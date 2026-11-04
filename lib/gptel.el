;;; -*- lexical-binding: t; -*-

(use-package gptel
  :defer t
  :config ;; GJL changed from :init to :config
  (load (expand-file-name "private/openai-key.el" user-emacs-directory) t 'nomessage)
  (setq gptel-default-mode 'org-mode)
  (setq gptel-model 'gpt-5)
  (setq gptel-directives
      '((default . "You are a large language model living in Emacs org mode, and a helpful assistant. Respond concisely. Code should use org-mode code fences: with '#+begin_src lang' and '#+end_src lang', where 'lang' is python, rust, julia, elisp, etc. Don't write more than 5 or so lines of code unless asked. When you write code, put one statement on each line. Don't write more than one statement on a line, separating them with semicolons. If the syntax requires a semicolon, put one after a statement, then a newline. The code you write should follow roughly what most style guides would suggest.")
        (programming . "You are a large language model and a careful programmer. Provide code and only code as output without any additional text, prompt or note.")
        (writing . "You are a large language model and a writing assistant. Respond concisely.")
        (chat . "You are a large language model and a conversation partner. Respond concisely.")
        (computer . "You are an LLM living in emacs org mode. Respond concisely. Code should use org-mode code fences: with '#+begin_src lang' and '#+end_src lang', where 'lang' is python, rust, julia, elisp, etc. Do not write more than a few, about 5, lines of code, unless I explicitly ask for it. Focus on my questions and what we are trying to solve. Avoid extra information unless I ask. When you write code, put one statement on each line. Don't write more than one statement on a line separated by semicolons. The code you write should follow roughly what most style guides would suggest.")))
  :bind (("C-c g" . gptel-mode)
         ("C-c m" . gptel-menu)
         ("C-c a" . gptel-add))
  )

(defun my/gptel-mode-setup ()
  (visual-line-mode 1)
  (require 'files-x) ;; needed for my/gptel-mode-auto
  (setq gptel-expert-commands t) ;; show more options in gptel-menu
  )

(add-hook 'gptel-mode-hook #'my/gptel-mode-setup)

;; Now that we autoload gptel-mode, the check that gptel-mode is bound will fail.
;; So we omit the check and simply call the function `gptel-mode`.
;; Add a header to the file that does stuff upon opening
;; Like this -->  # -*- eval: (and (fboundp 'gptel-mode) (gptel-mode 1)); -*-
;; I can't find a name for this line.
(defun my/gptel-mode-auto ()
  "Ensure that this file opens with `gptel-mode' enabled."
  (message "Running my/gptel-mode-auto in buffer %s" (buffer-name))
  (condition-case err
      (save-excursion
        (modify-file-local-variable-prop-line
         'eval nil 'delete)
        (add-file-local-variable-prop-line
         'eval
         ;;'(and (fboundp 'gptel-mode) (gptel-mode 1))
         '(gptel-mode 1)
         ))
    (error (message "%S" err))))

(add-hook 'gptel-save-state-hook #'my/gptel-mode-auto)

;;(setq-local gptel-model "gpt-5"))

;; (add-to-list 'safe-local-variable-values
;;              '(eval (and (fboundp 'gptel-mode) (gptel-mode 1))))

(add-to-list 'safe-local-variable-values
             '(eval (gptel-mode 1)))
