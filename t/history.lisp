(in-package :cl-user)
(defpackage cl-gists-test.history
  (:use :cl
        :prove
        :cl-gists-test.init
        :cl-gists)
  (:import-from :cl-gists.util
                :parse-json)
  (:import-from :cl-gists.history
                :make-history
                :make-histories))
(in-package :cl-gists-test.history)

(plan nil)

(defvar *histories-json-string*
  "[{
        \"url\": \"https://api.github.com/gists/aa5a315d61ae9438b18d/57a7f021a713b1c5a6a199b54cc514735d2d462f\",
        \"version\": \"57a7f021a713b1c5a6a199b54cc514735d2d462f\",
        \"user\": {
        \"login\": \"octocat\",
        \"id\": 1,
        \"avatar_url\": \"https://github.com/images/error/octocat_happy.gif\",
        \"gravatar_id\": \"\",
        \"url\": \"https://api.github.com/users/octocat\",
        \"html_url\": \"https://github.com/octocat\",
        \"followers_url\": \"https://api.github.com/users/octocat/followers\",
        \"following_url\": \"https://api.github.com/users/octocat/following{/other_user}\",
        \"gists_url\": \"https://api.github.com/users/octocat/gists{/gist_id}\",
        \"starred_url\": \"https://api.github.com/users/octocat/starred{/owner}{/repo}\",
        \"subscriptions_url\": \"https://api.github.com/users/octocat/subscriptions\",
        \"organizations_url\": \"https://api.github.com/users/octocat/orgs\",
        \"repos_url\": \"https://api.github.com/users/octocat/repos\",
        \"events_url\": \"https://api.github.com/users/octocat/events{/privacy}\",
        \"received_events_url\": \"https://api.github.com/users/octocat/received_events\",
        \"type\": \"User\",
        \"site_admin\": false
        },
        \"change_status\": {
        \"deletions\": 0,
        \"additions\": 180,
        \"total\": 180
        },
        \"committed_at\": \"2010-04-14T02:15:15Z\"
    }]")

(subtest "history"
  (let ((history (make-history :url "https://api.github.com/gists/aa5a315d61ae9438b18d/57a7f021a713b1c5a6a199b54cc514735d2d462f"
                               :version "57a7f021a713b1c5a6a199b54cc514735d2d462f"
                               :user '(:login "octocat"
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
                               :deletions 0
                               :additions 180
                               :total 180
                               :committed-at "2010-04-14T02:15:15Z")))
    (is-type history
             'history
             "can make-history.")

    (test-history history)))

(subtest "make-histories"
  (let ((history (car (make-histories (parse-json *histories-json-string*)))))
    (is-type history
             'history
             "can make-histories.")

    (test-history history)))

(finalize)
