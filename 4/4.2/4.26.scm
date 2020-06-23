;unless as a derived expression
(define (unless? exp) (tagged-list? exp 'unless))
(define (analyze-unless exp) (analyze (unless-if exp)))
(define (unless->if exp)
    (make-if (if-predicate exp) (if-alternative exp) (if-consequent exp)))

;Both Ben and Alyssa are right. Using the derived expression described above, unless can be easily implemented as a 
;special form and work correctly in applicative-order. Alyssa