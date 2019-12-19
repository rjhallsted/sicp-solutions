(define (reverse x)
    (define (reverse-inner orig new)
        (if (null? (cdr orig))
            (cons (car orig) new)
            (reverse-inner (cdr orig) (cons (car orig) new))))
    (if (null? x)
        x    
        (reverse-inner x '())))

(define (no-more? x)
    (null? x))

(define (except-first-denomination x)
    (cdr x))

(define (first-denomination x)
    (car x))

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount
                   (first-denomination coin-values))
                coin-values)))))

;the order of the coin denominations does not affect the answer
;because the same coins are in play.

;testing
(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(display (cc 100 us-coins)) (newline)
(display (cc 100 (reverse us-coins))) (newline)
(newline)
(display (cc 100 uk-coins)) (newline)
(display (cc 100 (reverse uk-coins))) (newline)