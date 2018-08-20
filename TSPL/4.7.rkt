#lang racket

;;赋值
;;语法：(set! var expr)

#|
set！不会建立一个新的绑定而是改变一个已有的绑定。首先会解析expr的值，然后将其绑定在var上。任何对于
var接下来的引用就会指向新的值了

赋值在scheme中不像其他语言中那样被频繁使用，但是赋值在实现状态改变的时候非常有用。
|#

(define flip-flop
  (let ([start #f])
    (lambda ()
      (set! start (not start))
      start)))

(flip-flop)
(flip-flop)
(flip-flop)
(flip-flop)

#|
赋值对于缓存也很有用。
下面的这个例子使用了叫做记忆化的技术
这会将上一次计算的返回值保存起来这样就不用重复计算了。
|#
(define memoize
  (lambda (proc)
    (let ([cache '()])
      (lambda (x)
        (cond
          [(assq x cache) => cdr]
          [else
           (let ([ans (proc x)])
             (set! cache (cons (cons x ans) cache))
             ans)])))))

(define fibonacci
  (memoize
   (lambda (n)
     (if (< n 2)
         1
         (+ (fibonacci (- n 1)) (fibonacci (- n 2)))))))

(fibonacci 100)

