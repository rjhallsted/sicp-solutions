;a)

(define (get-record employee-name file)
    ((get file 'employee) employee-name))

;Each division would need to supply a package, along with an installer that uses the put procedure.
;They would need to use the file as the identifier, and must supply an 'employee' procedure that
;returns the record containing the given employee name. If the employee is not found, is should return false.

;b)

(define (get-salary employee-name file)
    ((get file 'salary) (get-record file employee-name)))

;The file's package must provide a selector procedure that returns the salary of a given employee record.
;As long as each division provides this, the structure of the record itself is irrelevant to the 'get-salary'
;procedure.

;c)
(define (find-employee-record employee-name files)
    (if (null? files)
        #f
        (let ((record (get-record employee-name (car files))))
            (if (record)
                record
                (find-employee-record employee-name (cdr files))))))

;d) The new division must create a package with it's internal record system. That package 
;should contain a selector to get a record keyed to an employee's name, added to the external system
;using 'put'. It should also supply selectors on that record to access information such as salary, address,
;etc. Those selectors should also be exposed to the external system using 'put'.