
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 4b 01 00 00       	call   800181 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing removing the shared variables
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 e0 22 80 00       	push   $0x8022e0
  80004a:	e8 3d 18 00 00       	call   80188c <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 66 1a 00 00       	call   801ac9 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 e1 1a 00 00       	call   801b4c <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 f0 22 80 00       	push   $0x8022f0
  800079:	e8 ea 04 00 00       	call   800568 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,100, 50);
  800081:	6a 32                	push   $0x32
  800083:	6a 64                	push   $0x64
  800085:	68 d0 07 00 00       	push   $0x7d0
  80008a:	68 23 23 80 00       	push   $0x802323
  80008f:	e8 8a 1c 00 00       	call   801d1e <sys_create_env>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000,100, 50);
  80009a:	6a 32                	push   $0x32
  80009c:	6a 64                	push   $0x64
  80009e:	68 d0 07 00 00       	push   $0x7d0
  8000a3:	68 2c 23 80 00       	push   $0x80232c
  8000a8:	e8 71 1c 00 00       	call   801d1e <sys_create_env>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	e8 7e 1c 00 00       	call   801d3c <sys_run_env>
  8000be:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 98 3a 00 00       	push   $0x3a98
  8000c9:	e8 ec 1e 00 00       	call   801fba <env_sleep>
  8000ce:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d7:	e8 60 1c 00 00       	call   801d3c <sys_run_env>
  8000dc:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000df:	90                   	nop
  8000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	83 f8 02             	cmp    $0x2,%eax
  8000e8:	75 f6                	jne    8000e0 <_main+0xa8>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ea:	e8 da 19 00 00       	call   801ac9 <sys_calculate_free_frames>
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	50                   	push   %eax
  8000f3:	68 38 23 80 00       	push   $0x802338
  8000f8:	e8 6b 04 00 00       	call   800568 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp

	sys_free_env(envIdProcessA);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e8             	pushl  -0x18(%ebp)
  800106:	e8 4d 1c 00 00       	call   801d58 <sys_free_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_free_env(envIdProcessB);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 e4             	pushl  -0x1c(%ebp)
  800114:	e8 3f 1c 00 00       	call   801d58 <sys_free_env>
  800119:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011c:	e8 a8 19 00 00       	call   801ac9 <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800124:	e8 23 1a 00 00       	call   801b4c <sys_pf_calculate_allocated_pages>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800132:	74 27                	je     80015b <_main+0x123>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	68 6c 23 80 00       	push   $0x80236c
  80013f:	e8 24 04 00 00       	call   800568 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 bc 23 80 00       	push   $0x8023bc
  80014f:	6a 23                	push   $0x23
  800151:	68 f2 23 80 00       	push   $0x8023f2
  800156:	e8 6b 01 00 00       	call   8002c6 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	68 08 24 80 00       	push   $0x802408
  800166:	e8 fd 03 00 00       	call   800568 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 68 24 80 00       	push   $0x802468
  800176:	e8 ed 03 00 00       	call   800568 <cprintf>
  80017b:	83 c4 10             	add    $0x10,%esp
	return;
  80017e:	90                   	nop
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800187:	e8 72 18 00 00       	call   8019fe <sys_getenvindex>
  80018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80018f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	c1 e0 03             	shl    $0x3,%eax
  800197:	01 d0                	add    %edx,%eax
  800199:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001a0:	01 c8                	add    %ecx,%eax
  8001a2:	01 c0                	add    %eax,%eax
  8001a4:	01 d0                	add    %edx,%eax
  8001a6:	01 c0                	add    %eax,%eax
  8001a8:	01 d0                	add    %edx,%eax
  8001aa:	89 c2                	mov    %eax,%edx
  8001ac:	c1 e2 05             	shl    $0x5,%edx
  8001af:	29 c2                	sub    %eax,%edx
  8001b1:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001b8:	89 c2                	mov    %eax,%edx
  8001ba:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001c0:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ca:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001d0:	84 c0                	test   %al,%al
  8001d2:	74 0f                	je     8001e3 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d9:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001de:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e7:	7e 0a                	jle    8001f3 <libmain+0x72>
		binaryname = argv[0];
  8001e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ec:	8b 00                	mov    (%eax),%eax
  8001ee:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001f3:	83 ec 08             	sub    $0x8,%esp
  8001f6:	ff 75 0c             	pushl  0xc(%ebp)
  8001f9:	ff 75 08             	pushl  0x8(%ebp)
  8001fc:	e8 37 fe ff ff       	call   800038 <_main>
  800201:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800204:	e8 90 19 00 00       	call   801b99 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	68 cc 24 80 00       	push   $0x8024cc
  800211:	e8 52 03 00 00       	call   800568 <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800219:	a1 20 30 80 00       	mov    0x803020,%eax
  80021e:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800224:	a1 20 30 80 00       	mov    0x803020,%eax
  800229:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	52                   	push   %edx
  800233:	50                   	push   %eax
  800234:	68 f4 24 80 00       	push   $0x8024f4
  800239:	e8 2a 03 00 00       	call   800568 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800241:	a1 20 30 80 00       	mov    0x803020,%eax
  800246:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80024c:	a1 20 30 80 00       	mov    0x803020,%eax
  800251:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	52                   	push   %edx
  80025b:	50                   	push   %eax
  80025c:	68 1c 25 80 00       	push   $0x80251c
  800261:	e8 02 03 00 00       	call   800568 <cprintf>
  800266:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800269:	a1 20 30 80 00       	mov    0x803020,%eax
  80026e:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800274:	83 ec 08             	sub    $0x8,%esp
  800277:	50                   	push   %eax
  800278:	68 5d 25 80 00       	push   $0x80255d
  80027d:	e8 e6 02 00 00       	call   800568 <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	68 cc 24 80 00       	push   $0x8024cc
  80028d:	e8 d6 02 00 00       	call   800568 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800295:	e8 19 19 00 00       	call   801bb3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80029a:	e8 19 00 00 00       	call   8002b8 <exit>
}
  80029f:	90                   	nop
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    

008002a2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	6a 00                	push   $0x0
  8002ad:	e8 18 17 00 00       	call   8019ca <sys_env_destroy>
  8002b2:	83 c4 10             	add    $0x10,%esp
}
  8002b5:	90                   	nop
  8002b6:	c9                   	leave  
  8002b7:	c3                   	ret    

008002b8 <exit>:

void
exit(void)
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002be:	e8 6d 17 00 00       	call   801a30 <sys_env_exit>
}
  8002c3:	90                   	nop
  8002c4:	c9                   	leave  
  8002c5:	c3                   	ret    

008002c6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002cc:	8d 45 10             	lea    0x10(%ebp),%eax
  8002cf:	83 c0 04             	add    $0x4,%eax
  8002d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002d5:	a1 18 31 80 00       	mov    0x803118,%eax
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	74 16                	je     8002f4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002de:	a1 18 31 80 00       	mov    0x803118,%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	50                   	push   %eax
  8002e7:	68 74 25 80 00       	push   $0x802574
  8002ec:	e8 77 02 00 00       	call   800568 <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002f4:	a1 00 30 80 00       	mov    0x803000,%eax
  8002f9:	ff 75 0c             	pushl  0xc(%ebp)
  8002fc:	ff 75 08             	pushl  0x8(%ebp)
  8002ff:	50                   	push   %eax
  800300:	68 79 25 80 00       	push   $0x802579
  800305:	e8 5e 02 00 00       	call   800568 <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80030d:	8b 45 10             	mov    0x10(%ebp),%eax
  800310:	83 ec 08             	sub    $0x8,%esp
  800313:	ff 75 f4             	pushl  -0xc(%ebp)
  800316:	50                   	push   %eax
  800317:	e8 e1 01 00 00       	call   8004fd <vcprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80031f:	83 ec 08             	sub    $0x8,%esp
  800322:	6a 00                	push   $0x0
  800324:	68 95 25 80 00       	push   $0x802595
  800329:	e8 cf 01 00 00       	call   8004fd <vcprintf>
  80032e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800331:	e8 82 ff ff ff       	call   8002b8 <exit>

	// should not return here
	while (1) ;
  800336:	eb fe                	jmp    800336 <_panic+0x70>

