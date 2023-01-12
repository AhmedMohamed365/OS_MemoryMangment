
obj/user/tst_envfree1:     file format elf32-i386


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
  800031:	e8 89 01 00 00       	call   8001bf <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests environment free run tef1 5 3
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing scenario 1: without using dynamic allocation/de-allocation, shared variables and semaphores
	// Testing removing the allocated pages in mem, WS, mapped page tables, env's directory and env's page file

	int freeFrames_before = sys_calculate_free_frames() ;
  80003e:	e8 59 14 00 00       	call   80149c <sys_calculate_free_frames>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800046:	e8 d4 14 00 00       	call   80151f <sys_pf_calculate_allocated_pages>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	ff 75 f4             	pushl  -0xc(%ebp)
  800054:	68 c0 1c 80 00       	push   $0x801cc0
  800059:	e8 48 05 00 00       	call   8005a6 <cprintf>
  80005e:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes

	int32 envIdProcessA = sys_create_env("ef_fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800061:	a1 20 30 80 00       	mov    0x803020,%eax
  800066:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  80006c:	89 c2                	mov    %eax,%edx
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 40 74             	mov    0x74(%eax),%eax
  800076:	6a 32                	push   $0x32
  800078:	52                   	push   %edx
  800079:	50                   	push   %eax
  80007a:	68 f3 1c 80 00       	push   $0x801cf3
  80007f:	e8 6d 16 00 00       	call   8016f1 <sys_create_env>
  800084:	83 c4 10             	add    $0x10,%esp
  800087:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int32 envIdProcessB = sys_create_env("ef_fact", (myEnv->page_WS_max_size)-1,(myEnv->SecondListSize), 50);
  80008a:	a1 20 30 80 00       	mov    0x803020,%eax
  80008f:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  800095:	89 c2                	mov    %eax,%edx
  800097:	a1 20 30 80 00       	mov    0x803020,%eax
  80009c:	8b 40 74             	mov    0x74(%eax),%eax
  80009f:	48                   	dec    %eax
  8000a0:	6a 32                	push   $0x32
  8000a2:	52                   	push   %edx
  8000a3:	50                   	push   %eax
  8000a4:	68 fa 1c 80 00       	push   $0x801cfa
  8000a9:	e8 43 16 00 00       	call   8016f1 <sys_create_env>
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessC = sys_create_env("ef_fos_add",(myEnv->page_WS_max_size)*4,(myEnv->SecondListSize), 50);
  8000b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b9:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  8000bf:	89 c2                	mov    %eax,%edx
  8000c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c6:	8b 40 74             	mov    0x74(%eax),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	6a 32                	push   $0x32
  8000ce:	52                   	push   %edx
  8000cf:	50                   	push   %eax
  8000d0:	68 02 1d 80 00       	push   $0x801d02
  8000d5:	e8 17 16 00 00       	call   8016f1 <sys_create_env>
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Run 3 processes
	sys_run_env(envIdProcessA);
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e6:	e8 24 16 00 00       	call   80170f <sys_run_env>
  8000eb:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8000f4:	e8 16 16 00 00       	call   80170f <sys_run_env>
  8000f9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessC);
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800102:	e8 08 16 00 00       	call   80170f <sys_run_env>
  800107:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	68 70 17 00 00       	push   $0x1770
  800112:	e8 76 18 00 00       	call   80198d <env_sleep>
  800117:	83 c4 10             	add    $0x10,%esp
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  80011a:	e8 7d 13 00 00       	call   80149c <sys_calculate_free_frames>
  80011f:	83 ec 08             	sub    $0x8,%esp
  800122:	50                   	push   %eax
  800123:	68 10 1d 80 00       	push   $0x801d10
  800128:	e8 79 04 00 00       	call   8005a6 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Kill the 3 processes
	sys_free_env(envIdProcessA);
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	ff 75 ec             	pushl  -0x14(%ebp)
  800136:	e8 f0 15 00 00       	call   80172b <sys_free_env>
  80013b:	83 c4 10             	add    $0x10,%esp
	sys_free_env(envIdProcessB);
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	ff 75 e8             	pushl  -0x18(%ebp)
  800144:	e8 e2 15 00 00       	call   80172b <sys_free_env>
  800149:	83 c4 10             	add    $0x10,%esp
	sys_free_env(envIdProcessC);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800152:	e8 d4 15 00 00       	call   80172b <sys_free_env>
  800157:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80015a:	e8 3d 13 00 00       	call   80149c <sys_calculate_free_frames>
  80015f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800162:	e8 b8 13 00 00       	call   80151f <sys_pf_calculate_allocated_pages>
  800167:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016a:	83 ec 08             	sub    $0x8,%esp
  80016d:	ff 75 e0             	pushl  -0x20(%ebp)
  800170:	68 44 1d 80 00       	push   $0x801d44
  800175:	e8 2c 04 00 00       	call   8005a6 <cprintf>
  80017a:	83 c4 10             	add    $0x10,%esp

	if((freeFrames_after - freeFrames_before) !=0)
  80017d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800180:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800183:	74 14                	je     800199 <_main+0x161>
		panic("env_free() does not work correctly... check it again.") ;
  800185:	83 ec 04             	sub    $0x4,%esp
  800188:	68 a4 1d 80 00       	push   $0x801da4
  80018d:	6a 27                	push   $0x27
  80018f:	68 da 1d 80 00       	push   $0x801dda
  800194:	e8 6b 01 00 00       	call   800304 <_panic>

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800199:	83 ec 08             	sub    $0x8,%esp
  80019c:	ff 75 e0             	pushl  -0x20(%ebp)
  80019f:	68 44 1d 80 00       	push   $0x801d44
  8001a4:	e8 fd 03 00 00       	call   8005a6 <cprintf>
  8001a9:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 1 for envfree completed successfully.\n");
  8001ac:	83 ec 0c             	sub    $0xc,%esp
  8001af:	68 f0 1d 80 00       	push   $0x801df0
  8001b4:	e8 ed 03 00 00       	call   8005a6 <cprintf>
  8001b9:	83 c4 10             	add    $0x10,%esp
	return;
  8001bc:	90                   	nop
}
  8001bd:	c9                   	leave  
  8001be:	c3                   	ret    

008001bf <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001c5:	e8 07 12 00 00       	call   8013d1 <sys_getenvindex>
  8001ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001d0:	89 d0                	mov    %edx,%eax
  8001d2:	c1 e0 03             	shl    $0x3,%eax
  8001d5:	01 d0                	add    %edx,%eax
  8001d7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001de:	01 c8                	add    %ecx,%eax
  8001e0:	01 c0                	add    %eax,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	01 c0                	add    %eax,%eax
  8001e6:	01 d0                	add    %edx,%eax
  8001e8:	89 c2                	mov    %eax,%edx
  8001ea:	c1 e2 05             	shl    $0x5,%edx
  8001ed:	29 c2                	sub    %eax,%edx
  8001ef:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001fe:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800203:	a1 20 30 80 00       	mov    0x803020,%eax
  800208:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80020e:	84 c0                	test   %al,%al
  800210:	74 0f                	je     800221 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800212:	a1 20 30 80 00       	mov    0x803020,%eax
  800217:	05 40 3c 01 00       	add    $0x13c40,%eax
  80021c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800221:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800225:	7e 0a                	jle    800231 <libmain+0x72>
		binaryname = argv[0];
  800227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022a:	8b 00                	mov    (%eax),%eax
  80022c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800231:	83 ec 08             	sub    $0x8,%esp
  800234:	ff 75 0c             	pushl  0xc(%ebp)
  800237:	ff 75 08             	pushl  0x8(%ebp)
  80023a:	e8 f9 fd ff ff       	call   800038 <_main>
  80023f:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800242:	e8 25 13 00 00       	call   80156c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	68 54 1e 80 00       	push   $0x801e54
  80024f:	e8 52 03 00 00       	call   8005a6 <cprintf>
  800254:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800257:	a1 20 30 80 00       	mov    0x803020,%eax
  80025c:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800262:	a1 20 30 80 00       	mov    0x803020,%eax
  800267:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80026d:	83 ec 04             	sub    $0x4,%esp
  800270:	52                   	push   %edx
  800271:	50                   	push   %eax
  800272:	68 7c 1e 80 00       	push   $0x801e7c
  800277:	e8 2a 03 00 00       	call   8005a6 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80027f:	a1 20 30 80 00       	mov    0x803020,%eax
  800284:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80028a:	a1 20 30 80 00       	mov    0x803020,%eax
  80028f:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	52                   	push   %edx
  800299:	50                   	push   %eax
  80029a:	68 a4 1e 80 00       	push   $0x801ea4
  80029f:	e8 02 03 00 00       	call   8005a6 <cprintf>
  8002a4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ac:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	50                   	push   %eax
  8002b6:	68 e5 1e 80 00       	push   $0x801ee5
  8002bb:	e8 e6 02 00 00       	call   8005a6 <cprintf>
  8002c0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002c3:	83 ec 0c             	sub    $0xc,%esp
  8002c6:	68 54 1e 80 00       	push   $0x801e54
  8002cb:	e8 d6 02 00 00       	call   8005a6 <cprintf>
  8002d0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002d3:	e8 ae 12 00 00       	call   801586 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002d8:	e8 19 00 00 00       	call   8002f6 <exit>
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8002e6:	83 ec 0c             	sub    $0xc,%esp
  8002e9:	6a 00                	push   $0x0
  8002eb:	e8 ad 10 00 00       	call   80139d <sys_env_destroy>
  8002f0:	83 c4 10             	add    $0x10,%esp
}
  8002f3:	90                   	nop
  8002f4:	c9                   	leave  
  8002f5:	c3                   	ret    

008002f6 <exit>:

void
exit(void)
{
  8002f6:	55                   	push   %ebp
  8002f7:	89 e5                	mov    %esp,%ebp
  8002f9:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002fc:	e8 02 11 00 00       	call   801403 <sys_env_exit>
}
  800301:	90                   	nop
  800302:	c9                   	leave  
  800303:	c3                   	ret    

