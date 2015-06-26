(let* ((gist (create-gist
              (make-gist :description "sample"
                         :public t
                         :files '((:name "file1" :content "text1")
                                  (:name "file2" :content "text2")))))
       (files (gist-files gist))
       (file1 (car files))
       (file2 (cadr files)))

  ;; Change description.
  (setf (gist-description gist) "changed")

  ;; Changed filename and content.
  (setf (file-name file1) "file3")
  (setf (file-content file1) "text3")

  ;; Delete a file.
  (setf (file-content file2) nil)

  (setf (gist-files) (list file1 file2))

  (edit-gist gist))
