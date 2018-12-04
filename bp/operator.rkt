#lang racket
(require "tensor.rkt")

(provide (all-defined-out))


;; in 输入 list of tensor 例如 (list x y)
;; op 计算函数 function 参数对应计算的数量 参数为 tensor中的值 而非整个tensor
;; gradient  梯度下降函数  在反向传播时被调用 负责梯度下降和更新
(define (make-operator in op gradient)
  (define (abstract-op) (apply op (map tensor-get in)) )
  (define result (make-tensor (abstract-op)))

  (define (abstract-gradient) (apply gradient
                                     (cons (tensor-get-delta result)
                                           (map tensor-get in))))
  (for ([i in])
    (tensor-add-forward i
                        (lambda ()
                          (tensor-set! result (abstract-op)))))
  (tensor-add-backward result abstract-gradient)

  result)

(define (ADD x y)
  (define (add-op _x _y)
    (+ _x _y))
  (define (gradient delta _x _y)
    (tensor-update! x delta)
    (tensor-update! y delta))
  (make-operator (list x y) add-op gradient)
  )

(define (MUL x y)
  (define (mul-op _x _y)
    (* _x _y))
  (define (gradient delta _x _y)
    (tensor-update! x (* delta _y))
    (tensor-update! y (* delta _x)))
  (make-operator (list x y) mul-op gradient)
  )

(define (DIV x y)
  (define (div-op _x _y)
    (/ _x _y))
  (define (gradient delta _x _y)
    (tensor-update! x (* delta (/ 1 _y)))
    (tensor-update! y (* delta (- (/ _x (sqr _y))))))
  (make-operator (list x y) div-op gradient)
  )


(define (MINUS x y)
  (define (minus-op _x _y)
    (- _x _y))
  (define (gradient delta _x _y)
    (tensor-update! x delta)
    (tensor-update! y (- delta)))
  (make-operator (list x y) minus-op gradient))

(define (SIN x)
  (define (sin-op _x)
    (sin _x))
  (define (gradient delta _x)
    (tensor-update! x (* (cos _x) delta)))
  (make-operator (list x) sin-op gradient)
  )

(define (COS x)
  (define (cos-op _x)
    (cos _x))
  (define (gradient delta _x)
    (tensor-update! x (* delta (- (sin _x)))))
  (make-operator (list x) cos-op gradient)
  )

(define (TAN x)
  (define (tan-op _x)
    (tensor-set! x (tan _x)))
  (define (gradient delta _x)
    (tensor-update! x (* delta (/ 1 (sqr (cos _x))))))
  (make-operator (list x) tan-op gradient)
  )

(define (LN x)
  (define (ln-op _x)
     (log _x))
  (define (gradient delta _x)
    (tensor-update! x (* delta (/ 1 _x))))
  (make-operator (list x) ln-op gradient)
  )

(define (EXP x)
  (define (exp-op _x)
    (exp _x))
  (define (gradient delta _x)
    (tensor-update! x (* delta (exp _x))))
  (make-operator (list x) exp-op gradient)
  )

(define (EXPT x y)
  (define (power-op _x _y)
    (expt _x _y))
  (define (gradient delta _x _y)
    (tensor-update! x (* delta (* _y (expt _x (- _y 1)))))
    (tensor-update! y (* delta (* (log _x)
                                  (exp (* _y (log _x)))))))
  (make-operator (list x y) power-op gradient))

(define (LOG x y)
  (define (log-op _x _y)
    (/ (log (tensor-get _x))
       (log (tensor-get _y))))
  (define (gradient delta _x _y)
    (tensor-update! x (* delta (- (/ (log _y)
                                     (* _x (sqr (log _x)))))))
    (tensor-update! y (* delta (/ 1 (* _y (log _x))))))
  (make-operator (list x y) log-op gradient))

