(define (average x y) 
    (/ (+ x y) 2))

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define (make-segment a b)
    (cons a b))

(define (start-segment x)
    (car x))

(define (end-segment x)
    (cdr x))

(define (make-point x y)
    (cons x y))

(define (x-point x)
    (car x))

(define (y-point x)
    (cdr x))

(define (midpoint-segment x)
    (make-point (average (x-point (start-segment x))
                        (x-point (end-segment x)))
                (average (y-point (start-segment x))
                        (y-point (end-segment x)))))


(define line1 (make-segment (make-point 1 3) (make-point 3 5)))
(print-point (midpoint-segment line1))


(define line2 (make-segment (make-point (- 4) 12) (make-point (- 23) 42)))
(print-point (midpoint-segment line2))

(newline)