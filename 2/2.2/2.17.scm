;three potential versions. The first is the easiest to write and read
;so it's the preferred version

(define (last-pair x)
    (list (list-ref x (- (length x) 1))))

;(define (last-pair x)
;    (if (null? (cdr x))
;        (list (car x))
;        (last-pair (cdr x))))

;(define (last-pair x)
;    (define (inner-last-pair x)
;        (if (null? (cddr x))
;            (cdr x)
;            (inner-last-pair (cdr x))))
;    (if (null? (cdr x))
;        x
;        (inner-last-pair x)))

;testing
(define items (list 12 72 149 34))
(define one-item (list 3))

(display (last-pair items)) (newline)
(display (last-pair one-item))
(newline)
