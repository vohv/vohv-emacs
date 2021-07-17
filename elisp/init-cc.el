;; -*- lexical-binding: t -*-

(add-hook 'c-mode-common-hook (lambda ()
                                (define-key c-mode-base-map (kbd "C-x C-o") #'ff-find-other-file)
                                (c-set-style "stroustrup")
                                (setq-default c-basic-offset 4)))
(straight-use-package 'modern-cpp-font-lock)
(modern-c++-font-lock-global-mode)


(provide 'init-cc)
