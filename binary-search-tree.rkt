#lang racket

;空节点
(define-struct no-info [])

(define NONE (make-no-info))

(define-struct node [ssn name left right])
;;一个二元树节点,ssn 和 name 都是节点值,所存放的内容ssn<Number> name<Sysmbol>
;left and right 是node类型或者NONE


;;n->name/false
;n代表ssn,如果树中存在社保号为n的人则输出n对应的名字,若没有则输出false

(define (JF&N a b )
  (cond
    [(and (boolean? a) (boolean? b)) false]
    [else (if (symbol? a) a b)]))

(define (search_bt n BT)
  (cond
    [(no-info? BT) false]
    [(= n (node-ssn BT)) (node-name BT)]
    [else (JF&N (search_bt n (node-left  BT)) (search_bt n (node-right BT)))]))

;测试用树
(define a-bt (make-node 23 'lj (make-node 4 'fy NONE (make-node 2828 'sxs NONE NONE)) NONE))

;(search_bt 2828 a-bt )

;BT->list of number
;将一棵树中所有的元素的ssn转化为数字的链表
(define (inorder BT)
  (cond
    [(no-info? BT) '()]
    [else (append (inorder (node-left BT))
                  (list (node-ssn BT) )
                  (inorder (node-right BT)))]))
;(inorder a-bt)


;;二元搜索树的要求,升序或者降序 依次为 left BT right


;不妨设是从左向右




