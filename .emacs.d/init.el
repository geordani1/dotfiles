;;; Customization settings - separate from main config
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;;; Minimal UI Experience
(menu-bar-mode -1)       ; Disable menu bar
(tool-bar-mode -1)       ; Disable tool bar
(scroll-bar-mode -1)     ; Disable scroll bars
(setq inhibit-startup-screen t)  ; Disable startup screen

;;; Better Defaults
(setq ring-bell-function 'ignore)  ; Disable audible bell

;;; Disable Backup/Auto-save Files
(setq make-backup-files nil)     ; No backup files
(setq backup-inhibited t)        ; Inhibit backups
(setq auto-save-default nil)     ; Disable auto-save
(setq create-lockfiles nil)      ; Disable lock files

;;; Line and Column Information
(global-display-line-numbers-mode 1)  ; Show line numbers globally
(setq display-line-numbers-type 'relative) ; Relative line numbers
(column-number-mode 1)             ; Show column in mode-line

;;; Global Programming Settings
(setq-default indent-tabs-mode nil)  ; Use spaces for indentation
(setq-default tab-width 4)           ; Set tab width to 4 spaces
(setq-default fill-column 80)        ; Wrap at 80 characters

;;; Package Management Setup
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)  ; Always install packages if missing

;;; Enhanced Completion with Ivy
(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t))

(use-package swiper
  :bind ("C-s" . swiper))  ; Better search with swiper

;;; Evil Mode (Vim Emulation)
(use-package evil
  :init
  (setq evil-want-integration t)    ; Required for evil-collection
  (setq evil-want-keybinding nil)   ; Let evil-collection manage keybindings
  :config
  (evil-mode 1))                    ; Enable evil globally

;;; Evil Collection (Vim-style keybindings for other modes)
(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(dired ibuffer)) ; Apply to these modes
  (evil-collection-init))

;;; Markdown Support
(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode)     ; Auto-enable for .md files
  :hook (markdown-mode . visual-line-mode) ; Wrap lines visually
  :config
  (setq markdown-command "pandoc"))       ; Use pandoc for rendering

;;; Web Development Support
(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)   ; HTML files
         ("\\.css\\'" . web-mode)     ; CSS files
         ("\\.js\\'" . web-mode)))    ; JavaScript files

;;; Emmet (HTML/CSS Expansion)
(use-package emmet-mode
  :hook ((web-mode css-mode) . emmet-mode) ; Enable in web/css modes
  :config
  (setq emmet-move-cursor-between-quotes t)) ; Better cursor placement

;;; Syntax Checking
(use-package flycheck
  :hook (after-init . global-flycheck-mode)) ; Enable globally after init

;;; Rainbow Delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)) ; Colorful parentheses

;;; Doom Themes
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t    ; Enable bold fonts
        doom-themes-enable-italic t) ; Enable italic fonts
  (load-theme 'doom-dark+ t)         ; Load dark theme
  (doom-themes-visual-bell-config)   ; Visual bell (instead of audible)
  (doom-themes-org-config))          ; Special setup for org-mode
