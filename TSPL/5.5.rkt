#lang racket

;;map以及folding

#|
当程序需要在列表元素上进行递归或者迭代操作的时候，mapping和floding通常来说都是比较方便的。
这些操作是null检查以及挨个应用过程的抽象，有一些map操作也可以使用在向量和string上。
|#



#|
syntax：（map procedure list1 list2 。。。）
返回：一个结果的list

map将procedure应用与list1，list2对应的元素上，返回一个list作为返回值。list1 list2长度必须相同
procedure必须接受和list数量一致的参数，并且返回一个值，不能改变list里面的元素。
|#

(map abs '(1 -2 3 -4 5 -6))

(map (lambda (x y) (* x y))
     '(1 2 3 4)
     '(8 7 6 5))

;;虽然应用自身出现的顺序不固定，但是输出的结果的顺序和输入列表中的元素是对应的。
;;map可能是这样定义的

;; (define map
;;   (lambda (f ls . more)
;;     (if (null? more)
;;         (let map1 ([ls ls])
;;           (if (null? ls)
;;               '()
;;               (cons (f (car ls))
;;                     (map1 (cdr ls)))))
;;         (let map-more ([ls ls] [more more])
;;           (if (null? ls)
;;               '()
;;               (cons
;;                (apply f (car ls) (map car more))
;;                (map-more (cdr ls) (map cdr more))))))))

#|
这个版本的map没有错误检测。在设计map时递归地调用了自身，因为有单list的特例存在所以这是可行的。
|#


#|
语法：（for-each procedure list1 list2）
返回值：不确定

for-each 和map类似，除了不像那样返回一个list，for-each保证procedure是按照序列从左向右应用的，procedure必须接收和list的数量一样多的参数。没有错误检测的foreach可以这样定义

(define for-each
  (lambda (f ls . more)
    (do ([ls ls (car ls)]
         [more more (map cdr more)])
        ((null? ls))
      (apply f (car ls) (map car more)))))

|#

(let ([same-count 0])
  (for-each
   (lambda (x y)
     (when (= x y)
       (set! same-count (+ same-count 1))))
   '(1 2 3 4 5 6)
   '(2 3 3 4 7 6))
  same-count)
