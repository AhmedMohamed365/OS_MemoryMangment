
obj/user/MidTermEx_ProcessA:     file format elf32-i386


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
  800031:	e8 36 01 00 00       	call   80016c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 f1 17 00 00       	call   801834 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 c0 22 80 00       	push   $0x8022c0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 76 16 00 00       	call   8016cc <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 c2 22 80 00       	push   $0x8022c2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 60 16 00 00       	call   8016cc <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 c9 22 80 00       	push   $0x8022c9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 4a 16 00 00       	call   8016cc <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 fd 1a 00 00       	call   801b91 <sys_get_virtual_time>
  800094:	83 c4 0c             	add    $0xc,%esp
  800097:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80009a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	f7 f1                	div    %ecx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	50                   	push   %eax
  8000b7:	e8 1b 1d 00 00       	call   801dd7 <env_sleep>
  8000bc:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Y = (*X) * 2 ;
  8000bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	01 c0                	add    %eax,%eax
  8000c6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 bc 1a 00 00       	call   801b91 <sys_get_virtual_time>
  8000d5:	83 c4 0c             	add    $0xc,%esp
  8000d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000db:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e5:	f7 f1                	div    %ecx
  8000e7:	89 d0                	mov    %edx,%eax
  8000e9:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 da 1c 00 00       	call   801dd7 <env_sleep>
  8000fd:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Y ;
  800100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800103:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800106:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800108:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 7d 1a 00 00       	call   801b91 <sys_get_virtual_time>
  800114:	83 c4 0c             	add    $0xc,%esp
  800117:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80011f:	ba 00 00 00 00       	mov    $0x0,%edx
  800124:	f7 f1                	div    %ecx
  800126:	89 d0                	mov    %edx,%eax
  800128:	05 d0 07 00 00       	add    $0x7d0,%eax
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  800130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	50                   	push   %eax
  800137:	e8 9b 1c 00 00       	call   801dd7 <env_sleep>
  80013c:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	if (*useSem == 1)
  80013f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800142:	8b 00                	mov    (%eax),%eax
  800144:	83 f8 01             	cmp    $0x1,%eax
  800147:	75 13                	jne    80015c <_main+0x124>
	{
		sys_signalSemaphore(parentenvID, "T") ;
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 d7 22 80 00       	push   $0x8022d7
  800151:	ff 75 f4             	pushl  -0xc(%ebp)
  800154:	e8 28 19 00 00       	call   801a81 <sys_signalSemaphore>
  800159:	83 c4 10             	add    $0x10,%esp
	}

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015f:	8b 00                	mov    (%eax),%eax
  800161:	8d 50 01             	lea    0x1(%eax),%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	89 10                	mov    %edx,(%eax)

}
  800169:	90                   	nop
  80016a:	c9                   	leave  
  80016b:	c3                   	ret    

0080016c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800172:	e8 a4 16 00 00       	call   80181b <sys_getenvindex>
  800177:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80017a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017d:	89 d0                	mov    %edx,%eax
  80017f:	c1 e0 03             	shl    $0x3,%eax
  800182:	01 d0                	add    %edx,%eax
  800184:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80018b:	01 c8                	add    %ecx,%eax
  80018d:	01 c0                	add    %eax,%eax
  80018f:	01 d0                	add    %edx,%eax
  800191:	01 c0                	add    %eax,%eax
  800193:	01 d0                	add    %edx,%eax
  800195:	89 c2                	mov    %eax,%edx
  800197:	c1 e2 05             	shl    $0x5,%edx
  80019a:	29 c2                	sub    %eax,%edx
  80019c:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001a3:	89 c2                	mov    %eax,%edx
  8001a5:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001ab:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b5:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001bb:	84 c0                	test   %al,%al
  8001bd:	74 0f                	je     8001ce <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c4:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001c9:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d2:	7e 0a                	jle    8001de <libmain+0x72>
		binaryname = argv[0];
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	8b 00                	mov    (%eax),%eax
  8001d9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001de:	83 ec 08             	sub    $0x8,%esp
  8001e1:	ff 75 0c             	pushl  0xc(%ebp)
  8001e4:	ff 75 08             	pushl  0x8(%ebp)
  8001e7:	e8 4c fe ff ff       	call   800038 <_main>
  8001ec:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001ef:	e8 c2 17 00 00       	call   8019b6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 f4 22 80 00       	push   $0x8022f4
  8001fc:	e8 84 01 00 00       	call   800385 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800204:	a1 20 30 80 00       	mov    0x803020,%eax
  800209:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80020f:	a1 20 30 80 00       	mov    0x803020,%eax
  800214:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80021a:	83 ec 04             	sub    $0x4,%esp
  80021d:	52                   	push   %edx
  80021e:	50                   	push   %eax
  80021f:	68 1c 23 80 00       	push   $0x80231c
  800224:	e8 5c 01 00 00       	call   800385 <cprintf>
  800229:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80022c:	a1 20 30 80 00       	mov    0x803020,%eax
  800231:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800237:	a1 20 30 80 00       	mov    0x803020,%eax
  80023c:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	52                   	push   %edx
  800246:	50                   	push   %eax
  800247:	68 44 23 80 00       	push   $0x802344
  80024c:	e8 34 01 00 00       	call   800385 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800254:	a1 20 30 80 00       	mov    0x803020,%eax
  800259:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	50                   	push   %eax
  800263:	68 85 23 80 00       	push   $0x802385
  800268:	e8 18 01 00 00       	call   800385 <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 f4 22 80 00       	push   $0x8022f4
  800278:	e8 08 01 00 00       	call   800385 <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800280:	e8 4b 17 00 00       	call   8019d0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800285:	e8 19 00 00 00       	call   8002a3 <exit>
}
  80028a:	90                   	nop
  80028b:	c9                   	leave  
  80028c:	c3                   	ret    

0080028d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800293:	83 ec 0c             	sub    $0xc,%esp
  800296:	6a 00                	push   $0x0
  800298:	e8 4a 15 00 00       	call   8017e7 <sys_env_destroy>
  80029d:	83 c4 10             	add    $0x10,%esp
}
  8002a0:	90                   	nop
  8002a1:	c9                   	leave  
  8002a2:	c3                   	ret    

008002a3 <exit>:

void
exit(void)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002a9:	e8 9f 15 00 00       	call   80184d <sys_env_exit>
}
  8002ae:	90                   	nop
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	8b 00                	mov    (%eax),%eax
  8002bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8002bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c2:	89 0a                	mov    %ecx,(%edx)
  8002c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c7:	88 d1                	mov    %dl,%cl
  8002c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d3:	8b 00                	mov    (%eax),%eax
  8002d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002da:	75 2c                	jne    800308 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002dc:	a0 24 30 80 00       	mov    0x803024,%al
  8002e1:	0f b6 c0             	movzbl %al,%eax
  8002e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e7:	8b 12                	mov    (%edx),%edx
  8002e9:	89 d1                	mov    %edx,%ecx
  8002eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ee:	83 c2 08             	add    $0x8,%edx
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	50                   	push   %eax
  8002f5:	51                   	push   %ecx
  8002f6:	52                   	push   %edx
  8002f7:	e8 a9 14 00 00       	call   8017a5 <sys_cputs>
  8002fc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030b:	8b 40 04             	mov    0x4(%eax),%eax
  80030e:	8d 50 01             	lea    0x1(%eax),%edx
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	89 50 04             	mov    %edx,0x4(%eax)
}
  800317:	90                   	nop
  800318:	c9                   	leave  
  800319:	c3                   	ret    

0080031a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800323:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032a:	00 00 00 
	b.cnt = 0;
  80032d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800334:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800337:	ff 75 0c             	pushl  0xc(%ebp)
  80033a:	ff 75 08             	pushl  0x8(%ebp)
  80033d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800343:	50                   	push   %eax
  800344:	68 b1 02 80 00       	push   $0x8002b1
  800349:	e8 11 02 00 00       	call   80055f <vprintfmt>
  80034e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800351:	a0 24 30 80 00       	mov    0x803024,%al
  800356:	0f b6 c0             	movzbl %al,%eax
  800359:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	50                   	push   %eax
  800363:	52                   	push   %edx
  800364:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80036a:	83 c0 08             	add    $0x8,%eax
  80036d:	50                   	push   %eax
  80036e:	e8 32 14 00 00       	call   8017a5 <sys_cputs>
  800373:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800376:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80037d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800383:	c9                   	leave  
  800384:	c3                   	ret    

00800385 <cprintf>:

int cprintf(const char *fmt, ...) {
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80038b:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800392:	8d 45 0c             	lea    0xc(%ebp),%eax
  800395:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800398:	8b 45 08             	mov    0x8(%ebp),%eax
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a1:	50                   	push   %eax
  8003a2:	e8 73 ff ff ff       	call   80031a <vcprintf>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003b0:	c9                   	leave  
  8003b1:	c3                   	ret    

008003b2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003b8:	e8 f9 15 00 00       	call   8019b6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c6:	83 ec 08             	sub    $0x8,%esp
  8003c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8003cc:	50                   	push   %eax
  8003cd:	e8 48 ff ff ff       	call   80031a <vcprintf>
  8003d2:	83 c4 10             	add    $0x10,%esp
  8003d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003d8:	e8 f3 15 00 00       	call   8019d0 <sys_enable_interrupt>
	return cnt;
  8003dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	53                   	push   %ebx
  8003e6:	83 ec 14             	sub    $0x14,%esp
  8003e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800400:	77 55                	ja     800457 <printnum+0x75>
  800402:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800405:	72 05                	jb     80040c <printnum+0x2a>
  800407:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80040a:	77 4b                	ja     800457 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80040c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80040f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800412:	8b 45 18             	mov    0x18(%ebp),%eax
  800415:	ba 00 00 00 00       	mov    $0x0,%edx
  80041a:	52                   	push   %edx
  80041b:	50                   	push   %eax
  80041c:	ff 75 f4             	pushl  -0xc(%ebp)
  80041f:	ff 75 f0             	pushl  -0x10(%ebp)
  800422:	e8 35 1c 00 00       	call   80205c <__udivdi3>
  800427:	83 c4 10             	add    $0x10,%esp
  80042a:	83 ec 04             	sub    $0x4,%esp
  80042d:	ff 75 20             	pushl  0x20(%ebp)
  800430:	53                   	push   %ebx
  800431:	ff 75 18             	pushl  0x18(%ebp)
  800434:	52                   	push   %edx
  800435:	50                   	push   %eax
  800436:	ff 75 0c             	pushl  0xc(%ebp)
  800439:	ff 75 08             	pushl  0x8(%ebp)
  80043c:	e8 a1 ff ff ff       	call   8003e2 <printnum>
  800441:	83 c4 20             	add    $0x20,%esp
  800444:	eb 1a                	jmp    800460 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	ff 75 0c             	pushl  0xc(%ebp)
  80044c:	ff 75 20             	pushl  0x20(%ebp)
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	ff d0                	call   *%eax
  800454:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800457:	ff 4d 1c             	decl   0x1c(%ebp)
  80045a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80045e:	7f e6                	jg     800446 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800460:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800463:	bb 00 00 00 00       	mov    $0x0,%ebx
  800468:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80046b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80046e:	53                   	push   %ebx
  80046f:	51                   	push   %ecx
  800470:	52                   	push   %edx
  800471:	50                   	push   %eax
  800472:	e8 f5 1c 00 00       	call   80216c <__umoddi3>
  800477:	83 c4 10             	add    $0x10,%esp
  80047a:	05 b4 25 80 00       	add    $0x8025b4,%eax
  80047f:	8a 00                	mov    (%eax),%al
  800481:	0f be c0             	movsbl %al,%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	ff 75 0c             	pushl  0xc(%ebp)
  80048a:	50                   	push   %eax
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	ff d0                	call   *%eax
  800490:	83 c4 10             	add    $0x10,%esp
}
  800493:	90                   	nop
  800494:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80049c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004a0:	7e 1c                	jle    8004be <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a5:	8b 00                	mov    (%eax),%eax
  8004a7:	8d 50 08             	lea    0x8(%eax),%edx
  8004aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ad:	89 10                	mov    %edx,(%eax)
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	83 e8 08             	sub    $0x8,%eax
  8004b7:	8b 50 04             	mov    0x4(%eax),%edx
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	eb 40                	jmp    8004fe <getuint+0x65>
	else if (lflag)
  8004be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004c2:	74 1e                	je     8004e2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	8d 50 04             	lea    0x4(%eax),%edx
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	89 10                	mov    %edx,(%eax)
  8004d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d4:	8b 00                	mov    (%eax),%eax
  8004d6:	83 e8 04             	sub    $0x4,%eax
  8004d9:	8b 00                	mov    (%eax),%eax
  8004db:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e0:	eb 1c                	jmp    8004fe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	8d 50 04             	lea    0x4(%eax),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	89 10                	mov    %edx,(%eax)
  8004ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	83 e8 04             	sub    $0x4,%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004fe:	5d                   	pop    %ebp
  8004ff:	c3                   	ret    

