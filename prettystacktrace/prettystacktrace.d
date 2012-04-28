module prettystacktrace;


import std.stdio;
import std.array;

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


void main(string[] args) {
    // choose between std in and file passed as atgument
    File* input = &stdin;
    foreach(int i, arg; args) {
        if(i==0) continue;
        if(arg[0]!='-') {
            // ignore args of the form -foo or --bar
            input = new File(args[i]);
            break;
        }
    }

    string line;
    while (input.readln(line)) {
        // remove '\n'
        if (line.length>1) line = line[0..$-2];
        else continue;
        // tokenize
        auto tokens = line.split(" ");
        int tokIn = tokens.find("in");
        int tokAt = tokens.find("at");
        bool endl = false;
        // print
        if (line[0]=='#')   { write("\n", RED, tokens[0] ,RESET); }
        if (tokIn>0)        { write(" in ", LIGHTBLUE, tokens[tokIn+1] , RESET); }
        if (tokAt>0)        { write(" at ", LIGHTGREEN, tokens[tokAt+1] , RESET); } 
    }

}