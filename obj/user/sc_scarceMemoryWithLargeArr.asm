
obj/user/sc_scarceMemoryWithLargeArr:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 70 00 00 00       	call   8000a6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

//char Elements[102400*PAGE_SIZE];
char Elements[25600*PAGE_SIZE];
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	/*[1] CREATE LARGE ARRAY THAT SCARCE MEMORY*/
	env_sleep(500000);
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 20 a1 07 00       	push   $0x7a120
  800046:	e8 c6 1c 00 00       	call   801d11 <env_sleep>
  80004b:	83 c4 10             	add    $0x10,%esp
	uint32 required_size = sizeof(int) * 3;
  80004e:	c7 45 f0 0c 00 00 00 	movl   $0xc,-0x10(%ebp)
	uint32 *Elements2 = malloc(required_size) ;
  800055:	83 ec 0c             	sub    $0xc,%esp
  800058:	ff 75 f0             	pushl  -0x10(%ebp)
  80005b:	e8 e9 0f 00 00       	call   801049 <malloc>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	89 45 ec             	mov    %eax,-0x14(%ebp)
//
//	for(uint32 i = 0; i < 13500*PAGE_SIZE; i+=PAGE_SIZE)
//	{
//		Elements[i] = 0;
//	}
	for(uint32 i = 0; i < required_size; i+=PAGE_SIZE)
  800066:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80006d:	eb 1c                	jmp    80008b <_main+0x53>
	{
		Elements2[i] = 0;
  80006f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800072:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80007c:	01 d0                	add    %edx,%eax
  80007e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
//
//	for(uint32 i = 0; i < 13500*PAGE_SIZE; i+=PAGE_SIZE)
//	{
//		Elements[i] = 0;
//	}
	for(uint32 i = 0; i < required_size; i+=PAGE_SIZE)
  800084:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80008b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80008e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800091:	72 dc                	jb     80006f <_main+0x37>
	{
		Elements2[i] = 0;
	}

	cprintf("Congratulations!! Scenario of Handling SCARCE MEM is completed successfully!!\n\n\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 00 22 80 00       	push   $0x802200
  80009b:	e8 1f 02 00 00       	call   8002bf <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp

	return;
  8000a3:	90                   	nop
}
  8000a4:	c9                   	leave  
  8000a5:	c3                   	ret    

008000a6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000ac:	e8 a4 16 00 00       	call   801755 <sys_getenvindex>
  8000b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000b7:	89 d0                	mov    %edx,%eax
  8000b9:	c1 e0 03             	shl    $0x3,%eax
  8000bc:	01 d0                	add    %edx,%eax
  8000be:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000c5:	01 c8                	add    %ecx,%eax
  8000c7:	01 c0                	add    %eax,%eax
  8000c9:	01 d0                	add    %edx,%eax
  8000cb:	01 c0                	add    %eax,%eax
  8000cd:	01 d0                	add    %edx,%eax
  8000cf:	89 c2                	mov    %eax,%edx
  8000d1:	c1 e2 05             	shl    $0x5,%edx
  8000d4:	29 c2                	sub    %eax,%edx
  8000d6:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8000dd:	89 c2                	mov    %eax,%edx
  8000df:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000e5:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ef:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8000f5:	84 c0                	test   %al,%al
  8000f7:	74 0f                	je     800108 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8000f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fe:	05 40 3c 01 00       	add    $0x13c40,%eax
  800103:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800108:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80010c:	7e 0a                	jle    800118 <libmain+0x72>
		binaryname = argv[0];
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	8b 00                	mov    (%eax),%eax
  800113:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	ff 75 0c             	pushl  0xc(%ebp)
  80011e:	ff 75 08             	pushl  0x8(%ebp)
  800121:	e8 12 ff ff ff       	call   800038 <_main>
  800126:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800129:	e8 c2 17 00 00       	call   8018f0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	68 6c 22 80 00       	push   $0x80226c
  800136:	e8 84 01 00 00       	call   8002bf <cprintf>
  80013b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80013e:	a1 20 30 80 00       	mov    0x803020,%eax
  800143:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800149:	a1 20 30 80 00       	mov    0x803020,%eax
  80014e:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	52                   	push   %edx
  800158:	50                   	push   %eax
  800159:	68 94 22 80 00       	push   $0x802294
  80015e:	e8 5c 01 00 00       	call   8002bf <cprintf>
  800163:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800166:	a1 20 30 80 00       	mov    0x803020,%eax
  80016b:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800171:	a1 20 30 80 00       	mov    0x803020,%eax
  800176:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80017c:	83 ec 04             	sub    $0x4,%esp
  80017f:	52                   	push   %edx
  800180:	50                   	push   %eax
  800181:	68 bc 22 80 00       	push   $0x8022bc
  800186:	e8 34 01 00 00       	call   8002bf <cprintf>
  80018b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80018e:	a1 20 30 80 00       	mov    0x803020,%eax
  800193:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800199:	83 ec 08             	sub    $0x8,%esp
  80019c:	50                   	push   %eax
  80019d:	68 fd 22 80 00       	push   $0x8022fd
  8001a2:	e8 18 01 00 00       	call   8002bf <cprintf>
  8001a7:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	68 6c 22 80 00       	push   $0x80226c
  8001b2:	e8 08 01 00 00       	call   8002bf <cprintf>
  8001b7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ba:	e8 4b 17 00 00       	call   80190a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001bf:	e8 19 00 00 00       	call   8001dd <exit>
}
  8001c4:	90                   	nop
  8001c5:	c9                   	leave  
  8001c6:	c3                   	ret    

008001c7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	6a 00                	push   $0x0
  8001d2:	e8 4a 15 00 00       	call   801721 <sys_env_destroy>
  8001d7:	83 c4 10             	add    $0x10,%esp
}
  8001da:	90                   	nop
  8001db:	c9                   	leave  
  8001dc:	c3                   	ret    

008001dd <exit>:

void
exit(void)
{
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8001e3:	e8 9f 15 00 00       	call   801787 <sys_env_exit>
}
  8001e8:	90                   	nop
  8001e9:	c9                   	leave  
  8001ea:	c3                   	ret    

008001eb <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f4:	8b 00                	mov    (%eax),%eax
  8001f6:	8d 48 01             	lea    0x1(%eax),%ecx
  8001f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001fc:	89 0a                	mov    %ecx,(%edx)
  8001fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800201:	88 d1                	mov    %dl,%cl
  800203:	8b 55 0c             	mov    0xc(%ebp),%edx
  800206:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80020a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020d:	8b 00                	mov    (%eax),%eax
  80020f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800214:	75 2c                	jne    800242 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800216:	a0 24 30 80 00       	mov    0x803024,%al
  80021b:	0f b6 c0             	movzbl %al,%eax
  80021e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800221:	8b 12                	mov    (%edx),%edx
  800223:	89 d1                	mov    %edx,%ecx
  800225:	8b 55 0c             	mov    0xc(%ebp),%edx
  800228:	83 c2 08             	add    $0x8,%edx
  80022b:	83 ec 04             	sub    $0x4,%esp
  80022e:	50                   	push   %eax
  80022f:	51                   	push   %ecx
  800230:	52                   	push   %edx
  800231:	e8 a9 14 00 00       	call   8016df <sys_cputs>
  800236:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800242:	8b 45 0c             	mov    0xc(%ebp),%eax
  800245:	8b 40 04             	mov    0x4(%eax),%eax
  800248:	8d 50 01             	lea    0x1(%eax),%edx
  80024b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800251:	90                   	nop
  800252:	c9                   	leave  
  800253:	c3                   	ret    

00800254 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80025d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800264:	00 00 00 
	b.cnt = 0;
  800267:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80026e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800271:	ff 75 0c             	pushl  0xc(%ebp)
  800274:	ff 75 08             	pushl  0x8(%ebp)
  800277:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80027d:	50                   	push   %eax
  80027e:	68 eb 01 80 00       	push   $0x8001eb
  800283:	e8 11 02 00 00       	call   800499 <vprintfmt>
  800288:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80028b:	a0 24 30 80 00       	mov    0x803024,%al
  800290:	0f b6 c0             	movzbl %al,%eax
  800293:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	50                   	push   %eax
  80029d:	52                   	push   %edx
  80029e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a4:	83 c0 08             	add    $0x8,%eax
  8002a7:	50                   	push   %eax
  8002a8:	e8 32 14 00 00       	call   8016df <sys_cputs>
  8002ad:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002b0:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002b7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002bd:	c9                   	leave  
  8002be:	c3                   	ret    

008002bf <cprintf>:

int cprintf(const char *fmt, ...) {
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002c5:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8002cc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d5:	83 ec 08             	sub    $0x8,%esp
  8002d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002db:	50                   	push   %eax
  8002dc:	e8 73 ff ff ff       	call   800254 <vcprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
  8002e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002ea:	c9                   	leave  
  8002eb:	c3                   	ret    

008002ec <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002f2:	e8 f9 15 00 00       	call   8018f0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002f7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	ff 75 f4             	pushl  -0xc(%ebp)
  800306:	50                   	push   %eax
  800307:	e8 48 ff ff ff       	call   800254 <vcprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
  80030f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800312:	e8 f3 15 00 00       	call   80190a <sys_enable_interrupt>
	return cnt;
  800317:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80031a:	c9                   	leave  
  80031b:	c3                   	ret    

0080031c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	53                   	push   %ebx
  800320:	83 ec 14             	sub    $0x14,%esp
  800323:	8b 45 10             	mov    0x10(%ebp),%eax
  800326:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800329:	8b 45 14             	mov    0x14(%ebp),%eax
  80032c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80032f:	8b 45 18             	mov    0x18(%ebp),%eax
  800332:	ba 00 00 00 00       	mov    $0x0,%edx
  800337:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80033a:	77 55                	ja     800391 <printnum+0x75>
  80033c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80033f:	72 05                	jb     800346 <printnum+0x2a>
  800341:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800344:	77 4b                	ja     800391 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800346:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800349:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80034c:	8b 45 18             	mov    0x18(%ebp),%eax
  80034f:	ba 00 00 00 00       	mov    $0x0,%edx
  800354:	52                   	push   %edx
  800355:	50                   	push   %eax
  800356:	ff 75 f4             	pushl  -0xc(%ebp)
  800359:	ff 75 f0             	pushl  -0x10(%ebp)
  80035c:	e8 33 1c 00 00       	call   801f94 <__udivdi3>
  800361:	83 c4 10             	add    $0x10,%esp
  800364:	83 ec 04             	sub    $0x4,%esp
  800367:	ff 75 20             	pushl  0x20(%ebp)
  80036a:	53                   	push   %ebx
  80036b:	ff 75 18             	pushl  0x18(%ebp)
  80036e:	52                   	push   %edx
  80036f:	50                   	push   %eax
  800370:	ff 75 0c             	pushl  0xc(%ebp)
  800373:	ff 75 08             	pushl  0x8(%ebp)
  800376:	e8 a1 ff ff ff       	call   80031c <printnum>
  80037b:	83 c4 20             	add    $0x20,%esp
  80037e:	eb 1a                	jmp    80039a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800380:	83 ec 08             	sub    $0x8,%esp
  800383:	ff 75 0c             	pushl  0xc(%ebp)
  800386:	ff 75 20             	pushl  0x20(%ebp)
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	ff d0                	call   *%eax
  80038e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800391:	ff 4d 1c             	decl   0x1c(%ebp)
  800394:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800398:	7f e6                	jg     800380 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80039d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003a8:	53                   	push   %ebx
  8003a9:	51                   	push   %ecx
  8003aa:	52                   	push   %edx
  8003ab:	50                   	push   %eax
  8003ac:	e8 f3 1c 00 00       	call   8020a4 <__umoddi3>
  8003b1:	83 c4 10             	add    $0x10,%esp
  8003b4:	05 34 25 80 00       	add    $0x802534,%eax
  8003b9:	8a 00                	mov    (%eax),%al
  8003bb:	0f be c0             	movsbl %al,%eax
  8003be:	83 ec 08             	sub    $0x8,%esp
  8003c1:	ff 75 0c             	pushl  0xc(%ebp)
  8003c4:	50                   	push   %eax
  8003c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c8:	ff d0                	call   *%eax
  8003ca:	83 c4 10             	add    $0x10,%esp
}
  8003cd:	90                   	nop
  8003ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003da:	7e 1c                	jle    8003f8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003df:	8b 00                	mov    (%eax),%eax
  8003e1:	8d 50 08             	lea    0x8(%eax),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	89 10                	mov    %edx,(%eax)
  8003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ec:	8b 00                	mov    (%eax),%eax
  8003ee:	83 e8 08             	sub    $0x8,%eax
  8003f1:	8b 50 04             	mov    0x4(%eax),%edx
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	eb 40                	jmp    800438 <getuint+0x65>
	else if (lflag)
  8003f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003fc:	74 1e                	je     80041c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	8b 00                	mov    (%eax),%eax
  800403:	8d 50 04             	lea    0x4(%eax),%edx
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	89 10                	mov    %edx,(%eax)
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	83 e8 04             	sub    $0x4,%eax
  800413:	8b 00                	mov    (%eax),%eax
  800415:	ba 00 00 00 00       	mov    $0x0,%edx
  80041a:	eb 1c                	jmp    800438 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	8d 50 04             	lea    0x4(%eax),%edx
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	89 10                	mov    %edx,(%eax)
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	83 e8 04             	sub    $0x4,%eax
  800431:	8b 00                	mov    (%eax),%eax
  800433:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800438:	5d                   	pop    %ebp
  800439:	c3                   	ret    

