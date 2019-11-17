/*

Image Utils

Obv. this is just dumb copied from FP utils.

Testing

color[
    (((('sd0)*((((((8'd0)+(((IS)>>((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1))))
                         +(((IS)>>(((((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1))))
                         +(((IS)>>((((((((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1))))
                         +(((IS)>>(((((((((((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1))))
                         +(((IS)>>((((((((((((((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1)))))
                         +(((IS)>>((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1))))
                         +(((IS)>>(((((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1))))
                         +(((((IS)>>((((((((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1)))==('sd0))?('sd0):((((IS)>>((((((((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1)))-('sd1))):((('sd0)*((((((8'd0)
                         +(((IS)>>((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1))))+(((IS)>>(((((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1))))
                         +(((IS)>>((((((((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1))))
                         +(((IS)>>(((((((((((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1))))
                         +(((IS)>>((((((((((((((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1)))))
                         +(((IS)>>((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1))))
                         +(((IS)>>(((((((((((((((((((((((((4'd0)+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd13))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd4))-('sd1))+('sd1))+(4'd6))-('sd1))+('sd1)))&((('sd1)<<(4'd6))-('sd1)))]
*/

`timescale 1ns / 100ps

`include "../../utils/sim/sim.v"

`include "../../image/rtl/image_defs.v"

// Error line number  offset 174?

module image_background_instance #(
        parameter IS = `IS_DEFAULT
    )(
        input [1:0] operation
    );

    parameter Output=`OutputDebug;

    // create the realtime_ns counter
    `Realtime

    // create the 10MHz clock
    `Clock10MHz

    task i_init;
        begin
        end
    endtask

    task  i_clock;
        begin
            #2
            @( posedge clock );
            // `Info( "    Clock");
            #2
            ;
        end
    endtask

    reg  reset;
    task  i_reset;
        begin
            reset = 1;
            i_clock;
            `Info( "    Reset");
            reset = 0;
            i_clock;
        end
    endtask

    task test_init;
        begin
            i_init;
            i_reset;

            in_i = 0;
            out_i = 0;
        end
    endtask

    //
    // Spec Details
    //

    localparam ImplementAccessPort = 1;
    localparam ImageDataWidth =  `I_w( IS );

    localparam Width = `IS_WIDTH( IS );
    localparam Height = `IS_HEIGHT( IS );

    localparam PixelCount = `IS_PIXEL_COUNT( IS );

    localparam WidthWidth =  `IS_WIDTH_WIDTH( IS );
    localparam HeightWidth = `IS_HEIGHT_WIDTH( IS );
    localparam DataWidth =   `IS_DATA_WIDTH( IS );

    localparam [7:0] C0Width =     `IS_C0_WIDTH( IS );
    localparam [7:0] C1Width =     `IS_C1_WIDTH( IS );
    localparam [7:0] C2Width =     `IS_C2_WIDTH( IS );
    localparam [7:0] AlphaWidth =  `IS_ALPHA_WIDTH( IS );
    localparam [7:0] ZWidth =      `IS_Z_WIDTH( IS );

    localparam C0Max    = ( 1 << C0Width ) - 1;
    localparam C1Max    = ( 1 << C1Width ) - 1;
    localparam C2Max    = ( 1 << C2Width ) - 1;
    localparam AlphaMax = ( 1 << AlphaWidth ) - 1;
    localparam ZMax     = ( 1 << ZWidth ) - 1;

    //
    // Image Background
    //

    wire [ImageDataWidth-1:0 ] image_background2buffer;
    reg                    background_out_request_external;

    wire background_out_sending;

    reg [DataWidth-1:0]   color;

    image_background #(
            .IS( IS )
    ) ibackground (
            .clock( clock ),
            .reset( reset ),

            .operation( operation ),
            .color( color ),

            .out_request_external( background_out_request_external ),

            .image_out( image_background2buffer ),

            .out_sending( background_out_sending )
        );

    // All the buffer out signals (set up to monitor all)
    wire                 background_out_start;
    wire                 background_out_stop;
    wire [DataWidth-1:0] background_out_data;
    wire                 background_out_valid;
    wire                 background_out_error;
    wire                 background_out_ready;
    wire                 background_out_request;
    wire                 background_out_cancel;

    assign background_out_start = `I_Start( IS, image_background2buffer );
    assign background_out_stop = `I_Stop( IS, image_background2buffer );
    assign background_out_data = `I_Data( IS, image_background2buffer );
    assign background_out_error = `I_Error( IS, image_background2buffer );
    assign background_out_valid = `I_Valid( IS, image_background2buffer );
    assign background_out_request = `I_Request( IS, image_background2buffer );
    assign background_out_cancel = `I_Cancel( IS, image_background2buffer );
    assign background_out_ready = `I_Ready( IS, image_background2buffer );

    //
    // ImageBuffer
    //

    reg  buffer_in_request_external;
    reg  buffer_out_request_external;

    wire [ImageDataWidth-1:0 ] buffer_image_out;

    wire in_receiving;
    wire out_sending;

    reg  [WidthWidth-1:0]  buffer_port_out_x;
    reg  [HeightWidth-1:0] buffer_port_out_y;
    wire [DataWidth-1:0]   buffer_port_out_data;

    image_buffer #(
            .IS( IS ),
            .ImplementAccessPort( ImplementAccessPort )
    ) ibuffer (
            .clock( clock ),
            .reset( reset ),

            .in_request_external( buffer_in_request_external ),
            .out_request_external( buffer_out_request_external ),

            .image_in( image_background2buffer ),
            .image_out( buffer_image_out ),

            .in_receiving( in_receiving ),
            .out_sending( out_sending ),

            .buffer_out_x( buffer_port_out_x ),
            .buffer_out_y( buffer_port_out_y ),
            .buffer_out_data( buffer_port_out_data )
        );

    //
    // Signals
    //

    // All the out signals
    wire                 buffer_out_start;
    wire                 buffer_out_stop;
    wire [DataWidth-1:0] buffer_out_data;
    wire                 buffer_out_valid;
    wire                 buffer_out_error;
    reg                  buffer_out_ready;
    reg                  buffer_out_request;
    reg                  buffer_out_cancel;

    assign buffer_out_start = `I_Start( IS, buffer_image_out );
    assign buffer_out_stop = `I_Stop( IS, buffer_image_out );
    assign buffer_out_data = `I_Data( IS, buffer_image_out );
    assign buffer_out_error = `I_Error( IS, buffer_image_out );
    assign buffer_out_valid = `I_Valid( IS, buffer_image_out );

    assign `I_Request( IS, buffer_image_out ) = buffer_out_request;
    assign `I_Cancel( IS, buffer_image_out ) = buffer_out_cancel;
    assign `I_Ready( IS, buffer_image_out ) = buffer_out_ready;

    //
    // Tests
    //

    task test_initial_state(  inout integer AssertErrorCount, inout integer AssertTestCount );
        begin
            `InfoDo $display( "    Test Initial State" );

            `InfoDo $display( "        IS %x", IS );
            `InfoDo $display( "            IS.X      %d",  `IS_X( IS ) );
            `InfoDo $display( "            IS.Y      %d",  `IS_Y( IS ) );
            `InfoDo $display( "            IS.Width  %d",  `IS_WIDTH( IS ) );
            `InfoDo $display( "            IS.Height %d", `IS_HEIGHT( IS ) );

            `InfoDo $display( "        IS_w %d", `IS_w );
            `InfoDo $display( "        I_w %d", `I_w( IS ) );

            `Assert( !background_out_sending, "Not Sending" );

            buffer_out_request = 0;
            buffer_out_cancel = 0;
            buffer_out_ready = 0;

            background_out_request_external <= 0;
            buffer_out_request_external <= 0;
            buffer_in_request_external <= 0;
        end
    endtask

    integer in_i;
    integer out_i;
    integer out_i_check;
    integer count;
    integer count_limit;

    reg [DataWidth-1:0] data_check;

    task test_background( inout integer AssertErrorCount, inout integer AssertTestCount );
        begin

            `InfoDo $display( "    Test Background" );

            `Assert( !background_out_request, "No Out Request" );
            `Assert( !background_out_cancel, "No Out Cancel" );
            `Assert( !background_out_ready, "No Out Ready" );

            // pull a frame
            buffer_in_request_external = 1;

            i_clock;

            buffer_in_request_external = 0;

            `Assert( background_out_request, "Buffer Request" );
            `Assert( background_out_ready, "Buffer Ready" );

            out_i = 0;

            count_limit = PixelCount + 10;
            count = 0;

            // err - 125
            `I_C0( IS, color ) = 1'H1;
            `I_C1( IS, color ) = 1'H1;
            `I_C2( IS, color ) = 1'H1;

            while ( ( out_i < PixelCount ) && ( count < count_limit ) ) begin

                if ( background_out_ready && background_out_valid ) begin
                    if ( out_i == 0 ) begin
                        `Assert( background_out_start, "Start" );
                    end
                    if ( out_i == PixelCount - 1  ) begin
                        `Assert( background_out_stop, "Stop" );
                    end
                    out_i = out_i + 1;
                    data_check = `I_Data( IS, background_out_data );
                    if ( operation == 0 ) begin
                        `AssertEqual( color, data_check, "Xfer");
                    end
                end

                count = count + 1;
                i_clock;

            end

            `Assert( count < count_limit, "Count Limit" );
            `AssertEqual( out_i, PixelCount, "Out Count" );

        end
    endtask

    //
    // Buffer to Console
    //

    integer out_frame_x;
    integer out_frame_y;
    integer out_frame_pixel_r;
    integer out_frame_pixel_g;
    integer out_frame_pixel_b;
    integer out_frame_pixel_total;

    localparam out_frame_pixel_max_total = ( (2**C0Width) + (2**C1Width) + (2**C2Width) - 3 );

    function [2:0] out_brightness( input reg[ DataWidth-1:0 ] pixel ); begin

            out_frame_pixel_r = ( C0Width ) ? `I_C0( IS, pixel ) : 0;
            out_frame_pixel_g = ( C1Width ) ? `I_C1( IS, pixel ) : 0;
            out_frame_pixel_b = ( C2Width ) ? `I_C2( IS, pixel ) : 0;
            // out_frame_pixel_r = 0;
            // out_frame_pixel_g = 0;
            // out_frame_pixel_b = 0;

            out_frame_pixel_total = out_frame_pixel_r + out_frame_pixel_g + out_frame_pixel_b;

            // lcdtb_brightness = ( out_frame_pixel_total == 0 ) ? 0 : 1;

            out_brightness = ( out_frame_pixel_total == 0 ) ? 0 :
                                  ( ( out_frame_pixel_total <= ( out_frame_pixel_max_total / 4 ) ? 1 :
                                       ( out_frame_pixel_total <= ( out_frame_pixel_max_total / 2 ) ? 2 : 3 ) ) );

            // $display( "        Brightness %x -> %x %x %x -> %x", pixel, out_frame_pixel_r, out_frame_pixel_g, out_frame_pixel_b, lcdtb_brightness );

        end
    endfunction

    function [2:0] out_r( input reg[ DataWidth-1:0 ] pixel ); begin
            out_r = ( C0Width == 0 ) ? 0 : 
                            ( `I_C0( IS, pixel ) == 0 ) ? 0 :
                                  ( ( `I_C0( IS, pixel ) <= ( C0Max / 4 ) ? 1 :
                                       ( `I_C0( IS, pixel ) <= ( C0Max / 2 ) ? 2 : 3 ) ) );
        end                                 
    endfunction

    function [2:0] out_g( input reg[ DataWidth-1:0 ] pixel ); begin
            out_g = ( C1Width == 0 ) ? 0 : 
                            ( `I_C1( IS, pixel ) == 0 ) ? 0 :
                                  ( ( `I_C1( IS, pixel ) <= ( C1Max / 4 ) ? 1 :
                                       ( `I_C1( IS, pixel ) <= ( C1Max / 2 ) ? 2 : 3 ) ) );
        end
    endfunction

    function [2:0] out_b( input reg[ DataWidth-1:0 ] pixel ); begin
            out_b = ( C2Width == 0 ) ? 0 : 
                            ( `I_C2( IS, pixel ) == 0 ) ? 0 :
                                  ( ( `I_C2( IS, pixel ) <= ( C2Max / 4 ) ? 1 :
                                       ( `I_C2( IS, pixel ) <= ( C2Max / 2 ) ? 2 : 3 ) ) );
        end
    endfunction

    integer r;
    integer b;
    integer g;

    task out_frame( input reg full );
        begin

            // Top of the frame
            $write( "        /" );
            for ( out_frame_x = 0; out_frame_x < Width; out_frame_x = out_frame_x + 1 ) begin
                $write( "---" );
                if ( !full && ( out_frame_x == Width / 8 ) ) begin
                    $write( "..." );
                    out_frame_x = 15 * Width / 16;
                end
            end
            $write( "\\\n" );

            for ( out_frame_y = 0; out_frame_y < Height; out_frame_y = out_frame_y + 1 ) begin
                $write( "        |" );
                // $display( "        %3d", out_frame_y );
                for ( out_frame_x = 0; out_frame_x < Width; out_frame_x = out_frame_x + 1 ) begin
                    buffer_port_out_x = out_frame_x;
                    buffer_port_out_y = out_frame_y;

                    #1

                    r = out_r( buffer_port_out_data );
                    g = out_g( buffer_port_out_data );
                    b = out_b( buffer_port_out_data );

                    // $display( "            %3d    %3x", out_frame_x, out_frame_out_data );
                    $write( "%s", ( r == 0 ) ? " " : ( ( r == 1 ) ? "." : ( ( r == 2 ) ? "r" : "R" ) ) );
                    $write( "%s", ( g == 0 ) ? " " : ( ( g == 1 ) ? "." : ( ( g == 2 ) ? "g" : "G" ) ) );
                    $write( "%s", ( b == 0 ) ? " " : ( ( b == 1 ) ? "." : ( ( b == 2 ) ? "b" : "B" ) ) );

                    /// $write( "***" );

                    if ( !full && ( out_frame_x == Width / 8 ) ) begin
                        $write( "..." );
                        out_frame_x = 15 * Width / 16;
                    end
                end
                $write( "|\n" );
                if ( !full && ( out_frame_y == Height / 8 ) ) begin
                    $write( "        ...\n" );
                    out_frame_y = 15 * Height / 16;
                end
            end

            // Bottom of the frame
            $write( "        \\" );
            for ( out_frame_x = 0; out_frame_x < Width; out_frame_x = out_frame_x + 1 ) begin
                $write( "---" );
                if ( !full && ( out_frame_x == Width / 8 ) ) begin
                    $write( "..." );
                    out_frame_x = 15 * Width / 16;
                end
            end
            $write( "/\n" );

        end
    endtask
endmodule

module image_background_tb();

    parameter Output=`OutputDebug;
    // parameter Output=`OutputInfo;
    // parameter Output=`OutputError;

    initial begin
      $dumpfile("image_background_tb.vcd");
      $dumpvars( 0, image_background_tb );
    end

    `AssertSetup

    // create the realtime_ns counter
    `Realtime

    // create the 10MHz clock
    `Clock10MHz

    task i_init;
        begin
        end
    endtask

    task  i_clock;
        begin
            #2
            @( posedge clock );
            // `Info( "    Clock");
            #2
            ;
        end
    endtask

    reg  reset;

    task  i_reset;
        begin
            reset = 1;
            i_clock;
            `Info( "    Reset");
            reset = 0;
            i_clock;
        end
    endtask

    //
    // Spec Details
    //

    localparam [`IS_w-1:0] IS = `IS( 0, 0, 8, 8, 0, 1, `IS_FORMAT_RGB, 8, 8, 8, 0, 0 );

    localparam ImageDataWidth =  `I_w( IS );

    localparam Width = `IS_WIDTH( IS );
    localparam Height = `IS_HEIGHT( IS );

    localparam PixelCount = `IS_PIXEL_COUNT( IS );

    localparam WidthWidth =  `IS_WIDTH_WIDTH( IS );
    localparam HeightWidth = `IS_HEIGHT_WIDTH( IS );
    localparam DataWidth =   `IS_DATA_WIDTH( IS );

    localparam C0Width =     `IS_C0_WIDTH( IS );
    localparam C1Width =     `IS_C1_WIDTH( IS );
    localparam C2Width =     `IS_C2_WIDTH( IS );
    localparam AlphaWidth =  `IS_ALPHA_WIDTH( IS );
    localparam ZWidth =      `IS_Z_WIDTH( IS );

    //
    // Image Background
    //

    wire [ImageDataWidth-1:0 ] image;
    reg                        background_out_request_external;
    reg                        background_out_ready;
    reg                        background_out_request;
    reg                        background_out_cancel;

    wire background_out_sending;

    reg [DataWidth-1:0]   color;
    //reg [23:0]   color;

    image_background #(
            .IS( IS )
    ) ibackground (
            .clock( clock ),
            .reset( reset ),

            .operation( 2'H0 ),
            .color( color ),

            .out_request_external( background_out_request_external ),

            .image_out( image ),

            .out_sending( background_out_sending )
        );

    task test_init;
        begin
            background_out_request = 0;
            background_out_ready = 0;
            background_out_cancel = 0;
        end
    endtask

    task test_idle;
        begin
            `Info( "        Checking Idle" );
            `Assert( !background_out_valid, "Idle - no Valid" );
            `Assert( !background_out_sending, "Idle - no Sending" );
        end
    endtask

    integer count;
    integer count_limit;
    integer out_i;
    integer data_check;

    task test_request( input reg pauses );
        begin
            `InfoDo $display( "        Checking Request (Pauses %d)", pauses );
            // pull a frame
            background_out_request_external = 1;

            i_clock;

            background_out_request_external = 1;

            out_i = 0;

            count_limit = PixelCount + 10;
            count = 0;

            // err - 125
            `I_C0( IS, color ) = 1'H1;
            `I_C1( IS, color ) = 1'H1;
            `I_C2( IS, color ) = 1'H1;

            background_out_ready = 1;

            while ( ( out_i < PixelCount ) && ( count < count_limit ) ) begin

                if ( background_out_ready && background_out_valid ) begin
                    if ( out_i == 0 ) begin
                        `Assert( background_out_start, "Start" );
                    end
                    if ( out_i == PixelCount - 1  ) begin
                        `Assert( background_out_stop, "Stop" );
                    end
                    out_i = out_i + 1;
                    data_check = `I_Data( IS, background_out_data );
                    `AssertEqual( color, data_check, "Xfer");
                end

                if ( pauses ) begin

                    background_out_ready = 0;

                    i_clock;
                    i_clock;
                    i_clock;
                    i_clock;

                    background_out_ready = 1;

                end

                count = count + 1;
                i_clock;

            end

            background_out_ready = 0;

            `Assert( !background_out_valid, "No more Valid" );

            `Assert( count < count_limit, "Count Limit" );
            `AssertEqual( out_i, PixelCount, "Out Count" );
        end
    endtask

    // All the buffer out signals (set up to monitor all)
    wire                 background_out_start;
    wire                 background_out_stop;
    wire [DataWidth-1:0] background_out_data;
    wire                 background_out_valid;
    wire                 background_out_error;

    assign background_out_start = `I_Start( IS, image );
    assign background_out_stop = `I_Stop( IS, image );
    assign background_out_data = `I_Data( IS, image );
    assign background_out_error = `I_Error( IS, image );
    assign background_out_valid = `I_Valid( IS, image );
    assign `I_Request( IS, image ) = background_out_request;
    assign `I_Cancel( IS, image ) = background_out_cancel;
    assign `I_Ready( IS, image ) = background_out_ready;

    // leaving as an integer doesn't seem to work
    localparam [`IS_w-1:0] IS_1 = `IS( 0, 0, 32, 32, 0, 1, `IS_FORMAT_RGB, 8, 8, 8, 0, 0 );
    localparam [`IS_w-1:0] IS_2 = `IS( 0, 0, 127, 95, 0, 1, `IS_FORMAT_RGB, 8, 8, 8, 0, 0 );

    image_background_instance #( .IS(IS_1) ) ibi1( 2'H0 );
    image_background_instance #( .IS(IS_1) ) ibi2( 2'H1 );

    initial begin
        $display( "Image Background Tests %s", `__FILE__ );

        `Info( "    Data Check" );


        i_reset;

        test_init;
        ibi1.test_init;
        ibi2.test_init;

        i_clock;
        i_clock;
        i_clock;
        i_clock;

        test_idle;

        test_request( 0 );

        i_clock;
        i_clock;
        i_clock;
        i_clock;

        test_request( 1 );

        i_clock;
        i_clock;
        i_clock;
        i_clock;

        `Info( "    Instanced Checks" );

        `Info( "    Spec Check" );
        `InfoDo $display( "        IS %x", IS_1 );
        `InfoDo $display( "            IS.X      %d",  `IS_X( IS_1 ) );
        `InfoDo $display( "            IS.Y      %d",  `IS_Y( IS_1 ) );
        `InfoDo $display( "            IS.Width  %d",  `IS_WIDTH( IS_1 ) );
        `InfoDo $display( "            IS.Height %d", `IS_HEIGHT( IS_1 ) );

        `Info( "    Checking IBI1" );

        ibi1.test_initial_state( AssertErrorCount, AssertTestCount);
        ibi2.test_initial_state( AssertErrorCount, AssertTestCount);

        ibi1.i_clock;
        ibi1.i_clock;
        ibi1.i_clock;
        ibi1.i_clock;
        ibi2.i_clock;
        ibi2.i_clock;
        ibi2.i_clock;
        ibi2.i_clock;

        ibi1.out_frame( 1 );

        ibi1.i_clock;
        ibi1.i_clock;
        ibi1.i_clock;
        ibi1.i_clock;

        ibi1.test_background( AssertErrorCount, AssertTestCount );

        ibi1.i_clock;
        ibi1.i_clock;
        ibi1.i_clock;
        ibi1.i_clock;

        ibi1.out_frame( 1 );

        `Info( "    Checking IBI2" );

        ibi2.out_frame( 1 );

        ibi2.i_clock;
        ibi2.i_clock;
        ibi2.i_clock;
        ibi2.i_clock;

        ibi2.i_clock;
        ibi2.i_clock;
        ibi2.i_clock;
        ibi2.i_clock;

        ibi2.test_background( AssertErrorCount, AssertTestCount );

        ibi2.i_clock;
        ibi2.i_clock;
        ibi2.i_clock;
        ibi2.i_clock;

        ibi2.out_frame( 1 );

        ibi1.i_clock;
        ibi1.i_clock;
        ibi1.i_clock;
        ibi1.i_clock;
        ibi1.i_clock;
        ibi1.i_clock;
        ibi1.i_clock;
        ibi1.i_clock;
        `AssertSummary

        $finish;
    end

endmodule

