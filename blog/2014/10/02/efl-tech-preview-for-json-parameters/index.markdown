---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
    - content: EFL
      domain: category
      nicename: efl
  post_type: post
  wp_menu_order: 0
  wp_post_id: 1059
  wp_post_name: efl-tech-preview-for-json-parameters
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/efl-tech-preview-for-json-parameters/
date: 2014-10-02 10:30:03
status: published
tags:
  - cfengine
  - EFL
title: EFL tech preview for JSON parameters
---


It's very likely that [EFL](https://github.com/neilhwatson/evolve_cfengine_freelib)
for CFEngine 3.6 will be able to read both CSV and JSON parameter
files. Some EFL users are looking forward to this because some CSV
files have very long lines and are hard to read. On the other hand some
CSV files are short and less cluttered than an equivalent JSON file
would be. At first I tried to transition completely to JSON files, but
upon further consideration EFL will be able to use both. Here's how.

---

The following example creates a CSV and a JSON parameter file with the
same parameters in each, then parses them similar to the current *efl_command
bundle*. The bundle efl_command takes the same input as you are using
now, or a JSON file.

Current CSV parameters

    any   ;; /usr/bin/true  ;; no  ;; no  ;; 1  ;; promisee for true
    # comments more flexible in csv.
    linux ;; /usr/bin/false ;; yes ;; yes ;; 60 ;; promisee for false
          

Upcoming JSON parameters

    [
       {
          "class": "any",
          "command": "/usr/bin/true",
          "useshell": "no",
          "comment": "This is how comments must be in JSON",
          "module": "no",
          "ifelapsed": 1,
          "promisee": "promisee for true"
       },
       {
          "class": "linux",
          "command": "/usr/bin/false",
          "useshell": "yes",
          "module": "yes",
          "ifelapsed": 60,
          "promisee": "promisee for false"
       }
    ]
          

The bundle efl_command will call an additional bundle to parse the
parameter file, but to the you efl_command will work exactly the same
way. You won't have to change your parameter files to transition from
3.5 to 3.6.

