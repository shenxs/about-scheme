#lang racket

(require racket/stream)
;;stream 可以看作是一个特殊的数据结构可以用来表示无限的数据
;;可以将它看做是一个无限长的list
;;在实现上来看stream是一个元素加上一个promise
;;通过延时求值像是lazy的方式做到使用时才求值所以即使无限长但是不影响效率


;;延迟一个表达式的求值
;;由于racket不是惰性求值所以实现delay有点困难
;;以下代码并不正确
(define (delay exp)
  (λ () exp))

(define a-delay
  (delay '(display "hello delay")))

;;求解delay
;;实现在racket中并不正确
(define (force a-delay)
  (eval a-delay))

;;n -> stream
;;返回从n开始的stream
(define (my-nature a)
  (stream-cons a (my-nature (+ 1 a)) ))

;;自然数序列
(define 0->infinity (my-nature 0))

(define f '())
(define r 0->infinity)

;; (for ([i (range 0 100)])
;;   (begin
;;     (set! f (stream-first r))
;;     (set! r (stream-rest r))
;;     (displayln f)))


;;stream n -> stream
;;将stream中的前n个取出
(define (stream-take s n)
  (define (iterator s k)
    (cond
      [(equal? empty-stream s) (error "stream长度小于" n)]
      [(= k n) (stream-first s)]
      [else (stream-cons (stream-first s )  (stream-take (stream-rest s ) (add1 k)))]))
  (iterator s 1))


;;stream n -> list
;;将stream的前n个转换为
(define (my-stream->list s n)
  (cond
    [(stream-empty? s) '()]
    [(zero? n) '()]
    [else (cons (stream-first s) (my-stream->list (stream-rest s) (- n 1)))]))


;;list -> stream
;;用list构造一个stream
(define (my-list->stream l)
  (cond
    [(empty? l) empty-stream]
    [else (stream-cons (first l)
                       (my-list->stream (rest l)))]))


;;一些常用的流函数

;;将两个stream相加,如果都是无限的流则不会终止
(define (stream-add s1 s2)
  (cond
    [(stream-empty? s1) empty-stream]
    [(stream-empty? s2) empty-stream]
    [else (stream-cons (+ (stream-first s1)
                          (stream-first s2))
                       (stream-add (stream-rest s1)
                                   (stream-rest s2)))]))


;;使用流定义斐波那契数列


(define fib
  (letrec ([make-stream
            (λ (a b)
              (stream-cons  a (make-stream b (+ a b))))]
           )
    (make-stream 0 1)))


;;可以通过calkin-wilf 数来遍历有理数

(define (midl-see a)
  (display "\t")
  ;(displayln a)
  )

(my-stream->list fib 100)


                      ;;测试模块<f12>
(module+ test
  (require rackunit)
  (display "hello test "))
