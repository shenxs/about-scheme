;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |Exercise-160- riot|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(define (col n img)
  (cond
    [(zero? (sub1 n)) img]
    [(positive? (sub1 n)) (above img (col (sub1 n) img ))]))

(define (row n img)
  (cond
    [(zero? (sub1 n)) img]
    [(positive? (sub1 n)) (beside img (row (sub1 n) img ))]))

(define Background (row 18 (col 18 (empty-scene 10 10))))

(define Ball (circle 5 "solid" "red"))

(define (play l)
  (cond
    [(empty? l) Background ]
    [else (place-image Ball (posn-x (first l)) (posn-y (first l)) (play (rest l)))]))

(define (drawer pair)
  (cond
    [(empty? pair) (play pair)]
    [else (play (pair-l pair))]))


;;设定n为小球的数量，l为列表
(define-struct pair [n l])


(define (time-hander p)
  (make-pair
   (sub1 (pair-n p))
   (cons
    (make-posn (* 10 (random 18)) (* 10 (random 18)))
    (pair-l p) )))

(define (stop-judge p)
  (if (= 0 (pair-n p)) true false))

(define (main pair)
  (big-bang pair
            [to-draw drawer ]
            [on-tick time-hander 1]
            [stop-when stop-judge]))

(main (make-pair 6 '()))