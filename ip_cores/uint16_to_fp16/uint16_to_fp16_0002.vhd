-- ------------------------------------------------------------------------- 
-- High Level Design Compiler for Intel(R) FPGAs Version 23.1std (Release Build #993)
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2024 Intel Corporation.  All rights reserved.
-- Your use of  Intel Corporation's design tools,  logic functions and other
-- software and  tools, and its AMPP partner logic functions, and any output
-- files any  of the foregoing (including  device programming  or simulation
-- files), and  any associated  documentation  or information  are expressly
-- subject  to the terms and  conditions of the  Intel FPGA Software License
-- Agreement, Intel MegaCore Function License Agreement, or other applicable
-- license agreement,  including,  without limitation,  that your use is for
-- the  sole  purpose of  programming  logic devices  manufactured by  Intel
-- and  sold by Intel  or its authorized  distributors. Please refer  to the
-- applicable agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from uint16_to_fp16_0002
-- VHDL created on Thu Apr  3 03:06:53 2025


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY altera_lnsim;
USE altera_lnsim.altera_lnsim_components.altera_syncram;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity uint16_to_fp16_0002 is
    port (
        a : in std_logic_vector(15 downto 0);  -- ufix16
        q : out std_logic_vector(15 downto 0);  -- float16_m10
        clk : in std_logic;
        areset : in std_logic
    );
end uint16_to_fp16_0002;

architecture normal of uint16_to_fp16_0002 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal maxCount_uid7_fxpToFPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal inIsZero_uid8_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal msbIn_uid9_fxpToFPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal expPreRnd_uid10_fxpToFPTest_a : STD_LOGIC_VECTOR (5 downto 0);
    signal expPreRnd_uid10_fxpToFPTest_b : STD_LOGIC_VECTOR (5 downto 0);
    signal expPreRnd_uid10_fxpToFPTest_o : STD_LOGIC_VECTOR (5 downto 0);
    signal expPreRnd_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal expFracRnd_uid12_fxpToFPTest_q : STD_LOGIC_VECTOR (16 downto 0);
    signal sticky_uid16_fxpToFPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal sticky_uid16_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal nr_uid17_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rnd_uid18_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expFracR_uid20_fxpToFPTest_a : STD_LOGIC_VECTOR (18 downto 0);
    signal expFracR_uid20_fxpToFPTest_b : STD_LOGIC_VECTOR (18 downto 0);
    signal expFracR_uid20_fxpToFPTest_o : STD_LOGIC_VECTOR (18 downto 0);
    signal expFracR_uid20_fxpToFPTest_q : STD_LOGIC_VECTOR (17 downto 0);
    signal fracR_uid21_fxpToFPTest_in : STD_LOGIC_VECTOR (10 downto 0);
    signal fracR_uid21_fxpToFPTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal expR_uid22_fxpToFPTest_b : STD_LOGIC_VECTOR (6 downto 0);
    signal udf_uid23_fxpToFPTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal udf_uid23_fxpToFPTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal udf_uid23_fxpToFPTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal udf_uid23_fxpToFPTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal expInf_uid24_fxpToFPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal ovf_uid25_fxpToFPTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal ovf_uid25_fxpToFPTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal ovf_uid25_fxpToFPTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal ovf_uid25_fxpToFPTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal excSelector_uid26_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracZ_uid27_fxpToFPTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal fracRPostExc_uid28_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostExc_uid28_fxpToFPTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal udfOrInZero_uid29_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excSelector_uid30_fxpToFPTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal expZ_uid33_fxpToFPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal expR_uid34_fxpToFPTest_in : STD_LOGIC_VECTOR (4 downto 0);
    signal expR_uid34_fxpToFPTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal expRPostExc_uid35_fxpToFPTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid35_fxpToFPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal outRes_uid36_fxpToFPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal zs_uid38_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vCount_uid40_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid42_lzcShifterZ1_uid6_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid42_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal zs_uid43_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal vCount_uid45_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cStage_uid48_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vStagei_uid49_lzcShifterZ1_uid6_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid49_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal zs_uid50_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal vCount_uid52_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cStage_uid55_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vStagei_uid56_lzcShifterZ1_uid6_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid56_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal zs_uid57_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal vCount_uid59_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cStage_uid62_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vStagei_uid63_lzcShifterZ1_uid6_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid63_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vCount_uid66_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cStage_uid69_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vStagei_uid70_lzcShifterZ1_uid6_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid70_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vCount_uid71_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal vCountBig_uid73_lzcShifterZ1_uid6_fxpToFPTest_a : STD_LOGIC_VECTOR (6 downto 0);
    signal vCountBig_uid73_lzcShifterZ1_uid6_fxpToFPTest_b : STD_LOGIC_VECTOR (6 downto 0);
    signal vCountBig_uid73_lzcShifterZ1_uid6_fxpToFPTest_o : STD_LOGIC_VECTOR (6 downto 0);
    signal vCountBig_uid73_lzcShifterZ1_uid6_fxpToFPTest_c : STD_LOGIC_VECTOR (0 downto 0);
    signal vCountFinal_uid75_lzcShifterZ1_uid6_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vCountFinal_uid75_lzcShifterZ1_uid6_fxpToFPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal l_uid13_fxpToFPTest_merged_bit_select_in : STD_LOGIC_VECTOR (1 downto 0);
    signal l_uid13_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (0 downto 0);
    signal l_uid13_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (0 downto 0);
    signal rVStage_uid44_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (7 downto 0);
    signal rVStage_uid44_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (7 downto 0);
    signal rVStage_uid51_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (3 downto 0);
    signal rVStage_uid51_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (11 downto 0);
    signal rVStage_uid58_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid58_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (13 downto 0);
    signal rVStage_uid65_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (0 downto 0);
    signal rVStage_uid65_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (14 downto 0);
    signal fracRnd_uid11_fxpToFPTest_merged_bit_select_in : STD_LOGIC_VECTOR (14 downto 0);
    signal fracRnd_uid11_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (10 downto 0);
    signal fracRnd_uid11_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (3 downto 0);
    signal redist0_fracRnd_uid11_fxpToFPTest_merged_bit_select_b_1_q : STD_LOGIC_VECTOR (10 downto 0);

begin


    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- expInf_uid24_fxpToFPTest(CONSTANT,23)
    expInf_uid24_fxpToFPTest_q <= "11111";

    -- expZ_uid33_fxpToFPTest(CONSTANT,32)
    expZ_uid33_fxpToFPTest_q <= "00000";

    -- rVStage_uid65_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select(BITSELECT,81)@0
    rVStage_uid65_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_b <= vStagei_uid63_lzcShifterZ1_uid6_fxpToFPTest_q(15 downto 15);
    rVStage_uid65_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_c <= vStagei_uid63_lzcShifterZ1_uid6_fxpToFPTest_q(14 downto 0);

    -- cStage_uid69_lzcShifterZ1_uid6_fxpToFPTest(BITJOIN,68)@0
    cStage_uid69_lzcShifterZ1_uid6_fxpToFPTest_q <= rVStage_uid65_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_c & GND_q;

    -- rVStage_uid58_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select(BITSELECT,80)@0
    rVStage_uid58_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_b <= vStagei_uid56_lzcShifterZ1_uid6_fxpToFPTest_q(15 downto 14);
    rVStage_uid58_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_c <= vStagei_uid56_lzcShifterZ1_uid6_fxpToFPTest_q(13 downto 0);

    -- zs_uid57_lzcShifterZ1_uid6_fxpToFPTest(CONSTANT,56)
    zs_uid57_lzcShifterZ1_uid6_fxpToFPTest_q <= "00";

    -- cStage_uid62_lzcShifterZ1_uid6_fxpToFPTest(BITJOIN,61)@0
    cStage_uid62_lzcShifterZ1_uid6_fxpToFPTest_q <= rVStage_uid58_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_c & zs_uid57_lzcShifterZ1_uid6_fxpToFPTest_q;

    -- rVStage_uid51_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select(BITSELECT,79)@0
    rVStage_uid51_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_b <= vStagei_uid49_lzcShifterZ1_uid6_fxpToFPTest_q(15 downto 12);
    rVStage_uid51_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_c <= vStagei_uid49_lzcShifterZ1_uid6_fxpToFPTest_q(11 downto 0);

    -- zs_uid50_lzcShifterZ1_uid6_fxpToFPTest(CONSTANT,49)
    zs_uid50_lzcShifterZ1_uid6_fxpToFPTest_q <= "0000";

    -- cStage_uid55_lzcShifterZ1_uid6_fxpToFPTest(BITJOIN,54)@0
    cStage_uid55_lzcShifterZ1_uid6_fxpToFPTest_q <= rVStage_uid51_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_c & zs_uid50_lzcShifterZ1_uid6_fxpToFPTest_q;

    -- rVStage_uid44_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select(BITSELECT,78)@0
    rVStage_uid44_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_b <= vStagei_uid42_lzcShifterZ1_uid6_fxpToFPTest_q(15 downto 8);
    rVStage_uid44_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_c <= vStagei_uid42_lzcShifterZ1_uid6_fxpToFPTest_q(7 downto 0);

    -- zs_uid43_lzcShifterZ1_uid6_fxpToFPTest(CONSTANT,42)
    zs_uid43_lzcShifterZ1_uid6_fxpToFPTest_q <= "00000000";

    -- cStage_uid48_lzcShifterZ1_uid6_fxpToFPTest(BITJOIN,47)@0
    cStage_uid48_lzcShifterZ1_uid6_fxpToFPTest_q <= rVStage_uid44_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_c & zs_uid43_lzcShifterZ1_uid6_fxpToFPTest_q;

    -- zs_uid38_lzcShifterZ1_uid6_fxpToFPTest(CONSTANT,37)
    zs_uid38_lzcShifterZ1_uid6_fxpToFPTest_q <= "0000000000000000";

    -- vCount_uid40_lzcShifterZ1_uid6_fxpToFPTest(LOGICAL,39)@0
    vCount_uid40_lzcShifterZ1_uid6_fxpToFPTest_q <= "1" WHEN a = zs_uid38_lzcShifterZ1_uid6_fxpToFPTest_q ELSE "0";

    -- vStagei_uid42_lzcShifterZ1_uid6_fxpToFPTest(MUX,41)@0
    vStagei_uid42_lzcShifterZ1_uid6_fxpToFPTest_s <= vCount_uid40_lzcShifterZ1_uid6_fxpToFPTest_q;
    vStagei_uid42_lzcShifterZ1_uid6_fxpToFPTest_combproc: PROCESS (vStagei_uid42_lzcShifterZ1_uid6_fxpToFPTest_s, a, zs_uid38_lzcShifterZ1_uid6_fxpToFPTest_q)
    BEGIN
        CASE (vStagei_uid42_lzcShifterZ1_uid6_fxpToFPTest_s) IS
            WHEN "0" => vStagei_uid42_lzcShifterZ1_uid6_fxpToFPTest_q <= a;
            WHEN "1" => vStagei_uid42_lzcShifterZ1_uid6_fxpToFPTest_q <= zs_uid38_lzcShifterZ1_uid6_fxpToFPTest_q;
            WHEN OTHERS => vStagei_uid42_lzcShifterZ1_uid6_fxpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- vCount_uid45_lzcShifterZ1_uid6_fxpToFPTest(LOGICAL,44)@0
    vCount_uid45_lzcShifterZ1_uid6_fxpToFPTest_q <= "1" WHEN rVStage_uid44_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_b = zs_uid43_lzcShifterZ1_uid6_fxpToFPTest_q ELSE "0";

    -- vStagei_uid49_lzcShifterZ1_uid6_fxpToFPTest(MUX,48)@0
    vStagei_uid49_lzcShifterZ1_uid6_fxpToFPTest_s <= vCount_uid45_lzcShifterZ1_uid6_fxpToFPTest_q;
    vStagei_uid49_lzcShifterZ1_uid6_fxpToFPTest_combproc: PROCESS (vStagei_uid49_lzcShifterZ1_uid6_fxpToFPTest_s, vStagei_uid42_lzcShifterZ1_uid6_fxpToFPTest_q, cStage_uid48_lzcShifterZ1_uid6_fxpToFPTest_q)
    BEGIN
        CASE (vStagei_uid49_lzcShifterZ1_uid6_fxpToFPTest_s) IS
            WHEN "0" => vStagei_uid49_lzcShifterZ1_uid6_fxpToFPTest_q <= vStagei_uid42_lzcShifterZ1_uid6_fxpToFPTest_q;
            WHEN "1" => vStagei_uid49_lzcShifterZ1_uid6_fxpToFPTest_q <= cStage_uid48_lzcShifterZ1_uid6_fxpToFPTest_q;
            WHEN OTHERS => vStagei_uid49_lzcShifterZ1_uid6_fxpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- vCount_uid52_lzcShifterZ1_uid6_fxpToFPTest(LOGICAL,51)@0
    vCount_uid52_lzcShifterZ1_uid6_fxpToFPTest_q <= "1" WHEN rVStage_uid51_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_b = zs_uid50_lzcShifterZ1_uid6_fxpToFPTest_q ELSE "0";

    -- vStagei_uid56_lzcShifterZ1_uid6_fxpToFPTest(MUX,55)@0
    vStagei_uid56_lzcShifterZ1_uid6_fxpToFPTest_s <= vCount_uid52_lzcShifterZ1_uid6_fxpToFPTest_q;
    vStagei_uid56_lzcShifterZ1_uid6_fxpToFPTest_combproc: PROCESS (vStagei_uid56_lzcShifterZ1_uid6_fxpToFPTest_s, vStagei_uid49_lzcShifterZ1_uid6_fxpToFPTest_q, cStage_uid55_lzcShifterZ1_uid6_fxpToFPTest_q)
    BEGIN
        CASE (vStagei_uid56_lzcShifterZ1_uid6_fxpToFPTest_s) IS
            WHEN "0" => vStagei_uid56_lzcShifterZ1_uid6_fxpToFPTest_q <= vStagei_uid49_lzcShifterZ1_uid6_fxpToFPTest_q;
            WHEN "1" => vStagei_uid56_lzcShifterZ1_uid6_fxpToFPTest_q <= cStage_uid55_lzcShifterZ1_uid6_fxpToFPTest_q;
            WHEN OTHERS => vStagei_uid56_lzcShifterZ1_uid6_fxpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- vCount_uid59_lzcShifterZ1_uid6_fxpToFPTest(LOGICAL,58)@0
    vCount_uid59_lzcShifterZ1_uid6_fxpToFPTest_q <= "1" WHEN rVStage_uid58_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_b = zs_uid57_lzcShifterZ1_uid6_fxpToFPTest_q ELSE "0";

    -- vStagei_uid63_lzcShifterZ1_uid6_fxpToFPTest(MUX,62)@0
    vStagei_uid63_lzcShifterZ1_uid6_fxpToFPTest_s <= vCount_uid59_lzcShifterZ1_uid6_fxpToFPTest_q;
    vStagei_uid63_lzcShifterZ1_uid6_fxpToFPTest_combproc: PROCESS (vStagei_uid63_lzcShifterZ1_uid6_fxpToFPTest_s, vStagei_uid56_lzcShifterZ1_uid6_fxpToFPTest_q, cStage_uid62_lzcShifterZ1_uid6_fxpToFPTest_q)
    BEGIN
        CASE (vStagei_uid63_lzcShifterZ1_uid6_fxpToFPTest_s) IS
            WHEN "0" => vStagei_uid63_lzcShifterZ1_uid6_fxpToFPTest_q <= vStagei_uid56_lzcShifterZ1_uid6_fxpToFPTest_q;
            WHEN "1" => vStagei_uid63_lzcShifterZ1_uid6_fxpToFPTest_q <= cStage_uid62_lzcShifterZ1_uid6_fxpToFPTest_q;
            WHEN OTHERS => vStagei_uid63_lzcShifterZ1_uid6_fxpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- vCount_uid66_lzcShifterZ1_uid6_fxpToFPTest(LOGICAL,65)@0
    vCount_uid66_lzcShifterZ1_uid6_fxpToFPTest_q <= "1" WHEN rVStage_uid65_lzcShifterZ1_uid6_fxpToFPTest_merged_bit_select_b = GND_q ELSE "0";

    -- vStagei_uid70_lzcShifterZ1_uid6_fxpToFPTest(MUX,69)@0
    vStagei_uid70_lzcShifterZ1_uid6_fxpToFPTest_s <= vCount_uid66_lzcShifterZ1_uid6_fxpToFPTest_q;
    vStagei_uid70_lzcShifterZ1_uid6_fxpToFPTest_combproc: PROCESS (vStagei_uid70_lzcShifterZ1_uid6_fxpToFPTest_s, vStagei_uid63_lzcShifterZ1_uid6_fxpToFPTest_q, cStage_uid69_lzcShifterZ1_uid6_fxpToFPTest_q)
    BEGIN
        CASE (vStagei_uid70_lzcShifterZ1_uid6_fxpToFPTest_s) IS
            WHEN "0" => vStagei_uid70_lzcShifterZ1_uid6_fxpToFPTest_q <= vStagei_uid63_lzcShifterZ1_uid6_fxpToFPTest_q;
            WHEN "1" => vStagei_uid70_lzcShifterZ1_uid6_fxpToFPTest_q <= cStage_uid69_lzcShifterZ1_uid6_fxpToFPTest_q;
            WHEN OTHERS => vStagei_uid70_lzcShifterZ1_uid6_fxpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracRnd_uid11_fxpToFPTest_merged_bit_select(BITSELECT,82)@0
    fracRnd_uid11_fxpToFPTest_merged_bit_select_in <= vStagei_uid70_lzcShifterZ1_uid6_fxpToFPTest_q(14 downto 0);
    fracRnd_uid11_fxpToFPTest_merged_bit_select_b <= fracRnd_uid11_fxpToFPTest_merged_bit_select_in(14 downto 4);
    fracRnd_uid11_fxpToFPTest_merged_bit_select_c <= fracRnd_uid11_fxpToFPTest_merged_bit_select_in(3 downto 0);

    -- sticky_uid16_fxpToFPTest(LOGICAL,15)@0 + 1
    sticky_uid16_fxpToFPTest_qi <= "1" WHEN fracRnd_uid11_fxpToFPTest_merged_bit_select_c /= "0000" ELSE "0";
    sticky_uid16_fxpToFPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => sticky_uid16_fxpToFPTest_qi, xout => sticky_uid16_fxpToFPTest_q, clk => clk, aclr => areset );

    -- nr_uid17_fxpToFPTest(LOGICAL,16)@1
    nr_uid17_fxpToFPTest_q <= not (l_uid13_fxpToFPTest_merged_bit_select_c);

    -- l_uid13_fxpToFPTest_merged_bit_select(BITSELECT,77)@1
    l_uid13_fxpToFPTest_merged_bit_select_in <= STD_LOGIC_VECTOR(expFracRnd_uid12_fxpToFPTest_q(1 downto 0));
    l_uid13_fxpToFPTest_merged_bit_select_b <= STD_LOGIC_VECTOR(l_uid13_fxpToFPTest_merged_bit_select_in(1 downto 1));
    l_uid13_fxpToFPTest_merged_bit_select_c <= STD_LOGIC_VECTOR(l_uid13_fxpToFPTest_merged_bit_select_in(0 downto 0));

    -- rnd_uid18_fxpToFPTest(LOGICAL,17)@1
    rnd_uid18_fxpToFPTest_q <= l_uid13_fxpToFPTest_merged_bit_select_b or nr_uid17_fxpToFPTest_q or sticky_uid16_fxpToFPTest_q;

    -- maxCount_uid7_fxpToFPTest(CONSTANT,6)
    maxCount_uid7_fxpToFPTest_q <= "10000";

    -- vCount_uid71_lzcShifterZ1_uid6_fxpToFPTest(BITJOIN,70)@0
    vCount_uid71_lzcShifterZ1_uid6_fxpToFPTest_q <= vCount_uid40_lzcShifterZ1_uid6_fxpToFPTest_q & vCount_uid45_lzcShifterZ1_uid6_fxpToFPTest_q & vCount_uid52_lzcShifterZ1_uid6_fxpToFPTest_q & vCount_uid59_lzcShifterZ1_uid6_fxpToFPTest_q & vCount_uid66_lzcShifterZ1_uid6_fxpToFPTest_q;

    -- vCountBig_uid73_lzcShifterZ1_uid6_fxpToFPTest(COMPARE,72)@0
    vCountBig_uid73_lzcShifterZ1_uid6_fxpToFPTest_a <= STD_LOGIC_VECTOR("00" & maxCount_uid7_fxpToFPTest_q);
    vCountBig_uid73_lzcShifterZ1_uid6_fxpToFPTest_b <= STD_LOGIC_VECTOR("00" & vCount_uid71_lzcShifterZ1_uid6_fxpToFPTest_q);
    vCountBig_uid73_lzcShifterZ1_uid6_fxpToFPTest_o <= STD_LOGIC_VECTOR(UNSIGNED(vCountBig_uid73_lzcShifterZ1_uid6_fxpToFPTest_a) - UNSIGNED(vCountBig_uid73_lzcShifterZ1_uid6_fxpToFPTest_b));
    vCountBig_uid73_lzcShifterZ1_uid6_fxpToFPTest_c(0) <= vCountBig_uid73_lzcShifterZ1_uid6_fxpToFPTest_o(6);

    -- vCountFinal_uid75_lzcShifterZ1_uid6_fxpToFPTest(MUX,74)@0 + 1
    vCountFinal_uid75_lzcShifterZ1_uid6_fxpToFPTest_s <= vCountBig_uid73_lzcShifterZ1_uid6_fxpToFPTest_c;
    vCountFinal_uid75_lzcShifterZ1_uid6_fxpToFPTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            vCountFinal_uid75_lzcShifterZ1_uid6_fxpToFPTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (vCountFinal_uid75_lzcShifterZ1_uid6_fxpToFPTest_s) IS
                WHEN "0" => vCountFinal_uid75_lzcShifterZ1_uid6_fxpToFPTest_q <= vCount_uid71_lzcShifterZ1_uid6_fxpToFPTest_q;
                WHEN "1" => vCountFinal_uid75_lzcShifterZ1_uid6_fxpToFPTest_q <= maxCount_uid7_fxpToFPTest_q;
                WHEN OTHERS => vCountFinal_uid75_lzcShifterZ1_uid6_fxpToFPTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- msbIn_uid9_fxpToFPTest(CONSTANT,8)
    msbIn_uid9_fxpToFPTest_q <= "11110";

    -- expPreRnd_uid10_fxpToFPTest(SUB,9)@1
    expPreRnd_uid10_fxpToFPTest_a <= STD_LOGIC_VECTOR("0" & msbIn_uid9_fxpToFPTest_q);
    expPreRnd_uid10_fxpToFPTest_b <= STD_LOGIC_VECTOR("0" & vCountFinal_uid75_lzcShifterZ1_uid6_fxpToFPTest_q);
    expPreRnd_uid10_fxpToFPTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expPreRnd_uid10_fxpToFPTest_a) - UNSIGNED(expPreRnd_uid10_fxpToFPTest_b));
    expPreRnd_uid10_fxpToFPTest_q <= expPreRnd_uid10_fxpToFPTest_o(5 downto 0);

    -- redist0_fracRnd_uid11_fxpToFPTest_merged_bit_select_b_1(DELAY,83)
    redist0_fracRnd_uid11_fxpToFPTest_merged_bit_select_b_1 : dspba_delay
    GENERIC MAP ( width => 11, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracRnd_uid11_fxpToFPTest_merged_bit_select_b, xout => redist0_fracRnd_uid11_fxpToFPTest_merged_bit_select_b_1_q, clk => clk, aclr => areset );

    -- expFracRnd_uid12_fxpToFPTest(BITJOIN,11)@1
    expFracRnd_uid12_fxpToFPTest_q <= expPreRnd_uid10_fxpToFPTest_q & redist0_fracRnd_uid11_fxpToFPTest_merged_bit_select_b_1_q;

    -- expFracR_uid20_fxpToFPTest(ADD,19)@1
    expFracR_uid20_fxpToFPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((18 downto 17 => expFracRnd_uid12_fxpToFPTest_q(16)) & expFracRnd_uid12_fxpToFPTest_q));
    expFracR_uid20_fxpToFPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000000000000000000" & rnd_uid18_fxpToFPTest_q));
    expFracR_uid20_fxpToFPTest_o <= STD_LOGIC_VECTOR(SIGNED(expFracR_uid20_fxpToFPTest_a) + SIGNED(expFracR_uid20_fxpToFPTest_b));
    expFracR_uid20_fxpToFPTest_q <= expFracR_uid20_fxpToFPTest_o(17 downto 0);

    -- expR_uid22_fxpToFPTest(BITSELECT,21)@1
    expR_uid22_fxpToFPTest_b <= STD_LOGIC_VECTOR(expFracR_uid20_fxpToFPTest_q(17 downto 11));

    -- expR_uid34_fxpToFPTest(BITSELECT,33)@1
    expR_uid34_fxpToFPTest_in <= expR_uid22_fxpToFPTest_b(4 downto 0);
    expR_uid34_fxpToFPTest_b <= expR_uid34_fxpToFPTest_in(4 downto 0);

    -- ovf_uid25_fxpToFPTest(COMPARE,24)@1
    ovf_uid25_fxpToFPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((8 downto 7 => expR_uid22_fxpToFPTest_b(6)) & expR_uid22_fxpToFPTest_b));
    ovf_uid25_fxpToFPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0000" & expInf_uid24_fxpToFPTest_q));
    ovf_uid25_fxpToFPTest_o <= STD_LOGIC_VECTOR(SIGNED(ovf_uid25_fxpToFPTest_a) - SIGNED(ovf_uid25_fxpToFPTest_b));
    ovf_uid25_fxpToFPTest_n(0) <= not (ovf_uid25_fxpToFPTest_o(8));

    -- inIsZero_uid8_fxpToFPTest(LOGICAL,7)@1
    inIsZero_uid8_fxpToFPTest_q <= "1" WHEN vCountFinal_uid75_lzcShifterZ1_uid6_fxpToFPTest_q = maxCount_uid7_fxpToFPTest_q ELSE "0";

    -- udf_uid23_fxpToFPTest(COMPARE,22)@1
    udf_uid23_fxpToFPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000000" & GND_q));
    udf_uid23_fxpToFPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((8 downto 7 => expR_uid22_fxpToFPTest_b(6)) & expR_uid22_fxpToFPTest_b));
    udf_uid23_fxpToFPTest_o <= STD_LOGIC_VECTOR(SIGNED(udf_uid23_fxpToFPTest_a) - SIGNED(udf_uid23_fxpToFPTest_b));
    udf_uid23_fxpToFPTest_n(0) <= not (udf_uid23_fxpToFPTest_o(8));

    -- udfOrInZero_uid29_fxpToFPTest(LOGICAL,28)@1
    udfOrInZero_uid29_fxpToFPTest_q <= udf_uid23_fxpToFPTest_n or inIsZero_uid8_fxpToFPTest_q;

    -- excSelector_uid30_fxpToFPTest(BITJOIN,29)@1
    excSelector_uid30_fxpToFPTest_q <= ovf_uid25_fxpToFPTest_n & udfOrInZero_uid29_fxpToFPTest_q;

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- expRPostExc_uid35_fxpToFPTest(MUX,34)@1
    expRPostExc_uid35_fxpToFPTest_s <= excSelector_uid30_fxpToFPTest_q;
    expRPostExc_uid35_fxpToFPTest_combproc: PROCESS (expRPostExc_uid35_fxpToFPTest_s, expR_uid34_fxpToFPTest_b, expZ_uid33_fxpToFPTest_q, expInf_uid24_fxpToFPTest_q)
    BEGIN
        CASE (expRPostExc_uid35_fxpToFPTest_s) IS
            WHEN "00" => expRPostExc_uid35_fxpToFPTest_q <= expR_uid34_fxpToFPTest_b;
            WHEN "01" => expRPostExc_uid35_fxpToFPTest_q <= expZ_uid33_fxpToFPTest_q;
            WHEN "10" => expRPostExc_uid35_fxpToFPTest_q <= expInf_uid24_fxpToFPTest_q;
            WHEN "11" => expRPostExc_uid35_fxpToFPTest_q <= expInf_uid24_fxpToFPTest_q;
            WHEN OTHERS => expRPostExc_uid35_fxpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracZ_uid27_fxpToFPTest(CONSTANT,26)
    fracZ_uid27_fxpToFPTest_q <= "0000000000";

    -- fracR_uid21_fxpToFPTest(BITSELECT,20)@1
    fracR_uid21_fxpToFPTest_in <= expFracR_uid20_fxpToFPTest_q(10 downto 0);
    fracR_uid21_fxpToFPTest_b <= fracR_uid21_fxpToFPTest_in(10 downto 1);

    -- excSelector_uid26_fxpToFPTest(LOGICAL,25)@1
    excSelector_uid26_fxpToFPTest_q <= inIsZero_uid8_fxpToFPTest_q or ovf_uid25_fxpToFPTest_n or udf_uid23_fxpToFPTest_n;

    -- fracRPostExc_uid28_fxpToFPTest(MUX,27)@1
    fracRPostExc_uid28_fxpToFPTest_s <= excSelector_uid26_fxpToFPTest_q;
    fracRPostExc_uid28_fxpToFPTest_combproc: PROCESS (fracRPostExc_uid28_fxpToFPTest_s, fracR_uid21_fxpToFPTest_b, fracZ_uid27_fxpToFPTest_q)
    BEGIN
        CASE (fracRPostExc_uid28_fxpToFPTest_s) IS
            WHEN "0" => fracRPostExc_uid28_fxpToFPTest_q <= fracR_uid21_fxpToFPTest_b;
            WHEN "1" => fracRPostExc_uid28_fxpToFPTest_q <= fracZ_uid27_fxpToFPTest_q;
            WHEN OTHERS => fracRPostExc_uid28_fxpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- outRes_uid36_fxpToFPTest(BITJOIN,35)@1
    outRes_uid36_fxpToFPTest_q <= GND_q & expRPostExc_uid35_fxpToFPTest_q & fracRPostExc_uid28_fxpToFPTest_q;

    -- xOut(GPOUT,4)@1
    q <= outRes_uid36_fxpToFPTest_q;

END normal;
