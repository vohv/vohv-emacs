;;; -*- lexical-binding: t -*-

(straight-use-package 'clipetty)
(global-clipetty-mode)
(global-set-key (kbd "M-w") 'clipetty-kill-ring-save)

(provide 'init-xterm)
