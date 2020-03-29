(load "digital-circuits.scm")

(define (ripple-carry-adder a-wires b-wires s-wires c-wire)
    (let ((c-out (make-wire)))
        (full-adder (car a-wires) (car b-wires) c-wire (car s-wires) c-out)
        (if (not (null? (cdr a-wires))
            (ripple-carry-adder (cdr a-wires) (cdr b-wires) (cdr s-wires) c-out))))
    'ok)

;;assuming and-gates take longer, or are equivalent to or-gates
;;foreach half-adder, 2 and-gates + 1 inverter
;;foreach full-adder, 4 and-gates + 2 inverters + 1 or-gate
;;for ripple-carry-adder -> 4n and-gates + 2n inverters + n or-gates

