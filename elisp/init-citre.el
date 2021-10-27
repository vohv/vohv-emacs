;;; -*- lexical-binding: t -*-

(straight-use-package 'citre)

(require 'citre)
(require 'citre-config)

(defun citre-jump+ ()
  (interactive)
  (condition-case _
      (citre-jump)
    (error (call-interactively #'xref-find-definitions))))

(with-eval-after-load "citre"
  (setq
   citre-readtags-program (executable-find "readtags")
   citre-ctags-program (executable-find "ctags")
   citre-default-create-tags-file-location 'global-cache
   citre-use-project-root-when-creating-tags t
   citre-prompt-language-for-ctags-command t)
  (setq-default
   citre-enable-xref-integration t
   citre-enable-capf-integration t
   citre-enable-imenu-integration t)
  (require 'projectile)
  (setq citre-project-root-function #'projectile-project-root)

  ;; Integrate with `eglot'
  (define-advice xref--create-fetcher (:around (fn &rest args) fallback)
    (let ((fetcher (apply fn args))
          (citre-fetcher
           (let ((xref-backend-functions '(citre-xref-backend t)))
             (ignore xref-backend-functions)
             (apply fn args))))
      (lambda ()
        (or (with-demoted-errors "%s, fallback to citre"
              (funcall fetcher))
            (funcall citre-fetcher))))))

(global-set-key (kbd "C-x c j") 'citre-jump+)
(global-set-key (kbd "C-x c J") 'citre-jump-back)
(global-set-key (kbd "C-x c p") 'citre-ace-peek)
(global-set-key (kbd "C-x c u") 'citre-update-this-tags-file)

;;; xref
(autoload #'xref-push-marker-stack "xref" "" nil)
(defun my--push-point-to-xref-marker-stack (&rest r)
  (xref-push-marker-stack (point-marker)))
(dolist (func '(find-function
                projectile-grep
                citre-jump
                consult-imenu
                consult-ripgrep
                color-rg-search-project-with-type))
  (advice-add func :before 'my--push-point-to-xref-marker-stack))

(provide 'init-citre)
