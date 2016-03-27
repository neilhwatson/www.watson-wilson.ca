---
author: nwatson
data:
  categories:
    - content: best practices
      domain: category
      nicename: best-practices
    - content: Cfengine
      domain: category
      nicename: cfengine
    - content: pcre
      domain: category
      nicename: pcre
    - content: regex
      domain: category
      nicename: regex
  post_type: post
  wp_menu_order: 0
  wp_post_id: 1136
  wp_post_name: build-better-regular-expressions-in-cfengine
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/build-better-regular-expressions-in-cfengine/
date: 2015-08-20 21:51:58
status: published
tags:
  - best practices
  - Cfengine
  - pcre
  - regex
title: Build better regular expressions in CFEngine
---
![picture of a regex](/static/images/regex.png)

Regular expressions can vary from simple to WTF. Usually they tend
toward the latter. What most don't realized, or are too lazy to use, is
that regular expressions can be made to include friendly whitespace and
comments. CFEngine is no exception.

---

Let's look at an example regular expression and policy to match IP
addresses. This is a non-trivial expression. (Thanks to the Perl module
[Regexp::Common::net](https://metacpan.org/pod/Regexp::Common::net) for
my regex source). In this example I match a list of three IP addresses
against the regex and set a class for each match. Reports promises
produce a TAP output (ok) if there was a match. First let's see the
horrific regular expression.

``

    body common control
    {
            bundlesequence => { "main", };
    }
    
    bundle agent main
    {
       vars:
          "ips" slist => { "10.0.0.1", "192.168.0.1", "172.16.233.255" };
    
       classes:
          "match_${ips}"
             comment    => "Oh, the horror!",
             expression => regcmp( 
    "(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})",
                ${ips}
                );
    
          reports:
             "1..3";
             "ok 1 - Match 10.0.0.1"
                if => canonify( "match_10.0.0.1" );
             "not ok 1 - Match 10.0.0.1"
                if => not( canonify( "match_10.0.0.1" ));
             "ok 1 - Match 192.168.0.1"
                if => canonify( "match_192.168.0.1" );
             "not ok 1 - Match 192.168.0.1"
                if => not( canonify( "match_192.168.0.1" ));
             "ok 1 - Match 172.16.233.255"
                if => canonify( "match_172.16.233.255" );
             "not ok 1 - Match 172.16.233.255"
                if => not( canonify( "match_172.16.233.255" ));
    }

You'd rather insult Chuck Norris' wife than read that regex. But, it
actually works:

``

    R: 1..3
    R: ok 1 - Match 10.0.0.1
    R: ok 1 - Match 192.168.0.1
    R: ok 1 - Match 172.16.233.255

Now, let's lessen the stress, pain, and wrath of the future maintainers
of our code. Here we use the setting (?mxs) (Note that the mxs can be
in any order so long as the question mark is first) which allows us to
spread the regex over multiple lines and add comments because # and
white space are ignored by the regex parser. This is not CFEngine
magic, but part of PCRE.

``

    body common control
    {
            bundlesequence => { "main", };
    }
    
    bundle agent main
    {
       vars:
          "ips" slist => { "10.0.0.1", "192.168.0.1", "172.16.233.255" };
    
       classes:
          "match_${ips}"
             comment    => "I deserve a raise for this.",
             expression => regcmp( 
             "(?xms)
                # First octet 
                (?:
                   25[0-5]            # Remember ips go as high as 255.
                   |                  # or
                   2[0-4][0-9]        # Between 200 and 249.
                   |                  # or
                   [0-1]?[0-9]{1,2}   # Less than 200.
                ) 
                [.]                   # Decimal point
    
                # Second octet 
                (?:
                   25[0-5]            # Remember ips go as high as 255.
                   |                  # or
                   2[0-4][0-9]        # Between 200 and 249.
                   |                  # or
                   [0-1]?[0-9]{1,2}   # Less than 200.
                ) 
                [.]                   # Decimal point
                # Third octet 
                (?:
                   25[0-5]            # Remember ips go as high as 255.
                   |                  # or
                   2[0-4][0-9]        # Between 200 and 249.
                   |                  # or
                   [0-1]?[0-9]{1,2}   # Less than 200.
                ) 
                [.]                   # Decimal point
                # Forth octet 
                (?:
                   25[0-5]            # Remember ips go as high as 255.
                   |                  # or
                   2[0-4][0-9]        # Between 200 and 249.
                   |                  # or
                   [0-1]?[0-9]{1,2}   # Less than 200.
                ) 
             ",
                ${ips}
                );
    
          reports:
             "1..3";
             "ok 1 - Match 10.0.0.1"
                if => canonify( "match_10.0.0.1" );
             "not ok 1 - Match 10.0.0.1"
                if => not( canonify( "match_10.0.0.1" ));
             "ok 1 - Match 192.168.0.1"
                if => canonify( "match_192.168.0.1" );
             "not ok 1 - Match 192.168.0.1"
                if => not( canonify( "match_192.168.0.1" ));
             "ok 1 - Match 172.16.233.255"
                if => canonify( "match_172.16.233.255" );
             "not ok 1 - Match 172.16.233.255"
                if => not( canonify( "match_172.16.233.255" ));
    }

That's much nicer and it produces the same results. Also notice the use
non-capture groups (?:). This is good practice in regular expression to
avoid unwanted captures.

Note that because (?msx) ignores whitespace you'll have to use *\s* and
perhaps modifiers to express any whitespace, including new lines.

I encourage you to use (?mxs) in all your regular expressions. Be
considerate of your fellows and your future shelf. Make you regexes
readable and documented just as you would your other code (your other
code is pretty isn't!?).

### Further reading ###

  * [PCRE Pattern man page](http://www.pcre.org/current/doc/html/pcre2pattern.html)

  * [Mastering Regular Expressions](http://shop.oreilly.com/product/9780596528126.do)

  * [PCRE cheatsheet](/pcre-cheatsheet/)
