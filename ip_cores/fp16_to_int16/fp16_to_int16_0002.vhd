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

-- VHDL created from fp16_to_int16_0002
-- VHDL created on Sat Mar 22 14:39:50 2025


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

entity fp16_to_int16_0002 is
    port (
        a : in std_logic_vector(15 downto 0);  -- float16_m10
        q : out std_logic_vector(15 downto 0);  -- sfix16
        clk : in std_logic;
        areset : in std_logic
    );
end fp16_to_int16_0002;

architecture normal of fp16_to_int16_0002 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstAllOWE_uid6_fpToFxPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal cstZeroWF_uid7_fpToFxPTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal cstAllZWE_uid8_fpToFxPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal exp_x_uid9_fpToFxPTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal frac_x_uid10_fpToFxPTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal excZ_x_uid11_fpToFxPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_x_uid11_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid12_fpToFxPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid12_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid13_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid14_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_x_uid15_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid16_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcXZ_uid22_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oFracX_uid23_fpToFxPTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal signX_uid25_fpToFxPTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal ovfExpVal_uid26_fpToFxPTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal ovfExpRange_uid27_fpToFxPTest_a : STD_LOGIC_VECTOR (7 downto 0);
    signal ovfExpRange_uid27_fpToFxPTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal ovfExpRange_uid27_fpToFxPTest_o : STD_LOGIC_VECTOR (7 downto 0);
    signal ovfExpRange_uid27_fpToFxPTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal udfExpVal_uid28_fpToFxPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal udf_uid29_fpToFxPTest_a : STD_LOGIC_VECTOR (7 downto 0);
    signal udf_uid29_fpToFxPTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal udf_uid29_fpToFxPTest_o : STD_LOGIC_VECTOR (7 downto 0);
    signal udf_uid29_fpToFxPTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal ovfExpVal_uid30_fpToFxPTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal shiftValE_uid31_fpToFxPTest_a : STD_LOGIC_VECTOR (7 downto 0);
    signal shiftValE_uid31_fpToFxPTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal shiftValE_uid31_fpToFxPTest_o : STD_LOGIC_VECTOR (7 downto 0);
    signal shiftValE_uid31_fpToFxPTest_q : STD_LOGIC_VECTOR (6 downto 0);
    signal shiftValRaw_uid32_fpToFxPTest_in : STD_LOGIC_VECTOR (4 downto 0);
    signal shiftValRaw_uid32_fpToFxPTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal maxShiftCst_uid33_fpToFxPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal shiftOutOfRange_uid34_fpToFxPTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal shiftOutOfRange_uid34_fpToFxPTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal shiftOutOfRange_uid34_fpToFxPTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal shiftOutOfRange_uid34_fpToFxPTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal shiftVal_uid35_fpToFxPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal shiftVal_uid35_fpToFxPTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal shifterIn_uid37_fpToFxPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal maxPosValueS_uid39_fpToFxPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal maxNegValueS_uid40_fpToFxPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal zRightShiferNoStickyOut_uid41_fpToFxPTest_q : STD_LOGIC_VECTOR (16 downto 0);
    signal xXorSignE_uid42_fpToFxPTest_b : STD_LOGIC_VECTOR (16 downto 0);
    signal xXorSignE_uid42_fpToFxPTest_q : STD_LOGIC_VECTOR (16 downto 0);
    signal d0_uid43_fpToFxPTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal sPostRndFull_uid44_fpToFxPTest_a : STD_LOGIC_VECTOR (17 downto 0);
    signal sPostRndFull_uid44_fpToFxPTest_b : STD_LOGIC_VECTOR (17 downto 0);
    signal sPostRndFull_uid44_fpToFxPTest_o : STD_LOGIC_VECTOR (17 downto 0);
    signal sPostRndFull_uid44_fpToFxPTest_q : STD_LOGIC_VECTOR (17 downto 0);
    signal sPostRnd_uid45_fpToFxPTest_in : STD_LOGIC_VECTOR (16 downto 0);
    signal sPostRnd_uid45_fpToFxPTest_b : STD_LOGIC_VECTOR (15 downto 0);
    signal sPostRnd_uid46_fpToFxPTest_in : STD_LOGIC_VECTOR (18 downto 0);
    signal sPostRnd_uid46_fpToFxPTest_b : STD_LOGIC_VECTOR (17 downto 0);
    signal rndOvfPos_uid47_fpToFxPTest_a : STD_LOGIC_VECTOR (19 downto 0);
    signal rndOvfPos_uid47_fpToFxPTest_b : STD_LOGIC_VECTOR (19 downto 0);
    signal rndOvfPos_uid47_fpToFxPTest_o : STD_LOGIC_VECTOR (19 downto 0);
    signal rndOvfPos_uid47_fpToFxPTest_c : STD_LOGIC_VECTOR (0 downto 0);
    signal ovfPostRnd_uid48_fpToFxPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal muxSelConc_uid49_fpToFxPTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal muxSel_uid50_fpToFxPTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal maxNegValueU_uid51_fpToFxPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal finalOut_uid52_fpToFxPTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal finalOut_uid52_fpToFxPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal rightShiftStage0Idx1Rng8_uid56_rightShiferNoStickyOut_uid38_fpToFxPTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal rightShiftStage0Idx1Pad8_uid57_rightShiferNoStickyOut_uid38_fpToFxPTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal rightShiftStage0Idx1_uid58_rightShiferNoStickyOut_uid38_fpToFxPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal rightShiftStage1Idx1Rng2_uid63_rightShiferNoStickyOut_uid38_fpToFxPTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal rightShiftStage1Idx1Pad2_uid64_rightShiferNoStickyOut_uid38_fpToFxPTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage1Idx1_uid65_rightShiferNoStickyOut_uid38_fpToFxPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal rightShiftStage1Idx2Rng4_uid66_rightShiferNoStickyOut_uid38_fpToFxPTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal rightShiftStage1Idx2Pad4_uid67_rightShiferNoStickyOut_uid38_fpToFxPTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal rightShiftStage1Idx2_uid68_rightShiferNoStickyOut_uid38_fpToFxPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal rightShiftStage1Idx3Rng6_uid69_rightShiferNoStickyOut_uid38_fpToFxPTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal rightShiftStage1Idx3Pad6_uid70_rightShiferNoStickyOut_uid38_fpToFxPTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal rightShiftStage1Idx3_uid71_rightShiferNoStickyOut_uid38_fpToFxPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal rightShiftStage2Idx1Rng1_uid74_rightShiferNoStickyOut_uid38_fpToFxPTest_b : STD_LOGIC_VECTOR (14 downto 0);
    signal rightShiftStage2Idx1_uid76_rightShiferNoStickyOut_uid38_fpToFxPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal rightShiftStage2_uid78_rightShiferNoStickyOut_uid38_fpToFxPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal rightShiftStage2_uid78_rightShiferNoStickyOut_uid38_fpToFxPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal rightShiftStageSel4Dto3_uid61_rightShiferNoStickyOut_uid38_fpToFxPTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel4Dto3_uid61_rightShiferNoStickyOut_uid38_fpToFxPTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel4Dto3_uid61_rightShiferNoStickyOut_uid38_fpToFxPTest_merged_bit_select_d : STD_LOGIC_VECTOR (0 downto 0);
    signal redist0_signX_uid25_fpToFxPTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist1_frac_x_uid10_fpToFxPTest_b_1_q : STD_LOGIC_VECTOR (9 downto 0);