0080043a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80043d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800441:	7e 1c                	jle    80045f <getint+0x25>
		return va_arg(*ap, long long);
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	8d 50 08             	lea    0x8(%eax),%edx
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	89 10                	mov    %edx,(%eax)
  800450:	8b 45 08             	mov    0x8(%ebp),%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	83 e8 08             	sub    $0x8,%eax
  800458:	8b 50 04             	mov    0x4(%eax),%edx
  80045b:	8b 00                	mov    (%eax),%eax
  80045d:	eb 38                	jmp    800497 <getint+0x5d>
	else if (lflag)
  80045f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800463:	74 1a                	je     80047f <getint+0x45>
		return va_arg(*ap, long);
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 50 04             	lea    0x4(%eax),%edx
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	89 10                	mov    %edx,(%eax)
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	83 e8 04             	sub    $0x4,%eax
  80047a:	8b 00                	mov    (%eax),%eax
  80047c:	99                   	cltd   
  80047d:	eb 18                	jmp    800497 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	8b 00                	mov    (%eax),%eax
  800484:	8d 50 04             	lea    0x4(%eax),%edx
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	89 10                	mov    %edx,(%eax)
  80048c:	8b 45 08             	mov    0x8(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	83 e8 04             	sub    $0x4,%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	99                   	cltd   
}
  800497:	5d                   	pop    %ebp
  800498:	c3                   	ret    

00800499 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	56                   	push   %esi
  80049d:	53                   	push   %ebx
  80049e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a1:	eb 17                	jmp    8004ba <vprintfmt+0x21>
			if (ch == '\0')
  8004a3:	85 db                	test   %ebx,%ebx
  8004a5:	0f 84 af 03 00 00    	je     80085a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	ff 75 0c             	pushl  0xc(%ebp)
  8004b1:	53                   	push   %ebx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	ff d0                	call   *%eax
  8004b7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bd:	8d 50 01             	lea    0x1(%eax),%edx
  8004c0:	89 55 10             	mov    %edx,0x10(%ebp)
  8004c3:	8a 00                	mov    (%eax),%al
  8004c5:	0f b6 d8             	movzbl %al,%ebx
  8004c8:	83 fb 25             	cmp    $0x25,%ebx
  8004cb:	75 d6                	jne    8004a3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004cd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004d1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004d8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004df:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004e6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f0:	8d 50 01             	lea    0x1(%eax),%edx
  8004f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f6:	8a 00                	mov    (%eax),%al
  8004f8:	0f b6 d8             	movzbl %al,%ebx
  8004fb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004fe:	83 f8 55             	cmp    $0x55,%eax
  800501:	0f 87 2b 03 00 00    	ja     800832 <vprintfmt+0x399>
  800507:	8b 04 85 58 25 80 00 	mov    0x802558(,%eax,4),%eax
  80050e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800510:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800514:	eb d7                	jmp    8004ed <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800516:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80051a:	eb d1                	jmp    8004ed <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80051c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800523:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	01 c0                	add    %eax,%eax
  80052f:	01 d8                	add    %ebx,%eax
  800531:	83 e8 30             	sub    $0x30,%eax
  800534:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800537:	8b 45 10             	mov    0x10(%ebp),%eax
  80053a:	8a 00                	mov    (%eax),%al
  80053c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80053f:	83 fb 2f             	cmp    $0x2f,%ebx
  800542:	7e 3e                	jle    800582 <vprintfmt+0xe9>
  800544:	83 fb 39             	cmp    $0x39,%ebx
  800547:	7f 39                	jg     800582 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800549:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80054c:	eb d5                	jmp    800523 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80054e:	8b 45 14             	mov    0x14(%ebp),%eax
  800551:	83 c0 04             	add    $0x4,%eax
  800554:	89 45 14             	mov    %eax,0x14(%ebp)
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	83 e8 04             	sub    $0x4,%eax
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800562:	eb 1f                	jmp    800583 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800564:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800568:	79 83                	jns    8004ed <vprintfmt+0x54>
				width = 0;
  80056a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800571:	e9 77 ff ff ff       	jmp    8004ed <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800576:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80057d:	e9 6b ff ff ff       	jmp    8004ed <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800582:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800583:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800587:	0f 89 60 ff ff ff    	jns    8004ed <vprintfmt+0x54>
				width = precision, precision = -1;
  80058d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800593:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80059a:	e9 4e ff ff ff       	jmp    8004ed <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80059f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005a2:	e9 46 ff ff ff       	jmp    8004ed <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	83 c0 04             	add    $0x4,%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b3:	83 e8 04             	sub    $0x4,%eax
  8005b6:	8b 00                	mov    (%eax),%eax
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	ff 75 0c             	pushl  0xc(%ebp)
  8005be:	50                   	push   %eax
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	ff d0                	call   *%eax
  8005c4:	83 c4 10             	add    $0x10,%esp
			break;
  8005c7:	e9 89 02 00 00       	jmp    800855 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	83 c0 04             	add    $0x4,%eax
  8005d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	83 e8 04             	sub    $0x4,%eax
  8005db:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005dd:	85 db                	test   %ebx,%ebx
  8005df:	79 02                	jns    8005e3 <vprintfmt+0x14a>
				err = -err;
  8005e1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005e3:	83 fb 64             	cmp    $0x64,%ebx
  8005e6:	7f 0b                	jg     8005f3 <vprintfmt+0x15a>
  8005e8:	8b 34 9d a0 23 80 00 	mov    0x8023a0(,%ebx,4),%esi
  8005ef:	85 f6                	test   %esi,%esi
  8005f1:	75 19                	jne    80060c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005f3:	53                   	push   %ebx
  8005f4:	68 45 25 80 00       	push   $0x802545
  8005f9:	ff 75 0c             	pushl  0xc(%ebp)
  8005fc:	ff 75 08             	pushl  0x8(%ebp)
  8005ff:	e8 5e 02 00 00       	call   800862 <printfmt>
  800604:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800607:	e9 49 02 00 00       	jmp    800855 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80060c:	56                   	push   %esi
  80060d:	68 4e 25 80 00       	push   $0x80254e
  800612:	ff 75 0c             	pushl  0xc(%ebp)
  800615:	ff 75 08             	pushl  0x8(%ebp)
  800618:	e8 45 02 00 00       	call   800862 <printfmt>
  80061d:	83 c4 10             	add    $0x10,%esp
			break;
  800620:	e9 30 02 00 00       	jmp    800855 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	83 c0 04             	add    $0x4,%eax
  80062b:	89 45 14             	mov    %eax,0x14(%ebp)
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	83 e8 04             	sub    $0x4,%eax
  800634:	8b 30                	mov    (%eax),%esi
  800636:	85 f6                	test   %esi,%esi
  800638:	75 05                	jne    80063f <vprintfmt+0x1a6>
				p = "(null)";
  80063a:	be 51 25 80 00       	mov    $0x802551,%esi
			if (width > 0 && padc != '-')
  80063f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800643:	7e 6d                	jle    8006b2 <vprintfmt+0x219>
  800645:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800649:	74 67                	je     8006b2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80064b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064e:	83 ec 08             	sub    $0x8,%esp
  800651:	50                   	push   %eax
  800652:	56                   	push   %esi
  800653:	e8 0c 03 00 00       	call   800964 <strnlen>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80065e:	eb 16                	jmp    800676 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800660:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800664:	83 ec 08             	sub    $0x8,%esp
  800667:	ff 75 0c             	pushl  0xc(%ebp)
  80066a:	50                   	push   %eax
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	ff d0                	call   *%eax
  800670:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800673:	ff 4d e4             	decl   -0x1c(%ebp)
  800676:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067a:	7f e4                	jg     800660 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80067c:	eb 34                	jmp    8006b2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80067e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800682:	74 1c                	je     8006a0 <vprintfmt+0x207>
  800684:	83 fb 1f             	cmp    $0x1f,%ebx
  800687:	7e 05                	jle    80068e <vprintfmt+0x1f5>
  800689:	83 fb 7e             	cmp    $0x7e,%ebx
  80068c:	7e 12                	jle    8006a0 <vprintfmt+0x207>
					putch('?', putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	ff 75 0c             	pushl  0xc(%ebp)
  800694:	6a 3f                	push   $0x3f
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	ff d0                	call   *%eax
  80069b:	83 c4 10             	add    $0x10,%esp
  80069e:	eb 0f                	jmp    8006af <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	ff 75 0c             	pushl  0xc(%ebp)
  8006a6:	53                   	push   %ebx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	ff d0                	call   *%eax
  8006ac:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006af:	ff 4d e4             	decl   -0x1c(%ebp)
  8006b2:	89 f0                	mov    %esi,%eax
  8006b4:	8d 70 01             	lea    0x1(%eax),%esi
  8006b7:	8a 00                	mov    (%eax),%al
  8006b9:	0f be d8             	movsbl %al,%ebx
  8006bc:	85 db                	test   %ebx,%ebx
  8006be:	74 24                	je     8006e4 <vprintfmt+0x24b>
  8006c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c4:	78 b8                	js     80067e <vprintfmt+0x1e5>
  8006c6:	ff 4d e0             	decl   -0x20(%ebp)
  8006c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006cd:	79 af                	jns    80067e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006cf:	eb 13                	jmp    8006e4 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	ff 75 0c             	pushl  0xc(%ebp)
  8006d7:	6a 20                	push   $0x20
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	ff d0                	call   *%eax
  8006de:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e1:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e8:	7f e7                	jg     8006d1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006ea:	e9 66 01 00 00       	jmp    800855 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	ff 75 e8             	pushl  -0x18(%ebp)
  8006f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f8:	50                   	push   %eax
  8006f9:	e8 3c fd ff ff       	call   80043a <getint>
  8006fe:	83 c4 10             	add    $0x10,%esp
  800701:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800704:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80070a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80070d:	85 d2                	test   %edx,%edx
  80070f:	79 23                	jns    800734 <vprintfmt+0x29b>
				putch('-', putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	6a 2d                	push   $0x2d
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	ff d0                	call   *%eax
  80071e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800727:	f7 d8                	neg    %eax
  800729:	83 d2 00             	adc    $0x0,%edx
  80072c:	f7 da                	neg    %edx
  80072e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800731:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800734:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80073b:	e9 bc 00 00 00       	jmp    8007fc <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	ff 75 e8             	pushl  -0x18(%ebp)
  800746:	8d 45 14             	lea    0x14(%ebp),%eax
  800749:	50                   	push   %eax
  80074a:	e8 84 fc ff ff       	call   8003d3 <getuint>
  80074f:	83 c4 10             	add    $0x10,%esp
  800752:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800755:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800758:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80075f:	e9 98 00 00 00       	jmp    8007fc <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	6a 58                	push   $0x58
  80076c:	8b 45 08             	mov    0x8(%ebp),%eax
  80076f:	ff d0                	call   *%eax
  800771:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	ff 75 0c             	pushl  0xc(%ebp)
  80077a:	6a 58                	push   $0x58
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	ff d0                	call   *%eax
  800781:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 0c             	pushl  0xc(%ebp)
  80078a:	6a 58                	push   $0x58
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	ff d0                	call   *%eax
  800791:	83 c4 10             	add    $0x10,%esp
			break;
  800794:	e9 bc 00 00 00       	jmp    800855 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800799:	83 ec 08             	sub    $0x8,%esp
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	6a 30                	push   $0x30
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	ff d0                	call   *%eax
  8007a6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	ff 75 0c             	pushl  0xc(%ebp)
  8007af:	6a 78                	push   $0x78
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	ff d0                	call   *%eax
  8007b6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	83 c0 04             	add    $0x4,%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 e8 04             	sub    $0x4,%eax
  8007c8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007d4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007db:	eb 1f                	jmp    8007fc <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8007e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e6:	50                   	push   %eax
  8007e7:	e8 e7 fb ff ff       	call   8003d3 <getuint>
  8007ec:	83 c4 10             	add    $0x10,%esp
  8007ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007f5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007fc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800800:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	52                   	push   %edx
  800807:	ff 75 e4             	pushl  -0x1c(%ebp)
  80080a:	50                   	push   %eax
  80080b:	ff 75 f4             	pushl  -0xc(%ebp)
  80080e:	ff 75 f0             	pushl  -0x10(%ebp)
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	ff 75 08             	pushl  0x8(%ebp)
  800817:	e8 00 fb ff ff       	call   80031c <printnum>
  80081c:	83 c4 20             	add    $0x20,%esp
			break;
  80081f:	eb 34                	jmp    800855 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	53                   	push   %ebx
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
			break;
  800830:	eb 23                	jmp    800855 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	6a 25                	push   $0x25
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800842:	ff 4d 10             	decl   0x10(%ebp)
  800845:	eb 03                	jmp    80084a <vprintfmt+0x3b1>
  800847:	ff 4d 10             	decl   0x10(%ebp)
  80084a:	8b 45 10             	mov    0x10(%ebp),%eax
  80084d:	48                   	dec    %eax
  80084e:	8a 00                	mov    (%eax),%al
  800850:	3c 25                	cmp    $0x25,%al
  800852:	75 f3                	jne    800847 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800854:	90                   	nop
		}
	}
  800855:	e9 47 fc ff ff       	jmp    8004a1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80085a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80085b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80085e:	5b                   	pop    %ebx
  80085f:	5e                   	pop    %esi
  800860:	5d                   	pop    %ebp
  800861:	c3                   	ret    

