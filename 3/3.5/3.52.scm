(load "streams.scm")

(define sum 0)

(define (accum x)
    (set! sum (+ x sum)) 
    sum)

(define seq
    (stream-map accum 
               (stream-enumerate-interval 1 20)))

;seq = (1 3 6 10 15 21 28 36 45 55 66 78 91 105 120 136 153 171 190 210)
;y = (6 10 28 36 66 78 120 136 190 210)
;z = (10 15 45 55 105 120 190 210)

(define y (stream-filter even? seq))
(define z
    (stream-filter (lambda (x) (= (remainder x 5) 0))
                   seq))

;; (display-stream y)
(display (stream-ref y 7)) (newline) ;136
(display "sum: ") (display sum) (newline) ;136

(display-stream z) ;(10 15 45 55 105 120 190 210)
(display "sum: ") (display sum) (newline) ;210

;;Without the memoization of the stream, the sum would continue to rise, since each call to accum increases it.