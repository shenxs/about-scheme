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

(find-root ploy -1 14)
