;;; -*- lexical-binding: t -*-

(straight-use-package 'smartparens)

(require 'smartparens-config)

(add-hook 'prog-mode-hook #'smartparens-mode)

(straight-use-package 'symbol-overlay)
(dolist (hook '(prog-mode-hook html-mode-hook yaml-mode-hook conf-mode-hook))
  (add-hook hook 'symbol-overlay-mode))
(with-eval-after-load "symbol-overlay"
  (define-key symbol-overlay-mode-map (kbd "M-i") 'symbol-overlay-put)
  (define-key symbol-overlay-mode-map (kbd "M-I") 'symbol-overlay-remove-all))

;; (add-hook 'after-init-hook 'global-whitespace-mode)
;;; whitespace
(setq
 whitespace-line-column 80
 whitespace-style
 '(face             ; visualize things below:
   empty            ; empty lines at beginning/end of buffer
   lines-tail       ; lines go beyond `fill-column'
   space-before-tab ; spaces before tab
   trailing         ; trailing blanks
   tabs             ; tabs (show by face)
   tab-mark         ; tabs (show by symbol)
   ))

(defun +show-trailing-whitespace ()
  (setq-local show-trailing-whitespace t))

(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'whitespace-mode))

(with-eval-after-load "whitespace"
  ;; Don't use different background for tabs.
  (face-spec-set 'whitespace-tab
                 '((t :background unspecified)))
  ;; Only use background and underline for long lines, so we can still have
  ;; syntax highlight.

  ;; For some reason use face-defface-spec as spec-type doesn't work.  My guess
  ;; is it's due to the variables with the same name as the faces in
  ;; whitespace.el.  Anyway, we have to manually set some attribute to
  ;; unspecified here.
  (face-spec-set 'whitespace-line
                 '((((background light))
                    :background "#d8d8d8" :foreground unspecified
                    :underline t :weight unspecified)
                   (t
                    :background "#404040" :foreground unspecified
                    :underline t :weight unspecified)))

  ;; Use softer visual cue for space before tabs.
  (face-spec-set 'whitespace-space-before-tab
                 '((((background light))
                    :background "#d8d8d8" :foreground "#de4da1")
                   (t
                    :inherit warning
                    :background "#404040" :foreground "#ee6aa7")))
  )

(show-paren-mode 1)

(straight-use-package 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;;; huge file
(when (fboundp 'so-long-enable)
  (add-hook 'after-init-hook 'so-long-enable))
(straight-use-package 'vlf)
(require 'vlf)

(provide 'init-edit)
