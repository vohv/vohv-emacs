;;; -*- lexical-binding: t -*-

;;; selectrum
(straight-use-package 'selectrum)
(straight-use-package 'selectrum-prescient)
(straight-use-package 'rg)

(selectrum-mode +1)
(selectrum-prescient-mode +1)
(prescient-persist-mode +1)


;;; company
(straight-use-package 'company)

(add-hook 'after-init-hook 'global-company-mode)

(with-eval-after-load "company"
  (setq company-backends
        '((company-files          ; files & directory
           company-keywords       ; keywords
           company-capf
           company-yasnippet
           )
          (company-abbrev company-dabbrev)
          ))
  (setq company-idle-delay 0.5)
  (setq company-show-numbers t)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-align-annotations t)
  ;; invert the navigation direction if the the completion popup-isearch-match
  ;; is displayed on top (happens near the bottom of windows)
  (setq company-tooltip-flip-when-above t))

;;; color-rg
;; (straight-use-package '(color-rg :type git :host github :repo "manateelazycat/color-rg"))
;; (define-key isearch-mode-map (kbd "M-s M-s") 'isearch-toggle-color-rg)


(provide 'init-completion)
