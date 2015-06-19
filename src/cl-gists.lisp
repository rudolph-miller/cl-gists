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
                :file-language)
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
                :gist-updated-at)
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
           :gist-updated-at))
(in-package :cl-gists)
