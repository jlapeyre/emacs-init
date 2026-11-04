;;; openqasm3-mode.el --- major mode for editing OpenQASM 3. -*- coding: utf-8; lexical-binding: t; -*-

;; This file is not part of GNU Emacs.

;; create the list for font-lock.
;; each category of keyword is given a particular face
(setq openqasm3-font-lock-keywords
      (let* (
             ;; define several category of keywords
             (x-keywords '("break" "continue" "else" "for" "if" "return" "while" "const" "reset" "measure"
                           "barrier" "delay"
                           "gate" "def" "defcal" "defcalgrammar"
                           "extern"))
            (x-types '("float" "int" "uint"  "complex" "angle" "duration" "stretch" "bit" "bool" "qubit" "array"))
            (x-constants '("ACTIVE" "AGENT" "ALL_SIDES" "ATTACH_BACK"))
            (x-events '("include" "OPENQASM"))
;            (x-events '("at_rot_target" "at_target" "attach"))
;            (x-functions '("llAbs" "llAcos" "llAddToLandBanList" "llAddToLandPassList"))

            ;; generate regex string for each category of keywords
            (x-keywords-regexp (regexp-opt x-keywords 'words))
            (x-types-regexp (regexp-opt x-types 'words))
            (x-constants-regexp (regexp-opt x-constants 'words))
            (x-events-regexp (regexp-opt x-events 'words))
;            (x-functions-regexp (regexp-opt x-functions 'words))
            )

        `(
          (,x-types-regexp . 'font-lock-type-face)
;          (,x-constants-regexp . 'font-lock-constant-face)
;          (,x-events-regexp . 'font-lock-builtin-face)
;          (,x-functions-regexp . 'font-lock-function-name-face)
          (,x-keywords-regexp . 'font-lock-keyword-face)
          ;; note: order above matters, because once colored, that part won't change.
          ;; in general, put longer words first
          )))

;;;###autoload
(define-derived-mode openqasm3-mode c-mode "openqasm3-mode"
  "Major mode for editing OpenQASM 3 code"
 ;; :syntax-table nil ; don't want this i think
    ;; code for syntax highlighting
  (setq font-lock-defaults '((openqasm3-font-lock-keywords)))
  )

;; add the mode to the `features' list
(provide 'openqasm3-mode)

;;; mylsl-mode.el ends here
