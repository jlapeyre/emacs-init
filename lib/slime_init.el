;;; -*- lexical-binding: t; -*-

(setq inferior-lisp-program "sbcl --dynamic-space-size 4096")

(defun raise-minor-mode-map-alist (mode-symbol)
  "Raise `minor-mode-map-alist' priority of MODE-SYMBOL."
  (let ((x (assq mode-symbol minor-mode-map-alist)))
    (and x (setq minor-mode-map-alist (cons x (delq x minor-mode-map-alist))))))

(with-eval-after-load 'slime
  (require 'ac-slime)
  (add-hook 'slime-mode-hook 'set-up-slime-ac)
  (add-hook 'slime-repl-mode-hook 'set-up-slime-ac))

(use-package slime
  :commands slime
  :config
  (setq slime-net-coding-system 'utf-8-unix)
  (setq slime-contribs '(slime-fancy slime-banner slime-media))
  (progn
    ;; Replace "sbcl" with the path to your implementation
    (slime-setup '(slime-fancy
                   ; slime-highlight-edits
                   slime-autodoc
                   slime-indentation
                   slime-company))
    (setq slime-net-coding-system 'utf-8-unix
          slime-truncate-lines nil
          slime-multiprocessing t
          )
    (raise-minor-mode-map-alist 'view-mode)
    (setq lisp-lambda-list-keyword-parameter-alignment t
          lisp-lambda-list-keyword-alignment t
      lisp-align-keywords-in-calls t)))

(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))
