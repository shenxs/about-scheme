;大型的软件系统通常需要配置文件才能够正确的运转
;系统管理员通常要应对不同的软件系统
;配置文件指的是程序启动时所需要的数据
;配置文件从某种意义上来说就是一个附加的申明
;因为它有时候相当的复杂,所以程序设计者更喜欢用另一套不同的机制去处理它
;因为软件工程师不确定系统管理员是否懂得编写软件所使用的语言
;所以工程师们设计了一种简单的,目的明确的配置语言
;这种特殊的语言也被叫做 domain-specific language(DSL)
;使用dsl大大简化了系统管理员的工作
;系统管理员会写一些xml"程序"来配置他们要启动的系统
;又提到了有限状态机 .我们要给他设计一个DSL

#lang racket
(require 2htdp/universe
         2htdp/image
         "25-XML.rkt")

; A FSM is a [List-of 1Transition]
; A 1Transition is a list of two items:
;   (cons FSM-State (cons FSM-State '()))
; A FSM-State is a String that specifies color

; data examples
;作为数据的例子
(define fsm-traffic
  '(("red" "green") ("green" "yellow") ("yellow" "red")))

; FSM FSM-State -> FSM-State 有限状态机 从一个状态到另一个状态
; match the keys pressed by a player with the given FSM  每按一次键,就切换当前的状态,看上去的就是按一下切换颜色
(define (simulate state0 transitions)
  ; State of the World: FSM-State
  (big-bang state0
    [to-draw
      (lambda (current)
        (overlay
          (text current 24 "indigo")
         (square 100 "solid" current)))]
    [on-key
      (lambda (current key-event)
        (find transitions current))]))

; [List-of [List X Y]] X -> Y
; finds the matching Y for the given X in the association list
; 从alist中找到x对应的下一个状态应该是什么
(define (find alist x)
  (local ((define fm (assoc x alist)))
    (if (cons? fm) (second fm) (error "next state not found"))))
;去掉下面的注释可以测试程序运行
;; (simulate "red" fsm-traffic)

;Exercise 365
;修改render函数,将当前状态显示在square上面

;Exercise 366
;重新设计find函数
;没看到为什么,暂时留着

;Exercise 367
;改变数据的定义方式,以此让某些按键并不触发颜色变换
;并且不改变find函数自身
(define fsm-key-traffic
  '(("red"  "green" " " ) ("green" "yellow" " ") ("yellow"  "red" " ")))
(define (simulate2 state0 transitions)
  ; State of the World: FSM-State
  (big-bang state0
    [to-draw
      (lambda (current)
        (overlay
          (text current 24 "indigo")
         (square 100 "solid" current)))]
    [on-key
      (lambda (current key-event)
        (local ((define right-key (third (assoc current transitions))))
          (cond
            [(key=? key-event right-key) (find transitions current)]
            [else current])))]))

;; (simulate2 "red" fsm-key-traffic)


;Exercise 368
;设计xml语句来配置机器,从白色到黑色,不考虑按键

;; <machine initial="balck">
;; <action state="black" next="white" />
;; <action state="white" next="black" />
;; </machine>

;;Xmachine 版本

(define Xmachine
  '(machine ((initial "black"))
          (action ((state "black") (next "white")))
          (action ((state "white") (next "black")))))


;Sample Problem
;设计一个程序,使用xmachine来使simulate工作
(xexpr-attributes Xmachine)

(define (simulate-xmachine machine)
  (local(
         ;初始状态
         (define state0 (second (first (xexpr-attributes machine))))
         ;从machine中提取出所需数据
         (define (tiqu-machine m)
           (local(
                  (define content (xexpr-content m))
                  (define (action-state a)
                    (second (first (xexpr-attributes a))))
                  (define (action-next a)
                    (second (second (xexpr-attributes a))))
                  (define (make-action action so-far)
                    (cons (list (action-state action) (action-next action)) so-far))
                  )
                (foldr make-action '() content )
             ))
         ;类似fsm-traffic的数据定义
         (define data (tiqu-machine machine))
         )
    (simulate state0 data)))

(simulate-xmachine Xmachine)
