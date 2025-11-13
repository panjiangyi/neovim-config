;; Exception handling queries for Java
;; Matches try-catch-finally blocks

;; @exception.outer - entire try-catch-finally block
(try_statement) @exception.outer

;; @exception.inner - only the try block's content
(try_statement
  body: (block) @exception.inner)
