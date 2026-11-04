(use-package py-vterm-interaction
  :defer t
  :hook (python-mode . py-vterm-interaction-mode)
  :config
  ;;; Suggested:
  (setq-default py-vterm-interaction-repl-program "ipython -i")
  (setq-default py-vterm-interaction-silent-cells t)
  )
