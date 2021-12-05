;;; -*- lexical-binding: t -*-

(defconst sys/wslp
  (string-match-p "microsoft" operating-system-release)
  "Are we running on Microsoft WSL?")

(defconst sys/win32p
  (eq system-type 'windows-nt)
  "Are we running on WinTel system?")

(provide 'init-const)
