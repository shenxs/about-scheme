;; https://pe-cn.github.io/1/

;;暴力枚举
(define (solve x)
  (define (valid-number? x)
	(or (= 0 (mod x 3))
		(= 0 (mod x 5))))
  (define (solve-inner x acc)
	(cond
	 [(= 0 x) acc]
	 [else (solve-inner (- x 1)
				  (if (valid-number? x)
					  (+ x acc)
					  acc))]))

  (solve-inner x 0 ))

 (solve 999)


;; 3的倍数 和 5 的倍数 都是等差数列,
;; 求和之后去除公共项

;;up 上限
(define (solve2)
  (define sum3 (/ (* 333  (+ 3 999)) 2))
  (define sum5 (/ (* 199 (+ 5 995)) 2))
  (define sum15 (/ (* 66 (+ 15 990)) 2))
  (-  (+ sum3 sum5) sum15))


;;;;;;;;;;;;;;;;;性能比较
(time (solve 999))
(time (solve2))

;; (time (solve 999))
    ;; no collections
    ;; 0.000033022s elapsed cpu time
    ;; 0.000032000s elapsed real time
    ;; 0 bytes allocated
;; 233168
;; > (time (solve2))
;; (time (solve2))
    ;; no collections
    ;; 0.000000043s elapsed cpu time
    ;; 0.000000000s elapsed real time
    ;; 0 bytes allocated
;; 233168
