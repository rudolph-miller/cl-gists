(in-package :cl-user)
(defpackage cl-gists.util
  (:use :cl)
  (:import-from :local-time
                :format-timestring
                :+utc-zone+)
  (:import-from :quri
                :render-uri)
  (:import-from :babel
                :octets-to-string)
  (:export :format-timestring-for-api
           :request
           :get-request
           :post-request
           :patch-request
           :format-plist))
(in-package :cl-gists.util)

(defvar *raw-keyword* "raw_")

(defun format-timestring-for-api (timestamp)
  (format-timestring nil
                     timestamp
                     :format '(:year "-" (:month 2 #\0) "-" (:day 2 #\0) "T"
                               (:hour 2 #\0) ":" (:min 2 #\0) ":" (:sec 2 #\0) "Z")
                     :timezone +utc-zone+))

(defun request (uri &key method content)
  (multiple-value-bind (body status) (dex:request (render-uri uri) :method method :content content)
    (cond
      ((and (<= 200 status) (<= status 299))
       (if (typep body 'string)
           body
           (octets-to-string body :encoding :utf-8)))
      (t (error "Status is not 200."))))) ;; Taks: More precise error.

(defun get-request (uri)
  (request uri :method :get))

(defun post-request (uri &optional content)
  (request uri :method :post :content content))

(defun patche-request (uri &optional content)
  (request uri :method :patch :content content))

(defun format-plist (plist)
  (loop for (key value) on plist by #'cddr
        nconc (list (intern (string-upcase (symbol-name key)) :keyword)
                    value)))
