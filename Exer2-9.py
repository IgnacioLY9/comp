import ast
from interp_Lvar import *

s = '''
x = 1
y = x + 1
z = (x + 2) + (2 - y)
print(x + 1 - z)
'''
tree = ast.parse(s)
interp_Lvar(tree)
pe_Lvar(tree)
