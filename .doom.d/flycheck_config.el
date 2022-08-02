;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Mateus da Silva Sousa"
      user-mail-address "mateus.sousa@teknisa.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
(setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 12 :weight 'normal))
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
(load-theme 'dracula t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;; (use-package! lsp-volar
;; :config
;;  (setq auto-rename-tag-mode t)
;; )
(use-package! tree-sitter
   :hook (prog-mode . turn-on-tree-sitter-mode)
   :hook (tree-sitter-after-on . tree-sitter-hl-mode)
   :config
   (require 'tree-sitter-langs)
   ;; This makes every node a link to a section of code
   (setq tree-sitter-debug-jump-buttons t
         ;; and this highlights the entire sub tree in your code
         tree-sitter-debug-highlight-jump-region t

         auto-rename-tag-mode t
         )
   )

(global-tree-sitter-mode)

(use-package! typescript-mode
  :after tree-sitter lsp-mode
  :hook (typescript-mode . lsp-deferred)
  :config
  (add-hook 'typescript-mode-hook #'rainbow-delimiters-mode)
  (with-eval-after-load 'flycheck
    (flycheck-add-mode 'javascript-eslint 'typescript-mode))
  ;; (setq-default flycheck-disabled-checkers
  ;;       (append flycheck-disabled-checkers
  ;;               '(javascript-jshint)))
  ;; (flycheck-add-mode 'javascript-eslint 'web-mode)
  ;; (setq-default flycheck-disabled-checkers
  ;;       (append flycheck-disabled-checkers
  ;;               '(json-jsonlist)))
  (defun my/use-eslint-from-node-modules ()
    (let* ((root (locate-dominating-file
                  (or (buffer-file-name) default-directory)
                  "node_modules"))
           (eslint (and root
                        (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
  (add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
;;  :config
;;
;;  (defun setup-tide-mode ()
;;    (interactive)
;;    (tide-setup)
;;    (flycheck-mode +1)
;;    (setq flycheck-check-syntax-automatically '(save mode-enabled))
;;    (eldoc-mode +1)
;;    (tide-hl-identifier-mode +1)
    ;; company is an optional dependency. You have to
    ;; install it separately via package-install
    ;; `M-x package-install [ret] company`
;;    (company-mode +1))

  ;; aligns annotation to the right hand side
;;  (setq company-tooltip-align-annotations t)

  ;; formats the buffer before saving
  ;; (add-hook 'before-save-hook 'tide-format-before-save)

;;  (add-hook 'typescript-mode-hook #'setup-tide-mode)
)

(use-package! lsp-mode
  :commands lsp lsp-deferred
)

;; for completions

;(use-package! vue-mode
;  :mode "\\.vue\\'"
;  :config
;  (add-hook 'vue-mode-hook #'lsp))
(use-package! web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.vue?\\'" . web-mode))
;;  (add-to-list 'auto-mode-alist '("\\.ts\\'" . web-mode))
  (add-hook! 'web-mode-hook #'lsp)
  (add-hook! 'web-mode-hook 'flycheck-mode)
  (add-hook! 'web-mode-hook #'rainbow-delimiters-mode)
  (setq auto-rename-tag-mode t)
  (with-eval-after-load 'flycheck
    (flycheck-add-mode 'javascript-eslint 'web-mode))
  )
;;(use-package! company
;;  :ensure t
;;  :config
;;        (global-company-mode t)
;;        (setq company-minimum-prefix-length 1
;;              company-idle-delay 0.0)
;;)

(setq projectile-project-search-path '("~/Projects/Teknisa"))
;; (use-package! apheleia
;;   :config
;;   (setf (alist-get 'prettier apheleia-formatters)
;;         '(npx "prettier" file))
;;   (add-to-list 'apheleia-mode-alist '(typescript-mode .  prettier))
;;   (add-to-list 'apheleia-mode-alist '(web-mode . prettier))
;;   (apheleia-global-mode t))
