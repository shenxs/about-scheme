;;racket和chez的语法有些不一样
;;一些代码写在这里因为racket无法运行或者需要额外的包,和已有的冲突



(define make-queue
  (lambda ()
    (let ([end (cons 'ignore '())])
      (cons end end))))

(define putq!
  (lambda (q v)
    (let ([end (cons 'ignore '())])
      (set-car! (cdr q) v)
      (set-cdr! (cdr q) end)
      (set-cdr! q end))))

(define getq!
  (lambda (q)
    (car (car q))))


(define delq!
  (lambda (q)
    (set-car! q (cdr (car q)))))


(define myq (make-queue))

(putq! myq 'a)

(putq! myq 'b)

(getq! myq)

(delq! myq)

(getq! myq)


;;Exercise 2.9.5

(define emptyq?
  (lambda (q)
    (if (> (length (car q)) 1)
        #f #t)))

(define myq2 (make-queue))

(putq! myq2 'a)

(delq! myq2)

(emptyq? myq2)
