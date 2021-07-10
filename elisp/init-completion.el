;;; -*- lexical-binding: t -*-

;;; selectrum
(straight-use-package 'selectrum)
(straight-use-package 'selectrum-prescient)

(selectrum-mode +1)
(selectrum-prescient-mode +1)
(prescient-persist-mode +1)


;;; company
(straight-use-package 'company)

(add-hook 'after-init-hook 'global-company-mode)

(provide 'init-completion)
