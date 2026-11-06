;;; init-org.el --- Org mode  -*- lexical-binding: t; -*-

;; I am using pdf-tools. So opening pdf's in emacs is nice.
;; viking is lightweight for viewing gps tracks
(defvar my/gpx-viewer (getenv "GPX_VIEWER"))
;;;* ORG MODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; ORG
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq org-default-notes-file "~/git/org/refile.org")

;; (setq org-agenda-include-diary t)
;; (setq org-agenda-diary-file "~/git/org/specialdates.org")

;; The diary file is in .emacs.d It has a line to include
;; a diary file also in .emacs.d. This was created by icalendar-import-file
(with-eval-after-load 'org-agenda
  (setq org-agenda-include-diary t)
  (setq org-agenda-diary-file "~/git/org/specialdates.org"))

;; Are these doing anything?
;; (with-eval-after-load 'diary-lib
;;   (add-hook 'diary-list-entries-hook #'diary-include-other-diary-files)
;;   (add-hook 'diary-mark-entries-hook #'diary-mark-included-diary-files))

(setq org-file-apps '((auto-mode . emacs)
 ("\\.mm\\'" . default)
 ("\\.x?html?\\'" . default)
 ("\\.pdf\\'" . emacs)
 ("\\.pptx\\'" . "libreoffice %s")
 ("\\.gpx\\'" . (start-process "gpx-viewer" nil my/gpx-viewer file))))

(setq org-directory "~/git/org")

(setq org-use-speed-commands t)

;; exact search and text search do not seem to work
(setq org-link-search-must-match-exact-headline nil)

;; Cleaner view
(setq org-hide-leading-stars t)

; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets
(setq org-refile-use-outline-path t)

; Complete the full path in one step
(setq org-outline-path-complete-in-steps nil)


; Use the current window for indirect buffer display
(setq org-indirect-buffer-display 'current-window)

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)

