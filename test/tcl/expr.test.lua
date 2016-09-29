#!/usr/bin/env ./tcltestrunner.lua

# 2001 September 15
#
# The author disclaims copyright to this source code.  In place of
# a legal notice, here is a blessing:
#
#    May you do good and not evil.
#    May you find forgiveness for yourself and forgive others.
#    May you share freely, never taking more than you give.
#
#***********************************************************************
# This file implements regression tests for SQLite library.  The
# focus of this file is testing expressions.
#
# $Id: expr.test,v 1.67 2009/02/04 03:59:25 shane Exp $

set testdir [file dirname $argv0]
source $testdir/tester.tcl

# # Create a table to work with.
# #
# ifcapable floatingpoint {
#   execsql {CREATE TABLE test1(i1 int, i2 int, r1 real, r2 real, t1 text, t2 text)}
#   execsql {INSERT INTO test1 VALUES(1,2,1.1,2.2,'hello','world')}
# }
# ifcapable !floatingpoint {
#   execsql {CREATE TABLE test1(i1 int, i2 int, t1 text, t2 text)}
#   execsql {INSERT INTO test1 VALUES(1,2,'hello','world')}
# }

# proc test_expr {name settings expr result} {
#   do_test $name [format {
#     execsql {BEGIN; UPDATE test1 SET %s; SELECT %s FROM test1; ROLLBACK;}
#   } $settings $expr] $result
# }
# proc test_realnum_expr {name settings expr result} {
#   do_realnum_test $name [format {
#     execsql {BEGIN; UPDATE test1 SET %s; SELECT %s FROM test1; ROLLBACK;}
#   } $settings $expr] $result
# }

# test_expr expr-1.1 {i1=10, i2=20} {i1+i2} 30
# test_expr expr-1.2 {i1=10, i2=20} {i1-i2} -10
# test_expr expr-1.3 {i1=10, i2=20} {i1*i2} 200
# test_expr expr-1.4 {i1=10, i2=20} {i1/i2} 0
# test_expr expr-1.5 {i1=10, i2=20} {i2/i1} 2
# test_expr expr-1.6 {i1=10, i2=20} {i2<i1} 0
# test_expr expr-1.7 {i1=10, i2=20} {i2<=i1} 0
# test_expr expr-1.8 {i1=10, i2=20} {i2>i1} 1
# test_expr expr-1.9 {i1=10, i2=20} {i2>=i1} 1
# test_expr expr-1.10 {i1=10, i2=20} {i2!=i1} 1
# test_expr expr-1.11 {i1=10, i2=20} {i2=i1} 0
# test_expr expr-1.12 {i1=10, i2=20} {i2<>i1} 1
# test_expr expr-1.13 {i1=10, i2=20} {i2==i1} 0
# test_expr expr-1.14 {i1=20, i2=20} {i2<i1} 0
# test_expr expr-1.15 {i1=20, i2=20} {i2<=i1} 1
# test_expr expr-1.16 {i1=20, i2=20} {i2>i1} 0
# test_expr expr-1.17 {i1=20, i2=20} {i2>=i1} 1
# test_expr expr-1.18 {i1=20, i2=20} {i2!=i1} 0
# test_expr expr-1.19 {i1=20, i2=20} {i2=i1} 1
# test_expr expr-1.20 {i1=20, i2=20} {i2<>i1} 0
# test_expr expr-1.21 {i1=20, i2=20} {i2==i1} 1
# ifcapable floatingpoint {
#   test_expr expr-1.22 {i1=1, i2=2, r1=3.0} {i1+i2*r1} {7.0}
#   test_expr expr-1.23 {i1=1, i2=2, r1=3.0} {(i1+i2)*r1} {9.0}
# }
# test_expr expr-1.24 {i1=1, i2=2} {min(i1,i2,i1+i2,i1-i2)} {-1}
# test_expr expr-1.25 {i1=1, i2=2} {max(i1,i2,i1+i2,i1-i2)} {3}
# test_expr expr-1.26 {i1=1, i2=2} {max(i1,i2,i1+i2,i1-i2)} {3}
# test_expr expr-1.27 {i1=1, i2=2} {i1==1 AND i2=2} {1}
# test_expr expr-1.28 {i1=1, i2=2} {i1=2 AND i2=1} {0}
# test_expr expr-1.29 {i1=1, i2=2} {i1=1 AND i2=1} {0}
# test_expr expr-1.30 {i1=1, i2=2} {i1=2 AND i2=2} {0}
# test_expr expr-1.31 {i1=1, i2=2} {i1==1 OR i2=2} {1}
# test_expr expr-1.32 {i1=1, i2=2} {i1=2 OR i2=1} {0}
# test_expr expr-1.33 {i1=1, i2=2} {i1=1 OR i2=1} {1}
# test_expr expr-1.34 {i1=1, i2=2} {i1=2 OR i2=2} {1}
# test_expr expr-1.35 {i1=1, i2=2} {i1-i2=-1} {1}
# test_expr expr-1.36 {i1=1, i2=0} {not i1} {0}
# test_expr expr-1.37 {i1=1, i2=0} {not i2} {1}
# test_expr expr-1.38 {i1=1} {-i1} {-1}
# test_expr expr-1.39 {i1=1} {+i1} {1}
# test_expr expr-1.40 {i1=1, i2=2} {+(i2+i1)} {3}
# test_expr expr-1.41 {i1=1, i2=2} {-(i2+i1)} {-3}
# test_expr expr-1.42 {i1=1, i2=2} {i1|i2} {3}
# test_expr expr-1.42b {i1=1, i2=2} {4|2} {6}
# test_expr expr-1.43 {i1=1, i2=2} {i1&i2} {0}
# test_expr expr-1.43b {i1=1, i2=2} {4&5} {4}
# test_expr expr-1.44 {i1=1} {~i1} {-2}
# test_expr expr-1.44b {i1=NULL} {~i1} {{}}
# test_expr expr-1.45a {i1=1, i2=3} {i1<<i2} {8}
# test_expr expr-1.45b {i1=1, i2=-3} {i1>>i2} {8}
# test_expr expr-1.45c {i1=1, i2=0} {i1<<i2} {1}
# test_expr expr-1.45d {i1=1, i2=62} {i1<<i2} {4611686018427387904}
# test_expr expr-1.45e {i1=1, i2=63} {i1<<i2} {-9223372036854775808}
# test_expr expr-1.45f {i1=1, i2=64} {i1<<i2} {0}
# test_expr expr-1.45g {i1=32, i2=-9223372036854775808} {i1>>i2} {0}
# test_expr expr-1.46a {i1=32, i2=3} {i1>>i2} {4}
# test_expr expr-1.46b {i1=32, i2=6} {i1>>i2} {0}
# test_expr expr-1.46c {i1=-32, i2=3} {i1>>i2} {-4}
# test_expr expr-1.46d {i1=-32, i2=100} {i1>>i2} {-1}
# test_expr expr-1.46e {i1=32, i2=-3} {i1>>i2} {256}
# test_expr expr-1.47 {i1=9999999999, i2=8888888888} {i1<i2} 0
# test_expr expr-1.48 {i1=9999999999, i2=8888888888} {i1=i2} 0
# test_expr expr-1.49 {i1=9999999999, i2=8888888888} {i1>i2} 1
# test_expr expr-1.50 {i1=99999999999, i2=99999999998} {i1<i2} 0
# test_expr expr-1.51 {i1=99999999999, i2=99999999998} {i1=i2} 0
# test_expr expr-1.52 {i1=99999999999, i2=99999999998} {i1>i2} 1
# test_expr expr-1.53 {i1=099999999999, i2=99999999999} {i1<i2} 0
# test_expr expr-1.54 {i1=099999999999, i2=99999999999} {i1=i2} 1
# test_expr expr-1.55 {i1=099999999999, i2=99999999999} {i1>i2} 0
# test_expr expr-1.56 {i1=25, i2=11} {i1%i2} 3
# test_expr expr-1.58 {i1=NULL, i2=1} {coalesce(i1+i2,99)} 99
# test_expr expr-1.59 {i1=1, i2=NULL} {coalesce(i1+i2,99)} 99
# test_expr expr-1.60 {i1=NULL, i2=NULL} {coalesce(i1+i2,99)} 99
# test_expr expr-1.61 {i1=NULL, i2=1} {coalesce(i1-i2,99)} 99
# test_expr expr-1.62 {i1=1, i2=NULL} {coalesce(i1-i2,99)} 99
# test_expr expr-1.63 {i1=NULL, i2=NULL} {coalesce(i1-i2,99)} 99
# test_expr expr-1.64 {i1=NULL, i2=1} {coalesce(i1*i2,99)} 99
# test_expr expr-1.65 {i1=1, i2=NULL} {coalesce(i1*i2,99)} 99
# test_expr expr-1.66 {i1=NULL, i2=NULL} {coalesce(i1*i2,99)} 99
# test_expr expr-1.67 {i1=NULL, i2=1} {coalesce(i1/i2,99)} 99
# test_expr expr-1.68 {i1=1, i2=NULL} {coalesce(i1/i2,99)} 99
# test_expr expr-1.69 {i1=NULL, i2=NULL} {coalesce(i1/i2,99)} 99
# test_expr expr-1.70 {i1=NULL, i2=1} {coalesce(i1<i2,99)} 99
# test_expr expr-1.71 {i1=1, i2=NULL} {coalesce(i1>i2,99)} 99
# test_expr expr-1.72 {i1=NULL, i2=NULL} {coalesce(i1<=i2,99)} 99
# test_expr expr-1.73 {i1=NULL, i2=1} {coalesce(i1>=i2,99)} 99
# test_expr expr-1.74 {i1=1, i2=NULL} {coalesce(i1!=i2,99)} 99
# test_expr expr-1.75 {i1=NULL, i2=NULL} {coalesce(i1==i2,99)} 99
# test_expr expr-1.76 {i1=NULL, i2=NULL} {coalesce(not i1,99)} 99
# test_expr expr-1.77 {i1=NULL, i2=NULL} {coalesce(-i1,99)} 99
# test_expr expr-1.78 {i1=NULL, i2=NULL} {coalesce(i1 IS NULL AND i2=5,99)} 99
# test_expr expr-1.79 {i1=NULL, i2=NULL} {coalesce(i1 IS NULL OR i2=5,99)} 1
# test_expr expr-1.80 {i1=NULL, i2=NULL} {coalesce(i1=5 AND i2 IS NULL,99)} 99
# test_expr expr-1.81 {i1=NULL, i2=NULL} {coalesce(i1=5 OR i2 IS NULL,99)} 1
# test_expr expr-1.82 {i1=NULL, i2=3} {coalesce(min(i1,i2,1),99)} 99
# test_expr expr-1.83 {i1=NULL, i2=3} {coalesce(max(i1,i2,1),99)} 99
# test_expr expr-1.84 {i1=3, i2=NULL} {coalesce(min(i1,i2,1),99)} 99
# test_expr expr-1.85 {i1=3, i2=NULL} {coalesce(max(i1,i2,1),99)} 99
# test_expr expr-1.86 {i1=3, i2=8} {5 between i1 and i2} 1
# test_expr expr-1.87 {i1=3, i2=8} {5 not between i1 and i2} 0
# test_expr expr-1.88 {i1=3, i2=8} {55 between i1 and i2} 0
# test_expr expr-1.89 {i1=3, i2=8} {55 not between i1 and i2} 1
# test_expr expr-1.90 {i1=3, i2=NULL} {5 between i1 and i2} {{}}
# test_expr expr-1.91 {i1=3, i2=NULL} {5 not between i1 and i2} {{}}
# test_expr expr-1.92 {i1=3, i2=NULL} {2 between i1 and i2} 0
# test_expr expr-1.93 {i1=3, i2=NULL} {2 not between i1 and i2} 1
# test_expr expr-1.94 {i1=NULL, i2=8} {2 between i1 and i2} {{}}
# test_expr expr-1.95 {i1=NULL, i2=8} {2 not between i1 and i2} {{}}
# test_expr expr-1.94 {i1=NULL, i2=8} {55 between i1 and i2} 0
# test_expr expr-1.95 {i1=NULL, i2=8} {55 not between i1 and i2} 1
# test_expr expr-1.96 {i1=NULL, i2=3} {coalesce(i1<<i2,99)} 99
# test_expr expr-1.97 {i1=32, i2=NULL} {coalesce(i1>>i2,99)} 99
# test_expr expr-1.98 {i1=NULL, i2=NULL} {coalesce(i1|i2,99)} 99
# test_expr expr-1.99 {i1=32, i2=NULL} {coalesce(i1&i2,99)} 99
# test_expr expr-1.100 {i1=1, i2=''} {i1=i2} 0
# test_expr expr-1.101 {i1=0, i2=''} {i1=i2} 0

