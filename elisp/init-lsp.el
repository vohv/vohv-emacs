;;; -*- lexical-binding: t -*-

(straight-use-package 'eglot)

(defvar +clangd-exec "clangd")
(defvar +clangd-param (list "--enable-config"
                            "--clang-tidy"))

(defun set-eglot-client (mode server-call)
  (add-to-list 'eglot-server-programs `(,mode . ,server-call)))

(with-eval-after-load "eglot"
  (set-eglot-client 'cc-mode (append (list +clangd-exec) +clangd-param))
  )

(when (executable-find +clangd-exec)
  (add-hook 'c-mode-common-hook 'eglot-ensure))

(provide 'init-lsp)
