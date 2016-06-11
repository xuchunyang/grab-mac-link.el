# `grab-mac-link.el`

Grab link from Mac Apps and insert it into Emacs as plain, Markdown or Org link, e.g.,

    Plain:    https://www.wikipedia.org/
    Markdown: [Wikipedia](https://www.wikipedia.org/)
    Org:      [[https://www.wikipedia.org/][Wikipedia]]

## Supported Apps

- Google Chrome
- Safari
- Firefox
- Finder
- Mail

## Commands

### `grab-mac-link`

Prompt for an application to grab a link from, prompt for a link
format to insert as, and insert it at point.

### `grab-mac-link-chrome`

Grab link from Chrome and insert it at point as plain link

### `grab-mac-link-chrome-as-markdown-link`

Grab link from Chrome and insert it at point as Markdown link

### `grab-mac-link-chrome-as-org-link`

Grab link from Chrome and insert it at point as Org link

### `grab-mac-link-safari`
### `grab-mac-link-safari-as-markdown-link`
### `grab-mac-link-safari-as-org-link`

and so on...

## Programming Interface

### `(grab-mac-link-chrome-1)`

``` emacs-lisp
(grab-mac-link-chrome-1)
    ⇒ ("https://www.wikipedia.org/" "Wikipedia")
```

### `(grab-mac-link-firefox-1)`

``` emacs-lisp
(grab-mac-link-firefox-1)
    ⇒ ("https://www.wikipedia.org" "Wikipedia")
```

### `(grab-mac-link-safari-1)`

``` emacs-lisp
(grab-mac-link-safari-1)
    ⇒ ("https://www.wikipedia.org/" "Wikipedia")
```

### `(grab-mac-link-finder-1)`

``` emacs-lisp
(grab-mac-link-finder-1)
    ⇒ ("file:///Users/xcy/Downloads/haunt-0.2.tar.gz" "haunt-0.2.tar.gz")
```

### `(grab-mac-link-mail-1)`

``` emacs-lisp
(grab-mac-link-mail-1)
    ⇒ ("message://HjOnDbgYiWfDDNcbF-rbtw@notifications.google.com" "New sign-in from iPad")
```

## Acknowledgment

AppleScript code used in this program is borrowed from [`org-mac-link.el`](http://orgmode.org/worg/org-contrib/org-mac-link.html).
