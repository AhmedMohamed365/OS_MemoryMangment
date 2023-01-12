
obj/user/tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 e3 00 00 00       	call   800119 <libmain>
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
  800086:	68 c0 21 80 00       	push   $0x8021c0
  80008b:	6a 12                	push   $0x12
  80008d:	68 dc 21 80 00       	push   $0x8021dc
  800092:	e8 c7 01 00 00       	call   80025e <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  800097:	e8 13 19 00 00       	call   8019af <sys_getparentenvid>
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	68 f7 21 80 00       	push   $0x8021f7
  8000a4:	50                   	push   %eax
  8000a5:	e8 9d 17 00 00       	call   801847 <sget>
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b0:	e8 ac 19 00 00       	call   801a61 <sys_calculate_free_frames>
  8000b5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	68 fc 21 80 00       	push   $0x8021fc
  8000c0:	e8 3b 04 00 00       	call   800500 <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000c8:	83 ec 0c             	sub    $0xc,%esp
  8000cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ce:	e8 91 17 00 00       	call   801864 <sfree>
  8000d3:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 20 22 80 00       	push   $0x802220
  8000de:	e8 1d 04 00 00       	call   800500 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000e6:	e8 76 19 00 00       	call   801a61 <sys_calculate_free_frames>
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f0:	29 c2                	sub    %eax,%edx
  8000f2:	89 d0                	mov    %edx,%eax
  8000f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000f7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8000fb:	74 14                	je     800111 <_main+0xd9>
  8000fd:	83 ec 04             	sub    $0x4,%esp
  800100:	68 38 22 80 00       	push   $0x802238
  800105:	6a 1f                	push   $0x1f
  800107:	68 dc 21 80 00       	push   $0x8021dc
  80010c:	e8 4d 01 00 00       	call   80025e <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800111:	e8 e8 1c 00 00       	call   801dfe <inctst>

	return;
  800116:	90                   	nop
}
  800117:	c9                   	leave  
  800118:	c3                   	ret    

00800119 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80011f:	e8 72 18 00 00       	call   801996 <sys_getenvindex>
  800124:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80012a:	89 d0                	mov    %edx,%eax
  80012c:	c1 e0 03             	shl    $0x3,%eax
  80012f:	01 d0                	add    %edx,%eax
  800131:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800138:	01 c8                	add    %ecx,%eax
  80013a:	01 c0                	add    %eax,%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	01 c0                	add    %eax,%eax
  800140:	01 d0                	add    %edx,%eax
  800142:	89 c2                	mov    %eax,%edx
  800144:	c1 e2 05             	shl    $0x5,%edx
  800147:	29 c2                	sub    %eax,%edx
  800149:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800150:	89 c2                	mov    %eax,%edx
  800152:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800158:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80015d:	a1 20 30 80 00       	mov    0x803020,%eax
  800162:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800168:	84 c0                	test   %al,%al
  80016a:	74 0f                	je     80017b <libmain+0x62>
		binaryname = myEnv->prog_name;
  80016c:	a1 20 30 80 00       	mov    0x803020,%eax
  800171:	05 40 3c 01 00       	add    $0x13c40,%eax
  800176:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80017f:	7e 0a                	jle    80018b <libmain+0x72>
		binaryname = argv[0];
  800181:	8b 45 0c             	mov    0xc(%ebp),%eax
  800184:	8b 00                	mov    (%eax),%eax
  800186:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	ff 75 0c             	pushl  0xc(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 9f fe ff ff       	call   800038 <_main>
  800199:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80019c:	e8 90 19 00 00       	call   801b31 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	68 dc 22 80 00       	push   $0x8022dc
  8001a9:	e8 52 03 00 00       	call   800500 <cprintf>
  8001ae:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b6:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8001bc:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c1:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8001c7:	83 ec 04             	sub    $0x4,%esp
  8001ca:	52                   	push   %edx
  8001cb:	50                   	push   %eax
  8001cc:	68 04 23 80 00       	push   $0x802304
  8001d1:	e8 2a 03 00 00       	call   800500 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8001d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001de:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8001e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e9:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	52                   	push   %edx
  8001f3:	50                   	push   %eax
  8001f4:	68 2c 23 80 00       	push   $0x80232c
  8001f9:	e8 02 03 00 00       	call   800500 <cprintf>
  8001fe:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800201:	a1 20 30 80 00       	mov    0x803020,%eax
  800206:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	50                   	push   %eax
  800210:	68 6d 23 80 00       	push   $0x80236d
  800215:	e8 e6 02 00 00       	call   800500 <cprintf>
  80021a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	68 dc 22 80 00       	push   $0x8022dc
  800225:	e8 d6 02 00 00       	call   800500 <cprintf>
  80022a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022d:	e8 19 19 00 00       	call   801b4b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800232:	e8 19 00 00 00       	call   800250 <exit>
}
  800237:	90                   	nop
  800238:	c9                   	leave  
  800239:	c3                   	ret    

0080023a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	6a 00                	push   $0x0
  800245:	e8 18 17 00 00       	call   801962 <sys_env_destroy>
  80024a:	83 c4 10             	add    $0x10,%esp
}
  80024d:	90                   	nop
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <exit>:

void
exit(void)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800256:	e8 6d 17 00 00       	call   8019c8 <sys_env_exit>
}
  80025b:	90                   	nop
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800264:	8d 45 10             	lea    0x10(%ebp),%eax
  800267:	83 c0 04             	add    $0x4,%eax
  80026a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80026d:	a1 18 31 80 00       	mov    0x803118,%eax
  800272:	85 c0                	test   %eax,%eax
  800274:	74 16                	je     80028c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800276:	a1 18 31 80 00       	mov    0x803118,%eax
  80027b:	83 ec 08             	sub    $0x8,%esp
  80027e:	50                   	push   %eax
  80027f:	68 84 23 80 00       	push   $0x802384
  800284:	e8 77 02 00 00       	call   800500 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80028c:	a1 00 30 80 00       	mov    0x803000,%eax
  800291:	ff 75 0c             	pushl  0xc(%ebp)
  800294:	ff 75 08             	pushl  0x8(%ebp)
  800297:	50                   	push   %eax
  800298:	68 89 23 80 00       	push   $0x802389
  80029d:	e8 5e 02 00 00       	call   800500 <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a8:	83 ec 08             	sub    $0x8,%esp
  8002ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ae:	50                   	push   %eax
  8002af:	e8 e1 01 00 00       	call   800495 <vcprintf>
  8002b4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002b7:	83 ec 08             	sub    $0x8,%esp
  8002ba:	6a 00                	push   $0x0
  8002bc:	68 a5 23 80 00       	push   $0x8023a5
  8002c1:	e8 cf 01 00 00       	call   800495 <vcprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002c9:	e8 82 ff ff ff       	call   800250 <exit>

	// should not return here
	while (1) ;
  8002ce:	eb fe                	jmp    8002ce <_panic+0x70>

