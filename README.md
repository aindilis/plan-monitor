# plan-monitor
This software presently implements a barebones real-time web-based
interactive behavior tree plan monitor.

This system will take recommendations (such as for instance the
CDC/WHO's guidelines related to the COVID-19 pandemic) compiled into a
behavior tree specification, and interactively walks people through
tasks most likely from a mobile phone's web-browser.

Eventually, the user will be able to enter into the interface a task
such as 'go to the grocery store' and the corresponding procedure wll
be found.  The user will then be walked through this procedure, like
an interactive checklist that can branch based on results of tasks.

Currently, there is a default behavior tree specified in the Users
model, which the user will be walked through.  We are working to
expand the kinds of behavior tree nodes available, the loading and
context switching mechanism, etc.

We are releasing early and
often in order to successfully release this system.  It is part of the
FRDCSA (https://frdcsa.org), but designed to be independent of any
existing (unreleased) FRDCSA libraries to make it easier to install.

For more info on how this is supposed to work see this paper:

https://github.com/aindilis/plan-monitor/blob/master/lib/FRDCSA/PlanMonitor/behavior-tree-task-manager-for-covid-19.pdf

Here are the links from that paper:

https://frdcsa.org/bts-covid-19/links.html

Here is a more recent video (at the time of writing):

https://frdcsa.org/~andrewdo/projects/plan-monitor-voice.webm

And here is a video of an earlier version in action:

https://frdcsa.org/~andrewdo/projects/plan-monitor.webm

# Installation

Please note these install instructions will be improved when the system has been properly released on CPAN.

First download packages

```
sudo cpanm https://github.com/aindilis/plan-monitor/raw/master/plan-monitor-0.01.tar.gz
sudo cpanm https://github.com/aindilis/perl-btpm/raw/master/perl-btpm-0.01.tar.gz
sudo cpanm https://github.com/aindilis/perl-btsk/blob/master/perl-btsk-0.01.tar.gz 
```

Then install all dependencies (e.g. sudo cpanm Mojolicious; sudo cpanm Class::MethodMaker; etc).  I don't yet have the list of all dependencies ready.

Then, clone the https://github.com/aindilis/plan-monitor/ repository, and in it's root directory, run:

```
./debug.sh
```
