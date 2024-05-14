module dumper;
`ifdef DUMP
initial if ($test$plusargs("dump")) $dumpvars(0, tb);
`endif
endmodule
