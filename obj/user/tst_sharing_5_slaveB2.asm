
obj/user/tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 38 01 00 00       	call   80016e <libmain>
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
  80003b:	83 ec 18             	sub    $0x18,%esp
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
  800086:	68 c0 22 80 00       	push   $0x8022c0
  80008b:	6a 12                	push   $0x12
  80008d:	68 dc 22 80 00       	push   $0x8022dc
  800092:	e8 1c 02 00 00       	call   8002b3 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  800097:	e8 68 19 00 00       	call   801a04 <sys_getparentenvid>
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	68 f9 22 80 00       	push   $0x8022f9
  8000a4:	50                   	push   %eax
  8000a5:	e8 f2 17 00 00       	call   80189c <sget>
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 fc 22 80 00       	push   $0x8022fc
  8000b8:	e8 98 04 00 00       	call   800555 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	68 24 23 80 00       	push   $0x802324
  8000c8:	e8 88 04 00 00       	call   800555 <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	68 28 23 00 00       	push   $0x2328
  8000d8:	e8 ca 1e 00 00       	call   801fa7 <env_sleep>
  8000dd:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 d1 19 00 00       	call   801ab6 <sys_calculate_free_frames>
  8000e5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ee:	e8 c6 17 00 00       	call   8018b9 <sfree>
  8000f3:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 44 23 80 00       	push   $0x802344
  8000fe:	e8 52 04 00 00       	call   800555 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800106:	e8 ab 19 00 00       	call   801ab6 <sys_calculate_free_frames>
  80010b:	89 c2                	mov    %eax,%edx
  80010d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800110:	29 c2                	sub    %eax,%edx
  800112:	89 d0                	mov    %edx,%eax
  800114:	83 f8 04             	cmp    $0x4,%eax
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 5c 23 80 00       	push   $0x80235c
  800121:	6a 20                	push   $0x20
  800123:	68 dc 22 80 00       	push   $0x8022dc
  800128:	e8 86 01 00 00       	call   8002b3 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  80012d:	e8 3b 1d 00 00       	call   801e6d <gettst>
  800132:	83 f8 02             	cmp    $0x2,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 fc 23 80 00       	push   $0x8023fc
  80013f:	6a 23                	push   $0x23
  800141:	68 dc 22 80 00       	push   $0x8022dc
  800146:	e8 68 01 00 00       	call   8002b3 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	68 08 24 80 00       	push   $0x802408
  800153:	e8 fd 03 00 00       	call   800555 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	68 2c 24 80 00       	push   $0x80242c
  800163:	e8 ed 03 00 00       	call   800555 <cprintf>
  800168:	83 c4 10             	add    $0x10,%esp

	return;
  80016b:	90                   	nop
}
  80016c:	c9                   	leave  
  80016d:	c3                   	ret    

0080016e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016e:	55                   	push   %ebp
  80016f:	89 e5                	mov    %esp,%ebp
  800171:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800174:	e8 72 18 00 00       	call   8019eb <sys_getenvindex>
  800179:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80017c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017f:	89 d0                	mov    %edx,%eax
  800181:	c1 e0 03             	shl    $0x3,%eax
  800184:	01 d0                	add    %edx,%eax
  800186:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80018d:	01 c8                	add    %ecx,%eax
  80018f:	01 c0                	add    %eax,%eax
  800191:	01 d0                	add    %edx,%eax
  800193:	01 c0                	add    %eax,%eax
  800195:	01 d0                	add    %edx,%eax
  800197:	89 c2                	mov    %eax,%edx
  800199:	c1 e2 05             	shl    $0x5,%edx
  80019c:	29 c2                	sub    %eax,%edx
  80019e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001a5:	89 c2                	mov    %eax,%edx
  8001a7:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001ad:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b7:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001bd:	84 c0                	test   %al,%al
  8001bf:	74 0f                	je     8001d0 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c6:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001cb:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d4:	7e 0a                	jle    8001e0 <libmain+0x72>
		binaryname = argv[0];
  8001d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d9:	8b 00                	mov    (%eax),%eax
  8001db:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001e0:	83 ec 08             	sub    $0x8,%esp
  8001e3:	ff 75 0c             	pushl  0xc(%ebp)
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	e8 4a fe ff ff       	call   800038 <_main>
  8001ee:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001f1:	e8 90 19 00 00       	call   801b86 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	68 90 24 80 00       	push   $0x802490
  8001fe:	e8 52 03 00 00       	call   800555 <cprintf>
  800203:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800206:	a1 20 30 80 00       	mov    0x803020,%eax
  80020b:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800211:	a1 20 30 80 00       	mov    0x803020,%eax
  800216:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	52                   	push   %edx
  800220:	50                   	push   %eax
  800221:	68 b8 24 80 00       	push   $0x8024b8
  800226:	e8 2a 03 00 00       	call   800555 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80022e:	a1 20 30 80 00       	mov    0x803020,%eax
  800233:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800239:	a1 20 30 80 00       	mov    0x803020,%eax
  80023e:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800244:	83 ec 04             	sub    $0x4,%esp
  800247:	52                   	push   %edx
  800248:	50                   	push   %eax
  800249:	68 e0 24 80 00       	push   $0x8024e0
  80024e:	e8 02 03 00 00       	call   800555 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800256:	a1 20 30 80 00       	mov    0x803020,%eax
  80025b:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800261:	83 ec 08             	sub    $0x8,%esp
  800264:	50                   	push   %eax
  800265:	68 21 25 80 00       	push   $0x802521
  80026a:	e8 e6 02 00 00       	call   800555 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 90 24 80 00       	push   $0x802490
  80027a:	e8 d6 02 00 00       	call   800555 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800282:	e8 19 19 00 00       	call   801ba0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800287:	e8 19 00 00 00       	call   8002a5 <exit>
}
  80028c:	90                   	nop
  80028d:	c9                   	leave  
  80028e:	c3                   	ret    

0080028f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	6a 00                	push   $0x0
  80029a:	e8 18 17 00 00       	call   8019b7 <sys_env_destroy>
  80029f:	83 c4 10             	add    $0x10,%esp
}
  8002a2:	90                   	nop
  8002a3:	c9                   	leave  
  8002a4:	c3                   	ret    

008002a5 <exit>:

void
exit(void)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002ab:	e8 6d 17 00 00       	call   801a1d <sys_env_exit>
}
  8002b0:	90                   	nop
  8002b1:	c9                   	leave  
  8002b2:	c3                   	ret    

008002b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8002bc:	83 c0 04             	add    $0x4,%eax
  8002bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002c2:	a1 18 31 80 00       	mov    0x803118,%eax
  8002c7:	85 c0                	test   %eax,%eax
  8002c9:	74 16                	je     8002e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002cb:	a1 18 31 80 00       	mov    0x803118,%eax
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	50                   	push   %eax
  8002d4:	68 38 25 80 00       	push   $0x802538
  8002d9:	e8 77 02 00 00       	call   800555 <cprintf>
  8002de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e1:	a1 00 30 80 00       	mov    0x803000,%eax
  8002e6:	ff 75 0c             	pushl  0xc(%ebp)
  8002e9:	ff 75 08             	pushl  0x8(%ebp)
  8002ec:	50                   	push   %eax
  8002ed:	68 3d 25 80 00       	push   $0x80253d
  8002f2:	e8 5e 02 00 00       	call   800555 <cprintf>
  8002f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fd:	83 ec 08             	sub    $0x8,%esp
  800300:	ff 75 f4             	pushl  -0xc(%ebp)
  800303:	50                   	push   %eax
  800304:	e8 e1 01 00 00       	call   8004ea <vcprintf>
  800309:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	6a 00                	push   $0x0
  800311:	68 59 25 80 00       	push   $0x802559
  800316:	e8 cf 01 00 00       	call   8004ea <vcprintf>
  80031b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80031e:	e8 82 ff ff ff       	call   8002a5 <exit>

	// should not return here
	while (1) ;
  800323:	eb fe                	jmp    800323 <_panic+0x70>

