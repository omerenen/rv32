

`define UPPER_INST_MEM          32'h8009_0000 >> 2
`define LOWER_INST_MEM          32'h8000_0000 >> 2
// `define MEM_DEPTH               ((`UPPER_INST_MEM - `LOWER_INST_MEM) / 4) // Bellek boyutu hesaplaması (her komut 4 byte)


`define UPPER_DATA_MEM          32'h8002_0000 >> 2
`define LOWER_DATA_MEM          32'h8001_0000 >> 2

`define OPCODE_R_TYPE           7'b0110011

`define OPCODE_I_TYPE_IMM       7'b0010011 
`define OPCODE_I_TYPE_LOAD      7'b0000011 
`define OPCODE_I_TYPE_JALR      7'b1100111 

`define OPCODE_U_TYPE_AUIPC     7'b0010111 
`define OPCODE_U_TYPE_LUI       7'b0110111 

`define OPCODE_S_TYPE           7'b0100011 

`define OPCODE_B_TYPE           7'b1100011 

`define OPCODE_J_TYPE_JAL       7'b1101111 


`define ADD                    4'b0000
`define SUB                    4'b0001
`define AND                    4'b0010
`define OR                     4'b0011
`define XOR                    4'b0100
`define SLL                    4'b0101
`define SRL                    4'b0110
`define SRA                    4'b0111
`define LT                     4'b1000
`define EQ                     4'b1001
`define NEQ                    4'b1010
`define GTE                    4'b1011
`define LTU                    4'b1100
`define GTEU                   4'b1101