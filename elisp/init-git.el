;;; -*- lexical-binding: t -*-

(straight-use-package 'diff-hl)
(straight-use-package 'magit)
(straight-use-package 'smerge-mode)

(with-eval-after-load "magit"
  (define-key transient-base-map (kbd "<escape>") #'transient-quit-one))

(global-unset-key (kbd "C-x g"))
(global-set-key (kbd "C-x g s") 'magit-status)
(global-set-key (kbd "C-x g b") 'magit-blame)
(global-set-key (kbd "C-x g l") 'magit-log)
(global-set-key (kbd "C-x g d") 'magit-diff)
(global-set-key (kbd "C-x g p") 'magit-project-status)

(autoload #'magit-status "magit" nil t)
(autoload #'magit-diff "magit" nil t)
(autoload #'magit-blame "magit" nil t)
(autoload #'magit-log "magit" nil t)
(autoload #'magit-project-status "magit" nil t)
;;; diff-hl

(autoload #'diff-hl-mode "diff-hl")

(add-hook 'dired-mode-hook 'diff-hl-dired-mode)
(add-hook 'prog-mode-hook 'diff-hl-mode)
(add-hook 'conf-mode-hook 'diff-hl-mode)

;;; smerge

(autoload #'smerge-mode "smerge-mode" nil t)

(add-hook 'find-file-hook 'smerge-mode)

(provide 'init-git)
