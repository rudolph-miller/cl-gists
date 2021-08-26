(in-package :cl-user)
(defpackage cl-gists.user
  (:use :cl
        :annot.doc)
  (:export :cl-gists.user
           :user
           :user-login
           :user-id
           :user-avatar-url
           :user-url
           :user-html-url
           :user-followers-url
           :user-following-url
           :user-gists-url
           :user-starred-url
           :user-subscriptions-url
           :user-organizations-url
           :user-repos-url
           :user-events-url
           :user-received-events-url
           :user-type
           :user-site-admin
           :make-user))
(in-package :cl-gists.user)

(syntax:use-syntax :annot)

@doc
"Structure of User."
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
  (site-admin nil :type boolean)
  (node-id nil :type (or null string)))
