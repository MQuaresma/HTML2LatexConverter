%option noyywrap
%{
void beginSection(char *);
%}

%x TTAG HTAG BTAG
%%
\<title\>                       {BEGIN TTAG;fprintf(stdout,"\\title{");}
\<(h|H)[0-9]\>                  {BEGIN HTAG;
                                 switch(yytext[2]){
                                     case '2':
                                         beginSection("");
                                         break;
                                     case '3':
                                         beginSection("sub");
                                         break;
                                     default:
                                         beginSection("subsub");
                                         break;
                                 }
                                }
.|\n                            {;}

<TTAG>{
\<\/title\>                     {BEGIN INITIAL;fprintf(stdout,"}\n\\begin{document}\n\\maketitle\n");}
.|\n                            {fprintf(stdout,"%s",yytext);}
}

<HTAG>{
\<\/(h|H)[0-9]\>                    {BEGIN INITIAL;fprintf(stdout,"}\n");}
\<[^(\>|(h|H)[0-9])]*\>.+\<\/[^(\>|(h|H)[0-9])]*\>              {;}
.                                   {fprintf(stdout,"%s",yytext);}
\n                                  {;}
}

%%
void beginSection(char *secType){
    fprintf(stdout,"\\%ssection{",secType);
}

void beginLatex(){
    fprintf(stdout,"\\documentclass{article}\n");
}

void endLatex(){
    fprintf(stdout, "\\end{document}");
}


int main(int argc, char *argv[]){
    beginLatex();
    yyin=fopen(*++argv,"r");
    //stdout=fopen(*++argv,"w");
    yylex();
    fclose(yyin);
    endLatex();
}
