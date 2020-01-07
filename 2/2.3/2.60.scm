(load "../2.2/list-ops.scm")

(define (element-of-set? x set)
    (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
    (cons x set))

(define (unique-values-of-set set)
    (accumulate (lambda (item new-list)
                    (if (not (element-of-set? item new-list))
                        (cons item new-list)
                        new-list))
                '()
                set))

(define (intersection-set set1 set2)
    (unique-values-of-set (cond ((or (null? set1) (null? set2)) '())
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


;element-of-set is the same procedure
;adjoin set is more efficient since it no longer needs to check the set for the value
;intersection-set is less efficient, because in this implementation, it has to filter out duplicates at the end (Not sure if I did this one correcty)
;union-set is more efficient, as it does not need to check for duplicates

;Allowing duplicates would be useful in situations where the original composition of the data needed to be retained. Say you were aggregating votes. Allowing duplicates allows you to know the total number of votes per value.