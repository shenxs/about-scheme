#ifndef builtin_func_h
#define builtin_func_h
#include "type.h"

lval* builtin_add(lenv* e,lval* a);
lval* builtin_sub(lenv* e,lval* a);
lval* builtin_mul(lenv* e,lval* a);
lval* builtin_div(lenv* e,lval* a);
lval* builtin_list(lenv* e,lval* a);
lval* builtin_car(lenv* e,lval* a);
lval* builtin_cdr(lenv* e,lval* a);
lval* builtin_def(lenv* e,lval* a);
lval* builtin_exit(lenv* e,lval* a);
lval* builtin_eval(lenv* e,lval* a);

lval *buildin_op(lenv* e, lval *a, char *op);

#endif
