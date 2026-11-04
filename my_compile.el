;;; -*- lexical-binding: t; -*-
;; Byte-compile all files, then native-compile them asynchronously

(require 'cl-lib)

(setq my-all-src-files
      (let* ((src-files
              (append '("early-init.el" "init.el")
                      (cl-loop for fname in (directory-files-recursively "lib" "\\.el\\'")
                               collect fname)
                      (cl-loop for fname in (directory-files-recursively "lisp" "\\.el\\'")
                               collect fname)
                      (cl-loop for fname in (directory-files-recursively "mylisp" "\\.el\\'")
                               collect fname)
                      ))
             (here (file-name-directory (or load-file-name buffer-file-name))))
        (cl-loop for fname in src-files
                 collect (expand-file-name fname here))))

(dolist (f my-all-src-files)
  (byte-compile-file f))

(native-compile-async my-all-src-files)
