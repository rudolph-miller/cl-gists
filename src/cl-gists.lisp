(in-package :cl-user)
(defpackage cl-gists
  (:use :cl)
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
                :file-content)
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
                :create-gist)
  (:export ;; user
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
           :create-gist))
(in-package :cl-gists)