begin


    -- maxNegValueU_uid51_fpToFxPTest(CONSTANT,50)
    maxNegValueU_uid51_fpToFxPTest_q <= "0000000000000000";

    -- maxNegValueS_uid40_fpToFxPTest(CONSTANT,39)
    maxNegValueS_uid40_fpToFxPTest_q <= "1000000000000000";

    -- maxPosValueS_uid39_fpToFxPTest(CONSTANT,38)
    maxPosValueS_uid39_fpToFxPTest_q <= "0111111111111111";

    -- d0_uid43_fpToFxPTest(CONSTANT,42)
    d0_uid43_fpToFxPTest_q <= "001";

    -- signX_uid25_fpToFxPTest(BITSELECT,24)@0
    signX_uid25_fpToFxPTest_b <= STD_LOGIC_VECTOR(a(15 downto 15));

    -- redist0_signX_uid25_fpToFxPTest_b_1(DELAY,80)
    redist0_signX_uid25_fpToFxPTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => signX_uid25_fpToFxPTest_b, xout => redist0_signX_uid25_fpToFxPTest_b_1_q, clk => clk, aclr => areset );

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- rightShiftStage2Idx1Rng1_uid74_rightShiferNoStickyOut_uid38_fpToFxPTest(BITSELECT,73)@1
    rightShiftStage2Idx1Rng1_uid74_rightShiferNoStickyOut_uid38_fpToFxPTest_b <= rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest_q(15 downto 1);

    -- rightShiftStage2Idx1_uid76_rightShiferNoStickyOut_uid38_fpToFxPTest(BITJOIN,75)@1
    rightShiftStage2Idx1_uid76_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= GND_q & rightShiftStage2Idx1Rng1_uid74_rightShiferNoStickyOut_uid38_fpToFxPTest_b;

    -- rightShiftStage1Idx3Pad6_uid70_rightShiferNoStickyOut_uid38_fpToFxPTest(CONSTANT,69)
    rightShiftStage1Idx3Pad6_uid70_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= "000000";

    -- rightShiftStage1Idx3Rng6_uid69_rightShiferNoStickyOut_uid38_fpToFxPTest(BITSELECT,68)@1
    rightShiftStage1Idx3Rng6_uid69_rightShiferNoStickyOut_uid38_fpToFxPTest_b <= rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_q(15 downto 6);

    -- rightShiftStage1Idx3_uid71_rightShiferNoStickyOut_uid38_fpToFxPTest(BITJOIN,70)@1
    rightShiftStage1Idx3_uid71_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= rightShiftStage1Idx3Pad6_uid70_rightShiferNoStickyOut_uid38_fpToFxPTest_q & rightShiftStage1Idx3Rng6_uid69_rightShiferNoStickyOut_uid38_fpToFxPTest_b;

    -- rightShiftStage1Idx2Pad4_uid67_rightShiferNoStickyOut_uid38_fpToFxPTest(CONSTANT,66)
    rightShiftStage1Idx2Pad4_uid67_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= "0000";

    -- rightShiftStage1Idx2Rng4_uid66_rightShiferNoStickyOut_uid38_fpToFxPTest(BITSELECT,65)@1
    rightShiftStage1Idx2Rng4_uid66_rightShiferNoStickyOut_uid38_fpToFxPTest_b <= rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_q(15 downto 4);

    -- rightShiftStage1Idx2_uid68_rightShiferNoStickyOut_uid38_fpToFxPTest(BITJOIN,67)@1
    rightShiftStage1Idx2_uid68_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= rightShiftStage1Idx2Pad4_uid67_rightShiferNoStickyOut_uid38_fpToFxPTest_q & rightShiftStage1Idx2Rng4_uid66_rightShiferNoStickyOut_uid38_fpToFxPTest_b;

    -- rightShiftStage1Idx1Pad2_uid64_rightShiferNoStickyOut_uid38_fpToFxPTest(CONSTANT,63)
    rightShiftStage1Idx1Pad2_uid64_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= "00";

    -- rightShiftStage1Idx1Rng2_uid63_rightShiferNoStickyOut_uid38_fpToFxPTest(BITSELECT,62)@1
    rightShiftStage1Idx1Rng2_uid63_rightShiferNoStickyOut_uid38_fpToFxPTest_b <= rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_q(15 downto 2);

    -- rightShiftStage1Idx1_uid65_rightShiferNoStickyOut_uid38_fpToFxPTest(BITJOIN,64)@1
    rightShiftStage1Idx1_uid65_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= rightShiftStage1Idx1Pad2_uid64_rightShiferNoStickyOut_uid38_fpToFxPTest_q & rightShiftStage1Idx1Rng2_uid63_rightShiferNoStickyOut_uid38_fpToFxPTest_b;

    -- rightShiftStage0Idx1Pad8_uid57_rightShiferNoStickyOut_uid38_fpToFxPTest(CONSTANT,56)
    rightShiftStage0Idx1Pad8_uid57_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= "00000000";

    -- rightShiftStage0Idx1Rng8_uid56_rightShiferNoStickyOut_uid38_fpToFxPTest(BITSELECT,55)@1
    rightShiftStage0Idx1Rng8_uid56_rightShiferNoStickyOut_uid38_fpToFxPTest_b <= shifterIn_uid37_fpToFxPTest_q(15 downto 8);

    -- rightShiftStage0Idx1_uid58_rightShiferNoStickyOut_uid38_fpToFxPTest(BITJOIN,57)@1
    rightShiftStage0Idx1_uid58_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= rightShiftStage0Idx1Pad8_uid57_rightShiferNoStickyOut_uid38_fpToFxPTest_q & rightShiftStage0Idx1Rng8_uid56_rightShiferNoStickyOut_uid38_fpToFxPTest_b;

    -- exp_x_uid9_fpToFxPTest(BITSELECT,8)@0
    exp_x_uid9_fpToFxPTest_b <= a(14 downto 10);

    -- excZ_x_uid11_fpToFxPTest(LOGICAL,10)@0 + 1
    excZ_x_uid11_fpToFxPTest_qi <= "1" WHEN exp_x_uid9_fpToFxPTest_b = cstAllZWE_uid8_fpToFxPTest_q ELSE "0";
    excZ_x_uid11_fpToFxPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_x_uid11_fpToFxPTest_qi, xout => excZ_x_uid11_fpToFxPTest_q, clk => clk, aclr => areset );

    -- invExcXZ_uid22_fpToFxPTest(LOGICAL,21)@1
    invExcXZ_uid22_fpToFxPTest_q <= not (excZ_x_uid11_fpToFxPTest_q);

    -- frac_x_uid10_fpToFxPTest(BITSELECT,9)@0
    frac_x_uid10_fpToFxPTest_b <= a(9 downto 0);

    -- redist1_frac_x_uid10_fpToFxPTest_b_1(DELAY,81)
    redist1_frac_x_uid10_fpToFxPTest_b_1 : dspba_delay
    GENERIC MAP ( width => 10, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => frac_x_uid10_fpToFxPTest_b, xout => redist1_frac_x_uid10_fpToFxPTest_b_1_q, clk => clk, aclr => areset );

    -- oFracX_uid23_fpToFxPTest(BITJOIN,22)@1
    oFracX_uid23_fpToFxPTest_q <= invExcXZ_uid22_fpToFxPTest_q & redist1_frac_x_uid10_fpToFxPTest_b_1_q;

    -- cstAllZWE_uid8_fpToFxPTest(CONSTANT,7)
    cstAllZWE_uid8_fpToFxPTest_q <= "00000";

    -- shifterIn_uid37_fpToFxPTest(BITJOIN,36)@1
    shifterIn_uid37_fpToFxPTest_q <= oFracX_uid23_fpToFxPTest_q & cstAllZWE_uid8_fpToFxPTest_q;

    -- rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest(MUX,61)@1
    rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_s <= rightShiftStageSel4Dto3_uid61_rightShiferNoStickyOut_uid38_fpToFxPTest_merged_bit_select_b;
    rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_combproc: PROCESS (rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_s, shifterIn_uid37_fpToFxPTest_q, rightShiftStage0Idx1_uid58_rightShiferNoStickyOut_uid38_fpToFxPTest_q, maxNegValueU_uid51_fpToFxPTest_q)
    BEGIN
        CASE (rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_s) IS
            WHEN "00" => rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= shifterIn_uid37_fpToFxPTest_q;
            WHEN "01" => rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= rightShiftStage0Idx1_uid58_rightShiferNoStickyOut_uid38_fpToFxPTest_q;
            WHEN "10" => rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= maxNegValueU_uid51_fpToFxPTest_q;
            WHEN "11" => rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= maxNegValueU_uid51_fpToFxPTest_q;
            WHEN OTHERS => rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest(MUX,72)@1
    rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest_s <= rightShiftStageSel4Dto3_uid61_rightShiferNoStickyOut_uid38_fpToFxPTest_merged_bit_select_c;
    rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest_combproc: PROCESS (rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest_s, rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_q, rightShiftStage1Idx1_uid65_rightShiferNoStickyOut_uid38_fpToFxPTest_q, rightShiftStage1Idx2_uid68_rightShiferNoStickyOut_uid38_fpToFxPTest_q, rightShiftStage1Idx3_uid71_rightShiferNoStickyOut_uid38_fpToFxPTest_q)
    BEGIN
        CASE (rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest_s) IS
            WHEN "00" => rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= rightShiftStage0_uid62_rightShiferNoStickyOut_uid38_fpToFxPTest_q;
            WHEN "01" => rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= rightShiftStage1Idx1_uid65_rightShiferNoStickyOut_uid38_fpToFxPTest_q;
            WHEN "10" => rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= rightShiftStage1Idx2_uid68_rightShiferNoStickyOut_uid38_fpToFxPTest_q;
            WHEN "11" => rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= rightShiftStage1Idx3_uid71_rightShiferNoStickyOut_uid38_fpToFxPTest_q;
            WHEN OTHERS => rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- maxShiftCst_uid33_fpToFxPTest(CONSTANT,32)
    maxShiftCst_uid33_fpToFxPTest_q <= "10000";

    -- ovfExpVal_uid30_fpToFxPTest(CONSTANT,29)
    ovfExpVal_uid30_fpToFxPTest_q <= "011101";

    -- shiftValE_uid31_fpToFxPTest(SUB,30)@0
    shiftValE_uid31_fpToFxPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((7 downto 6 => ovfExpVal_uid30_fpToFxPTest_q(5)) & ovfExpVal_uid30_fpToFxPTest_q));
    shiftValE_uid31_fpToFxPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & exp_x_uid9_fpToFxPTest_b));
    shiftValE_uid31_fpToFxPTest_o <= STD_LOGIC_VECTOR(SIGNED(shiftValE_uid31_fpToFxPTest_a) - SIGNED(shiftValE_uid31_fpToFxPTest_b));
    shiftValE_uid31_fpToFxPTest_q <= shiftValE_uid31_fpToFxPTest_o(6 downto 0);

    -- shiftValRaw_uid32_fpToFxPTest(BITSELECT,31)@0
    shiftValRaw_uid32_fpToFxPTest_in <= shiftValE_uid31_fpToFxPTest_q(4 downto 0);
    shiftValRaw_uid32_fpToFxPTest_b <= shiftValRaw_uid32_fpToFxPTest_in(4 downto 0);

    -- shiftOutOfRange_uid34_fpToFxPTest(COMPARE,33)@0
    shiftOutOfRange_uid34_fpToFxPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((8 downto 7 => shiftValE_uid31_fpToFxPTest_q(6)) & shiftValE_uid31_fpToFxPTest_q));
    shiftOutOfRange_uid34_fpToFxPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0000" & maxShiftCst_uid33_fpToFxPTest_q));
    shiftOutOfRange_uid34_fpToFxPTest_o <= STD_LOGIC_VECTOR(SIGNED(shiftOutOfRange_uid34_fpToFxPTest_a) - SIGNED(shiftOutOfRange_uid34_fpToFxPTest_b));
    shiftOutOfRange_uid34_fpToFxPTest_n(0) <= not (shiftOutOfRange_uid34_fpToFxPTest_o(8));

    -- shiftVal_uid35_fpToFxPTest(MUX,34)@0 + 1
    shiftVal_uid35_fpToFxPTest_s <= shiftOutOfRange_uid34_fpToFxPTest_n;
    shiftVal_uid35_fpToFxPTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            shiftVal_uid35_fpToFxPTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (shiftVal_uid35_fpToFxPTest_s) IS
                WHEN "0" => shiftVal_uid35_fpToFxPTest_q <= shiftValRaw_uid32_fpToFxPTest_b;
                WHEN "1" => shiftVal_uid35_fpToFxPTest_q <= maxShiftCst_uid33_fpToFxPTest_q;
                WHEN OTHERS => shiftVal_uid35_fpToFxPTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- rightShiftStageSel4Dto3_uid61_rightShiferNoStickyOut_uid38_fpToFxPTest_merged_bit_select(BITSELECT,79)@1
    rightShiftStageSel4Dto3_uid61_rightShiferNoStickyOut_uid38_fpToFxPTest_merged_bit_select_b <= shiftVal_uid35_fpToFxPTest_q(4 downto 3);
    rightShiftStageSel4Dto3_uid61_rightShiferNoStickyOut_uid38_fpToFxPTest_merged_bit_select_c <= shiftVal_uid35_fpToFxPTest_q(2 downto 1);
    rightShiftStageSel4Dto3_uid61_rightShiferNoStickyOut_uid38_fpToFxPTest_merged_bit_select_d <= shiftVal_uid35_fpToFxPTest_q(0 downto 0);

    -- rightShiftStage2_uid78_rightShiferNoStickyOut_uid38_fpToFxPTest(MUX,77)@1
    rightShiftStage2_uid78_rightShiferNoStickyOut_uid38_fpToFxPTest_s <= rightShiftStageSel4Dto3_uid61_rightShiferNoStickyOut_uid38_fpToFxPTest_merged_bit_select_d;
    rightShiftStage2_uid78_rightShiferNoStickyOut_uid38_fpToFxPTest_combproc: PROCESS (rightShiftStage2_uid78_rightShiferNoStickyOut_uid38_fpToFxPTest_s, rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest_q, rightShiftStage2Idx1_uid76_rightShiferNoStickyOut_uid38_fpToFxPTest_q)
    BEGIN
        CASE (rightShiftStage2_uid78_rightShiferNoStickyOut_uid38_fpToFxPTest_s) IS
            WHEN "0" => rightShiftStage2_uid78_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= rightShiftStage1_uid73_rightShiferNoStickyOut_uid38_fpToFxPTest_q;
            WHEN "1" => rightShiftStage2_uid78_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= rightShiftStage2Idx1_uid76_rightShiferNoStickyOut_uid38_fpToFxPTest_q;
            WHEN OTHERS => rightShiftStage2_uid78_rightShiferNoStickyOut_uid38_fpToFxPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- zRightShiferNoStickyOut_uid41_fpToFxPTest(BITJOIN,40)@1
    zRightShiferNoStickyOut_uid41_fpToFxPTest_q <= GND_q & rightShiftStage2_uid78_rightShiferNoStickyOut_uid38_fpToFxPTest_q;

    -- xXorSignE_uid42_fpToFxPTest(LOGICAL,41)@1
    xXorSignE_uid42_fpToFxPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 1 => redist0_signX_uid25_fpToFxPTest_b_1_q(0)) & redist0_signX_uid25_fpToFxPTest_b_1_q));
    xXorSignE_uid42_fpToFxPTest_q <= zRightShiferNoStickyOut_uid41_fpToFxPTest_q xor xXorSignE_uid42_fpToFxPTest_b;

    -- sPostRndFull_uid44_fpToFxPTest(ADD,43)@1
    sPostRndFull_uid44_fpToFxPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => xXorSignE_uid42_fpToFxPTest_q(16)) & xXorSignE_uid42_fpToFxPTest_q));
    sPostRndFull_uid44_fpToFxPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 3 => d0_uid43_fpToFxPTest_q(2)) & d0_uid43_fpToFxPTest_q));
    sPostRndFull_uid44_fpToFxPTest_o <= STD_LOGIC_VECTOR(SIGNED(sPostRndFull_uid44_fpToFxPTest_a) + SIGNED(sPostRndFull_uid44_fpToFxPTest_b));
    sPostRndFull_uid44_fpToFxPTest_q <= sPostRndFull_uid44_fpToFxPTest_o(17 downto 0);

    -- sPostRnd_uid45_fpToFxPTest(BITSELECT,44)@1
    sPostRnd_uid45_fpToFxPTest_in <= sPostRndFull_uid44_fpToFxPTest_q(16 downto 0);
    sPostRnd_uid45_fpToFxPTest_b <= sPostRnd_uid45_fpToFxPTest_in(16 downto 1);

    -- udfExpVal_uid28_fpToFxPTest(CONSTANT,27)
    udfExpVal_uid28_fpToFxPTest_q <= "01101";

    -- udf_uid29_fpToFxPTest(COMPARE,28)@0 + 1
    udf_uid29_fpToFxPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((7 downto 5 => udfExpVal_uid28_fpToFxPTest_q(4)) & udfExpVal_uid28_fpToFxPTest_q));
    udf_uid29_fpToFxPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & exp_x_uid9_fpToFxPTest_b));
    udf_uid29_fpToFxPTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            udf_uid29_fpToFxPTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            udf_uid29_fpToFxPTest_o <= STD_LOGIC_VECTOR(SIGNED(udf_uid29_fpToFxPTest_a) - SIGNED(udf_uid29_fpToFxPTest_b));
        END IF;
    END PROCESS;
    udf_uid29_fpToFxPTest_n(0) <= not (udf_uid29_fpToFxPTest_o(7));

    -- sPostRnd_uid46_fpToFxPTest(BITSELECT,45)@1
    sPostRnd_uid46_fpToFxPTest_in <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((18 downto 18 => sPostRndFull_uid44_fpToFxPTest_q(17)) & sPostRndFull_uid44_fpToFxPTest_q));
    sPostRnd_uid46_fpToFxPTest_b <= STD_LOGIC_VECTOR(sPostRnd_uid46_fpToFxPTest_in(18 downto 1));

    -- rndOvfPos_uid47_fpToFxPTest(COMPARE,46)@1
    rndOvfPos_uid47_fpToFxPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0000" & maxPosValueS_uid39_fpToFxPTest_q));
    rndOvfPos_uid47_fpToFxPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((19 downto 18 => sPostRnd_uid46_fpToFxPTest_b(17)) & sPostRnd_uid46_fpToFxPTest_b));
    rndOvfPos_uid47_fpToFxPTest_o <= STD_LOGIC_VECTOR(SIGNED(rndOvfPos_uid47_fpToFxPTest_a) - SIGNED(rndOvfPos_uid47_fpToFxPTest_b));
    rndOvfPos_uid47_fpToFxPTest_c(0) <= rndOvfPos_uid47_fpToFxPTest_o(19);

    -- ovfExpVal_uid26_fpToFxPTest(CONSTANT,25)
    ovfExpVal_uid26_fpToFxPTest_q <= "011110";

    -- ovfExpRange_uid27_fpToFxPTest(COMPARE,26)@0 + 1
    ovfExpRange_uid27_fpToFxPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & exp_x_uid9_fpToFxPTest_b));
    ovfExpRange_uid27_fpToFxPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((7 downto 6 => ovfExpVal_uid26_fpToFxPTest_q(5)) & ovfExpVal_uid26_fpToFxPTest_q));
    ovfExpRange_uid27_fpToFxPTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            ovfExpRange_uid27_fpToFxPTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            ovfExpRange_uid27_fpToFxPTest_o <= STD_LOGIC_VECTOR(SIGNED(ovfExpRange_uid27_fpToFxPTest_a) - SIGNED(ovfExpRange_uid27_fpToFxPTest_b));
        END IF;
    END PROCESS;
    ovfExpRange_uid27_fpToFxPTest_n(0) <= not (ovfExpRange_uid27_fpToFxPTest_o(7));

    -- cstZeroWF_uid7_fpToFxPTest(CONSTANT,6)
    cstZeroWF_uid7_fpToFxPTest_q <= "0000000000";

    -- fracXIsZero_uid13_fpToFxPTest(LOGICAL,12)@1
    fracXIsZero_uid13_fpToFxPTest_q <= "1" WHEN cstZeroWF_uid7_fpToFxPTest_q = redist1_frac_x_uid10_fpToFxPTest_b_1_q ELSE "0";

    -- cstAllOWE_uid6_fpToFxPTest(CONSTANT,5)
    cstAllOWE_uid6_fpToFxPTest_q <= "11111";

    -- expXIsMax_uid12_fpToFxPTest(LOGICAL,11)@0 + 1
    expXIsMax_uid12_fpToFxPTest_qi <= "1" WHEN exp_x_uid9_fpToFxPTest_b = cstAllOWE_uid6_fpToFxPTest_q ELSE "0";
    expXIsMax_uid12_fpToFxPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid12_fpToFxPTest_qi, xout => expXIsMax_uid12_fpToFxPTest_q, clk => clk, aclr => areset );

    -- excI_x_uid15_fpToFxPTest(LOGICAL,14)@1
    excI_x_uid15_fpToFxPTest_q <= expXIsMax_uid12_fpToFxPTest_q and fracXIsZero_uid13_fpToFxPTest_q;

    -- fracXIsNotZero_uid14_fpToFxPTest(LOGICAL,13)@1
    fracXIsNotZero_uid14_fpToFxPTest_q <= not (fracXIsZero_uid13_fpToFxPTest_q);

    -- excN_x_uid16_fpToFxPTest(LOGICAL,15)@1
    excN_x_uid16_fpToFxPTest_q <= expXIsMax_uid12_fpToFxPTest_q and fracXIsNotZero_uid14_fpToFxPTest_q;

    -- ovfPostRnd_uid48_fpToFxPTest(LOGICAL,47)@1
    ovfPostRnd_uid48_fpToFxPTest_q <= excN_x_uid16_fpToFxPTest_q or excI_x_uid15_fpToFxPTest_q or ovfExpRange_uid27_fpToFxPTest_n or rndOvfPos_uid47_fpToFxPTest_c;

    -- muxSelConc_uid49_fpToFxPTest(BITJOIN,48)@1
    muxSelConc_uid49_fpToFxPTest_q <= redist0_signX_uid25_fpToFxPTest_b_1_q & udf_uid29_fpToFxPTest_n & ovfPostRnd_uid48_fpToFxPTest_q;

    -- muxSel_uid50_fpToFxPTest(LOOKUP,49)@1
    muxSel_uid50_fpToFxPTest_combproc: PROCESS (muxSelConc_uid49_fpToFxPTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (muxSelConc_uid49_fpToFxPTest_q) IS
            WHEN "000" => muxSel_uid50_fpToFxPTest_q <= "00";
            WHEN "001" => muxSel_uid50_fpToFxPTest_q <= "01";
            WHEN "010" => muxSel_uid50_fpToFxPTest_q <= "11";
            WHEN "011" => muxSel_uid50_fpToFxPTest_q <= "11";
            WHEN "100" => muxSel_uid50_fpToFxPTest_q <= "00";
            WHEN "101" => muxSel_uid50_fpToFxPTest_q <= "10";
            WHEN "110" => muxSel_uid50_fpToFxPTest_q <= "11";
            WHEN "111" => muxSel_uid50_fpToFxPTest_q <= "11";
            WHEN OTHERS => -- unreachable
                           muxSel_uid50_fpToFxPTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- finalOut_uid52_fpToFxPTest(MUX,51)@1
    finalOut_uid52_fpToFxPTest_s <= muxSel_uid50_fpToFxPTest_q;
    finalOut_uid52_fpToFxPTest_combproc: PROCESS (finalOut_uid52_fpToFxPTest_s, sPostRnd_uid45_fpToFxPTest_b, maxPosValueS_uid39_fpToFxPTest_q, maxNegValueS_uid40_fpToFxPTest_q, maxNegValueU_uid51_fpToFxPTest_q)
    BEGIN
        CASE (finalOut_uid52_fpToFxPTest_s) IS
            WHEN "00" => finalOut_uid52_fpToFxPTest_q <= sPostRnd_uid45_fpToFxPTest_b;
            WHEN "01" => finalOut_uid52_fpToFxPTest_q <= maxPosValueS_uid39_fpToFxPTest_q;
            WHEN "10" => finalOut_uid52_fpToFxPTest_q <= maxNegValueS_uid40_fpToFxPTest_q;
            WHEN "11" => finalOut_uid52_fpToFxPTest_q <= maxNegValueU_uid51_fpToFxPTest_q;
            WHEN OTHERS => finalOut_uid52_fpToFxPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- xOut(GPOUT,4)@1
    q <= finalOut_uid52_fpToFxPTest_q;

END normal;
