
obj/user/ef_MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 b4 01 00 00       	call   8001ea <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 40 23 80 00       	push   $0x802340
  80004a:	e8 a6 18 00 00       	call   8018f5 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	//cprintf("Do you want to use semaphore (y/n)? ") ;
	//char select = getchar() ;
	char select = 'y';
  80005e:	c6 45 f3 79          	movb   $0x79,-0xd(%ebp)
	//cputchar(select);
	//cputchar('\n');

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	6a 00                	push   $0x0
  800067:	6a 04                	push   $0x4
  800069:	68 42 23 80 00       	push   $0x802342
  80006e:	e8 82 18 00 00       	call   8018f5 <smalloc>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  800079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80007c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  800082:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  800086:	74 06                	je     80008e <_main+0x56>
  800088:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  80008c:	75 09                	jne    800097 <_main+0x5f>
		*useSem = 1 ;
  80008e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800091:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  800097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009a:	8b 00                	mov    (%eax),%eax
  80009c:	83 f8 01             	cmp    $0x1,%eax
  80009f:	75 12                	jne    8000b3 <_main+0x7b>
	{
		sys_createSemaphore("T", 0);
  8000a1:	83 ec 08             	sub    $0x8,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	68 49 23 80 00       	push   $0x802349
  8000ab:	e8 c6 1b 00 00       	call   801c76 <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 4b 23 80 00       	push   $0x80234b
  8000bf:	e8 31 18 00 00       	call   8018f5 <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d8:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  8000de:	89 c2                	mov    %eax,%edx
  8000e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e5:	8b 40 74             	mov    0x74(%eax),%eax
  8000e8:	6a 32                	push   $0x32
  8000ea:	52                   	push   %edx
  8000eb:	50                   	push   %eax
  8000ec:	68 59 23 80 00       	push   $0x802359
  8000f1:	e8 91 1c 00 00       	call   801d87 <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000fc:	a1 20 30 80 00       	mov    0x803020,%eax
  800101:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  800107:	89 c2                	mov    %eax,%edx
  800109:	a1 20 30 80 00       	mov    0x803020,%eax
  80010e:	8b 40 74             	mov    0x74(%eax),%eax
  800111:	6a 32                	push   $0x32
  800113:	52                   	push   %edx
  800114:	50                   	push   %eax
  800115:	68 63 23 80 00       	push   $0x802363
  80011a:	e8 68 1c 00 00       	call   801d87 <sys_create_env>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800125:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800129:	74 06                	je     800131 <_main+0xf9>
  80012b:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80012f:	75 14                	jne    800145 <_main+0x10d>
		panic("NO AVAILABLE ENVs...");
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	68 6d 23 80 00       	push   $0x80236d
  800139:	6a 27                	push   $0x27
  80013b:	68 82 23 80 00       	push   $0x802382
  800140:	e8 ea 01 00 00       	call   80032f <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014b:	e8 55 1c 00 00       	call   801da5 <sys_run_env>
  800150:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 10 27 00 00       	push   $0x2710
  80015b:	e8 c3 1e 00 00       	call   802023 <env_sleep>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 37 1c 00 00       	call   801da5 <sys_run_env>
  80016e:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800171:	90                   	nop
  800172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800175:	8b 00                	mov    (%eax),%eax
  800177:	83 f8 02             	cmp    $0x2,%eax
  80017a:	75 f6                	jne    800172 <_main+0x13a>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  80017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80017f:	8b 00                	mov    (%eax),%eax
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	50                   	push   %eax
  800185:	68 9d 23 80 00       	push   $0x80239d
  80018a:	e8 42 04 00 00       	call   8005d1 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800192:	e8 e9 18 00 00       	call   801a80 <sys_getparentenvid>
  800197:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  80019a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80019e:	7e 47                	jle    8001e7 <_main+0x1af>
	{
		//Get the check-finishing counter
		int *AllFinish = NULL;
  8001a0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		AllFinish = sget(parentenvID, "finishedCount") ;
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	68 4b 23 80 00       	push   $0x80234b
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	e8 61 17 00 00       	call   801918 <sget>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_free_env(envIdProcessA);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	e8 f9 1b 00 00       	call   801dc1 <sys_free_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
		sys_free_env(envIdProcessB);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d1:	e8 eb 1b 00 00       	call   801dc1 <sys_free_env>
  8001d6:	83 c4 10             	add    $0x10,%esp
		(*AllFinish)++ ;
  8001d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001dc:	8b 00                	mov    (%eax),%eax
  8001de:	8d 50 01             	lea    0x1(%eax),%edx
  8001e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001e4:	89 10                	mov    %edx,(%eax)
	}

	return;
  8001e6:	90                   	nop
  8001e7:	90                   	nop
}
  8001e8:	c9                   	leave  
  8001e9:	c3                   	ret    

008001ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001f0:	e8 72 18 00 00       	call   801a67 <sys_getenvindex>
  8001f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001fb:	89 d0                	mov    %edx,%eax
  8001fd:	c1 e0 03             	shl    $0x3,%eax
  800200:	01 d0                	add    %edx,%eax
  800202:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800209:	01 c8                	add    %ecx,%eax
  80020b:	01 c0                	add    %eax,%eax
  80020d:	01 d0                	add    %edx,%eax
  80020f:	01 c0                	add    %eax,%eax
  800211:	01 d0                	add    %edx,%eax
  800213:	89 c2                	mov    %eax,%edx
  800215:	c1 e2 05             	shl    $0x5,%edx
  800218:	29 c2                	sub    %eax,%edx
  80021a:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800221:	89 c2                	mov    %eax,%edx
  800223:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800229:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80022e:	a1 20 30 80 00       	mov    0x803020,%eax
  800233:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800239:	84 c0                	test   %al,%al
  80023b:	74 0f                	je     80024c <libmain+0x62>
		binaryname = myEnv->prog_name;
  80023d:	a1 20 30 80 00       	mov    0x803020,%eax
  800242:	05 40 3c 01 00       	add    $0x13c40,%eax
  800247:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80024c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800250:	7e 0a                	jle    80025c <libmain+0x72>
		binaryname = argv[0];
  800252:	8b 45 0c             	mov    0xc(%ebp),%eax
  800255:	8b 00                	mov    (%eax),%eax
  800257:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80025c:	83 ec 08             	sub    $0x8,%esp
  80025f:	ff 75 0c             	pushl  0xc(%ebp)
  800262:	ff 75 08             	pushl  0x8(%ebp)
  800265:	e8 ce fd ff ff       	call   800038 <_main>
  80026a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80026d:	e8 90 19 00 00       	call   801c02 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 cc 23 80 00       	push   $0x8023cc
  80027a:	e8 52 03 00 00       	call   8005d1 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800282:	a1 20 30 80 00       	mov    0x803020,%eax
  800287:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80028d:	a1 20 30 80 00       	mov    0x803020,%eax
  800292:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	52                   	push   %edx
  80029c:	50                   	push   %eax
  80029d:	68 f4 23 80 00       	push   $0x8023f4
  8002a2:	e8 2a 03 00 00       	call   8005d1 <cprintf>
  8002a7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8002aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8002af:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8002b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ba:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8002c0:	83 ec 04             	sub    $0x4,%esp
  8002c3:	52                   	push   %edx
  8002c4:	50                   	push   %eax
  8002c5:	68 1c 24 80 00       	push   $0x80241c
  8002ca:	e8 02 03 00 00       	call   8005d1 <cprintf>
  8002cf:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d7:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	50                   	push   %eax
  8002e1:	68 5d 24 80 00       	push   $0x80245d
  8002e6:	e8 e6 02 00 00       	call   8005d1 <cprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002ee:	83 ec 0c             	sub    $0xc,%esp
  8002f1:	68 cc 23 80 00       	push   $0x8023cc
  8002f6:	e8 d6 02 00 00       	call   8005d1 <cprintf>
  8002fb:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002fe:	e8 19 19 00 00       	call   801c1c <sys_enable_interrupt>

	// exit gracefully
	exit();
  800303:	e8 19 00 00 00       	call   800321 <exit>
}
  800308:	90                   	nop
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800311:	83 ec 0c             	sub    $0xc,%esp
  800314:	6a 00                	push   $0x0
  800316:	e8 18 17 00 00       	call   801a33 <sys_env_destroy>
  80031b:	83 c4 10             	add    $0x10,%esp
}
  80031e:	90                   	nop
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <exit>:

void
exit(void)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800327:	e8 6d 17 00 00       	call   801a99 <sys_env_exit>
}
  80032c:	90                   	nop
  80032d:	c9                   	leave  
  80032e:	c3                   	ret    

0080032f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800335:	8d 45 10             	lea    0x10(%ebp),%eax
  800338:	83 c0 04             	add    $0x4,%eax
  80033b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80033e:	a1 18 31 80 00       	mov    0x803118,%eax
  800343:	85 c0                	test   %eax,%eax
  800345:	74 16                	je     80035d <_panic+0x2e>
		cprintf("%s: ", argv0);
  800347:	a1 18 31 80 00       	mov    0x803118,%eax
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	50                   	push   %eax
  800350:	68 74 24 80 00       	push   $0x802474
  800355:	e8 77 02 00 00       	call   8005d1 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80035d:	a1 00 30 80 00       	mov    0x803000,%eax
  800362:	ff 75 0c             	pushl  0xc(%ebp)
  800365:	ff 75 08             	pushl  0x8(%ebp)
  800368:	50                   	push   %eax
  800369:	68 79 24 80 00       	push   $0x802479
  80036e:	e8 5e 02 00 00       	call   8005d1 <cprintf>
  800373:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800376:	8b 45 10             	mov    0x10(%ebp),%eax
  800379:	83 ec 08             	sub    $0x8,%esp
  80037c:	ff 75 f4             	pushl  -0xc(%ebp)
  80037f:	50                   	push   %eax
  800380:	e8 e1 01 00 00       	call   800566 <vcprintf>
  800385:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	6a 00                	push   $0x0
  80038d:	68 95 24 80 00       	push   $0x802495
  800392:	e8 cf 01 00 00       	call   800566 <vcprintf>
  800397:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80039a:	e8 82 ff ff ff       	call   800321 <exit>

	// should not return here
	while (1) ;
  80039f:	eb fe                	jmp    80039f <_panic+0x70>