# # Check for proper handling of 64-bit integer values.
# #
# if {[working_64bit_int]} {
#   test_expr expr-1.102 {i1=40, i2=1} {i2<<i1} 1099511627776
# }

# ifcapable floatingpoint {
#   test_expr expr-1.103 {i1=0} {(-2147483648.0 % -1)} 0.0
#   test_expr expr-1.104 {i1=0} {(-9223372036854775808.0 % -1)} 0.0
#   test_expr expr-1.105 {i1=0} {(-9223372036854775808.0 / -1)>1} 1
# }

# if {[working_64bit_int]} {
#   test_realnum_expr expr-1.106 {i1=0} {-9223372036854775808/-1} 9.22337203685478e+18
# }

# test_expr expr-1.107 {i1=0} {-9223372036854775808%-1} 0
# test_expr expr-1.108 {i1=0} {1%0} {{}}
# test_expr expr-1.109 {i1=0} {1/0} {{}}

# if {[working_64bit_int]} {
#   test_expr expr-1.110 {i1=0} {-9223372036854775807/-1} 9223372036854775807
# }

# test_expr expr-1.111 {i1=NULL, i2=8} {i1 IS i2} 0
# test_expr expr-1.112 {i1=NULL, i2=NULL} {i1 IS i2} 1
# test_expr expr-1.113 {i1=6, i2=NULL} {i1 IS i2} 0
# test_expr expr-1.114 {i1=6, i2=6} {i1 IS i2} 1
# test_expr expr-1.115 {i1=NULL, i2=8} \
#   {CASE WHEN i1 IS i2 THEN 'yes' ELSE 'no' END} no
# test_expr expr-1.116 {i1=NULL, i2=NULL} \
#   {CASE WHEN i1 IS i2 THEN 'yes' ELSE 'no' END} yes
# test_expr expr-1.117 {i1=6, i2=NULL} \
#   {CASE WHEN i1 IS i2 THEN 'yes' ELSE 'no' END} no
# test_expr expr-1.118 {i1=8, i2=8} \
#   {CASE WHEN i1 IS i2 THEN 'yes' ELSE 'no' END} yes
# test_expr expr-1.119 {i1=NULL, i2=8} {i1 IS NOT i2} 1
# test_expr expr-1.120 {i1=NULL, i2=NULL} {i1 IS NOT i2} 0
# test_expr expr-1.121 {i1=6, i2=NULL} {i1 IS NOT i2} 1
# test_expr expr-1.122 {i1=6, i2=6} {i1 IS NOT i2} 0
# test_expr expr-1.123 {i1=NULL, i2=8} \
#   {CASE WHEN i1 IS NOT i2 THEN 'yes' ELSE 'no' END} yes
# test_expr expr-1.124 {i1=NULL, i2=NULL} \
#   {CASE WHEN i1 IS NOT i2 THEN 'yes' ELSE 'no' END} no
# test_expr expr-1.125 {i1=6, i2=NULL} \
#   {CASE WHEN i1 IS NOT i2 THEN 'yes' ELSE 'no' END} yes
# test_expr expr-1.126 {i1=8, i2=8} \
#   {CASE WHEN i1 IS NOT i2 THEN 'yes' ELSE 'no' END} no

# do_catchsql_test expr-1.127 {
#   SELECT 1 IS #1;
# } {1 {near "#1": syntax error}}

