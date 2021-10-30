;;; -*- lexical-binding: t -*-

(defun +split-window-dwim ()
  "Split window.
If the window is wide enough, split at right, otherwise split at below."
  (interactive)
  (if (> (/ (window-width)
            (window-height))
         3)
      (split-window-right)
    (split-window-below)))

(defun +rotate-window ()
  "Rotate all windows clockwise."
  (interactive)
  (let* ((wl (window-list nil nil (minibuffer-window)))
         (bl (reverse (mapcar (lambda (w) (window-buffer w)) wl)))
         (nbl (append (cdr bl) (list (car bl)))))
    (cl-loop for w in wl
          for b in (reverse nbl)
          do (set-window-buffer w b))
    (select-window (next-window))))

(defun +window-rotate-layout ()
  "Toggle between horizontal and vertical split with two windows."
  (interactive)
  (if (> (length (window-list)) 2)
      (error "Can't toggle with more than 2 windows!")
    (let ((func (if (window-full-height-p)
                    #'split-window-vertically
                  #'split-window-horizontally)))
      (delete-other-windows)
      (funcall func)
      (save-selected-window
        (other-window 1)
        (switch-to-buffer (other-buffer))))))
(provide 'init-window)
