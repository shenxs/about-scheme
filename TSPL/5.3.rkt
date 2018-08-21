#lang racket

;; 条件

#|
(if test a b)
(if test a)
根据test的值决定返回a或者b的值

test a b必须是表达式。如果test是真则返回a，如果test是假则返回b。
在第二种形式中，如果没有b那么结果是不特定的。
|#

(let ([ls '(a b c)])
  (if (null? ls)
      '()
      (cdr ls)))

(let ([ls '()])
  (if (null? ls)
      '()
      (cdr ls)))

(let ([abs
       (lambda (x)
         (if (< x 0)
             (- 0 x)
             x))])
  (abs -4))


(let ([x -4])
  (if (< x 0)
      (list 'minus (- 0 x))
      (list 'plus 4)))


;; (not obj)
;; 布尔操作 非
;;
;; not 操作等价于
;;(lambda (x) (if x #t #f))


;; and
;; (and expr ... )

#|
如果没有任何子表达式，and会返回#t.不然的话，and会
从左向右依次解析表达式，直到只剩下一个表达式或者有子表达式返回#f
如果有子表达式返回#f那么剩下的表达式不会再被解析直接返回#f
如果只剩下一个表达式那么返回最后一个子表达式的值

|#

(and #f '(a b) '(c d))

(and '(a b) '(c d) '(e f))


#|
(or expr1 expr2 ...)
如果没有任何子表达式，or返回#f
否则or会逐个解析子表达式，直到只剩下一个子表达式或者有除了#f之外的值返回
如果只剩下一个表达式，那么最后一个表达式会被解析然后返回最后一个表达式的值。
如果有除了#f以外的值出现那么or会返回那个值
|#

(or #f 'a 'b)




;;语法：(cond clause1 clause2 ...)
;; 每个clause必须是以下的形式之一

#|
(test)
(test expr1 expr2 ...)
(test => expr)

最后一种clause可能是以上的任何一种形式，或者可能是一个else的clause
(else expr1 expr2 ...)

所有的clause的test都会被按顺序解析直到有一个为真或者所有的test都解析完了。、
如果是第一种形式的clause的test为真则返回真
如果是第二种形式，那么expr1，expr2 会依次执行，然后最后一个表达式的值被返回
如果是第三种形式，那么expr应该是一个只接受一个参数的过程，会将此过程应用于test的值，这个应用的返回值会作为返回值。

如果没有一个test是#t也米有else clause存在，那么返回值是不确定的

|#


(let ([x 0])
  (cond
    [(< x 0) (list 'minus (abs x))]
    [(> x 0) (list 'plus x)]
    [else (list 'zero x)]))


(define select
  (lambda (x)
    (cond
      [(not (symbol? x))]
      [(assq x '((a . 1) (b . 2) (c . 3))) => cdr]
      [else 0])))

(select 3)
(select 'b)
(select 'e)



;;语法：else
;;语法：=>

#|
这是cond的辅助关键词，同时也是guard，case的辅助关键词
任何其他不是作为辅助关键词的使用都是语法错误
|#


;;语法：(when test-expr expr1 expr2 ...)
;;语法：(unless test expr1 expr2 ...)


#|
对于when来说当 test-expr是真的时候那么expr1 expr2就会依次执行
最后一个表达式的值会作为返回值
如果test-expr的值是#f那么没有任何后续的表达式会被执行，when的返回值将会是不确定的


对于unless ，如果test是false，那么expr1 expr2 ...会依次执行，最后一个表达式的值会被返回
，如果test的值是真那么没有表达式会被执行，返回值不确定

|#
(let ([x -4] [sign 'plus])
  (when (< x 0)
    (set! x (- 0 x))
    (set! sign 'minus))
  (list sign x))

(define check-pair
  (lambda (x)
    (unless (pair? x)
      (error 'check-pair "invalid argument" x))
    x))

(check-pair '(a b c))


#|可以像这样定义when和unless
(define-syntax when
  (syntax-rules ()
    [(_ e0 e1 e2 ...)
     (if e0 (begin e1 e2 ...))]))


(define-syntax unless
  (syntax-rules ()
    [(_ e0 e1 e2 ...)
     (if (not e0) (begin e1 e2 ...))]))


可以用when来定义unless

(define-syntax unless
  (syntax-rules ()
    [(_ e0 e1 e2 ...)
     (when (not e0) e1 e2 ...)]))

|#


;;语法：(case expr0 clause1 clause2)


#|
每一个clause除了最后一个必须以下面的形式呈现
((key ...) expr1 expr2 ...)

每一个clause的datum的值都是不一样的，最后一个clause的可以使以上亿的形式，也可以是else。

expr0的值会被解析，然后和每一个clause的key使用eqv？比较。如果某一个clause存在相匹配的key，那么expr1 ，expr2 。。。 就会被执行，序列的最后一个表达式的值就会被返回

如果没有匹配则进入else，都没有那么返回值不确定。



|#

(let ([x 4] [y 5])
  (case (+ x y)
    [(1 3 5 7 9) 'odd]
    [(0 2 4 6 8) 'even]
    [else 'out-of-range]))


