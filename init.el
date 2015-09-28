;;; init.el --- Mads' configuration file
;;; Commentary:
;;; Code:

(server-start)

(require 'package)

(setq package-enable-at-startup nil)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

;; Load my packages
(package-initialize)

;; Make sure `use-package' is installed.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-verbose t)

(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'load-path "/Volumes/credentials/")
(load "~/.emacs.d/lisp/functions.el")
(load "~/.emacs.d/lisp/sql-logins.el")

(if window-system
    (progn
      (load-theme 'zenburn t)
      ;; (set-face-attribute 'default nil :font "DejaVu Sans Mono-12:antialias=subpixel")
      (set-face-attribute 'default nil :font "Hack-12:antialias=subpixel")))

(unless window-system
  (global-set-key (kbd "C-M-d") 'backward-kill-word)
  (menu-bar-mode -1))

;; Put the auto-generated custom changes in another file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; Always ask for y/n keypress instead of typing out 'yes' or 'no'
(defalias 'yes-or-no-p 'y-or-n-p)

(global-hi-lock-mode nil)
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
(setq compilation-scroll-output t)
(setq ns-pop-up-frames nil)
(setq compilation-ask-about-save nil) ; Automatically save buffers before compiling
(setq frame-title-format '((:eval buffer-file-name)))
(setq whitespace-style '(trailing tabs tab-mark face))
(setq compilation-read-command nil)
(setq speedbar-show-unknown-files t)
(setq enable-local-variables :all) ; Sort of scary.
(setq dabbrev-case-replace nil)
(setq dabbrev-case-distinction nil)
(setq dabbrev-case-fold-search nil)
(setq tramp-default-method "ssh")

(pending-delete-mode t)
(normal-erase-is-backspace-mode 1)
(delete-selection-mode t)
(scroll-bar-mode -1)
(show-paren-mode t)
(tool-bar-mode -1)
(global-auto-revert-mode 1)  ; pick up changes to files on disk automatically
(electric-pair-mode -1)
(global-linum-mode -1)
(global-hl-line-mode -1)
(global-whitespace-mode)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(customize-set-variable 'indicate-empty-lines t) ; get those cute dashes in the fringe.
(customize-set-variable 'fringe-mode nil)        ; default fringe-mode

(global-set-key [(super shift return)] 'toggle-maximize-buffer)
(global-set-key (kbd "M-;") 'comment-dwim)
(global-set-key (kbd "C-;") #'comment-line-dwim)
(global-set-key (kbd "M-s o") #'occur-dwim)
(global-set-key (kbd "s-w") 'delete-frame)
(global-set-key (kbd "s-<return>") 'toggle-fullscreen)
(global-set-key (kbd "C-x C-SPC") 'pop-to-mark-command)
(global-set-key (kbd "s-+") 'text-scale-increase)
(global-set-key (kbd "s--") 'text-scale-decrease)
(global-set-key (kbd "s-{")  'prev-window)
(global-set-key (kbd "s-}") 'other-window)
(global-set-key (kbd "M-a") 'insert-aa) ; For when I want to
(global-set-key (kbd "M-o") 'insert-oe) ; write danish with my
(global-set-key (kbd "M-'") 'insert-ae) ; uk layout keyboard.
(global-set-key (kbd "C-`") 'switch-buffer-visual)
(global-set-key (kbd "s-`") 'ns-next-frame)
(global-set-key (kbd "s-¬") 'ns-prev-frame)
(global-set-key (kbd "C-c C-1") 'previous-buffer)
(global-set-key (kbd "C-c C-2") 'next-buffer)
(global-set-key (kbd "M-/") 'dabbrev-expand)

(define-key isearch-mode-map (kbd "<backspace>") 'isearch-delete-char)

;; Put the compilation buffer at the bottom.
(add-to-list 'display-buffer-alist
             `(,(rx bos "*compilation*" eos)
               (display-buffer-reuse-window
                display-buffer-in-side-window)
               (reusable-frames . visible)
               (side            . bottom)
               (window-height   . 0.3)))

;; Awesome little package for expanding macros. Helps to understand
;; what is going on im my use-package declarations.
(use-package macrostep
  :ensure t
  :bind ("C-c e m" . macrostep-expand))

;; My own small package for report specifications for one of our
;; internal analytics systems at issuu
(use-package report-spec-mode
  :load-path "dev-pkgs/"
  :defer)

;; My own small package for hdl files.
(use-package hdl-mode
  :load-path "dev-pkgs/"
  :mode "\\.hdl\\'" :defer)

;; A different buffer view.
(use-package ibuffer
  :bind ("C-x C-b" . ibuffer))

(use-package ace-jump-mode
  :ensure nil
  :disabled
  :bind ("C-<tab>" . ace-jump-mode))

(use-package ace-jump-zap
  :disabled
  :bind ("M-z" . ace-jump-zap-to-char))

(use-package ace-window
  :ensure t
  :disabled
  :bind ("C-x o" . ace-window))

(use-package direx
  :ensure t
  :bind ("C-x d" . ido-wrapper/direx:find-directory)
  :init (require 'direx))

(use-package exec-path-from-shell
  :init
  (progn
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-env "CAML_LD_LIBRARY_PATH"))) ; Used by OCaml.

(use-package shell
  :commands shell
  :config
  (progn
    (define-key shell-mode-map (kbd "s-k") 'clear-shell)
    (define-key shell-mode-map (kbd "<up>") 'comint-previous-input)
    (define-key shell-mode-map (kbd "<down>") 'comint-next-input)))

(use-package flyspell
  :commands flyspell-mode
  :config (progn
            (define-key flyspell-mode-map (kbd "C-.") nil)))

(use-package ido
  :ensure t
  :init
  (progn
    (ido-mode 1)
    (setq ido-enable-flex-matching t)
    (setq ido-use-filename-at-point nil)
    (setq ido-create-new-buffer 'always)
    (setq ido-max-prospects 5)
    (setq ido-auto-merge-work-directories-length -1))) ; disable annoying directory search

(use-package ido-vertical-mode
  :ensure t
  :init
  (progn
    (ido-vertical-mode 1)
    (defun bind-ido-keys ()
      (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
      (define-key ido-completion-map (kbd "C-p")   'ido-prev-match))

    (add-hook 'ido-setup-hook #'bind-ido-keys)))

(use-package magit
  :ensure t
  :commands magit-status
  :config
  (progn
    (setq magit-last-seen-setup-instructions "1.4.0")
    (setq magit-push-always-verify `PP)))

(use-package projectile
  :ensure t
  :diminish " P"
  :init (progn

          (defun projectile-direx ()
            (direx:find-directory (projectile-project-root)))

          (projectile-global-mode)
          (setq projectile-switch-project-action #'projectile-direx)
          (setq projectile-completion-system 'helm)
          (setq projectile-tags-command "/usr/local/bin/ctags -Re -f %s %s")
          (setq projectile-use-git-grep t)))

(use-package helm
  :ensure t
  :init
  (progn
    (setq helm-follow-mode t)
    (setq helm-split-window-in-side-p t)
    (setq helm-buffers-fuzzy-matching t)
    (setq helm-M-x-always-save-history nil)
    (custom-set-faces
     '(helm-source-header ((t (:foreground "white" :weight bold :family "Sans Serif"))))))
  :bind (("C-c C-s" . helm-occur)
         ("C-." . helm-M-x)
         ("C-x b" . helm-buffers-list)
         ("M-y" . helm-show-kill-ring)))

(use-package helm-projectile
  :ensure t
  :bind ("C-c p p" . helm-projectile-switch-project)
  :config
  (progn
    ;; Removes 'helm-source-projectile-projects' from C-c p h as it is
    ;; possible to switch project using 'helm-projectile-switch-project'
    (setq helm-projectile-sources-list
          '(helm-source-projectile-files-list
            helm-source-projectile-buffers-list
            helm-source-projectile-recentf-list))))

(use-package helm-git-grep
  :ensure t
  :bind (("s-F" . helm-git-grep)))

(use-package expand-region
  :ensure t
  :bind ("C-w" . er/expand-region))

;; TODO: Would prefer to use company mode everywhere.
(use-package auto-complete
  :ensure t
  :init (global-auto-complete-mode t)
  :config (progn
            (ac-config-default)
            (setq ac-auto-start nil)
            (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
            (define-key ac-complete-mode-map "\C-n" 'ac-next)
            (define-key ac-complete-mode-map "\C-p" 'ac-previous)))

(use-package multiple-cursors
  :ensure t
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

(use-package bookmark+
  :ensure t
  :bind (("s-<f2>" . bmkp-toggle-autonamed-bookmark-set/delete)
         ("<f2>" . bmkp-next-bookmark-this-buffer)
         ("S-<f2>" . bmkp-previous-bookmark-this-buffer))
  :config (progn
          (setq bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
          (setq bmkp-auto-light-when-set 'autonamed-bookmark)))

(use-package ag
  :ensure t
  :commands ag
  :config (progn
            (setq ag-highlight-search t)
            (setq ag-reuse-buffers 't)))

(use-package diminish
  :ensure t)

(use-package undo-tree
  :ensure t
  :diminish " U"
  :bind (("C-x u" . undo-tree-visualize))
  :init
  (progn
    (setq undo-tree-visualizer-relative-timestamps t)
    (setq undo-tree-visualizer-timestamps t)))

;; TODO: Something seems broken here. It keeps trying to load a ./snippets dir
;;       when I activate yas-minor-mode.
(use-package yasnippet
  :ensure t
  :defer
  :commands yas-minor-mode
  :config (progn
            (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
            ;; (yas-reload-all)
            ))

(use-package diff-hl
  :ensure t
  :init (global-diff-hl-mode))

(use-package org
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

    ;; Capturing notes
    (setq org-capture-templates
      '(("b" "Bookmark" entry (file+headline "~/Dropbox/org/urls.org" "Bookmarks")
         "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n" :empty-lines 1)
        ))

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
            "~/Dropbox/org/notes"))

    ;; (add-hook 'org-mode-hook 'yas-minor-mode)

    ;; http://www.wisdomandwonder.com/link/9573/how-to-correctly-enable-flycheck-in-babel-source-blocks
    (defadvice org-edit-src-code (around set-buffer-file-name activate compile)
      (let ((file-name (buffer-file-name)))
        ad-do-it
        (setq buffer-file-name file-name)))))

(use-package smart-mode-line
  :ensure t
  :disabled t
  :init (progn
          (setq sml/no-confirm-load-theme t)
          (sml/setup)
          (sml/apply-theme 'powerline)))

(use-package scss-mode
  :commands scss-mode
  :config (setq scss-compile-at-save nil))

(use-package web-mode
  :ensure t
  :commands web-mode
  :mode ("\\.js[x]?\\'" . web-mode)
  :config
  (progn
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

    ;; Get web-mode to use tern for code-completion
    (defadvice company-tern (before web-mode-set-up-ac-sources activate)
      "Set `tern-mode' based on current language before running company-tern."
      (if (equal major-mode 'web-mode)
          (let ((web-mode-cur-language
                 (web-mode-language-at-pos)))
            (if (or (string= web-mode-cur-language "jsx")
                    (string= web-mode-cur-language "javascript"))
                (unless tern-mode (tern-mode))
              (if tern-mode (tern-mode))))))

    (define-key web-mode-map (kbd "M-<tab>") 'company-tern)
    (define-key web-mode-map (kbd "C-c C-s") 'helm-occur)
    (define-key web-mode-map (kbd "M-s-≥") 'web-mode-element-close)

    (add-hook 'web-mode-hook 'flycheck-mode)
    (add-hook 'web-mode-hook 'company-mode)
    (add-hook 'web-mode-hook 'tern-mode)
    ;; NOTICE: Requires `npm install -g eslint`
    (flycheck-add-mode 'javascript-eslint 'web-mode)))

;; Code-completion for javascript files
;; we're using tern.
;; NOTICE: Requires `npm install -g tern`
(use-package tern
  :ensure t)

(use-package company-tern
  :ensure t)

(use-package markdown-mode
  :ensure t
  :commands markdown-mode
  :config
  (progn
    (define-key markdown-mode-map (kbd "M-<tab>") 'ido-complete-word-ispell)
    (add-hook 'markdown-mode-hook 'flyspell-mode)))

(use-package lisp-mode
  :commands lisp-mode
  :config
  (progn
    ;; elint current buffer seems like a fun one.
    (define-key emacs-lisp-mode-map (kbd "M-.") 'elisp-slime-nav-find-elisp-thing-at-point)
    (define-key emacs-lisp-mode-map (kbd "M-,") 'pop-tag-mark)
    (define-key emacs-lisp-mode-map (kbd "M-<tab>") 'company-complete)
    (add-hook 'emacs-lisp-mode-hook 'flycheck-mode)
    (add-hook 'emacs-lisp-mode-hook 'turn-on-elisp-slime-nav-mode)
    (add-hook 'emacs-lisp-mode-hook 'flyspell-prog-mode)
    (add-hook 'emacs-lisp-mode-hook 'company-mode)
    (add-hook 'emacs-lisp-mode-hook 'eldoc-mode)))

(use-package octave
  :commands octave-mode
  :config
  (progn
    (autoload 'octave-mode "octave-mod" nil t)
    (setq auto-mode-alist (cons '("\\.m$" . octave-mode) auto-mode-alist))
    (add-hook 'octave-mode-hook (lambda ()
                                  (abbrev-mode 1)
                                  (auto-fill-mode 1)
                                  (if (eq window-system 'x)
                                      (font-lock-mode 1))))))

(use-package erlang
  :commands erlang-mode
  :config
  (progn
    (add-to-list 'load-path "/Users/hartmann/dev/distel/elisp") ; Not in melpa yet
    (require 'distel)

    (distel-setup)
    ;; http://parijatmishra.wordpress.com/2008/08/15/up-and-running-with-emacs-erlang-and-distel/
    ;; http://alexott.net/en/writings/emacs-devenv/EmacsErlang.html#sec8
    (setq inferior-erlang-machine-options '("-sname" "emacs"))

    (define-key erlang-mode-map (kbd "M-.") 'erl-find-source-under-point)
    (define-key erlang-mode-map (kbd "M-,") 'erl-find-source-unwind)
    (define-key erlang-mode-map (kbd "M-<tab>") 'erl-complete)
    (define-key erlang-mode-map (kbd "C-c C-c") 'compile)
    (define-key erlang-mode-map (kbd "C-c C-s") nil)
    (define-key erlang-mode-map (kbd "<return>")'newline-and-indent)

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
    (define-key merlin-mode-map "\M-," 'merlin-pop-stack)
    (define-key merlin-mode-map (kbd "C-c C-p") 'prev-match)
    (define-key merlin-mode-map (kbd "C-c C-n") 'next-match)
    (define-key tuareg-mode-map (kbd "C-x C-r") 'tuareg-eval-region)
    (define-key tuareg-mode-map (kbd "C-c C-s") nil)

    ;; (setq merlin-logfile "/Users/hartmann/Desktop/merlin.log")
    (setq merlin-error-after-save t)

    (add-hook 'tuareg-mode-hook
              (lambda ()
                (merlin-mode)
                (utop-minor-mode)
                (define-key utop-minor-mode-map (kbd "C-c C-z") 'utop)
                (define-key utop-minor-mode-map (kbd "C-c C-s") nil)
                (setq indent-line-function 'ocp-indent-line)))))

(use-package python
  :commands python-mode
  :config
  (progn
    (define-key python-mode-map (kbd "M-<tab>") 'jedi:complete)
    (define-key python-mode-map (kbd "C-c C-s") 'helm-occur)
    (define-key python-mode-map (kbd "C-c C-c") 'compile)
    (define-key python-mode-map (kbd "C-c C-p") nil)
    (add-hook 'python-mode-hook 'flycheck-mode)
    (add-hook 'python-mode-hook 'jedi:setup)
;; (add-hook 'python-mode-hook 'yas-minor-mode)
))

(use-package jedi
  :ensure
  :defer
  :config
  (progn
    (add-hook 'python-mode-hook 'jedi:setup)
    (add-hook 'jedi-mode-hook
              (lambda ()
                (define-key jedi-mode-map (kbd "C-<tab>") nil)
                (define-key jedi-mode-map "\M-." 'jedi:goto-definition)
                (define-key jedi-mode-map "\M-," 'jedi:goto-definition-pop-marker)))))

(use-package flycheck
  :ensure
  :commands flycheck-mode)

(use-package highlight-symbol
  :ensure t
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
  :ensure t)

(use-package elixir-mode
  :ensure t
  :commands elixir-mode
  :config
  (progn
    (add-hook 'elixir-mode-hook 'alchemist-mode)))

(use-package alchemist
  :ensure t
  :commands alchemist-mode
  :config (progn
            ;; (add-hook 'alchemist-mode-hook 'yas-minor-mode)
            (add-hook 'alchemist-mode-hook 'company-mode)
            (add-hook 'alchemist-iex-mode-hook 'company-mode)
            (define-key alchemist-mode-map (kbd "M-<tab>") 'company-complete)
            (define-key alchemist-mode-map (kbd "M-?") 'alchemist-help-search-at-point)
            (define-key alchemist-mode-map (kbd "C-c C-t") 'alchemist-mix-test-file)
            (define-key alchemist-mode-map (kbd "C-c C-c") 'alchemist-mix-compile)
            (define-key alchemist-mode-map (kbd "C-c C-r") 'alchemist-mix-run)
            (define-key alchemist-mode-map (kbd "C-c C-z") 'alchemist-iex-project-run)))

(use-package scala-mode
  :ensure
  :commands scala-mode
  :config
  (progn
    ;; (add-hook 'scala-mode-hook 'yas-minor-mode)
    (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)))

(use-package ensime
  :ensure
  :commands ensime
  :config
  (progn
    ;; Disable automatic completion
    (setq ensime-completion-style nil)
    (define-key ensime-mode-map (kbd "<tab>") nil)
    (define-key ensime-mode-map (kbd "M-<tab>") 'ensime-company)
    (define-key ensime-mode-map (kbd "C-c C-t") 'ensime-print-type-at-point)))

(use-package elm-mode
  :ensure t
  :commands elm-mode)

(use-package jinja2-mode
  :ensure t
  :commands jinja2-mode)

(use-package wgrep :ensure t)           ; Makes it possbile to edit grep buffers!
(use-package wgrep-helm :ensure t)        ; wgrep support for helm.

(use-package tex-mode
  :commands tex-mode
  :config
  (progn
    ;; This currently doesn't override the annoying tex-compile
    (define-key tex-mode-map (kbd "C-c C-c") 'compile)
    (define-key latex-mode-map (kbd "C-c C-c") 'compile)))

;;; init.el ends here