00800338 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80033e:	a1 20 30 80 00       	mov    0x803020,%eax
  800343:	8b 50 74             	mov    0x74(%eax),%edx
  800346:	8b 45 0c             	mov    0xc(%ebp),%eax
  800349:	39 c2                	cmp    %eax,%edx
  80034b:	74 14                	je     800361 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	68 98 25 80 00       	push   $0x802598
  800355:	6a 26                	push   $0x26
  800357:	68 e4 25 80 00       	push   $0x8025e4
  80035c:	e8 65 ff ff ff       	call   8002c6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800361:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800368:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036f:	e9 b6 00 00 00       	jmp    80042a <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800374:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800377:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80037e:	8b 45 08             	mov    0x8(%ebp),%eax
  800381:	01 d0                	add    %edx,%eax
  800383:	8b 00                	mov    (%eax),%eax
  800385:	85 c0                	test   %eax,%eax
  800387:	75 08                	jne    800391 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800389:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80038c:	e9 96 00 00 00       	jmp    800427 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800391:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800398:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80039f:	eb 5d                	jmp    8003fe <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a6:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003af:	c1 e2 04             	shl    $0x4,%edx
  8003b2:	01 d0                	add    %edx,%eax
  8003b4:	8a 40 04             	mov    0x4(%eax),%al
  8003b7:	84 c0                	test   %al,%al
  8003b9:	75 40                	jne    8003fb <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c0:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003c9:	c1 e2 04             	shl    $0x4,%edx
  8003cc:	01 d0                	add    %edx,%eax
  8003ce:	8b 00                	mov    (%eax),%eax
  8003d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003db:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ea:	01 c8                	add    %ecx,%eax
  8003ec:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ee:	39 c2                	cmp    %eax,%edx
  8003f0:	75 09                	jne    8003fb <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8003f2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003f9:	eb 12                	jmp    80040d <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fb:	ff 45 e8             	incl   -0x18(%ebp)
  8003fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800403:	8b 50 74             	mov    0x74(%eax),%edx
  800406:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800409:	39 c2                	cmp    %eax,%edx
  80040b:	77 94                	ja     8003a1 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80040d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800411:	75 14                	jne    800427 <CheckWSWithoutLastIndex+0xef>
			panic(
  800413:	83 ec 04             	sub    $0x4,%esp
  800416:	68 f0 25 80 00       	push   $0x8025f0
  80041b:	6a 3a                	push   $0x3a
  80041d:	68 e4 25 80 00       	push   $0x8025e4
  800422:	e8 9f fe ff ff       	call   8002c6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800427:	ff 45 f0             	incl   -0x10(%ebp)
  80042a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800430:	0f 8c 3e ff ff ff    	jl     800374 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800436:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800444:	eb 20                	jmp    800466 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800446:	a1 20 30 80 00       	mov    0x803020,%eax
  80044b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800451:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800454:	c1 e2 04             	shl    $0x4,%edx
  800457:	01 d0                	add    %edx,%eax
  800459:	8a 40 04             	mov    0x4(%eax),%al
  80045c:	3c 01                	cmp    $0x1,%al
  80045e:	75 03                	jne    800463 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800460:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800463:	ff 45 e0             	incl   -0x20(%ebp)
  800466:	a1 20 30 80 00       	mov    0x803020,%eax
  80046b:	8b 50 74             	mov    0x74(%eax),%edx
  80046e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800471:	39 c2                	cmp    %eax,%edx
  800473:	77 d1                	ja     800446 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800478:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047b:	74 14                	je     800491 <CheckWSWithoutLastIndex+0x159>
		panic(
  80047d:	83 ec 04             	sub    $0x4,%esp
  800480:	68 44 26 80 00       	push   $0x802644
  800485:	6a 44                	push   $0x44
  800487:	68 e4 25 80 00       	push   $0x8025e4
  80048c:	e8 35 fe ff ff       	call   8002c6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800491:	90                   	nop
  800492:	c9                   	leave  
  800493:	c3                   	ret    

00800494 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80049a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a5:	89 0a                	mov    %ecx,(%edx)
  8004a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8004aa:	88 d1                	mov    %dl,%cl
  8004ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004af:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b6:	8b 00                	mov    (%eax),%eax
  8004b8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bd:	75 2c                	jne    8004eb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004bf:	a0 24 30 80 00       	mov    0x803024,%al
  8004c4:	0f b6 c0             	movzbl %al,%eax
  8004c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ca:	8b 12                	mov    (%edx),%edx
  8004cc:	89 d1                	mov    %edx,%ecx
  8004ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d1:	83 c2 08             	add    $0x8,%edx
  8004d4:	83 ec 04             	sub    $0x4,%esp
  8004d7:	50                   	push   %eax
  8004d8:	51                   	push   %ecx
  8004d9:	52                   	push   %edx
  8004da:	e8 a9 14 00 00       	call   801988 <sys_cputs>
  8004df:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ee:	8b 40 04             	mov    0x4(%eax),%eax
  8004f1:	8d 50 01             	lea    0x1(%eax),%edx
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fa:	90                   	nop
  8004fb:	c9                   	leave  
  8004fc:	c3                   	ret    

008004fd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800506:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050d:	00 00 00 
	b.cnt = 0;
  800510:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800517:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051a:	ff 75 0c             	pushl  0xc(%ebp)
  80051d:	ff 75 08             	pushl  0x8(%ebp)
  800520:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800526:	50                   	push   %eax
  800527:	68 94 04 80 00       	push   $0x800494
  80052c:	e8 11 02 00 00       	call   800742 <vprintfmt>
  800531:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800534:	a0 24 30 80 00       	mov    0x803024,%al
  800539:	0f b6 c0             	movzbl %al,%eax
  80053c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	50                   	push   %eax
  800546:	52                   	push   %edx
  800547:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054d:	83 c0 08             	add    $0x8,%eax
  800550:	50                   	push   %eax
  800551:	e8 32 14 00 00       	call   801988 <sys_cputs>
  800556:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800559:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800560:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800566:	c9                   	leave  
  800567:	c3                   	ret    

00800568 <cprintf>:

int cprintf(const char *fmt, ...) {
  800568:	55                   	push   %ebp
  800569:	89 e5                	mov    %esp,%ebp
  80056b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056e:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800575:	8d 45 0c             	lea    0xc(%ebp),%eax
  800578:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80057b:	8b 45 08             	mov    0x8(%ebp),%eax
  80057e:	83 ec 08             	sub    $0x8,%esp
  800581:	ff 75 f4             	pushl  -0xc(%ebp)
  800584:	50                   	push   %eax
  800585:	e8 73 ff ff ff       	call   8004fd <vcprintf>
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800590:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800593:	c9                   	leave  
  800594:	c3                   	ret    

00800595 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800595:	55                   	push   %ebp
  800596:	89 e5                	mov    %esp,%ebp
  800598:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80059b:	e8 f9 15 00 00       	call   801b99 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8005af:	50                   	push   %eax
  8005b0:	e8 48 ff ff ff       	call   8004fd <vcprintf>
  8005b5:	83 c4 10             	add    $0x10,%esp
  8005b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005bb:	e8 f3 15 00 00       	call   801bb3 <sys_enable_interrupt>
	return cnt;
  8005c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c3:	c9                   	leave  
  8005c4:	c3                   	ret    

008005c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	53                   	push   %ebx
  8005c9:	83 ec 14             	sub    $0x14,%esp
  8005cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d8:	8b 45 18             	mov    0x18(%ebp),%eax
  8005db:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e3:	77 55                	ja     80063a <printnum+0x75>
  8005e5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e8:	72 05                	jb     8005ef <printnum+0x2a>
  8005ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ed:	77 4b                	ja     80063a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ef:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fd:	52                   	push   %edx
  8005fe:	50                   	push   %eax
  8005ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800602:	ff 75 f0             	pushl  -0x10(%ebp)
  800605:	e8 66 1a 00 00       	call   802070 <__udivdi3>
  80060a:	83 c4 10             	add    $0x10,%esp
  80060d:	83 ec 04             	sub    $0x4,%esp
  800610:	ff 75 20             	pushl  0x20(%ebp)
  800613:	53                   	push   %ebx
  800614:	ff 75 18             	pushl  0x18(%ebp)
  800617:	52                   	push   %edx
  800618:	50                   	push   %eax
  800619:	ff 75 0c             	pushl  0xc(%ebp)
  80061c:	ff 75 08             	pushl  0x8(%ebp)
  80061f:	e8 a1 ff ff ff       	call   8005c5 <printnum>
  800624:	83 c4 20             	add    $0x20,%esp
  800627:	eb 1a                	jmp    800643 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	ff 75 0c             	pushl  0xc(%ebp)
  80062f:	ff 75 20             	pushl  0x20(%ebp)
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	ff d0                	call   *%eax
  800637:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063a:	ff 4d 1c             	decl   0x1c(%ebp)
  80063d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800641:	7f e6                	jg     800629 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800643:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800646:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800651:	53                   	push   %ebx
  800652:	51                   	push   %ecx
  800653:	52                   	push   %edx
  800654:	50                   	push   %eax
  800655:	e8 26 1b 00 00       	call   802180 <__umoddi3>
  80065a:	83 c4 10             	add    $0x10,%esp
  80065d:	05 b4 28 80 00       	add    $0x8028b4,%eax
  800662:	8a 00                	mov    (%eax),%al
  800664:	0f be c0             	movsbl %al,%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 0c             	pushl  0xc(%ebp)
  80066d:	50                   	push   %eax
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	ff d0                	call   *%eax
  800673:	83 c4 10             	add    $0x10,%esp
}
  800676:	90                   	nop
  800677:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067a:	c9                   	leave  
  80067b:	c3                   	ret    

0080067c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800683:	7e 1c                	jle    8006a1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	8d 50 08             	lea    0x8(%eax),%edx
  80068d:	8b 45 08             	mov    0x8(%ebp),%eax
  800690:	89 10                	mov    %edx,(%eax)
  800692:	8b 45 08             	mov    0x8(%ebp),%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	83 e8 08             	sub    $0x8,%eax
  80069a:	8b 50 04             	mov    0x4(%eax),%edx
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	eb 40                	jmp    8006e1 <getuint+0x65>
	else if (lflag)
  8006a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a5:	74 1e                	je     8006c5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	8d 50 04             	lea    0x4(%eax),%edx
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	89 10                	mov    %edx,(%eax)
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	83 e8 04             	sub    $0x4,%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c3:	eb 1c                	jmp    8006e1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	8d 50 04             	lea    0x4(%eax),%edx
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	89 10                	mov    %edx,(%eax)
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	83 e8 04             	sub    $0x4,%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e1:	5d                   	pop    %ebp
  8006e2:	c3                   	ret    

008006e3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ea:	7e 1c                	jle    800708 <getint+0x25>
		return va_arg(*ap, long long);
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	8d 50 08             	lea    0x8(%eax),%edx
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	89 10                	mov    %edx,(%eax)
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	83 e8 08             	sub    $0x8,%eax
  800701:	8b 50 04             	mov    0x4(%eax),%edx
  800704:	8b 00                	mov    (%eax),%eax
  800706:	eb 38                	jmp    800740 <getint+0x5d>
	else if (lflag)
  800708:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070c:	74 1a                	je     800728 <getint+0x45>
		return va_arg(*ap, long);
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	8b 00                	mov    (%eax),%eax
  800713:	8d 50 04             	lea    0x4(%eax),%edx
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	89 10                	mov    %edx,(%eax)
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	83 e8 04             	sub    $0x4,%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	99                   	cltd   
  800726:	eb 18                	jmp    800740 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	99                   	cltd   
}
  800740:	5d                   	pop    %ebp
  800741:	c3                   	ret    

00800742 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	56                   	push   %esi
  800746:	53                   	push   %ebx
  800747:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074a:	eb 17                	jmp    800763 <vprintfmt+0x21>
			if (ch == '\0')
  80074c:	85 db                	test   %ebx,%ebx
  80074e:	0f 84 af 03 00 00    	je     800b03 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	53                   	push   %ebx
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	ff d0                	call   *%eax
  800760:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800763:	8b 45 10             	mov    0x10(%ebp),%eax
  800766:	8d 50 01             	lea    0x1(%eax),%edx
  800769:	89 55 10             	mov    %edx,0x10(%ebp)
  80076c:	8a 00                	mov    (%eax),%al
  80076e:	0f b6 d8             	movzbl %al,%ebx
  800771:	83 fb 25             	cmp    $0x25,%ebx
  800774:	75 d6                	jne    80074c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800776:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800781:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800788:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80078f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800796:	8b 45 10             	mov    0x10(%ebp),%eax
  800799:	8d 50 01             	lea    0x1(%eax),%edx
  80079c:	89 55 10             	mov    %edx,0x10(%ebp)
  80079f:	8a 00                	mov    (%eax),%al
  8007a1:	0f b6 d8             	movzbl %al,%ebx
  8007a4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a7:	83 f8 55             	cmp    $0x55,%eax
  8007aa:	0f 87 2b 03 00 00    	ja     800adb <vprintfmt+0x399>
  8007b0:	8b 04 85 d8 28 80 00 	mov    0x8028d8(,%eax,4),%eax
  8007b7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bd:	eb d7                	jmp    800796 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c3:	eb d1                	jmp    800796 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007cf:	89 d0                	mov    %edx,%eax
  8007d1:	c1 e0 02             	shl    $0x2,%eax
  8007d4:	01 d0                	add    %edx,%eax
  8007d6:	01 c0                	add    %eax,%eax
  8007d8:	01 d8                	add    %ebx,%eax
  8007da:	83 e8 30             	sub    $0x30,%eax
  8007dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e3:	8a 00                	mov    (%eax),%al
  8007e5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e8:	83 fb 2f             	cmp    $0x2f,%ebx
  8007eb:	7e 3e                	jle    80082b <vprintfmt+0xe9>
  8007ed:	83 fb 39             	cmp    $0x39,%ebx
  8007f0:	7f 39                	jg     80082b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f5:	eb d5                	jmp    8007cc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 c0 04             	add    $0x4,%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 e8 04             	sub    $0x4,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080b:	eb 1f                	jmp    80082c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800811:	79 83                	jns    800796 <vprintfmt+0x54>
				width = 0;
  800813:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081a:	e9 77 ff ff ff       	jmp    800796 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80081f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800826:	e9 6b ff ff ff       	jmp    800796 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800830:	0f 89 60 ff ff ff    	jns    800796 <vprintfmt+0x54>
				width = precision, precision = -1;
  800836:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800839:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800843:	e9 4e ff ff ff       	jmp    800796 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800848:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084b:	e9 46 ff ff ff       	jmp    800796 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	83 c0 04             	add    $0x4,%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 e8 04             	sub    $0x4,%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	50                   	push   %eax
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	ff d0                	call   *%eax
  80086d:	83 c4 10             	add    $0x10,%esp
			break;
  800870:	e9 89 02 00 00       	jmp    800afe <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800886:	85 db                	test   %ebx,%ebx
  800888:	79 02                	jns    80088c <vprintfmt+0x14a>
				err = -err;
  80088a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088c:	83 fb 64             	cmp    $0x64,%ebx
  80088f:	7f 0b                	jg     80089c <vprintfmt+0x15a>
  800891:	8b 34 9d 20 27 80 00 	mov    0x802720(,%ebx,4),%esi
  800898:	85 f6                	test   %esi,%esi
  80089a:	75 19                	jne    8008b5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089c:	53                   	push   %ebx
  80089d:	68 c5 28 80 00       	push   $0x8028c5
  8008a2:	ff 75 0c             	pushl  0xc(%ebp)
  8008a5:	ff 75 08             	pushl  0x8(%ebp)
  8008a8:	e8 5e 02 00 00       	call   800b0b <printfmt>
  8008ad:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b0:	e9 49 02 00 00       	jmp    800afe <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b5:	56                   	push   %esi
  8008b6:	68 ce 28 80 00       	push   $0x8028ce
  8008bb:	ff 75 0c             	pushl  0xc(%ebp)
  8008be:	ff 75 08             	pushl  0x8(%ebp)
  8008c1:	e8 45 02 00 00       	call   800b0b <printfmt>
  8008c6:	83 c4 10             	add    $0x10,%esp
			break;
  8008c9:	e9 30 02 00 00       	jmp    800afe <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	83 c0 04             	add    $0x4,%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 e8 04             	sub    $0x4,%eax
  8008dd:	8b 30                	mov    (%eax),%esi
  8008df:	85 f6                	test   %esi,%esi
  8008e1:	75 05                	jne    8008e8 <vprintfmt+0x1a6>
				p = "(null)";
  8008e3:	be d1 28 80 00       	mov    $0x8028d1,%esi
			if (width > 0 && padc != '-')
  8008e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ec:	7e 6d                	jle    80095b <vprintfmt+0x219>
  8008ee:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f2:	74 67                	je     80095b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	50                   	push   %eax
  8008fb:	56                   	push   %esi
  8008fc:	e8 0c 03 00 00       	call   800c0d <strnlen>
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800907:	eb 16                	jmp    80091f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800909:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	50                   	push   %eax
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	ff d0                	call   *%eax
  800919:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091c:	ff 4d e4             	decl   -0x1c(%ebp)
  80091f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800923:	7f e4                	jg     800909 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800925:	eb 34                	jmp    80095b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800927:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092b:	74 1c                	je     800949 <vprintfmt+0x207>
  80092d:	83 fb 1f             	cmp    $0x1f,%ebx
  800930:	7e 05                	jle    800937 <vprintfmt+0x1f5>
  800932:	83 fb 7e             	cmp    $0x7e,%ebx
  800935:	7e 12                	jle    800949 <vprintfmt+0x207>
					putch('?', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 3f                	push   $0x3f
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
  800947:	eb 0f                	jmp    800958 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800949:	83 ec 08             	sub    $0x8,%esp
  80094c:	ff 75 0c             	pushl  0xc(%ebp)
  80094f:	53                   	push   %ebx
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800958:	ff 4d e4             	decl   -0x1c(%ebp)
  80095b:	89 f0                	mov    %esi,%eax
  80095d:	8d 70 01             	lea    0x1(%eax),%esi
  800960:	8a 00                	mov    (%eax),%al
  800962:	0f be d8             	movsbl %al,%ebx
  800965:	85 db                	test   %ebx,%ebx
  800967:	74 24                	je     80098d <vprintfmt+0x24b>
  800969:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096d:	78 b8                	js     800927 <vprintfmt+0x1e5>
  80096f:	ff 4d e0             	decl   -0x20(%ebp)
  800972:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800976:	79 af                	jns    800927 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800978:	eb 13                	jmp    80098d <vprintfmt+0x24b>
				putch(' ', putdat);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	ff 75 0c             	pushl  0xc(%ebp)
  800980:	6a 20                	push   $0x20
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	ff d0                	call   *%eax
  800987:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098a:	ff 4d e4             	decl   -0x1c(%ebp)
  80098d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800991:	7f e7                	jg     80097a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800993:	e9 66 01 00 00       	jmp    800afe <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 e8             	pushl  -0x18(%ebp)
  80099e:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a1:	50                   	push   %eax
  8009a2:	e8 3c fd ff ff       	call   8006e3 <getint>
  8009a7:	83 c4 10             	add    $0x10,%esp
  8009aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b6:	85 d2                	test   %edx,%edx
  8009b8:	79 23                	jns    8009dd <vprintfmt+0x29b>
				putch('-', putdat);
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	6a 2d                	push   $0x2d
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d0:	f7 d8                	neg    %eax
  8009d2:	83 d2 00             	adc    $0x0,%edx
  8009d5:	f7 da                	neg    %edx
  8009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e4:	e9 bc 00 00 00       	jmp    800aa5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	e8 84 fc ff ff       	call   80067c <getuint>
  8009f8:	83 c4 10             	add    $0x10,%esp
  8009fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a01:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a08:	e9 98 00 00 00       	jmp    800aa5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 58                	push   $0x58
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 58                	push   $0x58
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 0c             	pushl  0xc(%ebp)
  800a33:	6a 58                	push   $0x58
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	ff d0                	call   *%eax
  800a3a:	83 c4 10             	add    $0x10,%esp
			break;
  800a3d:	e9 bc 00 00 00       	jmp    800afe <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 30                	push   $0x30
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 78                	push   $0x78
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a62:	8b 45 14             	mov    0x14(%ebp),%eax
  800a65:	83 c0 04             	add    $0x4,%eax
  800a68:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 e8 04             	sub    $0x4,%eax
  800a71:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a84:	eb 1f                	jmp    800aa5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8f:	50                   	push   %eax
  800a90:	e8 e7 fb ff ff       	call   80067c <getuint>
  800a95:	83 c4 10             	add    $0x10,%esp
  800a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	52                   	push   %edx
  800ab0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab3:	50                   	push   %eax
  800ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab7:	ff 75 f0             	pushl  -0x10(%ebp)
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	ff 75 08             	pushl  0x8(%ebp)
  800ac0:	e8 00 fb ff ff       	call   8005c5 <printnum>
  800ac5:	83 c4 20             	add    $0x20,%esp
			break;
  800ac8:	eb 34                	jmp    800afe <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	53                   	push   %ebx
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	ff d0                	call   *%eax
  800ad6:	83 c4 10             	add    $0x10,%esp
			break;
  800ad9:	eb 23                	jmp    800afe <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	6a 25                	push   $0x25
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	ff d0                	call   *%eax
  800ae8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aeb:	ff 4d 10             	decl   0x10(%ebp)
  800aee:	eb 03                	jmp    800af3 <vprintfmt+0x3b1>
  800af0:	ff 4d 10             	decl   0x10(%ebp)
  800af3:	8b 45 10             	mov    0x10(%ebp),%eax
  800af6:	48                   	dec    %eax
  800af7:	8a 00                	mov    (%eax),%al
  800af9:	3c 25                	cmp    $0x25,%al
  800afb:	75 f3                	jne    800af0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800afd:	90                   	nop
		}
	}
  800afe:	e9 47 fc ff ff       	jmp    80074a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b03:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b07:	5b                   	pop    %ebx
  800b08:	5e                   	pop    %esi
  800b09:	5d                   	pop    %ebp
  800b0a:	c3                   	ret    