00800500 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800503:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800507:	7e 1c                	jle    800525 <getint+0x25>
		return va_arg(*ap, long long);
  800509:	8b 45 08             	mov    0x8(%ebp),%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	8d 50 08             	lea    0x8(%eax),%edx
  800511:	8b 45 08             	mov    0x8(%ebp),%eax
  800514:	89 10                	mov    %edx,(%eax)
  800516:	8b 45 08             	mov    0x8(%ebp),%eax
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	83 e8 08             	sub    $0x8,%eax
  80051e:	8b 50 04             	mov    0x4(%eax),%edx
  800521:	8b 00                	mov    (%eax),%eax
  800523:	eb 38                	jmp    80055d <getint+0x5d>
	else if (lflag)
  800525:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800529:	74 1a                	je     800545 <getint+0x45>
		return va_arg(*ap, long);
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	8d 50 04             	lea    0x4(%eax),%edx
  800533:	8b 45 08             	mov    0x8(%ebp),%eax
  800536:	89 10                	mov    %edx,(%eax)
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	83 e8 04             	sub    $0x4,%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	99                   	cltd   
  800543:	eb 18                	jmp    80055d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800545:	8b 45 08             	mov    0x8(%ebp),%eax
  800548:	8b 00                	mov    (%eax),%eax
  80054a:	8d 50 04             	lea    0x4(%eax),%edx
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	89 10                	mov    %edx,(%eax)
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	8b 00                	mov    (%eax),%eax
  800557:	83 e8 04             	sub    $0x4,%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	99                   	cltd   
}
  80055d:	5d                   	pop    %ebp
  80055e:	c3                   	ret    

0080055f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80055f:	55                   	push   %ebp
  800560:	89 e5                	mov    %esp,%ebp
  800562:	56                   	push   %esi
  800563:	53                   	push   %ebx
  800564:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800567:	eb 17                	jmp    800580 <vprintfmt+0x21>
			if (ch == '\0')
  800569:	85 db                	test   %ebx,%ebx
  80056b:	0f 84 af 03 00 00    	je     800920 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	ff 75 0c             	pushl  0xc(%ebp)
  800577:	53                   	push   %ebx
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	ff d0                	call   *%eax
  80057d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800580:	8b 45 10             	mov    0x10(%ebp),%eax
  800583:	8d 50 01             	lea    0x1(%eax),%edx
  800586:	89 55 10             	mov    %edx,0x10(%ebp)
  800589:	8a 00                	mov    (%eax),%al
  80058b:	0f b6 d8             	movzbl %al,%ebx
  80058e:	83 fb 25             	cmp    $0x25,%ebx
  800591:	75 d6                	jne    800569 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800593:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800597:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80059e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b6:	8d 50 01             	lea    0x1(%eax),%edx
  8005b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8005bc:	8a 00                	mov    (%eax),%al
  8005be:	0f b6 d8             	movzbl %al,%ebx
  8005c1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005c4:	83 f8 55             	cmp    $0x55,%eax
  8005c7:	0f 87 2b 03 00 00    	ja     8008f8 <vprintfmt+0x399>
  8005cd:	8b 04 85 d8 25 80 00 	mov    0x8025d8(,%eax,4),%eax
  8005d4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005d6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005da:	eb d7                	jmp    8005b3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005dc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005e0:	eb d1                	jmp    8005b3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ec:	89 d0                	mov    %edx,%eax
  8005ee:	c1 e0 02             	shl    $0x2,%eax
  8005f1:	01 d0                	add    %edx,%eax
  8005f3:	01 c0                	add    %eax,%eax
  8005f5:	01 d8                	add    %ebx,%eax
  8005f7:	83 e8 30             	sub    $0x30,%eax
  8005fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800600:	8a 00                	mov    (%eax),%al
  800602:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800605:	83 fb 2f             	cmp    $0x2f,%ebx
  800608:	7e 3e                	jle    800648 <vprintfmt+0xe9>
  80060a:	83 fb 39             	cmp    $0x39,%ebx
  80060d:	7f 39                	jg     800648 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80060f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800612:	eb d5                	jmp    8005e9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	83 c0 04             	add    $0x4,%eax
  80061a:	89 45 14             	mov    %eax,0x14(%ebp)
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	83 e8 04             	sub    $0x4,%eax
  800623:	8b 00                	mov    (%eax),%eax
  800625:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800628:	eb 1f                	jmp    800649 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80062a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80062e:	79 83                	jns    8005b3 <vprintfmt+0x54>
				width = 0;
  800630:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800637:	e9 77 ff ff ff       	jmp    8005b3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80063c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800643:	e9 6b ff ff ff       	jmp    8005b3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800648:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800649:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80064d:	0f 89 60 ff ff ff    	jns    8005b3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800653:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800656:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800659:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800660:	e9 4e ff ff ff       	jmp    8005b3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800665:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800668:	e9 46 ff ff ff       	jmp    8005b3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	83 c0 04             	add    $0x4,%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	83 e8 04             	sub    $0x4,%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	83 ec 08             	sub    $0x8,%esp
  800681:	ff 75 0c             	pushl  0xc(%ebp)
  800684:	50                   	push   %eax
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	ff d0                	call   *%eax
  80068a:	83 c4 10             	add    $0x10,%esp
			break;
  80068d:	e9 89 02 00 00       	jmp    80091b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	83 c0 04             	add    $0x4,%eax
  800698:	89 45 14             	mov    %eax,0x14(%ebp)
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	83 e8 04             	sub    $0x4,%eax
  8006a1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006a3:	85 db                	test   %ebx,%ebx
  8006a5:	79 02                	jns    8006a9 <vprintfmt+0x14a>
				err = -err;
  8006a7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006a9:	83 fb 64             	cmp    $0x64,%ebx
  8006ac:	7f 0b                	jg     8006b9 <vprintfmt+0x15a>
  8006ae:	8b 34 9d 20 24 80 00 	mov    0x802420(,%ebx,4),%esi
  8006b5:	85 f6                	test   %esi,%esi
  8006b7:	75 19                	jne    8006d2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b9:	53                   	push   %ebx
  8006ba:	68 c5 25 80 00       	push   $0x8025c5
  8006bf:	ff 75 0c             	pushl  0xc(%ebp)
  8006c2:	ff 75 08             	pushl  0x8(%ebp)
  8006c5:	e8 5e 02 00 00       	call   800928 <printfmt>
  8006ca:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006cd:	e9 49 02 00 00       	jmp    80091b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006d2:	56                   	push   %esi
  8006d3:	68 ce 25 80 00       	push   $0x8025ce
  8006d8:	ff 75 0c             	pushl  0xc(%ebp)
  8006db:	ff 75 08             	pushl  0x8(%ebp)
  8006de:	e8 45 02 00 00       	call   800928 <printfmt>
  8006e3:	83 c4 10             	add    $0x10,%esp
			break;
  8006e6:	e9 30 02 00 00       	jmp    80091b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	83 c0 04             	add    $0x4,%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 30                	mov    (%eax),%esi
  8006fc:	85 f6                	test   %esi,%esi
  8006fe:	75 05                	jne    800705 <vprintfmt+0x1a6>
				p = "(null)";
  800700:	be d1 25 80 00       	mov    $0x8025d1,%esi
			if (width > 0 && padc != '-')
  800705:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800709:	7e 6d                	jle    800778 <vprintfmt+0x219>
  80070b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80070f:	74 67                	je     800778 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800711:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	50                   	push   %eax
  800718:	56                   	push   %esi
  800719:	e8 0c 03 00 00       	call   800a2a <strnlen>
  80071e:	83 c4 10             	add    $0x10,%esp
  800721:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800724:	eb 16                	jmp    80073c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800726:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	ff 75 0c             	pushl  0xc(%ebp)
  800730:	50                   	push   %eax
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	ff d0                	call   *%eax
  800736:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800739:	ff 4d e4             	decl   -0x1c(%ebp)
  80073c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800740:	7f e4                	jg     800726 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800742:	eb 34                	jmp    800778 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800744:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800748:	74 1c                	je     800766 <vprintfmt+0x207>
  80074a:	83 fb 1f             	cmp    $0x1f,%ebx
  80074d:	7e 05                	jle    800754 <vprintfmt+0x1f5>
  80074f:	83 fb 7e             	cmp    $0x7e,%ebx
  800752:	7e 12                	jle    800766 <vprintfmt+0x207>
					putch('?', putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	6a 3f                	push   $0x3f
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	ff d0                	call   *%eax
  800761:	83 c4 10             	add    $0x10,%esp
  800764:	eb 0f                	jmp    800775 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	ff 75 0c             	pushl  0xc(%ebp)
  80076c:	53                   	push   %ebx
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	ff d0                	call   *%eax
  800772:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800775:	ff 4d e4             	decl   -0x1c(%ebp)
  800778:	89 f0                	mov    %esi,%eax
  80077a:	8d 70 01             	lea    0x1(%eax),%esi
  80077d:	8a 00                	mov    (%eax),%al
  80077f:	0f be d8             	movsbl %al,%ebx
  800782:	85 db                	test   %ebx,%ebx
  800784:	74 24                	je     8007aa <vprintfmt+0x24b>
  800786:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80078a:	78 b8                	js     800744 <vprintfmt+0x1e5>
  80078c:	ff 4d e0             	decl   -0x20(%ebp)
  80078f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800793:	79 af                	jns    800744 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800795:	eb 13                	jmp    8007aa <vprintfmt+0x24b>
				putch(' ', putdat);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	ff 75 0c             	pushl  0xc(%ebp)
  80079d:	6a 20                	push   $0x20
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	ff d0                	call   *%eax
  8007a4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007a7:	ff 4d e4             	decl   -0x1c(%ebp)
  8007aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ae:	7f e7                	jg     800797 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007b0:	e9 66 01 00 00       	jmp    80091b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8007bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8007be:	50                   	push   %eax
  8007bf:	e8 3c fd ff ff       	call   800500 <getint>
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d3:	85 d2                	test   %edx,%edx
  8007d5:	79 23                	jns    8007fa <vprintfmt+0x29b>
				putch('-', putdat);
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	ff 75 0c             	pushl  0xc(%ebp)
  8007dd:	6a 2d                	push   $0x2d
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	ff d0                	call   *%eax
  8007e4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ed:	f7 d8                	neg    %eax
  8007ef:	83 d2 00             	adc    $0x0,%edx
  8007f2:	f7 da                	neg    %edx
  8007f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800801:	e9 bc 00 00 00       	jmp    8008c2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 e8             	pushl  -0x18(%ebp)
  80080c:	8d 45 14             	lea    0x14(%ebp),%eax
  80080f:	50                   	push   %eax
  800810:	e8 84 fc ff ff       	call   800499 <getuint>
  800815:	83 c4 10             	add    $0x10,%esp
  800818:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80081e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800825:	e9 98 00 00 00       	jmp    8008c2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	6a 58                	push   $0x58
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	ff d0                	call   *%eax
  800837:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80083a:	83 ec 08             	sub    $0x8,%esp
  80083d:	ff 75 0c             	pushl  0xc(%ebp)
  800840:	6a 58                	push   $0x58
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	ff d0                	call   *%eax
  800847:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80084a:	83 ec 08             	sub    $0x8,%esp
  80084d:	ff 75 0c             	pushl  0xc(%ebp)
  800850:	6a 58                	push   $0x58
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	ff d0                	call   *%eax
  800857:	83 c4 10             	add    $0x10,%esp
			break;
  80085a:	e9 bc 00 00 00       	jmp    80091b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	6a 30                	push   $0x30
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	ff d0                	call   *%eax
  80086c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	6a 78                	push   $0x78
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	ff d0                	call   *%eax
  80087c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 c0 04             	add    $0x4,%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
  800888:	8b 45 14             	mov    0x14(%ebp),%eax
  80088b:	83 e8 04             	sub    $0x4,%eax
  80088e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800890:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800893:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80089a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008a1:	eb 1f                	jmp    8008c2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a9:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ac:	50                   	push   %eax
  8008ad:	e8 e7 fb ff ff       	call   800499 <getuint>
  8008b2:	83 c4 10             	add    $0x10,%esp
  8008b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008bb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008c2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c9:	83 ec 04             	sub    $0x4,%esp
  8008cc:	52                   	push   %edx
  8008cd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008d0:	50                   	push   %eax
  8008d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 00 fb ff ff       	call   8003e2 <printnum>
  8008e2:	83 c4 20             	add    $0x20,%esp
			break;
  8008e5:	eb 34                	jmp    80091b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 0c             	pushl  0xc(%ebp)
  8008ed:	53                   	push   %ebx
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	ff d0                	call   *%eax
  8008f3:	83 c4 10             	add    $0x10,%esp
			break;
  8008f6:	eb 23                	jmp    80091b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	ff 75 0c             	pushl  0xc(%ebp)
  8008fe:	6a 25                	push   $0x25
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	ff d0                	call   *%eax
  800905:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800908:	ff 4d 10             	decl   0x10(%ebp)
  80090b:	eb 03                	jmp    800910 <vprintfmt+0x3b1>
  80090d:	ff 4d 10             	decl   0x10(%ebp)
  800910:	8b 45 10             	mov    0x10(%ebp),%eax
  800913:	48                   	dec    %eax
  800914:	8a 00                	mov    (%eax),%al
  800916:	3c 25                	cmp    $0x25,%al
  800918:	75 f3                	jne    80090d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80091a:	90                   	nop
		}
	}
  80091b:	e9 47 fc ff ff       	jmp    800567 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800920:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800921:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800924:	5b                   	pop    %ebx
  800925:	5e                   	pop    %esi
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80092e:	8d 45 10             	lea    0x10(%ebp),%eax
  800931:	83 c0 04             	add    $0x4,%eax
  800934:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800937:	8b 45 10             	mov    0x10(%ebp),%eax
  80093a:	ff 75 f4             	pushl  -0xc(%ebp)
  80093d:	50                   	push   %eax
  80093e:	ff 75 0c             	pushl  0xc(%ebp)
  800941:	ff 75 08             	pushl  0x8(%ebp)
  800944:	e8 16 fc ff ff       	call   80055f <vprintfmt>
  800949:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80094c:	90                   	nop
  80094d:	c9                   	leave  
  80094e:	c3                   	ret    

