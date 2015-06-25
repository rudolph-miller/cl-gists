(in-package :cl-user)
(defpackage cl-gists.util
  (:use :cl)
  (:import-from :alexandria
                :remove-from-plist)
  (:import-from :local-time
                :format-timestring
                :+utc-zone+)
  (:import-from :quri
                :render-uri)
  (:import-from :babel
                :octets-to-string)
  (:import-from :trivial-types
                :property-list-p)
  (:import-from :jonathan
                :parse)
  (:export :format-timestring-for-api
           :request
           :get-request
           :post-request
           :put-request
           :delete-request
           :patch-request
           :parse-json))
(in-package :cl-gists.util)

(defvar *raw-keyword* "raw_")

(defun format-timestring-for-api (timestamp)
  (format-timestring nil
                     timestamp
                     :format '(:year "-" (:month 2 #\0) "-" (:day 2 #\0) "T"
                               (:hour 2 #\0) ":" (:min 2 #\0) ":" (:sec 2 #\0) "Z")
                     :timezone +utc-zone+))

(defun request (uri &key method content ignore-statuses basic-auth)
  (multiple-value-bind (body status) (dex:request (render-uri uri) :method method
                                                                   :content content
                                                                   :basic-auth basic-auth)
    (let ((string-body  (if (typep body 'string)
                            body
                            (octets-to-string body :encoding :utf-8))))
      (cond
        ((and (<= 200 status) (<= status 299))
         (values string-body status))
        (t (if (and ignore-statuses (member status ignore-statuses))
               (values string-body status)
               (error "URI: ~a~%Method: ~a~%Content: ~a~%Status: ~a~%Message: ~a~%"
                      uri
                      method
                      content
                      status
                      string-body)))))))

(defun get-request (uri &key ignore-statuses basic-auth)
  (request uri :method :get :ignore-statuses ignore-statuses))

(defun post-request (uri &key content basic-auth)
  (request uri :method :post :content content))

(defun put-request (uri &key content basic-auth)
  (request uri :method :put :content content))

(defun delete-request (uri &key content basic-auth)
  (request uri :method :delete :content content))

(defun patch-request (uri &key content basic-auth)
  (request uri :method :patch :content content))

(defun parse-json (json)
  (flet ((lispify (key)
           (string-upcase (substitute #\- #\_ key)))
         (format-files (plist)
           (when (getf plist :files)
             (setf (getf plist :files)
                   (loop for (name value-plist) on (getf plist :files) by #'cddr
                         for filename = (or (getf value-plist :filename) name)
                         collecting (append (list :name filename)
                                            (remove-from-plist value-plist :filename)))))
           plist))
    (let ((parsed (parse json
                         :keyword-normalizer #'lispify
                         :normalize-all t
                         :exclude-normalize-keys '("FILES"))))
      (if (property-list-p parsed)
          (format-files parsed)
          (mapcar #'format-files parsed)))))
