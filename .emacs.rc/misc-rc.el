(require 'ansi-color)

(global-set-key (kbd "C-x C-g") 'find-file-at-point)
(global-set-key (kbd "C-c i m") 'imenu)
(global-set-key (kbd "M-w") 'kill-region)
(global-set-key (kbd "C-w") 'kill-ring-save)

(setq-default inhibit-splash-screen t
              make-backup-files nil
							tab-width 2
							indent-tabs-mode t
							compilation-scroll-output t
							visible-bell (equal system-type 'windows-nt))

(defun rc/colorize-compilation-buffer ()
  (read-only-mode 'toggle)
  (ansi-color-apply-on-region compilation-filter-start (point))
  (read-only-mode 'toggle))
(add-hook 'compilation-filter-hook 'rc/colorize-compilation-buffer)

(defun rc/buffer-file-name ()
  (if (equal major-mode 'dired-mode)
      default-directory
    (buffer-file-name)))

(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-,") 'rc/duplicate-line)


(defun rc/rgrep-selected (beg end)
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list nil nil)))
  (let* ((pattern (if (and beg end)
                      (buffer-substring-no-properties beg end)
                    (or (thing-at-point 'symbol t)
                        (user-error "No region selected and no symbol at point"))))
         (dir (if (derived-mode-p 'dired-mode)
                  default-directory
                (or (and (buffer-file-name)
                         (file-name-directory (buffer-file-name)))
                    default-directory)))
         (default-directory dir)
         (command (format "rg --line-number --column --no-heading --color never --glob %s -e %s ."
                          (shell-quote-argument "*")
                          (shell-quote-argument pattern))))
    (compilation-start command 'grep-mode)))

(global-set-key (kbd "C-x p s") 'rc/rgrep-selected)

(setq x-alt-keysym 'meta)

(setq confirm-kill-emacs 'y-or-n-p)

(windmove-default-keybindings)
