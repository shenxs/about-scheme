#lang racket

;;stream 可以看作是一个特殊的数据结构可以用来表示无限的数据
;;可以将它看做是一个无限长的list
;;在实现上来看stream是一个元素加上一个promise
;;通过延时求值像是lazy的方式做到使用时才求值所以即使无限长但是不影响效率

(define nature (stream 0 (+ 1 (stream-filter nature))))

;;延迟一个表达式的求值
;;由于racket不是惰性求值所以实现delay有点困难
(define (delay exp)
  (λ () exp))

(define a-delay
  (delay '(display "hello delay")))

;;求解delay
(define (force a-delay)
  (eval a-delay))


(define (my-nature a)
  (stream-cons a (my-nature (+ 1 a)) ))

(define 0->infinity (my-nature 0))

(define f '())
(define r 0->infinity)

(for ([i (range 0 100)])
  (begin
    (set! f (stream-first r))
    (set! r (stream-rest r))
    (displayln f)))
