;;; init.el --- Emacs configuration -*- lexical-binding: t; -*-

(my/mark "init.el start")

;(set-face-attribute 'default nil :height 150) ; Adjust the height as needed ; 120 is an example size (10pt)a

;; Optimize `auto-mode-alist'
(setq auto-mode-case-fold nil)

;; PERF: Restore file-name-handler-alist after startup.
;; It was set to nil in early-init.el for faster startup.
;; (unless (or (daemonp) noninteractive init-file-debug)
;;   (add-hook 'emacs-startup-hook
;;             (lambda ()
;;               (setq file-name-handler-alist
;;                     (delete-dups (append file-name-handler-alist
;;                                          centaur--file-name-handler-alist))))
;;             101))

;;; * Set Load path
(add-to-list 'load-path "~/.emacs.d/lisp/")
;;;** handwritten, or copied, code.
(add-to-list 'load-path "~/.emacs.d/mylisp/")
(add-to-list 'load-path "~/github/meow_king/typst-ts-mode")


;;(init-load "profile_debug.el")

;;;* Start package manager
;; The first time we load this file, startup fails. You must do M-x list-packages
;; Then restart emacs.

(require 'package)
(setq package-archives '(
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ))

(setq use-package-always-defer t)
(setq use-package-verbose t)

;; (setq package-enable-at-startup nil)
;; (setq package-quickstart t)
(package-initialize)

;; Put files written by packages in var/ and etc/ rather than the top level
;; of user-emacs-directory. Load before anything that reads those paths.
;; noerror: on first startup it is not yet installed (see my-packages).
(require 'no-littering nil t)
;; Also put backup (foo~) and auto-save (#foo#) files under var/
(when (fboundp 'no-littering-theme-backups)
  (no-littering-theme-backups))

;; Prevent package.el from writing package-selected-packages noninteractively.
(with-eval-after-load 'package
  (advice-add 'package--save-selected-packages :override #'ignore))

;;;* Benchmark-init

;; Only need this enabled when we are hacking initialization
;; NOTE: We must comment this out when first installing packages, beccause benchmark-init is not yet available.

;(let ((bench (getenv "EMACS_BENCHMARK")))
(let ((bench t))
  (when (and bench (require 'benchmark-init nil t))
    (add-hook 'after-init-hook #'benchmark-init/deactivate)
    (global-set-key (kbd "C-c B") #'benchmark-init/show-durations-tabulated)
    (global-set-key (kbd "C-c C") #'benchmark-init/show-durations-tree)))

(add-hook 'emacs-startup-hook
          (lambda () (message "Total: %.3fs  Init: %s"
                              (float-time (time-subtract (current-time) before-init-time))
                              (emacs-init-time))))

(setq custom-safe-themes '("ad3592425d3cc6e205aa492b2b6a8f1a86fc4d36a3963faf75b3909b94c1324a" default))

(init-load "settings")
(init-load "init-my-packages.el")

;;;** Install or update required packages automatically
(when (not package-archive-contents)
  (package-refresh-contents))
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; Same as the loop above, as a command
(defun my/ensure-packages ()
  (interactive)
  (unless package-archive-contents (package-refresh-contents))
  (dolist (p my-packages)
    (unless (package-installed-p p) (package-install p))))

;; Cannot put this in settings.el and load in early-init.el. Causes startup error.
;; Make code-quoting in info a bit less ugly.
(with-eval-after-load 'info
  (set-face-attribute 'Info-quoted nil :family "Iosevka" :height 160))

(use-package vterm
  :commands vterm
    :ensure t)

(init-load "gptel")
(init-load "language/julia")
(init-load "language/python")
(init-load "language/lsp")

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


(use-package yaml-ts-mode
  :ensure nil ; built-in in Emacs 29+
  :mode ("\\.yaml\\'" "\\.yml\\'"))

;; This does not prevent loading pcomplete on startup
(use-package pcomplete
  :commands
  pcomplete-expand
  pcomplete-list
  pcomplete-expand-and-complete
  pcomplete-continue pcomplete-help)

;;;* Save place in files across sessions
;;;
(use-package saveplace
  :init
  (save-place-mode 1))


(init-load "init-diredp")

(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" "nzathura")
        ("\\.djvu\\'" "djview")
        ("\\.mp4\\'" "mpv")
        ("\\.sh\\'" "/bin/bash")))


(use-package markdown-mode  ;; autoload
  :mode ("\\.md\\'" . markdown-mode))

;;;* Minibuffer completion

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

;; Global change font (including minibuffer) with prefix C-u
;; zoom-frm package.  Use C-x, then repeated C-+ or C--
;; (use-package zoom-frm
;;   :commands zoom-in/out zoom-in zoom-out
;;   :load-path "~/.emacs.d/lisp/zoom-frm"
;;   :config
;;   (define-key ctl-x-map [(control ?+)] 'zoom-in/out)
;;   (define-key ctl-x-map [(control ?-)] 'zoom-in/out)
;;   (define-key ctl-x-map [(control ?=)] 'zoom-in/out)
;;   (define-key ctl-x-map [(control ?0)] 'zoom-in/out))

(use-package zoom-frm
  :load-path "~/.emacs.d/lisp/zoom-frm"
  :commands (zoom-in/out zoom-in zoom-out)
  :bind (("C-x C-+" . zoom-in/out)
         ("C-x C--" . zoom-in/out)
         ("C-x C-=" . zoom-in/out)
         ("C-x C-0" . zoom-in/out)
         ([C-mouse-5] . zoom-in)
         ([C-mouse-4] . zoom-out)
         ([S-mouse-1] . zoom-in)
         ([C-S-mouse-1] . zoom-out)))

;; Use ctrl mouse wheel to zoom
(global-set-key (vector (list 'control mouse-wheel-down-event)) 'zoom-in)
(global-set-key (vector (list 'control mouse-wheel-up-event))   'zoom-out)

;; shift click and shift-ctrl click to zoom
(global-set-key [S-mouse-1]    'zoom-in)
(global-set-key [C-S-mouse-1]  'zoom-out)
;; Get rid of `mouse-set-font' or `mouse-appearance-menu':
(global-set-key [S-down-mouse-1] nil)

;; Hit C-u at any time while using these commands zoom-in, -out to toggle between buffer
;; zooming and frame zooming. The kind of zooming (buffer or frame) you get by
;; default is defined by option zoom-frame/buffer. C-u with a zoom command
;; toggles the option.

;;;;;;;;;;;;;;;;;;;;

;; Start up maximized, on any window system.
(push '(fullscreen . maximized) default-frame-alist)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; IBUFFER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;** C-x C-b opens ibuffer in other window.
;; default C-x C-b is bound to ibuffer. We change this to open ibuffer in other windowa
(global-set-key (kbd "C-x C-b") 'ibuffer-other-window)
(setq ibuffer-default-sorting-mode 'major-mode)

;;;** ibuffer column widths
;; nearly all of this is the default layout
(setq ibuffer-formats
      '((mark modified read-only " "
              (name 30 30 :left :elide) ; change: 30s were originally 18s
              " "
              (size 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " " filename-and-process)
        (mark " "
              (name 16 -1)
              " " filename)))



(global-set-key (kbd "C-x m") 'magit-status)  ;; Overwrite compose-mail binding

(with-eval-after-load 'calendar
  (setq calendar-latitude 41.4)
  (setq calendar-longitude 2.2)
  (setq calendar-location-name "Barcelona"))

;; I am using pdf-tools. So opening pdf's in emacs is nice.
;; viking is lightweight for viewing gps tracks
(setq gpx-viewer (getenv "GPX_VIEWER"))

;; On macOS the default uses `open', which goes to the system default browser.
(unless (eq system-type 'darwin)
  (setq browse-url-browser-function 'browse-url-generic
        browse-url-generic-program "firefox"))

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

(init-load "auctex_things")

;(init-load "images")

;;(init-load "helm-bibtex")

(init-load "editor")

(init-load "org_things")

(init-load "my_utils")

(use-package paradox
  :defer t
  :config (setq paradox-github-token t))


(setq custom-file  (locate-user-emacs-file (format "lib/%s" ".emacs-custom.el")))
(init-load ".emacs-custom.el")
; (init-load "seldom_used.el")
;(init-load "nocompile.el")
