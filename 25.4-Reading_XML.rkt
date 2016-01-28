;似乎从这一节开始要开始读取xml文件了
;管理员有时候希望可以从本地或者是web上获取(读取)xml配置文件
;所以这一章节在2htdp/batch-io的帮助下我们要做到以上的需求
#lang racket
(require
  2htdp/batch-io
  2htdp/universe)

;以下是teachpack的关于xexpr的内容

; Xexpr.v3 is one of:
;  – Symbol
;  – String
;  – Number
;  – (cons Symbol (cons Attribute*.v3 [List-of Xexpr.v3]))
;  – (cons Symbol [List-of Xexpr.v3])
;
; Attribute*.v3 is [List-of Attribute.v3]
;
; Attribute.v3 is:
;   (list Symbol String)
; interpretation.: (list 'a "some text") represents a="some text"

; Any -> Boolean
; is the given value an Xexpr.v3
; effect display bad piece if x is not an Xexpr.v3
;; (define (xexpr? x) ...)

; String -> Xexpr.v3
; produces the first XML element in file f as an X-expression
;; (define (read-xexpr f) ...)

; String -> Xexpr.v3
; produces the first XML element in file f as an X-expression
; and all whitespace between embedded elements is eliminated
; assume the XML element may not contain any text as elements
;忽略所有的<>与</>之间的内容
;; (define (read-plain-xexpr f) ...)

; String -> Boolean
; #false, if this url returns a '404'; #true otherwise
;; (define (url-exists? u) ...)

;; (url-exists? "http://icetea.me")

; String -> [Maybe Xexpr.v3]
; produces the first XML element from URL u as an X-expression
; or #false if (not (url-exists? u))
; reads HTML as XML if possible
; effect signals an error in case of network problems
;; (define (read-xexpr/web u) ...)

;; (read-xexpr/web "http://www.v2ex.com")
;; (read-xexpr/web "http://www.baidu.com")
;; (read-xexpr/web "http://www.sina.com")
;; (read-xexpr/web "http://www.baidu.com/s?tn=baiduhome_pg&rsv_idx=2&wd=%E5%BC%A0%E6%AA%AC&cq=5f3e28ff2ec563ffc5de5e21ba735780&rsv_dl=0_right_recom_21106&srcid=20986&rt=%E7%9B%B8%E5%85%B3%E4%BA%BA%E7%89%A9&euri=a9fc06f336b34389915b9cad452764e9")


; String -> [Maybe Xexpr.v3]
; produces the first XML element from URL u as an X-expression
; and all whitespace between embedded elements is eliminated
; or #false if (not (url-exists? u))
; reads HTML as XML if possible
; effect signals an error in case of network problems
;; (define (read-plain-xexpr/web u) ...)

;; (read-plain-xexpr/web "http://www.baidu.com")

; Xexpr.v3 -> String
; renders the X-expression x as a string
;; (define (xexpr-as-string x) ...)

;; (xexpr? '(mak ((df " ")) (fjk k)))
