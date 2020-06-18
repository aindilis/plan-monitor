(add-to-list 'auto-mode-alist '("\\.btpm\\'" . plan-monitor-mode))
(add-to-list 'auto-mode-alist '("\\.ep\\'" . web-mode))

;; Derived from simgen-bt-mode, hence includes some features not yet present in Plan Monitor mode

;; /var/lib/myfrdcsas/versions/myfrdcsa-1.0/codebases/minor/free-life-planner/projects/swipl-emacs/prolog.el

(setq plan-monitor-keywords '())
;; (setq plan-monitor-keywords '("set" "clear" "try" "fail" "not" "dur" "pin"))

(define-derived-mode plan-monitor-mode
 prolog-mode "Plan-Monitor"
 "Major mode for editing Plan Monitor .btpm Behavior Tree files
\\{plan-monitor-mode-map}"

 ;; (kill-all-local-variables)

 (setq major-mode 'prolog-mode)
 ;; (setq mode-name "Plan Monitor")

 ;; (use-local-map prolog-mode-map)
 ;; (set-syntax-table prolog-mode-syntax-table)
 ;; (prolog-mode-variables)

 (setq-local prolog-head-delimiter "\\(:-\\|\\+:\\|-:\\|\\+\\?\\|-\\?\\|-->\\|~\\?\\|\\!\\|\\?\\|-\\?\\|->\\|~>\\|=>\\|=\\?\\|>>\\|<>\\|<-->\\)")

 (make-local-variable 'font-lock-defaults)
 (setq plan-monitor-font-lock-keywords
  (prolog-font-lock-keywords))

 ;; (push
 ;;  (list (prolog-make-keywords-regexp plan-monitor-keywords) 1 font-lock-builtin-face)
 ;;  plan-monitor-font-lock-keywords)

 (setq font-lock-defaults
  '(plan-monitor-font-lock-keywords nil nil ((?_ . "w"))))

 (setq major-mode 'plan-monitor-mode)
 (setq mode-name "Plan-Monitor")

 (prolog-build-case-strings)
 (prolog-set-atom-regexps)
 (dolist (ar prolog-align-rules) (add-to-list 'align-rules-list ar))
 (run-mode-hooks 'prolog-mode-hook)

 ;; custom stuff
 (setq-local case-fold-search nil)
 (make-local-variable 'prolog-head-delimiter)

 ;; (setq-local prolog-head-delimiter "\\(:-\\|\\+:\\|-:\\|\\+\\?\\|-\\?\\|-->\\)")

 )

(require 'prolog)

(defun prolog-font-lock-keywords ()
  "Set up font lock keywords for the current Prolog system."
  ;(when window-system
    (require 'font-lock)
    
    ;; Define Prolog faces
    (defface prolog-redo-face
      '((((class grayscale)) (:italic t))
        (((class color)) (:foreground "darkorchid"))
        (t (:italic t)))
      "Prolog mode face for highlighting redo trace lines."
      :group 'prolog-faces)
    (defface prolog-exit-face
      '((((class grayscale)) (:underline t))
        (((class color) (background dark)) (:foreground "green"))
        (((class color) (background light)) (:foreground "ForestGreen"))
        (t (:underline t)))
      "Prolog mode face for highlighting exit trace lines."
      :group 'prolog-faces)
    (defface prolog-exception-face
      '((((class grayscale)) (:bold t :italic t :underline t))
        (((class color)) (:bold t :foreground "black" :background "Khaki"))
        (t (:bold t :italic t :underline t)))
      "Prolog mode face for highlighting exception trace lines."
      :group 'prolog-faces)
    (defface prolog-warning-face
      '((((class grayscale)) (:underline t))
        (((class color) (background dark)) (:foreground "blue"))
        (((class color) (background light)) (:foreground "MidnightBlue"))
        (t (:underline t)))
      "Face name to use for compiler warnings."
      :group 'prolog-faces)
    (defface prolog-builtin-face
      '((((class color) (background light)) (:foreground "Purple"))
        (((class color) (background dark)) (:foreground "Cyan"))
        (((class grayscale) (background light)) (:foreground "LightGray" :bold t))
        (((class grayscale) (background dark)) (:foreground "DimGray" :bold t))
        (t (:bold t)))
      "Face name to use for compiler warnings."
     :group 'prolog-faces)
    (defface prolog-plan-monitor-keywords-face
      '((((class color) (background light)) (:foreground "red"))
        (((class color) (background dark)) (:foreground "yellow"))
        (((class grayscale) (background light)) (:foreground "LightGray" :bold t))
        (((class grayscale) (background dark)) (:foreground "DimGray" :bold t))
        (t (:bold t)))
      "Face name to use for compiler warnings."
      :group 'prolog-faces)
    (defvar prolog-warning-face 
      (if (prolog-face-name-p 'font-lock-warning-face)
          'font-lock-warning-face
        'prolog-warning-face)
      "Face name to use for built in predicates.")
    (defvar prolog-builtin-face 
      (if (prolog-face-name-p 'font-lock-builtin-face)
          'font-lock-builtin-face
        'prolog-builtin-face)
     "Face name to use for built in predicates.")
    (defvar prolog-plan-monitor-keywords-face
      'prolog-plan-monitor-keywords-face
      "Face name to use for built in predicates.")
    (defvar prolog-redo-face 'prolog-redo-face
      "Face name to use for redo trace lines.")
    (defvar prolog-exit-face 'prolog-exit-face
      "Face name to use for exit trace lines.")
    (defvar prolog-exception-face 'prolog-exception-face
      "Face name to use for exception trace lines.")
    
    ;; Font Lock Patterns
    (let (
          ;; "Native" Prolog patterns
          (head-predicates
           (list (format "^\\(%s\\)\\((\\|[ \t]*\\(:-\\|\\+:\\|-:\\|\\+\\?\\|-\\?\\|-->\\|~\\?\\|\\!\\|\\?\\|-\\?\\|->\\|~>\\|=>\\|=\\?\\|>>\\|<>\\|<-->\\)\\)" prolog-atom-regexp)
                 1 font-lock-function-name-face))
           ;(list (format "^%s" prolog-atom-regexp)
           ;      0 font-lock-function-name-face))
          (head-predicates-1
           (list (format "\\.[ \t]*\\(%s\\)" prolog-atom-regexp)
                 1 font-lock-function-name-face) )
          (variables
           '("\\<\\([_A-Z][a-zA-Z0-9_]*\\)"
             1 font-lock-variable-name-face))
          (important-elements
           (list (if (eq prolog-system 'mercury)
                     "[][}{;|]\\|\\\\[+=]\\|<?=>?"
                   "[][}{!;|]\\|\\*->\\|:-\\|\\+:\\|-:\\|\\+\\?\\|-\\?\\|-->\\|~\\?\\|\\!\\|\\?\\|-\\?\\|->\\|~>\\|=>\\|=\\?\\|>>\\|<>\\|<-->")
                 0 'font-lock-keyword-face))
          (important-elements-1
           '("[^-*]\\(->\\)" 1 font-lock-keyword-face))
          (predspecs                        ; module:predicate/cardinality
           (list (format "\\<\\(%s:\\|\\)%s/[0-9]+"
                         prolog-atom-regexp prolog-atom-regexp)
                 0 font-lock-function-name-face 'prepend))
          (keywords                        ; directives (queries)
           (list
	    (concat
	     "[ {]\\("
	     (prolog-make-keywords-regexp plan-monitor-keywords)
	     "\\)[ }]")
              1 prolog-plan-monitor-keywords-face))
          (quoted_atom (list prolog-quoted-atom-regexp
                             2 'font-lock-string-face 'append))
          (string (list prolog-string-regexp
                        1 'font-lock-string-face 'append))
          ;; SICStus specific patterns
          (sicstus-object-methods
           (if (eq prolog-system 'sicstus)
               '(prolog-font-lock-object-matcher
                 1 font-lock-function-name-face)))
          ;; Mercury specific patterns
          (types
           (if (eq prolog-system 'mercury)
               (list
                (prolog-make-keywords-regexp prolog-types-i t)
                0 'font-lock-type-face)))
          (modes
           (if (eq prolog-system 'mercury)
               (list
                (prolog-make-keywords-regexp prolog-mode-specificators-i t)
                0 'font-lock-reference-face)))
          (directives
           (if (eq prolog-system 'mercury)
               (list
                (prolog-make-keywords-regexp prolog-directives-i t)
                0 'prolog-warning-face)))
          ;; Inferior mode specific patterns
          (prompt
           (list prolog-prompt-regexp-i 0 'font-lock-keyword-face))
          (trace-exit
           (cond
            ((eq prolog-system 'sicstus)
             '("[ \t]*[0-9]+[ \t]+[0-9]+[ \t]*\\(Exit\\):"
               1 prolog-exit-face))
            ((eq prolog-system 'swi)
             '("[ \t]*\\(Exit\\):[ \t]*([ \t0-9]*)" 1 prolog-exit-face))
            (t nil)))
          (trace-fail
           (cond
            ((eq prolog-system 'sicstus)
             '("[ \t]*[0-9]+[ \t]+[0-9]+[ \t]*\\(Fail\\):"
               1 prolog-warning-face))
            ((eq prolog-system 'swi)
             '("[ \t]*\\(Fail\\):[ \t]*([ \t0-9]*)" 1 prolog-warning-face))
            (t nil)))
          (trace-redo
           (cond
            ((eq prolog-system 'sicstus)
             '("[ \t]*[0-9]+[ \t]+[0-9]+[ \t]*\\(Redo\\):"
               1 prolog-redo-face))
            ((eq prolog-system 'swi)
             '("[ \t]*\\(Redo\\):[ \t]*([ \t0-9]*)" 1 prolog-redo-face))
            (t nil)))
          (trace-call
           (cond
            ((eq prolog-system 'sicstus)
             '("[ \t]*[0-9]+[ \t]+[0-9]+[ \t]*\\(Call\\):"
               1 font-lock-function-name-face))
            ((eq prolog-system 'swi)
             '("[ \t]*\\(Call\\):[ \t]*([ \t0-9]*)"
               1 font-lock-function-name-face))
            (t nil)))
          (trace-exception
           (cond
            ((eq prolog-system 'sicstus)
             '("[ \t]*[0-9]+[ \t]+[0-9]+[ \t]*\\(Exception\\):"
               1 prolog-exception-face))
            ((eq prolog-system 'swi)
             '("[ \t]*\\(Exception\\):[ \t]*([ \t0-9]*)"
               1 prolog-exception-face))
            (t nil)))
          (error-message-identifier
           (cond
            ((eq prolog-system 'sicstus)
             '("{\\([A-Z]* ?ERROR:\\)" 1 prolog-exception-face prepend))
            ((eq prolog-system 'swi)
             '("^[[]\\(WARNING:\\)" 1 prolog-builtin-face prepend))
            (t nil)))
          (error-whole-messages
           (cond
            ((eq prolog-system 'sicstus)
             '("{\\([A-Z]* ?ERROR:.*\\)}[ \t]*$"
               1 font-lock-comment-face append))
            ((eq prolog-system 'swi)
             '("^[[]WARNING:[^]]*[]]$" 0 font-lock-comment-face append))
            (t nil)))
          (error-warning-messages
           ;; Mostly errors that SICStus asks the user about how to solve,
           ;; such as "NAME CLASH:" for example.
           (cond
            ((eq prolog-system 'sicstus)
             '("^[A-Z ]*[A-Z]+:" 0 prolog-warning-face))
            (t nil)))
          (warning-messages
           (cond
            ((eq prolog-system 'sicstus)
             '("\\({ ?\\(Warning\\|WARNING\\) ?:.*}\\)[ \t]*$" 
               2 prolog-warning-face prepend))
            (t nil))))

      ;; Make font lock list
      (delq
       nil
       (cond
        ((eq major-mode 'prolog-mode)
         (list
          head-predicates
          head-predicates-1
          quoted_atom
          string
          variables
          important-elements
          important-elements-1
          predspecs
          keywords
          sicstus-object-methods
          types
          modes
          directives))
        ((eq major-mode 'prolog-inferior-mode)
         (list
         prompt
         error-message-identifier
         error-whole-messages
         error-warning-messages
         warning-messages
         predspecs
         trace-exit
         trace-fail
         trace-redo
         trace-call
         trace-exception))
        ((eq major-mode 'compilation-mode)
         (list
         error-message-identifier
         error-whole-messages
         error-warning-messages
         warning-messages
         predspecs))))
      ))


(provide 'plan-monitor)
