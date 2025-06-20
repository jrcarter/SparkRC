-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering
-- SPDX-License-Identifier: BSD-3-Clause
-- See https://spdx.org/licenses/
-- If you find this software useful, please let me know, either through
-- github.com/jrcarter or directly to pragmada@pragmada.x10hosting.com
-- **************************************************************************
--
-- Indefinite unbounded stacks
--
-- History:
-- 2025 Jul 01     J. Carter          V1.1--Use SPDX license format
-- 2023 Sep 01     J. Carter          V1.0--Initial version
--
package body SRC.Unbounded_Stacks is
   procedure Assign (To : in out Handle; From : in Handle) is
      -- Empty
   begin -- Assign
      Lists.Assign (Target => To.List, Source => From.List);
   end Assign;

   procedure Clear (Stack : in out Handle) is
      -- Empty
   begin -- Clear
      Lists.Clear (Container => Stack.List);
   end Clear;

   procedure Push (Onto : in out Handle; Item : in Element) is
      -- Empty
   begin -- Push
      Lists.Append (Container => Onto.List, New_Item => Item);
   end Push;


   procedure Pop (From : in out Handle; Item : out Element) is
      -- Empty
   begin -- Pop
      Item := Lists.Last_Element (From.List);
      Lists.Delete_Last (Container => From.List);
   end Pop;

   procedure Iterate (Over : in out Handle) is
      -- Empty
   begin -- Iterate
      All_Elements : for I in reverse 1 .. Lists.Last_Index (Over.List) loop
         Action (Item => Lists.Element (Container => Over.List, Index => I) );
      end loop All_Elements;
   end Iterate;
end SRC.Unbounded_Stacks;
