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


;;三个函数分离
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


;Exercise 303

(define (count_v2 sexp sy)
  (local (
          ; s表达式 smybol ->N
          ; 主函数
          (define (count-sexp sexp sy)
            (cond
              [(atom? sexp) (count-atom sexp sy)]
              [else (count_sl sexp sy)]))

          ; SL Symbol ->N
          ; 计算SL中sy的数量
          (define (count-sl sl sy)
            (cond
              [(empty? sl) 0]
              [else (+ (count-sexp (first sl) sy)
                       (count-sl (rest sl) sy))]))

          ;Atom Symbol -> N
          ;计算at中的sy的数量
          (define (count-atom at sy)
            (cond
              [(number? at) 0]
              [(string? at) 0]
              [(symbol? at) (if (symbol=? at sy) 1 0)]))
          )
    (count-sexp sexp sy)))



