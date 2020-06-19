// ics32_tb.v
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

`default_nettype none

module ics32_tb(
`ifndef EXTERNAL_CLOCKS
    input clk_12m,
`else
    input clk_1x,
    input clk_2x,
`endif

    output [3:0] vga_r,
    output [3:0] vga_g,
    output [3:0] vga_b,

    output vga_hsync,
    output vga_vsync,

    output vga_clk,
    output vga_de,

    output led_r,
    output led_b,

    input btn_1,
    input btn_2,
    input btn_3,

    // to be extended with i/o for DSPI/QSPI
    // ...

`ifndef FLASH_BLACKBOX
    output flash_sck,
    output flash_csn,
    output [3:0] flash_out,
    output [3:0] flash_oe,
    input [3:0] flash_in
`endif
);
    ics32 #(
        .ENABLE_WIDESCREEN(1),
        .FORCE_FAST_CPU(0),
        .RESET_DURATION(4),

        // For simulator use, there's no point enabling this unless the bootloader itself is being tested
        // The sim performs the bootloaders job of copying the program from flash to CPU RAM
        // Enabling this just delays the program start
        .ENABLE_BOOTLOADER(1)
    ) ics32 (
`ifndef EXTERNAL_CLOCKS
        .clk_12m(clk_12m),
`else
        .clk_1x(clk_1x),
        .clk_2x(clk_2x),
`endif

        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b),

        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync),

        .vga_clk(vga_clk),
        .vga_de(vga_de),

        .btn_1(btn_1),
        .btn_2(btn_2),
        .btn_3(btn_3),

        .led_r(led_r),
        .led_b(led_b),

        .flash_sck(flash_sck),
        .flash_csn(flash_csn),
        .flash_oe(flash_oe),
        .flash_out(flash_out),
        .flash_in(flash_in)
    );

`ifdef FLASH_BLACKBOX

    wire flash_sck;
    wire flash_csn;
    wire flash_mosi;
    wire flash_miso;

    flash_bb flash(
        .csn(flash_csn),
        .clk(flash_sck),
        .io0(flash_mosi),
        .io1(flash_miso)
    );

`endif

endmodule

`ifdef FLASH_BLACKBOX

(* cxxrtl_blackbox *)
module flash_bb(
    input csn,
    input clk,

    input io0,
    (* cxxrtl_sync *) output io1

    // inout [3:0] io
);

endmodule

`endif

