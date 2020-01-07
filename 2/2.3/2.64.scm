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


;a) Partial tree first determines how many elements will be on the left side, which is
;the length of the tree, minus 1, divided by 2 and rounded down (due to integer division).
;It then calls it self to generate the left tree (left-result). It then sets left-tree to the
;tree portion of left-result, and then determines how many elements go the right by taking the
;list length minus left-size plus one. this-entry (which corresponds to the first node of the tree)
;is then the first element of non-left-elts. It then calls itself to get right-result using
;the first x (where x is the value of right-size) elements of non-left-elts
;(not including the value of this-entry).
;
;Now the function has all the parts needed for the root tree, which it makes using this-entry,
;left-tree, and right-tree. It returns a pair with the root tree and the remaining elements. The remaining
;elements are useful in the non-root calls of this recursive function. The the end cases and the root case, 
;the value of remaining-elts will be '().

;b) The order of growth of list->tree would be O(n). Each element is touched only once.