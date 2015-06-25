(in-package :cl-user)
(defpackage cl-gists.api
  (:use :cl
        :annot.doc
        :quri
        :cl-gists.util
        :cl-gists.user
        :cl-gists.file
        :cl-gists.fork
        :cl-gists.history
        :cl-gists.gist)
  (:import-from :jonathan
                :to-json)
  (:import-from :local-time
                :timestamp
                :format-timestring)
  (:export :list-gists
           :get-gist
           :create-gist
           :edit-gist
           :list-gist-commits
           :star-gist
           :unstar-gist
           :gist-starred-p
           :fork-gist
           :list-gist-forks
           :delete-gist))
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
      (make-gists (parse-json (get-request uri))))))

@doc
"Get a single gist."
(defun get-gist (id &key sha)
  (check-type id string)
  (let ((uri-components (list id "/gists/" +api-base-uri+)))
    (when sha
      (push "/" uri-components)
      (push sha uri-components))
    (let ((uri (uri (apply #'concatenate 'string (nreverse uri-components)))))
      (apply #'make-gist (parse-json (get-request uri))))))

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
    (apply #'make-gist (parse-json (post-request uri content)))))

@doc
"Edit a gist."
#|
Task: auth
|#
(defun edit-gist (gist)
  (check-type gist gist)
  (if (gist-id gist)
      (let ((uri (uri (format nil "~a/gists/~a" +api-base-uri+ (gist-id gist))))
            (content (to-json `(("description" . ,(gist-description gist))
                                ("public" . ,(gist-public gist))
                                ("files" . ,(loop for file in (gist-files gist)
                                                  collecting (cons (or (file-old-name file) (file-name file))
                                                                   (if (file-content file)
                                                                       `(("content" . ,(file-content file)))
                                                                       :null)))))
                              :from :alist)))
        (apply #'make-gist (parse-json (patch-request uri content))))
      (error "No id bound.")))

(defun get-gist-id (id-or-gist)
  (etypecase id-or-gist
    (string id-or-gist)
    (gist (gist-id id-or-gist))))

@doc
"List gist commits."
(defun list-gist-commits (id-or-gist)
  (check-type id-or-gist (or string gist))
  (let* ((id (get-gist-id id-or-gist))
         (uri (uri (format nil "~a/gists/~a/commits" +api-base-uri+ id))))
      (make-histories-from-json (get-request uri))))

@doc
"Star a gist."
(defun star-gist (id-or-gist)
  (check-type id-or-gist (or string gist))
  (let* ((id (get-gist-id id-or-gist))
         (uri (uri (format nil "~a/gists/~a/star" +api-base-uri+ id))))
    (multiple-value-bind (body status) (put-request uri)
      (declare (ignore body))
      (when (= status 204)
        t))))

@doc
"Unstar a gist."
(defun unstar-gist (id-or-gist)
  (check-type id-or-gist (or string gist))
  (let* ((id (get-gist-id id-or-gist))
         (uri (uri (format nil "~a/gists/~a/star" +api-base-uri+ id))))
    (multiple-value-bind (body status) (delete-request uri)
      (declare (ignore body))
      (when (= status 204)
        t))))

@doc
"Check if a gist starred."
(defun gist-starred-p (id-or-gist)
  (check-type id-or-gist (or string gist))
  (let* ((id (get-gist-id id-or-gist))
         (uri (uri (format nil "~a/gists/~a/star" +api-base-uri+ id))))
    (multiple-value-bind (body status) (get-request uri :ignore-statuses (list 404))
      (declare (ignore body))
      (ecase status
        (204 t)
        (404 nil)))))

@doc
"Fork a gist."
(defun fork-gist (id-or-gist)
  (check-type id-or-gist (or string gist))
  (let* ((id (get-gist-id id-or-gist))
         (uri (uri (format nil "~a/gists/~a/forks" +api-base-uri+ id))))
    (apply #'make-gist (parse-json (post-request uri)))))

@doc
"List gist forks."
(defun list-gist-forks (id-or-gist)
  (check-type id-or-gist (or string gist))
  (let* ((id (get-gist-id id-or-gist))
         (uri (uri (format nil "~a/gists/~a/forks" +api-base-uri+ id))))
    (make-gists (parse-json (get-request uri)))))

@doc
"Delete a gist."
(defun delete-gist (id-or-gist)
  (check-type id-or-gist (or string gist))
  (let* ((id (get-gist-id id-or-gist))
         (uri (uri (format nil "~a/gists/~a" +api-base-uri+ id))))
    (multiple-value-bind (body status) (delete-request uri)
      (declare (ignore body))
      (when (= status 204)
        t))))
