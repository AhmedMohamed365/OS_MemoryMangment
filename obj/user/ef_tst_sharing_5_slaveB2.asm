
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 71 01 00 00       	call   8001a7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 23                	jmp    80006e <_main+0x36>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 30 80 00       	mov    0x803020,%eax
  800050:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	c1 e2 04             	shl    $0x4,%edx
  80005c:	01 d0                	add    %edx,%eax
  80005e:	8a 40 04             	mov    0x4(%eax),%al
  800061:	84 c0                	test   %al,%al
  800063:	74 06                	je     80006b <_main+0x33>
			{
				fullWS = 0;
  800065:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800069:	eb 12                	jmp    80007d <_main+0x45>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006b:	ff 45 f0             	incl   -0x10(%ebp)
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 50 74             	mov    0x74(%eax),%edx
  800076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800079:	39 c2                	cmp    %eax,%edx
  80007b:	77 ce                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007d:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800081:	74 14                	je     800097 <_main+0x5f>
  800083:	83 ec 04             	sub    $0x4,%esp
  800086:	68 00 23 80 00       	push   $0x802300
  80008b:	6a 12                	push   $0x12
  80008d:	68 1c 23 80 00       	push   $0x80231c
  800092:	e8 55 02 00 00       	call   8002ec <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  800097:	e8 a1 19 00 00       	call   801a3d <sys_getparentenvid>
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	68 3c 23 80 00       	push   $0x80233c
  8000a4:	50                   	push   %eax
  8000a5:	e8 2b 18 00 00       	call   8018d5 <sget>
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 40 23 80 00       	push   $0x802340
  8000b8:	e8 d1 04 00 00       	call   80058e <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	68 68 23 80 00       	push   $0x802368
  8000c8:	e8 c1 04 00 00       	call   80058e <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	68 28 23 00 00       	push   $0x2328
  8000d8:	e8 03 1f 00 00       	call   801fe0 <env_sleep>
  8000dd:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 0a 1a 00 00       	call   801aef <sys_calculate_free_frames>
  8000e5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ee:	e8 ff 17 00 00       	call   8018f2 <sfree>
  8000f3:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 88 23 80 00       	push   $0x802388
  8000fe:	e8 8b 04 00 00       	call   80058e <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800106:	e8 e4 19 00 00       	call   801aef <sys_calculate_free_frames>
  80010b:	89 c2                	mov    %eax,%edx
  80010d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800110:	29 c2                	sub    %eax,%edx
  800112:	89 d0                	mov    %edx,%eax
  800114:	83 f8 04             	cmp    $0x4,%eax
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 a0 23 80 00       	push   $0x8023a0
  800121:	6a 20                	push   $0x20
  800123:	68 1c 23 80 00       	push   $0x80231c
  800128:	e8 bf 01 00 00       	call   8002ec <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  80012d:	e8 74 1d 00 00       	call   801ea6 <gettst>
  800132:	83 f8 02             	cmp    $0x2,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 40 24 80 00       	push   $0x802440
  80013f:	6a 23                	push   $0x23
  800141:	68 1c 23 80 00       	push   $0x80231c
  800146:	e8 a1 01 00 00       	call   8002ec <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	68 4c 24 80 00       	push   $0x80244c
  800153:	e8 36 04 00 00       	call   80058e <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	68 70 24 80 00       	push   $0x802470
  800163:	e8 26 04 00 00       	call   80058e <cprintf>
  800168:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80016b:	e8 cd 18 00 00       	call   801a3d <sys_getparentenvid>
  800170:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800173:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800177:	7e 2b                	jle    8001a4 <_main+0x16c>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  800179:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  800180:	83 ec 08             	sub    $0x8,%esp
  800183:	68 bc 24 80 00       	push   $0x8024bc
  800188:	ff 75 e4             	pushl  -0x1c(%ebp)
  80018b:	e8 45 17 00 00       	call   8018d5 <sget>
  800190:	83 c4 10             	add    $0x10,%esp
  800193:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  800196:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800199:	8b 00                	mov    (%eax),%eax
  80019b:	8d 50 01             	lea    0x1(%eax),%edx
  80019e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a1:	89 10                	mov    %edx,(%eax)
	}
	return;
  8001a3:	90                   	nop
  8001a4:	90                   	nop
}
  8001a5:	c9                   	leave  
  8001a6:	c3                   	ret    

008001a7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ad:	e8 72 18 00 00       	call   801a24 <sys_getenvindex>
  8001b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001b8:	89 d0                	mov    %edx,%eax
  8001ba:	c1 e0 03             	shl    $0x3,%eax
  8001bd:	01 d0                	add    %edx,%eax
  8001bf:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001c6:	01 c8                	add    %ecx,%eax
  8001c8:	01 c0                	add    %eax,%eax
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	01 c0                	add    %eax,%eax
  8001ce:	01 d0                	add    %edx,%eax
  8001d0:	89 c2                	mov    %eax,%edx
  8001d2:	c1 e2 05             	shl    $0x5,%edx
  8001d5:	29 c2                	sub    %eax,%edx
  8001d7:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001de:	89 c2                	mov    %eax,%edx
  8001e0:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001e6:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f0:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001f6:	84 c0                	test   %al,%al
  8001f8:	74 0f                	je     800209 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ff:	05 40 3c 01 00       	add    $0x13c40,%eax
  800204:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800209:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80020d:	7e 0a                	jle    800219 <libmain+0x72>
		binaryname = argv[0];
  80020f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800212:	8b 00                	mov    (%eax),%eax
  800214:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	ff 75 0c             	pushl  0xc(%ebp)
  80021f:	ff 75 08             	pushl  0x8(%ebp)
  800222:	e8 11 fe ff ff       	call   800038 <_main>
  800227:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80022a:	e8 90 19 00 00       	call   801bbf <sys_disable_interrupt>
	cprintf("**************************************\n");
  80022f:	83 ec 0c             	sub    $0xc,%esp
  800232:	68 e4 24 80 00       	push   $0x8024e4
  800237:	e8 52 03 00 00       	call   80058e <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80023f:	a1 20 30 80 00       	mov    0x803020,%eax
  800244:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80024a:	a1 20 30 80 00       	mov    0x803020,%eax
  80024f:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800255:	83 ec 04             	sub    $0x4,%esp
  800258:	52                   	push   %edx
  800259:	50                   	push   %eax
  80025a:	68 0c 25 80 00       	push   $0x80250c
  80025f:	e8 2a 03 00 00       	call   80058e <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800267:	a1 20 30 80 00       	mov    0x803020,%eax
  80026c:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800272:	a1 20 30 80 00       	mov    0x803020,%eax
  800277:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80027d:	83 ec 04             	sub    $0x4,%esp
  800280:	52                   	push   %edx
  800281:	50                   	push   %eax
  800282:	68 34 25 80 00       	push   $0x802534
  800287:	e8 02 03 00 00       	call   80058e <cprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028f:	a1 20 30 80 00       	mov    0x803020,%eax
  800294:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	50                   	push   %eax
  80029e:	68 75 25 80 00       	push   $0x802575
  8002a3:	e8 e6 02 00 00       	call   80058e <cprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 e4 24 80 00       	push   $0x8024e4
  8002b3:	e8 d6 02 00 00       	call   80058e <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002bb:	e8 19 19 00 00       	call   801bd9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002c0:	e8 19 00 00 00       	call   8002de <exit>
}
  8002c5:	90                   	nop
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 00                	push   $0x0
  8002d3:	e8 18 17 00 00       	call   8019f0 <sys_env_destroy>
  8002d8:	83 c4 10             	add    $0x10,%esp
}
  8002db:	90                   	nop
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    

008002de <exit>:

void
exit(void)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002e4:	e8 6d 17 00 00       	call   801a56 <sys_env_exit>
}
  8002e9:	90                   	nop
  8002ea:	c9                   	leave  
  8002eb:	c3                   	ret    

008002ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002f2:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f5:	83 c0 04             	add    $0x4,%eax
  8002f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002fb:	a1 18 31 80 00       	mov    0x803118,%eax
  800300:	85 c0                	test   %eax,%eax
  800302:	74 16                	je     80031a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800304:	a1 18 31 80 00       	mov    0x803118,%eax
  800309:	83 ec 08             	sub    $0x8,%esp
  80030c:	50                   	push   %eax
  80030d:	68 8c 25 80 00       	push   $0x80258c
  800312:	e8 77 02 00 00       	call   80058e <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80031a:	a1 00 30 80 00       	mov    0x803000,%eax
  80031f:	ff 75 0c             	pushl  0xc(%ebp)
  800322:	ff 75 08             	pushl  0x8(%ebp)
  800325:	50                   	push   %eax
  800326:	68 91 25 80 00       	push   $0x802591
  80032b:	e8 5e 02 00 00       	call   80058e <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800333:	8b 45 10             	mov    0x10(%ebp),%eax
  800336:	83 ec 08             	sub    $0x8,%esp
  800339:	ff 75 f4             	pushl  -0xc(%ebp)
  80033c:	50                   	push   %eax
  80033d:	e8 e1 01 00 00       	call   800523 <vcprintf>
  800342:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	6a 00                	push   $0x0
  80034a:	68 ad 25 80 00       	push   $0x8025ad
  80034f:	e8 cf 01 00 00       	call   800523 <vcprintf>
  800354:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800357:	e8 82 ff ff ff       	call   8002de <exit>

	// should not return here
	while (1) ;
  80035c:	eb fe                	jmp    80035c <_panic+0x70>

