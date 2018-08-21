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