0080094f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800952:	8b 45 0c             	mov    0xc(%ebp),%eax
  800955:	8b 40 08             	mov    0x8(%eax),%eax
  800958:	8d 50 01             	lea    0x1(%eax),%edx
  80095b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800961:	8b 45 0c             	mov    0xc(%ebp),%eax
  800964:	8b 10                	mov    (%eax),%edx
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 40 04             	mov    0x4(%eax),%eax
  80096c:	39 c2                	cmp    %eax,%edx
  80096e:	73 12                	jae    800982 <sprintputch+0x33>
		*b->buf++ = ch;
  800970:	8b 45 0c             	mov    0xc(%ebp),%eax
  800973:	8b 00                	mov    (%eax),%eax
  800975:	8d 48 01             	lea    0x1(%eax),%ecx
  800978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097b:	89 0a                	mov    %ecx,(%edx)
  80097d:	8b 55 08             	mov    0x8(%ebp),%edx
  800980:	88 10                	mov    %dl,(%eax)
}
  800982:	90                   	nop
  800983:	5d                   	pop    %ebp
  800984:	c3                   	ret    

00800985 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800991:	8b 45 0c             	mov    0xc(%ebp),%eax
  800994:	8d 50 ff             	lea    -0x1(%eax),%edx
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	01 d0                	add    %edx,%eax
  80099c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009aa:	74 06                	je     8009b2 <vsnprintf+0x2d>
  8009ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009b0:	7f 07                	jg     8009b9 <vsnprintf+0x34>
		return -E_INVAL;
  8009b2:	b8 03 00 00 00       	mov    $0x3,%eax
  8009b7:	eb 20                	jmp    8009d9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b9:	ff 75 14             	pushl  0x14(%ebp)
  8009bc:	ff 75 10             	pushl  0x10(%ebp)
  8009bf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009c2:	50                   	push   %eax
  8009c3:	68 4f 09 80 00       	push   $0x80094f
  8009c8:	e8 92 fb ff ff       	call   80055f <vprintfmt>
  8009cd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009d3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009d9:	c9                   	leave  
  8009da:	c3                   	ret    

008009db <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e1:	8d 45 10             	lea    0x10(%ebp),%eax
  8009e4:	83 c0 04             	add    $0x4,%eax
  8009e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f0:	50                   	push   %eax
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	ff 75 08             	pushl  0x8(%ebp)
  8009f7:	e8 89 ff ff ff       	call   800985 <vsnprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a14:	eb 06                	jmp    800a1c <strlen+0x15>
		n++;
  800a16:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a19:	ff 45 08             	incl   0x8(%ebp)
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	8a 00                	mov    (%eax),%al
  800a21:	84 c0                	test   %al,%al
  800a23:	75 f1                	jne    800a16 <strlen+0xf>
		n++;
	return n;
  800a25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a37:	eb 09                	jmp    800a42 <strnlen+0x18>
		n++;
  800a39:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3c:	ff 45 08             	incl   0x8(%ebp)
  800a3f:	ff 4d 0c             	decl   0xc(%ebp)
  800a42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a46:	74 09                	je     800a51 <strnlen+0x27>
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	8a 00                	mov    (%eax),%al
  800a4d:	84 c0                	test   %al,%al
  800a4f:	75 e8                	jne    800a39 <strnlen+0xf>
		n++;
	return n;
  800a51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a54:	c9                   	leave  
  800a55:	c3                   	ret    

00800a56 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a62:	90                   	nop
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	8d 50 01             	lea    0x1(%eax),%edx
  800a69:	89 55 08             	mov    %edx,0x8(%ebp)
  800a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a75:	8a 12                	mov    (%edx),%dl
  800a77:	88 10                	mov    %dl,(%eax)
  800a79:	8a 00                	mov    (%eax),%al
  800a7b:	84 c0                	test   %al,%al
  800a7d:	75 e4                	jne    800a63 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a82:	c9                   	leave  
  800a83:	c3                   	ret    

00800a84 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a97:	eb 1f                	jmp    800ab8 <strncpy+0x34>
		*dst++ = *src;
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8d 50 01             	lea    0x1(%eax),%edx
  800a9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa5:	8a 12                	mov    (%edx),%dl
  800aa7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aac:	8a 00                	mov    (%eax),%al
  800aae:	84 c0                	test   %al,%al
  800ab0:	74 03                	je     800ab5 <strncpy+0x31>
			src++;
  800ab2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ab5:	ff 45 fc             	incl   -0x4(%ebp)
  800ab8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800abb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800abe:	72 d9                	jb     800a99 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ac0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ac3:	c9                   	leave  
  800ac4:	c3                   	ret    

00800ac5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ad1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ad5:	74 30                	je     800b07 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ad7:	eb 16                	jmp    800aef <strlcpy+0x2a>
			*dst++ = *src++;
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8d 50 01             	lea    0x1(%eax),%edx
  800adf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ae8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aeb:	8a 12                	mov    (%edx),%dl
  800aed:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aef:	ff 4d 10             	decl   0x10(%ebp)
  800af2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800af6:	74 09                	je     800b01 <strlcpy+0x3c>
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	8a 00                	mov    (%eax),%al
  800afd:	84 c0                	test   %al,%al
  800aff:	75 d8                	jne    800ad9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b07:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b0d:	29 c2                	sub    %eax,%edx
  800b0f:	89 d0                	mov    %edx,%eax
}
  800b11:	c9                   	leave  
  800b12:	c3                   	ret    

00800b13 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b16:	eb 06                	jmp    800b1e <strcmp+0xb>
		p++, q++;
  800b18:	ff 45 08             	incl   0x8(%ebp)
  800b1b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 00                	mov    (%eax),%al
  800b23:	84 c0                	test   %al,%al
  800b25:	74 0e                	je     800b35 <strcmp+0x22>
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8a 10                	mov    (%eax),%dl
  800b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2f:	8a 00                	mov    (%eax),%al
  800b31:	38 c2                	cmp    %al,%dl
  800b33:	74 e3                	je     800b18 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	8a 00                	mov    (%eax),%al
  800b3a:	0f b6 d0             	movzbl %al,%edx
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	8a 00                	mov    (%eax),%al
  800b42:	0f b6 c0             	movzbl %al,%eax
  800b45:	29 c2                	sub    %eax,%edx
  800b47:	89 d0                	mov    %edx,%eax
}
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b4e:	eb 09                	jmp    800b59 <strncmp+0xe>
		n--, p++, q++;
  800b50:	ff 4d 10             	decl   0x10(%ebp)
  800b53:	ff 45 08             	incl   0x8(%ebp)
  800b56:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b5d:	74 17                	je     800b76 <strncmp+0x2b>
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8a 00                	mov    (%eax),%al
  800b64:	84 c0                	test   %al,%al
  800b66:	74 0e                	je     800b76 <strncmp+0x2b>
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	8a 10                	mov    (%eax),%dl
  800b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b70:	8a 00                	mov    (%eax),%al
  800b72:	38 c2                	cmp    %al,%dl
  800b74:	74 da                	je     800b50 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b7a:	75 07                	jne    800b83 <strncmp+0x38>
		return 0;
  800b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b81:	eb 14                	jmp    800b97 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8a 00                	mov    (%eax),%al
  800b88:	0f b6 d0             	movzbl %al,%edx
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	8a 00                	mov    (%eax),%al
  800b90:	0f b6 c0             	movzbl %al,%eax
  800b93:	29 c2                	sub    %eax,%edx
  800b95:	89 d0                	mov    %edx,%eax
}
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	83 ec 04             	sub    $0x4,%esp
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ba5:	eb 12                	jmp    800bb9 <strchr+0x20>
		if (*s == c)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800baf:	75 05                	jne    800bb6 <strchr+0x1d>
			return (char *) s;
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	eb 11                	jmp    800bc7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bb6:	ff 45 08             	incl   0x8(%ebp)
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8a 00                	mov    (%eax),%al
  800bbe:	84 c0                	test   %al,%al
  800bc0:	75 e5                	jne    800ba7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc7:	c9                   	leave  
  800bc8:	c3                   	ret    

00800bc9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 04             	sub    $0x4,%esp
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bd5:	eb 0d                	jmp    800be4 <strfind+0x1b>
		if (*s == c)
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	8a 00                	mov    (%eax),%al
  800bdc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bdf:	74 0e                	je     800bef <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800be1:	ff 45 08             	incl   0x8(%ebp)
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8a 00                	mov    (%eax),%al
  800be9:	84 c0                	test   %al,%al
  800beb:	75 ea                	jne    800bd7 <strfind+0xe>
  800bed:	eb 01                	jmp    800bf0 <strfind+0x27>
		if (*s == c)
			break;
  800bef:	90                   	nop
	return (char *) s;
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bf3:	c9                   	leave  
  800bf4:	c3                   	ret    

00800bf5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c01:	8b 45 10             	mov    0x10(%ebp),%eax
  800c04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c07:	eb 0e                	jmp    800c17 <memset+0x22>
		*p++ = c;
  800c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c0c:	8d 50 01             	lea    0x1(%eax),%edx
  800c0f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c15:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c17:	ff 4d f8             	decl   -0x8(%ebp)
  800c1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c1e:	79 e9                	jns    800c09 <memset+0x14>
		*p++ = c;

	return v;
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c23:	c9                   	leave  
  800c24:	c3                   	ret    

00800c25 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c37:	eb 16                	jmp    800c4f <memcpy+0x2a>
		*d++ = *s++;
  800c39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c3c:	8d 50 01             	lea    0x1(%eax),%edx
  800c3f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c48:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c4b:	8a 12                	mov    (%edx),%dl
  800c4d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c55:	89 55 10             	mov    %edx,0x10(%ebp)
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	75 dd                	jne    800c39 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c5f:	c9                   	leave  
  800c60:	c3                   	ret    

00800c61 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c79:	73 50                	jae    800ccb <memmove+0x6a>
  800c7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	01 d0                	add    %edx,%eax
  800c83:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c86:	76 43                	jbe    800ccb <memmove+0x6a>
		s += n;
  800c88:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c91:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c94:	eb 10                	jmp    800ca6 <memmove+0x45>
			*--d = *--s;
  800c96:	ff 4d f8             	decl   -0x8(%ebp)
  800c99:	ff 4d fc             	decl   -0x4(%ebp)
  800c9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9f:	8a 10                	mov    (%eax),%dl
  800ca1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ca4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ca6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cac:	89 55 10             	mov    %edx,0x10(%ebp)
  800caf:	85 c0                	test   %eax,%eax
  800cb1:	75 e3                	jne    800c96 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cb3:	eb 23                	jmp    800cd8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cb8:	8d 50 01             	lea    0x1(%eax),%edx
  800cbb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cbe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cc1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cc7:	8a 12                	mov    (%edx),%dl
  800cc9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ccb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cce:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd1:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd4:	85 c0                	test   %eax,%eax
  800cd6:	75 dd                	jne    800cb5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cec:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cef:	eb 2a                	jmp    800d1b <memcmp+0x3e>
		if (*s1 != *s2)
  800cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf4:	8a 10                	mov    (%eax),%dl
  800cf6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	38 c2                	cmp    %al,%dl
  800cfd:	74 16                	je     800d15 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	0f b6 d0             	movzbl %al,%edx
  800d07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	0f b6 c0             	movzbl %al,%eax
  800d0f:	29 c2                	sub    %eax,%edx
  800d11:	89 d0                	mov    %edx,%eax
  800d13:	eb 18                	jmp    800d2d <memcmp+0x50>
		s1++, s2++;
  800d15:	ff 45 fc             	incl   -0x4(%ebp)
  800d18:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d21:	89 55 10             	mov    %edx,0x10(%ebp)
  800d24:	85 c0                	test   %eax,%eax
  800d26:	75 c9                	jne    800cf1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d2d:	c9                   	leave  
  800d2e:	c3                   	ret    

