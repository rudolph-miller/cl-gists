(in-package :cl-user)
(defpackage cl-gists-test.init
  (:use :cl
        :cl-gists
        :prove)
  (:export :test-all-slots-bound-and-not-nil
           :test-user
           :test-file
           :test-gist))
(in-package :cl-gists-test.init)

(defmacro test-all-slots-bound-and-not-nil (obj &key excludes)
  `(loop for slot in (c2mop:class-direct-slots (class-of ,obj))
         for name = (c2mop:slot-definition-name slot)
         do (ok (slot-boundp ,obj name)
                (format nil "~a is bound." name))
            (if (find name ,excludes)
                (is (slot-value ,obj name)
                    nil
                    (format nil "~a is NIL." name))
                (ok (slot-value ,obj name)
                    (format nil "~a is not NIL." name)))))

(defmacro test-user (user)
  `(test-all-slots-bound-and-not-nil ,user :excludes (list 'cl-gists.user::site-admin)))

(defmacro test-file (file)
  `(test-all-slots-bound-and-not-nil ,file :excludes (list 'cl-gists.file::truncated)))

(defmacro test-gist (gist)
  `(progn
     (test-all-slots-bound-and-not-nil ,gist :excludes (list 'cl-gists.gist::user))
     (test-user (gist-user ,gist))
     (test-file (car (gist-files ,gist)))))
