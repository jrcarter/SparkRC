# SparkRC
SPARK Reusable Components

A couple of useful components to complement the Ada.Containers.Formal_* components: queues and stacks. These can be fully proven correct and free of run-time errors.

The unbounded versions are limited to Integer'Last Elements due to the use of Positive for the index of the underlying vector. This should be adequate for most uses. The index subtype may be changed if a larger limit is needed.

The unbounded forms are a little more difficult, due to the need for a function to return an object of an indefinite type (an **out** parameter may have the wrong constraint for the returned value) and a procedure to remove the object returned by the function (a SPARK function cannot have **in out** parameters). See the comments in the package specifications.

prove.ads contains some instantiations of the components for proving.

gnatprove.out contains the results of proving prove.ads with

gnatprove -P src
