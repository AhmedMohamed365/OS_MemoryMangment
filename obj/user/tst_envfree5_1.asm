
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 10 01 00 00       	call   800146 <libmain>
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
	// Testing scenario 5_1: Kill ONE program has shared variables and it free it
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 00 22 80 00       	push   $0x802200
  80004a:	e8 02 18 00 00       	call   801851 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 2b 1a 00 00       	call   801a8e <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 a6 1a 00 00       	call   801b11 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 10 22 80 00       	push   $0x802210
  800079:	e8 af 04 00 00       	call   80052d <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 30 80 00       	mov    0x803020,%eax
  800086:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 43 22 80 00       	push   $0x802243
  800099:	e8 45 1c 00 00       	call   801ce3 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 52 1c 00 00       	call   801d01 <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 cc 19 00 00       	call   801a8e <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 4c 22 80 00       	push   $0x80224c
  8000cb:	e8 5d 04 00 00       	call   80052d <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_free_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 3f 1c 00 00       	call   801d1d <sys_free_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 a8 19 00 00       	call   801a8e <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 23 1a 00 00       	call   801b11 <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 27                	je     800120 <_main+0xe8>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n", freeFrames_after);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ff:	68 80 22 80 00       	push   $0x802280
  800104:	e8 24 04 00 00       	call   80052d <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
		panic("env_free() does not work correctly... check it again.");
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 d0 22 80 00       	push   $0x8022d0
  800114:	6a 1e                	push   $0x1e
  800116:	68 06 23 80 00       	push   $0x802306
  80011b:	e8 6b 01 00 00       	call   80028b <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 e4             	pushl  -0x1c(%ebp)
  800126:	68 1c 23 80 00       	push   $0x80231c
  80012b:	e8 fd 03 00 00       	call   80052d <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 7c 23 80 00       	push   $0x80237c
  80013b:	e8 ed 03 00 00       	call   80052d <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
	return;
  800143:	90                   	nop
}
  800144:	c9                   	leave  
  800145:	c3                   	ret    

00800146 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80014c:	e8 72 18 00 00       	call   8019c3 <sys_getenvindex>
  800151:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800157:	89 d0                	mov    %edx,%eax
  800159:	c1 e0 03             	shl    $0x3,%eax
  80015c:	01 d0                	add    %edx,%eax
  80015e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800165:	01 c8                	add    %ecx,%eax
  800167:	01 c0                	add    %eax,%eax
  800169:	01 d0                	add    %edx,%eax
  80016b:	01 c0                	add    %eax,%eax
  80016d:	01 d0                	add    %edx,%eax
  80016f:	89 c2                	mov    %eax,%edx
  800171:	c1 e2 05             	shl    $0x5,%edx
  800174:	29 c2                	sub    %eax,%edx
  800176:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80017d:	89 c2                	mov    %eax,%edx
  80017f:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800185:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80018a:	a1 20 30 80 00       	mov    0x803020,%eax
  80018f:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800195:	84 c0                	test   %al,%al
  800197:	74 0f                	je     8001a8 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800199:	a1 20 30 80 00       	mov    0x803020,%eax
  80019e:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001a3:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ac:	7e 0a                	jle    8001b8 <libmain+0x72>
		binaryname = argv[0];
  8001ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b1:	8b 00                	mov    (%eax),%eax
  8001b3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	ff 75 0c             	pushl  0xc(%ebp)
  8001be:	ff 75 08             	pushl  0x8(%ebp)
  8001c1:	e8 72 fe ff ff       	call   800038 <_main>
  8001c6:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001c9:	e8 90 19 00 00       	call   801b5e <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	68 e0 23 80 00       	push   $0x8023e0
  8001d6:	e8 52 03 00 00       	call   80052d <cprintf>
  8001db:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001de:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e3:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8001e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ee:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8001f4:	83 ec 04             	sub    $0x4,%esp
  8001f7:	52                   	push   %edx
  8001f8:	50                   	push   %eax
  8001f9:	68 08 24 80 00       	push   $0x802408
  8001fe:	e8 2a 03 00 00       	call   80052d <cprintf>
  800203:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800206:	a1 20 30 80 00       	mov    0x803020,%eax
  80020b:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800211:	a1 20 30 80 00       	mov    0x803020,%eax
  800216:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	52                   	push   %edx
  800220:	50                   	push   %eax
  800221:	68 30 24 80 00       	push   $0x802430
  800226:	e8 02 03 00 00       	call   80052d <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80022e:	a1 20 30 80 00       	mov    0x803020,%eax
  800233:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	50                   	push   %eax
  80023d:	68 71 24 80 00       	push   $0x802471
  800242:	e8 e6 02 00 00       	call   80052d <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80024a:	83 ec 0c             	sub    $0xc,%esp
  80024d:	68 e0 23 80 00       	push   $0x8023e0
  800252:	e8 d6 02 00 00       	call   80052d <cprintf>
  800257:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80025a:	e8 19 19 00 00       	call   801b78 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80025f:	e8 19 00 00 00       	call   80027d <exit>
}
  800264:	90                   	nop
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80026d:	83 ec 0c             	sub    $0xc,%esp
  800270:	6a 00                	push   $0x0
  800272:	e8 18 17 00 00       	call   80198f <sys_env_destroy>
  800277:	83 c4 10             	add    $0x10,%esp
}
  80027a:	90                   	nop
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <exit>:

void
exit(void)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800283:	e8 6d 17 00 00       	call   8019f5 <sys_env_exit>
}
  800288:	90                   	nop
  800289:	c9                   	leave  
  80028a:	c3                   	ret    

0080028b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800291:	8d 45 10             	lea    0x10(%ebp),%eax
  800294:	83 c0 04             	add    $0x4,%eax
  800297:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80029a:	a1 18 31 80 00       	mov    0x803118,%eax
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	74 16                	je     8002b9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a3:	a1 18 31 80 00       	mov    0x803118,%eax
  8002a8:	83 ec 08             	sub    $0x8,%esp
  8002ab:	50                   	push   %eax
  8002ac:	68 88 24 80 00       	push   $0x802488
  8002b1:	e8 77 02 00 00       	call   80052d <cprintf>
  8002b6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b9:	a1 00 30 80 00       	mov    0x803000,%eax
  8002be:	ff 75 0c             	pushl  0xc(%ebp)
  8002c1:	ff 75 08             	pushl  0x8(%ebp)
  8002c4:	50                   	push   %eax
  8002c5:	68 8d 24 80 00       	push   $0x80248d
  8002ca:	e8 5e 02 00 00       	call   80052d <cprintf>
  8002cf:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d5:	83 ec 08             	sub    $0x8,%esp
  8002d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002db:	50                   	push   %eax
  8002dc:	e8 e1 01 00 00       	call   8004c2 <vcprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002e4:	83 ec 08             	sub    $0x8,%esp
  8002e7:	6a 00                	push   $0x0
  8002e9:	68 a9 24 80 00       	push   $0x8024a9
  8002ee:	e8 cf 01 00 00       	call   8004c2 <vcprintf>
  8002f3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002f6:	e8 82 ff ff ff       	call   80027d <exit>

	// should not return here
	while (1) ;
  8002fb:	eb fe                	jmp    8002fb <_panic+0x70>