008003a1 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ac:	8b 50 74             	mov    0x74(%eax),%edx
  8003af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b2:	39 c2                	cmp    %eax,%edx
  8003b4:	74 14                	je     8003ca <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	68 98 24 80 00       	push   $0x802498
  8003be:	6a 26                	push   $0x26
  8003c0:	68 e4 24 80 00       	push   $0x8024e4
  8003c5:	e8 65 ff ff ff       	call   80032f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d8:	e9 b6 00 00 00       	jmp    800493 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8003dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ea:	01 d0                	add    %edx,%eax
  8003ec:	8b 00                	mov    (%eax),%eax
  8003ee:	85 c0                	test   %eax,%eax
  8003f0:	75 08                	jne    8003fa <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003f2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003f5:	e9 96 00 00 00       	jmp    800490 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8003fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800401:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800408:	eb 5d                	jmp    800467 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80040a:	a1 20 30 80 00       	mov    0x803020,%eax
  80040f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800415:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800418:	c1 e2 04             	shl    $0x4,%edx
  80041b:	01 d0                	add    %edx,%eax
  80041d:	8a 40 04             	mov    0x4(%eax),%al
  800420:	84 c0                	test   %al,%al
  800422:	75 40                	jne    800464 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800424:	a1 20 30 80 00       	mov    0x803020,%eax
  800429:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80042f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800432:	c1 e2 04             	shl    $0x4,%edx
  800435:	01 d0                	add    %edx,%eax
  800437:	8b 00                	mov    (%eax),%eax
  800439:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80043c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80043f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800444:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800449:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800450:	8b 45 08             	mov    0x8(%ebp),%eax
  800453:	01 c8                	add    %ecx,%eax
  800455:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800457:	39 c2                	cmp    %eax,%edx
  800459:	75 09                	jne    800464 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  80045b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800462:	eb 12                	jmp    800476 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800464:	ff 45 e8             	incl   -0x18(%ebp)
  800467:	a1 20 30 80 00       	mov    0x803020,%eax
  80046c:	8b 50 74             	mov    0x74(%eax),%edx
  80046f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	77 94                	ja     80040a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800476:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80047a:	75 14                	jne    800490 <CheckWSWithoutLastIndex+0xef>
			panic(
  80047c:	83 ec 04             	sub    $0x4,%esp
  80047f:	68 f0 24 80 00       	push   $0x8024f0
  800484:	6a 3a                	push   $0x3a
  800486:	68 e4 24 80 00       	push   $0x8024e4
  80048b:	e8 9f fe ff ff       	call   80032f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800490:	ff 45 f0             	incl   -0x10(%ebp)
  800493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800496:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800499:	0f 8c 3e ff ff ff    	jl     8003dd <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80049f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004ad:	eb 20                	jmp    8004cf <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004af:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b4:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8004ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004bd:	c1 e2 04             	shl    $0x4,%edx
  8004c0:	01 d0                	add    %edx,%eax
  8004c2:	8a 40 04             	mov    0x4(%eax),%al
  8004c5:	3c 01                	cmp    $0x1,%al
  8004c7:	75 03                	jne    8004cc <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8004c9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004cc:	ff 45 e0             	incl   -0x20(%ebp)
  8004cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d4:	8b 50 74             	mov    0x74(%eax),%edx
  8004d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004da:	39 c2                	cmp    %eax,%edx
  8004dc:	77 d1                	ja     8004af <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004e4:	74 14                	je     8004fa <CheckWSWithoutLastIndex+0x159>
		panic(
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 44 25 80 00       	push   $0x802544
  8004ee:	6a 44                	push   $0x44
  8004f0:	68 e4 24 80 00       	push   $0x8024e4
  8004f5:	e8 35 fe ff ff       	call   80032f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004fa:	90                   	nop
  8004fb:	c9                   	leave  
  8004fc:	c3                   	ret    

008004fd <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800503:	8b 45 0c             	mov    0xc(%ebp),%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	8d 48 01             	lea    0x1(%eax),%ecx
  80050b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80050e:	89 0a                	mov    %ecx,(%edx)
  800510:	8b 55 08             	mov    0x8(%ebp),%edx
  800513:	88 d1                	mov    %dl,%cl
  800515:	8b 55 0c             	mov    0xc(%ebp),%edx
  800518:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	3d ff 00 00 00       	cmp    $0xff,%eax
  800526:	75 2c                	jne    800554 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800528:	a0 24 30 80 00       	mov    0x803024,%al
  80052d:	0f b6 c0             	movzbl %al,%eax
  800530:	8b 55 0c             	mov    0xc(%ebp),%edx
  800533:	8b 12                	mov    (%edx),%edx
  800535:	89 d1                	mov    %edx,%ecx
  800537:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053a:	83 c2 08             	add    $0x8,%edx
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	50                   	push   %eax
  800541:	51                   	push   %ecx
  800542:	52                   	push   %edx
  800543:	e8 a9 14 00 00       	call   8019f1 <sys_cputs>
  800548:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80054b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	8b 40 04             	mov    0x4(%eax),%eax
  80055a:	8d 50 01             	lea    0x1(%eax),%edx
  80055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800560:	89 50 04             	mov    %edx,0x4(%eax)
}
  800563:	90                   	nop
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80056f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800576:	00 00 00 
	b.cnt = 0;
  800579:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800580:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800583:	ff 75 0c             	pushl  0xc(%ebp)
  800586:	ff 75 08             	pushl  0x8(%ebp)
  800589:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80058f:	50                   	push   %eax
  800590:	68 fd 04 80 00       	push   $0x8004fd
  800595:	e8 11 02 00 00       	call   8007ab <vprintfmt>
  80059a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80059d:	a0 24 30 80 00       	mov    0x803024,%al
  8005a2:	0f b6 c0             	movzbl %al,%eax
  8005a5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005ab:	83 ec 04             	sub    $0x4,%esp
  8005ae:	50                   	push   %eax
  8005af:	52                   	push   %edx
  8005b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b6:	83 c0 08             	add    $0x8,%eax
  8005b9:	50                   	push   %eax
  8005ba:	e8 32 14 00 00       	call   8019f1 <sys_cputs>
  8005bf:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005c2:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8005c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005cf:	c9                   	leave  
  8005d0:	c3                   	ret    

008005d1 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005d1:	55                   	push   %ebp
  8005d2:	89 e5                	mov    %esp,%ebp
  8005d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d7:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ed:	50                   	push   %eax
  8005ee:	e8 73 ff ff ff       	call   800566 <vcprintf>
  8005f3:	83 c4 10             	add    $0x10,%esp
  8005f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005fc:	c9                   	leave  
  8005fd:	c3                   	ret    

008005fe <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800604:	e8 f9 15 00 00       	call   801c02 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800609:	8d 45 0c             	lea    0xc(%ebp),%eax
  80060c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80060f:	8b 45 08             	mov    0x8(%ebp),%eax
  800612:	83 ec 08             	sub    $0x8,%esp
  800615:	ff 75 f4             	pushl  -0xc(%ebp)
  800618:	50                   	push   %eax
  800619:	e8 48 ff ff ff       	call   800566 <vcprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
  800621:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800624:	e8 f3 15 00 00       	call   801c1c <sys_enable_interrupt>
	return cnt;
  800629:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80062c:	c9                   	leave  
  80062d:	c3                   	ret    

0080062e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80062e:	55                   	push   %ebp
  80062f:	89 e5                	mov    %esp,%ebp
  800631:	53                   	push   %ebx
  800632:	83 ec 14             	sub    $0x14,%esp
  800635:	8b 45 10             	mov    0x10(%ebp),%eax
  800638:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800641:	8b 45 18             	mov    0x18(%ebp),%eax
  800644:	ba 00 00 00 00       	mov    $0x0,%edx
  800649:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80064c:	77 55                	ja     8006a3 <printnum+0x75>
  80064e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800651:	72 05                	jb     800658 <printnum+0x2a>
  800653:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800656:	77 4b                	ja     8006a3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800658:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80065b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80065e:	8b 45 18             	mov    0x18(%ebp),%eax
  800661:	ba 00 00 00 00       	mov    $0x0,%edx
  800666:	52                   	push   %edx
  800667:	50                   	push   %eax
  800668:	ff 75 f4             	pushl  -0xc(%ebp)
  80066b:	ff 75 f0             	pushl  -0x10(%ebp)
  80066e:	e8 65 1a 00 00       	call   8020d8 <__udivdi3>
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	83 ec 04             	sub    $0x4,%esp
  800679:	ff 75 20             	pushl  0x20(%ebp)
  80067c:	53                   	push   %ebx
  80067d:	ff 75 18             	pushl  0x18(%ebp)
  800680:	52                   	push   %edx
  800681:	50                   	push   %eax
  800682:	ff 75 0c             	pushl  0xc(%ebp)
  800685:	ff 75 08             	pushl  0x8(%ebp)
  800688:	e8 a1 ff ff ff       	call   80062e <printnum>
  80068d:	83 c4 20             	add    $0x20,%esp
  800690:	eb 1a                	jmp    8006ac <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 0c             	pushl  0xc(%ebp)
  800698:	ff 75 20             	pushl  0x20(%ebp)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	ff d0                	call   *%eax
  8006a0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006a3:	ff 4d 1c             	decl   0x1c(%ebp)
  8006a6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006aa:	7f e6                	jg     800692 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ac:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ba:	53                   	push   %ebx
  8006bb:	51                   	push   %ecx
  8006bc:	52                   	push   %edx
  8006bd:	50                   	push   %eax
  8006be:	e8 25 1b 00 00       	call   8021e8 <__umoddi3>
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	05 b4 27 80 00       	add    $0x8027b4,%eax
  8006cb:	8a 00                	mov    (%eax),%al
  8006cd:	0f be c0             	movsbl %al,%eax
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	50                   	push   %eax
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	ff d0                	call   *%eax
  8006dc:	83 c4 10             	add    $0x10,%esp
}
  8006df:	90                   	nop
  8006e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

008006e5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ec:	7e 1c                	jle    80070a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	8d 50 08             	lea    0x8(%eax),%edx
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	89 10                	mov    %edx,(%eax)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	83 e8 08             	sub    $0x8,%eax
  800703:	8b 50 04             	mov    0x4(%eax),%edx
  800706:	8b 00                	mov    (%eax),%eax
  800708:	eb 40                	jmp    80074a <getuint+0x65>
	else if (lflag)
  80070a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070e:	74 1e                	je     80072e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	8d 50 04             	lea    0x4(%eax),%edx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	89 10                	mov    %edx,(%eax)
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	83 e8 04             	sub    $0x4,%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
  80072c:	eb 1c                	jmp    80074a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	8d 50 04             	lea    0x4(%eax),%edx
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	89 10                	mov    %edx,(%eax)
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	83 e8 04             	sub    $0x4,%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80074a:	5d                   	pop    %ebp
  80074b:	c3                   	ret    

