;skipping drawing out environments both because I have a good grasp of this already and it's hard to do in a text editor

;;make-account has all of its definitions in one frame
;;acc points to the dispatch, in E1. The evalutation of disptach returns a procudure, contained in E1, in a new frame (E1a). The value of balance is pulled from E1

;;acc2 is distinct from acc because it lives in a different environment. How these are separated is an implementation detail. They could feasibly share the same projecedure objects for dispatch, etc. and keep different frames for balance. Alteranatively, they could use different procedure objects for dispatch, etc., keeping them in the same frame as balance.