00800b0b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b11:	8d 45 10             	lea    0x10(%ebp),%eax
  800b14:	83 c0 04             	add    $0x4,%eax
  800b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b20:	50                   	push   %eax
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	ff 75 08             	pushl  0x8(%ebp)
  800b27:	e8 16 fc ff ff       	call   800742 <vprintfmt>
  800b2c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b2f:	90                   	nop
  800b30:	c9                   	leave  
  800b31:	c3                   	ret    

00800b32 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b38:	8b 40 08             	mov    0x8(%eax),%eax
  800b3b:	8d 50 01             	lea    0x1(%eax),%edx
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b47:	8b 10                	mov    (%eax),%edx
  800b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4c:	8b 40 04             	mov    0x4(%eax),%eax
  800b4f:	39 c2                	cmp    %eax,%edx
  800b51:	73 12                	jae    800b65 <sprintputch+0x33>
		*b->buf++ = ch;
  800b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b56:	8b 00                	mov    (%eax),%eax
  800b58:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5e:	89 0a                	mov    %ecx,(%edx)
  800b60:	8b 55 08             	mov    0x8(%ebp),%edx
  800b63:	88 10                	mov    %dl,(%eax)
}
  800b65:	90                   	nop
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b77:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	01 d0                	add    %edx,%eax
  800b7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8d:	74 06                	je     800b95 <vsnprintf+0x2d>
  800b8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b93:	7f 07                	jg     800b9c <vsnprintf+0x34>
		return -E_INVAL;
  800b95:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9a:	eb 20                	jmp    800bbc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9c:	ff 75 14             	pushl  0x14(%ebp)
  800b9f:	ff 75 10             	pushl  0x10(%ebp)
  800ba2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba5:	50                   	push   %eax
  800ba6:	68 32 0b 80 00       	push   $0x800b32
  800bab:	e8 92 fb ff ff       	call   800742 <vprintfmt>
  800bb0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc4:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc7:	83 c0 04             	add    $0x4,%eax
  800bca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd3:	50                   	push   %eax
  800bd4:	ff 75 0c             	pushl  0xc(%ebp)
  800bd7:	ff 75 08             	pushl  0x8(%ebp)
  800bda:	e8 89 ff ff ff       	call   800b68 <vsnprintf>
  800bdf:	83 c4 10             	add    $0x10,%esp
  800be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf7:	eb 06                	jmp    800bff <strlen+0x15>
		n++;
  800bf9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfc:	ff 45 08             	incl   0x8(%ebp)
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	8a 00                	mov    (%eax),%al
  800c04:	84 c0                	test   %al,%al
  800c06:	75 f1                	jne    800bf9 <strlen+0xf>
		n++;
	return n;
  800c08:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1a:	eb 09                	jmp    800c25 <strnlen+0x18>
		n++;
  800c1c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1f:	ff 45 08             	incl   0x8(%ebp)
  800c22:	ff 4d 0c             	decl   0xc(%ebp)
  800c25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c29:	74 09                	je     800c34 <strnlen+0x27>
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	8a 00                	mov    (%eax),%al
  800c30:	84 c0                	test   %al,%al
  800c32:	75 e8                	jne    800c1c <strnlen+0xf>
		n++;
	return n;
  800c34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c37:	c9                   	leave  
  800c38:	c3                   	ret    

00800c39 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c45:	90                   	nop
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	8d 50 01             	lea    0x1(%eax),%edx
  800c4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c52:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c55:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c58:	8a 12                	mov    (%edx),%dl
  800c5a:	88 10                	mov    %dl,(%eax)
  800c5c:	8a 00                	mov    (%eax),%al
  800c5e:	84 c0                	test   %al,%al
  800c60:	75 e4                	jne    800c46 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c62:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c65:	c9                   	leave  
  800c66:	c3                   	ret    

00800c67 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7a:	eb 1f                	jmp    800c9b <strncpy+0x34>
		*dst++ = *src;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8d 50 01             	lea    0x1(%eax),%edx
  800c82:	89 55 08             	mov    %edx,0x8(%ebp)
  800c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c88:	8a 12                	mov    (%edx),%dl
  800c8a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	84 c0                	test   %al,%al
  800c93:	74 03                	je     800c98 <strncpy+0x31>
			src++;
  800c95:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c98:	ff 45 fc             	incl   -0x4(%ebp)
  800c9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca1:	72 d9                	jb     800c7c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca6:	c9                   	leave  
  800ca7:	c3                   	ret    

00800ca8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb8:	74 30                	je     800cea <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cba:	eb 16                	jmp    800cd2 <strlcpy+0x2a>
			*dst++ = *src++;
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8d 50 01             	lea    0x1(%eax),%edx
  800cc2:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cce:	8a 12                	mov    (%edx),%dl
  800cd0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd2:	ff 4d 10             	decl   0x10(%ebp)
  800cd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd9:	74 09                	je     800ce4 <strlcpy+0x3c>
  800cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	84 c0                	test   %al,%al
  800ce2:	75 d8                	jne    800cbc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ced:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf0:	29 c2                	sub    %eax,%edx
  800cf2:	89 d0                	mov    %edx,%eax
}
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    

00800cf6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cf9:	eb 06                	jmp    800d01 <strcmp+0xb>
		p++, q++;
  800cfb:	ff 45 08             	incl   0x8(%ebp)
  800cfe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	84 c0                	test   %al,%al
  800d08:	74 0e                	je     800d18 <strcmp+0x22>
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 10                	mov    (%eax),%dl
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	38 c2                	cmp    %al,%dl
  800d16:	74 e3                	je     800cfb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	0f b6 d0             	movzbl %al,%edx
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	0f b6 c0             	movzbl %al,%eax
  800d28:	29 c2                	sub    %eax,%edx
  800d2a:	89 d0                	mov    %edx,%eax
}
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    

00800d2e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d31:	eb 09                	jmp    800d3c <strncmp+0xe>
		n--, p++, q++;
  800d33:	ff 4d 10             	decl   0x10(%ebp)
  800d36:	ff 45 08             	incl   0x8(%ebp)
  800d39:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d40:	74 17                	je     800d59 <strncmp+0x2b>
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	74 0e                	je     800d59 <strncmp+0x2b>
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 10                	mov    (%eax),%dl
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	38 c2                	cmp    %al,%dl
  800d57:	74 da                	je     800d33 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5d:	75 07                	jne    800d66 <strncmp+0x38>
		return 0;
  800d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d64:	eb 14                	jmp    800d7a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	0f b6 d0             	movzbl %al,%edx
  800d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	0f b6 c0             	movzbl %al,%eax
  800d76:	29 c2                	sub    %eax,%edx
  800d78:	89 d0                	mov    %edx,%eax
}
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	83 ec 04             	sub    $0x4,%esp
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d88:	eb 12                	jmp    800d9c <strchr+0x20>
		if (*s == c)
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d92:	75 05                	jne    800d99 <strchr+0x1d>
			return (char *) s;
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	eb 11                	jmp    800daa <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d99:	ff 45 08             	incl   0x8(%ebp)
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	8a 00                	mov    (%eax),%al
  800da1:	84 c0                	test   %al,%al
  800da3:	75 e5                	jne    800d8a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    

