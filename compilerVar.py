import ast
from ast import *
from utils import *
from x86_ast import *
import os
from typing import List, Tuple, Set, Dict
from graph import UndirectedAdjList
from priority_queue import *

Binding = Tuple[Name, expr]
Temporaries = List[Binding]


class CompilerVar:

    ###################################
    #### Partial evaluation
    ###################################

    def pe_neg(self, r: expr) -> expr:
      match r:
        case Constant(n):
          return Constant(neg64(n))
        case _:
          return UnaryOp(USub(), r)
  
    # add and sub assume residual expressions
    def pe_add(self, r1: expr, r2: expr) -> expr:
      match (r1, r2):
        case (Constant(n1), Constant(n2)):
          return Constant(add64(n1, n2))
        case (Constant(n1), BinOp(Constant(n2), op, right)):
          return BinOp(Constant(add64(n1, n2)), op, right)
        case (BinOp(Constant(n1), op, right), Constant(n2)):
          return BinOp(Constant(add64(n1, n2)), op, right)
        case (BinOp(Constant(n1), op1, r1), BinOp(Constant(n2), op2, r2)):
           match (op1, op2):
            case (Add(), Add()):
              return BinOp(Constant(add64(n1, n2)), Add(), BinOp(r1, Add(), r2))
            case (Add(), Sub()):
              return BinOp(Constant(add64(n1, n2)), Add(), BinOp(r1, Sub(), r2))
            case (Sub(), Sub()):
              return BinOp(Constant(add64(n1, n2)), Sub(), BinOp(r1, Add(), r2))
            case (Sub(), Add()):
              return BinOp(Constant(add64(n1, n2)), Add(), BinOp(r2, Sub(), r1))
            case _:
              raise Exception ("pe_add has unexpected operation + ", repr(r1))
        case (BinOp(Constant(n1), op, right), inert):
          match op:
            case Add():
              return BinOp(Constant(n1), Add(), BinOp(right, Add(), inert))
            case Sub():
              return BinOp(Constant(n1), Add(), BinOp(UnaryOp(Usub(), right), Add(), inert))
            case _:
              raise Exception ("pe_add has unexpected operation + ", repr(r1))
        case (inert, BinOp(Constant(n1), op, right)):
          match op:
            case Add():
              return BinOp(Constant(n1), Add(), BinOp(right, Add(), inert))
            case Sub():
              return BinOp(Constant(n1), Add(), BinOp(UnaryOp(Usub(), right), Add(), inert))
            case _:
              raise Exception ("pe_add has unexpected operation + ", repr(r1))
        case (inert, Constant(n2)):
          return BinOp(Constant(n2), Add(), inert)
        case _:
          return BinOp(r1, Add(), r2)
  
    def pe_sub(self, r1: expr, r2: expr) -> expr:
      match (r1, r2):
        case (Constant(n1), Constant(n2)):
          return Constant(sub64(n1, n2))
        case (Constant(n1), BinOp(Constant(n2), Add(), right)):
          return BinOp(Constant(sub64(n1, n2)), Sub(), right)
        case (Constant(n1), BinOp(Constant(n2), Sub(), right)):
          return BinOp(Constant(sub64(n1, n2)), Add(), right)
        case (BinOp(Constant(n1), op, right), Constant(n2)):
          return BinOp(Constant(sub64(n1, n2)), op, right)
        case (BinOp(Constant(n1), op1, r1), BinOp(Constant(n2), op2, r2)):
          match (op1, op2):
            case (Add(), Add()):
              return BinOp(Constant(sub64(n1, n2)), Add(), BinOp(r1, Sub(), r2))
            case (Add(), Sub()):
              return BinOp(Constant(sub64(n1, n2)), Add(), BinOp(r1, Add(), r2))
            case (Sub(), Sub()):
              return BinOp(Constant(sub64(n1, n2)), Add(), BinOp(r2, Sub(), r1))
            case (Sub(), Add()):
              return BinOp(Constant(sub64(n1, n2)), Sub(), BinOp(r1, Add(), r2))
            case _:
              raise Exception ("pe_add has unexpected operation + ", repr(r1), repr(r2))
        case (BinOp(Constant(n1), op, right), inert):
           match op:
             case Add():
               return BinOp(Constant(n1), Add(), BinOp(right, Sub(), inert))
             case Sub():
               return BinOp(Constant(n1), Sub(), BinOp(right, Add(), inert))
             case _:
               raise Exception ("pe_add has unexpected operation + ", repr(r1))
        case (inert, BinOp(Constant(n1), op, right)):
          match op:
            case Add():
              return BinOp(Constant(neg64(n1)), Add(), BinOp(intert, Sub(), right))
            case Sub():
              return BinOp(Constant(neg(n1)), Add(), BinOp(inert, Add(), right))
            case _:
              raise Exception ("pe_add has unexpected operation + ", repr(r1))
        case (inert, Constant(n2)):
          return BinOp(Constant(neg64(n2)), Add(), inert)
        case _:
          return BinOp(r1, Sub(), r2)
  
    def pe_exp(self, e: expr, env: Set[expr]) -> expr:
      match e:
        case Name(id):
          return e
        case BinOp(left, Add(), right):
          return self.pe_add(self.pe_exp(left, env), self.pe_exp(right, env))
        case BinOp(left, Sub(), right):
          return self.pe_sub(self.pe_exp(left, env), self.pe_exp(right, env))
        case UnaryOp(USub(), v):
          return self.pe_neg(self.pe_exp(v, env))
        case Constant(value):
          return e
        case Call(Name('input_int'), []):
          return e
  
    def pe_stmt(self, s: stmt, env: Set[expr]) -> stmt:
      match s:
        case Assign([Name(id)], value):
          env[id] = self.pe_exp(value, env)
          return Assign([Name(id)], env[id])
        case Expr(Call(Name('print'), [arg])):
          return Expr(Call(Name('print'), [self.pe_exp(arg, env)]))
        case Expr(value):
          return Expr(self.pe_exp(value, env))
  
    def partial_eval(self, p: Module) -> Module:
      match p:
        case Module(body):
          newBody = [self.pe_stmt(s, {}) for s in body]
          return Module(newBody)

    ############################################################################
    # Remove Complex Operands
    ############################################################################

    def rco_exp(self, e: expr, need_atomic : bool) -> Tuple[expr, Temporaries]:
        match e:
            case Constant(value):
                return e, []
            case Name(id):
                return e, []
            case Call(Name('input_int'),[]):
                newTemp = Name(generate_name('tmp'))
                return newTemp, [Assign([newTemp], Call(Name('input_int'),[]))]
            case UnaryOp(op, operand):
                (varName, varMap) = self.rco_exp(operand, True)
                if need_atomic:
                    newTemp = Name(generate_name('tmp'))
                    return newTemp, varMap + [Assign([newTemp], UnaryOp(op, varName))]
                else:
                    return UnaryOp(op, varName), varMap
            case BinOp(left, op, right):
                (leftVarName, leftVarMap) = self.rco_exp(left, True)
                (rightVarName, rightVarMap) = self.rco_exp(right, True)
                if need_atomic:
                    newTemp = Name(generate_name('tmp'))
                    return newTemp, leftVarMap + rightVarMap + [Assign([newTemp], BinOp(leftVarName, op, rightVarName))]
                else:
                    return BinOp(leftVarName, op, rightVarName), leftVarMap + rightVarMap
            case _:
                raise Exception ('error in rco_exp, unexpected + ', repr(e))

    def rco_stmt(self, s: stmt) -> List[stmt]:
        match s:
            case Expr(Call(Name('print'),[arg])):
                (newVar, varMap) = self.rco_exp(arg, True)
                return varMap + [Expr(Call(Name('print'),[newVar]))]
            case Assign(targets, value):
                (newVar, varMap) = self.rco_exp(value, False)
                return varMap + [Assign(targets, newVar)]
            case Expr(value):
                (newVar, varMap) = self.rco_exp(value, False)
                return varMap + [Expr(newVar)]
            case _:
                raise Exception ('error in rco_stmt, unexpected + ', repr(s)) 

    def remove_complex_operands(self, p: Module) -> Module:
        match p:
            case Module(body):
                stmts = [self.rco_stmt(s) for s in body]
                return Module(sum(stmts, []))
            case _:
                raise Exception ('error in remove_complex_operands + ', repr(p))

    ############################################################################
    # Select Instructions
    ############################################################################

    # The expression e passed to select_arg should furthermore be an atom.
    # (But there is no type for atoms, so the type of e is given as expr.)
    def select_arg(self, e: expr) -> arg:
        match e:
            case Name(id):
                return Variable(id)
            case Constant(value):
                return Immediate(value)
            case _:
                raise Exception ('error in select_arg + ', repr(e))

    def select_op(self, op: operator) -> str:
        match op:
            case Add():
                return 'addq'
            case Sub():
                return 'subq'
            case USub():
                return 'negq'
            case _:
                raise Exception ('error in select_op + ', repr(op))

    def select_stmt(self, s: stmt) -> List[instr]:
        match s:
            case Expr(Call(Name('print'),[arg])):
                return [Instr('movq', [self.select_arg(arg), Reg('rdi')]),
                        Callq(label_name('print_int'), 1)]
            case Expr(value):
                return []
            case Assign([Name(id)], Call(Name('input_int'), [])):
                return [Callq(label_name('read_int'), 0),
                        Instr('movq', [Reg('rax'), self.select_arg(Name(id))])]
            case Assign([Name(id)], UnaryOp(USub(), value)):
                return [Instr('movq', [self.select_arg(value), self.select_arg(Name(id))]),
                        Instr('negq', [self.select_arg(Name(id))])]
            case Assign([Name(id)], BinOp(left, op, right)):
                return [Instr('movq', [self.select_arg(left), Reg('rax')]),
                        Instr(self.select_op(op), [self.select_arg(right), Reg('rax')]),
                        Instr('movq', [Reg('rax'), self.select_arg(Name(id))])]
            case Assign([Name(id)], arg):
                return [Instr('movq', [self.select_arg(arg), self.select_arg(Name(id))])]
            case _:
                raise Exception ('error in select_stmt + ', repr(s))

    def select_instructions(self, p: Module) -> X86Program:
        match p:
            case Module(body):
                stmts = [self.select_stmt(s) for s in body]
                return X86Program(sum(stmts, []))
            case _:
                raise Exception ('error in select_intructions + ', repr(p))

    ############################################################################
    # Assign Homes
    ############################################################################

    def assign_homes_arg(self, a: arg, home: Dict[Variable, arg]) -> arg:
        print(repr(a))
        match a:
            case Immediate(value):
                return a
            case Reg(id):
                return a
            case Variable(id):
                # temp = home.get(id)
                # if temp:
                #     return temp
                # else:
                #     loc = Deref('rbp', -(8 + 8 * len(home)))
                #     home[id] = loc
                #     return loc
                return home[a]
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
            case _:
                raise Exception ('error in assign_homes_instr + ', repr(i))

    def assign_homes(self, p: X86Program) -> X86Program:
        # match p:
        #     case X86Program(body):
        #         variableMap = {}
        #         newInstr = []
        #         for i in body:
        #             newInstr.append(self.assign_homes_instr(i, variableMap))
        #         p = X86Program(newInstr)
        #         p.stack_space = align(8 * len(variableMap), 16)
        #         return p
        #     case _:
        #         raise Exception ('error in assign_homes + ', repr(p))
        match p:
            case X86Program(body):
                live_sets = self.uncover_live(p)
                interference_graph = self.build_interference(p, live_sets)
                move_graph = self.build_move_graph(p)
                colors = self.color_graph(interference_graph, move_graph)
                locations = self.allocate_registers(colors)
                newInstr = []
                for i in body:
                    newInstr.append(self.assign_homes_instr(i, locations))
                p.body = newInstr
                return p
            case _:
                raise Exception ('error in assign_homes + ', repr(p))
                


    ############################################################################
    # Patch Instructions
    ############################################################################

    def patch_instr(self, i: instr) -> List[instr]:
        match i:
            case Instr('movq', (Deref(reg1, offset1), Deref(reg2, offset2))):
                return [Instr('movq', [Deref(reg1, offset1), Reg('rax')]),
                        Instr('movq', [Reg('rax'), Deref(reg2, offset2)])]
            case Instr('movq', (Immediate(value), Deref(reg, offset))):
                if value > (2 ** 16) or value < -(2 ** 16):
                    return [Instr('movq', [Immediate(value), Reg('rax')]),
                            Instr('movq', [Reg('rax'), Deref(reg, offset)])]
                else:
                    return [i]
                return [i]
            case Instr('movq', (arg1, arg2)):
                if arg1 == arg2:
                    return []
                else:
                    return [i]
            case Callq(fun, arity):
                return [i]
            case Instr(operation, (arg1, arg2)):
                return [i]
            case Instr(operation, (arg, )):
                return [i]
            case _:
                raise Exception ('error in patch_instr')

    def patch_instructions(self, p: X86Program) -> X86Program:
        match p:
            case X86Program(body):
                newInstr = []
                for i in body:
                    newInstr.append(self.patch_instr(i)) 
                newInstr = sum(newInstr, [])
                p.body = newInstr
                return p
            case _:
                raise Exception ('error in patch_instructions + ', repr(p))

    ############################################################################
    # Prelude & Conclusion
    ############################################################################

    def prelude_and_conclusion(self, p: X86Program) -> X86Program:
        match p:
            case X86Program(body):
                self.locations_used(p)
                callee_reg = list(p.c)
                addStack = [Instr('pushq', [loc]) for loc in callee_reg]
                removeStack = [Instr('popq', [loc]) for loc in reversed(callee_reg)]
                p.stack_space = align(8*len(p.s) + 8*len(p.c), 16) - 8*len(p.c)
                p.body = addStack + [Instr('pushq', [Reg('rbp')]),
                          Instr('movq', [Reg('rsp'), Reg('rbp')]),
                          Instr('subq', [Immediate(p.stack_space), Reg('rsp')])] + p.body
                p.body = p.body + [Instr('addq', [Immediate(p.stack_space), Reg('rsp')]),
                                   Instr('popq', [Reg('rbp')])] + removeStack + [Instr('retq', [])]
                return p
            case _:
                raise Exception ('error in prelude_and_conclusion + ', repr(p))

    ############################################################################
    # Liveness Analysis (Occurs after Select Instructions)
    ############################################################################

    param_registers = [Reg('rdi'), Reg('rsi'), Reg('rdx'), Reg('rcx'), Reg('r8'), Reg('r9')]
    caller_saved_registers = [Reg('rax'), Reg('rcx'), Reg('rdx'), Reg('rsi'), Reg('rdi'), Reg('r8'), Reg('r9'), Reg('r10'), Reg('r11')]
    callee_saved_registers = [Reg('rsp'), Reg('rbp'), Reg('rbx'), Reg('r12'), Reg('r13'), Reg('r14'), Reg('r15')]

    registers = set(caller_saved_registers + callee_saved_registers)

    def getLoc(self, param) -> Set[location]:
        match param:
            case Variable(id):
                return {param}
            case Reg(s):
                return {param}
            case Deref(loc, offset):
                return {Reg(loc)}
            case Immediate(value):
                return set()
            case _:
                raise Exception ('error in getLoc + ', repr(param))

    def R(self, i: instr) -> Set[location]:
        match i:
            case Instr('movq', args):
                return self.getLoc(args[0])
            case Instr('addq', args):
                return self.getLoc(args[0]) | self.getLoc(args[1])
            case Instr('subq', args):
                return self.getLoc(args[0]) | self.getLoc(args[1])
            case Instr('negq', args):
                return self.getLoc(args[0])
            case Callq(func, arity):
                returnSet = set()
                for n in range(arity):
                    returnSet = returnSet | {self.param_registers[n]}
                return returnSet
            case _:
                raise Exception ('error in R + ', repr(i))
    def W(self, i: instr) -> Set[location]:
        match i:
            case Instr('movq', args):
                return self.getLoc(args[1])
            case Instr('addq', args):
                return self.getLoc(args[1])
            case Instr('subq', args):
                return self.getLoc(args[1])
            case Instr('negq', args):
                return self.getLoc(args[0])
            case Callq(func, arity):
                return set(self.caller_saved_registers)
            case _:
                raise Exception ('error in W + ', repr(i))

    def getBeforeAfter(self, i: instr, prev_before):
        curr_after = prev_before
        curr_before = (curr_after - self.W(i)) | self.R(i) # - is set difference, | is union
        return [curr_before, curr_after]

    def uncover_live(self, p: X86Program) -> Dict[instr : Set[location]]:
        match p:
            case X86Program(body):
                returnDict = {}
                i_before = set()
                for i in reversed(body):
                    i_before, i_after = self.getBeforeAfter(i, i_before)
                    returnDict.update({i : i_after})
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
            case X86Program(body):
                graph = UndirectedAdjList()
                for i in body:
                    self.add_edges(i, graph, afterDict[i])
                for i in body:
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
            case X86Program(body):
                graph = UndirectedAdjList()
                for i in body:
                    self.detect_move(i, graph)
                return graph
            case _:
                raise Exceptions ('error in build_move_graph + ', repr(p))

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
        for i in p.body:
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
                case _:
                    raise Exception ('error in patch_instr')

