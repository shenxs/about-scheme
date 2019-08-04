
;;使用迭代的方式在对数步数内计算处两个数的乘积

(define (double a)
  (+ a a))

(define (halve a)
  (/ a 2))

(define (my-multi a b)
  (define (iter a x y)
    (cond
     [(= 0 y) a]
     [(even? y) (iter a (double x) (halve y))]
     [else (iter (+ a x) x (- y 1))]))
  (iter 0 a b))


(and (equal? 0 (my-multi 4 0))
     (equal? 20 (my-multi 4 5))
     (equal? 25 (my-multi 5 5))
     (equal? 30 (my-multi 10 3)))

(my-multi 10000 10000)

