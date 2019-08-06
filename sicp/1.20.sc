
(define count 0)

(define (my-remainder x y)
  (set! count (+ count 1))
  (remainder x y))

(define (gcd a b)
  (define (iter x y)
    (if (= y 0)
        x
        (iter y (my-remainder x y))))
  (if (> a b)
      (iter a b)
      (iter b a)))

(gcd 206 40)
count
;;一共四次
