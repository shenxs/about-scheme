#lang racket
;;List and pairs
;;列表和序对
;; 序对或者叫cons单元,是最基础的scheme结构类型.通过序对的cdr部分可以构建一个list,list中的元素都存在car里面cdr存放下一个序对,最后一个序对的cdr里面应该是一个空表---().如果不是那么这不是一个良构的表.

;;pairs也可以用来构建二叉树.树中的每个序对都是二叉树的内部节点,car和csdr是当前节点的子节点

;;良构的list会被包裹在括号中,以空格间隔作为一个序列打印.
;;中括号有可能被用来代替小括号,空表还是用()表示.

;;非良构的表和树有一些复杂,单个序对是以两个对象,中间加一个.的形式表示的
;;如(a . b) 。这是一个点序对的记法。
;;非良构的列表和数可以用这种点序对的方式标记,比如:(1 2 3 . 4) 或((1 . 2) . 3)
;;良构的list也可以这么表示例如:
;;(1 . (2 . (3 . ())))


;;有可能通过set-car!,和set-cdr!创造出死循环的列表.这样的list不是良构的.

;;接收list参数的函数需要检测这是否是一个良构的list只能通过遍历的方式
;;要么遇到不合法的结尾了要么由于圈的存在死循环了.

;;例如member不需要检测list是否是非法的,这要他可以找到他要找的元素就可以了
;;list-ref也不需要检测了list中是否存在圈,因为他是通过递归来递增下标的.


;;函数(cons obj1 obj2)
;;返回一个car是obj1 cdr是obj2的序对

;;(car pair) 返回pair的car部分
;;(cdr pair) 返回pair的cdr部分
;;(set-car! pair obj) 设置pair的car为obj
;;(set-cdr! pair obj) 如上

;;caar cadr cddddr
;;c和r之间的字母分别代表了car和cdr,并且对其参数从右向左应用
;;例如cadr等价于(lambda (x) (car (cdr x)))



;;(list obj ...) 返回一个obj ...组成的列表

;;函数(cons* obj ... final-obj)
;;返回由final-obj组成的一个list(可能不是良构的)

;;(list? obj) 返回obj是否是一个良构的list

;;(length list) 返回list的element的个数
;;使用龟兔赛跑算法来计算


;;函数(list-ref list n)
;;返回返回list中的第n和值(从0开始)

;;函数(list-tail list n)
;;返回从n开始的剩下的元素。


;;函数(append)
;;函数(append list ... obj)

;;append 将第一个和第二个列表,第三个列表的...的元素组合在一起组成一个列表,除了最后一个元素之外剩下的都必须是序对构成的.最后一个元素会简单地放在列表的末尾.

;;(reverse list)
;;将一个list倒置

;;(member obj list)
;;(memq obj list)
;;(memv obj list)

;;返回第一个tail,tail的car等于obj,不然就返回#f
;;memq  -- eq?
;;memv  -- eqv?
;;member equal?
;;区别是比较函数不同

(memq 'a '(b c a d e))
(memq 'a '(b c d e g))
(memq 'a '(a a c d f))


;;(memf pro list)
;;chez scheme叫做memp
;;类似于member,使用pro寻找元素,pro接收一个参数


;;(remq obj list)
;;(remv obj list)
;;(remove obj list)
;;将list中出现的obj移除,
;;使用的比较函数分别是eq? eqv? equal?

;;(remf pro list)使用pro
;;使用pro来判断是否删除删除


;;(filter procedure list)
;;返回 list包含procedure返回true的部分


;;(partition pro list)
;;pro接收一个参数返回一个返回值,不能修改list
;;partition接收一个list返回两个list一个是pro返回true的list
;;另一个是pro返回false的list

;;(find pro list)
;;找到第一个pro返回true的元素


;;(assq obj alist)
;;(assv obj alist)
;;(assoc obj alist)
;;返回第一个alist中car等于obj的元素,不存在则返回#f

(define (assq x ls)
  (cond
    [(null? ls) #f]
    [(eq? (caar ls) x) (car ls)]
    [else (assq x (cdr ls))]))

;;assv 和assoc和其不同之处是使用eqv? 和equal?来代替eq?作比较

(assq 'b '((a . 1) (b . 2)))


;;(assp procedure alist)
;;使用procedure做判断,如果不存在则返回#f
;;a-list必须是协同列表,每个列表的元素都是(key . value)的形式

(assf odd? '((1 . a) (2 . b)))


;;(list-sort predicate list)
;;根据predicate将list排序
;;predicate 应该接收两个参数,如果说以第一参数应该排在第二参数之前那就返回#t
;;predicate有可能被调用nlogn次,n为列表长度.

(sort  '(3 4 1 3 4 9 7 3 1 1 -1) <)