00800862 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800868:	8d 45 10             	lea    0x10(%ebp),%eax
  80086b:	83 c0 04             	add    $0x4,%eax
  80086e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800871:	8b 45 10             	mov    0x10(%ebp),%eax
  800874:	ff 75 f4             	pushl  -0xc(%ebp)
  800877:	50                   	push   %eax
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	e8 16 fc ff ff       	call   800499 <vprintfmt>
  800883:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800886:	90                   	nop
  800887:	c9                   	leave  
  800888:	c3                   	ret    

00800889 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80088c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088f:	8b 40 08             	mov    0x8(%eax),%eax
  800892:	8d 50 01             	lea    0x1(%eax),%edx
  800895:	8b 45 0c             	mov    0xc(%ebp),%eax
  800898:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80089b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089e:	8b 10                	mov    (%eax),%edx
  8008a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a3:	8b 40 04             	mov    0x4(%eax),%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	73 12                	jae    8008bc <sprintputch+0x33>
		*b->buf++ = ch;
  8008aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8d 48 01             	lea    0x1(%eax),%ecx
  8008b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b5:	89 0a                	mov    %ecx,(%edx)
  8008b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ba:	88 10                	mov    %dl,(%eax)
}
  8008bc:	90                   	nop
  8008bd:	5d                   	pop    %ebp
  8008be:	c3                   	ret    

008008bf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	01 d0                	add    %edx,%eax
  8008d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008e4:	74 06                	je     8008ec <vsnprintf+0x2d>
  8008e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ea:	7f 07                	jg     8008f3 <vsnprintf+0x34>
		return -E_INVAL;
  8008ec:	b8 03 00 00 00       	mov    $0x3,%eax
  8008f1:	eb 20                	jmp    800913 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008f3:	ff 75 14             	pushl  0x14(%ebp)
  8008f6:	ff 75 10             	pushl  0x10(%ebp)
  8008f9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008fc:	50                   	push   %eax
  8008fd:	68 89 08 80 00       	push   $0x800889
  800902:	e8 92 fb ff ff       	call   800499 <vprintfmt>
  800907:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80090a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80090d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800910:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800913:	c9                   	leave  
  800914:	c3                   	ret    

00800915 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80091b:	8d 45 10             	lea    0x10(%ebp),%eax
  80091e:	83 c0 04             	add    $0x4,%eax
  800921:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800924:	8b 45 10             	mov    0x10(%ebp),%eax
  800927:	ff 75 f4             	pushl  -0xc(%ebp)
  80092a:	50                   	push   %eax
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	ff 75 08             	pushl  0x8(%ebp)
  800931:	e8 89 ff ff ff       	call   8008bf <vsnprintf>
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80093c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80093f:	c9                   	leave  
  800940:	c3                   	ret    

00800941 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800947:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80094e:	eb 06                	jmp    800956 <strlen+0x15>
		n++;
  800950:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800953:	ff 45 08             	incl   0x8(%ebp)
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8a 00                	mov    (%eax),%al
  80095b:	84 c0                	test   %al,%al
  80095d:	75 f1                	jne    800950 <strlen+0xf>
		n++;
	return n;
  80095f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800962:	c9                   	leave  
  800963:	c3                   	ret    

00800964 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80096a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800971:	eb 09                	jmp    80097c <strnlen+0x18>
		n++;
  800973:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800976:	ff 45 08             	incl   0x8(%ebp)
  800979:	ff 4d 0c             	decl   0xc(%ebp)
  80097c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800980:	74 09                	je     80098b <strnlen+0x27>
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8a 00                	mov    (%eax),%al
  800987:	84 c0                	test   %al,%al
  800989:	75 e8                	jne    800973 <strnlen+0xf>
		n++;
	return n;
  80098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80099c:	90                   	nop
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	8d 50 01             	lea    0x1(%eax),%edx
  8009a3:	89 55 08             	mov    %edx,0x8(%ebp)
  8009a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009ac:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009af:	8a 12                	mov    (%edx),%dl
  8009b1:	88 10                	mov    %dl,(%eax)
  8009b3:	8a 00                	mov    (%eax),%al
  8009b5:	84 c0                	test   %al,%al
  8009b7:	75 e4                	jne    80099d <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009bc:	c9                   	leave  
  8009bd:	c3                   	ret    

008009be <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d1:	eb 1f                	jmp    8009f2 <strncpy+0x34>
		*dst++ = *src;
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8d 50 01             	lea    0x1(%eax),%edx
  8009d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8009dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009df:	8a 12                	mov    (%edx),%dl
  8009e1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e6:	8a 00                	mov    (%eax),%al
  8009e8:	84 c0                	test   %al,%al
  8009ea:	74 03                	je     8009ef <strncpy+0x31>
			src++;
  8009ec:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ef:	ff 45 fc             	incl   -0x4(%ebp)
  8009f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009f5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009f8:	72 d9                	jb     8009d3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a0f:	74 30                	je     800a41 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a11:	eb 16                	jmp    800a29 <strlcpy+0x2a>
			*dst++ = *src++;
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8d 50 01             	lea    0x1(%eax),%edx
  800a19:	89 55 08             	mov    %edx,0x8(%ebp)
  800a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a22:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a25:	8a 12                	mov    (%edx),%dl
  800a27:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a29:	ff 4d 10             	decl   0x10(%ebp)
  800a2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a30:	74 09                	je     800a3b <strlcpy+0x3c>
  800a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	84 c0                	test   %al,%al
  800a39:	75 d8                	jne    800a13 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a41:	8b 55 08             	mov    0x8(%ebp),%edx
  800a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a47:	29 c2                	sub    %eax,%edx
  800a49:	89 d0                	mov    %edx,%eax
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a50:	eb 06                	jmp    800a58 <strcmp+0xb>
		p++, q++;
  800a52:	ff 45 08             	incl   0x8(%ebp)
  800a55:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8a 00                	mov    (%eax),%al
  800a5d:	84 c0                	test   %al,%al
  800a5f:	74 0e                	je     800a6f <strcmp+0x22>
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8a 10                	mov    (%eax),%dl
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	8a 00                	mov    (%eax),%al
  800a6b:	38 c2                	cmp    %al,%dl
  800a6d:	74 e3                	je     800a52 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	8a 00                	mov    (%eax),%al
  800a74:	0f b6 d0             	movzbl %al,%edx
  800a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7a:	8a 00                	mov    (%eax),%al
  800a7c:	0f b6 c0             	movzbl %al,%eax
  800a7f:	29 c2                	sub    %eax,%edx
  800a81:	89 d0                	mov    %edx,%eax
}
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a88:	eb 09                	jmp    800a93 <strncmp+0xe>
		n--, p++, q++;
  800a8a:	ff 4d 10             	decl   0x10(%ebp)
  800a8d:	ff 45 08             	incl   0x8(%ebp)
  800a90:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a97:	74 17                	je     800ab0 <strncmp+0x2b>
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8a 00                	mov    (%eax),%al
  800a9e:	84 c0                	test   %al,%al
  800aa0:	74 0e                	je     800ab0 <strncmp+0x2b>
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8a 10                	mov    (%eax),%dl
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	8a 00                	mov    (%eax),%al
  800aac:	38 c2                	cmp    %al,%dl
  800aae:	74 da                	je     800a8a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ab0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab4:	75 07                	jne    800abd <strncmp+0x38>
		return 0;
  800ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  800abb:	eb 14                	jmp    800ad1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	8a 00                	mov    (%eax),%al
  800ac2:	0f b6 d0             	movzbl %al,%edx
  800ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac8:	8a 00                	mov    (%eax),%al
  800aca:	0f b6 c0             	movzbl %al,%eax
  800acd:	29 c2                	sub    %eax,%edx
  800acf:	89 d0                	mov    %edx,%eax
}
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 04             	sub    $0x4,%esp
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800adf:	eb 12                	jmp    800af3 <strchr+0x20>
		if (*s == c)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ae9:	75 05                	jne    800af0 <strchr+0x1d>
			return (char *) s;
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	eb 11                	jmp    800b01 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800af0:	ff 45 08             	incl   0x8(%ebp)
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	8a 00                	mov    (%eax),%al
  800af8:	84 c0                	test   %al,%al
  800afa:	75 e5                	jne    800ae1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b01:	c9                   	leave  
  800b02:	c3                   	ret    

00800b03 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	83 ec 04             	sub    $0x4,%esp
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b0f:	eb 0d                	jmp    800b1e <strfind+0x1b>
		if (*s == c)
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8a 00                	mov    (%eax),%al
  800b16:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b19:	74 0e                	je     800b29 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b1b:	ff 45 08             	incl   0x8(%ebp)
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 00                	mov    (%eax),%al
  800b23:	84 c0                	test   %al,%al
  800b25:	75 ea                	jne    800b11 <strfind+0xe>
  800b27:	eb 01                	jmp    800b2a <strfind+0x27>
		if (*s == c)
			break;
  800b29:	90                   	nop
	return (char *) s;
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b2d:	c9                   	leave  
  800b2e:	c3                   	ret    

00800b2f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b41:	eb 0e                	jmp    800b51 <memset+0x22>
		*p++ = c;
  800b43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b46:	8d 50 01             	lea    0x1(%eax),%edx
  800b49:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b51:	ff 4d f8             	decl   -0x8(%ebp)
  800b54:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b58:	79 e9                	jns    800b43 <memset+0x14>
		*p++ = c;

	return v;
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b71:	eb 16                	jmp    800b89 <memcpy+0x2a>
		*d++ = *s++;
  800b73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b76:	8d 50 01             	lea    0x1(%eax),%edx
  800b79:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b7f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b82:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b85:	8a 12                	mov    (%edx),%dl
  800b87:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b89:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8f:	89 55 10             	mov    %edx,0x10(%ebp)
  800b92:	85 c0                	test   %eax,%eax
  800b94:	75 dd                	jne    800b73 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bb3:	73 50                	jae    800c05 <memmove+0x6a>
  800bb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbb:	01 d0                	add    %edx,%eax
  800bbd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bc0:	76 43                	jbe    800c05 <memmove+0x6a>
		s += n;
  800bc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bce:	eb 10                	jmp    800be0 <memmove+0x45>
			*--d = *--s;
  800bd0:	ff 4d f8             	decl   -0x8(%ebp)
  800bd3:	ff 4d fc             	decl   -0x4(%ebp)
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd9:	8a 10                	mov    (%eax),%dl
  800bdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bde:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800be0:	8b 45 10             	mov    0x10(%ebp),%eax
  800be3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be6:	89 55 10             	mov    %edx,0x10(%ebp)
  800be9:	85 c0                	test   %eax,%eax
  800beb:	75 e3                	jne    800bd0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bed:	eb 23                	jmp    800c12 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf2:	8d 50 01             	lea    0x1(%eax),%edx
  800bf5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bf8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bfb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bfe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c01:	8a 12                	mov    (%edx),%dl
  800c03:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c05:	8b 45 10             	mov    0x10(%ebp),%eax
  800c08:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c0b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c0e:	85 c0                	test   %eax,%eax
  800c10:	75 dd                	jne    800bef <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c15:	c9                   	leave  
  800c16:	c3                   	ret    

00800c17 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c26:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c29:	eb 2a                	jmp    800c55 <memcmp+0x3e>
		if (*s1 != *s2)
  800c2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2e:	8a 10                	mov    (%eax),%dl
  800c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c33:	8a 00                	mov    (%eax),%al
  800c35:	38 c2                	cmp    %al,%dl
  800c37:	74 16                	je     800c4f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3c:	8a 00                	mov    (%eax),%al
  800c3e:	0f b6 d0             	movzbl %al,%edx
  800c41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	0f b6 c0             	movzbl %al,%eax
  800c49:	29 c2                	sub    %eax,%edx
  800c4b:	89 d0                	mov    %edx,%eax
  800c4d:	eb 18                	jmp    800c67 <memcmp+0x50>
		s1++, s2++;
  800c4f:	ff 45 fc             	incl   -0x4(%ebp)
  800c52:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c55:	8b 45 10             	mov    0x10(%ebp),%eax
  800c58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c5e:	85 c0                	test   %eax,%eax
  800c60:	75 c9                	jne    800c2b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c72:	8b 45 10             	mov    0x10(%ebp),%eax
  800c75:	01 d0                	add    %edx,%eax
  800c77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c7a:	eb 15                	jmp    800c91 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	0f b6 d0             	movzbl %al,%edx
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	0f b6 c0             	movzbl %al,%eax
  800c8a:	39 c2                	cmp    %eax,%edx
  800c8c:	74 0d                	je     800c9b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c8e:	ff 45 08             	incl   0x8(%ebp)
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c97:	72 e3                	jb     800c7c <memfind+0x13>
  800c99:	eb 01                	jmp    800c9c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c9b:	90                   	nop
	return (void *) s;
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c9f:	c9                   	leave  
  800ca0:	c3                   	ret    

