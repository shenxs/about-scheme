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


