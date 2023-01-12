
obj/user/ef_tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 18 02 00 00       	call   80024e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 23                	jmp    80006f <_main+0x37>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
  800051:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	c1 e2 04             	shl    $0x4,%edx
  80005d:	01 d0                	add    %edx,%eax
  80005f:	8a 40 04             	mov    0x4(%eax),%al
  800062:	84 c0                	test   %al,%al
  800064:	74 06                	je     80006c <_main+0x34>
			{
				fullWS = 0;
  800066:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006a:	eb 12                	jmp    80007e <_main+0x46>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006c:	ff 45 f0             	incl   -0x10(%ebp)
  80006f:	a1 20 30 80 00       	mov    0x803020,%eax
  800074:	8b 50 74             	mov    0x74(%eax),%edx
  800077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	77 ce                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007e:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800082:	74 14                	je     800098 <_main+0x60>
  800084:	83 ec 04             	sub    $0x4,%esp
  800087:	68 00 23 80 00       	push   $0x802300
  80008c:	6a 13                	push   $0x13
  80008e:	68 1c 23 80 00       	push   $0x80231c
  800093:	e8 fb 02 00 00       	call   800393 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  800098:	e8 47 1a 00 00       	call   801ae4 <sys_getparentenvid>
  80009d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a0:	e8 c1 1b 00 00       	call   801c66 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000a5:	e8 ec 1a 00 00       	call   801b96 <sys_calculate_free_frames>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	68 3a 23 80 00       	push   $0x80233a
  8000b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b8:	e8 bf 18 00 00       	call   80197c <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c3:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 3c 23 80 00       	push   $0x80233c
  8000d4:	6a 1c                	push   $0x1c
  8000d6:	68 1c 23 80 00       	push   $0x80231c
  8000db:	e8 b3 02 00 00       	call   800393 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e3:	e8 ae 1a 00 00       	call   801b96 <sys_calculate_free_frames>
  8000e8:	29 c3                	sub    %eax,%ebx
  8000ea:	89 d8                	mov    %ebx,%eax
  8000ec:	83 f8 01             	cmp    $0x1,%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 9c 23 80 00       	push   $0x80239c
  8000f9:	6a 1d                	push   $0x1d
  8000fb:	68 1c 23 80 00       	push   $0x80231c
  800100:	e8 8e 02 00 00       	call   800393 <_panic>
	sys_enable_interrupt();
  800105:	e8 76 1b 00 00       	call   801c80 <sys_enable_interrupt>

	sys_disable_interrupt();
  80010a:	e8 57 1b 00 00       	call   801c66 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80010f:	e8 82 1a 00 00       	call   801b96 <sys_calculate_free_frames>
  800114:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	68 2d 24 80 00       	push   $0x80242d
  80011f:	ff 75 ec             	pushl  -0x14(%ebp)
  800122:	e8 55 18 00 00       	call   80197c <sget>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012d:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800134:	74 14                	je     80014a <_main+0x112>
  800136:	83 ec 04             	sub    $0x4,%esp
  800139:	68 3c 23 80 00       	push   $0x80233c
  80013e:	6a 23                	push   $0x23
  800140:	68 1c 23 80 00       	push   $0x80231c
  800145:	e8 49 02 00 00       	call   800393 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80014a:	e8 47 1a 00 00       	call   801b96 <sys_calculate_free_frames>
  80014f:	89 c2                	mov    %eax,%edx
  800151:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800154:	39 c2                	cmp    %eax,%edx
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 9c 23 80 00       	push   $0x80239c
  800160:	6a 24                	push   $0x24
  800162:	68 1c 23 80 00       	push   $0x80231c
  800167:	e8 27 02 00 00       	call   800393 <_panic>
	sys_enable_interrupt();
  80016c:	e8 0f 1b 00 00       	call   801c80 <sys_enable_interrupt>
	
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800171:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800174:	8b 00                	mov    (%eax),%eax
  800176:	83 f8 14             	cmp    $0x14,%eax
  800179:	74 14                	je     80018f <_main+0x157>
  80017b:	83 ec 04             	sub    $0x4,%esp
  80017e:	68 30 24 80 00       	push   $0x802430
  800183:	6a 27                	push   $0x27
  800185:	68 1c 23 80 00       	push   $0x80231c
  80018a:	e8 04 02 00 00       	call   800393 <_panic>

	sys_disable_interrupt();
  80018f:	e8 d2 1a 00 00       	call   801c66 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800194:	e8 fd 19 00 00       	call   801b96 <sys_calculate_free_frames>
  800199:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80019c:	83 ec 08             	sub    $0x8,%esp
  80019f:	68 67 24 80 00       	push   $0x802467
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	e8 d0 17 00 00       	call   80197c <sget>
  8001ac:	83 c4 10             	add    $0x10,%esp
  8001af:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b2:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001b9:	74 14                	je     8001cf <_main+0x197>
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	68 3c 23 80 00       	push   $0x80233c
  8001c3:	6a 2c                	push   $0x2c
  8001c5:	68 1c 23 80 00       	push   $0x80231c
  8001ca:	e8 c4 01 00 00       	call   800393 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001cf:	e8 c2 19 00 00       	call   801b96 <sys_calculate_free_frames>
  8001d4:	89 c2                	mov    %eax,%edx
  8001d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001d9:	39 c2                	cmp    %eax,%edx
  8001db:	74 14                	je     8001f1 <_main+0x1b9>
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	68 9c 23 80 00       	push   $0x80239c
  8001e5:	6a 2d                	push   $0x2d
  8001e7:	68 1c 23 80 00       	push   $0x80231c
  8001ec:	e8 a2 01 00 00       	call   800393 <_panic>
	sys_enable_interrupt();
  8001f1:	e8 8a 1a 00 00       	call   801c80 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f9:	8b 00                	mov    (%eax),%eax
  8001fb:	83 f8 0a             	cmp    $0xa,%eax
  8001fe:	74 14                	je     800214 <_main+0x1dc>
  800200:	83 ec 04             	sub    $0x4,%esp
  800203:	68 30 24 80 00       	push   $0x802430
  800208:	6a 30                	push   $0x30
  80020a:	68 1c 23 80 00       	push   $0x80231c
  80020f:	e8 7f 01 00 00       	call   800393 <_panic>

	*z = *x + *y ;
  800214:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800217:	8b 10                	mov    (%eax),%edx
  800219:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80021c:	8b 00                	mov    (%eax),%eax
  80021e:	01 c2                	add    %eax,%edx
  800220:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800223:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800225:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800228:	8b 00                	mov    (%eax),%eax
  80022a:	83 f8 1e             	cmp    $0x1e,%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 30 24 80 00       	push   $0x802430
  800237:	6a 33                	push   $0x33
  800239:	68 1c 23 80 00       	push   $0x80231c
  80023e:	e8 50 01 00 00       	call   800393 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800243:	e8 eb 1c 00 00       	call   801f33 <inctst>

	return;
  800248:	90                   	nop
}
  800249:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80024c:	c9                   	leave  
  80024d:	c3                   	ret    

0080024e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800254:	e8 72 18 00 00       	call   801acb <sys_getenvindex>
  800259:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80025c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80025f:	89 d0                	mov    %edx,%eax
  800261:	c1 e0 03             	shl    $0x3,%eax
  800264:	01 d0                	add    %edx,%eax
  800266:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80026d:	01 c8                	add    %ecx,%eax
  80026f:	01 c0                	add    %eax,%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	01 c0                	add    %eax,%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	89 c2                	mov    %eax,%edx
  800279:	c1 e2 05             	shl    $0x5,%edx
  80027c:	29 c2                	sub    %eax,%edx
  80027e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800285:	89 c2                	mov    %eax,%edx
  800287:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80028d:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800292:	a1 20 30 80 00       	mov    0x803020,%eax
  800297:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80029d:	84 c0                	test   %al,%al
  80029f:	74 0f                	je     8002b0 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8002a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a6:	05 40 3c 01 00       	add    $0x13c40,%eax
  8002ab:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002b4:	7e 0a                	jle    8002c0 <libmain+0x72>
		binaryname = argv[0];
  8002b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b9:	8b 00                	mov    (%eax),%eax
  8002bb:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8002c0:	83 ec 08             	sub    $0x8,%esp
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	e8 6a fd ff ff       	call   800038 <_main>
  8002ce:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002d1:	e8 90 19 00 00       	call   801c66 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	68 84 24 80 00       	push   $0x802484
  8002de:	e8 52 03 00 00       	call   800635 <cprintf>
  8002e3:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002eb:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8002f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f6:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8002fc:	83 ec 04             	sub    $0x4,%esp
  8002ff:	52                   	push   %edx
  800300:	50                   	push   %eax
  800301:	68 ac 24 80 00       	push   $0x8024ac
  800306:	e8 2a 03 00 00       	call   800635 <cprintf>
  80030b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80030e:	a1 20 30 80 00       	mov    0x803020,%eax
  800313:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800319:	a1 20 30 80 00       	mov    0x803020,%eax
  80031e:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800324:	83 ec 04             	sub    $0x4,%esp
  800327:	52                   	push   %edx
  800328:	50                   	push   %eax
  800329:	68 d4 24 80 00       	push   $0x8024d4
  80032e:	e8 02 03 00 00       	call   800635 <cprintf>
  800333:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800336:	a1 20 30 80 00       	mov    0x803020,%eax
  80033b:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	50                   	push   %eax
  800345:	68 15 25 80 00       	push   $0x802515
  80034a:	e8 e6 02 00 00       	call   800635 <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	68 84 24 80 00       	push   $0x802484
  80035a:	e8 d6 02 00 00       	call   800635 <cprintf>
  80035f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800362:	e8 19 19 00 00       	call   801c80 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800367:	e8 19 00 00 00       	call   800385 <exit>
}
  80036c:	90                   	nop
  80036d:	c9                   	leave  
  80036e:	c3                   	ret    

0080036f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
  800372:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800375:	83 ec 0c             	sub    $0xc,%esp
  800378:	6a 00                	push   $0x0
  80037a:	e8 18 17 00 00       	call   801a97 <sys_env_destroy>
  80037f:	83 c4 10             	add    $0x10,%esp
}
  800382:	90                   	nop
  800383:	c9                   	leave  
  800384:	c3                   	ret    

00800385 <exit>:

void
exit(void)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80038b:	e8 6d 17 00 00       	call   801afd <sys_env_exit>
}
  800390:	90                   	nop
  800391:	c9                   	leave  
  800392:	c3                   	ret    

00800393 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800399:	8d 45 10             	lea    0x10(%ebp),%eax
  80039c:	83 c0 04             	add    $0x4,%eax
  80039f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003a2:	a1 18 31 80 00       	mov    0x803118,%eax
  8003a7:	85 c0                	test   %eax,%eax
  8003a9:	74 16                	je     8003c1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003ab:	a1 18 31 80 00       	mov    0x803118,%eax
  8003b0:	83 ec 08             	sub    $0x8,%esp
  8003b3:	50                   	push   %eax
  8003b4:	68 2c 25 80 00       	push   $0x80252c
  8003b9:	e8 77 02 00 00       	call   800635 <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003c1:	a1 00 30 80 00       	mov    0x803000,%eax
  8003c6:	ff 75 0c             	pushl  0xc(%ebp)
  8003c9:	ff 75 08             	pushl  0x8(%ebp)
  8003cc:	50                   	push   %eax
  8003cd:	68 31 25 80 00       	push   $0x802531
  8003d2:	e8 5e 02 00 00       	call   800635 <cprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003da:	8b 45 10             	mov    0x10(%ebp),%eax
  8003dd:	83 ec 08             	sub    $0x8,%esp
  8003e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e3:	50                   	push   %eax
  8003e4:	e8 e1 01 00 00       	call   8005ca <vcprintf>
  8003e9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003ec:	83 ec 08             	sub    $0x8,%esp
  8003ef:	6a 00                	push   $0x0
  8003f1:	68 4d 25 80 00       	push   $0x80254d
  8003f6:	e8 cf 01 00 00       	call   8005ca <vcprintf>
  8003fb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003fe:	e8 82 ff ff ff       	call   800385 <exit>

	// should not return here
	while (1) ;
  800403:	eb fe                	jmp    800403 <_panic+0x70>