00800325 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80032b:	a1 20 30 80 00       	mov    0x803020,%eax
  800330:	8b 50 74             	mov    0x74(%eax),%edx
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	39 c2                	cmp    %eax,%edx
  800338:	74 14                	je     80034e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80033a:	83 ec 04             	sub    $0x4,%esp
  80033d:	68 5c 25 80 00       	push   $0x80255c
  800342:	6a 26                	push   $0x26
  800344:	68 a8 25 80 00       	push   $0x8025a8
  800349:	e8 65 ff ff ff       	call   8002b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80034e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800355:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80035c:	e9 b6 00 00 00       	jmp    800417 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800364:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	01 d0                	add    %edx,%eax
  800370:	8b 00                	mov    (%eax),%eax
  800372:	85 c0                	test   %eax,%eax
  800374:	75 08                	jne    80037e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800376:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800379:	e9 96 00 00 00       	jmp    800414 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80037e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800385:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80038c:	eb 5d                	jmp    8003eb <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80038e:	a1 20 30 80 00       	mov    0x803020,%eax
  800393:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800399:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80039c:	c1 e2 04             	shl    $0x4,%edx
  80039f:	01 d0                	add    %edx,%eax
  8003a1:	8a 40 04             	mov    0x4(%eax),%al
  8003a4:	84 c0                	test   %al,%al
  8003a6:	75 40                	jne    8003e8 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ad:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b6:	c1 e2 04             	shl    $0x4,%edx
  8003b9:	01 d0                	add    %edx,%eax
  8003bb:	8b 00                	mov    (%eax),%eax
  8003bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	01 c8                	add    %ecx,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003db:	39 c2                	cmp    %eax,%edx
  8003dd:	75 09                	jne    8003e8 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8003df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003e6:	eb 12                	jmp    8003fa <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e8:	ff 45 e8             	incl   -0x18(%ebp)
  8003eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f0:	8b 50 74             	mov    0x74(%eax),%edx
  8003f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f6:	39 c2                	cmp    %eax,%edx
  8003f8:	77 94                	ja     80038e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003fe:	75 14                	jne    800414 <CheckWSWithoutLastIndex+0xef>
			panic(
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	68 b4 25 80 00       	push   $0x8025b4
  800408:	6a 3a                	push   $0x3a
  80040a:	68 a8 25 80 00       	push   $0x8025a8
  80040f:	e8 9f fe ff ff       	call   8002b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800414:	ff 45 f0             	incl   -0x10(%ebp)
  800417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041d:	0f 8c 3e ff ff ff    	jl     800361 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800423:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800431:	eb 20                	jmp    800453 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800433:	a1 20 30 80 00       	mov    0x803020,%eax
  800438:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80043e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800441:	c1 e2 04             	shl    $0x4,%edx
  800444:	01 d0                	add    %edx,%eax
  800446:	8a 40 04             	mov    0x4(%eax),%al
  800449:	3c 01                	cmp    $0x1,%al
  80044b:	75 03                	jne    800450 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80044d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800450:	ff 45 e0             	incl   -0x20(%ebp)
  800453:	a1 20 30 80 00       	mov    0x803020,%eax
  800458:	8b 50 74             	mov    0x74(%eax),%edx
  80045b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80045e:	39 c2                	cmp    %eax,%edx
  800460:	77 d1                	ja     800433 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800465:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800468:	74 14                	je     80047e <CheckWSWithoutLastIndex+0x159>
		panic(
  80046a:	83 ec 04             	sub    $0x4,%esp
  80046d:	68 08 26 80 00       	push   $0x802608
  800472:	6a 44                	push   $0x44
  800474:	68 a8 25 80 00       	push   $0x8025a8
  800479:	e8 35 fe ff ff       	call   8002b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80047e:	90                   	nop
  80047f:	c9                   	leave  
  800480:	c3                   	ret    

00800481 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	8d 48 01             	lea    0x1(%eax),%ecx
  80048f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800492:	89 0a                	mov    %ecx,(%edx)
  800494:	8b 55 08             	mov    0x8(%ebp),%edx
  800497:	88 d1                	mov    %dl,%cl
  800499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004aa:	75 2c                	jne    8004d8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004ac:	a0 24 30 80 00       	mov    0x803024,%al
  8004b1:	0f b6 c0             	movzbl %al,%eax
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 12                	mov    (%edx),%edx
  8004b9:	89 d1                	mov    %edx,%ecx
  8004bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004be:	83 c2 08             	add    $0x8,%edx
  8004c1:	83 ec 04             	sub    $0x4,%esp
  8004c4:	50                   	push   %eax
  8004c5:	51                   	push   %ecx
  8004c6:	52                   	push   %edx
  8004c7:	e8 a9 14 00 00       	call   801975 <sys_cputs>
  8004cc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004db:	8b 40 04             	mov    0x4(%eax),%eax
  8004de:	8d 50 01             	lea    0x1(%eax),%edx
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004e7:	90                   	nop
  8004e8:	c9                   	leave  
  8004e9:	c3                   	ret    

008004ea <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004fa:	00 00 00 
	b.cnt = 0;
  8004fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800504:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800507:	ff 75 0c             	pushl  0xc(%ebp)
  80050a:	ff 75 08             	pushl  0x8(%ebp)
  80050d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800513:	50                   	push   %eax
  800514:	68 81 04 80 00       	push   $0x800481
  800519:	e8 11 02 00 00       	call   80072f <vprintfmt>
  80051e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800521:	a0 24 30 80 00       	mov    0x803024,%al
  800526:	0f b6 c0             	movzbl %al,%eax
  800529:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80052f:	83 ec 04             	sub    $0x4,%esp
  800532:	50                   	push   %eax
  800533:	52                   	push   %edx
  800534:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80053a:	83 c0 08             	add    $0x8,%eax
  80053d:	50                   	push   %eax
  80053e:	e8 32 14 00 00       	call   801975 <sys_cputs>
  800543:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800546:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80054d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800553:	c9                   	leave  
  800554:	c3                   	ret    

00800555 <cprintf>:

int cprintf(const char *fmt, ...) {
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80055b:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800562:	8d 45 0c             	lea    0xc(%ebp),%eax
  800565:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	ff 75 f4             	pushl  -0xc(%ebp)
  800571:	50                   	push   %eax
  800572:	e8 73 ff ff ff       	call   8004ea <vcprintf>
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800588:	e8 f9 15 00 00       	call   801b86 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80058d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800590:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	ff 75 f4             	pushl  -0xc(%ebp)
  80059c:	50                   	push   %eax
  80059d:	e8 48 ff ff ff       	call   8004ea <vcprintf>
  8005a2:	83 c4 10             	add    $0x10,%esp
  8005a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005a8:	e8 f3 15 00 00       	call   801ba0 <sys_enable_interrupt>
	return cnt;
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	53                   	push   %ebx
  8005b6:	83 ec 14             	sub    $0x14,%esp
  8005b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005d0:	77 55                	ja     800627 <printnum+0x75>
  8005d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005d5:	72 05                	jb     8005dc <printnum+0x2a>
  8005d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005da:	77 4b                	ja     800627 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005dc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005df:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005e2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ea:	52                   	push   %edx
  8005eb:	50                   	push   %eax
  8005ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8005f2:	e8 65 1a 00 00       	call   80205c <__udivdi3>
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	83 ec 04             	sub    $0x4,%esp
  8005fd:	ff 75 20             	pushl  0x20(%ebp)
  800600:	53                   	push   %ebx
  800601:	ff 75 18             	pushl  0x18(%ebp)
  800604:	52                   	push   %edx
  800605:	50                   	push   %eax
  800606:	ff 75 0c             	pushl  0xc(%ebp)
  800609:	ff 75 08             	pushl  0x8(%ebp)
  80060c:	e8 a1 ff ff ff       	call   8005b2 <printnum>
  800611:	83 c4 20             	add    $0x20,%esp
  800614:	eb 1a                	jmp    800630 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	ff 75 0c             	pushl  0xc(%ebp)
  80061c:	ff 75 20             	pushl  0x20(%ebp)
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	ff d0                	call   *%eax
  800624:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800627:	ff 4d 1c             	decl   0x1c(%ebp)
  80062a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80062e:	7f e6                	jg     800616 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800630:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800633:	bb 00 00 00 00       	mov    $0x0,%ebx
  800638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80063b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80063e:	53                   	push   %ebx
  80063f:	51                   	push   %ecx
  800640:	52                   	push   %edx
  800641:	50                   	push   %eax
  800642:	e8 25 1b 00 00       	call   80216c <__umoddi3>
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	05 74 28 80 00       	add    $0x802874,%eax
  80064f:	8a 00                	mov    (%eax),%al
  800651:	0f be c0             	movsbl %al,%eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	50                   	push   %eax
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	ff d0                	call   *%eax
  800660:	83 c4 10             	add    $0x10,%esp
}
  800663:	90                   	nop
  800664:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80066c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800670:	7e 1c                	jle    80068e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 50 08             	lea    0x8(%eax),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 10                	mov    %edx,(%eax)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	83 e8 08             	sub    $0x8,%eax
  800687:	8b 50 04             	mov    0x4(%eax),%edx
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	eb 40                	jmp    8006ce <getuint+0x65>
	else if (lflag)
  80068e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800692:	74 1e                	je     8006b2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	8d 50 04             	lea    0x4(%eax),%edx
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	89 10                	mov    %edx,(%eax)
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	83 e8 04             	sub    $0x4,%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b0:	eb 1c                	jmp    8006ce <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	89 10                	mov    %edx,(%eax)
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	8b 00                	mov    (%eax),%eax
  8006c4:	83 e8 04             	sub    $0x4,%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ce:	5d                   	pop    %ebp
  8006cf:	c3                   	ret    

008006d0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006d0:	55                   	push   %ebp
  8006d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006d7:	7e 1c                	jle    8006f5 <getint+0x25>
		return va_arg(*ap, long long);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 08             	lea    0x8(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 08             	sub    $0x8,%eax
  8006ee:	8b 50 04             	mov    0x4(%eax),%edx
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	eb 38                	jmp    80072d <getint+0x5d>
	else if (lflag)
  8006f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006f9:	74 1a                	je     800715 <getint+0x45>
		return va_arg(*ap, long);
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	8d 50 04             	lea    0x4(%eax),%edx
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	89 10                	mov    %edx,(%eax)
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	83 e8 04             	sub    $0x4,%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	99                   	cltd   
  800713:	eb 18                	jmp    80072d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	8d 50 04             	lea    0x4(%eax),%edx
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	89 10                	mov    %edx,(%eax)
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	83 e8 04             	sub    $0x4,%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	99                   	cltd   
}
  80072d:	5d                   	pop    %ebp
  80072e:	c3                   	ret    

0080072f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	56                   	push   %esi
  800733:	53                   	push   %ebx
  800734:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800737:	eb 17                	jmp    800750 <vprintfmt+0x21>
			if (ch == '\0')
  800739:	85 db                	test   %ebx,%ebx
  80073b:	0f 84 af 03 00 00    	je     800af0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	ff 75 0c             	pushl  0xc(%ebp)
  800747:	53                   	push   %ebx
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	ff d0                	call   *%eax
  80074d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800750:	8b 45 10             	mov    0x10(%ebp),%eax
  800753:	8d 50 01             	lea    0x1(%eax),%edx
  800756:	89 55 10             	mov    %edx,0x10(%ebp)
  800759:	8a 00                	mov    (%eax),%al
  80075b:	0f b6 d8             	movzbl %al,%ebx
  80075e:	83 fb 25             	cmp    $0x25,%ebx
  800761:	75 d6                	jne    800739 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800763:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800767:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80076e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800775:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80077c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800783:	8b 45 10             	mov    0x10(%ebp),%eax
  800786:	8d 50 01             	lea    0x1(%eax),%edx
  800789:	89 55 10             	mov    %edx,0x10(%ebp)
  80078c:	8a 00                	mov    (%eax),%al
  80078e:	0f b6 d8             	movzbl %al,%ebx
  800791:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800794:	83 f8 55             	cmp    $0x55,%eax
  800797:	0f 87 2b 03 00 00    	ja     800ac8 <vprintfmt+0x399>
  80079d:	8b 04 85 98 28 80 00 	mov    0x802898(,%eax,4),%eax
  8007a4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007a6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007aa:	eb d7                	jmp    800783 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007ac:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007b0:	eb d1                	jmp    800783 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	c1 e0 02             	shl    $0x2,%eax
  8007c1:	01 d0                	add    %edx,%eax
  8007c3:	01 c0                	add    %eax,%eax
  8007c5:	01 d8                	add    %ebx,%eax
  8007c7:	83 e8 30             	sub    $0x30,%eax
  8007ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d0:	8a 00                	mov    (%eax),%al
  8007d2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007d5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007d8:	7e 3e                	jle    800818 <vprintfmt+0xe9>
  8007da:	83 fb 39             	cmp    $0x39,%ebx
  8007dd:	7f 39                	jg     800818 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007df:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007e2:	eb d5                	jmp    8007b9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	83 c0 04             	add    $0x4,%eax
  8007ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	83 e8 04             	sub    $0x4,%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007f8:	eb 1f                	jmp    800819 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fe:	79 83                	jns    800783 <vprintfmt+0x54>
				width = 0;
  800800:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800807:	e9 77 ff ff ff       	jmp    800783 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80080c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800813:	e9 6b ff ff ff       	jmp    800783 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800818:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800819:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081d:	0f 89 60 ff ff ff    	jns    800783 <vprintfmt+0x54>
				width = precision, precision = -1;
  800823:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800826:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800829:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800830:	e9 4e ff ff ff       	jmp    800783 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800835:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800838:	e9 46 ff ff ff       	jmp    800783 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	83 c0 04             	add    $0x4,%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	83 e8 04             	sub    $0x4,%eax
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	ff 75 0c             	pushl  0xc(%ebp)
  800854:	50                   	push   %eax
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	ff d0                	call   *%eax
  80085a:	83 c4 10             	add    $0x10,%esp
			break;
  80085d:	e9 89 02 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 c0 04             	add    $0x4,%eax
  800868:	89 45 14             	mov    %eax,0x14(%ebp)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	83 e8 04             	sub    $0x4,%eax
  800871:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800873:	85 db                	test   %ebx,%ebx
  800875:	79 02                	jns    800879 <vprintfmt+0x14a>
				err = -err;
  800877:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800879:	83 fb 64             	cmp    $0x64,%ebx
  80087c:	7f 0b                	jg     800889 <vprintfmt+0x15a>
  80087e:	8b 34 9d e0 26 80 00 	mov    0x8026e0(,%ebx,4),%esi
  800885:	85 f6                	test   %esi,%esi
  800887:	75 19                	jne    8008a2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800889:	53                   	push   %ebx
  80088a:	68 85 28 80 00       	push   $0x802885
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	ff 75 08             	pushl  0x8(%ebp)
  800895:	e8 5e 02 00 00       	call   800af8 <printfmt>
  80089a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80089d:	e9 49 02 00 00       	jmp    800aeb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008a2:	56                   	push   %esi
  8008a3:	68 8e 28 80 00       	push   $0x80288e
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	ff 75 08             	pushl  0x8(%ebp)
  8008ae:	e8 45 02 00 00       	call   800af8 <printfmt>
  8008b3:	83 c4 10             	add    $0x10,%esp
			break;
  8008b6:	e9 30 02 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	83 c0 04             	add    $0x4,%eax
  8008c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	83 e8 04             	sub    $0x4,%eax
  8008ca:	8b 30                	mov    (%eax),%esi
  8008cc:	85 f6                	test   %esi,%esi
  8008ce:	75 05                	jne    8008d5 <vprintfmt+0x1a6>
				p = "(null)";
  8008d0:	be 91 28 80 00       	mov    $0x802891,%esi
			if (width > 0 && padc != '-')
  8008d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d9:	7e 6d                	jle    800948 <vprintfmt+0x219>
  8008db:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008df:	74 67                	je     800948 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	50                   	push   %eax
  8008e8:	56                   	push   %esi
  8008e9:	e8 0c 03 00 00       	call   800bfa <strnlen>
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008f4:	eb 16                	jmp    80090c <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008f6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	50                   	push   %eax
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	ff d0                	call   *%eax
  800906:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800909:	ff 4d e4             	decl   -0x1c(%ebp)
  80090c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800910:	7f e4                	jg     8008f6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800912:	eb 34                	jmp    800948 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800914:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800918:	74 1c                	je     800936 <vprintfmt+0x207>
  80091a:	83 fb 1f             	cmp    $0x1f,%ebx
  80091d:	7e 05                	jle    800924 <vprintfmt+0x1f5>
  80091f:	83 fb 7e             	cmp    $0x7e,%ebx
  800922:	7e 12                	jle    800936 <vprintfmt+0x207>
					putch('?', putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	6a 3f                	push   $0x3f
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
  800934:	eb 0f                	jmp    800945 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	53                   	push   %ebx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800945:	ff 4d e4             	decl   -0x1c(%ebp)
  800948:	89 f0                	mov    %esi,%eax
  80094a:	8d 70 01             	lea    0x1(%eax),%esi
  80094d:	8a 00                	mov    (%eax),%al
  80094f:	0f be d8             	movsbl %al,%ebx
  800952:	85 db                	test   %ebx,%ebx
  800954:	74 24                	je     80097a <vprintfmt+0x24b>
  800956:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80095a:	78 b8                	js     800914 <vprintfmt+0x1e5>
  80095c:	ff 4d e0             	decl   -0x20(%ebp)
  80095f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800963:	79 af                	jns    800914 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800965:	eb 13                	jmp    80097a <vprintfmt+0x24b>
				putch(' ', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	6a 20                	push   $0x20
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
  800974:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800977:	ff 4d e4             	decl   -0x1c(%ebp)
  80097a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097e:	7f e7                	jg     800967 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800980:	e9 66 01 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 e8             	pushl  -0x18(%ebp)
  80098b:	8d 45 14             	lea    0x14(%ebp),%eax
  80098e:	50                   	push   %eax
  80098f:	e8 3c fd ff ff       	call   8006d0 <getint>
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80099d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a3:	85 d2                	test   %edx,%edx
  8009a5:	79 23                	jns    8009ca <vprintfmt+0x29b>
				putch('-', putdat);
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	6a 2d                	push   $0x2d
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	ff d0                	call   *%eax
  8009b4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009bd:	f7 d8                	neg    %eax
  8009bf:	83 d2 00             	adc    $0x0,%edx
  8009c2:	f7 da                	neg    %edx
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d1:	e9 bc 00 00 00       	jmp    800a92 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8009df:	50                   	push   %eax
  8009e0:	e8 84 fc ff ff       	call   800669 <getuint>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009f5:	e9 98 00 00 00       	jmp    800a92 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	6a 58                	push   $0x58
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	ff d0                	call   *%eax
  800a07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 0c             	pushl  0xc(%ebp)
  800a10:	6a 58                	push   $0x58
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	ff d0                	call   *%eax
  800a17:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1a:	83 ec 08             	sub    $0x8,%esp
  800a1d:	ff 75 0c             	pushl  0xc(%ebp)
  800a20:	6a 58                	push   $0x58
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	ff d0                	call   *%eax
  800a27:	83 c4 10             	add    $0x10,%esp
			break;
  800a2a:	e9 bc 00 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 30                	push   $0x30
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	ff 75 0c             	pushl  0xc(%ebp)
  800a45:	6a 78                	push   $0x78
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	ff d0                	call   *%eax
  800a4c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a52:	83 c0 04             	add    $0x4,%eax
  800a55:	89 45 14             	mov    %eax,0x14(%ebp)
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	83 e8 04             	sub    $0x4,%eax
  800a5e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a71:	eb 1f                	jmp    800a92 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 e8             	pushl  -0x18(%ebp)
  800a79:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7c:	50                   	push   %eax
  800a7d:	e8 e7 fb ff ff       	call   800669 <getuint>
  800a82:	83 c4 10             	add    $0x10,%esp
  800a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a8b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a92:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a99:	83 ec 04             	sub    $0x4,%esp
  800a9c:	52                   	push   %edx
  800a9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aa0:	50                   	push   %eax
  800aa1:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa4:	ff 75 f0             	pushl  -0x10(%ebp)
  800aa7:	ff 75 0c             	pushl  0xc(%ebp)
  800aaa:	ff 75 08             	pushl  0x8(%ebp)
  800aad:	e8 00 fb ff ff       	call   8005b2 <printnum>
  800ab2:	83 c4 20             	add    $0x20,%esp
			break;
  800ab5:	eb 34                	jmp    800aeb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	53                   	push   %ebx
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	ff d0                	call   *%eax
  800ac3:	83 c4 10             	add    $0x10,%esp
			break;
  800ac6:	eb 23                	jmp    800aeb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	6a 25                	push   $0x25
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	ff d0                	call   *%eax
  800ad5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad8:	ff 4d 10             	decl   0x10(%ebp)
  800adb:	eb 03                	jmp    800ae0 <vprintfmt+0x3b1>
  800add:	ff 4d 10             	decl   0x10(%ebp)
  800ae0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae3:	48                   	dec    %eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	3c 25                	cmp    $0x25,%al
  800ae8:	75 f3                	jne    800add <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aea:	90                   	nop
		}
	}
  800aeb:	e9 47 fc ff ff       	jmp    800737 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800af0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800af1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800af4:	5b                   	pop    %ebx
  800af5:	5e                   	pop    %esi
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    

00800af8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800afe:	8d 45 10             	lea    0x10(%ebp),%eax
  800b01:	83 c0 04             	add    $0x4,%eax
  800b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b07:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0d:	50                   	push   %eax
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	ff 75 08             	pushl  0x8(%ebp)
  800b14:	e8 16 fc ff ff       	call   80072f <vprintfmt>
  800b19:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b1c:	90                   	nop
  800b1d:	c9                   	leave  
  800b1e:	c3                   	ret    

00800b1f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8b 40 08             	mov    0x8(%eax),%eax
  800b28:	8d 50 01             	lea    0x1(%eax),%edx
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8b 10                	mov    (%eax),%edx
  800b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b39:	8b 40 04             	mov    0x4(%eax),%eax
  800b3c:	39 c2                	cmp    %eax,%edx
  800b3e:	73 12                	jae    800b52 <sprintputch+0x33>
		*b->buf++ = ch;
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	8b 00                	mov    (%eax),%eax
  800b45:	8d 48 01             	lea    0x1(%eax),%ecx
  800b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4b:	89 0a                	mov    %ecx,(%edx)
  800b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b50:	88 10                	mov    %dl,(%eax)
}
  800b52:	90                   	nop
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	01 d0                	add    %edx,%eax
  800b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b7a:	74 06                	je     800b82 <vsnprintf+0x2d>
  800b7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b80:	7f 07                	jg     800b89 <vsnprintf+0x34>
		return -E_INVAL;
  800b82:	b8 03 00 00 00       	mov    $0x3,%eax
  800b87:	eb 20                	jmp    800ba9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b89:	ff 75 14             	pushl  0x14(%ebp)
  800b8c:	ff 75 10             	pushl  0x10(%ebp)
  800b8f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b92:	50                   	push   %eax
  800b93:	68 1f 0b 80 00       	push   $0x800b1f
  800b98:	e8 92 fb ff ff       	call   80072f <vprintfmt>
  800b9d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ba3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bb1:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb4:	83 c0 04             	add    $0x4,%eax
  800bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bba:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc0:	50                   	push   %eax
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	ff 75 08             	pushl  0x8(%ebp)
  800bc7:	e8 89 ff ff ff       	call   800b55 <vsnprintf>
  800bcc:	83 c4 10             	add    $0x10,%esp
  800bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be4:	eb 06                	jmp    800bec <strlen+0x15>
		n++;
  800be6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800be9:	ff 45 08             	incl   0x8(%ebp)
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8a 00                	mov    (%eax),%al
  800bf1:	84 c0                	test   %al,%al
  800bf3:	75 f1                	jne    800be6 <strlen+0xf>
		n++;
	return n;
  800bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf8:	c9                   	leave  
  800bf9:	c3                   	ret    

00800bfa <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c07:	eb 09                	jmp    800c12 <strnlen+0x18>
		n++;
  800c09:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c0c:	ff 45 08             	incl   0x8(%ebp)
  800c0f:	ff 4d 0c             	decl   0xc(%ebp)
  800c12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c16:	74 09                	je     800c21 <strnlen+0x27>
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	84 c0                	test   %al,%al
  800c1f:	75 e8                	jne    800c09 <strnlen+0xf>
		n++;
	return n;
  800c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c32:	90                   	nop
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8d 50 01             	lea    0x1(%eax),%edx
  800c39:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c42:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c45:	8a 12                	mov    (%edx),%dl
  800c47:	88 10                	mov    %dl,(%eax)
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	84 c0                	test   %al,%al
  800c4d:	75 e4                	jne    800c33 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c67:	eb 1f                	jmp    800c88 <strncpy+0x34>
		*dst++ = *src;
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8d 50 01             	lea    0x1(%eax),%edx
  800c6f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	84 c0                	test   %al,%al
  800c80:	74 03                	je     800c85 <strncpy+0x31>
			src++;
  800c82:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c85:	ff 45 fc             	incl   -0x4(%ebp)
  800c88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c8e:	72 d9                	jb     800c69 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c90:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ca1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca5:	74 30                	je     800cd7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ca7:	eb 16                	jmp    800cbf <strlcpy+0x2a>
			*dst++ = *src++;
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8d 50 01             	lea    0x1(%eax),%edx
  800caf:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cbb:	8a 12                	mov    (%edx),%dl
  800cbd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cbf:	ff 4d 10             	decl   0x10(%ebp)
  800cc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc6:	74 09                	je     800cd1 <strlcpy+0x3c>
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	84 c0                	test   %al,%al
  800ccf:	75 d8                	jne    800ca9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cdd:	29 c2                	sub    %eax,%edx
  800cdf:	89 d0                	mov    %edx,%eax
}
  800ce1:	c9                   	leave  
  800ce2:	c3                   	ret    

