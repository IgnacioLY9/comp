import ast
from interp_Lint import *

s = '''
print(f(x + 1) + g(y))
'''
tree = ast.parse(s)

print(ast.dump(tree))

