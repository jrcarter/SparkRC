-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering
-- SPDX-License-Identifier: BSD-3-Clause
-- See https://spdx.org/licenses/
-- If you find this software useful, please let me know, either through
-- github.com/jrcarter or directly to pragmada@pragmada.x10hosting.com
-- **************************************************************************
--
-- Bounded queues
--
-- History:
-- 2025 Jul 01     J. Carter          V1.3--Use SPDX license format
-- 2023 Nov 01     J. Carter          V1.2--Functional correctness proofs
-- 2023 Aug 15     J. Carter          V1.1--Improved contracts
-- 2023 Aug 01     J. Carter          V1.0--Initial version
--
private with Ada.Containers.Formal_Doubly_Linked_Lists;

generic -- SRC.Bounded_Queues
   type Element is private;

   with function "=" (Left : in Element; Right : in Element) return Boolean is <>;
package SRC.Bounded_Queues with SPARK_Mode
is
   type Handle (Max_Length : Positive_Count) is private with Default_Initial_Condition => Is_Empty (Handle);

   procedure Clear (Queue : in out Handle) with
      Post => Is_Empty (Queue);
   -- Makes Queue empty

   procedure Put (Onto : in out Handle; Item : in Element) with
      Pre  => Length (Onto) < Onto.Max_Length,
      Post => Length (Onto) = Length (Onto)'Old + 1;
   -- Adds Item to the tail of Onto

   procedure Get (From : in out Handle; Item : out Element) with
      Pre  => not Is_Empty (From),
      Post => Length (From) = Length (From)'Old - 1 and Item = Peek (From)'Old;
   -- Removes the Element at the head of From and assigns it to Item

   function Length (Queue : in Handle) return Count_Type;
   -- Returns the number of Elements in Queue

   function Is_Empty (Queue : in Handle) return Boolean with
      Post => Is_Empty'Result = (Length (Queue) = 0);
   -- Returns True if Queue is empty; False otherwise

   function Peek (Queue : in Handle) return Element with
      Pre => not Is_Empty (Queue);
   -- Return the Element at the head of Queue without altering Queue

   generic -- Iterate
      with procedure Action (Item : in Element);
   procedure Iterate (Over : in out Handle);
   -- Calls Action with each Element in Over in turn, from head to tail
private -- SRC.Bounded_Queues
   package Lists is new Ada.Containers.Formal_Doubly_Linked_Lists (Element_Type => Element);

   type Handle (Max_Length : Positive_Count) is record
      List : Lists.List (Capacity => Max_Length);
   end record;

   function Length (Queue : in Handle) return Count_Type is (Lists.Length (Queue.List) );

   function Is_Empty (Queue : in Handle) return Boolean is (Lists.Is_Empty (Queue.List) );

   function Peek (Queue : in Handle) return Element is (Lists.First_Element (Queue.List) );
end SRC.Bounded_Queues;
