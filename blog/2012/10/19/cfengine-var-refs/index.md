---
title: Variable references with Cfengine
tags: cfengine
---

Variables in Cfengine can be confusing at times. Here are some examples of
variable references. References are not strictly required, but they are good
practice like using the strict module in Perl.

---

bundle agent main {

   vars:
      "meta_purpose" string => "Demonstrate references";

      "my_scalar" string       => "This is a scalar typed as astring";
      "my_list" slist          => { "one", "two", "three" };
      "my_array[red]" string   => "Red element of associative array";
      "my_array[blue]" string  => "Blue element of associative array";
      "my_array[green]" string => "Green element of associative array";

   methods:
      "any" usebundle => test(
         "main.my_scalar",
         "main.my_list",
         "main.my_array"
         );
}

bundle agent test(scalarref, listref, arrayref) {

   vars:
      "local_scalar"
         string => "${${scalarref}}";

      "local_list"
         slist => { "@{${listref}}" };

      "arrayref_index"
         slist => getindices("${arrayref}");

      "local_array[${arrayref_index}]"
         string => "${${arrayref}[${arrayref_index}]}";

      "local_array_index"
         policy => 'free',
         slist => getindices("local_array");

   reports:
      cfengine::
         "scalarref         => ${${scalarref}}";
         "local_scalar      => ${local_scalar}";
         "local_list        => ${local_list}";
         "arrayref_index    => ${arrayref_index}";
         "arrayref item     => ${${arrayref}[${arrayref_index}]}";
         "local_array_index => ${local_array_index}";
         "local_array item  => ${local_array[${local_array_index}]}";
}

Now let's run it:

$ cf-agent -f ./references.cf 
R: scalarref         => This is a scalar typed as astring
R: local_scalar      => This is a scalar typed as astring
R: local_list        => one
R: local_list        => two
R: local_list        => three
R: arrayref_index    => red
R: arrayref_index    => blue
R: arrayref_index    => green
R: arrayref item     => Red element of associative array
R: arrayref item     => Blue element of associative array
R: arrayref item     => Green element of associative array
R: local_array_index => green
R: local_array_index => red
R: local_array_index => blue
R: local_array item  => Green element of associative array
R: local_array item  => Red element of associative array
R: local_array item  => Blue element of associative array