00800405 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
  800408:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80040b:	a1 20 30 80 00       	mov    0x803020,%eax
  800410:	8b 50 74             	mov    0x74(%eax),%edx
  800413:	8b 45 0c             	mov    0xc(%ebp),%eax
  800416:	39 c2                	cmp    %eax,%edx
  800418:	74 14                	je     80042e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80041a:	83 ec 04             	sub    $0x4,%esp
  80041d:	68 50 25 80 00       	push   $0x802550
  800422:	6a 26                	push   $0x26
  800424:	68 9c 25 80 00       	push   $0x80259c
  800429:	e8 65 ff ff ff       	call   800393 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800435:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80043c:	e9 b6 00 00 00       	jmp    8004f7 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800444:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	01 d0                	add    %edx,%eax
  800450:	8b 00                	mov    (%eax),%eax
  800452:	85 c0                	test   %eax,%eax
  800454:	75 08                	jne    80045e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800456:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800459:	e9 96 00 00 00       	jmp    8004f4 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80045e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800465:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80046c:	eb 5d                	jmp    8004cb <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046e:	a1 20 30 80 00       	mov    0x803020,%eax
  800473:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800479:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80047c:	c1 e2 04             	shl    $0x4,%edx
  80047f:	01 d0                	add    %edx,%eax
  800481:	8a 40 04             	mov    0x4(%eax),%al
  800484:	84 c0                	test   %al,%al
  800486:	75 40                	jne    8004c8 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800488:	a1 20 30 80 00       	mov    0x803020,%eax
  80048d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800493:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800496:	c1 e2 04             	shl    $0x4,%edx
  800499:	01 d0                	add    %edx,%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004a8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	01 c8                	add    %ecx,%eax
  8004b9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004bb:	39 c2                	cmp    %eax,%edx
  8004bd:	75 09                	jne    8004c8 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8004bf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004c6:	eb 12                	jmp    8004da <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c8:	ff 45 e8             	incl   -0x18(%ebp)
  8004cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d0:	8b 50 74             	mov    0x74(%eax),%edx
  8004d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004d6:	39 c2                	cmp    %eax,%edx
  8004d8:	77 94                	ja     80046e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004de:	75 14                	jne    8004f4 <CheckWSWithoutLastIndex+0xef>
			panic(
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	68 a8 25 80 00       	push   $0x8025a8
  8004e8:	6a 3a                	push   $0x3a
  8004ea:	68 9c 25 80 00       	push   $0x80259c
  8004ef:	e8 9f fe ff ff       	call   800393 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004f4:	ff 45 f0             	incl   -0x10(%ebp)
  8004f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004fd:	0f 8c 3e ff ff ff    	jl     800441 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800503:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80050a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800511:	eb 20                	jmp    800533 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800513:	a1 20 30 80 00       	mov    0x803020,%eax
  800518:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80051e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800521:	c1 e2 04             	shl    $0x4,%edx
  800524:	01 d0                	add    %edx,%eax
  800526:	8a 40 04             	mov    0x4(%eax),%al
  800529:	3c 01                	cmp    $0x1,%al
  80052b:	75 03                	jne    800530 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80052d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800530:	ff 45 e0             	incl   -0x20(%ebp)
  800533:	a1 20 30 80 00       	mov    0x803020,%eax
  800538:	8b 50 74             	mov    0x74(%eax),%edx
  80053b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	77 d1                	ja     800513 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800545:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800548:	74 14                	je     80055e <CheckWSWithoutLastIndex+0x159>
		panic(
  80054a:	83 ec 04             	sub    $0x4,%esp
  80054d:	68 fc 25 80 00       	push   $0x8025fc
  800552:	6a 44                	push   $0x44
  800554:	68 9c 25 80 00       	push   $0x80259c
  800559:	e8 35 fe ff ff       	call   800393 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80055e:	90                   	nop
  80055f:	c9                   	leave  
  800560:	c3                   	ret    

00800561 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800561:	55                   	push   %ebp
  800562:	89 e5                	mov    %esp,%ebp
  800564:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	8d 48 01             	lea    0x1(%eax),%ecx
  80056f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800572:	89 0a                	mov    %ecx,(%edx)
  800574:	8b 55 08             	mov    0x8(%ebp),%edx
  800577:	88 d1                	mov    %dl,%cl
  800579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80057c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800580:	8b 45 0c             	mov    0xc(%ebp),%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	3d ff 00 00 00       	cmp    $0xff,%eax
  80058a:	75 2c                	jne    8005b8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80058c:	a0 24 30 80 00       	mov    0x803024,%al
  800591:	0f b6 c0             	movzbl %al,%eax
  800594:	8b 55 0c             	mov    0xc(%ebp),%edx
  800597:	8b 12                	mov    (%edx),%edx
  800599:	89 d1                	mov    %edx,%ecx
  80059b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059e:	83 c2 08             	add    $0x8,%edx
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	50                   	push   %eax
  8005a5:	51                   	push   %ecx
  8005a6:	52                   	push   %edx
  8005a7:	e8 a9 14 00 00       	call   801a55 <sys_cputs>
  8005ac:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bb:	8b 40 04             	mov    0x4(%eax),%eax
  8005be:	8d 50 01             	lea    0x1(%eax),%edx
  8005c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005c7:	90                   	nop
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

008005ca <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005da:	00 00 00 
	b.cnt = 0;
  8005dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005e4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 08             	pushl  0x8(%ebp)
  8005ed:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005f3:	50                   	push   %eax
  8005f4:	68 61 05 80 00       	push   $0x800561
  8005f9:	e8 11 02 00 00       	call   80080f <vprintfmt>
  8005fe:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800601:	a0 24 30 80 00       	mov    0x803024,%al
  800606:	0f b6 c0             	movzbl %al,%eax
  800609:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	50                   	push   %eax
  800613:	52                   	push   %edx
  800614:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80061a:	83 c0 08             	add    $0x8,%eax
  80061d:	50                   	push   %eax
  80061e:	e8 32 14 00 00       	call   801a55 <sys_cputs>
  800623:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800626:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80062d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800633:	c9                   	leave  
  800634:	c3                   	ret    

00800635 <cprintf>:

int cprintf(const char *fmt, ...) {
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
  800638:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80063b:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800642:	8d 45 0c             	lea    0xc(%ebp),%eax
  800645:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	ff 75 f4             	pushl  -0xc(%ebp)
  800651:	50                   	push   %eax
  800652:	e8 73 ff ff ff       	call   8005ca <vcprintf>
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80065d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800660:	c9                   	leave  
  800661:	c3                   	ret    

00800662 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800662:	55                   	push   %ebp
  800663:	89 e5                	mov    %esp,%ebp
  800665:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800668:	e8 f9 15 00 00       	call   801c66 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80066d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800670:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800673:	8b 45 08             	mov    0x8(%ebp),%eax
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	ff 75 f4             	pushl  -0xc(%ebp)
  80067c:	50                   	push   %eax
  80067d:	e8 48 ff ff ff       	call   8005ca <vcprintf>
  800682:	83 c4 10             	add    $0x10,%esp
  800685:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800688:	e8 f3 15 00 00       	call   801c80 <sys_enable_interrupt>
	return cnt;
  80068d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800690:	c9                   	leave  
  800691:	c3                   	ret    

00800692 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800692:	55                   	push   %ebp
  800693:	89 e5                	mov    %esp,%ebp
  800695:	53                   	push   %ebx
  800696:	83 ec 14             	sub    $0x14,%esp
  800699:	8b 45 10             	mov    0x10(%ebp),%eax
  80069c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ad:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b0:	77 55                	ja     800707 <printnum+0x75>
  8006b2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b5:	72 05                	jb     8006bc <printnum+0x2a>
  8006b7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006ba:	77 4b                	ja     800707 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006bc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006bf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006c2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ca:	52                   	push   %edx
  8006cb:	50                   	push   %eax
  8006cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8006d2:	e8 b1 19 00 00       	call   802088 <__udivdi3>
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	ff 75 20             	pushl  0x20(%ebp)
  8006e0:	53                   	push   %ebx
  8006e1:	ff 75 18             	pushl  0x18(%ebp)
  8006e4:	52                   	push   %edx
  8006e5:	50                   	push   %eax
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	e8 a1 ff ff ff       	call   800692 <printnum>
  8006f1:	83 c4 20             	add    $0x20,%esp
  8006f4:	eb 1a                	jmp    800710 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	ff 75 20             	pushl  0x20(%ebp)
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	ff d0                	call   *%eax
  800704:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800707:	ff 4d 1c             	decl   0x1c(%ebp)
  80070a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80070e:	7f e6                	jg     8006f6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800710:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800713:	bb 00 00 00 00       	mov    $0x0,%ebx
  800718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071e:	53                   	push   %ebx
  80071f:	51                   	push   %ecx
  800720:	52                   	push   %edx
  800721:	50                   	push   %eax
  800722:	e8 71 1a 00 00       	call   802198 <__umoddi3>
  800727:	83 c4 10             	add    $0x10,%esp
  80072a:	05 74 28 80 00       	add    $0x802874,%eax
  80072f:	8a 00                	mov    (%eax),%al
  800731:	0f be c0             	movsbl %al,%eax
  800734:	83 ec 08             	sub    $0x8,%esp
  800737:	ff 75 0c             	pushl  0xc(%ebp)
  80073a:	50                   	push   %eax
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	ff d0                	call   *%eax
  800740:	83 c4 10             	add    $0x10,%esp
}
  800743:	90                   	nop
  800744:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800747:	c9                   	leave  
  800748:	c3                   	ret    

00800749 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800749:	55                   	push   %ebp
  80074a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80074c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800750:	7e 1c                	jle    80076e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	8d 50 08             	lea    0x8(%eax),%edx
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	89 10                	mov    %edx,(%eax)
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	83 e8 08             	sub    $0x8,%eax
  800767:	8b 50 04             	mov    0x4(%eax),%edx
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	eb 40                	jmp    8007ae <getuint+0x65>
	else if (lflag)
  80076e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800772:	74 1e                	je     800792 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	8d 50 04             	lea    0x4(%eax),%edx
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	89 10                	mov    %edx,(%eax)
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	83 e8 04             	sub    $0x4,%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	ba 00 00 00 00       	mov    $0x0,%edx
  800790:	eb 1c                	jmp    8007ae <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800792:	8b 45 08             	mov    0x8(%ebp),%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	8d 50 04             	lea    0x4(%eax),%edx
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	89 10                	mov    %edx,(%eax)
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	83 e8 04             	sub    $0x4,%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ae:	5d                   	pop    %ebp
  8007af:	c3                   	ret    

008007b0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b7:	7e 1c                	jle    8007d5 <getint+0x25>
		return va_arg(*ap, long long);
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	8d 50 08             	lea    0x8(%eax),%edx
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	89 10                	mov    %edx,(%eax)
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	83 e8 08             	sub    $0x8,%eax
  8007ce:	8b 50 04             	mov    0x4(%eax),%edx
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	eb 38                	jmp    80080d <getint+0x5d>
	else if (lflag)
  8007d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d9:	74 1a                	je     8007f5 <getint+0x45>
		return va_arg(*ap, long);
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	8d 50 04             	lea    0x4(%eax),%edx
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	89 10                	mov    %edx,(%eax)
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	83 e8 04             	sub    $0x4,%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	99                   	cltd   
  8007f3:	eb 18                	jmp    80080d <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	8b 00                	mov    (%eax),%eax
  8007fa:	8d 50 04             	lea    0x4(%eax),%edx
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	89 10                	mov    %edx,(%eax)
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	8b 00                	mov    (%eax),%eax
  800807:	83 e8 04             	sub    $0x4,%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	99                   	cltd   
}
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	56                   	push   %esi
  800813:	53                   	push   %ebx
  800814:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800817:	eb 17                	jmp    800830 <vprintfmt+0x21>
			if (ch == '\0')
  800819:	85 db                	test   %ebx,%ebx
  80081b:	0f 84 af 03 00 00    	je     800bd0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	53                   	push   %ebx
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800830:	8b 45 10             	mov    0x10(%ebp),%eax
  800833:	8d 50 01             	lea    0x1(%eax),%edx
  800836:	89 55 10             	mov    %edx,0x10(%ebp)
  800839:	8a 00                	mov    (%eax),%al
  80083b:	0f b6 d8             	movzbl %al,%ebx
  80083e:	83 fb 25             	cmp    $0x25,%ebx
  800841:	75 d6                	jne    800819 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800843:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800847:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80084e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800855:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80085c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800863:	8b 45 10             	mov    0x10(%ebp),%eax
  800866:	8d 50 01             	lea    0x1(%eax),%edx
  800869:	89 55 10             	mov    %edx,0x10(%ebp)
  80086c:	8a 00                	mov    (%eax),%al
  80086e:	0f b6 d8             	movzbl %al,%ebx
  800871:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800874:	83 f8 55             	cmp    $0x55,%eax
  800877:	0f 87 2b 03 00 00    	ja     800ba8 <vprintfmt+0x399>
  80087d:	8b 04 85 98 28 80 00 	mov    0x802898(,%eax,4),%eax
  800884:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800886:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80088a:	eb d7                	jmp    800863 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80088c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800890:	eb d1                	jmp    800863 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800892:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800899:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80089c:	89 d0                	mov    %edx,%eax
  80089e:	c1 e0 02             	shl    $0x2,%eax
  8008a1:	01 d0                	add    %edx,%eax
  8008a3:	01 c0                	add    %eax,%eax
  8008a5:	01 d8                	add    %ebx,%eax
  8008a7:	83 e8 30             	sub    $0x30,%eax
  8008aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b0:	8a 00                	mov    (%eax),%al
  8008b2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008b5:	83 fb 2f             	cmp    $0x2f,%ebx
  8008b8:	7e 3e                	jle    8008f8 <vprintfmt+0xe9>
  8008ba:	83 fb 39             	cmp    $0x39,%ebx
  8008bd:	7f 39                	jg     8008f8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008bf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008c2:	eb d5                	jmp    800899 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	83 c0 04             	add    $0x4,%eax
  8008ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	83 e8 04             	sub    $0x4,%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008d8:	eb 1f                	jmp    8008f9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008de:	79 83                	jns    800863 <vprintfmt+0x54>
				width = 0;
  8008e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008e7:	e9 77 ff ff ff       	jmp    800863 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008ec:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008f3:	e9 6b ff ff ff       	jmp    800863 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008f8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fd:	0f 89 60 ff ff ff    	jns    800863 <vprintfmt+0x54>
				width = precision, precision = -1;
  800903:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800906:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800909:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800910:	e9 4e ff ff ff       	jmp    800863 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800915:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800918:	e9 46 ff ff ff       	jmp    800863 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	83 c0 04             	add    $0x4,%eax
  800923:	89 45 14             	mov    %eax,0x14(%ebp)
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	83 e8 04             	sub    $0x4,%eax
  80092c:	8b 00                	mov    (%eax),%eax
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	ff 75 0c             	pushl  0xc(%ebp)
  800934:	50                   	push   %eax
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	ff d0                	call   *%eax
  80093a:	83 c4 10             	add    $0x10,%esp
			break;
  80093d:	e9 89 02 00 00       	jmp    800bcb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	83 c0 04             	add    $0x4,%eax
  800948:	89 45 14             	mov    %eax,0x14(%ebp)
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	83 e8 04             	sub    $0x4,%eax
  800951:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800953:	85 db                	test   %ebx,%ebx
  800955:	79 02                	jns    800959 <vprintfmt+0x14a>
				err = -err;
  800957:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800959:	83 fb 64             	cmp    $0x64,%ebx
  80095c:	7f 0b                	jg     800969 <vprintfmt+0x15a>
  80095e:	8b 34 9d e0 26 80 00 	mov    0x8026e0(,%ebx,4),%esi
  800965:	85 f6                	test   %esi,%esi
  800967:	75 19                	jne    800982 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800969:	53                   	push   %ebx
  80096a:	68 85 28 80 00       	push   $0x802885
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	ff 75 08             	pushl  0x8(%ebp)
  800975:	e8 5e 02 00 00       	call   800bd8 <printfmt>
  80097a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80097d:	e9 49 02 00 00       	jmp    800bcb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800982:	56                   	push   %esi
  800983:	68 8e 28 80 00       	push   $0x80288e
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	ff 75 08             	pushl  0x8(%ebp)
  80098e:	e8 45 02 00 00       	call   800bd8 <printfmt>
  800993:	83 c4 10             	add    $0x10,%esp
			break;
  800996:	e9 30 02 00 00       	jmp    800bcb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80099b:	8b 45 14             	mov    0x14(%ebp),%eax
  80099e:	83 c0 04             	add    $0x4,%eax
  8009a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	83 e8 04             	sub    $0x4,%eax
  8009aa:	8b 30                	mov    (%eax),%esi
  8009ac:	85 f6                	test   %esi,%esi
  8009ae:	75 05                	jne    8009b5 <vprintfmt+0x1a6>
				p = "(null)";
  8009b0:	be 91 28 80 00       	mov    $0x802891,%esi
			if (width > 0 && padc != '-')
  8009b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b9:	7e 6d                	jle    800a28 <vprintfmt+0x219>
  8009bb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009bf:	74 67                	je     800a28 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	50                   	push   %eax
  8009c8:	56                   	push   %esi
  8009c9:	e8 0c 03 00 00       	call   800cda <strnlen>
  8009ce:	83 c4 10             	add    $0x10,%esp
  8009d1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009d4:	eb 16                	jmp    8009ec <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009d6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	50                   	push   %eax
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	ff d0                	call   *%eax
  8009e6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f0:	7f e4                	jg     8009d6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f2:	eb 34                	jmp    800a28 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009f8:	74 1c                	je     800a16 <vprintfmt+0x207>
  8009fa:	83 fb 1f             	cmp    $0x1f,%ebx
  8009fd:	7e 05                	jle    800a04 <vprintfmt+0x1f5>
  8009ff:	83 fb 7e             	cmp    $0x7e,%ebx
  800a02:	7e 12                	jle    800a16 <vprintfmt+0x207>
					putch('?', putdat);
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	6a 3f                	push   $0x3f
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	ff d0                	call   *%eax
  800a11:	83 c4 10             	add    $0x10,%esp
  800a14:	eb 0f                	jmp    800a25 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	53                   	push   %ebx
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	ff d0                	call   *%eax
  800a22:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a25:	ff 4d e4             	decl   -0x1c(%ebp)
  800a28:	89 f0                	mov    %esi,%eax
  800a2a:	8d 70 01             	lea    0x1(%eax),%esi
  800a2d:	8a 00                	mov    (%eax),%al
  800a2f:	0f be d8             	movsbl %al,%ebx
  800a32:	85 db                	test   %ebx,%ebx
  800a34:	74 24                	je     800a5a <vprintfmt+0x24b>
  800a36:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a3a:	78 b8                	js     8009f4 <vprintfmt+0x1e5>
  800a3c:	ff 4d e0             	decl   -0x20(%ebp)
  800a3f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a43:	79 af                	jns    8009f4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a45:	eb 13                	jmp    800a5a <vprintfmt+0x24b>
				putch(' ', putdat);
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	6a 20                	push   $0x20
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	ff d0                	call   *%eax
  800a54:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a57:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5e:	7f e7                	jg     800a47 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a60:	e9 66 01 00 00       	jmp    800bcb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 e8             	pushl  -0x18(%ebp)
  800a6b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6e:	50                   	push   %eax
  800a6f:	e8 3c fd ff ff       	call   8007b0 <getint>
  800a74:	83 c4 10             	add    $0x10,%esp
  800a77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a83:	85 d2                	test   %edx,%edx
  800a85:	79 23                	jns    800aaa <vprintfmt+0x29b>
				putch('-', putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	6a 2d                	push   $0x2d
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9d:	f7 d8                	neg    %eax
  800a9f:	83 d2 00             	adc    $0x0,%edx
  800aa2:	f7 da                	neg    %edx
  800aa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aaa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ab1:	e9 bc 00 00 00       	jmp    800b72 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ab6:	83 ec 08             	sub    $0x8,%esp
  800ab9:	ff 75 e8             	pushl  -0x18(%ebp)
  800abc:	8d 45 14             	lea    0x14(%ebp),%eax
  800abf:	50                   	push   %eax
  800ac0:	e8 84 fc ff ff       	call   800749 <getuint>
  800ac5:	83 c4 10             	add    $0x10,%esp
  800ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800acb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ace:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad5:	e9 98 00 00 00       	jmp    800b72 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	6a 58                	push   $0x58
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
  800ae7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	ff 75 0c             	pushl  0xc(%ebp)
  800af0:	6a 58                	push   $0x58
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	ff d0                	call   *%eax
  800af7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	6a 58                	push   $0x58
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
			break;
  800b0a:	e9 bc 00 00 00       	jmp    800bcb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b0f:	83 ec 08             	sub    $0x8,%esp
  800b12:	ff 75 0c             	pushl  0xc(%ebp)
  800b15:	6a 30                	push   $0x30
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	ff d0                	call   *%eax
  800b1c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	6a 78                	push   $0x78
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	ff d0                	call   *%eax
  800b2c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b32:	83 c0 04             	add    $0x4,%eax
  800b35:	89 45 14             	mov    %eax,0x14(%ebp)
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	83 e8 04             	sub    $0x4,%eax
  800b3e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b4a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b51:	eb 1f                	jmp    800b72 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 e8             	pushl  -0x18(%ebp)
  800b59:	8d 45 14             	lea    0x14(%ebp),%eax
  800b5c:	50                   	push   %eax
  800b5d:	e8 e7 fb ff ff       	call   800749 <getuint>
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b6b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b72:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b79:	83 ec 04             	sub    $0x4,%esp
  800b7c:	52                   	push   %edx
  800b7d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b80:	50                   	push   %eax
  800b81:	ff 75 f4             	pushl  -0xc(%ebp)
  800b84:	ff 75 f0             	pushl  -0x10(%ebp)
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	ff 75 08             	pushl  0x8(%ebp)
  800b8d:	e8 00 fb ff ff       	call   800692 <printnum>
  800b92:	83 c4 20             	add    $0x20,%esp
			break;
  800b95:	eb 34                	jmp    800bcb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b97:	83 ec 08             	sub    $0x8,%esp
  800b9a:	ff 75 0c             	pushl  0xc(%ebp)
  800b9d:	53                   	push   %ebx
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	ff d0                	call   *%eax
  800ba3:	83 c4 10             	add    $0x10,%esp
			break;
  800ba6:	eb 23                	jmp    800bcb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba8:	83 ec 08             	sub    $0x8,%esp
  800bab:	ff 75 0c             	pushl  0xc(%ebp)
  800bae:	6a 25                	push   $0x25
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	ff d0                	call   *%eax
  800bb5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb8:	ff 4d 10             	decl   0x10(%ebp)
  800bbb:	eb 03                	jmp    800bc0 <vprintfmt+0x3b1>
  800bbd:	ff 4d 10             	decl   0x10(%ebp)
  800bc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc3:	48                   	dec    %eax
  800bc4:	8a 00                	mov    (%eax),%al
  800bc6:	3c 25                	cmp    $0x25,%al
  800bc8:	75 f3                	jne    800bbd <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bca:	90                   	nop
		}
	}
  800bcb:	e9 47 fc ff ff       	jmp    800817 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bd0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bd1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bde:	8d 45 10             	lea    0x10(%ebp),%eax
  800be1:	83 c0 04             	add    $0x4,%eax
  800be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	ff 75 f4             	pushl  -0xc(%ebp)
  800bed:	50                   	push   %eax
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	ff 75 08             	pushl  0x8(%ebp)
  800bf4:	e8 16 fc ff ff       	call   80080f <vprintfmt>
  800bf9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bfc:	90                   	nop
  800bfd:	c9                   	leave  
  800bfe:	c3                   	ret    

