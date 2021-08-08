;;; -*- lexical-binding: t -*-


(defvar +font-family "Fira Code")
(defvar +ufont-family "Microsoft YaHei")
(defvar +fixed-pitch-family "Sarasa Mono SC")
(defvar +variable-pitch-family "Sarasa Gothic SC")
(defvar +font-size 11)

(defun +load-base-font ()
  (let* ((font-spec (format "%s-%d" +font-family +font-size))
         (variable-pitch-font-spec (format "%s-%d" +variable-pitch-family +font-size))
         (fixed-pitch-font-spec (format "%s-%d" +fixed-pitch-family +font-size)))
    (add-to-list 'default-frame-alist `(font . ,font-spec))
    (set-face-attribute 'variable-pitch nil :font variable-pitch-font-spec)
    (set-face-attribute 'fixed-pitch nil :font fixed-pitch-font-spec)))

(defun +load-ext-font ()
  (when window-system
    (dolist (charset '(kana han cjk-misc bopomofo))
      (set-fontset-font
       (frame-parameter nil 'font)
       charset
       (font-spec :family +ufont-family)))))

(defun +load-font ()
  (let* ((font-spec (format "%s-%d" +font-family +font-size))
         (variable-pitch-font-spec (format "%s-%d" +variable-pitch-family +font-size))
         (fixed-pitch-font-spec (format "%s-%d" +fixed-pitch-family +font-size)))
    (set-frame-font font-spec)
    (set-face-attribute 'variable-pitch nil :font variable-pitch-font-spec)
    (set-face-attribute 'fixed-pitch nil :font fixed-pitch-font-spec))
  (+load-ext-font))

;; Setup basic fonts
(+load-base-font)

;; `+load-ext-font' must run after frame created.
;; So we use `after-init-hook' here.
(add-hook 'after-init-hook '+load-ext-font)

(provide 'init-font)
