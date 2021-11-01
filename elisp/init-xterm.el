;;; -*- lexical-binding: t -*-

(straight-use-package 'clipetty)
(add-hook 'after-init-hook 'global-clipetty-mode)
(global-set-key (kbd "M-w") 'clipetty-kill-ring-save)

(provide 'init-xterm)
