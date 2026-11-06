;;; init-settings.el --- Built-in options and global keys  -*- lexical-binding: t; -*-

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Set fill column globally
;; Julia docs suggest 92; why not
(setq-default fill-column 92)

;;;** Comment and uncomment region quickly
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)

;;;** Show useful info in mode line
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;;;** enable y/n answers instead of yes or no
(setq use-short-answers t)

;;;** More useful frame title.
;;;** Show either a file or a buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '("" invocation-name " - " (:eval (if (buffer-file-name)
                                            (abbreviate-file-name (buffer-file-name))
                                          "%b"))))

;;;** Easy to copy region to kill ring. Maybe there is another way to do this
(global-set-key "\C-c\k" 'copy-region-as-kill)

;;;** default binding is apropos-commands
(global-set-key (kbd "C-h a") 'apropos)

;** Change font size easily. In current buffer only
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(global-set-key (kbd "C-:") 'avy-goto-char)

;; Split vertically
(setq split-width-threshold 9999)

(setq large-file-warning-threshold 100000000)

(setq recentf-max-saved-items 200)
;; By default, turning on recentf-mode checks that every file in the saved
;; list still exists. Do that check after 5 minutes of idle time instead,
;; to keep it out of startup. The list itself is still loaded at startup.
;; Must be set before recentf-mode is turned on.
(setq recentf-auto-cleanup 300)
(recentf-mode 1)

(global-set-key (kbd "C-c r") 'recentf-open)

;; Zap upto, but not including character
(global-set-key (kbd "M-z") 'zap-up-to-char)

;; Better than default dabbrev expansion.
(global-set-key (kbd "M-/") 'hippie-expand)

(global-set-key (kbd "M-s i") 'isearch-toggle-invisible)

;;(global-set-key "\C-x\g" 'goto-line)        ;; Removed Nov 2015. Had this binding since early 90's. Maybe we prefer it ?
(global-set-key (kbd "C-x g") 'goto-line)     ;; No, stay with this binding.

;; Don't insert tabs in files. Only spaces
(setq-default indent-tabs-mode nil)

;; Disable effect of [Ins] key
(define-key global-map [(insert)] nil)
(define-key global-map [(control insert)] 'overwrite-mode)

;; from better-defaults
(setq
 select-enable-clipboard t
 ;; select-enable-primary nil nil allows pasting primary selction or clipboard content to emacs with middle click
 ;; Can't find how to paste if this is t
 select-enable-primary nil
 apropos-do-all t
 mouse-yank-at-point t
 require-final-newline t
 visible-bell t
 ediff-window-setup-function 'ediff-setup-windows-plain)

(global-set-key (kbd "C-a") 'back-to-indentation)


;; TODO bind to something useful
(global-set-key (kbd "C-x C-z") nil) ; (was suspend-frame)
(global-set-key (kbd "C-z") nil) ; (was suspend-frame), maybe still useful in termial emacs

;; Theme
(add-hook 'emacs-startup-hook
          (lambda ()
            (load-theme 'deeper-blue t)
            (set-face-attribute 'default nil :background "#000000")))

;; Show trailing whitespace and delete trailing whitespace on save
(set-face-attribute 'trailing-whitespace nil :background "yellow")
(dolist (hook '(prog-mode-hook text-mode-hook))
  (add-hook hook
            (lambda ()
              (setq show-trailing-whitespace t)
              (add-hook 'before-save-hook #'delete-trailing-whitespace nil t))))

;; https://emacsredux.com/blog/2026/04/07/stealing-from-the-best-emacs-configs/
;;
;; If you don’t edit right-to-left languages (Arabic, Hebrew, etc.), Emacs is doing a bunch
;; of work on every redisplay cycle for nothing. These settings tell Emacs to assume
;; left-to-right paragraphs everywhere and skip the bidirectional parenthesis algorithm.
;;
;; The blog post also sets bidi-display-reordering to 'left-to-right. That variable is
;; really t or nil, and any non-nil value means reordering stays on, so it is omitted.
(setq-default bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)

;; Emacs normally fontifies (syntax-highlights) text even while you’re actively typing. This
;; can cause micro-stutters, especially in tree-sitter modes or large buffers. One setting
;; fixes it:
(setq redisplay-skip-fontification-on-input t)
;; Emacs will defer fontification until you stop typing. In practice you never notice the
;; delay – the highlighting catches up instantly – but scrolling and typing may feel
;; smoother.

;; The default read-process-output-max is 64KB, which is still quite conservative. Modern
;; LSP servers like rust-analyzer or clangd routinely send multi-megabyte responses. Bumping
;; this reduces the number of read calls Emacs has to make:
(setq read-process-output-max (* 1024 1024)) ; MB
;; Reader comments that 1MB is better than 4MB
;;(setq read-process-output-max (* 4 1024 1024)) ; 4MB

;; Here’s a scenario: you copy a URL from your browser, switch to Emacs, kill a line with
;; C-k, and then try to yank the URL you copied earlier with C-y. Gone. The kill replaced it
;; on the clipboard.
;; This setting makes Emacs save the existing clipboard content into the kill ring before
;; overwriting it:
(setq save-interprogram-paste-before-kill t)
;; Now C-y gets the kill, and M-y gets you back to the URL. Such a small thing, but it
;; eliminates a genuinely annoying problem.

;; When you split a window with C-x 2 or C-x 3, Emacs halves the current window. If you
;; already have a multi-window layout, this can produce one awkwardly tiny window while
;; others stay large. With this setting, all windows in the frame resize proportionally:
(setq window-combination-resize t)


;; When you press C-h f or C-h v, Emacs opens the help buffer but leaves your cursor in the
;; original window. You almost always want to read the help right away, so you end up
;; pressing C-x o every single time. This fixes it:
(setq help-window-select t)

;; Optimize `auto-mode-alist'
(setq auto-mode-case-fold nil)

;;;* Save place in files across sessions
;;;
(use-package saveplace
  :init
  (save-place-mode 1))

(with-eval-after-load 'calendar
  (setq calendar-latitude 41.4)
  (setq calendar-longitude 2.2)
  (setq calendar-location-name "Barcelona"))

;; On macOS the default uses `open', which goes to the system default browser.
(unless (eq system-type 'darwin)
  (setq browse-url-browser-function 'browse-url-generic
        browse-url-generic-program "firefox"))
