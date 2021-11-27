;;; -*- lexical-binding: t -*-

(straight-use-package 'no-littering)
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
(setq custom-file (no-littering-expand-etc-file-name "custom.el"))
(require 'no-littering)

(provide 'init-no-littering)
