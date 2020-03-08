(define (mystery x)
    (define (loop x y)
        (if (null? x)
            y
            (let ((temp (cdr x)))
                (set-cdr! x y)
                (loop temp x))))
    (loop x '()))

;v -> ('a 'b 'c 'd)

;(mystery v)
;   (loop '(a b c d) '())
;       temp: '(b c d)
;       set-cdr! x y
;       x: '(a)
;       (loop '(b c d) '(a)
;           temp: '(c d)
;           set-cdr! x y
;           x: '(b a)
;           (loop '(c d) '(b a))
;               temp: '(d)
;               set-cdr! x y
;               x: '(c b a)
;               (loop '(d) '(c b a))
;                   temp: '()
;                   set-cdr! x y
;                   x: '(d c b a)
;                   (loop '() '(d c b a))
;                       '(d c b a)

;;mystery reverses the contents of x in place

;w = '(d c b a)
;v = '(a)

;v still points to the a, whereas the rest of the list structure has been reversed

(define v '(a b c d))
(define w (mystery v))

(display "w ") (display w) (newline)
(display "v ") (display v) (newline)