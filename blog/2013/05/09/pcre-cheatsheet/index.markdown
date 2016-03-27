---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
    - content: cheatsheet
      domain: category
      nicename: cheatsheet
    - content: pcre
      domain: category
      nicename: pcre
    - content: regex
      domain: category
      nicename: regex
  post_type: post
  wp_menu_order: 0
  wp_post_id: 127
  wp_post_name: pcre-cheatsheet
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/pcre-cheatsheet/
date: 2013-05-09 10:47:41
status: published
tags:
  - Cfengine
  - cheatsheet
  - pcre
  - regex
title: PCRE cheatsheet
---
Although similar to Perl, PCRE has some syntax that can be
difficult to remember. When I'm working with CFEngine I often have to
look it up. Here is a cheat-sheet to save time.

---

**Description **

** Syntax **

** Note**

Case insensitive

(?i)

Place at the beginning of the expression.

Class

[ ]

\d and [0-9-] are equivalent.

Digit

\d

\D for anything that is not a digit.

Lookahead, negative

(?!*pattern*

Lookahead, positive

(?=*pattern*

Lookbehind, negative

(?<!*pattern*

Lookbehind, positive

(?<=*pattern*

None capture grouping

(?:)

Group for logic and selection, but not capture.

Multi-line match

(?m)

Place at the beginning of the expression. Similar to Perl's m//g.

Extened regex

(mxs)

Use this to make your regexes readable. A regex best practice.

No magic

\Q \E

No special meaning to any characters between these.

Range

{n,m}

Minimum of *n*, maximum of *m*.

Whitespace

\s

\S for anything that is not whitespace.


### Notes ###

  1. Beginning settings are combined. For example (?mi) considers
    multiple lines and is case insensitive.

  2. Make your regexes readable by using the extened regex options.
    Consider this: `

              (?i)(?:linux|solaris|aix|hpux)
           

    ` Versus this: `

              (?imsx)(?: linux | solaris | aix | hpux )
           

    `

    Now imagine using it on a very complex regex.
