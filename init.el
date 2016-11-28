
(package-initialize)
(setq package-enable-at-startup nil)
(setq custom-file "~/.emacs.d/custom-settings.el")
(load custom-file t)
(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (package-refresh-contents)
)
(setq inhibit-startup-screen t)
;; Always try to install a package if not present
(setq use-package-always-ensure t)

(setq user-full-name "Ares Aguilar"
      user-mail-address "aresaguilarsotos@gmail.com")

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

(use-package savehist
  :config
  (progn
    (setq savehist-file "~/.emacs.d/savehist"
          history-length t
          history-delete-duplicates t
          savehist-save-minibuffer-history 1
          savehist-additional-variables
          '(kill-ring
            search-ring
            regexp-search-ring))
    (savehist-mode 1)))

(use-package persistent-scratch
  :config
  (persistent-scratch-setup-default))

(use-package helm
  :diminish helm-mode
  :init
  (progn
    (require 'helm-config)
    (require 'helm)
    (global-set-key (kbd "C-c h") 'helm-command-prefix)
    (global-unset-key (kbd "C-x c"))
    (setq helm-candidate-number-limit 100
          helm-idle-delay 0.0
          helm-input-idle-delay 0.01
          helm-yas-display-key-on-candidate t
          helm-quick-update t
          helm-M-x-requires-pattern nil
          helm-ff-skip-boring-files t
          helm-split-window-in-side-p t
          helm-display-header-line nil
          helm-autoresize-max-height 30
          helm-autoresize-min-height 30)
    (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
    (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
    (define-key helm-map (kbd "C-z")  'helm-select-action)
    (set-face-attribute 'helm-source-header nil :height 0.1)
    (helm-mode))
  :bind (("C-x b" . helm-mini)
         ("C-h a" . helm-apropos)
         ("C-x C-b" . helm-buffers-list)
         ("M-y" . helm-show-kill-ring)
         ("M-x" . helm-M-x)
         ("C-x c o" . helm-occur)
         ("C-x C-f" . helm-find-files)))

(fset 'yes-or-no-p 'y-or-n-p)

(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))

(use-package guide-key
  :defer t
  :diminish guide-key-mode
  :config
  (progn
  (setq guide-key/guide-key-sequence '("C-x r" "C-x 4" "C-c"))
  (guide-key-mode 1)))  ; Enable guide-key-mode

(tool-bar-mode -1)
(menu-bar-mode -1)

(scroll-bar-mode -1)

(use-package smart-mode-line)

(use-package monokai-theme
  :config
  (load-theme 'monokai t))

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq buffer-file-coding-system 'utf-8)
(setq default-file-name-coding-system 'utf-8)
(setq default-keyboard-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))
(setq default-sendmail-coding-system 'utf-8)
(setq default-terminal-coding-system 'utf-8)
(set-language-environment "UTF-8")
(when (display-graphic-p)
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

(use-package whitespace
  :config
  (progn
    (setq whitespace-display-mappings
          ;; all numbers are Unicode codepoint in decimal. try (insert-char 182 ) to see it
          '(
            (space-mark 32 [183] [46]) ; 32 SPACE, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
            (newline-mark 10 [182 10]) ; 10 LINE FEED
            (tab-mark 9 [9655 9] [92 9]) ; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE 「▷」
            ))
    (set-face-attribute 'whitespace-space nil :foreground "#272822")))

(use-package avy-zap
  :bind (("M-z" . avy-zap-up-to-char-dwim)
         ("M-Z" . avy-zap-to-char-dwim)))

(defun slick-copy (beg end)
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (message "Copied line")
     (list (line-beginning-position) (line-beginning-position 2)))))

(advice-add 'kill-ring-save :before #'slick-copy)

(use-package expand-region
  :defer t
  :bind ("C-+" . er/expand-region))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click)))

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)) ; one line at a time
      mouse-wheel-progressive-speed nil            ; don't accelerate
      mouse-wheel-follow-mouse 't                  ; scroll window under mouse
      scroll-conservatively 10000
      auto-window-vscroll nil
 )

(use-package ace-window
  :config (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package avy
  :bind ("M-g g" . avy-goto-line)
  :config (define-key isearch-mode-map (kbd "C-'") 'avy-isearch))

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(use-package key-chord
  :init
  (progn
    (setq key-chord-one-key-delay 0.15)
    (key-chord-mode 1)
    (key-chord-define-global "uu" 'undo)
    (key-chord-define-global "JJ" 'switch-to-previous-buffer)
    (key-chord-define-global "jj" 'avy-goto-char-timer)
    (key-chord-define-global "jk" 'avy-goto-char)
    (key-chord-define-global "jl" 'avy-goto-word-or-subword-1)
    (key-chord-define-global "jw" 'ace-window)
    (key-chord-define-global "CC" 'mc/edit-lines)))

(defun my/smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'my/smarter-move-beginning-of-line)

(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
(setq-default dired-omit-files-p t)
(setq diredp-hide-details-initially-flag t)
(setq diredp-hide-details-propagate-flag t)

(define-key key-translation-map [dead-circumflex] "^")

(setq browse-url-browser-function 'w3m-browse-url)

(setq org-directory "~/ORG")

(require 'auto-complete-config)
;; Make auto-complete work in org
(add-to-list 'ac-modes 'org-mode)
;; Variables
(custom-set-variables
 ;; Agenda files
 '(org-agenda-files (quote ("~/ORG/ARES.org" "~/ORG/trabajo.org")))
 ;; Number of consecutive days in agenda
 '(org-agenda-ndays 7)
 ;; Number of days to warn for deadlines
 '(org-deadline-warning-days 5)
 ;; Show all days in agenda, even without tasks
 '(org-agenda-show-all-dates t)
 ;; Don't warn deadlines if done
 '(org-agenda-skip-deadline-if-done t)
 ;; Don't show scheduled if done
 '(org-agenda-skip-scheduled-if-done t)
 ;; Show newest notes at top
 '(org-reverse-note-order t)
 ;; Do not use S-<arrow> (used in windmove)
 '(org-replace-disputed-keys t)
 ;; <RET> follows links
 '(org-return-follows-link t))

(global-set-key (kbd "C-c a")
                (lambda () (interactive) (find-file "~/ORG/ARES.org")))

(setq org-refile-targets '((org-agenda-files . (:maxlevel . 6))))

(global-set-key (kbd "C-c c") 'org-capture)
(setq org-default-notes-file "~/ORG/notas.org")
(setq org-capture-templates
      '(("a" "ARES Task" entry (file+headline "ARES.org" "TAREAS")
         "** TODO %?\n   %i\n"
         :empty-lines 1 :clock-keep t :kill-buffer t :prepend t)
        ("w" "WORK Task" entry (file+headline "trabajo.org" "TAREAS")
         "** TODO %?\n   %i\n"
         :empty-lines 1 :clock-keep t :kill-buffer t :prepend t)
        ("t" "TICKET" entry (file+headline "trabajo.org" "TICKETS")
         "** TODO [[https://10.0.1.151:3001/issues/%c][%^{Descripcion}]]\n   DEADLINE: %^t\n   :PROPERTIES:\n   :TICKET:   %c\n   :END:\n%^{BRANCH}p"
         :empty-lines 1 :clock-keep t :kill-buffer t :immediate-finish t :prepend t)
        ("p" "Required Package" item (file+headline "~/.emacs.d/init.org" "Prerequisites")
         "%i%?\n"
         :clock-keep t :kill-buffer t)
        ))

(use-package org-pomodoro
  :config
  (setq org-pomodoro-length 15))

;; source: http://lebensverrueckt.haktar.org/articles/org-mode-Food/
(defun food/gen-shopping-list ()
  "Generate shopping list from COCINAR items."
  (interactive)
  (goto-line 0)
  (let ((start-shopping-list (search-forward "* COMPRA" nil t)))
    (while (search-forward "** COCINAR" nil t)
      (show-subtree)
      (outline-next-visible-heading 1)
      (next-line)
      (let ((start (point)))
        (outline-next-visible-heading 1)
        ;;(previous-line)
        (copy-region-as-kill start (point)))
      (save-excursion
        (goto-char start-shopping-list)
        (newline)
        (yank)
        (show-subtree)
        (delete-blank-lines)))
    (goto-char start-shopping-list)
    (next-line)
    (org-table-goto-column 2)
    (org-table-sort-lines nil ?a)
    (goto-char start-shopping-list)
    (org-mark-subtree)
    (next-line)
    (flush-blank-lines))
  (org-table-align)
  (previous-line)
  (org-shifttab))
(defun food/clear-shopping-list ()
  "Clear everything in the shopping list."
  (interactive)
  (save-excursion
    (goto-line 0)
    (let ((start-shopping-list (search-forward "* COMPRA" nil t)))
      (show-subtree)
      (outline-next-visible-heading 1)
      (previous-line)
      (end-of-line)
      (kill-region start-shopping-list (point)))))
;; RECIPE template
(defun recipe-template ()
  "Create new recipe and add it to RECIPES list."
  (interactive)
  (goto-line 0)
  (search-forward "* RECETAS")
  (org-meta-return)
  (org-metaright)
  (setq recipe-name (read-string "Nombre: "))
  (insert recipe-name)
  (org-set-tags)
  (org-meta-return)
  (org-metaright)
  (insert "Ingredientes")
  (org-meta-return)
  (insert "Preparación")
  (search-backward recipe-name)
  (setq source (read-string "Fuente: "))
  (org-set-property "Fuente" source)
  (setq amount (read-string "Cantidad: "))
  (org-set-property "Cantidad" amount)
  )

(defun ticket-template ()
  "Create new ticket and add it to TICKETS list."
  (interactive)
  (goto-line 0)
  (search-forward "* TICKETS")
  (setq ticket-number (read-string "Ticket (num): "))
  (save-excursion
    (goto-line 0)
    (unless (eq (how-many (concat ":TICKET:[[:blank:]]+" ticket-number)) 0)
      (setq ticket-number (read-string "YA EXISTE. Otro?: "))
      ))
  (org-meta-return)
  (org-metaright)
  (setq ticket-name (read-string "Ticket (desc): "))
  (insert (concat
           "[[https://10.0.1.151:3001/issues/"
           ticket-number
           "]["
           ticket-name
           "]]"))
  (org-shiftright)
  (org-set-property "TICKET" ticket-number)
  (org-set-property "DEADLINE" "123")
  (org-set-tags)
  )

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(electric-pair-mode 1)
(show-paren-mode 1)
(setq show-paren-delay 0)

(column-number-mode 1)
(set-fill-column 80)

(use-package fill-column-indicator
  :config
  (define-globalized-minor-mode my-global-fci-mode fci-mode turn-on-fci-mode)
  (my-global-fci-mode 1))

(use-package magit
  :config
  (global-set-key (kbd "C-x g") 'magit-status))

(use-package monky
  :config
  (global-set-key (kbd "C-x G") 'monky-status))

(setq path-to-ctags "ctags")
(defun create-tags (dir-name)
  "Create tags file"
  (interactive "DDirectory: ")
  (shell-command
   (format "%s -f TAGS -e -R %s" path-to-ctags (directory-file-name dir-name))))

(use-package projectile
  :diminish projectile-mode
  :config
  (progn
    (setq projectile-keymap-prefix (kbd "C-c p")
          projectile-completion-system 'default
          projectile-enable-caching t
          projectile-indexing-method 'alien
          projectile-switch-project-action 'helm-projectile)
    (add-to-list 'projectile-globally-ignored-files "node-modules"))
  :config
  (projectile-global-mode))
;; Use projectile with helm
(use-package helm-projectile)

(require 'ecb)
(require 'ecb-util)
(require 'ecb-layout)
(require 'ecb-common-browser)
(eval-when-compile
  ;; to avoid compiler grips
  (require 'cl))

(setq ecb-tip-of-the-day nil)

;; Resize window with ECB
(add-hook 'ecb-deactivate-hook 'toggle-frame-maximized t)
;; resize the ECB window to be default (order matters here)
(add-hook 'ecb-activate-hook (lambda () (ecb-redraw-layout)))
(add-hook 'ecb-activate-hook 'toggle-frame-maximized t)

(defconst ecb-todo-buffer-name " *ECB todo")
(defun ecb-goto-todo-window ()
  "Make the todo window the current window."
  (interactive)
  (ecb-goto-ecb-window ecb-todo-buffer-name))
(defun ecb-todo-buffer-create ()
  "Create the todo buffer."
  (save-excursion
    (if (get-buffer ecb-todo-buffer-name)
        (get-buffer ecb-todo-buffer-name)
      (progn
        (find-file "c:/Users/aaguilar/ORG/trabajo.org")
        (get-buffer (rename-buffer ecb-todo-buffer-name))))))
(defecb-window-dedicator-to-ecb-buffer ecb-set-todo-buffer
    ecb-todo-buffer-name nil
  "Set the buffer in the current window to the todo-buffer and make this
window dedicated for this buffer."
  (switch-to-buffer (buffer-name (ecb-todo-buffer-create))))

(ecb-layout-define "FONETIC-layout" left-right
  "ECB Layout for FONETIC-IVR_VDF Workflow."
  ;; 1. Define directories buffer
  (ecb-set-directories-buffer)
  ;; 2. Splitting the left column in two windows
  (ecb-split-ver 0.34)
  ;; 3. Define sources buffer
  (ecb-set-sources-buffer)
  ;; 4. Split again and switch
  (ecb-split-ver 0.5)
  ;; 5. Define methods buffer
  (ecb-set-methods-buffer)
  (select-window (next-window (next-window)))
  ;; 6. Define TODO buffer
  (ecb-set-todo-buffer)
  ;; 7. Go back to ECB Edit window
  (select-window (previous-window (selected-window) 0))
  )

(require 'yasnippet)
(yas-global-mode 1)

(use-package company
  :config (add-hook 'prog-mode-hook 'company-mode))

(use-package "eldoc"
  :diminish eldoc-mode
  :commands turn-on-eldoc-mode
  :defer t
  :init
  (progn
  (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)))

(require 'cc-mode)
(setq-default c-basic-offset 4 c-default-style "k&r")
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)

;; ESS Package
(use-package ess-site
  :ensure ess
  :commands R
  :config
  (use-package ess-R-data-view
    :config
    (define-key ess-mode-map (kbd "C-c v") 'ess-R-dv-ctable)))
; Open *.r in R-mode
(add-to-list 'auto-mode-alist '("\\.r\\'" . R-mode))
; Expand methods window in ECB at start
(add-to-list 'ecb-non-semantic-methods-initial-expand 'R-mode)
; Make ECB default layout left3
(add-hook 'R-mode-hook (lambda ()
                         (setq ecb-layout-name "left3")))

;; Force LaTeX mode for .tex files
(add-to-list 'auto-mode-alist '("\\.tex\\'" . TeX-mode))

;; RefTeX loading
(add-hook 'TeX-mode-hook 'turn-on-reftex) ; Activar reftex con AucTeX
(setq reftex-plug-into-AUCTeX t)            ; Conectar a AUC TeX con RefTeX
(setq TeX-default-mode '"latex-mode")       ; Modo ordinario para ficheros .tex
(setq TeX-force-default-mode t)             ; Activar siempre dicho modo.

;; TeX settings
(setq TeX-parse-self t)                     ; Preview on load
(setq TeX-auto-save t)                      ; Auto Save
(setq TeX-PDF-mode t)                       ; PDF instead of div
(add-hook 'TeX-mode-hook 'flyspell-mode)    ; Enable spell-checking
(add-hook 'emacs-lisp-mode-hook 'flyspell-prog-mode)
(add-hook 'TeX-mode-hook
          (lambda () (TeX-fold-mode 1)))    ; Automatically activate TeX-fold-mode.
(add-hook 'TeX-mode-hook 'LaTeX-math-mode)

(add-to-list 'ecb-non-semantic-methods-initial-expand 'nxml-mode)
(add-hook 'nxml-mode-hook
          (lambda ()
            (set-variable
             'imenu-generic-expression
             (list
              (list
               nil
               "\\(<form id=\"\\)\\([A-Za-z0-9_]+\.\\)?\\([A-Za-z0-9\._]+\\)\\(\">\\)" 3)))
            (imenu-add-to-menubar "XML")
            (setq ecb-layout-name "FONETIC-layout")
              (add-to-list 'rng-schema-locating-files
             "~/.emacs.d/nxml-schemas/schemas.xml")))

(use-package hideshow
  :config
  (add-to-list 'hs-special-modes-alist
               '(nxml-mode
                 "<!--\\|<[^/>]*[^/]>"
                 "-->\\|</[^/>]*[^/]>"
                 "<!--"
                 sgml-skip-tag-forward
                 nil)))
(add-hook 'nxml-mode-hook 'hs-minor-mode)

(setq projectile-globally-ignored-directories
      (append '(
                ".settings"
                "grammars"
                "grammars-gsl"
                "prompts"
                )
              projectile-globally-ignored-directories))
(setq projectile-globally-ignored-files
      (append '(
                ".project"
                "*.properties"
                "*.grxml"
                "*.grammar"
                "*.wav"
                )
              projectile-globally-ignored-files))
;; Ignore trash in grep
(setq grep-find-ignored-directories
      (append '(
                ".settings"
                "grammars"
                "grammars-gsl"
                "prompts"
                )
              grep-find-ignored-directories))
(setq grep-find-ignored-files
      (append '(
                ".project"
                "*.properties"
                "*.grxml"
                "*.grammar"
                "*.wav"
                "*.aspx"
                )
              grep-find-ignored-files))

;;; VENTANA JSON
(defconst ecb-json-buffer-name " *ECB json")
(defun fonlog-parse-log-tx-result ()
  "Parsea una región con el resultado de una transacción en JSON."
  (interactive)
  (save-mark-and-excursion
   (setq inhibit-read-only t)
   (unless (use-region-p)
     (move-beginning-of-line nil)
     (search-forward "{\"result\":")
     (set-mark-command nil)
     (move-end-of-line nil)
     (backward-char))
    (let ((begin (region-beginning))
          (end (region-end))
          (jbuf (get-buffer-create ecb-json-buffer-name)))
      (copy-to-buffer jbuf begin end)
      (set-buffer jbuf)
      (json-mode-beautify)
      (font-lock-fontify-buffer))
    (setq inhibit-read-only nil)))
(defecb-window-dedicator-to-ecb-buffer ecb-set-json-buffer
    ecb-json-buffer-name nil
  "Hace del buffer actual el buffer json y lo dedica a su ventana."
  (switch-to-buffer (get-buffer-create ecb-json-buffer-name))
  (json-mode)
  (setq buffer-read-only t))
(ecb-layout-define "FONETIC-log-layout" left
  "ECB Layout para el modo FONETIC-log."
  ;; 1. Buffer de métodos
  (ecb-set-methods-buffer)
  ;; 2. Divido la barra izquierda en dos
  (ecb-split-ver 0.7)
  ;; 3. Buffer de json
  (ecb-set-json-buffer)
  ;; 4. Voy a la ventana de edición
  (select-window (next-window)))

(defvar fonlog-imenu-expressions
  '(
    ("GOTO" "\\(^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\\.[0-9][0-9][0-9] Int [0-9][0-9][0-9][0-9][0-9] [0-9a-fA-F]\\{8\\}-[0-9a-fA-F]\\{8\\} [0-9]+ \\)\\(goto :#\\)\\(.*\\)" 3)
    ("TX" "\\(^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\\.[0-9][0-9][0-9] Int [0-9][0-9][0-9][0-9][0-9] [0-9a-fA-F]\\{8\\}-[0-9a-fA-F]\\{8\\} [0-9]+ \\)\\(subdialog_start :request:\\)\\(http://[0-9.:]+/.*?/\\)\\(.*?\\)\\(|.*\\)" 4)
    )
  "Expresiones regulares para el imenu de log.")
(defun fonlog-imenu-config ()
  "Realiza la configuración inicial de imenu para el modo fonlog."
  (setq-local imenu-generic-expression fonlog-imenu-expressions)
  (imenu-add-menubar-index))
(defun fonlog-imenu-rescan ()
  "Parsea el archivo actual y actualiza imenu y el buffer de métodos de ECB."
  (interactive)
  (save-excursion
    (ecb-select-edit-window)
    (imenu--menubar-select imenu--rescan-item)
    (ecb-rebuild-methods-buffer)))

;; Paleta de colores
(defface fonlog-input-end-face
  '((t (:background "green" :foreground "black")))
  "Face para input_end MATCHED."
  :group 'fonlog)
(defface fonlog-subdialog-face
  '((t (:background "pink" :foreground "midnight blue")))
  "Face para subdialogs."
  :group 'fonlog)
(defface fonlog-codifis-face
  '((t (:background "purple" :foreground "yellow")))
  "Face para CODIFICACIONES."
  :group 'fonlog)
(defface fonlog-log-face
  '((t (:background "light slate gray" :foreground "lemon chiffon")))
  "Face para log."
  :group 'fonlog)
(defface fonlog-fetch-error-face
  '((t (:background "red" :foreground "cyan")))
  "Face para Fetch error."
  :group 'fonlog)

;; Expresiones regulares
(defvar fonlog-highlights
  '(
    ("\\(^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\\.[0-9][0-9][0-9] Int [0-9][0-9][0-9][0-9][0-9] [0-9a-fA-F]\\{8\\}-[0-9a-fA-F]\\{8\\} [0-9]+ \\)input_end MATCHED.*" . 'fonlog-input-end-face)
    ("\\(^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\\.[0-9][0-9][0-9] Int [0-9][0-9][0-9][0-9][0-9] [0-9a-fA-F]\\{8\\}-[0-9a-fA-F]\\{8\\} [0-9]+ \\)subdialog_return.*" . 'fonlog-subdialog-face)
    ("\\(^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\\.[0-9][0-9][0-9] Int [0-9][0-9][0-9][0-9][0-9] [0-9a-fA-F]\\{8\\}-[0-9a-fA-F]\\{8\\} [0-9]+ \\)log CODIFIS:.*" . 'fonlog-codifis-face)
    ("\\(^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\\.[0-9][0-9][0-9] Int [0-9][0-9][0-9][0-9][0-9] [0-9a-fA-F]\\{8\\}-[0-9a-fA-F]\\{8\\} [0-9]+ \\)log .*" . 'fonlog-log-face)
    ("\\(^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\\.[0-9][0-9][0-9] Std [0-9][0-9][0-9][0-9][0-9] EROR\\).*" . 'fonlog-fetch-error-face)
    )
  "Expresiones a subrayar para el modo log.")

(defun fonlog-font-lock-config ()
  "Realiza la configuración inicial de font-lock (subrayado) del modo fonlog."
  (setq-local font-lock-defaults '(fonlog-highlights))   ; Configuración de highlight
  (setq font-lock-keywords-only t)                 ; No subrayar strings ni comentarios
  )

(defun fonlog-config-log-buffer ()
  "Configura el buffer de log para el modo fonlog."
  ;; Optimización de lectura
  (setq-local buffer-read-only t)                     ; Modo lectura
  (setq-local make-backup-files nil)                  ; Sin backup files
  (setq-local backup-inhibited t)                     ; Inhabilita el backup

  ;; Deshabilitar autoguardado
  (auto-save-mode -1)

  ;; Configuracion autorevert
  (setq-local auto-revert-interval 2.0)
  ;(auto-revert-set-timer)
  (setq-local auto-revert-remote-files t)
  (setq-local buffer-stale-function
              #'(lambda (&optional noconfirm) 'fast))

  ;; Deshabilitar deshacer
  (buffer-disable-undo)

  (add-to-list 'ecb-non-semantic-methods-initial-expand 'fonlog-mode)
  (setq ecb-layout-name "FONETIC-log-layout")
  )

(defun fonlog-config-keys ()
  "Configura los keybindings para el modo fonlog."
  (local-set-key (kbd "C-j") 'fonlog-parse-log-tx-result)
  )

(define-derived-mode fonlog-mode auto-revert-tail-mode "fLog"
  "Modo mayor de visualización de logs de Fonetic."
  (fonlog-config-log-buffer)
  (fonlog-config-keys)
  (fonlog-imenu-config)
  (fonlog-font-lock-config)
  (font-lock-fontify-buffer)
  )
(add-to-list 'auto-mode-alist '("\\.log\\'" . fonlog-mode))

(defun my/music-keybindings ()
  "Modify keymap for mpc-mode"
  (local-set-key (kbd "C-c p") 'mpc-play-at-point))

(add-hook 'mpc-mode-hook 'my/music-keybindings)

(defun runic-write-off ()
  "Stop replacing character with runic ones"
  (interactive)
  (setq keyboard-translate-table nil)
  (global-unset-key (kbd "<f12>"))
  (message "Runic write mode disabled.")
)

(defun runic-write-on ()
  "Replace all characters with its runic equivalent"
  (interactive)
  (setq keyboard-translate-table
        (make-char-table 'keyboard-translate-table nil))

  (aset keyboard-translate-table 102 5792) ; F
  (aset keyboard-translate-table 97 5800)  ; A
  (aset keyboard-translate-table 114 5792) ; R
  (aset keyboard-translate-table 99 5810)  ; C, K, Q
  (aset keyboard-translate-table 107 5810)
  (aset keyboard-translate-table 113 5810)
  (aset keyboard-translate-table 103 5815) ; G
  (aset keyboard-translate-table 119 5817) ; W
  (aset keyboard-translate-table 104 5818) ; H
  (aset keyboard-translate-table 110 5822) ; N
  (aset keyboard-translate-table 105 5825) ; I
  (aset keyboard-translate-table 106 5827) ; J
  (aset keyboard-translate-table 112 5832) ; P
  (aset keyboard-translate-table 122 5833) ; Z
  (aset keyboard-translate-table 115 5835) ; S
  (aset keyboard-translate-table 116 5839) ; T
  (aset keyboard-translate-table 98 5842)  ; B
  (aset keyboard-translate-table 101 5846) ; E
  (aset keyboard-translate-table 109 5847) ; M
  (aset keyboard-translate-table 108 5850) ; L
  (aset keyboard-translate-table 111 5855) ; O
  (aset keyboard-translate-table 100 5854) ; D

  (global-set-key (kbd "<f12>") 'runic-write-off)

  (message "Runic write mode enabled. Press <f12> to exit.")
)

(use-package clipmon
  :init (progn (setq clipmon-action 'kill-new clipmon-timeout nil clipmon-sound nil clipmon-cursor-color nil clipmon-suffix nil) (clipmon-mode)))

(when (eq system-type 'windows-nt)
  ; FIX for keybindings
  (setq w32-pass-lwindow-to-system nil
        w32-lwindow-modifier 'super            ; Left Windows key
        w32-pass-rwindow-to-system nil
        w32-rwindow-modifier 'super            ; Right Windows key
        w32-pass-apps-to-system nil
        w32-apps-modifier 'hyper               ; Menu/App key
  ; FIX for aspell
        ispell-program-name "aspell"
        ispell-list-command "--list"
        ispell-personal-dictionary "~/.ispell"
  ; FIX for find
        find-program "C:\\cygwin64\\bin\\find.exe"
        gc-cons-threshold (* 100 1024 1024)   ; 100 mb
  ; FIX PATH
        exec-path (append '("C:\\cygwin64\\bin") exec-path))
  (setenv "PATH" (concat "C:\\cygwin64\\bin;" (getenv "PATH")))
  ; FIX for TRAMP
  (set-default 'tramp-auto-save-directory "~/AppData/Local/Temp")
  (set-default 'tramp-default-method "plink")
   ; Fix TLS
  (set-default 'gnutls-trustfiles (cons
                                   "C:/cygwin64/usr/ssl/certs/ca-bundle.trust.crt"
                                   "C:/cygwin64/usr/ssl/certs/ca-bundle.crt")))


