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

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define (print-segment seg)
    (print-point (start-segment seg))
    (print-point (end-segment seg)))


;implementation 1
(define (make-rect top-left bottom-right)
    (cons top-left bottom-right))

(define (rect-top-left-point rect)
    (car rect))

(define (rect-bottom-right-point rect)
    (cdr rect))

(define (rect-top-right-point rect)
    (make-point (x-point (rect-bottom-right-point rect)) (y-point (rect-top-left-point rect))))

(define (rect-bottom-left-point rect)
    (make-point (x-point (rect-top-left-point rect)) (y-point (rect-bottom-right-point rect))))

;implementation 2
;(define (make-rect top-left top-right bottom-left bottom-right)
;    (cons (cons top-left top-right) (cons bottom-left bottom-right)))

;(define (rect-top-left-point rect)
;    (car (car rect)))

;(define (rect-top-right-point rect)
;    (cdr (car rect)))

;(define (rect-bottom-left-point rect)
;    (car (cdr rect)))

;(define (rect-bottom-right-point rect)
;    (cdr (cdr rect)))

;works regardless of implementation
(define (rect-top-segment rect)
    (make-segment (rect-top-left-point rect)
        (rect-top-right-point rect)))

(define (rect-left-segment rect)
    (make-segment (rect-top-left-point rect)
        (rect-bottom-left-point rect)))

(define (segment-x-diff seg)
    (abs (- (x-point (end-segment seg))
            (x-point (start-segment seg)))))

(define (segment-y-diff seg)
    (abs (- (y-point (end-segment seg))
            (y-point (start-segment seg)))))

(define (rect-width rect)
    (segment-x-diff (rect-top-segment rect)))

(define (rect-height rect)
    (segment-y-diff (rect-left-segment rect)))

;procedures
(define (rect-perimeter rect)
    (+ (* 2 (rect-width rect))
        (* 2 (rect-height rect))))

(define (rect-area rect)
    (* (rect-width rect) (rect-height rect)))



;in-use (implementation 1)
(define rectangle (make-rect (make-point 0 0) (make-point 10 20)))

;in-use (implementation 2)
;(define rectangle (make-rect (make-point 0 0)
;                            (make-point 10 0)
;                            (make-point 0 20)
;                            (make-point 10 20)))

(display (rect-perimeter rectangle)) (newline)
(display (rect-area rectangle)) (newline)