00800bff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c05:	8b 40 08             	mov    0x8(%eax),%eax
  800c08:	8d 50 01             	lea    0x1(%eax),%edx
  800c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	8b 10                	mov    (%eax),%edx
  800c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c19:	8b 40 04             	mov    0x4(%eax),%eax
  800c1c:	39 c2                	cmp    %eax,%edx
  800c1e:	73 12                	jae    800c32 <sprintputch+0x33>
		*b->buf++ = ch;
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 00                	mov    (%eax),%eax
  800c25:	8d 48 01             	lea    0x1(%eax),%ecx
  800c28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2b:	89 0a                	mov    %ecx,(%edx)
  800c2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c30:	88 10                	mov    %dl,(%eax)
}
  800c32:	90                   	nop
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c44:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	01 d0                	add    %edx,%eax
  800c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c5a:	74 06                	je     800c62 <vsnprintf+0x2d>
  800c5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c60:	7f 07                	jg     800c69 <vsnprintf+0x34>
		return -E_INVAL;
  800c62:	b8 03 00 00 00       	mov    $0x3,%eax
  800c67:	eb 20                	jmp    800c89 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c69:	ff 75 14             	pushl  0x14(%ebp)
  800c6c:	ff 75 10             	pushl  0x10(%ebp)
  800c6f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c72:	50                   	push   %eax
  800c73:	68 ff 0b 80 00       	push   $0x800bff
  800c78:	e8 92 fb ff ff       	call   80080f <vprintfmt>
  800c7d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c83:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c89:	c9                   	leave  
  800c8a:	c3                   	ret    

00800c8b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c91:	8d 45 10             	lea    0x10(%ebp),%eax
  800c94:	83 c0 04             	add    $0x4,%eax
  800c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca0:	50                   	push   %eax
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	ff 75 08             	pushl  0x8(%ebp)
  800ca7:	e8 89 ff ff ff       	call   800c35 <vsnprintf>
  800cac:	83 c4 10             	add    $0x10,%esp
  800caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb5:	c9                   	leave  
  800cb6:	c3                   	ret    

