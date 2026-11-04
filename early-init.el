;; early-init.el --- Early initialization  -*- lexical-binding: t -*-

;; Duplicates same perf opt done later.
;; (defvar centaur--file-name-handler-alist file-name-handler-alist)
;; (setq file-name-handler-alist nil)

;; Big performance increase from this
(setq gc-cons-threshold most-positive-fixnum)
(setq gc-cons-percentage 0.6)
(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)
;; After startup, let gcmh manage GC: collect when idle, with a high
;; threshold while busy. Without gcmh, fall back to a moderate threshold,
;; since a very large one makes each collection a long pause.
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-percentage 0.15)
            (if (fboundp 'gcmh-mode)
                (gcmh-mode 1)
              (setq gc-cons-threshold (* 64 1024 1024)))
            (setq file-name-handler-alist file-name-handler-alist-original)))

;; Following cuts benchmark-init time in half. From about 13ms to 7ms
;; PERF: Reduce file-name operations on `load-path'.
;; Try .elc and .el before dynamic modules (.so, .dylib), and skip .gz.
;; This lasts for the whole session, so the module suffixes must stay:
;; vterm, for example, loads vterm-module.so.
(setq load-suffixes (append '(".elc" ".el")
                            (remove ".elc" (remove ".el" load-suffixes)))
      load-file-rep-suffixes '(""))

;; System (linux os) package manager sometimes installs autoload code
;; in /usr/share/emacs/site-lisp. All of these are loaded by default
;; The following disables loading code in site-lisp. So if I want
;; to use packages that put code in site-lisp, one option is to
;; move or copy it to my startup files.
(setq site-run-file nil)

(defun init-load (name)
  (let* ((file (locate-user-emacs-file (format "lib/%s" name)))
         (t0 (current-time)))
    (load file t t)
    (message "init-load %s: %.3fs"
             name (float-time (time-subtract (current-time) t0)))))

;; ;;;** Inhibit the welcome buffer
(setq inhibit-splash-screen t)
;; Alternative ways
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))

;; Disable GUI elements early to prevent flickering
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Dark black background, never white
(set-face-attribute 'default nil :background "#000000")
(set-face-attribute 'default nil :height 150) ; Adjust the height as needed ; 120 is an example size (10pt)
(set-face-attribute 'mode-line nil :height 120) ; Optional: Reset mode-line size
(set-face-attribute 'mode-line-inactive nil :height 120) ; Optional: Reset inactive mode-line size
;;;** We don't want a scratch buffer
(kill-buffer "*scratch*")

;; Looks like putting this here is even faster
;; I moved loading settings till after package manager in order for it to show up in benchmark
;; Statemets below apply to loading settings much earlier.
;; Settings loaded before package manager started. So settings must not use package manager
;; This restriction is inentional.
;(init-load "settings")
