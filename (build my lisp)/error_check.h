#ifndef error_check
#define error_check

/* 断言 */
#define LASSERT(args, cond, fmt, ...)           \
  if (!(cond)) {                                \
    lval *err = lval_err(fmt, ##__VA_ARGS__);   \
    lval_del(args);                             \
    return err;                                 \
  }

/* 判断表达式的长度 */
#define LASSERT_NUM(func,args,num)                                  \
  LASSERT(args,args->count==num,                                    \
          "Function '%s' is passed incorrect number of argument. "  \
          "Expected %i , Got %i",                                   \
          func,num,args->count)

/* 判断参数的类型 */
#define LASSERT_TYPE(func,args,position,t)                           \
  LASSERT(args,(args->cell[position]->type)==t,                      \
          "Function '%s' passed an incrorrect type of args at %i. "     \
          "Expected %s , Got %s",                                       \
          func,position,ltype_name(t),ltype_name(args->cell[position]->type))

#define LASSERT_NOT_EMPTY(func,args,index)            \
  LASSERT(args,args->cell[index]->count!=0,           \
          "Function '%s' passed {} for argument %i",  \
          func,index)

#endif
