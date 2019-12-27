(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (origin-frame frame)
     (add-vect (scale-vect (xcor-vect v)
                           (edge1-frame frame))
               (scale-vect (ycor-vect v)
                           (edge2-frame frame))))))


(define (split first-split second-split)
    (lambda (painter n)
        (if (= n 0)
            painter)
            (let ((smaller ((split first-split second-split) painter (- n 1))))
                (first-split painter (second-split smaller smaller)))))

(define right-split (split beside below))
(define up-split (split below beside))

(define (corner-split painter n)
    (if (= n 0)
        painter
        (let ((up (up-split painter (- n 1)))
                (right (right-split painter (- n 1))))
            (let ((top-left (beside up up))
                (bottom-right (below right right))
                (corner (corner-split painter (- n 1))))
            (beside (below painter top-left)
                    (below bottom-right corner))))))

(define (square-of-four tl tr bl br)
    (lambda (painter)
        (let ((top (beside (tl painter) (tr painter)))
                (bottom (beside (bl painter) (br painter))))
            (below bottom top))))

(define (flipped-pairs painter)
    (let ((combine4 (square-of-four identity flip-vert
                                    identity flip-vert)))
        (combine4 painter)))

(define (square-limit painter n)
    (let ((combine4 (square-of-four identity flip-horiz
                                    rotate180 flip-vert)))
        (combine4 (corner-split painter n))))