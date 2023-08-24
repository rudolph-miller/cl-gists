;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-USER -*-
;;; Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
;;; Copyright (c) 2023 by Symbolics Pte. Ltd. All rights reserved.
;;; SPDX-License-identifier: MS-PL

(uiop:define-package #:cl-gists.file
  (:use :cl
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

(defstruct (file (:constructor make-file (&key name size raw-url type truncated language content old-name
                                          &aux (old-name (or old-name name)))))
  "Structure of File."
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
