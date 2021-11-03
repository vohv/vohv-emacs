;;; -*- lexical-binding: t; -*-

(add-to-list 'load-path (locate-user-emacs-file "elisp"))

(require 'init-straight)

(require 'init-gc)
(require 'init-ui)

(let ((private-conf (locate-user-emacs-file "private.el")))
  (when (file-exists-p private-conf)
    (load-file private-conf)))

(require 'init-defaults)
(require 'init-font)
