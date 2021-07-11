;;; -*- lexical-binding: t -*-

(straight-use-package 'eglot)

(setq +clangd-exec "clangd")
(setq +clangd-param (list "--clang-tidy"))

(defun set-eglot-client (mode server-call)
  (add-to-list 'eglot-server-programs `(,mode . ,server-call)))

(with-eval-after-load "eglot"
  (set-eglot-client '(c++-mode c-mode) (append (list +clangd-exec) +clangd-param))
  )

(when (executable-find +clangd-exec)
  (add-hook 'c-mode-common-hook 'eglot-ensure))

(provide 'init-lsp)
