;;; init-julia.el --- Julia  -*- lexical-binding: t; -*-
;;;* julia mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; JULIA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (autoload 'julia-mode "julia-mode" "Highlighting for Julia files" t)
;; (add-to-list 'auto-mode-alist '("\\.jl$" . julia-mode))
;; (add-to-list 'auto-mode-alist '("\\.sj$" . julia-mode)) ;; Obsolete. was for Symata

(use-package julia-repl
  :defer t
  :commands (julia-repl julia-repl-mode)
  :init (setq vterm-max-scrollback 100000))

(use-package lsp-julia
  :defer t)

(use-package julia-mode
  :defer t
  :ensure t
  :mode ("\\.jl\\'" . julia-mode) ;; associate julia-mode with .jl files
)

(add-hook 'julia-mode-hook
          (lambda ()
            (require 'lsp-julia)   ;; ensure client is registered
            (lsp-deferred)))
