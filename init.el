;;; init.el --- Mads' configuration file
;;; Commentary:
;;; Code:

(server-start)

;; Configure package and use-package
;; ---------------------------------
(require 'package)

(setq package-enable-at-startup nil)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

;; Load my packages
(package-initialize)

;; Make sure `use-package' is installed.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-verbose t)
(setq use-package-always-ensure t)

;; Load my various elisp files.
;; ---------------------------------
(load "~/.emacs.d/functions.el")
(load "~/.emacs.d/project-frame.el")

;; window-system specific configuration
;; ---------------------------------
(if window-system
    (progn
      ;; Default width/height for initial window and subsequent windows
      ;; (set-face-attribute 'default nil :font "Hack-11:antialias=subpixel")
      (add-to-list 'initial-frame-alist '(width . 150))
      (add-to-list 'initial-frame-alist '(height . 50))
      (add-to-list 'default-frame-alist '(width . 150))
      (add-to-list 'default-frame-alist '(height . 50))
      (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
      (load-theme 'base16-ocean-dark-hartmann t)
      ;; (load-theme 'basic-light t)
      (set-face-attribute 'default nil :font "Operator Mono-13:antialias=subpixel:weight=thin"))
  (progn
    (tool-bar-mode -1)
    (menu-bar-mode -1)
    (define-key key-translation-map [?\C-h] [?\C-?])
    (global-set-key (kbd "C-M-d") 'backward-kill-word)))

;; Global configuration
;; ---------------------------------

;; Put the auto-generated custom changes in another file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; Always ask for y/n keypress instead of typing out 'yes' or 'no'
(defalias 'yes-or-no-p 'y-or-n-p)

(global-hi-lock-mode nil)
(setq-default fill-column 80)
(setq mouse-wheel-scroll-amount '(0.01))
(setq column-number-mode t)
(setq confirm-kill-emacs (quote y-or-n-p))
(setq x-select-enable-clipboard t)
(setq require-final-newline t)
(set-default 'truncate-lines t)
(setq auto-save-default nil) ; disable auto-save files (#foo#)
(setq backup-inhibited t)    ; disable backup files (foo~)
(setq debug-on-error nil)
(setq line-move-visual t)    ; Pressing down arrow key moves the cursor by a screen line
(setq-default indent-tabs-mode nil)
(setq ns-use-native-fullscreen nil)
(setq mac-allow-anti-aliasing t)
(setq ring-bell-function 'ignore)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(setq ns-pop-up-frames nil)
(setq frame-title-format '((:eval buffer-file-name)))
(setq enable-local-variables :all) ; Sort of scary.
(setq tramp-default-method "ssh")
(setq mouse-1-click-follows-link nil)
(setq mouse-1-click-in-non-selected-windows nil)

;; Set the threshold of when to split a window into more windows.
;; Some interesting readering:
;;     split-window-sensibly
;;     window-splittable-p
;; These values makes sense for me on a 13" rMBP with a high DPI
;; (setq split-width-threshold 160)
;; (setq split-height-threshold 30)
;; These values makes sense on an Apple 30" display
(setq split-width-threshold 160)
(setq split-height-threshold 70)

(pending-delete-mode t)
(normal-erase-is-backspace-mode 1)
(delete-selection-mode t)
(scroll-bar-mode -1)
(show-paren-mode t)
(tool-bar-mode -1)
(global-auto-revert-mode 1)  ; pick up changes to files on disk automatically
(electric-pair-mode -1)
(global-hl-line-mode -1)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Customize the fringe.
(customize-set-variable 'indicate-empty-lines t) ; get those cute dashes in the fringe.
(customize-set-variable 'fringe-mode '(4 . 2)) ; left/right width of fringe


(global-set-key [(super shift return)] 'toggle-maximize-buffer)
(global-set-key (kbd "C-o") 'open-line)
(global-set-key (kbd "M-.") 'mhj/find-tag)
(global-set-key (kbd "s-.") 'mhj/tags-apropos)
(global-set-key (kbd "M-;") 'comment-dwim)
(global-set-key (kbd "C-;") 'comment-line-dwim)
(global-set-key (kbd "s-w") 'delete-frame)
(global-set-key (kbd "s-<return>") 'toggle-fullscreen)
(global-set-key (kbd "C-x C-SPC") 'pop-to-mark-command)
(global-set-key (kbd "s-+") 'text-scale-increase)
(global-set-key (kbd "s--") 'text-scale-decrease)
(global-set-key (kbd "s-{") 'prev-window)
(global-set-key (kbd "s-}") 'other-window)
(global-set-key (kbd "M-a") 'insert-aa) ; For when I want to
(global-set-key (kbd "M-o") 'insert-oe) ; write danish with my
(global-set-key (kbd "M-'") 'insert-ae) ; uk layout keyboard.
(global-set-key (kbd "s-`") 'ns-next-frame)
(global-set-key (kbd "s-¬") 'ns-prev-frame)
(global-set-key (kbd "C-c C-1") 'previous-buffer)
(global-set-key (kbd "C-c C-2") 'next-buffer)

(global-set-key (kbd "<f11>") 'mhj/show-info-sidebar)
(global-set-key (kbd "<f12>") 'mhj/toggle-project-explorer)
(global-set-key (kbd "s-0") 'mhj/focus-project-explorer)

(define-key isearch-mode-map (kbd "<backspace>") 'isearch-delete-char)

(use-package flycheck
  ;; On the fly linting.
  ;; TODO: Configure where it stores its temporary files.
  :diminish ""
  :bind
  (:map flycheck-mode-map
        ("C-c ! ?" . flycheck-display-error-at-point))
  :commands flycheck-mode
  :init
  (progn
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (setq flycheck-highlighting-mode 'symbols)
    (setq flycheck-indication-mode 'left-fringe)

    (add-to-list 'display-buffer-alist
                 `(,(rx bos "*Flycheck errors*" eos)
                   (display-buffer-reuse-window
                    display-buffer-in-side-window)
                   (reusable-frames . visible)
                   (side            . bottom)
                   (window-height   . 0.3)))))

(use-package compilation
  ;; Configuration of the built-in compilation-mode
  :ensure nil
  :config
  (progn
    (setq compilation-scroll-output t)
    (setq compilation-read-command nil)
    (setq compilation-ask-about-save nil) ; Automatically save buffers before compiling
    (add-to-list 'display-buffer-alist
                 `(,(rx bos "*compilation*" eos)
                   (display-buffer-reuse-window
                    display-buffer-in-side-window)
                   (reusable-frames . visible)
                   (side            . bottom)
                   (window-height   . 0.3)))))

(use-package dabbrev
  ;; configuration of the built-in dynamic abbreviation package.
  :bind ("M-/" . dabbrev-expand)
  :config
  (progn
    (setq dabbrev-case-replace nil)
    (setq dabbrev-case-distinction nil)
    (setq dabbrev-case-fold-search nil)))

(use-package linum
  ;; Configuration of the built-in linum-mode.
  :config
  (progn
    (global-linum-mode -1)
    (setq linum-format " %d ")))

(use-package make-mode
  ;; Configuration of the built-in makefile-mode
  :config
  (progn

    (add-to-list 'auto-mode-alist '("\\Makefile\\'" . makefile-mode))
    (add-to-list 'auto-mode-alist '("\\.mk\\'" . makefile-mode))

    (font-lock-add-keywords
     'makefile-mode
     '(("define" . font-lock-keyword-face)
       ("endef" . font-lock-keyword-face)
       ("ifeq" . font-lock-keyword-face)
       ("ifdef" . font-lock-keyword-face)
       ("ifndef" . font-lock-keyword-face)
       ("else" . font-lock-keyword-face)
       ("endif" . font-lock-keyword-face)))

    (defun makefile-mode-setup ()
      (setq whitespace-style '(face tab-mark trailing)))

    (add-hook 'makefile-mode-hook 'linum-mode)
    (add-hook 'makefile-mode-hook 'makefile-mode-setup)))

(use-package macrostep
  ;; Awesome little package for expanding macros. Helps to understand
  ;; what is going on im my use-package declarations.
  :bind ("C-c e m" . macrostep-expand))

(use-package report-spec-mode
  ;; My own small package for report specifications for one of our
  ;; internal analytics systems at issuu
  :ensure nil
  :load-path "dev-pkgs/"
  :defer)

(use-package hdl-mode
  ;; My own small package for hdl files.
  :ensure nil
  :load-path "dev-pkgs/"
  :mode "\\.hdl\\'"
  :defer)

(use-package ibuffer
  ;; A different buffer view.
  :bind ("C-x C-b" . ibuffer))

(use-package ace-jump-mode
  ;; Quick way to jump to a given char.
  :bind ("C-<tab>" . ace-jump-mode))

(use-package dired
  :ensure nil
  :bind
  (:map dired-mode-map
        ("<s-down>" . dired-find-file)
        ("<s-up>" . diredp-up-directory))
  :config
  (progn

    (defun dired-mode-hook-set-faces ()
      ;; (setq mode-line-format (projectile-project-name))
      ;; (buffer-face-set '(:background "#343d46")) ;; dark theme
      ;; (buffer-face-set '(:background "#DEDEDE")) ;; basic light
      (message "color is %s" (car (custom-variable-theme-value 'dired-sidebar-background))))

    (setq insert-directory-program "/usr/local/opt/coreutils/libexec/gnubin/ls")
    (setq dired-listing-switches "-lXGh --group-directories-first")
    (add-hook 'dired-mode-hook 'dired-mode-hook-set-faces)
    (add-hook 'dired-mode-hook 'dired-omit-mode)
    (add-hook 'dired-mode-hook 'dired-hide-details-mode)))

(use-package dired-narrow
  ;; Make it possible to filter/search in a dired buffer. After a
  ;; filter has been applied it can be removed by refreshing the
  ;; buffer with 'g'.
  :bind
  (:map dired-mode-map
        ("/" . dired-narrow)))

(use-package dired-subtree
  ;; Very helpful package that makes it possible to insert a dired
  ;; subtree buffer directly below a folder in a dired buffer. Give
  ;; you something similar to a tree explorer.
  :demand
  :bind
  (:map dired-mode-map
        ("<enter>" . mhj/dwim-toggle-or-open)
        ("<return>" . mhj/dwim-toggle-or-open)
        ("<tab>" . mhj/dwim-toggle-or-open)
        ("<down-mouse-1>" . mhj/mouse-dwim-to-toggle-or-open))
  :config
  (progn
    (setq dired-subtree-line-prefix (lambda (depth) (make-string (* 2 depth) ?\s)))
    (setq dired-subtree-use-backgrounds nil)))

(use-package exec-path-from-shell
  ;; Make sure that emacs inherit environment variables from ~/.zshenv
  ;; and files like that.
  :init
  (progn
    (exec-path-from-shell-initialize)))

(use-package sh-script
  :config
  (progn
    (add-hook 'sh-mode-hook 'linum-mode)))

(use-package shell
  :commands shell
  :bind
  (:map shell-mode-map
        ("s-k" . clear-shell)
        ("<up>" . comint-previous-input)
        ("<down>" . comint-next-input)))

(use-package flyspell
  ;; Spell-checking of emacs buffers.
  :diminish (flyspell-mode)
  :commands flyspell-mode
  :bind
  (:map flyspell-mode-map
        ("C-;" . nil)
        ("C-," . nil)
        ("C-." . nil)))

(use-package ido
  ;; interactively-do-things. Improved find-file and M-x.
  :init
  (progn
    (ido-mode 1)
    (setq ido-enable-flex-matching t)
    (setq ido-use-filename-at-point nil)
    (setq ido-create-new-buffer 'always)
    (setq ido-max-prospects 7)
    (setq ido-auto-merge-work-directories-length -1))) ; disable annoying directory search

(use-package ido-vertical-mode
  ;; Display suggestions in the ido minibuffer vertically.
  :demand
  :init
  (progn
    (ido-vertical-mode 1)
    (defun bind-ido-keys ()
      (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
      (define-key ido-completion-map (kbd "C-p")   'ido-prev-match))
    (add-hook 'ido-setup-hook 'bind-ido-keys)))

(use-package magit
  :demand
  :commands magit-status
  :config
  (progn
    (setq magit-last-seen-setup-instructions "1.4.0")
    (setq magit-push-always-verify `PP)))

(use-package projectile
  :diminish ""
  :bind
  (:map projectile-mode-map
        ("C-c p f" . nil))
  :init
  (progn
    (projectile-global-mode)
    (setq projectile-completion-system 'helm)
    (setq projectile-use-git-grep t)))

(use-package helm
  :bind (("C-." . helm-M-x)
         ("C-x b" . helm-buffers-list)
         ("M-y" . helm-show-kill-ring)
         ("M-s" . helm-occur))
  :init
  (progn
    (setq helm-follow-mode t)
    (setq helm-split-window-in-side-p t)
    (setq helm-buffers-fuzzy-matching t)
    (setq helm-M-x-always-save-history nil)

    (setq helm-find-files-actions '
          (("Find File" . helm-find-file-or-marked)
           ("View file" . view-file)
           ("Zgrep File(s)" . helm-ff-zgrep)))

    (setq helm-type-file-actions
          '(("Find File" . helm-find-file-or-marked)
            ("View file" . view-file)
            ("Zgrep File(s)" . helm-ff-zgrep)))

    (add-to-list 'display-buffer-alist
                 `(,(rx bos "*helm" (+ anything) "*" eos)
                   (display-buffer-in-side-window)
                   (side            . bottom)
                   (window-height   . 0.3)))))

(use-package helm-c-yasnippet
  :demand
  :bind ("C-c y" . helm-yas-complete))

(use-package helm-projectile
  :bind (("C-c p p" . helm-projectile-switch-project)
         ("C-c p f" . helm-projectile-find-file)
         ("C-," . helm-projectile))
  :config
  (progn
    ;; Removes 'helm-source-projectile-projects' from C-c p h as it is
    ;; possible to switch project using 'helm-projectile-switch-project'

    ;; other options:
    ;;    helm-source-projectile-files-list
    ;;    helm-source-projectile-recentf-list
    (setq helm-projectile-sources-list
          '(helm-source-projectile-buffers-list
            helm-source-ls-git-status)))) ;; requires helm-ls-git

(use-package helm-git-grep
  ;; Interactive git-grep using helm
  :bind (("s-F" . helm-git-grep)))

(use-package helm-ls-git
  ;; Pretty nice project overview
  :config
  (progn
    (setq helm-ls-git-default-sources
          '(helm-source-ls-git-buffers
            helm-source-ls-git-status
            helm-source-ls-git))
    (setq helm-ls-git-show-abs-or-relative 'relative)))

;; Interactive ag queries using helm.
(use-package helm-ag)

(use-package expand-region
  ;; One of my favorite packages. Can increase/shrink a selection in
  ;; clever ways.
  :bind ("C-w" . er/expand-region))

(use-package auto-complete
  ;; Code-completion backend.
  ;; TODO: Would prefer to use company mode everywhere.
  :diminish (auto-complete-mode)
  :init (global-auto-complete-mode t)
  :bind
  (:map ac-complete-mode-map
        ("\C-n" . ac-next)
        ("\C-p" . ac-previous))
  :config (progn
            (ac-config-default)
            (setq ac-auto-start nil)
            (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")))

(use-package hydra)

(use-package multiple-cursors
  :bind (("C-M->" . mc/unmark-next-like-this)
         ("C-M-<" . mc/unmark-previous-like-this)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this))
  :init
  (progn
    (defhydra hydra-multiple-cursors (:color blue)
      "Multiple cursors"
      ("i" mc/insert-numbers "Insert numbers")
      ("h" mc-hide-unmatched-lines-mode "Hide Unmatched Lines")
      ("a" mc/mark-all-like-this "Mark All Like This")
      ("r" mc/reverse-regions "Reverse Regions")
      ("s" mc/sort-regions "Sort Regions")
      ("l" mc/edit-lines "Edit Lines"))))

(use-package bookmark+
  :bind (("s-<f2>" . bmkp-toggle-autonamed-bookmark-set/delete)
         ("<f2>" . bmkp-next-bookmark-this-buffer)
         ("S-<f2>" . bmkp-previous-bookmark-this-buffer))
  :config
  (progn
    (setq bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
    (setq bmkp-light-left-fringe-bitmap 'empty-line)
    (setq bmkp-auto-light-when-set 'autonamed-bookmark)))

(use-package ag
  :commands ag
  :config
  (progn
    (setq ag-highlight-search t)
    (setq ag-reuse-buffers 't)))

(use-package undo-tree
  :diminish (undo-tree-mode)
  :bind (("C-x u" . undo-tree-visualize))
  :init
  (progn
    (setq undo-tree-visualizer-relative-timestamps t)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)

    (add-to-list
     'display-buffer-alist
     `(,(rx bos " *undo-tree*" eos)
       (display-buffer-in-side-window)
       (side . right)
       (window-width . 0.4)))))

(use-package yasnippet
  :diminish (yas-minor-mode)
  :defer
  :init
  (progn
    (yas-global-mode)
    (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
    (yas-reload-all)))

(use-package diff-hl
  :init (global-diff-hl-mode))

(use-package org
  :bind
  (:map org-mode-map
        ("C-," . nil))
  :init
  (progn
    (require 'ox-publish)
    (require 'ob-ocaml)
    (require 'ob-sh)
    (require 'ob-sql)
    (require 'ob-python)
    (require 'ob-js)
    (require 'ob-R)

    (define-key global-map (kbd "C-c c") 'org-capture)

    (define-key org-mode-map (kbd "C-c C-a") 'org-agenda)
    (define-key org-mode-map (kbd "C-<tab>") nil)

    (setq org-html-htmlize-output-type 'css)
    (setq org-src-fontify-natively t)   ;trying it out
    (setq org-startup-folded nil)
    (setq org-confirm-babel-evaluate nil) ;; Living on the edge
    (setq org-startup-indented nil)
    (setq org-export-babel-evaluate nil) ;; Don't evaluate on export by default.

    ;; Blogging
    (setq org-publish-project-alist
          '(
            ;;
            ;; Blog
            ;;
            ("org-mads379.github.com"
             ;; Path to your org files.
             :base-directory "~/dev/mads379.github.com/_org/"
             :base-extension "org"
             ;; Path to your Jekyll project.
             :publishing-directory "~/dev/mads379.github.com/"
             :recursive t
             :publishing-function org-html-publish-to-html
             :headline-levels 4
             :html-extension "html"
             :body-only t) ;; Only export section between <body> </body>
            ("org-static-mads379.github.com"
             :base-directory "~/dev/mads379.github.com/org/"
             :base-extension "css\\|js\\|png\\|jpg\\|gif"
             :publishing-directory "~/dev/mads379.github.com/"
             :recursive t
             :publishing-function org-publish-attachment)
            ("mads379.github.com"
             :components ("org-ianbarton" "org-static-ian"))
            ;;
            ;; Notes
            ;;
            ("notes-org"
             :base-directory "/Users/hartmann/Dropbox/org/"
             :base-extension "org"
             :publishing-directory "/Users/hartmann/Sites/notes"
             :recursive t
             :publishing-function org-html-publish-to-html
             :headline-levels 4
             :auto-preamble t
             :html-extension "html"
             :body-only nil)
            ("notes-static"
             :base-directory "/Users/hartmann/Dropbox/org/"
             :base-extension "css\\|js\\|png\\|jpg\\|gif\\|eot\\|svg\\|ttf\\|woff\\|woff2"
             :publishing-directory "/Users/hartmann/Sites/notes"
             :recursive t
             :publishing-function org-publish-attachment)
            ("notes" :components ("notes-org" "notes-static")) ))


    (setq org-babel-load-languages
          '((ocaml . t)
            (emacs-lisp . t)
            (sh . t)
            (sql . t)
            (python . t)
            (js . t)
            (r . R)))

    (setq org-agenda-files
          '("~/Dropbox/org"
            "~/Dropbox/org/issuu"
            "~/Dropbox/org/projects"
            "~/Dropbox/org/notes"))

    (add-hook 'org-mode-hook 'linum-mode)

    ;; http://www.wisdomandwonder.com/link/9573/how-to-correctly-enable-flycheck-in-babel-source-blocks
    (defadvice org-edit-src-code (around set-buffer-file-name activate compile)
      (let ((file-name (buffer-file-name)))
        ad-do-it
        (setq buffer-file-name file-name)))))

(use-package scss-mode
  :commands scss-mode
  :config (setq scss-compile-at-save nil))

(use-package company-web)
(use-package web-mode
  :commands web-mode
  :mode
  (("\\.js[x]?\\'" . web-mode)
   ("\\.html$" . web-mode))
  :bind
  (:map web-mode-map
        ("M-<tab>" . mhj/web-mode-company-complete)
        ("C-c C-c" . flycheck-list-errors))
  :config
  (progn
    ;; I used this for some of it:
    ;; https://truongtx.me/2014/03/10/emacs-setup-jsx-mode-and-jsx-syntax-checking/

    ;; Force web-mode to consider all js files as potential react
    ;; files. See more here:
    ;; http://cha1tanya.com/2015/06/20/configuring-web-mode-with-jsx.html
    (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
    (setq web-mode-enable-auto-quoting nil)

    ;; Disable jshint making eslint the selected linter
    (setq-default flycheck-disabled-checkers '(javascript-jshint))

    ;; TBH not entirely sure how this magic works. If I don't have it
    ;; syntax highlighting for jsx parts of javascript files won't
    ;; work.
    (defadvice web-mode-highlight-part (around tweak-jsx activate)
      (if (equal web-mode-content-type "jsx")
          (let ((web-mode-enable-part-face nil))
            ad-do-it)
        ad-do-it))

    (add-hook 'web-mode-hook 'flycheck-mode)
    (add-hook 'web-mode-hook 'company-mode)
    (add-hook 'web-mode-hook 'tern-mode)
    (add-hook 'web-mode-hook 'linum-mode)

    ;; Requires `npm install -g eslint`
    (flycheck-add-mode 'javascript-eslint 'web-mode)))

;; company backend for tern
(use-package company-tern)


(use-package tern
  ;; Code-completion etc. for javascript.
  ;; currently requires npm install -g tern
  :bind
  (:map tern-mode-keymap
        ;; ("M-." . mhj/find-tag)
        ("M-." . tern-find-definition)
        ("M-*" . tern-pop-find-definition)
        ("M-?" . tern-get-docs)))

(use-package markdown-mode
  :commands markdown-mode
  :bind
  (:map markdown-mode-map
        ("M-<tab>" . ido-complete-word-ispell)
        ("M-?" . ispell-word)
        ("C-c C-c" . flycheck-list-errors))
  :config
  (progn
    (add-hook 'markdown-mode-hook 'linum-mode)
    (add-hook 'markdown-mode-hook 'flycheck-mode)
    (add-hook 'markdown-mode-hook 'flyspell-mode)))

(use-package eldoc
  :diminish (eldoc-mode))

(use-package elisp-slime-nav
  :diminish (elisp-slime-nav-mode))

(use-package slime)
(use-package slime-company)

(use-package lisp-mode
  ;; Configuration of the built-in lisp-mode.
  :ensure nil
  :commands lisp-mode
  :bind
  (:map emacs-lisp-mode-map
        ("M-." . elisp-slime-nav-find-elisp-thing-at-point)
        ("M-<tab>" . company-complete)
        ("M-?" . describe-function)
        ("C-c C-c" . flycheck-list-errors))
  :config
  (progn
    ;; elint current buffer seems like a fun one.
    (add-hook 'emacs-lisp-mode-hook 'flycheck-mode)
    (add-hook 'emacs-lisp-mode-hook 'turn-on-elisp-slime-nav-mode)
    ;; (add-hook 'emacs-lisp-mode-hook 'flyspell-prog-mode)
    (add-hook 'emacs-lisp-mode-hook 'linum-mode)
    (add-hook 'emacs-lisp-mode-hook 'company-mode)
    (add-hook 'emacs-lisp-mode-hook 'eldoc-mode)))

(use-package octave
  :commands octave-mode
  :mode (("\\.m$" . octave-mode))
  :config
  (progn
    (autoload 'octave-mode "octave-mod" nil t)
    (add-hook 'octave-mode-hook
              (lambda ()
                (abbrev-mode 1)
                (auto-fill-mode 1)
                (if (eq window-system 'x)
                    (font-lock-mode 1))))))

(use-package erlang
  :commands erlang-mode
  :bind
  (:map erlang-mode-map
        ("M-." . erl-find-source-under-point)
        ("M-," . erl-find-source-unwind)
        ("M-<tab>" . erl-complete)
        ("C-c C-c" . compile)
        ("<return>" . newline-and-indent))
  :config
  (progn
    (add-to-list 'load-path "/Users/hartmann/dev/distel/elisp") ; Not in melpa yet
    (require 'distel)
    (distel-setup)
    ;; http://parijatmishra.wordpress.com/2008/08/15/up-and-running-with-emacs-erlang-and-distel/
    ;; http://alexott.net/en/writings/emacs-devenv/EmacsErlang.html#sec8
    (setq inferior-erlang-machine-options '("-sname" "emacs"))
    (add-hook 'erlang-mode-hook 'flycheck-mode)))

(use-package tuareg
  :commands tuareg-mode
  :config
  (progn
    ;; TODO: Consider using flycheck: http://www.flycheck.org/manual/latest/Supported-languages.html#Supported-languages
    ;; TODO: Can I use company-mode for this?

    ;; Add opam emacs directory to the load-path
    (setq opam-share (substring (shell-command-to-string "opam config var share 2> /dev/null") 0 -1))
    (add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))

    ;; Setup environment variables using OPAM
    (dolist (var (car (read-from-string (shell-command-to-string "opam config env --sexp"))))
      (setenv (car var) (cadr var)))

    ;; One of the `opam config env` variables is PATH. Update `exec-path` to that.
    (setq exec-path (split-string (getenv "PATH") path-separator))

    ;; Load merlin-mode
    (require 'merlin)
    (require 'ocp-indent)

    ;; Use opam switch to lookup ocamlmerlin binary
    (setq merlin-command 'opam)
    (setq merlin-use-auto-complete-mode 'easy)

    ;; Automatically load utop.el.
    (add-to-list 'load-path "/Users/hartmann/dev/utop/src/top")
    (autoload 'utop-minor-mode "utop" "Minor mode for utop" t)

    ;; Used if I want to run some of ISSUU's OCaml projects in UTOP .
    (setenv "AGGREGATOR_CONF_SHADOW" "")
    (setenv "AGGREGATOR_HOME" "/Users/hartmann/dev/backend-insight/aggregator")
    (setenv "PROMOTED_HOME" "/Users/hartmann/dev/backend-promoted")
    (setenv "PROMOTED_CONF_SHADOW" "")

    (define-key merlin-mode-map (kbd "M-<tab>") 'merlin-try-completion)
    (define-key merlin-mode-map "\M-." 'merlin-locate)
    (define-key merlin-mode-map (kbd "C-c C-p") 'prev-match)
    (define-key merlin-mode-map (kbd "C-c C-n") 'next-match)
    (define-key tuareg-mode-map (kbd "C-x C-r") 'tuareg-eval-region)

    ;; (setq merlin-logfile "/Users/hartmann/Desktop/merlin.log")
    (setq merlin-error-after-save t)

    (add-hook 'tuareg-mode-hook
              (lambda ()
                (merlin-mode)
                (utop-minor-mode)
                (define-key utop-minor-mode-map (kbd "C-c C-z") 'utop)
                (setq indent-line-function 'ocp-indent-line)))))

(use-package elpy
  :commands elpy-enable
  :bind
  (:map python-mode-map
        ("M-." . elpy-goto-definition)
        ("M-*" . pop-tag-mark)
        ("M-?" . elpy-doc)
        ("C-c r" . hydra-elpy-refactor/body)
        ("C-c C-z" . elpy-shell-switch-to-shell)
   :map elpy-mode-map
        ("C-c C-c" . nil))
  :config
  (progn

    (defun disable-flymake ()
      (flymake-mode-off))

    (defhydra hydra-elpy-refactor (:color blue)
      "elpy refactor"
      ("r" elpy-refactor "Refactor")
      ("e" elpy-multiedit-python-symbol-at-point "Edit symbol")
      ("f" elpy-format-code "Format Code")
      ("o" elpy-importmagic-fixup "Organize imports")
      ("i" elpy-importmagic-add-import "Add missing import"))

    (setq elpy-rpc-backend "jedi")
    (setq elpy-modules
          '(elpy-module-sane-defaults
            elpy-module-company
            elpy-module-eldoc
            elpy-module-pyvenv))))

(use-package python
  :commands python-mode
  :bind
  (:map python-mode-map
        ("M-s" . nil)
        ("C-c C-p" . nil)
        ("C-c C-c" . flycheck-list-errors)
        ("M-<tab>" . company-complete))
  :config
  (progn

    (defun flycheck-python-set-pylint-executable ()
      "Use the pylint executable from your local venv."
      (let ((exec-path (python-shell-calculate-exec-path)))
        (setq flycheck-python-pylint-executable (executable-find "pylint"))))

    (defun flycheck-python-setup ()
      "Configure flycheck to use pylint and respect the projects configuration.
Wait till after the .dir-locals.el has been loaded."
      (add-hook 'hack-local-variables-hook 'flycheck-python-set-pylint-executable nil 'local)
      (setq flycheck-checker 'python-pylint)
      (setq flycheck-pylintrc (concat (upward-find-file "pylint.cfg") "/pylint.cfg")))

    (defun company-python-setup ()
      "Set the relevant backends for company-mode when editing python files."
      (set (make-local-variable 'company-backends)
           '(elpy-company-backend company-yasnippet company-etags)))

    (add-hook 'python-mode-hook 'flycheck-python-setup)
    (add-hook 'python-mode-hook 'flycheck-mode)
    (add-hook 'python-mode-hook 'flycheck-mode)
    (add-hook 'python-mode-hook 'company-mode)
    (add-hook 'python-mode-hook 'linum-mode)
    (add-hook 'python-mode-hook 'company-python-setup)
    (add-hook 'python-mode-hook 'elpy-mode)))

(use-package highlight-symbol
  :bind (("C-x w ." . highlight-symbol-at-point)
         ("C-x w %" . highlight-symbol-query-replace)
         ("C-x w o" . highlight-symbol-occur)
         ("C-x w c" . highlight-symbol-remove-all))
  :init
  (progn
    (defhydra hydra-navigate-symbol (global-map"C-x w")
      "navigate-symbol"
      ("n" highlight-symbol-next)
      ("p" highlight-symbol-prev))))

(use-package company
  :commands company-mode
  :diminish ""
  :bind
  (:map company-active-map
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous))
  :config
  (progn
    (setq company-show-numbers t)))

(use-package elixir-mode
  :commands elixir-mode
  :config
  (progn
    (add-hook 'elixir-mode-hook 'alchemist-mode)))

(use-package alchemist
  :commands alchemist-mode
  :bind
  (:map alchemist-mode-map
        ("M-<tab>" . company-complete)
        ("M-?" . alchemist-help-search-at-point)
        ("C-c C-t" . alchemist-mix-test-file)
        ("C-c C-c" . alchemist-mix-compile)
        ("C-c C-r" . alchemist-mix-run)
        ("C-c C-z" . alchemist-iex-project-run))
  :config
  (progn
    (add-hook 'alchemist-mode-hook 'company-mode)
    (add-hook 'alchemist-iex-mode-hook 'company-mode)))

(use-package scala-mode
  :commands scala-mode
  :config
  (progn
    (add-hook 'scala-mode-hook 'ensime-mode)
    (add-hook 'scala-mode-hook 'linum-mode)))

(use-package ensime
  :commands ensime ensime-mode
  :bind
  (:map ensime-mode-map
        ("<tab>" .  nil)
        ("M-<tab>" . company-complete)
        ("M-?" . ensime-show-doc-for-symbol-at-point)
        ("C-c C-t" . ensime-print-type-at-point))
  :config
  (progn
    (setq ensime-sem-high-enabled-p nil)
    (setq ensime-completion-style 'company)))

(use-package sql
  :config
  (progn
    (defun extend-with-mysql-syntax-and-keywords ()
      ;; Make # start a new line comment in SQL.
      (modify-syntax-entry ?# "< b" sql-mode-syntax-table)
      ;; Add a couple of MySQL keywords
      (font-lock-add-keywords
       'sql-mode
       '(("REPLACE" . 'font-lock-keyword-face)
         ("ALGORITHM" . 'font-lock-keyword-face)
         ("MERGE" . 'font-lock-keyword-face))))

    (add-hook 'sql-mode-hook 'linum-mode)
    (add-hook 'sql-mode-hook 'extend-with-mysql-syntax-and-keywords)))

(use-package elm-mode
  :commands elm-mode)

(use-package yaml-mode
  :config
  (progn
    (add-hook 'yaml-mode-hook 'linum-mode)))

(use-package feature-mode
  :bind
  (:map feature-mode-map
        ("M-." . mhj/find-tag)
        ("M-*" . pop-tag-mark))
  :config
  (progn
    (setq feature-indent-level 2)))

(use-package dockerfile-mode
  :config
  (progn
    (add-hook 'dockerfile-mode-hook 'linum-mode)))

(use-package jinja2-mode
  :commands jinja2-mode)

;; Makes it possbile to edit grep buffers!
(use-package wgrep)

;; wgrep support for helm.
(use-package wgrep-helm)

(use-package tex-mode
  :commands tex-mode
  :config
  (progn
    ;; This currently doesn't override the annoying tex-compile
    (define-key tex-mode-map (kbd "C-c C-c") 'compile)
    (define-key latex-mode-map (kbd "C-c C-c") 'compile)))

(use-package glsl-mode)

(use-package shift-text
  :ensure t
  :bind (("M-<up>" . shift-text-up)
         ("M-<down>" . shift-text-down)
         ("M-<left>" . shift-text-left)
         ("M-<right>" . shift-text-right))
  :config
  (progn
    (add-hook 'python-mode-hook (lambda () (setq-local st-indent-step python-indent-offset)))
    (add-hook 'web-mode-hook (lambda () (setq-local st-indent-step web-mode-code-indent-offset)))
    (add-hook 'yaml-mode-hook (lambda () (setq-local st-indent-step 2)))))

(use-package whitespace
  :diminish (global-whitespace-mode
             whitespace-mode
             whitespace-newline-mode)
  :config
  (progn
    (setq whitespace-style '(trailing tabs tab-mark face))
    (global-whitespace-mode)))

(use-package tabbar
  :disabled
  :bind
  (("s-{" . tabbar-backward-tab)
   ("s-}" . tabbar-forward-tab))
  :config
  (progn
    (defun projectile-buffer-groups-function ()
      (list
       (cond
        ((string-equal "*" (substring (buffer-name) 0 1)) "Emacs")
         (t (if (projectile-project-p) (projectile-project-name) "Common")))))

    (custom-set-variables
     '(tabbar-home-button (quote (("[o]") "[x]")))
     '(tabbar-mode t nil (tabbar))
     '(tabbar-mwheel-mode nil nil (tabbar))
     '(tabbar-scroll-left-button (quote ((" <") " <")))
     '(tabbar-scroll-right-button (quote ((" >") " >")))
     '(tabbar-separator (quote (0.5)))
     '(tabbar-use-images nil))

    (setq tabbar-buffer-groups-function 'projectile-buffer-groups-function)))

(use-package elscreen
  ;; TODO: I still want to be able to have a split-screen.
  ;; TODO: Make it work with side windows.
  ;; TODO: Hook it up with find-file functions etc.?
  ;; TODO: Bind s-W to close the tab (or window if it's the last tab?)
  :commands elscreen-start
  :disabled
  :bind
  (("s-T" . elscreen-create)
   ("s-{" . elscreen-previous)
   ("s-}" . elscreen-next)
   ("s-1" . mhj/elscreen-goto-0)
   ("s-2" . mhj/elscreen-goto-1)
   ("s-3" . mhj/elscreen-goto-2)
   ("s-4" . mhj/elscreen-goto-3)
   ("s-5" . mhj/elscreen-goto-4)
   ("s-6" . mhj/elscreen-goto-5)
   ("s-7" . mhj/elscreen-goto-6)
   ("s-8" . mhj/elscreen-goto-7)
   ("s-9" . mhj/elscreen-goto-8))
  :config
  (progn
    ;; No support for lambda's in :bind right now.
    (defun mhj/elscreen-goto-0 () (interactive)(elscreen-goto 0))
    (defun mhj/elscreen-goto-1 () (interactive)(elscreen-goto 1))
    (defun mhj/elscreen-goto-2 () (interactive)(elscreen-goto 2))
    (defun mhj/elscreen-goto-3 () (interactive)(elscreen-goto 3))
    (defun mhj/elscreen-goto-4 () (interactive)(elscreen-goto 4))
    (defun mhj/elscreen-goto-5 () (interactive)(elscreen-goto 5))
    (defun mhj/elscreen-goto-6 () (interactive)(elscreen-goto 6))
    (defun mhj/elscreen-goto-7 () (interactive)(elscreen-goto 7))
    (defun mhj/elscreen-goto-8 () (interactive)(elscreen-goto 8))

    (setq elscreen-tab-display-kill-screen nil)
    (setq elscreen-tab-display-control nil)
    (setq elscreen-display-screen-number nil)))

(use-package groovy-mode)

(use-package groovy-mode
  :config
  (progn
    (add-hook 'groovy-mode 'linum-mode)))

(use-package window-number
  :init
  (progn
    (window-number-meta-mode)))

(use-package osx-dictionary
  ;; Look up a string in the dictionary used by Dictionary.app
  :bind ("M-?" . osx-dictionary-search-pointer))

(use-package tabs
  ;; My own small package for report specifications for one of our
  ;; internal analytics systems at issuu
  :disabled
  :ensure nil
  :load-path "tabs/"
  :commands tabs-mode
  ;; :diminish tabs-mode
  :bind
  (("s-T" . tabs-toggle-display)
   ("s-t" . tabs-new-tab)
   :map tabs-keymap
   ("s-}" . tabs-next-tab)
   ("s-{" . tabs-previous-tab)
   ("s-w" . tabs-close-current-tab))
  :config (tabs-mode))

;;; init.el ends here
