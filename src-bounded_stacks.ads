-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering
-- SPDX-License-Identifier: BSD-3-Clause
-- See https://spdx.org/licenses/
-- If you find this software useful, please let me know, either through
-- github.com/jrcarter or directly to pragmada@pragmada.x10hosting.com
-- **************************************************************************
--
-- Bounded stacks
--
-- History:
-- 2025 Jul 01     J. Carter          V1.3--Use SPDX license format
-- 2023 Nov 01     J. Carter          V1.2--Functional correctness proofs
-- 2023 Aug 15     J. Carter          V1.1--Improved contracts
-- 2023 Aug 01     J. Carter          V1.0--Initial version
--
private with Ada.Containers.Formal_Doubly_Linked_Lists;

generic -- SRC.Bounded_Stacks
   type Element is private;

   with function "=" (Left : in Element; Right : in Element) return Boolean is <>;
package SRC.Bounded_Stacks with SPARK_Mode
is
   type Handle (Max_Length : Positive_Count) is private with Default_Initial_Condition => Is_Empty (Handle);

   procedure Clear (Stack : in out Handle) with
      Post => Is_Empty (Stack);
   -- Makes Stack empty

   procedure Push (Onto : in out Handle; Item : in Element) with
      Pre  => Length (Onto) < Onto.Max_Length,
      Post => Length (Onto) = Length (Onto)'Old + 1;
   -- Adds Item to the top of Onto

   procedure Pop (From : in out Handle; Item : out Element) with
      Pre  => not Is_Empty (From),
      Post => Length (From) = Length (From)'Old - 1 and Item = Peek (From)'Old;
   -- Removes the Element at the top of From and assigns it to Item

   function Length (Stack : in Handle) return Count_Type;
   -- Returns the number of Elements in Stack

   function Is_Empty (Stack : in Handle) return Boolean with
      Post => Is_Empty'Result = (Length (Stack) = 0);
   -- Returns True if Stack is empty; False otherwise

   function Peek (Stack : in Handle) return Element with
      Pre => not Is_Empty (Stack);
   -- Return the Element at the top of Stack without altering Stack

   generic -- Iterate
      with procedure Action (Item : in Element);
   procedure Iterate (Over : in out Handle);
   -- Calls Action with each Element in Over in turn, from top to bottom
private -- SRC.Bounded_Stacks
   package Lists is new Ada.Containers.Formal_Doubly_Linked_Lists (Element_Type => Element);

   type Handle (Max_Length : Positive_Count) is record
      List : Lists.List (Capacity => Max_Length);
   end record;

   function Length (Stack : in Handle) return Count_Type is (Lists.Length (Stack.List) );

   function Is_Empty (Stack : in Handle) return Boolean is (Lists.Is_Empty (Stack.List) );

   function Peek (Stack : in Handle) return Element is (Lists.Last_Element (Stack.List) );
end SRC.Bounded_Stacks;
