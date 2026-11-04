;;; -*- lexical-binding: t; -*-

;;(setq nerd-icons-font-family "Symbols Nerd Font Mono") ; the default
;;(setq nerd-icons-font-family "Symbols Nerd Font Mononoki"); missing glyphs
(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode)
  (diredp-mode . nerd-icons-dired-mode))

(defun my-dired+-boot (&rest _)
  (advice-remove 'dired #'my-dired+-boot)
  (advice-remove 'dired-noselect #'my-dired+-boot)
  (add-to-list 'load-path "~/.emacs.d/lisp/dired+")
  (setq dired-dwim-target t)
  (setq diredp-hide-details-initially-flag nil)
  (require 'dired+))

(advice-add 'dired :before #'my-dired+-boot)
(advice-add 'dired-noselect :before #'my-dired+-boot)

;; Make `emacs path/to/dir` load dired+
(when (catch 'd
        (dolist (a command-line-args-left)
          (when (file-directory-p a)
            (throw 'd t))) nil)
  (my-dired+-boot))
