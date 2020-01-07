(load "../2.2/list-ops.scm")

(define (element-of-set? x set)
    (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
    (cons x set))

;need to fix intersection set to include duplicates from set2 as well.
(define (intersection-set set1 set2)
    (accumulate (lambda (item new-list)
                    (if (not (element-of-set? item new-list))
                        (cons item new-list)
                        new-list))
        '()
        (cond ((or (null? set1) (null? set2)) '())
            ((element-of-set? (car set1) set2)
                (cons (car set1)
                    (intersection-set (cdr set1) set2)))
            (else (intersection-set (cdr set1) set2)))))

(define (union-set set1 set2)
    (if (null? set2)
        set1
        (union-set (adjoin-set (car set2) set1)
                    (cdr set2))))

(display (union-set '(1 2 2 3 5) '(4 4 5 6))) (newline)
(display (intersection-set '(1 2 2 3) '(2 3 3 3))) (newline)