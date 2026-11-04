;;; -*- lexical-binding: t; -*-
;;;* ORG MODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; ORG
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load (expand-file-name "lib/org_agenda_files" user-emacs-directory) 'noerror)

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
 ("\\.gpx\\'" . (concat (gpx-viewer " %s")))))

(setq org-mobile-inbox-for-pull "~/git/from-mobile.org")  ; only used for mobile org
(setq org-directory "~/git/org")  ; only used for mobile org
(setq org-mobile-directory "~/Dropbox/MobileOrg")

;; Extra commands for the agenda view
;; Took for fucking ever to get the category filtering to work. There are a *lot* of false paths and wild goose chases
;; online regarding this.
(setq org-agenda-custom-commands
      '(("n" "Agenda and all TODOs" ((agenda "") (alltodo "")))
        ("c" "calfw, calendar" gjl:calfw-open-calendar)))

(setq org-use-speed-commands t)

;; disable for debugging
(setq org-completion-use-ido t)

;; exact search and text search do not seem to work
(setq org-link-search-must-match-exact-headline nil)

;; Cleaner view
(setq org-hide-leading-stars t)

(setq org-drawers '("PROPERTIES" "CLOCK" "LOGBOOK" "RESULTS" "RANT"))

; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
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
(global-set-key (kbd "C-c z") 'org-capture)
(global-set-key (kbd "C-c C-f") 'org-capture-finalize)
(global-set-key (kbd "<f12>") 'org-agenda)
;; switch among org mode buffers
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key (kbd "<S-f12>")
                (lambda () (interactive) (find-file "~/git/org/todo.org")))
(global-set-key (kbd "C-<f12>")
                (lambda () (interactive) (find-file "~/git/org/physprojects.org")))

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
(global-set-key (kbd "<f11>") 'org-clock-goto)

(setq org-clock-out-remove-zero-time-clocks t)

;; Clock in an item
(global-set-key (kbd "C-<f11>") 'org-clock-in)

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

;;;** Thunderlink. Modified from code given in FAQ on worg. We open thunderbird directly
(defun org-thunderlink-open (path)
  "Opens a specified email in Thunderbird with the help of the add-on ThunderLink."
                                        ;(message-box path)
  (start-process "myname" nil "thunderbird" "-thunderlink" (concat "thunderlink:" path)))
(provide 'org-thunderlink)

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
(global-set-key "\C-cl" 'org-store-link)
;; use the ID when storing
(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

;; I set up org-mode to generate unique attachment IDs with org-id-method as follows:
(setq org-id-method (quote uuidgen))

;;;** Use hook to avoid triggering loading all of org before needed.
;; The line (when (not (boundp 'org-man-command))... prevents each line in
;; the hook from being run literally 20 times. The allows org-mode to load *much* faster
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             ;; Load various org-related libraries
;;             (unless (boundp 'org-man-command)
;;               (load-library "org-man")
;;               (load "extra-holidays.el")
;;               (load-library "calfw")
;;               (load-library "org-clock")
;;               (load-library "org-timer")
;;               (org-clock-persistence-insinuate)
;;               (require 'org-id)
;;               (require 'org-journal))

;;             ;; Define custom link type for zathura
;;             (org-link-set-parameters
;;              "zathura"
;;              :follow (lambda (path)
;;                        (start-process "zathura" nil "zathura" path))
;;              :complete (lambda ()
;;                          (read-file-name "Zathura file: "))
;;              :face 'org-link)))


(add-hook 'org-mode-hook (lambda ()
                           (progn
                             (visual-line-mode 1)
                             (org-link-set-parameters
                                "zathura"
                                :follow (lambda (path) (start-process "zathura" nil "zathura" path))
                                :complete (lambda () (read-file-name "Zathura file: "))
                                :face 'org-link)
                             (when (not (fboundp 'cfw:open-calendar-buffer))
                               ;(load-library "org-man.el") ; Figure this out later. Different files with same version number appear
                               (load "extra-holidays.el") ;; Holidays for Spain, Catalunya, etc.
                               ;; Allow linking to man pages. This was copied and pasted to my hand-rolled dir.
                               (load-library "calfw")     ;; Show a paper-like calendar
                               (load-library "org-clock") ; doesn't help
                               (load-library "org-timer") ; doesn't help
                               (org-clock-persistence-insinuate)
                               (require 'org-id)
                               (lambda () (require 'org-journal))
                               (org-link-set-parameters "thunderlink" 'org-thunderlink-open)
                               (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.2)) ; Change 2.0 to your preferred scale.
                               ))))


;; C-c C-j is already taken by org-goto. Can't find where or how this happens
                                  ;; So we choose a different binding for org-journal-new-entry.
                                  ;; But, wait, this will not do the clock-in clock-out thing that
                                  ;; Hansen's capture template does.
                                  ;; For the moment, we are using using capture template for journal
                                  ;; rather than org-journal
;; This is broken anyway, called too soon
;;                                  (define-key org-journal-mode-map (kbd "C-c j") 'org-journal-new-entry))))


;; helper function for launching calfw from agenda view
(defun gjl:calfw-open-calendar (&args)
  (interactive)
  (when (not (fboundp 'cfw:open-calendar-buffer))
    (progn (load-library "calfw") (load-library "calfw-org")))
  (cfw:open-calendar-buffer))

;; Calfw Unicode characters for frame
;; This looks better.
;; (setq cfw:fchar-junction ?╋
;;       cfw:fchar-vertical-line ?┃
;;       cfw:fchar-horizontal-line ?━
;;       cfw:fchar-left-junction ?┣
;;       cfw:fchar-right-junction ?┫
;;       cfw:fchar-top-junction ?┯
;;       cfw:fchar-top-left-corner ?┏
;;       cfw:fchar-top-right-corner ?┓)

;; Another lookf for calfw
(setq cfw:fchar-junction ?╬
      cfw:fchar-vertical-line ?║
      cfw:fchar-horizontal-line ?═
      cfw:fchar-left-junction ?╠
      cfw:fchar-right-junction ?╣
      cfw:fchar-top-junction ?╦
      cfw:fchar-top-left-corner ?╔
      cfw:fchar-top-right-corner ?╗)

(setq cfw:org-overwrite-default-keybinding t)

;; Copied verbatim from Bernt Hansen's web page
;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/git/org/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/git/org/refile.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
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
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

;; From Bernt Hansen. A crontab runs on the hour to do a git commit.
;; This causes several things to be loaded at runtime
;; (run-at-time "00:58" 3600 (lambda () (when (fboundp 'org-save-all-org-buffers)
;;                                        (org-save-all-org-buffers))))
;;; Subheadings do not inherit tags in higher levels
;;; I don't want them showing up in searches
(setq org-use-tag-inheritance nil)

;; org-global-tags-completion-table is not interactive, but the net seems to think it is.
;; So, here is someones function that I found.
(defun org-get-all-tags-list ()
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

;; (use-package org-modern
;;   :ensure t
;;   :hook (org-mode . org-modern-mode)
;;   :custom
;;   (org-modern-table t))   ; Unicode table lines


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

(add-to-list 'ignored-local-variable-values
             '(org-todo-keyword-faces ("PROG" . "orange") ("CANCELLED" . "gray")))

(defun my/apply-org-faces ()
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

(advice-add 'load-theme :after (lambda (&rest _) (my/apply-org-faces)))