00800304 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80030a:	8d 45 10             	lea    0x10(%ebp),%eax
  80030d:	83 c0 04             	add    $0x4,%eax
  800310:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800313:	a1 18 31 80 00       	mov    0x803118,%eax
  800318:	85 c0                	test   %eax,%eax
  80031a:	74 16                	je     800332 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80031c:	a1 18 31 80 00       	mov    0x803118,%eax
  800321:	83 ec 08             	sub    $0x8,%esp
  800324:	50                   	push   %eax
  800325:	68 fc 1e 80 00       	push   $0x801efc
  80032a:	e8 77 02 00 00       	call   8005a6 <cprintf>
  80032f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800332:	a1 00 30 80 00       	mov    0x803000,%eax
  800337:	ff 75 0c             	pushl  0xc(%ebp)
  80033a:	ff 75 08             	pushl  0x8(%ebp)
  80033d:	50                   	push   %eax
  80033e:	68 01 1f 80 00       	push   $0x801f01
  800343:	e8 5e 02 00 00       	call   8005a6 <cprintf>
  800348:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80034b:	8b 45 10             	mov    0x10(%ebp),%eax
  80034e:	83 ec 08             	sub    $0x8,%esp
  800351:	ff 75 f4             	pushl  -0xc(%ebp)
  800354:	50                   	push   %eax
  800355:	e8 e1 01 00 00       	call   80053b <vcprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80035d:	83 ec 08             	sub    $0x8,%esp
  800360:	6a 00                	push   $0x0
  800362:	68 1d 1f 80 00       	push   $0x801f1d
  800367:	e8 cf 01 00 00       	call   80053b <vcprintf>
  80036c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80036f:	e8 82 ff ff ff       	call   8002f6 <exit>

	// should not return here
	while (1) ;
  800374:	eb fe                	jmp    800374 <_panic+0x70>

00800376 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
  800379:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80037c:	a1 20 30 80 00       	mov    0x803020,%eax
  800381:	8b 50 74             	mov    0x74(%eax),%edx
  800384:	8b 45 0c             	mov    0xc(%ebp),%eax
  800387:	39 c2                	cmp    %eax,%edx
  800389:	74 14                	je     80039f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80038b:	83 ec 04             	sub    $0x4,%esp
  80038e:	68 20 1f 80 00       	push   $0x801f20
  800393:	6a 26                	push   $0x26
  800395:	68 6c 1f 80 00       	push   $0x801f6c
  80039a:	e8 65 ff ff ff       	call   800304 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80039f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003ad:	e9 b6 00 00 00       	jmp    800468 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8003b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 d0                	add    %edx,%eax
  8003c1:	8b 00                	mov    (%eax),%eax
  8003c3:	85 c0                	test   %eax,%eax
  8003c5:	75 08                	jne    8003cf <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003c7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ca:	e9 96 00 00 00       	jmp    800465 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8003cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003dd:	eb 5d                	jmp    80043c <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003df:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e4:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ed:	c1 e2 04             	shl    $0x4,%edx
  8003f0:	01 d0                	add    %edx,%eax
  8003f2:	8a 40 04             	mov    0x4(%eax),%al
  8003f5:	84 c0                	test   %al,%al
  8003f7:	75 40                	jne    800439 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fe:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800404:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800407:	c1 e2 04             	shl    $0x4,%edx
  80040a:	01 d0                	add    %edx,%eax
  80040c:	8b 00                	mov    (%eax),%eax
  80040e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800411:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800414:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800419:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80041b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800425:	8b 45 08             	mov    0x8(%ebp),%eax
  800428:	01 c8                	add    %ecx,%eax
  80042a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80042c:	39 c2                	cmp    %eax,%edx
  80042e:	75 09                	jne    800439 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800430:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800437:	eb 12                	jmp    80044b <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800439:	ff 45 e8             	incl   -0x18(%ebp)
  80043c:	a1 20 30 80 00       	mov    0x803020,%eax
  800441:	8b 50 74             	mov    0x74(%eax),%edx
  800444:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800447:	39 c2                	cmp    %eax,%edx
  800449:	77 94                	ja     8003df <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80044b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80044f:	75 14                	jne    800465 <CheckWSWithoutLastIndex+0xef>
			panic(
  800451:	83 ec 04             	sub    $0x4,%esp
  800454:	68 78 1f 80 00       	push   $0x801f78
  800459:	6a 3a                	push   $0x3a
  80045b:	68 6c 1f 80 00       	push   $0x801f6c
  800460:	e8 9f fe ff ff       	call   800304 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800465:	ff 45 f0             	incl   -0x10(%ebp)
  800468:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80046b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80046e:	0f 8c 3e ff ff ff    	jl     8003b2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800474:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800482:	eb 20                	jmp    8004a4 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800484:	a1 20 30 80 00       	mov    0x803020,%eax
  800489:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80048f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800492:	c1 e2 04             	shl    $0x4,%edx
  800495:	01 d0                	add    %edx,%eax
  800497:	8a 40 04             	mov    0x4(%eax),%al
  80049a:	3c 01                	cmp    $0x1,%al
  80049c:	75 03                	jne    8004a1 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80049e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a1:	ff 45 e0             	incl   -0x20(%ebp)
  8004a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a9:	8b 50 74             	mov    0x74(%eax),%edx
  8004ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004af:	39 c2                	cmp    %eax,%edx
  8004b1:	77 d1                	ja     800484 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004b9:	74 14                	je     8004cf <CheckWSWithoutLastIndex+0x159>
		panic(
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 cc 1f 80 00       	push   $0x801fcc
  8004c3:	6a 44                	push   $0x44
  8004c5:	68 6c 1f 80 00       	push   $0x801f6c
  8004ca:	e8 35 fe ff ff       	call   800304 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004cf:	90                   	nop
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8004e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e3:	89 0a                	mov    %ecx,(%edx)
  8004e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8004e8:	88 d1                	mov    %dl,%cl
  8004ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ed:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004fb:	75 2c                	jne    800529 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004fd:	a0 24 30 80 00       	mov    0x803024,%al
  800502:	0f b6 c0             	movzbl %al,%eax
  800505:	8b 55 0c             	mov    0xc(%ebp),%edx
  800508:	8b 12                	mov    (%edx),%edx
  80050a:	89 d1                	mov    %edx,%ecx
  80050c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80050f:	83 c2 08             	add    $0x8,%edx
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	50                   	push   %eax
  800516:	51                   	push   %ecx
  800517:	52                   	push   %edx
  800518:	e8 3e 0e 00 00       	call   80135b <sys_cputs>
  80051d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800520:	8b 45 0c             	mov    0xc(%ebp),%eax
  800523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	8b 40 04             	mov    0x4(%eax),%eax
  80052f:	8d 50 01             	lea    0x1(%eax),%edx
  800532:	8b 45 0c             	mov    0xc(%ebp),%eax
  800535:	89 50 04             	mov    %edx,0x4(%eax)
}
  800538:	90                   	nop
  800539:	c9                   	leave  
  80053a:	c3                   	ret    

0080053b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80053b:	55                   	push   %ebp
  80053c:	89 e5                	mov    %esp,%ebp
  80053e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800544:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80054b:	00 00 00 
	b.cnt = 0;
  80054e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800555:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800558:	ff 75 0c             	pushl  0xc(%ebp)
  80055b:	ff 75 08             	pushl  0x8(%ebp)
  80055e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800564:	50                   	push   %eax
  800565:	68 d2 04 80 00       	push   $0x8004d2
  80056a:	e8 11 02 00 00       	call   800780 <vprintfmt>
  80056f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800572:	a0 24 30 80 00       	mov    0x803024,%al
  800577:	0f b6 c0             	movzbl %al,%eax
  80057a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	50                   	push   %eax
  800584:	52                   	push   %edx
  800585:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80058b:	83 c0 08             	add    $0x8,%eax
  80058e:	50                   	push   %eax
  80058f:	e8 c7 0d 00 00       	call   80135b <sys_cputs>
  800594:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800597:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80059e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005a4:	c9                   	leave  
  8005a5:	c3                   	ret    

008005a6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005a6:	55                   	push   %ebp
  8005a7:	89 e5                	mov    %esp,%ebp
  8005a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ac:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c2:	50                   	push   %eax
  8005c3:	e8 73 ff ff ff       	call   80053b <vcprintf>
  8005c8:	83 c4 10             	add    $0x10,%esp
  8005cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005d1:	c9                   	leave  
  8005d2:	c3                   	ret    

008005d3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005d3:	55                   	push   %ebp
  8005d4:	89 e5                	mov    %esp,%ebp
  8005d6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005d9:	e8 8e 0f 00 00       	call   80156c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ed:	50                   	push   %eax
  8005ee:	e8 48 ff ff ff       	call   80053b <vcprintf>
  8005f3:	83 c4 10             	add    $0x10,%esp
  8005f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005f9:	e8 88 0f 00 00       	call   801586 <sys_enable_interrupt>
	return cnt;
  8005fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800601:	c9                   	leave  
  800602:	c3                   	ret    

00800603 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800603:	55                   	push   %ebp
  800604:	89 e5                	mov    %esp,%ebp
  800606:	53                   	push   %ebx
  800607:	83 ec 14             	sub    $0x14,%esp
  80060a:	8b 45 10             	mov    0x10(%ebp),%eax
  80060d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800616:	8b 45 18             	mov    0x18(%ebp),%eax
  800619:	ba 00 00 00 00       	mov    $0x0,%edx
  80061e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800621:	77 55                	ja     800678 <printnum+0x75>
  800623:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800626:	72 05                	jb     80062d <printnum+0x2a>
  800628:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80062b:	77 4b                	ja     800678 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80062d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800630:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800633:	8b 45 18             	mov    0x18(%ebp),%eax
  800636:	ba 00 00 00 00       	mov    $0x0,%edx
  80063b:	52                   	push   %edx
  80063c:	50                   	push   %eax
  80063d:	ff 75 f4             	pushl  -0xc(%ebp)
  800640:	ff 75 f0             	pushl  -0x10(%ebp)
  800643:	e8 fc 13 00 00       	call   801a44 <__udivdi3>
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	83 ec 04             	sub    $0x4,%esp
  80064e:	ff 75 20             	pushl  0x20(%ebp)
  800651:	53                   	push   %ebx
  800652:	ff 75 18             	pushl  0x18(%ebp)
  800655:	52                   	push   %edx
  800656:	50                   	push   %eax
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	ff 75 08             	pushl  0x8(%ebp)
  80065d:	e8 a1 ff ff ff       	call   800603 <printnum>
  800662:	83 c4 20             	add    $0x20,%esp
  800665:	eb 1a                	jmp    800681 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 0c             	pushl  0xc(%ebp)
  80066d:	ff 75 20             	pushl  0x20(%ebp)
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800678:	ff 4d 1c             	decl   0x1c(%ebp)
  80067b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80067f:	7f e6                	jg     800667 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800681:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800684:	bb 00 00 00 00       	mov    $0x0,%ebx
  800689:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80068c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80068f:	53                   	push   %ebx
  800690:	51                   	push   %ecx
  800691:	52                   	push   %edx
  800692:	50                   	push   %eax
  800693:	e8 bc 14 00 00       	call   801b54 <__umoddi3>
  800698:	83 c4 10             	add    $0x10,%esp
  80069b:	05 34 22 80 00       	add    $0x802234,%eax
  8006a0:	8a 00                	mov    (%eax),%al
  8006a2:	0f be c0             	movsbl %al,%eax
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	ff 75 0c             	pushl  0xc(%ebp)
  8006ab:	50                   	push   %eax
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	ff d0                	call   *%eax
  8006b1:	83 c4 10             	add    $0x10,%esp
}
  8006b4:	90                   	nop
  8006b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b8:	c9                   	leave  
  8006b9:	c3                   	ret    

