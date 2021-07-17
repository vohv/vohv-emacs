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

(provide 'init-org)
