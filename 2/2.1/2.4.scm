(define (cons x y)
    (lambda (m) (m x y)))

(define (car z)
    (z (lambda (p q) p)))

(define (cdr z)
    (z (lambda (p q) q)))


;proof
(define pair (cons 1 2))
(display (= 1 (car pair))) (newline)
(display (= 2 (cdr pair))) (newline)