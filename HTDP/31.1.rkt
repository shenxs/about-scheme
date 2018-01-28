#lang racket
(require 2htdp/image
         2htdp/universe)
;分形几何

(define SMALL 4)

(define small-triangle (triangle SMALL 'outline 'red))

(define (sierpinski side)
  (cond
    [(<= side SMALL) (triangle side 'outline 'red)]
    [else (local ((define half-sized (sierpinski (/ side 2))))
            (above half-sized
                   (beside half-sized half-sized)))]))

(big-bang 500
          [to-draw sierpinski]
          [name "谢尔斯宾三角"])