008006ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006ba:	55                   	push   %ebp
  8006bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c1:	7e 1c                	jle    8006df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	8d 50 08             	lea    0x8(%eax),%edx
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	89 10                	mov    %edx,(%eax)
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	83 e8 08             	sub    $0x8,%eax
  8006d8:	8b 50 04             	mov    0x4(%eax),%edx
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	eb 40                	jmp    80071f <getuint+0x65>
	else if (lflag)
  8006df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e3:	74 1e                	je     800703 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	8d 50 04             	lea    0x4(%eax),%edx
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 10                	mov    %edx,(%eax)
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800701:	eb 1c                	jmp    80071f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	8d 50 04             	lea    0x4(%eax),%edx
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	89 10                	mov    %edx,(%eax)
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	83 e8 04             	sub    $0x4,%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80071f:	5d                   	pop    %ebp
  800720:	c3                   	ret    

00800721 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800721:	55                   	push   %ebp
  800722:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800724:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800728:	7e 1c                	jle    800746 <getint+0x25>
		return va_arg(*ap, long long);
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 50 08             	lea    0x8(%eax),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	89 10                	mov    %edx,(%eax)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	83 e8 08             	sub    $0x8,%eax
  80073f:	8b 50 04             	mov    0x4(%eax),%edx
  800742:	8b 00                	mov    (%eax),%eax
  800744:	eb 38                	jmp    80077e <getint+0x5d>
	else if (lflag)
  800746:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80074a:	74 1a                	je     800766 <getint+0x45>
		return va_arg(*ap, long);
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	8d 50 04             	lea    0x4(%eax),%edx
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	89 10                	mov    %edx,(%eax)
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	83 e8 04             	sub    $0x4,%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	99                   	cltd   
  800764:	eb 18                	jmp    80077e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	8d 50 04             	lea    0x4(%eax),%edx
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	89 10                	mov    %edx,(%eax)
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	83 e8 04             	sub    $0x4,%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	99                   	cltd   
}
  80077e:	5d                   	pop    %ebp
  80077f:	c3                   	ret    

00800780 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	56                   	push   %esi
  800784:	53                   	push   %ebx
  800785:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800788:	eb 17                	jmp    8007a1 <vprintfmt+0x21>
			if (ch == '\0')
  80078a:	85 db                	test   %ebx,%ebx
  80078c:	0f 84 af 03 00 00    	je     800b41 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	ff 75 0c             	pushl  0xc(%ebp)
  800798:	53                   	push   %ebx
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	ff d0                	call   *%eax
  80079e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a4:	8d 50 01             	lea    0x1(%eax),%edx
  8007a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8007aa:	8a 00                	mov    (%eax),%al
  8007ac:	0f b6 d8             	movzbl %al,%ebx
  8007af:	83 fb 25             	cmp    $0x25,%ebx
  8007b2:	75 d6                	jne    80078a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d7:	8d 50 01             	lea    0x1(%eax),%edx
  8007da:	89 55 10             	mov    %edx,0x10(%ebp)
  8007dd:	8a 00                	mov    (%eax),%al
  8007df:	0f b6 d8             	movzbl %al,%ebx
  8007e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007e5:	83 f8 55             	cmp    $0x55,%eax
  8007e8:	0f 87 2b 03 00 00    	ja     800b19 <vprintfmt+0x399>
  8007ee:	8b 04 85 58 22 80 00 	mov    0x802258(,%eax,4),%eax
  8007f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007fb:	eb d7                	jmp    8007d4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800801:	eb d1                	jmp    8007d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800803:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80080a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80080d:	89 d0                	mov    %edx,%eax
  80080f:	c1 e0 02             	shl    $0x2,%eax
  800812:	01 d0                	add    %edx,%eax
  800814:	01 c0                	add    %eax,%eax
  800816:	01 d8                	add    %ebx,%eax
  800818:	83 e8 30             	sub    $0x30,%eax
  80081b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80081e:	8b 45 10             	mov    0x10(%ebp),%eax
  800821:	8a 00                	mov    (%eax),%al
  800823:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800826:	83 fb 2f             	cmp    $0x2f,%ebx
  800829:	7e 3e                	jle    800869 <vprintfmt+0xe9>
  80082b:	83 fb 39             	cmp    $0x39,%ebx
  80082e:	7f 39                	jg     800869 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800830:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800833:	eb d5                	jmp    80080a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 c0 04             	add    $0x4,%eax
  80083b:	89 45 14             	mov    %eax,0x14(%ebp)
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	83 e8 04             	sub    $0x4,%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800849:	eb 1f                	jmp    80086a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80084b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084f:	79 83                	jns    8007d4 <vprintfmt+0x54>
				width = 0;
  800851:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800858:	e9 77 ff ff ff       	jmp    8007d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80085d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800864:	e9 6b ff ff ff       	jmp    8007d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800869:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80086a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80086e:	0f 89 60 ff ff ff    	jns    8007d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800874:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800877:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80087a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800881:	e9 4e ff ff ff       	jmp    8007d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800886:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800889:	e9 46 ff ff ff       	jmp    8007d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 c0 04             	add    $0x4,%eax
  800894:	89 45 14             	mov    %eax,0x14(%ebp)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	83 e8 04             	sub    $0x4,%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	ff 75 0c             	pushl  0xc(%ebp)
  8008a5:	50                   	push   %eax
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	ff d0                	call   *%eax
  8008ab:	83 c4 10             	add    $0x10,%esp
			break;
  8008ae:	e9 89 02 00 00       	jmp    800b3c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 c0 04             	add    $0x4,%eax
  8008b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bf:	83 e8 04             	sub    $0x4,%eax
  8008c2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008c4:	85 db                	test   %ebx,%ebx
  8008c6:	79 02                	jns    8008ca <vprintfmt+0x14a>
				err = -err;
  8008c8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008ca:	83 fb 64             	cmp    $0x64,%ebx
  8008cd:	7f 0b                	jg     8008da <vprintfmt+0x15a>
  8008cf:	8b 34 9d a0 20 80 00 	mov    0x8020a0(,%ebx,4),%esi
  8008d6:	85 f6                	test   %esi,%esi
  8008d8:	75 19                	jne    8008f3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008da:	53                   	push   %ebx
  8008db:	68 45 22 80 00       	push   $0x802245
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	ff 75 08             	pushl  0x8(%ebp)
  8008e6:	e8 5e 02 00 00       	call   800b49 <printfmt>
  8008eb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ee:	e9 49 02 00 00       	jmp    800b3c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008f3:	56                   	push   %esi
  8008f4:	68 4e 22 80 00       	push   $0x80224e
  8008f9:	ff 75 0c             	pushl  0xc(%ebp)
  8008fc:	ff 75 08             	pushl  0x8(%ebp)
  8008ff:	e8 45 02 00 00       	call   800b49 <printfmt>
  800904:	83 c4 10             	add    $0x10,%esp
			break;
  800907:	e9 30 02 00 00       	jmp    800b3c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 c0 04             	add    $0x4,%eax
  800912:	89 45 14             	mov    %eax,0x14(%ebp)
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	83 e8 04             	sub    $0x4,%eax
  80091b:	8b 30                	mov    (%eax),%esi
  80091d:	85 f6                	test   %esi,%esi
  80091f:	75 05                	jne    800926 <vprintfmt+0x1a6>
				p = "(null)";
  800921:	be 51 22 80 00       	mov    $0x802251,%esi
			if (width > 0 && padc != '-')
  800926:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092a:	7e 6d                	jle    800999 <vprintfmt+0x219>
  80092c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800930:	74 67                	je     800999 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800932:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	50                   	push   %eax
  800939:	56                   	push   %esi
  80093a:	e8 0c 03 00 00       	call   800c4b <strnlen>
  80093f:	83 c4 10             	add    $0x10,%esp
  800942:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800945:	eb 16                	jmp    80095d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800947:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	50                   	push   %eax
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80095a:	ff 4d e4             	decl   -0x1c(%ebp)
  80095d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800961:	7f e4                	jg     800947 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800963:	eb 34                	jmp    800999 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800965:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800969:	74 1c                	je     800987 <vprintfmt+0x207>
  80096b:	83 fb 1f             	cmp    $0x1f,%ebx
  80096e:	7e 05                	jle    800975 <vprintfmt+0x1f5>
  800970:	83 fb 7e             	cmp    $0x7e,%ebx
  800973:	7e 12                	jle    800987 <vprintfmt+0x207>
					putch('?', putdat);
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	ff 75 0c             	pushl  0xc(%ebp)
  80097b:	6a 3f                	push   $0x3f
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	eb 0f                	jmp    800996 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800987:	83 ec 08             	sub    $0x8,%esp
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	53                   	push   %ebx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	ff d0                	call   *%eax
  800993:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800996:	ff 4d e4             	decl   -0x1c(%ebp)
  800999:	89 f0                	mov    %esi,%eax
  80099b:	8d 70 01             	lea    0x1(%eax),%esi
  80099e:	8a 00                	mov    (%eax),%al
  8009a0:	0f be d8             	movsbl %al,%ebx
  8009a3:	85 db                	test   %ebx,%ebx
  8009a5:	74 24                	je     8009cb <vprintfmt+0x24b>
  8009a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ab:	78 b8                	js     800965 <vprintfmt+0x1e5>
  8009ad:	ff 4d e0             	decl   -0x20(%ebp)
  8009b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009b4:	79 af                	jns    800965 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b6:	eb 13                	jmp    8009cb <vprintfmt+0x24b>
				putch(' ', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 20                	push   $0x20
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c8:	ff 4d e4             	decl   -0x1c(%ebp)
  8009cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009cf:	7f e7                	jg     8009b8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009d1:	e9 66 01 00 00       	jmp    800b3c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8009df:	50                   	push   %eax
  8009e0:	e8 3c fd ff ff       	call   800721 <getint>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009f4:	85 d2                	test   %edx,%edx
  8009f6:	79 23                	jns    800a1b <vprintfmt+0x29b>
				putch('-', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 2d                	push   $0x2d
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a0e:	f7 d8                	neg    %eax
  800a10:	83 d2 00             	adc    $0x0,%edx
  800a13:	f7 da                	neg    %edx
  800a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a22:	e9 bc 00 00 00       	jmp    800ae3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a30:	50                   	push   %eax
  800a31:	e8 84 fc ff ff       	call   8006ba <getuint>
  800a36:	83 c4 10             	add    $0x10,%esp
  800a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a46:	e9 98 00 00 00       	jmp    800ae3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	6a 58                	push   $0x58
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	ff d0                	call   *%eax
  800a58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	6a 58                	push   $0x58
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	ff d0                	call   *%eax
  800a68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a6b:	83 ec 08             	sub    $0x8,%esp
  800a6e:	ff 75 0c             	pushl  0xc(%ebp)
  800a71:	6a 58                	push   $0x58
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	ff d0                	call   *%eax
  800a78:	83 c4 10             	add    $0x10,%esp
			break;
  800a7b:	e9 bc 00 00 00       	jmp    800b3c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a80:	83 ec 08             	sub    $0x8,%esp
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	6a 30                	push   $0x30
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	ff d0                	call   *%eax
  800a8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 0c             	pushl  0xc(%ebp)
  800a96:	6a 78                	push   $0x78
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	ff d0                	call   *%eax
  800a9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 c0 04             	add    $0x4,%eax
  800aa6:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aac:	83 e8 04             	sub    $0x4,%eax
  800aaf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800abb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ac2:	eb 1f                	jmp    800ae3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 e8             	pushl  -0x18(%ebp)
  800aca:	8d 45 14             	lea    0x14(%ebp),%eax
  800acd:	50                   	push   %eax
  800ace:	e8 e7 fb ff ff       	call   8006ba <getuint>
  800ad3:	83 c4 10             	add    $0x10,%esp
  800ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800adc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ae3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	52                   	push   %edx
  800aee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800af1:	50                   	push   %eax
  800af2:	ff 75 f4             	pushl  -0xc(%ebp)
  800af5:	ff 75 f0             	pushl  -0x10(%ebp)
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	ff 75 08             	pushl  0x8(%ebp)
  800afe:	e8 00 fb ff ff       	call   800603 <printnum>
  800b03:	83 c4 20             	add    $0x20,%esp
			break;
  800b06:	eb 34                	jmp    800b3c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b08:	83 ec 08             	sub    $0x8,%esp
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	53                   	push   %ebx
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	ff d0                	call   *%eax
  800b14:	83 c4 10             	add    $0x10,%esp
			break;
  800b17:	eb 23                	jmp    800b3c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	6a 25                	push   $0x25
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	ff d0                	call   *%eax
  800b26:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b29:	ff 4d 10             	decl   0x10(%ebp)
  800b2c:	eb 03                	jmp    800b31 <vprintfmt+0x3b1>
  800b2e:	ff 4d 10             	decl   0x10(%ebp)
  800b31:	8b 45 10             	mov    0x10(%ebp),%eax
  800b34:	48                   	dec    %eax
  800b35:	8a 00                	mov    (%eax),%al
  800b37:	3c 25                	cmp    $0x25,%al
  800b39:	75 f3                	jne    800b2e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b3b:	90                   	nop
		}
	}
  800b3c:	e9 47 fc ff ff       	jmp    800788 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b41:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b52:	83 c0 04             	add    $0x4,%eax
  800b55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b58:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5e:	50                   	push   %eax
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	ff 75 08             	pushl  0x8(%ebp)
  800b65:	e8 16 fc ff ff       	call   800780 <vprintfmt>
  800b6a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b6d:	90                   	nop
  800b6e:	c9                   	leave  
  800b6f:	c3                   	ret    

