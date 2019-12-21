(define nil '()) ;using mit-scheme, so nil is not defined by default

(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map <??> rest)))))

(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map 
                        (lambda (x)
                            (append (list (car s)) x))
                        rest)))))

(display (subsets (list 3))) (newline)
;(() (3))

(display (subsets (list 2 3))) (newline)
;(() (3) (2) (2 3))

(display (subsets (list 1 2 3))) (newline)
;(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))


;This works by appending the the first item in s to the resulting subsets of the others.
;It recursively, gets all of the subsets but those involving the first number in s,
;and appends a list containing only the first value on the front. Those resulting lists
;then get appended to a list containing what they were without the first value.
;
;By doing this, the procedure drills down until it hits the individual values, in this case
;nil, then comes up a level, and appends 3 to that list (resulting in (3)). That list is
;appended to the existing one, resulting in (() (3)). It comes up a level again and repeats
;it again with 2. The resulting ((2) (2 3)) is appended to the original (() (3)) resulting
;in (() (3) (2) (2 3)). It happens again with 1. ((1) (1 3) (1 2) (1 2 3)) is appended to 
;(() (3) (2) (2 3)), resulting in (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3)).
;
;This is an example of how recursion works, and how it is a fractal process.