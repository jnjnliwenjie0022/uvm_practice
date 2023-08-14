import uvm_pkg::*;

class Simplesum;
    rand bit[7:0] x,y,z;
    int a = 0;
    constraint c {
        if(a==0)
            z==x+y;
        else
            z==x;
    };

    function void pre_randomize();
        a=1;
    endfunction

    function void post_randomize();
        z=y;
    endfunction
endclass

class Beverage;
    rand bit [7:0] beer_id;

    constraint c_beer_id {beer_id >= 10;
                          beer_id <= 50;};


endclass

module tb;
    Simplesum p;
    Beverage b;
    int status;

    initial begin
        p = new();
        b = new();
        $display(" before random a=%0d, x=%0h, y=%0h, z=%0h",p.a,p.x,p.y,p.z);

        status = p.randomize();
        $display("status: %0h", status); // 1 is successful

        $display(" after  random a=%0d, x=%0h, y=%0h, z=%0h",p.a,p.x,p.y,p.z);

        status = b.randomize();
        $display("status: %0h", status);

    end
endmodule
