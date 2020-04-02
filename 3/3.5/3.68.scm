(load "streams.scm")

(define (pairs s t)
    (interleave
        (stream-map (lambda (x) (list (stream-car s) x)) t)
        (pairs (stream-cdr s) (stream-cdr t))))

;(display-first-x-of-stream (pairs integers integers) 50)

;; (display (stream-ref (pairs integers integers) 0)) (newline)

;You recurse forever. Why though?

(display-first-x-of-stream (stream-map (lambda (x) (list (stream-car integers) x)) integers) 50)

;It has to do with how interleave is defined. pairs never creates a pair on its own. Interleave alternates each between streams, and because of that, when the pairs stream becomes the first stream, it tries to get the value of the first item, which it doesn't have, so it calculates it, but to get it, it calls interleave, which brings us back to the initial problem. It's forever calling pairs->interleave->pairs->interleave, etc. This happens due to how delay works. Delay takes a function, and wraps/memoizes it. The problem is that to get that function, you get infinite recursion due to interleave's argument swap. The first inner call to interleave needs stream map, which requires pairs, which requires stream-map, which requires pairs, so you never actually get a function because everything is calling something else that returns a function. You recurse without a base case.