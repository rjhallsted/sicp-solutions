(define (make-accumulator amount)
    (lambda (x)
        (begin (set! amount (+ amount x))
               amount)))

(define A (make-accumulator 5))

(display (A 10)) (newline)
(display (A 10)) (newline)