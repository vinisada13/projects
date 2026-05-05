library ieee;
use ieee.numeric_bit.all;

entity fluxoDados is
port(
    clock         : in bit;
    reset         : in bit;
    extendMSB     : in bit_vector (4 downto 0);
    extendLSB     : in bit_vector (4 downto 0);
    reg2Loc       : in bit;
    regWrite      : in bit;
    aluSrc        : in bit;
    alu_control   : in bit_vector (3 downto 0);
    branch        : in bit;
    uncondBranch  : in bit;
    memRead       : in bit;
    memWrite      : in bit;
    memToReg      : in bit;
    opcode        : out bit_vector (10 downto 0)
);
end entity fluxoDados;

architecture a_fluxo of fluxoDados is

   
    -- COMPONENTES 

    component reg is
        generic ( dataSize : natural := 64 );            -- PC: n = 7
        port (
            clock  : in bit;
            reset  : in bit;
            enable : in bit;
            d      : in  bit_vector(dataSize-1 downto 0);
            q      : out bit_vector(dataSize-1 downto 0)
        );
    end component;

    component memoriaInstrucoes is
        generic (
            addressSize : natural := 7;
            dataSize    : natural := 8;
            datFileName : string  := "memInstrPolilegv8.dat"
        );
        port (
            addr : in  bit_vector(addressSize-1 downto 0);
            data : out bit_vector(dataSize-1 downto 0)
        );
    end component;

    component regfile is
        port (
            clock    : in  bit;
            reset    : in  bit;
            regWrite : in  bit;
            rr1      : in  bit_vector(4 downto 0);
            rr2      : in  bit_vector(4 downto 0);
            wr       : in  bit_vector(4 downto 0);
            d        : in  bit_vector(63 downto 0);
            q1       : out bit_vector(63 downto 0);
            q2       : out bit_vector(63 downto 0)
        );
    end component;

    component sign_extend is
        generic (
            dataISize       : natural := 32;
            dataOSize       : natural := 64;
            dataMaxPosition : natural := 5
        );
        port (
            inData  : in  bit_vector(dataISize-1 downto 0);
            inDataStart  : in  bit_vector(dataMaxPosition-1 downto 0);
            inDataEnd  : in  bit_vector(dataMaxPosition-1 downto 0);
            outData : out bit_vector(dataOSize-1 downto 0)
        );
    end component;

    component ula is
        port (
            a           : in  bit_vector(63 downto 0);
            b           : in  bit_vector(63 downto 0);
            s : in  bit_vector(3 downto 0);
            f     : out bit_vector(63 downto 0);
            z        : out bit;
            ov    : out bit
        );
    end component;

    component mux_n is
        generic ( dataSize : natural := 64 );
        port (
            in0  : in  bit_vector(dataSize-1 downto 0);
            in1  : in  bit_vector(dataSize-1 downto 0);
            sel  : in  bit;
            dOut : out bit_vector(dataSize-1 downto 0)
        );
    end component;

    component memoriaDados is
        generic (
            addressSize : natural := 7;
            dataSize    : natural := 8;
            datFileName : string  := "memDadosInicialPolilegv8.dat"
        );
        port (
            clock  : in  bit;
            wr     : in  bit;
            addr   : in  bit_vector(addressSize-1 downto 0);
            data_i : in  bit_vector(dataSize-1 downto 0);
            data_o : out bit_vector(dataSize-1 downto 0)
        );
    end component;

    component adder_n is
        generic ( dataSize : natural := 64 );
        port (
            in0  : in  bit_vector(dataSize-1 downto 0);
            in1  : in  bit_vector(dataSize-1 downto 0);
            sum  : out bit_vector(dataSize-1 downto 0);
            cOut : out bit
        );
    end component;

    component two_left_shifts is
        generic ( dataSize : natural := 64 );
        port (
            input  : in  bit_vector(dataSize-1 downto 0);
            output : out bit_vector(dataSize-1 downto 0)
        );
    end component;

  
    -- SINAIS INTERNOS
    
    signal pc_q7     : bit_vector(6 downto 0);
    signal pc_d7     : bit_vector(6 downto 0);

    signal pc_q64    : bit_vector(63 downto 0);
    signal pc_plus4  : bit_vector(63 downto 0);
    signal pc_branch : bit_vector(63 downto 0);
    signal pc_next   : bit_vector(63 downto 0);

    signal c_dummy   : bit;
    signal c_dummy2   : bit;

    signal b0, b1, b2, b3 : bit_vector(7 downto 0);
    signal instr          : bit_vector(31 downto 0);

    signal rr1_addr  : bit_vector(4 downto 0);
    signal rr2_addr  : bit_vector(4 downto 0);
    signal wr_addr   : bit_vector(4 downto 0);

    -- reg2Loc (5 bits empacotados em 64 bits para usar mux_n)
    signal rr2_a64, rr2_b64, rr2_out64 : bit_vector(63 downto 0);

    signal rf_q1, rf_q2 : bit_vector(63 downto 0);

    signal imm64    : bit_vector(63 downto 0);
    signal imm_sl2  : bit_vector(63 downto 0);

    -- ALU A (para CBZ: usa rf_q2 quando branch=1 e uncondBranch=0)
    signal aluA_sel : bit;
    signal aluA     : bit_vector(63 downto 0);

    signal aluB     : bit_vector(63 downto 0);

    signal aluRes   : bit_vector(63 downto 0);
    signal aluZero  : bit;
    signal aluOvf   : bit;

    -- Data memory é 8 bits; zero-extend para 64 bits no writeback
    signal memData8  : bit_vector(7 downto 0);
    signal memData64 : bit_vector(63 downto 0);

    signal wbData   : bit_vector(63 downto 0);

    signal pcSrc    : bit;

    constant CONST_4 : bit_vector(63 downto 0) := bit_vector(to_unsigned(4, 64));

    function add7(a : bit_vector(6 downto 0); k : natural) return bit_vector is
        variable ua : unsigned(6 downto 0);
    begin
        ua := unsigned(a);
        return bit_vector(ua + to_unsigned(k, 7));
    end function;