00800ce3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ce6:	eb 06                	jmp    800cee <strcmp+0xb>
		p++, q++;
  800ce8:	ff 45 08             	incl   0x8(%ebp)
  800ceb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	84 c0                	test   %al,%al
  800cf5:	74 0e                	je     800d05 <strcmp+0x22>
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8a 10                	mov    (%eax),%dl
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	38 c2                	cmp    %al,%dl
  800d03:	74 e3                	je     800ce8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	0f b6 d0             	movzbl %al,%edx
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	0f b6 c0             	movzbl %al,%eax
  800d15:	29 c2                	sub    %eax,%edx
  800d17:	89 d0                	mov    %edx,%eax
}
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d1e:	eb 09                	jmp    800d29 <strncmp+0xe>
		n--, p++, q++;
  800d20:	ff 4d 10             	decl   0x10(%ebp)
  800d23:	ff 45 08             	incl   0x8(%ebp)
  800d26:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2d:	74 17                	je     800d46 <strncmp+0x2b>
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	84 c0                	test   %al,%al
  800d36:	74 0e                	je     800d46 <strncmp+0x2b>
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 10                	mov    (%eax),%dl
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	38 c2                	cmp    %al,%dl
  800d44:	74 da                	je     800d20 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4a:	75 07                	jne    800d53 <strncmp+0x38>
		return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d51:	eb 14                	jmp    800d67 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	0f b6 d0             	movzbl %al,%edx
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	0f b6 c0             	movzbl %al,%eax
  800d63:	29 c2                	sub    %eax,%edx
  800d65:	89 d0                	mov    %edx,%eax
}
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d75:	eb 12                	jmp    800d89 <strchr+0x20>
		if (*s == c)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7f:	75 05                	jne    800d86 <strchr+0x1d>
			return (char *) s;
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	eb 11                	jmp    800d97 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d86:	ff 45 08             	incl   0x8(%ebp)
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	75 e5                	jne    800d77 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d97:	c9                   	leave  
  800d98:	c3                   	ret    

