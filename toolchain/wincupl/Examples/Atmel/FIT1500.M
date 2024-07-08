/* 
For Atmel-WinCUPL 4.7b or later

************** FIT1500.M - Fitting Options Atmel ATF1500 **************
In most designs, you do not need to use any of the Fitting Options.  If
your design is very complex and require some "tweaking" to get higher
logic utilization or performance, then the ATF1500 fitter options may
be used. 

How to use the ATF1500 Fitting Options:
--------------------------------------
1.  Copy the FIT1500.M file to your project directory.  This file has 
    the CUPL macros for implementing the fitter options.

2.  To use the ATF1500 Fitter Options, you must insert the following
    statement in your CUPL file.

    $INCLUDE FIT1500.M   

    The above statement must be specified ahead of the fitting option(s).
    E.g.
    
        .
        .

        $INCLUDE FIT1500.M
  
        GLOBAL(Reset);   "Force the Reset pin to the global reset pin
        .
        .

3.  When using the CUPL macros, you can only pass a single parameter to 
    each macro.  For instance, if you need to declare X0, X1, X2 to be
    expander nodes, you cannot do the following:
        
         EXP(X0, X1, X2);

    Instead,you must specify in the following manner:

         EXP(X0);
         EXP(X1);
         EXP(X2);

Special Note
------------
If you specify the following macros in your CUPL file:

    EXP (X0);       "EXP option has higher priority than EXP_ALL
    EXP_ALL (OFF);   "(even when EXP_ALL is OFF).
    .
    .
    
The above is true for all macros that have the global ON/OFF and
individual signal setting options.  The individual setting option
always has a higher priority than the global setting option.

    Higher Priority         Lower Priority
    ---------------         ----------------
    EXP                     EXP_ALL
    GLOBAL                  GLOBAL_ALL
    CASCADE_LOGIC           CASCADE_LOGIC_ALL
    TURBO_OUTPUT            TURBO
    XOR_SYNTHESIS           XOR_SYNTHESIS_ALL

*/

/* ************************************************************************ */
$MACRO EXP_ALL A;
   PROPERTY ATMEL {FOLD A };
$MEND
/*
"   Turns ON/OFF all foldback logic for fitter optimization.
"   The default condition is ON.  This option is intended to improve
"   logic density of the device.  For higher design performance, use
"   the CASCADE_LOGIC_ALL or PARALLEL_EXPANDERS_ALL macro.
"
"   E.g.
"       EXP_ALL (ON);
*/

/* ************************************************************************ */
$MACRO EXP A;
 PROPERTY ATMEL {EXPAND=A };
$MEND
/*
"   This option is compatible with the MAX7032 macro.
"
""   Implements specific buried COM signals on the foldback or expander
"   nodes in the device. Your equations must be in the following form.
"
"       foldback_node = (a & b & c &....);
"
"   In the ATF1500 device, the foldback nodes are NAND function.
"   With the EXP macro, the ! (not) is automatically assumed by the
"   ATF1500 Fitter.
"
"   Note: If you are simulating the foldback nodes via the Simulate
"         Equations, Simulate Optimized Equations or Simulate Fitted
"         Equations ABEL command, then the vectors will fail simulation
"         because ABEL simulates the equations as specified in the
"         file and does not assume the invert condition. However,
"         your JEDEC file will have the invert condition implemented.
"
"   E.g.
"       EXP (X0);
"         
"       Equations
"       X0 = (!I1 & I0);    You must not use ! in the equation.
"
"    Refer to the FOLDBACK_LOGIC or SHARABLE_EXPANDERS macro for an
"    alternate option. 
*/

/* ************************************************************************ */
$MACRO FOLDBACK_LOGIC A;
  PROPERTY ATMEL {FOLD=A };
$MEND
$MACRO SHARABLE_EXPANDERS A;
  PROPERTY ATMEL {SHA=A };
