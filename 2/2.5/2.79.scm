;;heirarchy here is complex->rational->scheme-number

(define (install-equ?)
    (define (rational-equ? a b)
        (and (= (numer a) (numer b))
             (= (denom a) (denom b))))
    (define (complex-equ? a b)
        (and (equ? (real-part a) (real-part b))
             (equ? (imag-part a) (imag-part b))))
    (put 'equ? '(scheme-number scheme-number) =)
    (put 'equ? '(rational rational) rational-equ?)
    (put 'equ? '(complex complex) complex-equ?)
    'done)