begin
   
    -- PC (reg, n = 7)
    
    u_pc: reg
        generic map ( dataSize => 7 )
        port map (
            clock  => clock,
            reset  => reset,
            enable => '1',
            d      => pc_d7,
            q      => pc_q7
        );

    pc_q64 <= (63 downto 7 => '0') & pc_q7;

    --=========================================================
    -- Memória de Instruções (4 bytes -> 32 bits)
    -- (montagem little-endian: mem[PC]=LSB)
    
    u_im0: memoriaInstrucoes
        generic map ( addressSize => 7, dataSize => 8, datFileName => "memInstrPolilegv8.dat" )
        port map ( addr => pc_q7,            data => b0 );

    u_im1: memoriaInstrucoes
        generic map ( addressSize => 7, dataSize => 8, datFileName => "memInstrPolilegv8.dat" )
        port map ( addr => add7(pc_q7, 1), data => b1 );

    u_im2: memoriaInstrucoes
        generic map ( addressSize => 7, dataSize => 8, datFileName => "memInstrPolilegv8.dat" )
        port map ( addr => add7(pc_q7, 2), data => b2 );

    u_im3: memoriaInstrucoes
        generic map ( addressSize => 7, dataSize => 8, datFileName => "memInstrPolilegv8.dat" )
        port map ( addr => add7(pc_q7, 3), data => b3 );

    instr  <= b3 & b2 & b1 & b0;

    -- opcode sempre = 11 MSBs
    opcode <= instr(31 downto 21);

    -- Campos principais (LEGv8 padrão)
    rr1_addr <= instr(9 downto 5);
    wr_addr  <= instr(4 downto 0);

    -- reg2Loc: rr2 = instr(20..16) ou instr(4..0)
    rr2_a64 <= (63 downto 5 => '0') & instr(20 downto 16);
    rr2_b64 <= (63 downto 5 => '0') & instr(4 downto 0);

    u_mux_rr2: mux_n
        generic map ( dataSize => 64 )
        port map (
            in0  => rr2_a64,
            in1  => rr2_b64,
            sel  => reg2Loc,
            dOut => rr2_out64
        );

    rr2_addr <= rr2_out64(4 downto 0);

    --=========================================================
    -- Banco de Registradores
    
    u_rf: regfile
        port map (
            clock    => clock,
            reset    => reset,
            regWrite => regWrite,
            rr1      => rr1_addr,
            rr2      => rr2_addr,
            wr       => wr_addr,
            d        => wbData,
            q1       => rf_q1,
            q2       => rf_q2
        );

    --=========================================================
    -- Sign-Extend e ShiftLeft2
    
    u_sext: sign_extend
        generic map ( dataISize => 32, dataOSize => 64, dataMaxPosition => 5 )
        port map (
            inData  => instr,
            inDataStart  => extendMSB,
            inDataEnd  => extendLSB,
            outData => imm64
        );

    u_sl2: two_left_shifts
        generic map ( dataSize => 64 )
        port map (
            input  => imm64,
            output => imm_sl2
        );

    --=========================================================
    -- Somadores: PC+4 e PCBranch = PC+4 + (imm<<2)
    
    u_add_pc4: adder_n
        generic map ( dataSize => 64 )
        port map (
            in0  => pc_q64,
            in1  => CONST_4,
            sum  => pc_plus4,
            cOut => c_dummy
        );

    u_add_branch: adder_n
        generic map ( dataSize => 64 )
        port map (
            in0  => pc_plus4,
            in1  => imm_sl2,
            sum  => pc_branch,
            cOut => c_dummy2
        );

    --=========================================================
    -- ULA: entrada A (CBZ usa rf_q2), entrada B (q2 vs imm)

    aluA_sel <= branch and (not uncondBranch);

    u_mux_aluA: mux_n
        generic map ( dataSize => 64 )
        port map (
            in0  => rf_q1,
            in1  => rf_q2,
            sel  => aluA_sel,
            dOut => aluA
        );

    u_mux_aluB: mux_n
        generic map ( dataSize => 64 )
        port map (
            in0  => rf_q2,
            in1  => imm64,
            sel  => aluSrc,
            dOut => aluB
        );

    u_alu: ula
        port map (
            a       => aluA,
            b       => aluB,
            s => alu_control,
            f      => aluRes,
            z      => aluZero,
            ov    => aluOvf
        );

    --=========================================================
    -- Memória de Dados (8 bits)
    -- addr = aluRes(6 downto 0) (byte address)
    -- escreve apenas o byte menos significativo de rf_q2
    -- lê 1 byte e zero-extend para 64 bits
   
    u_dmem: memoriaDados
        generic map (
            addressSize => 7,
            dataSize    => 8,
            datFileName => "memDadosInicialPolilegv8.dat"
        )
        port map (
            clock  => clock,
            wr     => memWrite,
            addr   => aluRes(6 downto 0),
            data_i => rf_q2(7 downto 0),
            data_o => memData8
        );

    memData64 <= (63 downto 8 => '0') & memData8;

    --=========================================================
    -- Writeback: ALURes vs MemData64

    u_mux_wb: mux_n
        generic map ( dataSize => 64 )
        port map (
            in0  => aluRes,
            in1  => memData64,
            sel  => memToReg,
            dOut => wbData
        );

    --=========================================================
    -- Lógica de desvio

    pcSrc <= uncondBranch or (branch and aluZero);

    u_mux_pc: mux_n
        generic map ( dataSize => 64 )
        port map (
            in0  => pc_plus4,
            in1  => pc_branch,
            sel  => pcSrc,
            dOut => pc_next
        );

    pc_d7 <= pc_next(6 downto 0);

end architecture;
