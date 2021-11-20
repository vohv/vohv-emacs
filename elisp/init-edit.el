;;; -*- lexical-binding: t -*-

(straight-use-package 'smartparens)

(require 'smartparens-config)

(add-hook 'prog-mode-hook #'smartparens-mode)
(add-hook 'lisp-interaction-mode-hook #'smartparens-mode)

(straight-use-package 'symbol-overlay)
(dolist (hook '(prog-mode-hook html-mode-hook yaml-mode-hook conf-mode-hook))
  (add-hook hook 'symbol-overlay-mode))
(with-eval-after-load "symbol-overlay"
  (define-key symbol-overlay-mode-map (kbd "M-i") 'symbol-overlay-put)
  (define-key symbol-overlay-mode-map (kbd "M-I") 'symbol-overlay-remove-all)
  (define-key symbol-overlay-mode-map (kbd "M-n") 'symbol-overlay-jump-next)
  (define-key symbol-overlay-mode-map (kbd "M-p") 'symbol-overlay-jump-prev))

;;; whitespace
(custom-set-faces
 '(trailing-whitespace ((t (:background "light gray")))))

(defun +show-trailing-whitespace ()
  (setq-local show-trailing-whitespace t))

(dolist (hook '(prog-mode-hook conf-mode-hook))
  (add-hook hook #'+show-trailing-whitespace))

(straight-use-package 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;;; huge file
(when (fboundp 'so-long-enable)
  (so-long-enable))
(straight-use-package 'vlf)
(require 'vlf)

(straight-use-package 'shfmt)
(add-hook 'sh-mode-hook 'shfmt-on-save-mode)
(require 'sh-script)
(with-eval-after-load "sh-script"
  (define-key sh-mode-map (kbd "C-c C-f") 'shfmt))

(provide 'init-edit)