# ifcapable floatingpoint {if {[working_64bit_int]} {
#   test_expr expr-1.200\
#       {i1=9223372036854775806, i2=1} {i1+i2}      9223372036854775807
#   test_realnum_expr expr-1.201\
#       {i1=9223372036854775806, i2=2} {i1+i2}      9.22337203685478e+18
#   test_realnum_expr expr-1.202\
#       {i1=9223372036854775806, i2=100000} {i1+i2} 9.22337203685488e+18
#   test_realnum_expr expr-1.203\
#       {i1=9223372036854775807, i2=0} {i1+i2}      9223372036854775807
#   test_realnum_expr expr-1.204\
#       {i1=9223372036854775807, i2=1} {i1+i2}      9.22337203685478e+18
#   test_realnum_expr expr-1.205\
#       {i2=9223372036854775806, i1=1} {i1+i2}      9223372036854775807
#   test_realnum_expr expr-1.206\
#       {i2=9223372036854775806, i1=2} {i1+i2}      9.22337203685478e+18
#   test_realnum_expr expr-1.207\
#       {i2=9223372036854775806, i1=100000} {i1+i2} 9.22337203685488e+18
#   test_realnum_expr expr-1.208\
#       {i2=9223372036854775807, i1=0} {i1+i2}      9223372036854775807
#   test_realnum_expr expr-1.209\
#       {i2=9223372036854775807, i1=1} {i1+i2}      9.22337203685478e+18
#   test_realnum_expr expr-1.210\
#       {i1=-9223372036854775807, i2=-1} {i1+i2}    -9223372036854775808
#   test_realnum_expr expr-1.211\
#       {i1=-9223372036854775807, i2=-2} {i1+i2}    -9.22337203685478e+18
#   test_realnum_expr expr-1.212\
#       {i1=-9223372036854775807, i2=-100000} {i1+i2} -9.22337203685488e+18
#   test_realnum_expr expr-1.213\
#       {i1=-9223372036854775808, i2=0} {i1+i2}     -9223372036854775808
#   test_realnum_expr expr-1.214\
#       {i1=-9223372036854775808, i2=-1} {i1+i2}    -9.22337203685478e+18
#   test_realnum_expr expr-1.215\
#       {i2=-9223372036854775807, i1=-1} {i1+i2}    -9223372036854775808
#   test_realnum_expr expr-1.216\
#       {i2=-9223372036854775807, i1=-2} {i1+i2}    -9.22337203685478e+18
#   test_realnum_expr expr-1.217\
#       {i2=-9223372036854775807, i1=-100000} {i1+i2} -9.22337203685488e+18
#   test_realnum_expr expr-1.218\
#       {i2=-9223372036854775808, i1=0} {i1+i2}     -9223372036854775808
#   test_realnum_expr expr-1.219\
#       {i2=-9223372036854775808, i1=-1} {i1+i2}    -9.22337203685478e+18
#   test_realnum_expr expr-1.220\
#       {i1=9223372036854775806, i2=-1} {i1-i2}     9223372036854775807
#   test_realnum_expr expr-1.221\
#       {i1=9223372036854775806, i2=-2} {i1-i2}      9.22337203685478e+18
#   test_realnum_expr expr-1.222\
#       {i1=9223372036854775806, i2=-100000} {i1-i2} 9.22337203685488e+18
#   test_realnum_expr expr-1.223\
#       {i1=9223372036854775807, i2=0} {i1-i2}      9223372036854775807
#   test_realnum_expr expr-1.224\
#       {i1=9223372036854775807, i2=-1} {i1-i2}      9.22337203685478e+18
#   test_realnum_expr expr-1.225\
#       {i2=-9223372036854775806, i1=1} {i1-i2}      9223372036854775807
#   test_realnum_expr expr-1.226\
#       {i2=-9223372036854775806, i1=2} {i1-i2}      9.22337203685478e+18
#   test_realnum_expr expr-1.227\
#       {i2=-9223372036854775806, i1=100000} {i1-i2} 9.22337203685488e+18
#   test_realnum_expr expr-1.228\
#       {i2=-9223372036854775807, i1=0} {i1-i2}      9223372036854775807
#   test_realnum_expr expr-1.229\
#       {i2=-9223372036854775807, i1=1} {i1-i2}      9.22337203685478e+18
#   test_realnum_expr expr-1.230\
#       {i1=-9223372036854775807, i2=1} {i1-i2}    -9223372036854775808
#   test_realnum_expr expr-1.231\
#       {i1=-9223372036854775807, i2=2} {i1-i2}    -9.22337203685478e+18
#   test_realnum_expr expr-1.232\
#       {i1=-9223372036854775807, i2=100000} {i1-i2} -9.22337203685488e+18
#   test_realnum_expr expr-1.233\
#       {i1=-9223372036854775808, i2=0} {i1-i2}     -9223372036854775808
#   test_realnum_expr expr-1.234\
#       {i1=-9223372036854775808, i2=1} {i1-i2}    -9.22337203685478e+18
#   test_realnum_expr expr-1.235\
#       {i2=9223372036854775807, i1=-1} {i1-i2}    -9223372036854775808
#   test_realnum_expr expr-1.236\
#       {i2=9223372036854775807, i1=-2} {i1-i2}    -9.22337203685478e+18
#   test_realnum_expr expr-1.237\
#       {i2=9223372036854775807, i1=-100000} {i1-i2} -9.22337203685488e+18
#   test_realnum_expr expr-1.238\
#       {i2=9223372036854775807, i1=0} {i1-i2}     -9223372036854775807
#   test_realnum_expr expr-1.239\
#       {i2=9223372036854775807, i1=-1} {i1-i2}    -9223372036854775808

#   test_realnum_expr expr-1.250\
#       {i1=4294967296, i2=2147483648} {i1*i2}      9.22337203685478e+18
#   test_realnum_expr expr-1.251\
#       {i1=4294967296, i2=2147483647} {i1*i2}      9223372032559808512
#   test_realnum_expr expr-1.252\
#       {i1=-4294967296, i2=2147483648} {i1*i2}     -9223372036854775808
#   test_realnum_expr expr-1.253\
#       {i1=-4294967296, i2=2147483647} {i1*i2}     -9223372032559808512
#   test_realnum_expr expr-1.254\
#       {i1=4294967296, i2=-2147483648} {i1*i2}     -9223372036854775808
#   test_realnum_expr expr-1.255\
#       {i1=4294967296, i2=-2147483647} {i1*i2}     -9223372032559808512
#   test_realnum_expr expr-1.256\
#       {i1=-4294967296, i2=-2147483648} {i1*i2}    9.22337203685478e+18
#   test_realnum_expr expr-1.257\
#       {i1=-4294967296, i2=-2147483647} {i1*i2}    9223372032559808512

# }}

# ifcapable floatingpoint {
#   test_expr expr-2.1 {r1=1.23, r2=2.34} {r1+r2} 3.57
#   test_expr expr-2.2 {r1=1.23, r2=2.34} {r1-r2} -1.11
#   test_expr expr-2.3 {r1=1.23, r2=2.34} {r1*r2} 2.8782
# }
# set tcl_precision 15
# ifcapable floatingpoint {
#   test_expr expr-2.4 {r1=1.23, r2=2.34} {r1/r2} 0.525641025641026
#   test_expr expr-2.5 {r1=1.23, r2=2.34} {r2/r1} 1.90243902439024
#   test_expr expr-2.6 {r1=1.23, r2=2.34} {r2<r1} 0
#   test_expr expr-2.7 {r1=1.23, r2=2.34} {r2<=r1} 0
#   test_expr expr-2.8 {r1=1.23, r2=2.34} {r2>r1} 1
#   test_expr expr-2.9 {r1=1.23, r2=2.34} {r2>=r1} 1
#   test_expr expr-2.10 {r1=1.23, r2=2.34} {r2!=r1} 1
#   test_expr expr-2.11 {r1=1.23, r2=2.34} {r2=r1} 0
#   test_expr expr-2.12 {r1=1.23, r2=2.34} {r2<>r1} 1
#   test_expr expr-2.13 {r1=1.23, r2=2.34} {r2==r1} 0
#   test_expr expr-2.14 {r1=2.34, r2=2.34} {r2<r1} 0
#   test_expr expr-2.15 {r1=2.34, r2=2.34} {r2<=r1} 1
#   test_expr expr-2.16 {r1=2.34, r2=2.34} {r2>r1} 0
#   test_expr expr-2.17 {r1=2.34, r2=2.34} {r2>=r1} 1
#   test_expr expr-2.18 {r1=2.34, r2=2.34} {r2!=r1} 0
#   test_expr expr-2.19 {r1=2.34, r2=2.34} {r2=r1} 1
#   test_expr expr-2.20 {r1=2.34, r2=2.34} {r2<>r1} 0
#   test_expr expr-2.21 {r1=2.34, r2=2.34} {r2==r1} 1
#   test_expr expr-2.22 {r1=1.23, r2=2.34} {min(r1,r2,r1+r2,r1-r2)} {-1.11}
#   test_expr expr-2.23 {r1=1.23, r2=2.34} {max(r1,r2,r1+r2,r1-r2)} {3.57}
#   test_expr expr-2.24 {r1=25.0, r2=11.0} {r1%r2} 3.0
#   test_expr expr-2.25 {r1=1.23, r2=NULL} {coalesce(r1+r2,99.0)} 99.0
#   test_expr expr-2.26 {r1=1e300, r2=1e300} {coalesce((r1*r2)*0.0,99.0)} 99.0
#   test_expr expr-2.26b {r1=1e300, r2=-1e300} {coalesce((r1*r2)*0.0,99.0)} 99.0
#   test_expr expr-2.27 {r1=1.1, r2=0.0} {r1/r2} {{}}
#   test_expr expr-2.28 {r1=1.1, r2=0.0} {r1%r2} {{}}
# }

