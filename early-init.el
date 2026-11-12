;; early-init.el --- Early initialization  -*- lexical-binding: t -*-

(setq load-no-native t)

(defvar my/t0 (current-time))
(defvar my/startup-log nil)
(defun my/mark (what)
  (push (format "%7.3f  %s" (float-time (time-since my/t0)) what)
        my/startup-log))

(defun my/log-call-process (orig program &rest args)
  (let ((t1 (current-time)))
    (prog1 (apply orig program args)
      (my/mark (format "call-process %s %S (%.3fs)" program
                       (nthcdr 3 args) (float-time (time-since t1)))))))
(defun my/log-make-process (orig &rest args)
  (my/mark (format "make-process %S" (plist-get args :command)))
  (apply orig args))
(advice-add 'call-process :around #'my/log-call-process)
(advice-add 'make-process :around #'my/log-make-process)

(add-hook 'after-init-hook (lambda () (my/mark "after-init done")))
(add-hook 'emacs-startup-hook (lambda () (my/mark "emacs-startup-hook")))
(add-hook 'window-setup-hook
  (lambda ()
    (my/mark "window-setup (end)")
    (advice-remove 'call-process #'my/log-call-process)
    (advice-remove 'make-process #'my/log-make-process)
    (when (> (float-time (time-since my/t0)) 2.0)
      (with-temp-buffer
        (insert (mapconcat #'identity (reverse my/startup-log) "\n") "\n")
        (write-region nil nil
          (no-littering-expand-var-file-name
           (format-time-string "startup-trace-%F-%H%M%S.txt"))
          nil 'silent))))
  90)

(defun my/show-startup-log ()
  (interactive)
  (with-current-buffer (get-buffer-create "*startup-trace*")
    (erase-buffer)
    (insert (mapconcat #'identity (reverse my/startup-log) "\n") "\n")
    (display-buffer (current-buffer))))

;; Big performance increase from this
(setq gc-cons-threshold most-positive-fixnum)
(setq gc-cons-percentage 0.6)
;; After startup, let gcmh manage GC: collect when idle, with a high
;; threshold while busy. Without gcmh, fall back to a moderate threshold,
;; since a very large one makes each collection a long pause.
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-percentage 0.15)
            (if (fboundp 'gcmh-mode)
                (gcmh-mode 1)
              (setq gc-cons-threshold (* 64 1024 1024)))))

;; Every file operation checks `file-name-handler-alist' (for compressed
;; files, TRAMP, etc.), so empty it while loading the init files.
;; Restore it in `after-init-hook', which runs before the files named on
;; the command line are visited (`emacs-startup-hook' runs after). Keep any
;; handlers that packages added in the meantime.
(defvar my/file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'after-init-hook
          (lambda ()
            (setq file-name-handler-alist
                  (delete-dups (append file-name-handler-alist
                                       my/file-name-handler-alist-original))))
          -90)

;; Following cuts benchmark-init time in half. From about 13ms to 7ms
;; PERF: Reduce file-name operations on `load-path'.
;; Try .elc and .el before dynamic modules (.so, .dylib), and skip .gz.
;; This lasts for the whole session, so the module suffixes must stay:
;; vterm, for example, loads vterm-module.so.
(setq load-suffixes (append '(".elc" ".el")
                            (remove ".elc" (remove ".el" load-suffixes)))
      load-file-rep-suffixes '(""))
;; .elc is tried first, so load the .el instead if it is newer (e.g. after
;; editing without recompiling, see my_compile.el).
(setq load-prefer-newer t)

;; System (linux os) package manager sometimes installs autoload code
;; in /usr/share/emacs/site-lisp. All of these are loaded by default
;; The following disables loading code in site-lisp. So if I want
;; to use packages that put code in site-lisp, one option is to
;; move or copy it to my startup files.
(setq site-run-file nil)

;; Emacs activates packages after early-init.el and before init.el. With
;; quickstart, it loads one file with all packages' autoloads instead of
;; one file per package. Emacs rewrites the file after installing or
;; deleting packages with package.el.
;; Set this to nil to switch quickstart off. After switching it back on,
;; run M-x package-quickstart-refresh, since the file may be stale.
;; The path matches what no-littering sets, which loads too late for this.
(defvar my/package-quickstart t)
(when my/package-quickstart
  (setq package-quickstart t
        package-quickstart-file (locate-user-emacs-file "var/package-quickstart.el")))

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
