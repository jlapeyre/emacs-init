
;;; init-completion.el --- Minibuffer completion  -*- lexical-binding: t; -*-

;; Vertical completion list in the minibuffer
(use-package vertico
  :ensure t
  :init (vertico-mode))

;; In file name prompts, DEL right after a "/" deletes the whole last
;; directory; otherwise it deletes one character.
(use-package vertico-directory
  :ensure nil ; ships with vertico
  :after vertico
  :bind (:map vertico-map
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Typing ~/ or / after a path clears the old part
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;; Type several space-separated patterns; each one narrows further
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Remember minibuffer history across restarts. vertico lists recently
;; used candidates first, so M-x puts your frequent commands at the top.
(use-package savehist
  :init (savehist-mode))

;; Show a one-line description next to each candidate
(use-package marginalia
  :ensure t
  :init (marginalia-mode))

;; This does not prevent loading pcomplete on startup
(use-package pcomplete
  :commands
  pcomplete-expand
  pcomplete-list
  pcomplete-expand-and-complete
  pcomplete-continue pcomplete-help)

;; consult: search and selection commands whose candidates are shown by
;; vertico. These replace the helm commands used before.
;; C-h b is back to the built-in describe-bindings.
(use-package consult
  :bind (("M-y" . consult-yank-pop)  ; browse the kill ring
         ("M-s l" . consult-line))) ; lines in this buffer matching input, like occur (M-s o)

;; In-buffer completion popup
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)          ;; Enable automatic as-you-type completion
  (corfu-auto-delay 0.2)  ;; Delay in seconds before the popup appears
  (corfu-auto-prefix 2)   ;; Number of characters typed before triggering
  (corfu-quit-no-match t) ;; Automatically quit if no match is found
  :init
  (global-corfu-mode)
  ;; Optional: toggle switch matching your old muscle memory
  :bind (("C-c c" . global-corfu-mode)))
