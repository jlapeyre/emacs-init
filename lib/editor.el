;;; -*- lexical-binding: t; -*-

;;
;; Load packages used for editing files. Very similar to settings.el, except
;; the latter does not load packages, but only sets varables.
;; "used for editing files" is a bit vague.
;;

;; I am apparently not using this, so comment out
;; (use-package highlight-chars
;;   :load-path "~/.emacs.d/lisp/highlight-chars"
;;   :commands hc-highlight-trailing-whitespace hc-toggle-highlight-trailing-whitespace)


;; consult: search and selection commands whose candidates are shown by
;; vertico (see init.el). These replace the helm commands used before.
;; C-h b is back to the built-in describe-bindings.
(use-package consult
  :bind (("M-y" . consult-yank-pop)  ; browse the kill ring
         ("C-c h o" . consult-line))) ; lines in this buffer matching input, like occur

;; `helpful-callable' as a drop-in replacement.
;; (global-set-key (kbd "C-h f") #'helpful-callable)
;; (global-set-key (kbd "C-h v") #'helpful-variable)
;; (global-set-key (kbd "C-h k") #'helpful-key)
;; (global-set-key (kbd "C-h x") #'helpful-command)

(use-package helpful
  :defer t
  :commands helpful-callable helpful-variable helpful-key helpful-command
  :bind (("C-h f" . helpful-callable) ; rebind standard help keys to helpful
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)
         ("C-c C-d" . helpful-at-point)
         ("C-h F" . helpful-function))
  )

(use-package vundo
  :defer t
  :commands vundo
  :bind (("C-x u" . vundo)
         ; C-? was bound to undo-redo
         ("C-?" . vundo)
         )
  )


;; https://emacsredux.com/blog/2026/04/07/stealing-from-the-best-emacs-configs/
;; If you create a file that starts with #! (a shebang line), it should be executable. But
;; you always forget to chmod +x it, run the script, get “Permission denied”, curse, go
;; back, chmod, try again. This hook does it automatically:
(add-hook 'after-save-hook
          #'executable-make-buffer-file-executable-if-script-p)


;; With winner-mode and a small wrapper, you can make C-x 1 toggle: press it once to go
;; single-window, press it again to restore the previous layout.
;; winner-mode also gives C-c <left> and C-c <right> to step through window layouts.
(winner-mode +1)
(defun toggle-delete-other-windows ()
  "Delete other windows in frame if any, or restore previous window config."
  (interactive)
  (if (and winner-mode
           (equal (selected-window) (next-window)))
      (winner-undo)
    (delete-other-windows)))
(global-set-key (kbd "C-x 1") #'toggle-delete-other-windows)

;; (add-to-list 'treesit-language-source-alist
;;              '(typst "https://github.com/uben0/tree-sitter-typst"))

;; GJL 2026-08-08 11:40
;; I would like to use this. But it requires installing another .el file for support.
;; So maybe later
;; (add-to-list
;;  'treesit-language-source-alist
;;  '(typst "https://github.com/SeniorMars/tree-sitter-typst" "main"))
