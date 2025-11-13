;; extends

;; Exception handling queries for JavaScript/TypeScript
;; Matches try-catch-finally blocks

;; @exception.outer - entire try-catch-finally block
(try_statement) @exception.outer

;; @exception.inner - only the try block's content (excluding catch/finally)
(try_statement
  body: (statement_block) @exception.inner)

