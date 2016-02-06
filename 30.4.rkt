#lang racket

;Exercise 413
;相当于从最大的数字开始一个一个向下找
;(min n m) 因为m n的最大公约数必然比最小的小或等于最小的

(define (gdc.v1 m n)
  (local(
         (define (gdc x)
           (cond
             [(= x 1) 1]
             [else (if (= (remainder m x) (remainder n x) 0)
                     x
                     (gdc (sub1 x)))])))
    (gdc (min m n))))
;; (gdc.v1 101135853 45014640)
;实现的方式很烂,但是不至于让电脑运算好几秒

(define (gdc m n)
  (local(
         (define (clever-gdc large small)
           (cond
             [(= 0 small) large]
             [else (clever-gdc small (remainder large small))])))
    (clever-gdc (max m n) (min m n))))
;; (gdc 101135853 45014640)

(define (gdc.v3 m n)
  (local (
          (define (member? n l)
            (cond
              [(empty? l) #f]
              [(= n (first l)) #t]
              [else (member? n (rest l))]))
          (define (divisors n biggest)
            (cond
              [(= 1 biggest) (cons 1 '())]
              [(= 0 (remainder n biggest)) (cons biggest (divisors n (sub1 biggest)))]
              [else (divisors n (sub1 biggest))]))
          (define (largest-commom l1 l2)
            (cond
              [(member? (first l1) l2) (first l1)]
              [else (largest-commom (rest l1) l2)]))
          (define (gdc small large)
            (largest-commom (divisors small small) (divisors large small))))
    (gdc (min m n) (max m n ))))
(gdc.v3 101135853  45014640)
