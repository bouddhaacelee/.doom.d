;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Fabien"
      user-mail-address "john@doe.com")

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
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Groot")
(setq org-agenda-include-diary t)
(setq org-roam-directory "~/Groot/Notes")
(setq org-default-notes-file (concat org-directory "/inbox.org"))


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(custom-set-variables
     '(initial-frame-alist (quote ((fullscreen . maximized)))))

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(set-face-attribute 'default nil :font "Fira Code" :height 120 :weight 'light)
;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; TODO put in place a mechanism to save agenda file between session of emacs
;; the file contains only project files, which are added manually
;; Groot Agenda is added here and the daily too
;; define a strategy to select the correct dailies. A good one could be from today to one month later
;; ALGO
;; Get current date
;; (format-time-string "%Y-%m-%d.org")

(require 'org)
(after! org
  (setq org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●"))

  (defun fabien/pomodoro-start-work ()
    (interactive)
    (org-timer-set-timer "20:00"))

  (defun fabien/pomodoro-start-rest ()
    (interactive)
    (org-timer-set-timer "5:00"))

  (defun fabien/pomodoro-pause-continue ()
    (interactive)
    (org-timer-pause-or-continue))

  ;;(defun fabien/search-dailes ()
  ;;  (interactive)
  ;;  (setq start-date (- (time-to-days (current-time)) 7))
  ;;  (setq end-date (+ (time-to-days (current-time)) 30))

  ;;  (setq days-period (list ))
  ;;  (while (<= start-date end-date)
  ;;    (push '(format-time-string "%Y-%m-%d.org" (days-to-time start-date)) days-period)
  ;;    (setq start-date (1+ start-date))
  ;;    )
  ;;  (message days-period)
  ;; )
  )

(setq org-roam-v2-ack t)
(setq org-roam-dailies-directory "dailies")

(require 'org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(after! org-roam
  (defun fabien/org-roam-capture-inbox ()
  (interactive)
  (org-roam-capture- :node (org-roam-node-create)
                     :templates '(("i" "inbox" plain "* %?"
                                  :if-new (file+head "Inbox.org" "#+title: Inbox\n")))))

  (defun fabien/update-agenda-files-with-dailies ()
    (interactive)
    ;;remove daily from agenda files
    (setq org-agenda-files (cl-remove-if (lambda (k) (string-match (concat ".*" org-roam-dailies-directory ".*") k)) org-agenda-files))
    (setq dailies_counter 0)
    (while (< dailies_counter 30)
      (setq daily_path
          (format-time-string
           (concat org-roam-directory "/" org-roam-dailies-directory "/%Y-%m-%d.org")
           (time-add (* dailies_counter 86400)
                     (current-time)
                     )
           )
          )
      (cond  ((file-exists-p daily_path) (push daily_path org-agenda-files)))
      (setq dailies_counter (+ dailies_counter 1))
    )
    )
  (fabien/update-agenda-files-with-dailies)
  )
