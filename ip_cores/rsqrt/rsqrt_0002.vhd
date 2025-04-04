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

-- VHDL created from rsqrt_0002
-- VHDL created on Thu Apr  3 03:09:29 2025


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

entity rsqrt_0002 is
    port (
        a : in std_logic_vector(15 downto 0);  -- float16_m10
        q : out std_logic_vector(15 downto 0);  -- float16_m10
        clk : in std_logic;
        areset : in std_logic
    );
end rsqrt_0002;

architecture normal of rsqrt_0002 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstAllOWE_uid6_fpInvSqrtTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal cstAllZWF_uid7_fpInvSqrtTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal cstNaNWF_uid8_fpInvSqrtTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal cstAllZWE_uid9_fpInvSqrtTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal cst3BiasM1o2M1_uid10_fpInvSqrtTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal cst3BiasP1o2M1_uid11_fpInvSqrtTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal exp_x_uid16_fpInvSqrtTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal frac_x_uid17_fpInvSqrtTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal excZ_x_uid18_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid19_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid20_fpInvSqrtTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid20_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid21_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_x_uid22_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid23_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signX_uid28_fpInvSqrtTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal evenOddExp_uid30_fpInvSqrtTest_in : STD_LOGIC_VECTOR (0 downto 0);
    signal evenOddExp_uid30_fpInvSqrtTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal addrYFull_uid31_fpInvSqrtTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal yAddr_uid33_fpInvSqrtTest_b : STD_LOGIC_VECTOR (5 downto 0);
    signal yPPolyEval_uid34_fpInvSqrtTest_in : STD_LOGIC_VECTOR (4 downto 0);
    signal yPPolyEval_uid34_fpInvSqrtTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal fxpInvSqrtRes_uid36_fpInvSqrtTest_in : STD_LOGIC_VECTOR (15 downto 0);
    signal fxpInvSqrtRes_uid36_fpInvSqrtTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal cstSel_uid40_fpInvSqrtTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal cstSel_uid40_fpInvSqrtTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal expRExt_uid41_fpInvSqrtTest_b : STD_LOGIC_VECTOR (3 downto 0);
    signal expRExt_uid42_fpInvSqrtTest_a : STD_LOGIC_VECTOR (5 downto 0);
    signal expRExt_uid42_fpInvSqrtTest_b : STD_LOGIC_VECTOR (5 downto 0);
    signal expRExt_uid42_fpInvSqrtTest_o : STD_LOGIC_VECTOR (5 downto 0);
    signal expRExt_uid42_fpInvSqrtTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal expR_uid43_fpInvSqrtTest_in : STD_LOGIC_VECTOR (4 downto 0);
    signal expR_uid43_fpInvSqrtTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal fxpInverseResFrac_uid44_fpInvSqrtTest_in : STD_LOGIC_VECTOR (9 downto 0);
    signal fxpInverseResFrac_uid44_fpInvSqrtTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal invSignX_uid45_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid46_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcXZ_uid47_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xRegNeg_uid48_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xNOxRNeg_uid49_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRConc_uid50_fpInvSqrtTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal outMuxSelEnc_uid51_fpInvSqrtTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid53_fpInvSqrtTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid53_fpInvSqrtTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal expRPostExc_uid54_fpInvSqrtTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid54_fpInvSqrtTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal signR_uid55_fpInvSqrtTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal R_uid56_fpInvSqrtTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal memoryC0_uid58_invSqrtTables_q : STD_LOGIC_VECTOR (9 downto 0);
    signal memoryC0_uid59_invSqrtTables_q : STD_LOGIC_VECTOR (4 downto 0);
    signal os_uid60_invSqrtTables_q : STD_LOGIC_VECTOR (14 downto 0);
    signal memoryC1_uid62_invSqrtTables_q : STD_LOGIC_VECTOR (8 downto 0);
    signal lowRangeB_uid69_invPolyEval_in : STD_LOGIC_VECTOR (1 downto 0);
    signal lowRangeB_uid69_invPolyEval_b : STD_LOGIC_VECTOR (1 downto 0);
    signal highBBits_uid70_invPolyEval_b : STD_LOGIC_VECTOR (8 downto 0);
    signal s1sumAHighB_uid71_invPolyEval_a : STD_LOGIC_VECTOR (15 downto 0);
    signal s1sumAHighB_uid71_invPolyEval_b : STD_LOGIC_VECTOR (15 downto 0);
    signal s1sumAHighB_uid71_invPolyEval_o : STD_LOGIC_VECTOR (15 downto 0);
    signal s1sumAHighB_uid71_invPolyEval_q : STD_LOGIC_VECTOR (15 downto 0);
    signal s1_uid72_invPolyEval_q : STD_LOGIC_VECTOR (17 downto 0);
    signal prodXY_uid74_pT1_uid68_invPolyEval_a0 : STD_LOGIC_VECTOR (4 downto 0);
    signal prodXY_uid74_pT1_uid68_invPolyEval_b0 : STD_LOGIC_VECTOR (8 downto 0);
    signal prodXY_uid74_pT1_uid68_invPolyEval_s1 : STD_LOGIC_VECTOR (13 downto 0);
    signal prodXY_uid74_pT1_uid68_invPolyEval_pr : SIGNED (14 downto 0);
    signal prodXY_uid74_pT1_uid68_invPolyEval_q : STD_LOGIC_VECTOR (13 downto 0);
    signal osig_uid75_pT1_uid68_invPolyEval_b : STD_LOGIC_VECTOR (10 downto 0);
    signal redist0_yAddr_uid33_fpInvSqrtTest_b_2_q : STD_LOGIC_VECTOR (5 downto 0);
    signal redist1_evenOddExp_uid30_fpInvSqrtTest_b_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist2_signX_uid28_fpInvSqrtTest_b_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist3_fracXIsZero_uid20_fpInvSqrtTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist4_exp_x_uid16_fpInvSqrtTest_b_2_q : STD_LOGIC_VECTOR (4 downto 0);

