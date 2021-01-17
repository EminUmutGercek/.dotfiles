(setq-default
  delete-by-moving-to-trash t
  tab-width 4
  uniquify-buffer-name-style 'forward
  window-combination-resize t
  x-stretch-cursor t)

(setq undo-limit 80000000
  evil-want-fine-undo t
  auto-save-default t
  inhibit-compacting-font-caches t
  truncate-string-ellipsis "…"
  display-line-numbers-type 'relative)
;(global-subword-mode 1)

(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))

(when (file-exists-p custom-file)
  (load custom-file))

(setq writeroom-fullscreen-effect t)

(toggle-frame-fullscreen)

(setq doom-font (font-spec :family "SauceCodePro Nerd Font" :size 17)
      doom-variable-pitch-font (font-spec :family "SauceCodePro Nerd Font" :size 15)
      doom-big-font (font-spec :family "SauceCodePro Nerd Font" :size 24)
)

(setq user-full-name "Umut Gercek"
      user-mail-address "umutgercek1999@gmail.com")

(setq confirm-kill-emacs nil)
(unless (display-graphic-p)
  (require 'evil-terminal-cursor-changer)
  (evil-terminal-cursor-changer-activate) ; or (etcc-on)
  )

(defun my/light-theme ()
  "Light theme configurations"
  (progn
    (setq doom-theme 'doom-one-light)
    (use-package! doom-themes
      :custom-face
      (region ((nil :background "#aaaaaa")))

      :config
      (load-theme 'doom-one-light t)
      )
    ))

(defun my/dark-theme ()
  "Dark theme configurations"
  (progn
    (setq doom-theme 'doom-solarized-dark)
    (use-package! doom-themes
      :custom-face
      (region ((nil :background "#0b4f61")))
      :config
      (setq doom-solarized-dark-brighter-text t)
      (load-theme 'doom-solarized-dark t)
      )
    )
  )

(setq my/current-time (string-to-number (format-time-string "%H")))
(if
    (and
     (< 7 my/current-time)
     (< my/current-time 17 ))
    (my/light-theme)
  (my/dark-theme)
  )

(setq doom-scratch-buffer-major-mode t)

(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(remove-hook '+doom-dashboard-functions 'doom-dashboard-widget-footer)
(remove-hook '+doom-dashboard-functions 'doom-dashboard-widget-loaded)

(setq fancy-splash-image "~/.doom.d/GnuLove.png")

     (define-key evil-normal-state-map (kbd "C-c =") 'evil-numbers/inc-at-pt)
     (define-key evil-normal-state-map (kbd "C-c -") 'evil-numbers/dec-at-pt)

     (setq +evil-want-o/O-to-continue-comments nil)

     (after! evil-snipe
             (setq evil-snipe-scope 'visible)
             (setq evil-snipe-repeat-scope 'buffer)
             (setq evil-snipe-spillover-scope 'whole-buffer))

(map!
  (:after dired
    (:map dired-mode-map
      :n "RET" 'dired-find-alternate-file ;;Open in same bufer
          "-"   'find-alternate-file)
          "C-x i" #'peep-dired
     ))
(evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file
                                             (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(setq org-clock-persist t)
(org-clock-persistence-insinuate)
(setq org-clock-persist-query-resume nil)
(setq org-hide-emphasis-markers t)

(setq org-directory "~/Dropbox/Org")
(after! org
  (setq org-directory "~/Dropbox/Org"))

;;(setq +org:reading-list-file (+org/expand-org-file-name "gtd/read-list.org"))
;;(setq +org:bookmarks-file (+org/expand-org-file-name "gtd/bookmarks.org"))

(after! org
  (setq org-src-window-setup 'current-window))

(after! org-mode
  (unmap! '(motion) "C-h")
  )

(setq org-directory "~/Dropbox/org")

;; (use-package evil
;;   :custom
;;   evil-disable-insert-state-bindings t
;;   )
(setq org-emphasis-alist
      '(("/" italic)
        ("_" underline)
        ("=" org-verbatim verbatim)
        ("~" org-code verbatim)
        ("+"
         (:strike-through t))))

;;Agenda
(setq org-agenda-files (directory-files-recursively "~/Dropbox/org/gtd/" "\\.org$"))

(use-package! org-super-agenda
  :commands (org-super-agenda-mode))
(after! org-agenda
  (org-super-agenda-mode))

(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil org-agenda-tags-column 100)
(setq org-agenda-custom-commands
      '(("o" "Overview"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '((:name "Today"
                          :time-grid t
                          :date today
                          :todo "TODAY"
                          :scheduled today
                          :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next to do"
                           :todo "NEXT"
                           :order 1)
                          (:name "Important"
                           :tag "Important"
                           :priority "A"
                           :order 6)
                          (:name "Due Today"
                           :deadline today
                           :order 2)
                          (:name "Due Soon"
                           :deadline future
                           :order 8)
                          (:name "Overdue"
                           :deadline past
                           :face error
                           :order 7)
                          (:name "Assignments"
                           :tag "Assignment"
                           :order 10)
                          (:name "Issues"
                           :tag "Issue"
                           :order 12)
                          (:name "Emacs"
                           :tag "Emacs"
                           :order 13)
                          (:name "Projects"
                           :tag "Project"
                           :order 14)
                          (:name "Research"
                           :tag "Research"
                           :order 15)
                          (:name "To read"
                           :tag "Read"
                           :order 30)
                          (:name "Waiting"
                           :todo "WAITING"
                           :order 20)
                          (:name "University"
                           :tag "uni"
                           :order 32)
                          (:name "Trivial"
                           :priority<= "E"
                           :tag ("Trivial" "Unimportant")
                           :todo ("SOMEDAY" )
                           :order 90)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))

(setq org-capture-templates '(("t" "Todo")
                              ("tn" "No time" entry
                               (file+headline "~/Dropbox/org/gtd/inbox.org" "Tasks")
                               "* TODO %^{Description} %^g\n  %?")
                              ("tt" "With time" entry
                               (file+headline "~/Dropbox/org/gtd/agenda.org" "Tasks")
                               "* TODO %^{Description} %^g\n \%^t\n  %?")
                              ("T" "Tickler" entry
                               (file+headline "~/Dropbox/org/gtd/tickler.org" "Tickler")
                               "* %i%? \n %U")
                              ("n" "Simple Notes" entry
                               (file+headline "~/Dropbox/org/gtd/inbox.org" "Notes")
                               "* %^{Description} %^g\n  %?")
                              ("j" "Journal" entry
                               (file+datetree "~/Dropbox/org/gtd/journal.org")
                               "* %U %?" :clock-in t :clock-keep t)
                              ("r" "Resource")
                              ("ri" "Internet" entry
                               (file+olp "~/Dropbox/org/gtd/inbox.org" "Resources" "Internet")
                               "* [[%c][%^{Name of link}]] %^g\n%U\n" :immediate-finish t)))

(defun zz/org-download-paste-clipboard (&optional use-default-filename)
  (interactive "P")
  (require 'org-download)
  (let ((file
         (if (not use-default-filename)
             (read-string (format "Filename [%s]: " org-download-screenshot-basename)
                          nil nil org-download-screenshot-basename)
           nil)))
    (org-download-clipboard file)))

(after! org
  (setq org-download-method 'directory)
  (setq org-download-image-dir "~/Documents/Assets/Download")
  (setq org-download-heading-lvl nil)
  (setq org-download-timestamp "%Y%m%d-%H%M%S_")
  (setq org-image-actual-width 750)
  (map! :map org-mode-map
        "C-c l a y" #'zz/org-download-paste-clipboard
        "C-M-y" #'zz/org-download-paste-clipboard))

(setq
 ;; org-superstar-headline-bullets-list '("⁖" "*" "†" "✸" "✿")
 org-superstar-headline-bullets-list '("*")
 )

(map! :leader
      :desc "Go to notes directory"
      "a n" 'my/notes-counsel-find-file
      )

(defun my/notes-counsel-find-file ()
  "Foobar"
  (interactive)
  (counsel-find-file "/home/umut/Dropbox/org/Notes"))

(defun my/gtd-counsel-find-file ()
  "Foobar"
  (interactive)
  (counsel-find-file "/home/umut/Dropbox/org/gtd"))

(map! :leader
      :desc "Go to notes directory"
      "a g" 'my/gtd-counsel-find-file
      )

(defun my/src-counsel-find-file ()
  "Foobar"
  (interactive)
  (counsel-find-file "/home/umut/src/"))

(map! :leader
      :desc "Go to notes directory"
      "a s" 'my/src-counsel-find-file
      )

(defun my/curly-quoation-to-normal-quoation()
  "Change any curly quotation mark to normal quoation mark"
  (interactive)
  (goto-char (point-min))
  (while (search-forward "‘" nil t)
    (replace-match "'"))
  (goto-char (point-min))
  (while (search-forward "’" nil t)
    (replace-match "'"))

  (goto-char (point-min))
  (while (search-forward "“" nil t)
    (replace-match "\""))

  (goto-char (point-min))
  (while (search-forward "”" nil t)
    (replace-match "\""))
  )

(defun my/error-line ()
  "Create an error message in C++"
  (interactive)
  (move-beginning-of-line nil)
  (insert "std::cout << \"Error:\" << __LINE__ << std::endl;")
  )

(map! :leader
      :desc "Create an error message in C++"
      "d e" 'my/error-line
      )

(defun my/open-folder ()
  "Opens a folder with xdg-open"
  (interactive)
  (shell-command "xdg-open ."))

(defun xah-open-file-at-cursor ()
  "Open the file path under cursor.
If there is text selection, uses the text selection for path.
If the path starts with “http://”, open the URL in browser.
Input path can be {relative, full path, URL}.
Path may have a trailing “:‹n›” that indicates line number. If so, jump to that line number.
If path does not have a file extension, automatically try with “.el” for elisp files.
This command is similar to `find-file-at-point' but without prompting for confirmation.

URL `http://ergoemacs.org/emacs/emacs_open_file_path_fast.html'
Version 2019-01-16"
  (interactive)
  (let* (($inputStr (if (use-region-p)
                        (buffer-substring-no-properties (region-beginning) (region-end))
                      (let ($p0 $p1 $p2
                                ;; chars that are likely to be delimiters of file path or url, e.g. whitespace, comma. The colon is a problem. cuz it's in url, but not in file name. Don't want to use just space as delimiter because path or url are often in brackets or quotes as in markdown or html
                                ($pathStops "^  \t\n\"`'‘’“”|[]{}「」<>〔〕〈〉《》【】〖〗«»‹›❮❯❬❭〘〙·。\\"))
                        (setq $p0 (point))
                        (skip-chars-backward $pathStops)
                        (setq $p1 (point))
                        (goto-char $p0)
                        (skip-chars-forward $pathStops)
                        (setq $p2 (point))
                        (goto-char $p0)
                        (buffer-substring-no-properties $p1 $p2))))
         ($path
          (replace-regexp-in-string
           "^file:///" "/"
           (replace-regexp-in-string
            ":\\'" "" $inputStr))))
    (if (string-match-p "\\`https?://" $path)
        (if (fboundp 'xahsite-url-to-filepath)
            (let (($x (xahsite-url-to-filepath $path)))
              (if (string-match "^http" $x )
                  (browse-url $x)
                (find-file $x)))
          (progn (browse-url $path)))
      (if ; not starting “http://”
          (string-match "^\\`\\(.+?\\):\\([0-9]+\\)\\'" $path)
          (let (
                ($fpath (match-string 1 $path))
                ($line-num (string-to-number (match-string 2 $path))))
            (if (file-exists-p $fpath)
                (progn
                  (find-file $fpath)
                  (goto-char 1)
                  (forward-line (1- $line-num)))
              (when (y-or-n-p (format "file no exist: 「%s」. Create?" $fpath))
                (find-file $fpath))))
        (if (file-exists-p $path)
            (progn ; open f.ts instead of f.js
              (let (($ext (file-name-extension $path))
                    ($fnamecore (file-name-sans-extension $path)))
                (if (and (string-equal $ext "js")
                         (file-exists-p (concat $fnamecore ".ts")))
                    (find-file (concat $fnamecore ".ts"))
                  (find-file $path))))
          (if (file-exists-p (concat $path ".el"))
              (find-file (concat $path ".el"))
            (when (y-or-n-p (format "file no exist: 「%s」. Create?" $path))
              (find-file $path ))))))))

(map! :leader
      :desc "Translate word"
      "d f" 'xah-open-file-at-cursor
      )



(setq geiser-mit-binary "/usr/bin/scheme")
(setq geiser-active-implementations '(mit))
(setq geiser-scheme-implementation 'mit)
(setq scheme-program-name "/usr/local/bin/mit-scheme")
(setq geiser-scheme-implementation 'mit)
(setq geiser-default-implementation 'mit)

(defun my-compile-run ()
  (interactive)
  (save-buffer)
  (if (get-buffer "vterm")
      (setq cur-term "vterm")
    (setq cur-term "*doom:vterm-popup:main*")
    )
  (comint-send-string cur-term
                      (concat "clear"
                              "\n"
                              "g++ *.cpp"
                              ";"
                              "./a.out"
                              "\n")))

(defun my-compile-run-with-test ()
  (interactive)
  (save-buffer)
  (if (get-buffer "vterm")
      (setq cur-term "vterm")
    (setq cur-term "*doom:vterm-popup:main*")
    )
  (comint-send-string cur-term (concat "clear"
                                       "\n"
                                       "g++ "
                                       (buffer-name)
                                       ";"
                                       "./a.out"
                                       "<test"
                                       "\n")))

(map! :leader
      :desc "Compile and Run in vterm buffer"
      "d c"  'my-compile-run
      "d t"  'my-compile-run-with-test
      )

(after! company
  (setq company-idle-delay 0.35)
  (setq company-minimum-prefix-length 1)
  (setq company-selection-wrap-around t)
  (setq company-show-numbers t)
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  )
(set-company-backend! '(c-mode c++-mode objc-mode) '(company-lsp company-yasnippet))
                                        ;(after! company-box
                                        ;     (setq company-box-backends-colors
                                        ;           '((company-yasnippet . (:all "lime green" :selected (:background "lime green" :foreground "black"))))
                                        ;           ))

(use-package zeal-at-point)
(map! :leader
      :desc "Zeal Look Up"
      "d z" #'zeal-at-point
      )

(use-package rainbow-mode)

(use-package! framemove
  :config
  (setq framemove-hook-into-windmove t))

(use-package turkish)
(map! :leader
      :desc "Turkish last word"
      "d t" 'turkish-correct-last-word
      )

(use-package command-log-mode)

(eval-after-load "artist"
  '(define-key artist-mode-map [(down-mouse-3)] 'artist-mouse-choose-operation)
  )

(add-hook! 'rainbow-mode-hook
  (hl-line-mode (if rainbow-mode -1 +1)))

(add-hook 'pdf-tools-enabled-hook 'pdf-view-midnight-minor-mode) ;Dark mode

(setq +latex-viewers '(pdf-tools))

(push '("\\.pdf\\'" . emacs) org-file-apps)

(use-package! nov
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (setq nov-save-place-file (concat doom-cache-dir "nov-places")))