0080035e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035e:	55                   	push   %ebp
  80035f:	89 e5                	mov    %esp,%ebp
  800361:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800364:	a1 20 30 80 00       	mov    0x803020,%eax
  800369:	8b 50 74             	mov    0x74(%eax),%edx
  80036c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036f:	39 c2                	cmp    %eax,%edx
  800371:	74 14                	je     800387 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800373:	83 ec 04             	sub    $0x4,%esp
  800376:	68 b0 25 80 00       	push   $0x8025b0
  80037b:	6a 26                	push   $0x26
  80037d:	68 fc 25 80 00       	push   $0x8025fc
  800382:	e8 65 ff ff ff       	call   8002ec <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800395:	e9 b6 00 00 00       	jmp    800450 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 d0                	add    %edx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
  8003ab:	85 c0                	test   %eax,%eax
  8003ad:	75 08                	jne    8003b7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003af:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003b2:	e9 96 00 00 00       	jmp    80044d <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8003b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c5:	eb 5d                	jmp    800424 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cc:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d5:	c1 e2 04             	shl    $0x4,%edx
  8003d8:	01 d0                	add    %edx,%eax
  8003da:	8a 40 04             	mov    0x4(%eax),%al
  8003dd:	84 c0                	test   %al,%al
  8003df:	75 40                	jne    800421 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e6:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ef:	c1 e2 04             	shl    $0x4,%edx
  8003f2:	01 d0                	add    %edx,%eax
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800401:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800406:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	01 c8                	add    %ecx,%eax
  800412:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800414:	39 c2                	cmp    %eax,%edx
  800416:	75 09                	jne    800421 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800418:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80041f:	eb 12                	jmp    800433 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800421:	ff 45 e8             	incl   -0x18(%ebp)
  800424:	a1 20 30 80 00       	mov    0x803020,%eax
  800429:	8b 50 74             	mov    0x74(%eax),%edx
  80042c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80042f:	39 c2                	cmp    %eax,%edx
  800431:	77 94                	ja     8003c7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800433:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800437:	75 14                	jne    80044d <CheckWSWithoutLastIndex+0xef>
			panic(
  800439:	83 ec 04             	sub    $0x4,%esp
  80043c:	68 08 26 80 00       	push   $0x802608
  800441:	6a 3a                	push   $0x3a
  800443:	68 fc 25 80 00       	push   $0x8025fc
  800448:	e8 9f fe ff ff       	call   8002ec <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80044d:	ff 45 f0             	incl   -0x10(%ebp)
  800450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800453:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800456:	0f 8c 3e ff ff ff    	jl     80039a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80045c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800463:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80046a:	eb 20                	jmp    80048c <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80046c:	a1 20 30 80 00       	mov    0x803020,%eax
  800471:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800477:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80047a:	c1 e2 04             	shl    $0x4,%edx
  80047d:	01 d0                	add    %edx,%eax
  80047f:	8a 40 04             	mov    0x4(%eax),%al
  800482:	3c 01                	cmp    $0x1,%al
  800484:	75 03                	jne    800489 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800486:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800489:	ff 45 e0             	incl   -0x20(%ebp)
  80048c:	a1 20 30 80 00       	mov    0x803020,%eax
  800491:	8b 50 74             	mov    0x74(%eax),%edx
  800494:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800497:	39 c2                	cmp    %eax,%edx
  800499:	77 d1                	ja     80046c <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80049b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80049e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004a1:	74 14                	je     8004b7 <CheckWSWithoutLastIndex+0x159>
		panic(
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 5c 26 80 00       	push   $0x80265c
  8004ab:	6a 44                	push   $0x44
  8004ad:	68 fc 25 80 00       	push   $0x8025fc
  8004b2:	e8 35 fe ff ff       	call   8002ec <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004b7:	90                   	nop
  8004b8:	c9                   	leave  
  8004b9:	c3                   	ret    

008004ba <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	8d 48 01             	lea    0x1(%eax),%ecx
  8004c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cb:	89 0a                	mov    %ecx,(%edx)
  8004cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8004d0:	88 d1                	mov    %dl,%cl
  8004d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004e3:	75 2c                	jne    800511 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004e5:	a0 24 30 80 00       	mov    0x803024,%al
  8004ea:	0f b6 c0             	movzbl %al,%eax
  8004ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f0:	8b 12                	mov    (%edx),%edx
  8004f2:	89 d1                	mov    %edx,%ecx
  8004f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f7:	83 c2 08             	add    $0x8,%edx
  8004fa:	83 ec 04             	sub    $0x4,%esp
  8004fd:	50                   	push   %eax
  8004fe:	51                   	push   %ecx
  8004ff:	52                   	push   %edx
  800500:	e8 a9 14 00 00       	call   8019ae <sys_cputs>
  800505:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800511:	8b 45 0c             	mov    0xc(%ebp),%eax
  800514:	8b 40 04             	mov    0x4(%eax),%eax
  800517:	8d 50 01             	lea    0x1(%eax),%edx
  80051a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800520:	90                   	nop
  800521:	c9                   	leave  
  800522:	c3                   	ret    

00800523 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80052c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800533:	00 00 00 
	b.cnt = 0;
  800536:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80053d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800540:	ff 75 0c             	pushl  0xc(%ebp)
  800543:	ff 75 08             	pushl  0x8(%ebp)
  800546:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054c:	50                   	push   %eax
  80054d:	68 ba 04 80 00       	push   $0x8004ba
  800552:	e8 11 02 00 00       	call   800768 <vprintfmt>
  800557:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80055a:	a0 24 30 80 00       	mov    0x803024,%al
  80055f:	0f b6 c0             	movzbl %al,%eax
  800562:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	50                   	push   %eax
  80056c:	52                   	push   %edx
  80056d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800573:	83 c0 08             	add    $0x8,%eax
  800576:	50                   	push   %eax
  800577:	e8 32 14 00 00       	call   8019ae <sys_cputs>
  80057c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80057f:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800586:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <cprintf>:

int cprintf(const char *fmt, ...) {
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800594:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80059b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80059e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	83 ec 08             	sub    $0x8,%esp
  8005a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005aa:	50                   	push   %eax
  8005ab:	e8 73 ff ff ff       	call   800523 <vcprintf>
  8005b0:	83 c4 10             	add    $0x10,%esp
  8005b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b9:	c9                   	leave  
  8005ba:	c3                   	ret    

008005bb <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
  8005be:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005c1:	e8 f9 15 00 00       	call   801bbf <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005c6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d5:	50                   	push   %eax
  8005d6:	e8 48 ff ff ff       	call   800523 <vcprintf>
  8005db:	83 c4 10             	add    $0x10,%esp
  8005de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005e1:	e8 f3 15 00 00       	call   801bd9 <sys_enable_interrupt>
	return cnt;
  8005e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e9:	c9                   	leave  
  8005ea:	c3                   	ret    

008005eb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005eb:	55                   	push   %ebp
  8005ec:	89 e5                	mov    %esp,%ebp
  8005ee:	53                   	push   %ebx
  8005ef:	83 ec 14             	sub    $0x14,%esp
  8005f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800609:	77 55                	ja     800660 <printnum+0x75>
  80060b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80060e:	72 05                	jb     800615 <printnum+0x2a>
  800610:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800613:	77 4b                	ja     800660 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800615:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800618:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80061b:	8b 45 18             	mov    0x18(%ebp),%eax
  80061e:	ba 00 00 00 00       	mov    $0x0,%edx
  800623:	52                   	push   %edx
  800624:	50                   	push   %eax
  800625:	ff 75 f4             	pushl  -0xc(%ebp)
  800628:	ff 75 f0             	pushl  -0x10(%ebp)
  80062b:	e8 64 1a 00 00       	call   802094 <__udivdi3>
  800630:	83 c4 10             	add    $0x10,%esp
  800633:	83 ec 04             	sub    $0x4,%esp
  800636:	ff 75 20             	pushl  0x20(%ebp)
  800639:	53                   	push   %ebx
  80063a:	ff 75 18             	pushl  0x18(%ebp)
  80063d:	52                   	push   %edx
  80063e:	50                   	push   %eax
  80063f:	ff 75 0c             	pushl  0xc(%ebp)
  800642:	ff 75 08             	pushl  0x8(%ebp)
  800645:	e8 a1 ff ff ff       	call   8005eb <printnum>
  80064a:	83 c4 20             	add    $0x20,%esp
  80064d:	eb 1a                	jmp    800669 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	ff 75 0c             	pushl  0xc(%ebp)
  800655:	ff 75 20             	pushl  0x20(%ebp)
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	ff d0                	call   *%eax
  80065d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800660:	ff 4d 1c             	decl   0x1c(%ebp)
  800663:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800667:	7f e6                	jg     80064f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800669:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80066c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800674:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800677:	53                   	push   %ebx
  800678:	51                   	push   %ecx
  800679:	52                   	push   %edx
  80067a:	50                   	push   %eax
  80067b:	e8 24 1b 00 00       	call   8021a4 <__umoddi3>
  800680:	83 c4 10             	add    $0x10,%esp
  800683:	05 d4 28 80 00       	add    $0x8028d4,%eax
  800688:	8a 00                	mov    (%eax),%al
  80068a:	0f be c0             	movsbl %al,%eax
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	ff 75 0c             	pushl  0xc(%ebp)
  800693:	50                   	push   %eax
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	ff d0                	call   *%eax
  800699:	83 c4 10             	add    $0x10,%esp
}
  80069c:	90                   	nop
  80069d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a0:	c9                   	leave  
  8006a1:	c3                   	ret    

008006a2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006a2:	55                   	push   %ebp
  8006a3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a9:	7e 1c                	jle    8006c7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	8d 50 08             	lea    0x8(%eax),%edx
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	89 10                	mov    %edx,(%eax)
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	83 e8 08             	sub    $0x8,%eax
  8006c0:	8b 50 04             	mov    0x4(%eax),%edx
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	eb 40                	jmp    800707 <getuint+0x65>
	else if (lflag)
  8006c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006cb:	74 1e                	je     8006eb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	8d 50 04             	lea    0x4(%eax),%edx
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	89 10                	mov    %edx,(%eax)
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	83 e8 04             	sub    $0x4,%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e9:	eb 1c                	jmp    800707 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 04             	lea    0x4(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800707:	5d                   	pop    %ebp
  800708:	c3                   	ret    

00800709 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80070c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800710:	7e 1c                	jle    80072e <getint+0x25>
		return va_arg(*ap, long long);
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	8d 50 08             	lea    0x8(%eax),%edx
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	89 10                	mov    %edx,(%eax)
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	83 e8 08             	sub    $0x8,%eax
  800727:	8b 50 04             	mov    0x4(%eax),%edx
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	eb 38                	jmp    800766 <getint+0x5d>
	else if (lflag)
  80072e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800732:	74 1a                	je     80074e <getint+0x45>
		return va_arg(*ap, long);
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	8b 00                	mov    (%eax),%eax
  800739:	8d 50 04             	lea    0x4(%eax),%edx
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	89 10                	mov    %edx,(%eax)
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	83 e8 04             	sub    $0x4,%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	99                   	cltd   
  80074c:	eb 18                	jmp    800766 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	8d 50 04             	lea    0x4(%eax),%edx
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	89 10                	mov    %edx,(%eax)
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	83 e8 04             	sub    $0x4,%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	99                   	cltd   
}
  800766:	5d                   	pop    %ebp
  800767:	c3                   	ret    

00800768 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800768:	55                   	push   %ebp
  800769:	89 e5                	mov    %esp,%ebp
  80076b:	56                   	push   %esi
  80076c:	53                   	push   %ebx
  80076d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800770:	eb 17                	jmp    800789 <vprintfmt+0x21>
			if (ch == '\0')
  800772:	85 db                	test   %ebx,%ebx
  800774:	0f 84 af 03 00 00    	je     800b29 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	ff 75 0c             	pushl  0xc(%ebp)
  800780:	53                   	push   %ebx
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	ff d0                	call   *%eax
  800786:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800789:	8b 45 10             	mov    0x10(%ebp),%eax
  80078c:	8d 50 01             	lea    0x1(%eax),%edx
  80078f:	89 55 10             	mov    %edx,0x10(%ebp)
  800792:	8a 00                	mov    (%eax),%al
  800794:	0f b6 d8             	movzbl %al,%ebx
  800797:	83 fb 25             	cmp    $0x25,%ebx
  80079a:	75 d6                	jne    800772 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80079c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007a0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007a7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007ae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007b5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bf:	8d 50 01             	lea    0x1(%eax),%edx
  8007c2:	89 55 10             	mov    %edx,0x10(%ebp)
  8007c5:	8a 00                	mov    (%eax),%al
  8007c7:	0f b6 d8             	movzbl %al,%ebx
  8007ca:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007cd:	83 f8 55             	cmp    $0x55,%eax
  8007d0:	0f 87 2b 03 00 00    	ja     800b01 <vprintfmt+0x399>
  8007d6:	8b 04 85 f8 28 80 00 	mov    0x8028f8(,%eax,4),%eax
  8007dd:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007df:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007e3:	eb d7                	jmp    8007bc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007e5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007e9:	eb d1                	jmp    8007bc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007f5:	89 d0                	mov    %edx,%eax
  8007f7:	c1 e0 02             	shl    $0x2,%eax
  8007fa:	01 d0                	add    %edx,%eax
  8007fc:	01 c0                	add    %eax,%eax
  8007fe:	01 d8                	add    %ebx,%eax
  800800:	83 e8 30             	sub    $0x30,%eax
  800803:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800806:	8b 45 10             	mov    0x10(%ebp),%eax
  800809:	8a 00                	mov    (%eax),%al
  80080b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80080e:	83 fb 2f             	cmp    $0x2f,%ebx
  800811:	7e 3e                	jle    800851 <vprintfmt+0xe9>
  800813:	83 fb 39             	cmp    $0x39,%ebx
  800816:	7f 39                	jg     800851 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800818:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80081b:	eb d5                	jmp    8007f2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	83 c0 04             	add    $0x4,%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	83 e8 04             	sub    $0x4,%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800831:	eb 1f                	jmp    800852 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800833:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800837:	79 83                	jns    8007bc <vprintfmt+0x54>
				width = 0;
  800839:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800840:	e9 77 ff ff ff       	jmp    8007bc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800845:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80084c:	e9 6b ff ff ff       	jmp    8007bc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800851:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800852:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800856:	0f 89 60 ff ff ff    	jns    8007bc <vprintfmt+0x54>
				width = precision, precision = -1;
  80085c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80085f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800862:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800869:	e9 4e ff ff ff       	jmp    8007bc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80086e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800871:	e9 46 ff ff ff       	jmp    8007bc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	ff 75 0c             	pushl  0xc(%ebp)
  80088d:	50                   	push   %eax
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	ff d0                	call   *%eax
  800893:	83 c4 10             	add    $0x10,%esp
			break;
  800896:	e9 89 02 00 00       	jmp    800b24 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	83 c0 04             	add    $0x4,%eax
  8008a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	83 e8 04             	sub    $0x4,%eax
  8008aa:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008ac:	85 db                	test   %ebx,%ebx
  8008ae:	79 02                	jns    8008b2 <vprintfmt+0x14a>
				err = -err;
  8008b0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008b2:	83 fb 64             	cmp    $0x64,%ebx
  8008b5:	7f 0b                	jg     8008c2 <vprintfmt+0x15a>
  8008b7:	8b 34 9d 40 27 80 00 	mov    0x802740(,%ebx,4),%esi
  8008be:	85 f6                	test   %esi,%esi
  8008c0:	75 19                	jne    8008db <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008c2:	53                   	push   %ebx
  8008c3:	68 e5 28 80 00       	push   $0x8028e5
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	ff 75 08             	pushl  0x8(%ebp)
  8008ce:	e8 5e 02 00 00       	call   800b31 <printfmt>
  8008d3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008d6:	e9 49 02 00 00       	jmp    800b24 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008db:	56                   	push   %esi
  8008dc:	68 ee 28 80 00       	push   $0x8028ee
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	ff 75 08             	pushl  0x8(%ebp)
  8008e7:	e8 45 02 00 00       	call   800b31 <printfmt>
  8008ec:	83 c4 10             	add    $0x10,%esp
			break;
  8008ef:	e9 30 02 00 00       	jmp    800b24 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	83 c0 04             	add    $0x4,%eax
  8008fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	83 e8 04             	sub    $0x4,%eax
  800903:	8b 30                	mov    (%eax),%esi
  800905:	85 f6                	test   %esi,%esi
  800907:	75 05                	jne    80090e <vprintfmt+0x1a6>
				p = "(null)";
  800909:	be f1 28 80 00       	mov    $0x8028f1,%esi
			if (width > 0 && padc != '-')
  80090e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800912:	7e 6d                	jle    800981 <vprintfmt+0x219>
  800914:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800918:	74 67                	je     800981 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80091a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091d:	83 ec 08             	sub    $0x8,%esp
  800920:	50                   	push   %eax
  800921:	56                   	push   %esi
  800922:	e8 0c 03 00 00       	call   800c33 <strnlen>
  800927:	83 c4 10             	add    $0x10,%esp
  80092a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80092d:	eb 16                	jmp    800945 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80092f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800933:	83 ec 08             	sub    $0x8,%esp
  800936:	ff 75 0c             	pushl  0xc(%ebp)
  800939:	50                   	push   %eax
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	ff d0                	call   *%eax
  80093f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800942:	ff 4d e4             	decl   -0x1c(%ebp)
  800945:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800949:	7f e4                	jg     80092f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80094b:	eb 34                	jmp    800981 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80094d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800951:	74 1c                	je     80096f <vprintfmt+0x207>
  800953:	83 fb 1f             	cmp    $0x1f,%ebx
  800956:	7e 05                	jle    80095d <vprintfmt+0x1f5>
  800958:	83 fb 7e             	cmp    $0x7e,%ebx
  80095b:	7e 12                	jle    80096f <vprintfmt+0x207>
					putch('?', putdat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	6a 3f                	push   $0x3f
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	ff d0                	call   *%eax
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	eb 0f                	jmp    80097e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	53                   	push   %ebx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	ff d0                	call   *%eax
  80097b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80097e:	ff 4d e4             	decl   -0x1c(%ebp)
  800981:	89 f0                	mov    %esi,%eax
  800983:	8d 70 01             	lea    0x1(%eax),%esi
  800986:	8a 00                	mov    (%eax),%al
  800988:	0f be d8             	movsbl %al,%ebx
  80098b:	85 db                	test   %ebx,%ebx
  80098d:	74 24                	je     8009b3 <vprintfmt+0x24b>
  80098f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800993:	78 b8                	js     80094d <vprintfmt+0x1e5>
  800995:	ff 4d e0             	decl   -0x20(%ebp)
  800998:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80099c:	79 af                	jns    80094d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80099e:	eb 13                	jmp    8009b3 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	6a 20                	push   $0x20
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b0:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b7:	7f e7                	jg     8009a0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009b9:	e9 66 01 00 00       	jmp    800b24 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009be:	83 ec 08             	sub    $0x8,%esp
  8009c1:	ff 75 e8             	pushl  -0x18(%ebp)
  8009c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c7:	50                   	push   %eax
  8009c8:	e8 3c fd ff ff       	call   800709 <getint>
  8009cd:	83 c4 10             	add    $0x10,%esp
  8009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009dc:	85 d2                	test   %edx,%edx
  8009de:	79 23                	jns    800a03 <vprintfmt+0x29b>
				putch('-', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	6a 2d                	push   $0x2d
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009f6:	f7 d8                	neg    %eax
  8009f8:	83 d2 00             	adc    $0x0,%edx
  8009fb:	f7 da                	neg    %edx
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a03:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a0a:	e9 bc 00 00 00       	jmp    800acb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 e8             	pushl  -0x18(%ebp)
  800a15:	8d 45 14             	lea    0x14(%ebp),%eax
  800a18:	50                   	push   %eax
  800a19:	e8 84 fc ff ff       	call   8006a2 <getuint>
  800a1e:	83 c4 10             	add    $0x10,%esp
  800a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a24:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a27:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a2e:	e9 98 00 00 00       	jmp    800acb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	6a 58                	push   $0x58
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	ff d0                	call   *%eax
  800a40:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	6a 58                	push   $0x58
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	ff d0                	call   *%eax
  800a50:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	6a 58                	push   $0x58
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			break;
  800a63:	e9 bc 00 00 00       	jmp    800b24 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	6a 30                	push   $0x30
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	ff d0                	call   *%eax
  800a75:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a78:	83 ec 08             	sub    $0x8,%esp
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	6a 78                	push   $0x78
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	ff d0                	call   *%eax
  800a85:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	83 c0 04             	add    $0x4,%eax
  800a8e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a91:	8b 45 14             	mov    0x14(%ebp),%eax
  800a94:	83 e8 04             	sub    $0x4,%eax
  800a97:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aa3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aaa:	eb 1f                	jmp    800acb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ab5:	50                   	push   %eax
  800ab6:	e8 e7 fb ff ff       	call   8006a2 <getuint>
  800abb:	83 c4 10             	add    $0x10,%esp
  800abe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ac4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800acb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	52                   	push   %edx
  800ad6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ad9:	50                   	push   %eax
  800ada:	ff 75 f4             	pushl  -0xc(%ebp)
  800add:	ff 75 f0             	pushl  -0x10(%ebp)
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 00 fb ff ff       	call   8005eb <printnum>
  800aeb:	83 c4 20             	add    $0x20,%esp
			break;
  800aee:	eb 34                	jmp    800b24 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	53                   	push   %ebx
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	ff d0                	call   *%eax
  800afc:	83 c4 10             	add    $0x10,%esp
			break;
  800aff:	eb 23                	jmp    800b24 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b01:	83 ec 08             	sub    $0x8,%esp
  800b04:	ff 75 0c             	pushl  0xc(%ebp)
  800b07:	6a 25                	push   $0x25
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	ff d0                	call   *%eax
  800b0e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b11:	ff 4d 10             	decl   0x10(%ebp)
  800b14:	eb 03                	jmp    800b19 <vprintfmt+0x3b1>
  800b16:	ff 4d 10             	decl   0x10(%ebp)
  800b19:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1c:	48                   	dec    %eax
  800b1d:	8a 00                	mov    (%eax),%al
  800b1f:	3c 25                	cmp    $0x25,%al
  800b21:	75 f3                	jne    800b16 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b23:	90                   	nop
		}
	}
  800b24:	e9 47 fc ff ff       	jmp    800770 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b29:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b2d:	5b                   	pop    %ebx
  800b2e:	5e                   	pop    %esi
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    

00800b31 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b37:	8d 45 10             	lea    0x10(%ebp),%eax
  800b3a:	83 c0 04             	add    $0x4,%eax
  800b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b40:	8b 45 10             	mov    0x10(%ebp),%eax
  800b43:	ff 75 f4             	pushl  -0xc(%ebp)
  800b46:	50                   	push   %eax
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	ff 75 08             	pushl  0x8(%ebp)
  800b4d:	e8 16 fc ff ff       	call   800768 <vprintfmt>
  800b52:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b55:	90                   	nop
  800b56:	c9                   	leave  
  800b57:	c3                   	ret    

00800b58 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	8b 40 08             	mov    0x8(%eax),%eax
  800b61:	8d 50 01             	lea    0x1(%eax),%edx
  800b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b67:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8b 10                	mov    (%eax),%edx
  800b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b72:	8b 40 04             	mov    0x4(%eax),%eax
  800b75:	39 c2                	cmp    %eax,%edx
  800b77:	73 12                	jae    800b8b <sprintputch+0x33>
		*b->buf++ = ch;
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	8d 48 01             	lea    0x1(%eax),%ecx
  800b81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b84:	89 0a                	mov    %ecx,(%edx)
  800b86:	8b 55 08             	mov    0x8(%ebp),%edx
  800b89:	88 10                	mov    %dl,(%eax)
}
  800b8b:	90                   	nop
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	01 d0                	add    %edx,%eax
  800ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800baf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bb3:	74 06                	je     800bbb <vsnprintf+0x2d>
  800bb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb9:	7f 07                	jg     800bc2 <vsnprintf+0x34>
		return -E_INVAL;
  800bbb:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc0:	eb 20                	jmp    800be2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bc2:	ff 75 14             	pushl  0x14(%ebp)
  800bc5:	ff 75 10             	pushl  0x10(%ebp)
  800bc8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bcb:	50                   	push   %eax
  800bcc:	68 58 0b 80 00       	push   $0x800b58
  800bd1:	e8 92 fb ff ff       	call   800768 <vprintfmt>
  800bd6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bdc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800be2:	c9                   	leave  
  800be3:	c3                   	ret    

00800be4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bea:	8d 45 10             	lea    0x10(%ebp),%eax
  800bed:	83 c0 04             	add    $0x4,%eax
  800bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf6:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf9:	50                   	push   %eax
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	ff 75 08             	pushl  0x8(%ebp)
  800c00:	e8 89 ff ff ff       	call   800b8e <vsnprintf>
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c0e:	c9                   	leave  
  800c0f:	c3                   	ret    

00800c10 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1d:	eb 06                	jmp    800c25 <strlen+0x15>
		n++;
  800c1f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c22:	ff 45 08             	incl   0x8(%ebp)
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	8a 00                	mov    (%eax),%al
  800c2a:	84 c0                	test   %al,%al
  800c2c:	75 f1                	jne    800c1f <strlen+0xf>
		n++;
	return n;
  800c2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c31:	c9                   	leave  
  800c32:	c3                   	ret    

00800c33 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c40:	eb 09                	jmp    800c4b <strnlen+0x18>
		n++;
  800c42:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c45:	ff 45 08             	incl   0x8(%ebp)
  800c48:	ff 4d 0c             	decl   0xc(%ebp)
  800c4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4f:	74 09                	je     800c5a <strnlen+0x27>
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	8a 00                	mov    (%eax),%al
  800c56:	84 c0                	test   %al,%al
  800c58:	75 e8                	jne    800c42 <strnlen+0xf>
		n++;
	return n;
  800c5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c5d:	c9                   	leave  
  800c5e:	c3                   	ret    

00800c5f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c6b:	90                   	nop
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8d 50 01             	lea    0x1(%eax),%edx
  800c72:	89 55 08             	mov    %edx,0x8(%ebp)
  800c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c78:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c7b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c7e:	8a 12                	mov    (%edx),%dl
  800c80:	88 10                	mov    %dl,(%eax)
  800c82:	8a 00                	mov    (%eax),%al
  800c84:	84 c0                	test   %al,%al
  800c86:	75 e4                	jne    800c6c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c88:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8b:	c9                   	leave  
  800c8c:	c3                   	ret    

00800c8d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca0:	eb 1f                	jmp    800cc1 <strncpy+0x34>
		*dst++ = *src;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8d 50 01             	lea    0x1(%eax),%edx
  800ca8:	89 55 08             	mov    %edx,0x8(%ebp)
  800cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cae:	8a 12                	mov    (%edx),%dl
  800cb0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	84 c0                	test   %al,%al
  800cb9:	74 03                	je     800cbe <strncpy+0x31>
			src++;
  800cbb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cbe:	ff 45 fc             	incl   -0x4(%ebp)
  800cc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cc7:	72 d9                	jb     800ca2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ccc:	c9                   	leave  
  800ccd:	c3                   	ret    

00800cce <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cde:	74 30                	je     800d10 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ce0:	eb 16                	jmp    800cf8 <strlcpy+0x2a>
			*dst++ = *src++;
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8d 50 01             	lea    0x1(%eax),%edx
  800ce8:	89 55 08             	mov    %edx,0x8(%ebp)
  800ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cee:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cf1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cf4:	8a 12                	mov    (%edx),%dl
  800cf6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cf8:	ff 4d 10             	decl   0x10(%ebp)
  800cfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cff:	74 09                	je     800d0a <strlcpy+0x3c>
  800d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	84 c0                	test   %al,%al
  800d08:	75 d8                	jne    800ce2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d10:	8b 55 08             	mov    0x8(%ebp),%edx
  800d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d16:	29 c2                	sub    %eax,%edx
  800d18:	89 d0                	mov    %edx,%eax
}
  800d1a:	c9                   	leave  
  800d1b:	c3                   	ret    

