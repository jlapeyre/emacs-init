;;; init-file-modes.el --- Major modes for assorted file types  -*- lexical-binding: t; -*-

(use-package wolfram-mode
  :ensure t
  :mode ("\\.wl\\'" "\\.wls\\'" "\\.m\\'") ; Associates Wolfram/Mathematica files
  :commands run-wolfram
  :config
  (setq wolfram-indent 4) ; Sets your preferred indentation spacing
  ;; Find the kernel on PATH, so this works on Linux and macOS. If it is not
  ;; found, wolfram-mode's default is kept; set it by hand if needed.
  (let ((kernel (or (executable-find "MathKernel") (executable-find "WolframKernel"))))
    (when kernel (setq wolfram-program kernel)))
  (setq wolfram-path (if (eq system-type 'darwin)
                         "~/Library/Mathematica/Applications"
                       "~/.Mathematica/Applications")))

;; .m files open in wolfram-mode (above), except files that start like
;; MATLAB code: a % comment, function or classdef. `magic-mode-alist' is
;; checked before `auto-mode-alist'. matlab-mode's autoloads add a rule
;; there that claims every non-empty .m file that is not Objective-C,
;; including Mathematica files, so replace it. Loading matlab-mode adds
;; the rule again, so replace it then too.
(defun my/matlab-file-p ()
  (and buffer-file-name
       (string-match-p "\\.m\\'" buffer-file-name)
       (looking-at-p "[[:space:]]*\\(%\\|function\\_>\\|classdef\\_>\\)")))
(defun my/replace-matlab-magic-mode-rule ()
  (setq magic-mode-alist
        (cons '(my/matlab-file-p . matlab-mode)
              (delete '(my/matlab-file-p . matlab-mode)
                      (delete '(matlab-is-matlab-file . matlab-mode) magic-mode-alist)))))
(my/replace-matlab-magic-mode-rule)
(with-eval-after-load 'matlab-is-matlab-file
  (my/replace-matlab-magic-mode-rule))

(use-package yaml-ts-mode
  :ensure nil ; built-in in Emacs 29+
  :mode ("\\.yaml\\'" "\\.yml\\'"))

(use-package markdown-mode  ;; autoload
  :mode ("\\.md\\'" . markdown-mode))

(dolist (pair '(("\\.plt$" . gnuplot-mode) ("\\.gp$" . gnuplot-mode)))
  (add-to-list 'auto-mode-alist pair))

;; these lines enable the use of gnuplot mode
(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot mode" t)

(autoload 'openqasm3-mode "openqasm3-mode" "OpenQASM3 major mode" t)
(add-to-list 'auto-mode-alist '("\\.qasm$" . openqasm3-mode))

;; Autoload the mode only when opening .typ files
(autoload 'typst-ts-mode "typst-ts-mode" "Major mode for Typst files." t)
;; Associate .typ files with typst-ts-mode
(add-to-list 'auto-mode-alist '("\\.typ$" . typst-ts-mode))
