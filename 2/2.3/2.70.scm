(load "huffman.scm")

(define pairs '((A 2) (BOOM 1) (GET 2) (JOB 2) (NA 16) (SHA 3) (YIP 9) (WAH 1)))
(define tree (generate-huffman-tree pairs))

(define message '(Get a job Sha na na na na na na na na Get a job Sha na na na na na na na na Wah yip yip yip yip yip yip yip yip yip Sha boom)))

(display (encode message tree)) (newline)
;;(0 0 0 1 0 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 0 0 1 0 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 0 0 0 0 0 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 0 0 0 0 0 0 1)

(display (length (encode message tree))) (newline)
;122 bits required

;for an 8-symbol fixed-length alphabet, each symbol would require 3 bits (2^3 = 8).
;The message is 36-symbols long, meaning a total of 108 bits (36 * 3 = 108) would be required to encode it.
