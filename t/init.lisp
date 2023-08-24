;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-GIST-TESTS -*-
;;; Copyright (c) 2015 Rudolph Miller
;;; Copyright (c) 2023 Symbolics Pte Ltd
;;; SPDX-License-identifier: MS-PL

(in-package #:cl-gists-test)

(defmacro test-all-slots-bound-and-not-nil (obj &key excludes)
  `(loop for slot in (c2mop:class-direct-slots (class-of ,obj))
         for name = (c2mop:slot-definition-name slot)
         do (assert-true (slot-boundp ,obj name))
            (if (find name ,excludes)
                (assert-equal (slot-value ,obj name) nil
                    (format nil "~a is NIL." name))
                (assert-true (slot-value ,obj name)
                    (format nil "~a is not NIL." name)))))

(defmacro test-user (user)
  `(test-all-slots-bound-and-not-nil ,user :excludes (list 'cl-gists.user::site-admin
							   'cl-gists.user::node-id)))

(defmacro test-file (file)
  `(test-all-slots-bound-and-not-nil ,file :excludes (list 'cl-gists.file::truncated)))

(defmacro test-fork (fork)
  `(progn
     (deftest slots-of-fork (fork)
       (test-all-slots-bound-and-not-nil ,fork))
     (deftest slots-of-user (fork)
       (test-user (fork-user ,fork)))))

(defmacro test-history (history)
  `(progn
     (deftest slots-of-history (history)
       (test-all-slots-bound-and-not-nil ,history))
     (deftest slots-of-user (history)
       (test-user (history-user ,history)))))

(defmacro test-gist (gist &key excludes)
  `(progn
     (let ((excludes
             (append (list 'cl-gists.gist::user
                           'cl-gists.gist::truncated)
                     ,excludes)))
       (deftest slots-of-gist (gist)
         (test-all-slots-bound-and-not-nil ,gist :excludes excludes)))
     (deftest slots-of-owner (gist)
       (test-user (gist-owner ,gist)))
     (deftest slots-of-file (gist)
       (test-file (car (gist-files ,gist))))))

(defun mytoday ()
  (encode-timestamp 0 0 0 12 31 12 2014 :timezone +utc-zone+))
