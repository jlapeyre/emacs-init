;;; init-tex.el --- AUCTeX and RefTeX  -*- lexical-binding: t; -*-
;;;* auctex and friends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; AUCTEX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The AUCTeX package provides the features `tex' and `latex', not `auctex'.
;; So `use-package auctex' never ran its :config. Name the feature instead.
(use-package latex
  :mode ("\\.tex\\'" . LaTeX-mode)
  :commands TeX-latex-mode
  :config
  (require 'auctex-latexmk)
  (auctex-latexmk-setup)
  :init
  (setq TeX-PDF-mode t)
  (setq LaTeX-default-environment "equation*")
  (setq preview-scale-function 1.5)
  (setq preview-auto-reveal 3)
  (setq preview-default-document-pt 10)
  (setq preview-default-option-list '("displaymath" "floats" "graphics" "textmath" "sections" "footnotes" "showlabels"))
  )

;; Trailing whitespace is shown via text-mode-hook in settings.el.

(setq auctex-latexmk-inherit-TeX-PDF-mode t)
(setq TeX-electric-sub-and-superscript t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
(add-hook 'LaTeX-mode-hook (lambda () (setq TeX-command-default "LatexMk")))

;;;** Use reftex with auctex
(setq reftex-plug-into-AUCTeX t)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)

(setq reftex-label-alist '((nil ?e nil "~\\eqref{%s}" nil nil)))

;; To refresh the pdf after compiling the latex source
;; This seems not to be called, or not be effective in certain circumstances.
;; eg if the pdf buffer is not visible.
(add-hook 'TeX-after-compilation-finished-functions 'TeX-revert-document-buffer)

;;;** Use pdf-tool in-emacs viewer
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server nil)
(setq pdf-info-restart-process-p nil)

;; Evict cached images after 5 s rather than 300 s, to limit memory used by
;; rendered PDF pages. Suggested in https://github.com/politza/pdf-tools/issues/177
(setq image-cache-eviction-delay 5)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; END AUCTEX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
