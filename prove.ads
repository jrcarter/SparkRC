-- Instantiations of SRCs for proof purposes
-- Copyright (C) by PragmAda Software Engineering.  All rights reserved.
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses
--
with SRC.Bounded_Queues;
with SRC.Bounded_Stacks;
with SRC.Indefinite_Ordered_Searchable;
with SRC.Indefinite_Unbounded_Queues;
with SRC.Indefinite_Unbounded_Stacks;
with SRC.Unbounded_Ordered_Maps;

package Prove with SPARK_Mode
is
   --  -- Prove instances with an Elementary subtype
   package E_B_Queues is new SRC.Bounded_Queues (Element => Integer);
   package E_B_Stacks is new SRC.Bounded_Stacks (Element => Integer);
   package E_U_Queues is new SRC.Indefinite_Unbounded_Queues (Element => Integer, Max_Size_In_Storage_Elements => 4);
   package E_U_Stacks is new SRC.Indefinite_Unbounded_Stacks (Element => Integer, Max_Size_In_Storage_Elements => 4);
   package E_U_Search is new SRC.Indefinite_Ordered_Searchable (Element => Integer, Max_Size_In_Storage_Elements => 4);
   package E_U_Maps is new SRC.Unbounded_Ordered_Maps (Key_Info                     => Integer,
                                                       Value_Info                   => Integer,
                                                       Dummy_Value                  => 0,
                                                       Max_Size_In_Storage_Elements => 8);

   -- Prove instances with a Constrained Array subtype
   subtype CA is String (1 .. 256);

   package CA_B_Queues is new SRC.Bounded_Queues (Element => CA);
   package CA_B_Stacks is new SRC.Bounded_Stacks (Element => CA);
   package CA_U_Queues is new SRC.Indefinite_Unbounded_Queues (Element => CA, Max_Size_In_Storage_Elements => 256);
   package CA_U_Stacks is new SRC.Indefinite_Unbounded_Stacks (Element => CA, Max_Size_In_Storage_Elements => 256);
   package CA_U_Search is new SRC.Indefinite_Ordered_Searchable (Element => CA, Max_Size_In_Storage_Elements => 256);
   package CA_U_Maps is new SRC.Unbounded_Ordered_Maps (Key_Info                     => CA,
                                                        Value_Info                   => Integer,
                                                        Dummy_Value                  => 0,
                                                        Max_Size_In_Storage_Elements => 260);

   -- Prove instances with an Unconstrained Record subtype
   subtype Small is Integer range 0 .. 256;

   type UR (L : Small := 0) is record
      S : String (1 .. L);
   end record;

   function "<" (Left : in UR; Right : in UR) return Boolean is (Left.S < Right.S);

   package UR_U_Queues is new SRC.Indefinite_Unbounded_Queues (Element => UR, Max_Size_In_Storage_Elements => 260);
   package UR_U_Stacks is new SRC.Indefinite_Unbounded_Stacks (Element => UR, Max_Size_In_Storage_Elements => 260);
   package UR_U_Search is new SRC.Indefinite_Ordered_Searchable (Element => UR, Max_Size_In_Storage_Elements => 260);

   -- Prove instances with a Constrained Record subtype containing an unconstrained record component
   type CR is record
      U : UR;
   end record;

   function "<" (Left : in CR; Right : in CR) return Boolean is (Left.U.S < Right.U.S);

   package CR_B_Queues is new SRC.Bounded_Queues (Element => CR);
   package CR_B_Stacks is new SRC.Bounded_Stacks (Element => CR);
   package CR_U_Queues is new SRC.Indefinite_Unbounded_Queues (Element => CR, Max_Size_In_Storage_Elements => 260);
   package CR_U_Stacks is new SRC.Indefinite_Unbounded_Stacks (Element => CR, Max_Size_In_Storage_Elements => 260);
   package CR_U_Search is new SRC.Indefinite_Ordered_Searchable (Element => CR, Max_Size_In_Storage_Elements => 260);
   package CR_U_Maps is new SRC.Unbounded_Ordered_Maps (Key_Info                     => CR,
                                                        Value_Info                   => Integer,
                                                        Dummy_Value                  => 0,
                                                        Max_Size_In_Storage_Elements => 264);
end Prove;
