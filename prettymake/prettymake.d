module prettymake;

import std.stdio;
import std.array;

void main(string[] args) {
    auto input = &stdin;
    string line;
    while (stdin.readln(line)) {

        auto splitErr = line.split("error");
        
        for (int i=0; i<splitErr.length;++i) {
            if (i>0) write(RED, "error",RESET, splitErr[i]);
            else write(splitErr[i]);       
        }

        //string output = BLUE ~ line ~ RESET;

        //write(output);
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