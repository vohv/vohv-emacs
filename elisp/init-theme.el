;;; -*- lexical-binding: t -*-

;; (straight-use-package '(semantic-stickyfunc-enhance :type git :host github :repo "tuhdo/semantic-stickyfunc-enhance"))
;; (add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
;; (semantic-mode 1)
;; (require 'stickyfunc-enhance)


(defun +format-mode-line ()
  (let* ((lhs '((:eval (meow-indicator))
                (:eval (rime-lighter))
                " Row %l Col %C"
                (:eval (when (bound-and-true-p flycheck-mode) flycheck-mode-line))
                (:eval (when (bound-and-true-p flymake-mode)
                         flymake-mode-line-format))))
         (rhs '((:eval (+smart-file-name-cached))
                mode-line-modified
                " "
                (:eval mode-name)
                (vc-mode vc-mode)))
         (ww (window-width))
         (lhs-str (format-mode-line lhs))
         (rhs-str (format-mode-line rhs))
         (rhs-w (string-width rhs-str)))
    (format "%s%s%s"
            lhs-str
            (propertize " " 'display `((space :align-to (- (+ right right-fringe right-margin) (+ 1 ,rhs-w)))))
            rhs-str)))

(setq-default mode-line-format '((:eval (+format-mode-line))))

;;; theme

(straight-use-package 'doom-themes)

(with-eval-after-load "doom-themes"
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)

  (load-theme 'doom-vibrant t)

  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(when window-system
  (require 'doom-themes))

;;; modeline
(straight-use-package 'doom-modeline)

(with-eval-after-load "doom-modeline"
  (setq doom-modeline-vcs-max-length 100)
  (setq doom-modeline-icon nil))

;; (doom-modeline-mode 1)

(provide 'init-theme)
