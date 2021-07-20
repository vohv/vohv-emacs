;;; -*- lexical-binding: t -*-

;; (straight-use-package 'projectile)

;; (add-hook 'after-init-hook #'projectile-mode)
;; 
;; (with-eval-after-load "projectile"
;;   (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
;;   (when (and (not (executable-find "fd"))
;;              (executable-find "rg"))
;;     (setq projectile-generic-command
;;           (let ((rg-cmd ""))
;;             (dolist (dir projectile-globally-ignored-directories)
;;               (setq rg-cmd (format "%s --glob '!%s'" rg-cmd dir)))
;;             (concat "rg -0 --files --color=never --hidden" rg-cmd)))))
;; 
;; (setq projectile-mode-line-prefix ""
;;       projectile-sort-order 'recentf
;;       projectile-use-git-grep t)

(defun +project-root-function ()
    (project-root (project-current)))

(straight-use-package 'find-file-in-project)
(with-eval-after-load "find-file-in-project"
  (require 'project)
  (when (executable-find "fd")
    (setq ffip-use-rust-fd t))
  (setq ffip-project-root-function #'+project-root-function))

(provide 'init-project)
