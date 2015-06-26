(let ((id "gistid"))
  (star-gist id))
;; => T

(let ((gist (git-gist "gistid")))
  (star-gist gist))
;; => T