008002d0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002db:	8b 50 74             	mov    0x74(%eax),%edx
  8002de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e1:	39 c2                	cmp    %eax,%edx
  8002e3:	74 14                	je     8002f9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002e5:	83 ec 04             	sub    $0x4,%esp
  8002e8:	68 a8 23 80 00       	push   $0x8023a8
  8002ed:	6a 26                	push   $0x26
  8002ef:	68 f4 23 80 00       	push   $0x8023f4
  8002f4:	e8 65 ff ff ff       	call   80025e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800300:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800307:	e9 b6 00 00 00       	jmp    8003c2 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80030c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800316:	8b 45 08             	mov    0x8(%ebp),%eax
  800319:	01 d0                	add    %edx,%eax
  80031b:	8b 00                	mov    (%eax),%eax
  80031d:	85 c0                	test   %eax,%eax
  80031f:	75 08                	jne    800329 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800321:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800324:	e9 96 00 00 00       	jmp    8003bf <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800329:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800330:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800337:	eb 5d                	jmp    800396 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800339:	a1 20 30 80 00       	mov    0x803020,%eax
  80033e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800344:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800347:	c1 e2 04             	shl    $0x4,%edx
  80034a:	01 d0                	add    %edx,%eax
  80034c:	8a 40 04             	mov    0x4(%eax),%al
  80034f:	84 c0                	test   %al,%al
  800351:	75 40                	jne    800393 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800353:	a1 20 30 80 00       	mov    0x803020,%eax
  800358:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80035e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800361:	c1 e2 04             	shl    $0x4,%edx
  800364:	01 d0                	add    %edx,%eax
  800366:	8b 00                	mov    (%eax),%eax
  800368:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80036b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80036e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800373:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800378:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80037f:	8b 45 08             	mov    0x8(%ebp),%eax
  800382:	01 c8                	add    %ecx,%eax
  800384:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800386:	39 c2                	cmp    %eax,%edx
  800388:	75 09                	jne    800393 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  80038a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800391:	eb 12                	jmp    8003a5 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800393:	ff 45 e8             	incl   -0x18(%ebp)
  800396:	a1 20 30 80 00       	mov    0x803020,%eax
  80039b:	8b 50 74             	mov    0x74(%eax),%edx
  80039e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	77 94                	ja     800339 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003a9:	75 14                	jne    8003bf <CheckWSWithoutLastIndex+0xef>
			panic(
  8003ab:	83 ec 04             	sub    $0x4,%esp
  8003ae:	68 00 24 80 00       	push   $0x802400
  8003b3:	6a 3a                	push   $0x3a
  8003b5:	68 f4 23 80 00       	push   $0x8023f4
  8003ba:	e8 9f fe ff ff       	call   80025e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003bf:	ff 45 f0             	incl   -0x10(%ebp)
  8003c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003c8:	0f 8c 3e ff ff ff    	jl     80030c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003dc:	eb 20                	jmp    8003fe <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003de:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e3:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ec:	c1 e2 04             	shl    $0x4,%edx
  8003ef:	01 d0                	add    %edx,%eax
  8003f1:	8a 40 04             	mov    0x4(%eax),%al
  8003f4:	3c 01                	cmp    $0x1,%al
  8003f6:	75 03                	jne    8003fb <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8003f8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fb:	ff 45 e0             	incl   -0x20(%ebp)
  8003fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800403:	8b 50 74             	mov    0x74(%eax),%edx
  800406:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800409:	39 c2                	cmp    %eax,%edx
  80040b:	77 d1                	ja     8003de <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80040d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800410:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800413:	74 14                	je     800429 <CheckWSWithoutLastIndex+0x159>
		panic(
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	68 54 24 80 00       	push   $0x802454
  80041d:	6a 44                	push   $0x44
  80041f:	68 f4 23 80 00       	push   $0x8023f4
  800424:	e8 35 fe ff ff       	call   80025e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800429:	90                   	nop
  80042a:	c9                   	leave  
  80042b:	c3                   	ret    

0080042c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800432:	8b 45 0c             	mov    0xc(%ebp),%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	8d 48 01             	lea    0x1(%eax),%ecx
  80043a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80043d:	89 0a                	mov    %ecx,(%edx)
  80043f:	8b 55 08             	mov    0x8(%ebp),%edx
  800442:	88 d1                	mov    %dl,%cl
  800444:	8b 55 0c             	mov    0xc(%ebp),%edx
  800447:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80044b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	3d ff 00 00 00       	cmp    $0xff,%eax
  800455:	75 2c                	jne    800483 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800457:	a0 24 30 80 00       	mov    0x803024,%al
  80045c:	0f b6 c0             	movzbl %al,%eax
  80045f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800462:	8b 12                	mov    (%edx),%edx
  800464:	89 d1                	mov    %edx,%ecx
  800466:	8b 55 0c             	mov    0xc(%ebp),%edx
  800469:	83 c2 08             	add    $0x8,%edx
  80046c:	83 ec 04             	sub    $0x4,%esp
  80046f:	50                   	push   %eax
  800470:	51                   	push   %ecx
  800471:	52                   	push   %edx
  800472:	e8 a9 14 00 00       	call   801920 <sys_cputs>
  800477:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80047a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800483:	8b 45 0c             	mov    0xc(%ebp),%eax
  800486:	8b 40 04             	mov    0x4(%eax),%eax
  800489:	8d 50 01             	lea    0x1(%eax),%edx
  80048c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800492:	90                   	nop
  800493:	c9                   	leave  
  800494:	c3                   	ret    

00800495 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800495:	55                   	push   %ebp
  800496:	89 e5                	mov    %esp,%ebp
  800498:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80049e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004a5:	00 00 00 
	b.cnt = 0;
  8004a8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004af:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004b2:	ff 75 0c             	pushl  0xc(%ebp)
  8004b5:	ff 75 08             	pushl  0x8(%ebp)
  8004b8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004be:	50                   	push   %eax
  8004bf:	68 2c 04 80 00       	push   $0x80042c
  8004c4:	e8 11 02 00 00       	call   8006da <vprintfmt>
  8004c9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004cc:	a0 24 30 80 00       	mov    0x803024,%al
  8004d1:	0f b6 c0             	movzbl %al,%eax
  8004d4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	50                   	push   %eax
  8004de:	52                   	push   %edx
  8004df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e5:	83 c0 08             	add    $0x8,%eax
  8004e8:	50                   	push   %eax
  8004e9:	e8 32 14 00 00       	call   801920 <sys_cputs>
  8004ee:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004f1:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8004f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004fe:	c9                   	leave  
  8004ff:	c3                   	ret    

00800500 <cprintf>:

int cprintf(const char *fmt, ...) {
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800506:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80050d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800510:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800513:	8b 45 08             	mov    0x8(%ebp),%eax
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	ff 75 f4             	pushl  -0xc(%ebp)
  80051c:	50                   	push   %eax
  80051d:	e8 73 ff ff ff       	call   800495 <vcprintf>
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800528:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800533:	e8 f9 15 00 00       	call   801b31 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800538:	8d 45 0c             	lea    0xc(%ebp),%eax
  80053b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 f4             	pushl  -0xc(%ebp)
  800547:	50                   	push   %eax
  800548:	e8 48 ff ff ff       	call   800495 <vcprintf>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800553:	e8 f3 15 00 00       	call   801b4b <sys_enable_interrupt>
	return cnt;
  800558:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055b:	c9                   	leave  
  80055c:	c3                   	ret    

0080055d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80055d:	55                   	push   %ebp
  80055e:	89 e5                	mov    %esp,%ebp
  800560:	53                   	push   %ebx
  800561:	83 ec 14             	sub    $0x14,%esp
  800564:	8b 45 10             	mov    0x10(%ebp),%eax
  800567:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800570:	8b 45 18             	mov    0x18(%ebp),%eax
  800573:	ba 00 00 00 00       	mov    $0x0,%edx
  800578:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80057b:	77 55                	ja     8005d2 <printnum+0x75>
  80057d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800580:	72 05                	jb     800587 <printnum+0x2a>
  800582:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800585:	77 4b                	ja     8005d2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800587:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80058a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80058d:	8b 45 18             	mov    0x18(%ebp),%eax
  800590:	ba 00 00 00 00       	mov    $0x0,%edx
  800595:	52                   	push   %edx
  800596:	50                   	push   %eax
  800597:	ff 75 f4             	pushl  -0xc(%ebp)
  80059a:	ff 75 f0             	pushl  -0x10(%ebp)
  80059d:	e8 b2 19 00 00       	call   801f54 <__udivdi3>
  8005a2:	83 c4 10             	add    $0x10,%esp
  8005a5:	83 ec 04             	sub    $0x4,%esp
  8005a8:	ff 75 20             	pushl  0x20(%ebp)
  8005ab:	53                   	push   %ebx
  8005ac:	ff 75 18             	pushl  0x18(%ebp)
  8005af:	52                   	push   %edx
  8005b0:	50                   	push   %eax
  8005b1:	ff 75 0c             	pushl  0xc(%ebp)
  8005b4:	ff 75 08             	pushl  0x8(%ebp)
  8005b7:	e8 a1 ff ff ff       	call   80055d <printnum>
  8005bc:	83 c4 20             	add    $0x20,%esp
  8005bf:	eb 1a                	jmp    8005db <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	ff 75 0c             	pushl  0xc(%ebp)
  8005c7:	ff 75 20             	pushl  0x20(%ebp)
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	ff d0                	call   *%eax
  8005cf:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005d2:	ff 4d 1c             	decl   0x1c(%ebp)
  8005d5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005d9:	7f e6                	jg     8005c1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005db:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005e9:	53                   	push   %ebx
  8005ea:	51                   	push   %ecx
  8005eb:	52                   	push   %edx
  8005ec:	50                   	push   %eax
  8005ed:	e8 72 1a 00 00       	call   802064 <__umoddi3>
  8005f2:	83 c4 10             	add    $0x10,%esp
  8005f5:	05 b4 26 80 00       	add    $0x8026b4,%eax
  8005fa:	8a 00                	mov    (%eax),%al
  8005fc:	0f be c0             	movsbl %al,%eax
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 0c             	pushl  0xc(%ebp)
  800605:	50                   	push   %eax
  800606:	8b 45 08             	mov    0x8(%ebp),%eax
  800609:	ff d0                	call   *%eax
  80060b:	83 c4 10             	add    $0x10,%esp
}
  80060e:	90                   	nop
  80060f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800612:	c9                   	leave  
  800613:	c3                   	ret    

00800614 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800617:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80061b:	7e 1c                	jle    800639 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80061d:	8b 45 08             	mov    0x8(%ebp),%eax
  800620:	8b 00                	mov    (%eax),%eax
  800622:	8d 50 08             	lea    0x8(%eax),%edx
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	89 10                	mov    %edx,(%eax)
  80062a:	8b 45 08             	mov    0x8(%ebp),%eax
  80062d:	8b 00                	mov    (%eax),%eax
  80062f:	83 e8 08             	sub    $0x8,%eax
  800632:	8b 50 04             	mov    0x4(%eax),%edx
  800635:	8b 00                	mov    (%eax),%eax
  800637:	eb 40                	jmp    800679 <getuint+0x65>
	else if (lflag)
  800639:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80063d:	74 1e                	je     80065d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	8b 00                	mov    (%eax),%eax
  800644:	8d 50 04             	lea    0x4(%eax),%edx
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	89 10                	mov    %edx,(%eax)
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	83 e8 04             	sub    $0x4,%eax
  800654:	8b 00                	mov    (%eax),%eax
  800656:	ba 00 00 00 00       	mov    $0x0,%edx
  80065b:	eb 1c                	jmp    800679 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	8d 50 04             	lea    0x4(%eax),%edx
  800665:	8b 45 08             	mov    0x8(%ebp),%eax
  800668:	89 10                	mov    %edx,(%eax)
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	83 e8 04             	sub    $0x4,%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800679:	5d                   	pop    %ebp
  80067a:	c3                   	ret    

0080067b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80067b:	55                   	push   %ebp
  80067c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800682:	7e 1c                	jle    8006a0 <getint+0x25>
		return va_arg(*ap, long long);
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	8d 50 08             	lea    0x8(%eax),%edx
  80068c:	8b 45 08             	mov    0x8(%ebp),%eax
  80068f:	89 10                	mov    %edx,(%eax)
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	8b 00                	mov    (%eax),%eax
  800696:	83 e8 08             	sub    $0x8,%eax
  800699:	8b 50 04             	mov    0x4(%eax),%edx
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	eb 38                	jmp    8006d8 <getint+0x5d>
	else if (lflag)
  8006a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a4:	74 1a                	je     8006c0 <getint+0x45>
		return va_arg(*ap, long);
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	8d 50 04             	lea    0x4(%eax),%edx
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	89 10                	mov    %edx,(%eax)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	83 e8 04             	sub    $0x4,%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	99                   	cltd   
  8006be:	eb 18                	jmp    8006d8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	8d 50 04             	lea    0x4(%eax),%edx
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	89 10                	mov    %edx,(%eax)
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	83 e8 04             	sub    $0x4,%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	99                   	cltd   
}
  8006d8:	5d                   	pop    %ebp
  8006d9:	c3                   	ret    

008006da <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006da:	55                   	push   %ebp
  8006db:	89 e5                	mov    %esp,%ebp
  8006dd:	56                   	push   %esi
  8006de:	53                   	push   %ebx
  8006df:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e2:	eb 17                	jmp    8006fb <vprintfmt+0x21>
			if (ch == '\0')
  8006e4:	85 db                	test   %ebx,%ebx
  8006e6:	0f 84 af 03 00 00    	je     800a9b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	ff 75 0c             	pushl  0xc(%ebp)
  8006f2:	53                   	push   %ebx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	ff d0                	call   *%eax
  8006f8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8006fe:	8d 50 01             	lea    0x1(%eax),%edx
  800701:	89 55 10             	mov    %edx,0x10(%ebp)
  800704:	8a 00                	mov    (%eax),%al
  800706:	0f b6 d8             	movzbl %al,%ebx
  800709:	83 fb 25             	cmp    $0x25,%ebx
  80070c:	75 d6                	jne    8006e4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80070e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800712:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800719:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800720:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800727:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80072e:	8b 45 10             	mov    0x10(%ebp),%eax
  800731:	8d 50 01             	lea    0x1(%eax),%edx
  800734:	89 55 10             	mov    %edx,0x10(%ebp)
  800737:	8a 00                	mov    (%eax),%al
  800739:	0f b6 d8             	movzbl %al,%ebx
  80073c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80073f:	83 f8 55             	cmp    $0x55,%eax
  800742:	0f 87 2b 03 00 00    	ja     800a73 <vprintfmt+0x399>
  800748:	8b 04 85 d8 26 80 00 	mov    0x8026d8(,%eax,4),%eax
  80074f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800751:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800755:	eb d7                	jmp    80072e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800757:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80075b:	eb d1                	jmp    80072e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80075d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800764:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800767:	89 d0                	mov    %edx,%eax
  800769:	c1 e0 02             	shl    $0x2,%eax
  80076c:	01 d0                	add    %edx,%eax
  80076e:	01 c0                	add    %eax,%eax
  800770:	01 d8                	add    %ebx,%eax
  800772:	83 e8 30             	sub    $0x30,%eax
  800775:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800778:	8b 45 10             	mov    0x10(%ebp),%eax
  80077b:	8a 00                	mov    (%eax),%al
  80077d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800780:	83 fb 2f             	cmp    $0x2f,%ebx
  800783:	7e 3e                	jle    8007c3 <vprintfmt+0xe9>
  800785:	83 fb 39             	cmp    $0x39,%ebx
  800788:	7f 39                	jg     8007c3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80078a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80078d:	eb d5                	jmp    800764 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	83 c0 04             	add    $0x4,%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	83 e8 04             	sub    $0x4,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007a3:	eb 1f                	jmp    8007c4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a9:	79 83                	jns    80072e <vprintfmt+0x54>
				width = 0;
  8007ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007b2:	e9 77 ff ff ff       	jmp    80072e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007b7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007be:	e9 6b ff ff ff       	jmp    80072e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007c3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c8:	0f 89 60 ff ff ff    	jns    80072e <vprintfmt+0x54>
				width = precision, precision = -1;
  8007ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007db:	e9 4e ff ff ff       	jmp    80072e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007e0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007e3:	e9 46 ff ff ff       	jmp    80072e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	83 c0 04             	add    $0x4,%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	83 e8 04             	sub    $0x4,%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	ff 75 0c             	pushl  0xc(%ebp)
  8007ff:	50                   	push   %eax
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	ff d0                	call   *%eax
  800805:	83 c4 10             	add    $0x10,%esp
			break;
  800808:	e9 89 02 00 00       	jmp    800a96 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	83 c0 04             	add    $0x4,%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	83 e8 04             	sub    $0x4,%eax
  80081c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80081e:	85 db                	test   %ebx,%ebx
  800820:	79 02                	jns    800824 <vprintfmt+0x14a>
				err = -err;
  800822:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800824:	83 fb 64             	cmp    $0x64,%ebx
  800827:	7f 0b                	jg     800834 <vprintfmt+0x15a>
  800829:	8b 34 9d 20 25 80 00 	mov    0x802520(,%ebx,4),%esi
  800830:	85 f6                	test   %esi,%esi
  800832:	75 19                	jne    80084d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800834:	53                   	push   %ebx
  800835:	68 c5 26 80 00       	push   $0x8026c5
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	ff 75 08             	pushl  0x8(%ebp)
  800840:	e8 5e 02 00 00       	call   800aa3 <printfmt>
  800845:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800848:	e9 49 02 00 00       	jmp    800a96 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80084d:	56                   	push   %esi
  80084e:	68 ce 26 80 00       	push   $0x8026ce
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	ff 75 08             	pushl  0x8(%ebp)
  800859:	e8 45 02 00 00       	call   800aa3 <printfmt>
  80085e:	83 c4 10             	add    $0x10,%esp
			break;
  800861:	e9 30 02 00 00       	jmp    800a96 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	83 c0 04             	add    $0x4,%eax
  80086c:	89 45 14             	mov    %eax,0x14(%ebp)
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	83 e8 04             	sub    $0x4,%eax
  800875:	8b 30                	mov    (%eax),%esi
  800877:	85 f6                	test   %esi,%esi
  800879:	75 05                	jne    800880 <vprintfmt+0x1a6>
				p = "(null)";
  80087b:	be d1 26 80 00       	mov    $0x8026d1,%esi
			if (width > 0 && padc != '-')
  800880:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800884:	7e 6d                	jle    8008f3 <vprintfmt+0x219>
  800886:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80088a:	74 67                	je     8008f3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80088c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	50                   	push   %eax
  800893:	56                   	push   %esi
  800894:	e8 0c 03 00 00       	call   800ba5 <strnlen>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80089f:	eb 16                	jmp    8008b7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008a1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b4:	ff 4d e4             	decl   -0x1c(%ebp)
  8008b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008bb:	7f e4                	jg     8008a1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008bd:	eb 34                	jmp    8008f3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008c3:	74 1c                	je     8008e1 <vprintfmt+0x207>
  8008c5:	83 fb 1f             	cmp    $0x1f,%ebx
  8008c8:	7e 05                	jle    8008cf <vprintfmt+0x1f5>
  8008ca:	83 fb 7e             	cmp    $0x7e,%ebx
  8008cd:	7e 12                	jle    8008e1 <vprintfmt+0x207>
					putch('?', putdat);
  8008cf:	83 ec 08             	sub    $0x8,%esp
  8008d2:	ff 75 0c             	pushl  0xc(%ebp)
  8008d5:	6a 3f                	push   $0x3f
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	ff d0                	call   *%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
  8008df:	eb 0f                	jmp    8008f0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	ff 75 0c             	pushl  0xc(%ebp)
  8008e7:	53                   	push   %ebx
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	ff d0                	call   *%eax
  8008ed:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f0:	ff 4d e4             	decl   -0x1c(%ebp)
  8008f3:	89 f0                	mov    %esi,%eax
  8008f5:	8d 70 01             	lea    0x1(%eax),%esi
  8008f8:	8a 00                	mov    (%eax),%al
  8008fa:	0f be d8             	movsbl %al,%ebx
  8008fd:	85 db                	test   %ebx,%ebx
  8008ff:	74 24                	je     800925 <vprintfmt+0x24b>
  800901:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800905:	78 b8                	js     8008bf <vprintfmt+0x1e5>
  800907:	ff 4d e0             	decl   -0x20(%ebp)
  80090a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80090e:	79 af                	jns    8008bf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800910:	eb 13                	jmp    800925 <vprintfmt+0x24b>
				putch(' ', putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	6a 20                	push   $0x20
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	ff d0                	call   *%eax
  80091f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800922:	ff 4d e4             	decl   -0x1c(%ebp)
  800925:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800929:	7f e7                	jg     800912 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80092b:	e9 66 01 00 00       	jmp    800a96 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	ff 75 e8             	pushl  -0x18(%ebp)
  800936:	8d 45 14             	lea    0x14(%ebp),%eax
  800939:	50                   	push   %eax
  80093a:	e8 3c fd ff ff       	call   80067b <getint>
  80093f:	83 c4 10             	add    $0x10,%esp
  800942:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800945:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800948:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80094e:	85 d2                	test   %edx,%edx
  800950:	79 23                	jns    800975 <vprintfmt+0x29b>
				putch('-', putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	6a 2d                	push   $0x2d
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	ff d0                	call   *%eax
  80095f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800965:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800968:	f7 d8                	neg    %eax
  80096a:	83 d2 00             	adc    $0x0,%edx
  80096d:	f7 da                	neg    %edx
  80096f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800972:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800975:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80097c:	e9 bc 00 00 00       	jmp    800a3d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	ff 75 e8             	pushl  -0x18(%ebp)
  800987:	8d 45 14             	lea    0x14(%ebp),%eax
  80098a:	50                   	push   %eax
  80098b:	e8 84 fc ff ff       	call   800614 <getuint>
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800999:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a0:	e9 98 00 00 00       	jmp    800a3d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009a5:	83 ec 08             	sub    $0x8,%esp
  8009a8:	ff 75 0c             	pushl  0xc(%ebp)
  8009ab:	6a 58                	push   $0x58
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	ff d0                	call   *%eax
  8009b2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 0c             	pushl  0xc(%ebp)
  8009bb:	6a 58                	push   $0x58
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	ff d0                	call   *%eax
  8009c2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	6a 58                	push   $0x58
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	ff d0                	call   *%eax
  8009d2:	83 c4 10             	add    $0x10,%esp
			break;
  8009d5:	e9 bc 00 00 00       	jmp    800a96 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	6a 30                	push   $0x30
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
  8009e7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 78                	push   $0x78
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8009fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fd:	83 c0 04             	add    $0x4,%eax
  800a00:	89 45 14             	mov    %eax,0x14(%ebp)
  800a03:	8b 45 14             	mov    0x14(%ebp),%eax
  800a06:	83 e8 04             	sub    $0x4,%eax
  800a09:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a15:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a1c:	eb 1f                	jmp    800a3d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 e8             	pushl  -0x18(%ebp)
  800a24:	8d 45 14             	lea    0x14(%ebp),%eax
  800a27:	50                   	push   %eax
  800a28:	e8 e7 fb ff ff       	call   800614 <getuint>
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a36:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a3d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a44:	83 ec 04             	sub    $0x4,%esp
  800a47:	52                   	push   %edx
  800a48:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a4b:	50                   	push   %eax
  800a4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a4f:	ff 75 f0             	pushl  -0x10(%ebp)
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	ff 75 08             	pushl  0x8(%ebp)
  800a58:	e8 00 fb ff ff       	call   80055d <printnum>
  800a5d:	83 c4 20             	add    $0x20,%esp
			break;
  800a60:	eb 34                	jmp    800a96 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	53                   	push   %ebx
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	ff d0                	call   *%eax
  800a6e:	83 c4 10             	add    $0x10,%esp
			break;
  800a71:	eb 23                	jmp    800a96 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	6a 25                	push   $0x25
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	ff d0                	call   *%eax
  800a80:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a83:	ff 4d 10             	decl   0x10(%ebp)
  800a86:	eb 03                	jmp    800a8b <vprintfmt+0x3b1>
  800a88:	ff 4d 10             	decl   0x10(%ebp)
  800a8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a8e:	48                   	dec    %eax
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	3c 25                	cmp    $0x25,%al
  800a93:	75 f3                	jne    800a88 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800a95:	90                   	nop
		}
	}
  800a96:	e9 47 fc ff ff       	jmp    8006e2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a9b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a9f:	5b                   	pop    %ebx
  800aa0:	5e                   	pop    %esi
  800aa1:	5d                   	pop    %ebp
  800aa2:	c3                   	ret    

00800aa3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aa9:	8d 45 10             	lea    0x10(%ebp),%eax
  800aac:	83 c0 04             	add    $0x4,%eax
  800aaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ab2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab8:	50                   	push   %eax
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	ff 75 08             	pushl  0x8(%ebp)
  800abf:	e8 16 fc ff ff       	call   8006da <vprintfmt>
  800ac4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ac7:	90                   	nop
  800ac8:	c9                   	leave  
  800ac9:	c3                   	ret    

00800aca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800acd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad0:	8b 40 08             	mov    0x8(%eax),%eax
  800ad3:	8d 50 01             	lea    0x1(%eax),%edx
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	8b 10                	mov    (%eax),%edx
  800ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae4:	8b 40 04             	mov    0x4(%eax),%eax
  800ae7:	39 c2                	cmp    %eax,%edx
  800ae9:	73 12                	jae    800afd <sprintputch+0x33>
		*b->buf++ = ch;
  800aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	8d 48 01             	lea    0x1(%eax),%ecx
  800af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af6:	89 0a                	mov    %ecx,(%edx)
  800af8:	8b 55 08             	mov    0x8(%ebp),%edx
  800afb:	88 10                	mov    %dl,(%eax)
}
  800afd:	90                   	nop
  800afe:	5d                   	pop    %ebp
  800aff:	c3                   	ret    