008002fd <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800303:	a1 20 30 80 00       	mov    0x803020,%eax
  800308:	8b 50 74             	mov    0x74(%eax),%edx
  80030b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	74 14                	je     800326 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	68 ac 24 80 00       	push   $0x8024ac
  80031a:	6a 26                	push   $0x26
  80031c:	68 f8 24 80 00       	push   $0x8024f8
  800321:	e8 65 ff ff ff       	call   80028b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80032d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800334:	e9 b6 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
  800346:	01 d0                	add    %edx,%eax
  800348:	8b 00                	mov    (%eax),%eax
  80034a:	85 c0                	test   %eax,%eax
  80034c:	75 08                	jne    800356 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80034e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800351:	e9 96 00 00 00       	jmp    8003ec <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800356:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80035d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800364:	eb 5d                	jmp    8003c3 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800366:	a1 20 30 80 00       	mov    0x803020,%eax
  80036b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800371:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800374:	c1 e2 04             	shl    $0x4,%edx
  800377:	01 d0                	add    %edx,%eax
  800379:	8a 40 04             	mov    0x4(%eax),%al
  80037c:	84 c0                	test   %al,%al
  80037e:	75 40                	jne    8003c0 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800380:	a1 20 30 80 00       	mov    0x803020,%eax
  800385:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80038b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80038e:	c1 e2 04             	shl    $0x4,%edx
  800391:	01 d0                	add    %edx,%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800398:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	75 09                	jne    8003c0 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8003b7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003be:	eb 12                	jmp    8003d2 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c0:	ff 45 e8             	incl   -0x18(%ebp)
  8003c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c8:	8b 50 74             	mov    0x74(%eax),%edx
  8003cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ce:	39 c2                	cmp    %eax,%edx
  8003d0:	77 94                	ja     800366 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d6:	75 14                	jne    8003ec <CheckWSWithoutLastIndex+0xef>
			panic(
  8003d8:	83 ec 04             	sub    $0x4,%esp
  8003db:	68 04 25 80 00       	push   $0x802504
  8003e0:	6a 3a                	push   $0x3a
  8003e2:	68 f8 24 80 00       	push   $0x8024f8
  8003e7:	e8 9f fe ff ff       	call   80028b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ec:	ff 45 f0             	incl   -0x10(%ebp)
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f5:	0f 8c 3e ff ff ff    	jl     800339 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800402:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800409:	eb 20                	jmp    80042b <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040b:	a1 20 30 80 00       	mov    0x803020,%eax
  800410:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800416:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800419:	c1 e2 04             	shl    $0x4,%edx
  80041c:	01 d0                	add    %edx,%eax
  80041e:	8a 40 04             	mov    0x4(%eax),%al
  800421:	3c 01                	cmp    $0x1,%al
  800423:	75 03                	jne    800428 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800425:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800428:	ff 45 e0             	incl   -0x20(%ebp)
  80042b:	a1 20 30 80 00       	mov    0x803020,%eax
  800430:	8b 50 74             	mov    0x74(%eax),%edx
  800433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800436:	39 c2                	cmp    %eax,%edx
  800438:	77 d1                	ja     80040b <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80043a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800440:	74 14                	je     800456 <CheckWSWithoutLastIndex+0x159>
		panic(
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	68 58 25 80 00       	push   $0x802558
  80044a:	6a 44                	push   $0x44
  80044c:	68 f8 24 80 00       	push   $0x8024f8
  800451:	e8 35 fe ff ff       	call   80028b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800456:	90                   	nop
  800457:	c9                   	leave  
  800458:	c3                   	ret    

00800459 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80045f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	8d 48 01             	lea    0x1(%eax),%ecx
  800467:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046a:	89 0a                	mov    %ecx,(%edx)
  80046c:	8b 55 08             	mov    0x8(%ebp),%edx
  80046f:	88 d1                	mov    %dl,%cl
  800471:	8b 55 0c             	mov    0xc(%ebp),%edx
  800474:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	8b 00                	mov    (%eax),%eax
  80047d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800482:	75 2c                	jne    8004b0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800484:	a0 24 30 80 00       	mov    0x803024,%al
  800489:	0f b6 c0             	movzbl %al,%eax
  80048c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048f:	8b 12                	mov    (%edx),%edx
  800491:	89 d1                	mov    %edx,%ecx
  800493:	8b 55 0c             	mov    0xc(%ebp),%edx
  800496:	83 c2 08             	add    $0x8,%edx
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	50                   	push   %eax
  80049d:	51                   	push   %ecx
  80049e:	52                   	push   %edx
  80049f:	e8 a9 14 00 00       	call   80194d <sys_cputs>
  8004a4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	8b 40 04             	mov    0x4(%eax),%eax
  8004b6:	8d 50 01             	lea    0x1(%eax),%edx
  8004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004bf:	90                   	nop
  8004c0:	c9                   	leave  
  8004c1:	c3                   	ret    

008004c2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c2:	55                   	push   %ebp
  8004c3:	89 e5                	mov    %esp,%ebp
  8004c5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004cb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d2:	00 00 00 
	b.cnt = 0;
  8004d5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004dc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004df:	ff 75 0c             	pushl  0xc(%ebp)
  8004e2:	ff 75 08             	pushl  0x8(%ebp)
  8004e5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004eb:	50                   	push   %eax
  8004ec:	68 59 04 80 00       	push   $0x800459
  8004f1:	e8 11 02 00 00       	call   800707 <vprintfmt>
  8004f6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f9:	a0 24 30 80 00       	mov    0x803024,%al
  8004fe:	0f b6 c0             	movzbl %al,%eax
  800501:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800507:	83 ec 04             	sub    $0x4,%esp
  80050a:	50                   	push   %eax
  80050b:	52                   	push   %edx
  80050c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800512:	83 c0 08             	add    $0x8,%eax
  800515:	50                   	push   %eax
  800516:	e8 32 14 00 00       	call   80194d <sys_cputs>
  80051b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80051e:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800525:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <cprintf>:

int cprintf(const char *fmt, ...) {
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800533:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80053a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80053d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800540:	8b 45 08             	mov    0x8(%ebp),%eax
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	ff 75 f4             	pushl  -0xc(%ebp)
  800549:	50                   	push   %eax
  80054a:	e8 73 ff ff ff       	call   8004c2 <vcprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800555:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800558:	c9                   	leave  
  800559:	c3                   	ret    

0080055a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80055a:	55                   	push   %ebp
  80055b:	89 e5                	mov    %esp,%ebp
  80055d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800560:	e8 f9 15 00 00       	call   801b5e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800565:	8d 45 0c             	lea    0xc(%ebp),%eax
  800568:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	ff 75 f4             	pushl  -0xc(%ebp)
  800574:	50                   	push   %eax
  800575:	e8 48 ff ff ff       	call   8004c2 <vcprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
  80057d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800580:	e8 f3 15 00 00       	call   801b78 <sys_enable_interrupt>
	return cnt;
  800585:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800588:	c9                   	leave  
  800589:	c3                   	ret    

0080058a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80058a:	55                   	push   %ebp
  80058b:	89 e5                	mov    %esp,%ebp
  80058d:	53                   	push   %ebx
  80058e:	83 ec 14             	sub    $0x14,%esp
  800591:	8b 45 10             	mov    0x10(%ebp),%eax
  800594:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059d:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a8:	77 55                	ja     8005ff <printnum+0x75>
  8005aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ad:	72 05                	jb     8005b4 <printnum+0x2a>
  8005af:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b2:	77 4b                	ja     8005ff <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005b7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005ba:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c2:	52                   	push   %edx
  8005c3:	50                   	push   %eax
  8005c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8005ca:	e8 b1 19 00 00       	call   801f80 <__udivdi3>
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	83 ec 04             	sub    $0x4,%esp
  8005d5:	ff 75 20             	pushl  0x20(%ebp)
  8005d8:	53                   	push   %ebx
  8005d9:	ff 75 18             	pushl  0x18(%ebp)
  8005dc:	52                   	push   %edx
  8005dd:	50                   	push   %eax
  8005de:	ff 75 0c             	pushl  0xc(%ebp)
  8005e1:	ff 75 08             	pushl  0x8(%ebp)
  8005e4:	e8 a1 ff ff ff       	call   80058a <printnum>
  8005e9:	83 c4 20             	add    $0x20,%esp
  8005ec:	eb 1a                	jmp    800608 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	ff 75 0c             	pushl  0xc(%ebp)
  8005f4:	ff 75 20             	pushl  0x20(%ebp)
  8005f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fa:	ff d0                	call   *%eax
  8005fc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ff:	ff 4d 1c             	decl   0x1c(%ebp)
  800602:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800606:	7f e6                	jg     8005ee <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800608:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80060b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800613:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800616:	53                   	push   %ebx
  800617:	51                   	push   %ecx
  800618:	52                   	push   %edx
  800619:	50                   	push   %eax
  80061a:	e8 71 1a 00 00       	call   802090 <__umoddi3>
  80061f:	83 c4 10             	add    $0x10,%esp
  800622:	05 d4 27 80 00       	add    $0x8027d4,%eax
  800627:	8a 00                	mov    (%eax),%al
  800629:	0f be c0             	movsbl %al,%eax
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	ff 75 0c             	pushl  0xc(%ebp)
  800632:	50                   	push   %eax
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	ff d0                	call   *%eax
  800638:	83 c4 10             	add    $0x10,%esp
}
  80063b:	90                   	nop
  80063c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80063f:	c9                   	leave  
  800640:	c3                   	ret    

00800641 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800641:	55                   	push   %ebp
  800642:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800644:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800648:	7e 1c                	jle    800666 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	8d 50 08             	lea    0x8(%eax),%edx
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	89 10                	mov    %edx,(%eax)
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	83 e8 08             	sub    $0x8,%eax
  80065f:	8b 50 04             	mov    0x4(%eax),%edx
  800662:	8b 00                	mov    (%eax),%eax
  800664:	eb 40                	jmp    8006a6 <getuint+0x65>
	else if (lflag)
  800666:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80066a:	74 1e                	je     80068a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	8d 50 04             	lea    0x4(%eax),%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	89 10                	mov    %edx,(%eax)
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	83 e8 04             	sub    $0x4,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
  800688:	eb 1c                	jmp    8006a6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	8d 50 04             	lea    0x4(%eax),%edx
  800692:	8b 45 08             	mov    0x8(%ebp),%eax
  800695:	89 10                	mov    %edx,(%eax)
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	83 e8 04             	sub    $0x4,%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a6:	5d                   	pop    %ebp
  8006a7:	c3                   	ret    

008006a8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ab:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006af:	7e 1c                	jle    8006cd <getint+0x25>
		return va_arg(*ap, long long);
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	8d 50 08             	lea    0x8(%eax),%edx
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	89 10                	mov    %edx,(%eax)
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	83 e8 08             	sub    $0x8,%eax
  8006c6:	8b 50 04             	mov    0x4(%eax),%edx
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	eb 38                	jmp    800705 <getint+0x5d>
	else if (lflag)
  8006cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d1:	74 1a                	je     8006ed <getint+0x45>
		return va_arg(*ap, long);
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	8d 50 04             	lea    0x4(%eax),%edx
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	89 10                	mov    %edx,(%eax)
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	83 e8 04             	sub    $0x4,%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	99                   	cltd   
  8006eb:	eb 18                	jmp    800705 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	8d 50 04             	lea    0x4(%eax),%edx
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	89 10                	mov    %edx,(%eax)
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	83 e8 04             	sub    $0x4,%eax
  800702:	8b 00                	mov    (%eax),%eax
  800704:	99                   	cltd   
}
  800705:	5d                   	pop    %ebp
  800706:	c3                   	ret    

00800707 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800707:	55                   	push   %ebp
  800708:	89 e5                	mov    %esp,%ebp
  80070a:	56                   	push   %esi
  80070b:	53                   	push   %ebx
  80070c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070f:	eb 17                	jmp    800728 <vprintfmt+0x21>
			if (ch == '\0')
  800711:	85 db                	test   %ebx,%ebx
  800713:	0f 84 af 03 00 00    	je     800ac8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 0c             	pushl  0xc(%ebp)
  80071f:	53                   	push   %ebx
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	ff d0                	call   *%eax
  800725:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800728:	8b 45 10             	mov    0x10(%ebp),%eax
  80072b:	8d 50 01             	lea    0x1(%eax),%edx
  80072e:	89 55 10             	mov    %edx,0x10(%ebp)
  800731:	8a 00                	mov    (%eax),%al
  800733:	0f b6 d8             	movzbl %al,%ebx
  800736:	83 fb 25             	cmp    $0x25,%ebx
  800739:	75 d6                	jne    800711 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80073b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80073f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800746:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80074d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800754:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075b:	8b 45 10             	mov    0x10(%ebp),%eax
  80075e:	8d 50 01             	lea    0x1(%eax),%edx
  800761:	89 55 10             	mov    %edx,0x10(%ebp)
  800764:	8a 00                	mov    (%eax),%al
  800766:	0f b6 d8             	movzbl %al,%ebx
  800769:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80076c:	83 f8 55             	cmp    $0x55,%eax
  80076f:	0f 87 2b 03 00 00    	ja     800aa0 <vprintfmt+0x399>
  800775:	8b 04 85 f8 27 80 00 	mov    0x8027f8(,%eax,4),%eax
  80077c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80077e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800782:	eb d7                	jmp    80075b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800784:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800788:	eb d1                	jmp    80075b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80078a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800791:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800794:	89 d0                	mov    %edx,%eax
  800796:	c1 e0 02             	shl    $0x2,%eax
  800799:	01 d0                	add    %edx,%eax
  80079b:	01 c0                	add    %eax,%eax
  80079d:	01 d8                	add    %ebx,%eax
  80079f:	83 e8 30             	sub    $0x30,%eax
  8007a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a8:	8a 00                	mov    (%eax),%al
  8007aa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ad:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b0:	7e 3e                	jle    8007f0 <vprintfmt+0xe9>
  8007b2:	83 fb 39             	cmp    $0x39,%ebx
  8007b5:	7f 39                	jg     8007f0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ba:	eb d5                	jmp    800791 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	83 c0 04             	add    $0x4,%eax
  8007c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	83 e8 04             	sub    $0x4,%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d0:	eb 1f                	jmp    8007f1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d6:	79 83                	jns    80075b <vprintfmt+0x54>
				width = 0;
  8007d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007df:	e9 77 ff ff ff       	jmp    80075b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007eb:	e9 6b ff ff ff       	jmp    80075b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f5:	0f 89 60 ff ff ff    	jns    80075b <vprintfmt+0x54>
				width = precision, precision = -1;
  8007fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800801:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800808:	e9 4e ff ff ff       	jmp    80075b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800810:	e9 46 ff ff ff       	jmp    80075b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	83 c0 04             	add    $0x4,%eax
  80081b:	89 45 14             	mov    %eax,0x14(%ebp)
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	83 e8 04             	sub    $0x4,%eax
  800824:	8b 00                	mov    (%eax),%eax
  800826:	83 ec 08             	sub    $0x8,%esp
  800829:	ff 75 0c             	pushl  0xc(%ebp)
  80082c:	50                   	push   %eax
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	ff d0                	call   *%eax
  800832:	83 c4 10             	add    $0x10,%esp
			break;
  800835:	e9 89 02 00 00       	jmp    800ac3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	83 c0 04             	add    $0x4,%eax
  800840:	89 45 14             	mov    %eax,0x14(%ebp)
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	83 e8 04             	sub    $0x4,%eax
  800849:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80084b:	85 db                	test   %ebx,%ebx
  80084d:	79 02                	jns    800851 <vprintfmt+0x14a>
				err = -err;
  80084f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800851:	83 fb 64             	cmp    $0x64,%ebx
  800854:	7f 0b                	jg     800861 <vprintfmt+0x15a>
  800856:	8b 34 9d 40 26 80 00 	mov    0x802640(,%ebx,4),%esi
  80085d:	85 f6                	test   %esi,%esi
  80085f:	75 19                	jne    80087a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800861:	53                   	push   %ebx
  800862:	68 e5 27 80 00       	push   $0x8027e5
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	ff 75 08             	pushl  0x8(%ebp)
  80086d:	e8 5e 02 00 00       	call   800ad0 <printfmt>
  800872:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800875:	e9 49 02 00 00       	jmp    800ac3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80087a:	56                   	push   %esi
  80087b:	68 ee 27 80 00       	push   $0x8027ee
  800880:	ff 75 0c             	pushl  0xc(%ebp)
  800883:	ff 75 08             	pushl  0x8(%ebp)
  800886:	e8 45 02 00 00       	call   800ad0 <printfmt>
  80088b:	83 c4 10             	add    $0x10,%esp
			break;
  80088e:	e9 30 02 00 00       	jmp    800ac3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	83 c0 04             	add    $0x4,%eax
  800899:	89 45 14             	mov    %eax,0x14(%ebp)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	83 e8 04             	sub    $0x4,%eax
  8008a2:	8b 30                	mov    (%eax),%esi
  8008a4:	85 f6                	test   %esi,%esi
  8008a6:	75 05                	jne    8008ad <vprintfmt+0x1a6>
				p = "(null)";
  8008a8:	be f1 27 80 00       	mov    $0x8027f1,%esi
			if (width > 0 && padc != '-')
  8008ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b1:	7e 6d                	jle    800920 <vprintfmt+0x219>
  8008b3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008b7:	74 67                	je     800920 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008bc:	83 ec 08             	sub    $0x8,%esp
  8008bf:	50                   	push   %eax
  8008c0:	56                   	push   %esi
  8008c1:	e8 0c 03 00 00       	call   800bd2 <strnlen>
  8008c6:	83 c4 10             	add    $0x10,%esp
  8008c9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008cc:	eb 16                	jmp    8008e4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008ce:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	50                   	push   %eax
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	ff d0                	call   *%eax
  8008de:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e1:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e8:	7f e4                	jg     8008ce <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ea:	eb 34                	jmp    800920 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f0:	74 1c                	je     80090e <vprintfmt+0x207>
  8008f2:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f5:	7e 05                	jle    8008fc <vprintfmt+0x1f5>
  8008f7:	83 fb 7e             	cmp    $0x7e,%ebx
  8008fa:	7e 12                	jle    80090e <vprintfmt+0x207>
					putch('?', putdat);
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	ff 75 0c             	pushl  0xc(%ebp)
  800902:	6a 3f                	push   $0x3f
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	ff d0                	call   *%eax
  800909:	83 c4 10             	add    $0x10,%esp
  80090c:	eb 0f                	jmp    80091d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	53                   	push   %ebx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091d:	ff 4d e4             	decl   -0x1c(%ebp)
  800920:	89 f0                	mov    %esi,%eax
  800922:	8d 70 01             	lea    0x1(%eax),%esi
  800925:	8a 00                	mov    (%eax),%al
  800927:	0f be d8             	movsbl %al,%ebx
  80092a:	85 db                	test   %ebx,%ebx
  80092c:	74 24                	je     800952 <vprintfmt+0x24b>
  80092e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800932:	78 b8                	js     8008ec <vprintfmt+0x1e5>
  800934:	ff 4d e0             	decl   -0x20(%ebp)
  800937:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093b:	79 af                	jns    8008ec <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093d:	eb 13                	jmp    800952 <vprintfmt+0x24b>
				putch(' ', putdat);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	6a 20                	push   $0x20
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	ff d0                	call   *%eax
  80094c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094f:	ff 4d e4             	decl   -0x1c(%ebp)
  800952:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800956:	7f e7                	jg     80093f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800958:	e9 66 01 00 00       	jmp    800ac3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 e8             	pushl  -0x18(%ebp)
  800963:	8d 45 14             	lea    0x14(%ebp),%eax
  800966:	50                   	push   %eax
  800967:	e8 3c fd ff ff       	call   8006a8 <getint>
  80096c:	83 c4 10             	add    $0x10,%esp
  80096f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800972:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800978:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80097b:	85 d2                	test   %edx,%edx
  80097d:	79 23                	jns    8009a2 <vprintfmt+0x29b>
				putch('-', putdat);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	6a 2d                	push   $0x2d
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	ff d0                	call   *%eax
  80098c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80098f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800992:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800995:	f7 d8                	neg    %eax
  800997:	83 d2 00             	adc    $0x0,%edx
  80099a:	f7 da                	neg    %edx
  80099c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a9:	e9 bc 00 00 00       	jmp    800a6a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b4:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b7:	50                   	push   %eax
  8009b8:	e8 84 fc ff ff       	call   800641 <getuint>
  8009bd:	83 c4 10             	add    $0x10,%esp
  8009c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009c6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009cd:	e9 98 00 00 00       	jmp    800a6a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d2:	83 ec 08             	sub    $0x8,%esp
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	6a 58                	push   $0x58
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	ff d0                	call   *%eax
  8009df:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	ff 75 0c             	pushl  0xc(%ebp)
  8009e8:	6a 58                	push   $0x58
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	ff d0                	call   *%eax
  8009ef:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 0c             	pushl  0xc(%ebp)
  8009f8:	6a 58                	push   $0x58
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	ff d0                	call   *%eax
  8009ff:	83 c4 10             	add    $0x10,%esp
			break;
  800a02:	e9 bc 00 00 00       	jmp    800ac3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a07:	83 ec 08             	sub    $0x8,%esp
  800a0a:	ff 75 0c             	pushl  0xc(%ebp)
  800a0d:	6a 30                	push   $0x30
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	ff d0                	call   *%eax
  800a14:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	ff 75 0c             	pushl  0xc(%ebp)
  800a1d:	6a 78                	push   $0x78
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	ff d0                	call   *%eax
  800a24:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a27:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2a:	83 c0 04             	add    $0x4,%eax
  800a2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	83 e8 04             	sub    $0x4,%eax
  800a36:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a42:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a49:	eb 1f                	jmp    800a6a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a51:	8d 45 14             	lea    0x14(%ebp),%eax
  800a54:	50                   	push   %eax
  800a55:	e8 e7 fb ff ff       	call   800641 <getuint>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a60:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a63:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a6a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a71:	83 ec 04             	sub    $0x4,%esp
  800a74:	52                   	push   %edx
  800a75:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a78:	50                   	push   %eax
  800a79:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7c:	ff 75 f0             	pushl  -0x10(%ebp)
  800a7f:	ff 75 0c             	pushl  0xc(%ebp)
  800a82:	ff 75 08             	pushl  0x8(%ebp)
  800a85:	e8 00 fb ff ff       	call   80058a <printnum>
  800a8a:	83 c4 20             	add    $0x20,%esp
			break;
  800a8d:	eb 34                	jmp    800ac3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	53                   	push   %ebx
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	eb 23                	jmp    800ac3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 0c             	pushl  0xc(%ebp)
  800aa6:	6a 25                	push   $0x25
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	ff d0                	call   *%eax
  800aad:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab0:	ff 4d 10             	decl   0x10(%ebp)
  800ab3:	eb 03                	jmp    800ab8 <vprintfmt+0x3b1>
  800ab5:	ff 4d 10             	decl   0x10(%ebp)
  800ab8:	8b 45 10             	mov    0x10(%ebp),%eax
  800abb:	48                   	dec    %eax
  800abc:	8a 00                	mov    (%eax),%al
  800abe:	3c 25                	cmp    $0x25,%al
  800ac0:	75 f3                	jne    800ab5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac2:	90                   	nop
		}
	}
  800ac3:	e9 47 fc ff ff       	jmp    80070f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800acc:	5b                   	pop    %ebx
  800acd:	5e                   	pop    %esi
  800ace:	5d                   	pop    %ebp
  800acf:	c3                   	ret    

