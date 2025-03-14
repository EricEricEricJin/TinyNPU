	component soc_system is
		port (
			avmm_sdram_wrapper_0_read_read_start   : in    std_logic                      := 'X';             -- read_start
			avmm_sdram_wrapper_0_read_read_data    : out   std_logic_vector(127 downto 0);                    -- read_data
			avmm_sdram_wrapper_0_read_read_valid   : out   std_logic;                                         -- read_valid
			avmm_sdram_wrapper_0_rw_rw_cnt         : in    std_logic_vector(10 downto 0)  := (others => 'X'); -- rw_cnt
			avmm_sdram_wrapper_0_rw_rw_done        : out   std_logic;                                         -- rw_done
			avmm_sdram_wrapper_0_rw_rw_addr        : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- rw_addr
			avmm_sdram_wrapper_0_write_write_data  : in    std_logic_vector(127 downto 0) := (others => 'X'); -- write_data
			avmm_sdram_wrapper_0_write_write_nxt   : out   std_logic;                                         -- write_nxt
			avmm_sdram_wrapper_0_write_write_start : in    std_logic                      := 'X';             -- write_start
			clk_clk                                : in    std_logic                      := 'X';             -- clk
			f2h_pio32_en_out                       : out   std_logic;                                         -- en_out
			f2h_pio32_data_in                      : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- data_in
			h2f_pio32_en_out                       : out   std_logic;                                         -- en_out
			h2f_pio32_data_out                     : out   std_logic_vector(31 downto 0);                     -- data_out
			h2f_reset_reset_n                      : out   std_logic;                                         -- reset_n
			memory_mem_a                           : out   std_logic_vector(14 downto 0);                     -- mem_a
			memory_mem_ba                          : out   std_logic_vector(2 downto 0);                      -- mem_ba
			memory_mem_ck                          : out   std_logic;                                         -- mem_ck
			memory_mem_ck_n                        : out   std_logic;                                         -- mem_ck_n
			memory_mem_cke                         : out   std_logic;                                         -- mem_cke
			memory_mem_cs_n                        : out   std_logic;                                         -- mem_cs_n
			memory_mem_ras_n                       : out   std_logic;                                         -- mem_ras_n
			memory_mem_cas_n                       : out   std_logic;                                         -- mem_cas_n
			memory_mem_we_n                        : out   std_logic;                                         -- mem_we_n
			memory_mem_reset_n                     : out   std_logic;                                         -- mem_reset_n
			memory_mem_dq                          : inout std_logic_vector(31 downto 0)  := (others => 'X'); -- mem_dq
			memory_mem_dqs                         : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n                       : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- mem_dqs_n
			memory_mem_odt                         : out   std_logic;                                         -- mem_odt
			memory_mem_dm                          : out   std_logic_vector(3 downto 0);                      -- mem_dm
			memory_oct_rzqin                       : in    std_logic                      := 'X';             -- oct_rzqin
			reset_reset_n                          : in    std_logic                      := 'X'              -- reset_n
		);
	end component soc_system;

	u0 : component soc_system
		port map (
			avmm_sdram_wrapper_0_read_read_start   => CONNECTED_TO_avmm_sdram_wrapper_0_read_read_start,   --  avmm_sdram_wrapper_0_read.read_start
			avmm_sdram_wrapper_0_read_read_data    => CONNECTED_TO_avmm_sdram_wrapper_0_read_read_data,    --                           .read_data
			avmm_sdram_wrapper_0_read_read_valid   => CONNECTED_TO_avmm_sdram_wrapper_0_read_read_valid,   --                           .read_valid
			avmm_sdram_wrapper_0_rw_rw_cnt         => CONNECTED_TO_avmm_sdram_wrapper_0_rw_rw_cnt,         --    avmm_sdram_wrapper_0_rw.rw_cnt
			avmm_sdram_wrapper_0_rw_rw_done        => CONNECTED_TO_avmm_sdram_wrapper_0_rw_rw_done,        --                           .rw_done
			avmm_sdram_wrapper_0_rw_rw_addr        => CONNECTED_TO_avmm_sdram_wrapper_0_rw_rw_addr,        --                           .rw_addr
			avmm_sdram_wrapper_0_write_write_data  => CONNECTED_TO_avmm_sdram_wrapper_0_write_write_data,  -- avmm_sdram_wrapper_0_write.write_data
			avmm_sdram_wrapper_0_write_write_nxt   => CONNECTED_TO_avmm_sdram_wrapper_0_write_write_nxt,   --                           .write_nxt
			avmm_sdram_wrapper_0_write_write_start => CONNECTED_TO_avmm_sdram_wrapper_0_write_write_start, --                           .write_start
			clk_clk                                => CONNECTED_TO_clk_clk,                                --                        clk.clk
			f2h_pio32_en_out                       => CONNECTED_TO_f2h_pio32_en_out,                       --                  f2h_pio32.en_out
			f2h_pio32_data_in                      => CONNECTED_TO_f2h_pio32_data_in,                      --                           .data_in
			h2f_pio32_en_out                       => CONNECTED_TO_h2f_pio32_en_out,                       --                  h2f_pio32.en_out
			h2f_pio32_data_out                     => CONNECTED_TO_h2f_pio32_data_out,                     --                           .data_out
			h2f_reset_reset_n                      => CONNECTED_TO_h2f_reset_reset_n,                      --                  h2f_reset.reset_n
			memory_mem_a                           => CONNECTED_TO_memory_mem_a,                           --                     memory.mem_a
			memory_mem_ba                          => CONNECTED_TO_memory_mem_ba,                          --                           .mem_ba
			memory_mem_ck                          => CONNECTED_TO_memory_mem_ck,                          --                           .mem_ck
			memory_mem_ck_n                        => CONNECTED_TO_memory_mem_ck_n,                        --                           .mem_ck_n
			memory_mem_cke                         => CONNECTED_TO_memory_mem_cke,                         --                           .mem_cke
			memory_mem_cs_n                        => CONNECTED_TO_memory_mem_cs_n,                        --                           .mem_cs_n
			memory_mem_ras_n                       => CONNECTED_TO_memory_mem_ras_n,                       --                           .mem_ras_n
			memory_mem_cas_n                       => CONNECTED_TO_memory_mem_cas_n,                       --                           .mem_cas_n
			memory_mem_we_n                        => CONNECTED_TO_memory_mem_we_n,                        --                           .mem_we_n
			memory_mem_reset_n                     => CONNECTED_TO_memory_mem_reset_n,                     --                           .mem_reset_n
			memory_mem_dq                          => CONNECTED_TO_memory_mem_dq,                          --                           .mem_dq
			memory_mem_dqs                         => CONNECTED_TO_memory_mem_dqs,                         --                           .mem_dqs
			memory_mem_dqs_n                       => CONNECTED_TO_memory_mem_dqs_n,                       --                           .mem_dqs_n
			memory_mem_odt                         => CONNECTED_TO_memory_mem_odt,                         --                           .mem_odt
			memory_mem_dm                          => CONNECTED_TO_memory_mem_dm,                          --                           .mem_dm
			memory_oct_rzqin                       => CONNECTED_TO_memory_oct_rzqin,                       --                           .oct_rzqin
			reset_reset_n                          => CONNECTED_TO_reset_reset_n                           --                      reset.reset_n
		);

