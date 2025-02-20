	component soc_system is
		port (
			f2h_pio32_en_out         : out   std_logic;                                         -- en_out
			f2h_pio32_data_in        : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- data_in
			f2h_sdram0_address       : in    std_logic_vector(27 downto 0)  := (others => 'X'); -- address
			f2h_sdram0_burstcount    : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- burstcount
			f2h_sdram0_waitrequest   : out   std_logic;                                         -- waitrequest
			f2h_sdram0_readdata      : out   std_logic_vector(127 downto 0);                    -- readdata
			f2h_sdram0_readdatavalid : out   std_logic;                                         -- readdatavalid
			f2h_sdram0_read          : in    std_logic                      := 'X';             -- read
			h2f_pio32_en_out         : out   std_logic;                                         -- en_out
			h2f_pio32_data_out       : out   std_logic_vector(31 downto 0);                     -- data_out
			h2f_reset_reset_n        : out   std_logic;                                         -- reset_n
			memory_mem_a             : out   std_logic_vector(14 downto 0);                     -- mem_a
			memory_mem_ba            : out   std_logic_vector(2 downto 0);                      -- mem_ba
			memory_mem_ck            : out   std_logic;                                         -- mem_ck
			memory_mem_ck_n          : out   std_logic;                                         -- mem_ck_n
			memory_mem_cke           : out   std_logic;                                         -- mem_cke
			memory_mem_cs_n          : out   std_logic;                                         -- mem_cs_n
			memory_mem_ras_n         : out   std_logic;                                         -- mem_ras_n
			memory_mem_cas_n         : out   std_logic;                                         -- mem_cas_n
			memory_mem_we_n          : out   std_logic;                                         -- mem_we_n
			memory_mem_reset_n       : out   std_logic;                                         -- mem_reset_n
			memory_mem_dq            : inout std_logic_vector(31 downto 0)  := (others => 'X'); -- mem_dq
			memory_mem_dqs           : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n         : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- mem_dqs_n
			memory_mem_odt           : out   std_logic;                                         -- mem_odt
			memory_mem_dm            : out   std_logic_vector(3 downto 0);                      -- mem_dm
			memory_oct_rzqin         : in    std_logic                      := 'X';             -- oct_rzqin
			ext_rst_reset_n          : in    std_logic                      := 'X';             -- reset_n
			sys_clk_clk              : out   std_logic;                                         -- clk
			pll_locked_export        : out   std_logic;                                         -- export
			ext_clk_clk              : in    std_logic                      := 'X';             -- clk
			sys_rst_reset_n          : in    std_logic                      := 'X'              -- reset_n
		);
	end component soc_system;

	u0 : component soc_system
		port map (
			f2h_pio32_en_out         => CONNECTED_TO_f2h_pio32_en_out,         --  f2h_pio32.en_out
			f2h_pio32_data_in        => CONNECTED_TO_f2h_pio32_data_in,        --           .data_in
			f2h_sdram0_address       => CONNECTED_TO_f2h_sdram0_address,       -- f2h_sdram0.address
			f2h_sdram0_burstcount    => CONNECTED_TO_f2h_sdram0_burstcount,    --           .burstcount
			f2h_sdram0_waitrequest   => CONNECTED_TO_f2h_sdram0_waitrequest,   --           .waitrequest
			f2h_sdram0_readdata      => CONNECTED_TO_f2h_sdram0_readdata,      --           .readdata
			f2h_sdram0_readdatavalid => CONNECTED_TO_f2h_sdram0_readdatavalid, --           .readdatavalid
			f2h_sdram0_read          => CONNECTED_TO_f2h_sdram0_read,          --           .read
			h2f_pio32_en_out         => CONNECTED_TO_h2f_pio32_en_out,         --  h2f_pio32.en_out
			h2f_pio32_data_out       => CONNECTED_TO_h2f_pio32_data_out,       --           .data_out
			h2f_reset_reset_n        => CONNECTED_TO_h2f_reset_reset_n,        --  h2f_reset.reset_n
			memory_mem_a             => CONNECTED_TO_memory_mem_a,             --     memory.mem_a
			memory_mem_ba            => CONNECTED_TO_memory_mem_ba,            --           .mem_ba
			memory_mem_ck            => CONNECTED_TO_memory_mem_ck,            --           .mem_ck
			memory_mem_ck_n          => CONNECTED_TO_memory_mem_ck_n,          --           .mem_ck_n
			memory_mem_cke           => CONNECTED_TO_memory_mem_cke,           --           .mem_cke
			memory_mem_cs_n          => CONNECTED_TO_memory_mem_cs_n,          --           .mem_cs_n
			memory_mem_ras_n         => CONNECTED_TO_memory_mem_ras_n,         --           .mem_ras_n
			memory_mem_cas_n         => CONNECTED_TO_memory_mem_cas_n,         --           .mem_cas_n
			memory_mem_we_n          => CONNECTED_TO_memory_mem_we_n,          --           .mem_we_n
			memory_mem_reset_n       => CONNECTED_TO_memory_mem_reset_n,       --           .mem_reset_n
			memory_mem_dq            => CONNECTED_TO_memory_mem_dq,            --           .mem_dq
			memory_mem_dqs           => CONNECTED_TO_memory_mem_dqs,           --           .mem_dqs
			memory_mem_dqs_n         => CONNECTED_TO_memory_mem_dqs_n,         --           .mem_dqs_n
			memory_mem_odt           => CONNECTED_TO_memory_mem_odt,           --           .mem_odt
			memory_mem_dm            => CONNECTED_TO_memory_mem_dm,            --           .mem_dm
			memory_oct_rzqin         => CONNECTED_TO_memory_oct_rzqin,         --           .oct_rzqin
			ext_rst_reset_n          => CONNECTED_TO_ext_rst_reset_n,          --    ext_rst.reset_n
			sys_clk_clk              => CONNECTED_TO_sys_clk_clk,              --    sys_clk.clk
			pll_locked_export        => CONNECTED_TO_pll_locked_export,        -- pll_locked.export
			ext_clk_clk              => CONNECTED_TO_ext_clk_clk,              --    ext_clk.clk
			sys_rst_reset_n          => CONNECTED_TO_sys_rst_reset_n           --    sys_rst.reset_n
		);

