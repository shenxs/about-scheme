#ifndef type_h
#define type_h

#include "mpc.h"
/* 前置申明 */

enum { LVAL_NUM, LVAL_ERR, LVAL_SYM, LVAL_SEXPR, LVAL_QEXPR, LVAL_FUN };

struct lval; // lisp 元素
struct lenv; // lisp 环境

typedef struct lval lval;
typedef struct lenv lenv;
typedef lval *(*lbuildin)(lenv *, lval *); //内建函数

/* lisp value */
typedef struct lval {
  int type;

  long num;
  char *err;
  char *sym;
  lbuildin fun;

  int count;
  struct lval **cell;
} lval;

struct lenv {
  int count;
  char **syms;
  lval **vals;
};

lenv *lenv_new(void);
lval *lenv_get(lenv *e, lval *k);
void lenv_put(lenv *e, lval *k, lval *v);

void lval_del(lval *v);
lval *lval_copy(lval *v);

lval *lval_num(long x);
lval *lval_sym(char *s);
lval *lval_fun(lbuildin func);
lval *lval_err(char *fmt, ...);
lval *lval_sexpr(void);
lval *lval_qexpr(void);

lval *lval_add(lval *v, lval *x);
lval *lval_copy(lval *v);
lval *lval_pop(lval *v, int i);

lval *lval_take(lval *v, int i);
void lval_del(lval *v);
char *ltype_name(int t);

lval *lval_read_num(mpc_ast_t *t);
lval *lval_read(mpc_ast_t *t);

void lval_expr_print(lval *v, char open, char closen);
void lval_print(lval *v);
void lval_println(lval *v);

lval eval(mpc_ast_t *t);
lval eval_op(lval x, char *op, lval y);
lval *lval_eval_sexpr(lenv *e, lval *v);
lval *lval_eval(lenv *e, lval *v);

#endif
