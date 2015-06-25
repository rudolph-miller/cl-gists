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
           :file-old-name
           :make-file
           :make-files))
(in-package :cl-gists.file)

(syntax:use-syntax :annot)

@doc
"Structure of File."
(defstruct (file (:constructor make-file (&key name size raw-url type truncated language content old-name
                                          &aux (old-name (or old-name name)))))
  (name nil :type (or null string))
  (size nil :type (or null integer))
  (raw-url nil :type (or null string))
  (type nil :type (or null string))
  (truncated nil :type boolean)
  (language nil :type (or null string))
  (content nil :type (or null string))
  (old-name nil :type (or null string) :read-only t))

(defun make-files (list)
  (mapcar #'(lambda (plist) (apply #'make-file plist)) list))
