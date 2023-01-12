
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 8b 10 00 00       	call   8010db <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 e0 21 80 00       	push   $0x8021e0
  800061:	e8 18 03 00 00       	call   80037e <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 f3 21 80 00       	push   $0x8021f3
  8000be:	e8 bb 02 00 00       	call   80037e <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 ba 14 00 00       	call   801596 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 f1 0f 00 00       	call   8010db <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 f3 21 80 00       	push   $0x8021f3
  800114:	e8 65 02 00 00       	call   80037e <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 64 14 00 00       	call   801596 <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013e:	e8 a4 16 00 00       	call   8017e7 <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	c1 e0 03             	shl    $0x3,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800157:	01 c8                	add    %ecx,%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	01 d0                	add    %edx,%eax
  80015d:	01 c0                	add    %eax,%eax
  80015f:	01 d0                	add    %edx,%eax
  800161:	89 c2                	mov    %eax,%edx
  800163:	c1 e2 05             	shl    $0x5,%edx
  800166:	29 c2                	sub    %eax,%edx
  800168:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80016f:	89 c2                	mov    %eax,%edx
  800171:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800177:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80017c:	a1 20 30 80 00       	mov    0x803020,%eax
  800181:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800187:	84 c0                	test   %al,%al
  800189:	74 0f                	je     80019a <libmain+0x62>
		binaryname = myEnv->prog_name;
  80018b:	a1 20 30 80 00       	mov    0x803020,%eax
  800190:	05 40 3c 01 00       	add    $0x13c40,%eax
  800195:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019e:	7e 0a                	jle    8001aa <libmain+0x72>
		binaryname = argv[0];
  8001a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a3:	8b 00                	mov    (%eax),%eax
  8001a5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	ff 75 0c             	pushl  0xc(%ebp)
  8001b0:	ff 75 08             	pushl  0x8(%ebp)
  8001b3:	e8 80 fe ff ff       	call   800038 <_main>
  8001b8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001bb:	e8 c2 17 00 00       	call   801982 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	68 18 22 80 00       	push   $0x802218
  8001c8:	e8 84 01 00 00       	call   800351 <cprintf>
  8001cd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d5:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8001db:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e0:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8001e6:	83 ec 04             	sub    $0x4,%esp
  8001e9:	52                   	push   %edx
  8001ea:	50                   	push   %eax
  8001eb:	68 40 22 80 00       	push   $0x802240
  8001f0:	e8 5c 01 00 00       	call   800351 <cprintf>
  8001f5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8001f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fd:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800203:	a1 20 30 80 00       	mov    0x803020,%eax
  800208:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80020e:	83 ec 04             	sub    $0x4,%esp
  800211:	52                   	push   %edx
  800212:	50                   	push   %eax
  800213:	68 68 22 80 00       	push   $0x802268
  800218:	e8 34 01 00 00       	call   800351 <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800220:	a1 20 30 80 00       	mov    0x803020,%eax
  800225:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80022b:	83 ec 08             	sub    $0x8,%esp
  80022e:	50                   	push   %eax
  80022f:	68 a9 22 80 00       	push   $0x8022a9
  800234:	e8 18 01 00 00       	call   800351 <cprintf>
  800239:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	68 18 22 80 00       	push   $0x802218
  800244:	e8 08 01 00 00       	call   800351 <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024c:	e8 4b 17 00 00       	call   80199c <sys_enable_interrupt>

	// exit gracefully
	exit();
  800251:	e8 19 00 00 00       	call   80026f <exit>
}
  800256:	90                   	nop
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	6a 00                	push   $0x0
  800264:	e8 4a 15 00 00       	call   8017b3 <sys_env_destroy>
  800269:	83 c4 10             	add    $0x10,%esp
}
  80026c:	90                   	nop
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <exit>:

void
exit(void)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800275:	e8 9f 15 00 00       	call   801819 <sys_env_exit>
}
  80027a:	90                   	nop
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800283:	8b 45 0c             	mov    0xc(%ebp),%eax
  800286:	8b 00                	mov    (%eax),%eax
  800288:	8d 48 01             	lea    0x1(%eax),%ecx
  80028b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028e:	89 0a                	mov    %ecx,(%edx)
  800290:	8b 55 08             	mov    0x8(%ebp),%edx
  800293:	88 d1                	mov    %dl,%cl
  800295:	8b 55 0c             	mov    0xc(%ebp),%edx
  800298:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80029c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029f:	8b 00                	mov    (%eax),%eax
  8002a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a6:	75 2c                	jne    8002d4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002a8:	a0 24 30 80 00       	mov    0x803024,%al
  8002ad:	0f b6 c0             	movzbl %al,%eax
  8002b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b3:	8b 12                	mov    (%edx),%edx
  8002b5:	89 d1                	mov    %edx,%ecx
  8002b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ba:	83 c2 08             	add    $0x8,%edx
  8002bd:	83 ec 04             	sub    $0x4,%esp
  8002c0:	50                   	push   %eax
  8002c1:	51                   	push   %ecx
  8002c2:	52                   	push   %edx
  8002c3:	e8 a9 14 00 00       	call   801771 <sys_cputs>
  8002c8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	8b 40 04             	mov    0x4(%eax),%eax
  8002da:	8d 50 01             	lea    0x1(%eax),%edx
  8002dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002e3:	90                   	nop
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    

008002e6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f6:	00 00 00 
	b.cnt = 0;
  8002f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800300:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800303:	ff 75 0c             	pushl  0xc(%ebp)
  800306:	ff 75 08             	pushl  0x8(%ebp)
  800309:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80030f:	50                   	push   %eax
  800310:	68 7d 02 80 00       	push   $0x80027d
  800315:	e8 11 02 00 00       	call   80052b <vprintfmt>
  80031a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80031d:	a0 24 30 80 00       	mov    0x803024,%al
  800322:	0f b6 c0             	movzbl %al,%eax
  800325:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80032b:	83 ec 04             	sub    $0x4,%esp
  80032e:	50                   	push   %eax
  80032f:	52                   	push   %edx
  800330:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800336:	83 c0 08             	add    $0x8,%eax
  800339:	50                   	push   %eax
  80033a:	e8 32 14 00 00       	call   801771 <sys_cputs>
  80033f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800342:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800349:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80034f:	c9                   	leave  
  800350:	c3                   	ret    

00800351 <cprintf>:

int cprintf(const char *fmt, ...) {
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800357:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80035e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800364:	8b 45 08             	mov    0x8(%ebp),%eax
  800367:	83 ec 08             	sub    $0x8,%esp
  80036a:	ff 75 f4             	pushl  -0xc(%ebp)
  80036d:	50                   	push   %eax
  80036e:	e8 73 ff ff ff       	call   8002e6 <vcprintf>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800379:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800384:	e8 f9 15 00 00       	call   801982 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800389:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	ff 75 f4             	pushl  -0xc(%ebp)
  800398:	50                   	push   %eax
  800399:	e8 48 ff ff ff       	call   8002e6 <vcprintf>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003a4:	e8 f3 15 00 00       	call   80199c <sys_enable_interrupt>
	return cnt;
  8003a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003ac:	c9                   	leave  
  8003ad:	c3                   	ret    

008003ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	53                   	push   %ebx
  8003b2:	83 ec 14             	sub    $0x14,%esp
  8003b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003cc:	77 55                	ja     800423 <printnum+0x75>
  8003ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003d1:	72 05                	jb     8003d8 <printnum+0x2a>
  8003d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d6:	77 4b                	ja     800423 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003de:	8b 45 18             	mov    0x18(%ebp),%eax
  8003e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e6:	52                   	push   %edx
  8003e7:	50                   	push   %eax
  8003e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8003eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8003ee:	e8 81 1b 00 00       	call   801f74 <__udivdi3>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	83 ec 04             	sub    $0x4,%esp
  8003f9:	ff 75 20             	pushl  0x20(%ebp)
  8003fc:	53                   	push   %ebx
  8003fd:	ff 75 18             	pushl  0x18(%ebp)
  800400:	52                   	push   %edx
  800401:	50                   	push   %eax
  800402:	ff 75 0c             	pushl  0xc(%ebp)
  800405:	ff 75 08             	pushl  0x8(%ebp)
  800408:	e8 a1 ff ff ff       	call   8003ae <printnum>
  80040d:	83 c4 20             	add    $0x20,%esp
  800410:	eb 1a                	jmp    80042c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800412:	83 ec 08             	sub    $0x8,%esp
  800415:	ff 75 0c             	pushl  0xc(%ebp)
  800418:	ff 75 20             	pushl  0x20(%ebp)
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	ff d0                	call   *%eax
  800420:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800423:	ff 4d 1c             	decl   0x1c(%ebp)
  800426:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80042a:	7f e6                	jg     800412 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80042f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800437:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80043a:	53                   	push   %ebx
  80043b:	51                   	push   %ecx
  80043c:	52                   	push   %edx
  80043d:	50                   	push   %eax
  80043e:	e8 41 1c 00 00       	call   802084 <__umoddi3>
  800443:	83 c4 10             	add    $0x10,%esp
  800446:	05 d4 24 80 00       	add    $0x8024d4,%eax
  80044b:	8a 00                	mov    (%eax),%al
  80044d:	0f be c0             	movsbl %al,%eax
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	ff 75 0c             	pushl  0xc(%ebp)
  800456:	50                   	push   %eax
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	ff d0                	call   *%eax
  80045c:	83 c4 10             	add    $0x10,%esp
}
  80045f:	90                   	nop
  800460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800463:	c9                   	leave  
  800464:	c3                   	ret    

00800465 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800468:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80046c:	7e 1c                	jle    80048a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	8d 50 08             	lea    0x8(%eax),%edx
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	89 10                	mov    %edx,(%eax)
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	83 e8 08             	sub    $0x8,%eax
  800483:	8b 50 04             	mov    0x4(%eax),%edx
  800486:	8b 00                	mov    (%eax),%eax
  800488:	eb 40                	jmp    8004ca <getuint+0x65>
	else if (lflag)
  80048a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80048e:	74 1e                	je     8004ae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	8d 50 04             	lea    0x4(%eax),%edx
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	89 10                	mov    %edx,(%eax)
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	83 e8 04             	sub    $0x4,%eax
  8004a5:	8b 00                	mov    (%eax),%eax
  8004a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ac:	eb 1c                	jmp    8004ca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	8d 50 04             	lea    0x4(%eax),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	89 10                	mov    %edx,(%eax)
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	83 e8 04             	sub    $0x4,%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004ca:	5d                   	pop    %ebp
  8004cb:	c3                   	ret    

008004cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004d3:	7e 1c                	jle    8004f1 <getint+0x25>
		return va_arg(*ap, long long);
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	8d 50 08             	lea    0x8(%eax),%edx
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	89 10                	mov    %edx,(%eax)
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	83 e8 08             	sub    $0x8,%eax
  8004ea:	8b 50 04             	mov    0x4(%eax),%edx
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	eb 38                	jmp    800529 <getint+0x5d>
	else if (lflag)
  8004f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f5:	74 1a                	je     800511 <getint+0x45>
		return va_arg(*ap, long);
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 50 04             	lea    0x4(%eax),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	89 10                	mov    %edx,(%eax)
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	83 e8 04             	sub    $0x4,%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	99                   	cltd   
  80050f:	eb 18                	jmp    800529 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800511:	8b 45 08             	mov    0x8(%ebp),%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	8d 50 04             	lea    0x4(%eax),%edx
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	89 10                	mov    %edx,(%eax)
  80051e:	8b 45 08             	mov    0x8(%ebp),%eax
  800521:	8b 00                	mov    (%eax),%eax
  800523:	83 e8 04             	sub    $0x4,%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	99                   	cltd   
}
  800529:	5d                   	pop    %ebp
  80052a:	c3                   	ret    

