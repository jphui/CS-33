	.file	"thttpd.c"
	.text
	.p2align 4
	.type	handle_hup, @function
handle_hup:
.LASANPC4:
.LFB4:
	.cfi_startproc
	movl	$1, got_hup(%rip)
	ret
	.cfi_endproc
.LFE4:
	.size	handle_hup, .-handle_hup
	.section	.rodata
	.align 32
.LC0:
	.string	"  thttpd - %ld connections (%g/sec), %d max simultaneous, %lld bytes (%g/sec), %d httpd_conns allocated"
	.zero	56
	.text
	.p2align 4
	.type	thttpd_logstats, @function
thttpd_logstats:
.LASANPC35:
.LFB35:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	testq	%rdi, %rdi
	jle	.L4
	movq	stats_connections(%rip), %rdx
	pxor	%xmm2, %xmm2
	pxor	%xmm1, %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2ssq	%rdi, %xmm2
	movl	httpd_conn_count(%rip), %r9d
	movq	stats_bytes(%rip), %r8
	movl	$.LC0, %esi
	cvtsi2ssq	%rdx, %xmm0
	movl	stats_simultaneous(%rip), %ecx
	movl	$6, %edi
	movl	$2, %eax
	cvtsi2ssq	stats_bytes(%rip), %xmm1
	divss	%xmm2, %xmm0
	divss	%xmm2, %xmm1
	cvtss2sd	%xmm0, %xmm0
	cvtss2sd	%xmm1, %xmm1
	call	syslog
