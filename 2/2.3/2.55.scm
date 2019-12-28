(display (car ''abracadabra)) (newline)
(display (car 'abracadabra)) (newline)

;(car ''abracadabra) expands to (car (quote (quote abracadabra))). The existence of '' leads to nested quotes, so the first element is quote.
;The first ' quotes the rest of the items, making them a list. ' is replaced with quote by the interpreter. abracdabra remains abracadabra.
;The first quote returns a list containing (quote abracadabra) to car.