00800d99 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 04             	sub    $0x4,%esp
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da5:	eb 0d                	jmp    800db4 <strfind+0x1b>
		if (*s == c)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800daf:	74 0e                	je     800dbf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	75 ea                	jne    800da7 <strfind+0xe>
  800dbd:	eb 01                	jmp    800dc0 <strfind+0x27>
		if (*s == c)
			break;
  800dbf:	90                   	nop
	return (char *) s;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dd7:	eb 0e                	jmp    800de7 <memset+0x22>
		*p++ = c;
  800dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800de7:	ff 4d f8             	decl   -0x8(%ebp)
  800dea:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dee:	79 e9                	jns    800dd9 <memset+0x14>
		*p++ = c;

	return v;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e07:	eb 16                	jmp    800e1f <memcpy+0x2a>
		*d++ = *s++;
  800e09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0c:	8d 50 01             	lea    0x1(%eax),%edx
  800e0f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e18:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e1b:	8a 12                	mov    (%edx),%dl
  800e1d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e25:	89 55 10             	mov    %edx,0x10(%ebp)
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	75 dd                	jne    800e09 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    

00800e31 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e49:	73 50                	jae    800e9b <memmove+0x6a>
  800e4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e51:	01 d0                	add    %edx,%eax
  800e53:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e56:	76 43                	jbe    800e9b <memmove+0x6a>
		s += n;
  800e58:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e61:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e64:	eb 10                	jmp    800e76 <memmove+0x45>
			*--d = *--s;
  800e66:	ff 4d f8             	decl   -0x8(%ebp)
  800e69:	ff 4d fc             	decl   -0x4(%ebp)
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6f:	8a 10                	mov    (%eax),%dl
  800e71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e74:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e76:	8b 45 10             	mov    0x10(%ebp),%eax
  800e79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	75 e3                	jne    800e66 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e83:	eb 23                	jmp    800ea8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e88:	8d 50 01             	lea    0x1(%eax),%edx
  800e8b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e91:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e94:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e97:	8a 12                	mov    (%edx),%dl
  800e99:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	75 dd                	jne    800e85 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ebf:	eb 2a                	jmp    800eeb <memcmp+0x3e>
		if (*s1 != *s2)
  800ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec4:	8a 10                	mov    (%eax),%dl
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	38 c2                	cmp    %al,%dl
  800ecd:	74 16                	je     800ee5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	0f b6 d0             	movzbl %al,%edx
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	0f b6 c0             	movzbl %al,%eax
  800edf:	29 c2                	sub    %eax,%edx
  800ee1:	89 d0                	mov    %edx,%eax
  800ee3:	eb 18                	jmp    800efd <memcmp+0x50>
		s1++, s2++;
  800ee5:	ff 45 fc             	incl   -0x4(%ebp)
  800ee8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800eee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	75 c9                	jne    800ec1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ef8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efd:	c9                   	leave  
  800efe:	c3                   	ret    

00800eff <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f05:	8b 55 08             	mov    0x8(%ebp),%edx
  800f08:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0b:	01 d0                	add    %edx,%eax
  800f0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f10:	eb 15                	jmp    800f27 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	0f b6 d0             	movzbl %al,%edx
  800f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1d:	0f b6 c0             	movzbl %al,%eax
  800f20:	39 c2                	cmp    %eax,%edx
  800f22:	74 0d                	je     800f31 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f24:	ff 45 08             	incl   0x8(%ebp)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f2d:	72 e3                	jb     800f12 <memfind+0x13>
  800f2f:	eb 01                	jmp    800f32 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f31:	90                   	nop
	return (void *) s;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f44:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f4b:	eb 03                	jmp    800f50 <strtol+0x19>
		s++;
  800f4d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 20                	cmp    $0x20,%al
  800f57:	74 f4                	je     800f4d <strtol+0x16>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 09                	cmp    $0x9,%al
  800f60:	74 eb                	je     800f4d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	3c 2b                	cmp    $0x2b,%al
  800f69:	75 05                	jne    800f70 <strtol+0x39>
		s++;
  800f6b:	ff 45 08             	incl   0x8(%ebp)
  800f6e:	eb 13                	jmp    800f83 <strtol+0x4c>
	else if (*s == '-')
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 2d                	cmp    $0x2d,%al
  800f77:	75 0a                	jne    800f83 <strtol+0x4c>
		s++, neg = 1;
  800f79:	ff 45 08             	incl   0x8(%ebp)
  800f7c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f87:	74 06                	je     800f8f <strtol+0x58>
  800f89:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f8d:	75 20                	jne    800faf <strtol+0x78>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 30                	cmp    $0x30,%al
  800f96:	75 17                	jne    800faf <strtol+0x78>
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	40                   	inc    %eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 78                	cmp    $0x78,%al
  800fa0:	75 0d                	jne    800faf <strtol+0x78>
		s += 2, base = 16;
  800fa2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fa6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fad:	eb 28                	jmp    800fd7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800faf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb3:	75 15                	jne    800fca <strtol+0x93>
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 30                	cmp    $0x30,%al
  800fbc:	75 0c                	jne    800fca <strtol+0x93>
		s++, base = 8;
  800fbe:	ff 45 08             	incl   0x8(%ebp)
  800fc1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fc8:	eb 0d                	jmp    800fd7 <strtol+0xa0>
	else if (base == 0)
  800fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fce:	75 07                	jne    800fd7 <strtol+0xa0>
		base = 10;
  800fd0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 2f                	cmp    $0x2f,%al
  800fde:	7e 19                	jle    800ff9 <strtol+0xc2>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 39                	cmp    $0x39,%al
  800fe7:	7f 10                	jg     800ff9 <strtol+0xc2>
			dig = *s - '0';
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f be c0             	movsbl %al,%eax
  800ff1:	83 e8 30             	sub    $0x30,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff7:	eb 42                	jmp    80103b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 60                	cmp    $0x60,%al
  801000:	7e 19                	jle    80101b <strtol+0xe4>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 7a                	cmp    $0x7a,%al
  801009:	7f 10                	jg     80101b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	0f be c0             	movsbl %al,%eax
  801013:	83 e8 57             	sub    $0x57,%eax
  801016:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801019:	eb 20                	jmp    80103b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	3c 40                	cmp    $0x40,%al
  801022:	7e 39                	jle    80105d <strtol+0x126>
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	3c 5a                	cmp    $0x5a,%al
  80102b:	7f 30                	jg     80105d <strtol+0x126>
			dig = *s - 'A' + 10;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	0f be c0             	movsbl %al,%eax
  801035:	83 e8 37             	sub    $0x37,%eax
  801038:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80103b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801041:	7d 19                	jge    80105c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801049:	0f af 45 10          	imul   0x10(%ebp),%eax
  80104d:	89 c2                	mov    %eax,%edx
  80104f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801052:	01 d0                	add    %edx,%eax
  801054:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801057:	e9 7b ff ff ff       	jmp    800fd7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80105c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80105d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801061:	74 08                	je     80106b <strtol+0x134>
		*endptr = (char *) s;
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80106b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80106f:	74 07                	je     801078 <strtol+0x141>
  801071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801074:	f7 d8                	neg    %eax
  801076:	eb 03                	jmp    80107b <strtol+0x144>
  801078:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    

