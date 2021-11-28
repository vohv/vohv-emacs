;; -*- lexical-binding: t -*-

(straight-use-package 'flycheck)

(straight-use-package 'dash)
(require 'dash)

(with-eval-after-load "flycheck"
  (add-to-list 'flycheck-checkers 'c/c++-clang-check))

(defvar flycheck-clangcheck-build-path "build")

(defun flycheck-clangcheck-find-project-root (checker)
  (projectile-project-root))
(flycheck-define-checker c/c++-clang-check
  "A C/C++ syntax checker using Clang.

See URL `http://clang.llvm.org/'."
  :command ("clang-check"
            (option "-p" flycheck-clangcheck-build-path)
            "--extra-arg=-Wno-unknown-warning-option"  ; silence GCC options
            "--extra-arg=-Wno-null-character"          ; silence null
            "--extra-arg=-fno-color-diagnostics"       ; Do not include color codes in output
            "--extra-arg=-fno-caret-diagnostics"       ; Do not visually indicate the source
            "--extra-arg=-fno-diagnostics-show-option" ; Do not show the corresponding
            source-inplace
            ;; source-original
            )
  :error-patterns
  ((info line-start (file-name) ":" line ":" column
         ": note: " (optional (message)) line-end)
   (warning line-start (file-name) ":" line ":" column
            ": warning: " (optional (message)) line-end)
   (error line-start (file-name) ":" line ":" column
          ": " (or "fatal error" "error") ": " (optional (message)) line-end))
  :modes (c-mode c++-mode)
  :predicate (lambda () (flycheck-buffer-saved-p))
  :error-filter (lambda (error)
                  (-filter (lambda (err)
                             (eq (buffer-file-name) (flycheck-error-filename err)))
                           error))
  :working-directory flycheck-clangcheck-find-project-root)

(add-hook 'c-mode-common-hook (lambda ()
                                (flycheck-mode 1)
                                (define-key c-mode-base-map (kbd "C-x C-o") #'ff-find-other-file)
                                (c-set-style "stroustrup")
                                (setq-default c-basic-offset 4)))

(straight-use-package 'modern-cpp-font-lock)
;; (modern-c++-font-lock-global-mode)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(defun +which-func ()
  (interactive)
  (require 'which-func)
  (let* ((function-name (which-function)))
    (when function-name
      (message "Located in function: %s"
               (propertize
                function-name
                'face '+which-func-face)))))

(with-eval-after-load "cc-mode"
  (define-key c-mode-base-map (kbd "C-c i") '+which-func))
(provide 'init-cc)
