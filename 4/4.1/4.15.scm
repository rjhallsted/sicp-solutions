(define (run-forever) (run-forever))
(define (try p)
    (if (halts? p p) (run-forever) 'halted))

;A procedure such as halts? would necessarily need to actually wait for the expression to halt. If the expression never halts, halts? never arrives at a solution.

;The most obvious attempt to solve this is to see if a procedure calls itself and return false if true. However, this fails when applied to any recursive procedure with a base case, such as factorial.

;If you were to run (try try), you'd end up with an endless recursion. halts? would attempt (try try), which would call halts? again, etc.
;If in this case, halts? were to return true, this would violate halts? intended behavior, as try would return (run-forever) if halts? evaluated to true, which would mean try doesn't halt.
;The reverse case is true as well. If halts? evaluated to false, try would return 'halted, which would have surrounding halts return true, causing the surrounding try to call run-forever, meaning it doesn't halt.