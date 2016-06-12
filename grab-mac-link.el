;;; grab-mac-link.el --- Grab link from Mac Apps and insert it into Emacs  -*- lexical-binding: t; -*-

;; Copyright (c) 2010-2016 Free Software Foundation, Inc.
;; Copyright (C) 2016  Chunyang Xu

;; The code is heavily inspired by org-mac-link.el

;; Authors of org-mac-link.el:
;;      Anthony Lander <anthony.lander@gmail.com>
;;      John Wiegley <johnw@gnu.org>
;;      Christopher Suckling <suckling at gmail dot com>
;;      Daniil Frumin <difrumin@gmail.com>
;;      Alan Schmitt <alan.schmitt@polytechnique.org>
;;      Mike McLean <mike.mclean@pobox.com>

;; Author: Chunyang Xu <xuchunyang.me@gmail.com>
;; URL: https://github.com/xuchunyang/grab-mac-link.el
;; Version: 0.0
;; Package-Requires: ((emacs "24"))
;; Keywords: Markdown, mac, hyperlink
;; Created: Sat Jun 11 15:07:18 CST 2016

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; The code of `grab-mac-link.el' is inspired by `org-mac-link.el'
;;
;; The following applications are supportted:
;; - Google Chrome.app
;; - Safari.app
;; - Firefox.app
;; - Finder.app
;; - Mail.app
;;
;; To use, type M-x grab-mac-link

;;; Code:

(defun grab-mac-link-split (as-link)
  (split-string as-link "::split::"))

