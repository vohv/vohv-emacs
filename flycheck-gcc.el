;;; -*- lexical-binding: t -*-
(defun flycheck-gcc-header-file-p (file)
 (if (seq-find (lambda (ext)
            (string= (file-name-extension file) ext))
          (list "h" "hpp" "hh"))
     t
   nil))

(defun flycheck-gcc-get-arg-by-entry (entry)
  (when-let* ((cmd (cdr (assq 'command entry)))
              (arg (replace-regexp-in-string
                    " +-o .*" ""
                    (replace-regexp-in-string
                     "^[^ ]+ +" "" cmd))))
    arg))

(defun flycheck-gcc-get-dir-by-entry (entry)
  (cdr (assq 'directory entry)))

(defun flycheck-gcc-matched-pred (file)
  (lambda (entry)
    (equal (file-truename (cdr (assq 'file entry))) file)))

(defun flycheck-gcc-cpp-pred (file)
  (lambda ()
    (string-match-p "cpp" (file-truename (cdr (assq 'file entry))))))

(defun flycheck-gcc-find-entry (pred db)
  (seq-find pred db))

(defun flycheck-gcc-find-header-other-file (file)
  (when-let* ((default-directory project)
              (shell-command (format "fd -g '%s.{c,cpp,cc}' -c never ."
                                     (file-name-base file)))
              (file (nth 0 (split-string (shell-command-to-string shell-command) "\n")))
              (full-path (expand-file-name file project)))
    full-path))

(defun flycheck-gcc-get-arg (file)
  (require 'json)
  (when-let* ((project (projectile-project-root))
              (compile-db (json-read-file (expand-file-name "build/compile_commands.json" project)))
              (header-file-p (lambda () (flycheck-gcc-header-file-p file)))
              (cpp-file (if (funcall header-file-p)
                            (flycheck-gcc-find-header-other-file file)
                          file))
              (matched-pred (if cpp-file
                                (flycheck-gcc-matched-pred file)
                              (flycheck-gcc-cpp-pred file)))
              (matched-entry (flycheck-gcc-find-entry matched-pred compile-db))
              (arg (flycheck-gcc-get-arg-by-entry matched-entry)))
    arg))

(flycheck-gcc-get-arg "/home/zhuohui/ceph-int/src/os/xstore2/mscache/mscache.cpp")
