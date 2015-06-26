(list-gists)
;; => (#S(GIST ...) ...)

(list-gists :public t)
;; => (#S(GIST ...) ...)

(list-gists :username "Rudolph-Miller")
;; => (#S(GIST ...) ...)

(list-gists :since (local-time:today))
;; => (#S(GIST ...) ...)
