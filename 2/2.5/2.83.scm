(load "generic-arithmetic.scm")
(load "complex-numbers.scm")

(define (install-raise-package)
    (define (integer-raise x)
        (make-rational x x))
    (define (rational-raise x)
        (make-scheme-number (/ (numer x) (denom x)))) ;this requires numer and denom to be available
    (define (real-raise x)
        (make-complex-fromr-real-imag x 0))
    (put 'raise 'integer integer-raise)
    (put 'raise 'rational rational-raise)
    (put 'raise 'real real-raise)
    'done)