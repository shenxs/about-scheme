(define (average a b)
  (/ (+ a b) 2))
(define (improve guess x)
  (average guess (/ x guess)))

(define (good-enough? guess x)
  (< (abs (- (* guess guess) x))
     0.001))

(define (sqrt x)

  (define (good-enough? guess x)
    (< (abs (- (* guess guess) x))
       0.001))

  (define (sqrt-iter guess x count)
    (if (good-enough? guess x)
        (begin (display count) (newline) guess)
        (sqrt-iter (improve guess x) x (+ count 1))))
  (sqrt-iter 1.0 x 1))

(define (sqrt-root x)
  (define last '())
  (define (good-enough? guess)
    (cond
     [(null? last) (set! last guess) #f]
     [(< (abs (- guess last)) 0.001) #t]
     [else (set! last guess) #f]
     ))
  (define (sqrt-iter guess x count)
    (if (good-enough? guess )
        (begin (display count) (newline) guess)
        (sqrt-iter (improve guess x) x (+ count 1))))
  (sqrt-iter 1.0 x 1))


(sqrt 1000000) ;;迭代15次
(sqrt 0.0001) ;;6 次 0.03 效果不是很好

(sqrt-root 1000000) ;;对于较大的数值没有什么改进
(sqrt-root 0.0001);; 相对于之前的版本在小数上更加精确