00800b00 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	01 d0                	add    %edx,%eax
  800b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b25:	74 06                	je     800b2d <vsnprintf+0x2d>
  800b27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b2b:	7f 07                	jg     800b34 <vsnprintf+0x34>
		return -E_INVAL;
  800b2d:	b8 03 00 00 00       	mov    $0x3,%eax
  800b32:	eb 20                	jmp    800b54 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b34:	ff 75 14             	pushl  0x14(%ebp)
  800b37:	ff 75 10             	pushl  0x10(%ebp)
  800b3a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b3d:	50                   	push   %eax
  800b3e:	68 ca 0a 80 00       	push   $0x800aca
  800b43:	e8 92 fb ff ff       	call   8006da <vprintfmt>
  800b48:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b4e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b54:	c9                   	leave  
  800b55:	c3                   	ret    

00800b56 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b5c:	8d 45 10             	lea    0x10(%ebp),%eax
  800b5f:	83 c0 04             	add    $0x4,%eax
  800b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b65:	8b 45 10             	mov    0x10(%ebp),%eax
  800b68:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6b:	50                   	push   %eax
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	ff 75 08             	pushl  0x8(%ebp)
  800b72:	e8 89 ff ff ff       	call   800b00 <vsnprintf>
  800b77:	83 c4 10             	add    $0x10,%esp
  800b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b8f:	eb 06                	jmp    800b97 <strlen+0x15>
		n++;
  800b91:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b94:	ff 45 08             	incl   0x8(%ebp)
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8a 00                	mov    (%eax),%al
  800b9c:	84 c0                	test   %al,%al
  800b9e:	75 f1                	jne    800b91 <strlen+0xf>
		n++;
	return n;
  800ba0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    

00800ba5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb2:	eb 09                	jmp    800bbd <strnlen+0x18>
		n++;
  800bb4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb7:	ff 45 08             	incl   0x8(%ebp)
  800bba:	ff 4d 0c             	decl   0xc(%ebp)
  800bbd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc1:	74 09                	je     800bcc <strnlen+0x27>
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	8a 00                	mov    (%eax),%al
  800bc8:	84 c0                	test   %al,%al
  800bca:	75 e8                	jne    800bb4 <strnlen+0xf>
		n++;
	return n;
  800bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bdd:	90                   	nop
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8d 50 01             	lea    0x1(%eax),%edx
  800be4:	89 55 08             	mov    %edx,0x8(%ebp)
  800be7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bf0:	8a 12                	mov    (%edx),%dl
  800bf2:	88 10                	mov    %dl,(%eax)
  800bf4:	8a 00                	mov    (%eax),%al
  800bf6:	84 c0                	test   %al,%al
  800bf8:	75 e4                	jne    800bde <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfd:	c9                   	leave  
  800bfe:	c3                   	ret    

00800bff <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c12:	eb 1f                	jmp    800c33 <strncpy+0x34>
		*dst++ = *src;
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c20:	8a 12                	mov    (%edx),%dl
  800c22:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	74 03                	je     800c30 <strncpy+0x31>
			src++;
  800c2d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c30:	ff 45 fc             	incl   -0x4(%ebp)
  800c33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c36:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c39:	72 d9                	jb     800c14 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c3e:	c9                   	leave  
  800c3f:	c3                   	ret    

