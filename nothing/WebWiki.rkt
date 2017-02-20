#lang racket
(require web-server/servlet
         web-server/servlet-env)

;;当前的文件路径
(define document-root
  (path->string (current-directory)))

;;文件扩展名到MIME类型的对应

(define ext=>mime-type
  #hash((#""     . #"text/html; charset=utf-8")
        (#"html" . #"text/html; charset=utf-8")
        (#"png"  . #"image/png")
        (#"rkt"  . #"text/x-racket; charset=utf-8")))

;;静态文件处理函数

(define (handle-file-requset req)
  ;;获取url
  (define uri (request-uri req))

  ;;获得资源
  (define resource
    (map path/param-path (url-path uri)))

  ;;找到路径

  (define file (string-append
                document-root
                "/"
                (string-join resource "/")))
  (cond
    [(file-exists? file)
     ; =>

     ;获得MIME类型
     (define extension (filename-extension file))
     (define mime-type
       (hash-ref ext=>mime-type extension
                 (λ () TEXT/HTML-MIME-TYPE)))
     (define data (file->bytes file))
     (response
      200 #"OK"
      (current-seconds)
      mime-type
      '()
      (λ (client-out)
        (write-bytes data client-out)))
     ]
    [else (response/xexpr
           #:code 404
           #:message #"Not found"
           `(html
             (body
              (p "没找到"))))]
    )

  )



(serve/servlet handle-file-requset
               #:servlet-regexp #rx""
               ;; #:launch-browser? #f
               )



