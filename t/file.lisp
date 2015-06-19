(in-package :cl-user)
(defpackage cl-gists-test.file
  (:use :cl
        :prove
        :cl-gists-test.init
        :cl-gists))
(in-package :cl-gists-test.file)

(plan nil)

(subtest "file"
  (let ((file (make-file :name "sample.lisp"
                         :size 500
                         :raw-url "https://gist.githubusercontent.com/anonymous/abcde/sample.lisp"
                         :language "Common Lisp"
                         :type "text/plain"
                         :truncated nil)))
    (is-type file
             'file
             "can make-file.")

    (test-file file)))

(finalize)
