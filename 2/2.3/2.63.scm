(load "binary-trees.scm")

(define (tree->list-1 tree)
    (if (null? tree)
        '()
        (append (tree->list-1 (left-branch tree))
                (cons (entry tree)
                        (tree->list-1 (right-branch tree))))))

(define (tree->list-2 tree)
    (define (copy-to-list tree result-list)
        (if (null? tree)
            result-list
            (copy-to-list (left-branch tree)
                        (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list)))))
    (copy-to-list tree '()))

;a. The procedures do create the same lists

(define tree-a (make-tree 7
                        (make-tree 3
                                    (make-tree 1 '() '())
                                    (make-tree 5 '() '()))
                        (make-tree 9
                                    '()
                                    (make-tree 11 '() '()))))
    
(define tree-b (make-tree 3
                        (make-tree 1 '() '())
                        (make-tree 7
                                    (make-tree 5 '() '())
                                    (make-tree 9
                                                '()
                                                (make-tree 11 '() '())))))
                                    
(define tree-c (make-tree 5
                        (make-tree 3
                                    (make-tree 1 '() '())
                                    '())
                        (make-tree 9
                                    (make-tree 7 '() '())
                                    (make-tree 11 '() '()))))

(display "tree a") (newline)
(display (tree->list-1 tree-a)) (newline)
(display (tree->list-2 tree-a)) (newline)

(newline)

(display "tree b") (newline)
(display (tree->list-1 tree-b)) (newline)
(display (tree->list-2 tree-b)) (newline)

(newline)

(display "tree c") (newline)
(display (tree->list-1 tree-c)) (newline)
(display (tree->list-2 tree-c)) (newline)

;b. The procedures have the same order of growth. I've seen explanations where 1 is O(log n) and 
;2 is O(n), but I don't see how. The procedure must touch every node in the list, making it at minimum O(n).
;Both procedures appear to be structurally the same, making them have the same order of growth.
;The only difference is how the resulting list is tracked, and the use of append in 1.
;2, by using cons instead of append, might be marginally faster, but not by a different order. Each join must touch every node so far due to the use of append, whereas 2 has only one cons for each node, leaving each node touched only once.