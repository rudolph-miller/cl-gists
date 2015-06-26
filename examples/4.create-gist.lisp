(let ((gist (make-gist :description "sample"
                       :public t
                       :files '((:name "file1" :content "text1") (:name "file2" :content "text2")))))
  (create-gist gist))
;; => #S(GIST ...)
