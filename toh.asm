# Title: Programming Project Part 3       #Filename: TowersOfHanoi.asm
# Author: Joseph Lyons                    #Date: February 22nd, 2017
# Description: Displays the moves needed to solve the puzzle of the towers of Hanoi
# Input: Number of rings
# Output: Steps for solving the problem
################# Data segment #####################
.data

requestInput: .asciiz "Enter number of disks: "
moveDisk:     .asciiz "Move disk "
fromPeg:      .asciiz " from peg "
toPeg:        .asciiz " to peg "
newline:      .asciiz "\n"
################# Code segment #####################
.text
.globl main

# Variable Key:
# $a0 = n
# $a1 = start
# $a2 = finish
# $a3 = extra

main:
       li $v0, 4              # Load number for system call for printing string
       la $a0, requestInput   # Load string
       syscall
    
       li $v0, 5              # Load number for system call for reading number in
       syscall
    
       addi $a0, $v0,   0     # Put user number in $a0
       addi $a1, $zero, 1     # Put 1 in start
       addi $a2, $zero, 2     # Put 2 in finish
       addi $a3, $zero, 3     # Put 3 in extra
    
       jal  hanoi
       j    Leave

hanoi: addi $sp, $sp, -20     # Make room in stack
       sw   $ra, 16($sp)      # Store returning address
       sw   $a0, 12($sp)      # Store n
       sw   $a1, 8($sp)       # Store start
       sw   $a2, 4($sp)       # Store finish
       sw   $a3, 0($sp)       # Store extra

       slti $t0, $a0,   1     # Test base case
       beq  $t0, $zero, Skip  # As long as n > 0, call recursively
       addi $sp, $sp,   20    # If n = 0, adjust stack pointer and begin backtracing
       jr   $ra  

Skip:  addi $a0, $a0, -1      # Decrement n

       add  $t0, $a2, $zero   # Temp holder for $a1 for swapping proceedure next
       add  $a2, $a3, $zero   # Swap
       add  $a3, $t0, $zero   # Swap
       jal  hanoi             # Recursive call
       
       lw   $a3, 0($sp)       # Load Extra
       lw   $a2, 4($sp)       # Load Finish
       lw   $a1, 8($sp)       # Load start
       lw   $a0, 12($sp)      # Load n
       lw   $ra, 16($sp)      # Load returning address
       addi $sp, $sp, 20      # Adjust stack pointer
       
       add  $t0, $a0, $zero   # Back up n temporarily
       
       li   $v0, 4            # Load number for system call for printing string
       la   $a0, moveDisk     # Load string
       syscall
    
       li   $v0, 1            # Load number for system call for print number
       add  $a0, $t0, $zero   # Move $a0 for printing
       syscall
       
       li   $v0, 4            # Load number for system call for printing string
       la   $a0, fromPeg      # Load string
       syscall
    
       li   $v0, 1            # Load number for system call for print number
       add  $a0, $zero, $a1   # Move $a1 for printing
       syscall
       
       li   $v0, 4            # Load number for system call for printing string
       la   $a0, toPeg        # Load string
       syscall
    
       li   $v0, 1            # Load number for system call for print number
       add  $a0, $zero, $a2   # Move $a2 for printing
       syscall
       
       li   $v0, 4            # Load number for system call for printing string
       la   $a0, newline      # Load string
       syscall
       
       add  $a0, $t0, $zero   # recover n
       addi $a0, $a0, -1      # Decrement n
       
       add  $t0, $a1, $zero   # Temp holder for $a1 for swapping proceedure next
       add  $a1, $a3, $zero   # Swap
       add  $a3, $t0, $zero   # Swap
       j    hanoi             # Recursive call
       
       jr   $ra
Leave: