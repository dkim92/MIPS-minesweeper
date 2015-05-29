	.data
getCommand:     	.asciiz "\n\nFormat: (step or flag) (column) (row)"
enterCommand:   	.asciiz "\n>>  "
getRestart:     	.asciiz "\n\nRestart (0 to restart): "
buffer:			.space 6
printnewline:		.asciiz "\n"
printuntouched:		.asciiz "_ "
printblank:		.asciiz "  "
printflag:		.asciiz "f "
printmine:		.asciiz "m "
printsteppedmine:	.asciiz "! "
printzero:		.asciiz "0 "
printone:		.asciiz "1 "
printtwo:		.asciiz "2 "
printthree:		.asciiz "3 "
printfour:		.asciiz "4 "
printfive:		.asciiz "5 "
printsix:		.asciiz "6 "
printseven:		.asciiz "7 "
printeight:		.asciiz "8 "
printnine:		.asciiz "9 "
printa:			.asciiz "a "
printb:			.asciiz "b "
printc:			.asciiz "c "
printd:			.asciiz "d "
printe:			.asciiz "e "
printf:			.asciiz "f "
printg:			.asciiz "g "
printh:			.asciiz "h "
printi:			.asciiz "i "
printgamelogic1:	.asciiz "\nDidn't step on the flag\n\n"
printgamelogic2:	.asciiz "\n\nGame Over. Stepped on a mine.\n\n"
printgamelogic3:	.asciiz "\n\nYou win! You cleared the board.\n\n"
printgamelogic4:	.asciiz "\n\nFlags remaining: "
    .text
	.globl main


main:

# Game status register
	add $s6, $zero, $zero

# Create array with 81 bytes saving guesses (9x9 board)
# $s3 array of guesses
# Value of 0 is blank, 1-8 is adjacent mine, 10 is mine, 11 is flag, 12 is untouched, 13 is stepped mine
    li $v0, 9
    li $a0, 81
    syscall
    move $s3, $v0   # byte with board (a,1)
    addi $t0, $zero, 81
    addi $t1, $zero, 12
    iniboard:
        subi $t0, $t0, 1
    	add $t2, $s3, $t0
    	sb $t1, 0($t2)
    	bne $t0, $zero, iniboard
    
# Create array with 81 bytes saving mines
# Value of 1 means a mine is there
# $s4 array of mines
# $t0 mines used
    li $v0, 9
    li $a0, 81
    syscall
    move $s4, $v0   # dynamic memory allocation
    addi $t0, $zero, 10
    add $t3, $zero, $t0	# random num array index
    addi $t1, $zero, 81
    inimines:		# fill with zeroes
        subi $t1, $t1, 1
    	add $t2, $s4, $t1
    	sb $zero, 0($t2)
    	bne $t1, $zero, inimines
    # Entries can't be repeated, search before entry
    nextmine:
    	li $a0, 1
	li $a1, 80
    	li $v0, 42
    	syscall
    	add $t0, $a0, $s4   # random mine address
    	lb $t4, 0($t0)
    	addi $t5, $zero, 1
    	beq $t4, $t5, nextmine	# if block has value of 1, get another address
	sb $t5, 0($t0)		# else put value 1 in address

	# UNCOMMENT THIS SECTION TO GET MINE PLACEMENT INFORMATION	
	#li $v0, 1
	#syscall
	#li $v0, 4
	#la $a0, printnewline
	#syscall
	#li $v0, 4
	#la $a0, printnewline
	#syscall
    
    	subi $t3, $t3, 1
    	bne $t3, $zero, nextmine
    
# Create array with 81 bytes saving flags
# Value of 1 means a flag is there
# $s5 array of flags
# $s7 flags remaining
	addi $s7, $zero, 10
    li $v0, 9
    li $a0, 81
    syscall
    move $s5, $v0   # dynamic memory allocation

playing:

