#lang racket

;;定义变量
;;变量是不确切的翻译,实际上不像变量一样可以随意赋值.需要使用set!

#|
syntax: (define var expr)
syntax: (define var)
syntax: (define (var0 var1 ...) body1 body2 ...)
syntax: (define (var0 . varr) body1 body2 ...)
syntax: (define (var0 var1 var2 ... . varr) body1 body2 ...)

第一种形式,define将expr 的值绑定到var上.expr不应该有多次返回.不应同时通过普通和延续返回值,也不可以通过两次调用返回.scheme实现不需要检查这一限制,但是如果用户这么做了,将会条件类型&assertion的异常.

第二种形式和(define var unspecified)等价,此处unspecified是一些不确定的值.
剩下的形式都是将var绑定到对应参数和函数体的过程上,语法规则与lambda类似

(define var
  (lambda formals
    body1 body2 ...))

var 就是var0   formals 等价与 var1 var2 var3 ....


定义有可能出现在库的实现中,出现在顶层程序中,也有可能出现在lambda和case-lambda的函数体前.或者任何
可以从lambda推导出来的形式比如let* ,letrec*. 在函数体中出现的任何定义都会在宏展开的时候转换为letrec*

语法定义有可能出现在任何变量定义有出现的地方。
|#

;; (define x 3)
;; (define f (lambda (x y)
;;             (* (+ x y) 2)))
;; (f 5 4)
;; (define (sum-of-squares x y)
;;   (+ (* x x) (* y y)))
;; (sum-of-squares 3 4)


;; (define f
;;   (lambda (x)
;;     (+ x 1)))
;; (let ([x 2])
;;   (define f
;;     (lambda (y)
;;       (+ y x)))
;;   (f 3))

;; (f 3)

#|
一些列的定义可以通过begin表达式包裹起来。以这种形式将定义打包可以出现在任何一般的变量以及语法定义可能出现的地方。这些定义将会被当做分开的，就是说像是没有用begin包裹起来一样。这项特性可以让语法扩展展开成一系列的定义
|#

(define-syntax multi-define-syntax
  (syntax-rules ()
    [(_ (var expr) ...)
     (begin
       (define-syntax var expr)
       ...)]))

(let ()
  (define plus
    (lambda (x y)
      (if (zero? x)
          y
          (plus (sub1 x) (add1 y)))))
  (multi-define-syntax
   (add1 (syntax-rules () [(_ e) (+ e 1)]))
   (sub1 (syntax-rules () [(_ e) (- e 1)])))
  (plus 7 8))


;;很多scheme的repl中合一交互式地输入变量或者定义，又或者从文件载入变量和定义。
#|
这些顶层定义的行为解释不包括在r6rs中，但是在大多是的实现中，只要顶层变量在引用或者赋值前存在就可以。
例如在顶层定义f中使用了g，但是g还没有被定义。大多数实现会假定g是之后会被定义的变量。

(define f
  (lambda (x)
    (g x)))
 如果在f被调用解析之前g被定义了，如果g是一个变量，那么之前的假设就会成立，对于f的调用就会如期执行。

但是如果g被定义为一个语法扩展的关键词，g将会是一个变量的假设就被证明是错误的，如果f在被调用前没有被重新定义，那么scheme的实现会抛出一个异常。

|#




