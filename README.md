# SparkRC
SPARK Reusable Components

A couple of useful components to complement the Ada.Containers.Formal_* components: queues and stacks. These can be fully proven correct and free of run-time errors.

prove.ads contains some instantiations of the components for proving.

gnatprove.out contains the results of proving prove.ads with

gnatprove -P src