00800ad0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ad6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad9:	83 c0 04             	add    $0x4,%eax
  800adc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800adf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae5:	50                   	push   %eax
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	ff 75 08             	pushl  0x8(%ebp)
  800aec:	e8 16 fc ff ff       	call   800707 <vprintfmt>
  800af1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800af4:	90                   	nop
  800af5:	c9                   	leave  
  800af6:	c3                   	ret    

00800af7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	8b 40 08             	mov    0x8(%eax),%eax
  800b00:	8d 50 01             	lea    0x1(%eax),%edx
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	8b 10                	mov    (%eax),%edx
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	8b 40 04             	mov    0x4(%eax),%eax
  800b14:	39 c2                	cmp    %eax,%edx
  800b16:	73 12                	jae    800b2a <sprintputch+0x33>
		*b->buf++ = ch;
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	8b 00                	mov    (%eax),%eax
  800b1d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b23:	89 0a                	mov    %ecx,(%edx)
  800b25:	8b 55 08             	mov    0x8(%ebp),%edx
  800b28:	88 10                	mov    %dl,(%eax)
}
  800b2a:	90                   	nop
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    

00800b2d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	01 d0                	add    %edx,%eax
  800b44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b52:	74 06                	je     800b5a <vsnprintf+0x2d>
  800b54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b58:	7f 07                	jg     800b61 <vsnprintf+0x34>
		return -E_INVAL;
  800b5a:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5f:	eb 20                	jmp    800b81 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b61:	ff 75 14             	pushl  0x14(%ebp)
  800b64:	ff 75 10             	pushl  0x10(%ebp)
  800b67:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b6a:	50                   	push   %eax
  800b6b:	68 f7 0a 80 00       	push   $0x800af7
  800b70:	e8 92 fb ff ff       	call   800707 <vprintfmt>
  800b75:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b7b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b81:	c9                   	leave  
  800b82:	c3                   	ret    

00800b83 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b89:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8c:	83 c0 04             	add    $0x4,%eax
  800b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b92:	8b 45 10             	mov    0x10(%ebp),%eax
  800b95:	ff 75 f4             	pushl  -0xc(%ebp)
  800b98:	50                   	push   %eax
  800b99:	ff 75 0c             	pushl  0xc(%ebp)
  800b9c:	ff 75 08             	pushl  0x8(%ebp)
  800b9f:	e8 89 ff ff ff       	call   800b2d <vsnprintf>
  800ba4:	83 c4 10             	add    $0x10,%esp
  800ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bbc:	eb 06                	jmp    800bc4 <strlen+0x15>
		n++;
  800bbe:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc1:	ff 45 08             	incl   0x8(%ebp)
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	8a 00                	mov    (%eax),%al
  800bc9:	84 c0                	test   %al,%al
  800bcb:	75 f1                	jne    800bbe <strlen+0xf>
		n++;
	return n;
  800bcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd0:	c9                   	leave  
  800bd1:	c3                   	ret    

00800bd2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bdf:	eb 09                	jmp    800bea <strnlen+0x18>
		n++;
  800be1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be4:	ff 45 08             	incl   0x8(%ebp)
  800be7:	ff 4d 0c             	decl   0xc(%ebp)
  800bea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bee:	74 09                	je     800bf9 <strnlen+0x27>
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	8a 00                	mov    (%eax),%al
  800bf5:	84 c0                	test   %al,%al
  800bf7:	75 e8                	jne    800be1 <strnlen+0xf>
		n++;
	return n;
  800bf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfc:	c9                   	leave  
  800bfd:	c3                   	ret    

00800bfe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c0a:	90                   	nop
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	8d 50 01             	lea    0x1(%eax),%edx
  800c11:	89 55 08             	mov    %edx,0x8(%ebp)
  800c14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c17:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c1a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c1d:	8a 12                	mov    (%edx),%dl
  800c1f:	88 10                	mov    %dl,(%eax)
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	84 c0                	test   %al,%al
  800c25:	75 e4                	jne    800c0b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3f:	eb 1f                	jmp    800c60 <strncpy+0x34>
		*dst++ = *src;
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8d 50 01             	lea    0x1(%eax),%edx
  800c47:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4d:	8a 12                	mov    (%edx),%dl
  800c4f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c54:	8a 00                	mov    (%eax),%al
  800c56:	84 c0                	test   %al,%al
  800c58:	74 03                	je     800c5d <strncpy+0x31>
			src++;
  800c5a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c5d:	ff 45 fc             	incl   -0x4(%ebp)
  800c60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c63:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c66:	72 d9                	jb     800c41 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c68:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7d:	74 30                	je     800caf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c7f:	eb 16                	jmp    800c97 <strlcpy+0x2a>
			*dst++ = *src++;
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	8d 50 01             	lea    0x1(%eax),%edx
  800c87:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c90:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c93:	8a 12                	mov    (%edx),%dl
  800c95:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c97:	ff 4d 10             	decl   0x10(%ebp)
  800c9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9e:	74 09                	je     800ca9 <strlcpy+0x3c>
  800ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca3:	8a 00                	mov    (%eax),%al
  800ca5:	84 c0                	test   %al,%al
  800ca7:	75 d8                	jne    800c81 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800caf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb5:	29 c2                	sub    %eax,%edx
  800cb7:	89 d0                	mov    %edx,%eax
}
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cbe:	eb 06                	jmp    800cc6 <strcmp+0xb>
		p++, q++;
  800cc0:	ff 45 08             	incl   0x8(%ebp)
  800cc3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8a 00                	mov    (%eax),%al
  800ccb:	84 c0                	test   %al,%al
  800ccd:	74 0e                	je     800cdd <strcmp+0x22>
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 10                	mov    (%eax),%dl
  800cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	38 c2                	cmp    %al,%dl
  800cdb:	74 e3                	je     800cc0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	0f b6 d0             	movzbl %al,%edx
  800ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	0f b6 c0             	movzbl %al,%eax
  800ced:	29 c2                	sub    %eax,%edx
  800cef:	89 d0                	mov    %edx,%eax
}
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf6:	eb 09                	jmp    800d01 <strncmp+0xe>
		n--, p++, q++;
  800cf8:	ff 4d 10             	decl   0x10(%ebp)
  800cfb:	ff 45 08             	incl   0x8(%ebp)
  800cfe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d05:	74 17                	je     800d1e <strncmp+0x2b>
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	84 c0                	test   %al,%al
  800d0e:	74 0e                	je     800d1e <strncmp+0x2b>
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 10                	mov    (%eax),%dl
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	38 c2                	cmp    %al,%dl
  800d1c:	74 da                	je     800cf8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d22:	75 07                	jne    800d2b <strncmp+0x38>
		return 0;
  800d24:	b8 00 00 00 00       	mov    $0x0,%eax
  800d29:	eb 14                	jmp    800d3f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 d0             	movzbl %al,%edx
  800d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	0f b6 c0             	movzbl %al,%eax
  800d3b:	29 c2                	sub    %eax,%edx
  800d3d:	89 d0                	mov    %edx,%eax
}
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	83 ec 04             	sub    $0x4,%esp
  800d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d4d:	eb 12                	jmp    800d61 <strchr+0x20>
		if (*s == c)
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d57:	75 05                	jne    800d5e <strchr+0x1d>
			return (char *) s;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	eb 11                	jmp    800d6f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d5e:	ff 45 08             	incl   0x8(%ebp)
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	84 c0                	test   %al,%al
  800d68:	75 e5                	jne    800d4f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6f:	c9                   	leave  
  800d70:	c3                   	ret    

