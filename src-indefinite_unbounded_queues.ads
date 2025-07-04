-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering
-- SPDX-License-Identifier: BSD-3-Clause
-- See https://spdx.org/licenses/
-- If you find this software useful, please let me know, either through
-- github.com/jrcarter or directly to pragmada@pragmada.x10hosting.com
-- **************************************************************************
--
-- Indefinite unbounded queues
--
-- History:
-- 2025 Jul 01     J. Carter          V1.2--Use SPDX license format
-- 2023 Aug 15     J. Carter          V1.1--Improved contracts
-- 2023 Aug 01     J. Carter          V1.0--Initial version
--
private with Ada.Containers.Formal_Indefinite_Vectors;

generic -- SRC.Indefinite_Unbounded_Queues
   type Element (<>) is private;

   with function "=" (Left : in Element; Right : in Element) return Boolean is <>;

   Max_Size_In_Storage_Elements : Natural;
   -- Maximum size of an Element
package SRC.Indefinite_Unbounded_Queues with SPARK_Mode
is
   type Handle is limited private with Default_Initial_Condition => Is_Empty (Handle);

   procedure Assign (To : in out Handle; From : in Handle) with
      Post => Length (To) = Length (From);
   -- Makes the sequence of Elements in To, from head to tail, the same as the sequence in From

   procedure Clear (Queue : in out Handle) with
      Post => Is_Empty (Queue);
   -- Makes Queue empty
   -- Clear must be called before a Handle goes out of scope in order to avoid storage leaks

   procedure Put (Onto : in out Handle; Item : in Element) with
      Pre  => Count_Type'Pos (Length (Onto) ) < Integer'Pos (Integer'Last),
      Post => Length (Onto) = Length (Onto)'Old + 1;
   -- Adds Item to the tail of Onto

   -- For a Get operation, one needs to call Peek followed by Remove_Head
   -- One could define
   --   function Head (Queue : in out Handle) return Element is
   --      Result : constant Element := Peek (Queue);
   --   begin
   --      Remove_Head (From => Queue);
   --
   --      return Result;
   --   end Head;
   -- But that is not valid SPARK

   procedure Remove_Head (From : in out Handle) with
      Pre  => not Is_Empty (From),
      Post => Length (From) = Length (From)'Old - 1;
   -- Removes the Element at the head of From

   function Length (Queue : in Handle) return Count_Type;
   -- Returns the number of Elements in Queue

   function Is_Empty (Queue : in Handle) return Boolean with
      Post => Is_Empty'Result = (Length (Queue) = 0);
   -- Returns True if Queue is empty; False otherwise

   function Peek (Queue : in Handle) return Element with
      Pre => not Is_Empty (Queue);
   -- Return the Element at the head of Queue

   generic -- Iterate
      with procedure Action (Item : in Element);
   procedure Iterate (Over : in out Handle);
   -- Calls Action with each Element in Over in turn, from head to tail
private -- SRC.Indefinite_Unbounded_Queues
   package Lists is new Ada.Containers.Formal_Indefinite_Vectors (Index_Type                   => Positive,
                                                                  Element_Type                 => Element,
                                                                  Max_Size_In_Storage_Elements => Max_Size_In_Storage_Elements,
                                                                  Bounded                      => False);

   type Handle is record
      List : Lists.Vector (Capacity => 1);
   end record with
      Dynamic_Predicate => Count_Type'Pos (Lists.Length (Handle.List) ) = Integer'Pos (Lists.Last_Index (Handle.List) );

   function Length (Queue : in Handle) return Count_Type is (Lists.Length (Queue.List) );

   function Is_Empty (Queue : in Handle) return Boolean is (Lists.Is_Empty (Queue.List) );

   function Peek (Queue : in Handle) return Element is (Lists.First_Element (Queue.List) );
end SRC.Indefinite_Unbounded_Queues;
