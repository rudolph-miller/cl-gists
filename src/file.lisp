(in-package :cl-user)
(defpackage cl-gists.file
  (:use :cl
        :annot.doc
        :annot.class))
(in-package :cl-gists.file)

(syntax:use-syntax :annot)

@doc
"Structure of File."
@export-structure
(defstruct file
  (name nil :type (or null string))
  (size 0 :type integer)
  (raw-url nil :type (or null string))
  (type nil :type (or null string))
  (truncated nil :type boolean)
  (language nil :type (or null string)))