# Print board
	addi $t0, $zero, 10	# row index
	rows:
		addi $t1, $zero, 10	# column index
		columns:
			addi $t2, $zero, 10
			bne $t2, $t0, skipPrintColumns
			bne $t2, $t1, aCol			# Print out column markers
				li $v0, 4
				la $a0, printblank
				syscall
				j skipPrintBlock
			aCol:
			addi $t2, $zero, 9
			bne $t2, $t1, bCol
				li $v0, 4
				la $a0, printa
				syscall
				j skipPrintBlock
			bCol:
			addi $t2, $zero, 8
			bne $t2, $t1, cCol
				li $v0, 4
				la $a0, printb
				syscall
				j skipPrintBlock
			cCol:
			addi $t2, $zero, 7
			bne $t2, $t1, dCol
				li $v0, 4
				la $a0, printc
				syscall
				j skipPrintBlock
			dCol:
			addi $t2, $zero, 6
			bne $t2, $t1, eCol
				li $v0, 4
				la $a0, printd
				syscall
				j skipPrintBlock
			eCol:
			addi $t2, $zero, 5
			bne $t2, $t1, fCol
				li $v0, 4
				la $a0, printe
				syscall
				j skipPrintBlock
			fCol:
			addi $t2, $zero, 4
			bne $t2, $t1, gCol
				li $v0, 4
				la $a0, printf
				syscall
				j skipPrintBlock
			gCol:
			addi $t2, $zero, 3
			bne $t2, $t1, hCol
				li $v0, 4
				la $a0, printg
				syscall
				j skipPrintBlock
			hCol:
			addi $t2, $zero, 2
			bne $t2, $t1, iCol
				li $v0, 4
				la $a0, printh
				syscall
				j skipPrintBlock
			iCol:
			addi $t2, $zero, 1
			bne $t2, $t1, skipPrintColumns
				li $v0, 4
				la $a0, printi
				syscall
				j skipPrintBlock
			skipPrintColumns:
			addi $t2, $zero, 10		# Print out row markers
			bne $t2, $t1, skipPrintRows
			addi $t2, $zero, 9
			bne $t2, $t0, row2
				li $v0, 4
				la $a0, printone
				syscall
				j skipPrintBlock
			row2:
			addi $t2, $zero, 8
			bne $t2, $t0, row3
				li $v0, 4
				la $a0, printtwo
				syscall
				j skipPrintBlock
			row3:
			addi $t2, $zero, 7
			bne $t2, $t0, row4
				li $v0, 4
				la $a0, printthree
				syscall
				j skipPrintBlock
			row4:
			addi $t2, $zero, 6
			bne $t2, $t0, row5
				li $v0, 4
				la $a0, printfour
				syscall
				j skipPrintBlock
			row5:
			addi $t2, $zero, 5
			bne $t2, $t0, row6
				li $v0, 4
				la $a0, printfive
				syscall
				j skipPrintBlock
			row6:
			addi $t2, $zero, 4
			bne $t2, $t0, row7
				li $v0, 4
				la $a0, printsix
				syscall
				j skipPrintBlock
			row7:
			addi $t2, $zero, 3
			bne $t2, $t0, row8
				li $v0, 4
				la $a0, printseven
				syscall
				j skipPrintBlock
			row8:
			addi $t2, $zero, 2
			bne $t2, $t0, row9
				li $v0, 4
				la $a0, printeight
				syscall
				j skipPrintBlock
			row9:
			addi $t2, $zero, 1
			bne $t2, $t0, skipPrintRows
				li $v0, 4
				la $a0, printnine
				syscall
				j skipPrintBlock
			skipPrintRows:
			subi $t3, $t0, 1		# block_index = (max_row_amount) * (row_index - 1) + (column_index - 1)
			addi $t4, $zero, 9
			mul $t5, $t3, $t4
			subi $t7, $t1, 1
			add $t5, $t7, $t5
			add $t5, $t5, $s3
			lb $t6, 0($t5)
			blank:				# determine if block is untouched, blank, adjacent, etc
			add $t2, $zero, $zero
			bne $t6, $t2, adj1
				li $v0, 4
				la $a0, printzero
				syscall
				j skipPrintBlock
			adj1:
			addi $t2, $zero, 1
			bne $t6, $t2, adj2
				li $v0, 4
				la $a0, printone
				syscall
				j skipPrintBlock
			adj2:
			addi $t2, $zero, 2
			bne $t6, $t2, adj3
				li $v0, 4
				la $a0, printtwo
				syscall
				j skipPrintBlock
			adj3:
			addi $t2, $zero, 3
			bne $t6, $t2, adj4
				li $v0, 4
				la $a0, printthree
				syscall
				j skipPrintBlock
			adj4:
			addi $t2, $zero, 4
			bne $t6, $t2, adj5
				li $v0, 4
				la $a0, printfour
				syscall
				j skipPrintBlock
			adj5:
			addi $t2, $zero, 5
			bne $t6, $t2, adj6
				li $v0, 4
				la $a0, printfive
				syscall
				j skipPrintBlock
			adj6:
			addi $t2, $zero, 6
			bne $t6, $t2, adj7
				li $v0, 4
				la $a0, printsix
				syscall
				j skipPrintBlock
			adj7:
			addi $t2, $zero, 7
			bne $t6, $t2, adj8
				li $v0, 4
				la $a0, printseven
				syscall
				j skipPrintBlock
			adj8:
			addi $t2, $zero, 8
			bne $t6, $t2, mine
				li $v0, 4
				la $a0, printeight
				syscall
				j skipPrintBlock
			mine:
			addi $t2, $zero, 10
			bne $t6, $t2, flag
				li $v0, 4
				la $a0, printmine
				syscall
				j skipPrintBlock
			flag:
			addi $t2, $zero, 11
			bne $t6, $t2, untouched
				li $v0, 4
				la $a0, printflag
				syscall
				j skipPrintBlock
			untouched:
			addi $t2, $zero, 12
			bne $t6, $t2, steppedmine
				li $v0, 4
				la $a0, printuntouched
				syscall
				j skipPrintBlock
			steppedmine:
			addi $t2, $zero, 13
			bne $t6, $t2, skipPrintBlock
				li $v0, 4
				la $a0, printsteppedmine
				syscall
				j skipPrintBlock
			skipPrintBlock:
			subi $t1, $t1, 1
			bne $t1, $zero, columns
		li $v0, 4
		la $a0, printnewline
		syscall
		subi $t0, $t0, 1
		bne $t0, $zero, rows
	beq $s6, $zero, prompt

