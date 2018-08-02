#include<stdio.h>
#include <stdlib.h>
#include "mpc.h"

#ifdef _WIN32
#include <string.h>
static char buffer[2048]

/* 自定义readline函数 */
char* readline(char* prompt){
  fputs(prompt, stdout);
  fgets(buffer, 2048, stdin);
  char* cpy = malloc(strlen(buffer)+1);
  strcpy(cpy, buffer);
  cpy[strlen(cpy)-1] = '\0';
  return cpy;
}

/*  自定义add_history function */
void add_history(char* unused) {}

#else
#include <editline/readline.h>
#endif


/* lisp value */
typedef struct lval{
  int type;
  long num;

  char* err;
  char* sym;

  int count;
  struct lval **cell;
} lval;

lval eval(mpc_ast_t* t);
lval eval_op(lval x,char* op ,lval y);
enum {LVAL_NUM,LVAL_ERR,LVAL_SYM,LVAL_SEXPR};
enum {LERR_DIV_ZERO,LERR_BAD_OP,LERR_BAD_NUM};

lval* lval_num(long x){
  lval *v=malloc(sizeof(lval));
  v->type=LVAL_NUM;
  v->num=x;
  return v;
}

lval* lval_err(char* m){
  lval *v=malloc(sizeof(lval));
  v->type=LVAL_ERR;
  v->err=malloc(strlen(m)+1);
  strcpy(v->err,m);
  return v;
}

lval* lval_sym(char* s){
  lval *v = malloc(sizeof(lval));
  v->type=LVAL_SYM;
  v->sym=malloc(strlen(s)+1);
  strcpy(v->sym,s);
  return v;
}

lval * lval_sexpr(void){
  lval * v = malloc(sizeof(lval));
  v->type =LVAL_SEXPR;
  v->count=0;
  v->cell=NULL;
  return v;
}

void lval_del(lval* v){
  switch(v->type){
  case LVAL_NUM:break;
  case LVAL_ERR: free(v->err);break;
  case LVAL_SYM: free(v->sym);break;

  case LVAL_SEXPR:
    for(int i=0;i<v->count;i++){
      free(v->cell[i]);
    }
    free(v->cell);
    break;
  }
  free(v);
}

lval* lval_read_num(mpc_ast_t* t){
  errno =0;
  long x= strtol(t->contents,NULL,10);
  return errno != ERANGE ?
    lval_num(x) : lval_err("invalid number");
}

lval* lval_add(lval* v,lval* x){
  v->count++;
  v->cell = realloc(v->cell, sizeof(lval*)*v->count);
  v->cell[v->count-1]=x;
  return v;
}

lval* lval_read(mpc_ast_t* t){
  if(strstr(t->tag,"number")){return lval_read_num(t);}
  if(strstr(t->tag,"symbol")){return lval_sym(t->contents);}

  lval* x=NULL;
  if(strcmp(t->tag,">")==0){x=lval_sexpr();}
  if(strcmp(t->tag,"sexpr")){x=lval_sexpr();}
  for (int i = 0; i < t->children_num; i++) {
    if (strcmp(t->children[i]->contents, "(") == 0) { continue; }
    if (strcmp(t->children[i]->contents, ")") == 0) { continue; }
    if (strcmp(t->children[i]->contents, "}") == 0) { continue; }
    if (strcmp(t->children[i]->contents, "{") == 0) { continue; }
    if (strcmp(t->children[i]->tag,  "regex") == 0) { continue; }
    x = lval_add(x, lval_read(t->children[i]));
  }
  return x;
}


void lval_print(lval *v);
void lval_expr_print(lval* v,char open,char closen){
  putchar(open);
  for(int i=0;i<v->count;i++){
    lval_print(v->cell[i]);

    if(i!=v->count-1){
      putchar(' ');
    }
  }
  putchar(closen);
}

void lval_print(lval *v){
  switch(v->type){
  case LVAL_NUM:
    printf("%li",v->num);break;
  case LVAL_ERR:
    printf("ERROR: %s", v->err );
    break;
  case LVAL_SYM:
    printf("%s", v->sym );
    break;
  case LVAL_SEXPR:
    lval_expr_print(v, '(', ')');
    break;
  }
}

void lval_println(lval *v){
  lval_print(v);printf("\n");
}

int main(int argc,char** argv){

  /* 创建parsers */
  mpc_parser_t* Number = mpc_new("number");
  mpc_parser_t* Symbol= mpc_new("symbol");
  mpc_parser_t* Sexpr= mpc_new("sexpr");
  mpc_parser_t* Expr= mpc_new("expr");
  mpc_parser_t* Lispy=mpc_new("lispy");

  mpca_lang(MPCA_LANG_DEFAULT,
            "                                                     \
    number   : /-?[0-9]+/ ;                                       \
    symbol   : '+' | '-' | '*' | '/' | '%' | \"add\" | \"sub\" | \"mul\" | \"div\"; \
    sexpr    : '(' <expr>* ')'   ;\
    expr     : <number> | <symbol> | <sexpr> ;\
    lispy    : /^/  <expr>* /$/ ;             \
  ",
            Number,Symbol,Sexpr,Expr,Lispy);

  puts("MyLisp Version 0.0.0.0.1");
  puts("Press Ctrl+c to exit");

  while(1){
    char *input= readline("lispy>");

    add_history(input);

    mpc_result_t r;
    if(mpc_parse("<stdin>", input, Lispy, &r)){
      lval* x= lval_read(r.output);
      lval_println(x);
      mpc_ast_delete(r.output);
    }else{
      mpc_err_print(r.error);
      mpc_err_delete(r.error);
    }
    free(input);
  }

  mpc_cleanup(4, Number,Symbol,Sexpr,Expr,Lispy);

  return 0;
}

/* lval eval(mpc_ast_t* t){ */
/*   /\* 数字直接返回值 *\/ */
/*   if(strstr(t->tag, "number")){ */
/*     errno = 0; */
/*     long x = strtol(t->contents, NULL, 10); */
/*     return errno !=ERANGE ? lval_num(x):lval_err(LERR_BAD_NUM); */
/*   } */

/*   /\* 表达式，计算其值 *\/ */
/*   char* op=t->children[1]->contents; */

/*   lval x =eval(t->children[2]); */

/*   int i=3; */
/*   while(strstr(t->children[i]->tag, "expr")){ */
/*     x=eval_op(x, op, eval(t->children[i])); */
/*     i++; */
/*   } */
/*   return x; */

/* } */

/* lval eval_op(lval x, char* op, lval y) { */

/*   if(x.type ==LVAL_ERR) return x; */
/*   if(y.type ==LVAL_ERR) return y; */

/*   if (strcmp(op, "+") == 0 || strcmp(op, "add") == 0) { return lval_num( x.num + y.num); } */
/*   if (strcmp(op, "-") == 0 || strcmp(op, "sub") == 0) { return lval_num( x.num - y.num); } */
/*   if (strcmp(op, "*") == 0 || strcmp(op, "mul") == 0) { return lval_num( x.num * y.num); } */
/*   if (strcmp(op, "/") == 0 || strcmp(op, "div") == 0) { */
/*     if(y.num!=0){ */
/*       return lval_num( x.num/y.num); */
/*     }else{ */
/*       return lval_err(LERR_DIV_ZERO); */
/*     } */
/*   } */
/*   if (strcmp(op, "%") == 0) { return lval_num( x.num % y.num); } */
/* } */
