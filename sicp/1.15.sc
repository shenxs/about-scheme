(define (cube x) (* x x x))
(define (p x) (- (* 3 x) (* 4 (cube x))))
(define count 0)
(define (sine angle)
  (set! count (+ count 1))
  (if (not (> (abs angle) 0.1)) angle
      (p (sine (/ angle 3.0)))))

(sine 12.15) ;;计算12次

;;空间增长 lgN/lg2
