(let ((id "gistid"))
  (list-gist-commits id))
;; => (#S(HISTORY ...) ...)

(let ((gist (get-gist "gistid")))
  (list-gist-commits gist))
;; => (#S(HISTORY ...) ...)