00800b70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	8b 40 08             	mov    0x8(%eax),%eax
  800b79:	8d 50 01             	lea    0x1(%eax),%edx
  800b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	8b 10                	mov    (%eax),%edx
  800b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8a:	8b 40 04             	mov    0x4(%eax),%eax
  800b8d:	39 c2                	cmp    %eax,%edx
  800b8f:	73 12                	jae    800ba3 <sprintputch+0x33>
		*b->buf++ = ch;
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 48 01             	lea    0x1(%eax),%ecx
  800b99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9c:	89 0a                	mov    %ecx,(%edx)
  800b9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba1:	88 10                	mov    %dl,(%eax)
}
  800ba3:	90                   	nop
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	01 d0                	add    %edx,%eax
  800bbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bcb:	74 06                	je     800bd3 <vsnprintf+0x2d>
  800bcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd1:	7f 07                	jg     800bda <vsnprintf+0x34>
		return -E_INVAL;
  800bd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800bd8:	eb 20                	jmp    800bfa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bda:	ff 75 14             	pushl  0x14(%ebp)
  800bdd:	ff 75 10             	pushl  0x10(%ebp)
  800be0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800be3:	50                   	push   %eax
  800be4:	68 70 0b 80 00       	push   $0x800b70
  800be9:	e8 92 fb ff ff       	call   800780 <vprintfmt>
  800bee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c02:	8d 45 10             	lea    0x10(%ebp),%eax
  800c05:	83 c0 04             	add    $0x4,%eax
  800c08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c11:	50                   	push   %eax
  800c12:	ff 75 0c             	pushl  0xc(%ebp)
  800c15:	ff 75 08             	pushl  0x8(%ebp)
  800c18:	e8 89 ff ff ff       	call   800ba6 <vsnprintf>
  800c1d:	83 c4 10             	add    $0x10,%esp
  800c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c26:	c9                   	leave  
  800c27:	c3                   	ret    

00800c28 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c35:	eb 06                	jmp    800c3d <strlen+0x15>
		n++;
  800c37:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c3a:	ff 45 08             	incl   0x8(%ebp)
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	84 c0                	test   %al,%al
  800c44:	75 f1                	jne    800c37 <strlen+0xf>
		n++;
	return n;
  800c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c58:	eb 09                	jmp    800c63 <strnlen+0x18>
		n++;
  800c5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c5d:	ff 45 08             	incl   0x8(%ebp)
  800c60:	ff 4d 0c             	decl   0xc(%ebp)
  800c63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c67:	74 09                	je     800c72 <strnlen+0x27>
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8a 00                	mov    (%eax),%al
  800c6e:	84 c0                	test   %al,%al
  800c70:	75 e8                	jne    800c5a <strnlen+0xf>
		n++;
	return n;
  800c72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c75:	c9                   	leave  
  800c76:	c3                   	ret    

00800c77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c83:	90                   	nop
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8d 50 01             	lea    0x1(%eax),%edx
  800c8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c96:	8a 12                	mov    (%edx),%dl
  800c98:	88 10                	mov    %dl,(%eax)
  800c9a:	8a 00                	mov    (%eax),%al
  800c9c:	84 c0                	test   %al,%al
  800c9e:	75 e4                	jne    800c84 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ca0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca3:	c9                   	leave  
  800ca4:	c3                   	ret    

00800ca5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb8:	eb 1f                	jmp    800cd9 <strncpy+0x34>
		*dst++ = *src;
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8d 50 01             	lea    0x1(%eax),%edx
  800cc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc6:	8a 12                	mov    (%edx),%dl
  800cc8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	84 c0                	test   %al,%al
  800cd1:	74 03                	je     800cd6 <strncpy+0x31>
			src++;
  800cd3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cd6:	ff 45 fc             	incl   -0x4(%ebp)
  800cd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cdc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cdf:	72 d9                	jb     800cba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ce1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ce4:	c9                   	leave  
  800ce5:	c3                   	ret    

00800ce6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf6:	74 30                	je     800d28 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cf8:	eb 16                	jmp    800d10 <strlcpy+0x2a>
			*dst++ = *src++;
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	8d 50 01             	lea    0x1(%eax),%edx
  800d00:	89 55 08             	mov    %edx,0x8(%ebp)
  800d03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d0c:	8a 12                	mov    (%edx),%dl
  800d0e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d10:	ff 4d 10             	decl   0x10(%ebp)
  800d13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d17:	74 09                	je     800d22 <strlcpy+0x3c>
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	8a 00                	mov    (%eax),%al
  800d1e:	84 c0                	test   %al,%al
  800d20:	75 d8                	jne    800cfa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d28:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2e:	29 c2                	sub    %eax,%edx
  800d30:	89 d0                	mov    %edx,%eax
}
  800d32:	c9                   	leave  
  800d33:	c3                   	ret    

00800d34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d37:	eb 06                	jmp    800d3f <strcmp+0xb>
		p++, q++;
  800d39:	ff 45 08             	incl   0x8(%ebp)
  800d3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	84 c0                	test   %al,%al
  800d46:	74 0e                	je     800d56 <strcmp+0x22>
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	8a 10                	mov    (%eax),%dl
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	38 c2                	cmp    %al,%dl
  800d54:	74 e3                	je     800d39 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	0f b6 d0             	movzbl %al,%edx
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	0f b6 c0             	movzbl %al,%eax
  800d66:	29 c2                	sub    %eax,%edx
  800d68:	89 d0                	mov    %edx,%eax
}
  800d6a:	5d                   	pop    %ebp
  800d6b:	c3                   	ret    

00800d6c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d6f:	eb 09                	jmp    800d7a <strncmp+0xe>
		n--, p++, q++;
  800d71:	ff 4d 10             	decl   0x10(%ebp)
  800d74:	ff 45 08             	incl   0x8(%ebp)
  800d77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7e:	74 17                	je     800d97 <strncmp+0x2b>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	84 c0                	test   %al,%al
  800d87:	74 0e                	je     800d97 <strncmp+0x2b>
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 10                	mov    (%eax),%dl
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	38 c2                	cmp    %al,%dl
  800d95:	74 da                	je     800d71 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9b:	75 07                	jne    800da4 <strncmp+0x38>
		return 0;
  800d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800da2:	eb 14                	jmp    800db8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	0f b6 d0             	movzbl %al,%edx
  800dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daf:	8a 00                	mov    (%eax),%al
  800db1:	0f b6 c0             	movzbl %al,%eax
  800db4:	29 c2                	sub    %eax,%edx
  800db6:	89 d0                	mov    %edx,%eax
}
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	83 ec 04             	sub    $0x4,%esp
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc6:	eb 12                	jmp    800dda <strchr+0x20>
		if (*s == c)
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd0:	75 05                	jne    800dd7 <strchr+0x1d>
			return (char *) s;
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	eb 11                	jmp    800de8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dd7:	ff 45 08             	incl   0x8(%ebp)
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	84 c0                	test   %al,%al
  800de1:	75 e5                	jne    800dc8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800de3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de8:	c9                   	leave  
  800de9:	c3                   	ret    

00800dea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 04             	sub    $0x4,%esp
  800df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800df6:	eb 0d                	jmp    800e05 <strfind+0x1b>
		if (*s == c)
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e00:	74 0e                	je     800e10 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e02:	ff 45 08             	incl   0x8(%ebp)
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 00                	mov    (%eax),%al
  800e0a:	84 c0                	test   %al,%al
  800e0c:	75 ea                	jne    800df8 <strfind+0xe>
  800e0e:	eb 01                	jmp    800e11 <strfind+0x27>
		if (*s == c)
			break;
  800e10:	90                   	nop
	return (char *) s;
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e14:	c9                   	leave  
  800e15:	c3                   	ret    