00800d1c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d1f:	eb 06                	jmp    800d27 <strcmp+0xb>
		p++, q++;
  800d21:	ff 45 08             	incl   0x8(%ebp)
  800d24:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 00                	mov    (%eax),%al
  800d2c:	84 c0                	test   %al,%al
  800d2e:	74 0e                	je     800d3e <strcmp+0x22>
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8a 10                	mov    (%eax),%dl
  800d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	38 c2                	cmp    %al,%dl
  800d3c:	74 e3                	je     800d21 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	0f b6 d0             	movzbl %al,%edx
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	0f b6 c0             	movzbl %al,%eax
  800d4e:	29 c2                	sub    %eax,%edx
  800d50:	89 d0                	mov    %edx,%eax
}
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d57:	eb 09                	jmp    800d62 <strncmp+0xe>
		n--, p++, q++;
  800d59:	ff 4d 10             	decl   0x10(%ebp)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d66:	74 17                	je     800d7f <strncmp+0x2b>
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	74 0e                	je     800d7f <strncmp+0x2b>
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8a 10                	mov    (%eax),%dl
  800d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	38 c2                	cmp    %al,%dl
  800d7d:	74 da                	je     800d59 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d83:	75 07                	jne    800d8c <strncmp+0x38>
		return 0;
  800d85:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8a:	eb 14                	jmp    800da0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 d0             	movzbl %al,%edx
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	0f b6 c0             	movzbl %al,%eax
  800d9c:	29 c2                	sub    %eax,%edx
  800d9e:	89 d0                	mov    %edx,%eax
}
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	83 ec 04             	sub    $0x4,%esp
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dae:	eb 12                	jmp    800dc2 <strchr+0x20>
		if (*s == c)
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800db8:	75 05                	jne    800dbf <strchr+0x1d>
			return (char *) s;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	eb 11                	jmp    800dd0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dbf:	ff 45 08             	incl   0x8(%ebp)
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	84 c0                	test   %al,%al
  800dc9:	75 e5                	jne    800db0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	83 ec 04             	sub    $0x4,%esp
  800dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dde:	eb 0d                	jmp    800ded <strfind+0x1b>
		if (*s == c)
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800de8:	74 0e                	je     800df8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dea:	ff 45 08             	incl   0x8(%ebp)
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	84 c0                	test   %al,%al
  800df4:	75 ea                	jne    800de0 <strfind+0xe>
  800df6:	eb 01                	jmp    800df9 <strfind+0x27>
		if (*s == c)
			break;
  800df8:	90                   	nop
	return (char *) s;
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfc:	c9                   	leave  
  800dfd:	c3                   	ret    

