;;; init-utils.el --- My own commands  -*- lexical-binding: t; -*-

;;;
;;; Utils means function written by me others, with code here. Not in a package.
;;;

;;; C-c d insert-date, C-u C-c d with the time
(defun insert-date (&optional with-time)
  "Insert today's date at point, like 2026-11-05.
With a prefix argument, also insert the time, like 2026-11-05 14:30."
  (interactive "*P")
  (insert (format-time-string (if with-time "%F %R" "%F"))))
(bind-key "C-c d" #'insert-date)

;;;* Sorting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; SORTING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; These function taken from emacs wiki
(defun sort-words (reverse beg end)
  "Sort words in region alphabetically, in REVERSE if negative.
   Prefixed with negative \\[universal-argument], sorts in reverse.
   Word characters are \\w.

  The variable `sort-fold-case' determines whether alphabetic case
  affects the sort order.

  See `sort-regexp-fields'."
  (interactive "*P\nr")
  (sort-regexp-fields reverse "\\w+" "\\&" beg end))

;; Works at least for lisp symbols
(defun sort-symbols (reverse beg end)
      "Sort symbols in region alphabetically, in REVERSE if negative.
    See `sort-words'."
      (interactive "*P\nr")
      (sort-regexp-fields reverse "\\(\\sw\\|\\s_\\)+" "\\&" beg end))

(defun find-file-region (p1 p2)
  "Find file specified by characters in region. That is, find the filename in the region"
  (interactive "r")
  (find-file (buffer-substring p1 p2)))

;;;* launchers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Launchers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun kitty ()
  "launch a kitty terminal in the current directory"
  (interactive)
  (start-process "kitty" nil "kitty"))

(defun paste-primary-selection ()
  "Insert the primary selection at point."
  (interactive)
  (insert (gui-get-selection)))
(bind-key "C-c y" #'paste-primary-selection)

;;;* Exit without asking about running processes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Exit without asking about running processes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Quit Emacs without prompting to kill processes, such as shells.
;; Replaces custom code written by RSM in the early 90's: a C-x C-c wrapper that
;; cleared each process's query-on-exit flag and then called save-buffers-kill-emacs.
(setq confirm-kill-processes nil)
