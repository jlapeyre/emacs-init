;;; -*- lexical-binding: t; -*-

;; Special purpose debugging code. As an example.

;; 'diary-lib is hard-coded here.
(defvar my/diary-trace-buf "*diary-lib backtrace*")
(advice-add 'require :before
  (lambda (feat &rest _)
    (when (eq feat 'diary-lib)
      (with-current-buffer (get-buffer-create my/diary-trace-buf)
        (erase-buffer)
        (insert (format "load-file-name=%S\n\n" load-file-name))
        (let ((print-length nil) (print-level nil))
          (backtrace))
        (display-buffer (current-buffer)))))) 

;;Tells what file loaded a function
(advice-add 'require :before
            (lambda (feat &rest _)
              (when (eq feat 'diary-lib)
                (message "diary-lib required from %S" load-file-name))))
