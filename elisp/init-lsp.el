;;; -*- lexical-binding: t -*-

(straight-use-package 'flymake)
(straight-use-package 'eglot)
(straight-use-package 'lsp-mode)

(defvar +lsp 'lsp)

;;; flymake
(autoload #'flymake-mode "flymake" nil t)

(with-eval-after-load "flymake"
  (define-key flymake-mode-map (kbd "C-c C-b") #'consult-flymake)
  )

;;; eglot

(setq +clangd-executable "clangd")
(setq +clangd-args (list "--clang-tidy"
                          "--enable-config"
                          "--header-insertion=never"
                          "--pch-storage=memory"
                          "--malloc-trim"
                          "-j=12"))


(setq
 eglot-stay-out-of nil
 eglot-ignored-server-capabilites '(:documentHighlightProvider))

(defun set-eglot-client (mode server-call)
  (add-to-list 'eglot-server-programs `(,mode . ,server-call)))

(with-eval-after-load "eglot"
  (defun +eglot-format-dwim (&optional arg)
    (interactive "P")
    (cond
     ((use-region-p)
      (eglot-format (region-beginning) (region-end)))
     ((= (line-beginning-position) (line-end-position))
      (c-indent-line))
     (t
      (eglot-format (line-beginning-position) (line-end-position)))
     ))

  (set-eglot-client '(c++-mode c-mode) (append (list +clangd-executable) +clangd-args))
  (define-key eglot-mode-map (kbd "C-c C-f") #'+eglot-format-dwim)
  )

;;; lsp-mode

(setq lsp-clients-clangd-args +clangd-args)

(autoload #'lsp "lsp-mode" nil t)

(setq lsp-keymap-prefix "C-c C-l")

(defun +lsp-start ()
  (interactive)
  (if (equal 'lsp +lsp)
      (lsp)
    (eglot-ensure)))


(provide 'init-lsp)
