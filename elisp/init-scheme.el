;;; -*- lexical-binding: t -*-

(straight-use-package 'geiser)
(straight-use-package 'macrostep-geiser)
(straight-use-package 'geiser-guile)
(straight-use-package 'flycheck-guile)

(add-hook 'scheme-mode-hook 'rainbow-delimiters-mode)
(add-hook 'geiser-mode-hook 'macrostep-geiser-setup)
(add-hook 'geiser-repl-mode-hook 'macrostep-geiser-setup)

(defun +scheme/open-repl ()
  "Open the Scheme REPL."
  (interactive)
  (call-interactively #'switch-to-geiser)
  (current-buffer))

(setq scheme-program-name "guile")
(setq geiser-default-implementation 'guile)

(provide 'init-scheme)
