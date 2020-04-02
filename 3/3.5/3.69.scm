(load "streams.scm")

(define (pairs s t)
    (cons-stream
        (list (stream-car s) (stream-car t))
        (interleave
            (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
            (pairs (stream-cdr s) (stream-cdr t)))))

;; (define (triples s t u)
;;     (let ((pairs (pairs t u)))
;;         (let ((first-pair (stream-car pairs)))
;;             (con-stream
;;                 (list (stream-car s) (car first-pair) (cadr first-pair))
;;                 (interleave
;;                     (stream-map (lambda (x) (list (stream-car s) (car x) (cadr x)))
;;                                 pairs)
;;                     (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))))


(define (triples s t u)
    (define (make-triples-with these-pairs these-integers)
        (let ((first-pair (stream-car these-pairs)))
            (cons-stream
                (list (car first-pair)
                    (cadr first-pair)
                    (stream-car these-integers))
                (interleave
                    (stream-map (lambda (x) (list (car first-pair) (cadr first-pair) x))
                                (stream-cdr these-integers))
                    ;if all vals were equal, increment integer, othwerwise dont
                    (if (and (= (car first-pair) (cadr first-pair))
                             (= (car first-pair) (stream-car these-integers)))
                        (make-triples-with (stream-cdr these-pairs) (stream-cdr these-integers))
                        (make-triples-with (stream-cdr these-pairs) these-integers))))))
    (make-triples-with (pairs s t) u))


(define up-to-100 (stream-enumerate-interval 1 100))
(define pythagorean-triples
    (stream-filter (lambda (x) (= (+ (square (car x)) (square (cadr x)))
                                  (square (caddr x))))
                    (triples up-to-100 up-to-100 up-to-100)))

(display-stream pythagorean-triples)