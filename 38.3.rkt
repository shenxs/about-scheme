;;在结果中的迭代

#lang racket
(require 2htdp/image)

(struct posn [x y])

(define (add-triangle image a b c)
  (scene+line
   (scene+line
    (scene+line
     image
     (posn-x c) (posn-y c)
     (posn-x a) (posn-y a)
     "red")
    (posn-x b) (posn-y b)
    (posn-x a) (posn-y a)
    "red")
   (posn-x b) (posn-y b)
   (posn-x c) (posn-y c)
   "red"))


(define (too-small? a b c)
  (local (
          (define (x^2 x)
            (* x x))
          (define (distance a b)
            (sqrt (+ (x^2 (- (posn-x a) (posn-x b)))
                     (x^2 (- (posn-y a) (posn-y b))))))
          )
    (if (< 5 (max (distance a b)
                  (distance b c)
                  (distance a c)))
        #f #t)))

(define (mid-point a b)
  (posn (/ (+ (posn-x a) (posn-x b)) 2)
        (/ (+ (posn-y a) (posn-y b)) 2)))

; Image Posn Posn Posn -> Image
; generative adds the triangle (a, b, c) to s, subdivides the triangle
; into three by taking the midpoints of its sides, and deals
; with the outer triangles recursively until it is too small
(define (add-sierpinski scene0 a b c)
  (cond
    [(too-small? a b c) scene0]
    [else
     (local ((define scene1 (add-triangle scene0 a b c))
             (define mid-a-b (mid-point a b))
             (define mid-b-c (mid-point b c))
             (define mid-c-a (mid-point c a))
             (define scene2 (add-sierpinski scene1 a mid-a-b mid-c-a))
             (define scene3 (add-sierpinski scene2 b mid-b-c mid-a-b))
             )
       (add-sierpinski scene3 c mid-c-a mid-b-c))]))
      

(define run
  (local ((define s0 (empty-scene 1000 (* 500 (sqrt 3))))
          (define a (posn 500  0))
          (define b (posn 0 (* 500 (sqrt 3))))
          (define c (posn 1000 (* 500 (sqrt 3)))))
    (add-sierpinski s0 a  b c)))



