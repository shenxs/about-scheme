#lang racket
(require web-server/servlet
         web-server/servlet-env)

;;当前的文件路径
(define document-root
  (path->string (current-directory)))

(define (hello-servlet req)
  (response
   200
   #"OK"
   (current-seconds)
   TEXT/HTML-MIME-TYPE
   '()
   (λ (client-out)
     (write-string "Hello ,dynamic !" client-out))))

(serve/servlet hello-servlet
               #:servlet-path "/hello"
               #:extra-files-paths (list (build-path document-root))
               )
