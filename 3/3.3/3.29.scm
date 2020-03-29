(define (or-gate a b output)
    (let ((c (make-wire)) (d (make-wire)) (e (make-wire)))
        (inverter a c)
        (inverter b d)
        (and-gate c d e)
        (inverter e output)))
    'ok)

;the delay is 2 inverter-delays plus 1 and-gate-delay