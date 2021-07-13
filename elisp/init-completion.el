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
        )))

;;; color-rg
;; (straight-use-package '(color-rg :type git :host github :repo "manateelazycat/color-rg"))
;; (define-key isearch-mode-map (kbd "M-s M-s") 'isearch-toggle-color-rg)


(provide 'init-completion)