00800d2f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3b:	01 d0                	add    %edx,%eax
  800d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d40:	eb 15                	jmp    800d57 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	0f b6 d0             	movzbl %al,%edx
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	0f b6 c0             	movzbl %al,%eax
  800d50:	39 c2                	cmp    %eax,%edx
  800d52:	74 0d                	je     800d61 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d54:	ff 45 08             	incl   0x8(%ebp)
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d5d:	72 e3                	jb     800d42 <memfind+0x13>
  800d5f:	eb 01                	jmp    800d62 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d61:	90                   	nop
	return (void *) s;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d65:	c9                   	leave  
  800d66:	c3                   	ret    

00800d67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d74:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d7b:	eb 03                	jmp    800d80 <strtol+0x19>
		s++;
  800d7d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3c 20                	cmp    $0x20,%al
  800d87:	74 f4                	je     800d7d <strtol+0x16>
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	3c 09                	cmp    $0x9,%al
  800d90:	74 eb                	je     800d7d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	3c 2b                	cmp    $0x2b,%al
  800d99:	75 05                	jne    800da0 <strtol+0x39>
		s++;
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	eb 13                	jmp    800db3 <strtol+0x4c>
	else if (*s == '-')
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	3c 2d                	cmp    $0x2d,%al
  800da7:	75 0a                	jne    800db3 <strtol+0x4c>
		s++, neg = 1;
  800da9:	ff 45 08             	incl   0x8(%ebp)
  800dac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db7:	74 06                	je     800dbf <strtol+0x58>
  800db9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800dbd:	75 20                	jne    800ddf <strtol+0x78>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3c 30                	cmp    $0x30,%al
  800dc6:	75 17                	jne    800ddf <strtol+0x78>
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	40                   	inc    %eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	3c 78                	cmp    $0x78,%al
  800dd0:	75 0d                	jne    800ddf <strtol+0x78>
		s += 2, base = 16;
  800dd2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dd6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ddd:	eb 28                	jmp    800e07 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ddf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de3:	75 15                	jne    800dfa <strtol+0x93>
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	3c 30                	cmp    $0x30,%al
  800dec:	75 0c                	jne    800dfa <strtol+0x93>
		s++, base = 8;
  800dee:	ff 45 08             	incl   0x8(%ebp)
  800df1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800df8:	eb 0d                	jmp    800e07 <strtol+0xa0>
	else if (base == 0)
  800dfa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfe:	75 07                	jne    800e07 <strtol+0xa0>
		base = 10;
  800e00:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	3c 2f                	cmp    $0x2f,%al
  800e0e:	7e 19                	jle    800e29 <strtol+0xc2>
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	3c 39                	cmp    $0x39,%al
  800e17:	7f 10                	jg     800e29 <strtol+0xc2>
			dig = *s - '0';
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	8a 00                	mov    (%eax),%al
  800e1e:	0f be c0             	movsbl %al,%eax
  800e21:	83 e8 30             	sub    $0x30,%eax
  800e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e27:	eb 42                	jmp    800e6b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	3c 60                	cmp    $0x60,%al
  800e30:	7e 19                	jle    800e4b <strtol+0xe4>
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	3c 7a                	cmp    $0x7a,%al
  800e39:	7f 10                	jg     800e4b <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	0f be c0             	movsbl %al,%eax
  800e43:	83 e8 57             	sub    $0x57,%eax
  800e46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e49:	eb 20                	jmp    800e6b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	3c 40                	cmp    $0x40,%al
  800e52:	7e 39                	jle    800e8d <strtol+0x126>
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	3c 5a                	cmp    $0x5a,%al
  800e5b:	7f 30                	jg     800e8d <strtol+0x126>
			dig = *s - 'A' + 10;
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	0f be c0             	movsbl %al,%eax
  800e65:	83 e8 37             	sub    $0x37,%eax
  800e68:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e71:	7d 19                	jge    800e8c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e73:	ff 45 08             	incl   0x8(%ebp)
  800e76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e79:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e7d:	89 c2                	mov    %eax,%edx
  800e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e82:	01 d0                	add    %edx,%eax
  800e84:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e87:	e9 7b ff ff ff       	jmp    800e07 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e8c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e91:	74 08                	je     800e9b <strtol+0x134>
		*endptr = (char *) s;
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e9f:	74 07                	je     800ea8 <strtol+0x141>
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	f7 d8                	neg    %eax
  800ea6:	eb 03                	jmp    800eab <strtol+0x144>
  800ea8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <ltostr>:

void
ltostr(long value, char *str)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800eb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ec1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ec5:	79 13                	jns    800eda <ltostr+0x2d>
	{
		neg = 1;
  800ec7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ed4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ed7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ee2:	99                   	cltd   
  800ee3:	f7 f9                	idiv   %ecx
  800ee5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ee8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eeb:	8d 50 01             	lea    0x1(%eax),%edx
  800eee:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ef1:	89 c2                	mov    %eax,%edx
  800ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef6:	01 d0                	add    %edx,%eax
  800ef8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800efb:	83 c2 30             	add    $0x30,%edx
  800efe:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f03:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f08:	f7 e9                	imul   %ecx
  800f0a:	c1 fa 02             	sar    $0x2,%edx
  800f0d:	89 c8                	mov    %ecx,%eax
  800f0f:	c1 f8 1f             	sar    $0x1f,%eax
  800f12:	29 c2                	sub    %eax,%edx
  800f14:	89 d0                	mov    %edx,%eax
  800f16:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f1c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f21:	f7 e9                	imul   %ecx
  800f23:	c1 fa 02             	sar    $0x2,%edx
  800f26:	89 c8                	mov    %ecx,%eax
  800f28:	c1 f8 1f             	sar    $0x1f,%eax
  800f2b:	29 c2                	sub    %eax,%edx
  800f2d:	89 d0                	mov    %edx,%eax
  800f2f:	c1 e0 02             	shl    $0x2,%eax
  800f32:	01 d0                	add    %edx,%eax
  800f34:	01 c0                	add    %eax,%eax
  800f36:	29 c1                	sub    %eax,%ecx
  800f38:	89 ca                	mov    %ecx,%edx
  800f3a:	85 d2                	test   %edx,%edx
  800f3c:	75 9c                	jne    800eda <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f48:	48                   	dec    %eax
  800f49:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f50:	74 3d                	je     800f8f <ltostr+0xe2>
		start = 1 ;
  800f52:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f59:	eb 34                	jmp    800f8f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	01 d0                	add    %edx,%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	01 c2                	add    %eax,%edx
  800f70:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	01 c8                	add    %ecx,%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f82:	01 c2                	add    %eax,%edx
  800f84:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f87:	88 02                	mov    %al,(%edx)
		start++ ;
  800f89:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f8c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f92:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f95:	7c c4                	jl     800f5b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f97:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9d:	01 d0                	add    %edx,%eax
  800f9f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800fa2:	90                   	nop
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fab:	ff 75 08             	pushl  0x8(%ebp)
  800fae:	e8 54 fa ff ff       	call   800a07 <strlen>
  800fb3:	83 c4 04             	add    $0x4,%esp
  800fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fb9:	ff 75 0c             	pushl  0xc(%ebp)
  800fbc:	e8 46 fa ff ff       	call   800a07 <strlen>
  800fc1:	83 c4 04             	add    $0x4,%esp
  800fc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fd5:	eb 17                	jmp    800fee <strcconcat+0x49>
		final[s] = str1[s] ;
  800fd7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	01 c2                	add    %eax,%edx
  800fdf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	01 c8                	add    %ecx,%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800feb:	ff 45 fc             	incl   -0x4(%ebp)
  800fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff4:	7c e1                	jl     800fd7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ff6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ffd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801004:	eb 1f                	jmp    801025 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801006:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801009:	8d 50 01             	lea    0x1(%eax),%edx
  80100c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80100f:	89 c2                	mov    %eax,%edx
  801011:	8b 45 10             	mov    0x10(%ebp),%eax
  801014:	01 c2                	add    %eax,%edx
  801016:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	01 c8                	add    %ecx,%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801022:	ff 45 f8             	incl   -0x8(%ebp)
  801025:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801028:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80102b:	7c d9                	jl     801006 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80102d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801030:	8b 45 10             	mov    0x10(%ebp),%eax
  801033:	01 d0                	add    %edx,%eax
  801035:	c6 00 00             	movb   $0x0,(%eax)
}
  801038:	90                   	nop
  801039:	c9                   	leave  
  80103a:	c3                   	ret    

0080103b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80103e:	8b 45 14             	mov    0x14(%ebp),%eax
  801041:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801047:	8b 45 14             	mov    0x14(%ebp),%eax
  80104a:	8b 00                	mov    (%eax),%eax
  80104c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801053:	8b 45 10             	mov    0x10(%ebp),%eax
  801056:	01 d0                	add    %edx,%eax
  801058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80105e:	eb 0c                	jmp    80106c <strsplit+0x31>
			*string++ = 0;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	8d 50 01             	lea    0x1(%eax),%edx
  801066:	89 55 08             	mov    %edx,0x8(%ebp)
  801069:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	84 c0                	test   %al,%al
  801073:	74 18                	je     80108d <strsplit+0x52>
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	0f be c0             	movsbl %al,%eax
  80107d:	50                   	push   %eax
  80107e:	ff 75 0c             	pushl  0xc(%ebp)
  801081:	e8 13 fb ff ff       	call   800b99 <strchr>
  801086:	83 c4 08             	add    $0x8,%esp
  801089:	85 c0                	test   %eax,%eax
  80108b:	75 d3                	jne    801060 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	84 c0                	test   %al,%al
  801094:	74 5a                	je     8010f0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801096:	8b 45 14             	mov    0x14(%ebp),%eax
  801099:	8b 00                	mov    (%eax),%eax
  80109b:	83 f8 0f             	cmp    $0xf,%eax
  80109e:	75 07                	jne    8010a7 <strsplit+0x6c>
		{
			return 0;
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a5:	eb 66                	jmp    80110d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010aa:	8b 00                	mov    (%eax),%eax
  8010ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8010af:	8b 55 14             	mov    0x14(%ebp),%edx
  8010b2:	89 0a                	mov    %ecx,(%edx)
  8010b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010be:	01 c2                	add    %eax,%edx
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c5:	eb 03                	jmp    8010ca <strsplit+0x8f>
			string++;
  8010c7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	84 c0                	test   %al,%al
  8010d1:	74 8b                	je     80105e <strsplit+0x23>
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	0f be c0             	movsbl %al,%eax
  8010db:	50                   	push   %eax
  8010dc:	ff 75 0c             	pushl  0xc(%ebp)
  8010df:	e8 b5 fa ff ff       	call   800b99 <strchr>
  8010e4:	83 c4 08             	add    $0x8,%esp
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	74 dc                	je     8010c7 <strsplit+0x8c>
			string++;
	}
  8010eb:	e9 6e ff ff ff       	jmp    80105e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010f0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f4:	8b 00                	mov    (%eax),%eax
  8010f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801100:	01 d0                	add    %edx,%eax
  801102:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801108:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80110d:	c9                   	leave  
  80110e:	c3                   	ret    

