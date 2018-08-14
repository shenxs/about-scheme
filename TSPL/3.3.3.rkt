#lang racket

(define lwp-list '())
(define quit-k #f)
(define lwp
  (lambda (thunk)
    (set! lwp-list (append lwp-list (list thunk)))))

(define (start)
  (call/cc
   (lambda (k)
     (set! quit-k k)
     (next))))

(define (next)
  (let ([p (car lwp-list)])
    (set! lwp-list (cdr lwp-list))
    (p)))

(define pause
  (lambda ()
    (call/cc
     (lambda (k)
       (lwp (lambda () (k #f)))
       (next)))))

(define (quit v)
  (if (empty? lwp-list)
      (quit-k v)
      (next)))

(lwp  (lambda () (let f () (pause) (display "h") (quit #f) (f))))
(lwp  (lambda () (let f () (pause) (display "e") (quit #f) (f))))
(lwp  (lambda () (let f () (pause) (newline)  (quit #f) (f))))

;;如果lwp中的进程要退出,例如直接退出不调用pause
;;定义一个退出函数 quit,允许进程退出而不会影响lwp系统的运行
;;注意考虑lwp中只剩下一个进程的情况

;;任务退出相当于不在把自己的延续加入任务队列,所以结构和pause相似,少了(lwp (lambda () (k #f)))
(start)
