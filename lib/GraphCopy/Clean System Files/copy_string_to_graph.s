	.file	"copy_string_to_graph.c"
	.text
	.type	copy, @function
copy:
.LFB15:

	testq	%rdx, %rdx
	jle	.L1
	movl	$0, %eax
.L3:
	movq	(%rsi,%rax,8), %rcx
	movq	%rcx, (%rdi,%rax,8)
	addq	$1, %rax
	cmpq	%rax, %rdx
	jne	.L3
.L1:
	rep ret

.LFE15:
	.size	copy, .-copy
	.globl	copy_string_to_graph
	.type	copy_string_to_graph, @function
copy_string_to_graph:
.LFB16:

	pushq	%r15


	pushq	%r14


	pushq	%r13


	pushq	%r12


	pushq	%rbp


	pushq	%rbx


	subq	$120, %rsp

	movq	%rsi, %rbx
	movq	%rdx, %rax
	movq	%rdx, (%rsp)
	movq	%rcx, 24(%rsp)
	movq	%fs:40, %rsi
	movq	%rsi, 104(%rsp)
	xorl	%esi, %esi
	leaq	16(%rdi), %rbp
	subq	%rbx, %rax
	sarq	$3, %rax
	movq	%rax, %r14
	movq	%rdx, 8(%rsp)
	movq	%rdx, %r15
	leaq	96(%rsp), %r12
.L6:
	movq	0(%rbp), %rax
	movq	%r14, %rdi
	subq	$1, %rdi
	jns	.L7
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	leaq	8(%rbx,%rax), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	1(%rbp), %rax
	jmp	.L8
.L7:
	testb	$1, %al
	jne	.L9
	movq	%rbx, 0(%rbp)
	movq	%rbx, (%r12)
	movq	%rax, (%rbx)
	testb	$2, %al
	je	.L10
	movzwl	-2(%rax), %ecx
	testq	%rcx, %rcx
	jne	.L11
	cmpq	$dINT+2, %rax
	jne	.L12
	movq	8(%rbp), %rax
	cmpq	$32, %rax
	ja	.L13
	salq	$4, %rax
	addq	$small_integers, %rax
	movq	%rax, (%r12)
	movq	%rax, 0(%rbp)
	jmp	.L14
.L13:
	subq	$2, %r14
	jns	.L15
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	leaq	16(%rbx,%rax), %rax
	movq	24(%rsp), %rcx
	movq	%rax, (%rcx)
	leaq	9(%rbp), %rax
	jmp	.L8
.L15:
	movq	%rax, 8(%rbx)
	addq	$16, %rbx
.L14:
	addq	$16, %rbp
	jmp	.L16
.L12:
	cmpq	$CHAR+2, %rax
	jne	.L17
	movzbl	8(%rbp), %eax
	salq	$4, %rax
	addq	$static_characters, %rax
	movq	%rax, (%r12)
	movq	%rax, 0(%rbp)
	addq	$16, %rbp
	jmp	.L16
.L17:
	cmpq	$BOOL+2, %rax
	je	.L18
	cmpq	$REAL+2, %rax
	jne	.L19
.L18:
	subq	$2, %r14
	jns	.L20
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	leaq	16(%rbx,%rax), %rax
	movq	24(%rsp), %rcx
	movq	%rax, (%rcx)
	leaq	9(%rbp), %rax
	jmp	.L8
.L20:
	movq	8(%rbp), %rax
	movq	%rax, 8(%rbx)
	addq	$16, %rbp
	addq	$16, %rbx
	jmp	.L16
.L19:
	cmpq	$__STRING__+2, %rax
	jne	.L21
	movq	8(%rbp), %rax
	addq	$16, %rbp
	leaq	7(%rax), %r12
	shrq	$3, %r12
	subq	$1, %rdi
	subq	%r12, %rdi
	movq	%rdi, %r14
	testq	%rdi, %rdi
	jns	.L22
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	leaq	16(%rbx,%rax), %rax
	movq	24(%rsp), %rcx
	movq	%rax, (%rcx)
	leaq	1(%rbp), %rax
	jmp	.L8
.L22:
	movq	%rax, 8(%rbx)
	addq	$16, %rbx
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	copy
	salq	$3, %r12
	addq	%r12, %rbp
	addq	%r12, %rbx
	jmp	.L16
