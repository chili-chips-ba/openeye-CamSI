module DP_BRAM #(
  parameter W = 256,
  parameter D = 64 
)(
//Side-A
  input   logic                 clka,

  input   logic                 ena,
  input   logic[$clog2(D)-1:0]  addra,
  input   logic[(W/8)-1:0]      wea,
  input   logic[W-1:0]          dina,
  output  logic[W-1:0]          douta,

//Side-B
  input   logic                 clkb,

  input   logic                 enb,
  input   logic[$clog2(D)-1:0]  addrb,
  input   logic[(W/8)-1:0]      web,
  input   logic[W-1:0]          dinb,
  output  logic[W-1:0]          doutb
);

//---Storage
logic[W-1:0] mem[D];


//---Port A
for (genvar i=0; i<(W/8); i++) begin: a
  always_ff @(posedge clka)
     if (ena == 1'b1) begin
       if (wea[i] == 1'b1)
          mem[addra][8*i +: 8] <= dina[8*i +: 8];
     end
end

always_ff @(posedge clka) begin
   if (ena == 1'b1) begin
     douta <= mem[addra];
   end
end   

   
//---Port B
for (genvar j=0; j<(W/8); j++) begin: b
  always_ff @(posedge clkb) begin
     if (enb == 1'b1) begin
       if (web[j] == 1'b1)
          mem[addrb][8*j +: 8] <= dinb[8*j +: 8];
     end
  end
end

always_ff @(posedge clkb) begin
   if (enb == 1'b1) begin
      doutb <= mem[addrb];
   end
end
   
endmodule: DP_BRAM
