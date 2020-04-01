;n - 1 additions are performed
;
;0: 0
;1: 1
;2: 0 + 1 = 1
;3: 1 + 1 = 2
;4: 2 + 1 = 3
;5: 3 + 2 = 5
;6: 5 + 3 = 8
;7: 8 + 5 = 13

;indexed from 0, n - 1 additions are performed. Each respective fibonacci number needs to be calculated once

;if the streams weren't memoized, each number would have to be recalculated every time.

;0: 0
;1: 1
;2: 0 + 1 = 1
;3: (0 + 1) + 1 = 2
;4: ((0 + 1) + 1) + (0 + 1) = 3
;5: (((0 + 1) + 1) + (0 + 1)) + ((0 + 1) + 1) = 5
;6: ((((0 + 1) + 1) + (0 + 1)) + ((0 + 1) + 1)) + (((0 + 1) + 1) + (0 + 1)) = 8

;0: 0
;1: 0
;2: 1
;3: 2
;4: 4
;5: 7
;6: 12
;7: 20

;Each fibonacci must perform all of the additions for each number below it, meaning the total number of additions is a rapidly-increasing sequence itself. 0, 0, 1, 2, 4, 7 where the nth number is the (n-1)th number plus the (n-2)th number plus 1.