#lang racket

#|
scheme 的lambda 总是返回一个过程要么接收固定数量的参数，要么接收大于等于某一个数量的参数

(lambda (var1 ... var n) b1 b2)
接收n个参数

（lambda r b1 b2)
接收任意个参数，0到无限

（lambda (var1 .., varn . r) body1 body2 )
接收大于等于n个参数


lambda 并不能直接产生一个过程，接收两个或者三个参数。
更加确切地说lambda不支持可选参数。
可选参数可以通过lambda，长度判断虽然可能显得不那么明显和有效率

case-lambda语法可以直接支持可选参数，同时也支持固定或无限参数。
case-lambda 基于A New Approach to Procedures with Variable Arity 中提到的lambda× 语法


case-lambda 表达式由一系列clause组成，每一个都相当于一个lambda表达式，每个clause都以以一下形式组成
[formals body1 body2 ...]

每一个clause的语法都和lambda一样
case-lambda 表达式产生的过程可以接收的参数的个数，由每个clause能接收的参数共同决定

当一个由lambda-case创建的过程被执行的时候，clause会被挨个查看，并执行第一个能够接收实参的clause
，形参就会和对应的实参绑定，然后执行body1 body2 ...
每个clause 的参数定义和lambda类似合一接收固定参数，也可以是无限参数，又或者是大于等于n个参数
如果lambda-case所定义的过程接收到的参数在所有的clause都无法匹配则会产生&assertion报错

以下过程make-list通过case-lambda 支持可选的填充参数

|#


(define make-list
  (case-lambda
    [(n) (make-list n #f)]
    [(n x)
     (do ([n n (- n 1)] [ls '() (cons x ls)])
         ((zero? n) ls))]))
#|
substring 过程可以通过case-lambda进行扩展，可以支持默认的start，end参数
只提供一个start参数则默认end是字符串结尾
没有start 和end则相当于string-copy
|#

(define substring1
  (case-lambda
    [(s) (substring1 s 0 (string-length s))]
    [(s start) (substring1 s start (string-length s))]
    [(s start end) (substring s start end)]))


;;当只有一个参数提供时也可以将其视为结束参数，而提供和一个默认的开始

(define substring2
  (case-lambda
    [(s) (substring2 s 0 (string-length s))]
    [(s end) (substring2 s 0 end)]
    [(s start end) (substring s start end)]))

;; 也可以直接去掉中间的clause只支持全部提供start end和都不提供的情况

(define substring3
  (case-lambda
    [(s) (substring3 s 0 (string-length s))]
    [(s start end) (substring s start end)]))


