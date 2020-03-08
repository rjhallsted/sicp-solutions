;; (define (count-pairs x)
;;     (if (not (pair? x))
;;         0
;;         (+ (count-pairs (car x))
;;            (count-pairs (cdr x))
;;            1)))

(define (count-pairs x)
    (define already-counted '())
    (define (counted-yet? x)
        ;; (display "counted-yet? ") (display x) (newline)
        ;; (display already-counted) (newline)
        (define (counted-yet-inner x left-to-check)
            (if (null? left-to-check)
                #f
                (if (eq? x (car left-to-check))
                    #t
                    (counted-yet-inner x (cdr left-to-check)))))
        (counted-yet-inner x already-counted))
    (define (count-pairs-inner x)
        (if (not (pair? x))
            0
            (if (counted-yet? x)
                0
                (begin (set! already-counted (append already-counted (list x)))
                        ;; (display already-counted) (newline)
                       (+ (count-pairs-inner (car x))
                          (count-pairs-inner (cdr x))
                          1)))))
    (count-pairs-inner x))

(define a '(a b c))

(define i '(b))
(define j (cons i i))
(define b (cons 'a j))

(define c (cons j j))


(define (last-pair x)
    (if (null? (cdr x))
        x
        (last-pair (cdr x))))
(define (make-cycle x)
    (set-cdr! (last-pair x) x)
    x)

(define d '(a b c))
(make-cycle d)

(display "a ") (display (count-pairs a)) (newline)
(display "b ") (display (count-pairs b)) (newline)
(display "c ") (display (count-pairs c)) (newline)
(display "d ") (display (count-pairs d)) (newline)