0080074c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80074c:	55                   	push   %ebp
  80074d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80074f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800753:	7e 1c                	jle    800771 <getint+0x25>
		return va_arg(*ap, long long);
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	8d 50 08             	lea    0x8(%eax),%edx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	89 10                	mov    %edx,(%eax)
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	83 e8 08             	sub    $0x8,%eax
  80076a:	8b 50 04             	mov    0x4(%eax),%edx
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	eb 38                	jmp    8007a9 <getint+0x5d>
	else if (lflag)
  800771:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800775:	74 1a                	je     800791 <getint+0x45>
		return va_arg(*ap, long);
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	8b 00                	mov    (%eax),%eax
  80077c:	8d 50 04             	lea    0x4(%eax),%edx
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	89 10                	mov    %edx,(%eax)
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	8b 00                	mov    (%eax),%eax
  800789:	83 e8 04             	sub    $0x4,%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	99                   	cltd   
  80078f:	eb 18                	jmp    8007a9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	8d 50 04             	lea    0x4(%eax),%edx
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	89 10                	mov    %edx,(%eax)
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	83 e8 04             	sub    $0x4,%eax
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	99                   	cltd   
}
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	56                   	push   %esi
  8007af:	53                   	push   %ebx
  8007b0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b3:	eb 17                	jmp    8007cc <vprintfmt+0x21>
			if (ch == '\0')
  8007b5:	85 db                	test   %ebx,%ebx
  8007b7:	0f 84 af 03 00 00    	je     800b6c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	ff 75 0c             	pushl  0xc(%ebp)
  8007c3:	53                   	push   %ebx
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	ff d0                	call   *%eax
  8007c9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007cf:	8d 50 01             	lea    0x1(%eax),%edx
  8007d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d5:	8a 00                	mov    (%eax),%al
  8007d7:	0f b6 d8             	movzbl %al,%ebx
  8007da:	83 fb 25             	cmp    $0x25,%ebx
  8007dd:	75 d6                	jne    8007b5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007df:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007e3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007ea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800802:	8d 50 01             	lea    0x1(%eax),%edx
  800805:	89 55 10             	mov    %edx,0x10(%ebp)
  800808:	8a 00                	mov    (%eax),%al
  80080a:	0f b6 d8             	movzbl %al,%ebx
  80080d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800810:	83 f8 55             	cmp    $0x55,%eax
  800813:	0f 87 2b 03 00 00    	ja     800b44 <vprintfmt+0x399>
  800819:	8b 04 85 d8 27 80 00 	mov    0x8027d8(,%eax,4),%eax
  800820:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800822:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800826:	eb d7                	jmp    8007ff <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800828:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80082c:	eb d1                	jmp    8007ff <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80082e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800835:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800838:	89 d0                	mov    %edx,%eax
  80083a:	c1 e0 02             	shl    $0x2,%eax
  80083d:	01 d0                	add    %edx,%eax
  80083f:	01 c0                	add    %eax,%eax
  800841:	01 d8                	add    %ebx,%eax
  800843:	83 e8 30             	sub    $0x30,%eax
  800846:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800849:	8b 45 10             	mov    0x10(%ebp),%eax
  80084c:	8a 00                	mov    (%eax),%al
  80084e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800851:	83 fb 2f             	cmp    $0x2f,%ebx
  800854:	7e 3e                	jle    800894 <vprintfmt+0xe9>
  800856:	83 fb 39             	cmp    $0x39,%ebx
  800859:	7f 39                	jg     800894 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80085b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80085e:	eb d5                	jmp    800835 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	83 c0 04             	add    $0x4,%eax
  800866:	89 45 14             	mov    %eax,0x14(%ebp)
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	83 e8 04             	sub    $0x4,%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800874:	eb 1f                	jmp    800895 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800876:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087a:	79 83                	jns    8007ff <vprintfmt+0x54>
				width = 0;
  80087c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800883:	e9 77 ff ff ff       	jmp    8007ff <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800888:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80088f:	e9 6b ff ff ff       	jmp    8007ff <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800894:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800895:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800899:	0f 89 60 ff ff ff    	jns    8007ff <vprintfmt+0x54>
				width = precision, precision = -1;
  80089f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008ac:	e9 4e ff ff ff       	jmp    8007ff <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008b1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008b4:	e9 46 ff ff ff       	jmp    8007ff <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	83 c0 04             	add    $0x4,%eax
  8008bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	83 e8 04             	sub    $0x4,%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	50                   	push   %eax
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	ff d0                	call   *%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
			break;
  8008d9:	e9 89 02 00 00       	jmp    800b67 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008de:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e1:	83 c0 04             	add    $0x4,%eax
  8008e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	83 e8 04             	sub    $0x4,%eax
  8008ed:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008ef:	85 db                	test   %ebx,%ebx
  8008f1:	79 02                	jns    8008f5 <vprintfmt+0x14a>
				err = -err;
  8008f3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008f5:	83 fb 64             	cmp    $0x64,%ebx
  8008f8:	7f 0b                	jg     800905 <vprintfmt+0x15a>
  8008fa:	8b 34 9d 20 26 80 00 	mov    0x802620(,%ebx,4),%esi
  800901:	85 f6                	test   %esi,%esi
  800903:	75 19                	jne    80091e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800905:	53                   	push   %ebx
  800906:	68 c5 27 80 00       	push   $0x8027c5
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	ff 75 08             	pushl  0x8(%ebp)
  800911:	e8 5e 02 00 00       	call   800b74 <printfmt>
  800916:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800919:	e9 49 02 00 00       	jmp    800b67 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80091e:	56                   	push   %esi
  80091f:	68 ce 27 80 00       	push   $0x8027ce
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	ff 75 08             	pushl  0x8(%ebp)
  80092a:	e8 45 02 00 00       	call   800b74 <printfmt>
  80092f:	83 c4 10             	add    $0x10,%esp
			break;
  800932:	e9 30 02 00 00       	jmp    800b67 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	83 c0 04             	add    $0x4,%eax
  80093d:	89 45 14             	mov    %eax,0x14(%ebp)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 e8 04             	sub    $0x4,%eax
  800946:	8b 30                	mov    (%eax),%esi
  800948:	85 f6                	test   %esi,%esi
  80094a:	75 05                	jne    800951 <vprintfmt+0x1a6>
				p = "(null)";
  80094c:	be d1 27 80 00       	mov    $0x8027d1,%esi
			if (width > 0 && padc != '-')
  800951:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800955:	7e 6d                	jle    8009c4 <vprintfmt+0x219>
  800957:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80095b:	74 67                	je     8009c4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80095d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800960:	83 ec 08             	sub    $0x8,%esp
  800963:	50                   	push   %eax
  800964:	56                   	push   %esi
  800965:	e8 0c 03 00 00       	call   800c76 <strnlen>
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800970:	eb 16                	jmp    800988 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800972:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	50                   	push   %eax
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800985:	ff 4d e4             	decl   -0x1c(%ebp)
  800988:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098c:	7f e4                	jg     800972 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098e:	eb 34                	jmp    8009c4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800990:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800994:	74 1c                	je     8009b2 <vprintfmt+0x207>
  800996:	83 fb 1f             	cmp    $0x1f,%ebx
  800999:	7e 05                	jle    8009a0 <vprintfmt+0x1f5>
  80099b:	83 fb 7e             	cmp    $0x7e,%ebx
  80099e:	7e 12                	jle    8009b2 <vprintfmt+0x207>
					putch('?', putdat);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	6a 3f                	push   $0x3f
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
  8009b0:	eb 0f                	jmp    8009c1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 0c             	pushl  0xc(%ebp)
  8009b8:	53                   	push   %ebx
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	ff d0                	call   *%eax
  8009be:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c1:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c4:	89 f0                	mov    %esi,%eax
  8009c6:	8d 70 01             	lea    0x1(%eax),%esi
  8009c9:	8a 00                	mov    (%eax),%al
  8009cb:	0f be d8             	movsbl %al,%ebx
  8009ce:	85 db                	test   %ebx,%ebx
  8009d0:	74 24                	je     8009f6 <vprintfmt+0x24b>
  8009d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d6:	78 b8                	js     800990 <vprintfmt+0x1e5>
  8009d8:	ff 4d e0             	decl   -0x20(%ebp)
  8009db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009df:	79 af                	jns    800990 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e1:	eb 13                	jmp    8009f6 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009e3:	83 ec 08             	sub    $0x8,%esp
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	6a 20                	push   $0x20
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	ff d0                	call   *%eax
  8009f0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f3:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fa:	7f e7                	jg     8009e3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009fc:	e9 66 01 00 00       	jmp    800b67 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a01:	83 ec 08             	sub    $0x8,%esp
  800a04:	ff 75 e8             	pushl  -0x18(%ebp)
  800a07:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0a:	50                   	push   %eax
  800a0b:	e8 3c fd ff ff       	call   80074c <getint>
  800a10:	83 c4 10             	add    $0x10,%esp
  800a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a16:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1f:	85 d2                	test   %edx,%edx
  800a21:	79 23                	jns    800a46 <vprintfmt+0x29b>
				putch('-', putdat);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 0c             	pushl  0xc(%ebp)
  800a29:	6a 2d                	push   $0x2d
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	ff d0                	call   *%eax
  800a30:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a39:	f7 d8                	neg    %eax
  800a3b:	83 d2 00             	adc    $0x0,%edx
  800a3e:	f7 da                	neg    %edx
  800a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a46:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a4d:	e9 bc 00 00 00       	jmp    800b0e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 e8             	pushl  -0x18(%ebp)
  800a58:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5b:	50                   	push   %eax
  800a5c:	e8 84 fc ff ff       	call   8006e5 <getuint>
  800a61:	83 c4 10             	add    $0x10,%esp
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a6a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a71:	e9 98 00 00 00       	jmp    800b0e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	6a 58                	push   $0x58
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	ff d0                	call   *%eax
  800a83:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	6a 58                	push   $0x58
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 58                	push   $0x58
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
			break;
  800aa6:	e9 bc 00 00 00       	jmp    800b67 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	6a 30                	push   $0x30
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	ff d0                	call   *%eax
  800ab8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	6a 78                	push   $0x78
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	ff d0                	call   *%eax
  800ac8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800acb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ace:	83 c0 04             	add    $0x4,%eax
  800ad1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad7:	83 e8 04             	sub    $0x4,%eax
  800ada:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800adf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ae6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aed:	eb 1f                	jmp    800b0e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	ff 75 e8             	pushl  -0x18(%ebp)
  800af5:	8d 45 14             	lea    0x14(%ebp),%eax
  800af8:	50                   	push   %eax
  800af9:	e8 e7 fb ff ff       	call   8006e5 <getuint>
  800afe:	83 c4 10             	add    $0x10,%esp
  800b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b04:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b0e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b15:	83 ec 04             	sub    $0x4,%esp
  800b18:	52                   	push   %edx
  800b19:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b1c:	50                   	push   %eax
  800b1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b20:	ff 75 f0             	pushl  -0x10(%ebp)
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	ff 75 08             	pushl  0x8(%ebp)
  800b29:	e8 00 fb ff ff       	call   80062e <printnum>
  800b2e:	83 c4 20             	add    $0x20,%esp
			break;
  800b31:	eb 34                	jmp    800b67 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	53                   	push   %ebx
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
			break;
  800b42:	eb 23                	jmp    800b67 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	6a 25                	push   $0x25
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	ff d0                	call   *%eax
  800b51:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b54:	ff 4d 10             	decl   0x10(%ebp)
  800b57:	eb 03                	jmp    800b5c <vprintfmt+0x3b1>
  800b59:	ff 4d 10             	decl   0x10(%ebp)
  800b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5f:	48                   	dec    %eax
  800b60:	8a 00                	mov    (%eax),%al
  800b62:	3c 25                	cmp    $0x25,%al
  800b64:	75 f3                	jne    800b59 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b66:	90                   	nop
		}
	}
  800b67:	e9 47 fc ff ff       	jmp    8007b3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b6c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b70:	5b                   	pop    %ebx
  800b71:	5e                   	pop    %esi
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b7a:	8d 45 10             	lea    0x10(%ebp),%eax
  800b7d:	83 c0 04             	add    $0x4,%eax
  800b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b83:	8b 45 10             	mov    0x10(%ebp),%eax
  800b86:	ff 75 f4             	pushl  -0xc(%ebp)
  800b89:	50                   	push   %eax
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	ff 75 08             	pushl  0x8(%ebp)
  800b90:	e8 16 fc ff ff       	call   8007ab <vprintfmt>
  800b95:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b98:	90                   	nop
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba1:	8b 40 08             	mov    0x8(%eax),%eax
  800ba4:	8d 50 01             	lea    0x1(%eax),%edx
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb0:	8b 10                	mov    (%eax),%edx
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	8b 40 04             	mov    0x4(%eax),%eax
  800bb8:	39 c2                	cmp    %eax,%edx
  800bba:	73 12                	jae    800bce <sprintputch+0x33>
		*b->buf++ = ch;
  800bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	8d 48 01             	lea    0x1(%eax),%ecx
  800bc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc7:	89 0a                	mov    %ecx,(%edx)
  800bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcc:	88 10                	mov    %dl,(%eax)
}
  800bce:	90                   	nop
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	01 d0                	add    %edx,%eax
  800be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bf6:	74 06                	je     800bfe <vsnprintf+0x2d>
  800bf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfc:	7f 07                	jg     800c05 <vsnprintf+0x34>
		return -E_INVAL;
  800bfe:	b8 03 00 00 00       	mov    $0x3,%eax
  800c03:	eb 20                	jmp    800c25 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c05:	ff 75 14             	pushl  0x14(%ebp)
  800c08:	ff 75 10             	pushl  0x10(%ebp)
  800c0b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c0e:	50                   	push   %eax
  800c0f:	68 9b 0b 80 00       	push   $0x800b9b
  800c14:	e8 92 fb ff ff       	call   8007ab <vprintfmt>
  800c19:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c1f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c2d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c30:	83 c0 04             	add    $0x4,%eax
  800c33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c36:	8b 45 10             	mov    0x10(%ebp),%eax
  800c39:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3c:	50                   	push   %eax
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	ff 75 08             	pushl  0x8(%ebp)
  800c43:	e8 89 ff ff ff       	call   800bd1 <vsnprintf>
  800c48:	83 c4 10             	add    $0x10,%esp
  800c4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c60:	eb 06                	jmp    800c68 <strlen+0x15>
		n++;
  800c62:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c65:	ff 45 08             	incl   0x8(%ebp)
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	84 c0                	test   %al,%al
  800c6f:	75 f1                	jne    800c62 <strlen+0xf>
		n++;
	return n;
  800c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c83:	eb 09                	jmp    800c8e <strnlen+0x18>
		n++;
  800c85:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c88:	ff 45 08             	incl   0x8(%ebp)
  800c8b:	ff 4d 0c             	decl   0xc(%ebp)
  800c8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c92:	74 09                	je     800c9d <strnlen+0x27>
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	8a 00                	mov    (%eax),%al
  800c99:	84 c0                	test   %al,%al
  800c9b:	75 e8                	jne    800c85 <strnlen+0xf>
		n++;
	return n;
  800c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca0:	c9                   	leave  
  800ca1:	c3                   	ret    

00800ca2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cae:	90                   	nop
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8d 50 01             	lea    0x1(%eax),%edx
  800cb5:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cc1:	8a 12                	mov    (%edx),%dl
  800cc3:	88 10                	mov    %dl,(%eax)
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	84 c0                	test   %al,%al
  800cc9:	75 e4                	jne    800caf <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ccb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cce:	c9                   	leave  
  800ccf:	c3                   	ret    

00800cd0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce3:	eb 1f                	jmp    800d04 <strncpy+0x34>
		*dst++ = *src;
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8d 50 01             	lea    0x1(%eax),%edx
  800ceb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf1:	8a 12                	mov    (%edx),%dl
  800cf3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	74 03                	je     800d01 <strncpy+0x31>
			src++;
  800cfe:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d01:	ff 45 fc             	incl   -0x4(%ebp)
  800d04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d07:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d0a:	72 d9                	jb     800ce5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d0f:	c9                   	leave  
  800d10:	c3                   	ret    

00800d11 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d21:	74 30                	je     800d53 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d23:	eb 16                	jmp    800d3b <strlcpy+0x2a>
			*dst++ = *src++;
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8d 50 01             	lea    0x1(%eax),%edx
  800d2b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d34:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d37:	8a 12                	mov    (%edx),%dl
  800d39:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d3b:	ff 4d 10             	decl   0x10(%ebp)
  800d3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d42:	74 09                	je     800d4d <strlcpy+0x3c>
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	84 c0                	test   %al,%al
  800d4b:	75 d8                	jne    800d25 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d59:	29 c2                	sub    %eax,%edx
  800d5b:	89 d0                	mov    %edx,%eax
}
  800d5d:	c9                   	leave  
  800d5e:	c3                   	ret    