;;(global-set-key (kbd "C-c a") 'org-capture)  ;; this interferes with tag search commands
(bind-key "C-c z" #'org-capture)
(bind-key "<f12>" #'org-agenda)
;; switch among org mode buffers
(bind-key "C-c b" #'org-switchb)
(defun my/find-todo-org ()
  (interactive)
  (find-file "~/git/org/todo.org"))
(bind-key "<S-f12>" #'my/find-todo-org)
(defun my/find-physprojects-org ()
  (interactive)
  (find-file "~/git/org/physprojects.org"))
(bind-key "C-<f12>" #'my/find-physprojects-org)

;; Show lot of clocking history so it's easy to pick items off the C-F11 list
;; Why does this not work ! Often, these disappear, or several are missing
(setq org-clock-history-length 50)
;; Resume clocking task when emacs is restarted
(setq org-clock-persist 'history)

;; Agenda clock report parameters
(setq org-agenda-clockreport-parameter-plist
      (quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))


;; format string used when creating CLOCKSUM lines and when generating a
;; time duration (avoid showing days)
;; We can also configure this to print fractions of an hour rather than minutes
(setq org-duration-format
      '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))


;; Go to clocked item
;; overwrites full screen frame
(bind-key "<f11>" #'org-clock-goto)

(setq org-clock-out-remove-zero-time-clocks t)

;; Clock in an item
(bind-key "C-<f11>" #'org-clock-in)

;; go to beginning and end, except for headline stars
(setq org-special-ctrl-a/e t)

;; No, don't like this at the moment
;; follow hyperlinks with RETURN
(setq org-return-follows-link nil)

(setq org-log-done t
      org-todo-keywords '((sequence "TODO(t!)" "INPROGRESS(i!)" "WAITING(w!)" "|" "DONE(d!)" "CANCELLED(c!)")
                          (sequence "|" "CANCELLED(c!)"))
      org-todo-keyword-faces '(("INPROGRESS" . (:foreground "blue" :weight bold))
                               ("WAITING" :foreground "orange" :weight bold)
                               ("CANCELLED" :foreground "forestgreen" :weight bold)))

;; This makes some tasks blocked if they have not done subtasks
(setq org-enforce-todo-dependencies t)

;; Dim or grey out blocked tasks in the agenda. Or make them invisible.
;; Default is t
;;(setq org-agenda-dim-blocked-tasks t)
(setq org-agenda-dim-blocked-tasks 'invisible)

;; I was using these. But I don't think I will continue
;; #+TODO: IGNORANT(!) KNOW1 KNOW2 KNOW3 | DONE_WITH_INTRO(!)

;; BH
;; I use priorities A-E where tasks without a specific priority are lowest priority E.
(setq org-enable-priority-commands t)
(setq org-default-priority ?E)
(setq org-lowest-priority ?E)

;; BH
;; The following setting creates a unique task ID for the heading
;; in the PROPERTY drawer when I use C-c l. This allows me to move
;; the task around arbitrarily in my org files and the link to it
;; still works.
;; Be careful about what this means. I must first create the ID
;; with C-c l. Then C-c C-l will use this ID when creating a link
;; Store the link
(bind-key "C-c l" #'org-store-link)
;; use the ID when storing
(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

;; I set up org-mode to generate unique attachment IDs with org-id-method as follows:
(setq org-id-method (quote uuidgen))

;; Done in each org buffer
(defun my/org-mode-setup ()
  (visual-line-mode 1))
(add-hook 'org-mode-hook #'my/org-mode-setup)

;; Done once, when org is loaded
(with-eval-after-load 'org
  (org-link-set-parameters
   "zathura"
   :follow (lambda (path) (start-process "zathura" nil "zathura" path))
   :complete (lambda () (read-file-name "Zathura file: "))
   :face 'org-link)
  (load "extra-holidays") ;; Holidays for Spain, Catalunya, etc.
  (require 'org-clock)
  (require 'org-timer)
  (org-clock-persistence-insinuate)
  (require 'org-id)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.2))) ; Change 2.0 to your preferred scale.

;; Copied verbatim from Bernt Hansen's web page
;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/git/org/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/git/org/refile.org")
               "* TODO Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/git/org/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("l" "Journal and Link" entry (file+datetree "~/git/org/diary.org")
               "* %?\nlinkback: %a\n%U\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/git/org/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/git/org/refile.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file "~/git/org/refile.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file "~/git/org/refile.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/git/org/refile.org")
               "* TODO %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: TODO\n:END:\n"))))

;; From Bernt Hansen. A crontab runs on the hour to do a git commit.
;; This causes several things to be loaded at runtime
;; (run-at-time "00:58" 3600 (lambda () (when (fboundp 'org-save-all-org-buffers)
;;                                        (org-save-all-org-buffers))))
;;; Subheadings do not inherit tags in higher levels
;;; I don't want them showing up in searches
(setq org-use-tag-inheritance nil)

;; org-global-tags-completion-table is not interactive, but the net seems to think it is.
;; So, here is someones function that I found.
(defun my/org-get-all-tags-list ()
    (interactive)
    (mapcar 'car (org-global-tags-completion-table)))

;;; From beautifying org mode web post

;; Use bold font for *word*, etc.
(setq org-hide-emphasis-markers t)

; Use "•" for -
(font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;; From https://zzamboni.org/post/my-emacs-configuration-with-commentary/
(use-package org-bullets
  :after org
  :hook
  (org-mode . (lambda () (org-bullets-mode 1))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; END MAIN ORG CONFIGURATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/org-time-diff-point-and-mark ()
  "Compute the time difference in hours between the dates at point and mark."
  (interactive)
  (let* ((point-date (org-element-context))
         (mark-date (save-excursion
                      (goto-char (mark))
                      (org-element-context)))
         (point-time (org-element-property :raw-value point-date))
         (mark-time (org-element-property :raw-value mark-date)))
    (if (and point-time mark-time)
        (let* ((date1 (org-time-string-to-time point-time))
               (date2 (org-time-string-to-time mark-time))
               (hours (/ (- (float-time date1) (float-time date2) ) (* 60.0 60.0)) ))
          (message "Difference: %.2f hours" (abs hours)))
      (message "Please make sure both point and mark are on date entries."))))

;; Some org files set these faces as a file-local variable; ignore it without asking
(add-to-list 'ignored-local-variable-values
             '(org-todo-keyword-faces ("PROG" . "orange") ("CANCELLED" . "gray")))

(defun my/apply-org-faces (&rest _)
  (custom-theme-set-faces
   'user
   '(org-block ((t (:inherit fixed-pitch))))
   '(org-code ((t (:inherit (shadow fixed-pitch)))))
   '(org-document-info ((t (:foreground "dark orange"))))
   '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
   '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
   '(org-link ((t (:foreground "royal blue" :underline t))))
   '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-property-value ((t (:inherit fixed-pitch))))
   '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
   '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
   '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))))

(with-eval-after-load 'org
  (my/apply-org-faces))

(advice-add 'load-theme :after #'my/apply-org-faces)