# test_expr expr-3.1 {t1='abc', t2='xyz'} {t1<t2} 1
# test_expr expr-3.2 {t1='xyz', t2='abc'} {t1<t2} 0
# test_expr expr-3.3 {t1='abc', t2='abc'} {t1<t2} 0
# test_expr expr-3.4 {t1='abc', t2='xyz'} {t1<=t2} 1
# test_expr expr-3.5 {t1='xyz', t2='abc'} {t1<=t2} 0
# test_expr expr-3.6 {t1='abc', t2='abc'} {t1<=t2} 1
# test_expr expr-3.7 {t1='abc', t2='xyz'} {t1>t2} 0
# test_expr expr-3.8 {t1='xyz', t2='abc'} {t1>t2} 1
# test_expr expr-3.9 {t1='abc', t2='abc'} {t1>t2} 0
# test_expr expr-3.10 {t1='abc', t2='xyz'} {t1>=t2} 0
# test_expr expr-3.11 {t1='xyz', t2='abc'} {t1>=t2} 1
# test_expr expr-3.12 {t1='abc', t2='abc'} {t1>=t2} 1
# test_expr expr-3.13 {t1='abc', t2='xyz'} {t1=t2} 0
# test_expr expr-3.14 {t1='xyz', t2='abc'} {t1=t2} 0
# test_expr expr-3.15 {t1='abc', t2='abc'} {t1=t2} 1
# test_expr expr-3.16 {t1='abc', t2='xyz'} {t1==t2} 0
# test_expr expr-3.17 {t1='xyz', t2='abc'} {t1==t2} 0
# test_expr expr-3.18 {t1='abc', t2='abc'} {t1==t2} 1
# test_expr expr-3.19 {t1='abc', t2='xyz'} {t1<>t2} 1
# test_expr expr-3.20 {t1='xyz', t2='abc'} {t1<>t2} 1
# test_expr expr-3.21 {t1='abc', t2='abc'} {t1<>t2} 0
# test_expr expr-3.22 {t1='abc', t2='xyz'} {t1!=t2} 1
# test_expr expr-3.23 {t1='xyz', t2='abc'} {t1!=t2} 1
# test_expr expr-3.24 {t1='abc', t2='abc'} {t1!=t2} 0
# test_expr expr-3.25 {t1=NULL, t2='hi'} {t1 isnull} 1
# test_expr expr-3.25b {t1=NULL, t2='hi'} {t1 is null} 1
# test_expr expr-3.26 {t1=NULL, t2='hi'} {t2 isnull} 0
# test_expr expr-3.27 {t1=NULL, t2='hi'} {t1 notnull} 0
# test_expr expr-3.28 {t1=NULL, t2='hi'} {t2 notnull} 1
# test_expr expr-3.28b {t1=NULL, t2='hi'} {t2 is not null} 1
# test_expr expr-3.29 {t1='xyz', t2='abc'} {t1||t2} {xyzabc}
# test_expr expr-3.30 {t1=NULL, t2='abc'} {t1||t2} {{}}
# test_expr expr-3.31 {t1='xyz', t2=NULL} {t1||t2} {{}}
# test_expr expr-3.32 {t1='xyz', t2='abc'} {t1||' hi '||t2} {{xyz hi abc}}
# test_expr epxr-3.33 {t1='abc', t2=NULL} {coalesce(t1<t2,99)} 99
# test_expr epxr-3.34 {t1='abc', t2=NULL} {coalesce(t2<t1,99)} 99
# test_expr epxr-3.35 {t1='abc', t2=NULL} {coalesce(t1>t2,99)} 99
# test_expr epxr-3.36 {t1='abc', t2=NULL} {coalesce(t2>t1,99)} 99
# test_expr epxr-3.37 {t1='abc', t2=NULL} {coalesce(t1<=t2,99)} 99
# test_expr epxr-3.38 {t1='abc', t2=NULL} {coalesce(t2<=t1,99)} 99
# test_expr epxr-3.39 {t1='abc', t2=NULL} {coalesce(t1>=t2,99)} 99
# test_expr epxr-3.40 {t1='abc', t2=NULL} {coalesce(t2>=t1,99)} 99
# test_expr epxr-3.41 {t1='abc', t2=NULL} {coalesce(t1==t2,99)} 99
# test_expr epxr-3.42 {t1='abc', t2=NULL} {coalesce(t2==t1,99)} 99
# test_expr epxr-3.43 {t1='abc', t2=NULL} {coalesce(t1!=t2,99)} 99
# test_expr epxr-3.44 {t1='abc', t2=NULL} {coalesce(t2!=t1,99)} 99

# test_expr expr-4.1 {t1='abc', t2='Abc'} {t1<t2} 0
# test_expr expr-4.2 {t1='abc', t2='Abc'} {t1>t2} 1
# test_expr expr-4.3 {t1='abc', t2='Bbc'} {t1<t2} 0
# test_expr expr-4.4 {t1='abc', t2='Bbc'} {t1>t2} 1
# test_expr expr-4.5 {t1='0', t2='0.0'} {t1==t2} 0
# test_expr expr-4.6 {t1='0.000', t2='0.0'} {t1==t2} 0
# test_expr expr-4.7 {t1=' 0.000', t2=' 0.0'} {t1==t2} 0
# test_expr expr-4.8 {t1='0.0', t2='abc'} {t1<t2} 1
# test_expr expr-4.9 {t1='0.0', t2='abc'} {t1==t2} 0

# ifcapable floatingpoint {
#   test_expr expr-4.10 {r1='0.0', r2='abc'} {r1>r2} 0
#   test_expr expr-4.11 {r1='abc', r2='Abc'} {r1<r2} 0
#   test_expr expr-4.12 {r1='abc', r2='Abc'} {r1>r2} 1
#   test_expr expr-4.13 {r1='abc', r2='Bbc'} {r1<r2} 0
#   test_expr expr-4.14 {r1='abc', r2='Bbc'} {r1>r2} 1
#   test_expr expr-4.15 {r1='0', r2='0.0'} {r1==r2} 1
#   test_expr expr-4.16 {r1='0.000', r2='0.0'} {r1==r2} 1
#   test_expr expr-4.17 {r1=' 0.000', r2=' 0.0'} {r1==r2} 1
#   test_expr expr-4.18 {r1='0.0', r2='abc'} {r1<r2} 1
#   test_expr expr-4.19 {r1='0.0', r2='abc'} {r1==r2} 0
#   test_expr expr-4.20 {r1='0.0', r2='abc'} {r1>r2} 0
# }

# # CSL is true if LIKE is case sensitive and false if not.
# # NCSL is the opposite.  Use these variables as the result
# # on operations where case makes a difference.
# set CSL $sqlite_options(casesensitivelike)
# set NCSL [expr {!$CSL}]

# test_expr expr-5.1 {t1='abc', t2='xyz'} {t1 LIKE t2} 0
# test_expr expr-5.2a {t1='abc', t2='abc'} {t1 LIKE t2} 1
# test_expr expr-5.2b {t1='abc', t2='ABC'} {t1 LIKE t2} $NCSL
# test_expr expr-5.3a {t1='abc', t2='a_c'} {t1 LIKE t2} 1
# test_expr expr-5.3b {t1='abc', t2='A_C'} {t1 LIKE t2} $NCSL
# test_expr expr-5.4 {t1='abc', t2='abc_'} {t1 LIKE t2} 0
# test_expr expr-5.5a {t1='abc', t2='a%c'} {t1 LIKE t2} 1
# test_expr expr-5.5b {t1='abc', t2='A%C'} {t1 LIKE t2} $NCSL
# test_expr expr-5.5c {t1='abdc', t2='a%c'} {t1 LIKE t2} 1
# test_expr expr-5.5d {t1='ac', t2='a%c'} {t1 LIKE t2} 1
# test_expr expr-5.5e {t1='ac', t2='A%C'} {t1 LIKE t2} $NCSL
# test_expr expr-5.6a {t1='abxyzzyc', t2='a%c'} {t1 LIKE t2} 1
# test_expr expr-5.6b {t1='abxyzzyc', t2='A%C'} {t1 LIKE t2} $NCSL
# test_expr expr-5.7a {t1='abxyzzy', t2='a%c'} {t1 LIKE t2} 0
# test_expr expr-5.7b {t1='abxyzzy', t2='A%C'} {t1 LIKE t2} 0
# test_expr expr-5.8a {t1='abxyzzycx', t2='a%c'} {t1 LIKE t2} 0
# test_expr expr-5.8b {t1='abxyzzycy', t2='a%cx'} {t1 LIKE t2} 0
# test_expr expr-5.8c {t1='abxyzzycx', t2='A%C'} {t1 LIKE t2} 0
# test_expr expr-5.8d {t1='abxyzzycy', t2='A%CX'} {t1 LIKE t2} 0
# test_expr expr-5.9a {t1='abc', t2='a%_c'} {t1 LIKE t2} 1
# test_expr expr-5.9b {t1='ac', t2='a%_c'} {t1 LIKE t2} 0
# test_expr expr-5.9c {t1='abc', t2='A%_C'} {t1 LIKE t2} $NCSL
# test_expr expr-5.9d {t1='ac', t2='A%_C'} {t1 LIKE t2} 0
# test_expr expr-5.10a {t1='abxyzzyc', t2='a%_c'} {t1 LIKE t2} 1
# test_expr expr-5.10b {t1='abxyzzyc', t2='A%_C'} {t1 LIKE t2} $NCSL
# test_expr expr-5.11 {t1='abc', t2='xyz'} {t1 NOT LIKE t2} 1
# test_expr expr-5.12a {t1='abc', t2='abc'} {t1 NOT LIKE t2} 0
# test_expr expr-5.12b {t1='abc', t2='ABC'} {t1 NOT LIKE t2} $CSL
# test_expr expr-5.13  {t1='A'}  {t1 LIKE 'A%_'} 0
# test_expr expr-5.14  {t1='AB'} {t1 LIKE 'A%b' ESCAPE 'b'} 0

