(in-package :cl-user)
(defpackage cl-gists-test.util
  (:use :cl
        :prove
        :local-time
        :quri
        :cl-gists-test.init
        :cl-gists.util))
(in-package :cl-gists-test.util)

(plan nil)

(subtest "format-timestring-for-api"
  (is (format-timestring-for-api (mytoday))
      "2014-12-31T12:00:00Z"
      "can format timestamp."))

(subtest "get-request"
  (is-type (get-request (uri "https://google.co.jp"))
           'string
           "string.")

  (is-type (get-request (uri "https://api.github.com"))
           'string
           "octets.")

  (is-error (get-request (uri "https://api.github.com1"))
            'error
            "error."))

(subtest "parse-json")

(subtest "restore-key")

(finalize)
