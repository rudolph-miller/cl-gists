(in-package :cl-user)
(defpackage cl-gists.file
  (:use :cl
        :annot.doc
        :cl-gists.util)
  (:import-from :alexandria
                :remove-from-plist)
  (:export :cl-gists.file
           :file
           :file-name
           :file-size
           :file-raw-url
           :file-type
           :file-truncated
           :file-language
           :file-content
           :make-file
           :make-files))
(in-package :cl-gists.file)

(syntax:use-syntax :annot)

@doc
"Structure of File."
(defstruct file
  (name nil :type (or null string))
  (size 0 :type integer)
  (raw-url nil :type (or null string))
  (type nil :type (or null string))
  (truncated nil :type boolean)
  (language nil :type (or null string))
  (content nil :type (or null string)))

(defun make-files (files)
  (loop for (name plist) on files by #'cddr
        for formatted-plist = (format-plist plist)
        for filename = (or (getf formatted-plist :filename) (symbol-name name))
        collecting (apply #'make-file (append (list :name filename)
                                              (remove-from-plist formatted-plist :filename)))))
