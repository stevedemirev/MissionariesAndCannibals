; View next successor states
(defun mac-next (state)
  (let ((error-type (check-input state)))
    (if error-type
        (progn
          (format t "Input error: ~a~%" error-type))
        (progn
          (format t "Valid state: ~a~%" state)
          (format t "Successor states: ~a~%" (generate-successor-states state))
          ))))

; Input error handling
(defun check-input (state)
  (cond
    ((< (length state) 3)
    "Not enough states were input, please input 3")

    ((> (length state) 3)
    "Too many states were input, please input 3")

    ((not (integerp(first state)))
    "Missionary state is not an integer, please enter an integer")

    ((not (integerp(second state)))
    "Cannibal state is not an integer, please enter an integer")

    ((or (< (first state) 0) (> (first state) 3))
    "Missionary value must be between 0-3 (inclusive)")

    ((or (< (second state) 0) (> (second state) 3))
    "Cannibal value must be between 0-3 (inclusive)")

    ((and (< (first state) (second state)) (not (= (first state) 0)))
    "Cannibals have eaten the Missionary(s), please ensure 'm' is greater than or equal to 'c' or 'm' is set to 0")

    ((not (member (third state) '(l r)))
    "Boat must be either 'l' or 'r'")

    ((not (valid-input state))
    "Unknown input error")

    (t nil)))

; Input constraints
(defun valid-input (state)
  (and (listp state)
       (= (length state) 3)
       (integerp (first state))
       (integerp (second state))
       (member (third state) '(l r))
       (or (and (>= (first state) (second state)) (not (= (first state) 0))) (= (first state) 0))
       (<= 0 (first state) 3)
       (<= 0 (second state) 3)
       ))

; Constraint function to determine whether it will be a valid state
(defun successor-constraints (m c)
  (and (<= m 3) (>= m 0) (<= c 3) (>= c 0) ; 0 <= m <= 3 && 0 <= c <= 3
        ; Constraints: More missionaries than cannibals on left side and right side or missionaries = cannibals
        ; ((m > c && 3-m = 0) || m = c ) || ((m < c) && (3-m = 3))
       (or (or (and (> m c) (= (- 3 m) 0)) 
           (= m c))
        (or (and (< m c) (= (- 3 m)3))))))

; Function that pushes successor states to list if valid
(defun generate-successor-states (state)
  (let* ((m (car state))  ; Number of missionaries on the left bank
         (c (cadr state)) ; Number of cannibals on the left bank
         (b (caddr state)) ; Location of the boat ('l' or 'r')
         (opposite-bank (if (eql b 'l) 'r 'l)) ; Calculate opposite bank
         (successors '()))  ; Initialize empty list for successor states

; Left bank below         
    ; Push 2 missionaries if valid state from left bank
    (if (and (eql b 'l) (successor-constraints (- m 2) c))
        (push (list (- m 2) c opposite-bank) successors))

    ; Push 1 missionary if valid state from left bank
    (if (and (eql b 'l) (successor-constraints (- m 1) c))
        (push (list (- m 1) c opposite-bank) successors))

    ; Push 2 cannibals if valid state from left bank
    (if (and (eql b 'l) (successor-constraints m (- c 2)))
        (push (list m (- c 2) opposite-bank) successors))

    ; Push 1 cannibal if valid state from left bank
    (if (and (eql b 'l) (successor-constraints m (- c 1)))
        (push (list m (- c 1) opposite-bank) successors))

    ; Push 1 missionary and 1 cannibal if valid state from left bank
    (if (and (eql b 'l) (successor-constraints (- m 1) (- c 1)))
        (push (list (- m 1) (- c 1) opposite-bank) successors))

; Right bank below
    ; Push 2 missionaries if valid state from right bank
    (if (and (eql b 'r) (successor-constraints (+ m 2) c))
        (push (list (+ m 2) c opposite-bank) successors))

    ; Push 1 missionary if valid state from right bank
    (if (and (eql b 'r) (successor-constraints (+ m 1) c))
        (push (list (+ m 1) c opposite-bank) successors))

    ; Push 2 cannibals if valid state from right bank
    (if (and (eql b 'r) (successor-constraints m (+ c 2)))
        (push (list m (+ c 2) opposite-bank) successors))

    ; Push 1 cannibal if valid state from right bank
    (if (and (eql b 'r) (successor-constraints m (+ c 1)))
        (push (list m (+ c 1) opposite-bank) successors))

    ; Push 1 missionary and 1 cannibal if valid state from right bank
    (if (and (eql b 'r) (successor-constraints (+ m 1) (+ c 1)))
        (push (list (+ m 1) (+ c 1) opposite-bank) successors))

    ; Push nil if no valid states exist from right bank
    (if (null successors)
        (push nil successors))

    successors))

(defun visited-states (state visited)
;Check if state has already been visited
  (member state visited :test #'equal)) 

(defun dfs (current-state end-state path visited)
; Return the path taken if we reach end-state
  (if (equal current-state end-state)
      (reverse path)  
; Remove visited states from successors list and place to unvisited-successors
      (let* ((successors (generate-successor-states current-state))
             (unvisited-successors (remove-if (lambda (state) (visited-states state visited)) successors)))    
; DFS loop to visit each unvisited successor
        (dolist (next unvisited-successors)
          (let ((new-visited (cons next visited)))
            (let ((result (dfs next end-state (cons next path) new-visited)))
              (when result
                (return result))))))))

(defun mac (start end)
  ; Check 'start' and 'end' variables for errors
  (let ((start-error (check-input start))
        (end-error (check-input end)))
    (if (or start-error end-error)
        (progn
          (when start-error
            (format t "Input error in start state input: ~a~%" start-error))
          (when end-error
            (format t "Input error in end state input: ~a~%" end-error))
          (exit 1))))
  ; Make a visited list, place starting state into list then start DFS and return path
  (let ((visited '()))
    (push start visited)
    (let ((path (dfs start end (list start) visited)))
      (format t "Path from ~a to ~a: ~a~%" start end (if path path '(nil)))))) 


; Menu for program
(defun menu ()
    (format t "Welcome to the Missionaries and Cannibals Program! ~%")
  (loop
    (format t "~%Please enter '1' to use starting state: (3 3 L) and ending state: (0 0 R),
Please enter '2' to use starting state: (3 3 L) and ending state: (2 2 L),
Please enter '3' to use starting state: (2 2 L) and ending state: (0 2 L),
Please enter '4' to input a custom list,
Please enter '5' to view the successor states of a state,
Please enter 'exit' to exit the program.

Input: ")
    (let ((choice (read)))
      (terpri)
      (case choice
        (`exit (return))
        (1 (mac `(3 3 l) `(0 0 r)))
        (2 (mac `(3 3 l) `(2 2 l)))
        (3 (mac `(2 2 l) `(0 2 l)))
        (4 (format t "Please input the starting state in the form '(m c b)': ")
            (let ((starting (read)))
            (format t "Please input the ending state in the form '(m c b)': ")
            (let ((ending (read)))
                (terpri)
                (mac starting ending))))
        (5 (format t "Please input a state in the form '(m c b)': ")
         (let ((state (read)))
            (terpri)
           (mac-next state)))))))

(menu)


