(in-package :cl-user)
(defpackage cl-gists.gist
  (:use :cl
        :annot.doc
        :annot.class
        :cl-gists.user
        :cl-gists.file)
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
@export-structure
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
  (updated-at nil :type (or null timestamp)))

@export
(defun make-gist (&key url forks-url commits-url id description public owner user files comments
                    comments-url html-url git-pull-url git-push-url created-at updated-at)
  (%make-gist :url url
              :forks-url forks-url
              :commits-url commits-url
              :id id
              :description description
              :public public
              :owner (apply #'make-user owner)
              :user user
              :files (mapcar #'(lambda (alist) (apply #'make-file alist)) files)
              :comments comments
              :comments-url comments-url
              :html-url html-url
              :git-pull-url git-pull-url
              :git-push-url git-push-url
              :created-at (parse-timestring created-at)
              :updated-at (parse-timestring updated-at)))

(defun lispify (string)
  (string-upcase (substitute #\- #\_ string)))

(defun format-keyword (keyword)
  (intern (lispify (symbol-name keyword)) :keyword))

(defun format-plist (plist)
  (loop for (key value) on plist by #'cddr
        nconc (list (format-keyword key) value)))

(defun format-file-plist (plist)
  (loop for (name value-plist) on plist by #'cddr
        collecting (append (list :name (symbol-name name))
                           (format-plist value-plist))))

(defun format-gist-plist (plist)
  (append (list :files (format-file-plist (getf plist :files))
                :owner (format-plist (getf plist :owner)))
          (remove-from-plist plist :files :owner)))

@export
(defun make-gist-from-json (json)
  (apply #'make-gist (format-gist-plist (parse json :keyword-normalizer #'lispify))))

@export
(defun make-gists-from-json (json)
  (mapcar #'(lambda (plist) (apply #'make-gist (format-gist-plist plist)))
          (parse json :keyword-normalizer #'lispify)))
    
