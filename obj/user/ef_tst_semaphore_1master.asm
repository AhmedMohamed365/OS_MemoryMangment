
obj/user/ef_tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 f8 01 00 00       	call   80022e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int envID = sys_getenvid();
  80003e:	e8 4f 1a 00 00       	call   801a92 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 e0 22 80 00       	push   $0x8022e0
  800050:	e8 65 1c 00 00       	call   801cba <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 e4 22 80 00       	push   $0x8022e4
  800062:	e8 53 1c 00 00       	call   801cba <sys_createSemaphore>
  800067:	83 c4 10             	add    $0x10,%esp

	int id1, id2, id3;
	id1 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80006a:	a1 20 30 80 00       	mov    0x803020,%eax
  80006f:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  800075:	89 c2                	mov    %eax,%edx
  800077:	a1 20 30 80 00       	mov    0x803020,%eax
  80007c:	8b 40 74             	mov    0x74(%eax),%eax
  80007f:	6a 32                	push   $0x32
  800081:	52                   	push   %edx
  800082:	50                   	push   %eax
  800083:	68 ec 22 80 00       	push   $0x8022ec
  800088:	e8 3e 1d 00 00       	call   801dcb <sys_create_env>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800093:	a1 20 30 80 00       	mov    0x803020,%eax
  800098:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  80009e:	89 c2                	mov    %eax,%edx
  8000a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a5:	8b 40 74             	mov    0x74(%eax),%eax
  8000a8:	6a 32                	push   $0x32
  8000aa:	52                   	push   %edx
  8000ab:	50                   	push   %eax
  8000ac:	68 ec 22 80 00       	push   $0x8022ec
  8000b1:	e8 15 1d 00 00       	call   801dcb <sys_create_env>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000bc:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c1:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ce:	8b 40 74             	mov    0x74(%eax),%eax
  8000d1:	6a 32                	push   $0x32
  8000d3:	52                   	push   %edx
  8000d4:	50                   	push   %eax
  8000d5:	68 ec 22 80 00       	push   $0x8022ec
  8000da:	e8 ec 1c 00 00       	call   801dcb <sys_create_env>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR || id3 == E_ENV_CREATION_ERROR)
  8000e5:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000e9:	74 0c                	je     8000f7 <_main+0xbf>
  8000eb:	83 7d ec ef          	cmpl   $0xffffffef,-0x14(%ebp)
  8000ef:	74 06                	je     8000f7 <_main+0xbf>
  8000f1:	83 7d e8 ef          	cmpl   $0xffffffef,-0x18(%ebp)
  8000f5:	75 14                	jne    80010b <_main+0xd3>
		panic("NO AVAILABLE ENVs...");
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 f9 22 80 00       	push   $0x8022f9
  8000ff:	6a 13                	push   $0x13
  800101:	68 10 23 80 00       	push   $0x802310
  800106:	e8 68 02 00 00       	call   800373 <_panic>

	sys_run_env(id1);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 f0             	pushl  -0x10(%ebp)
  800111:	e8 d3 1c 00 00       	call   801de9 <sys_run_env>
  800116:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 75 ec             	pushl  -0x14(%ebp)
  80011f:	e8 c5 1c 00 00       	call   801de9 <sys_run_env>
  800124:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 e8             	pushl  -0x18(%ebp)
  80012d:	e8 b7 1c 00 00       	call   801de9 <sys_run_env>
  800132:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 e4 22 80 00       	push   $0x8022e4
  80013d:	ff 75 f4             	pushl  -0xc(%ebp)
  800140:	e8 ae 1b 00 00       	call   801cf3 <sys_waitSemaphore>
  800145:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 e4 22 80 00       	push   $0x8022e4
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	e8 9b 1b 00 00       	call   801cf3 <sys_waitSemaphore>
  800158:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 e4 22 80 00       	push   $0x8022e4
  800163:	ff 75 f4             	pushl  -0xc(%ebp)
  800166:	e8 88 1b 00 00       	call   801cf3 <sys_waitSemaphore>
  80016b:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	68 e0 22 80 00       	push   $0x8022e0
  800176:	ff 75 f4             	pushl  -0xc(%ebp)
  800179:	e8 58 1b 00 00       	call   801cd6 <sys_getSemaphoreValue>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	68 e4 22 80 00       	push   $0x8022e4
  80018c:	ff 75 f4             	pushl  -0xc(%ebp)
  80018f:	e8 42 1b 00 00       	call   801cd6 <sys_getSemaphoreValue>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80019a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80019e:	75 18                	jne    8001b8 <_main+0x180>
  8001a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8001a4:	75 12                	jne    8001b8 <_main+0x180>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	68 30 23 80 00       	push   $0x802330
  8001ae:	e8 62 04 00 00       	call   800615 <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	eb 10                	jmp    8001c8 <_main+0x190>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 78 23 80 00       	push   $0x802378
  8001c0:	e8 50 04 00 00       	call   800615 <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c8:	e8 f7 18 00 00       	call   801ac4 <sys_getparentenvid>
  8001cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  8001d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001d4:	7e 55                	jle    80022b <_main+0x1f3>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  8001d6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	68 c3 23 80 00       	push   $0x8023c3
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	e8 6f 17 00 00       	call   80195c <sget>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_free_env(id1);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f9:	e8 07 1c 00 00       	call   801e05 <sys_free_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
		sys_free_env(id2);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 ec             	pushl  -0x14(%ebp)
  800207:	e8 f9 1b 00 00       	call   801e05 <sys_free_env>
  80020c:	83 c4 10             	add    $0x10,%esp
		sys_free_env(id3);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e8             	pushl  -0x18(%ebp)
  800215:	e8 eb 1b 00 00       	call   801e05 <sys_free_env>
  80021a:	83 c4 10             	add    $0x10,%esp
		(*finishedCount)++ ;
  80021d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800220:	8b 00                	mov    (%eax),%eax
  800222:	8d 50 01             	lea    0x1(%eax),%edx
  800225:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800228:	89 10                	mov    %edx,(%eax)
	}

	return;
  80022a:	90                   	nop
  80022b:	90                   	nop
}
  80022c:	c9                   	leave  
  80022d:	c3                   	ret    

0080022e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800234:	e8 72 18 00 00       	call   801aab <sys_getenvindex>
  800239:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80023c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80023f:	89 d0                	mov    %edx,%eax
  800241:	c1 e0 03             	shl    $0x3,%eax
  800244:	01 d0                	add    %edx,%eax
  800246:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80024d:	01 c8                	add    %ecx,%eax
  80024f:	01 c0                	add    %eax,%eax
  800251:	01 d0                	add    %edx,%eax
  800253:	01 c0                	add    %eax,%eax
  800255:	01 d0                	add    %edx,%eax
  800257:	89 c2                	mov    %eax,%edx
  800259:	c1 e2 05             	shl    $0x5,%edx
  80025c:	29 c2                	sub    %eax,%edx
  80025e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800265:	89 c2                	mov    %eax,%edx
  800267:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80026d:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800272:	a1 20 30 80 00       	mov    0x803020,%eax
  800277:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80027d:	84 c0                	test   %al,%al
  80027f:	74 0f                	je     800290 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800281:	a1 20 30 80 00       	mov    0x803020,%eax
  800286:	05 40 3c 01 00       	add    $0x13c40,%eax
  80028b:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800290:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800294:	7e 0a                	jle    8002a0 <libmain+0x72>
		binaryname = argv[0];
  800296:	8b 45 0c             	mov    0xc(%ebp),%eax
  800299:	8b 00                	mov    (%eax),%eax
  80029b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	ff 75 0c             	pushl  0xc(%ebp)
  8002a6:	ff 75 08             	pushl  0x8(%ebp)
  8002a9:	e8 8a fd ff ff       	call   800038 <_main>
  8002ae:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002b1:	e8 90 19 00 00       	call   801c46 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002b6:	83 ec 0c             	sub    $0xc,%esp
  8002b9:	68 ec 23 80 00       	push   $0x8023ec
  8002be:	e8 52 03 00 00       	call   800615 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cb:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8002d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d6:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	52                   	push   %edx
  8002e0:	50                   	push   %eax
  8002e1:	68 14 24 80 00       	push   $0x802414
  8002e6:	e8 2a 03 00 00       	call   800615 <cprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8002ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f3:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8002f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8002fe:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	52                   	push   %edx
  800308:	50                   	push   %eax
  800309:	68 3c 24 80 00       	push   $0x80243c
  80030e:	e8 02 03 00 00       	call   800615 <cprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800316:	a1 20 30 80 00       	mov    0x803020,%eax
  80031b:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800321:	83 ec 08             	sub    $0x8,%esp
  800324:	50                   	push   %eax
  800325:	68 7d 24 80 00       	push   $0x80247d
  80032a:	e8 e6 02 00 00       	call   800615 <cprintf>
  80032f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800332:	83 ec 0c             	sub    $0xc,%esp
  800335:	68 ec 23 80 00       	push   $0x8023ec
  80033a:	e8 d6 02 00 00       	call   800615 <cprintf>
  80033f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800342:	e8 19 19 00 00       	call   801c60 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800347:	e8 19 00 00 00       	call   800365 <exit>
}
  80034c:	90                   	nop
  80034d:	c9                   	leave  
  80034e:	c3                   	ret    

0080034f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800355:	83 ec 0c             	sub    $0xc,%esp
  800358:	6a 00                	push   $0x0
  80035a:	e8 18 17 00 00       	call   801a77 <sys_env_destroy>
  80035f:	83 c4 10             	add    $0x10,%esp
}
  800362:	90                   	nop
  800363:	c9                   	leave  
  800364:	c3                   	ret    

00800365 <exit>:

void
exit(void)
{
  800365:	55                   	push   %ebp
  800366:	89 e5                	mov    %esp,%ebp
  800368:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80036b:	e8 6d 17 00 00       	call   801add <sys_env_exit>
}
  800370:	90                   	nop
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800379:	8d 45 10             	lea    0x10(%ebp),%eax
  80037c:	83 c0 04             	add    $0x4,%eax
  80037f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800382:	a1 18 31 80 00       	mov    0x803118,%eax
  800387:	85 c0                	test   %eax,%eax
  800389:	74 16                	je     8003a1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80038b:	a1 18 31 80 00       	mov    0x803118,%eax
  800390:	83 ec 08             	sub    $0x8,%esp
  800393:	50                   	push   %eax
  800394:	68 94 24 80 00       	push   $0x802494
  800399:	e8 77 02 00 00       	call   800615 <cprintf>
  80039e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003a1:	a1 00 30 80 00       	mov    0x803000,%eax
  8003a6:	ff 75 0c             	pushl  0xc(%ebp)
  8003a9:	ff 75 08             	pushl  0x8(%ebp)
  8003ac:	50                   	push   %eax
  8003ad:	68 99 24 80 00       	push   $0x802499
  8003b2:	e8 5e 02 00 00       	call   800615 <cprintf>
  8003b7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c3:	50                   	push   %eax
  8003c4:	e8 e1 01 00 00       	call   8005aa <vcprintf>
  8003c9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003cc:	83 ec 08             	sub    $0x8,%esp
  8003cf:	6a 00                	push   $0x0
  8003d1:	68 b5 24 80 00       	push   $0x8024b5
  8003d6:	e8 cf 01 00 00       	call   8005aa <vcprintf>
  8003db:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003de:	e8 82 ff ff ff       	call   800365 <exit>

	// should not return here
	while (1) ;
  8003e3:	eb fe                	jmp    8003e3 <_panic+0x70>