Preview policy

    body common control
    {
            bundlesequence => { "main", };
    }
    
    bundle agent main
    {
       methods:
          "create param files for example" usebundle => init( 'testfile' );
    
          parse_json::
             "json"
                usebundle => efl_command( "${sys.workdir}/inputs/testfile.json" );
    
          parse_csv::
             "csv"
                usebundle => efl_command( "${sys.workdir}/inputs/testfile.csv" );
    }
    
    bundle agent efl_command( ref )
    {
       meta:
          "purpose" string => "Run given command if context is true.";
          "field_0" string => "Context";
          "field_1" string => "Command";
          "field_2" string => "usehell";
          "field_3" string => "module";
          "field_4" string => "ifelapsed";
          "field_5" string => "promisee";
    
       vars:
          "p"
             comment => "Prefix to call fq var names from method call bundle",
             string  => "efl_command_parse";
    
       methods:
          'parse data'
             inherit   => 'true',
             usebundle => efl_command_parse( "${ref}" );
    
    ## Demonstrate that command parameters are parsed without 
    ## using an actual commands promise
       reports:
       '
       "${${p}.command[${${p}.i}]}" -> { "${${p}.promisee[${${p}.i}]}" }
          comment    => "Run desired command",
          handle     => "efl_command_commands",
          ifvarclass => "${${p}.class[${${p}.i}]}",
          contain    => contain_efl_command( "${${p}.useshell[${${p}.i}]}" ),
          module     => "${${p}.module[${${p}.i}]}",
          classes    => efl_rkn( "${${p}.command[${${p}.i}]}",
             "efl_command_commands" ),
          action     => efl_delta_reporting( "efl_command_commands",
             "${${p}.command[${${p}.i}]}", "${${p}.promisee[${${p}.i}]}",
             "${${p}.ifelapsed[${${p}.i}]}"); ';
    }
    
    bundle agent efl_command_parse ( ref )
    {
       meta:
          'purpose' string => "Parse data for efl_command via method.";
          'note'    string => "Using a method avoids the loss of a pass.";
    
       vars:
          "ref_canon" string => canonify( "${ref}" );
    
    ## Pasrse CSV files
          "cmd_o"
             comment    => "Read data file for parsing.",
             ifvarclass => "parse_${ref_canon}_as_csv" ,
             data       => data_readstringarrayidx(
                "${ref}",
                "${efl_c.comment}",
                "${efl_c.array_delimiter}",
                "${efl_c.max_num}",
                "${efl_c.max_bytes}"
             );
    
    ## Pasrse JSON files
          "cmd_o"
             ifvarclass => "parse_${ref_canon}_as_json" ,
             data       => readjson( "${ref}", "${efl_c.max_bytes}" );
    
          "i"
             ifvarclass => "parse_${ref_canon}_as_json|parse_${ref_canon}_as_csv",
             slist      => getindices( "cmd_o" );
    
    ## Build final common data array for bundle use and expand internal vars
    ## to work around bug 2333
          "class[${i}]"
             ifvarclass => "parse_${ref_canon}_as_csv",
             string     => "${cmd_o[${i}][0]}";
          "class[${i}]"
             ifvarclass => "parse_${ref_canon}_as_json",
             string     => "${cmd_o[${i}][class]}";
          "command[${i}]"
             ifvarclass => "parse_${ref_canon}_as_csv",
             string     => "${cmd_o[${i}][1]}";
          "command[${i}]"
             ifvarclass => "parse_${ref_canon}_as_json",
             string     => "${cmd_o[${i}][command]}";
          "useshell[${i}]"
             ifvarclass => "parse_${ref_canon}_as_csv",
             string     => "${cmd_o[${i}][2]}";
          "useshell[${i}]"
             ifvarclass => "parse_${ref_canon}_as_json",
             string     => "${cmd_o[${i}][useshell]}";
          "module[${i}]"
             ifvarclass => "parse_${ref_canon}_as_csv",
             string     => "${cmd_o[${i}][3]}";
          "module[${i}]"
             ifvarclass => "parse_${ref_canon}_as_json",
             string     => "${cmd_o[${i}][module]}";
          "ifelapsed[${i}]"
             ifvarclass => "parse_${ref_canon}_as_csv",
             string     => "${cmd_o[${i}][4]}";
          "ifelapsed[${i}]"
             ifvarclass => "parse_${ref_canon}_as_json",
             string     => "${cmd_o[${i}][ifelapsed]}";
          "promisee[${i}]"
             ifvarclass => "parse_${ref_canon}_as_csv",
             string     => "${cmd_o[${i}][5]}";
          "promisee[${i}]"
             ifvarclass => "parse_${ref_canon}_as_json",
             string     => "${cmd_o[${i}][promisee]}";
    
       classes:
          "parse_${ref_canon}_as_json"
             expression => regcmp( ".*\.(json|dat|jsn)", ${ref} );
          "parse_${ref_canon}_as_csv"
             expression => regcmp( ".*\.(txt|csv)", ${ref} );
    }
    
    bundle agent init ( ref )
    {
       meta:
          'purpose' string => "Promise json and csv files for this demonstration";
    
       vars:
          "${ref}_contents[json]" string => '
    [
       {
          "class": "any",
          "command": "/usr/bin/true",
          "useshell": "no",
          "comment": "This is how comments must be in JSON",
          "module": "no",
          "ifelapsed": 1,
          "promisee": "promisee for true"
       },
       {
          "class": "linux",
          "command": "/usr/bin/false",
          "useshell": "yes",
          "module": "yes",
          "ifelapsed": 60,
          "promisee": "promisee for false"
       }
    ]';
          "${ref}_contents[csv]" string => "
    any ;; /usr/bin/true ;; no ;; no ;; 1 ;; promisee for true
    # comments more flexible in csv.
    linux ;; /usr/bin/false ;; yes ;; yes ;; 60 ;; promisee for false
    ";
    
       "i" slist => getindices( '${ref}_contents' );
    
       files:
          "${sys.workdir}/inputs/${ref}.${i}" -> { "Neil H Watson", "EFL" }
             create        => 'true',
             edit_defaults => empty,
             edit_line     => append_if_no_line( "${${ref}_contents[${i}]}" );
    }
    
    body edit_defaults empty
    {
          empty_file_before_editing => "true";
          edit_backup => "false";
    }
    bundle edit_line append_if_no_line(str)
    {
      insert_lines:
          "$(str)";
    }
    
    bundle common efl_c
    {
       meta:
          "purpose" string => "Common configs for all EFL bundles";
    
       vars:
    #
    # Configs for reading data files
    #
          "cache"
             comment => "Location for agent to cache template and other temp files",
             string  => "/var/cache/cfengine";
    
          "class"
             comment => "Regex to extract class name from parameter file name.",
             string  => ".*?-(\w+)\.txt";
    
          "comment"
             comment => "Comment string in data file.",
             string  => "\s*#[^\n]*";
    
          "array_delimiter"
             comment => "Field delimiter for CSV data files read by readstringarrayidx",
             string  => "\s*;;\s*";
    
          "slist_delimiter"
             comment => "Field delimiter for CSV data files read by readstringlist",
             string  => "\s";
    
          "max_num"
             comment => "Maximum number of lines to read from data file",
             int     => "500";
    
          "max_bytes"
             comment => "Maximum number of bytes to read from data file.",
             string  => "1M";
    
    }
          

