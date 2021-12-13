;;; -*- lexical-binding: t -*-

(straight-use-package 'clipetty)
(global-clipetty-mode)
(global-set-key (kbd "M-w") 'clipetty-kill-ring-save)
(unless window-system
  (xterm-mouse-mode))

(provide 'init-xterm)
