;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: ASDF -*-
;;; Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
;;; Copyright (c) 2021-2023 by Symbolics Pte. Ltd. All rights reserved.
;;; SPDX-License-identifier: MS-PL

(defsystem "cl-gists-test"
  :author "Rudolph Miller"
  :maintainer "Steve Nunez"
  :license "MIT"
  :homepage "https://github.com/Rudolph-Miller/cl-gists"
  :depends-on ("cl-gists"
               "prove"
               "closer-mop")
  :components ((:module "t"
                :components
                ((:file "init")
                 (:test-file "util")
                 (:test-file "user")
                 (:test-file "file")
                 (:test-file "fork")
                 (:test-file "history")
                 (:test-file "gist")
                 (:test-file "api")
                 (:test-file "cl-gists"))))
  :description "Test system for cl-gists."

  :defsystem-depends-on ("prove-asdf")
  :perform (test-op (o c) (symbol-call :prove-asdf :run-test-system c)))
