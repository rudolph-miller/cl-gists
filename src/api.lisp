(in-package :cl-user)
(defpackage cl-gists.api
  (:use :cl
        :annot.doc
        :quri
        :cl-gists.util
        :cl-gists.user
        :cl-gists.file
        :cl-gists.gist)
  (:import-from :jonathan
                :to-json)
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

@doc
"Create a gist."
#| 
Task: Have to check filename
See: https://developer.github.com/v3/gists/#create-a-gist
Note: Don't name your files "gistfile" with a numerical suffix. This is the format of the automatic naming scheme that Gist uses internally.
|#
(defun create-gist (gist)
  (check-type gist gist)
  (let ((uri (uri (format nil "~a/gists" +api-base-uri+)))
        (content (to-json `(("description" . ,(gist-description gist))
                            ("public" . ,(gist-public gist))
                            ("files" . ,(loop for file in (gist-files gist)
                                              collecting (cons (file-name file)
                                                               `(("content" . ,(file-content file)))))))
                          :from :alist)))
    (make-gist-from-json (post-request uri content))))
