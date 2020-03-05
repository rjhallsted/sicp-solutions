(load "symbolic-algebra-modified.scm")

(define p1 (make-polynomial 'x (list (make-term 2 1) (make-term 1 2) (make-term 0 1))))
(define p2 (make-polynomial 'x (list (make-term 2 11) (make-term 0 7))))
(define p3 (make-polynomial 'x (list (make-term 1 13) (make-term 0 5))))

(define q1 (mul p1 p2))
(define q2 (mul p1 p3))

(display "p1  ") (display p1) (newline)
(display "gcd ") (display (greatest-common-divisor q1 q2)) (newline)