.L21:
	cmpq	$__ARRAY__+2, %rax
	jne	.L23
	subq	$3, %r14
	jns	.L24
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	leaq	24(%rbx,%rax), %rax
	movq	24(%rsp), %rcx
	movq	%rax, (%rcx)
	leaq	9(%rbp), %rax
	jmp	.L8
.L24:
	movq	8(%rbp), %r13
	movq	16(%rbp), %rax
	addq	$24, %rbp
	movq	%r13, 8(%rbx)
	movq	%rax, 16(%rbx)
	leaq	24(%rbx), %rsi
	movq	%rsi, 16(%rsp)
	testq	%rax, %rax
	jne	.L25
	movq	%r13, %rax
	leaq	0(,%r13,8), %rdx
	subq	%rdx, %r15
	movq	8(%rsp), %rcx
	cmpq	%r15, %rcx
	jbe	.L26
	subq	%r15, %rcx
	sarq	$3, %rcx
	subq	%rcx, %r14
	jns	.L90
	movq	(%rsp), %rdx
	subq	%r15, %rdx
	sarq	$3, %rdx
	addq	%rdx, %rax
	movq	16(%rsp), %rsi
	leaq	(%rsi,%rax,8), %rax
	movq	24(%rsp), %rcx
	movq	%rax, (%rcx)
	leaq	1(%rbp), %rax
	jmp	.L8
.L90:
	movq	%r15, 8(%rsp)
.L26:
	subq	$1, %r13
	js	.L27
	leaq	16(%rbx,%rdx), %rax
.L28:
	movq	%rax, (%r15,%r13,8)
	subq	$1, %r13
	subq	$8, %rax
	cmpq	$-1, %r13
	jne	.L28
.L27:
	movq	16(%rsp), %rbx
	addq	%rdx, %rbx
	jmp	.L16
.L25:
	movl	$REAL+2, %edx
	cmpq	%rax, %rdx
	je	.L98
	movl	$dINT+2, %esi
	cmpq	%rax, %rsi
	jne	.L29
.L98:
	subq	%r13, %r14
	jns	.L31
	movq	(%rsp), %rbx
	subq	8(%rsp), %rbx
	sarq	$3, %rbx
	addq	%r13, %rbx
	movq	16(%rsp), %rax
	leaq	(%rax,%rbx,8), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	1(%rbp), %rax
	jmp	.L8
.L31:
	movq	%r13, %rdx
	movq	%rbp, %rsi
	movq	16(%rsp), %r12
	movq	%r12, %rdi
	call	copy
	leaq	0(,%r13,8), %rbx
	addq	%rbx, %rbp
	addq	%r12, %rbx
	jmp	.L16
.L29:
	movl	$BOOL+2, %edx
	cmpq	%rax, %rdx
	jne	.L32
	leaq	7(%r13), %rbx
	sarq	$3, %rbx
	subq	%rbx, %r14
	jns	.L33
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	sarq	$3, %rax
	addq	%rax, %rbx
	movq	16(%rsp), %rax
	leaq	(%rax,%rbx,8), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	1(%rbp), %rax
	jmp	.L8
.L33:
	movq	%rbx, %rdx
	movq	%rbp, %rsi
	movq	16(%rsp), %r13
	movq	%r13, %rdi
	call	copy
	salq	$3, %rbx
	addq	%rbx, %rbp
	addq	%r13, %rbx
	jmp	.L16
.L32:
	movzwl	(%rax), %ecx
	movzwl	%cx, %edx
	movzwl	-2(%rax), %eax
	subq	$256, %rax
	testq	%rdx, %rdx
	jne	.L34
	movq	%r13, %rbx
	imulq	%rax, %rbx
	subq	%rbx, %r14
	jns	.L35
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	sarq	$3, %rax
	addq	%rax, %rbx
	movq	16(%rsp), %rax
	leaq	(%rax,%rbx,8), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	1(%rbp), %rax
	jmp	.L8
.L35:
	movq	%rbx, %rdx
	movq	%rbp, %rsi
	movq	16(%rsp), %r13
	movq	%r13, %rdi
	call	copy
	salq	$3, %rbx
	addq	%rbx, %rbp
	addq	%r13, %rbx
	jmp	.L16
