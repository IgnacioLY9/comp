import ast
from ast import *
from utils import *
from x86_ast import *
import os
from typing import List, Tuple, Set, Dict
from graph import UndirectedAdjList

Binding = Tuple[Name, expr]
Temporaries = List[Binding]


class Compiler:

    ###################################
    #### Partial evaluation
    ###################################

    def pe_neg(self, r):
      match r:
        case Constant(n):
          return Constant(neg64(n))
        case _:
          return UnaryOp(USub(), r)
  
    # add and sub assume residual expressions
    def pe_add(self, r1, r2):
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
  
    def pe_sub(self, r1, r2):
      print(repr(r1), ',', repr(r2))
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
          print("here")
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
  
    def pe_exp(self, e, env):
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
  
    def pe_stmt(self, s, env):
      match s:
        case Assign([Name(id)], value):
          env[id] = self.pe_exp(value, env)
          return Assign([Name(id)], env[id])
        case Expr(Call(Name('print'), [arg])):
          return Expr(Call(Name('print'), [self.pe_exp(arg, env)]))
        case Expr(value):
          return Expr(self.pe_exp(value, env))
  
    def partial_eval(self, p):
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
        match a:
            case Immediate(value):
                return a
            case Reg(id):
                return a
            case Variable(id):
                temp = home.get(id)
                if temp:
                    return temp
                else:
                    loc = Deref('rbp', -(8 + 8 * len(home)))
                    home[id] = loc
                    return loc
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
        match p:
            case X86Program(body):
                variableMap = {}
                newInstr = []
                for i in body:
                    newInstr.append(self.assign_homes_instr(i, variableMap))
                p = X86Program(newInstr)
                p.stack_space = align(8 * len(variableMap), 16)
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
                p.body = [Instr('pushq', [Reg('rbp')]),
                          Instr('movq', [Reg('rsp'), Reg('rbp')]),
                          Instr('subq', [Immediate(p.stack_space), Reg('rsp')])] + p.body
                p.body = p.body + [Instr('addq', [Immediate(p.stack_space), Reg('rsp')]),
                                   Instr('popq', [Reg('rbp')]),
                                   Instr('retq', [])]
                return p
            case _:
                raise Exception ('error in prelude_and_conclusion + ', repr(p))

