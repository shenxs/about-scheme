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
(define a-bt (make-node 3 'lj (make-node 1 'fy NONE (make-node 2 'sxs NONE NONE)) NONE))

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

;社工号,二元搜索树 -> 社工号对应的名字或者NONE 表示没有找到

(define (search_bst n bst)
  (cond
    [(no-info? bst) NONE]
    [(= n (node-ssn bst)) (node-name bst)]
    [else (if (> n (node-ssn bst))
            (search_bst n (node-right bst))
            (search_bst n (node-left bst)))]))

;(search_bst 1 a-bt)


;Exercise 312
;
;构造二元搜索树
;
;It consumes a BST B, a number N, and a symbol S
(define (creat_bst B N S)
  (cond
    [(no-info? B) (make-node N S NONE NONE)]
    [else (if (> N (node-ssn B))
             (make-node (node-ssn B) (node-name B) (node-left B) (creat_bst (node-right B) N  S))
             (make-node (node-ssn B) (node-name B) (creat_bst (node-left B) N  S) (node-right B)))]))


;从一个list 创造一个二元搜索树
;list of node->BST

(define (creat_bst_from_list l)
  (cond
    [(empty? l) NONE]
    [else (creat_bst (creat_bst_from_list (rest l)) (first (first l)) (second (first l)) )]))

(define sample
  '((99 o)
    (77 l)
    (24 i)
    (10 h)
    (95 g)
    (15 d)
    (89 c)
    (29 b)
    (63 a)))
;(creat_bst_from_list sample)
(search_bst 8 (creat_bst_from_list sample))