00800d71 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	83 ec 04             	sub    $0x4,%esp
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7d:	eb 0d                	jmp    800d8c <strfind+0x1b>
		if (*s == c)
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d87:	74 0e                	je     800d97 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d89:	ff 45 08             	incl   0x8(%ebp)
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	84 c0                	test   %al,%al
  800d93:	75 ea                	jne    800d7f <strfind+0xe>
  800d95:	eb 01                	jmp    800d98 <strfind+0x27>
		if (*s == c)
			break;
  800d97:	90                   	nop
	return (char *) s;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d9b:	c9                   	leave  
  800d9c:	c3                   	ret    

00800d9d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800daf:	eb 0e                	jmp    800dbf <memset+0x22>
		*p++ = c;
  800db1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db4:	8d 50 01             	lea    0x1(%eax),%edx
  800db7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dbf:	ff 4d f8             	decl   -0x8(%ebp)
  800dc2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dc6:	79 e9                	jns    800db1 <memset+0x14>
		*p++ = c;

	return v;
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dcb:	c9                   	leave  
  800dcc:	c3                   	ret    

00800dcd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ddf:	eb 16                	jmp    800df7 <memcpy+0x2a>
		*d++ = *s++;
  800de1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de4:	8d 50 01             	lea    0x1(%eax),%edx
  800de7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ded:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df3:	8a 12                	mov    (%edx),%dl
  800df5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800df7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfd:	89 55 10             	mov    %edx,0x10(%ebp)
  800e00:	85 c0                	test   %eax,%eax
  800e02:	75 dd                	jne    800de1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e07:	c9                   	leave  
  800e08:	c3                   	ret    

00800e09 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e21:	73 50                	jae    800e73 <memmove+0x6a>
  800e23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e26:	8b 45 10             	mov    0x10(%ebp),%eax
  800e29:	01 d0                	add    %edx,%eax
  800e2b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2e:	76 43                	jbe    800e73 <memmove+0x6a>
		s += n;
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e3c:	eb 10                	jmp    800e4e <memmove+0x45>
			*--d = *--s;
  800e3e:	ff 4d f8             	decl   -0x8(%ebp)
  800e41:	ff 4d fc             	decl   -0x4(%ebp)
  800e44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e47:	8a 10                	mov    (%eax),%dl
  800e49:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e51:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e54:	89 55 10             	mov    %edx,0x10(%ebp)
  800e57:	85 c0                	test   %eax,%eax
  800e59:	75 e3                	jne    800e3e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e5b:	eb 23                	jmp    800e80 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e60:	8d 50 01             	lea    0x1(%eax),%edx
  800e63:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e66:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e69:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e6f:	8a 12                	mov    (%edx),%dl
  800e71:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e73:	8b 45 10             	mov    0x10(%ebp),%eax
  800e76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e79:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7c:	85 c0                	test   %eax,%eax
  800e7e:	75 dd                	jne    800e5d <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e83:	c9                   	leave  
  800e84:	c3                   	ret    

00800e85 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e97:	eb 2a                	jmp    800ec3 <memcmp+0x3e>
		if (*s1 != *s2)
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9c:	8a 10                	mov    (%eax),%dl
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	38 c2                	cmp    %al,%dl
  800ea5:	74 16                	je     800ebd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f b6 d0             	movzbl %al,%edx
  800eaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	0f b6 c0             	movzbl %al,%eax
  800eb7:	29 c2                	sub    %eax,%edx
  800eb9:	89 d0                	mov    %edx,%eax
  800ebb:	eb 18                	jmp    800ed5 <memcmp+0x50>
		s1++, s2++;
  800ebd:	ff 45 fc             	incl   -0x4(%ebp)
  800ec0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec9:	89 55 10             	mov    %edx,0x10(%ebp)
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	75 c9                	jne    800e99 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed5:	c9                   	leave  
  800ed6:	c3                   	ret    

00800ed7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee3:	01 d0                	add    %edx,%eax
  800ee5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee8:	eb 15                	jmp    800eff <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	0f b6 d0             	movzbl %al,%edx
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	0f b6 c0             	movzbl %al,%eax
  800ef8:	39 c2                	cmp    %eax,%edx
  800efa:	74 0d                	je     800f09 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800efc:	ff 45 08             	incl   0x8(%ebp)
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f05:	72 e3                	jb     800eea <memfind+0x13>
  800f07:	eb 01                	jmp    800f0a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f09:	90                   	nop
	return (void *) s;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0d:	c9                   	leave  
  800f0e:	c3                   	ret    

00800f0f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f1c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f23:	eb 03                	jmp    800f28 <strtol+0x19>
		s++;
  800f25:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	3c 20                	cmp    $0x20,%al
  800f2f:	74 f4                	je     800f25 <strtol+0x16>
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 09                	cmp    $0x9,%al
  800f38:	74 eb                	je     800f25 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 2b                	cmp    $0x2b,%al
  800f41:	75 05                	jne    800f48 <strtol+0x39>
		s++;
  800f43:	ff 45 08             	incl   0x8(%ebp)
  800f46:	eb 13                	jmp    800f5b <strtol+0x4c>
	else if (*s == '-')
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 2d                	cmp    $0x2d,%al
  800f4f:	75 0a                	jne    800f5b <strtol+0x4c>
		s++, neg = 1;
  800f51:	ff 45 08             	incl   0x8(%ebp)
  800f54:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5f:	74 06                	je     800f67 <strtol+0x58>
  800f61:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f65:	75 20                	jne    800f87 <strtol+0x78>
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	3c 30                	cmp    $0x30,%al
  800f6e:	75 17                	jne    800f87 <strtol+0x78>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	40                   	inc    %eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	3c 78                	cmp    $0x78,%al
  800f78:	75 0d                	jne    800f87 <strtol+0x78>
		s += 2, base = 16;
  800f7a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f7e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f85:	eb 28                	jmp    800faf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8b:	75 15                	jne    800fa2 <strtol+0x93>
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	3c 30                	cmp    $0x30,%al
  800f94:	75 0c                	jne    800fa2 <strtol+0x93>
		s++, base = 8;
  800f96:	ff 45 08             	incl   0x8(%ebp)
  800f99:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa0:	eb 0d                	jmp    800faf <strtol+0xa0>
	else if (base == 0)
  800fa2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa6:	75 07                	jne    800faf <strtol+0xa0>
		base = 10;
  800fa8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	3c 2f                	cmp    $0x2f,%al
  800fb6:	7e 19                	jle    800fd1 <strtol+0xc2>
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 39                	cmp    $0x39,%al
  800fbf:	7f 10                	jg     800fd1 <strtol+0xc2>
			dig = *s - '0';
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	0f be c0             	movsbl %al,%eax
  800fc9:	83 e8 30             	sub    $0x30,%eax
  800fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fcf:	eb 42                	jmp    801013 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 60                	cmp    $0x60,%al
  800fd8:	7e 19                	jle    800ff3 <strtol+0xe4>
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 7a                	cmp    $0x7a,%al
  800fe1:	7f 10                	jg     800ff3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	0f be c0             	movsbl %al,%eax
  800feb:	83 e8 57             	sub    $0x57,%eax
  800fee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff1:	eb 20                	jmp    801013 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	3c 40                	cmp    $0x40,%al
  800ffa:	7e 39                	jle    801035 <strtol+0x126>
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 5a                	cmp    $0x5a,%al
  801003:	7f 30                	jg     801035 <strtol+0x126>
			dig = *s - 'A' + 10;
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f be c0             	movsbl %al,%eax
  80100d:	83 e8 37             	sub    $0x37,%eax
  801010:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801016:	3b 45 10             	cmp    0x10(%ebp),%eax
  801019:	7d 19                	jge    801034 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80101b:	ff 45 08             	incl   0x8(%ebp)
  80101e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801021:	0f af 45 10          	imul   0x10(%ebp),%eax
  801025:	89 c2                	mov    %eax,%edx
  801027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80102f:	e9 7b ff ff ff       	jmp    800faf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801034:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801035:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801039:	74 08                	je     801043 <strtol+0x134>
		*endptr = (char *) s;
  80103b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103e:	8b 55 08             	mov    0x8(%ebp),%edx
  801041:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801043:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801047:	74 07                	je     801050 <strtol+0x141>
  801049:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104c:	f7 d8                	neg    %eax
  80104e:	eb 03                	jmp    801053 <strtol+0x144>
  801050:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801053:	c9                   	leave  
  801054:	c3                   	ret    

00801055 <ltostr>:

