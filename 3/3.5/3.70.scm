(load "streams.scm")

(define (merge-weighted s1 s2 weight)
    (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
            (let ((s1car (stream-car s1))
                  (s2car (stream-car s2)))
                (cond ((< (weight s1car) (weight s2car))
                        (cons-stream s1car
                                     (merge-weighted (stream-cdr s1) s2 weight)))
                    ((> (weight s1car) (weight s2car))
                        (cons-stream s2car
                                     (merge-weighted s1 (stream-cdr s2) weight)))
                    (else
                        (cons-stream s1car
                                     (merge-weighted (stream-cdr s1)
                                                     s2 ;retain the other item
                                                     weight))))))))

(define (weighted-pairs s t weight)
    (cons-stream
        (list (stream-car s) (stream-car t))
        (merge-weighted
            (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
            (weighted-pairs (stream-cdr s) (stream-cdr t) weight)
            weight)))

;a
(define a-stream (weighted-pairs integers integers (lambda (x) (+ (car x) (cadr x)))))
;; (display-first-x-of-stream
;;     a-stream
;;     20)

;b
(define (b-weight pair)
    (+ (* 2 (car pair)) (* 3 (cadr pair)) (* 5 (car pair) (cadr pair))))

(define filtered-stream (stream-filter (lambda (x) (and (not (= 0 (modulo x 2)))
                                                        (not (= 0 (modulo x 3)))
                                                        (not (= 0 (modulo x 5)))))
                                        integers))
(define b-stream (weighted-pairs filtered-stream filtered-stream b-weight))

(display-first-x-of-stream b-stream 20)