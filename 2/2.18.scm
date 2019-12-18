(define (reverse x)
    (define (reverse-inner orig new)
        (if (null? (cdr orig))
            (cons (car orig) new)
            (reverse-inner (cdr orig) (cons (car orig) new))))
    (if (null? x)
        x    
        (reverse-inner x '())))

;testing
(define a (list 1 4 9 16 25))
(display (reverse a)) (newline)

(define one-item (list 8))
(display (reverse one-item)) (newline)

(display (reverse '())) (newline)