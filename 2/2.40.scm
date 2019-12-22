(load "list-ops.scm")


(define (unique-pairs n)
    (flatmap (lambda (i)
                (map (lambda (j)
                        (list i j))
                    (enumerate-interval 1 (- i 1))))
            (enumerate-interval 1 n)))

(display (unique-pairs 6)) (newline)

;borrowed version of prime?
(define (prime? n)
  (define (F n i) ;"helper"
    (cond ((< n (* i i)) #t)
          ((zero? (remainder n i)) #f)
          (else
           (F n (+ i 1)))))
; "primality test"
 (cond ((< n 2) #f)
     (else
      (F n 2))))


(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

;improved prime-sum-pairs
(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum? (unique-pairs n))))

(display (prime-sum-pairs 6)) (newline)