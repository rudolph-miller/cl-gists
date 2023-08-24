;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-USER -*-
;;; Copyright (c) 2023 Symbolics Pte Ltd
;;; SPDX-License-identifier: MS-PL

;;; Unit Tests for CL-GISTS

(uiop:define-package #:cl-gists-test
  (:use #:cl
	#:clunit
	#:cl-gists
	#:local-time
	#:quri
	#:cl-gists.util
	#:cl-gists.user
	#:cl-gists.file
	#:cl-gists.fork
	#:cl-gists.history
	#:cl-gists.gist))

