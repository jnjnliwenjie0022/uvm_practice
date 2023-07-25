VLOG = vcs
SIM = ./simv
VERDI = verdi
UVM_VERBOSITY = UVM_MEDIUM

SRC = -f flist

VLOG_CONF = -sverilog \
			-l build.log \
			+v2k \
			-kdb \
			-lca \
			-full64 \
			-debug_access+all \
			-timescale=1ns/1ps \
			+define+DUMP_FSDB \
			+define+UVM_VERDI_COMPWAVE \
			+incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm.sv \
			-CFLAGS \
			-DVCS \
			+acc +vpi \
			-ntb_opts uvm \
			-Xcheck_p1800_2009=char \
			-cpp g++-4.8 \
			-cc gcc-4.8 \
			-LDFLAGS -Wl,--no-as-needed

SIM_CONF =  -l run.log \
			+fsdb+autoflush\
			+UVM_TESTNAME=my_case4 \
			+UVM_VERDI_TRACE="UVM_AWARE+RAL+HIER+COMPWAVE" \
			+UVM_TR_RECORD \
			+UVM_LOG_RECORD \
			+verbose=1 \
			+ntb_random_seed=244

TMPFILE = simv.* \
	*.log *.vpd *.key *.conf *.rc *.fsdb* *.dat *.h \
    simv* csrc* DVE* INCA* verdi* waves* \
	*.dsn *.shm *.trn *.vcd* *.history \
	.inter.vpd.uvm \
	.restartSimSession.tcl.old \
	*.log \
	vlog 01 02

RM = rm -rf

VERDI_CONF = -sv \
			 -top tb \
			 -nologo

all: comp sim

comp:
	$(VLOG) $(SRC) $(VLOG_CONF)
sim:
	$(SIM) $(SIM_CONF)
verdi:
	$(VERDI) $(SRC) $(VERDI_CONF)
clean:
	$(RM) $(TMPFILE)

