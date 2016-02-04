#lang racket

(require 
         lang/htdp-advanced)

(define (bundle s n)
  (cond
    [(empty? s) '()]
    [else (cons (implode (take s n)) (bundle (drop s n) n))]))

; [List-of X] N -> [List-of X]
; retrieves the first n items in l if possible or everything

; [List-of X] N -> [List-of X]
; remove the first n items from l if possible or everything

;; (bundle '("a" "b" "c" "d") 2)
;Exercise 396
;NO 参数不符合要求

;Exercise 397

;[list of emlement] Number {list of emlement ->chunks}===>list of chunks
(define (list->chunks s n f)
  (cond
    [(empty? s) '()]
    [else (cons (f (take s n)) (list->chunks (drop s n) n f))]))

(define (bundle.v2 s n)
  (list->chunks s n implode))

;Exercise 398
(define (my_partition s n)
  (local((define l (string-length s)))
    (cond
      [(= n 0) (error "n不可以是0")]
      [(< n l)
       (cons (substring s 0 n ) (my_partition (substring s n l ) n) ) ]
      [else (cons s'())]
      )))

(my_partition "" 100)
