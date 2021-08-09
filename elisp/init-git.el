;;; -*- lexical-binding: t -*-

(straight-use-package 'magit)
(straight-use-package 'smerge-mode)
(straight-use-package 'git-gutter)
(straight-use-package 'vc-msg)
(straight-use-package 'git-timemachine)

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

;; {{ speed up magit, @see https://jakemccrary.com/blog/2020/11/14/speeding-up-magit/
(defvar +prefer-lightweight-magit t)
(with-eval-after-load 'magit
  (when +prefer-lightweight-magit
    (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
    ;; (remove-hook 'magit-status-sections-hook 'magit-insert-status-headers)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)))
;; }}

(defun +git-commit-id ()
  "Select commit id from current branch."
  (let* ((git-cmd "git --no-pager log --date=short --pretty=format:'%h|%ad|%s|%an'")
         (collection (nonempty-lines (shell-command-to-string git-cmd)))
         (item (completing-read "git log:" collection)))
    (when item
      (car (split-string item "|" t)))))

(defun +git-show-commit-internal ()
  "Show git commit."
  (let* ((id (+git-commit-id)))
    (when id
      (shell-command-to-string (format "git show %s" id)))))

(defun +git-show-commit ()
  "Show commit using ffip."
  (interactive)
  (let* ((ffip-diff-backends '(("Show git commit" . +git-show-commit-internal))))
    (ffip-show-diff 0)))

;; {{ git-timemachine
(defun +git-timemachine-show-selected-revision ()
  "Show last (current) revision of file."
  (interactive)
  (let*
      (
       (collection (mapcar (lambda (rev)
                             `(,(concat (substring-no-properties (nth 0 rev) 0 7) "|" (nth 5 rev) "|" (nth 6 rev)) . ,rev))
                           (git-timemachine--revisions)))
       (rev (+completing-read-alist-value "commits:" collection))
       )
    (when rev
      (git-timemachine-show-revision rev))))

(defun +git-timemachine ()
  "Open git snapshot with the selected version."
  (interactive)
  (+ensure 'git-timemachine)
  (git-timemachine--start #'+git-timemachine-show-selected-revision))
;; }}

;;; smerge
(autoload #'smerge-mode "smerge-mode" nil t)
(add-hook 'find-file-hook 'smerge-mode)

(provide 'init-git)
