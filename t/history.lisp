;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-GISTS-TEST -*-
;;; Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
;;; Copyright (c) 2021-2023 by Symbolics Pte. Ltd. All rights reserved.
;;; SPDX-License-identifier: MS-PL

(in-package #:cl-gists-test)

(defsuite history (gists))

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

(deftest make-history (history)
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

    (assert-true (typep history 'history)
      "Can make-history.")
    (test-history history)))

(deftest make-histories (history)
  (let ((history (car (make-histories (parse-json *histories-json-string*)))))
    (assert-true (typep history 'history)
      "Can make-histories.")
    (test-history history)))

