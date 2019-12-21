(define (fringe x)
    (cond
        ((null? x)
            '())
        ((not (pair? x))
            (list x))
        (else 
            (append (fringe (car x))
                    (fringe (cdr x))))))

(define x (list (list 1 2) (list 3 4)))

(display (fringe x)) (newline)
;(1 2 3 4)

(display (fringe (list x x))) (newline)
;(1 2 3 4 1 2 3 4)