00800e16 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e22:	8b 45 10             	mov    0x10(%ebp),%eax
  800e25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e28:	eb 0e                	jmp    800e38 <memset+0x22>
		*p++ = c;
  800e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2d:	8d 50 01             	lea    0x1(%eax),%edx
  800e30:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e36:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e38:	ff 4d f8             	decl   -0x8(%ebp)
  800e3b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e3f:	79 e9                	jns    800e2a <memset+0x14>
		*p++ = c;

	return v;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e58:	eb 16                	jmp    800e70 <memcpy+0x2a>
		*d++ = *s++;
  800e5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5d:	8d 50 01             	lea    0x1(%eax),%edx
  800e60:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e69:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e6c:	8a 12                	mov    (%edx),%dl
  800e6e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e70:	8b 45 10             	mov    0x10(%ebp),%eax
  800e73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e76:	89 55 10             	mov    %edx,0x10(%ebp)
  800e79:	85 c0                	test   %eax,%eax
  800e7b:	75 dd                	jne    800e5a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e80:	c9                   	leave  
  800e81:	c3                   	ret    

00800e82 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e97:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e9a:	73 50                	jae    800eec <memmove+0x6a>
  800e9c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea2:	01 d0                	add    %edx,%eax
  800ea4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ea7:	76 43                	jbe    800eec <memmove+0x6a>
		s += n;
  800ea9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eac:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800eaf:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eb5:	eb 10                	jmp    800ec7 <memmove+0x45>
			*--d = *--s;
  800eb7:	ff 4d f8             	decl   -0x8(%ebp)
  800eba:	ff 4d fc             	decl   -0x4(%ebp)
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	8a 10                	mov    (%eax),%dl
  800ec2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eca:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ecd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed0:	85 c0                	test   %eax,%eax
  800ed2:	75 e3                	jne    800eb7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ed4:	eb 23                	jmp    800ef9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee8:	8a 12                	mov    (%edx),%dl
  800eea:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	75 dd                	jne    800ed6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f10:	eb 2a                	jmp    800f3c <memcmp+0x3e>
		if (*s1 != *s2)
  800f12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f15:	8a 10                	mov    (%eax),%dl
  800f17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	38 c2                	cmp    %al,%dl
  800f1e:	74 16                	je     800f36 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	0f b6 d0             	movzbl %al,%edx
  800f28:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	0f b6 c0             	movzbl %al,%eax
  800f30:	29 c2                	sub    %eax,%edx
  800f32:	89 d0                	mov    %edx,%eax
  800f34:	eb 18                	jmp    800f4e <memcmp+0x50>
		s1++, s2++;
  800f36:	ff 45 fc             	incl   -0x4(%ebp)
  800f39:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f42:	89 55 10             	mov    %edx,0x10(%ebp)
  800f45:	85 c0                	test   %eax,%eax
  800f47:	75 c9                	jne    800f12 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f4e:	c9                   	leave  
  800f4f:	c3                   	ret    

00800f50 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f56:	8b 55 08             	mov    0x8(%ebp),%edx
  800f59:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5c:	01 d0                	add    %edx,%eax
  800f5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f61:	eb 15                	jmp    800f78 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	0f b6 d0             	movzbl %al,%edx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	0f b6 c0             	movzbl %al,%eax
  800f71:	39 c2                	cmp    %eax,%edx
  800f73:	74 0d                	je     800f82 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f75:	ff 45 08             	incl   0x8(%ebp)
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f7e:	72 e3                	jb     800f63 <memfind+0x13>
  800f80:	eb 01                	jmp    800f83 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f82:	90                   	nop
	return (void *) s;
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f86:	c9                   	leave  
  800f87:	c3                   	ret    

00800f88 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f95:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f9c:	eb 03                	jmp    800fa1 <strtol+0x19>
		s++;
  800f9e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 20                	cmp    $0x20,%al
  800fa8:	74 f4                	je     800f9e <strtol+0x16>
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 09                	cmp    $0x9,%al
  800fb1:	74 eb                	je     800f9e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 2b                	cmp    $0x2b,%al
  800fba:	75 05                	jne    800fc1 <strtol+0x39>
		s++;
  800fbc:	ff 45 08             	incl   0x8(%ebp)
  800fbf:	eb 13                	jmp    800fd4 <strtol+0x4c>
	else if (*s == '-')
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3c 2d                	cmp    $0x2d,%al
  800fc8:	75 0a                	jne    800fd4 <strtol+0x4c>
		s++, neg = 1;
  800fca:	ff 45 08             	incl   0x8(%ebp)
  800fcd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd8:	74 06                	je     800fe0 <strtol+0x58>
  800fda:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fde:	75 20                	jne    801000 <strtol+0x78>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 30                	cmp    $0x30,%al
  800fe7:	75 17                	jne    801000 <strtol+0x78>
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	40                   	inc    %eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	3c 78                	cmp    $0x78,%al
  800ff1:	75 0d                	jne    801000 <strtol+0x78>
		s += 2, base = 16;
  800ff3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ff7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ffe:	eb 28                	jmp    801028 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801000:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801004:	75 15                	jne    80101b <strtol+0x93>
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	3c 30                	cmp    $0x30,%al
  80100d:	75 0c                	jne    80101b <strtol+0x93>
		s++, base = 8;
  80100f:	ff 45 08             	incl   0x8(%ebp)
  801012:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801019:	eb 0d                	jmp    801028 <strtol+0xa0>
	else if (base == 0)
  80101b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101f:	75 07                	jne    801028 <strtol+0xa0>
		base = 10;
  801021:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 2f                	cmp    $0x2f,%al
  80102f:	7e 19                	jle    80104a <strtol+0xc2>
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	3c 39                	cmp    $0x39,%al
  801038:	7f 10                	jg     80104a <strtol+0xc2>
			dig = *s - '0';
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	0f be c0             	movsbl %al,%eax
  801042:	83 e8 30             	sub    $0x30,%eax
  801045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801048:	eb 42                	jmp    80108c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	3c 60                	cmp    $0x60,%al
  801051:	7e 19                	jle    80106c <strtol+0xe4>
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	3c 7a                	cmp    $0x7a,%al
  80105a:	7f 10                	jg     80106c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	0f be c0             	movsbl %al,%eax
  801064:	83 e8 57             	sub    $0x57,%eax
  801067:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80106a:	eb 20                	jmp    80108c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 40                	cmp    $0x40,%al
  801073:	7e 39                	jle    8010ae <strtol+0x126>
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	3c 5a                	cmp    $0x5a,%al
  80107c:	7f 30                	jg     8010ae <strtol+0x126>
			dig = *s - 'A' + 10;
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	0f be c0             	movsbl %al,%eax
  801086:	83 e8 37             	sub    $0x37,%eax
  801089:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80108c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801092:	7d 19                	jge    8010ad <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801094:	ff 45 08             	incl   0x8(%ebp)
  801097:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80109e:	89 c2                	mov    %eax,%edx
  8010a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a3:	01 d0                	add    %edx,%eax
  8010a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010a8:	e9 7b ff ff ff       	jmp    801028 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010ad:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010b2:	74 08                	je     8010bc <strtol+0x134>
		*endptr = (char *) s;
  8010b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010c0:	74 07                	je     8010c9 <strtol+0x141>
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	f7 d8                	neg    %eax
  8010c7:	eb 03                	jmp    8010cc <strtol+0x144>
  8010c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010cc:	c9                   	leave  
  8010cd:	c3                   	ret    

008010ce <ltostr>:

void
ltostr(long value, char *str)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010e6:	79 13                	jns    8010fb <ltostr+0x2d>
	{
		neg = 1;
  8010e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010f5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010f8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801103:	99                   	cltd   
  801104:	f7 f9                	idiv   %ecx
  801106:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801109:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110c:	8d 50 01             	lea    0x1(%eax),%edx
  80110f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801112:	89 c2                	mov    %eax,%edx
  801114:	8b 45 0c             	mov    0xc(%ebp),%eax
  801117:	01 d0                	add    %edx,%eax
  801119:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80111c:	83 c2 30             	add    $0x30,%edx
  80111f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801121:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801124:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801129:	f7 e9                	imul   %ecx
  80112b:	c1 fa 02             	sar    $0x2,%edx
  80112e:	89 c8                	mov    %ecx,%eax
  801130:	c1 f8 1f             	sar    $0x1f,%eax
  801133:	29 c2                	sub    %eax,%edx
  801135:	89 d0                	mov    %edx,%eax
  801137:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80113a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80113d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801142:	f7 e9                	imul   %ecx
  801144:	c1 fa 02             	sar    $0x2,%edx
  801147:	89 c8                	mov    %ecx,%eax
  801149:	c1 f8 1f             	sar    $0x1f,%eax
  80114c:	29 c2                	sub    %eax,%edx
  80114e:	89 d0                	mov    %edx,%eax
  801150:	c1 e0 02             	shl    $0x2,%eax
  801153:	01 d0                	add    %edx,%eax
  801155:	01 c0                	add    %eax,%eax
  801157:	29 c1                	sub    %eax,%ecx
  801159:	89 ca                	mov    %ecx,%edx
  80115b:	85 d2                	test   %edx,%edx
  80115d:	75 9c                	jne    8010fb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80115f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801166:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801169:	48                   	dec    %eax
  80116a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80116d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801171:	74 3d                	je     8011b0 <ltostr+0xe2>
		start = 1 ;
  801173:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80117a:	eb 34                	jmp    8011b0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80117c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 d0                	add    %edx,%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801189:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	01 c2                	add    %eax,%edx
  801191:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	01 c8                	add    %ecx,%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80119d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	01 c2                	add    %eax,%edx
  8011a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8011aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011b6:	7c c4                	jl     80117c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011be:	01 d0                	add    %edx,%eax
  8011c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011c3:	90                   	nop
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    

008011c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011cc:	ff 75 08             	pushl  0x8(%ebp)
  8011cf:	e8 54 fa ff ff       	call   800c28 <strlen>
  8011d4:	83 c4 04             	add    $0x4,%esp
  8011d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011da:	ff 75 0c             	pushl  0xc(%ebp)
  8011dd:	e8 46 fa ff ff       	call   800c28 <strlen>
  8011e2:	83 c4 04             	add    $0x4,%esp
  8011e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011f6:	eb 17                	jmp    80120f <strcconcat+0x49>
		final[s] = str1[s] ;
  8011f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fe:	01 c2                	add    %eax,%edx
  801200:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	01 c8                	add    %ecx,%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80120c:	ff 45 fc             	incl   -0x4(%ebp)
  80120f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801212:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801215:	7c e1                	jl     8011f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801217:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80121e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801225:	eb 1f                	jmp    801246 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801227:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122a:	8d 50 01             	lea    0x1(%eax),%edx
  80122d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801230:	89 c2                	mov    %eax,%edx
  801232:	8b 45 10             	mov    0x10(%ebp),%eax
  801235:	01 c2                	add    %eax,%edx
  801237:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80123a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123d:	01 c8                	add    %ecx,%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801243:	ff 45 f8             	incl   -0x8(%ebp)
  801246:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801249:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80124c:	7c d9                	jl     801227 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80124e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801251:	8b 45 10             	mov    0x10(%ebp),%eax
  801254:	01 d0                	add    %edx,%eax
  801256:	c6 00 00             	movb   $0x0,(%eax)
}
  801259:	90                   	nop
  80125a:	c9                   	leave  
  80125b:	c3                   	ret    

