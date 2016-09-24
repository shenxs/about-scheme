#lang racket

;;对于scheme的解析需要时刻追踪着需要解释的表达式,以及对于解析的值如何处理


;; 例如对于 (null? x)的解析
;; (if (null? x) x (cdr x))
;; 需要解析的是 (null? x)
;; 当值确定后就需要决定接下来的解析的表达式是 x 还是 (cdr x)

;; 我们把对值的处理叫做 continuation (计算的继续?承接?后续? 裘宗燕将其翻译为延续  , 比较难以翻译)

;; 假如x是'(a b c)
;; 我们可以在对 (if (null? x) x (cdr x))的求值的过程中独立出六个延续

;; 1对 (if (null? x) x (cdr x))求值
;; 2对 (null? x)求值
;; 3对null?求值
;; 4对x求值
;; 5对cdr求值
;; 6对x求值 (又求解了一次)

;; call/cc可以捕获任何表达式的延续
;; call/cc接受一个过程p,p可以接受一个参数,call/cc会构造出当前具体的延续并传递给p
;; 延续本身用k来表示,每一次当k应用于某一个值的时候它会返回当前延续的值,这个值也就是call/cc的返回值


;; 如果p的返回值不包括k那么p的返回值就是call/cc的返回值

;; 例如

;; (call/cc
;;  (lambda (k)
;;    (* 5 4)))


;; (call/cc
;;  (lambda (k)
;;    (* 5 (k 4))))


;; (+ 2
;;    (call/cc
;;     (lambda (k)
;;       (* 5 (k 4)))))


;; ;延续可以用来制造一个nonlocal的退出,

(define (product ls)
  (call/cc
   (lambda (break)
     (let f ([ls ls])
       (cond
         [(null? ls) 1]
         [(zero? (car ls)) (break 0)]
         [else (* (car ls) (f (cdr ls)))])))))

(product '(1 2 3 4 5 6))


(product '(1 2 3 4 5  0   34 5  ))


;;延续的好处是可以从正常的递归中跳出直接给出返回值,不需要再继续递归下去




(let ([x (call/cc  (lambda (k) k))])
  (x (lambda (ignore) "ignore")))


;;因为(lambda (k) k)会返回参数本身,x被绑定到延续本身


((call/cc (lambda (k) k)) (lambda (x) x))

;;这也许会是这么短的代码量上最难懂的代码
(((call/cc (lambda (k) k)) (lambda (x) x)) "HEY!")

;;call/cc的返回值是它自身的延续,和之前的代码一样

;;将此延续应用于(lambda (x) x) 将会返回 (lambda (x) x)


;;==>
((lambda (x) x) "Hey!")



;;这种使用延续的做法也不总是让人疑惑


;;一个求阶乘的小例子

(define retry #f)


(define (factorial x)
  (if (= 0 x)
      (call/cc (lambda (k) (set! retry k) 1))
      (* x (factorial (- x 1)))))

(factorial 4)

;;可以像正常的阶乘函数那样工作但是这个函数会对retry产生副作用
;;将call/cc 理解为断点 ,将某一时刻的状态保存下来,此刻的状态传递给被call/cc应用的函数
;;可以利用call/cc来实现断点
;;
(retry 7)



;;延续还可以被用于多任务



(define lwp-list '())

(define lwp
  (lambda (thunk)
    (set! lwp-list (append lwp-list (list thunk)))))

(define start
  (lambda ()
    (let ([p (car lwp-list)])
      (set! lwp-list (cdr lwp-list))
      (p))))


(define pause
  (lambda ()
    (call/cc
     (lambda (k)
       (lwp (lambda () (k #f)))
       (start)))))

(lwp (lambda () (let f () (pause) (display "h") (f))))
(lwp (lambda () (let f () (pause) (display "e") (f))))
(lwp (lambda () (let f () (pause) (display "y") (f))))
(lwp (lambda () (let f () (pause) (display "!") (f))))
(lwp (lambda () (let f () (pause) (newline) (f))))

(start)
;;死循环打印hey!

