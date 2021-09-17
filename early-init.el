;;; -*- lexical-binding: t; -*-

(add-to-list 'load-path (locate-user-emacs-file "elisp"))

(require 'init-straight)

;; Defer garbage collection further back in the startup process
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)

(require 'init-gc)
(require 'init-ui)
(require 'init-defaults)

(require 'init-font)
