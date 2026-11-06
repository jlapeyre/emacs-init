;;; -*- lexical-binding: t; -*-

(use-package pdf-tools  ;; autoload
  :mode ("\\.pdf\\'" . pdf-view-mode) ;; associate pdf-view-mode with .pdf files
  :commands pdf-view-mode
  :config
  (pdf-tools-install) ;; Sufficient for initialization. Do not remove unless you find another way to initialize.
  (define-key pdf-view-mode-map (kbd "j") 'pdf-view-next-line-or-next-page)
  (define-key pdf-view-mode-map (kbd "k") 'pdf-view-previous-line-or-previous-page)
  (define-key pdf-view-mode-map (kbd "G") 'pdf-view-last-page)
  (define-key pdf-view-mode-map (kbd "g") 'pdf-view-first-page)
  (define-key pdf-view-mode-map (kbd "d") 'pdf-view-scroll-up-or-next-page)
  (define-key pdf-view-mode-map (kbd "u") 'pdf-view-scroll-down-or-previous-page)
  (setq pdf-annot-list-listed-types '(caret file highlight popup squiggly strike-out text underline))
  (setq pdf-info-restart-process-p 'ask))
