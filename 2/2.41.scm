(load "list-ops.scm")

(define (unique-triples n)
    (flatmap (lambda (i)
        (flatmap (lambda (j)
                    (map (lambda (k)
                        (list i j k))
                        (enumerate-interval 1 (- j 1))))
                (enumerate-interval 1 (- i 1))))
    (enumerate-interval 1 n)))



;(define (prime-sum-pairs n)
;  (map make-pair-sum
;       (filter prime-sum? (unique-pairs n))))

(define (sum-to? s)
    (lambda (triple)
        (= s (accumulate + 0 triple))))

(define (ordered-triples-that-sum-to n s)
    (filter (sum-to? s) (unique-triples n)))

(display (ordered-triples-that-sum-to 6 10)) (newline)