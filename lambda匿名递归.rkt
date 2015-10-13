#lang racket

;http://shellfly.org/blog/2015/01/07/yi-the-y-combinator-slight-return/

;阶乘函数
;Number->N!
(define (f n)
  (cond
    [(= 0 n) 1]
    [else (* n (f (- n 1)))]))

;;将上面的显示的自我调用的递归函数变成通过λ实现的匿名递归
(define almost_factorial
  (lambda (f)
    (lambda (n)
      (if (= n 0)
          1
          (* n (f (- n 1)))))))

(define almost_fibonacci
  (lambda (f)
    (lambda (n)
      (cond ((= n 0) 0)
            ((= n 1) 1)
            (else (+ (f (- n 1)) (f (- n 2))))))))

;目的实现Y
;(define fibonacci (Y almost_fibonacci))
;(define factorial (Y almost_factorial))

;almost_f -> f
;f是我想要的递归函数
;(Y almost_f)<==>f
;(almost_f f)<==>f
;(Y almost_f)<==>(almost_f f)<==>(almost_f (Y almost_f))
;(λ (almost_f) (almost_f (Y almost_f))))
;(λ (x) (x x))
(define (Y0 f)
  (f (Y0 f)))

(define Y
  (lambda (f)
    (lambda (x) (x x)
      (lambda (x) (f (lambda (y) ((x x) y)))))))


(define (Y2 f)
    (f (λ (x) (x (Y2 x)))))

(define eternity
    (lambda (x)
      (eternity x)))  

(((lambda (n!)     ;; 展开后成为 n0! 函数
   (lambda (n)
     (cond
       [(zero? n) 1]
       [else (* n (n! (- n 1)))])))
 eternity) 4)


((lambda (f)        ;; 函数 n1!
   (lambda (n)
     (cond
       [(zero? 0) 1]
       [else (* n (f (- n 1)))])))
 ((lambda (n!)      ;; 函数 n0!
   (lambda (n)
     (cond
       [(zero? n) 1]
       [else (* n (n! (- n 1)))])))
  eternity))

((lambda (f)         ;; 函数 n<=2!
   (lambda (n)
     (cond
       [(zero? n) 1]
       [else (* n (f (- n 1)))])))
 ((lambda (f)        ;; 函数 n<=1!
   (lambda (n)
     (cond
       [(zero? 0) 1]
       [else (* n (f (- n 1)))])))
  ((lambda (n!)      ;; 函数 n0!
    (lambda (n)
      (cond
        [(zero? n) 1]
        [else (* n (n! (- n 1)))])))
  eternity)))