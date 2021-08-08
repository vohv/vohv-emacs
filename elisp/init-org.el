;;; -*- lexical-binding: t -*-

;;; Org babel

(defun +org-babel-setup ()
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (shell . t)))
  (setq org-confirm-babel-evaluate nil))


(with-eval-after-load "org"
  (+org-babel-setup))
(setq browse-url-browser-function 'browse-url-default-browser)
(provide 'init-org)