00800c40 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c50:	74 30                	je     800c82 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c52:	eb 16                	jmp    800c6a <strlcpy+0x2a>
			*dst++ = *src++;
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	8d 50 01             	lea    0x1(%eax),%edx
  800c5a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c60:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c63:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c66:	8a 12                	mov    (%edx),%dl
  800c68:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c6a:	ff 4d 10             	decl   0x10(%ebp)
  800c6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c71:	74 09                	je     800c7c <strlcpy+0x3c>
  800c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 d8                	jne    800c54 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c82:	8b 55 08             	mov    0x8(%ebp),%edx
  800c85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c88:	29 c2                	sub    %eax,%edx
  800c8a:	89 d0                	mov    %edx,%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c91:	eb 06                	jmp    800c99 <strcmp+0xb>
		p++, q++;
  800c93:	ff 45 08             	incl   0x8(%ebp)
  800c96:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8a 00                	mov    (%eax),%al
  800c9e:	84 c0                	test   %al,%al
  800ca0:	74 0e                	je     800cb0 <strcmp+0x22>
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8a 10                	mov    (%eax),%dl
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	8a 00                	mov    (%eax),%al
  800cac:	38 c2                	cmp    %al,%dl
  800cae:	74 e3                	je     800c93 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8a 00                	mov    (%eax),%al
  800cb5:	0f b6 d0             	movzbl %al,%edx
  800cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	0f b6 c0             	movzbl %al,%eax
  800cc0:	29 c2                	sub    %eax,%edx
  800cc2:	89 d0                	mov    %edx,%eax
}
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cc9:	eb 09                	jmp    800cd4 <strncmp+0xe>
		n--, p++, q++;
  800ccb:	ff 4d 10             	decl   0x10(%ebp)
  800cce:	ff 45 08             	incl   0x8(%ebp)
  800cd1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd8:	74 17                	je     800cf1 <strncmp+0x2b>
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	74 0e                	je     800cf1 <strncmp+0x2b>
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 10                	mov    (%eax),%dl
  800ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	38 c2                	cmp    %al,%dl
  800cef:	74 da                	je     800ccb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cf1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf5:	75 07                	jne    800cfe <strncmp+0x38>
		return 0;
  800cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfc:	eb 14                	jmp    800d12 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 d0             	movzbl %al,%edx
  800d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	0f b6 c0             	movzbl %al,%eax
  800d0e:	29 c2                	sub    %eax,%edx
  800d10:	89 d0                	mov    %edx,%eax
}
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 04             	sub    $0x4,%esp
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d20:	eb 12                	jmp    800d34 <strchr+0x20>
		if (*s == c)
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d2a:	75 05                	jne    800d31 <strchr+0x1d>
			return (char *) s;
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	eb 11                	jmp    800d42 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d31:	ff 45 08             	incl   0x8(%ebp)
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	84 c0                	test   %al,%al
  800d3b:	75 e5                	jne    800d22 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d42:	c9                   	leave  
  800d43:	c3                   	ret    

00800d44 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	83 ec 04             	sub    $0x4,%esp
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d50:	eb 0d                	jmp    800d5f <strfind+0x1b>
		if (*s == c)
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5a:	74 0e                	je     800d6a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	75 ea                	jne    800d52 <strfind+0xe>
  800d68:	eb 01                	jmp    800d6b <strfind+0x27>
		if (*s == c)
			break;
  800d6a:	90                   	nop
	return (char *) s;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d82:	eb 0e                	jmp    800d92 <memset+0x22>
		*p++ = c;
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d87:	8d 50 01             	lea    0x1(%eax),%edx
  800d8a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d90:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d92:	ff 4d f8             	decl   -0x8(%ebp)
  800d95:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d99:	79 e9                	jns    800d84 <memset+0x14>
		*p++ = c;

	return v;
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800db2:	eb 16                	jmp    800dca <memcpy+0x2a>
		*d++ = *s++;
  800db4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db7:	8d 50 01             	lea    0x1(%eax),%edx
  800dba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dbd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dc6:	8a 12                	mov    (%edx),%dl
  800dc8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dca:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	75 dd                	jne    800db4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800df4:	73 50                	jae    800e46 <memmove+0x6a>
  800df6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfc:	01 d0                	add    %edx,%eax
  800dfe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e01:	76 43                	jbe    800e46 <memmove+0x6a>
		s += n;
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e09:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e0f:	eb 10                	jmp    800e21 <memmove+0x45>
			*--d = *--s;
  800e11:	ff 4d f8             	decl   -0x8(%ebp)
  800e14:	ff 4d fc             	decl   -0x4(%ebp)
  800e17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1a:	8a 10                	mov    (%eax),%dl
  800e1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e21:	8b 45 10             	mov    0x10(%ebp),%eax
  800e24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e27:	89 55 10             	mov    %edx,0x10(%ebp)
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	75 e3                	jne    800e11 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e2e:	eb 23                	jmp    800e53 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e33:	8d 50 01             	lea    0x1(%eax),%edx
  800e36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e42:	8a 12                	mov    (%edx),%dl
  800e44:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 dd                	jne    800e30 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e56:	c9                   	leave  
  800e57:	c3                   	ret    

00800e58 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e6a:	eb 2a                	jmp    800e96 <memcmp+0x3e>
		if (*s1 != *s2)
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6f:	8a 10                	mov    (%eax),%dl
  800e71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	38 c2                	cmp    %al,%dl
  800e78:	74 16                	je     800e90 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	0f b6 d0             	movzbl %al,%edx
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	0f b6 c0             	movzbl %al,%eax
  800e8a:	29 c2                	sub    %eax,%edx
  800e8c:	89 d0                	mov    %edx,%eax
  800e8e:	eb 18                	jmp    800ea8 <memcmp+0x50>
		s1++, s2++;
  800e90:	ff 45 fc             	incl   -0x4(%ebp)
  800e93:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e96:	8b 45 10             	mov    0x10(%ebp),%eax
  800e99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e9c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9f:	85 c0                	test   %eax,%eax
  800ea1:	75 c9                	jne    800e6c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ea3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	01 d0                	add    %edx,%eax
  800eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ebb:	eb 15                	jmp    800ed2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	0f b6 d0             	movzbl %al,%edx
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	0f b6 c0             	movzbl %al,%eax
  800ecb:	39 c2                	cmp    %eax,%edx
  800ecd:	74 0d                	je     800edc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ecf:	ff 45 08             	incl   0x8(%ebp)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ed8:	72 e3                	jb     800ebd <memfind+0x13>
  800eda:	eb 01                	jmp    800edd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800edc:	90                   	nop
	return (void *) s;
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee0:	c9                   	leave  
  800ee1:	c3                   	ret    

00800ee2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ee8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800eef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ef6:	eb 03                	jmp    800efb <strtol+0x19>
		s++;
  800ef8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	3c 20                	cmp    $0x20,%al
  800f02:	74 f4                	je     800ef8 <strtol+0x16>
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	3c 09                	cmp    $0x9,%al
  800f0b:	74 eb                	je     800ef8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	3c 2b                	cmp    $0x2b,%al
  800f14:	75 05                	jne    800f1b <strtol+0x39>
		s++;
  800f16:	ff 45 08             	incl   0x8(%ebp)
  800f19:	eb 13                	jmp    800f2e <strtol+0x4c>
	else if (*s == '-')
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3c 2d                	cmp    $0x2d,%al
  800f22:	75 0a                	jne    800f2e <strtol+0x4c>
		s++, neg = 1;
  800f24:	ff 45 08             	incl   0x8(%ebp)
  800f27:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	74 06                	je     800f3a <strtol+0x58>
  800f34:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f38:	75 20                	jne    800f5a <strtol+0x78>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 30                	cmp    $0x30,%al
  800f41:	75 17                	jne    800f5a <strtol+0x78>
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	40                   	inc    %eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	3c 78                	cmp    $0x78,%al
  800f4b:	75 0d                	jne    800f5a <strtol+0x78>
		s += 2, base = 16;
  800f4d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f51:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f58:	eb 28                	jmp    800f82 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5e:	75 15                	jne    800f75 <strtol+0x93>
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	3c 30                	cmp    $0x30,%al
  800f67:	75 0c                	jne    800f75 <strtol+0x93>
		s++, base = 8;
  800f69:	ff 45 08             	incl   0x8(%ebp)
  800f6c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f73:	eb 0d                	jmp    800f82 <strtol+0xa0>
	else if (base == 0)
  800f75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f79:	75 07                	jne    800f82 <strtol+0xa0>
		base = 10;
  800f7b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	3c 2f                	cmp    $0x2f,%al
  800f89:	7e 19                	jle    800fa4 <strtol+0xc2>
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	3c 39                	cmp    $0x39,%al
  800f92:	7f 10                	jg     800fa4 <strtol+0xc2>
			dig = *s - '0';
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	0f be c0             	movsbl %al,%eax
  800f9c:	83 e8 30             	sub    $0x30,%eax
  800f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa2:	eb 42                	jmp    800fe6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 60                	cmp    $0x60,%al
  800fab:	7e 19                	jle    800fc6 <strtol+0xe4>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 7a                	cmp    $0x7a,%al
  800fb4:	7f 10                	jg     800fc6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f be c0             	movsbl %al,%eax
  800fbe:	83 e8 57             	sub    $0x57,%eax
  800fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc4:	eb 20                	jmp    800fe6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 40                	cmp    $0x40,%al
  800fcd:	7e 39                	jle    801008 <strtol+0x126>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 5a                	cmp    $0x5a,%al
  800fd6:	7f 30                	jg     801008 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	83 e8 37             	sub    $0x37,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fec:	7d 19                	jge    801007 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ff8:	89 c2                	mov    %eax,%edx
  800ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffd:	01 d0                	add    %edx,%eax
  800fff:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801002:	e9 7b ff ff ff       	jmp    800f82 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801007:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801008:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80100c:	74 08                	je     801016 <strtol+0x134>
		*endptr = (char *) s;
  80100e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
  801014:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801016:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80101a:	74 07                	je     801023 <strtol+0x141>
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	f7 d8                	neg    %eax
  801021:	eb 03                	jmp    801026 <strtol+0x144>
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <ltostr>:

void
ltostr(long value, char *str)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801035:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80103c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801040:	79 13                	jns    801055 <ltostr+0x2d>
	{
		neg = 1;
  801042:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80104f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801052:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80105d:	99                   	cltd   
  80105e:	f7 f9                	idiv   %ecx
  801060:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801063:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801066:	8d 50 01             	lea    0x1(%eax),%edx
  801069:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80106c:	89 c2                	mov    %eax,%edx
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	01 d0                	add    %edx,%eax
  801073:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801076:	83 c2 30             	add    $0x30,%edx
  801079:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80107b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80107e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801083:	f7 e9                	imul   %ecx
  801085:	c1 fa 02             	sar    $0x2,%edx
  801088:	89 c8                	mov    %ecx,%eax
  80108a:	c1 f8 1f             	sar    $0x1f,%eax
  80108d:	29 c2                	sub    %eax,%edx
  80108f:	89 d0                	mov    %edx,%eax
  801091:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801094:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801097:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80109c:	f7 e9                	imul   %ecx
  80109e:	c1 fa 02             	sar    $0x2,%edx
  8010a1:	89 c8                	mov    %ecx,%eax
  8010a3:	c1 f8 1f             	sar    $0x1f,%eax
  8010a6:	29 c2                	sub    %eax,%edx
  8010a8:	89 d0                	mov    %edx,%eax
  8010aa:	c1 e0 02             	shl    $0x2,%eax
  8010ad:	01 d0                	add    %edx,%eax
  8010af:	01 c0                	add    %eax,%eax
  8010b1:	29 c1                	sub    %eax,%ecx
  8010b3:	89 ca                	mov    %ecx,%edx
  8010b5:	85 d2                	test   %edx,%edx
  8010b7:	75 9c                	jne    801055 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c3:	48                   	dec    %eax
  8010c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010cb:	74 3d                	je     80110a <ltostr+0xe2>
		start = 1 ;
  8010cd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010d4:	eb 34                	jmp    80110a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	01 d0                	add    %edx,%eax
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	01 c2                	add    %eax,%edx
  8010eb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c8                	add    %ecx,%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	01 c2                	add    %eax,%edx
  8010ff:	8a 45 eb             	mov    -0x15(%ebp),%al
  801102:	88 02                	mov    %al,(%edx)
		start++ ;
  801104:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801107:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80110a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801110:	7c c4                	jl     8010d6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801112:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801115:	8b 45 0c             	mov    0xc(%ebp),%eax
  801118:	01 d0                	add    %edx,%eax
  80111a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80111d:	90                   	nop
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801126:	ff 75 08             	pushl  0x8(%ebp)
  801129:	e8 54 fa ff ff       	call   800b82 <strlen>
  80112e:	83 c4 04             	add    $0x4,%esp
  801131:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801134:	ff 75 0c             	pushl  0xc(%ebp)
  801137:	e8 46 fa ff ff       	call   800b82 <strlen>
  80113c:	83 c4 04             	add    $0x4,%esp
  80113f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801142:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801149:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801150:	eb 17                	jmp    801169 <strcconcat+0x49>
		final[s] = str1[s] ;
  801152:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801155:	8b 45 10             	mov    0x10(%ebp),%eax
  801158:	01 c2                	add    %eax,%edx
  80115a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	01 c8                	add    %ecx,%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801166:	ff 45 fc             	incl   -0x4(%ebp)
  801169:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80116f:	7c e1                	jl     801152 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801171:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801178:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80117f:	eb 1f                	jmp    8011a0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801181:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801184:	8d 50 01             	lea    0x1(%eax),%edx
  801187:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	01 c2                	add    %eax,%edx
  801191:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	01 c8                	add    %ecx,%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80119d:	ff 45 f8             	incl   -0x8(%ebp)
  8011a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011a6:	7c d9                	jl     801181 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ae:	01 d0                	add    %edx,%eax
  8011b0:	c6 00 00             	movb   $0x0,(%eax)
}
  8011b3:	90                   	nop
  8011b4:	c9                   	leave  
  8011b5:	c3                   	ret    