00800ca1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ca7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb5:	eb 03                	jmp    800cba <strtol+0x19>
		s++;
  800cb7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	3c 20                	cmp    $0x20,%al
  800cc1:	74 f4                	je     800cb7 <strtol+0x16>
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	3c 09                	cmp    $0x9,%al
  800cca:	74 eb                	je     800cb7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	3c 2b                	cmp    $0x2b,%al
  800cd3:	75 05                	jne    800cda <strtol+0x39>
		s++;
  800cd5:	ff 45 08             	incl   0x8(%ebp)
  800cd8:	eb 13                	jmp    800ced <strtol+0x4c>
	else if (*s == '-')
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	3c 2d                	cmp    $0x2d,%al
  800ce1:	75 0a                	jne    800ced <strtol+0x4c>
		s++, neg = 1;
  800ce3:	ff 45 08             	incl   0x8(%ebp)
  800ce6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ced:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf1:	74 06                	je     800cf9 <strtol+0x58>
  800cf3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cf7:	75 20                	jne    800d19 <strtol+0x78>
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	3c 30                	cmp    $0x30,%al
  800d00:	75 17                	jne    800d19 <strtol+0x78>
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	40                   	inc    %eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	3c 78                	cmp    $0x78,%al
  800d0a:	75 0d                	jne    800d19 <strtol+0x78>
		s += 2, base = 16;
  800d0c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d10:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d17:	eb 28                	jmp    800d41 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1d:	75 15                	jne    800d34 <strtol+0x93>
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	3c 30                	cmp    $0x30,%al
  800d26:	75 0c                	jne    800d34 <strtol+0x93>
		s++, base = 8;
  800d28:	ff 45 08             	incl   0x8(%ebp)
  800d2b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d32:	eb 0d                	jmp    800d41 <strtol+0xa0>
	else if (base == 0)
  800d34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d38:	75 07                	jne    800d41 <strtol+0xa0>
		base = 10;
  800d3a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	3c 2f                	cmp    $0x2f,%al
  800d48:	7e 19                	jle    800d63 <strtol+0xc2>
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	3c 39                	cmp    $0x39,%al
  800d51:	7f 10                	jg     800d63 <strtol+0xc2>
			dig = *s - '0';
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	0f be c0             	movsbl %al,%eax
  800d5b:	83 e8 30             	sub    $0x30,%eax
  800d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d61:	eb 42                	jmp    800da5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	3c 60                	cmp    $0x60,%al
  800d6a:	7e 19                	jle    800d85 <strtol+0xe4>
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	3c 7a                	cmp    $0x7a,%al
  800d73:	7f 10                	jg     800d85 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	0f be c0             	movsbl %al,%eax
  800d7d:	83 e8 57             	sub    $0x57,%eax
  800d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d83:	eb 20                	jmp    800da5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	3c 40                	cmp    $0x40,%al
  800d8c:	7e 39                	jle    800dc7 <strtol+0x126>
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	3c 5a                	cmp    $0x5a,%al
  800d95:	7f 30                	jg     800dc7 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	0f be c0             	movsbl %al,%eax
  800d9f:	83 e8 37             	sub    $0x37,%eax
  800da2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800da8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dab:	7d 19                	jge    800dc6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800dad:	ff 45 08             	incl   0x8(%ebp)
  800db0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800db7:	89 c2                	mov    %eax,%edx
  800db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dbc:	01 d0                	add    %edx,%eax
  800dbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dc1:	e9 7b ff ff ff       	jmp    800d41 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dc6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dcb:	74 08                	je     800dd5 <strtol+0x134>
		*endptr = (char *) s;
  800dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dd9:	74 07                	je     800de2 <strtol+0x141>
  800ddb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dde:	f7 d8                	neg    %eax
  800de0:	eb 03                	jmp    800de5 <strtol+0x144>
  800de2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de5:	c9                   	leave  
  800de6:	c3                   	ret    

00800de7 <ltostr>:

void
ltostr(long value, char *str)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ded:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800df4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dff:	79 13                	jns    800e14 <ltostr+0x2d>
	{
		neg = 1;
  800e01:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e0e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e11:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e1c:	99                   	cltd   
  800e1d:	f7 f9                	idiv   %ecx
  800e1f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e25:	8d 50 01             	lea    0x1(%eax),%edx
  800e28:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2b:	89 c2                	mov    %eax,%edx
  800e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e30:	01 d0                	add    %edx,%eax
  800e32:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e35:	83 c2 30             	add    $0x30,%edx
  800e38:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e3d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e42:	f7 e9                	imul   %ecx
  800e44:	c1 fa 02             	sar    $0x2,%edx
  800e47:	89 c8                	mov    %ecx,%eax
  800e49:	c1 f8 1f             	sar    $0x1f,%eax
  800e4c:	29 c2                	sub    %eax,%edx
  800e4e:	89 d0                	mov    %edx,%eax
  800e50:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e56:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e5b:	f7 e9                	imul   %ecx
  800e5d:	c1 fa 02             	sar    $0x2,%edx
  800e60:	89 c8                	mov    %ecx,%eax
  800e62:	c1 f8 1f             	sar    $0x1f,%eax
  800e65:	29 c2                	sub    %eax,%edx
  800e67:	89 d0                	mov    %edx,%eax
  800e69:	c1 e0 02             	shl    $0x2,%eax
  800e6c:	01 d0                	add    %edx,%eax
  800e6e:	01 c0                	add    %eax,%eax
  800e70:	29 c1                	sub    %eax,%ecx
  800e72:	89 ca                	mov    %ecx,%edx
  800e74:	85 d2                	test   %edx,%edx
  800e76:	75 9c                	jne    800e14 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e82:	48                   	dec    %eax
  800e83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e86:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e8a:	74 3d                	je     800ec9 <ltostr+0xe2>
		start = 1 ;
  800e8c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e93:	eb 34                	jmp    800ec9 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	01 d0                	add    %edx,%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800ea2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea8:	01 c2                	add    %eax,%edx
  800eaa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb0:	01 c8                	add    %ecx,%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800eb6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	01 c2                	add    %eax,%edx
  800ebe:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ec1:	88 02                	mov    %al,(%edx)
		start++ ;
  800ec3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ec6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ecc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ecf:	7c c4                	jl     800e95 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ed1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	01 d0                	add    %edx,%eax
  800ed9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800edc:	90                   	nop
  800edd:	c9                   	leave  
  800ede:	c3                   	ret    

00800edf <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ee5:	ff 75 08             	pushl  0x8(%ebp)
  800ee8:	e8 54 fa ff ff       	call   800941 <strlen>
  800eed:	83 c4 04             	add    $0x4,%esp
  800ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ef3:	ff 75 0c             	pushl  0xc(%ebp)
  800ef6:	e8 46 fa ff ff       	call   800941 <strlen>
  800efb:	83 c4 04             	add    $0x4,%esp
  800efe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f0f:	eb 17                	jmp    800f28 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f14:	8b 45 10             	mov    0x10(%ebp),%eax
  800f17:	01 c2                	add    %eax,%edx
  800f19:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	01 c8                	add    %ecx,%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f25:	ff 45 fc             	incl   -0x4(%ebp)
  800f28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f2e:	7c e1                	jl     800f11 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f30:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f3e:	eb 1f                	jmp    800f5f <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f43:	8d 50 01             	lea    0x1(%eax),%edx
  800f46:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f49:	89 c2                	mov    %eax,%edx
  800f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4e:	01 c2                	add    %eax,%edx
  800f50:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	01 c8                	add    %ecx,%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f5c:	ff 45 f8             	incl   -0x8(%ebp)
  800f5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f62:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f65:	7c d9                	jl     800f40 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6d:	01 d0                	add    %edx,%eax
  800f6f:	c6 00 00             	movb   $0x0,(%eax)
}
  800f72:	90                   	nop
  800f73:	c9                   	leave  
  800f74:	c3                   	ret    

00800f75 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f78:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f81:	8b 45 14             	mov    0x14(%ebp),%eax
  800f84:	8b 00                	mov    (%eax),%eax
  800f86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	01 d0                	add    %edx,%eax
  800f92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f98:	eb 0c                	jmp    800fa6 <strsplit+0x31>
			*string++ = 0;
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8d 50 01             	lea    0x1(%eax),%edx
  800fa0:	89 55 08             	mov    %edx,0x8(%ebp)
  800fa3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	84 c0                	test   %al,%al
  800fad:	74 18                	je     800fc7 <strsplit+0x52>
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	0f be c0             	movsbl %al,%eax
  800fb7:	50                   	push   %eax
  800fb8:	ff 75 0c             	pushl  0xc(%ebp)
  800fbb:	e8 13 fb ff ff       	call   800ad3 <strchr>
  800fc0:	83 c4 08             	add    $0x8,%esp
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	75 d3                	jne    800f9a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	84 c0                	test   %al,%al
  800fce:	74 5a                	je     80102a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd3:	8b 00                	mov    (%eax),%eax
  800fd5:	83 f8 0f             	cmp    $0xf,%eax
  800fd8:	75 07                	jne    800fe1 <strsplit+0x6c>
		{
			return 0;
  800fda:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdf:	eb 66                	jmp    801047 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fe1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe4:	8b 00                	mov    (%eax),%eax
  800fe6:	8d 48 01             	lea    0x1(%eax),%ecx
  800fe9:	8b 55 14             	mov    0x14(%ebp),%edx
  800fec:	89 0a                	mov    %ecx,(%edx)
  800fee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ff5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff8:	01 c2                	add    %eax,%edx
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fff:	eb 03                	jmp    801004 <strsplit+0x8f>
			string++;
  801001:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	84 c0                	test   %al,%al
  80100b:	74 8b                	je     800f98 <strsplit+0x23>
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	0f be c0             	movsbl %al,%eax
  801015:	50                   	push   %eax
  801016:	ff 75 0c             	pushl  0xc(%ebp)
  801019:	e8 b5 fa ff ff       	call   800ad3 <strchr>
  80101e:	83 c4 08             	add    $0x8,%esp
  801021:	85 c0                	test   %eax,%eax
  801023:	74 dc                	je     801001 <strsplit+0x8c>
			string++;
	}
  801025:	e9 6e ff ff ff       	jmp    800f98 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80102a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80102b:	8b 45 14             	mov    0x14(%ebp),%eax
  80102e:	8b 00                	mov    (%eax),%eax
  801030:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
  80103a:	01 d0                	add    %edx,%eax
  80103c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801042:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801047:	c9                   	leave  
  801048:	c3                   	ret    

