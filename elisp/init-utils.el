;;; -*- lexical-binding: t -*-

(straight-use-package 'dash)

(require 'dash)
(require 'subr-x)

(defun +ensure (feature)
  "Make sure FEATURE is required."
  (unless (featurep feature)
    (condition-case nil
        (require feature)
      (error nil))))

(defun +in-string-p ()
  "Return non-nil if inside string, else nil.
Result depends on syntax table's string quote character."
  (interactive)
  (or (nth 3 (syntax-ppss))
      (member 'font-lock-string-face
              (text-properties-at (point)))))

(defun +in-comment-p ()
  "Return non-inl if inside comment, else nil.
Result depends on syntax table's comment character."
  (interactive)
  (nth 4 (syntax-ppss)))

(defvar +smart-file-name-cache nil)

(defun +project-root-dir ()
  (when-let* ((pc (project-current)))
    (project-root pc)))

(defun +smart-file-name ()
  "Get current file name, if we are in project, the return relative path to the project root, otherwise return absolute file path.
This function is slow, so we have to use cache."
  (let ((project-dir (+project-root-dir))
        (bfn (buffer-file-name (current-buffer))))
    (cond
     ((and bfn project-dir)
      (concat
       (propertize
        (car
         (reverse
          (split-string (string-trim-right project-dir "/") "/")))
        'face
        'bold)
       "/"
       (file-relative-name bfn project-dir)))
     (bfn bfn)
     (t (buffer-name)))))

(defun +smart-file-name-cached ()
  (if (eq (buffer-name) (car +smart-file-name-cache))
      (cdr +smart-file-name-cache)
    (let ((file-name (+smart-file-name)))
      (setq +smart-file-name-cache
            (cons (buffer-name) file-name))
      file-name)))

(defun +vc-branch-name ()
  (when vc-mode
    (propertize
     (replace-regexp-in-string
      "Git[-:]"
      ""
      (substring-no-properties vc-mode))
     'face
     'bold)))

(defun +which-linux-distribution ()
  "from lsb_release"
  (interactive)
  (when-let* ((lsb_release_command (executable-find "lsb_release"))
              (is-linux (eq system-type 'gnu/linux)))
    (shell-command-to-string "lsb_release -sir")))


(require 'cl-lib)
(defmacro make-sparse-keymap-local (&rest bindings)
  (declare (indent 2))
  (let ((map (make-symbol "map")))
    `(let ((,map (make-sparse-keymap)))
       ,@(cl-loop for (key . cmd) in bindings
                  collect `(define-key ,map ,key ,cmd))
       ,map)))


(provide 'init-utils)
