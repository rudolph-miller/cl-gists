#|
  This file is a part of cl-gists project.
  Copyright (c) 2015 Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
|#

#|
  Gists API Wrapper for Common Lisp.
  Author: Rudolph Miller (chopsticks.tk.ppfm@gmail.com)
|#

(defsystem "cl-gists"
  :version "0.1"
  :author "Rudolph Miller"
  :license "MIT"
  :homepage "https://github.com/Rudolph-Miller/cl-gists"
  :depends-on ("cl-syntax"
               "cl-syntax-annot"
               "alexandria"
               "local-time"
               "trivial-types"
               "quri"
               "dexador"
               "babel"
               "jonathan"
               "uiop")
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
                 (:file "cl-gists"))))
  :description "Gists API Wrapper for Common Lisp."
  ;;:long-description #.(read-file-string (subpathname *load-pathname "README.md"))
  :in-order-to ((test-op (test-op "cl-gists-test"))))
