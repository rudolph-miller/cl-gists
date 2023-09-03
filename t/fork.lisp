;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-GISTS-TEST -*-
;;; Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
;;; Copyright (c) 2021-2023 by Symbolics Pte. Ltd. All rights reserved.
;;; SPDX-License-identifier: MS-PL

(in-package #:cl-gists-test)

(defsuite fork (gists))

(defvar *forks-json-string*
  "[{
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
     \"url\": \"https://api.github.com/gists/dee9c42e4998ce2ea439\",
     \"id\": \"dee9c42e4998ce2ea439\",
     \"created_at\": \"2011-04-14T16:00:49Z\",
     \"updated_at\": \"2011-04-14T16:00:49Z\"
   }]")

(deftest make-fork (fork)
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

    ;; Why is the return type being tested?  What else could be returned from make-fork?
    (assert-true (typep fork 'fork)
      "Can make-fork.")
    (test-fork fork)))

(deftest make-forks (fork)
  (let ((fork (car (make-forks (parse-json *forks-json-string*)))))
    (assert-true (typep fork 'fork)
      "Can make-forks.")
    (test-fork fork)))
