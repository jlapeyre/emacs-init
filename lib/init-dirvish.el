(use-package dirvish
  :init
  (dirvish-override-dired-mode)
  :config
  (setq dirvish-attributes '(vc-state subtree-state file-size file-time))
  ;;(setq dirvish-attributes '(nerd-icons vc-state subtree-state file-size file-time))
  )
