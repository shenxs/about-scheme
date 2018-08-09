#include "error_check.h"
#ifndef builtin_func_h
#define builtin_func_h
#include "type.h"

extern mpc_parser_t *Lispy;

// math
lval *builtin_add(lenv *e, lval *a);
lval *builtin_sub(lenv *e, lval *a);
lval *builtin_mul(lenv *e, lval *a);
lval *builtin_div(lenv *e, lval *a);
lval *builtin_mod(lenv *e, lval *a);
lval *builtin_is_zero(lenv *e,lval *a);
lval *builtin_cmp(lenv *e,lval *a,char* op);
lval *builtin_gt(lenv*e,lval*a);
lval *builtin_ge(lenv*e,lval*a);
lval *builtin_lt(lenv*e,lval*a);
lval *builtin_le(lenv*e,lval*a);

// bool
lval *builtin_and(lenv *e, lval *a);
lval *builtin_or(lenv *e, lval *a);
lval *builtin_not(lenv *e, lval *a);
lval *builtin_is_true(lenv *e, lval *a);

// list oprator
lval *builtin_list(lenv *e, lval *a);
lval *builtin_car(lenv *e, lval *a);
lval *builtin_head(lenv *e, lval *a);
lval *builtin_join(lenv *e, lval *a);
lval *builtin_cdr(lenv *e, lval *a);
lval *builtin_quote(lenv *e,lval *a);

// system
lval *builtin_def(lenv *e, lval *a);
lval *builtin_exit(lenv *e, lval *a);
lval *builtin_eval(lenv *e, lval *a);
lval *builtin_lambda(lenv *e, lval *a);
lval *builtin_put(lenv *e, lval *a);
lval *builtin_var(lenv *e, lval *a, char *func);
lval *builtin_load(lenv *e,lval *a);
lval *builtin_print(lenv *e,lval *a);
lval *builtin_error(lenv *e,lval *a);

lval *builtin_op(lenv *e, lval *a, char *op);

// condition
lval *builtin_if(lenv *e,lval *a);
lval *builtin_equal(lenv *e,lval *a);

//return what it get,get one return one
lval *builtin_value(lenv *e,lval *a);

#endif