00801049 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  80104f:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801056:	8b 55 08             	mov    0x8(%ebp),%edx
  801059:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80105c:	01 d0                	add    %edx,%eax
  80105e:	48                   	dec    %eax
  80105f:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801062:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801065:	ba 00 00 00 00       	mov    $0x0,%edx
  80106a:	f7 75 ac             	divl   -0x54(%ebp)
  80106d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801070:	29 d0                	sub    %edx,%eax
  801072:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801075:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  80107c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801083:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  80108a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801091:	eb 3f                	jmp    8010d2 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801093:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801096:	8b 04 c5 00 06 c2 06 	mov    0x6c20600(,%eax,8),%eax
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	50                   	push   %eax
  8010a1:	ff 75 e8             	pushl  -0x18(%ebp)
  8010a4:	68 b0 26 80 00       	push   $0x8026b0
  8010a9:	e8 11 f2 ff ff       	call   8002bf <cprintf>
  8010ae:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  8010b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b4:	8b 04 c5 04 06 c2 06 	mov    0x6c20604(,%eax,8),%eax
  8010bb:	83 ec 04             	sub    $0x4,%esp
  8010be:	50                   	push   %eax
  8010bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8010c2:	68 c5 26 80 00       	push   $0x8026c5
  8010c7:	e8 f3 f1 ff ff       	call   8002bf <cprintf>
  8010cc:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  8010cf:	ff 45 e8             	incl   -0x18(%ebp)
  8010d2:	a1 28 30 80 00       	mov    0x803028,%eax
  8010d7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8010da:	7c b7                	jl     801093 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8010dc:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  8010e3:	e9 42 01 00 00       	jmp    80122a <malloc+0x1e1>
		int flag0=1;
  8010e8:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8010ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010f5:	eb 6b                	jmp    801162 <malloc+0x119>
			for(int k=0;k<count;k++){
  8010f7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8010fe:	eb 42                	jmp    801142 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801100:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801103:	8b 14 c5 00 06 c2 06 	mov    0x6c20600(,%eax,8),%edx
  80110a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80110d:	39 c2                	cmp    %eax,%edx
  80110f:	77 2e                	ja     80113f <malloc+0xf6>
  801111:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801114:	8b 14 c5 04 06 c2 06 	mov    0x6c20604(,%eax,8),%edx
  80111b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80111e:	39 c2                	cmp    %eax,%edx
  801120:	76 1d                	jbe    80113f <malloc+0xf6>
					ni=arr_add[k].end-i;
  801122:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801125:	8b 14 c5 04 06 c2 06 	mov    0x6c20604(,%eax,8),%edx
  80112c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80112f:	29 c2                	sub    %eax,%edx
  801131:	89 d0                	mov    %edx,%eax
  801133:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801136:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  80113d:	eb 0d                	jmp    80114c <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  80113f:	ff 45 d8             	incl   -0x28(%ebp)
  801142:	a1 28 30 80 00       	mov    0x803028,%eax
  801147:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80114a:	7c b4                	jl     801100 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  80114c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801150:	74 09                	je     80115b <malloc+0x112>
				flag0=0;
  801152:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801159:	eb 16                	jmp    801171 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  80115b:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	01 c2                	add    %eax,%edx
  80116a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80116d:	39 c2                	cmp    %eax,%edx
  80116f:	77 86                	ja     8010f7 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801171:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801175:	0f 84 a2 00 00 00    	je     80121d <malloc+0x1d4>

			int f=1;
  80117b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801182:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801185:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801188:	89 c8                	mov    %ecx,%eax
  80118a:	01 c0                	add    %eax,%eax
  80118c:	01 c8                	add    %ecx,%eax
  80118e:	c1 e0 02             	shl    $0x2,%eax
  801191:	05 40 31 c0 06       	add    $0x6c03140,%eax
  801196:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801198:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8011a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a4:	89 d0                	mov    %edx,%eax
  8011a6:	01 c0                	add    %eax,%eax
  8011a8:	01 d0                	add    %edx,%eax
  8011aa:	c1 e0 02             	shl    $0x2,%eax
  8011ad:	05 44 31 c0 06       	add    $0x6c03144,%eax
  8011b2:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  8011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b7:	89 d0                	mov    %edx,%eax
  8011b9:	01 c0                	add    %eax,%eax
  8011bb:	01 d0                	add    %edx,%eax
  8011bd:	c1 e0 02             	shl    $0x2,%eax
  8011c0:	05 48 31 c0 06       	add    $0x6c03148,%eax
  8011c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  8011cb:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  8011ce:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8011d5:	eb 36                	jmp    80120d <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  8011d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	01 c2                	add    %eax,%edx
  8011df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011e2:	8b 04 c5 00 06 c2 06 	mov    0x6c20600(,%eax,8),%eax
  8011e9:	39 c2                	cmp    %eax,%edx
  8011eb:	73 1d                	jae    80120a <malloc+0x1c1>
					ni=arr_add[l].end-i;
  8011ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011f0:	8b 14 c5 04 06 c2 06 	mov    0x6c20604(,%eax,8),%edx
  8011f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011fa:	29 c2                	sub    %eax,%edx
  8011fc:	89 d0                	mov    %edx,%eax
  8011fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801201:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801208:	eb 0d                	jmp    801217 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  80120a:	ff 45 d0             	incl   -0x30(%ebp)
  80120d:	a1 28 30 80 00       	mov    0x803028,%eax
  801212:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801215:	7c c0                	jl     8011d7 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801217:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80121b:	75 1d                	jne    80123a <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  80121d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801227:	01 45 e4             	add    %eax,-0x1c(%ebp)
  80122a:	a1 04 30 80 00       	mov    0x803004,%eax
  80122f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801232:	0f 8c b0 fe ff ff    	jl     8010e8 <malloc+0x9f>
  801238:	eb 01                	jmp    80123b <malloc+0x1f2>

				}
			}

			if(f){
				break;
  80123a:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  80123b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80123f:	75 7a                	jne    8012bb <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801241:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	48                   	dec    %eax
  80124d:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801252:	7c 0a                	jl     80125e <malloc+0x215>
			return NULL;
  801254:	b8 00 00 00 00       	mov    $0x0,%eax
  801259:	e9 a4 02 00 00       	jmp    801502 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  80125e:	a1 04 30 80 00       	mov    0x803004,%eax
  801263:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801266:	a1 28 30 80 00       	mov    0x803028,%eax
  80126b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  80126e:	89 14 c5 00 06 c2 06 	mov    %edx,0x6c20600(,%eax,8)
		    sys_allocateMem(s,size);
  801275:	83 ec 08             	sub    $0x8,%esp
  801278:	ff 75 08             	pushl  0x8(%ebp)
  80127b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80127e:	e8 04 06 00 00       	call   801887 <sys_allocateMem>
  801283:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801286:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	01 d0                	add    %edx,%eax
  801291:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  801296:	a1 28 30 80 00       	mov    0x803028,%eax
  80129b:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8012a1:	89 14 c5 04 06 c2 06 	mov    %edx,0x6c20604(,%eax,8)
			count++;
  8012a8:	a1 28 30 80 00       	mov    0x803028,%eax
  8012ad:	40                   	inc    %eax
  8012ae:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  8012b3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8012b6:	e9 47 02 00 00       	jmp    801502 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  8012bb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8012c2:	e9 ac 00 00 00       	jmp    801373 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8012c7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8012ca:	89 d0                	mov    %edx,%eax
  8012cc:	01 c0                	add    %eax,%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	c1 e0 02             	shl    $0x2,%eax
  8012d3:	05 44 31 c0 06       	add    $0x6c03144,%eax
  8012d8:	8b 00                	mov    (%eax),%eax
  8012da:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8012dd:	eb 7e                	jmp    80135d <malloc+0x314>
			int flag=0;
  8012df:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  8012e6:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8012ed:	eb 57                	jmp    801346 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8012ef:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8012f2:	8b 14 c5 00 06 c2 06 	mov    0x6c20600(,%eax,8),%edx
  8012f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8012fc:	39 c2                	cmp    %eax,%edx
  8012fe:	77 1a                	ja     80131a <malloc+0x2d1>
  801300:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801303:	8b 14 c5 04 06 c2 06 	mov    0x6c20604(,%eax,8),%edx
  80130a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80130d:	39 c2                	cmp    %eax,%edx
  80130f:	76 09                	jbe    80131a <malloc+0x2d1>
								flag=1;
  801311:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801318:	eb 36                	jmp    801350 <malloc+0x307>
			arr[i].space++;
  80131a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80131d:	89 d0                	mov    %edx,%eax
  80131f:	01 c0                	add    %eax,%eax
  801321:	01 d0                	add    %edx,%eax
  801323:	c1 e0 02             	shl    $0x2,%eax
  801326:	05 48 31 c0 06       	add    $0x6c03148,%eax
  80132b:	8b 00                	mov    (%eax),%eax
  80132d:	8d 48 01             	lea    0x1(%eax),%ecx
  801330:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801333:	89 d0                	mov    %edx,%eax
  801335:	01 c0                	add    %eax,%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	c1 e0 02             	shl    $0x2,%eax
  80133c:	05 48 31 c0 06       	add    $0x6c03148,%eax
  801341:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801343:	ff 45 c0             	incl   -0x40(%ebp)
  801346:	a1 28 30 80 00       	mov    0x803028,%eax
  80134b:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  80134e:	7c 9f                	jl     8012ef <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801350:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801354:	75 19                	jne    80136f <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801356:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  80135d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801360:	a1 04 30 80 00       	mov    0x803004,%eax
  801365:	39 c2                	cmp    %eax,%edx
  801367:	0f 82 72 ff ff ff    	jb     8012df <malloc+0x296>
  80136d:	eb 01                	jmp    801370 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  80136f:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801370:	ff 45 cc             	incl   -0x34(%ebp)
  801373:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801376:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801379:	0f 8c 48 ff ff ff    	jl     8012c7 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  80137f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801386:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  80138d:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801394:	eb 37                	jmp    8013cd <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801396:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801399:	89 d0                	mov    %edx,%eax
  80139b:	01 c0                	add    %eax,%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	c1 e0 02             	shl    $0x2,%eax
  8013a2:	05 48 31 c0 06       	add    $0x6c03148,%eax
  8013a7:	8b 00                	mov    (%eax),%eax
  8013a9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8013ac:	7d 1c                	jge    8013ca <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  8013ae:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8013b1:	89 d0                	mov    %edx,%eax
  8013b3:	01 c0                	add    %eax,%eax
  8013b5:	01 d0                	add    %edx,%eax
  8013b7:	c1 e0 02             	shl    $0x2,%eax
  8013ba:	05 48 31 c0 06       	add    $0x6c03148,%eax
  8013bf:	8b 00                	mov    (%eax),%eax
  8013c1:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  8013c4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8013c7:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  8013ca:	ff 45 b4             	incl   -0x4c(%ebp)
  8013cd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8013d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013d3:	7c c1                	jl     801396 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  8013d5:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8013db:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8013de:	89 c8                	mov    %ecx,%eax
  8013e0:	01 c0                	add    %eax,%eax
  8013e2:	01 c8                	add    %ecx,%eax
  8013e4:	c1 e0 02             	shl    $0x2,%eax
  8013e7:	05 40 31 c0 06       	add    $0x6c03140,%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	89 04 d5 00 06 c2 06 	mov    %eax,0x6c20600(,%edx,8)
	arr_add[count].end=arr[index].end;
  8013f5:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8013fb:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8013fe:	89 c8                	mov    %ecx,%eax
  801400:	01 c0                	add    %eax,%eax
  801402:	01 c8                	add    %ecx,%eax
  801404:	c1 e0 02             	shl    $0x2,%eax
  801407:	05 44 31 c0 06       	add    $0x6c03144,%eax
  80140c:	8b 00                	mov    (%eax),%eax
  80140e:	89 04 d5 04 06 c2 06 	mov    %eax,0x6c20604(,%edx,8)
	count++;
  801415:	a1 28 30 80 00       	mov    0x803028,%eax
  80141a:	40                   	inc    %eax
  80141b:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  801420:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801423:	89 d0                	mov    %edx,%eax
  801425:	01 c0                	add    %eax,%eax
  801427:	01 d0                	add    %edx,%eax
  801429:	c1 e0 02             	shl    $0x2,%eax
  80142c:	05 40 31 c0 06       	add    $0x6c03140,%eax
  801431:	8b 00                	mov    (%eax),%eax
  801433:	83 ec 08             	sub    $0x8,%esp
  801436:	ff 75 08             	pushl  0x8(%ebp)
  801439:	50                   	push   %eax
  80143a:	e8 48 04 00 00       	call   801887 <sys_allocateMem>
  80143f:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801442:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801449:	eb 78                	jmp    8014c3 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  80144b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80144e:	89 d0                	mov    %edx,%eax
  801450:	01 c0                	add    %eax,%eax
  801452:	01 d0                	add    %edx,%eax
  801454:	c1 e0 02             	shl    $0x2,%eax
  801457:	05 40 31 c0 06       	add    $0x6c03140,%eax
  80145c:	8b 00                	mov    (%eax),%eax
  80145e:	83 ec 04             	sub    $0x4,%esp
  801461:	50                   	push   %eax
  801462:	ff 75 b0             	pushl  -0x50(%ebp)
  801465:	68 b0 26 80 00       	push   $0x8026b0
  80146a:	e8 50 ee ff ff       	call   8002bf <cprintf>
  80146f:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801472:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801475:	89 d0                	mov    %edx,%eax
  801477:	01 c0                	add    %eax,%eax
  801479:	01 d0                	add    %edx,%eax
  80147b:	c1 e0 02             	shl    $0x2,%eax
  80147e:	05 44 31 c0 06       	add    $0x6c03144,%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	83 ec 04             	sub    $0x4,%esp
  801488:	50                   	push   %eax
  801489:	ff 75 b0             	pushl  -0x50(%ebp)
  80148c:	68 c5 26 80 00       	push   $0x8026c5
  801491:	e8 29 ee ff ff       	call   8002bf <cprintf>
  801496:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801499:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80149c:	89 d0                	mov    %edx,%eax
  80149e:	01 c0                	add    %eax,%eax
  8014a0:	01 d0                	add    %edx,%eax
  8014a2:	c1 e0 02             	shl    $0x2,%eax
  8014a5:	05 48 31 c0 06       	add    $0x6c03148,%eax
  8014aa:	8b 00                	mov    (%eax),%eax
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	50                   	push   %eax
  8014b0:	ff 75 b0             	pushl  -0x50(%ebp)
  8014b3:	68 d8 26 80 00       	push   $0x8026d8
  8014b8:	e8 02 ee ff ff       	call   8002bf <cprintf>
  8014bd:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  8014c0:	ff 45 b0             	incl   -0x50(%ebp)
  8014c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8014c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014c9:	7c 80                	jl     80144b <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  8014cb:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8014ce:	89 d0                	mov    %edx,%eax
  8014d0:	01 c0                	add    %eax,%eax
  8014d2:	01 d0                	add    %edx,%eax
  8014d4:	c1 e0 02             	shl    $0x2,%eax
  8014d7:	05 40 31 c0 06       	add    $0x6c03140,%eax
  8014dc:	8b 00                	mov    (%eax),%eax
  8014de:	83 ec 08             	sub    $0x8,%esp
  8014e1:	50                   	push   %eax
  8014e2:	68 ec 26 80 00       	push   $0x8026ec
  8014e7:	e8 d3 ed ff ff       	call   8002bf <cprintf>
  8014ec:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  8014ef:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8014f2:	89 d0                	mov    %edx,%eax
  8014f4:	01 c0                	add    %eax,%eax
  8014f6:	01 d0                	add    %edx,%eax
  8014f8:	c1 e0 02             	shl    $0x2,%eax
  8014fb:	05 40 31 c0 06       	add    $0x6c03140,%eax
  801500:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801510:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801517:	eb 4b                	jmp    801564 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801519:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80151c:	8b 04 c5 00 06 c2 06 	mov    0x6c20600(,%eax,8),%eax
  801523:	89 c2                	mov    %eax,%edx
  801525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801528:	39 c2                	cmp    %eax,%edx
  80152a:	7f 35                	jg     801561 <free+0x5d>
  80152c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152f:	8b 04 c5 04 06 c2 06 	mov    0x6c20604(,%eax,8),%eax
  801536:	89 c2                	mov    %eax,%edx
  801538:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80153b:	39 c2                	cmp    %eax,%edx
  80153d:	7e 22                	jle    801561 <free+0x5d>
				start=arr_add[i].start;
  80153f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801542:	8b 04 c5 00 06 c2 06 	mov    0x6c20600(,%eax,8),%eax
  801549:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  80154c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154f:	8b 04 c5 04 06 c2 06 	mov    0x6c20604(,%eax,8),%eax
  801556:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801559:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80155c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  80155f:	eb 0d                	jmp    80156e <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801561:	ff 45 ec             	incl   -0x14(%ebp)
  801564:	a1 28 30 80 00       	mov    0x803028,%eax
  801569:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80156c:	7c ab                	jl     801519 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  80156e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801571:	8b 14 c5 04 06 c2 06 	mov    0x6c20604(,%eax,8),%edx
  801578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157b:	8b 04 c5 00 06 c2 06 	mov    0x6c20600(,%eax,8),%eax
  801582:	29 c2                	sub    %eax,%edx
  801584:	89 d0                	mov    %edx,%eax
  801586:	83 ec 08             	sub    $0x8,%esp
  801589:	50                   	push   %eax
  80158a:	ff 75 f4             	pushl  -0xc(%ebp)
  80158d:	e8 d9 02 00 00       	call   80186b <sys_freeMem>
  801592:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801598:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80159b:	eb 2d                	jmp    8015ca <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  80159d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a0:	40                   	inc    %eax
  8015a1:	8b 14 c5 00 06 c2 06 	mov    0x6c20600(,%eax,8),%edx
  8015a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015ab:	89 14 c5 00 06 c2 06 	mov    %edx,0x6c20600(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  8015b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015b5:	40                   	inc    %eax
  8015b6:	8b 14 c5 04 06 c2 06 	mov    0x6c20604(,%eax,8),%edx
  8015bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c0:	89 14 c5 04 06 c2 06 	mov    %edx,0x6c20604(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  8015c7:	ff 45 e8             	incl   -0x18(%ebp)
  8015ca:	a1 28 30 80 00       	mov    0x803028,%eax
  8015cf:	48                   	dec    %eax
  8015d0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8015d3:	7f c8                	jg     80159d <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  8015d5:	a1 28 30 80 00       	mov    0x803028,%eax
  8015da:	48                   	dec    %eax
  8015db:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  8015e0:	90                   	nop
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 18             	sub    $0x18,%esp
  8015e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ec:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	68 08 27 80 00       	push   $0x802708
  8015f7:	68 18 01 00 00       	push   $0x118
  8015fc:	68 2b 27 80 00       	push   $0x80272b
  801601:	e8 bf 07 00 00       	call   801dc5 <_panic>

00801606 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	68 08 27 80 00       	push   $0x802708
  801614:	68 1e 01 00 00       	push   $0x11e
  801619:	68 2b 27 80 00       	push   $0x80272b
  80161e:	e8 a2 07 00 00       	call   801dc5 <_panic>

00801623 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	68 08 27 80 00       	push   $0x802708
  801631:	68 24 01 00 00       	push   $0x124
  801636:	68 2b 27 80 00       	push   $0x80272b
  80163b:	e8 85 07 00 00       	call   801dc5 <_panic>

00801640 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	68 08 27 80 00       	push   $0x802708
  80164e:	68 29 01 00 00       	push   $0x129
  801653:	68 2b 27 80 00       	push   $0x80272b
  801658:	e8 68 07 00 00       	call   801dc5 <_panic>

0080165d <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801663:	83 ec 04             	sub    $0x4,%esp
  801666:	68 08 27 80 00       	push   $0x802708
  80166b:	68 2f 01 00 00       	push   $0x12f
  801670:	68 2b 27 80 00       	push   $0x80272b
  801675:	e8 4b 07 00 00       	call   801dc5 <_panic>

0080167a <shrink>:
}
void shrink(uint32 newSize)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	68 08 27 80 00       	push   $0x802708
  801688:	68 33 01 00 00       	push   $0x133
  80168d:	68 2b 27 80 00       	push   $0x80272b
  801692:	e8 2e 07 00 00       	call   801dc5 <_panic>

00801697 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80169d:	83 ec 04             	sub    $0x4,%esp
  8016a0:	68 08 27 80 00       	push   $0x802708
  8016a5:	68 38 01 00 00       	push   $0x138
  8016aa:	68 2b 27 80 00       	push   $0x80272b
  8016af:	e8 11 07 00 00       	call   801dc5 <_panic>

008016b4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	57                   	push   %edi
  8016b8:	56                   	push   %esi
  8016b9:	53                   	push   %ebx
  8016ba:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016cc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016cf:	cd 30                	int    $0x30
  8016d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	5b                   	pop    %ebx
  8016db:	5e                   	pop    %esi
  8016dc:	5f                   	pop    %edi
  8016dd:	5d                   	pop    %ebp
  8016de:	c3                   	ret    

008016df <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	83 ec 04             	sub    $0x4,%esp
  8016e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016eb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	52                   	push   %edx
  8016f7:	ff 75 0c             	pushl  0xc(%ebp)
  8016fa:	50                   	push   %eax
  8016fb:	6a 00                	push   $0x0
  8016fd:	e8 b2 ff ff ff       	call   8016b4 <syscall>
  801702:	83 c4 18             	add    $0x18,%esp
}
  801705:	90                   	nop
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_cgetc>:

int
sys_cgetc(void)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 01                	push   $0x1
  801717:	e8 98 ff ff ff       	call   8016b4 <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	50                   	push   %eax
  801730:	6a 05                	push   $0x5
  801732:	e8 7d ff ff ff       	call   8016b4 <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 02                	push   $0x2
  80174b:	e8 64 ff ff ff       	call   8016b4 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 03                	push   $0x3
  801764:	e8 4b ff ff ff       	call   8016b4 <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 04                	push   $0x4
  80177d:	e8 32 ff ff ff       	call   8016b4 <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_env_exit>:


void sys_env_exit(void)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 06                	push   $0x6
  801796:	e8 19 ff ff ff       	call   8016b4 <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
}
  80179e:	90                   	nop
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	52                   	push   %edx
  8017b1:	50                   	push   %eax
  8017b2:	6a 07                	push   $0x7
  8017b4:	e8 fb fe ff ff       	call   8016b4 <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	56                   	push   %esi
  8017c2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017c3:	8b 75 18             	mov    0x18(%ebp),%esi
  8017c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	56                   	push   %esi
  8017d3:	53                   	push   %ebx
  8017d4:	51                   	push   %ecx
  8017d5:	52                   	push   %edx
  8017d6:	50                   	push   %eax
  8017d7:	6a 08                	push   $0x8
  8017d9:	e8 d6 fe ff ff       	call   8016b4 <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
}
  8017e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e4:	5b                   	pop    %ebx
  8017e5:	5e                   	pop    %esi
  8017e6:	5d                   	pop    %ebp
  8017e7:	c3                   	ret    

