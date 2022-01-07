;;; -*- lexical-binding: t -*-

(defconst sys/wslp
  (when operating-system-release
    (string-match-p "microsoft" operating-system-release))
  "Are we running on Microsoft WSL?")

(defconst sys/linuxp
  (eq system-type 'gnu/linux)
  "Are we running on a GNU/Linux system?")

(defconst sys/win32p
  (eq system-type 'windows-nt)
  "Are we running on WinTel system?")

(defconst sys/macp
  (eq system-type 'darwin)
  "Are we running on a Mac system?")

(defconst sys/mac-ns-p
  (eq window-system 'ns)
  "Are we running on a GNUstep or Macintosh Cocoa display?")

(provide 'init-const)