0080052b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	56                   	push   %esi
  80052f:	53                   	push   %ebx
  800530:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800533:	eb 17                	jmp    80054c <vprintfmt+0x21>
			if (ch == '\0')
  800535:	85 db                	test   %ebx,%ebx
  800537:	0f 84 af 03 00 00    	je     8008ec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80053d:	83 ec 08             	sub    $0x8,%esp
  800540:	ff 75 0c             	pushl  0xc(%ebp)
  800543:	53                   	push   %ebx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	ff d0                	call   *%eax
  800549:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80054c:	8b 45 10             	mov    0x10(%ebp),%eax
  80054f:	8d 50 01             	lea    0x1(%eax),%edx
  800552:	89 55 10             	mov    %edx,0x10(%ebp)
  800555:	8a 00                	mov    (%eax),%al
  800557:	0f b6 d8             	movzbl %al,%ebx
  80055a:	83 fb 25             	cmp    $0x25,%ebx
  80055d:	75 d6                	jne    800535 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80055f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800563:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80056a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800571:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800578:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057f:	8b 45 10             	mov    0x10(%ebp),%eax
  800582:	8d 50 01             	lea    0x1(%eax),%edx
  800585:	89 55 10             	mov    %edx,0x10(%ebp)
  800588:	8a 00                	mov    (%eax),%al
  80058a:	0f b6 d8             	movzbl %al,%ebx
  80058d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800590:	83 f8 55             	cmp    $0x55,%eax
  800593:	0f 87 2b 03 00 00    	ja     8008c4 <vprintfmt+0x399>
  800599:	8b 04 85 f8 24 80 00 	mov    0x8024f8(,%eax,4),%eax
  8005a0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005a2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005a6:	eb d7                	jmp    80057f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005a8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005ac:	eb d1                	jmp    80057f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b8:	89 d0                	mov    %edx,%eax
  8005ba:	c1 e0 02             	shl    $0x2,%eax
  8005bd:	01 d0                	add    %edx,%eax
  8005bf:	01 c0                	add    %eax,%eax
  8005c1:	01 d8                	add    %ebx,%eax
  8005c3:	83 e8 30             	sub    $0x30,%eax
  8005c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cc:	8a 00                	mov    (%eax),%al
  8005ce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005d1:	83 fb 2f             	cmp    $0x2f,%ebx
  8005d4:	7e 3e                	jle    800614 <vprintfmt+0xe9>
  8005d6:	83 fb 39             	cmp    $0x39,%ebx
  8005d9:	7f 39                	jg     800614 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005db:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005de:	eb d5                	jmp    8005b5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	83 c0 04             	add    $0x4,%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	83 e8 04             	sub    $0x4,%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005f4:	eb 1f                	jmp    800615 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005fa:	79 83                	jns    80057f <vprintfmt+0x54>
				width = 0;
  8005fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800603:	e9 77 ff ff ff       	jmp    80057f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800608:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80060f:	e9 6b ff ff ff       	jmp    80057f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800614:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800615:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800619:	0f 89 60 ff ff ff    	jns    80057f <vprintfmt+0x54>
				width = precision, precision = -1;
  80061f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800625:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80062c:	e9 4e ff ff ff       	jmp    80057f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800631:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800634:	e9 46 ff ff ff       	jmp    80057f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	83 c0 04             	add    $0x4,%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	83 e8 04             	sub    $0x4,%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	50                   	push   %eax
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	ff d0                	call   *%eax
  800656:	83 c4 10             	add    $0x10,%esp
			break;
  800659:	e9 89 02 00 00       	jmp    8008e7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	83 c0 04             	add    $0x4,%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	83 e8 04             	sub    $0x4,%eax
  80066d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80066f:	85 db                	test   %ebx,%ebx
  800671:	79 02                	jns    800675 <vprintfmt+0x14a>
				err = -err;
  800673:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800675:	83 fb 64             	cmp    $0x64,%ebx
  800678:	7f 0b                	jg     800685 <vprintfmt+0x15a>
  80067a:	8b 34 9d 40 23 80 00 	mov    0x802340(,%ebx,4),%esi
  800681:	85 f6                	test   %esi,%esi
  800683:	75 19                	jne    80069e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800685:	53                   	push   %ebx
  800686:	68 e5 24 80 00       	push   $0x8024e5
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	ff 75 08             	pushl  0x8(%ebp)
  800691:	e8 5e 02 00 00       	call   8008f4 <printfmt>
  800696:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800699:	e9 49 02 00 00       	jmp    8008e7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80069e:	56                   	push   %esi
  80069f:	68 ee 24 80 00       	push   $0x8024ee
  8006a4:	ff 75 0c             	pushl  0xc(%ebp)
  8006a7:	ff 75 08             	pushl  0x8(%ebp)
  8006aa:	e8 45 02 00 00       	call   8008f4 <printfmt>
  8006af:	83 c4 10             	add    $0x10,%esp
			break;
  8006b2:	e9 30 02 00 00       	jmp    8008e7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	83 c0 04             	add    $0x4,%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	83 e8 04             	sub    $0x4,%eax
  8006c6:	8b 30                	mov    (%eax),%esi
  8006c8:	85 f6                	test   %esi,%esi
  8006ca:	75 05                	jne    8006d1 <vprintfmt+0x1a6>
				p = "(null)";
  8006cc:	be f1 24 80 00       	mov    $0x8024f1,%esi
			if (width > 0 && padc != '-')
  8006d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d5:	7e 6d                	jle    800744 <vprintfmt+0x219>
  8006d7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006db:	74 67                	je     800744 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	50                   	push   %eax
  8006e4:	56                   	push   %esi
  8006e5:	e8 0c 03 00 00       	call   8009f6 <strnlen>
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006f0:	eb 16                	jmp    800708 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006f2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	50                   	push   %eax
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	ff d0                	call   *%eax
  800702:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800705:	ff 4d e4             	decl   -0x1c(%ebp)
  800708:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070c:	7f e4                	jg     8006f2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070e:	eb 34                	jmp    800744 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800710:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800714:	74 1c                	je     800732 <vprintfmt+0x207>
  800716:	83 fb 1f             	cmp    $0x1f,%ebx
  800719:	7e 05                	jle    800720 <vprintfmt+0x1f5>
  80071b:	83 fb 7e             	cmp    $0x7e,%ebx
  80071e:	7e 12                	jle    800732 <vprintfmt+0x207>
					putch('?', putdat);
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	6a 3f                	push   $0x3f
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	eb 0f                	jmp    800741 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	ff 75 0c             	pushl  0xc(%ebp)
  800738:	53                   	push   %ebx
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	ff d0                	call   *%eax
  80073e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800741:	ff 4d e4             	decl   -0x1c(%ebp)
  800744:	89 f0                	mov    %esi,%eax
  800746:	8d 70 01             	lea    0x1(%eax),%esi
  800749:	8a 00                	mov    (%eax),%al
  80074b:	0f be d8             	movsbl %al,%ebx
  80074e:	85 db                	test   %ebx,%ebx
  800750:	74 24                	je     800776 <vprintfmt+0x24b>
  800752:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800756:	78 b8                	js     800710 <vprintfmt+0x1e5>
  800758:	ff 4d e0             	decl   -0x20(%ebp)
  80075b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80075f:	79 af                	jns    800710 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800761:	eb 13                	jmp    800776 <vprintfmt+0x24b>
				putch(' ', putdat);
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	6a 20                	push   $0x20
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	ff d0                	call   *%eax
  800770:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800773:	ff 4d e4             	decl   -0x1c(%ebp)
  800776:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80077a:	7f e7                	jg     800763 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80077c:	e9 66 01 00 00       	jmp    8008e7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 e8             	pushl  -0x18(%ebp)
  800787:	8d 45 14             	lea    0x14(%ebp),%eax
  80078a:	50                   	push   %eax
  80078b:	e8 3c fd ff ff       	call   8004cc <getint>
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800796:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079f:	85 d2                	test   %edx,%edx
  8007a1:	79 23                	jns    8007c6 <vprintfmt+0x29b>
				putch('-', putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	6a 2d                	push   $0x2d
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	ff d0                	call   *%eax
  8007b0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b9:	f7 d8                	neg    %eax
  8007bb:	83 d2 00             	adc    $0x0,%edx
  8007be:	f7 da                	neg    %edx
  8007c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007c6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007cd:	e9 bc 00 00 00       	jmp    80088e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d8:	8d 45 14             	lea    0x14(%ebp),%eax
  8007db:	50                   	push   %eax
  8007dc:	e8 84 fc ff ff       	call   800465 <getuint>
  8007e1:	83 c4 10             	add    $0x10,%esp
  8007e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007ea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f1:	e9 98 00 00 00       	jmp    80088e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	ff 75 0c             	pushl  0xc(%ebp)
  8007fc:	6a 58                	push   $0x58
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	ff d0                	call   *%eax
  800803:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 0c             	pushl  0xc(%ebp)
  80080c:	6a 58                	push   $0x58
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	ff d0                	call   *%eax
  800813:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	ff 75 0c             	pushl  0xc(%ebp)
  80081c:	6a 58                	push   $0x58
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	ff d0                	call   *%eax
  800823:	83 c4 10             	add    $0x10,%esp
			break;
  800826:	e9 bc 00 00 00       	jmp    8008e7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	6a 30                	push   $0x30
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	6a 78                	push   $0x78
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 c0 04             	add    $0x4,%eax
  800851:	89 45 14             	mov    %eax,0x14(%ebp)
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	83 e8 04             	sub    $0x4,%eax
  80085a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80085c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800866:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80086d:	eb 1f                	jmp    80088e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 e8             	pushl  -0x18(%ebp)
  800875:	8d 45 14             	lea    0x14(%ebp),%eax
  800878:	50                   	push   %eax
  800879:	e8 e7 fb ff ff       	call   800465 <getuint>
  80087e:	83 c4 10             	add    $0x10,%esp
  800881:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800884:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800887:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80088e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800892:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800895:	83 ec 04             	sub    $0x4,%esp
  800898:	52                   	push   %edx
  800899:	ff 75 e4             	pushl  -0x1c(%ebp)
  80089c:	50                   	push   %eax
  80089d:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	ff 75 08             	pushl  0x8(%ebp)
  8008a9:	e8 00 fb ff ff       	call   8003ae <printnum>
  8008ae:	83 c4 20             	add    $0x20,%esp
			break;
  8008b1:	eb 34                	jmp    8008e7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	ff 75 0c             	pushl  0xc(%ebp)
  8008b9:	53                   	push   %ebx
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	ff d0                	call   *%eax
  8008bf:	83 c4 10             	add    $0x10,%esp
			break;
  8008c2:	eb 23                	jmp    8008e7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008c4:	83 ec 08             	sub    $0x8,%esp
  8008c7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ca:	6a 25                	push   $0x25
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	ff d0                	call   *%eax
  8008d1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d4:	ff 4d 10             	decl   0x10(%ebp)
  8008d7:	eb 03                	jmp    8008dc <vprintfmt+0x3b1>
  8008d9:	ff 4d 10             	decl   0x10(%ebp)
  8008dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008df:	48                   	dec    %eax
  8008e0:	8a 00                	mov    (%eax),%al
  8008e2:	3c 25                	cmp    $0x25,%al
  8008e4:	75 f3                	jne    8008d9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008e6:	90                   	nop
		}
	}
  8008e7:	e9 47 fc ff ff       	jmp    800533 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008ec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f0:	5b                   	pop    %ebx
  8008f1:	5e                   	pop    %esi
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fd:	83 c0 04             	add    $0x4,%eax
  800900:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800903:	8b 45 10             	mov    0x10(%ebp),%eax
  800906:	ff 75 f4             	pushl  -0xc(%ebp)
  800909:	50                   	push   %eax
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	e8 16 fc ff ff       	call   80052b <vprintfmt>
  800915:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800918:	90                   	nop
  800919:	c9                   	leave  
  80091a:	c3                   	ret    

