;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |38|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "abstraction.rkt" "teachpack" "2htdp")) #f)))

;; (λ (x) x)
;; ;需要y被绑定
;; ;; (λ (x) y)
;; (λ (y) (λ (x) y))
;; ((λ (x) x) (λ (x) x))
;; ;无限循环
;; ;((λ (x) (x x)) (λ (x) (x x)))
;; (((λ (y) (λ (x) y))
;; (λ (z) z))
;; (λ (w) w))
;; ;;==>
;; ((λ (x) (λ (z) z))
;; (λ (w) w))
;; ;;==>
;; ((λ (z) z) (λ (w) w))
;; ;;==>
;; (λ (w) w)

(define ex1 '(λ (x) x))
(define ex2 '(λ (x) y))
(define ex3 '(λ (y) (λ (x) y)))
(define ex4 '((λ (x) (x x)) (λ (x) (x x))))

;Exercise 488
(define (is-var? item)
  (if (and (symbol? item) (not (symbol=? 'λ item)))
      #t #f))

(define (is-λ? item)
  (if (cons? item)
      (if (symbol? (first item))
          (if (symbol=? 'λ (first item))
              #t #f)
          #f)
      #f))

(define (is-app? item)
  (if (and (cons? item) (= 2 (length item)))
      #t #f))

(define (λ-para item)
  (cond
    [(= 2 (length item)) (second (first item))]
    [(= 3 (length item)) (second item)]))
(define (λ-body item)
  (cond
    [(= 2 (length item)) (third (first item))]
    [(= 3 (length item)) (third item)]))
(define (app-fun item)
  (first item))
(define (app-arg item)
  (second item))

;;给出λ表达式的参数
;; (define (declareds)
;; )

(define (undeclareds le0)
  (local (; Lam [List-of Symbol] -> [List-of Symbol]
          ; accumulator declareds is a list of all λ
          ; parameters on the path from le0 to le
          (define (undeclareds/a le declareds)
            (cond
              [(is-var? le)
               (if (member? le declareds) le '*undeclared)]
              [(is-λ? le)
               (local ((define para (λ-para le))
                       (define newd (append para declareds))
                       (define body (undeclareds/a (λ-body le) newd)))
                 (list 'λ  para body))]
              [(is-app? le)
               (list (undeclareds/a (app-fun le) declareds)
                     (undeclareds/a (app-arg le) declareds))]
              [else (cons le declareds)])))
    (undeclareds/a le0 '())))
(is-λ? ex4)
(check-expect (undeclareds ex1) ex1)
(check-expect (undeclareds ex2) '(λ (x) *undeclared))
(check-expect (undeclareds ex3) ex3)
(check-expect (undeclareds ex4) ex4)