008003e5 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f0:	8b 50 74             	mov    0x74(%eax),%edx
  8003f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f6:	39 c2                	cmp    %eax,%edx
  8003f8:	74 14                	je     80040e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003fa:	83 ec 04             	sub    $0x4,%esp
  8003fd:	68 b8 24 80 00       	push   $0x8024b8
  800402:	6a 26                	push   $0x26
  800404:	68 04 25 80 00       	push   $0x802504
  800409:	e8 65 ff ff ff       	call   800373 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80040e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80041c:	e9 b6 00 00 00       	jmp    8004d7 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	01 d0                	add    %edx,%eax
  800430:	8b 00                	mov    (%eax),%eax
  800432:	85 c0                	test   %eax,%eax
  800434:	75 08                	jne    80043e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800436:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800439:	e9 96 00 00 00       	jmp    8004d4 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80043e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800445:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80044c:	eb 5d                	jmp    8004ab <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80044e:	a1 20 30 80 00       	mov    0x803020,%eax
  800453:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800459:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80045c:	c1 e2 04             	shl    $0x4,%edx
  80045f:	01 d0                	add    %edx,%eax
  800461:	8a 40 04             	mov    0x4(%eax),%al
  800464:	84 c0                	test   %al,%al
  800466:	75 40                	jne    8004a8 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800468:	a1 20 30 80 00       	mov    0x803020,%eax
  80046d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800473:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800476:	c1 e2 04             	shl    $0x4,%edx
  800479:	01 d0                	add    %edx,%eax
  80047b:	8b 00                	mov    (%eax),%eax
  80047d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800480:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800483:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800488:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	01 c8                	add    %ecx,%eax
  800499:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80049b:	39 c2                	cmp    %eax,%edx
  80049d:	75 09                	jne    8004a8 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  80049f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004a6:	eb 12                	jmp    8004ba <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a8:	ff 45 e8             	incl   -0x18(%ebp)
  8004ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b0:	8b 50 74             	mov    0x74(%eax),%edx
  8004b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b6:	39 c2                	cmp    %eax,%edx
  8004b8:	77 94                	ja     80044e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004be:	75 14                	jne    8004d4 <CheckWSWithoutLastIndex+0xef>
			panic(
  8004c0:	83 ec 04             	sub    $0x4,%esp
  8004c3:	68 10 25 80 00       	push   $0x802510
  8004c8:	6a 3a                	push   $0x3a
  8004ca:	68 04 25 80 00       	push   $0x802504
  8004cf:	e8 9f fe ff ff       	call   800373 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004d4:	ff 45 f0             	incl   -0x10(%ebp)
  8004d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004dd:	0f 8c 3e ff ff ff    	jl     800421 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004e3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004f1:	eb 20                	jmp    800513 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8004f8:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8004fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800501:	c1 e2 04             	shl    $0x4,%edx
  800504:	01 d0                	add    %edx,%eax
  800506:	8a 40 04             	mov    0x4(%eax),%al
  800509:	3c 01                	cmp    $0x1,%al
  80050b:	75 03                	jne    800510 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80050d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800510:	ff 45 e0             	incl   -0x20(%ebp)
  800513:	a1 20 30 80 00       	mov    0x803020,%eax
  800518:	8b 50 74             	mov    0x74(%eax),%edx
  80051b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051e:	39 c2                	cmp    %eax,%edx
  800520:	77 d1                	ja     8004f3 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800525:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800528:	74 14                	je     80053e <CheckWSWithoutLastIndex+0x159>
		panic(
  80052a:	83 ec 04             	sub    $0x4,%esp
  80052d:	68 64 25 80 00       	push   $0x802564
  800532:	6a 44                	push   $0x44
  800534:	68 04 25 80 00       	push   $0x802504
  800539:	e8 35 fe ff ff       	call   800373 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80053e:	90                   	nop
  80053f:	c9                   	leave  
  800540:	c3                   	ret    

00800541 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800541:	55                   	push   %ebp
  800542:	89 e5                	mov    %esp,%ebp
  800544:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054a:	8b 00                	mov    (%eax),%eax
  80054c:	8d 48 01             	lea    0x1(%eax),%ecx
  80054f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800552:	89 0a                	mov    %ecx,(%edx)
  800554:	8b 55 08             	mov    0x8(%ebp),%edx
  800557:	88 d1                	mov    %dl,%cl
  800559:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800560:	8b 45 0c             	mov    0xc(%ebp),%eax
  800563:	8b 00                	mov    (%eax),%eax
  800565:	3d ff 00 00 00       	cmp    $0xff,%eax
  80056a:	75 2c                	jne    800598 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80056c:	a0 24 30 80 00       	mov    0x803024,%al
  800571:	0f b6 c0             	movzbl %al,%eax
  800574:	8b 55 0c             	mov    0xc(%ebp),%edx
  800577:	8b 12                	mov    (%edx),%edx
  800579:	89 d1                	mov    %edx,%ecx
  80057b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80057e:	83 c2 08             	add    $0x8,%edx
  800581:	83 ec 04             	sub    $0x4,%esp
  800584:	50                   	push   %eax
  800585:	51                   	push   %ecx
  800586:	52                   	push   %edx
  800587:	e8 a9 14 00 00       	call   801a35 <sys_cputs>
  80058c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80058f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800592:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059b:	8b 40 04             	mov    0x4(%eax),%eax
  80059e:	8d 50 01             	lea    0x1(%eax),%edx
  8005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005a7:	90                   	nop
  8005a8:	c9                   	leave  
  8005a9:	c3                   	ret    

008005aa <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005aa:	55                   	push   %ebp
  8005ab:	89 e5                	mov    %esp,%ebp
  8005ad:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005b3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005ba:	00 00 00 
	b.cnt = 0;
  8005bd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005c4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005c7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ca:	ff 75 08             	pushl  0x8(%ebp)
  8005cd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005d3:	50                   	push   %eax
  8005d4:	68 41 05 80 00       	push   $0x800541
  8005d9:	e8 11 02 00 00       	call   8007ef <vprintfmt>
  8005de:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005e1:	a0 24 30 80 00       	mov    0x803024,%al
  8005e6:	0f b6 c0             	movzbl %al,%eax
  8005e9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	50                   	push   %eax
  8005f3:	52                   	push   %edx
  8005f4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005fa:	83 c0 08             	add    $0x8,%eax
  8005fd:	50                   	push   %eax
  8005fe:	e8 32 14 00 00       	call   801a35 <sys_cputs>
  800603:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800606:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80060d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800613:	c9                   	leave  
  800614:	c3                   	ret    

00800615 <cprintf>:

int cprintf(const char *fmt, ...) {
  800615:	55                   	push   %ebp
  800616:	89 e5                	mov    %esp,%ebp
  800618:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80061b:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800622:	8d 45 0c             	lea    0xc(%ebp),%eax
  800625:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 f4             	pushl  -0xc(%ebp)
  800631:	50                   	push   %eax
  800632:	e8 73 ff ff ff       	call   8005aa <vcprintf>
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80063d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800640:	c9                   	leave  
  800641:	c3                   	ret    

00800642 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800642:	55                   	push   %ebp
  800643:	89 e5                	mov    %esp,%ebp
  800645:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800648:	e8 f9 15 00 00       	call   801c46 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80064d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800650:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	83 ec 08             	sub    $0x8,%esp
  800659:	ff 75 f4             	pushl  -0xc(%ebp)
  80065c:	50                   	push   %eax
  80065d:	e8 48 ff ff ff       	call   8005aa <vcprintf>
  800662:	83 c4 10             	add    $0x10,%esp
  800665:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800668:	e8 f3 15 00 00       	call   801c60 <sys_enable_interrupt>
	return cnt;
  80066d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800670:	c9                   	leave  
  800671:	c3                   	ret    

00800672 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800672:	55                   	push   %ebp
  800673:	89 e5                	mov    %esp,%ebp
  800675:	53                   	push   %ebx
  800676:	83 ec 14             	sub    $0x14,%esp
  800679:	8b 45 10             	mov    0x10(%ebp),%eax
  80067c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800685:	8b 45 18             	mov    0x18(%ebp),%eax
  800688:	ba 00 00 00 00       	mov    $0x0,%edx
  80068d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800690:	77 55                	ja     8006e7 <printnum+0x75>
  800692:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800695:	72 05                	jb     80069c <printnum+0x2a>
  800697:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80069a:	77 4b                	ja     8006e7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80069c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80069f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006aa:	52                   	push   %edx
  8006ab:	50                   	push   %eax
  8006ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8006af:	ff 75 f0             	pushl  -0x10(%ebp)
  8006b2:	e8 b1 19 00 00       	call   802068 <__udivdi3>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	83 ec 04             	sub    $0x4,%esp
  8006bd:	ff 75 20             	pushl  0x20(%ebp)
  8006c0:	53                   	push   %ebx
  8006c1:	ff 75 18             	pushl  0x18(%ebp)
  8006c4:	52                   	push   %edx
  8006c5:	50                   	push   %eax
  8006c6:	ff 75 0c             	pushl  0xc(%ebp)
  8006c9:	ff 75 08             	pushl  0x8(%ebp)
  8006cc:	e8 a1 ff ff ff       	call   800672 <printnum>
  8006d1:	83 c4 20             	add    $0x20,%esp
  8006d4:	eb 1a                	jmp    8006f0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006d6:	83 ec 08             	sub    $0x8,%esp
  8006d9:	ff 75 0c             	pushl  0xc(%ebp)
  8006dc:	ff 75 20             	pushl  0x20(%ebp)
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	ff d0                	call   *%eax
  8006e4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006e7:	ff 4d 1c             	decl   0x1c(%ebp)
  8006ea:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006ee:	7f e6                	jg     8006d6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006fe:	53                   	push   %ebx
  8006ff:	51                   	push   %ecx
  800700:	52                   	push   %edx
  800701:	50                   	push   %eax
  800702:	e8 71 1a 00 00       	call   802178 <__umoddi3>
  800707:	83 c4 10             	add    $0x10,%esp
  80070a:	05 d4 27 80 00       	add    $0x8027d4,%eax
  80070f:	8a 00                	mov    (%eax),%al
  800711:	0f be c0             	movsbl %al,%eax
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	ff 75 0c             	pushl  0xc(%ebp)
  80071a:	50                   	push   %eax
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	ff d0                	call   *%eax
  800720:	83 c4 10             	add    $0x10,%esp
}
  800723:	90                   	nop
  800724:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800727:	c9                   	leave  
  800728:	c3                   	ret    

00800729 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800729:	55                   	push   %ebp
  80072a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80072c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800730:	7e 1c                	jle    80074e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	8d 50 08             	lea    0x8(%eax),%edx
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	89 10                	mov    %edx,(%eax)
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	83 e8 08             	sub    $0x8,%eax
  800747:	8b 50 04             	mov    0x4(%eax),%edx
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	eb 40                	jmp    80078e <getuint+0x65>
	else if (lflag)
  80074e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800752:	74 1e                	je     800772 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	8b 00                	mov    (%eax),%eax
  800759:	8d 50 04             	lea    0x4(%eax),%edx
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	89 10                	mov    %edx,(%eax)
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	83 e8 04             	sub    $0x4,%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	ba 00 00 00 00       	mov    $0x0,%edx
  800770:	eb 1c                	jmp    80078e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	8b 00                	mov    (%eax),%eax
  800777:	8d 50 04             	lea    0x4(%eax),%edx
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	89 10                	mov    %edx,(%eax)
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	83 e8 04             	sub    $0x4,%eax
  800787:	8b 00                	mov    (%eax),%eax
  800789:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80078e:	5d                   	pop    %ebp
  80078f:	c3                   	ret    

00800790 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800793:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800797:	7e 1c                	jle    8007b5 <getint+0x25>
		return va_arg(*ap, long long);
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	8d 50 08             	lea    0x8(%eax),%edx
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	89 10                	mov    %edx,(%eax)
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	83 e8 08             	sub    $0x8,%eax
  8007ae:	8b 50 04             	mov    0x4(%eax),%edx
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	eb 38                	jmp    8007ed <getint+0x5d>
	else if (lflag)
  8007b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007b9:	74 1a                	je     8007d5 <getint+0x45>
		return va_arg(*ap, long);
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	8d 50 04             	lea    0x4(%eax),%edx
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	89 10                	mov    %edx,(%eax)
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	83 e8 04             	sub    $0x4,%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	99                   	cltd   
  8007d3:	eb 18                	jmp    8007ed <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	8d 50 04             	lea    0x4(%eax),%edx
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	89 10                	mov    %edx,(%eax)
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	83 e8 04             	sub    $0x4,%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	99                   	cltd   
}
  8007ed:	5d                   	pop    %ebp
  8007ee:	c3                   	ret    

008007ef <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	56                   	push   %esi
  8007f3:	53                   	push   %ebx
  8007f4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f7:	eb 17                	jmp    800810 <vprintfmt+0x21>
			if (ch == '\0')
  8007f9:	85 db                	test   %ebx,%ebx
  8007fb:	0f 84 af 03 00 00    	je     800bb0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	ff 75 0c             	pushl  0xc(%ebp)
  800807:	53                   	push   %ebx
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	ff d0                	call   *%eax
  80080d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800810:	8b 45 10             	mov    0x10(%ebp),%eax
  800813:	8d 50 01             	lea    0x1(%eax),%edx
  800816:	89 55 10             	mov    %edx,0x10(%ebp)
  800819:	8a 00                	mov    (%eax),%al
  80081b:	0f b6 d8             	movzbl %al,%ebx
  80081e:	83 fb 25             	cmp    $0x25,%ebx
  800821:	75 d6                	jne    8007f9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800823:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800827:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80082e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800835:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80083c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800843:	8b 45 10             	mov    0x10(%ebp),%eax
  800846:	8d 50 01             	lea    0x1(%eax),%edx
  800849:	89 55 10             	mov    %edx,0x10(%ebp)
  80084c:	8a 00                	mov    (%eax),%al
  80084e:	0f b6 d8             	movzbl %al,%ebx
  800851:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800854:	83 f8 55             	cmp    $0x55,%eax
  800857:	0f 87 2b 03 00 00    	ja     800b88 <vprintfmt+0x399>
  80085d:	8b 04 85 f8 27 80 00 	mov    0x8027f8(,%eax,4),%eax
  800864:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800866:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80086a:	eb d7                	jmp    800843 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80086c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800870:	eb d1                	jmp    800843 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800872:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800879:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80087c:	89 d0                	mov    %edx,%eax
  80087e:	c1 e0 02             	shl    $0x2,%eax
  800881:	01 d0                	add    %edx,%eax
  800883:	01 c0                	add    %eax,%eax
  800885:	01 d8                	add    %ebx,%eax
  800887:	83 e8 30             	sub    $0x30,%eax
  80088a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80088d:	8b 45 10             	mov    0x10(%ebp),%eax
  800890:	8a 00                	mov    (%eax),%al
  800892:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800895:	83 fb 2f             	cmp    $0x2f,%ebx
  800898:	7e 3e                	jle    8008d8 <vprintfmt+0xe9>
  80089a:	83 fb 39             	cmp    $0x39,%ebx
  80089d:	7f 39                	jg     8008d8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80089f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008a2:	eb d5                	jmp    800879 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	83 c0 04             	add    $0x4,%eax
  8008aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	83 e8 04             	sub    $0x4,%eax
  8008b3:	8b 00                	mov    (%eax),%eax
  8008b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008b8:	eb 1f                	jmp    8008d9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008be:	79 83                	jns    800843 <vprintfmt+0x54>
				width = 0;
  8008c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008c7:	e9 77 ff ff ff       	jmp    800843 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008cc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008d3:	e9 6b ff ff ff       	jmp    800843 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008d8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008dd:	0f 89 60 ff ff ff    	jns    800843 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f0:	e9 4e ff ff ff       	jmp    800843 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008f5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008f8:	e9 46 ff ff ff       	jmp    800843 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	83 c0 04             	add    $0x4,%eax
  800903:	89 45 14             	mov    %eax,0x14(%ebp)
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	83 e8 04             	sub    $0x4,%eax
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	50                   	push   %eax
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
			break;
  80091d:	e9 89 02 00 00       	jmp    800bab <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800922:	8b 45 14             	mov    0x14(%ebp),%eax
  800925:	83 c0 04             	add    $0x4,%eax
  800928:	89 45 14             	mov    %eax,0x14(%ebp)
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	83 e8 04             	sub    $0x4,%eax
  800931:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800933:	85 db                	test   %ebx,%ebx
  800935:	79 02                	jns    800939 <vprintfmt+0x14a>
				err = -err;
  800937:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800939:	83 fb 64             	cmp    $0x64,%ebx
  80093c:	7f 0b                	jg     800949 <vprintfmt+0x15a>
  80093e:	8b 34 9d 40 26 80 00 	mov    0x802640(,%ebx,4),%esi
  800945:	85 f6                	test   %esi,%esi
  800947:	75 19                	jne    800962 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800949:	53                   	push   %ebx
  80094a:	68 e5 27 80 00       	push   $0x8027e5
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	ff 75 08             	pushl  0x8(%ebp)
  800955:	e8 5e 02 00 00       	call   800bb8 <printfmt>
  80095a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80095d:	e9 49 02 00 00       	jmp    800bab <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800962:	56                   	push   %esi
  800963:	68 ee 27 80 00       	push   $0x8027ee
  800968:	ff 75 0c             	pushl  0xc(%ebp)
  80096b:	ff 75 08             	pushl  0x8(%ebp)
  80096e:	e8 45 02 00 00       	call   800bb8 <printfmt>
  800973:	83 c4 10             	add    $0x10,%esp
			break;
  800976:	e9 30 02 00 00       	jmp    800bab <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80097b:	8b 45 14             	mov    0x14(%ebp),%eax
  80097e:	83 c0 04             	add    $0x4,%eax
  800981:	89 45 14             	mov    %eax,0x14(%ebp)
  800984:	8b 45 14             	mov    0x14(%ebp),%eax
  800987:	83 e8 04             	sub    $0x4,%eax
  80098a:	8b 30                	mov    (%eax),%esi
  80098c:	85 f6                	test   %esi,%esi
  80098e:	75 05                	jne    800995 <vprintfmt+0x1a6>
				p = "(null)";
  800990:	be f1 27 80 00       	mov    $0x8027f1,%esi
			if (width > 0 && padc != '-')
  800995:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800999:	7e 6d                	jle    800a08 <vprintfmt+0x219>
  80099b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80099f:	74 67                	je     800a08 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	50                   	push   %eax
  8009a8:	56                   	push   %esi
  8009a9:	e8 0c 03 00 00       	call   800cba <strnlen>
  8009ae:	83 c4 10             	add    $0x10,%esp
  8009b1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009b4:	eb 16                	jmp    8009cc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009b6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	50                   	push   %eax
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	ff d0                	call   *%eax
  8009c6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d0:	7f e4                	jg     8009b6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d2:	eb 34                	jmp    800a08 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009d8:	74 1c                	je     8009f6 <vprintfmt+0x207>
  8009da:	83 fb 1f             	cmp    $0x1f,%ebx
  8009dd:	7e 05                	jle    8009e4 <vprintfmt+0x1f5>
  8009df:	83 fb 7e             	cmp    $0x7e,%ebx
  8009e2:	7e 12                	jle    8009f6 <vprintfmt+0x207>
					putch('?', putdat);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	6a 3f                	push   $0x3f
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	ff d0                	call   *%eax
  8009f1:	83 c4 10             	add    $0x10,%esp
  8009f4:	eb 0f                	jmp    800a05 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	53                   	push   %ebx
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	ff d0                	call   *%eax
  800a02:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a05:	ff 4d e4             	decl   -0x1c(%ebp)
  800a08:	89 f0                	mov    %esi,%eax
  800a0a:	8d 70 01             	lea    0x1(%eax),%esi
  800a0d:	8a 00                	mov    (%eax),%al
  800a0f:	0f be d8             	movsbl %al,%ebx
  800a12:	85 db                	test   %ebx,%ebx
  800a14:	74 24                	je     800a3a <vprintfmt+0x24b>
  800a16:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a1a:	78 b8                	js     8009d4 <vprintfmt+0x1e5>
  800a1c:	ff 4d e0             	decl   -0x20(%ebp)
  800a1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a23:	79 af                	jns    8009d4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a25:	eb 13                	jmp    800a3a <vprintfmt+0x24b>
				putch(' ', putdat);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	6a 20                	push   $0x20
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a37:	ff 4d e4             	decl   -0x1c(%ebp)
  800a3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3e:	7f e7                	jg     800a27 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a40:	e9 66 01 00 00       	jmp    800bab <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a45:	83 ec 08             	sub    $0x8,%esp
  800a48:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4e:	50                   	push   %eax
  800a4f:	e8 3c fd ff ff       	call   800790 <getint>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a63:	85 d2                	test   %edx,%edx
  800a65:	79 23                	jns    800a8a <vprintfmt+0x29b>
				putch('-', putdat);
  800a67:	83 ec 08             	sub    $0x8,%esp
  800a6a:	ff 75 0c             	pushl  0xc(%ebp)
  800a6d:	6a 2d                	push   $0x2d
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	ff d0                	call   *%eax
  800a74:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7d:	f7 d8                	neg    %eax
  800a7f:	83 d2 00             	adc    $0x0,%edx
  800a82:	f7 da                	neg    %edx
  800a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a87:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a8a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a91:	e9 bc 00 00 00       	jmp    800b52 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 e8             	pushl  -0x18(%ebp)
  800a9c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a9f:	50                   	push   %eax
  800aa0:	e8 84 fc ff ff       	call   800729 <getuint>
  800aa5:	83 c4 10             	add    $0x10,%esp
  800aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aae:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ab5:	e9 98 00 00 00       	jmp    800b52 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	6a 58                	push   $0x58
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	ff d0                	call   *%eax
  800ac7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	6a 58                	push   $0x58
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	6a 58                	push   $0x58
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
  800ae7:	83 c4 10             	add    $0x10,%esp
			break;
  800aea:	e9 bc 00 00 00       	jmp    800bab <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	ff 75 0c             	pushl  0xc(%ebp)
  800af5:	6a 30                	push   $0x30
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	ff d0                	call   *%eax
  800afc:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	6a 78                	push   $0x78
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	ff d0                	call   *%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b12:	83 c0 04             	add    $0x4,%eax
  800b15:	89 45 14             	mov    %eax,0x14(%ebp)
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	83 e8 04             	sub    $0x4,%eax
  800b1e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b2a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b31:	eb 1f                	jmp    800b52 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 e8             	pushl  -0x18(%ebp)
  800b39:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3c:	50                   	push   %eax
  800b3d:	e8 e7 fb ff ff       	call   800729 <getuint>
  800b42:	83 c4 10             	add    $0x10,%esp
  800b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b48:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b4b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b52:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b59:	83 ec 04             	sub    $0x4,%esp
  800b5c:	52                   	push   %edx
  800b5d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b60:	50                   	push   %eax
  800b61:	ff 75 f4             	pushl  -0xc(%ebp)
  800b64:	ff 75 f0             	pushl  -0x10(%ebp)
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	ff 75 08             	pushl  0x8(%ebp)
  800b6d:	e8 00 fb ff ff       	call   800672 <printnum>
  800b72:	83 c4 20             	add    $0x20,%esp
			break;
  800b75:	eb 34                	jmp    800bab <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b77:	83 ec 08             	sub    $0x8,%esp
  800b7a:	ff 75 0c             	pushl  0xc(%ebp)
  800b7d:	53                   	push   %ebx
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	ff d0                	call   *%eax
  800b83:	83 c4 10             	add    $0x10,%esp
			break;
  800b86:	eb 23                	jmp    800bab <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b88:	83 ec 08             	sub    $0x8,%esp
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	6a 25                	push   $0x25
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	ff d0                	call   *%eax
  800b95:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b98:	ff 4d 10             	decl   0x10(%ebp)
  800b9b:	eb 03                	jmp    800ba0 <vprintfmt+0x3b1>
  800b9d:	ff 4d 10             	decl   0x10(%ebp)
  800ba0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba3:	48                   	dec    %eax
  800ba4:	8a 00                	mov    (%eax),%al
  800ba6:	3c 25                	cmp    $0x25,%al
  800ba8:	75 f3                	jne    800b9d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800baa:	90                   	nop
		}
	}
  800bab:	e9 47 fc ff ff       	jmp    8007f7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bb1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bb4:	5b                   	pop    %ebx
  800bb5:	5e                   	pop    %esi
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    

