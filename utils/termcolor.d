module utils.termcolor;

version(Posix) {
    enum{ RESET         = "\033[0m"
        , BOLD          = "\033[1m"
        , ITALIC        = "\033[3m"
        , UNDERLINED    = "\033[4m"

        , GREY          = "\033[0;30m"
        , LIGHGREY      = "\033[1;30m"
        , RED           = "\033[31m"
        , LIGHTRED      = "\033[1;31m"
        , GREEN         = "\033[1;32m"
        , LIGHTGREEN    = "\033[1;32m"
        , YELLOW        = "\033[33m"
        , LIGHTYELLOW   = "\033[1;33m"
        , BLUE          = "\033[34m"
        , LIGHTBLUE     = "\033[1;34m"
        , PURPLE        = "\033[0;35m"
        , LIGHTPURPLE   = "\033[1;35m"
        , CYAN          = "\033[0;36m"
        , LIGHTCYAN     = "\033[1;36m"

        , HIGHLIGHT_GREY    = "\033[1;40m"
        , HIGHLIGHT_RED     = "\033[1;41m"
        , HIGHLIGHT_GREEN   = "\033[1;42m"
        , HIGHLIGHT_YELLOW  = "\033[1;43m"
        , HIGHLIGHT_BLUE    = "\033[1;44m"
        , HIGHLIGHT_PURPLE  = "\033[1;45m"
        , HIGHLIGHT_CYAN    = "\033[1;46m"
        , HIGHLIGHT_LIGHTGREY = "\033[2;47m"
    }
} else {
    enum{ RESET         = ""
        , BOLD          = ""
        , ITALIC        = ""
        , UNDERLINED    = ""

        , GREY          = ""
        , LIGHGREY      = ""
        , RED           = ""
        , LIGHTRED      = ""
        , GREEN         = ""
        , LIGHTGREEN    = ""
        , YELLOW        = ""
        , LIGHTYELLOW   = ""
        , BLUE          = ""
        , LIGHTBLUE     = ""
        , PURPLE        = ""
        , LIGHTPURPLE   = ""
        , CYAN          = ""
        , LIGHTCYAN     = ""

        , HIGHLIGHT_GREY    = ""
        , HIGHLIGHT_RED     = ""
        , HIGHLIGHT_GREEN   = ""
        , HIGHLIGHT_YELLOW  = ""
        , HIGHLIGHT_BLUE    = ""
        , HIGHLIGHT_PURPLE  = ""
        , HIGHLIGHT_CYAN    = ""
        , HIGHLIGHT_LIGHTGREY = ""
    }
} // version

/+
void main() {
    import std.stdio;
    import std.conv;

    for(int i = 0; i < 100; ++i) {
        string dark = "\033[0;" ~ i.to!string() ~"m";
        string light = "\033[1;" ~ i.to!string() ~"m";
        string other2 = "\033[2;" ~ i.to!string() ~"m";
        string other3 = "\033[3;" ~ i.to!string() ~"m";
        string other4 = "\033[4;" ~ i.to!string() ~"m";
        writeln( RESET, "#   ", i, "  ", dark, "- dark -"
            , RESET,"  ", light, "- light -"
            , RESET, other2, " -- Foo2 --"
            , RESET, other3, " -- Bar3 --"
            , RESET, other4, " -- Plop4 --"
            , RESET);
    }
}
+/