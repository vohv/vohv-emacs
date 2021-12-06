;;; -*- lexical-binding: t -*-

(straight-use-package 'tree-sitter)
(straight-use-package 'tree-sitter-langs)

(when-let* ((distr (+which-linux-distribution)))
  (when (string-match-p "CentOS 7" (+which-linux-distribution))
    (setq tsc-dyn-dir (no-littering-expand-etc-file-name "tree-sitter/bin/CentOS7"))))

(with-eval-after-load "tree-sitter"
  (tree-sitter-load 'elisp (no-littering-expand-etc-file-name "tree-sitter-langs/bin/elisp"))
  (tree-sitter-load 'Scheme (no-littering-expand-etc-file-name "tree-sitter-langs/bin/scheme"))
  (tree-sitter-load 'latex (no-littering-expand-etc-file-name "tree-sitter-langs/bin/latex"))
  (add-to-list 'tree-sitter-major-mode-language-alist '(emacs-lisp-mode . elisp))
  (add-to-list 'tree-sitter-major-mode-language-alist '(lisp-interaction-mode . elisp))
  (add-to-list 'tree-sitter-major-mode-language-alist '(scheme-mode . Scheme))
  (add-to-list 'tree-sitter-major-mode-language-alist '(latex-mode . latex))
  )

(dolist (hook (list
               'c-mode-common-hook
               'c-mode-hook
               'c++-mode-hook
               'emacs-lisp-mode-hook
               'scheme-mode-hook
               'lisp-interaction-mode-hook
               'rust-mode-hook
               'latex-mode-hook))
  (add-hook hook #'tree-sitter-hl-mode))

(provide 'init-tree-sitter)
