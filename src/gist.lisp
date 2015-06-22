(in-package :cl-user)
(defpackage cl-gists.gist
  (:use :cl
        :annot.doc
        :cl-gists.util
        :cl-gists.user
        :cl-gists.file
        :cl-gists.fork
        :cl-gists.history)
  (:export :cl-gists.gist
           :gist
           :gist-url
           :gist-forks-url
           :gist-commits-url
           :gist-id
           :gist-description
           :gist-public
           :gist-owner
           :gist-user
           :gist-files
           :gist-comments
           :gist-comments-url
           :gist-html-url
           :gist-git-pull-url
           :gist-git-push-url
           :gist-created-at
           :gist-updated-at
           :gist-forks
           :gist-history
           :make-gist
           :make-gist-from-json
           :make-gists-from-json)
  (:import-from :alexandria
                :remove-from-plist)
  (:import-from :local-time
                :timestamp
                :parse-timestring)
  (:import-from :jonathan
                :parse))
(in-package :cl-gists.gist)

(syntax:use-syntax :annot)

@doc
"Structure of Gist"
(defstruct (gist (:constructor %make-gist))
  (url nil :type (or null string))
  (forks-url nil :type (or null string))
  (commits-url nil :type (or null string))
  (id nil :type (or null string))
  (description nil :type (or null string))
  (public nil :type boolean)
  (owner nil :type (or null user))
  (user nil) ;; Not sure what kind of object.
  (files nil :type list) ;; List of file.
  (comments 0 :type integer)
  (comments-url nil :type (or null string))
  (html-url nil :type (or null string))
  (git-pull-url nil :type (or null string))
  (git-push-url nil :type (or null string))
  (created-at nil :type (or null timestamp))
  (updated-at nil :type (or null timestamp))
  (forks nil :type list)
  (history nil :type list))

(defun make-gist (&key url forks-url commits-url id description public owner user files comments
                    comments-url html-url git-pull-url git-push-url created-at updated-at forks history)
  (%make-gist :url url
              :forks-url forks-url
              :commits-url commits-url
              :id id
              :description description
              :public public
              :owner (apply #'make-user owner)
              :user user
              :files (make-files files)
              :comments comments
              :comments-url comments-url
              :html-url html-url
              :git-pull-url git-pull-url
              :git-push-url git-push-url
              :created-at (parse-timestring created-at)
              :updated-at (parse-timestring updated-at)
              :forks (make-forks forks)
              :history (make-histories history)))

(defun parse-gist (json)
  (flet ((lispify (key)
           (string-upcase (substitute #\- #\_ key))))
    (parse json
           :keyword-normalizer #'lispify
           :normalize-all t
           :exclude-normalize-keys '("FILES"))))
@export
(defun make-gist-from-json (json)
  (apply #'make-gist (parse-gist json)))

@export
(defun make-gists-from-json (json)
  (mapcar #'(lambda (plist) (apply #'make-gist plist)) (parse-gist json)))
