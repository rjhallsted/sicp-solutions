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

;b. The procedures have the same order of growth