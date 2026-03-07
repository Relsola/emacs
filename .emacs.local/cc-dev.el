;;; https://github.com/tree-sitter/tree-sitter-c
;;; https://github.com/tree-sitter/tree-sitter-cpp
;;; ~/.emacs.d/tree-sitter/

(dolist (pair '((c-mode . c-ts-mode)
                (c++-mode . c++-ts-mode)))
  (add-to-list 'major-mode-remap-alist pair))

(setq treesit-font-lock-level 4)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               `((c-ts-mode c++-ts-mode c-or-c++-ts-mode) . ("clangd"))))

;;; 保存时格式化
(defun cc-eglot-format-before-save ()
  (add-hook 'before-save-hook #'eglot-format-buffer nil t))

(defun cc-insert-single-right-arrow ()
  (interactive)
	(insert "->")
	(when (bound-and-true-p company-mode)
    (company-manual-begin)))

(defun cc-eldoc-peek-focus ()
  (interactive)
  (eldoc-doc-buffer t)
  (let ((win (get-buffer-window "*eldoc*")))
    (when win
      (select-window win))))

(defun cc-bind-key ()
  (local-set-key (kbd "C-.") #'cc-insert-single-right-arrow)
	;;; 变量重构
	(local-set-key (kbd "<f2>") #'eglot-rename)
	;;; 打开文档
	(local-set-key (kbd "C-c C-h") #'eldoc-doc-buffer)
	(local-set-key (kbd "C-c h") #'cc-eldoc-peek-focus))

(dolist (hook '(c-ts-mode-hook c++-ts-mode-hook c-or-c++-ts-mode-hook))
  (add-hook hook #'eglot-ensure)
  (add-hook hook #'cc-eglot-format-before-save)
	(add-hook hook #'cc-bind-key))

(when (eq system-type 'windows-nt)
	(setq shell-file-name "pwsh")
	(setq shell-command-switch "-c"))

(provide 'cc-dev)
