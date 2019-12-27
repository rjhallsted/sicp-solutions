(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
       (draw-line
        ((frame-coord-map frame) (start-segment segment))
        ((frame-coord-map frame) (end-segment segment))))
     segment-list)))

;a.  The painter that draws the outline of the designated frame.

(define outline-painter
    (let ((v00 (make-vector 0 0))
            (v01 (make-vector 0 1))
            (v11 (make-vector 1 1))
            (v10 (make-vector 1 0)))
        (segments->painter (list (make-segment v00 v01)
                                (make-segment v01 v11)
                                (make-segment v11 v10)
                                (make-segment v10 v00)))))

;b.  The painter that draws an ``X'' by connecting opposite corners of the frame.
(define x-painter
    (let ((v00 (make-vector 0 0))
            (v01 (make-vector 0 1))
            (v11 (make-vector 1 1))
            (v10 (make-vector 1 0)))
        (segments->painter (list (make-segment v00 v11)
                                (make-segment v01 v10)))))

;c.  The painter that draws a diamond shape by connecting the midpoints of the sides of the frame.
(define diamond-painter
    (let ((left (make-vector 0 0.5))
            (top (make-vector 0.5 1))
            (right (make-vector 1 0.5))
            (bottom (make-vector 0.5 0)))
        (segments->painter (list (make-segment left top)
                                (make-segment top right)
                                (make-segment right bottom)
                                (make-segment bottom left)))))

;d.  The wave painter. 
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
        (make-segment (make-vector 0.5 0.3) (make-vector 0.4 0))))
(define wave (segments->painter wave-segments))