void
ltostr(long value, char *str)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80105b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801062:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801069:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106d:	79 13                	jns    801082 <ltostr+0x2d>
	{
		neg = 1;
  80106f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801076:	8b 45 0c             	mov    0xc(%ebp),%eax
  801079:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80107c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80107f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80108a:	99                   	cltd   
  80108b:	f7 f9                	idiv   %ecx
  80108d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801090:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801093:	8d 50 01             	lea    0x1(%eax),%edx
  801096:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801099:	89 c2                	mov    %eax,%edx
  80109b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109e:	01 d0                	add    %edx,%eax
  8010a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a3:	83 c2 30             	add    $0x30,%edx
  8010a6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ab:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b0:	f7 e9                	imul   %ecx
  8010b2:	c1 fa 02             	sar    $0x2,%edx
  8010b5:	89 c8                	mov    %ecx,%eax
  8010b7:	c1 f8 1f             	sar    $0x1f,%eax
  8010ba:	29 c2                	sub    %eax,%edx
  8010bc:	89 d0                	mov    %edx,%eax
  8010be:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c9:	f7 e9                	imul   %ecx
  8010cb:	c1 fa 02             	sar    $0x2,%edx
  8010ce:	89 c8                	mov    %ecx,%eax
  8010d0:	c1 f8 1f             	sar    $0x1f,%eax
  8010d3:	29 c2                	sub    %eax,%edx
  8010d5:	89 d0                	mov    %edx,%eax
  8010d7:	c1 e0 02             	shl    $0x2,%eax
  8010da:	01 d0                	add    %edx,%eax
  8010dc:	01 c0                	add    %eax,%eax
  8010de:	29 c1                	sub    %eax,%ecx
  8010e0:	89 ca                	mov    %ecx,%edx
  8010e2:	85 d2                	test   %edx,%edx
  8010e4:	75 9c                	jne    801082 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f0:	48                   	dec    %eax
  8010f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f8:	74 3d                	je     801137 <ltostr+0xe2>
		start = 1 ;
  8010fa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801101:	eb 34                	jmp    801137 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801103:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801106:	8b 45 0c             	mov    0xc(%ebp),%eax
  801109:	01 d0                	add    %edx,%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801110:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 c2                	add    %eax,%edx
  801118:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80111b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111e:	01 c8                	add    %ecx,%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801124:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	01 c2                	add    %eax,%edx
  80112c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80112f:	88 02                	mov    %al,(%edx)
		start++ ;
  801131:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801134:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80113d:	7c c4                	jl     801103 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80113f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	01 d0                	add    %edx,%eax
  801147:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80114a:	90                   	nop
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801153:	ff 75 08             	pushl  0x8(%ebp)
  801156:	e8 54 fa ff ff       	call   800baf <strlen>
  80115b:	83 c4 04             	add    $0x4,%esp
  80115e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801161:	ff 75 0c             	pushl  0xc(%ebp)
  801164:	e8 46 fa ff ff       	call   800baf <strlen>
  801169:	83 c4 04             	add    $0x4,%esp
  80116c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80116f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801176:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117d:	eb 17                	jmp    801196 <strcconcat+0x49>
		final[s] = str1[s] ;
  80117f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801182:	8b 45 10             	mov    0x10(%ebp),%eax
  801185:	01 c2                	add    %eax,%edx
  801187:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	01 c8                	add    %ecx,%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801193:	ff 45 fc             	incl   -0x4(%ebp)
  801196:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801199:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80119c:	7c e1                	jl     80117f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80119e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011ac:	eb 1f                	jmp    8011cd <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b1:	8d 50 01             	lea    0x1(%eax),%edx
  8011b4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011b7:	89 c2                	mov    %eax,%edx
  8011b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bc:	01 c2                	add    %eax,%edx
  8011be:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	01 c8                	add    %ecx,%eax
  8011c6:	8a 00                	mov    (%eax),%al
  8011c8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ca:	ff 45 f8             	incl   -0x8(%ebp)
  8011cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d3:	7c d9                	jl     8011ae <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011db:	01 d0                	add    %edx,%eax
  8011dd:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e0:	90                   	nop
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    

008011e3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f2:	8b 00                	mov    (%eax),%eax
  8011f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801206:	eb 0c                	jmp    801214 <strsplit+0x31>
			*string++ = 0;
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8d 50 01             	lea    0x1(%eax),%edx
  80120e:	89 55 08             	mov    %edx,0x8(%ebp)
  801211:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	8a 00                	mov    (%eax),%al
  801219:	84 c0                	test   %al,%al
  80121b:	74 18                	je     801235 <strsplit+0x52>
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	0f be c0             	movsbl %al,%eax
  801225:	50                   	push   %eax
  801226:	ff 75 0c             	pushl  0xc(%ebp)
  801229:	e8 13 fb ff ff       	call   800d41 <strchr>
  80122e:	83 c4 08             	add    $0x8,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	75 d3                	jne    801208 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	84 c0                	test   %al,%al
  80123c:	74 5a                	je     801298 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80123e:	8b 45 14             	mov    0x14(%ebp),%eax
  801241:	8b 00                	mov    (%eax),%eax
  801243:	83 f8 0f             	cmp    $0xf,%eax
  801246:	75 07                	jne    80124f <strsplit+0x6c>
		{
			return 0;
  801248:	b8 00 00 00 00       	mov    $0x0,%eax
  80124d:	eb 66                	jmp    8012b5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80124f:	8b 45 14             	mov    0x14(%ebp),%eax
  801252:	8b 00                	mov    (%eax),%eax
  801254:	8d 48 01             	lea    0x1(%eax),%ecx
  801257:	8b 55 14             	mov    0x14(%ebp),%edx
  80125a:	89 0a                	mov    %ecx,(%edx)
  80125c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801263:	8b 45 10             	mov    0x10(%ebp),%eax
  801266:	01 c2                	add    %eax,%edx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126d:	eb 03                	jmp    801272 <strsplit+0x8f>
			string++;
  80126f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	84 c0                	test   %al,%al
  801279:	74 8b                	je     801206 <strsplit+0x23>
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	0f be c0             	movsbl %al,%eax
  801283:	50                   	push   %eax
  801284:	ff 75 0c             	pushl  0xc(%ebp)
  801287:	e8 b5 fa ff ff       	call   800d41 <strchr>
  80128c:	83 c4 08             	add    $0x8,%esp
  80128f:	85 c0                	test   %eax,%eax
  801291:	74 dc                	je     80126f <strsplit+0x8c>
			string++;
	}
  801293:	e9 6e ff ff ff       	jmp    801206 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801298:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801299:	8b 45 14             	mov    0x14(%ebp),%eax
  80129c:	8b 00                	mov    (%eax),%eax
  80129e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a8:	01 d0                	add    %edx,%eax
  8012aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8012bd:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8012c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8012ca:	01 d0                	add    %edx,%eax
  8012cc:	48                   	dec    %eax
  8012cd:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8012d0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8012d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d8:	f7 75 ac             	divl   -0x54(%ebp)
  8012db:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8012de:	29 d0                	sub    %edx,%eax
  8012e0:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8012e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8012ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8012f1:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8012f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8012ff:	eb 3f                	jmp    801340 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801304:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80130b:	83 ec 04             	sub    $0x4,%esp
  80130e:	50                   	push   %eax
  80130f:	ff 75 e8             	pushl  -0x18(%ebp)
  801312:	68 50 29 80 00       	push   $0x802950
  801317:	e8 11 f2 ff ff       	call   80052d <cprintf>
  80131c:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  80131f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801322:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801329:	83 ec 04             	sub    $0x4,%esp
  80132c:	50                   	push   %eax
  80132d:	ff 75 e8             	pushl  -0x18(%ebp)
  801330:	68 65 29 80 00       	push   $0x802965
  801335:	e8 f3 f1 ff ff       	call   80052d <cprintf>
  80133a:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  80133d:	ff 45 e8             	incl   -0x18(%ebp)
  801340:	a1 28 30 80 00       	mov    0x803028,%eax
  801345:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801348:	7c b7                	jl     801301 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  80134a:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801351:	e9 42 01 00 00       	jmp    801498 <malloc+0x1e1>
		int flag0=1;
  801356:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  80135d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801360:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801363:	eb 6b                	jmp    8013d0 <malloc+0x119>
			for(int k=0;k<count;k++){
  801365:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80136c:	eb 42                	jmp    8013b0 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  80136e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801371:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801378:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80137b:	39 c2                	cmp    %eax,%edx
  80137d:	77 2e                	ja     8013ad <malloc+0xf6>
  80137f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801382:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801389:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80138c:	39 c2                	cmp    %eax,%edx
  80138e:	76 1d                	jbe    8013ad <malloc+0xf6>
					ni=arr_add[k].end-i;
  801390:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801393:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80139a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80139d:	29 c2                	sub    %eax,%edx
  80139f:	89 d0                	mov    %edx,%eax
  8013a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  8013a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8013ab:	eb 0d                	jmp    8013ba <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8013ad:	ff 45 d8             	incl   -0x28(%ebp)
  8013b0:	a1 28 30 80 00       	mov    0x803028,%eax
  8013b5:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8013b8:	7c b4                	jl     80136e <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8013ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013be:	74 09                	je     8013c9 <malloc+0x112>
				flag0=0;
  8013c0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8013c7:	eb 16                	jmp    8013df <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8013c9:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8013d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	01 c2                	add    %eax,%edx
  8013d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013db:	39 c2                	cmp    %eax,%edx
  8013dd:	77 86                	ja     801365 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8013df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013e3:	0f 84 a2 00 00 00    	je     80148b <malloc+0x1d4>

			int f=1;
  8013e9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  8013f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013f3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8013f6:	89 c8                	mov    %ecx,%eax
  8013f8:	01 c0                	add    %eax,%eax
  8013fa:	01 c8                	add    %ecx,%eax
  8013fc:	c1 e0 02             	shl    $0x2,%eax
  8013ff:	05 20 31 80 00       	add    $0x803120,%eax
  801404:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801406:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80140f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801412:	89 d0                	mov    %edx,%eax
  801414:	01 c0                	add    %eax,%eax
  801416:	01 d0                	add    %edx,%eax
  801418:	c1 e0 02             	shl    $0x2,%eax
  80141b:	05 24 31 80 00       	add    $0x803124,%eax
  801420:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801422:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801425:	89 d0                	mov    %edx,%eax
  801427:	01 c0                	add    %eax,%eax
  801429:	01 d0                	add    %edx,%eax
  80142b:	c1 e0 02             	shl    $0x2,%eax
  80142e:	05 28 31 80 00       	add    $0x803128,%eax
  801433:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801439:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  80143c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801443:	eb 36                	jmp    80147b <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801445:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	01 c2                	add    %eax,%edx
  80144d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801450:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801457:	39 c2                	cmp    %eax,%edx
  801459:	73 1d                	jae    801478 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  80145b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80145e:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801468:	29 c2                	sub    %eax,%edx
  80146a:	89 d0                	mov    %edx,%eax
  80146c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  80146f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801476:	eb 0d                	jmp    801485 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801478:	ff 45 d0             	incl   -0x30(%ebp)
  80147b:	a1 28 30 80 00       	mov    0x803028,%eax
  801480:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801483:	7c c0                	jl     801445 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801485:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801489:	75 1d                	jne    8014a8 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  80148b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801492:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801495:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801498:	a1 04 30 80 00       	mov    0x803004,%eax
  80149d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8014a0:	0f 8c b0 fe ff ff    	jl     801356 <malloc+0x9f>
  8014a6:	eb 01                	jmp    8014a9 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  8014a8:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8014a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014ad:	75 7a                	jne    801529 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  8014af:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	01 d0                	add    %edx,%eax
  8014ba:	48                   	dec    %eax
  8014bb:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8014c0:	7c 0a                	jl     8014cc <malloc+0x215>
			return NULL;
  8014c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c7:	e9 a4 02 00 00       	jmp    801770 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  8014cc:	a1 04 30 80 00       	mov    0x803004,%eax
  8014d1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8014d4:	a1 28 30 80 00       	mov    0x803028,%eax
  8014d9:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8014dc:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  8014e3:	83 ec 08             	sub    $0x8,%esp
  8014e6:	ff 75 08             	pushl  0x8(%ebp)
  8014e9:	ff 75 a4             	pushl  -0x5c(%ebp)
  8014ec:	e8 04 06 00 00       	call   801af5 <sys_allocateMem>
  8014f1:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  8014f4:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	01 d0                	add    %edx,%eax
  8014ff:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  801504:	a1 28 30 80 00       	mov    0x803028,%eax
  801509:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80150f:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  801516:	a1 28 30 80 00       	mov    0x803028,%eax
  80151b:	40                   	inc    %eax
  80151c:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  801521:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801524:	e9 47 02 00 00       	jmp    801770 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801529:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801530:	e9 ac 00 00 00       	jmp    8015e1 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801535:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801538:	89 d0                	mov    %edx,%eax
  80153a:	01 c0                	add    %eax,%eax
  80153c:	01 d0                	add    %edx,%eax
  80153e:	c1 e0 02             	shl    $0x2,%eax
  801541:	05 24 31 80 00       	add    $0x803124,%eax
  801546:	8b 00                	mov    (%eax),%eax
  801548:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80154b:	eb 7e                	jmp    8015cb <malloc+0x314>
			int flag=0;
  80154d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801554:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  80155b:	eb 57                	jmp    8015b4 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  80155d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801560:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801567:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80156a:	39 c2                	cmp    %eax,%edx
  80156c:	77 1a                	ja     801588 <malloc+0x2d1>
  80156e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801571:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801578:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80157b:	39 c2                	cmp    %eax,%edx
  80157d:	76 09                	jbe    801588 <malloc+0x2d1>
								flag=1;
  80157f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801586:	eb 36                	jmp    8015be <malloc+0x307>
			arr[i].space++;
  801588:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80158b:	89 d0                	mov    %edx,%eax
  80158d:	01 c0                	add    %eax,%eax
  80158f:	01 d0                	add    %edx,%eax
  801591:	c1 e0 02             	shl    $0x2,%eax
  801594:	05 28 31 80 00       	add    $0x803128,%eax
  801599:	8b 00                	mov    (%eax),%eax
  80159b:	8d 48 01             	lea    0x1(%eax),%ecx
  80159e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8015a1:	89 d0                	mov    %edx,%eax
  8015a3:	01 c0                	add    %eax,%eax
  8015a5:	01 d0                	add    %edx,%eax
  8015a7:	c1 e0 02             	shl    $0x2,%eax
  8015aa:	05 28 31 80 00       	add    $0x803128,%eax
  8015af:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  8015b1:	ff 45 c0             	incl   -0x40(%ebp)
  8015b4:	a1 28 30 80 00       	mov    0x803028,%eax
  8015b9:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  8015bc:	7c 9f                	jl     80155d <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  8015be:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8015c2:	75 19                	jne    8015dd <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8015c4:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8015cb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8015ce:	a1 04 30 80 00       	mov    0x803004,%eax
  8015d3:	39 c2                	cmp    %eax,%edx
  8015d5:	0f 82 72 ff ff ff    	jb     80154d <malloc+0x296>
  8015db:	eb 01                	jmp    8015de <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  8015dd:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  8015de:	ff 45 cc             	incl   -0x34(%ebp)
  8015e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8015e4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015e7:	0f 8c 48 ff ff ff    	jl     801535 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  8015ed:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  8015f4:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  8015fb:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801602:	eb 37                	jmp    80163b <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801604:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801607:	89 d0                	mov    %edx,%eax
  801609:	01 c0                	add    %eax,%eax
  80160b:	01 d0                	add    %edx,%eax
  80160d:	c1 e0 02             	shl    $0x2,%eax
  801610:	05 28 31 80 00       	add    $0x803128,%eax
  801615:	8b 00                	mov    (%eax),%eax
  801617:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80161a:	7d 1c                	jge    801638 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  80161c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80161f:	89 d0                	mov    %edx,%eax
  801621:	01 c0                	add    %eax,%eax
  801623:	01 d0                	add    %edx,%eax
  801625:	c1 e0 02             	shl    $0x2,%eax
  801628:	05 28 31 80 00       	add    $0x803128,%eax
  80162d:	8b 00                	mov    (%eax),%eax
  80162f:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801632:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801635:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801638:	ff 45 b4             	incl   -0x4c(%ebp)
  80163b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80163e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801641:	7c c1                	jl     801604 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801643:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801649:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  80164c:	89 c8                	mov    %ecx,%eax
  80164e:	01 c0                	add    %eax,%eax
  801650:	01 c8                	add    %ecx,%eax
  801652:	c1 e0 02             	shl    $0x2,%eax
  801655:	05 20 31 80 00       	add    $0x803120,%eax
  80165a:	8b 00                	mov    (%eax),%eax
  80165c:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801663:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801669:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  80166c:	89 c8                	mov    %ecx,%eax
  80166e:	01 c0                	add    %eax,%eax
  801670:	01 c8                	add    %ecx,%eax
  801672:	c1 e0 02             	shl    $0x2,%eax
  801675:	05 24 31 80 00       	add    $0x803124,%eax
  80167a:	8b 00                	mov    (%eax),%eax
  80167c:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  801683:	a1 28 30 80 00       	mov    0x803028,%eax
  801688:	40                   	inc    %eax
  801689:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  80168e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801691:	89 d0                	mov    %edx,%eax
  801693:	01 c0                	add    %eax,%eax
  801695:	01 d0                	add    %edx,%eax
  801697:	c1 e0 02             	shl    $0x2,%eax
  80169a:	05 20 31 80 00       	add    $0x803120,%eax
  80169f:	8b 00                	mov    (%eax),%eax
  8016a1:	83 ec 08             	sub    $0x8,%esp
  8016a4:	ff 75 08             	pushl  0x8(%ebp)
  8016a7:	50                   	push   %eax
  8016a8:	e8 48 04 00 00       	call   801af5 <sys_allocateMem>
  8016ad:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  8016b0:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8016b7:	eb 78                	jmp    801731 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8016b9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8016bc:	89 d0                	mov    %edx,%eax
  8016be:	01 c0                	add    %eax,%eax
  8016c0:	01 d0                	add    %edx,%eax
  8016c2:	c1 e0 02             	shl    $0x2,%eax
  8016c5:	05 20 31 80 00       	add    $0x803120,%eax
  8016ca:	8b 00                	mov    (%eax),%eax
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	50                   	push   %eax
  8016d0:	ff 75 b0             	pushl  -0x50(%ebp)
  8016d3:	68 50 29 80 00       	push   $0x802950
  8016d8:	e8 50 ee ff ff       	call   80052d <cprintf>
  8016dd:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8016e0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8016e3:	89 d0                	mov    %edx,%eax
  8016e5:	01 c0                	add    %eax,%eax
  8016e7:	01 d0                	add    %edx,%eax
  8016e9:	c1 e0 02             	shl    $0x2,%eax
  8016ec:	05 24 31 80 00       	add    $0x803124,%eax
  8016f1:	8b 00                	mov    (%eax),%eax
  8016f3:	83 ec 04             	sub    $0x4,%esp
  8016f6:	50                   	push   %eax
  8016f7:	ff 75 b0             	pushl  -0x50(%ebp)
  8016fa:	68 65 29 80 00       	push   $0x802965
  8016ff:	e8 29 ee ff ff       	call   80052d <cprintf>
  801704:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801707:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80170a:	89 d0                	mov    %edx,%eax
  80170c:	01 c0                	add    %eax,%eax
  80170e:	01 d0                	add    %edx,%eax
  801710:	c1 e0 02             	shl    $0x2,%eax
  801713:	05 28 31 80 00       	add    $0x803128,%eax
  801718:	8b 00                	mov    (%eax),%eax
  80171a:	83 ec 04             	sub    $0x4,%esp
  80171d:	50                   	push   %eax
  80171e:	ff 75 b0             	pushl  -0x50(%ebp)
  801721:	68 78 29 80 00       	push   $0x802978
  801726:	e8 02 ee ff ff       	call   80052d <cprintf>
  80172b:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  80172e:	ff 45 b0             	incl   -0x50(%ebp)
  801731:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801734:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801737:	7c 80                	jl     8016b9 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801739:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80173c:	89 d0                	mov    %edx,%eax
  80173e:	01 c0                	add    %eax,%eax
  801740:	01 d0                	add    %edx,%eax
  801742:	c1 e0 02             	shl    $0x2,%eax
  801745:	05 20 31 80 00       	add    $0x803120,%eax
  80174a:	8b 00                	mov    (%eax),%eax
  80174c:	83 ec 08             	sub    $0x8,%esp
  80174f:	50                   	push   %eax
  801750:	68 8c 29 80 00       	push   $0x80298c
  801755:	e8 d3 ed ff ff       	call   80052d <cprintf>
  80175a:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  80175d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801760:	89 d0                	mov    %edx,%eax
  801762:	01 c0                	add    %eax,%eax
  801764:	01 d0                	add    %edx,%eax
  801766:	c1 e0 02             	shl    $0x2,%eax
  801769:	05 20 31 80 00       	add    $0x803120,%eax
  80176e:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  80177e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801785:	eb 4b                	jmp    8017d2 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801787:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178a:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801791:	89 c2                	mov    %eax,%edx
  801793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801796:	39 c2                	cmp    %eax,%edx
  801798:	7f 35                	jg     8017cf <free+0x5d>
  80179a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179d:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8017a4:	89 c2                	mov    %eax,%edx
  8017a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a9:	39 c2                	cmp    %eax,%edx
  8017ab:	7e 22                	jle    8017cf <free+0x5d>
				start=arr_add[i].start;
  8017ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b0:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8017b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bd:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8017c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8017c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8017cd:	eb 0d                	jmp    8017dc <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8017cf:	ff 45 ec             	incl   -0x14(%ebp)
  8017d2:	a1 28 30 80 00       	mov    0x803028,%eax
  8017d7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8017da:	7c ab                	jl     801787 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8017dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017df:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8017e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e9:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8017f0:	29 c2                	sub    %eax,%edx
  8017f2:	89 d0                	mov    %edx,%eax
  8017f4:	83 ec 08             	sub    $0x8,%esp
  8017f7:	50                   	push   %eax
  8017f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fb:	e8 d9 02 00 00       	call   801ad9 <sys_freeMem>
  801800:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801806:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801809:	eb 2d                	jmp    801838 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  80180b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80180e:	40                   	inc    %eax
  80180f:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801816:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801819:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801820:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801823:	40                   	inc    %eax
  801824:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80182b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80182e:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801835:	ff 45 e8             	incl   -0x18(%ebp)
  801838:	a1 28 30 80 00       	mov    0x803028,%eax
  80183d:	48                   	dec    %eax
  80183e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801841:	7f c8                	jg     80180b <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801843:	a1 28 30 80 00       	mov    0x803028,%eax
  801848:	48                   	dec    %eax
  801849:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  80184e:	90                   	nop
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 18             	sub    $0x18,%esp
  801857:	8b 45 10             	mov    0x10(%ebp),%eax
  80185a:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  80185d:	83 ec 04             	sub    $0x4,%esp
  801860:	68 a8 29 80 00       	push   $0x8029a8
  801865:	68 18 01 00 00       	push   $0x118
  80186a:	68 cb 29 80 00       	push   $0x8029cb
  80186f:	e8 17 ea ff ff       	call   80028b <_panic>

00801874 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80187a:	83 ec 04             	sub    $0x4,%esp
  80187d:	68 a8 29 80 00       	push   $0x8029a8
  801882:	68 1e 01 00 00       	push   $0x11e
  801887:	68 cb 29 80 00       	push   $0x8029cb
  80188c:	e8 fa e9 ff ff       	call   80028b <_panic>

00801891 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801897:	83 ec 04             	sub    $0x4,%esp
  80189a:	68 a8 29 80 00       	push   $0x8029a8
  80189f:	68 24 01 00 00       	push   $0x124
  8018a4:	68 cb 29 80 00       	push   $0x8029cb
  8018a9:	e8 dd e9 ff ff       	call   80028b <_panic>

008018ae <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	68 a8 29 80 00       	push   $0x8029a8
  8018bc:	68 29 01 00 00       	push   $0x129
  8018c1:	68 cb 29 80 00       	push   $0x8029cb
  8018c6:	e8 c0 e9 ff ff       	call   80028b <_panic>

008018cb <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018d1:	83 ec 04             	sub    $0x4,%esp
  8018d4:	68 a8 29 80 00       	push   $0x8029a8
  8018d9:	68 2f 01 00 00       	push   $0x12f
  8018de:	68 cb 29 80 00       	push   $0x8029cb
  8018e3:	e8 a3 e9 ff ff       	call   80028b <_panic>

008018e8 <shrink>:
}
void shrink(uint32 newSize)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	68 a8 29 80 00       	push   $0x8029a8
  8018f6:	68 33 01 00 00       	push   $0x133
  8018fb:	68 cb 29 80 00       	push   $0x8029cb
  801900:	e8 86 e9 ff ff       	call   80028b <_panic>

00801905 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80190b:	83 ec 04             	sub    $0x4,%esp
  80190e:	68 a8 29 80 00       	push   $0x8029a8
  801913:	68 38 01 00 00       	push   $0x138
  801918:	68 cb 29 80 00       	push   $0x8029cb
  80191d:	e8 69 e9 ff ff       	call   80028b <_panic>

00801922 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	57                   	push   %edi
  801926:	56                   	push   %esi
  801927:	53                   	push   %ebx
  801928:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801931:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801934:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801937:	8b 7d 18             	mov    0x18(%ebp),%edi
  80193a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80193d:	cd 30                	int    $0x30
  80193f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801942:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	5b                   	pop    %ebx
  801949:	5e                   	pop    %esi
  80194a:	5f                   	pop    %edi
  80194b:	5d                   	pop    %ebp
  80194c:	c3                   	ret    

0080194d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 04             	sub    $0x4,%esp
  801953:	8b 45 10             	mov    0x10(%ebp),%eax
  801956:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801959:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	52                   	push   %edx
  801965:	ff 75 0c             	pushl  0xc(%ebp)
  801968:	50                   	push   %eax
  801969:	6a 00                	push   $0x0
  80196b:	e8 b2 ff ff ff       	call   801922 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	90                   	nop
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_cgetc>:

int
sys_cgetc(void)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 01                	push   $0x1
  801985:	e8 98 ff ff ff       	call   801922 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	50                   	push   %eax
  80199e:	6a 05                	push   $0x5
  8019a0:	e8 7d ff ff ff       	call   801922 <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 02                	push   $0x2
  8019b9:	e8 64 ff ff ff       	call   801922 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 03                	push   $0x3
  8019d2:	e8 4b ff ff ff       	call   801922 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 04                	push   $0x4
  8019eb:	e8 32 ff ff ff       	call   801922 <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_env_exit>:


void sys_env_exit(void)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 06                	push   $0x6
  801a04:	e8 19 ff ff ff       	call   801922 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	90                   	nop
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	52                   	push   %edx
  801a1f:	50                   	push   %eax
  801a20:	6a 07                	push   $0x7
  801a22:	e8 fb fe ff ff       	call   801922 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	56                   	push   %esi
  801a30:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a31:	8b 75 18             	mov    0x18(%ebp),%esi
  801a34:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a37:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	56                   	push   %esi
  801a41:	53                   	push   %ebx
  801a42:	51                   	push   %ecx
  801a43:	52                   	push   %edx
  801a44:	50                   	push   %eax
  801a45:	6a 08                	push   $0x8
  801a47:	e8 d6 fe ff ff       	call   801922 <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
}
  801a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a52:	5b                   	pop    %ebx
  801a53:	5e                   	pop    %esi
  801a54:	5d                   	pop    %ebp
  801a55:	c3                   	ret    

