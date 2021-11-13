;;; -*- lexical-binding: t -*-

;; (straight-use-package '(semantic-stickyfunc-enhance :type git :host github :repo "tuhdo/semantic-stickyfunc-enhance"))
;; (add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
;; (semantic-mode 1)
;; (require 'stickyfunc-enhance)

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
  (let* ((lhs '((:eval (meow-indicator))
                (:eval (rime-lighter))
                " Row %l Col %C"
                (:eval (when (bound-and-true-p flycheck-mode) flycheck-mode-line))
                (:eval (when (bound-and-true-p flymake-mode)
                         flymake-mode-line-format))
                " "
                (:eval (+which-func-format))))
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

;; (straight-use-package '(dogemacs-theme :type git
;;                                        :host github
;;                                        :repo "DogLooksGood/dogEmacs"
;;                                        :files ("themes/*.el")))

;; (require 'graverse-theme)
;; (require 'grayscale-theme)
;; (require 'joker-theme)
;; (require 'minidark-theme)
;; (require 'paperlike-theme)
;; (require 'printed-theme)
;; (require 'storybook-theme)

;; (if (window-system)
;;     (load-theme 'printed t)
;;   (load-theme 'joker t))

(provide 'init-theme)
