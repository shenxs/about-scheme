#lang racket

; An S-expr (S-expression) is one of:
; – Atom
; – SL
; An SL (S-list) is one of:
; – '()
; – (cons S-expr SL)
; An Atom is one of:
; – Number
; – String
; – Symbol

;Exercise 302
(define (atom? X)
  (cond
    [(symbol? X) true]
    [(string? X) true]
    [(number? X) true]
    [else false]))

;determines how many times some symbol sy occurs
;in some S-expression sexp
;S-expression Symbol ->Number
;计算S表达式中有多少sy Symbol
(define (count sexp sy)
  (cond
    [(atom? sexp) (count_atom sexp sy)]
    [else (count_sl sexp sy)]))

(define (count_atom at sy)
  (cond
    [(symbol? at) (if (symbol=? at sy) 1 0 )]
    [(string? at) 0]
    [(number? at) 0]))

(define (count_sl sl sy )
  (cond
    [(empty? sl) 0 ]
    [else (+ (count (first sl) sy) (count_sl (rest sl) sy))]))

(count '(wing (wing (wing body wing) wing) wing) 'wing )
