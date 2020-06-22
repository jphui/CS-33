	.file	"thttpd.c"
	.text
	.p2align 4
	.type	handle_hup, @function
handle_hup:
.LFB4:
	.cfi_startproc
	movl	$1, got_hup(%rip)
	ret
	.cfi_endproc
.LFE4:
	.size	handle_hup, .-handle_hup
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"  thttpd - %ld connections (%g/sec), %d max simultaneous, %lld bytes (%g/sec), %d httpd_conns allocated"
	.text
	.p2align 4
	.type	thttpd_logstats, @function
thttpd_logstats:
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
	.section	.rodata.str1.8
	.align 8
.LC1:
	.string	"throttle #%d '%.80s' rate %ld greatly exceeding limit %ld; %d sending"
	.align 8
.LC2:
	.string	"throttle #%d '%.80s' rate %ld exceeding limit %ld; %d sending"
	.align 8
.LC3:
	.string	"throttle #%d '%.80s' rate %ld lower than minimum %ld; %d sending"
	.text
	.p2align 4
	.type	update_throttles, @function
update_throttles:
.LFB25:
	.cfi_startproc
	movl	numthrottles(%rip), %r8d
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
	testl	%r8d, %r8d
	jg	.L7
	jmp	.L13
	.p2align 4,,10
	.p2align 3
.L36:
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movl	%ebx, %edx
	movl	$.LC1, %esi
	movl	$5, %edi
	pushq	%rax
	.cfi_def_cfa_offset 48
.L35:
	xorl	%eax, %eax
	call	syslog
	movq	throttles(%rip), %rcx
	popq	%rsi
	.cfi_def_cfa_offset 40
	popq	%rdi
	.cfi_def_cfa_offset 32
	addq	%rbp, %rcx
	movq	24(%rcx), %r8
.L10:
	movq	16(%rcx), %r9
	cmpq	%r8, %r9
	jle	.L11
	movl	40(%rcx), %eax
	testl	%eax, %eax
	je	.L11
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movq	(%rcx), %rcx
	movl	%ebx, %edx
	movl	$.LC3, %esi
	pushq	%rax
	.cfi_def_cfa_offset 48
	movl	$5, %edi
	xorl	%eax, %eax
	call	syslog
	popq	%rax
	.cfi_def_cfa_offset 40
	popq	%rdx
	.cfi_def_cfa_offset 32
	.p2align 4,,10
	.p2align 3
.L11:
	addl	$1, %ebx
	addq	$48, %rbp
	cmpl	%ebx, numthrottles(%rip)
	jle	.L13
.L7:
	movq	throttles(%rip), %rcx
	addq	%rbp, %rcx
	movq	32(%rcx), %rdx
	movq	24(%rcx), %rsi
	movq	$0, 32(%rcx)
	movq	8(%rcx), %r9
	movq	%rdx, %rax
	shrq	$63, %rax
	addq	%rdx, %rax
	sarq	%rax
	leaq	(%rax,%rsi,2), %rsi
	movq	%rsi, %rax
	sarq	$63, %rsi
	imulq	%r12
	subq	%rsi, %rdx
	movq	%rdx, 24(%rcx)
	movq	%rdx, %r8
	cmpq	%r9, %rdx
	jle	.L10
	movl	40(%rcx), %eax
	testl	%eax, %eax
	je	.L11
	leaq	(%r9,%r9), %rdx
	movq	(%rcx), %rcx
	cmpq	%rdx, %r8
	jg	.L36
	subq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movl	%ebx, %edx
	movl	$.LC2, %esi
	movl	$6, %edi
	pushq	%rax
	.cfi_def_cfa_offset 48
	jmp	.L35
	.p2align 4,,10
	.p2align 3
.L13:
	.cfi_restore_state
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L6
	movq	connects(%rip), %r10
	subl	$1, %eax
	movq	throttles(%rip), %rbx
	leaq	(%rax,%rax,8), %rbp
	salq	$4, %rbp
	leaq	144(%r10), %r9
	addq	%r9, %rbp
	jmp	.L20
	.p2align 4,,10
	.p2align 3
.L15:
	movq	%r9, %r10
	cmpq	%r9, %rbp
	je	.L6
.L39:
	addq	$144, %r9
.L20:
	movl	(%r10), %eax
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L15
	movl	56(%r10), %ecx
	movq	$-1, 64(%r10)
	testl	%ecx, %ecx
	jle	.L15
	movslq	16(%r10), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%rbx, %rax
	movslq	40(%rax), %rsi
	movq	8(%rax), %rax
	cqto
	idivq	%rsi
	leaq	20(%r10), %rsi
	movq	%rax, %rdi
	leal	-1(%rcx), %eax
	leaq	(%rsi,%rax,4), %r11
	jmp	.L21
	.p2align 4,,10
	.p2align 3
.L38:
	cmpq	%rax, %rdi
	cmovg	%rax, %rdi
.L18:
	addq	$4, %rsi
.L21:
	cmpq	%r11, %rsi
	je	.L37
	movslq	(%rsi), %rax
	leaq	(%rax,%rax,2), %rcx
	salq	$4, %rcx
	addq	%rbx, %rcx
	movq	8(%rcx), %rax
	movslq	40(%rcx), %r8
	cqto
	idivq	%r8
	cmpq	$-1, %rdi
	jne	.L38
	movq	%rax, %rdi
	jmp	.L18
	.p2align 4,,10
	.p2align 3
.L37:
	movq	%rdi, 64(%r10)
	movq	%r9, %r10
	cmpq	%r9, %rbp
	jne	.L39
.L6:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE25:
	.size	update_throttles, .-update_throttles
	.section	.rodata.str1.8
	.align 8
.LC4:
	.string	"%s: no value required for %s option\n"
	.text
	.p2align 4
	.type	no_value_required, @function
no_value_required:
.LFB14:
	.cfi_startproc
	testq	%rsi, %rsi
	jne	.L45
	ret
.L45:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdi, %rcx
	movq	argv0(%rip), %rdx
	movl	$.LC4, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE14:
	.size	no_value_required, .-no_value_required
	.section	.rodata.str1.8
	.align 8
.LC5:
	.string	"%s: value required for %s option\n"
	.text
	.p2align 4
	.type	value_required, @function
value_required:
.LFB13:
	.cfi_startproc
	testq	%rsi, %rsi
	je	.L51
	ret
.L51:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdi, %rcx
	movq	argv0(%rip), %rdx
	movl	$.LC5, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE13:
	.size	value_required, .-value_required
	.section	.rodata.str1.8
	.align 8
.LC6:
	.string	"usage:  %s [-C configfile] [-p port] [-d dir] [-r|-nor] [-dd data_dir] [-s|-nos] [-v|-nov] [-g|-nog] [-u user] [-c cgipat] [-t throttles] [-h host] [-l logfile] [-i pidfile] [-T charset] [-P P3P] [-M maxage] [-V] [-D]\n"
	.text
	.p2align 4
	.type	usage, @function
usage:
.LFB11:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	xorl	%eax, %eax
	movl	$.LC6, %esi
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE11:
	.size	usage, .-usage
	.p2align 4
	.type	wakeup_connection, @function
wakeup_connection:
.LFB30:
	.cfi_startproc
	cmpl	$3, (%rdi)
	movq	$0, 96(%rdi)
	movq	%rdi, %rsi
	je	.L56
	ret
	.p2align 4,,10
	.p2align 3
.L56:
	movq	8(%rdi), %rax
	movl	$2, (%rdi)
	movl	$1, %edx
	movl	704(%rax), %edi
	jmp	fdwatch_add_fd
	.cfi_endproc
.LFE30:
	.size	wakeup_connection, .-wakeup_connection
	.section	.rodata.str1.8
	.align 8
.LC7:
	.string	"up %ld seconds, stats for %ld seconds:"
	.text
	.p2align 4
	.type	logstats, @function
logstats:
.LFB34:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	testq	%rdi, %rdi
	je	.L61
.L58:
	movq	(%rdi), %rax
	movl	$1, %ecx
	movl	$.LC7, %esi
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
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L61:
	.cfi_restore_state
	movq	%rsp, %rdi
	xorl	%esi, %esi
	call	gettimeofday
	movq	%rsp, %rdi
	jmp	.L58
	.cfi_endproc
.LFE34:
	.size	logstats, .-logstats
	.p2align 4
	.type	show_stats, @function
show_stats:
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
	xorl	%edi, %edi
	movl	(%rax), %ebp
	movq	%rax, %rbx
	call	logstats
	movl	%ebp, (%rbx)
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE6:
	.size	handle_usr2, .-handle_usr2
	.p2align 4
	.type	occasional, @function
occasional:
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
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC8:
	.string	"/tmp"
	.text
	.p2align 4
	.type	handle_alrm, @function