0080125c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80125f:	8b 45 14             	mov    0x14(%ebp),%eax
  801262:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801268:	8b 45 14             	mov    0x14(%ebp),%eax
  80126b:	8b 00                	mov    (%eax),%eax
  80126d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801274:	8b 45 10             	mov    0x10(%ebp),%eax
  801277:	01 d0                	add    %edx,%eax
  801279:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80127f:	eb 0c                	jmp    80128d <strsplit+0x31>
			*string++ = 0;
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8d 50 01             	lea    0x1(%eax),%edx
  801287:	89 55 08             	mov    %edx,0x8(%ebp)
  80128a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	84 c0                	test   %al,%al
  801294:	74 18                	je     8012ae <strsplit+0x52>
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	0f be c0             	movsbl %al,%eax
  80129e:	50                   	push   %eax
  80129f:	ff 75 0c             	pushl  0xc(%ebp)
  8012a2:	e8 13 fb ff ff       	call   800dba <strchr>
  8012a7:	83 c4 08             	add    $0x8,%esp
  8012aa:	85 c0                	test   %eax,%eax
  8012ac:	75 d3                	jne    801281 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	84 c0                	test   %al,%al
  8012b5:	74 5a                	je     801311 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ba:	8b 00                	mov    (%eax),%eax
  8012bc:	83 f8 0f             	cmp    $0xf,%eax
  8012bf:	75 07                	jne    8012c8 <strsplit+0x6c>
		{
			return 0;
  8012c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c6:	eb 66                	jmp    80132e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012cb:	8b 00                	mov    (%eax),%eax
  8012cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8012d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8012d3:	89 0a                	mov    %ecx,(%edx)
  8012d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012df:	01 c2                	add    %eax,%edx
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012e6:	eb 03                	jmp    8012eb <strsplit+0x8f>
			string++;
  8012e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	84 c0                	test   %al,%al
  8012f2:	74 8b                	je     80127f <strsplit+0x23>
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	0f be c0             	movsbl %al,%eax
  8012fc:	50                   	push   %eax
  8012fd:	ff 75 0c             	pushl  0xc(%ebp)
  801300:	e8 b5 fa ff ff       	call   800dba <strchr>
  801305:	83 c4 08             	add    $0x8,%esp
  801308:	85 c0                	test   %eax,%eax
  80130a:	74 dc                	je     8012e8 <strsplit+0x8c>
			string++;
	}
  80130c:	e9 6e ff ff ff       	jmp    80127f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801311:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801312:	8b 45 14             	mov    0x14(%ebp),%eax
  801315:	8b 00                	mov    (%eax),%eax
  801317:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131e:	8b 45 10             	mov    0x10(%ebp),%eax
  801321:	01 d0                	add    %edx,%eax
  801323:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801329:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	57                   	push   %edi
  801334:	56                   	push   %esi
  801335:	53                   	push   %ebx
  801336:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801342:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801345:	8b 7d 18             	mov    0x18(%ebp),%edi
  801348:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80134b:	cd 30                	int    $0x30
  80134d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801350:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801353:	83 c4 10             	add    $0x10,%esp
  801356:	5b                   	pop    %ebx
  801357:	5e                   	pop    %esi
  801358:	5f                   	pop    %edi
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

0080135b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	83 ec 04             	sub    $0x4,%esp
  801361:	8b 45 10             	mov    0x10(%ebp),%eax
  801364:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801367:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	52                   	push   %edx
  801373:	ff 75 0c             	pushl  0xc(%ebp)
  801376:	50                   	push   %eax
  801377:	6a 00                	push   $0x0
  801379:	e8 b2 ff ff ff       	call   801330 <syscall>
  80137e:	83 c4 18             	add    $0x18,%esp
}
  801381:	90                   	nop
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <sys_cgetc>:

int
sys_cgetc(void)
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 01                	push   $0x1
  801393:	e8 98 ff ff ff       	call   801330 <syscall>
  801398:	83 c4 18             	add    $0x18,%esp
}
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	50                   	push   %eax
  8013ac:	6a 05                	push   $0x5
  8013ae:	e8 7d ff ff ff       	call   801330 <syscall>
  8013b3:	83 c4 18             	add    $0x18,%esp
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 02                	push   $0x2
  8013c7:	e8 64 ff ff ff       	call   801330 <syscall>
  8013cc:	83 c4 18             	add    $0x18,%esp
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 03                	push   $0x3
  8013e0:	e8 4b ff ff ff       	call   801330 <syscall>
  8013e5:	83 c4 18             	add    $0x18,%esp
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 04                	push   $0x4
  8013f9:	e8 32 ff ff ff       	call   801330 <syscall>
  8013fe:	83 c4 18             	add    $0x18,%esp
}
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <sys_env_exit>:


void sys_env_exit(void)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 06                	push   $0x6
  801412:	e8 19 ff ff ff       	call   801330 <syscall>
  801417:	83 c4 18             	add    $0x18,%esp
}
  80141a:	90                   	nop
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801420:	8b 55 0c             	mov    0xc(%ebp),%edx
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	52                   	push   %edx
  80142d:	50                   	push   %eax
  80142e:	6a 07                	push   $0x7
  801430:	e8 fb fe ff ff       	call   801330 <syscall>
  801435:	83 c4 18             	add    $0x18,%esp
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	56                   	push   %esi
  80143e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80143f:	8b 75 18             	mov    0x18(%ebp),%esi
  801442:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801445:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801448:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	56                   	push   %esi
  80144f:	53                   	push   %ebx
  801450:	51                   	push   %ecx
  801451:	52                   	push   %edx
  801452:	50                   	push   %eax
  801453:	6a 08                	push   $0x8
  801455:	e8 d6 fe ff ff       	call   801330 <syscall>
  80145a:	83 c4 18             	add    $0x18,%esp
}
  80145d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801460:	5b                   	pop    %ebx
  801461:	5e                   	pop    %esi
  801462:	5d                   	pop    %ebp
  801463:	c3                   	ret    

00801464 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801467:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	52                   	push   %edx
  801474:	50                   	push   %eax
  801475:	6a 09                	push   $0x9
  801477:	e8 b4 fe ff ff       	call   801330 <syscall>
  80147c:	83 c4 18             	add    $0x18,%esp
}
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	ff 75 0c             	pushl  0xc(%ebp)
  80148d:	ff 75 08             	pushl  0x8(%ebp)
  801490:	6a 0a                	push   $0xa
  801492:	e8 99 fe ff ff       	call   801330 <syscall>
  801497:	83 c4 18             	add    $0x18,%esp
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 0b                	push   $0xb
  8014ab:	e8 80 fe ff ff       	call   801330 <syscall>
  8014b0:	83 c4 18             	add    $0x18,%esp
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 0c                	push   $0xc
  8014c4:	e8 67 fe ff ff       	call   801330 <syscall>
  8014c9:	83 c4 18             	add    $0x18,%esp
}
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    

008014ce <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 0d                	push   $0xd
  8014dd:	e8 4e fe ff ff       	call   801330 <syscall>
  8014e2:	83 c4 18             	add    $0x18,%esp
}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	ff 75 0c             	pushl  0xc(%ebp)
  8014f3:	ff 75 08             	pushl  0x8(%ebp)
  8014f6:	6a 11                	push   $0x11
  8014f8:	e8 33 fe ff ff       	call   801330 <syscall>
  8014fd:	83 c4 18             	add    $0x18,%esp
	return;
  801500:	90                   	nop
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	ff 75 0c             	pushl  0xc(%ebp)
  80150f:	ff 75 08             	pushl  0x8(%ebp)
  801512:	6a 12                	push   $0x12
  801514:	e8 17 fe ff ff       	call   801330 <syscall>
  801519:	83 c4 18             	add    $0x18,%esp
	return ;
  80151c:	90                   	nop
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 0e                	push   $0xe
  80152e:	e8 fd fd ff ff       	call   801330 <syscall>
  801533:	83 c4 18             	add    $0x18,%esp
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	ff 75 08             	pushl  0x8(%ebp)
  801546:	6a 0f                	push   $0xf
  801548:	e8 e3 fd ff ff       	call   801330 <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
}
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 10                	push   $0x10
  801561:	e8 ca fd ff ff       	call   801330 <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
}
  801569:	90                   	nop
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 14                	push   $0x14
  80157b:	e8 b0 fd ff ff       	call   801330 <syscall>
  801580:	83 c4 18             	add    $0x18,%esp
}
  801583:	90                   	nop
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 15                	push   $0x15
  801595:	e8 96 fd ff ff       	call   801330 <syscall>
  80159a:	83 c4 18             	add    $0x18,%esp
}
  80159d:	90                   	nop
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_cputc>:


void
sys_cputc(const char c)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 04             	sub    $0x4,%esp
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015ac:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	50                   	push   %eax
  8015b9:	6a 16                	push   $0x16
  8015bb:	e8 70 fd ff ff       	call   801330 <syscall>
  8015c0:	83 c4 18             	add    $0x18,%esp
}
  8015c3:	90                   	nop
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 17                	push   $0x17
  8015d5:	e8 56 fd ff ff       	call   801330 <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
}
  8015dd:	90                   	nop
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	ff 75 0c             	pushl  0xc(%ebp)
  8015ef:	50                   	push   %eax
  8015f0:	6a 18                	push   $0x18
  8015f2:	e8 39 fd ff ff       	call   801330 <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	52                   	push   %edx
  80160c:	50                   	push   %eax
  80160d:	6a 1b                	push   $0x1b
  80160f:	e8 1c fd ff ff       	call   801330 <syscall>
  801614:	83 c4 18             	add    $0x18,%esp
}
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80161c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	52                   	push   %edx
  801629:	50                   	push   %eax
  80162a:	6a 19                	push   $0x19
  80162c:	e8 ff fc ff ff       	call   801330 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
}
  801634:	90                   	nop
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80163a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	52                   	push   %edx
  801647:	50                   	push   %eax
  801648:	6a 1a                	push   $0x1a
  80164a:	e8 e1 fc ff ff       	call   801330 <syscall>
  80164f:	83 c4 18             	add    $0x18,%esp
}
  801652:	90                   	nop
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
  80165e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801661:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801664:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	6a 00                	push   $0x0
  80166d:	51                   	push   %ecx
  80166e:	52                   	push   %edx
  80166f:	ff 75 0c             	pushl  0xc(%ebp)
  801672:	50                   	push   %eax
  801673:	6a 1c                	push   $0x1c
  801675:	e8 b6 fc ff ff       	call   801330 <syscall>
  80167a:	83 c4 18             	add    $0x18,%esp
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801682:	8b 55 0c             	mov    0xc(%ebp),%edx
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	52                   	push   %edx
  80168f:	50                   	push   %eax
  801690:	6a 1d                	push   $0x1d
  801692:	e8 99 fc ff ff       	call   801330 <syscall>
  801697:	83 c4 18             	add    $0x18,%esp
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80169f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	51                   	push   %ecx
  8016ad:	52                   	push   %edx
  8016ae:	50                   	push   %eax
  8016af:	6a 1e                	push   $0x1e
  8016b1:	e8 7a fc ff ff       	call   801330 <syscall>
  8016b6:	83 c4 18             	add    $0x18,%esp
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	52                   	push   %edx
  8016cb:	50                   	push   %eax
  8016cc:	6a 1f                	push   $0x1f
  8016ce:	e8 5d fc ff ff       	call   801330 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 20                	push   $0x20
  8016e7:	e8 44 fc ff ff       	call   801330 <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	6a 00                	push   $0x0
  8016f9:	ff 75 14             	pushl  0x14(%ebp)
  8016fc:	ff 75 10             	pushl  0x10(%ebp)
  8016ff:	ff 75 0c             	pushl  0xc(%ebp)
  801702:	50                   	push   %eax
  801703:	6a 21                	push   $0x21
  801705:	e8 26 fc ff ff       	call   801330 <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	50                   	push   %eax
  80171e:	6a 22                	push   $0x22
  801720:	e8 0b fc ff ff       	call   801330 <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	90                   	nop
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	50                   	push   %eax
  80173a:	6a 23                	push   $0x23
  80173c:	e8 ef fb ff ff       	call   801330 <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	90                   	nop
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80174d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801750:	8d 50 04             	lea    0x4(%eax),%edx
  801753:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	52                   	push   %edx
  80175d:	50                   	push   %eax
  80175e:	6a 24                	push   $0x24
  801760:	e8 cb fb ff ff       	call   801330 <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
	return result;
  801768:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80176b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801771:	89 01                	mov    %eax,(%ecx)
  801773:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	c9                   	leave  
  80177a:	c2 04 00             	ret    $0x4

