;with map
(define (square-tree tree)
    (map (lambda (sub-tree)
            (if (pair? sub-tree)
                (square-tree sub-tree)
                (square sub-tree)))
        tree))


(display (square-tree
    (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))) (newline)
;(1 (4 (9 16) 25) (36 49))

;without map
(define (square-tree tree)
    (cond ((null? tree) '())
        ((pair? tree)
            (cons (square-tree (car tree))
                (square-tree (cdr tree))))
        (else
            (square tree))))


(display (square-tree
    (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))) (newline)
;(1 (4 (9 16) 25) (36 49))