0080107d <ltostr>:

void
ltostr(long value, char *str)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801083:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80108a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801095:	79 13                	jns    8010aa <ltostr+0x2d>
	{
		neg = 1;
  801097:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80109e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010a4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010a7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010b2:	99                   	cltd   
  8010b3:	f7 f9                	idiv   %ecx
  8010b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bb:	8d 50 01             	lea    0x1(%eax),%edx
  8010be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c6:	01 d0                	add    %edx,%eax
  8010c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010cb:	83 c2 30             	add    $0x30,%edx
  8010ce:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d8:	f7 e9                	imul   %ecx
  8010da:	c1 fa 02             	sar    $0x2,%edx
  8010dd:	89 c8                	mov    %ecx,%eax
  8010df:	c1 f8 1f             	sar    $0x1f,%eax
  8010e2:	29 c2                	sub    %eax,%edx
  8010e4:	89 d0                	mov    %edx,%eax
  8010e6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ec:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f1:	f7 e9                	imul   %ecx
  8010f3:	c1 fa 02             	sar    $0x2,%edx
  8010f6:	89 c8                	mov    %ecx,%eax
  8010f8:	c1 f8 1f             	sar    $0x1f,%eax
  8010fb:	29 c2                	sub    %eax,%edx
  8010fd:	89 d0                	mov    %edx,%eax
  8010ff:	c1 e0 02             	shl    $0x2,%eax
  801102:	01 d0                	add    %edx,%eax
  801104:	01 c0                	add    %eax,%eax
  801106:	29 c1                	sub    %eax,%ecx
  801108:	89 ca                	mov    %ecx,%edx
  80110a:	85 d2                	test   %edx,%edx
  80110c:	75 9c                	jne    8010aa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80110e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801115:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801118:	48                   	dec    %eax
  801119:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80111c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801120:	74 3d                	je     80115f <ltostr+0xe2>
		start = 1 ;
  801122:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801129:	eb 34                	jmp    80115f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80112b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801131:	01 d0                	add    %edx,%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	01 c2                	add    %eax,%edx
  801140:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 c8                	add    %ecx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80114c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	01 c2                	add    %eax,%edx
  801154:	8a 45 eb             	mov    -0x15(%ebp),%al
  801157:	88 02                	mov    %al,(%edx)
		start++ ;
  801159:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80115c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80115f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801162:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801165:	7c c4                	jl     80112b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801167:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80116a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116d:	01 d0                	add    %edx,%eax
  80116f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801172:	90                   	nop
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80117b:	ff 75 08             	pushl  0x8(%ebp)
  80117e:	e8 54 fa ff ff       	call   800bd7 <strlen>
  801183:	83 c4 04             	add    $0x4,%esp
  801186:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801189:	ff 75 0c             	pushl  0xc(%ebp)
  80118c:	e8 46 fa ff ff       	call   800bd7 <strlen>
  801191:	83 c4 04             	add    $0x4,%esp
  801194:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801197:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80119e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011a5:	eb 17                	jmp    8011be <strcconcat+0x49>
		final[s] = str1[s] ;
  8011a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ad:	01 c2                	add    %eax,%edx
  8011af:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	01 c8                	add    %ecx,%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011bb:	ff 45 fc             	incl   -0x4(%ebp)
  8011be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011c4:	7c e1                	jl     8011a7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011d4:	eb 1f                	jmp    8011f5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d9:	8d 50 01             	lea    0x1(%eax),%edx
  8011dc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011df:	89 c2                	mov    %eax,%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 c2                	add    %eax,%edx
  8011e6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ec:	01 c8                	add    %ecx,%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011f2:	ff 45 f8             	incl   -0x8(%ebp)
  8011f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011fb:	7c d9                	jl     8011d6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801200:	8b 45 10             	mov    0x10(%ebp),%eax
  801203:	01 d0                	add    %edx,%eax
  801205:	c6 00 00             	movb   $0x0,(%eax)
}
  801208:	90                   	nop
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80120e:	8b 45 14             	mov    0x14(%ebp),%eax
  801211:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801217:	8b 45 14             	mov    0x14(%ebp),%eax
  80121a:	8b 00                	mov    (%eax),%eax
  80121c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801223:	8b 45 10             	mov    0x10(%ebp),%eax
  801226:	01 d0                	add    %edx,%eax
  801228:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80122e:	eb 0c                	jmp    80123c <strsplit+0x31>
			*string++ = 0;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8d 50 01             	lea    0x1(%eax),%edx
  801236:	89 55 08             	mov    %edx,0x8(%ebp)
  801239:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	84 c0                	test   %al,%al
  801243:	74 18                	je     80125d <strsplit+0x52>
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	0f be c0             	movsbl %al,%eax
  80124d:	50                   	push   %eax
  80124e:	ff 75 0c             	pushl  0xc(%ebp)
  801251:	e8 13 fb ff ff       	call   800d69 <strchr>
  801256:	83 c4 08             	add    $0x8,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	75 d3                	jne    801230 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	84 c0                	test   %al,%al
  801264:	74 5a                	je     8012c0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801266:	8b 45 14             	mov    0x14(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	83 f8 0f             	cmp    $0xf,%eax
  80126e:	75 07                	jne    801277 <strsplit+0x6c>
		{
			return 0;
  801270:	b8 00 00 00 00       	mov    $0x0,%eax
  801275:	eb 66                	jmp    8012dd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	8d 48 01             	lea    0x1(%eax),%ecx
  80127f:	8b 55 14             	mov    0x14(%ebp),%edx
  801282:	89 0a                	mov    %ecx,(%edx)
  801284:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80128b:	8b 45 10             	mov    0x10(%ebp),%eax
  80128e:	01 c2                	add    %eax,%edx
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801295:	eb 03                	jmp    80129a <strsplit+0x8f>
			string++;
  801297:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	8a 00                	mov    (%eax),%al
  80129f:	84 c0                	test   %al,%al
  8012a1:	74 8b                	je     80122e <strsplit+0x23>
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	0f be c0             	movsbl %al,%eax
  8012ab:	50                   	push   %eax
  8012ac:	ff 75 0c             	pushl  0xc(%ebp)
  8012af:	e8 b5 fa ff ff       	call   800d69 <strchr>
  8012b4:	83 c4 08             	add    $0x8,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	74 dc                	je     801297 <strsplit+0x8c>
			string++;
	}
  8012bb:	e9 6e ff ff ff       	jmp    80122e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012c0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c4:	8b 00                	mov    (%eax),%eax
  8012c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012d8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8012e5:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8012ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ef:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8012f2:	01 d0                	add    %edx,%eax
  8012f4:	48                   	dec    %eax
  8012f5:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8012f8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8012fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801300:	f7 75 ac             	divl   -0x54(%ebp)
  801303:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801306:	29 d0                	sub    %edx,%eax
  801308:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  80130b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801312:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801319:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801320:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801327:	eb 3f                	jmp    801368 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801329:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80132c:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801333:	83 ec 04             	sub    $0x4,%esp
  801336:	50                   	push   %eax
  801337:	ff 75 e8             	pushl  -0x18(%ebp)
  80133a:	68 f0 29 80 00       	push   $0x8029f0
  80133f:	e8 11 f2 ff ff       	call   800555 <cprintf>
  801344:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801347:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80134a:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801351:	83 ec 04             	sub    $0x4,%esp
  801354:	50                   	push   %eax
  801355:	ff 75 e8             	pushl  -0x18(%ebp)
  801358:	68 05 2a 80 00       	push   $0x802a05
  80135d:	e8 f3 f1 ff ff       	call   800555 <cprintf>
  801362:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801365:	ff 45 e8             	incl   -0x18(%ebp)
  801368:	a1 28 30 80 00       	mov    0x803028,%eax
  80136d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801370:	7c b7                	jl     801329 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801372:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801379:	e9 42 01 00 00       	jmp    8014c0 <malloc+0x1e1>
		int flag0=1;
  80137e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801385:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801388:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80138b:	eb 6b                	jmp    8013f8 <malloc+0x119>
			for(int k=0;k<count;k++){
  80138d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801394:	eb 42                	jmp    8013d8 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801396:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801399:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8013a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013a3:	39 c2                	cmp    %eax,%edx
  8013a5:	77 2e                	ja     8013d5 <malloc+0xf6>
  8013a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013aa:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8013b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013b4:	39 c2                	cmp    %eax,%edx
  8013b6:	76 1d                	jbe    8013d5 <malloc+0xf6>
					ni=arr_add[k].end-i;
  8013b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013bb:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8013c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c5:	29 c2                	sub    %eax,%edx
  8013c7:	89 d0                	mov    %edx,%eax
  8013c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  8013cc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8013d3:	eb 0d                	jmp    8013e2 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8013d5:	ff 45 d8             	incl   -0x28(%ebp)
  8013d8:	a1 28 30 80 00       	mov    0x803028,%eax
  8013dd:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8013e0:	7c b4                	jl     801396 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8013e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013e6:	74 09                	je     8013f1 <malloc+0x112>
				flag0=0;
  8013e8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8013ef:	eb 16                	jmp    801407 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8013f1:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8013f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801403:	39 c2                	cmp    %eax,%edx
  801405:	77 86                	ja     80138d <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801407:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80140b:	0f 84 a2 00 00 00    	je     8014b3 <malloc+0x1d4>

			int f=1;
  801411:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801418:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80141b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80141e:	89 c8                	mov    %ecx,%eax
  801420:	01 c0                	add    %eax,%eax
  801422:	01 c8                	add    %ecx,%eax
  801424:	c1 e0 02             	shl    $0x2,%eax
  801427:	05 20 31 80 00       	add    $0x803120,%eax
  80142c:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  80142e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801437:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143a:	89 d0                	mov    %edx,%eax
  80143c:	01 c0                	add    %eax,%eax
  80143e:	01 d0                	add    %edx,%eax
  801440:	c1 e0 02             	shl    $0x2,%eax
  801443:	05 24 31 80 00       	add    $0x803124,%eax
  801448:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  80144a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144d:	89 d0                	mov    %edx,%eax
  80144f:	01 c0                	add    %eax,%eax
  801451:	01 d0                	add    %edx,%eax
  801453:	c1 e0 02             	shl    $0x2,%eax
  801456:	05 28 31 80 00       	add    $0x803128,%eax
  80145b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801461:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801464:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80146b:	eb 36                	jmp    8014a3 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  80146d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	01 c2                	add    %eax,%edx
  801475:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801478:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80147f:	39 c2                	cmp    %eax,%edx
  801481:	73 1d                	jae    8014a0 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801483:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801486:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80148d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801490:	29 c2                	sub    %eax,%edx
  801492:	89 d0                	mov    %edx,%eax
  801494:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801497:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  80149e:	eb 0d                	jmp    8014ad <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  8014a0:	ff 45 d0             	incl   -0x30(%ebp)
  8014a3:	a1 28 30 80 00       	mov    0x803028,%eax
  8014a8:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8014ab:	7c c0                	jl     80146d <malloc+0x18e>
					break;

				}
			}

			if(f){
  8014ad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014b1:	75 1d                	jne    8014d0 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  8014b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8014ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014bd:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8014c0:	a1 04 30 80 00       	mov    0x803004,%eax
  8014c5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8014c8:	0f 8c b0 fe ff ff    	jl     80137e <malloc+0x9f>
  8014ce:	eb 01                	jmp    8014d1 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  8014d0:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8014d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014d5:	75 7a                	jne    801551 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  8014d7:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	01 d0                	add    %edx,%eax
  8014e2:	48                   	dec    %eax
  8014e3:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8014e8:	7c 0a                	jl     8014f4 <malloc+0x215>
			return NULL;
  8014ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ef:	e9 a4 02 00 00       	jmp    801798 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  8014f4:	a1 04 30 80 00       	mov    0x803004,%eax
  8014f9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8014fc:	a1 28 30 80 00       	mov    0x803028,%eax
  801501:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801504:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  80150b:	83 ec 08             	sub    $0x8,%esp
  80150e:	ff 75 08             	pushl  0x8(%ebp)
  801511:	ff 75 a4             	pushl  -0x5c(%ebp)
  801514:	e8 04 06 00 00       	call   801b1d <sys_allocateMem>
  801519:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  80151c:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	01 d0                	add    %edx,%eax
  801527:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  80152c:	a1 28 30 80 00       	mov    0x803028,%eax
  801531:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801537:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  80153e:	a1 28 30 80 00       	mov    0x803028,%eax
  801543:	40                   	inc    %eax
  801544:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  801549:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80154c:	e9 47 02 00 00       	jmp    801798 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801551:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801558:	e9 ac 00 00 00       	jmp    801609 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  80155d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801560:	89 d0                	mov    %edx,%eax
  801562:	01 c0                	add    %eax,%eax
  801564:	01 d0                	add    %edx,%eax
  801566:	c1 e0 02             	shl    $0x2,%eax
  801569:	05 24 31 80 00       	add    $0x803124,%eax
  80156e:	8b 00                	mov    (%eax),%eax
  801570:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801573:	eb 7e                	jmp    8015f3 <malloc+0x314>
			int flag=0;
  801575:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  80157c:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801583:	eb 57                	jmp    8015dc <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801585:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801588:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80158f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801592:	39 c2                	cmp    %eax,%edx
  801594:	77 1a                	ja     8015b0 <malloc+0x2d1>
  801596:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801599:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8015a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8015a3:	39 c2                	cmp    %eax,%edx
  8015a5:	76 09                	jbe    8015b0 <malloc+0x2d1>
								flag=1;
  8015a7:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  8015ae:	eb 36                	jmp    8015e6 <malloc+0x307>
			arr[i].space++;
  8015b0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8015b3:	89 d0                	mov    %edx,%eax
  8015b5:	01 c0                	add    %eax,%eax
  8015b7:	01 d0                	add    %edx,%eax
  8015b9:	c1 e0 02             	shl    $0x2,%eax
  8015bc:	05 28 31 80 00       	add    $0x803128,%eax
  8015c1:	8b 00                	mov    (%eax),%eax
  8015c3:	8d 48 01             	lea    0x1(%eax),%ecx
  8015c6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8015c9:	89 d0                	mov    %edx,%eax
  8015cb:	01 c0                	add    %eax,%eax
  8015cd:	01 d0                	add    %edx,%eax
  8015cf:	c1 e0 02             	shl    $0x2,%eax
  8015d2:	05 28 31 80 00       	add    $0x803128,%eax
  8015d7:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  8015d9:	ff 45 c0             	incl   -0x40(%ebp)
  8015dc:	a1 28 30 80 00       	mov    0x803028,%eax
  8015e1:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  8015e4:	7c 9f                	jl     801585 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  8015e6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8015ea:	75 19                	jne    801605 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8015ec:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8015f3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8015f6:	a1 04 30 80 00       	mov    0x803004,%eax
  8015fb:	39 c2                	cmp    %eax,%edx
  8015fd:	0f 82 72 ff ff ff    	jb     801575 <malloc+0x296>
  801603:	eb 01                	jmp    801606 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801605:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801606:	ff 45 cc             	incl   -0x34(%ebp)
  801609:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80160c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80160f:	0f 8c 48 ff ff ff    	jl     80155d <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801615:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  80161c:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801623:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  80162a:	eb 37                	jmp    801663 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  80162c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80162f:	89 d0                	mov    %edx,%eax
  801631:	01 c0                	add    %eax,%eax
  801633:	01 d0                	add    %edx,%eax
  801635:	c1 e0 02             	shl    $0x2,%eax
  801638:	05 28 31 80 00       	add    $0x803128,%eax
  80163d:	8b 00                	mov    (%eax),%eax
  80163f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801642:	7d 1c                	jge    801660 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801644:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801647:	89 d0                	mov    %edx,%eax
  801649:	01 c0                	add    %eax,%eax
  80164b:	01 d0                	add    %edx,%eax
  80164d:	c1 e0 02             	shl    $0x2,%eax
  801650:	05 28 31 80 00       	add    $0x803128,%eax
  801655:	8b 00                	mov    (%eax),%eax
  801657:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  80165a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80165d:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801660:	ff 45 b4             	incl   -0x4c(%ebp)
  801663:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801666:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801669:	7c c1                	jl     80162c <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  80166b:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801671:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801674:	89 c8                	mov    %ecx,%eax
  801676:	01 c0                	add    %eax,%eax
  801678:	01 c8                	add    %ecx,%eax
  80167a:	c1 e0 02             	shl    $0x2,%eax
  80167d:	05 20 31 80 00       	add    $0x803120,%eax
  801682:	8b 00                	mov    (%eax),%eax
  801684:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  80168b:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801691:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801694:	89 c8                	mov    %ecx,%eax
  801696:	01 c0                	add    %eax,%eax
  801698:	01 c8                	add    %ecx,%eax
  80169a:	c1 e0 02             	shl    $0x2,%eax
  80169d:	05 24 31 80 00       	add    $0x803124,%eax
  8016a2:	8b 00                	mov    (%eax),%eax
  8016a4:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  8016ab:	a1 28 30 80 00       	mov    0x803028,%eax
  8016b0:	40                   	inc    %eax
  8016b1:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  8016b6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8016b9:	89 d0                	mov    %edx,%eax
  8016bb:	01 c0                	add    %eax,%eax
  8016bd:	01 d0                	add    %edx,%eax
  8016bf:	c1 e0 02             	shl    $0x2,%eax
  8016c2:	05 20 31 80 00       	add    $0x803120,%eax
  8016c7:	8b 00                	mov    (%eax),%eax
  8016c9:	83 ec 08             	sub    $0x8,%esp
  8016cc:	ff 75 08             	pushl  0x8(%ebp)
  8016cf:	50                   	push   %eax
  8016d0:	e8 48 04 00 00       	call   801b1d <sys_allocateMem>
  8016d5:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  8016d8:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8016df:	eb 78                	jmp    801759 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8016e1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8016e4:	89 d0                	mov    %edx,%eax
  8016e6:	01 c0                	add    %eax,%eax
  8016e8:	01 d0                	add    %edx,%eax
  8016ea:	c1 e0 02             	shl    $0x2,%eax
  8016ed:	05 20 31 80 00       	add    $0x803120,%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	83 ec 04             	sub    $0x4,%esp
  8016f7:	50                   	push   %eax
  8016f8:	ff 75 b0             	pushl  -0x50(%ebp)
  8016fb:	68 f0 29 80 00       	push   $0x8029f0
  801700:	e8 50 ee ff ff       	call   800555 <cprintf>
  801705:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801708:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80170b:	89 d0                	mov    %edx,%eax
  80170d:	01 c0                	add    %eax,%eax
  80170f:	01 d0                	add    %edx,%eax
  801711:	c1 e0 02             	shl    $0x2,%eax
  801714:	05 24 31 80 00       	add    $0x803124,%eax
  801719:	8b 00                	mov    (%eax),%eax
  80171b:	83 ec 04             	sub    $0x4,%esp
  80171e:	50                   	push   %eax
  80171f:	ff 75 b0             	pushl  -0x50(%ebp)
  801722:	68 05 2a 80 00       	push   $0x802a05
  801727:	e8 29 ee ff ff       	call   800555 <cprintf>
  80172c:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  80172f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801732:	89 d0                	mov    %edx,%eax
  801734:	01 c0                	add    %eax,%eax
  801736:	01 d0                	add    %edx,%eax
  801738:	c1 e0 02             	shl    $0x2,%eax
  80173b:	05 28 31 80 00       	add    $0x803128,%eax
  801740:	8b 00                	mov    (%eax),%eax
  801742:	83 ec 04             	sub    $0x4,%esp
  801745:	50                   	push   %eax
  801746:	ff 75 b0             	pushl  -0x50(%ebp)
  801749:	68 18 2a 80 00       	push   $0x802a18
  80174e:	e8 02 ee ff ff       	call   800555 <cprintf>
  801753:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801756:	ff 45 b0             	incl   -0x50(%ebp)
  801759:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80175c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80175f:	7c 80                	jl     8016e1 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801761:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801764:	89 d0                	mov    %edx,%eax
  801766:	01 c0                	add    %eax,%eax
  801768:	01 d0                	add    %edx,%eax
  80176a:	c1 e0 02             	shl    $0x2,%eax
  80176d:	05 20 31 80 00       	add    $0x803120,%eax
  801772:	8b 00                	mov    (%eax),%eax
  801774:	83 ec 08             	sub    $0x8,%esp
  801777:	50                   	push   %eax
  801778:	68 2c 2a 80 00       	push   $0x802a2c
  80177d:	e8 d3 ed ff ff       	call   800555 <cprintf>
  801782:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801785:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801788:	89 d0                	mov    %edx,%eax
  80178a:	01 c0                	add    %eax,%eax
  80178c:	01 d0                	add    %edx,%eax
  80178e:	c1 e0 02             	shl    $0x2,%eax
  801791:	05 20 31 80 00       	add    $0x803120,%eax
  801796:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  8017a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8017ad:	eb 4b                	jmp    8017fa <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  8017af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b2:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8017b9:	89 c2                	mov    %eax,%edx
  8017bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017be:	39 c2                	cmp    %eax,%edx
  8017c0:	7f 35                	jg     8017f7 <free+0x5d>
  8017c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c5:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8017cc:	89 c2                	mov    %eax,%edx
  8017ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017d1:	39 c2                	cmp    %eax,%edx
  8017d3:	7e 22                	jle    8017f7 <free+0x5d>
				start=arr_add[i].start;
  8017d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d8:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8017df:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8017e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e5:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8017ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8017ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8017f5:	eb 0d                	jmp    801804 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8017f7:	ff 45 ec             	incl   -0x14(%ebp)
  8017fa:	a1 28 30 80 00       	mov    0x803028,%eax
  8017ff:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801802:	7c ab                	jl     8017af <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801807:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80180e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801811:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801818:	29 c2                	sub    %eax,%edx
  80181a:	89 d0                	mov    %edx,%eax
  80181c:	83 ec 08             	sub    $0x8,%esp
  80181f:	50                   	push   %eax
  801820:	ff 75 f4             	pushl  -0xc(%ebp)
  801823:	e8 d9 02 00 00       	call   801b01 <sys_freeMem>
  801828:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  80182b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801831:	eb 2d                	jmp    801860 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801833:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801836:	40                   	inc    %eax
  801837:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80183e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801841:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801848:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80184b:	40                   	inc    %eax
  80184c:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801853:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801856:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  80185d:	ff 45 e8             	incl   -0x18(%ebp)
  801860:	a1 28 30 80 00       	mov    0x803028,%eax
  801865:	48                   	dec    %eax
  801866:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801869:	7f c8                	jg     801833 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  80186b:	a1 28 30 80 00       	mov    0x803028,%eax
  801870:	48                   	dec    %eax
  801871:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801876:	90                   	nop
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 18             	sub    $0x18,%esp
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801885:	83 ec 04             	sub    $0x4,%esp
  801888:	68 48 2a 80 00       	push   $0x802a48
  80188d:	68 18 01 00 00       	push   $0x118
  801892:	68 6b 2a 80 00       	push   $0x802a6b
  801897:	e8 17 ea ff ff       	call   8002b3 <_panic>

0080189c <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	68 48 2a 80 00       	push   $0x802a48
  8018aa:	68 1e 01 00 00       	push   $0x11e
  8018af:	68 6b 2a 80 00       	push   $0x802a6b
  8018b4:	e8 fa e9 ff ff       	call   8002b3 <_panic>

008018b9 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	68 48 2a 80 00       	push   $0x802a48
  8018c7:	68 24 01 00 00       	push   $0x124
  8018cc:	68 6b 2a 80 00       	push   $0x802a6b
  8018d1:	e8 dd e9 ff ff       	call   8002b3 <_panic>

008018d6 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018dc:	83 ec 04             	sub    $0x4,%esp
  8018df:	68 48 2a 80 00       	push   $0x802a48
  8018e4:	68 29 01 00 00       	push   $0x129
  8018e9:	68 6b 2a 80 00       	push   $0x802a6b
  8018ee:	e8 c0 e9 ff ff       	call   8002b3 <_panic>

008018f3 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018f9:	83 ec 04             	sub    $0x4,%esp
  8018fc:	68 48 2a 80 00       	push   $0x802a48
  801901:	68 2f 01 00 00       	push   $0x12f
  801906:	68 6b 2a 80 00       	push   $0x802a6b
  80190b:	e8 a3 e9 ff ff       	call   8002b3 <_panic>

00801910 <shrink>:
}
void shrink(uint32 newSize)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801916:	83 ec 04             	sub    $0x4,%esp
  801919:	68 48 2a 80 00       	push   $0x802a48
  80191e:	68 33 01 00 00       	push   $0x133
  801923:	68 6b 2a 80 00       	push   $0x802a6b
  801928:	e8 86 e9 ff ff       	call   8002b3 <_panic>

