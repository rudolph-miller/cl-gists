;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-USER -*-
;;; Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
;;; Copyright (c) 2023 by Symbolics Pte. Ltd. All rights reserved.
;;; SPDX-License-identifier: MS-PL

(uiop:define-package #:cl-gists.gist
  (:use :cl
        :cl-gists.util
        :cl-gists.user
        :cl-gists.file
        :cl-gists.fork
        :cl-gists.history)
  (:import-from :local-time
                :timestamp
                :parse-timestring)
  (:export :cl-gists.gist
           :gist
           :gist-url
           :gist-forks-url
           :gist-commits-url
           :gist-id
           :gist-description
           :gist-public
           :gist-owner
           :gist-fork-of
           :gist-user
           :gist-files
           :gist-comments
           :gist-comments-url
           :gist-html-url
           :gist-git-pull-url
           :gist-git-push-url
           :gist-created-at
           :gist-updated-at
           :gist-forks
           :gist-history
           :make-gist
           :make-gists))
(in-package :cl-gists.gist)


(defstruct (gist (:constructor %make-gist))
  "Structure of Gist"
  (url nil :type (or null string))
  (forks-url nil :type (or null string))
  (commits-url nil :type (or null string))
  (id nil :type (or null string))
  (description nil :type (or null string))
  (public nil :type boolean)
  (owner nil :type (or null user))
  (fork-of nil :type (or null gist))
  (user nil) ;; Not sure what kind of object.
  (files nil :type list) ;; List of file.
  (comments nil :type (or null integer))
  (comments-url nil :type (or null string))
  (html-url nil :type (or null string))
  (git-pull-url nil :type (or null string))
  (git-push-url nil :type (or null string))
  (created-at nil :type (or null timestamp))
  (updated-at nil :type (or null timestamp))
  (forks nil :type list)
  (history nil :type list)
  (truncated nil :type boolean)
  (node-id nil :type (or null string)))

(defun make-gist (&key url forks-url commits-url id description public owner fork-of user files comments
                    comments-url html-url git-pull-url git-push-url created-at updated-at forks history truncated
		    node-id)
  (%make-gist :url url
              :forks-url forks-url
              :commits-url commits-url
              :id id
              :description description
              :public public
              :owner (apply #'make-user owner)
              :fork-of (when fork-of (apply #'make-gist fork-of))
              :user user
              :files (make-files files)
              :comments comments
              :comments-url comments-url
              :html-url html-url
              :git-pull-url git-pull-url
              :git-push-url git-push-url
              :created-at (and created-at (parse-timestring created-at))
              :updated-at (and updated-at (parse-timestring updated-at))
              :forks (make-forks forks)
              :history (make-histories history)
              :truncated truncated
	      :node-id node-id))

(defun make-gists (list)
  (mapcar #'(lambda (plist) (apply #'make-gist plist)) list))