.L34:
	cmpq	%rax, %rdx
	jne	.L36
	imulq	%r13, %rdx
	leaq	0(,%rdx,8), %rsi
	subq	%rsi, %r15
	movq	8(%rsp), %rax
	cmpq	%r15, %rax
	jbe	.L37
	subq	%r15, %rax
	sarq	$3, %rax
	subq	%rax, %r14
	jns	.L91
	movq	(%rsp), %rax
	subq	%r15, %rax
	sarq	$3, %rax
	addq	%rdx, %rax
	movq	16(%rsp), %rcx
	leaq	(%rcx,%rax,8), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	1(%rbp), %rax
	jmp	.L8
.L91:
	movq	%r15, 8(%rsp)
.L37:
	movq	%rdx, %rax
	subq	$1, %rax
	js	.L38
	leaq	16(%rbx,%rdx,8), %rdx
.L39:
	movq	%rdx, (%r15,%rax,8)
	subq	$1, %rax
	subq	$8, %rdx
	cmpq	$-1, %rax
	jne	.L39
.L38:
	movq	16(%rsp), %rbx
	addq	%rsi, %rbx
	jmp	.L16
.L36:
	movq	%rax, %rsi
	subq	%rdx, %rsi
	movq	%rsi, 32(%rsp)
	imulq	%r13, %rax
	subq	%rax, %r14
	jns	.L40
	movq	(%rsp), %rdx
	subq	8(%rsp), %rdx
	sarq	$3, %rdx
	addq	%rdx, %rax
	movq	16(%rsp), %rsi
	leaq	(%rsi,%rax,8), %rax
	movq	24(%rsp), %rcx
	movq	%rax, (%rcx)
	leaq	1(%rbp), %rax
	jmp	.L8
.L40:
	movq	%r13, %rax
	imulq	%rdx, %rax
	salq	$3, %rax
	subq	%rax, %r15
	movq	8(%rsp), %rax
	cmpq	%r15, %rax
	jbe	.L41
	subq	%r15, %rax
	sarq	$3, %rax
	subq	%rax, %r14
	jns	.L92
	movq	(%rsp), %rax
	subq	%r15, %rax
	addq	16(%rsp), %rax
	movq	24(%rsp), %rcx
	movq	%rax, (%rcx)
	leaq	1(%rbp), %rax
	jmp	.L8
.L92:
	movq	%r15, 8(%rsp)
.L41:
	testq	%r13, %r13
	jle	.L93
	movzwl	%cx, %eax
	movq	%rax, 72(%rsp)
	salq	$3, %rax
	movq	%rax, 56(%rsp)
	movq	32(%rsp), %rsi
	salq	$3, %rsi
	movq	%rsi, %rcx
	movq	%rsi, 48(%rsp)
	movq	%rax, %rsi
	addq	%rcx, %rax
	movq	%rax, 40(%rsp)
	leaq	24(%rbx,%rsi), %r12
	leaq	-1(%rdx), %rax
	movq	%rax, 64(%rsp)
	movq	%r15, %rbx
	movl	$0, %eax
	movq	%rbp, 80(%rsp)
	movq	%r15, 88(%rsp)
	movq	%rax, %r15
	jmp	.L42
.L43:
	movq	%rdx, -8(%rbx,%rax,8)
	subq	$8, %rdx
	subq	$1, %rax
	jne	.L43
.L44:
	addq	56(%rsp), %rbx
	movq	32(%rsp), %rdx
	movq	%rbp, %rsi
	movq	%r12, %rdi
	call	copy
	addq	48(%rsp), %rbp
	addq	$1, %r15
	addq	40(%rsp), %r12
	cmpq	%r15, %r13
	jne	.L42
	movq	80(%rsp), %rbp
	movq	88(%rsp), %r15
	movq	40(%rsp), %rbx
	imulq	%r13, %rbx
	addq	16(%rsp), %rbx
	imulq	48(%rsp), %r13
	addq	%r13, %rbp
	jmp	.L16
.L42:
	cmpq	$0, 64(%rsp)
	js	.L44
	leaq	-8(%r12), %rdx
	movq	72(%rsp), %rax
	jmp	.L43
.L23:
	subq	$10, %rax
	movq	%rax, (%r12)
	movq	%rax, 0(%rbp)
	addq	$8, %rbp
	jmp	.L16
.L11:
	cmpq	$1, %rcx
	jne	.L45
	subq	$2, %r14
	jns	.L46
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	leaq	16(%rbx,%rax), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	9(%rbp), %rax
	jmp	.L8
.L46:
	leaq	8(%rbx), %r12
	addq	$8, %rbp
	addq	$16, %rbx
	jmp	.L6
