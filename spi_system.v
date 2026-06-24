module spi_system #(
    parameter mode = 0
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire tx_en,
    input wire rx_en,

    input wire [1:0] slave_sel,

    input wire [7:0] address,
    input wire [7:0] data_out,

    output wire [7:0] data_in,
    output wire rx_valid
);

    // Internal wires
    wire sclk;
    wire mosi;
    wire miso;

    wire cs_active;

    wire [3:0] cs_n;

    wire miso0;
    wire miso1;
    wire miso2;
    wire miso3;

    assign cs_n[0] = ~(cs_active && (slave_sel == 2'b00));
    assign cs_n[1] = ~(cs_active && (slave_sel == 2'b01));
    assign cs_n[2] = ~(cs_active && (slave_sel == 2'b10));
    assign cs_n[3] = ~(cs_active && (slave_sel == 2'b11));

    spi_master #(
        .mode(mode)
    ) master (

        .clk(clk),
        .en(en),
        .rst(rst),

        .tx_en(tx_en),
        .rx_en(rx_en),

        .miso(miso),

        .address(address),
        .data_out(data_out),

        .sclk(sclk),
        .cs_active(cs_active),
        .mosi(mosi),

        .data_in(data_in),
        .rx_valid(rx_valid)
    );

    spi_slave #(
        .mode(mode)
    ) slave0 (

        .rst(rst),
        .cs_n(cs_n[0]),

        .sclk(sclk),
        .mosi(mosi),

        .miso(miso0)
    );

    spi_slave #(
        .mode(mode)
    ) slave1 (

        .rst(rst),
        .cs_n(cs_n[1]),

        .sclk(sclk),
        .mosi(mosi),

        .miso(miso1)
    );

    spi_slave #(
        .mode(mode)
    ) slave2 (

        .rst(rst),
        .cs_n(cs_n[2]),

        .sclk(sclk),
        .mosi(mosi),

        .miso(miso2)
    );

    spi_slave #(
        .mode(mode)
    ) slave3 (

        .rst(rst),
        .cs_n(cs_n[3]),

        .sclk(sclk),
        .mosi(mosi),

        .miso(miso3)
    );
   

    assign miso = (!cs_n[0]) ? miso0 :
              (!cs_n[1]) ? miso1 :
              (!cs_n[2]) ? miso2 :
              (!cs_n[3]) ? miso3 :
              1'bz;

endmodule
