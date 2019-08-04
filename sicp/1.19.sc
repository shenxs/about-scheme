;;可以在对数时间内计算出斐波那契数列

;;在使用迭代的方式计算的时候可以发现是
;; a <- a+b
;; b <- a

;;可以将这种变换对应为矩阵计算
;;由于之前的乘法可以在log时间内完成
;;可以借鉴快速乘法的方式完成矩阵运算，即可在log时间内完成fib（n）的计算


(define (fib n)
  (fib-iter 1 0 0 1 n))


(define (fib-iter a b p q count)
  (cond
   [(= count 0) b]
   [(even? count)
    (fib-iter a b
              (+ (* q q) (* p p))
              (+ (* 2 p q) (* q q))
              (/ count 2))]
   [else (fib-iter (+ (* b q) (* a q) (* a p))
                   (+ (* b p) (* a q))
                   p
                   q
                   (- count 1))]))

(fib 30)

;;参考
;;http://jots-jottings.blogspot.com/2011/09/sicp-119-fibonacci-on-steroids.html
;;所有的计算全部使用log时间的算法最终会对比现有的平台更快吗？
;;大概现代计算机的算术模块已经使用了这些技巧来加速基本的运算了,不过依然是非常快速

