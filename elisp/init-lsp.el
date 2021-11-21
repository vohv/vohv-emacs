;;; -*- lexical-binding: t -*-

(straight-use-package 'flymake)
(straight-use-package 'eglot)
(straight-use-package 'lsp-mode)

(defvar +enable-lsp nil)
(defvar +lsp 'eglot)

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
 eglot-stay-out-of '()
 eglot-ignored-server-capabilites '(:documentHighlightProvider))

(add-to-list 'eglot-stay-out-of 'company)
(add-to-list 'eglot-stay-out-of 'flymake)

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

(setq lsp-keymap-prefix "C-c C-M-l")

(defun +lsp-start ()
  (interactive)
  (when (fboundp 'citre-mode)
    (setq-default citre-enable-xref-integration nil)
    (setq-default citre-enable-capf-integration nil)
    (setq-default citre-enable-imenu-integration nil))
  (if (equal 'lsp +lsp)
      (lsp)
    (eglot-ensure)))

(defvar +lsp-command-map
  (let ((m (make-keymap)))
    (define-key m (kbd "a") 'lsp-execute-code-action)
    (define-key m (kbd "f") 'lsp-format-region)
    m))

(defalias '+lsp-command-map +lsp-command-map)

(with-eval-after-load "lsp-mode"
  (define-key lsp-mode-map (kbd "C-c C-l") '+lsp-command-map))


(if +enable-lsp
    (add-hook 'c-mode-common-hook '+lsp-start))

(provide 'init-lsp)
