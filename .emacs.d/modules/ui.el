;;; modules/ui.el --- UI/Appearance


;;; Code:

;; Disable startup screen
(setq inhibit-startup-screen t
      initial-scratch-message nil)

;; Kill startup buffers on startup
(defun my/kill-startup-buffers ()
  "Kill scratch and messages buffers on startup."
  (when (get-buffer "*scratch*")
    (kill-buffer "*scratch*"))
  ;; (when (get-buffer "*Messages*")
  ;;   (kill-buffer "*Messages*"))
  (when (get-buffer "*straight-process*")
    (kill-buffer "*straight-process*")))

(add-hook 'emacs-startup-hook #'my/kill-startup-buffers)

;; Frame title
(setq frame-title-format '("%b – Emacs"))

;; Clean UI - remove clutter
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq ring-bell-function 'ignore)  ; Disable bell

;; Smooth scrolling
(setq scroll-margin 3
      scroll-conservatively 101
      scroll-preserve-screen-position t
      auto-window-vscroll nil)

;; Better line wrapping
(global-visual-line-mode 1)

;; Line numbers
(setq-default display-line-numbers-width 3)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Show matching parentheses
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Highlight current line
(global-hl-line-mode 1)


(use-package centaur-tabs
  :demand t
  :config
  (centaur-tabs-mode t)
  (setq centaur-tabs-style "bar"
        centaur-tabs-height 32
        centaur-tabs-set-icons t
        centaur-tabs-set-modified-marker t
        centaur-tabs-modified-marker "●"
        centaur-tabs-close-button "×"
        centaur-tabs-set-bar 'under        
        centaur-tabs-gray-out-icons 'buffer)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward))

(setq x-underline-at-descent-line t)



;; Theme
(use-package doom-themes
  :demand t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config)
  (doom-themes-treemacs-config))  ; Treemacs theme integration


;; Modeline
(use-package doom-modeline
  :demand t
  :config
  (setq doom-modeline-height 30
        doom-modeline-bar-width 4
        doom-modeline-buffer-file-name-style 'truncate-with-project
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-minor-modes nil
        doom-modeline-buffer-encoding nil
        doom-modeline-vcs-max-length 20)
  :hook (after-init . doom-modeline-mode))

;; Icons
(use-package nerd-icons
  :demand t)

;; All-the-icons (needed for some packages)
(use-package all-the-icons
  :if (display-graphic-p))

;; PROJECT TREE EXPLORER - Treemacs
(use-package treemacs
  :demand t
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t f"   . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))
  :config
  (setq treemacs-width 35
        treemacs-width-is-initially-locked t
        treemacs-is-never-other-window t
        treemacs-follow-mode t
        treemacs-no-header-line t
        ;; treemacs-no-png-images t
        treemacs-display-in-side-window t
        treemacs-indent-guide-style 'line
        treemacs-user-mode-line-format 'none
        treemacs-filewatch-mode t
        treemacs-fringe-indicator-mode 'always
        treemacs-git-mode 'deferred
        treemacs-collapse-dirs 3
        treemacs-sorting 'alphabetic-asc
        treemacs-show-hidden-files t
        treemacs-indentation 2
        treemacs-space-between-root-nodes nil)
  
  ;; Remove the fringe
  (add-hook 'treemacs-mode-hook (lambda () (set-window-fringes nil 0 0)))
  (add-hook 'treemacs-mode-hook 'variable-pitch-mode)
  
  ;; Theme integration
  (with-eval-after-load 'treemacs
    (set-face-attribute 'treemacs-window-background-face nil 
                        :background (face-attribute 'default :background))
    (set-face-attribute 'treemacs-hl-line-face nil 
                        :background (doom-lighten (face-attribute 'default :background) 0.05))))
;; Treemacs icons
(use-package treemacs-nerd-icons
  :after treemacs
  :demand t
  :config
  (treemacs-load-theme "nerd-icons")
  (setq treemacs-nerd-icons-nodes-height 1.0)
  )

;; Treemacs + Projectile integration
(use-package treemacs-projectile
  :after (treemacs projectile))

;; Treemacs + Magit integration
(use-package treemacs-magit
  :after (treemacs magit))

;; Auto-open treemacs on startup
(add-hook 'emacs-startup-hook 'treemacs)

;; Dashboard - better startup screen
(use-package dashboard
  :demand t
  :config
  (setq dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-items '((recents  . 5)
                          (projects . 5)
                          (bookmarks . 5))
        dashboard-set-navigator t
        dashboard-set-init-info t)
  (dashboard-setup-startup-hook))

;; Rainbow delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Highlight TODO keywords
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-keyword-faces
        '(("TODO"   . "#FF0000")
          ("FIXME"  . "#FF0000")
          ("HACK"   . "#FF8C00")
          ("NOTE"   . "#1E90FF")
          ("DEPRECATED" . "#8B008B"))))

;; Indent guides
(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-responsive 'top
  )
)
;; Better window dividers
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(window-divider-mode 1)

;; Ligatures support (for JetBrains Mono)
(use-package ligature
  :config
  (ligature-set-ligatures 'prog-mode 
                          '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                            ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                            "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                            "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                            "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                            "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                            "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                            "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                            ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                            "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                            "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                            "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                            "\\\\" "://"))
  (global-ligature-mode t))

;; Dimmer - dim inactive windows
(use-package dimmer
  :config
  (setq dimmer-fraction 0.3)
  (appendq! dimmer-exclusion-predicates '(treemacs-is-treemacs-window?))  
  (dimmer-mode t))

;; Which-key - show available keybindings
(use-package which-key
  :demand t
  :config
  (setq which-key-idle-delay 0.5
        which-key-popup-type 'side-window
        which-key-side-window-location 'bottom
        which-key-side-window-max-height 0.25)
  (which-key-mode 1))

;; Beacon - highlight cursor on window switch
(use-package beacon
  :config
  (setq beacon-blink-when-window-scrolls t
        beacon-blink-when-window-changes t
        beacon-blink-when-point-moves-vertically 10)
  (beacon-mode 1))

;; Better help buffers
(use-package helpful
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key)
  ([remap describe-command] . helpful-command))

;; Font configuration for daemon mode
(defun my/setup-fonts ()
  "Setup fonts - works with daemon mode."
  (when (display-graphic-p)
    (set-face-attribute 'default nil
                        :family "Monaco Nerd Font"
                        :height 80)
    (set-face-attribute 'fixed-pitch nil
                        :family "Monaco Nerd Font"
                        :height 80)
    (when (find-font (font-spec :name "Fira Code Nerd Font"))
      (set-face-attribute 'variable-pitch nil
                          :family "Fira Code Nerd Font"
                          :height 80))))

;; Apply fonts correctly for both daemon and normal mode
(if (daemonp)
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (with-selected-frame frame
                  (my/setup-fonts))))
  (my/setup-fonts))

;; Also set default-frame-alist for new frames
(add-to-list 'default-frame-alist '(font . "Monaco-14"))

(provide 'ui)
;;; ui.el ends here
