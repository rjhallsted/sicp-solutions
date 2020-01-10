(load "huffman.scm")
(load "../2.2/list-ops")

(define (min a b) (if (< b a) b a))

(define (do-merge leaves)
    (define (smallest-weight leaves)
        (accumulate (lambda (item comparison) (min (weight item) comparison))
                    10000000
                    leaves))
    (define (do-merge-inner leaves small-weight)
        (if (or (= small-weight (weight (car leaves)))
                (null? (cddr leaves)))
            (cons (make-code-tree (car leaves) (cadr leaves))
                  (cddr leaves))
            (cons (car leaves)
                  (do-merge-inner (cdr leaves) small-weight))))
    (do-merge-inner leaves (smallest-weight leaves)))

(define (successive-merge leaves)
    (if (null? (cdr leaves))
        leaves
        (successive-merge (do-merge leaves))))


(define leaf-set (make-leaf-set '((A 8) (B 3) (C 1) (D 1) (E 1) (F 1) (G 1) (H 1))))
(display (successive-merge leaf-set)) (newline)

(define sample-tree (successive-merge leaf-set))
(display (decode (encode '(a d a b b c a) sample-tree)
                sample-tree))
(newline)