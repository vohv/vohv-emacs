;;; -*- lexical-binding: t -*-

(straight-use-package 'flymake)
(straight-use-package 'eglot)
(straight-use-package 'lsp-mode)
(straight-use-package '(nox
                        :type git
                        :host github
                        :repo "manateelazycat/nox"))

(defvar +lsp 'nox)

;;; flymake
(autoload #'flymake-mode "flymake" nil t)

(with-eval-after-load "flymake"
  (define-key flymake-mode-map (kbd "C-c C-b") #'consult-flymake))

(straight-use-package 'consult-flycheck)
(with-eval-after-load "flycheck"
  (define-key flycheck-mode-map (kbd "C-c C-b") #'consult-flycheck))

;;; eglot

(defvar +clangd-executable "clangd")
(defvar +clangd-args (list "--clang-tidy"
                          "--enable-config"
                          "--header-insertion=never"
                          "--pch-storage=memory"
                          "--malloc-trim"
                          "-j=12"))

(setq eglot-stay-out-of '())
(setq  eglot-ignored-server-capabilites '(:documentHighlightProvider))
(setq  eglot-send-changes-idle-time 10)

(add-to-list 'eglot-stay-out-of 'company)
;; (add-to-list 'eglot-stay-out-of 'flymake)

(defun set-eglot-client (mode server-call)
  (add-to-list 'eglot-server-programs `(,mode . ,server-call)))

(with-eval-after-load "eglot"
  (defun +eglot-format-dwim (&optional arg)
    (interactive "P")
    (cond
     ((use-region-p)
      (eglot-format (region-beginning) (region-end)))
     ((= (line-beginning-position) (line-end-position))
      (c-indent-line))
     (t
      (eglot-format (line-beginning-position) (line-end-position)))
     ))

  (set-eglot-client '(c++-mode c-mode) (append (list +clangd-executable) +clangd-args))
  (define-key eglot-mode-map (kbd "C-c C-f") #'+eglot-format-dwim))

;;; lsp-mode

(setq lsp-clients-clangd-args +clangd-args)

(autoload #'lsp "lsp-mode" nil t)

(setq lsp-keymap-prefix "C-c C-M-l")

;;; nox
(defun set-nox-client (mode server-call)
  (add-to-list 'nox-server-programs `(,mode . ,server-call)))

(with-eval-after-load "nox"
  (defun +nox-format-dwim (&optional arg)
    (interactive "P")
    (cond
     ((use-region-p)
      (nox-format (region-beginning) (region-end)))
     ((= (line-beginning-position) (line-end-position))
      (c-indent-line))
     (t
      (nox-format (line-beginning-position) (line-end-position)))
     ))
  (set-nox-client '(c++-mode c-mode) (append (list +clangd-executable) +clangd-args))
  (define-key nox-mode-map (kbd "C-c C-f") #'nox-format-dwim))


(defun +lsp-start ()
  (interactive)
  (when (fboundp 'citre-mode)
    (setq-default citre-enable-xref-integration nil)
    (setq-default citre-enable-capf-integration nil)
    (setq-default citre-enable-imenu-integration nil))
  (cond ((equal 'lsp +lsp) (lsp))
        ((equal 'eglot +lsp) (eglot-ensure))
        ((equal 'nox +lsp) (nox-ensure))))

(defvar +lsp-command-map
  (let ((m (make-keymap)))
    (define-key m (kbd "a") 'lsp-execute-code-action)
    (define-key m (kbd "f") 'lsp-format-region)
    m))

(defalias '+lsp-command-map +lsp-command-map)

(with-eval-after-load "lsp-mode"
  (define-key lsp-mode-map (kbd "C-c C-l") '+lsp-command-map))

(add-hook 'c-mode-common-hook '+lsp-start)

(provide 'init-lsp)
