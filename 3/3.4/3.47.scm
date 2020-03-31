(define (make-mutex)
    (let ((cell (list false)))
        (define (the-mutex m)
            (cond
                ((eq? m 'acquire)
                    (if (test-and-set! cell)
                        (the-mutex 'acquire))) ; retry
                ((eq? m 'release)
                    (clear! cell))))
        the-mutex))
(define (clear! cell)
    (set-car! cell false))
(define (test-and-set! cell)
    (if (car cell)
        true
        (begin
            (set-car! cell true)
            false)))

;a) semaphore in terms of mutexes

(define (make-sempahore n)
    (let ((mutexes-left n)
          (mutexes (map (lambda (x) (make-mutex)) (enumerate 0 n))))
        (define (the-semaphore m)
            (cond ((eq? m 'acquire)
                    (if (> mutexes-left 0)
                        (let ((to-acquire (- mutexes-left 1)))
                            (begin
                                ((list-ref mutexes (- n to-acquire)) 'acquire)
                                (set! mutexes-left (- mutexes-left 1))))
                        (the-semaphore 'acquire)))
                ((eq? m 'release)
                    (if (< mutexes-left n)
                        (begin  
                            (set! mutexes-left (+ mutexes-left 1))
                            ((list-ref mutexes (- n mutexes-left)) 'release))))))
        the-semaphore))

;a) semaphore in terms of test-and-set! operations
(define (make-sempahore n)
    (let ((mutexes (map (lambda (x) false) (enumerate 0 n))))
        (define (found-and-set-mutex? check-these)
            (if (null? check-these)
                false
                (if (test-and-set! (car check-these))
                    (found-and-set-mutex (cdr check-these))
                    true)))
        (define (release-a-mutex! check-these)
            (if (not (null? check-these))
                (if (test-and-set! (car check-these))
                    (clear! (car check-these))
                    (begin
                        (clear! (car check-these))
                        (release-a-mutex! (cdr check-these))))))
        (define (the-semaphore m)
            (cond ((eq? m 'acquire)
                    (if (not (found-and-set-mutex? mutexes))
                        (the-semaphore 'acquire))) ; retry
                ((eq? m 'release)
                    (release-a-mutex! mutexes))))
        the-semaphore))
