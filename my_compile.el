;;; my_compile.el --- Byte-compile and native-compile the init files -*- lexical-binding: t; -*-

;; Usage, from any directory:
;;   M-x load-file RET ~/.emacs.d/my_compile.el
;;   emacs --batch -l ~/.emacs.d/my_compile.el
;; Compiles early-init.el, init.el, and lib/, lisp/ and mylisp/ (not attic/).

(require 'cl-lib)

(let* ((here (file-name-directory (or load-file-name buffer-file-name)))
       (files (append (list (expand-file-name "early-init.el" here)
                            (expand-file-name "init.el" here))
                      (cl-mapcan (lambda (dir)
                                   (directory-files-recursively
                                    (expand-file-name dir here) "\\.el\\'"))
                                 '("lib" "lisp" "mylisp")))))
  ;; In batch mode packages are not activated, and their macros are
  ;; needed to compile the files that use them.
  (when noninteractive
    (package-activate-all))
  ;; Some files in lisp/ require others there.
  (dolist (dir (cons (expand-file-name "lisp" here)
                     (seq-filter #'file-directory-p
                                 (directory-files (expand-file-name "lisp" here) t "\\`[^.]"))))
    (add-to-list 'load-path dir))
  (dolist (f files)
    (byte-compile-file f))
  (if noninteractive
      ;; Batch Emacs would exit before asynchronous compilation finishes.
      (dolist (f files)
        (native-compile f))
    (native-compile-async files)))
