(in-package :cl-user)
(defpackage cl-gists-test.file
  (:use :cl
        :prove
        :cl-gists-test.init
        :cl-gists)
  (:import-from :cl-gists.file
                :make-file
                :make-files))
(in-package :cl-gists-test.file)

(plan nil)

(subtest "file"
  (let ((file (make-file :name "sample.lisp"
                         :size 500
                         :raw-url "https://gist.githubusercontent.com/anonymous/abcde/sample.lisp"
                         :language "Common Lisp"
                         :type "text/plain"
                         :truncated nil
                         :content "Sample text.")))
    (is-type file
             'file
             "can make-file.")

    (test-file file)))

(subtest "make-files"
    (let ((file (car (make-files '((:size 500
                                    :name "sample.lisp"
                                    :raw-url "https://gist.githubusercontent.com/anonymous/abcde/sample.lisp"
                                    :language "Common Lisp"
                                    :type "text/plain"
                                    :truncated nil
                                    :content "Sample text."))))))
      (is-type file
               'file
               "can make-files.")

      (test-file file)))