Policy in action ` `

    neil@ettin ~/.cfagent/inputs $ cf-agent -Kf ./efl36.cf -D parse_csv
    R: 
       "/usr/bin/true" -> { "promisee for true" }
          comment    => "Run desired command",
          handle     => "efl_command_commands",
          ifvarclass => "any",
          contain    => contain_efl_command( "no" ),
          module     => "no",
          classes    => efl_rkn( "/usr/bin/true",
             "efl_command_commands" ),
          action     => efl_delta_reporting( "efl_command_commands",
             "/usr/bin/true", "promisee for true",
             "1"); 
    R: 
       "/usr/bin/false" -> { "promisee for false" }
          comment    => "Run desired command",
          handle     => "efl_command_commands",
          ifvarclass => "linux",
          contain    => contain_efl_command( "yes" ),
          module     => "yes",
          classes    => efl_rkn( "/usr/bin/false",
             "efl_command_commands" ),
          action     => efl_delta_reporting( "efl_command_commands",
             "/usr/bin/false", "promisee for false",
             "60"); 
    
    neil@ettin ~/.cfagent/inputs $ cf-agent -Kf ./efl36.cf -D parse_json
    R: 
       "/usr/bin/true" -> { "promiser for true" }
          comment    => "Run desired command",
          handle     => "efl_command_commands",
          ifvarclass => "any",
          contain    => contain_efl_command( "no" ),
          module     => "no",
          classes    => efl_rkn( "/usr/bin/true",
             "efl_command_commands" ),
          action     => efl_delta_reporting( "efl_command_commands",
             "/usr/bin/true", "promiser for true",
             "1"); 
    R: 
       "/usr/bin/false" -> { "promiser for false" }
          comment    => "Run desired command",
          handle     => "efl_command_commands",
          ifvarclass => "linux",
          contain    => contain_efl_command( "yes" ),
          module     => "yes",
          classes    => efl_rkn( "/usr/bin/false",
             "efl_command_commands" ),
          action     => efl_delta_reporting( "efl_command_commands",
             "/usr/bin/false", "promiser for false",
             "60"); 
          

Once CFEngine 3.6 stabilizes look for updates in [EFL](https://github.com/neilhwatson/evolve_cfengine_freelib).
In the mean time I recommend you stick with EFL's 3.5 branch and
CFEngine 3.5.
