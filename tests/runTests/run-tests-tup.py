import os
import sys

# sys.path.append('../python-student-support-code')
# sys.path.append('../python-student-support-code/interp_x86')

sys.path.append('../comp')
sys.path.append('../comp/interp_x86')

import compilerTup
import interp_Ltup
import interp_Ctup
import type_check_Ltup
import type_check_Ctup
from utils import run_tests, run_one_test, enable_tracing
from interp_x86.eval_x86 import interp_x86

enable_tracing()

compiler = compilerTup.CompilerTup()

typecheck_L = type_check_Ltup.TypeCheckLtup().type_check
typecheck_C = type_check_Ctup.TypeCheckCtup().type_check

typecheck_dict = {
    'source': typecheck_L,
    'partial_eval': typecheck_L,
    'resolve': typecheck_L,
    'expose_allocation': typecheck_L,
    'remove_complex_operands': typecheck_L,
    'explicate_control': typecheck_C,
}
interpL = interp_Ltup.InterpLtup().interp
interpC = interp_Ctup.InterpCtup().interp
interp_dict = {
    'shrink': interpL,
    'partial_eval': interpL,
    'resolve': interpL,
    'expose_allocation': interpL,
    'remove_complex_operands': interpL,
    'explicate_control': interpC,
    # 'select_instructions': interp_x86,
    # 'assign_homes': interp_x86,
    # 'patch_instructions': interp_x86,
    # 'prelude_and_conclusion': interp_x86,
}

if True:
    run_tests('tup', compiler, 'tup',
              typecheck_dict,
              interp_dict)
    run_tests('while', compiler, 'tup',
              typecheck_dict,
              interp_dict)
    run_tests('if', compiler, 'tup',
              typecheck_dict,
              interp_dict)
    run_tests('var', compiler, 'tup',
              typecheck_dict,
              interp_dict)
else:
    run_one_test(os.getcwd() + '/tests/var/zero.py',
                 'var',
                 compiler,
                 'var',
                 typecheck_dict,
                 interp_dict)
