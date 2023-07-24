`ifndef MY_SEQUENCE__SV
`define MY_SEQUENCE__SV

class my_sequence extends uvm_sequence #(my_transaction);
   my_transaction m_trans;

   function new(string name= "my_sequence");
      super.new(name);
   endfunction

   virtual task body();
      repeat (10) begin
         `uvm_info("my_sequence", "body is called", UVM_LOW);
         //`uvm_do(m_trans)
         req = my_transaction::type_id::create("req"); 
         `uvm_info("my_sequence", "before wait_for_grant", UVM_LOW);
         wait_for_grant();                            //wait for grant
         `uvm_info("my_sequence", "after wait_for_grant", UVM_LOW);
         assert(req.randomize());                     //randomize the req                   
         send_request(req);                           //send req to driver
         wait_for_item_done();                        //wait for item done from driver
      end
      #1000;
   endtask

   `uvm_object_utils(my_sequence)
endclass
`endif
