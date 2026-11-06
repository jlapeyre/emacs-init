;;; init-packages.el --- Package system and package list  -*- lexical-binding: t; -*-

;;;* Package manager
;; Emacs has already activated the installed packages before this file is
;; loaded (see early-init.el), so do not call `package-initialize' here.
;; On a fresh install, run M-x package-install-selected-packages, then
;; restart. The package list is below.

(require 'package)
(setq package-archives '(
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ))

(setq use-package-always-defer t)
(setq use-package-verbose t)

;; Put files written by packages in var/ and etc/ rather than the top level
;; of user-emacs-directory. Load before anything that reads those paths.
;; noerror: on first startup it is not yet installed.
(require 'no-littering nil t)
;; Also put backup (foo~) and auto-save (#foo#) files under var/
(when (fboundp 'no-littering-theme-backups)
  (no-littering-theme-backups))

;; package-selected-packages is set below. Keep
;; package.el from saving its own copy to the custom file, which would
;; override that list.
(with-eval-after-load 'package
  (advice-add 'package--save-selected-packages :override #'ignore))

;;;* Benchmark-init

;; Only need this enabled when we are hacking initialization
;; NOTE: We must comment this out when first installing packages, beccause benchmark-init is not yet available.

;(let ((bench (getenv "EMACS_BENCHMARK")))
(let ((bench t))
  (when (and bench (require 'benchmark-init nil t))
    (add-hook 'after-init-hook #'benchmark-init/deactivate)
    (global-set-key (kbd "C-c B") #'benchmark-init/show-durations-tabulated)
    (global-set-key (kbd "C-c C") #'benchmark-init/show-durations-tree)))

(add-hook 'emacs-startup-hook
          (lambda () (message "Total: %.3fs  Init: %s"
                              (float-time (time-subtract (current-time) before-init-time))
                              (emacs-init-time))))


;;;** Packages to install
;; Install any that are missing with M-x package-install-selected-packages
;; (on a new machine, run M-x package-refresh-contents first).
;; M-x package-autoremove deletes installed packages that are not in this
;; list and that no package in it depends on.
(setq package-selected-packages '(
                      auctex-latexmk
                      avy
                      benchmark-init
                      bison-mode
                      browse-at-remote
                      calfw
                      calfw-org
                      consult
                      cargo-mode
                      eat
                      flycheck-rust
                      deadgrep
                      dired-quick-sort
                      dumb-jump
                      gcmh
                      py-vterm-interaction
                      ess
                      default-text-scale
                      djvu
                      gh-md ;; Render github markdown and display in a buffer
                      eimp
                      go-mode
                      lsp-mode
                      lsp-julia
                      lsp-pyright
                      pdf-tools ; This must be compiled. See my notes in the directory in ./elpa/
                      gmail-message-mode
                      edit-server
                      fish-mode
                      nerd-icons
                      nerd-icons-dired
                      no-littering ; keep package data files out of user-emacs-directory
                      org
                      org-bullets
                      org-vcard
                      gnuplot-mode
                      golden-ratio
                      json-mode
                      julia-mode
                      julia-repl
                      jupyter
                      magit
                      helpful
                      ebib
                      lua-mode
                      markdown-mode ; How to specify which version and repo ? Looks like the order in which repos were added above.
                      math-symbol-lists
                      matlab-mode
                      openwith
                      paredit
                      php-mode
                      rust-mode
                      shell-pop
                      swift-mode
                      toml-mode
                      treemacs
                      tuareg
                      typescript-mode
                      volume wolfram-mode
                      visual-fill-column
                      vterm
                      vundo
                      vertico
                      orderless
                      marginalia
                      ;; yaml-mode
                      ))
