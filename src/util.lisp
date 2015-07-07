(in-package :cl-user)
(defpackage cl-gists.util
  (:use :cl
        :annot.doc)
  (:import-from :osicat
                :environment-variable)
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
  (:export :*credentials*
           :*github-username-env-var*
           :*github-password-env-var*
           :*github-oauth-token-env-var*
           :username
           :password
           :oauth-token
           :format-timestring-for-api
           :request
           :get-request
           :post-request
           :put-request
           :delete-request
           :patch-request
           :parse-json))
(in-package :cl-gists.util)

(syntax:use-syntax :annot)

(defvar *raw-keyword* "raw_")

@doc
"Global variable of credentials."
(defvar *credentials* nil)

@doc
"Environment variable for a username of GitHub."
(defvar *github-username-env-var* "GITHUB_USERNAME")

@doc
"Environment variable for a password of GitHub."
(defvar *github-password-env-var* "GITHUB_PASSWORD")

@doc
"Environment variable for a OAuth token of GitHub."
(defvar *github-oauth-token-env-var* "GITHUB_OAUTH_TOKEN")

@doc
"Return the username."
(defgeneric username (credentials)
  (:method ((credentials t))
    (declare (ignore credentials))
    (environment-variable *github-username-env-var*)))

@doc
"Return the password."
(defgeneric password (credentials)
  (:method ((credentials t))
    (declare (ignore credentials))
    (environment-variable *github-password-env-var*)))

@doc
"Return the OAuth token."
(defgeneric oauth-token (credentials)
  (:method ((credentials t))
    (declare (ignore credentials))
    (environment-variable *github-oauth-token-env-var*)))

(defun format-timestring-for-api (timestamp)
  (format-timestring nil
                     timestamp
                     :format '(:year "-" (:month 2 #\0) "-" (:day 2 #\0) "T"
                               (:hour 2 #\0) ":" (:min 2 #\0) ":" (:sec 2 #\0) "Z")
                     :timezone +utc-zone+))

(defun request (uri &key method content ignore-statuses (credentials *credentials*))
  (multiple-value-bind (body status)
      (handler-bind ((dex:http-request-failed (lambda (c)
                                                (declare (ignore c))
                                                (invoke-restart 'dex:ignore-and-continue))))
        (dex:request (render-uri uri)
                     :method method
                     :content content
                     :headers (when (oauth-token credentials)
                                `(("Authorization" . ,(format nil "token ~a"
                                                              (oauth-token credentials)))))
                     :basic-auth (when (and (not (oauth-token credentials))
                                            (username credentials)
                                            (password credentials))
                                   (cons (username credentials)
                                         (password credentials)))))
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

(defun get-request (uri &key ignore-statuses)
  (request uri :method :get :ignore-statuses ignore-statuses))

(defun post-request (uri &key content)
  (request uri :method :post :content content))

(defun put-request (uri &key content)
  (request uri :method :put :content content))

(defun delete-request (uri &key content)
  (request uri :method :delete :content content))

(defun patch-request (uri &key content)
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