00800bb8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bbe:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc1:	83 c0 04             	add    $0x4,%eax
  800bc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bca:	ff 75 f4             	pushl  -0xc(%ebp)
  800bcd:	50                   	push   %eax
  800bce:	ff 75 0c             	pushl  0xc(%ebp)
  800bd1:	ff 75 08             	pushl  0x8(%ebp)
  800bd4:	e8 16 fc ff ff       	call   8007ef <vprintfmt>
  800bd9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bdc:	90                   	nop
  800bdd:	c9                   	leave  
  800bde:	c3                   	ret    

00800bdf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be5:	8b 40 08             	mov    0x8(%eax),%eax
  800be8:	8d 50 01             	lea    0x1(%eax),%edx
  800beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bee:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf4:	8b 10                	mov    (%eax),%edx
  800bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf9:	8b 40 04             	mov    0x4(%eax),%eax
  800bfc:	39 c2                	cmp    %eax,%edx
  800bfe:	73 12                	jae    800c12 <sprintputch+0x33>
		*b->buf++ = ch;
  800c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c03:	8b 00                	mov    (%eax),%eax
  800c05:	8d 48 01             	lea    0x1(%eax),%ecx
  800c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0b:	89 0a                	mov    %ecx,(%edx)
  800c0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c10:	88 10                	mov    %dl,(%eax)
}
  800c12:	90                   	nop
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	01 d0                	add    %edx,%eax
  800c2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c3a:	74 06                	je     800c42 <vsnprintf+0x2d>
  800c3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c40:	7f 07                	jg     800c49 <vsnprintf+0x34>
		return -E_INVAL;
  800c42:	b8 03 00 00 00       	mov    $0x3,%eax
  800c47:	eb 20                	jmp    800c69 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c49:	ff 75 14             	pushl  0x14(%ebp)
  800c4c:	ff 75 10             	pushl  0x10(%ebp)
  800c4f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c52:	50                   	push   %eax
  800c53:	68 df 0b 80 00       	push   $0x800bdf
  800c58:	e8 92 fb ff ff       	call   8007ef <vprintfmt>
  800c5d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c63:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c71:	8d 45 10             	lea    0x10(%ebp),%eax
  800c74:	83 c0 04             	add    $0x4,%eax
  800c77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c80:	50                   	push   %eax
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	ff 75 08             	pushl  0x8(%ebp)
  800c87:	e8 89 ff ff ff       	call   800c15 <vsnprintf>
  800c8c:	83 c4 10             	add    $0x10,%esp
  800c8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca4:	eb 06                	jmp    800cac <strlen+0x15>
		n++;
  800ca6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca9:	ff 45 08             	incl   0x8(%ebp)
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	84 c0                	test   %al,%al
  800cb3:	75 f1                	jne    800ca6 <strlen+0xf>
		n++;
	return n;
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc7:	eb 09                	jmp    800cd2 <strnlen+0x18>
		n++;
  800cc9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccc:	ff 45 08             	incl   0x8(%ebp)
  800ccf:	ff 4d 0c             	decl   0xc(%ebp)
  800cd2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd6:	74 09                	je     800ce1 <strnlen+0x27>
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	84 c0                	test   %al,%al
  800cdf:	75 e8                	jne    800cc9 <strnlen+0xf>
		n++;
	return n;
  800ce1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce4:	c9                   	leave  
  800ce5:	c3                   	ret    

