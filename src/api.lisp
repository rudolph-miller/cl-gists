;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-USER -*-
;;; Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
;;; Copyright (c) 2023 by Symbolics Pte. Ltd. All rights reserved.
;;; SPDX-License-identifier: MS-PL

(in-package #:cl-user)

(uiop:define-package #:cl-gists.api
  (:use :cl
        :annot.doc
        :quri
        :cl-gists.util
        :cl-gists.user
        :cl-gists.file
        :cl-gists.fork
        :cl-gists.history
        :cl-gists.gist)
  (:import-from :local-time
                :timestamp
                :format-timestring)
  (:import-from :jonathan
                :to-json)
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

(defun check-credentials ()
  (unless (or (oauth-token *credentials*)
              (and (username *credentials*)
                   (password *credentials*)))
    (error "One of OAuth token or Basic Authentication is required.")))

(defparameter +api-base-uri+ "https://api.github.com"
  "GitHub API Base URI"  )

(defun list-gists (&key username public starred since)
  "List gists"
  (when (and public starred)
    (error "Do not specify both of :public and :starred."))
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

(defun get-gist (id &key sha)
  "Get a single gist."
  (check-type id string)
  (let ((uri-components (list id "/gists/" +api-base-uri+)))
    (when sha
      (push "/" uri-components)
      (push sha uri-components))
    (let ((uri (uri (apply #'concatenate 'string (nreverse uri-components)))))
      (apply #'make-gist (parse-json (get-request uri))))))

#|
Task: Have to check filename
See: https://developer.github.com/v3/gists/#create-a-gist
Note: Don't name your files "gistfile" with a numerical suffix. This is the format of the automatic naming scheme that Gist uses internally.
|#
(defun create-gist (gist)
  "Create a gist."
  (check-type gist gist)
  (let ((uri (uri (format nil "~a/gists" +api-base-uri+)))
        (content (to-json `(("description" . ,(gist-description gist))
                            ("public" . ,(gist-public gist))
                            ("files" . ,(loop for file in (gist-files gist)
                                              collecting (cons (file-name file)
                                                               `(("content" . ,(file-content file)))))))
                          :from :alist)))
    (apply #'make-gist (parse-json (post-request uri :content content)))))

#|
Task: auth
|#
(defun edit-gist (gist)
  "Edit a gist."
  (check-type gist gist)
  (check-credentials)
  (if (gist-id gist)
      (let ((uri (uri (format nil "~a/gists/~a" +api-base-uri+ (gist-id gist))))
            (content (to-json `(("description" . ,(gist-description gist))
                                ("files" . ,(loop for file in (gist-files gist)
                                                  collecting (cons (or (file-old-name file) (file-name file))
                                                                   (if (file-content file)
                                                                       `(("content" . ,(file-content file))
                                                                         ("filename" . ,(file-name file)))
                                                                       :null)))))
                              :from :alist)))
        (apply #'make-gist (parse-json (patch-request uri :content content))))
      (error "No id bound.")))

(defun get-gist-id (id-or-gist)
  (etypecase id-or-gist
    (string id-or-gist)
    (gist (gist-id id-or-gist))))

(defun list-gist-commits (id-or-gist)
  "List gist commits."
  (check-type id-or-gist (or string gist))
  (let* ((id (get-gist-id id-or-gist))
         (uri (uri (format nil "~a/gists/~a/commits" +api-base-uri+ id))))
    (make-histories (parse-json (get-request uri)))))

(defun star-gist (id-or-gist)
  "Star a gist."
  (check-type id-or-gist (or string gist))
  (check-credentials)
  (let* ((id (get-gist-id id-or-gist))
         (uri (uri (format nil "~a/gists/~a/star" +api-base-uri+ id))))
    (multiple-value-bind (body status) (put-request uri)
      (declare (ignore body))
      (when (= status 204)
        t))))

(defun unstar-gist (id-or-gist)
  "Unstar a gist."
  (check-type id-or-gist (or string gist))
  (check-credentials)
  (let* ((id (get-gist-id id-or-gist))
         (uri (uri (format nil "~a/gists/~a/star" +api-base-uri+ id))))
    (multiple-value-bind (body status) (delete-request uri)
      (declare (ignore body))
      (when (= status 204)
        t))))

(defun gist-starred-p (id-or-gist)
  "Check if a gist starred."
  (check-type id-or-gist (or string gist))
  (check-credentials)
  (let* ((id (get-gist-id id-or-gist))
         (uri (uri (format nil "~a/gists/~a/star" +api-base-uri+ id))))
    (multiple-value-bind (body status) (get-request uri :ignore-statuses (list 404))
      (declare (ignore body))
      (ecase status
        (204 t)
        (404 nil)))))

(defun fork-gist (id-or-gist)
  "Fork a gist."
  (check-type id-or-gist (or string gist))
  (check-credentials)
  (let* ((id (get-gist-id id-or-gist))
         (uri (uri (format nil "~a/gists/~a/forks" +api-base-uri+ id))))
    (apply #'make-gist (parse-json (post-request uri)))))

(defun list-gist-forks (id-or-gist)
  "List gist forks."
  (check-type id-or-gist (or string gist))
  (let* ((id (get-gist-id id-or-gist))
         (uri (uri (format nil "~a/gists/~a/forks" +api-base-uri+ id))))
    (make-gists (parse-json (get-request uri)))))

(defun delete-gist (id-or-gist)
  "Delete a gist."
  (check-type id-or-gist (or string gist))
  (check-credentials)
  (let* ((id (get-gist-id id-or-gist))
         (uri (uri (format nil "~a/gists/~a" +api-base-uri+ id))))
    (multiple-value-bind (body status) (delete-request uri)
      (declare (ignore body))
      (when (= status 204)
        t))))
