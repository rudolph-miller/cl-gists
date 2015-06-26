#|
  This file is a part of cl-gists project.
  Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
|#

(in-package :cl-user)
(defpackage cl-gists-test-asd
  (:use :cl :asdf))
(in-package :cl-gists-test-asd)

(defsystem cl-gists-test
  :author "Rudolph Miller"
  :license "MIT"
  :homepage "https://github.com/Rudolph-Miller/cl-gists"
  :depends-on (:cl-gists
               :prove
               :closer-mop)
  :components ((:module "t"
                :components
                ((:file "init")
                 (:test-file "util")
                 (:test-file "user")
                 (:test-file "file")
                 (:test-file "fork")
                 (:test-file "history")
                 (:test-file "gist")
                 (:test-file "api")
                 (:test-file "cl-gists"))))
  :description "Test system for cl-gists."

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
