;; extends

;; Exception handling queries for Go
;; Go doesn't have try-catch, but we can use defer-panic-recover pattern

;; @exception.outer - defer function call (used for error handling)
(defer_statement) @exception.outer

;; @exception.inner - the deferred function body
(defer_statement
  (call_expression) @exception.inner)