begin


    -- signX_uid28_fpInvSqrtTest(BITSELECT,27)@0
    signX_uid28_fpInvSqrtTest_b <= STD_LOGIC_VECTOR(a(15 downto 15));

    -- redist2_signX_uid28_fpInvSqrtTest_b_2(DELAY,78)
    redist2_signX_uid28_fpInvSqrtTest_b_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => signX_uid28_fpInvSqrtTest_b, xout => redist2_signX_uid28_fpInvSqrtTest_b_2_q, clk => clk, aclr => areset );

    -- cstAllZWE_uid9_fpInvSqrtTest(CONSTANT,8)
    cstAllZWE_uid9_fpInvSqrtTest_q <= "00000";

    -- exp_x_uid16_fpInvSqrtTest(BITSELECT,15)@0
    exp_x_uid16_fpInvSqrtTest_b <= a(14 downto 10);

    -- redist4_exp_x_uid16_fpInvSqrtTest_b_2(DELAY,80)
    redist4_exp_x_uid16_fpInvSqrtTest_b_2 : dspba_delay
    GENERIC MAP ( width => 5, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => exp_x_uid16_fpInvSqrtTest_b, xout => redist4_exp_x_uid16_fpInvSqrtTest_b_2_q, clk => clk, aclr => areset );

    -- excZ_x_uid18_fpInvSqrtTest(LOGICAL,17)@2
    excZ_x_uid18_fpInvSqrtTest_q <= "1" WHEN redist4_exp_x_uid16_fpInvSqrtTest_b_2_q = cstAllZWE_uid9_fpInvSqrtTest_q ELSE "0";

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- signR_uid55_fpInvSqrtTest(LOGICAL,54)@2
    signR_uid55_fpInvSqrtTest_q <= excZ_x_uid18_fpInvSqrtTest_q and redist2_signX_uid28_fpInvSqrtTest_b_2_q;

    -- cstAllOWE_uid6_fpInvSqrtTest(CONSTANT,5)
    cstAllOWE_uid6_fpInvSqrtTest_q <= "11111";

    -- expRExt_uid41_fpInvSqrtTest(BITSELECT,40)@2
    expRExt_uid41_fpInvSqrtTest_b <= redist4_exp_x_uid16_fpInvSqrtTest_b_2_q(4 downto 1);

    -- cst3BiasM1o2M1_uid10_fpInvSqrtTest(CONSTANT,9)
    cst3BiasM1o2M1_uid10_fpInvSqrtTest_q <= "10101";

    -- cst3BiasP1o2M1_uid11_fpInvSqrtTest(CONSTANT,10)
    cst3BiasP1o2M1_uid11_fpInvSqrtTest_q <= "10110";

    -- frac_x_uid17_fpInvSqrtTest(BITSELECT,16)@0
    frac_x_uid17_fpInvSqrtTest_b <= a(9 downto 0);

    -- cstAllZWF_uid7_fpInvSqrtTest(CONSTANT,6)
    cstAllZWF_uid7_fpInvSqrtTest_q <= "0000000000";

    -- fracXIsZero_uid20_fpInvSqrtTest(LOGICAL,19)@0 + 1
    fracXIsZero_uid20_fpInvSqrtTest_qi <= "1" WHEN cstAllZWF_uid7_fpInvSqrtTest_q = frac_x_uid17_fpInvSqrtTest_b ELSE "0";
    fracXIsZero_uid20_fpInvSqrtTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid20_fpInvSqrtTest_qi, xout => fracXIsZero_uid20_fpInvSqrtTest_q, clk => clk, aclr => areset );

    -- redist3_fracXIsZero_uid20_fpInvSqrtTest_q_2(DELAY,79)
    redist3_fracXIsZero_uid20_fpInvSqrtTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid20_fpInvSqrtTest_q, xout => redist3_fracXIsZero_uid20_fpInvSqrtTest_q_2_q, clk => clk, aclr => areset );

    -- evenOddExp_uid30_fpInvSqrtTest(BITSELECT,29)@0
    evenOddExp_uid30_fpInvSqrtTest_in <= STD_LOGIC_VECTOR(exp_x_uid16_fpInvSqrtTest_b(0 downto 0));
    evenOddExp_uid30_fpInvSqrtTest_b <= STD_LOGIC_VECTOR(evenOddExp_uid30_fpInvSqrtTest_in(0 downto 0));

    -- redist1_evenOddExp_uid30_fpInvSqrtTest_b_2(DELAY,77)
    redist1_evenOddExp_uid30_fpInvSqrtTest_b_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => evenOddExp_uid30_fpInvSqrtTest_b, xout => redist1_evenOddExp_uid30_fpInvSqrtTest_b_2_q, clk => clk, aclr => areset );

    -- concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest(BITJOIN,38)@2
    concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q <= redist3_fracXIsZero_uid20_fpInvSqrtTest_q_2_q & redist1_evenOddExp_uid30_fpInvSqrtTest_b_2_q;

    -- cstSel_uid40_fpInvSqrtTest(MUX,39)@2
    cstSel_uid40_fpInvSqrtTest_s <= concFracXIsZeroOddEvenSel_uid39_fpInvSqrtTest_q;
    cstSel_uid40_fpInvSqrtTest_combproc: PROCESS (cstSel_uid40_fpInvSqrtTest_s, cst3BiasP1o2M1_uid11_fpInvSqrtTest_q, cst3BiasM1o2M1_uid10_fpInvSqrtTest_q)
    BEGIN
        CASE (cstSel_uid40_fpInvSqrtTest_s) IS
            WHEN "00" => cstSel_uid40_fpInvSqrtTest_q <= cst3BiasP1o2M1_uid11_fpInvSqrtTest_q;
            WHEN "01" => cstSel_uid40_fpInvSqrtTest_q <= cst3BiasM1o2M1_uid10_fpInvSqrtTest_q;
            WHEN "10" => cstSel_uid40_fpInvSqrtTest_q <= cst3BiasP1o2M1_uid11_fpInvSqrtTest_q;
            WHEN "11" => cstSel_uid40_fpInvSqrtTest_q <= cst3BiasP1o2M1_uid11_fpInvSqrtTest_q;
            WHEN OTHERS => cstSel_uid40_fpInvSqrtTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- expRExt_uid42_fpInvSqrtTest(SUB,41)@2
    expRExt_uid42_fpInvSqrtTest_a <= STD_LOGIC_VECTOR("0" & cstSel_uid40_fpInvSqrtTest_q);
    expRExt_uid42_fpInvSqrtTest_b <= STD_LOGIC_VECTOR("00" & expRExt_uid41_fpInvSqrtTest_b);
    expRExt_uid42_fpInvSqrtTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expRExt_uid42_fpInvSqrtTest_a) - UNSIGNED(expRExt_uid42_fpInvSqrtTest_b));
    expRExt_uid42_fpInvSqrtTest_q <= expRExt_uid42_fpInvSqrtTest_o(5 downto 0);

    -- expR_uid43_fpInvSqrtTest(BITSELECT,42)@2
    expR_uid43_fpInvSqrtTest_in <= expRExt_uid42_fpInvSqrtTest_q(4 downto 0);
    expR_uid43_fpInvSqrtTest_b <= expR_uid43_fpInvSqrtTest_in(4 downto 0);

    -- invExcXZ_uid47_fpInvSqrtTest(LOGICAL,46)@2
    invExcXZ_uid47_fpInvSqrtTest_q <= not (excZ_x_uid18_fpInvSqrtTest_q);

    -- xRegNeg_uid48_fpInvSqrtTest(LOGICAL,47)@2
    xRegNeg_uid48_fpInvSqrtTest_q <= invExcXZ_uid47_fpInvSqrtTest_q and redist2_signX_uid28_fpInvSqrtTest_b_2_q;

    -- fracXIsNotZero_uid21_fpInvSqrtTest(LOGICAL,20)@2
    fracXIsNotZero_uid21_fpInvSqrtTest_q <= not (redist3_fracXIsZero_uid20_fpInvSqrtTest_q_2_q);

    -- expXIsMax_uid19_fpInvSqrtTest(LOGICAL,18)@2
    expXIsMax_uid19_fpInvSqrtTest_q <= "1" WHEN redist4_exp_x_uid16_fpInvSqrtTest_b_2_q = cstAllOWE_uid6_fpInvSqrtTest_q ELSE "0";

    -- excN_x_uid23_fpInvSqrtTest(LOGICAL,22)@2
    excN_x_uid23_fpInvSqrtTest_q <= expXIsMax_uid19_fpInvSqrtTest_q and fracXIsNotZero_uid21_fpInvSqrtTest_q;

    -- xNOxRNeg_uid49_fpInvSqrtTest(LOGICAL,48)@2
    xNOxRNeg_uid49_fpInvSqrtTest_q <= excN_x_uid23_fpInvSqrtTest_q or xRegNeg_uid48_fpInvSqrtTest_q;

    -- excI_x_uid22_fpInvSqrtTest(LOGICAL,21)@2
    excI_x_uid22_fpInvSqrtTest_q <= expXIsMax_uid19_fpInvSqrtTest_q and redist3_fracXIsZero_uid20_fpInvSqrtTest_q_2_q;

    -- invSignX_uid45_fpInvSqrtTest(LOGICAL,44)@2
    invSignX_uid45_fpInvSqrtTest_q <= not (redist2_signX_uid28_fpInvSqrtTest_b_2_q);

    -- excRZero_uid46_fpInvSqrtTest(LOGICAL,45)@2
    excRZero_uid46_fpInvSqrtTest_q <= invSignX_uid45_fpInvSqrtTest_q and excI_x_uid22_fpInvSqrtTest_q;

    -- excRConc_uid50_fpInvSqrtTest(BITJOIN,49)@2
    excRConc_uid50_fpInvSqrtTest_q <= xNOxRNeg_uid49_fpInvSqrtTest_q & excZ_x_uid18_fpInvSqrtTest_q & excRZero_uid46_fpInvSqrtTest_q;

    -- outMuxSelEnc_uid51_fpInvSqrtTest(LOOKUP,50)@2
    outMuxSelEnc_uid51_fpInvSqrtTest_combproc: PROCESS (excRConc_uid50_fpInvSqrtTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (excRConc_uid50_fpInvSqrtTest_q) IS
            WHEN "000" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "01";
            WHEN "001" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "00";
            WHEN "010" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "10";
            WHEN "011" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "00";
            WHEN "100" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "11";
            WHEN "101" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "00";
            WHEN "110" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "10";
            WHEN "111" => outMuxSelEnc_uid51_fpInvSqrtTest_q <= "01";
            WHEN OTHERS => -- unreachable
                           outMuxSelEnc_uid51_fpInvSqrtTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- expRPostExc_uid54_fpInvSqrtTest(MUX,53)@2
    expRPostExc_uid54_fpInvSqrtTest_s <= outMuxSelEnc_uid51_fpInvSqrtTest_q;
    expRPostExc_uid54_fpInvSqrtTest_combproc: PROCESS (expRPostExc_uid54_fpInvSqrtTest_s, cstAllZWE_uid9_fpInvSqrtTest_q, expR_uid43_fpInvSqrtTest_b, cstAllOWE_uid6_fpInvSqrtTest_q)
    BEGIN
        CASE (expRPostExc_uid54_fpInvSqrtTest_s) IS
            WHEN "00" => expRPostExc_uid54_fpInvSqrtTest_q <= cstAllZWE_uid9_fpInvSqrtTest_q;
            WHEN "01" => expRPostExc_uid54_fpInvSqrtTest_q <= expR_uid43_fpInvSqrtTest_b;
            WHEN "10" => expRPostExc_uid54_fpInvSqrtTest_q <= cstAllOWE_uid6_fpInvSqrtTest_q;
            WHEN "11" => expRPostExc_uid54_fpInvSqrtTest_q <= cstAllOWE_uid6_fpInvSqrtTest_q;
            WHEN OTHERS => expRPostExc_uid54_fpInvSqrtTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- cstNaNWF_uid8_fpInvSqrtTest(CONSTANT,7)
    cstNaNWF_uid8_fpInvSqrtTest_q <= "0000000001";

    -- addrYFull_uid31_fpInvSqrtTest(BITJOIN,30)@0
    addrYFull_uid31_fpInvSqrtTest_q <= evenOddExp_uid30_fpInvSqrtTest_b & frac_x_uid17_fpInvSqrtTest_b;

    -- yAddr_uid33_fpInvSqrtTest(BITSELECT,32)@0
    yAddr_uid33_fpInvSqrtTest_b <= addrYFull_uid31_fpInvSqrtTest_q(10 downto 5);

    -- memoryC1_uid62_invSqrtTables(LOOKUP,61)@0
    memoryC1_uid62_invSqrtTables_combproc: PROCESS (yAddr_uid33_fpInvSqrtTest_b)
    BEGIN
        -- Begin reserved scope level
        CASE (yAddr_uid33_fpInvSqrtTest_b) IS
            WHEN "000000" => memoryC1_uid62_invSqrtTables_q <= "101001111";
            WHEN "000001" => memoryC1_uid62_invSqrtTables_q <= "101010111";
            WHEN "000010" => memoryC1_uid62_invSqrtTables_q <= "101011110";
            WHEN "000011" => memoryC1_uid62_invSqrtTables_q <= "101100101";
            WHEN "000100" => memoryC1_uid62_invSqrtTables_q <= "101101100";
            WHEN "000101" => memoryC1_uid62_invSqrtTables_q <= "101110001";
            WHEN "000110" => memoryC1_uid62_invSqrtTables_q <= "101110111";
            WHEN "000111" => memoryC1_uid62_invSqrtTables_q <= "101111100";
            WHEN "001000" => memoryC1_uid62_invSqrtTables_q <= "110000001";
            WHEN "001001" => memoryC1_uid62_invSqrtTables_q <= "110000101";
            WHEN "001010" => memoryC1_uid62_invSqrtTables_q <= "110001010";
            WHEN "001011" => memoryC1_uid62_invSqrtTables_q <= "110001110";
            WHEN "001100" => memoryC1_uid62_invSqrtTables_q <= "110010001";
            WHEN "001101" => memoryC1_uid62_invSqrtTables_q <= "110010110";
            WHEN "001110" => memoryC1_uid62_invSqrtTables_q <= "110011000";
            WHEN "001111" => memoryC1_uid62_invSqrtTables_q <= "110011100";
            WHEN "010000" => memoryC1_uid62_invSqrtTables_q <= "110011111";
            WHEN "010001" => memoryC1_uid62_invSqrtTables_q <= "110100010";
            WHEN "010010" => memoryC1_uid62_invSqrtTables_q <= "110100101";
            WHEN "010011" => memoryC1_uid62_invSqrtTables_q <= "110100111";
            WHEN "010100" => memoryC1_uid62_invSqrtTables_q <= "110101010";
            WHEN "010101" => memoryC1_uid62_invSqrtTables_q <= "110101100";
            WHEN "010110" => memoryC1_uid62_invSqrtTables_q <= "110101111";
            WHEN "010111" => memoryC1_uid62_invSqrtTables_q <= "110110000";
            WHEN "011000" => memoryC1_uid62_invSqrtTables_q <= "110110011";
            WHEN "011001" => memoryC1_uid62_invSqrtTables_q <= "110110101";
            WHEN "011010" => memoryC1_uid62_invSqrtTables_q <= "110110111";
            WHEN "011011" => memoryC1_uid62_invSqrtTables_q <= "110111001";
            WHEN "011100" => memoryC1_uid62_invSqrtTables_q <= "110111010";
            WHEN "011101" => memoryC1_uid62_invSqrtTables_q <= "110111100";
            WHEN "011110" => memoryC1_uid62_invSqrtTables_q <= "110111110";
            WHEN "011111" => memoryC1_uid62_invSqrtTables_q <= "110111111";
            WHEN "100000" => memoryC1_uid62_invSqrtTables_q <= "100000110";
            WHEN "100001" => memoryC1_uid62_invSqrtTables_q <= "100010001";
            WHEN "100010" => memoryC1_uid62_invSqrtTables_q <= "100011100";
            WHEN "100011" => memoryC1_uid62_invSqrtTables_q <= "100100100";
            WHEN "100100" => memoryC1_uid62_invSqrtTables_q <= "100101110";
            WHEN "100101" => memoryC1_uid62_invSqrtTables_q <= "100110111";
            WHEN "100110" => memoryC1_uid62_invSqrtTables_q <= "100111101";
            WHEN "100111" => memoryC1_uid62_invSqrtTables_q <= "101000101";
            WHEN "101000" => memoryC1_uid62_invSqrtTables_q <= "101001100";
            WHEN "101001" => memoryC1_uid62_invSqrtTables_q <= "101010011";
            WHEN "101010" => memoryC1_uid62_invSqrtTables_q <= "101011000";
            WHEN "101011" => memoryC1_uid62_invSqrtTables_q <= "101011110";
            WHEN "101100" => memoryC1_uid62_invSqrtTables_q <= "101100100";
            WHEN "101101" => memoryC1_uid62_invSqrtTables_q <= "101101001";
            WHEN "101110" => memoryC1_uid62_invSqrtTables_q <= "101101110";
            WHEN "101111" => memoryC1_uid62_invSqrtTables_q <= "101110010";
            WHEN "110000" => memoryC1_uid62_invSqrtTables_q <= "101110111";
            WHEN "110001" => memoryC1_uid62_invSqrtTables_q <= "101111011";
            WHEN "110010" => memoryC1_uid62_invSqrtTables_q <= "101111111";
            WHEN "110011" => memoryC1_uid62_invSqrtTables_q <= "110000010";
            WHEN "110100" => memoryC1_uid62_invSqrtTables_q <= "110000111";
            WHEN "110101" => memoryC1_uid62_invSqrtTables_q <= "110001001";
            WHEN "110110" => memoryC1_uid62_invSqrtTables_q <= "110001101";
            WHEN "110111" => memoryC1_uid62_invSqrtTables_q <= "110010000";
            WHEN "111000" => memoryC1_uid62_invSqrtTables_q <= "110010011";
            WHEN "111001" => memoryC1_uid62_invSqrtTables_q <= "110010110";
            WHEN "111010" => memoryC1_uid62_invSqrtTables_q <= "110011000";
            WHEN "111011" => memoryC1_uid62_invSqrtTables_q <= "110011011";
            WHEN "111100" => memoryC1_uid62_invSqrtTables_q <= "110011110";
            WHEN "111101" => memoryC1_uid62_invSqrtTables_q <= "110011111";
            WHEN "111110" => memoryC1_uid62_invSqrtTables_q <= "110100011";
            WHEN "111111" => memoryC1_uid62_invSqrtTables_q <= "110100100";
            WHEN OTHERS => -- unreachable
                           memoryC1_uid62_invSqrtTables_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- yPPolyEval_uid34_fpInvSqrtTest(BITSELECT,33)@0
    yPPolyEval_uid34_fpInvSqrtTest_in <= frac_x_uid17_fpInvSqrtTest_b(4 downto 0);
    yPPolyEval_uid34_fpInvSqrtTest_b <= yPPolyEval_uid34_fpInvSqrtTest_in(4 downto 0);

    -- prodXY_uid74_pT1_uid68_invPolyEval(MULT,73)@0 + 2
    prodXY_uid74_pT1_uid68_invPolyEval_pr <= SIGNED(signed(resize(UNSIGNED(prodXY_uid74_pT1_uid68_invPolyEval_a0),6)) * SIGNED(prodXY_uid74_pT1_uid68_invPolyEval_b0));
    prodXY_uid74_pT1_uid68_invPolyEval_component: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid74_pT1_uid68_invPolyEval_a0 <= (others => '0');
            prodXY_uid74_pT1_uid68_invPolyEval_b0 <= (others => '0');
            prodXY_uid74_pT1_uid68_invPolyEval_s1 <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            prodXY_uid74_pT1_uid68_invPolyEval_a0 <= yPPolyEval_uid34_fpInvSqrtTest_b;
            prodXY_uid74_pT1_uid68_invPolyEval_b0 <= STD_LOGIC_VECTOR(memoryC1_uid62_invSqrtTables_q);
            prodXY_uid74_pT1_uid68_invPolyEval_s1 <= STD_LOGIC_VECTOR(resize(prodXY_uid74_pT1_uid68_invPolyEval_pr,14));
        END IF;
    END PROCESS;
    prodXY_uid74_pT1_uid68_invPolyEval_q <= prodXY_uid74_pT1_uid68_invPolyEval_s1;

    -- osig_uid75_pT1_uid68_invPolyEval(BITSELECT,74)@2
    osig_uid75_pT1_uid68_invPolyEval_b <= STD_LOGIC_VECTOR(prodXY_uid74_pT1_uid68_invPolyEval_q(13 downto 3));

    -- highBBits_uid70_invPolyEval(BITSELECT,69)@2
    highBBits_uid70_invPolyEval_b <= STD_LOGIC_VECTOR(osig_uid75_pT1_uid68_invPolyEval_b(10 downto 2));

    -- redist0_yAddr_uid33_fpInvSqrtTest_b_2(DELAY,76)
    redist0_yAddr_uid33_fpInvSqrtTest_b_2 : dspba_delay
    GENERIC MAP ( width => 6, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => yAddr_uid33_fpInvSqrtTest_b, xout => redist0_yAddr_uid33_fpInvSqrtTest_b_2_q, clk => clk, aclr => areset );

    -- memoryC0_uid59_invSqrtTables(LOOKUP,58)@2
    memoryC0_uid59_invSqrtTables_combproc: PROCESS (redist0_yAddr_uid33_fpInvSqrtTest_b_2_q)
    BEGIN
        -- Begin reserved scope level
        CASE (redist0_yAddr_uid33_fpInvSqrtTest_b_2_q) IS
            WHEN "000000" => memoryC0_uid59_invSqrtTables_q <= "01011";
            WHEN "000001" => memoryC0_uid59_invSqrtTables_q <= "01011";
            WHEN "000010" => memoryC0_uid59_invSqrtTables_q <= "01010";
            WHEN "000011" => memoryC0_uid59_invSqrtTables_q <= "01010";
            WHEN "000100" => memoryC0_uid59_invSqrtTables_q <= "01010";
            WHEN "000101" => memoryC0_uid59_invSqrtTables_q <= "01010";
            WHEN "000110" => memoryC0_uid59_invSqrtTables_q <= "01010";
            WHEN "000111" => memoryC0_uid59_invSqrtTables_q <= "01010";
            WHEN "001000" => memoryC0_uid59_invSqrtTables_q <= "01010";
            WHEN "001001" => memoryC0_uid59_invSqrtTables_q <= "01001";
            WHEN "001010" => memoryC0_uid59_invSqrtTables_q <= "01001";
            WHEN "001011" => memoryC0_uid59_invSqrtTables_q <= "01001";
            WHEN "001100" => memoryC0_uid59_invSqrtTables_q <= "01001";
            WHEN "001101" => memoryC0_uid59_invSqrtTables_q <= "01001";
            WHEN "001110" => memoryC0_uid59_invSqrtTables_q <= "01001";
            WHEN "001111" => memoryC0_uid59_invSqrtTables_q <= "01001";
            WHEN "010000" => memoryC0_uid59_invSqrtTables_q <= "01001";
            WHEN "010001" => memoryC0_uid59_invSqrtTables_q <= "01001";
            WHEN "010010" => memoryC0_uid59_invSqrtTables_q <= "01001";
            WHEN "010011" => memoryC0_uid59_invSqrtTables_q <= "01000";
            WHEN "010100" => memoryC0_uid59_invSqrtTables_q <= "01000";
            WHEN "010101" => memoryC0_uid59_invSqrtTables_q <= "01000";
            WHEN "010110" => memoryC0_uid59_invSqrtTables_q <= "01000";
            WHEN "010111" => memoryC0_uid59_invSqrtTables_q <= "01000";
            WHEN "011000" => memoryC0_uid59_invSqrtTables_q <= "01000";
            WHEN "011001" => memoryC0_uid59_invSqrtTables_q <= "01000";
            WHEN "011010" => memoryC0_uid59_invSqrtTables_q <= "01000";
            WHEN "011011" => memoryC0_uid59_invSqrtTables_q <= "01000";
            WHEN "011100" => memoryC0_uid59_invSqrtTables_q <= "01000";
            WHEN "011101" => memoryC0_uid59_invSqrtTables_q <= "01000";
            WHEN "011110" => memoryC0_uid59_invSqrtTables_q <= "01000";
            WHEN "011111" => memoryC0_uid59_invSqrtTables_q <= "01000";
            WHEN "100000" => memoryC0_uid59_invSqrtTables_q <= "10000";
            WHEN "100001" => memoryC0_uid59_invSqrtTables_q <= "01111";
            WHEN "100010" => memoryC0_uid59_invSqrtTables_q <= "01111";
            WHEN "100011" => memoryC0_uid59_invSqrtTables_q <= "01111";
            WHEN "100100" => memoryC0_uid59_invSqrtTables_q <= "01111";
            WHEN "100101" => memoryC0_uid59_invSqrtTables_q <= "01110";
            WHEN "100110" => memoryC0_uid59_invSqrtTables_q <= "01110";
            WHEN "100111" => memoryC0_uid59_invSqrtTables_q <= "01110";
            WHEN "101000" => memoryC0_uid59_invSqrtTables_q <= "01110";
            WHEN "101001" => memoryC0_uid59_invSqrtTables_q <= "01110";
            WHEN "101010" => memoryC0_uid59_invSqrtTables_q <= "01101";
            WHEN "101011" => memoryC0_uid59_invSqrtTables_q <= "01101";
            WHEN "101100" => memoryC0_uid59_invSqrtTables_q <= "01101";
            WHEN "101101" => memoryC0_uid59_invSqrtTables_q <= "01101";
            WHEN "101110" => memoryC0_uid59_invSqrtTables_q <= "01101";
            WHEN "101111" => memoryC0_uid59_invSqrtTables_q <= "01101";
            WHEN "110000" => memoryC0_uid59_invSqrtTables_q <= "01101";
            WHEN "110001" => memoryC0_uid59_invSqrtTables_q <= "01100";
            WHEN "110010" => memoryC0_uid59_invSqrtTables_q <= "01100";
            WHEN "110011" => memoryC0_uid59_invSqrtTables_q <= "01100";
            WHEN "110100" => memoryC0_uid59_invSqrtTables_q <= "01100";
            WHEN "110101" => memoryC0_uid59_invSqrtTables_q <= "01100";
            WHEN "110110" => memoryC0_uid59_invSqrtTables_q <= "01100";
            WHEN "110111" => memoryC0_uid59_invSqrtTables_q <= "01100";
            WHEN "111000" => memoryC0_uid59_invSqrtTables_q <= "01100";
            WHEN "111001" => memoryC0_uid59_invSqrtTables_q <= "01011";
            WHEN "111010" => memoryC0_uid59_invSqrtTables_q <= "01011";
            WHEN "111011" => memoryC0_uid59_invSqrtTables_q <= "01011";
            WHEN "111100" => memoryC0_uid59_invSqrtTables_q <= "01011";
            WHEN "111101" => memoryC0_uid59_invSqrtTables_q <= "01011";
            WHEN "111110" => memoryC0_uid59_invSqrtTables_q <= "01011";
            WHEN "111111" => memoryC0_uid59_invSqrtTables_q <= "01011";
            WHEN OTHERS => -- unreachable
                           memoryC0_uid59_invSqrtTables_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- memoryC0_uid58_invSqrtTables(LOOKUP,57)@2
    memoryC0_uid58_invSqrtTables_combproc: PROCESS (redist0_yAddr_uid33_fpInvSqrtTest_b_2_q)
    BEGIN
        -- Begin reserved scope level
        CASE (redist0_yAddr_uid33_fpInvSqrtTest_b_2_q) IS
            WHEN "000000" => memoryC0_uid58_invSqrtTables_q <= "0101000101";
            WHEN "000001" => memoryC0_uid58_invSqrtTables_q <= "0010010100";
            WHEN "000010" => memoryC0_uid58_invSqrtTables_q <= "1111101011";
            WHEN "000011" => memoryC0_uid58_invSqrtTables_q <= "1101001001";
            WHEN "000100" => memoryC0_uid58_invSqrtTables_q <= "1010101110";
            WHEN "000101" => memoryC0_uid58_invSqrtTables_q <= "1000011010";
            WHEN "000110" => memoryC0_uid58_invSqrtTables_q <= "0110001011";
            WHEN "000111" => memoryC0_uid58_invSqrtTables_q <= "0100000010";
            WHEN "001000" => memoryC0_uid58_invSqrtTables_q <= "0001111110";
            WHEN "001001" => memoryC0_uid58_invSqrtTables_q <= "1111111111";
            WHEN "001010" => memoryC0_uid58_invSqrtTables_q <= "1110000100";
            WHEN "001011" => memoryC0_uid58_invSqrtTables_q <= "1100001110";
            WHEN "001100" => memoryC0_uid58_invSqrtTables_q <= "1010011100";
            WHEN "001101" => memoryC0_uid58_invSqrtTables_q <= "1000101101";
            WHEN "001110" => memoryC0_uid58_invSqrtTables_q <= "0111000011";
            WHEN "001111" => memoryC0_uid58_invSqrtTables_q <= "0101011011";
            WHEN "010000" => memoryC0_uid58_invSqrtTables_q <= "0011110111";
            WHEN "010001" => memoryC0_uid58_invSqrtTables_q <= "0010010110";
            WHEN "010010" => memoryC0_uid58_invSqrtTables_q <= "0000111000";
            WHEN "010011" => memoryC0_uid58_invSqrtTables_q <= "1111011101";
            WHEN "010100" => memoryC0_uid58_invSqrtTables_q <= "1110000100";
            WHEN "010101" => memoryC0_uid58_invSqrtTables_q <= "1100101110";
            WHEN "010110" => memoryC0_uid58_invSqrtTables_q <= "1011011010";
            WHEN "010111" => memoryC0_uid58_invSqrtTables_q <= "1010001001";
            WHEN "011000" => memoryC0_uid58_invSqrtTables_q <= "1000111001";
            WHEN "011001" => memoryC0_uid58_invSqrtTables_q <= "0111101100";
            WHEN "011010" => memoryC0_uid58_invSqrtTables_q <= "0110100001";
            WHEN "011011" => memoryC0_uid58_invSqrtTables_q <= "0101011000";
            WHEN "011100" => memoryC0_uid58_invSqrtTables_q <= "0100010001";
            WHEN "011101" => memoryC0_uid58_invSqrtTables_q <= "0011001011";
            WHEN "011110" => memoryC0_uid58_invSqrtTables_q <= "0010000111";
            WHEN "011111" => memoryC0_uid58_invSqrtTables_q <= "0001000101";
            WHEN "100000" => memoryC0_uid58_invSqrtTables_q <= "0000000011";
            WHEN "100001" => memoryC0_uid58_invSqrtTables_q <= "1100001001";
            WHEN "100010" => memoryC0_uid58_invSqrtTables_q <= "1000011010";
            WHEN "100011" => memoryC0_uid58_invSqrtTables_q <= "0100110110";
            WHEN "100100" => memoryC0_uid58_invSqrtTables_q <= "0001011010";
            WHEN "100101" => memoryC0_uid58_invSqrtTables_q <= "1110001000";
            WHEN "100110" => memoryC0_uid58_invSqrtTables_q <= "1010111111";
            WHEN "100111" => memoryC0_uid58_invSqrtTables_q <= "0111111101";
            WHEN "101000" => memoryC0_uid58_invSqrtTables_q <= "0101000010";
            WHEN "101001" => memoryC0_uid58_invSqrtTables_q <= "0010001110";
            WHEN "101010" => memoryC0_uid58_invSqrtTables_q <= "1111100001";
            WHEN "101011" => memoryC0_uid58_invSqrtTables_q <= "1100111010";
            WHEN "101100" => memoryC0_uid58_invSqrtTables_q <= "1010011000";
            WHEN "101101" => memoryC0_uid58_invSqrtTables_q <= "0111111100";
            WHEN "101110" => memoryC0_uid58_invSqrtTables_q <= "0101100101";
            WHEN "101111" => memoryC0_uid58_invSqrtTables_q <= "0011010011";
            WHEN "110000" => memoryC0_uid58_invSqrtTables_q <= "0001000101";
            WHEN "110001" => memoryC0_uid58_invSqrtTables_q <= "1110111100";
            WHEN "110010" => memoryC0_uid58_invSqrtTables_q <= "1100110111";
            WHEN "110011" => memoryC0_uid58_invSqrtTables_q <= "1010110110";
            WHEN "110100" => memoryC0_uid58_invSqrtTables_q <= "1000111000";
            WHEN "110101" => memoryC0_uid58_invSqrtTables_q <= "0110111111";
            WHEN "110110" => memoryC0_uid58_invSqrtTables_q <= "0101001000";
            WHEN "110111" => memoryC0_uid58_invSqrtTables_q <= "0011010101";
            WHEN "111000" => memoryC0_uid58_invSqrtTables_q <= "0001100101";
            WHEN "111001" => memoryC0_uid58_invSqrtTables_q <= "1111111000";
            WHEN "111010" => memoryC0_uid58_invSqrtTables_q <= "1110001110";
            WHEN "111011" => memoryC0_uid58_invSqrtTables_q <= "1100100110";
            WHEN "111100" => memoryC0_uid58_invSqrtTables_q <= "1011000001";
            WHEN "111101" => memoryC0_uid58_invSqrtTables_q <= "1001011111";
            WHEN "111110" => memoryC0_uid58_invSqrtTables_q <= "0111111110";
            WHEN "111111" => memoryC0_uid58_invSqrtTables_q <= "0110100001";
            WHEN OTHERS => -- unreachable
                           memoryC0_uid58_invSqrtTables_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- os_uid60_invSqrtTables(BITJOIN,59)@2
    os_uid60_invSqrtTables_q <= memoryC0_uid59_invSqrtTables_q & memoryC0_uid58_invSqrtTables_q;

    -- s1sumAHighB_uid71_invPolyEval(ADD,70)@2
    s1sumAHighB_uid71_invPolyEval_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((15 downto 15 => os_uid60_invSqrtTables_q(14)) & os_uid60_invSqrtTables_q));
    s1sumAHighB_uid71_invPolyEval_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((15 downto 9 => highBBits_uid70_invPolyEval_b(8)) & highBBits_uid70_invPolyEval_b));
    s1sumAHighB_uid71_invPolyEval_o <= STD_LOGIC_VECTOR(SIGNED(s1sumAHighB_uid71_invPolyEval_a) + SIGNED(s1sumAHighB_uid71_invPolyEval_b));
    s1sumAHighB_uid71_invPolyEval_q <= s1sumAHighB_uid71_invPolyEval_o(15 downto 0);

    -- lowRangeB_uid69_invPolyEval(BITSELECT,68)@2
    lowRangeB_uid69_invPolyEval_in <= osig_uid75_pT1_uid68_invPolyEval_b(1 downto 0);
    lowRangeB_uid69_invPolyEval_b <= lowRangeB_uid69_invPolyEval_in(1 downto 0);

    -- s1_uid72_invPolyEval(BITJOIN,71)@2
    s1_uid72_invPolyEval_q <= s1sumAHighB_uid71_invPolyEval_q & lowRangeB_uid69_invPolyEval_b;

    -- fxpInvSqrtRes_uid36_fpInvSqrtTest(BITSELECT,35)@2
    fxpInvSqrtRes_uid36_fpInvSqrtTest_in <= s1_uid72_invPolyEval_q(15 downto 0);
    fxpInvSqrtRes_uid36_fpInvSqrtTest_b <= fxpInvSqrtRes_uid36_fpInvSqrtTest_in(15 downto 5);

    -- fxpInverseResFrac_uid44_fpInvSqrtTest(BITSELECT,43)@2
    fxpInverseResFrac_uid44_fpInvSqrtTest_in <= fxpInvSqrtRes_uid36_fpInvSqrtTest_b(9 downto 0);
    fxpInverseResFrac_uid44_fpInvSqrtTest_b <= fxpInverseResFrac_uid44_fpInvSqrtTest_in(9 downto 0);

    -- fracRPostExc_uid53_fpInvSqrtTest(MUX,52)@2
    fracRPostExc_uid53_fpInvSqrtTest_s <= outMuxSelEnc_uid51_fpInvSqrtTest_q;
    fracRPostExc_uid53_fpInvSqrtTest_combproc: PROCESS (fracRPostExc_uid53_fpInvSqrtTest_s, cstAllZWF_uid7_fpInvSqrtTest_q, fxpInverseResFrac_uid44_fpInvSqrtTest_b, cstNaNWF_uid8_fpInvSqrtTest_q)
    BEGIN
        CASE (fracRPostExc_uid53_fpInvSqrtTest_s) IS
            WHEN "00" => fracRPostExc_uid53_fpInvSqrtTest_q <= cstAllZWF_uid7_fpInvSqrtTest_q;
            WHEN "01" => fracRPostExc_uid53_fpInvSqrtTest_q <= fxpInverseResFrac_uid44_fpInvSqrtTest_b;
            WHEN "10" => fracRPostExc_uid53_fpInvSqrtTest_q <= cstAllZWF_uid7_fpInvSqrtTest_q;
            WHEN "11" => fracRPostExc_uid53_fpInvSqrtTest_q <= cstNaNWF_uid8_fpInvSqrtTest_q;
            WHEN OTHERS => fracRPostExc_uid53_fpInvSqrtTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- R_uid56_fpInvSqrtTest(BITJOIN,55)@2
    R_uid56_fpInvSqrtTest_q <= signR_uid55_fpInvSqrtTest_q & expRPostExc_uid54_fpInvSqrtTest_q & fracRPostExc_uid53_fpInvSqrtTest_q;

    -- xOut(GPOUT,4)@2
    q <= R_uid56_fpInvSqrtTest_q;

END normal;
