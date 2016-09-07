#lang racket
(require 2htdp/batch-io
          lang/htdp-advanced )

;; queen

(define (imploade l)
  (cond
    [(empty? l) ""]
    [else (string-append (first l) (imploade (rest l)))]))

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



;; (make-palindrome '("a" "b" "c"))
;; (time (append big-list big-list) #t)

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
;; (time (make-palindrome.v2 big-list) #t)
;; (time (make-palindrome.v3 big-list) #t)

;Exercise 479

; Matrix -> Matrix
; find the first row that doesn't start with 0 and use it as the first one
; generative move the first row to last place
; termination this function does not terminate if all rows in M start with 0

(define (rotate M)
  (cond
    [(foldr (λ (a b) (and a b)) #t (map (λ (item) (if (= 0 (first item)) #t #f)) M)) (error "所有的list都以0开头")];;好乱估计自己都会看不懂
    [(not (= (first (first M)) 0)) M]
    [else (rotate (append (rest M) (list (first M))))]))

;; (rotate (list
          ;; (list 0 2 3 4 )
          ;; (list 0 2 3 4 )
          ;; (list 0 3 4 5)))

(define (rotate.v2 M0)
  (local (
          (define (rotate/a M seen)
            (cond
              [(empty? M) seen]
              [(not (= (first (first M))0)) (append M seen)]
              [else (rotate/a (rest M) (cons (first M) seen))])))
    (cond
      [(foldr (λ (a b) (and a b)) #t (map (λ (item) (if (= 0 (first item)) #t #f)) M0)) (error "所有的list都以0开头")]
      [else (rotate/a M0 '())])))


;; (rotate.v2 (list
          ;; (list 0 2 3 4 )
          ;; (list 1 2 3 4 )
          ;; (list 0 3 4 5)))



;Exercise 480
;[list of numbers]==>number
;ex. '(1 0 2)==>102
(define (to10 l)
  (local ((define l2h (reverse l))
          (define (to10 l i)
            (cond
              [(empty? l) 0]
              [else (+ (* i (first l)) (to10 (rest l) (* 10 i)))])))
    (to10 l2h 1)))

;; (time (to10 '(1 0  0 0 0 0 2 0 0 0)) )

;Exercise 480
;判断一个数字是否为质数
(define (is-prime n)
  (local (
          (define (is-prime/a n a)
            (cond
              [(< (sqrt n) a) #t]
              [(= 0 (remainder n  a)) #f]
              [else (is-prime/a n (add1 a))])
          ))
    (cond
      [(= 1 n) #f]
      [else (is-prime/a n 2)])))

;Exercise 482
;
(define (my-map f l)
  (local(
         (define (my-map/a a f l)
           (cond
             [(empty? l) a]
             [else (my-map/a (append a (list (f (first l)))) f (rest l))])))
    (my-map/a '() f l)))
;; (my-map add1 '(1 2 3 4 ))


(define (my-foldl f e l0)
  (local (
          ;Exercise 483 task 1
          ;a表示已经完成的部分的结果
          ;l是尚未完成的list
          (define (fold/a a l)
            (cond
              [(empty? l) a]
              [else (fold/a (f (first l) a) (rest l))])))
    (fold/a e l0)))

(define (my-foldr f e l0)
  (cond
    [(empty? l0) e]
    [else (f (first l0) (my-foldr f e (rest l0)))]))

;;分别用递归和迭代实现的foldr与foldl,有点意思
;;递归和迭代也许可以相互转化? 可以吗?
;foldr 递归
;foldl 迭代
;(foldr f e l) == (foldl f e (reserve l)


;Task2


(build-list 10 (λ (x) x))

;;[Number] [Number=>Number]===>[list of numbers]

(define (my-build-list n f)
  (local (
          ;a已经完成的list,x 当前是数字
          (define (build/a x f a)
            (cond
              [(= x -1) a]
              [else (build/a (sub1 x) f (cons (f x) a))])))
    (build/a (sub1 n) f '())))

(my-build-list 10 (λ (x) x))


;Exercise 486
;文件名,最大字符数
;输出out.txt
(define (fmt file w)
  (local(
         (define (fmt l n a)
           (local((define len (length l)))
             (cond
               [(< len n) (string-append a (imploade l))]
               [else (fmt (drop l n) n (string-append a "\n" (imploade (take l n))))])))
         (define in-f (read-file "in.txt"))
         (define out-f
           (fmt (explode in-f) w ""))
         )
    (write-file "out.txt" out-f)))
(fmt "in.txt" 40)
