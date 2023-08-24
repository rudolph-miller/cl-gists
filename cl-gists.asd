;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: ASDF -*-
;;; Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
;;; Copyright (c) 2021-2023 by Symbolics Pte. Ltd. All rights reserved.
;;; SPDX-License-identifier: MS-PL

(defsystem "cl-gists"
  :version "0.2.0"
  :author "Rudolph Miller"
  :maintainer "Steve Nunez"
  :license "MIT"
  :homepage "https://github.com/Rudolph-Miller/cl-gists"
  :depends-on (;"cl-syntax"
               ;"cl-syntax-annot"
               "alexandria"
               "local-time"
               "trivial-types"
               "quri"
               "dexador"
               "babel"
               "jonathan"
               "uiop")
  :components ((:module "src"
                :serial t
                :components
                ((:file "util")
                 (:file "user")
                 (:file "file")
                 (:file "fork")
                 (:file "history")
                 (:file "gist")
                 (:file "api")
                 (:file "cl-gists"))))
  :description "Gists API Wrapper for Common Lisp."
  ;;:long-description #.(read-file-string (subpathname *load-pathname "description.text"))
  :in-order-to ((test-op (test-op "cl-gists-test"))))
