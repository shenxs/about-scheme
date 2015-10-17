;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 22.3-S-expressions) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))

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
;sl is one of
;(atom atom ....atom)
;(atom sl)
;
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

;Exercise 304
;计算s表达式的深度
;atom元素的深度等于1

;sl->Number

;a ->1
;(z b) ->1
;(1 2 4 (2 (2 4 ) 5) 1  ) ->3
;(1 2 ( 3 3 ) (3 (5 6)))  ->3

(define (depth sl)
  (cond
    [(atom? sl) 1]
    [(empty? sl) 0 ]
    [else (max (+ 1 (depth (first sl))) (depth (rest sl)))]))

;(depth '(1 2 4 (2 (2 ( + 6 (6 9)) ) 5) 1  ))
;(depth '(a))


;;Exercise 305
;S-expression ,old(symbol),new(symbol)->S-expression
;将S-expression 中的old替换为new

(define (substitute S_expression old new)
  (cond
    [(empty? S_expression ) '()]
    [(number? S_expression) S_expression]
    [(atom? S_expression) (if (symbol=? S_expression old) new S_expression)]
    [else (cons (substitute (first S_expression) old new) (substitute (rest S_expression) old new) )]
    ))

(substitute '(2 3 (3 4 haha ha) ha ) 'ha 'wa )






