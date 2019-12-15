(load "2.8.scm")

(define (int-error message int)
    (display message)
    (display ": ")
    (print-interval int))

(define (interval-spans-zero? int)
    (and (< (lower-bound int) 0)
            (> (upper-bound int) 0)))

(define (div-interval x y)
    (let ((div-error-message "Division error: interval spans 0"))
        (cond ((interval-spans-zero? x)
                (error div-error-message x))
            ((interval-spans-zero? y)
                (error div-error-message y))))
    (mul-interval x 
        (make-interval (/ 1.0 (upper-bound y))
            (/ 1.0 (lower-bound y)))))

(define int-a (make-interval 1 2))
(define int-b (make-interval (- 1) 1))

(define int-c (div-interval int-a int-b))


(print-interval int-c) (newline)