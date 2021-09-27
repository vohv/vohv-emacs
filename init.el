;;; -*- lexical-binding: t; -*-

(straight-use-package 'benchmark-init)
(require 'benchmark-init)
(add-hook 'after-init-hook 'benchmark-init/deactivate)

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)
(add-hook 'emacs-startup-hook
          (lambda ()
            "Recover GC values after startup."
            (setq gc-cons-threshold 800000
                  gc-cons-percentage 0.1)))

(require 'init-utils)
(require 'init-modal)
(require 'init-theme)
(require 'init-completion)
(require 'init-lsp)
(require 'init-edit)
(require 'init-git)
(require 'init-project)
(require 'init-cc)
(require 'init-org)
(require 'init-citre)
(require 'init-sh)
(require 'init-rime)
(require 'init-debug)
(require 'init-minibuffer)
(require 'init-builtin)