# Game logic
# $s6 game status register
# 1 stepped on flag, 2 stepped on mine, 3 cleared board, 4 flag update, 6 check win, 7 show mines
	gamelogic:
	flagstep:
	addi $t0, $zero, 1
	bne $s6, $t0, loss
		li $v0, 4
		la $a0, printgamelogic1
		syscall
		add $s6, $zero, $zero
		j playing
	loss:
	addi $t0, $zero, 2
	bne $s6, $t0, win
		li $v0, 4
		la $a0, printgamelogic2
		syscall
		addi $s6, $zero, 7
		j printmines
	win:
	addi $t0, $zero, 3
	bne $s6, $t0, flagupdate
		li $v0, 4
		la $a0, printgamelogic3
		syscall
		addi $s6, $zero, 7
		j printmines
	flagupdate:
	addi $t0, $zero, 4
	bne $s6, $t0, wincheck
		li $v0, 4
		la $a0, printgamelogic4
		syscall
		li $v0, 1
		move $a0, $s7
		syscall
		li $v0, 4
		la $a0, printnewline
		syscall
		li $v0, 4
		la $a0, printnewline
		syscall
		add $s6, $zero, $zero
		j nextround
	wincheck:
	addi $t0, $zero, 6
	bne $s6, $t0, skipGameLogic
		addi $t1, $zero, 81
		add $t9, $zero, $zero 
		nextblock:		# check if all board blocks below 10 or they are untouched/flagged mines
        	subi $t1, $t1, 1
	    	add $t2, $s4, $t1
    		lb $t3, 0($t2)
    		add $t7, $s3, $t1
    		lb $t6, 0($t7)
    		addi $t4, $zero, 1
    		addi $t8, $zero, 12
    		addi $t5, $zero, 11
    		bne $t3, $t4, skiptests
    		beq $t6, $t8, skiptests3
    		bne $t6, $t5, skiptests
    		skiptests3:
    		addi $t9, $t9, 1
    		j skiptests2
    		skiptests:
    		sltiu $t4, $t6, 10
    		addi $t5, $zero, 1
    		bne $t4, $t5, skiptests2
    		addi $t9, $t9, 1
    		skiptests2:
    		bne $t1, $zero, nextblock
    		addi $t1, $zero, 81
    		bne $t1, $t9, nowin
    		addi $s6, $zero, 3
    		j win
    		nowin:
    		add $s6, $zero, $zero
		j skipGameLogic
	printmines:
	addi $t0, $zero, 7
	bne $s6, $t0, skipGameLogic
		addi $t1, $zero, 81
		nextblock2:		# find remaining untouched mines and reveal
        	subi $t1, $t1, 1
	    	add $t2, $s4, $t1
    		lb $t3, 0($t2)
    		add $t7, $s3, $t1
    		lb $t6, 0($t7)
    		addi $t4, $zero, 1
    		addi $t5, $zero, 10
    		addi $t8, $zero, 13
    		bne $t3, $t4, printminesnotmine
    		beq $t6, $t8, printminesnotmine
    		sb $t5, 0($t7)
    		printminesnotmine:
    		bne $t1, $zero, nextblock2
    		add $s6, $zero, $zero
    		j out
	skipGameLogic:

