(define (same-parity . given)
    (define (same-parity-inner left parity)
        (cond ((null? left)
                '())
            ((= parity (remainder (car left) 2))
                (cons (car left) (same-parity-inner (cdr left) parity)))
            (else
                (same-parity-inner (cdr left) parity))))
    (same-parity-inner given (remainder (car given) 2)))

(display (same-parity 1 2 3 4 5 6 7)) (newline)
(display (same-parity 2 3 4 5 6 7)) (newline)
