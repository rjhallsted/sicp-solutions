(load "mapping.scm")

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things) 
              (cons (square (car things))
                    answer))))
  (iter items nil))

(display (square-list (list 1 2 3 4))) (newline)

;The above version appends the existing list to the newly squared item, rather than appending the item to the list.

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items nil))

(display (square-list (list 1 2 3 4))) (newline)

;Louis is still adding the new item at the top of the list. He need's to cdr down to the end of the list before appending the item.
