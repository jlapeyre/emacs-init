# attic

Init files that are not loaded at startup. They were taken out at some
point, possibly because they slowed startup. They are kept here so that
they are easy to find and turn back on.

To try one for a session:

    (load (locate-user-emacs-file "attic/pdftools"))

To turn one back on permanently, move it to `lib/` and add an `init-load`
line to `init.el`.

| File | What it does |
|------|--------------|
| `pdftools.el` | pdf-tools setup: `.pdf` opens in pdf-view-mode, vi-like keys (j k g G d u) |
| `helm-bibtex.el` | helm-bibtex for the literature collection in `~/literature_collection/`, bound to F10. Needs the helm-bibtex package, no longer in the package list; citar is the vertico/consult equivalent |
| `images.el` | Use ImageMagick for PNG, JPEG, TIFF and SVG; fit image to window |
| `seldom_used.el` | `evince-on-current-file`, maxima-mode autoloads, shell-pop on C-t |
| `profile_debug.el` | Example: show a backtrace when `diary-lib` is required |
