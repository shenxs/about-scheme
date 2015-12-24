#lang racket
(define WRONG "错误的s表达式")

;用来处理单纯的加法和乘法
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
                   (make-add (parse (second s)) (parse (third s)))]
                  [(symbol=? (first s) '*)
                   (make-mul (parse (second s)) (parse (third s)))]
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

(define (subst ex x v)
  (cond
    [(empty? ex) '()]
    [(symbol=? x (first ex)) (cons v (rest ex))]
    [else (cons (first ex) (subst (rest ex) x v))]))

(define (numberic? ex x v)
  (local (
          ;;替换symbol为
          (define ex2 (subst ex x v))
          )
    (if (or (mul? (parse ex2))
            (add? (parse ex2)))
      true
      false)))

(define (parse2 x)
  (parse (subst x 's 7)))





;S-expression -> BSL-fun-def
;将s表达式转换成BSL(if possible)
(define (def-parse s)
  (local (
          ;S-expression ->BSL-expression
          (define (def-parse s)
            (cond
              [(atom? s) (error WRONG)]
              [else
                (if (and (= 3 (length s)) (eq? 'define (first s)) )
                  (head-parse (second s) (parse (third s)))
                  (error WRONG))]))

          (define (head-parse s body)
            (cond
              [(atom? s) (error WRONG)]
              [else
                (if (not (= (length s) 2))
                  (error WRONG)
                  (local
                    (
                     (define name (first s))
                     (define para (second s))
                     )
                    (if (and (symbol? name) (symbol? para))
                      (make-def name para body)
                      (error WRONG))
                    ))]))
          )
    (def-parse s)))

(def-parse '(define x 7))
