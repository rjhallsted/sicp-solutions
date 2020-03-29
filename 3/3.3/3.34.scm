;You cannot have two connectors actually be the same connector.
;If you set b, you don't have enough information to derive a.
;If you then set a, you immediately get a condtradiction error.
;This doesn't work as a constraint because it only works in terms of a, and not in terms of b.

(load "constraints.scm")

(define (squarer a b)
    (multiplier a a b))

(define a (make-connector))
(define b (make-connector))

(probe "a" a)
(probe "b" b)

(squarer a b)

(set-value! b 9 'user)
(set-value! a 2 'user)