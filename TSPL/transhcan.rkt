#lang racket
(call/cc (lambda (k) (* 5 4)))

(call/cc (lambda (k) (* 5 (k 4))))

;;a list of number --> a number
;;计算一个列表的数字的乘积
(define (prducrt ls)
  (call/cc (lambda (break)
             (let f ([ls ls])
               (cond
                 [(empty? ls) 1]
                 [(= (first ls) 0) (break 0)]
                 [else (* (first ls) (f (rest ls)))])))))

(prducrt '(1 2 3 4 5  6 0 2434 45))



(let ([x (call/cc (lambda (k) k))])
  (x (lambda (nothing)
       (begin (displayln nothing)
              "hi"))))

;;好像明白一点什么叫延续了

(define lwp-list '())


;;将一个任务加入list的结尾
(define (lwp thunk)
  (set! lwp-list (append lwp-list (list thunk))))

;;从列表取出一个任务来执行
(define (start)
  (let ([p (first lwp-list)])
    (set! lwp-list (rest lwp-list))
    (p)))

(define (pause)
  (call/cc (lambda (k)
             (lwp (lambda () (k #f)))
             (start))))

(lwp (lambda ()
       (let f ()
         (pause)
         (display "h")
         (f))))
(lwp (lambda () (let f () (pause) (display "e") (f))))
(lwp (lambda () (let f () (pause) (display "y") (f))))
(lwp (lambda () (let f () (pause) (display "!") (f))))
(lwp (lambda () (let f () (pause) (newline) (f))))

;;(start)

((first)) (list (lambda () (let f () (pause) (display "f") (f) )))
