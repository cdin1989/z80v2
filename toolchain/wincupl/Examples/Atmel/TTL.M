/* Macro Library for some TTL devices */


/* Quadruple 2-input positive-NAND gates */

$MACRO TTLSN7400 P1 P2 P3 P4 P5 P6 P7 P8 P9 P10 P11 P12 P13 P14
P3 = !(P1 & P2);
P6 = !(P4 & P5);
P8 = !(P9 & P10);
P11 = !(P12 & P13);
$MEND


/* Quadruple 2-input positive-NOR gates */

$MACRO TTLSN7402 P1 P2 P3 P4 P5 P6 P7 P8 P9 P10 P11 P12 P13 P14
P3 = !(P1 # P2);
P6 = !(P4 # P5);
P8 = !(P9 # P10);
P11 = !(P12 # P13);
$MEND


/* Hex Inverters */

$MACRO TTLSN7404 P1 P2 P3 P4 P5 P6 P7 P8 P9 P10 P11 P12 P13 P14
P2 = !P1;
P4 = !P3;
P6 = !P5;
P8 = !P9;
P10 = !P11;
P12 = !P13;
$MEND


/* Quadruple 2-input positive-AND gates */

$MACRO TTLSN7408 P1 P2 P3 P4 P5 P6 P7 P8 P9 P10 P11 P12 P13 P14
P3 = P2 & P1;
P6 = P5 & P4;
P8 = P9 & P10;
P11 = P12 & P13;
$MEND


/* 4-wide AND-OR-INVERT gates */

$MACRO TTLSN7454 P1 P2 P3 P4 P5 P6 P7 P8 P9 P10 P11 P12 P13 P14
P8 = !(P2 & P3
     # P4 & P5
     # P9 & P10
     # P1 & P13);
$MEND


/* Dual D-type positive-edge-triggered flip-flops with Preset and Clear */

$MACRO TTLSN7474 P1 P2 P3 P4 P5 P6 P7 P8 P9 P10 P11 P12 P13 P14
P5.d = P2;
P5.ck = !P3;
P5.ar = !P1;
P5.ap = !P4;
P6 = !P2;
P9.d = P12;
P9.ck = !P11;
P9.ar = !P13;
P9.ap = !P10;
P8 = !P12;
$MEND