handle_alrm:
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
	movl	(%rax), %ebp
	movq	%rax, %rbx
	movl	watchdog_flag(%rip), %eax
	testl	%eax, %eax
	je	.L70
	movl	$0, watchdog_flag(%rip)
	movl	$360, %edi
	call	alarm
	movl	%ebp, (%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L70:
	.cfi_restore_state
	movl	$.LC8, %edi
	call	chdir
	call	abort
	.cfi_endproc
.LFE7:
	.size	handle_alrm, .-handle_alrm
	.section	.rodata.str1.1
.LC9:
	.string	"child wait - %m"
	.text
	.p2align 4
	.type	handle_chld, @function
handle_chld:
.LFB3:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	call	__errno_location
	movl	(%rax), %r12d
	movq	%rax, %rbx
.L72:
	movl	$1, %edx
	leaq	12(%rsp), %rsi
	movl	$-1, %edi
	call	waitpid
	testl	%eax, %eax
	je	.L73
	js	.L88
	movq	hs(%rip), %rdx
	testq	%rdx, %rdx
	je	.L72
	movl	36(%rdx), %eax
	subl	$1, %eax
	cmovs	%ebp, %eax
	movl	%eax, 36(%rdx)
	jmp	.L72
	.p2align 4,,10
	.p2align 3
.L88:
	movl	(%rbx), %eax
	cmpl	$4, %eax
	je	.L72
	cmpl	$11, %eax
	je	.L72
	cmpl	$10, %eax
	jne	.L89
.L73:
	movl	%r12d, (%rbx)
	addq	$16, %rsp
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
.L89:
	.cfi_restore_state
	movl	$.LC9, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	movl	%r12d, (%rbx)
	addq	$16, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE3:
	.size	handle_chld, .-handle_chld
	.section	.rodata.str1.8
	.align 8
.LC10:
	.string	"out of memory copying a string"
	.align 8
.LC11:
	.string	"%s: out of memory copying a string\n"
	.text
	.p2align 4
	.type	e_strdup, @function
e_strdup:
.LFB15:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	strdup
	testq	%rax, %rax
	je	.L93
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L93:
	.cfi_restore_state
	movl	$.LC10, %esi
	movl	$2, %edi
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	xorl	%eax, %eax
	movl	$.LC11, %esi
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE15:
	.size	e_strdup, .-e_strdup
	.section	.rodata.str1.1
.LC12:
	.string	"r"
.LC13:
	.string	" \t\n\r"
.LC14:
	.string	"debug"
.LC15:
	.string	"port"
.LC16:
	.string	"dir"
.LC17:
	.string	"chroot"
.LC18:
	.string	"nochroot"
.LC19:
	.string	"data_dir"
.LC20:
	.string	"symlink"
.LC21:
	.string	"nosymlink"
.LC22:
	.string	"symlinks"
.LC23:
	.string	"nosymlinks"
.LC24:
	.string	"user"
.LC25:
	.string	"cgipat"
.LC26:
	.string	"cgilimit"
.LC27:
	.string	"urlpat"
.LC28:
	.string	"noemptyreferers"
.LC29:
	.string	"localpat"
.LC30:
	.string	"throttles"
.LC31:
	.string	"host"
.LC32:
	.string	"logfile"
.LC33:
	.string	"vhost"
.LC34:
	.string	"novhost"
.LC35:
	.string	"globalpasswd"
.LC36:
	.string	"noglobalpasswd"
.LC37:
	.string	"pidfile"
.LC38:
	.string	"charset"
.LC39:
	.string	"p3p"
.LC40:
	.string	"max_age"
	.section	.rodata.str1.8
	.align 8
.LC41:
	.string	"%s: unknown config option '%s'\n"
	.text
	.p2align 4
	.type	read_config, @function
read_config:
.LFB12:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	movl	$.LC12, %esi
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$112, %rsp
	.cfi_def_cfa_offset 160
	call	fopen
	testq	%rax, %rax
	je	.L141
	movabsq	$4294977024, %rbp
	movq	%rax, %r13
.L95:
	movq	%r13, %rdx
	movl	$1000, %esi
	movq	%rsp, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L146
	movl	$35, %esi
	movq	%rsp, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L96
	movb	$0, (%rax)
.L96:
	movl	$.LC13, %esi
	movq	%rsp, %rdi
	call	strspn
	leaq	(%rsp,%rax), %r12
	cmpb	$0, (%r12)
	je	.L95
	.p2align 4,,10
	.p2align 3
.L97:
	movl	$.LC13, %esi
	movq	%r12, %rdi
	call	strcspn
	leaq	(%r12,%rax), %rbx
	movzbl	(%rbx), %eax
	cmpb	$32, %al
	jbe	.L143
	.p2align 4,,10
	.p2align 3
.L98:
	movl	$61, %esi
	movq	%r12, %rdi
	xorl	%r14d, %r14d
	call	strchr
	testq	%rax, %rax
	je	.L100
	movb	$0, (%rax)
	leaq	1(%rax), %r14
.L100:
	movl	$.LC14, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L147
	movl	$.LC15, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L148
	movl	$.LC16, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L149
	movl	$.LC17, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L150
	movl	$.LC18, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L151
	movl	$.LC19, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L152
	movl	$.LC20, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L144
	movl	$.LC21, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L145
	movl	$.LC22, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L144
	movl	$.LC23, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L145
	movl	$.LC24, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L153
	movl	$.LC25, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L154
	movl	$.LC26, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L155
	movl	$.LC27, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L156
	movl	$.LC28, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L157
	movl	$.LC29, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L158
	movl	$.LC30, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L159
	movl	$.LC31, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L160
	movl	$.LC32, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L161
	movl	$.LC33, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L162
	movl	$.LC34, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L163
	movl	$.LC35, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L164
	movl	$.LC36, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L165
	movl	$.LC37, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L166
	movl	$.LC38, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L167
	movl	$.LC39, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L168
	movl	$.LC40, %esi
	movq	%r12, %rdi
	call	strcasecmp
	testl	%eax, %eax
	jne	.L128
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	atoi
	movl	%eax, max_age(%rip)
	jmp	.L102
	.p2align 4,,10
	.p2align 3
.L143:
	btq	%rax, %rbp
	jnc	.L98
	movzbl	1(%rbx), %eax
	addq	$1, %rbx
	movb	$0, -1(%rbx)
	cmpb	$32, %al
	ja	.L98
	jmp	.L143
	.p2align 4,,10
	.p2align 3
.L147:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$1, debug(%rip)
.L102:
	movl	$.LC13, %esi
	movq	%rbx, %rdi
	call	strspn
	leaq	(%rbx,%rax), %r12
	cmpb	$0, (%r12)
	jne	.L97
	jmp	.L95
.L148:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	atoi
	movw	%ax, port(%rip)
	jmp	.L102
.L149:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, dir(%rip)
	jmp	.L102
.L150:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L102
.L151:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L102
.L152:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, data_dir(%rip)
	jmp	.L102
.L144:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$0, no_symlink_check(%rip)
	jmp	.L102
.L145:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$1, no_symlink_check(%rip)
	jmp	.L102
.L153:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, user(%rip)
	jmp	.L102
.L146:
	movq	%r13, %rdi
	call	fclose
	addq	$112, %rsp
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
.L154:
	.cfi_restore_state
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, cgi_pattern(%rip)
	jmp	.L102
.L156:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, url_pattern(%rip)
	jmp	.L102
.L155:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	atoi
	movl	%eax, cgi_limit(%rip)
	jmp	.L102
.L158:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, local_pattern(%rip)
	jmp	.L102
.L157:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$1, no_empty_referers(%rip)
	jmp	.L102
.L159:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, throttlefile(%rip)
	jmp	.L102
.L161:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, logfile(%rip)
	jmp	.L102
.L160:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, hostname(%rip)
	jmp	.L102
.L141:
	movq	%rbp, %rdi
	call	perror
	movl	$1, %edi
	call	exit
	.p2align 4,,10
	.p2align 3
.L164:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$1, do_global_passwd(%rip)
	jmp	.L102
.L128:
	movq	stderr(%rip), %rdi
	movq	%r12, %rcx
	movl	$.LC41, %esi
	xorl	%eax, %eax
	movq	argv0(%rip), %rdx
	call	fprintf
	movl	$1, %edi
	call	exit
	.p2align 4,,10
	.p2align 3
.L168:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, p3p(%rip)
	jmp	.L102
.L167:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, charset(%rip)
	jmp	.L102
.L166:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, pidfile(%rip)
	jmp	.L102
.L165:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$0, do_global_passwd(%rip)
	jmp	.L102
.L163:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$0, do_vhost(%rip)
	jmp	.L102
.L162:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	no_value_required
	movl	$1, do_vhost(%rip)
	jmp	.L102
	.cfi_endproc
.LFE12:
	.size	read_config, .-read_config
	.section	.rodata.str1.1
.LC42:
	.string	"nobody"
.LC43:
	.string	"iso-8859-1"
.LC44:
	.string	""
.LC45:
	.string	"thttpd/2.27.0 Oct 3, 2014"
.LC46:
	.string	"-nor"
.LC47:
	.string	"-dd"
.LC48:
	.string	"-nos"
.LC49:
	.string	"-u"
.LC50:
	.string	"-c"
.LC51:
	.string	"-t"
.LC52:
	.string	"-h"
.LC53:
	.string	"-l"
.LC54:
	.string	"-v"
.LC55:
	.string	"-nov"
.LC56:
	.string	"-g"
.LC57:
	.string	"-nog"
.LC58:
	.string	"-i"
.LC59:
	.string	"-T"
.LC60:
	.string	"-P"
.LC61:
	.string	"-M"
.LC62:
	.string	"-D"
	.text
	.p2align 4
	.type	parse_args, @function
parse_args:
.LFB10:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movl	$80, %eax
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rsi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movl	%edi, %r12d
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
	movq	$.LC42, user(%rip)
	movq	$.LC43, charset(%rip)
	movq	$.LC44, p3p(%rip)
	movl	$-1, max_age(%rip)
	cmpl	$1, %edi
	jg	.L170
	jmp	.L171
	.p2align 4,,10
	.p2align 3
.L183:
	movl	$5, %ecx
	movl	$.LC46, %edi
	movq	%rbp, %rsi
	repz cmpsb
	seta	%cl
	sbbb	$0, %cl
	testb	%cl, %cl
	jne	.L184
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	.p2align 4,,10
	.p2align 3
.L177:
	addl	$1, %ebx
	cmpl	%ebx, %r12d
	jle	.L171
.L170:
	movslq	%ebx, %rax
	movq	0(%r13,%rax,8), %rbp
	leaq	0(,%rax,8), %r14
	cmpb	$45, 0(%rbp)
	jne	.L204
	movzbl	1(%rbp), %eax
	cmpl	$86, %eax
	jne	.L173
	cmpb	$0, 2(%rbp)
	je	.L219
.L173:
	movzbl	0(%rbp), %edx
	cmpl	$45, %edx
	jne	.L183
	cmpl	$67, %eax
	je	.L220
.L175:
	cmpl	$45, %edx
	jne	.L183
	cmpl	$112, %eax
	jne	.L179
	cmpb	$0, 2(%rbp)
	jne	.L179
	leal	1(%rbx), %r15d
	cmpl	%r12d, %r15d
	jge	.L180
	movq	8(%r13,%r14), %rdi
	movl	%r15d, %ebx
	addl	$1, %ebx
	call	atoi
	movw	%ax, port(%rip)
	cmpl	%ebx, %r12d
	jg	.L170
	.p2align 4,,10
	.p2align 3
.L171:
	cmpl	%ebx, %r12d
	jne	.L204
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
.L220:
	.cfi_restore_state
	cmpb	$0, 2(%rbp)
	jne	.L175
	leal	1(%rbx), %r15d
	cmpl	%r12d, %r15d
	jl	.L221
	cmpl	$112, %eax
	je	.L180
.L179:
	cmpl	$45, %edx
	jne	.L183
	cmpl	$100, %eax
	je	.L222
.L180:
	cmpl	$45, %edx
	jne	.L183
	cmpl	$114, %eax
	jne	.L183
	cmpb	$0, 2(%rbp)
	jne	.L183
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L177
	.p2align 4,,10
	.p2align 3
.L221:
	movq	8(%r13,%r14), %rdi
	movl	%r15d, %ebx
	call	read_config
	jmp	.L177
	.p2align 4,,10
	.p2align 3
.L184:
	movl	$4, %ecx
	movl	$.LC47, %edi
	movq	%rbp, %rsi
	repz cmpsb
	seta	%cl
	sbbb	$0, %cl
	testb	%cl, %cl
	jne	.L185
	leal	1(%rbx), %ecx
	cmpl	%r12d, %ecx
	jl	.L223
.L185:
	cmpl	$45, %edx
	jne	.L187
	cmpl	$115, %eax
	jne	.L187
	cmpb	$0, 2(%rbp)
	jne	.L187
	movl	$0, no_symlink_check(%rip)
	jmp	.L177
.L187:
	movl	$.LC48, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L188
	movl	$1, no_symlink_check(%rip)
	jmp	.L177
	.p2align 4,,10
	.p2align 3
.L222:
	cmpb	$0, 2(%rbp)
	jne	.L180
	leal	1(%rbx), %ecx
	cmpl	%r12d, %ecx
	jge	.L180
	movq	8(%r13,%r14), %rax
	movl	%ecx, %ebx
	movq	%rax, dir(%rip)
	jmp	.L177
.L223:
	movq	8(%r13,%r14), %rax
	movl	%ecx, %ebx
	movq	%rax, data_dir(%rip)
	jmp	.L177
.L188:
	movl	$.LC49, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L189
	leal	1(%rbx), %eax
	cmpl	%r12d, %eax
	jge	.L189
	movq	8(%r13,%r14), %rdx
	movl	%eax, %ebx
	movq	%rdx, user(%rip)
	jmp	.L177
.L219:
	movl	$.LC45, %edi
	call	puts
	xorl	%edi, %edi
	call	exit
.L189:
	movl	$.LC50, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L190
	leal	1(%rbx), %eax
	cmpl	%r12d, %eax
	jl	.L224
.L190:
	movl	$.LC51, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L191
	leal	1(%rbx), %eax
	cmpl	%r12d, %eax
	jge	.L192
	movq	8(%r13,%r14), %rdx
	movl	%eax, %ebx
	movq	%rdx, throttlefile(%rip)
	jmp	.L177
.L191:
	movl	$.LC52, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L193
	leal	1(%rbx), %eax
	cmpl	%r12d, %eax
	jge	.L194
	movq	8(%r13,%r14), %rdx
	movl	%eax, %ebx
	movq	%rdx, hostname(%rip)
	jmp	.L177
.L192:
	movl	$.LC52, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L194
.L193:
	movl	$.LC53, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L194
	leal	1(%rbx), %eax
	cmpl	%r12d, %eax
	jge	.L194
	movq	8(%r13,%r14), %rdx
	movl	%eax, %ebx
	movq	%rdx, logfile(%rip)
	jmp	.L177
.L194:
	movl	$.LC54, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L225
	movl	$.LC55, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L196
	movl	$0, do_vhost(%rip)
	jmp	.L177
.L224:
	movq	8(%r13,%r14), %rdx
	movl	%eax, %ebx
	movq	%rdx, cgi_pattern(%rip)
	jmp	.L177
.L225:
	movl	$1, do_vhost(%rip)
	jmp	.L177
.L196:
	movl	$.LC56, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L197
	movl	$1, do_global_passwd(%rip)
	jmp	.L177
.L197:
	movl	$.LC57, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L198
	movl	$0, do_global_passwd(%rip)
	jmp	.L177
.L198:
	movl	$.LC58, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L199
	leal	1(%rbx), %eax
	cmpl	%r12d, %eax
	jge	.L200
	movq	8(%r13,%r14), %rdx
	movl	%eax, %ebx
	movq	%rdx, pidfile(%rip)
	jmp	.L177
.L199:
	movl	$.LC59, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L201
	leal	1(%rbx), %eax
	cmpl	%r12d, %eax
	jge	.L200
	movq	8(%r13,%r14), %rdx
	movl	%eax, %ebx
	movq	%rdx, charset(%rip)
	jmp	.L177
.L200:
	movl	$.LC60, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L203
.L202:
	movl	$.LC61, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L203
	leal	1(%rbx), %r15d
	cmpl	%r12d, %r15d
	jge	.L203
	movq	8(%r13,%r14), %rdi
	movl	%r15d, %ebx
	call	atoi
	movl	%eax, max_age(%rip)
	jmp	.L177
.L201:
	movl	$.LC60, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L202
	leal	1(%rbx), %eax
	cmpl	%r12d, %eax
	jge	.L203
	movq	8(%r13,%r14), %rdx
	movl	%eax, %ebx
	movq	%rdx, p3p(%rip)
	jmp	.L177
.L203:
	movl	$.LC62, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L204
	movl	$1, debug(%rip)
	jmp	.L177
.L204:
	call	usage
	.cfi_endproc
.LFE10:
	.size	parse_args, .-parse_args
	.section	.rodata.str1.1
.LC63:
	.string	"%.80s - %m"
.LC64:
	.string	" %4900[^ \t] %ld"
	.section	.rodata.str1.8
	.align 8
.LC65:
	.string	"unparsable line in %.80s - %.80s"
	.align 8
.LC66:
	.string	"%s: unparsable line in %.80s - %.80s\n"
	.section	.rodata.str1.1
.LC67:
	.string	"|/"
	.section	.rodata.str1.8
	.align 8
.LC68:
	.string	"out of memory allocating a throttletab"
	.align 8
.LC69:
	.string	"%s: out of memory allocating a throttletab\n"
	.section	.rodata.str1.1
.LC70:
	.string	" %4900[^ \t] %ld-%ld"
	.text
	.p2align 4
	.type	read_throttlefile, @function
read_throttlefile:
.LFB17:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	movl	$.LC12, %esi
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rdi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$10048, %rsp
	.cfi_def_cfa_offset 10096
	call	fopen
	testq	%rax, %rax
	je	.L264
	xorl	%esi, %esi
	leaq	16(%rsp), %rdi
	leaq	32(%rsp), %rbx
	movq	%rax, %r12
	movabsq	$4294977024, %rbp
	call	gettimeofday
	.p2align 4,,10
	.p2align 3
.L234:
	movq	%r12, %rdx
	movl	$5000, %esi
	movq	%rbx, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L265
	movl	$35, %esi
	movq	%rbx, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L229
	movb	$0, (%rax)
.L229:
	movq	%rbx, %rdx
.L230:
	movl	(%rdx), %ecx
	addq	$4, %rdx
	leal	-16843009(%rcx), %eax
	notl	%ecx
	andl	%ecx, %eax
	andl	$-2139062144, %eax
	je	.L230
	movl	%eax, %ecx
	shrl	$16, %ecx
	testl	$32896, %eax
	cmove	%ecx, %eax
	leaq	2(%rdx), %rcx
	cmove	%rcx, %rdx
	movl	%eax, %esi
	addb	%al, %sil
	sbbq	$3, %rdx
	subq	%rbx, %rdx
	je	.L234
	movslq	%edx, %rcx
	subl	$1, %edx
	leaq	(%rbx,%rcx), %rax
	leaq	31(%rsp,%rcx), %rcx
	subq	%rdx, %rcx
	.p2align 4,,10
	.p2align 3
.L233:
	movzbl	-1(%rax), %edx
	cmpb	$32, %dl
	jbe	.L266
.L235:
	xorl	%eax, %eax
	movq	%rsp, %r8
	leaq	8(%rsp), %rcx
	movl	$.LC70, %esi
	leaq	5040(%rsp), %rdx
	movq	%rbx, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L238
	xorl	%eax, %eax
	movq	%rsp, %rcx
	leaq	5040(%rsp), %rdx
	movq	%rbx, %rdi
	movl	$.LC64, %esi
	call	__isoc99_sscanf
	cmpl	$2, %eax
	je	.L267
	movq	%rbx, %rcx
	movq	%r13, %rdx
	xorl	%eax, %eax
	movl	$.LC65, %esi
	movl	$2, %edi
	call	syslog
	movq	%rbx, %r8
	movq	%r13, %rcx
	movl	$.LC66, %esi
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L234
	.p2align 4,,10
	.p2align 3
.L266:
	btq	%rdx, %rbp
	jnc	.L235
	movb	$0, -1(%rax)
	subq	$1, %rax
	cmpq	%rcx, %rax
	jne	.L233
	jmp	.L234
	.p2align 4,,10
	.p2align 3
.L267:
	movq	$0, 8(%rsp)
.L238:
	cmpb	$47, 5040(%rsp)
	jne	.L241
	jmp	.L268
	.p2align 4,,10
	.p2align 3
.L242:
	leaq	2(%rax), %rsi
	leaq	1(%rax), %rdi
	call	strcpy
.L241:
	movl	$.LC67, %esi
	leaq	5040(%rsp), %rdi
	call	strstr
	testq	%rax, %rax
	jne	.L242
	movslq	numthrottles(%rip), %r14
	movl	maxthrottles(%rip), %eax
	cmpl	%eax, %r14d
	jl	.L243
	testl	%eax, %eax
	jne	.L244
	movl	$100, maxthrottles(%rip)
	movl	$4800, %edi
	call	malloc
	movq	%rax, throttles(%rip)
.L245:
	testq	%rax, %rax
	je	.L269
.L246:
	leaq	(%r14,%r14,2), %r14
	leaq	5040(%rsp), %rdi
	salq	$4, %r14
	addq	%rax, %r14
	call	e_strdup
	movq	(%rsp), %rcx
	movq	%rax, (%r14)
	movslq	numthrottles(%rip), %rax
	movq	%rax, %rdx
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	throttles(%rip), %rax
	addl	$1, %edx
	movq	%rcx, 8(%rax)
	movq	8(%rsp), %rcx
	movq	$0, 24(%rax)
	movq	%rcx, 16(%rax)
	movq	$0, 32(%rax)
	movl	$0, 40(%rax)
	movl	%edx, numthrottles(%rip)
	jmp	.L234
.L244:
	addl	%eax, %eax
	movq	throttles(%rip), %rdi
	movl	%eax, maxthrottles(%rip)
	cltq
	leaq	(%rax,%rax,2), %rsi
	salq	$4, %rsi
	call	realloc
	movq	%rax, throttles(%rip)
	jmp	.L245
.L243:
	movq	throttles(%rip), %rax
	jmp	.L246
.L268:
	leaq	5041(%rsp), %rsi
	leaq	5040(%rsp), %rdi
	call	strcpy
	jmp	.L241
.L265:
	movq	%r12, %rdi
	call	fclose
	addq	$10048, %rsp
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
.L264:
	.cfi_restore_state
	movq	%r13, %rdx
	movl	$.LC63, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movq	%r13, %rdi
	call	perror
	movl	$1, %edi
	call	exit
.L269:
	movl	$.LC68, %esi
	movl	$2, %edi
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	xorl	%eax, %eax
	movl	$.LC69, %esi
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE17:
	.size	read_throttlefile, .-read_throttlefile
	.section	.rodata.str1.1
.LC71:
	.string	"re-opening logfile"
.LC72:
	.string	"a"
.LC73:
	.string	"re-opening %.80s - %m"
	.text
	.p2align 4
	.type	re_open_logfile, @function
re_open_logfile:
.LFB8:
	.cfi_startproc
	movl	no_log(%rip), %eax
	testl	%eax, %eax
	jne	.L270
	cmpq	$0, hs(%rip)
	je	.L270
	movq	logfile(%rip), %rax
	testq	%rax, %rax
	je	.L270
	cmpb	$45, (%rax)
	je	.L285
.L276:
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	xorl	%eax, %eax
	movl	$.LC71, %esi
	movl	$5, %edi
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	syslog
	movq	logfile(%rip), %rdi
	movl	$.LC72, %esi
	call	fopen
	movq	logfile(%rip), %r12
	movl	$384, %esi
	movq	%rax, %rbp
	movq	%r12, %rdi
	call	chmod
	testq	%rbp, %rbp
	je	.L275
	testl	%eax, %eax
	jne	.L275
	movq	%rbp, %rdi
	call	fileno
	movl	$2, %esi
	movl	$1, %edx
	movl	%eax, %edi
	xorl	%eax, %eax
	call	fcntl
	movq	hs(%rip), %rdi
	addq	$8, %rsp
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
.L285:
	cmpb	$0, 1(%rax)
	jne	.L276
.L270:
	ret
	.p2align 4,,10
	.p2align 3
.L275:
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -24
	.cfi_offset 12, -16
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	movq	%r12, %rdx
	movl	$.LC73, %esi
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
	.section	.rodata.str1.1
.LC74:
	.string	"too many connections!"
	.section	.rodata.str1.8
	.align 8
.LC75:
	.string	"the connects free list is messed up"
	.align 8
.LC76:
	.string	"out of memory allocating an httpd_conn"
	.text
	.p2align 4
	.type	handle_newconnect, @function
handle_newconnect:
.LFB19:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	movabsq	$-4294967295, %r14
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rdi, %r13
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movl	%esi, %ebx
	subq	$24, %rsp
	.cfi_def_cfa_offset 64
	movl	num_connects(%rip), %eax
.L295:
	cmpl	%eax, max_connects(%rip)
	jle	.L305
	movslq	first_free_connect(%rip), %rax
	cmpl	$-1, %eax
	je	.L289
	leaq	(%rax,%rax,8), %rbp
	salq	$4, %rbp
	addq	connects(%rip), %rbp
	movl	0(%rbp), %eax
	testl	%eax, %eax
	jne	.L289
	movq	8(%rbp), %rdx
	testq	%rdx, %rdx
	je	.L306
.L291:
	movq	hs(%rip), %rdi
	movl	%ebx, %esi
	call	httpd_get_conn
	testl	%eax, %eax
	je	.L293
	cmpl	$2, %eax
	je	.L297
	movl	4(%rbp), %eax
	movq	%r14, 0(%rbp)
	addl	$1, num_connects(%rip)
	movl	%eax, first_free_connect(%rip)
	movq	0(%r13), %rax
	movq	$0, 96(%rbp)
	movq	%rax, 88(%rbp)
	movq	8(%rbp), %rax
	movq	$0, 104(%rbp)
	movl	$0, 56(%rbp)
	movl	704(%rax), %edi
	movq	$0, 136(%rbp)
	call	httpd_set_ndelay
	movq	8(%rbp), %rax
	xorl	%edx, %edx
	movq	%rbp, %rsi
	movl	704(%rax), %edi
	call	fdwatch_add_fd
	addq	$1, stats_connections(%rip)
	movl	num_connects(%rip), %eax
	cmpl	stats_simultaneous(%rip), %eax
	jle	.L295
	movl	%eax, stats_simultaneous(%rip)
	jmp	.L295
	.p2align 4,,10
	.p2align 3
.L297:
	movl	$1, %eax
.L286:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L293:
	.cfi_restore_state
	movq	%r13, %rdi
	movl	%eax, 12(%rsp)
	call	tmr_run
	movl	12(%rsp), %eax
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L306:
	.cfi_restore_state
	movl	$720, %edi
	call	malloc
	movq	%rax, 8(%rbp)
	movq	%rax, %rdx
	testq	%rax, %rax
	je	.L307
	addl	$1, httpd_conn_count(%rip)
	movl	$0, (%rax)
	jmp	.L291
	.p2align 4,,10
	.p2align 3
.L305:
	xorl	%eax, %eax
	movl	$.LC74, %esi
	movl	$4, %edi
	call	syslog
	movq	%r13, %rdi
	call	tmr_run
	xorl	%eax, %eax
	jmp	.L286
.L289:
	movl	$.LC75, %esi
.L304:
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L307:
	movl	$.LC76, %esi
	jmp	.L304
	.cfi_endproc
.LFE19:
	.size	handle_newconnect, .-handle_newconnect
	.section	.rodata.str1.8
	.align 8
.LC77:
	.string	"throttle sending count was negative - shouldn't happen!"
	.text
	.p2align 4
	.type	check_throttles, @function
check_throttles:
.LFB23:
	.cfi_startproc
	movl	numthrottles(%rip), %eax
	movl	$0, 56(%rdi)
	movq	$-1, 72(%rdi)
	movq	$-1, 64(%rdi)
	testl	%eax, %eax
	jle	.L332
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	xorl	%ebx, %ebx
	jmp	.L309
	.p2align 4,,10
	.p2align 3
.L315:
	cmpq	%rdi, %rax
	cmovl	%rdi, %rax
	movq	%rax, 72(%rbp)
.L311:
	addl	$1, %r13d
	cmpl	%r13d, numthrottles(%rip)
	jle	.L316
.L333:
	addq	$1, %rbx
	cmpl	$9, 56(%rbp)
	jg	.L316
.L309:
	movq	8(%rbp), %rax
	leaq	(%rbx,%rbx,2), %r12
	movl	%ebx, %r13d
	movl	%ebx, %r14d
	salq	$4, %r12
	movq	240(%rax), %rsi
	movq	throttles(%rip), %rax
	movq	(%rax,%r12), %rdi
	call	match
	testl	%eax, %eax
	je	.L311
	movq	throttles(%rip), %rcx
	addq	%r12, %rcx
	movq	8(%rcx), %rax
	movq	24(%rcx), %rdx
	leaq	(%rax,%rax), %rsi
	cmpq	%rsi, %rdx
	jg	.L319
	movq	16(%rcx), %rdi
	cmpq	%rdi, %rdx
	jl	.L319
	movl	40(%rcx), %esi
	testl	%esi, %esi
	js	.L312
	addl	$1, %esi
	cqto
	movslq	%esi, %r8
	idivq	%r8
.L313:
	movslq	56(%rbp), %rdx
	leal	1(%rdx), %r8d
	movl	%r8d, 56(%rbp)
	movl	%r14d, 16(%rbp,%rdx,4)
	movq	64(%rbp), %rdx
	movl	%esi, 40(%rcx)
	cmpq	$-1, %rdx
	je	.L314
	cmpq	%rdx, %rax
	cmovg	%rdx, %rax
.L314:
	movq	%rax, 64(%rbp)
	movq	72(%rbp), %rax
	cmpq	$-1, %rax
	jne	.L315
	addl	$1, %r13d
	cmpl	%r13d, numthrottles(%rip)
	movq	%rdi, 72(%rbp)
	jg	.L333
.L316:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movl	$1, %eax
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
.L312:
	.cfi_restore_state
	movl	$.LC77, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	movq	throttles(%rip), %rcx
	movl	$1, %esi
	addq	%r12, %rcx
	movq	8(%rcx), %rax
	movq	16(%rcx), %rdi
	movl	$0, 40(%rcx)
	jmp	.L313
	.p2align 4,,10
	.p2align 3
.L319:
	popq	%rbx
	.cfi_def_cfa_offset 40
	xorl	%eax, %eax
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L332:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	movl	$1, %eax
	ret
	.cfi_endproc
.LFE23:
	.size	check_throttles, .-check_throttles
	.p2align 4
	.type	shut_down, @function
shut_down:
.LFB18:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	xorl	%esi, %esi
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	xorl	%ebx, %ebx
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movq	%rsp, %rdi
	call	gettimeofday
	movq	%rsp, %rdi
	call	logstats
	movl	max_connects(%rip), %edx
	testl	%edx, %edx
	jg	.L335
	jmp	.L340
	.p2align 4,,10
	.p2align 3
.L338:
	testq	%rdi, %rdi
	je	.L339
	call	httpd_destroy_conn
	movq	connects(%rip), %r12
	addq	%rbx, %r12
	movq	8(%r12), %rdi
	call	free
	subl	$1, httpd_conn_count(%rip)
	movq	$0, 8(%r12)
.L339:
	addl	$1, %ebp
	addq	$144, %rbx
	cmpl	%ebp, max_connects(%rip)
	jle	.L340
.L335:
	movq	connects(%rip), %rax
	addq	%rbx, %rax
	movq	8(%rax), %rdi
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L338
	movq	%rsp, %rsi
	call	httpd_close_conn
	movq	connects(%rip), %rax
	movq	8(%rax,%rbx), %rdi
	jmp	.L338
	.p2align 4,,10
	.p2align 3
.L340:
	movq	hs(%rip), %rbp
	testq	%rbp, %rbp
	je	.L337
	movq	$0, hs(%rip)
	movl	72(%rbp), %edi
	cmpl	$-1, %edi
	jne	.L361
	movl	76(%rbp), %edi
	cmpl	$-1, %edi
	jne	.L362
.L342:
	movq	%rbp, %rdi
	call	httpd_terminate
.L337:
	call	mmc_destroy
	call	tmr_destroy
	movq	connects(%rip), %rdi
	call	free
	movq	throttles(%rip), %rdi
	testq	%rdi, %rdi
	je	.L334
	call	free
.L334:
	addq	$16, %rsp
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
.L362:
	.cfi_restore_state
	call	fdwatch_del_fd
	jmp	.L342
	.p2align 4,,10
	.p2align 3
.L361:
	call	fdwatch_del_fd
	movl	76(%rbp), %edi
	cmpl	$-1, %edi
	je	.L342
	jmp	.L362
	.cfi_endproc
.LFE18:
	.size	shut_down, .-shut_down
	.section	.rodata.str1.1
.LC78:
	.string	"exiting"
	.text
	.p2align 4
	.type	handle_usr1, @function
handle_usr1:
.LFB5:
	.cfi_startproc
	movl	num_connects(%rip), %eax
	testl	%eax, %eax
	je	.L368
	movl	$1, got_usr1(%rip)
	ret
	.p2align 4,,10
	.p2align 3
.L368:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	shut_down
	movl	$5, %edi
	movl	$.LC78, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	xorl	%edi, %edi
	call	exit
	.cfi_endproc
.LFE5:
	.size	handle_usr1, .-handle_usr1
	.section	.rodata.str1.1
.LC79:
	.string	"exiting due to signal %d"
	.text
	.p2align 4
	.type	handle_term, @function
handle_term:
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
	movl	$.LC79, %esi
	call	syslog
	call	closelog
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE2:
	.size	handle_term, .-handle_term
	.p2align 4
	.type	clear_throttles.isra.0, @function
clear_throttles.isra.0:
.LFB36:
	.cfi_startproc
	movl	56(%rdi), %eax
	testl	%eax, %eax
	jle	.L371
	subl	$1, %eax
	movq	throttles(%rip), %rcx
	leaq	16(%rdi), %rdx
	leaq	20(%rdi,%rax,4), %rsi
	.p2align 4,,10
	.p2align 3
.L373:
	movslq	(%rdx), %rax
	addq	$4, %rdx
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	subl	$1, 40(%rcx,%rax)
	cmpq	%rsi, %rdx
	jne	.L373
.L371:
	ret
	.cfi_endproc
.LFE36:
	.size	clear_throttles.isra.0, .-clear_throttles.isra.0
	.p2align 4
	.type	really_clear_connection, @function
really_clear_connection:
.LFB28:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	8(%rdi), %rdi
	movq	200(%rdi), %rax
	addq	%rax, stats_bytes(%rip)
	cmpl	$3, (%rbx)
	je	.L376
	movl	704(%rdi), %edi
	call	fdwatch_del_fd
	movq	8(%rbx), %rdi
.L376:
	movq	%rbp, %rsi
	call	httpd_close_conn
	movq	%rbx, %rdi
	call	clear_throttles.isra.0
	movq	104(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L377
	call	tmr_cancel
	movq	$0, 104(%rbx)
.L377:
	movl	first_free_connect(%rip), %eax
	movl	$0, (%rbx)
	movabsq	$-8198552921648689607, %rdi
	subl	$1, num_connects(%rip)
	movl	%eax, 4(%rbx)
	subq	connects(%rip), %rbx
	sarq	$4, %rbx
	imulq	%rdi, %rbx
	movl	%ebx, first_free_connect(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE28:
	.size	really_clear_connection, .-really_clear_connection
	.section	.rodata.str1.8
	.align 8
.LC80:
	.string	"replacing non-null linger_timer!"
	.align 8
.LC81:
	.string	"tmr_create(linger_clear_connection) failed"
	.text
	.p2align 4
	.type	clear_connection, @function
clear_connection:
.LFB27:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rdi, %rbp
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	96(%rdi), %rdi
	testq	%rdi, %rdi
	je	.L383
	call	tmr_cancel
	movq	$0, 96(%rbp)
.L383:
	movl	0(%rbp), %eax
	cmpl	$4, %eax
	je	.L396
	movq	8(%rbp), %rdx
	movl	556(%rdx), %ecx
	testl	%ecx, %ecx
	je	.L385
	movl	704(%rdx), %edi
	cmpl	$3, %eax
	jne	.L397
.L386:
	movl	$4, 0(%rbp)
	movl	$1, %esi
	call	shutdown
	movq	8(%rbp), %rax
	xorl	%edx, %edx
	movq	%rbp, %rsi
	movl	704(%rax), %edi
	call	fdwatch_add_fd
	cmpq	$0, 104(%rbp)
	je	.L387
	movl	$.LC80, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L387:
	xorl	%r8d, %r8d
	movl	$500, %ecx
	movq	%rbp, %rdx
	movl	$linger_clear_connection, %esi
	movq	%r12, %rdi
	call	tmr_create
	movq	%rax, 104(%rbp)
	testq	%rax, %rax
	je	.L398
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L397:
	.cfi_restore_state
	call	fdwatch_del_fd
	movq	8(%rbp), %rax
	movl	704(%rax), %edi
	jmp	.L386
	.p2align 4,,10
	.p2align 3
.L396:
	movq	104(%rbp), %rdi
	call	tmr_cancel
	movq	8(%rbp), %rax
	movq	$0, 104(%rbp)
	movl	$0, 556(%rax)
.L385:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%r12, %rsi
	movq	%rbp, %rdi
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	really_clear_connection
.L398:
	.cfi_restore_state
	movl	$2, %edi
	movl	$.LC81, %esi
	call	syslog
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE27:
	.size	clear_connection, .-clear_connection
	.p2align 4
	.type	finish_connection, @function
finish_connection:
.LFB26:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rdi, %rbp
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	8(%rdi), %rdi
	call	httpd_write_response
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	movq	%r12, %rsi
	movq	%rbp, %rdi
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	clear_connection
	.cfi_endproc
.LFE26:
	.size	finish_connection, .-finish_connection
	.p2align 4
	.type	handle_read, @function
handle_read:
.LFB20:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movq	%rsi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	8(%rdi), %rbp
	movq	160(%rbp), %rsi
	movq	152(%rbp), %rdx
	cmpq	%rdx, %rsi
	jb	.L402
	cmpq	$5000, %rdx
	ja	.L426
	addq	$1000, %rdx
	leaq	152(%rbp), %rsi
	leaq	144(%rbp), %rdi
	call	httpd_realloc_str
	movq	152(%rbp), %rdx
	movq	160(%rbp), %rsi
.L402:
	movl	704(%rbp), %edi
	subq	%rsi, %rdx
	addq	144(%rbp), %rsi
	call	read
	testl	%eax, %eax
	je	.L426
	jns	.L405
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L401
	cmpl	$11, %eax
	je	.L401
.L426:
	movl	$.LC44, %r9d
	movq	httpd_err400form(%rip), %r8
	movl	$400, %esi
	movq	%rbp, %rdi
	movq	httpd_err400title(%rip), %rdx
	movq	%r9, %rcx
	call	httpd_send_err
.L425:
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%r13, %rsi
	movq	%r12, %rdi
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	jmp	finish_connection
	.p2align 4,,10
	.p2align 3
.L405:
	.cfi_restore_state
	cltq
	addq	%rax, 160(%rbp)
	movq	0(%r13), %rax
	movq	%rbp, %rdi
	movq	%rax, 88(%r12)
	call	httpd_got_request
	testl	%eax, %eax
	je	.L401
	cmpl	$2, %eax
	je	.L426
	movq	%rbp, %rdi
	call	httpd_parse_request
	testl	%eax, %eax
	js	.L425
	movq	%r12, %rdi
	call	check_throttles
	testl	%eax, %eax
	je	.L427
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	httpd_start_request
	testl	%eax, %eax
	js	.L425
	movl	528(%rbp), %eax
	testl	%eax, %eax
	je	.L411
	movq	536(%rbp), %rax
	movq	%rax, 136(%r12)
	movq	544(%rbp), %rax
	addq	$1, %rax
	movq	%rax, 128(%r12)
.L412:
	cmpq	$0, 712(%rbp)
	je	.L428
	movq	128(%r12), %rax
	cmpq	%rax, 136(%r12)
	jge	.L425
	movq	0(%r13), %rax
	movl	$2, (%r12)
	movq	$0, 112(%r12)
	movl	704(%rbp), %edi
	movq	%rax, 80(%r12)
	call	fdwatch_del_fd
	movl	704(%rbp), %edi
	movq	%r12, %rsi
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movl	$1, %edx
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	jmp	fdwatch_add_fd
	.p2align 4,,10
	.p2align 3
.L401:
	.cfi_restore_state
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
.L427:
	.cfi_restore_state
	movq	208(%rbp), %r9
	movq	httpd_err503form(%rip), %r8
	movl	$.LC44, %ecx
	movq	%rbp, %rdi
	movq	httpd_err503title(%rip), %rdx
	movl	$503, %esi
	call	httpd_send_err
	jmp	.L425
	.p2align 4,,10
	.p2align 3
.L411:
	movq	192(%rbp), %rax
	movl	$0, %edx
	testq	%rax, %rax
	cmovs	%rdx, %rax
	movq	%rax, 128(%r12)
	jmp	.L412
.L428:
	movl	56(%r12), %eax
	movq	200(%rbp), %rsi
	testl	%eax, %eax
	jle	.L417
	subl	$1, %eax
	movq	throttles(%rip), %rcx
	leaq	16(%r12), %rdx
	leaq	20(%r12,%rax,4), %rdi
	.p2align 4,,10
	.p2align 3
.L416:
	movslq	(%rdx), %rax
	addq	$4, %rdx
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%rsi, 32(%rcx,%rax)
	cmpq	%rdx, %rdi
	jne	.L416
.L417:
	movq	%rsi, 136(%r12)
	jmp	.L425
	.cfi_endproc
.LFE20:
	.size	handle_read, .-handle_read
	.section	.rodata.str1.8
	.align 8
.LC82:
	.string	"%.80s connection timed out reading"
	.align 8
.LC83:
	.string	"%.80s connection timed out sending"
	.text
	.p2align 4
	.type	idle, @function
idle:
.LFB29:
	.cfi_startproc
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L437
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	xorl	%ebx, %ebx
	jmp	.L434
	.p2align 4,,10
	.p2align 3
.L442:
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L432
	movq	(%r12), %rax
	subq	88(%rbp), %rax
	cmpq	$299, %rax
	jg	.L440
.L432:
	addq	$1, %rbx
	cmpl	%ebx, max_connects(%rip)
	jle	.L441
.L434:
	leaq	(%rbx,%rbx,8), %rbp
	salq	$4, %rbp
	addq	connects(%rip), %rbp
	movl	0(%rbp), %eax
	cmpl	$1, %eax
	jne	.L442
	movq	(%r12), %rax
	subq	88(%rbp), %rax
	cmpq	$59, %rax
	jle	.L432
	movq	8(%rbp), %rax
	addq	$1, %rbx
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC82, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	syslog
	movl	$.LC44, %r9d
	movq	8(%rbp), %rdi
	movq	httpd_err408form(%rip), %r8
	movq	httpd_err408title(%rip), %rdx
	movq	%r9, %rcx
	movl	$408, %esi
	call	httpd_send_err
	movq	%r12, %rsi
	movq	%rbp, %rdi
	call	finish_connection
	cmpl	%ebx, max_connects(%rip)
	jg	.L434
.L441:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L440:
	.cfi_restore_state
	movq	8(%rbp), %rax
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC83, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	syslog
	movq	%r12, %rsi
	movq	%rbp, %rdi
	call	clear_connection
	jmp	.L432
	.p2align 4,,10
	.p2align 3
.L437:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	ret
	.cfi_endproc
.LFE29:
	.size	idle, .-idle
	.section	.rodata.str1.8
	.align 8
.LC84:
	.string	"replacing non-null wakeup_timer!"
	.align 8
.LC85:
	.string	"tmr_create(wakeup_connection) failed"
	.section	.rodata.str1.1
.LC86:
	.string	"write - %m sending %.80s"
	.text
	.p2align 4
	.type	handle_send, @function
handle_send:
.LFB21:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movl	$1000000000, %eax
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	64(%rdi), %rcx
	movq	8(%rdi), %rbx
	cmpq	$-1, %rcx
	je	.L444
	testq	%rcx, %rcx
	leaq	3(%rcx), %rdx
	cmovns	%rcx, %rdx
	movq	%rdx, %rax
	sarq	$2, %rax
.L444:
	movq	136(%rbp), %rdx
	movq	128(%rbp), %rdi
	movq	712(%rbx), %rsi
	movq	472(%rbx), %rcx
	subq	%rdx, %rdi
	addq	%rdx, %rsi
	movq	%rdi, %rdx
	cmpq	%rax, %rdi
	movl	704(%rbx), %edi
	cmova	%rax, %rdx
	testq	%rcx, %rcx
	jne	.L445
	call	write
	testl	%eax, %eax
	js	.L497
.L447:
	jne	.L498
.L466:
	addq	$100, 112(%rbp)
	movl	704(%rbx), %edi
	movl	$3, 0(%rbp)
	call	fdwatch_del_fd
	cmpq	$0, 96(%rbp)
	je	.L450
	movl	$.LC84, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L450:
	movq	112(%rbp), %rcx
.L496:
	xorl	%r8d, %r8d
	movq	%rbp, %rdx
	movl	$wakeup_connection, %esi
	movq	%r12, %rdi
	call	tmr_create
	movq	%rax, 96(%rbp)
	testq	%rax, %rax
	je	.L499
.L443:
	addq	$40, %rsp
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
.L445:
	.cfi_restore_state
	movq	368(%rbx), %rax
	movq	%rsi, 16(%rsp)
	movq	%rsp, %rsi
	movq	%rdx, 24(%rsp)
	movl	$2, %edx
	movq	%rax, (%rsp)
	movq	%rcx, 8(%rsp)
	call	writev
	testl	%eax, %eax
	jns	.L447
.L497:
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L443
	cmpl	$11, %eax
	je	.L466
	cmpl	$32, %eax
	setne	%cl
	cmpl	$22, %eax
	setne	%dl
	testb	%dl, %cl
	je	.L451
	cmpl	$104, %eax
	je	.L451
	movq	208(%rbx), %rdx
	movl	$.LC86, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L451:
	movq	%r12, %rsi
	movq	%rbp, %rdi
	call	clear_connection
	addq	$40, %rsp
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
.L498:
	.cfi_restore_state
	movq	(%r12), %rdx
	movslq	%eax, %rsi
	movq	%rdx, 88(%rbp)
	movq	472(%rbx), %rdx
	testq	%rdx, %rdx
	jne	.L453
.L454:
	movq	8(%rbp), %rdx
	movq	136(%rbp), %r9
	movq	200(%rdx), %rax
	addq	%rsi, %r9
	movq	%r9, 136(%rbp)
	addq	%rsi, %rax
	movq	%rax, 200(%rdx)
	movl	56(%rbp), %edx
	testl	%edx, %edx
	jle	.L460
	subl	$1, %edx
	movq	throttles(%rip), %rdi
	leaq	16(%rbp), %rcx
	leaq	20(%rbp,%rdx,4), %r8
	.p2align 4,,10
	.p2align 3
.L459:
	movslq	(%rcx), %rdx
	addq	$4, %rcx
	leaq	(%rdx,%rdx,2), %rdx
	salq	$4, %rdx
	addq	%rsi, 32(%rdi,%rdx)
	cmpq	%rcx, %r8
	jne	.L459
.L460:
	cmpq	128(%rbp), %r9
	jge	.L500
	movq	112(%rbp), %rdx
	cmpq	$100, %rdx
	jg	.L501
.L461:
	movq	64(%rbp), %rcx
	cmpq	$-1, %rcx
	je	.L443
	movq	(%r12), %rdx
	subq	80(%rbp), %rdx
	movq	%rdx, %r13
	je	.L469
	cqto
	idivq	%r13
.L462:
	cmpq	%rax, %rcx
	jge	.L443
	movl	$3, 0(%rbp)
	movl	704(%rbx), %edi
	call	fdwatch_del_fd
	movq	8(%rbp), %rax
	movq	200(%rax), %rax
	cqto
	idivq	64(%rbp)
	movl	%eax, %ebx
	subl	%r13d, %ebx
	cmpq	$0, 96(%rbp)
	je	.L463
	movl	$.LC84, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L463:
	movl	$500, %ecx
	testl	%ebx, %ebx
	jle	.L496
	movslq	%ebx, %rbx
	imulq	$1000, %rbx, %rcx
	jmp	.L496
	.p2align 4,,10
	.p2align 3
.L453:
	cmpq	%rsi, %rdx
	ja	.L502
	movq	$0, 472(%rbx)
	subl	%edx, %eax
	movslq	%eax, %rsi
	jmp	.L454
	.p2align 4,,10
	.p2align 3
.L501:
	subq	$100, %rdx
	movq	%rdx, 112(%rbp)
	jmp	.L461
	.p2align 4,,10
	.p2align 3
.L469:
	movl	$1, %r13d
	jmp	.L462
	.p2align 4,,10
	.p2align 3
.L500:
	movq	%r12, %rsi
	movq	%rbp, %rdi
	call	finish_connection
	jmp	.L443
	.p2align 4,,10
	.p2align 3
.L502:
	subl	%eax, %edx
	movq	368(%rbx), %rdi
	movslq	%edx, %r13
	addq	%rdi, %rsi
	movq	%r13, %rdx
	call	memmove
	movq	%r13, 472(%rbx)
	xorl	%esi, %esi
	jmp	.L454
.L499:
	movl	$2, %edi
	movl	$.LC85, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE21:
	.size	handle_send, .-handle_send
	.p2align 4
	.type	linger_clear_connection, @function
linger_clear_connection:
.LFB31:
	.cfi_startproc
	movq	$0, 104(%rdi)
	jmp	really_clear_connection
	.cfi_endproc
.LFE31:
	.size	linger_clear_connection, .-linger_clear_connection
	.p2align 4
	.type	handle_linger, @function
handle_linger:
.LFB22:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movl	$4096, %edx
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rdi, %rbp
	subq	$4104, %rsp
	.cfi_def_cfa_offset 4128
	movq	8(%rdi), %rax
	movq	%rsp, %rsi
	movl	704(%rax), %edi
	call	read
	testl	%eax, %eax
	js	.L513
	je	.L506
.L504:
	addq	$4104, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L513:
	.cfi_restore_state
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L504
	cmpl	$11, %eax
	je	.L504
.L506:
	movq	%r12, %rsi
	movq	%rbp, %rdi
	call	really_clear_connection
	addq	$4104, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE22:
	.size	handle_linger, .-handle_linger
	.section	.rodata.str1.1
.LC87:
	.string	"%d"
.LC88:
	.string	"getaddrinfo %.80s - %.80s"
.LC89:
	.string	"%s: getaddrinfo %s - %s\n"
	.section	.rodata.str1.8
	.align 8
.LC90:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.text
	.p2align 4
	.type	lookup_hostname.constprop.0, @function
lookup_hostname.constprop.0:
.LFB37:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pxor	%xmm0, %xmm0
	xorl	%eax, %eax
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rdx, %r14
	movl	$.LC87, %edx
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rcx, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rsi, %rbx
	movl	$10, %esi
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movzwl	port(%rip), %ecx
	leaq	22(%rsp), %rdi
	movaps	%xmm0, 32(%rsp)
	movaps	%xmm0, 48(%rsp)
	movl	$1, 32(%rsp)
	movl	$1, 40(%rsp)
	movaps	%xmm0, 64(%rsp)
	call	snprintf
	leaq	8(%rsp), %rcx
	leaq	32(%rsp), %rdx
	movq	hostname(%rip), %rdi
	leaq	22(%rsp), %rsi
	call	getaddrinfo
	testl	%eax, %eax
	jne	.L531
	movq	8(%rsp), %r15
	xorl	%r13d, %r13d
	xorl	%esi, %esi
	movq	%r15, %rax
	testq	%r15, %r15
	jne	.L516
	jmp	.L532
	.p2align 4,,10
	.p2align 3
.L534:
	cmpl	$10, %edx
	jne	.L519
	testq	%rsi, %rsi
	cmove	%rax, %rsi
.L519:
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L533
.L516:
	movl	4(%rax), %edx
	cmpl	$2, %edx
	jne	.L534
	testq	%r13, %r13
	cmove	%rax, %r13
	movq	40(%rax), %rax
	testq	%rax, %rax
	jne	.L516
.L533:
	testq	%rsi, %rsi
	je	.L535
	movl	16(%rsi), %r8d
	cmpq	$128, %r8
	ja	.L530
	movl	$16, %ecx
	movq	%r14, %rdi
	rep stosq
	movq	%r14, %rdi
	movl	16(%rsi), %edx
	movq	24(%rsi), %rsi
	call	memmove
	movl	$1, (%r12)
.L521:
	testq	%r13, %r13
	je	.L517
	movl	16(%r13), %r8d
	cmpq	$128, %r8
	ja	.L530
	xorl	%eax, %eax
	movl	$16, %ecx
	movq	%rbp, %rdi
	rep stosq
	movq	%rbp, %rdi
	movl	16(%r13), %edx
	movq	24(%r13), %rsi
	call	memmove
	movl	$1, (%rbx)
.L524:
	movq	%r15, %rdi
	call	freeaddrinfo
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
.L532:
	.cfi_restore_state
	movl	$0, (%r12)
.L517:
	movl	$0, (%rbx)
	jmp	.L524
.L535:
	movl	$0, (%r12)
	jmp	.L521
.L530:
	movq	hostname(%rip), %rdx
	movl	$2, %edi
	movl	$128, %ecx
	xorl	%eax, %eax
	movl	$.LC90, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L531:
	movl	%eax, %edi
	movl	%eax, %r13d
	call	gai_strerror
	movl	$.LC88, %esi
	movl	$2, %edi
	movq	hostname(%rip), %rdx
	movq	%rax, %rcx
	xorl	%eax, %eax
	call	syslog
	movl	%r13d, %edi
	call	gai_strerror
	movq	stderr(%rip), %rdi
	movl	$.LC89, %esi
	movq	hostname(%rip), %rcx
	movq	argv0(%rip), %rdx
	movq	%rax, %r8
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE37:
	.size	lookup_hostname.constprop.0, .-lookup_hostname.constprop.0
	.section	.rodata.str1.1
.LC91:
	.string	"can't find any valid address"
	.section	.rodata.str1.8
	.align 8
.LC92:
	.string	"%s: can't find any valid address\n"
	.section	.rodata.str1.1
.LC93:
	.string	"unknown user - '%.80s'"
.LC94:
	.string	"%s: unknown user - '%s'\n"
.LC95:
	.string	"/dev/null"
.LC96:
	.string	"-"
	.section	.rodata.str1.8
	.align 8
.LC97:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.align 8
.LC98:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
	.section	.rodata.str1.1
.LC99:
	.string	"fchown logfile - %m"
.LC100:
	.string	"fchown logfile"
.LC101:
	.string	"chdir - %m"
.LC102:
	.string	"chdir"
.LC103:
	.string	"daemon - %m"
.LC104:
	.string	"w"
.LC105:
	.string	"%d\n"
	.section	.rodata.str1.8
	.align 8
.LC106:
	.string	"fdwatch initialization failure"
	.section	.rodata.str1.1
.LC107:
	.string	"chroot - %m"
	.section	.rodata.str1.8
	.align 8
.LC108:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.align 8
.LC109:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
	.section	.rodata.str1.1
.LC110:
	.string	"chroot chdir - %m"
.LC111:
	.string	"chroot chdir"
.LC112:
	.string	"data_dir chdir - %m"
.LC113:
	.string	"data_dir chdir"
.LC114:
	.string	"tmr_create(occasional) failed"
.LC115:
	.string	"tmr_create(idle) failed"
	.section	.rodata.str1.8
	.align 8
.LC116:
	.string	"tmr_create(update_throttles) failed"
	.section	.rodata.str1.1
.LC117:
	.string	"tmr_create(show_stats) failed"
.LC118:
	.string	"setgroups - %m"
.LC119:
	.string	"setgid - %m"
.LC120:
	.string	"initgroups - %m"
.LC121:
	.string	"setuid - %m"
	.section	.rodata.str1.8
	.align 8
.LC122:
	.string	"started as root without requesting chroot(), warning only"
	.align 8
.LC123:
	.string	"out of memory allocating a connecttab"
	.section	.rodata.str1.1
.LC124:
	.string	"fdwatch - %m"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB9:
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
	movl	%edi, %r13d
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
	subq	$4424, %rsp
	.cfi_def_cfa_offset 4480
	movq	(%rsi), %rbp
	movl	$47, %esi
	leaq	48(%rsp), %rbx
	movq	%rbp, %rdi
	movq	%rbp, argv0(%rip)
	call	strrchr
	movl	$9, %esi
	leaq	1(%rax), %rdx
	testq	%rax, %rax
	cmovne	%rdx, %rbp
	movl	$24, %edx
	movq	%rbp, %rdi
	call	openlog
	movq	%r12, %rsi
	movl	%r13d, %edi
	leaq	176(%rsp), %r12
	call	parse_args
	call	tzset
	leaq	28(%rsp), %rcx
	movq	%r12, %rdx
	movq	%rbx, %rdi
	leaq	24(%rsp), %rsi
	call	lookup_hostname.constprop.0
	movl	24(%rsp), %eax
	orl	28(%rsp), %eax
	je	.L667
	movq	throttlefile(%rip), %rdi
	movl	$0, numthrottles(%rip)
	movl	$0, maxthrottles(%rip)
	movq	$0, throttles(%rip)
	testq	%rdi, %rdi
	je	.L539
	call	read_throttlefile
.L539:
	call	getuid
	movl	$32767, %r14d
	movl	$32767, %r15d
	testl	%eax, %eax
	je	.L668
.L540:
	movq	logfile(%rip), %rbp
	testq	%rbp, %rbp
	je	.L542
	movl	$.LC95, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L543
	movl	$1, no_log(%rip)
	xorl	%ebp, %ebp
.L542:
	movq	dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L548
	call	chdir
	testl	%eax, %eax
	js	.L669
.L548:
	leaq	304(%rsp), %r13
	movl	$4096, %esi
	movq	%r13, %rdi
	call	getcwd
	orq	$-1, %rcx
	xorl	%eax, %eax
	movq	%r13, %rdi
	repnz scasb
	notq	%rcx
	cmpb	$47, 302(%rsp,%rcx)
	jne	.L670
.L549:
	cmpl	$0, debug(%rip)
	je	.L671
	call	setsid
.L552:
	movq	pidfile(%rip), %rdi
	testq	%rdi, %rdi
	je	.L553
	movl	$.LC104, %esi
	call	fopen
	testq	%rax, %rax
	je	.L672
	movq	%rax, (%rsp)
	call	getpid
	movq	(%rsp), %rdi
	movl	$.LC105, %esi
	movl	%eax, %edx
	xorl	%eax, %eax
	call	fprintf
	movq	(%rsp), %rdi
	call	fclose
.L553:
	call	fdwatch_get_nfiles
	movl	%eax, max_connects(%rip)
	testl	%eax, %eax
	js	.L673
	subl	$10, %eax
	cmpl	$0, do_chroot(%rip)
	movl	%eax, max_connects(%rip)
	jne	.L674
.L556:
	movq	data_dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L560
	call	chdir
	testl	%eax, %eax
	js	.L675
.L560:
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
	movl	no_empty_referers(%rip), %eax
	xorl	%esi, %esi
	movq	%r12, %rdx
	cmpl	$0, 28(%rsp)
	movzwl	port(%rip), %ecx
	cmove	%rsi, %rdx
	cmpl	$0, 24(%rsp)
	pushq	%rax
	.cfi_def_cfa_offset 4488
	movl	do_global_passwd(%rip), %eax
	pushq	local_pattern(%rip)
	.cfi_def_cfa_offset 4496
	cmovne	%rbx, %rsi
	movl	cgi_limit(%rip), %r9d
	pushq	url_pattern(%rip)
	.cfi_def_cfa_offset 4504
	movq	cgi_pattern(%rip), %r8
	pushq	%rax
	.cfi_def_cfa_offset 4512
	movl	do_vhost(%rip), %eax
	movq	hostname(%rip), %rdi
	pushq	%rax
	.cfi_def_cfa_offset 4520
	movl	no_symlink_check(%rip), %eax
	pushq	%rax
	.cfi_def_cfa_offset 4528
	movl	no_log(%rip), %eax
	pushq	%rbp
	.cfi_def_cfa_offset 4536
	pushq	%rax
	.cfi_def_cfa_offset 4544
	movl	max_age(%rip), %eax
	pushq	%r13
	.cfi_def_cfa_offset 4552
	pushq	%rax
	.cfi_def_cfa_offset 4560
	pushq	p3p(%rip)
	.cfi_def_cfa_offset 4568
	pushq	charset(%rip)
	.cfi_def_cfa_offset 4576
	call	httpd_initialize
	addq	$96, %rsp
	.cfi_def_cfa_offset 4480
	movq	%rax, hs(%rip)
	testq	%rax, %rax
	je	.L666
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$120000, %ecx
	movl	$occasional, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L676
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$5000, %ecx
	movl	$idle, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L677
	cmpl	$0, numthrottles(%rip)
	jle	.L566
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$2000, %ecx
	movl	$update_throttles, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L678
.L566:
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$3600000, %ecx
	movl	$show_stats, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L679
	xorl	%edi, %edi
	call	time
	movq	$0, stats_connections(%rip)
	movq	%rax, stats_time(%rip)
	movq	%rax, start_time(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	call	getuid
	testl	%eax, %eax
	jne	.L569
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	setgroups
	movl	$.LC118, %esi
	testl	%eax, %eax
	js	.L665
	movl	%r14d, %edi
	call	setgid
	movl	$.LC119, %esi
	testl	%eax, %eax
	js	.L665
	movq	user(%rip), %rdi
	movl	%r14d, %esi
	call	initgroups
	testl	%eax, %eax
	js	.L680
.L572:
	movl	%r15d, %edi
	call	setuid
	movl	$.LC121, %esi
	testl	%eax, %eax
	js	.L665
	cmpl	$0, do_chroot(%rip)
	jne	.L569
	movl	$.LC122, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
.L569:
	movslq	max_connects(%rip), %rbp
	movq	%rbp, %rbx
	imulq	$144, %rbp, %rbp
	movq	%rbp, %rdi
	call	malloc
	movq	%rax, connects(%rip)
	testq	%rax, %rax
	je	.L575
	movq	%rax, %rdx
	xorl	%ecx, %ecx
	jmp	.L576
.L577:
	addl	$1, %ecx
	movl	$0, (%rdx)
	addq	$144, %rdx
	movl	%ecx, -140(%rdx)
	movq	$0, -136(%rdx)
.L576:
	cmpl	%ecx, %ebx
	jg	.L577
	movl	$-1, -140(%rax,%rbp)
	movq	hs(%rip), %rax
	movl	$0, first_free_connect(%rip)
	movl	$0, num_connects(%rip)
	movl	$0, httpd_conn_count(%rip)
	testq	%rax, %rax
	je	.L579
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L580
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
	movq	hs(%rip), %rax
.L580:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L579
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
.L579:
	leaq	32(%rsp), %rdi
	call	tmr_prepare_timeval
.L582:
	cmpl	$0, terminate(%rip)
	je	.L604
	cmpl	$0, num_connects(%rip)
	jle	.L681
.L604:
	movl	got_hup(%rip), %eax
	testl	%eax, %eax
	jne	.L682
.L583:
	leaq	32(%rsp), %rdi
	call	tmr_mstimeout
	movq	%rax, %rdi
	call	fdwatch
	movl	%eax, %ebx
	testl	%eax, %eax
	jns	.L584
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L582
	cmpl	$11, %eax
	je	.L582
	movl	$3, %edi
	movl	$.LC124, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L671:
	movq	stdin(%rip), %rdi
	call	fclose
	movq	stdout(%rip), %rdi
	cmpq	%rbp, %rdi
	je	.L551
	call	fclose
.L551:
	movq	stderr(%rip), %rdi
	call	fclose
	movl	$1, %esi
	movl	$1, %edi
	call	daemon
	movl	$.LC103, %esi
	testl	%eax, %eax
	jns	.L552
.L665:
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
.L666:
	movl	$1, %edi
	call	exit
.L670:
	movw	$47, -1(%r13,%rcx)
	jmp	.L549
.L543:
	movl	$.LC96, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L544
	movq	stdout(%rip), %rbp
	jmp	.L542
.L668:
	movq	user(%rip), %rdi
	call	getpwnam
	testq	%rax, %rax
	je	.L683
	movl	16(%rax), %r15d
	movl	20(%rax), %r14d
	jmp	.L540
.L669:
	movl	$.LC101, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC102, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L544:
	movq	%rbp, %rdi
	movl	$.LC72, %esi
	call	fopen
	movq	logfile(%rip), %r13
	movl	$384, %esi
	movq	%rax, %rbp
	movq	%r13, %rdi
	call	chmod
	testq	%rbp, %rbp
	je	.L608
	testl	%eax, %eax
	jne	.L608
	cmpb	$47, 0(%r13)
	jne	.L684
.L547:
	movq	%rbp, %rdi
	call	fileno
	movl	$1, %edx
	movl	$2, %esi
	movl	%eax, %edi
	xorl	%eax, %eax
	call	fcntl
	call	getuid
	testl	%eax, %eax
	jne	.L542
	movq	%rbp, %rdi
	call	fileno
	movl	%r14d, %edx
	movl	%r15d, %esi
	movl	%eax, %edi
	call	fchown
	testl	%eax, %eax
	jns	.L542
	movl	$.LC99, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC100, %edi
	call	perror
	jmp	.L542
.L667:
	movl	$.LC91, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	xorl	%eax, %eax
	movl	$.LC92, %esi
	call	fprintf
	movl	$1, %edi
	call	exit
.L672:
	movq	pidfile(%rip), %rdx
	movl	$2, %edi
	movl	$.LC63, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L673:
	movl	$.LC106, %esi
	jmp	.L665
.L674:
	movq	%r13, %rdi
	call	chroot
	testl	%eax, %eax
	js	.L685
	movq	logfile(%rip), %r8
	testq	%r8, %r8
	je	.L558
	movl	$.LC96, %esi
	movq	%r8, %rdi
	movq	%r8, (%rsp)
	call	strcmp
	testl	%eax, %eax
	je	.L558
	orq	$-1, %rcx
	xorl	%eax, %eax
	movq	%r13, %rdi
	movq	(%rsp), %r8
	repnz scasb
	movq	%r13, %rsi
	movq	%r8, %rdi
	notq	%rcx
	leaq	-1(%rcx), %rdx
	movq	%rcx, 8(%rsp)
	call	strncmp
	testl	%eax, %eax
	jne	.L559
	movq	(%rsp), %r8
	movq	8(%rsp), %rcx
	movq	%r8, %rdi
	leaq	-2(%r8,%rcx), %rsi
	call	strcpy
.L558:
	movw	$47, 304(%rsp)
	movq	%r13, %rdi
	call	chdir
	testl	%eax, %eax
	jns	.L556
	movl	$.LC110, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC111, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L675:
	movl	$.LC112, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC113, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L684:
	xorl	%eax, %eax
	movl	$.LC97, %esi
	movl	$4, %edi
	call	syslog
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	movl	$.LC98, %esi
	call	fprintf
	jmp	.L547
.L678:
	movl	$2, %edi
	movl	$.LC116, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L683:
	movq	user(%rip), %rdx
	movl	$.LC93, %esi
	movl	$2, %edi
	call	syslog
	movq	stderr(%rip), %rdi
	movl	$.LC94, %esi
	xorl	%eax, %eax
	movq	user(%rip), %rcx
	movq	argv0(%rip), %rdx
	call	fprintf
	movl	$1, %edi
	call	exit
.L676:
	movl	$2, %edi
	movl	$.LC114, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L584:
	leaq	32(%rsp), %rdi
	call	tmr_prepare_timeval
	testl	%ebx, %ebx
	je	.L686
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L596
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L591
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L592
.L595:
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L596
.L591:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L596
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L596
	movq	hs(%rip), %rax
	leaq	32(%rsp), %rdi
	movl	72(%rax), %esi
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L582
.L596:
	call	fdwatch_get_next_client_data
	movq	%rax, %rbp
	cmpq	$-1, %rax
	je	.L687
	testq	%rbp, %rbp
	je	.L596
	movq	8(%rbp), %rax
	movl	704(%rax), %edi
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L688
	movl	0(%rbp), %eax
	cmpl	$2, %eax
	je	.L599
	cmpl	$4, %eax
	je	.L600
	subl	$1, %eax
	jne	.L596
	leaq	32(%rsp), %rsi
	movq	%rbp, %rdi
	call	handle_read
	jmp	.L596
.L688:
	leaq	32(%rsp), %rsi
	movq	%rbp, %rdi
	call	clear_connection
	jmp	.L596
.L682:
	call	re_open_logfile
	movl	$0, got_hup(%rip)
	jmp	.L583
.L608:
	movq	%r13, %rdx
	movl	$.LC63, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movq	logfile(%rip), %rdi
	call	perror
	movl	$1, %edi
	call	exit
.L687:
	leaq	32(%rsp), %rdi
	call	tmr_run
	movl	got_usr1(%rip), %eax
	testl	%eax, %eax
	je	.L582
	cmpl	$0, terminate(%rip)
	jne	.L582
	movq	hs(%rip), %rax
	movl	$1, terminate(%rip)
	testq	%rax, %rax
	je	.L582
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L602
	call	fdwatch_del_fd
	movq	hs(%rip), %rax
.L602:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L603
	call	fdwatch_del_fd
.L603:
	movq	hs(%rip), %rdi
	call	httpd_unlisten
	jmp	.L582
.L600:
	leaq	32(%rsp), %rsi
	movq	%rbp, %rdi
	call	handle_linger
	jmp	.L596
.L599:
	leaq	32(%rsp), %rsi
	movq	%rbp, %rdi
	call	handle_send
	jmp	.L596
.L685:
	movl	$.LC107, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC17, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L679:
	movl	$2, %edi
	movl	$.LC117, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L677:
	movl	$2, %edi
	movl	$.LC115, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L559:
	xorl	%eax, %eax
	movl	$.LC108, %esi
	movl	$4, %edi
	call	syslog
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	movl	$.LC109, %esi
	call	fprintf
	jmp	.L558
.L686:
	leaq	32(%rsp), %rdi
	call	tmr_run
	jmp	.L582
.L592:
	movq	hs(%rip), %rax
	leaq	32(%rsp), %rdi
	movl	76(%rax), %esi
	call	handle_newconnect
	testl	%eax, %eax
	je	.L595
	jmp	.L582
.L681:
	call	shut_down
	movl	$5, %edi
	movl	$.LC78, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	xorl	%edi, %edi
	call	exit
.L680:
	movl	$.LC120, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L572
.L575:
	movl	$.LC123, %esi
	jmp	.L665
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.local	watchdog_flag
	.comm	watchdog_flag,4,4
	.local	got_usr1
	.comm	got_usr1,4,4
	.local	got_hup
	.comm	got_hup,4,4
	.comm	stats_simultaneous,4,4
	.comm	stats_bytes,8,8
	.comm	stats_connections,8,8
	.comm	stats_time,8,8
	.comm	start_time,8,8
	.globl	terminate
	.bss
	.align 4
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	4
	.local	hs
	.comm	hs,8,8
	.local	httpd_conn_count
	.comm	httpd_conn_count,4,4
	.local	first_free_connect
	.comm	first_free_connect,4,4
	.local	max_connects
	.comm	max_connects,4,4
	.local	num_connects
	.comm	num_connects,4,4
	.local	connects
	.comm	connects,8,8
	.local	maxthrottles
	.comm	maxthrottles,4,4
	.local	numthrottles
	.comm	numthrottles,4,4
	.local	throttles
	.comm	throttles,8,8
	.local	max_age
	.comm	max_age,4,4
	.local	p3p
	.comm	p3p,8,8
	.local	charset
	.comm	charset,8,8
	.local	user
	.comm	user,8,8
	.local	pidfile
	.comm	pidfile,8,8
	.local	hostname
	.comm	hostname,8,8
	.local	throttlefile
	.comm	throttlefile,8,8
	.local	logfile
	.comm	logfile,8,8
	.local	local_pattern
	.comm	local_pattern,8,8
	.local	no_empty_referers
	.comm	no_empty_referers,4,4
	.local	url_pattern
	.comm	url_pattern,8,8
	.local	cgi_limit
	.comm	cgi_limit,4,4
	.local	cgi_pattern
	.comm	cgi_pattern,8,8
	.local	do_global_passwd
	.comm	do_global_passwd,4,4
	.local	do_vhost
	.comm	do_vhost,4,4
	.local	no_symlink_check
	.comm	no_symlink_check,4,4
	.local	no_log
	.comm	no_log,4,4
	.local	do_chroot
	.comm	do_chroot,4,4
	.local	data_dir
	.comm	data_dir,8,8
	.local	dir
	.comm	dir,8,8
	.local	port
	.comm	port,2,2
	.local	debug
	.comm	debug,4,4
	.local	argv0
	.comm	argv0,8,8
	.ident	"GCC: (GNU) 9.2.0"
	.section	.note.GNU-stack,"",@progbits