00800dfe <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e10:	eb 0e                	jmp    800e20 <memset+0x22>
		*p++ = c;
  800e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e15:	8d 50 01             	lea    0x1(%eax),%edx
  800e18:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e20:	ff 4d f8             	decl   -0x8(%ebp)
  800e23:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e27:	79 e9                	jns    800e12 <memset+0x14>
		*p++ = c;

	return v;
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2c:	c9                   	leave  
  800e2d:	c3                   	ret    

00800e2e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e40:	eb 16                	jmp    800e58 <memcpy+0x2a>
		*d++ = *s++;
  800e42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e45:	8d 50 01             	lea    0x1(%eax),%edx
  800e48:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e51:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e54:	8a 12                	mov    (%edx),%dl
  800e56:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e58:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e61:	85 c0                	test   %eax,%eax
  800e63:	75 dd                	jne    800e42 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e68:	c9                   	leave  
  800e69:	c3                   	ret    

00800e6a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e82:	73 50                	jae    800ed4 <memmove+0x6a>
  800e84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	01 d0                	add    %edx,%eax
  800e8c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e8f:	76 43                	jbe    800ed4 <memmove+0x6a>
		s += n;
  800e91:	8b 45 10             	mov    0x10(%ebp),%eax
  800e94:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e97:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e9d:	eb 10                	jmp    800eaf <memmove+0x45>
			*--d = *--s;
  800e9f:	ff 4d f8             	decl   -0x8(%ebp)
  800ea2:	ff 4d fc             	decl   -0x4(%ebp)
  800ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea8:	8a 10                	mov    (%eax),%dl
  800eaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ead:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eaf:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb5:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb8:	85 c0                	test   %eax,%eax
  800eba:	75 e3                	jne    800e9f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ebc:	eb 23                	jmp    800ee1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ebe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec1:	8d 50 01             	lea    0x1(%eax),%edx
  800ec4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ecd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ed0:	8a 12                	mov    (%edx),%dl
  800ed2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eda:	89 55 10             	mov    %edx,0x10(%ebp)
  800edd:	85 c0                	test   %eax,%eax
  800edf:	75 dd                	jne    800ebe <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ef8:	eb 2a                	jmp    800f24 <memcmp+0x3e>
		if (*s1 != *s2)
  800efa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efd:	8a 10                	mov    (%eax),%dl
  800eff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	38 c2                	cmp    %al,%dl
  800f06:	74 16                	je     800f1e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	0f b6 d0             	movzbl %al,%edx
  800f10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	0f b6 c0             	movzbl %al,%eax
  800f18:	29 c2                	sub    %eax,%edx
  800f1a:	89 d0                	mov    %edx,%eax
  800f1c:	eb 18                	jmp    800f36 <memcmp+0x50>
		s1++, s2++;
  800f1e:	ff 45 fc             	incl   -0x4(%ebp)
  800f21:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f2a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	75 c9                	jne    800efa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	01 d0                	add    %edx,%eax
  800f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f49:	eb 15                	jmp    800f60 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 d0             	movzbl %al,%edx
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	0f b6 c0             	movzbl %al,%eax
  800f59:	39 c2                	cmp    %eax,%edx
  800f5b:	74 0d                	je     800f6a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f5d:	ff 45 08             	incl   0x8(%ebp)
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f66:	72 e3                	jb     800f4b <memfind+0x13>
  800f68:	eb 01                	jmp    800f6b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f6a:	90                   	nop
	return (void *) s;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f6e:	c9                   	leave  
  800f6f:	c3                   	ret    

00800f70 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f7d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f84:	eb 03                	jmp    800f89 <strtol+0x19>
		s++;
  800f86:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3c 20                	cmp    $0x20,%al
  800f90:	74 f4                	je     800f86 <strtol+0x16>
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	3c 09                	cmp    $0x9,%al
  800f99:	74 eb                	je     800f86 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	3c 2b                	cmp    $0x2b,%al
  800fa2:	75 05                	jne    800fa9 <strtol+0x39>
		s++;
  800fa4:	ff 45 08             	incl   0x8(%ebp)
  800fa7:	eb 13                	jmp    800fbc <strtol+0x4c>
	else if (*s == '-')
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3c 2d                	cmp    $0x2d,%al
  800fb0:	75 0a                	jne    800fbc <strtol+0x4c>
		s++, neg = 1;
  800fb2:	ff 45 08             	incl   0x8(%ebp)
  800fb5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc0:	74 06                	je     800fc8 <strtol+0x58>
  800fc2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fc6:	75 20                	jne    800fe8 <strtol+0x78>
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3c 30                	cmp    $0x30,%al
  800fcf:	75 17                	jne    800fe8 <strtol+0x78>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	40                   	inc    %eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 78                	cmp    $0x78,%al
  800fd9:	75 0d                	jne    800fe8 <strtol+0x78>
		s += 2, base = 16;
  800fdb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fdf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fe6:	eb 28                	jmp    801010 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fe8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fec:	75 15                	jne    801003 <strtol+0x93>
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	3c 30                	cmp    $0x30,%al
  800ff5:	75 0c                	jne    801003 <strtol+0x93>
		s++, base = 8;
  800ff7:	ff 45 08             	incl   0x8(%ebp)
  800ffa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801001:	eb 0d                	jmp    801010 <strtol+0xa0>
	else if (base == 0)
  801003:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801007:	75 07                	jne    801010 <strtol+0xa0>
		base = 10;
  801009:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 2f                	cmp    $0x2f,%al
  801017:	7e 19                	jle    801032 <strtol+0xc2>
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 39                	cmp    $0x39,%al
  801020:	7f 10                	jg     801032 <strtol+0xc2>
			dig = *s - '0';
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f be c0             	movsbl %al,%eax
  80102a:	83 e8 30             	sub    $0x30,%eax
  80102d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801030:	eb 42                	jmp    801074 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	3c 60                	cmp    $0x60,%al
  801039:	7e 19                	jle    801054 <strtol+0xe4>
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	3c 7a                	cmp    $0x7a,%al
  801042:	7f 10                	jg     801054 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	0f be c0             	movsbl %al,%eax
  80104c:	83 e8 57             	sub    $0x57,%eax
  80104f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801052:	eb 20                	jmp    801074 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 40                	cmp    $0x40,%al
  80105b:	7e 39                	jle    801096 <strtol+0x126>
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	3c 5a                	cmp    $0x5a,%al
  801064:	7f 30                	jg     801096 <strtol+0x126>
			dig = *s - 'A' + 10;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	0f be c0             	movsbl %al,%eax
  80106e:	83 e8 37             	sub    $0x37,%eax
  801071:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801077:	3b 45 10             	cmp    0x10(%ebp),%eax
  80107a:	7d 19                	jge    801095 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80107c:	ff 45 08             	incl   0x8(%ebp)
  80107f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801082:	0f af 45 10          	imul   0x10(%ebp),%eax
  801086:	89 c2                	mov    %eax,%edx
  801088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108b:	01 d0                	add    %edx,%eax
  80108d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801090:	e9 7b ff ff ff       	jmp    801010 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801095:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801096:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109a:	74 08                	je     8010a4 <strtol+0x134>
		*endptr = (char *) s;
  80109c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109f:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010a8:	74 07                	je     8010b1 <strtol+0x141>
  8010aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ad:	f7 d8                	neg    %eax
  8010af:	eb 03                	jmp    8010b4 <strtol+0x144>
  8010b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <ltostr>:

void
ltostr(long value, char *str)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ce:	79 13                	jns    8010e3 <ltostr+0x2d>
	{
		neg = 1;
  8010d0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010dd:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010e0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010eb:	99                   	cltd   
  8010ec:	f7 f9                	idiv   %ecx
  8010ee:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	8d 50 01             	lea    0x1(%eax),%edx
  8010f7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010fa:	89 c2                	mov    %eax,%edx
  8010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ff:	01 d0                	add    %edx,%eax
  801101:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801104:	83 c2 30             	add    $0x30,%edx
  801107:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801109:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80110c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801111:	f7 e9                	imul   %ecx
  801113:	c1 fa 02             	sar    $0x2,%edx
  801116:	89 c8                	mov    %ecx,%eax
  801118:	c1 f8 1f             	sar    $0x1f,%eax
  80111b:	29 c2                	sub    %eax,%edx
  80111d:	89 d0                	mov    %edx,%eax
  80111f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801122:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801125:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80112a:	f7 e9                	imul   %ecx
  80112c:	c1 fa 02             	sar    $0x2,%edx
  80112f:	89 c8                	mov    %ecx,%eax
  801131:	c1 f8 1f             	sar    $0x1f,%eax
  801134:	29 c2                	sub    %eax,%edx
  801136:	89 d0                	mov    %edx,%eax
  801138:	c1 e0 02             	shl    $0x2,%eax
  80113b:	01 d0                	add    %edx,%eax
  80113d:	01 c0                	add    %eax,%eax
  80113f:	29 c1                	sub    %eax,%ecx
  801141:	89 ca                	mov    %ecx,%edx
  801143:	85 d2                	test   %edx,%edx
  801145:	75 9c                	jne    8010e3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801147:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	48                   	dec    %eax
  801152:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801155:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801159:	74 3d                	je     801198 <ltostr+0xe2>
		start = 1 ;
  80115b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801162:	eb 34                	jmp    801198 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801164:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	01 d0                	add    %edx,%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801171:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	01 c2                	add    %eax,%edx
  801179:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	01 c8                	add    %ecx,%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801185:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	01 c2                	add    %eax,%edx
  80118d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801190:	88 02                	mov    %al,(%edx)
		start++ ;
  801192:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801195:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80119e:	7c c4                	jl     801164 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 d0                	add    %edx,%eax
  8011a8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ab:	90                   	nop
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011b4:	ff 75 08             	pushl  0x8(%ebp)
  8011b7:	e8 54 fa ff ff       	call   800c10 <strlen>
  8011bc:	83 c4 04             	add    $0x4,%esp
  8011bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011c2:	ff 75 0c             	pushl  0xc(%ebp)
  8011c5:	e8 46 fa ff ff       	call   800c10 <strlen>
  8011ca:	83 c4 04             	add    $0x4,%esp
  8011cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011de:	eb 17                	jmp    8011f7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	01 c2                	add    %eax,%edx
  8011e8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	01 c8                	add    %ecx,%eax
  8011f0:	8a 00                	mov    (%eax),%al
  8011f2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011f4:	ff 45 fc             	incl   -0x4(%ebp)
  8011f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011fd:	7c e1                	jl     8011e0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011ff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801206:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80120d:	eb 1f                	jmp    80122e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80120f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801212:	8d 50 01             	lea    0x1(%eax),%edx
  801215:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801218:	89 c2                	mov    %eax,%edx
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	01 c2                	add    %eax,%edx
  80121f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801222:	8b 45 0c             	mov    0xc(%ebp),%eax
  801225:	01 c8                	add    %ecx,%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80122b:	ff 45 f8             	incl   -0x8(%ebp)
  80122e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801231:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801234:	7c d9                	jl     80120f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801236:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801239:	8b 45 10             	mov    0x10(%ebp),%eax
  80123c:	01 d0                	add    %edx,%eax
  80123e:	c6 00 00             	movb   $0x0,(%eax)
}
  801241:	90                   	nop
  801242:	c9                   	leave  
  801243:	c3                   	ret    