008017e8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	52                   	push   %edx
  8017f8:	50                   	push   %eax
  8017f9:	6a 09                	push   $0x9
  8017fb:	e8 b4 fe ff ff       	call   8016b4 <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	ff 75 08             	pushl  0x8(%ebp)
  801814:	6a 0a                	push   $0xa
  801816:	e8 99 fe ff ff       	call   8016b4 <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 0b                	push   $0xb
  80182f:	e8 80 fe ff ff       	call   8016b4 <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 0c                	push   $0xc
  801848:	e8 67 fe ff ff       	call   8016b4 <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 0d                	push   $0xd
  801861:	e8 4e fe ff ff       	call   8016b4 <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	ff 75 0c             	pushl  0xc(%ebp)
  801877:	ff 75 08             	pushl  0x8(%ebp)
  80187a:	6a 11                	push   $0x11
  80187c:	e8 33 fe ff ff       	call   8016b4 <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
	return;
  801884:	90                   	nop
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	ff 75 0c             	pushl  0xc(%ebp)
  801893:	ff 75 08             	pushl  0x8(%ebp)
  801896:	6a 12                	push   $0x12
  801898:	e8 17 fe ff ff       	call   8016b4 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a0:	90                   	nop
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 0e                	push   $0xe
  8018b2:	e8 fd fd ff ff       	call   8016b4 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	ff 75 08             	pushl  0x8(%ebp)
  8018ca:	6a 0f                	push   $0xf
  8018cc:	e8 e3 fd ff ff       	call   8016b4 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 10                	push   $0x10
  8018e5:	e8 ca fd ff ff       	call   8016b4 <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
}
  8018ed:	90                   	nop
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 14                	push   $0x14
  8018ff:	e8 b0 fd ff ff       	call   8016b4 <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	90                   	nop
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 15                	push   $0x15
  801919:	e8 96 fd ff ff       	call   8016b4 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	90                   	nop
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_cputc>:


void
sys_cputc(const char c)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801930:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	50                   	push   %eax
  80193d:	6a 16                	push   $0x16
  80193f:	e8 70 fd ff ff       	call   8016b4 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	90                   	nop
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 17                	push   $0x17
  801959:	e8 56 fd ff ff       	call   8016b4 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	90                   	nop
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	ff 75 0c             	pushl  0xc(%ebp)
  801973:	50                   	push   %eax
  801974:	6a 18                	push   $0x18
  801976:	e8 39 fd ff ff       	call   8016b4 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801983:	8b 55 0c             	mov    0xc(%ebp),%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	52                   	push   %edx
  801990:	50                   	push   %eax
  801991:	6a 1b                	push   $0x1b
  801993:	e8 1c fd ff ff       	call   8016b4 <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	52                   	push   %edx
  8019ad:	50                   	push   %eax
  8019ae:	6a 19                	push   $0x19
  8019b0:	e8 ff fc ff ff       	call   8016b4 <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	90                   	nop
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	52                   	push   %edx
  8019cb:	50                   	push   %eax
  8019cc:	6a 1a                	push   $0x1a
  8019ce:	e8 e1 fc ff ff       	call   8016b4 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	90                   	nop
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 04             	sub    $0x4,%esp
  8019df:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019e5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019e8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	6a 00                	push   $0x0
  8019f1:	51                   	push   %ecx
  8019f2:	52                   	push   %edx
  8019f3:	ff 75 0c             	pushl  0xc(%ebp)
  8019f6:	50                   	push   %eax
  8019f7:	6a 1c                	push   $0x1c
  8019f9:	e8 b6 fc ff ff       	call   8016b4 <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	52                   	push   %edx
  801a13:	50                   	push   %eax
  801a14:	6a 1d                	push   $0x1d
  801a16:	e8 99 fc ff ff       	call   8016b4 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	51                   	push   %ecx
  801a31:	52                   	push   %edx
  801a32:	50                   	push   %eax
  801a33:	6a 1e                	push   $0x1e
  801a35:	e8 7a fc ff ff       	call   8016b4 <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	52                   	push   %edx
  801a4f:	50                   	push   %eax
  801a50:	6a 1f                	push   $0x1f
  801a52:	e8 5d fc ff ff       	call   8016b4 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 20                	push   $0x20
  801a6b:	e8 44 fc ff ff       	call   8016b4 <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	6a 00                	push   $0x0
  801a7d:	ff 75 14             	pushl  0x14(%ebp)
  801a80:	ff 75 10             	pushl  0x10(%ebp)
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	50                   	push   %eax
  801a87:	6a 21                	push   $0x21
  801a89:	e8 26 fc ff ff       	call   8016b4 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	50                   	push   %eax
  801aa2:	6a 22                	push   $0x22
  801aa4:	e8 0b fc ff ff       	call   8016b4 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	90                   	nop
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	50                   	push   %eax
  801abe:	6a 23                	push   $0x23
  801ac0:	e8 ef fb ff ff       	call   8016b4 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	90                   	nop
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ad1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ad4:	8d 50 04             	lea    0x4(%eax),%edx
  801ad7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	52                   	push   %edx
  801ae1:	50                   	push   %eax
  801ae2:	6a 24                	push   $0x24
  801ae4:	e8 cb fb ff ff       	call   8016b4 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
	return result;
  801aec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801af2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801af5:	89 01                	mov    %eax,(%ecx)
  801af7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	c9                   	leave  
  801afe:	c2 04 00             	ret    $0x4

