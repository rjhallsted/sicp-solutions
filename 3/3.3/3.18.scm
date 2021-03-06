(define (is-cycled? x)
    (define found-pairs '())
    (define (found-yet? pair)
        (define (found-yet-inner pair found)
            (cond ((null? found) #f)
                ((eq? pair (car found)) #t)
                (else (found-yet-inner pair (cdr found)))))
        (found-yet-inner pair found-pairs))
    (define (is-cycled-inner left-to-check)
        (cond ((null? left-to-check) #f)
            ((found-yet? left-to-check) #t)
            (else (begin (set! found-pairs (cons left-to-check found-pairs))
                         (is-cycled-inner (cdr left-to-check))))))
    (is-cycled-inner x))
    
(define (last-pair x)
    (if (null? (cdr x))
        x
        (last-pair (cdr x))))
(define (make-cycle x)
    (set-cdr! (last-pair x) x)
    x)

(define d '(a b c))
(display (is-cycled? d)) (newline)
(make-cycle d)
(display (is-cycled? d)) (newline)

(define e (cons 'x d))
(display (is-cycled? e)) (newline)