.L45:
	cmpq	$2, %rcx
	jne	.L48
	movq	%r14, %rax
	subq	$3, %rax
	jns	.L49
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	leaq	24(%rbx,%rax), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	9(%rbp), %rax
	jmp	.L8
.L49:
	cmpq	8(%rsp), %r15
	ja	.L50
	movq	%r14, %rax
	subq	$4, %rax
	jns	.L51
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	leaq	16(%rbx,%rax), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	9(%rbp), %rax
	jmp	.L8
.L51:
	subq	$8, 8(%rsp)
.L50:
	leaq	16(%rbx), %rdx
	movq	%rdx, -8(%r15)
	leaq	8(%rbx), %r12
	addq	$8, %rbp
	addq	$24, %rbx
	movq	%rax, %r14
	leaq	-8(%r15), %r15
	jmp	.L6
.L48:
	cmpq	$255, %rcx
	ja	.L52
	subq	$1, %rdi
	subq	%rcx, %rdi
	movq	%rdi, %r14
	testq	%rdi, %rdi
	jns	.L53
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	sarq	$3, %rax
	leaq	2(%rcx,%rax), %rax
	leaq	(%rbx,%rax,8), %rax
	movq	24(%rsp), %rcx
	movq	%rax, (%rcx)
	leaq	9(%rbp), %rax
	jmp	.L8
.L53:
	leaq	8(%rbx), %r12
	leaq	24(%rbx), %rsi
	movq	%rsi, 16(%rbx)
	leaq	-1(%rcx), %rax
	leaq	0(,%rax,8), %rdx
	subq	%rdx, %r15
	movq	8(%rsp), %rdx
	cmpq	%r15, %rdx
	jbe	.L54
	movq	%rdx, %r8
	subq	%r15, %rdx
	sarq	$3, %rdx
	subq	%rdx, %rdi
	movq	%rdi, %r14
	jns	.L94
	movq	(%rsp), %rax
	subq	%r8, %rax
	sarq	$3, %rax
	addq	%rcx, %rax
	leaq	-8(%rsi,%rax,8), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	9(%rbp), %rax
	jmp	.L8
.L94:
	movq	%r15, 8(%rsp)
.L54:
	leaq	-1(%rax), %rdi
	leaq	0(,%rdi,8), %rdx
	leaq	(%rsi,%rdx), %r8
	movq	%r8, (%r15,%rdi,8)
	leaq	-8(%rsi,%rdx), %rdi
	movq	%rdi, -8(%r15,%rdx)
	subq	$3, %rax
	js	.L55
	leaq	-8(%rbx,%rcx,8), %rdx
.L56:
	movq	%rdx, (%r15,%rax,8)
	subq	$8, %rdx
	subq	$1, %rax
	jns	.L56
.L55:
	leaq	-8(%rsi,%rcx,8), %rbx
	addq	$8, %rbp
	jmp	.L6
.L52:
	movzwl	(%rax), %edx
	movzwl	%dx, %r13d
	leaq	-256(%rcx), %rax
	cmpq	$1, %rax
	jne	.L57
	subq	$2, %r14
	jns	.L58
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	leaq	16(%rbx,%rax), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	9(%rbp), %rax
	jmp	.L8
.L58:
	testq	%r13, %r13
	jne	.L59
	movq	8(%rbp), %rax
	movq	%rax, 8(%rbx)
	addq	$16, %rbp
	addq	$16, %rbx
	jmp	.L16
.L59:
	leaq	8(%rbx), %r12
	addq	$8, %rbp
	addq	$16, %rbx
	jmp	.L6
.L57:
	cmpq	$2, %rax
	jne	.L60
	movq	%r14, %rax
	subq	$3, %rax
	jns	.L61
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	leaq	24(%rbx,%rax), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	9(%rbp), %rax
	jmp	.L8
.L61:
	testq	%r13, %r13
	jne	.L62
	movq	8(%rbp), %rdx
	movq	%rdx, 8(%rbx)
	movq	16(%rbp), %rdx
	movq	%rdx, 16(%rbx)
	addq	$24, %rbp
	addq	$24, %rbx
	movq	%rax, %r14
	jmp	.L16
.L62:
	cmpq	$1, %r13
	jne	.L63
	movq	8(%rbp), %rdx
	movq	%rdx, 16(%rbx)
	addq	$16, %rbp
	movq	%rax, %r14
	jmp	.L64
