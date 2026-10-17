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
        self.functionToArity = {}
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
                newFun = self.resolve_exp(fun)
                newArgs = [self.resolve_exp(a) for a in args]
                return Call(newFun, newArgs)
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
                newFun = self.cb_exp(fun)
                newArgs = [self.cb_exp(a) for a in args]
                return Call(newFun, newArgs)
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
            case FunRef(name, arity):
                return e
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
            case FunRef(name, arity):
                if need_atomic:
                    newTemp = Name(generate_name('tmp'))
                    return newTemp, [Assign([newTemp], FunRef(name, arity))]
                else:
                    return e, []
            case Call(Name(fun), args):
                if fun in builtin_functions:
                    return super().rco_exp(e, need_atomic)
                else:
                    newFunc, newMap1 = self.rco_exp(Name(fun), True)
                    newArgs = []
                    argMaps = []
                    for arg in args:
                        newVar, newMap = self.rco_exp(arg, True)
                        newArgs.append(newVar)
                        argMaps.append(newMap)
                    argMaps = sum(argMaps, [])
                    if need_atomic:
                        newTemp = Name(generate_name('tmp'))
                        return newTemp, newMap1 + argMaps + [Assign([newTemp], Call(newFunc, newArgs))]
                    else:
                        return Call(newFunc, newArgs), argMaps
            case Call(func, args):
                newFunc, funcVars = self.rco_exp(func, True)
                newVars = []
                newMaps = []
                for arg in args:
                    newVar, newMap = self.rco_exp(arg, True)
                    newVars.append(newVar)
                    newMaps.append(newMap)
                newMaps = funcVars + sum(newMaps, [])
                if need_atomic:
                    newTemp = Name(generate_name('tmp'))
                    return newTemp, newMaps + [Assign([newTemp], Call(newFunc, newVars))]
                else:
                    return Call(newFunc, newVars), newMaps
            case _:
                return super().rco_exp(e, need_atomic)

    def rco_stmt(self, s: stmt) -> List[stmt]:
        match s:
            case Return(value):
                match value:
                    case Call(func, args):
                        newVar, newMap = self.rco_exp(value, False)
                        return newMap + [Return(newVar)]
                    case _:
                        newVar, newMap = self.rco_exp(value, True)
                        return newMap + [Return(newVar)]
            case FunctionDef(name, params, body, dl, returns, comment):
                newBody = sum([self.rco_stmt(st) for st in body], [])
                return [FunctionDef(name, params, newBody, dl, returns, comment)]
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

    def explicate_tail(self, e: expr, basic_blocks: Dict[str, List[stmt]]) -> Promise | List[stmt]:
        match e:
            case Begin(body, result):
                newResult = self.explicate_tail(result, basic_blocks)
                for s in reversed(body):
                    newResult = self.explicate_stmt(s, newResult, basic_blocks)
                return newResult
            case IfExp(arg1, arg2, arg3):
                newArg2 = self.explicate_tail(arg2, basic_blocks)
                newArg3 = self.explicate_tail(arg3, basic_blocks)
                return self.explicate_pred(arg1, newArg2, newArg3, basic_blocks)
            case Call(Name(func), args):
                if func in builtin_functions:
                    return [Return(e)]
                else:
                    return [TailCall(Name(func), args)]
            case Call(fun, args):
                newFun = self.explicate_tail(fun)
                newArgs = [self.explicate_tail(arg) for arg in args]
                return [TailCall(newFun, newArgs)]
            case _:
                return [Return(e)]

    def explicate_pred(self, cnd: expr, thn: List[stmt], els: List[stmt], basic_blocks: Dict[str, List[stmt]]) -> List[stmt]:
        match cnd:
            case Call(func, args):
                newTemp = Name(generate_name('tmp'))
                thnBlock = self.create_block(thn, basic_blocks)
                elsBlock = self.create_block(els, basic_blocks)
                return [Assign([newTemp], cnd),
                        If(Compare(newTemp, [Eq()], [Constant(True)]), thnBlock, elsBlock)]
            case _:
                return super().explicate_pred(cnd, thn, els, basic_blocks)
    
    def explicate_stmt(self, s: stmt, cont: List[stmt], basic_blocks: Dict[str, List[stmt]]) -> List[stmt]:
        match s:
            case Return(value):
                return self.explicate_tail(value, basic_blocks)
            case _:
                return super().explicate_stmt(s, cont, basic_blocks)

    def explicate_def(self, s: FunctionDef) -> FunctionDef:
        match s:
            case FunctionDef(name, params, body, dl, returns, comment):
                newbody = []
                blocks = {}
                if isinstance(returns, VoidType):
                    body += [Return(Constant(None))]
                for s in reversed(body):
                    newbody = self.explicate_stmt(s, newbody, blocks)
                blocks[label_name(name + '_start')] = force(newbody)
                return FunctionDef(name, params, blocks, dl, returns, comment)
            case _:
                raise Exception ('error in explicate_def + ', repr(s))
    
    def explicate_control(self, p: Module) -> CProgramDefs:
        match p:
            case Module(body):
                funcDefs = []
                for defn in body:
                    funcDefs.append(self.explicate_def(defn))
                temp = CProgramDefs(funcDefs)
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

    def remove_orphans(self, p: CProgramDefs | FunctionDef) -> CProgramDefs | FunctionDef:
        match p:
            case FunctionDef(name, params, body, dl, returns, comment):
                blocks = body
                self.block_parent_dict = {}
                self.block_child_dict = {}
                for (block, ss) in blocks.items():
                    self.block_parent_dict[block] = []
                    self.block_child_dict[block] = []
                for (block, ss) in blocks.items():
                    self.count_parents(block, ss)
                orphans = []
                for block in blocks:
                    if (len(self.block_parent_dict[block]) == 0 and block != name + '_start'):
                        orphans += [block]
                for block in orphans:
                    blocks.pop(block)
                    for c in self.block_child_dict[block]:
                        self.block_parent_dict[c].remove(block)
                return FunctionDef(name, params, blocks, dl, returns, comment)
            case CProgramDefs(funcDefs):
                newDefs = []
                for func in funcDefs:
                    newDefs.append(self.remove_orphans(func))
                return CProgramDefs(newDefs)
            case _:
                raise Exception ('error in remove orphans + ', repr(p))

    ###############################################################
    ######## Remove Jumps
    ###############################################################

    def count_parents_86(self, label: str, stmts: List[instr]):
        return super().count_parents_86(label, stmts)

    def merge_blocks(self, child_label: str, parent: List[instr], child: List[instr]) -> List[instr]:
        return super().merge_blocks(child_label, parent, child)

    def remove_jumps(self, p: X86Program | FunctionDef) -> X86ProgramDefs | FunctionDef:
        match p:
            case FunctionDef(name, params, body, dl, returns, comment):
                blocks = body
                self.block_parent_dict = {}
                self.block_child_dict = {}
                self.block_parent_dict[name + '_conclusion'] = []
                for (block, ss) in blocks.items():
                    self.block_parent_dict[block] = []
                    self.block_child_dict[block] = []
                for (block, ss) in blocks.items():
                    self.count_parents_86(block, ss)
                graph = DirectedAdjList()
                for (label, ss) in blocks.items():
                    for s in ss:
                        match s:
                            case Jump(arg):
                                graph.add_edge(label, arg)
                            case JumpIf(cc, arg):
                                graph.add_edge(label, arg)
                            case _:
                                continue
                graph = transpose(graph)
                block_list = topological_sort(graph)
                for label in block_list:
                    if label == name + '_start' or label == name + '_conclusion':
                        continue
                    ss = blocks[label]
                    if len(self.block_parent_dict[label]) == 0:
                        blocks.pop(label)
                    elif len(self.block_parent_dict[label]) == 1:
                        parent = self.block_parent_dict[label][0]
                        blocks[parent], merge = self.merge_blocks(label, blocks[parent], ss)
                        if merge:
                            blocks.pop(label)
                return FunctionDef(name, params, blocks, dl, returns, comment)
            case X86ProgramDefs(funDefs):
                newDefs = []
                for func in funDefs:
                    newDefs.append(self.remove_jumps(func))
                return X86ProgramDefs(newDefs)
            case _:
                raise Exception('error in remove_jumps + ', repr(p))

    ###############################################################
    ######## Select Instructions
    ###############################################################

    def select_arg(self, e: expr) -> arg:
        return super().select_arg(e)

    def select_op(self, op: operator) -> str:
        return super().select_op(op)

    def select_jump(self, op: operator) -> str:
        return super().select_jump(op)

    def isPointer(self, arg: TupleType) -> bool:
            return super().isPointer(arg)

    def select_stmt(self, s: stmt) -> List[instr]:
        match s:
            case TailCall(Name(id), args):
                newFunc = self.select_arg(Name(id))
                newArgs = [self.select_arg(a) for a in args]
                moves = []
                for i in range(len(newArgs)):
                    moves.append(Instr('movq', [newArgs[i], self.param_registers[i]]))
                return moves + [TailJump(newFunc, len(args))]
            case TailCall(FunRef(name, arity), args):
                newFun = self.select_arg(Name(name))
                newArgs = [self.select_arg(a) for a in args]
                moves = []
                for i in range(len(newArgs)):
                    moves.append(Instr('movq', [newArgs[i], self.param_registers[i]]))
                return moves + [TailJump(newFun, len(args))]
            case Return(value):
                st = self.select_stmt(Assign([Reg('rax')], value))
                return st + [Jump(label_name(self.current_fun + '_conclusion'))]
            case Assign([lhs], Constant(None)):
                newLhs = self.select_arg(lhs)
                return [Instr('movq', [Immediate(0), newLhs])]
            case Assign([lhs], Call(Name(f), args)):
                if f in builtin_functions:
                    return super().select_stmt(s)
                else:
                    newArgs = [self.select_arg(a) for a in args]
                    moves = []
                    for i in range(len(newArgs)):
                        moves.append(Instr('movq', [newArgs[i], self.param_registers[i]]))
                    newFun = self.select_arg(Name(f))
                    newLhs = self.select_arg(lhs)
                    return moves + [IndirectCallq(newFun, len(newArgs)),
                                    Instr('movq', [Reg('rax'), newLhs])]
            case Assign([lhs], FunRef(name, arity)):
                lhs_prime = self.select_arg(lhs)
                return [Instr('leaq', [Global(label_name(name)), lhs_prime])]
            case Assign([lhs], Call(FunRef(name, arity), args)):
                newArgs = [self.select_arg(a) for a in args]
                moves = []
                for i in range(len(newArgs)):
                    moves.append(Instr('movq', [newArgs[i], self.param_registers[i]]))
                newFun = self.select_arg(Name(name))
                newLhs = self.select_arg(lhs)
                return moves + [IndirectCallq(newFun, len(newArgs)),
                                Instr('movq', [Reg('rax'), newLhs])]
            case Expr(Call(Name(f), args)):
                if f in builtin_functions:
                    return super().select_stmt(s)
                else:
                    newArgs = [self.select_arg(a) for a in args]
                    moves = []
                    for i in range(len(newArgs)):
                        moves.append(Instr('movq', [newArgs[i], self.param_registers[i]]))
                    newFun = self.select_arg(Name(f))
                    return moves + [IndirectCallq(newFun, len(newArgs))]
            case Expr(Call(FunRef(name, arity), args)):
                newArgs = [self.select_arg(a) for a in args]
                moves = []
                for i in range(len(newArgs)):
                    moves.append(Instr('movq', [newArgs[i], self.param_registers[i]]))
                newFun = self.select_arg(Name(name))
                return moves + [IndirectCallq(newFun, len(newArgs))]
            case _:
                return super().select_stmt(s)

    def select_def(self, s: FunctionDef) -> FunctionDef:
        match s:
            case FunctionDef(name, params, blocks, dl, returns, comment):
                self.current_fun = name
                moveRegisters = []
                for i in range(len(params)):
                    moveRegisters.append(Instr('movq', [self.param_registers[i], Variable(params[i][0])]))
                block_dict = {}
                for (label, ss) in blocks.items():
                    if label == name + '_start':
                        block_dict[label] = moveRegisters
                    else:
                        block_dict[label] = []
                    for st in ss:
                        instructions = self.select_stmt(st)
                        block_dict[label] += instructions
                func = FunctionDef(label_name(name), [], block_dict, dl, returns, comment)
                func.var_types = s.var_types
                return func
            case _:
                raise Exception ('error in select_def + ', repr(s))

    def select_instructions(self, p: CProgramDefs) -> X86ProgramDefs:
        match p:
            case CProgramDefs(funDefs):
                newDefs = []
                for fun in funDefs:
                    newDefs.append(self.select_def(fun))
                temp = X86ProgramDefs(newDefs)
                vars = []
                for i in range(len(temp.defs)):
                    vars.append(temp.defs[i].var_types)
                temp = self.remove_jumps(temp)
                for i in range(len(temp.defs)):
                    temp.defs[i].var_types = vars[i]
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
        return super().getLoc(param)

    def R(self, i: instr) -> Set[location]:
        match i:
            case TailJump(func, arity):
                returnSet = set()
                for n in range(arity):
                    returnSet = returnSet | {self.param_registers[n]}
                return self.getLoc(func) | returnSet
            case IndirectCallq(func, arity):
                returnSet = set()
                for n in range(arity):
                    returnSet = returnSet | {self.param_registers[n]}
                return self.getLoc(func) | returnSet
            case Instr('leaq', args):
                return self.getLoc(args[0])
            case _:
                return super().R(i)

    def W(self, i: instr) -> Set[location]:
        match i:
            case TailJump(func, arity):
                return set(self.caller_saved_registers)
            case IndirectCallq(func, arity):
                return set(self.caller_saved_registers)
            case Instr('leaq', args):
                return self.getLoc(args[1])
            case _:
                return super().W(i)

    def getBeforeAfter(self, i: instr, prev_before):
        return super().getBeforeAfter(i, prev_before)

    def uncover_live(self, f: FunctionDef) -> Dict[instr, Set[location]]:
        match f:
            case FunctionDef(name, params, body, dl, returns, comment):
                blocks = body
                live_before_dict_block = {}
                live_after_dict_block = {}
                live_before_dict_i = {}
                live_after_dict_i = {}
                live_after_dict_block[name + '_conclusion'] = set()
                live_before_dict_block[name + '_conclusion'] = set()
                graph = DirectedAdjList()
                for (label, ss) in blocks.items():
                    graph.add_vertex(label)
                    live_before_dict_block[label] = set()
                    live_after_dict_block[label] = set()
                    for s in ss:
                        match s:
                            case JumpIf(cc, arg):
                                if arg == name + '_conclusion':
                                    continue
                                graph.add_edge(label, arg)
                            case Jump(arg):
                                if arg == name + '_conclusion':
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
                                i_before, i_after = self.getBeforeAfter(blocks[label][i], i_before)
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
            case IndirectCallq(func, arity):
                for v in afterSet:
                    if v not in self.registers and self.isPointer(self.var_types[v.id]):
                        for r in self.callee_saved_registers:
                            graph.add_edge(v, r)
                for d in self.W(i):
                    for v in afterSet:
                        if v != d:
                            graph.add_edge(d,v)
            case TailJump(func, arity):
                return
            case _:
                # leaq should be handled here
                return super().add_edges(i, graph, afterSet)

    def add_ver(self, i: instr, graph: UndirectedAdjList):
        return super().add_ver(i, graph)

    def build_interference(self, p: FunctionDef, afterDict: Dict[instr, Set[location]]) -> UndirectedAdjList:
        self.var_types = p.var_types
        match p:
            case FunctionDef(name, params, body, dl, returns, comment):
                blocks = body
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

    def build_move_graph(self, p: FunctionDef) -> UndirectedAdjList:
        match p:
            case FunctionDef(name, params, body, dl, returns, comment):
                blocks = body
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
        return super().assign_homes_arg(a, home)

    def assign_homes_instr(self, i: instr, home: Dict[Variable, arg]) -> instr:
        match i:
            case Instr('leaq', args):
                return Instr('leaq', [self.assign_homes_arg(args[0], home), self.assign_homes_arg(args[1], home)])
            case TailJump(func, arity):
                return TailJump(self.assign_homes_arg(func, home), arity)
            case IndirectCallq(func, arity):
                return IndirectCallq(self.assign_homes_arg(func, home), arity)
            case _:
                return super().assign_homes_instr(i, home)

    def assign_homes(self, p: X86ProgramDefs | FunctionDef) -> X86ProgramDefs | FunctionDef:
        match p:
            case X86ProgramDefs(funDefs):
                newFuns = []
                for f in funDefs:
                    newFuns.append(self.assign_homes(f))
                return X86ProgramDefs(newFuns)
            case FunctionDef(name, params, body, dl, returns, comment):
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
                return FunctionDef(name, params, newBlocks, dl, returns, comment)
            case _:
                raise Exception ('error in assign_homes + ', repr(p))

    ###############################################################
    ######## Patch Instructions
    ###############################################################

    def patch_instr(self, i: instr) -> List[instr]:
        match i:
            case Instr('leaq', [arg1, Deref(loc, offset)]):
                return [Instr('movq', [Deref(loc, offset), Reg('rax')]),
                        Instr('leaq', [arg1, Reg('rax')])]
            case TailJump(func, arity):
                if func != Reg('rax'):
                    return [Instr('movq', [func, Reg('rax')]),
                            TailJump(Reg('rax'), arity)]
                else:
                    return [i]
            case IndirectCallq(func, arity):
                return [i]
            case _:
                return super().patch_instr(i)

    def patch_instructions(self, p: X86ProgramDefs | FunctionDef) -> X86ProgramDefs | FunctionDef:
        match p:
            case X86ProgramDefs(funDefs):
                newFuns = []
                for fun in funDefs:
                    newFuns.append(self.patch_instructions(fun))
                return X86ProgramDefs(newFuns)
            case FunctionDef(name, params, body, dl, returns, comment):
                blocks = body
                newBlocks = {}
                for (label, ss) in blocks.items():
                    newInstr = []
                    for i in ss:
                        newInstr.append(self.patch_instr(i)) 
                    newInstr = sum(newInstr, [])
                    newBlocks[label] = newInstr
                return FunctionDef(name, params, newBlocks, dl, returns, comment)
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

    def locations_used(self, p: FunctionDef):
        p.s = set()
        p.c = set()
        p.r = set()
        p.tailCall = None
        for (label, ss) in p.body.items():
            for i in ss:
                match i:
                    case IndirectCallq(fun, arity):
                        self.in_callee(p.c, fun)
                        self.in_stack(p.s, fun)
                        self.in_root(p.r, fun)
                    case TailJump(fun, arity):
                        self.in_callee(p.c, fun)
                        self.in_stack(p.s, fun)
                        self.in_root(p.r, fun)
                        p.tailCall = fun
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

    def replace_tail_call(self, i: instr, conc: list[instr]):
        match i:
            case TailJump(fun, arity):
                return conc + [IndirectJump(fun), Instr('retq', [])]
            case _:
                return [i]

    def prelude_and_conclusion(self, p: X86ProgramDefs | FunctionDef) -> X86Program | FunctionDef:
        match p:
            case X86ProgramDefs(funs):
                blocks = {}
                for f in funs:
                    blocks = blocks | self.prelude_and_conclusion(f)
                return X86Program(blocks)
            case FunctionDef(name, params, body, dl, returns, comment):
                blocks = body
                self.locations_used(p)
                callee_reg = list(p.c)
                addStack = [Instr('pushq', [loc]) for loc in callee_reg]
                removeStack = [Instr('popq', [loc]) for loc in reversed(callee_reg)]
                p.stack_space = align(8*len(p.s) + 8*len(p.c), 16) - 8*len(p.c)
                p.root_space = 2 ** 14
                p.heap_space = 2 ** 14
                p.num_spills = len(p.r)
                if name == 'main':
                    initialize = [Instr('movq', [Immediate(p.root_space), Reg('rdi')]),
                                Instr('movq', [Immediate(p.heap_space), Reg('rsi')]),
                                Callq(label_name('initialize'), 2),
                                Instr('movq', [Global(label_name('rootstack_begin')), Reg('r15')])]
                else:
                    initialize = []
                zeroes = []
                for i in range(p.num_spills):
                    zeroes += [Instr('movq', [Immediate(0), Deref('r15', 0)]),
                               Instr('addq', [Immediate(8), Reg('r15')])]
                pre_stmts = addStack + [Instr('pushq', [Reg('rbp')]),
                          Instr('movq', [Reg('rsp'), Reg('rbp')]),
                          Instr('subq', [Immediate(p.stack_space), Reg('rsp')])] + initialize + zeroes + [Jump(label_name(name + '_start'))]
                con_stmts = [Instr('subq', [Immediate(p.num_spills), Reg('r15')]),
                                Instr('addq', [Immediate(p.stack_space), Reg('rsp')]),
                                Instr('popq', [Reg('rbp')])] + removeStack
                newBlocks = {}
                for (label, ss) in blocks.items():
                        newBlocks[label] = sum([self.replace_tail_call(s, con_stmts) for s in ss], [])
                newBlocks[name] = pre_stmts
                newBlocks[name + '_conclusion'] = con_stmts + [Instr('retq', [])]
                return newBlocks
            case _:
                raise Exception ('error in prelude_and_conclusion + ', repr(p))
