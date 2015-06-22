(in-package :cl-user)
(defpackage cl-gists.fork
  (:use :cl
        :annot.doc
        :cl-gists.user)
  (:import-from :local-time
                :timestamp
                :parse-timestring)
  (:export :fork
           :fork-user
           :fork-url
           :fork-id
           :fork-created-at
           :fork-updated-at
           :make-fork
           :make-forks))
(in-package :cl-gists.fork)

(syntax:use-syntax :annot)

@doc
"Structure of Fork."
(defstruct (fork (:constructor %make-fork))
  (user nil :type (or null user))
  (url nil :type (or null string))
  (id nil :type (or null string))
  (created-at nil :type (or null timestamp))
  (updated-at nil :type (or null timestamp)))

(defun make-fork (&key user url id created-at updated-at)
  (%make-fork :user (apply #'make-user user)
              :url url
              :id id
              :created-at (parse-timestring created-at)
              :updated-at (parse-timestring updated-at)))

(defun make-forks (list)
  (mapcar #'(lambda (plist) (apply #'make-fork plist)) list))
