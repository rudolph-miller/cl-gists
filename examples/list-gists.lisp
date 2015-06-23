(list-gists)
;; => (list #S(GIST ...) ...)

(list-gists :public t)
;; => (list #S(GIST ...) ...)

(list-gists :username "Rudolph-Miller")
;; => (list #S(GIST ...) ...)

(list-gists :since (local-time:today))
;; => (list #S(GIST ...) ...)
