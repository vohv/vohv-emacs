;;; -*- lexical-binding: t; -*-

(require 'init-no-littering)
(require 'init-utils)
(require 'init-theme)
(require 'init-modal)
(require 'init-minibuffer)
(require 'init-edit)

(require 'init-completion)
(require 'init-project)
(require 'init-git)
(require 'init-builtin)
(require 'init-grep)
(require 'init-debug)
(require 'init-xterm)
(require 'init-citre)
(require 'init-lsp)
(require 'init-sh)
(require 'init-cc)
(require 'init-window)
(require 'init-docker)
(require 'init-misc)

(defvar +org nil)
(defvar +rime nil)
(defvar +rss nil)
(defvar +tree-sitter t)

(when +tree-sitter
  (require 'init-tree-sitter))

(when +org 
  (require 'init-org))

(when +rime
  (require 'init-rime))

(when +rss
  (require 'init-rss))