00801244 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801250:	8b 45 14             	mov    0x14(%ebp),%eax
  801253:	8b 00                	mov    (%eax),%eax
  801255:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125c:	8b 45 10             	mov    0x10(%ebp),%eax
  80125f:	01 d0                	add    %edx,%eax
  801261:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801267:	eb 0c                	jmp    801275 <strsplit+0x31>
			*string++ = 0;
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8d 50 01             	lea    0x1(%eax),%edx
  80126f:	89 55 08             	mov    %edx,0x8(%ebp)
  801272:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	84 c0                	test   %al,%al
  80127c:	74 18                	je     801296 <strsplit+0x52>
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	0f be c0             	movsbl %al,%eax
  801286:	50                   	push   %eax
  801287:	ff 75 0c             	pushl  0xc(%ebp)
  80128a:	e8 13 fb ff ff       	call   800da2 <strchr>
  80128f:	83 c4 08             	add    $0x8,%esp
  801292:	85 c0                	test   %eax,%eax
  801294:	75 d3                	jne    801269 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	84 c0                	test   %al,%al
  80129d:	74 5a                	je     8012f9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80129f:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a2:	8b 00                	mov    (%eax),%eax
  8012a4:	83 f8 0f             	cmp    $0xf,%eax
  8012a7:	75 07                	jne    8012b0 <strsplit+0x6c>
		{
			return 0;
  8012a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ae:	eb 66                	jmp    801316 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b3:	8b 00                	mov    (%eax),%eax
  8012b5:	8d 48 01             	lea    0x1(%eax),%ecx
  8012b8:	8b 55 14             	mov    0x14(%ebp),%edx
  8012bb:	89 0a                	mov    %ecx,(%edx)
  8012bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c7:	01 c2                	add    %eax,%edx
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ce:	eb 03                	jmp    8012d3 <strsplit+0x8f>
			string++;
  8012d0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	84 c0                	test   %al,%al
  8012da:	74 8b                	je     801267 <strsplit+0x23>
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	8a 00                	mov    (%eax),%al
  8012e1:	0f be c0             	movsbl %al,%eax
  8012e4:	50                   	push   %eax
  8012e5:	ff 75 0c             	pushl  0xc(%ebp)
  8012e8:	e8 b5 fa ff ff       	call   800da2 <strchr>
  8012ed:	83 c4 08             	add    $0x8,%esp
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	74 dc                	je     8012d0 <strsplit+0x8c>
			string++;
	}
  8012f4:	e9 6e ff ff ff       	jmp    801267 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012f9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	01 d0                	add    %edx,%eax
  80130b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801311:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  80131e:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801325:	8b 55 08             	mov    0x8(%ebp),%edx
  801328:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80132b:	01 d0                	add    %edx,%eax
  80132d:	48                   	dec    %eax
  80132e:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801331:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801334:	ba 00 00 00 00       	mov    $0x0,%edx
  801339:	f7 75 ac             	divl   -0x54(%ebp)
  80133c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80133f:	29 d0                	sub    %edx,%eax
  801341:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801344:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  80134b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801352:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801359:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801360:	eb 3f                	jmp    8013a1 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801362:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801365:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80136c:	83 ec 04             	sub    $0x4,%esp
  80136f:	50                   	push   %eax
  801370:	ff 75 e8             	pushl  -0x18(%ebp)
  801373:	68 50 2a 80 00       	push   $0x802a50
  801378:	e8 11 f2 ff ff       	call   80058e <cprintf>
  80137d:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801380:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801383:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  80138a:	83 ec 04             	sub    $0x4,%esp
  80138d:	50                   	push   %eax
  80138e:	ff 75 e8             	pushl  -0x18(%ebp)
  801391:	68 65 2a 80 00       	push   $0x802a65
  801396:	e8 f3 f1 ff ff       	call   80058e <cprintf>
  80139b:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  80139e:	ff 45 e8             	incl   -0x18(%ebp)
  8013a1:	a1 28 30 80 00       	mov    0x803028,%eax
  8013a6:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8013a9:	7c b7                	jl     801362 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8013ab:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  8013b2:	e9 42 01 00 00       	jmp    8014f9 <malloc+0x1e1>
		int flag0=1;
  8013b7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8013be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013c4:	eb 6b                	jmp    801431 <malloc+0x119>
			for(int k=0;k<count;k++){
  8013c6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8013cd:	eb 42                	jmp    801411 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8013cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013d2:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8013d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013dc:	39 c2                	cmp    %eax,%edx
  8013de:	77 2e                	ja     80140e <malloc+0xf6>
  8013e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013e3:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8013ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013ed:	39 c2                	cmp    %eax,%edx
  8013ef:	76 1d                	jbe    80140e <malloc+0xf6>
					ni=arr_add[k].end-i;
  8013f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013f4:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8013fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013fe:	29 c2                	sub    %eax,%edx
  801400:	89 d0                	mov    %edx,%eax
  801402:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801405:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  80140c:	eb 0d                	jmp    80141b <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  80140e:	ff 45 d8             	incl   -0x28(%ebp)
  801411:	a1 28 30 80 00       	mov    0x803028,%eax
  801416:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801419:	7c b4                	jl     8013cf <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  80141b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80141f:	74 09                	je     80142a <malloc+0x112>
				flag0=0;
  801421:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801428:	eb 16                	jmp    801440 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  80142a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801431:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	01 c2                	add    %eax,%edx
  801439:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80143c:	39 c2                	cmp    %eax,%edx
  80143e:	77 86                	ja     8013c6 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801440:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801444:	0f 84 a2 00 00 00    	je     8014ec <malloc+0x1d4>

			int f=1;
  80144a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801451:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801454:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801457:	89 c8                	mov    %ecx,%eax
  801459:	01 c0                	add    %eax,%eax
  80145b:	01 c8                	add    %ecx,%eax
  80145d:	c1 e0 02             	shl    $0x2,%eax
  801460:	05 20 31 80 00       	add    $0x803120,%eax
  801465:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801467:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801470:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801473:	89 d0                	mov    %edx,%eax
  801475:	01 c0                	add    %eax,%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	c1 e0 02             	shl    $0x2,%eax
  80147c:	05 24 31 80 00       	add    $0x803124,%eax
  801481:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801483:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801486:	89 d0                	mov    %edx,%eax
  801488:	01 c0                	add    %eax,%eax
  80148a:	01 d0                	add    %edx,%eax
  80148c:	c1 e0 02             	shl    $0x2,%eax
  80148f:	05 28 31 80 00       	add    $0x803128,%eax
  801494:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  80149a:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  80149d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8014a4:	eb 36                	jmp    8014dc <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  8014a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	01 c2                	add    %eax,%edx
  8014ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014b1:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8014b8:	39 c2                	cmp    %eax,%edx
  8014ba:	73 1d                	jae    8014d9 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  8014bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014bf:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8014c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014c9:	29 c2                	sub    %eax,%edx
  8014cb:	89 d0                	mov    %edx,%eax
  8014cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  8014d0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  8014d7:	eb 0d                	jmp    8014e6 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  8014d9:	ff 45 d0             	incl   -0x30(%ebp)
  8014dc:	a1 28 30 80 00       	mov    0x803028,%eax
  8014e1:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8014e4:	7c c0                	jl     8014a6 <malloc+0x18e>
					break;

				}
			}

			if(f){
  8014e6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014ea:	75 1d                	jne    801509 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  8014ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8014f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f6:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8014f9:	a1 04 30 80 00       	mov    0x803004,%eax
  8014fe:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801501:	0f 8c b0 fe ff ff    	jl     8013b7 <malloc+0x9f>
  801507:	eb 01                	jmp    80150a <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801509:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  80150a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80150e:	75 7a                	jne    80158a <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801510:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	01 d0                	add    %edx,%eax
  80151b:	48                   	dec    %eax
  80151c:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801521:	7c 0a                	jl     80152d <malloc+0x215>
			return NULL;
  801523:	b8 00 00 00 00       	mov    $0x0,%eax
  801528:	e9 a4 02 00 00       	jmp    8017d1 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  80152d:	a1 04 30 80 00       	mov    0x803004,%eax
  801532:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801535:	a1 28 30 80 00       	mov    0x803028,%eax
  80153a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  80153d:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  801544:	83 ec 08             	sub    $0x8,%esp
  801547:	ff 75 08             	pushl  0x8(%ebp)
  80154a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80154d:	e8 04 06 00 00       	call   801b56 <sys_allocateMem>
  801552:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801555:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	01 d0                	add    %edx,%eax
  801560:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  801565:	a1 28 30 80 00       	mov    0x803028,%eax
  80156a:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801570:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  801577:	a1 28 30 80 00       	mov    0x803028,%eax
  80157c:	40                   	inc    %eax
  80157d:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  801582:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801585:	e9 47 02 00 00       	jmp    8017d1 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  80158a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801591:	e9 ac 00 00 00       	jmp    801642 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801596:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801599:	89 d0                	mov    %edx,%eax
  80159b:	01 c0                	add    %eax,%eax
  80159d:	01 d0                	add    %edx,%eax
  80159f:	c1 e0 02             	shl    $0x2,%eax
  8015a2:	05 24 31 80 00       	add    $0x803124,%eax
  8015a7:	8b 00                	mov    (%eax),%eax
  8015a9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8015ac:	eb 7e                	jmp    80162c <malloc+0x314>
			int flag=0;
  8015ae:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  8015b5:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8015bc:	eb 57                	jmp    801615 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8015be:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015c1:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8015c8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8015cb:	39 c2                	cmp    %eax,%edx
  8015cd:	77 1a                	ja     8015e9 <malloc+0x2d1>
  8015cf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015d2:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8015d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8015dc:	39 c2                	cmp    %eax,%edx
  8015de:	76 09                	jbe    8015e9 <malloc+0x2d1>
								flag=1;
  8015e0:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  8015e7:	eb 36                	jmp    80161f <malloc+0x307>
			arr[i].space++;
  8015e9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8015ec:	89 d0                	mov    %edx,%eax
  8015ee:	01 c0                	add    %eax,%eax
  8015f0:	01 d0                	add    %edx,%eax
  8015f2:	c1 e0 02             	shl    $0x2,%eax
  8015f5:	05 28 31 80 00       	add    $0x803128,%eax
  8015fa:	8b 00                	mov    (%eax),%eax
  8015fc:	8d 48 01             	lea    0x1(%eax),%ecx
  8015ff:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801602:	89 d0                	mov    %edx,%eax
  801604:	01 c0                	add    %eax,%eax
  801606:	01 d0                	add    %edx,%eax
  801608:	c1 e0 02             	shl    $0x2,%eax
  80160b:	05 28 31 80 00       	add    $0x803128,%eax
  801610:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801612:	ff 45 c0             	incl   -0x40(%ebp)
  801615:	a1 28 30 80 00       	mov    0x803028,%eax
  80161a:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  80161d:	7c 9f                	jl     8015be <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  80161f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801623:	75 19                	jne    80163e <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801625:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  80162c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80162f:	a1 04 30 80 00       	mov    0x803004,%eax
  801634:	39 c2                	cmp    %eax,%edx
  801636:	0f 82 72 ff ff ff    	jb     8015ae <malloc+0x296>
  80163c:	eb 01                	jmp    80163f <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  80163e:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  80163f:	ff 45 cc             	incl   -0x34(%ebp)
  801642:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801645:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801648:	0f 8c 48 ff ff ff    	jl     801596 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  80164e:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801655:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  80165c:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801663:	eb 37                	jmp    80169c <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801665:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801668:	89 d0                	mov    %edx,%eax
  80166a:	01 c0                	add    %eax,%eax
  80166c:	01 d0                	add    %edx,%eax
  80166e:	c1 e0 02             	shl    $0x2,%eax
  801671:	05 28 31 80 00       	add    $0x803128,%eax
  801676:	8b 00                	mov    (%eax),%eax
  801678:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80167b:	7d 1c                	jge    801699 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  80167d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801680:	89 d0                	mov    %edx,%eax
  801682:	01 c0                	add    %eax,%eax
  801684:	01 d0                	add    %edx,%eax
  801686:	c1 e0 02             	shl    $0x2,%eax
  801689:	05 28 31 80 00       	add    $0x803128,%eax
  80168e:	8b 00                	mov    (%eax),%eax
  801690:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801693:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801696:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801699:	ff 45 b4             	incl   -0x4c(%ebp)
  80169c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80169f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016a2:	7c c1                	jl     801665 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  8016a4:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8016aa:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8016ad:	89 c8                	mov    %ecx,%eax
  8016af:	01 c0                	add    %eax,%eax
  8016b1:	01 c8                	add    %ecx,%eax
  8016b3:	c1 e0 02             	shl    $0x2,%eax
  8016b6:	05 20 31 80 00       	add    $0x803120,%eax
  8016bb:	8b 00                	mov    (%eax),%eax
  8016bd:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  8016c4:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8016ca:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8016cd:	89 c8                	mov    %ecx,%eax
  8016cf:	01 c0                	add    %eax,%eax
  8016d1:	01 c8                	add    %ecx,%eax
  8016d3:	c1 e0 02             	shl    $0x2,%eax
  8016d6:	05 24 31 80 00       	add    $0x803124,%eax
  8016db:	8b 00                	mov    (%eax),%eax
  8016dd:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  8016e4:	a1 28 30 80 00       	mov    0x803028,%eax
  8016e9:	40                   	inc    %eax
  8016ea:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  8016ef:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8016f2:	89 d0                	mov    %edx,%eax
  8016f4:	01 c0                	add    %eax,%eax
  8016f6:	01 d0                	add    %edx,%eax
  8016f8:	c1 e0 02             	shl    $0x2,%eax
  8016fb:	05 20 31 80 00       	add    $0x803120,%eax
  801700:	8b 00                	mov    (%eax),%eax
  801702:	83 ec 08             	sub    $0x8,%esp
  801705:	ff 75 08             	pushl  0x8(%ebp)
  801708:	50                   	push   %eax
  801709:	e8 48 04 00 00       	call   801b56 <sys_allocateMem>
  80170e:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801711:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801718:	eb 78                	jmp    801792 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  80171a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80171d:	89 d0                	mov    %edx,%eax
  80171f:	01 c0                	add    %eax,%eax
  801721:	01 d0                	add    %edx,%eax
  801723:	c1 e0 02             	shl    $0x2,%eax
  801726:	05 20 31 80 00       	add    $0x803120,%eax
  80172b:	8b 00                	mov    (%eax),%eax
  80172d:	83 ec 04             	sub    $0x4,%esp
  801730:	50                   	push   %eax
  801731:	ff 75 b0             	pushl  -0x50(%ebp)
  801734:	68 50 2a 80 00       	push   $0x802a50
  801739:	e8 50 ee ff ff       	call   80058e <cprintf>
  80173e:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801741:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801744:	89 d0                	mov    %edx,%eax
  801746:	01 c0                	add    %eax,%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	c1 e0 02             	shl    $0x2,%eax
  80174d:	05 24 31 80 00       	add    $0x803124,%eax
  801752:	8b 00                	mov    (%eax),%eax
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	50                   	push   %eax
  801758:	ff 75 b0             	pushl  -0x50(%ebp)
  80175b:	68 65 2a 80 00       	push   $0x802a65
  801760:	e8 29 ee ff ff       	call   80058e <cprintf>
  801765:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801768:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80176b:	89 d0                	mov    %edx,%eax
  80176d:	01 c0                	add    %eax,%eax
  80176f:	01 d0                	add    %edx,%eax
  801771:	c1 e0 02             	shl    $0x2,%eax
  801774:	05 28 31 80 00       	add    $0x803128,%eax
  801779:	8b 00                	mov    (%eax),%eax
  80177b:	83 ec 04             	sub    $0x4,%esp
  80177e:	50                   	push   %eax
  80177f:	ff 75 b0             	pushl  -0x50(%ebp)
  801782:	68 78 2a 80 00       	push   $0x802a78
  801787:	e8 02 ee ff ff       	call   80058e <cprintf>
  80178c:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  80178f:	ff 45 b0             	incl   -0x50(%ebp)
  801792:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801795:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801798:	7c 80                	jl     80171a <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  80179a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80179d:	89 d0                	mov    %edx,%eax
  80179f:	01 c0                	add    %eax,%eax
  8017a1:	01 d0                	add    %edx,%eax
  8017a3:	c1 e0 02             	shl    $0x2,%eax
  8017a6:	05 20 31 80 00       	add    $0x803120,%eax
  8017ab:	8b 00                	mov    (%eax),%eax
  8017ad:	83 ec 08             	sub    $0x8,%esp
  8017b0:	50                   	push   %eax
  8017b1:	68 8c 2a 80 00       	push   $0x802a8c
  8017b6:	e8 d3 ed ff ff       	call   80058e <cprintf>
  8017bb:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  8017be:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8017c1:	89 d0                	mov    %edx,%eax
  8017c3:	01 c0                	add    %eax,%eax
  8017c5:	01 d0                	add    %edx,%eax
  8017c7:	c1 e0 02             	shl    $0x2,%eax
  8017ca:	05 20 31 80 00       	add    $0x803120,%eax
  8017cf:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  8017df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8017e6:	eb 4b                	jmp    801833 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  8017e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017eb:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8017f2:	89 c2                	mov    %eax,%edx
  8017f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017f7:	39 c2                	cmp    %eax,%edx
  8017f9:	7f 35                	jg     801830 <free+0x5d>
  8017fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fe:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801805:	89 c2                	mov    %eax,%edx
  801807:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80180a:	39 c2                	cmp    %eax,%edx
  80180c:	7e 22                	jle    801830 <free+0x5d>
				start=arr_add[i].start;
  80180e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801811:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801818:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  80181b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181e:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801825:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801828:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80182b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  80182e:	eb 0d                	jmp    80183d <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801830:	ff 45 ec             	incl   -0x14(%ebp)
  801833:	a1 28 30 80 00       	mov    0x803028,%eax
  801838:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80183b:	7c ab                	jl     8017e8 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  80183d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801840:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184a:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801851:	29 c2                	sub    %eax,%edx
  801853:	89 d0                	mov    %edx,%eax
  801855:	83 ec 08             	sub    $0x8,%esp
  801858:	50                   	push   %eax
  801859:	ff 75 f4             	pushl  -0xc(%ebp)
  80185c:	e8 d9 02 00 00       	call   801b3a <sys_freeMem>
  801861:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801867:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80186a:	eb 2d                	jmp    801899 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  80186c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80186f:	40                   	inc    %eax
  801870:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801877:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80187a:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801881:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801884:	40                   	inc    %eax
  801885:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80188c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80188f:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801896:	ff 45 e8             	incl   -0x18(%ebp)
  801899:	a1 28 30 80 00       	mov    0x803028,%eax
  80189e:	48                   	dec    %eax
  80189f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018a2:	7f c8                	jg     80186c <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  8018a4:	a1 28 30 80 00       	mov    0x803028,%eax
  8018a9:	48                   	dec    %eax
  8018aa:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  8018af:	90                   	nop
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 18             	sub    $0x18,%esp
  8018b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bb:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	68 a8 2a 80 00       	push   $0x802aa8
  8018c6:	68 18 01 00 00       	push   $0x118
  8018cb:	68 cb 2a 80 00       	push   $0x802acb
  8018d0:	e8 17 ea ff ff       	call   8002ec <_panic>

008018d5 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018db:	83 ec 04             	sub    $0x4,%esp
  8018de:	68 a8 2a 80 00       	push   $0x802aa8
  8018e3:	68 1e 01 00 00       	push   $0x11e
  8018e8:	68 cb 2a 80 00       	push   $0x802acb
  8018ed:	e8 fa e9 ff ff       	call   8002ec <_panic>

008018f2 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018f8:	83 ec 04             	sub    $0x4,%esp
  8018fb:	68 a8 2a 80 00       	push   $0x802aa8
  801900:	68 24 01 00 00       	push   $0x124
  801905:	68 cb 2a 80 00       	push   $0x802acb
  80190a:	e8 dd e9 ff ff       	call   8002ec <_panic>

0080190f <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801915:	83 ec 04             	sub    $0x4,%esp
  801918:	68 a8 2a 80 00       	push   $0x802aa8
  80191d:	68 29 01 00 00       	push   $0x129
  801922:	68 cb 2a 80 00       	push   $0x802acb
  801927:	e8 c0 e9 ff ff       	call   8002ec <_panic>

0080192c <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801932:	83 ec 04             	sub    $0x4,%esp
  801935:	68 a8 2a 80 00       	push   $0x802aa8
  80193a:	68 2f 01 00 00       	push   $0x12f
  80193f:	68 cb 2a 80 00       	push   $0x802acb
  801944:	e8 a3 e9 ff ff       	call   8002ec <_panic>

00801949 <shrink>:
}
void shrink(uint32 newSize)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80194f:	83 ec 04             	sub    $0x4,%esp
  801952:	68 a8 2a 80 00       	push   $0x802aa8
  801957:	68 33 01 00 00       	push   $0x133
  80195c:	68 cb 2a 80 00       	push   $0x802acb
  801961:	e8 86 e9 ff ff       	call   8002ec <_panic>

