(load "2.12.scm")

(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))
(define (par2 r1 r2)
  (let ((one (make-interval 1 1))) 
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))

(define int-a (make-interval 20.2 20.3))
(define int-b (make-interval 129 130))

(print-center-width (par1 int-a int-b))
(print-center-width (par2 int-a int-b))
(print-center-width (div-interval int-a int-a))
(print-center-width (div-interval int-a int-b))


(newline)

(define int-c (make-interval 101 103))
(define int-d (make-interval 28 28.1))

(print-center-width (par1 int-c int-d))
(print-center-width (par2 int-c int-d))
(print-center-width (div-interval int-c int-c))
(print-center-width (div-interval int-c int-d))

(newline)

;par2 ends up with a tighter resulting tolerance.