;;; -*- lexical-binding: t -*-

(straight-use-package 'smartparens)

(require 'smartparens-config)

(add-hook 'prog-mode-hook #'smartparens-mode)

(straight-use-package 'smart-hungry-delete)
(require 'smart-hungry-delete)

(smart-hungry-delete-add-default-hooks)

(with-eval-after-load "smart-hungry-delete"
  (let (
        (map-list (list prog-mode-map text-mode-map))
        )
    (dolist (map map-list)
      (define-key map [remap delete-backward-char] 'smart-hungry-delete-backward-char)
      (define-key map [remap backward-delete-char-untabify] 'smart-hungry-delete-backward-char)
      (define-key map [remap c-electric-backspace] 'smart-hungry-delete-backward-char)
      (define-key map [remap c-electric-delete-forward] 'smart-hungry-delete-backward-char)
      ))
  )


(provide 'init-edit)