# # The following tests only work on versions of TCL that support Unicode
# #
# if {"\u1234"!="u1234"} {
#   test_expr expr-5.13a "t1='a\u0080c', t2='a_c'" {t1 LIKE t2} 1
#   test_expr expr-5.13b "t1='a\u0080c', t2='A_C'" {t1 LIKE t2} $NCSL
#   test_expr expr-5.14a "t1='a\u07FFc', t2='a_c'" {t1 LIKE t2} 1
#   test_expr expr-5.14b "t1='a\u07FFc', t2='A_C'" {t1 LIKE t2} $NCSL
#   test_expr expr-5.15a "t1='a\u0800c', t2='a_c'" {t1 LIKE t2} 1
#   test_expr expr-5.15b "t1='a\u0800c', t2='A_C'" {t1 LIKE t2} $NCSL
#   test_expr expr-5.16a "t1='a\uFFFFc', t2='a_c'" {t1 LIKE t2} 1
#   test_expr expr-5.16b "t1='a\uFFFFc', t2='A_C'" {t1 LIKE t2} $NCSL
#   test_expr expr-5.17 "t1='a\u0080', t2='A__'" {t1 LIKE t2} 0
#   test_expr expr-5.18 "t1='a\u07FF', t2='A__'" {t1 LIKE t2} 0
#   test_expr expr-5.19 "t1='a\u0800', t2='A__'" {t1 LIKE t2} 0
#   test_expr expr-5.20 "t1='a\uFFFF', t2='A__'" {t1 LIKE t2} 0
#   test_expr expr-5.21a "t1='ax\uABCD', t2='a_\uABCD'" {t1 LIKE t2} 1
#   test_expr expr-5.21b "t1='ax\uABCD', t2='A_\uABCD'" {t1 LIKE t2} $NCSL
#   test_expr expr-5.22a "t1='ax\u1234', t2='a%\u1234'" {t1 LIKE t2} 1
#   test_expr expr-5.22b "t1='ax\u1234', t2='A%\u1234'" {t1 LIKE t2} $NCSL
#   test_expr expr-5.23a "t1='ax\uFEDC', t2='a_%'" {t1 LIKE t2} 1
#   test_expr expr-5.23b "t1='ax\uFEDC', t2='A_%'" {t1 LIKE t2} $NCSL
#   test_expr expr-5.24a "t1='ax\uFEDCy\uFEDC', t2='a%\uFEDC'" {t1 LIKE t2} 1
#   test_expr expr-5.24b "t1='ax\uFEDCy\uFEDC', t2='A%\uFEDC'" {t1 LIKE t2} $NCSL
# }

# test_expr expr-5.54 {t1='abc', t2=NULL} {t1 LIKE t2} {{}}
# test_expr expr-5.55 {t1='abc', t2=NULL} {t1 NOT LIKE t2} {{}}
# test_expr expr-5.56 {t1='abc', t2=NULL} {t2 LIKE t1} {{}}
# test_expr expr-5.57 {t1='abc', t2=NULL} {t2 NOT LIKE t1} {{}}

# # LIKE expressions that use ESCAPE characters.
# test_expr expr-5.58a {t1='abc', t2='a_c'}   {t1 LIKE t2 ESCAPE '7'} 1
# test_expr expr-5.58b {t1='abc', t2='A_C'}   {t1 LIKE t2 ESCAPE '7'} $NCSL
# test_expr expr-5.59a {t1='a_c', t2='a7_c'}  {t1 LIKE t2 ESCAPE '7'} 1
# test_expr expr-5.59b {t1='a_c', t2='A7_C'}  {t1 LIKE t2 ESCAPE '7'} $NCSL
# test_expr expr-5.60a {t1='abc', t2='a7_c'}  {t1 LIKE t2 ESCAPE '7'} 0
# test_expr expr-5.60b {t1='abc', t2='A7_C'}  {t1 LIKE t2 ESCAPE '7'} 0
# test_expr expr-5.61a {t1='a7Xc', t2='a7_c'} {t1 LIKE t2 ESCAPE '7'} 0
# test_expr expr-5.61b {t1='a7Xc', t2='A7_C'} {t1 LIKE t2 ESCAPE '7'} 0
# test_expr expr-5.62a {t1='abcde', t2='a%e'} {t1 LIKE t2 ESCAPE '7'} 1
# test_expr expr-5.62b {t1='abcde', t2='A%E'} {t1 LIKE t2 ESCAPE '7'} $NCSL
# test_expr expr-5.63a {t1='abcde', t2='a7%e'} {t1 LIKE t2 ESCAPE '7'} 0
# test_expr expr-5.63b {t1='abcde', t2='A7%E'} {t1 LIKE t2 ESCAPE '7'} 0
# test_expr expr-5.64a {t1='a7cde', t2='a7%e'} {t1 LIKE t2 ESCAPE '7'} 0
# test_expr expr-5.64b {t1='a7cde', t2='A7%E'} {t1 LIKE t2 ESCAPE '7'} 0
# test_expr expr-5.65a {t1='a7cde', t2='a77%e'} {t1 LIKE t2 ESCAPE '7'} 1
# test_expr expr-5.65b {t1='a7cde', t2='A77%E'} {t1 LIKE t2 ESCAPE '7'} $NCSL
# test_expr expr-5.66a {t1='abc7', t2='a%77'} {t1 LIKE t2 ESCAPE '7'} 1
# test_expr expr-5.66b {t1='abc7', t2='A%77'} {t1 LIKE t2 ESCAPE '7'} $NCSL
# test_expr expr-5.67a {t1='abc_', t2='a%7_'} {t1 LIKE t2 ESCAPE '7'} 1
# test_expr expr-5.67b {t1='abc_', t2='A%7_'} {t1 LIKE t2 ESCAPE '7'} $NCSL
# test_expr expr-5.68a {t1='abc7', t2='a%7_'} {t1 LIKE t2 ESCAPE '7'} 0
# test_expr expr-5.68b {t1='abc7', t2='A%7_'} {t1 LIKE t2 ESCAPE '7'} 0

# # These are the same test as the block above, but using a multi-byte 
# # character as the escape character.
# if {"\u1234"!="u1234"} {
#   test_expr expr-5.69a "t1='abc', t2='a_c'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" 1
#   test_expr expr-5.69b "t1='abc', t2='A_C'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" $NCSL
#   test_expr expr-5.70a "t1='a_c', t2='a\u1234_c'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" 1
#   test_expr expr-5.70b "t1='a_c', t2='A\u1234_C'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" $NCSL
#   test_expr expr-5.71a "t1='abc', t2='a\u1234_c'" \
#        "t1 LIKE t2 ESCAPE '\u1234'" 0
#   test_expr expr-5.71b "t1='abc', t2='A\u1234_C'" \
#        "t1 LIKE t2 ESCAPE '\u1234'" 0
#   test_expr expr-5.72a "t1='a\u1234Xc', t2='a\u1234_c'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" 0
#   test_expr expr-5.72b "t1='a\u1234Xc', t2='A\u1234_C'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" 0
#   test_expr expr-5.73a "t1='abcde', t2='a%e'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" 1
#   test_expr expr-5.73b "t1='abcde', t2='A%E'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" $NCSL
#   test_expr expr-5.74a "t1='abcde', t2='a\u1234%e'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" 0
#   test_expr expr-5.74b "t1='abcde', t2='A\u1234%E'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" 0
#   test_expr expr-5.75a "t1='a\u1234cde', t2='a\u1234%e'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" 0
#   test_expr expr-5.75b "t1='a\u1234cde', t2='A\u1234%E'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" 0
#   test_expr expr-5.76a "t1='a\u1234cde', t2='a\u1234\u1234%e'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" 1
#   test_expr expr-5.76b "t1='a\u1234cde', t2='A\u1234\u1234%E'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" $NCSL
#   test_expr expr-5.77a "t1='abc\u1234', t2='a%\u1234\u1234'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" 1
#   test_expr expr-5.77b "t1='abc\u1234', t2='A%\u1234\u1234'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" $NCSL
#   test_expr expr-5.78a "t1='abc_', t2='a%\u1234_'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" 1
#   test_expr expr-5.78b "t1='abc_', t2='A%\u1234_'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" $NCSL
#   test_expr expr-5.79a "t1='abc\u1234', t2='a%\u1234_'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" 0
#   test_expr expr-5.79b "t1='abc\u1234', t2='A%\u1234_'" \
#       "t1 LIKE t2 ESCAPE '\u1234'" 0
# }

