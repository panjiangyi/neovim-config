;; Exception handling queries for Python
;; Matches try-except-finally blocks

;; @exception.outer - entire try-except-finally block
(try_statement) @exception.outer

;; @exception.inner - only the try block's content
(try_statement
  body: (block) @exception.inner)
