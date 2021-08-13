;;; -*- lexical-binding: t -*-

(straight-use-package 'selectrum)
(straight-use-package 'selectrum-prescient)
(straight-use-package 'orderless)
(straight-use-package 'embark)
(straight-use-package 'consult)
(straight-use-package 'projectile)
(straight-use-package 'embark-consult)
(straight-use-package 'marginalia)
(straight-use-package 'rg)

(require 'prescient)
(selectrum-mode +1)
(prescient-persist-mode 1)
(selectrum-prescient-mode +1)

(with-eval-after-load 'selectrum
  (require 'orderless))

(defun +use-orderless-in-minbuffer ()
  (setq-local completion-styles '(substring orderless)))

(add-hook 'minibuffer-setup-hook '+use-orderless-in-minbuffer)

(require 'embark)
(with-eval-after-load "selectrum"
  (define-key selectrum-minibuffer-map (kbd "C-c C-o") 'embark-export)
  (define-key selectrum-minibuffer-map (kbd "C-c C-c") 'embark-act))

(require 'consult)
(defmacro +no-consult-preview (&rest cmds)
  `(with-eval-after-load "consult"
     (consult-customize ,@cmds :preview-key (kbd "M-e"))))

(+no-consult-preview
 consult-ripgrep
 consult-git-grep consult-grep
 consult-bookmark consult-recent-file consult-xref
 consult--source-file consult--source-project-file consult--source-bookmark)

(require 'projectile)
(setq-default consult-project-root-function 'projectile-project-root)

(defun +consult-ripgrep-dwim (&optional dir initial)
  (interactive (list prefix-arg (when-let ((s (symbol-at-point)))
                                  (symbol-name s))))
  (consult-ripgrep dir initial))

(global-set-key [remap switch-to-buffer] 'consult-buffer)
(global-set-key [remap switch-to-buffer-other-window] 'consult-buffer-other-window)
(global-set-key [remap switch-to-buffer-other-frame] 'consult-buffer-other-frame)
(global-set-key [remap imenu] 'consult-imenu)
(global-set-key [remap goto-line] 'consult-goto-line)

(with-eval-after-load "embark"
  (require 'embark-consult)
  (add-hook 'embark-collect-mode-hook 'embark-consult-preview-minor-mode))

(require 'marginalia)
(add-hook 'after-init-hook 'marginalia-mode)

(with-eval-after-load "wgrep"
  (define-key wgrep-mode-map (kbd "C-c C-c") #'wgrep-finish-edit)
  (setq wgrep-auto-save-buffer t))

(defun my--push-point-to-xref-marker-stack (&rest r)
  (xref-push-marker-stack (point-marker)))
(dolist (func '(find-function
                projectile-grep
                citre-jump
                consult-imenu
                consult-ripgrep))
  (advice-add func :before 'my--push-point-to-xref-marker-stack))

(provide 'init-minibuffer)
