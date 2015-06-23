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

(subtest "request"
  (is-type (request (uri "https://google.co.jp") :method :get)
           'string
           "string.")

  (is-type (request (uri "https://api.github.com") :method :get)
           'string
           "octets.")

  (is-error (request (uri "https://api.github.com1") :method :get)
            'error
            "error."))

(finalize)
