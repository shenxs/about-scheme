;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 22.6-Simplifying-Function) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))

; S-expr Symbol Atom -> S-expr
; replaces all occurrences of old in sexp with new

(check-expect (substitute 'world 'hello 0) 'world)
(check-expect (substitute '(world hello) 'hello 'bye) '(world bye))
(check-expect (substitute '(((world) bye) bye) 'bye '42) '(((world) 42) 42))

(define (atom? x)
  (cond
    [(symbol? x) true]
    [(string? x) true]
    [(number? x) true]
    [else false]))

(define (substitute sexp old new)
  (local (; S-expr -> S-expr
          (define (subst-sexp sexp)
            (cond
              [(atom? sexp) (subst-atom sexp)]
              [else (subst-sl sexp)]))

          ;anyc->boolean
          ;judge wheatheaer somec is a atom
          (define (atom? x)
            (cond
              [(string? x) true]
              [(number? x) true]
              [(symbol? x) true]
              [else false]))
          ; SL -> S-expr
          (define (subst-sl sl)
            (cond
              [(empty? sl) '()]
              [else (cons (subst-sexp (first sl)) (subst-sl (rest sl)))]))

          ; Atom -> S-expr
          (define (subst-atom at)
            (cond
              [(number? at) at]
              [(string? at) at]
              [(symbol? at) (if (symbol=? at old) new at)])))
    ; — IN —
    (subst-sexp sexp)))


(define (substitute.v2 sexp old new)
  (local (; S-expr -> S-expr
          (define (subst-sexp sexp)
            (cond
              [(atom? sexp) (subst-atom sexp)]
              [else (subst-sl sexp)]))

          ; SL -> S-expr
          (define (subst-sl sl)
            (map subst-sexp sl))

          ; Atom -> S-expr
          (define (subst-atom at)
            (if (eq? at old) new at)))
    ; — IN —
    (subst-sexp sexp)))

(define (substitute.v3 sexp old new)
  (local(;S-expr->S-expr
         (define (subst-sexp sexp)
           (cond
             [(atom? sexp) (if (eq? sexp old) new sexp )]
             [else (map subst-sexp sexp)]))

         ;SL -> S-expr
         (define (subst-sl sexp)
           (map subst-sl sexp))
         )
    ;-- IN--
    (subst-sexp sexp)
    ))

;;最终化简的结果

(define (Substitute sexp old new)
  (cond
    [(atom? sexp) (if (eq? sexp old) new old)]
    [else (map ( λ (s) (Substitute s old new)) sexp) ]))
