;;; -*- lexical-binding: t -*-

(defun +ensure (feature)
  "Make sure FEATURE is required."
  (unless (featurep feature)
    (condition-case nil
        (require feature)
      (error nil))))

(defun nonempty-lines (str)
  "Split STR into lines."
  (split-string str "[\r\n]+" t))

(defun +completing-read-alist-value (prompt alist)
  (cdr (assoc (completing-read prompt alist) alist)))

(defun +open-config ()
  (interactive)
  (find-file (expand-file-name "init.el" user-emacs-directory)))

(provide 'init-utils)
