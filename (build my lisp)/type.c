#include "type.h"

lenv* lenv_new(void){
  lenv* e=malloc(sizeof(lenv));
  e->par=NULL;
  e->count=0;
  e->syms=NULL;
  e->vals=NULL;
  return e;
}

lenv *lenv_copy(lenv* e){
  lenv* n = malloc(sizeof(lenv));
  n->par = e->par;
  n->count= e->count;
  n->syms =malloc((sizeof(char*) * n->count));
  n->vals = malloc((sizeof(lval*))* n->count);
  for(int i=0;i<n->count;i++){
    n->syms[i]=malloc(strlen(e->syms[i])+1);
    strcpy(n->syms[i],e->syms[i]);
    n->vals[i]= lval_copy(e->vals[i]);
  }
  return n;

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
  if(e->par){
    return lenv_get(e->par, k);
  }else{
    return lval_err("unboud symbol %s", k->sym);
  }
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


void lenv_def(lenv* e,lval *k,lval *v){
  /* 定义全局变量 */
  /* 输入 */
  /*   环境,符号,值 */
  while(e->par){
    e=e->par;
  }
  lenv_put(e,k,v);
}

lval *lval_bool(char *s){
  lval* v=malloc(sizeof(lval));
  v->type=LVAL_BOOL;
  if(strcmp(s,"true")==0||strcmp(s,"false")==0){
    v->sym=malloc(sizeof(char)*3);
    strcpy(v->sym,s);
  }else{
    return lval_err("Internal error");
  }
  return v;
}

lval *lval_num(long x) {
  lval *v = malloc(sizeof(lval));
  v->type = LVAL_NUM;
  v->num = x;
  return v;
}

lval *lval_err(char *fmt, ... ) {
  lval *v = malloc(sizeof(lval));
  v->type = LVAL_ERR;

  va_list va;
  va_start(va,fmt);

  v->err=malloc(512);
  vsprintf(v->err,fmt,va);

  v->err=realloc(v->err, strlen(v->err)+1);
  va_end(va);

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
  v->builtin =func;
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
    if(strcmp(t->contents,"true")==0||
       strcmp(t->contents,"false")==0){
      return lval_bool(t->contents);
    }
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
  case LVAL_NUM:break;
  case LVAL_FUN:
    if(!v->builtin){
      lenv_del(v->env);
      lval_del(v->formals);
      lval_del(v->body);
    }
    break;
  case LVAL_ERR:
    free(v->err);
    break;
  case LVAL_BOOL:
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
  case LVAL_FUN:
    if(v->builtin){
      x->builtin=v->builtin;
    }else{
      x->builtin=NULL;
      x->env=lenv_copy(v->env);
      x->formals=lval_copy( v->formals);
      x->body=lval_copy(v->body);
    }
    break;
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
  case LVAL_BOOL:
    printf("%s",v->sym);
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
    if(v->builtin){
      printf("<builtin>");
    }else{
      printf("(lambda ");lval_print(v->formals);
      putchar(' ');lval_print(v->body);putchar(')');
    }
    break;
  }
}

void lval_println(lval *v) {
  lval_print(v);
  printf("\n");
}


lval *lval_eval(lenv* e, lval *v) {
  if(v->type == LVAL_SYM){
    lval* x=lenv_get(e,v);
    lval_del(v);
    return x;
  }

  if (v->type == LVAL_SEXPR) {
    return lval_eval_sexpr(e,v);
  }else{
    return v;
  }
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


char* ltype_name(int t){
  switch(t){
  case LVAL_FUN:return "Function";
  case LVAL_NUM:return "Number";
  case LVAL_ERR:return "Error";
  case LVAL_SYM:return "Symbol";
  case LVAL_QEXPR:return "Q-Expression";
  case LVAL_SEXPR:return "S-Expression";
  case LVAL_BOOL:return "Boolean";
  default:return "UNKONW";
  }
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

  lval *f = lval_pop(v, 0);
  if (f->type != LVAL_FUN) {
    lval* err=lval_err("first element is not a function,"
                       "Expect %s , Got %s ",
                       ltype_name(LVAL_FUN),ltype_name(f->type));

    lval_del(f);
    lval_del(v);
    return err;
  }

  lval *result = lval_call(e, f, v);

  lval_del(f);
  return result;
}

lval *lval_lambda(lval *formals, lval *body){
  lval *v =malloc(sizeof(lval));
  v->type =LVAL_FUN;
  v->builtin=NULL;
  v->env=lenv_new();
  v->formals =formals;
  v->body=body;
  return v;
}

lval *lval_call(lenv *e,lval *f,lval* a){
  /* 内置函数 */
  if(f->builtin){
    return f->builtin(e,a);
  }

  /* 用户自定义函数 */
  int given=a->count;
  int total=f->formals->count;

  while(a->count){
    if(f->formals->count==0){
      return lval_err("Function passed too many arguments. Expect %i,Got %i. ", total,given);
    }
    lval* k=lval_pop(f->formals, 0);

    /* 如果包含&,则将剩下的参数作为一个单一的list传递给&后的形参 */
    if(strcmp(k->sym, "&") ==0 ){
      if(f->formals->count!=1){
        return lval_err("Function formal invalid"
                        "Symbol & is not followed by one single symbol");
      }
      lval* next_formal=lval_pop(f->formals, 0);
      lenv_put(e, next_formal, builtin_list(e, a));
      lval_del(k);lval_del(next_formal);
      break;
    }
    lval* v=lval_pop(a, 0);
    lenv_put(f->env, k, v );

    lval_del(k);
    lval_del(v);
  }

  /* 参数已经被绑定到形参上或者形参为空所以可以释放掉 */
  lval_del(a);
  /* If '&' remains in formal list bind to empty list */
  if (f->formals->count > 0 &&
      strcmp(f->formals->cell[0]->sym, "&") == 0) {

    /* Check to ensure that & is not passed invalidly. */
    if (f->formals->count != 2) {
      return lval_err("Function format invalid. "
                      "Symbol '&' not followed by single symbol.");
    }

    /* Pop and delete '&' symbol */
    lval_del(lval_pop(f->formals, 0));

    /* Pop next symbol and create empty list */
    lval* sym = lval_pop(f->formals, 0);
    lval* val = lval_qexpr();

    /* Bind to environment and delete */
    lenv_put(f->env, sym, val);
    lval_del(sym); lval_del(val);
  }
  if(f->formals->count==0){
    /* 设置上级环境 */
    f->env->par=e;
    return builtin_eval(f->env,lval_add(lval_sexpr(),lval_copy(f->body)));
  }else{
    return lval_copy(f);
  }
}