0080110f <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801115:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  80111c:	8b 55 08             	mov    0x8(%ebp),%edx
  80111f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801122:	01 d0                	add    %edx,%eax
  801124:	48                   	dec    %eax
  801125:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801128:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80112b:	ba 00 00 00 00       	mov    $0x0,%edx
  801130:	f7 75 ac             	divl   -0x54(%ebp)
  801133:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801136:	29 d0                	sub    %edx,%eax
  801138:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  80113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801142:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801149:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801150:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801157:	eb 3f                	jmp    801198 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801159:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80115c:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801163:	83 ec 04             	sub    $0x4,%esp
  801166:	50                   	push   %eax
  801167:	ff 75 e8             	pushl  -0x18(%ebp)
  80116a:	68 30 27 80 00       	push   $0x802730
  80116f:	e8 11 f2 ff ff       	call   800385 <cprintf>
  801174:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801177:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80117a:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801181:	83 ec 04             	sub    $0x4,%esp
  801184:	50                   	push   %eax
  801185:	ff 75 e8             	pushl  -0x18(%ebp)
  801188:	68 45 27 80 00       	push   $0x802745
  80118d:	e8 f3 f1 ff ff       	call   800385 <cprintf>
  801192:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801195:	ff 45 e8             	incl   -0x18(%ebp)
  801198:	a1 28 30 80 00       	mov    0x803028,%eax
  80119d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8011a0:	7c b7                	jl     801159 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8011a2:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  8011a9:	e9 42 01 00 00       	jmp    8012f0 <malloc+0x1e1>
		int flag0=1;
  8011ae:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8011b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8011bb:	eb 6b                	jmp    801228 <malloc+0x119>
			for(int k=0;k<count;k++){
  8011bd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8011c4:	eb 42                	jmp    801208 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8011c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011c9:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8011d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011d3:	39 c2                	cmp    %eax,%edx
  8011d5:	77 2e                	ja     801205 <malloc+0xf6>
  8011d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011da:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8011e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011e4:	39 c2                	cmp    %eax,%edx
  8011e6:	76 1d                	jbe    801205 <malloc+0xf6>
					ni=arr_add[k].end-i;
  8011e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011eb:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8011f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f5:	29 c2                	sub    %eax,%edx
  8011f7:	89 d0                	mov    %edx,%eax
  8011f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  8011fc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801203:	eb 0d                	jmp    801212 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801205:	ff 45 d8             	incl   -0x28(%ebp)
  801208:	a1 28 30 80 00       	mov    0x803028,%eax
  80120d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801210:	7c b4                	jl     8011c6 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801212:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801216:	74 09                	je     801221 <malloc+0x112>
				flag0=0;
  801218:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  80121f:	eb 16                	jmp    801237 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801221:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801228:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	01 c2                	add    %eax,%edx
  801230:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801233:	39 c2                	cmp    %eax,%edx
  801235:	77 86                	ja     8011bd <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801237:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80123b:	0f 84 a2 00 00 00    	je     8012e3 <malloc+0x1d4>

			int f=1;
  801241:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801248:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80124b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80124e:	89 c8                	mov    %ecx,%eax
  801250:	01 c0                	add    %eax,%eax
  801252:	01 c8                	add    %ecx,%eax
  801254:	c1 e0 02             	shl    $0x2,%eax
  801257:	05 20 31 80 00       	add    $0x803120,%eax
  80125c:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  80125e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801267:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126a:	89 d0                	mov    %edx,%eax
  80126c:	01 c0                	add    %eax,%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	c1 e0 02             	shl    $0x2,%eax
  801273:	05 24 31 80 00       	add    $0x803124,%eax
  801278:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  80127a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127d:	89 d0                	mov    %edx,%eax
  80127f:	01 c0                	add    %eax,%eax
  801281:	01 d0                	add    %edx,%eax
  801283:	c1 e0 02             	shl    $0x2,%eax
  801286:	05 28 31 80 00       	add    $0x803128,%eax
  80128b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801291:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801294:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80129b:	eb 36                	jmp    8012d3 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  80129d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	01 c2                	add    %eax,%edx
  8012a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8012a8:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8012af:	39 c2                	cmp    %eax,%edx
  8012b1:	73 1d                	jae    8012d0 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  8012b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8012b6:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8012bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012c0:	29 c2                	sub    %eax,%edx
  8012c2:	89 d0                	mov    %edx,%eax
  8012c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  8012c7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  8012ce:	eb 0d                	jmp    8012dd <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  8012d0:	ff 45 d0             	incl   -0x30(%ebp)
  8012d3:	a1 28 30 80 00       	mov    0x803028,%eax
  8012d8:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8012db:	7c c0                	jl     80129d <malloc+0x18e>
					break;

				}
			}

			if(f){
  8012dd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8012e1:	75 1d                	jne    801300 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  8012e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8012ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012ed:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8012f0:	a1 04 30 80 00       	mov    0x803004,%eax
  8012f5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8012f8:	0f 8c b0 fe ff ff    	jl     8011ae <malloc+0x9f>
  8012fe:	eb 01                	jmp    801301 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801300:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801301:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801305:	75 7a                	jne    801381 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801307:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	48                   	dec    %eax
  801313:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801318:	7c 0a                	jl     801324 <malloc+0x215>
			return NULL;
  80131a:	b8 00 00 00 00       	mov    $0x0,%eax
  80131f:	e9 a4 02 00 00       	jmp    8015c8 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801324:	a1 04 30 80 00       	mov    0x803004,%eax
  801329:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  80132c:	a1 28 30 80 00       	mov    0x803028,%eax
  801331:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801334:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  80133b:	83 ec 08             	sub    $0x8,%esp
  80133e:	ff 75 08             	pushl  0x8(%ebp)
  801341:	ff 75 a4             	pushl  -0x5c(%ebp)
  801344:	e8 04 06 00 00       	call   80194d <sys_allocateMem>
  801349:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  80134c:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  80135c:	a1 28 30 80 00       	mov    0x803028,%eax
  801361:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801367:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  80136e:	a1 28 30 80 00       	mov    0x803028,%eax
  801373:	40                   	inc    %eax
  801374:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  801379:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80137c:	e9 47 02 00 00       	jmp    8015c8 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801381:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801388:	e9 ac 00 00 00       	jmp    801439 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  80138d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801390:	89 d0                	mov    %edx,%eax
  801392:	01 c0                	add    %eax,%eax
  801394:	01 d0                	add    %edx,%eax
  801396:	c1 e0 02             	shl    $0x2,%eax
  801399:	05 24 31 80 00       	add    $0x803124,%eax
  80139e:	8b 00                	mov    (%eax),%eax
  8013a0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8013a3:	eb 7e                	jmp    801423 <malloc+0x314>
			int flag=0;
  8013a5:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  8013ac:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8013b3:	eb 57                	jmp    80140c <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8013b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8013b8:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8013bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8013c2:	39 c2                	cmp    %eax,%edx
  8013c4:	77 1a                	ja     8013e0 <malloc+0x2d1>
  8013c6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8013c9:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8013d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8013d3:	39 c2                	cmp    %eax,%edx
  8013d5:	76 09                	jbe    8013e0 <malloc+0x2d1>
								flag=1;
  8013d7:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  8013de:	eb 36                	jmp    801416 <malloc+0x307>
			arr[i].space++;
  8013e0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8013e3:	89 d0                	mov    %edx,%eax
  8013e5:	01 c0                	add    %eax,%eax
  8013e7:	01 d0                	add    %edx,%eax
  8013e9:	c1 e0 02             	shl    $0x2,%eax
  8013ec:	05 28 31 80 00       	add    $0x803128,%eax
  8013f1:	8b 00                	mov    (%eax),%eax
  8013f3:	8d 48 01             	lea    0x1(%eax),%ecx
  8013f6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8013f9:	89 d0                	mov    %edx,%eax
  8013fb:	01 c0                	add    %eax,%eax
  8013fd:	01 d0                	add    %edx,%eax
  8013ff:	c1 e0 02             	shl    $0x2,%eax
  801402:	05 28 31 80 00       	add    $0x803128,%eax
  801407:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801409:	ff 45 c0             	incl   -0x40(%ebp)
  80140c:	a1 28 30 80 00       	mov    0x803028,%eax
  801411:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801414:	7c 9f                	jl     8013b5 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801416:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80141a:	75 19                	jne    801435 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  80141c:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801423:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801426:	a1 04 30 80 00       	mov    0x803004,%eax
  80142b:	39 c2                	cmp    %eax,%edx
  80142d:	0f 82 72 ff ff ff    	jb     8013a5 <malloc+0x296>
  801433:	eb 01                	jmp    801436 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801435:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801436:	ff 45 cc             	incl   -0x34(%ebp)
  801439:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80143c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80143f:	0f 8c 48 ff ff ff    	jl     80138d <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801445:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  80144c:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801453:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  80145a:	eb 37                	jmp    801493 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  80145c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80145f:	89 d0                	mov    %edx,%eax
  801461:	01 c0                	add    %eax,%eax
  801463:	01 d0                	add    %edx,%eax
  801465:	c1 e0 02             	shl    $0x2,%eax
  801468:	05 28 31 80 00       	add    $0x803128,%eax
  80146d:	8b 00                	mov    (%eax),%eax
  80146f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801472:	7d 1c                	jge    801490 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801474:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801477:	89 d0                	mov    %edx,%eax
  801479:	01 c0                	add    %eax,%eax
  80147b:	01 d0                	add    %edx,%eax
  80147d:	c1 e0 02             	shl    $0x2,%eax
  801480:	05 28 31 80 00       	add    $0x803128,%eax
  801485:	8b 00                	mov    (%eax),%eax
  801487:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  80148a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80148d:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801490:	ff 45 b4             	incl   -0x4c(%ebp)
  801493:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801496:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801499:	7c c1                	jl     80145c <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  80149b:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8014a1:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8014a4:	89 c8                	mov    %ecx,%eax
  8014a6:	01 c0                	add    %eax,%eax
  8014a8:	01 c8                	add    %ecx,%eax
  8014aa:	c1 e0 02             	shl    $0x2,%eax
  8014ad:	05 20 31 80 00       	add    $0x803120,%eax
  8014b2:	8b 00                	mov    (%eax),%eax
  8014b4:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  8014bb:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8014c1:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8014c4:	89 c8                	mov    %ecx,%eax
  8014c6:	01 c0                	add    %eax,%eax
  8014c8:	01 c8                	add    %ecx,%eax
  8014ca:	c1 e0 02             	shl    $0x2,%eax
  8014cd:	05 24 31 80 00       	add    $0x803124,%eax
  8014d2:	8b 00                	mov    (%eax),%eax
  8014d4:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  8014db:	a1 28 30 80 00       	mov    0x803028,%eax
  8014e0:	40                   	inc    %eax
  8014e1:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  8014e6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8014e9:	89 d0                	mov    %edx,%eax
  8014eb:	01 c0                	add    %eax,%eax
  8014ed:	01 d0                	add    %edx,%eax
  8014ef:	c1 e0 02             	shl    $0x2,%eax
  8014f2:	05 20 31 80 00       	add    $0x803120,%eax
  8014f7:	8b 00                	mov    (%eax),%eax
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	ff 75 08             	pushl  0x8(%ebp)
  8014ff:	50                   	push   %eax
  801500:	e8 48 04 00 00       	call   80194d <sys_allocateMem>
  801505:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801508:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  80150f:	eb 78                	jmp    801589 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801511:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801514:	89 d0                	mov    %edx,%eax
  801516:	01 c0                	add    %eax,%eax
  801518:	01 d0                	add    %edx,%eax
  80151a:	c1 e0 02             	shl    $0x2,%eax
  80151d:	05 20 31 80 00       	add    $0x803120,%eax
  801522:	8b 00                	mov    (%eax),%eax
  801524:	83 ec 04             	sub    $0x4,%esp
  801527:	50                   	push   %eax
  801528:	ff 75 b0             	pushl  -0x50(%ebp)
  80152b:	68 30 27 80 00       	push   $0x802730
  801530:	e8 50 ee ff ff       	call   800385 <cprintf>
  801535:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801538:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80153b:	89 d0                	mov    %edx,%eax
  80153d:	01 c0                	add    %eax,%eax
  80153f:	01 d0                	add    %edx,%eax
  801541:	c1 e0 02             	shl    $0x2,%eax
  801544:	05 24 31 80 00       	add    $0x803124,%eax
  801549:	8b 00                	mov    (%eax),%eax
  80154b:	83 ec 04             	sub    $0x4,%esp
  80154e:	50                   	push   %eax
  80154f:	ff 75 b0             	pushl  -0x50(%ebp)
  801552:	68 45 27 80 00       	push   $0x802745
  801557:	e8 29 ee ff ff       	call   800385 <cprintf>
  80155c:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  80155f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801562:	89 d0                	mov    %edx,%eax
  801564:	01 c0                	add    %eax,%eax
  801566:	01 d0                	add    %edx,%eax
  801568:	c1 e0 02             	shl    $0x2,%eax
  80156b:	05 28 31 80 00       	add    $0x803128,%eax
  801570:	8b 00                	mov    (%eax),%eax
  801572:	83 ec 04             	sub    $0x4,%esp
  801575:	50                   	push   %eax
  801576:	ff 75 b0             	pushl  -0x50(%ebp)
  801579:	68 58 27 80 00       	push   $0x802758
  80157e:	e8 02 ee ff ff       	call   800385 <cprintf>
  801583:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801586:	ff 45 b0             	incl   -0x50(%ebp)
  801589:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80158c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80158f:	7c 80                	jl     801511 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801591:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801594:	89 d0                	mov    %edx,%eax
  801596:	01 c0                	add    %eax,%eax
  801598:	01 d0                	add    %edx,%eax
  80159a:	c1 e0 02             	shl    $0x2,%eax
  80159d:	05 20 31 80 00       	add    $0x803120,%eax
  8015a2:	8b 00                	mov    (%eax),%eax
  8015a4:	83 ec 08             	sub    $0x8,%esp
  8015a7:	50                   	push   %eax
  8015a8:	68 6c 27 80 00       	push   $0x80276c
  8015ad:	e8 d3 ed ff ff       	call   800385 <cprintf>
  8015b2:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  8015b5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8015b8:	89 d0                	mov    %edx,%eax
  8015ba:	01 c0                	add    %eax,%eax
  8015bc:	01 d0                	add    %edx,%eax
  8015be:	c1 e0 02             	shl    $0x2,%eax
  8015c1:	05 20 31 80 00       	add    $0x803120,%eax
  8015c6:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  8015d6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8015dd:	eb 4b                	jmp    80162a <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  8015df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e2:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8015e9:	89 c2                	mov    %eax,%edx
  8015eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ee:	39 c2                	cmp    %eax,%edx
  8015f0:	7f 35                	jg     801627 <free+0x5d>
  8015f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f5:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8015fc:	89 c2                	mov    %eax,%edx
  8015fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801601:	39 c2                	cmp    %eax,%edx
  801603:	7e 22                	jle    801627 <free+0x5d>
				start=arr_add[i].start;
  801605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801608:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80160f:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801612:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801615:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  80161c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  80161f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801622:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801625:	eb 0d                	jmp    801634 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801627:	ff 45 ec             	incl   -0x14(%ebp)
  80162a:	a1 28 30 80 00       	mov    0x803028,%eax
  80162f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801632:	7c ab                	jl     8015df <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801637:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80163e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801641:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801648:	29 c2                	sub    %eax,%edx
  80164a:	89 d0                	mov    %edx,%eax
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	50                   	push   %eax
  801650:	ff 75 f4             	pushl  -0xc(%ebp)
  801653:	e8 d9 02 00 00       	call   801931 <sys_freeMem>
  801658:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  80165b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801661:	eb 2d                	jmp    801690 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801663:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801666:	40                   	inc    %eax
  801667:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80166e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801671:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801678:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80167b:	40                   	inc    %eax
  80167c:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801683:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801686:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  80168d:	ff 45 e8             	incl   -0x18(%ebp)
  801690:	a1 28 30 80 00       	mov    0x803028,%eax
  801695:	48                   	dec    %eax
  801696:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801699:	7f c8                	jg     801663 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  80169b:	a1 28 30 80 00       	mov    0x803028,%eax
  8016a0:	48                   	dec    %eax
  8016a1:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  8016a6:	90                   	nop
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 18             	sub    $0x18,%esp
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 88 27 80 00       	push   $0x802788
  8016bd:	68 18 01 00 00       	push   $0x118
  8016c2:	68 ab 27 80 00       	push   $0x8027ab
  8016c7:	e8 bf 07 00 00       	call   801e8b <_panic>

008016cc <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8016d2:	83 ec 04             	sub    $0x4,%esp
  8016d5:	68 88 27 80 00       	push   $0x802788
  8016da:	68 1e 01 00 00       	push   $0x11e
  8016df:	68 ab 27 80 00       	push   $0x8027ab
  8016e4:	e8 a2 07 00 00       	call   801e8b <_panic>

008016e9 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8016ef:	83 ec 04             	sub    $0x4,%esp
  8016f2:	68 88 27 80 00       	push   $0x802788
  8016f7:	68 24 01 00 00       	push   $0x124
  8016fc:	68 ab 27 80 00       	push   $0x8027ab
  801701:	e8 85 07 00 00       	call   801e8b <_panic>

00801706 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80170c:	83 ec 04             	sub    $0x4,%esp
  80170f:	68 88 27 80 00       	push   $0x802788
  801714:	68 29 01 00 00       	push   $0x129
  801719:	68 ab 27 80 00       	push   $0x8027ab
  80171e:	e8 68 07 00 00       	call   801e8b <_panic>

00801723 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801729:	83 ec 04             	sub    $0x4,%esp
  80172c:	68 88 27 80 00       	push   $0x802788
  801731:	68 2f 01 00 00       	push   $0x12f
  801736:	68 ab 27 80 00       	push   $0x8027ab
  80173b:	e8 4b 07 00 00       	call   801e8b <_panic>

00801740 <shrink>:
}
void shrink(uint32 newSize)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	68 88 27 80 00       	push   $0x802788
  80174e:	68 33 01 00 00       	push   $0x133
  801753:	68 ab 27 80 00       	push   $0x8027ab
  801758:	e8 2e 07 00 00       	call   801e8b <_panic>

