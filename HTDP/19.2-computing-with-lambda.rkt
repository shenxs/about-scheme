#lang racket

(define (f x) (* 10 x))
;is short for

#| (define f |#
  #| (lambda (x) |#
    #| (* 10 x))) |#

#| ;;exercise 268 |#
#| ;number->boolean |#
#| (define (compare x) |#
  #| (= (f-plain x) (f-lambda x))) |#



;;这中间有许多单步测试的练习,就不在vim里面测试了

;这里有一个比较好玩的语句
;注意没有在vim中实测运行过,racket的结果就是死循环这条语句没有结束的时候
;((lambda (x) ( x x ) ) (lambda (x) (x x))
;这条语句会不停的展开一致保持这个状态,现在是这样,以后也一直会使这样


;;GG
;2015-09-26 15:10:50
