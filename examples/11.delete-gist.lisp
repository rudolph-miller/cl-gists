(let ((id "gistid"))
  (delete-gist id))
;; => T

(let ((gist (get-gist "gistid")))
  (delete-gist gist))
;; => T
