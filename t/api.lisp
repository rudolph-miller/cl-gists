(in-package :cl-user)
(defpackage cl-gists-test.api
  (:use :cl
        :prove
        :cl-gists-test.init
        :cl-gists))
(in-package :cl-gists-test.api)

(plan nil)

(defvar *anonymous-gist-id* "dc6a799aa31b5f501d15")

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

    (list-gists-test (:starred t) ":starred.")

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
  (let ((gist (create-gist (make-gist :description "sample" :public t :files (list (list :name "sample" :content "Sample."))))))
    (ok (get-gist (gist-id gist))
        "can create a gist.")

    (delete-gist gist)))

(defmacro with-new-gist ((var) &body body)
  `(let ((,var (create-gist (make-gist :description "sample" :public t :files (list (list :name "sample" :content "Sample."))))))
     ,@body
     (ignore-errors (delete-gist (gist-id ,var)))))

(subtest "list-gist-commits"
  (with-new-gist (gist)
    (is-type (car (list-gist-commits gist))
             'history
             "can git list of gist-commits.")))

(subtest "star-gist"
  (with-new-gist (gist)
    (is (gist-starred-p gist)
        nil
        "At first, the gist is not starred.")

    (star-gist gist)

    (ok (gist-starred-p gist)
        "can star the gist.")))

(subtest "unstar-gist"
  (with-new-gist (gist)
    (star-gist gist)

    (ok (gist-starred-p gist)
        "At first, the gist is starred.")

    (unstar-gist gist)

    (is (gist-starred-p gist)
        nil
        "can unstar the gist.")))

(subtest "gist-starred-p"
  (with-new-gist (gist)
    (is (gist-starred-p gist)
        nil
        "NIL.")

    (star-gist gist)

    (ok (gist-starred-p gist)
        "T.")))

(subtest "fork-gist"
  (let* ((gist (get-gist *anonymous-gist-id*))
         (forked (fork-gist gist)))
    (is-type (get-gist (gist-id forked))
             'gist
             "can fork a gist.")

    (delete-gist forked)))

(subtest "list-gist-forks"
  (let* ((gist (get-gist *anonymous-gist-id*))
         (forked (fork-gist gist)))

    (is-type (car (list-gist-forks gist))
             'gist
             "can get list of fork gists.")

    (delete-gist forked)))

(subtest "delete-gist"
  (let ((gist (create-gist (make-gist :description "sample" :public t :files (list (list :name "sample" :content "hihi"))))))
    (ok (get-gist (gist-id gist))
        "At first, you can get the gist.")

    (delete-gist gist)

    (is-error (get-gist (gist-id gist))
              'error
              "can delete gist.")))

(finalize)
