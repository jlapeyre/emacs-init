;;; -*- lexical-binding: t; -*-

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
