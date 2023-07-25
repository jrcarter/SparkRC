-- Instantiations of SRCs for proof purposes
-- Copyright (C) by PragmAda Software Engineering.  All rights reserved.
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses
--
with SRC.Bounded_Queues;
with SRC.Bounded_Stacks;

package Prove with SPARK_Mode
is
   -- Prove instances with an Elementary subtype
   package E_Queues is new SRC.Bounded_Queues (Element => Integer);
   package E_Stacks is new SRC.Bounded_Stacks (Element => Integer);

   -- Prove instances with a Constrained Array subtype
   subtype CA is String (1 .. 256);

   package CA_Queues is new SRC.Bounded_Queues (Element => CA);
   package CA_Stacks is new SRC.Bounded_Stacks (Element => CA);

   -- Prove instances with a Constrained Record subtype containing an unconstrained record component
   subtype Small is Integer range 0 .. 256;

   type UR (L : Small := 0) is record
      S : String (1 .. L);
   end record;

   type CR is record
      U : UR;
   end record;

   package CR_Queues is new SRC.Bounded_Queues (Element => CR);
   package CR_Stacks is new SRC.Bounded_Stacks (Element => CR);
end Prove;