00800cb7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc4:	eb 06                	jmp    800ccc <strlen+0x15>
		n++;
  800cc6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc9:	ff 45 08             	incl   0x8(%ebp)
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	84 c0                	test   %al,%al
  800cd3:	75 f1                	jne    800cc6 <strlen+0xf>
		n++;
	return n;
  800cd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd8:	c9                   	leave  
  800cd9:	c3                   	ret    

00800cda <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce7:	eb 09                	jmp    800cf2 <strnlen+0x18>
		n++;
  800ce9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cec:	ff 45 08             	incl   0x8(%ebp)
  800cef:	ff 4d 0c             	decl   0xc(%ebp)
  800cf2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf6:	74 09                	je     800d01 <strnlen+0x27>
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	84 c0                	test   %al,%al
  800cff:	75 e8                	jne    800ce9 <strnlen+0xf>
		n++;
	return n;
  800d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d12:	90                   	nop
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8d 50 01             	lea    0x1(%eax),%edx
  800d19:	89 55 08             	mov    %edx,0x8(%ebp)
  800d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d22:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d25:	8a 12                	mov    (%edx),%dl
  800d27:	88 10                	mov    %dl,(%eax)
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	84 c0                	test   %al,%al
  800d2d:	75 e4                	jne    800d13 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d32:	c9                   	leave  
  800d33:	c3                   	ret    

00800d34 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d47:	eb 1f                	jmp    800d68 <strncpy+0x34>
		*dst++ = *src;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8d 50 01             	lea    0x1(%eax),%edx
  800d4f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d55:	8a 12                	mov    (%edx),%dl
  800d57:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	84 c0                	test   %al,%al
  800d60:	74 03                	je     800d65 <strncpy+0x31>
			src++;
  800d62:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d65:	ff 45 fc             	incl   -0x4(%ebp)
  800d68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d6e:	72 d9                	jb     800d49 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d70:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d73:	c9                   	leave  
  800d74:	c3                   	ret    

00800d75 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d85:	74 30                	je     800db7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d87:	eb 16                	jmp    800d9f <strlcpy+0x2a>
			*dst++ = *src++;
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8d 50 01             	lea    0x1(%eax),%edx
  800d8f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d95:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d98:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d9b:	8a 12                	mov    (%edx),%dl
  800d9d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d9f:	ff 4d 10             	decl   0x10(%ebp)
  800da2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da6:	74 09                	je     800db1 <strlcpy+0x3c>
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	84 c0                	test   %al,%al
  800daf:	75 d8                	jne    800d89 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800db7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbd:	29 c2                	sub    %eax,%edx
  800dbf:	89 d0                	mov    %edx,%eax
}
  800dc1:	c9                   	leave  
  800dc2:	c3                   	ret    

00800dc3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dc6:	eb 06                	jmp    800dce <strcmp+0xb>
		p++, q++;
  800dc8:	ff 45 08             	incl   0x8(%ebp)
  800dcb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	84 c0                	test   %al,%al
  800dd5:	74 0e                	je     800de5 <strcmp+0x22>
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 10                	mov    (%eax),%dl
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	38 c2                	cmp    %al,%dl
  800de3:	74 e3                	je     800dc8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f b6 d0             	movzbl %al,%edx
  800ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	0f b6 c0             	movzbl %al,%eax
  800df5:	29 c2                	sub    %eax,%edx
  800df7:	89 d0                	mov    %edx,%eax
}
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dfe:	eb 09                	jmp    800e09 <strncmp+0xe>
		n--, p++, q++;
  800e00:	ff 4d 10             	decl   0x10(%ebp)
  800e03:	ff 45 08             	incl   0x8(%ebp)
  800e06:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0d:	74 17                	je     800e26 <strncmp+0x2b>
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	84 c0                	test   %al,%al
  800e16:	74 0e                	je     800e26 <strncmp+0x2b>
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8a 10                	mov    (%eax),%dl
  800e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	38 c2                	cmp    %al,%dl
  800e24:	74 da                	je     800e00 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2a:	75 07                	jne    800e33 <strncmp+0x38>
		return 0;
  800e2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e31:	eb 14                	jmp    800e47 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	0f b6 d0             	movzbl %al,%edx
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	0f b6 c0             	movzbl %al,%eax
  800e43:	29 c2                	sub    %eax,%edx
  800e45:	89 d0                	mov    %edx,%eax
}
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 04             	sub    $0x4,%esp
  800e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e52:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e55:	eb 12                	jmp    800e69 <strchr+0x20>
		if (*s == c)
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e5f:	75 05                	jne    800e66 <strchr+0x1d>
			return (char *) s;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	eb 11                	jmp    800e77 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e66:	ff 45 08             	incl   0x8(%ebp)
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 e5                	jne    800e57 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 04             	sub    $0x4,%esp
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e85:	eb 0d                	jmp    800e94 <strfind+0x1b>
		if (*s == c)
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e8f:	74 0e                	je     800e9f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e91:	ff 45 08             	incl   0x8(%ebp)
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	84 c0                	test   %al,%al
  800e9b:	75 ea                	jne    800e87 <strfind+0xe>
  800e9d:	eb 01                	jmp    800ea0 <strfind+0x27>
		if (*s == c)
			break;
  800e9f:	90                   	nop
	return (char *) s;
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800eb7:	eb 0e                	jmp    800ec7 <memset+0x22>
		*p++ = c;
  800eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebc:	8d 50 01             	lea    0x1(%eax),%edx
  800ebf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ec7:	ff 4d f8             	decl   -0x8(%ebp)
  800eca:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ece:	79 e9                	jns    800eb9 <memset+0x14>
		*p++ = c;

	return v;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed3:	c9                   	leave  
  800ed4:	c3                   	ret    

00800ed5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ede:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ee7:	eb 16                	jmp    800eff <memcpy+0x2a>
		*d++ = *s++;
  800ee9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eec:	8d 50 01             	lea    0x1(%eax),%edx
  800eef:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ef2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ef5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800efb:	8a 12                	mov    (%edx),%dl
  800efd:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f05:	89 55 10             	mov    %edx,0x10(%ebp)
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	75 dd                	jne    800ee9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0f:	c9                   	leave  
  800f10:	c3                   	ret    

00800f11 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f26:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f29:	73 50                	jae    800f7b <memmove+0x6a>
  800f2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f31:	01 d0                	add    %edx,%eax
  800f33:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f36:	76 43                	jbe    800f7b <memmove+0x6a>
		s += n;
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f41:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f44:	eb 10                	jmp    800f56 <memmove+0x45>
			*--d = *--s;
  800f46:	ff 4d f8             	decl   -0x8(%ebp)
  800f49:	ff 4d fc             	decl   -0x4(%ebp)
  800f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4f:	8a 10                	mov    (%eax),%dl
  800f51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f54:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f56:	8b 45 10             	mov    0x10(%ebp),%eax
  800f59:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f5c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5f:	85 c0                	test   %eax,%eax
  800f61:	75 e3                	jne    800f46 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f63:	eb 23                	jmp    800f88 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f68:	8d 50 01             	lea    0x1(%eax),%edx
  800f6b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f71:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f74:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f77:	8a 12                	mov    (%edx),%dl
  800f79:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f81:	89 55 10             	mov    %edx,0x10(%ebp)
  800f84:	85 c0                	test   %eax,%eax
  800f86:	75 dd                	jne    800f65 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8b:	c9                   	leave  
  800f8c:	c3                   	ret    

00800f8d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f9f:	eb 2a                	jmp    800fcb <memcmp+0x3e>
		if (*s1 != *s2)
  800fa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa4:	8a 10                	mov    (%eax),%dl
  800fa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	38 c2                	cmp    %al,%dl
  800fad:	74 16                	je     800fc5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800faf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	0f b6 d0             	movzbl %al,%edx
  800fb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	0f b6 c0             	movzbl %al,%eax
  800fbf:	29 c2                	sub    %eax,%edx
  800fc1:	89 d0                	mov    %edx,%eax
  800fc3:	eb 18                	jmp    800fdd <memcmp+0x50>
		s1++, s2++;
  800fc5:	ff 45 fc             	incl   -0x4(%ebp)
  800fc8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fce:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd1:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	75 c9                	jne    800fa1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  800feb:	01 d0                	add    %edx,%eax
  800fed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ff0:	eb 15                	jmp    801007 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	0f b6 d0             	movzbl %al,%edx
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	0f b6 c0             	movzbl %al,%eax
  801000:	39 c2                	cmp    %eax,%edx
  801002:	74 0d                	je     801011 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801004:	ff 45 08             	incl   0x8(%ebp)
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80100d:	72 e3                	jb     800ff2 <memfind+0x13>
  80100f:	eb 01                	jmp    801012 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801011:	90                   	nop
	return (void *) s;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80101d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801024:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80102b:	eb 03                	jmp    801030 <strtol+0x19>
		s++;
  80102d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 20                	cmp    $0x20,%al
  801037:	74 f4                	je     80102d <strtol+0x16>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 09                	cmp    $0x9,%al
  801040:	74 eb                	je     80102d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	3c 2b                	cmp    $0x2b,%al
  801049:	75 05                	jne    801050 <strtol+0x39>
		s++;
  80104b:	ff 45 08             	incl   0x8(%ebp)
  80104e:	eb 13                	jmp    801063 <strtol+0x4c>
	else if (*s == '-')
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	3c 2d                	cmp    $0x2d,%al
  801057:	75 0a                	jne    801063 <strtol+0x4c>
		s++, neg = 1;
  801059:	ff 45 08             	incl   0x8(%ebp)
  80105c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801063:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801067:	74 06                	je     80106f <strtol+0x58>
  801069:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80106d:	75 20                	jne    80108f <strtol+0x78>
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	8a 00                	mov    (%eax),%al
  801074:	3c 30                	cmp    $0x30,%al
  801076:	75 17                	jne    80108f <strtol+0x78>
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	40                   	inc    %eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	3c 78                	cmp    $0x78,%al
  801080:	75 0d                	jne    80108f <strtol+0x78>
		s += 2, base = 16;
  801082:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801086:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80108d:	eb 28                	jmp    8010b7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80108f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801093:	75 15                	jne    8010aa <strtol+0x93>
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	3c 30                	cmp    $0x30,%al
  80109c:	75 0c                	jne    8010aa <strtol+0x93>
		s++, base = 8;
  80109e:	ff 45 08             	incl   0x8(%ebp)
  8010a1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010a8:	eb 0d                	jmp    8010b7 <strtol+0xa0>
	else if (base == 0)
  8010aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ae:	75 07                	jne    8010b7 <strtol+0xa0>
		base = 10;
  8010b0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	3c 2f                	cmp    $0x2f,%al
  8010be:	7e 19                	jle    8010d9 <strtol+0xc2>
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	3c 39                	cmp    $0x39,%al
  8010c7:	7f 10                	jg     8010d9 <strtol+0xc2>
			dig = *s - '0';
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	0f be c0             	movsbl %al,%eax
  8010d1:	83 e8 30             	sub    $0x30,%eax
  8010d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010d7:	eb 42                	jmp    80111b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	3c 60                	cmp    $0x60,%al
  8010e0:	7e 19                	jle    8010fb <strtol+0xe4>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 7a                	cmp    $0x7a,%al
  8010e9:	7f 10                	jg     8010fb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	0f be c0             	movsbl %al,%eax
  8010f3:	83 e8 57             	sub    $0x57,%eax
  8010f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f9:	eb 20                	jmp    80111b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	3c 40                	cmp    $0x40,%al
  801102:	7e 39                	jle    80113d <strtol+0x126>
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 5a                	cmp    $0x5a,%al
  80110b:	7f 30                	jg     80113d <strtol+0x126>
			dig = *s - 'A' + 10;
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	0f be c0             	movsbl %al,%eax
  801115:	83 e8 37             	sub    $0x37,%eax
  801118:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80111b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801121:	7d 19                	jge    80113c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801123:	ff 45 08             	incl   0x8(%ebp)
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	0f af 45 10          	imul   0x10(%ebp),%eax
  80112d:	89 c2                	mov    %eax,%edx
  80112f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801137:	e9 7b ff ff ff       	jmp    8010b7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80113c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80113d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801141:	74 08                	je     80114b <strtol+0x134>
		*endptr = (char *) s;
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	8b 55 08             	mov    0x8(%ebp),%edx
  801149:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80114b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114f:	74 07                	je     801158 <strtol+0x141>
  801151:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801154:	f7 d8                	neg    %eax
  801156:	eb 03                	jmp    80115b <strtol+0x144>
  801158:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80115b:	c9                   	leave  
  80115c:	c3                   	ret    

0080115d <ltostr>:

