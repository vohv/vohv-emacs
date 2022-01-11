;;; -*- lexical-binding: t -*-

(straight-use-package '(tree-sitter
			            :host github
			            :repo "emacs-tree-sitter/elisp-tree-sitter"
                        :branch "master"))
(straight-use-package 'tree-sitter-langs)

(when-let* ((distr (+which-linux-distribution)))
  (when (string-match-p "CentOS 7" (+which-linux-distribution))
    (setq tsc-dyn-get-from '(:compilation))))

(defvar +tree-sitter-elisp-load-path nil)
(defvar +tree-sitter-scheme-load-path nil)
(defvar +tree-sitter-latex-load-path nil)
(with-eval-after-load "tree-sitter"
  ;; support elisp
  (cond (sys/macp (setq +tree-sitter-elisp-load-path (no-littering-expand-etc-file-name "tree-sitter-langs/OSX/elisp")))
        (sys/linuxp (setq +tree-sitter-elisp-load-path (no-littering-expand-etc-file-name "tree-sitter-langs/Linux/elisp"))))

  (when +tree-sitter-elisp-load-path
    (tree-sitter-load 'elisp +tree-sitter-elisp-load-path)
    (add-to-list 'tree-sitter-major-mode-language-alist '(emacs-lisp-mode . elisp))
    (add-to-list 'tree-sitter-major-mode-language-alist '(lisp-interaction-mode . elisp))
    )

  ;; support scheme
  (cond (sys/linuxp (setq +tree-sitter-scheme-load-path (no-littering-expand-etc-file-name "tree-sitter-langs/Linux/scheme")))
        (sys/macp nil))
  (when +tree-sitter-scheme-load-path
    (tree-sitter-load 'Scheme +tree-sitter-scheme-load-path)
    (add-to-list 'tree-sitter-major-mode-language-alist '(scheme-mode . Scheme)))

  ;; support latex
  (cond (sys/linuxp (setq +tree-sitter-latex-load-path (no-littering-expand-etc-file-name "tree-sitter-langs/Linux/latex")))
        (sys/macp nil))
  (when +tree-sitter-latex-load-path
    (tree-sitter-load 'latex +tree-sitter-latex-load-path)
    (add-to-list 'tree-sitter-major-mode-language-alist '(latex-mode . latex))))

(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook 'tree-sitter-hl-mode)

(provide 'init-tree-sitter)
