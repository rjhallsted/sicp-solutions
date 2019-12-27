(define (cons a b)
    (* (expt 2 a) (expt 3 b)))

(define (car z)
    (define (a-iter x count)
        (if (=  0 (remainder x 2))
            (a-iter (/ x 2) (+ count 1))
            count))
    (a-iter z 0))

(define (cdr z)
    (define (b-iter x count)
        (if (=  0 (remainder x 3))
            (b-iter (/ x 3) (+ count 1))
            count))
    (b-iter z 0))


;proof
(define pair (cons 3 6))
(display (car pair)) (newline)
(display (cdr pair)) (newline)