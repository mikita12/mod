# Numbers of kernel functions.
EXIT_NR  = 1
READ_NR  = 3
WRITE_NR = 4

STDIN  = 0
STDOUT = 1
EXIT_CODE_SUCCESS = 0


.data
	
	inputLen = 0xfffffff
	.lcomm input, inputLen
	readb: .space 4
        .lcomm offset, 4	

	mod1Len = 4
	mod1: .int (1 << 30) - 1
	mod2Len = 4
	mod2: .int (1 << 30) 
	mod3Len = 4
	mod3: .int (1 << 30) + 1

	.lcomm r1, mod1Len
	.lcomm r2, mod2Len
	.lcomm r3, mod3Len


.text

#.global _start
#_start:

.global forward
forward:

pushl %ebp
movl %esp,%ebp
subl $80,%esp
pushl %edi
pushl %esi
pushl %ebx


mov $READ_NR , %eax 
mov $STDIN   , %ebx 
mov $input   , %ecx 
mov $inputLen, %edx 
int $0x80

mov %eax, readb
mov $0, %ebx
mov %ebx, offset

mov offset, %esi
mov readb, %edi

programLoop:
#	int3

	cmp %edi, %esi
	jge endProgram
	
	
	mov input(%esi), %eax
	mov $0, %edx
	mov mod1, %ebx
	div %ebx
	mov %edx, r1
	
	
	mov input(%esi), %eax
	mov $0, %edx
	mov mod2, %ebx
	div %ebx
	mov %edx, r2

	mov input(%esi), %eax
	mov $0, %edx
	mov mod3, %ebx
	div %ebx
	mov %edx, r3

	mov $WRITE_NR, %eax 
	mov $STDOUT  , %ebx 
	mov $r1      , %ecx 
	mov $mod1Len , %edx 
	int $0x80

	mov $WRITE_NR, %eax 
	mov $STDOUT  , %ebx 
	mov $r2      , %ecx 
	mov $mod2Len , %edx 
	int $0x80

	mov $WRITE_NR, %eax 
	mov $STDOUT  , %ebx 
	mov $r3      , %ecx 
	mov $mod3Len , %edx 
	int $0x80
	
	add $4,%esi
	
jmp programLoop

endProgram:

movl %edi,%eax
xorl %eax,%eax
popl %ebx
popl %esi
popl %edi
leave 
ret

#mov $1,%eax
#mov $0,%ebx
#int $0x80
