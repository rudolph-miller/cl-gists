(in-package :cl-user)
(defpackage cl-gists.api
  (:use :cl
        :annot.doc
        :quri
        :cl-gists.util
        :cl-gists.user
        :cl-gists.file
        :cl-gists.gist)
  (:import-from :local-time
                :timestamp
                :format-timestring))
(in-package :cl-gists.api)

(syntax:use-syntax :annot)

(defparameter +api-base-uri+ "https://api.github.com")

@doc
"List gists."
(defun list-gists (&key username public starred since)
  (assert (not (and public starred)))
  (check-type since (or null timestamp))
  (let ((uri-components (list +api-base-uri+)))
    (when username
      (push "/users/" uri-components)
      (push username uri-components))
    (push "/gists" uri-components)
    (when public
      (push "/public" uri-components))
    (when starred
      (push "/starred" uri-components))
    (let ((uri (uri (apply #'concatenate 'string (nreverse uri-components)))))
      (when since
        (setf (uri-query-params uri) `(("since" . ,(format-timestring nil since)))))
      (make-gists-from-json (get-request uri)))))

@doc
"Get a single gist."
(defun get-gist (id &key sha)
  (check-type id string)
  (let ((uri-components (list id "/gists/" +api-base-uri+)))
    (when sha
      (push "/" uri-components)
      (push sha uri-components))
    (let ((uri (uri (apply #'concatenate 'string (nreverse uri-components)))))
      (make-gist-from-json (get-request uri)))))