0080192d <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801933:	83 ec 04             	sub    $0x4,%esp
  801936:	68 48 2a 80 00       	push   $0x802a48
  80193b:	68 38 01 00 00       	push   $0x138
  801940:	68 6b 2a 80 00       	push   $0x802a6b
  801945:	e8 69 e9 ff ff       	call   8002b3 <_panic>

0080194a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	57                   	push   %edi
  80194e:	56                   	push   %esi
  80194f:	53                   	push   %ebx
  801950:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8b 55 0c             	mov    0xc(%ebp),%edx
  801959:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80195f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801962:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801965:	cd 30                	int    $0x30
  801967:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80196a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	5b                   	pop    %ebx
  801971:	5e                   	pop    %esi
  801972:	5f                   	pop    %edi
  801973:	5d                   	pop    %ebp
  801974:	c3                   	ret    

00801975 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 04             	sub    $0x4,%esp
  80197b:	8b 45 10             	mov    0x10(%ebp),%eax
  80197e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801981:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	52                   	push   %edx
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	50                   	push   %eax
  801991:	6a 00                	push   $0x0
  801993:	e8 b2 ff ff ff       	call   80194a <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	90                   	nop
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_cgetc>:

int
sys_cgetc(void)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 01                	push   $0x1
  8019ad:	e8 98 ff ff ff       	call   80194a <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	50                   	push   %eax
  8019c6:	6a 05                	push   $0x5
  8019c8:	e8 7d ff ff ff       	call   80194a <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 02                	push   $0x2
  8019e1:	e8 64 ff ff ff       	call   80194a <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 03                	push   $0x3
  8019fa:	e8 4b ff ff ff       	call   80194a <syscall>
  8019ff:	83 c4 18             	add    $0x18,%esp
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 04                	push   $0x4
  801a13:	e8 32 ff ff ff       	call   80194a <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_env_exit>:


