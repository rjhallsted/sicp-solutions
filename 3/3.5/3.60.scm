(load "3.59.scm")

(define (mul-series s1 s2)
    (cons-stream (* (stream-car s1) (stream-car s2))
                 (add-streams (scale-stream (stream-cdr s1) (stream-car s2))
                              (mul-series (stream-cdr s2) s1))))


(define (check-val-at-index index)
    (let ((results (add-streams (mul-streams sine-series sine-series)
                   (mul-streams cosine-series cosine-series))))
        (= (stream-ref results index) 1)))

;; (stream-for-each (lambda (x)
;;             (display x)
;;             (display ": ")
;;             (display (check-val-at-index x))
;;             (newline))
;;         (stream-enumerate-interval 0 10))

(display-first-x-of-stream (add-streams (mul-series sine-series sine-series)
                                        (mul-series cosine-series cosine-series))
                            10)