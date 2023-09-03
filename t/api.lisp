;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-GISTS-TEST -*-
;;; Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
;;; Copyright (c) 2021-2023 by Symbolics Pte. Ltd. All rights reserved.
;;; SPDX-License-identifier: MS-PL

(in-package #:cl-gists-test)

(defsuite api (gists))
(defsuite list (api))

(defvar *anonymous-gist-id* "dc6a799aa31b5f501d15")

;;; Various ways of listing gists
;;; Note that these are dependent on the user running the test.  For
;;; example if you have no starred gists, then the starred test will
;;; fail.
(deftest without-keywords (list)
  (let ((gist (car (list-gists))))
    (assert-true (typep gist 'gist)
      "Can get a list of gists.")))

(deftest username (list)
  (let ((gist (car (list-gists :username "Symbolics"))))
    (assert-true (typep gist 'gist)
      "Can get a list of gists by username")))

(deftest public (list)
  (let ((gist (car (list-gists :public t))))
    (assert-true (typep gist 'gist)
      "Can get a list of gists that are public")))

(deftest starred (list)
  (let ((gist (car (list-gists :starred t))))
    (assert-true (typep gist 'gist)
      "Can get a list of gists that are starred")))

(deftest since (list)
  (let ((gist (car (list-gists :since (mytoday)))))
    (assert-true (typep gist 'gist)
      "Can get a list of gists since a particular date")))


;;; Regular API calls
(deftest get-gist (api)
  (let ((target-gist (car (list-gists))))
    (assert-true (typep (get-gist (gist-id target-gist))
			'gist)
      "Without :sha")

    (let* ((gist (get-gist (gist-id target-gist)))
           (version (history-version (car (gist-history gist)))))
      (assert-true (typep (get-gist (gist-id gist) :sha version)
			  'gist)
	"With :sha"))))

(deftest create-gist (api)
  (let ((gist (create-gist (make-gist :description "sample"
				      :public t
				      :files (list (list :name "sample" :content "Sample."))))))
    (assert-true (get-gist (gist-id gist))
      "Can create a gist")
    (delete-gist gist)))

(defmacro with-new-gist ((var) &body body)
  `(let ((,var (create-gist (make-gist :description "sample" :public t :files (list (list :name "sample" :content "Sample."))))))
     ,@body
     (ignore-errors (delete-gist (gist-id ,var)))))

(deftest edit-gist (api)
  (with-new-gist (gist)
    (let ((description "changed")
          (files (gist-files gist)))
      (setf (gist-description gist) description)
      (setf (file-content (car files)) nil)
      (setf (gist-files gist) files)

      (edit-gist gist)

      (sleep 5)

      (let ((new-gist (get-gist (gist-id gist))))
	(assert-true (string= (gist-description new-gist) description)
	  "Description can be edited")
	(assert-equal (gist-files new-gist) nil
          "Files can be deleted")

	(setf (gist-files gist)
              (list (make-file :name "new-file" :content "New content.")))
	(edit-gist gist)
	(sleep 5)

	(let ((new-gist (get-gist (gist-id gist))))
	  (assert-true (typep (car (gist-files new-gist)) 'file)
	    "Can add files"))

	(let ((filename "changed-file")
              (content "Changed content."))

          (setf (gist-files gist)
		(list (make-file :name filename :content content :old-name "new-file")))
          (edit-gist gist)
          (sleep 5)

          (let* ((files (gist-files (get-gist (gist-id gist))))
		 (file (car files)))

	    (assert-true (= (length files) 1)
              "can edit existing files.")
	    (assert-true (string= (file-name file) filename)
              "can change name.")
	    (assert-true (string= (file-content file) content)
              "can change content.")))))))


(deftest list-gist-commits (api)
  (with-new-gist (gist)
    (assert-true (typep (car (list-gist-commits gist)) 'history)
      "Can git list of gist-commits")))

(deftest star-gist (api)
  (with-new-gist (gist)
    (assert-false (gist-starred-p gist)
      "At first, the gist is not starred.")
    (star-gist gist)
    (assert-true (gist-starred-p gist)
      "Can star the gist.")))

(deftest unstar-gist (api)
  (with-new-gist (gist)
    (star-gist gist)
    (assert-true (gist-starred-p gist)
      "At first, the gist is starred.")
    (unstar-gist gist)
    (assert-false (gist-starred-p gist)
      "Can unstar the gist.")))

(deftest gist-starred-p (api)
  (with-new-gist (gist)
    (assert-false (gist-starred-p gist)
      "Gist is not starred")
    (star-gist gist)
    (assert-true (gist-starred-p gist)
      "Gist is starred")))

(deftest fork-gist (api)
  (let* ((gist (get-gist *anonymous-gist-id*))
         (forked (fork-gist gist)))
    (assert-true (typep (get-gist (gist-id forked)) 'gist)
      "can fork a gist.")
    (delete-gist forked)))

(deftest list-gist-forks (api)
  (let* ((gist (get-gist *anonymous-gist-id*))
         (forked (fork-gist gist)))
    (assert-true (typep (car (list-gist-forks gist)) 'gist)
      "can get list of fork gists.")
    (delete-gist forked)))

(deftest delete-gist (api)
  (let ((gist (create-gist (make-gist :description "sample" :public t :files (list (list :name "sample" :content "Sample."))))))
    (assert-true (get-gist (gist-id gist))
      (delete-gist gist)
      (assert-condition error (get-gist (gist-id gist))
	"Can delete the gist"))))

