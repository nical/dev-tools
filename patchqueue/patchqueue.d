module patchqueue;

import std.process;
import std.stdio;
import std.array;
import std.string;
import std.conv;

// patchqueue [N] -m "add a comment" # sets the comment associated to this patch
// patchqueue [N] broken # mark as broken
// patchqueue [N] ok # mark as not broken
// patchqueue [N] -i N # set importnce
// patchqueue # should display:
/*
1 * name-1 (---**) "bug 173728 comment foo bar blabla"
2 * name-2 (-****) "bug 173728 other comment foo bar blabla"
3 * name-3 (--***) "bug 156754 hello foo bar blabla"
4 - name-4 (----*) [broken] "bug 197635 comment foo bar blabla"
*/

ulong max(ulong a, ulong b){ return (a>b)?a:b; }

struct Patch {
    string name;
    string state;
    string comment;
}

Patch[] patchQueue;

void main(string[] args) {
    shell("touch .patchqueue");
    auto f = File(".patchqueue","r");
    string buf;
    string[string] comments;
    while (f.readln(buf)) {
        auto pair = buf.split("$");
        if (pair.length<2) continue;
        comments[pair[0]]=pair[1][0..$-1];
        //writeln(pair[0],":",pair[1][0..pair[1].length-1]);
    }
    f.close();

    string qseries = shell("hg qseries -v");
    auto lines = qseries.split("\n");
    int currentPatch = 0;
    ulong maxlen = 0;

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

    bool modifiedComments = false;
    string currPatchName = patchQueue[currentPatch].name;
    foreach (i, arg;args[1..$]) {
        
        auto temp = currPatchName;
        try {
            currPatchName = patchQueue[to!int(arg)-1].name;
        } catch(Exception e) {
            currPatchName = temp;
        }
        
        if (arg=="-r") {
            comments[currPatchName] = "-- Review? --";
            modifiedComments = true;
        } else if (arg=="-l") {
            comments[currPatchName] = "-- Landed! --";
            modifiedComments = true;
        } else if (arg=="-m") {
            if(args.length>i)
                comments[currPatchName] = args[i+2];
            else
                comments[currPatchName] = " ";
            modifiedComments = true;
        }
    }

    if (modifiedComments) comments.save(".patchqueue");

    foreach (i, p;patchQueue) {
        if(p.state=="U") {
            write(GREY, " | ", i+1, " ", p.name);
        } else if (p.state=="C") {
            write(LIGHTBLUE, " * ", i+1," ", p.name);
        } else if (p.state=="A") {
            write(" | ", i+1, " ", p.name);
        }
        //writeln(maxlen);

        int nSpaces = 2 + cast(int)maxlen-cast(int)p.name.length;
        //writeln(nSpaces); continue;
        for (int u=0; u<nSpaces;++u) write(' ');
        writeln("| ", p.comment, RESET);
    }


    //TODO
}

void save(string[string] comments, string file) {
    auto f = File(file,"w");
    foreach (ref p;patchQueue) {
        p.comment = comments[p.name];
        f.writeln(p.name,":",p.comment);
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