# Enter in command into 6 byte buffer
	prompt:
    li $v0, 4
    la $a0, getCommand
    syscall
    li $v0, 4
    la $a0, enterCommand
    syscall
    li $v0, 8
    la $a0, buffer
    li $a1, 6
    syscall
    lb $s0, 0($a0)  # byte indicating step or flag
    lb $s1, 2($a0)  # byte indicating column
    lb $s2, 4($a0)  # byte indicating row
    li $v0, 4
    la $a0, printnewline
    syscall
    li $v0, 4
    la $a0, printnewline
    syscall
    
    subi $s2, $s2, 49			# ascii offset '1'
    subi $s1, $s1, 97			# ascii offset 'a'
    sltiu $t0, $s1, 9
    sltiu $t1, $s2, 9
    beq $t0, $zero, prompt		# if column not between 1 and 9, ask again
    beq $t1, $zero, prompt		# if row not between 1 and 9, ask again
    addi $s1, $s1, 1
    addi $s2, $s2, 1
    addi $t0, $zero, 10
    sub $s1, $t0, $s1
    sub $s2, $t0, $s2
    li $t0, 's'				# if step command, go to branch block
    beq $t0, $s0, handlestep
    li $t0, 'f'				# if flag command, go to flag block
    beq $t0, $s0, handleflag
    li $t0, 'q'				# if q command, quit
    beq $t0, $s0, out
    j prompt				# else ask again
    
# Handle flag
	handleflag:
	addi $s6, $zero, 4
	addi $t8, $zero, 11
	addi $t9, $zero, 12
	subi $t3, $s2, 1		# block_index = (max_row_amount) * (row_index - 1) + (column_index - 1)
	addi $t4, $zero, 9
	mul $t5, $t3, $t4
	subi $t7, $s1, 1
	add $t5, $t7, $t5
	add $t2, $t5, $s3
	lb $t6, 0($t2)
	bne $t6, $t9, unset		# if untouched, flag it
	beq $s7, $zero, nextround
	sb $t8, 0($t2)
	add $t2, $t5, $s5
	addi $t8, $zero, 1
	sb $t8, 0($t2)
	subi $s7, $s7, 1
	j gamelogic
	unset:
	bne $t6, $t8, nextround		# if flagged, unflag it
	sb $t9, 0($t2)
	add $t2, $t5, $s5
	sb $zero, 0($t2)
	addi $s7, $s7, 1
	j gamelogic

