;; Set custom variables to separate file
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;; Disable UI elements for minimal experience
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)

;; Better defaults
(setq ring-bell-function 'ignore)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq create-lockfiles nil)

;; Create backup directory if it doesn't exist
(unless (file-exists-p "~/.emacs.d/backups")
  (make-directory "~/.emacs.d/backups" t))

;; Show line numbers and column numbers
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(column-number-mode 1)

;; Show matching parentheses
(show-paren-mode 1)

;; Global settings for all programming modes
(setq-default indent-tabs-mode nil)  ; Default to spaces
(setq-default tab-width 4)
(setq-default fill-column 80)

;; Language-specific indentation settings
;; Languages that prefer TABS
(add-hook 'c-mode-hook (lambda () 
                         (setq indent-tabs-mode t)      ; Use real tabs
                         (setq c-basic-offset 4)))      ; 4 spaces wide

(add-hook 'c++-mode-hook (lambda () 
                           (setq indent-tabs-mode t)    ; Use real tabs
                           (setq c-basic-offset 4)))    ; 4 spaces wide

;; Go uses tabs by default (when you add go-mode later)
;; (add-hook 'go-mode-hook (lambda () (setq indent-tabs-mode t)))

;; Languages that prefer SPACES
(add-hook 'python-mode-hook (lambda () 
                              (setq indent-tabs-mode nil)   ; Use spaces
                              (setq python-indent-offset 4))) ; 4 spaces

(add-hook 'ruby-mode-hook (lambda () 
                            (setq indent-tabs-mode nil)     ; Use spaces
                            (setq ruby-indent-level 2)))    ; 2 spaces

(add-hook 'web-mode-hook (lambda () 
                           (setq indent-tabs-mode nil)      ; Use spaces
                           (setq web-mode-markup-indent-offset 2)
                           (setq web-mode-css-indent-offset 2)
                           (setq web-mode-code-indent-offset 2)))

(add-hook 'css-mode-hook (lambda () 
                           (setq indent-tabs-mode nil)      ; Use spaces
                           (setq css-indent-offset 2)))     ; 2 spaces

(add-hook 'js-mode-hook (lambda () 
                          (setq indent-tabs-mode nil)       ; Use spaces
                          (setq js-indent-level 2)))        ; 2 spaces

;; Package management setup
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Better completion with Ivy
(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t))

(use-package swiper
  :bind ("C-s" . swiper))

;; Auto-completion framework
(use-package company
  :hook (after-init . global-company-mode)
  :custom
  (company-idle-delay 0.3)
  (company-minimum-prefix-length 2))

;; Markdown support
(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode)
  :hook (markdown-mode . visual-line-mode)
  :config
  (setq markdown-command "pandoc"))

;; Python support
(use-package python-mode
  :mode ("\\.py\\'" . python-mode))

;; Ruby support  
(use-package ruby-mode
  :mode ("\\.rb\\'" . ruby-mode))

;; Web development (HTML/CSS/JavaScript)
(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.js\\'" . web-mode)))

;; Emmet for HTML/CSS expansion
(use-package emmet-mode
  :hook ((web-mode css-mode) . emmet-mode)
  :config
  (setq emmet-move-cursor-between-quotes t))

;; C/C++ support - moved to hooks above

;; Syntax checking
(use-package flycheck
  :hook (after-init . global-flycheck-mode))

;; Rainbow delimiters for better parentheses visibility
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Code folding
(use-package origami
  :hook (prog-mode . origami-mode)
  :bind (("C-c f f" . origami-toggle-node)
         ("C-c f F" . origami-toggle-all-nodes)
         ("C-c f o" . origami-open-node)
         ("C-c f c" . origami-close-node)))

;; Doom themes
(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)
  
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; Custom function for Chirpy Jekyll posts
(defun create-chirpy-post ()
  "Create a new Chirpy Jekyll post with proper frontmatter."
  (interactive)
  (let* ((title (read-string "Post title: "))
         (date-time (format-time-string "%Y-%m-%d %H:%M:%S %z"))
         (date (format-time-string "%Y-%m-%d"))
         (filename (format "%s-%s.md" 
                          date 
                          (replace-regexp-in-string "[^a-zA-Z0-9]+" "-" 
                                                   (downcase title))))
         ;; CHANGE THIS PATH to your actual blog posts directory
         (filepath (expand-file-name filename "~/path/to/your/blog/_posts"))
         (categories (read-string "Categories (space separated): "))
         (tags (read-string "Tags (space separated): "))
         (category-list (if (string-empty-p categories) 
                           "" 
                           (string-trim categories)))
         (tag-list (if (string-empty-p tags) 
                      "" 
                      (mapconcat (lambda (tag) (string-trim tag))
                                (split-string tags " ") ", "))))
    
    (find-file filepath)
    (insert (format "---
title: %s
date: %s
categories: [%s]
tags: [%s]
---

" title date-time category-list tag-list))
    (goto-char (point-max))
    (message "New Chirpy post created: %s" filename)))