0080091b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800921:	8b 40 08             	mov    0x8(%eax),%eax
  800924:	8d 50 01             	lea    0x1(%eax),%edx
  800927:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80092d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800930:	8b 10                	mov    (%eax),%edx
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
  800935:	8b 40 04             	mov    0x4(%eax),%eax
  800938:	39 c2                	cmp    %eax,%edx
  80093a:	73 12                	jae    80094e <sprintputch+0x33>
		*b->buf++ = ch;
  80093c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	8d 48 01             	lea    0x1(%eax),%ecx
  800944:	8b 55 0c             	mov    0xc(%ebp),%edx
  800947:	89 0a                	mov    %ecx,(%edx)
  800949:	8b 55 08             	mov    0x8(%ebp),%edx
  80094c:	88 10                	mov    %dl,(%eax)
}
  80094e:	90                   	nop
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8d 50 ff             	lea    -0x1(%eax),%edx
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	01 d0                	add    %edx,%eax
  800968:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800972:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800976:	74 06                	je     80097e <vsnprintf+0x2d>
  800978:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80097c:	7f 07                	jg     800985 <vsnprintf+0x34>
		return -E_INVAL;
  80097e:	b8 03 00 00 00       	mov    $0x3,%eax
  800983:	eb 20                	jmp    8009a5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800985:	ff 75 14             	pushl  0x14(%ebp)
  800988:	ff 75 10             	pushl  0x10(%ebp)
  80098b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80098e:	50                   	push   %eax
  80098f:	68 1b 09 80 00       	push   $0x80091b
  800994:	e8 92 fb ff ff       	call   80052b <vprintfmt>
  800999:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80099c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009a5:	c9                   	leave  
  8009a6:	c3                   	ret    

008009a7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8009b0:	83 c0 04             	add    $0x4,%eax
  8009b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009bc:	50                   	push   %eax
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	ff 75 08             	pushl  0x8(%ebp)
  8009c3:	e8 89 ff ff ff       	call   800951 <vsnprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp
  8009cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009d1:	c9                   	leave  
  8009d2:	c3                   	ret    

008009d3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009e0:	eb 06                	jmp    8009e8 <strlen+0x15>
		n++;
  8009e2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e5:	ff 45 08             	incl   0x8(%ebp)
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8a 00                	mov    (%eax),%al
  8009ed:	84 c0                	test   %al,%al
  8009ef:	75 f1                	jne    8009e2 <strlen+0xf>
		n++;
	return n;
  8009f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    

008009f6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a03:	eb 09                	jmp    800a0e <strnlen+0x18>
		n++;
  800a05:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a08:	ff 45 08             	incl   0x8(%ebp)
  800a0b:	ff 4d 0c             	decl   0xc(%ebp)
  800a0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a12:	74 09                	je     800a1d <strnlen+0x27>
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	8a 00                	mov    (%eax),%al
  800a19:	84 c0                	test   %al,%al
  800a1b:	75 e8                	jne    800a05 <strnlen+0xf>
		n++;
	return n;
  800a1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a20:	c9                   	leave  
  800a21:	c3                   	ret    

00800a22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a2e:	90                   	nop
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	8d 50 01             	lea    0x1(%eax),%edx
  800a35:	89 55 08             	mov    %edx,0x8(%ebp)
  800a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a3e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a41:	8a 12                	mov    (%edx),%dl
  800a43:	88 10                	mov    %dl,(%eax)
  800a45:	8a 00                	mov    (%eax),%al
  800a47:	84 c0                	test   %al,%al
  800a49:	75 e4                	jne    800a2f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4e:	c9                   	leave  
  800a4f:	c3                   	ret    

00800a50 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a63:	eb 1f                	jmp    800a84 <strncpy+0x34>
		*dst++ = *src;
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	8d 50 01             	lea    0x1(%eax),%edx
  800a6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800a6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a71:	8a 12                	mov    (%edx),%dl
  800a73:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a78:	8a 00                	mov    (%eax),%al
  800a7a:	84 c0                	test   %al,%al
  800a7c:	74 03                	je     800a81 <strncpy+0x31>
			src++;
  800a7e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a81:	ff 45 fc             	incl   -0x4(%ebp)
  800a84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a87:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a8a:	72 d9                	jb     800a65 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa1:	74 30                	je     800ad3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aa3:	eb 16                	jmp    800abb <strlcpy+0x2a>
			*dst++ = *src++;
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8d 50 01             	lea    0x1(%eax),%edx
  800aab:	89 55 08             	mov    %edx,0x8(%ebp)
  800aae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ab4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ab7:	8a 12                	mov    (%edx),%dl
  800ab9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800abb:	ff 4d 10             	decl   0x10(%ebp)
  800abe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac2:	74 09                	je     800acd <strlcpy+0x3c>
  800ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac7:	8a 00                	mov    (%eax),%al
  800ac9:	84 c0                	test   %al,%al
  800acb:	75 d8                	jne    800aa5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad9:	29 c2                	sub    %eax,%edx
  800adb:	89 d0                	mov    %edx,%eax
}
  800add:	c9                   	leave  
  800ade:	c3                   	ret    

00800adf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ae2:	eb 06                	jmp    800aea <strcmp+0xb>
		p++, q++;
  800ae4:	ff 45 08             	incl   0x8(%ebp)
  800ae7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8a 00                	mov    (%eax),%al
  800aef:	84 c0                	test   %al,%al
  800af1:	74 0e                	je     800b01 <strcmp+0x22>
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	8a 10                	mov    (%eax),%dl
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	8a 00                	mov    (%eax),%al
  800afd:	38 c2                	cmp    %al,%dl
  800aff:	74 e3                	je     800ae4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	8a 00                	mov    (%eax),%al
  800b06:	0f b6 d0             	movzbl %al,%edx
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	8a 00                	mov    (%eax),%al
  800b0e:	0f b6 c0             	movzbl %al,%eax
  800b11:	29 c2                	sub    %eax,%edx
  800b13:	89 d0                	mov    %edx,%eax
}
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b1a:	eb 09                	jmp    800b25 <strncmp+0xe>
		n--, p++, q++;
  800b1c:	ff 4d 10             	decl   0x10(%ebp)
  800b1f:	ff 45 08             	incl   0x8(%ebp)
  800b22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b29:	74 17                	je     800b42 <strncmp+0x2b>
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	84 c0                	test   %al,%al
  800b32:	74 0e                	je     800b42 <strncmp+0x2b>
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8a 10                	mov    (%eax),%dl
  800b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3c:	8a 00                	mov    (%eax),%al
  800b3e:	38 c2                	cmp    %al,%dl
  800b40:	74 da                	je     800b1c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b46:	75 07                	jne    800b4f <strncmp+0x38>
		return 0;
  800b48:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4d:	eb 14                	jmp    800b63 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	8a 00                	mov    (%eax),%al
  800b54:	0f b6 d0             	movzbl %al,%edx
  800b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5a:	8a 00                	mov    (%eax),%al
  800b5c:	0f b6 c0             	movzbl %al,%eax
  800b5f:	29 c2                	sub    %eax,%edx
  800b61:	89 d0                	mov    %edx,%eax
}
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 04             	sub    $0x4,%esp
  800b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b71:	eb 12                	jmp    800b85 <strchr+0x20>
		if (*s == c)
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8a 00                	mov    (%eax),%al
  800b78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b7b:	75 05                	jne    800b82 <strchr+0x1d>
			return (char *) s;
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	eb 11                	jmp    800b93 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b82:	ff 45 08             	incl   0x8(%ebp)
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8a 00                	mov    (%eax),%al
  800b8a:	84 c0                	test   %al,%al
  800b8c:	75 e5                	jne    800b73 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b93:	c9                   	leave  
  800b94:	c3                   	ret    

00800b95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	83 ec 04             	sub    $0x4,%esp
  800b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ba1:	eb 0d                	jmp    800bb0 <strfind+0x1b>
		if (*s == c)
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	8a 00                	mov    (%eax),%al
  800ba8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bab:	74 0e                	je     800bbb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bad:	ff 45 08             	incl   0x8(%ebp)
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8a 00                	mov    (%eax),%al
  800bb5:	84 c0                	test   %al,%al
  800bb7:	75 ea                	jne    800ba3 <strfind+0xe>
  800bb9:	eb 01                	jmp    800bbc <strfind+0x27>
		if (*s == c)
			break;
  800bbb:	90                   	nop
	return (char *) s;
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bbf:	c9                   	leave  
  800bc0:	c3                   	ret    

00800bc1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bd3:	eb 0e                	jmp    800be3 <memset+0x22>
		*p++ = c;
  800bd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd8:	8d 50 01             	lea    0x1(%eax),%edx
  800bdb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bde:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800be3:	ff 4d f8             	decl   -0x8(%ebp)
  800be6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bea:	79 e9                	jns    800bd5 <memset+0x14>
		*p++ = c;

	return v;
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c03:	eb 16                	jmp    800c1b <memcpy+0x2a>
		*d++ = *s++;
  800c05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c08:	8d 50 01             	lea    0x1(%eax),%edx
  800c0b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c14:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c17:	8a 12                	mov    (%edx),%dl
  800c19:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c21:	89 55 10             	mov    %edx,0x10(%ebp)
  800c24:	85 c0                	test   %eax,%eax
  800c26:	75 dd                	jne    800c05 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c2b:	c9                   	leave  
  800c2c:	c3                   	ret    

00800c2d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c45:	73 50                	jae    800c97 <memmove+0x6a>
  800c47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	01 d0                	add    %edx,%eax
  800c4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c52:	76 43                	jbe    800c97 <memmove+0x6a>
		s += n;
  800c54:	8b 45 10             	mov    0x10(%ebp),%eax
  800c57:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c60:	eb 10                	jmp    800c72 <memmove+0x45>
			*--d = *--s;
  800c62:	ff 4d f8             	decl   -0x8(%ebp)
  800c65:	ff 4d fc             	decl   -0x4(%ebp)
  800c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6b:	8a 10                	mov    (%eax),%dl
  800c6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c70:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c72:	8b 45 10             	mov    0x10(%ebp),%eax
  800c75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c78:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7b:	85 c0                	test   %eax,%eax
  800c7d:	75 e3                	jne    800c62 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c7f:	eb 23                	jmp    800ca4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c84:	8d 50 01             	lea    0x1(%eax),%edx
  800c87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c93:	8a 12                	mov    (%edx),%dl
  800c95:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c97:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca0:	85 c0                	test   %eax,%eax
  800ca2:	75 dd                	jne    800c81 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ca7:	c9                   	leave  
  800ca8:	c3                   	ret    

00800ca9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cbb:	eb 2a                	jmp    800ce7 <memcmp+0x3e>
		if (*s1 != *s2)
  800cbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc0:	8a 10                	mov    (%eax),%dl
  800cc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	38 c2                	cmp    %al,%dl
  800cc9:	74 16                	je     800ce1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ccb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	0f b6 d0             	movzbl %al,%edx
  800cd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd6:	8a 00                	mov    (%eax),%al
  800cd8:	0f b6 c0             	movzbl %al,%eax
  800cdb:	29 c2                	sub    %eax,%edx
  800cdd:	89 d0                	mov    %edx,%eax
  800cdf:	eb 18                	jmp    800cf9 <memcmp+0x50>
		s1++, s2++;
  800ce1:	ff 45 fc             	incl   -0x4(%ebp)
  800ce4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ce7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ced:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf0:	85 c0                	test   %eax,%eax
  800cf2:	75 c9                	jne    800cbd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf9:	c9                   	leave  
  800cfa:	c3                   	ret    

00800cfb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d01:	8b 55 08             	mov    0x8(%ebp),%edx
  800d04:	8b 45 10             	mov    0x10(%ebp),%eax
  800d07:	01 d0                	add    %edx,%eax
  800d09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d0c:	eb 15                	jmp    800d23 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	0f b6 d0             	movzbl %al,%edx
  800d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d19:	0f b6 c0             	movzbl %al,%eax
  800d1c:	39 c2                	cmp    %eax,%edx
  800d1e:	74 0d                	je     800d2d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d20:	ff 45 08             	incl   0x8(%ebp)
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d29:	72 e3                	jb     800d0e <memfind+0x13>
  800d2b:	eb 01                	jmp    800d2e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d2d:	90                   	nop
	return (void *) s;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d31:	c9                   	leave  
  800d32:	c3                   	ret    

