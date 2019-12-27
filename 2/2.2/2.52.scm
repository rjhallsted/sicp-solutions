;;a.  Add some segments to the primitive wave painter of exercise  2.49 (to add a smile, for example)
(define wave-segments
    (list
        (make-segment (make-vector 0.2 0) (make-vector 0.4 0.5))
        (make-segment (make-vector 0.4 0.5) (make-vector 0.35 0.55))
        (make-segment (make-vector 0.35 0.55) (make-vector 0.2 0.4))
        (make-segment (make-vector 0.2 0.4) (make-vector 0 0.6))
        (make-segment (make-vector 0 0.8) (make-vector 0.2 0.55))
        (make-segment (make-vector 0.2 0.55) (make-vector 0.3 0.6))
        (make-segment (make-vector 0.3 0.6) (make-vector 0.4 0.6))
        (make-segment (make-vector 0.4 0.6) (make-vector 0.3 0.8))
        (make-segment (make-vector 0.3 0.8) (make-vector 0.4 1))
        (make-segment (make-vector 0.6 1) (make-vector 0.7 0.8))
        (make-segment (make-vector 0.7 0.8) (make-vector 0.6 0.6))
        (make-segment (make-vector 0.6 0.6) (make-vector 0.8 0.6))
        (make-segment (make-vector 0.8 0.6) (make-vector 1 0.4))
        (make-segment (make-vector 1 0.2) (make-vector 0.6 0.4))
        (make-segment (make-vector 0.6 0.4) (make-vector 0.8 0))
        (make-segment (make-vector 0.6 0) (make-vector 0.5 0.3))
        (make-segment (make-vector 0.5 0.3) (make-vector 0.4 0))
        (make-segment (make-vector 0.35 0.75) (make-vector 0.45 0.7))
        (make-segment (make-vector 0.45 0.7) (make-vector 0.55 0.7))
        (make-segment (make-vector 0.55 0.7) (make-vector 0.65 0.75))))
(define wave (segments->painter wave-segments))

;; b. Change the pattern constructed by corner-split (for example, by using only one copy of the up-split and right-split images instead of two).
(define (corner-split painter n)
    (if (= n 0)
        painter
        (let ((up (up-split painter (- n 1)))
                (right (right-split painter (- n 1))))
            (let (
                (corner (corner-split painter (- n 1))))
            (beside (below painter up)
                    (below right corner))))))


;; c. Modify the version of square-limit that uses square-of-four so as to assemble the corners in a different pattern. (For example, you might make the big Mr. Rogers look outward from each corner of the square.)

(define (square-limit painter n)
    (let ((combine4 (square-of-four flip-horiz identity
                                    flip-vert rotate180)))
        (combine4 (corner-split painter n))))