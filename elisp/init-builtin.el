;;; -*- lexical-binding: t -*-

;;; Emacs builtin mode
;;; https://emacs-china.org/t/emacs-builtin-mode/11937


;;; saveplace
(add-hook 'after-init-hook 'save-place-mode)

;;; subword
(add-hook 'after-init-hook 'global-subword-mode)
;;;; winner
(add-hook 'after-init-hook 'winner-mode)
(add-hook 'ediff-quit-hook 'winner-undo)

;;; autorevert
(add-hook 'after-init-hook 'global-auto-revert-mode)

;;; isearch
(setq isearch-lazy-count t
      lazy-count-prefix-format "%s/%s ")

(provide 'init-builtin)