00801b01 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	ff 75 10             	pushl  0x10(%ebp)
  801b0b:	ff 75 0c             	pushl  0xc(%ebp)
  801b0e:	ff 75 08             	pushl  0x8(%ebp)
  801b11:	6a 13                	push   $0x13
  801b13:	e8 9c fb ff ff       	call   8016b4 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1b:	90                   	nop
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_rcr2>:
uint32 sys_rcr2()
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 25                	push   $0x25
  801b2d:	e8 82 fb ff ff       	call   8016b4 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 04             	sub    $0x4,%esp
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b43:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	50                   	push   %eax
  801b50:	6a 26                	push   $0x26
  801b52:	e8 5d fb ff ff       	call   8016b4 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5a:	90                   	nop
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <rsttst>:
void rsttst()
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 28                	push   $0x28
  801b6c:	e8 43 fb ff ff       	call   8016b4 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
	return ;
  801b74:	90                   	nop
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 04             	sub    $0x4,%esp
  801b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b80:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b83:	8b 55 18             	mov    0x18(%ebp),%edx
  801b86:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b8a:	52                   	push   %edx
  801b8b:	50                   	push   %eax
  801b8c:	ff 75 10             	pushl  0x10(%ebp)
  801b8f:	ff 75 0c             	pushl  0xc(%ebp)
  801b92:	ff 75 08             	pushl  0x8(%ebp)
  801b95:	6a 27                	push   $0x27
  801b97:	e8 18 fb ff ff       	call   8016b4 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9f:	90                   	nop
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <chktst>:
void chktst(uint32 n)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	ff 75 08             	pushl  0x8(%ebp)
  801bb0:	6a 29                	push   $0x29
  801bb2:	e8 fd fa ff ff       	call   8016b4 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bba:	90                   	nop
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <inctst>:

void inctst()
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 2a                	push   $0x2a
  801bcc:	e8 e3 fa ff ff       	call   8016b4 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd4:	90                   	nop
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <gettst>:
uint32 gettst()
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 2b                	push   $0x2b
  801be6:	e8 c9 fa ff ff       	call   8016b4 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 2c                	push   $0x2c
  801c02:	e8 ad fa ff ff       	call   8016b4 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
  801c0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c0d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c11:	75 07                	jne    801c1a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c13:	b8 01 00 00 00       	mov    $0x1,%eax
  801c18:	eb 05                	jmp    801c1f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 2c                	push   $0x2c
  801c33:	e8 7c fa ff ff       	call   8016b4 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
  801c3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c3e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c42:	75 07                	jne    801c4b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c44:	b8 01 00 00 00       	mov    $0x1,%eax
  801c49:	eb 05                	jmp    801c50 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 2c                	push   $0x2c
  801c64:	e8 4b fa ff ff       	call   8016b4 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
  801c6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c6f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c73:	75 07                	jne    801c7c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c75:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7a:	eb 05                	jmp    801c81 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 2c                	push   $0x2c
  801c95:	e8 1a fa ff ff       	call   8016b4 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
  801c9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ca0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ca4:	75 07                	jne    801cad <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ca6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cab:	eb 05                	jmp    801cb2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	ff 75 08             	pushl  0x8(%ebp)
  801cc2:	6a 2d                	push   $0x2d
  801cc4:	e8 eb f9 ff ff       	call   8016b4 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccc:	90                   	nop
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cd3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	6a 00                	push   $0x0
  801ce1:	53                   	push   %ebx
  801ce2:	51                   	push   %ecx
  801ce3:	52                   	push   %edx
  801ce4:	50                   	push   %eax
  801ce5:	6a 2e                	push   $0x2e
  801ce7:	e8 c8 f9 ff ff       	call   8016b4 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	52                   	push   %edx
  801d04:	50                   	push   %eax
  801d05:	6a 2f                	push   $0x2f
  801d07:	e8 a8 f9 ff ff       	call   8016b4 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801d17:	8b 55 08             	mov    0x8(%ebp),%edx
  801d1a:	89 d0                	mov    %edx,%eax
  801d1c:	c1 e0 02             	shl    $0x2,%eax
  801d1f:	01 d0                	add    %edx,%eax
  801d21:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d28:	01 d0                	add    %edx,%eax
  801d2a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d31:	01 d0                	add    %edx,%eax
  801d33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d3a:	01 d0                	add    %edx,%eax
  801d3c:	c1 e0 04             	shl    $0x4,%eax
  801d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801d42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801d49:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801d4c:	83 ec 0c             	sub    $0xc,%esp
  801d4f:	50                   	push   %eax
  801d50:	e8 76 fd ff ff       	call   801acb <sys_get_virtual_time>
  801d55:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801d58:	eb 41                	jmp    801d9b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801d5a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801d5d:	83 ec 0c             	sub    $0xc,%esp
  801d60:	50                   	push   %eax
  801d61:	e8 65 fd ff ff       	call   801acb <sys_get_virtual_time>
  801d66:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801d69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d6f:	29 c2                	sub    %eax,%edx
  801d71:	89 d0                	mov    %edx,%eax
  801d73:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801d76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7c:	89 d1                	mov    %edx,%ecx
  801d7e:	29 c1                	sub    %eax,%ecx
  801d80:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d86:	39 c2                	cmp    %eax,%edx
  801d88:	0f 97 c0             	seta   %al
  801d8b:	0f b6 c0             	movzbl %al,%eax
  801d8e:	29 c1                	sub    %eax,%ecx
  801d90:	89 c8                	mov    %ecx,%eax
  801d92:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801d95:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d98:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801da1:	72 b7                	jb     801d5a <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801da3:	90                   	nop
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801dac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801db3:	eb 03                	jmp    801db8 <busy_wait+0x12>
  801db5:	ff 45 fc             	incl   -0x4(%ebp)
  801db8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dbb:	3b 45 08             	cmp    0x8(%ebp),%eax
  801dbe:	72 f5                	jb     801db5 <busy_wait+0xf>
	return i;
  801dc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801dcb:	8d 45 10             	lea    0x10(%ebp),%eax
  801dce:	83 c0 04             	add    $0x4,%eax
  801dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801dd4:	a1 80 3e c3 06       	mov    0x6c33e80,%eax
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	74 16                	je     801df3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801ddd:	a1 80 3e c3 06       	mov    0x6c33e80,%eax
  801de2:	83 ec 08             	sub    $0x8,%esp
  801de5:	50                   	push   %eax
  801de6:	68 38 27 80 00       	push   $0x802738
  801deb:	e8 cf e4 ff ff       	call   8002bf <cprintf>
  801df0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801df3:	a1 00 30 80 00       	mov    0x803000,%eax
  801df8:	ff 75 0c             	pushl  0xc(%ebp)
  801dfb:	ff 75 08             	pushl  0x8(%ebp)
  801dfe:	50                   	push   %eax
  801dff:	68 3d 27 80 00       	push   $0x80273d
  801e04:	e8 b6 e4 ff ff       	call   8002bf <cprintf>
  801e09:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801e0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0f:	83 ec 08             	sub    $0x8,%esp
  801e12:	ff 75 f4             	pushl  -0xc(%ebp)
  801e15:	50                   	push   %eax
  801e16:	e8 39 e4 ff ff       	call   800254 <vcprintf>
  801e1b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801e1e:	83 ec 08             	sub    $0x8,%esp
  801e21:	6a 00                	push   $0x0
  801e23:	68 59 27 80 00       	push   $0x802759
  801e28:	e8 27 e4 ff ff       	call   800254 <vcprintf>
  801e2d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801e30:	e8 a8 e3 ff ff       	call   8001dd <exit>

	// should not return here
	while (1) ;
  801e35:	eb fe                	jmp    801e35 <_panic+0x70>

