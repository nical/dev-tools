module patchqueue;

import std.process;
import std.stdio;
import std.array;
import std.string;
import std.conv;

ulong max(ulong a, ulong b){ return (a>b)?a:b; }

struct Patch {
    string name;
    string state;
    string comment;
}

void main(string[] args) {

    Patch[] patchQueue;

    // load the comments
    shell("touch .patchqueue");
    auto f = File(".patchqueue","r");
    string buf;
    string[string] comments;
    while (f.readln(buf)) {
        auto pair = buf.split("$");
        if (pair.length<2) continue;
        comments[pair[0]]=pair[1][0..$-1];
        //writeln(pair[0],"$",pair[1][0..$-1]);
    }
    f.close();

    
    int currentPatch = 0;
    ulong maxlen = 0;
    // build the patch queue from hg qseries -v output
    {
        string qseries = shell("hg qseries -v");
        auto lines = qseries.split("\n");
        foreach (i, line;lines) {
            auto tokens = line.split(" ");
            if (tokens.length < 3) break;

            string com = " ";
            if (tokens[2] in comments) com = comments[tokens[2]];
            
            patchQueue ~= Patch(tokens[2],tokens[1], com );
            
            if (tokens[1]=="U" && i>0 && patchQueue[i-1].state=="A") {
                patchQueue[i-1].state = "C";
                currentPatch = cast(int)i-1;
            }
            if (max(maxlen,patchQueue[i].name.length)>maxlen) maxlen = patchQueue[i].name.length;
        }
    }

    
    bool reloadPatchQueue = false;
    bool modifiedComments = false;
    int targetPatch = currentPatch;
    
    // process command line arguments
    foreach (i, arg;args[1..$]) {
        try {
            targetPatch = to!int(arg)-1;
            continue;
        } catch(Exception e) {}

        if (arg=="export") {            
            writeln(shell("hg export qtip"));
        } else if (arg=="diff") {            
            writeln(shell("hg export qtip | pygmentize -l diff"));
        } else if (arg=="refresh") {            
            shell("hg qrefresh");
        } else if (arg=="try") {
            // mozilla specific, ush to try server
            writeln(BLUE," * ", "hg qnew -m 'try: -b do -p all -u all -t none' try", RESET);
                  writeln(shell("hg qnew -m 'try: -b do -p all -u all -t none' try"));
            writeln(BLUE," * ", "hg push -f try", RESET);
                  writeln(shell("hg push -f try"));
            writeln(BLUE," * " ,"hg qpop", RESET);
                  writeln(shell("hg qpop"));
            writeln(BLUE, " * ","hg qremove try", RESET);
                  writeln(shell("hg qremove try"));
            reloadPatchQueue = true;
        } else if (arg=="push") {
            writeln(shell("hg qpush"));
            reloadPatchQueue = true;
        } else if (arg=="pop") {
            writeln(shell("hg qpop"));
            reloadPatchQueue = true;
        } else if (arg=="-r" || arg=="--review") {
            patchQueue[targetPatch].comment = "-- Review? --";
            modifiedComments = true;
        } else if (arg=="r+" || arg=="--review+") {
            patchQueue[targetPatch].comment = "-- Review+ --";
            modifiedComments = true;
        } else if (arg=="r-" || arg=="--review+") {
            patchQueue[targetPatch].comment = "-- Review- --";
            modifiedComments = true;
        } else if (arg=="-l" || arg=="--landed") {
            patchQueue[targetPatch].comment = "-- Landed! --";
            modifiedComments = true;
        } else if (arg=="-m" || arg=="--message") {
            if(args.length>i){
                patchQueue[targetPatch].comment = args[i+2];
            } else {
                patchQueue[targetPatch].comment = " ";
            }
            modifiedComments = true;
        }
    }

    // save comment changes if any
    if (modifiedComments) {
        {
            auto f2 = File(".patchqueue","w");
            foreach (ref p;patchQueue) {
                f2.writeln(p.name,"$",p.comment);
            }
        }
        
    }

    // if we changed our position in the queue, let's reload it to make sure we
    // display the right current position
    if (reloadPatchQueue)
    {
        patchQueue = [];
        string qseries = shell("hg qseries -v");
        auto lines = qseries.split("\n");
        foreach (i, line;lines) {
            auto tokens = line.split(" ");
            if (tokens.length < 3) break;

            string com = " ";
            if (tokens[2] in comments) com = comments[tokens[2]];
            
            patchQueue ~= Patch(tokens[2],tokens[1], com );
            
            if (tokens[1]=="U" && i>0 && patchQueue[i-1].state=="A") {
                patchQueue[i-1].state = "C";
                currentPatch = cast(int)i-1;
            }
            if (max(maxlen,patchQueue[i].name.length)>maxlen) maxlen = patchQueue[i].name.length;
        }
    }

    // output to stdout
    writeln();
    foreach (i, p;patchQueue) {
        string s = "";
        if (i+1<10) s = " ";
        if (p.state=="U") {
            write(GREY, " | ", s, i+1, " ", p.name);
        } else if (p.state=="C") {
            write(LIGHTBLUE, " * ", s, i+1," ", p.name);
        } else if (p.state=="A") {
            write(" | ", s, i+1, " ", p.name);
        }
        
        int nSpaces = 2 + cast(int)maxlen-cast(int)p.name.length;
        for (int u=0; u<nSpaces;++u) write(' ');
        writeln("| ", p.comment, RESET);
    }
} // main

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