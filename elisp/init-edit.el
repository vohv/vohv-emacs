;;; -*- lexical-binding: t -*-

(straight-use-package 'smartparens)

(require 'smartparens-config)

(add-hook 'prog-mode-hook #'smartparens-mode)

(straight-use-package 'symbol-overlay)
(dolist (hook '(prog-mode-hook html-mode-hook yaml-mode-hook conf-mode-hook))
  (add-hook hook 'symbol-overlay-mode))
(with-eval-after-load "symbol-overlay"
  (define-key symbol-overlay-mode-map (kbd "M-i") 'symbol-overlay-put)
  (define-key symbol-overlay-mode-map (kbd "M-I") 'symbol-overlay-remove-all))

;;; whitespace
(custom-set-faces
 '(trailing-whitespace ((t (:background "light gray")))))

(defun +show-trailing-whitespace ()
  (setq-local show-trailing-whitespace t))

(dolist (hook '(prog-mode-hook conf-mode-hook))
  (add-hook hook #'+show-trailing-whitespace))

(show-paren-mode 1)

(straight-use-package 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;;; huge file
(when (fboundp 'so-long-enable)
  (add-hook 'after-init-hook 'so-long-enable))
(straight-use-package 'vlf)
(require 'vlf)

(straight-use-package 'shfmt)
(add-hook 'sh-mode-hook 'shfmt-on-save-mode)
(require 'sh-script)
(with-eval-after-load "sh-script"
  (define-key sh-mode-map (kbd "C-c C-f") 'shfmt)
  )

(straight-use-package '(casease :type git :host github :repo "DogLooksGood/casease"))

(require 'casease)
(casease-setup
 :hook c-mode-common-hook
 :separator ?=
 :entries
 ((pascal "\\(-\\)[a-z]" "[A-Z]")
  (snake "[a-z]")))
(provide 'init-edit)
