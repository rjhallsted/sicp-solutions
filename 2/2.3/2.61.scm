(load "ordered-set.scm")

(define (adjoin-set x set)
    (cond ((null? set) '())
        ((= x (car set)) set)
        ((> x (car set)) (cons (car set) (adjoin-set x (cdr set))))
        (else (cons x set))))

(display (adjoin-set 3 '(1 2 4 5))) (newline)

