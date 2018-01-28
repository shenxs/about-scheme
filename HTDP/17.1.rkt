;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |17.1|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
;Exercise 238
;list of number[number->number]->list of number
(define (tabulate n f)
  (cond
    [(= n 0) (list (f 0))]
    [else
      (cons (f n)
            (tabulate (sub1 n) f))]))
;(tabulate 9 tan)


;Exercise 239
;list of X ,(X,Y->Y) ,Y ->Y
(define (fold2 l f last-case)
  (cond
    [(empty? l) last-case]
    [else (f (first l) (fold2 (rest l)))]))

;;Posn,img ->img
(define (place-dot p img)
  (place-image dot (posn-x p) (posn-y p) img))
;;图形常量
(define emt (empty-scene 100 100))
(define dot (circle 3  "solid" "red"))

(define (product_From_Abstract l)
  (fold2 l * 1))

(define (image*_from_abstract l)
  (fold2 l place-dot emt))
