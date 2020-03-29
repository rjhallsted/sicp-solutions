(load "constraints.scm")

(define (averager a b c)
    (let ((sum (make-connector)) (h (make-connector)))
        (probe "a" a)
        (probe "b" b)
        (probe "avg" c)
        (probe "sum" sum)

        (adder a b sum)
        (constant 0.5 h)
        (multiplier sum h c)))

(define a (make-connector))
(define b (make-connector))
(define c (make-connector))

(averager a b c)

(set-value! b 5 'user)
(set-value! c 4 'user)