;;; -*- lexical-binding: t; -*-

(use-package lsp-mode
  :ensure t
  :defer t
  :hook (lsp-mode . (lambda ()
                      (let ((lsp-keymap-prefix (kbd "C-c C-l")))
                        (lsp-enable-which-key-integration))
                      (setq lsp-pylsp-plugins-pycodestyle-enabled nil)
                      ;; (setq lsp-log-io t) verbose and slow
                      (setq lsp-pylsp-plugins-pyflakes-enabled nil)
                      (setq lsp-pylsp-plugins-pylint-enabled nil)
                      ))

  :custom (lsp-enable-snippet nil)
  :config
  (define-key lsp-mode-map (kbd "C-c C-l") lsp-command-map))

(add-hook 'python-mode-hook
          (lambda ()
            (setq-local lsp-diagnostics-provider :none) ; no LSP diagnostics
            (flymake-mode -1)
            (when (bound-and-true-p flycheck-mode)
              (flycheck-mode -1))))

(add-hook 'rust-mode-hook #'lsp)
(add-hook 'python-mode-hook 'lsp)
