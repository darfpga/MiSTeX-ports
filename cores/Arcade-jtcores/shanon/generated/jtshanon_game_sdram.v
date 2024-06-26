// jtshanon_game_sdram.v is automatically generated by JTFRAME
// Do not modify it
// Do not add it to git

`ifndef JTFRAME_COLORW
`define JTFRAME_COLORW 4
`endif

`ifndef JTFRAME_BUTTONS
`define JTFRAME_BUTTONS 2
`endif

module jtshanon_game_sdram(
    `include "jtframe_common_ports.inc"
    `include "jtframe_mem_ports.inc"
);

/* verilator lint_off WIDTH */
localparam [25:0] BA1_START  =`ifdef JTFRAME_BA1_START  `JTFRAME_BA1_START  `else 26'd0 `endif;
localparam [25:0] BA2_START  =`ifdef JTFRAME_BA2_START  `JTFRAME_BA2_START  `else 26'd0 `endif;
localparam [25:0] BA3_START  =`ifdef JTFRAME_BA3_START  `JTFRAME_BA3_START  `else 26'd0 `endif;
localparam [25:0] PROM_START =`ifdef JTFRAME_PROM_START `JTFRAME_PROM_START `else 26'd0 `endif;
localparam [25:0] HEADER_LEN =`ifdef JTFRAME_HEADER     `JTFRAME_HEADER     `else 26'd0 `endif;
/* verilator lint_on WIDTH */