# Handle step
	handlestep:
	subi $t3, $s2, 1		# block_index = (max_row_amount) * (row_index - 1) + (column_index - 1)
	addi $t4, $zero, 9
	mul $t5, $t3, $t4
	subi $t7, $s1, 1
	add $t5, $t7, $t5
	add $t2, $t5, $s4
	lb $t6, 0($t2)
	add $t9, $t5, $s5
	lb $t8, 0($t9)
	addi $t0, $zero, 1
	bne $t8, $t0, ismine		# if flag is there, don't step
	addi $s6, $zero, 1
	j playing
	ismine:
	bne $t0, $t6, notmine		# if the stepped block is a mine
	addi $t1, $zero, 13
	add $t2, $t5, $s3
	sb $t1, 0($t2)
	addi $s6, $zero, 2
	j playing
	notmine:
		cornercases:
			zero:
			add $t0, $zero, $zero
			bne $t5, $t0, eight
				add $t9, $zero, $zero
				add $t7, $t5, $s4
				addi $t8, $t7, 1	# Check left
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				addi $t8, $t7, 9	# Check top
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				addi $t8, $t7, 10	# Check top left
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				add $t2, $t5, $s3	# Save counts to square
				sb $t9, 0($t2)
				j skipCases
			eight:
			addi $t0, $zero, 8
			bne $t5, $t0, seventytwo
				add $t9, $zero, $zero
				add $t7, $t5, $s4
				subi $t8, $t7, 1	# Check right
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				addi $t8, $t7, 9	# Check top
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				addi $t8, $t7, 8	# Check top right
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				add $t2, $t5, $s3	# Save counts to square
				sb $t9, 0($t2)
				j skipCases
			seventytwo:
			addi $t0, $zero, 72
			bne $t5, $t0, eighty
				add $t9, $zero, $zero
				add $t7, $t5, $s4
				addi $t8, $t7, 1	# Check left
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				subi $t8, $t7, 9	# Check bottom
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				subi $t8, $t7, 8	# Check bottom left
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				add $t2, $t5, $s3	# Save counts to square
				sb $t9, 0($t2)
				j skipCases
			eighty:
			addi $t0, $zero, 80
			bne $t5, $t0, edgecases
				add $t9, $zero, $zero
				add $t7, $t5, $s4
				subi $t8, $t7, 1	# Check right
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				subi $t8, $t7, 9	# Check bottom
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				subi $t8, $t7, 10	# Check bottom right
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				add $t2, $t5, $s3	# Save counts to square
				sb $t9, 0($t2)
				j skipCases
		edgecases:
			leftedge:
			addi $t0, $zero, 9
			bne $s1, $t0, rightedge
				add $t9, $zero, $zero
				add $t7, $t5, $s4
				subi $t8, $t7, 1	# Check right
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				subi $t8, $t7, 9	# Check bottom
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				subi $t8, $t7, 10	# Check bottom right
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				addi $t8, $t7, 9	# Check top
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				addi $t8, $t7, 8	# Check top right
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				add $t2, $t5, $s3	# Save counts to square
				sb $t9, 0($t2)
				j skipCases
			rightedge:
			addi $t0, $zero, 1
			bne $s1, $t0, topedge
				add $t9, $zero, $zero
				add $t7, $t5, $s4
				addi $t8, $t7, 1	# Check left
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				subi $t8, $t7, 9	# Check bottom
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				subi $t8, $t7, 8	# Check bottom left
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				addi $t8, $t7, 9	# Check top
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				addi $t8, $t7, 10	# Check top left
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				add $t2, $t5, $s3	# Save counts to square
				sb $t9, 0($t2)
				j skipCases
			topedge:
			addi $t0, $zero, 9
			bne $s2, $t0, bottomedge
				add $t9, $zero, $zero
				add $t7, $t5, $s4
				addi $t8, $t7, 1	# Check left
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				subi $t8, $t7, 9	# Check bottom
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				subi $t8, $t7, 8	# Check bottom left
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				subi $t8, $t7, 1	# Check right
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				subi $t8, $t7, 10	# Check bottom right
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				add $t2, $t5, $s3	# Save counts to square
				sb $t9, 0($t2)
				j skipCases
			bottomedge:
			addi $t0, $zero, 1
			bne $s2, $t0, middlecases
				add $t9, $zero, $zero
				add $t7, $t5, $s4
				addi $t8, $t7, 1	# Check left
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				addi $t8, $t7, 9	# Check top
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				addi $t8, $t7, 10	# Check top left
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				subi $t8, $t7, 1	# Check right
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				addi $t8, $t7, 8	# Check top right
				lb $t4, 0($t8)
				add $t9, $t9, $t4
				add $t2, $t5, $s3	# Save counts to square
				sb $t9, 0($t2)
				j skipCases
		middlecases:
			add $t9, $zero, $zero
			add $t7, $t5, $s4
			addi $t8, $t7, 1	# Check left
			lb $t4, 0($t8)
			add $t9, $t9, $t4
			addi $t8, $t7, 9	# Check top
			lb $t4, 0($t8)
			add $t9, $t9, $t4
			addi $t8, $t7, 10	# Check top left
			lb $t4, 0($t8)
			add $t9, $t9, $t4
			subi $t8, $t7, 1	# Check right
			lb $t4, 0($t8)
			add $t9, $t9, $t4
			addi $t8, $t7, 8	# Check top right
			lb $t4, 0($t8)
			add $t9, $t9, $t4
			subi $t8, $t7, 8	# Check bottom left
			lb $t4, 0($t8)
			add $t9, $t9, $t4
			subi $t8, $t7, 9	# Check bottom
			lb $t4, 0($t8)
			add $t9, $t9, $t4
			subi $t8, $t7, 10	# Check bottom right
			lb $t4, 0($t8)
			add $t9, $t9, $t4
			add $t2, $t5, $s3	# Save counts to square
			sb $t9, 0($t2)
			j skipCases
		skipCases:
# Game winning logic	
# Take the next command
	nextround:
	addi $s6, $zero, 6
	j playing
        
# Prompt for game to restart from beginning
out:
    li $v0, 4
    la $a0, getRestart
    syscall
    li $v0, 5
    syscall
    add $t0, $v0, $zero
    beq $t0, $zero, main
# Exit
    li $v0, 10
    syscall

