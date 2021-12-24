(straight-use-package 'cmake-mode)
(straight-use-package '(company-cmake :host github :repo "purcell/company-cmake"))

(when-let* (
            (e (executable-find "cmake"))
            )
  (setq company-cmake-executable e)
  (setq cmake-mode-cmake-executable e))

(when-let* (
            (e (executable-find "cmake3"))
            )
  (setq company-cmake-executable e)
  (setq cmake-mode-cmake-executable e))

(with-eval-after-load "company"
  (add-to-list 'company-backends 'company-cmake))

(provide 'init-cmake)
