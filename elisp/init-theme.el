;;; -*- lexical-binding: t -*-

(defface +which-func-face
  '((t (:foreground "Gold" :bold t)))
  "Face for show function location.")

(defun +which-func-format ()
  (require 'which-func)
  (let ((function-name (which-function)))
    (when function-name
      `("[" ,(propertize function-name 'face '+which-func-face) "]")
      )))

(defun +format-mode-line ()
  (let* ((lhs '((:eval (when (fboundp 'meow-indent)
                         (meow-indicator)))
                " L%l C%C "
                (:eval (when (fboundp 'rime-lighter)
                         (rime-lighter)))
                (:eval (when (bound-and-true-p flycheck-mode) flycheck-mode-line))
                (:eval (when (bound-and-true-p flymake-mode)
                         flymake-mode-line-format))))
         (rhs '((:eval (when (fboundp 'eglot--managed-mode)
                         (eglot--mode-line-format)))
                " "
                (:eval (+smart-file-name-cached))
                mode-line-modified
                " "
                (:eval mode-name)
                (:eval (+vc-branch-name))))
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


(require 'joker-theme)
(require 'printed-theme)
(require 'minidark-theme)

(if (window-system)
    (load-theme 'printed t)
  (load-theme 'minidark t))

(provide 'init-theme)