00801966 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80196c:	83 ec 04             	sub    $0x4,%esp
  80196f:	68 a8 2a 80 00       	push   $0x802aa8
  801974:	68 38 01 00 00       	push   $0x138
  801979:	68 cb 2a 80 00       	push   $0x802acb
  80197e:	e8 69 e9 ff ff       	call   8002ec <_panic>

00801983 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	57                   	push   %edi
  801987:	56                   	push   %esi
  801988:	53                   	push   %ebx
  801989:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801992:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801995:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801998:	8b 7d 18             	mov    0x18(%ebp),%edi
  80199b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80199e:	cd 30                	int    $0x30
  8019a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	5b                   	pop    %ebx
  8019aa:	5e                   	pop    %esi
  8019ab:	5f                   	pop    %edi
  8019ac:	5d                   	pop    %ebp
  8019ad:	c3                   	ret    

008019ae <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019ba:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	52                   	push   %edx
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	50                   	push   %eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	e8 b2 ff ff ff       	call   801983 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	90                   	nop
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 01                	push   $0x1
  8019e6:	e8 98 ff ff ff       	call   801983 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	50                   	push   %eax
  8019ff:	6a 05                	push   $0x5
  801a01:	e8 7d ff ff ff       	call   801983 <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 02                	push   $0x2
  801a1a:	e8 64 ff ff ff       	call   801983 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 03                	push   $0x3
  801a33:	e8 4b ff ff ff       	call   801983 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 04                	push   $0x4
  801a4c:	e8 32 ff ff ff       	call   801983 <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_env_exit>:


void sys_env_exit(void)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 06                	push   $0x6
  801a65:	e8 19 ff ff ff       	call   801983 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	90                   	nop
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	52                   	push   %edx
  801a80:	50                   	push   %eax
  801a81:	6a 07                	push   $0x7
  801a83:	e8 fb fe ff ff       	call   801983 <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	56                   	push   %esi
  801a91:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a92:	8b 75 18             	mov    0x18(%ebp),%esi
  801a95:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	56                   	push   %esi
  801aa2:	53                   	push   %ebx
  801aa3:	51                   	push   %ecx
  801aa4:	52                   	push   %edx
  801aa5:	50                   	push   %eax
  801aa6:	6a 08                	push   $0x8
  801aa8:	e8 d6 fe ff ff       	call   801983 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab3:	5b                   	pop    %ebx
  801ab4:	5e                   	pop    %esi
  801ab5:	5d                   	pop    %ebp
  801ab6:	c3                   	ret    

