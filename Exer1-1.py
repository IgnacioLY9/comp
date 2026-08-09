from interp_Lint import *
import ast

def pe_neg(r):
    match r:
        case Constant(n):
            return Constant(neg64(n))
        case _:
            return UnaryOp(USub(), r)

def pe_add(r1, r2):
    match (r1, r2):
        case (Constant(n1), Constant(n2)):
            return Constant(add64(n1, n2))
        case _:
            return BinOp(r1, Add(), r2)

def pe_sub(r1, r2):
    match (r1, r2):
        case (Constant(n1), Constant(n2)):
            return Constant(sub64(n1, n2))
        case _:
            return BinOp(r1, Sub(), r2)

def pe_exp(e):
    match e:
        case BinOp(left, Add(), right):
            return pe_add(pe_exp(left), pe_exp(right))
        case BinOp(left, Sub(), right):
            return pe_sub(pe_exp(left), pe_exp(right))
        case UnaryOp(USub(), v):
            return pe_neg(pe_exp(v))
        case Constant(value):
            return e
        case Call(Name('input_int'), []):
            return e

def pe_stmt(s):
    match s:
        case Expr(Call(Name('print'), [arg])):
            return Expr(Call(Name('print'), [pe_exp(arg)]))
        case Expr(value):
            return Expr(pe_exp(value))

def pe_P_int(p):
    match p:
        case Module(body):
            new_body = [pe_stmt(s) for s in body]
            return Module(new_body)

# 10 - (11 + 8)

program1 = Module(body=[Expr(value=Call(Name('print'), [BinOp(left=Constant(value=10), op=Sub(), right=BinOp(left=Constant(value=11), op=Add(), right=Constant(value=8)))]))])
interp(program1)

interp(pe_P_int(program1))

# user_input + -(-8)

program2 = Module(body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[BinOp(left=Call(func=Name(id='input_int', ctx=Load())), op=Add(), right=UnaryOp(op=USub(), operand=UnaryOp(op=USub(), operand=(Constant(8)))))]))])

interp(program2)
interp(pe_P_int(program2))

# (10 + (11 - 20) + 9) - 8

program3 = Module(body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[BinOp(left=BinOp(left=BinOp(left=Constant(value=10), op=Add(), right=BinOp(left=Constant(value=11), op=Sub(), right=Constant(value=20))), op=Add(), right=Constant(value=9)), op=Sub(), right=Constant(value=8))]))])

interp(program3)
interp(pe_P_int(program3))

program4 = Module(body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Constant(value=0)])), Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Constant(value=0)]))])

interp(program4)
interp(pe_P_int(program4))