0080175d <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801763:	83 ec 04             	sub    $0x4,%esp
  801766:	68 88 27 80 00       	push   $0x802788
  80176b:	68 38 01 00 00       	push   $0x138
  801770:	68 ab 27 80 00       	push   $0x8027ab
  801775:	e8 11 07 00 00       	call   801e8b <_panic>

0080177a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	57                   	push   %edi
  80177e:	56                   	push   %esi
  80177f:	53                   	push   %ebx
  801780:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
  801786:	8b 55 0c             	mov    0xc(%ebp),%edx
  801789:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80178c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80178f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801792:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801795:	cd 30                	int    $0x30
  801797:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80179a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	5b                   	pop    %ebx
  8017a1:	5e                   	pop    %esi
  8017a2:	5f                   	pop    %edi
  8017a3:	5d                   	pop    %ebp
  8017a4:	c3                   	ret    

008017a5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 04             	sub    $0x4,%esp
  8017ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017b1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	52                   	push   %edx
  8017bd:	ff 75 0c             	pushl  0xc(%ebp)
  8017c0:	50                   	push   %eax
  8017c1:	6a 00                	push   $0x0
  8017c3:	e8 b2 ff ff ff       	call   80177a <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
}
  8017cb:	90                   	nop
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <sys_cgetc>:

int
sys_cgetc(void)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 01                	push   $0x1
  8017dd:	e8 98 ff ff ff       	call   80177a <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	50                   	push   %eax
  8017f6:	6a 05                	push   $0x5
  8017f8:	e8 7d ff ff ff       	call   80177a <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 02                	push   $0x2
  801811:	e8 64 ff ff ff       	call   80177a <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 03                	push   $0x3
  80182a:	e8 4b ff ff ff       	call   80177a <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 04                	push   $0x4
  801843:	e8 32 ff ff ff       	call   80177a <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_env_exit>:


void sys_env_exit(void)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 06                	push   $0x6
  80185c:	e8 19 ff ff ff       	call   80177a <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	90                   	nop
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80186a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	52                   	push   %edx
  801877:	50                   	push   %eax
  801878:	6a 07                	push   $0x7
  80187a:	e8 fb fe ff ff       	call   80177a <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	56                   	push   %esi
  801888:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801889:	8b 75 18             	mov    0x18(%ebp),%esi
  80188c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80188f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801892:	8b 55 0c             	mov    0xc(%ebp),%edx
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	56                   	push   %esi
  801899:	53                   	push   %ebx
  80189a:	51                   	push   %ecx
  80189b:	52                   	push   %edx
  80189c:	50                   	push   %eax
  80189d:	6a 08                	push   $0x8
  80189f:	e8 d6 fe ff ff       	call   80177a <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018aa:	5b                   	pop    %ebx
  8018ab:	5e                   	pop    %esi
  8018ac:	5d                   	pop    %ebp
  8018ad:	c3                   	ret    

008018ae <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	52                   	push   %edx
  8018be:	50                   	push   %eax
  8018bf:	6a 09                	push   $0x9
  8018c1:	e8 b4 fe ff ff       	call   80177a <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	ff 75 0c             	pushl  0xc(%ebp)
  8018d7:	ff 75 08             	pushl  0x8(%ebp)
  8018da:	6a 0a                	push   $0xa
  8018dc:	e8 99 fe ff ff       	call   80177a <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 0b                	push   $0xb
  8018f5:	e8 80 fe ff ff       	call   80177a <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 0c                	push   $0xc
  80190e:	e8 67 fe ff ff       	call   80177a <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 0d                	push   $0xd
  801927:	e8 4e fe ff ff       	call   80177a <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	ff 75 0c             	pushl  0xc(%ebp)
  80193d:	ff 75 08             	pushl  0x8(%ebp)
  801940:	6a 11                	push   $0x11
  801942:	e8 33 fe ff ff       	call   80177a <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
	return;
  80194a:	90                   	nop
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	6a 12                	push   $0x12
  80195e:	e8 17 fe ff ff       	call   80177a <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
	return ;
  801966:	90                   	nop
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 0e                	push   $0xe
  801978:	e8 fd fd ff ff       	call   80177a <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	ff 75 08             	pushl  0x8(%ebp)
  801990:	6a 0f                	push   $0xf
  801992:	e8 e3 fd ff ff       	call   80177a <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 10                	push   $0x10
  8019ab:	e8 ca fd ff ff       	call   80177a <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	90                   	nop
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 14                	push   $0x14
  8019c5:	e8 b0 fd ff ff       	call   80177a <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	90                   	nop
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 15                	push   $0x15
  8019df:	e8 96 fd ff ff       	call   80177a <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	90                   	nop
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_cputc>:


void
sys_cputc(const char c)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 04             	sub    $0x4,%esp
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019f6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	50                   	push   %eax
  801a03:	6a 16                	push   $0x16
  801a05:	e8 70 fd ff ff       	call   80177a <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	90                   	nop
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 17                	push   $0x17
  801a1f:	e8 56 fd ff ff       	call   80177a <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	90                   	nop
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	50                   	push   %eax
  801a3a:	6a 18                	push   $0x18
  801a3c:	e8 39 fd ff ff       	call   80177a <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	52                   	push   %edx
  801a56:	50                   	push   %eax
  801a57:	6a 1b                	push   $0x1b
  801a59:	e8 1c fd ff ff       	call   80177a <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	52                   	push   %edx
  801a73:	50                   	push   %eax
  801a74:	6a 19                	push   $0x19
  801a76:	e8 ff fc ff ff       	call   80177a <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	90                   	nop
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	52                   	push   %edx
  801a91:	50                   	push   %eax
  801a92:	6a 1a                	push   $0x1a
  801a94:	e8 e1 fc ff ff       	call   80177a <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	90                   	nop
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	6a 00                	push   $0x0
  801ab7:	51                   	push   %ecx
  801ab8:	52                   	push   %edx
  801ab9:	ff 75 0c             	pushl  0xc(%ebp)
  801abc:	50                   	push   %eax
  801abd:	6a 1c                	push   $0x1c
  801abf:	e8 b6 fc ff ff       	call   80177a <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	52                   	push   %edx
  801ad9:	50                   	push   %eax
  801ada:	6a 1d                	push   $0x1d
  801adc:	e8 99 fc ff ff       	call   80177a <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ae9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	51                   	push   %ecx
  801af7:	52                   	push   %edx
  801af8:	50                   	push   %eax
  801af9:	6a 1e                	push   $0x1e
  801afb:	e8 7a fc ff ff       	call   80177a <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	52                   	push   %edx
  801b15:	50                   	push   %eax
  801b16:	6a 1f                	push   $0x1f
  801b18:	e8 5d fc ff ff       	call   80177a <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 20                	push   $0x20
  801b31:	e8 44 fc ff ff       	call   80177a <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	6a 00                	push   $0x0
  801b43:	ff 75 14             	pushl  0x14(%ebp)
  801b46:	ff 75 10             	pushl  0x10(%ebp)
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	50                   	push   %eax
  801b4d:	6a 21                	push   $0x21
  801b4f:	e8 26 fc ff ff       	call   80177a <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	50                   	push   %eax
  801b68:	6a 22                	push   $0x22
  801b6a:	e8 0b fc ff ff       	call   80177a <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	90                   	nop
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	50                   	push   %eax
  801b84:	6a 23                	push   $0x23
  801b86:	e8 ef fb ff ff       	call   80177a <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	90                   	nop
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b97:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b9a:	8d 50 04             	lea    0x4(%eax),%edx
  801b9d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	52                   	push   %edx
  801ba7:	50                   	push   %eax
  801ba8:	6a 24                	push   $0x24
  801baa:	e8 cb fb ff ff       	call   80177a <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
	return result;
  801bb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bb8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bbb:	89 01                	mov    %eax,(%ecx)
  801bbd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	c9                   	leave  
  801bc4:	c2 04 00             	ret    $0x4

