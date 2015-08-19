;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname list-excercise) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define (sum l)
  (cond
    [(empty? l) 0]
    [else (+ (if (> (first l) -274) (first l) 0) (sum (rest l)))]))
(define (how-many l)
  (cond
    [(empty? l) 0]
    [else (+ (if (> (first l) -274) 1 0) (how-many (rest l) ))]))
(define (average l)
  (/ (sum l) (how-many l)))


(average '())