00800d5f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d62:	eb 06                	jmp    800d6a <strcmp+0xb>
		p++, q++;
  800d64:	ff 45 08             	incl   0x8(%ebp)
  800d67:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	84 c0                	test   %al,%al
  800d71:	74 0e                	je     800d81 <strcmp+0x22>
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 10                	mov    (%eax),%dl
  800d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	38 c2                	cmp    %al,%dl
  800d7f:	74 e3                	je     800d64 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f b6 d0             	movzbl %al,%edx
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	0f b6 c0             	movzbl %al,%eax
  800d91:	29 c2                	sub    %eax,%edx
  800d93:	89 d0                	mov    %edx,%eax
}
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    

00800d97 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d9a:	eb 09                	jmp    800da5 <strncmp+0xe>
		n--, p++, q++;
  800d9c:	ff 4d 10             	decl   0x10(%ebp)
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800da5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da9:	74 17                	je     800dc2 <strncmp+0x2b>
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	84 c0                	test   %al,%al
  800db2:	74 0e                	je     800dc2 <strncmp+0x2b>
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 10                	mov    (%eax),%dl
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	38 c2                	cmp    %al,%dl
  800dc0:	74 da                	je     800d9c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc6:	75 07                	jne    800dcf <strncmp+0x38>
		return 0;
  800dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800dcd:	eb 14                	jmp    800de3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 d0             	movzbl %al,%edx
  800dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	0f b6 c0             	movzbl %al,%eax
  800ddf:	29 c2                	sub    %eax,%edx
  800de1:	89 d0                	mov    %edx,%eax
}
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    

00800de5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 04             	sub    $0x4,%esp
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800df1:	eb 12                	jmp    800e05 <strchr+0x20>
		if (*s == c)
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8a 00                	mov    (%eax),%al
  800df8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dfb:	75 05                	jne    800e02 <strchr+0x1d>
			return (char *) s;
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	eb 11                	jmp    800e13 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e02:	ff 45 08             	incl   0x8(%ebp)
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 00                	mov    (%eax),%al
  800e0a:	84 c0                	test   %al,%al
  800e0c:	75 e5                	jne    800df3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e13:	c9                   	leave  
  800e14:	c3                   	ret    

00800e15 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	83 ec 04             	sub    $0x4,%esp
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e21:	eb 0d                	jmp    800e30 <strfind+0x1b>
		if (*s == c)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e2b:	74 0e                	je     800e3b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e2d:	ff 45 08             	incl   0x8(%ebp)
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	84 c0                	test   %al,%al
  800e37:	75 ea                	jne    800e23 <strfind+0xe>
  800e39:	eb 01                	jmp    800e3c <strfind+0x27>
		if (*s == c)
			break;
  800e3b:	90                   	nop
	return (char *) s;
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3f:	c9                   	leave  
  800e40:	c3                   	ret    

00800e41 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e53:	eb 0e                	jmp    800e63 <memset+0x22>
		*p++ = c;
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e58:	8d 50 01             	lea    0x1(%eax),%edx
  800e5b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e61:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e63:	ff 4d f8             	decl   -0x8(%ebp)
  800e66:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e6a:	79 e9                	jns    800e55 <memset+0x14>
		*p++ = c;

	return v;
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e83:	eb 16                	jmp    800e9b <memcpy+0x2a>
		*d++ = *s++;
  800e85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e88:	8d 50 01             	lea    0x1(%eax),%edx
  800e8b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e91:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e94:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e97:	8a 12                	mov    (%edx),%dl
  800e99:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	75 dd                	jne    800e85 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ebf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ec5:	73 50                	jae    800f17 <memmove+0x6a>
  800ec7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecd:	01 d0                	add    %edx,%eax
  800ecf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ed2:	76 43                	jbe    800f17 <memmove+0x6a>
		s += n;
  800ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800eda:	8b 45 10             	mov    0x10(%ebp),%eax
  800edd:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee0:	eb 10                	jmp    800ef2 <memmove+0x45>
			*--d = *--s;
  800ee2:	ff 4d f8             	decl   -0x8(%ebp)
  800ee5:	ff 4d fc             	decl   -0x4(%ebp)
  800ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eeb:	8a 10                	mov    (%eax),%dl
  800eed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef8:	89 55 10             	mov    %edx,0x10(%ebp)
  800efb:	85 c0                	test   %eax,%eax
  800efd:	75 e3                	jne    800ee2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eff:	eb 23                	jmp    800f24 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f04:	8d 50 01             	lea    0x1(%eax),%edx
  800f07:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f10:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f13:	8a 12                	mov    (%edx),%dl
  800f15:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f20:	85 c0                	test   %eax,%eax
  800f22:	75 dd                	jne    800f01 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f27:	c9                   	leave  
  800f28:	c3                   	ret    

00800f29 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f3b:	eb 2a                	jmp    800f67 <memcmp+0x3e>
		if (*s1 != *s2)
  800f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f40:	8a 10                	mov    (%eax),%dl
  800f42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	38 c2                	cmp    %al,%dl
  800f49:	74 16                	je     800f61 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 d0             	movzbl %al,%edx
  800f53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f b6 c0             	movzbl %al,%eax
  800f5b:	29 c2                	sub    %eax,%edx
  800f5d:	89 d0                	mov    %edx,%eax
  800f5f:	eb 18                	jmp    800f79 <memcmp+0x50>
		s1++, s2++;
  800f61:	ff 45 fc             	incl   -0x4(%ebp)
  800f64:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f67:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f70:	85 c0                	test   %eax,%eax
  800f72:	75 c9                	jne    800f3d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f79:	c9                   	leave  
  800f7a:	c3                   	ret    

00800f7b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f81:	8b 55 08             	mov    0x8(%ebp),%edx
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	01 d0                	add    %edx,%eax
  800f89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f8c:	eb 15                	jmp    800fa3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	0f b6 d0             	movzbl %al,%edx
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	0f b6 c0             	movzbl %al,%eax
  800f9c:	39 c2                	cmp    %eax,%edx
  800f9e:	74 0d                	je     800fad <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fa0:	ff 45 08             	incl   0x8(%ebp)
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fa9:	72 e3                	jb     800f8e <memfind+0x13>
  800fab:	eb 01                	jmp    800fae <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fad:	90                   	nop
	return (void *) s;
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc7:	eb 03                	jmp    800fcc <strtol+0x19>
		s++;
  800fc9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	3c 20                	cmp    $0x20,%al
  800fd3:	74 f4                	je     800fc9 <strtol+0x16>
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 09                	cmp    $0x9,%al
  800fdc:	74 eb                	je     800fc9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 2b                	cmp    $0x2b,%al
  800fe5:	75 05                	jne    800fec <strtol+0x39>
		s++;
  800fe7:	ff 45 08             	incl   0x8(%ebp)
  800fea:	eb 13                	jmp    800fff <strtol+0x4c>
	else if (*s == '-')
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 2d                	cmp    $0x2d,%al
  800ff3:	75 0a                	jne    800fff <strtol+0x4c>
		s++, neg = 1;
  800ff5:	ff 45 08             	incl   0x8(%ebp)
  800ff8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801003:	74 06                	je     80100b <strtol+0x58>
  801005:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801009:	75 20                	jne    80102b <strtol+0x78>
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	3c 30                	cmp    $0x30,%al
  801012:	75 17                	jne    80102b <strtol+0x78>
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	40                   	inc    %eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	3c 78                	cmp    $0x78,%al
  80101c:	75 0d                	jne    80102b <strtol+0x78>
		s += 2, base = 16;
  80101e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801022:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801029:	eb 28                	jmp    801053 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80102b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102f:	75 15                	jne    801046 <strtol+0x93>
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	3c 30                	cmp    $0x30,%al
  801038:	75 0c                	jne    801046 <strtol+0x93>
		s++, base = 8;
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801044:	eb 0d                	jmp    801053 <strtol+0xa0>
	else if (base == 0)
  801046:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104a:	75 07                	jne    801053 <strtol+0xa0>
		base = 10;
  80104c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	3c 2f                	cmp    $0x2f,%al
  80105a:	7e 19                	jle    801075 <strtol+0xc2>
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 39                	cmp    $0x39,%al
  801063:	7f 10                	jg     801075 <strtol+0xc2>
			dig = *s - '0';
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f be c0             	movsbl %al,%eax
  80106d:	83 e8 30             	sub    $0x30,%eax
  801070:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801073:	eb 42                	jmp    8010b7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	3c 60                	cmp    $0x60,%al
  80107c:	7e 19                	jle    801097 <strtol+0xe4>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 7a                	cmp    $0x7a,%al
  801085:	7f 10                	jg     801097 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	0f be c0             	movsbl %al,%eax
  80108f:	83 e8 57             	sub    $0x57,%eax
  801092:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801095:	eb 20                	jmp    8010b7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	3c 40                	cmp    $0x40,%al
  80109e:	7e 39                	jle    8010d9 <strtol+0x126>
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 5a                	cmp    $0x5a,%al
  8010a7:	7f 30                	jg     8010d9 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	0f be c0             	movsbl %al,%eax
  8010b1:	83 e8 37             	sub    $0x37,%eax
  8010b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ba:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010bd:	7d 19                	jge    8010d8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010bf:	ff 45 08             	incl   0x8(%ebp)
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010c9:	89 c2                	mov    %eax,%edx
  8010cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ce:	01 d0                	add    %edx,%eax
  8010d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010d3:	e9 7b ff ff ff       	jmp    801053 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010d8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010dd:	74 08                	je     8010e7 <strtol+0x134>
		*endptr = (char *) s;
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010eb:	74 07                	je     8010f4 <strtol+0x141>
  8010ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f0:	f7 d8                	neg    %eax
  8010f2:	eb 03                	jmp    8010f7 <strtol+0x144>
  8010f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <ltostr>:

void
ltostr(long value, char *str)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801106:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80110d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801111:	79 13                	jns    801126 <ltostr+0x2d>
	{
		neg = 1;
  801113:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801120:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801123:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80112e:	99                   	cltd   
  80112f:	f7 f9                	idiv   %ecx
  801131:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801134:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801137:	8d 50 01             	lea    0x1(%eax),%edx
  80113a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80113d:	89 c2                	mov    %eax,%edx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	01 d0                	add    %edx,%eax
  801144:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801147:	83 c2 30             	add    $0x30,%edx
  80114a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80114c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80114f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801154:	f7 e9                	imul   %ecx
  801156:	c1 fa 02             	sar    $0x2,%edx
  801159:	89 c8                	mov    %ecx,%eax
  80115b:	c1 f8 1f             	sar    $0x1f,%eax
  80115e:	29 c2                	sub    %eax,%edx
  801160:	89 d0                	mov    %edx,%eax
  801162:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801165:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801168:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80116d:	f7 e9                	imul   %ecx
  80116f:	c1 fa 02             	sar    $0x2,%edx
  801172:	89 c8                	mov    %ecx,%eax
  801174:	c1 f8 1f             	sar    $0x1f,%eax
  801177:	29 c2                	sub    %eax,%edx
  801179:	89 d0                	mov    %edx,%eax
  80117b:	c1 e0 02             	shl    $0x2,%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	01 c0                	add    %eax,%eax
  801182:	29 c1                	sub    %eax,%ecx
  801184:	89 ca                	mov    %ecx,%edx
  801186:	85 d2                	test   %edx,%edx
  801188:	75 9c                	jne    801126 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80118a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801191:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801194:	48                   	dec    %eax
  801195:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801198:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119c:	74 3d                	je     8011db <ltostr+0xe2>
		start = 1 ;
  80119e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011a5:	eb 34                	jmp    8011db <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 c2                	add    %eax,%edx
  8011bc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 c8                	add    %ecx,%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	01 c2                	add    %eax,%edx
  8011d0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011d3:	88 02                	mov    %al,(%edx)
		start++ ;
  8011d5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011e1:	7c c4                	jl     8011a7 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e9:	01 d0                	add    %edx,%eax
  8011eb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ee:	90                   	nop
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011f7:	ff 75 08             	pushl  0x8(%ebp)
  8011fa:	e8 54 fa ff ff       	call   800c53 <strlen>
  8011ff:	83 c4 04             	add    $0x4,%esp
  801202:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801205:	ff 75 0c             	pushl  0xc(%ebp)
  801208:	e8 46 fa ff ff       	call   800c53 <strlen>
  80120d:	83 c4 04             	add    $0x4,%esp
  801210:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801213:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80121a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801221:	eb 17                	jmp    80123a <strcconcat+0x49>
		final[s] = str1[s] ;
  801223:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801226:	8b 45 10             	mov    0x10(%ebp),%eax
  801229:	01 c2                	add    %eax,%edx
  80122b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	01 c8                	add    %ecx,%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801237:	ff 45 fc             	incl   -0x4(%ebp)
  80123a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801240:	7c e1                	jl     801223 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801242:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801249:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801250:	eb 1f                	jmp    801271 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801252:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801255:	8d 50 01             	lea    0x1(%eax),%edx
  801258:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80125b:	89 c2                	mov    %eax,%edx
  80125d:	8b 45 10             	mov    0x10(%ebp),%eax
  801260:	01 c2                	add    %eax,%edx
  801262:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	01 c8                	add    %ecx,%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80126e:	ff 45 f8             	incl   -0x8(%ebp)
  801271:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801274:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801277:	7c d9                	jl     801252 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801279:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	c6 00 00             	movb   $0x0,(%eax)
}
  801284:	90                   	nop
  801285:	c9                   	leave  
  801286:	c3                   	ret    

