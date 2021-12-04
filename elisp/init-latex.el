 ;;; -*- lexical-binding: t -*-
(with-eval-after-load "tex-mode"
  (dolist (hook (list
                   'latex-mode-hook
                   'tex-mode-hook))
      (add-hook hook #'yas-minor-mode)
      (add-hook hook (lambda ()
                       (let ((+lsp 'lsp))
                         (+lsp-start))))
      ))

(with-eval-after-load "eglot"
  (set-eglot-client 'latex-mode '("digestif")))

(provide 'init-latex)
