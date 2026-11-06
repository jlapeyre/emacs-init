;;; init.el --- Emacs configuration -*- lexical-binding: t; -*-

;; Startup order: early-init.el (GC and file-handler settings, frame
;; appearance, package quickstart, startup trace, `init-load'); then Emacs
;; activates the installed packages; then this file. The configuration is
;; in lib/init-*.el. `init-load' loads one and logs how long it took.
;; Files that are not loaded are kept in attic/.

(my/mark "init.el start")

;;;* Load path
;; Vendored code
(add-to-list 'load-path "~/.emacs.d/lisp/")
;; Handwritten, or copied, code
(add-to-list 'load-path "~/.emacs.d/mylisp/")
(add-to-list 'load-path "~/github/meow_king/typst-ts-mode")

;;;* Configuration
;; init-packages comes first: the package list, use-package, and
;; no-littering, which sets where other packages keep their files.
(init-load "init-packages")    ; package archives and list, use-package, benchmark-init
(init-load "init-settings")    ; built-in options and global keys
(init-load "init-ui")          ; theme safety, fonts, zooming, frames, ibuffer
(init-load "init-completion")  ; vertico, orderless, marginalia, consult
(init-load "init-editor")      ; helpful, vundo, winner
(init-load "init-dired")       ; dired+, icons
(init-load "init-file-modes")  ; Wolfram/MATLAB, YAML, Markdown, gnuplot, OpenQASM, Typst
(init-load "init-tex")         ; AUCTeX, RefTeX
(init-load "init-org")         ; org, agenda, capture, calfw
(init-load "init-julia")
(init-load "init-python")
(init-load "init-lsp")
(init-load "init-gptel")
(init-load "init-tools")       ; vterm, magit
(init-load "init-utils")       ; my own commands: insert-date, sorting, ...

;; Settings are made in code. Anything saved with Customize goes in var/,
;; which is not under version control; move it into code if it is worth keeping.
(setq custom-file (locate-user-emacs-file "var/custom.el"))
(load custom-file t t)
