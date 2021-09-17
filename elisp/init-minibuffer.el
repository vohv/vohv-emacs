;;; -*- lexical-binding: t -*-

(straight-use-package 'orderless)
(straight-use-package 'selectrum)
(straight-use-package 'selectrum-prescient)
(straight-use-package 'embark)
(straight-use-package 'consult)
(straight-use-package 'embark-consult)
(straight-use-package 'marginalia)

(require 'selectrum)
(require 'selectrum-prescient)
(add-hook 'after-init-hook (lambda () (selectrum-mode t)))
(add-hook 'after-init-hook (lambda () (selectrum-prescient-mode t)))

(require 'orderless)

;;; orderless
(with-eval-after-load "selectrum"
  (require 'orderless))
(defun +use-orderless-in-minibuffer ()
  (setq-local completion-styles '(substring orderless)))
(add-hook 'minibuffer-setup-hook '+use-orderless-in-minibuffer)

;;; selectrum
(require 'embark)
(with-eval-after-load "selectrum"
  (define-key selectrum-minibuffer-map (kbd "C-c C-o") 'embark-export)
  (define-key selectrum-minibuffer-map (kbd "C-c C-c") 'embark-act))

;;; embark
(with-eval-after-load "embark"
  (require 'embark-consult)
  (add-hook 'embark-collect-mode-hook 'embark-consult-preview-minor-mode))

;;; consult
(require 'consult)
(global-set-key [remap switch-to-buffer] 'consult-buffer)
(global-set-key [remap switch-to-buffer-other-window] 'consult-buffer-other-window)
(global-set-key [remap switch-to-buffer-other-frame] 'consult-buffer-other-frame)
(global-set-key [remap goto-line] 'consult-goto-line)

;;; marginalia
(add-hook 'after-init-hook 'marginalia-mode)

;;; projectile
(require 'projectile)
(setq-default consult-project-root-function 'projectile-project-root)

;;; color rg
(straight-use-package '(color-rg :type git :host github :repo "manateelazycat/color-rg"))
(require 'color-rg)

(defun +color-rg-switch-normal (origin-fun &rest args)
  (apply origin-fun args)
  (meow--switch-state 'normal))
(advice-add 'color-rg-switch-to-edit-mode :around #'+color-rg-switch-normal)

(defun +color-rg-switch-motion (origin-fun &rest args)
  (apply origin-fun args)
  (meow--switch-state 'motion))
(advice-add 'color-rg-apply-changed :around #'+color-rg-switch-motion)

(global-set-key [remap rgrep] 'color-rg-search-project-with-type)

(provide 'init-minibuffer)
