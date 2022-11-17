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
   '(kind-icon nix-mode virtualenvwrapper eshell-prompt-extras yasnippet-snippets yasnippet good-scroll ripgrep vterm helpful which-key ef-themes doom-themes orderless evil-snipe expand-region nyan-mode minimap magit all-the-icons-completion consult-dir vertico rainbow-delimiters smartparens evil-surround marginalia use-package undo-tree highlight-numbers doom-modeline corfu-doc)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
