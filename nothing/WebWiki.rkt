#lang racket
(require web-server/servlet
         web-server/servlet-env)

(require net/uri-codec)

(require file/sha1
         net/base64)

(define root (path->string (current-directory)))

;;passwd文件的路径

(define passwd-file (string-append root "passwd"))

(define (any? pred list)
  ;查看是否有任何值list之中有和pred匹配的
  (match list
    ['() #f]
    [(cons hd tl)
     (or (pred hd) (any? pred (cdr list)))]))

;;检查密码的例行公事
(define (htpasswd-credentials-valid? passwd-file username password)
  ;;检查用户信息是否和数据库中符合
  ;;假定所有条目使用"htpasswd -s"来sha1加密
  (define lines (call-with-input-file passwd-file
                 (λ (port) (port->lines port))))
  (define sha1-pass (sha1-bytes (open-input-bytes password)))

  ;;使用base64加密
  (define sha1-pass-b64
    (bytes->string/utf-8 (base64-encode sha1-pass #"")))

  ;;检测用户名和密码是否匹配
  (define (password-match? line)

    (define user:hash (string-split line ":"))
    (define user (car user:hash))
    (define hash (cadr user:hash))

    (match (string->list hash)
      ;;检查sha1前缀
      [`(#\{ #\S #\H #\A #\} . ,hashpass-chars)
       (define hashpass (list->string hashpass-chars))
       (and (equal? username (string->bytes/utf-8 user))
            (equal? hashpass sha1-pass-b64))]
      [else #f]))

  ;;检查是否有符合条件的一行
  (any? password-match? lines))

(define (req->user req)
  (match (request->basic-credentials req)
    [(cons user pass) user]
    [else #f]))

(define (authenticated? req)
  (match (request->basic-credentials req)
    [(cons user pass)
     (htpasswd-credentials-valid? passwd-file user pass)]
    [else #f]))


(define (hello-servlet req)
  (cond
    [(not (authenticated? req))
     (response
      401 #"Unauthorized"
      (current-seconds)
      TEXT/HTML-MIME-TYPE
      (list
       (make-basic-auth-header
        "需要认证"))
      void)]
    [else (response/xexpr
           #:preamble #"<!DOCTYPE html"
           `(html
             (head)
             (body
              (p "Hello, " ,(bytes->string/utf-8 (req->user req)) "!"))))]))


(serve/servlet hello-servlet
               #:servlet-regexp #rx"")


