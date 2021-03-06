;;; -*- lexical-binding: t -*-

(straight-use-package '(meow :type git :host github :repo "meow-edit/meow"))

(defun +self-insert-in-region ()
  (interactive)
  (let* ((e (meow--event-key last-input-event)))
    (when (use-region-p)
    (self-insert-command 1))))

(defun meow-setup ()
  (setq meow-cheatsheet-physical-layout meow-cheatsheet-physical-layout-ansi)
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)

  (meow-leader-define-key
   ;; cheatsheet
   '("?" . meow-cheatsheet)
   ;; high frequency keybindings
   '("e" . "C-x C-e")
   '(")" . "C-)")
   '("}" . "C-}")
   '("." . "M-.")
   '("," . "M-,")
   '("/" . "M-?")
   ;; window management
   '("w" . other-window)
   '("W" . window-swap-states)
   '("o" . delete-other-windows)
   '("s" . split-window-below)
   '("-" . split-window-right)
   ;; overwrited motion key
   '("$" . "H-$")
   ;; high frequency commands
   '(";" . comment-dwim)
   '("K" . kill-this-buffer)
   '("d" . dired)
   '("b" . switch-to-buffer)
   '("r" . rgrep)
   '("R" . +window-rotate-layout)
   '("f" . find-file)
   '("i" . imenu)
   '("a" . execute-extended-command)
   '("=" . "C-c ^")
   '("p" . "C-x p f")
   '("j" . project-switch-to-buffer)
   '("t" . tab-bar-switch-to-tab)
   '("v" . "C-x g")
   '("l" . "C-x p p")
   '("n" . "C-x M-n")
   ;; toggles
   '("L" . display-line-numbers-mode)
   '("S" . smartparens-strict-mode)
   '("T" . telega)
   '("P" . pass)
   '("A" . org-agenda)
   '("D" . docker)
   '("E" . elfeed-dashboard)
   '("F" . flymake-mode)
   '("\\" . dired-sidebar-toggle-sidebar))
  (meow-motion-overwrite-define-key
   '("$" . repeat)
   '("'" . repeat)
   '("n" . next-line)
   '("p" . previous-line)
   '("M-n" . "H-n")
   '("M-p" . "H-p")
   '("<escape>" . +project-previous-buffer))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . mode-line-other-buffer)))

(setq
 meow-cursor-type-keypad 'box
 meow-cursor-type-insert '(bar .3)
 meow-esc-delay 0.001
 meow-keypad-describe-delay 0.5
 meow-select-on-change t
 meow-replace-state-name-list '((normal . "N")
                                (motion . "M")
                                (keypad . "K")
                                (insert . "I")
                                (bmacro . "B")))

(require 'meow)

(meow-global-mode 1)

(with-eval-after-load "meow"
  ;; make Meow usable in TUI Emacs
  (meow-esc-mode 1)
  (add-to-list 'meow-mode-state-list '(inf-iex-mode . normal))
  (add-to-list 'meow-mode-state-list '(authinfo-mode . normal))
  (add-to-list 'meow-mode-state-list '(Custom-mode . normal))
  (add-to-list 'meow-mode-state-list '(cider-test-report-mode . normal))
  (add-to-list 'meow-mode-state-list '(comint-mode . normal))
  (add-to-list 'meow-mode-state-list '(color-rg-mode . motion))
  (add-to-list 'meow-mode-state-list '(cargo-process-mode . normal))
  (add-to-list 'meow-mode-state-list '(shell-mode . normal))
  (add-to-list 'meow-mode-state-list '(elfeed-dashboard-mode . motion))
  (setq meow-grab-fill-commands nil)
  (setq meow-visit-sanitize-completion t)
  ;; use << and >> to select to bol/eol
  (add-to-list 'meow-char-thing-table '(?> . line))
  (add-to-list 'meow-char-thing-table '(?< . line))
  ;; define our command layout
  (meow-setup))

(provide 'init-modal)
