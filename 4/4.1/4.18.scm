(define (solve f y0 dt)
    (define y (integral (delay dy) y0 dt))
    (define dy (stream-map f y))
    y))

(define solve
    (lambda (f y0 dt)
        (let ((y '*unassigned*) (dy '*unassigned))
            (let ((a (integral (delay dy) y0 dt))
                (b (stream-map f y)))
                (set! y a)
                (set! dy b)
                y)))

;;The above method will not work correctly for solve, because at the expresssions are evaluated at the time of definition (due to the second let), while their values are still '*unassigned. Normally the expressions are evaluated when they are called, allowing them to be re-evaluated for each item in the stream


(lambda ⟨vars⟩
    (let ((u '*unassigned*)
          (v '*unassigned*))
        (set! u ⟨e1⟩)
        (set! v ⟨e2⟩)
        ⟨e3⟩))

(define solve
    (lambda (f y0 dt)
        (let ((y '*unassigned)
              (dy '*unassigned))
            (set! y (integral (delay dy) y0 dt))
            (set! dy (stream-map f y))
            y)))