.L63:
	cmpq	8(%rsp), %r15
	ja	.L65
	movq	%r14, %rax
	subq	$4, %rax
	jns	.L66
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	leaq	32(%rbx,%rax), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	9(%rbp), %rax
	jmp	.L8
.L66:
	subq	$8, 8(%rsp)
.L65:
	addq	$8, %rbp
	leaq	16(%rbx), %rdx
	movq	%rdx, -8(%r15)
	movq	%rax, %r14
	leaq	-8(%r15), %r15
.L64:
	leaq	8(%rbx), %r12
	addq	$24, %rbx
	jmp	.L6
.L60:
	leaq	-1(%rdi), %rsi
	subq	%rax, %rsi
	movq	%rsi, 40(%rsp)
	movq	%rsi, %r14
	testq	%rsi, %rsi
	jns	.L67
	movq	(%rsp), %rdx
	subq	8(%rsp), %rdx
	sarq	$3, %rdx
	addq	%rdx, %rax
	leaq	(%rbx,%rax,8), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	9(%rbp), %rax
	jmp	.L8
.L67:
	leaq	24(%rbx), %rsi
	movq	%rsi, 16(%rsp)
	movq	%rsi, 16(%rbx)
	testq	%r13, %r13
	jne	.L68
	movq	8(%rbp), %rax
	movq	%rax, 8(%rbx)
	addq	$16, %rbp
	leaq	-257(%rcx), %rbx
	movq	%rbx, %rdx
	movq	%rbp, %rsi
	movq	16(%rsp), %r13
	movq	%r13, %rdi
	call	copy
	salq	$3, %rbx
	addq	%rbx, %rbp
	addq	%r13, %rbx
	jmp	.L16
.L68:
	leaq	8(%rbx), %r12
	movzwl	%dx, %ecx
	movq	%rcx, 48(%rsp)
	subq	%rcx, %rax
	movq	%rax, 32(%rsp)
	addq	$8, %rbp
	testq	%rax, %rax
	jle	.L69
	movq	16(%rsp), %rsi
	leaq	-8(%rsi,%rcx,8), %rdi
	movq	%rax, %rdx
	movq	%rbp, %rsi
	call	copy
	movq	32(%rsp), %rax
	leaq	0(%rbp,%rax,8), %rbp
.L69:
	leaq	-1(%r13), %rcx
	testq	%rcx, %rcx
	jle	.L70
	movq	%rcx, %rdx
	leaq	0(,%rcx,8), %rax
	subq	%rax, %r15
	movq	8(%rsp), %rax
	cmpq	%r15, %rax
	jbe	.L71
	subq	%r15, %rax
	sarq	$3, %rax
	movq	40(%rsp), %r14
	subq	%rax, %r14
	jns	.L95
	movq	(%rsp), %rax
	subq	%r15, %rax
	sarq	$3, %rax
	addq	32(%rsp), %rdx
	addq	%rdx, %rax
	movq	16(%rsp), %rsi
	leaq	(%rsi,%rax,8), %rax
	movq	24(%rsp), %rcx
	movq	%rax, (%rcx)
	leaq	1(%rbp), %rax
	jmp	.L8
.L95:
	movq	%r15, 8(%rsp)
.L71:
	subq	$2, %r13
	js	.L70
	movq	48(%rsp), %rax
	leaq	8(%rbx,%rax,8), %rax
	leaq	(%r15,%r13,8), %rdx
	addq	$16, %rbx
.L72:
	movq	%rax, (%rdx)
	subq	$8, %rax
	subq	$8, %rdx
	cmpq	%rbx, %rax
	jne	.L72
.L70:
	addq	32(%rsp), %rcx
	movq	16(%rsp), %rax
	leaq	(%rax,%rcx,8), %rbx
	jmp	.L6
.L10:
	movl	-4(%rax), %esi
	movslq	%esi, %r13
	cmpq	$1, %r13
	jle	.L73
	cmpq	$255, %r13
	jg	.L74
	subq	%r13, %rdi
	movq	%rdi, %r14
	jns	.L75
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	sarq	$3, %rax
	leaq	1(%rax,%r13), %rax
	leaq	(%rbx,%rax,8), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	9(%rbp), %rax
	jmp	.L8
