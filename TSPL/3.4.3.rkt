#lang racket

;; 使用cps风格重写一下函数

;; (define reciprocals
;;   (lambda (ls)
;;     (call/cc
;;      (lambda (k)
;;        (map (lambda (x)
;;               (if (= x 0)
;;                   (k "zero found")
;;                   (/ 1 x)))
;;             ls)))))


(define (reciprocals ls k)
  (let ([break k])
    (let f ([ls ls] [k k])
      (cond
        [(null? ls) (k '())]
        [(= 0 (car ls)) (break "zero found")]
        [else (f (cdr ls) (lambda (x) (k  (cons (/ 1 (car ls)) x))))]))))

(reciprocals '(1 2 0 34 5) values)
(reciprocals '(1 2 3 1/2 3 4) values)
