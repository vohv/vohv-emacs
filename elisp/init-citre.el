;;; -*- lexical-binding: t -*-

(straight-use-package 'citre)
(straight-use-package 'dumb-jump)

(require 'citre)
(require 'citre-config)

(defun citre-jump+ ()
  (interactive)
  (if (eq major-mode 'emacs-lisp-mode)
      (progn
        (require 'dumb-jump)
        (dumb-jump-go))
  (condition-case _
      (citre-jump)
    (error (call-interactively #'xref-find-definitions)))))


(setq
 citre-readtags-program (executable-find "readtags")
 citre-ctags-program (executable-find "ctags")
 citre-default-create-tags-file-location 'global-cache
 citre-use-project-root-when-creating-tags t
 citre-prompt-language-for-ctags-command t)

(defvar citre-keymap
  (let ((m (make-keymap)))
    (define-key m (kbd "j") 'citre-jump+)
    (define-key m (kbd "J") 'citre-jump-back)
    (define-key m (kbd "p") 'citre-peek)
    (define-key m (kbd "P") 'citre-ace-peek)
    (define-key m (kbd "u") 'citre-update-this-tags-file)))
(defalias 'citre-keymap citre-keymap)
(global-set-key (kbd "C-c v") 'citre-keymap)

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
