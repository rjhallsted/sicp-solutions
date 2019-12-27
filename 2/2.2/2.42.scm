(load "list-ops.scm")

(define (make-position-set items)
    items)

(define (append-position position new-row)
    (make-position-set (append position (list new-row))))

(define (get-position-at positions col)
    (list-ref positions (- col 1)))

(define empty-board '())

(define (safe? col positions)
    (define (check-col-for check-col unsafe-vals)
        (find (lambda (x) (= (get-position-at positions check-col) x))
            unsafe-vals))
    (define (run-checks check-col offset current-pos)
        (cond ((= 0 check-col)
                #t)
            ((check-col-for check-col (list (- current-pos offset)
                                            current-pos
                                            (+ current-pos offset)))
                #f)
            (else
                (run-checks (- check-col 1) (+ offset 1) current-pos))))
    (run-checks (- col 1) 1 (get-position-at positions col)))

(define (adjoin-position new-row col rest-of-queens)
    (if (eqv? empty-board rest-of-queens)
        (make-position-set (list new-row))
        (append-position rest-of-queens new-row)))

(define (queens board-size)
    (define (queen-cols k)  
        (if (= k 0)
            (list empty-board)
            (filter (lambda (positions) (safe? k positions))
                    (flatmap (lambda (rest-of-queens)
                                (map (lambda (new-row)
                                        (adjoin-position new-row k rest-of-queens))
                                    (enumerate-interval 1 board-size)))
                            (queen-cols (- k 1))))))
    (queen-cols board-size))

(map (lambda (solution)
        (display solution)
        (newline))
    (queens 8))
(display "solution count: ") (display (length (queens 8))) (newline)