void sys_env_exit(void)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 06                	push   $0x6
  801a2c:	e8 19 ff ff ff       	call   80194a <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	90                   	nop
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	52                   	push   %edx
  801a47:	50                   	push   %eax
  801a48:	6a 07                	push   $0x7
  801a4a:	e8 fb fe ff ff       	call   80194a <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	56                   	push   %esi
  801a58:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a59:	8b 75 18             	mov    0x18(%ebp),%esi
  801a5c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	56                   	push   %esi
  801a69:	53                   	push   %ebx
  801a6a:	51                   	push   %ecx
  801a6b:	52                   	push   %edx
  801a6c:	50                   	push   %eax
  801a6d:	6a 08                	push   $0x8
  801a6f:	e8 d6 fe ff ff       	call   80194a <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a7a:	5b                   	pop    %ebx
  801a7b:	5e                   	pop    %esi
  801a7c:	5d                   	pop    %ebp
  801a7d:	c3                   	ret    

00801a7e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	52                   	push   %edx
  801a8e:	50                   	push   %eax
  801a8f:	6a 09                	push   $0x9
  801a91:	e8 b4 fe ff ff       	call   80194a <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	ff 75 0c             	pushl  0xc(%ebp)
  801aa7:	ff 75 08             	pushl  0x8(%ebp)
  801aaa:	6a 0a                	push   $0xa
  801aac:	e8 99 fe ff ff       	call   80194a <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 0b                	push   $0xb
  801ac5:	e8 80 fe ff ff       	call   80194a <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 0c                	push   $0xc
  801ade:	e8 67 fe ff ff       	call   80194a <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 0d                	push   $0xd
  801af7:	e8 4e fe ff ff       	call   80194a <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	ff 75 0c             	pushl  0xc(%ebp)
  801b0d:	ff 75 08             	pushl  0x8(%ebp)
  801b10:	6a 11                	push   $0x11
  801b12:	e8 33 fe ff ff       	call   80194a <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
	return;
  801b1a:	90                   	nop
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	ff 75 0c             	pushl  0xc(%ebp)
  801b29:	ff 75 08             	pushl  0x8(%ebp)
  801b2c:	6a 12                	push   $0x12
  801b2e:	e8 17 fe ff ff       	call   80194a <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
	return ;
  801b36:	90                   	nop
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 0e                	push   $0xe
  801b48:	e8 fd fd ff ff       	call   80194a <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	ff 75 08             	pushl  0x8(%ebp)
  801b60:	6a 0f                	push   $0xf
  801b62:	e8 e3 fd ff ff       	call   80194a <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 10                	push   $0x10
  801b7b:	e8 ca fd ff ff       	call   80194a <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
}
  801b83:	90                   	nop
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 14                	push   $0x14
  801b95:	e8 b0 fd ff ff       	call   80194a <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	90                   	nop
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 15                	push   $0x15
  801baf:	e8 96 fd ff ff       	call   80194a <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	90                   	nop
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_cputc>:


