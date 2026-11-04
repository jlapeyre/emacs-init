;;; -*- lexical-binding: t; -*-
;;;* auctex and friends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; AUCTEX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; This causes error when compiling:  TeX-command-expand
;; TODO. Try to fix it by examining TeX-command-list
;; Feb 14, 2018. I discover that this is not being triggered
;; (auctex-latexmk-setup is not being run
;; TO BE CLEAR. This is broken
(use-package auctex
  :mode ("\\.tex\\'" . LaTeX-mode)
  :commands TeX-latex-mode
  :config
  (progn (load-library "auctex-latexmk") ;; not using a file anymore
         (auctex-latexmk-setup)
         (message "auctex-latexmk setup done"))
  :init
  (setq TeX-PDF-mode t)
  (setq LaTeX-default-environment "equation*")
  (setq preview-scale-function 1.5)
  (setq preview-auto-reveal 3)
  (setq preview-default-document-pt 10)
  (setq preview-default-option-list '("displaymath" "floats" "graphics" "textmath" "sections" "footnotes" "showlabels"))
  )


;; :config above is not run after loading. I don't understand why
;; Using this hook sets up auctex-latexmk
;; For some reason the hc-highlight stuff is broken. Not for other modes. Just latex
;; So I set the deprecated show-trailing-whitespace. This works finally.
;; This took a couple of hours to solve.
(add-hook 'LaTeX-mode-hook (lambda ()
                             (load-library "auctex-latexmk")
                             (auctex-latexmk-setup)
                             (message "auctex-latexmk-setup run from hook")
                             (hc-highlight-trailing-whitespace)
                             (message "Done hc-highlight-trailing-whitespace")
                             (setq show-trailing-whitespace t)
                             (message "Set show-trailing-whitespace t")
;;                             (hc-toggle-highlight-trailing-whitespace)
                             ;;                             (message "Done hc-toggle-highlight-trailing-whitespace")
                             ))


(setq auctex-latexmk-inherit-TeX-PDF-mode t)
(setq TeX-electric-sub-and-superscript t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
;;;** Use pdflatex by default
(setq TeX-PDF-mode t)
(add-hook 'LaTeX-mode-hook (lambda ()
                             (setq reftex-plug-into-AUCTeX t)
                             (setq TeX-command-default "LatexMk"))) ; this does indeed make this default

;;;** Use reftex with auctex
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)

(setq reftex-label-alist '((nil ?e nil "~\\eqref{%s}" nil nil)))

;; To refresh the pdf after compiling the latex source
;; This seems not to be called, or not be effective in certain circumstances.
;; eg if the pdf buffer is not visible.
(add-hook 'TeX-after-TeX-LaTeX-command-finished-functions 'TeX-revert-document-buffer)
(add-hook 'TeX-after-compilation-finished-functions 'TeX-revert-document-buffer)

;;;** Use pdf-tool in-emacs viewer
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server-flag nil
      TeX-source-correlate-start-server nil)
(setq pdf-info-restart-process-p nil)

;; Suggestion for bug https://github.com/politza/pdf-tools/issues/177
;; There is some memory leak that crashes the OS. Happens alwasy with emacs
;; viewing pdf with pdf-tools. The following may have nothing to do with the
;; problem. In fact its very likely that is has nothing to do with the problem.
;; Sometimes I think it is somehow gnome's fault.  Sat Jun 10 17:40:24 CEST 2017
(setq image-cache-eviction-delay 5)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; END AUCTEX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
