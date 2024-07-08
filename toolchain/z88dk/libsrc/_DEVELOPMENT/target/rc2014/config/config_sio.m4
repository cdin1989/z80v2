divert(-1)

###############################################################
# Zilog SIO/0-2 CONFIGURATION
# rebuild the library if changes are made
#

define(`__IO_SIOA_CONTROL_REGISTER', 0x`'eval(__IO_SIO_PORT_BASE+__IO_SIO_PORT_OFFSET_A+__IO_SIO_PORT_OFFSET_C,16)) # Address of Channel A Control Register
define(`__IO_SIOA_DATA_REGISTER', 0x`'eval(__IO_SIO_PORT_BASE+__IO_SIO_PORT_OFFSET_A+__IO_SIO_PORT_OFFSET_D,16))    # Address of Channel A Data Register
define(`__IO_SIOB_CONTROL_REGISTER', 0x`'eval(__IO_SIO_PORT_BASE+__IO_SIO_PORT_OFFSET_B+__IO_SIO_PORT_OFFSET_C,16)) # Address of Channel B Control Register
define(`__IO_SIOB_DATA_REGISTER', 0x`'eval(__IO_SIO_PORT_BASE+__IO_SIO_PORT_OFFSET_B+__IO_SIO_PORT_OFFSET_D,16))    # Address of Channel B Data Register

# Write Register 0

define(`__IO_SIO_WR0_NULL', 0x00)

define(`__IO_SIO_WR0_R0', 0x00)
define(`__IO_SIO_WR0_R1', 0x01)
define(`__IO_SIO_WR0_R2', 0x02)
define(`__IO_SIO_WR0_R3', 0x03)
define(`__IO_SIO_WR0_R4', 0x04)
define(`__IO_SIO_WR0_R5', 0x05)
define(`__IO_SIO_WR0_R6', 0x06)
define(`__IO_SIO_WR0_R7', 0x07)

define(`__IO_SIO_WR0_SDLC_ABORT', 0x08)
define(`__IO_SIO_WR0_EXT_INT_RESET', 0x10)
define(`__IO_SIO_WR0_CHANNEL_RESET', 0x18)
define(`__IO_SIO_WR0_RX_INT_FIRST_REENABLE', 0x20)
define(`__IO_SIO_WR0_TX_INT_PENDING_RESET', 0x28)
define(`__IO_SIO_WR0_ERROR_RESET', 0x30)
define(`__IO_SIO_WR0_A_INT_RETURN', 0x38)

define(`__IO_SIO_WR0_RX_CRC_RESET', 0x40)
define(`__IO_SIO_WR0_TX_CRC_RESET', 0x80)
define(`__IO_SIO_WR0_TX_EOM_RESET', 0xC0)

# Write Register 1

define(`__IO_SIO_WR1_EXT_INT_ENABLE', 0x01)
define(`__IO_SIO_WR1_TX_INT_ENABLE', 0x02)
define(`__IO_SIO_WR1_B_STATUS_VECTOR', 0x04)


define(`__IO_SIO_WR1_RX_INT_NONE', 0x00)
define(`__IO_SIO_WR1_RX_INT_FIRST', 0x08)
define(`__IO_SIO_WR1_RX_INT_ALL_EXCL_SPECIAL', 0x10)
define(`__IO_SIO_WR1_RX_INT_ALL', 0x18)

define(`__IO_SIO_WR1_WAIT_READY_RX', 0x20)
define(`__IO_SIO_WR1_WAIT_READY_READY', 0x40)
define(`__IO_SIO_WR1_WAIT_READY_ENABLE', 0x80)

# Write Register 2 (Interrupt Vector Register - Channel B Only)

# Write Register 3

define(`__IO_SIO_WR3_RX_ENABLE', 0x01)
define(`__IO_SIO_WR3_RX_SYNC_LOAD_INHIBIT', 0x02)
define(`__IO_SIO_WR3_SDLC_ADDRESS_SEARCH', 0x04)
define(`__IO_SIO_WR3_SDLC_RX_CRC', 0x08)
define(`__IO_SIO_WR3_HUNT_PHASE_ENABLE', 0x10)
define(`__IO_SIO_WR3_AUTO_ENABLES', 0x20)

define(`__IO_SIO_WR3_RX_5BIT', 0x00)
define(`__IO_SIO_WR3_RX_7BIT', 0x40)
define(`__IO_SIO_WR3_RX_6BIT', 0x80)
define(`__IO_SIO_WR3_RX_8BIT', 0xC0)

# Write Register 4

define(`__IO_SIO_WR4_PARITY_NONE', 0x00)
define(`__IO_SIO_WR4_PARITY_ENABLE', 0x01)
define(`__IO_SIO_WR4_PARITY_EVEN', 0x02)

define(`__IO_SIO_WR4_SYNC_MODE', 0x00)
define(`__IO_SIO_WR4_STOP_1', 0x04)
define(`__IO_SIO_WR4_STOP_3HALF', 0x08)
define(`__IO_SIO_WR4_STOP_2', 0x0C)

define(`__IO_SIO_WR4_SYNC_8BIT', 0x00)
define(`__IO_SIO_WR4_SYNC_16BIT', 0x10)
define(`__IO_SIO_WR4_SYNC_SDLC', 0x20)
define(`__IO_SIO_WR4_SYNC_EXTERN', 0x30)

define(`__IO_SIO_WR4_CLK_DIV_01', 0x00)
define(`__IO_SIO_WR4_CLK_DIV_16', 0x40)
define(`__IO_SIO_WR4_CLK_DIV_32', 0x80)
define(`__IO_SIO_WR4_CLK_DIV_64', 0xC0)

# Write Register 5

define(`__IO_SIO_WR5_TX_CRC_ENABLE', 0x01)
define(`__IO_SIO_WR5_RTS', 0x02)
define(`__IO_SIO_WR5_SDLC_CRC_16', 0x04)
define(`__IO_SIO_WR5_TX_ENABLE', 0x08)
define(`__IO_SIO_WR5_TX_BREAK', 0x10)

define(`__IO_SIO_WR5_TX_5BIT', 0x00)
define(`__IO_SIO_WR5_TX_7BIT', 0x20)
define(`__IO_SIO_WR5_TX_6BIT', 0x40)
define(`__IO_SIO_WR5_TX_8BIT', 0x60)

define(`__IO_SIO_WR5_TX_DTR', 0x80)

# Write Register 6 (SDLC SYNC LSB)

# Write Register 7 (SDLC SYNC MSB)

# Read Register 0

define(`__IO_SIO_RR0_RX_CHAR', 0x01)
define(`__IO_SIO_RR0_A_INT_PENDING', 0x02)
define(`__IO_SIO_RR0_TX_EMPTY', 0x04)
define(`__IO_SIO_RR0_DCD', 0x08)
define(`__IO_SIO_RR0_SYNC', 0x10)
define(`__IO_SIO_RR0_CTS', 0x20)
define(`__IO_SIO_RR0_TX_EOM', 0x40)
define(`__IO_SIO_RR0_RX_BREAK', 0x80)

# Read Register 1

define(`__IO_SIO_RR1_TX_ALL_SENT', 0x01)

define(`__IO_SIO_RR1_SDLC_RESIDUE_CODE_0', 0x02)
define(`__IO_SIO_RR1_SDLC_RESIDUE_CODE_1', 0x04)
define(`__IO_SIO_RR1_SDLC_RESIDUE_CODE_2', 0x08)

define(`__IO_SIO_RR1_RX_PARITY_ERROR', 0x10)
define(`__IO_SIO_RR1_RX_OVERRUN', 0x20)
define(`__IO_SIO_RR1_RX_FRAMING_ERROR', 0x40)
define(`__IO_SIO_RR1_SDLC_EOF', 0x80)

# Read Register 2  (Interrupt Vector Register - Channel B Only)

# Zilog SIO driver

define(`__IO_SIO_RX_SIZE', 0x100)         # Size of the Rx Buffer
define(`__IO_SIO_RX_FULLISH', 0x`'eval(__IO_SIO_RX_SIZE-16,16))
                                          # Fullness of the Rx Buffer, when NOT_RTS is signalled
define(`__IO_SIO_RX_EMPTYISH', 0x08)      # Fullness of the Rx Buffer, when RTS is signalled
define(`__IO_SIO_TX_SIZE', 0x10)          # Size of the Tx Buffer   

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_SIOA_CONTROL_REGISTER'
PUBLIC `__IO_SIOA_DATA_REGISTER'
PUBLIC `__IO_SIOB_CONTROL_REGISTER'
PUBLIC `__IO_SIOB_DATA_REGISTER'

PUBLIC `__IO_SIO_WR0_NULL'

PUBLIC `__IO_SIO_WR0_R0'
PUBLIC `__IO_SIO_WR0_R1'
PUBLIC `__IO_SIO_WR0_R2'
PUBLIC `__IO_SIO_WR0_R3'
PUBLIC `__IO_SIO_WR0_R4'
PUBLIC `__IO_SIO_WR0_R5'
PUBLIC `__IO_SIO_WR0_R6'
PUBLIC `__IO_SIO_WR0_R7'

PUBLIC `__IO_SIO_WR0_SDLC_ABORT'
PUBLIC `__IO_SIO_WR0_EXT_INT_RESET'
PUBLIC `__IO_SIO_WR0_CHANNEL_RESET'
PUBLIC `__IO_SIO_WR0_RX_INT_FIRST_REENABLE'
PUBLIC `__IO_SIO_WR0_TX_INT_PENDING_RESET'
PUBLIC `__IO_SIO_WR0_ERROR_RESET'
PUBLIC `__IO_SIO_WR0_A_INT_RETURN'

PUBLIC `__IO_SIO_WR0_RX_CRC_RESET'
PUBLIC `__IO_SIO_WR0_TX_CRC_RESET'
PUBLIC `__IO_SIO_WR0_TX_EOM_RESET'

PUBLIC `__IO_SIO_WR1_EXT_INT_ENABLE'
PUBLIC `__IO_SIO_WR1_TX_INT_ENABLE'
PUBLIC `__IO_SIO_WR1_B_STATUS_VECTOR'

PUBLIC `__IO_SIO_WR1_RX_INT_NONE'
PUBLIC `__IO_SIO_WR1_RX_INT_FIRST'
PUBLIC `__IO_SIO_WR1_RX_INT_ALL_EXCL_SPECIAL'
PUBLIC `__IO_SIO_WR1_RX_INT_ALL'

PUBLIC `__IO_SIO_WR1_WAIT_READY_RX'
PUBLIC `__IO_SIO_WR1_WAIT_READY_READY'
PUBLIC `__IO_SIO_WR1_WAIT_READY_ENABLE'

PUBLIC `__IO_SIO_WR3_RX_ENABLE'
PUBLIC `__IO_SIO_WR3_RX_SYNC_LOAD_INHIBIT'
PUBLIC `__IO_SIO_WR3_SDLC_ADDRESS_SEARCH'
PUBLIC `__IO_SIO_WR3_SDLC_RX_CRC'
PUBLIC `__IO_SIO_WR3_HUNT_PHASE_ENABLE'
PUBLIC `__IO_SIO_WR3_AUTO_ENABLES'

PUBLIC `__IO_SIO_WR3_RX_5BIT'
PUBLIC `__IO_SIO_WR3_RX_7BIT'
PUBLIC `__IO_SIO_WR3_RX_6BIT'
PUBLIC `__IO_SIO_WR3_RX_8BIT'

PUBLIC `__IO_SIO_WR4_PARITY_NONE'
PUBLIC `__IO_SIO_WR4_PARITY_ENABLE'
PUBLIC `__IO_SIO_WR4_PARITY_EVEN'

PUBLIC `__IO_SIO_WR4_SYNC_MODE'
PUBLIC `__IO_SIO_WR4_STOP_1'
PUBLIC `__IO_SIO_WR4_STOP_3HALF'
PUBLIC `__IO_SIO_WR4_STOP_2'

PUBLIC `__IO_SIO_WR4_SYNC_8BIT'
PUBLIC `__IO_SIO_WR4_SYNC_16BIT'
PUBLIC `__IO_SIO_WR4_SYNC_SDLC'
PUBLIC `__IO_SIO_WR4_SYNC_EXTERN'

PUBLIC `__IO_SIO_WR4_CLK_DIV_01'
PUBLIC `__IO_SIO_WR4_CLK_DIV_16'
PUBLIC `__IO_SIO_WR4_CLK_DIV_32'
PUBLIC `__IO_SIO_WR4_CLK_DIV_64'

PUBLIC `__IO_SIO_WR5_TX_CRC_ENABLE'
PUBLIC `__IO_SIO_WR5_RTS'
PUBLIC `__IO_SIO_WR5_SDLC_CRC_16'
PUBLIC `__IO_SIO_WR5_TX_ENABLE'
PUBLIC `__IO_SIO_WR5_TX_BREAK'

PUBLIC `__IO_SIO_WR5_TX_5BIT'
PUBLIC `__IO_SIO_WR5_TX_7BIT'
PUBLIC `__IO_SIO_WR5_TX_6BIT'
PUBLIC `__IO_SIO_WR5_TX_8BIT'

PUBLIC `__IO_SIO_WR5_TX_DTR'

PUBLIC `__IO_SIO_RR0_RX_CHAR'
PUBLIC `__IO_SIO_RR0_A_INT_PENDING'
PUBLIC `__IO_SIO_RR0_TX_EMPTY'
PUBLIC `__IO_SIO_RR0_DCD'
PUBLIC `__IO_SIO_RR0_SYNC'
PUBLIC `__IO_SIO_RR0_CTS'
PUBLIC `__IO_SIO_RR0_TX_EOM'
PUBLIC `__IO_SIO_RR0_RX_BREAK'

PUBLIC `__IO_SIO_RR1_TX_ALL_SENT'

PUBLIC `__IO_SIO_RR1_SDLC_RESIDUE_CODE_0'
PUBLIC `__IO_SIO_RR1_SDLC_RESIDUE_CODE_1'
PUBLIC `__IO_SIO_RR1_SDLC_RESIDUE_CODE_2'

PUBLIC `__IO_SIO_RR1_RX_PARITY_ERROR'
PUBLIC `__IO_SIO_RR1_RX_OVERRUN'
PUBLIC `__IO_SIO_RR1_RX_FRAMING_ERROR'
PUBLIC `__IO_SIO_RR1_SDLC_EOF'

PUBLIC `__IO_SIO_RX_SIZE'
PUBLIC `__IO_SIO_RX_FULLISH'
PUBLIC `__IO_SIO_RX_EMPTYISH'
PUBLIC `__IO_SIO_TX_SIZE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_SIOA_CONTROL_REGISTER'   = __IO_SIOA_CONTROL_REGISTER
defc `__IO_SIOA_DATA_REGISTER'      = __IO_SIOA_DATA_REGISTER
defc `__IO_SIOB_CONTROL_REGISTER'   = __IO_SIOB_CONTROL_REGISTER
defc `__IO_SIOB_DATA_REGISTER'      = __IO_SIOB_DATA_REGISTER

defc `__IO_SIO_WR0_NULL'      = __IO_SIO_WR0_NULL

defc `__IO_SIO_WR0_R0'      = __IO_SIO_WR0_R0
defc `__IO_SIO_WR0_R1'      = __IO_SIO_WR0_R1
defc `__IO_SIO_WR0_R2'      = __IO_SIO_WR0_R2
defc `__IO_SIO_WR0_R3'      = __IO_SIO_WR0_R3
defc `__IO_SIO_WR0_R4'      = __IO_SIO_WR0_R4
defc `__IO_SIO_WR0_R5'      = __IO_SIO_WR0_R5
defc `__IO_SIO_WR0_R6'      = __IO_SIO_WR0_R6
defc `__IO_SIO_WR0_R7'      = __IO_SIO_WR0_R7

defc `__IO_SIO_WR0_SDLC_ABORT'      = __IO_SIO_WR0_SDLC_ABORT
defc `__IO_SIO_WR0_EXT_INT_RESET'      = __IO_SIO_WR0_EXT_INT_RESET
defc `__IO_SIO_WR0_CHANNEL_RESET'      = __IO_SIO_WR0_CHANNEL_RESET
defc `__IO_SIO_WR0_RX_INT_FIRST_REENABLE'      = __IO_SIO_WR0_RX_INT_FIRST_REENABLE
defc `__IO_SIO_WR0_TX_INT_PENDING_RESET'      = __IO_SIO_WR0_TX_INT_PENDING_RESET
defc `__IO_SIO_WR0_ERROR_RESET'      = __IO_SIO_WR0_ERROR_RESET
defc `__IO_SIO_WR0_A_INT_RETURN'      = __IO_SIO_WR0_A_INT_RETURN

defc `__IO_SIO_WR0_RX_CRC_RESET'      = __IO_SIO_WR0_RX_CRC_RESET
defc `__IO_SIO_WR0_TX_CRC_RESET'      = __IO_SIO_WR0_TX_CRC_RESET
defc `__IO_SIO_WR0_TX_EOM_RESET'      = __IO_SIO_WR0_TX_EOM_RESET

defc `__IO_SIO_WR1_EXT_INT_ENABLE'      = __IO_SIO_WR1_EXT_INT_ENABLE
defc `__IO_SIO_WR1_TX_INT_ENABLE'      = __IO_SIO_WR1_TX_INT_ENABLE
defc `__IO_SIO_WR1_B_STATUS_VECTOR'      = __IO_SIO_WR1_B_STATUS_VECTOR

defc `__IO_SIO_WR1_RX_INT_NONE'      = __IO_SIO_WR1_RX_INT_NONE
defc `__IO_SIO_WR1_RX_INT_FIRST'      = __IO_SIO_WR1_RX_INT_FIRST
defc `__IO_SIO_WR1_RX_INT_ALL_EXCL_SPECIAL'      = __IO_SIO_WR1_RX_INT_ALL_EXCL_SPECIAL
defc `__IO_SIO_WR1_RX_INT_ALL'      = __IO_SIO_WR1_RX_INT_ALL

defc `__IO_SIO_WR1_WAIT_READY_RX'      = __IO_SIO_WR1_WAIT_READY_RX
defc `__IO_SIO_WR1_WAIT_READY_READY'      = __IO_SIO_WR1_WAIT_READY_READY
defc `__IO_SIO_WR1_WAIT_READY_ENABLE'      = __IO_SIO_WR1_WAIT_READY_ENABLE

defc `__IO_SIO_WR3_RX_ENABLE'      = __IO_SIO_WR3_RX_ENABLE
defc `__IO_SIO_WR3_RX_SYNC_LOAD_INHIBIT'      = __IO_SIO_WR3_RX_SYNC_LOAD_INHIBIT
defc `__IO_SIO_WR3_SDLC_ADDRESS_SEARCH'      = __IO_SIO_WR3_SDLC_ADDRESS_SEARCH
defc `__IO_SIO_WR3_SDLC_RX_CRC'      = __IO_SIO_WR3_SDLC_RX_CRC
defc `__IO_SIO_WR3_HUNT_PHASE_ENABLE'      = __IO_SIO_WR3_HUNT_PHASE_ENABLE
defc `__IO_SIO_WR3_AUTO_ENABLES'      = __IO_SIO_WR3_AUTO_ENABLES

defc `__IO_SIO_WR3_RX_5BIT'      = __IO_SIO_WR3_RX_5BIT
defc `__IO_SIO_WR3_RX_7BIT'      = __IO_SIO_WR3_RX_7BIT
defc `__IO_SIO_WR3_RX_6BIT'      = __IO_SIO_WR3_RX_6BIT
defc `__IO_SIO_WR3_RX_8BIT'      = __IO_SIO_WR3_RX_8BIT

defc `__IO_SIO_WR4_PARITY_NONE'      = __IO_SIO_WR4_PARITY_NONE
defc `__IO_SIO_WR4_PARITY_ENABLE'      = __IO_SIO_WR4_PARITY_ENABLE
defc `__IO_SIO_WR4_PARITY_EVEN'      = __IO_SIO_WR4_PARITY_EVEN

defc `__IO_SIO_WR4_SYNC_MODE'      = __IO_SIO_WR4_SYNC_MODE
defc `__IO_SIO_WR4_STOP_1'      = __IO_SIO_WR4_STOP_1
defc `__IO_SIO_WR4_STOP_3HALF'      = __IO_SIO_WR4_STOP_3HALF
defc `__IO_SIO_WR4_STOP_2'      = __IO_SIO_WR4_STOP_2

defc `__IO_SIO_WR4_SYNC_8BIT'      = __IO_SIO_WR4_SYNC_8BIT
defc `__IO_SIO_WR4_SYNC_16BIT'      = __IO_SIO_WR4_SYNC_16BIT
defc `__IO_SIO_WR4_SYNC_SDLC'      = __IO_SIO_WR4_SYNC_SDLC
defc `__IO_SIO_WR4_SYNC_EXTERN'      = __IO_SIO_WR4_SYNC_EXTERN

defc `__IO_SIO_WR4_CLK_DIV_01'      = __IO_SIO_WR4_CLK_DIV_01
defc `__IO_SIO_WR4_CLK_DIV_16'      = __IO_SIO_WR4_CLK_DIV_16
defc `__IO_SIO_WR4_CLK_DIV_32'      = __IO_SIO_WR4_CLK_DIV_32
defc `__IO_SIO_WR4_CLK_DIV_64'      = __IO_SIO_WR4_CLK_DIV_64

defc `__IO_SIO_WR5_TX_CRC_ENABLE'      = __IO_SIO_WR5_TX_CRC_ENABLE
defc `__IO_SIO_WR5_RTS'      = __IO_SIO_WR5_RTS
defc `__IO_SIO_WR5_SDLC_CRC_16'      = __IO_SIO_WR5_SDLC_CRC_16
defc `__IO_SIO_WR5_TX_ENABLE'      = __IO_SIO_WR5_TX_ENABLE
defc `__IO_SIO_WR5_TX_BREAK'      = __IO_SIO_WR5_TX_BREAK

defc `__IO_SIO_WR5_TX_5BIT'      = __IO_SIO_WR5_TX_5BIT
defc `__IO_SIO_WR5_TX_7BIT'      = __IO_SIO_WR5_TX_7BIT
defc `__IO_SIO_WR5_TX_6BIT'      = __IO_SIO_WR5_TX_6BIT
defc `__IO_SIO_WR5_TX_8BIT'      = __IO_SIO_WR5_TX_8BIT

defc `__IO_SIO_WR5_TX_DTR'      = __IO_SIO_WR5_TX_DTR

defc `__IO_SIO_RR0_RX_CHAR'      = __IO_SIO_RR0_RX_CHAR
defc `__IO_SIO_RR0_A_INT_PENDING'      = __IO_SIO_RR0_A_INT_PENDING
defc `__IO_SIO_RR0_TX_EMPTY'      = __IO_SIO_RR0_TX_EMPTY
defc `__IO_SIO_RR0_DCD'      = __IO_SIO_RR0_DCD
defc `__IO_SIO_RR0_SYNC'      = __IO_SIO_RR0_SYNC
defc `__IO_SIO_RR0_CTS'      = __IO_SIO_RR0_CTS
defc `__IO_SIO_RR0_TX_EOM'      = __IO_SIO_RR0_TX_EOM
defc `__IO_SIO_RR0_RX_BREAK'      = __IO_SIO_RR0_RX_BREAK

defc `__IO_SIO_RR1_TX_ALL_SENT'      = __IO_SIO_RR1_TX_ALL_SENT

defc `__IO_SIO_RR1_SDLC_RESIDUE_CODE_0'      = __IO_SIO_RR1_SDLC_RESIDUE_CODE_0
defc `__IO_SIO_RR1_SDLC_RESIDUE_CODE_1'      = __IO_SIO_RR1_SDLC_RESIDUE_CODE_1
defc `__IO_SIO_RR1_SDLC_RESIDUE_CODE_2'      = __IO_SIO_RR1_SDLC_RESIDUE_CODE_2

defc `__IO_SIO_RR1_RX_PARITY_ERROR'      = __IO_SIO_RR1_RX_PARITY_ERROR
defc `__IO_SIO_RR1_RX_OVERRUN'      = __IO_SIO_RR1_RX_OVERRUN
defc `__IO_SIO_RR1_RX_FRAMING_ERROR'      = __IO_SIO_RR1_RX_FRAMING_ERROR
defc `__IO_SIO_RR1_SDLC_EOF'      = __IO_SIO_RR1_SDLC_EOF

defc `__IO_SIO_RX_SIZE'      = __IO_SIO_RX_SIZE
defc `__IO_SIO_RX_FULLISH'      = __IO_SIO_RX_FULLISH
defc `__IO_SIO_RX_EMPTYISH'      = __IO_SIO_RX_EMPTYISH
defc `__IO_SIO_TX_SIZE'      = __IO_SIO_TX_SIZE
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_SIOA_CONTROL_REGISTER'  __IO_SIOA_CONTROL_REGISTER
`#define' `__IO_SIOA_DATA_REGISTER'     __IO_SIOA_DATA_REGISTER
`#define' `__IO_SIOB_CONTROL_REGISTER'  __IO_SIOB_CONTROL_REGISTER
`#define' `__IO_SIOB_DATA_REGISTER'     __IO_SIOB_DATA_REGISTER

`#define' `__IO_SIO_WR0_NULL'     __IO_SIO_WR0_NULL

`#define' `__IO_SIO_WR0_R0'     __IO_SIO_WR0_R0
`#define' `__IO_SIO_WR0_R1'     __IO_SIO_WR0_R1
`#define' `__IO_SIO_WR0_R2'     __IO_SIO_WR0_R2
`#define' `__IO_SIO_WR0_R3'     __IO_SIO_WR0_R3
`#define' `__IO_SIO_WR0_R4'     __IO_SIO_WR0_R4
`#define' `__IO_SIO_WR0_R5'     __IO_SIO_WR0_R5
`#define' `__IO_SIO_WR0_R6'     __IO_SIO_WR0_R6
`#define' `__IO_SIO_WR0_R7'     __IO_SIO_WR0_R7

`#define' `__IO_SIO_WR0_SDLC_ABORT'     __IO_SIO_WR0_SDLC_ABORT
`#define' `__IO_SIO_WR0_EXT_INT_RESET'     __IO_SIO_WR0_EXT_INT_RESET
`#define' `__IO_SIO_WR0_CHANNEL_RESET'     __IO_SIO_WR0_CHANNEL_RESET
`#define' `__IO_SIO_WR0_RX_INT_FIRST_REENABLE'     __IO_SIO_WR0_RX_INT_FIRST_REENABLE
`#define' `__IO_SIO_WR0_TX_INT_PENDING_RESET'     __IO_SIO_WR0_TX_INT_PENDING_RESET
`#define' `__IO_SIO_WR0_ERROR_RESET'     __IO_SIO_WR0_ERROR_RESET
`#define' `__IO_SIO_WR0_A_INT_RETURN'     __IO_SIO_WR0_A_INT_RETURN

`#define' `__IO_SIO_WR0_RX_CRC_RESET'     __IO_SIO_WR0_RX_CRC_RESET
`#define' `__IO_SIO_WR0_TX_CRC_RESET'     __IO_SIO_WR0_TX_CRC_RESET
`#define' `__IO_SIO_WR0_TX_EOM_RESET'     __IO_SIO_WR0_TX_EOM_RESET

`#define' `__IO_SIO_WR1_EXT_INT_ENABLE'     __IO_SIO_WR1_EXT_INT_ENABLE
`#define' `__IO_SIO_WR1_TX_INT_ENABLE'     __IO_SIO_WR1_TX_INT_ENABLE
`#define' `__IO_SIO_WR1_B_STATUS_VECTOR'     __IO_SIO_WR1_B_STATUS_VECTOR

`#define' `__IO_SIO_WR1_RX_INT_NONE'     __IO_SIO_WR1_RX_INT_NONE
`#define' `__IO_SIO_WR1_RX_INT_FIRST'     __IO_SIO_WR1_RX_INT_FIRST
`#define' `__IO_SIO_WR1_RX_INT_ALL_EXCL_SPECIAL'     __IO_SIO_WR1_RX_INT_ALL_EXCL_SPECIAL
`#define' `__IO_SIO_WR1_RX_INT_ALL'     __IO_SIO_WR1_RX_INT_ALL

`#define' `__IO_SIO_WR1_WAIT_READY_RX'     __IO_SIO_WR1_WAIT_READY_RX
`#define' `__IO_SIO_WR1_WAIT_READY_READY'     __IO_SIO_WR1_WAIT_READY_READY
`#define' `__IO_SIO_WR1_WAIT_READY_ENABLE'     __IO_SIO_WR1_WAIT_READY_ENABLE

`#define' `__IO_SIO_WR3_RX_ENABLE'     __IO_SIO_WR3_RX_ENABLE
`#define' `__IO_SIO_WR3_RX_SYNC_LOAD_INHIBIT'     __IO_SIO_WR3_RX_SYNC_LOAD_INHIBIT
`#define' `__IO_SIO_WR3_SDLC_ADDRESS_SEARCH'     __IO_SIO_WR3_SDLC_ADDRESS_SEARCH
`#define' `__IO_SIO_WR3_SDLC_RX_CRC'     __IO_SIO_WR3_SDLC_RX_CRC
`#define' `__IO_SIO_WR3_HUNT_PHASE_ENABLE'     __IO_SIO_WR3_HUNT_PHASE_ENABLE
`#define' `__IO_SIO_WR3_AUTO_ENABLES'     __IO_SIO_WR3_AUTO_ENABLES

`#define' `__IO_SIO_WR3_RX_5BIT'     __IO_SIO_WR3_RX_5BIT
`#define' `__IO_SIO_WR3_RX_7BIT'     __IO_SIO_WR3_RX_7BIT
`#define' `__IO_SIO_WR3_RX_6BIT'     __IO_SIO_WR3_RX_6BIT
`#define' `__IO_SIO_WR3_RX_8BIT'     __IO_SIO_WR3_RX_8BIT

`#define' `__IO_SIO_WR4_PARITY_NONE'     __IO_SIO_WR4_PARITY_NONE
`#define' `__IO_SIO_WR4_PARITY_ENABLE'     __IO_SIO_WR4_PARITY_ENABLE
`#define' `__IO_SIO_WR4_PARITY_EVEN'     __IO_SIO_WR4_PARITY_EVEN

`#define' `__IO_SIO_WR4_SYNC_MODE'     __IO_SIO_WR4_SYNC_MODE
`#define' `__IO_SIO_WR4_STOP_1'     __IO_SIO_WR4_STOP_1
`#define' `__IO_SIO_WR4_STOP_3HALF'     __IO_SIO_WR4_STOP_3HALF
`#define' `__IO_SIO_WR4_STOP_2'     __IO_SIO_WR4_STOP_2

`#define' `__IO_SIO_WR4_SYNC_8BIT'     __IO_SIO_WR4_SYNC_8BIT
`#define' `__IO_SIO_WR4_SYNC_16BIT'     __IO_SIO_WR4_SYNC_16BIT
`#define' `__IO_SIO_WR4_SYNC_SDLC'     __IO_SIO_WR4_SYNC_SDLC
`#define' `__IO_SIO_WR4_SYNC_EXTERN'     __IO_SIO_WR4_SYNC_EXTERN

`#define' `__IO_SIO_WR4_CLK_DIV_01'     __IO_SIO_WR4_CLK_DIV_01
`#define' `__IO_SIO_WR4_CLK_DIV_16'     __IO_SIO_WR4_CLK_DIV_16
`#define' `__IO_SIO_WR4_CLK_DIV_32'     __IO_SIO_WR4_CLK_DIV_32
`#define' `__IO_SIO_WR4_CLK_DIV_64'     __IO_SIO_WR4_CLK_DIV_64

`#define' `__IO_SIO_WR5_TX_CRC_ENABLE'     __IO_SIO_WR5_TX_CRC_ENABLE
`#define' `__IO_SIO_WR5_RTS'     __IO_SIO_WR5_RTS
`#define' `__IO_SIO_WR5_SDLC_CRC_16'     __IO_SIO_WR5_SDLC_CRC_16
`#define' `__IO_SIO_WR5_TX_ENABLE'     __IO_SIO_WR5_TX_ENABLE
`#define' `__IO_SIO_WR5_TX_BREAK'     __IO_SIO_WR5_TX_BREAK

`#define' `__IO_SIO_WR5_TX_5BIT'     __IO_SIO_WR5_TX_5BIT
`#define' `__IO_SIO_WR5_TX_7BIT'     __IO_SIO_WR5_TX_7BIT
`#define' `__IO_SIO_WR5_TX_6BIT'     __IO_SIO_WR5_TX_6BIT
`#define' `__IO_SIO_WR5_TX_8BIT'     __IO_SIO_WR5_TX_8BIT

`#define' `__IO_SIO_WR5_TX_DTR'     __IO_SIO_WR5_TX_DTR

`#define' `__IO_SIO_RR0_RX_CHAR'     __IO_SIO_RR0_RX_CHAR
`#define' `__IO_SIO_RR0_A_INT_PENDING'     __IO_SIO_RR0_A_INT_PENDING
`#define' `__IO_SIO_RR0_TX_EMPTY'     __IO_SIO_RR0_TX_EMPTY
`#define' `__IO_SIO_RR0_DCD'     __IO_SIO_RR0_DCD
`#define' `__IO_SIO_RR0_SYNC'     __IO_SIO_RR0_SYNC
`#define' `__IO_SIO_RR0_CTS'     __IO_SIO_RR0_CTS
`#define' `__IO_SIO_RR0_TX_EOM'     __IO_SIO_RR0_TX_EOM
`#define' `__IO_SIO_RR0_RX_BREAK'     __IO_SIO_RR0_RX_BREAK

`#define' `__IO_SIO_RR1_TX_ALL_SENT'     __IO_SIO_RR1_TX_ALL_SENT

`#define' `__IO_SIO_RR1_SDLC_RESIDUE_CODE_0'     __IO_SIO_RR1_SDLC_RESIDUE_CODE_0
`#define' `__IO_SIO_RR1_SDLC_RESIDUE_CODE_1'     __IO_SIO_RR1_SDLC_RESIDUE_CODE_1
`#define' `__IO_SIO_RR1_SDLC_RESIDUE_CODE_2'     __IO_SIO_RR1_SDLC_RESIDUE_CODE_2

`#define' `__IO_SIO_RR1_RX_PARITY_ERROR'     __IO_SIO_RR1_RX_PARITY_ERROR
`#define' `__IO_SIO_RR1_RX_OVERRUN'     __IO_SIO_RR1_RX_OVERRUN
`#define' `__IO_SIO_RR1_RX_FRAMING_ERROR'     __IO_SIO_RR1_RX_FRAMING_ERROR
`#define' `__IO_SIO_RR1_SDLC_EOF'     __IO_SIO_RR1_SDLC_EOF

`#define' `__IO_SIO_RX_SIZE'        __IO_SIO_RX_SIZE
`#define' `__IO_SIO_RX_FULLISH'     __IO_SIO_RX_FULLISH
`#define' `__IO_SIO_RX_EMPTYISH'    __IO_SIO_RX_EMPTYISH
`#define' `__IO_SIO_TX_SIZE'        __IO_SIO_TX_SIZE
')