#lang racket

#|
延续是一个过程，代表了给定点的接下来的计算，这可以通过(call-with-current-continuation)得到，也可以简写成call/cc
|#

#|
过程：（call/cc produce）
过程：(call-with-current-continuation procedure)

这两个过程是一样的，前者是后者的简写
call/cc获得他的延续，并将此延续传递给procedure，procedure应该接受一个参数。延续可以看做是一个函数，每一次延续应用在0或者更多的值上时。
这个值就被返回给call/cc 作为call/cc这个application的延续。
也就是说当延续这个过程被调用的时候，他会将他的参数作为call/cc的返回值
延续可以用来实现非本地的退出，回溯，协程，以及多任务.


下面的例子展示了一个使用continuation来做非本地的退出的应用
|#

(define (member x ls)
  (call/cc (lambda (break)
             (do ([ls ls (cdr ls)])
                 ((null? ls) #f)
               (when (equal? x (car ls))
                 (break ls))))))

(member 'd '(a b c ))

(member 'd '(a b c d))

(member 'b '(a b c d))

#|
当前的延续在内部的表示方式是一个过程调用的栈，通过将栈封装在一个过程对象中的
方式来表示一个延续。由于封装的堆栈大小是不确定的，因此必须有某种机制无限地保留
堆栈中的内容。这可以以非常简单的高效的方式做到，并且不影响不使用延续的代码
|#
