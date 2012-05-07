module prettybuild;

import utils.termcolor;

import std.stdio;
import std.array;

void main(string[] args) {
    auto input = &stdin;
    string line;
    string[] errors;
    string[] warnings;
    while (stdin.readln(line)) {

        string errLine  = line.replace("error:", LIGHTRED~"error:"~RESET);
        string warnLine = line.replace("warning:", YELLOW~"warning:"~RESET);
        write(errLine.replace("warning:", YELLOW~"warning:"~RESET));

        if (line!=errLine) {
            errors ~= errLine;
        } if (line!=warnLine) {
            warnings ~= warnLine;
        }
    }

    // summary

    if (errors.length>0) {
        if (errors.length==1) {
            writeln(LIGHTRED, "\n1 error:", RESET);
        } else {
            writeln(LIGHTRED, "\n", errors.length, " errors occured:");
        }
        foreach (err;errors) {
            write( BLUE, " * ", RESET, err);
        }
    }

    if (warnings.length>0) {
        if (errors.length==1) {
            writeln(YELLOW, "\n1 warning:", RESET);
        } else {
            writeln(YELLOW, "\n", warnings.length, " warnings:");
        }
        foreach (warn;warnings) {
            write( BLUE, " * ", RESET, warn);
        }
    }
}
