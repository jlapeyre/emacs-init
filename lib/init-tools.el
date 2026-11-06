;;; init-tools.el --- Terminal, magit  -*- lexical-binding: t; -*-

(use-package vterm
  :commands vterm
    :ensure t)

(global-set-key (kbd "C-x m") 'magit-status)  ;; Overwrite compose-mail binding
