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
    (define-key m (kbd "u") 'citre-update-this-tags-file)
    m))
(defalias 'citre-keymap citre-keymap)
(global-set-key (kbd "C-c v") 'citre-keymap)

;;; xref
(autoload #'xref-push-marker-stack "xref" "" nil)
(defun my--push-point-to-xref-marker-stack (&rest r)
  (xref-push-marker-stack (point-marker)))
(dolist (func '(find-function
                citre-jump
                consult-imenu
                consult-ripgrep
                color-rg-search-project-with-type))
  (advice-add func :before 'my--push-point-to-xref-marker-stack))

(defun +citre-insert-exclued-submodules-cmd ()
  (interactive)
  (require 'magit-submodule)
  (let* ((exclude-arg-func
          (lambda (path)
            (format "--exclude=%s" path)))
         (module-paths
          (let ((default-directory (citre-project-root)))
            (magit-list-module-paths)))
         (exculde-args
          (mapcar exclude-arg-func module-paths))
         (exculde-cmd
          (format "%s\n"
                  (seq-reduce (lambda (args arg)
                                (format "%s\n%s" args arg))
                              exculde-args ""))))
    (insert exculde-cmd)))

(define-advice xref--create-fetcher (:around (-fn &rest -args) fallback)
  (let ((fetcher (apply -fn -args))
        (citre-fetcher
         (let ((xref-backend-functions '(citre-xref-backend t)))
           (ignore xref-backend-functions)
           (apply -fn -args))))
    (lambda ()
      (or (with-demoted-errors "%s, fallback to citre"
            (funcall fetcher))
          (funcall citre-fetcher)))))

(defun lsp-citre-capf-function ()
  "A capf backend that tries lsp first, then Citre."
  (let ((lsp-result (pcase +lsp
                      ('lsp
                       (and (fboundp #'lsp-completion-at-point)
                            (lsp-completion-at-point)))
                      ('eglot
                       (and (fboundp #'eglot-completion-at-point)
                            (eglot-completion-at-point)))
                      ('nox
                       (and (fboundp #'nox-completion-at-point)
                            (nox-completion-at-point))))))
    (if (and lsp-result
             (try-completion
              (buffer-substring (nth 0 lsp-result)
                                (nth 1 lsp-result))
              (nth 2 lsp-result)))
        lsp-result
      (citre-completion-at-point))))

(defun enable-lsp-citre-capf-backend ()
  "Enable the lsp + Citre capf backend in current buffer."
  (add-hook 'completion-at-point-functions #'lsp-citre-capf-function nil t))

(add-hook 'citre-mode-hook #'enable-lsp-citre-capf-backend)

(provide 'init-citre)
