---
title: Dynamic bundlesequence in Cfengine
tags: cfengine, cfengine cookbook, configuration management
---

Problem

You want to have your bundlesequence change based on class.

---

Solution

This question comes up regularly on the Cfengine mailing list. The secret is to build a string list based on class. The alternative is to use methods.

bundle common g {
    vars:

        any::

            "bseq" slist => {
                "site",
                "ntp",
                "hard"
            },
            policy => "free";

        cf_dbs::

            "bseq" slist => {
                @{bseq},
                "db2",
                "mysql"
            },
            policy => "free";

        cf_webfarm::

            "bseq" slist => {
                @{bseq},
                "httpd",
                "proxy"
            },
            policy => "free";
}

body common control {

    bundlesequence => { "@{g.bseq}" };

}

bundle agent site{
    reports:
        cfengine_3::
            "site bundle";
}
bundle agent ntp{
    reports:
        cfengine_3::
            "ntp bundle";
}
bundle agent hard{
    reports:
        cfengine_3::
            "hard bundle";
}
bundle agent db2{
    reports:
        cfengine_3::
            "db2 bundle";
}
bundle agent mysql{
    reports:
        cfengine_3::
            "mysql bundle";
}
bundle agent httpd{
        reports:
            cfengine_3::
                "httpd bundle";
}
bundle agent proxy{
        reports:
            cfengine_3::
                "proxy bundle";
}

Although left out here for brevity, under normal conditions you would have a classes section in the common g bundle to define what hosts belong to the classes cf_dbs and cf_webfarm. In the vars section you can see how we build upon the default bseq list first defined for the any class. The policy body part allows us to redefine the variable. By default Cfengine does not allow variable values to be changed.

Please note that due to normal ordering vars promises are evaluated before classes promises. So the custom classes cf_dbs and cf_webfarm must be declared in a common bundle above the common g bundle. For example:


bundle common classes {
   classes:

      "cf_dbs" or => { "hosta", "hostb", "hostc" };

}
bundle common g {
    vars:

        any::

            "bseq" slist => {
                "site",
                "ntp",
                "hard"
            },
            policy => "free";

        cf_dbs::

            "bseq" slist => {
                @{bseq},
                "db2",
                "mysql"
            },
            policy => "free";
..

For this exercise we can set the classes manually using the -D command switch. Below you can see how the bundle sequence changes for each class starting with the default any class.


neil@ettin ~/.cfagent/inputs $ cf-agent -f ./recipe.cf
R: site bundle
R: ntp bundle
R: hard bundle
neil@ettin ~/.cfagent/inputs $ cf-agent -KD cf_dbs -f ./recipe.cf
R: site bundle
R: ntp bundle
R: hard bundle
R: db2 bundle
R: mysql bundle
neil@ettin ~/.cfagent/inputs $ cf-agent -KD cf_webfarm -f ./recipe.cf
R: site bundle
R: ntp bundle
R: hard bundle
R: httpd bundle
R: proxy bundle

People do this with inputs too. If your inputs holds secret information like passwords this can be useful.

An alternative method to a dynamic bundle sequence is to use methods.


body common control {

    bundlesequence => { "main" };

}

bundle agent main{

    methods:

        any::

            "any" usebundle => site;
            "any" usebundle => ntp;
            "any" usebundle => hard;

        cf_dbs::

            "cf_dbs" usebundle => db2;
            "cf_dbs" usebundle => mysql;

        cf_webfarm::

            "cf_dbs" usebundle => httpd;
            "cf_dbs" usebundle => proxy;
}

bundle agent site{
    reports:
        cfengine_3::
            "site bundle";
}
bundle agent ntp{
    reports:
        cfengine_3::
            "ntp bundle";
}
bundle agent hard{
    reports:
        cfengine_3::
            "hard bundle";
}
bundle agent db2{
    reports:
        cfengine_3::
            "db2 bundle";
}
bundle agent mysql{
    reports:
        cfengine_3::
            "mysql bundle";
}
bundle agent httpd{
        reports:
            cfengine_3::
                "httpd bundle";
}
bundle agent proxy{
        reports:
            cfengine_3::
                "proxy bundle";
}

The result is exactly the same. However using methods allows you to pass parameters to the bundles. Also you can define your classes for cf_dbs and cf_webfarms in the same main bundle. For example:


body common control {

    bundlesequence => { "main" };

}
bundle agent main{

    vars:

        cf_dbs1::
            
            "db2_version" string => "9.1";

        cf_dbs2::
            
            "db2_version" string => "9.2";
            
    classes:

        "cf_dbs1" or => { "dbhost1", "dbhost2", "dbhost3" };
        "cf_dbs2" or => { "dbhost4", "dbhost5", "dbhost6" };
        "cf_dbs" or => { "cf_dbs1", "cf_dbs2" };

    methods:

        any::

            "any" usebundle => site;
            "any" usebundle => ntp;
            "any" usebundle => hard;

        cf_dbs::

            "cf_dbs" usebundle => db2( "${db2_version}" );
            "cf_dbs" usebundle => mysql;

}

bundle agent site{
    reports:
        cfengine_3::
            "site bundle";
}
bundle agent ntp{
    reports:
        cfengine_3::
            "ntp bundle";
}
bundle agent hard{
    reports:
        cfengine_3::
            "hard bundle";
}
bundle agent db2(version){
    reports:
        cfengine_3::
            "db2 bundle ${version}";
}
bundle agent mysql{
    reports:
        cfengine_3::
            "mysql bundle";
}

Here we define groups of database host classes. Hosts with the hostname dbhost1 to dbhost3 are members of the cf_dbs1 class. Members of that class have the db2_version string set to 9.1. Using classes we not only determine which bundles are run but what parameters can be passed to them.


neil@ettin ~/.cfagent/inputs $ cf-agent -Kf ./recipe.cf
R: site bundle
R: ntp bundle
R: hard bundle
neil@ettin ~/.cfagent/inputs $ cf-agent -D dbhost1 -Kf ./recipe.cf
R: site bundle
R: ntp bundle
R: hard bundle
R: db2 bundle 9.1
R: mysql bundle
neil@ettin ~/.cfagent/inputs $ cf-agent -D dbhost4 -Kf ./recipe.cf
R: site bundle
R: ntp bundle
R: hard bundle
R: db2 bundle 9.2
R: mysql bundle