00801a56 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	52                   	push   %edx
  801a66:	50                   	push   %eax
  801a67:	6a 09                	push   $0x9
  801a69:	e8 b4 fe ff ff       	call   801922 <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	ff 75 0c             	pushl  0xc(%ebp)
  801a7f:	ff 75 08             	pushl  0x8(%ebp)
  801a82:	6a 0a                	push   $0xa
  801a84:	e8 99 fe ff ff       	call   801922 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 0b                	push   $0xb
  801a9d:	e8 80 fe ff ff       	call   801922 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 0c                	push   $0xc
  801ab6:	e8 67 fe ff ff       	call   801922 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 0d                	push   $0xd
  801acf:	e8 4e fe ff ff       	call   801922 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	ff 75 0c             	pushl  0xc(%ebp)
  801ae5:	ff 75 08             	pushl  0x8(%ebp)
  801ae8:	6a 11                	push   $0x11
  801aea:	e8 33 fe ff ff       	call   801922 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
	return;
  801af2:	90                   	nop
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	ff 75 0c             	pushl  0xc(%ebp)
  801b01:	ff 75 08             	pushl  0x8(%ebp)
  801b04:	6a 12                	push   $0x12
  801b06:	e8 17 fe ff ff       	call   801922 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0e:	90                   	nop
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 0e                	push   $0xe
  801b20:	e8 fd fd ff ff       	call   801922 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	ff 75 08             	pushl  0x8(%ebp)
  801b38:	6a 0f                	push   $0xf
  801b3a:	e8 e3 fd ff ff       	call   801922 <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 10                	push   $0x10
  801b53:	e8 ca fd ff ff       	call   801922 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	90                   	nop
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 14                	push   $0x14
  801b6d:	e8 b0 fd ff ff       	call   801922 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	90                   	nop
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 15                	push   $0x15
  801b87:	e8 96 fd ff ff       	call   801922 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	90                   	nop
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b9e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	50                   	push   %eax
  801bab:	6a 16                	push   $0x16
  801bad:	e8 70 fd ff ff       	call   801922 <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
}
  801bb5:	90                   	nop
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 17                	push   $0x17
  801bc7:	e8 56 fd ff ff       	call   801922 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	90                   	nop
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	ff 75 0c             	pushl  0xc(%ebp)
  801be1:	50                   	push   %eax
  801be2:	6a 18                	push   $0x18
  801be4:	e8 39 fd ff ff       	call   801922 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	52                   	push   %edx
  801bfe:	50                   	push   %eax
  801bff:	6a 1b                	push   $0x1b
  801c01:	e8 1c fd ff ff       	call   801922 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	52                   	push   %edx
  801c1b:	50                   	push   %eax
  801c1c:	6a 19                	push   $0x19
  801c1e:	e8 ff fc ff ff       	call   801922 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	90                   	nop
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	52                   	push   %edx
  801c39:	50                   	push   %eax
  801c3a:	6a 1a                	push   $0x1a
  801c3c:	e8 e1 fc ff ff       	call   801922 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	90                   	nop
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	83 ec 04             	sub    $0x4,%esp
  801c4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c50:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c53:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c56:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	6a 00                	push   $0x0
  801c5f:	51                   	push   %ecx
  801c60:	52                   	push   %edx
  801c61:	ff 75 0c             	pushl  0xc(%ebp)
  801c64:	50                   	push   %eax
  801c65:	6a 1c                	push   $0x1c
  801c67:	e8 b6 fc ff ff       	call   801922 <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	52                   	push   %edx
  801c81:	50                   	push   %eax
  801c82:	6a 1d                	push   $0x1d
  801c84:	e8 99 fc ff ff       	call   801922 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c91:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	51                   	push   %ecx
  801c9f:	52                   	push   %edx
  801ca0:	50                   	push   %eax
  801ca1:	6a 1e                	push   $0x1e
  801ca3:	e8 7a fc ff ff       	call   801922 <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	52                   	push   %edx
  801cbd:	50                   	push   %eax
  801cbe:	6a 1f                	push   $0x1f
  801cc0:	e8 5d fc ff ff       	call   801922 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 20                	push   $0x20
  801cd9:	e8 44 fc ff ff       	call   801922 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	6a 00                	push   $0x0
  801ceb:	ff 75 14             	pushl  0x14(%ebp)
  801cee:	ff 75 10             	pushl  0x10(%ebp)
  801cf1:	ff 75 0c             	pushl  0xc(%ebp)
  801cf4:	50                   	push   %eax
  801cf5:	6a 21                	push   $0x21
  801cf7:	e8 26 fc ff ff       	call   801922 <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	50                   	push   %eax
  801d10:	6a 22                	push   $0x22
  801d12:	e8 0b fc ff ff       	call   801922 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	90                   	nop
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	50                   	push   %eax
  801d2c:	6a 23                	push   $0x23
  801d2e:	e8 ef fb ff ff       	call   801922 <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
}
  801d36:	90                   	nop
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d3f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d42:	8d 50 04             	lea    0x4(%eax),%edx
  801d45:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	52                   	push   %edx
  801d4f:	50                   	push   %eax
  801d50:	6a 24                	push   $0x24
  801d52:	e8 cb fb ff ff       	call   801922 <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
	return result;
  801d5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d63:	89 01                	mov    %eax,(%ecx)
  801d65:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	c9                   	leave  
  801d6c:	c2 04 00             	ret    $0x4