00800ce6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cf2:	90                   	nop
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8d 50 01             	lea    0x1(%eax),%edx
  800cf9:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d02:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d05:	8a 12                	mov    (%edx),%dl
  800d07:	88 10                	mov    %dl,(%eax)
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	84 c0                	test   %al,%al
  800d0d:	75 e4                	jne    800cf3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d12:	c9                   	leave  
  800d13:	c3                   	ret    

00800d14 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d27:	eb 1f                	jmp    800d48 <strncpy+0x34>
		*dst++ = *src;
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8d 50 01             	lea    0x1(%eax),%edx
  800d2f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d35:	8a 12                	mov    (%edx),%dl
  800d37:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	84 c0                	test   %al,%al
  800d40:	74 03                	je     800d45 <strncpy+0x31>
			src++;
  800d42:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d45:	ff 45 fc             	incl   -0x4(%ebp)
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d4e:	72 d9                	jb     800d29 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d50:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d65:	74 30                	je     800d97 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d67:	eb 16                	jmp    800d7f <strlcpy+0x2a>
			*dst++ = *src++;
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8d 50 01             	lea    0x1(%eax),%edx
  800d6f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d75:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d78:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d7b:	8a 12                	mov    (%edx),%dl
  800d7d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d7f:	ff 4d 10             	decl   0x10(%ebp)
  800d82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d86:	74 09                	je     800d91 <strlcpy+0x3c>
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	84 c0                	test   %al,%al
  800d8f:	75 d8                	jne    800d69 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d97:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9d:	29 c2                	sub    %eax,%edx
  800d9f:	89 d0                	mov    %edx,%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800da6:	eb 06                	jmp    800dae <strcmp+0xb>
		p++, q++;
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	84 c0                	test   %al,%al
  800db5:	74 0e                	je     800dc5 <strcmp+0x22>
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	8a 10                	mov    (%eax),%dl
  800dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	38 c2                	cmp    %al,%dl
  800dc3:	74 e3                	je     800da8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	0f b6 d0             	movzbl %al,%edx
  800dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	0f b6 c0             	movzbl %al,%eax
  800dd5:	29 c2                	sub    %eax,%edx
  800dd7:	89 d0                	mov    %edx,%eax
}
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    

00800ddb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dde:	eb 09                	jmp    800de9 <strncmp+0xe>
		n--, p++, q++;
  800de0:	ff 4d 10             	decl   0x10(%ebp)
  800de3:	ff 45 08             	incl   0x8(%ebp)
  800de6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800de9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ded:	74 17                	je     800e06 <strncmp+0x2b>
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	84 c0                	test   %al,%al
  800df6:	74 0e                	je     800e06 <strncmp+0x2b>
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 10                	mov    (%eax),%dl
  800dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	38 c2                	cmp    %al,%dl
  800e04:	74 da                	je     800de0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0a:	75 07                	jne    800e13 <strncmp+0x38>
		return 0;
  800e0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e11:	eb 14                	jmp    800e27 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	0f b6 d0             	movzbl %al,%edx
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	0f b6 c0             	movzbl %al,%eax
  800e23:	29 c2                	sub    %eax,%edx
  800e25:	89 d0                	mov    %edx,%eax
}
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 04             	sub    $0x4,%esp
  800e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e32:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e35:	eb 12                	jmp    800e49 <strchr+0x20>
		if (*s == c)
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e3f:	75 05                	jne    800e46 <strchr+0x1d>
			return (char *) s;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	eb 11                	jmp    800e57 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e46:	ff 45 08             	incl   0x8(%ebp)
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	84 c0                	test   %al,%al
  800e50:	75 e5                	jne    800e37 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e57:	c9                   	leave  
  800e58:	c3                   	ret    

00800e59 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 04             	sub    $0x4,%esp
  800e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e62:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e65:	eb 0d                	jmp    800e74 <strfind+0x1b>
		if (*s == c)
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e6f:	74 0e                	je     800e7f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e71:	ff 45 08             	incl   0x8(%ebp)
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	84 c0                	test   %al,%al
  800e7b:	75 ea                	jne    800e67 <strfind+0xe>
  800e7d:	eb 01                	jmp    800e80 <strfind+0x27>
		if (*s == c)
			break;
  800e7f:	90                   	nop
	return (char *) s;
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e83:	c9                   	leave  
  800e84:	c3                   	ret    

00800e85 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e91:	8b 45 10             	mov    0x10(%ebp),%eax
  800e94:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e97:	eb 0e                	jmp    800ea7 <memset+0x22>
		*p++ = c;
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9c:	8d 50 01             	lea    0x1(%eax),%edx
  800e9f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ea2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ea7:	ff 4d f8             	decl   -0x8(%ebp)
  800eaa:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eae:	79 e9                	jns    800e99 <memset+0x14>
		*p++ = c;

	return v;
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb3:	c9                   	leave  
  800eb4:	c3                   	ret    

00800eb5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ec7:	eb 16                	jmp    800edf <memcpy+0x2a>
		*d++ = *s++;
  800ec9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ecc:	8d 50 01             	lea    0x1(%eax),%edx
  800ecf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800edb:	8a 12                	mov    (%edx),%dl
  800edd:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800edf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee5:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	75 dd                	jne    800ec9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f06:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f09:	73 50                	jae    800f5b <memmove+0x6a>
  800f0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	01 d0                	add    %edx,%eax
  800f13:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f16:	76 43                	jbe    800f5b <memmove+0x6a>
		s += n;
  800f18:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f21:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f24:	eb 10                	jmp    800f36 <memmove+0x45>
			*--d = *--s;
  800f26:	ff 4d f8             	decl   -0x8(%ebp)
  800f29:	ff 4d fc             	decl   -0x4(%ebp)
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2f:	8a 10                	mov    (%eax),%dl
  800f31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f34:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f36:	8b 45 10             	mov    0x10(%ebp),%eax
  800f39:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3f:	85 c0                	test   %eax,%eax
  800f41:	75 e3                	jne    800f26 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f43:	eb 23                	jmp    800f68 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f48:	8d 50 01             	lea    0x1(%eax),%edx
  800f4b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f4e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f51:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f54:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f57:	8a 12                	mov    (%edx),%dl
  800f59:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f61:	89 55 10             	mov    %edx,0x10(%ebp)
  800f64:	85 c0                	test   %eax,%eax
  800f66:	75 dd                	jne    800f45 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f6b:	c9                   	leave  
  800f6c:	c3                   	ret    

00800f6d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f7f:	eb 2a                	jmp    800fab <memcmp+0x3e>
		if (*s1 != *s2)
  800f81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f84:	8a 10                	mov    (%eax),%dl
  800f86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	38 c2                	cmp    %al,%dl
  800f8d:	74 16                	je     800fa5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	0f b6 d0             	movzbl %al,%edx
  800f97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	0f b6 c0             	movzbl %al,%eax
  800f9f:	29 c2                	sub    %eax,%edx
  800fa1:	89 d0                	mov    %edx,%eax
  800fa3:	eb 18                	jmp    800fbd <memcmp+0x50>
		s1++, s2++;
  800fa5:	ff 45 fc             	incl   -0x4(%ebp)
  800fa8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb1:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	75 c9                	jne    800f81 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fbd:	c9                   	leave  
  800fbe:	c3                   	ret    

00800fbf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	01 d0                	add    %edx,%eax
  800fcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fd0:	eb 15                	jmp    800fe7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	0f b6 d0             	movzbl %al,%edx
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	0f b6 c0             	movzbl %al,%eax
  800fe0:	39 c2                	cmp    %eax,%edx
  800fe2:	74 0d                	je     800ff1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fe4:	ff 45 08             	incl   0x8(%ebp)
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fed:	72 e3                	jb     800fd2 <memfind+0x13>
  800fef:	eb 01                	jmp    800ff2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ff1:	90                   	nop
	return (void *) s;
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff5:	c9                   	leave  
  800ff6:	c3                   	ret    

00800ff7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ffd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801004:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80100b:	eb 03                	jmp    801010 <strtol+0x19>
		s++;
  80100d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 20                	cmp    $0x20,%al
  801017:	74 f4                	je     80100d <strtol+0x16>
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 09                	cmp    $0x9,%al
  801020:	74 eb                	je     80100d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	3c 2b                	cmp    $0x2b,%al
  801029:	75 05                	jne    801030 <strtol+0x39>
		s++;
  80102b:	ff 45 08             	incl   0x8(%ebp)
  80102e:	eb 13                	jmp    801043 <strtol+0x4c>
	else if (*s == '-')
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 2d                	cmp    $0x2d,%al
  801037:	75 0a                	jne    801043 <strtol+0x4c>
		s++, neg = 1;
  801039:	ff 45 08             	incl   0x8(%ebp)
  80103c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801043:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801047:	74 06                	je     80104f <strtol+0x58>
  801049:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80104d:	75 20                	jne    80106f <strtol+0x78>
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	8a 00                	mov    (%eax),%al
  801054:	3c 30                	cmp    $0x30,%al
  801056:	75 17                	jne    80106f <strtol+0x78>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	40                   	inc    %eax
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	3c 78                	cmp    $0x78,%al
  801060:	75 0d                	jne    80106f <strtol+0x78>
		s += 2, base = 16;
  801062:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801066:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80106d:	eb 28                	jmp    801097 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80106f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801073:	75 15                	jne    80108a <strtol+0x93>
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	3c 30                	cmp    $0x30,%al
  80107c:	75 0c                	jne    80108a <strtol+0x93>
		s++, base = 8;
  80107e:	ff 45 08             	incl   0x8(%ebp)
  801081:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801088:	eb 0d                	jmp    801097 <strtol+0xa0>
	else if (base == 0)
  80108a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80108e:	75 07                	jne    801097 <strtol+0xa0>
		base = 10;
  801090:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	3c 2f                	cmp    $0x2f,%al
  80109e:	7e 19                	jle    8010b9 <strtol+0xc2>
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 39                	cmp    $0x39,%al
  8010a7:	7f 10                	jg     8010b9 <strtol+0xc2>
			dig = *s - '0';
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	0f be c0             	movsbl %al,%eax
  8010b1:	83 e8 30             	sub    $0x30,%eax
  8010b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010b7:	eb 42                	jmp    8010fb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	3c 60                	cmp    $0x60,%al
  8010c0:	7e 19                	jle    8010db <strtol+0xe4>
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	3c 7a                	cmp    $0x7a,%al
  8010c9:	7f 10                	jg     8010db <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	0f be c0             	movsbl %al,%eax
  8010d3:	83 e8 57             	sub    $0x57,%eax
  8010d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010d9:	eb 20                	jmp    8010fb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	3c 40                	cmp    $0x40,%al
  8010e2:	7e 39                	jle    80111d <strtol+0x126>
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 5a                	cmp    $0x5a,%al
  8010eb:	7f 30                	jg     80111d <strtol+0x126>
			dig = *s - 'A' + 10;
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	0f be c0             	movsbl %al,%eax
  8010f5:	83 e8 37             	sub    $0x37,%eax
  8010f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010fe:	3b 45 10             	cmp    0x10(%ebp),%eax
  801101:	7d 19                	jge    80111c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801103:	ff 45 08             	incl   0x8(%ebp)
  801106:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801109:	0f af 45 10          	imul   0x10(%ebp),%eax
  80110d:	89 c2                	mov    %eax,%edx
  80110f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801112:	01 d0                	add    %edx,%eax
  801114:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801117:	e9 7b ff ff ff       	jmp    801097 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80111c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80111d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801121:	74 08                	je     80112b <strtol+0x134>
		*endptr = (char *) s;
  801123:	8b 45 0c             	mov    0xc(%ebp),%eax
  801126:	8b 55 08             	mov    0x8(%ebp),%edx
  801129:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80112b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80112f:	74 07                	je     801138 <strtol+0x141>
  801131:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801134:	f7 d8                	neg    %eax
  801136:	eb 03                	jmp    80113b <strtol+0x144>
  801138:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <ltostr>:

