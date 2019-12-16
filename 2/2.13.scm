(load "2.12.scm")

;assuming intervals are both positive and the percentage is low,
;the product interval's tolerance will be approximately the factors'
;tolerances added together

;examples

(define (prove-tolerance a b)
    (let ((c (mul-interval a b)))
        ((print-interval c) (newline)
        (newline)
        (display (percent c))
        (display " = ")
        (display (percent int-a))
        (display " + ")
        (display (percent int-b)) (newline))))


(define int-a (make-center-percent 3.5 10))
(define int-b (make-center-percent 2 5))

(define int-c (mul-interval int-a int-b))
(print-interval int-c) (newline)
(newline)
(display (percent int-c))
(display " = ")
(display (percent int-a))
(display " + ")
(display (percent int-b)) (newline)

(define int-d (make-center-percent 6.33 7))
(define int-e (make-center-percent 1 2))

(define int-f (mul-interval int-d int-e))
(print-interval int-f) (newline)
(newline)
(display (percent int-f))
(display " = ")
(display (percent int-d))
(display " + ")
(display (percent int-e)) (newline)