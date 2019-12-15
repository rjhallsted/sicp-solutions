(load "interval-arithmetic.scm")

(define (upper-bound int)
    (cdr int))

(define (lower-bound int)
    (car int))