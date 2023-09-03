;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: ASDF -*-
;;; Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
;;; Copyright (c) 2023 by Symbolics Pte. Ltd. All rights reserved.
;;; SPDX-License-identifier: MS-PL

(defsystem #:cl-gists
  :version "0.2.1"
  :author "Rudolph Miller"
  :maintainer "Steve Nunez"
  :license :MS-PL
  :homepage "https://github.com/Symbolics/cl-gists"
  :depends-on ("alexandria"
	       "alexandria+"
               "local-time"
               "quri"
               "dexador"
               "babel"
               "yason")
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
                 (:file "pkgdcl"))))
  :description "Gists API Wrapper for Common Lisp."
  ;;:long-description #.(read-file-string (subpathname *load-pathname "description.text"))
  :in-order-to ((test-op (test-op "cl-gists/test"))))

(defsystem #:cl-gists/test
  :author "Rudolph Miller"
  :maintainer "Steve Nunez"
  :license "MIT"
  :homepage "https://github.com/Symbolics/cl-gists"
  :depends-on ("cl-gists"
	       "clunit2"
               "closer-mop")
  :components ((:module "t"		;'t' = 'tests'
                :components ((:file "pkgdcl")
			     (:file "suite")
			     (:file "init")
			     (:file "util")
			     (:file "user")
			     (:file "file")
			     (:file "fork")
			     (:file "history")
			     (:file "gist")
			     (:file "api"))))
  :description "Test system for cl-gists."
  :perform (test-op (o s)
		    (let ((*print-pretty* t)) ;work around clunit issue #9
		      (symbol-call :clunit :run-suite
				   (find-symbol* :gists
						 :cl-gists-test)
					   :use-debugger nil))))
