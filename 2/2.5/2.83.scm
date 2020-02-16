(load "generic-arithmetic.scm")
(load "complex-numbers.scm")

(define (install-raise-package)
    (define (integer->rational x)
        (make-rational x x))
    (define (rational->scheme-number x)
        (make-scheme-number (/ (numer x) (denom x)))) ;this requires numer and denom to be available
    (define (scheme-number->complex x)
        (make-complex-fromr-real-imag x 0))
    (put 'raise 'integer integer->rational)
    (put 'raise 'rational rational->scheme-number)
    (put 'raise 'scheme-number scheme-number->complex)
    'done)