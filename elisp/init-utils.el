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


(defun +copy-yank-str (msg &optional clipboard-only)
  (unless clipboard-only (kill-new msg))
  msg)

(defun +popup-which-function ()
  "Popup which function message"
  (interactive)
  (require 'popup)
  (require 'which-func)
  (let* ((msg (which-function)))
    (when msg
      ;; (popup-tip msg)
      (message msg)
      (+copy-yank-str msg))))

(defvar +smart-file-name-cache nil)

(defun +smart-file-name ()
  "Get current file name, if we are in project, the return relative path to the project root, otherwise return absolute file path.
This function is slow, so we have to use cache."
  (let ((vc-dir (vc-root-dir))
        (bfn (buffer-file-name (current-buffer))))
    (cond
     ((and bfn vc-dir)
      (concat
       (file-name-base (string-trim-right vc-dir "/")) "/" (file-relative-name bfn vc-dir)))
     (bfn bfn)
     (t (buffer-name)))))

(defun +smart-file-name-cached ()
  (if (eq (buffer-name) (car +smart-file-name-cache))
      (cdr +smart-file-name-cache)
    (let ((file-name (+smart-file-name)))
      (setq +smart-file-name-cache
            (cons (buffer-name) file-name))
      file-name)))

(provide 'init-utils)