008011b6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c5:	8b 00                	mov    (%eax),%eax
  8011c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d1:	01 d0                	add    %edx,%eax
  8011d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d9:	eb 0c                	jmp    8011e7 <strsplit+0x31>
			*string++ = 0;
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8d 50 01             	lea    0x1(%eax),%edx
  8011e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8011e4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 18                	je     801208 <strsplit+0x52>
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	0f be c0             	movsbl %al,%eax
  8011f8:	50                   	push   %eax
  8011f9:	ff 75 0c             	pushl  0xc(%ebp)
  8011fc:	e8 13 fb ff ff       	call   800d14 <strchr>
  801201:	83 c4 08             	add    $0x8,%esp
  801204:	85 c0                	test   %eax,%eax
  801206:	75 d3                	jne    8011db <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	84 c0                	test   %al,%al
  80120f:	74 5a                	je     80126b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801211:	8b 45 14             	mov    0x14(%ebp),%eax
  801214:	8b 00                	mov    (%eax),%eax
  801216:	83 f8 0f             	cmp    $0xf,%eax
  801219:	75 07                	jne    801222 <strsplit+0x6c>
		{
			return 0;
  80121b:	b8 00 00 00 00       	mov    $0x0,%eax
  801220:	eb 66                	jmp    801288 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801222:	8b 45 14             	mov    0x14(%ebp),%eax
  801225:	8b 00                	mov    (%eax),%eax
  801227:	8d 48 01             	lea    0x1(%eax),%ecx
  80122a:	8b 55 14             	mov    0x14(%ebp),%edx
  80122d:	89 0a                	mov    %ecx,(%edx)
  80122f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801236:	8b 45 10             	mov    0x10(%ebp),%eax
  801239:	01 c2                	add    %eax,%edx
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801240:	eb 03                	jmp    801245 <strsplit+0x8f>
			string++;
  801242:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	84 c0                	test   %al,%al
  80124c:	74 8b                	je     8011d9 <strsplit+0x23>
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	0f be c0             	movsbl %al,%eax
  801256:	50                   	push   %eax
  801257:	ff 75 0c             	pushl  0xc(%ebp)
  80125a:	e8 b5 fa ff ff       	call   800d14 <strchr>
  80125f:	83 c4 08             	add    $0x8,%esp
  801262:	85 c0                	test   %eax,%eax
  801264:	74 dc                	je     801242 <strsplit+0x8c>
			string++;
	}
  801266:	e9 6e ff ff ff       	jmp    8011d9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80126b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	8b 00                	mov    (%eax),%eax
  801271:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801278:	8b 45 10             	mov    0x10(%ebp),%eax
  80127b:	01 d0                	add    %edx,%eax
  80127d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801283:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801290:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801297:	8b 55 08             	mov    0x8(%ebp),%edx
  80129a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80129d:	01 d0                	add    %edx,%eax
  80129f:	48                   	dec    %eax
  8012a0:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8012a3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8012a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ab:	f7 75 ac             	divl   -0x54(%ebp)
  8012ae:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8012b1:	29 d0                	sub    %edx,%eax
  8012b3:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8012b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8012bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8012c4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8012cb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8012d2:	eb 3f                	jmp    801313 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8012d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012d7:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8012de:	83 ec 04             	sub    $0x4,%esp
  8012e1:	50                   	push   %eax
  8012e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8012e5:	68 30 28 80 00       	push   $0x802830
  8012ea:	e8 11 f2 ff ff       	call   800500 <cprintf>
  8012ef:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  8012f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012f5:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8012fc:	83 ec 04             	sub    $0x4,%esp
  8012ff:	50                   	push   %eax
  801300:	ff 75 e8             	pushl  -0x18(%ebp)
  801303:	68 45 28 80 00       	push   $0x802845
  801308:	e8 f3 f1 ff ff       	call   800500 <cprintf>
  80130d:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801310:	ff 45 e8             	incl   -0x18(%ebp)
  801313:	a1 28 30 80 00       	mov    0x803028,%eax
  801318:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80131b:	7c b7                	jl     8012d4 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  80131d:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801324:	e9 42 01 00 00       	jmp    80146b <malloc+0x1e1>
		int flag0=1;
  801329:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801330:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801333:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801336:	eb 6b                	jmp    8013a3 <malloc+0x119>
			for(int k=0;k<count;k++){
  801338:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80133f:	eb 42                	jmp    801383 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801341:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801344:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80134b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80134e:	39 c2                	cmp    %eax,%edx
  801350:	77 2e                	ja     801380 <malloc+0xf6>
  801352:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801355:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80135c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80135f:	39 c2                	cmp    %eax,%edx
  801361:	76 1d                	jbe    801380 <malloc+0xf6>
					ni=arr_add[k].end-i;
  801363:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801366:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80136d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801370:	29 c2                	sub    %eax,%edx
  801372:	89 d0                	mov    %edx,%eax
  801374:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801377:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  80137e:	eb 0d                	jmp    80138d <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801380:	ff 45 d8             	incl   -0x28(%ebp)
  801383:	a1 28 30 80 00       	mov    0x803028,%eax
  801388:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80138b:	7c b4                	jl     801341 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  80138d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801391:	74 09                	je     80139c <malloc+0x112>
				flag0=0;
  801393:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  80139a:	eb 16                	jmp    8013b2 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  80139c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8013a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	01 c2                	add    %eax,%edx
  8013ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013ae:	39 c2                	cmp    %eax,%edx
  8013b0:	77 86                	ja     801338 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8013b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013b6:	0f 84 a2 00 00 00    	je     80145e <malloc+0x1d4>

			int f=1;
  8013bc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  8013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013c6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8013c9:	89 c8                	mov    %ecx,%eax
  8013cb:	01 c0                	add    %eax,%eax
  8013cd:	01 c8                	add    %ecx,%eax
  8013cf:	c1 e0 02             	shl    $0x2,%eax
  8013d2:	05 20 31 80 00       	add    $0x803120,%eax
  8013d7:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  8013d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8013e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e5:	89 d0                	mov    %edx,%eax
  8013e7:	01 c0                	add    %eax,%eax
  8013e9:	01 d0                	add    %edx,%eax
  8013eb:	c1 e0 02             	shl    $0x2,%eax
  8013ee:	05 24 31 80 00       	add    $0x803124,%eax
  8013f3:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  8013f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f8:	89 d0                	mov    %edx,%eax
  8013fa:	01 c0                	add    %eax,%eax
  8013fc:	01 d0                	add    %edx,%eax
  8013fe:	c1 e0 02             	shl    $0x2,%eax
  801401:	05 28 31 80 00       	add    $0x803128,%eax
  801406:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  80140c:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  80140f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801416:	eb 36                	jmp    80144e <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801418:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	01 c2                	add    %eax,%edx
  801420:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801423:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80142a:	39 c2                	cmp    %eax,%edx
  80142c:	73 1d                	jae    80144b <malloc+0x1c1>
					ni=arr_add[l].end-i;
  80142e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801431:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801438:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80143b:	29 c2                	sub    %eax,%edx
  80143d:	89 d0                	mov    %edx,%eax
  80143f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801442:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801449:	eb 0d                	jmp    801458 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  80144b:	ff 45 d0             	incl   -0x30(%ebp)
  80144e:	a1 28 30 80 00       	mov    0x803028,%eax
  801453:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801456:	7c c0                	jl     801418 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801458:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80145c:	75 1d                	jne    80147b <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  80145e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801465:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801468:	01 45 e4             	add    %eax,-0x1c(%ebp)
  80146b:	a1 04 30 80 00       	mov    0x803004,%eax
  801470:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801473:	0f 8c b0 fe ff ff    	jl     801329 <malloc+0x9f>
  801479:	eb 01                	jmp    80147c <malloc+0x1f2>

				}
			}

			if(f){
				break;
  80147b:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  80147c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801480:	75 7a                	jne    8014fc <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801482:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	01 d0                	add    %edx,%eax
  80148d:	48                   	dec    %eax
  80148e:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801493:	7c 0a                	jl     80149f <malloc+0x215>
			return NULL;
  801495:	b8 00 00 00 00       	mov    $0x0,%eax
  80149a:	e9 a4 02 00 00       	jmp    801743 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  80149f:	a1 04 30 80 00       	mov    0x803004,%eax
  8014a4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8014a7:	a1 28 30 80 00       	mov    0x803028,%eax
  8014ac:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8014af:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	ff 75 08             	pushl  0x8(%ebp)
  8014bc:	ff 75 a4             	pushl  -0x5c(%ebp)
  8014bf:	e8 04 06 00 00       	call   801ac8 <sys_allocateMem>
  8014c4:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  8014c7:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	01 d0                	add    %edx,%eax
  8014d2:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  8014d7:	a1 28 30 80 00       	mov    0x803028,%eax
  8014dc:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8014e2:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  8014e9:	a1 28 30 80 00       	mov    0x803028,%eax
  8014ee:	40                   	inc    %eax
  8014ef:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  8014f4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8014f7:	e9 47 02 00 00       	jmp    801743 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  8014fc:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801503:	e9 ac 00 00 00       	jmp    8015b4 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801508:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80150b:	89 d0                	mov    %edx,%eax
  80150d:	01 c0                	add    %eax,%eax
  80150f:	01 d0                	add    %edx,%eax
  801511:	c1 e0 02             	shl    $0x2,%eax
  801514:	05 24 31 80 00       	add    $0x803124,%eax
  801519:	8b 00                	mov    (%eax),%eax
  80151b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80151e:	eb 7e                	jmp    80159e <malloc+0x314>
			int flag=0;
  801520:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801527:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  80152e:	eb 57                	jmp    801587 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801530:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801533:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80153a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80153d:	39 c2                	cmp    %eax,%edx
  80153f:	77 1a                	ja     80155b <malloc+0x2d1>
  801541:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801544:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80154b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80154e:	39 c2                	cmp    %eax,%edx
  801550:	76 09                	jbe    80155b <malloc+0x2d1>
								flag=1;
  801552:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801559:	eb 36                	jmp    801591 <malloc+0x307>
			arr[i].space++;
  80155b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80155e:	89 d0                	mov    %edx,%eax
  801560:	01 c0                	add    %eax,%eax
  801562:	01 d0                	add    %edx,%eax
  801564:	c1 e0 02             	shl    $0x2,%eax
  801567:	05 28 31 80 00       	add    $0x803128,%eax
  80156c:	8b 00                	mov    (%eax),%eax
  80156e:	8d 48 01             	lea    0x1(%eax),%ecx
  801571:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801574:	89 d0                	mov    %edx,%eax
  801576:	01 c0                	add    %eax,%eax
  801578:	01 d0                	add    %edx,%eax
  80157a:	c1 e0 02             	shl    $0x2,%eax
  80157d:	05 28 31 80 00       	add    $0x803128,%eax
  801582:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801584:	ff 45 c0             	incl   -0x40(%ebp)
  801587:	a1 28 30 80 00       	mov    0x803028,%eax
  80158c:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  80158f:	7c 9f                	jl     801530 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801591:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801595:	75 19                	jne    8015b0 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801597:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  80159e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8015a1:	a1 04 30 80 00       	mov    0x803004,%eax
  8015a6:	39 c2                	cmp    %eax,%edx
  8015a8:	0f 82 72 ff ff ff    	jb     801520 <malloc+0x296>
  8015ae:	eb 01                	jmp    8015b1 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  8015b0:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  8015b1:	ff 45 cc             	incl   -0x34(%ebp)
  8015b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8015b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015ba:	0f 8c 48 ff ff ff    	jl     801508 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  8015c0:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  8015c7:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  8015ce:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  8015d5:	eb 37                	jmp    80160e <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  8015d7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8015da:	89 d0                	mov    %edx,%eax
  8015dc:	01 c0                	add    %eax,%eax
  8015de:	01 d0                	add    %edx,%eax
  8015e0:	c1 e0 02             	shl    $0x2,%eax
  8015e3:	05 28 31 80 00       	add    $0x803128,%eax
  8015e8:	8b 00                	mov    (%eax),%eax
  8015ea:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8015ed:	7d 1c                	jge    80160b <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  8015ef:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8015f2:	89 d0                	mov    %edx,%eax
  8015f4:	01 c0                	add    %eax,%eax
  8015f6:	01 d0                	add    %edx,%eax
  8015f8:	c1 e0 02             	shl    $0x2,%eax
  8015fb:	05 28 31 80 00       	add    $0x803128,%eax
  801600:	8b 00                	mov    (%eax),%eax
  801602:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801605:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801608:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  80160b:	ff 45 b4             	incl   -0x4c(%ebp)
  80160e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801611:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801614:	7c c1                	jl     8015d7 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801616:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80161c:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  80161f:	89 c8                	mov    %ecx,%eax
  801621:	01 c0                	add    %eax,%eax
  801623:	01 c8                	add    %ecx,%eax
  801625:	c1 e0 02             	shl    $0x2,%eax
  801628:	05 20 31 80 00       	add    $0x803120,%eax
  80162d:	8b 00                	mov    (%eax),%eax
  80162f:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801636:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80163c:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  80163f:	89 c8                	mov    %ecx,%eax
  801641:	01 c0                	add    %eax,%eax
  801643:	01 c8                	add    %ecx,%eax
  801645:	c1 e0 02             	shl    $0x2,%eax
  801648:	05 24 31 80 00       	add    $0x803124,%eax
  80164d:	8b 00                	mov    (%eax),%eax
  80164f:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  801656:	a1 28 30 80 00       	mov    0x803028,%eax
  80165b:	40                   	inc    %eax
  80165c:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  801661:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801664:	89 d0                	mov    %edx,%eax
  801666:	01 c0                	add    %eax,%eax
  801668:	01 d0                	add    %edx,%eax
  80166a:	c1 e0 02             	shl    $0x2,%eax
  80166d:	05 20 31 80 00       	add    $0x803120,%eax
  801672:	8b 00                	mov    (%eax),%eax
  801674:	83 ec 08             	sub    $0x8,%esp
  801677:	ff 75 08             	pushl  0x8(%ebp)
  80167a:	50                   	push   %eax
  80167b:	e8 48 04 00 00       	call   801ac8 <sys_allocateMem>
  801680:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801683:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  80168a:	eb 78                	jmp    801704 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  80168c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80168f:	89 d0                	mov    %edx,%eax
  801691:	01 c0                	add    %eax,%eax
  801693:	01 d0                	add    %edx,%eax
  801695:	c1 e0 02             	shl    $0x2,%eax
  801698:	05 20 31 80 00       	add    $0x803120,%eax
  80169d:	8b 00                	mov    (%eax),%eax
  80169f:	83 ec 04             	sub    $0x4,%esp
  8016a2:	50                   	push   %eax
  8016a3:	ff 75 b0             	pushl  -0x50(%ebp)
  8016a6:	68 30 28 80 00       	push   $0x802830
  8016ab:	e8 50 ee ff ff       	call   800500 <cprintf>
  8016b0:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8016b3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8016b6:	89 d0                	mov    %edx,%eax
  8016b8:	01 c0                	add    %eax,%eax
  8016ba:	01 d0                	add    %edx,%eax
  8016bc:	c1 e0 02             	shl    $0x2,%eax
  8016bf:	05 24 31 80 00       	add    $0x803124,%eax
  8016c4:	8b 00                	mov    (%eax),%eax
  8016c6:	83 ec 04             	sub    $0x4,%esp
  8016c9:	50                   	push   %eax
  8016ca:	ff 75 b0             	pushl  -0x50(%ebp)
  8016cd:	68 45 28 80 00       	push   $0x802845
  8016d2:	e8 29 ee ff ff       	call   800500 <cprintf>
  8016d7:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  8016da:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8016dd:	89 d0                	mov    %edx,%eax
  8016df:	01 c0                	add    %eax,%eax
  8016e1:	01 d0                	add    %edx,%eax
  8016e3:	c1 e0 02             	shl    $0x2,%eax
  8016e6:	05 28 31 80 00       	add    $0x803128,%eax
  8016eb:	8b 00                	mov    (%eax),%eax
  8016ed:	83 ec 04             	sub    $0x4,%esp
  8016f0:	50                   	push   %eax
  8016f1:	ff 75 b0             	pushl  -0x50(%ebp)
  8016f4:	68 58 28 80 00       	push   $0x802858
  8016f9:	e8 02 ee ff ff       	call   800500 <cprintf>
  8016fe:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801701:	ff 45 b0             	incl   -0x50(%ebp)
  801704:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801707:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80170a:	7c 80                	jl     80168c <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  80170c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80170f:	89 d0                	mov    %edx,%eax
  801711:	01 c0                	add    %eax,%eax
  801713:	01 d0                	add    %edx,%eax
  801715:	c1 e0 02             	shl    $0x2,%eax
  801718:	05 20 31 80 00       	add    $0x803120,%eax
  80171d:	8b 00                	mov    (%eax),%eax
  80171f:	83 ec 08             	sub    $0x8,%esp
  801722:	50                   	push   %eax
  801723:	68 6c 28 80 00       	push   $0x80286c
  801728:	e8 d3 ed ff ff       	call   800500 <cprintf>
  80172d:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801730:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801733:	89 d0                	mov    %edx,%eax
  801735:	01 c0                	add    %eax,%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	c1 e0 02             	shl    $0x2,%eax
  80173c:	05 20 31 80 00       	add    $0x803120,%eax
  801741:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801751:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801758:	eb 4b                	jmp    8017a5 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  80175a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175d:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801764:	89 c2                	mov    %eax,%edx
  801766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801769:	39 c2                	cmp    %eax,%edx
  80176b:	7f 35                	jg     8017a2 <free+0x5d>
  80176d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801770:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801777:	89 c2                	mov    %eax,%edx
  801779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80177c:	39 c2                	cmp    %eax,%edx
  80177e:	7e 22                	jle    8017a2 <free+0x5d>
				start=arr_add[i].start;
  801780:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801783:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80178a:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  80178d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801790:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801797:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  80179a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8017a0:	eb 0d                	jmp    8017af <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8017a2:	ff 45 ec             	incl   -0x14(%ebp)
  8017a5:	a1 28 30 80 00       	mov    0x803028,%eax
  8017aa:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8017ad:	7c ab                	jl     80175a <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8017af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b2:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8017b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bc:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8017c3:	29 c2                	sub    %eax,%edx
  8017c5:	89 d0                	mov    %edx,%eax
  8017c7:	83 ec 08             	sub    $0x8,%esp
  8017ca:	50                   	push   %eax
  8017cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ce:	e8 d9 02 00 00       	call   801aac <sys_freeMem>
  8017d3:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  8017d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017dc:	eb 2d                	jmp    80180b <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  8017de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017e1:	40                   	inc    %eax
  8017e2:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8017e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ec:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  8017f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017f6:	40                   	inc    %eax
  8017f7:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8017fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801801:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801808:	ff 45 e8             	incl   -0x18(%ebp)
  80180b:	a1 28 30 80 00       	mov    0x803028,%eax
  801810:	48                   	dec    %eax
  801811:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801814:	7f c8                	jg     8017de <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801816:	a1 28 30 80 00       	mov    0x803028,%eax
  80181b:	48                   	dec    %eax
  80181c:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801821:	90                   	nop
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	83 ec 18             	sub    $0x18,%esp
  80182a:	8b 45 10             	mov    0x10(%ebp),%eax
  80182d:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801830:	83 ec 04             	sub    $0x4,%esp
  801833:	68 88 28 80 00       	push   $0x802888
  801838:	68 18 01 00 00       	push   $0x118
  80183d:	68 ab 28 80 00       	push   $0x8028ab
  801842:	e8 17 ea ff ff       	call   80025e <_panic>

00801847 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80184d:	83 ec 04             	sub    $0x4,%esp
  801850:	68 88 28 80 00       	push   $0x802888
  801855:	68 1e 01 00 00       	push   $0x11e
  80185a:	68 ab 28 80 00       	push   $0x8028ab
  80185f:	e8 fa e9 ff ff       	call   80025e <_panic>

00801864 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80186a:	83 ec 04             	sub    $0x4,%esp
  80186d:	68 88 28 80 00       	push   $0x802888
  801872:	68 24 01 00 00       	push   $0x124
  801877:	68 ab 28 80 00       	push   $0x8028ab
  80187c:	e8 dd e9 ff ff       	call   80025e <_panic>

00801881 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801887:	83 ec 04             	sub    $0x4,%esp
  80188a:	68 88 28 80 00       	push   $0x802888
  80188f:	68 29 01 00 00       	push   $0x129
  801894:	68 ab 28 80 00       	push   $0x8028ab
  801899:	e8 c0 e9 ff ff       	call   80025e <_panic>

0080189e <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018a4:	83 ec 04             	sub    $0x4,%esp
  8018a7:	68 88 28 80 00       	push   $0x802888
  8018ac:	68 2f 01 00 00       	push   $0x12f
  8018b1:	68 ab 28 80 00       	push   $0x8028ab
  8018b6:	e8 a3 e9 ff ff       	call   80025e <_panic>

008018bb <shrink>:
}
void shrink(uint32 newSize)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018c1:	83 ec 04             	sub    $0x4,%esp
  8018c4:	68 88 28 80 00       	push   $0x802888
  8018c9:	68 33 01 00 00       	push   $0x133
  8018ce:	68 ab 28 80 00       	push   $0x8028ab
  8018d3:	e8 86 e9 ff ff       	call   80025e <_panic>

