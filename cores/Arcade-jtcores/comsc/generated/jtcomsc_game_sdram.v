// jtcomsc_game_sdram.v is automatically generated by JTFRAME
// Do not modify it
// Do not add it to git

`ifndef JTFRAME_COLORW
`define JTFRAME_COLORW 4
`endif

`ifndef JTFRAME_BUTTONS
`define JTFRAME_BUTTONS 2
`endif

module jtcomsc_game_sdram(
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


parameter GAME = `JTCONTRA_PCB;
parameter CONTRA = 0;
parameter SND_OFFSET = `SND_START >>1;
parameter GFX1_OFFSET = `GFX1_START>>1;
parameter GFX2_OFFSET = `GFX2_START>>1;
parameter PCM_OFFSET = `PCM_START >>1;

`ifndef JTFRAME_IOCTL_RD
wire ioctl_ram = 0;
`endif
// Audio channels 
wire signed [15:0] fm;
wire signed [ 8:0] pcm;
wire [ 7:0] psga;
wire psga_rcen;
wire [ 7:0] psgb;
wire psgb_rcen;
wire [ 7:0] psgc;
wire psgc_rcen;
wire mute;
// Additional ports

// BRAM buses
// SDRAM buses

wire [18:1] gfx1_addr;
wire [15:0] gfx1_data;
wire        gfx1_cs, gfx1_ok;
wire [18:1] gfx2_addr;
wire [15:0] gfx2_data;
wire        gfx2_cs, gfx2_ok;
wire [16:0] pcm_addr;
wire [ 7:0] pcm_data;
wire        pcm_cs, pcm_ok;
wire [14:0] snd_addr;
wire [ 7:0] snd_data;
wire        snd_cs, snd_ok;
wire [17:0] main_addr;
wire [ 7:0] main_data;
wire        main_cs, main_ok;
wire        prom_we, header;
wire [21:0] raw_addr, post_addr;
wire [25:0] pre_addr, dwnld_addr, ioctl_addr_noheader;
wire [ 7:0] post_data;
wire [15:0] raw_data;
wire        pass_io;
// Clock enable signals
wire cen3; 
wire cen1p5; 
wire cen_fm; 
wire cen_fm2; 
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
jtcontra_game u_game(
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
    .fm     ( fm      ),.pcm     ( pcm      ),.psga     ( psga      ),
    .psga_rcen( psga_rcen ),
.psgb     ( psgb      ),
    .psgb_rcen( psgb_rcen ),
.psgc     ( psgc      ),
    .psgc_rcen( psgc_rcen ),

    
    .snd_en         ( snd_en        ),
    .cen3    ( cen3    ), 
    .cen1p5    ( cen1p5    ), 
    .cen_fm    ( cen_fm    ), 
    .cen_fm2    ( cen_fm2    ), 

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
    // Memory interface - SDRAM
    .gfx1_addr ( gfx1_addr ),
    .gfx1_cs   ( gfx1_cs   ),
    .gfx1_ok   ( gfx1_ok   ),
    .gfx1_data ( gfx1_data ),
    
    .gfx2_addr ( gfx2_addr ),
    .gfx2_cs   ( gfx2_cs   ),
    .gfx2_ok   ( gfx2_ok   ),
    .gfx2_data ( gfx2_data ),
    
    .pcm_addr ( pcm_addr ),
    .pcm_cs   ( pcm_cs   ),
    .pcm_ok   ( pcm_ok   ),
    .pcm_data ( pcm_data ),
    
    .snd_addr ( snd_addr ),
    .snd_cs   ( snd_cs   ),
    .snd_ok   ( snd_ok   ),
    .snd_data ( snd_data ),
    
    .main_addr ( main_addr ),
    .main_cs   ( main_cs   ),
    .main_ok   ( main_ok   ),
    .main_data ( main_data ),
    
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



jtframe_rom_5slots #(
    // gfx1
    .SLOT0_OFFSET(GFX1_OFFSET[21:0]),
    .SLOT0_AW(18),
    .SLOT0_DW(16), 
    // gfx2
    .SLOT1_OFFSET(GFX2_OFFSET[21:0]),
    .SLOT1_AW(18),
    .SLOT1_DW(16), 
    // pcm
    .SLOT2_OFFSET(PCM_OFFSET[21:0]),
    .SLOT2_AW(17),
    .SLOT2_DW( 8), 
    // snd
    .SLOT3_OFFSET(SND_OFFSET[21:0]),
    .SLOT3_AW(15),
    .SLOT3_DW( 8), 
    // main
    .SLOT4_AW(18),
    .SLOT4_DW( 8)
`ifdef JTFRAME_BA2_LEN
    ,.SLOT0_DOUBLE(1)
    ,.SLOT1_DOUBLE(1)
    ,.SLOT2_DOUBLE(1)
    ,.SLOT3_DOUBLE(1)
    ,.SLOT4_DOUBLE(1)
`endif
) u_bank0(
    .rst         ( rst        ),
    .clk         ( clk        ),
    
    .slot0_addr  ( gfx1_addr  ),
    .slot0_dout  ( gfx1_data  ),
    .slot0_cs    ( gfx1_cs    ),
    .slot0_ok    ( gfx1_ok    ),
    
    .slot1_addr  ( gfx2_addr  ),
    .slot1_dout  ( gfx2_data  ),
    .slot1_cs    ( gfx2_cs    ),
    .slot1_ok    ( gfx2_ok    ),
    
    .slot2_addr  ( pcm_addr  ),
    .slot2_dout  ( pcm_data  ),
    .slot2_cs    ( pcm_cs    ),
    .slot2_ok    ( pcm_ok    ),
    
    .slot3_addr  ( snd_addr  ),
    .slot3_dout  ( snd_data  ),
    .slot3_cs    ( snd_cs    ),
    .slot3_ok    ( snd_ok    ),
    
    .slot4_addr  ( main_addr  ),
    .slot4_dout  ( main_data  ),
    .slot4_cs    ( main_cs    ),
    .slot4_ok    ( main_ok    ),
    
    // SDRAM controller interface
    .sdram_ack   ( ba_ack[0]  ),
    .sdram_rd    ( ba_rd[0]   ),
    .sdram_addr  ( ba0_addr   ),
    .data_dst    ( ba_dst[0]  ),
    .data_rdy    ( ba_rdy[0]  ),
    .data_read   ( data_read  )
);
assign ba_wr[0] = 0;
assign ba0_din  = 0;
assign ba0_dsn  = 3;
assign hold_rst=0;
assign ba1_addr = 0;
assign ba_rd[1] = 0;
assign ba_wr[1] = 0;
assign ba1_dsn  = 3;
assign ba1_din  = 0;
assign ba2_addr = 0;
assign ba_rd[2] = 0;
assign ba_wr[2] = 0;
assign ba2_dsn  = 3;
assign ba2_din  = 0;
assign ba3_addr = 0;
assign ba_rd[3] = 0;
assign ba_wr[3] = 0;
assign ba3_dsn  = 3;
assign ba3_din  = 0;



// Clock enable generation
// 3000000 = 24000000*1/8 Hz from clk24
`ifdef VERILATOR_KEEP_CEN /* verilator tracing_on */ `else /* verilator tracing_off */ `endif
jtframe_gated_cen #(.W(2),.NUM(1),.DEN(8),.MFREQ(24000)) u_cen0_clk24(
    .rst    ( rst          ),
    .clk    ( clk24 ),
    .busy   ( (main_cs & ~main_ok) | (snd_cs & ~snd_ok)    ),
    .cen    ( { cen1p5, cen3 } ),
    .fave   (              ),
    .fworst (              )
); /* verilator tracing_off */

