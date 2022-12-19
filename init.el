(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(setq initial-scratch-message "")
(setq visible-bell 1)
(global-display-line-numbers-mode)

;;themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'brudy t)


;;package management

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;;essential packages
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(use-package clojure-mode :ensure t)
(use-package cider :ensure t
	     :config
	     (add-hook 'clojure-mode-hook 'cider-mode))

(add-hook 'clojure-mode-hook 'enable-paredit-mode)

(setq clojure-indent-style :align-arguments)
(setq clojure-align-forms-automatically t)

(use-package company :ensure t
	     :hook (cider-repl-mode . company-mode)
	     :config
	     (add-hook 'cider-repl-mode-hook #'company-mode)
	     (add-hook 'cider-mode-hook #'company-mode))

(defun custom-clojure-mode-hook ()
  (local-set-key (kbd "C-c C-l") 'cider-load-buffer))

(add-hook 'clojure-mode-hook 'custom-clojure-mode-hook)

;;clojure autocompletition and IntelliSense

(use-package flycheck
	     :ensure t
	     :config
	     (add-hook 'cider-mode-hook #'flycheck-mode))


;;lein repl

(require 'cider)
(setq cider-default-cljs-repl 'lein)
(setq cider-lein-parameters "repl :headless")
(global-set-key (kbd "C-c C-j") #'cider-jack-in)

;;dir tree visualization

(use-package treemacs
	     :ensure t
	     :bind (("<f8>" . treemacs))
	     :config
	     (setq treemacs-follow-after-init          t
        treemacs-width                      35
        treemacs-indentation                2
        treemacs-git-integration            t
        treemacs-collapse-dirs              3
        treemacs-silent-refresh             nil
        treemacs-change-root-without-asking nil
        treemacs-sorting                    'alphabetic-desc
        treemacs-show-hidden-files          t
        treemacs-never-persist              nil
        treemacs-is-never-other-window      nil
	treemacs-goto-tag-strategy          'refetch-index))


;;processing configuration
(setq processing-location "~/processing-java.exe")
(use-package proced :ensure t)

(global-set-key (kbd "C-c C-c") #'proced-eval-region)

(use-package processing-mode :ensure t)
(global-set-key (kbd "C-c C-r") #'processing-sketch-run)

(use-package auto-complete :ensure t)

(require 'processing-mode)

(require 'auto-complete)
(global-set-key (kbd "C-c C-i") 'auto-complete)
(add-hook 'processing-mode-hook #'auto-complete-mode)


;;rust configuration

(use-package rust-mode :ensure t)
(use-package cargo :ensure t)

(global-set-key (kbd "C-c C-c") #'cargo-process-run)
(global-set-key (kbd "C-c C-t") #'cargo-process-test)


;(use-package rustfmt :ensure t)
(use-package racer :ensure t)

;(global-set-key (kbd "C-c C-f") #'rustfmt-format-buffer)
(global-set-key (kbd "TAB") #'racer-complete-or-indent)


;;custom bindings

(global-set-key (kbd "C-x j") 'cider-jack-in)

(defun create-new-clojure-project ()
  (interactive)
  (let ((project-name (read-string "Enter project name: ")))
    (shell-command (concat "lein new app " project-name))
    (treemacs-add-project-to-workspace project-name)))

(global-set-key (kbd "C-c C-n") 'create-new-clojure-project)
(global-set-key (kbd "C-c cd") 'cd)

(use-package csharp-mode)

(defun mkdir ()
  (interactive)
  (let ((name (read-string "Enter directory name: ")))
    (shell-command (concat "mkdir " name ))))

(global-set-key (kbd "C-c mkdir") 'mkdir)
