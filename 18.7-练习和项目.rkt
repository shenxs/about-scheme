;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname 18.7-练习和项目) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))


;Exercise 255
;将一系列的美元转换成欧元
;1$==1.22€
;[list of Number]->[list of Number]
(define (convert-euro lom)
  (local(
         ;美元到欧元
         ;Number->Number
         (define (to-euro n)
           (* n 1.22)))
    (map to-euro lom)))

;translates a list of Posns into a list of list of pairs of numbers
;list-of Posn-> [list-of [list Number Number ]]
(define (translate lop)
  (local(
         (define( Posn_to_list p)
           (list (posn-x p) (posn-y p)))
         )
    (map Posn_to_list lop)))



;Exercise 256
;
; sorts a list of inventory records by the difference between
;the two prices
;[a list of IR]-> a sorted [list of IR]

(define-struct ir [name price])

(define (sort_IR_price loir)
  (local(
         (define (cmp a b)
           (> (ir-price a) (ir-price b))))
    (sort loir cmp)))


