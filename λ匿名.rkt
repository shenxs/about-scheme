#lang racket
;原函数
(define (f1 n)
  (cond
    [(= 0 n) 1]
    [else (* n (f1 (- n 1)))]))

;非显示的递归调用
(define (f2_part self n)
  (cond
    [(= n 0) 1]
    [else (* n (self self (- n 1)))]))

(define (f2 n)
  (f2_part f2_part n))

;local 使之成为一个函数

(define (f3 n)
  (local (
          (define (part self n)
            (cond
              [(= n 0) 1]
              [else (* n (self self (- n 1)))]))
          )
    (part part n)))

;加入λ
(define (f4 n)
  ((λ (x) (x x n))
   (λ (f n)
       (if (= n 0) 1 (* n (f f (- n 1)))))))

;去掉函数名

((λ (n)
    ((λ (x) (x x n))
     (λ (f n)
        (if (= n 0 )1 (* n (f f (- n 1))))))) 1000)
