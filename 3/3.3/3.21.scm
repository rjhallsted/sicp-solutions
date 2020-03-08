(load "queue.scm")

(define q1 (make-queue))
(insert-queue! q1 'a)
;((a) a)
(insert-queue! q1 'b)
;((a b) b)
(delete-queue! q1)
;((b) b)
(delete-queue! q1)
;(() b)

;;Queues are pairs. At the end of that first series of statements, the first pointer points to an empty list, where the second pointer still points to the last added item.

(define (display-queue queue)
    (display (front-ptr queue)))

(define q2 (make-queue))
(insert-queue! q2 'a)
(display-queue q2) (newline)
(insert-queue! q2 'b)
(display-queue q2) (newline)
(delete-queue! q2)
(display-queue q2) (newline)
(delete-queue! q2)
(display-queue q2) (newline)
(insert-queue! q2 'c)
(display-queue q2) (newline)
