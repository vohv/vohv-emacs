;;; -*- lexical-binding: t -*-

(straight-use-package 'find-file-in-project)
(straight-use-package 'project)

(setq project-switch-commands '((find-file-in-project-by-selected "Find file")
                                (color-rg-search-input-in-project "Find regexp")
                                (project-dired "Dired")
                                (project-eshell "Eshell")
                                (magit-project-status "Magit")))
(require 'project)

(with-eval-after-load "project"
  (define-key project-prefix-map "m" #'magit-project-status)
  (define-key project-prefix-map "f" 'find-file-in-project-by-selected)
  (define-key project-prefix-map "g" 'color-rg-search-input-in-project)

  ;; remember current project after project-switch-project for custom
  ;; commands (eg. find-file-in-project-by-selected)
  (advice-add 'project-switch-project :after (lambda (&rest _ignore)
                                               (when-let* ((pr (project-current)))
                                                 (project-remember-project pr)))))

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
  (when (executable-find "fd")
    (setq ffip-use-rust-fd t))
  (setq ffip-project-root-function #'+project-root))

(defun +project-root ()
  (when-let* ((pr (project-current)))
    (cdr pr)))

(defun +project-try-local (dir)
  "Determine if DIR is a non-Git project."
  (catch 'ret
    (let ((pr-flags '((".project")
                      ("go.mod" "Cargo.toml" "project.clj" "pom.xml" "package.json") ;; higher priority
                      ("Makefile" "README.org" "README.md"))))
      (dolist (current-level pr-flags)
        (dolist (f current-level)
          (when-let ((root (locate-dominating-file dir f)))
            (throw 'ret (cons 'local root))))))))

(cl-defmethod project-root ((project (head local)))
  (cdr project))

(push #'+project-try-local project-find-functions)

(provide 'init-project)