.L75:
	leaq	-8(,%r13,8), %rdi
	subq	%rdi, %r15
	movq	8(%rsp), %rax
	cmpq	%r15, %rax
	jbe	.L76
	subq	%r15, %rax
	sarq	$3, %rax
	subq	%rax, %r14
	jns	.L96
	movq	(%rsp), %rax
	subq	%r15, %rax
	sarq	$3, %rax
	movslq	%esi, %r15
	leaq	1(%rax,%r15), %rax
	leaq	(%rbx,%rax,8), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	9(%rbp), %rax
	jmp	.L8
.L96:
	movq	%r15, 8(%rsp)
.L76:
	leaq	8(%rbx), %r12
	leaq	16(%rbx), %rcx
	leaq	-8(%rcx,%rdi), %rax
	movq	%rax, -8(%r15,%rdi)
	subq	$3, %r13
	js	.L77
	addq	%rdi, %rbx
	leaq	(%r15,%r13,8), %rax
	movq	%r12, %rdx
.L78:
	movq	%rbx, (%rax)
	subq	$8, %rbx
	subq	$8, %rax
	cmpq	%rdx, %rbx
	jne	.L78
.L77:
	addq	$8, %rbp
	leaq	(%rcx,%rdi), %rbx
	jmp	.L6
.L74:
	cmpq	$257, %r13
	je	.L79
	sarq	$8, %r13
	movq	%r13, %rcx
	movq	%r13, 16(%rsp)
	movzbl	%sil, %eax
	movl	%eax, 32(%rsp)
	cltq
	movq	%rax, %r13
	subq	%rcx, %r13
	subq	%rax, %rdi
	movq	%rdi, %r14
	jns	.L80
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	sarq	$3, %rax
	movslq	32(%rsp), %r15
	leaq	1(%rax,%r15), %rax
	leaq	(%rbx,%rax,8), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	9(%rbp), %rax
	jmp	.L8
.L80:
	addq	$8, %rbp
	leaq	8(%rbx), %r12
	leaq	(%r12,%r13,8), %rdi
	movq	16(%rsp), %rdx
	movq	%rbp, %rsi
	call	copy
	movq	16(%rsp), %rax
	leaq	0(%rbp,%rax,8), %rbp
	testq	%r13, %r13
	jne	.L81
	movslq	32(%rsp), %rax
	leaq	(%r12,%rax,8), %rbx
	jmp	.L16
.L81:
	addq	$16, %rbx
	cmpq	$1, %r13
	jle	.L82
	leaq	-8(,%r13,8), %rax
	subq	%rax, %r15
	movq	8(%rsp), %rsi
	cmpq	%r15, %rsi
	jbe	.L83
	movq	%rsi, %rdx
	subq	%r15, %rdx
	sarq	$3, %rdx
	subq	%rdx, %r14
	jns	.L97
	movq	(%rsp), %rax
	subq	%r15, %rax
	sarq	$3, %rax
	movslq	32(%rsp), %r15
	addq	%r15, %rax
	leaq	(%rbx,%rax,8), %rax
	movq	24(%rsp), %rcx
	movq	%rax, (%rcx)
	leaq	1(%rbp), %rax
	jmp	.L8
.L97:
	movq	%r15, 8(%rsp)
.L83:
	leaq	-8(%rbx,%rax), %rdx
	movq	%rdx, -8(%r15,%rax)
	movq	%r13, %rdx
	subq	$3, %rdx
	js	.L82
	leaq	-16(%rbx,%rax), %rax
.L84:
	movq	%rax, (%r15,%rdx,8)
	subq	$1, %rdx
	subq	$8, %rax
	cmpq	$-1, %rdx
	jne	.L84
.L82:
	movslq	32(%rsp), %rax
	leaq	-8(%rbx,%rax,8), %rbx
	jmp	.L6
.L79:
	subq	$3, %r14
	jns	.L85
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	leaq	24(%rbx,%rax), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	9(%rbp), %rax
	jmp	.L8
.L85:
	movq	8(%rbp), %rax
	movq	%rax, 8(%rbx)
	addq	$16, %rbp
	addq	$24, %rbx
	jmp	.L16
.L73:
	subq	$3, %r14
	jns	.L86
	movq	(%rsp), %rax
	subq	8(%rsp), %rax
	leaq	24(%rbx,%rax), %rax
	movq	24(%rsp), %rsi
	movq	%rax, (%rsi)
	leaq	9(%rbp), %rax
	jmp	.L8
