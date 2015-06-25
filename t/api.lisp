(in-package :cl-user)
(defpackage cl-gists-test.api
  (:use :cl
        :prove
        :cl-gists-test.init
        :cl-gists))
(in-package :cl-gists-test.api)

(plan nil)

(subtest "list-gists"
  (macrolet ((list-gists-test (args comment)
               `(subtest ,comment
                  (let ((gist (car (list-gists ,@args))))
                    (is-type gist
                             'gist
                             "can get list of gists.")))))

    (list-gists-test nil "without keywords.")

    (list-gists-test (:username "Rudolph-Miller") ":username.")

    (list-gists-test (:public t) ":public.")

    (skip 1 ":starred.") ;; Task: Auth

    (list-gists-test (:since (mytoday)) ":since.")))

(subtest "get-gist"
  (let ((target-gist (car (list-gists))))
    (is-type (get-gist (gist-id target-gist))
             'gist
             "without :sha.")

    (let* ((gist (get-gist (gist-id target-gist)))
           (version (history-version (car (gist-history gist)))))
      (is-type (get-gist (gist-id gist) :sha version)
               'gist
               "with :sha."))))

(subtest "create-gist"
  (skip 1 "Have to stub request."))

(subtest "edit-gist"
  (skip 1 "Have to stub request."))

(finalize)