void
sys_cputc(const char c)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bc6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	50                   	push   %eax
  801bd3:	6a 16                	push   $0x16
  801bd5:	e8 70 fd ff ff       	call   80194a <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
}
  801bdd:	90                   	nop
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 17                	push   $0x17
  801bef:	e8 56 fd ff ff       	call   80194a <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	90                   	nop
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	ff 75 0c             	pushl  0xc(%ebp)
  801c09:	50                   	push   %eax
  801c0a:	6a 18                	push   $0x18
  801c0c:	e8 39 fd ff ff       	call   80194a <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	52                   	push   %edx
  801c26:	50                   	push   %eax
  801c27:	6a 1b                	push   $0x1b
  801c29:	e8 1c fd ff ff       	call   80194a <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	52                   	push   %edx
  801c43:	50                   	push   %eax
  801c44:	6a 19                	push   $0x19
  801c46:	e8 ff fc ff ff       	call   80194a <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
}
  801c4e:	90                   	nop
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	52                   	push   %edx
  801c61:	50                   	push   %eax
  801c62:	6a 1a                	push   $0x1a
  801c64:	e8 e1 fc ff ff       	call   80194a <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	90                   	nop
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 04             	sub    $0x4,%esp
  801c75:	8b 45 10             	mov    0x10(%ebp),%eax
  801c78:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c7b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c7e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	6a 00                	push   $0x0
  801c87:	51                   	push   %ecx
  801c88:	52                   	push   %edx
  801c89:	ff 75 0c             	pushl  0xc(%ebp)
  801c8c:	50                   	push   %eax
  801c8d:	6a 1c                	push   $0x1c
  801c8f:	e8 b6 fc ff ff       	call   80194a <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	52                   	push   %edx
  801ca9:	50                   	push   %eax
  801caa:	6a 1d                	push   $0x1d
  801cac:	e8 99 fc ff ff       	call   80194a <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	51                   	push   %ecx
  801cc7:	52                   	push   %edx
  801cc8:	50                   	push   %eax
  801cc9:	6a 1e                	push   $0x1e
  801ccb:	e8 7a fc ff ff       	call   80194a <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	52                   	push   %edx
  801ce5:	50                   	push   %eax
  801ce6:	6a 1f                	push   $0x1f
  801ce8:	e8 5d fc ff ff       	call   80194a <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 20                	push   $0x20
  801d01:	e8 44 fc ff ff       	call   80194a <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	6a 00                	push   $0x0
  801d13:	ff 75 14             	pushl  0x14(%ebp)
  801d16:	ff 75 10             	pushl  0x10(%ebp)
  801d19:	ff 75 0c             	pushl  0xc(%ebp)
  801d1c:	50                   	push   %eax
  801d1d:	6a 21                	push   $0x21
  801d1f:	e8 26 fc ff ff       	call   80194a <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	50                   	push   %eax
  801d38:	6a 22                	push   $0x22
  801d3a:	e8 0b fc ff ff       	call   80194a <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
}
  801d42:	90                   	nop
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	50                   	push   %eax
  801d54:	6a 23                	push   $0x23
  801d56:	e8 ef fb ff ff       	call   80194a <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
}
  801d5e:	90                   	nop
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d67:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d6a:	8d 50 04             	lea    0x4(%eax),%edx
  801d6d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	52                   	push   %edx
  801d77:	50                   	push   %eax
  801d78:	6a 24                	push   $0x24
  801d7a:	e8 cb fb ff ff       	call   80194a <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
	return result;
  801d82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d88:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d8b:	89 01                	mov    %eax,(%ecx)
  801d8d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	c9                   	leave  
  801d94:	c2 04 00             	ret    $0x4

00801d97 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	ff 75 10             	pushl  0x10(%ebp)
  801da1:	ff 75 0c             	pushl  0xc(%ebp)
  801da4:	ff 75 08             	pushl  0x8(%ebp)
  801da7:	6a 13                	push   $0x13
  801da9:	e8 9c fb ff ff       	call   80194a <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
	return ;
  801db1:	90                   	nop
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 25                	push   $0x25
  801dc3:	e8 82 fb ff ff       	call   80194a <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 04             	sub    $0x4,%esp
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dd9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	50                   	push   %eax
  801de6:	6a 26                	push   $0x26
  801de8:	e8 5d fb ff ff       	call   80194a <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
	return ;
  801df0:	90                   	nop
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <rsttst>:
void rsttst()
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 28                	push   $0x28
  801e02:	e8 43 fb ff ff       	call   80194a <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0a:	90                   	nop
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 04             	sub    $0x4,%esp
  801e13:	8b 45 14             	mov    0x14(%ebp),%eax
  801e16:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e19:	8b 55 18             	mov    0x18(%ebp),%edx
  801e1c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e20:	52                   	push   %edx
  801e21:	50                   	push   %eax
  801e22:	ff 75 10             	pushl  0x10(%ebp)
  801e25:	ff 75 0c             	pushl  0xc(%ebp)
  801e28:	ff 75 08             	pushl  0x8(%ebp)
  801e2b:	6a 27                	push   $0x27
  801e2d:	e8 18 fb ff ff       	call   80194a <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
	return ;
  801e35:	90                   	nop
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <chktst>:
void chktst(uint32 n)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	ff 75 08             	pushl  0x8(%ebp)
  801e46:	6a 29                	push   $0x29
  801e48:	e8 fd fa ff ff       	call   80194a <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e50:	90                   	nop
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <inctst>:

void inctst()
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 2a                	push   $0x2a
  801e62:	e8 e3 fa ff ff       	call   80194a <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6a:	90                   	nop
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <gettst>:
uint32 gettst()
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 2b                	push   $0x2b
  801e7c:	e8 c9 fa ff ff       	call   80194a <syscall>
  801e81:	83 c4 18             	add    $0x18,%esp
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 2c                	push   $0x2c
  801e98:	e8 ad fa ff ff       	call   80194a <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
  801ea0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ea3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ea7:	75 07                	jne    801eb0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ea9:	b8 01 00 00 00       	mov    $0x1,%eax
  801eae:	eb 05                	jmp    801eb5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 2c                	push   $0x2c
  801ec9:	e8 7c fa ff ff       	call   80194a <syscall>
  801ece:	83 c4 18             	add    $0x18,%esp
  801ed1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ed4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ed8:	75 07                	jne    801ee1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eda:	b8 01 00 00 00       	mov    $0x1,%eax
  801edf:	eb 05                	jmp    801ee6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 2c                	push   $0x2c
  801efa:	e8 4b fa ff ff       	call   80194a <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
  801f02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f05:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f09:	75 07                	jne    801f12 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f10:	eb 05                	jmp    801f17 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 2c                	push   $0x2c
  801f2b:	e8 1a fa ff ff       	call   80194a <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
  801f33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f36:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f3a:	75 07                	jne    801f43 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f3c:	b8 01 00 00 00       	mov    $0x1,%eax
  801f41:	eb 05                	jmp    801f48 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	ff 75 08             	pushl  0x8(%ebp)
  801f58:	6a 2d                	push   $0x2d
  801f5a:	e8 eb f9 ff ff       	call   80194a <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f62:	90                   	nop
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f69:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f72:	8b 45 08             	mov    0x8(%ebp),%eax
  801f75:	6a 00                	push   $0x0
  801f77:	53                   	push   %ebx
  801f78:	51                   	push   %ecx
  801f79:	52                   	push   %edx
  801f7a:	50                   	push   %eax
  801f7b:	6a 2e                	push   $0x2e
  801f7d:	e8 c8 f9 ff ff       	call   80194a <syscall>
  801f82:	83 c4 18             	add    $0x18,%esp
}
  801f85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	52                   	push   %edx
  801f9a:	50                   	push   %eax
  801f9b:	6a 2f                	push   $0x2f
  801f9d:	e8 a8 f9 ff ff       	call   80194a <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801fad:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb0:	89 d0                	mov    %edx,%eax
  801fb2:	c1 e0 02             	shl    $0x2,%eax
  801fb5:	01 d0                	add    %edx,%eax
  801fb7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fbe:	01 d0                	add    %edx,%eax
  801fc0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fc7:	01 d0                	add    %edx,%eax
  801fc9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fd0:	01 d0                	add    %edx,%eax
  801fd2:	c1 e0 04             	shl    $0x4,%eax
  801fd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801fd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801fdf:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801fe2:	83 ec 0c             	sub    $0xc,%esp
  801fe5:	50                   	push   %eax
  801fe6:	e8 76 fd ff ff       	call   801d61 <sys_get_virtual_time>
  801feb:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801fee:	eb 41                	jmp    802031 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801ff0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ff3:	83 ec 0c             	sub    $0xc,%esp
  801ff6:	50                   	push   %eax
  801ff7:	e8 65 fd ff ff       	call   801d61 <sys_get_virtual_time>
  801ffc:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801fff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802002:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802005:	29 c2                	sub    %eax,%edx
  802007:	89 d0                	mov    %edx,%eax
  802009:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80200c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80200f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802012:	89 d1                	mov    %edx,%ecx
  802014:	29 c1                	sub    %eax,%ecx
  802016:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802019:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80201c:	39 c2                	cmp    %eax,%edx
  80201e:	0f 97 c0             	seta   %al
  802021:	0f b6 c0             	movzbl %al,%eax
  802024:	29 c1                	sub    %eax,%ecx
  802026:	89 c8                	mov    %ecx,%eax
  802028:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80202b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80202e:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802034:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802037:	72 b7                	jb     801ff0 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802039:	90                   	nop
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802042:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802049:	eb 03                	jmp    80204e <busy_wait+0x12>
  80204b:	ff 45 fc             	incl   -0x4(%ebp)
  80204e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802051:	3b 45 08             	cmp    0x8(%ebp),%eax
  802054:	72 f5                	jb     80204b <busy_wait+0xf>
	return i;
  802056:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    
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
