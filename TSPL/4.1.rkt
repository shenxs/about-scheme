#lang racket
#|
过程以及变量绑定是构建scheme程序的时候最基本的东西。这章主要描述了创建过程和多变量绑定的一小部分语法
形式。一开始是最基本的值引用和lambda 表达式，然后是变量绑定和赋值，例如define ，letrec，letvalue，set！
其他的绑定和赋值形式不会是主要的，例如命名的let
|#


#|
任何在程序中出现的有可见变量绑定的标识符都是变量。
例如，在define，lambda，let或者其他的变量绑定方式中所定义的标识符
|#

list
(define x 'a)
(list x x)
(let ([x 'b])
  (list x x))
(let ([let 'let]) let)

#|
在顶层程序或者库代码中出现未绑定到变量，关键词，记录名或者其他实体的标识符都是不符合语法规则的。
因为library，顶层程序和lambda或者其他局部主体中的定义的作用域是整个主体，所以不一定要先定义变量
然后才能引用，只要该变量在定义结束时没有真正解析就好了。
|#

;; (define f
;;   (lambda (x)
;;     (g x)))
;; (define g
;;   (lambda (x)
;;     (+ x x)))

#|这是可以的，在定义g之前引用了g|#

;; (define q (g 3))
;; (define g
;;   (lambda (x)
    ;; (+ x x)))
;;由于定义q的时候需要解析g所以这会报错
