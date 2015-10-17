#lang racket
;原函数
(define (f1 n)
  (cond
    [(= 0 n) 1]
    [else (* n (f1 (- n 1)))]))

;非显示的递归调用
(define (f2_part self n)
  (cond
    [(= n 0) 1]
    [else (* n (self self (- n 1)))]))

(define (f2 n)
  (f2_part f2_part n))

;local 使之成为一个函数

(define (f3 n)
  (local (
          (define (part self n)
            (cond
              [(= n 0) 1]
              [else (* n (self self (- n 1)))]))
          )
    (part part n)))

;加入λ
(define (f4 n)
  ((λ (x) (x x n))
   (λ (f n)
       (if (= n 0) 1 (* n (f f (- n 1)))))))

;去掉函数名

((λ (n)
    ((λ (x) (x x n))
     (λ (f n)
        (if (= n 0 ) 1 (* n (f f (- n 1))))))) 6)
;成功,没有函数名的递归函数


;;使之化简,然后一般化
;先把n拿出来试试
(define (f5 n)
  ((λ (x) (x x n))
   (λ (f n)
      (if (= n 0) 1 (* n (f f (- n 1)))))))

;将两个参数的匿名函数转换成嵌套的单参匿名函数
(f5 6)


;;以下内容为博客转载,非原创
(define (part-f1 self)
  ((lambda (f)
     (lambda (n)
       (if (= n 0)
            1
            (* n (f (- n 1))))))
   (self self)))
;(define f6 (part-f1 part-f1))

;;抄袭结束

(define almost_f
  (lambda (f)
    (lambda (n)
      (if (= n 0)
        1
        (* n (f (- n 1)))))))