void
ltostr(long value, char *str)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80114a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801151:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801155:	79 13                	jns    80116a <ltostr+0x2d>
	{
		neg = 1;
  801157:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801164:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801167:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801172:	99                   	cltd   
  801173:	f7 f9                	idiv   %ecx
  801175:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801178:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117b:	8d 50 01             	lea    0x1(%eax),%edx
  80117e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801181:	89 c2                	mov    %eax,%edx
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	01 d0                	add    %edx,%eax
  801188:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80118b:	83 c2 30             	add    $0x30,%edx
  80118e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801190:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801193:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801198:	f7 e9                	imul   %ecx
  80119a:	c1 fa 02             	sar    $0x2,%edx
  80119d:	89 c8                	mov    %ecx,%eax
  80119f:	c1 f8 1f             	sar    $0x1f,%eax
  8011a2:	29 c2                	sub    %eax,%edx
  8011a4:	89 d0                	mov    %edx,%eax
  8011a6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ac:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011b1:	f7 e9                	imul   %ecx
  8011b3:	c1 fa 02             	sar    $0x2,%edx
  8011b6:	89 c8                	mov    %ecx,%eax
  8011b8:	c1 f8 1f             	sar    $0x1f,%eax
  8011bb:	29 c2                	sub    %eax,%edx
  8011bd:	89 d0                	mov    %edx,%eax
  8011bf:	c1 e0 02             	shl    $0x2,%eax
  8011c2:	01 d0                	add    %edx,%eax
  8011c4:	01 c0                	add    %eax,%eax
  8011c6:	29 c1                	sub    %eax,%ecx
  8011c8:	89 ca                	mov    %ecx,%edx
  8011ca:	85 d2                	test   %edx,%edx
  8011cc:	75 9c                	jne    80116a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d8:	48                   	dec    %eax
  8011d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e0:	74 3d                	je     80121f <ltostr+0xe2>
		start = 1 ;
  8011e2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011e9:	eb 34                	jmp    80121f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	01 c2                	add    %eax,%edx
  801200:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801203:	8b 45 0c             	mov    0xc(%ebp),%eax
  801206:	01 c8                	add    %ecx,%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80120c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	01 c2                	add    %eax,%edx
  801214:	8a 45 eb             	mov    -0x15(%ebp),%al
  801217:	88 02                	mov    %al,(%edx)
		start++ ;
  801219:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80121c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80121f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801222:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801225:	7c c4                	jl     8011eb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801227:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 d0                	add    %edx,%eax
  80122f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801232:	90                   	nop
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80123b:	ff 75 08             	pushl  0x8(%ebp)
  80123e:	e8 54 fa ff ff       	call   800c97 <strlen>
  801243:	83 c4 04             	add    $0x4,%esp
  801246:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801249:	ff 75 0c             	pushl  0xc(%ebp)
  80124c:	e8 46 fa ff ff       	call   800c97 <strlen>
  801251:	83 c4 04             	add    $0x4,%esp
  801254:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801257:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80125e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801265:	eb 17                	jmp    80127e <strcconcat+0x49>
		final[s] = str1[s] ;
  801267:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80126a:	8b 45 10             	mov    0x10(%ebp),%eax
  80126d:	01 c2                	add    %eax,%edx
  80126f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	01 c8                	add    %ecx,%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80127b:	ff 45 fc             	incl   -0x4(%ebp)
  80127e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801281:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801284:	7c e1                	jl     801267 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801286:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80128d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801294:	eb 1f                	jmp    8012b5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801296:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801299:	8d 50 01             	lea    0x1(%eax),%edx
  80129c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80129f:	89 c2                	mov    %eax,%edx
  8012a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a4:	01 c2                	add    %eax,%edx
  8012a6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ac:	01 c8                	add    %ecx,%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012b2:	ff 45 f8             	incl   -0x8(%ebp)
  8012b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012bb:	7c d9                	jl     801296 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c3:	01 d0                	add    %edx,%eax
  8012c5:	c6 00 00             	movb   $0x0,(%eax)
}
  8012c8:	90                   	nop
  8012c9:	c9                   	leave  
  8012ca:	c3                   	ret    

