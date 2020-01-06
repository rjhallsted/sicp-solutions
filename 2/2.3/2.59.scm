(load "sets.scm")

(define (union-set set1 set2)
    (if (null? set2)
        set1
        (union-set (adjoin-set (car set2) set1)
                    (cdr set2))))

(display (union-set '(1 2 3 5) '(4 5 6))) (newline)