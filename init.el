
(package-initialize)
(setq package-enable-at-startup nil)
(setq custom-file "~/.emacs.d/custom-settings.el")
(load custom-file t)
(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (package-refresh-contents)
)
(setq inhibit-startup-screen t)

(setq user-full-name "Ares Aguilar"
      user-mail-address "aresaguilarsotos@gmail.com")

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))

(use-package helm
  :diminish helm-mode
  :init
  (progn
    (require 'helm-config)
    (require 'helm)
    (global-set-key (kbd "C-c h") 'helm-command-prefix)
    (global-unset-key (kbd "C-x c"))
    (setq helm-candidate-number-limit 100)
    (setq helm-idle-delay 0.0
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

(load-theme 'monokai t)

(prefer-coding-system 'utf-8)
(when (display-graphic-p)
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
    (if mark-active (list (region-beginning) (region-end))
      (list (line-beginning-position)
        (line-beginning-position 2)))))

(use-package expand-region
  :defer t
  :bind ("C-=" . er/expand-region))

(windmove-default-keybindings)

(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)



(use-package smartscan
  :defer t
  :config (global-smartscan-mode t))

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
(setq org-default-notes-file "~/ORG/notas.org")

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
 )

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

(setq-default tab-width 4)

(electric-pair-mode 1)
(show-paren-mode 1)
(setq show-paren-delay 0)

(column-number-mode 1)

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
    (setq projectile-keymap-prefix (kbd "C-c p"))
    (setq projectile-completion-system 'default)
    (setq projectile-enable-caching t)
    (setq projectile-indexing-method 'alien)
    (add-to-list 'projectile-globally-ignored-files "node-modules"))
  :config
  (projectile-global-mode))
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
(setq-default tab-width 4 indent-tabs-mode nil)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)

(use-package ess-site
  :commands R)

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

(defun my/music-keybindings ()
  "Modify keymap for mpc-mode"
  (local-set-key (kbd "C-c p") 'mpc-play-at-point))

(add-hook 'mpc-mode-hook 'my/music-keybindings)

(use-package clipmon
  :init (progn (setq clipmon-action 'kill-new clipmon-timeout nil clipmon-sound nil clipmon-cursor-color nil clipmon-suffix nil) (clipmon-mode)))


