;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname list-excercise) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define (sum l)
  (cond
    [(empty? l) 0]
    [else (+  (first l)  (sum (rest l)))]))
;;相比前者速度更快，计算的步骤更少
(define (sum.2 l)
  (cond
    [(empty? (rest l)) (first l)]
    [(cons? (rest l)) (+ (first l) (sum.2 (rest l)))]))
(define (sort>? l)
  (cond
    [(empty? (rest l)) true]
    [else  (and (> (first l) (first (rest l))) (sort>? (rest l)) )]))
(check-expect (sort>? (cons 9 (cons 8 (cons 1 '())))) true )
(define (how-many l)
  (cond
    [(empty? (rest l)) 1 ]
    [else (+ 1 (how-many (rest l)))]))
(check-expect (how-many (cons 9 (cons 8 (cons 1 '())))) 3)
(define (all-true l)
  (cond
    [(empty? (rest l)) (first l)]
    [else (and (first l) (all-true (rest l)))]))

(define (copier n l)
  (cond
    [(zero? n) '()]
    [(positive? n) (cons l (copier (sub1 n) l))]
    [(not (integer? n)) (error "请输入正整数")]))

(define (add-to-pi n)
  (+ n pi))
(check-within (add-to-pi 3) (+ 3 pi) 0.001)
(define (multiply n x)
  (cond
    [(zero? n) 1]
    [(positive? n) (* x (multiply (sub1 n) x))]
    [(not (integer? n)) (error "请输入整数")]))
(define (col n img)
  (cond
    [(zero? (sub1 n)) img]
    [(positive? (sub1 n)) (above img (col (sub1 n) img ))]))
(define (row n img)
  (cond
    [(zero? (sub1 n)) img]
    [(positive? (sub1 n)) (beside img (row (sub1 n) img ))]))
(check-expect (multiply 10 2) 1024)
(define Background (row 8 (col 18 (empty-scene 10 10))))
(define Ball (circle 5 "solid" "red"))
(define (play l)
  (cond
    [(empty? (rest l)) (place-image Ball (posn-x (first l)) (posn-y (first l)) Background) ]
    [else (place-image Ball (posn-x (first l)) (posn-y (first l)) (play (rest l)))]))

(play (cons (make-posn 20 30) (cons (make-posn 30 40) (cons (make-posn 40 60) '())) ))