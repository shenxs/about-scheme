#lang racket
(require math/number-theory)
;;这是一种机智的做法
;;
(let ([sum (lambda (sum ls)
             (if (null? ls)
                 0
                 (+ (first ls) (sum sum (rest ls)))))]);;此处的sum是参数sum所以不会不存在
  (sum sum '( 1 2 3 4 5)))


;; (let ([sum (lambda (ls)
;;              (if (null? ls)
;;                  0
;;                  (+ (first ls) (sum (rest ls)))))]);;定义时会报错,sum未定义,let的绑定只可以在let的body表达式中使用
;;   (sum '(1 2 3 4 5)))


;(letrec ([var expr] ... ) body body2 ...)

;;可以使用letrec不同于let他可以在expr和body中使用var定义


(letrec ([even? (lambda (x)
                  (if (zero? x) #t (odd? (- x 1) )))]
         [odd? (lambda (x)
                 (if (zero? x) #f (even? (- x 1))))])
  (list (odd? 13) (even? 12)))


(letrec ([sum (lambda (ls)
                (if (null? ls)
                    0
                    (+ (car ls) (sum (cdr ls)))))])
  (sum '(1 2 3 4 5)))


;;letrec中绑定的变量通常是过程,但是不一定,只要这个表达式可以被单独evaluate而不依赖与其他表达式
;;这是一个符合语法的例子
(letrec ([y (lambda () (+ x 2))]
         [x 1])
  (y))


;; ;;一个反例
;; (letrec ([y (+ x 2)]
;;          [x 1])
;;   (list x y))

;;可以使用letrec来掩盖一些辅助函数使得top define更加简洁,避免污染顶层命名空间


(define list?
  (lambda (x)
    (letrec ([race (lambda (hare tortiose)
                     (if (pair? hare)
                         (let ([hare (cdr hare)])
                           (if (pair? hare)
                               (and (not (eq? hare tortiose))
                                    (race (cdr hare) (cdr tortiose)))
                               (null? hare)))
                         (null? hare)))])
      (race x x))))


(list? '())



(let fac ([n 10])
  (if (zero? n)
      1
      (* n (fac (sub1 n)))))


;; (let name ([var expr] ...)
;;   body body1 ...)
;; ;;可以改写为 TODO 有前提
;; (letrec ([name (lambda (var ...) body body1 ...)])
;;   (name expr ...))


;; ;;也可以是
;; ((letrec ([neme (lambda (var ...) body body1 ...)])
;;    name)
;;  expr ...)


;; 有些递归可以用迭代来代替.比如尾递归,可以不用担心调用栈溢出.

;;什么是尾部调用?
;;如果一个表达式转化为lambda 表达式,此调用的返回值直接从lambda表达式返回,那么这个调用发生的位置就是尾部.
;;比如lambda 表达式的最后body表达式,如果一个在lambda中的表达式,调用它之后没有什么事剩下,
;;if表达式的两个分支都算是尾部,and和or的最后一个表达式
;;let和letrec的最后一个body表达式



;; ;;e.g

;; (lambda () (f (g)))

;; ;f是在尾部调用的但是g不是,因为lambda 的返回值是从f返回的而不是从g

;; (lambda () (if (g) (f) (f)))
;; (lambda () (let ([x 4]) (f)))
;; (lambda () (or (g) (f)))

;; ;;以上的调用都是f是尾部调用而g不是


;;用递归和迭代分别实现



(define (factorial1 n)
  (if (= n 1)
      1
      (* n (factorial1 (sub1 n)))))


(define (factorial2 n)
  (letrec ([f (lambda (n c)
                (if (= n 1)
                    c
                    (f (sub1 n) (* n c))))])
    (f n 1)))

;;斐波那契数列

(define fibonacci-r
  (lambda (n)
    (cond
      [(= n 0) 0]
      [(= n 1) 1]
      [else (+ (fibonacci-r (- n 1))
               (fibonacci-r (- n 2)))])))

;(fibonacci-r 40)

(define (fibonacci-i n)
  (letrec ([f (lambda (i a b)
             (cond
               [(= i 1) b]
               [else (f (sub1 i) b (+ a b))]))])
    (f n 0 1)))

;(fibonacci-i 100)

;;因式分解


(define (factor n)
  (let f ([n n] [i 2])
    (cond
      [(<= n i) (list n)]
      [(integer? (/ n i))
       (cons i (f (/ n i) i))]
      [else (f n (add1 i))])))


;; (factor 362880014137)
(modulo (expt 65 17) 3233)



(define (factor2 n)
  (let f ([n n] [i 2])
    (cond
      [(prime? n) (list n)]
      [(integer? (/ n i))
       (cons i (f (/ n i) i))]
      [else (f n (add1 i))])))

(factor2 121212121212)


;;3.2.3
;;可以但是需要两个let来办到

(let even? ([x 20])
  (cond
    [(= x 0) #t]
    [else (let odd? ([x (- x 1)])
            (cond
              [(= x 0) #f]
              [else (even? (- x 1))]))]))

;;3.2.4


(define make-counter
  (lambda ()
    (let ([x 0])
      (lambda ()
        (let ([t x])
          (begin
            (set! x (+ x 1))
            t))))))


(define c1 (make-counter))

(define (fibnacci n)
  (letrec ([f (lambda (a b n)
                (begin (c1)
                       (cond
                         [(= n 0) b]
                         [else (f b (+ a b) (- n 1))])))])
    (f 0 1 n)))

(fibnacci 20)

(c1)


(define c2 (make-counter))

(define (fibnacci2 n)
  (letrec ([f (lambda (n)
                (begin (c2)
                       (cond
                         [(= n 0) 0]
                         [(= n 1) 1]
                         [else (+ (f (- n 1)) (f (- n 2)))])))])
    (f n)))

(fibnacci2 20)

(c2)
