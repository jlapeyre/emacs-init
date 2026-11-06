;;; -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; HELM-BIBTEX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; At least these need to be installed for pdf-tools.
;; Notice that these deps are mentioned partially in different places in the docs.
;; We need to put the documented deps together in order to build the tool.
;; apt-get install gcc g++ make automake autoconf libpng-dev libz-dev libpoppler-glib-dev libpoppler-private-dev
;; This is not enough. Still wants to download. Still gives various
;; failures. I go into the build dir and run make by hand.
;; This still gives build errors, but the main binary is built
;; We must do:
;; cd .emacs.d
;; cd elpa/
;; cd pdf-tools-20151126.1458/
;; cd build/
;; make

;; Meant to allow 'g' to revert buffer with no query in pdf-view-mode.
;; The pdf buffer is not updated sometimes by auctex.
(add-hook 'pdf-view-mode-hook  (lambda () (set (make-local-variable 'revert-without-query) '(".+\.pdf"))))

(use-package helm-bibtex
  :commands helm-bibtex
  :init
  (setq my-literature-directory-name "~/literature_collection/")
  (setq bibtex-completion-bibliography (list (concat my-literature-directory-name "mylibrarybib.bib")
                                           (concat my-literature-directory-name "machine_learning_bib.bib")
                                           (concat my-literature-directory-name "myownnotes.bib")
                                           (concat my-literature-directory-name "myowntalks.bib")))
  (setq bibtex-completion-library-path (list (concat my-literature-directory-name "library") (concat my-literature-directory-name "mynoteslibrary")
                                           (concat my-literature-directory-name "library_machine_learning")
                                           (concat my-literature-directory-name "mytalkslibrary")))
  ;; Look for additional pdf files automatically (if properly named)
  (setq bibtex-completion-find-additional-pdfs t)
  :config
  (use-package helm-files) ; allows helm-resume to work with helm-bibtex
  )

(autoload 'helm-bibtex "helm-bibtex" "" t)
(global-set-key (kbd "<f10>") 'helm-bibtex)  ;; maybe bindings should be moved to one place
;; Resume most recent helm session (not necessarily helm-bibtex)
(global-set-key (kbd "S-<f10>") 'helm-resume)

(setq bibtex-completion-pdf-field "file") ;; This seems to break helm bibtex completely
(setq bibtex-completion-pdf-symbol "⌘")
(setq bibtex-completion-notes-symbol "✎")
(setq bibtex-completion-notes-path (concat my-literature-directory-name  "notes/notes.org"))
(setq bibtex-completion-notes-extension ".org")
(setq bibtex-completion-additional-search-fields  '(keywords tags journal))
(setq bibtex-completion-format-citation-functions
  '((org-mode      . helm-bibtex-format-citation-org-link-to-PDF)
    (latex-mode    . helm-bibtex-format-citation-cite)
    (markdown-mode . helm-bibtex-format-citation-pandoc-citeproc)
    (default       . helm-bibtex-format-citation-default)))

