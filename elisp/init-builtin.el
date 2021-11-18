;;; -*- lexical-binding: t -*-

;;; Emacs builtin mode
;;; https://emacs-china.org/t/emacs-builtin-mode/11937


;;; saveplace
(save-place-mode)

;;; subword
(global-subword-mode)
;;;; winner
(winner-mode)
(add-hook 'ediff-quit-hook 'winner-undo)

;;; autorevert
(global-auto-revert-mode)

;;; isearch
(setq isearch-lazy-count t
      lazy-count-prefix-format "%s/%s ")

(provide 'init-builtin)
