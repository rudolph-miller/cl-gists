(in-package :cl-user)
(defpackage cl-gists.user
  (:use :cl
        :annot.doc
        :annot.class))
(in-package :cl-gists.user)

(syntax:use-syntax :annot)

@doc
"Structure of User."
@export-structure
(defstruct user
  (login nil :type (or null string))
  (id nil :type (or null integer))
  (avatar-url nil :type (or null string))
  (gravatar-id nil :type (or null string))
  (url nil :type (or null string))
  (html-url nil :type (or null string))
  (followers-url nil :type (or null string))
  (following-url nil :type (or null string))
  (gists-url nil :type (or null string))
  (starred-url nil :type (or null string))
  (subscriptions-url nil :type (or null string))
  (organizations-url nil :type (or null string))
  (repos-url nil :type (or null string))
  (events-url nil :type (or null string))
  (received-events-url nil :type (or null string))
  (type nil :type (or null string))
  (site-admin nil :type boolean))
