from lark import Lark, tree, Token
from ast import *

def parse_lark(program):
    grammar = r"""
    DIGIT: /[0-9]/
    INT: "-"? DIGIT+
    NEWLINE: (/\r/? /\n/)+
    VAR: /([a-zA-Z_][a-zA-Z0-9_]*)/
    
    exp: exp "+" exp_hi -> add
        | exp "-" exp_hi -> sub
        | exp_hi
    
    exp_hi: INT -> int
        | "input_int" "(" ")" -> input_int
        | "-" exp_hi -> usub
        | "(" exp ")" -> paren
        | VAR -> name
    
    stmt: "print" "(" exp ")" -> print
        | exp -> expr
        | VAR "=" exp -> assign
    
    stmt_list: -> empty_stmt
        | stmt NEWLINE stmt_list -> add_stmt
    
    lang_var: stmt_list -> module
    
    %import common.WS_INLINE
    %ignore WS_INLINE
    """
    
    # parser = Lark(grammar, start='lang_var', parser='earley', ambiguity='explicit')
    parser = Lark(grammar, start='lang_var', parser='lalr') 
    return parser.parse(program) 


s = '''x = 10
y = x + 10 - (-12)
z = -2 + (11 - 8)
print(x + y + z - 1)
'''

def parse_tree_to_ast(e):
    if isinstance(e, Token):
        return
    elif e.data == 'int':
        return Constant(int(e.children[0].value))
    elif e.data == 'name':
        return Name(e.children[0].value)
    elif e.data == 'input_int':
        return Call(Name('input_int'), [])
    elif e.data == 'print':
        e1 = e.children[0]
        return Expr(Call(Name('print'), [parse_tree_to_ast(e1)]))
    elif e.data == 'usub':
        e1 = e.children[0]
        return UnaryOp(USub(), parse_tree_to_ast(e1))
    elif e.data == 'paren':
        return parse_tree_to_ast(e.children[0])
    elif e.data == 'expr':
        return Expr(parse_tree_to_ast(e.children[0]))
    elif e.data == 'exp':
        return parse_tree_to_ast(e.children[0])
    elif e.data == 'assign':
        e1, e2 = e.children
        return Assign([Name(e1.value)], parse_tree_to_ast(e2))
    elif e.data == 'add':
        e1, e2 = e.children
        return BinOp(parse_tree_to_ast(e1), Add(), parse_tree_to_ast(e2))
    elif e.data == 'sub':
        e1, e2 = e.children
        return BinOp(parse_tree_to_ast(e1), Sub(), parse_tree_to_ast(e2))
    elif e.data == 'add_stmt':
        e1, e2, e3 = e.children
        first_term = parse_tree_to_ast(e1)
        second_term = parse_tree_to_ast(e3)
        return [first_term] + second_term
    elif e.data == 'empty_stmt':
        return []
    elif e.data == 'module':
        body = parse_tree_to_ast(e.children[0])
        return Module(body)
    else:
        raise Exception('unhandled parse tree', e)

if __name__ == '__main__':
    tree = parse_lark(s)
    print(tree.pretty())
    print(tree)
    print('------------')
    temp = parse_tree_to_ast(tree)
    print(dump(temp))
    print('----------------------')
    print(dump(parse(s)))