00801d6f <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	ff 75 10             	pushl  0x10(%ebp)
  801d79:	ff 75 0c             	pushl  0xc(%ebp)
  801d7c:	ff 75 08             	pushl  0x8(%ebp)
  801d7f:	6a 13                	push   $0x13
  801d81:	e8 9c fb ff ff       	call   801922 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
	return ;
  801d89:	90                   	nop
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_rcr2>:
uint32 sys_rcr2()
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 25                	push   $0x25
  801d9b:	e8 82 fb ff ff       	call   801922 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 04             	sub    $0x4,%esp
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801db1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	50                   	push   %eax
  801dbe:	6a 26                	push   $0x26
  801dc0:	e8 5d fb ff ff       	call   801922 <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc8:	90                   	nop
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <rsttst>:
void rsttst()
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 28                	push   $0x28
  801dda:	e8 43 fb ff ff       	call   801922 <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
	return ;
  801de2:	90                   	nop
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 04             	sub    $0x4,%esp
  801deb:	8b 45 14             	mov    0x14(%ebp),%eax
  801dee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801df1:	8b 55 18             	mov    0x18(%ebp),%edx
  801df4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801df8:	52                   	push   %edx
  801df9:	50                   	push   %eax
  801dfa:	ff 75 10             	pushl  0x10(%ebp)
  801dfd:	ff 75 0c             	pushl  0xc(%ebp)
  801e00:	ff 75 08             	pushl  0x8(%ebp)
  801e03:	6a 27                	push   $0x27
  801e05:	e8 18 fb ff ff       	call   801922 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0d:	90                   	nop
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <chktst>:
void chktst(uint32 n)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	ff 75 08             	pushl  0x8(%ebp)
  801e1e:	6a 29                	push   $0x29
  801e20:	e8 fd fa ff ff       	call   801922 <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
	return ;
  801e28:	90                   	nop
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <inctst>:

void inctst()
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 2a                	push   $0x2a
  801e3a:	e8 e3 fa ff ff       	call   801922 <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e42:	90                   	nop
}
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <gettst>:
uint32 gettst()
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 2b                	push   $0x2b
  801e54:	e8 c9 fa ff ff       	call   801922 <syscall>
  801e59:	83 c4 18             	add    $0x18,%esp
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 2c                	push   $0x2c
  801e70:	e8 ad fa ff ff       	call   801922 <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
  801e78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e7b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e7f:	75 07                	jne    801e88 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e81:	b8 01 00 00 00       	mov    $0x1,%eax
  801e86:	eb 05                	jmp    801e8d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 2c                	push   $0x2c
  801ea1:	e8 7c fa ff ff       	call   801922 <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
  801ea9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801eac:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801eb0:	75 07                	jne    801eb9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb7:	eb 05                	jmp    801ebe <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801eb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 2c                	push   $0x2c
  801ed2:	e8 4b fa ff ff       	call   801922 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
  801eda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801edd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ee1:	75 07                	jne    801eea <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ee3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee8:	eb 05                	jmp    801eef <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801eea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 2c                	push   $0x2c
  801f03:	e8 1a fa ff ff       	call   801922 <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
  801f0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f0e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f12:	75 07                	jne    801f1b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f14:	b8 01 00 00 00       	mov    $0x1,%eax
  801f19:	eb 05                	jmp    801f20 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	ff 75 08             	pushl  0x8(%ebp)
  801f30:	6a 2d                	push   $0x2d
  801f32:	e8 eb f9 ff ff       	call   801922 <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
	return ;
  801f3a:	90                   	nop
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f41:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f44:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	6a 00                	push   $0x0
  801f4f:	53                   	push   %ebx
  801f50:	51                   	push   %ecx
  801f51:	52                   	push   %edx
  801f52:	50                   	push   %eax
  801f53:	6a 2e                	push   $0x2e
  801f55:	e8 c8 f9 ff ff       	call   801922 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
}
  801f5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f68:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	52                   	push   %edx
  801f72:	50                   	push   %eax
  801f73:	6a 2f                	push   $0x2f
  801f75:	e8 a8 f9 ff ff       	call   801922 <syscall>
  801f7a:	83 c4 18             	add    $0x18,%esp
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    
  801f7f:	90                   	nop

