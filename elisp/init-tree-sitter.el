;;; -*- lexical-binding: t -*-

(straight-use-package 'tree-sitter)
(straight-use-package 'tree-sitter-langs)

(when-let* ((distr (+which-linux-distribution)))
  (when (string-match-p "CentOS 7" (+which-linux-distribution))
    (setq tsc-dyn-dir (no-littering-expand-etc-file-name "tree-sitter/bin/CentOS7"))))

(with-eval-after-load "tree-sitter"
  ;; support elisp
  (tree-sitter-load 'elisp (no-littering-expand-etc-file-name "tree-sitter-langs/bin/elisp"))
  (add-to-list 'tree-sitter-major-mode-language-alist '(emacs-lisp-mode . elisp))
  (add-to-list 'tree-sitter-major-mode-language-alist '(lisp-interaction-mode . elisp))

  ;; support scheme
  (tree-sitter-load 'Scheme (no-littering-expand-etc-file-name "tree-sitter-langs/bin/scheme"))

  ;; support latex
  (add-to-list 'tree-sitter-major-mode-language-alist '(latex-mode . latex))

  (tree-sitter-load 'latex (no-littering-expand-etc-file-name "tree-sitter-langs/bin/latex"))
  (add-to-list 'tree-sitter-major-mode-language-alist '(scheme-mode . Scheme)))

(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook 'tree-sitter-hl-mode)

(provide 'init-tree-sitter)
