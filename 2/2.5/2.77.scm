(put 'real-part '(complex) real-part)
(put 'imag-part '(complex) imag-part)
(put 'magnitude '(complex) magnitude)
(put 'angle '(complex) angle)

(magnitude z)
(apply-generic 'magnitude z)
(let ((type-tags '((complex))))
        (let ((proc (get 'magnitude '((complex)))))
            (if proc
                (apply proc '((contents z)))
                (error 
                    "No method for these types: APPLY-GENERIC"
                    (list op type-tags))))))
(apply magnitude '((contents z)))
(magnitude (contents z))
(apply-generic 'magnitude (contents z))
(let ((type-tags '(rectangular)))
    (let ((proc (get 'magnitude '(rectangular)))
        (if proc
            (apply proc '((contents (contents z))))
            (error 
                "No method for these types: APPLY-GENERIC"
                (list op type-tags))))))
(magnitude (contents (contents z)))
(sqrt (+ (square (real-part (contents (contents z))))
         (square (imag-part (contents (contents z))))))
(sqrt (+ (square (real-part '(3 4)))
         (square (imag-part '(3 4)))))
(sqrt (+ (square (car '(3 4)))
         (square (cdr '(3 4)))))
(sqrt (+ (square 3)
         (square 4)))
(sqrt (+ 9
         16))
(sqrt 25)
5

;;this works because it gives an external use of magnitude for the complex number package. All that procedure needs to do is differentiate between the polar and rectangular types, and call the correct 'magnitude' procedure. 'apply-generic' does this already. This would not work if the sub-packages of the complex number package did not each have a 'magnitude' procedure. It requires they all do, or you risk getting another error thrown by 'apply-generic'