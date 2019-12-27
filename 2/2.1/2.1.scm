(load "help.scm")

(define (make-rat n d)
    (let ((g (gcd (abs n) (abs d))))
        (let ((simp-n (abs (/ n g))) (simp-d (abs (/ d g))))
            (cond ((or (and (< d 0) (> n 0)) (and (< n 0) (> d 0)))
                    (cons (- simp-n) simp-d))
                (else
                    (cons simp-n simp-d))))))

(define neg-one-half (make-rat 1 (- 2)))
(print-rat neg-one-half)

(define one-third (make-rat (- 1) (- 3)))
(print-rat one-third)

(define neg-one-eight (make-rat (- 1) 8))
(print-rat neg-one-eight)

(print-rat (mul-rat one-third neg-one-eight))

(newline)