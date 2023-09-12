;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el
(package! company-sourcekit)
(package! undo-tree)
(package! org-noter)
(package! org-roam
          :recipe (:host github :repo "jethrokuan/org-roam"))
(package! company-org-roam
  :recipe (:host github :repo "jethrokuan/company-org-roam"))
(unpin! org-roam)
(package! org-roam-ui)
