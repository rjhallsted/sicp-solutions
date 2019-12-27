(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))


;one
;(lambda (f) (lambda (x) (f ((zero f) x))))
;(lambda (f) (lambda (x) (f ((lambda (x) x) x))))
;(lambda (f) (lambda (x) (f x)))

(define one (lambda (f) (lambda (x) (f x))))

;two
;(lambda (f) (lambda (x) (f ((one f) x))))
;(lambda (f) (lambda (x) (f ((lambda (x) (f x)) x))))
;(lambda (f) (lambda (x) (f (f x)))

(define two (lambda (f) (lambda (x) (f (f x)))))

(define three (lambda (f) (lambda (x) (f (f (f x))))))


;(add one two)
;(add (lambda (fa) (lambda (xa) (fa xa)))
;    (lambda (fb) (lambda (xb) (fb (fb xb)))))

;(define (add a b)
;    (a b))
;(fa b)
;(fa (fb (fb xb)))

;(define (add a b)
;    (lambda (f) (a b)))

;(lambda (f) ((lambda (xa) (fa xa)) b))
;(lambda (f) (fa  b))
;(lambda (f) (fa  (lambda (xb) (fb (fb xb)))))

;(lambda (f) (a f))
;(lambda (f) (lambda (x) (f x)))

;(lambda (f) (b f))
;(lambda (f) (lambda (x) (f (f x))))

;(lambda (f) ((b f) (a f)))
;(lambda (f) ((lambda (xa) (f (f xa))) (lambda (xb) (f xb))))

;(lambda (f) (lambda (x) ((b f) ((a f) x))))
;(lambda (f) (lambda (x) ((lambda (x) (f (f x)))) ((a f) x)))
;(lambda (f) (lambda (x) (f (f ((a f) x)))))
;(lambda (f) (lambda (x) (f (f (f (x))))))

;(lambda (f) (lambda (x) (f (f (f x)))))

(define (add a b)
    (lambda (f) (lambda (x) ((b f) ((a f) x)))))