;;; -*- lexical-binding: t -*-

(straight-use-package 'flymake)
(straight-use-package 'eglot)

(autoload #'flymake-mode "flymake" nil t)

(with-eval-after-load "flymake"
  (define-key flymake-mode-map (kbd "C-c C-b") #'flymake-show-diagnostics-buffer)
  (define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
  (define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)
  )

(setq +clangd-exec "clangd")
(setq +clangd-param (list "--clang-tidy"
                          "--header-insertion=never"
                          "--pch-storage=memory"))


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
     (t
      (eglot-format (line-beginning-position) (line-end-position)))
     ))

  (set-eglot-client '(c++-mode c-mode) (append (list +clangd-exec) +clangd-param))
  (define-key eglot-mode-map (kbd "TAB") #'+eglot-format-dwim)
  )

(when (executable-find +clangd-exec)
  (add-hook 'c-mode-common-hook 'eglot-ensure))

(provide 'init-lsp)
