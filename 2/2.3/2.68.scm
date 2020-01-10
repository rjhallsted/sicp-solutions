(load "huffman.scm")

(define (element-of-set? x set)
    (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (encode-symbol symbol tree)
    (cond ((leaf? tree) '())
        ((element-of-set? symbol (symbols (left-branch tree)))
            (cons 0 (encode-symbol symbol (left-branch tree))))
        ((element-of-set? symbol (symbols (right-branch tree)))
            (cons 1 (encode-symbol symbol (right-branch tree))))
        (else (error "symbol not found in tree -- ENCODE-SYMBOL" symbol))))

(define sample-tree
    (make-code-tree (make-leaf 'A 4)
                    (make-code-tree
                    (make-leaf 'B 2)
                    (make-code-tree (make-leaf 'D 1)
                                    (make-leaf 'C 1)))))
                        
(display '(a d a b b c a)) (newline)
(display (decode (encode '(a d a b b c a) sample-tree)
                sample-tree))
(newline)