;;; -*- lexical-binding: t; -*-

;; http://emacs.stackexchange.com/questions/2433/shrink-zoom-scale-images-in-image-mode
;; Following fits to window. The other image.el functions also work because
;; of setting image-type-header-regexps below.
(defun modi/image-transform-fit-to-window()
  "Resize the image to fit the width or height based on the image and window ratios.
Imagemagick is required to run this function."
  (interactive)
  (let* ( (img-size (image-display-size (image-get-display-property) t))
          (img-width (car img-size))
          (img-height (cdr img-size))
          (img-h/w-ratio (/ (float img-height) (float img-width)))
          (win-width (- (nth 2 (window-inside-pixel-edges))
                        (nth 0 (window-inside-pixel-edges))))
          (win-height (- (nth 3 (window-inside-pixel-edges))
                         (nth 1 (window-inside-pixel-edges))))
          (win-h/w-ratio (/ (float win-height) (float win-width))))
    ;; Fit image by width if the h/w ratio of window is > h/w ratio of the image
    (if (> win-h/w-ratio img-h/w-ratio)
        (image-transform-fit-to-width)
      ;; Else fit by height
      (image-transform-fit-to-height))))

;; Force Imagemagick to load images rather than libjpeg
;; But, this disables png images in org mode :(
(setq image-type-header-regexps
       `(
         ("\\`/[\t\n\r ]*\\*.*XPM.\\*/" . xpm)
         ("\\`P[1-6]\\\(?:\
              \\(?:\\(?:#[^\r\n]*[\r\n]\\)?[[:space:]]\\)+\
              \\(?:\\(?:#[^\r\n]*[\r\n]\\)?[0-9]\\)+\
              \\)\\{2\\}" . pbm)
         ("\\`GIF8[79]a" . gif)
         ;; ("\\`\x89PNG\r\n\x1a\n" . png) ;; Uncomment this (and comment the below line) to enable inline png images in org-mode
         ("\\`\x89PNG\r\n\x1a\n" . imagemagick) ; png
         ("\\`[\t\n\r ]*#define \\([a-z0-9_]+\\)_width [0-9]+\n\
              #define \\1_height [0-9]+\n\\(\
              #define \\1_x_hot [0-9]+\n\
              #define \\1_y_hot [0-9]+\n\\)?\
              static \\(unsigned \\)?char \\1_bits" . xbm)
         ;; ("\\`\\(?:MM\0\\*\\|II\\*\0\\)" . tiff)
         ("\\`\\(?:MM\0\\*\\|II\\*\0\\)" . imagemagick) ; tiff
         ("\\`[\t\n\r ]*%!PS" . postscript)
         ;; ("\\`\xff\xd8" . jpeg) ;; Uncomment this (and comment the below line) to enable inline jpg images in org-mode
         ("\\`\xff\xd8" . imagemagick)    ; jpeg
         ("\\`\377\330" . imagemagick)    ; jpeg
         (,(let* ((incomment-re "\\(?:[^-]\\|-[^-]\\)")
                  (comment-re (concat "\\(?:!--" incomment-re "*-->[ \t\r\n]*<\\)")))
             (concat "\\(?:<\\?xml[ \t\r\n]+[^>]*>\\)?[ \t\r\n]*<"
                     comment-re "*"
                     "\\(?:!DOCTYPE[ \t\r\n]+[^>]*>[ \t\r\n]*<[ \t\r\n]*" comment-re "*\\)?"
                     "[Ss][Vv][Gg]"))
          ;; . svg)  ;; Uncomment this (and comment the below line) to enable inline svg images in org-mode
          . imagemagick) ; svg
         ))


;;;* EIMP Image manipulation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; EIMP Image manipulation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package eimp
  :commands eimp-mode
  :hook (image-mode . eimp-mode)
  :config
  (eimp-enable-undo t)
  (eimp-ignore-read-only-modes
   '(gnus-article-mode puzzle-mode tumme-display-image-mode tumme-thumbnail-mode w3m-mode google-maps)))
