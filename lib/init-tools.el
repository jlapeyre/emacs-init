;;; init-tools.el --- Terminal, magit  -*- lexical-binding: t; -*-

;; remap C-q, so that C-q C-y sends C-y to the terminal (libvterm)
(use-package vterm
  :commands vterm
  :ensure t
  :config
  (define-key vterm-mode-map (kbd "C-q")
    (lambda ()
      (interactive)
      (vterm-send-string (char-to-string (read-key))))))


;(define-key vterm-mode-map (kbd "C-q") #'vterm-send-next-key)

(bind-key "C-x m" #'magit-status)  ;; Overwrite compose-mail binding
