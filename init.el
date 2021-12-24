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
(require 'init-scheme)
(require 'init-latex)
(require 'init-tab-bar)
(require 'init-tree-sitter)
(require 'init-grammatical-edit)
(require 'init-cmake)

(defvar +org nil)
(defvar +rime nil)
(defvar +rss nil)
(defvar +eaf nil)

(when +org
  (require 'init-org))

(when +rime
  (require 'init-rime))

(when +rss
  (require 'init-rss))


(defun eaf-add-app (app)
  (let* ((app-dir (locate-user-emacs-file "site-lisp/emacs-application-framework"))
         (app-load-path (expand-file-name app app-dir)))
    (add-to-list 'load-path app-load-path)
    (require (intern (format "eaf-%s" app)))))

(when +eaf
  (add-to-list 'load-path (locate-user-emacs-file "site-lisp/emacs-application-framework"))
  (setq eaf-proxy-type "http")
  (setq eaf-proxy-host "127.0.0.1")
  (setq eaf-proxy-port "7890")
  (setq eaf-config-location (no-littering-expand-var-file-name "eaf"))
  (setq eaf-browser-font-family +font-unicode-family)
  (require 'eaf)
  (add-hook 'meow-motion-mode-hook
            (lambda ()
              (when (derived-mode-p 'eaf-mode)
                (define-key eaf-mode-map (kbd "M-SPC") meow-leader-keymap)) ))
  (eaf-add-app "browser")
  (eaf-add-app "terminal")
  (eaf-add-app "org-previewer"))
