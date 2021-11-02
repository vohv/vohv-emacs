;;; -*- lexical-binding: t -*-

(straight-use-package 'magit)
(straight-use-package 'smerge-mode)
(straight-use-package 'git-timemachine)
(straight-use-package 'git-modes)
(straight-use-package 'git-blamed)
(straight-use-package 'magit-todos)
(straight-use-package 'diff-hl)
(straight-use-package 'fullframe)
(straight-use-package 'git-commit)

(global-set-key (kbd "C-x v t") 'git-timemachine-toggle)

(with-eval-after-load "magit"
  (require 'magit-todos)
  (define-key transient-base-map (kbd "<escape>") #'transient-quit-one)
  (setq-default magit-diff-refine-hunk t)
  (fullframe magit-status magit-mode-quit-window)
)

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

(add-hook 'git-commit-mode-hook 'goto-address-mode)


;; {{ speed up magit, @see https://jakemccrary.com/blog/2020/11/14/speeding-up-magit/
(defvar +prefer-lightweight-magit t)
(with-eval-after-load 'magit
  (when +prefer-lightweight-magit
    (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
    ;; (remove-hook 'magit-status-sections-hook 'magit-insert-status-headers)
    ;; (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
    ;; (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)))
;; }}

;;; smerge
(autoload #'smerge-mode "smerge-mode" nil t)
(add-hook 'find-file-hook 'smerge-mode)

;;; diff hl
(global-diff-hl-mode)
(unless (window-system)
  (diff-hl-margin-mode +1)
  )
(with-eval-after-load "magit"
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(provide 'init-git)
