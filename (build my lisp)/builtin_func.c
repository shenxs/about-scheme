#include "builtin_func.h"
#include "error_check.h"

lval* builtin_add(lenv* e,lval* a){
  return builtin_op(e, a, "+");
}

lval* builtin_sub(lenv* e,lval* a){
  return builtin_op(e, a, "-");
}
lval* builtin_mul(lenv* e,lval* a){
  return builtin_op(e, a, "*");
}

lval* builtin_div(lenv* e,lval* a){
  return builtin_op(e, a, "/");
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

// get a Q-Expession and return a Q-expression with only the first element
lval *builtin_head(lenv *e,lval *a){
  LASSERT_NUM("head",a,1);
  LASSERT_TYPE("head",a,0,LVAL_QEXPR);

  lval* result=lval_pop(a->cell[0], 0);
  lval_del(a);

  return lval_add(lval_qexpr(), result);


}

/* 将两个Q-expression 合并为一个 */
lval *builtin_join(lenv *e,lval *a){
  LASSERT_NUM("join",a,2);
  for(int i=0;i<a->count;i++){
    LASSERT_TYPE("join",a,i,LVAL_QEXPR);
  }
  lval* result=lval_copy(a->cell[0]);
  for(int i=0;i<a->cell[1]->count;i++){
    lval_add(result, a->cell[1]->cell[i]);
  }
  lval_del(a);
  return result;
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
  return builtin_var(e,a,"def");
}

lval *builtin_put(lenv *e ,lval *a){
  return builtin_var(e,a,"=");
}

lval *builtin_var(lenv *e ,lval *a,char* func){
  LASSERT(a,a->count!=0,"Function get no argument");
  LASSERT_TYPE(func,a,0,LVAL_QEXPR);

  lval* sym=a->cell[0];
  for(int i=0;i<sym->count;i++){
    LASSERT(a,(sym->cell[i]->type==LVAL_SYM),
            "Function '%s' can not define no-symbol. "
            "Expect %s,Got %s.",
            func,ltype_name(LVAL_SYM), ltype_name(sym->cell[i]->type));
  }

  LASSERT(a,sym->count == a->count-1,
          "Function '%s' get wrong number of argument,"
          "Expect %i,Got %i.",
          func,sym->count+1,a->count);

  for(int i=0;i<sym->count;i++){
    if(strcmp(func,"def")==0){
      lenv_def(e,sym->cell[i],a->cell[i+1]);
    }else if(strcmp(func,"=")==0){
      lenv_put(e,sym->cell[i],a->cell[i+1]);
    }else{
      lval_del(a);
      return lval_err("内部错误");
    }
  }
  lval_del(a);
  return lval_void();

}

lval* builtin_eval(lenv* e,lval* a){

  LASSERT_NUM("eval",a,1);

  lval* x=a->cell[0];

  switch(x->type){
  case LVAL_QEXPR:
    if(a->cell[0]->count==0){
      return lval_take(a,0);
    }
    a->cell[0]->type=LVAL_SEXPR;
    return lval_eval(e, a->cell[0]);
  default:
    return lval_eval(e,a->cell[0]);
  }
}

lval* builtin_exit(lenv* e,lval* a){
  exit(0);
}

lval *builtin_op(lenv* e, lval *a, char *op) {
  /* 确保所有的参数都是数字 */
  for (int i = 0; i < a->count; i++) {
    if (a->cell[i]->type != LVAL_NUM) {
      int type=a->cell[i]->type;
      lval_del(a);
      return lval_err("function %s get incorrect argument .Got %s ,Expect %s.",
                      op,ltype_name(type) ,ltype_name(LVAL_NUM));
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

lval *builtin_lambda(lenv *e, lval *a){
  LASSERT_NUM("lambda" ,a ,2);
  LASSERT_TYPE("lambda",a,0,LVAL_QEXPR);
  LASSERT_TYPE("lambda",a,1,LVAL_QEXPR);

  for(int i=0;i<a->cell[0]->count;i++){
    LASSERT(a,(a->cell[0]->cell[i]->type == LVAL_SYM),
            "Can't define not-symbol. Expect %s. Got %S",
            ltype_name(LVAL_SYM),a->cell[0]->cell[i]->type);
  }

  lval* formals=lval_pop(a,0);
  lval* body=lval_pop(a,0);

  lval_del(a);
  return lval_lambda(formals,body);
}

lval *builtin_is_zero(lenv *e,lval *a){
  LASSERT_NUM("zero?",a,1);
  LASSERT_TYPE("zero?",a,0,LVAL_NUM);

  if(a->cell[0]->num==0){
    return lval_bool("true");
  }else{
    return lval_bool("false");
  }
}

lval *builtin_and(lenv *e, lval *a){
  LASSERT_NUM("and",a,2);
  LASSERT_TYPE("and",a,0,LVAL_BOOL);
  LASSERT_TYPE("and",a,1,LVAL_BOOL);
  if(strcmp(a->cell[0]->sym,"true")==0&&
     strcmp(a->cell[1]->sym,"true")==0){
    return lval_bool("true");
  }else{
    return lval_bool("false");
  }
}


lval *builtin_or(lenv *e, lval *a){
  LASSERT_NUM("or",a,2);
  LASSERT_TYPE("or",a,0,LVAL_BOOL);
  LASSERT_TYPE("or",a,1,LVAL_BOOL);
  if(strcmp(a->cell[0]->sym,"false")==0&&
     strcmp(a->cell[1]->sym,"false")==0){
    return lval_bool("false");
  }else{
    return lval_bool("true");
  }
}

lval *builtin_not(lenv *e, lval *a){
  LASSERT_NUM("not" ,a ,1);
  LASSERT_TYPE("not" ,a ,0,LVAL_BOOL);
  lval* x=lval_take(a,0);
  if(strcmp(x->sym,"true")==0){
    lval_del(x);
    return lval_bool("false");
  }else if(strcmp(x->sym,"false")==0){
    lval_del(x);
    return lval_bool("true");
  }else{
    return lval_err("error in buidin not");
  }
}

lval *builtin_is_true(lenv *e, lval *a){
  LASSERT_NUM("true?",a,1);
  if(a->cell[0]->type!=LVAL_BOOL){
    return lval_bool("false");
  }else{
    return lval_take(a,0);
  }
}

lval *builtin_if(lenv *e,lval *a){
  LASSERT_NUM("if",a,3);
  LASSERT_TYPE("if",a,0,LVAL_BOOL);
  /* LASSERT_TYPE("if",a,1,LVAL_QEXPR); */
  /* LASSERT_TYPE("if",a,2,LVAL_QEXPR); */

  if(strcmp( a->cell[0]->sym , "true")==0){
    if(a->cell[1]->type == LVAL_QEXPR){
      return  builtin_eval(e,lval_add(lval_sexpr(), a->cell[1]));
    }else{
      return lval_take(a,1);
    }
  }else if(strcmp(a->cell[0]->sym ,"false") == 0){
    if(a->cell[2]->type==LVAL_QEXPR){
      return builtin_eval(e,lval_add(lval_sexpr(),a->cell[2]));
    }else{
      return lval_take(a,2);
    }
  }else{
    return lval_err("if got a invalid condition");
  }
}

/* 比较两个数字类型大小 */
lval *builtin_cmp(lenv *e,lval *a,char* op){
  LASSERT_NUM(op,a,2);
  LASSERT_TYPE(op,a,0,LVAL_NUM);
  LASSERT_TYPE(op,a,1,LVAL_NUM);

  lval* n1=a->cell[0];
  lval* n2 = a->cell[1];

  int flag=-1;

  if(strcmp(op,"=?")==0){
    flag=n1->num==n2->num ? 1:0 ;
  }else if(strcmp(op,">")==0){
    flag=n1->num>n2->num ? 1:0 ;
  }else if(strcmp(op,">=")==0){
    flag=n1->num>=n2->num ? 1:0 ;
  }else if(strcmp(op,"<")==0){
    flag=n1->num<n2->num ? 1:0 ;
  }else if(strcmp(op,"<=")){
    flag=n1->num<=n2->num ? 1:0 ;
  }else{
    return lval_err("%s is not defined",op);
  }

  if(flag==1){
    return lval_bool("true");
  }else if(flag==0){
    return lval_bool("false");
  }else{
    return lval_err("buildin_cmp error");
  }
}

lval *builtin_gt(lenv*e,lval*a){
  return builtin_cmp(e,a,">");
}
lval *builtin_ge(lenv*e,lval*a){
  return builtin_cmp(e,a,">=");
}
lval *builtin_lt(lenv*e,lval*a){
  return builtin_cmp(e,a,"<");
}
lval *builtin_le(lenv*e,lval*a){
  return builtin_cmp(e,a,"<=");
}

lval *builtin_equal(lenv *e,lval *a){
  LASSERT_NUM("=?",a,2);
  int flag=lval_eq(a->cell[0],a->cell[1]);
  lval_del(a);
  if(flag){
    return lval_bool("true");
  }else{
    return lval_bool("false");
  }
}

lval *builtin_value(lenv *e,lval *a){
  LASSERT_NUM("value",a,1);
  return lval_take(a,0);
}


lval *builtin_load(lenv *e,lval *a){
  //a := (<string>)
  LASSERT_NUM("load",a,1);
  LASSERT_TYPE("load",a,0,LVAL_STR);

  mpc_result_t r;
  if(mpc_parse_contents(a->cell[0]->str, Lispy, &r)){
    lval* expr =lval_read(r.output);
    mpc_ast_delete(r.output);
    while(expr->count){
      lval *x=lval_eval(e, lval_pop(expr, 0));
      if(x->type==LVAL_ERR) lval_print(x);
      lval_del(x);
    }
    lval_del(a);
    lval_del(expr);

    return lval_void();
  }else{
    char * err_msg=mpc_err_string(r.error);
    mpc_err_delete(r.error);

    lval* err=lval_err("Could not load Libaray '%s' ,Get the error %s", a->cell[0]->str,err_msg);
    free(err_msg);
    lval_del(a);
    return err;
  }
}

lval *builtin_print(lenv *e,lval *a){
  //a:= (<expr>*)
  for(int i=0;i<a->count;i++){
    lval_print(a->cell[i]);putchar(' ');
  }
  putchar('\n');
  lval_del(a);
  return lval_void();
}

lval *builtin_error(lenv *e,lval *a){
  // a := (<string>) a包含错误信息
  LASSERT_NUM("error",a,1);
  LASSERT_TYPE("error",a,0,LVAL_STR);
  lval* err=lval_err(a->cell[0]->str);
  lval_del(a);
  return err;
}
