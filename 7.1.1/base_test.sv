`ifndef BASE_TEST__SV
`define BASE_TEST__SV

class base_test extends uvm_test;
    //{{{
    my_env         env;
    //my_env         env0;
    //my_env         env1;
    my_vsqr        v_sqr;   
    //}}}
   
    function new(string name = "base_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction
    
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);
    //virtual function void final_phase(uvm_phase phase);
    `uvm_component_utils(base_test)
    UVM_FILE info_log;
    //UVM_FILE warning_log;
    //UVM_FILE error_log;
    //UVM_FILE fatal_log;
    virtual function void connect_phase(uvm_phase phase);
        //{{{
        v_sqr.p_my_sqr = env.i_agt.sqr;
        v_sqr.p_bus_sqr = env.bus_agt.sqr;
        //}}}
        info_log = $fopen("info.log", "w");
        //warning_log = $fopen("warning.log", "w");
        //error_log = $fopen("error.log", "w");
        //fatal_log = $fopen("fatal.log", "w");
        //v_sqr.set_report_severity_file(UVM_INFO,    info_log);
        //v_sqr.set_report_severity_action(UVM_INFO, UVM_DISPLAY | UVM_LOG);
        //env0.i_agt.sqr.set_report_severity_file(UVM_INFO,    info_log);
        //env0.i_agt.sqr.set_report_severity_action(UVM_INFO, UVM_DISPLAY | UVM_LOG);
        //env.set_report_severity_file(UVM_INFO,    info_log);
        //env.set_report_severity_action(UVM_INFO, UVM_DISPLAY | UVM_LOG);
        //env.i_agt.sqr.set_report_severity_file(UVM_INFO,    info_log);
        //env.i_agt.mon.set_report_severity_file(UVM_INFO,    info_log);
        //env.i_agt.drv.set_report_severity_file(UVM_WARNING, warning_log);
        //env.i_agt.drv.set_report_severity_file(UVM_ERROR,   error_log);
        //env.i_agt.drv.set_report_severity_file(UVM_FATAL,   fatal_log);
        //env.i_agt.sqr.set_report_severity_action(UVM_INFO, UVM_DISPLAY | UVM_LOG);
        //env.i_agt.mon.set_report_severity_action(UVM_INFO, UVM_DISPLAY | UVM_LOG);
        //env.i_agt.drv.set_report_severity_action(UVM_WARNING, UVM_DISPLAY | UVM_LOG);
        //env.i_agt.drv.set_report_severity_action(UVM_ERROR, UVM_DISPLAY | UVM_COUNT | UVM_LOG);
        //env.i_agt.drv.set_report_severity_action(UVM_FATAL, UVM_DISPLAY | UVM_EXIT | UVM_LOG);
       
        //env.i_agt.set_report_severity_file_hier(UVM_INFO,    info_log);
        //env.i_agt.set_report_severity_file_hier(UVM_WARNING, warning_log);
        //env.i_agt.set_report_severity_file_hier(UVM_ERROR,   error_log);
        //env.i_agt.set_report_severity_file_hier(UVM_FATAL,   fatal_log);
        //env.i_agt.set_report_severity_action_hier(UVM_INFO, UVM_DISPLAY| UVM_LOG);
        //env.i_agt.set_report_severity_action_hier(UVM_WARNING, UVM_DISPLAY| UVM_LOG);
        //env.i_agt.set_report_severity_action_hier(UVM_ERROR, UVM_DISPLAY| UVM_COUNT | UVM_LOG);
        //env.i_agt.set_report_severity_action_hier(UVM_FATAL, UVM_DISPLAY| | UVM_EXIT | UVM_LOG);
    endfunction
    virtual function void final_phase(uvm_phase phase);
        $fclose(info_log);
        //$fclose(warning_log);
        //$fclose(error_log);
        //$fclose(fatal_log);
    endfunction
endclass


function void base_test::build_phase(uvm_phase phase);
   super.build_phase(phase);
    
   `uvm_info("bast_test", "UVM_DEBUG is called", UVM_DEBUG);
   `uvm_info("base_test", "UVM_HIGH is called", UVM_HIGH);
    env  =  my_env::type_id::create("env", this); 
    //env0  =  my_env::type_id::create("env0", this); 
    //env1  =  my_env::type_id::create("env1", this); 
    v_sqr =  my_vsqr::type_id::create("v_sqr", this); 
endfunction

task base_test::main_phase(uvm_phase phase);
   phase.phase_done.set_drain_time(this, 1000);
endtask

function void base_test::report_phase(uvm_phase phase);
   uvm_report_server server;
   int err_num;
   super.report_phase(phase);

   server = get_report_server();
   err_num = server.get_severity_count(UVM_ERROR);

   if (err_num != 0) begin
      $display("TEST CASE FAILED");
   end
   else begin
      $display("TEST CASE PASSED");
   end
endfunction

`endif