.L86:
	addq	$8, %rbp
	testq	%r13, %r13
	jne	.L87
	addq	$24, %rbx
	jmp	.L16
.L87:
	leaq	8(%rbx), %r12
	addq	$24, %rbx
	jmp	.L6
.L9:
	movq	-1(%rbp,%rax), %rax
	movq	%rax, (%r12)
	addq	$8, %rbp
	movq	%rdi, %r14
	jmp	.L16
.L93:
	movq	16(%rsp), %rbx
.L16:
	cmpq	(%rsp), %r15
	je	.L88
	movq	(%r15), %r12
	leaq	8(%r15), %r15
	jmp	.L6
.L88:
	movq	24(%rsp), %rax
	movq	%rbx, (%rax)
	movq	96(%rsp), %rax
.L8:
	movq	104(%rsp), %rsi
	xorq	%fs:40, %rsi
	je	.L89
	call	__stack_chk_fail
.L89:
	addq	$120, %rsp

	popq	%rbx

	popq	%rbp

	popq	%r12

	popq	%r13

	popq	%r14

	popq	%r15

	ret

.LFE16:
	.size	copy_string_to_graph, .-copy_string_to_graph
	.globl	remove_forwarding_pointers_from_string
	.type	remove_forwarding_pointers_from_string, @function
remove_forwarding_pointers_from_string:
.LFB17:

	addq	$16, %rdi
	cmpq	%rsi, %rdi
	jnb	.L108
	movq	$-256, %rcx
	movl	$dINT+2, %r10d
	movl	$BOOL+2, %r9d
	movl	$REAL+2, %r8d
.L124:
	movq	(%rdi), %rax
	testb	$1, %al
	jne	.L110
	movq	(%rax), %rax
	movq	%rax, (%rdi)
	testb	$2, %al
	je	.L111
	movzwl	-2(%rax), %edx
	testq	%rdx, %rdx
	jne	.L112
	cmpq	$dINT+2, %rax
	je	.L113
	cmpq	$CHAR+2, %rax
	je	.L113
	cmpq	$BOOL+2, %rax
	je	.L113
	cmpq	$REAL+2, %rax
	jne	.L114
.L113:
	addq	$16, %rdi
	jmp	.L115
.L114:
	cmpq	$__STRING__+2, %rax
	jne	.L116
	movq	8(%rdi), %rax
	addq	$7, %rax
	andq	$-8, %rax
	leaq	16(%rdi,%rax), %rdi
	jmp	.L115
.L116:
	cmpq	$__ARRAY__+2, %rax
	jne	.L117
	movq	16(%rdi), %rax
	leaq	24(%rdi), %rdx
	testq	%rax, %rax
	je	.L122
	movq	8(%rdi), %rdi
	cmpq	%rax, %r8
	je	.L123
	cmpq	%rax, %r10
	jne	.L118
.L123:
	leaq	(%rdx,%rdi,8), %rdi
	jmp	.L115
.L118:
	cmpq	%rax, %r9
	jne	.L120
	addq	$7, %rdi
	andq	$-8, %rdi
	addq	%rdx, %rdi
	jmp	.L115
.L120:
	movzwl	-2(%rax), %r11d
	subq	$256, %r11
	movzwl	(%rax), %eax
	subq	%rax, %r11
	imulq	%r11, %rdi
	leaq	(%rdx,%rdi,8), %rdi
	jmp	.L115
.L117:
	addq	$8, %rdi
	jmp	.L115
.L112:
	addq	$8, %rdi
	cmpq	$255, %rdx
	jbe	.L115
	movzwl	(%rax), %eax
	movq	%rcx, %r11
	subq	%rax, %r11
	addq	%r11, %rdx
	leaq	(%rdi,%rdx,8), %rdi
	jmp	.L115
.L111:
	movslq	-4(%rax), %rax
	addq	$8, %rdi
	cmpq	$255, %rax
	jle	.L115
	sarq	$8, %rax
	leaq	(%rdi,%rax,8), %rdi
	jmp	.L115
.L110:
	addq	$8, %rdi
	jmp	.L115
.L122:
	movq	%rdx, %rdi
.L115:
	cmpq	%rdi, %rsi
	ja	.L124
.L108:
	rep ret

.LFE17:
	.size	remove_forwarding_pointers_from_string, .-remove_forwarding_pointers_from_string
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.11) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
