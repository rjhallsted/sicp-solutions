;; Currently, the table is stored as a list where each item's car points to a pair where the car is the key and the cdr is the value for that keys. This allows an indefinite depth.

;; To modify this so that table is represented as a binary tree ordered by the keys, each node of the tree would be represented thus: The car is the value of that node, in this case the same pair containing the key and value as described above. The cdr then contains a pair with pointers to the left and right branches.

;; From there the lookup and insert procedures whould need to be modified so that they can traverse the tree and create the new type of node