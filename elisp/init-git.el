;;; -*- lexical-binding: t -*-

(straight-use-package 'magit)
(straight-use-package 'smerge-mode)
(straight-use-package 'git-timemachine)
(straight-use-package 'git-modes)
(straight-use-package 'diff-hl)
(straight-use-package 'fullframe)

(require 'git-modes)

(defvar +libgit-enable nil)
(defvar +prefer-lightweight-magit nil)

(global-set-key (kbd "C-x v t") 'git-timemachine-toggle)

(with-eval-after-load "magit"
  (define-key transient-base-map (kbd "<escape>") #'transient-quit-one)
  (setq-default magit-diff-refine-hunk t)
  (fullframe magit-status magit-mode-quit-window)
  (fullframe magit-project-status magit-mode-quit-window)

  (setq magit-blame--style
      '(margin
        (margin-format " %s%f" " %C %a" " %H")
        (margin-width . 42)
        (margin-face . magit-blame-margin)
        (margin-body-face magit-blame-dimmed))))

(defvar magit-keymap
  (let ((m (make-keymap)))
    (define-key m (kbd "s") 'magit-status)
    (define-key m (kbd "b") 'magit-blame)
    (define-key m (kbd "l") 'magit-log)
    (define-key m (kbd "d") 'magit-diff)
    (define-key m (kbd "p") 'magit-project-status)
    m))
(defalias 'magit-keymap magit-keymap)
(global-set-key (kbd "C-x g") 'magit-keymap)

(autoload #'magit-diff "magit" nil t)
(autoload #'magit-blame "magit" nil t)
(autoload #'magit-log "magit" nil t)

(add-hook 'git-commit-mode-hook 'goto-address-mode)


;; {{ speed up magit, @see https://jakemccrary.com/blog/2020/11/14/speeding-up-magit/
(with-eval-after-load 'magit
  (when +prefer-lightweight-magit
    (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
    ;; (remove-hook 'magit-status-sections-hook 'magit-insert-status-headers)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
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


;; (straight-use-package 'blamer)
;; (setq blamer-idle-time 0.3
;;       blamer-min-offset 70)

(provide 'init-git)