00801e37 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801e3d:	a1 20 30 80 00       	mov    0x803020,%eax
  801e42:	8b 50 74             	mov    0x74(%eax),%edx
  801e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e48:	39 c2                	cmp    %eax,%edx
  801e4a:	74 14                	je     801e60 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801e4c:	83 ec 04             	sub    $0x4,%esp
  801e4f:	68 5c 27 80 00       	push   $0x80275c
  801e54:	6a 26                	push   $0x26
  801e56:	68 a8 27 80 00       	push   $0x8027a8
  801e5b:	e8 65 ff ff ff       	call   801dc5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801e60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801e67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801e6e:	e9 b6 00 00 00       	jmp    801f29 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  801e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e76:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	01 d0                	add    %edx,%eax
  801e82:	8b 00                	mov    (%eax),%eax
  801e84:	85 c0                	test   %eax,%eax
  801e86:	75 08                	jne    801e90 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801e88:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801e8b:	e9 96 00 00 00       	jmp    801f26 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  801e90:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801e97:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801e9e:	eb 5d                	jmp    801efd <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801ea0:	a1 20 30 80 00       	mov    0x803020,%eax
  801ea5:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801eab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eae:	c1 e2 04             	shl    $0x4,%edx
  801eb1:	01 d0                	add    %edx,%eax
  801eb3:	8a 40 04             	mov    0x4(%eax),%al
  801eb6:	84 c0                	test   %al,%al
  801eb8:	75 40                	jne    801efa <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801eba:	a1 20 30 80 00       	mov    0x803020,%eax
  801ebf:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801ec5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ec8:	c1 e2 04             	shl    $0x4,%edx
  801ecb:	01 d0                	add    %edx,%eax
  801ecd:	8b 00                	mov    (%eax),%eax
  801ecf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ed2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ed5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801eda:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	01 c8                	add    %ecx,%eax
  801eeb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801eed:	39 c2                	cmp    %eax,%edx
  801eef:	75 09                	jne    801efa <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  801ef1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801ef8:	eb 12                	jmp    801f0c <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801efa:	ff 45 e8             	incl   -0x18(%ebp)
  801efd:	a1 20 30 80 00       	mov    0x803020,%eax
  801f02:	8b 50 74             	mov    0x74(%eax),%edx
  801f05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f08:	39 c2                	cmp    %eax,%edx
  801f0a:	77 94                	ja     801ea0 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801f0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f10:	75 14                	jne    801f26 <CheckWSWithoutLastIndex+0xef>
			panic(
  801f12:	83 ec 04             	sub    $0x4,%esp
  801f15:	68 b4 27 80 00       	push   $0x8027b4
  801f1a:	6a 3a                	push   $0x3a
  801f1c:	68 a8 27 80 00       	push   $0x8027a8
  801f21:	e8 9f fe ff ff       	call   801dc5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801f26:	ff 45 f0             	incl   -0x10(%ebp)
  801f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f2f:	0f 8c 3e ff ff ff    	jl     801e73 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801f35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801f3c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f43:	eb 20                	jmp    801f65 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801f45:	a1 20 30 80 00       	mov    0x803020,%eax
  801f4a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801f50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f53:	c1 e2 04             	shl    $0x4,%edx
  801f56:	01 d0                	add    %edx,%eax
  801f58:	8a 40 04             	mov    0x4(%eax),%al
  801f5b:	3c 01                	cmp    $0x1,%al
  801f5d:	75 03                	jne    801f62 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  801f5f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801f62:	ff 45 e0             	incl   -0x20(%ebp)
  801f65:	a1 20 30 80 00       	mov    0x803020,%eax
  801f6a:	8b 50 74             	mov    0x74(%eax),%edx
  801f6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f70:	39 c2                	cmp    %eax,%edx
  801f72:	77 d1                	ja     801f45 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f77:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f7a:	74 14                	je     801f90 <CheckWSWithoutLastIndex+0x159>
		panic(
  801f7c:	83 ec 04             	sub    $0x4,%esp
  801f7f:	68 08 28 80 00       	push   $0x802808
  801f84:	6a 44                	push   $0x44
  801f86:	68 a8 27 80 00       	push   $0x8027a8
  801f8b:	e8 35 fe ff ff       	call   801dc5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801f90:	90                   	nop
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    
  801f93:	90                   	nop

00801f94 <__udivdi3>:
  801f94:	55                   	push   %ebp
  801f95:	57                   	push   %edi
  801f96:	56                   	push   %esi
  801f97:	53                   	push   %ebx
  801f98:	83 ec 1c             	sub    $0x1c,%esp
  801f9b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f9f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801fa3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fa7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fab:	89 ca                	mov    %ecx,%edx
  801fad:	89 f8                	mov    %edi,%eax
  801faf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801fb3:	85 f6                	test   %esi,%esi
  801fb5:	75 2d                	jne    801fe4 <__udivdi3+0x50>
  801fb7:	39 cf                	cmp    %ecx,%edi
  801fb9:	77 65                	ja     802020 <__udivdi3+0x8c>
  801fbb:	89 fd                	mov    %edi,%ebp
  801fbd:	85 ff                	test   %edi,%edi
  801fbf:	75 0b                	jne    801fcc <__udivdi3+0x38>
  801fc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc6:	31 d2                	xor    %edx,%edx
  801fc8:	f7 f7                	div    %edi
  801fca:	89 c5                	mov    %eax,%ebp
  801fcc:	31 d2                	xor    %edx,%edx
  801fce:	89 c8                	mov    %ecx,%eax
  801fd0:	f7 f5                	div    %ebp
  801fd2:	89 c1                	mov    %eax,%ecx
  801fd4:	89 d8                	mov    %ebx,%eax
  801fd6:	f7 f5                	div    %ebp
  801fd8:	89 cf                	mov    %ecx,%edi
  801fda:	89 fa                	mov    %edi,%edx
  801fdc:	83 c4 1c             	add    $0x1c,%esp
  801fdf:	5b                   	pop    %ebx
  801fe0:	5e                   	pop    %esi
  801fe1:	5f                   	pop    %edi
  801fe2:	5d                   	pop    %ebp
  801fe3:	c3                   	ret    
  801fe4:	39 ce                	cmp    %ecx,%esi
  801fe6:	77 28                	ja     802010 <__udivdi3+0x7c>
  801fe8:	0f bd fe             	bsr    %esi,%edi
  801feb:	83 f7 1f             	xor    $0x1f,%edi
  801fee:	75 40                	jne    802030 <__udivdi3+0x9c>
  801ff0:	39 ce                	cmp    %ecx,%esi
  801ff2:	72 0a                	jb     801ffe <__udivdi3+0x6a>
  801ff4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ff8:	0f 87 9e 00 00 00    	ja     80209c <__udivdi3+0x108>
  801ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  802003:	89 fa                	mov    %edi,%edx
  802005:	83 c4 1c             	add    $0x1c,%esp
  802008:	5b                   	pop    %ebx
  802009:	5e                   	pop    %esi
  80200a:	5f                   	pop    %edi
  80200b:	5d                   	pop    %ebp
  80200c:	c3                   	ret    
  80200d:	8d 76 00             	lea    0x0(%esi),%esi
  802010:	31 ff                	xor    %edi,%edi
  802012:	31 c0                	xor    %eax,%eax
  802014:	89 fa                	mov    %edi,%edx
  802016:	83 c4 1c             	add    $0x1c,%esp
  802019:	5b                   	pop    %ebx
  80201a:	5e                   	pop    %esi
  80201b:	5f                   	pop    %edi
  80201c:	5d                   	pop    %ebp
  80201d:	c3                   	ret    
  80201e:	66 90                	xchg   %ax,%ax
  802020:	89 d8                	mov    %ebx,%eax
  802022:	f7 f7                	div    %edi
  802024:	31 ff                	xor    %edi,%edi
  802026:	89 fa                	mov    %edi,%edx
  802028:	83 c4 1c             	add    $0x1c,%esp
  80202b:	5b                   	pop    %ebx
  80202c:	5e                   	pop    %esi
  80202d:	5f                   	pop    %edi
  80202e:	5d                   	pop    %ebp
  80202f:	c3                   	ret    
  802030:	bd 20 00 00 00       	mov    $0x20,%ebp
  802035:	89 eb                	mov    %ebp,%ebx
  802037:	29 fb                	sub    %edi,%ebx
  802039:	89 f9                	mov    %edi,%ecx
  80203b:	d3 e6                	shl    %cl,%esi
  80203d:	89 c5                	mov    %eax,%ebp
  80203f:	88 d9                	mov    %bl,%cl
  802041:	d3 ed                	shr    %cl,%ebp
  802043:	89 e9                	mov    %ebp,%ecx
  802045:	09 f1                	or     %esi,%ecx
  802047:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80204b:	89 f9                	mov    %edi,%ecx
  80204d:	d3 e0                	shl    %cl,%eax
  80204f:	89 c5                	mov    %eax,%ebp
  802051:	89 d6                	mov    %edx,%esi
  802053:	88 d9                	mov    %bl,%cl
  802055:	d3 ee                	shr    %cl,%esi
  802057:	89 f9                	mov    %edi,%ecx
  802059:	d3 e2                	shl    %cl,%edx
  80205b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80205f:	88 d9                	mov    %bl,%cl
  802061:	d3 e8                	shr    %cl,%eax
  802063:	09 c2                	or     %eax,%edx
  802065:	89 d0                	mov    %edx,%eax
  802067:	89 f2                	mov    %esi,%edx
  802069:	f7 74 24 0c          	divl   0xc(%esp)
  80206d:	89 d6                	mov    %edx,%esi
  80206f:	89 c3                	mov    %eax,%ebx
  802071:	f7 e5                	mul    %ebp
  802073:	39 d6                	cmp    %edx,%esi
  802075:	72 19                	jb     802090 <__udivdi3+0xfc>
  802077:	74 0b                	je     802084 <__udivdi3+0xf0>
  802079:	89 d8                	mov    %ebx,%eax
  80207b:	31 ff                	xor    %edi,%edi
  80207d:	e9 58 ff ff ff       	jmp    801fda <__udivdi3+0x46>
  802082:	66 90                	xchg   %ax,%ax
  802084:	8b 54 24 08          	mov    0x8(%esp),%edx
  802088:	89 f9                	mov    %edi,%ecx
  80208a:	d3 e2                	shl    %cl,%edx
  80208c:	39 c2                	cmp    %eax,%edx
  80208e:	73 e9                	jae    802079 <__udivdi3+0xe5>
  802090:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802093:	31 ff                	xor    %edi,%edi
  802095:	e9 40 ff ff ff       	jmp    801fda <__udivdi3+0x46>
  80209a:	66 90                	xchg   %ax,%ax
  80209c:	31 c0                	xor    %eax,%eax
  80209e:	e9 37 ff ff ff       	jmp    801fda <__udivdi3+0x46>
  8020a3:	90                   	nop

008020a4 <__umoddi3>:
  8020a4:	55                   	push   %ebp
  8020a5:	57                   	push   %edi
  8020a6:	56                   	push   %esi
  8020a7:	53                   	push   %ebx
  8020a8:	83 ec 1c             	sub    $0x1c,%esp
  8020ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8020af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8020bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020c3:	89 f3                	mov    %esi,%ebx
  8020c5:	89 fa                	mov    %edi,%edx
  8020c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020cb:	89 34 24             	mov    %esi,(%esp)
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	75 1a                	jne    8020ec <__umoddi3+0x48>
  8020d2:	39 f7                	cmp    %esi,%edi
  8020d4:	0f 86 a2 00 00 00    	jbe    80217c <__umoddi3+0xd8>
  8020da:	89 c8                	mov    %ecx,%eax
  8020dc:	89 f2                	mov    %esi,%edx
  8020de:	f7 f7                	div    %edi
  8020e0:	89 d0                	mov    %edx,%eax
  8020e2:	31 d2                	xor    %edx,%edx
  8020e4:	83 c4 1c             	add    $0x1c,%esp
  8020e7:	5b                   	pop    %ebx
  8020e8:	5e                   	pop    %esi
  8020e9:	5f                   	pop    %edi
  8020ea:	5d                   	pop    %ebp
  8020eb:	c3                   	ret    
  8020ec:	39 f0                	cmp    %esi,%eax
  8020ee:	0f 87 ac 00 00 00    	ja     8021a0 <__umoddi3+0xfc>
  8020f4:	0f bd e8             	bsr    %eax,%ebp
  8020f7:	83 f5 1f             	xor    $0x1f,%ebp
  8020fa:	0f 84 ac 00 00 00    	je     8021ac <__umoddi3+0x108>
  802100:	bf 20 00 00 00       	mov    $0x20,%edi
  802105:	29 ef                	sub    %ebp,%edi
  802107:	89 fe                	mov    %edi,%esi
  802109:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80210d:	89 e9                	mov    %ebp,%ecx
  80210f:	d3 e0                	shl    %cl,%eax
  802111:	89 d7                	mov    %edx,%edi
  802113:	89 f1                	mov    %esi,%ecx
  802115:	d3 ef                	shr    %cl,%edi
  802117:	09 c7                	or     %eax,%edi
  802119:	89 e9                	mov    %ebp,%ecx
  80211b:	d3 e2                	shl    %cl,%edx
  80211d:	89 14 24             	mov    %edx,(%esp)
  802120:	89 d8                	mov    %ebx,%eax
  802122:	d3 e0                	shl    %cl,%eax
  802124:	89 c2                	mov    %eax,%edx
  802126:	8b 44 24 08          	mov    0x8(%esp),%eax
  80212a:	d3 e0                	shl    %cl,%eax
  80212c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802130:	8b 44 24 08          	mov    0x8(%esp),%eax
  802134:	89 f1                	mov    %esi,%ecx
  802136:	d3 e8                	shr    %cl,%eax
  802138:	09 d0                	or     %edx,%eax
  80213a:	d3 eb                	shr    %cl,%ebx
  80213c:	89 da                	mov    %ebx,%edx
  80213e:	f7 f7                	div    %edi
  802140:	89 d3                	mov    %edx,%ebx
  802142:	f7 24 24             	mull   (%esp)
  802145:	89 c6                	mov    %eax,%esi
  802147:	89 d1                	mov    %edx,%ecx
  802149:	39 d3                	cmp    %edx,%ebx
  80214b:	0f 82 87 00 00 00    	jb     8021d8 <__umoddi3+0x134>
  802151:	0f 84 91 00 00 00    	je     8021e8 <__umoddi3+0x144>
  802157:	8b 54 24 04          	mov    0x4(%esp),%edx
  80215b:	29 f2                	sub    %esi,%edx
  80215d:	19 cb                	sbb    %ecx,%ebx
  80215f:	89 d8                	mov    %ebx,%eax
  802161:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802165:	d3 e0                	shl    %cl,%eax
  802167:	89 e9                	mov    %ebp,%ecx
  802169:	d3 ea                	shr    %cl,%edx
  80216b:	09 d0                	or     %edx,%eax
  80216d:	89 e9                	mov    %ebp,%ecx
  80216f:	d3 eb                	shr    %cl,%ebx
  802171:	89 da                	mov    %ebx,%edx
  802173:	83 c4 1c             	add    $0x1c,%esp
  802176:	5b                   	pop    %ebx
  802177:	5e                   	pop    %esi
  802178:	5f                   	pop    %edi
  802179:	5d                   	pop    %ebp
  80217a:	c3                   	ret    
  80217b:	90                   	nop
  80217c:	89 fd                	mov    %edi,%ebp
  80217e:	85 ff                	test   %edi,%edi
  802180:	75 0b                	jne    80218d <__umoddi3+0xe9>
  802182:	b8 01 00 00 00       	mov    $0x1,%eax
  802187:	31 d2                	xor    %edx,%edx
  802189:	f7 f7                	div    %edi
  80218b:	89 c5                	mov    %eax,%ebp
  80218d:	89 f0                	mov    %esi,%eax
  80218f:	31 d2                	xor    %edx,%edx
  802191:	f7 f5                	div    %ebp
  802193:	89 c8                	mov    %ecx,%eax
  802195:	f7 f5                	div    %ebp
  802197:	89 d0                	mov    %edx,%eax
  802199:	e9 44 ff ff ff       	jmp    8020e2 <__umoddi3+0x3e>
  80219e:	66 90                	xchg   %ax,%ax
  8021a0:	89 c8                	mov    %ecx,%eax
  8021a2:	89 f2                	mov    %esi,%edx
  8021a4:	83 c4 1c             	add    $0x1c,%esp
  8021a7:	5b                   	pop    %ebx
  8021a8:	5e                   	pop    %esi
  8021a9:	5f                   	pop    %edi
  8021aa:	5d                   	pop    %ebp
  8021ab:	c3                   	ret    
  8021ac:	3b 04 24             	cmp    (%esp),%eax
  8021af:	72 06                	jb     8021b7 <__umoddi3+0x113>
  8021b1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8021b5:	77 0f                	ja     8021c6 <__umoddi3+0x122>
  8021b7:	89 f2                	mov    %esi,%edx
  8021b9:	29 f9                	sub    %edi,%ecx
  8021bb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8021bf:	89 14 24             	mov    %edx,(%esp)
  8021c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021c6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021ca:	8b 14 24             	mov    (%esp),%edx
  8021cd:	83 c4 1c             	add    $0x1c,%esp
  8021d0:	5b                   	pop    %ebx
  8021d1:	5e                   	pop    %esi
  8021d2:	5f                   	pop    %edi
  8021d3:	5d                   	pop    %ebp
  8021d4:	c3                   	ret    
  8021d5:	8d 76 00             	lea    0x0(%esi),%esi
  8021d8:	2b 04 24             	sub    (%esp),%eax
  8021db:	19 fa                	sbb    %edi,%edx
  8021dd:	89 d1                	mov    %edx,%ecx
  8021df:	89 c6                	mov    %eax,%esi
  8021e1:	e9 71 ff ff ff       	jmp    802157 <__umoddi3+0xb3>
  8021e6:	66 90                	xchg   %ax,%ax
  8021e8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8021ec:	72 ea                	jb     8021d8 <__umoddi3+0x134>
  8021ee:	89 d9                	mov    %ebx,%ecx
  8021f0:	e9 62 ff ff ff       	jmp    802157 <__umoddi3+0xb3>
