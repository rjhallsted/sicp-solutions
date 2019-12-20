(define (reverse x)
    (define (reverse-inner orig new)
        (if (null? (cdr orig))
            (cons (car orig) new)
            (reverse-inner (cdr orig) (cons (car orig) new))))
    (if (null? x)
        x    
        (reverse-inner x '())))

(define (deep-reverse x)
    (define (deep-reverse-inner orig new)
        (cond 
            ((and (pair? (car orig)) (null? (cdr orig)))
                (cons (deep-reverse (car orig)) new))
            ((pair? (car orig))
                (deep-reverse-inner (cdr orig)
                                    (cons (deep-reverse (car orig)) new)))
            ((null? (cdr orig))
                (cons (car orig) new))
            (else 
                (deep-reverse-inner (cdr orig)
                                    (cons (car orig) new)))))
    (if (null? x)
        x    
        (deep-reverse-inner x '())))


(define x (list (list 1 2) (list 3 4)))
(display x) (newline)
(display (reverse x)) (newline)
(display (deep-reverse x)) (newline)

(newline)

(define y (list 1 2 (list 3 4)))
(define z (list (list 1 2) 3))
(define a (list 1 (list 2 3) 4))

(display (deep-reverse y)) (newline)
(display (deep-reverse z)) (newline)
(display (deep-reverse a)) (newline)