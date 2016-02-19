#lang racket


;Exercise 478

(define big-list
  (local ((define (build n)
            (cond
              [(= 1 n) (cons 1 '())]
              [else (cons n (build (sub1 n)))])))
    (build 100000)))

(define (product.v1 l)
  (cond
    [(empty? l) 1]
    [else (* (first l) (product.v1  (rest l)))]))

(define (product.v2 l)
  (local(
         (define (product/a l a)
           (cond
             [(empty? l) a]
             [else (product/a (rest l) (* a (first l)))])))
    (product/a l 1)))


;; (time (product.v1 big-list) #t)
;; (time (product.v2 big-list) #t)
;;迭代的比较慢,当数据量比较大的时候,比较小的时候没有什么区别


;Exercise 476
(define (how-many.v1 l)
  (cond
    [(empty? l) 0]
    [else (+ 1 (how-many.v1 (rest l)))]))

(define (how-many.v2 l)
  (local (
          (define (how-many/a l a)
            (cond
              [(empty? l) a]
              [else (how-many/a (rest l) (add1 a))])))
    (how-many/a l 0)))


;; (time (how-many.v1 (range 100000)))
;; (time (how-many.v2 (range 100000)))
;;迭代的版本速度更加快,没有垃圾回收时间,递归可能需要展开所以耗时比较长

;Exercise 477 略
;Exercise 478
;生成回文序列

(define (make-palindrome l)
  (cond
    [(empty? (rest l)) (list (first l))]
    [else (append (list (first l))
                  (make-palindrome (rest l))
                  (list (first l)))]))

;;O(n^2)



(make-palindrome '("a" "b" "c"))
(time (append big-list big-list) #t)

(define (make-palindrome.v2 l)
  (local (
          (define (all-but-last l)
            (cond
              [(empty? (rest l)) '()]
              [else(cons (first l) (all-but-last (rest l)))]))
          (define (mirror l)
            (append (all-but-last l) (list (last l)) (all-but-last l))))
    (mirror l)))

;;速度比v2快出大约4倍
(define (make-palindrome.v3 l)
  (local (
          (define (all-but-last l)
            (cond
              [(empty? (rest l)) '()]
              [else(cons (first l) (all-but-last (rest l)))]))
          (define (mirror l)
            (local ((define  l-but-last (all-but-last l)))
            (append l-but-last  (list (last l)) l-but-last ))))
    (mirror l)))


;; (time (make-palindrome big-list) #t)
(time (make-palindrome.v2 big-list) #t)
(time (make-palindrome.v3 big-list) #t)