008018d8 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018de:	83 ec 04             	sub    $0x4,%esp
  8018e1:	68 88 28 80 00       	push   $0x802888
  8018e6:	68 38 01 00 00       	push   $0x138
  8018eb:	68 ab 28 80 00       	push   $0x8028ab
  8018f0:	e8 69 e9 ff ff       	call   80025e <_panic>

008018f5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	57                   	push   %edi
  8018f9:	56                   	push   %esi
  8018fa:	53                   	push   %ebx
  8018fb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	8b 55 0c             	mov    0xc(%ebp),%edx
  801904:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801907:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80190a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80190d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801910:	cd 30                	int    $0x30
  801912:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801915:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	5b                   	pop    %ebx
  80191c:	5e                   	pop    %esi
  80191d:	5f                   	pop    %edi
  80191e:	5d                   	pop    %ebp
  80191f:	c3                   	ret    

00801920 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	8b 45 10             	mov    0x10(%ebp),%eax
  801929:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80192c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	52                   	push   %edx
  801938:	ff 75 0c             	pushl  0xc(%ebp)
  80193b:	50                   	push   %eax
  80193c:	6a 00                	push   $0x0
  80193e:	e8 b2 ff ff ff       	call   8018f5 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	90                   	nop
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_cgetc>:

int
sys_cgetc(void)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 01                	push   $0x1
  801958:	e8 98 ff ff ff       	call   8018f5 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	50                   	push   %eax
  801971:	6a 05                	push   $0x5
  801973:	e8 7d ff ff ff       	call   8018f5 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 02                	push   $0x2
  80198c:	e8 64 ff ff ff       	call   8018f5 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 03                	push   $0x3
  8019a5:	e8 4b ff ff ff       	call   8018f5 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 04                	push   $0x4
  8019be:	e8 32 ff ff ff       	call   8018f5 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_env_exit>:


