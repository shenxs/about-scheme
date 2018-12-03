#lang racket
(require "tensor.rkt")

(provide ADD
         MUL)



(define (DIV x y)
  (define result (make-tensor 0))
  (define (div-op)
    (tensor-set! result
                 (/ (tensor-get x) (tensor-get y) )))

  (define (gradient)
    (let ([delta (tensor-get-delta result)]
          [in1 (tensor-get x)]
          [in2 (tensor-get y)])
      (tensor-update! x (* delta (/ 1 (tensor-get y))))
      (tensor-update! y (* delta (- (/ in1 (sqr in2)))))))

  (div-op)

  (tensor-add-forward x div-op)
  (tensor-add-forward y div-op)
  (tensor-add-backward result gradient))

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



