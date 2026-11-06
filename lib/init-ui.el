;;; init-ui.el --- Fonts, zooming, frames, ibuffer  -*- lexical-binding: t; -*-

(setq custom-safe-themes '("ad3592425d3cc6e205aa492b2b6a8f1a86fc4d36a3963faf75b3909b94c1324a" default))

;; Make code-quoting in info a bit less ugly.
(with-eval-after-load 'info
  (set-face-attribute 'Info-quoted nil :family "Iosevka" :height 160))

;; zoom-frm (vendored in lisp/): zoom the buffer, or the whole frame
;; including the minibuffer. Use C-x, then repeated C-+ or C--.
;; C-u with a zoom command toggles between buffer and frame zooming
;; (option `zoom-frame/buffer').
(use-package zoom-frm
  :load-path "~/.emacs.d/lisp/zoom-frm"
  :commands (zoom-in/out zoom-in zoom-out)
  :bind (("C-x C-+" . zoom-in/out)
         ("C-x C--" . zoom-in/out)
         ("C-x C-=" . zoom-in/out)
         ("C-x C-0" . zoom-in/out)
         ;; shift click and shift-ctrl click
         ([S-mouse-1] . zoom-in)
         ([C-S-mouse-1] . zoom-out))
  :init
  ;; Ctrl + mouse wheel. The wheel event names differ between window
  ;; systems, so use the variables rather than fixed keys.
  (global-set-key (vector (list 'control mouse-wheel-down-event)) #'zoom-in)
  (global-set-key (vector (list 'control mouse-wheel-up-event)) #'zoom-out)
  ;; Get rid of `mouse-set-font' or `mouse-appearance-menu':
  (global-set-key [S-down-mouse-1] nil))

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
