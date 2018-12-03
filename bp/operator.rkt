#lang racket
(require "tensor.rkt")

(provide ADD
         MUL)

;;operation add
;;x y are tensor
;;return a tensor
(define (ADD x y)
  (define result (make-tensor 0))
  (define (add-operator)
    (let ([a (tensor-get x)]
          [b (tensor-get y)])
      (tensor-set! result (+ a b))))

  (define (gradient)
    (let ([delta (tensor-get-delta result)])
      (tensor-update! x delta)
      (tensor-update! y delta)))

  (add-operator)
  (tensor-add-forward x add-operator)
  (tensor-add-forward y add-operator)
  (tensor-add-backward result gradient)

  result)


(define (MUL x y)
  (define result (make-tensor 0))
  (define (mul-operator)
    (let ([a (tensor-get x)]
          [b (tensor-get y)])
      (tensor-set! result (* a b))))
  (define (gradient)
    (let ([delta (tensor-get-delta result)]
          [_x (tensor-get x)]
          [_y (tensor-get y)])
      (tensor-update! x (* _y delta))
      (tensor-update! y (* _x delta))))
  (mul-operator)
  (tensor-add-forward x mul-operator)
  (tensor-add-forward y mul-operator)
  (tensor-add-backward result gradient)

  result)



