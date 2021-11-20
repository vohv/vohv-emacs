;;; -*- lexical-binding: t -*-

(straight-use-package 'orderless)
(straight-use-package 'vertico)
(straight-use-package 'embark)
(straight-use-package 'consult)
(straight-use-package 'embark-consult)
(straight-use-package 'marginalia)

(require 'vertico)
(vertico-mode)

(with-eval-after-load "vertico"
  (require 'orderless))

(defun +use-orderless-in-minibuffer ()
  (setq-local completion-styles '(substring orderless)))
(add-hook 'minibuffer-setup-hook '+use-orderless-in-minibuffer)

(require 'embark)
(with-eval-after-load "vertico"
  (define-key vertico-map (kbd "C-c C-o") 'embark-export)
  (define-key vertico-map (kbd "C-c C-c") 'embark-act))

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
(setq xref-show-xrefs-function #'consult-xref
      xref-show-definitions-function #'consult-xref)

(setq-default completion-in-region-function #'consult-completion-in-region)

;;; marginalia
(marginalia-mode)

(provide 'init-minibuffer)