00801ab7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801aba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	52                   	push   %edx
  801ac7:	50                   	push   %eax
  801ac8:	6a 09                	push   $0x9
  801aca:	e8 b4 fe ff ff       	call   801983 <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	ff 75 0c             	pushl  0xc(%ebp)
  801ae0:	ff 75 08             	pushl  0x8(%ebp)
  801ae3:	6a 0a                	push   $0xa
  801ae5:	e8 99 fe ff ff       	call   801983 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 0b                	push   $0xb
  801afe:	e8 80 fe ff ff       	call   801983 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 0c                	push   $0xc
  801b17:	e8 67 fe ff ff       	call   801983 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 0d                	push   $0xd
  801b30:	e8 4e fe ff ff       	call   801983 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	ff 75 0c             	pushl  0xc(%ebp)
  801b46:	ff 75 08             	pushl  0x8(%ebp)
  801b49:	6a 11                	push   $0x11
  801b4b:	e8 33 fe ff ff       	call   801983 <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
	return;
  801b53:	90                   	nop
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	ff 75 0c             	pushl  0xc(%ebp)
  801b62:	ff 75 08             	pushl  0x8(%ebp)
  801b65:	6a 12                	push   $0x12
  801b67:	e8 17 fe ff ff       	call   801983 <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6f:	90                   	nop
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 0e                	push   $0xe
  801b81:	e8 fd fd ff ff       	call   801983 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	ff 75 08             	pushl  0x8(%ebp)
  801b99:	6a 0f                	push   $0xf
  801b9b:	e8 e3 fd ff ff       	call   801983 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 10                	push   $0x10
  801bb4:	e8 ca fd ff ff       	call   801983 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	90                   	nop
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 14                	push   $0x14
  801bce:	e8 b0 fd ff ff       	call   801983 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	90                   	nop
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 15                	push   $0x15
  801be8:	e8 96 fd ff ff       	call   801983 <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	90                   	nop
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_cputc>:


void
sys_cputc(const char c)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	50                   	push   %eax
  801c0c:	6a 16                	push   $0x16
  801c0e:	e8 70 fd ff ff       	call   801983 <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
}
  801c16:	90                   	nop
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 17                	push   $0x17
  801c28:	e8 56 fd ff ff       	call   801983 <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	90                   	nop
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	ff 75 0c             	pushl  0xc(%ebp)
  801c42:	50                   	push   %eax
  801c43:	6a 18                	push   $0x18
  801c45:	e8 39 fd ff ff       	call   801983 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	52                   	push   %edx
  801c5f:	50                   	push   %eax
  801c60:	6a 1b                	push   $0x1b
  801c62:	e8 1c fd ff ff       	call   801983 <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	52                   	push   %edx
  801c7c:	50                   	push   %eax
  801c7d:	6a 19                	push   $0x19
  801c7f:	e8 ff fc ff ff       	call   801983 <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
}
  801c87:	90                   	nop
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	52                   	push   %edx
  801c9a:	50                   	push   %eax
  801c9b:	6a 1a                	push   $0x1a
  801c9d:	e8 e1 fc ff ff       	call   801983 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	90                   	nop
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 04             	sub    $0x4,%esp
  801cae:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cb4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cb7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	51                   	push   %ecx
  801cc1:	52                   	push   %edx
  801cc2:	ff 75 0c             	pushl  0xc(%ebp)
  801cc5:	50                   	push   %eax
  801cc6:	6a 1c                	push   $0x1c
  801cc8:	e8 b6 fc ff ff       	call   801983 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	52                   	push   %edx
  801ce2:	50                   	push   %eax
  801ce3:	6a 1d                	push   $0x1d
  801ce5:	e8 99 fc ff ff       	call   801983 <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cf2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	51                   	push   %ecx
  801d00:	52                   	push   %edx
  801d01:	50                   	push   %eax
  801d02:	6a 1e                	push   $0x1e
  801d04:	e8 7a fc ff ff       	call   801983 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	52                   	push   %edx
  801d1e:	50                   	push   %eax
  801d1f:	6a 1f                	push   $0x1f
  801d21:	e8 5d fc ff ff       	call   801983 <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 20                	push   $0x20
  801d3a:	e8 44 fc ff ff       	call   801983 <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	6a 00                	push   $0x0
  801d4c:	ff 75 14             	pushl  0x14(%ebp)
  801d4f:	ff 75 10             	pushl  0x10(%ebp)
  801d52:	ff 75 0c             	pushl  0xc(%ebp)
  801d55:	50                   	push   %eax
  801d56:	6a 21                	push   $0x21
  801d58:	e8 26 fc ff ff       	call   801983 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	50                   	push   %eax
  801d71:	6a 22                	push   $0x22
  801d73:	e8 0b fc ff ff       	call   801983 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
}
  801d7b:	90                   	nop
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	50                   	push   %eax
  801d8d:	6a 23                	push   $0x23
  801d8f:	e8 ef fb ff ff       	call   801983 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
}
  801d97:	90                   	nop
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801da0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801da3:	8d 50 04             	lea    0x4(%eax),%edx
  801da6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	52                   	push   %edx
  801db0:	50                   	push   %eax
  801db1:	6a 24                	push   $0x24
  801db3:	e8 cb fb ff ff       	call   801983 <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
	return result;
  801dbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dc1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dc4:	89 01                	mov    %eax,(%ecx)
  801dc6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	c9                   	leave  
  801dcd:	c2 04 00             	ret    $0x4

00801dd0 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	ff 75 10             	pushl  0x10(%ebp)
  801dda:	ff 75 0c             	pushl  0xc(%ebp)
  801ddd:	ff 75 08             	pushl  0x8(%ebp)
  801de0:	6a 13                	push   $0x13
  801de2:	e8 9c fb ff ff       	call   801983 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dea:	90                   	nop
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_rcr2>:
uint32 sys_rcr2()
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 25                	push   $0x25
  801dfc:	e8 82 fb ff ff       	call   801983 <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	83 ec 04             	sub    $0x4,%esp
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e12:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	50                   	push   %eax
  801e1f:	6a 26                	push   $0x26
  801e21:	e8 5d fb ff ff       	call   801983 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
	return ;
  801e29:	90                   	nop
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <rsttst>:
void rsttst()
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 28                	push   $0x28
  801e3b:	e8 43 fb ff ff       	call   801983 <syscall>
  801e40:	83 c4 18             	add    $0x18,%esp
	return ;
  801e43:	90                   	nop
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 04             	sub    $0x4,%esp
  801e4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801e4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e52:	8b 55 18             	mov    0x18(%ebp),%edx
  801e55:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e59:	52                   	push   %edx
  801e5a:	50                   	push   %eax
  801e5b:	ff 75 10             	pushl  0x10(%ebp)
  801e5e:	ff 75 0c             	pushl  0xc(%ebp)
  801e61:	ff 75 08             	pushl  0x8(%ebp)
  801e64:	6a 27                	push   $0x27
  801e66:	e8 18 fb ff ff       	call   801983 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6e:	90                   	nop
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <chktst>:
void chktst(uint32 n)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	ff 75 08             	pushl  0x8(%ebp)
  801e7f:	6a 29                	push   $0x29
  801e81:	e8 fd fa ff ff       	call   801983 <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
	return ;
  801e89:	90                   	nop
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <inctst>:

void inctst()
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 2a                	push   $0x2a
  801e9b:	e8 e3 fa ff ff       	call   801983 <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea3:	90                   	nop
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <gettst>:
uint32 gettst()
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 2b                	push   $0x2b
  801eb5:	e8 c9 fa ff ff       	call   801983 <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 2c                	push   $0x2c
  801ed1:	e8 ad fa ff ff       	call   801983 <syscall>
  801ed6:	83 c4 18             	add    $0x18,%esp
  801ed9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801edc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ee0:	75 07                	jne    801ee9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ee2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee7:	eb 05                	jmp    801eee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ee9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 2c                	push   $0x2c
  801f02:	e8 7c fa ff ff       	call   801983 <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
  801f0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f0d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f11:	75 07                	jne    801f1a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f13:	b8 01 00 00 00       	mov    $0x1,%eax
  801f18:	eb 05                	jmp    801f1f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 2c                	push   $0x2c
  801f33:	e8 4b fa ff ff       	call   801983 <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
  801f3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f3e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f42:	75 07                	jne    801f4b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f44:	b8 01 00 00 00       	mov    $0x1,%eax
  801f49:	eb 05                	jmp    801f50 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 2c                	push   $0x2c
  801f64:	e8 1a fa ff ff       	call   801983 <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
  801f6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f6f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f73:	75 07                	jne    801f7c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f75:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7a:	eb 05                	jmp    801f81 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	ff 75 08             	pushl  0x8(%ebp)
  801f91:	6a 2d                	push   $0x2d
  801f93:	e8 eb f9 ff ff       	call   801983 <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9b:	90                   	nop
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fa2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	6a 00                	push   $0x0
  801fb0:	53                   	push   %ebx
  801fb1:	51                   	push   %ecx
  801fb2:	52                   	push   %edx
  801fb3:	50                   	push   %eax
  801fb4:	6a 2e                	push   $0x2e
  801fb6:	e8 c8 f9 ff ff       	call   801983 <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
}
  801fbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	52                   	push   %edx
  801fd3:	50                   	push   %eax
  801fd4:	6a 2f                	push   $0x2f
  801fd6:	e8 a8 f9 ff ff       	call   801983 <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
}
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe9:	89 d0                	mov    %edx,%eax
  801feb:	c1 e0 02             	shl    $0x2,%eax
  801fee:	01 d0                	add    %edx,%eax
  801ff0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ff7:	01 d0                	add    %edx,%eax
  801ff9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802000:	01 d0                	add    %edx,%eax
  802002:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802009:	01 d0                	add    %edx,%eax
  80200b:	c1 e0 04             	shl    $0x4,%eax
  80200e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802011:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802018:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80201b:	83 ec 0c             	sub    $0xc,%esp
  80201e:	50                   	push   %eax
  80201f:	e8 76 fd ff ff       	call   801d9a <sys_get_virtual_time>
  802024:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802027:	eb 41                	jmp    80206a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802029:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	50                   	push   %eax
  802030:	e8 65 fd ff ff       	call   801d9a <sys_get_virtual_time>
  802035:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802038:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80203b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80203e:	29 c2                	sub    %eax,%edx
  802040:	89 d0                	mov    %edx,%eax
  802042:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802045:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802048:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204b:	89 d1                	mov    %edx,%ecx
  80204d:	29 c1                	sub    %eax,%ecx
  80204f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802052:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802055:	39 c2                	cmp    %eax,%edx
  802057:	0f 97 c0             	seta   %al
  80205a:	0f b6 c0             	movzbl %al,%eax
  80205d:	29 c1                	sub    %eax,%ecx
  80205f:	89 c8                	mov    %ecx,%eax
  802061:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802064:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802067:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802070:	72 b7                	jb     802029 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802072:	90                   	nop
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80207b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802082:	eb 03                	jmp    802087 <busy_wait+0x12>
  802084:	ff 45 fc             	incl   -0x4(%ebp)
  802087:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80208a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80208d:	72 f5                	jb     802084 <busy_wait+0xf>
	return i;
  80208f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <__udivdi3>:
  802094:	55                   	push   %ebp
  802095:	57                   	push   %edi
  802096:	56                   	push   %esi
  802097:	53                   	push   %ebx
  802098:	83 ec 1c             	sub    $0x1c,%esp
  80209b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80209f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020ab:	89 ca                	mov    %ecx,%edx
  8020ad:	89 f8                	mov    %edi,%eax
  8020af:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020b3:	85 f6                	test   %esi,%esi
  8020b5:	75 2d                	jne    8020e4 <__udivdi3+0x50>
  8020b7:	39 cf                	cmp    %ecx,%edi
  8020b9:	77 65                	ja     802120 <__udivdi3+0x8c>
  8020bb:	89 fd                	mov    %edi,%ebp
  8020bd:	85 ff                	test   %edi,%edi
  8020bf:	75 0b                	jne    8020cc <__udivdi3+0x38>
  8020c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c6:	31 d2                	xor    %edx,%edx
  8020c8:	f7 f7                	div    %edi
  8020ca:	89 c5                	mov    %eax,%ebp
  8020cc:	31 d2                	xor    %edx,%edx
  8020ce:	89 c8                	mov    %ecx,%eax
  8020d0:	f7 f5                	div    %ebp
  8020d2:	89 c1                	mov    %eax,%ecx
  8020d4:	89 d8                	mov    %ebx,%eax
  8020d6:	f7 f5                	div    %ebp
  8020d8:	89 cf                	mov    %ecx,%edi
  8020da:	89 fa                	mov    %edi,%edx
  8020dc:	83 c4 1c             	add    $0x1c,%esp
  8020df:	5b                   	pop    %ebx
  8020e0:	5e                   	pop    %esi
  8020e1:	5f                   	pop    %edi
  8020e2:	5d                   	pop    %ebp
  8020e3:	c3                   	ret    
  8020e4:	39 ce                	cmp    %ecx,%esi
  8020e6:	77 28                	ja     802110 <__udivdi3+0x7c>
  8020e8:	0f bd fe             	bsr    %esi,%edi
  8020eb:	83 f7 1f             	xor    $0x1f,%edi
  8020ee:	75 40                	jne    802130 <__udivdi3+0x9c>
  8020f0:	39 ce                	cmp    %ecx,%esi
  8020f2:	72 0a                	jb     8020fe <__udivdi3+0x6a>
  8020f4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8020f8:	0f 87 9e 00 00 00    	ja     80219c <__udivdi3+0x108>
  8020fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802103:	89 fa                	mov    %edi,%edx
  802105:	83 c4 1c             	add    $0x1c,%esp
  802108:	5b                   	pop    %ebx
  802109:	5e                   	pop    %esi
  80210a:	5f                   	pop    %edi
  80210b:	5d                   	pop    %ebp
  80210c:	c3                   	ret    
  80210d:	8d 76 00             	lea    0x0(%esi),%esi
  802110:	31 ff                	xor    %edi,%edi
  802112:	31 c0                	xor    %eax,%eax
  802114:	89 fa                	mov    %edi,%edx
  802116:	83 c4 1c             	add    $0x1c,%esp
  802119:	5b                   	pop    %ebx
  80211a:	5e                   	pop    %esi
  80211b:	5f                   	pop    %edi
  80211c:	5d                   	pop    %ebp
  80211d:	c3                   	ret    
  80211e:	66 90                	xchg   %ax,%ax
  802120:	89 d8                	mov    %ebx,%eax
  802122:	f7 f7                	div    %edi
  802124:	31 ff                	xor    %edi,%edi
  802126:	89 fa                	mov    %edi,%edx
  802128:	83 c4 1c             	add    $0x1c,%esp
  80212b:	5b                   	pop    %ebx
  80212c:	5e                   	pop    %esi
  80212d:	5f                   	pop    %edi
  80212e:	5d                   	pop    %ebp
  80212f:	c3                   	ret    
  802130:	bd 20 00 00 00       	mov    $0x20,%ebp
  802135:	89 eb                	mov    %ebp,%ebx
  802137:	29 fb                	sub    %edi,%ebx
  802139:	89 f9                	mov    %edi,%ecx
  80213b:	d3 e6                	shl    %cl,%esi
  80213d:	89 c5                	mov    %eax,%ebp
  80213f:	88 d9                	mov    %bl,%cl
  802141:	d3 ed                	shr    %cl,%ebp
  802143:	89 e9                	mov    %ebp,%ecx
  802145:	09 f1                	or     %esi,%ecx
  802147:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80214b:	89 f9                	mov    %edi,%ecx
  80214d:	d3 e0                	shl    %cl,%eax
  80214f:	89 c5                	mov    %eax,%ebp
  802151:	89 d6                	mov    %edx,%esi
  802153:	88 d9                	mov    %bl,%cl
  802155:	d3 ee                	shr    %cl,%esi
  802157:	89 f9                	mov    %edi,%ecx
  802159:	d3 e2                	shl    %cl,%edx
  80215b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80215f:	88 d9                	mov    %bl,%cl
  802161:	d3 e8                	shr    %cl,%eax
  802163:	09 c2                	or     %eax,%edx
  802165:	89 d0                	mov    %edx,%eax
  802167:	89 f2                	mov    %esi,%edx
  802169:	f7 74 24 0c          	divl   0xc(%esp)
  80216d:	89 d6                	mov    %edx,%esi
  80216f:	89 c3                	mov    %eax,%ebx
  802171:	f7 e5                	mul    %ebp
  802173:	39 d6                	cmp    %edx,%esi
  802175:	72 19                	jb     802190 <__udivdi3+0xfc>
  802177:	74 0b                	je     802184 <__udivdi3+0xf0>
  802179:	89 d8                	mov    %ebx,%eax
  80217b:	31 ff                	xor    %edi,%edi
  80217d:	e9 58 ff ff ff       	jmp    8020da <__udivdi3+0x46>
  802182:	66 90                	xchg   %ax,%ax
  802184:	8b 54 24 08          	mov    0x8(%esp),%edx
  802188:	89 f9                	mov    %edi,%ecx
  80218a:	d3 e2                	shl    %cl,%edx
  80218c:	39 c2                	cmp    %eax,%edx
  80218e:	73 e9                	jae    802179 <__udivdi3+0xe5>
  802190:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802193:	31 ff                	xor    %edi,%edi
  802195:	e9 40 ff ff ff       	jmp    8020da <__udivdi3+0x46>
  80219a:	66 90                	xchg   %ax,%ax
  80219c:	31 c0                	xor    %eax,%eax
  80219e:	e9 37 ff ff ff       	jmp    8020da <__udivdi3+0x46>
  8021a3:	90                   	nop