00801287 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80128a:	8b 45 14             	mov    0x14(%ebp),%eax
  80128d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129f:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a2:	01 d0                	add    %edx,%eax
  8012a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012aa:	eb 0c                	jmp    8012b8 <strsplit+0x31>
			*string++ = 0;
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8d 50 01             	lea    0x1(%eax),%edx
  8012b2:	89 55 08             	mov    %edx,0x8(%ebp)
  8012b5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	84 c0                	test   %al,%al
  8012bf:	74 18                	je     8012d9 <strsplit+0x52>
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	0f be c0             	movsbl %al,%eax
  8012c9:	50                   	push   %eax
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	e8 13 fb ff ff       	call   800de5 <strchr>
  8012d2:	83 c4 08             	add    $0x8,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	75 d3                	jne    8012ac <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	84 c0                	test   %al,%al
  8012e0:	74 5a                	je     80133c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e5:	8b 00                	mov    (%eax),%eax
  8012e7:	83 f8 0f             	cmp    $0xf,%eax
  8012ea:	75 07                	jne    8012f3 <strsplit+0x6c>
		{
			return 0;
  8012ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f1:	eb 66                	jmp    801359 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f6:	8b 00                	mov    (%eax),%eax
  8012f8:	8d 48 01             	lea    0x1(%eax),%ecx
  8012fb:	8b 55 14             	mov    0x14(%ebp),%edx
  8012fe:	89 0a                	mov    %ecx,(%edx)
  801300:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801307:	8b 45 10             	mov    0x10(%ebp),%eax
  80130a:	01 c2                	add    %eax,%edx
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801311:	eb 03                	jmp    801316 <strsplit+0x8f>
			string++;
  801313:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	84 c0                	test   %al,%al
  80131d:	74 8b                	je     8012aa <strsplit+0x23>
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	0f be c0             	movsbl %al,%eax
  801327:	50                   	push   %eax
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	e8 b5 fa ff ff       	call   800de5 <strchr>
  801330:	83 c4 08             	add    $0x8,%esp
  801333:	85 c0                	test   %eax,%eax
  801335:	74 dc                	je     801313 <strsplit+0x8c>
			string++;
	}
  801337:	e9 6e ff ff ff       	jmp    8012aa <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80133c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80133d:	8b 45 14             	mov    0x14(%ebp),%eax
  801340:	8b 00                	mov    (%eax),%eax
  801342:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801349:	8b 45 10             	mov    0x10(%ebp),%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801354:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801361:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801368:	8b 55 08             	mov    0x8(%ebp),%edx
  80136b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	48                   	dec    %eax
  801371:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801374:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801377:	ba 00 00 00 00       	mov    $0x0,%edx
  80137c:	f7 75 ac             	divl   -0x54(%ebp)
  80137f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801382:	29 d0                	sub    %edx,%eax
  801384:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  80138e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801395:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  80139c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8013a3:	eb 3f                	jmp    8013e4 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8013a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013a8:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8013af:	83 ec 04             	sub    $0x4,%esp
  8013b2:	50                   	push   %eax
  8013b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8013b6:	68 30 29 80 00       	push   $0x802930
  8013bb:	e8 11 f2 ff ff       	call   8005d1 <cprintf>
  8013c0:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  8013c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c6:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8013cd:	83 ec 04             	sub    $0x4,%esp
  8013d0:	50                   	push   %eax
  8013d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8013d4:	68 45 29 80 00       	push   $0x802945
  8013d9:	e8 f3 f1 ff ff       	call   8005d1 <cprintf>
  8013de:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  8013e1:	ff 45 e8             	incl   -0x18(%ebp)
  8013e4:	a1 28 30 80 00       	mov    0x803028,%eax
  8013e9:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8013ec:	7c b7                	jl     8013a5 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8013ee:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  8013f5:	e9 42 01 00 00       	jmp    80153c <malloc+0x1e1>
		int flag0=1;
  8013fa:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801401:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801404:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801407:	eb 6b                	jmp    801474 <malloc+0x119>
			for(int k=0;k<count;k++){
  801409:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801410:	eb 42                	jmp    801454 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801412:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801415:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80141c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80141f:	39 c2                	cmp    %eax,%edx
  801421:	77 2e                	ja     801451 <malloc+0xf6>
  801423:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801426:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80142d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801430:	39 c2                	cmp    %eax,%edx
  801432:	76 1d                	jbe    801451 <malloc+0xf6>
					ni=arr_add[k].end-i;
  801434:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801437:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80143e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801441:	29 c2                	sub    %eax,%edx
  801443:	89 d0                	mov    %edx,%eax
  801445:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801448:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  80144f:	eb 0d                	jmp    80145e <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801451:	ff 45 d8             	incl   -0x28(%ebp)
  801454:	a1 28 30 80 00       	mov    0x803028,%eax
  801459:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80145c:	7c b4                	jl     801412 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  80145e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801462:	74 09                	je     80146d <malloc+0x112>
				flag0=0;
  801464:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  80146b:	eb 16                	jmp    801483 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  80146d:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801474:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	01 c2                	add    %eax,%edx
  80147c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80147f:	39 c2                	cmp    %eax,%edx
  801481:	77 86                	ja     801409 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801483:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801487:	0f 84 a2 00 00 00    	je     80152f <malloc+0x1d4>

			int f=1;
  80148d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801494:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801497:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80149a:	89 c8                	mov    %ecx,%eax
  80149c:	01 c0                	add    %eax,%eax
  80149e:	01 c8                	add    %ecx,%eax
  8014a0:	c1 e0 02             	shl    $0x2,%eax
  8014a3:	05 20 31 80 00       	add    $0x803120,%eax
  8014a8:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  8014aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8014b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b6:	89 d0                	mov    %edx,%eax
  8014b8:	01 c0                	add    %eax,%eax
  8014ba:	01 d0                	add    %edx,%eax
  8014bc:	c1 e0 02             	shl    $0x2,%eax
  8014bf:	05 24 31 80 00       	add    $0x803124,%eax
  8014c4:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  8014c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c9:	89 d0                	mov    %edx,%eax
  8014cb:	01 c0                	add    %eax,%eax
  8014cd:	01 d0                	add    %edx,%eax
  8014cf:	c1 e0 02             	shl    $0x2,%eax
  8014d2:	05 28 31 80 00       	add    $0x803128,%eax
  8014d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  8014dd:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  8014e0:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8014e7:	eb 36                	jmp    80151f <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  8014e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	01 c2                	add    %eax,%edx
  8014f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014f4:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8014fb:	39 c2                	cmp    %eax,%edx
  8014fd:	73 1d                	jae    80151c <malloc+0x1c1>
					ni=arr_add[l].end-i;
  8014ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801502:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80150c:	29 c2                	sub    %eax,%edx
  80150e:	89 d0                	mov    %edx,%eax
  801510:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801513:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  80151a:	eb 0d                	jmp    801529 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  80151c:	ff 45 d0             	incl   -0x30(%ebp)
  80151f:	a1 28 30 80 00       	mov    0x803028,%eax
  801524:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801527:	7c c0                	jl     8014e9 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801529:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80152d:	75 1d                	jne    80154c <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  80152f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801536:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801539:	01 45 e4             	add    %eax,-0x1c(%ebp)
  80153c:	a1 04 30 80 00       	mov    0x803004,%eax
  801541:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801544:	0f 8c b0 fe ff ff    	jl     8013fa <malloc+0x9f>
  80154a:	eb 01                	jmp    80154d <malloc+0x1f2>

				}
			}

			if(f){
				break;
  80154c:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  80154d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801551:	75 7a                	jne    8015cd <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801553:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	01 d0                	add    %edx,%eax
  80155e:	48                   	dec    %eax
  80155f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801564:	7c 0a                	jl     801570 <malloc+0x215>
			return NULL;
  801566:	b8 00 00 00 00       	mov    $0x0,%eax
  80156b:	e9 a4 02 00 00       	jmp    801814 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801570:	a1 04 30 80 00       	mov    0x803004,%eax
  801575:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801578:	a1 28 30 80 00       	mov    0x803028,%eax
  80157d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801580:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  801587:	83 ec 08             	sub    $0x8,%esp
  80158a:	ff 75 08             	pushl  0x8(%ebp)
  80158d:	ff 75 a4             	pushl  -0x5c(%ebp)
  801590:	e8 04 06 00 00       	call   801b99 <sys_allocateMem>
  801595:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801598:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	01 d0                	add    %edx,%eax
  8015a3:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  8015a8:	a1 28 30 80 00       	mov    0x803028,%eax
  8015ad:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015b3:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  8015ba:	a1 28 30 80 00       	mov    0x803028,%eax
  8015bf:	40                   	inc    %eax
  8015c0:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  8015c5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8015c8:	e9 47 02 00 00       	jmp    801814 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  8015cd:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8015d4:	e9 ac 00 00 00       	jmp    801685 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8015d9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8015dc:	89 d0                	mov    %edx,%eax
  8015de:	01 c0                	add    %eax,%eax
  8015e0:	01 d0                	add    %edx,%eax
  8015e2:	c1 e0 02             	shl    $0x2,%eax
  8015e5:	05 24 31 80 00       	add    $0x803124,%eax
  8015ea:	8b 00                	mov    (%eax),%eax
  8015ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8015ef:	eb 7e                	jmp    80166f <malloc+0x314>
			int flag=0;
  8015f1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  8015f8:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8015ff:	eb 57                	jmp    801658 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801601:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801604:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80160b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80160e:	39 c2                	cmp    %eax,%edx
  801610:	77 1a                	ja     80162c <malloc+0x2d1>
  801612:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801615:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80161c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80161f:	39 c2                	cmp    %eax,%edx
  801621:	76 09                	jbe    80162c <malloc+0x2d1>
								flag=1;
  801623:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  80162a:	eb 36                	jmp    801662 <malloc+0x307>
			arr[i].space++;
  80162c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80162f:	89 d0                	mov    %edx,%eax
  801631:	01 c0                	add    %eax,%eax
  801633:	01 d0                	add    %edx,%eax
  801635:	c1 e0 02             	shl    $0x2,%eax
  801638:	05 28 31 80 00       	add    $0x803128,%eax
  80163d:	8b 00                	mov    (%eax),%eax
  80163f:	8d 48 01             	lea    0x1(%eax),%ecx
  801642:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801645:	89 d0                	mov    %edx,%eax
  801647:	01 c0                	add    %eax,%eax
  801649:	01 d0                	add    %edx,%eax
  80164b:	c1 e0 02             	shl    $0x2,%eax
  80164e:	05 28 31 80 00       	add    $0x803128,%eax
  801653:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801655:	ff 45 c0             	incl   -0x40(%ebp)
  801658:	a1 28 30 80 00       	mov    0x803028,%eax
  80165d:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801660:	7c 9f                	jl     801601 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801662:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801666:	75 19                	jne    801681 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801668:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  80166f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801672:	a1 04 30 80 00       	mov    0x803004,%eax
  801677:	39 c2                	cmp    %eax,%edx
  801679:	0f 82 72 ff ff ff    	jb     8015f1 <malloc+0x296>
  80167f:	eb 01                	jmp    801682 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801681:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801682:	ff 45 cc             	incl   -0x34(%ebp)
  801685:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801688:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80168b:	0f 8c 48 ff ff ff    	jl     8015d9 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801691:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801698:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  80169f:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  8016a6:	eb 37                	jmp    8016df <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  8016a8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8016ab:	89 d0                	mov    %edx,%eax
  8016ad:	01 c0                	add    %eax,%eax
  8016af:	01 d0                	add    %edx,%eax
  8016b1:	c1 e0 02             	shl    $0x2,%eax
  8016b4:	05 28 31 80 00       	add    $0x803128,%eax
  8016b9:	8b 00                	mov    (%eax),%eax
  8016bb:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8016be:	7d 1c                	jge    8016dc <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  8016c0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8016c3:	89 d0                	mov    %edx,%eax
  8016c5:	01 c0                	add    %eax,%eax
  8016c7:	01 d0                	add    %edx,%eax
  8016c9:	c1 e0 02             	shl    $0x2,%eax
  8016cc:	05 28 31 80 00       	add    $0x803128,%eax
  8016d1:	8b 00                	mov    (%eax),%eax
  8016d3:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  8016d6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8016d9:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  8016dc:	ff 45 b4             	incl   -0x4c(%ebp)
  8016df:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8016e2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016e5:	7c c1                	jl     8016a8 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  8016e7:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8016ed:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8016f0:	89 c8                	mov    %ecx,%eax
  8016f2:	01 c0                	add    %eax,%eax
  8016f4:	01 c8                	add    %ecx,%eax
  8016f6:	c1 e0 02             	shl    $0x2,%eax
  8016f9:	05 20 31 80 00       	add    $0x803120,%eax
  8016fe:	8b 00                	mov    (%eax),%eax
  801700:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801707:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80170d:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801710:	89 c8                	mov    %ecx,%eax
  801712:	01 c0                	add    %eax,%eax
  801714:	01 c8                	add    %ecx,%eax
  801716:	c1 e0 02             	shl    $0x2,%eax
  801719:	05 24 31 80 00       	add    $0x803124,%eax
  80171e:	8b 00                	mov    (%eax),%eax
  801720:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  801727:	a1 28 30 80 00       	mov    0x803028,%eax
  80172c:	40                   	inc    %eax
  80172d:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  801732:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801735:	89 d0                	mov    %edx,%eax
  801737:	01 c0                	add    %eax,%eax
  801739:	01 d0                	add    %edx,%eax
  80173b:	c1 e0 02             	shl    $0x2,%eax
  80173e:	05 20 31 80 00       	add    $0x803120,%eax
  801743:	8b 00                	mov    (%eax),%eax
  801745:	83 ec 08             	sub    $0x8,%esp
  801748:	ff 75 08             	pushl  0x8(%ebp)
  80174b:	50                   	push   %eax
  80174c:	e8 48 04 00 00       	call   801b99 <sys_allocateMem>
  801751:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801754:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  80175b:	eb 78                	jmp    8017d5 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  80175d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801760:	89 d0                	mov    %edx,%eax
  801762:	01 c0                	add    %eax,%eax
  801764:	01 d0                	add    %edx,%eax
  801766:	c1 e0 02             	shl    $0x2,%eax
  801769:	05 20 31 80 00       	add    $0x803120,%eax
  80176e:	8b 00                	mov    (%eax),%eax
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	50                   	push   %eax
  801774:	ff 75 b0             	pushl  -0x50(%ebp)
  801777:	68 30 29 80 00       	push   $0x802930
  80177c:	e8 50 ee ff ff       	call   8005d1 <cprintf>
  801781:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801784:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801787:	89 d0                	mov    %edx,%eax
  801789:	01 c0                	add    %eax,%eax
  80178b:	01 d0                	add    %edx,%eax
  80178d:	c1 e0 02             	shl    $0x2,%eax
  801790:	05 24 31 80 00       	add    $0x803124,%eax
  801795:	8b 00                	mov    (%eax),%eax
  801797:	83 ec 04             	sub    $0x4,%esp
  80179a:	50                   	push   %eax
  80179b:	ff 75 b0             	pushl  -0x50(%ebp)
  80179e:	68 45 29 80 00       	push   $0x802945
  8017a3:	e8 29 ee ff ff       	call   8005d1 <cprintf>
  8017a8:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  8017ab:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8017ae:	89 d0                	mov    %edx,%eax
  8017b0:	01 c0                	add    %eax,%eax
  8017b2:	01 d0                	add    %edx,%eax
  8017b4:	c1 e0 02             	shl    $0x2,%eax
  8017b7:	05 28 31 80 00       	add    $0x803128,%eax
  8017bc:	8b 00                	mov    (%eax),%eax
  8017be:	83 ec 04             	sub    $0x4,%esp
  8017c1:	50                   	push   %eax
  8017c2:	ff 75 b0             	pushl  -0x50(%ebp)
  8017c5:	68 58 29 80 00       	push   $0x802958
  8017ca:	e8 02 ee ff ff       	call   8005d1 <cprintf>
  8017cf:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  8017d2:	ff 45 b0             	incl   -0x50(%ebp)
  8017d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8017d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017db:	7c 80                	jl     80175d <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  8017dd:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8017e0:	89 d0                	mov    %edx,%eax
  8017e2:	01 c0                	add    %eax,%eax
  8017e4:	01 d0                	add    %edx,%eax
  8017e6:	c1 e0 02             	shl    $0x2,%eax
  8017e9:	05 20 31 80 00       	add    $0x803120,%eax
  8017ee:	8b 00                	mov    (%eax),%eax
  8017f0:	83 ec 08             	sub    $0x8,%esp
  8017f3:	50                   	push   %eax
  8017f4:	68 6c 29 80 00       	push   $0x80296c
  8017f9:	e8 d3 ed ff ff       	call   8005d1 <cprintf>
  8017fe:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801801:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801804:	89 d0                	mov    %edx,%eax
  801806:	01 c0                	add    %eax,%eax
  801808:	01 d0                	add    %edx,%eax
  80180a:	c1 e0 02             	shl    $0x2,%eax
  80180d:	05 20 31 80 00       	add    $0x803120,%eax
  801812:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801822:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801829:	eb 4b                	jmp    801876 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  80182b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80182e:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801835:	89 c2                	mov    %eax,%edx
  801837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80183a:	39 c2                	cmp    %eax,%edx
  80183c:	7f 35                	jg     801873 <free+0x5d>
  80183e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801841:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801848:	89 c2                	mov    %eax,%edx
  80184a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80184d:	39 c2                	cmp    %eax,%edx
  80184f:	7e 22                	jle    801873 <free+0x5d>
				start=arr_add[i].start;
  801851:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801854:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80185b:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  80185e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801861:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801868:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  80186b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801871:	eb 0d                	jmp    801880 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801873:	ff 45 ec             	incl   -0x14(%ebp)
  801876:	a1 28 30 80 00       	mov    0x803028,%eax
  80187b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80187e:	7c ab                	jl     80182b <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801883:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80188a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188d:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801894:	29 c2                	sub    %eax,%edx
  801896:	89 d0                	mov    %edx,%eax
  801898:	83 ec 08             	sub    $0x8,%esp
  80189b:	50                   	push   %eax
  80189c:	ff 75 f4             	pushl  -0xc(%ebp)
  80189f:	e8 d9 02 00 00       	call   801b7d <sys_freeMem>
  8018a4:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  8018a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018ad:	eb 2d                	jmp    8018dc <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  8018af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b2:	40                   	inc    %eax
  8018b3:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8018ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018bd:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  8018c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c7:	40                   	inc    %eax
  8018c8:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8018cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d2:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  8018d9:	ff 45 e8             	incl   -0x18(%ebp)
  8018dc:	a1 28 30 80 00       	mov    0x803028,%eax
  8018e1:	48                   	dec    %eax
  8018e2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018e5:	7f c8                	jg     8018af <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  8018e7:	a1 28 30 80 00       	mov    0x803028,%eax
  8018ec:	48                   	dec    %eax
  8018ed:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  8018f2:	90                   	nop
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	83 ec 18             	sub    $0x18,%esp
  8018fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fe:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801901:	83 ec 04             	sub    $0x4,%esp
  801904:	68 88 29 80 00       	push   $0x802988
  801909:	68 18 01 00 00       	push   $0x118
  80190e:	68 ab 29 80 00       	push   $0x8029ab
  801913:	e8 17 ea ff ff       	call   80032f <_panic>

00801918 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80191e:	83 ec 04             	sub    $0x4,%esp
  801921:	68 88 29 80 00       	push   $0x802988
  801926:	68 1e 01 00 00       	push   $0x11e
  80192b:	68 ab 29 80 00       	push   $0x8029ab
  801930:	e8 fa e9 ff ff       	call   80032f <_panic>

00801935 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80193b:	83 ec 04             	sub    $0x4,%esp
  80193e:	68 88 29 80 00       	push   $0x802988
  801943:	68 24 01 00 00       	push   $0x124
  801948:	68 ab 29 80 00       	push   $0x8029ab
  80194d:	e8 dd e9 ff ff       	call   80032f <_panic>

00801952 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801958:	83 ec 04             	sub    $0x4,%esp
  80195b:	68 88 29 80 00       	push   $0x802988
  801960:	68 29 01 00 00       	push   $0x129
  801965:	68 ab 29 80 00       	push   $0x8029ab
  80196a:	e8 c0 e9 ff ff       	call   80032f <_panic>

0080196f <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801975:	83 ec 04             	sub    $0x4,%esp
  801978:	68 88 29 80 00       	push   $0x802988
  80197d:	68 2f 01 00 00       	push   $0x12f
  801982:	68 ab 29 80 00       	push   $0x8029ab
  801987:	e8 a3 e9 ff ff       	call   80032f <_panic>

0080198c <shrink>:
}
void shrink(uint32 newSize)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801992:	83 ec 04             	sub    $0x4,%esp
  801995:	68 88 29 80 00       	push   $0x802988
  80199a:	68 33 01 00 00       	push   $0x133
  80199f:	68 ab 29 80 00       	push   $0x8029ab
  8019a4:	e8 86 e9 ff ff       	call   80032f <_panic>

