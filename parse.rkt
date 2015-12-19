#lang racket
(define WRONG "错误的s表达式")

;用来处理单纯的假发和乘法

(define-struct add [left right])
(define-struct mul [left right])
(define (atom? s)
  (cond
    [(or (number? s)
         (string? s)
         (symbol? s))
     true]
    [else false]))

(define-struct def [name para body])
(define (parse s)
  (local (;S-expr -> BSL-expr
         (define (parse s)
           (cond
             [(atom? s) (parse-atom s)]
             [else (parse-sl s)]))

         ;SL -> BSL-expr
         (define (parse-sl s)
           (local ((define l (length s)))
             (cond
               [(< l 3) (error WRONG)]
               [(and (= l 3) (symbol? (first s)))
                (cond
                  [(symbol=? (first s) '+)
                   (+ (parse (second s)) (parse (third s)))]
                  [(symbol=? (first s) '*)
                   (* (parse (second s)) (parse (third s)))]
                  [else (error WRONG)])]
               [else (error WRONG)])))

         ;Atom->BSL-expr
         (define (parse-atom s)
           (cond
             [(number? s) s]
             [(string? s) (error "不可以是字符串")]
             [(symbol? s) (error "不可以是标记(symbol)")]))
          )
    (parse s)))
(parse '(+ 1 2 ))