# test_expr expr-6.1 {t1='abc', t2='xyz'} {t1 GLOB t2} 0
# test_expr expr-6.2 {t1='abc', t2='ABC'} {t1 GLOB t2} 0
# test_expr expr-6.3 {t1='abc', t2='A?C'} {t1 GLOB t2} 0
# test_expr expr-6.4 {t1='abc', t2='a?c'} {t1 GLOB t2} 1
# test_expr expr-6.5 {t1='abc', t2='abc?'} {t1 GLOB t2} 0
# test_expr expr-6.6 {t1='abc', t2='A*C'} {t1 GLOB t2} 0
# test_expr expr-6.7 {t1='abc', t2='a*c'} {t1 GLOB t2} 1
# test_expr expr-6.8 {t1='abxyzzyc', t2='a*c'} {t1 GLOB t2} 1
# test_expr expr-6.9 {t1='abxyzzy', t2='a*c'} {t1 GLOB t2} 0
# test_expr expr-6.10 {t1='abxyzzycx', t2='a*c'} {t1 GLOB t2} 0
# test_expr expr-6.11 {t1='abc', t2='xyz'} {t1 NOT GLOB t2} 1
# test_expr expr-6.12 {t1='abc', t2='abc'} {t1 NOT GLOB t2} 0
# test_expr expr-6.13 {t1='abc', t2='a[bx]c'} {t1 GLOB t2} 1
# test_expr expr-6.14 {t1='abc', t2='a[cx]c'} {t1 GLOB t2} 0
# test_expr expr-6.15 {t1='abc', t2='a[a-d]c'} {t1 GLOB t2} 1
# test_expr expr-6.16 {t1='abc', t2='a[^a-d]c'} {t1 GLOB t2} 0
# test_expr expr-6.17 {t1='abc', t2='a[A-Dc]c'} {t1 GLOB t2} 0
# test_expr expr-6.18 {t1='abc', t2='a[^A-Dc]c'} {t1 GLOB t2} 1
# test_expr expr-6.19 {t1='abc', t2='a[]b]c'} {t1 GLOB t2} 1
# test_expr expr-6.20 {t1='abc', t2='a[^]b]c'} {t1 GLOB t2} 0
# test_expr expr-6.21a {t1='abcdefg', t2='a*[de]g'} {t1 GLOB t2} 0
# test_expr expr-6.21b {t1='abcdefg', t2='a*[df]g'} {t1 GLOB t2} 1
# test_expr expr-6.21c {t1='abcdefg', t2='a*[d-h]g'} {t1 GLOB t2} 1
# test_expr expr-6.21d {t1='abcdefg', t2='a*[b-e]g'} {t1 GLOB t2} 0
# test_expr expr-6.22a {t1='abcdefg', t2='a*[^de]g'} {t1 GLOB t2} 1
# test_expr expr-6.22b {t1='abcdefg', t2='a*[^def]g'} {t1 GLOB t2} 0
# test_expr expr-6.23 {t1='abcdefg', t2='a*?g'} {t1 GLOB t2} 1
# test_expr expr-6.24 {t1='ac', t2='a*c'} {t1 GLOB t2} 1
# test_expr expr-6.25 {t1='ac', t2='a*?c'} {t1 GLOB t2} 0
# test_expr expr-6.26 {t1='a*c', t2='a[*]c'} {t1 GLOB t2} 1
# test_expr expr-6.27 {t1='a?c', t2='a[?]c'} {t1 GLOB t2} 1
# test_expr expr-6.28 {t1='a[c', t2='a[[]c'} {t1 GLOB t2} 1


# # These tests only work on versions of TCL that support Unicode
# #
# if {"\u1234"!="u1234"} {
#   test_expr expr-6.26 "t1='a\u0080c', t2='a?c'" {t1 GLOB t2} 1
#   test_expr expr-6.27 "t1='a\u07ffc', t2='a?c'" {t1 GLOB t2} 1
#   test_expr expr-6.28 "t1='a\u0800c', t2='a?c'" {t1 GLOB t2} 1
#   test_expr expr-6.29 "t1='a\uffffc', t2='a?c'" {t1 GLOB t2} 1
#   test_expr expr-6.30 "t1='a\u1234', t2='a?'" {t1 GLOB t2} 1
#   test_expr expr-6.31 "t1='a\u1234', t2='a??'" {t1 GLOB t2} 0
#   test_expr expr-6.32 "t1='ax\u1234', t2='a?\u1234'" {t1 GLOB t2} 1
#   test_expr expr-6.33 "t1='ax\u1234', t2='a*\u1234'" {t1 GLOB t2} 1
#   test_expr expr-6.34 "t1='ax\u1234y\u1234', t2='a*\u1234'" {t1 GLOB t2} 1
#   test_expr expr-6.35 "t1='a\u1234b', t2='a\[x\u1234y\]b'" {t1 GLOB t2} 1
#   test_expr expr-6.36 "t1='a\u1234b', t2='a\[\u1233-\u1235\]b'" {t1 GLOB t2} 1
#   test_expr expr-6.37 "t1='a\u1234b', t2='a\[\u1234-\u124f\]b'" {t1 GLOB t2} 1
#   test_expr expr-6.38 "t1='a\u1234b', t2='a\[\u1235-\u124f\]b'" {t1 GLOB t2} 0
#   test_expr expr-6.39 "t1='a\u1234b', t2='a\[a-\u1235\]b'" {t1 GLOB t2} 1
#   test_expr expr-6.40 "t1='a\u1234b', t2='a\[a-\u1234\]b'" {t1 GLOB t2} 1
#   test_expr expr-6.41 "t1='a\u1234b', t2='a\[a-\u1233\]b'" {t1 GLOB t2} 0
# }

# test_expr expr-6.51 {t1='ABC', t2='xyz'} {t1 GLOB t2} 0
# test_expr expr-6.52 {t1='ABC', t2='abc'} {t1 GLOB t2} 0
# test_expr expr-6.53 {t1='ABC', t2='a?c'} {t1 GLOB t2} 0
# test_expr expr-6.54 {t1='ABC', t2='A?C'} {t1 GLOB t2} 1
# test_expr expr-6.55 {t1='ABC', t2='abc?'} {t1 GLOB t2} 0
# test_expr expr-6.56 {t1='ABC', t2='a*c'} {t1 GLOB t2} 0
# test_expr expr-6.57 {t1='ABC', t2='A*C'} {t1 GLOB t2} 1
# test_expr expr-6.58 {t1='ABxyzzyC', t2='A*C'} {t1 GLOB t2} 1
# test_expr expr-6.59 {t1='ABxyzzy', t2='A*C'} {t1 GLOB t2} 0
# test_expr expr-6.60 {t1='ABxyzzyCx', t2='A*C'} {t1 GLOB t2} 0
# test_expr expr-6.61 {t1='ABC', t2='xyz'} {t1 NOT GLOB t2} 1
# test_expr expr-6.62 {t1='ABC', t2='ABC'} {t1 NOT GLOB t2} 0
# test_expr expr-6.63 {t1='ABC', t2='A[Bx]C'} {t1 GLOB t2} 1
# test_expr expr-6.64 {t1='ABC', t2='A[Cx]C'} {t1 GLOB t2} 0
# test_expr expr-6.65 {t1='ABC', t2='A[A-D]C'} {t1 GLOB t2} 1
# test_expr expr-6.66 {t1='ABC', t2='A[^A-D]C'} {t1 GLOB t2} 0
# test_expr expr-6.67 {t1='ABC', t2='A[a-dC]C'} {t1 GLOB t2} 0
# test_expr expr-6.68 {t1='ABC', t2='A[^a-dC]C'} {t1 GLOB t2} 1
# test_expr expr-6.69a {t1='ABC', t2='A[]B]C'} {t1 GLOB t2} 1
# test_expr expr-6.69b {t1='A]C', t2='A[]B]C'} {t1 GLOB t2} 1
# test_expr expr-6.70a {t1='ABC', t2='A[^]B]C'} {t1 GLOB t2} 0
# test_expr expr-6.70b {t1='AxC', t2='A[^]B]C'} {t1 GLOB t2} 1
# test_expr expr-6.70c {t1='A]C', t2='A[^]B]C'} {t1 GLOB t2} 0
# test_expr expr-6.71 {t1='ABCDEFG', t2='A*[DE]G'} {t1 GLOB t2} 0
# test_expr expr-6.72 {t1='ABCDEFG', t2='A*[^DE]G'} {t1 GLOB t2} 1
# test_expr expr-6.73 {t1='ABCDEFG', t2='A*?G'} {t1 GLOB t2} 1
# test_expr expr-6.74 {t1='AC', t2='A*C'} {t1 GLOB t2} 1
# test_expr expr-6.75 {t1='AC', t2='A*?C'} {t1 GLOB t2} 0

