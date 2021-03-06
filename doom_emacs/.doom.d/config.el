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
      truncate-string-ellipsis "…")

(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))
(when (file-exists-p custom-file)
  (load custom-file))

(toggle-frame-fullscreen)

(defun my/day-additonals ()
  (custom-set-faces!
    '(region     :background "#f5f5ff")
    '(org-block-begin-line :background "#fafaf8")
    '(org-block-end-line   :background "#fafaf8")))

(defun my/night-additonals ()
  (interactive )
  (progn
    (custom-set-faces!
      '(region     :background "#094A5A")
      '(org-block-begin-line :background "#002b3a")
      '(org-block-end-line   :background "#002b3a"))

    (setq doom-solarized-dark-brighter-text t
          doom-solarized-dark-brighter-comments t
          doom-themes-enable-bold t)))

(setq my/current-time (string-to-number (format-time-string "%H")))

(defun my/day-or-night ()
  (if
      (and
       (< 5 my/current-time)
       (< my/current-time 20))
      'day
    'night))

(setq doom-theme (if (eq (my/day-or-night) 'day)
                     'doom-one-light
                   'doom-solarized-dark))

(if (eq (my/day-or-night) 'day)
    (my/day-additonals)
    (my/night-additonals))

;; (setq doom-font (font-spec :family "SauceCodePro Nerd Font" :size 17))
(setq doom-font (font-spec :family "SauceCodePro NF" :size 17)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 24))
;; doom-big-font (font-spec :family "Ubuntu" :size 24)
;; doom-serif-font (font-spec :family "Noto Serif SC" :size 24)
;; doom-variable-pitch-font (font-spec :family "Ubuntu" :size 17))

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(setq user-full-name "Emin Umut Gerçek"
      user-mail-address "umutgercek1999@gmail.com")

(setq confirm-kill-emacs nil)

(setq doom-scratch-buffer-major-mode t)

(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(remove-hook '+doom-dashboard-functions 'doom-dashboard-widget-footer)
(remove-hook '+doom-dashboard-functions 'doom-dashboard-widget-loaded)

(setq fancy-splash-image "~/.doom.d/GnuLove.png")

(setq org-directory "~/Dropbox/Org")

(after! org
  (setq org-src-window-setup 'split-window-right))

(org-autolist-mode 1)

(setq org-log-done 'time)

(remove-hook! '(org-mode-hook text-mode-hook)
              #'display-line-numbers-mode)

(setq org-clock-persist t)
(org-clock-persistence-insinuate)
(setq org-clock-persist-query-resume nil)

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

                              ("j" "Journal" entry
                               (file+datetree "~/Dropbox/org/gtd/journal.org")
                               "* %U %?" :clock-in t :clock-keep t)

                              ("l" "Log")

                              ("ls" "Log SICP daily" entry
                               (file+olp+datetree "~/Dropbox/org/gtd/sicp.org" "Log")
                               "* %<%H:%M>\n%^{minute}p%^{page}p%^{current-page}p%?" :jump-to-captured t :immediate-finish t)

                              ("lu" "Log UNIX daily" entry
                               (file+olp+datetree "~/Dropbox/org/gtd/log.org" "UNIX")
                               "* %<%H:%M> %^{Topic}\n%^{minute|60}p" :immediate-finish t)

                              ("r" "Resource")

                              ("ri" "Internet" entry
                               (file+olp "~/Dropbox/org/gtd/inbox.org" "Resources" "Internet")
                               "* [[%c][%^{Name of link}]] %^g\n%U\n")))

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

(map! :leader
      :desc "Insert image from clipboard to org"
      "e p" 'zz/org-download-paste-clipboard)

(setq org-pretty-entities t)

;; (setq org-use-sub-superscripts '{})
(setq org-use-sub-superscripts nil)

(setq org-hide-emphasis-markers t)

(setq org-emphasis-alist
      '(("*" bold)
        ("/" italic)
        ("_" underline)
        ("=" org-verbatim verbatim)
        ("~" org-code verbatim)))
;; ("+" (:strike-through t))))

(use-package! org-appear
  :hook (org-mode . org-appear-mode))

(defun org-pretty-symbols-mode ()
  ;; (push '("[ ]" .  "☐") prettify-symbols-alist)
  ;; (push '("[X]" . "☑" ) prettify-symbols-alist)

  (push '("#+begin_src"      . "λ") prettify-symbols-alist)
  (push '("#+end_src"        . "・") prettify-symbols-alist)
  (push '("#+results:"       . "»") prettify-symbols-alist)
  (push '(":end:"            . "⋱") prettify-symbols-alist)
  (push '(":results:"        . "⋰") prettify-symbols-alist)
  (push '("#+begin_verbatim" . "∬") prettify-symbols-alist)
  (push '("#+end_verbatim"   . "∯") prettify-symbols-alist)
  (push '("#+begin_verse"    . "∭") prettify-symbols-alist)
  (push '("#+end_verse"      . "∰") prettify-symbols-alist)
  (push '("#+begin_quote"    . "") prettify-symbols-alist)
  (push '("#+end_quote"      . "") prettify-symbols-alist)
  ;;               Capital
  (push '("#+BEGIN_SRC"      . "λ") prettify-symbols-alist)
  (push '("#+END_SRC"        . "⋱") prettify-symbols-alist)
  (push '("#+END_SRC"        . "・") prettify-symbols-alist)
  (push '("#+RESULTS:"       . "»") prettify-symbols-alist)
  (push '(":END:"            . "⋱") prettify-symbols-alist)
  (push '(":RESULTS:"        . "⋰") prettify-symbols-alist)
  (push '("#+BEGIN_VERBATIM" . "∬") prettify-symbols-alist)
  (push '("#+END_VERBATIM"   . "∯") prettify-symbols-alist)
  (push '("#+BEGIN_VERSE"    . "∭") prettify-symbols-alist)
  (push '("#+END_VERSE"      . "∰") prettify-symbols-alist)
  (push '("#+BEGIN_QUOTE"    . "") prettify-symbols-alist)
  (push '("#+END_QUOTE"      . "") prettify-symbols-alist)
  (prettify-symbols-mode t))

(add-hook 'org-mode-hook (lambda () (org-pretty-symbols-mode)))

(map! :leader
      :desc "org-ctrl-c-star copy"
      "8" 'org-ctrl-c-star)

(setq org-format-latex-options (plist-put org-format-latex-options :scale 3.0))

(use-package! org-fragtog)
;; :hook (org-mode . org-fragtog-mode))

(setq org-latex-listings 'minted)
(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq org-export-with-sub-superscripts '{})

(setq org-export-headline-levels 6)

(defun my/insert-picture-order()
  "Insert order of picture"
  (interactive)
  (setq current-cursor (point))
  (setq x 0)
  (while (re-search-forward "file:Pictures" nil t -1)
    (setq x (+ x 1)))
  (setq x (- x 1))
  (goto-char current-cursor)
  x)

(defun my/include-file-lines-org-mode (file-name src-lang begin end)
  "Insert file's lines as source block ing org mode"
  (setq real-end (+ end 1))
  (setq line-string (format "%d-%d" begin real-end))
  (format "#+include: %s :lines %s :src %s" file-name line-string src-lang ))
(my/include-file-lines-org-mode "./New.cpp" "C++" 5 10)

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

(defun my/documents-counsel-find-file ()
  "Foobar"
  (interactive)
  (counsel-find-file "/home/umut/Document/"))

(map! :leader
      :desc "Go to documents directory"
      "a d" 'my/documents-counsel-find-file
      )

(defun my/curly-quoation-to-normal-quoation()
  "Change any curly quotation mark to normal quoation mark"
  (interactive)
  (goto-char (point-min))
  (while (search-forward "'" nil t)
    (replace-match "'"))
  (goto-char (point-min))
  (while (search-forward "'" nil t)
    (replace-match "'"))

  (goto-char (point-min))
  (while (search-forward """ nil t)
    (replace-match "\""))

  (goto-char (point-min))
  (while (search-forward """ nil t)
    (replace-match "\""))
  )

(defun my/error-line ()
  "Create an error message in C++"
  (interactive)
  (move-beginning-of-line nil)
  (insert "std::cout << \"Error:\" << __LINE__ << std::endl;"))

(map! :leader
      :desc "Create an error message in C++"
      "d e" 'my/error-line)

(defun my/open-directory ()
  "Opens a folder with xdg-open"
  (interactive)
  (shell-command "xdg-open ."))

(defun my/org-table-color-y-n (start end)
  "Make =y= s green and n s red with =y= and ~n~"
  (interactive "r")
  (replace-regexp " y " " =y= " nil start end)
  (replace-regexp " n " " ~n~ " nil start end))

(defun my/just-one-space-in-region (beg end)
  "replace all whitespace in the region with single spaces"
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (while (re-search-forward "\\s-+" nil t)
        (replace-match " ")))))

(map! :leader
      :desc "Go to documents directory"
      "j s" 'my/my/just-one-space-in-region)

(defun my/*2 ()
  (interactive)
  (skip-chars-backward "0-9")
  (or (looking-at "[0-9]+")
      (error "No number at point"))
  (replace-match (number-to-string (* (string-to-number (match-string 0) 2)))))

(defun my//2 ()
  (interactive)
  (skip-chars-backward "0-9")
  (or (looking-at "[0-9]+")
      (error "No number at point"))
  (replace-match (number-to-string (/ (string-to-number (match-string 0)) 2))))

(defun my/info->org-heading()
  "Simple workflow for reading info in emasc while taking notes on
  org-mode"
  (interactive)
  (fm-right-frame)
  (goto-char (point-max))
  (insert (substring-no-properties (car kill-ring)))
  (forward-line -1)
  (kill-whole-line)
  (forward-line -1)
  (org-ctrl-c-star)
  (fm-left-frame))


(map! :leader
      "j o" 'my/info->org-heading)

(defun my/info->org-text(beginning end)
  "Simple workflow for reading info in emasc while taking notes on
  org-mode"
  (interactive "r")
  (fm-right-frame)
  (goto-char (point-max))
  (insert (substring-no-properties (car kill-ring)))
  (insert "\n")
  (fm-left-frame))

(map! :leader
      "j f" 'my/info->org-text)

(defun my/send-src-block-to-vterm ()
  "Send source code's (currently on) content to vterm.
It won't looks more than one vterm, close other ones."
  (interactive)
  (save-buffer)
  (let
      ((cur-term (if (get-buffer "vterm")
                     "vterm"
                   "*doom:vterm-popup:main*"))
       (content  (org-element-property :value (org-element-at-point))))
    (comint-send-string cur-term
                        content)))

(map! :map org-mode-map
      :leader
      "e s" 'my/send-src-block-to-vterm)

(defun xah-title-case-region-or-line (@begin @end)
  "Title case text between nearest brackets, or current line, or text selection.
Capitalize first letter of each word, except words like {to, of, the, a, in, or, and, …}. If a word already contains cap letters such as HTTP, URL, they are left as is.

When called in a elisp program, *begin *end are region boundaries.
URL `http://ergoemacs.org/emacs/elisp_title_case_text.html'
Version 2017-01-11"
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (let (
           $p1
           $p2
           ($skipChars "^\"<>(){}[]""''‹›«»「」『』【】〖〗《》〈〉〔〕"))
       (progn
         (skip-chars-backward $skipChars (line-beginning-position))
         (setq $p1 (point))
         (skip-chars-forward $skipChars (line-end-position))
         (setq $p2 (point)))
       (list $p1 $p2))))
  (let* (
         ($strPairs [
                     [" A " " a "]
                     [" And " " and "]
                     [" At " " at "]
                     [" As " " as "]
                     [" By " " by "]
                     [" Be " " be "]
                     [" Into " " into "]
                     [" In " " in "]
                     [" Is " " is "]
                     [" It " " it "]
                     [" For " " for "]
                     [" Of " " of "]
                     [" Or " " or "]
                     [" On " " on "]
                     [" Via " " via "]
                     [" The " " the "]
                     [" That " " that "]
                     [" To " " to "]
                     [" Vs " " vs "]
                     [" With " " with "]
                     [" From " " from "]
                     ["'S " "'s "]
                     ["'T " "'t "]
                     ]))
    (save-excursion
      (save-restriction
        (narrow-to-region @begin @end)
        (upcase-initials-region (point-min) (point-max))
        (let ((case-fold-search nil))
          (mapc
           (lambda ($x)
             (goto-char (point-min))
             (while
                 (search-forward (aref $x 0) nil t)
               (replace-match (aref $x 1) "FIXEDCASE" "LITERAL")))
           $strPairs))))))

(map! :leader
      "j t"  'xah-title-case-region-or-line)

(setq org-babel-default-header-args:C++ '((:includes . "<bits/stdc++.h>")
                                          (:flags . "-std=c++20")
                                          (:namespaces . "std")))

(setq org-babel-default-header-args:C '((:includes . "'(<stdio.h> <stdlib.h> <unistd.h> <time.h> <string.h>)")
                                        (:flags . "-std=c99")))

(map! :leader
      "j r" 'python-shell-send-region
      "j b" 'python-shell-send-buffer
      "j d" 'python-shell-send-defun)

(after! company
  (setq company-idle-delay 0.5)
  (setq company-minimum-prefix-length 1)
  (setq company-selection-wrap-around t);;Circular list
  (setq company-show-numbers t));; M-7 for 7nd match

(after! company
  (define-key company-active-map (kbd "<tab>")
    #'company-complete-selection)
  (define-key company-active-map (kbd "TAB")
    #'company-complete-selection))

(after! company
  (setq company-tooltip-limit 10
        company-tooltip-minimum-width 80))

(setq  writeroom-width 80)

(setq writeroom-mode-hook
      '(writeroom-mode-set-explicitly
        +zen-enable-mixed-pitch-mode-h))

(setq doom-themes-treemacs-theme "doom-colors")
(doom-themes-treemacs-config)

(setq doom-modeline-github t)
(setq doom-modeline-github-interval (* 30 60))

(setq +evil-want-o/O-to-continue-comments nil)

(after! evil-snipe
  (setq evil-snipe-scope 'visible)
  (setq evil-snipe-repeat-scope 'buffer)
  (setq evil-snipe-spillover-scope 'whole-buffer))

(setq yas-triggers-in-field t)

(map!
 (:after dired
  (:map dired-mode-map
   :n "RET" 'dired-find-alternate-file ;;Open in same bufer
   "-"   'find-alternate-file)
  "C-x i" #'peep-dired))

(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(use-package! dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (map! :map dired-mode-map
        :n "H" #'dired-hide-dotfiles-mode))

(setq lsp-enable-symbol-highlighting nil)

(add-hook 'pdf-tools-enabled-hook 'pdf-view-midnight-minor-mode) ;Dark mode

(setq +latex-viewers '(pdf-tools))

(push '("\\.pdf\\'" . emacs) org-file-apps)

(use-package zeal-at-point)
(map! :leader
      :desc "Zeal Look Up"
      "j z" #'zeal-at-point)

(use-package! framemove
  :config
  (setq framemove-hook-into-windmove t))

(use-package turkish)
(map! :leader
      :desc "Turkish last word"
      "d t" 'turkish-correct-last-word)

(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook 'Info-selection-hook 'info-colors-fontify-node)
(add-hook 'Info-mode-hook #'mixed-pitch-mode)

(use-package! command-log-mode)

(use-package! nov
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (setq nov-save-place-file (concat doom-cache-dir "nov-places")))

(use-package! org-pandoc-import :after org)

(require 'cl-lib)

(defun eww-tag-pre (dom)
  (let ((shr-folding-mode 'none)
        (shr-current-font 'default))
    (shr-ensure-newline)
    (insert (eww-fontify-pre dom))
    (shr-ensure-newline)))

(defun eww-fontify-pre (dom)
  (with-temp-buffer
    (shr-generic dom)
    (let ((mode (eww-buffer-auto-detect-mode)))
      (when mode
        (eww-fontify-buffer mode)))
    (buffer-string)))

(defun eww-fontify-buffer (mode)
  (delay-mode-hooks (funcall mode))
  (font-lock-default-function mode)
  (font-lock-default-fontify-region (point-min)
                                    (point-max)
                                    nil))

(defun eww-buffer-auto-detect-mode ()
  (let* ((map '((ada ada-mode)
                (awk awk-mode)
                (c c-mode)
                (cpp c++-mode)
                (clojure clojure-mode lisp-mode)
                (csharp csharp-mode java-mode)
                (css css-mode)
                (dart dart-mode)
                (delphi delphi-mode)
                (emacslisp emacs-lisp-mode)
                (erlang erlang-mode)
                (fortran fortran-mode)
                (fsharp fsharp-mode)
                (go go-mode)
                (groovy groovy-mode)
                (haskell haskell-mode)
                (html html-mode)
                (java java-mode)
                (javascript javascript-mode)
                (json json-mode javascript-mode)
                (latex latex-mode)
                (lisp lisp-mode)
                (lua lua-mode)
                (matlab matlab-mode octave-mode)
                (objc objc-mode c-mode)
                (perl perl-mode)
                (php php-mode)
                (prolog prolog-mode)
                (python python-mode)
                (r r-mode)
                (ruby ruby-mode)
                (rust rust-mode)
                (scala scala-mode)
                (shell shell-script-mode)
                (smalltalk smalltalk-mode)
                (sql sql-mode)
                (swift swift-mode)
                (visualbasic visual-basic-mode)
                (xml sgml-mode)))
         (language (language-detection-string
                    (buffer-substring-no-properties (point-min) (point-max))))
         (modes (cdr (assoc language map)))
         (mode (cl-loop for mode in modes
                        when (fboundp mode)
                        return mode)))
    (message (format "%s" language))
    (when (fboundp mode)
      mode)))

(setq shr-external-rendering-functions
      '((pre . eww-tag-pre)))

(use-package! keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

(use-package! outshine)

(use-package! atomic-chrome
  :config
  (atomic-chrome-start-server))

(setq delimit-columns-str-before "{ ")
(setq delimit-columns-str-after " }")
(setq delimit-columns-str-separator ", ")
(setq delimit-columns-before "")
(setq delimit-columns-after "")
(setq delimit-columns-separator " ")
(setq delimit-columns-format 'separator)
(setq delimit-columns-extra t)

(map! :leader
      "j [" 'delimit-columns-region)

(eval-after-load "artist"
  '(define-key artist-mode-map [(down-mouse-3)] 'artist-mouse-choose-operation))

(setq rainbow-delimiters-max-face-count 9)

(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   ))

(setq gdb-many-windows t)
(setq gdb-show-main t)
(add-hook 'gud-mode-hook
          (lambda ()
            (tool-bar-mode 1)
            (gud-tooltip-mode)))

(defun my/gud-quit ()
  (interactive)
  (tool-bar-mode -1)
  (let ((kill-buffer-query-functions nil))
    (switch-to-buffer "*gud-a.out*")
    (kill-buffer-and-window))
  (gud-basic-call "quit"))

(set-fringe-style (quote (24 . 24)))

(use-package! nmap)

(map! :leader
      :desc "Insert image from clipboard to org"
      "x" 'org-capture
      "X" 'doom/open-scratch-buffer
      "jj" 'org-ctrl-c-ctrl-c)

(map!
    :n "M-k" #'drag-stuff-up
    :n "M-j" #'drag-stuff-down)

(use-package! string-inflection
  :config
  (map! :leader
        "ec" 'string-inflection-all-cycle))

(setq rmh-elfeed-org-files
      '("~/Dropbox/rss.org"))

(use-package! elfeed-goodies)
(elfeed-goodies/setup)

(after! elfeed

  (elfeed-org)
  (use-package! elfeed-link)

  (setq elfeed-search-filter "@1-week-ago +unread"
        elfeed-search-print-entry-function '+rss/elfeed-search-print-entry
        elfeed-search-title-min-width 80
        elfeed-show-entry-switch #'pop-to-buffer
        elfeed-show-entry-delete #'+rss/delete-pane
        elfeed-show-refresh-function #'+rss/elfeed-show-refresh--better-style
        shr-max-image-proportion 0.6)

  (add-hook! 'elfeed-show-mode-hook (hide-mode-line-mode 1))
  (add-hook! 'elfeed-search-update-hook #'hide-mode-line-mode)

  (defface elfeed-show-title-face '((t (:weight ultrabold :slant italic :height 1.5)))
    "title face in elfeed show buffer"
    :group 'elfeed)
  (defface elfeed-show-author-face `((t (:weight light)))
    "title face in elfeed show buffer"
    :group 'elfeed)
  (set-face-attribute 'elfeed-search-title-face nil
                      :foreground 'nil
                      :weight 'light)

  (defadvice! +rss-elfeed-wrap-h-nicer ()
    "Enhances an elfeed entry's readability by wrapping it to a width of
`fill-column' and centering it with `visual-fill-column-mode'."
    :override #'+rss-elfeed-wrap-h
    (setq-local truncate-lines nil
                shr-width 120
                visual-fill-column-center-text t
                default-text-properties '(line-height 1.1))
    (let ((inhibit-read-only t)
          (inhibit-modification-hooks t))
      (visual-fill-column-mode)
      ;; (setq-local shr-current-font '(:family "Merriweather" :height 1.2))
      (set-buffer-modified-p nil)))

  (defun +rss/elfeed-search-print-entry (entry)
    "Print ENTRY to the buffer."
    (let* ((elfeed-goodies/tag-column-width 40)
           (elfeed-goodies/feed-source-column-width 30)
           (title (or (elfeed-meta entry :title) (elfeed-entry-title entry) ""))
           (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
           (feed (elfeed-entry-feed entry))
           (feed-title
            (when feed
              (or (elfeed-meta feed :title) (elfeed-feed-title feed))))
           (tags (mapcar #'symbol-name (elfeed-entry-tags entry)))
           (tags-str (concat (mapconcat 'identity tags ",")))
           (title-width (- (window-width) elfeed-goodies/feed-source-column-width
                           elfeed-goodies/tag-column-width 4))

           (tag-column (elfeed-format-column
                        tags-str (elfeed-clamp (length tags-str)
                                               elfeed-goodies/tag-column-width
                                               elfeed-goodies/tag-column-width)
                        :left))
           (feed-column (elfeed-format-column
                         feed-title (elfeed-clamp elfeed-goodies/feed-source-column-width
                                                  elfeed-goodies/feed-source-column-width
                                                  elfeed-goodies/feed-source-column-width)
                         :left)))

      (insert (propertize feed-column 'face 'elfeed-search-feed-face) " ")
      (insert (propertize tag-column 'face 'elfeed-search-tag-face) " ")
      (insert (propertize title 'face title-faces 'kbd-help title))
      (setq-local line-spacing 0.2)))

  (defun +rss/elfeed-show-refresh--better-style ()
    "Update the buffer to match the selected entry, using a mail-style."
    (interactive)
    (let* ((inhibit-read-only t)
           (title (elfeed-entry-title elfeed-show-entry))
           (date (seconds-to-time (elfeed-entry-date elfeed-show-entry)))
           (author (elfeed-meta elfeed-show-entry :author))
           (link (elfeed-entry-link elfeed-show-entry))
           (tags (elfeed-entry-tags elfeed-show-entry))
           (tagsstr (mapconcat #'symbol-name tags ", "))
           (nicedate (format-time-string "%a, %e %b %Y %T %Z" date))
           (content (elfeed-deref (elfeed-entry-content elfeed-show-entry)))
           (type (elfeed-entry-content-type elfeed-show-entry))
           (feed (elfeed-entry-feed elfeed-show-entry))
           (feed-title (elfeed-feed-title feed))
           (base (and feed (elfeed-compute-base (elfeed-feed-url feed)))))
      (erase-buffer)
      (insert "\n")
      (insert (format "%s\n\n" (propertize title 'face 'elfeed-show-title-face)))
      (insert (format "%s\t" (propertize feed-title 'face 'elfeed-search-feed-face)))
      (when (and author elfeed-show-entry-author)
        (insert (format "%s\n" (propertize author 'face 'elfeed-show-author-face))))
      (insert (format "%s\n\n" (propertize nicedate 'face 'elfeed-log-date-face)))
      (when tags
        (insert (format "%s\n"
                        (propertize tagsstr 'face 'elfeed-search-tag-face))))
      ;; (insert (propertize "Link: " 'face 'message-header-name))
      ;; (elfeed-insert-link link link)
      ;; (insert "\n")
      (cl-loop for enclosure in (elfeed-entry-enclosures elfeed-show-entry)
               do (insert (propertize "Enclosure: " 'face 'message-header-name))
               do (elfeed-insert-link (car enclosure))
               do (insert "\n"))
      (insert "\n")
      (if content
          (if (eq type 'html)
              (elfeed-insert-html content base)
            (insert content))
        (insert (propertize "(empty)\n" 'face 'italic)))
      (goto-char (point-min))))

  )

(add-hook! 'rainbow-mode-hook
  (hl-line-mode (if rainbow-mode -1 +1)))
