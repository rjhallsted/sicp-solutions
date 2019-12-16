(load "2.11.scm")

(define (make-center-percent center percentage)
    (let ((half-width (* percentage 0.01 center)))
        (make-interval (- center half-width) (+ center half-width))))

(define (percent i)
    (let ((c (center i)))
        (* (/ (- (upper-bound i) c) c) 100)))

;testing
(define int-a (make-center-percent 6.8 10))
(print-interval int-a) (newline)
(display (percent int-a)) (newline)