#include "builtin_func.h"
#include "mpc.h"
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
  lenv_add_builtin(e, "car", builtin_car);
  lenv_add_builtin(e, "cdr", builtin_cdr);
  lenv_add_builtin(e, "eval", builtin_eval);
  lenv_add_builtin(e, "def", builtin_def);
  lenv_add_builtin(e, "lambda", builtin_lambda);

  /* Mathematical Functions */
  lenv_add_builtin(e, "+", builtin_add);
  lenv_add_builtin(e, "-", builtin_sub);
  lenv_add_builtin(e, "*", builtin_mul);
  lenv_add_builtin(e, "/", builtin_div);

  /* exit */
  lenv_add_builtin(e, "exit", builtin_exit);
  lenv_add_builtin(e, "=", builtin_put);
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

  lenv *e = lenv_new();
  lenv_add_buildins(e);

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

  mpc_cleanup(4, Number, Symbol, Sexpr, Qexpr, Expr, Lispy);

  return 0;
}
