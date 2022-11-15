;; Use-package
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/"))
      package-quickstart t)

(unless (and (fboundp 'package-installed-p)
             (package-installed-p 'use-package))
  (package-initialize)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)

;; Basic emacs config
(use-package emacs
  ;; Vertico configurations...
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t) 
  :config
  ;; Emacs internal options
  (setq-default user-full-name "Grimpper"
                inhibit-startup-screen t
                custom-safe-themes t)
  (if init-file-debug
      (setq warning-minimum-level :debug)
    (setq warning-minimum-level :emergency))
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (show-paren-mode 1)
  (blink-cursor-mode 0)
  (fringe-mode '(0 . 0))
  ;; No scroll bar
  (add-to-list 'default-frame-alist
               '(vertical-scroll-bars . nil))
  ;; No jump arround
  (setq scroll-conservatively 101
	scroll-margin 2)
  ;; Font
  (add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font-14"))
  ;; Remember line number
  (save-place-mode 1)
  ;; Additional functions
  (defun my-reload-emacs ()
    "Reload the Emacs configuration"
    (interactive)
    (load-file "~/.emacs.d/init.el"))
  :bind
  (;; Make ESC close prompts
   ("<escape>" . keyboard-escape-quit))
  :hook (prog-mode . display-line-numbers-mode))

;; Custom config file
(let
    ((customization-file (expand-file-name "custom.el" user-emacs-directory)))
  (when (file-exists-p customization-file)
    (setq custom-file customization-file)
    (load custom-file 'noerror)))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; Only highlight prog & text buffers
(use-package hl-line
  :hook
  (prog-mode . hl-line-mode)
  (text-mode . hl-line-mode))

;; Undo system
(use-package undo-tree
  :init
  (global-undo-tree-mode)
  :config
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))
        undo-tree-visualizer-timestamps t
        undo-tree-visualizer-diff t))

;; Evil
(use-package evil
  :demand t
  :bind (:map evil-motion-state-map
	      ;; Unbound confliction keys
              ("C-e" . nil)
              ("C-y" . nil)
              ("TAB" . nil)
	      ("C-<up>" . evil-scroll-line-up)
              ("C-<down>" . evil-scroll-line-down))
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-tree)
  (mapc (lambda (mode)
          (evil-set-initial-state mode 'emacs))
        '(eww-mode
          profiler-report-mode
          pdf-view-mode
          eshell-mode
          vterm-mode))
  :init
  (setq evil-ex-substitute-global t     ; I like my s/../.. to by global by default
        evil-move-cursor-back nil       ; Don't move the block cursor when toggling insert mode
        evil-kill-on-visual-paste nil))

;; Evil-surround
(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

;; Evil-snipe
(use-package evil-snipe
  :ensure t
  :after evil
  :config
  (evil-snipe-override-mode 1))

;; Expand region
(use-package expand-region
  :after evil
  :bind ("C-e" . er/expand-region))

;; Themes
(use-package ef-themes
  :config
  (load-theme 'ef-night t))

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; Highlight numbers
(use-package highlight-numbers
  :hook
  (prog-mode . highlight-numbers-mode))

;; Handle very long lines
(use-package so-long
  :hook (after-init-hook . global-so-long-mode))

;; Improved parenthesis
(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config
  (require 'smartparens-config)
  (setq sp-highlight-pair-overlay nil) ;; Do not highlight space between parentheses when they are inserted
  :bind (("M-i" . sp-forward-slurp-sexp)
	 ("M-I" . sp-backward-slurp-sexp)
	 ("M-o" . sp-forward-barf-sexp)
	 ("M-O" . sp-backward-barf-sexp)))

;; Highlight parenthesis
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Minimap
(use-package minimap
  :config
  (setq minimap-window-location 'right
	minimap-minimum-width 10
	minimap-dedicated-window nil
	minimap-hide-cursor nil
	minimap-hide-scroll-bar t
	minimap-hide-fringes t))

;; Which-key
(use-package which-key
  :diminish
  :custom
  (which-key-idle-secondary-delay 0.01)
  :config
  (which-key-mode t))

;; Improved help system
(use-package helpful
  :custom
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ("C-h f" . helpful-function)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key))

;; Vertico
;; Enable vertico
(use-package vertico
  :custom
  (vertico-cycle t)
  :bind
  (:map vertico-map
	("<prior>" . vertico-scroll-down)
	("<next>" . vertico-scroll-up)
        ("<escape>" . minibuffer-keyboard-quit))
  :config
  (add-hook 'minibuffer-setup-hook #'vertico-repeat-save)
  (global-set-key "\M-'" #'vertico-repeat)
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Configure directory extension.
(use-package vertico-directory
  :after vertico
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package vertico-mouse
  :after vertico
  :load-path "straight/repos/vertico/extensions/"
  :init (vertico-mouse-mode))

;; Enable icons into the vertico completion
(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :config (setq all-the-icons-scale-factor 1.0)
  :init (all-the-icons-completion-mode))

(advice-add #'vertico--format-candidate :around
            (lambda (orig cand prefix suffix index _start)
              (setq cand (funcall orig cand prefix suffix index _start))
              (concat
               (if (= vertico--index index)
                   (propertize "» " 'face 'vertico-current)
                 "  ")
               cand)))

(use-package marginalia
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
           ("M-A" . marginalia-cycle))
  :custom
    (marginalia-max-relative-age 0)
    (marginalia-align 'left)
  :init
    (marginalia-mode))

;; Consult
(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key (kbd "M-.")
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
)

;; Consult-dir
(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map vertico-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

;; Corfu
(use-package corfu
  ;; Optional customizations
  :custom
  (corfu-cycle t)                  ; Allows cycling through candidates
  (corfu-auto t)                   ; Enable auto completion
  (corfu-auto-prefix 2)            ; Enable auto completion
  (corfu-auto-delay 0.0)           ; Enable auto completion
  (corfu-quit-at-boundary 'separator)
  (corfu-echo-documentation 0.25)   ; Enable auto completion
  (corfu-preview-current 'insert)   ; Do not preview current candidate
  (tab-always-indent 'complete)


  ;; Optionally use TAB for cycling, default is `corfu-complete'.
  :bind (:map corfu-map
              ("C-SPC" . corfu-insert-separator))

  :init
  (global-corfu-mode)
  :hook
  (eshell-mode . (lambda ()
		   (setq-local corfu-auto nil)
		   (corfu-mode)))
  :config
  (defun corfu-enable-always-in-minibuffer ()
    "Enable Corfu in the minibuffer if Vertico/Mct are not active."
    (unless (or (bound-and-true-p mct--active)
		(bound-and-true-p vertico--input))
      (setq-local corfu-auto t)
      (corfu-mode)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer))

(use-package corfu-history
  :after corfu
  :load-path "~/.emacs.d/straight/repos/corfu/extensions"
  :init
  (global-corfu-mode))

(use-package corfu-doc
  :after corfu
  :bind (:map corfu-map
	      ("M-e" . corfu-doc-scroll-down)
	      ("M-d" . corfu-doc-scroll-up)
	      ("M-c" . corfu-doc-toggle))
  :hook (corfu-mode-hook . corfu-doc-mode))

(defun corfu-send-shell (&rest _)
  "Send completion candidate when inside comint/eshell."
  (cond
   ((and (derived-mode-p 'eshell-mode) (fboundp 'eshell-send-input))
    (eshell-send-input))
   ((and (derived-mode-p 'comint-mode)  (fboundp 'comint-send-input))
    (comint-send-input))))

(advice-add #'corfu-insert :after #'corfu-send-shell)

(use-package magit)


;; --- Custom variables ---
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(magit doom-modeline nyan-mode ripgrep vterm helpful which-key ef-themes doom-themes orderless expand-region minimap all-the-icons-completion consult-dir vertico rainbow-delimiters smartparens evil-surround marginalia use-package undo-tree highlight-numbers corfu-doc)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
