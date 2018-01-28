;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 13.6-FSM) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t write repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp")) #f)))

(define-struct transition [current next])

(define fsm-traffic
  (list (make-transition "red" "green")
        (make-transition "green" "yellow")
        (make-transition "yellow" "red")))

(define (state=? s1 s2)
  (if (and (string=? (transition-current s1) (transition-current s2))
           (string=? (transition-next s1) (transition-next s2)))
    true false))

(define BW-fsm
  (list (make-transition "black" "white")
        (make-transition "white" "black")))

(define (simulate a-fsm current)
  (big-bang (make-fs a-fsm current)
            [to-draw state-render]
            [on-key find-next-state]))
(define-struct fs [fsm current])
(define (state-render fs)
  (square 100 "solid" (fs-current fs)))
(define (find-next-state fs key)
  (make-fs (fs-fsm fs) (find (fs-fsm fs) (fs-current fs))))

(define (find fsm c)
  (cond
    [(empty? fsm) (error "未找到下一状态")]
    [else (if (string=? c (transition-current (first fsm)))
            (transition-next(first fsm))
            (find (rest fsm) c))]))
;(simulate fsm-traffic "red")
(define-struct ktransition [current key next])
(define key-fsm
  (list
        (make-ktransition "a" "a" "a")
        (make-ktransition "a" "b" "b")
        (make-ktransition "b" "b" "b")
        (make-ktransition "b" "c" "c")
        (make-ktransition "c" "b" "b")
        (make-ktransition "c" "c" "c")
        (make-ktransition "c" "d" "d")
        (make-ktransition "b" "d" "d")
        (make-ktransition "d" "any" "end")
        (make-ktransition "end" "any" "end")
        ))

(define (simulate.key a-fsm current)
  (big-bang (make-fs a-fsm current)
            [to-draw key-state-render]
            [on-key find-next-key]))

(define (key-state-render fs)
  (text  (fs-current fs) 24 "black"))

(define (find-next-key fs key)
  (make-fs (fs-fsm fs)  (find-key (fs-fsm fs) (fs-current fs) key)))
(define (find-key fsm c ke)
  (cond
    [(empty? fsm) "error"]
    [else (if (and
                (if (string=? c (ktransition-current (first fsm))) true
                  (if (string=? "any" (ktransition-current (first fsm)  )) true false))
                (if (string=? ke (ktransition-key (first fsm) )) true
                  (if (string=? "any" (ktransition-key (first fsm))) true   false)))
            (ktransition-next (first fsm)) (find-key (rest fsm) c ke))]))
(simulate.key key-fsm "a")
