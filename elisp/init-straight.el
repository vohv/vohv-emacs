;;; -*- lexical-binding: t -*-

(defvar +straight-use-speedup-mirror nil)

(setq comp-deferred-compilation-deny-list ())
(setq straight-vc-git-default-clone-depth 1)

(setq straight-disable-native-compile
      (when (fboundp 'native-comp-available-p)
	(not (native-comp-available-p))))

(defvar bootstrap-version)
(let ((bootstrap-file
       (locate-user-emacs-file "straight/repos/straight.el/bootstrap.el"))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(global-set-key (kbd "C-x M-s p") 'straight-pull-package)
(global-set-key (kbd "C-x M-s P") 'straight-pull-all)
(global-set-key (kbd "C-x M-s c") 'straight-check-package)
(global-set-key (kbd "C-x M-s C") 'straight-check-all)
(global-set-key (kbd "C-x M-s b") 'straight-rebuild-package)
(global-set-key (kbd "C-x M-s B") 'straight-rebuild-all)


(when +straight-use-speedup-mirror
  (advice-add 'straight-vc-git--encode-url :around #'noalias-set-github-mirror)
  (defun noalias-set-github-mirror (oldfunc &rest args)
    (let ((url (apply oldfunc args)))
      (replace-regexp-in-string (rx (group "github.com"))
                                "github.com.cnpmjs.org" url nil nil 1))))

(provide 'init-straight)
