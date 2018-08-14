(import (scheme))
;;lwp使用了set!和append,每一次都会把lwp-list全部复制一份
;;请使用队列数据类型改写来避免这样的问题

(define make-queue
  (lambda ()
    (let ([end (cons 'ignored '())])
      (cons end end))))

(define putq!
  (lambda (q v)
    (let ([end (cons 'ignored '())])
      (set-car! (cdr q) v)
      (set-cdr! (cdr q) end)
      (set-cdr! q end))))

(define getq
  (lambda (q)
    (car (car q))))

(define delq!
  (lambda (q)
    (set-car! q (cdr (car q)))))

(define lwp-list (make-queue))
(define quit-k #f)
(define lwp
  (lambda (thunk)
    (putq! lwp-list  thunk)))

(define (start)
  (call/cc
   (lambda (k)
     (set! quit-k k)
     (next))))

(define (next)
  (let ([p (getq lwp-list)])
    (delq! lwp-list)
    (p)))

(define pause
  (lambda ()
    (call/cc
     (lambda (k)
       (lwp (lambda () (k #f)))
       (next)))))

(define (quit v)
  (if (null? lwp-list)
      (quit-k v)
      (next)))

;; (lwp  (lambda () (let f () (pause) (display "h") (quit #f) (f))))
;; (lwp  (lambda () (let f () (pause) (display "e") (quit #f) (f))))
;; (lwp  (lambda () (let f () (pause) (newline) (quit #f) (f))))

;; (start)

;;轻量级的线程机制可以动态查创建新线程

(define (lwp-new func)
  (lwp (lambda () (let f () (pause) (func) (f) ))))

(lwp-new (lambda () (display "h")))
(lwp-new (lambda () (display "e")))
(lwp-new (lambda () (display "y")))
(lwp-new (lambda () (display "!")))
(lwp-new (lambda () (newline)))
(start)