008012cb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012da:	8b 00                	mov    (%eax),%eax
  8012dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e6:	01 d0                	add    %edx,%eax
  8012e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012ee:	eb 0c                	jmp    8012fc <strsplit+0x31>
			*string++ = 0;
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	8d 50 01             	lea    0x1(%eax),%edx
  8012f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8012f9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	84 c0                	test   %al,%al
  801303:	74 18                	je     80131d <strsplit+0x52>
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	0f be c0             	movsbl %al,%eax
  80130d:	50                   	push   %eax
  80130e:	ff 75 0c             	pushl  0xc(%ebp)
  801311:	e8 13 fb ff ff       	call   800e29 <strchr>
  801316:	83 c4 08             	add    $0x8,%esp
  801319:	85 c0                	test   %eax,%eax
  80131b:	75 d3                	jne    8012f0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	84 c0                	test   %al,%al
  801324:	74 5a                	je     801380 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801326:	8b 45 14             	mov    0x14(%ebp),%eax
  801329:	8b 00                	mov    (%eax),%eax
  80132b:	83 f8 0f             	cmp    $0xf,%eax
  80132e:	75 07                	jne    801337 <strsplit+0x6c>
		{
			return 0;
  801330:	b8 00 00 00 00       	mov    $0x0,%eax
  801335:	eb 66                	jmp    80139d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801337:	8b 45 14             	mov    0x14(%ebp),%eax
  80133a:	8b 00                	mov    (%eax),%eax
  80133c:	8d 48 01             	lea    0x1(%eax),%ecx
  80133f:	8b 55 14             	mov    0x14(%ebp),%edx
  801342:	89 0a                	mov    %ecx,(%edx)
  801344:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80134b:	8b 45 10             	mov    0x10(%ebp),%eax
  80134e:	01 c2                	add    %eax,%edx
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801355:	eb 03                	jmp    80135a <strsplit+0x8f>
			string++;
  801357:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	8a 00                	mov    (%eax),%al
  80135f:	84 c0                	test   %al,%al
  801361:	74 8b                	je     8012ee <strsplit+0x23>
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	0f be c0             	movsbl %al,%eax
  80136b:	50                   	push   %eax
  80136c:	ff 75 0c             	pushl  0xc(%ebp)
  80136f:	e8 b5 fa ff ff       	call   800e29 <strchr>
  801374:	83 c4 08             	add    $0x8,%esp
  801377:	85 c0                	test   %eax,%eax
  801379:	74 dc                	je     801357 <strsplit+0x8c>
			string++;
	}
  80137b:	e9 6e ff ff ff       	jmp    8012ee <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801380:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801381:	8b 45 14             	mov    0x14(%ebp),%eax
  801384:	8b 00                	mov    (%eax),%eax
  801386:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80138d:	8b 45 10             	mov    0x10(%ebp),%eax
  801390:	01 d0                	add    %edx,%eax
  801392:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801398:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8013a5:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8013ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8013af:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8013b2:	01 d0                	add    %edx,%eax
  8013b4:	48                   	dec    %eax
  8013b5:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8013b8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8013bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c0:	f7 75 ac             	divl   -0x54(%ebp)
  8013c3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8013c6:	29 d0                	sub    %edx,%eax
  8013c8:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8013cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8013d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8013d9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8013e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8013e7:	eb 3f                	jmp    801428 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8013e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ec:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8013f3:	83 ec 04             	sub    $0x4,%esp
  8013f6:	50                   	push   %eax
  8013f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8013fa:	68 50 29 80 00       	push   $0x802950
  8013ff:	e8 11 f2 ff ff       	call   800615 <cprintf>
  801404:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801407:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80140a:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801411:	83 ec 04             	sub    $0x4,%esp
  801414:	50                   	push   %eax
  801415:	ff 75 e8             	pushl  -0x18(%ebp)
  801418:	68 65 29 80 00       	push   $0x802965
  80141d:	e8 f3 f1 ff ff       	call   800615 <cprintf>
  801422:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801425:	ff 45 e8             	incl   -0x18(%ebp)
  801428:	a1 28 30 80 00       	mov    0x803028,%eax
  80142d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801430:	7c b7                	jl     8013e9 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801432:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801439:	e9 42 01 00 00       	jmp    801580 <malloc+0x1e1>
		int flag0=1;
  80143e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801448:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80144b:	eb 6b                	jmp    8014b8 <malloc+0x119>
			for(int k=0;k<count;k++){
  80144d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801454:	eb 42                	jmp    801498 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801456:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801459:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801460:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801463:	39 c2                	cmp    %eax,%edx
  801465:	77 2e                	ja     801495 <malloc+0xf6>
  801467:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80146a:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801471:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801474:	39 c2                	cmp    %eax,%edx
  801476:	76 1d                	jbe    801495 <malloc+0xf6>
					ni=arr_add[k].end-i;
  801478:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80147b:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801485:	29 c2                	sub    %eax,%edx
  801487:	89 d0                	mov    %edx,%eax
  801489:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  80148c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801493:	eb 0d                	jmp    8014a2 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801495:	ff 45 d8             	incl   -0x28(%ebp)
  801498:	a1 28 30 80 00       	mov    0x803028,%eax
  80149d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8014a0:	7c b4                	jl     801456 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8014a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014a6:	74 09                	je     8014b1 <malloc+0x112>
				flag0=0;
  8014a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8014af:	eb 16                	jmp    8014c7 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8014b1:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8014b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	01 c2                	add    %eax,%edx
  8014c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014c3:	39 c2                	cmp    %eax,%edx
  8014c5:	77 86                	ja     80144d <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8014c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014cb:	0f 84 a2 00 00 00    	je     801573 <malloc+0x1d4>

			int f=1;
  8014d1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  8014d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014db:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8014de:	89 c8                	mov    %ecx,%eax
  8014e0:	01 c0                	add    %eax,%eax
  8014e2:	01 c8                	add    %ecx,%eax
  8014e4:	c1 e0 02             	shl    $0x2,%eax
  8014e7:	05 20 31 80 00       	add    $0x803120,%eax
  8014ec:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  8014ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8014f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014fa:	89 d0                	mov    %edx,%eax
  8014fc:	01 c0                	add    %eax,%eax
  8014fe:	01 d0                	add    %edx,%eax
  801500:	c1 e0 02             	shl    $0x2,%eax
  801503:	05 24 31 80 00       	add    $0x803124,%eax
  801508:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  80150a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150d:	89 d0                	mov    %edx,%eax
  80150f:	01 c0                	add    %eax,%eax
  801511:	01 d0                	add    %edx,%eax
  801513:	c1 e0 02             	shl    $0x2,%eax
  801516:	05 28 31 80 00       	add    $0x803128,%eax
  80151b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801521:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801524:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80152b:	eb 36                	jmp    801563 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  80152d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	01 c2                	add    %eax,%edx
  801535:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801538:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80153f:	39 c2                	cmp    %eax,%edx
  801541:	73 1d                	jae    801560 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801543:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801546:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80154d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801550:	29 c2                	sub    %eax,%edx
  801552:	89 d0                	mov    %edx,%eax
  801554:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801557:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  80155e:	eb 0d                	jmp    80156d <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801560:	ff 45 d0             	incl   -0x30(%ebp)
  801563:	a1 28 30 80 00       	mov    0x803028,%eax
  801568:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  80156b:	7c c0                	jl     80152d <malloc+0x18e>
					break;

				}
			}

			if(f){
  80156d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801571:	75 1d                	jne    801590 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801573:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  80157a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157d:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801580:	a1 04 30 80 00       	mov    0x803004,%eax
  801585:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801588:	0f 8c b0 fe ff ff    	jl     80143e <malloc+0x9f>
  80158e:	eb 01                	jmp    801591 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801590:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801595:	75 7a                	jne    801611 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801597:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	01 d0                	add    %edx,%eax
  8015a2:	48                   	dec    %eax
  8015a3:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8015a8:	7c 0a                	jl     8015b4 <malloc+0x215>
			return NULL;
  8015aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8015af:	e9 a4 02 00 00       	jmp    801858 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  8015b4:	a1 04 30 80 00       	mov    0x803004,%eax
  8015b9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8015bc:	a1 28 30 80 00       	mov    0x803028,%eax
  8015c1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8015c4:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  8015cb:	83 ec 08             	sub    $0x8,%esp
  8015ce:	ff 75 08             	pushl  0x8(%ebp)
  8015d1:	ff 75 a4             	pushl  -0x5c(%ebp)
  8015d4:	e8 04 06 00 00       	call   801bdd <sys_allocateMem>
  8015d9:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  8015dc:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	01 d0                	add    %edx,%eax
  8015e7:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  8015ec:	a1 28 30 80 00       	mov    0x803028,%eax
  8015f1:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015f7:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  8015fe:	a1 28 30 80 00       	mov    0x803028,%eax
  801603:	40                   	inc    %eax
  801604:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  801609:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80160c:	e9 47 02 00 00       	jmp    801858 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801611:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801618:	e9 ac 00 00 00       	jmp    8016c9 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  80161d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801620:	89 d0                	mov    %edx,%eax
  801622:	01 c0                	add    %eax,%eax
  801624:	01 d0                	add    %edx,%eax
  801626:	c1 e0 02             	shl    $0x2,%eax
  801629:	05 24 31 80 00       	add    $0x803124,%eax
  80162e:	8b 00                	mov    (%eax),%eax
  801630:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801633:	eb 7e                	jmp    8016b3 <malloc+0x314>
			int flag=0;
  801635:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  80163c:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801643:	eb 57                	jmp    80169c <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801645:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801648:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80164f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801652:	39 c2                	cmp    %eax,%edx
  801654:	77 1a                	ja     801670 <malloc+0x2d1>
  801656:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801659:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801660:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801663:	39 c2                	cmp    %eax,%edx
  801665:	76 09                	jbe    801670 <malloc+0x2d1>
								flag=1;
  801667:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  80166e:	eb 36                	jmp    8016a6 <malloc+0x307>
			arr[i].space++;
  801670:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801673:	89 d0                	mov    %edx,%eax
  801675:	01 c0                	add    %eax,%eax
  801677:	01 d0                	add    %edx,%eax
  801679:	c1 e0 02             	shl    $0x2,%eax
  80167c:	05 28 31 80 00       	add    $0x803128,%eax
  801681:	8b 00                	mov    (%eax),%eax
  801683:	8d 48 01             	lea    0x1(%eax),%ecx
  801686:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801689:	89 d0                	mov    %edx,%eax
  80168b:	01 c0                	add    %eax,%eax
  80168d:	01 d0                	add    %edx,%eax
  80168f:	c1 e0 02             	shl    $0x2,%eax
  801692:	05 28 31 80 00       	add    $0x803128,%eax
  801697:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801699:	ff 45 c0             	incl   -0x40(%ebp)
  80169c:	a1 28 30 80 00       	mov    0x803028,%eax
  8016a1:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  8016a4:	7c 9f                	jl     801645 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  8016a6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8016aa:	75 19                	jne    8016c5 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8016ac:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8016b3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8016b6:	a1 04 30 80 00       	mov    0x803004,%eax
  8016bb:	39 c2                	cmp    %eax,%edx
  8016bd:	0f 82 72 ff ff ff    	jb     801635 <malloc+0x296>
  8016c3:	eb 01                	jmp    8016c6 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  8016c5:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  8016c6:	ff 45 cc             	incl   -0x34(%ebp)
  8016c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8016cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016cf:	0f 8c 48 ff ff ff    	jl     80161d <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  8016d5:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  8016dc:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  8016e3:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  8016ea:	eb 37                	jmp    801723 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  8016ec:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8016ef:	89 d0                	mov    %edx,%eax
  8016f1:	01 c0                	add    %eax,%eax
  8016f3:	01 d0                	add    %edx,%eax
  8016f5:	c1 e0 02             	shl    $0x2,%eax
  8016f8:	05 28 31 80 00       	add    $0x803128,%eax
  8016fd:	8b 00                	mov    (%eax),%eax
  8016ff:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801702:	7d 1c                	jge    801720 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801704:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801707:	89 d0                	mov    %edx,%eax
  801709:	01 c0                	add    %eax,%eax
  80170b:	01 d0                	add    %edx,%eax
  80170d:	c1 e0 02             	shl    $0x2,%eax
  801710:	05 28 31 80 00       	add    $0x803128,%eax
  801715:	8b 00                	mov    (%eax),%eax
  801717:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  80171a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80171d:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801720:	ff 45 b4             	incl   -0x4c(%ebp)
  801723:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801726:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801729:	7c c1                	jl     8016ec <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  80172b:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801731:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801734:	89 c8                	mov    %ecx,%eax
  801736:	01 c0                	add    %eax,%eax
  801738:	01 c8                	add    %ecx,%eax
  80173a:	c1 e0 02             	shl    $0x2,%eax
  80173d:	05 20 31 80 00       	add    $0x803120,%eax
  801742:	8b 00                	mov    (%eax),%eax
  801744:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  80174b:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801751:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801754:	89 c8                	mov    %ecx,%eax
  801756:	01 c0                	add    %eax,%eax
  801758:	01 c8                	add    %ecx,%eax
  80175a:	c1 e0 02             	shl    $0x2,%eax
  80175d:	05 24 31 80 00       	add    $0x803124,%eax
  801762:	8b 00                	mov    (%eax),%eax
  801764:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  80176b:	a1 28 30 80 00       	mov    0x803028,%eax
  801770:	40                   	inc    %eax
  801771:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  801776:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801779:	89 d0                	mov    %edx,%eax
  80177b:	01 c0                	add    %eax,%eax
  80177d:	01 d0                	add    %edx,%eax
  80177f:	c1 e0 02             	shl    $0x2,%eax
  801782:	05 20 31 80 00       	add    $0x803120,%eax
  801787:	8b 00                	mov    (%eax),%eax
  801789:	83 ec 08             	sub    $0x8,%esp
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	50                   	push   %eax
  801790:	e8 48 04 00 00       	call   801bdd <sys_allocateMem>
  801795:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801798:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  80179f:	eb 78                	jmp    801819 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8017a1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8017a4:	89 d0                	mov    %edx,%eax
  8017a6:	01 c0                	add    %eax,%eax
  8017a8:	01 d0                	add    %edx,%eax
  8017aa:	c1 e0 02             	shl    $0x2,%eax
  8017ad:	05 20 31 80 00       	add    $0x803120,%eax
  8017b2:	8b 00                	mov    (%eax),%eax
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	50                   	push   %eax
  8017b8:	ff 75 b0             	pushl  -0x50(%ebp)
  8017bb:	68 50 29 80 00       	push   $0x802950
  8017c0:	e8 50 ee ff ff       	call   800615 <cprintf>
  8017c5:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8017c8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8017cb:	89 d0                	mov    %edx,%eax
  8017cd:	01 c0                	add    %eax,%eax
  8017cf:	01 d0                	add    %edx,%eax
  8017d1:	c1 e0 02             	shl    $0x2,%eax
  8017d4:	05 24 31 80 00       	add    $0x803124,%eax
  8017d9:	8b 00                	mov    (%eax),%eax
  8017db:	83 ec 04             	sub    $0x4,%esp
  8017de:	50                   	push   %eax
  8017df:	ff 75 b0             	pushl  -0x50(%ebp)
  8017e2:	68 65 29 80 00       	push   $0x802965
  8017e7:	e8 29 ee ff ff       	call   800615 <cprintf>
  8017ec:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  8017ef:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8017f2:	89 d0                	mov    %edx,%eax
  8017f4:	01 c0                	add    %eax,%eax
  8017f6:	01 d0                	add    %edx,%eax
  8017f8:	c1 e0 02             	shl    $0x2,%eax
  8017fb:	05 28 31 80 00       	add    $0x803128,%eax
  801800:	8b 00                	mov    (%eax),%eax
  801802:	83 ec 04             	sub    $0x4,%esp
  801805:	50                   	push   %eax
  801806:	ff 75 b0             	pushl  -0x50(%ebp)
  801809:	68 78 29 80 00       	push   $0x802978
  80180e:	e8 02 ee ff ff       	call   800615 <cprintf>
  801813:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801816:	ff 45 b0             	incl   -0x50(%ebp)
  801819:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80181c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80181f:	7c 80                	jl     8017a1 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801821:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801824:	89 d0                	mov    %edx,%eax
  801826:	01 c0                	add    %eax,%eax
  801828:	01 d0                	add    %edx,%eax
  80182a:	c1 e0 02             	shl    $0x2,%eax
  80182d:	05 20 31 80 00       	add    $0x803120,%eax
  801832:	8b 00                	mov    (%eax),%eax
  801834:	83 ec 08             	sub    $0x8,%esp
  801837:	50                   	push   %eax
  801838:	68 8c 29 80 00       	push   $0x80298c
  80183d:	e8 d3 ed ff ff       	call   800615 <cprintf>
  801842:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801845:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801848:	89 d0                	mov    %edx,%eax
  80184a:	01 c0                	add    %eax,%eax
  80184c:	01 d0                	add    %edx,%eax
  80184e:	c1 e0 02             	shl    $0x2,%eax
  801851:	05 20 31 80 00       	add    $0x803120,%eax
  801856:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801866:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80186d:	eb 4b                	jmp    8018ba <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  80186f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801872:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801879:	89 c2                	mov    %eax,%edx
  80187b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80187e:	39 c2                	cmp    %eax,%edx
  801880:	7f 35                	jg     8018b7 <free+0x5d>
  801882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801885:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  80188c:	89 c2                	mov    %eax,%edx
  80188e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801891:	39 c2                	cmp    %eax,%edx
  801893:	7e 22                	jle    8018b7 <free+0x5d>
				start=arr_add[i].start;
  801895:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801898:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80189f:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8018a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a5:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8018ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8018af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8018b5:	eb 0d                	jmp    8018c4 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8018b7:	ff 45 ec             	incl   -0x14(%ebp)
  8018ba:	a1 28 30 80 00       	mov    0x803028,%eax
  8018bf:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8018c2:	7c ab                	jl     80186f <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8018c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c7:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8018ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d1:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8018d8:	29 c2                	sub    %eax,%edx
  8018da:	89 d0                	mov    %edx,%eax
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	50                   	push   %eax
  8018e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e3:	e8 d9 02 00 00       	call   801bc1 <sys_freeMem>
  8018e8:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  8018eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018f1:	eb 2d                	jmp    801920 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  8018f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f6:	40                   	inc    %eax
  8018f7:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8018fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801901:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80190b:	40                   	inc    %eax
  80190c:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801913:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801916:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  80191d:	ff 45 e8             	incl   -0x18(%ebp)
  801920:	a1 28 30 80 00       	mov    0x803028,%eax
  801925:	48                   	dec    %eax
  801926:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801929:	7f c8                	jg     8018f3 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  80192b:	a1 28 30 80 00       	mov    0x803028,%eax
  801930:	48                   	dec    %eax
  801931:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801936:	90                   	nop
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 18             	sub    $0x18,%esp
  80193f:	8b 45 10             	mov    0x10(%ebp),%eax
  801942:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801945:	83 ec 04             	sub    $0x4,%esp
  801948:	68 a8 29 80 00       	push   $0x8029a8
  80194d:	68 18 01 00 00       	push   $0x118
  801952:	68 cb 29 80 00       	push   $0x8029cb
  801957:	e8 17 ea ff ff       	call   800373 <_panic>

0080195c <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	68 a8 29 80 00       	push   $0x8029a8
  80196a:	68 1e 01 00 00       	push   $0x11e
  80196f:	68 cb 29 80 00       	push   $0x8029cb
  801974:	e8 fa e9 ff ff       	call   800373 <_panic>

00801979 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	68 a8 29 80 00       	push   $0x8029a8
  801987:	68 24 01 00 00       	push   $0x124
  80198c:	68 cb 29 80 00       	push   $0x8029cb
  801991:	e8 dd e9 ff ff       	call   800373 <_panic>

00801996 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80199c:	83 ec 04             	sub    $0x4,%esp
  80199f:	68 a8 29 80 00       	push   $0x8029a8
  8019a4:	68 29 01 00 00       	push   $0x129
  8019a9:	68 cb 29 80 00       	push   $0x8029cb
  8019ae:	e8 c0 e9 ff ff       	call   800373 <_panic>

008019b3 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019b9:	83 ec 04             	sub    $0x4,%esp
  8019bc:	68 a8 29 80 00       	push   $0x8029a8
  8019c1:	68 2f 01 00 00       	push   $0x12f
  8019c6:	68 cb 29 80 00       	push   $0x8029cb
  8019cb:	e8 a3 e9 ff ff       	call   800373 <_panic>

008019d0 <shrink>:
}
void shrink(uint32 newSize)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019d6:	83 ec 04             	sub    $0x4,%esp
  8019d9:	68 a8 29 80 00       	push   $0x8029a8
  8019de:	68 33 01 00 00       	push   $0x133
  8019e3:	68 cb 29 80 00       	push   $0x8029cb
  8019e8:	e8 86 e9 ff ff       	call   800373 <_panic>

008019ed <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019f3:	83 ec 04             	sub    $0x4,%esp
  8019f6:	68 a8 29 80 00       	push   $0x8029a8
  8019fb:	68 38 01 00 00       	push   $0x138
  801a00:	68 cb 29 80 00       	push   $0x8029cb
  801a05:	e8 69 e9 ff ff       	call   800373 <_panic>

