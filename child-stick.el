(defcustom child-stick-padding 10 "Padding value between parent window and child frame")
(defcustom child-stick-delay 0.1 "Delay between window spawn and positioning function")

(defun child-stick--title-bar-height (&optional frame)
  "Get title bar height in pixels"
  (cddr (assq 'title-bar-size (frame-geometry frame))))

(defun child-stick-nw (&optional frame)
  "Position Child window to NW"
  (interactive)
  (let* ((target (or frame (selected-frame)))
         (geometry (frame-geometry target))
         (width (frame-pixel-width target))
         (offset-x (- (+ width child-stick-padding)))
         (offset-y (- (child-stick--title-bar-height target))))
    (set-frame-position target offset-x offset-y)))

(defun child-stick-ne (&optional frame)
  "Position Child window to NW"
  (interactive)
  (let* ((target (or frame (selected-frame)))
         (parent (frame-parent target))
         (geometry (frame-geometry target))
         (parent-width (frame-pixel-width parent))
         (offset-x (+ (+ parent-width child-stick-padding)))
         (offset-y (- (child-stick--title-bar-height target))))
  (set-frame-position target offset-x offset-y)))

(defun child-stick-sw (&optional frame)
  "Position Child window to NW"
  (interactive)
  (let* ((target (or frame (selected-frame)))
         (parent (frame-parent target))
         (width (frame-pixel-width target))
         (height (frame-pixel-height target))
         (parent-height (frame-pixel-height parent))
         (offset-x (- (+ width child-stick-padding)))
         (offset-y (- parent-height (child-stick--title-bar-height) height))
         )
    (set-frame-position target offset-x offset-y)))

(defun child-stick-se (&optional frame)
  "Position Child window to NW"
  (interactive)
  (let* ((target (or frame (selected-frame)))
         (parent (frame-parent target))
         (width (frame-pixel-width parent))
         (height (frame-pixel-height target))
         (parent-height (frame-pixel-height parent))
         (offset-x (+ (+ width child-stick-padding)))
         (offset-y (- parent-height (child-stick--title-bar-height) height)))
  (set-frame-position target offset-x offset-y)))

(defun child-stick-e (&optional frame)
  "Position Child window to NW"
  (interactive)
  (let* ((target (or frame (selected-frame)))
         (parent (frame-parent target))
         (parent-width (frame-pixel-width parent))
         (parent-height (frame-pixel-height parent))
         (offset-x (+ (+ parent-width child-stick-padding)))
         (offset-y (- (cddr (assq 'title-bar-size geometry))))
         )
    (set-frame-position target offset-x offset-y)
    (set-frame-height target (- parent-height (tab-bar-height parent t)) nil t)))


(defun child-stick-w (&optional frame)
  "Stick child window to W"
  (interactive)
  (let* ((target (or frame (selected-frame)))
         (parent (frame-parent target))
         (width (frame-pixel-width target))
         (parent-width (frame-pixel-width parent))
         (parent-height (frame-pixel-height parent))
         (offset-x (- 0 width child-stick-padding))
         (offset-y (- (child-stick--title-bar-height target))))
    (set-frame-position target offset-x offset-y)
    (set-frame-height target (- parent-height (tab-bar-height parent t)) nil t)))

(defun child-stick-s (&optional frame)
  "Stick Child window to NW"
  (interactive)
  (let* ((target (or frame (selected-frame)))
         (parent (frame-parent target))
         (width (frame-pixel-width target))
         (parent-width (frame-pixel-width parent))
         (parent-height (frame-pixel-height parent))
         (offset-y (+ parent-height child-stick-padding)))
    (set-frame-height target 15)
    (set-frame-width target (- parent-width 16) nil t)
    (set-frame-position target 0 offset-y)
  ))

(defun display-buffer-child-stick (buffer alist)
  "Display BUFFER in a sticky child frame.

ALIST is an association list of action symbols and values.  See
Info node `(elisp) Buffer Display Action Alists' for details of
such alists.

It shares all characteristic of `display-buffer-in-child-frame'
with an exception that it positions frame window to a direction provided
in `stick-direction' parameter in provided ALIST."
  (let* ((direction (or (ignore-errors (cdr (assq 'stick-direction alist))) 'nw))
         (frame  (display-buffer-in-child-frame buffer alist))
         (dirfun (intern (concat "child-stick-" (symbol-name direction))))
         )
    (message "%s" dirfun)
    (run-with-timer child-stick-delay nil dirfun (window-frame frame))))
