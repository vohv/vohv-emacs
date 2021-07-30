;;; -*- lexical-binding: t -*-

(straight-use-package 'magit)
(straight-use-package 'smerge-mode)
(straight-use-package 'git-gutter)
(straight-use-package 'vc-msg)

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


;; {{ git-gutter
(with-eval-after-load "git-gutter"
  (unless (fboundp 'global-display-line-numbers-mode)
    ;; git-gutter's workaround for linum-mode bug.
    ;; should not be used in `display-line-number-mode'
    (git-gutter:linum-setup))

  (setq git-gutter:update-interval 2)
  (setq git-gutter:disabled-modes
        '(asm-mode
          org-mode
          outline-mode
          markdown-mode
          image-mode))
  (custom-set-variables
   '(git-gutter:modified-sign "=") ;; two space
   '(git-gutter:added-sign "+")    ;; multiple character is OK
   '(git-gutter:deleted-sign "-"))

  (set-face-foreground 'git-gutter:modified "purple")
  (set-face-foreground 'git-gutter:added "green")
  (set-face-foreground 'git-gutter:deleted "red")
  )

(defun +git-gutter-reset-to-head-parent()
  "Reset gutter to HEAD^.  Support Subversion and Git."
  (interactive)
  (let* ((filename (buffer-file-name))
         (cmd (concat "git --no-pager log --oneline -n1 --pretty=\"format:%H\" "
                      filename))
         (parent (cond
                  ((eq git-gutter:vcs-type 'svn)
                   "PREV")
                  (filename
                   (concat (shell-command-to-string cmd) "^"))
                  (t
                   "HEAD^"))))
    (git-gutter:set-start-revision parent)
    (message "git-gutter:set-start-revision HEAD^")))

(defun +git-gutter-reset-to-default ()
  "Restore git gutter to its original status.
Show the diff between current working code and git head."
  (interactive)
  (git-gutter:set-start-revision nil)
  (message "git-gutter reset")
  )

(defun +git-gutter-toggle ()
  "Toggle git gutter."
  (interactive)
  (git-gutter-mode -1)
  ;; git-gutter-fringe doesn't seem to
  ;; clear the markup right away
  (sit-for 0.1)
  (git-gutter:clear))

(global-set-key (kbd "C-x g u") 'git-gutter-mode)
(global-set-key (kbd "C-x g =") 'git-gutter:popup-hunk)
;; Stage current hunk
(global-set-key (kbd "C-x g S") 'git-gutter:stage-hunk)
;; Revert current hunk
(global-set-key (kbd "C-x g r") 'git-gutter:revert-hunk)

(run-with-idle-timer 2 nil #'global-git-gutter-mode)
;; }}

;; {{ speed up magit, @see https://jakemccrary.com/blog/2020/11/14/speeding-up-magit/
(defvar +prefer-lightweight-magit t)
(with-eval-after-load 'magit
  (when +prefer-lightweight-magit
    (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
    (remove-hook 'magit-status-sections-hook 'magit-insert-status-headers)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)))
;; }}

(defun nonempty-lines (str)
  "Split STR into lines."
  (split-string str "[\r\n]+" t))

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

;;; smerge
(autoload #'smerge-mode "smerge-mode" nil t)
(add-hook 'find-file-hook 'smerge-mode)

(provide 'init-git)
