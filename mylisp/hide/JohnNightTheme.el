(deftheme JohnNightTheme
  "Created 2018-05-27.")

(custom-theme-set-variables
 'JohnNightTheme
 '(TeX-PDF-mode t)
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(package-selected-packages (quote (haskell-mode gnuplot-mode go-mode yaml-mode auctex gh-md golden-ratio julia-shell julia-repl yasnippet wolfram-mode volume use-package smex plantuml-mode outline-magic org-vcard org-pdfview org-password-manager org-journal openwith magit julia-mode image-dired+ ido-vertical-mode ido-ubiquitous idle-highlight-mode help-mode+ help-fns+ help+ helm-bibtex google-translate ess eimp ebib djvu dired+ default-text-scale calfw browse-at-remote bookmark+ bongo benchmark-init aumix-mode auctex-latexmk ace-window)))
 '(pdf-info-restart-process-p (quote ask))
 '(column-number-mode t)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil))

(custom-theme-set-faces
 'JohnNightTheme
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 143 :width normal)))))

(provide-theme 'JohnNightTheme)
