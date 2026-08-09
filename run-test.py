import os
import sys

sys.path.append('../python-student-support-code')
sys.path.append('../python-student-support-code/interp_x86')

import compilerTup
import interp_Ltup
import interp_Ctup
import type_check_Ltup
import type_check_Ctup
from utils import run_tests, run_one_test, enable_tracing
from interp_x86.eval_x86 import interp_x86

enable_tracing()

compiler = compilerTup.CompilerTup()

typecheck_Ltup = type_check_Ltup.TypeCheckLtup().type_check
typecheck_Ctup = type_check_Ctup.TypeCheckCtup().type_check

typecheck_dict = {
    'source': typecheck_Ltup,
    'partial_eval': typecheck_Ltup,
    'expose_allocation': typecheck_Ltup,
    'remove_complex_operands': typecheck_Ltup,
    'explicate_control': typecheck_Ctup,
}
interpLtup = interp_Ltup.InterpLtup().interp
interpCtup = interp_Ctup.InterpCtup().interp
interp_dict = {
    'shrink': interpLtup,
    'partial_eval': interpLtup,
    'expose_allocation': interpLtup,
    'remove_complex_operands': interpLtup,
    'explicate_control': interpCtup,
    # 'select_instructions': interp_x86,
    # 'assign_homes': interp_x86,
    # 'patch_instructions': interp_x86,
    'prelude_and_conclusion': interp_x86,
}

run_one_test(os.getcwd() + '/tests/tup/t1.py',
                 'tup',
                 compiler,
                 'tup',
                 typecheck_dict,
                 interp_dict)
