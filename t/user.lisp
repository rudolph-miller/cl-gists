;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-GISTS-TEST -*-
;;; Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
;;; Copyright (c) 2021-2023 by Symbolics Pte. Ltd. All rights reserved.
;;; SPDX-License-identifier: MS-PL

(in-package #:cl-gists-test)

(defsuite user (gists))

(deftest make-user (user)
  (let ((test-user (make-user :login "octocat"
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
    (test-user test-user)))