00800d33 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d40:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d47:	eb 03                	jmp    800d4c <strtol+0x19>
		s++;
  800d49:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	3c 20                	cmp    $0x20,%al
  800d53:	74 f4                	je     800d49 <strtol+0x16>
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3c 09                	cmp    $0x9,%al
  800d5c:	74 eb                	je     800d49 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	3c 2b                	cmp    $0x2b,%al
  800d65:	75 05                	jne    800d6c <strtol+0x39>
		s++;
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	eb 13                	jmp    800d7f <strtol+0x4c>
	else if (*s == '-')
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	3c 2d                	cmp    $0x2d,%al
  800d73:	75 0a                	jne    800d7f <strtol+0x4c>
		s++, neg = 1;
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d83:	74 06                	je     800d8b <strtol+0x58>
  800d85:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d89:	75 20                	jne    800dab <strtol+0x78>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	3c 30                	cmp    $0x30,%al
  800d92:	75 17                	jne    800dab <strtol+0x78>
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	40                   	inc    %eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	3c 78                	cmp    $0x78,%al
  800d9c:	75 0d                	jne    800dab <strtol+0x78>
		s += 2, base = 16;
  800d9e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800da2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800da9:	eb 28                	jmp    800dd3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800daf:	75 15                	jne    800dc6 <strtol+0x93>
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	3c 30                	cmp    $0x30,%al
  800db8:	75 0c                	jne    800dc6 <strtol+0x93>
		s++, base = 8;
  800dba:	ff 45 08             	incl   0x8(%ebp)
  800dbd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dc4:	eb 0d                	jmp    800dd3 <strtol+0xa0>
	else if (base == 0)
  800dc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dca:	75 07                	jne    800dd3 <strtol+0xa0>
		base = 10;
  800dcc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	3c 2f                	cmp    $0x2f,%al
  800dda:	7e 19                	jle    800df5 <strtol+0xc2>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	3c 39                	cmp    $0x39,%al
  800de3:	7f 10                	jg     800df5 <strtol+0xc2>
			dig = *s - '0';
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f be c0             	movsbl %al,%eax
  800ded:	83 e8 30             	sub    $0x30,%eax
  800df0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800df3:	eb 42                	jmp    800e37 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	3c 60                	cmp    $0x60,%al
  800dfc:	7e 19                	jle    800e17 <strtol+0xe4>
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	3c 7a                	cmp    $0x7a,%al
  800e05:	7f 10                	jg     800e17 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	0f be c0             	movsbl %al,%eax
  800e0f:	83 e8 57             	sub    $0x57,%eax
  800e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e15:	eb 20                	jmp    800e37 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	3c 40                	cmp    $0x40,%al
  800e1e:	7e 39                	jle    800e59 <strtol+0x126>
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	3c 5a                	cmp    $0x5a,%al
  800e27:	7f 30                	jg     800e59 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	0f be c0             	movsbl %al,%eax
  800e31:	83 e8 37             	sub    $0x37,%eax
  800e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e3a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e3d:	7d 19                	jge    800e58 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e3f:	ff 45 08             	incl   0x8(%ebp)
  800e42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e45:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e49:	89 c2                	mov    %eax,%edx
  800e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4e:	01 d0                	add    %edx,%eax
  800e50:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e53:	e9 7b ff ff ff       	jmp    800dd3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e58:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e5d:	74 08                	je     800e67 <strtol+0x134>
		*endptr = (char *) s;
  800e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e62:	8b 55 08             	mov    0x8(%ebp),%edx
  800e65:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e67:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e6b:	74 07                	je     800e74 <strtol+0x141>
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	f7 d8                	neg    %eax
  800e72:	eb 03                	jmp    800e77 <strtol+0x144>
  800e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <ltostr>:

void
ltostr(long value, char *str)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e86:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e91:	79 13                	jns    800ea6 <ltostr+0x2d>
	{
		neg = 1;
  800e93:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ea0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ea3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800eae:	99                   	cltd   
  800eaf:	f7 f9                	idiv   %ecx
  800eb1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800eb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb7:	8d 50 01             	lea    0x1(%eax),%edx
  800eba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebd:	89 c2                	mov    %eax,%edx
  800ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec2:	01 d0                	add    %edx,%eax
  800ec4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ec7:	83 c2 30             	add    $0x30,%edx
  800eca:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ecc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ecf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ed4:	f7 e9                	imul   %ecx
  800ed6:	c1 fa 02             	sar    $0x2,%edx
  800ed9:	89 c8                	mov    %ecx,%eax
  800edb:	c1 f8 1f             	sar    $0x1f,%eax
  800ede:	29 c2                	sub    %eax,%edx
  800ee0:	89 d0                	mov    %edx,%eax
  800ee2:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800ee5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ee8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800eed:	f7 e9                	imul   %ecx
  800eef:	c1 fa 02             	sar    $0x2,%edx
  800ef2:	89 c8                	mov    %ecx,%eax
  800ef4:	c1 f8 1f             	sar    $0x1f,%eax
  800ef7:	29 c2                	sub    %eax,%edx
  800ef9:	89 d0                	mov    %edx,%eax
  800efb:	c1 e0 02             	shl    $0x2,%eax
  800efe:	01 d0                	add    %edx,%eax
  800f00:	01 c0                	add    %eax,%eax
  800f02:	29 c1                	sub    %eax,%ecx
  800f04:	89 ca                	mov    %ecx,%edx
  800f06:	85 d2                	test   %edx,%edx
  800f08:	75 9c                	jne    800ea6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f14:	48                   	dec    %eax
  800f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f18:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f1c:	74 3d                	je     800f5b <ltostr+0xe2>
		start = 1 ;
  800f1e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f25:	eb 34                	jmp    800f5b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2d:	01 d0                	add    %edx,%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3a:	01 c2                	add    %eax,%edx
  800f3c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f42:	01 c8                	add    %ecx,%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	01 c2                	add    %eax,%edx
  800f50:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f53:	88 02                	mov    %al,(%edx)
		start++ ;
  800f55:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f58:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f61:	7c c4                	jl     800f27 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f63:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	01 d0                	add    %edx,%eax
  800f6b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f6e:	90                   	nop
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f77:	ff 75 08             	pushl  0x8(%ebp)
  800f7a:	e8 54 fa ff ff       	call   8009d3 <strlen>
  800f7f:	83 c4 04             	add    $0x4,%esp
  800f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f85:	ff 75 0c             	pushl  0xc(%ebp)
  800f88:	e8 46 fa ff ff       	call   8009d3 <strlen>
  800f8d:	83 c4 04             	add    $0x4,%esp
  800f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fa1:	eb 17                	jmp    800fba <strcconcat+0x49>
		final[s] = str1[s] ;
  800fa3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa9:	01 c2                	add    %eax,%edx
  800fab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	01 c8                	add    %ecx,%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fb7:	ff 45 fc             	incl   -0x4(%ebp)
  800fba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fc0:	7c e1                	jl     800fa3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fc2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fc9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fd0:	eb 1f                	jmp    800ff1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd5:	8d 50 01             	lea    0x1(%eax),%edx
  800fd8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fdb:	89 c2                	mov    %eax,%edx
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	01 c2                	add    %eax,%edx
  800fe2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	01 c8                	add    %ecx,%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fee:	ff 45 f8             	incl   -0x8(%ebp)
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ff7:	7c d9                	jl     800fd2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800ff9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fff:	01 d0                	add    %edx,%eax
  801001:	c6 00 00             	movb   $0x0,(%eax)
}
  801004:	90                   	nop
  801005:	c9                   	leave  
  801006:	c3                   	ret    

