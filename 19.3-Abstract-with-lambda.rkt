#lang racket


(define-struct posn [x y])

;Exercise 272
(define hui-lv 1.2)


(define (court0-euro l)
  (map (lambda (x) (* x hui-lv) l)))

(define (translate l)
  (map (lambda (p) (list (posn-x p) (posn-y p))) l))


;Exercise 273
(define-struct ir [name price])
(define ( sort_by_price l)
  (sort l (lambda (i1 i2) (> (ir-price i1 ) (ir-price i2)))))


;Exercise 274
;Number ,ua ,list of ir ->list of ir
(define (eliminate-exp n ua l)
  (filter (lambda (ir) (< (ir-price ir) ua)) l))

(define (recall ty l)
   (filter (lambda (ir) (not (string=? (ir-name ir) ty))) l))

(define (selection l1 l2)
  (local(
         (define (in? n l)
           (cond
             [(empty? l) false]
             [(= n (first l) ) true]
             [else (in? n (rest l))]))
         (define (in-l1? n)
           (in? n l2))
         )
    (filter in-l1?  l2)))

;不知道怎么用lambda实现,因为lambda为匿名调用所以在做递归的时候总是不知道怎么实现


;;Exercise 275


(define (build-nature n)
  (build-list n (lambda (n) n)))
;(build-nature 7)
(define (build-nature+1 n)
  (build-list n (lambda (n) (+ n 1))))

(define f (λ (x) (* x x)) )
(f 3)

;;由于λ演算的递归实现还没有想到所以先跳过这些东西