0080177d <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	ff 75 10             	pushl  0x10(%ebp)
  801787:	ff 75 0c             	pushl  0xc(%ebp)
  80178a:	ff 75 08             	pushl  0x8(%ebp)
  80178d:	6a 13                	push   $0x13
  80178f:	e8 9c fb ff ff       	call   801330 <syscall>
  801794:	83 c4 18             	add    $0x18,%esp
	return ;
  801797:	90                   	nop
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_rcr2>:
uint32 sys_rcr2()
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 25                	push   $0x25
  8017a9:	e8 82 fb ff ff       	call   801330 <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 04             	sub    $0x4,%esp
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017bf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	50                   	push   %eax
  8017cc:	6a 26                	push   $0x26
  8017ce:	e8 5d fb ff ff       	call   801330 <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d6:	90                   	nop
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <rsttst>:
void rsttst()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 28                	push   $0x28
  8017e8:	e8 43 fb ff ff       	call   801330 <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f0:	90                   	nop
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017ff:	8b 55 18             	mov    0x18(%ebp),%edx
  801802:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801806:	52                   	push   %edx
  801807:	50                   	push   %eax
  801808:	ff 75 10             	pushl  0x10(%ebp)
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	ff 75 08             	pushl  0x8(%ebp)
  801811:	6a 27                	push   $0x27
  801813:	e8 18 fb ff ff       	call   801330 <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
	return ;
  80181b:	90                   	nop
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <chktst>:
void chktst(uint32 n)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	6a 29                	push   $0x29
  80182e:	e8 fd fa ff ff       	call   801330 <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
	return ;
  801836:	90                   	nop
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <inctst>:

void inctst()
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 2a                	push   $0x2a
  801848:	e8 e3 fa ff ff       	call   801330 <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
	return ;
  801850:	90                   	nop
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <gettst>:
uint32 gettst()
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 2b                	push   $0x2b
  801862:	e8 c9 fa ff ff       	call   801330 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 2c                	push   $0x2c
  80187e:	e8 ad fa ff ff       	call   801330 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
  801886:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801889:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80188d:	75 07                	jne    801896 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80188f:	b8 01 00 00 00       	mov    $0x1,%eax
  801894:	eb 05                	jmp    80189b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801896:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 2c                	push   $0x2c
  8018af:	e8 7c fa ff ff       	call   801330 <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
  8018b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8018ba:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8018be:	75 07                	jne    8018c7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8018c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8018c5:	eb 05                	jmp    8018cc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8018c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 2c                	push   $0x2c
  8018e0:	e8 4b fa ff ff       	call   801330 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
  8018e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8018eb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8018ef:	75 07                	jne    8018f8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8018f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f6:	eb 05                	jmp    8018fd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8018f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 2c                	push   $0x2c
  801911:	e8 1a fa ff ff       	call   801330 <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
  801919:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80191c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801920:	75 07                	jne    801929 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801922:	b8 01 00 00 00       	mov    $0x1,%eax
  801927:	eb 05                	jmp    80192e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801929:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	ff 75 08             	pushl  0x8(%ebp)
  80193e:	6a 2d                	push   $0x2d
  801940:	e8 eb f9 ff ff       	call   801330 <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
	return ;
  801948:	90                   	nop
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80194f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801952:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801955:	8b 55 0c             	mov    0xc(%ebp),%edx
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	6a 00                	push   $0x0
  80195d:	53                   	push   %ebx
  80195e:	51                   	push   %ecx
  80195f:	52                   	push   %edx
  801960:	50                   	push   %eax
  801961:	6a 2e                	push   $0x2e
  801963:	e8 c8 f9 ff ff       	call   801330 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801973:	8b 55 0c             	mov    0xc(%ebp),%edx
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	52                   	push   %edx
  801980:	50                   	push   %eax
  801981:	6a 2f                	push   $0x2f
  801983:	e8 a8 f9 ff ff       	call   801330 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801993:	8b 55 08             	mov    0x8(%ebp),%edx
  801996:	89 d0                	mov    %edx,%eax
  801998:	c1 e0 02             	shl    $0x2,%eax
  80199b:	01 d0                	add    %edx,%eax
  80199d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a4:	01 d0                	add    %edx,%eax
  8019a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ad:	01 d0                	add    %edx,%eax
  8019af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b6:	01 d0                	add    %edx,%eax
  8019b8:	c1 e0 04             	shl    $0x4,%eax
  8019bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8019be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8019c5:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8019c8:	83 ec 0c             	sub    $0xc,%esp
  8019cb:	50                   	push   %eax
  8019cc:	e8 76 fd ff ff       	call   801747 <sys_get_virtual_time>
  8019d1:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8019d4:	eb 41                	jmp    801a17 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8019d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019d9:	83 ec 0c             	sub    $0xc,%esp
  8019dc:	50                   	push   %eax
  8019dd:	e8 65 fd ff ff       	call   801747 <sys_get_virtual_time>
  8019e2:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019eb:	29 c2                	sub    %eax,%edx
  8019ed:	89 d0                	mov    %edx,%eax
  8019ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f8:	89 d1                	mov    %edx,%ecx
  8019fa:	29 c1                	sub    %eax,%ecx
  8019fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a02:	39 c2                	cmp    %eax,%edx
  801a04:	0f 97 c0             	seta   %al
  801a07:	0f b6 c0             	movzbl %al,%eax
  801a0a:	29 c1                	sub    %eax,%ecx
  801a0c:	89 c8                	mov    %ecx,%eax
  801a0e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a11:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a14:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a1d:	72 b7                	jb     8019d6 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a1f:	90                   	nop
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a2f:	eb 03                	jmp    801a34 <busy_wait+0x12>
  801a31:	ff 45 fc             	incl   -0x4(%ebp)
  801a34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a37:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a3a:	72 f5                	jb     801a31 <busy_wait+0xf>
	return i;
  801a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    
  801a41:	66 90                	xchg   %ax,%ax
  801a43:	90                   	nop

