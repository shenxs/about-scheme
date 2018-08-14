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

;;因为(lambda (k) k)会返回参数本身,x被绑定到延续本身,当x被应用于过程 (lambda (ignore) "ignore")时
;;该过程就作为call/cc 的返回了,所以x被重新绑定为该过程然会被应用于自身,相当于
;; ( (lambda (ignore) "ignore") (lambda (ignore) "ignore") )
;;所以返回值就是ignore


((call/cc (lambda (k) k)) (lambda (x) x))

;;这也许会是这么短的代码量中最难懂的代码
(((call/cc (lambda (k) k)) (lambda (x) x)) "HEY!")


;;call/cc的返回值是它自身的延续,和之前的代码一样

;;将此延续应用于(lambda (x) x) 所以call/cc的返回变成了(lambda (x) x)
;;即 ( (lambda (x) x)  (lambda (x) x))
;;==>(lambda (x) x)

;;==>
;; ((lambda (x) x) "Hey!")
;; 所以结果是 "Hey!"



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
(retry 1)



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
       (lwp (lambda () (k #f)));;k应用与什么值并不重要,但是k会保存当前的状态k是一个延续,将它放到任务的最后
       (start)))))

(lwp (lambda () (let f () (pause) (display "h") (f))))
(lwp (lambda () (let f () (pause) (display "e") (f))))
(lwp (lambda () (let f () (pause) (display "y") (f))))
(lwp (lambda () (let f () (pause) (display "!") (f))))
(lwp (lambda () (let f () (pause) (newline) (f))))

;;(start)

;;死循环打印hey!
;;(start)开始执行,以第一个任务为例,会先执行(pause),可以看到pause中将(lambda () (k #f))加入了任务队列中
;; 然后又调用了(start)
;; start从任务队列中调取出下一个任务,该任务也是先调用pause,这样依次走完一遍来到 换行这个任务执行玩(pause)之后,
;;在(start)调用中会从任务序列中拿出第一个(display "h)的任务时放入的(lambda () (f #f)) 当该过程被执行之后
;;call/cc会把#f作为返回值,相当于时间回到了刚调用第一个任务的(pause) 刚完成的时刻,下面就是(display "h")
;;第一个字符被打印出来,然后是(f) ,f又会再次调用(pause),pause将当时的延续又加入任务队列,接着调(start)
;;start 这时候取出的任务就是打印e任务放入的延续,pause的返回就是#f,此时第二个字符被打印,
;;以此类推会不停地打印"hey!"