008021a4 <__umoddi3>:
  8021a4:	55                   	push   %ebp
  8021a5:	57                   	push   %edi
  8021a6:	56                   	push   %esi
  8021a7:	53                   	push   %ebx
  8021a8:	83 ec 1c             	sub    $0x1c,%esp
  8021ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021c3:	89 f3                	mov    %esi,%ebx
  8021c5:	89 fa                	mov    %edi,%edx
  8021c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021cb:	89 34 24             	mov    %esi,(%esp)
  8021ce:	85 c0                	test   %eax,%eax
  8021d0:	75 1a                	jne    8021ec <__umoddi3+0x48>
  8021d2:	39 f7                	cmp    %esi,%edi
  8021d4:	0f 86 a2 00 00 00    	jbe    80227c <__umoddi3+0xd8>
  8021da:	89 c8                	mov    %ecx,%eax
  8021dc:	89 f2                	mov    %esi,%edx
  8021de:	f7 f7                	div    %edi
  8021e0:	89 d0                	mov    %edx,%eax
  8021e2:	31 d2                	xor    %edx,%edx
  8021e4:	83 c4 1c             	add    $0x1c,%esp
  8021e7:	5b                   	pop    %ebx
  8021e8:	5e                   	pop    %esi
  8021e9:	5f                   	pop    %edi
  8021ea:	5d                   	pop    %ebp
  8021eb:	c3                   	ret    
  8021ec:	39 f0                	cmp    %esi,%eax
  8021ee:	0f 87 ac 00 00 00    	ja     8022a0 <__umoddi3+0xfc>
  8021f4:	0f bd e8             	bsr    %eax,%ebp
  8021f7:	83 f5 1f             	xor    $0x1f,%ebp
  8021fa:	0f 84 ac 00 00 00    	je     8022ac <__umoddi3+0x108>
  802200:	bf 20 00 00 00       	mov    $0x20,%edi
  802205:	29 ef                	sub    %ebp,%edi
  802207:	89 fe                	mov    %edi,%esi
  802209:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80220d:	89 e9                	mov    %ebp,%ecx
  80220f:	d3 e0                	shl    %cl,%eax
  802211:	89 d7                	mov    %edx,%edi
  802213:	89 f1                	mov    %esi,%ecx
  802215:	d3 ef                	shr    %cl,%edi
  802217:	09 c7                	or     %eax,%edi
  802219:	89 e9                	mov    %ebp,%ecx
  80221b:	d3 e2                	shl    %cl,%edx
  80221d:	89 14 24             	mov    %edx,(%esp)
  802220:	89 d8                	mov    %ebx,%eax
  802222:	d3 e0                	shl    %cl,%eax
  802224:	89 c2                	mov    %eax,%edx
  802226:	8b 44 24 08          	mov    0x8(%esp),%eax
  80222a:	d3 e0                	shl    %cl,%eax
  80222c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802230:	8b 44 24 08          	mov    0x8(%esp),%eax
  802234:	89 f1                	mov    %esi,%ecx
  802236:	d3 e8                	shr    %cl,%eax
  802238:	09 d0                	or     %edx,%eax
  80223a:	d3 eb                	shr    %cl,%ebx
  80223c:	89 da                	mov    %ebx,%edx
  80223e:	f7 f7                	div    %edi
  802240:	89 d3                	mov    %edx,%ebx
  802242:	f7 24 24             	mull   (%esp)
  802245:	89 c6                	mov    %eax,%esi
  802247:	89 d1                	mov    %edx,%ecx
  802249:	39 d3                	cmp    %edx,%ebx
  80224b:	0f 82 87 00 00 00    	jb     8022d8 <__umoddi3+0x134>
  802251:	0f 84 91 00 00 00    	je     8022e8 <__umoddi3+0x144>
  802257:	8b 54 24 04          	mov    0x4(%esp),%edx
  80225b:	29 f2                	sub    %esi,%edx
  80225d:	19 cb                	sbb    %ecx,%ebx
  80225f:	89 d8                	mov    %ebx,%eax
  802261:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802265:	d3 e0                	shl    %cl,%eax
  802267:	89 e9                	mov    %ebp,%ecx
  802269:	d3 ea                	shr    %cl,%edx
  80226b:	09 d0                	or     %edx,%eax
  80226d:	89 e9                	mov    %ebp,%ecx
  80226f:	d3 eb                	shr    %cl,%ebx
  802271:	89 da                	mov    %ebx,%edx
  802273:	83 c4 1c             	add    $0x1c,%esp
  802276:	5b                   	pop    %ebx
  802277:	5e                   	pop    %esi
  802278:	5f                   	pop    %edi
  802279:	5d                   	pop    %ebp
  80227a:	c3                   	ret    
  80227b:	90                   	nop
  80227c:	89 fd                	mov    %edi,%ebp
  80227e:	85 ff                	test   %edi,%edi
  802280:	75 0b                	jne    80228d <__umoddi3+0xe9>
  802282:	b8 01 00 00 00       	mov    $0x1,%eax
  802287:	31 d2                	xor    %edx,%edx
  802289:	f7 f7                	div    %edi
  80228b:	89 c5                	mov    %eax,%ebp
  80228d:	89 f0                	mov    %esi,%eax
  80228f:	31 d2                	xor    %edx,%edx
  802291:	f7 f5                	div    %ebp
  802293:	89 c8                	mov    %ecx,%eax
  802295:	f7 f5                	div    %ebp
  802297:	89 d0                	mov    %edx,%eax
  802299:	e9 44 ff ff ff       	jmp    8021e2 <__umoddi3+0x3e>
  80229e:	66 90                	xchg   %ax,%ax
  8022a0:	89 c8                	mov    %ecx,%eax
  8022a2:	89 f2                	mov    %esi,%edx
  8022a4:	83 c4 1c             	add    $0x1c,%esp
  8022a7:	5b                   	pop    %ebx
  8022a8:	5e                   	pop    %esi
  8022a9:	5f                   	pop    %edi
  8022aa:	5d                   	pop    %ebp
  8022ab:	c3                   	ret    
  8022ac:	3b 04 24             	cmp    (%esp),%eax
  8022af:	72 06                	jb     8022b7 <__umoddi3+0x113>
  8022b1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8022b5:	77 0f                	ja     8022c6 <__umoddi3+0x122>
  8022b7:	89 f2                	mov    %esi,%edx
  8022b9:	29 f9                	sub    %edi,%ecx
  8022bb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8022bf:	89 14 24             	mov    %edx,(%esp)
  8022c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022c6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022ca:	8b 14 24             	mov    (%esp),%edx
  8022cd:	83 c4 1c             	add    $0x1c,%esp
  8022d0:	5b                   	pop    %ebx
  8022d1:	5e                   	pop    %esi
  8022d2:	5f                   	pop    %edi
  8022d3:	5d                   	pop    %ebp
  8022d4:	c3                   	ret    
  8022d5:	8d 76 00             	lea    0x0(%esi),%esi
  8022d8:	2b 04 24             	sub    (%esp),%eax
  8022db:	19 fa                	sbb    %edi,%edx
  8022dd:	89 d1                	mov    %edx,%ecx
  8022df:	89 c6                	mov    %eax,%esi
  8022e1:	e9 71 ff ff ff       	jmp    802257 <__umoddi3+0xb3>
  8022e6:	66 90                	xchg   %ax,%ax
  8022e8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8022ec:	72 ea                	jb     8022d8 <__umoddi3+0x134>
  8022ee:	89 d9                	mov    %ebx,%ecx
  8022f0:	e9 62 ff ff ff       	jmp    802257 <__umoddi3+0xb3>