00800dac <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 04             	sub    $0x4,%esp
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db8:	eb 0d                	jmp    800dc7 <strfind+0x1b>
		if (*s == c)
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc2:	74 0e                	je     800dd2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc4:	ff 45 08             	incl   0x8(%ebp)
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	84 c0                	test   %al,%al
  800dce:	75 ea                	jne    800dba <strfind+0xe>
  800dd0:	eb 01                	jmp    800dd3 <strfind+0x27>
		if (*s == c)
			break;
  800dd2:	90                   	nop
	return (char *) s;
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd6:	c9                   	leave  
  800dd7:	c3                   	ret    

00800dd8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de4:	8b 45 10             	mov    0x10(%ebp),%eax
  800de7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dea:	eb 0e                	jmp    800dfa <memset+0x22>
		*p++ = c;
  800dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800def:	8d 50 01             	lea    0x1(%eax),%edx
  800df2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dfa:	ff 4d f8             	decl   -0x8(%ebp)
  800dfd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e01:	79 e9                	jns    800dec <memset+0x14>
		*p++ = c;

	return v;
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e1a:	eb 16                	jmp    800e32 <memcpy+0x2a>
		*d++ = *s++;
  800e1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1f:	8d 50 01             	lea    0x1(%eax),%edx
  800e22:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e28:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e2e:	8a 12                	mov    (%edx),%dl
  800e30:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e32:	8b 45 10             	mov    0x10(%ebp),%eax
  800e35:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e38:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3b:	85 c0                	test   %eax,%eax
  800e3d:	75 dd                	jne    800e1c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e42:	c9                   	leave  
  800e43:	c3                   	ret    

00800e44 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e59:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5c:	73 50                	jae    800eae <memmove+0x6a>
  800e5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e61:	8b 45 10             	mov    0x10(%ebp),%eax
  800e64:	01 d0                	add    %edx,%eax
  800e66:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e69:	76 43                	jbe    800eae <memmove+0x6a>
		s += n;
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e71:	8b 45 10             	mov    0x10(%ebp),%eax
  800e74:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e77:	eb 10                	jmp    800e89 <memmove+0x45>
			*--d = *--s;
  800e79:	ff 4d f8             	decl   -0x8(%ebp)
  800e7c:	ff 4d fc             	decl   -0x4(%ebp)
  800e7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e82:	8a 10                	mov    (%eax),%dl
  800e84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e87:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e89:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e92:	85 c0                	test   %eax,%eax
  800e94:	75 e3                	jne    800e79 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e96:	eb 23                	jmp    800ebb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9b:	8d 50 01             	lea    0x1(%eax),%edx
  800e9e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eaa:	8a 12                	mov    (%edx),%dl
  800eac:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eae:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb4:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	75 dd                	jne    800e98 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebe:	c9                   	leave  
  800ebf:	c3                   	ret    

00800ec0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed2:	eb 2a                	jmp    800efe <memcmp+0x3e>
		if (*s1 != *s2)
  800ed4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed7:	8a 10                	mov    (%eax),%dl
  800ed9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	38 c2                	cmp    %al,%dl
  800ee0:	74 16                	je     800ef8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	0f b6 d0             	movzbl %al,%edx
  800eea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	0f b6 c0             	movzbl %al,%eax
  800ef2:	29 c2                	sub    %eax,%edx
  800ef4:	89 d0                	mov    %edx,%eax
  800ef6:	eb 18                	jmp    800f10 <memcmp+0x50>
		s1++, s2++;
  800ef8:	ff 45 fc             	incl   -0x4(%ebp)
  800efb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800efe:	8b 45 10             	mov    0x10(%ebp),%eax
  800f01:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f04:	89 55 10             	mov    %edx,0x10(%ebp)
  800f07:	85 c0                	test   %eax,%eax
  800f09:	75 c9                	jne    800ed4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    

00800f12 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f18:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	01 d0                	add    %edx,%eax
  800f20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f23:	eb 15                	jmp    800f3a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	0f b6 d0             	movzbl %al,%edx
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	0f b6 c0             	movzbl %al,%eax
  800f33:	39 c2                	cmp    %eax,%edx
  800f35:	74 0d                	je     800f44 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f37:	ff 45 08             	incl   0x8(%ebp)
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f40:	72 e3                	jb     800f25 <memfind+0x13>
  800f42:	eb 01                	jmp    800f45 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f44:	90                   	nop
	return (void *) s;
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f48:	c9                   	leave  
  800f49:	c3                   	ret    

00800f4a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f57:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5e:	eb 03                	jmp    800f63 <strtol+0x19>
		s++;
  800f60:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	3c 20                	cmp    $0x20,%al
  800f6a:	74 f4                	je     800f60 <strtol+0x16>
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 09                	cmp    $0x9,%al
  800f73:	74 eb                	je     800f60 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	3c 2b                	cmp    $0x2b,%al
  800f7c:	75 05                	jne    800f83 <strtol+0x39>
		s++;
  800f7e:	ff 45 08             	incl   0x8(%ebp)
  800f81:	eb 13                	jmp    800f96 <strtol+0x4c>
	else if (*s == '-')
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	3c 2d                	cmp    $0x2d,%al
  800f8a:	75 0a                	jne    800f96 <strtol+0x4c>
		s++, neg = 1;
  800f8c:	ff 45 08             	incl   0x8(%ebp)
  800f8f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9a:	74 06                	je     800fa2 <strtol+0x58>
  800f9c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa0:	75 20                	jne    800fc2 <strtol+0x78>
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	3c 30                	cmp    $0x30,%al
  800fa9:	75 17                	jne    800fc2 <strtol+0x78>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	40                   	inc    %eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3c 78                	cmp    $0x78,%al
  800fb3:	75 0d                	jne    800fc2 <strtol+0x78>
		s += 2, base = 16;
  800fb5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fb9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc0:	eb 28                	jmp    800fea <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc6:	75 15                	jne    800fdd <strtol+0x93>
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3c 30                	cmp    $0x30,%al
  800fcf:	75 0c                	jne    800fdd <strtol+0x93>
		s++, base = 8;
  800fd1:	ff 45 08             	incl   0x8(%ebp)
  800fd4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fdb:	eb 0d                	jmp    800fea <strtol+0xa0>
	else if (base == 0)
  800fdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe1:	75 07                	jne    800fea <strtol+0xa0>
		base = 10;
  800fe3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	3c 2f                	cmp    $0x2f,%al
  800ff1:	7e 19                	jle    80100c <strtol+0xc2>
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	3c 39                	cmp    $0x39,%al
  800ffa:	7f 10                	jg     80100c <strtol+0xc2>
			dig = *s - '0';
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	0f be c0             	movsbl %al,%eax
  801004:	83 e8 30             	sub    $0x30,%eax
  801007:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100a:	eb 42                	jmp    80104e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	3c 60                	cmp    $0x60,%al
  801013:	7e 19                	jle    80102e <strtol+0xe4>
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	3c 7a                	cmp    $0x7a,%al
  80101c:	7f 10                	jg     80102e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	0f be c0             	movsbl %al,%eax
  801026:	83 e8 57             	sub    $0x57,%eax
  801029:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102c:	eb 20                	jmp    80104e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	3c 40                	cmp    $0x40,%al
  801035:	7e 39                	jle    801070 <strtol+0x126>
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	3c 5a                	cmp    $0x5a,%al
  80103e:	7f 30                	jg     801070 <strtol+0x126>
			dig = *s - 'A' + 10;
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f be c0             	movsbl %al,%eax
  801048:	83 e8 37             	sub    $0x37,%eax
  80104b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80104e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801051:	3b 45 10             	cmp    0x10(%ebp),%eax
  801054:	7d 19                	jge    80106f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801056:	ff 45 08             	incl   0x8(%ebp)
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801060:	89 c2                	mov    %eax,%edx
  801062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801065:	01 d0                	add    %edx,%eax
  801067:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80106a:	e9 7b ff ff ff       	jmp    800fea <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80106f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801070:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801074:	74 08                	je     80107e <strtol+0x134>
		*endptr = (char *) s;
  801076:	8b 45 0c             	mov    0xc(%ebp),%eax
  801079:	8b 55 08             	mov    0x8(%ebp),%edx
  80107c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80107e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801082:	74 07                	je     80108b <strtol+0x141>
  801084:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801087:	f7 d8                	neg    %eax
  801089:	eb 03                	jmp    80108e <strtol+0x144>
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108e:	c9                   	leave  
  80108f:	c3                   	ret    

00801090 <ltostr>:

void
ltostr(long value, char *str)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801096:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a8:	79 13                	jns    8010bd <ltostr+0x2d>
	{
		neg = 1;
  8010aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010ba:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c5:	99                   	cltd   
  8010c6:	f7 f9                	idiv   %ecx
  8010c8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ce:	8d 50 01             	lea    0x1(%eax),%edx
  8010d1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d4:	89 c2                	mov    %eax,%edx
  8010d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d9:	01 d0                	add    %edx,%eax
  8010db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010de:	83 c2 30             	add    $0x30,%edx
  8010e1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010eb:	f7 e9                	imul   %ecx
  8010ed:	c1 fa 02             	sar    $0x2,%edx
  8010f0:	89 c8                	mov    %ecx,%eax
  8010f2:	c1 f8 1f             	sar    $0x1f,%eax
  8010f5:	29 c2                	sub    %eax,%edx
  8010f7:	89 d0                	mov    %edx,%eax
  8010f9:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ff:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801104:	f7 e9                	imul   %ecx
  801106:	c1 fa 02             	sar    $0x2,%edx
  801109:	89 c8                	mov    %ecx,%eax
  80110b:	c1 f8 1f             	sar    $0x1f,%eax
  80110e:	29 c2                	sub    %eax,%edx
  801110:	89 d0                	mov    %edx,%eax
  801112:	c1 e0 02             	shl    $0x2,%eax
  801115:	01 d0                	add    %edx,%eax
  801117:	01 c0                	add    %eax,%eax
  801119:	29 c1                	sub    %eax,%ecx
  80111b:	89 ca                	mov    %ecx,%edx
  80111d:	85 d2                	test   %edx,%edx
  80111f:	75 9c                	jne    8010bd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801121:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801128:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112b:	48                   	dec    %eax
  80112c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80112f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801133:	74 3d                	je     801172 <ltostr+0xe2>
		start = 1 ;
  801135:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113c:	eb 34                	jmp    801172 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80113e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	01 d0                	add    %edx,%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80114b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801151:	01 c2                	add    %eax,%edx
  801153:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801156:	8b 45 0c             	mov    0xc(%ebp),%eax
  801159:	01 c8                	add    %ecx,%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80115f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	01 c2                	add    %eax,%edx
  801167:	8a 45 eb             	mov    -0x15(%ebp),%al
  80116a:	88 02                	mov    %al,(%edx)
		start++ ;
  80116c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80116f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801175:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801178:	7c c4                	jl     80113e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80117a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	01 d0                	add    %edx,%eax
  801182:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801185:	90                   	nop
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80118e:	ff 75 08             	pushl  0x8(%ebp)
  801191:	e8 54 fa ff ff       	call   800bea <strlen>
  801196:	83 c4 04             	add    $0x4,%esp
  801199:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119c:	ff 75 0c             	pushl  0xc(%ebp)
  80119f:	e8 46 fa ff ff       	call   800bea <strlen>
  8011a4:	83 c4 04             	add    $0x4,%esp
  8011a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b8:	eb 17                	jmp    8011d1 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c0:	01 c2                	add    %eax,%edx
  8011c2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c8:	01 c8                	add    %ecx,%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011ce:	ff 45 fc             	incl   -0x4(%ebp)
  8011d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d7:	7c e1                	jl     8011ba <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e7:	eb 1f                	jmp    801208 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ec:	8d 50 01             	lea    0x1(%eax),%edx
  8011ef:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f2:	89 c2                	mov    %eax,%edx
  8011f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f7:	01 c2                	add    %eax,%edx
  8011f9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ff:	01 c8                	add    %ecx,%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801205:	ff 45 f8             	incl   -0x8(%ebp)
  801208:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120e:	7c d9                	jl     8011e9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801210:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801213:	8b 45 10             	mov    0x10(%ebp),%eax
  801216:	01 d0                	add    %edx,%eax
  801218:	c6 00 00             	movb   $0x0,(%eax)
}
  80121b:	90                   	nop
  80121c:	c9                   	leave  
  80121d:	c3                   	ret    

