#include "mpc.h"
#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
#include <string.h>
/* static char buffer[2048] */

/* 自定义readline函数 */
char *
readline(char *prompt) {
  fputs(prompt, stdout);
  fgets(buffer, 2048, stdin);
  char *cpy = malloc(strlen(buffer) + 1);
  strcpy(cpy, buffer);
  cpy[strlen(cpy) - 1] = '\0';
  return cpy;
}

/*  自定义add_history function */
void add_history(char *unused) {}

#else
#include <editline/readline.h>
#endif


/* 前置申明 */

struct lval; //lisp 元素
struct lenv; //lisp 环境

typedef struct lval lval;
typedef struct lenv lenv;

enum { LVAL_NUM, LVAL_ERR, LVAL_SYM, LVAL_SEXPR, LVAL_QEXPR ,LVAL_FUN};

typedef lval*(*lbuildin)(lenv*,lval*); //内建函数

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

struct lenv{
  int count;
  char** syms;
  lval** vals;
};

void  lval_del(lval *v);
lval* lval_copy(lval *v);
lval* lval_err(char *m);
lval eval(mpc_ast_t *t);
lval eval_op(lval x, char *op, lval y);
lval *lval_sym(char *s) ;
lval *lval_fun(lbuildin func);
lval *lval_err(char *m) ;

