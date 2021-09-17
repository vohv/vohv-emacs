;;; -*- lexical-binding: t -*-

(straight-use-package 'orderless)
(straight-use-package 'vertico)
(straight-use-package 'savehist)
(straight-use-package 'embark)
(straight-use-package 'consult)
(straight-use-package 'embark-consult)
(straight-use-package 'marginalia)
(straight-use-package 'affe)


(add-hook 'after-init-hook 'vertico-mode)

(require 'orderless)
(with-eval-after-load "vertico"
  (require 'orderless))

(defun +use-orderless-in-minibuffer ()
  (setq-local completion-styles '(substring orderless)))

(add-hook 'minibuffer-setup- '+use-orderless-in-minibuffer)

(require 'embark)
(with-eval-after-load "vertico"
  (define-key vertico-map (kbd "C-c C-o") 'embark-export)
  (define-key vertico-map (kbd "C-c C-c") 'embark-act)
  )

(require 'consult)

(require 'projectile)
(setq-default consult-project-root-function 'projectile-project-root)

(require 'affe)
(when (executable-find "rg")
  (defun +affe-grep-at-point (&optional dir initial)
    (interactive (list prefix-arg (when-let ((s (symbol-at-point)))
                                    (symbol-name s))))
    (affe-grep dir initial))
  ;; (global-set-key [remap rgrep] '+affe-grep-at-point)
  )

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

(global-set-key [remap switch-to-buffer] 'consult-buffer)
(global-set-key [remap switch-to-buffer-other-window] 'consult-buffer-other-window)
(global-set-key [remap switch-to-buffer-other-frame] 'consult-buffer-other-frame)
(global-set-key [remap goto-line] 'consult-goto-line)

(with-eval-after-load "embark"
  (require 'embark-consult)
  (add-hook 'embark-collect-mode-hook 'embark-consult-preview-minor-mode))

(add-hook 'after-init-hook 'marginalia-mode)

(provide 'init-minibuffer)
