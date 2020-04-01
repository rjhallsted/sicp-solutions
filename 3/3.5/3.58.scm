(define (expand num den radix)
    (cons-stream
        (quotient (* num radix) den)
        (expand (remainder (* num radix) den) den radix)))

;(expand 1 7 10)
;(1 4 2 8 5 7) repeated indefinitely

;(expand 3 8 10)
;(3 7 5 0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;0's indefinitely

;This function generates the decimal sequence of the numerator divided by the denominator, multiplied by the radix.
;It's basically doing long division