(load "help.scm")

(define (make-rat n d)
    (let ((g (gcd (abs n) (abs d))))
        (cond ((and (< n 0) (< d 0))
                (cons (abs (/ n g)) (abs (/ d g))))
            ((< d 0)
                (cons (- (abs (/ n g))) (abs (/ d g))))
            (else
                (cons (/ n g) (/ d g))))))

(define (make-rat n d)
    (let ((g (gcd (abs n) (abs d))))
        (let ((num (abs (/ n g))) (denom (abs (/ d g))))
            (cond ((or (and (< d 0) (> n 0)) (and (< n 0) (> d 0)))
                    (cons (- num) denom))
                (else
                    (cons num denom))))))

(define neg-one-half (make-rat 1 (- 2)))
(print-rat neg-one-half)

(define one-third (make-rat (- 1) (- 3)))
(print-rat one-third)

(define neg-one-eight (make-rat (- 1) 8))
(print-rat neg-one-eight)

(print-rat (mul-rat one-third neg-one-eight))

(newline)