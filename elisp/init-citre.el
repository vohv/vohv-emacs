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
   citre-readtags-program (executable-find "readtags")
   citre-ctags-program (executable-find "ctags")
   citre-default-create-tags-file-location 'global-cache
   citre-use-project-root-when-creating-tags t
   citre-prompt-language-for-ctags-command t)
  (setq-default
   citre-enable-xref-integration nil
   citre-enable-capf-integration nil
   citre-enable-imenu-integration nil)
  (require 'projectile)
  (setq citre-project-root-function #'projectile-project-root)

  ;; Integrate with `eglot'
  (define-advice xref--create-fetcher (:around (fn &rest args) fallback)
    (let ((fetcher (apply fn args))
          (citre-fetcher
           (let ((xref-backend-functions '(citre-xref-backend t)))
             (ignore xref-backend-functions)
             (apply fn args))))
      (lambda ()
        (or (with-demoted-errors "%s, fallback to citre"
              (funcall fetcher))
            (funcall citre-fetcher)))))

  ;; (defun lsp-citre-capf-function ()
  ;;   "A capf backend that tries lsp first, then Citre."
  ;;   (let ((lsp-result (eglot-completion-at-point))
  ;;         (if (and lsp-result
  ;;                  (try-completion
  ;;                   (buffer-substring (nth 0 lsp-result)
  ;;                                     (nth 1 lsp-result))
  ;;                   (nth 2 lsp-result)))
  ;;             lsp-result
  ;;           (citre-completion-at-point)))))
  ;;
  ;; (defun enable-lsp-citre-capf-backend ()
  ;;   "Enable the lsp + Citre capf backend in current buffer."
  ;;   (add-hook 'completion-at-point-functions #'lsp-citre-capf-function nil t))
  ;;
  ;; (add-hook 'citre-mode-hook #'enable-lsp-citre-capf-backend)
  )

(global-set-key (kbd "C-x c j") 'citre-jump+)
(global-set-key (kbd "C-x c J") 'citre-jump-back)
(global-set-key (kbd "C-x c p") 'citre-ace-peek)
(global-set-key (kbd "C-x c u") 'citre-update-this-tags-file)




;;; smart jump
;; (straight-use-package 'smart-jump)
;;
;; (autoload #'smart-jump-go "smart-jump" nil t)
;; (autoload #'smart-jump-back "smart-jump" nil t )
;; (autoload #'smart-jump-references "smart-jump" nil t)
;;
;; (global-set-key (kbd "M-.") #'smart-jump-go)
;; (global-set-key (kbd "M-,") #'smart-jump-back)
;; (global-set-key (kbd "M-?") #'smart-jump-references)
;;
;; (smart-jump-register :modes '(c-mode c++-mode)
;;                      :jump-fn 'citre-jump+
;;                      :pop-fn 'citre-jump-back
;;                      :refs-fn 'citre-jump+
;;                      :should-jump t
;;                      :heuristic 'point
;;                      :async 500
;;                      :order 2)
;;
;; (smart-jump-register :modes '(c-mode c++-mode)
;;                      :jump-fn 'xref-find-definitions
;;                      :pop-fn 'xref-pop-marker-stack
;;                      :refs-fn 'xref-find-references
;;                      :should-jump t
;;                      :heuristic 'point
;;                      :async 500
;;                      :order 1)

;;; xref
(autoload #'xref-push-marker-stack "xref" "" nil)
(defun my--push-point-to-xref-marker-stack (&rest r)
  (xref-push-marker-stack (point-marker)))
(dolist (func '(find-function
                projectile-grep
                citre-jump
                consult-imenu
                consult-ripgrep
                color-rg-search-project-with-type))
  (advice-add func :before 'my--push-point-to-xref-marker-stack))

(provide 'init-citre)
