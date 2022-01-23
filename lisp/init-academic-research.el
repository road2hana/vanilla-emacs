;; Helm configuration
  (use-package helm
    :config
    (require 'helm-config)
    :init
    (helm-mode 1)
    :bind
    (("M-x"     . helm-M-x) ;; Evaluate functions
     ("C-x C-f" . helm-find-files) ;; Open or create files
     ("C-x b"   . helm-mini) ;; Select buffers
     ("C-x C-r" . helm-recentf) ;; Select recently saved files
     ("C-c i"   . helm-imenu) ;; Select document heading
     ("M-y"     . helm-show-kill-ring) ;; Show the kill ring
     :map helm-map
     ("C-z" . helm-select-action)
     ("<tab>" . helm-execute-persistent-action)))


;; Change fields and format
(setq bibtex-user-optional-fields '(("keywords" "Keywords to describe the entry" "")
                                    ("file" "Link to document file." ":"))
      bibtex-align-at-equal-sign t)

(setq bib-files-directory (directory-files
                           (concat (getenv "HOME") "/Documents/bibliography") t
                           "^[A-Z|a-z].+.bib$")
      pdf-files-directory (concat (getenv "HOME") "/Documents/pdf"))

(use-package helm-bibtex
	:bind (("C-c r" . helm-bibtex))
  :config
	(autoload 'helm-bibtex "helm-bibtex" "" t)
  (require 'helm-config)
  (setq bibtex-completion-bibliography bib-files-directory
        bibtex-completion-library-path pdf-files-directory
        bibtex-completion-pdf-field "File"
        bibtex-completion-notes-path org-directory))
;; PDF
(use-package pdf-tools
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page)
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  (setq pdf-view-resize-factor 1.1)
  (setq pdf-annot-activate-created-annotations t)
  (setq pdf-view-midnight-colors '("#3F3F3F" . "#DCDCCC")) ;; for Zenburn theme
  (add-hook 'pdf-tools-enabled-hook 'pdf-view-midnight-minor-mode)
  (define-key pdf-view-mode-map (kbd "h") 'pdf-annot-add-highlight-markup-annotation)
  (define-key pdf-view-mode-map (kbd "t") 'pdf-annot-add-text-annotation)
  (define-key pdf-view-mode-map (kbd "D") 'pdf-annot-delete))

;; markdown-mode No frills, just needed for syntax highlighting:
(use-package markdown-mode)

;; writeroom-mode I keep thinking I’ll use this, but haven’t needed it much yet.
(use-package writeroom-mode
  :bind (("<f9>" . writeroom-mode))
  :config
  (setq writeroom-width 96))

;; Word wrap and spacing settings
(global-visual-line-mode 1)
;;However, I now believe that there is a better way for writers using Emacs to handle this situation: leave this setting out and use the default fill-paragraph functionality (M-q), with a sensible fill-column setting (I understand that 80 is traditional).
(setq-default fill-column 80)
;;This last setting lets Emacs know that a sentence ends after a single (rather than double) space. I learned to double-space after full stops, but am gradually adjusting.
(setq sentence-end-double-space nil)


(provide 'init-academic-research)
;; init-academic-research.el ends here


