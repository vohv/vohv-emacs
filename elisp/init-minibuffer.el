;;; -*- lexical-binding: t -*-

(straight-use-package 'orderless)
(straight-use-package 'vertico)
(straight-use-package 'embark)
(straight-use-package 'consult)
(straight-use-package 'embark-consult)
(straight-use-package 'marginalia)
(straight-use-package 'projectile)

(require 'vertico)
(add-hook 'after-init-hook 'vertico-mode)

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

(define-key color-rg-mode-map (kbd "g") 'color-rg-recompile)
(define-key color-rg-mode-map (kbd "n") 'color-rg-jump-next-keyword)
(define-key color-rg-mode-map (kbd "p") 'color-rg-jump-prev-keyword)

(defun +color-rg-dwim ()
  (interactive)
  (cond ((equal current-prefix-arg '(4))
         (color-rg-search-symbol))
        ((equal current-prefix-arg '(16))
         (color-rg-search-symbol-in-current-file))
        (t
         (color-rg-search-symbol-in-project))
        ))
(global-set-key [remap rgrep] '+color-rg-dwim)

;;; rg.el
;; (straight-use-package 'rg)
;; (global-set-key (kbd "C-c s") #'rg-menu)
;; (setq rg-custom-type-aliases '(("cc" . "*.c *.h *.hpp *.cpp *.cc")))
;; (with-eval-after-load 'rg)
;;
;; (require 'rg-isearch)
;; (define-key isearch-mode-map (kbd "M-s r") 'rg-isearch-menu)
;; (global-set-key [remap rgrep] 'rg-dwim)
;;
;; (setq wgrep-auto-save-buffer t)

(provide 'init-minibuffer)