(defun grab-mac-link-make-org-link (url name)
  (require 'org)
  (org-make-link-string url name))

(defun grab-mac-link-make-markdown-link (url name)
  "Make a Markdown inline link."
  (format "[%s](%s)" name url))


;; Google Chrome.app

(defun grab-mac-link-chrome-1 ()
  (let ((result
         (do-applescript
          (concat
           "set frontmostApplication to path to frontmost application\n"
           "tell application \"Google Chrome\"\n"
           "	set theUrl to get URL of active tab of first window\n"
           "	set theResult to (get theUrl) & \"::split::\" & (get name of window 1)\n"
           "end tell\n"
           "activate application (frontmostApplication as text)\n"
           "set links to {}\n"
           "copy theResult to the end of links\n"
           "return links as string\n"))))
    (grab-mac-link-split
     (replace-regexp-in-string
      "^\"\\|\"$" "" (car (split-string result "[\r\n]+" t))))))

;;;###autoload
(defun grab-mac-link-chrome ()
  (interactive)
  (insert (car (grab-mac-link-chrome-1))))

;;;###autoload
(defun grab-mac-link-chrome-as-markdown-link ()
  (interactive)
  (insert (apply #'grab-mac-link-make-markdown-link (grab-mac-link-chrome-1))))

;;;###autoload
(defun grab-mac-link-chrome-as-org-link ()
  (interactive)
  (insert (apply #'grab-mac-link-make-org-link (grab-mac-link-chrome-1))))


;; Firefox.app

(defun grab-mac-link-firefox-1 ()
  (let ((result
         (do-applescript
          (concat
           "set oldClipboard to the clipboard\n"
           "set frontmostApplication to path to frontmost application\n"
           "tell application \"Firefox\"\n"
           "	activate\n"
           "	delay 0.15\n"
           "	tell application \"System Events\"\n"
           "		keystroke \"l\" using {command down}\n"
           "		keystroke \"a\" using {command down}\n"
           "		keystroke \"c\" using {command down}\n"
           "	end tell\n"
           "	delay 0.15\n"
           "	set theUrl to the clipboard\n"
           "	set the clipboard to oldClipboard\n"
           "	set theResult to (get theUrl) & \"::split::\" & (get name of window 1)\n"
           "end tell\n"
           "activate application (frontmostApplication as text)\n"
           "set links to {}\n"
           "copy theResult to the end of links\n"
           "return links as string\n"))))
    (grab-mac-link-split
     (car (split-string result "[\r\n]+" t)))))

;;;###autoload
(defun grab-mac-link-firefox ()
  (interactive)
  (insert (car (grab-mac-link-firefox-1))))

;;;###autoload
(defun grab-mac-link-firefox-as-markdown-link ()
  (interactive)
  (insert (apply #'grab-mac-link-make-markdown-link (grab-mac-link-firefox-1))))

;;;###autoload
(defun grab-mac-link-firefox-as-org-link ()
  (interactive)
  (insert (apply #'grab-mac-link-make-org-link (grab-mac-link-firefox-1))))


;; Safari.app

(defun grab-mac-link-safari-1 ()
  (grab-mac-link-split
   (do-applescript
    (concat
     "tell application \"Safari\"\n"
     "	set theUrl to URL of document 1\n"
     "	set theName to the name of the document 1\n"
     "	return theUrl & \"::split::\" & theName\n"
     "end tell\n"))))

;;;###autoload
(defun grab-mac-link-safari ()
  (interactive)
  (insert (car (grab-mac-link-safari-1))))

;;;###autoload
(defun grab-mac-link-safari-as-markdown-link ()
  (interactive)
  (insert (apply #'grab-mac-link-make-markdown-link (grab-mac-link-safari-1))))

;;;###autoload
(defun grab-mac-link-safari-as-org-link ()
  (interactive)
  (insert (apply #'grab-mac-link-make-org-link (grab-mac-link-safari-1))))


;; Finder.app

(defun grab-mac-link-finder-1 ()
  (grab-mac-link-split
   (do-applescript
    (concat
     "tell application \"Finder\"\n"
     " set theSelection to the selection\n"
     " set links to {}\n"
     " repeat with theItem in theSelection\n"
     " set theLink to \"file://\" & (POSIX path of (theItem as string)) & \"::split::\" & (get the name of theItem)\n"
     " copy theLink to the end of links\n"
     " end repeat\n"
     " return links as string\n"
     "end tell\n"))))

;;;###autoload
(defun grab-mac-link-finder ()
  (interactive)
  (insert (car (grab-mac-link-finder-1))))

;;;###autoload
(defun grab-mac-link-finder-as-markdown-link ()
  (interactive)
  (insert (apply #'grab-mac-link-make-markdown-link (grab-mac-link-finder-1))))

;;;###autoload
(defun grab-mac-link-finder-as-org-link ()
  (interactive)
  (insert (apply #'grab-mac-link-make-org-link (grab-mac-link-finder-1))))


;; Mail.app

(defun grab-mac-link-mail-1 ()
  "AppleScript to create links to selected messages in Mail.app."
  (grab-mac-link-split
   (do-applescript
    (concat
     "tell application \"Mail\"\n"
     "set theLinkList to {}\n"
     "set theSelection to selection\n"
     "repeat with theMessage in theSelection\n"
     "set theID to message id of theMessage\n"
     "set theSubject to subject of theMessage\n"
     "set theLink to \"message://\" & theID & \"::split::\" & theSubject\n"
     "if (theLinkList is not equal to {}) then\n"
     "set theLink to \"\n\" & theLink\n"
     "end if\n"
     "copy theLink to end of theLinkList\n"
     "end repeat\n"
     "return theLinkList as string\n"
     "end tell"))))

;;;###autoload
(defun grab-mac-link-mail ()
  (interactive)
  (insert (car (grab-mac-link-mail-1))))

;;;###autoload
(defun grab-mac-link-mail-as-markdown-link ()
  (interactive)
  (insert (apply #'grab-mac-link-make-markdown-link (grab-mac-link-mail-1))))

;;;###autoload
(defun grab-mac-link-mail-as-org-link ()
  (interactive)
  (insert (apply #'grab-mac-link-make-org-link (grab-mac-link-mail-1))))


;; Terminal.app

(defun grab-mac-link-terminal-1 ()
  (grab-mac-link-split
   (do-applescript
    (concat
     "tell application \"Terminal\"\n"
     "  set theName to custom title in tab 1 of window 1\n"
     "  do script \"pwd | pbcopy\" in window 1\n"
     "  set theUrl to do shell script \"pbpaste\"\n"
     "  return theUrl & \"::split::\" & theName\n"
     "end tell"))))


;; One Entry point for all

;;;###autoload
(defun grab-mac-link ()
  "Prompt for an application to grab a link from.
When done, go grab the link, and insert it at point."
  (interactive)
  (let ((apps
         '((?c . chrome)
           (?s . safari)
           (?f . firefox)
           (?F . finder)
           (?m . mail)))
        (actions
         '((?p . "grab-mac-link-%s")
           (?m . "grab-mac-link-%s-as-markdown-link")
           (?o . "grab-mac-link-%s-as-org-link")))
        input grab-function)

    (message "[c]hrome [s]afari [f]irefox [F]inder [m]ail:" )
    (setq input (read-char-exclusive))
    (setq app (cdr (assq input apps)))

    (message "Grab link from %s as a [p]lain [m]arkdown [o]rg link:" app)
    (setq input (read-char-exclusive))
    (setq grab-function (intern (format (cdr (assq input actions)) app)))

    (when grab-function
      (call-interactively grab-function))))

(provide 'grab-mac-link)
;;; grab-mac-link.el ends here
