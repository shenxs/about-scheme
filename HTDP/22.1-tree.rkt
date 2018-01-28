#lang racket

;(make-child Child Child String Number String)
;                               出生年份 眼睛颜色
(define-struct child [father mother name date eye])

(define-struct no_parent [])
(define MTFT (make-no_parent ))
; Oldest Generation:
(define Carl (make-child MTFT MTFT "Carl" 1926 "green"))
(define Bettina (make-child MTFT MTFT "Bettina" 1926 "green"))

; Middle Generation:
(define Adam (make-child Carl Bettina "Adam" 1950 "hazel"))
(define Dave (make-child Carl Bettina "Dave" 1955 "black"))
(define Eva (make-child Carl Bettina "Eva" 1965 "blue"))
(define Fred (make-child MTFT MTFT "Fred" 1966 "pink"))

; Youngest Generation:
(define Gustav (make-child Fred Eva "Gustav" 1988 "brown"))

;;Exercise 296
;count-person
;child->Number
;计算一个家族(一颗家族树)的人数
(define (count_person a_ftree)
  (cond
    [(no_parent? a_ftree ) 0]
    [else (+ 1
             (count_person (child-father a_ftree ))
             (count_person (child-mother a_ftree)))]))
;(count_person Gustav)
;(count_person Dave)


;;Exercise 297
;计算一个家族树的平均年龄
;

;年龄总数
;Child->Number
(define (sum_age a_ftree)
  (cond
    [(no_parent? a_ftree ) 0]
    [else (+ (- 2015 (child-date a_ftree))
             (sum_age (child-father a_ftree))
             (sum_age (child-mother a_ftree)))]))

;
;Child->Number
;平均年龄
(define (average_age a_ftree)
  (/
    (sum_age a_ftree)
    (count_person a_ftree)))

;;Exercise 298
;得到一颗家族树的所有

(define (eye-color a_ftree)
  (cond
    [(no_parent? a_ftree) '()]
    [else (append (list (child-eye a_ftree)) (eye-color (child-father a_ftree) ) (eye-color (child-mother a_ftree)) )]))

#| (eye-color Gustav ) |#
#| (eye-color Adam) |#


;;Exercise 299
;child->Boolean
;判断一个child是否有一个拥有一个蓝色眼睛的祖先
;a_ftree == a family tree
(define (blue_eyed_child? a_ftree)
  (cond
    [(no_parent? a_ftree) false]
    [(string=? "blue" (child-eye a_ftree)) true]
    [else (or (blue_eyed_child? (child-father a_ftree))
              (blue_eyed_child? (child-mother a_ftree)))]))

(define (blue_eyed_ancestor a_ftree)
  (or (blue_eyed_child? (child-mother a_ftree) )
      (blue_eyed_child? (child-father a_ftree))))

;(blue_eyed_ancestor  Adam)

