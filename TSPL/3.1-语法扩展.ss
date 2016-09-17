(begin 'a 'b 'c)


;;3.3.1
(define-syntax let*
  (syntax-rules ()
    [(_ ([v e])
       t)
     (let ([v e])
       t)]
    [(_ ([v0 e0] [v1 e1] [v2 e2] ...)
        t)
     (let ([v0 e0])
       (let* ([v1 e1] [v2 e2] ...)
         t))]))

(let* ([a 5]
       [b (+ a a)]
       [c (+ a b)])
  (list a b c))
