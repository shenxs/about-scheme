(define (runtime)
  (+ (time-nanosecond (current-time))
     (* 1000000000  (time-second (current-time)))))

(define (timer fun)
  (let ([start (runtime)])
    (fun)
    (- (runtime) start)))
