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

from compilerArray import CompilerArray

Binding = Tup[Name, expr]
Temporaries = List[Binding]

class CompilerFun(CompilerArray):

    ###############################################################
    ######## Partial Eval
    ###############################################################

    def pe_neg(self, e: expr) -> expr:
        return super().pe_neg(e)

    def pe_add(self, e1: expr, e2: expr) -> expr:
        return super().pe_add(e1, e2)

    def pe_sub(self, e1: expr, e2: expr) -> expr:
        return super().pe_sub(e1, e2)

    def pe_mult(self, e1: expr, e2: expr) -> expr:
        return super().pe_mult(e1, e2)

    def pe_exp(self, e: expr, env: Set[expr]) -> expr:
        match e:
            case Call(e1, args):
                new_args = [self.pe_exp(a, env) for a in args]
                return Call(self.pe_exp(e1, env), new_args)
            case _:
                return super().pe_exp(e, env)
                
    def pe_stmt(self, s: stmt, env: Set[expr]) -> expr:
        match s:
            case Return(e1):
                return Return(self.pe_exp(e1, env))
            case FunctionDef(name, params, body, dl, returns, comment):
                newStmts = [self.pe_stmt(s, env) for s in body]
                return FunctionDef(name, params, newStmts, dl, returns, comment)
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

    def shrink_exp(self, e: expr) -> expr:
        match e:
            case Call(Name('input_int'), []):
                return super().shrink_exp(e)
            case Call(func, args):
                new_args = [self.shrink_exp(a) for a in args]
                return Call(self.shrink_exp(func), new_args)
            case _:
                return super().shrink_exp(e)

    def shrink_stmt(self, s: stmt) -> stmt:
        match s:
            case Return(e1):
                return Return(self.shrink_exp(e1))
            case FunctionDef(name, params, body, dl, returns, comment):
                newBody = [self.shrink_stmt(b) for b in body]
                return FunctionDef(name, params, newBody, dl, returns, comment)
            case _:
                return super().shrink_stmt(s)

    def shrink(self, p: Module) -> Module:
        match p:
            case Module(body):
                stmts = [self.shrink_stmt(stmt) for stmt in body]
                newBody = []
                funDefs = []
                for s in stmts:
                    if isinstance(s, FunctionDef):
                        funDefs.append(s)
                    else:
                        newBody.append(s)
                return Module(funDefs + [FunctionDef('main', [], newBody + [Return(Constant(0))], None, IntType(), None)])
            case _:
                raise Exception ('error in shrink + ', repr(p))

    ###############################################################
    ######## Reveal Functions
    ###############################################################
    
    # functionToArity = {'input_int' : 0, 'print' : 1, 'len' : 1, 'array_load' : 2, 'array_store' : 3}
    functionToArity = {}

    def reveal_exp(self, e: expr) -> expr:
        match e:
            case Constant(value):
                return e
            case UnaryOp(op, exp):
                return UnaryOp(op, self.reveal_exp(exp))
            case BinOp(exp1, op, exp2):
                return BinOp(self.reveal_exp(exp1), op, self.reveal_exp(exp2))
            case Name(var):
                if var in self.functionToArity:
                    return FunRef(var, self.functionToArity[var])
                return e
            case BoolOp(boolop, [exp1, exp2]):
                return BoolOp(boolop, [self.reveal_exp(exp1), self.reveal_exp(exp2)])
            case Compare(exp1, [cmp], [exp2]):
                return Compare(self.reveal_exp(exp1), [cmp], [self.reveal_exp(exp2)])
            case IfExp(exp1, exp2, exp3):
                return IfExp(self.reveal_exp(exp1), self.reveal_exp(exp2), self.reveal_exp(exp3))
            case Tuple(exps, Load()):
                es = [self.reveal_exp(exp) for exp in exps]
                return Tuple(es, Load())
            case Subscript(exp1, exp2, Load()):
                return Subscript(self.reveal_exp(exp1), self.reveal_exp(exp2), Load())
            case ast.List(exps, Load()):
                es = [self.reveal_exp(exp) for exp in exps]
                return ast.List(es, Load())
            case Call(name, args):
                newName = self.reveal_exp(name)
                newArgs = [self.reveal_exp(a) for a in args]
                return Call(newName, newArgs)
            case _:
                raise Exception ('error in resolve_exp + ', repr(e))

    def reveal_stmt(self, s: stmt) -> stmt:
        match s:
            case Assign([Subscript(exp1, exp2, Store())], exp3):
                return Assign([Subscript(self.reveal_exp(exp1), self.reveal_exp(exp2), Store())], self.reveal_exp(exp3))
            case While(exp, stmts, []):
                es = [self.reveal_stmt(stmt) for stmt in stmts]
                return While(self.reveal_exp(exp), es, [])
            case If(exp, stmts1, stmts2):
                es1 = [self.reveal_stmt(stmt) for stmt in stmts1]
                es2 = [self.reveal_stmt(stmt) for stmt in stmts2]
                return If(self.reveal_exp(exp), es1, es2)
            case Assign([Name(var)], exp):
                return Assign([Name(var)], self.reveal_exp(exp))
            case Expr(exp):
                return Expr(self.reveal_exp(exp))
            case Return(e):
                return Return(self.reveal_exp(e))
            case FunctionDef(name, params, body, dl, returns, comment):
                self.functionToArity[name] = len(params)
                newBody = [self.reveal_stmt(b) for b in body]
                return FunctionDef(name, params, newBody, dl, returns, comment)
            case _:
                raise Exception ('error in resolve_stmt + ', repr(s))

    def reveal_functions(self, p: Module) -> Module:
        match p:
            case Module(body):
                stmts = [self.reveal_stmt(stmt) for stmt in body]
                return Module(stmts)
            case _:
                raise Exception ('error in reveal_functions + ', repr(p))


    ###############################################################
    ######## Resolve
    ###############################################################

    def resolve_exp(self, e: expr) -> expr:
        match e:
            case FunRef(name, arity):
                return e
            case Call(Name('input_int'),[]):
                return super().resolve_exp(e)
            case Call(Name('print'), [exp]):
                return super().resolve_exp(e)
            case Call(Name('len'),[exp]):
                return super().resolve_exp(e)
            case Call(fun, args):
                newArgs = [self.resolve_exp(a) for a in args]
                return Call(fun, args)
            case _:
                return super().resolve_exp(e)

    def resolve_stmt(self, s: stmt) -> stmt:
        match s:
            case Return(e1):
                return Return(self.resolve_exp(e1))
            case FunctionDef(name, params, body, dl, returns, comment):
                newBody = [self.resolve_stmt(b) for b in body]
                return FunctionDef(name, params, newBody, dl, returns, comment)
            case _:
                return super().resolve_stmt(s)

    def resolve(self, p: Module) -> Module:
        match p:
            case Module(body):
                stmts = [self.resolve_stmt(stmt) for stmt in body]
                return Module(stmts)
            case _:
                raise Exception ('error in resolve + ', repr(p))

    ###############################################################
    ######## Check Bounds
    ###############################################################

    def cb_exp(self, e: expr) -> expr:
        match e:
            case FunRef(name, arity):
                return e
            case Call(Name('input_int'),[]):
                return super().cb_exp(e)
            case Call(Name('print'), [exp]):
                return super().cb_exp(e)
            case Call(Name('len'),[exp]):
                return super().cb_exp(e)
            case Call(Name('array_len'), [tup]):
                return super().cb_exp(e)
            case Call(Name('array_load'), [tup, idx]):
                return super().cb_exp(e)
            case Call(Name('array_store'), [tup, idx, val]):
                return super().cb_exp(e)
            case Call(fun, args):
                newArgs = [self.cb_exp(a) for a in args]
                return Call(fun, newArgs)
            case _:
                return super().cb_exp(e)

    def cb_stmt(self, s: stmt) -> stmt:
        match s:
            case Return(e1):
                return Return(self.cb_exp(e1))
            case FunctionDef(name, params, body, dl, returns, comment):
                newBody = [self.cb_stmt(b) for b in body]
                return FunctionDef(name, params, newBody, dl, returns, comment)
            case _:
                return super().cb_stmt(s)

    def check_bounds(self, p: Module) -> Module:
        match p:
            case Module(body):
                stmts = [self.cb_stmt(stmt) for stmt in body]
                return Module(stmts)
            case _:
                raise Exception ('error in check_bounds + ', repr(p))

    ###############################################################
    ######## Limit Functions
    ###############################################################

    def limit_functions_exp(self, e: expr, env: Dict[str, Tup[expr, int]]) -> expr:
        match e:
            case Constant(value):
                return e
            case UnaryOp(op, exp):
                return UnaryOp(op, self.limit_functions_exp(exp, env))
            case BinOp(exp1, op, exp2):
                return BinOp(self.limit_functions_exp(exp1, env), op, self.limit_functions_exp(exp2, env))
            case Name(var):
                if var in env:
                    tup_name, idx = env[var]
                    return Subscript(tup_name, Constant(idx), Load())
                else:
                    return e
            case FunRef(name, arity):
                return e
            case BoolOp(boolop, [exp1, exp2]):
                return BoolOp(boolop, [self.limit_functions_exp(exp1, env), self.limit_functions_exp(exp2, env)])
            case Compare(exp1, [cmp], [exp2]):
                return Compare(self.limit_functions_exp(exp1, env), [cmp], [self.limit_functions_exp(exp2, env)])
            case IfExp(exp1, exp2, exp3):
                return IfExp(self.limit_functions_exp(exp1, env), self.limit_functions_exp(exp2, env), self.limit_functions_exp(exp3, env))
            case Tuple(exps, Load()):
                es = [self.limit_functions_exp(exp, env) for exp in exps]
                return Tuple(es, Load())
            case Subscript(exp1, exp2, Load()):
                return Subscript(self.limit_functions_exp(exp1, env), self.limit_functions_exp(exp2, env), Load())
            case ast.List(exps, Load()):
                es = [self.limit_functions_exp(exp, env) for exp in exps]
                return ast.List(es, Load())
            case Call(name, args):
                newName = self.limit_functions_exp(name, env)
                newArgs = [self.limit_functions_exp(a, env) for a in args]
                if len(args) <= 6:
                    return Call(newName, newArgs)
                else:
                    initArgs = newArgs[:5]
                    tailArgs = newArgs[5:]
                    return Call(newName, initArgs + [Tuple(tailArgs, Load())])
            case _:
                raise Exception ('error in limit_functions_exp + ', repr(e))

    def limit_functions_stmt(self, s: stmt, env: Dict[str, Tup[expr, int]]) -> stmt:
        match s:
            case Assign([Subscript(exp1, exp2, Store())], exp3):
                return Assign([Subscript(self.limit_functions_exp(exp1, env), self.limit_functions_exp(exp2, env), Store())], self.limit_functions_exp(exp3, env))
            case While(exp, stmts, []):
                es = [self.limit_functions_stmt(stmt, env) for stmt in stmts]
                return While(self.limit_functions_exp(exp, env), es, [])
            case If(exp, stmts1, stmts2):
                es1 = [self.limit_functions_stmt(stmt, env) for stmt in stmts1]
                es2 = [self.limit_functions_stmt(stmt, env) for stmt in stmts2]
                return If(self.limit_functions_exp(exp, env), es1, es2)
            case Assign([Name(var)], exp):
                return Assign([Name(var)], self.limit_functions_exp(exp, env))
            case Expr(exp):
                return Expr(self.limit_functions_exp(exp, env))
            case Return(e):
                return Return(self.limit_functions_exp(e, env))
            case FunctionDef(name, params, body, dl, returns, comment):
                if len(params) <= 6:
                    new_body = [self.limit_functions_stmt(st, {}) for st in body]
                    return FunctionDef(name, params, new_body, dl, returns, comment)
                else:
                    new_env = {}
                    init_params = params[:5]
                    tail_params = params[5:]
                    tuple_type = TupleType([t for (x,t) in tail_params])
                    newTup = generate_name('tup')
                    i = 0
                    for (x,t) in tail_params:
                        new_env[x] = (Name(newTup), i)
                        i += 1
                    newbody = [self.limit_functions_stmt(st, new_env) for st in body]
                    newParams = init_params + [(newTup, tuple_type)]
                    return FunctionDef(name, newParams, newbody, dl, returns, comment)

            case _:
                raise Exception ('error in limit_functions_stmt + ', repr(s))

    def limit_functions(self, p: Module) -> Module:
        match p:
            case Module(body):
                stmts = [self.limit_functions_stmt(stmt, {}) for stmt in body]
                return Module(stmts)
            case _:
                raise Exception ('error in limit_functions + ', repr(p))

    ###############################################################
    ######## Expose Allocation
    ###############################################################

    def expose_alloc(self, tup: List[expr], alloc: Allocate) -> expr:
        return super().expose_alloc(tup, alloc)

    def expose_alloc_array(self, arr: List[expr], alloc: AllocateArray) -> expr:
        return super().expose_alloc_array(arr, alloc)

    def expose_exp(self, e: expr) -> expr:
        match e:
            case Call(FunRef(name, arity), args):
                return Call(FunRef(name, arity), [self.expose_exp(ex) for ex in args])
            case _:
                return super().expose_exp(e)

    def expose_stmt(self, s: stmt) -> stmt:
        match s:
            case Return(value):
                return Return(self.expose_exp(value))
            case FunctionDef(name, params, body, dl, returns, comment):
                newBody = [self.expose_stmt(st) for st in body]
                return FunctionDef(name, params, newBody, dl, returns, comment)
            case _:
                return super().expose_stmt(s)

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
            case Call(Name('array_len'), [tup]):
                newVar1, newMap1 = self.rco_exp(tup, True)
                newTemp = Name(generate_name('tmp'))
                return newTemp, newMap1 + [Assign([newTemp], Call(Name('array_len'), [newVar1]))]
            case Call(Name('array_load'), [tup, idx]):
                newVar1, newMap1 = self.rco_exp(tup, True)
                newVar2, newMap2 = self.rco_exp(idx, True)
                newTemp = Name(generate_name('tmp'))
                return newTemp, newMap1 + newMap2 + [Assign([newTemp], Call(Name('array_load'), [newVar1, newVar2]))]
            case Call(Name('array_store'), [tup, idx, val]):
                newVar1, newMap1 = self.rco_exp(tup, True)
                newVar2, newMap2 = self.rco_exp(idx, True)
                newVar3, newMap3 = self.rco_exp(val, True)
                return Call(Name('array_store'), [newVar1, newVar2, newVar3]), newMap1 + newMap2 + newMap3
            case AllocateArray(arg1, t):
                if need_atomic:
                    temp = Name(generate_name('tmp'))
                    return temp, [Assign([temp], e)]
                else:
                    return e, []
            case Call(Name('exit'), []):
                return e, []
            case _:
                return super().rco_exp(e, need_atomic)

    def rco_stmt(self, s: stmt) -> List[stmt]:
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
            case Expr(Call(Name('array_store'), args)):
                raise Exception ('sto[]')
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
            return super().select_arg(e)

    def select_op(self, op: operator) -> str:
        match op:
            case Mult():
                return 'imulq'
            case _:
                return super().select_op(op)

    def select_jump(self, op: operator) -> str:
            return super().select_jump(op)

    def isPointer(self, arg: TupleType) -> bool:
        match arg:
            case ListType(t):
                return True
            case _:
                return super().isPointer(arg)

    def select_stmt(self, s: stmt) -> List[instr]:
        match s:
            case Assign([arg1], Call(Name('array_load'), [tup, idx])):
                arg1 = self.select_arg(arg1)
                arg2 = self.select_arg(tup)
                arg3 = self.select_arg(idx)
                return [Instr('movq', [arg2, Reg('r11')]), # put arr in r11
                        Instr('movq', [arg3, Reg('rax')]), # put arg3 in rax
                        Instr('addq', [Immediate(1), Reg('rax')]), # get the offset
                        Instr('imulq', [Immediate(8), Reg('rax')]),
                        Instr('addq', [Reg('rax'), Reg('r11')]), # get the memory location we want
                        Instr('movq', [Deref('r11', 0), arg1])] # put the value in the arg
            case Expr(Call(Name('array_store'), [tup, idx, val])):
                arg1 = self.select_arg(tup)
                arg2 = self.select_arg(idx)
                arg3 = self.select_arg(val)
                return [Instr('movq', [arg1, Reg('r11')]),
                        Instr('movq', [arg2, Reg('rax')]),
                        Instr('addq', [Immediate(1), Reg('rax')]),
                        Instr('imulq', [Immediate(8), Reg('rax')]),
                        Instr('addq', [Reg('rax'), Reg('r11')]),
                        Instr('movq', [arg3, Deref('r11', 0)])]
            case Assign([arg1], Call(Name('array_len'), [arg2])):
                arg1 = self.select_arg(arg1)
                arg2 = self.select_arg(arg2)
                return [Instr('movq', [arg2, Reg('rax')]), # put tuple in rax
                        Instr('movq', [Deref('rax', 0), Reg('rax')]), # dereference to load the actual bits in rax
                        Instr('movq', [Immediate((2 ** 62) - 4), Reg('r11')]),
                        Instr('andq', [Reg('r11'), Reg('rax')]), # and with 2^64 - 2 to get just the bits that store size
                        Instr('sarq', [Immediate(2), Reg('rax')]), # shift right to get rid of the trailing 0s 
                        Instr('movq', [Reg('rax'), arg1])] # store length in arg2
            case Assign([arg1], AllocateArray(arg2, ListType(types))):
                arg1 = self.select_arg(arg1)
                len = arg2
                if self.isPointer(types):
                    pointer_mask = 1
                else:
                    pointer_mask = 0
                tag = 0 | (len << 2) | (pointer_mask << 1)| 1
                return [Instr('movq', [Global(label_name('free_ptr')), Reg('r11')]),
                        Instr('addq', [Immediate(8 * (len + 1)), Global(label_name('free_ptr'))]),
                        Instr('movq', [Immediate(tag), Deref('r11', 0)]),
                        Instr('movq', [Reg('r11'), arg1])]
            case Assign([arg1], Call(Name('exit'), [])):
                return [Instr('movq', [Immediate(255), Reg('rdi')]),
                        Callq(label_name('call_exit'), 1)]
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
            case Instr('imulq', args):
                return self.getLoc(args[0]) | self.getLoc(args[1])
            case _:
                return super().R(i)

    def W(self, i: instr) -> Set[location]:
        match i:
            case Instr('imulq', args):
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

    def build_move_graph(self, p:X86Program) -> UndirectedAdjList:
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
            # case need mult
            case (Instr('imulq', [arg, Immediate(value)])):
                return [instr('movq', [Immediate(value), Reg('rax')]),
                        instr('imulq', [arg, Reg('rax')])]
            case (Instr('imulq', [arg, Deref(loc, offset)])):
                return [instr('movq', [Deref(loc, offset), Reg('rax')]),
                        instr('imulq', [arg, Reg('rax')])]
            case (Instr('imulq', [arg, Global(label)])):
                return [instr('movq', [Global(label), Reg('rax')]),
                        instr('imulq', [arg, Reg('rax')])]
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