0080121e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801221:	8b 45 14             	mov    0x14(%ebp),%eax
  801224:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80122a:	8b 45 14             	mov    0x14(%ebp),%eax
  80122d:	8b 00                	mov    (%eax),%eax
  80122f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801236:	8b 45 10             	mov    0x10(%ebp),%eax
  801239:	01 d0                	add    %edx,%eax
  80123b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801241:	eb 0c                	jmp    80124f <strsplit+0x31>
			*string++ = 0;
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8d 50 01             	lea    0x1(%eax),%edx
  801249:	89 55 08             	mov    %edx,0x8(%ebp)
  80124c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	84 c0                	test   %al,%al
  801256:	74 18                	je     801270 <strsplit+0x52>
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	0f be c0             	movsbl %al,%eax
  801260:	50                   	push   %eax
  801261:	ff 75 0c             	pushl  0xc(%ebp)
  801264:	e8 13 fb ff ff       	call   800d7c <strchr>
  801269:	83 c4 08             	add    $0x8,%esp
  80126c:	85 c0                	test   %eax,%eax
  80126e:	75 d3                	jne    801243 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	84 c0                	test   %al,%al
  801277:	74 5a                	je     8012d3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801279:	8b 45 14             	mov    0x14(%ebp),%eax
  80127c:	8b 00                	mov    (%eax),%eax
  80127e:	83 f8 0f             	cmp    $0xf,%eax
  801281:	75 07                	jne    80128a <strsplit+0x6c>
		{
			return 0;
  801283:	b8 00 00 00 00       	mov    $0x0,%eax
  801288:	eb 66                	jmp    8012f0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80128a:	8b 45 14             	mov    0x14(%ebp),%eax
  80128d:	8b 00                	mov    (%eax),%eax
  80128f:	8d 48 01             	lea    0x1(%eax),%ecx
  801292:	8b 55 14             	mov    0x14(%ebp),%edx
  801295:	89 0a                	mov    %ecx,(%edx)
  801297:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129e:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a1:	01 c2                	add    %eax,%edx
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012a8:	eb 03                	jmp    8012ad <strsplit+0x8f>
			string++;
  8012aa:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	84 c0                	test   %al,%al
  8012b4:	74 8b                	je     801241 <strsplit+0x23>
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	0f be c0             	movsbl %al,%eax
  8012be:	50                   	push   %eax
  8012bf:	ff 75 0c             	pushl  0xc(%ebp)
  8012c2:	e8 b5 fa ff ff       	call   800d7c <strchr>
  8012c7:	83 c4 08             	add    $0x8,%esp
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	74 dc                	je     8012aa <strsplit+0x8c>
			string++;
	}
  8012ce:	e9 6e ff ff ff       	jmp    801241 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d7:	8b 00                	mov    (%eax),%eax
  8012d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e3:	01 d0                	add    %edx,%eax
  8012e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012eb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8012f8:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8012ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801302:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801305:	01 d0                	add    %edx,%eax
  801307:	48                   	dec    %eax
  801308:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80130b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80130e:	ba 00 00 00 00       	mov    $0x0,%edx
  801313:	f7 75 ac             	divl   -0x54(%ebp)
  801316:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801319:	29 d0                	sub    %edx,%eax
  80131b:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  80131e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801325:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  80132c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801333:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80133a:	eb 3f                	jmp    80137b <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  80133c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80133f:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801346:	83 ec 04             	sub    $0x4,%esp
  801349:	50                   	push   %eax
  80134a:	ff 75 e8             	pushl  -0x18(%ebp)
  80134d:	68 30 2a 80 00       	push   $0x802a30
  801352:	e8 11 f2 ff ff       	call   800568 <cprintf>
  801357:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  80135a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80135d:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801364:	83 ec 04             	sub    $0x4,%esp
  801367:	50                   	push   %eax
  801368:	ff 75 e8             	pushl  -0x18(%ebp)
  80136b:	68 45 2a 80 00       	push   $0x802a45
  801370:	e8 f3 f1 ff ff       	call   800568 <cprintf>
  801375:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801378:	ff 45 e8             	incl   -0x18(%ebp)
  80137b:	a1 28 30 80 00       	mov    0x803028,%eax
  801380:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801383:	7c b7                	jl     80133c <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801385:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  80138c:	e9 42 01 00 00       	jmp    8014d3 <malloc+0x1e1>
		int flag0=1;
  801391:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801398:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80139b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80139e:	eb 6b                	jmp    80140b <malloc+0x119>
			for(int k=0;k<count;k++){
  8013a0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8013a7:	eb 42                	jmp    8013eb <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8013a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013ac:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8013b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013b6:	39 c2                	cmp    %eax,%edx
  8013b8:	77 2e                	ja     8013e8 <malloc+0xf6>
  8013ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013bd:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8013c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013c7:	39 c2                	cmp    %eax,%edx
  8013c9:	76 1d                	jbe    8013e8 <malloc+0xf6>
					ni=arr_add[k].end-i;
  8013cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013ce:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8013d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d8:	29 c2                	sub    %eax,%edx
  8013da:	89 d0                	mov    %edx,%eax
  8013dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  8013df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8013e6:	eb 0d                	jmp    8013f5 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8013e8:	ff 45 d8             	incl   -0x28(%ebp)
  8013eb:	a1 28 30 80 00       	mov    0x803028,%eax
  8013f0:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8013f3:	7c b4                	jl     8013a9 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8013f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013f9:	74 09                	je     801404 <malloc+0x112>
				flag0=0;
  8013fb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801402:	eb 16                	jmp    80141a <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801404:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  80140b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	01 c2                	add    %eax,%edx
  801413:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801416:	39 c2                	cmp    %eax,%edx
  801418:	77 86                	ja     8013a0 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  80141a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80141e:	0f 84 a2 00 00 00    	je     8014c6 <malloc+0x1d4>

			int f=1;
  801424:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  80142b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80142e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801431:	89 c8                	mov    %ecx,%eax
  801433:	01 c0                	add    %eax,%eax
  801435:	01 c8                	add    %ecx,%eax
  801437:	c1 e0 02             	shl    $0x2,%eax
  80143a:	05 20 31 80 00       	add    $0x803120,%eax
  80143f:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801441:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80144a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144d:	89 d0                	mov    %edx,%eax
  80144f:	01 c0                	add    %eax,%eax
  801451:	01 d0                	add    %edx,%eax
  801453:	c1 e0 02             	shl    $0x2,%eax
  801456:	05 24 31 80 00       	add    $0x803124,%eax
  80145b:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  80145d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801460:	89 d0                	mov    %edx,%eax
  801462:	01 c0                	add    %eax,%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	c1 e0 02             	shl    $0x2,%eax
  801469:	05 28 31 80 00       	add    $0x803128,%eax
  80146e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801474:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801477:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80147e:	eb 36                	jmp    8014b6 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801480:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	01 c2                	add    %eax,%edx
  801488:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80148b:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801492:	39 c2                	cmp    %eax,%edx
  801494:	73 1d                	jae    8014b3 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801496:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801499:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8014a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014a3:	29 c2                	sub    %eax,%edx
  8014a5:	89 d0                	mov    %edx,%eax
  8014a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  8014aa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  8014b1:	eb 0d                	jmp    8014c0 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  8014b3:	ff 45 d0             	incl   -0x30(%ebp)
  8014b6:	a1 28 30 80 00       	mov    0x803028,%eax
  8014bb:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8014be:	7c c0                	jl     801480 <malloc+0x18e>
					break;

				}
			}

			if(f){
  8014c0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014c4:	75 1d                	jne    8014e3 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  8014c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8014cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014d0:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8014d3:	a1 04 30 80 00       	mov    0x803004,%eax
  8014d8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8014db:	0f 8c b0 fe ff ff    	jl     801391 <malloc+0x9f>
  8014e1:	eb 01                	jmp    8014e4 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  8014e3:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8014e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014e8:	75 7a                	jne    801564 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  8014ea:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	01 d0                	add    %edx,%eax
  8014f5:	48                   	dec    %eax
  8014f6:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8014fb:	7c 0a                	jl     801507 <malloc+0x215>
			return NULL;
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801502:	e9 a4 02 00 00       	jmp    8017ab <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801507:	a1 04 30 80 00       	mov    0x803004,%eax
  80150c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  80150f:	a1 28 30 80 00       	mov    0x803028,%eax
  801514:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801517:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  80151e:	83 ec 08             	sub    $0x8,%esp
  801521:	ff 75 08             	pushl  0x8(%ebp)
  801524:	ff 75 a4             	pushl  -0x5c(%ebp)
  801527:	e8 04 06 00 00       	call   801b30 <sys_allocateMem>
  80152c:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  80152f:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	01 d0                	add    %edx,%eax
  80153a:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  80153f:	a1 28 30 80 00       	mov    0x803028,%eax
  801544:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80154a:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  801551:	a1 28 30 80 00       	mov    0x803028,%eax
  801556:	40                   	inc    %eax
  801557:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  80155c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80155f:	e9 47 02 00 00       	jmp    8017ab <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801564:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80156b:	e9 ac 00 00 00       	jmp    80161c <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801570:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801573:	89 d0                	mov    %edx,%eax
  801575:	01 c0                	add    %eax,%eax
  801577:	01 d0                	add    %edx,%eax
  801579:	c1 e0 02             	shl    $0x2,%eax
  80157c:	05 24 31 80 00       	add    $0x803124,%eax
  801581:	8b 00                	mov    (%eax),%eax
  801583:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801586:	eb 7e                	jmp    801606 <malloc+0x314>
			int flag=0;
  801588:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  80158f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801596:	eb 57                	jmp    8015ef <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801598:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80159b:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8015a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8015a5:	39 c2                	cmp    %eax,%edx
  8015a7:	77 1a                	ja     8015c3 <malloc+0x2d1>
  8015a9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015ac:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8015b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8015b6:	39 c2                	cmp    %eax,%edx
  8015b8:	76 09                	jbe    8015c3 <malloc+0x2d1>
								flag=1;
  8015ba:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  8015c1:	eb 36                	jmp    8015f9 <malloc+0x307>
			arr[i].space++;
  8015c3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8015c6:	89 d0                	mov    %edx,%eax
  8015c8:	01 c0                	add    %eax,%eax
  8015ca:	01 d0                	add    %edx,%eax
  8015cc:	c1 e0 02             	shl    $0x2,%eax
  8015cf:	05 28 31 80 00       	add    $0x803128,%eax
  8015d4:	8b 00                	mov    (%eax),%eax
  8015d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8015d9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8015dc:	89 d0                	mov    %edx,%eax
  8015de:	01 c0                	add    %eax,%eax
  8015e0:	01 d0                	add    %edx,%eax
  8015e2:	c1 e0 02             	shl    $0x2,%eax
  8015e5:	05 28 31 80 00       	add    $0x803128,%eax
  8015ea:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  8015ec:	ff 45 c0             	incl   -0x40(%ebp)
  8015ef:	a1 28 30 80 00       	mov    0x803028,%eax
  8015f4:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  8015f7:	7c 9f                	jl     801598 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  8015f9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8015fd:	75 19                	jne    801618 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8015ff:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801606:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801609:	a1 04 30 80 00       	mov    0x803004,%eax
  80160e:	39 c2                	cmp    %eax,%edx
  801610:	0f 82 72 ff ff ff    	jb     801588 <malloc+0x296>
  801616:	eb 01                	jmp    801619 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801618:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801619:	ff 45 cc             	incl   -0x34(%ebp)
  80161c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80161f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801622:	0f 8c 48 ff ff ff    	jl     801570 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801628:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  80162f:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801636:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  80163d:	eb 37                	jmp    801676 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  80163f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801642:	89 d0                	mov    %edx,%eax
  801644:	01 c0                	add    %eax,%eax
  801646:	01 d0                	add    %edx,%eax
  801648:	c1 e0 02             	shl    $0x2,%eax
  80164b:	05 28 31 80 00       	add    $0x803128,%eax
  801650:	8b 00                	mov    (%eax),%eax
  801652:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801655:	7d 1c                	jge    801673 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801657:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80165a:	89 d0                	mov    %edx,%eax
  80165c:	01 c0                	add    %eax,%eax
  80165e:	01 d0                	add    %edx,%eax
  801660:	c1 e0 02             	shl    $0x2,%eax
  801663:	05 28 31 80 00       	add    $0x803128,%eax
  801668:	8b 00                	mov    (%eax),%eax
  80166a:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  80166d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801670:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801673:	ff 45 b4             	incl   -0x4c(%ebp)
  801676:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801679:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80167c:	7c c1                	jl     80163f <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  80167e:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801684:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801687:	89 c8                	mov    %ecx,%eax
  801689:	01 c0                	add    %eax,%eax
  80168b:	01 c8                	add    %ecx,%eax
  80168d:	c1 e0 02             	shl    $0x2,%eax
  801690:	05 20 31 80 00       	add    $0x803120,%eax
  801695:	8b 00                	mov    (%eax),%eax
  801697:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  80169e:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8016a4:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8016a7:	89 c8                	mov    %ecx,%eax
  8016a9:	01 c0                	add    %eax,%eax
  8016ab:	01 c8                	add    %ecx,%eax
  8016ad:	c1 e0 02             	shl    $0x2,%eax
  8016b0:	05 24 31 80 00       	add    $0x803124,%eax
  8016b5:	8b 00                	mov    (%eax),%eax
  8016b7:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  8016be:	a1 28 30 80 00       	mov    0x803028,%eax
  8016c3:	40                   	inc    %eax
  8016c4:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  8016c9:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8016cc:	89 d0                	mov    %edx,%eax
  8016ce:	01 c0                	add    %eax,%eax
  8016d0:	01 d0                	add    %edx,%eax
  8016d2:	c1 e0 02             	shl    $0x2,%eax
  8016d5:	05 20 31 80 00       	add    $0x803120,%eax
  8016da:	8b 00                	mov    (%eax),%eax
  8016dc:	83 ec 08             	sub    $0x8,%esp
  8016df:	ff 75 08             	pushl  0x8(%ebp)
  8016e2:	50                   	push   %eax
  8016e3:	e8 48 04 00 00       	call   801b30 <sys_allocateMem>
  8016e8:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  8016eb:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8016f2:	eb 78                	jmp    80176c <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8016f4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8016f7:	89 d0                	mov    %edx,%eax
  8016f9:	01 c0                	add    %eax,%eax
  8016fb:	01 d0                	add    %edx,%eax
  8016fd:	c1 e0 02             	shl    $0x2,%eax
  801700:	05 20 31 80 00       	add    $0x803120,%eax
  801705:	8b 00                	mov    (%eax),%eax
  801707:	83 ec 04             	sub    $0x4,%esp
  80170a:	50                   	push   %eax
  80170b:	ff 75 b0             	pushl  -0x50(%ebp)
  80170e:	68 30 2a 80 00       	push   $0x802a30
  801713:	e8 50 ee ff ff       	call   800568 <cprintf>
  801718:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  80171b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80171e:	89 d0                	mov    %edx,%eax
  801720:	01 c0                	add    %eax,%eax
  801722:	01 d0                	add    %edx,%eax
  801724:	c1 e0 02             	shl    $0x2,%eax
  801727:	05 24 31 80 00       	add    $0x803124,%eax
  80172c:	8b 00                	mov    (%eax),%eax
  80172e:	83 ec 04             	sub    $0x4,%esp
  801731:	50                   	push   %eax
  801732:	ff 75 b0             	pushl  -0x50(%ebp)
  801735:	68 45 2a 80 00       	push   $0x802a45
  80173a:	e8 29 ee ff ff       	call   800568 <cprintf>
  80173f:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801742:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801745:	89 d0                	mov    %edx,%eax
  801747:	01 c0                	add    %eax,%eax
  801749:	01 d0                	add    %edx,%eax
  80174b:	c1 e0 02             	shl    $0x2,%eax
  80174e:	05 28 31 80 00       	add    $0x803128,%eax
  801753:	8b 00                	mov    (%eax),%eax
  801755:	83 ec 04             	sub    $0x4,%esp
  801758:	50                   	push   %eax
  801759:	ff 75 b0             	pushl  -0x50(%ebp)
  80175c:	68 58 2a 80 00       	push   $0x802a58
  801761:	e8 02 ee ff ff       	call   800568 <cprintf>
  801766:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801769:	ff 45 b0             	incl   -0x50(%ebp)
  80176c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80176f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801772:	7c 80                	jl     8016f4 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801774:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801777:	89 d0                	mov    %edx,%eax
  801779:	01 c0                	add    %eax,%eax
  80177b:	01 d0                	add    %edx,%eax
  80177d:	c1 e0 02             	shl    $0x2,%eax
  801780:	05 20 31 80 00       	add    $0x803120,%eax
  801785:	8b 00                	mov    (%eax),%eax
  801787:	83 ec 08             	sub    $0x8,%esp
  80178a:	50                   	push   %eax
  80178b:	68 6c 2a 80 00       	push   $0x802a6c
  801790:	e8 d3 ed ff ff       	call   800568 <cprintf>
  801795:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801798:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80179b:	89 d0                	mov    %edx,%eax
  80179d:	01 c0                	add    %eax,%eax
  80179f:	01 d0                	add    %edx,%eax
  8017a1:	c1 e0 02             	shl    $0x2,%eax
  8017a4:	05 20 31 80 00       	add    $0x803120,%eax
  8017a9:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  8017b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8017c0:	eb 4b                	jmp    80180d <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  8017c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c5:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8017cc:	89 c2                	mov    %eax,%edx
  8017ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017d1:	39 c2                	cmp    %eax,%edx
  8017d3:	7f 35                	jg     80180a <free+0x5d>
  8017d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d8:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8017df:	89 c2                	mov    %eax,%edx
  8017e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017e4:	39 c2                	cmp    %eax,%edx
  8017e6:	7e 22                	jle    80180a <free+0x5d>
				start=arr_add[i].start;
  8017e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017eb:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8017f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8017f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f8:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8017ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801802:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801805:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801808:	eb 0d                	jmp    801817 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  80180a:	ff 45 ec             	incl   -0x14(%ebp)
  80180d:	a1 28 30 80 00       	mov    0x803028,%eax
  801812:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801815:	7c ab                	jl     8017c2 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181a:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801824:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80182b:	29 c2                	sub    %eax,%edx
  80182d:	89 d0                	mov    %edx,%eax
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	50                   	push   %eax
  801833:	ff 75 f4             	pushl  -0xc(%ebp)
  801836:	e8 d9 02 00 00       	call   801b14 <sys_freeMem>
  80183b:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  80183e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801841:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801844:	eb 2d                	jmp    801873 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801846:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801849:	40                   	inc    %eax
  80184a:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801851:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801854:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  80185b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80185e:	40                   	inc    %eax
  80185f:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801866:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801869:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801870:	ff 45 e8             	incl   -0x18(%ebp)
  801873:	a1 28 30 80 00       	mov    0x803028,%eax
  801878:	48                   	dec    %eax
  801879:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80187c:	7f c8                	jg     801846 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  80187e:	a1 28 30 80 00       	mov    0x803028,%eax
  801883:	48                   	dec    %eax
  801884:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801889:	90                   	nop
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	83 ec 18             	sub    $0x18,%esp
  801892:	8b 45 10             	mov    0x10(%ebp),%eax
  801895:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801898:	83 ec 04             	sub    $0x4,%esp
  80189b:	68 88 2a 80 00       	push   $0x802a88
  8018a0:	68 18 01 00 00       	push   $0x118
  8018a5:	68 ab 2a 80 00       	push   $0x802aab
  8018aa:	e8 17 ea ff ff       	call   8002c6 <_panic>

008018af <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018b5:	83 ec 04             	sub    $0x4,%esp
  8018b8:	68 88 2a 80 00       	push   $0x802a88
  8018bd:	68 1e 01 00 00       	push   $0x11e
  8018c2:	68 ab 2a 80 00       	push   $0x802aab
  8018c7:	e8 fa e9 ff ff       	call   8002c6 <_panic>

008018cc <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018d2:	83 ec 04             	sub    $0x4,%esp
  8018d5:	68 88 2a 80 00       	push   $0x802a88
  8018da:	68 24 01 00 00       	push   $0x124
  8018df:	68 ab 2a 80 00       	push   $0x802aab
  8018e4:	e8 dd e9 ff ff       	call   8002c6 <_panic>

008018e9 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018ef:	83 ec 04             	sub    $0x4,%esp
  8018f2:	68 88 2a 80 00       	push   $0x802a88
  8018f7:	68 29 01 00 00       	push   $0x129
  8018fc:	68 ab 2a 80 00       	push   $0x802aab
  801901:	e8 c0 e9 ff ff       	call   8002c6 <_panic>

00801906 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80190c:	83 ec 04             	sub    $0x4,%esp
  80190f:	68 88 2a 80 00       	push   $0x802a88
  801914:	68 2f 01 00 00       	push   $0x12f
  801919:	68 ab 2a 80 00       	push   $0x802aab
  80191e:	e8 a3 e9 ff ff       	call   8002c6 <_panic>

00801923 <shrink>:
}
void shrink(uint32 newSize)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	68 88 2a 80 00       	push   $0x802a88
  801931:	68 33 01 00 00       	push   $0x133
  801936:	68 ab 2a 80 00       	push   $0x802aab
  80193b:	e8 86 e9 ff ff       	call   8002c6 <_panic>

