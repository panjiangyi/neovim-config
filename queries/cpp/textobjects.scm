;; extends

;; Exception handling queries for C++
;; Matches try-catch blocks

;; @exception.outer - entire try-catch block
(try_statement) @exception.outer

;; @exception.inner - only the try block's content
(try_statement
  body: (compound_statement) @exception.inner)

