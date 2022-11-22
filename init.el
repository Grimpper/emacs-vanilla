(require 'org)
(org-babel-load-file
 (expand-file-name
  "config.org"
  user-emacs-directory))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(vterm ripgrep helpful which-key ef-themes virtualenvwrapper good-scroll doom-themes orderless evil-snipe pyvenv expand-region nyan-mode minimap magit all-the-icons-completion consult-dir eshell-syntax-highlighting eshell-prompt-extras yasnippet-snippets vertico rainbow-delimiters smartparens iedit org-superstar evil-surround marginalia use-package evil-goggles undo-tree esh-autosuggest nix-mode highlight-numbers doom-modeline corfu-doc kind-icon)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-goggles-change-face ((t (:inherit diff-removed))))
 '(evil-goggles-delete-face ((t (:inherit diff-removed))))
 '(evil-goggles-paste-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-add-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-change-face ((t (:inherit diff-changed))))
 '(evil-goggles-undo-redo-remove-face ((t (:inherit diff-removed))))
 '(evil-goggles-yank-face ((t (:inherit diff-changed))))
 '(org-document-title ((t (:font "DejaVuSansMono Nerd Font Mono" :height 1.3 :weight bold :foreground "sky blue"))))
 '(org-level-1 ((t (:font "DejaVuSansMono Nerd Font Mono" :height 1.15 :weight bold))))
 '(org-level-2 ((t (:font "DejaVuSansMono Nerd Font Mono" :height 1.1 :weight bold))))
 '(org-level-3 ((t (:font "DejaVuSansMono Nerd Font Mono" :height 1.05 :weight bold))))
 '(org-level-4 ((t (:font "DejaVuSansMono Nerd Font Mono" :height 1.0 :weight bold))))
 '(org-level-5 ((t (:font "DejaVuSansMono Nerd Font Mono"))))
 '(org-level-6 ((t (:font "DejaVuSansMono Nerd Font Mono"))))
 '(org-level-7 ((t (:font "DejaVuSansMono Nerd Font Mono"))))
 '(org-level-8 ((t (:font "DejaVuSansMono Nerd Font Mono")))))
