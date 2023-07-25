-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering.  All rights reserved.
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses
-- **************************************************************************
--
-- Root package for SPARK Reusable Components
--
-- History:
-- 2023 Aug 01     J. Carter          V1.0--Initial version
--
with Ada.Containers;

package SRC with SPARK_Mode
is
   subtype Positive_Count is Ada.Containers.Count_Type range 1 .. Ada.Containers.Count_Type'Last;
   use type Positive_Count;
end SRC;
