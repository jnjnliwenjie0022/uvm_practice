import uvm_pkg::*;
class my_trans extends uvm_sequence_item;
  `uvm_object_utils(my_trans)
  rand bit[13:0] line;
  rand bit[13:0] pixel;
  rand bit[31:0] bytepix;
  rand bit[7:0] framerate;
  rand bit[3:0] colorinfo;
  rand bit[3:0] frame_field_video;
  function new(string name = "my_trans");
    super.new(name);
  endfunction
endclass: my_trans


class my_sequence extends uvm_sequence #(my_trans);
  `uvm_object_utils(my_sequence)
  rand bit[13:0] line;
  rand bit[13:0] pixel;
  rand bit[31:0] bytepix;
  rand bit[7:0] framerate;
  rand bit[3:0] colorinfo;
  rand bit[3:0] frame_field_video;
  my_trans tr;

  function new(string name = "my_sequence");
    super.new(name);
  endfunction

  task body;
    tr = my_trans::type_id::create("tr");
    assert(tr.randomize() with {
      line==local::line;
      pixel==local::pixel;
      bytepix==local::bytepix;
      framerate==local::framerate;
      colorinfo==local::colorinfo;
      frame_field_video==local::frame_field_video;
    })
    else begin
      `uvm_fatal("SEQ", "Randomized failed!")
    end

    `uvm_info("SEQ", $psprintf("tr.line = %0d", tr.line), UVM_NONE)
    `uvm_info("SEQ", $psprintf("tr.pixel = %0d", tr.pixel), UVM_NONE)
    `uvm_info("SEQ", $psprintf("tr.bytepix = %0d", tr.bytepix), UVM_NONE)
    `uvm_info("SEQ", $psprintf("tr.framerate = %0d", tr.framerate), UVM_NONE)
    `uvm_info("SEQ", $psprintf("tr.colorinfo = %0d", tr.colorinfo), UVM_NONE)
    `uvm_info("SEQ", $psprintf("tr.frame_field_video = %0d", tr.frame_field_video), UVM_NONE)
  endtask: body
endclass: my_sequence


class my_test extends uvm_test;
  `uvm_component_utils(my_test)

  my_sequence wr1;

  function new(string name = "adpcm_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this, "starting wr1");
    wr1 = my_sequence::type_id::create("wr1");
    assert(wr1.randomize() with {
      wr1.line==14'd2;
      wr1.pixel==14'd1400;
      wr1.bytepix==32'd3;
      wr1.framerate==8'h08;
      wr1.colorinfo==4'd1;
      wr1.frame_field_video==4'd8;
    })
    else begin
      `uvm_fatal("TEST", "Randomized failed!")
    end
    wr1.start(null);
    phase.drop_objection(this, "finished wr1");
  endtask: run_phase
endclass: my_test


module tb;
  initial begin
    run_test("my_test");
  end
endmodule: tb

