(define (make-vect x y) (cons x y))
(define (xcor-vect v) (car v))
(define (ycor-vect v) (cdr v))

(define (add-vect v1 v2)
    (make-vector (+ (xcor-vect v1) (xcor-vect v2))
                 (+ (ycor-vect v1) (ycor-vect v2))))

(define (sub-vect v1 v2)
    (make-vector (- (xcor-vect v1) (xcor-vect v2))
                 (- (ycor-vect v1) (ycor-vect v2))))

(define (scale-vect factor v)
    (make-vector (* (xcor-vect v1))
                 (* (ycor-vect v2))))


(define (make-segment start-vect end-vect)
    (cons start-vect end-vect))
(define (start-segment segment)
    (car segment))
(define (end-segment segment)
    (cdr segment))