.L4:
	movq	$0, stats_connections(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE35:
	.size	thttpd_logstats, .-thttpd_logstats
	.section	.rodata
	.align 32
.LC1:
	.string	"throttle #%d '%.80s' rate %ld greatly exceeding limit %ld; %d sending"
	.zero	58
	.align 32
.LC2:
	.string	"throttle #%d '%.80s' rate %ld exceeding limit %ld; %d sending"
	.zero	34
	.align 32
.LC3:
	.string	"throttle #%d '%.80s' rate %ld lower than minimum %ld; %d sending"
	.zero	63
	.text
	.p2align 4
	.type	update_throttles, @function
update_throttles:
.LASANPC25:
.LFB25:
	.cfi_startproc
	movl	numthrottles(%rip), %r11d
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movabsq	$6148914691236517206, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	xorl	%ebx, %ebx
	testl	%r11d, %r11d
	jg	.L7
	jmp	.L24
	.p2align 4,,10
	.p2align 3
.L109:
	movq	%rdi, %rcx
	leaq	(%r9,%r9), %rdx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L100
	movq	(%rdi), %rcx
	cmpq	%rdx, %r8
	jle	.L17
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movl	$5, %edi
	movl	%ebx, %edx
	movl	$.LC1, %esi
	pushq	%rax
	.cfi_def_cfa_offset 48
	xorl	%eax, %eax
	call	syslog
	movq	throttles(%rip), %rdi
	popq	%r9
	.cfi_def_cfa_offset 40
	popq	%r10
	.cfi_def_cfa_offset 32
	addq	%rbp, %rdi
	leaq	24(%rdi), %r8
	movq	%r8, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L101
.L19:
	movq	24(%rdi), %r8
.L13:
	leaq	16(%rdi), %r9
	movq	%r9, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L102
	movq	16(%rdi), %r9
	cmpq	%r8, %r9
	jle	.L21
	leaq	40(%rdi), %r10
	movq	%r10, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L22
	cmpb	$3, %al
	jle	.L103
.L22:
	movl	40(%rdi), %eax
	testl	%eax, %eax
	jne	.L104
.L21:
	addl	$1, %ebx
	addq	$48, %rbp
	cmpl	%ebx, numthrottles(%rip)
	jle	.L24
.L7:
	movq	throttles(%rip), %rdi
	addq	%rbp, %rdi
	leaq	24(%rdi), %r8
	movq	%r8, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L105
	leaq	32(%rdi), %r8
	movq	24(%rdi), %rax
	movq	%r8, %rdx
	shrq	$3, %rdx
	addq	%rax, %rax
	cmpb	$0, 2147450880(%rdx)
	jne	.L106
	movq	32(%rdi), %rdx
	leaq	8(%rdi), %r9
	movq	$0, 32(%rdi)
	movq	%rdx, %rcx
	shrq	$63, %rcx
	addq	%rdx, %rcx
	sarq	%rcx
	addq	%rax, %rcx
	movq	%rcx, %rax
	sarq	$63, %rcx
	imulq	%r12
	movq	%r9, %rax
	shrq	$3, %rax
	subq	%rcx, %rdx
	cmpb	$0, 2147450880(%rax)
	movq	%rdx, 24(%rdi)
	movq	%rdx, %r8
	jne	.L107
	movq	8(%rdi), %r9
	cmpq	%r9, %rdx
	jle	.L13
	leaq	40(%rdi), %r10
	movq	%r10, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L14
	cmpb	$3, %al
	jle	.L108
.L14:
	movl	40(%rdi), %eax
	testl	%eax, %eax
	jne	.L109
	addq	$16, %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L21
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L104:
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L110
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movq	(%rdi), %rcx
	movl	%ebx, %edx
	movl	$.LC3, %esi
	pushq	%rax
	.cfi_def_cfa_offset 48
	movl	$5, %edi
	xorl	%eax, %eax
	addl	$1, %ebx
	addq	$48, %rbp
	call	syslog
	cmpl	%ebx, numthrottles(%rip)
	popq	%rax
	.cfi_def_cfa_offset 40
	popq	%rdx
	.cfi_def_cfa_offset 32
	jg	.L7
	.p2align 4,,10
	.p2align 3
.L24:
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L6
	subl	$1, %eax
	movq	connects(%rip), %r8
	movq	throttles(%rip), %r10
	leaq	(%rax,%rax,8), %rax
	salq	$4, %rax
	leaq	144(%r8,%rax), %r11
	jmp	.L37
	.p2align 4,,10
	.p2align 3
.L27:
	addq	$144, %r8
	cmpq	%r11, %r8
	je	.L6
.L37:
	movq	%r8, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L25
	cmpb	$3, %al
	jle	.L111
.L25:
	movl	(%r8), %eax
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L27
	leaq	64(%r8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L112
	leaq	56(%r8), %rdi
	movq	$-1, 64(%r8)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L29
	cmpb	$3, %al
	jle	.L113
.L29:
	movl	56(%r8), %r9d
	testl	%r9d, %r9d
	jle	.L27
	leaq	16(%r8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L38
	cmpb	$3, %al
	jle	.L114
.L38:
	movslq	16(%r8), %rax
	leaq	(%rax,%rax,2), %rcx
	salq	$4, %rcx
	addq	%r10, %rcx
	leaq	8(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L115
	leaq	40(%rcx), %rdi
	movq	8(%rcx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L40
	cmpb	$3, %dl
	jle	.L116
.L40:
	movslq	40(%rcx), %rcx
	cqto
	leaq	20(%r8), %rdi
	idivq	%rcx
	movq	%rax, %rsi
	leal	-1(%r9), %eax
	leaq	(%rdi,%rax,4), %r9
	jmp	.L41
	.p2align 4,,10
	.p2align 3
.L121:
	cmpq	%rax, %rsi
	cmovg	%rax, %rsi
.L35:
	addq	$4, %rdi
.L41:
	cmpq	%r9, %rdi
	je	.L117
	movq	%rdi, %rax
	movq	%rdi, %rcx
	shrq	$3, %rax
	andl	$7, %ecx
	movzbl	2147450880(%rax), %eax
	addl	$3, %ecx
	cmpb	%al, %cl
	jl	.L32
	testb	%al, %al
	jne	.L118
.L32:
	movslq	(%rdi), %rax
	leaq	(%rax,%rax,2), %rcx
	salq	$4, %rcx
	addq	%r10, %rcx
	leaq	8(%rcx), %rbp
	movq	%rbp, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L119
	leaq	40(%rcx), %rbp
	movq	8(%rcx), %rax
	movq	%rbp, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L34
	cmpb	$3, %dl
	jle	.L120
.L34:
	movslq	40(%rcx), %rcx
	cqto
	idivq	%rcx
	cmpq	$-1, %rsi
	jne	.L121
	movq	%rax, %rsi
	jmp	.L35
	.p2align 4,,10
	.p2align 3
.L17:
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movl	$.LC2, %esi
	movl	$6, %edi
	movl	%ebx, %edx
	pushq	%rax
	.cfi_def_cfa_offset 48
	xorl	%eax, %eax
	call	syslog
	movq	throttles(%rip), %rdi
	popq	%rcx
	.cfi_def_cfa_offset 40
	popq	%rsi
	.cfi_def_cfa_offset 32
	addq	%rbp, %rdi
	leaq	24(%rdi), %r8
	movq	%r8, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L19
	movq	%r8, %rdi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L117:
	movq	%rsi, 64(%r8)
	addq	$144, %r8
	cmpq	%r11, %r8
	jne	.L37
.L6:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L120:
	.cfi_restore_state
	movq	%rbp, %rdi
	call	__asan_report_load4
.L119:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L118:
	call	__asan_report_load4
.L105:
	movq	%r8, %rdi
	call	__asan_report_load8
.L107:
	movq	%r9, %rdi
	call	__asan_report_load8
.L106:
	movq	%r8, %rdi
	call	__asan_report_load8
.L111:
	movq	%r8, %rdi
	call	__asan_report_load4
.L102:
	movq	%r9, %rdi
	call	__asan_report_load8
.L100:
	call	__asan_report_load8
.L108:
	movq	%r10, %rdi
	call	__asan_report_load4
.L103:
	movq	%r10, %rdi
	call	__asan_report_load4
.L112:
	call	__asan_report_store8
.L113:
	call	__asan_report_load4
.L101:
	movq	%r8, %rdi
	call	__asan_report_load8
.L110:
	call	__asan_report_load8
.L116:
	call	__asan_report_load4
.L115:
	call	__asan_report_load8
.L114:
	call	__asan_report_load4
	.cfi_endproc
.LFE25:
	.size	update_throttles, .-update_throttles
	.section	.rodata
	.align 32
.LC4:
	.string	"%s: no value required for %s option\n"
	.zero	59
	.text
	.p2align 4
	.type	no_value_required, @function
no_value_required:
.LASANPC14:
.LFB14:
	.cfi_startproc
	testq	%rsi, %rsi
	jne	.L128
	ret
.L128:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L129
	movq	%rdi, %rcx
	movq	stderr(%rip), %rdi
	movl	$.LC4, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L129:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE14:
	.size	no_value_required, .-no_value_required
	.section	.rodata
	.align 32
.LC5:
	.string	"%s: value required for %s option\n"
	.zero	62
	.text
	.p2align 4
	.type	value_required, @function
value_required:
.LASANPC13:
.LFB13:
	.cfi_startproc
	testq	%rsi, %rsi
	je	.L136
	ret
.L136:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L137
	movq	%rdi, %rcx
	movq	stderr(%rip), %rdi
	movl	$.LC5, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L137:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE13:
	.size	value_required, .-value_required
	.section	.rodata
	.align 32
.LC6:
	.string	"usage:  %s [-C configfile] [-p port] [-d dir] [-r|-nor] [-dd data_dir] [-s|-nos] [-v|-nov] [-g|-nog] [-u user] [-c cgipat] [-t throttles] [-h host] [-l logfile] [-i pidfile] [-T charset] [-P P3P] [-M maxage] [-V] [-D]\n"
	.zero	37
	.text
	.p2align 4
	.type	usage, @function
usage:
.LASANPC11:
.LFB11:
	.cfi_startproc
	movl	$stderr, %eax
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L141
	movq	stderr(%rip), %rdi
	movl	$.LC6, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L141:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE11:
	.size	usage, .-usage
	.globl	__asan_stack_malloc_0
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC7:
	.string	"1 32 8 16 client_data:2104"
	.text
	.p2align 4
	.type	wakeup_connection, @function
wakeup_connection:
.LASANPC30:
.LFB30:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rdi, %rsi
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$80, %rsp
	.cfi_def_cfa_offset 112
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	16(%rsp), %rbx
	movq	%rbx, %r12
	testl	%eax, %eax
	jne	.L165
.L142:
	leaq	32(%rbx), %rdi
	movq	%rbx, %rbp
	movq	$1102416563, (%rbx)
	movq	%rdi, %rax
	shrq	$3, %rbp
	movq	$.LC7, 8(%rbx)
	shrq	$3, %rax
	movq	$.LASANPC30, 16(%rbx)
	movl	$-235802127, 2147450880(%rbp)
	movl	$-202116352, 2147450884(%rbp)
	cmpb	$0, 2147450880(%rax)
	movq	%rsi, 32(%rbx)
	jne	.L166
	leaq	96(%rsi), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L167
	movq	%rsi, %rax
	movq	$0, 96(%rsi)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L148
	cmpb	$3, %al
	jle	.L168
.L148:
	cmpl	$3, (%rsi)
	je	.L169
.L145:
	cmpq	%rbx, %r12
	jne	.L170
	movq	$0, 2147450880(%rbp)
.L144:
	addq	$80, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L169:
	.cfi_restore_state
	leaq	8(%rsi), %rdi
	movl	$2, (%rsi)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L171
	movq	8(%rsi), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L151
	cmpb	$3, %dl
	jle	.L172
.L151:
	movl	704(%rax), %edi
	movl	$1, %edx
	call	fdwatch_add_fd
	jmp	.L145
.L168:
	movq	%rsi, %rdi
	call	__asan_report_load4
.L172:
	call	__asan_report_load4
.L167:
	call	__asan_report_store8
.L170:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, (%rbx)
	movq	%rax, 2147450880(%rbp)
	jmp	.L144
.L166:
	call	__asan_report_load8
.L165:
	movq	%rdi, 8(%rsp)
	movl	$64, %edi
	call	__asan_stack_malloc_0
	movq	8(%rsp), %rsi
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L142
.L171:
	call	__asan_report_load8
	.cfi_endproc
.LFE30:
	.size	wakeup_connection, .-wakeup_connection
	.section	.rodata.str1.1
.LC8:
	.string	"1 32 16 7 tv:2150"
	.section	.rodata
	.align 32
.LC9:
	.string	"up %ld seconds, stats for %ld seconds:"
	.zero	57
	.text
	.p2align 4
	.type	logstats, @function
logstats:
.LASANPC34:
.LFB34:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$72, %rsp
	.cfi_def_cfa_offset 112
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rsp, %rbx
	movq	%rbx, %r12
	testl	%eax, %eax
	jne	.L181
.L173:
	movq	%rbx, %r13
	movq	$1102416563, (%rbx)
	shrq	$3, %r13
	movq	$.LC8, 8(%rbx)
	movq	$.LASANPC34, 16(%rbx)
	movl	$-235802127, 2147450880(%r13)
	movl	$-202178560, 2147450884(%r13)
	testq	%rbp, %rbp
	je	.L182
.L177:
	movq	%rbp, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L183
	movq	0(%rbp), %rax
	movl	$1, %ecx
	movl	$.LC9, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	movq	%rax, %rbp
	subq	start_time(%rip), %rdx
	subq	stats_time(%rip), %rbp
	cmove	%rcx, %rbp
	movq	%rax, stats_time(%rip)
	xorl	%eax, %eax
	movq	%rbp, %rcx
	call	syslog
	movq	%rbp, %rdi
	call	thttpd_logstats
	movq	%rbp, %rdi
	call	httpd_logstats
	movq	%rbp, %rdi
	call	mmc_logstats
	movq	%rbp, %rdi
	call	fdwatch_logstats
	movq	%rbp, %rdi
	call	tmr_logstats
	cmpq	%rbx, %r12
	jne	.L184
	movq	$0, 2147450880(%r13)
.L175:
	addq	$72, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L182:
	.cfi_restore_state
	leaq	32(%rbx), %rbp
	xorl	%esi, %esi
	movq	%rbp, %rdi
	call	gettimeofday
	jmp	.L177
.L183:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L181:
	movl	$64, %edi
	call	__asan_stack_malloc_0
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L173
.L184:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, (%rbx)
	movq	%rax, 2147450880(%r13)
	jmp	.L175
	.cfi_endproc
.LFE34:
	.size	logstats, .-logstats
	.p2align 4
	.type	show_stats, @function
show_stats:
.LASANPC33:
.LFB33:
	.cfi_startproc
	movq	%rsi, %rdi
	jmp	logstats
	.cfi_endproc
.LFE33:
	.size	show_stats, .-show_stats
	.p2align 4
	.type	handle_usr2, @function
handle_usr2:
.LASANPC6:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	__errno_location
	movq	%rax, %rbp
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbp, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L187
	testb	%dl, %dl
	jne	.L202
.L187:
	xorl	%edi, %edi
	movl	0(%rbp), %ebx
	call	logstats
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbp, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L188
	testb	%dl, %dl
	jne	.L203
.L188:
	movl	%ebx, 0(%rbp)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L203:
	.cfi_restore_state
	movq	%rbp, %rdi
	call	__asan_report_store4
.L202:
	movq	%rbp, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE6:
	.size	handle_usr2, .-handle_usr2
	.p2align 4
	.type	occasional, @function
occasional:
.LASANPC32:
.LFB32:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rsi, %rdi
	call	mmc_cleanup
	call	tmr_cleanup
	movl	$1, watchdog_flag(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE32:
	.size	occasional, .-occasional
	.section	.rodata
	.align 32
.LC10:
	.string	"/tmp"
	.zero	59
	.text
	.p2align 4
	.type	handle_alrm, @function
handle_alrm:
.LASANPC7:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	__errno_location
	movq	%rax, %rbp
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbp, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L207
	testb	%dl, %dl
	jne	.L223
.L207:
	movl	watchdog_flag(%rip), %eax
	movl	0(%rbp), %ebx
	testl	%eax, %eax
	je	.L224
	movl	$0, watchdog_flag(%rip)
	movl	$360, %edi
	call	alarm
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbp, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L209
	testb	%dl, %dl
	jne	.L225
.L209:
	movl	%ebx, 0(%rbp)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L225:
	.cfi_restore_state
	movq	%rbp, %rdi
	call	__asan_report_store4
.L223:
	movq	%rbp, %rdi
	call	__asan_report_load4
.L224:
	movl	$.LC10, %edi
	call	chdir
	call	__asan_handle_no_return
	call	abort
	.cfi_endproc
.LFE7:
	.size	handle_alrm, .-handle_alrm
	.section	.rodata.str1.1
.LC11:
	.string	"1 32 4 10 status:188"
	.section	.rodata
	.align 32
.LC12:
	.string	"child wait - %m"
	.zero	48
	.text
	.p2align 4
	.type	handle_chld, @function
handle_chld:
.LASANPC3:
.LFB3:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	16(%rsp), %rbx
	testl	%eax, %eax
	jne	.L275
.L226:
	movq	%rbx, %r12
	movq	$1102416563, (%rbx)
	leaq	64(%rbx), %rbp
	shrq	$3, %r12
	movq	$.LC11, 8(%rbx)
	movq	$.LASANPC3, 16(%rbx)
	movl	$-235802127, 2147450880(%r12)
	movl	$-202116348, 2147450884(%r12)
	call	__errno_location
	movq	%rax, %r15
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%r15, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L230
	testb	%dl, %dl
	jne	.L276
.L230:
	movl	(%r15), %eax
	movq	%r15, %r14
	subq	$32, %rbp
	xorl	%r13d, %r13d
	shrq	$3, %r14
	movl	%eax, 12(%rsp)
	movq	%r15, %rax
	andl	$7, %eax
	addl	$3, %eax
	movb	%al, 11(%rsp)
.L231:
	movl	$1, %edx
	movq	%rbp, %rsi
	movl	$-1, %edi
	call	waitpid
	testl	%eax, %eax
	je	.L236
	js	.L277
	movq	hs(%rip), %rdx
	testq	%rdx, %rdx
	je	.L231
	leaq	36(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L237
	testb	%cl, %cl
	jne	.L278
.L237:
	movl	36(%rdx), %eax
	subl	$1, %eax
	cmovs	%r13d, %eax
	movl	%eax, 36(%rdx)
	jmp	.L231
	.p2align 4,,10
	.p2align 3
.L277:
	movzbl	2147450880(%r14), %eax
	cmpb	%al, 11(%rsp)
	jl	.L234
	testb	%al, %al
	jne	.L279
.L234:
	movl	(%r15), %eax
	cmpl	$4, %eax
	je	.L231
	cmpl	$11, %eax
	je	.L231
	cmpl	$10, %eax
	jne	.L280
.L236:
	movq	%r15, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%r15, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L240
	testb	%dl, %dl
	jne	.L281
.L240:
	movl	12(%rsp), %eax
	movl	%eax, (%r15)
	leaq	16(%rsp), %rax
	cmpq	%rbx, %rax
	jne	.L282
	movq	$0, 2147450880(%r12)
.L228:
	addq	$88, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L280:
	.cfi_restore_state
	movl	$.LC12, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L236
.L276:
	movq	%r15, %rdi
	call	__asan_report_load4
.L281:
	movq	%r15, %rdi
	call	__asan_report_store4
.L282:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, (%rbx)
	movq	%rax, 2147450880(%r12)
	jmp	.L228
.L278:
	call	__asan_report_load4
.L279:
	movq	%r15, %rdi
	call	__asan_report_load4
.L275:
	movl	$64, %edi
	call	__asan_stack_malloc_0
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L226
	.cfi_endproc
.LFE3:
	.size	handle_chld, .-handle_chld
	.section	.rodata
	.align 32
.LC13:
	.string	"out of memory copying a string"
	.zero	33
	.align 32
.LC14:
	.string	"%s: out of memory copying a string\n"
	.zero	60
	.text
	.p2align 4
	.type	e_strdup, @function
e_strdup:
.LASANPC15:
.LFB15:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	strdup
	testq	%rax, %rax
	je	.L287
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L287:
	.cfi_restore_state
	movl	$.LC13, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L288
	movq	stderr(%rip), %rdi
	movl	$.LC14, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L288:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE15:
	.size	e_strdup, .-e_strdup
	.globl	__asan_stack_malloc_2
	.section	.rodata.str1.1
.LC15:
	.string	"1 48 100 9 line:1002"
	.section	.rodata
	.align 32
.LC16:
	.string	"r"
	.zero	62
	.align 32
.LC17:
	.string	" \t\n\r"
	.zero	59
	.align 32
.LC18:
	.string	"debug"
	.zero	58
	.align 32
.LC19:
	.string	"port"
	.zero	59
	.align 32
.LC20:
	.string	"dir"
	.zero	60
	.align 32
.LC21:
	.string	"chroot"
	.zero	57
	.align 32
.LC22:
	.string	"nochroot"
	.zero	55
	.align 32
.LC23:
	.string	"data_dir"
	.zero	55
	.align 32
.LC24:
	.string	"symlink"
	.zero	56
	.align 32
.LC25:
	.string	"nosymlink"
	.zero	54
	.align 32
.LC26:
	.string	"symlinks"
	.zero	55
	.align 32
.LC27:
	.string	"nosymlinks"
	.zero	53
	.align 32
.LC28:
	.string	"user"
	.zero	59
	.align 32
.LC29:
	.string	"cgipat"
	.zero	57
	.align 32
.LC30:
	.string	"cgilimit"
	.zero	55
	.align 32
.LC31:
	.string	"urlpat"
	.zero	57
	.align 32
.LC32:
	.string	"noemptyreferers"
	.zero	48
	.align 32
.LC33:
	.string	"localpat"
	.zero	55
	.align 32
.LC34:
	.string	"throttles"
	.zero	54
	.align 32
.LC35:
	.string	"host"
	.zero	59
	.align 32
.LC36:
	.string	"logfile"
	.zero	56
	.align 32
.LC37:
	.string	"vhost"
	.zero	58
	.align 32
.LC38:
	.string	"novhost"
	.zero	56
	.align 32
.LC39:
	.string	"globalpasswd"
	.zero	51
	.align 32
.LC40:
	.string	"noglobalpasswd"
	.zero	49
	.align 32
.LC41:
	.string	"pidfile"
	.zero	56
	.align 32
.LC42:
	.string	"charset"
	.zero	56
	.align 32
.LC43:
	.string	"p3p"
	.zero	60
	.align 32
.LC44:
	.string	"max_age"
	.zero	56
	.align 32
.LC45:
	.string	"%s: unknown config option '%s'\n"
	.zero	32
	.text
	.p2align 4
	.type	read_config, @function
read_config:
.LASANPC12:
.LFB12:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$216, %rsp
	.cfi_def_cfa_offset 272
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	16(%rsp), %r12
	testl	%eax, %eax
	jne	.L393
.L289:
	movq	%r12, %rax
	movl	$.LC16, %esi
	movq	%rbp, %rdi
	movq	$1102416563, (%r12)
	movq	$.LC15, 8(%r12)
	shrq	$3, %rax
	movq	$.LASANPC12, 16(%r12)
	movq	%rax, 8(%rsp)
	movl	$-235802127, 2147450880(%rax)
	movl	$61937, 2147450884(%rax)
	movl	$-217841664, 2147450896(%rax)
	movl	$-202116109, 2147450900(%rax)
	call	fopen
	movq	%rax, (%rsp)
	testq	%rax, %rax
	je	.L387
	movabsq	$4294977024, %rbx
	leaq	48(%r12), %r14
.L293:
	movq	(%rsp), %rdx
	movl	$1000, %esi
	movq	%r14, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L394
	movq	%r14, %rdi
	movl	$35, %esi
	call	strchr
	movq	%rax, %rdi
	testq	%rax, %rax
	je	.L294
	shrq	$3, %rax
	movq	%rdi, %rdx
	movzbl	2147450880(%rax), %eax
	andl	$7, %edx
	cmpb	%dl, %al
	jg	.L295
	testb	%al, %al
	jne	.L395
.L295:
	movb	$0, (%rdi)
.L294:
	movl	$.LC17, %esi
	movq	%r14, %rdi
	call	strspn
	leaq	(%r14,%rax), %r15
	movq	%r15, %rax
	movq	%r15, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L296
	testb	%al, %al
	jne	.L396
	.p2align 4,,10
	.p2align 3
.L296:
	cmpb	$0, (%r15)
	je	.L293
	movl	$.LC17, %esi
	movq	%r15, %rdi
	call	strcspn
	leaq	(%r15,%rax), %r13
	movq	%r13, %rax
	movq	%r13, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L301
	testb	%al, %al
	jne	.L397
	.p2align 4,,10
	.p2align 3
.L301:
	movzbl	0(%r13), %eax
	cmpb	$32, %al
	jbe	.L398
.L299:
	movl	$61, %esi
	movq	%r15, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L338
	movq	%rax, %rdx
	movq	%rax, %rcx
	leaq	1(%rax), %rbp
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	cmpb	%cl, %dl
	jg	.L304
	testb	%dl, %dl
	jne	.L399
.L304:
	movb	$0, (%rax)
.L303:
	movl	$.LC18, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L400
	movl	$.LC19, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L401
	movl	$.LC20, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L402
	movl	$.LC21, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L403
	movl	$.LC22, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L404
	movl	$.LC23, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L405
	movl	$.LC24, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L390
	movl	$.LC25, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L391
	movl	$.LC26, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L390
	movl	$.LC27, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L391
	movl	$.LC28, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L406
	movl	$.LC29, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L407
	movl	$.LC30, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L408
	movl	$.LC31, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L409
	movl	$.LC32, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L410
	movl	$.LC33, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L411
	movl	$.LC34, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L412
	movl	$.LC35, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L413
	movl	$.LC36, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L414
	movl	$.LC37, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L415
	movl	$.LC38, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L416
	movl	$.LC39, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L417
	movl	$.LC40, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L418
	movl	$.LC41, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L419
	movl	$.LC42, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L420
	movl	$.LC43, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L421
	movl	$.LC44, %esi
	movq	%r15, %rdi
	call	strcasecmp
	testl	%eax, %eax
	jne	.L332
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	atoi
	movl	%eax, max_age(%rip)
	jmp	.L306
	.p2align 4,,10
	.p2align 3
.L398:
	btq	%rax, %rbx
	jnc	.L299
	movq	%r13, %rdi
	addq	$1, %r13
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L300
	testb	%al, %al
	jne	.L422
.L300:
	movq	%r13, %rax
	movb	$0, -1(%r13)
	movq	%r13, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L301
	testb	%al, %al
	je	.L301
	movq	%r13, %rdi
	call	__asan_report_load1
	.p2align 4,,10
	.p2align 3
.L400:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	no_value_required
	movl	$1, debug(%rip)
.L306:
	movl	$.LC17, %esi
	movq	%r13, %rdi
	call	strspn
	leaq	0(%r13,%rax), %r15
	movq	%r15, %rax
	movq	%r15, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L296
	testb	%al, %al
	je	.L296
	movq	%r15, %rdi
	call	__asan_report_load1
	.p2align 4,,10
	.p2align 3
.L338:
	xorl	%ebp, %ebp
	jmp	.L303
.L401:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	atoi
	movw	%ax, port(%rip)
	jmp	.L306
.L402:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, dir(%rip)
	jmp	.L306
.L403:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	no_value_required
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L306
.L404:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	no_value_required
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L306
.L405:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, data_dir(%rip)
	jmp	.L306
.L390:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	no_value_required
	movl	$0, no_symlink_check(%rip)
	jmp	.L306
.L391:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	no_value_required
	movl	$1, no_symlink_check(%rip)
	jmp	.L306
.L422:
	call	__asan_report_store1
.L406:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, user(%rip)
	jmp	.L306
.L394:
	movq	(%rsp), %rdi
	call	fclose
	leaq	16(%rsp), %rax
	cmpq	%r12, %rax
	jne	.L423
	movq	8(%rsp), %rax
	movq	$0, 2147450880(%rax)
	movq	$0, 2147450896(%rax)
.L291:
	addq	$216, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L407:
	.cfi_restore_state
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, cgi_pattern(%rip)
	jmp	.L306
.L409:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, url_pattern(%rip)
	jmp	.L306
.L408:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	atoi
	movl	%eax, cgi_limit(%rip)
	jmp	.L306
.L411:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, local_pattern(%rip)
	jmp	.L306
.L410:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	no_value_required
	movl	$1, no_empty_referers(%rip)
	jmp	.L306
.L412:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, throttlefile(%rip)
	jmp	.L306
.L397:
	movq	%r13, %rdi
	call	__asan_report_load1
.L399:
	movq	%rax, %rdi
	call	__asan_report_store1
.L414:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, logfile(%rip)
	jmp	.L306
.L413:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, hostname(%rip)
	jmp	.L306
.L423:
	movq	$1172321806, (%r12)
	movq	8(%rsp), %rax
	movabsq	$-723401728380766731, %rcx
	movdqa	.LC46(%rip), %xmm0
	movq	%rcx, 2147450896(%rax)
	movups	%xmm0, 2147450880(%rax)
	jmp	.L291
	.p2align 4,,10
	.p2align 3
.L417:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	no_value_required
	movl	$1, do_global_passwd(%rip)
	jmp	.L306
.L332:
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L424
	movq	stderr(%rip), %rdi
	movq	%r15, %rcx
	movl	$.LC45, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.p2align 4,,10
	.p2align 3
.L421:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, p3p(%rip)
	jmp	.L306
.L420:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, charset(%rip)
	jmp	.L306
.L424:
	movl	$stderr, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L419:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, pidfile(%rip)
	jmp	.L306
.L418:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	no_value_required
	movl	$0, do_global_passwd(%rip)
	jmp	.L306
.L416:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	no_value_required
	movl	$0, do_vhost(%rip)
	jmp	.L306
.L415:
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	no_value_required
	movl	$1, do_vhost(%rip)
	jmp	.L306
.L396:
	movq	%r15, %rdi
	call	__asan_report_load1
.L395:
	call	__asan_report_store1
.L387:
	movq	%rbp, %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L393:
	movl	$192, %edi
	call	__asan_stack_malloc_2
	testq	%rax, %rax
	cmovne	%rax, %r12
	jmp	.L289
	.cfi_endproc
.LFE12:
	.size	read_config, .-read_config
	.section	.rodata
	.align 32
.LC47:
	.string	"nobody"
	.zero	57
	.align 32
.LC48:
	.string	"iso-8859-1"
	.zero	53
	.align 32
.LC49:
	.string	""
	.zero	63
	.align 32
.LC50:
	.string	"-V"
	.zero	61
	.align 32
.LC51:
	.string	"thttpd/2.27.0 Oct 3, 2014"
	.zero	38
	.align 32
.LC52:
	.string	"-C"
	.zero	61
	.align 32
.LC53:
	.string	"-p"
	.zero	61
	.align 32
.LC54:
	.string	"-d"
	.zero	61
	.align 32
.LC55:
	.string	"-r"
	.zero	61
	.align 32
.LC56:
	.string	"-nor"
	.zero	59
	.align 32
.LC57:
	.string	"-dd"
	.zero	60
	.align 32
.LC58:
	.string	"-s"
	.zero	61
	.align 32
.LC59:
	.string	"-nos"
	.zero	59
	.align 32
.LC60:
	.string	"-u"
	.zero	61
	.align 32
.LC61:
	.string	"-c"
	.zero	61
	.align 32
.LC62:
	.string	"-t"
	.zero	61
	.align 32
.LC63:
	.string	"-h"
	.zero	61
	.align 32
.LC64:
	.string	"-l"
	.zero	61
	.align 32
.LC65:
	.string	"-v"
	.zero	61
	.align 32
.LC66:
	.string	"-nov"
	.zero	59
	.align 32
.LC67:
	.string	"-g"
	.zero	61
	.align 32
.LC68:
	.string	"-nog"
	.zero	59
	.align 32
.LC69:
	.string	"-i"
	.zero	61
	.align 32
.LC70:
	.string	"-T"
	.zero	61
	.align 32
.LC71:
	.string	"-P"
	.zero	61
	.align 32
.LC72:
	.string	"-M"
	.zero	61
	.align 32
.LC73:
	.string	"-D"
	.zero	61
	.text
	.p2align 4
	.type	parse_args, @function
parse_args:
.LASANPC10:
.LFB10:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movl	$80, %eax
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rsi, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movl	%edi, %r13d
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movl	$1, %ebx
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movw	%ax, port(%rip)
	movl	$0, debug(%rip)
	movq	$0, dir(%rip)
	movq	$0, data_dir(%rip)
	movl	$0, do_chroot(%rip)
	movl	$0, no_log(%rip)
	movl	$0, no_symlink_check(%rip)
	movl	$0, do_vhost(%rip)
	movl	$0, do_global_passwd(%rip)
	movq	$0, cgi_pattern(%rip)
	movl	$0, cgi_limit(%rip)
	movq	$0, url_pattern(%rip)
	movl	$0, no_empty_referers(%rip)
	movq	$0, local_pattern(%rip)
	movq	$0, throttlefile(%rip)
	movq	$0, hostname(%rip)
	movq	$0, logfile(%rip)
	movq	$0, pidfile(%rip)
	movq	$.LC47, user(%rip)
	movq	$.LC48, charset(%rip)
	movq	$.LC49, p3p(%rip)
	movl	$-1, max_age(%rip)
	cmpl	$1, %edi
	jg	.L426
	jmp	.L427
	.p2align 4,,10
	.p2align 3
.L497:
	leal	1(%rbx), %r15d
	cmpl	%r13d, %r15d
	jl	.L492
	movl	$.LC53, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L434
.L433:
	movl	$.LC54, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L434
	leal	1(%rbx), %eax
	cmpl	%r13d, %eax
	jge	.L434
	leaq	8(%r14,%r12), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L493
	movq	(%rdi), %rdx
	movl	%eax, %ebx
	movq	%rdx, dir(%rip)
	.p2align 4,,10
	.p2align 3
.L432:
	addl	$1, %ebx
	cmpl	%ebx, %r13d
	jle	.L427
.L426:
	movslq	%ebx, %r12
	salq	$3, %r12
	leaq	(%r14,%r12), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L494
	movq	(%rdi), %rbp
	movq	%rbp, %rax
	movq	%rbp, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L469
	testb	%al, %al
	jne	.L495
.L469:
	cmpb	$45, 0(%rbp)
	jne	.L467
	movl	$.LC50, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L496
	movl	$.LC52, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L497
	movl	$.LC53, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L433
	leal	1(%rbx), %r15d
	cmpl	%r13d, %r15d
	jge	.L434
	leaq	8(%r14,%r12), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L498
	movq	(%rdi), %rdi
	movl	%r15d, %ebx
	addl	$1, %ebx
	call	atoi
	movw	%ax, port(%rip)
	cmpl	%ebx, %r13d
	jg	.L426
	.p2align 4,,10
	.p2align 3
.L427:
	cmpl	%ebx, %r13d
	jne	.L467
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L434:
	.cfi_restore_state
	movl	$.LC55, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L437
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L432
	.p2align 4,,10
	.p2align 3
.L437:
	movl	$.LC56, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L438
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L432
	.p2align 4,,10
	.p2align 3
.L492:
	leaq	8(%r14,%r12), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L499
	movq	(%rdi), %rdi
	movl	%r15d, %ebx
	call	read_config
	jmp	.L432
	.p2align 4,,10
	.p2align 3
.L438:
	movl	$.LC57, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L439
	leal	1(%rbx), %eax
	cmpl	%r13d, %eax
	jge	.L439
	leaq	8(%r14,%r12), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L500
	movq	(%rdi), %rdx
	movl	%eax, %ebx
	movq	%rdx, data_dir(%rip)
	jmp	.L432
	.p2align 4,,10
	.p2align 3
.L439:
	movl	$.LC58, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L441
	movl	$0, no_symlink_check(%rip)
	jmp	.L432
.L441:
	movl	$.LC59, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L442
	movl	$1, no_symlink_check(%rip)
	jmp	.L432
.L442:
	movl	$.LC60, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L443
	leal	1(%rbx), %eax
	cmpl	%r13d, %eax
	jge	.L443
	leaq	8(%r14,%r12), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L501
	movq	(%rdi), %rdx
	movl	%eax, %ebx
	movq	%rdx, user(%rip)
	jmp	.L432
.L496:
	movl	$.LC51, %edi
	call	puts
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
.L443:
	movl	$.LC61, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L445
	leal	1(%rbx), %eax
	cmpl	%r13d, %eax
	jge	.L445
	leaq	8(%r14,%r12), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L502
	movq	(%rdi), %rdx
	movl	%eax, %ebx
	movq	%rdx, cgi_pattern(%rip)
	jmp	.L432
.L445:
	movl	$.LC62, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L447
	leal	1(%rbx), %eax
	cmpl	%r13d, %eax
	jge	.L448
	leaq	8(%r14,%r12), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L503
	movq	(%rdi), %rdx
	movl	%eax, %ebx
	movq	%rdx, throttlefile(%rip)
	jmp	.L432
.L447:
	movl	$.LC63, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L450
	leal	1(%rbx), %eax
	cmpl	%r13d, %eax
	jge	.L451
	leaq	8(%r14,%r12), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L504
	movq	(%rdi), %rdx
	movl	%eax, %ebx
	movq	%rdx, hostname(%rip)
	jmp	.L432
.L448:
	movl	$.LC63, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L451
.L450:
	movl	$.LC64, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L451
	leal	1(%rbx), %eax
	cmpl	%r13d, %eax
	jge	.L451
	leaq	8(%r14,%r12), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L505
	movq	(%rdi), %rdx
	movl	%eax, %ebx
	movq	%rdx, logfile(%rip)
	jmp	.L432
.L451:
	movl	$.LC65, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L506
	movl	$.LC66, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L455
	movl	$0, do_vhost(%rip)
	jmp	.L432
.L506:
	movl	$1, do_vhost(%rip)
	jmp	.L432
.L455:
	movl	$.LC67, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L456
	movl	$1, do_global_passwd(%rip)
	jmp	.L432
.L456:
	movl	$.LC68, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L457
	movl	$0, do_global_passwd(%rip)
	jmp	.L432
.L495:
	movq	%rbp, %rdi
	call	__asan_report_load1
.L494:
	call	__asan_report_load8
.L457:
	movl	$.LC69, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L458
	leal	1(%rbx), %eax
	cmpl	%r13d, %eax
	jge	.L459
	leaq	8(%r14,%r12), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L507
	movq	(%rdi), %rdx
	movl	%eax, %ebx
	movq	%rdx, pidfile(%rip)
	jmp	.L432
.L458:
	movl	$.LC70, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L461
	leal	1(%rbx), %eax
	cmpl	%r13d, %eax
	jge	.L459
	leaq	8(%r14,%r12), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L508
	movq	(%rdi), %rdx
	movl	%eax, %ebx
	movq	%rdx, charset(%rip)
	jmp	.L432
.L459:
	movl	$.LC71, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L464
.L463:
	movl	$.LC72, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L464
	leal	1(%rbx), %r15d
	cmpl	%r13d, %r15d
	jge	.L464
	leaq	8(%r14,%r12), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L509
	movq	(%rdi), %rdi
	movl	%r15d, %ebx
	call	atoi
	movl	%eax, max_age(%rip)
	jmp	.L432
.L461:
	movl	$.LC71, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L463
	leal	1(%rbx), %eax
	cmpl	%r13d, %eax
	jge	.L464
	leaq	8(%r14,%r12), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L510
	movq	(%rdi), %rdx
	movl	%eax, %ebx
	movq	%rdx, p3p(%rip)
	jmp	.L432
.L464:
	movl	$.LC73, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L467
	movl	$1, debug(%rip)
	jmp	.L432
.L493:
	call	__asan_report_load8
.L499:
	call	__asan_report_load8
.L498:
	call	__asan_report_load8
.L505:
	call	__asan_report_load8
.L507:
	call	__asan_report_load8
.L508:
	call	__asan_report_load8
.L467:
	call	__asan_handle_no_return
	call	usage
.L500:
	call	__asan_report_load8
.L509:
	call	__asan_report_load8
.L510:
	call	__asan_report_load8
.L501:
	call	__asan_report_load8
.L504:
	call	__asan_report_load8
.L502:
	call	__asan_report_load8
.L503:
	call	__asan_report_load8
	.cfi_endproc
.LFE10:
	.size	parse_args, .-parse_args
	.globl	__asan_stack_malloc_8
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC74:
	.string	"5 32 8 14 max_limit:1376 64 8 14 min_limit:1376 96 16 7 tv:1377 128 5000 8 buf:1372 5392 5000 12 pattern:1375"
	.globl	__asan_stack_free_8
	.section	.rodata
	.align 32
.LC75:
	.string	"%.80s - %m"
	.zero	53
	.align 32
.LC76:
	.string	" %4900[^ \t] %ld"
	.zero	48
	.align 32
.LC77:
	.string	"unparsable line in %.80s - %.80s"
	.zero	63
	.align 32
.LC78:
	.string	"%s: unparsable line in %.80s - %.80s\n"
	.zero	58
	.align 32
.LC79:
	.string	"|/"
	.zero	61
	.align 32
.LC80:
	.string	"out of memory allocating a throttletab"
	.zero	57
	.align 32
.LC81:
	.string	"%s: out of memory allocating a throttletab\n"
	.zero	52
	.align 32
.LC82:
	.string	" %4900[^ \t] %ld-%ld"
	.zero	44
	.text
	.p2align 4
	.type	read_throttlefile, @function
read_throttlefile:
.LASANPC17:
.LFB17:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$10728, %rsp
	.cfi_def_cfa_offset 10784
	leaq	64(%rsp), %rax
	movq	%rdi, 32(%rsp)
	movq	%rax, 48(%rsp)
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	testl	%eax, %eax
	jne	.L589
.L511:
	movq	48(%rsp), %rax
	movl	$.LC16, %esi
	movq	$1102416563, (%rax)
	leaq	10656(%rax), %r15
	movq	$.LC74, 8(%rax)
	movq	$.LASANPC17, 16(%rax)
	shrq	$3, %rax
	movq	32(%rsp), %rdi
	movl	$-235802127, 2147450880(%rax)
	movq	%rax, %r13
	movl	$-218959360, 2147450884(%rax)
	movl	$-218959360, 2147450888(%rax)
	movl	$-219021312, 2147450892(%rax)
	movl	$-218959360, 2147451520(%rax)
	movl	$-218959118, 2147451524(%rax)
	movl	$-218959118, 2147451528(%rax)
	movl	$-218959118, 2147451532(%rax)
	movl	$-218959118, 2147451536(%rax)
	movl	$-218959118, 2147451540(%rax)
	movl	$-218959118, 2147451544(%rax)
	movl	$-218959118, 2147451548(%rax)
	movl	$62194, 2147451552(%rax)
	movl	$-218103808, 2147452176(%rax)
	movl	$-202116109, 2147452180(%rax)
	movl	$-202116109, 2147452184(%rax)
	movl	$-202116109, 2147452188(%rax)
	movl	$-202116109, 2147452192(%rax)
	movl	$-202116109, 2147452196(%rax)
	movl	$-202116109, 2147452200(%rax)
	movl	$-202116109, 2147452204(%rax)
	movl	$-202116109, 2147452208(%rax)
	call	fopen
	movq	%rax, %r14
	testq	%rax, %rax
	je	.L590
	movq	48(%rsp), %rbx
	xorl	%esi, %esi
	leaq	96(%rbx), %rdi
	leaq	128(%rbx), %rbp
	call	gettimeofday
	movq	%rbx, %rax
	movq	%r13, 56(%rsp)
	movabsq	$4294977024, %rbx
	leaq	5392(%rax), %r12
	leaq	126(%rax), %rsi
	movq	%r12, %rax
	movq	%rsi, 8(%rsp)
	shrq	$3, %rax
	movq	%rax, 40(%rsp)
	.p2align 4,,10
	.p2align 3
.L521:
	movq	%r14, %rdx
	movl	$5000, %esi
	movq	%rbp, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L591
	movl	$35, %esi
	movq	%rbp, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L517
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	cmpb	%cl, %dl
	jg	.L518
	testb	%dl, %dl
	jne	.L592
.L518:
	movb	$0, (%rax)
.L517:
	movq	%rbp, %rdi
	call	strlen
	testq	%rax, %rax
	je	.L521
	movslq	%eax, %rcx
	subl	$1, %eax
	leaq	-1(%rcx,%rbp), %rdi
	addq	8(%rsp), %rcx
	subq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L520:
	movq	%rdi, %rax
	movq	%rdi, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L522
	testb	%al, %al
	jne	.L593
.L522:
	movzbl	(%rdi), %eax
	cmpb	$32, %al
	jbe	.L594
.L523:
	leaq	-10592(%r15), %rax
	movq	%r12, %rdx
	movl	$.LC82, %esi
	movq	%rbp, %rdi
	leaq	-10624(%r15), %r13
	movq	%rax, 16(%rsp)
	movq	%rax, %rcx
	xorl	%eax, %eax
	movq	%r13, %r8
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L527
	xorl	%eax, %eax
	movq	%r13, %rcx
	movq	%r12, %rdx
	movl	$.LC76, %esi
	movq	%rbp, %rdi
	call	__isoc99_sscanf
	cmpl	$2, %eax
	je	.L595
	movq	32(%rsp), %rdx
	xorl	%eax, %eax
	movq	%rbp, %rcx
	movl	$.LC77, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L596
	movq	32(%rsp), %rcx
	movq	%rbp, %r8
	movl	$.LC78, %esi
	xorl	%eax, %eax
	movq	stderr(%rip), %rdi
	call	fprintf
	jmp	.L521
	.p2align 4,,10
	.p2align 3
.L594:
	btq	%rax, %rbx
	jnc	.L523
	movb	$0, (%rdi)
	subq	$1, %rdi
	cmpq	%rcx, %rdi
	jne	.L520
	jmp	.L521
	.p2align 4,,10
	.p2align 3
.L595:
	movq	16(%rsp), %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L597
	movq	$0, -10592(%r15)
.L527:
	movq	40(%rsp), %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L530
	jle	.L598
.L530:
	cmpb	$47, -5264(%r15)
	jne	.L532
	jmp	.L599
	.p2align 4,,10
	.p2align 3
.L533:
	leaq	2(%rax), %rsi
	leaq	1(%rax), %rdi
	call	strcpy
.L532:
	movl	$.LC79, %esi
	movq	%r12, %rdi
	call	strstr
	testq	%rax, %rax
	jne	.L533
	movslq	numthrottles(%rip), %rdx
	movl	maxthrottles(%rip), %eax
	cmpl	%eax, %edx
	jl	.L534
	movl	%edx, 24(%rsp)
	testl	%eax, %eax
	jne	.L535
	movl	$100, maxthrottles(%rip)
	movl	$4800, %edi
	call	malloc
	movslq	24(%rsp), %rdx
	movq	%rax, throttles(%rip)
.L536:
	testq	%rax, %rax
	je	.L600
.L537:
	leaq	(%rdx,%rdx,2), %r8
	movq	%r12, %rdi
	salq	$4, %r8
	addq	%rax, %r8
	movq	%r8, 24(%rsp)
	call	e_strdup
	movq	24(%rsp), %r8
	movq	%r8, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L601
	movq	%rax, (%r8)
	movslq	numthrottles(%rip), %rax
	movq	%r13, %rcx
	shrq	$3, %rcx
	movq	%rax, %rdx
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	throttles(%rip), %rax
	cmpb	$0, 2147450880(%rcx)
	jne	.L602
	leaq	8(%rax), %rdi
	movq	-10624(%r15), %rcx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L603
	movq	%rcx, 8(%rax)
	movq	16(%rsp), %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L604
	leaq	16(%rax), %rdi
	movq	-10592(%r15), %rcx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L605
	leaq	24(%rax), %rdi
	movq	%rcx, 16(%rax)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L606
	leaq	32(%rax), %rdi
	movq	$0, 24(%rax)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L607
	leaq	40(%rax), %rdi
	movq	$0, 32(%rax)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	movzbl	2147450880(%rcx), %ecx
	testb	%cl, %cl
	je	.L546
	cmpb	$3, %cl
	jle	.L608
.L546:
	movl	$0, 40(%rax)
	leal	1(%rdx), %eax
	movl	%eax, numthrottles(%rip)
	jmp	.L521
.L535:
	addl	%eax, %eax
	movq	throttles(%rip), %rdi
	movl	%eax, maxthrottles(%rip)
	cltq
	leaq	(%rax,%rax,2), %rsi
	salq	$4, %rsi
	call	realloc
	movslq	24(%rsp), %rdx
	movq	%rax, throttles(%rip)
	jmp	.L536
.L534:
	movq	throttles(%rip), %rax
	jmp	.L537
.L599:
	leaq	-5263(%r15), %rsi
	movq	%r12, %rdi
	call	strcpy
	jmp	.L532
.L591:
	movq	%r14, %rdi
	movq	56(%rsp), %r13
	call	fclose
	leaq	64(%rsp), %rax
	cmpq	48(%rsp), %rax
	jne	.L609
	movl	$0, 2147451552(%r13)
	pxor	%xmm0, %xmm0
	movl	$0, 2147452208(%r13)
	movups	%xmm0, 2147450880(%r13)
	movups	%xmm0, 2147451520(%r13)
	movups	%xmm0, 2147451536(%r13)
	movups	%xmm0, 2147452176(%r13)
	movups	%xmm0, 2147452192(%r13)
.L513:
	addq	$10728, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L593:
	.cfi_restore_state
	call	__asan_report_load1
.L596:
	movl	$stderr, %edi
	call	__asan_report_load8
.L592:
	movq	%rax, %rdi
	call	__asan_report_store1
.L590:
	movq	32(%rsp), %rbx
	movl	$.LC75, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	movq	%rbx, %rdx
	call	syslog
	movq	%rbx, %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L589:
	movl	$10656, %edi
	call	__asan_stack_malloc_8
	testq	%rax, %rax
	cmove	48(%rsp), %rax
	movq	%rax, 48(%rsp)
	jmp	.L511
.L609:
	movq	48(%rsp), %rax
	leaq	64(%rsp), %rdx
	movl	$10656, %esi
	movq	$1172321806, (%rax)
	movq	%rax, %rdi
	call	__asan_stack_free_8
	jmp	.L513
.L597:
	movq	16(%rsp), %rdi
	call	__asan_report_store8
.L608:
	call	__asan_report_store4
.L607:
	call	__asan_report_store8
.L606:
	call	__asan_report_store8
.L605:
	call	__asan_report_store8
.L604:
	movq	16(%rsp), %rdi
	call	__asan_report_load8
.L603:
	call	__asan_report_store8
.L602:
	movq	%r13, %rdi
	call	__asan_report_load8
.L601:
	movq	%r8, %rdi
	call	__asan_report_store8
.L600:
	movl	$.LC80, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L610
	movq	stderr(%rip), %rdi
	movl	$.LC81, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L598:
	movq	%r12, %rdi
	call	__asan_report_load1
.L610:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE17:
	.size	read_throttlefile, .-read_throttlefile
	.section	.rodata
	.align 32
.LC83:
	.string	"-"
	.zero	62
	.align 32
.LC84:
	.string	"re-opening logfile"
	.zero	45
	.align 32
.LC85:
	.string	"a"
	.zero	62
	.align 32
.LC86:
	.string	"re-opening %.80s - %m"
	.zero	42
	.text
	.p2align 4
	.type	re_open_logfile, @function
re_open_logfile:
.LASANPC8:
.LFB8:
	.cfi_startproc
	movl	no_log(%rip), %eax
	testl	%eax, %eax
	jne	.L623
	cmpq	$0, hs(%rip)
	je	.L623
	movq	logfile(%rip), %rdi
	testq	%rdi, %rdi
	je	.L623
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movl	$.LC83, %esi
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	strcmp
	testl	%eax, %eax
	jne	.L626
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L623:
	.cfi_restore 6
	.cfi_restore 12
	ret
	.p2align 4,,10
	.p2align 3
.L626:
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -24
	.cfi_offset 12, -16
	xorl	%eax, %eax
	movl	$.LC84, %esi
	movl	$5, %edi
	call	syslog
	movq	logfile(%rip), %rdi
	movl	$.LC85, %esi
	call	fopen
	movq	logfile(%rip), %r12
	movl	$384, %esi
	movq	%rax, %rbp
	movq	%r12, %rdi
	call	chmod
	testq	%rbp, %rbp
	je	.L615
	testl	%eax, %eax
	jne	.L615
	movq	%rbp, %rdi
	call	fileno
	movl	$2, %esi
	movl	$1, %edx
	movl	%eax, %edi
	xorl	%eax, %eax
	call	fcntl
	movq	hs(%rip), %rdi
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbp, %rsi
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_restore 12
	.cfi_def_cfa_offset 8
	jmp	httpd_set_logfp
	.p2align 4,,10
	.p2align 3
.L615:
	.cfi_restore_state
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	movq	%r12, %rdx
	movl	$.LC86, %esi
	xorl	%eax, %eax
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 16
	movl	$2, %edi
	popq	%r12
	.cfi_restore 12
	.cfi_def_cfa_offset 8
	jmp	syslog
	.cfi_endproc
.LFE8:
	.size	re_open_logfile, .-re_open_logfile
	.section	.rodata
	.align 32
.LC87:
	.string	"too many connections!"
	.zero	42
	.align 32
.LC88:
	.string	"the connects free list is messed up"
	.zero	60
	.align 32
.LC89:
	.string	"out of memory allocating an httpd_conn"
	.zero	57
	.text
	.p2align 4
	.type	handle_newconnect, @function
handle_newconnect:
.LASANPC19:
.LFB19:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rdi, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	shrq	$3, %r15
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rdi, %r13
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movl	%esi, %ebx
	subq	$16, %rsp
	.cfi_def_cfa_offset 64
	movl	num_connects(%rip), %eax
.L651:
	cmpl	%eax, max_connects(%rip)
	jle	.L702
	movslq	first_free_connect(%rip), %rax
	cmpl	$-1, %eax
	je	.L630
	leaq	(%rax,%rax,8), %rbp
	salq	$4, %rbp
	addq	connects(%rip), %rbp
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L631
	cmpb	$3, %al
	jle	.L703
.L631:
	movl	0(%rbp), %eax
	testl	%eax, %eax
	jne	.L630
	leaq	8(%rbp), %r14
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L704
	movq	8(%rbp), %rdx
	testq	%rdx, %rdx
	je	.L705
.L634:
	movq	hs(%rip), %rdi
	movl	%ebx, %esi
	call	httpd_get_conn
	testl	%eax, %eax
	je	.L637
	cmpl	$2, %eax
	je	.L653
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L639
	cmpb	$3, %al
	jle	.L706
.L639:
	leaq	4(%rbp), %rdi
	movl	$1, 0(%rbp)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L640
	testb	%dl, %dl
	jne	.L707
.L640:
	movl	4(%rbp), %eax
	addl	$1, num_connects(%rip)
	cmpb	$0, 2147450880(%r15)
	movl	$-1, 4(%rbp)
	movl	%eax, first_free_connect(%rip)
	jne	.L708
	leaq	88(%rbp), %rdi
	movq	0(%r13), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L709
	leaq	96(%rbp), %rdi
	movq	%rax, 88(%rbp)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L710
	leaq	104(%rbp), %rdi
	movq	$0, 96(%rbp)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L711
	leaq	136(%rbp), %rdi
	movq	$0, 104(%rbp)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L712
	movq	$0, 136(%rbp)
	leaq	56(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L646
	cmpb	$3, %al
	jle	.L713
.L646:
	movq	%r14, %rax
	movl	$0, 56(%rbp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L714
	movq	8(%rbp), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L648
	cmpb	$3, %dl
	jle	.L715
.L648:
	movl	704(%rax), %edi
	call	httpd_set_ndelay
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L716
	movq	8(%rbp), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L650
	cmpb	$3, %dl
	jle	.L717
.L650:
	movl	704(%rax), %edi
	xorl	%edx, %edx
	movq	%rbp, %rsi
	call	fdwatch_add_fd
	addq	$1, stats_connections(%rip)
	movl	num_connects(%rip), %eax
	cmpl	stats_simultaneous(%rip), %eax
	jle	.L651
	movl	%eax, stats_simultaneous(%rip)
	jmp	.L651
	.p2align 4,,10
	.p2align 3
.L653:
	movl	$1, %eax
.L627:
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L637:
	.cfi_restore_state
	movq	%r13, %rdi
	movl	%eax, 12(%rsp)
	call	tmr_run
	movl	12(%rsp), %eax
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L705:
	.cfi_restore_state
	movl	$720, %edi
	call	malloc
	movq	%rax, 8(%rbp)
	movq	%rax, %rdx
	testq	%rax, %rax
	je	.L718
	movq	%rax, %rcx
	shrq	$3, %rcx
	movzbl	2147450880(%rcx), %ecx
	testb	%cl, %cl
	je	.L636
	cmpb	$3, %cl
	jle	.L719
.L636:
	addl	$1, httpd_conn_count(%rip)
	movl	$0, (%rax)
	jmp	.L634
.L706:
	movq	%rbp, %rdi
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L702:
	xorl	%eax, %eax
	movl	$.LC87, %esi
	movl	$4, %edi
	call	syslog
	movq	%r13, %rdi
	call	tmr_run
	xorl	%eax, %eax
	jmp	.L627
.L630:
	movl	$2, %edi
	movl	$.LC88, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L704:
	movq	%r14, %rdi
	call	__asan_report_load8
.L703:
	movq	%rbp, %rdi
	call	__asan_report_load4
.L707:
	call	__asan_report_load4
.L716:
	movq	%r14, %rdi
	call	__asan_report_load8
.L717:
	call	__asan_report_load4
.L708:
	movq	%r13, %rdi
	call	__asan_report_load8
.L709:
	call	__asan_report_store8
.L710:
	call	__asan_report_store8
.L711:
	call	__asan_report_store8
.L712:
	call	__asan_report_store8
.L713:
	call	__asan_report_store4
.L714:
	movq	%r14, %rdi
	call	__asan_report_load8
.L715:
	call	__asan_report_load4
.L719:
	movq	%rax, %rdi
	call	__asan_report_store4
.L718:
	movl	$2, %edi
	movl	$.LC89, %esi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE19:
	.size	handle_newconnect, .-handle_newconnect
	.section	.rodata
	.align 32
.LC90:
	.string	"throttle sending count was negative - shouldn't happen!"
	.zero	40
	.text
	.p2align 4
	.type	check_throttles, @function
check_throttles:
.LASANPC23:
.LFB23:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	leaq	56(%rdi), %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%r13, %rax
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	shrq	$3, %rax
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L721
	cmpb	$3, %al
	jle	.L804
.L721:
	leaq	72(%rbx), %rax
	movl	$0, 56(%rbx)
	movq	%rax, 16(%rsp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L805
	leaq	64(%rbx), %rax
	movq	$-1, 72(%rbx)
	movq	%rax, 8(%rsp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L806
	leaq	8(%rbx), %rax
	movq	$-1, 64(%rbx)
	xorl	%ebp, %ebp
	movq	%rax, 24(%rsp)
	shrq	$3, %rax
	movq	%rax, (%rsp)
	movl	numthrottles(%rip), %eax
	testl	%eax, %eax
	jg	.L724
	jmp	.L746
	.p2align 4,,10
	.p2align 3
.L820:
	addl	$1, %edi
	cqto
	movslq	%edi, %rsi
	idivq	%rsi
.L735:
	movq	%r13, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L739
	cmpb	$3, %dl
	jle	.L807
.L739:
	movslq	56(%rbx), %rsi
	leal	1(%rsi), %edx
	leaq	16(%rbx,%rsi,4), %r11
	movl	%edx, 56(%rbx)
	movq	%r11, %rdx
	movq	%r11, %r8
	shrq	$3, %rdx
	andl	$7, %r8d
	movzbl	2147450880(%rdx), %edx
	addl	$3, %r8d
	cmpb	%dl, %r8b
	jl	.L740
	testb	%dl, %dl
	jne	.L808
.L740:
	movq	%r10, %rdx
	movl	%r14d, 16(%rbx,%rsi,4)
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L741
	cmpb	$3, %dl
	jle	.L809
.L741:
	movq	8(%rsp), %rdx
	movl	%edi, 40(%rcx)
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L810
	movq	64(%rbx), %rdx
	cmpq	$-1, %rdx
	je	.L743
	cmpq	%rdx, %rax
	cmovg	%rdx, %rax
.L743:
	movq	%rax, 64(%rbx)
	movq	16(%rsp), %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L811
	movq	72(%rbx), %rax
	cmpq	$-1, %rax
	je	.L803
	cmpq	%r9, %rax
	cmovge	%rax, %r9
.L803:
	movq	%r9, 72(%rbx)
.L729:
	addl	$1, %r12d
	cmpl	%r12d, numthrottles(%rip)
	jle	.L746
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L747
	cmpb	$3, %al
	jle	.L812
.L747:
	addq	$1, %rbp
	cmpl	$9, 56(%rbx)
	jg	.L746
.L724:
	movq	(%rsp), %rax
	movl	%ebp, %r12d
	movl	%ebp, %r14d
	cmpb	$0, 2147450880(%rax)
	jne	.L813
	movq	8(%rbx), %rax
	leaq	240(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L814
	leaq	0(%rbp,%rbp,2), %r8
	movq	throttles(%rip), %rdi
	movq	240(%rax), %rsi
	movq	%r8, %r15
	salq	$4, %r15
	addq	%r15, %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L815
	movq	(%rdi), %rdi
	call	match
	testl	%eax, %eax
	je	.L729
	movq	throttles(%rip), %rcx
	addq	%r15, %rcx
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L816
	leaq	8(%rcx), %rdi
	movq	24(%rcx), %rdx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L817
	movq	8(%rcx), %rax
	leaq	(%rax,%rax), %rsi
	cmpq	%rsi, %rdx
	jg	.L750
	leaq	16(%rcx), %rdi
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L818
	movq	16(%rcx), %r9
	cmpq	%r9, %rdx
	jl	.L750
	leaq	40(%rcx), %r10
	movq	%r10, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L733
	cmpb	$3, %dl
	jle	.L819
.L733:
	movl	40(%rcx), %edi
	testl	%edi, %edi
	jns	.L820
	xorl	%eax, %eax
	movl	$.LC90, %esi
	movl	$3, %edi
	call	syslog
	movq	throttles(%rip), %rcx
	addq	%r15, %rcx
	leaq	40(%rcx), %r10
	movq	%r10, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L736
	cmpb	$3, %al
	jle	.L821
.L736:
	leaq	8(%rcx), %rdi
	movl	$0, 40(%rcx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L822
	leaq	16(%rcx), %rdi
	movq	8(%rcx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L823
	movq	16(%rcx), %r9
	movl	$1, %edi
	jmp	.L735
	.p2align 4,,10
	.p2align 3
.L746:
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movl	$1, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L750:
	.cfi_restore_state
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L815:
	.cfi_restore_state
	call	__asan_report_load8
.L814:
	call	__asan_report_load8
.L813:
	movq	24(%rsp), %rdi
	call	__asan_report_load8
.L812:
	movq	%r13, %rdi
	call	__asan_report_load4
.L811:
	movq	16(%rsp), %rdi
	call	__asan_report_load8
.L810:
	movq	8(%rsp), %rdi
	call	__asan_report_load8
.L809:
	movq	%r10, %rdi
	call	__asan_report_store4
.L808:
	movq	%r11, %rdi
	call	__asan_report_store4
.L807:
	movq	%r13, %rdi
	call	__asan_report_load4
.L819:
	movq	%r10, %rdi
	call	__asan_report_load4
.L818:
	call	__asan_report_load8
.L817:
	call	__asan_report_load8
.L816:
	call	__asan_report_load8
.L823:
	call	__asan_report_load8
.L822:
	call	__asan_report_load8
.L821:
	movq	%r10, %rdi
	call	__asan_report_store4
.L804:
	movq	%r13, %rdi
	call	__asan_report_store4
.L806:
	movq	8(%rsp), %rdi
	call	__asan_report_store8
.L805:
	movq	16(%rsp), %rdi
	call	__asan_report_store8
	.cfi_endproc
.LFE23:
	.size	check_throttles, .-check_throttles
	.section	.rodata.str1.1
.LC91:
	.string	"1 32 16 7 tv:1469"
	.text
	.p2align 4
	.type	shut_down, @function
shut_down:
.LASANPC18:
.LFB18:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movl	__asan_option_detect_stack_use_after_return(%rip), %edx
	leaq	16(%rsp), %rbp
	testl	%edx, %edx
	jne	.L881
.L824:
	movq	%rbp, %rax
	movq	$1102416563, 0(%rbp)
	xorl	%esi, %esi
	xorl	%r15d, %r15d
	shrq	$3, %rax
	movq	$.LC91, 8(%rbp)
	leaq	32(%rbp), %r13
	xorl	%ebx, %ebx
	movq	$.LASANPC18, 16(%rbp)
	movq	%r13, %rdi
	movq	%rax, 8(%rsp)
	movl	$-235802127, 2147450880(%rax)
	movl	$-202178560, 2147450884(%rax)
	call	gettimeofday
	movq	%r13, %rdi
	call	logstats
	movl	max_connects(%rip), %eax
	movq	%r13, (%rsp)
	testl	%eax, %eax
	jg	.L828
	jmp	.L838
	.p2align 4,,10
	.p2align 3
.L833:
	testq	%rdi, %rdi
	je	.L835
	call	httpd_destroy_conn
	movq	connects(%rip), %r12
	addq	%r15, %r12
	leaq	8(%r12), %r14
	movq	%r14, %r13
	shrq	$3, %r13
	cmpb	$0, 2147450880(%r13)
	jne	.L882
	movq	8(%r12), %rdi
	call	free
	subl	$1, httpd_conn_count(%rip)
	cmpb	$0, 2147450880(%r13)
	jne	.L883
	movq	$0, 8(%r12)
.L835:
	addl	$1, %ebx
	addq	$144, %r15
	cmpl	%ebx, max_connects(%rip)
	jle	.L838
.L828:
	movq	connects(%rip), %rdi
	addq	%r15, %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L831
	cmpb	$3, %al
	jle	.L884
.L831:
	leaq	8(%rdi), %r8
	movl	(%rdi), %eax
	movq	%r8, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L885
	movq	8(%rdi), %rdi
	testl	%eax, %eax
	je	.L833
	movq	(%rsp), %rsi
	call	httpd_close_conn
	movq	connects(%rip), %rax
	addq	%r15, %rax
	leaq	8(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L886
	movq	8(%rax), %rdi
	jmp	.L833
	.p2align 4,,10
	.p2align 3
.L838:
	movq	hs(%rip), %r13
	testq	%r13, %r13
	je	.L830
	movq	$0, hs(%rip)
	leaq	72(%r13), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L839
	cmpb	$3, %al
	jle	.L887
.L839:
	movl	72(%r13), %edi
	cmpl	$-1, %edi
	jne	.L888
.L840:
	leaq	76(%r13), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L841
	testb	%dl, %dl
	jne	.L889
.L841:
	movl	76(%r13), %edi
	cmpl	$-1, %edi
	jne	.L890
.L842:
	movq	%r13, %rdi
	call	httpd_terminate
.L830:
	call	mmc_destroy
	call	tmr_destroy
	movq	connects(%rip), %rdi
	call	free
	movq	throttles(%rip), %rdi
	testq	%rdi, %rdi
	je	.L827
	call	free
.L827:
	leaq	16(%rsp), %rax
	cmpq	%rbp, %rax
	jne	.L891
	movq	8(%rsp), %rax
	movq	$0, 2147450880(%rax)
.L826:
	addq	$88, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L888:
	.cfi_restore_state
	call	fdwatch_del_fd
	jmp	.L840
	.p2align 4,,10
	.p2align 3
.L890:
	call	fdwatch_del_fd
	jmp	.L842
.L884:
	call	__asan_report_load4
.L885:
	movq	%r8, %rdi
	call	__asan_report_load8
.L882:
	movq	%r14, %rdi
	call	__asan_report_load8
.L883:
	movq	%r14, %rdi
	call	__asan_report_store8
.L886:
	call	__asan_report_load8
.L891:
	movq	$1172321806, 0(%rbp)
	movq	8(%rsp), %rax
	movabsq	$-723401728380766731, %rcx
	movq	%rcx, 2147450880(%rax)
	jmp	.L826
.L881:
	movl	$64, %edi
	call	__asan_stack_malloc_0
	testq	%rax, %rax
	cmovne	%rax, %rbp
	jmp	.L824
.L889:
	call	__asan_report_load4
.L887:
	call	__asan_report_load4
	.cfi_endproc
.LFE18:
	.size	shut_down, .-shut_down
	.section	.rodata
	.align 32
.LC92:
	.string	"exiting"
	.zero	56
	.text
	.p2align 4
	.type	handle_usr1, @function
handle_usr1:
.LASANPC5:
.LFB5:
	.cfi_startproc
	movl	num_connects(%rip), %eax
	testl	%eax, %eax
	je	.L897
	movl	$1, got_usr1(%rip)
	ret
	.p2align 4,,10
	.p2align 3
.L897:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	shut_down
	movl	$5, %edi
	movl	$.LC92, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
	.cfi_endproc
.LFE5:
	.size	handle_usr1, .-handle_usr1
	.section	.rodata
	.align 32
.LC93:
	.string	"exiting due to signal %d"
	.zero	39
	.text
	.p2align 4
	.type	handle_term, @function
handle_term:
.LASANPC2:
.LFB2:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movl	%edi, %r12d
	call	shut_down
	movl	$5, %edi
	movl	%r12d, %edx
	xorl	%eax, %eax
	movl	$.LC93, %esi
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE2:
	.size	handle_term, .-handle_term
	.p2align 4
	.type	clear_throttles.isra.0, @function
clear_throttles.isra.0:
.LASANPC36:
.LFB36:
	.cfi_startproc
	leaq	56(%rdi), %r8
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%r8, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L901
	cmpb	$3, %al
	jle	.L926
.L901:
	movl	56(%rdi), %eax
	testl	%eax, %eax
	jle	.L900
	subl	$1, %eax
	movq	throttles(%rip), %rsi
	leaq	16(%rdi), %r8
	leaq	20(%rdi,%rax,4), %rcx
	.p2align 4,,10
	.p2align 3
.L905:
	movq	%r8, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%r8, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L903
	testb	%dl, %dl
	jne	.L927
.L903:
	movslq	(%r8), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%rsi, %rax
	leaq	40(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L904
	cmpb	$3, %dl
	jle	.L928
.L904:
	addq	$4, %r8
	subl	$1, 40(%rax)
	cmpq	%rcx, %r8
	jne	.L905
.L900:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L926:
	.cfi_restore_state
	movq	%r8, %rdi
	call	__asan_report_load4
.L928:
	call	__asan_report_load4
.L927:
	movq	%r8, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE36:
	.size	clear_throttles.isra.0, .-clear_throttles.isra.0
	.p2align 4
	.type	really_clear_connection, @function
really_clear_connection:
.LASANPC28:
.LFB28:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	leaq	8(%rdi), %r13
	movq	%r13, %rax
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	shrq	$3, %rax
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	cmpb	$0, 2147450880(%rax)
	jne	.L969
	movq	%rdi, %rbp
	movq	8(%rdi), %rdi
	leaq	200(%rdi), %r8
	movq	%r8, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L970
	movq	200(%rdi), %rax
	addq	%rax, stats_bytes(%rip)
	movq	%rbp, %rax
	movq	%rsi, %r12
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L932
	cmpb	$3, %al
	jle	.L971
.L932:
	cmpl	$3, 0(%rbp)
	jne	.L972
.L933:
	leaq	104(%rbp), %r13
	movq	%r12, %rsi
	call	httpd_close_conn
	movq	%r13, %r12
	movq	%rbp, %rdi
	call	clear_throttles.isra.0
	shrq	$3, %r12
	cmpb	$0, 2147450880(%r12)
	jne	.L973
	movq	104(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L937
	call	tmr_cancel
	cmpb	$0, 2147450880(%r12)
	jne	.L974
	movq	$0, 104(%rbp)
.L937:
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L939
	cmpb	$3, %al
	jle	.L975
.L939:
	leaq	4(%rbp), %rdi
	movl	$0, 0(%rbp)
	movl	first_free_connect(%rip), %ecx
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L940
	testb	%dl, %dl
	jne	.L976
.L940:
	movabsq	$-8198552921648689607, %rdi
	movl	%ecx, 4(%rbp)
	subq	connects(%rip), %rbp
	sarq	$4, %rbp
	subl	$1, num_connects(%rip)
	imulq	%rdi, %rbp
	movl	%ebp, first_free_connect(%rip)
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L972:
	.cfi_restore_state
	leaq	704(%rdi), %r8
	movq	%r8, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L934
	cmpb	$3, %al
	jle	.L977
.L934:
	movl	704(%rdi), %edi
	call	fdwatch_del_fd
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L978
	movq	8(%rbp), %rdi
	jmp	.L933
.L976:
	call	__asan_report_store4
.L975:
	movq	%rbp, %rdi
	call	__asan_report_store4
.L971:
	movq	%rbp, %rdi
	call	__asan_report_load4
.L970:
	movq	%r8, %rdi
	call	__asan_report_load8
.L969:
	movq	%r13, %rdi
	call	__asan_report_load8
.L973:
	movq	%r13, %rdi
	call	__asan_report_load8
.L974:
	movq	%r13, %rdi
	call	__asan_report_store8
.L977:
	movq	%r8, %rdi
	call	__asan_report_load4
.L978:
	movq	%r13, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE28:
	.size	really_clear_connection, .-really_clear_connection
	.section	.rodata
	.align 32
.LC94:
	.string	"replacing non-null linger_timer!"
	.zero	63
	.align 32
.LC95:
	.string	"tmr_create(linger_clear_connection) failed"
	.zero	53
	.text
	.p2align 4
	.type	clear_connection, @function
clear_connection:
.LASANPC27:
.LFB27:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	leaq	96(%rdi), %r14
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%r14, %r13
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	shrq	$3, %r13
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	cmpb	$0, 2147450880(%r13)
	jne	.L1052
	movq	%rdi, %rbp
	movq	96(%rdi), %rdi
	movq	%rsi, %r12
	testq	%rdi, %rdi
	je	.L981
	call	tmr_cancel
	cmpb	$0, 2147450880(%r13)
	jne	.L1053
	movq	$0, 96(%rbp)
.L981:
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L983
	cmpb	$3, %al
	jle	.L1054
.L983:
	movl	0(%rbp), %ecx
	cmpl	$4, %ecx
	je	.L1055
	leaq	8(%rbp), %r13
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1056
	movq	8(%rbp), %rax
	leaq	556(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %esi
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%sil, %dl
	jl	.L991
	testb	%sil, %sil
	jne	.L1057
.L991:
	movl	556(%rax), %edx
	testl	%edx, %edx
	je	.L989
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L992
	cmpb	$3, %dl
	jle	.L1058
.L992:
	movl	704(%rax), %edi
	cmpl	$3, %ecx
	jne	.L1059
.L993:
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L996
	cmpb	$3, %al
	jle	.L1060
.L996:
	movl	$4, 0(%rbp)
	movl	$1, %esi
	call	shutdown
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1061
	movq	8(%rbp), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L998
	cmpb	$3, %dl
	jle	.L1062
.L998:
	movl	704(%rax), %edi
	xorl	%edx, %edx
	movq	%rbp, %rsi
	leaq	104(%rbp), %r13
	call	fdwatch_add_fd
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1063
	cmpq	$0, 104(%rbp)
	je	.L1000
	movl	$.LC94, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L1000:
	xorl	%r8d, %r8d
	movq	%rbp, %rdx
	movl	$500, %ecx
	movl	$linger_clear_connection, %esi
	movq	%r12, %rdi
	call	tmr_create
	movq	%r13, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1064
	movq	%rax, 104(%rbp)
	testq	%rax, %rax
	je	.L1065
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1059:
	.cfi_restore_state
	call	fdwatch_del_fd
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1066
	movq	8(%rbp), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L995
	cmpb	$3, %dl
	jle	.L1067
.L995:
	movl	704(%rax), %edi
	jmp	.L993
	.p2align 4,,10
	.p2align 3
.L1055:
	leaq	104(%rbp), %r14
	movq	%r14, %r13
	shrq	$3, %r13
	cmpb	$0, 2147450880(%r13)
	jne	.L1068
	movq	104(%rbp), %rdi
	call	tmr_cancel
	cmpb	$0, 2147450880(%r13)
	jne	.L1069
	leaq	8(%rbp), %rdi
	movq	$0, 104(%rbp)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1070
	movq	8(%rbp), %rdx
	leaq	556(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L988
	testb	%cl, %cl
	jne	.L1071
.L988:
	movl	$0, 556(%rdx)
.L989:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movq	%r12, %rsi
	movq	%rbp, %rdi
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	jmp	really_clear_connection
.L1054:
	.cfi_restore_state
	movq	%rbp, %rdi
	call	__asan_report_load4
.L1057:
	call	__asan_report_load4
.L1062:
	call	__asan_report_load4
.L1060:
	movq	%rbp, %rdi
	call	__asan_report_store4
.L1058:
	call	__asan_report_load4
.L1067:
	call	__asan_report_load4
.L1071:
	call	__asan_report_store4
.L1052:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1056:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1064:
	movq	%r13, %rdi
	call	__asan_report_store8
.L1063:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1061:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1053:
	movq	%r14, %rdi
	call	__asan_report_store8
.L1065:
	movl	$2, %edi
	movl	$.LC95, %esi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1066:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1069:
	movq	%r14, %rdi
	call	__asan_report_store8
.L1070:
	call	__asan_report_load8
.L1068:
	movq	%r14, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE27:
	.size	clear_connection, .-clear_connection
	.p2align 4
	.type	finish_connection, @function
finish_connection:
.LASANPC26:
.LFB26:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rdi, %rbp
	addq	$8, %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	cmpb	$0, 2147450880(%rax)
	jne	.L1075
	movq	8(%rbp), %rdi
	movq	%rsi, %r12
	call	httpd_write_response
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%r12, %rsi
	movq	%rbp, %rdi
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	clear_connection
.L1075:
	.cfi_restore_state
	call	__asan_report_load8
	.cfi_endproc
.LFE26:
	.size	finish_connection, .-finish_connection
	.p2align 4
	.type	handle_read, @function
handle_read:
.LASANPC20:
.LFB20:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r12
	addq	$8, %rdi
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdi, %rax
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	shrq	$3, %rax
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	cmpb	$0, 2147450880(%rax)
	jne	.L1193
	movq	8(%r12), %rbp
	leaq	160(%rbp), %r14
	movq	%r14, %rbx
	shrq	$3, %rbx
	cmpb	$0, 2147450880(%rbx)
	jne	.L1194
	leaq	152(%rbp), %r15
	movq	%rsi, %r13
	movq	160(%rbp), %rsi
	movq	%r15, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1195
	movq	152(%rbp), %rdx
	leaq	144(%rbp), %rdi
	cmpq	%rdx, %rsi
	jb	.L1080
	cmpq	$5000, %rdx
	ja	.L1196
	leaq	144(%rbp), %rdi
	addq	$1000, %rdx
	movq	%r15, %rsi
	movq	%rax, 8(%rsp)
	movq	%rdi, (%rsp)
	call	httpd_realloc_str
	movq	8(%rsp), %rax
	movq	(%rsp), %rdi
	cmpb	$0, 2147450880(%rax)
	jne	.L1197
	cmpb	$0, 2147450880(%rbx)
	movq	152(%rbp), %rdx
	jne	.L1198
	movq	160(%rbp), %rsi
.L1080:
	movq	%rdi, %rax
	subq	%rsi, %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1199
	leaq	704(%rbp), %r15
	addq	144(%rbp), %rsi
	movq	%r15, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1087
	cmpb	$3, %al
	jle	.L1200
.L1087:
	movl	704(%rbp), %edi
	call	read
	testl	%eax, %eax
	je	.L1201
	jns	.L1091
	call	__errno_location
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1092
	testb	%cl, %cl
	jne	.L1202
.L1092:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1076
	cmpl	$11, %eax
	je	.L1076
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1203
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L1101
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L1091:
	movq	%r14, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1204
	cltq
	addq	%rax, 160(%rbp)
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1205
	leaq	88(%r12), %rdi
	movq	0(%r13), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1206
	movq	%rax, 88(%r12)
	movq	%rbp, %rdi
	call	httpd_got_request
	testl	%eax, %eax
	je	.L1076
	cmpl	$2, %eax
	je	.L1207
	movq	%rbp, %rdi
	call	httpd_parse_request
	testl	%eax, %eax
	js	.L1192
	movq	%r12, %rdi
	call	check_throttles
	testl	%eax, %eax
	je	.L1208
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	httpd_start_request
	testl	%eax, %eax
	js	.L1192
	leaq	528(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1108
	cmpb	$3, %al
	jle	.L1209
.L1108:
	movl	528(%rbp), %eax
	testl	%eax, %eax
	je	.L1109
	leaq	536(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1210
	leaq	136(%r12), %rdi
	movq	536(%rbp), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1211
	leaq	544(%rbp), %rdi
	movq	%rax, 136(%r12)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1212
	leaq	128(%r12), %rdi
	movq	544(%rbp), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	addq	$1, %rax
	cmpb	$0, 2147450880(%rdx)
	jne	.L1213
.L1118:
	movq	%rax, 128(%r12)
.L1114:
	leaq	712(%rbp), %r8
	movq	%r8, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1214
	cmpq	$0, 712(%rbp)
	je	.L1215
	leaq	136(%r12), %r8
	movq	%r8, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1216
	movq	%rdi, %rdx
	movq	136(%r12), %rax
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1217
	cmpq	128(%r12), %rax
	jge	.L1192
	movq	%r12, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1131
	cmpb	$3, %al
	jle	.L1218
.L1131:
	movq	%r13, %rax
	movl	$2, (%r12)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1219
	leaq	80(%r12), %rdi
	movq	0(%r13), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1220
	leaq	112(%r12), %rdi
	movq	%rax, 80(%r12)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1221
	movq	$0, 112(%r12)
	movq	%r15, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1135
	cmpb	$3, %al
	jle	.L1222
.L1135:
	movl	704(%rbp), %edi
	call	fdwatch_del_fd
	movq	%r15, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1136
	cmpb	$3, %al
	jle	.L1223
.L1136:
	movl	704(%rbp), %edi
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rsi
	movl	$1, %edx
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	fdwatch_add_fd
	.p2align 4,,10
	.p2align 3
.L1196:
	.cfi_restore_state
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1224
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1225
.L1101:
	movl	$.LC49, %r9d
	movq	httpd_err400title(%rip), %rdx
	movl	$400, %esi
	movq	%rbp, %rdi
	movq	%r9, %rcx
	call	httpd_send_err
.L1192:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r13, %rsi
	movq	%r12, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	finish_connection
	.p2align 4,,10
	.p2align 3
.L1076:
	.cfi_restore_state
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1207:
	.cfi_restore_state
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1226
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L1101
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L1201:
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1227
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L1101
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L1208:
	leaq	208(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1228
	movl	$httpd_err503form, %eax
	movq	208(%rbp), %r9
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1229
	movl	$httpd_err503title, %eax
	movq	httpd_err503form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1230
	movq	httpd_err503title(%rip), %rdx
	movl	$.LC49, %ecx
	movl	$503, %esi
	movq	%rbp, %rdi
	call	httpd_send_err
	jmp	.L1192
.L1200:
	movq	%r15, %rdi
	call	__asan_report_load4
.L1202:
	movq	%rax, %rdi
	call	__asan_report_load4
.L1203:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L1109:
	leaq	192(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1231
	movq	192(%rbp), %rax
	leaq	128(%r12), %rdi
	testq	%rax, %rax
	js	.L1232
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	je	.L1118
	call	__asan_report_store8
	.p2align 4,,10
	.p2align 3
.L1232:
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1233
	movq	$0, 128(%r12)
	jmp	.L1114
.L1215:
	leaq	56(%r12), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1121
	cmpb	$3, %al
	jle	.L1234
.L1121:
	leaq	200(%rbp), %rdi
	movl	56(%r12), %eax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1235
	movq	200(%rbp), %rcx
	testl	%eax, %eax
	jle	.L1128
	subl	$1, %eax
	movq	throttles(%rip), %r9
	leaq	16(%r12), %rdi
	leaq	20(%r12,%rax,4), %rsi
	.p2align 4,,10
	.p2align 3
.L1127:
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1125
	testb	%dl, %dl
	jne	.L1236
.L1125:
	movslq	(%rdi), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%r9, %rax
	leaq	32(%rax), %r8
	movq	%r8, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1237
	addq	$4, %rdi
	addq	%rcx, 32(%rax)
	cmpq	%rsi, %rdi
	jne	.L1127
.L1128:
	leaq	136(%r12), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1238
	movq	%rcx, 136(%r12)
	jmp	.L1192
.L1195:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1194:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1193:
	call	__asan_report_load8
.L1199:
	call	__asan_report_load8
.L1198:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1197:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1225:
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
.L1227:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1204:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1205:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1206:
	call	__asan_report_store8
.L1224:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1237:
	movq	%r8, %rdi
	call	__asan_report_load8
.L1238:
	call	__asan_report_store8
.L1235:
	call	__asan_report_load8
.L1236:
	call	__asan_report_load4
.L1231:
	call	__asan_report_load8
.L1234:
	call	__asan_report_load4
.L1226:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1229:
	movl	$httpd_err503form, %edi
	call	__asan_report_load8
.L1228:
	call	__asan_report_load8
.L1230:
	movl	$httpd_err503title, %edi
	call	__asan_report_load8
.L1210:
	call	__asan_report_load8
.L1209:
	call	__asan_report_load4
.L1218:
	movq	%r12, %rdi
	call	__asan_report_store4
.L1220:
	call	__asan_report_store8
.L1219:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1221:
	call	__asan_report_store8
.L1223:
	movq	%r15, %rdi
	call	__asan_report_load4
.L1214:
	movq	%r8, %rdi
	call	__asan_report_load8
.L1213:
	call	__asan_report_store8
.L1212:
	call	__asan_report_load8
.L1211:
	call	__asan_report_store8
.L1217:
	call	__asan_report_load8
.L1222:
	movq	%r15, %rdi
	call	__asan_report_load4
.L1216:
	movq	%r8, %rdi
	call	__asan_report_load8
.L1233:
	call	__asan_report_store8
	.cfi_endproc
.LFE20:
	.size	handle_read, .-handle_read
	.section	.rodata
	.align 32
.LC96:
	.string	"%.80s connection timed out reading"
	.zero	61
	.align 32
.LC97:
	.string	"%.80s connection timed out sending"
	.zero	61
	.text
	.p2align 4
	.type	idle, @function
idle:
.LASANPC29:
.LFB29:
	.cfi_startproc
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L1265
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rsi, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	shrq	$3, %r15
	movq	%rsi, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movl	$httpd_err408form, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	shrq	$3, %r12
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	xorl	%ebx, %ebx
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	jmp	.L1256
	.p2align 4,,10
	.p2align 3
.L1273:
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L1243
	cmpb	$0, 2147450880(%r15)
	jne	.L1268
	leaq	88(%rbp), %rdi
	movq	(%r14), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1269
	subq	88(%rbp), %rax
	cmpq	$299, %rax
	jg	.L1270
.L1243:
	addq	$1, %rbx
	cmpl	%ebx, max_connects(%rip)
	jle	.L1271
.L1256:
	leaq	(%rbx,%rbx,8), %rbp
	salq	$4, %rbp
	addq	connects(%rip), %rbp
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1241
	cmpb	$3, %al
	jle	.L1272
.L1241:
	movl	0(%rbp), %eax
	cmpl	$1, %eax
	jne	.L1273
	cmpb	$0, 2147450880(%r15)
	jne	.L1274
	leaq	88(%rbp), %rdi
	movq	(%r14), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1275
	subq	88(%rbp), %rax
	cmpq	$59, %rax
	jle	.L1243
	leaq	8(%rbp), %r13
	movq	%r13, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1276
	movq	8(%rbp), %rax
	movq	%rcx, 8(%rsp)
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC96, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	syslog
	movq	8(%rsp), %rcx
	cmpb	$0, 2147450880(%r12)
	jne	.L1277
	movl	$httpd_err408title, %eax
	movq	httpd_err408form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1278
	cmpb	$0, 2147450880(%rcx)
	movq	httpd_err408title(%rip), %rdx
	jne	.L1279
	movl	$.LC49, %r9d
	movq	8(%rbp), %rdi
	movl	$408, %esi
	addq	$1, %rbx
	movq	%r9, %rcx
	call	httpd_send_err
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	finish_connection
	cmpl	%ebx, max_connects(%rip)
	jg	.L1256
.L1271:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1270:
	.cfi_restore_state
	leaq	8(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1280
	movq	8(%rbp), %rax
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC97, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	syslog
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	clear_connection
	jmp	.L1243
	.p2align 4,,10
	.p2align 3
.L1265:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	ret
.L1272:
	.cfi_def_cfa_offset 80
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	%rbp, %rdi
	call	__asan_report_load4
.L1269:
	call	__asan_report_load8
.L1268:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1275:
	call	__asan_report_load8
.L1274:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1280:
	call	__asan_report_load8
.L1279:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1278:
	movl	$httpd_err408title, %edi
	call	__asan_report_load8
.L1277:
	movl	$httpd_err408form, %edi
	call	__asan_report_load8
.L1276:
	movq	%r13, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE29:
	.size	idle, .-idle
	.globl	__asan_stack_malloc_1
	.section	.rodata.str1.1
.LC98:
	.string	"1 32 32 7 iv:1734"
	.section	.rodata
	.align 32
.LC99:
	.string	"replacing non-null wakeup_timer!"
	.zero	63
	.align 32
.LC100:
	.string	"tmr_create(wakeup_connection) failed"
	.zero	59
	.align 32
.LC101:
	.string	"write - %m sending %.80s"
	.zero	39
	.text
	.p2align 4
	.type	handle_send, @function
handle_send:
.LASANPC21:
.LFB21:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$152, %rsp
	.cfi_def_cfa_offset 208
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	48(%rsp), %r15
	testl	%eax, %eax
	jne	.L1436
.L1281:
	leaq	8(%rbp), %r13
	movq	%r15, %rbx
	movq	$1102416563, (%r15)
	leaq	96(%r15), %rax
	movq	%r13, %rdx
	shrq	$3, %rbx
	movq	$.LC98, 8(%r15)
	shrq	$3, %rdx
	movq	$.LASANPC21, 16(%r15)
	movl	$-235802127, 2147450880(%rbx)
	movl	$-202116109, 2147450888(%rbx)
	cmpb	$0, 2147450880(%rdx)
	jne	.L1437
	leaq	64(%rbp), %rdx
	movq	8(%rbp), %rcx
	movq	%rdx, 8(%rsp)
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1438
	movq	64(%rbp), %rsi
	movl	$1000000000, %edx
	cmpq	$-1, %rsi
	je	.L1287
	testq	%rsi, %rsi
	leaq	3(%rsi), %rdx
	cmovns	%rsi, %rdx
	sarq	$2, %rdx
.L1287:
	leaq	472(%rcx), %r10
	movq	%r10, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1439
	cmpq	$0, 472(%rcx)
	jne	.L1289
	leaq	128(%rbp), %rax
	movq	%rax, (%rsp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1440
	leaq	136(%rbp), %r9
	movq	128(%rbp), %rax
	movq	%r9, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1441
	movq	136(%rbp), %rsi
	leaq	712(%rcx), %rdi
	subq	%rsi, %rax
	cmpq	%rdx, %rax
	cmovbe	%rax, %rdx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1442
	leaq	704(%rcx), %r14
	addq	712(%rcx), %rsi
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1293
	cmpb	$3, %al
	jle	.L1443
.L1293:
	movl	704(%rcx), %edi
	movq	%r9, 32(%rsp)
	movq	%r10, 24(%rsp)
	movq	%rcx, 16(%rsp)
	call	write
	movq	16(%rsp), %rcx
	movq	24(%rsp), %r10
	movq	32(%rsp), %r9
	testl	%eax, %eax
	js	.L1444
.L1304:
	jne	.L1445
.L1352:
	leaq	112(%rbp), %r13
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1446
	movq	%rbp, %rax
	addq	$100, 112(%rbp)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1309
	cmpb	$3, %al
	jle	.L1447
.L1309:
	movq	%r14, %rax
	movl	$3, 0(%rbp)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1310
	cmpb	$3, %al
	jle	.L1448
.L1310:
	movl	704(%rcx), %edi
	leaq	96(%rbp), %r14
	call	fdwatch_del_fd
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1449
	cmpq	$0, 96(%rbp)
	je	.L1312
	movl	$.LC99, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L1312:
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1450
	movq	112(%rbp), %rcx
	xorl	%r8d, %r8d
	movq	%rbp, %rdx
	movl	$wakeup_connection, %esi
	movq	%r12, %rdi
	call	tmr_create
	movq	%r14, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1451
.L1314:
	movq	%rax, 96(%rbp)
	testq	%rax, %rax
	je	.L1452
.L1284:
	leaq	48(%rsp), %rax
	cmpq	%r15, %rax
	jne	.L1453
	movq	$0, 2147450880(%rbx)
	movl	$0, 2147450888(%rbx)
.L1283:
	addq	$152, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1289:
	.cfi_restore_state
	leaq	368(%rcx), %rdi
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1454
	leaq	-64(%rax), %r11
	movq	368(%rcx), %rsi
	movq	%r11, %rdi
	shrq	$3, %rdi
	cmpb	$0, 2147450880(%rdi)
	jne	.L1455
	leaq	-56(%rax), %rdi
	movq	%rsi, -64(%rax)
	movq	472(%rcx), %rsi
	movq	%rdi, %r8
	shrq	$3, %r8
	cmpb	$0, 2147450880(%r8)
	jne	.L1456
	leaq	712(%rcx), %rdi
	movq	%rsi, -56(%rax)
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1457
	leaq	136(%rbp), %r9
	movq	712(%rcx), %rsi
	movq	%r9, %rdi
	shrq	$3, %rdi
	cmpb	$0, 2147450880(%rdi)
	jne	.L1458
	leaq	-48(%rax), %r8
	movq	136(%rbp), %rdi
	movq	%r8, %r14
	shrq	$3, %r14
	addq	%rdi, %rsi
	cmpb	$0, 2147450880(%r14)
	jne	.L1459
	movq	%rsi, -48(%rax)
	leaq	128(%rbp), %rsi
	movq	%rsi, (%rsp)
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1460
	movq	128(%rbp), %rsi
	subq	%rdi, %rsi
	leaq	-40(%rax), %rdi
	cmpq	%rdx, %rsi
	cmovbe	%rsi, %rdx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1461
	leaq	704(%rcx), %r14
	movq	%rdx, -40(%rax)
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1303
	cmpb	$3, %al
	jle	.L1462
.L1303:
	movl	704(%rcx), %edi
	movq	%r11, %rsi
	movl	$2, %edx
	movq	%r9, 40(%rsp)
	movq	%r10, 32(%rsp)
	movq	%rcx, 24(%rsp)
	movq	%r11, 16(%rsp)
	call	writev
	movq	16(%rsp), %r11
	movq	40(%rsp), %r9
	movq	32(%rsp), %r10
	movq	24(%rsp), %rcx
	shrq	$3, %r11
	movl	$-117901064, 2147450880(%r11)
	testl	%eax, %eax
	jns	.L1304
.L1444:
	movq	%rcx, (%rsp)
	call	__errno_location
	movq	(%rsp), %rcx
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %esi
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%sil, %dl
	jl	.L1305
	testb	%sil, %sil
	jne	.L1463
.L1305:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1284
	cmpl	$11, %eax
	je	.L1352
	cmpl	$32, %eax
	setne	%sil
	cmpl	$22, %eax
	setne	%dl
	testb	%dl, %sil
	je	.L1315
	cmpl	$104, %eax
	jne	.L1464
.L1315:
	movq	%r12, %rsi
	movq	%rbp, %rdi
	call	clear_connection
	jmp	.L1284
	.p2align 4,,10
	.p2align 3
.L1445:
	movq	%r12, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1465
	leaq	88(%rbp), %rdi
	movq	(%r12), %rdx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1466
	movq	%rdx, 88(%rbp)
	movq	%r10, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1467
	movq	472(%rcx), %rdx
	testq	%rdx, %rdx
	jne	.L1321
.L1435:
	movslq	%eax, %rdx
.L1322:
	movq	%r9, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1468
	movq	136(%rbp), %r8
	movq	%r13, %rax
	shrq	$3, %rax
	addq	%rdx, %r8
	cmpb	$0, 2147450880(%rax)
	movq	%r8, 136(%rbp)
	jne	.L1469
	movq	8(%rbp), %rax
	leaq	200(%rax), %rdi
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1470
	movq	200(%rax), %rdi
	addq	%rdx, %rdi
	movq	%rdi, 200(%rax)
	movq	%rdi, 16(%rsp)
	leaq	56(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1328
	cmpb	$3, %al
	jle	.L1471
.L1328:
	movl	56(%rbp), %eax
	testl	%eax, %eax
	jle	.L1336
	subl	$1, %eax
	movq	throttles(%rip), %r11
	leaq	16(%rbp), %rdi
	leaq	20(%rbp,%rax,4), %r10
	.p2align 4,,10
	.p2align 3
.L1335:
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %esi
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%sil, %al
	jl	.L1333
	testb	%sil, %sil
	jne	.L1472
.L1333:
	movslq	(%rdi), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%r11, %rax
	leaq	32(%rax), %r9
	movq	%r9, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1473
	addq	$4, %rdi
	addq	%rdx, 32(%rax)
	cmpq	%r10, %rdi
	jne	.L1335
.L1336:
	movq	(%rsp), %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1474
	cmpq	128(%rbp), %r8
	jge	.L1475
	leaq	112(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1476
	movq	112(%rbp), %rax
	cmpq	$100, %rax
	jg	.L1477
.L1338:
	movq	8(%rsp), %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1478
	movq	64(%rbp), %rsi
	cmpq	$-1, %rsi
	je	.L1284
	leaq	80(%rbp), %rdi
	movq	(%r12), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1479
	subq	80(%rbp), %rax
	movq	%rax, %r8
	je	.L1355
	movq	16(%rsp), %rax
	cqto
	idivq	%r8
	movq	%rax, 16(%rsp)
.L1341:
	cmpq	16(%rsp), %rsi
	jge	.L1284
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1342
	cmpb	$3, %al
	jg	.L1342
	movq	%rbp, %rdi
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L1321:
	movslq	%eax, %rsi
	cmpq	%rsi, %rdx
	ja	.L1480
	movq	$0, 472(%rcx)
	subl	%edx, %eax
	jmp	.L1435
	.p2align 4,,10
	.p2align 3
.L1477:
	subq	$100, %rax
	movq	%rax, 112(%rbp)
	jmp	.L1338
	.p2align 4,,10
	.p2align 3
.L1355:
	movl	$1, %r8d
	jmp	.L1341
	.p2align 4,,10
	.p2align 3
.L1342:
	movq	%r14, %rax
	movl	$3, 0(%rbp)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1343
	cmpb	$3, %al
	jg	.L1343
	movq	%r14, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1343:
	movl	704(%rcx), %edi
	movq	%r8, (%rsp)
	call	fdwatch_del_fd
	movq	%r13, %rax
	movq	(%rsp), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1481
	movq	8(%rbp), %rax
	leaq	200(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1482
	movq	8(%rsp), %rdx
	movq	200(%rax), %rax
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1483
	cqto
	leaq	96(%rbp), %r13
	idivq	64(%rbp)
	movl	%eax, %r14d
	movq	%r13, %rax
	shrq	$3, %rax
	subl	%r8d, %r14d
	cmpb	$0, 2147450880(%rax)
	jne	.L1484
	cmpq	$0, 96(%rbp)
	je	.L1348
	movl	$.LC99, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L1348:
	movl	$500, %ecx
	testl	%r14d, %r14d
	jle	.L1349
	movslq	%r14d, %r14
	imulq	$1000, %r14, %rcx
.L1349:
	xorl	%r8d, %r8d
	movq	%rbp, %rdx
	movl	$wakeup_connection, %esi
	movq	%r12, %rdi
	call	tmr_create
	movq	%r13, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	je	.L1314
	movq	%r13, %rdi
	call	__asan_report_store8
	.p2align 4,,10
	.p2align 3
.L1475:
	movq	%r12, %rsi
	movq	%rbp, %rdi
	call	finish_connection
	jmp	.L1284
	.p2align 4,,10
	.p2align 3
.L1480:
	leaq	368(%rcx), %rdi
	subl	%eax, %edx
	movq	%rdi, %rax
	movslq	%edx, %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1485
	movq	368(%rcx), %rdi
	movq	%r9, 32(%rsp)
	movq	%rcx, 24(%rsp)
	addq	%rdi, %rsi
	movq	%rdx, 16(%rsp)
	call	memmove
	movq	16(%rsp), %rdx
	movq	24(%rsp), %rcx
	movq	32(%rsp), %r9
	movq	%rdx, 472(%rcx)
	xorl	%edx, %edx
	jmp	.L1322
.L1448:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1447:
	movq	%rbp, %rdi
	call	__asan_report_store4
.L1471:
	call	__asan_report_load4
.L1442:
	call	__asan_report_load8
.L1454:
	call	__asan_report_load8
.L1456:
	call	__asan_report_store8
.L1455:
	movq	%r11, %rdi
	call	__asan_report_store8
.L1460:
	movq	(%rsp), %rdi
	call	__asan_report_load8
.L1459:
	movq	%r8, %rdi
	call	__asan_report_store8
.L1458:
	movq	%r9, %rdi
	call	__asan_report_load8
.L1457:
	call	__asan_report_load8
.L1461:
	call	__asan_report_store8
.L1441:
	movq	%r9, %rdi
	call	__asan_report_load8
.L1440:
	movq	(%rsp), %rdi
	call	__asan_report_load8
.L1443:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1462:
	movq	%r14, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1464:
	leaq	208(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1486
	movq	208(%rcx), %rdx
	movl	$.LC101, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L1315
.L1473:
	movq	%r9, %rdi
	call	__asan_report_load8
.L1472:
	call	__asan_report_load4
.L1436:
	movl	$96, %edi
	call	__asan_stack_malloc_1
	testq	%rax, %rax
	cmovne	%rax, %r15
	jmp	.L1281
.L1439:
	movq	%r10, %rdi
	call	__asan_report_load8
.L1466:
	call	__asan_report_store8
.L1465:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1469:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1470:
	call	__asan_report_load8
.L1474:
	movq	(%rsp), %rdi
	call	__asan_report_load8
.L1463:
	movq	%rax, %rdi
	call	__asan_report_load4
.L1438:
	movq	8(%rsp), %rdi
	call	__asan_report_load8
.L1446:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1467:
	movq	%r10, %rdi
	call	__asan_report_load8
.L1450:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1451:
	movq	%r14, %rdi
	call	__asan_report_store8
.L1452:
	movl	$2, %edi
	movl	$.LC100, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1453:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, (%r15)
	movq	%rax, 2147450880(%rbx)
	movl	$-168430091, 2147450888(%rbx)
	jmp	.L1283
.L1437:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1449:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1468:
	movq	%r9, %rdi
	call	__asan_report_load8
.L1476:
	call	__asan_report_load8
.L1478:
	movq	8(%rsp), %rdi
	call	__asan_report_load8
.L1479:
	call	__asan_report_load8
.L1485:
	call	__asan_report_load8
.L1486:
	call	__asan_report_load8
.L1484:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1483:
	movq	8(%rsp), %rdi
	call	__asan_report_load8
.L1482:
	call	__asan_report_load8
.L1481:
	movq	%r13, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE21:
	.size	handle_send, .-handle_send
	.section	.rodata.str1.1
.LC102:
	.string	"1 32 8 16 client_data:2118"
	.text
	.p2align 4
	.type	linger_clear_connection, @function
linger_clear_connection:
.LASANPC31:
.LFB31:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$88, %rsp
	.cfi_def_cfa_offset 128
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	16(%rsp), %rbx
	movq	%rbx, %r13
	testl	%eax, %eax
	jne	.L1494
.L1487:
	leaq	32(%rbx), %rdi
	movq	%rbx, %r12
	movq	$1102416563, (%rbx)
	movq	%rdi, %rax
	shrq	$3, %r12
	movq	$.LC102, 8(%rbx)
	shrq	$3, %rax
	movq	$.LASANPC31, 16(%rbx)
	movl	$-235802127, 2147450880(%r12)
	movl	$-202116352, 2147450884(%r12)
	cmpb	$0, 2147450880(%rax)
	movq	%rbp, 32(%rbx)
	jne	.L1495
	leaq	104(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1496
	movq	$0, 104(%rbp)
	movq	%rbp, %rdi
	call	really_clear_connection
	cmpq	%rbx, %r13
	jne	.L1497
	movq	$0, 2147450880(%r12)
.L1489:
	addq	$88, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L1494:
	.cfi_restore_state
	movl	$64, %edi
	movq	%rsi, 8(%rsp)
	call	__asan_stack_malloc_0
	movq	8(%rsp), %rsi
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L1487
.L1497:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, (%rbx)
	movq	%rax, 2147450880(%r12)
	jmp	.L1489
.L1496:
	call	__asan_report_store8
.L1495:
	call	__asan_report_load8
	.cfi_endproc
.LFE31:
	.size	linger_clear_connection, .-linger_clear_connection
	.globl	__asan_stack_malloc_7
	.section	.rodata.str1.1
.LC103:
	.string	"1 32 4096 8 buf:1867"
	.globl	__asan_stack_free_7
	.text
	.p2align 4
	.type	handle_linger, @function
handle_linger:
.LASANPC22:
.LFB22:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rsi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$4256, %rsp
	.cfi_def_cfa_offset 4304
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rsp, %rbp
	movq	%rbp, %r14
	testl	%eax, %eax
	jne	.L1521
.L1498:
	leaq	8(%r12), %rdi
	movq	%rbp, %rbx
	movq	$1102416563, 0(%rbp)
	leaq	4256(%rbp), %rsi
	movq	%rdi, %rax
	shrq	$3, %rbx
	movq	$.LC103, 8(%rbp)
	shrq	$3, %rax
	movq	$.LASANPC22, 16(%rbp)
	movl	$-235802127, 2147450880(%rbx)
	movl	$-202116109, 2147451396(%rbx)
	movl	$-202116109, 2147451400(%rbx)
	movl	$-202116109, 2147451404(%rbx)
	movl	$-202116109, 2147451408(%rbx)
	cmpb	$0, 2147450880(%rax)
	jne	.L1522
	movq	8(%r12), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1503
	cmpb	$3, %dl
	jle	.L1523
.L1503:
	movl	704(%rax), %edi
	subq	$4224, %rsi
	movl	$4096, %edx
	call	read
	testl	%eax, %eax
	js	.L1524
	je	.L1507
.L1501:
	cmpq	%rbp, %r14
	jne	.L1525
	movl	$0, 2147450880(%rbx)
	pxor	%xmm0, %xmm0
	movups	%xmm0, 2147451396(%rbx)
.L1500:
	addq	$4256, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1524:
	.cfi_restore_state
	call	__errno_location
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1505
	testb	%cl, %cl
	jne	.L1526
.L1505:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1501
	cmpl	$11, %eax
	je	.L1501
.L1507:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	really_clear_connection
	jmp	.L1501
.L1523:
	call	__asan_report_load4
.L1522:
	call	__asan_report_load8
.L1521:
	movl	$4256, %edi
	call	__asan_stack_malloc_7
	testq	%rax, %rax
	cmovne	%rax, %rbp
	jmp	.L1498
.L1525:
	movq	$1172321806, 0(%rbp)
	movq	%r14, %rdx
	movl	$4256, %esi
	movq	%rbp, %rdi
	call	__asan_stack_free_7
	jmp	.L1500
.L1526:
	movq	%rax, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE22:
	.size	handle_linger, .-handle_linger
	.section	.rodata.str1.8
	.align 8
.LC104:
	.string	"3 48 8 7 ai:1242 80 10 12 portstr:1240 112 48 10 hints:1239"
	.section	.rodata
	.align 32
.LC105:
	.string	"%d"
	.zero	61
	.align 32
.LC106:
	.string	"getaddrinfo %.80s - %.80s"
	.zero	38
	.align 32
.LC107:
	.string	"%s: getaddrinfo %s - %s\n"
	.zero	39
	.align 32
.LC108:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.zero	57
	.text
	.p2align 4
	.type	lookup_hostname.constprop.0, @function
lookup_hostname.constprop.0:
.LASANPC37:
.LFB37:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rdi, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rdx, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$232, %rsp
	.cfi_def_cfa_offset 288
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rsi, 16(%rsp)
	leaq	32(%rsp), %rbx
	movq	%rcx, 8(%rsp)
	testl	%eax, %eax
	jne	.L1622
.L1527:
	movq	%rbx, %rbp
	movq	$1102416563, (%rbx)
	leaq	112(%rbx), %rdi
	xorl	%esi, %esi
	shrq	$3, %rbp
	movq	$.LC104, 8(%rbx)
	movl	$48, %edx
	leaq	192(%rbx), %r15
	movq	$.LASANPC37, 16(%rbx)
	movl	$-235802127, 2147450880(%rbp)
	movl	$-234881024, 2147450884(%rbp)
	movl	$33554432, 2147450888(%rbp)
	movl	$62194, 2147450892(%rbp)
	movl	$-202116109, 2147450900(%rbp)
	call	memset
	movq	%rax, %rdi
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1531
	cmpb	$3, %al
	jle	.L1623
.L1531:
	leaq	-72(%r15), %rdi
	movl	$1, -80(%r15)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1532
	cmpb	$3, %al
	jle	.L1624
.L1532:
	leaq	-112(%r15), %r8
	movl	$.LC105, %edx
	movl	$10, %esi
	xorl	%eax, %eax
	movzwl	port(%rip), %ecx
	movq	%r8, %rdi
	movq	%r8, 24(%rsp)
	leaq	-144(%r15), %r12
	movl	$1, -72(%r15)
	call	snprintf
	movq	24(%rsp), %r8
	leaq	-80(%r15), %rdx
	movq	%r12, %rcx
	movq	hostname(%rip), %rdi
	movq	%r8, %rsi
	call	getaddrinfo
	testl	%eax, %eax
	jne	.L1625
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1626
	movq	-144(%r15), %r15
	xorl	%r12d, %r12d
	xorl	%ecx, %ecx
	movq	%r15, %rax
	testq	%r15, %r15
	jne	.L1536
	jmp	.L1627
	.p2align 4,,10
	.p2align 3
.L1631:
	cmpl	$10, %edx
	jne	.L1541
	testq	%rcx, %rcx
	cmove	%rax, %rcx
.L1541:
	leaq	40(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1628
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L1629
.L1536:
	leaq	4(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %esi
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%sil, %dl
	jl	.L1539
	testb	%sil, %sil
	jne	.L1630
.L1539:
	movl	4(%rax), %edx
	cmpl	$2, %edx
	jne	.L1631
	testq	%r12, %r12
	cmove	%rax, %r12
	jmp	.L1541
	.p2align 4,,10
	.p2align 3
.L1629:
	testq	%rcx, %rcx
	je	.L1632
	leaq	16(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1546
	cmpb	$3, %al
	jle	.L1633
.L1546:
	movl	16(%rcx), %r8d
	cmpq	$128, %r8
	ja	.L1621
	movl	$128, %edx
	xorl	%esi, %esi
	movq	%r13, %rdi
	movq	%rcx, 24(%rsp)
	call	memset
	movq	24(%rsp), %rcx
	leaq	24(%rcx), %rdi
	movl	16(%rcx), %edx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1634
	movq	24(%rcx), %rsi
	movq	%r13, %rdi
	call	memmove
	movq	8(%rsp), %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1549
	cmpb	$3, %al
	jle	.L1635
.L1549:
	movq	8(%rsp), %rax
	movl	$1, (%rax)
.L1545:
	testq	%r12, %r12
	je	.L1538
	leaq	16(%r12), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1553
	cmpb	$3, %al
	jle	.L1636
.L1553:
	movl	16(%r12), %r8d
	cmpq	$128, %r8
	ja	.L1621
	movl	$128, %edx
	xorl	%esi, %esi
	movq	%r14, %rdi
	call	memset
	leaq	24(%r12), %rdi
	movl	16(%r12), %edx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1637
	movq	24(%r12), %rsi
	movq	%r14, %rdi
	call	memmove
	movq	16(%rsp), %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1556
	cmpb	$3, %al
	jle	.L1638
.L1556:
	movq	16(%rsp), %rax
	movl	$1, (%rax)
.L1552:
	movq	%r15, %rdi
	call	freeaddrinfo
	leaq	32(%rsp), %rax
	cmpq	%rbx, %rax
	jne	.L1639
	movl	$0, 2147450900(%rbp)
	pxor	%xmm0, %xmm0
	movups	%xmm0, 2147450880(%rbp)
.L1529:
	addq	$232, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L1627:
	.cfi_restore_state
	movq	8(%rsp), %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1537
	cmpb	$3, %al
	jle	.L1640
.L1537:
	movq	8(%rsp), %rax
	movl	$0, (%rax)
.L1538:
	movq	16(%rsp), %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1551
	cmpb	$3, %al
	jle	.L1641
.L1551:
	movq	16(%rsp), %rax
	movl	$0, (%rax)
	jmp	.L1552
.L1632:
	movq	8(%rsp), %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1544
	cmpb	$3, %al
	jle	.L1642
.L1544:
	movq	8(%rsp), %rax
	movl	$0, (%rax)
	jmp	.L1545
.L1623:
	call	__asan_report_store4
.L1624:
	call	__asan_report_store4
.L1628:
	call	__asan_report_load8
.L1630:
	call	__asan_report_load4
.L1626:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1622:
	movl	$192, %edi
	call	__asan_stack_malloc_2
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L1527
.L1639:
	movdqa	.LC46(%rip), %xmm0
	movq	$1172321806, (%rbx)
	movabsq	$-723401728380766731, %rax
	movq	%rax, 2147450896(%rbp)
	movups	%xmm0, 2147450880(%rbp)
	jmp	.L1529
.L1621:
	movq	hostname(%rip), %rdx
	movl	$2, %edi
	movl	$128, %ecx
	xorl	%eax, %eax
	movl	$.LC108, %esi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1641:
	movq	16(%rsp), %rdi
	call	__asan_report_store4
.L1642:
	movq	8(%rsp), %rdi
	call	__asan_report_store4
.L1640:
	movq	8(%rsp), %rdi
	call	__asan_report_store4
.L1633:
	call	__asan_report_load4
.L1636:
	call	__asan_report_load4
.L1635:
	movq	8(%rsp), %rdi
	call	__asan_report_store4
.L1625:
	movl	%eax, %edi
	movl	%eax, 8(%rsp)
	call	gai_strerror
	movl	$.LC106, %esi
	movl	$2, %edi
	movq	hostname(%rip), %rdx
	movq	%rax, %rcx
	xorl	%eax, %eax
	call	syslog
	movl	8(%rsp), %r8d
	movl	%r8d, %edi
	call	gai_strerror
	movq	hostname(%rip), %rcx
	movq	argv0(%rip), %rdx
	movq	%rax, %r8
	movl	$stderr, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1643
	movq	stderr(%rip), %rdi
	movl	$.LC107, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1637:
	call	__asan_report_load8
.L1643:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1634:
	call	__asan_report_load8
.L1638:
	movq	16(%rsp), %rdi
	call	__asan_report_store4
	.cfi_endproc
.LFE37:
	.size	lookup_hostname.constprop.0, .-lookup_hostname.constprop.0
	.section	.rodata.str1.8
	.align 8
.LC109:
	.string	"6 48 4 9 gotv4:367 64 4 9 gotv6:367 80 16 6 tv:368 112 128 7 sa4:365 272 128 7 sa6:366 432 4097 7 cwd:358"
	.section	.rodata
	.align 32
.LC110:
	.string	"can't find any valid address"
	.zero	35
	.align 32
.LC111:
	.string	"%s: can't find any valid address\n"
	.zero	62
	.align 32
.LC112:
	.string	"unknown user - '%.80s'"
	.zero	41
	.align 32
.LC113:
	.string	"%s: unknown user - '%s'\n"
	.zero	39
	.align 32
.LC114:
	.string	"/dev/null"
	.zero	54
	.align 32
.LC115:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.zero	61
	.align 32
.LC116:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
	.zero	56
	.align 32
.LC117:
	.string	"fchown logfile - %m"
	.zero	44
	.align 32
.LC118:
	.string	"fchown logfile"
	.zero	49
	.align 32
.LC119:
	.string	"chdir - %m"
	.zero	53
	.align 32
.LC120:
	.string	"chdir"
	.zero	58
	.align 32
.LC121:
	.string	"/"
	.zero	62
	.align 32
.LC122:
	.string	"daemon - %m"
	.zero	52
	.align 32
.LC123:
	.string	"w"
	.zero	62
	.align 32
.LC124:
	.string	"%d\n"
	.zero	60
	.align 32
.LC125:
	.string	"fdwatch initialization failure"
	.zero	33
	.align 32
.LC126:
	.string	"chroot - %m"
	.zero	52
	.align 32
.LC127:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.zero	54
	.align 32
.LC128:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
	.zero	49
	.align 32
.LC129:
	.string	"chroot chdir - %m"
	.zero	46
	.align 32
.LC130:
	.string	"chroot chdir"
	.zero	51
	.align 32
.LC131:
	.string	"data_dir chdir - %m"
	.zero	44
	.align 32
.LC132:
	.string	"data_dir chdir"
	.zero	49
	.align 32
.LC133:
	.string	"tmr_create(occasional) failed"
	.zero	34
	.align 32
.LC134:
	.string	"tmr_create(idle) failed"
	.zero	40
	.align 32
.LC135:
	.string	"tmr_create(update_throttles) failed"
	.zero	60
	.align 32
.LC136:
	.string	"tmr_create(show_stats) failed"
	.zero	34
	.align 32
.LC137:
	.string	"setgroups - %m"
	.zero	49
	.align 32
.LC138:
	.string	"setgid - %m"
	.zero	52
	.align 32
.LC139:
	.string	"initgroups - %m"
	.zero	48
	.align 32
.LC140:
	.string	"setuid - %m"
	.zero	52
	.align 32
.LC141:
	.string	"started as root without requesting chroot(), warning only"
	.zero	38
	.align 32
.LC142:
	.string	"out of memory allocating a connecttab"
	.zero	58
	.align 32
.LC143:
	.string	"fdwatch - %m"
	.zero	51
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LASANPC9:
.LFB9:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movl	%edi, %r14d
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$4872, %rsp
	.cfi_def_cfa_offset 4928
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	64(%rsp), %rbp
	testl	%eax, %eax
	jne	.L1949
.L1644:
	movq	%rbp, %rax
	movq	$1102416563, 0(%rbp)
	leaq	4800(%rbp), %rbx
	shrq	$3, %rax
	movq	$.LC109, 8(%rbp)
	movq	$.LASANPC9, 16(%rbp)
	movl	$-235802127, 2147450880(%rax)
	movl	$-234556943, 2147450884(%rax)
	movl	$61956, 2147450888(%rax)
	movl	$62194, 2147450892(%rax)
	movl	$-219021312, 2147450908(%rax)
	movl	$62194, 2147450912(%rax)
	movl	$-219021312, 2147450928(%rax)
	movl	$62194, 2147450932(%rax)
	movl	$-218038272, 2147451444(%rax)
	movl	$-202116109, 2147451448(%rax)
	movl	$-202116109, 2147451452(%rax)
	movl	$-202116109, 2147451456(%rax)
	movl	$-202116109, 2147451460(%rax)
	movl	$-202116109, 2147451464(%rax)
	movl	$-202116109, 2147451468(%rax)
	movl	$-202116109, 2147451472(%rax)
	movl	$-202116109, 2147451476(%rax)
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1950
	movq	(%r12), %r13
	movl	$47, %esi
	leaq	272(%rbp), %r15
	movq	%r13, %rdi
	movq	%r13, argv0(%rip)
	call	strrchr
	movl	$9, %esi
	testq	%rax, %rax
	leaq	1(%rax), %rdx
	cmovne	%rdx, %r13
	movl	$24, %edx
	movq	%r13, %rdi
	leaq	48(%rbp), %r13
	call	openlog
	movl	%r14d, %edi
	movq	%r12, %rsi
	leaq	64(%rbp), %r14
	call	parse_args
	call	tzset
	leaq	112(%rbp), %rax
	movq	%r14, %rcx
	movq	%r15, %rdx
	movq	%rax, %rdi
	movq	%r13, %rsi
	movq	%rax, 8(%rsp)
	call	lookup_hostname.constprop.0
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1650
	cmpb	$3, %al
	jle	.L1951
.L1650:
	movq	%r14, %rax
	movl	-4752(%rbx), %edx
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1651
	cmpb	$3, %al
	jle	.L1952
.L1651:
	orl	-4736(%rbx), %edx
	je	.L1953
	movq	throttlefile(%rip), %rdi
	movl	$0, numthrottles(%rip)
	movl	$0, maxthrottles(%rip)
	movq	$0, throttles(%rip)
	testq	%rdi, %rdi
	je	.L1654
	call	read_throttlefile
.L1654:
	call	getuid
	movl	$32767, 20(%rsp)
	movl	$32767, 40(%rsp)
	testl	%eax, %eax
	je	.L1954
.L1655:
	movq	logfile(%rip), %rbp
	testq	%rbp, %rbp
	je	.L1660
	movl	$.LC114, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L1661
	movl	$1, no_log(%rip)
	xorl	%ebp, %ebp
.L1660:
	movq	dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1669
	call	chdir
	testl	%eax, %eax
	js	.L1955
.L1669:
	leaq	-4368(%rbx), %r12
	movl	$4096, %esi
	movq	%r12, %rdi
	call	getcwd
	movq	%r12, %rdi
	call	strlen
	leaq	-1(%rax), %rdx
	leaq	(%r12,%rdx), %rdi
	movq	%rdi, %rcx
	movq	%rdi, %rsi
	shrq	$3, %rcx
	andl	$7, %esi
	movzbl	2147450880(%rcx), %ecx
	cmpb	%sil, %cl
	jg	.L1670
	testb	%cl, %cl
	jne	.L1956
.L1670:
	cmpb	$47, -4368(%rdx,%rbx)
	jne	.L1957
.L1671:
	cmpl	$0, debug(%rip)
	je	.L1958
	call	setsid
.L1677:
	movq	pidfile(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1678
	movl	$.LC123, %esi
	call	fopen
	testq	%rax, %rax
	je	.L1959
	movq	%rax, 24(%rsp)
	call	getpid
	movq	24(%rsp), %rdi
	movl	$.LC124, %esi
	movl	%eax, %edx
	xorl	%eax, %eax
	call	fprintf
	movq	24(%rsp), %rdi
	call	fclose
.L1678:
	call	fdwatch_get_nfiles
	movl	%eax, max_connects(%rip)
	testl	%eax, %eax
	js	.L1960
	subl	$10, %eax
	cmpl	$0, do_chroot(%rip)
	movl	%eax, max_connects(%rip)
	jne	.L1961
.L1681:
	movq	data_dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1686
	call	chdir
	testl	%eax, %eax
	js	.L1962
.L1686:
	movl	$handle_term, %esi
	movl	$15, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_term, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_chld, %esi
	movl	$17, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$1, %esi
	movl	$13, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_hup, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_usr1, %esi
	movl	$10, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_usr2, %esi
	movl	$12, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_alrm, %esi
	movl	$14, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$360, %edi
	movl	$0, got_hup(%rip)
	movl	$0, got_usr1(%rip)
	movl	$0, watchdog_flag(%rip)
	call	alarm
	call	tmr_init
	movl	do_global_passwd(%rip), %eax
	movq	%r14, %rdx
	movl	no_empty_referers(%rip), %r11d
	shrq	$3, %rdx
	movq	local_pattern(%rip), %r10
	movq	url_pattern(%rip), %rdi
	movl	%eax, 24(%rsp)
	movl	do_vhost(%rip), %eax
	movzbl	2147450880(%rdx), %edx
	movl	cgi_limit(%rip), %r9d
	movl	%eax, 32(%rsp)
	movl	no_symlink_check(%rip), %eax
	movq	cgi_pattern(%rip), %r8
	movzwl	port(%rip), %ecx
	movl	%eax, 44(%rsp)
	movl	no_log(%rip), %eax
	movl	%eax, 48(%rsp)
	movl	max_age(%rip), %eax
	movl	%eax, 52(%rsp)
	movq	p3p(%rip), %rax
	movq	%rax, 56(%rsp)
	movq	charset(%rip), %rax
	testb	%dl, %dl
	je	.L1687
	cmpb	$3, %dl
	jle	.L1963
.L1687:
	cmpl	$0, -4736(%rbx)
	movl	$0, %edx
	movq	%r13, %rsi
	cmovne	%r15, %rdx
	shrq	$3, %rsi
	movzbl	2147450880(%rsi), %esi
	testb	%sil, %sil
	je	.L1689
	cmpb	$3, %sil
	jle	.L1964
.L1689:
	cmpl	$0, -4752(%rbx)
	movl	$0, %esi
	cmovne	8(%rsp), %rsi
	pushq	%r11
	.cfi_def_cfa_offset 4936
	pushq	%r10
	.cfi_def_cfa_offset 4944
	pushq	%rdi
	.cfi_def_cfa_offset 4952
	movl	48(%rsp), %edi
	pushq	%rdi
	.cfi_def_cfa_offset 4960
	movl	64(%rsp), %edi
	pushq	%rdi
	.cfi_def_cfa_offset 4968
	movl	84(%rsp), %edi
	pushq	%rdi
	.cfi_def_cfa_offset 4976
	pushq	%rbp
	.cfi_def_cfa_offset 4984
	movl	104(%rsp), %edi
	pushq	%rdi
	.cfi_def_cfa_offset 4992
	pushq	%r12
	.cfi_def_cfa_offset 5000
	movl	124(%rsp), %edi
	pushq	%rdi
	.cfi_def_cfa_offset 5008
	movq	hostname(%rip), %rdi
	pushq	136(%rsp)
	.cfi_def_cfa_offset 5016
	pushq	%rax
	.cfi_def_cfa_offset 5024
	call	httpd_initialize
	addq	$96, %rsp
	.cfi_def_cfa_offset 4928
	movq	%rax, hs(%rip)
	testq	%rax, %rax
	je	.L1946
	movl	$JunkClientData, %ebp
	movq	%rbp, %r12
	shrq	$3, %r12
	cmpb	$0, 2147450880(%r12)
	jne	.L1965
	movq	JunkClientData(%rip), %rdx
	movl	$occasional, %esi
	movl	$1, %r8d
	xorl	%edi, %edi
	movl	$120000, %ecx
	call	tmr_create
	movl	$.LC133, %esi
	testq	%rax, %rax
	je	.L1947
	cmpb	$0, 2147450880(%r12)
	jne	.L1966
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$5000, %ecx
	movl	$idle, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L1967
	cmpl	$0, numthrottles(%rip)
	jle	.L1696
	cmpb	$0, 2147450880(%r12)
	jne	.L1968
	movq	JunkClientData(%rip), %rdx
	movl	$update_throttles, %esi
	movl	$1, %r8d
	xorl	%edi, %edi
	movl	$2000, %ecx
	call	tmr_create
	movl	$.LC135, %esi
	testq	%rax, %rax
	je	.L1947
.L1696:
	movq	%rbp, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1969
	movq	JunkClientData(%rip), %rdx
	movl	$show_stats, %esi
	movl	$1, %r8d
	xorl	%edi, %edi
	movl	$3600000, %ecx
	call	tmr_create
	movl	$.LC136, %esi
	testq	%rax, %rax
	je	.L1947
	xorl	%edi, %edi
	call	time
	movq	$0, stats_connections(%rip)
	movq	%rax, stats_time(%rip)
	movq	%rax, start_time(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	call	getuid
	testl	%eax, %eax
	je	.L1970
.L1701:
	movslq	max_connects(%rip), %r12
	movq	%r12, %rbp
	imulq	$144, %r12, %r12
	movq	%r12, %rdi
	call	malloc
	movq	%rax, connects(%rip)
	testq	%rax, %rax
	je	.L1707
	movq	%rax, %rdi
	xorl	%edx, %edx
	jmp	.L1708
.L1712:
	movq	%rdi, %rcx
	shrq	$3, %rcx
	movzbl	2147450880(%rcx), %ecx
	testb	%cl, %cl
	je	.L1709
	cmpb	$3, %cl
	jle	.L1971
.L1709:
	leaq	4(%rdi), %r8
	movl	$0, (%rdi)
	addl	$1, %edx
	movq	%r8, %rcx
	shrq	$3, %rcx
	movzbl	2147450880(%rcx), %esi
	movq	%r8, %rcx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%sil, %cl
	jl	.L1710
	testb	%sil, %sil
	jne	.L1972
.L1710:
	leaq	8(%rdi), %r8
	movl	%edx, 4(%rdi)
	movq	%r8, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1973
	movq	$0, 8(%rdi)
	addq	$144, %rdi
.L1708:
	cmpl	%edx, %ebp
	jg	.L1712
	leaq	-144(%rax,%r12), %rdx
	leaq	4(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1713
	testb	%cl, %cl
	jne	.L1974
.L1713:
	movq	hs(%rip), %rax
	movl	$-1, 4(%rdx)
	movl	$0, first_free_connect(%rip)
	movl	$0, num_connects(%rip)
	movl	$0, httpd_conn_count(%rip)
	testq	%rax, %rax
	je	.L1715
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1716
	cmpb	$3, %dl
	jle	.L1975
.L1716:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1717
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
	movq	hs(%rip), %rax
.L1717:
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1718
	testb	%cl, %cl
	jne	.L1976
.L1718:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1715
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
.L1715:
	subq	$4720, %rbx
	movq	%rbx, %rdi
	call	tmr_prepare_timeval
.L1720:
	cmpl	$0, terminate(%rip)
	je	.L1752
	cmpl	$0, num_connects(%rip)
	jle	.L1977
.L1752:
	movl	got_hup(%rip), %eax
	testl	%eax, %eax
	jne	.L1978
.L1721:
	movq	%rbx, %rdi
	call	tmr_mstimeout
	movq	%rax, %rdi
	call	fdwatch
	movl	%eax, %ebp
	testl	%eax, %eax
	jns	.L1722
	call	__errno_location
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1723
	testb	%cl, %cl
	jne	.L1979
.L1723:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1720
	cmpl	$11, %eax
	je	.L1720
	movl	$.LC143, %esi
	movl	$3, %edi
	jmp	.L1948
.L1958:
	movl	$stdin, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1980
	movq	stdin(%rip), %rdi
	call	fclose
	movl	$stdout, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1981
	movq	stdout(%rip), %rdi
	cmpq	%rbp, %rdi
	je	.L1675
	call	fclose
.L1675:
	movl	$stderr, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1982
	movq	stderr(%rip), %rdi
	call	fclose
	movl	$1, %esi
	movl	$1, %edi
	call	daemon
	movl	$.LC122, %esi
	testl	%eax, %eax
	jns	.L1677
.L1945:
	movl	$2, %edi
.L1948:
	xorl	%eax, %eax
	call	syslog
.L1946:
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1957:
	leaq	(%r12,%rax), %rdi
	movl	$2, %edx
	movl	$.LC121, %esi
	call	memcpy
	jmp	.L1671
.L1661:
	movl	$.LC83, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L1662
	movl	$stdout, %eax
	movq	stdout(%rip), %rbp
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L1660
	movl	$stdout, %edi
	call	__asan_report_load8
.L1954:
	movq	user(%rip), %rdi
	call	getpwnam
	testq	%rax, %rax
	je	.L1983
	leaq	16(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1658
	cmpb	$3, %dl
	jle	.L1984
.L1658:
	leaq	20(%rax), %rdi
	movl	16(%rax), %ecx
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movl	%ecx, 40(%rsp)
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1659
	testb	%cl, %cl
	jne	.L1985
.L1659:
	movl	20(%rax), %eax
	movl	%eax, 20(%rsp)
	jmp	.L1655
.L1955:
	movl	$.LC119, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC120, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1662:
	movq	%rbp, %rdi
	movl	$.LC85, %esi
	call	fopen
	movq	logfile(%rip), %r12
	movl	$384, %esi
	movq	%rax, %rbp
	movq	%r12, %rdi
	call	chmod
	testq	%rbp, %rbp
	je	.L1756
	testl	%eax, %eax
	jne	.L1756
	movq	%r12, %rax
	movq	%r12, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L1666
	testb	%al, %al
	je	.L1666
	movq	%r12, %rdi
	call	__asan_report_load1
.L1666:
	cmpb	$47, (%r12)
	jne	.L1986
.L1667:
	movq	%rbp, %rdi
	call	fileno
	movl	$1, %edx
	movl	$2, %esi
	movl	%eax, %edi
	xorl	%eax, %eax
	call	fcntl
	call	getuid
	testl	%eax, %eax
	jne	.L1660
	movq	%rbp, %rdi
	call	fileno
	movl	20(%rsp), %edx
	movl	40(%rsp), %esi
	movl	%eax, %edi
	call	fchown
	testl	%eax, %eax
	jns	.L1660
	movl	$.LC117, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC118, %edi
	call	perror
	jmp	.L1660
.L1967:
	movl	$.LC134, %esi
.L1947:
	movl	$2, %edi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1953:
	xorl	%eax, %eax
	movl	$.LC110, %esi
	movl	$3, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1987
	movq	stderr(%rip), %rdi
	movl	$.LC111, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1959:
	movq	pidfile(%rip), %rdx
	movl	$2, %edi
	movl	$.LC75, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1960:
	movl	$.LC125, %esi
	jmp	.L1945
.L1961:
	movq	%r12, %rdi
	call	chroot
	testl	%eax, %eax
	js	.L1988
	movq	logfile(%rip), %r8
	testq	%r8, %r8
	je	.L1683
	movl	$.LC83, %esi
	movq	%r8, %rdi
	movq	%r8, 24(%rsp)
	call	strcmp
	testl	%eax, %eax
	je	.L1683
	movq	%r12, %rdi
	call	strlen
	movq	24(%rsp), %r8
	movq	%r12, %rsi
	movq	%rax, %rdx
	movq	%rax, 32(%rsp)
	movq	%r8, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L1684
	movq	24(%rsp), %r8
	movq	32(%rsp), %rdx
	movq	%r8, %rdi
	leaq	-1(%r8,%rdx), %rsi
	call	strcpy
.L1683:
	movq	%r12, %rdi
	movl	$2, %edx
	movl	$.LC121, %esi
	call	memcpy
	movq	%r12, %rdi
	call	chdir
	testl	%eax, %eax
	jns	.L1681
	movl	$.LC129, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC130, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1962:
	movl	$.LC131, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC132, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1986:
	xorl	%eax, %eax
	movl	$.LC115, %esi
	movl	$4, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1989
	movq	stderr(%rip), %rdi
	movl	$.LC116, %esi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L1667
.L1970:
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	setgroups
	movl	$.LC137, %esi
	testl	%eax, %eax
	js	.L1945
	movl	20(%rsp), %edi
	call	setgid
	movl	$.LC138, %esi
	testl	%eax, %eax
	js	.L1945
	movl	20(%rsp), %esi
	movq	user(%rip), %rdi
	call	initgroups
	testl	%eax, %eax
	js	.L1990
.L1704:
	movl	40(%rsp), %edi
	call	setuid
	movl	$.LC140, %esi
	testl	%eax, %eax
	js	.L1945
	cmpl	$0, do_chroot(%rip)
	jne	.L1701
	movl	$.LC141, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L1701
.L1952:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1951:
	movq	%r13, %rdi
	call	__asan_report_load4
.L1956:
	call	__asan_report_load1
.L1963:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1964:
	movq	%r13, %rdi
	call	__asan_report_load4
.L1984:
	call	__asan_report_load4
.L1985:
	call	__asan_report_load4
.L1983:
	movq	user(%rip), %rdx
	movl	$.LC112, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	user(%rip), %rcx
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1991
	movq	stderr(%rip), %rdi
	movl	$.LC113, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1722:
	movq	%rbx, %rdi
	call	tmr_prepare_timeval
	testl	%ebp, %ebp
	je	.L1992
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L1739
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1730
	testb	%cl, %cl
	jne	.L1993
.L1730:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1731
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L1732
.L1736:
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L1739
.L1731:
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1737
	cmpb	$3, %dl
	jle	.L1994
.L1737:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1739
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L1739
	movq	hs(%rip), %rax
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1738
	cmpb	$3, %dl
	jle	.L1995
.L1738:
	movl	72(%rax), %esi
	movq	%rbx, %rdi
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L1720
.L1739:
	call	fdwatch_get_next_client_data
	movq	%rax, %rbp
	cmpq	$-1, %rax
	je	.L1996
	testq	%rbp, %rbp
	je	.L1739
	leaq	8(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1997
	movq	8(%rbp), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1741
	cmpb	$3, %dl
	jle	.L1998
.L1741:
	movl	704(%rax), %edi
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L1999
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1744
	cmpb	$3, %al
	jle	.L2000
.L1744:
	movl	0(%rbp), %eax
	cmpl	$2, %eax
	je	.L1745
	cmpl	$4, %eax
	je	.L1746
	subl	$1, %eax
	jne	.L1739
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	call	handle_read
	jmp	.L1739
.L1999:
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	call	clear_connection
	jmp	.L1739
.L1978:
	call	re_open_logfile
	movl	$0, got_hup(%rip)
	jmp	.L1721
.L1756:
	movq	%r12, %rdx
	movl	$.LC75, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movq	logfile(%rip), %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1996:
	movq	%rbx, %rdi
	call	tmr_run
	movl	got_usr1(%rip), %eax
	testl	%eax, %eax
	je	.L1720
	cmpl	$0, terminate(%rip)
	jne	.L1720
	movq	hs(%rip), %rax
	movl	$1, terminate(%rip)
	testq	%rax, %rax
	je	.L1720
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1748
	cmpb	$3, %dl
	jle	.L2001
.L1748:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1749
	call	fdwatch_del_fd
	movq	hs(%rip), %rax
.L1749:
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1750
	testb	%cl, %cl
	jne	.L2002
.L1750:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1751
	call	fdwatch_del_fd
.L1751:
	movq	hs(%rip), %rdi
	call	httpd_unlisten
	jmp	.L1720
.L1746:
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	call	handle_linger
	jmp	.L1739
.L1745:
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	call	handle_send
	jmp	.L1739
.L1988:
	movl	$.LC126, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC21, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1684:
	xorl	%eax, %eax
	movl	$.LC127, %esi
	movl	$4, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L2003
	movq	stderr(%rip), %rdi
	movl	$.LC128, %esi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L1683
.L1992:
	movq	%rbx, %rdi
	call	tmr_run
	jmp	.L1720
.L1732:
	movq	hs(%rip), %rdx
	leaq	76(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1734
	testb	%cl, %cl
	jne	.L2004
.L1734:
	movl	76(%rdx), %esi
	movq	%rbx, %rdi
	call	handle_newconnect
	testl	%eax, %eax
	je	.L1736
	jmp	.L1720
.L1977:
	call	shut_down
	movl	$5, %edi
	movl	$.LC92, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
.L1990:
	movl	$.LC139, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L1704
.L1950:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1949:
	movl	$4800, %edi
	call	__asan_stack_malloc_7
	testq	%rax, %rax
	cmovne	%rax, %rbp
	jmp	.L1644
.L1981:
	movl	$stdout, %edi
	call	__asan_report_load8
.L1982:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1980:
	movl	$stdin, %edi
	call	__asan_report_load8
.L1997:
	call	__asan_report_load8
.L2000:
	movq	%rbp, %rdi
	call	__asan_report_load4
.L1998:
	call	__asan_report_load4
.L1973:
	movq	%r8, %rdi
	call	__asan_report_store8
.L1972:
	movq	%r8, %rdi
	call	__asan_report_store4
.L1987:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1966:
	movl	$JunkClientData, %edi
	call	__asan_report_load8
.L1971:
	call	__asan_report_store4
.L1965:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L1991:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1968:
	movl	$JunkClientData, %edi
	call	__asan_report_load8
.L1976:
	call	__asan_report_load4
.L1975:
	call	__asan_report_load4
.L1707:
	movl	$.LC142, %esi
	jmp	.L1945
.L1974:
	call	__asan_report_store4
.L1969:
	movl	$JunkClientData, %edi
	call	__asan_report_load8
.L2001:
	call	__asan_report_load4
.L1979:
	movq	%rax, %rdi
	call	__asan_report_load4
.L2002:
	call	__asan_report_load4
.L1989:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1993:
	call	__asan_report_load4
.L1995:
	call	__asan_report_load4
.L2003:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1994:
	call	__asan_report_load4
.L2004:
	call	__asan_report_load4
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.bss
	.align 32
	.type	watchdog_flag, @object
	.size	watchdog_flag, 4
watchdog_flag:
	.zero	64
	.align 32
	.type	got_usr1, @object
	.size	got_usr1, 4
got_usr1:
	.zero	64
	.align 32
	.type	got_hup, @object
	.size	got_hup, 4
got_hup:
	.zero	64
	.comm	stats_simultaneous,4,4
	.comm	stats_bytes,8,8
	.comm	stats_connections,8,8
	.comm	stats_time,8,8
	.comm	start_time,8,8
	.globl	terminate
	.align 32
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	64
	.align 32
	.type	hs, @object
	.size	hs, 8
hs:
	.zero	64
	.align 32
	.type	httpd_conn_count, @object
	.size	httpd_conn_count, 4
httpd_conn_count:
	.zero	64
	.align 32
	.type	first_free_connect, @object
	.size	first_free_connect, 4
first_free_connect:
	.zero	64
	.align 32
	.type	max_connects, @object
	.size	max_connects, 4
max_connects:
	.zero	64
	.align 32
	.type	num_connects, @object
	.size	num_connects, 4
num_connects:
	.zero	64
	.align 32
	.type	connects, @object
	.size	connects, 8
connects:
	.zero	64
	.align 32
	.type	maxthrottles, @object
	.size	maxthrottles, 4
maxthrottles:
	.zero	64
	.align 32
	.type	numthrottles, @object
	.size	numthrottles, 4
numthrottles:
	.zero	64
	.align 32
	.type	throttles, @object
	.size	throttles, 8
throttles:
	.zero	64
	.align 32
	.type	max_age, @object
	.size	max_age, 4
max_age:
	.zero	64
	.align 32
	.type	p3p, @object
	.size	p3p, 8
p3p:
	.zero	64
	.align 32
	.type	charset, @object
	.size	charset, 8
charset:
	.zero	64
	.align 32
	.type	user, @object
	.size	user, 8
user:
	.zero	64
	.align 32
	.type	pidfile, @object
	.size	pidfile, 8
pidfile:
	.zero	64
	.align 32
	.type	hostname, @object
	.size	hostname, 8
hostname:
	.zero	64
	.align 32
	.type	throttlefile, @object
	.size	throttlefile, 8
throttlefile:
	.zero	64
	.align 32
	.type	logfile, @object
	.size	logfile, 8
logfile:
	.zero	64
	.align 32
	.type	local_pattern, @object
	.size	local_pattern, 8
local_pattern:
	.zero	64
	.align 32
	.type	no_empty_referers, @object
	.size	no_empty_referers, 4
no_empty_referers:
	.zero	64
	.align 32
	.type	url_pattern, @object
	.size	url_pattern, 8
url_pattern:
	.zero	64
	.align 32
	.type	cgi_limit, @object
	.size	cgi_limit, 4
cgi_limit:
	.zero	64
	.align 32
	.type	cgi_pattern, @object
	.size	cgi_pattern, 8
cgi_pattern:
	.zero	64
	.align 32
	.type	do_global_passwd, @object
	.size	do_global_passwd, 4
do_global_passwd:
	.zero	64
	.align 32
	.type	do_vhost, @object
	.size	do_vhost, 4
do_vhost:
	.zero	64
	.align 32
	.type	no_symlink_check, @object
	.size	no_symlink_check, 4
no_symlink_check:
	.zero	64
	.align 32
	.type	no_log, @object
	.size	no_log, 4
no_log:
	.zero	64
	.align 32
	.type	do_chroot, @object
	.size	do_chroot, 4
do_chroot:
	.zero	64
	.align 32
	.type	data_dir, @object
	.size	data_dir, 8
data_dir:
	.zero	64
	.align 32
	.type	dir, @object
	.size	dir, 8
dir:
	.zero	64
	.align 32
	.type	port, @object
	.size	port, 2
port:
	.zero	64
	.align 32
	.type	debug, @object
	.size	debug, 4
debug:
	.zero	64
	.align 32
	.type	argv0, @object
	.size	argv0, 8
argv0:
	.zero	64
	.section	.rodata.str1.1
.LC144:
	.string	"thttpd.c"
	.data
	.align 16
	.type	.LASANLOC1, @object
	.size	.LASANLOC1, 16
.LASANLOC1:
	.quad	.LC144
	.long	135
	.long	40
	.align 16
	.type	.LASANLOC2, @object
	.size	.LASANLOC2, 16
.LASANLOC2:
	.quad	.LC144
	.long	135
	.long	30
	.align 16
	.type	.LASANLOC3, @object
	.size	.LASANLOC3, 16
.LASANLOC3:
	.quad	.LC144
	.long	135
	.long	21
	.globl	__odr_asan.terminate
	.bss
	.type	__odr_asan.terminate, @object
	.size	__odr_asan.terminate, 1
__odr_asan.terminate:
	.zero	1
	.data
	.align 16
	.type	.LASANLOC4, @object
	.size	.LASANLOC4, 16
.LASANLOC4:
	.quad	.LC144
	.long	129
	.long	5
	.align 16
	.type	.LASANLOC5, @object
	.size	.LASANLOC5, 16
.LASANLOC5:
	.quad	.LC144
	.long	128
	.long	22
	.align 16
	.type	.LASANLOC6, @object
	.size	.LASANLOC6, 16
.LASANLOC6:
	.quad	.LC144
	.long	118
	.long	12
	.align 16
	.type	.LASANLOC7, @object
	.size	.LASANLOC7, 16
.LASANLOC7:
	.quad	.LC144
	.long	117
	.long	40
	.align 16
	.type	.LASANLOC8, @object
	.size	.LASANLOC8, 16
.LASANLOC8:
	.quad	.LC144
	.long	117
	.long	26
	.align 16
	.type	.LASANLOC9, @object
	.size	.LASANLOC9, 16
.LASANLOC9:
	.quad	.LC144
	.long	117
	.long	12
	.align 16
	.type	.LASANLOC10, @object
	.size	.LASANLOC10, 16
.LASANLOC10:
	.quad	.LC144
	.long	116
	.long	20
	.align 16
	.type	.LASANLOC11, @object
	.size	.LASANLOC11, 16
.LASANLOC11:
	.quad	.LC144
	.long	96
	.long	26
	.align 16
	.type	.LASANLOC12, @object
	.size	.LASANLOC12, 16
.LASANLOC12:
	.quad	.LC144
	.long	96
	.long	12
	.align 16
	.type	.LASANLOC13, @object
	.size	.LASANLOC13, 16
.LASANLOC13:
	.quad	.LC144
	.long	95
	.long	21
	.align 16
	.type	.LASANLOC14, @object
	.size	.LASANLOC14, 16
.LASANLOC14:
	.quad	.LC144
	.long	85
	.long	12
	.align 16
	.type	.LASANLOC15, @object
	.size	.LASANLOC15, 16
.LASANLOC15:
	.quad	.LC144
	.long	84
	.long	14
	.align 16
	.type	.LASANLOC16, @object
	.size	.LASANLOC16, 16
.LASANLOC16:
	.quad	.LC144
	.long	83
	.long	14
	.align 16
	.type	.LASANLOC17, @object
	.size	.LASANLOC17, 16
.LASANLOC17:
	.quad	.LC144
	.long	82
	.long	14
	.align 16
	.type	.LASANLOC18, @object
	.size	.LASANLOC18, 16
.LASANLOC18:
	.quad	.LC144
	.long	81
	.long	14
	.align 16
	.type	.LASANLOC19, @object
	.size	.LASANLOC19, 16
.LASANLOC19:
	.quad	.LC144
	.long	80
	.long	14
	.align 16
	.type	.LASANLOC20, @object
	.size	.LASANLOC20, 16
.LASANLOC20:
	.quad	.LC144
	.long	79
	.long	14
	.align 16
	.type	.LASANLOC21, @object
	.size	.LASANLOC21, 16
.LASANLOC21:
	.quad	.LC144
	.long	78
	.long	14
	.align 16
	.type	.LASANLOC22, @object
	.size	.LASANLOC22, 16
.LASANLOC22:
	.quad	.LC144
	.long	77
	.long	14
	.align 16
	.type	.LASANLOC23, @object
	.size	.LASANLOC23, 16
.LASANLOC23:
	.quad	.LC144
	.long	76
	.long	12
	.align 16
	.type	.LASANLOC24, @object
	.size	.LASANLOC24, 16
.LASANLOC24:
	.quad	.LC144
	.long	75
	.long	14
	.align 16
	.type	.LASANLOC25, @object
	.size	.LASANLOC25, 16
.LASANLOC25:
	.quad	.LC144
	.long	74
	.long	12
	.align 16
	.type	.LASANLOC26, @object
	.size	.LASANLOC26, 16
.LASANLOC26:
	.quad	.LC144
	.long	73
	.long	14
	.align 16
	.type	.LASANLOC27, @object
	.size	.LASANLOC27, 16
.LASANLOC27:
	.quad	.LC144
	.long	72
	.long	59
	.align 16
	.type	.LASANLOC28, @object
	.size	.LASANLOC28, 16
.LASANLOC28:
	.quad	.LC144
	.long	72
	.long	49
	.align 16
	.type	.LASANLOC29, @object
	.size	.LASANLOC29, 16
.LASANLOC29:
	.quad	.LC144
	.long	72
	.long	31
	.align 16
	.type	.LASANLOC30, @object
	.size	.LASANLOC30, 16
.LASANLOC30:
	.quad	.LC144
	.long	72
	.long	23
	.align 16
	.type	.LASANLOC31, @object
	.size	.LASANLOC31, 16
.LASANLOC31:
	.quad	.LC144
	.long	72
	.long	12
	.align 16
	.type	.LASANLOC32, @object
	.size	.LASANLOC32, 16
.LASANLOC32:
	.quad	.LC144
	.long	71
	.long	14
	.align 16
	.type	.LASANLOC33, @object
	.size	.LASANLOC33, 16
.LASANLOC33:
	.quad	.LC144
	.long	70
	.long	14
	.align 16
	.type	.LASANLOC34, @object
	.size	.LASANLOC34, 16
.LASANLOC34:
	.quad	.LC144
	.long	69
	.long	23
	.align 16
	.type	.LASANLOC35, @object
	.size	.LASANLOC35, 16
.LASANLOC35:
	.quad	.LC144
	.long	68
	.long	12
	.align 16
	.type	.LASANLOC36, @object
	.size	.LASANLOC36, 16
.LASANLOC36:
	.quad	.LC144
	.long	67
	.long	14
	.section	.rodata.str1.1
.LC145:
	.string	"watchdog_flag"
.LC146:
	.string	"got_usr1"
.LC147:
	.string	"got_hup"
.LC148:
	.string	"terminate"
.LC149:
	.string	"hs"
.LC150:
	.string	"httpd_conn_count"
.LC151:
	.string	"first_free_connect"
.LC152:
	.string	"max_connects"
.LC153:
	.string	"num_connects"
.LC154:
	.string	"connects"
.LC155:
	.string	"maxthrottles"
.LC156:
	.string	"numthrottles"
.LC157:
	.string	"hostname"
.LC158:
	.string	"throttlefile"
.LC159:
	.string	"local_pattern"
.LC160:
	.string	"no_empty_referers"
.LC161:
	.string	"url_pattern"
.LC162:
	.string	"cgi_limit"
.LC163:
	.string	"cgi_pattern"
.LC164:
	.string	"do_global_passwd"
.LC165:
	.string	"do_vhost"
.LC166:
	.string	"no_symlink_check"
.LC167:
	.string	"no_log"
.LC168:
	.string	"do_chroot"
.LC169:
	.string	"argv0"
.LC170:
	.string	"*.LC105"
.LC171:
	.string	"*.LC97"
.LC172:
	.string	"*.LC119"
.LC173:
	.string	"*.LC39"
.LC174:
	.string	"*.LC84"
.LC175:
	.string	"*.LC139"
.LC176:
	.string	"*.LC79"
.LC177:
	.string	"*.LC80"
.LC178:
	.string	"*.LC1"
.LC179:
	.string	"*.LC131"
.LC180:
	.string	"*.LC134"
.LC181:
	.string	"*.LC70"
.LC182:
	.string	"*.LC35"
.LC183:
	.string	"*.LC61"
.LC184:
	.string	"*.LC76"
.LC185:
	.string	"*.LC63"
.LC186:
	.string	"*.LC83"
.LC187:
	.string	"*.LC55"
.LC188:
	.string	"*.LC126"
.LC189:
	.string	"*.LC132"
.LC190:
	.string	"*.LC36"
.LC191:
	.string	"*.LC21"
.LC192:
	.string	"*.LC32"
.LC193:
	.string	"*.LC138"
.LC194:
	.string	"*.LC56"
.LC195:
	.string	"*.LC45"
.LC196:
	.string	"*.LC106"
.LC197:
	.string	"*.LC29"
.LC198:
	.string	"*.LC6"
.LC199:
	.string	"*.LC3"
.LC200:
	.string	"*.LC110"
.LC201:
	.string	"*.LC108"
.LC202:
	.string	"*.LC82"
.LC203:
	.string	"*.LC77"
.LC204:
	.string	"*.LC118"
.LC205:
	.string	"*.LC31"
.LC206:
	.string	"*.LC40"
.LC207:
	.string	"*.LC50"
.LC208:
	.string	"*.LC57"
.LC209:
	.string	"*.LC41"
.LC210:
	.string	"*.LC121"
.LC211:
	.string	"*.LC62"
.LC212:
	.string	"*.LC30"
.LC213:
	.string	"*.LC0"
.LC214:
	.string	"*.LC85"
.LC215:
	.string	"*.LC140"
.LC216:
	.string	"*.LC124"
.LC217:
	.string	"*.LC12"
.LC218:
	.string	"*.LC137"
.LC219:
	.string	"*.LC47"
.LC220:
	.string	"*.LC48"
.LC221:
	.string	"*.LC130"
.LC222:
	.string	"*.LC43"
.LC223:
	.string	"*.LC100"
.LC224:
	.string	"*.LC19"
.LC225:
	.string	"*.LC25"
.LC226:
	.string	"*.LC129"
.LC227:
	.string	"*.LC112"
.LC228:
	.string	"*.LC113"
.LC229:
	.string	"*.LC143"
.LC230:
	.string	"*.LC20"
.LC231:
	.string	"*.LC51"
.LC232:
	.string	"*.LC73"
.LC233:
	.string	"*.LC89"
.LC234:
	.string	"*.LC67"
.LC235:
	.string	"*.LC64"
.LC236:
	.string	"*.LC65"
.LC237:
	.string	"*.LC116"
.LC238:
	.string	"*.LC16"
.LC239:
	.string	"*.LC123"
.LC240:
	.string	"*.LC122"
.LC241:
	.string	"*.LC78"
.LC242:
	.string	"*.LC125"
.LC243:
	.string	"*.LC4"
.LC244:
	.string	"*.LC127"
.LC245:
	.string	"*.LC17"
.LC246:
	.string	"*.LC68"
.LC247:
	.string	"*.LC22"
.LC248:
	.string	"*.LC42"
.LC249:
	.string	"*.LC66"
.LC250:
	.string	"*.LC26"
.LC251:
	.string	"*.LC86"
.LC252:
	.string	"*.LC33"
.LC253:
	.string	"*.LC49"
.LC254:
	.string	"*.LC120"
.LC255:
	.string	"*.LC128"
.LC256:
	.string	"*.LC107"
.LC257:
	.string	"*.LC101"
.LC258:
	.string	"*.LC141"
.LC259:
	.string	"*.LC96"
.LC260:
	.string	"*.LC75"
.LC261:
	.string	"*.LC9"
.LC262:
	.string	"*.LC136"
.LC263:
	.string	"*.LC71"
.LC264:
	.string	"*.LC81"
.LC265:
	.string	"*.LC54"
.LC266:
	.string	"*.LC69"
.LC267:
	.string	"*.LC58"
.LC268:
	.string	"*.LC90"
.LC269:
	.string	"*.LC142"
.LC270:
	.string	"*.LC2"
.LC271:
	.string	"*.LC94"
.LC272:
	.string	"*.LC5"
.LC273:
	.string	"*.LC95"
.LC274:
	.string	"*.LC135"
.LC275:
	.string	"*.LC99"
.LC276:
	.string	"*.LC92"
.LC277:
	.string	"*.LC23"
.LC278:
	.string	"*.LC59"
.LC279:
	.string	"*.LC10"
.LC280:
	.string	"*.LC117"
.LC281:
	.string	"*.LC114"
.LC282:
	.string	"*.LC87"
.LC283:
	.string	"*.LC34"
.LC284:
	.string	"*.LC133"
.LC285:
	.string	"*.LC44"
.LC286:
	.string	"*.LC27"
.LC287:
	.string	"*.LC88"
.LC288:
	.string	"*.LC93"
.LC289:
	.string	"*.LC52"
.LC290:
	.string	"*.LC72"
.LC291:
	.string	"*.LC38"
.LC292:
	.string	"*.LC53"
.LC293:
	.string	"*.LC60"
.LC294:
	.string	"*.LC37"
.LC295:
	.string	"*.LC28"
.LC296:
	.string	"*.LC13"
.LC297:
	.string	"*.LC14"
.LC298:
	.string	"*.LC111"
.LC299:
	.string	"*.LC24"
.LC300:
	.string	"*.LC115"
.LC301:
	.string	"*.LC18"
	.data
	.align 32
	.type	.LASAN0, @object
	.size	.LASAN0, 10752
.LASAN0:
	.quad	watchdog_flag
	.quad	4
	.quad	64
	.quad	.LC145
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC1
	.quad	0
	.quad	got_usr1
	.quad	4
	.quad	64
	.quad	.LC146
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC2
	.quad	0
	.quad	got_hup
	.quad	4
	.quad	64
	.quad	.LC147
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC3
	.quad	0
	.quad	terminate
	.quad	4
	.quad	64
	.quad	.LC148
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC4
	.quad	__odr_asan.terminate
	.quad	hs
	.quad	8
	.quad	64
	.quad	.LC149
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC5
	.quad	0
	.quad	httpd_conn_count
	.quad	4
	.quad	64
	.quad	.LC150
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC6
	.quad	0
	.quad	first_free_connect
	.quad	4
	.quad	64
	.quad	.LC151
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC7
	.quad	0
	.quad	max_connects
	.quad	4
	.quad	64
	.quad	.LC152
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC8
	.quad	0
	.quad	num_connects
	.quad	4
	.quad	64
	.quad	.LC153
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC9
	.quad	0
	.quad	connects
	.quad	8
	.quad	64
	.quad	.LC154
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC10
	.quad	0
	.quad	maxthrottles
	.quad	4
	.quad	64
	.quad	.LC155
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC11
	.quad	0
	.quad	numthrottles
	.quad	4
	.quad	64
	.quad	.LC156
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC12
	.quad	0
	.quad	throttles
	.quad	8
	.quad	64
	.quad	.LC34
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC13
	.quad	0
	.quad	max_age
	.quad	4
	.quad	64
	.quad	.LC44
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC14
	.quad	0
	.quad	p3p
	.quad	8
	.quad	64
	.quad	.LC43
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC15
	.quad	0
	.quad	charset
	.quad	8
	.quad	64
	.quad	.LC42
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC16
	.quad	0
	.quad	user
	.quad	8
	.quad	64
	.quad	.LC28
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC17
	.quad	0
	.quad	pidfile
	.quad	8
	.quad	64
	.quad	.LC41
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC18
	.quad	0
	.quad	hostname
	.quad	8
	.quad	64
	.quad	.LC157
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC19
	.quad	0
	.quad	throttlefile
	.quad	8
	.quad	64
	.quad	.LC158
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC20
	.quad	0
	.quad	logfile
	.quad	8
	.quad	64
	.quad	.LC36
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC21
	.quad	0
	.quad	local_pattern
	.quad	8
	.quad	64
	.quad	.LC159
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC22
	.quad	0
	.quad	no_empty_referers
	.quad	4
	.quad	64
	.quad	.LC160
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC23
	.quad	0
	.quad	url_pattern
	.quad	8
	.quad	64
	.quad	.LC161
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC24
	.quad	0
	.quad	cgi_limit
	.quad	4
	.quad	64
	.quad	.LC162
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC25
	.quad	0
	.quad	cgi_pattern
	.quad	8
	.quad	64
	.quad	.LC163
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC26
	.quad	0
	.quad	do_global_passwd
	.quad	4
	.quad	64
	.quad	.LC164
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC27
	.quad	0
	.quad	do_vhost
	.quad	4
	.quad	64
	.quad	.LC165
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC28
	.quad	0
	.quad	no_symlink_check
	.quad	4
	.quad	64
	.quad	.LC166
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC29
	.quad	0
	.quad	no_log
	.quad	4
	.quad	64
	.quad	.LC167
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC30
	.quad	0
	.quad	do_chroot
	.quad	4
	.quad	64
	.quad	.LC168
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC31
	.quad	0
	.quad	data_dir
	.quad	8
	.quad	64
	.quad	.LC23
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC32
	.quad	0
	.quad	dir
	.quad	8
	.quad	64
	.quad	.LC20
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC33
	.quad	0
	.quad	port
	.quad	2
	.quad	64
	.quad	.LC19
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC34
	.quad	0
	.quad	debug
	.quad	4
	.quad	64
	.quad	.LC18
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC35
	.quad	0
	.quad	argv0
	.quad	8
	.quad	64
	.quad	.LC169
	.quad	.LC144
	.quad	0
	.quad	.LASANLOC36
	.quad	0
	.quad	.LC105
	.quad	3
	.quad	64
	.quad	.LC170
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC97
	.quad	35
	.quad	96
	.quad	.LC171
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC119
	.quad	11
	.quad	64
	.quad	.LC172
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC39
	.quad	13
	.quad	64
	.quad	.LC173
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC84
	.quad	19
	.quad	64
	.quad	.LC174
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC139
	.quad	16
	.quad	64
	.quad	.LC175
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC79
	.quad	3
	.quad	64
	.quad	.LC176
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC80
	.quad	39
	.quad	96
	.quad	.LC177
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC1
	.quad	70
	.quad	128
	.quad	.LC178
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC131
	.quad	20
	.quad	64
	.quad	.LC179
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC134
	.quad	24
	.quad	64
	.quad	.LC180
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC70
	.quad	3
	.quad	64
	.quad	.LC181
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC35
	.quad	5
	.quad	64
	.quad	.LC182
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC61
	.quad	3
	.quad	64
	.quad	.LC183
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC76
	.quad	16
	.quad	64
	.quad	.LC184
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC63
	.quad	3
	.quad	64
	.quad	.LC185
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC83
	.quad	2
	.quad	64
	.quad	.LC186
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC55
	.quad	3
	.quad	64
	.quad	.LC187
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC126
	.quad	12
	.quad	64
	.quad	.LC188
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC132
	.quad	15
	.quad	64
	.quad	.LC189
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC36
	.quad	8
	.quad	64
	.quad	.LC190
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC21
	.quad	7
	.quad	64
	.quad	.LC191
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC32
	.quad	16
	.quad	64
	.quad	.LC192
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC138
	.quad	12
	.quad	64
	.quad	.LC193
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC56
	.quad	5
	.quad	64
	.quad	.LC194
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC45
	.quad	32
	.quad	64
	.quad	.LC195
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC106
	.quad	26
	.quad	64
	.quad	.LC196
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC29
	.quad	7
	.quad	64
	.quad	.LC197
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC6
	.quad	219
	.quad	256
	.quad	.LC198
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC3
	.quad	65
	.quad	128
	.quad	.LC199
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC110
	.quad	29
	.quad	64
	.quad	.LC200
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC108
	.quad	39
	.quad	96
	.quad	.LC201
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC82
	.quad	20
	.quad	64
	.quad	.LC202
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC77
	.quad	33
	.quad	96
	.quad	.LC203
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC118
	.quad	15
	.quad	64
	.quad	.LC204
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC31
	.quad	7
	.quad	64
	.quad	.LC205
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC40
	.quad	15
	.quad	64
	.quad	.LC206
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC50
	.quad	3
	.quad	64
	.quad	.LC207
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC57
	.quad	4
	.quad	64
	.quad	.LC208
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC41
	.quad	8
	.quad	64
	.quad	.LC209
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC121
	.quad	2
	.quad	64
	.quad	.LC210
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC62
	.quad	3
	.quad	64
	.quad	.LC211
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC30
	.quad	9
	.quad	64
	.quad	.LC212
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC0
	.quad	104
	.quad	160
	.quad	.LC213
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC85
	.quad	2
	.quad	64
	.quad	.LC214
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC140
	.quad	12
	.quad	64
	.quad	.LC215
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC124
	.quad	4
	.quad	64
	.quad	.LC216
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC12
	.quad	16
	.quad	64
	.quad	.LC217
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC137
	.quad	15
	.quad	64
	.quad	.LC218
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC47
	.quad	7
	.quad	64
	.quad	.LC219
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC48
	.quad	11
	.quad	64
	.quad	.LC220
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC130
	.quad	13
	.quad	64
	.quad	.LC221
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC43
	.quad	4
	.quad	64
	.quad	.LC222
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC100
	.quad	37
	.quad	96
	.quad	.LC223
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC19
	.quad	5
	.quad	64
	.quad	.LC224
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC25
	.quad	10
	.quad	64
	.quad	.LC225
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC129
	.quad	18
	.quad	64
	.quad	.LC226
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC112
	.quad	23
	.quad	64
	.quad	.LC227
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC113
	.quad	25
	.quad	64
	.quad	.LC228
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC143
	.quad	13
	.quad	64
	.quad	.LC229
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC20
	.quad	4
	.quad	64
	.quad	.LC230
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC51
	.quad	26
	.quad	64
	.quad	.LC231
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC73
	.quad	3
	.quad	64
	.quad	.LC232
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC89
	.quad	39
	.quad	96
	.quad	.LC233
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC67
	.quad	3
	.quad	64
	.quad	.LC234
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC64
	.quad	3
	.quad	64
	.quad	.LC235
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC65
	.quad	3
	.quad	64
	.quad	.LC236
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC116
	.quad	72
	.quad	128
	.quad	.LC237
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC16
	.quad	2
	.quad	64
	.quad	.LC238
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC123
	.quad	2
	.quad	64
	.quad	.LC239
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC122
	.quad	12
	.quad	64
	.quad	.LC240
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC78
	.quad	38
	.quad	96
	.quad	.LC241
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC125
	.quad	31
	.quad	64
	.quad	.LC242
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC4
	.quad	37
	.quad	96
	.quad	.LC243
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC127
	.quad	74
	.quad	128
	.quad	.LC244
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC17
	.quad	5
	.quad	64
	.quad	.LC245
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC68
	.quad	5
	.quad	64
	.quad	.LC246
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC22
	.quad	9
	.quad	64
	.quad	.LC247
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC42
	.quad	8
	.quad	64
	.quad	.LC248
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC66
	.quad	5
	.quad	64
	.quad	.LC249
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC26
	.quad	9
	.quad	64
	.quad	.LC250
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC86
	.quad	22
	.quad	64
	.quad	.LC251
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC33
	.quad	9
	.quad	64
	.quad	.LC252
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC49
	.quad	1
	.quad	64
	.quad	.LC253
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC120
	.quad	6
	.quad	64
	.quad	.LC254
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC128
	.quad	79
	.quad	128
	.quad	.LC255
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC107
	.quad	25
	.quad	64
	.quad	.LC256
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC101
	.quad	25
	.quad	64
	.quad	.LC257
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC141
	.quad	58
	.quad	96
	.quad	.LC258
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC96
	.quad	35
	.quad	96
	.quad	.LC259
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC75
	.quad	11
	.quad	64
	.quad	.LC260
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC9
	.quad	39
	.quad	96
	.quad	.LC261
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC136
	.quad	30
	.quad	64
	.quad	.LC262
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC71
	.quad	3
	.quad	64
	.quad	.LC263
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC81
	.quad	44
	.quad	96
	.quad	.LC264
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC54
	.quad	3
	.quad	64
	.quad	.LC265
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC69
	.quad	3
	.quad	64
	.quad	.LC266
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC58
	.quad	3
	.quad	64
	.quad	.LC267
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC90
	.quad	56
	.quad	96
	.quad	.LC268
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC142
	.quad	38
	.quad	96
	.quad	.LC269
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC2
	.quad	62
	.quad	96
	.quad	.LC270
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC94
	.quad	33
	.quad	96
	.quad	.LC271
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC5
	.quad	34
	.quad	96
	.quad	.LC272
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC95
	.quad	43
	.quad	96
	.quad	.LC273
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC135
	.quad	36
	.quad	96
	.quad	.LC274
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC99
	.quad	33
	.quad	96
	.quad	.LC275
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC92
	.quad	8
	.quad	64
	.quad	.LC276
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC23
	.quad	9
	.quad	64
	.quad	.LC277
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC59
	.quad	5
	.quad	64
	.quad	.LC278
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC10
	.quad	5
	.quad	64
	.quad	.LC279
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC117
	.quad	20
	.quad	64
	.quad	.LC280
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC114
	.quad	10
	.quad	64
	.quad	.LC281
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC87
	.quad	22
	.quad	64
	.quad	.LC282
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC34
	.quad	10
	.quad	64
	.quad	.LC283
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC133
	.quad	30
	.quad	64
	.quad	.LC284
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC44
	.quad	8
	.quad	64
	.quad	.LC285
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC27
	.quad	11
	.quad	64
	.quad	.LC286
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC88
	.quad	36
	.quad	96
	.quad	.LC287
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC93
	.quad	25
	.quad	64
	.quad	.LC288
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC52
	.quad	3
	.quad	64
	.quad	.LC289
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC72
	.quad	3
	.quad	64
	.quad	.LC290
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC38
	.quad	8
	.quad	64
	.quad	.LC291
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC53
	.quad	3
	.quad	64
	.quad	.LC292
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC60
	.quad	3
	.quad	64
	.quad	.LC293
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC37
	.quad	6
	.quad	64
	.quad	.LC294
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC28
	.quad	5
	.quad	64
	.quad	.LC295
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC13
	.quad	31
	.quad	64
	.quad	.LC296
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC14
	.quad	36
	.quad	96
	.quad	.LC297
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC111
	.quad	34
	.quad	96
	.quad	.LC298
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC24
	.quad	8
	.quad	64
	.quad	.LC299
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC115
	.quad	67
	.quad	128
	.quad	.LC300
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC18
	.quad	6
	.quad	64
	.quad	.LC301
	.quad	.LC144
	.quad	0
	.quad	0
	.quad	0
	.section	.text.exit,"ax",@progbits
	.p2align 4
	.type	_GLOBAL__sub_D_00099_0_terminate, @function
_GLOBAL__sub_D_00099_0_terminate:
.LFB38:
	.cfi_startproc
	movl	$168, %esi
	movl	$.LASAN0, %edi
	jmp	__asan_unregister_globals
	.cfi_endproc
.LFE38:
	.size	_GLOBAL__sub_D_00099_0_terminate, .-_GLOBAL__sub_D_00099_0_terminate
	.section	.fini_array.00099,"aw"
	.align 8
	.quad	_GLOBAL__sub_D_00099_0_terminate
	.section	.text.startup
	.p2align 4
	.type	_GLOBAL__sub_I_00099_1_terminate, @function
_GLOBAL__sub_I_00099_1_terminate:
.LFB39:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	__asan_init
	call	__asan_version_mismatch_check_v8
	movl	$168, %esi
	movl	$.LASAN0, %edi
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	jmp	__asan_register_globals
	.cfi_endproc
.LFE39:
	.size	_GLOBAL__sub_I_00099_1_terminate, .-_GLOBAL__sub_I_00099_1_terminate
	.section	.init_array.00099,"aw"
	.align 8
	.quad	_GLOBAL__sub_I_00099_1_terminate
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC46:
	.quad	-723401728380766731
	.quad	-723401728380766731
	.ident	"GCC: (GNU) 9.2.0"
	.section	.note.GNU-stack,"",@progbits