00801a44 <__udivdi3>:
  801a44:	55                   	push   %ebp
  801a45:	57                   	push   %edi
  801a46:	56                   	push   %esi
  801a47:	53                   	push   %ebx
  801a48:	83 ec 1c             	sub    $0x1c,%esp
  801a4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a5b:	89 ca                	mov    %ecx,%edx
  801a5d:	89 f8                	mov    %edi,%eax
  801a5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a63:	85 f6                	test   %esi,%esi
  801a65:	75 2d                	jne    801a94 <__udivdi3+0x50>
  801a67:	39 cf                	cmp    %ecx,%edi
  801a69:	77 65                	ja     801ad0 <__udivdi3+0x8c>
  801a6b:	89 fd                	mov    %edi,%ebp
  801a6d:	85 ff                	test   %edi,%edi
  801a6f:	75 0b                	jne    801a7c <__udivdi3+0x38>
  801a71:	b8 01 00 00 00       	mov    $0x1,%eax
  801a76:	31 d2                	xor    %edx,%edx
  801a78:	f7 f7                	div    %edi
  801a7a:	89 c5                	mov    %eax,%ebp
  801a7c:	31 d2                	xor    %edx,%edx
  801a7e:	89 c8                	mov    %ecx,%eax
  801a80:	f7 f5                	div    %ebp
  801a82:	89 c1                	mov    %eax,%ecx
  801a84:	89 d8                	mov    %ebx,%eax
  801a86:	f7 f5                	div    %ebp
  801a88:	89 cf                	mov    %ecx,%edi
  801a8a:	89 fa                	mov    %edi,%edx
  801a8c:	83 c4 1c             	add    $0x1c,%esp
  801a8f:	5b                   	pop    %ebx
  801a90:	5e                   	pop    %esi
  801a91:	5f                   	pop    %edi
  801a92:	5d                   	pop    %ebp
  801a93:	c3                   	ret    
  801a94:	39 ce                	cmp    %ecx,%esi
  801a96:	77 28                	ja     801ac0 <__udivdi3+0x7c>
  801a98:	0f bd fe             	bsr    %esi,%edi
  801a9b:	83 f7 1f             	xor    $0x1f,%edi
  801a9e:	75 40                	jne    801ae0 <__udivdi3+0x9c>
  801aa0:	39 ce                	cmp    %ecx,%esi
  801aa2:	72 0a                	jb     801aae <__udivdi3+0x6a>
  801aa4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801aa8:	0f 87 9e 00 00 00    	ja     801b4c <__udivdi3+0x108>
  801aae:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab3:	89 fa                	mov    %edi,%edx
  801ab5:	83 c4 1c             	add    $0x1c,%esp
  801ab8:	5b                   	pop    %ebx
  801ab9:	5e                   	pop    %esi
  801aba:	5f                   	pop    %edi
  801abb:	5d                   	pop    %ebp
  801abc:	c3                   	ret    
  801abd:	8d 76 00             	lea    0x0(%esi),%esi
  801ac0:	31 ff                	xor    %edi,%edi
  801ac2:	31 c0                	xor    %eax,%eax
  801ac4:	89 fa                	mov    %edi,%edx
  801ac6:	83 c4 1c             	add    $0x1c,%esp
  801ac9:	5b                   	pop    %ebx
  801aca:	5e                   	pop    %esi
  801acb:	5f                   	pop    %edi
  801acc:	5d                   	pop    %ebp
  801acd:	c3                   	ret    
  801ace:	66 90                	xchg   %ax,%ax
  801ad0:	89 d8                	mov    %ebx,%eax
  801ad2:	f7 f7                	div    %edi
  801ad4:	31 ff                	xor    %edi,%edi
  801ad6:	89 fa                	mov    %edi,%edx
  801ad8:	83 c4 1c             	add    $0x1c,%esp
  801adb:	5b                   	pop    %ebx
  801adc:	5e                   	pop    %esi
  801add:	5f                   	pop    %edi
  801ade:	5d                   	pop    %ebp
  801adf:	c3                   	ret    
  801ae0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ae5:	89 eb                	mov    %ebp,%ebx
  801ae7:	29 fb                	sub    %edi,%ebx
  801ae9:	89 f9                	mov    %edi,%ecx
  801aeb:	d3 e6                	shl    %cl,%esi
  801aed:	89 c5                	mov    %eax,%ebp
  801aef:	88 d9                	mov    %bl,%cl
  801af1:	d3 ed                	shr    %cl,%ebp
  801af3:	89 e9                	mov    %ebp,%ecx
  801af5:	09 f1                	or     %esi,%ecx
  801af7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801afb:	89 f9                	mov    %edi,%ecx
  801afd:	d3 e0                	shl    %cl,%eax
  801aff:	89 c5                	mov    %eax,%ebp
  801b01:	89 d6                	mov    %edx,%esi
  801b03:	88 d9                	mov    %bl,%cl
  801b05:	d3 ee                	shr    %cl,%esi
  801b07:	89 f9                	mov    %edi,%ecx
  801b09:	d3 e2                	shl    %cl,%edx
  801b0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0f:	88 d9                	mov    %bl,%cl
  801b11:	d3 e8                	shr    %cl,%eax
  801b13:	09 c2                	or     %eax,%edx
  801b15:	89 d0                	mov    %edx,%eax
  801b17:	89 f2                	mov    %esi,%edx
  801b19:	f7 74 24 0c          	divl   0xc(%esp)
  801b1d:	89 d6                	mov    %edx,%esi
  801b1f:	89 c3                	mov    %eax,%ebx
  801b21:	f7 e5                	mul    %ebp
  801b23:	39 d6                	cmp    %edx,%esi
  801b25:	72 19                	jb     801b40 <__udivdi3+0xfc>
  801b27:	74 0b                	je     801b34 <__udivdi3+0xf0>
  801b29:	89 d8                	mov    %ebx,%eax
  801b2b:	31 ff                	xor    %edi,%edi
  801b2d:	e9 58 ff ff ff       	jmp    801a8a <__udivdi3+0x46>
  801b32:	66 90                	xchg   %ax,%ax
  801b34:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b38:	89 f9                	mov    %edi,%ecx
  801b3a:	d3 e2                	shl    %cl,%edx
  801b3c:	39 c2                	cmp    %eax,%edx
  801b3e:	73 e9                	jae    801b29 <__udivdi3+0xe5>
  801b40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b43:	31 ff                	xor    %edi,%edi
  801b45:	e9 40 ff ff ff       	jmp    801a8a <__udivdi3+0x46>
  801b4a:	66 90                	xchg   %ax,%ax
  801b4c:	31 c0                	xor    %eax,%eax
  801b4e:	e9 37 ff ff ff       	jmp    801a8a <__udivdi3+0x46>
  801b53:	90                   	nop

00801b54 <__umoddi3>:
  801b54:	55                   	push   %ebp
  801b55:	57                   	push   %edi
  801b56:	56                   	push   %esi
  801b57:	53                   	push   %ebx
  801b58:	83 ec 1c             	sub    $0x1c,%esp
  801b5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b73:	89 f3                	mov    %esi,%ebx
  801b75:	89 fa                	mov    %edi,%edx
  801b77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b7b:	89 34 24             	mov    %esi,(%esp)
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	75 1a                	jne    801b9c <__umoddi3+0x48>
  801b82:	39 f7                	cmp    %esi,%edi
  801b84:	0f 86 a2 00 00 00    	jbe    801c2c <__umoddi3+0xd8>
  801b8a:	89 c8                	mov    %ecx,%eax
  801b8c:	89 f2                	mov    %esi,%edx
  801b8e:	f7 f7                	div    %edi
  801b90:	89 d0                	mov    %edx,%eax
  801b92:	31 d2                	xor    %edx,%edx
  801b94:	83 c4 1c             	add    $0x1c,%esp
  801b97:	5b                   	pop    %ebx
  801b98:	5e                   	pop    %esi
  801b99:	5f                   	pop    %edi
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    
  801b9c:	39 f0                	cmp    %esi,%eax
  801b9e:	0f 87 ac 00 00 00    	ja     801c50 <__umoddi3+0xfc>
  801ba4:	0f bd e8             	bsr    %eax,%ebp
  801ba7:	83 f5 1f             	xor    $0x1f,%ebp
  801baa:	0f 84 ac 00 00 00    	je     801c5c <__umoddi3+0x108>
  801bb0:	bf 20 00 00 00       	mov    $0x20,%edi
  801bb5:	29 ef                	sub    %ebp,%edi
  801bb7:	89 fe                	mov    %edi,%esi
  801bb9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bbd:	89 e9                	mov    %ebp,%ecx
  801bbf:	d3 e0                	shl    %cl,%eax
  801bc1:	89 d7                	mov    %edx,%edi
  801bc3:	89 f1                	mov    %esi,%ecx
  801bc5:	d3 ef                	shr    %cl,%edi
  801bc7:	09 c7                	or     %eax,%edi
  801bc9:	89 e9                	mov    %ebp,%ecx
  801bcb:	d3 e2                	shl    %cl,%edx
  801bcd:	89 14 24             	mov    %edx,(%esp)
  801bd0:	89 d8                	mov    %ebx,%eax
  801bd2:	d3 e0                	shl    %cl,%eax
  801bd4:	89 c2                	mov    %eax,%edx
  801bd6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bda:	d3 e0                	shl    %cl,%eax
  801bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801be4:	89 f1                	mov    %esi,%ecx
  801be6:	d3 e8                	shr    %cl,%eax
  801be8:	09 d0                	or     %edx,%eax
  801bea:	d3 eb                	shr    %cl,%ebx
  801bec:	89 da                	mov    %ebx,%edx
  801bee:	f7 f7                	div    %edi
  801bf0:	89 d3                	mov    %edx,%ebx
  801bf2:	f7 24 24             	mull   (%esp)
  801bf5:	89 c6                	mov    %eax,%esi
  801bf7:	89 d1                	mov    %edx,%ecx
  801bf9:	39 d3                	cmp    %edx,%ebx
  801bfb:	0f 82 87 00 00 00    	jb     801c88 <__umoddi3+0x134>
  801c01:	0f 84 91 00 00 00    	je     801c98 <__umoddi3+0x144>
  801c07:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c0b:	29 f2                	sub    %esi,%edx
  801c0d:	19 cb                	sbb    %ecx,%ebx
  801c0f:	89 d8                	mov    %ebx,%eax
  801c11:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c15:	d3 e0                	shl    %cl,%eax
  801c17:	89 e9                	mov    %ebp,%ecx
  801c19:	d3 ea                	shr    %cl,%edx
  801c1b:	09 d0                	or     %edx,%eax
  801c1d:	89 e9                	mov    %ebp,%ecx
  801c1f:	d3 eb                	shr    %cl,%ebx
  801c21:	89 da                	mov    %ebx,%edx
  801c23:	83 c4 1c             	add    $0x1c,%esp
  801c26:	5b                   	pop    %ebx
  801c27:	5e                   	pop    %esi
  801c28:	5f                   	pop    %edi
  801c29:	5d                   	pop    %ebp
  801c2a:	c3                   	ret    
  801c2b:	90                   	nop
  801c2c:	89 fd                	mov    %edi,%ebp
  801c2e:	85 ff                	test   %edi,%edi
  801c30:	75 0b                	jne    801c3d <__umoddi3+0xe9>
  801c32:	b8 01 00 00 00       	mov    $0x1,%eax
  801c37:	31 d2                	xor    %edx,%edx
  801c39:	f7 f7                	div    %edi
  801c3b:	89 c5                	mov    %eax,%ebp
  801c3d:	89 f0                	mov    %esi,%eax
  801c3f:	31 d2                	xor    %edx,%edx
  801c41:	f7 f5                	div    %ebp
  801c43:	89 c8                	mov    %ecx,%eax
  801c45:	f7 f5                	div    %ebp
  801c47:	89 d0                	mov    %edx,%eax
  801c49:	e9 44 ff ff ff       	jmp    801b92 <__umoddi3+0x3e>
  801c4e:	66 90                	xchg   %ax,%ax
  801c50:	89 c8                	mov    %ecx,%eax
  801c52:	89 f2                	mov    %esi,%edx
  801c54:	83 c4 1c             	add    $0x1c,%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5e                   	pop    %esi
  801c59:	5f                   	pop    %edi
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    
  801c5c:	3b 04 24             	cmp    (%esp),%eax
  801c5f:	72 06                	jb     801c67 <__umoddi3+0x113>
  801c61:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c65:	77 0f                	ja     801c76 <__umoddi3+0x122>
  801c67:	89 f2                	mov    %esi,%edx
  801c69:	29 f9                	sub    %edi,%ecx
  801c6b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c6f:	89 14 24             	mov    %edx,(%esp)
  801c72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c76:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c7a:	8b 14 24             	mov    (%esp),%edx
  801c7d:	83 c4 1c             	add    $0x1c,%esp
  801c80:	5b                   	pop    %ebx
  801c81:	5e                   	pop    %esi
  801c82:	5f                   	pop    %edi
  801c83:	5d                   	pop    %ebp
  801c84:	c3                   	ret    
  801c85:	8d 76 00             	lea    0x0(%esi),%esi
  801c88:	2b 04 24             	sub    (%esp),%eax
  801c8b:	19 fa                	sbb    %edi,%edx
  801c8d:	89 d1                	mov    %edx,%ecx
  801c8f:	89 c6                	mov    %eax,%esi
  801c91:	e9 71 ff ff ff       	jmp    801c07 <__umoddi3+0xb3>
  801c96:	66 90                	xchg   %ax,%ax
  801c98:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c9c:	72 ea                	jb     801c88 <__umoddi3+0x134>
  801c9e:	89 d9                	mov    %ebx,%ecx
  801ca0:	e9 62 ff ff ff       	jmp    801c07 <__umoddi3+0xb3>
