(load "./1.21.sc")
(define (prime? n)
  (= n (smallest-divisor n) ))
(define (runtime)
  (+ (time-nanosecond (current-time))
     (* 1000000000  (time-second (current-time)))))
(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))
(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))))
(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))
(define (search-for-primes start next count)
  (cond
   [(= count  0) (newline)]
   [(prime? start) (timed-prime-test start) (search-for-primes (next start) next (- count 1))]
   [else (search-for-primes (next start) next count)]))

(search-for-primes 19960101 (lambda (x) (if (odd? x)
                                        (+ x 2)
                                        (+ x 1)))
                   10)


