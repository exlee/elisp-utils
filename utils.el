(defun eshell-frame ()
  "Create new eshell frame"
  (interactive)
  (with-selected-frame
      (make-frame `((name . "Eshell") (parent-frame . ,(selected-frame)) (tab-bar-lines . 0)))
     (display-buffer-override-next-command
      (lambda (buffer alist)
        (cons (display-buffer-full-frame buffer alist) 'frame)))
    (eshell)))