$MEND
/*
"   This option is similar to the EXP option except that the
"   ATF1500 Fitter will not assume the ! in the AND function.
"   (to get a NAND function) The ! must be specifed in the
"   expander equations.
"
"   Your equations must be in the following form.
"
"       foldback_node = !(a & b & c &....);
"
"   In the ATF1500 device, the foldback nodes are NAND function.
"   With the FOLDBACK_LOGIC or SHARABLE_EXPANDERS macro, you must
"   specify the ! in the equations.
"
"   Note: Unlike the EXP option, the CUPL simulation will pass
"         with this fitter option.  The logic equations specified
"         in the CUPL source file match the vectors in the .SI file.
"
"   E.g.
"       FOLDBACK_LOGIC(X0);   or  SHARABLE_EXPANDERS(X0);
"         
"       Equations
"       X0 = !(!I1 & I0);    You must use the ! in the equation.
*/

/* ************************************************************************ */
$MACRO GLOBAL_ALL A;            
  PROPERTY ATMEL {DEDICATED_INPUT A };
$MEND
/*
"   Turns ON/OFF global input pin fitting assignments.  Sets the most
"   commonly used CLOCK, RESET or OE pins to the global pins.  Note that
"   the RESET and OE pins have to be Active Low or inverted in the .AR and
"   .OE equations.  The default condition is ON.
"
"   E.g. #1
"
"       GLOBAL_ALL (ON);       This statement is not necessary because
"       pin = Reset;           the GLOBAL default condition is ON. 
"       pin = OE;
"
"       Equations 
"       OutReg.ar  = !Reset;   Assigned to the GCLR global pin.
"       OutReg.oe  = !OE;      Assigned to the OE1 or OE2 global pin.
"
"   E.g. #2
"
"       GLOBAL_ALL (ON);
"       pin = !Reset;
"       pin = !OE;
"
"       Equations 
"       OutReg.ar  = Reset;    Assigned to the GCLR global pin.
"       OutReg.oe  = OE;       Assigned to the OE1 or OE2 global pin.
"
*/

/* ************************************************************************ */
$MACRO GLOBAL A;                 
   PROPERTY ATMEL {DEDICATED_INPUT=A };
$MEND
/*   
    This option is compatible with the MAX7032 macro.
"
"   Assigns the specified input(s) to the global input pins: GCLK, GCLR,
"   OE1 and OE2 pinz.
"
"   E.g.
"       GLOBAL(RESET);
*/

/* ************************************************************************ */
$MACRO CASCADE_LOGIC_ALL A;
  PROPERTY ATMEL {CASC A };
$MEND
$MACRO PARALLEL_EXPANDERS_ALL A;
  PROPERTY ATMEL {PAR A };
$MEND
/*
"   Turns ON/OFF cascade logic or parallel expanders for fitter optimization.
"   This option improves the performance of the design, but at the expense
"   of device resources.  The default condition is ON.
"
"   E.g.
"       CASCADE_LOGIC_ALL (ON):
"       or
"       PARALLEL_EXPANDERS_ALL (ON);
*/

/* ************************************************************************ */
$MACRO CASCADE_LOGIC A;
  PROPERTY ATMEL {CASC=A };
$MEND
$MACRO PARALLEL_EXPANDERS A;
  PROPERTY ATMEL {PAR=A };
$MEND
/*
"   This option is compatible with the MAX7032 macro. 
"
"   Allows specific outputs to use the cascade logic or parallel expander
"   optimization for higher performance.
"
"   E.g.
"       CASCADE_LOGIC (OUT);  OUT to use cascade logic to logic
"                             implementation.
"   or
"       PARALLEL_EXPANDERS (OUT);  OUT to use parallel expanders to logic
"                                  implementation.
*/

/* ************************************************************************* */
$MACRO SOFT_BUFFER_INSERTION A;
  PROPERTY ATMEL {SOFT_BUFFER A };
$MEND
/*
"   This option is compatible with the MAX7032 macro in the 'FITMAX'
"   library.
"
"   This option enables the fitter to create physical device nodes in the
"   device, i.e. prevents the fitter from collapsing the combinatorial
"   nodes.  The default is OFF.
"
"   Ex.
"       SOFT_BUFFER_INSERTION (ON);  Turns ON physical node option
*/

/* ************************************************************************* */
$MACRO SOFT A;
  PROPERTY ATMEL {SOFT_BUFFER=A };
$MEND
/*
"   This option is compatible with the MAX7032 macro in the 'FITMAX'
"   library.
"
"   This option assigns physical device nodes in the device, i.e.
"   prevents the fitter from collapsing the combinatorial nodes.
"
"   Ex.
"       SOFT(A);   Assigns node A to be a physical device node
*/

