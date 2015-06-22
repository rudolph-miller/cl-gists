(in-package :cl-user)
(defpackage cl-gists.history
  (:use :cl
        :annot.doc
        :cl-gists.user)
  (:import-from :local-time
                :timestamp
                :parse-timestring)
  (:import-from :alexandria
                :remove-from-plist)
  (:export :history
           :history-url
           :history-version
           :history-user
           :history-deletions
           :history-additions
           :history-total
           :history-committed-at
           :make-history
           :make-histories))
(in-package :cl-gists.history)

(syntax:use-syntax :annot)

@doc
"Structure of History."
(defstruct (history (:constructor %make-history))
  (url nil :type (or null string))
  (version nil :type (or null string))
  (user nil :type (or null user))
  (deletions 0 :type (or null integer))
  (additions 0 :type (or null integer))
  (total 0 :type (or null integer))
  (committed-at nil :type (or null timestamp)))

(defun make-history (&key url version user deletions additions total committed-at)
  (%make-history :url url
                 :version version
                 :user (apply #'make-user user)
                 :deletions deletions
                 :additions additions
                 :total total
                 :committed-at (parse-timestring committed-at)))

(defun make-histories (list)
  (flet ((format-plist-for-history (plist)
           (let ((change-status (getf plist :change-status)))
             (append change-status
                     (remove-from-plist plist :change-status)))))
    (mapcar #'(lambda (plist) (apply #'make-history (format-plist-for-history plist)))
            list)))
