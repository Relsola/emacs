;;; https://pavinberg.github.io/emacs-book/zh/development/

(use-package company
 :ensure t
 :init (global-company-mode)
 :config
 (setq company-minimum-prefix-length 1)
 (setq company-tooltip-align-annotations t)
 (setq company-idle-delay 0.0)
 (setq company-show-numbers t)
 (setq company-selection-wrap-around t)
 (setq company-transformers '(company-sort-by-occurrence)))

(use-package company-box
   :ensure t
   :if window-system
   :hook (company-mode . company-box-mode))

(use-package yasnippet
 :ensure t
 :hook
 (prog-mode . yas-minor-mode)
 :config
 (yas-reload-all)

 (defun company-mode/backend-with-yas (backend)
  (if (and (listp backend) (member 'company-yasnippet backend))
   backend
   (append (if (consp backend) backend (list backend))
        '(:with company-yasnippet))))
 (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

 (define-key yas-minor-mode-map [(tab)]    nil)
 (define-key yas-minor-mode-map (kbd "TAB")  nil)
 (define-key yas-minor-mode-map (kbd "<tab>") nil)
 :bind
 (:map yas-minor-mode-map ("S-<tab>" . yas-expand)))

(use-package yasnippet-snippets
 :ensure t
 :after yasnippet)

(global-set-key (kbd "M-/") 'hippie-expand)

(provide 'init-dev)
