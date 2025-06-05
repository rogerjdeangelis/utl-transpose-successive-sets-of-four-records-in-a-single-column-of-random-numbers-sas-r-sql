%let pgm=utl-transpose-successive-sets-of-four-records-in-a-single-column-of-random-numbers-sas-r-sql;

%stop_submission;

Transpose successive sets of four records in a single column of random letters using sas r sql

Not well suited for sql, but I provided for completeness.

   SOLUTIONS
        1 sas # cards input (6 methods)
        2 sas array
          PeterClemmensen
          https://communities.sas.com/t5/user/viewprofilepage/user-id/3130
        3 r matrix
        4 sas sql
        5 r sql (also works im python and excel)
        6 sas datstep mod

github
https://tinyurl.com/3tecpnyt
https://github.com/rogerjdeangelis/utl-transpose-successive-sets-of-four-records-in-a-single-column-of-random-numbers-sas-r-sql

SOAPBOX ON

Algorithm to create grouping variables.
Can be used  sql.

Suppose you have and you want
   have               want
   ----        ----------------
     a         1    1    1    a
     b         1    2    2    b
     c         1    3    3    c
     d         1    4    4    d
     e         2    1    5    e
     f         2    2    6    f
     g         2    3    7    g
     h         2    4    8    h

data grp;
   input ltr$;
   grp=floor((_n_-1)/4) +1;
   fours=mod(_n_-1,4)+1;
   seq=_n_;
cards4;
a
b
c
d
e
f
g
h
;;;;
run;quit;

SOAPBOX OFF


SAS COMMUNITIES
https://tinyurl.com/bdrmwhn
https://communities.sas.com/t5/SAS-Programming/Rearrange-A-Column-Of-Text-In-A-Particular-Way/m-p/787983#M251855

