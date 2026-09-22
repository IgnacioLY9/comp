import ast
from ast import *
from utils import *
from x86_ast import *
from graph import *
from priority_queue import *
from dataflow_analysis import *
import os
from typing import List, Set, Dict
from typing import Tuple as Tup

from compilerWhile import CompilerWhile

Binding = Tup[Name, expr]
Temporaries = List[Binding]

class CompilerTup(CompilerWhile):

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
            case Tuple(exp, Load()):
                es = [self.pe_exp(e, env) for e in exp]
                return Tuple(es, Load())
            case Subscript(exp, idx, Load()):
                return Subscript(self.pe_exp(exp, env), idx, Load())
            case Call(Name('len'), [exp]):
                return Call(Name('len'), [self.pe_exp(exp, env)])
            case _:
                return super().pe_exp(e, env)
                
    def pe_stmt(self, s: stmt, env: Set[expr]) -> expr:
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

    def shrink_exp(self, e: expr) -> expr:
        match e:
            case Tuple(exp, Load()):
                es = [self.shrink_exp(e) for e in exp]
                return Tuple(es, Load())
            case Subscript(exp, idx, Load()):
                return Subscript(self.shrink_exp(exp), idx, Load())
            case Call(Name('len'), [exp]):
                return Call(Name('len'), [self.shrink_exp(exp)])
            case _:
                return super().shrink_exp(e)

    def shrink_stmt(self, s: stmt) -> stmt:
        return super().shrink_stmt(s)

    def shrink(self, p: Module) -> Module:
        match p:
            case Module(body):
                stmts = [self.shrink_stmt(stmt) for stmt in body]
                return Module(stmts)
            case _:
                raise Exception ('error in shrink + ', repr(p))

    ###############################################################
    ######## Expose Allocation
    ###############################################################

    def expose_alloc(self, tup: List[expr], alloc: Allocate) -> expr:
        l = len(tup)
        space = (l + 1) * 8
        arr = generate_name('alloc')
        init_vars = [generate_name('init') for t in tup]
        inits = []
        for i in range(l):
            inits += [Assign([Name(init_vars[i])], tup[i])]
        conditional = Compare(BinOp(GlobalValue('free_ptr'), Add(), Constant(space)),[Lt()], [GlobalValue('fromspace_end')])
        initialize = [Assign([Name(arr)], alloc)]
        assignment = []
        for i in range(l):
            assignment += [Assign([Subscript(Name(arr), Constant(i), Store())], Name(init_vars[i]))]
        body = inits + [If(conditional, [], [Collect(space)])] + initialize + assignment
        return Begin(body, Name(arr))

    def expose_exp(self, e: expr) -> expr:
        match e:
            case Name(id):
                return e
            case Constant(value):
                return e
            case BinOp(arg1, op, arg2):
                return BinOp(self.expose_exp(arg1), op, self.expose_exp(arg2))
            case UnaryOp(op, arg):
                return UnaryOp(op, self.expose_exp(arg))
            case Call(Name(func), args):
                return Call(Name(func), [self.expose_exp(ex) for ex in args])
            case IfExp(arg1, arg2, arg3):
                return IfExp(self.expose_exp(arg1), self.expose_exp(arg2), self.expose_exp(arg3))
            case Begin(body, result):
                return Begin([self.expose_stmt(s) for s in body], self.expose_exp(result))
            case Compare(arg1, cmp, arg2):
                return Compare(self.expose_exp(arg1), cmp, [self.expose_exp(s) for s in arg2])
            case Tuple(arg, Load()):
                new_body = [self.expose_exp(ex) for ex in arg]
                alloc = Allocate(len(new_body), e.has_type)
                return self.expose_alloc(new_body, alloc)
            case Subscript(arg, idx, Load()):
                return Subscript(self.expose_exp(arg), self.expose_exp(idx), Load())
            case _:
                raise Exception ('error in expose_arg + ', repr(e))

    def expose_stmt(self, s: stmt) -> stmt:
        match s:
            case Expr(exp):
                return Expr(self.expose_exp(exp))
            case If(arg1, arg2, arg3):
                return If(self.expose_exp(arg1), [self.expose_stmt(s) for s in arg2], [self.expose_stmt(s) for s in arg3])
            case While(arg1, arg2, []):
                return While(self.expose_exp(arg1), [self.expose_stmt(s) for s in arg2], [])
            case Assign(lhs, rhs):
                return Assign(lhs, self.expose_exp(rhs))
            case _:
                raise Exception ('error in expose_stmt + ', repr(s))

    def expose_allocation(self, p: Module) -> Module:
        match p:
            case Module(body):
                stmts = [self.expose_stmt(s) for s in body]
                return Module(stmts)
            case _:
                raise Exception ('error in expose allocation + ', repr(p))

    ###############################################################
    ######## Reduce Complex Operands
    ###############################################################

    def rco_exp(self, e: expr, need_atomic : bool) -> Tup[expr, Temporaries]:
        match e:
            case GlobalValue(value):
                return e, []
            case Subscript(arg1, arg2, Load()):
                newVar1, newMap1 = self.rco_exp(arg1, True)
                newVar2, newMap2 = self.rco_exp(arg2, True)
                if need_atomic:
                    temp = Name(generate_name('tmp'))
                    return temp, newMap1 + newMap2 + [Assign([temp], Subscript(newVar1, newVar2, Load()))]
                else:
                    return Subscript(newVar1, newVar2, Load()), newMap1 + newMap2
            case Call(Name('len'), [arg]):
                newVar, newMap = self.rco_exp(arg, True)
                newTemp = Name(generate_name('tmp'))
                return newTemp, [Assign([newTemp], Call(Name('len'),[newVar]))] + newMap
            case Allocate(arg1, t):
                if need_atomic:
                    temp = Name(generate_name('tmp'))
                    return temp, [Assign([temp], e)]
                else:
                    return e, []
            case _:
                return super().rco_exp(e, need_atomic)

    def rco_stmt(self, s: stmt) -> List[stmt]:
        match s:
            case Collect(value):
                return [s]
            case Assign([Subscript(arg1, arg2, Store())], arg3):
                newVar1, newMap1 = self.rco_exp(arg1, True)
                newVar3, newMap3 = self.rco_exp(arg3, True)
                return newMap1 + newMap3 + [Assign([Subscript(newVar1, arg2, Store())], newVar3)]
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
        return super().explicate_effect(e, cont, basic_blocks)

    def explicate_assign(self, rhs: List[expr], lhs: expr, cont: List[expr], basic_blocks: Dict[str, List[stmt]]) -> Promise | List[stmt]:
        return super().explicate_assign(rhs, lhs, cont, basic_blocks)

    def explicate_pred(self, cnd: expr, thn: List[stmt], els: List[stmt], basic_blocks: Dict[str, List[stmt]]) -> List[stmt]:
        match cnd:
            case Subscript(arg1, arg2, Load()):
                temp = Name(generate_name('tmp'))
                return [Assign([temp], cnd)] + force(self.explicate_pred(temp, thn, els, basic_blocks))
            case _:
                return super().explicate_pred(cnd, thn, els, basic_blocks)
    
    def explicate_stmt(self, s: stmt, cont: List[stmt], basic_blocks: Dict[str, List[stmt]]) -> List[stmt]:
        match s:
            case Collect(arg):
                cont_block = self.create_block(cont, basic_blocks)
                return [s] + force(cont_block)
            case _:
                return super().explicate_stmt(s, cont, basic_blocks)
    
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
                for (block, ss) in blocks.items():
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
        return super().count_parents_86(label, stmts)

    def merge_blocks(self, child_label: str, parent: List[instr], child: List[instr]) -> List[instr]:
        return super().merge_blocks()

    def remove_jumps(self, p: X86Program) -> X86Program:
        match p:
            case X86Program(blocks):
                self.block_parent_dict = {}
                self.block_child_dict = {}
                self.block_parent_dict['conclusion'] = []
                for (block, ss) in blocks.items():
                    self.block_parent_dict[block] = []
                    self.block_child_dict[block] = []
                for (block, ss) in blocks.items():
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
            case GlobalValue(value):
                return Global(label_name(value))
            case Subscript(arg1, arg2, Store()):
                return 8*(arg2 + 1)*(arg1)
            case _:
                return super().select_arg(e)

    def select_op(self, op: operator) -> str:
        match op:
            case Is():
                return 'sete'
            case _:
                return super().select_op(op)

    def select_jump(self, op: operator) -> str:
        match op:
            case Is():
                return 'e'
            case _:
                return super().select_jump(op)

    def isPointer(self, arg: TupleType) -> bool:
        match arg:
            case TupleType(t):
                return True
            case _:
                return False

    def select_stmt(self, s: stmt) -> List[instr]:
        match s:
            case Collect(value):
                return [Instr('movq', [Reg('r15'), Reg('rdi')]),
                        Instr('movq', [Immediate(value), Reg('rsi')]),
                        Callq(label_name('collect'), 2)]
            case Assign([Subscript(arg1, arg2, Store())], arg3):
                arg1 = self.select_arg(arg1)
                arg2 = self.select_arg(arg2).value
                arg3 = self.select_arg(arg3)
                return [Instr('movq', [arg1, Reg('r11')]),
                        Instr('movq', [arg3, Deref('r11', 8*(arg2 + 1))])]
            case Assign([arg1], Subscript(arg2, arg3, Load())):
                arg1 = self.select_arg(arg1)
                arg2 = self.select_arg(arg2)
                arg3 = self.select_arg(arg3).value
                return [Instr('movq', [arg2, Reg('r11')]),
                        Instr('movq', [Deref('r11', 8*(arg3 + 1)), arg1])]
            case Assign([arg1], Call(Name('len'), [arg2])):
                arg1 = self.select_arg(arg1)        
                arg2 = self.select_arg(arg2)
                return [Instr('movq', [arg2, Reg('rax')]), # put tuple in rax
                        Instr('movq', [Deref('rax', 0), Reg('rax')]), # dereference to load the actual bits in rax
                        Instr('andq', [Immediate(126), Reg('rax')]), # and with 126 to get just the bits that store size
                        Instr('sarq', [Immediate(1), Reg('rax')]), # shift right to get rid of the trailing 0 (used for garbage collection)
                        Instr('movq', [Reg('rax'), arg1])] # store length in arg2
            case Assign([arg1], Allocate(arg2, TupleType(types))):
                arg1 = self.select_arg(arg1)
                len = arg2
                type_tag = 0
                count = 7
                for t in types:
                    type_tag |= bool2int(self.isPointer(t)) << count
                    count += 1
                tag = type_tag | (len << 1) | 1
                return [Instr('movq', [Global(label_name('free_ptr')), Reg('r11')]),
                        Instr('addq', [Immediate(8 * (len + 1)), Global(label_name('free_ptr'))]),
                        Instr('movq', [Immediate(tag), Deref('r11', 0)]),
                        Instr('movq', [Reg('r11'), arg1])]
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
                temp.var_types = p.var_types
                return temp
            case _:
                raise Exception ('error in select_intructions + ', repr(p))

    ############################################################################
    # Liveness Analysis
    ############################################################################

    param_registers = [Reg('rdi'), Reg('rsi'), Reg('rdx'), Reg('rcx'), Reg('r8'), Reg('r9')]
    caller_saved_registers = [Reg('rax'), Reg('rcx'), Reg('rdx'), Reg('rsi'), Reg('rdi'), Reg('r8'), Reg('r9'), Reg('r10'), Reg('r11')]
    callee_saved_registers = [Reg('rsp'), Reg('rbp'), Reg('rbx'), Reg('r12'), Reg('r13'), Reg('r14'), Reg('r15')]

    registers = set(caller_saved_registers + callee_saved_registers)

    def getLoc(self, param) -> Set[location]:
        match param:
            case Global(value):
                return set()
            case _:
                return super().getLoc(param)

    def R(self, i: instr) -> Set[location]:
        match i:
            case Instr('andq', args):
                return self.getLoc(args[1])
            case Instr('sarq', args):
                return self.getLoc(args[1])
            case _:
                return super().R(i)

    def W(self, i: instr) -> Set[location]:
        match i:
            case Instr('andq', args):
                return self.getLoc(args[1])
            case Instr('sarq', args):
                return self.getLoc(args[1])
            case _:
                return super().W(i)

    def getBeforeAfter(self, i: instr, prev_before):
        curr_after = prev_before
        curr_before = (curr_after - self.W(i)) | self.R(i) # - is set difference, | is union
        return [curr_before, curr_after]

    def uncover_live(self, p: X86Program) -> Dict[instr, Set[location]]:
        match p:
            case X86Program(blocks):
                live_before_dict_block = {}
                live_after_dict_block = {}
                live_before_dict_i = {}
                live_after_dict_i = {}
                live_after_dict_block['conclusion'] = set()
                live_before_dict_block['conclusion'] = set()
                graph = DirectedAdjList()
                for (label, ss) in blocks.items():
                    live_before_dict_block[label] = set()
                    live_after_dict_block[label] = set()
                    for s in ss:
                        match s:
                            case JumpIf(cc, arg):
                                if arg == 'conclusion':
                                    continue
                                graph.add_edge(label, arg)
                            case Jump(arg):
                                if arg == 'conclusion':
                                    continue
                                graph.add_edge(label, arg)
                            case _:
                                continue
                graph = transpose(graph)

                def transfer(label, live_after_set):
                    i_before = set()
                    for i in range(len(blocks[label]) - 1, -1, -1):
                        match blocks[label][i]:
                            case Jump(arg):
                                i_after = live_before_dict_block[arg]
                                i_before = i_after
                            case JumpIf(cc, arg):
                                i_before = i_before | live_before_dict_block[arg]
                                i_after = i_before
                            case _:
                                i_before, i_after = self.getBeforeAfter (blocks[label][i], i_before)
                        if (i == 0):
                            live_before_dict_block[label] = i_before
                        live_before_dict_i.update({blocks[label][i] : i_before})
                        live_after_dict_i.update({blocks[label][i] : i_after})

                    return live_before_dict_block[label]

                analyze_dataflow(graph, transfer, set(), lambda x, y: x.union(y))

                return live_after_dict_i
            case _:
                raise Exception ('error in uncover_live + ', repr(p))

    ############################################################################
    # Build Interference graph
    ############################################################################

    def add_edges(self, i: instr, graph: UndirectedAdjList, afterSet: Set[location]):
        match i:
            case Callq(name, args):
                if name == label_name('collect'):
                    for v in afterSet:
                        if v not in self.registers and self.isPointer(self.var_types[v.id]):
                            for r in self.callee_saved_registers:
                                graph.add_edge(v, r)
                return super().add_edges(i, graph, afterSet)
            case _:
                return super().add_edges(i, graph, afterSet)

    def add_ver(self, i: instr, graph: UndirectedAdjList):
        return super().add_ver(i, graph)

    def build_interference(self, p: X86Program, afterDict: Dict[instr, Set[location]]) -> UndirectedAdjList:
        self.var_types = p.var_types
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
        return super().has_colored_neighbor(node, sat, move_graph, colors)

    def color_graph(self, graph: UndirectedAdjList, move_graph: UndirectedAdjList) -> Dict[Variable, int]:
        return super().color_graph(graph, move_graph)

    def allocate_registers(self, colors: Dict[Variable, int]):
        returnDict = {}
        for k,v in colors.items():
            if v < 11:
                returnDict.update({k : Reg(self.colToReg[v])})
            elif not self.isPointer(self.var_types[k.id]):
                loc = -8 - 8*(v - 11)
                returnDict.update({k : Deref('rbp', loc)})
            else:
                loc = -8 - 8*(v - 11)
                returnDict.update({k : Deref('r15', loc)})
        return returnDict

    ############################################################################
    # Move Biasing
    ############################################################################

    def detect_move(self, i: instr, graph: UndirectedAdjList):
        return super().detect_move(i, graph)

    def build_move_graph(self, p: X86Program) -> UndirectedAdjList:
        match p:
            case X86Program(blocks):
                graph = UndirectedAdjList()
                for (label, ss) in blocks.items():
                    for i in ss:
                        self.detect_move(i, graph)
                return graph
            case _:
                raise Exception ('error in build_move_graph + ', repr(p))

    ###############################################################
    ######## Assign Homes
    ###############################################################

    def assign_homes_arg(self, a: arg, home: Dict[Variable, arg]) -> arg:
        match a:
            case Global(label):
                return a
            case _:
                return super().assign_homes_arg(a, home)

    def assign_homes_instr(self, i: instr, home: Dict[Variable, arg]) -> instr:
        return super().assign_homes_instr(i, home)

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
            case Instr('movq', [Global(label), Deref(loc, offset)]):
                return [Instr('movq', [Global(label), Reg('rax')]),
                        Instr('movq', [Reg('rax'), Deref(loc, offset)])]
            case Instr('movq', [Deref(loc, offset), Global(label)]):
                return [Instr('movq', [Deref(loc, offset), Reg('rax')]),
                        Instr('movq', [Reg('rax'), Global(label)])]
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
        if isinstance(arg, Deref) and arg.reg == 'rbp':
            stack_used.add(arg)

    def in_root(self, root_used, arg):
        if isinstance(arg, Deref) and arg.reg == 'r15':
            root_used.add(arg)

    def locations_used(self, p: X86Program):
        p.s = set()
        p.c = set()
        p.r = set()
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
                        self.in_root(p.r, arg1)
                        self.in_root(p.r, arg2)
                    case Instr(operation, (arg, )):
                        self.in_callee(p.c, arg)
                        self.in_stack(p.s, arg)
                        self.in_root(p.r, arg)
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
                p.root_space = 2 ** 14
                p.heap_space = 2 ** 14
                p.num_spills = len(p.r)
                initialize = [Instr('movq', [Immediate(p.root_space), Reg('rdi')]),
                              Instr('movq', [Immediate(p.heap_space), Reg('rsi')]),
                              Callq(label_name('initialize'), 2),
                              Instr('movq', [Global(label_name('rootstack_begin')), Reg('r15')])]
                zeroes = []
                for i in range(p.num_spills):
                    zeroes += [Instr('movq', [Immediate(0), Deref('r15', 0)]),
                               Instr('addq', [Immediate(8), Reg('r15')])]
                pre_stmts = addStack + [Instr('pushq', [Reg('rbp')]),
                          Instr('movq', [Reg('rsp'), Reg('rbp')]),
                          Instr('subq', [Immediate(p.stack_space), Reg('rsp')])] + initialize + zeroes + [Jump('start')]
                con_stmts = [Instr('subq', [Immediate(p.num_spills), Reg('r15')]),
                                Instr('addq', [Immediate(p.stack_space), Reg('rsp')]),
                                Instr('popq', [Reg('rbp')])] + removeStack + [Instr('retq', [])]
                blocks['main'] = pre_stmts
                blocks['conclusion'] = con_stmts
                return p
            case _:
                raise Exception ('error in prelude_and_conclusion + ', repr(p))