00801a0a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	57                   	push   %edi
  801a0e:	56                   	push   %esi
  801a0f:	53                   	push   %ebx
  801a10:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a1c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a1f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a22:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a25:	cd 30                	int    $0x30
  801a27:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	5b                   	pop    %ebx
  801a31:	5e                   	pop    %esi
  801a32:	5f                   	pop    %edi
  801a33:	5d                   	pop    %ebp
  801a34:	c3                   	ret    

00801a35 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	83 ec 04             	sub    $0x4,%esp
  801a3b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a41:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	52                   	push   %edx
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	50                   	push   %eax
  801a51:	6a 00                	push   $0x0
  801a53:	e8 b2 ff ff ff       	call   801a0a <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	90                   	nop
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_cgetc>:

int
sys_cgetc(void)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 01                	push   $0x1
  801a6d:	e8 98 ff ff ff       	call   801a0a <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	50                   	push   %eax
  801a86:	6a 05                	push   $0x5
  801a88:	e8 7d ff ff ff       	call   801a0a <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 02                	push   $0x2
  801aa1:	e8 64 ff ff ff       	call   801a0a <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 03                	push   $0x3
  801aba:	e8 4b ff ff ff       	call   801a0a <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 04                	push   $0x4
  801ad3:	e8 32 ff ff ff       	call   801a0a <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_env_exit>:


void sys_env_exit(void)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 06                	push   $0x6
  801aec:	e8 19 ff ff ff       	call   801a0a <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	90                   	nop
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	52                   	push   %edx
  801b07:	50                   	push   %eax
  801b08:	6a 07                	push   $0x7
  801b0a:	e8 fb fe ff ff       	call   801a0a <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	56                   	push   %esi
  801b18:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b19:	8b 75 18             	mov    0x18(%ebp),%esi
  801b1c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	56                   	push   %esi
  801b29:	53                   	push   %ebx
  801b2a:	51                   	push   %ecx
  801b2b:	52                   	push   %edx
  801b2c:	50                   	push   %eax
  801b2d:	6a 08                	push   $0x8
  801b2f:	e8 d6 fe ff ff       	call   801a0a <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3a:	5b                   	pop    %ebx
  801b3b:	5e                   	pop    %esi
  801b3c:	5d                   	pop    %ebp
  801b3d:	c3                   	ret    

00801b3e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	52                   	push   %edx
  801b4e:	50                   	push   %eax
  801b4f:	6a 09                	push   $0x9
  801b51:	e8 b4 fe ff ff       	call   801a0a <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	ff 75 0c             	pushl  0xc(%ebp)
  801b67:	ff 75 08             	pushl  0x8(%ebp)
  801b6a:	6a 0a                	push   $0xa
  801b6c:	e8 99 fe ff ff       	call   801a0a <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 0b                	push   $0xb
  801b85:	e8 80 fe ff ff       	call   801a0a <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 0c                	push   $0xc
  801b9e:	e8 67 fe ff ff       	call   801a0a <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 0d                	push   $0xd
  801bb7:	e8 4e fe ff ff       	call   801a0a <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	6a 11                	push   $0x11
  801bd2:	e8 33 fe ff ff       	call   801a0a <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
	return;
  801bda:	90                   	nop
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	ff 75 0c             	pushl  0xc(%ebp)
  801be9:	ff 75 08             	pushl  0x8(%ebp)
  801bec:	6a 12                	push   $0x12
  801bee:	e8 17 fe ff ff       	call   801a0a <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf6:	90                   	nop
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 0e                	push   $0xe
  801c08:	e8 fd fd ff ff       	call   801a0a <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	ff 75 08             	pushl  0x8(%ebp)
  801c20:	6a 0f                	push   $0xf
  801c22:	e8 e3 fd ff ff       	call   801a0a <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 10                	push   $0x10
  801c3b:	e8 ca fd ff ff       	call   801a0a <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	90                   	nop
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 14                	push   $0x14
  801c55:	e8 b0 fd ff ff       	call   801a0a <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	90                   	nop
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 15                	push   $0x15
  801c6f:	e8 96 fd ff ff       	call   801a0a <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
}
  801c77:	90                   	nop
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_cputc>:


void
sys_cputc(const char c)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 04             	sub    $0x4,%esp
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c86:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	50                   	push   %eax
  801c93:	6a 16                	push   $0x16
  801c95:	e8 70 fd ff ff       	call   801a0a <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
}
  801c9d:	90                   	nop
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 17                	push   $0x17
  801caf:	e8 56 fd ff ff       	call   801a0a <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	90                   	nop
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	ff 75 0c             	pushl  0xc(%ebp)
  801cc9:	50                   	push   %eax
  801cca:	6a 18                	push   $0x18
  801ccc:	e8 39 fd ff ff       	call   801a0a <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	52                   	push   %edx
  801ce6:	50                   	push   %eax
  801ce7:	6a 1b                	push   $0x1b
  801ce9:	e8 1c fd ff ff       	call   801a0a <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	52                   	push   %edx
  801d03:	50                   	push   %eax
  801d04:	6a 19                	push   $0x19
  801d06:	e8 ff fc ff ff       	call   801a0a <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	90                   	nop
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	52                   	push   %edx
  801d21:	50                   	push   %eax
  801d22:	6a 1a                	push   $0x1a
  801d24:	e8 e1 fc ff ff       	call   801a0a <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	90                   	nop
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	83 ec 04             	sub    $0x4,%esp
  801d35:	8b 45 10             	mov    0x10(%ebp),%eax
  801d38:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d3b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d3e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	6a 00                	push   $0x0
  801d47:	51                   	push   %ecx
  801d48:	52                   	push   %edx
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	50                   	push   %eax
  801d4d:	6a 1c                	push   $0x1c
  801d4f:	e8 b6 fc ff ff       	call   801a0a <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	52                   	push   %edx
  801d69:	50                   	push   %eax
  801d6a:	6a 1d                	push   $0x1d
  801d6c:	e8 99 fc ff ff       	call   801a0a <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d79:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	51                   	push   %ecx
  801d87:	52                   	push   %edx
  801d88:	50                   	push   %eax
  801d89:	6a 1e                	push   $0x1e
  801d8b:	e8 7a fc ff ff       	call   801a0a <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	52                   	push   %edx
  801da5:	50                   	push   %eax
  801da6:	6a 1f                	push   $0x1f
  801da8:	e8 5d fc ff ff       	call   801a0a <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 20                	push   $0x20
  801dc1:	e8 44 fc ff ff       	call   801a0a <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	6a 00                	push   $0x0
  801dd3:	ff 75 14             	pushl  0x14(%ebp)
  801dd6:	ff 75 10             	pushl  0x10(%ebp)
  801dd9:	ff 75 0c             	pushl  0xc(%ebp)
  801ddc:	50                   	push   %eax
  801ddd:	6a 21                	push   $0x21
  801ddf:	e8 26 fc ff ff       	call   801a0a <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	50                   	push   %eax
  801df8:	6a 22                	push   $0x22
  801dfa:	e8 0b fc ff ff       	call   801a0a <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	90                   	nop
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	50                   	push   %eax
  801e14:	6a 23                	push   $0x23
  801e16:	e8 ef fb ff ff       	call   801a0a <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
}
  801e1e:	90                   	nop
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e27:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e2a:	8d 50 04             	lea    0x4(%eax),%edx
  801e2d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	52                   	push   %edx
  801e37:	50                   	push   %eax
  801e38:	6a 24                	push   $0x24
  801e3a:	e8 cb fb ff ff       	call   801a0a <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
	return result;
  801e42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e4b:	89 01                	mov    %eax,(%ecx)
  801e4d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	c9                   	leave  
  801e54:	c2 04 00             	ret    $0x4

00801e57 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	ff 75 10             	pushl  0x10(%ebp)
  801e61:	ff 75 0c             	pushl  0xc(%ebp)
  801e64:	ff 75 08             	pushl  0x8(%ebp)
  801e67:	6a 13                	push   $0x13
  801e69:	e8 9c fb ff ff       	call   801a0a <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e71:	90                   	nop
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 25                	push   $0x25
  801e83:	e8 82 fb ff ff       	call   801a0a <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e99:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	50                   	push   %eax
  801ea6:	6a 26                	push   $0x26
  801ea8:	e8 5d fb ff ff       	call   801a0a <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb0:	90                   	nop
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <rsttst>:
void rsttst()
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 28                	push   $0x28
  801ec2:	e8 43 fb ff ff       	call   801a0a <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eca:	90                   	nop
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 04             	sub    $0x4,%esp
  801ed3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ed9:	8b 55 18             	mov    0x18(%ebp),%edx
  801edc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ee0:	52                   	push   %edx
  801ee1:	50                   	push   %eax
  801ee2:	ff 75 10             	pushl  0x10(%ebp)
  801ee5:	ff 75 0c             	pushl  0xc(%ebp)
  801ee8:	ff 75 08             	pushl  0x8(%ebp)
  801eeb:	6a 27                	push   $0x27
  801eed:	e8 18 fb ff ff       	call   801a0a <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef5:	90                   	nop
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <chktst>:
void chktst(uint32 n)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	ff 75 08             	pushl  0x8(%ebp)
  801f06:	6a 29                	push   $0x29
  801f08:	e8 fd fa ff ff       	call   801a0a <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f10:	90                   	nop
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <inctst>:

void inctst()
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 2a                	push   $0x2a
  801f22:	e8 e3 fa ff ff       	call   801a0a <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2a:	90                   	nop
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <gettst>:
uint32 gettst()
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 2b                	push   $0x2b
  801f3c:	e8 c9 fa ff ff       	call   801a0a <syscall>
  801f41:	83 c4 18             	add    $0x18,%esp
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 2c                	push   $0x2c
  801f58:	e8 ad fa ff ff       	call   801a0a <syscall>
  801f5d:	83 c4 18             	add    $0x18,%esp
  801f60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f63:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f67:	75 07                	jne    801f70 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f69:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6e:	eb 05                	jmp    801f75 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 2c                	push   $0x2c
  801f89:	e8 7c fa ff ff       	call   801a0a <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
  801f91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f94:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f98:	75 07                	jne    801fa1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9f:	eb 05                	jmp    801fa6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 2c                	push   $0x2c
  801fba:	e8 4b fa ff ff       	call   801a0a <syscall>
  801fbf:	83 c4 18             	add    $0x18,%esp
  801fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fc5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fc9:	75 07                	jne    801fd2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fcb:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd0:	eb 05                	jmp    801fd7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 2c                	push   $0x2c
  801feb:	e8 1a fa ff ff       	call   801a0a <syscall>
  801ff0:	83 c4 18             	add    $0x18,%esp
  801ff3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ff6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ffa:	75 07                	jne    802003 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ffc:	b8 01 00 00 00       	mov    $0x1,%eax
  802001:	eb 05                	jmp    802008 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802003:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	ff 75 08             	pushl  0x8(%ebp)
  802018:	6a 2d                	push   $0x2d
  80201a:	e8 eb f9 ff ff       	call   801a0a <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
	return ;
  802022:	90                   	nop
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802029:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80202c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	6a 00                	push   $0x0
  802037:	53                   	push   %ebx
  802038:	51                   	push   %ecx
  802039:	52                   	push   %edx
  80203a:	50                   	push   %eax
  80203b:	6a 2e                	push   $0x2e
  80203d:	e8 c8 f9 ff ff       	call   801a0a <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	52                   	push   %edx
  80205a:	50                   	push   %eax
  80205b:	6a 2f                	push   $0x2f
  80205d:	e8 a8 f9 ff ff       	call   801a0a <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    
  802067:	90                   	nop

