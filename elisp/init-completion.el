;;; -*- lexical-binding: t -*-

;;; selectrum
(straight-use-package 'selectrum)
(straight-use-package 'selectrum-prescient)
(straight-use-package 'company)
(straight-use-package 'corfu)
(straight-use-package 'rg)
(straight-use-package 'prescient)
(straight-use-package 'yasnippet)

(straight-use-package 'marginalia)
(define-key minibuffer-local-map (kbd "M-A") #'marginalia-cycle)
(marginalia-mode)

;;; yasnippet

(autoload #'yas-minor-mode "yasnippet")

(add-hook 'prog-mode-hook 'yas-minor-mode)

(with-eval-after-load "yasnippet"
  (let ((inhibit-message t))
    (yas-reload-all))

  (define-key yas-keymap [escape] nil)
  (define-key yas-keymap [tab] nil)
  (define-key yas-keymap (kbd "S-<tab>") nil)
  (define-key yas-keymap (kbd "Tab") nil)
  (define-key yas-keymap [return] 'yas-next-field-or-maybe-expand)
  (define-key yas-keymap (kbd "RET") 'yas-next-field-or-maybe-expand)
  (define-key yas-keymap (kbd "S-<return>") 'yas-prev-field))

;;; company

(add-hook 'after-init-hook 'global-company-mode)

(setq
 company-frontends '(company-pseudo-tooltip-unless-just-one-frontend
                     company-preview-if-just-one-frontend)
 company-idle-delay 0
 company-show-numbers t
 company-tooltip-limit 10
 company-tooltip-idle-delay 0.4
 company-minimum-prefix-length 3)

(setq company-backends
      '((company-files          ; files & directory
         company-keywords       ; keywords
         company-capf
         company-yasnippet)
        (company-abbrev company-dabbrev)))
(defun ora-company-number ()
  "Forward to `company-complete-number'.
Unless the number is potentially part of the candidate.
In that case, insert the number."
  (interactive)
  (let* ((k (this-command-keys))
         (re (concat "^" company-prefix k)))
    (if (or (cl-find-if (lambda (s) (string-match re s))
                        company-candidates)
            (> (string-to-number k)
               (length company-candidates))
            (looking-back "[0-9]+\\.[0-9]*" (line-beginning-position)))
        (self-insert-command 1)
      (company-complete-number
       (if (equal k "0")
           10
         (string-to-number k))))))

(defun ora--company-good-prefix-p (orig-fn prefix)
  (unless (and (stringp prefix) (string-match-p "\\`[0-9]+\\'" prefix))
    (funcall orig-fn prefix)))

(with-eval-after-load "company"
  (advice-add 'company--good-prefix-p :around #'ora--company-good-prefix-p)

  (let ((map company-active-map))
    (mapc (lambda (x) (define-key map (format "%d" x) 'ora-company-number))
          (number-sequence 0 9))
    (define-key map " " (lambda ()
                          (interactive)
                          (company-abort)
                          (self-insert-command 1)))
    (define-key map (kbd "<return>") nil)))

(autoload #'company-mode "company")

;;; selectrum

(require 'selectrum)
(require 'selectrum-prescient)
(selectrum-mode t)
(selectrum-prescient-mode t)

(defun +minibuffer-backward-delete ()
  (interactive)
  (delete-region
   (or
    (save-mark-and-excursion
      (while (equal ?/ (char-before)) (backward-char))
      (when-let ((p (re-search-backward "/" (line-beginning-position) t)))
        (1+ p)))
    (save-mark-and-excursion (backward-word) (point)))
   (point)))

(with-eval-after-load "selectrum"
  (define-key selectrum-minibuffer-map (kbd "M-DEL") #'+minibuffer-backward-delete)
  (define-key selectrum-minibuffer-map (kbd "{") #'selectrum-previous-candidate)
  (define-key selectrum-minibuffer-map (kbd "}") #'selectrum-next-candidate)
  (define-key selectrum-minibuffer-map (kbd "[") #'previous-history-element)
  (define-key selectrum-minibuffer-map (kbd "]") #'next-history-element))

(autoload #'rg-project "rg" nil t)

(with-eval-after-load "wgrep"
  (define-key wgrep-mode-map (kbd "C-c C-c") #'wgrep-finish-edit)
  (setq wgrep-auto-save-buffer t))

(provide 'init-completion)
