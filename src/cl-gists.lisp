;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-USER -*-
;;; Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
;;; Copyright (c) 2023 by Symbolics Pte. Ltd. All rights reserved.
;;; SPDX-License-identifier: MS-PL

(uiop:define-package #:cl-gists
  (:use :cl)
  (:nicknames :gists)
  (:import-from :cl-gists.util
                :*credentials*
                :*github-username-env-var*
                :*github-password-env-var*
                :*github-oauth-token-env-var*
                :username
                :password
                :oauth-token)
  (:import-from :cl-gists.user
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
                :user-site-admin)
  (:import-from :cl-gists.file
                :file
                :file-name
                :file-size
                :file-raw-url
                :file-type
                :file-truncated
                :file-language
                :file-content
                :file-old-name
                :make-file)
  (:import-from :cl-gists.fork
                :fork
                :fork-user
                :fork-url
                :fork-id
                :fork-created-at
                :fork-updated-at)
  (:import-from :cl-gists.history
                :history
                :history-url
                :history-version
                :history-user
                :history-deletions
                :history-additions
                :history-total
                :history-committed-at)
  (:import-from :cl-gists.gist
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
                :make-gist)
  (:import-from :cl-gists.api
                :list-gists
                :get-gist
                :create-gist
                :edit-gist
                :list-gist-commits
                :star-gist
                :unstar-gist
                :gist-starred-p
                :fork-gist
                :list-gist-forks
                :delete-gist)
  (:export ;; util
           :*credentials*
           :*github-username-env-var*
           :*github-password-env-var*
           :*github-oauth-token-env-var*
           :username
           :password
           :oauth-token

           ;; user
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

           ;; file
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

           ;; fork
           :fork
           :fork-user
           :fork-url
           :fork-id
           :fork-created-at
           :fork-updated-at

           ;; history
           :history
           :history-url
           :history-version
           :history-user
           :history-deletions
           :history-additions
           :history-total
           :history-committed-at

           ;; gist
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

           ;; api
           :list-gists
           :get-gist
           :create-gist
           :edit-gist
           :list-gist-commits
           :star-gist
           :unstar-gist
           :gist-starred-p
           :fork-gist
           :list-gist-forks
           :delete-gist))
(in-package :cl-gists)