00801007 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80100a:	8b 45 14             	mov    0x14(%ebp),%eax
  80100d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801013:	8b 45 14             	mov    0x14(%ebp),%eax
  801016:	8b 00                	mov    (%eax),%eax
  801018:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80101f:	8b 45 10             	mov    0x10(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80102a:	eb 0c                	jmp    801038 <strsplit+0x31>
			*string++ = 0;
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8d 50 01             	lea    0x1(%eax),%edx
  801032:	89 55 08             	mov    %edx,0x8(%ebp)
  801035:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	84 c0                	test   %al,%al
  80103f:	74 18                	je     801059 <strsplit+0x52>
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	0f be c0             	movsbl %al,%eax
  801049:	50                   	push   %eax
  80104a:	ff 75 0c             	pushl  0xc(%ebp)
  80104d:	e8 13 fb ff ff       	call   800b65 <strchr>
  801052:	83 c4 08             	add    $0x8,%esp
  801055:	85 c0                	test   %eax,%eax
  801057:	75 d3                	jne    80102c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	84 c0                	test   %al,%al
  801060:	74 5a                	je     8010bc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801062:	8b 45 14             	mov    0x14(%ebp),%eax
  801065:	8b 00                	mov    (%eax),%eax
  801067:	83 f8 0f             	cmp    $0xf,%eax
  80106a:	75 07                	jne    801073 <strsplit+0x6c>
		{
			return 0;
  80106c:	b8 00 00 00 00       	mov    $0x0,%eax
  801071:	eb 66                	jmp    8010d9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801073:	8b 45 14             	mov    0x14(%ebp),%eax
  801076:	8b 00                	mov    (%eax),%eax
  801078:	8d 48 01             	lea    0x1(%eax),%ecx
  80107b:	8b 55 14             	mov    0x14(%ebp),%edx
  80107e:	89 0a                	mov    %ecx,(%edx)
  801080:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
  80108a:	01 c2                	add    %eax,%edx
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801091:	eb 03                	jmp    801096 <strsplit+0x8f>
			string++;
  801093:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	84 c0                	test   %al,%al
  80109d:	74 8b                	je     80102a <strsplit+0x23>
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	0f be c0             	movsbl %al,%eax
  8010a7:	50                   	push   %eax
  8010a8:	ff 75 0c             	pushl  0xc(%ebp)
  8010ab:	e8 b5 fa ff ff       	call   800b65 <strchr>
  8010b0:	83 c4 08             	add    $0x8,%esp
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	74 dc                	je     801093 <strsplit+0x8c>
			string++;
	}
  8010b7:	e9 6e ff ff ff       	jmp    80102a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010bc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c0:	8b 00                	mov    (%eax),%eax
  8010c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cc:	01 d0                	add    %edx,%eax
  8010ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    

008010db <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8010e1:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8010e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010eb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8010ee:	01 d0                	add    %edx,%eax
  8010f0:	48                   	dec    %eax
  8010f1:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8010f4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8010f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010fc:	f7 75 ac             	divl   -0x54(%ebp)
  8010ff:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801102:	29 d0                	sub    %edx,%eax
  801104:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801107:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  80110e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801115:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  80111c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801123:	eb 3f                	jmp    801164 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801125:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801128:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80112f:	83 ec 04             	sub    $0x4,%esp
  801132:	50                   	push   %eax
  801133:	ff 75 e8             	pushl  -0x18(%ebp)
  801136:	68 50 26 80 00       	push   $0x802650
  80113b:	e8 11 f2 ff ff       	call   800351 <cprintf>
  801140:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801143:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801146:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  80114d:	83 ec 04             	sub    $0x4,%esp
  801150:	50                   	push   %eax
  801151:	ff 75 e8             	pushl  -0x18(%ebp)
  801154:	68 65 26 80 00       	push   $0x802665
  801159:	e8 f3 f1 ff ff       	call   800351 <cprintf>
  80115e:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801161:	ff 45 e8             	incl   -0x18(%ebp)
  801164:	a1 28 30 80 00       	mov    0x803028,%eax
  801169:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80116c:	7c b7                	jl     801125 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  80116e:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801175:	e9 42 01 00 00       	jmp    8012bc <malloc+0x1e1>
		int flag0=1;
  80117a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801181:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801184:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801187:	eb 6b                	jmp    8011f4 <malloc+0x119>
			for(int k=0;k<count;k++){
  801189:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801190:	eb 42                	jmp    8011d4 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801192:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801195:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80119c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80119f:	39 c2                	cmp    %eax,%edx
  8011a1:	77 2e                	ja     8011d1 <malloc+0xf6>
  8011a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011a6:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8011ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011b0:	39 c2                	cmp    %eax,%edx
  8011b2:	76 1d                	jbe    8011d1 <malloc+0xf6>
					ni=arr_add[k].end-i;
  8011b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011b7:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8011be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011c1:	29 c2                	sub    %eax,%edx
  8011c3:	89 d0                	mov    %edx,%eax
  8011c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  8011c8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8011cf:	eb 0d                	jmp    8011de <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8011d1:	ff 45 d8             	incl   -0x28(%ebp)
  8011d4:	a1 28 30 80 00       	mov    0x803028,%eax
  8011d9:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8011dc:	7c b4                	jl     801192 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8011de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011e2:	74 09                	je     8011ed <malloc+0x112>
				flag0=0;
  8011e4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8011eb:	eb 16                	jmp    801203 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8011ed:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8011f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	01 c2                	add    %eax,%edx
  8011fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011ff:	39 c2                	cmp    %eax,%edx
  801201:	77 86                	ja     801189 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801203:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801207:	0f 84 a2 00 00 00    	je     8012af <malloc+0x1d4>

			int f=1;
  80120d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801214:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801217:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80121a:	89 c8                	mov    %ecx,%eax
  80121c:	01 c0                	add    %eax,%eax
  80121e:	01 c8                	add    %ecx,%eax
  801220:	c1 e0 02             	shl    $0x2,%eax
  801223:	05 20 31 80 00       	add    $0x803120,%eax
  801228:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  80122a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801233:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801236:	89 d0                	mov    %edx,%eax
  801238:	01 c0                	add    %eax,%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	c1 e0 02             	shl    $0x2,%eax
  80123f:	05 24 31 80 00       	add    $0x803124,%eax
  801244:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801246:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801249:	89 d0                	mov    %edx,%eax
  80124b:	01 c0                	add    %eax,%eax
  80124d:	01 d0                	add    %edx,%eax
  80124f:	c1 e0 02             	shl    $0x2,%eax
  801252:	05 28 31 80 00       	add    $0x803128,%eax
  801257:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  80125d:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801260:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801267:	eb 36                	jmp    80129f <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801269:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	01 c2                	add    %eax,%edx
  801271:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801274:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80127b:	39 c2                	cmp    %eax,%edx
  80127d:	73 1d                	jae    80129c <malloc+0x1c1>
					ni=arr_add[l].end-i;
  80127f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801282:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801289:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80128c:	29 c2                	sub    %eax,%edx
  80128e:	89 d0                	mov    %edx,%eax
  801290:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801293:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  80129a:	eb 0d                	jmp    8012a9 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  80129c:	ff 45 d0             	incl   -0x30(%ebp)
  80129f:	a1 28 30 80 00       	mov    0x803028,%eax
  8012a4:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8012a7:	7c c0                	jl     801269 <malloc+0x18e>
					break;

				}
			}

			if(f){
  8012a9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8012ad:	75 1d                	jne    8012cc <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  8012af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8012b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012b9:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8012bc:	a1 04 30 80 00       	mov    0x803004,%eax
  8012c1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8012c4:	0f 8c b0 fe ff ff    	jl     80117a <malloc+0x9f>
  8012ca:	eb 01                	jmp    8012cd <malloc+0x1f2>

				}
			}

			if(f){
				break;
  8012cc:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8012cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012d1:	75 7a                	jne    80134d <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  8012d3:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	01 d0                	add    %edx,%eax
  8012de:	48                   	dec    %eax
  8012df:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8012e4:	7c 0a                	jl     8012f0 <malloc+0x215>
			return NULL;
  8012e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012eb:	e9 a4 02 00 00       	jmp    801594 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  8012f0:	a1 04 30 80 00       	mov    0x803004,%eax
  8012f5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8012f8:	a1 28 30 80 00       	mov    0x803028,%eax
  8012fd:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801300:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  801307:	83 ec 08             	sub    $0x8,%esp
  80130a:	ff 75 08             	pushl  0x8(%ebp)
  80130d:	ff 75 a4             	pushl  -0x5c(%ebp)
  801310:	e8 04 06 00 00       	call   801919 <sys_allocateMem>
  801315:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801318:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	01 d0                	add    %edx,%eax
  801323:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  801328:	a1 28 30 80 00       	mov    0x803028,%eax
  80132d:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801333:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  80133a:	a1 28 30 80 00       	mov    0x803028,%eax
  80133f:	40                   	inc    %eax
  801340:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  801345:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801348:	e9 47 02 00 00       	jmp    801594 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  80134d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801354:	e9 ac 00 00 00       	jmp    801405 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801359:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80135c:	89 d0                	mov    %edx,%eax
  80135e:	01 c0                	add    %eax,%eax
  801360:	01 d0                	add    %edx,%eax
  801362:	c1 e0 02             	shl    $0x2,%eax
  801365:	05 24 31 80 00       	add    $0x803124,%eax
  80136a:	8b 00                	mov    (%eax),%eax
  80136c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80136f:	eb 7e                	jmp    8013ef <malloc+0x314>
			int flag=0;
  801371:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801378:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  80137f:	eb 57                	jmp    8013d8 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801381:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801384:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80138b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80138e:	39 c2                	cmp    %eax,%edx
  801390:	77 1a                	ja     8013ac <malloc+0x2d1>
  801392:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801395:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80139c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80139f:	39 c2                	cmp    %eax,%edx
  8013a1:	76 09                	jbe    8013ac <malloc+0x2d1>
								flag=1;
  8013a3:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  8013aa:	eb 36                	jmp    8013e2 <malloc+0x307>
			arr[i].space++;
  8013ac:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8013af:	89 d0                	mov    %edx,%eax
  8013b1:	01 c0                	add    %eax,%eax
  8013b3:	01 d0                	add    %edx,%eax
  8013b5:	c1 e0 02             	shl    $0x2,%eax
  8013b8:	05 28 31 80 00       	add    $0x803128,%eax
  8013bd:	8b 00                	mov    (%eax),%eax
  8013bf:	8d 48 01             	lea    0x1(%eax),%ecx
  8013c2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8013c5:	89 d0                	mov    %edx,%eax
  8013c7:	01 c0                	add    %eax,%eax
  8013c9:	01 d0                	add    %edx,%eax
  8013cb:	c1 e0 02             	shl    $0x2,%eax
  8013ce:	05 28 31 80 00       	add    $0x803128,%eax
  8013d3:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  8013d5:	ff 45 c0             	incl   -0x40(%ebp)
  8013d8:	a1 28 30 80 00       	mov    0x803028,%eax
  8013dd:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  8013e0:	7c 9f                	jl     801381 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  8013e2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8013e6:	75 19                	jne    801401 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8013e8:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8013ef:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8013f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8013f7:	39 c2                	cmp    %eax,%edx
  8013f9:	0f 82 72 ff ff ff    	jb     801371 <malloc+0x296>
  8013ff:	eb 01                	jmp    801402 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801401:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801402:	ff 45 cc             	incl   -0x34(%ebp)
  801405:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801408:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80140b:	0f 8c 48 ff ff ff    	jl     801359 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801411:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801418:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  80141f:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801426:	eb 37                	jmp    80145f <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801428:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80142b:	89 d0                	mov    %edx,%eax
  80142d:	01 c0                	add    %eax,%eax
  80142f:	01 d0                	add    %edx,%eax
  801431:	c1 e0 02             	shl    $0x2,%eax
  801434:	05 28 31 80 00       	add    $0x803128,%eax
  801439:	8b 00                	mov    (%eax),%eax
  80143b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80143e:	7d 1c                	jge    80145c <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801440:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801443:	89 d0                	mov    %edx,%eax
  801445:	01 c0                	add    %eax,%eax
  801447:	01 d0                	add    %edx,%eax
  801449:	c1 e0 02             	shl    $0x2,%eax
  80144c:	05 28 31 80 00       	add    $0x803128,%eax
  801451:	8b 00                	mov    (%eax),%eax
  801453:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801456:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801459:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  80145c:	ff 45 b4             	incl   -0x4c(%ebp)
  80145f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801462:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801465:	7c c1                	jl     801428 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801467:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80146d:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801470:	89 c8                	mov    %ecx,%eax
  801472:	01 c0                	add    %eax,%eax
  801474:	01 c8                	add    %ecx,%eax
  801476:	c1 e0 02             	shl    $0x2,%eax
  801479:	05 20 31 80 00       	add    $0x803120,%eax
  80147e:	8b 00                	mov    (%eax),%eax
  801480:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801487:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80148d:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801490:	89 c8                	mov    %ecx,%eax
  801492:	01 c0                	add    %eax,%eax
  801494:	01 c8                	add    %ecx,%eax
  801496:	c1 e0 02             	shl    $0x2,%eax
  801499:	05 24 31 80 00       	add    $0x803124,%eax
  80149e:	8b 00                	mov    (%eax),%eax
  8014a0:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  8014a7:	a1 28 30 80 00       	mov    0x803028,%eax
  8014ac:	40                   	inc    %eax
  8014ad:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  8014b2:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8014b5:	89 d0                	mov    %edx,%eax
  8014b7:	01 c0                	add    %eax,%eax
  8014b9:	01 d0                	add    %edx,%eax
  8014bb:	c1 e0 02             	shl    $0x2,%eax
  8014be:	05 20 31 80 00       	add    $0x803120,%eax
  8014c3:	8b 00                	mov    (%eax),%eax
  8014c5:	83 ec 08             	sub    $0x8,%esp
  8014c8:	ff 75 08             	pushl  0x8(%ebp)
  8014cb:	50                   	push   %eax
  8014cc:	e8 48 04 00 00       	call   801919 <sys_allocateMem>
  8014d1:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  8014d4:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8014db:	eb 78                	jmp    801555 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8014dd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8014e0:	89 d0                	mov    %edx,%eax
  8014e2:	01 c0                	add    %eax,%eax
  8014e4:	01 d0                	add    %edx,%eax
  8014e6:	c1 e0 02             	shl    $0x2,%eax
  8014e9:	05 20 31 80 00       	add    $0x803120,%eax
  8014ee:	8b 00                	mov    (%eax),%eax
  8014f0:	83 ec 04             	sub    $0x4,%esp
  8014f3:	50                   	push   %eax
  8014f4:	ff 75 b0             	pushl  -0x50(%ebp)
  8014f7:	68 50 26 80 00       	push   $0x802650
  8014fc:	e8 50 ee ff ff       	call   800351 <cprintf>
  801501:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801504:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801507:	89 d0                	mov    %edx,%eax
  801509:	01 c0                	add    %eax,%eax
  80150b:	01 d0                	add    %edx,%eax
  80150d:	c1 e0 02             	shl    $0x2,%eax
  801510:	05 24 31 80 00       	add    $0x803124,%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	50                   	push   %eax
  80151b:	ff 75 b0             	pushl  -0x50(%ebp)
  80151e:	68 65 26 80 00       	push   $0x802665
  801523:	e8 29 ee ff ff       	call   800351 <cprintf>
  801528:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  80152b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80152e:	89 d0                	mov    %edx,%eax
  801530:	01 c0                	add    %eax,%eax
  801532:	01 d0                	add    %edx,%eax
  801534:	c1 e0 02             	shl    $0x2,%eax
  801537:	05 28 31 80 00       	add    $0x803128,%eax
  80153c:	8b 00                	mov    (%eax),%eax
  80153e:	83 ec 04             	sub    $0x4,%esp
  801541:	50                   	push   %eax
  801542:	ff 75 b0             	pushl  -0x50(%ebp)
  801545:	68 78 26 80 00       	push   $0x802678
  80154a:	e8 02 ee ff ff       	call   800351 <cprintf>
  80154f:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801552:	ff 45 b0             	incl   -0x50(%ebp)
  801555:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801558:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80155b:	7c 80                	jl     8014dd <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  80155d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801560:	89 d0                	mov    %edx,%eax
  801562:	01 c0                	add    %eax,%eax
  801564:	01 d0                	add    %edx,%eax
  801566:	c1 e0 02             	shl    $0x2,%eax
  801569:	05 20 31 80 00       	add    $0x803120,%eax
  80156e:	8b 00                	mov    (%eax),%eax
  801570:	83 ec 08             	sub    $0x8,%esp
  801573:	50                   	push   %eax
  801574:	68 8c 26 80 00       	push   $0x80268c
  801579:	e8 d3 ed ff ff       	call   800351 <cprintf>
  80157e:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801581:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801584:	89 d0                	mov    %edx,%eax
  801586:	01 c0                	add    %eax,%eax
  801588:	01 d0                	add    %edx,%eax
  80158a:	c1 e0 02             	shl    $0x2,%eax
  80158d:	05 20 31 80 00       	add    $0x803120,%eax
  801592:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  8015a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8015a9:	eb 4b                	jmp    8015f6 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  8015ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ae:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8015b5:	89 c2                	mov    %eax,%edx
  8015b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ba:	39 c2                	cmp    %eax,%edx
  8015bc:	7f 35                	jg     8015f3 <free+0x5d>
  8015be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c1:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8015c8:	89 c2                	mov    %eax,%edx
  8015ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015cd:	39 c2                	cmp    %eax,%edx
  8015cf:	7e 22                	jle    8015f3 <free+0x5d>
				start=arr_add[i].start;
  8015d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d4:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8015db:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8015de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e1:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8015e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8015eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8015f1:	eb 0d                	jmp    801600 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8015f3:	ff 45 ec             	incl   -0x14(%ebp)
  8015f6:	a1 28 30 80 00       	mov    0x803028,%eax
  8015fb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8015fe:	7c ab                	jl     8015ab <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801603:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80160a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160d:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801614:	29 c2                	sub    %eax,%edx
  801616:	89 d0                	mov    %edx,%eax
  801618:	83 ec 08             	sub    $0x8,%esp
  80161b:	50                   	push   %eax
  80161c:	ff 75 f4             	pushl  -0xc(%ebp)
  80161f:	e8 d9 02 00 00       	call   8018fd <sys_freeMem>
  801624:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80162d:	eb 2d                	jmp    80165c <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  80162f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801632:	40                   	inc    %eax
  801633:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80163a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80163d:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801647:	40                   	inc    %eax
  801648:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80164f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801652:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801659:	ff 45 e8             	incl   -0x18(%ebp)
  80165c:	a1 28 30 80 00       	mov    0x803028,%eax
  801661:	48                   	dec    %eax
  801662:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801665:	7f c8                	jg     80162f <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801667:	a1 28 30 80 00       	mov    0x803028,%eax
  80166c:	48                   	dec    %eax
  80166d:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801672:	90                   	nop
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 18             	sub    $0x18,%esp
  80167b:	8b 45 10             	mov    0x10(%ebp),%eax
  80167e:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801681:	83 ec 04             	sub    $0x4,%esp
  801684:	68 a8 26 80 00       	push   $0x8026a8
  801689:	68 18 01 00 00       	push   $0x118
  80168e:	68 cb 26 80 00       	push   $0x8026cb
  801693:	e8 0b 07 00 00       	call   801da3 <_panic>

00801698 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80169e:	83 ec 04             	sub    $0x4,%esp
  8016a1:	68 a8 26 80 00       	push   $0x8026a8
  8016a6:	68 1e 01 00 00       	push   $0x11e
  8016ab:	68 cb 26 80 00       	push   $0x8026cb
  8016b0:	e8 ee 06 00 00       	call   801da3 <_panic>

008016b5 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8016bb:	83 ec 04             	sub    $0x4,%esp
  8016be:	68 a8 26 80 00       	push   $0x8026a8
  8016c3:	68 24 01 00 00       	push   $0x124
  8016c8:	68 cb 26 80 00       	push   $0x8026cb
  8016cd:	e8 d1 06 00 00       	call   801da3 <_panic>

008016d2 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8016d8:	83 ec 04             	sub    $0x4,%esp
  8016db:	68 a8 26 80 00       	push   $0x8026a8
  8016e0:	68 29 01 00 00       	push   $0x129
  8016e5:	68 cb 26 80 00       	push   $0x8026cb
  8016ea:	e8 b4 06 00 00       	call   801da3 <_panic>

008016ef <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8016f5:	83 ec 04             	sub    $0x4,%esp
  8016f8:	68 a8 26 80 00       	push   $0x8026a8
  8016fd:	68 2f 01 00 00       	push   $0x12f
  801702:	68 cb 26 80 00       	push   $0x8026cb
  801707:	e8 97 06 00 00       	call   801da3 <_panic>

0080170c <shrink>:
}
void shrink(uint32 newSize)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801712:	83 ec 04             	sub    $0x4,%esp
  801715:	68 a8 26 80 00       	push   $0x8026a8
  80171a:	68 33 01 00 00       	push   $0x133
  80171f:	68 cb 26 80 00       	push   $0x8026cb
  801724:	e8 7a 06 00 00       	call   801da3 <_panic>