void
ltostr(long value, char *str)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801163:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80116a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801171:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801175:	79 13                	jns    80118a <ltostr+0x2d>
	{
		neg = 1;
  801177:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80117e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801181:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801184:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801187:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801192:	99                   	cltd   
  801193:	f7 f9                	idiv   %ecx
  801195:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801198:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119b:	8d 50 01             	lea    0x1(%eax),%edx
  80119e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011a1:	89 c2                	mov    %eax,%edx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 d0                	add    %edx,%eax
  8011a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ab:	83 c2 30             	add    $0x30,%edx
  8011ae:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011b8:	f7 e9                	imul   %ecx
  8011ba:	c1 fa 02             	sar    $0x2,%edx
  8011bd:	89 c8                	mov    %ecx,%eax
  8011bf:	c1 f8 1f             	sar    $0x1f,%eax
  8011c2:	29 c2                	sub    %eax,%edx
  8011c4:	89 d0                	mov    %edx,%eax
  8011c6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011cc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011d1:	f7 e9                	imul   %ecx
  8011d3:	c1 fa 02             	sar    $0x2,%edx
  8011d6:	89 c8                	mov    %ecx,%eax
  8011d8:	c1 f8 1f             	sar    $0x1f,%eax
  8011db:	29 c2                	sub    %eax,%edx
  8011dd:	89 d0                	mov    %edx,%eax
  8011df:	c1 e0 02             	shl    $0x2,%eax
  8011e2:	01 d0                	add    %edx,%eax
  8011e4:	01 c0                	add    %eax,%eax
  8011e6:	29 c1                	sub    %eax,%ecx
  8011e8:	89 ca                	mov    %ecx,%edx
  8011ea:	85 d2                	test   %edx,%edx
  8011ec:	75 9c                	jne    80118a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f8:	48                   	dec    %eax
  8011f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801200:	74 3d                	je     80123f <ltostr+0xe2>
		start = 1 ;
  801202:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801209:	eb 34                	jmp    80123f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80120b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	01 d0                	add    %edx,%eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121e:	01 c2                	add    %eax,%edx
  801220:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	01 c8                	add    %ecx,%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80122c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80122f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801232:	01 c2                	add    %eax,%edx
  801234:	8a 45 eb             	mov    -0x15(%ebp),%al
  801237:	88 02                	mov    %al,(%edx)
		start++ ;
  801239:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80123c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80123f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801242:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801245:	7c c4                	jl     80120b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801247:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80124a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124d:	01 d0                	add    %edx,%eax
  80124f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801252:	90                   	nop
  801253:	c9                   	leave  
  801254:	c3                   	ret    

00801255 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80125b:	ff 75 08             	pushl  0x8(%ebp)
  80125e:	e8 54 fa ff ff       	call   800cb7 <strlen>
  801263:	83 c4 04             	add    $0x4,%esp
  801266:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801269:	ff 75 0c             	pushl  0xc(%ebp)
  80126c:	e8 46 fa ff ff       	call   800cb7 <strlen>
  801271:	83 c4 04             	add    $0x4,%esp
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801277:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80127e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801285:	eb 17                	jmp    80129e <strcconcat+0x49>
		final[s] = str1[s] ;
  801287:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128a:	8b 45 10             	mov    0x10(%ebp),%eax
  80128d:	01 c2                	add    %eax,%edx
  80128f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	01 c8                	add    %ecx,%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80129b:	ff 45 fc             	incl   -0x4(%ebp)
  80129e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012a4:	7c e1                	jl     801287 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012b4:	eb 1f                	jmp    8012d5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b9:	8d 50 01             	lea    0x1(%eax),%edx
  8012bc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c4:	01 c2                	add    %eax,%edx
  8012c6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 c8                	add    %ecx,%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012d2:	ff 45 f8             	incl   -0x8(%ebp)
  8012d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012db:	7c d9                	jl     8012b6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e3:	01 d0                	add    %edx,%eax
  8012e5:	c6 00 00             	movb   $0x0,(%eax)
}
  8012e8:	90                   	nop
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fa:	8b 00                	mov    (%eax),%eax
  8012fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	01 d0                	add    %edx,%eax
  801308:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80130e:	eb 0c                	jmp    80131c <strsplit+0x31>
			*string++ = 0;
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	8d 50 01             	lea    0x1(%eax),%edx
  801316:	89 55 08             	mov    %edx,0x8(%ebp)
  801319:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	84 c0                	test   %al,%al
  801323:	74 18                	je     80133d <strsplit+0x52>
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	0f be c0             	movsbl %al,%eax
  80132d:	50                   	push   %eax
  80132e:	ff 75 0c             	pushl  0xc(%ebp)
  801331:	e8 13 fb ff ff       	call   800e49 <strchr>
  801336:	83 c4 08             	add    $0x8,%esp
  801339:	85 c0                	test   %eax,%eax
  80133b:	75 d3                	jne    801310 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	84 c0                	test   %al,%al
  801344:	74 5a                	je     8013a0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801346:	8b 45 14             	mov    0x14(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	83 f8 0f             	cmp    $0xf,%eax
  80134e:	75 07                	jne    801357 <strsplit+0x6c>
		{
			return 0;
  801350:	b8 00 00 00 00       	mov    $0x0,%eax
  801355:	eb 66                	jmp    8013bd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801357:	8b 45 14             	mov    0x14(%ebp),%eax
  80135a:	8b 00                	mov    (%eax),%eax
  80135c:	8d 48 01             	lea    0x1(%eax),%ecx
  80135f:	8b 55 14             	mov    0x14(%ebp),%edx
  801362:	89 0a                	mov    %ecx,(%edx)
  801364:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136b:	8b 45 10             	mov    0x10(%ebp),%eax
  80136e:	01 c2                	add    %eax,%edx
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801375:	eb 03                	jmp    80137a <strsplit+0x8f>
			string++;
  801377:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	84 c0                	test   %al,%al
  801381:	74 8b                	je     80130e <strsplit+0x23>
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8a 00                	mov    (%eax),%al
  801388:	0f be c0             	movsbl %al,%eax
  80138b:	50                   	push   %eax
  80138c:	ff 75 0c             	pushl  0xc(%ebp)
  80138f:	e8 b5 fa ff ff       	call   800e49 <strchr>
  801394:	83 c4 08             	add    $0x8,%esp
  801397:	85 c0                	test   %eax,%eax
  801399:	74 dc                	je     801377 <strsplit+0x8c>
			string++;
	}
  80139b:	e9 6e ff ff ff       	jmp    80130e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013a0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a4:	8b 00                	mov    (%eax),%eax
  8013a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b0:	01 d0                	add    %edx,%eax
  8013b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013b8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8013c5:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8013cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013cf:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	48                   	dec    %eax
  8013d5:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8013d8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8013db:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e0:	f7 75 ac             	divl   -0x54(%ebp)
  8013e3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8013e6:	29 d0                	sub    %edx,%eax
  8013e8:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8013eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8013f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8013f9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801400:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801407:	eb 3f                	jmp    801448 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80140c:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801413:	83 ec 04             	sub    $0x4,%esp
  801416:	50                   	push   %eax
  801417:	ff 75 e8             	pushl  -0x18(%ebp)
  80141a:	68 f0 29 80 00       	push   $0x8029f0
  80141f:	e8 11 f2 ff ff       	call   800635 <cprintf>
  801424:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801427:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80142a:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801431:	83 ec 04             	sub    $0x4,%esp
  801434:	50                   	push   %eax
  801435:	ff 75 e8             	pushl  -0x18(%ebp)
  801438:	68 05 2a 80 00       	push   $0x802a05
  80143d:	e8 f3 f1 ff ff       	call   800635 <cprintf>
  801442:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801445:	ff 45 e8             	incl   -0x18(%ebp)
  801448:	a1 28 30 80 00       	mov    0x803028,%eax
  80144d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801450:	7c b7                	jl     801409 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801452:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801459:	e9 42 01 00 00       	jmp    8015a0 <malloc+0x1e1>
		int flag0=1;
  80145e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801468:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80146b:	eb 6b                	jmp    8014d8 <malloc+0x119>
			for(int k=0;k<count;k++){
  80146d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801474:	eb 42                	jmp    8014b8 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801476:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801479:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801480:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801483:	39 c2                	cmp    %eax,%edx
  801485:	77 2e                	ja     8014b5 <malloc+0xf6>
  801487:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80148a:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801491:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801494:	39 c2                	cmp    %eax,%edx
  801496:	76 1d                	jbe    8014b5 <malloc+0xf6>
					ni=arr_add[k].end-i;
  801498:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80149b:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8014a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014a5:	29 c2                	sub    %eax,%edx
  8014a7:	89 d0                	mov    %edx,%eax
  8014a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  8014ac:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8014b3:	eb 0d                	jmp    8014c2 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8014b5:	ff 45 d8             	incl   -0x28(%ebp)
  8014b8:	a1 28 30 80 00       	mov    0x803028,%eax
  8014bd:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8014c0:	7c b4                	jl     801476 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8014c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014c6:	74 09                	je     8014d1 <malloc+0x112>
				flag0=0;
  8014c8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8014cf:	eb 16                	jmp    8014e7 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8014d1:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8014d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	01 c2                	add    %eax,%edx
  8014e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014e3:	39 c2                	cmp    %eax,%edx
  8014e5:	77 86                	ja     80146d <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8014e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014eb:	0f 84 a2 00 00 00    	je     801593 <malloc+0x1d4>

			int f=1;
  8014f1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  8014f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014fb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8014fe:	89 c8                	mov    %ecx,%eax
  801500:	01 c0                	add    %eax,%eax
  801502:	01 c8                	add    %ecx,%eax
  801504:	c1 e0 02             	shl    $0x2,%eax
  801507:	05 20 31 80 00       	add    $0x803120,%eax
  80150c:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  80150e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801517:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151a:	89 d0                	mov    %edx,%eax
  80151c:	01 c0                	add    %eax,%eax
  80151e:	01 d0                	add    %edx,%eax
  801520:	c1 e0 02             	shl    $0x2,%eax
  801523:	05 24 31 80 00       	add    $0x803124,%eax
  801528:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  80152a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80152d:	89 d0                	mov    %edx,%eax
  80152f:	01 c0                	add    %eax,%eax
  801531:	01 d0                	add    %edx,%eax
  801533:	c1 e0 02             	shl    $0x2,%eax
  801536:	05 28 31 80 00       	add    $0x803128,%eax
  80153b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801541:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801544:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80154b:	eb 36                	jmp    801583 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  80154d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	01 c2                	add    %eax,%edx
  801555:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801558:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80155f:	39 c2                	cmp    %eax,%edx
  801561:	73 1d                	jae    801580 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801563:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801566:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80156d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801570:	29 c2                	sub    %eax,%edx
  801572:	89 d0                	mov    %edx,%eax
  801574:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801577:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  80157e:	eb 0d                	jmp    80158d <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801580:	ff 45 d0             	incl   -0x30(%ebp)
  801583:	a1 28 30 80 00       	mov    0x803028,%eax
  801588:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  80158b:	7c c0                	jl     80154d <malloc+0x18e>
					break;

				}
			}

			if(f){
  80158d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801591:	75 1d                	jne    8015b0 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801593:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  80159a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159d:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8015a0:	a1 04 30 80 00       	mov    0x803004,%eax
  8015a5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8015a8:	0f 8c b0 fe ff ff    	jl     80145e <malloc+0x9f>
  8015ae:	eb 01                	jmp    8015b1 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  8015b0:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8015b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015b5:	75 7a                	jne    801631 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  8015b7:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	01 d0                	add    %edx,%eax
  8015c2:	48                   	dec    %eax
  8015c3:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8015c8:	7c 0a                	jl     8015d4 <malloc+0x215>
			return NULL;
  8015ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8015cf:	e9 a4 02 00 00       	jmp    801878 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  8015d4:	a1 04 30 80 00       	mov    0x803004,%eax
  8015d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8015dc:	a1 28 30 80 00       	mov    0x803028,%eax
  8015e1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8015e4:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	ff 75 08             	pushl  0x8(%ebp)
  8015f1:	ff 75 a4             	pushl  -0x5c(%ebp)
  8015f4:	e8 04 06 00 00       	call   801bfd <sys_allocateMem>
  8015f9:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  8015fc:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	01 d0                	add    %edx,%eax
  801607:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  80160c:	a1 28 30 80 00       	mov    0x803028,%eax
  801611:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801617:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  80161e:	a1 28 30 80 00       	mov    0x803028,%eax
  801623:	40                   	inc    %eax
  801624:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  801629:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80162c:	e9 47 02 00 00       	jmp    801878 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801631:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801638:	e9 ac 00 00 00       	jmp    8016e9 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  80163d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801640:	89 d0                	mov    %edx,%eax
  801642:	01 c0                	add    %eax,%eax
  801644:	01 d0                	add    %edx,%eax
  801646:	c1 e0 02             	shl    $0x2,%eax
  801649:	05 24 31 80 00       	add    $0x803124,%eax
  80164e:	8b 00                	mov    (%eax),%eax
  801650:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801653:	eb 7e                	jmp    8016d3 <malloc+0x314>
			int flag=0;
  801655:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  80165c:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801663:	eb 57                	jmp    8016bc <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801665:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801668:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80166f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801672:	39 c2                	cmp    %eax,%edx
  801674:	77 1a                	ja     801690 <malloc+0x2d1>
  801676:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801679:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801680:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801683:	39 c2                	cmp    %eax,%edx
  801685:	76 09                	jbe    801690 <malloc+0x2d1>
								flag=1;
  801687:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  80168e:	eb 36                	jmp    8016c6 <malloc+0x307>
			arr[i].space++;
  801690:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801693:	89 d0                	mov    %edx,%eax
  801695:	01 c0                	add    %eax,%eax
  801697:	01 d0                	add    %edx,%eax
  801699:	c1 e0 02             	shl    $0x2,%eax
  80169c:	05 28 31 80 00       	add    $0x803128,%eax
  8016a1:	8b 00                	mov    (%eax),%eax
  8016a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8016a6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8016a9:	89 d0                	mov    %edx,%eax
  8016ab:	01 c0                	add    %eax,%eax
  8016ad:	01 d0                	add    %edx,%eax
  8016af:	c1 e0 02             	shl    $0x2,%eax
  8016b2:	05 28 31 80 00       	add    $0x803128,%eax
  8016b7:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  8016b9:	ff 45 c0             	incl   -0x40(%ebp)
  8016bc:	a1 28 30 80 00       	mov    0x803028,%eax
  8016c1:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  8016c4:	7c 9f                	jl     801665 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  8016c6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8016ca:	75 19                	jne    8016e5 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8016cc:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8016d3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8016d6:	a1 04 30 80 00       	mov    0x803004,%eax
  8016db:	39 c2                	cmp    %eax,%edx
  8016dd:	0f 82 72 ff ff ff    	jb     801655 <malloc+0x296>
  8016e3:	eb 01                	jmp    8016e6 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  8016e5:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  8016e6:	ff 45 cc             	incl   -0x34(%ebp)
  8016e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8016ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016ef:	0f 8c 48 ff ff ff    	jl     80163d <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  8016f5:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  8016fc:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801703:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  80170a:	eb 37                	jmp    801743 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  80170c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80170f:	89 d0                	mov    %edx,%eax
  801711:	01 c0                	add    %eax,%eax
  801713:	01 d0                	add    %edx,%eax
  801715:	c1 e0 02             	shl    $0x2,%eax
  801718:	05 28 31 80 00       	add    $0x803128,%eax
  80171d:	8b 00                	mov    (%eax),%eax
  80171f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801722:	7d 1c                	jge    801740 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801724:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801727:	89 d0                	mov    %edx,%eax
  801729:	01 c0                	add    %eax,%eax
  80172b:	01 d0                	add    %edx,%eax
  80172d:	c1 e0 02             	shl    $0x2,%eax
  801730:	05 28 31 80 00       	add    $0x803128,%eax
  801735:	8b 00                	mov    (%eax),%eax
  801737:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  80173a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80173d:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801740:	ff 45 b4             	incl   -0x4c(%ebp)
  801743:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801746:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801749:	7c c1                	jl     80170c <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  80174b:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801751:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801754:	89 c8                	mov    %ecx,%eax
  801756:	01 c0                	add    %eax,%eax
  801758:	01 c8                	add    %ecx,%eax
  80175a:	c1 e0 02             	shl    $0x2,%eax
  80175d:	05 20 31 80 00       	add    $0x803120,%eax
  801762:	8b 00                	mov    (%eax),%eax
  801764:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  80176b:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801771:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801774:	89 c8                	mov    %ecx,%eax
  801776:	01 c0                	add    %eax,%eax
  801778:	01 c8                	add    %ecx,%eax
  80177a:	c1 e0 02             	shl    $0x2,%eax
  80177d:	05 24 31 80 00       	add    $0x803124,%eax
  801782:	8b 00                	mov    (%eax),%eax
  801784:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  80178b:	a1 28 30 80 00       	mov    0x803028,%eax
  801790:	40                   	inc    %eax
  801791:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  801796:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801799:	89 d0                	mov    %edx,%eax
  80179b:	01 c0                	add    %eax,%eax
  80179d:	01 d0                	add    %edx,%eax
  80179f:	c1 e0 02             	shl    $0x2,%eax
  8017a2:	05 20 31 80 00       	add    $0x803120,%eax
  8017a7:	8b 00                	mov    (%eax),%eax
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	ff 75 08             	pushl  0x8(%ebp)
  8017af:	50                   	push   %eax
  8017b0:	e8 48 04 00 00       	call   801bfd <sys_allocateMem>
  8017b5:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  8017b8:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8017bf:	eb 78                	jmp    801839 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8017c1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8017c4:	89 d0                	mov    %edx,%eax
  8017c6:	01 c0                	add    %eax,%eax
  8017c8:	01 d0                	add    %edx,%eax
  8017ca:	c1 e0 02             	shl    $0x2,%eax
  8017cd:	05 20 31 80 00       	add    $0x803120,%eax
  8017d2:	8b 00                	mov    (%eax),%eax
  8017d4:	83 ec 04             	sub    $0x4,%esp
  8017d7:	50                   	push   %eax
  8017d8:	ff 75 b0             	pushl  -0x50(%ebp)
  8017db:	68 f0 29 80 00       	push   $0x8029f0
  8017e0:	e8 50 ee ff ff       	call   800635 <cprintf>
  8017e5:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8017e8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8017eb:	89 d0                	mov    %edx,%eax
  8017ed:	01 c0                	add    %eax,%eax
  8017ef:	01 d0                	add    %edx,%eax
  8017f1:	c1 e0 02             	shl    $0x2,%eax
  8017f4:	05 24 31 80 00       	add    $0x803124,%eax
  8017f9:	8b 00                	mov    (%eax),%eax
  8017fb:	83 ec 04             	sub    $0x4,%esp
  8017fe:	50                   	push   %eax
  8017ff:	ff 75 b0             	pushl  -0x50(%ebp)
  801802:	68 05 2a 80 00       	push   $0x802a05
  801807:	e8 29 ee ff ff       	call   800635 <cprintf>
  80180c:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  80180f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801812:	89 d0                	mov    %edx,%eax
  801814:	01 c0                	add    %eax,%eax
  801816:	01 d0                	add    %edx,%eax
  801818:	c1 e0 02             	shl    $0x2,%eax
  80181b:	05 28 31 80 00       	add    $0x803128,%eax
  801820:	8b 00                	mov    (%eax),%eax
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	50                   	push   %eax
  801826:	ff 75 b0             	pushl  -0x50(%ebp)
  801829:	68 18 2a 80 00       	push   $0x802a18
  80182e:	e8 02 ee ff ff       	call   800635 <cprintf>
  801833:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801836:	ff 45 b0             	incl   -0x50(%ebp)
  801839:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80183c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80183f:	7c 80                	jl     8017c1 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801841:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801844:	89 d0                	mov    %edx,%eax
  801846:	01 c0                	add    %eax,%eax
  801848:	01 d0                	add    %edx,%eax
  80184a:	c1 e0 02             	shl    $0x2,%eax
  80184d:	05 20 31 80 00       	add    $0x803120,%eax
  801852:	8b 00                	mov    (%eax),%eax
  801854:	83 ec 08             	sub    $0x8,%esp
  801857:	50                   	push   %eax
  801858:	68 2c 2a 80 00       	push   $0x802a2c
  80185d:	e8 d3 ed ff ff       	call   800635 <cprintf>
  801862:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801865:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801868:	89 d0                	mov    %edx,%eax
  80186a:	01 c0                	add    %eax,%eax
  80186c:	01 d0                	add    %edx,%eax
  80186e:	c1 e0 02             	shl    $0x2,%eax
  801871:	05 20 31 80 00       	add    $0x803120,%eax
  801876:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801886:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80188d:	eb 4b                	jmp    8018da <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  80188f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801892:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801899:	89 c2                	mov    %eax,%edx
  80189b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80189e:	39 c2                	cmp    %eax,%edx
  8018a0:	7f 35                	jg     8018d7 <free+0x5d>
  8018a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a5:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8018ac:	89 c2                	mov    %eax,%edx
  8018ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018b1:	39 c2                	cmp    %eax,%edx
  8018b3:	7e 22                	jle    8018d7 <free+0x5d>
				start=arr_add[i].start;
  8018b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b8:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8018bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8018c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c5:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8018cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8018cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8018d5:	eb 0d                	jmp    8018e4 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8018d7:	ff 45 ec             	incl   -0x14(%ebp)
  8018da:	a1 28 30 80 00       	mov    0x803028,%eax
  8018df:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8018e2:	7c ab                	jl     80188f <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8018e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e7:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8018ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f1:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8018f8:	29 c2                	sub    %eax,%edx
  8018fa:	89 d0                	mov    %edx,%eax
  8018fc:	83 ec 08             	sub    $0x8,%esp
  8018ff:	50                   	push   %eax
  801900:	ff 75 f4             	pushl  -0xc(%ebp)
  801903:	e8 d9 02 00 00       	call   801be1 <sys_freeMem>
  801908:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  80190b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801911:	eb 2d                	jmp    801940 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801913:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801916:	40                   	inc    %eax
  801917:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80191e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801921:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801928:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80192b:	40                   	inc    %eax
  80192c:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801933:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801936:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  80193d:	ff 45 e8             	incl   -0x18(%ebp)
  801940:	a1 28 30 80 00       	mov    0x803028,%eax
  801945:	48                   	dec    %eax
  801946:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801949:	7f c8                	jg     801913 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  80194b:	a1 28 30 80 00       	mov    0x803028,%eax
  801950:	48                   	dec    %eax
  801951:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801956:	90                   	nop
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	83 ec 18             	sub    $0x18,%esp
  80195f:	8b 45 10             	mov    0x10(%ebp),%eax
  801962:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801965:	83 ec 04             	sub    $0x4,%esp
  801968:	68 48 2a 80 00       	push   $0x802a48
  80196d:	68 18 01 00 00       	push   $0x118
  801972:	68 6b 2a 80 00       	push   $0x802a6b
  801977:	e8 17 ea ff ff       	call   800393 <_panic>

0080197c <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	68 48 2a 80 00       	push   $0x802a48
  80198a:	68 1e 01 00 00       	push   $0x11e
  80198f:	68 6b 2a 80 00       	push   $0x802a6b
  801994:	e8 fa e9 ff ff       	call   800393 <_panic>

00801999 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	68 48 2a 80 00       	push   $0x802a48
  8019a7:	68 24 01 00 00       	push   $0x124
  8019ac:	68 6b 2a 80 00       	push   $0x802a6b
  8019b1:	e8 dd e9 ff ff       	call   800393 <_panic>

008019b6 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019bc:	83 ec 04             	sub    $0x4,%esp
  8019bf:	68 48 2a 80 00       	push   $0x802a48
  8019c4:	68 29 01 00 00       	push   $0x129
  8019c9:	68 6b 2a 80 00       	push   $0x802a6b
  8019ce:	e8 c0 e9 ff ff       	call   800393 <_panic>

008019d3 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	68 48 2a 80 00       	push   $0x802a48
  8019e1:	68 2f 01 00 00       	push   $0x12f
  8019e6:	68 6b 2a 80 00       	push   $0x802a6b
  8019eb:	e8 a3 e9 ff ff       	call   800393 <_panic>

008019f0 <shrink>:
}
void shrink(uint32 newSize)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	68 48 2a 80 00       	push   $0x802a48
  8019fe:	68 33 01 00 00       	push   $0x133
  801a03:	68 6b 2a 80 00       	push   $0x802a6b
  801a08:	e8 86 e9 ff ff       	call   800393 <_panic>

