;; -*- lexical-binding: t; -*-

(straight-use-package 'gcmh)

(require 'gcmh)

(setq gcmh-idle-delay 5
      gcmh-high-cons-threshold #x1000000) ; 16MB

(gcmh-mode 1)

(provide 'init-gc)