// 3579544 = 24000000*9721/65177 Hz from clk24
`ifdef VERILATOR_KEEP_CEN /* verilator tracing_on */ `else /* verilator tracing_off */ `endif
jtframe_gated_cen #(.W(2),.NUM(9721),.DEN(65177),.MFREQ(24000)) u_cen1_clk24(
    .rst    ( rst          ),
    .clk    ( clk24 ),
    .busy   ( (main_cs & ~main_ok) | (snd_cs & ~snd_ok)    ),
    .cen    ( { cen_fm2, cen_fm } ),
    .fave   (              ),
    .fworst (              )
); /* verilator tracing_off */

`ifndef NOSOUND/* verilator tracing_on */
assign mute=0;
jtframe_rcmix #(
    .W0(16),
    .W1(9),
    .W2(8),
    .W3(8),
    .W4(8),
    .FIR1("fir_192k_4k.hex"),
    .STEREO0( 0),
    .STEREO1( 0),
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
    .FRACW( 9), .FRACN(1), .FRACM(250)
) u_rcmix(
    .rst    ( rst       ),
    .clk    ( clk       ),
    .mute   ( mute      ),
    .sample ( sample    ),
    .ch_en  ( snd_en    ),
    .gpole  ( 8'h86 ),  // 19894 Hz 
    .ch0    ( fm ),
    .ch1    ( pcm ),
    .ch2    ( psga ),
    .ch3    ( psgb ),
    .ch4    ( psgc ),
    .ch5    ( 16'd0 ),
    .p0     ( 16'h00D4), // 5811 Hz, 0 Hz 
    .p1     ( 16'h00), // 0 Hz, 0 Hz 
    .p2     ( psga_rcen?16'h00BC : 16'h0), // 9494 Hz, 0 Hz 
    .p3     ( psgb_rcen?16'h00BC : 16'h0), // 9494 Hz, 0 Hz 
    .p4     ( psgc_rcen?16'h00BC : 16'h0), // 9494 Hz, 0 Hz 
    .p5     ( 16'h0), 
    .g0     ( 8'h6A ), // fm
    .g1     ( 8'hD0 ), // pcm
    .g2     ( 8'h5E ), // psga
    .g3     ( 8'h5E ), // psgb
    .g4     ( 8'h5E ), // psgc
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
jtframe_frac_cen #(.WC(9)) u_cen192(
    .clk    ( clk       ),
    .n      ( 1 ),
    .m      ( 250 ),
    .cen    ( {  ncs,sample }  ), // sample is always 192 kHz
    .cenb   (                  )
);
`endif
endmodule
