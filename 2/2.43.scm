;Louis's program runs slow because it calls queen-cols
;for each iteration of the 1 - board-size interval, which happens at every
;level of queen-cols. queen-cols is recursive, which means calls to it
;square for each column;

;Louis's running time is (x^x)T, where x is the board size.