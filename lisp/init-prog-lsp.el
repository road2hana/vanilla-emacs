(use-package lsp-mode
  :commands
  (lsp lsp-deferred)
  :hook
  ((lsp-mode . (lambda () (setq-local evil-lookup-func #'lsp-describe-thing-at-point)))
   (lsp-mode . lsp-enable-which-key-integration))
  :general
  (lc/local-leader-keys
    :states 'normal
    :keymaps 'lsp-mode-map
    "i" '(:ignore t :which-key "import")
    "i o" '(lsp-organize-imports :wk "optimize")
    "l" '(:keymap lsp-command-map :wk "lsp")
    "a" '(lsp-execute-code-action :wk "code action")	
    "r" '(lsp-rename :wk "rename"))
  ;; (lsp-mode-map
  ;;  :states 'normal
  ;;  "gD" 'lsp-find-references)
  :init
  (setq lsp-restart 'ignore)
  (setq lsp-eldoc-enable-hover nil)
  (setq lsp-enable-file-watchers nil)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-keep-workspace-alive nil)
  (setq lsp-auto-execute-action nil)
  (setq lsp-before-save-edits nil)
	(setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-diagnostics-provider :none)
  )

(use-package lsp-ui
  :hook
  ((lsp-mode . lsp-ui-mode)
   ;; (lsp-mode . (lambda () (setq-local evil-goto-definition-functions '(lambda (&rest args) (lsp-ui-peek-find-definitions)))))
   )
  ;; :bind
  ;; (:map lsp-ui-mode-map
  ;;       ([remap lsp-find-references] . lsp-ui-peek-find-references))
  :general
  (lc/local-leader-keys
    "h" 'lsp-ui-doc-show
    "H" 'lsp-ui-doc-hide)
  (lsp-ui-peek-mode-map
   :states 'normal
   "C-j" 'lsp-ui-peek--select-next
   "C-k" 'lsp-ui-peek--select-prev)
  (outline-mode-map
   :states 'normal
   "C-j" 'nil
   "C-k" 'nil)
  :init
  (setq lsp-ui-doc-show-with-cursor nil)
  (setq lsp-ui-doc-show-with-mouse nil)
  (setq lsp-ui-peek-always-show t)
  (setq lsp-ui-peek-fontify 'always)
  )

(use-package dap-mode
  :hook
  ((dap-terminated . lc/hide-debug-windows)
   (dap-ui-repl-mode . (lambda () (setq-local truncate-lines t))))
  :general
  (lc/local-leader-keys
    :keymaps 'python-mode-map
    "d d" '(dap-debug :wk "debug")
    "d b" '(dap-breakpoint-toggle :wk "breakpoint")
    "d c" '(dap-continue :wk "continue")
    "d n" '(dap-next :wk "next")
    "d e" '(dap-eval-thing-at-point :wk "eval")
    "d i" '(dap-step-in :wk "step in")
    "d q" '(dap-disconnect :wk "quit")
    "d r" '(dap-ui-repl :wk "repl")
    "d h" '(dap-hydra :wk "hydra")
    "d i" '(lc/dap-inspect-df :wk "view df")
    "d I" '(lc/dap-inspect-df2 :wk "view df2")
    "d t" '(lc/dap-dtale-df :wk "dtale df")
    )
  (:keymaps 'dap-ui-repl-mode-map
            "TAB" 'lc/py-indent-or-complete)
  :init
  ;; (defun lc/dap-dtale-df (dataframe)
  ;;   "Show df in tale in default browser"
  ;;   (interactive (list (read-from-minibuffer "DataFrame: " (evil-find-symbol nil))))
  ;;   (dap-eval (concat "import dtale; dtale.show(" dataframe ", open_browser=True)")))
  (defun lc/dap-inspect-df (dataframe)
    "Save the df to csv and open the file with csv-mode"
    (interactive (list (read-from-minibuffer "DataFrame: " (evil-find-symbol nil))))
    (dap-eval (concat dataframe ".to_csv('~/tmp-inspect-df.csv', index=False)"))
    (sleep-for 1)
    (with-current-buffer 
        (display-buffer
         (with-current-buffer (find-file-noselect "~/tmp-inspect-df.csv")
           (rename-buffer "*inspect-df*"))
         '((;display-buffer-in-side-window
            display-buffer-reuse-window)
           (side . right)
           (window-width . 0.5)
           )))
    )
	(defun lc/dap-inspect-df2 (dataframe)
    "Save the df to csv and open the file with csv-mode"
    (interactive (list (read-from-minibuffer "DataFrame: " (evil-find-symbol nil))))
    (dap-eval (concat dataframe ".to_csv('~/tmp-inspect-df2.csv', index=False)"))
    (sleep-for 1)
    (with-current-buffer 
        (display-buffer
         (with-current-buffer (find-file-noselect "~/tmp-inspect-df2.csv")
           (rename-buffer "*inspect-df2*"))
         '((;display-buffer-in-side-window
            display-buffer-reuse-window)
           (side . right)
           (window-width . 0.5)
           )))
    )
  ;; (add-to-list 'display-buffer-alist
  ;;              '(("*inspect-df*"
  ;;                 (display-buffer-reuse-window display-buffer-in-side-window)
  ;;                 (side . bottom)
  ;;                 (reusable-frames . visible)
  ;;                 (window-height . 0.33)
  ;;                 )))
  ;; (setq dap-auto-configure-features '(locals repl))
  (setq dap-auto-configure-features '(sessions repl))
  (setq dap-python-debugger 'debugpy)
  ;; show stdout
  (setq dap-auto-show-output t)
  (setq dap-output-window-min-height 10)
  (setq dap-output-window-max-height 200)
  (setq dap-overlays-use-overlays nil)
  ;; hide stdout window  when done
  (defun lc/hide-debug-windows (session)
    "Hide debug windows when all debug sessions are dead."
		;; (when (get-buffer "*inspect-df*")
		;; 	(delete-window (get-buffer-window  "*inspect-df*")))
    (unless (-filter 'dap--session-running (dap--get-sessions))
      (kill-buffer (dap--debug-session-output-buffer (dap--cur-session-or-die))))
    )
  (defun lc/dap-python--executable-find (orig-fun &rest args)
    (executable-find "python"))
  :config
  ;; configure windows
  (require 'dap-ui)
  (setq dap-ui-buffer-configurations
        '(("*dap-ui-sessions*"
           (side . bottom)
           (slot . 1)
           (window-height . 0.33))
          ("*debug-window*"
           (side . bottom)
           (slot . 2)
           (window-height . 0.33))
          ("*dap-ui-repl*"
           (side . bottom)
           (slot . 3)
           (window-height . 0.33))))
  (dap-ui-mode 1)
  ;; python virtualenv
  (require 'dap-python)
  (advice-add 'dap-python--pyenv-executable-find :around #'lc/dap-python--executable-find)
  ;; debug templates
  (defvar dap-script-args (list :type "python"
                                :args []
                                :cwd "${workspaceFolder}"
                                :justMyCode :json-false
                                :request "launch"
                                :debugger 'debugpy
                                :name "dap-debug-script"))
  (defvar dap-test-args (list :type "python-test-at-point"
                              :args ""
                              :justMyCode :json-false
                              ;; :cwd "${workspaceFolder}"
                              :request "launch"
                              :module "pytest"
                              :debugger 'debugpy
                              :name "dap-debug-test-at-point"))
  (defvar empties-forecast (list
                            :name "empties forecast"
                            :type "python"
                            :request "launch"
                            :program "./src/empties/forecasting/predict.py"
                            :env '(("NO_JSON_LOG" . "true"))
                            :args ["--source01" "./data/empties-history-sample.parquet"
                                   "--source02" "./data/model_selection.files"
                                   "--source03" "./data/booking-feature-sample.parquet"
                                   "--source04" "./data/holiday-2019-05-24-1558683595"
                                   "--output-data" "./data/predictions.parquet"
                                   "--output-metrics" "./data/metrics.json"]
                            ))
  (dap-register-debug-template "dap-debug-script" dap-script-args)
  (dap-register-debug-template "dap-debug-test-at-point" dap-test-args)
  ;; bind the templates
  (lc/local-leader-keys
    :keymaps 'python-mode-map
    "d t" '((lambda () (interactive) (dap-debug dap-test-args)) :wk "test")
    "d s" '((lambda () (interactive) (dap-debug dap-script-args)) :wk "script")
    )
  )

(provide 'init-prog-lsp)
;;; init-prog-lsp.el ends here
