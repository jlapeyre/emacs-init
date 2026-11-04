;;;** List packages to auto-install
(defvar my-packages '(
		      auctex-latexmk
                      auto-complete ; may be inlcuded in the emacs distribution
		      avy
		      benchmark-init
                      bison-mode
		      browse-at-remote
                      calfw
                      calfw-org
                      cargo-mode
                      csv
                      eat
                      flycheck-rust
                      deadgrep
                      dired-quick-sort
                      dirvish
                      dumb-jump
                      elpy
                      gcmh
                      py-vterm-interaction
                      jedi
                      evil
                      ess
                      default-text-scale
		      djvu
                      gh-md ;; Render github markdown and display in a buffer
                      eimp
                      go-mode
                      lsp-mode
                      lsp-julia
                      pdf-tools ; This must be compiled. See my notes in the directory in ./elpa/
                      outline-magic ; We need to use only one of outline-magic and outshine
                      gmail-message-mode
                      edit-server
                      fish-mode
                      mic-paren
                      nerd-icons
                      nerd-icons-dired
                      org
                      org-bullets
                      org-journal
                      org-vcard
                      org-modern
                      gnuplot-mode
                      golden-ratio
                      google-translate
                      ace-window
                      json-mode
                      julia-mode
                      julia-repl
                      julia-snail
                      jupyter
                      magit
                      helm
                      helm-bibtex
                      helm-descbinds
                      helm-google
                      helm-gtags
                      helpful
                      ebib
                      image-dired+
                      lua-mode
                      magit
                      markdown-mode ; How to specify which version and repo ? Looks like the order in which repos were added above.
                      math-symbol-lists
                      matlab-mode
                      openwith
                      paredit
                      php-mode
                      rust-mode
                      shell-pop
                      slime
                      slime-company
                      swift-mode
                      ac-slime
                      toml-mode
                      treemacs
                      tuareg
                      typescript-mode
                      smex undo-tree volume wolfram-mode
                      visual-fill-column
                      vterm
                      vundo
                      ;; yaml-mode
		      )
  "A list of packages to ensure are installed at launch.")
