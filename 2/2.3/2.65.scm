(load "binary-trees.scm")

(define (tree->list tree)
  (if (null? tree)
      '()
      (append (tree->list (left-branch tree))
              (cons (entry tree)
                    (tree->list (right-branch tree))))))

(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
        (let ((left-result (partial-tree elts left-size)))
          (let ((left-tree (car left-result))
                (non-left-elts (cdr left-result))
                (right-size (- n (+ left-size 1))))
            (let ((this-entry (car non-left-elts))
                  (right-result (partial-tree (cdr non-left-elts)
                                              right-size)))
              (let ((right-tree (car right-result))
                    (remaining-elts (cdr right-result)))
                (cons (make-tree this-entry left-tree right-tree)
                      remaining-elts))))))))

(define (balance-tree tree)
    (list->tree (tree->list tree)))


;; (define (union-set set1 set2)
;;     (cond ((null? set1) set2)
;;         ((null? set2) set1)
;;         (else
;;             (let ((x1 (car set1)) (x2 (car set2)))
;;                 (cond ((= x1 x2)
;;                         (cons x1 (union-set (cdr set1) (cdr set2))))
;;                     ((< x1 x2)
;;                         (cons x1 (union-set (cdr set1) set2)))
;;                     ((< x2 x1)
;;                         (cons x2 (union-set set1 (cdr set2)))))))))



;this is way more than O(n)
(define (union-set set1 set2)
    (balance-tree
        (cond ((null? set1) set2)
            ((null? set2) set1)
            (else
                (let ((x1 (entry set1)) (x2 (entry set2)))
                    (cond ((= x1 x2)
                            (make-tree x1 (union-set (left-branch set1) (left-branch set2))
                                        (union-set (right-branch set1) (right-branch set2))))
                        ((< x1 x2)
                            (union-set (adjoin-set x2 set1)
                                        (union-set (left-branch set2) (right-branch set2))))
                        ((> x1 x2)
                            (union-set (union-set (left-branch set1) (right-branch set1))
                                        (adjoin-set x1 set2)))))))))                                    

(define tree-a (list->tree '(1 3 5 7 9 11)))
(define tree-b (list->tree '(2 4 6 8 10 12)))

(display (union-set tree-a tree-b)) (newline)