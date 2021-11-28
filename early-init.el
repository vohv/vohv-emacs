;;; -*- lexical-binding: t; -*-

(add-to-list 'load-path (locate-user-emacs-file "elisp"))
(add-to-list 'load-path (locate-user-emacs-file "theme"))

(require 'init-straight)
(defvar +straight-use-speedup-mirror nil)

(require 'init-gc)
(require 'init-ui)
(require 'init-utils)

(let ((private-conf (locate-user-emacs-file "private.el")))
  (when (file-exists-p private-conf)
    (load-file private-conf)))


(when +straight-use-speedup-mirror
  (advice-add 'straight-vc-git--encode-url :around #'noalias-set-github-mirror)
  (defun noalias-set-github-mirror (oldfunc &rest args)
    (let ((url (apply oldfunc args)))
      (replace-regexp-in-string (rx (group "github.com"))
                                "github.com.cnpmjs.org" url nil nil 1))))

(require 'init-defaults)
(require 'init-font)
