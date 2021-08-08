;;; -*- lexical-binding: t -*-

(straight-use-package 'smartparens)

(require 'smartparens-config)

(add-hook 'prog-mode-hook #'smartparens-mode)

(straight-use-package 'smart-hungry-delete)
(require 'smart-hungry-delete)

(smart-hungry-delete-add-default-hooks)

(with-eval-after-load "smart-hungry-delete"
  (dolist (map (list prog-mode-map text-mode-map))
    (define-key map [remap delete-backward-char] 'smart-hungry-delete-backward-char)
    (define-key map [remap backward-delete-char-untabify] 'smart-hungry-delete-backward-char)
    (define-key map [remap c-electric-backspace] 'smart-hungry-delete-backward-char)
    (define-key map [remap c-electric-delete-forward] 'smart-hungry-delete-backward-char)))



(defun +show-trailing-whitespace ()
  (setq-local show-trailing-whitespace t))

(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'+show-trailing-whitespace))

(show-paren-mode 1)

(straight-use-package 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(provide 'init-edit)
