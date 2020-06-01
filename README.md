# plan-monitor
Compile tasks of daily living into Behavior Trees and interactively executes them.  Pure Perl using Mojolicious.

This software presently does nothing, please do not install it until a
later version, which we will upload ASAP.  We are releasing early and
often in order to successfully release this system.  It is part of the
FRDCSA (https://frdcsa.org), which has historically had trouble being
released properly.                                                                                                                                                                                                                                                                                                             

This system will take recommendations such as for instance the
CDC/WHO's guidelines related to the COVID-19 pandemic, and compiles
them into a Behavior Tree specification that can interactively walk
people through tasks via something like a mobile phone's web-browser.

For instance, the user enters into the interface a task such as 'go to
the grocery store'.  The corresponding procedure is found, and the
user is walked through this procedure, like an interactive checklist
that can branch based on results of tasks.

For more info on how this is supposed to work see this paper:

https://github.com/aindilis/plan-monitor/blob/master/lib/FRDCSA/PlanMonitor/behavior-tree-task-manager-for-covid-19.pdf