00801940 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801946:	83 ec 04             	sub    $0x4,%esp
  801949:	68 88 2a 80 00       	push   $0x802a88
  80194e:	68 38 01 00 00       	push   $0x138
  801953:	68 ab 2a 80 00       	push   $0x802aab
  801958:	e8 69 e9 ff ff       	call   8002c6 <_panic>

0080195d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	57                   	push   %edi
  801961:	56                   	push   %esi
  801962:	53                   	push   %ebx
  801963:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801972:	8b 7d 18             	mov    0x18(%ebp),%edi
  801975:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801978:	cd 30                	int    $0x30
  80197a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80197d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801980:	83 c4 10             	add    $0x10,%esp
  801983:	5b                   	pop    %ebx
  801984:	5e                   	pop    %esi
  801985:	5f                   	pop    %edi
  801986:	5d                   	pop    %ebp
  801987:	c3                   	ret    

00801988 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	83 ec 04             	sub    $0x4,%esp
  80198e:	8b 45 10             	mov    0x10(%ebp),%eax
  801991:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801994:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	52                   	push   %edx
  8019a0:	ff 75 0c             	pushl  0xc(%ebp)
  8019a3:	50                   	push   %eax
  8019a4:	6a 00                	push   $0x0
  8019a6:	e8 b2 ff ff ff       	call   80195d <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	90                   	nop
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 01                	push   $0x1
  8019c0:	e8 98 ff ff ff       	call   80195d <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	50                   	push   %eax
  8019d9:	6a 05                	push   $0x5
  8019db:	e8 7d ff ff ff       	call   80195d <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 02                	push   $0x2
  8019f4:	e8 64 ff ff ff       	call   80195d <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 03                	push   $0x3
  801a0d:	e8 4b ff ff ff       	call   80195d <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 04                	push   $0x4
  801a26:	e8 32 ff ff ff       	call   80195d <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_env_exit>:


void sys_env_exit(void)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 06                	push   $0x6
  801a3f:	e8 19 ff ff ff       	call   80195d <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	90                   	nop
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	52                   	push   %edx
  801a5a:	50                   	push   %eax
  801a5b:	6a 07                	push   $0x7
  801a5d:	e8 fb fe ff ff       	call   80195d <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a6c:	8b 75 18             	mov    0x18(%ebp),%esi
  801a6f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a72:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	56                   	push   %esi
  801a7c:	53                   	push   %ebx
  801a7d:	51                   	push   %ecx
  801a7e:	52                   	push   %edx
  801a7f:	50                   	push   %eax
  801a80:	6a 08                	push   $0x8
  801a82:	e8 d6 fe ff ff       	call   80195d <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8d:	5b                   	pop    %ebx
  801a8e:	5e                   	pop    %esi
  801a8f:	5d                   	pop    %ebp
  801a90:	c3                   	ret    

