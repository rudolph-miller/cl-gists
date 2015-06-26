;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; By default, environment variables.

*github-username-env-var*
;; => "GITHUB_USERNAME"

*github-password-env-var*
;; => "GITHUB_PASSWORD"

*github-oauth-token-env-var*
;; => "GITHUB_OAUTH_TOKEN"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; You can customize credential methods.

(defclass github-credentials ()
  ((username :initarg :username)
   (password :initarg :password)
   (oauth-token :initarg :oauth-token)))

;; username and password

(defmethod username ((obj github-credentials))
  (slot-value obj 'username))

(defmethod password ((obj github-credentials))
  (slot-value obj 'password))

(setq *credentials* (make-instance 'github-credentials
                                   :username "Rudolph-Miller"
                                   :password "PASSWORD"))

;; oauth-token

(defmethod oauth-token ((obj github-credentials))
  (slot-value obj 'oauth-token))

(setq *credentials* (make-instance 'github-credentials
                                   :oauth-token "OAUTHTOKEN"))
