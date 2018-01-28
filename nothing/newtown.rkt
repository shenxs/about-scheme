#lang racket


;牛顿解方程
;参数F guess ->root

;精度
(define 精度 0.000000000000001)

;判断答案是否足够接近
;F,guess->boolean
(define (good-enough? F guess)
  (if (or (< (* (F (+ guess 精度)) (F (- guess 精度)) ) 0)
          (= 0 (F guess)))
    true
    false))

;定义dx
(define dx 0.0000000001)

;得到某个点的导数
(define (导 F guess)
  (/ (- (F (+ guess dx))  (F guess)) dx ))


;得到下一个guess
;F guess->guess
(define (next F guess)
  (- guess (/ (F guess) (导 F guess ))))

(define (newton F guess)
  (if (good-enough? F guess)
    guess
    (newton F (next F guess))))

;;要求解的方程
(define (F x)
  (* (- x 5) (- x 4)))

(newton F -1)
