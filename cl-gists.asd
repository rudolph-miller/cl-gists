#|
  This file is a part of cl-gists project.
  Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
|#

#|
  Gists API Wrapper for Common Lisp.
  Author: Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
|#

(in-package :cl-user)
(defpackage cl-gists-asd
  (:use :cl :asdf))
(in-package :cl-gists-asd)

(defsystem cl-gists
  :version "0.1"
  :author "Rudolph Miller"
  :license "MIT"
  :homepage "https://github.com/Rudolph-Miller/cl-gists"
  :depends-on (:cl-syntax
               :cl-syntax-annot
               :alexandria
               :local-time
               :dexador
               :jonathan)
  :components ((:module "src"
                :serial t
                :components
                ((:file "user")
                 (:file "file")
                 (:file "gist")
                 (:file "cl-gists"))))
  :description "Gists API Wrapper for Common Lisp."
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.md"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op cl-gists-test))))
