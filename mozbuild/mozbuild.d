module mozbuild;
import utils.termcolor;

import std.stdio;
import std.process;

void main(string[] args) {

    string cmd = "";
    string objDir = "obj-Linux64dbg";
    bool incremental = false;

    if (args.length > 1) {
        incremental = true;
    }

    foreach (arg;args[1..$]) {
        if (arg[0]!='-') {
            cmd ~=" make -C "~objDir~"/"~arg ~" 1>&2 && ";
        } 
    }

    if (incremental) {
        cmd ~=" make -C "~objDir~"/toolkit/library 1>&2";
        writeln(BLUE, "Incremental build.");
        writeln(BLUE, cmd, RESET);
        shell(cmd);
    } else {
        writeln(BLUE, "Normal build.");
        writeln(BLUE, "make -f client.mk -s 1>&2", RESET);
        shell("make -f client.mk -s 1>&2");
    }
}