00801729 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80172f:	83 ec 04             	sub    $0x4,%esp
  801732:	68 a8 26 80 00       	push   $0x8026a8
  801737:	68 38 01 00 00       	push   $0x138
  80173c:	68 cb 26 80 00       	push   $0x8026cb
  801741:	e8 5d 06 00 00       	call   801da3 <_panic>

00801746 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	57                   	push   %edi
  80174a:	56                   	push   %esi
  80174b:	53                   	push   %ebx
  80174c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	8b 55 0c             	mov    0xc(%ebp),%edx
  801755:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801758:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80175b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80175e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801761:	cd 30                	int    $0x30
  801763:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801766:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801769:	83 c4 10             	add    $0x10,%esp
  80176c:	5b                   	pop    %ebx
  80176d:	5e                   	pop    %esi
  80176e:	5f                   	pop    %edi
  80176f:	5d                   	pop    %ebp
  801770:	c3                   	ret    

00801771 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	83 ec 04             	sub    $0x4,%esp
  801777:	8b 45 10             	mov    0x10(%ebp),%eax
  80177a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80177d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	52                   	push   %edx
  801789:	ff 75 0c             	pushl  0xc(%ebp)
  80178c:	50                   	push   %eax
  80178d:	6a 00                	push   $0x0
  80178f:	e8 b2 ff ff ff       	call   801746 <syscall>
  801794:	83 c4 18             	add    $0x18,%esp
}
  801797:	90                   	nop
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_cgetc>:

int
sys_cgetc(void)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 01                	push   $0x1
  8017a9:	e8 98 ff ff ff       	call   801746 <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	50                   	push   %eax
  8017c2:	6a 05                	push   $0x5
  8017c4:	e8 7d ff ff ff       	call   801746 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 02                	push   $0x2
  8017dd:	e8 64 ff ff ff       	call   801746 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 03                	push   $0x3
  8017f6:	e8 4b ff ff ff       	call   801746 <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 04                	push   $0x4
  80180f:	e8 32 ff ff ff       	call   801746 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_env_exit>:


void sys_env_exit(void)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 06                	push   $0x6
  801828:	e8 19 ff ff ff       	call   801746 <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	90                   	nop
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801836:	8b 55 0c             	mov    0xc(%ebp),%edx
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	52                   	push   %edx
  801843:	50                   	push   %eax
  801844:	6a 07                	push   $0x7
  801846:	e8 fb fe ff ff       	call   801746 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	56                   	push   %esi
  801854:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801855:	8b 75 18             	mov    0x18(%ebp),%esi
  801858:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80185b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	56                   	push   %esi
  801865:	53                   	push   %ebx
  801866:	51                   	push   %ecx
  801867:	52                   	push   %edx
  801868:	50                   	push   %eax
  801869:	6a 08                	push   $0x8
  80186b:	e8 d6 fe ff ff       	call   801746 <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
}
  801873:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801876:	5b                   	pop    %ebx
  801877:	5e                   	pop    %esi
  801878:	5d                   	pop    %ebp
  801879:	c3                   	ret    

0080187a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80187d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	52                   	push   %edx
  80188a:	50                   	push   %eax
  80188b:	6a 09                	push   $0x9
  80188d:	e8 b4 fe ff ff       	call   801746 <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	ff 75 08             	pushl  0x8(%ebp)
  8018a6:	6a 0a                	push   $0xa
  8018a8:	e8 99 fe ff ff       	call   801746 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 0b                	push   $0xb
  8018c1:	e8 80 fe ff ff       	call   801746 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 0c                	push   $0xc
  8018da:	e8 67 fe ff ff       	call   801746 <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 0d                	push   $0xd
  8018f3:	e8 4e fe ff ff       	call   801746 <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	ff 75 08             	pushl  0x8(%ebp)
  80190c:	6a 11                	push   $0x11
  80190e:	e8 33 fe ff ff       	call   801746 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
	return;
  801916:	90                   	nop
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	ff 75 0c             	pushl  0xc(%ebp)
  801925:	ff 75 08             	pushl  0x8(%ebp)
  801928:	6a 12                	push   $0x12
  80192a:	e8 17 fe ff ff       	call   801746 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
	return ;
  801932:	90                   	nop
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 0e                	push   $0xe
  801944:	e8 fd fd ff ff       	call   801746 <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	6a 0f                	push   $0xf
  80195e:	e8 e3 fd ff ff       	call   801746 <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 10                	push   $0x10
  801977:	e8 ca fd ff ff       	call   801746 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	90                   	nop
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 14                	push   $0x14
  801991:	e8 b0 fd ff ff       	call   801746 <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	90                   	nop
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 15                	push   $0x15
  8019ab:	e8 96 fd ff ff       	call   801746 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	90                   	nop
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	83 ec 04             	sub    $0x4,%esp
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019c2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	50                   	push   %eax
  8019cf:	6a 16                	push   $0x16
  8019d1:	e8 70 fd ff ff       	call   801746 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	90                   	nop
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 17                	push   $0x17
  8019eb:	e8 56 fd ff ff       	call   801746 <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	90                   	nop
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	ff 75 0c             	pushl  0xc(%ebp)
  801a05:	50                   	push   %eax
  801a06:	6a 18                	push   $0x18
  801a08:	e8 39 fd ff ff       	call   801746 <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	52                   	push   %edx
  801a22:	50                   	push   %eax
  801a23:	6a 1b                	push   $0x1b
  801a25:	e8 1c fd ff ff       	call   801746 <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	52                   	push   %edx
  801a3f:	50                   	push   %eax
  801a40:	6a 19                	push   $0x19
  801a42:	e8 ff fc ff ff       	call   801746 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	90                   	nop
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	52                   	push   %edx
  801a5d:	50                   	push   %eax
  801a5e:	6a 1a                	push   $0x1a
  801a60:	e8 e1 fc ff ff       	call   801746 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	90                   	nop
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	83 ec 04             	sub    $0x4,%esp
  801a71:	8b 45 10             	mov    0x10(%ebp),%eax
  801a74:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a77:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a7a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	51                   	push   %ecx
  801a84:	52                   	push   %edx
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	50                   	push   %eax
  801a89:	6a 1c                	push   $0x1c
  801a8b:	e8 b6 fc ff ff       	call   801746 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	52                   	push   %edx
  801aa5:	50                   	push   %eax
  801aa6:	6a 1d                	push   $0x1d
  801aa8:	e8 99 fc ff ff       	call   801746 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ab5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	51                   	push   %ecx
  801ac3:	52                   	push   %edx
  801ac4:	50                   	push   %eax
  801ac5:	6a 1e                	push   $0x1e
  801ac7:	e8 7a fc ff ff       	call   801746 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	52                   	push   %edx
  801ae1:	50                   	push   %eax
  801ae2:	6a 1f                	push   $0x1f
  801ae4:	e8 5d fc ff ff       	call   801746 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 20                	push   $0x20
  801afd:	e8 44 fc ff ff       	call   801746 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	ff 75 14             	pushl  0x14(%ebp)
  801b12:	ff 75 10             	pushl  0x10(%ebp)
  801b15:	ff 75 0c             	pushl  0xc(%ebp)
  801b18:	50                   	push   %eax
  801b19:	6a 21                	push   $0x21
  801b1b:	e8 26 fc ff ff       	call   801746 <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	50                   	push   %eax
  801b34:	6a 22                	push   $0x22
  801b36:	e8 0b fc ff ff       	call   801746 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	90                   	nop
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	50                   	push   %eax
  801b50:	6a 23                	push   $0x23
  801b52:	e8 ef fb ff ff       	call   801746 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	90                   	nop
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b63:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b66:	8d 50 04             	lea    0x4(%eax),%edx
  801b69:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	52                   	push   %edx
  801b73:	50                   	push   %eax
  801b74:	6a 24                	push   $0x24
  801b76:	e8 cb fb ff ff       	call   801746 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
	return result;
  801b7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b87:	89 01                	mov    %eax,(%ecx)
  801b89:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	c9                   	leave  
  801b90:	c2 04 00             	ret    $0x4