008019a9 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019af:	83 ec 04             	sub    $0x4,%esp
  8019b2:	68 88 29 80 00       	push   $0x802988
  8019b7:	68 38 01 00 00       	push   $0x138
  8019bc:	68 ab 29 80 00       	push   $0x8029ab
  8019c1:	e8 69 e9 ff ff       	call   80032f <_panic>

008019c6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	57                   	push   %edi
  8019ca:	56                   	push   %esi
  8019cb:	53                   	push   %ebx
  8019cc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019db:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019de:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019e1:	cd 30                	int    $0x30
  8019e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019e9:	83 c4 10             	add    $0x10,%esp
  8019ec:	5b                   	pop    %ebx
  8019ed:	5e                   	pop    %esi
  8019ee:	5f                   	pop    %edi
  8019ef:	5d                   	pop    %ebp
  8019f0:	c3                   	ret    

008019f1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 04             	sub    $0x4,%esp
  8019f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019fd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	52                   	push   %edx
  801a09:	ff 75 0c             	pushl  0xc(%ebp)
  801a0c:	50                   	push   %eax
  801a0d:	6a 00                	push   $0x0
  801a0f:	e8 b2 ff ff ff       	call   8019c6 <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	90                   	nop
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <sys_cgetc>:

int
sys_cgetc(void)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 01                	push   $0x1
  801a29:	e8 98 ff ff ff       	call   8019c6 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	50                   	push   %eax
  801a42:	6a 05                	push   $0x5
  801a44:	e8 7d ff ff ff       	call   8019c6 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 02                	push   $0x2
  801a5d:	e8 64 ff ff ff       	call   8019c6 <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 03                	push   $0x3
  801a76:	e8 4b ff ff ff       	call   8019c6 <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 04                	push   $0x4
  801a8f:	e8 32 ff ff ff       	call   8019c6 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_env_exit>:


void sys_env_exit(void)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 06                	push   $0x6
  801aa8:	e8 19 ff ff ff       	call   8019c6 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	90                   	nop
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	52                   	push   %edx
  801ac3:	50                   	push   %eax
  801ac4:	6a 07                	push   $0x7
  801ac6:	e8 fb fe ff ff       	call   8019c6 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	56                   	push   %esi
  801ad4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ad5:	8b 75 18             	mov    0x18(%ebp),%esi
  801ad8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801adb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	56                   	push   %esi
  801ae5:	53                   	push   %ebx
  801ae6:	51                   	push   %ecx
  801ae7:	52                   	push   %edx
  801ae8:	50                   	push   %eax
  801ae9:	6a 08                	push   $0x8
  801aeb:	e8 d6 fe ff ff       	call   8019c6 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af6:	5b                   	pop    %ebx
  801af7:	5e                   	pop    %esi
  801af8:	5d                   	pop    %ebp
  801af9:	c3                   	ret    

