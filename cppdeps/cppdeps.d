module cppdeps;

import std.process : shell;
import std.stdio;
import std.array;

void main(string[] args) {
    // choose between std in and file passed as atgument
    string inputCmd = "";
    foreach(int i, arg; args) {
        if(i==0) continue;
        inputCmd ~= arg ~ " ";
    }

    writeln(LIGHTGREEN, "execute cmd: ", LIGHTBLUE, inputCmd, " -H", RESET);

    string res = shell(inputCmd ~ "-H 2>&1");

    writeln(LIGHTGREEN, "...done", RESET);

    
    string[] state;
    int depth = 0;

    auto resLines = res.split("\n");
    foreach (line ; resLines) {
        if(line.length==0 || line[0]!='.' ) continue;
        

        int d = 0;
        for ( ; line[d]=='.';++d) {}

        if (line[d]!=' ') {
            writeln(RED, "bad formatting ",BLUE, line[d], d, RESET, line );
            continue; // bad format, ignore the line;
        }
        string fileName = line[d+1..$-1];
        //write(fileName);

        if (d>depth) {
            write(RED, "+ ", RESET);
        //    state ~= 
        } else if (d<depth) {
            write(BLUE, "- ", RESET);
        } else {
            write(RESET, "* ");
        }
        depth = d;

        writeln(GREY, line, RESET);

    }
}





version(Posix)
{
    enum{ RESET = "\033[0m"
        , BOLD = "\033[1m"
        , ITALIC = "\033[3m"
        , UNDERLINED = "\033[4m"
        , BLUE = "\033[34m"
        , LIGHTBLUE = "\033[1;34m"
        , GREEN = "\033[1;32m"
        , LIGHTGREEN = "\033[1;32m"
        , RED = "\033[31m"
        , LIGHTRED = "\033[1;31m"
        , GREY = "\033[1;30m"
        , PURPLE = "\033[1;35m"
    };
} else {
    enum{ RESET = ""
        , BOLD = ""
        , ITALIC = ""
        , UNDERLINED = ""
        , BLUE = ""
        , LIGHTBLUE = ""
        , GREEN = ""
        , LIGHTGREEN = ""
        , RED = ""
        , LIGHTRED = ""
        , GREY = ""
        , PURPLE = ""
    };
}

int find(T1,T2)(T1 s, T2 c) {
    foreach(int i, T2 cc ; s) {
        if(c==cc) {
            return i;
        }
    }
    return -1;
}

