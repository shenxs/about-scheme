;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |16.5|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
(define (extract R l n)
  (cond
    [(empty? l) '()]
    [else (if (R (first l) n)
            (cons (first l) (extract R (rest l) n))
            (extract R (rest l) n))]))
(define (square>? a b)
  (> (* a a ) b))
;(extract < (list 1 2 3 4 5) 7)
(extract square>? (list 3 4 5 7 8) 10)
;(extract < (cons 6 (cons 4 '())) 5)
;(extract < (cons 4 '() ) 5)