void sys_env_exit(void)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 06                	push   $0x6
  8019d7:	e8 19 ff ff ff       	call   8018f5 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
}
  8019df:	90                   	nop
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	52                   	push   %edx
  8019f2:	50                   	push   %eax
  8019f3:	6a 07                	push   $0x7
  8019f5:	e8 fb fe ff ff       	call   8018f5 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	56                   	push   %esi
  801a03:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a04:	8b 75 18             	mov    0x18(%ebp),%esi
  801a07:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	56                   	push   %esi
  801a14:	53                   	push   %ebx
  801a15:	51                   	push   %ecx
  801a16:	52                   	push   %edx
  801a17:	50                   	push   %eax
  801a18:	6a 08                	push   $0x8
  801a1a:	e8 d6 fe ff ff       	call   8018f5 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a25:	5b                   	pop    %ebx
  801a26:	5e                   	pop    %esi
  801a27:	5d                   	pop    %ebp
  801a28:	c3                   	ret    

00801a29 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	52                   	push   %edx
  801a39:	50                   	push   %eax
  801a3a:	6a 09                	push   $0x9
  801a3c:	e8 b4 fe ff ff       	call   8018f5 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	ff 75 0c             	pushl  0xc(%ebp)
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	6a 0a                	push   $0xa
  801a57:	e8 99 fe ff ff       	call   8018f5 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 0b                	push   $0xb
  801a70:	e8 80 fe ff ff       	call   8018f5 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 0c                	push   $0xc
  801a89:	e8 67 fe ff ff       	call   8018f5 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 0d                	push   $0xd
  801aa2:	e8 4e fe ff ff       	call   8018f5 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	ff 75 08             	pushl  0x8(%ebp)
  801abb:	6a 11                	push   $0x11
  801abd:	e8 33 fe ff ff       	call   8018f5 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
	return;
  801ac5:	90                   	nop
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	ff 75 0c             	pushl  0xc(%ebp)
  801ad4:	ff 75 08             	pushl  0x8(%ebp)
  801ad7:	6a 12                	push   $0x12
  801ad9:	e8 17 fe ff ff       	call   8018f5 <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae1:	90                   	nop
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 0e                	push   $0xe
  801af3:	e8 fd fd ff ff       	call   8018f5 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	ff 75 08             	pushl  0x8(%ebp)
  801b0b:	6a 0f                	push   $0xf
  801b0d:	e8 e3 fd ff ff       	call   8018f5 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 10                	push   $0x10
  801b26:	e8 ca fd ff ff       	call   8018f5 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	90                   	nop
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 14                	push   $0x14
  801b40:	e8 b0 fd ff ff       	call   8018f5 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	90                   	nop
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 15                	push   $0x15
  801b5a:	e8 96 fd ff ff       	call   8018f5 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	90                   	nop
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 04             	sub    $0x4,%esp
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b71:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	50                   	push   %eax
  801b7e:	6a 16                	push   $0x16
  801b80:	e8 70 fd ff ff       	call   8018f5 <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	90                   	nop
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 17                	push   $0x17
  801b9a:	e8 56 fd ff ff       	call   8018f5 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	90                   	nop
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	ff 75 0c             	pushl  0xc(%ebp)
  801bb4:	50                   	push   %eax
  801bb5:	6a 18                	push   $0x18
  801bb7:	e8 39 fd ff ff       	call   8018f5 <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	52                   	push   %edx
  801bd1:	50                   	push   %eax
  801bd2:	6a 1b                	push   $0x1b
  801bd4:	e8 1c fd ff ff       	call   8018f5 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801be1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	52                   	push   %edx
  801bee:	50                   	push   %eax
  801bef:	6a 19                	push   $0x19
  801bf1:	e8 ff fc ff ff       	call   8018f5 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	52                   	push   %edx
  801c0c:	50                   	push   %eax
  801c0d:	6a 1a                	push   $0x1a
  801c0f:	e8 e1 fc ff ff       	call   8018f5 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	90                   	nop
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	83 ec 04             	sub    $0x4,%esp
  801c20:	8b 45 10             	mov    0x10(%ebp),%eax
  801c23:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c26:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c29:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	6a 00                	push   $0x0
  801c32:	51                   	push   %ecx
  801c33:	52                   	push   %edx
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	50                   	push   %eax
  801c38:	6a 1c                	push   $0x1c
  801c3a:	e8 b6 fc ff ff       	call   8018f5 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	52                   	push   %edx
  801c54:	50                   	push   %eax
  801c55:	6a 1d                	push   $0x1d
  801c57:	e8 99 fc ff ff       	call   8018f5 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	51                   	push   %ecx
  801c72:	52                   	push   %edx
  801c73:	50                   	push   %eax
  801c74:	6a 1e                	push   $0x1e
  801c76:	e8 7a fc ff ff       	call   8018f5 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	52                   	push   %edx
  801c90:	50                   	push   %eax
  801c91:	6a 1f                	push   $0x1f
  801c93:	e8 5d fc ff ff       	call   8018f5 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 20                	push   $0x20
  801cac:	e8 44 fc ff ff       	call   8018f5 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbc:	6a 00                	push   $0x0
  801cbe:	ff 75 14             	pushl  0x14(%ebp)
  801cc1:	ff 75 10             	pushl  0x10(%ebp)
  801cc4:	ff 75 0c             	pushl  0xc(%ebp)
  801cc7:	50                   	push   %eax
  801cc8:	6a 21                	push   $0x21
  801cca:	e8 26 fc ff ff       	call   8018f5 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	50                   	push   %eax
  801ce3:	6a 22                	push   $0x22
  801ce5:	e8 0b fc ff ff       	call   8018f5 <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
}
  801ced:	90                   	nop
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	50                   	push   %eax
  801cff:	6a 23                	push   $0x23
  801d01:	e8 ef fb ff ff       	call   8018f5 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	90                   	nop
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d12:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d15:	8d 50 04             	lea    0x4(%eax),%edx
  801d18:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	52                   	push   %edx
  801d22:	50                   	push   %eax
  801d23:	6a 24                	push   $0x24
  801d25:	e8 cb fb ff ff       	call   8018f5 <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
	return result;
  801d2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d36:	89 01                	mov    %eax,(%ecx)
  801d38:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	c9                   	leave  
  801d3f:	c2 04 00             	ret    $0x4

00801d42 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	ff 75 10             	pushl  0x10(%ebp)
  801d4c:	ff 75 0c             	pushl  0xc(%ebp)
  801d4f:	ff 75 08             	pushl  0x8(%ebp)
  801d52:	6a 13                	push   $0x13
  801d54:	e8 9c fb ff ff       	call   8018f5 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5c:	90                   	nop
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_rcr2>:
uint32 sys_rcr2()
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 25                	push   $0x25
  801d6e:	e8 82 fb ff ff       	call   8018f5 <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	83 ec 04             	sub    $0x4,%esp
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d84:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	50                   	push   %eax
  801d91:	6a 26                	push   $0x26
  801d93:	e8 5d fb ff ff       	call   8018f5 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9b:	90                   	nop
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <rsttst>:
void rsttst()
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 28                	push   $0x28
  801dad:	e8 43 fb ff ff       	call   8018f5 <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
	return ;
  801db5:	90                   	nop
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 04             	sub    $0x4,%esp
  801dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dc4:	8b 55 18             	mov    0x18(%ebp),%edx
  801dc7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dcb:	52                   	push   %edx
  801dcc:	50                   	push   %eax
  801dcd:	ff 75 10             	pushl  0x10(%ebp)
  801dd0:	ff 75 0c             	pushl  0xc(%ebp)
  801dd3:	ff 75 08             	pushl  0x8(%ebp)
  801dd6:	6a 27                	push   $0x27
  801dd8:	e8 18 fb ff ff       	call   8018f5 <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
	return ;
  801de0:	90                   	nop
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <chktst>:
void chktst(uint32 n)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	ff 75 08             	pushl  0x8(%ebp)
  801df1:	6a 29                	push   $0x29
  801df3:	e8 fd fa ff ff       	call   8018f5 <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfb:	90                   	nop
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <inctst>:

void inctst()
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 2a                	push   $0x2a
  801e0d:	e8 e3 fa ff ff       	call   8018f5 <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
	return ;
  801e15:	90                   	nop
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <gettst>:
uint32 gettst()
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 2b                	push   $0x2b
  801e27:	e8 c9 fa ff ff       	call   8018f5 <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 2c                	push   $0x2c
  801e43:	e8 ad fa ff ff       	call   8018f5 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
  801e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e4e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e52:	75 07                	jne    801e5b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e54:	b8 01 00 00 00       	mov    $0x1,%eax
  801e59:	eb 05                	jmp    801e60 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 2c                	push   $0x2c
  801e74:	e8 7c fa ff ff       	call   8018f5 <syscall>
  801e79:	83 c4 18             	add    $0x18,%esp
  801e7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e7f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e83:	75 07                	jne    801e8c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e85:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8a:	eb 05                	jmp    801e91 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 2c                	push   $0x2c
  801ea5:	e8 4b fa ff ff       	call   8018f5 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
  801ead:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eb0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eb4:	75 07                	jne    801ebd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eb6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebb:	eb 05                	jmp    801ec2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ebd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 2c                	push   $0x2c
  801ed6:	e8 1a fa ff ff       	call   8018f5 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
  801ede:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ee1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ee5:	75 07                	jne    801eee <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ee7:	b8 01 00 00 00       	mov    $0x1,%eax
  801eec:	eb 05                	jmp    801ef3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	ff 75 08             	pushl  0x8(%ebp)
  801f03:	6a 2d                	push   $0x2d
  801f05:	e8 eb f9 ff ff       	call   8018f5 <syscall>
  801f0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0d:	90                   	nop
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f14:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f17:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	6a 00                	push   $0x0
  801f22:	53                   	push   %ebx
  801f23:	51                   	push   %ecx
  801f24:	52                   	push   %edx
  801f25:	50                   	push   %eax
  801f26:	6a 2e                	push   $0x2e
  801f28:	e8 c8 f9 ff ff       	call   8018f5 <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	52                   	push   %edx
  801f45:	50                   	push   %eax
  801f46:	6a 2f                	push   $0x2f
  801f48:	e8 a8 f9 ff ff       	call   8018f5 <syscall>
  801f4d:	83 c4 18             	add    $0x18,%esp
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    
  801f52:	66 90                	xchg   %ax,%ax