00801a91 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	52                   	push   %edx
  801aa1:	50                   	push   %eax
  801aa2:	6a 09                	push   $0x9
  801aa4:	e8 b4 fe ff ff       	call   80195d <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	ff 75 0c             	pushl  0xc(%ebp)
  801aba:	ff 75 08             	pushl  0x8(%ebp)
  801abd:	6a 0a                	push   $0xa
  801abf:	e8 99 fe ff ff       	call   80195d <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 0b                	push   $0xb
  801ad8:	e8 80 fe ff ff       	call   80195d <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 0c                	push   $0xc
  801af1:	e8 67 fe ff ff       	call   80195d <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 0d                	push   $0xd
  801b0a:	e8 4e fe ff ff       	call   80195d <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	ff 75 08             	pushl  0x8(%ebp)
  801b23:	6a 11                	push   $0x11
  801b25:	e8 33 fe ff ff       	call   80195d <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
	return;
  801b2d:	90                   	nop
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	ff 75 0c             	pushl  0xc(%ebp)
  801b3c:	ff 75 08             	pushl  0x8(%ebp)
  801b3f:	6a 12                	push   $0x12
  801b41:	e8 17 fe ff ff       	call   80195d <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
	return ;
  801b49:	90                   	nop
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 0e                	push   $0xe
  801b5b:	e8 fd fd ff ff       	call   80195d <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	ff 75 08             	pushl  0x8(%ebp)
  801b73:	6a 0f                	push   $0xf
  801b75:	e8 e3 fd ff ff       	call   80195d <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 10                	push   $0x10
  801b8e:	e8 ca fd ff ff       	call   80195d <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
}
  801b96:	90                   	nop
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 14                	push   $0x14
  801ba8:	e8 b0 fd ff ff       	call   80195d <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
}
  801bb0:	90                   	nop
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 15                	push   $0x15
  801bc2:	e8 96 fd ff ff       	call   80195d <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	90                   	nop
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_cputc>:


void
sys_cputc(const char c)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	83 ec 04             	sub    $0x4,%esp
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bd9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	50                   	push   %eax
  801be6:	6a 16                	push   $0x16
  801be8:	e8 70 fd ff ff       	call   80195d <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	90                   	nop
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 17                	push   $0x17
  801c02:	e8 56 fd ff ff       	call   80195d <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
}
  801c0a:	90                   	nop
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	ff 75 0c             	pushl  0xc(%ebp)
  801c1c:	50                   	push   %eax
  801c1d:	6a 18                	push   $0x18
  801c1f:	e8 39 fd ff ff       	call   80195d <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	52                   	push   %edx
  801c39:	50                   	push   %eax
  801c3a:	6a 1b                	push   $0x1b
  801c3c:	e8 1c fd ff ff       	call   80195d <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	52                   	push   %edx
  801c56:	50                   	push   %eax
  801c57:	6a 19                	push   $0x19
  801c59:	e8 ff fc ff ff       	call   80195d <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	90                   	nop
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	52                   	push   %edx
  801c74:	50                   	push   %eax
  801c75:	6a 1a                	push   $0x1a
  801c77:	e8 e1 fc ff ff       	call   80195d <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	90                   	nop
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 04             	sub    $0x4,%esp
  801c88:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c91:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	6a 00                	push   $0x0
  801c9a:	51                   	push   %ecx
  801c9b:	52                   	push   %edx
  801c9c:	ff 75 0c             	pushl  0xc(%ebp)
  801c9f:	50                   	push   %eax
  801ca0:	6a 1c                	push   $0x1c
  801ca2:	e8 b6 fc ff ff       	call   80195d <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801caf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	52                   	push   %edx
  801cbc:	50                   	push   %eax
  801cbd:	6a 1d                	push   $0x1d
  801cbf:	e8 99 fc ff ff       	call   80195d <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ccc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	51                   	push   %ecx
  801cda:	52                   	push   %edx
  801cdb:	50                   	push   %eax
  801cdc:	6a 1e                	push   $0x1e
  801cde:	e8 7a fc ff ff       	call   80195d <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	52                   	push   %edx
  801cf8:	50                   	push   %eax
  801cf9:	6a 1f                	push   $0x1f
  801cfb:	e8 5d fc ff ff       	call   80195d <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 20                	push   $0x20
  801d14:	e8 44 fc ff ff       	call   80195d <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	6a 00                	push   $0x0
  801d26:	ff 75 14             	pushl  0x14(%ebp)
  801d29:	ff 75 10             	pushl  0x10(%ebp)
  801d2c:	ff 75 0c             	pushl  0xc(%ebp)
  801d2f:	50                   	push   %eax
  801d30:	6a 21                	push   $0x21
  801d32:	e8 26 fc ff ff       	call   80195d <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	50                   	push   %eax
  801d4b:	6a 22                	push   $0x22
  801d4d:	e8 0b fc ff ff       	call   80195d <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	90                   	nop
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	50                   	push   %eax
  801d67:	6a 23                	push   $0x23
  801d69:	e8 ef fb ff ff       	call   80195d <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
}
  801d71:	90                   	nop
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d7a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d7d:	8d 50 04             	lea    0x4(%eax),%edx
  801d80:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	52                   	push   %edx
  801d8a:	50                   	push   %eax
  801d8b:	6a 24                	push   $0x24
  801d8d:	e8 cb fb ff ff       	call   80195d <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
	return result;
  801d95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d9b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d9e:	89 01                	mov    %eax,(%ecx)
  801da0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	c9                   	leave  
  801da7:	c2 04 00             	ret    $0x4

00801daa <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	ff 75 10             	pushl  0x10(%ebp)
  801db4:	ff 75 0c             	pushl  0xc(%ebp)
  801db7:	ff 75 08             	pushl  0x8(%ebp)
  801dba:	6a 13                	push   $0x13
  801dbc:	e8 9c fb ff ff       	call   80195d <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc4:	90                   	nop
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 25                	push   $0x25
  801dd6:	e8 82 fb ff ff       	call   80195d <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 04             	sub    $0x4,%esp
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dec:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	50                   	push   %eax
  801df9:	6a 26                	push   $0x26
  801dfb:	e8 5d fb ff ff       	call   80195d <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
	return ;
  801e03:	90                   	nop
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <rsttst>:
void rsttst()
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 28                	push   $0x28
  801e15:	e8 43 fb ff ff       	call   80195d <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1d:	90                   	nop
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 04             	sub    $0x4,%esp
  801e26:	8b 45 14             	mov    0x14(%ebp),%eax
  801e29:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e2c:	8b 55 18             	mov    0x18(%ebp),%edx
  801e2f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e33:	52                   	push   %edx
  801e34:	50                   	push   %eax
  801e35:	ff 75 10             	pushl  0x10(%ebp)
  801e38:	ff 75 0c             	pushl  0xc(%ebp)
  801e3b:	ff 75 08             	pushl  0x8(%ebp)
  801e3e:	6a 27                	push   $0x27
  801e40:	e8 18 fb ff ff       	call   80195d <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
	return ;
  801e48:	90                   	nop
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <chktst>:
void chktst(uint32 n)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	ff 75 08             	pushl  0x8(%ebp)
  801e59:	6a 29                	push   $0x29
  801e5b:	e8 fd fa ff ff       	call   80195d <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
	return ;
  801e63:	90                   	nop
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <inctst>:

void inctst()
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 2a                	push   $0x2a
  801e75:	e8 e3 fa ff ff       	call   80195d <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7d:	90                   	nop
}
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <gettst>:
uint32 gettst()
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 2b                	push   $0x2b
  801e8f:	e8 c9 fa ff ff       	call   80195d <syscall>
  801e94:	83 c4 18             	add    $0x18,%esp
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 2c                	push   $0x2c
  801eab:	e8 ad fa ff ff       	call   80195d <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
  801eb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801eb6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801eba:	75 07                	jne    801ec3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ebc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec1:	eb 05                	jmp    801ec8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ec3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 2c                	push   $0x2c
  801edc:	e8 7c fa ff ff       	call   80195d <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
  801ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ee7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801eeb:	75 07                	jne    801ef4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eed:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef2:	eb 05                	jmp    801ef9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ef4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 2c                	push   $0x2c
  801f0d:	e8 4b fa ff ff       	call   80195d <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
  801f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f18:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f1c:	75 07                	jne    801f25 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f23:	eb 05                	jmp    801f2a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 2c                	push   $0x2c
  801f3e:	e8 1a fa ff ff       	call   80195d <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
  801f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f49:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f4d:	75 07                	jne    801f56 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f4f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f54:	eb 05                	jmp    801f5b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	ff 75 08             	pushl  0x8(%ebp)
  801f6b:	6a 2d                	push   $0x2d
  801f6d:	e8 eb f9 ff ff       	call   80195d <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
	return ;
  801f75:	90                   	nop
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f7c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	6a 00                	push   $0x0
  801f8a:	53                   	push   %ebx
  801f8b:	51                   	push   %ecx
  801f8c:	52                   	push   %edx
  801f8d:	50                   	push   %eax
  801f8e:	6a 2e                	push   $0x2e
  801f90:	e8 c8 f9 ff ff       	call   80195d <syscall>
  801f95:	83 c4 18             	add    $0x18,%esp
}
  801f98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	52                   	push   %edx
  801fad:	50                   	push   %eax
  801fae:	6a 2f                	push   $0x2f
  801fb0:	e8 a8 f9 ff ff       	call   80195d <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801fc0:	8b 55 08             	mov    0x8(%ebp),%edx
  801fc3:	89 d0                	mov    %edx,%eax
  801fc5:	c1 e0 02             	shl    $0x2,%eax
  801fc8:	01 d0                	add    %edx,%eax
  801fca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fd1:	01 d0                	add    %edx,%eax
  801fd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fda:	01 d0                	add    %edx,%eax
  801fdc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fe3:	01 d0                	add    %edx,%eax
  801fe5:	c1 e0 04             	shl    $0x4,%eax
  801fe8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801feb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801ff2:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801ff5:	83 ec 0c             	sub    $0xc,%esp
  801ff8:	50                   	push   %eax
  801ff9:	e8 76 fd ff ff       	call   801d74 <sys_get_virtual_time>
  801ffe:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802001:	eb 41                	jmp    802044 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802003:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802006:	83 ec 0c             	sub    $0xc,%esp
  802009:	50                   	push   %eax
  80200a:	e8 65 fd ff ff       	call   801d74 <sys_get_virtual_time>
  80200f:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802012:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802015:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802018:	29 c2                	sub    %eax,%edx
  80201a:	89 d0                	mov    %edx,%eax
  80201c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80201f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802022:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802025:	89 d1                	mov    %edx,%ecx
  802027:	29 c1                	sub    %eax,%ecx
  802029:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80202c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80202f:	39 c2                	cmp    %eax,%edx
  802031:	0f 97 c0             	seta   %al
  802034:	0f b6 c0             	movzbl %al,%eax
  802037:	29 c1                	sub    %eax,%ecx
  802039:	89 c8                	mov    %ecx,%eax
  80203b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80203e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802041:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80204a:	72 b7                	jb     802003 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80204c:	90                   	nop
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802055:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80205c:	eb 03                	jmp    802061 <busy_wait+0x12>
  80205e:	ff 45 fc             	incl   -0x4(%ebp)
  802061:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802064:	3b 45 08             	cmp    0x8(%ebp),%eax
  802067:	72 f5                	jb     80205e <busy_wait+0xf>
	return i;
  802069:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    
  80206e:	66 90                	xchg   %ax,%ax

