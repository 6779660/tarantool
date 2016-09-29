#!/usr/bin/env ./tcltestrunner.lua

# 2012 December 31
#
# The author disclaims copyright to this source code.  In place of
# a legal notice, here is a blessing:
#
#    May you do good and not evil.
#    May you find forgiveness for yourself and forgive others.
#    May you share freely, never taking more than you give.
#
#***********************************************************************
# 
# This file implements test for the REGEXP operator in test_regexp.c.
#

set testdir [file dirname $argv0]
source $testdir/tester.tcl

do_test regexp1-1.1 {
  load_static_extension db regexp
  db eval {
    CREATE TABLE t1(x INTEGER PRIMARY KEY, y TEXT);
    INSERT INTO t1 VALUES(1, 'For since by man came death,');
    INSERT INTO t1 VALUES(2, 'by man came also the resurrection of the dead.');
    INSERT INTO t1 VALUES(3, 'For as in Adam all die,');
    INSERT INTO t1 VALUES(4, 'even so in Christ shall all be made alive.');

    SELECT x FROM t1 WHERE y REGEXP '^For ' ORDER BY x;
  }
} {1 3}

do_execsql_test regexp1-1.2 {
  SELECT x FROM t1 WHERE y REGEXP 'by|in' ORDER BY x;
} {1 2 3 4}
do_execsql_test regexp1-1.3 {
  SELECT x FROM t1 WHERE y REGEXP 'by|Christ' ORDER BY x;
} {1 2 4}
do_execsql_test regexp1-1.4 {
  SELECT x FROM t1 WHERE y REGEXP 'shal+ al+' ORDER BY x;
} {4}
do_execsql_test regexp1-1.5 {
  SELECT x FROM t1 WHERE y REGEXP 'shall x*y*z*all' ORDER BY x;
} {4}
do_execsql_test regexp1-1.6 {
  SELECT x FROM t1 WHERE y REGEXP 'shallx?y? ?z?all' ORDER BY x;
} {4}
do_execsql_test regexp1-1.7 {
  SELECT x FROM t1 WHERE y REGEXP 'r{2}' ORDER BY x;
} {2}
do_execsql_test regexp1-1.8 {
  SELECT x FROM t1 WHERE y REGEXP 'r{3}' ORDER BY x;
} {}
do_execsql_test regexp1-1.9 {
  SELECT x FROM t1 WHERE y REGEXP 'r{1}' ORDER BY x;
} {1 2 3 4}
do_execsql_test regexp1-1.10 {
  SELECT x FROM t1 WHERE y REGEXP 'ur{2,10}e' ORDER BY x;
} {2}
do_execsql_test regexp1-1.11 {
  SELECT x FROM t1 WHERE y REGEXP '[Aa]dam' ORDER BY x;
} {3}
do_execsql_test regexp1-1.12 {
  SELECT x FROM t1 WHERE y REGEXP '[^Aa]dam' ORDER BY x;
} {}
do_execsql_test regexp1-1.13 {
  SELECT x FROM t1 WHERE y REGEXP '[^b-zB-Z]dam' ORDER BY x;
} {3}
do_execsql_test regexp1-1.14 {
  SELECT x FROM t1 WHERE y REGEXP 'alive' ORDER BY x;
} {4}
do_execsql_test regexp1-1.15 {
  SELECT x FROM t1 WHERE y REGEXP '^alive' ORDER BY x;
} {}
do_execsql_test regexp1-1.16 {
  SELECT x FROM t1 WHERE y REGEXP 'alive$' ORDER BY x;
} {}
do_execsql_test regexp1-1.17 {
  SELECT x FROM t1 WHERE y REGEXP 'alive.$' ORDER BY x;
} {4}
do_execsql_test regexp1-1.18 {
  SELECT x FROM t1 WHERE y REGEXP 'alive\.$' ORDER BY x;
} {4}
do_execsql_test regexp1-1.19 {
  SELECT x FROM t1 WHERE y REGEXP 'ma[nd]' ORDER BY x;
} {1 2 4}
do_execsql_test regexp1-1.20 {
  SELECT x FROM t1 WHERE y REGEXP '\bma[nd]' ORDER BY x;
} {1 2 4}
do_execsql_test regexp1-1.21 {
  SELECT x FROM t1 WHERE y REGEXP 'ma[nd]\b' ORDER BY x;
} {1 2}
do_execsql_test regexp1-1.22 {
  SELECT x FROM t1 WHERE y REGEXP 'ma\w' ORDER BY x;
} {1 2 4}
do_execsql_test regexp1-1.23 {
  SELECT x FROM t1 WHERE y REGEXP 'ma\W' ORDER BY x;
} {}
do_execsql_test regexp1-1.24 {
  SELECT x FROM t1 WHERE y REGEXP '\sma\w' ORDER BY x;
} {1 2 4}
do_execsql_test regexp1-1.25 {
  SELECT x FROM t1 WHERE y REGEXP '\Sma\w' ORDER BY x;
} {}
do_execsql_test regexp1-1.26 {
  SELECT x FROM t1 WHERE y REGEXP 'alive\S$' ORDER BY x;
} {4}
do_execsql_test regexp1-1.27 {
  SELECT x FROM t1 WHERE y REGEXP
          '\b(unto|us|son|given|his|name|called|' ||
          'wonderful|councelor|mighty|god|everlasting|father|' ||
          'prince|peace|alive)\b';
} {4}

