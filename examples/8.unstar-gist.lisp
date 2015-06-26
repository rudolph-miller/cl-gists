(let ((id "gistid"))
  (unstar-gist id))
;; => T

(let ((gist (git-gist "gistid")))
  (unstar-gist gist))
;; => T
