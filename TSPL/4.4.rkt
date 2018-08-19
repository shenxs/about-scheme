#lang racket

;;局部绑定

#|
语法：(let ((var expr) ...) body1 body2 ...)
返回最后一个body的值
|#


#|
let建立起局部变量的绑定，每一个var都绑定到对应的expr上。
绑定的变量可以在let的主体里面eval，类似于lambda

let,let*,letrec以及letrec* 非常相似但是有一些略微的区别。
let 表达式中的expr不在var的作用范围内。
let* 以及letrec* ,对于expr的解析顺序不固定,有可能从左向右也有可能从右向左或者任何实现所倾向的顺序
使用let的时候var都是独立的,解析的顺序不重要
|#

(let ([x (* 3.0 3.0)] [y (* 4.0 4.0)])
  (sqrt (+ x y)))

(let ([x 'a] [y '(b c)])
  (cons x y))

(let ([x 0] [y 1])
  (let ([x y] [y x])
    (list x y)))

#|
let 可以从lambda定义
|#
;;以下是一种let的定义方式

#|
(define-syntax let
  (syntax-rules ()
    [(_ ((x e) ...) b1 b2 ...)
     ((lambda (x ...) b1 b2 ...) e ...)]))
|#

;;let还可以有命名的


;; 语法:(let* ((var expr) ...) body1 body2)
;; 返回 body的最后一个表达式

#|
let* 和let比较相似,除了expr是从左向右并且expr在剩下的作用域中有效
使用let* 时注意他是线性依赖并且解析的顺序是很重要的

|#

(let* ([x (* 5.0 5.0)]
       [y (- x (* 4.0 4.0))])
  (sqrt y))

(let ([x 0] [y 1])
  (let* ([x y] [y x])
    (list x y)))

#|
任何 let* 都可以都可以转化为一系列嵌套的let. 以下定义定义了典型的转换

(define-syntax let*
  (syntax-rules ()
    [(_ () e1 e2 ...)
     (let () e1 e2 ...)]
    [(_ ((x1 v1) (x2 v2) ...) e1 e2 ...)
     (let ((x1 v1))
       (let* ((x2 v2) ...) e1 e2 ...))]))

|#


;; 语法:(letrec ((var expr) ...) body1 body2 ...)
;; 返回最后的表达式的值

#|
letrec 和let以及let* ,除了所有的表达式expr作用域都包括在var
letrec 允许定义的相互递归调用

|#

(letrec ([sum (lambda (x)
                (if (zero? x)
                    0
                    (+ x (sum (- x 1)))))])
  (sum 5))

#|
expr 表达式解析的顺序不是固定的,所以程序一定不能在所有的表达式被解析前引用任何由letrec绑定的变量
在lambda出现的变量都不被记为引用,, unless the resulting procedure is applied before all of the values have been computed.
如果违反此限制，则会引发具有条件类型和断言的异常。

一个expr不能有超过一次的返回.也就是说,他不能同时有正常的返回和调用延续获得返回
并且不应该通过调用这样的延续来返回两次。scheme的实现并不要求检查这种违反限制的使用，
但是如果用户这么做了就会得到一个异常

选择使用 letrec而不是let*或let当你需要变量的定义有循环依赖并且解析的顺序是不中要的时候


letrec表达式的形式可以通过let和set!来做到

|#

;; (let ((var #f) ...)
;;   (let ((temp expr) ...)
;;     (set! var temp) ...
;;     (let () body1 body2 ...)))


#|
在这里 temp是新的没有在letrec中出现的变量,每一个temp对应一个(temp expr).
最外面的let先建立起值绑定,绑定的初始值并不重要,所以在这里使用了#f.绑定已经出现了,所以expr中可以
出现这些变量的引用.所以这些expr的解析环境包含这些变量.中间层的let会解析这些表达式并且绑定到临时变量上
,set!将表达式再绑定到对应的变量上。最内层的let就是letrec内部的函数体

这种转换并不强制和限制expr中的解析和赋值。如果做出这种严格限制我们也可以生成更加高效的代码
|#