#define LASSERT(args, cond, fmt, ...)           \
  if (!(cond)) {                                \
    lval* err = lval_err(fmt, ##__VA_ARGS__);   \
    lval_del(args);                             \
    return err;                                 \
  }
lenv* lenv_new(void){
  lenv* e=malloc(sizeof(lenv));
  e->count=0;
  e->syms=NULL;
  e->vals=NULL;
  return e;
}
void  lenv_del(lenv* e){
  for(int i=0;i<e->count;i++){
    free(e->syms[i]);
    lval_del(e->vals[i]);
  }
  free(e->syms);
  free(e->vals);
  free(e);
}
lval* lenv_get(lenv* e,lval*k){
  for(int i=0;i<e->count;i++){
    if(strcmp(e->syms[i],k->sym)==0){
      return lval_copy(e->vals[i]);
    }
  }
  return lval_err("unboud symbol");
}
void lenv_put(lenv* e,lval* k,lval* v){
  for(int i=0;i<e->count;i++){
    if(strcmp(e->syms[i],k->sym)==0){
      lval_del(e->vals[i]);
      e->vals[i]=lval_copy(v);
      return;
    }
  }
  /* 如果不存在此变量则将其添加到环境中 */
  e->count++;
  e->vals = realloc(e->vals,sizeof(lval*)*e->count);
  e->syms = realloc(e->syms,sizeof(lval*)*e->count);

  e->vals[e->count-1] = lval_copy(v);
  e->syms[e->count-1] = malloc(strlen(k->sym)+1);
  strcpy(e->syms[e->count-1], k->sym);

}
lval *lval_num(long x) {
  lval *v = malloc(sizeof(lval));
  v->type = LVAL_NUM;
  v->num = x;
  return v;
}

lval *lval_err(char *m) {
  lval *v = malloc(sizeof(lval));
  v->type = LVAL_ERR;
  v->err = malloc(strlen(m) + 1);
  strcpy(v->err, m);
  return v;
}

lval *lval_sym(char *s) {
  lval *v = malloc(sizeof(lval));
  v->type = LVAL_SYM;
  v->sym = malloc(strlen(s) + 1);
  strcpy(v->sym, s);
  return v;
}

lval *lval_sexpr(void) {
  lval *v = malloc(sizeof(lval));
  v->type = LVAL_SEXPR;
  v->count = 0;
  v->cell = NULL;
  return v;
}

lval *lval_qexpr(void) {
  lval *v = malloc(sizeof(lval));
  v->type = LVAL_QEXPR;
  v->count = 0;
  v->cell = NULL;
  return v;
}

lval *lval_fun(lbuildin func){
  lval* v =malloc(sizeof(lval));
  v->type=LVAL_FUN;
  v->fun=func;
  return v;
}
lval *lval_read_num(mpc_ast_t *t) {
  errno = 0;
  long x = strtol(t->contents, NULL, 10);
  return errno != ERANGE ? lval_num(x) : lval_err("invalid number");
}

lval *lval_add(lval *v, lval *x) {
  v->count++;
  v->cell = realloc(v->cell, sizeof(lval *) * v->count);
  v->cell[v->count - 1] = x;
  return v;
}
lval *lval_read(mpc_ast_t *t) {
  if (strstr(t->tag, "number")) {
    return lval_read_num(t);
  }
  if (strstr(t->tag, "symbol")) {
    return lval_sym(t->contents);
  }

  lval *x = NULL;
  /* tag > 根元素 */
  /* if (strcmp(t->tag, ">") == 0) { */
  /*   x = lval_sexpr(); */
  /* } */
  if (strstr(t->tag, "sexpr")) {
    x = lval_sexpr();
  }
  if (strstr(t->tag, "qexpr")) {
    x = lval_qexpr();
  }
  for (int i = 0; i < t->children_num; i++) {
    if (strcmp(t->children[i]->contents, "(") == 0) {
      continue;
    }
    if (strcmp(t->children[i]->contents, ")") == 0) {
      continue;
    }
    if (strcmp(t->children[i]->contents, "}") == 0) {
      continue;
    }
    if (strcmp(t->children[i]->contents, "{") == 0) {
      continue;
    }
    if (strcmp(t->children[i]->tag, "regex") == 0) {
      continue;
    }
    x = lval_add(x, lval_read(t->children[i]));
  }
  return x;
}
void lval_del(lval *v) {
  switch (v->type) {
  case LVAL_NUM:
  case LVAL_FUN:
    break;
  case LVAL_ERR:
    free(v->err);
    break;
  case LVAL_SYM:
    free(v->sym);
    break;
  case LVAL_SEXPR:
  case LVAL_QEXPR:
    for (int i = 0; i < v->count; i++) {
      free(v->cell[i]);
    }
    free(v->cell);
    break;
  }
  free(v);
}
lval* lval_copy(lval *v) {
  lval* x=malloc(sizeof(lval));
  x->type=v->type;

  switch (v->type) {
  case LVAL_NUM:x->num=v->num;break;
  case LVAL_FUN:x->fun=v->fun;break;
  case LVAL_ERR:
    x->err=malloc(strlen(v->err)+1);
    strcpy(x->err,v->err);
    break;
  case LVAL_SYM:
    x->sym=malloc(strlen(v->sym)+1);
    strcpy(x->sym,v->sym);
    break;
  case LVAL_SEXPR:
  case LVAL_QEXPR:
    x->count=v->count;
    x->cell=malloc(sizeof(lval*)*x->count);
    for (int i = 0; i < v->count; i++) {
      x->cell[i]=lval_copy(v->cell[i]);
    }
    break;
  }
  return x;
}

void lval_print(lval *v);
void lval_expr_print(lval *v, char open, char closen) {
  putchar(open);
  for (int i = 0; i < v->count; i++) {
    lval_print(v->cell[i]);

    if (i != v->count - 1) {
      putchar(' ');
    }
  }
  putchar(closen);
}

void lval_print(lval *v) {
  switch (v->type) {
  case LVAL_NUM:
    printf("%li", v->num);
    break;
  case LVAL_ERR:
    printf("ERROR: %s", v->err);
    break;
  case LVAL_SYM:
    printf("%s", v->sym);
    break;
  case LVAL_SEXPR:
    lval_expr_print(v, '(', ')');
    break;
  case LVAL_QEXPR:
    lval_expr_print(v, '{', '}');
    break;
  case LVAL_FUN:
    printf("<function>");
    break;
  }
}

void lval_println(lval *v) {
  lval_print(v);
  printf("\n");
}

lval *lval_eval_sexpr(lenv* e, lval *v);

lval *lval_eval(lenv* e, lval *v) {
  if(v->type == LVAL_SYM){
    lval* x=lenv_get(e,v);
    lval_del(v);
    return x;
  }

  if (v->type == LVAL_SEXPR) {
    return lval_eval_sexpr(e,v);
  }
  return v;
}

lval *lval_pop(lval *v, int i) {
  lval *x = v->cell[i];

  memmove(&v->cell[i], &v->cell[i + 1], sizeof(lval *) * (v->count - i - 1));
  v->count--;
  v->cell = realloc(v->cell, sizeof(lval *) * v->count);
  return x;
}

lval *lval_take(lval *v, int i) {
  lval *x = lval_pop(v, i);
  lval_del(v);
  return x;
}

lval *buildin_op(lenv* e, lval *a, char *op) {
  /* 确保所有的参数都是数字 */
  for (int i = 0; i < a->count; i++) {
    if (a->cell[i]->type != LVAL_NUM) {
      lval_del(a);
      return lval_err("can not deal with non-number");
    }
  }

  lval *x = NULL;
  if(strcmp(op, "+")==0){
    x=lval_num(0);
  }else if(strcmp(op, "*")==0){
    x=lval_num(1);
  }else if(strcmp(op, "-")==0){
    if(a->count==0){
      lval_del(a);
      return lval_err("sub need at least one param");
    }else if (a->count==1){
      lval* result=lval_num(-1*a->cell[0]->num);
      lval_del(a);
      return result;
    }else{
      x=lval_pop(a, 0);
    }
  }else if(strcmp(op, "/")==0){
    if(a->count==0){
      lval_del(a);
      return lval_err("div need at least one param");
    }else{
      x=lval_pop(a, 0);
    }
  }
  while (a->count > 0) {
    lval *y = lval_pop(a, 0);
    if (strcmp(op, "+") == 0) {
      x->num += y->num;
    }
    if (strcmp(op, "-") == 0) {
      x->num -= y->num;
    }
    if (strcmp(op, "*") == 0) {
      x->num *= y->num;
    }
    if (strcmp(op, "/") == 0) {
      if (y->num == 0) {
        lval_del(x);
        lval_del(y);
        x = lval_err("Division By Zero!");
        break;
      }
      x->num /= y->num;
    }
    lval_del(y);
  }

  lval_del(a);
  return x;
}

lval* builtin_add(lenv* e,lval* a){
  return buildin_op(e, a, "+");
}

lval* builtin_sub(lenv* e,lval* a){
  return buildin_op(e, a, "-");
}
lval* builtin_mul(lenv* e,lval* a){
  return buildin_op(e, a, "*");
}

lval* builtin_div(lenv* e,lval* a){
  return buildin_op(e, a, "/");
}

lval* builtin_list(lenv* e,lval* a){
  lval* v =lval_qexpr();
  for(int i=0;i<a->count;i++){
    lval_add(v, lval_eval(e, a->cell[i]));
  }
  for(int i=0;i<v->count;i++){
    if(v->cell[i]->type==LVAL_ERR){
      lval* err=lval_copy(v->cell[i]);
      lval_del(v);
      return err;
    }
  }
  return v;
}

lval* builtin_car(lenv* e,lval* a){
  /* env,sxpr ==> lval  */
  if(a->count!=1){
    return lval_err("car only take one param");
  }else{
    lval* expr=lval_copy(a->cell[0]);
    if(expr->type!=LVAL_QEXPR){
      lval_del(a);
      lval_del(expr);
      return lval_err("car need qexpr as it's param");
    }
    if(expr->count==0){
      lval_del(a);
      lval_del(expr);
      return lval_err("length of qexpr equals 0");
    }

    lval* result=lval_copy(expr->cell[0]);

    lval_del(expr);
    lval_del(a);
    return result;
  }
}

lval* builtin_cdr(lenv* e,lval* a){
  if(a->count!=1){
    return lval_err("cdr only take one param");
  }else{
    if(a->cell[0]->type!=LVAL_QEXPR){
      return lval_err("cdr need a qexpr as a param");
    }else if(a->cell[0]->count==0){
      return lval_err("qexpr length equals 0");
    }else{
      lval* head= lval_pop(a->cell[0], 0);
      lval_del(head);
      return a->cell[0];
    }
  }
}

lval* builtin_def(lenv* e,lval* a){
  if(a->count<2){
    return lval_err("need at least 2 parma");
  }else if(a->cell[0]->type !=LVAL_QEXPR){
    return lval_err("def passed a incorrect type");
  }

  lval* sym=a->cell[0];

  for(int i=0;i<sym->count;i++){
    lenv_put(e, sym->cell[i], a->cell[i+1]);
  }
  lval_del(a);
  return lval_sym(";)");
}

lval* builtin_eval(lenv* e,lval* a){
  if(a->count==0){
    return lval_err("eval need 1 arg");
  }
  if(a->cell[0]->type!=LVAL_QEXPR){
    return lval_err("eval need a qexpr as arg");
  }
  return lval_eval(e, a->cell[0]->cell[0]);
}

lval* builtin_exit(lenv* e,lval* a){
  exit(0);
}

void lenv_add_builtin(lenv* e,char* name,lbuildin func){
  lval* k = lval_sym(name);
  lval* v=lval_fun(func);
  lenv_put(e,k,v);
  lval_del(k);lval_del(v);
}

void lenv_add_buildins(lenv* e){
  /* List Functions */
  lenv_add_builtin(e, "list", builtin_list);
  lenv_add_builtin(e, "car", builtin_car);
  lenv_add_builtin(e, "cdr", builtin_cdr);
  lenv_add_builtin(e, "eval", builtin_eval);
  lenv_add_builtin(e, "def", builtin_def);
  /* lenv_add_builtin(e, "join", builtin_join); */

  /* Mathematical Functions */
  lenv_add_builtin(e, "+", builtin_add);
  lenv_add_builtin(e, "-", builtin_sub);
  lenv_add_builtin(e, "*", builtin_mul);
  lenv_add_builtin(e, "/", builtin_div);

  /* exit */
  lenv_add_builtin(e, "exit", builtin_exit);
}


lval *lval_eval_sexpr(lenv* e, lval *v) {
  for (int i = 0; i < v->count; i++) {
    v->cell[i] = lval_eval(e,v->cell[i]);
  }

  for (int i = 0; i < v->count; i++) {
    if (v->cell[i]->type == LVAL_ERR) {
      return lval_take(v, i);
    }
  }

  if (v->count == 0) {
    return v;
  }
  /* lval_println(v); */
  /* if(v->count == 1 &&v->cell[0]->type!=LVAL_FUN){ */
  /*   return lval_take(v, 0); */
  /* } */

  lval *f = lval_pop(v, 0);
  if (f->type != LVAL_FUN) {
    lval_del(f);
    lval_del(v);
    return lval_err("first element is not a function");
  }

  lval *result = f->fun(e,v);

  lval_del(f);
  return result;
}

int main(int argc, char **argv) {

  /* 创建parsers */
  mpc_parser_t *Number = mpc_new("number");
  mpc_parser_t *Symbol = mpc_new("symbol");
  mpc_parser_t *Sexpr = mpc_new("sexpr");
  mpc_parser_t *Qexpr = mpc_new("qexpr");
  mpc_parser_t *Expr = mpc_new("expr");
  mpc_parser_t *Lispy = mpc_new("lispy");

  mpca_lang(MPCA_LANG_DEFAULT,
            "                                                     \
    number   : /-?[0-9]+/ ;                                       \
    symbol   : /[a-zA-Z0-9_+\\-*\\/\\\\=<>!&]+/ ;                 \
    sexpr    : '(' <expr>* ')'   ;                                \
    qexpr    : '{' <expr>* '}'   ;                                \
    expr     : <number> | <symbol> | <sexpr> | <qexpr>;           \
    lispy    : /^/  <expr>* /$/ ;                                 \
  ",
            Number, Symbol, Sexpr, Qexpr, Expr, Lispy);

  puts("MyLisp Version 0.0.0.0.1");
  puts("Press Ctrl+c to exit");

  lenv* e=lenv_new();
  lenv_add_buildins(e);

  while (1) {
    char *input = readline(">");

    add_history(input);

    mpc_result_t r;
    if (mpc_parse("<stdin>", input, Lispy, &r)) {
      /* mpc_ast_print(r.output); */
      mpc_ast_t* t=r.output;
      for(int i=0;i<t->children_num;i++){
        if (strcmp(t->children[i]->tag, "regex") == 0) {
          continue;
        }
        lval* x=lval_read(t->children[i]);
        x=lval_eval(e, x);
        lval_println(x);
        lval_del(x);
      }
      mpc_ast_delete(r.output);
    } else {
      mpc_err_print(r.error);
      mpc_err_delete(r.error);
    }
    free(input);
  }

  mpc_cleanup(4, Number, Symbol, Sexpr, Qexpr, Expr, Lispy);

  return 0;
}
