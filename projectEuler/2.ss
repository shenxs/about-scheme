(define (solve a b acc)
  (cond
   [(> b 4000000) acc]
   [else (solve b (+ a b)
				(if (odd? b) acc (+ b acc)))]))

(solve 1 2 0)

;;偶数斐波那契数列可以有递推公式

(define (solve2 x y acc)
  (cond
   [(> y 4000000) acc]
   [else (solve2 y (+ (* 4 y) x) (+ acc y))]))

(solve2 2 8 2)
