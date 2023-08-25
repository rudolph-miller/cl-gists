;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-GISTS-TEST -*-
;;; Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
;;; Copyright (c) 2021-2023 by Symbolics Pte. Ltd. All rights reserved.
;;; SPDX-License-identifier: MS-PL

(in-package #:cl-gists-test)

(defsuite file (gists))

(deftest make-file (file)
  (let ((file (make-file :name "sample.lisp"
                         :size 500
                         :raw-url "https://gist.githubusercontent.com/anonymous/abcde/sample.lisp"
                         :language "Common Lisp"
                         :type "text/plain"
                         :truncated nil
                         :content "Sample text.")))
    (test-file file)))			;test-file only tests if slot is bound, not if it's the correct value

(deftest make-files (file)
  (let ((file (car (make-files '((:size 500
                                  :name "sample.lisp"
                                  :raw-url "https://gist.githubusercontent.com/anonymous/abcde/sample.lisp"
                                  :language "Common Lisp"
                                  :type "text/plain"
                                  :truncated nil
                                  :content "Sample text."))))))
    (assert-true (typep file 'file)
      "Can make-files.")

    (test-file file)))

