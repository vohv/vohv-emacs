;;; -*- lexical-binding: t -*-

(straight-use-package 'projectile)
(straight-use-package 'find-file-in-project)
(straight-use-package 'project)

(setq project-switch-commands '((find-file-in-project-by-selected "Find file")
                                (color-rg-search-symbol-in-project "Find regexp")
                                (project-dired "Dired")
                                (project-eshell "Eshell")
                                (magit-project-status "Magit")))
(require 'project)

(with-eval-after-load "project"
  (define-key project-prefix-map "m" #'magit-project-status)
  (define-key project-prefix-map "f" 'find-file-in-project-by-selected)
  (define-key project-prefix-map "g" 'color-rg-search-symbol-in-project))

(defun +project-previous-buffer (arg)
  (interactive "P")
  (unless arg
    (if-let ((pr (project-current)))
        (switch-to-buffer
         (->> (project--buffer-list pr)
              (--remove (or (minibufferp it)
                            (get-buffer-window-list it)))
              (car)))
      (mode-line-other-buffer))))

(require 'find-file-in-project)

(with-eval-after-load "find-file-in-project"
  (require 'projectile)
  (when (executable-find "fd")
    (setq ffip-use-rust-fd t))
  (setq ffip-project-root-function #'projectile-project-root))

(provide 'init-project)