do_execsql_test regexp1-2.1 {
  SELECT 'aaaabbbbcccc' REGEXP 'ab*c', 
         'aaaacccc' REGEXP 'ab*c';
} {1 1}
do_execsql_test regexp1-2.2 {
  SELECT 'aaaabbbbcccc' REGEXP 'ab+c',
         'aaaacccc' REGEXP 'ab+c';
} {1 0}
do_execsql_test regexp1-2.3 {
  SELECT 'aaaabbbbcccc' REGEXP 'ab?c',
         'aaaacccc' REGEXP 'ab?c';
} {0 1}
do_execsql_test regexp1-2.4 {
  SELECT 'aaaabbbbbbcccc' REGEXP 'ab{3,5}c',
         'aaaabbbbbcccc' REGEXP 'ab{3,5}c',
         'aaaabbbbcccc' REGEXP 'ab{3,5}c',
         'aaaabbbcccc' REGEXP 'ab{3,5}c',
         'aaaabbcccc' REGEXP 'ab{3,5}c',
         'aaaabcccc' REGEXP 'ab{3,5}c'
} {0 1 1 1 0 0}
do_execsql_test regexp1-2.5 {
  SELECT 'aaaabbbbcccc' REGEXP 'a(a|b|c)+c',
         'aaaabbbbcccc' REGEXP '^a(a|b|c){11}c$',
         'aaaabbbbcccc' REGEXP '^a(a|b|c){10}c$',
         'aaaabbbbcccc' REGEXP '^a(a|b|c){9}c$'
} {1 0 1 0}
do_execsql_test regexp1-2.6 {
  SELECT 'aaaabbbbcccc' REGEXP '^a(a|bb|c)+c$',
         'aaaabbbbcccc' REGEXP '^a(a|bbb|c)+c$',
         'aaaabbbbcccc' REGEXP '^a(a|bbbb|c)+c$'
} {1 0 1}
do_execsql_test regexp1-2.7 {
  SELECT 'aaaabbbbcccc' REGEXP '^a([ac]+|bb){3}c$',
         'aaaabbbbcccc' REGEXP '^a([ac]+|bb){4}c$',
         'aaaabbbbcccc' REGEXP '^a([ac]+|bb){5}c$'
} {0 1 1}

do_execsql_test regexp1-2.8 {
  SELECT 'abc*def+ghi.jkl[mno]pqr' REGEXP 'c.d',
         'abc*def+ghi.jkl[mno]pqr' REGEXP 'c\*d',
         'abc*def+ghi.jkl[mno]pqr' REGEXP 'f\+g',
         'abc*def+ghi.jkl[mno]pqr' REGEXP 'i\.j',
         'abc*def+ghi.jkl[mno]pqr' REGEXP 'l\[mno\]p'
} {1 1 1 1 1}

do_test regexp1-2.9 {
  set v1 "abc\ndef"
  db eval {SELECT $v1 REGEXP '^abc\ndef$'}
} {1}
do_test regexp1-2.10 {
  set v1 "abc\adef"
  db eval {SELECT $v1 REGEXP '^abc\adef$'}
} {1}
do_test regexp1-2.11 {
  set v1 "abc\tdef"
  db eval {SELECT $v1 REGEXP '^abc\tdef$'}
} {1}
do_test regexp1-2.12 {
  set v1 "abc\rdef"
  db eval {SELECT $v1 REGEXP '^abc\rdef$'}
} {1}
do_test regexp1-2.13 {
  set v1 "abc\fdef"
  db eval {SELECT $v1 REGEXP '^abc\fdef$'}
} {1}
do_test regexp1-2.14 {
  set v1 "abc\vdef"
  db eval {SELECT $v1 REGEXP '^abc\vdef$'}
} {1}
do_execsql_test regexp1-2.15 {
  SELECT 'abc\def' REGEXP '^abc\\def',
         'abc(def' REGEXP '^abc\(def',
         'abc)def' REGEXP '^abc\)def',
         'abc*def' REGEXP '^abc\*def',
         'abc.def' REGEXP '^abc\.def',
         'abc+def' REGEXP '^abc\+def',
         'abc?def' REGEXP '^abc\?def',
         'abc[def' REGEXP '^abc\[def',
         'abc$def' REGEXP '^abc\$',
         '^def'    REGEXP '\^def',
         'abc{4}x' REGEXP '^abc\{4\}x$',
         'abc|def' REGEXP '^abc\|def$'
} {1 1 1 1 1 1 1 1 1 1 1 1}

do_execsql_test regexp1-2.20 {
  SELECT 'abc$¢€xyz' REGEXP '^abc\u0024\u00a2\u20acxyz$',
         'abc$¢€xyz' REGEXP '^abc\u0024\u00A2\u20ACxyz$',
         'abc$¢€xyz' REGEXP '^abc\x24\xa2\u20acxyz$'
} {1 1 1}
do_execsql_test regexp1-2.21 {
  SELECT 'abc$¢€xyz' REGEXP '^abc[\u0024][\u00a2][\u20ac]xyz$',
         'abc$¢€xyz' REGEXP '^abc[\u0024\u00A2\u20AC]{3}xyz$',
         'abc$¢€xyz' REGEXP '^abc[\x24][\xa2\u20ac]+xyz$'
} {1 1 1}
do_execsql_test regexp1-2.22 {
  SELECT 'abc$¢€xyz' REGEXP '^abc[^\u0025-X][^ -\u007f][^\u20ab]xyz$'
} {1}

finish_test
