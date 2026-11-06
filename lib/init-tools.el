;;; init-tools.el --- Terminal, magit, package list UI  -*- lexical-binding: t; -*-

(use-package vterm
  :commands vterm
    :ensure t)

(global-set-key (kbd "C-x m") 'magit-status)  ;; Overwrite compose-mail binding

(use-package paradox
  :defer t
  :config (setq paradox-github-token t))
