#!/usr/bin/env ./tcltestrunner.lua

# 2002 May 24
#
# The author disclaims copyright to this source code.  In place of
# a legal notice, here is a blessing:
#
#    May you do good and not evil.
#    May you find forgiveness for yourself and forgive others.
#    May you share freely, never taking more than you give.
#
#***********************************************************************
# This file implements regression tests for SQLite library. 
#
# The focus of this file is testing of the proper handling of conversions
# to the native text representation.
#
# $Id: enc3.test,v 1.8 2008/01/22 01:48:09 drh Exp $

set testdir [file dirname $argv0]
source $testdir/tester.tcl

# MUST_WORK_TEST

ifcapable {utf16} {
  do_test enc3-1.1 {
    execsql {
      PRAGMA encoding=utf16le;
      PRAGMA encoding;
    }
  } {UTF-16le}
}
do_test enc3-1.2 {
  execsql {
    CREATE TABLE t1(x PRIMARY KEY,y);
    INSERT INTO t1 VALUES('abc''123',5);
    SELECT * FROM t1
  }
} {abc'123 5}
do_test enc3-1.3 {
  execsql {
    SELECT quote(x) || ' ' || quote(y) FROM t1
  }
} {{'abc''123' 5}}
ifcapable {bloblit} {
  do_test enc3-1.4 {
    execsql {
      DELETE FROM t1;
      INSERT INTO t1 VALUES(x'616263646566',NULL);
      SELECT * FROM t1
    }
  } {abcdef {}}
  do_test enc3-1.5 {
    execsql {
      SELECT quote(x) || ' ' || quote(y) FROM t1
    }
  } {{X'616263646566' NULL}}
}
ifcapable {bloblit && utf16} {
  do_test enc3-2.1 {
    execsql {
      PRAGMA encoding
    }
  } {UTF-16le}
  do_test enc3-2.2 {
    execsql {
      CREATE TABLE t2(a PRIMARY KEY);
      INSERT INTO t2 VALUES(x'61006200630064006500');
      SELECT CAST(a AS text) FROM t2 WHERE a LIKE 'abc%';
    }
  } {abcde}
  do_test enc3-2.3 {
    execsql {
      SELECT CAST(x'61006200630064006500' AS text);
    }
  } {abcde}
  # do_test enc3-2.4 {
  #   execsql {
  #     SELECT rowid FROM t2 WHERE a LIKE x'610062002500';
  #   }
  # } {1}
}

# # Try to attach a database with a different encoding.
# #
# ifcapable {utf16 && shared_cache} {
#   db close
#   forcedelete test8.db test8.db-journal
#   set ::enable_shared_cache [sqlite3_enable_shared_cache 1]
#   sqlite3 dbaux test8.db
#   sqlite3 db test.db
#   db eval {SELECT 1 FROM sqlite_master LIMIT 1}
#   do_test enc3-3.1 {
#     dbaux eval {
#       PRAGMA encoding='utf8';
#       CREATE TABLE t1(x);
#       PRAGMA encoding
#     }
#   } {UTF-8}
#   do_test enc3-3.2 {
#     catchsql {
#       ATTACH 'test.db' AS utf16;
#       SELECT 1 FROM utf16.sqlite_master LIMIT 1;
#     } dbaux
#   } {1 {attached databases must use the same text encoding as main database}}
#   dbaux close
#   forcedelete test8.db test8.db-journal
#   sqlite3_enable_shared_cache $::enable_shared_cache
# }

finish_test