parameter ROAD_START = `ROAD_START;
parameter FD_PROM = `FD1089_START;
parameter SND_OFFSET = (`SND_START-BA1_START)>>1;
parameter PCM_OFFSET = (`PCM_START-BA1_START)>>1;
parameter VRAM_OFFSET = 22'h10_0000;
parameter SRAM_OFFSET = 22'h18_0000;
parameter RD0_OFFSET = 3<<22 | (ROAD_START-`JTFRAME_BA3_START)>>1;
parameter RD1_OFFSET = RD0_OFFSET+26'h4000;

`ifndef JTFRAME_IOCTL_RD
wire ioctl_ram = 0;
`endif
// Audio channels 
wire signed [15:0] fm_l, fm_r;
wire signed [15:0] pcm_l, pcm_r;
wire mute;
// Additional ports
wire  gfx_cs;
wire [14:1] rd0_addr;
wire [15:0] rd0_data;

// BRAM buses

// SDRAM buses

wire [16:1] xram_addr;
wire [15:0] xram_data;
wire        xram_cs, xram_ok;
wire        xram_we;
wire [15:0] xram_din;
wire [ 1:0] xram_dsn;

wire [14:1] subram_addr;
wire [15:0] subram_data;
wire        subram_cs, subram_ok;
wire        subram_we;
wire [15:0] subram_din;
wire [ 1:0] subram_dsn;

wire [18:1] main_addr;
wire [15:0] main_data;
wire        main_cs, main_ok;
wire [15:1] map1_addr;
wire [15:0] map1_data;
wire        map1_cs, map1_ok;
wire [15:1] map2_addr;
wire [15:0] map2_data;
wire        map2_cs, map2_ok;
wire [18:1] subrom_addr;
wire [15:0] subrom_data;
wire        subrom_cs, subrom_ok;
wire [15:0] snd_addr;
wire [ 7:0] snd_data;
wire        snd_cs, snd_ok;
wire [18:0] pcm_addr;
wire [ 7:0] pcm_data;
wire        pcm_cs, pcm_ok;
wire [13:2] char_addr;
wire [31:0] char_data;
wire        char_cs, char_ok;
wire [17:2] scr1_addr;
wire [31:0] scr1_data;
wire        scr1_cs, scr1_ok;
wire [17:2] scr2_addr;
wire [31:0] scr2_data;
wire        scr2_cs, scr2_ok;
wire [19:1] obj_addr;
wire [15:0] obj_data;
wire        obj_cs, obj_ok;
wire        prom_we, header;
wire [21:0] raw_addr, post_addr;
wire [25:0] pre_addr, dwnld_addr, ioctl_addr_noheader;
wire [ 7:0] post_data;
wire [15:0] raw_data;
wire        pass_io;
// Clock enable signals
wire cen_pcm; 
wire cen_fm; 
wire cen_fm2; 
wire cen_snd; 
wire cen_nc; 
wire gfx8_en, gfx16_en, ioctl_dwn;

assign pass_io = header | ioctl_ram;
assign ioctl_addr_noheader = `ifdef JTFRAME_HEADER header ? ioctl_addr : ioctl_addr - HEADER_LEN `else ioctl_addr `endif ;

wire rst_h, rst24_h, rst48_h, hold_rst;
/* verilator tracing_off */
jtframe_rsthold u_hold(
    .rst    ( rst       ),
    .clk    ( clk       ),
    .hold   ( hold_rst  ),
    .rst_h  ( rst_h     )
`ifdef JTFRAME_CLK24 ,
    .rst24  ( rst24     ),
    .clk24  ( clk24     ),
    .rst24_h( rst24_h   )
`endif
`ifdef JTFRAME_CLK48 ,
    .rst48  ( rst48     ),
    .clk48  ( clk48     ),
    .rst48_h( rst48_h   )
`endif
);
/* verilator tracing_on */
jtoutrun_game u_game(
    .rst        ( rst_h     ),
    .clk        ( clk       ),
`ifdef JTFRAME_CLK24
    .rst24      ( rst24_h   ),
    .clk24      ( clk24     ),
`endif
`ifdef JTFRAME_CLK48
    .rst48      ( rst48_h   ),
    .clk48      ( clk48     ),
`endif
    // Audio channels
    .mute( mute ),
    .fm_l   ( fm_l    ),
    .fm_r   ( fm_r    ),.pcm_l   ( pcm_l    ),
    .pcm_r   ( pcm_r    ),
    
    .snd_en         ( snd_en        ),
    .cen_pcm    ( cen_pcm    ), 
    .cen_fm    ( cen_fm    ), 
    .cen_fm2    ( cen_fm2    ), 
    .cen_snd    ( cen_snd    ), 
    .cen_nc    ( cen_nc    ), 

    .pxl2_cen       ( pxl2_cen      ),
    .pxl_cen        ( pxl_cen       ),
    .red            ( red           ),
    .green          ( green         ),
    .blue           ( blue          ),
    .LHBL           ( LHBL          ),
    .LVBL           ( LVBL          ),
    .HS             ( HS            ),
    .VS             ( VS            ),
    // cabinet I/O
    .cab_1p   ( cab_1p  ),
    .coin     ( coin    ),
    .joystick1    ( joystick1        ), .joystick2    ( joystick2        ), `ifdef JTFRAME_4PLAYERS
    .joystick3    ( joystick3        ), .joystick4    ( joystick4        ), `endif `ifdef JTFRAME_MOUSE
    .mouse_1p     ( mouse_1p         ), .mouse_2p     ( mouse_2p         ), `endif `ifdef JTFRAME_SPINNER
    .spinner_1p   ( spinner_1p       ), .spinner_2p   ( spinner_2p       ), `endif `ifdef JTFRAME_ANALOG
    .joyana_l1    ( joyana_l1        ), .joyana_l2    ( joyana_l2        ), `ifdef JTFRAME_ANALOG_DUAL
    .joyana_r1    ( joyana_r1        ), .joyana_r2    ( joyana_r2        ), `endif `ifdef JTFRAME_4PLAYERS
    .joyana_l3    ( joyana_l3        ), .joyana_l4    ( joyana_l4        ), `ifdef JTFRAME_ANALOG_DUAL
    .joyana_r3    ( joyana_r3        ), .joyana_r4    ( joyana_r4        ), `endif `endif `endif `ifdef JTFRAME_DIAL
    .dial_x       ( dial_x           ), .dial_y       ( dial_y           ), `endif
    // DIP switches
    .status         ( status        ),
    .dipsw          ( dipsw         ),
    .service        ( service       ),
    .tilt           ( tilt          ),
    .dip_pause      ( dip_pause     ),
    .dip_flip       ( dip_flip      ),
    .dip_test       ( dip_test      ),
    .dip_fxlevel    ( dip_fxlevel   ),
    .enable_psg     ( enable_psg    ),
    .enable_fm      ( enable_fm     ),
    // Ports declared in mem.yaml
    .gfx_cs   ( gfx_cs ),
    .rd0_addr   ( rd0_addr ),
    .rd0_data   ( rd0_data ),
    // Memory interface - SDRAM
    .xram_addr ( xram_addr ),
    .xram_cs   ( xram_cs   ),
    .xram_ok   ( xram_ok   ),
    .xram_data ( xram_data ),
    .xram_we   ( xram_we   ),
    .xram_dsn  ( xram_dsn  ),
    .xram_din  ( xram_din  ),
    
    .subram_addr ( subram_addr ),
    .subram_cs   ( subram_cs   ),
    .subram_ok   ( subram_ok   ),
    .subram_data ( subram_data ),
    .subram_we   ( subram_we   ),
    .subram_dsn  ( subram_dsn  ),
    .subram_din  ( subram_din  ),
    
    .main_addr ( main_addr ),
    .main_cs   ( main_cs   ),
    .main_ok   ( main_ok   ),
    .main_data ( main_data ),
    
    .map1_addr ( map1_addr ),
    .map1_ok   ( map1_ok   ),
    .map1_data ( map1_data ),
    
    .map2_addr ( map2_addr ),
    .map2_ok   ( map2_ok   ),
    .map2_data ( map2_data ),
    
    .subrom_addr ( subrom_addr ),
    .subrom_cs   ( subrom_cs   ),
    .subrom_ok   ( subrom_ok   ),
    .subrom_data ( subrom_data ),
    
    .snd_addr ( snd_addr ),
    .snd_cs   ( snd_cs   ),
    .snd_ok   ( snd_ok   ),
    .snd_data ( snd_data ),
    
    .pcm_addr ( pcm_addr ),
    .pcm_cs   ( pcm_cs   ),
    .pcm_ok   ( pcm_ok   ),
    .pcm_data ( pcm_data ),
    
    .char_addr ( char_addr ),
    .char_ok   ( char_ok   ),
    .char_data ( char_data ),
    
    .scr1_addr ( scr1_addr ),
    .scr1_ok   ( scr1_ok   ),
    .scr1_data ( scr1_data ),
    
    .scr2_addr ( scr2_addr ),
    .scr2_ok   ( scr2_ok   ),
    .scr2_data ( scr2_data ),
    
    .obj_addr ( obj_addr ),
    .obj_cs   ( obj_cs   ),
    .obj_ok   ( obj_ok   ),
    .obj_data ( obj_data ),
    
    // Memory interface - BRAM

    // PROM writting
    .ioctl_addr   ( pass_io ? ioctl_addr       : ioctl_addr_noheader  ),
    .prog_addr    ( pass_io ? ioctl_addr[21:0] : raw_addr      ),
    .prog_data    ( pass_io ? ioctl_dout       : raw_data[7:0] ),
    .prog_we      ( pass_io ? ioctl_wr         : prog_we       ),
    .prog_ba      ( prog_ba        ), // prog_ba supplied in case it helps re-mapping addresses
`ifdef JTFRAME_PROM_START
    .prom_we      ( prom_we        ),
`endif
`ifdef JTFRAME_HEADER
    .header       ( header         ),
`endif
`ifdef JTFRAME_IOCTL_RD
    .ioctl_ram    ( ioctl_ram      ),
    .ioctl_din    ( ioctl_din      ),
    .ioctl_dout   ( ioctl_dout     ),
    .ioctl_wr     ( ioctl_wr       ), `endif
    .ioctl_cart   ( ioctl_cart     ),
    // Debug
    .debug_bus    ( debug_bus      ),
    .debug_view   ( debug_view     ),
`ifdef JTFRAME_STATUS
    .st_addr      ( st_addr        ),
    .st_dout      ( st_dout        ),
`endif
`ifdef JTFRAME_LF_BUFFER
    .game_vrender( game_vrender  ),
    .game_hdump  ( game_hdump    ),
    .ln_addr     ( ln_addr       ),
    .ln_data     ( ln_data       ),
    .ln_done     ( ln_done       ),
    .ln_hs       ( ln_hs         ),
    .ln_pxl      ( ln_pxl        ),
    .ln_v        ( ln_v          ),
    .ln_we       ( ln_we         ),
`endif
    .gfx_en      ( gfx_en        )
);
/* verilator tracing_off */
assign dwnld_busy = ioctl_rom | prom_we; // prom_we is really just for sims
assign dwnld_addr = ioctl_addr;
assign prog_addr = raw_addr;
assign prog_data = raw_data;
assign gfx8_en   = 0;
assign gfx16_en  = 0;
assign ioctl_dwn = ioctl_rom | ioctl_cart;
`ifdef VERILATOR_KEEP_SDRAM /* verilator tracing_on */ `else /* verilator tracing_off */ `endif
jtframe_dwnld #(
`ifdef JTFRAME_HEADER
    .HEADER    ( `JTFRAME_HEADER   ),
`endif
`ifdef JTFRAME_BA1_START
    .BA1_START ( BA1_START ),
`endif
`ifdef JTFRAME_BA2_START
    .BA2_START ( BA2_START ),
`endif
`ifdef JTFRAME_BA3_START
    .BA3_START ( BA3_START ),
`endif
`ifdef JTFRAME_PROM_START
    .PROM_START( PROM_START ),
`endif
    .SWAB      ( 1),
    .GFX8B0    ( 0),
    .GFX16B0   ( 0)
) u_dwnld(
    .clk          ( clk            ),
    .ioctl_rom    ( ioctl_dwn      ),
    .ioctl_addr   ( dwnld_addr     ),
    .ioctl_dout   ( ioctl_dout     ),
    .ioctl_wr     ( ioctl_wr       ),
    .gfx8_en      ( gfx8_en        ),
    .gfx16_en     ( gfx16_en       ),
    .prog_addr    ( raw_addr       ),
    .prog_data    ( raw_data       ),
    .prog_mask    ( prog_mask      ), // active low
    .prog_we      ( prog_we        ),
    .prog_rd      ( prog_rd        ),
    .prog_ba      ( prog_ba        ),
    .prom_we      ( prom_we        ),
    .header       ( header         ),
    .sdram_ack    ( prog_ack       )
);
`ifdef VERILATOR_KEEP_SDRAM /* verilator tracing_on */ `else /* verilator tracing_off */ `endif



jtframe_ram2_5slots #(
    // xram
    .SLOT0_AW(16),
    .SLOT0_DW(16), 
    // subram
    .SLOT1_AW(14),
    .SLOT1_DW(16), 
    // main
    .SLOT2_AW(18),
    .SLOT2_DW(16), 
    // map1
    .SLOT3_OFFSET(VRAM_OFFSET[21:0]),
    .SLOT3_AW(15),
    .SLOT3_DW(16), 
    // map2
    .SLOT4_OFFSET(VRAM_OFFSET[21:0]),
    .SLOT4_AW(15),
    .SLOT4_DW(16)
`ifdef JTFRAME_BA2_LEN
    ,.SLOT2_DOUBLE(1)
    ,.SLOT3_DOUBLE(1)
    ,.SLOT4_DOUBLE(1)
`endif
) u_bank0(
    .rst         ( rst        ),
    .clk         ( clk        ),
    
    .slot0_addr  ( xram_addr  ),
    .hold_rst    ( hold_rst        ), 
    .slot0_wen   ( xram_we    ),
    .slot0_din   ( xram_din   ),
    .slot0_wrmask( xram_dsn   ),
    .slot0_offset( VRAM_OFFSET[21:0] ),
    .slot0_dout  ( xram_data  ),
    .slot0_cs    ( xram_cs    ),
    .slot0_ok    ( xram_ok    ),
    
    .slot1_addr  ( subram_addr  ),
    .slot1_wen   ( subram_we    ),
    .slot1_din   ( subram_din   ),
    .slot1_wrmask( subram_dsn   ),
    .slot1_offset( SRAM_OFFSET[21:0] ),
    .slot1_dout  ( subram_data  ),
    .slot1_cs    ( subram_cs    ),
    .slot1_ok    ( subram_ok    ),
    
    .slot2_addr  ( main_addr  ),
    .slot2_clr   ( 1'b0       ), // only 1'b0 supported in mem.yaml
    .slot2_dout  ( main_data  ),
    .slot2_cs    ( main_cs    ),
    .slot2_ok    ( main_ok    ),
    
    .slot3_addr  ( map1_addr  ),
    .slot3_clr   ( 1'b0       ), // only 1'b0 supported in mem.yaml
    .slot3_dout  ( map1_data  ),
    .slot3_cs    ( gfx_cs    ),
    .slot3_ok    ( map1_ok    ),
    
    .slot4_addr  ( map2_addr  ),
    .slot4_clr   ( 1'b0       ), // only 1'b0 supported in mem.yaml
    .slot4_dout  ( map2_data  ),
    .slot4_cs    ( gfx_cs    ),
    .slot4_ok    ( map2_ok    ),
    
    // SDRAM controller interface
    .sdram_ack   ( ba_ack[0]  ),
    .sdram_rd    ( ba_rd[0]   ),
    .sdram_addr  ( ba0_addr   ),
    .sdram_wr    ( ba_wr[0]   ),
    .sdram_wrmask( ba0_dsn    ),
    .data_write  ( ba0_din    ),
    .data_dst    ( ba_dst[0]  ),
    .data_rdy    ( ba_rdy[0]  ),
    .data_read   ( data_read  )
);
jtframe_rom_3slots #(
    // subrom
    .SLOT0_AW(18),
    .SLOT0_DW(16), 
    // snd
    .SLOT1_OFFSET(SND_OFFSET[21:0]),
    .SLOT1_AW(16),
    .SLOT1_DW( 8), 
    // pcm
    .SLOT2_OFFSET(PCM_OFFSET[21:0]),
    .SLOT2_AW(19),
    .SLOT2_DW( 8)
`ifdef JTFRAME_BA2_LEN
    ,.SLOT0_DOUBLE(1)
    ,.SLOT1_DOUBLE(1)
    ,.SLOT2_DOUBLE(1)
`endif
) u_bank1(
    .rst         ( rst        ),
    .clk         ( clk        ),
    
    .slot0_addr  ( subrom_addr  ),
    .slot0_dout  ( subrom_data  ),
    .slot0_cs    ( subrom_cs    ),
    .slot0_ok    ( subrom_ok    ),
    
    .slot1_addr  ( snd_addr  ),
    .slot1_dout  ( snd_data  ),
    .slot1_cs    ( snd_cs    ),
    .slot1_ok    ( snd_ok    ),
    
    .slot2_addr  ( pcm_addr  ),
    .slot2_dout  ( pcm_data  ),
    .slot2_cs    ( pcm_cs    ),
    .slot2_ok    ( pcm_ok    ),
    
    // SDRAM controller interface
    .sdram_ack   ( ba_ack[1]  ),
    .sdram_rd    ( ba_rd[1]   ),
    .sdram_addr  ( ba1_addr   ),
    .data_dst    ( ba_dst[1]  ),
    .data_rdy    ( ba_rdy[1]  ),
    .data_read   ( data_read  )
);
assign ba_wr[1] = 0;
assign ba1_din  = 0;
assign ba1_dsn  = 3;
jtframe_rom_3slots #(
    // char
    .SLOT0_AW(13),
    .SLOT0_DW(32), 
    // scr1
    .SLOT1_AW(17),
    .SLOT1_DW(32), 
    // scr2
    .SLOT2_AW(17),
    .SLOT2_DW(32)
`ifdef JTFRAME_BA2_LEN
    ,.SLOT0_DOUBLE(1)
    ,.SLOT1_DOUBLE(1)
    ,.SLOT2_DOUBLE(1)
`endif
) u_bank2(
    .rst         ( rst        ),
    .clk         ( clk        ),
    
    .slot0_addr  ( { char_addr, 1'b0 } ),
    .slot0_dout  ( char_data  ),
    .slot0_cs    ( gfx_cs    ),
    .slot0_ok    ( char_ok    ),
    
    .slot1_addr  ( { scr1_addr, 1'b0 } ),
    .slot1_dout  ( scr1_data  ),
    .slot1_cs    ( gfx_cs    ),
    .slot1_ok    ( scr1_ok    ),
    
    .slot2_addr  ( { scr2_addr, 1'b0 } ),
    .slot2_dout  ( scr2_data  ),
    .slot2_cs    ( gfx_cs    ),
    .slot2_ok    ( scr2_ok    ),
    
    // SDRAM controller interface
    .sdram_ack   ( ba_ack[2]  ),
    .sdram_rd    ( ba_rd[2]   ),
    .sdram_addr  ( ba2_addr   ),
    .data_dst    ( ba_dst[2]  ),
    .data_rdy    ( ba_rdy[2]  ),
    .data_read   ( data_read  )
);
assign ba_wr[2] = 0;
assign ba2_din  = 0;
assign ba2_dsn  = 3;
jtframe_rom_1slot #(
    // obj
    .SLOT0_AW(19),
    .SLOT0_DW(16)
`ifdef JTFRAME_BA2_LEN
    ,.SLOT0_DOUBLE(1)
`endif
) u_bank3(
    .rst         ( rst        ),
    .clk         ( clk        ),
    
    .slot0_addr  ( obj_addr  ),
    .slot0_dout  ( obj_data  ),
    .slot0_cs    ( obj_cs    ),
    .slot0_ok    ( obj_ok    ),
    
    // SDRAM controller interface
    .sdram_ack   ( ba_ack[3]  ),
    .sdram_rd    ( ba_rd[3]   ),
    .sdram_addr  ( ba3_addr   ),
    .data_dst    ( ba_dst[3]  ),
    .data_rdy    ( ba_rdy[3]  ),
    .data_read   ( data_read  )
);
assign ba_wr[3] = 0;
assign ba3_din  = 0;
assign ba3_dsn  = 3;


/* verilator tracing_off */

jtframe_bram_rom #(
    .AW(15-1),.DW(16),
    .OFFSET(RD0_OFFSET),
    .SIMFILE_LO("rd0_lo.bin"),
    .SIMFILE_HI("rd0_hi.bin")
) u_brom_rd0(
    .clk    ( clk       ),
    // Read port
    .addr   ( rd0_addr ),
    .data   ( rd0_data ),
    // Write port
    .prog_addr( {prog_ba,prog_addr} ),
    .prog_mask( prog_mask ),
    .prog_data( prog_data[7:0] ),
    .prog_we  ( prog_we   )
);
/* verilator tracing_off */





// Clock enable generation
// 7999999 = 50318176*7851/49381 Hz from clk
`ifdef VERILATOR_KEEP_CEN /* verilator tracing_on */ `else /* verilator tracing_off */ `endif
jtframe_gated_cen #(.W(3),.NUM(7851),.DEN(49381),.MFREQ(50318)) u_cen0_clk(
    .rst    ( rst          ),
    .clk    ( clk ),
    .busy   ( 1'b0    ),
    .cen    ( { cen_fm2, cen_fm, cen_pcm } ),
    .fave   (              ),
    .fworst (              )
); /* verilator tracing_off */

// 5000000 = 50318176*6443/64840 Hz from clk
`ifdef VERILATOR_KEEP_CEN /* verilator tracing_on */ `else /* verilator tracing_off */ `endif
jtframe_gated_cen #(.W(2),.NUM(6443),.DEN(64840),.MFREQ(50318)) u_cen1_clk(
    .rst    ( rst          ),
    .clk    ( clk ),
    .busy   ( 1'b0    ),
    .cen    ( { cen_nc, cen_snd } ),
    .fave   (              ),
    .fworst (              )
); /* verilator tracing_off */

`ifndef NOSOUND/* verilator tracing_on */
jtframe_rcmix #(
    .W0(16),
    .W1(16),
    .STEREO0( 1),
    .STEREO1( 1),
    .STEREO2( 0),
    .STEREO3( 0),
    .STEREO4( 0),
    .STEREO5( 0),
    .DCRM0  ( 0),
    .DCRM1  ( 0),
    .DCRM2  ( 0),
    .DCRM3  ( 0),
    .DCRM4  ( 0),
    .DCRM5  ( 0),
    .STEREO (      1),
    // Fractional cen for 192kHz
    .FRACW( 17), .FRACN(149), .FRACM(39049)
) u_rcmix(
    .rst    ( rst       ),
    .clk    ( clk       ),
    .mute   ( mute      ),
    .sample ( sample    ),
    .ch_en  ( snd_en    ),
    .gpole  ( 8'h86 ),  // 19894 Hz 
    .ch0    ( { fm_l,fm_r } ),
    .ch1    ( { pcm_l,pcm_r } ),
    .ch2    ( 16'd0 ),
    .ch3    ( 16'd0 ),
    .ch4    ( 16'd0 ),
    .ch5    ( 16'd0 ),
    .p0     ( 16'h0096), // 16324 Hz, 0 Hz 
    .p1     ( 16'h0098), // 15915 Hz, 0 Hz 
    .p2     ( 16'h0), 
    .p3     ( 16'h0), 
    .p4     ( 16'h0), 
    .p5     ( 16'h0), 
    .g0     ( 8'h20 ), // fm
    .g1     ( 8'h3C ), // pcm
    .g2     ( 8'h00 ), 
    .g3     ( 8'h00 ), 
    .g4     ( 8'h00 ), 
    .g5     ( 8'h00 ), 
    .mixed({ snd_left, snd_right}),
    .peak ( game_led ),
    .vu   ( snd_vu   )
);
`else
assign { snd_left, snd_right}=0;
assign snd_vu   = 0;
assign game_led = 0;
wire ncs;
jtframe_frac_cen #(.WC(17)) u_cen192(
    .clk    ( clk       ),
    .n      ( 149 ),
    .m      ( 39049 ),
    .cen    ( {  ncs,sample }  ), // sample is always 192 kHz
    .cenb   (                  )
);
`endif
endmodule
