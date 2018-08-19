(library (grades)
  (export gpa->grade gpa distribution histogram)
  (import (rnrs))

  (define in-range?
    (lambda (x n y)
      (and (>= n x) (< n y))))

  (define-syntax range-case
    (syntax-rules (- else)
      [(_ expr ((x - y) e1 e2 ...) ... [else ee1 ee2 ...])
       (let ([tmp expr])
         (cond
          [(in-range? x tmp y) e1 e2 ...]
          ...
          [else ee1 ee2 ...]))]
      [(_ expr ((x - y) e1 e2 ...) ...)
       (let ([tmp expr])
         (cond
          [(in-range? x tmp y) e1 e2 ...]
          ...))]))

  (define letter->number
    (lambda (x)
      (case x
        [(a)  4.0]
        [(b)  3.0]
        [(c)  2.0]
        [(d)  1.0]
        [(f)  0.0]
        [else (assertion-violation 'grade "invalid letter grade" x)])))

  (define gpa->grade
    (lambda (x)
      (range-case x
                  [(0.0 - 0.5) 'f]
                  [(0.5 - 1.5) 'd]
                  [(1.5 - 2.5) 'c]
                  [(2.5 - 3.5) 'b]
                  [else 'a])))

  (define-syntax gpa
    (syntax-rules ()
      [(_ g1 g2 ...)
       (letrec ([f (lambda (l) (cond
                                [(null? l) '()]
                                [(eqv? 'x (car l)) (f (cdr l))]
                                [else (cons (letter->number (car l)) (f (cdr l)))]))])
         (let ([ls (f '(g1 g2 ...))])
           (if (= (length ls) 0)
               0
               (/ (apply + ls) (length ls)))))]))
  (define $distribution
    (lambda (ls)
      (let loop ([ls ls] [a 0] [b 0] [c 0] [d 0] [f 0])
        (if (null? ls)
            (list (list a 'a) (list b 'b) (list c 'c)
                  (list d 'd) (list f 'f))
            (case (car ls)
              [(a) (loop (cdr ls) (+ a 1) b c d f)]
              [(b) (loop (cdr ls) a (+ b 1) c d f)]
              [(c) (loop (cdr ls) a b (+ c 1) d f)]
              [(d) (loop (cdr ls) a b c (+ d 1) f)]
              [(f) (loop (cdr ls) a b c d (+ f 1))]
                                        ; ignore x grades, per preceding exercise
              [(x) (loop (cdr ls) a b c d f)]
              [else (assertion-violation 'distribution
                                         "unrecognized grade letter"
                                         (car ls))])))))
  (define-syntax distribution
    (syntax-rules ()
      [(_ g1 g2 ...)
       ($distribution '(g1 g2 ...))]))
  (define histogram
    (lambda (port distr)
      (for-each
       (lambda (n g)
         (put-datum port g)
         (put-string port ": ")
         (let loop ([n n])
           (unless (= n 0)
             (put-char port #\*)
             (loop (- n 1))))
         (put-string port "\n"))
       (map car distr)
       (map cadr distr))))

  )
