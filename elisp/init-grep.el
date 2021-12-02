;;; -*- lexical-binding: t -*-

;;; color rg
(straight-use-package '(color-rg :type git
                                 :host github
                                 :repo "manateelazycat/color-rg"))
(require 'color-rg)

(with-eval-after-load "meow"
  (defun +color-rg-switch-normal (origin-fun &rest args)
    (apply origin-fun args)
    (meow--switch-state 'normal))

  (defun +color-rg-switch-motion (origin-fun &rest args)
    (apply origin-fun args)
    (meow--switch-state 'motion))

  (advice-add 'color-rg-switch-to-edit-mode :around #'+color-rg-switch-normal)
  (advice-add 'color-rg-apply-changed :around #'+color-rg-switch-motion))

(define-key color-rg-mode-map (kbd "g") 'color-rg-recompile)
(define-key color-rg-mode-map (kbd "n") 'color-rg-jump-next-keyword)
(define-key color-rg-mode-map (kbd "p") 'color-rg-jump-prev-keyword)

(defun +color-rg-dwim ()
  (interactive)
  (cond ((equal current-prefix-arg '(4))
         (color-rg-search-symbol))
        ((equal current-prefix-arg '(16))
         (color-rg-search-symbol-in-current-file))
        (t
         (color-rg-search-symbol-in-project))
        ))
(global-set-key [remap rgrep] '+color-rg-dwim)

(setq color-rg-search-no-ignore-file nil)

;;; rg.el
;; (straight-use-package 'rg)
;; (global-set-key (kbd "C-c s") #'rg-menu)
;; (setq rg-custom-type-aliases '(("cc" . "*.c *.h *.hpp *.cpp *.cc")))
;; (with-eval-after-load 'rg)
;;
;; (require 'rg-isearch)
;; (define-key isearch-mode-map (kbd "M-s r") 'rg-isearch-menu)
;; (global-set-key [remap rgrep] 'rg-dwim)
;;
;; (setq wgrep-auto-save-buffer t)

(provide 'init-grep)