00802068 <__udivdi3>:
  802068:	55                   	push   %ebp
  802069:	57                   	push   %edi
  80206a:	56                   	push   %esi
  80206b:	53                   	push   %ebx
  80206c:	83 ec 1c             	sub    $0x1c,%esp
  80206f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802073:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802077:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80207b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80207f:	89 ca                	mov    %ecx,%edx
  802081:	89 f8                	mov    %edi,%eax
  802083:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802087:	85 f6                	test   %esi,%esi
  802089:	75 2d                	jne    8020b8 <__udivdi3+0x50>
  80208b:	39 cf                	cmp    %ecx,%edi
  80208d:	77 65                	ja     8020f4 <__udivdi3+0x8c>
  80208f:	89 fd                	mov    %edi,%ebp
  802091:	85 ff                	test   %edi,%edi
  802093:	75 0b                	jne    8020a0 <__udivdi3+0x38>
  802095:	b8 01 00 00 00       	mov    $0x1,%eax
  80209a:	31 d2                	xor    %edx,%edx
  80209c:	f7 f7                	div    %edi
  80209e:	89 c5                	mov    %eax,%ebp
  8020a0:	31 d2                	xor    %edx,%edx
  8020a2:	89 c8                	mov    %ecx,%eax
  8020a4:	f7 f5                	div    %ebp
  8020a6:	89 c1                	mov    %eax,%ecx
  8020a8:	89 d8                	mov    %ebx,%eax
  8020aa:	f7 f5                	div    %ebp
  8020ac:	89 cf                	mov    %ecx,%edi
  8020ae:	89 fa                	mov    %edi,%edx
  8020b0:	83 c4 1c             	add    $0x1c,%esp
  8020b3:	5b                   	pop    %ebx
  8020b4:	5e                   	pop    %esi
  8020b5:	5f                   	pop    %edi
  8020b6:	5d                   	pop    %ebp
  8020b7:	c3                   	ret    
  8020b8:	39 ce                	cmp    %ecx,%esi
  8020ba:	77 28                	ja     8020e4 <__udivdi3+0x7c>
  8020bc:	0f bd fe             	bsr    %esi,%edi
  8020bf:	83 f7 1f             	xor    $0x1f,%edi
  8020c2:	75 40                	jne    802104 <__udivdi3+0x9c>
  8020c4:	39 ce                	cmp    %ecx,%esi
  8020c6:	72 0a                	jb     8020d2 <__udivdi3+0x6a>
  8020c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8020cc:	0f 87 9e 00 00 00    	ja     802170 <__udivdi3+0x108>
  8020d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d7:	89 fa                	mov    %edi,%edx
  8020d9:	83 c4 1c             	add    $0x1c,%esp
  8020dc:	5b                   	pop    %ebx
  8020dd:	5e                   	pop    %esi
  8020de:	5f                   	pop    %edi
  8020df:	5d                   	pop    %ebp
  8020e0:	c3                   	ret    
  8020e1:	8d 76 00             	lea    0x0(%esi),%esi
  8020e4:	31 ff                	xor    %edi,%edi
  8020e6:	31 c0                	xor    %eax,%eax
  8020e8:	89 fa                	mov    %edi,%edx
  8020ea:	83 c4 1c             	add    $0x1c,%esp
  8020ed:	5b                   	pop    %ebx
  8020ee:	5e                   	pop    %esi
  8020ef:	5f                   	pop    %edi
  8020f0:	5d                   	pop    %ebp
  8020f1:	c3                   	ret    
  8020f2:	66 90                	xchg   %ax,%ax
  8020f4:	89 d8                	mov    %ebx,%eax
  8020f6:	f7 f7                	div    %edi
  8020f8:	31 ff                	xor    %edi,%edi
  8020fa:	89 fa                	mov    %edi,%edx
  8020fc:	83 c4 1c             	add    $0x1c,%esp
  8020ff:	5b                   	pop    %ebx
  802100:	5e                   	pop    %esi
  802101:	5f                   	pop    %edi
  802102:	5d                   	pop    %ebp
  802103:	c3                   	ret    
  802104:	bd 20 00 00 00       	mov    $0x20,%ebp
  802109:	89 eb                	mov    %ebp,%ebx
  80210b:	29 fb                	sub    %edi,%ebx
  80210d:	89 f9                	mov    %edi,%ecx
  80210f:	d3 e6                	shl    %cl,%esi
  802111:	89 c5                	mov    %eax,%ebp
  802113:	88 d9                	mov    %bl,%cl
  802115:	d3 ed                	shr    %cl,%ebp
  802117:	89 e9                	mov    %ebp,%ecx
  802119:	09 f1                	or     %esi,%ecx
  80211b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80211f:	89 f9                	mov    %edi,%ecx
  802121:	d3 e0                	shl    %cl,%eax
  802123:	89 c5                	mov    %eax,%ebp
  802125:	89 d6                	mov    %edx,%esi
  802127:	88 d9                	mov    %bl,%cl
  802129:	d3 ee                	shr    %cl,%esi
  80212b:	89 f9                	mov    %edi,%ecx
  80212d:	d3 e2                	shl    %cl,%edx
  80212f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802133:	88 d9                	mov    %bl,%cl
  802135:	d3 e8                	shr    %cl,%eax
  802137:	09 c2                	or     %eax,%edx
  802139:	89 d0                	mov    %edx,%eax
  80213b:	89 f2                	mov    %esi,%edx
  80213d:	f7 74 24 0c          	divl   0xc(%esp)
  802141:	89 d6                	mov    %edx,%esi
  802143:	89 c3                	mov    %eax,%ebx
  802145:	f7 e5                	mul    %ebp
  802147:	39 d6                	cmp    %edx,%esi
  802149:	72 19                	jb     802164 <__udivdi3+0xfc>
  80214b:	74 0b                	je     802158 <__udivdi3+0xf0>
  80214d:	89 d8                	mov    %ebx,%eax
  80214f:	31 ff                	xor    %edi,%edi
  802151:	e9 58 ff ff ff       	jmp    8020ae <__udivdi3+0x46>
  802156:	66 90                	xchg   %ax,%ax
  802158:	8b 54 24 08          	mov    0x8(%esp),%edx
  80215c:	89 f9                	mov    %edi,%ecx
  80215e:	d3 e2                	shl    %cl,%edx
  802160:	39 c2                	cmp    %eax,%edx
  802162:	73 e9                	jae    80214d <__udivdi3+0xe5>
  802164:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802167:	31 ff                	xor    %edi,%edi
  802169:	e9 40 ff ff ff       	jmp    8020ae <__udivdi3+0x46>
  80216e:	66 90                	xchg   %ax,%ax
  802170:	31 c0                	xor    %eax,%eax
  802172:	e9 37 ff ff ff       	jmp    8020ae <__udivdi3+0x46>
  802177:	90                   	nop

00802178 <__umoddi3>:
  802178:	55                   	push   %ebp
  802179:	57                   	push   %edi
  80217a:	56                   	push   %esi
  80217b:	53                   	push   %ebx
  80217c:	83 ec 1c             	sub    $0x1c,%esp
  80217f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802183:	8b 74 24 34          	mov    0x34(%esp),%esi
  802187:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80218b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80218f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802193:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802197:	89 f3                	mov    %esi,%ebx
  802199:	89 fa                	mov    %edi,%edx
  80219b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80219f:	89 34 24             	mov    %esi,(%esp)
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	75 1a                	jne    8021c0 <__umoddi3+0x48>
  8021a6:	39 f7                	cmp    %esi,%edi
  8021a8:	0f 86 a2 00 00 00    	jbe    802250 <__umoddi3+0xd8>
  8021ae:	89 c8                	mov    %ecx,%eax
  8021b0:	89 f2                	mov    %esi,%edx
  8021b2:	f7 f7                	div    %edi
  8021b4:	89 d0                	mov    %edx,%eax
  8021b6:	31 d2                	xor    %edx,%edx
  8021b8:	83 c4 1c             	add    $0x1c,%esp
  8021bb:	5b                   	pop    %ebx
  8021bc:	5e                   	pop    %esi
  8021bd:	5f                   	pop    %edi
  8021be:	5d                   	pop    %ebp
  8021bf:	c3                   	ret    
  8021c0:	39 f0                	cmp    %esi,%eax
  8021c2:	0f 87 ac 00 00 00    	ja     802274 <__umoddi3+0xfc>
  8021c8:	0f bd e8             	bsr    %eax,%ebp
  8021cb:	83 f5 1f             	xor    $0x1f,%ebp
  8021ce:	0f 84 ac 00 00 00    	je     802280 <__umoddi3+0x108>
  8021d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8021d9:	29 ef                	sub    %ebp,%edi
  8021db:	89 fe                	mov    %edi,%esi
  8021dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021e1:	89 e9                	mov    %ebp,%ecx
  8021e3:	d3 e0                	shl    %cl,%eax
  8021e5:	89 d7                	mov    %edx,%edi
  8021e7:	89 f1                	mov    %esi,%ecx
  8021e9:	d3 ef                	shr    %cl,%edi
  8021eb:	09 c7                	or     %eax,%edi
  8021ed:	89 e9                	mov    %ebp,%ecx
  8021ef:	d3 e2                	shl    %cl,%edx
  8021f1:	89 14 24             	mov    %edx,(%esp)
  8021f4:	89 d8                	mov    %ebx,%eax
  8021f6:	d3 e0                	shl    %cl,%eax
  8021f8:	89 c2                	mov    %eax,%edx
  8021fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021fe:	d3 e0                	shl    %cl,%eax
  802200:	89 44 24 04          	mov    %eax,0x4(%esp)
  802204:	8b 44 24 08          	mov    0x8(%esp),%eax
  802208:	89 f1                	mov    %esi,%ecx
  80220a:	d3 e8                	shr    %cl,%eax
  80220c:	09 d0                	or     %edx,%eax
  80220e:	d3 eb                	shr    %cl,%ebx
  802210:	89 da                	mov    %ebx,%edx
  802212:	f7 f7                	div    %edi
  802214:	89 d3                	mov    %edx,%ebx
  802216:	f7 24 24             	mull   (%esp)
  802219:	89 c6                	mov    %eax,%esi
  80221b:	89 d1                	mov    %edx,%ecx
  80221d:	39 d3                	cmp    %edx,%ebx
  80221f:	0f 82 87 00 00 00    	jb     8022ac <__umoddi3+0x134>
  802225:	0f 84 91 00 00 00    	je     8022bc <__umoddi3+0x144>
  80222b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80222f:	29 f2                	sub    %esi,%edx
  802231:	19 cb                	sbb    %ecx,%ebx
  802233:	89 d8                	mov    %ebx,%eax
  802235:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802239:	d3 e0                	shl    %cl,%eax
  80223b:	89 e9                	mov    %ebp,%ecx
  80223d:	d3 ea                	shr    %cl,%edx
  80223f:	09 d0                	or     %edx,%eax
  802241:	89 e9                	mov    %ebp,%ecx
  802243:	d3 eb                	shr    %cl,%ebx
  802245:	89 da                	mov    %ebx,%edx
  802247:	83 c4 1c             	add    $0x1c,%esp
  80224a:	5b                   	pop    %ebx
  80224b:	5e                   	pop    %esi
  80224c:	5f                   	pop    %edi
  80224d:	5d                   	pop    %ebp
  80224e:	c3                   	ret    
  80224f:	90                   	nop
  802250:	89 fd                	mov    %edi,%ebp
  802252:	85 ff                	test   %edi,%edi
  802254:	75 0b                	jne    802261 <__umoddi3+0xe9>
  802256:	b8 01 00 00 00       	mov    $0x1,%eax
  80225b:	31 d2                	xor    %edx,%edx
  80225d:	f7 f7                	div    %edi
  80225f:	89 c5                	mov    %eax,%ebp
  802261:	89 f0                	mov    %esi,%eax
  802263:	31 d2                	xor    %edx,%edx
  802265:	f7 f5                	div    %ebp
  802267:	89 c8                	mov    %ecx,%eax
  802269:	f7 f5                	div    %ebp
  80226b:	89 d0                	mov    %edx,%eax
  80226d:	e9 44 ff ff ff       	jmp    8021b6 <__umoddi3+0x3e>
  802272:	66 90                	xchg   %ax,%ax
  802274:	89 c8                	mov    %ecx,%eax
  802276:	89 f2                	mov    %esi,%edx
  802278:	83 c4 1c             	add    $0x1c,%esp
  80227b:	5b                   	pop    %ebx
  80227c:	5e                   	pop    %esi
  80227d:	5f                   	pop    %edi
  80227e:	5d                   	pop    %ebp
  80227f:	c3                   	ret    
  802280:	3b 04 24             	cmp    (%esp),%eax
  802283:	72 06                	jb     80228b <__umoddi3+0x113>
  802285:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802289:	77 0f                	ja     80229a <__umoddi3+0x122>
  80228b:	89 f2                	mov    %esi,%edx
  80228d:	29 f9                	sub    %edi,%ecx
  80228f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802293:	89 14 24             	mov    %edx,(%esp)
  802296:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80229a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80229e:	8b 14 24             	mov    (%esp),%edx
  8022a1:	83 c4 1c             	add    $0x1c,%esp
  8022a4:	5b                   	pop    %ebx
  8022a5:	5e                   	pop    %esi
  8022a6:	5f                   	pop    %edi
  8022a7:	5d                   	pop    %ebp
  8022a8:	c3                   	ret    
  8022a9:	8d 76 00             	lea    0x0(%esi),%esi
  8022ac:	2b 04 24             	sub    (%esp),%eax
  8022af:	19 fa                	sbb    %edi,%edx
  8022b1:	89 d1                	mov    %edx,%ecx
  8022b3:	89 c6                	mov    %eax,%esi
  8022b5:	e9 71 ff ff ff       	jmp    80222b <__umoddi3+0xb3>
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8022c0:	72 ea                	jb     8022ac <__umoddi3+0x134>
  8022c2:	89 d9                	mov    %ebx,%ecx
  8022c4:	e9 62 ff ff ff       	jmp    80222b <__umoddi3+0xb3>