/* ************************************************************************ */
$MACRO SECURITY A;               
  PROPERTY ATMEL {SEC=A };
$MEND
/*
"   This option is compatible with the MAX7032 macro. 
"
"   Sets the Security Bit to ON/OFF.  Default condition is OFF.
"
"   E.g.
"       SECURITY (OFF);
*/

/* ************************************************************************ */
$MACRO TURBO A;                 
  PROPERTY ATMEL {output_fast A };
$MEND
/*
"   This option is compatible with the MAX7032 macro. 
"
"   Sets all outputs to FAST (ON) or SLOW (OFF) slew-rate.  Default
"   condition is OFF. 
"
"   E.g.
"       TURBO (OFF):
*/

/* ************************************************************************ */
$MACRO TURBO_OUTPUT A;          
  PROPERTY ATMEL {output_fast = A };
$MEND
/*
"
"   Sets specific outputs for FAST slew-rate.
"
"   E.g.
"       TURBO_OUTPUT (OUT);
*/

/* ************************************************************************ */
$MACRO XOR_SYNTHESIS_ALL A;
  PROPERTY ATMEL {XOR A };
$MEND
/*
"
"   Turns ON/OFF XOR synthesis for logic optimization.  Default condition
"   is  OFF.
"
"   E.g.
"       XOR_SYNTHESIS_ALL (ON);
*/

/* ************************************************************************ */
$MACRO XOR_SYNTHESIS A;
  PROPERTY ATMEL {XOR=A };
$MEND
/*
"
"   Sets specific outputs to use XOR synthesis.
"
"   E.g.
"       XOR_SYNTEHESIS (OUT);
*/

/* ************************************************************************ */
$MACRO OPTIMIZE A;
  PROPERTY ATMEL {OPT=A };
$MEND
/*
"   This option is compatible with the MAX7032 macro. 
"
"   Turns ON/OFF all logic optimization features, including sharable
"   and parallel expanders, and XOR synthesis optimization. The
"   default condition is ON.
"
"   E.g.
"       OPTIMIZE (ON);
*/

/* ************************************************************************ */
$MACRO JEDEC_FILE A;
  PROPERTY ATMEL {jed = A };
$MEND
/*
"   Allows a different file name for the generated JEDEC file.  The
"   default file name is the same file name as the CUPL source.PLD 
"   file.
"
*/

/* ************************************************************************ */
$MACRO SLEEP A;                  
   PROPERTY ATMEL {sle A };
$MEND
/*
"   A = ON:  Enables the Power Down Pin mode.
"     = OFF: Disables the Power Down Pin mode.
"   With this macro, the fitter chooses the Powerdown Pin label
"   (POWERDOWN).  You can choose your own label using SLEEP_PIN
"   macro.
"
"   Default condition is OFF.
*/

/* ************************************************************************ */
$MACRO SLEEP_PIN A;                  
   PROPERTY ATMEL {sle=A };
$MEND
/*
"   A = label of Powerdown pin.  The Powerdown pin mode is automatically
"       enabled.
*/

/* ************************************************************************ */
$MACRO PIN_KEEPER A;                  
   PROPERTY ATMEL {pin_k A };
$MEND
/*
"   A = ON:  Sets all input and I/O pins to have pin keeper circuits.
"     = OFF; Turns off pin keeper circuits for all pins.
"   Default condition is ON.
*/

/* ************************************************************************ */
$MACRO SPEED_GRADE A;                  
   PROPERTY ATMEL {tpd=A };
$MEND
/*
"   A = 7,10,15,25:  Selects speed grade for ATF1500.  Verilog timing model
"       output file (file.VT) is automatically generated by the fitter.  
"       The Verilog file can be used by a Verilog Simulator for timing
"       simulation.
"   Default condition is 15 ns.
*/

/* ************************************************************************ */
$MACRO PREASSIGN_KEEP A;                  
   PROPERTY ATMEL {prea=A };
$MEND
/*
"   A = TRY:    Tries to keep preassigned pin/node numbers.  If design failed
"               to fit, fitter ignores all preassignments.
"     = IGNORE: Ignores all preassignments.
"     = KEEP:   Keeps all preassignments.  Fitter is aborted if design failed
"               to fit.
"
"   Default condition is TRY.
*/