00801f80 <__udivdi3>:
  801f80:	55                   	push   %ebp
  801f81:	57                   	push   %edi
  801f82:	56                   	push   %esi
  801f83:	53                   	push   %ebx
  801f84:	83 ec 1c             	sub    $0x1c,%esp
  801f87:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f8b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f97:	89 ca                	mov    %ecx,%edx
  801f99:	89 f8                	mov    %edi,%eax
  801f9b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f9f:	85 f6                	test   %esi,%esi
  801fa1:	75 2d                	jne    801fd0 <__udivdi3+0x50>
  801fa3:	39 cf                	cmp    %ecx,%edi
  801fa5:	77 65                	ja     80200c <__udivdi3+0x8c>
  801fa7:	89 fd                	mov    %edi,%ebp
  801fa9:	85 ff                	test   %edi,%edi
  801fab:	75 0b                	jne    801fb8 <__udivdi3+0x38>
  801fad:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb2:	31 d2                	xor    %edx,%edx
  801fb4:	f7 f7                	div    %edi
  801fb6:	89 c5                	mov    %eax,%ebp
  801fb8:	31 d2                	xor    %edx,%edx
  801fba:	89 c8                	mov    %ecx,%eax
  801fbc:	f7 f5                	div    %ebp
  801fbe:	89 c1                	mov    %eax,%ecx
  801fc0:	89 d8                	mov    %ebx,%eax
  801fc2:	f7 f5                	div    %ebp
  801fc4:	89 cf                	mov    %ecx,%edi
  801fc6:	89 fa                	mov    %edi,%edx
  801fc8:	83 c4 1c             	add    $0x1c,%esp
  801fcb:	5b                   	pop    %ebx
  801fcc:	5e                   	pop    %esi
  801fcd:	5f                   	pop    %edi
  801fce:	5d                   	pop    %ebp
  801fcf:	c3                   	ret    
  801fd0:	39 ce                	cmp    %ecx,%esi
  801fd2:	77 28                	ja     801ffc <__udivdi3+0x7c>
  801fd4:	0f bd fe             	bsr    %esi,%edi
  801fd7:	83 f7 1f             	xor    $0x1f,%edi
  801fda:	75 40                	jne    80201c <__udivdi3+0x9c>
  801fdc:	39 ce                	cmp    %ecx,%esi
  801fde:	72 0a                	jb     801fea <__udivdi3+0x6a>
  801fe0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801fe4:	0f 87 9e 00 00 00    	ja     802088 <__udivdi3+0x108>
  801fea:	b8 01 00 00 00       	mov    $0x1,%eax
  801fef:	89 fa                	mov    %edi,%edx
  801ff1:	83 c4 1c             	add    $0x1c,%esp
  801ff4:	5b                   	pop    %ebx
  801ff5:	5e                   	pop    %esi
  801ff6:	5f                   	pop    %edi
  801ff7:	5d                   	pop    %ebp
  801ff8:	c3                   	ret    
  801ff9:	8d 76 00             	lea    0x0(%esi),%esi
  801ffc:	31 ff                	xor    %edi,%edi
  801ffe:	31 c0                	xor    %eax,%eax
  802000:	89 fa                	mov    %edi,%edx
  802002:	83 c4 1c             	add    $0x1c,%esp
  802005:	5b                   	pop    %ebx
  802006:	5e                   	pop    %esi
  802007:	5f                   	pop    %edi
  802008:	5d                   	pop    %ebp
  802009:	c3                   	ret    
  80200a:	66 90                	xchg   %ax,%ax
  80200c:	89 d8                	mov    %ebx,%eax
  80200e:	f7 f7                	div    %edi
  802010:	31 ff                	xor    %edi,%edi
  802012:	89 fa                	mov    %edi,%edx
  802014:	83 c4 1c             	add    $0x1c,%esp
  802017:	5b                   	pop    %ebx
  802018:	5e                   	pop    %esi
  802019:	5f                   	pop    %edi
  80201a:	5d                   	pop    %ebp
  80201b:	c3                   	ret    
  80201c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802021:	89 eb                	mov    %ebp,%ebx
  802023:	29 fb                	sub    %edi,%ebx
  802025:	89 f9                	mov    %edi,%ecx
  802027:	d3 e6                	shl    %cl,%esi
  802029:	89 c5                	mov    %eax,%ebp
  80202b:	88 d9                	mov    %bl,%cl
  80202d:	d3 ed                	shr    %cl,%ebp
  80202f:	89 e9                	mov    %ebp,%ecx
  802031:	09 f1                	or     %esi,%ecx
  802033:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802037:	89 f9                	mov    %edi,%ecx
  802039:	d3 e0                	shl    %cl,%eax
  80203b:	89 c5                	mov    %eax,%ebp
  80203d:	89 d6                	mov    %edx,%esi
  80203f:	88 d9                	mov    %bl,%cl
  802041:	d3 ee                	shr    %cl,%esi
  802043:	89 f9                	mov    %edi,%ecx
  802045:	d3 e2                	shl    %cl,%edx
  802047:	8b 44 24 08          	mov    0x8(%esp),%eax
  80204b:	88 d9                	mov    %bl,%cl
  80204d:	d3 e8                	shr    %cl,%eax
  80204f:	09 c2                	or     %eax,%edx
  802051:	89 d0                	mov    %edx,%eax
  802053:	89 f2                	mov    %esi,%edx
  802055:	f7 74 24 0c          	divl   0xc(%esp)
  802059:	89 d6                	mov    %edx,%esi
  80205b:	89 c3                	mov    %eax,%ebx
  80205d:	f7 e5                	mul    %ebp
  80205f:	39 d6                	cmp    %edx,%esi
  802061:	72 19                	jb     80207c <__udivdi3+0xfc>
  802063:	74 0b                	je     802070 <__udivdi3+0xf0>
  802065:	89 d8                	mov    %ebx,%eax
  802067:	31 ff                	xor    %edi,%edi
  802069:	e9 58 ff ff ff       	jmp    801fc6 <__udivdi3+0x46>
  80206e:	66 90                	xchg   %ax,%ax
  802070:	8b 54 24 08          	mov    0x8(%esp),%edx
  802074:	89 f9                	mov    %edi,%ecx
  802076:	d3 e2                	shl    %cl,%edx
  802078:	39 c2                	cmp    %eax,%edx
  80207a:	73 e9                	jae    802065 <__udivdi3+0xe5>
  80207c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80207f:	31 ff                	xor    %edi,%edi
  802081:	e9 40 ff ff ff       	jmp    801fc6 <__udivdi3+0x46>
  802086:	66 90                	xchg   %ax,%ax
  802088:	31 c0                	xor    %eax,%eax
  80208a:	e9 37 ff ff ff       	jmp    801fc6 <__udivdi3+0x46>
  80208f:	90                   	nop

00802090 <__umoddi3>:
  802090:	55                   	push   %ebp
  802091:	57                   	push   %edi
  802092:	56                   	push   %esi
  802093:	53                   	push   %ebx
  802094:	83 ec 1c             	sub    $0x1c,%esp
  802097:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80209b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80209f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8020a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020af:	89 f3                	mov    %esi,%ebx
  8020b1:	89 fa                	mov    %edi,%edx
  8020b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020b7:	89 34 24             	mov    %esi,(%esp)
  8020ba:	85 c0                	test   %eax,%eax
  8020bc:	75 1a                	jne    8020d8 <__umoddi3+0x48>
  8020be:	39 f7                	cmp    %esi,%edi
  8020c0:	0f 86 a2 00 00 00    	jbe    802168 <__umoddi3+0xd8>
  8020c6:	89 c8                	mov    %ecx,%eax
  8020c8:	89 f2                	mov    %esi,%edx
  8020ca:	f7 f7                	div    %edi
  8020cc:	89 d0                	mov    %edx,%eax
  8020ce:	31 d2                	xor    %edx,%edx
  8020d0:	83 c4 1c             	add    $0x1c,%esp
  8020d3:	5b                   	pop    %ebx
  8020d4:	5e                   	pop    %esi
  8020d5:	5f                   	pop    %edi
  8020d6:	5d                   	pop    %ebp
  8020d7:	c3                   	ret    
  8020d8:	39 f0                	cmp    %esi,%eax
  8020da:	0f 87 ac 00 00 00    	ja     80218c <__umoddi3+0xfc>
  8020e0:	0f bd e8             	bsr    %eax,%ebp
  8020e3:	83 f5 1f             	xor    $0x1f,%ebp
  8020e6:	0f 84 ac 00 00 00    	je     802198 <__umoddi3+0x108>
  8020ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8020f1:	29 ef                	sub    %ebp,%edi
  8020f3:	89 fe                	mov    %edi,%esi
  8020f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020f9:	89 e9                	mov    %ebp,%ecx
  8020fb:	d3 e0                	shl    %cl,%eax
  8020fd:	89 d7                	mov    %edx,%edi
  8020ff:	89 f1                	mov    %esi,%ecx
  802101:	d3 ef                	shr    %cl,%edi
  802103:	09 c7                	or     %eax,%edi
  802105:	89 e9                	mov    %ebp,%ecx
  802107:	d3 e2                	shl    %cl,%edx
  802109:	89 14 24             	mov    %edx,(%esp)
  80210c:	89 d8                	mov    %ebx,%eax
  80210e:	d3 e0                	shl    %cl,%eax
  802110:	89 c2                	mov    %eax,%edx
  802112:	8b 44 24 08          	mov    0x8(%esp),%eax
  802116:	d3 e0                	shl    %cl,%eax
  802118:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802120:	89 f1                	mov    %esi,%ecx
  802122:	d3 e8                	shr    %cl,%eax
  802124:	09 d0                	or     %edx,%eax
  802126:	d3 eb                	shr    %cl,%ebx
  802128:	89 da                	mov    %ebx,%edx
  80212a:	f7 f7                	div    %edi
  80212c:	89 d3                	mov    %edx,%ebx
  80212e:	f7 24 24             	mull   (%esp)
  802131:	89 c6                	mov    %eax,%esi
  802133:	89 d1                	mov    %edx,%ecx
  802135:	39 d3                	cmp    %edx,%ebx
  802137:	0f 82 87 00 00 00    	jb     8021c4 <__umoddi3+0x134>
  80213d:	0f 84 91 00 00 00    	je     8021d4 <__umoddi3+0x144>
  802143:	8b 54 24 04          	mov    0x4(%esp),%edx
  802147:	29 f2                	sub    %esi,%edx
  802149:	19 cb                	sbb    %ecx,%ebx
  80214b:	89 d8                	mov    %ebx,%eax
  80214d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802151:	d3 e0                	shl    %cl,%eax
  802153:	89 e9                	mov    %ebp,%ecx
  802155:	d3 ea                	shr    %cl,%edx
  802157:	09 d0                	or     %edx,%eax
  802159:	89 e9                	mov    %ebp,%ecx
  80215b:	d3 eb                	shr    %cl,%ebx
  80215d:	89 da                	mov    %ebx,%edx
  80215f:	83 c4 1c             	add    $0x1c,%esp
  802162:	5b                   	pop    %ebx
  802163:	5e                   	pop    %esi
  802164:	5f                   	pop    %edi
  802165:	5d                   	pop    %ebp
  802166:	c3                   	ret    
  802167:	90                   	nop
  802168:	89 fd                	mov    %edi,%ebp
  80216a:	85 ff                	test   %edi,%edi
  80216c:	75 0b                	jne    802179 <__umoddi3+0xe9>
  80216e:	b8 01 00 00 00       	mov    $0x1,%eax
  802173:	31 d2                	xor    %edx,%edx
  802175:	f7 f7                	div    %edi
  802177:	89 c5                	mov    %eax,%ebp
  802179:	89 f0                	mov    %esi,%eax
  80217b:	31 d2                	xor    %edx,%edx
  80217d:	f7 f5                	div    %ebp
  80217f:	89 c8                	mov    %ecx,%eax
  802181:	f7 f5                	div    %ebp
  802183:	89 d0                	mov    %edx,%eax
  802185:	e9 44 ff ff ff       	jmp    8020ce <__umoddi3+0x3e>
  80218a:	66 90                	xchg   %ax,%ax
  80218c:	89 c8                	mov    %ecx,%eax
  80218e:	89 f2                	mov    %esi,%edx
  802190:	83 c4 1c             	add    $0x1c,%esp
  802193:	5b                   	pop    %ebx
  802194:	5e                   	pop    %esi
  802195:	5f                   	pop    %edi
  802196:	5d                   	pop    %ebp
  802197:	c3                   	ret    
  802198:	3b 04 24             	cmp    (%esp),%eax
  80219b:	72 06                	jb     8021a3 <__umoddi3+0x113>
  80219d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8021a1:	77 0f                	ja     8021b2 <__umoddi3+0x122>
  8021a3:	89 f2                	mov    %esi,%edx
  8021a5:	29 f9                	sub    %edi,%ecx
  8021a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8021ab:	89 14 24             	mov    %edx,(%esp)
  8021ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021b6:	8b 14 24             	mov    (%esp),%edx
  8021b9:	83 c4 1c             	add    $0x1c,%esp
  8021bc:	5b                   	pop    %ebx
  8021bd:	5e                   	pop    %esi
  8021be:	5f                   	pop    %edi
  8021bf:	5d                   	pop    %ebp
  8021c0:	c3                   	ret    
  8021c1:	8d 76 00             	lea    0x0(%esi),%esi
  8021c4:	2b 04 24             	sub    (%esp),%eax
  8021c7:	19 fa                	sbb    %edi,%edx
  8021c9:	89 d1                	mov    %edx,%ecx
  8021cb:	89 c6                	mov    %eax,%esi
  8021cd:	e9 71 ff ff ff       	jmp    802143 <__umoddi3+0xb3>
  8021d2:	66 90                	xchg   %ax,%ax
  8021d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8021d8:	72 ea                	jb     8021c4 <__umoddi3+0x134>
  8021da:	89 d9                	mov    %ebx,%ecx
  8021dc:	e9 62 ff ff ff       	jmp    802143 <__umoddi3+0xb3>
