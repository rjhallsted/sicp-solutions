(load "sets.scm")

(define (union-set set1 set2)
    (cond ((null? set2)
            set1)
        ((null? set1)
            set2)
        ((element-of-set? (car set2) set1)
            (union-set set1 (cdr set2)))
        (else
            (union-set (cons (car set2) set1)
                        (cdr set2)))))

(display (union-set '(1 2 3 5) '(4 5 6))) (newline)