/**************************************************************************************************************************/
/*                 INPUT & PROCESS SIX METHODS                             |              OUTPUT                          */
/*                 ============================                            |              ======                          */
/*They all use the dfault flowover option. Some more flexible than others  |  WORK.HAVE total obs=2                       */
/*BEST                                                                     |                                              */
/*data have; data have;  data have; data want;  data want;  data want;     |   VAR1    VAR2    VAR3    VAR4               */
/*input      input       input      input       input       infile cards4  |                                              */
/* var1 $    #1 var1 $     var1 $   var1$       var1$         flowover;    |    a       b       c       d                 */
/* var2 $    #2 var2 $   / var2 $   var2$       var2$       input          |    e       f       g       h                 */
/* var3 $    #3 var3 $   / var3 $   var3$       var3$       var1$          |                                              */
/* var4 $;   #4 var4 $;  / var4 $;  var4$  @;  var4$  @@;   var2$          |                                              */
/*cards4;    ards4;      cards4;    cards4;     cards4;     var3$          |                                              */
/*a          a           a          a           a           var4$;         |                                              */
/*b          b           b          b           b           cards4;        |                                              */
/*c          c           c          c           c           a              |                                              */
/*d          d           d          d           d           b              |                                              */
/*e          e           e          e           e           c              |                                              */
/*f          f           f          f           f           d              |                                              */
/*g          g           g          g           g           e              |                                              */
/*h          h           h          h           h           f              |                                              */
/*;;;;       ;;;;        ;;;;       ;;;;        ;;;;        g              |                                              */
/*run;       run;        run;       run;quit;   run;quit;   h              |                                              */
/*                                                          ;;;;           |                                              */
/*                                                          run;quit;      |                                              */
/*------------------------------------------------------------------------------------------------------------------------*/
/*  INPUT           | PROCESS                                              |  WORK.HAVE total obs=2                       */
/*  -----           | -------                                              |                                              */
/*  SD1.HAVE obs=8  |                                                      |   V1    V2    V3    V4                       */
/*   LTR            | 2 SAS ARRAY                                          |                                              */
/*                  | ===========                                          |   a     b     c     d                        */
/*    a             |                                                      |   e     f     g     h                        */
/*    b             | data want;                                           |                                              */
/*    c             |    set sd1.have;                                     |                                              */
/*    d             |    array v{*} $ v1 - v4;                             |                                              */
/*    e             |    m = mod(_N_ - 1, 4) + 1;                          |                                              */
/*    f             |    v[m] = ltr;                                       |                                              */
/*    g             |    if m = 4;                                         |                                              */
/*    h             |    retain v:;                                        |                                              */
/*                  |    keep v:;                                          |                                              */
/* options          | run;                                                 |                                              */
/* validvarname=    |                                                      |      [,1] [,2] [,3] [,4]                     */
/* upcase;          |                                                      |      [,1] [,2] [,3] [,4]                     */
/* libname sd1      |-----------------------------------------------------------------------------------------------------*/
/*   "d:/sd1";      | 3 R MATRIX                                           | > R                                          */
/* data sd1.have;   | ==========                                           |      [,1] [,2] [,3] [,4]                     */
/* input ltr$;      |                                                      | [1,] "a"  "b"  "c"  "d"                      */
/* cards4;          | A ONE LINER                                          | [2,] "e"  "f"  "g"  "h"                      */
/* a                |                                                      |                                              */
/* b                | want<-matrix(                                        | SAS                                          */
/* c                |     have                                             |                                              */
/* d                |    ,nrow=2                                           | SD1.WANT                                     */
/* e                |    ,ncol=4                                           |                                              */
/* f                |    ,byrow=TRUE);                                     |  COL_0    COL_1    COL_2    COL_3            */
/* g                |                                                      |                                              */
/* h                |                                                      |    a        b        c        d              */
/* ;;;;             | %utl_rbeginx;                                        |    e        f        g        h
/* run;quit;        | parmcards4;                                          |
/*                  | library(haven)                                       |                                              */
/*                  | library(sqldf)                                       |                                              */
/*                  | source("c:/oto/fn_tosas9x.R")                        |                                              */
/*                  | have<-unlist(                                        |                                              */
/*                  |  read_sas("d:/sd1/have.sas7bdat"))                   |                                              */
/*                  | have                                                 |                                              */
/*                  | want<-matrix(                                        |                                              */
/*                  |   have                                               |                                              */
/*                  |  ,nrow=2                                             |                                              */
/*                  |  ,ncol=4                                             |                                              */
/*                  |  ,byrow=TRUE);                                       |                                              */
/*                  | want                                                 |                                              */
/*                  | fn_tosas9x(                                          |                                              */
/*                  |       inp    = want                                  |                                              */
/*                  |      ,outlib ="d:/sd1/"                              |                                              */
/*                  |      ,outdsn ="want"                                 |                                              */
/*                  |      )                                               |                                              */
/*                  | ;;;;                                                 |                                              */
/*                  | %utl_rendx;                                          |                                              */
/*                  |                                                      |                                              */
/*                  | proc print data=sd1.want;                            |                                              */
/*                  | run;quit;                                            |                                              */
/*                  |                                                      |                                              */
/*                  |-----------------------------------------------------------------------------------------------------*/
/*                  | 4 SAS SQL                                            |  GROUP    L1    L2    L3    L4               */
/*                  | =========                                            |                                              */
/*                  | proc sql;                                            |    0      a     b     c     d                */
/*                  | create table want as                                 |    1      e     f     g     h                */
/*                  | select                                               |                                              */
/*                  |    floor(seq/4) as group                             |                                              */
/*                  |   ,max(case when mod(seq-1,4)=0 then Ltr end) as L1  |                                              */
/*                  |   ,max(case when mod(seq-1,4)=1 then Ltr end) as L2  |                                              */
/*                  |   ,max(case when mod(seq-1,4)=2 then Ltr end) as L3  |                                              */
/*                  |   ,max(case when mod(seq-1,4)=3 then Ltr end) as L4  |                                              */
/*                  | from                                                 |                                              */
/*                  |    %sqlpartition(dsn=sd1.have,by=ltr)                |                                              */
/*                  | group                                                |                                              */
/*                  |    by floor((seq-1)/4)                               |                                              */
/*                  | ;quit;                                               |                                              */
/*                  |---------------------------------------------------------------------------------------------------- */
/*                  |                                                      |                                              */
/*                  | 5 R SQL                                              | > want                                       */
/*                  | =======                                              |   grp L1 L2 L3 L4                            */
/*                  |                                                      | 1   0  a  b  c  d                            */
/*                  | %utl_rbeginx;                                        | 2   1  e  f  g  h                            */
/*                  | parmcards4;                                          |                                              */
/*                  | library(haven)                                       | WORK.WANT total obs=2                        */
/*                  | library(sqldf)                                       |                                              */
/*                  | source("c:/oto/fn_tosas9x.R")                        |  GRP    L1    L2    L3    L4                 */
/*                  | options(sqldf.dll = "d:/dll/sqlean.dll")             |                                              */
/*                  | have<-read_sas("d:/sd1/have.sas7bdat")               |   0     a     b     c     d                  */
/*                  | print(have)                                          |   1     e     f     g     h                  */
/*                  | want<-sqldf('                                        |                                              */
/*                  | with                                                 |                                              */
/*                  |    groups as (                                       |                                              */
/*                  | select                                               |                                              */
/*                  |  *                                                   |                                              */
/*                  | ,rowid as seq                                        |                                              */
/*                  | ,floor((rowid-1)/4) as grp                           |                                              */
/*                  | from                                                 |                                              */
/*                  |  have)                                               |                                              */
/*                  | SELECT                                               |                                              */
/*                  |   grp                                                |                                              */
/*                  |  ,MAX(CASE WHEN mod(seq-1,4)=0 THEN Ltr END) AS L1   |                                              */
/*                  |  ,MAX(CASE WHEN mod(seq-1,4)=1 THEN Ltr END) AS L2   |                                              */
/*                  |  ,MAX(CASE WHEN mod(seq-1,4)=2 THEN Ltr END) AS L3   |                                              */
/*                  |  ,MAX(CASE WHEN mod(seq-1,4)=3 THEN Ltr END) AS L4   |                                              */
/*                  | FROM groups                                          |                                              */
/*                  | GROUP BY grp')                                       |                                              */
/*                  | want                                                 |                                              */
/*                  | fn_tosas9x(                                          |                                              */
/*                  |       inp    = want                                  |                                              */
/*                  |      ,outlib ="d:/sd1/"                              |                                              */
/*                  |      ,outdsn ="want"                                 |                                              */
/*                  |      )                                               |                                              */
/*                  | ;;;;                                                 |                                              */
/*                  | %utl_rendx;                                          |                                              */
/*                  |                                                      |                                              */
/*                  | proc print data=sd1.want;                            |                                              */
/*                  | run;quit;                                            |                                              */
/*                  |                                                      |                                              */
/*                  |-----------------------------------------------------------------------------------------------------*/
/*                  |                                                      | V1    V2    V3    V4                         */
/*                  | 6 SAS BASE NO LOOP                                   |                                              */
/*                  | ==================                                   | a     b     c     d                          */
/*                  |                                                      | e     f     g     h                          */
/*                  | data grp ;                                           |                                              */
/*                  |    retain v1-v4;                                     |                                              */
/*                  |    set sd1.have;                                     |                                              */
/*                  |    fours=mod(_n_-1,4)+1;                             |                                              */
/*                  |    if fours=1 then v1=ltr;                           |                                              */
/*                  |    if fours=2 then v2=ltr;                           |                                              */
/*                  |    if fours=3 then v3=ltr;                           |                                              */
/*                  |    if fours=4 then v4=ltr;                           |                                              */
/*                  |    if fours=4 then output;                           |                                              */
/*                  | run;quit;                                            |                                              */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
