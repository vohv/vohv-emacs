;; -*- lexical-binding: t -*-

(add-hook 'c-mode-common-hook (lambda ()
                                (define-key c-mode-base-map (kbd "C-x C-o") #'ff-find-other-file)
                                (c-set-style "stroustrup")
                                (setq-default c-basic-offset 4)))

(straight-use-package 'modern-cpp-font-lock)
(modern-c++-font-lock-global-mode)
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
