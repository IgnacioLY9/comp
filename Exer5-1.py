from type_check_Lif import *
from ast import *
from interp_Lif import *

tester = TypeCheckLif()

s1 = '''
x = 1

if x == 1:
    print(0)
'''

s2 = '''
1 + 1 + 2
'''

s3 = '''
print(True and True)
'''

s4 = '''
if input_int():
    print(0)
else:
    print(1)
'''

s5 = '''
if input_int() == 11:
    print(11)
else:
    print(0)
'''

s6 = '''
print(11 > 11)
'''

s7 = '''
if print(1 == 1):
    print(0)
else:
    print(1)
'''

s8 = '''
1 > 2 and 1 < 2 or 1 ==1 
'''

s9 = '''
not (not False and not True)
'''

s10 = '''
True and (1 != 2)
'''

programs = [s1,s2,s3,s4,s5,s6,s7,s8,s9,s10]
interp = InterpLif()

for s in programs:
    tree = ast.parse(s)
    ss = tree.body
    print(ast.dump(tree))    

    try:
        tester.type_check_stmts(ss, {})
    except:
        print('type error')
    else:
        print('no error')
        # interp.interp(tree)
        # print('')
