;;; -*- lexical-binding: t; -*-

(use-package lsp-mode
  :ensure t
  :defer t
  :hook (lsp-mode . (lambda ()
                      (let ((lsp-keymap-prefix (kbd "C-c C-l")))
                        (lsp-enable-which-key-integration))
                      ;; (setq lsp-log-io t) verbose and slow
                      ))

  :custom
  (lsp-enable-snippet nil)
  (lsp-diagnostics-provider :flymake)
  :config
  (define-key lsp-mode-map (kbd "C-c C-l") lsp-command-map))

;; Show errors and warnings only after saving, not while typing.
;; lsp-mode hands each new set of diagnostics from the server to flymake as
;; soon as it arrives, so flymake's own timing settings have no effect.
;; Skip those updates while the buffer has unsaved changes. The diagnostics
;; that arrive after a save are shown.
;; Note: this advises an internal lsp-mode function, which could be renamed.
(defun my/lsp-flymake-update-only-when-saved (orig &rest args)
  (unless (buffer-modified-p)
    (apply orig args)))
(advice-add 'lsp-diagnostics--flymake-after-diagnostics
            :around #'my/lsp-flymake-update-only-when-saved)

;; Python: use pyright as the language server.
(use-package lsp-pyright
  :defer t
  :init
  ;; pylsp is also installed; without this lsp-mode may ask which to use.
  (setq lsp-disabled-clients '(pylsp))
  :hook (python-mode . (lambda ()
                         ;; Use only pyright's diagnostics, not python-mode's
                         ;; own flymake checker (pyflakes etc.).
                         (remove-hook 'flymake-diagnostic-functions #'python-flymake t)
                         (require 'lsp-pyright)
                         (lsp-deferred))))

(add-hook 'rust-mode-hook #'lsp)
