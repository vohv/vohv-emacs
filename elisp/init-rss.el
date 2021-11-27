;;; -*- lexical-binding: t -*-

(straight-use-package 'elfeed)

;; elfeed
(autoload #'elfeed "elfeed" nil t)

(setq elfeed-curl-extra-arguments
      `("--socks5-hostname" ,(concat +proxy-host ":" (number-to-string +proxy-port))))

;; elfeed-dashboard
(straight-use-package 'elfeed-dashboard)

(with-eval-after-load "elfeed-dashboard"
  (setq elfeed-dashboard-file
        (no-littering-expand-etc-file-name "elfeed/elfeed-dashboard.org"))
  (advice-add 'elfeed-search-quit-window :after #'elfeed-dashboard-update-links))

(autoload #'elfeed-dashboard "elfeed-dashboard" nil t)

;; elfeed-org
(straight-use-package 'elfeed-org)

(setq rmh-elfeed-org-files (list (no-littering-expand-etc-file-name "elfeed/elfeed-feeds.org")))

(provide 'init-rss)