# test_expr expr-6.63 {t1=NULL, t2='a*?c'} {t1 GLOB t2} {{}}
# test_expr expr-6.64 {t1='ac', t2=NULL} {t1 GLOB t2} {{}}
# test_expr expr-6.65 {t1=NULL, t2='a*?c'} {t1 NOT GLOB t2} {{}}
# test_expr expr-6.66 {t1='ac', t2=NULL} {t1 NOT GLOB t2} {{}}

# # Check that the affinity of a CAST expression is calculated correctly.
# ifcapable cast {
#   test_expr expr-6.67 {t1='01', t2=1} {t1 = t2} 0
#   test_expr expr-6.68 {t1='1', t2=1} {t1 = t2} 1
#   test_expr expr-6.69 {t1='01', t2=1} {CAST(t1 AS INTEGER) = t2} 1
# }

# test_expr expr-case.1 {i1=1, i2=2} \
# 	{CASE WHEN i1 = i2 THEN 'eq' ELSE 'ne' END} ne
# test_expr expr-case.2 {i1=2, i2=2} \
# 	{CASE WHEN i1 = i2 THEN 'eq' ELSE 'ne' END} eq
# test_expr expr-case.3 {i1=NULL, i2=2} \
# 	{CASE WHEN i1 = i2 THEN 'eq' ELSE 'ne' END} ne
# test_expr expr-case.4 {i1=2, i2=NULL} \
# 	{CASE WHEN i1 = i2 THEN 'eq' ELSE 'ne' END} ne
# test_expr expr-case.5 {i1=2} \
# 	{CASE i1 WHEN 1 THEN 'one' WHEN 2 THEN 'two' ELSE 'error' END} two
# test_expr expr-case.6 {i1=1} \
# 	{CASE i1 WHEN 1 THEN 'one' WHEN NULL THEN 'two' ELSE 'error' END} one
# test_expr expr-case.7 {i1=2} \
# 	{CASE i1 WHEN 1 THEN 'one' WHEN NULL THEN 'two' ELSE 'error' END} error
# test_expr expr-case.8 {i1=3} \
# 	{CASE i1 WHEN 1 THEN 'one' WHEN NULL THEN 'two' ELSE 'error' END} error
# test_expr expr-case.9 {i1=3} \
# 	{CASE i1 WHEN 1 THEN 'one' WHEN 2 THEN 'two' ELSE 'error' END} error
# test_expr expr-case.10 {i1=3} \
# 	{CASE i1 WHEN 1 THEN 'one' WHEN 2 THEN 'two' END} {{}}
# test_expr expr-case.11 {i1=null} \
# 	{CASE i1 WHEN 1 THEN 'one' WHEN 2 THEN 'two' ELSE 3 END} 3
# test_expr expr-case.12 {i1=1} \
# 	{CASE i1 WHEN 1 THEN null WHEN 2 THEN 'two' ELSE 3 END} {{}}
# test_expr expr-case.13 {i1=7} \
# 	{ CASE WHEN i1 < 5 THEN 'low' 
# 	       WHEN i1 < 10 THEN 'medium' 
#                WHEN i1 < 15 THEN 'high' ELSE 'error' END} medium


# # The sqliteExprIfFalse and sqliteExprIfTrue routines are only
# # executed as part of a WHERE clause.  Create a table suitable
# # for testing these functions.
# #
# execsql {DROP TABLE test1}
# execsql {CREATE TABLE test1(a int, b int);}
# for {set i 1} {$i<=20} {incr i} {
#   execsql "INSERT INTO test1 VALUES($i,[expr {1<<$i}])"
# }
# execsql "INSERT INTO test1 VALUES(NULL,0)"
# do_test expr-7.1 {
#   execsql {SELECT * FROM test1 ORDER BY a}
# } {{} 0 1 2 2 4 3 8 4 16 5 32 6 64 7 128 8 256 9 512 10 1024 11 2048 12 4096 13 8192 14 16384 15 32768 16 65536 17 131072 18 262144 19 524288 20 1048576}

# proc test_expr2 {name expr result} {
#   do_test $name [format {
#     execsql {SELECT a FROM test1 WHERE %s ORDER BY a}
#   } $expr] $result
# }

# test_expr2 expr-7.2  {a<10 AND a>8}                  {9}
# test_expr2 expr-7.3  {a<=10 AND a>=8}                {8 9 10}
# test_expr2 expr-7.4  {a>=8 AND a<=10}                {8 9 10}
# test_expr2 expr-7.5  {a>=20 OR a<=1}                 {1 20}
# test_expr2 expr-7.6  {b!=4 AND a<=3}                 {1 3}
# test_expr2 expr-7.7  {b==8 OR b==16 OR b==32}        {3 4 5}
# test_expr2 expr-7.8  {NOT b<>8 OR b==1024}           {3 10}
# test_expr2 expr-7.9  {b LIKE '10%'}                  {10 20}
# test_expr2 expr-7.10 {b LIKE '_4'}                   {6}
# test_expr2 expr-7.11 {a GLOB '1?'}            {10 11 12 13 14 15 16 17 18 19}
# test_expr2 expr-7.12 {b GLOB '1*4'}                  {10 14}
# test_expr2 expr-7.13 {b GLOB '*1[456]'}              {4}
# test_expr2 expr-7.14 {a ISNULL}                      {{}}
# test_expr2 expr-7.15 {a NOTNULL AND a<3}             {1 2}
# test_expr2 expr-7.16 {a AND a<3}                     {1 2}
# test_expr2 expr-7.17 {NOT a}                         {}
# test_expr2 expr-7.18 {a==11 OR (b>1000 AND b<2000)}  {10 11}
# test_expr2 expr-7.19 {a<=1 OR a>=20}                 {1 20}
# test_expr2 expr-7.20 {a<1 OR a>20}                   {}
# test_expr2 expr-7.21 {a>19 OR a<1}                   {20}
# test_expr2 expr-7.22 {a!=1 OR a=100} \
#                          {2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20}
# test_expr2 expr-7.23 {(a notnull AND a<4) OR a==8}   {1 2 3 8}
# test_expr2 expr-7.24 {a LIKE '2_' OR a==8}           {8 20}
# test_expr2 expr-7.25 {a GLOB '2?' OR a==8}           {8 20}
# test_expr2 expr-7.26 {a isnull OR a=8}               {{} 8}
# test_expr2 expr-7.27 {a notnull OR a=8} \
#                           {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20}
# test_expr2 expr-7.28 {a<0 OR b=0} {{}}
# test_expr2 expr-7.29 {b=0 OR a<0} {{}}
# test_expr2 expr-7.30 {a<0 AND b=0} {}
# test_expr2 expr-7.31 {b=0 AND a<0} {}
# test_expr2 expr-7.32 {a IS NULL AND (a<0 OR b=0)} {{}}
# test_expr2 expr-7.33 {a IS NULL AND (b=0 OR a<0)} {{}}
# test_expr2 expr-7.34 {a IS NULL AND (a<0 AND b=0)} {}
# test_expr2 expr-7.35 {a IS NULL AND (b=0 AND a<0)} {}
# test_expr2 expr-7.32 {(a<0 OR b=0) AND a IS NULL} {{}}
# test_expr2 expr-7.33 {(b=0 OR a<0) AND a IS NULL} {{}}
# test_expr2 expr-7.34 {(a<0 AND b=0) AND a IS NULL} {}
# test_expr2 expr-7.35 {(b=0 AND a<0) AND a IS NULL} {}
# test_expr2 expr-7.36 {a<2 OR (a<0 OR b=0)} {{} 1}
# test_expr2 expr-7.37 {a<2 OR (b=0 OR a<0)} {{} 1}
# test_expr2 expr-7.38 {a<2 OR (a<0 AND b=0)} {1}
# test_expr2 expr-7.39 {a<2 OR (b=0 AND a<0)} {1}
# ifcapable floatingpoint {
#   test_expr2 expr-7.40 {((a<2 OR a IS NULL) AND b<3) OR b>1e10} {{} 1}
# }
# test_expr2 expr-7.41 {a BETWEEN -1 AND 1} {1}
# test_expr2 expr-7.42 {a NOT BETWEEN 2 AND 100} {1}
# test_expr2 expr-7.43 {(b+1234)||'this is a string that is at least 32 characters long' BETWEEN 1 AND 2} {}
# test_expr2 expr-7.44 {123||'xabcdefghijklmnopqrstuvwyxz01234567890'||a BETWEEN '123a' AND '123b'} {}
# test_expr2 expr-7.45 {((123||'xabcdefghijklmnopqrstuvwyxz01234567890'||a) BETWEEN '123a' AND '123b')<0} {}
# test_expr2 expr-7.46 {((123||'xabcdefghijklmnopqrstuvwyxz01234567890'||a) BETWEEN '123a' AND '123z')>0} {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20}

