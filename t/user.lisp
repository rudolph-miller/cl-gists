(in-package :cl-user)
(defpackage cl-gists-test.user
  (:use :cl
        :prove
        :cl-gists-test.init
        :cl-gists))
(in-package :cl-gists-test.user)

(plan nil)

(subtest "user"
  (let ((user (make-user :login "octocat"
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
                         :site-admin nil)))
    (is-type user
             'user
             "can make-user.")

    (test-user user)))

(finalize)
