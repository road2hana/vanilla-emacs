(use-package lsp-julia
  :config
  (setq lsp-julia-default-environment "~/.julia/environments/v1.7"))

(add-hook 'ess-julia-mode-hook #'lsp-mode)

(provide 'init-prog-julia)
;;; init-prog-julia.el ends here
