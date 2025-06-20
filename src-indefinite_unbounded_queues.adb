-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering
-- SPDX-License-Identifier: BSD-3-Clause
-- See https://spdx.org/licenses/
-- If you find this software useful, please let me know, either through
-- github.com/jrcarter or directly to pragmada@pragmada.x10hosting.com
-- **************************************************************************
--
-- indefinite unbounded queues
--
-- History:
-- 2025 Jul 01     J. Carter          V1.1--Use SPDX license format
-- 2023 Aug 01     J. Carter          V1.0--Initial version
--
package body SRC.Indefinite_Unbounded_Queues is
   procedure Assign (To : in out Handle; From : in Handle) is
      -- Empty
   begin -- Assign
      Lists.Assign (Target => To.List, Source => From.List);
   end Assign;

   procedure Clear (Queue : in out Handle) is
      -- Empty
   begin -- Clear
      Lists.Clear (Container => Queue.List);
   end Clear;

   procedure Put (Onto : in out Handle; Item : in Element) is
      -- Empty
   begin -- Put
      Lists.Append (Container => Onto.List, New_Item => Item);
   end Put;

   procedure Remove_Head (From : in out Handle) is
      -- Empty
   begin -- Remove_Head
      Lists.Delete_First (Container => From.List);
   end Remove_Head;

   procedure Iterate (Over : in out Handle) is
      -- Empty
   begin -- Iterate
      All_Elements : for I in 1 .. Lists.Last_Index (Over.List) loop
         Action (Item => Lists.Element (Container => Over.List, Index => I) );
      end loop All_Elements;
   end Iterate;
end SRC.Indefinite_Unbounded_Queues;
