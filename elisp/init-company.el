;;; -*- lexical-binding: t -*-

(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

(straight-use-package 'company)
(straight-use-package 'company-quickhelp)

(add-hook 'after-init-hook 'global-company-mode)
(with-eval-after-load 'company
  (define-key company-mode-map (kbd "M-/") 'company-complete)
  (define-key company-mode-map [remap completion-at-point] 'company-complete)

  (define-key company-mode-map [remap indent-for-tab-command]
    'company-indent-or-complete-common)

  (define-key company-active-map (kbd "M-/") 'company-other-backend)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-d") 'company-show-doc-buffer)
  (define-key company-active-map (kbd "M-.") 'company-show-location)

  (setq-default company-dabbrev-other-buffers 'all
                company-tooltip-align-annotations t)

  (setq company-backends (delete 'company-clang company-backends))
  (setq company-global-modes '(not erc-mode message-mode help-mode
                                   gud-mode eshell-mode shell-mode))
  (setq company-tooltip-limit 12)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 5)
  )

(global-set-key (kbd "M-C-/") 'company-complete)
(add-hook 'after-init-hook 'company-quickhelp-mode)

(provide 'init-company)
