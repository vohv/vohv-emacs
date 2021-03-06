;;; -*- lexical-binding: t -*-

(defvar +font-wide-family "Source Code Pro")
(defvar +font-tall-family "Source Code Pro")
(defvar +font-unicode-family "LXGW WenKai")
(defvar +font-symbol-family "DejaVu Sans Mono")
(defvar +fixed-pitch-family "Sarasa Mono SC")
(defvar +variable-pitch-family "LXGW WenKai")
(defvar +font-rescale '((tall . 1.0) (wide . 1.0)))
(defvar +font-wide-or-tall 'tall)
(defvar +font-size-list '(10 11 12 13 14 15 16 17 18))
(defvar +font-size 10)

(defun +get-base-font ()
  (if (eq 'tall +font-wide-or-tall) +font-tall-family +font-wide-family))

(defun +load-base-font ()
  (let* ((font-spec (format "%s-%d" (+get-base-font) +font-size))
         (variable-pitch-font-spec (format "%s-%d" +variable-pitch-family +font-size))
         (fixed-pitch-font-spec (format "%s-%d" +fixed-pitch-family +font-size)))
    (set-frame-font font-spec)
    (add-to-list 'default-frame-alist `(font . ,font-spec))
    (set-face-attribute 'variable-pitch nil :font variable-pitch-font-spec)
    (set-face-attribute 'fixed-pitch nil :font fixed-pitch-font-spec)))

(defun +load-ext-font ()
  (let ((rescale (alist-get +font-wide-or-tall +font-rescale)))
    (setq face-font-rescale-alist
          `((,+font-unicode-family . ,rescale))))
  (when window-system
    (dolist (charset '(kana han hangul cjk-misc bopomofo))
      (set-fontset-font
       (frame-parameter nil 'font)
       charset
       (font-spec :family +font-unicode-family)))
    (set-fontset-font
     (frame-parameter nil 'font)
     'symbol
     (font-spec :family +font-symbol-family))))

(defun +load-font (&rest _ignore)
  (+load-base-font)
  (+load-ext-font))

(defun +larger-font ()
  (interactive)
  (if-let ((size (--find (> it +font-size) +font-size-list)))
      (progn (setq +font-size size)
             (+load-font)
             (message "Font size: %s" +font-size))
    (message "Using largest font")))

(defun +smaller-font ()
  (interactive)
  (if-let ((size (--find (< it +font-size) (reverse +font-size-list))))
      (progn (setq +font-size size)
             (message "Font size: %s" +font-size)
             (+load-font))
    (message "Using smallest font")))

(global-set-key (kbd "M-+") #'+larger-font)
(global-set-key (kbd "M--") #'+smaller-font)

;; Setup basic fonts
(+load-base-font)

;; `+load-ext-font' must run after frame created.
;; So we use `after-init-hook' here.
(add-hook 'after-init-hook '+load-font)

(advice-add 'load-theme :after '+load-font)
(advice-add 'disable-theme :after '+load-font)

;; Helper function to enable fixed pitch in buffer
(defun +use-fixed-pitch ()
  (interactive)
  (setq buffer-face-mode-face `(:family ,+fixed-pitch-family))
  (buffer-face-mode +1))

(defun +toggle-wide-tall-font ()
  (interactive)
  (if (eq +font-wide-or-tall 'tall)
      (setq +font-wide-or-tall 'wide)
    (setq +font-wide-or-tall 'tall))
  (+load-font))

(provide 'init-font)