00801afa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	52                   	push   %edx
  801b0a:	50                   	push   %eax
  801b0b:	6a 09                	push   $0x9
  801b0d:	e8 b4 fe ff ff       	call   8019c6 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	ff 75 0c             	pushl  0xc(%ebp)
  801b23:	ff 75 08             	pushl  0x8(%ebp)
  801b26:	6a 0a                	push   $0xa
  801b28:	e8 99 fe ff ff       	call   8019c6 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 0b                	push   $0xb
  801b41:	e8 80 fe ff ff       	call   8019c6 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 0c                	push   $0xc
  801b5a:	e8 67 fe ff ff       	call   8019c6 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 0d                	push   $0xd
  801b73:	e8 4e fe ff ff       	call   8019c6 <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	ff 75 0c             	pushl  0xc(%ebp)
  801b89:	ff 75 08             	pushl  0x8(%ebp)
  801b8c:	6a 11                	push   $0x11
  801b8e:	e8 33 fe ff ff       	call   8019c6 <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
	return;
  801b96:	90                   	nop
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	ff 75 0c             	pushl  0xc(%ebp)
  801ba5:	ff 75 08             	pushl  0x8(%ebp)
  801ba8:	6a 12                	push   $0x12
  801baa:	e8 17 fe ff ff       	call   8019c6 <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb2:	90                   	nop
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 0e                	push   $0xe
  801bc4:	e8 fd fd ff ff       	call   8019c6 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	ff 75 08             	pushl  0x8(%ebp)
  801bdc:	6a 0f                	push   $0xf
  801bde:	e8 e3 fd ff ff       	call   8019c6 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 10                	push   $0x10
  801bf7:	e8 ca fd ff ff       	call   8019c6 <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	90                   	nop
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 14                	push   $0x14
  801c11:	e8 b0 fd ff ff       	call   8019c6 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	90                   	nop
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 15                	push   $0x15
  801c2b:	e8 96 fd ff ff       	call   8019c6 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	90                   	nop
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 04             	sub    $0x4,%esp
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c42:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	50                   	push   %eax
  801c4f:	6a 16                	push   $0x16
  801c51:	e8 70 fd ff ff       	call   8019c6 <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
}
  801c59:	90                   	nop
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 17                	push   $0x17
  801c6b:	e8 56 fd ff ff       	call   8019c6 <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	90                   	nop
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	ff 75 0c             	pushl  0xc(%ebp)
  801c85:	50                   	push   %eax
  801c86:	6a 18                	push   $0x18
  801c88:	e8 39 fd ff ff       	call   8019c6 <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	52                   	push   %edx
  801ca2:	50                   	push   %eax
  801ca3:	6a 1b                	push   $0x1b
  801ca5:	e8 1c fd ff ff       	call   8019c6 <syscall>
  801caa:	83 c4 18             	add    $0x18,%esp
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	52                   	push   %edx
  801cbf:	50                   	push   %eax
  801cc0:	6a 19                	push   $0x19
  801cc2:	e8 ff fc ff ff       	call   8019c6 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	90                   	nop
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	52                   	push   %edx
  801cdd:	50                   	push   %eax
  801cde:	6a 1a                	push   $0x1a
  801ce0:	e8 e1 fc ff ff       	call   8019c6 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	90                   	nop
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 04             	sub    $0x4,%esp
  801cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cf7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cfa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	6a 00                	push   $0x0
  801d03:	51                   	push   %ecx
  801d04:	52                   	push   %edx
  801d05:	ff 75 0c             	pushl  0xc(%ebp)
  801d08:	50                   	push   %eax
  801d09:	6a 1c                	push   $0x1c
  801d0b:	e8 b6 fc ff ff       	call   8019c6 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	52                   	push   %edx
  801d25:	50                   	push   %eax
  801d26:	6a 1d                	push   $0x1d
  801d28:	e8 99 fc ff ff       	call   8019c6 <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	51                   	push   %ecx
  801d43:	52                   	push   %edx
  801d44:	50                   	push   %eax
  801d45:	6a 1e                	push   $0x1e
  801d47:	e8 7a fc ff ff       	call   8019c6 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	52                   	push   %edx
  801d61:	50                   	push   %eax
  801d62:	6a 1f                	push   $0x1f
  801d64:	e8 5d fc ff ff       	call   8019c6 <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 20                	push   $0x20
  801d7d:	e8 44 fc ff ff       	call   8019c6 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	6a 00                	push   $0x0
  801d8f:	ff 75 14             	pushl  0x14(%ebp)
  801d92:	ff 75 10             	pushl  0x10(%ebp)
  801d95:	ff 75 0c             	pushl  0xc(%ebp)
  801d98:	50                   	push   %eax
  801d99:	6a 21                	push   $0x21
  801d9b:	e8 26 fc ff ff       	call   8019c6 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	50                   	push   %eax
  801db4:	6a 22                	push   $0x22
  801db6:	e8 0b fc ff ff       	call   8019c6 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
}
  801dbe:	90                   	nop
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	50                   	push   %eax
  801dd0:	6a 23                	push   $0x23
  801dd2:	e8 ef fb ff ff       	call   8019c6 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
}
  801dda:	90                   	nop
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801de3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801de6:	8d 50 04             	lea    0x4(%eax),%edx
  801de9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	52                   	push   %edx
  801df3:	50                   	push   %eax
  801df4:	6a 24                	push   $0x24
  801df6:	e8 cb fb ff ff       	call   8019c6 <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
	return result;
  801dfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e07:	89 01                	mov    %eax,(%ecx)
  801e09:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	c9                   	leave  
  801e10:	c2 04 00             	ret    $0x4

00801e13 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	ff 75 10             	pushl  0x10(%ebp)
  801e1d:	ff 75 0c             	pushl  0xc(%ebp)
  801e20:	ff 75 08             	pushl  0x8(%ebp)
  801e23:	6a 13                	push   $0x13
  801e25:	e8 9c fb ff ff       	call   8019c6 <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2d:	90                   	nop
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 25                	push   $0x25
  801e3f:	e8 82 fb ff ff       	call   8019c6 <syscall>
  801e44:	83 c4 18             	add    $0x18,%esp
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 04             	sub    $0x4,%esp
  801e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e52:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e55:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	50                   	push   %eax
  801e62:	6a 26                	push   $0x26
  801e64:	e8 5d fb ff ff       	call   8019c6 <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6c:	90                   	nop
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <rsttst>:
void rsttst()
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 28                	push   $0x28
  801e7e:	e8 43 fb ff ff       	call   8019c6 <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
	return ;
  801e86:	90                   	nop
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 04             	sub    $0x4,%esp
  801e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e95:	8b 55 18             	mov    0x18(%ebp),%edx
  801e98:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e9c:	52                   	push   %edx
  801e9d:	50                   	push   %eax
  801e9e:	ff 75 10             	pushl  0x10(%ebp)
  801ea1:	ff 75 0c             	pushl  0xc(%ebp)
  801ea4:	ff 75 08             	pushl  0x8(%ebp)
  801ea7:	6a 27                	push   $0x27
  801ea9:	e8 18 fb ff ff       	call   8019c6 <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb1:	90                   	nop
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <chktst>:
void chktst(uint32 n)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	ff 75 08             	pushl  0x8(%ebp)
  801ec2:	6a 29                	push   $0x29
  801ec4:	e8 fd fa ff ff       	call   8019c6 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ecc:	90                   	nop
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <inctst>:

void inctst()
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 2a                	push   $0x2a
  801ede:	e8 e3 fa ff ff       	call   8019c6 <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee6:	90                   	nop
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <gettst>:
uint32 gettst()
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 2b                	push   $0x2b
  801ef8:	e8 c9 fa ff ff       	call   8019c6 <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 2c                	push   $0x2c
  801f14:	e8 ad fa ff ff       	call   8019c6 <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
  801f1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f1f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f23:	75 07                	jne    801f2c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f25:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2a:	eb 05                	jmp    801f31 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 2c                	push   $0x2c
  801f45:	e8 7c fa ff ff       	call   8019c6 <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
  801f4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f50:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f54:	75 07                	jne    801f5d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f56:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5b:	eb 05                	jmp    801f62 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 2c                	push   $0x2c
  801f76:	e8 4b fa ff ff       	call   8019c6 <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
  801f7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f81:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f85:	75 07                	jne    801f8e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f87:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8c:	eb 05                	jmp    801f93 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 2c                	push   $0x2c
  801fa7:	e8 1a fa ff ff       	call   8019c6 <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
  801faf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fb2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fb6:	75 07                	jne    801fbf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fb8:	b8 01 00 00 00       	mov    $0x1,%eax
  801fbd:	eb 05                	jmp    801fc4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	ff 75 08             	pushl  0x8(%ebp)
  801fd4:	6a 2d                	push   $0x2d
  801fd6:	e8 eb f9 ff ff       	call   8019c6 <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801fde:	90                   	nop
}
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fe5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fe8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	6a 00                	push   $0x0
  801ff3:	53                   	push   %ebx
  801ff4:	51                   	push   %ecx
  801ff5:	52                   	push   %edx
  801ff6:	50                   	push   %eax
  801ff7:	6a 2e                	push   $0x2e
  801ff9:	e8 c8 f9 ff ff       	call   8019c6 <syscall>
  801ffe:	83 c4 18             	add    $0x18,%esp
}
  802001:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802009:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	52                   	push   %edx
  802016:	50                   	push   %eax
  802017:	6a 2f                	push   $0x2f
  802019:	e8 a8 f9 ff ff       	call   8019c6 <syscall>
  80201e:	83 c4 18             	add    $0x18,%esp
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802029:	8b 55 08             	mov    0x8(%ebp),%edx
  80202c:	89 d0                	mov    %edx,%eax
  80202e:	c1 e0 02             	shl    $0x2,%eax
  802031:	01 d0                	add    %edx,%eax
  802033:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80203a:	01 d0                	add    %edx,%eax
  80203c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802043:	01 d0                	add    %edx,%eax
  802045:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80204c:	01 d0                	add    %edx,%eax
  80204e:	c1 e0 04             	shl    $0x4,%eax
  802051:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802054:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80205b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80205e:	83 ec 0c             	sub    $0xc,%esp
  802061:	50                   	push   %eax
  802062:	e8 76 fd ff ff       	call   801ddd <sys_get_virtual_time>
  802067:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80206a:	eb 41                	jmp    8020ad <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80206c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80206f:	83 ec 0c             	sub    $0xc,%esp
  802072:	50                   	push   %eax
  802073:	e8 65 fd ff ff       	call   801ddd <sys_get_virtual_time>
  802078:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80207b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80207e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802081:	29 c2                	sub    %eax,%edx
  802083:	89 d0                	mov    %edx,%eax
  802085:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802088:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80208b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208e:	89 d1                	mov    %edx,%ecx
  802090:	29 c1                	sub    %eax,%ecx
  802092:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802095:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802098:	39 c2                	cmp    %eax,%edx
  80209a:	0f 97 c0             	seta   %al
  80209d:	0f b6 c0             	movzbl %al,%eax
  8020a0:	29 c1                	sub    %eax,%ecx
  8020a2:	89 c8                	mov    %ecx,%eax
  8020a4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8020a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8020ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020b3:	72 b7                	jb     80206c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8020b5:	90                   	nop
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
  8020bb:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8020be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8020c5:	eb 03                	jmp    8020ca <busy_wait+0x12>
  8020c7:	ff 45 fc             	incl   -0x4(%ebp)
  8020ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020d0:	72 f5                	jb     8020c7 <busy_wait+0xf>
	return i;
  8020d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    
  8020d7:	90                   	nop

