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
  - cfengine
  - cheatsheet
  - pcre
  - regex
title: PCRE cheatsheet
---
Although similar to Perl, PCRE has some syntax that can be
difficult to remember. When I'm working with CFEngine I often have to
look it up. Here is a cheat-sheet to save time.

---

<table class='table'>
   <thead>
      <tr>
         <th>Description</th>
         <th>Syntax</th>
         <th>Note</th>
      </tr>
   </thead>
   <tbody>
      <tr>
         <td>Case insensitive</td>
         <td>(?i)</td>
         <td>Place at the beginning of the expression.</td>
      </tr>
      <tr>
         <td>Class</td>
         <td>[ ]</td>
         <td>\d and [0-9-] are equivalent.</td>
      </tr>
      <tr>
         <td>Digit</td>
         <td>\d</td>
         <td>\D for anything that is not a digit.</td>
      </tr>
      <tr>
         <td>Lookahead, negative</td>
         <td>(?!*pattern*</td>
      </tr>
      <tr>
         <td>Lookahead, positive</td>
         <td>(?=*pattern*</td>
      </tr>
      <tr>
         <td>Lookbehind, negative</td>
         <td>(?<!*pattern*</td>
      </tr>
      <tr>
         <td>Lookbehind, positive</td>
         <td>(?<=*pattern*</td>
      </tr>
      <tr>
         <td>None capture grouping</td>
         <td>(?:)Group for logic and selection, but not capture.</td>
      </tr>
      <tr>
         <td>Multi-line match</td>
         <td>(?m)</td>
         <td>Place at the beginning of the expression. Similar to Perl's m//g.</td>
      </tr>
      <tr>
         <td>Extened regex</td>
         <td>(mxs)</td>
         <td>Use this to make your regexes readable. A regex best practice.</td>
      </tr>
      <tr>
         <td>No magic</td>
         <td>\Q \E</td>
         <td>No special meaning to any characters between these.</td>
      </tr>
      <tr>
         <td>Range</td>
         <td>{n,m}</td>
         <td>Minimum of *n*, maximum of *m*.</td>
      </tr>
      <tr>
         <td>Whitespace</td>
         <td>\s</td>
         <td>\S for anything that is not whitespace.</td>
      </tr>
   </tbody>
</table>

### Notes ###

1. Beginning settings are combined. For example (?mi) considers
 multiple lines and is case insensitive.

1. Make your regexes readable by using the extened regex options.
 Consider this:

   (?i)(?:linux|solaris|aix|hpux)

   Versus this:

   (?imsx)(?: linux | solaris | aix | hpux )

Now imagine using it on a very complex regex.
[See here](/blog/2015/08/20/build-better-regular-expressions-in-cfengine/) for
a more complex example.

