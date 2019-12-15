(load "2.8.scm")

(define (interval-width int)
    (/ (- (upper-bound int) (lower-bound int)) 2))

(define int-a (make-interval 3 5))
(define int-b (make-interval 4 9))

(display (interval-width (add-interval int-a int-b)))
(display " = ")
(display (interval-width int-a))
(display " + ")
(display (interval-width int-b))
(newline)

(define int-c (make-interval (- 1) 2))
(define int-d (make-interval 6 7))

(display (interval-width (sub-interval int-c int-d)))
(display " = ")
(display (interval-width int-c))
(display " - ")
(display (interval-width int-d))
(newline)

;addition proof
;
;w((xa, ya)) = (ya - xa) / 2
;w((xb, yb)) = (yb - xb) / 2
;add((xa, ya), (xb, yb)) = ((xa + xb), (ya + yb))
;w(((xa + xb), (ya + yb))) = ((ya + yb) - (xa + xb)) / 2
;((ya + yb) - (xa + xb)) / 2 = ((ya - xa) / 2) + ((yb - xb) / 2)
;((ya + yb) - (xa + xb)) / 2 = ((ya - xa) + (yb - xb)) / 2)
;(ya + yb - xa - xb) / 2 = (ya - xa + yb - xb) / 2)
;(ya + yb - xa - xb) / 2 = (ya + yb - xa - xb) / 2)


;subtraction proof
;
;w((xa, ya)) = (ya - xa) / 2
;w((xb, yb)) = (yb - xb) / 2
;sub((xa, ya), (xb, yb)) = ((xa - xb), (ya - yb))
;w(((xa - xb), (ya - yb))) = ((ya - yb) - (xa - xb)) / 2
;((ya - yb) - (xa - xb)) / 2 = ((ya - xa) / 2) - ((yb - xb) / 2)
;((ya - yb) - (xa - xb)) / 2 = ((ya - xa) - (yb - xb)) / 2)
;((ya - yb - xa - xb)) / 2 = ((ya - xa - yb - xb)) / 2)
;((ya - yb - xa - xb)) / 2 = ((ya - yb - xa - xb)) / 2)

(display (interval-width (mul-interval int-c int-d)))
(display " != ")
(display (interval-width int-c))
(display " * ")
(display (interval-width int-d))
(newline)

(display (interval-width (div-interval int-c int-d)))
(display " != ")
(display (interval-width int-c))
(display " / ")
(display (interval-width int-d))
(newline)
