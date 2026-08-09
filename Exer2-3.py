from interp_Lvar import *
import ast

program4 = Module(body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Constant(value=0)])), Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Constant(value=0)]))])

interp = InterpLvar()
interp.interp(program4)

program5 = Module(body=[Assign(targets=[Name(id='x', ctx=Store())], value=Constant(value=9223372036854775807)), Assign(targets=[Name(id='x', ctx=Store())], value=UnaryOp(op=USub(), operand=Name(id='x', ctx=Load()))), Assign(targets=[Name(id='x', ctx=Store())], value=BinOp(left=Name(id='x', ctx=Load()), op=Sub(), right=Constant(value=1))), Assign(targets=[Name(id='x', ctx=Store())], value=UnaryOp(op=USub(), operand=Name(id='x', ctx=Load()))), Expr(value=Call(func=Name(id='print', ctx=Load()), args=[Name(id='x', ctx=Load())]))])

print('----------')
interp.interp(program5)
program6 =Module(body=[Expr(value=Call(func=Name(id='print', ctx=Load()), args=[BinOp(left=Constant(value=9223372036854775808), op=Add(), right=Constant(value=100))]))]) 

print('-----------')
interp.interp(program6)
