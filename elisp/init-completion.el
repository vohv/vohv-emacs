;;; -*- lexical-binding: t -*-

(straight-use-package 'company)
(straight-use-package 'yasnippet)

(add-hook 'prog-mode-hook
          (lambda ()
            (require 'yasnippet)
            (yas-global-mode 1)))

(add-hook 'prog-mode-hook
          (lambda ()
            (require 'company)
            (require 'company-yasnippet)
            (require 'company-files)
            (require 'company-tng)
            ;; Config for company mode.
            (setq company-minimum-prefix-length 1) ; pop up a completion menu by tapping a character
            (setq company-show-numbers t) ; number the candidates (use M-1, M-2 etc to select completions).
            (setq company-require-match nil) ; allow input string that do not match candidate words.
            (setq company-idle-delay 0) ; trigger completion immediately

            ;; Don't downcase the returned candidates.
            (setq company-dabbrev-downcase nil)
            (setq company-dabbrev-ignore-case t)

            ;; Customize company backends
            (setq company-backends
                  '(
                    (company-capf company-keywords company-files)
                    ))

            ;; Add yasnippet support for all company backends.
            (defvar company-mode/enable-yas t
              "Enable yasnippet for all backends.")

            (defun company-mode/backend-with-yas (backend)
              (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
                  backend
                (append (if (consp backend) backend (list backend))
                        '(:with company-yasnippet))))
            (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

            ;; Remove duplicate candidate
            (add-to-list 'company-transformers #'delete-dups)

            ;; Enable global
            (global-company-mode)

            (define-key company-mode-map (kbd "TAB") nil)
            (define-key company-active-map (kbd "M-p") nil)
            (define-key company-active-map (kbd "M-n") nil)
            (define-key company-active-map (kbd "C-m") nil)

            (define-key company-active-map (kbd "TAB") 'company-complete-selection)
            (define-key company-active-map (kbd "M-h") 'company-complete-selection)
            (define-key company-active-map (kbd "M-H") 'company-complete-common)
            (define-key company-active-map (kbd "M-.") 'company-show-location)
            (define-key company-active-map (kbd "M-s") 'company-filter-candidate)
            (define-key company-active-map (kbd "M-n") 'company-select-next)
            (define-key company-active-map (kbd "M-p") 'company-select-previous)
            (define-key company-active-map (kbd "M-i") 'yas-expand)))

(provide 'init-completion)