# test_expr2 expr-7.50 {((a between 1 and 2 OR 0) AND 1) OR 0} {1 2}
# test_expr2 expr-7.51 {((a not between 3 and 100 OR 0) AND 1) OR 0} {1 2}

# ifcapable subquery {
#   test_expr2 expr-7.52 {((a in (1,2) OR 0) AND 1) OR 0} {1 2}
#   test_expr2 expr-7.53 \
#       {((a not in (3,4,5,6,7,8,9,10) OR 0) AND a<11) OR 0} {1 2}
# }
# test_expr2 expr-7.54 {((a>0 OR 0) AND a<3) OR 0} {1 2}
# ifcapable subquery {
#   test_expr2 expr-7.55 {((a in (1,2) OR 0) IS NULL AND 1) OR 0} {{}}
#   test_expr2 expr-7.56 \
#       {((a not in (3,4,5,6,7,8,9,10) IS NULL OR 0) AND 1) OR 0} {{}}
# }
# test_expr2 expr-7.57 {((a>0 IS NULL OR 0) AND 1) OR 0} {{}}

# test_expr2 expr-7.58  {(a||'')<='1'}                  {1}

# test_expr2 expr-7.59 {LIKE('10%',b)}                  {10 20}
# test_expr2 expr-7.60 {LIKE('_4',b)}                   {6}
# test_expr2 expr-7.61 {GLOB('1?',a)}            {10 11 12 13 14 15 16 17 18 19}
# test_expr2 expr-7.62 {GLOB('1*4',b)}                  {10 14}
# test_expr2 expr-7.63 {GLOB('*1[456]',b)}              {4}
# test_expr2 expr-7.64 {b = abs(-2)}                    {1}
# test_expr2 expr-7.65 {b = abs(+-2)}                   {1}
# test_expr2 expr-7.66 {b = abs(++-2)}                  {1}
# test_expr2 expr-7.67 {b = abs(+-+-2)}                 {1}
# test_expr2 expr-7.68 {b = abs(+-++-2)}                {1}
# test_expr2 expr-7.69 {b = abs(++++-2)}                {1}
# test_expr2 expr-7.70 {b = 5 - abs(+3)}                {1}
# test_expr2 expr-7.71 {b = 5 - abs(-3)}                {1}
# ifcapable floatingpoint {
#   test_expr2 expr-7.72 {b = abs(-2.0)}                  {1}
# }
# test_expr2 expr-7.73 {b = 6 - abs(-a)}                {2}
# ifcapable floatingpoint {
#   test_expr2 expr-7.74 {b = abs(8.0)}                   {3}
# }

# # Test the CURRENT_TIME, CURRENT_DATE, and CURRENT_TIMESTAMP expressions.
# #
# ifcapable {floatingpoint} {
#   set sqlite_current_time 1157124849
#   do_test expr-8.1 {
#     execsql {SELECT CURRENT_TIME}
#   } {15:34:09}
#   do_test expr-8.2 {
#     execsql {SELECT CURRENT_DATE}
#   } {2006-09-01}
#   do_test expr-8.3 {
#     execsql {SELECT CURRENT_TIMESTAMP}
#   } {{2006-09-01 15:34:09}}
# }
# ifcapable datetime {
#   do_test expr-8.4 {
#     execsql {SELECT CURRENT_TIME==time('now');}
#   } 1
#   do_test expr-8.5 {
#     execsql {SELECT CURRENT_DATE==date('now');}
#   } 1
#   do_test expr-8.6 {
#     execsql {SELECT CURRENT_TIMESTAMP==datetime('now');}
#   } 1
# }
# set sqlite_current_time 0

# ifcapable floatingpoint {
#   do_test expr-9.1 {
#     execsql {SELECT round(-('-'||'123'))}
#   } 123.0
# }

# # Test an error message that can be generated by the LIKE expression
# do_test expr-10.1 {
#   catchsql {SELECT 'abc' LIKE 'abc' ESCAPE ''}
# } {1 {ESCAPE expression must be a single character}}
# do_test expr-10.2 {
#   catchsql {SELECT 'abc' LIKE 'abc' ESCAPE 'ab'}
# } {1 {ESCAPE expression must be a single character}}

# # If we specify an integer constant that is bigger than the largest
# # possible integer, code the integer as a real number.
# #
# do_test expr-11.1 {
#   execsql {SELECT typeof(9223372036854775807)}
# } {integer}
# do_test expr-11.2 {
#   execsql {SELECT typeof(00000009223372036854775807)}
# } {integer}
# do_test expr-11.3 {
#   execsql {SELECT typeof(+9223372036854775807)}
# } {integer}
# do_test expr-11.4 {
#   execsql {SELECT typeof(+000000009223372036854775807)}
# } {integer}
# do_test expr-11.5 {
#   execsql {SELECT typeof(9223372036854775808)}
# } {real}
# do_test expr-11.6 {
#   execsql {SELECT typeof(00000009223372036854775808)}
# } {real}
# do_test expr-11.7 {
#   execsql {SELECT typeof(+9223372036854775808)}
# } {real}
# do_test expr-11.8 {
#   execsql {SELECT typeof(+0000009223372036854775808)}
# } {real}
# do_test expr-11.11 {
#   execsql {SELECT typeof(-9223372036854775808)}
# } {integer}
# do_test expr-11.12 {
#   execsql {SELECT typeof(-00000009223372036854775808)}
# } {integer}
# ifcapable floatingpoint {
#   do_test expr-11.13 {
#     execsql {SELECT typeof(-9223372036854775809)}
#   } {real}
#   do_test expr-11.14 {
#     execsql {SELECT typeof(-00000009223372036854775809)}
#   } {real}
# }

# # These two statements used to leak memory (because of missing %destructor
# # directives in parse.y).
# do_test expr-12.1 {
#   catchsql {
#     SELECT (CASE a>4 THEN 1 ELSE 0 END) FROM test1;
#   }
# } {1 {near "THEN": syntax error}}
# do_test expr-12.2 {
#   catchsql {
#     SELECT (CASE WHEN a>4 THEN 1 ELSE 0) FROM test1;
#   }
# } {1 {near ")": syntax error}}

# ifcapable floatingpoint {
#   do_realnum_test expr-13.1 {
#     execsql {
#       SELECT 12345678901234567890;
#     }
#   } {1.23456789012346e+19}
# }

# # Implicit String->Integer conversion is used when possible.
# #
# if {[working_64bit_int]} {
#   do_test expr-13.2 {
#     execsql {
#       SELECT 0+'9223372036854775807'
#     }
#   } {9223372036854775807}
#   do_test expr-13.3 {
#     execsql {
#       SELECT '9223372036854775807'+0
#     }
#   } {9223372036854775807}
# }

# # If the value is too large, use String->Float conversion.
# #
# ifcapable floatingpoint {
#   do_realnum_test expr-13.4 {
#     execsql {
#       SELECT 0+'9223372036854775808'
#     }
#   } {9.22337203685478e+18}
#   do_realnum_test expr-13.5 {
#     execsql {
#       SELECT '9223372036854775808'+0
#     }
#   } {9.22337203685478e+18}
# }

# # Use String->float conversion if the value is explicitly a floating
# # point value.
# #
# do_realnum_test expr-13.6 {
#   execsql {
#     SELECT 0+'9223372036854775807.0'
#   }
# } {9.22337203685478e+18}
# do_realnum_test expr-13.7 {
#   execsql {
#     SELECT '9223372036854775807.0'+0
#   }
# } {9.22337203685478e+18}

# do_execsql_test expr-13.8 {
#   SELECT "" <= '';
# } {1}
# do_execsql_test expr-13.9 {
#   SELECT '' <= "";
# } {1}



finish_test
