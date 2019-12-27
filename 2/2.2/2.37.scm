(load "list-ops.scm")

(define m (list (list 1 2 3 4) (list 4 5 6 6) (list 6 7 8 9)))

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(display (dot-product (list 1 2 3) (list 1 5 7))) (newline)
;32

(define (matrix-*-vector m v)
  (map (lambda (x) (dot-product x v)) m))

(display (matrix-*-vector m (list 1 2 3 4))) (newline)
;(30 56 80)

(define (transpose mat)
  (accumulate-n cons nil mat))

(display (transpose m)) (newline)
;((1 4 6) (2 5 7) (3 6 8) (4 6 9))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (v)
            (matrix-*-vector cols v))
        m)))

(define a (list (list 1 2 3) (list 4 5 6)))
(define b (list (list 1 2) (list 3 4) (list 5 6)))

(display (matrix-*-matrix a b)) (newline)
;((22 28) (44 64))


