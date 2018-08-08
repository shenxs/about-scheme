#include "mpc.h"

mpc_parser_t *Number;
mpc_parser_t *Symbol;
mpc_parser_t *String;
mpc_parser_t *Comment;
mpc_parser_t *Sexpr;
mpc_parser_t *Qexpr;
mpc_parser_t *Expr;
mpc_parser_t *Lispy;

#include "builtin_func.h"
#include "type.h"
#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
#include <string.h>
/* static char buffer[2048] */

/* 自定义readline函数 */
char *readline(char *prompt) {
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

void lenv_add_builtin(lenv *e, char *name, lbuildin func) {
  lval *k = lval_sym(name);
  lval *v = lval_fun(func);
  lenv_put(e, k, v);
  lval_del(k);
  lval_del(v);
}

void lenv_add_buildins(lenv *e) {
  /* List Functions */
  lenv_add_builtin(e, "list", builtin_list);
  lenv_add_builtin(e, "head", builtin_head);
  lenv_add_builtin(e, "join", builtin_join);
  lenv_add_builtin(e, "car", builtin_car);
  lenv_add_builtin(e, "cdr", builtin_cdr);

  /* Mathematical Functions */
  lenv_add_builtin(e, "+", builtin_add);
  lenv_add_builtin(e, "-", builtin_sub);
  lenv_add_builtin(e, "*", builtin_mul);
  lenv_add_builtin(e, "/", builtin_div);
  lenv_add_builtin(e, "zero?", builtin_is_zero);
  lenv_add_builtin(e, ">", builtin_gt);
  lenv_add_builtin(e, ">=", builtin_ge);
  lenv_add_builtin(e, "<", builtin_lt);
  lenv_add_builtin(e, "<=", builtin_le);

  /* logical */
  lenv_add_builtin(e, "and", builtin_and);
  lenv_add_builtin(e, "or", builtin_or);
  lenv_add_builtin(e, "not", builtin_not);
  lenv_add_builtin(e, "true?", builtin_is_true);

  /* other */
  lenv_add_builtin(e, "eval", builtin_eval);
  lenv_add_builtin(e, "def", builtin_def);
  lenv_add_builtin(e, "lambda", builtin_lambda);
  lenv_add_builtin(e, "value", builtin_value);
  lenv_add_builtin(e, "if", builtin_if);
  lenv_add_builtin(e, "=?", builtin_equal);
  lenv_add_builtin(e, "exit", builtin_exit);
  lenv_add_builtin(e, "load", builtin_load);
  lenv_add_builtin(e, "print", builtin_print);
  lenv_add_builtin(e, "error", builtin_error);


  lenv_add_builtin(e, "=", builtin_put);
}

int main(int argc, char **argv) {

  /* 初始化parsers */
  Number = mpc_new("number");
  Symbol = mpc_new("symbol");
  Sexpr = mpc_new("sexpr");
  Qexpr = mpc_new("qexpr");
  Expr = mpc_new("expr");
  Lispy = mpc_new("lispy");
  String = mpc_new("string");
  Comment = mpc_new("comment");

  mpca_lang(MPCA_LANG_DEFAULT,
            "number   : /-?[0-9]+/ ;                                    \
             symbol   : /[a-zA-Z0-9_+\\-*\\/\\\\=<>!&?]+/ ;             \
             string   : /\"(\\\\.|[^\"])*\"/ ;                          \
             comment  : /;[^\\r\\n]*/ ;                                 \
             sexpr    : '(' <expr>* ')'   ;                             \
             qexpr    : '{' <expr>* '}'   ;                             \
             expr     : <comment>| <number> | <symbol> |<string>|<sexpr> | <qexpr>; \
             lispy    : /^/  <expr>* /$/ ;                              \
  ",
            Number, Symbol, String, Sexpr, Qexpr, Expr, Lispy, Comment);


  lenv *e = lenv_new();
  lenv_add_buildins(e);

  if(argc >=2){
    for(int i=1;i<argc;i++){
      lval* arg = lval_add(lval_sexpr(), lval_str(argv[i]));
      lval* x= builtin_load(e, arg);
      if(x->type==LVAL_ERR){lval_print(x);}
      lval_del(x);
    }
    return 0;
  }

  puts("MyLisp Version 0.0.0.0.1");
  puts("Press Ctrl+c to exit\n");
  while (1) {
    char *input = readline(">");

    add_history(input);

    mpc_result_t r;
    if (mpc_parse("<stdin>", input, Lispy, &r)) {
      /* mpc_ast_print(r.output); */
      mpc_ast_t *t = r.output;
      for (int i = 0; i < t->children_num; i++) {
        if (strcmp(t->children[i]->tag, "regex") == 0) {
          continue;
        }
        if (strstr(t->children[i]->tag, "comment")) {
          continue;
        }
        lval *x = lval_read(t->children[i]);
        x = lval_eval(e, x);
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

  mpc_cleanup(8, Number, Symbol, String, Sexpr, Qexpr, Expr, Lispy, Comment);

  return 0;
}
