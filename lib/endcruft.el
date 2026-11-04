;;; -*- lexical-binding: t; -*-

;; Following was done by chatgpt, but it never worked.

;; (defun my-gptel-latex-preview-if-math ()
;;   "Run `org-latex-preview` if Org-mode math is detected and `gptel-mode` is active in the buffer."
;;   (when (and (derived-mode-p 'org-mode)
;;              gptel-mode
;;              (save-excursion
;;                (goto-char (point-min))
;;                (re-search-forward "\\(\\$\\$\\|\\\\[\\|\\$\\|\\\\(\\)" nil t)))
;;     (org-latex-preview '(16))))

;; (defun my-setup-gptel-latex-preview ()
;;   "Set up automatic LaTeX previews in buffers with `gptel-mode`."
;;   (add-hook 'post-command-hook 'my-gptel-latex-preview-if-math nil t))

;; (add-hook 'gptel-mode-hook 'my-setup-gptel-latex-preview)

;; (defvar my-gptel-latex-preview-timer nil
;;   "Timer for delayed LaTeX previews in `gptel-mode`.")

;; (defun my-gptel-latex-preview-if-math ()
;;   "Run `org-latex-preview` if Org-mode math is detected and `gptel-mode` is active."
;;   (when (and (derived-mode-p 'org-mode)
;;              gptel-mode
;;              (save-excursion
;;                (goto-char (point-min))
;;                (re-search-forward "\\(?:\\$\\$\\|\\\\[\\|\\$\\|\\\\(\\)" nil t)))
;;     (org-latex-preview '(16))))

;; (defun my-debounced-gptel-latex-preview ()
;;   "Debounce the execution of `my-gptel-latex-preview-if-math`."
;;   (when my-gptel-latex-preview-timer
;;     (cancel-timer my-gptel-latex-preview-timer))
;;   (setq my-gptel-latex-preview-timer
;;         (run-with-idle-timer 0.5 nil #'my-gptel-latex-preview-if-math)))

;; (defun my-setup-gptel-latex-preview ()
;;   "Set up automatic LaTeX previews in buffers with `gptel-mode`."
;;   (add-hook 'post-command-hook #'my-debounced-gptel-latex-preview nil t))

;; (add-hook 'gptel-mode-hook #'my-setup-gptel-latex-preview)



;; ;; ORIG COMMENTS: means these were commented out in the code I copied from online
;; (use-package typst-ts-mode
;;   :load-path "~/.emacs.d/typst-ts-mode"
;;   :custom
;;   ;; (typst-ts-mode-watch-options "--open")
;;   (typst-ts-mode-enable-raw-blocks-highlight nil)
;;   (typst-ts-mode-highlight-raw-blocks-at-startup nil)
;;   :config
;;   (add-hook 'typst-ts-mode-hook #'auto-fill-mode)

;;   ;; GJL comment
;;   ;; (add-to-list 'lsp-language-id-configuration '(typst-ts-mode . "typst"))
;;   ;; (lsp-register-client
;;   ;;  (make-lsp-client
;;   ;;   :new-connection (lsp-stdio-connection "typst-lsp")
;;   ;;   :major-modes '(typst-ts-mode)
;;   ;;   :server-id 'typst-lsp))

;;   ;; 5 ORIG COMMENTS
;;   ;; (add-hook 'typst-ts-mode-hook 'eglot-ensure)
;;   ;; (add-to-list 'eglot-server-programs
;;   ;; '(typst-ts-mode . ("typst-lsp")))
;;   ;; (setq-default eglot-workspace-configuration
;;   ;; '((typst-lsp (maxCompletions . 200))))

;;   ;; GJL comment
;;   (add-to-list 'treesit-language-source-alist
;;                '(typst "https://github.com/uben0/tree-sitter-typst"))

;;   ;; ORIG COMMENTS
;;   ;; (treesit-install-language-grammar 'typst)
;;   )
