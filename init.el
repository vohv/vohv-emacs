;;; -*- lexical-binding: t; -*-

(require 'init-theme)
(require 'init-modal)
(require 'init-minibuffer)
(require 'init-edit)

(run-with-idle-timer
 1 nil
 #'(lambda ()
     (require 'init-utils)
     (require 'init-completion)
     (require 'init-project)
     (require 'init-git)
     (require 'init-builtin)
     (require 'init-grep)
     (require 'init-debug)
     (require 'init-xterm)
     (require 'init-rime)
     (require 'init-citre)
     (require 'init-org)
     (require 'init-lsp)
     (require 'init-sh)
     (require 'init-cc)
     (require 'init-window)
     (require 'init-misc)))
