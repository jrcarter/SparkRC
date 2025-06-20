-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering
-- SPDX-License-Identifier: BSD-3-Clause
-- See https://spdx.org/licenses/
-- If you find this software useful, please let me know, either through
-- github.com/jrcarter or directly to pragmada@pragmada.x10hosting.com
-- **************************************************************************
--
-- Unbounded, ordered maps
--
-- History:
-- 2025 Jul 01     J. Carter          V1.1--Use SPDX license format
-- 2023 Aug 15     J. Carter          V1.0--Initial version
--
package body SRC.Unbounded_Ordered_Maps is
   procedure Assign (To : in out Handle; From : in Handle) is
      -- Empty
   begin -- Assign
      Lists.Assign (To => To.List, From => From.List);
   end Assign;

   procedure Clear (Map : in out Handle) is
      -- Empty
   begin -- Clear
      Lists.Clear (Set => Map.List);
   end Clear;

   procedure Insert (Into : in out Handle; Key : in Key_Info; Value : in Value_Info) is
      -- Empty
   begin -- Insert
      Lists.Insert (Into => Into.List, Item => (Key => Key, Value => Value) );
   end Insert;

   procedure Update (Into : in out Handle; Key : in Key_Info; Value : in Value_Info) is
      -- Empty
   begin -- Update
      Lists.Update (Into => Into.List, Item => (Key => Key, Value => Value) );
   end Update;

   procedure Delete (From : in out Handle; Key : in Key_Info) is
      -- Empty
   begin -- Delete
      Lists.Delete (From => From.List, Item => (Key => Key, Value => Dummy_Value) );
   end Delete;

   procedure Iterate (Over : in out Handle) is
      procedure Action (Item : in Pair);
      -- Calls the supplied Action with the components of Item

      procedure Local is new Lists.Iterate (Action => Action);

      procedure Action (Item : in Pair) is
         -- Empty
      begin -- Action
         Action (Key => Item.Key, Value => Item.Value);
      end Action;
   begin -- Iterate
      Local (Over => Over.List);
   end Iterate;
end SRC.Unbounded_Ordered_Maps;
