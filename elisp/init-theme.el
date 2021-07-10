;;; -*- lexical-binding: t -*-


;;; theme

(straight-use-package 'doom-themes)

(with-eval-after-load "doom-themes"
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)

  (load-theme 'doom-one t)

  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(require 'doom-themes)

;;; modeline
(straight-use-package 'doom-modeline)

(doom-modeline-mode 1)



(provide 'init-theme)
