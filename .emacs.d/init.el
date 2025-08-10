;; Ultra Minimal Emacs Configuration

;; UI cleanup
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Basic settings
(setq inhibit-startup-screen t)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq ring-bell-function 'ignore)
(column-number-mode t)
(show-paren-mode 1)

;; Line numbers
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

;; UTF-8
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; Font - larger size
(when (display-graphic-p)
  (set-face-attribute 'default nil :family "Monospace" :height 140))

;; Force horizontal window splits - CORRECT WAY
(setq window-combination-resize t
      split-width-threshold 300)

;; Package setup for Doom themes
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Install doom-themes if not installed
(unless (package-installed-p 'doom-themes)
  (package-refresh-contents)
  (package-install 'doom-themes))

;; Load Doom Nord theme
(load-theme 'doom-nord t)