00801bc7 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	ff 75 10             	pushl  0x10(%ebp)
  801bd1:	ff 75 0c             	pushl  0xc(%ebp)
  801bd4:	ff 75 08             	pushl  0x8(%ebp)
  801bd7:	6a 13                	push   $0x13
  801bd9:	e8 9c fb ff ff       	call   80177a <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
	return ;
  801be1:	90                   	nop
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 25                	push   $0x25
  801bf3:	e8 82 fb ff ff       	call   80177a <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	8b 45 08             	mov    0x8(%ebp),%eax
  801c06:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c09:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	50                   	push   %eax
  801c16:	6a 26                	push   $0x26
  801c18:	e8 5d fb ff ff       	call   80177a <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c20:	90                   	nop
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <rsttst>:
void rsttst()
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 28                	push   $0x28
  801c32:	e8 43 fb ff ff       	call   80177a <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3a:	90                   	nop
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	83 ec 04             	sub    $0x4,%esp
  801c43:	8b 45 14             	mov    0x14(%ebp),%eax
  801c46:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c49:	8b 55 18             	mov    0x18(%ebp),%edx
  801c4c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c50:	52                   	push   %edx
  801c51:	50                   	push   %eax
  801c52:	ff 75 10             	pushl  0x10(%ebp)
  801c55:	ff 75 0c             	pushl  0xc(%ebp)
  801c58:	ff 75 08             	pushl  0x8(%ebp)
  801c5b:	6a 27                	push   $0x27
  801c5d:	e8 18 fb ff ff       	call   80177a <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
	return ;
  801c65:	90                   	nop
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <chktst>:
void chktst(uint32 n)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	ff 75 08             	pushl  0x8(%ebp)
  801c76:	6a 29                	push   $0x29
  801c78:	e8 fd fa ff ff       	call   80177a <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c80:	90                   	nop
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <inctst>:

void inctst()
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 2a                	push   $0x2a
  801c92:	e8 e3 fa ff ff       	call   80177a <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9a:	90                   	nop
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <gettst>:
uint32 gettst()
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 2b                	push   $0x2b
  801cac:	e8 c9 fa ff ff       	call   80177a <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 2c                	push   $0x2c
  801cc8:	e8 ad fa ff ff       	call   80177a <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
  801cd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cd3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cd7:	75 07                	jne    801ce0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cde:	eb 05                	jmp    801ce5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ce0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 2c                	push   $0x2c
  801cf9:	e8 7c fa ff ff       	call   80177a <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
  801d01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d04:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d08:	75 07                	jne    801d11 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0f:	eb 05                	jmp    801d16 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 2c                	push   $0x2c
  801d2a:	e8 4b fa ff ff       	call   80177a <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
  801d32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d35:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d39:	75 07                	jne    801d42 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d40:	eb 05                	jmp    801d47 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 2c                	push   $0x2c
  801d5b:	e8 1a fa ff ff       	call   80177a <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
  801d63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d66:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d6a:	75 07                	jne    801d73 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d71:	eb 05                	jmp    801d78 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	6a 2d                	push   $0x2d
  801d8a:	e8 eb f9 ff ff       	call   80177a <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d92:	90                   	nop
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d99:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	6a 00                	push   $0x0
  801da7:	53                   	push   %ebx
  801da8:	51                   	push   %ecx
  801da9:	52                   	push   %edx
  801daa:	50                   	push   %eax
  801dab:	6a 2e                	push   $0x2e
  801dad:	e8 c8 f9 ff ff       	call   80177a <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
}
  801db5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	52                   	push   %edx
  801dca:	50                   	push   %eax
  801dcb:	6a 2f                	push   $0x2f
  801dcd:	e8 a8 f9 ff ff       	call   80177a <syscall>
  801dd2:	83 c4 18             	add    $0x18,%esp
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  801de0:	89 d0                	mov    %edx,%eax
  801de2:	c1 e0 02             	shl    $0x2,%eax
  801de5:	01 d0                	add    %edx,%eax
  801de7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dee:	01 d0                	add    %edx,%eax
  801df0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801df7:	01 d0                	add    %edx,%eax
  801df9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e00:	01 d0                	add    %edx,%eax
  801e02:	c1 e0 04             	shl    $0x4,%eax
  801e05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801e08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801e0f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801e12:	83 ec 0c             	sub    $0xc,%esp
  801e15:	50                   	push   %eax
  801e16:	e8 76 fd ff ff       	call   801b91 <sys_get_virtual_time>
  801e1b:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801e1e:	eb 41                	jmp    801e61 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801e20:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801e23:	83 ec 0c             	sub    $0xc,%esp
  801e26:	50                   	push   %eax
  801e27:	e8 65 fd ff ff       	call   801b91 <sys_get_virtual_time>
  801e2c:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e35:	29 c2                	sub    %eax,%edx
  801e37:	89 d0                	mov    %edx,%eax
  801e39:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e42:	89 d1                	mov    %edx,%ecx
  801e44:	29 c1                	sub    %eax,%ecx
  801e46:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4c:	39 c2                	cmp    %eax,%edx
  801e4e:	0f 97 c0             	seta   %al
  801e51:	0f b6 c0             	movzbl %al,%eax
  801e54:	29 c1                	sub    %eax,%ecx
  801e56:	89 c8                	mov    %ecx,%eax
  801e58:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e64:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e67:	72 b7                	jb     801e20 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e69:	90                   	nop
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801e79:	eb 03                	jmp    801e7e <busy_wait+0x12>
  801e7b:	ff 45 fc             	incl   -0x4(%ebp)
  801e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e81:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e84:	72 f5                	jb     801e7b <busy_wait+0xf>
	return i;
  801e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801e91:	8d 45 10             	lea    0x10(%ebp),%eax
  801e94:	83 c0 04             	add    $0x4,%eax
  801e97:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801e9a:	a1 60 3e 83 00       	mov    0x833e60,%eax
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	74 16                	je     801eb9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801ea3:	a1 60 3e 83 00       	mov    0x833e60,%eax
  801ea8:	83 ec 08             	sub    $0x8,%esp
  801eab:	50                   	push   %eax
  801eac:	68 b8 27 80 00       	push   $0x8027b8
  801eb1:	e8 cf e4 ff ff       	call   800385 <cprintf>
  801eb6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801eb9:	a1 00 30 80 00       	mov    0x803000,%eax
  801ebe:	ff 75 0c             	pushl  0xc(%ebp)
  801ec1:	ff 75 08             	pushl  0x8(%ebp)
  801ec4:	50                   	push   %eax
  801ec5:	68 bd 27 80 00       	push   $0x8027bd
  801eca:	e8 b6 e4 ff ff       	call   800385 <cprintf>
  801ecf:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed5:	83 ec 08             	sub    $0x8,%esp
  801ed8:	ff 75 f4             	pushl  -0xc(%ebp)
  801edb:	50                   	push   %eax
  801edc:	e8 39 e4 ff ff       	call   80031a <vcprintf>
  801ee1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801ee4:	83 ec 08             	sub    $0x8,%esp
  801ee7:	6a 00                	push   $0x0
  801ee9:	68 d9 27 80 00       	push   $0x8027d9
  801eee:	e8 27 e4 ff ff       	call   80031a <vcprintf>
  801ef3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801ef6:	e8 a8 e3 ff ff       	call   8002a3 <exit>

	// should not return here
	while (1) ;
  801efb:	eb fe                	jmp    801efb <_panic+0x70>

