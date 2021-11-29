;;; -*- lexical-binding: t -*-

(straight-use-package 'tree-sitter)
(straight-use-package 'tree-sitter-langs)

(with-eval-after-load "tree-sitter"
  (tree-sitter-load 'elisp (no-littering-expand-etc-file-name "tree-sitter-langs/bin/elisp"))
  (add-to-list 'tree-sitter-major-mode-language-alist '(emacs-lisp-mode . elisp))
  (add-to-list 'tree-sitter-major-mode-language-alist '(lisp-interaction-mode . elisp)))

(dolist (hook (list
               'c-mode-common-hook
               'c-mode-hook
               'c++-mode-hook
               'emacs-lisp-mode-hook
               'lisp-interaction-mode-hook
               'rust-mode-hook))
  (add-hook hook #'tree-sitter-hl-mode))

(provide 'init-tree-sitter)
