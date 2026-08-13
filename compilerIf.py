import ast
from ast import *
from utils import *
from x86_ast import *
import os
from typing import List, Tuple, Set, Dict
from graph import *
from priority_queue import *

from compilerVar import CompilerVar

Binding = Tuple[Name, expr]
Temporaries = List[Binding]

class CompilerIf(CompilerVar):

    ###############################################################
    ######## Partial Eval
    ###############################################################

    def pe_neg(self, e: expr) -> expr:
        return super().pe_neg(e)

    def pe_add(self, e1: expr, e2: expr) -> expr:
        return super().pe_add(e1, e2)

    def pe_sub(self, e1: expr, e2: expr) -> expr:
        return super().pe_sub(e1, e2)

    def pe_exp(self, e: expr, env: Set[expr]) -> expr:
        match e:
            case BoolOp(op, values):
                return BoolOp(op, [self.pe_exp(values[0], env), self.pe_exp(values[1], env)])
                # return BoolOp(op, [self.pe_exp(arg1, env), self.pe_exp(arg2, env)])
            case UnaryOp(Not(), operand):
                match operand:
                    case Constant(True):
                        return Constant(False)
                    case Constant(False):
                        return Constant(True)
                    case _:
                        return UnaryOp(Not(), self.pe_exp(operand, env))
            case Compare(arg1, [cmp], arg2):
                return Compare(self.pe_exp(arg1, env), [cmp], [self.pe_exp(e, env) for e in arg2])
            case IfExp(arg1, arg2, arg3):
                return IfExp(self.pe_exp(arg1, env), self.pe_exp(arg2, env), self.pe_exp(arg3, env))
            case _:
                return super().pe_exp(e, env)
                
    def pe_stmt(self, s: statement, env: Set[expr]) -> expr:
        match s:
            case If(exp1, stmt1, stmt2):
                stmts1 = [self.pe_stmt(st, env) for st in stmt1]
                stmts2 = [self.pe_stmt(st, env) for st in stmt2]
                return If(self.pe_exp(exp1, env), stmts1, stmts2)
            case _:
                return super().pe_stmt(s, env)

    def partial_eval(self, p: Module) -> Module:
        match p:
            case Module(body):
                newBody = [self.pe_stmt(s, {}) for s in body]
                return Module(newBody)
            case _:
                return super().partial_eval(p)

    ###############################################################
    ######## Shrink
    ###############################################################

    def shrink_exp(self, e: exp) -> exp:
        match e:
            case Constant(value):
                return e
            case Name(id):
                return e
            case Call(Name('input_int'),[]):
                return e
            case UnaryOp(op, operand):
                return UnaryOp(op, self.shrink_exp(operand))
            case BinOp(left, op, right):
                return BinOp(self.shrink_exp(left), op, self.shrink_exp(right))
            case BoolOp(op, [arg1, arg2]):
                if isinstance(op, And):
                    return IfExp(self.shrink_exp(arg1), self.shrink_exp(arg2), Constant(False))
                elif isinstance(op, Or):
                    return IfExp(self.shrink_exp(arg1), Constant(True), self.shrink_exp(arg2))
                else:
                    raise Exception ('error in boolop match, unexpected + ', repr(op))
                return BoolOp(boolop, [self.shrink_exp(arg1), self.shrink_exp(arg1)])
            case Compare(arg1, [cmp], arg2):
                return Compare(self.shrink_exp(arg1), [cmp], [self.shrink_exp(e) for e in arg2])
            case IfExp(arg1, arg2, arg3):
                return IfExp(self.shrink_exp(arg1), self.shrink_exp(arg2), self.shrink_exp(arg3))
            case _:
                raise Exception ('error in shrink_exp, unexpected + ', repr(e))

    def shrink_stmt(self, s: stmt) -> stmt:
        match s:
            case Expr(Call(Name('print'), [arg])):
                return Expr(Call(Name('print'), [self.shrink_exp(arg)]))
            case Expr(arg):
                return Expr(self.shrink_exp(arg))
            case Assign([Name(var)], arg):
                return Assign([Name(var)], self.shrink_exp(arg))
            case If(exp1, stmt1, stmt2):
                stmts1 = [self.shrink_stmt(s) for s in stmt1]
                stmts2 = [self.shrink_stmt(s) for s in stmt2]
                return If(self.shrink_exp(exp1), stmts1, stmts2)

    def shrink(self, p: Module) -> Module:
        match p:
            case Module(body):
                stmts = [self.shrink_stmt(stmt) for stmt in body]
                return Module(stmts)
            case _:
                raise Exception ('error in shrink + ', repr(p))

    ###############################################################
    ######## Reduce Complex Operands
    ###############################################################

    def rco_exp(self, e: expr, need_atomic : bool) -> Tuple[expr, Temporaries]:
        match e:
            case Compare(arg1, [cmp], arg2):
                (newVar, varMap) = self.rco_exp(arg1, True)
                rhsVars = []
                rhsMaps = []
                for e in arg2:
                    (v, M) = self.rco_exp(e, True)
                    rhsVars.append(v)
                    rhsMaps += M
                if need_atomic:
                    newTemp = Name(generate_name('tmp'))
                    return newTemp, varMap + rhsMaps + [Assign([newTemp], Compare(newVar, [cmp], rhsVars))]
                else:
                    return Compare(newVar, [cmp], rhsVars), varMap + rhsMaps
            case IfExp(arg1, arg2, arg3):
                (newVar1, newMap1) = self.rco_exp(arg1, False)
                (newVar2, newMap2) = self.rco_exp(arg2, False)
                (newVar3, newMap3) = self.rco_exp(arg3, False)
                newArg2 = Begin(newMap2, newVar2)
                newArg3 = Begin(newMap3, newVar3)
                if need_atomic:
                    newTemp = Name(generate_name('tmp'))
                    return newTemp, newMap1 + [Assign([newTemp], IfExp(newVar1, newArg2, newArg3))]
                else:
                    return IfExp(newVar1, newArg2, newArg3), newMap1
            case Begin(stmts, exp):
                ss = [self.rco_stmt(s) for s in stmts]
                ss = sum(ss, [])
                (newVar, varMap) = self.rco_exp(exp, False)
                if need_atomic:
                    newTemp = Name(generate_name('tmp'))
                    return newTemp, varMap + [Assign([newTemp], Begin(ss, newVar))]
                else:
                    return Begin(ss, newVar), varMap
            case _:
                return super().rco_exp(e, need_atomic)

    def rco_stmt(self, s: stmt) -> List[stmt]:
        match s:
            case If(exp1, stmt1, stmt2):
                stmts1 = sum([self.rco_stmt(s) for s in stmt1], [])
                stmts2 = sum([self.rco_stmt(s) for s in stmt2], [])
                (newVar, varMap) = self.rco_exp(exp1, False)
                return varMap + [If(newVar, stmts1, stmts2)]
            case _:
                return super().rco_stmt(s)

    def remove_complex_operands(self, p: Module) -> Module:
        match p:
            case Module(body):
                stmts = [self.rco_stmt(s) for s in body]
                return Module(sum(stmts, []))
            case _:
                raise Exception ('error in remove_complex_operands + ', repr(p))

    ###############################################################
    ######## Explicate Control
    ###############################################################

    def create_block(self, promise: Promise | List[stmt], basic_blocks: Dict[str, List[stmt]]) -> Promise:
        def delay():
            stmts = force(promise)
            match stmts:
                case [Goto(l)]:
                    return [Goto(l)]
                case _:
                    label = label_name(generate_name('block'))
                    basic_blocks[label] = stmts
                    return [Goto(label)]
        return Promise(delay)

    def explicate_effect(self, e: expr, cont: Promise | List[stmt], basic_blocks: Dict[str, List[stmt]]) -> Promise | List[stmt]:
        match e:
            case IfExp(test, body, orelse):
                newBody = self.explicate_effect(body, cont, basic_blocks)
                newElse = self.explicate_effect(orelse, cont, basic_blocks)
                newExpr = self.explicate_pred(test, newBody, newElse, basic_blocks)
                return newExpr
            case Call(func, args):
                block = self.create_block([Expr(e)] + force(cont), basic_blocks)
                return block
            case Begin(body, result):
                # cont_block = self.create_block(cont, basic_blocks)
                # newBody = []
                # for s in reversed(body):
                #     newBody = self.explicate_stmt(s, newBody, basic_blocks)
                # return newBody + force(cont_block)
                ss = self.explicate_effect(result, cont, basic_blocks)
                for s in reversed(body):
                    ss = self.explicate_stmts(s, ss, basic_blocks)
                return ss
            case _:
                return cont
    
    def explicate_assign(self, rhs: List[expr], lhs: expr, cont: List[expr], basic_blocks: Dict[str, List[stmt]]) -> Promise | List[stmt]:
        match rhs:
            case IfExp(test, body, orelse):
                next_block = self.create_block(cont, basic_blocks)
                newBody = self.explicate_assign(body, lhs, next_block, basic_blocks)
                newElse = self.explicate_assign(orelse, lhs, next_block, basic_blocks)
                newRhs = self.explicate_pred(test, newBody, newElse, basic_blocks)
                return newRhs
            case Begin(body, result):
                ss = self.explicate_assign(result, lhs, cont, basic_blocks)
                for s in reversed(body):
                    ss = self.explicate_stmt(s, ss, basic_blocks)
                return ss
            # case Begin(body, result):
            #     next_block = self.create_block(cont, basic_blocks)
            #     newBody = []
            #     for s in reversed(body):
            #         newBody = self.explicate_stmt(s, newBody, basic_blocks)
            #     match result:
            #         case IfExp(test, body, orelse):
            #             newThen = self.explicate_assign(body, lhs, next_block, basic_blocks)
            #             newElse = self.explicate_assign(orelse, lhs, next_block, basic_blocks)
            #             newRhs = self.explicate_pred(test, newThen, newElse, basic_blocks)
            #             return newBody + force(newRhs) # todo
            #         case _:
            #             return newBody + [Assign([lhs], result)] + force(next_block)
            case _:
                return [Assign([lhs], rhs)] + force(cont) # todo
    
    def explicate_pred(self, cnd: expr, thn: List[stmt], els: List[stmt], basic_blocks: Dict[str, List[stmt]]) -> List[stmt]:
        match cnd:
            case Compare(left, [op], [right]):
                goto_thn = self.create_block(thn, basic_blocks)
                goto_els = self.create_block(els, basic_blocks)
                return [If(cnd, force(goto_thn), force(goto_els))]
            case Constant(True):
                return thn;
            case Constant(False):
                return els;
            case UnaryOp(Not(), operand):
                return [If(Compare(operand, [Eq()], [Constant(False)]),
                    force(self.create_block(thn, basic_blocks)),
                    force(self.create_block(els, basic_blocks)))]
            case IfExp(test, body, orelse):
                thn_block = self.create_block(thn, basic_blocks)
                els_block = self.create_block(els, basic_blocks)
                newBody = self.explicate_pred(body, thn_block, els_block, basic_blocks)
                newElse = self.explicate_pred(orelse, thn_block, els_block, basic_blocks)
                newPred = self.explicate_pred(test, newBody, newElse, basic_blocks)
                return newPred
            case Begin(body, result):
                newBody = []
                for s in reversed(body):
                    newBody = self.explicate_stmt(s, newBody, basic_blocks)
                newPred = self.explicate_pred(result, thn, els, basic_blocks)
                return newBody + force(newPred) # todo
            case _:
                return [If(Compare(cnd, [Eq()], [Constant(True)]),
                    force(self.create_block(thn, basic_blocks)),
                    force(self.create_block(els, basic_blocks)))]
    
    def explicate_stmt(self, s: stmt, cont: List[stmt], basic_blocks: Dict[str, List[stmt]]) -> List[stmt]:
        match s:
            case Assign([lhs], rhs):
                return self.explicate_assign(rhs, lhs, cont, basic_blocks)
            case Expr(value):
                return self.explicate_effect(value, cont, basic_blocks)
            case If(test, body, orelse):
                cont_block = self.create_block(cont, basic_blocks)
                newBody = cont_block
                for s in reversed(body):
                    newBody = self.explicate_stmt(s, newBody, basic_blocks)
                newElse = cont_block
                for s in reversed(orelse):
                    newElse = self.explicate_stmt(s, newElse, basic_blocks)
                newStmt = self.explicate_pred(test, newBody, newElse, basic_blocks)
                return newStmt
            case _:
                raise Exception ('error in explicate_stmt + ', repr(s))
    
    def explicate_control(self, p: Module) -> CProgram:
        match p:
            case Module(body):
                new_body = [Return(Constant(0))]
                basic_blocks = {}
                for s in reversed(body):
                    new_body = self.explicate_stmt(s, new_body, basic_blocks)
                basic_blocks[label_name('start')] = force(new_body)
                temp = CProgram(basic_blocks)
                temp = self.remove_orphans(temp)
                return temp
            case _:
                raise Exception ('error in explicate_control + ', repr(p))

    ###############################################################
    ######## Remove Orphans
    ###############################################################

    block_parent_dict = {}
    block_child_dict = {}

    def count_parents(self, label: str, stmts: List[instr]):
        for s in stmts:
            match s:
                case Goto(l):
                    self.block_parent_dict[l] += [label]
                    self.block_child_dict[label] += [l]
                case If(cmp, [Goto(l1)], [Goto(l2)]):
                    self.block_parent_dict[l1] += [label]
                    self.block_child_dict[label] += [l1]
                    self.block_parent_dict[l2] += [label]
                    self.block_child_dict[label] += [l2]
                case _:
                    continue

    def remove_orphans(self, p: CProgram) -> CProgram:
        match p:
            case CProgram(blocks):
                self.block_parent_dict = {}
                self.block_child_dict = {}
                for (block, ss) in blocks.items():
                    self.block_parent_dict[block] = []
                    self.block_child_dict[block] = []
                    self.count_parents(block, ss)
                orphans = []
                for block in blocks:
                    if (len(self.block_parent_dict[block]) == 0 and block != 'start'):
                        orphans += [block]
                for block in orphans:
                    blocks.pop(block)
                    for c in self.block_child_dict[block]:
                        self.block_parent_dict[c].remove(block)
                return CProgram(blocks)

    ###############################################################
    ######## Remove Jumps
    ###############################################################

    def count_parents_86(self, label: str, stmts: List[instr]):
        for s in stmts:
            match s:
                case Jump(l):
                    self.block_parent_dict[l] += [label]
                    self.block_child_dict[label] += [l]
                case JumpIf(cc, l):
                    self.block_parent_dict[l] += [label]
                    self.block_child_dict[label] += [l]
                case _:
                    continue

    def merge_blocks(self, child_label: str, parent: List[instr], child: List[instr]) -> List[instr]:
        returnList = []
        for i in parent:
            match i:
                case JumpIf(cc, loc):
                    if loc == child_label:
                        returnList += child
                case Jump(loc):
                    if loc == child_label:
                        returnList += child
                case _:
                    returnList.append(i)
        return returnList

    def remove_jumps(self, p: X86Program) -> X86Program:
        match p:
            case X86Program(blocks):
                self.block_parent_dict = {}
                self.block_child_dict = {}
                self.block_parent_dict['conclusion'] = []
                for (block, ss) in blocks.items():
                    self.block_parent_dict[block] = []
                    self.block_child_dict[block] = []
                    self.count_parents_86(block, ss)
                graph = DirectedAdjList()
                for (label, ss) in blocks.items():
                    for s in ss:
                        match s:
                            case Goto(arg):
                                graph.add_edge(label, arg)
                            case _:
                                continue
                graph = transpose(graph)
                block_list = topological_sort(graph)
                for label in block_list:
                    if label == 'start' or label == 'conclusion':
                        continue
                    ss = blocks[label]
                    if len(self.block_parent_dict[label]) == 0:
                        blocks.pop(label)
                    elif len(self.block_parent_dict[label]) == 1:
                        parent = self.block_parent_dict[label][0]
                        blocks[parent] = self.merge_blocks(label, blocks[parent], ss)
                    blocks.pop(label)
                return X86Program(blocks)

    ###############################################################
    ######## Select Instructions
    ###############################################################

    def select_arg(self, e: expr) -> arg:
        match e:
            case Constant(True):
                return Immediate(1)
            case Constant(False):
                return Immediate(0)
            case _:
                return super().select_arg(e)

    def select_op(self, op: operator) -> str:
        match op:
            case Eq():
                return 'sete'
            case NotEq():
                return 'setne'
            case Lt():
                return 'setl'
            case LtE():
                return 'setle'
            case Gt():
                return 'setg'
            case GtE():
                return 'setge'
            case _:
                return super().select_op(op)

    def select_jump(self, op: operator) -> str:
        match op:
            case Eq():
                return 'e'
            case NotEq():
                return 'ne'
            case Lt():
                return 'l'
            case LtE():
                return 'le'
            case Gt():
                return 'g'
            case GtE():
                return 'ge'
            case _:
                raise Exception ('error in select_jump + ', repr(op))

    def select_stmt(self, s: stmt) -> List[instr]:
        match s:
            case Assign([Name(id)], Compare(atm1, [cmp], [atm2])):
                return [Instr('cmpq', [self.select_arg(atm2), self.select_arg(atm1)]),
                        Instr(self.select_op(cmp), [ByteReg('al')]),
                        Instr('movzbq', [ByteReg('al'), self.select_arg(Name(id))])]
            case Assign([Name(id)], UnaryOp(Not(), value)):
                return [Instr('movq', [self.select_arg(value), self.select_arg(Name(id))]),
                        Instr('xorq', [Immediate(1), self.select_arg(Name(id))])]
            case Return(Constant(value)):
                return [Instr('movq', [Immediate(value), Reg('rax')]),
                        Jump(label_name('conclusion'))]
            case Goto(label):
                return [Jump(label)]
            case If(Compare(atm1, [op], [atm2]), [Goto(label1)], [Goto(label2)]):
                return [Instr('cmpq', [self.select_arg(atm2), self.select_arg(atm1)]),
                        JumpIf(self.select_jump(op), label1),
                        Jump(label2)]
            case _:
                return super().select_stmt(s)

    def select_instructions(self, p: Module) -> X86Program:
        match p:
            case CProgram(blocks):
                block_dict = {}
                for (label, ss) in blocks.items():
                    block_dict[label] = []
                    for s in ss:
                        instructions = self.select_stmt(s)
                        block_dict[label] += instructions
                temp = X86Program(block_dict)
                temp = self.remove_jumps(temp)
                return temp
            case _:
                raise Exception ('error in select_intructions + ', repr(p))

    ############################################################################
    # Liveness Analysis (Occurs after Select Instructions)
    ############################################################################

    param_registers = [Reg('rdi'), Reg('rsi'), Reg('rdx'), Reg('rcx'), Reg('r8'), Reg('r9')]
    caller_saved_registers = [Reg('rax'), Reg('rcx'), Reg('rdx'), Reg('rsi'), Reg('rdi'), Reg('r8'), Reg('r9'), Reg('r10'), Reg('r11')]
    callee_saved_registers = [Reg('rsp'), Reg('rbp'), Reg('rbx'), Reg('r12'), Reg('r13'), Reg('r14'), Reg('r15')]

    registers = set(caller_saved_registers + callee_saved_registers)

    live_before_dict = {}

    def getLoc(self, param) -> Set[location]:
        match param:
            case ByteReg(s):
                return {param}
            case _:
                return super().getLoc(param)

    def R(self, i: instr) -> Set[location]:
        match i:
            case Instr('movzbq', arg):
                return self.getLoc(arg[0])
            case Instr('cmpq', arg):
                return self.getLoc(arg[0]) | self.getLoc(arg[1])
            case Instr('sete', arg):
                return set()
            case Instr('setne', arg):
                return set()
            case Instr('setle', arg):
                return set()
            case Instr('setl', arg):
                return set()
            case Instr('setge', arg):
                return set()
            case Instr('setg', arg):
                return set()
            case _:
                return super().R(i)

    def W(self, i: instr) -> Set[location]:
        match i:
            case Instr('movzbq', arg):
                return self.getLoc(arg[1])
            case Instr('cmpq', args):
                return set()
            case Instr('sete', arg):
                return self.getLoc(arg[0])
            case Instr('setne', arg):
                return self.getLoc(arg[0])
            case Instr('setle', arg):
                return self.getLoc(arg[0])
            case Instr('setl', arg):
                return self.getLoc(arg[0])
            case Instr('setge', arg):
                return self.getLoc(arg[0])
            case Instr('setg', arg):
                return self.getLoc(arg[0])
            case _:
                return super().W(i)

    def getBeforeAfter(self, i: instr, prev_before):
        curr_after = prev_before
        curr_before = (curr_after - self.W(i)) | self.R(i) # - is set difference, | is union
        return [curr_before, curr_after]

    def uncover_live(self, p: X86Program) -> Dict[instr : Set[location]]:
        match p:
            case X86Program(blocks):
                graph = DirectedAdjList()
                for (label, ss) in blocks.items():
                    for s in ss:
                        match s:
                            case JumpIf(cc, arg):
                                graph.add_edge(label, arg)
                            case Jump(arg):
                                graph.add_edge(label, arg)
                            case _:
                                continue
                graph = transpose(graph)
                block_list = topological_sort(graph)
                returnDict = {}
                for block in block_list:
                    if block == 'conclusion':
                        self.live_before_dict[block] = set()
                        continue
                    i_before = set()
                    for i in range(len(blocks[block]) - 1, -1, -1):
                        match blocks[block][i]:
                            case Jump(arg):
                                i_after = self.live_before_dict[arg]
                                i_before = i_after
                            case JumpIf(cc, arg):
                                i_before = i_before | self.live_before_dict[arg]
                                i_after = i_before
                            case _:
                                i_before, i_after = self.getBeforeAfter (blocks[block][i], i_before)
                        if (i == 0):
                            self.live_before_dict[block] = i_before
                        returnDict.update({blocks[block][i] : i_after})
                return returnDict
            case _:
                raise Exception ('error in uncover_live + ', repr(p))

    ############################################################################
    # Build Interference graph
    ############################################################################

    def add_edges(self, i: instr, graph: UndirectedAdjList, afterSet: Set[location]):
        match i:
            case Instr('movq', args):
                for v in afterSet:
                    if v != args[0] and v != args[1]:
                        graph.add_edge(args[1], v)
            case Instr('movzbq', args):
                for v in afterSet:
                    if v != args[0] and v != args[1]:
                        graph.add_edge(args[1], v)
            case Instr(op, args):
                for d in self.W(i):
                    for v in afterSet:
                        if v != d:
                            graph.add_edge(d,v)
            case Callq(func, arity):
                for d in self.W(i):
                    for v in afterSet:
                        if v != d:
                            graph.add_edge(d,v)
            case Jump(loc):
                return
            case JumpIf(cc, loc):
                return
            case _:
                raise Exception ('error in add_edges + ', repr(i))

    def add_ver(self, i: instr, graph: UnidrectedAdjList):
        match i:
            case Instr(op, args):
                for arg in args:
                    if isinstance(arg, Variable) and arg not in graph.vertices():
                        graph.add_vertex(arg)
            case _:
                return

    def build_interference(self, p: X86Program, afterDict: Dict[instr: Set[location]]) -> UndirectedAdjList:
        match p:
            case X86Program(blocks):
                graph = UndirectedAdjList()
                for (label, ss) in blocks.items():
                    for i in ss:
                        self.add_edges(i, graph, afterDict[i])
                    for i in ss:
                        self.add_ver(i, graph)
                return graph
            case _:
                raise Exception ('error in build interference + ', repr(p))

    ############################################################################
    # Graph Coloring
    ############################################################################

    colToReg = {-5:'r15',-4:'r11',-3:'rbp',-2:'rsp',-1:'rax',0:'rcx',1:'rdx',2:'rsi',3:'rdi',4:'r8',
                5:'r9',6:'r10',7:'rbx',8:'r12',9:'r13',10:'r14'}
    regToCol = {'r15':-5,'r11':-4,'rbp':-3,'rsp':-2,'rax':-1,'rcx':0,'rdx':1,'rsi':2,'rdi':3,'r8':4,
                'r9':5,'r10':6,'rbx':7,'r12':8,'r13':9,'r14':10}

    def has_colored_neighbor(self, node, sat, move_graph, colors):
        for u in move_graph.adjacent(node):
            if u in colors and colors[u] not in sat[u]:
                return True
        return False

    def color_graph(self, graph: UndirectedAdjList, move_graph: UndirectedAdjList) -> Dict[Variable : int]:
        L = {}
        sat = {}
        returnDict = {}
        for v in graph.vertices():
            L.update({v : 0})
            sat.update({v : []})
        for v in graph.vertices():
            if v in self.registers:
                returnDict.update({v : self.regToCol[v.id]})
                for u in graph.adjacent(v):
                    if self.regToCol[v.id] < 0:
                        continue
                    sat[u].append(self.regToCol[v.id])
                    L[u] += 1
        def comp(x, y):
            return L[x.key] < L[y.key]
        pq = PriorityQueue(comp)
        for k,v in L.items():
            pq.push(k)
        while(not pq.empty()):
            potential = []
            limit = L[pq.top()]
            while (not pq.empty() and L[pq.top()] == limit):
                potential.append(pq.pop())
            node = None
            for i in range(len(potential)):
                if i == len(potential) - 1:
                    node = potential[i]
                elif potential[i] not in self.registers and self.has_colored_neighbor(potential[i], sat, move_graph, returnDict):
                    node = potential[i]
                    break
                continue
            for n in potential:
                if n != node:
                    pq.push(n)
            if node in self.registers:
                continue
            # assign next available color (update the return dictionary)
            # check move neighbors to see if they are already colored
            # if the min number is less than 11, choose that color
            # if it is greater than 11,
            # then increment until we find the next available color
            # if that color is greater than 11, then choose the color of the move neighbor
            # else choose that color
            potential_col = float('inf')
            for u in move_graph.adjacent(node):
                if u in returnDict:
                    potential_col = min(potential_col, returnDict[u])
            i = 0
            if potential_col < 11 and potential_col not in sat[node]:
                returnDict.update({node : potential_col})
            else:
                while i in sat[node]:
                    i += 1
                if i >= 11 and potential_col < float('inf'):
                    returnDict.update({node : potential_col})
                else:
                    returnDict.update({node : i})
            # add saturation
            for u in graph.adjacent(node):
                sat[u].append(returnDict[node])
                L[u] += 1
                pq.increase_key(u)
        # return dictionary
        return returnDict
    
    def allocate_registers(self, colors: Dict[Variable : int]):
        returnDict = {}
        for k,v in colors.items():
            if v < 11:
                returnDict.update({k : Reg(self.colToReg[v])})
            else:
                loc = -8 - 8*(v - 11)
                returnDict.update({k : Deref('rbp', loc)})
        return returnDict

    ############################################################################
    # Move Biasing
    ############################################################################

    def detect_move(self, i: instr, graph: UndirectedAdjList):
        match i:
            case Instr('movq', [arg1, arg2]):
                if arg1 != arg2 and isinstance(arg1, Variable) and isinstance(arg2, Variable):
                    graph.add_edge(arg1, arg2)
            case _:
                return

    def build_move_graph(self, p:X86program) -> UndirectedAdjList:
        match p:
            case X86Program(blocks):
                graph = UndirectedAdjList()
                for (label, ss) in blocks.items():
                    for i in ss:
                        self.detect_move(i, graph)
                return graph
            case _:
                raise Exceptions ('error in build_move_graph + ', repr(p))

    ###############################################################
    ######## Assign Homes
    ###############################################################

    def assign_homes_arg(self, a: arg, home: Dict[Variable, arg]) -> arg:
        match a:
            case Immediate(value):
                return a
            case Reg(id):
                return a
            case Variable(id):
                return home[a]
            case Deref(loc, offset):
                return a
            case _:
                raise Exception ('error in assign_homes_arg + ', repr(a))

    def assign_homes_instr(self, i: instr,
                           home: Dict[Variable, arg]) -> instr:
        match i:
            case Instr(operation, (arg1, arg2)):
                return Instr(operation, (self.assign_homes_arg(arg1, home), self.assign_homes_arg(arg2, home)))
            case Instr(operation, (arg, )):
                return Instr(operation, (self.assign_homes_arg(arg, home),))
            case Callq(func, arity):
                return i
            case Jump(loc):
                return i
            case JumpIf(cc, loc):
                return i
            case _:
                raise Exception ('error in assign_homes_instr + ', repr(i))

    def assign_homes(self, p: X86Program) -> X86Program:
        match p:
            case X86Program(blocks):
                live_sets = self.uncover_live(p)
                interference_graph = self.build_interference(p, live_sets)
                move_graph = self.build_move_graph(p)
                colors = self.color_graph(interference_graph, move_graph)
                locations = self.allocate_registers(colors)
                blocks = p.body
                newBlocks = {}
                for (label, ss) in blocks.items():
                    newInstr = []
                    for i in ss:
                        newInstr.append(self.assign_homes_instr(i, locations))
                    newBlocks[label] = newInstr
                return X86Program(newBlocks)
            case _:
                raise Exception ('error in assign_homes + ', repr(p))

    ###############################################################
    ######## Patch Instructions
    ###############################################################

    def patch_instr(self, i: instr) -> List[instr]:
        match i:
            case Instr('movzbq', (al, Deref(reg2, offset2))):
                return [Instr('movzbq', [al, Reg('rax')]),
                        Instr('movq', [Reg('rax'), Deref(reg2, offset2)])]
            case Instr('cmpq', (arg1, Immediate(value))):
                return [Instr('movq', [Immediate(value), Reg('rax')]),
                        Instr('cmpq', [arg1, Reg('rax')])]
            case Instr('cmpq', (Deref(reg1, offset1), Deref(reg2, offset2))):
                return [Instr('movq', [Deref(reg1, offset1), Reg('rax')]),
                        Instr('cmpq', [Reg('rax'), Deref(reg2, offset2)])]
            case Jump(loc):
                return [i]
            case JumpIf(cc, loc):
                return [i]
            case _:
                return super().patch_instr(i)

    def patch_instructions(self, p: X86Program) -> X86Program:
        match p:
            case X86Program(blocks):
                newBlocks = {}
                for (label, ss) in blocks.items():
                    newInstr = []
                    for i in ss:
                        newInstr.append(self.patch_instr(i)) 
                    newInstr = sum(newInstr, [])
                    newBlocks[label] = newInstr
                return X86Program(newBlocks)
            case _:
                raise Exception ('error in patch_instructions + ', repr(p))

    ############################################################################
    # Find Stackframe size
    ############################################################################

    def in_callee(self, callee_used, arg):
        if arg in self.callee_saved_registers:
            callee_used.add(arg)

    def in_stack(self, stack_used, arg):
        if isinstance(arg, Deref):
            stack_used.add(arg)

    def locations_used(self, p: X86Program):
        p.s = set()
        p.c = set()
        for (label, ss) in p.body.items():
            for i in ss:
                match i:
                    case Callq(fun, arity):
                        continue
                    case Instr(operation, (arg1, arg2)):
                        self.in_callee(p.c, arg1)
                        self.in_callee(p.c, arg2)
                        self.in_stack(p.s, arg1)
                        self.in_stack(p.s, arg2)
                    case Instr(operation, (arg, )):
                        self.in_callee(p.c, arg)
                        self.in_stack(p.s, arg)
                    case Jump(loc):
                        continue
                    case JumpIf(cc, loc):
                        continue
                    case _:
                        raise Exception ('error in patch_instr')


    ###############################################################
    ######## Prelude and Conclusion
    ###############################################################

    def prelude_and_conclusion(self, p: X86Program) -> X86Program:
        match p:
            case X86Program(blocks):
                self.locations_used(p)
                callee_reg = list(p.c)
                addStack = [Instr('pushq', [loc]) for loc in callee_reg]
                removeStack = [Instr('popq', [loc]) for loc in reversed(callee_reg)]
                p.stack_space = align(8*len(p.s) + 8*len(p.c), 16) - 8*len(p.c)
                pre_stmts = addStack + [Instr('pushq', [Reg('rbp')]),
                          Instr('movq', [Reg('rsp'), Reg('rbp')]),
                          Instr('subq', [Immediate(p.stack_space), Reg('rsp')]),
                          Jump('start')]
                con_stmts = [Instr('addq', [Immediate(p.stack_space), Reg('rsp')]),
                                   Instr('popq', [Reg('rbp')])] + removeStack + [Instr('retq', [])]
                blocks['main'] = pre_stmts
                blocks['conclusion'] = con_stmts
                return p
            case _:
                raise Exception ('error in prelude_and_conclusion + ', repr(p))

