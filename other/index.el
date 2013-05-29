;; HOW TO USE THIS FILE

;; 1. Open this file in Emacs and type `M-x eval-buffer' to evaluate
;; all the Emacs Lisp function definitions and key bindings in it.

;; 2. Run the script index-helper.pl from the shell and save its
;; output to a file, e.g.
;;   hottbook$ other/index-helper.pl >indexterms.txt

;; 3. Open the `indexterms.txt` file in Emacs, position point at the
;; beginning of the words you want to index (e.g. the beginning of a
;; letter), and type `C-c i`.  You will be prompted one by one whether
;; you want to index the words appearing after that point.  As soon as
;; you say "yes" to one of them, you will be prompted for the term
;; under which you want to index it.  You can break out of this
;; without selecting a word to index by typing `C-g` (the standard
;; Emacs quit command).

;; 4. After choosing a word to index as above, type `C-c n` to jump to
;; and highlight the next occurrence of that word; you will then be
;; prompted whether or not to add an index entry for it.  If you've
;; been editing files since creating the `indexterms.txt` file, then
;; the positions stored therein may not match reality and the script
;; may not be able to find the actual occurrence, but it should
;; hopefully be close by and you can find it yourself.  FEEL FREE to
;; say "no" to the script and then add your own index entry or
;; entries, if you think the default `\index{term}` is not right for
;; this occurrence.

;; 5. Repeat step 4 until the script tells you "No more occurrences of
;; current word".  If you type `C-u C-c n`, then the command `C-c n`
;; will repeat itself automatically until you quit (with `C-g`) or run
;; out of occurrences.  In either case, you should be left back at the
;; `indexterms.txt` file, ready to type `C-c i` again and choose your
;; next word to index.

;; 6. After doing this for a while, especially if you've been making
;; other edits at the same time (as tends to happen), the positions in
;; the `indexterms.txt` file may become very far off.  When this
;; happens you can do the following.
;;  a) Repeat step 2 to recreate the file.
;;  b) Switch to that file in Emacs and type `M-x revert-buffer` to
;;     reload the new version.  Make sure you reposition the cursor
;;     where it was before.
;;  c) Type `M-x index-clear-offsets` to inform the indexing scripts.
;; In place of steps b and c, you can also just quit and restart Emacs.

(defvar index-buffer nil)
(defvar index-word nil)
(defvar index-term nil)
(defvar index-bound nil)

(defvar index-overlay nil)
(setq index-overlay (make-overlay (point-min) (point-max)))
(delete-overlay index-overlay)
(overlay-put index-overlay 'face '((:background "purple")))

(defvar index-offsets nil)

(defun index-term () (interactive)
  (if (and (re-search-forward "^=+ " nil t)
	   (progn (recenter) t)
	   (looking-at "\\([A-Za-z-']+\\) "))
      (let ((word (match-string 1)))
	(move-overlay index-overlay (match-beginning 1) (match-end 1))
	(unwind-protect
	    (if (y-or-n-p (concat "Index '" word "'? "))
		(progn
		  (setq index-buffer (current-buffer)
			index-word word
			index-term (read-string (concat "Index entry for '" index-word "' (default=" index-word ") : ") nil nil index-word)
			index-bound (save-excursion (re-search-forward "^=+ " nil t)))
		  (forward-line 1))
	      (index-term))
	  (beginning-of-line)
	  (delete-overlay index-overlay)))
    (message "No words found")))

(global-set-key '[(control ?c) ?i] 'index-term)

(defun index-next (repeat) (interactive "P")
  (let (file loc)
    (if (progn
	  (set-buffer index-buffer)
	  (re-search-forward "\\[\\([A-Za-z]+\\.tex\\) @ \\([0-9]+\\)\\]" index-bound t))
	(let ((file (match-string 1))
	      (loc (string-to-number (match-string 2)))
	      offset)
	  (find-file file)
	  (goto-char loc)
	  (backward-char 20)		; Correct for strange misalignments
	  (setq offset (or (cdr (assoc (current-buffer) index-offsets)) 0))
	  (forward-char offset)
	  (if (search-forward index-word (+ (point) 400) t)
	      (progn
		(move-overlay index-overlay (match-beginning 0) (match-end 0))
		(unwind-protect
		    (progn
		      (when (y-or-n-p (concat "Index this occurrence as '" index-term "'? "))
			(when (or (looking-at "}")
				  (save-excursion
				    (goto-char (match-beginning 0))
				    (backward-char 1)
				    (looking-at "{")))
			  (backward-up-list -1))
			(insert "\\index{" index-term "}")
			(setq offset (+ offset 8 (length index-term)))
			(if (assoc (current-buffer) index-offsets)
			    (setcdr (assoc (current-buffer) index-offsets) offset)
			  (setq index-offsets (cons (cons (current-buffer) offset) index-offsets))))
		      (with-current-buffer index-buffer
			(forward-line 1)))
		  (delete-overlay index-overlay)
		  (with-current-buffer index-buffer
		    (beginning-of-line)))
		(if repeat
		    (index-next repeat)))
	    (if (and repeat (y-or-n-p "This occurrence not found; continue? "))
		(index-next repeat)
	      (message "Occurrence not found"))))
      (switch-to-buffer index-buffer)
      (message "No more occurrences of current word"))))

(global-set-key `[(control ?c) ?n] 'index-next)

(defun index-clear-offsets () (interactive)
  (setq index-offsets nil))
