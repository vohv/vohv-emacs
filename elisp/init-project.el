;;; -*- lexical-binding: t -*-

(straight-use-package 'projectile)

(add-hook 'after-init-hook #'projectile-mode)

(setq project-switch-commands '((find-file-in-project-by-selected "Find file")
                           (project-find-regexp "Find regexp")
                           (project-dired "Dired")
                           (project-eshell "Eshell")
                           (magit-status "Magit")))
(require 'project)

(with-eval-after-load "project"
  (define-key project-prefix-map "f" 'find-file-in-project-by-selected)
  (define-key project-prefix-map "m" 'magit-status))

(straight-use-package 'find-file-in-project)

(with-eval-after-load "find-file-in-project"
  (require 'project)
  (when (executable-find "fd")
    (setq ffip-use-rust-fd t))
  (setq ffip-project-root-function #'projectile-project-root))

(provide 'init-project)
