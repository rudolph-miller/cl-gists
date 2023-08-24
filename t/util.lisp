;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-GIST-TEST -*-
;;; Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
;;; Copyright (c) 2021-2023 by Symbolics Pte. Ltd. All rights reserved.
;;; SPDX-License-identifier: MS-PL

(in-package #:cl-gists-test)

(defsuite util (gists))

(deftest format-timestring-for-api (util)
  (assert-true (string= (format-timestring-for-api (mytoday))
			"2014-12-31T12:00:00Z")
    "Can format timestamp."))

(deftest request (util)

  ;; The following two tests are certain to fail on MS Windows.
  ;; LS-USER> (type-of (dex:request (quri:uri "https://google.co.jp") :method :get))
  ;; (SIMPLE-ARRAY CHARACTER (19576))
  ;; LS-USER> (type-of (dex:request (quri:uri "https://api.github.com") :method :get))
  ;; (SIMPLE-ARRAY CHARACTER (2262))
  ;; LS-USER> (stringp *)
  ;; NIL
  ;; I have left them here because they were in the original tests.

  #-win32
  (assert-true (typep (type-of (request (uri "https://google.co.jp") :method :get)) 'string)
    "String returned from HTTP request")
  #-win32
  (assert-true (typep (type-of (request (uri "https://api.github.com") :method :get)) 'string)
    "Octets returned from HTTP request")

  (assert-condition error (request (uri "https://api.github.com1") :method :get)
    "Error because host not found."))

