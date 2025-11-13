;; Exception handling queries for JavaScript/TypeScript
;; Matches try-catch-finally blocks

;; @exception.outer - entire try-catch-finally block
;; This matches the complete try statement including try, catch, and finally clauses
(try_statement) @exception.outer

;; @exception.inner - only the try block's content (excluding catch/finally)
;; This selects just the body of the try block
(try_statement
  body: (statement_block) @exception.inner)
