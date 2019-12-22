(load "./utils.sc")

(define (runtime)
  (time-second (current-time)))


(define (time-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (fast-mod a x y n)
  (cond
   [(= y 1) (remainder (* a x) n)]
   [(odd? y) (fast-mod (remainder (* a x) n) x (- y 1) n)]
   [else (fast-mod a (remainder (* x x) n) (/ y 2) n)]))

(define (% x y n)
  (fast-mod 1 x y n))

(define (random-range x y)
  (+ x (random (- y x))))

(define (fast-prime? n)
  (if (= 1 (% (random-range 2 n)
              (- n 1)
              n))
      #t
      #f))

(define (multi fun n)
  (cond
   [(= n 1) (fun)]
   [(fun) (multi fun (- n 1))]
   [else #f]))

(define (find n)
  (cond
   [(= n 1) '()]
   [(multi (lambda () (fast-prime? n)) 5) (display n) (newline) (find (- n 1))]
   [else (find (- n 1))]))

(find 10000)

(timer (lambda ()  (fast-prime? 1000)))
(timer (lambda ()  (fast-prime? 1000000)))
(timer (lambda ()  (fast-prime? 1000000000000)))

(fast-prime? 2047)


