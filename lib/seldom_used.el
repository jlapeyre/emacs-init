;;; -*- lexical-binding: t; -*-
;; Using zathura
;; Note that this runs nevince, which runs nohup so the command does not block emacs
(defun evince-on-current-file ()
  "Run evince on the current file (from Dired or buffer)."
  (interactive)
  (let* ((file (or (and (derived-mode-p 'dired-mode)
                        (dired-get-file-for-visit))
                   (buffer-file-name)))
         (command (format "nevince \"%s\"" file)))
    (unless file
      (error "No file associated with point"))
    ;; Close the buffer if visiting the file
    (when (and (buffer-file-name)
               (string-equal file (buffer-file-name)))
      (kill-buffer))
    ;; Run the shell command
    (shell-command command)))

(autoload 'maxima-mode "maxima" "Maxima mode" t)
(autoload 'maxima "maxima" "Maxima interaction" t)
(add-to-list 'auto-mode-alist '("\\.mac$" . maxima-mode))

;; November 2018. Do not start this by default. Saves 10-20 ms
;; Default buffer is a shell.
;; Following was added by rsm in the early 90's
;; This line starts up a shell, and is rather long due to (something Ed did or did not do !)
;; (shell)
;; (rename-buffer "dired-synced-shell") ;  Nov 2015 change name to dired-synced-shell
;; (switch-to-buffer "dired-synced-shell")

;; Sync a shell in buffer with dired.
;; This doesn't work for switching to a dired buffer that already exists. Workaround: press g to refresh the buffer.
;; http://emacs.stackexchange.com/questions/5676/how-can-i-keep-dired-in-sync-with-a-shell-buffer
;; GJL added the (let* ... construction.

(use-package shell-pop
  :bind ("C-t" . shell-pop)
  :init
  (setq shell-pop-shell-type '("ansi-term" "*ansi-term*"
                               (lambda nil (ansi-term shell-pop-term-shell))))
  ;;   ;; need to do this manually or not picked up by `shell-pop'
  ;;   (shell-pop--set-shell-type 'shell-pop-shell-type shell-pop-shell-type))
  (setq shell-pop-term-shell "/bin/zsh"))