00801efd <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801f03:	a1 20 30 80 00       	mov    0x803020,%eax
  801f08:	8b 50 74             	mov    0x74(%eax),%edx
  801f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0e:	39 c2                	cmp    %eax,%edx
  801f10:	74 14                	je     801f26 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801f12:	83 ec 04             	sub    $0x4,%esp
  801f15:	68 dc 27 80 00       	push   $0x8027dc
  801f1a:	6a 26                	push   $0x26
  801f1c:	68 28 28 80 00       	push   $0x802828
  801f21:	e8 65 ff ff ff       	call   801e8b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801f26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801f2d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801f34:	e9 b6 00 00 00       	jmp    801fef <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  801f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	01 d0                	add    %edx,%eax
  801f48:	8b 00                	mov    (%eax),%eax
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	75 08                	jne    801f56 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801f4e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801f51:	e9 96 00 00 00       	jmp    801fec <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  801f56:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801f5d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801f64:	eb 5d                	jmp    801fc3 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801f66:	a1 20 30 80 00       	mov    0x803020,%eax
  801f6b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801f71:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f74:	c1 e2 04             	shl    $0x4,%edx
  801f77:	01 d0                	add    %edx,%eax
  801f79:	8a 40 04             	mov    0x4(%eax),%al
  801f7c:	84 c0                	test   %al,%al
  801f7e:	75 40                	jne    801fc0 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801f80:	a1 20 30 80 00       	mov    0x803020,%eax
  801f85:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801f8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f8e:	c1 e2 04             	shl    $0x4,%edx
  801f91:	01 d0                	add    %edx,%eax
  801f93:	8b 00                	mov    (%eax),%eax
  801f95:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801f98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801fa0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	01 c8                	add    %ecx,%eax
  801fb1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801fb3:	39 c2                	cmp    %eax,%edx
  801fb5:	75 09                	jne    801fc0 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  801fb7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801fbe:	eb 12                	jmp    801fd2 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801fc0:	ff 45 e8             	incl   -0x18(%ebp)
  801fc3:	a1 20 30 80 00       	mov    0x803020,%eax
  801fc8:	8b 50 74             	mov    0x74(%eax),%edx
  801fcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fce:	39 c2                	cmp    %eax,%edx
  801fd0:	77 94                	ja     801f66 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801fd2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fd6:	75 14                	jne    801fec <CheckWSWithoutLastIndex+0xef>
			panic(
  801fd8:	83 ec 04             	sub    $0x4,%esp
  801fdb:	68 34 28 80 00       	push   $0x802834
  801fe0:	6a 3a                	push   $0x3a
  801fe2:	68 28 28 80 00       	push   $0x802828
  801fe7:	e8 9f fe ff ff       	call   801e8b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801fec:	ff 45 f0             	incl   -0x10(%ebp)
  801fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ff5:	0f 8c 3e ff ff ff    	jl     801f39 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801ffb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802002:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802009:	eb 20                	jmp    80202b <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80200b:	a1 20 30 80 00       	mov    0x803020,%eax
  802010:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802016:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802019:	c1 e2 04             	shl    $0x4,%edx
  80201c:	01 d0                	add    %edx,%eax
  80201e:	8a 40 04             	mov    0x4(%eax),%al
  802021:	3c 01                	cmp    $0x1,%al
  802023:	75 03                	jne    802028 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  802025:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802028:	ff 45 e0             	incl   -0x20(%ebp)
  80202b:	a1 20 30 80 00       	mov    0x803020,%eax
  802030:	8b 50 74             	mov    0x74(%eax),%edx
  802033:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802036:	39 c2                	cmp    %eax,%edx
  802038:	77 d1                	ja     80200b <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80203a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802040:	74 14                	je     802056 <CheckWSWithoutLastIndex+0x159>
		panic(
  802042:	83 ec 04             	sub    $0x4,%esp
  802045:	68 88 28 80 00       	push   $0x802888
  80204a:	6a 44                	push   $0x44
  80204c:	68 28 28 80 00       	push   $0x802828
  802051:	e8 35 fe ff ff       	call   801e8b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802056:	90                   	nop
  802057:	c9                   	leave  
  802058:	c3                   	ret    
  802059:	66 90                	xchg   %ax,%ax
  80205b:	90                   	nop

0080205c <__udivdi3>:
  80205c:	55                   	push   %ebp
  80205d:	57                   	push   %edi
  80205e:	56                   	push   %esi
  80205f:	53                   	push   %ebx
  802060:	83 ec 1c             	sub    $0x1c,%esp
  802063:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802067:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80206b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80206f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802073:	89 ca                	mov    %ecx,%edx
  802075:	89 f8                	mov    %edi,%eax
  802077:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80207b:	85 f6                	test   %esi,%esi
  80207d:	75 2d                	jne    8020ac <__udivdi3+0x50>
  80207f:	39 cf                	cmp    %ecx,%edi
  802081:	77 65                	ja     8020e8 <__udivdi3+0x8c>
  802083:	89 fd                	mov    %edi,%ebp
  802085:	85 ff                	test   %edi,%edi
  802087:	75 0b                	jne    802094 <__udivdi3+0x38>
  802089:	b8 01 00 00 00       	mov    $0x1,%eax
  80208e:	31 d2                	xor    %edx,%edx
  802090:	f7 f7                	div    %edi
  802092:	89 c5                	mov    %eax,%ebp
  802094:	31 d2                	xor    %edx,%edx
  802096:	89 c8                	mov    %ecx,%eax
  802098:	f7 f5                	div    %ebp
  80209a:	89 c1                	mov    %eax,%ecx
  80209c:	89 d8                	mov    %ebx,%eax
  80209e:	f7 f5                	div    %ebp
  8020a0:	89 cf                	mov    %ecx,%edi
  8020a2:	89 fa                	mov    %edi,%edx
  8020a4:	83 c4 1c             	add    $0x1c,%esp
  8020a7:	5b                   	pop    %ebx
  8020a8:	5e                   	pop    %esi
  8020a9:	5f                   	pop    %edi
  8020aa:	5d                   	pop    %ebp
  8020ab:	c3                   	ret    
  8020ac:	39 ce                	cmp    %ecx,%esi
  8020ae:	77 28                	ja     8020d8 <__udivdi3+0x7c>
  8020b0:	0f bd fe             	bsr    %esi,%edi
  8020b3:	83 f7 1f             	xor    $0x1f,%edi
  8020b6:	75 40                	jne    8020f8 <__udivdi3+0x9c>
  8020b8:	39 ce                	cmp    %ecx,%esi
  8020ba:	72 0a                	jb     8020c6 <__udivdi3+0x6a>
  8020bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8020c0:	0f 87 9e 00 00 00    	ja     802164 <__udivdi3+0x108>
  8020c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020cb:	89 fa                	mov    %edi,%edx
  8020cd:	83 c4 1c             	add    $0x1c,%esp
  8020d0:	5b                   	pop    %ebx
  8020d1:	5e                   	pop    %esi
  8020d2:	5f                   	pop    %edi
  8020d3:	5d                   	pop    %ebp
  8020d4:	c3                   	ret    
  8020d5:	8d 76 00             	lea    0x0(%esi),%esi
  8020d8:	31 ff                	xor    %edi,%edi
  8020da:	31 c0                	xor    %eax,%eax
  8020dc:	89 fa                	mov    %edi,%edx
  8020de:	83 c4 1c             	add    $0x1c,%esp
  8020e1:	5b                   	pop    %ebx
  8020e2:	5e                   	pop    %esi
  8020e3:	5f                   	pop    %edi
  8020e4:	5d                   	pop    %ebp
  8020e5:	c3                   	ret    
  8020e6:	66 90                	xchg   %ax,%ax
  8020e8:	89 d8                	mov    %ebx,%eax
  8020ea:	f7 f7                	div    %edi
  8020ec:	31 ff                	xor    %edi,%edi
  8020ee:	89 fa                	mov    %edi,%edx
  8020f0:	83 c4 1c             	add    $0x1c,%esp
  8020f3:	5b                   	pop    %ebx
  8020f4:	5e                   	pop    %esi
  8020f5:	5f                   	pop    %edi
  8020f6:	5d                   	pop    %ebp
  8020f7:	c3                   	ret    
  8020f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020fd:	89 eb                	mov    %ebp,%ebx
  8020ff:	29 fb                	sub    %edi,%ebx
  802101:	89 f9                	mov    %edi,%ecx
  802103:	d3 e6                	shl    %cl,%esi
  802105:	89 c5                	mov    %eax,%ebp
  802107:	88 d9                	mov    %bl,%cl
  802109:	d3 ed                	shr    %cl,%ebp
  80210b:	89 e9                	mov    %ebp,%ecx
  80210d:	09 f1                	or     %esi,%ecx
  80210f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802113:	89 f9                	mov    %edi,%ecx
  802115:	d3 e0                	shl    %cl,%eax
  802117:	89 c5                	mov    %eax,%ebp
  802119:	89 d6                	mov    %edx,%esi
  80211b:	88 d9                	mov    %bl,%cl
  80211d:	d3 ee                	shr    %cl,%esi
  80211f:	89 f9                	mov    %edi,%ecx
  802121:	d3 e2                	shl    %cl,%edx
  802123:	8b 44 24 08          	mov    0x8(%esp),%eax
  802127:	88 d9                	mov    %bl,%cl
  802129:	d3 e8                	shr    %cl,%eax
  80212b:	09 c2                	or     %eax,%edx
  80212d:	89 d0                	mov    %edx,%eax
  80212f:	89 f2                	mov    %esi,%edx
  802131:	f7 74 24 0c          	divl   0xc(%esp)
  802135:	89 d6                	mov    %edx,%esi
  802137:	89 c3                	mov    %eax,%ebx
  802139:	f7 e5                	mul    %ebp
  80213b:	39 d6                	cmp    %edx,%esi
  80213d:	72 19                	jb     802158 <__udivdi3+0xfc>
  80213f:	74 0b                	je     80214c <__udivdi3+0xf0>
  802141:	89 d8                	mov    %ebx,%eax
  802143:	31 ff                	xor    %edi,%edi
  802145:	e9 58 ff ff ff       	jmp    8020a2 <__udivdi3+0x46>
  80214a:	66 90                	xchg   %ax,%ax
  80214c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802150:	89 f9                	mov    %edi,%ecx
  802152:	d3 e2                	shl    %cl,%edx
  802154:	39 c2                	cmp    %eax,%edx
  802156:	73 e9                	jae    802141 <__udivdi3+0xe5>
  802158:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80215b:	31 ff                	xor    %edi,%edi
  80215d:	e9 40 ff ff ff       	jmp    8020a2 <__udivdi3+0x46>
  802162:	66 90                	xchg   %ax,%ax
  802164:	31 c0                	xor    %eax,%eax
  802166:	e9 37 ff ff ff       	jmp    8020a2 <__udivdi3+0x46>
  80216b:	90                   	nop

0080216c <__umoddi3>:
  80216c:	55                   	push   %ebp
  80216d:	57                   	push   %edi
  80216e:	56                   	push   %esi
  80216f:	53                   	push   %ebx
  802170:	83 ec 1c             	sub    $0x1c,%esp
  802173:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802177:	8b 74 24 34          	mov    0x34(%esp),%esi
  80217b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80217f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802183:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802187:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80218b:	89 f3                	mov    %esi,%ebx
  80218d:	89 fa                	mov    %edi,%edx
  80218f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802193:	89 34 24             	mov    %esi,(%esp)
  802196:	85 c0                	test   %eax,%eax
  802198:	75 1a                	jne    8021b4 <__umoddi3+0x48>
  80219a:	39 f7                	cmp    %esi,%edi
  80219c:	0f 86 a2 00 00 00    	jbe    802244 <__umoddi3+0xd8>
  8021a2:	89 c8                	mov    %ecx,%eax
  8021a4:	89 f2                	mov    %esi,%edx
  8021a6:	f7 f7                	div    %edi
  8021a8:	89 d0                	mov    %edx,%eax
  8021aa:	31 d2                	xor    %edx,%edx
  8021ac:	83 c4 1c             	add    $0x1c,%esp
  8021af:	5b                   	pop    %ebx
  8021b0:	5e                   	pop    %esi
  8021b1:	5f                   	pop    %edi
  8021b2:	5d                   	pop    %ebp
  8021b3:	c3                   	ret    
  8021b4:	39 f0                	cmp    %esi,%eax
  8021b6:	0f 87 ac 00 00 00    	ja     802268 <__umoddi3+0xfc>
  8021bc:	0f bd e8             	bsr    %eax,%ebp
  8021bf:	83 f5 1f             	xor    $0x1f,%ebp
  8021c2:	0f 84 ac 00 00 00    	je     802274 <__umoddi3+0x108>
  8021c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8021cd:	29 ef                	sub    %ebp,%edi
  8021cf:	89 fe                	mov    %edi,%esi
  8021d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021d5:	89 e9                	mov    %ebp,%ecx
  8021d7:	d3 e0                	shl    %cl,%eax
  8021d9:	89 d7                	mov    %edx,%edi
  8021db:	89 f1                	mov    %esi,%ecx
  8021dd:	d3 ef                	shr    %cl,%edi
  8021df:	09 c7                	or     %eax,%edi
  8021e1:	89 e9                	mov    %ebp,%ecx
  8021e3:	d3 e2                	shl    %cl,%edx
  8021e5:	89 14 24             	mov    %edx,(%esp)
  8021e8:	89 d8                	mov    %ebx,%eax
  8021ea:	d3 e0                	shl    %cl,%eax
  8021ec:	89 c2                	mov    %eax,%edx
  8021ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021f2:	d3 e0                	shl    %cl,%eax
  8021f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021fc:	89 f1                	mov    %esi,%ecx
  8021fe:	d3 e8                	shr    %cl,%eax
  802200:	09 d0                	or     %edx,%eax
  802202:	d3 eb                	shr    %cl,%ebx
  802204:	89 da                	mov    %ebx,%edx
  802206:	f7 f7                	div    %edi
  802208:	89 d3                	mov    %edx,%ebx
  80220a:	f7 24 24             	mull   (%esp)
  80220d:	89 c6                	mov    %eax,%esi
  80220f:	89 d1                	mov    %edx,%ecx
  802211:	39 d3                	cmp    %edx,%ebx
  802213:	0f 82 87 00 00 00    	jb     8022a0 <__umoddi3+0x134>
  802219:	0f 84 91 00 00 00    	je     8022b0 <__umoddi3+0x144>
  80221f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802223:	29 f2                	sub    %esi,%edx
  802225:	19 cb                	sbb    %ecx,%ebx
  802227:	89 d8                	mov    %ebx,%eax
  802229:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80222d:	d3 e0                	shl    %cl,%eax
  80222f:	89 e9                	mov    %ebp,%ecx
  802231:	d3 ea                	shr    %cl,%edx
  802233:	09 d0                	or     %edx,%eax
  802235:	89 e9                	mov    %ebp,%ecx
  802237:	d3 eb                	shr    %cl,%ebx
  802239:	89 da                	mov    %ebx,%edx
  80223b:	83 c4 1c             	add    $0x1c,%esp
  80223e:	5b                   	pop    %ebx
  80223f:	5e                   	pop    %esi
  802240:	5f                   	pop    %edi
  802241:	5d                   	pop    %ebp
  802242:	c3                   	ret    
  802243:	90                   	nop
  802244:	89 fd                	mov    %edi,%ebp
  802246:	85 ff                	test   %edi,%edi
  802248:	75 0b                	jne    802255 <__umoddi3+0xe9>
  80224a:	b8 01 00 00 00       	mov    $0x1,%eax
  80224f:	31 d2                	xor    %edx,%edx
  802251:	f7 f7                	div    %edi
  802253:	89 c5                	mov    %eax,%ebp
  802255:	89 f0                	mov    %esi,%eax
  802257:	31 d2                	xor    %edx,%edx
  802259:	f7 f5                	div    %ebp
  80225b:	89 c8                	mov    %ecx,%eax
  80225d:	f7 f5                	div    %ebp
  80225f:	89 d0                	mov    %edx,%eax
  802261:	e9 44 ff ff ff       	jmp    8021aa <__umoddi3+0x3e>
  802266:	66 90                	xchg   %ax,%ax
  802268:	89 c8                	mov    %ecx,%eax
  80226a:	89 f2                	mov    %esi,%edx
  80226c:	83 c4 1c             	add    $0x1c,%esp
  80226f:	5b                   	pop    %ebx
  802270:	5e                   	pop    %esi
  802271:	5f                   	pop    %edi
  802272:	5d                   	pop    %ebp
  802273:	c3                   	ret    
  802274:	3b 04 24             	cmp    (%esp),%eax
  802277:	72 06                	jb     80227f <__umoddi3+0x113>
  802279:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80227d:	77 0f                	ja     80228e <__umoddi3+0x122>
  80227f:	89 f2                	mov    %esi,%edx
  802281:	29 f9                	sub    %edi,%ecx
  802283:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802287:	89 14 24             	mov    %edx,(%esp)
  80228a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80228e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802292:	8b 14 24             	mov    (%esp),%edx
  802295:	83 c4 1c             	add    $0x1c,%esp
  802298:	5b                   	pop    %ebx
  802299:	5e                   	pop    %esi
  80229a:	5f                   	pop    %edi
  80229b:	5d                   	pop    %ebp
  80229c:	c3                   	ret    
  80229d:	8d 76 00             	lea    0x0(%esi),%esi
  8022a0:	2b 04 24             	sub    (%esp),%eax
  8022a3:	19 fa                	sbb    %edi,%edx
  8022a5:	89 d1                	mov    %edx,%ecx
  8022a7:	89 c6                	mov    %eax,%esi
  8022a9:	e9 71 ff ff ff       	jmp    80221f <__umoddi3+0xb3>
  8022ae:	66 90                	xchg   %ax,%ax
  8022b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8022b4:	72 ea                	jb     8022a0 <__umoddi3+0x134>
  8022b6:	89 d9                	mov    %ebx,%ecx
  8022b8:	e9 62 ff ff ff       	jmp    80221f <__umoddi3+0xb3>
