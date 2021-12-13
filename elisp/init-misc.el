;;; -*- lexical-binding: t -*-

(straight-use-package 'restart-emacs)

(defun +project-previous-buffer (arg)
  (interactive "P")
  (unless arg
    (if-let ((pr (project-current)))
        (switch-to-buffer
         (->> (project--buffer-list pr)
              (--remove (or (minibufferp it)
                            (get-buffer-window-list it)))
              (car)))
      (mode-line-other-buffer))))
(provide 'init-misc)