00802070 <__udivdi3>:
  802070:	55                   	push   %ebp
  802071:	57                   	push   %edi
  802072:	56                   	push   %esi
  802073:	53                   	push   %ebx
  802074:	83 ec 1c             	sub    $0x1c,%esp
  802077:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80207b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80207f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802083:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802087:	89 ca                	mov    %ecx,%edx
  802089:	89 f8                	mov    %edi,%eax
  80208b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80208f:	85 f6                	test   %esi,%esi
  802091:	75 2d                	jne    8020c0 <__udivdi3+0x50>
  802093:	39 cf                	cmp    %ecx,%edi
  802095:	77 65                	ja     8020fc <__udivdi3+0x8c>
  802097:	89 fd                	mov    %edi,%ebp
  802099:	85 ff                	test   %edi,%edi
  80209b:	75 0b                	jne    8020a8 <__udivdi3+0x38>
  80209d:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a2:	31 d2                	xor    %edx,%edx
  8020a4:	f7 f7                	div    %edi
  8020a6:	89 c5                	mov    %eax,%ebp
  8020a8:	31 d2                	xor    %edx,%edx
  8020aa:	89 c8                	mov    %ecx,%eax
  8020ac:	f7 f5                	div    %ebp
  8020ae:	89 c1                	mov    %eax,%ecx
  8020b0:	89 d8                	mov    %ebx,%eax
  8020b2:	f7 f5                	div    %ebp
  8020b4:	89 cf                	mov    %ecx,%edi
  8020b6:	89 fa                	mov    %edi,%edx
  8020b8:	83 c4 1c             	add    $0x1c,%esp
  8020bb:	5b                   	pop    %ebx
  8020bc:	5e                   	pop    %esi
  8020bd:	5f                   	pop    %edi
  8020be:	5d                   	pop    %ebp
  8020bf:	c3                   	ret    
  8020c0:	39 ce                	cmp    %ecx,%esi
  8020c2:	77 28                	ja     8020ec <__udivdi3+0x7c>
  8020c4:	0f bd fe             	bsr    %esi,%edi
  8020c7:	83 f7 1f             	xor    $0x1f,%edi
  8020ca:	75 40                	jne    80210c <__udivdi3+0x9c>
  8020cc:	39 ce                	cmp    %ecx,%esi
  8020ce:	72 0a                	jb     8020da <__udivdi3+0x6a>
  8020d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8020d4:	0f 87 9e 00 00 00    	ja     802178 <__udivdi3+0x108>
  8020da:	b8 01 00 00 00       	mov    $0x1,%eax
  8020df:	89 fa                	mov    %edi,%edx
  8020e1:	83 c4 1c             	add    $0x1c,%esp
  8020e4:	5b                   	pop    %ebx
  8020e5:	5e                   	pop    %esi
  8020e6:	5f                   	pop    %edi
  8020e7:	5d                   	pop    %ebp
  8020e8:	c3                   	ret    
  8020e9:	8d 76 00             	lea    0x0(%esi),%esi
  8020ec:	31 ff                	xor    %edi,%edi
  8020ee:	31 c0                	xor    %eax,%eax
  8020f0:	89 fa                	mov    %edi,%edx
  8020f2:	83 c4 1c             	add    $0x1c,%esp
  8020f5:	5b                   	pop    %ebx
  8020f6:	5e                   	pop    %esi
  8020f7:	5f                   	pop    %edi
  8020f8:	5d                   	pop    %ebp
  8020f9:	c3                   	ret    
  8020fa:	66 90                	xchg   %ax,%ax
  8020fc:	89 d8                	mov    %ebx,%eax
  8020fe:	f7 f7                	div    %edi
  802100:	31 ff                	xor    %edi,%edi
  802102:	89 fa                	mov    %edi,%edx
  802104:	83 c4 1c             	add    $0x1c,%esp
  802107:	5b                   	pop    %ebx
  802108:	5e                   	pop    %esi
  802109:	5f                   	pop    %edi
  80210a:	5d                   	pop    %ebp
  80210b:	c3                   	ret    
  80210c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802111:	89 eb                	mov    %ebp,%ebx
  802113:	29 fb                	sub    %edi,%ebx
  802115:	89 f9                	mov    %edi,%ecx
  802117:	d3 e6                	shl    %cl,%esi
  802119:	89 c5                	mov    %eax,%ebp
  80211b:	88 d9                	mov    %bl,%cl
  80211d:	d3 ed                	shr    %cl,%ebp
  80211f:	89 e9                	mov    %ebp,%ecx
  802121:	09 f1                	or     %esi,%ecx
  802123:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802127:	89 f9                	mov    %edi,%ecx
  802129:	d3 e0                	shl    %cl,%eax
  80212b:	89 c5                	mov    %eax,%ebp
  80212d:	89 d6                	mov    %edx,%esi
  80212f:	88 d9                	mov    %bl,%cl
  802131:	d3 ee                	shr    %cl,%esi
  802133:	89 f9                	mov    %edi,%ecx
  802135:	d3 e2                	shl    %cl,%edx
  802137:	8b 44 24 08          	mov    0x8(%esp),%eax
  80213b:	88 d9                	mov    %bl,%cl
  80213d:	d3 e8                	shr    %cl,%eax
  80213f:	09 c2                	or     %eax,%edx
  802141:	89 d0                	mov    %edx,%eax
  802143:	89 f2                	mov    %esi,%edx
  802145:	f7 74 24 0c          	divl   0xc(%esp)
  802149:	89 d6                	mov    %edx,%esi
  80214b:	89 c3                	mov    %eax,%ebx
  80214d:	f7 e5                	mul    %ebp
  80214f:	39 d6                	cmp    %edx,%esi
  802151:	72 19                	jb     80216c <__udivdi3+0xfc>
  802153:	74 0b                	je     802160 <__udivdi3+0xf0>
  802155:	89 d8                	mov    %ebx,%eax
  802157:	31 ff                	xor    %edi,%edi
  802159:	e9 58 ff ff ff       	jmp    8020b6 <__udivdi3+0x46>
  80215e:	66 90                	xchg   %ax,%ax
  802160:	8b 54 24 08          	mov    0x8(%esp),%edx
  802164:	89 f9                	mov    %edi,%ecx
  802166:	d3 e2                	shl    %cl,%edx
  802168:	39 c2                	cmp    %eax,%edx
  80216a:	73 e9                	jae    802155 <__udivdi3+0xe5>
  80216c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80216f:	31 ff                	xor    %edi,%edi
  802171:	e9 40 ff ff ff       	jmp    8020b6 <__udivdi3+0x46>
  802176:	66 90                	xchg   %ax,%ax
  802178:	31 c0                	xor    %eax,%eax
  80217a:	e9 37 ff ff ff       	jmp    8020b6 <__udivdi3+0x46>
  80217f:	90                   	nop

00802180 <__umoddi3>:
  802180:	55                   	push   %ebp
  802181:	57                   	push   %edi
  802182:	56                   	push   %esi
  802183:	53                   	push   %ebx
  802184:	83 ec 1c             	sub    $0x1c,%esp
  802187:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80218b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80218f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802193:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802197:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80219b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80219f:	89 f3                	mov    %esi,%ebx
  8021a1:	89 fa                	mov    %edi,%edx
  8021a3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021a7:	89 34 24             	mov    %esi,(%esp)
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	75 1a                	jne    8021c8 <__umoddi3+0x48>
  8021ae:	39 f7                	cmp    %esi,%edi
  8021b0:	0f 86 a2 00 00 00    	jbe    802258 <__umoddi3+0xd8>
  8021b6:	89 c8                	mov    %ecx,%eax
  8021b8:	89 f2                	mov    %esi,%edx
  8021ba:	f7 f7                	div    %edi
  8021bc:	89 d0                	mov    %edx,%eax
  8021be:	31 d2                	xor    %edx,%edx
  8021c0:	83 c4 1c             	add    $0x1c,%esp
  8021c3:	5b                   	pop    %ebx
  8021c4:	5e                   	pop    %esi
  8021c5:	5f                   	pop    %edi
  8021c6:	5d                   	pop    %ebp
  8021c7:	c3                   	ret    
  8021c8:	39 f0                	cmp    %esi,%eax
  8021ca:	0f 87 ac 00 00 00    	ja     80227c <__umoddi3+0xfc>
  8021d0:	0f bd e8             	bsr    %eax,%ebp
  8021d3:	83 f5 1f             	xor    $0x1f,%ebp
  8021d6:	0f 84 ac 00 00 00    	je     802288 <__umoddi3+0x108>
  8021dc:	bf 20 00 00 00       	mov    $0x20,%edi
  8021e1:	29 ef                	sub    %ebp,%edi
  8021e3:	89 fe                	mov    %edi,%esi
  8021e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021e9:	89 e9                	mov    %ebp,%ecx
  8021eb:	d3 e0                	shl    %cl,%eax
  8021ed:	89 d7                	mov    %edx,%edi
  8021ef:	89 f1                	mov    %esi,%ecx
  8021f1:	d3 ef                	shr    %cl,%edi
  8021f3:	09 c7                	or     %eax,%edi
  8021f5:	89 e9                	mov    %ebp,%ecx
  8021f7:	d3 e2                	shl    %cl,%edx
  8021f9:	89 14 24             	mov    %edx,(%esp)
  8021fc:	89 d8                	mov    %ebx,%eax
  8021fe:	d3 e0                	shl    %cl,%eax
  802200:	89 c2                	mov    %eax,%edx
  802202:	8b 44 24 08          	mov    0x8(%esp),%eax
  802206:	d3 e0                	shl    %cl,%eax
  802208:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802210:	89 f1                	mov    %esi,%ecx
  802212:	d3 e8                	shr    %cl,%eax
  802214:	09 d0                	or     %edx,%eax
  802216:	d3 eb                	shr    %cl,%ebx
  802218:	89 da                	mov    %ebx,%edx
  80221a:	f7 f7                	div    %edi
  80221c:	89 d3                	mov    %edx,%ebx
  80221e:	f7 24 24             	mull   (%esp)
  802221:	89 c6                	mov    %eax,%esi
  802223:	89 d1                	mov    %edx,%ecx
  802225:	39 d3                	cmp    %edx,%ebx
  802227:	0f 82 87 00 00 00    	jb     8022b4 <__umoddi3+0x134>
  80222d:	0f 84 91 00 00 00    	je     8022c4 <__umoddi3+0x144>
  802233:	8b 54 24 04          	mov    0x4(%esp),%edx
  802237:	29 f2                	sub    %esi,%edx
  802239:	19 cb                	sbb    %ecx,%ebx
  80223b:	89 d8                	mov    %ebx,%eax
  80223d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802241:	d3 e0                	shl    %cl,%eax
  802243:	89 e9                	mov    %ebp,%ecx
  802245:	d3 ea                	shr    %cl,%edx
  802247:	09 d0                	or     %edx,%eax
  802249:	89 e9                	mov    %ebp,%ecx
  80224b:	d3 eb                	shr    %cl,%ebx
  80224d:	89 da                	mov    %ebx,%edx
  80224f:	83 c4 1c             	add    $0x1c,%esp
  802252:	5b                   	pop    %ebx
  802253:	5e                   	pop    %esi
  802254:	5f                   	pop    %edi
  802255:	5d                   	pop    %ebp
  802256:	c3                   	ret    
  802257:	90                   	nop
  802258:	89 fd                	mov    %edi,%ebp
  80225a:	85 ff                	test   %edi,%edi
  80225c:	75 0b                	jne    802269 <__umoddi3+0xe9>
  80225e:	b8 01 00 00 00       	mov    $0x1,%eax
  802263:	31 d2                	xor    %edx,%edx
  802265:	f7 f7                	div    %edi
  802267:	89 c5                	mov    %eax,%ebp
  802269:	89 f0                	mov    %esi,%eax
  80226b:	31 d2                	xor    %edx,%edx
  80226d:	f7 f5                	div    %ebp
  80226f:	89 c8                	mov    %ecx,%eax
  802271:	f7 f5                	div    %ebp
  802273:	89 d0                	mov    %edx,%eax
  802275:	e9 44 ff ff ff       	jmp    8021be <__umoddi3+0x3e>
  80227a:	66 90                	xchg   %ax,%ax
  80227c:	89 c8                	mov    %ecx,%eax
  80227e:	89 f2                	mov    %esi,%edx
  802280:	83 c4 1c             	add    $0x1c,%esp
  802283:	5b                   	pop    %ebx
  802284:	5e                   	pop    %esi
  802285:	5f                   	pop    %edi
  802286:	5d                   	pop    %ebp
  802287:	c3                   	ret    
  802288:	3b 04 24             	cmp    (%esp),%eax
  80228b:	72 06                	jb     802293 <__umoddi3+0x113>
  80228d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802291:	77 0f                	ja     8022a2 <__umoddi3+0x122>
  802293:	89 f2                	mov    %esi,%edx
  802295:	29 f9                	sub    %edi,%ecx
  802297:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80229b:	89 14 24             	mov    %edx,(%esp)
  80229e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022a2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022a6:	8b 14 24             	mov    (%esp),%edx
  8022a9:	83 c4 1c             	add    $0x1c,%esp
  8022ac:	5b                   	pop    %ebx
  8022ad:	5e                   	pop    %esi
  8022ae:	5f                   	pop    %edi
  8022af:	5d                   	pop    %ebp
  8022b0:	c3                   	ret    
  8022b1:	8d 76 00             	lea    0x0(%esi),%esi
  8022b4:	2b 04 24             	sub    (%esp),%eax
  8022b7:	19 fa                	sbb    %edi,%edx
  8022b9:	89 d1                	mov    %edx,%ecx
  8022bb:	89 c6                	mov    %eax,%esi
  8022bd:	e9 71 ff ff ff       	jmp    802233 <__umoddi3+0xb3>
  8022c2:	66 90                	xchg   %ax,%ax
  8022c4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8022c8:	72 ea                	jb     8022b4 <__umoddi3+0x134>
  8022ca:	89 d9                	mov    %ebx,%ecx
  8022cc:	e9 62 ff ff ff       	jmp    802233 <__umoddi3+0xb3>
