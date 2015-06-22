(in-package :cl-user)
(defpackage cl-gists-test.init
  (:use :cl
        :cl-gists
        :prove
        :local-time)
  (:export :test-all-slots-bound-and-not-nil
           :test-user
           :test-file
           :test-fork
           :test-history
           :test-gist
           :mytoday))
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

(defmacro test-fork (fork)
  `(progn
     (subtest "slots of fork"
       (test-all-slots-bound-and-not-nil ,fork))
     (subtest "slots of user"
       (test-user (fork-user ,fork)))))

(defmacro test-history (history)
  `(progn
     (subtest "slots of history"
       (test-all-slots-bound-and-not-nil ,history))
     (subtest "slots of user"
       (test-user (history-user ,history)))))

(defmacro test-gist (gist &key excludes)
  `(progn
     (subtest "slots of gist"
       (test-all-slots-bound-and-not-nil ,gist :excludes (append (list 'cl-gists.gist::user) ,excludes)))
     (subtest "slots of owner"
       (test-user (gist-owner ,gist)))
     (subtest "slots of file"
       (test-file (car (gist-files ,gist))))))

(defun mytoday ()
  (encode-timestamp 0 0 0 12 31 12 2014 :timezone +utc-zone+))
