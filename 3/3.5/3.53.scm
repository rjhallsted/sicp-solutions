(define s (cons-stream 1 (add-streams s s)))

;(1 2 4 8 16 32), etc. Each item is double the prior item