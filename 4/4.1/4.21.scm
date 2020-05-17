;; ;a
;; ((lambda (n)
;;     ((lambda (fact) (fact fact n))
;;         (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))))
;;     10)

;; (lambda (10)
;;     ((lambda (fact) (fact fact 10))
;;     (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))))

;; ((lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))
;;     (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))
;;     10)

;; (if (= 10 1) 1 (* 10 ((lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))
;;                             (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))
;;                             (- 10 1))))

;; (* 10 ((lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))
;;             (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))
;;             9))

;; (* 10 (* 9 ((lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))
;;                 (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))
;;                 8)))             
;; (* 10 (* 9 (* 8 ((lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))
;;                     (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))
;;                     7))))
;; ;....                    

;; (* 10 (* 9 (* 8 (* 7 (* 6 (* 5 (* 4 (* 3 (* 2 ((lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))
;;                                                     (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))
;;                                                     1))))))))))
                                                
;; (* 10 (* 9 (* 8 (* 7 (* 6 (* 5 (* 4 (* 3 (* 2 1)))))))))
;; (* 10 (* 9 (* 8 (* 7 (* 6 (* 5 (* 4 (* 3 2))))))))
;; (* 10 (* 9 (* 8 (* 7 (* 6 (* 5 (* 4 6)))))))
;; (* 10 (* 9 (* 8 (* 7 (* 6 (* 5 24))))))
;; (* 10 (* 9 (* 8 (* 7 (* 6 120)))))
;; (* 10 (* 9 (* 8 (* 7 720))))
;; ;....
;; 3628800


;analogous fibonacci
((lambda (n)
    ((lambda (fact) (fact fact n))
        (lambda (ft k) (if (or (= k 0) (= k 1)) k (+ (ft ft (- k 1)) (ft ft (- k 2)))))))
    10)

;b
(define (f x)
((lambda (even? odd?) (even? even? odd? x))
    (lambda (ev? od? n)
        (if (= n 0) true (od? ev? od? (- n 1))))
    (lambda (ev? od? n)
        (if (= n 0) false (ev? ev? od? (- n 1))))))