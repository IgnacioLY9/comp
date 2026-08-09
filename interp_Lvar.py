from ast import *
from utils import input_int
from interp_Lint import InterpLint
from utils import input_int, add64, sub64, neg64

class InterpLvar(InterpLint):
  def interp_exp(self, e, env):
    match e:
      case Name(id):
        return env[id]
      case _:
        return super().interp_exp(e, env)

  def interp_stmt(self, s, env, cont):
    match s:
      case Assign([Name(id)], value):
        env[id] = self.interp_exp(value, env)
        return self.interp_stmts(cont, env)
      case _:
        return super().interp_stmt(s, env, cont)
        
  def interp(self, p):
    match p:
      case Module(body):
        self.interp_stmts(body, {})
      case _:
        raise Exception('interp: unexpected ' + repr(p))

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

  def pe_P_var(self, p):
    match p:
      case Module(body):
        newBody = [self.pe_stmt(s, {}) for s in body]
        return Module(newBody)

def interp_Lvar(ast):
  interp = InterpLvar()
  interp.interp(ast)

def pe_Lvar(ast):
    pe_interp = InterpLvar()
    print()
    print(repr(ast))
    temp = pe_interp.pe_P_var(ast)
    print(repr(temp))
    pe_interp.interp(temp)

if __name__ == "__main__":
  eight = Constant(8)
  neg_eight = UnaryOp(USub(), eight)
  read = Call(Name('input_int'), [])
  ast1_1 = BinOp(read, Add(), neg_eight)
  pr = Expr(Call(Name('print'), [ast1_1]))
  p = Module([pr])
  interp = InterpLvar()
  interp.interp(p)
