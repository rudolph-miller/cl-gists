(in-package :cl-user)
(defpackage cl-gists-test.fork
  (:use :cl
        :prove
        :cl-gists-test.init
        :cl-gists)
  (:import-from :cl-gists.fork
                :make-fork
                :make-forks))
(in-package :cl-gists-test.fork)

(plan nil)

(subtest "fork"
  (let ((fork (make-fork :user '(:login "octocat"
                                 :id 1
                                 :avatar-url "https://github.com/images/error/octocat_happy.gif"
                                 :gravatar-id "abc"
                                 :url "https://api.github.com/users/octocat"
                                 :html-url "https://github.com/octocat"
                                 :followers-url "https://api.github.com/users/octocat/followers"
                                 :following-url "https://api.github.com/users/octocat/following{/other_user}"
                                 :gists-url "https://api.github.com/users/octocat/gists{/gist_id}"
                                 :starred-url "https://api.github.com/users/octocat/starred{/owner}{/repo}"
                                 :subscriptions-url "https://api.github.com/users/octocat/subscriptions"
                                 :organizations-url "https://api.github.com/users/octocat/orgs"
                                 :repos-url "https://api.github.com/users/octocat/repos"
                                 :events-url "https://api.github.com/users/octocat/events{/privacy}"
                                 :received-events-url "https://api.github.com/users/octocat/received_events"
                                 :type "User"
                                 :site-admin nil)
                         :url "https://api.github.com/gists/dee9c42e4998ce2ea439"
                         :id "dee9c42e4998ce2ea439"
                         :created-at "2010-04-14T02:15:15Z"
                         :updated-at "2011-06-20T11:34:15Z")))
    (is-type fork
             'fork
             "can make-fork.")

    (test-fork fork)))

(subtest "make-forks"
  (let ((fork (car (make-forks '((:user (:login "octocat"
                                         :id 1
                                         :avatar-url "https://github.com/images/error/octocat_happy.gif"
                                         :gravatar-id "abc"
                                         :url "https://api.github.com/users/octocat"
                                         :html-url "https://github.com/octocat"
                                         :followers-url "https://api.github.com/users/octocat/followers"
                                         :following-url "https://api.github.com/users/octocat/following{/other_user}"
                                         :gists-url "https://api.github.com/users/octocat/gists{/gist_id}"
                                         :starred-url "https://api.github.com/users/octocat/starred{/owner}{/repo}"
                                         :subscriptions-url "https://api.github.com/users/octocat/subscriptions"
                                         :organizations-url "https://api.github.com/users/octocat/orgs"
                                         :repos-url "https://api.github.com/users/octocat/repos"
                                         :events-url "https://api.github.com/users/octocat/events{/privacy}"
                                         :received-events-url "https://api.github.com/users/octocat/received_events"
                                         :type "User"
                                         :site-admin nil)
                                  :url "https://api.github.com/gists/dee9c42e4998ce2ea439"
                                  :id "dee9c42e4998ce2ea439"
                                  :created-at "2010-04-14T02:15:15Z"
                                  :updated-at "2011-06-20T11:34:15Z"))))))
    (is-type fork
             'fork
             "can make-forks.")

    (test-fork fork)))

(finalize)