00801f54 <__udivdi3>:
  801f54:	55                   	push   %ebp
  801f55:	57                   	push   %edi
  801f56:	56                   	push   %esi
  801f57:	53                   	push   %ebx
  801f58:	83 ec 1c             	sub    $0x1c,%esp
  801f5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f6b:	89 ca                	mov    %ecx,%edx
  801f6d:	89 f8                	mov    %edi,%eax
  801f6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f73:	85 f6                	test   %esi,%esi
  801f75:	75 2d                	jne    801fa4 <__udivdi3+0x50>
  801f77:	39 cf                	cmp    %ecx,%edi
  801f79:	77 65                	ja     801fe0 <__udivdi3+0x8c>
  801f7b:	89 fd                	mov    %edi,%ebp
  801f7d:	85 ff                	test   %edi,%edi
  801f7f:	75 0b                	jne    801f8c <__udivdi3+0x38>
  801f81:	b8 01 00 00 00       	mov    $0x1,%eax
  801f86:	31 d2                	xor    %edx,%edx
  801f88:	f7 f7                	div    %edi
  801f8a:	89 c5                	mov    %eax,%ebp
  801f8c:	31 d2                	xor    %edx,%edx
  801f8e:	89 c8                	mov    %ecx,%eax
  801f90:	f7 f5                	div    %ebp
  801f92:	89 c1                	mov    %eax,%ecx
  801f94:	89 d8                	mov    %ebx,%eax
  801f96:	f7 f5                	div    %ebp
  801f98:	89 cf                	mov    %ecx,%edi
  801f9a:	89 fa                	mov    %edi,%edx
  801f9c:	83 c4 1c             	add    $0x1c,%esp
  801f9f:	5b                   	pop    %ebx
  801fa0:	5e                   	pop    %esi
  801fa1:	5f                   	pop    %edi
  801fa2:	5d                   	pop    %ebp
  801fa3:	c3                   	ret    
  801fa4:	39 ce                	cmp    %ecx,%esi
  801fa6:	77 28                	ja     801fd0 <__udivdi3+0x7c>
  801fa8:	0f bd fe             	bsr    %esi,%edi
  801fab:	83 f7 1f             	xor    $0x1f,%edi
  801fae:	75 40                	jne    801ff0 <__udivdi3+0x9c>
  801fb0:	39 ce                	cmp    %ecx,%esi
  801fb2:	72 0a                	jb     801fbe <__udivdi3+0x6a>
  801fb4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801fb8:	0f 87 9e 00 00 00    	ja     80205c <__udivdi3+0x108>
  801fbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc3:	89 fa                	mov    %edi,%edx
  801fc5:	83 c4 1c             	add    $0x1c,%esp
  801fc8:	5b                   	pop    %ebx
  801fc9:	5e                   	pop    %esi
  801fca:	5f                   	pop    %edi
  801fcb:	5d                   	pop    %ebp
  801fcc:	c3                   	ret    
  801fcd:	8d 76 00             	lea    0x0(%esi),%esi
  801fd0:	31 ff                	xor    %edi,%edi
  801fd2:	31 c0                	xor    %eax,%eax
  801fd4:	89 fa                	mov    %edi,%edx
  801fd6:	83 c4 1c             	add    $0x1c,%esp
  801fd9:	5b                   	pop    %ebx
  801fda:	5e                   	pop    %esi
  801fdb:	5f                   	pop    %edi
  801fdc:	5d                   	pop    %ebp
  801fdd:	c3                   	ret    
  801fde:	66 90                	xchg   %ax,%ax
  801fe0:	89 d8                	mov    %ebx,%eax
  801fe2:	f7 f7                	div    %edi
  801fe4:	31 ff                	xor    %edi,%edi
  801fe6:	89 fa                	mov    %edi,%edx
  801fe8:	83 c4 1c             	add    $0x1c,%esp
  801feb:	5b                   	pop    %ebx
  801fec:	5e                   	pop    %esi
  801fed:	5f                   	pop    %edi
  801fee:	5d                   	pop    %ebp
  801fef:	c3                   	ret    
  801ff0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ff5:	89 eb                	mov    %ebp,%ebx
  801ff7:	29 fb                	sub    %edi,%ebx
  801ff9:	89 f9                	mov    %edi,%ecx
  801ffb:	d3 e6                	shl    %cl,%esi
  801ffd:	89 c5                	mov    %eax,%ebp
  801fff:	88 d9                	mov    %bl,%cl
  802001:	d3 ed                	shr    %cl,%ebp
  802003:	89 e9                	mov    %ebp,%ecx
  802005:	09 f1                	or     %esi,%ecx
  802007:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80200b:	89 f9                	mov    %edi,%ecx
  80200d:	d3 e0                	shl    %cl,%eax
  80200f:	89 c5                	mov    %eax,%ebp
  802011:	89 d6                	mov    %edx,%esi
  802013:	88 d9                	mov    %bl,%cl
  802015:	d3 ee                	shr    %cl,%esi
  802017:	89 f9                	mov    %edi,%ecx
  802019:	d3 e2                	shl    %cl,%edx
  80201b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80201f:	88 d9                	mov    %bl,%cl
  802021:	d3 e8                	shr    %cl,%eax
  802023:	09 c2                	or     %eax,%edx
  802025:	89 d0                	mov    %edx,%eax
  802027:	89 f2                	mov    %esi,%edx
  802029:	f7 74 24 0c          	divl   0xc(%esp)
  80202d:	89 d6                	mov    %edx,%esi
  80202f:	89 c3                	mov    %eax,%ebx
  802031:	f7 e5                	mul    %ebp
  802033:	39 d6                	cmp    %edx,%esi
  802035:	72 19                	jb     802050 <__udivdi3+0xfc>
  802037:	74 0b                	je     802044 <__udivdi3+0xf0>
  802039:	89 d8                	mov    %ebx,%eax
  80203b:	31 ff                	xor    %edi,%edi
  80203d:	e9 58 ff ff ff       	jmp    801f9a <__udivdi3+0x46>
  802042:	66 90                	xchg   %ax,%ax
  802044:	8b 54 24 08          	mov    0x8(%esp),%edx
  802048:	89 f9                	mov    %edi,%ecx
  80204a:	d3 e2                	shl    %cl,%edx
  80204c:	39 c2                	cmp    %eax,%edx
  80204e:	73 e9                	jae    802039 <__udivdi3+0xe5>
  802050:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802053:	31 ff                	xor    %edi,%edi
  802055:	e9 40 ff ff ff       	jmp    801f9a <__udivdi3+0x46>
  80205a:	66 90                	xchg   %ax,%ax
  80205c:	31 c0                	xor    %eax,%eax
  80205e:	e9 37 ff ff ff       	jmp    801f9a <__udivdi3+0x46>
  802063:	90                   	nop

00802064 <__umoddi3>:
  802064:	55                   	push   %ebp
  802065:	57                   	push   %edi
  802066:	56                   	push   %esi
  802067:	53                   	push   %ebx
  802068:	83 ec 1c             	sub    $0x1c,%esp
  80206b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80206f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802073:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802077:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80207b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80207f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802083:	89 f3                	mov    %esi,%ebx
  802085:	89 fa                	mov    %edi,%edx
  802087:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80208b:	89 34 24             	mov    %esi,(%esp)
  80208e:	85 c0                	test   %eax,%eax
  802090:	75 1a                	jne    8020ac <__umoddi3+0x48>
  802092:	39 f7                	cmp    %esi,%edi
  802094:	0f 86 a2 00 00 00    	jbe    80213c <__umoddi3+0xd8>
  80209a:	89 c8                	mov    %ecx,%eax
  80209c:	89 f2                	mov    %esi,%edx
  80209e:	f7 f7                	div    %edi
  8020a0:	89 d0                	mov    %edx,%eax
  8020a2:	31 d2                	xor    %edx,%edx
  8020a4:	83 c4 1c             	add    $0x1c,%esp
  8020a7:	5b                   	pop    %ebx
  8020a8:	5e                   	pop    %esi
  8020a9:	5f                   	pop    %edi
  8020aa:	5d                   	pop    %ebp
  8020ab:	c3                   	ret    
  8020ac:	39 f0                	cmp    %esi,%eax
  8020ae:	0f 87 ac 00 00 00    	ja     802160 <__umoddi3+0xfc>
  8020b4:	0f bd e8             	bsr    %eax,%ebp
  8020b7:	83 f5 1f             	xor    $0x1f,%ebp
  8020ba:	0f 84 ac 00 00 00    	je     80216c <__umoddi3+0x108>
  8020c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8020c5:	29 ef                	sub    %ebp,%edi
  8020c7:	89 fe                	mov    %edi,%esi
  8020c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020cd:	89 e9                	mov    %ebp,%ecx
  8020cf:	d3 e0                	shl    %cl,%eax
  8020d1:	89 d7                	mov    %edx,%edi
  8020d3:	89 f1                	mov    %esi,%ecx
  8020d5:	d3 ef                	shr    %cl,%edi
  8020d7:	09 c7                	or     %eax,%edi
  8020d9:	89 e9                	mov    %ebp,%ecx
  8020db:	d3 e2                	shl    %cl,%edx
  8020dd:	89 14 24             	mov    %edx,(%esp)
  8020e0:	89 d8                	mov    %ebx,%eax
  8020e2:	d3 e0                	shl    %cl,%eax
  8020e4:	89 c2                	mov    %eax,%edx
  8020e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020ea:	d3 e0                	shl    %cl,%eax
  8020ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020f4:	89 f1                	mov    %esi,%ecx
  8020f6:	d3 e8                	shr    %cl,%eax
  8020f8:	09 d0                	or     %edx,%eax
  8020fa:	d3 eb                	shr    %cl,%ebx
  8020fc:	89 da                	mov    %ebx,%edx
  8020fe:	f7 f7                	div    %edi
  802100:	89 d3                	mov    %edx,%ebx
  802102:	f7 24 24             	mull   (%esp)
  802105:	89 c6                	mov    %eax,%esi
  802107:	89 d1                	mov    %edx,%ecx
  802109:	39 d3                	cmp    %edx,%ebx
  80210b:	0f 82 87 00 00 00    	jb     802198 <__umoddi3+0x134>
  802111:	0f 84 91 00 00 00    	je     8021a8 <__umoddi3+0x144>
  802117:	8b 54 24 04          	mov    0x4(%esp),%edx
  80211b:	29 f2                	sub    %esi,%edx
  80211d:	19 cb                	sbb    %ecx,%ebx
  80211f:	89 d8                	mov    %ebx,%eax
  802121:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802125:	d3 e0                	shl    %cl,%eax
  802127:	89 e9                	mov    %ebp,%ecx
  802129:	d3 ea                	shr    %cl,%edx
  80212b:	09 d0                	or     %edx,%eax
  80212d:	89 e9                	mov    %ebp,%ecx
  80212f:	d3 eb                	shr    %cl,%ebx
  802131:	89 da                	mov    %ebx,%edx
  802133:	83 c4 1c             	add    $0x1c,%esp
  802136:	5b                   	pop    %ebx
  802137:	5e                   	pop    %esi
  802138:	5f                   	pop    %edi
  802139:	5d                   	pop    %ebp
  80213a:	c3                   	ret    
  80213b:	90                   	nop
  80213c:	89 fd                	mov    %edi,%ebp
  80213e:	85 ff                	test   %edi,%edi
  802140:	75 0b                	jne    80214d <__umoddi3+0xe9>
  802142:	b8 01 00 00 00       	mov    $0x1,%eax
  802147:	31 d2                	xor    %edx,%edx
  802149:	f7 f7                	div    %edi
  80214b:	89 c5                	mov    %eax,%ebp
  80214d:	89 f0                	mov    %esi,%eax
  80214f:	31 d2                	xor    %edx,%edx
  802151:	f7 f5                	div    %ebp
  802153:	89 c8                	mov    %ecx,%eax
  802155:	f7 f5                	div    %ebp
  802157:	89 d0                	mov    %edx,%eax
  802159:	e9 44 ff ff ff       	jmp    8020a2 <__umoddi3+0x3e>
  80215e:	66 90                	xchg   %ax,%ax
  802160:	89 c8                	mov    %ecx,%eax
  802162:	89 f2                	mov    %esi,%edx
  802164:	83 c4 1c             	add    $0x1c,%esp
  802167:	5b                   	pop    %ebx
  802168:	5e                   	pop    %esi
  802169:	5f                   	pop    %edi
  80216a:	5d                   	pop    %ebp
  80216b:	c3                   	ret    
  80216c:	3b 04 24             	cmp    (%esp),%eax
  80216f:	72 06                	jb     802177 <__umoddi3+0x113>
  802171:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802175:	77 0f                	ja     802186 <__umoddi3+0x122>
  802177:	89 f2                	mov    %esi,%edx
  802179:	29 f9                	sub    %edi,%ecx
  80217b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80217f:	89 14 24             	mov    %edx,(%esp)
  802182:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802186:	8b 44 24 04          	mov    0x4(%esp),%eax
  80218a:	8b 14 24             	mov    (%esp),%edx
  80218d:	83 c4 1c             	add    $0x1c,%esp
  802190:	5b                   	pop    %ebx
  802191:	5e                   	pop    %esi
  802192:	5f                   	pop    %edi
  802193:	5d                   	pop    %ebp
  802194:	c3                   	ret    
  802195:	8d 76 00             	lea    0x0(%esi),%esi
  802198:	2b 04 24             	sub    (%esp),%eax
  80219b:	19 fa                	sbb    %edi,%edx
  80219d:	89 d1                	mov    %edx,%ecx
  80219f:	89 c6                	mov    %eax,%esi
  8021a1:	e9 71 ff ff ff       	jmp    802117 <__umoddi3+0xb3>
  8021a6:	66 90                	xchg   %ax,%ax
  8021a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8021ac:	72 ea                	jb     802198 <__umoddi3+0x134>
  8021ae:	89 d9                	mov    %ebx,%ecx
  8021b0:	e9 62 ff ff ff       	jmp    802117 <__umoddi3+0xb3>
