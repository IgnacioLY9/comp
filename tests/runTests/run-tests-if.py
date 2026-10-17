import os
import sys

# sys.path.append('../python-student-support-code')
# sys.path.append('../python-student-support-code/interp_x86')

sys.path.append('../comp')
sys.path.append('../comp/interp_x86')

import compilerIf
import interp_Lif
import interp_Cif
import type_check_Lif
import type_check_Cif
from utils import run_tests, run_one_test, enable_tracing
from interp_x86.eval_x86 import interp_x86

# enable_tracing()

compiler = compilerIf.CompilerIf()

typecheck_L = type_check_Lif.TypeCheckLif().type_check
typecheck_C = type_check_Cif.TypeCheckCif().type_check

typecheck_dict = {
    'source': typecheck_L,
    'partial_eval': typecheck_L,
    'resolve': typecheck_L,
    'expose_allocation': typecheck_L,
    'remove_complex_operands': typecheck_L,
    'explicate_control': typecheck_C,
}
interpL = interp_Lif.InterpLif().interp
interpC = interp_Cif.InterpCif().interp
interp_dict = {
    'shrink': interpL,
    'partial_eval': interpL,
    'remove_complex_operands': interpL,
    'explicate_control': interpC,
    'select_instructions': interp_x86,
    'assign_homes': interp_x86,
    'patch_instructions': interp_x86,
    'prelude_and_conclusion': interp_x86,
}

if True:
    run_tests('if', compiler, 'if',
              typecheck_dict,
              interp_dict)
    run_tests('var', compiler, 'if',
              typecheck_dict,
              interp_dict)
else:
    run_one_test(os.getcwd() + '/tests/var/zero.py',
                 'var',
                 compiler,
                 'var',
                 typecheck_dict,
                 interp_dict)
