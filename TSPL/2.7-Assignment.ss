;;racket和chez的语法有些不一样
;;一些代码写在这里因为racket无法运行或者需要额外的包,和已有的冲突



(define make-queue
  (lambda ()
    (let ([end (cons 'ignore '())])
      (cons end end))))

(define putq!
  (lambda (q v)
    (let ([end (cons 'ignore '())])
      (set-car! (cdr q) v)
      (set-cdr! (cdr q) end)
      (set-cdr! q end))))

(define getq!
  (lambda (q)
    (if (emptyq? q)
        (assertion-violation 'getq! "队列为空" q)
        (car (car q)))))


(define delq!
  (lambda (q)
    (if (emptyq? q)
        (assertion-violation 'delq! "队列为空" q)
        (set-car! q (cdr (car q))))))


(define myq (make-queue))

(putq! myq 'a)

(putq! myq 'b)

(getq! myq)

(delq! myq)

(getq! myq)


;;Exercise 2.9.5

(define emptyq?
  (lambda (q)
    (if (> (length (car q)) 1)
        #f #t)))

(define myq2 (make-queue))

(putq! myq2 'a)

(delq! myq2)

(emptyq? myq2)

(getq! myq2)


;;2.9.6



(define make-queue
  (lambda ()
    (cons '() '())))


(define (putq! q v)
  (let ([p (cons v '())])
    (if (null? (car q))
        (begin
          (set-car! q p)
          (set-cdr! q p))
        (begin
          (set-cdr! (cdr q) p)
          (set-cdr! q p)))))


(define (getq! q)
  (car (car q)))

(define (delq! q)
  (if (eq? (car q) (cdr q))
      (begin
        (set-car! q '())
        (set-cdr! q '()))
      (set-car! q (cdr (car q)))))

(define myq (make-queue))

(putq! myq 'a)
(putq! myq 'b)
(putq! myq 'c)

(delq! myq)

;;队列的实现来看
;;有占位符实现
;;罗辑一致添加和删除的时候没有特殊情况
;;浪费占位符的空间
;;插入的步骤需要3,删除1步


;;无占位符
;;处理的时候需要判断是否是空队列,是否队列里面只有一个元素
;;节省占位符空间
;;代码实现需要分类所以显得啰嗦
;;罗辑步骤更加简单



(define (list? l)
  (cond
   [(null? l) #t]
   [(symbol? l) #f]
   [else (list? (cdr l))]))
(list?  '())

(list? '(1 2 3))

(list? '(a . b))

;;2.9.8

(define (race hare tortoise)
  (if (pair? hare)
      (let ([hare (cdr hare)])
        (if (pair? hare)
            (and (not (eq? hare tortoise))
                 (race (cdr hare) (cdr tortoise)))
            (null? hare)))
      (null? hare)))


(define list?
  (lambda (x)
    (race x x)))



