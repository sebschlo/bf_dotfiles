;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(setq user-full-name "Sebastian Schloesser"
      user-mail-address "seb@breakfastny.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 17.0))
(setq doom-variable-pitch-font (font-spec :family "Avenir Next" :size 17.0))

;There are two ways to load a theme. Both assume the theme is installed and
;available. You can either set `doom-theme' or manually load a theme with the
;`load-theme' function. This is the default:

;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-acario-light)
;; (setq doom-theme 'doom-horizon)
;; (setq doom-theme 'doom-laserwave)
;; (setq doom-theme 'doom-moonlight)
;; (setq doom-theme 'doom-nord)
;; (setq doom-theme 'doom-nord-light)
(setq doom-theme 'doom-outrun-electric)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(setq doom-line-numbers-style 'relative)
(setq blink-cursor-mode 1)

(remove-hook 'text-mode-hook #'auto-fill-mode)
(add-hook 'message-mode-hook #'word-wrap-mode)
(global-visual-line-mode t)
(setq evil-respect-visual-line-mode t)
(setq hl-fill-column-mode nil)
(map! :n "j" #'evil-next-visual-line
      :n "k" #'evil-previous-visual-line)

(setq hl-fill-column-mode nil)

;; Enable mouse support
(xterm-mouse-mode t)
(unless window-system
(global-set-key (kbd "<mouse-4>") 'scroll-down-line)
(global-set-key (kbd "<mouse-5>") 'scroll-up-line))

(defun window-split-toggle ()
  "Toggle between horizontal and vertical split with two windows."
  (interactive)
  (if (> (length (window-list)) 2)
      (error "Can't toggle with more than 2 windows!")
    (let ((func (if (window-full-height-p)
                    #'split-window-vertically
                  #'split-window-horizontally)))
      (delete-other-windows)
      (funcall func)
      (save-selected-window
        (other-window 1)
        (switch-to-buffer (other-buffer))))))

;; Window navigation
(map!
 :nv "C-h" #'evil-window-left
 :nv "C-j" #'evil-window-down
 :nv "C-k" #'evil-window-up
 :nv "C-l" #'evil-window-right
 :nv "C-w" #'evil-window-delete)

;; Org checkboxes
(map! (:leader :desc "Org Toggle Checkbox" "m m" #'org-toggle-checkbox))

;; Helpful
(map! (:leader :desc "Helpful at point" "h h" #'helpful-at-point))

;; copy/paste
(map! (:leader :desc "Show the Kill Ring" "v" #'counsel-yank-pop))

;; Mark todo as done
(defun my-org-todo-done ()
  (interactive)
  "Mark todo as done"
  (org-todo 'done))
(map! (:leader :desc "Mark todo as done" "d" #'my-org-todo-done))

(map! (:leader :desc "Schedule todo" "m s" #'org-schedule))
(map! (:leader :desc "Org-Todo" "T" #'org-todo))

;; Insert time on timestamps
(defun
    my-org-time-stamp ()
  (interactive)
  "Insert timestamp with time"
  (org-time-stamp t))
(map! (:leader :desc "Current Timestamp" "m c" #'my-org-time-stamp))

;; Clipboard into OSX
(map! (:leader :desc "Copy into OSX and rink" "y" #'clipboard-kill-ring-save))
(map! "M-p" #'clipboard-yank)

;; Tags
(map! (:leader :desc "Insert tag from global list" "m t" #'air-org-set-tags))

(setq select-enable-clipboard nil)

(setenv "SHELL" "/bin/zsh")
(setq explicit-shell-file-name "/bin/zsh")

(require 'org-crypt)
(require 'epa-file)
(epa-file-enable)
(setq org-tags-exclude-from-inheritance (quote ("crypt"))
      org-crypt-key nil)

(server-start)

(global-undo-tree-mode)

(setq projectile-mode-line "Projectile")
(defadvice projectile-project-root (around ignore-remote first activate)
  (unless (file-remote-p default-directory) ad-do-it))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org")
(setq org-agenda-files (directory-files-recursively "~/org/" "\\.org$"))
(setq org-agenda-show-future-repeats nil)
(setq org-cycle-separator-lines -1)

(map! :leader
      :desc "Access org agenda" "A"
      'org-agenda "a" "a")

(after! org
  ;; Log timestamp on org todos
  (setq org-log-done 'time)

  ;; make sure cookies update
  (defun +org|update-cookies ()
    "Update counts in headlines (aka \"cookies\")."
    (when (and buffer-file-name (file-exists-p buffer-file-name))
      (org-update-statistics-cookies t)))

  (add-hook 'before-save-hook #'+org|update-cookies nil t)
  (add-hook 'evil-insert-state-exit-hook #'+org|update-cookies nil t)

  ;; Recompute agenda files and nodes
  (defun +org|add-agenda-files ()
    (when (eq major-mode 'org-mode)
      (org-roam-db-sync)
      (setq org-agenda-files (directory-files-recursively "~/org/" "\\.org$"))))

  (add-hook 'after-save-hook #'+org|add-agenda-files)

  ;; Org smart insert item.
  (map! :after evil-org
        :map evil-org-mode-map
        :n "C-o" #'+org/insert-item-below)

  ;; Auto save all the time
  ;; (add-hook 'auto-save-hook 'my-commit-org-files) TURNED OFF FOR NOW, TOO MUCH DROPBOX DATA
  (defun my-commit-org-files ()
    (interactive)
    "Commit all org files"
    (org-save-all-org-buffers)
    (shell-command "~/org/auto_commit.sh"))

  ;; Todo keywords
  (setq org-todo-keywords
        '((sequence "TODO(t/!)" "PROJ(p)" "STRT(s!)" "|" "DONE(d/!)" "KILL(k/!)")
          (sequence "WAIT(w/!)" "|" "DELG(g/!)")))


  ;; Tags
  (defun air--org-swap-tags (tags)
    "Replace any tags on the current headline with TAGS. The assumption is that TAGS will be a string conforming to Org Mode's tag format specifications, or nil to remove all tags."
    (let ((old-tags (org-get-tags-string))
          (tags (if tags
                    (concat " " tags)
                  "")))
      (save-excursion
        (beginning-of-line)
        (re-search-forward
         (concat "[ \t]*" (regexp-quote old-tags) "[ \t]*$")
         (line-end-position) t)
        (replace-match tags)
        (org-set-tags t))))



  (defun air-org-set-tags (tag)
    "Add TAG if it is not in the list of tags, remove it otherwise. TAG is chosen interactively from the global tags completion table."
    (interactive
     (list (let ((org-last-tags-completion-table
                  (if (derived-mode-p 'org-mode)
                      (org-uniquify
                       (delq nil (append (org-get-buffer-tags)
                                         (org-global-tags-completion-table))))
                    (org-global-tags-completion-table))))
             (org-icompleting-read
              "Tag: " 'org-tags-completion-function nil nil nil
              'org-tags-history))))
    (let* ((cur-list (org-get-tags))
           (new-tags (mapconcat 'identity
                                (if (member tag cur-list)
                                    (delete tag cur-list)
                                  (append cur-list (list tag)))
                                ":"))
           (new (if (> (length new-tags) 1) (concat " :" new-tags ":")
                  nil)))
      (air--org-swap-tags new)))


  ;; Agenda setup
  (setq org-agenda-todo-ignore-scheduled t
        org-agenda-todo-ignore-deadlines t
        hl-fill-column-mode nil)

  (setq org-agenda-custom-commands
        '(("c" "Closed review"
           tags "TODO=\"DONE\"&CLOSED>=\"<-1w>\""
           ((org-agenda-files (directory-files-recursively "~/org/" "\\.org$")))
        )))

  ;; Capture Templates
  (setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/todo.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a"))))


;; Alfred Integration
(defadvice org-switch-to-buffer-other-window
    (after supress-window-splitting activate)
  "Delete the extra window if we're in a capture frame"
  (if (equal "remember" (frame-parameter nil 'name))
      (delete-other-windows)))

(defadvice org-capture-finalize
    (after delete-capture-frame activate)
  "Advise capture-finalize to close the frame"
  (when (and (equal "remember" (frame-parameter nil 'name))
             (not (eq this-command 'org-capture-refile)))
    (delete-frame)))

(defadvice org-capture-refile
    (after delete-capture-frame activate)
  "Advise org-refile to close the frame"
  (delete-frame))

(defun make-orgcapture-frame ()
  "Create a new frame and run org-capture."
  (interactive)
  (make-frame '((name . "remember") (width . 80) (height . 16)
                (top . 400) (left . 300)
                (font . "-apple-Monaco-medium-normal-normal-*-13-*-*-*-m-0-iso10646-1")
                ))
  (select-frame-by-name "remember")
  (org-capture)
  (delete-frame "remember"))

(use-package! org-noter
  :after org
  :config
  (setq org-noter-notes-window-location 'vertical-split
        org-noter-notes-search-path '("~/org")
        org-noter-auto-save-last-location t
        org-noter-default-notes-file-names '("~/org/pdf_notes.org")))

(use-package org-roam
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "~/org")
  :bind (:map org-roam-mode-map
         (("C-c n l" . org-roam)
          ("C-c n f" . org-roam-find-file)
          ("C-c n j" . org-roam-jump-to-index)
          ("C-c n b" . org-roam-switch-to-buffer)
          ("C-c n g" . org-roam-graph))
         :map org-mode-map
         (("C-c n i" . org-roam-insert))))
(map! :leader
      (:prefix-map ("j" . "journal")
       :desc "Capture new entry" "n" #'org-roam-dailies-capture-today
       :desc "Go to today's entry" "t" #'org-roam-dailies-find-today
       :desc "Go to yesterday's entry" "y" #'org-roam-dailies-find-yesterday
       :desc "Go to specific date" "d" #'org-roam-dailies-find-date
       :desc "Toggle the org-roam buffer" "b" #'org-roam-buffer-toggle))
(map! :leader
      :desc "Add org-roam node" "a" #'org-roam-node-insert
      :desc "Find org-roam node" "F" #'org-roam-node-find)

(defadvice org-roam-insert (around append-if-in-evil-normal-mode activate compile)
  "If in evil normal mode and cursor is on a whitespace character, then go into
append mode first before inserting the link. This is to put the link after the
space rather than before."
  (let ((is-in-evil-normal-mode (and (bound-and-true-p evil-mode)
                                     (not (bound-and-true-p evil-insert-state-minor-mode))
                                     (looking-at "[[:blank:]]"))))
    (if (not is-in-evil-normal-mode)
        ad-do-it
      (evil-append 0)
      ad-do-it
      (evil-normal-state))))

(use-package! company-org-roam
  :when (featurep! :completion company)
  :after org-roam
  :config
  (set-company-backend! 'org-mode '(company-org-roam company-yasnippet company-dabbrev)))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org
  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;; (require 'company-sourcekit)
;; (add-to-list 'company-backends 'company-sourcekit)

(use-package lsp-sourcekit
  :after lsp-mode
  :config
  (setq lsp-sourcekit-executable "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp"))

(use-package swift-mode
  :hook (swift-mode . (lambda () (lsp))))

(with-eval-after-load 'lsp-mode
  (setq lsp-diagnostics-modeline-scope :project)
  (add-hook 'lsp-managed-mode-hook 'lsp-diagnostics-modeline-mode))