00801a0d <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a13:	83 ec 04             	sub    $0x4,%esp
  801a16:	68 48 2a 80 00       	push   $0x802a48
  801a1b:	68 38 01 00 00       	push   $0x138
  801a20:	68 6b 2a 80 00       	push   $0x802a6b
  801a25:	e8 69 e9 ff ff       	call   800393 <_panic>

00801a2a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	57                   	push   %edi
  801a2e:	56                   	push   %esi
  801a2f:	53                   	push   %ebx
  801a30:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a3c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a3f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a42:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a45:	cd 30                	int    $0x30
  801a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a4d:	83 c4 10             	add    $0x10,%esp
  801a50:	5b                   	pop    %ebx
  801a51:	5e                   	pop    %esi
  801a52:	5f                   	pop    %edi
  801a53:	5d                   	pop    %ebp
  801a54:	c3                   	ret    

00801a55 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 04             	sub    $0x4,%esp
  801a5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a61:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	52                   	push   %edx
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	50                   	push   %eax
  801a71:	6a 00                	push   $0x0
  801a73:	e8 b2 ff ff ff       	call   801a2a <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	90                   	nop
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_cgetc>:

int
sys_cgetc(void)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 01                	push   $0x1
  801a8d:	e8 98 ff ff ff       	call   801a2a <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	50                   	push   %eax
  801aa6:	6a 05                	push   $0x5
  801aa8:	e8 7d ff ff ff       	call   801a2a <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 02                	push   $0x2
  801ac1:	e8 64 ff ff ff       	call   801a2a <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 03                	push   $0x3
  801ada:	e8 4b ff ff ff       	call   801a2a <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 04                	push   $0x4
  801af3:	e8 32 ff ff ff       	call   801a2a <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_env_exit>:


