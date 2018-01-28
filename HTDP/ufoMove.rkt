#lang racket
;; ufo 设定位置和速度
(define-struct ufo [loc vel])
(define-struct vle [x y])
;;ufo->ufo
;;将速度加到位置上

;;vel posn ->posn
;;将速度加到位置上去

(define (posn+ p v)
  (make-posn (+ (posn-x p) (vel-x v))
             (+ (posn-y p) (vel-y v))))
(define (ufo-move u)
  (posn+ (ufo-loc u) (ufo-vel u)))

