(define (is-cycled? x)
    (define (is-cycled-inner first-pair x)
        (cond ((null? x) #f)
            ((eq? x first-pair) #t)
            (else (is-cycled-inner first-pair (cdr x)))))
    (is-cycled-inner x (cdr x)))g

(define (last-pair x)
    (if (null? (cdr x))
        x
        (last-pair (cdr x))))
(define (make-cycle x)
    (set-cdr! (last-pair x) x)
    x)

(define d '(a b c))
(display (is-cycled? d)) (newline)
(make-cycle d)
(display (is-cycled? d)) (newline)