(let ((id "gistid"))
  (gist-starred-p id))
;; => T or NIL

(let ((gist (git-gist "gistid")))
  (gist-starred-p gist))
;; => T or NIL
