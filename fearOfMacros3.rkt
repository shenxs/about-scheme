#lang racket
(require (for-syntax racket/match)
         (for-syntax racket/syntax)
         (for-syntax racket/string))
;;可以简单地重新组合,easy
;; (define-syntax (my_if stx)
;;   (match (syntax->list stx)
;;     [(list _ condition t f)
;;      (datum->syntax stx `(cond [,condition ,t ]
;;                                [else ,f]))]))

;; (define-syntax (mylet stx)
;;   (syntax-case stx ()
;;     [(_ ([name:id var:expr] ... ) body ...)
;;      #'((λ (name:id ...) body ...) var:expr ...)]))


;; (define-syntax (hypen-define stx)
;;   (syntax-case stx ()
;;     [(_ (names ...) (args ...) body0 body ...)
;;      (let*
;;          ([name (map syntax-e (syntax-e #'(names ...)))]
;;           [name2 (map symbol->string name)]
;;           [name  (string-join name2 "-")]
;;           [name2 (string->symbol name)])
;;        (with-syntax ([fName (datum->syntax stx name2)])
;;          #'(define (fName args ...)
;;              body0
;;              body ...)))]))


;; (hypen-define (foo bar fun) (x) (* x x))


;; (define-syntax (my_struct stx)
;;   (syntax-case stx ()
;;     [(_ id [fields ...])
;;      ;检查语法
;;      (for-each (λ (x)
;;                  (unless (identifier? x)
;;                    (raise-syntax-error #f "不是标识符" stx x)))
;;                (cons #'id (syntax->list #'[fields ...])))
;;      (with-syntax ([pred-id (format-id stx "~a?" #'id)])
;;        #`(begin
;;            ;;定义构建器
;;            (define (id fields ...)
;;              ;;如果直接使用id id是一个procedure ,'id是指的结构体的名字
;;              (apply vector (cons 'id (list fields ...))))

;;            ;;定义谓词函数
;;            (define (pred-id x)
;;              (and
;;               (vector? x)
;;               (eq? 'id (vector-ref x 0))))
;;            ;定义accessor

;;            #,@(for/list ([x (syntax->list #'[fields ...])]
;;                          [n (in-naturals 1)])
;;                 (with-syntax ([fName (format-id stx "~a.~a" #'id x)]
;;                               [ix n])
;;                   #'(define (fName s)
;;                       (vector-ref s ix))))
;;            ))]))

;; (my_struct posn [x y])

;; (define a (posn 1 2))

;; ;; (posn? a)
;; ;; (vector? a)
;; ;; (vector-ref a 0)



;; ;;设定js对象

(define js (hasheq 'a (hasheq 'b (hasheq 'c "value"))))

;; (hash-ref js 'a)



;->* 设定可选的参数形式
;(->* (强制参数 ...) 可选参数 rest pre range post)

(define/contract (hash-refs h l [def #f])
  ((hash? list?) (any/c) . ->* . any)
  (with-handlers ([exn:fail? (const (cond [(procedure? def) (def)]
                                          [else def]))])
    (displayln l)
    (for/fold ([h h])
              ([k (in-list l)])
      (hash-ref h k))))

;; (hash-refs js '(a b c))


;找到字符串匹配的地方然后将其切割
;; (regexp-split #rx"\\." "js.a.b.c")
;==> '("js" "a" "b" "c")

(require racket/syntax)
(format-id #f "~a" "hello")

;;in-list用于for循环,效率更加高
(define-syntax (hash.ref stx)
  (syntax-case stx ()
    ;如果没有可选项用#f代替
    [(_ chain) #'(hash.ref chain #f)]
    [(_ chain default)
     (let* ([chain-str (symbol->string (syntax->datum #'chain))]
            [ids (for/list ([str (in-list (regexp-split #rx"\\." chain-str))])
                   (format-id #'chain "~a" str))])
       (with-syntax ([hash-table (car ids)]
                     [keys       (cdr ids)])
         #'(hash-refs hash-table 'keys default)))]))

(hash.ref js.a.b.c "无")