void sys_env_exit(void)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 06                	push   $0x6
  801b0c:	e8 19 ff ff ff       	call   801a2a <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	90                   	nop
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	52                   	push   %edx
  801b27:	50                   	push   %eax
  801b28:	6a 07                	push   $0x7
  801b2a:	e8 fb fe ff ff       	call   801a2a <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	56                   	push   %esi
  801b38:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b39:	8b 75 18             	mov    0x18(%ebp),%esi
  801b3c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	56                   	push   %esi
  801b49:	53                   	push   %ebx
  801b4a:	51                   	push   %ecx
  801b4b:	52                   	push   %edx
  801b4c:	50                   	push   %eax
  801b4d:	6a 08                	push   $0x8
  801b4f:	e8 d6 fe ff ff       	call   801a2a <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b5a:	5b                   	pop    %ebx
  801b5b:	5e                   	pop    %esi
  801b5c:	5d                   	pop    %ebp
  801b5d:	c3                   	ret    

00801b5e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	52                   	push   %edx
  801b6e:	50                   	push   %eax
  801b6f:	6a 09                	push   $0x9
  801b71:	e8 b4 fe ff ff       	call   801a2a <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	ff 75 0c             	pushl  0xc(%ebp)
  801b87:	ff 75 08             	pushl  0x8(%ebp)
  801b8a:	6a 0a                	push   $0xa
  801b8c:	e8 99 fe ff ff       	call   801a2a <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 0b                	push   $0xb
  801ba5:	e8 80 fe ff ff       	call   801a2a <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 0c                	push   $0xc
  801bbe:	e8 67 fe ff ff       	call   801a2a <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 0d                	push   $0xd
  801bd7:	e8 4e fe ff ff       	call   801a2a <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	ff 75 0c             	pushl  0xc(%ebp)
  801bed:	ff 75 08             	pushl  0x8(%ebp)
  801bf0:	6a 11                	push   $0x11
  801bf2:	e8 33 fe ff ff       	call   801a2a <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
	return;
  801bfa:	90                   	nop
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	ff 75 0c             	pushl  0xc(%ebp)
  801c09:	ff 75 08             	pushl  0x8(%ebp)
  801c0c:	6a 12                	push   $0x12
  801c0e:	e8 17 fe ff ff       	call   801a2a <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
	return ;
  801c16:	90                   	nop
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 0e                	push   $0xe
  801c28:	e8 fd fd ff ff       	call   801a2a <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	ff 75 08             	pushl  0x8(%ebp)
  801c40:	6a 0f                	push   $0xf
  801c42:	e8 e3 fd ff ff       	call   801a2a <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 10                	push   $0x10
  801c5b:	e8 ca fd ff ff       	call   801a2a <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
}
  801c63:	90                   	nop
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 14                	push   $0x14
  801c75:	e8 b0 fd ff ff       	call   801a2a <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	90                   	nop
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 15                	push   $0x15
  801c8f:	e8 96 fd ff ff       	call   801a2a <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	90                   	nop
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_cputc>:


void
sys_cputc(const char c)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 04             	sub    $0x4,%esp
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ca6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	50                   	push   %eax
  801cb3:	6a 16                	push   $0x16
  801cb5:	e8 70 fd ff ff       	call   801a2a <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	90                   	nop
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 17                	push   $0x17
  801ccf:	e8 56 fd ff ff       	call   801a2a <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	90                   	nop
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	ff 75 0c             	pushl  0xc(%ebp)
  801ce9:	50                   	push   %eax
  801cea:	6a 18                	push   $0x18
  801cec:	e8 39 fd ff ff       	call   801a2a <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	52                   	push   %edx
  801d06:	50                   	push   %eax
  801d07:	6a 1b                	push   $0x1b
  801d09:	e8 1c fd ff ff       	call   801a2a <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	52                   	push   %edx
  801d23:	50                   	push   %eax
  801d24:	6a 19                	push   $0x19
  801d26:	e8 ff fc ff ff       	call   801a2a <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
}
  801d2e:	90                   	nop
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	52                   	push   %edx
  801d41:	50                   	push   %eax
  801d42:	6a 1a                	push   $0x1a
  801d44:	e8 e1 fc ff ff       	call   801a2a <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
}
  801d4c:	90                   	nop
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	83 ec 04             	sub    $0x4,%esp
  801d55:	8b 45 10             	mov    0x10(%ebp),%eax
  801d58:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d5b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d5e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	6a 00                	push   $0x0
  801d67:	51                   	push   %ecx
  801d68:	52                   	push   %edx
  801d69:	ff 75 0c             	pushl  0xc(%ebp)
  801d6c:	50                   	push   %eax
  801d6d:	6a 1c                	push   $0x1c
  801d6f:	e8 b6 fc ff ff       	call   801a2a <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	52                   	push   %edx
  801d89:	50                   	push   %eax
  801d8a:	6a 1d                	push   $0x1d
  801d8c:	e8 99 fc ff ff       	call   801a2a <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	51                   	push   %ecx
  801da7:	52                   	push   %edx
  801da8:	50                   	push   %eax
  801da9:	6a 1e                	push   $0x1e
  801dab:	e8 7a fc ff ff       	call   801a2a <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	52                   	push   %edx
  801dc5:	50                   	push   %eax
  801dc6:	6a 1f                	push   $0x1f
  801dc8:	e8 5d fc ff ff       	call   801a2a <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 20                	push   $0x20
  801de1:	e8 44 fc ff ff       	call   801a2a <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	6a 00                	push   $0x0
  801df3:	ff 75 14             	pushl  0x14(%ebp)
  801df6:	ff 75 10             	pushl  0x10(%ebp)
  801df9:	ff 75 0c             	pushl  0xc(%ebp)
  801dfc:	50                   	push   %eax
  801dfd:	6a 21                	push   $0x21
  801dff:	e8 26 fc ff ff       	call   801a2a <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	50                   	push   %eax
  801e18:	6a 22                	push   $0x22
  801e1a:	e8 0b fc ff ff       	call   801a2a <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	90                   	nop
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	50                   	push   %eax
  801e34:	6a 23                	push   $0x23
  801e36:	e8 ef fb ff ff       	call   801a2a <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
}
  801e3e:	90                   	nop
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e47:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e4a:	8d 50 04             	lea    0x4(%eax),%edx
  801e4d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	52                   	push   %edx
  801e57:	50                   	push   %eax
  801e58:	6a 24                	push   $0x24
  801e5a:	e8 cb fb ff ff       	call   801a2a <syscall>
  801e5f:	83 c4 18             	add    $0x18,%esp
	return result;
  801e62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e68:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e6b:	89 01                	mov    %eax,(%ecx)
  801e6d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	c9                   	leave  
  801e74:	c2 04 00             	ret    $0x4

00801e77 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	ff 75 10             	pushl  0x10(%ebp)
  801e81:	ff 75 0c             	pushl  0xc(%ebp)
  801e84:	ff 75 08             	pushl  0x8(%ebp)
  801e87:	6a 13                	push   $0x13
  801e89:	e8 9c fb ff ff       	call   801a2a <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e91:	90                   	nop
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 25                	push   $0x25
  801ea3:	e8 82 fb ff ff       	call   801a2a <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	83 ec 04             	sub    $0x4,%esp
  801eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801eb9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	50                   	push   %eax
  801ec6:	6a 26                	push   $0x26
  801ec8:	e8 5d fb ff ff       	call   801a2a <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed0:	90                   	nop
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <rsttst>:
void rsttst()
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 28                	push   $0x28
  801ee2:	e8 43 fb ff ff       	call   801a2a <syscall>
  801ee7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eea:	90                   	nop
}
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
  801ef0:	83 ec 04             	sub    $0x4,%esp
  801ef3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ef9:	8b 55 18             	mov    0x18(%ebp),%edx
  801efc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f00:	52                   	push   %edx
  801f01:	50                   	push   %eax
  801f02:	ff 75 10             	pushl  0x10(%ebp)
  801f05:	ff 75 0c             	pushl  0xc(%ebp)
  801f08:	ff 75 08             	pushl  0x8(%ebp)
  801f0b:	6a 27                	push   $0x27
  801f0d:	e8 18 fb ff ff       	call   801a2a <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
	return ;
  801f15:	90                   	nop
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <chktst>:
void chktst(uint32 n)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	ff 75 08             	pushl  0x8(%ebp)
  801f26:	6a 29                	push   $0x29
  801f28:	e8 fd fa ff ff       	call   801a2a <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f30:	90                   	nop
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <inctst>:

void inctst()
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 2a                	push   $0x2a
  801f42:	e8 e3 fa ff ff       	call   801a2a <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4a:	90                   	nop
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <gettst>:
uint32 gettst()
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 2b                	push   $0x2b
  801f5c:	e8 c9 fa ff ff       	call   801a2a <syscall>
  801f61:	83 c4 18             	add    $0x18,%esp
}
  801f64:	c9                   	leave  
  801f65:	c3                   	ret    

00801f66 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 2c                	push   $0x2c
  801f78:	e8 ad fa ff ff       	call   801a2a <syscall>
  801f7d:	83 c4 18             	add    $0x18,%esp
  801f80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f83:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f87:	75 07                	jne    801f90 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f89:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8e:	eb 05                	jmp    801f95 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 2c                	push   $0x2c
  801fa9:	e8 7c fa ff ff       	call   801a2a <syscall>
  801fae:	83 c4 18             	add    $0x18,%esp
  801fb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fb4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fb8:	75 07                	jne    801fc1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fba:	b8 01 00 00 00       	mov    $0x1,%eax
  801fbf:	eb 05                	jmp    801fc6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 2c                	push   $0x2c
  801fda:	e8 4b fa ff ff       	call   801a2a <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
  801fe2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fe5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fe9:	75 07                	jne    801ff2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801feb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff0:	eb 05                	jmp    801ff7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ff2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 2c                	push   $0x2c
  80200b:	e8 1a fa ff ff       	call   801a2a <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
  802013:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802016:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80201a:	75 07                	jne    802023 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80201c:	b8 01 00 00 00       	mov    $0x1,%eax
  802021:	eb 05                	jmp    802028 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802023:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	ff 75 08             	pushl  0x8(%ebp)
  802038:	6a 2d                	push   $0x2d
  80203a:	e8 eb f9 ff ff       	call   801a2a <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
	return ;
  802042:	90                   	nop
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802049:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80204c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80204f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	6a 00                	push   $0x0
  802057:	53                   	push   %ebx
  802058:	51                   	push   %ecx
  802059:	52                   	push   %edx
  80205a:	50                   	push   %eax
  80205b:	6a 2e                	push   $0x2e
  80205d:	e8 c8 f9 ff ff       	call   801a2a <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80206d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	52                   	push   %edx
  80207a:	50                   	push   %eax
  80207b:	6a 2f                	push   $0x2f
  80207d:	e8 a8 f9 ff ff       	call   801a2a <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    
  802087:	90                   	nop