00801b93 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	ff 75 10             	pushl  0x10(%ebp)
  801b9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ba0:	ff 75 08             	pushl  0x8(%ebp)
  801ba3:	6a 13                	push   $0x13
  801ba5:	e8 9c fb ff ff       	call   801746 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
	return ;
  801bad:	90                   	nop
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 25                	push   $0x25
  801bbf:	e8 82 fb ff ff       	call   801746 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 04             	sub    $0x4,%esp
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bd5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	50                   	push   %eax
  801be2:	6a 26                	push   $0x26
  801be4:	e8 5d fb ff ff       	call   801746 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bec:	90                   	nop
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <rsttst>:
void rsttst()
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 28                	push   $0x28
  801bfe:	e8 43 fb ff ff       	call   801746 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
	return ;
  801c06:	90                   	nop
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 04             	sub    $0x4,%esp
  801c0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c12:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c15:	8b 55 18             	mov    0x18(%ebp),%edx
  801c18:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c1c:	52                   	push   %edx
  801c1d:	50                   	push   %eax
  801c1e:	ff 75 10             	pushl  0x10(%ebp)
  801c21:	ff 75 0c             	pushl  0xc(%ebp)
  801c24:	ff 75 08             	pushl  0x8(%ebp)
  801c27:	6a 27                	push   $0x27
  801c29:	e8 18 fb ff ff       	call   801746 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c31:	90                   	nop
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <chktst>:
void chktst(uint32 n)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	ff 75 08             	pushl  0x8(%ebp)
  801c42:	6a 29                	push   $0x29
  801c44:	e8 fd fa ff ff       	call   801746 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4c:	90                   	nop
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <inctst>:

void inctst()
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 2a                	push   $0x2a
  801c5e:	e8 e3 fa ff ff       	call   801746 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
	return ;
  801c66:	90                   	nop
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <gettst>:
uint32 gettst()
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 2b                	push   $0x2b
  801c78:	e8 c9 fa ff ff       	call   801746 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 2c                	push   $0x2c
  801c94:	e8 ad fa ff ff       	call   801746 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
  801c9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c9f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ca3:	75 07                	jne    801cac <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ca5:	b8 01 00 00 00       	mov    $0x1,%eax
  801caa:	eb 05                	jmp    801cb1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 2c                	push   $0x2c
  801cc5:	e8 7c fa ff ff       	call   801746 <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
  801ccd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cd0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cd4:	75 07                	jne    801cdd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cdb:	eb 05                	jmp    801ce2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 2c                	push   $0x2c
  801cf6:	e8 4b fa ff ff       	call   801746 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
  801cfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d01:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d05:	75 07                	jne    801d0e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d07:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0c:	eb 05                	jmp    801d13 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 2c                	push   $0x2c
  801d27:	e8 1a fa ff ff       	call   801746 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
  801d2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d32:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d36:	75 07                	jne    801d3f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d38:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3d:	eb 05                	jmp    801d44 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	ff 75 08             	pushl  0x8(%ebp)
  801d54:	6a 2d                	push   $0x2d
  801d56:	e8 eb f9 ff ff       	call   801746 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5e:	90                   	nop
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d65:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d68:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d71:	6a 00                	push   $0x0
  801d73:	53                   	push   %ebx
  801d74:	51                   	push   %ecx
  801d75:	52                   	push   %edx
  801d76:	50                   	push   %eax
  801d77:	6a 2e                	push   $0x2e
  801d79:	e8 c8 f9 ff ff       	call   801746 <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
}
  801d81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	52                   	push   %edx
  801d96:	50                   	push   %eax
  801d97:	6a 2f                	push   $0x2f
  801d99:	e8 a8 f9 ff ff       	call   801746 <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801da9:	8d 45 10             	lea    0x10(%ebp),%eax
  801dac:	83 c0 04             	add    $0x4,%eax
  801daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801db2:	a1 60 3e 83 00       	mov    0x833e60,%eax
  801db7:	85 c0                	test   %eax,%eax
  801db9:	74 16                	je     801dd1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801dbb:	a1 60 3e 83 00       	mov    0x833e60,%eax
  801dc0:	83 ec 08             	sub    $0x8,%esp
  801dc3:	50                   	push   %eax
  801dc4:	68 d8 26 80 00       	push   $0x8026d8
  801dc9:	e8 83 e5 ff ff       	call   800351 <cprintf>
  801dce:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801dd1:	a1 00 30 80 00       	mov    0x803000,%eax
  801dd6:	ff 75 0c             	pushl  0xc(%ebp)
  801dd9:	ff 75 08             	pushl  0x8(%ebp)
  801ddc:	50                   	push   %eax
  801ddd:	68 dd 26 80 00       	push   $0x8026dd
  801de2:	e8 6a e5 ff ff       	call   800351 <cprintf>
  801de7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801dea:	8b 45 10             	mov    0x10(%ebp),%eax
  801ded:	83 ec 08             	sub    $0x8,%esp
  801df0:	ff 75 f4             	pushl  -0xc(%ebp)
  801df3:	50                   	push   %eax
  801df4:	e8 ed e4 ff ff       	call   8002e6 <vcprintf>
  801df9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801dfc:	83 ec 08             	sub    $0x8,%esp
  801dff:	6a 00                	push   $0x0
  801e01:	68 f9 26 80 00       	push   $0x8026f9
  801e06:	e8 db e4 ff ff       	call   8002e6 <vcprintf>
  801e0b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801e0e:	e8 5c e4 ff ff       	call   80026f <exit>

	// should not return here
	while (1) ;
  801e13:	eb fe                	jmp    801e13 <_panic+0x70>

