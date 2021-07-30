;;; -*- lexical-binding: t -*-

(straight-use-package 'flymake-shellcheck)

(when (executable-find "shellcheck")
  (add-hook 'sh-mode-hook 'flymake-shellcheck-load))

(provide 'init-sh)