00802088 <__udivdi3>:
  802088:	55                   	push   %ebp
  802089:	57                   	push   %edi
  80208a:	56                   	push   %esi
  80208b:	53                   	push   %ebx
  80208c:	83 ec 1c             	sub    $0x1c,%esp
  80208f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802093:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802097:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80209b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80209f:	89 ca                	mov    %ecx,%edx
  8020a1:	89 f8                	mov    %edi,%eax
  8020a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020a7:	85 f6                	test   %esi,%esi
  8020a9:	75 2d                	jne    8020d8 <__udivdi3+0x50>
  8020ab:	39 cf                	cmp    %ecx,%edi
  8020ad:	77 65                	ja     802114 <__udivdi3+0x8c>
  8020af:	89 fd                	mov    %edi,%ebp
  8020b1:	85 ff                	test   %edi,%edi
  8020b3:	75 0b                	jne    8020c0 <__udivdi3+0x38>
  8020b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ba:	31 d2                	xor    %edx,%edx
  8020bc:	f7 f7                	div    %edi
  8020be:	89 c5                	mov    %eax,%ebp
  8020c0:	31 d2                	xor    %edx,%edx
  8020c2:	89 c8                	mov    %ecx,%eax
  8020c4:	f7 f5                	div    %ebp
  8020c6:	89 c1                	mov    %eax,%ecx
  8020c8:	89 d8                	mov    %ebx,%eax
  8020ca:	f7 f5                	div    %ebp
  8020cc:	89 cf                	mov    %ecx,%edi
  8020ce:	89 fa                	mov    %edi,%edx
  8020d0:	83 c4 1c             	add    $0x1c,%esp
  8020d3:	5b                   	pop    %ebx
  8020d4:	5e                   	pop    %esi
  8020d5:	5f                   	pop    %edi
  8020d6:	5d                   	pop    %ebp
  8020d7:	c3                   	ret    
  8020d8:	39 ce                	cmp    %ecx,%esi
  8020da:	77 28                	ja     802104 <__udivdi3+0x7c>
  8020dc:	0f bd fe             	bsr    %esi,%edi
  8020df:	83 f7 1f             	xor    $0x1f,%edi
  8020e2:	75 40                	jne    802124 <__udivdi3+0x9c>
  8020e4:	39 ce                	cmp    %ecx,%esi
  8020e6:	72 0a                	jb     8020f2 <__udivdi3+0x6a>
  8020e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8020ec:	0f 87 9e 00 00 00    	ja     802190 <__udivdi3+0x108>
  8020f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f7:	89 fa                	mov    %edi,%edx
  8020f9:	83 c4 1c             	add    $0x1c,%esp
  8020fc:	5b                   	pop    %ebx
  8020fd:	5e                   	pop    %esi
  8020fe:	5f                   	pop    %edi
  8020ff:	5d                   	pop    %ebp
  802100:	c3                   	ret    
  802101:	8d 76 00             	lea    0x0(%esi),%esi
  802104:	31 ff                	xor    %edi,%edi
  802106:	31 c0                	xor    %eax,%eax
  802108:	89 fa                	mov    %edi,%edx
  80210a:	83 c4 1c             	add    $0x1c,%esp
  80210d:	5b                   	pop    %ebx
  80210e:	5e                   	pop    %esi
  80210f:	5f                   	pop    %edi
  802110:	5d                   	pop    %ebp
  802111:	c3                   	ret    
  802112:	66 90                	xchg   %ax,%ax
  802114:	89 d8                	mov    %ebx,%eax
  802116:	f7 f7                	div    %edi
  802118:	31 ff                	xor    %edi,%edi
  80211a:	89 fa                	mov    %edi,%edx
  80211c:	83 c4 1c             	add    $0x1c,%esp
  80211f:	5b                   	pop    %ebx
  802120:	5e                   	pop    %esi
  802121:	5f                   	pop    %edi
  802122:	5d                   	pop    %ebp
  802123:	c3                   	ret    
  802124:	bd 20 00 00 00       	mov    $0x20,%ebp
  802129:	89 eb                	mov    %ebp,%ebx
  80212b:	29 fb                	sub    %edi,%ebx
  80212d:	89 f9                	mov    %edi,%ecx
  80212f:	d3 e6                	shl    %cl,%esi
  802131:	89 c5                	mov    %eax,%ebp
  802133:	88 d9                	mov    %bl,%cl
  802135:	d3 ed                	shr    %cl,%ebp
  802137:	89 e9                	mov    %ebp,%ecx
  802139:	09 f1                	or     %esi,%ecx
  80213b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80213f:	89 f9                	mov    %edi,%ecx
  802141:	d3 e0                	shl    %cl,%eax
  802143:	89 c5                	mov    %eax,%ebp
  802145:	89 d6                	mov    %edx,%esi
  802147:	88 d9                	mov    %bl,%cl
  802149:	d3 ee                	shr    %cl,%esi
  80214b:	89 f9                	mov    %edi,%ecx
  80214d:	d3 e2                	shl    %cl,%edx
  80214f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802153:	88 d9                	mov    %bl,%cl
  802155:	d3 e8                	shr    %cl,%eax
  802157:	09 c2                	or     %eax,%edx
  802159:	89 d0                	mov    %edx,%eax
  80215b:	89 f2                	mov    %esi,%edx
  80215d:	f7 74 24 0c          	divl   0xc(%esp)
  802161:	89 d6                	mov    %edx,%esi
  802163:	89 c3                	mov    %eax,%ebx
  802165:	f7 e5                	mul    %ebp
  802167:	39 d6                	cmp    %edx,%esi
  802169:	72 19                	jb     802184 <__udivdi3+0xfc>
  80216b:	74 0b                	je     802178 <__udivdi3+0xf0>
  80216d:	89 d8                	mov    %ebx,%eax
  80216f:	31 ff                	xor    %edi,%edi
  802171:	e9 58 ff ff ff       	jmp    8020ce <__udivdi3+0x46>
  802176:	66 90                	xchg   %ax,%ax
  802178:	8b 54 24 08          	mov    0x8(%esp),%edx
  80217c:	89 f9                	mov    %edi,%ecx
  80217e:	d3 e2                	shl    %cl,%edx
  802180:	39 c2                	cmp    %eax,%edx
  802182:	73 e9                	jae    80216d <__udivdi3+0xe5>
  802184:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802187:	31 ff                	xor    %edi,%edi
  802189:	e9 40 ff ff ff       	jmp    8020ce <__udivdi3+0x46>
  80218e:	66 90                	xchg   %ax,%ax
  802190:	31 c0                	xor    %eax,%eax
  802192:	e9 37 ff ff ff       	jmp    8020ce <__udivdi3+0x46>
  802197:	90                   	nop

00802198 <__umoddi3>:
  802198:	55                   	push   %ebp
  802199:	57                   	push   %edi
  80219a:	56                   	push   %esi
  80219b:	53                   	push   %ebx
  80219c:	83 ec 1c             	sub    $0x1c,%esp
  80219f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021b7:	89 f3                	mov    %esi,%ebx
  8021b9:	89 fa                	mov    %edi,%edx
  8021bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021bf:	89 34 24             	mov    %esi,(%esp)
  8021c2:	85 c0                	test   %eax,%eax
  8021c4:	75 1a                	jne    8021e0 <__umoddi3+0x48>
  8021c6:	39 f7                	cmp    %esi,%edi
  8021c8:	0f 86 a2 00 00 00    	jbe    802270 <__umoddi3+0xd8>
  8021ce:	89 c8                	mov    %ecx,%eax
  8021d0:	89 f2                	mov    %esi,%edx
  8021d2:	f7 f7                	div    %edi
  8021d4:	89 d0                	mov    %edx,%eax
  8021d6:	31 d2                	xor    %edx,%edx
  8021d8:	83 c4 1c             	add    $0x1c,%esp
  8021db:	5b                   	pop    %ebx
  8021dc:	5e                   	pop    %esi
  8021dd:	5f                   	pop    %edi
  8021de:	5d                   	pop    %ebp
  8021df:	c3                   	ret    
  8021e0:	39 f0                	cmp    %esi,%eax
  8021e2:	0f 87 ac 00 00 00    	ja     802294 <__umoddi3+0xfc>
  8021e8:	0f bd e8             	bsr    %eax,%ebp
  8021eb:	83 f5 1f             	xor    $0x1f,%ebp
  8021ee:	0f 84 ac 00 00 00    	je     8022a0 <__umoddi3+0x108>
  8021f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8021f9:	29 ef                	sub    %ebp,%edi
  8021fb:	89 fe                	mov    %edi,%esi
  8021fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802201:	89 e9                	mov    %ebp,%ecx
  802203:	d3 e0                	shl    %cl,%eax
  802205:	89 d7                	mov    %edx,%edi
  802207:	89 f1                	mov    %esi,%ecx
  802209:	d3 ef                	shr    %cl,%edi
  80220b:	09 c7                	or     %eax,%edi
  80220d:	89 e9                	mov    %ebp,%ecx
  80220f:	d3 e2                	shl    %cl,%edx
  802211:	89 14 24             	mov    %edx,(%esp)
  802214:	89 d8                	mov    %ebx,%eax
  802216:	d3 e0                	shl    %cl,%eax
  802218:	89 c2                	mov    %eax,%edx
  80221a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80221e:	d3 e0                	shl    %cl,%eax
  802220:	89 44 24 04          	mov    %eax,0x4(%esp)
  802224:	8b 44 24 08          	mov    0x8(%esp),%eax
  802228:	89 f1                	mov    %esi,%ecx
  80222a:	d3 e8                	shr    %cl,%eax
  80222c:	09 d0                	or     %edx,%eax
  80222e:	d3 eb                	shr    %cl,%ebx
  802230:	89 da                	mov    %ebx,%edx
  802232:	f7 f7                	div    %edi
  802234:	89 d3                	mov    %edx,%ebx
  802236:	f7 24 24             	mull   (%esp)
  802239:	89 c6                	mov    %eax,%esi
  80223b:	89 d1                	mov    %edx,%ecx
  80223d:	39 d3                	cmp    %edx,%ebx
  80223f:	0f 82 87 00 00 00    	jb     8022cc <__umoddi3+0x134>
  802245:	0f 84 91 00 00 00    	je     8022dc <__umoddi3+0x144>
  80224b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80224f:	29 f2                	sub    %esi,%edx
  802251:	19 cb                	sbb    %ecx,%ebx
  802253:	89 d8                	mov    %ebx,%eax
  802255:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802259:	d3 e0                	shl    %cl,%eax
  80225b:	89 e9                	mov    %ebp,%ecx
  80225d:	d3 ea                	shr    %cl,%edx
  80225f:	09 d0                	or     %edx,%eax
  802261:	89 e9                	mov    %ebp,%ecx
  802263:	d3 eb                	shr    %cl,%ebx
  802265:	89 da                	mov    %ebx,%edx
  802267:	83 c4 1c             	add    $0x1c,%esp
  80226a:	5b                   	pop    %ebx
  80226b:	5e                   	pop    %esi
  80226c:	5f                   	pop    %edi
  80226d:	5d                   	pop    %ebp
  80226e:	c3                   	ret    
  80226f:	90                   	nop
  802270:	89 fd                	mov    %edi,%ebp
  802272:	85 ff                	test   %edi,%edi
  802274:	75 0b                	jne    802281 <__umoddi3+0xe9>
  802276:	b8 01 00 00 00       	mov    $0x1,%eax
  80227b:	31 d2                	xor    %edx,%edx
  80227d:	f7 f7                	div    %edi
  80227f:	89 c5                	mov    %eax,%ebp
  802281:	89 f0                	mov    %esi,%eax
  802283:	31 d2                	xor    %edx,%edx
  802285:	f7 f5                	div    %ebp
  802287:	89 c8                	mov    %ecx,%eax
  802289:	f7 f5                	div    %ebp
  80228b:	89 d0                	mov    %edx,%eax
  80228d:	e9 44 ff ff ff       	jmp    8021d6 <__umoddi3+0x3e>
  802292:	66 90                	xchg   %ax,%ax
  802294:	89 c8                	mov    %ecx,%eax
  802296:	89 f2                	mov    %esi,%edx
  802298:	83 c4 1c             	add    $0x1c,%esp
  80229b:	5b                   	pop    %ebx
  80229c:	5e                   	pop    %esi
  80229d:	5f                   	pop    %edi
  80229e:	5d                   	pop    %ebp
  80229f:	c3                   	ret    
  8022a0:	3b 04 24             	cmp    (%esp),%eax
  8022a3:	72 06                	jb     8022ab <__umoddi3+0x113>
  8022a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8022a9:	77 0f                	ja     8022ba <__umoddi3+0x122>
  8022ab:	89 f2                	mov    %esi,%edx
  8022ad:	29 f9                	sub    %edi,%ecx
  8022af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8022b3:	89 14 24             	mov    %edx,(%esp)
  8022b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022be:	8b 14 24             	mov    (%esp),%edx
  8022c1:	83 c4 1c             	add    $0x1c,%esp
  8022c4:	5b                   	pop    %ebx
  8022c5:	5e                   	pop    %esi
  8022c6:	5f                   	pop    %edi
  8022c7:	5d                   	pop    %ebp
  8022c8:	c3                   	ret    
  8022c9:	8d 76 00             	lea    0x0(%esi),%esi
  8022cc:	2b 04 24             	sub    (%esp),%eax
  8022cf:	19 fa                	sbb    %edi,%edx
  8022d1:	89 d1                	mov    %edx,%ecx
  8022d3:	89 c6                	mov    %eax,%esi
  8022d5:	e9 71 ff ff ff       	jmp    80224b <__umoddi3+0xb3>
  8022da:	66 90                	xchg   %ax,%ax
  8022dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8022e0:	72 ea                	jb     8022cc <__umoddi3+0x134>
  8022e2:	89 d9                	mov    %ebx,%ecx
  8022e4:	e9 62 ff ff ff       	jmp    80224b <__umoddi3+0xb3>
