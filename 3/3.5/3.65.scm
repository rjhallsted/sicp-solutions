(load "streams.scm")

(define (stream-limit s tolerance)
    (define (compare item stream)
        (cond ((stream-null? stream)
                (error "End of stream. No items within tolerance"))
            ((< (abs (- item (stream-car stream)))
                tolerance)
                (stream-car stream))
            (else
                (compare (stream-car stream) (stream-cdr stream)))))
    (compare (stream-car s) (stream-cdr s)))

(define (euler-transform s)
    (let ((s0 (stream-ref s 0))
          (s1 (stream-ref s 1))
          (s2 (stream-ref s 2)))
        (cons-stream (- s2 (/ (square (- s2 s1))
                              (+ s0 (* -2 s1) s2)))
                     (euler-transform (stream-cdr s)))))

(define (make-tableau transform s)
    (cons-stream s (make-tableau transform (transform s))))
(define (accelerated-sequence transform s)
    (stream-map stream-car (make-tableau transform s)))

(define alternating-ones
    (cons-stream 1 (scale-stream alternating-ones (- 1))))
(define log2-stream
    (partial-sums (div-streams alternating-ones integers)))

;; (display-first-x-of-stream
;;     (stream-map (lambda (x) (* x 1.0))
;;                 log2-stream)
;;     80)

;;original sequence: 80ish

;; (display-first-x-of-stream
;;     (stream-map (lambda (x) (* x 1.0))
;;                 (euler-transform log2-stream))
;;     10)

;;the euler transformation gets a tighter tolerance within 2 items than the original does in 80



(display-first-x-of-stream
    (stream-map (lambda (x) (* x 1.0))
                (accelerated-sequence euler-transform log2-stream))
    8)

;;the accelerate arrived at an answer with 7 digits in 4 items