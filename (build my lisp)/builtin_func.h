#ifndef builtin_func_h
#define builtin_func_h
#include "type.h"
#include "error_check.h"

lval *builtin_add(lenv *e, lval *a);
lval *builtin_sub(lenv *e, lval *a);
lval *builtin_mul(lenv *e, lval *a);
lval *builtin_div(lenv *e, lval *a);
lval *builtin_list(lenv *e, lval *a);
lval *builtin_car(lenv *e, lval *a);
lval *builtin_cdr(lenv *e, lval *a);
lval *builtin_def(lenv *e, lval *a);
lval *builtin_exit(lenv *e, lval *a);
lval *builtin_eval(lenv *e, lval *a);
lval *builtin_lambda(lenv *e, lval *a);
lval *builtin_put(lenv *e ,lval *a);
lval *builtin_var(lenv *e ,lval *a,char* func);

lval *builtin_op(lenv *e, lval *a, char *op);

#endif
