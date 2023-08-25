;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-USER -*-
;;; Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
;;; Copyright (c) 2023 by Symbolics Pte. Ltd. All rights reserved.
;;; SPDX-License-identifier: MS-PL

(uiop:define-package #:cl-gists.util
  (:use :cl)
  (:import-from :uiop
                :getenv)
  (:import-from #:alexandria
		#:remove-from-plist
		#:make-keyword)
  (:import-from :local-time
                :format-timestring
                :+utc-zone+)
  (:import-from :quri
                :render-uri)
  (:import-from :babel
                :octets-to-string)
  (:import-from #:alexandria+ #:plistp)
  (:import-from :yason
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

(defvar *raw-keyword* "raw_")

(defvar *credentials* nil
  "Global variable of credentials.")

(defvar *github-username-env-var* "GITHUB_USERNAME"
  "Environment variable for a username of GitHub.")

(defvar *github-password-env-var* "GITHUB_PASSWORD"
  "Environment variable for a password of GitHub.")

(defvar *github-oauth-token-env-var* "GITHUB_OAUTH_TOKEN"
  "Environment variable for a OAuth token of GitHub."  )

(defgeneric username (credentials)
  (:documentation "Return the username.")
  (:method ((credentials t))
    (declare (ignore credentials))
    (getenv *github-username-env-var*)))

(defgeneric password (credentials)
  (:documentation "Return the password.")
  (:method ((credentials t))
    (declare (ignore credentials))
    (getenv *github-password-env-var*)))

(defgeneric oauth-token (credentials)
  (:documentation "Return the OAuth token.")
  (:method ((credentials t))
    (declare (ignore credentials))
    (getenv *github-oauth-token-env-var*)))

(defun format-timestring-for-api (timestamp)
  (format-timestring nil
                     timestamp
                     :format '(:year "-" (:month 2 #\0) "-" (:day 2 #\0) "T"
                               (:hour 2 #\0) ":" (:min 2 #\0) ":" (:sec 2 #\0) "Z")
                     :timezone +utc-zone+))

(defun request (uri &key method content ignore-statuses (credentials *credentials*))
  (multiple-value-bind (body status response-headers)
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
        ((<= 200 status 299)
         (values string-body status response-headers))
        (t (if (and ignore-statuses (member status ignore-statuses))
               (values string-body status response-headers)
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
	   (unless (string= key "FILES")
             (make-keyword (string-upcase (substitute #\- #\_ key)))))
         (format-files (plist)
           (when (getf plist :files)
             (setf (getf plist :files)
                   (loop for (name value-plist) on (getf plist :files) by #'cddr
                         for filename = (or (getf value-plist :filename) name)
                         collecting (append (list :name filename)
                                            (remove-from-plist value-plist :filename)))))
           plist))
    (let* ((parsed (parse json :object-as :plist :object-key-fn #'lispify)))
      (if (property-list-p parsed)
          (format-files parsed)
          (mapcar #'format-files parsed)))))

