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

;接下来是画出一棵草原树

(define smallest-l 15)
(define left-degree-speed 0.15)
(define right-degree-speed 0.2)

(define (add+line image x y l degree)
  (local (
          (define aim (make-polar l degree))
          (define x2 (+ x (real-part aim)))
          (define y2 (- y (imag-part aim)))
          )
    (scene+line image x y x2 y2 "red")))

(define (add-cha image x y l degree)
  (local (
          (define s0 (add+line image x y l degree))
          (define aim (make-polar l degree))
          (define x1 (+ x (* 1/3 (real-part aim))))
          (define y1 (- y (* 1/3 (imag-part aim))))
          (define x2 (+ x (* 2/3 (real-part aim))))
          (define y2 (- y (* 2/3 (imag-part aim))))
          (define s1 (add+line s0 x1 y1 l (+ degree left-degree-speed)))
          )
    (add+line s1 x2 y2 l (- degree right-degree-speed))))

(define (next-point x y l degree)
  (local (
          (define aim (make-polar l degree))
          (define new-x (+ x (real-part aim)))
          (define new-y (- y (imag-part aim)))
          )
    (posn new-x new-y)))

(define (next-l l)
  (- l 5))

;;image ,x ,y ,l(线段长度) ,角度
(define (add-savannah image x y l degree)
  (cond
    [(< l  smallest-l) (add+line image x y smallest-l degree)]
    [else (local
            (
             (define s0 (add+line image x y l degree))
             (define 1/3p (next-point x y (* l 1/3) degree))
             (define 2/3p (next-point x y (* l 2/3) degree))
             ;(define l-p (next-point (posn-x 1/3p) (posn-y 1/3p) l (+ left-degree-speed  degree)))
             ;(define r-p (next-point (posn-x 2/3p) (posn-y 2/3p) l (- degree right-degree-speed)))
             (define s1 (add-savannah s0 (posn-x 1/3p) (posn-y 1/3p) (next-l l) (+ left-degree-speed degree)))
             )
             (add-savannah s1 (posn-x 2/3p) (posn-y 2/3p) (next-l l) (- degree right-degree-speed)))]
    ))
(add-savannah (empty-scene 200 200) 100 200 50 (/ 3.1415926 2))
