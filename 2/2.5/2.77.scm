(put 'real-part '(complex) real-part)
(put 'imag-part '(complex) imag-part)
(put 'magnitude '(complex) magnitude)
(put 'angle '(complex) angle)

(magnitude z)
(apply-generic 'magnitude z)
((get 'magnitude (op z)) z)
((get 'magnitude '(complex)) (contents z))
(apply-generic 'magnitude (contents z))
;;assuming (contents z) is 'polar. The steps are nearly the same for rectangular.
(car (contents z))

;;definitely missing some steps. Need to come back an fill them in