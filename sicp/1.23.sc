(define (square x)
  (* x x))

(define (smallest-divisor n next)
  (find-divisor n 2 next))

(define (next1 n)
  (cond
   [(= n 2) 3]
   [else (+ n 2)]))

(define (next2 n)
  (+ n 1))

(define (find-divisor n test-divisor next)
  (cond
   [(> (square test-divisor) n) n]
   [(divides? test-divisor n) test-divisor]
   [else (find-divisor n (next test-divisor ) next)]))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n next)
  (= n (smallest-divisor n next) ))

(define (runtime)
  (+ (time-nanosecond (current-time))
     (* 1000000000  (time-second (current-time)))))
(define (timed-prime-test n next)
  (newline)
  (display n)
  (start-prime-test n (runtime) next))
(define (start-prime-test n start-time next)
  (if (prime? n next)
      (report-prime (- (runtime) start-time))))
(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))
(define (search-for-primes start next count prime-next)
  (cond
   [(= count  0) (newline)]
   [(prime? start prime-next)
    (timed-prime-test start prime-next)
    (search-for-primes (next start) next (- count 1) prime-next)]
   [else (search-for-primes (next start) next count prime-next)]))

(search-for-primes 1000000 (lambda (x) (if (odd? x)
                                            (+ x 2)
                                            (+ x 1)))
                   6
                   next1)

(search-for-primes 1000000 (lambda (x) (if (odd? x)
                                           (+ x 2)
                                           (+ x 1)))
                   6
                   next2)

;;几乎就是两倍的关系

