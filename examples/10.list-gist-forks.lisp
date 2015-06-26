(let ((id "gistid"))
  (list-gist-forks id))
;; => (#S(GIST ...) ...)

(let ((gist (git-gist "gistid")))
  (list-gist-forks gist))
;; => (#S(GIST ...) ...)
