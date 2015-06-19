(in-package :cl-user)
(defpackage cl-gists.file
  (:use :cl
        :annot.doc)
  (:export :cl-gists.file
           :file
           :file-name
           :file-size
           :file-raw-url
           :file-type
           :file-truncated
           :file-language
           :make-file))
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
  (language nil :type (or null string)))
