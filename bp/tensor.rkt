#lang racket

(provide make-tensor
         tensor?
         tensor-get
         tensor-get-delta
         tensor-set!
         tensor-update!
         tensor-add-forward
         tensor-add-backward)

(define (make-tensor n)
  (let ([content n]
        [type 'tensor]
        [delta 0]
        [forward-procs '()]
        [backward-procs '()])

    (define (setter n)
      (set! content n)
      (for-each (lambda (x) (x))
                forward-procs))

    (define (update d)
      (set! delta  d)
      (if (empty? backward-procs)
          (begin
            (set! content (- content d))
            (for-each (lambda (x) (x))
                      forward-procs))
          (for-each (lambda (x) (x))
                    backward-procs)
          ))

    (define (add-forward-procs p)
      (set! forward-procs (cons p forward-procs)))

    (define (add-backward-procs p)
      (set! backward-procs (cons p backward-procs)))

    (define (dispatcher action)
      (cond
        [(symbol=? action 'get) content]
        [(symbol=? action 'get-delta) delta]
        [(symbol=? action 'set) setter]
        [(symbol=? action 'update) update]
        [(symbol=? action 'add-forward) add-forward-procs]
        [(symbol=? action 'add-backward) add-backward-procs]
        [(symbol=? action 'get-type) type]
        [else (error "Unknow action")]))

    dispatcher))


(define (tensor? t)
  (with-handlers ( [exn:fail?  (lambda (e) #f)])
    (symbol=? 'tensor (t 'get-type))))

(define (tensor-get t)
  (t 'get))

(define (tensor-get-delta t)
  (t 'get-delta))

(define (tensor-set! t n)
  ((t 'set) n))

(define (tensor-update! t delta)
  ((t 'update) delta))

(define (tensor-add-forward t a)
  ((t 'add-forward) a))

(define (tensor-add-backward t a)
  ((t 'add-backward) a))
