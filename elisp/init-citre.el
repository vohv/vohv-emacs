;;; -*- lexical-binding: t -*-

(straight-use-package 'citre)

(require 'citre)
(require 'citre-config)

(defun citre-jump+ ()
  (interactive)
  (condition-case _
      (citre-jump)
    (error (call-interactively #'xref-find-definitions))))

(with-eval-after-load "citre"
  (setq
   ;; Set these if readtags/ctags is not in your path.
   citre-readtags-program (executable-find "readtags")
   citre-ctags-program (executable-find "ctags")
   ;; Set this if you use project management plugin like projectile.  It's
   ;; used for things like displaying paths relatively, see its docstring.
   citre-project-root-function #'+project-root-function
   ;; Set this if you want to always use one location to create a tags file.
   citre-default-create-tags-file-location 'global-cache
   ;; See the "Create tags file" section above to know these options
   citre-use-project-root-when-creating-tags t
   citre-prompt-language-for-ctags-command t
   )
  (setq company-backends '((company-capf company-citre :with company-yasnippet :separate)))
  )

(global-set-key (kbd "C-x c j") 'citre-jump+)
(global-set-key (kbd "C-x c J") 'citre-jump-back)
(global-set-key (kbd "C-x c p") 'citre-ace-peek)
(global-set-key (kbd "C-x c u") 'citre-update-this-tags-file)




;;; smart jump
(straight-use-package 'smart-jump)

(autoload #'smart-jump-go "smart-jump" nil t)
(autoload #'smart-jump-back "smart-jump" nil t )
(autoload #'smart-jump-references "smart-jump" nil t)

(global-set-key (kbd "M-.") #'smart-jump-go)
(global-set-key (kbd "M-,") #'smart-jump-back)
(global-set-key (kbd "M-?") #'smart-jump-references)

(smart-jump-register :modes '(c-mode c++-mode)
                     :jump-fn 'citre-jump+
                     :pop-fn 'citre-jump-back
                     :refs-fn 'citre-jump+
                     :should-jump t
                     :heuristic 'point
                     :async 500
                     :order 2)

(smart-jump-register :modes '(c-mode c++-mode)
                     :jump-fn 'xref-find-definitions
                     :pop-fn 'xref-pop-marker-stack
                     :refs-fn 'xref-find-references
                     :should-jump t
                     :heuristic 'point
                     :async 500
                     :order 1)

(provide 'init-citre)
