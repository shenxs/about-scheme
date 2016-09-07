#lang racket
; [Number -> Number] Number Number -> Number
; determines R such that f has a root in [R,(+ R TOLERANCE)]
; assume f is continuous
; assume (or (<= (f left) 0 (f right)) (<= (f right) 0 (f left)))
; generative divide interval in half, the root is in one of the two
; halves, pick according to assumption

(define TOLERANCE 0.5)

(define (find-root f left right)
  (cond
    [(<= (- right left) TOLERANCE) left]
    [else
      (local ((define mid (/ (+ left right) 2))
              (define f@mid (f mid))
              (define f@left (f left))
              (define f@right (f right)))
        (cond
          [(or (<= f@left 0 f@mid) (<= f@mid 0 f@left))
           (find-root f left mid)]
          [(or (<= f@mid 0 f@right) (<= f@right 0 f@mid))
           (find-root f mid right)]
          [else (error "something wrong") ]))]))

(define (ploy x)
  (* (- x 5) ( - x -1)))

;; (find-root ploy -1 14)

;Exercise 428

;The function consumes a number n and a list of n2 numbers.
;It produces a list of n lists of n numbers

(define (creat-matrix n l)
  (local(
         ;;从list l里面拿出n个元素
         (define (take-from l n)
           (cond
             [(= 0 n) '()]
             [else (cons (first l) (take-from (rest l) (sub1 n)))]))
         (define (drop-from l n)
           (cond
             [(= 0 n) l]
             [else (drop-from (rest l) (sub1 n))])))
    (cond
      [(>= (length l) n) (cons (take-from l n) (creat-matrix n (drop-from l n)))]
      [else '()])))

(creat-matrix 3 '(1 2 3 4 5 6 7 8 9))