00801e15 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801e1b:	a1 20 30 80 00       	mov    0x803020,%eax
  801e20:	8b 50 74             	mov    0x74(%eax),%edx
  801e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e26:	39 c2                	cmp    %eax,%edx
  801e28:	74 14                	je     801e3e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801e2a:	83 ec 04             	sub    $0x4,%esp
  801e2d:	68 fc 26 80 00       	push   $0x8026fc
  801e32:	6a 26                	push   $0x26
  801e34:	68 48 27 80 00       	push   $0x802748
  801e39:	e8 65 ff ff ff       	call   801da3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801e3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801e45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801e4c:	e9 b6 00 00 00       	jmp    801f07 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  801e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	01 d0                	add    %edx,%eax
  801e60:	8b 00                	mov    (%eax),%eax
  801e62:	85 c0                	test   %eax,%eax
  801e64:	75 08                	jne    801e6e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801e66:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801e69:	e9 96 00 00 00       	jmp    801f04 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  801e6e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801e75:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801e7c:	eb 5d                	jmp    801edb <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801e7e:	a1 20 30 80 00       	mov    0x803020,%eax
  801e83:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801e89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e8c:	c1 e2 04             	shl    $0x4,%edx
  801e8f:	01 d0                	add    %edx,%eax
  801e91:	8a 40 04             	mov    0x4(%eax),%al
  801e94:	84 c0                	test   %al,%al
  801e96:	75 40                	jne    801ed8 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801e98:	a1 20 30 80 00       	mov    0x803020,%eax
  801e9d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801ea3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ea6:	c1 e2 04             	shl    $0x4,%edx
  801ea9:	01 d0                	add    %edx,%eax
  801eab:	8b 00                	mov    (%eax),%eax
  801ead:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801eb0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eb3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801eb8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	01 c8                	add    %ecx,%eax
  801ec9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ecb:	39 c2                	cmp    %eax,%edx
  801ecd:	75 09                	jne    801ed8 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  801ecf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801ed6:	eb 12                	jmp    801eea <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ed8:	ff 45 e8             	incl   -0x18(%ebp)
  801edb:	a1 20 30 80 00       	mov    0x803020,%eax
  801ee0:	8b 50 74             	mov    0x74(%eax),%edx
  801ee3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ee6:	39 c2                	cmp    %eax,%edx
  801ee8:	77 94                	ja     801e7e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801eea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801eee:	75 14                	jne    801f04 <CheckWSWithoutLastIndex+0xef>
			panic(
  801ef0:	83 ec 04             	sub    $0x4,%esp
  801ef3:	68 54 27 80 00       	push   $0x802754
  801ef8:	6a 3a                	push   $0x3a
  801efa:	68 48 27 80 00       	push   $0x802748
  801eff:	e8 9f fe ff ff       	call   801da3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801f04:	ff 45 f0             	incl   -0x10(%ebp)
  801f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f0d:	0f 8c 3e ff ff ff    	jl     801e51 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801f13:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801f1a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f21:	eb 20                	jmp    801f43 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801f23:	a1 20 30 80 00       	mov    0x803020,%eax
  801f28:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801f2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f31:	c1 e2 04             	shl    $0x4,%edx
  801f34:	01 d0                	add    %edx,%eax
  801f36:	8a 40 04             	mov    0x4(%eax),%al
  801f39:	3c 01                	cmp    $0x1,%al
  801f3b:	75 03                	jne    801f40 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  801f3d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801f40:	ff 45 e0             	incl   -0x20(%ebp)
  801f43:	a1 20 30 80 00       	mov    0x803020,%eax
  801f48:	8b 50 74             	mov    0x74(%eax),%edx
  801f4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f4e:	39 c2                	cmp    %eax,%edx
  801f50:	77 d1                	ja     801f23 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f58:	74 14                	je     801f6e <CheckWSWithoutLastIndex+0x159>
		panic(
  801f5a:	83 ec 04             	sub    $0x4,%esp
  801f5d:	68 a8 27 80 00       	push   $0x8027a8
  801f62:	6a 44                	push   $0x44
  801f64:	68 48 27 80 00       	push   $0x802748
  801f69:	e8 35 fe ff ff       	call   801da3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801f6e:	90                   	nop
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    
  801f71:	66 90                	xchg   %ax,%ax
  801f73:	90                   	nop

00801f74 <__udivdi3>:
  801f74:	55                   	push   %ebp
  801f75:	57                   	push   %edi
  801f76:	56                   	push   %esi
  801f77:	53                   	push   %ebx
  801f78:	83 ec 1c             	sub    $0x1c,%esp
  801f7b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f7f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f8b:	89 ca                	mov    %ecx,%edx
  801f8d:	89 f8                	mov    %edi,%eax
  801f8f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f93:	85 f6                	test   %esi,%esi
  801f95:	75 2d                	jne    801fc4 <__udivdi3+0x50>
  801f97:	39 cf                	cmp    %ecx,%edi
  801f99:	77 65                	ja     802000 <__udivdi3+0x8c>
  801f9b:	89 fd                	mov    %edi,%ebp
  801f9d:	85 ff                	test   %edi,%edi
  801f9f:	75 0b                	jne    801fac <__udivdi3+0x38>
  801fa1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa6:	31 d2                	xor    %edx,%edx
  801fa8:	f7 f7                	div    %edi
  801faa:	89 c5                	mov    %eax,%ebp
  801fac:	31 d2                	xor    %edx,%edx
  801fae:	89 c8                	mov    %ecx,%eax
  801fb0:	f7 f5                	div    %ebp
  801fb2:	89 c1                	mov    %eax,%ecx
  801fb4:	89 d8                	mov    %ebx,%eax
  801fb6:	f7 f5                	div    %ebp
  801fb8:	89 cf                	mov    %ecx,%edi
  801fba:	89 fa                	mov    %edi,%edx
  801fbc:	83 c4 1c             	add    $0x1c,%esp
  801fbf:	5b                   	pop    %ebx
  801fc0:	5e                   	pop    %esi
  801fc1:	5f                   	pop    %edi
  801fc2:	5d                   	pop    %ebp
  801fc3:	c3                   	ret    
  801fc4:	39 ce                	cmp    %ecx,%esi
  801fc6:	77 28                	ja     801ff0 <__udivdi3+0x7c>
  801fc8:	0f bd fe             	bsr    %esi,%edi
  801fcb:	83 f7 1f             	xor    $0x1f,%edi
  801fce:	75 40                	jne    802010 <__udivdi3+0x9c>
  801fd0:	39 ce                	cmp    %ecx,%esi
  801fd2:	72 0a                	jb     801fde <__udivdi3+0x6a>
  801fd4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801fd8:	0f 87 9e 00 00 00    	ja     80207c <__udivdi3+0x108>
  801fde:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe3:	89 fa                	mov    %edi,%edx
  801fe5:	83 c4 1c             	add    $0x1c,%esp
  801fe8:	5b                   	pop    %ebx
  801fe9:	5e                   	pop    %esi
  801fea:	5f                   	pop    %edi
  801feb:	5d                   	pop    %ebp
  801fec:	c3                   	ret    
  801fed:	8d 76 00             	lea    0x0(%esi),%esi
  801ff0:	31 ff                	xor    %edi,%edi
  801ff2:	31 c0                	xor    %eax,%eax
  801ff4:	89 fa                	mov    %edi,%edx
  801ff6:	83 c4 1c             	add    $0x1c,%esp
  801ff9:	5b                   	pop    %ebx
  801ffa:	5e                   	pop    %esi
  801ffb:	5f                   	pop    %edi
  801ffc:	5d                   	pop    %ebp
  801ffd:	c3                   	ret    
  801ffe:	66 90                	xchg   %ax,%ax
  802000:	89 d8                	mov    %ebx,%eax
  802002:	f7 f7                	div    %edi
  802004:	31 ff                	xor    %edi,%edi
  802006:	89 fa                	mov    %edi,%edx
  802008:	83 c4 1c             	add    $0x1c,%esp
  80200b:	5b                   	pop    %ebx
  80200c:	5e                   	pop    %esi
  80200d:	5f                   	pop    %edi
  80200e:	5d                   	pop    %ebp
  80200f:	c3                   	ret    
  802010:	bd 20 00 00 00       	mov    $0x20,%ebp
  802015:	89 eb                	mov    %ebp,%ebx
  802017:	29 fb                	sub    %edi,%ebx
  802019:	89 f9                	mov    %edi,%ecx
  80201b:	d3 e6                	shl    %cl,%esi
  80201d:	89 c5                	mov    %eax,%ebp
  80201f:	88 d9                	mov    %bl,%cl
  802021:	d3 ed                	shr    %cl,%ebp
  802023:	89 e9                	mov    %ebp,%ecx
  802025:	09 f1                	or     %esi,%ecx
  802027:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80202b:	89 f9                	mov    %edi,%ecx
  80202d:	d3 e0                	shl    %cl,%eax
  80202f:	89 c5                	mov    %eax,%ebp
  802031:	89 d6                	mov    %edx,%esi
  802033:	88 d9                	mov    %bl,%cl
  802035:	d3 ee                	shr    %cl,%esi
  802037:	89 f9                	mov    %edi,%ecx
  802039:	d3 e2                	shl    %cl,%edx
  80203b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80203f:	88 d9                	mov    %bl,%cl
  802041:	d3 e8                	shr    %cl,%eax
  802043:	09 c2                	or     %eax,%edx
  802045:	89 d0                	mov    %edx,%eax
  802047:	89 f2                	mov    %esi,%edx
  802049:	f7 74 24 0c          	divl   0xc(%esp)
  80204d:	89 d6                	mov    %edx,%esi
  80204f:	89 c3                	mov    %eax,%ebx
  802051:	f7 e5                	mul    %ebp
  802053:	39 d6                	cmp    %edx,%esi
  802055:	72 19                	jb     802070 <__udivdi3+0xfc>
  802057:	74 0b                	je     802064 <__udivdi3+0xf0>
  802059:	89 d8                	mov    %ebx,%eax
  80205b:	31 ff                	xor    %edi,%edi
  80205d:	e9 58 ff ff ff       	jmp    801fba <__udivdi3+0x46>
  802062:	66 90                	xchg   %ax,%ax
  802064:	8b 54 24 08          	mov    0x8(%esp),%edx
  802068:	89 f9                	mov    %edi,%ecx
  80206a:	d3 e2                	shl    %cl,%edx
  80206c:	39 c2                	cmp    %eax,%edx
  80206e:	73 e9                	jae    802059 <__udivdi3+0xe5>
  802070:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802073:	31 ff                	xor    %edi,%edi
  802075:	e9 40 ff ff ff       	jmp    801fba <__udivdi3+0x46>
  80207a:	66 90                	xchg   %ax,%ax
  80207c:	31 c0                	xor    %eax,%eax
  80207e:	e9 37 ff ff ff       	jmp    801fba <__udivdi3+0x46>
  802083:	90                   	nop

00802084 <__umoddi3>:
  802084:	55                   	push   %ebp
  802085:	57                   	push   %edi
  802086:	56                   	push   %esi
  802087:	53                   	push   %ebx
  802088:	83 ec 1c             	sub    $0x1c,%esp
  80208b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80208f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802093:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802097:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80209b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80209f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020a3:	89 f3                	mov    %esi,%ebx
  8020a5:	89 fa                	mov    %edi,%edx
  8020a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020ab:	89 34 24             	mov    %esi,(%esp)
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	75 1a                	jne    8020cc <__umoddi3+0x48>
  8020b2:	39 f7                	cmp    %esi,%edi
  8020b4:	0f 86 a2 00 00 00    	jbe    80215c <__umoddi3+0xd8>
  8020ba:	89 c8                	mov    %ecx,%eax
  8020bc:	89 f2                	mov    %esi,%edx
  8020be:	f7 f7                	div    %edi
  8020c0:	89 d0                	mov    %edx,%eax
  8020c2:	31 d2                	xor    %edx,%edx
  8020c4:	83 c4 1c             	add    $0x1c,%esp
  8020c7:	5b                   	pop    %ebx
  8020c8:	5e                   	pop    %esi
  8020c9:	5f                   	pop    %edi
  8020ca:	5d                   	pop    %ebp
  8020cb:	c3                   	ret    
  8020cc:	39 f0                	cmp    %esi,%eax
  8020ce:	0f 87 ac 00 00 00    	ja     802180 <__umoddi3+0xfc>
  8020d4:	0f bd e8             	bsr    %eax,%ebp
  8020d7:	83 f5 1f             	xor    $0x1f,%ebp
  8020da:	0f 84 ac 00 00 00    	je     80218c <__umoddi3+0x108>
  8020e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8020e5:	29 ef                	sub    %ebp,%edi
  8020e7:	89 fe                	mov    %edi,%esi
  8020e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020ed:	89 e9                	mov    %ebp,%ecx
  8020ef:	d3 e0                	shl    %cl,%eax
  8020f1:	89 d7                	mov    %edx,%edi
  8020f3:	89 f1                	mov    %esi,%ecx
  8020f5:	d3 ef                	shr    %cl,%edi
  8020f7:	09 c7                	or     %eax,%edi
  8020f9:	89 e9                	mov    %ebp,%ecx
  8020fb:	d3 e2                	shl    %cl,%edx
  8020fd:	89 14 24             	mov    %edx,(%esp)
  802100:	89 d8                	mov    %ebx,%eax
  802102:	d3 e0                	shl    %cl,%eax
  802104:	89 c2                	mov    %eax,%edx
  802106:	8b 44 24 08          	mov    0x8(%esp),%eax
  80210a:	d3 e0                	shl    %cl,%eax
  80210c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802110:	8b 44 24 08          	mov    0x8(%esp),%eax
  802114:	89 f1                	mov    %esi,%ecx
  802116:	d3 e8                	shr    %cl,%eax
  802118:	09 d0                	or     %edx,%eax
  80211a:	d3 eb                	shr    %cl,%ebx
  80211c:	89 da                	mov    %ebx,%edx
  80211e:	f7 f7                	div    %edi
  802120:	89 d3                	mov    %edx,%ebx
  802122:	f7 24 24             	mull   (%esp)
  802125:	89 c6                	mov    %eax,%esi
  802127:	89 d1                	mov    %edx,%ecx
  802129:	39 d3                	cmp    %edx,%ebx
  80212b:	0f 82 87 00 00 00    	jb     8021b8 <__umoddi3+0x134>
  802131:	0f 84 91 00 00 00    	je     8021c8 <__umoddi3+0x144>
  802137:	8b 54 24 04          	mov    0x4(%esp),%edx
  80213b:	29 f2                	sub    %esi,%edx
  80213d:	19 cb                	sbb    %ecx,%ebx
  80213f:	89 d8                	mov    %ebx,%eax
  802141:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802145:	d3 e0                	shl    %cl,%eax
  802147:	89 e9                	mov    %ebp,%ecx
  802149:	d3 ea                	shr    %cl,%edx
  80214b:	09 d0                	or     %edx,%eax
  80214d:	89 e9                	mov    %ebp,%ecx
  80214f:	d3 eb                	shr    %cl,%ebx
  802151:	89 da                	mov    %ebx,%edx
  802153:	83 c4 1c             	add    $0x1c,%esp
  802156:	5b                   	pop    %ebx
  802157:	5e                   	pop    %esi
  802158:	5f                   	pop    %edi
  802159:	5d                   	pop    %ebp
  80215a:	c3                   	ret    
  80215b:	90                   	nop
  80215c:	89 fd                	mov    %edi,%ebp
  80215e:	85 ff                	test   %edi,%edi
  802160:	75 0b                	jne    80216d <__umoddi3+0xe9>
  802162:	b8 01 00 00 00       	mov    $0x1,%eax
  802167:	31 d2                	xor    %edx,%edx
  802169:	f7 f7                	div    %edi
  80216b:	89 c5                	mov    %eax,%ebp
  80216d:	89 f0                	mov    %esi,%eax
  80216f:	31 d2                	xor    %edx,%edx
  802171:	f7 f5                	div    %ebp
  802173:	89 c8                	mov    %ecx,%eax
  802175:	f7 f5                	div    %ebp
  802177:	89 d0                	mov    %edx,%eax
  802179:	e9 44 ff ff ff       	jmp    8020c2 <__umoddi3+0x3e>
  80217e:	66 90                	xchg   %ax,%ax
  802180:	89 c8                	mov    %ecx,%eax
  802182:	89 f2                	mov    %esi,%edx
  802184:	83 c4 1c             	add    $0x1c,%esp
  802187:	5b                   	pop    %ebx
  802188:	5e                   	pop    %esi
  802189:	5f                   	pop    %edi
  80218a:	5d                   	pop    %ebp
  80218b:	c3                   	ret    
  80218c:	3b 04 24             	cmp    (%esp),%eax
  80218f:	72 06                	jb     802197 <__umoddi3+0x113>
  802191:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802195:	77 0f                	ja     8021a6 <__umoddi3+0x122>
  802197:	89 f2                	mov    %esi,%edx
  802199:	29 f9                	sub    %edi,%ecx
  80219b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80219f:	89 14 24             	mov    %edx,(%esp)
  8021a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021aa:	8b 14 24             	mov    (%esp),%edx
  8021ad:	83 c4 1c             	add    $0x1c,%esp
  8021b0:	5b                   	pop    %ebx
  8021b1:	5e                   	pop    %esi
  8021b2:	5f                   	pop    %edi
  8021b3:	5d                   	pop    %ebp
  8021b4:	c3                   	ret    
  8021b5:	8d 76 00             	lea    0x0(%esi),%esi
  8021b8:	2b 04 24             	sub    (%esp),%eax
  8021bb:	19 fa                	sbb    %edi,%edx
  8021bd:	89 d1                	mov    %edx,%ecx
  8021bf:	89 c6                	mov    %eax,%esi
  8021c1:	e9 71 ff ff ff       	jmp    802137 <__umoddi3+0xb3>
  8021c6:	66 90                	xchg   %ax,%ax
  8021c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8021cc:	72 ea                	jb     8021b8 <__umoddi3+0x134>
  8021ce:	89 d9                	mov    %ebx,%ecx
  8021d0:	e9 62 ff ff ff       	jmp    802137 <__umoddi3+0xb3>