008020d8 <__udivdi3>:
  8020d8:	55                   	push   %ebp
  8020d9:	57                   	push   %edi
  8020da:	56                   	push   %esi
  8020db:	53                   	push   %ebx
  8020dc:	83 ec 1c             	sub    $0x1c,%esp
  8020df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020ef:	89 ca                	mov    %ecx,%edx
  8020f1:	89 f8                	mov    %edi,%eax
  8020f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020f7:	85 f6                	test   %esi,%esi
  8020f9:	75 2d                	jne    802128 <__udivdi3+0x50>
  8020fb:	39 cf                	cmp    %ecx,%edi
  8020fd:	77 65                	ja     802164 <__udivdi3+0x8c>
  8020ff:	89 fd                	mov    %edi,%ebp
  802101:	85 ff                	test   %edi,%edi
  802103:	75 0b                	jne    802110 <__udivdi3+0x38>
  802105:	b8 01 00 00 00       	mov    $0x1,%eax
  80210a:	31 d2                	xor    %edx,%edx
  80210c:	f7 f7                	div    %edi
  80210e:	89 c5                	mov    %eax,%ebp
  802110:	31 d2                	xor    %edx,%edx
  802112:	89 c8                	mov    %ecx,%eax
  802114:	f7 f5                	div    %ebp
  802116:	89 c1                	mov    %eax,%ecx
  802118:	89 d8                	mov    %ebx,%eax
  80211a:	f7 f5                	div    %ebp
  80211c:	89 cf                	mov    %ecx,%edi
  80211e:	89 fa                	mov    %edi,%edx
  802120:	83 c4 1c             	add    $0x1c,%esp
  802123:	5b                   	pop    %ebx
  802124:	5e                   	pop    %esi
  802125:	5f                   	pop    %edi
  802126:	5d                   	pop    %ebp
  802127:	c3                   	ret    
  802128:	39 ce                	cmp    %ecx,%esi
  80212a:	77 28                	ja     802154 <__udivdi3+0x7c>
  80212c:	0f bd fe             	bsr    %esi,%edi
  80212f:	83 f7 1f             	xor    $0x1f,%edi
  802132:	75 40                	jne    802174 <__udivdi3+0x9c>
  802134:	39 ce                	cmp    %ecx,%esi
  802136:	72 0a                	jb     802142 <__udivdi3+0x6a>
  802138:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80213c:	0f 87 9e 00 00 00    	ja     8021e0 <__udivdi3+0x108>
  802142:	b8 01 00 00 00       	mov    $0x1,%eax
  802147:	89 fa                	mov    %edi,%edx
  802149:	83 c4 1c             	add    $0x1c,%esp
  80214c:	5b                   	pop    %ebx
  80214d:	5e                   	pop    %esi
  80214e:	5f                   	pop    %edi
  80214f:	5d                   	pop    %ebp
  802150:	c3                   	ret    
  802151:	8d 76 00             	lea    0x0(%esi),%esi
  802154:	31 ff                	xor    %edi,%edi
  802156:	31 c0                	xor    %eax,%eax
  802158:	89 fa                	mov    %edi,%edx
  80215a:	83 c4 1c             	add    $0x1c,%esp
  80215d:	5b                   	pop    %ebx
  80215e:	5e                   	pop    %esi
  80215f:	5f                   	pop    %edi
  802160:	5d                   	pop    %ebp
  802161:	c3                   	ret    
  802162:	66 90                	xchg   %ax,%ax
  802164:	89 d8                	mov    %ebx,%eax
  802166:	f7 f7                	div    %edi
  802168:	31 ff                	xor    %edi,%edi
  80216a:	89 fa                	mov    %edi,%edx
  80216c:	83 c4 1c             	add    $0x1c,%esp
  80216f:	5b                   	pop    %ebx
  802170:	5e                   	pop    %esi
  802171:	5f                   	pop    %edi
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    
  802174:	bd 20 00 00 00       	mov    $0x20,%ebp
  802179:	89 eb                	mov    %ebp,%ebx
  80217b:	29 fb                	sub    %edi,%ebx
  80217d:	89 f9                	mov    %edi,%ecx
  80217f:	d3 e6                	shl    %cl,%esi
  802181:	89 c5                	mov    %eax,%ebp
  802183:	88 d9                	mov    %bl,%cl
  802185:	d3 ed                	shr    %cl,%ebp
  802187:	89 e9                	mov    %ebp,%ecx
  802189:	09 f1                	or     %esi,%ecx
  80218b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80218f:	89 f9                	mov    %edi,%ecx
  802191:	d3 e0                	shl    %cl,%eax
  802193:	89 c5                	mov    %eax,%ebp
  802195:	89 d6                	mov    %edx,%esi
  802197:	88 d9                	mov    %bl,%cl
  802199:	d3 ee                	shr    %cl,%esi
  80219b:	89 f9                	mov    %edi,%ecx
  80219d:	d3 e2                	shl    %cl,%edx
  80219f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021a3:	88 d9                	mov    %bl,%cl
  8021a5:	d3 e8                	shr    %cl,%eax
  8021a7:	09 c2                	or     %eax,%edx
  8021a9:	89 d0                	mov    %edx,%eax
  8021ab:	89 f2                	mov    %esi,%edx
  8021ad:	f7 74 24 0c          	divl   0xc(%esp)
  8021b1:	89 d6                	mov    %edx,%esi
  8021b3:	89 c3                	mov    %eax,%ebx
  8021b5:	f7 e5                	mul    %ebp
  8021b7:	39 d6                	cmp    %edx,%esi
  8021b9:	72 19                	jb     8021d4 <__udivdi3+0xfc>
  8021bb:	74 0b                	je     8021c8 <__udivdi3+0xf0>
  8021bd:	89 d8                	mov    %ebx,%eax
  8021bf:	31 ff                	xor    %edi,%edi
  8021c1:	e9 58 ff ff ff       	jmp    80211e <__udivdi3+0x46>
  8021c6:	66 90                	xchg   %ax,%ax
  8021c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021cc:	89 f9                	mov    %edi,%ecx
  8021ce:	d3 e2                	shl    %cl,%edx
  8021d0:	39 c2                	cmp    %eax,%edx
  8021d2:	73 e9                	jae    8021bd <__udivdi3+0xe5>
  8021d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021d7:	31 ff                	xor    %edi,%edi
  8021d9:	e9 40 ff ff ff       	jmp    80211e <__udivdi3+0x46>
  8021de:	66 90                	xchg   %ax,%ax
  8021e0:	31 c0                	xor    %eax,%eax
  8021e2:	e9 37 ff ff ff       	jmp    80211e <__udivdi3+0x46>
  8021e7:	90                   	nop

008021e8 <__umoddi3>:
  8021e8:	55                   	push   %ebp
  8021e9:	57                   	push   %edi
  8021ea:	56                   	push   %esi
  8021eb:	53                   	push   %ebx
  8021ec:	83 ec 1c             	sub    $0x1c,%esp
  8021ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802203:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802207:	89 f3                	mov    %esi,%ebx
  802209:	89 fa                	mov    %edi,%edx
  80220b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80220f:	89 34 24             	mov    %esi,(%esp)
  802212:	85 c0                	test   %eax,%eax
  802214:	75 1a                	jne    802230 <__umoddi3+0x48>
  802216:	39 f7                	cmp    %esi,%edi
  802218:	0f 86 a2 00 00 00    	jbe    8022c0 <__umoddi3+0xd8>
  80221e:	89 c8                	mov    %ecx,%eax
  802220:	89 f2                	mov    %esi,%edx
  802222:	f7 f7                	div    %edi
  802224:	89 d0                	mov    %edx,%eax
  802226:	31 d2                	xor    %edx,%edx
  802228:	83 c4 1c             	add    $0x1c,%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5e                   	pop    %esi
  80222d:	5f                   	pop    %edi
  80222e:	5d                   	pop    %ebp
  80222f:	c3                   	ret    
  802230:	39 f0                	cmp    %esi,%eax
  802232:	0f 87 ac 00 00 00    	ja     8022e4 <__umoddi3+0xfc>
  802238:	0f bd e8             	bsr    %eax,%ebp
  80223b:	83 f5 1f             	xor    $0x1f,%ebp
  80223e:	0f 84 ac 00 00 00    	je     8022f0 <__umoddi3+0x108>
  802244:	bf 20 00 00 00       	mov    $0x20,%edi
  802249:	29 ef                	sub    %ebp,%edi
  80224b:	89 fe                	mov    %edi,%esi
  80224d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802251:	89 e9                	mov    %ebp,%ecx
  802253:	d3 e0                	shl    %cl,%eax
  802255:	89 d7                	mov    %edx,%edi
  802257:	89 f1                	mov    %esi,%ecx
  802259:	d3 ef                	shr    %cl,%edi
  80225b:	09 c7                	or     %eax,%edi
  80225d:	89 e9                	mov    %ebp,%ecx
  80225f:	d3 e2                	shl    %cl,%edx
  802261:	89 14 24             	mov    %edx,(%esp)
  802264:	89 d8                	mov    %ebx,%eax
  802266:	d3 e0                	shl    %cl,%eax
  802268:	89 c2                	mov    %eax,%edx
  80226a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80226e:	d3 e0                	shl    %cl,%eax
  802270:	89 44 24 04          	mov    %eax,0x4(%esp)
  802274:	8b 44 24 08          	mov    0x8(%esp),%eax
  802278:	89 f1                	mov    %esi,%ecx
  80227a:	d3 e8                	shr    %cl,%eax
  80227c:	09 d0                	or     %edx,%eax
  80227e:	d3 eb                	shr    %cl,%ebx
  802280:	89 da                	mov    %ebx,%edx
  802282:	f7 f7                	div    %edi
  802284:	89 d3                	mov    %edx,%ebx
  802286:	f7 24 24             	mull   (%esp)
  802289:	89 c6                	mov    %eax,%esi
  80228b:	89 d1                	mov    %edx,%ecx
  80228d:	39 d3                	cmp    %edx,%ebx
  80228f:	0f 82 87 00 00 00    	jb     80231c <__umoddi3+0x134>
  802295:	0f 84 91 00 00 00    	je     80232c <__umoddi3+0x144>
  80229b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80229f:	29 f2                	sub    %esi,%edx
  8022a1:	19 cb                	sbb    %ecx,%ebx
  8022a3:	89 d8                	mov    %ebx,%eax
  8022a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022a9:	d3 e0                	shl    %cl,%eax
  8022ab:	89 e9                	mov    %ebp,%ecx
  8022ad:	d3 ea                	shr    %cl,%edx
  8022af:	09 d0                	or     %edx,%eax
  8022b1:	89 e9                	mov    %ebp,%ecx
  8022b3:	d3 eb                	shr    %cl,%ebx
  8022b5:	89 da                	mov    %ebx,%edx
  8022b7:	83 c4 1c             	add    $0x1c,%esp
  8022ba:	5b                   	pop    %ebx
  8022bb:	5e                   	pop    %esi
  8022bc:	5f                   	pop    %edi
  8022bd:	5d                   	pop    %ebp
  8022be:	c3                   	ret    
  8022bf:	90                   	nop
  8022c0:	89 fd                	mov    %edi,%ebp
  8022c2:	85 ff                	test   %edi,%edi
  8022c4:	75 0b                	jne    8022d1 <__umoddi3+0xe9>
  8022c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cb:	31 d2                	xor    %edx,%edx
  8022cd:	f7 f7                	div    %edi
  8022cf:	89 c5                	mov    %eax,%ebp
  8022d1:	89 f0                	mov    %esi,%eax
  8022d3:	31 d2                	xor    %edx,%edx
  8022d5:	f7 f5                	div    %ebp
  8022d7:	89 c8                	mov    %ecx,%eax
  8022d9:	f7 f5                	div    %ebp
  8022db:	89 d0                	mov    %edx,%eax
  8022dd:	e9 44 ff ff ff       	jmp    802226 <__umoddi3+0x3e>
  8022e2:	66 90                	xchg   %ax,%ax
  8022e4:	89 c8                	mov    %ecx,%eax
  8022e6:	89 f2                	mov    %esi,%edx
  8022e8:	83 c4 1c             	add    $0x1c,%esp
  8022eb:	5b                   	pop    %ebx
  8022ec:	5e                   	pop    %esi
  8022ed:	5f                   	pop    %edi
  8022ee:	5d                   	pop    %ebp
  8022ef:	c3                   	ret    
  8022f0:	3b 04 24             	cmp    (%esp),%eax
  8022f3:	72 06                	jb     8022fb <__umoddi3+0x113>
  8022f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8022f9:	77 0f                	ja     80230a <__umoddi3+0x122>
  8022fb:	89 f2                	mov    %esi,%edx
  8022fd:	29 f9                	sub    %edi,%ecx
  8022ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802303:	89 14 24             	mov    %edx,(%esp)
  802306:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80230a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80230e:	8b 14 24             	mov    (%esp),%edx
  802311:	83 c4 1c             	add    $0x1c,%esp
  802314:	5b                   	pop    %ebx
  802315:	5e                   	pop    %esi
  802316:	5f                   	pop    %edi
  802317:	5d                   	pop    %ebp
  802318:	c3                   	ret    
  802319:	8d 76 00             	lea    0x0(%esi),%esi
  80231c:	2b 04 24             	sub    (%esp),%eax
  80231f:	19 fa                	sbb    %edi,%edx
  802321:	89 d1                	mov    %edx,%ecx
  802323:	89 c6                	mov    %eax,%esi
  802325:	e9 71 ff ff ff       	jmp    80229b <__umoddi3+0xb3>
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802330:	72 ea                	jb     80231c <__umoddi3+0x134>
  802332:	89 d9                	mov    %ebx,%ecx
  802334:	e9 62 ff ff ff       	jmp    80229b <__umoddi3+0xb3>
