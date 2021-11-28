;;; -*- lexical-binding: t -*-

(straight-use-package 'tree-sitter)
(straight-use-package 'tree-sitter-langs)

(require 'tree-sitter)
(require 'tree-sitter-langs)

(add-hook 'c-mode-common-hook #'tree-sitter-hl-mode)

(provide 'init-tree-sitter)
