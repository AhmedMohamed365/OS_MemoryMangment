
obj/user/ef_tst_sharing_1:     file format elf32-i386


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
  800031:	e8 5e 03 00 00       	call   800394 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
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
  800087:	68 40 24 80 00       	push   $0x802440
  80008c:	6a 12                	push   $0x12
  80008e:	68 5c 24 80 00       	push   $0x80245c
  800093:	e8 41 04 00 00       	call   8004d9 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 74 24 80 00       	push   $0x802474
  8000a0:	e8 d6 06 00 00       	call   80077b <cprintf>
  8000a5:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000a8:	e8 2f 1c 00 00       	call   801cdc <sys_calculate_free_frames>
  8000ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b0:	83 ec 04             	sub    $0x4,%esp
  8000b3:	6a 01                	push   $0x1
  8000b5:	68 00 10 00 00       	push   $0x1000
  8000ba:	68 ab 24 80 00       	push   $0x8024ab
  8000bf:	e8 db 19 00 00       	call   801a9f <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000ca:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d1:	74 14                	je     8000e7 <_main+0xaf>
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	68 b0 24 80 00       	push   $0x8024b0
  8000db:	6a 1a                	push   $0x1a
  8000dd:	68 5c 24 80 00       	push   $0x80245c
  8000e2:	e8 f2 03 00 00       	call   8004d9 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000e7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000ea:	e8 ed 1b 00 00       	call   801cdc <sys_calculate_free_frames>
  8000ef:	29 c3                	sub    %eax,%ebx
  8000f1:	89 d8                	mov    %ebx,%eax
  8000f3:	83 f8 04             	cmp    $0x4,%eax
  8000f6:	74 28                	je     800120 <_main+0xe8>
  8000f8:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000fb:	e8 dc 1b 00 00       	call   801cdc <sys_calculate_free_frames>
  800100:	29 c3                	sub    %eax,%ebx
  800102:	e8 d5 1b 00 00       	call   801cdc <sys_calculate_free_frames>
  800107:	83 ec 08             	sub    $0x8,%esp
  80010a:	53                   	push   %ebx
  80010b:	50                   	push   %eax
  80010c:	ff 75 e8             	pushl  -0x18(%ebp)
  80010f:	68 1c 25 80 00       	push   $0x80251c
  800114:	6a 1b                	push   $0x1b
  800116:	68 5c 24 80 00       	push   $0x80245c
  80011b:	e8 b9 03 00 00       	call   8004d9 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800120:	e8 b7 1b 00 00       	call   801cdc <sys_calculate_free_frames>
  800125:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("y", PAGE_SIZE + 4, 1);
  800128:	83 ec 04             	sub    $0x4,%esp
  80012b:	6a 01                	push   $0x1
  80012d:	68 04 10 00 00       	push   $0x1004
  800132:	68 a3 25 80 00       	push   $0x8025a3
  800137:	e8 63 19 00 00       	call   801a9f <smalloc>
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800142:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800149:	74 14                	je     80015f <_main+0x127>
  80014b:	83 ec 04             	sub    $0x4,%esp
  80014e:	68 b0 24 80 00       	push   $0x8024b0
  800153:	6a 1f                	push   $0x1f
  800155:	68 5c 24 80 00       	push   $0x80245c
  80015a:	e8 7a 03 00 00       	call   8004d9 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  80015f:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800162:	e8 75 1b 00 00       	call   801cdc <sys_calculate_free_frames>
  800167:	29 c3                	sub    %eax,%ebx
  800169:	89 d8                	mov    %ebx,%eax
  80016b:	83 f8 04             	cmp    $0x4,%eax
  80016e:	74 28                	je     800198 <_main+0x160>
  800170:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800173:	e8 64 1b 00 00       	call   801cdc <sys_calculate_free_frames>
  800178:	29 c3                	sub    %eax,%ebx
  80017a:	e8 5d 1b 00 00       	call   801cdc <sys_calculate_free_frames>
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	53                   	push   %ebx
  800183:	50                   	push   %eax
  800184:	ff 75 e8             	pushl  -0x18(%ebp)
  800187:	68 1c 25 80 00       	push   $0x80251c
  80018c:	6a 21                	push   $0x21
  80018e:	68 5c 24 80 00       	push   $0x80245c
  800193:	e8 41 03 00 00       	call   8004d9 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800198:	e8 3f 1b 00 00       	call   801cdc <sys_calculate_free_frames>
  80019d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("z", 4, 1);
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	6a 01                	push   $0x1
  8001a5:	6a 04                	push   $0x4
  8001a7:	68 a5 25 80 00       	push   $0x8025a5
  8001ac:	e8 ee 18 00 00       	call   801a9f <smalloc>
  8001b1:	83 c4 10             	add    $0x10,%esp
  8001b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001b7:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 b0 24 80 00       	push   $0x8024b0
  8001c8:	6a 25                	push   $0x25
  8001ca:	68 5c 24 80 00       	push   $0x80245c
  8001cf:	e8 05 03 00 00       	call   8004d9 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001d4:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001d7:	e8 00 1b 00 00       	call   801cdc <sys_calculate_free_frames>
  8001dc:	29 c3                	sub    %eax,%ebx
  8001de:	89 d8                	mov    %ebx,%eax
  8001e0:	83 f8 03             	cmp    $0x3,%eax
  8001e3:	74 14                	je     8001f9 <_main+0x1c1>
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 a8 25 80 00       	push   $0x8025a8
  8001ed:	6a 26                	push   $0x26
  8001ef:	68 5c 24 80 00       	push   $0x80245c
  8001f4:	e8 e0 02 00 00       	call   8004d9 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	68 28 26 80 00       	push   $0x802628
  800201:	e8 75 05 00 00       	call   80077b <cprintf>
  800206:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	68 50 26 80 00       	push   $0x802650
  800211:	e8 65 05 00 00       	call   80077b <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  800219:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800220:	eb 2d                	jmp    80024f <_main+0x217>
		{
			x[i] = -1;
  800222:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800225:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80022c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022f:	01 d0                	add    %edx,%eax
  800231:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800237:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800241:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800244:	01 d0                	add    %edx,%eax
  800246:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  80024c:	ff 45 ec             	incl   -0x14(%ebp)
  80024f:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  800256:	7e ca                	jle    800222 <_main+0x1ea>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  800258:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  80025f:	eb 18                	jmp    800279 <_main+0x241>
		{
			z[i] = -1;
  800261:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80026e:	01 d0                	add    %edx,%eax
  800270:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800276:	ff 45 ec             	incl   -0x14(%ebp)
  800279:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800280:	7e df                	jle    800261 <_main+0x229>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800282:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800285:	8b 00                	mov    (%eax),%eax
  800287:	83 f8 ff             	cmp    $0xffffffff,%eax
  80028a:	74 14                	je     8002a0 <_main+0x268>
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	68 78 26 80 00       	push   $0x802678
  800294:	6a 3a                	push   $0x3a
  800296:	68 5c 24 80 00       	push   $0x80245c
  80029b:	e8 39 02 00 00       	call   8004d9 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a3:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002a8:	8b 00                	mov    (%eax),%eax
  8002aa:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 78 26 80 00       	push   $0x802678
  8002b7:	6a 3b                	push   $0x3b
  8002b9:	68 5c 24 80 00       	push   $0x80245c
  8002be:	e8 16 02 00 00       	call   8004d9 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002c6:	8b 00                	mov    (%eax),%eax
  8002c8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002cb:	74 14                	je     8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 78 26 80 00       	push   $0x802678
  8002d5:	6a 3d                	push   $0x3d
  8002d7:	68 5c 24 80 00       	push   $0x80245c
  8002dc:	e8 f8 01 00 00       	call   8004d9 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002e4:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002ee:	74 14                	je     800304 <_main+0x2cc>
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	68 78 26 80 00       	push   $0x802678
  8002f8:	6a 3e                	push   $0x3e
  8002fa:	68 5c 24 80 00       	push   $0x80245c
  8002ff:	e8 d5 01 00 00       	call   8004d9 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800304:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800307:	8b 00                	mov    (%eax),%eax
  800309:	83 f8 ff             	cmp    $0xffffffff,%eax
  80030c:	74 14                	je     800322 <_main+0x2ea>
  80030e:	83 ec 04             	sub    $0x4,%esp
  800311:	68 78 26 80 00       	push   $0x802678
  800316:	6a 40                	push   $0x40
  800318:	68 5c 24 80 00       	push   $0x80245c
  80031d:	e8 b7 01 00 00       	call   8004d9 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800325:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  80032a:	8b 00                	mov    (%eax),%eax
  80032c:	83 f8 ff             	cmp    $0xffffffff,%eax
  80032f:	74 14                	je     800345 <_main+0x30d>
  800331:	83 ec 04             	sub    $0x4,%esp
  800334:	68 78 26 80 00       	push   $0x802678
  800339:	6a 41                	push   $0x41
  80033b:	68 5c 24 80 00       	push   $0x80245c
  800340:	e8 94 01 00 00       	call   8004d9 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 a4 26 80 00       	push   $0x8026a4
  80034d:	e8 29 04 00 00       	call   80077b <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800355:	e8 d0 18 00 00       	call   801c2a <sys_getparentenvid>
  80035a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if(parentenvID > 0)
  80035d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800361:	7e 2b                	jle    80038e <_main+0x356>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800363:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  80036a:	83 ec 08             	sub    $0x8,%esp
  80036d:	68 f8 26 80 00       	push   $0x8026f8
  800372:	ff 75 d8             	pushl  -0x28(%ebp)
  800375:	e8 48 17 00 00       	call   801ac2 <sget>
  80037a:	83 c4 10             	add    $0x10,%esp
  80037d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		(*finishedCount)++ ;
  800380:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800383:	8b 00                	mov    (%eax),%eax
  800385:	8d 50 01             	lea    0x1(%eax),%edx
  800388:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80038b:	89 10                	mov    %edx,(%eax)
	}

	return;
  80038d:	90                   	nop
  80038e:	90                   	nop
}
  80038f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800392:	c9                   	leave  
  800393:	c3                   	ret    

00800394 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80039a:	e8 72 18 00 00       	call   801c11 <sys_getenvindex>
  80039f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003a5:	89 d0                	mov    %edx,%eax
  8003a7:	c1 e0 03             	shl    $0x3,%eax
  8003aa:	01 d0                	add    %edx,%eax
  8003ac:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003b3:	01 c8                	add    %ecx,%eax
  8003b5:	01 c0                	add    %eax,%eax
  8003b7:	01 d0                	add    %edx,%eax
  8003b9:	01 c0                	add    %eax,%eax
  8003bb:	01 d0                	add    %edx,%eax
  8003bd:	89 c2                	mov    %eax,%edx
  8003bf:	c1 e2 05             	shl    $0x5,%edx
  8003c2:	29 c2                	sub    %eax,%edx
  8003c4:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8003cb:	89 c2                	mov    %eax,%edx
  8003cd:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8003d3:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003dd:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8003e3:	84 c0                	test   %al,%al
  8003e5:	74 0f                	je     8003f6 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8003e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ec:	05 40 3c 01 00       	add    $0x13c40,%eax
  8003f1:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003fa:	7e 0a                	jle    800406 <libmain+0x72>
		binaryname = argv[0];
  8003fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ff:	8b 00                	mov    (%eax),%eax
  800401:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	ff 75 0c             	pushl  0xc(%ebp)
  80040c:	ff 75 08             	pushl  0x8(%ebp)
  80040f:	e8 24 fc ff ff       	call   800038 <_main>
  800414:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800417:	e8 90 19 00 00       	call   801dac <sys_disable_interrupt>
	cprintf("**************************************\n");
  80041c:	83 ec 0c             	sub    $0xc,%esp
  80041f:	68 20 27 80 00       	push   $0x802720
  800424:	e8 52 03 00 00       	call   80077b <cprintf>
  800429:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80042c:	a1 20 30 80 00       	mov    0x803020,%eax
  800431:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800437:	a1 20 30 80 00       	mov    0x803020,%eax
  80043c:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	52                   	push   %edx
  800446:	50                   	push   %eax
  800447:	68 48 27 80 00       	push   $0x802748
  80044c:	e8 2a 03 00 00       	call   80077b <cprintf>
  800451:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800454:	a1 20 30 80 00       	mov    0x803020,%eax
  800459:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80045f:	a1 20 30 80 00       	mov    0x803020,%eax
  800464:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80046a:	83 ec 04             	sub    $0x4,%esp
  80046d:	52                   	push   %edx
  80046e:	50                   	push   %eax
  80046f:	68 70 27 80 00       	push   $0x802770
  800474:	e8 02 03 00 00       	call   80077b <cprintf>
  800479:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80047c:	a1 20 30 80 00       	mov    0x803020,%eax
  800481:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800487:	83 ec 08             	sub    $0x8,%esp
  80048a:	50                   	push   %eax
  80048b:	68 b1 27 80 00       	push   $0x8027b1
  800490:	e8 e6 02 00 00       	call   80077b <cprintf>
  800495:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800498:	83 ec 0c             	sub    $0xc,%esp
  80049b:	68 20 27 80 00       	push   $0x802720
  8004a0:	e8 d6 02 00 00       	call   80077b <cprintf>
  8004a5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a8:	e8 19 19 00 00       	call   801dc6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004ad:	e8 19 00 00 00       	call   8004cb <exit>
}
  8004b2:	90                   	nop
  8004b3:	c9                   	leave  
  8004b4:	c3                   	ret    

008004b5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
  8004b8:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8004bb:	83 ec 0c             	sub    $0xc,%esp
  8004be:	6a 00                	push   $0x0
  8004c0:	e8 18 17 00 00       	call   801bdd <sys_env_destroy>
  8004c5:	83 c4 10             	add    $0x10,%esp
}
  8004c8:	90                   	nop
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <exit>:

void
exit(void)
{
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8004d1:	e8 6d 17 00 00       	call   801c43 <sys_env_exit>
}
  8004d6:	90                   	nop
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004df:	8d 45 10             	lea    0x10(%ebp),%eax
  8004e2:	83 c0 04             	add    $0x4,%eax
  8004e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004e8:	a1 18 31 80 00       	mov    0x803118,%eax
  8004ed:	85 c0                	test   %eax,%eax
  8004ef:	74 16                	je     800507 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004f1:	a1 18 31 80 00       	mov    0x803118,%eax
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	50                   	push   %eax
  8004fa:	68 c8 27 80 00       	push   $0x8027c8
  8004ff:	e8 77 02 00 00       	call   80077b <cprintf>
  800504:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800507:	a1 00 30 80 00       	mov    0x803000,%eax
  80050c:	ff 75 0c             	pushl  0xc(%ebp)
  80050f:	ff 75 08             	pushl  0x8(%ebp)
  800512:	50                   	push   %eax
  800513:	68 cd 27 80 00       	push   $0x8027cd
  800518:	e8 5e 02 00 00       	call   80077b <cprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800520:	8b 45 10             	mov    0x10(%ebp),%eax
  800523:	83 ec 08             	sub    $0x8,%esp
  800526:	ff 75 f4             	pushl  -0xc(%ebp)
  800529:	50                   	push   %eax
  80052a:	e8 e1 01 00 00       	call   800710 <vcprintf>
  80052f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	6a 00                	push   $0x0
  800537:	68 e9 27 80 00       	push   $0x8027e9
  80053c:	e8 cf 01 00 00       	call   800710 <vcprintf>
  800541:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800544:	e8 82 ff ff ff       	call   8004cb <exit>

	// should not return here
	while (1) ;
  800549:	eb fe                	jmp    800549 <_panic+0x70>

0080054b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80054b:	55                   	push   %ebp
  80054c:	89 e5                	mov    %esp,%ebp
  80054e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800551:	a1 20 30 80 00       	mov    0x803020,%eax
  800556:	8b 50 74             	mov    0x74(%eax),%edx
  800559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055c:	39 c2                	cmp    %eax,%edx
  80055e:	74 14                	je     800574 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800560:	83 ec 04             	sub    $0x4,%esp
  800563:	68 ec 27 80 00       	push   $0x8027ec
  800568:	6a 26                	push   $0x26
  80056a:	68 38 28 80 00       	push   $0x802838
  80056f:	e8 65 ff ff ff       	call   8004d9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800574:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80057b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800582:	e9 b6 00 00 00       	jmp    80063d <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80058a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	01 d0                	add    %edx,%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	85 c0                	test   %eax,%eax
  80059a:	75 08                	jne    8005a4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80059c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80059f:	e9 96 00 00 00       	jmp    80063a <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8005a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b2:	eb 5d                	jmp    800611 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b9:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8005bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005c2:	c1 e2 04             	shl    $0x4,%edx
  8005c5:	01 d0                	add    %edx,%eax
  8005c7:	8a 40 04             	mov    0x4(%eax),%al
  8005ca:	84 c0                	test   %al,%al
  8005cc:	75 40                	jne    80060e <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8005d3:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8005d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005dc:	c1 e2 04             	shl    $0x4,%edx
  8005df:	01 d0                	add    %edx,%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ee:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	01 c8                	add    %ecx,%eax
  8005ff:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800601:	39 c2                	cmp    %eax,%edx
  800603:	75 09                	jne    80060e <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800605:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80060c:	eb 12                	jmp    800620 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80060e:	ff 45 e8             	incl   -0x18(%ebp)
  800611:	a1 20 30 80 00       	mov    0x803020,%eax
  800616:	8b 50 74             	mov    0x74(%eax),%edx
  800619:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	77 94                	ja     8005b4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800620:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800624:	75 14                	jne    80063a <CheckWSWithoutLastIndex+0xef>
			panic(
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 44 28 80 00       	push   $0x802844
  80062e:	6a 3a                	push   $0x3a
  800630:	68 38 28 80 00       	push   $0x802838
  800635:	e8 9f fe ff ff       	call   8004d9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80063a:	ff 45 f0             	incl   -0x10(%ebp)
  80063d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800640:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800643:	0f 8c 3e ff ff ff    	jl     800587 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800649:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800650:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800657:	eb 20                	jmp    800679 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800659:	a1 20 30 80 00       	mov    0x803020,%eax
  80065e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800664:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800667:	c1 e2 04             	shl    $0x4,%edx
  80066a:	01 d0                	add    %edx,%eax
  80066c:	8a 40 04             	mov    0x4(%eax),%al
  80066f:	3c 01                	cmp    $0x1,%al
  800671:	75 03                	jne    800676 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800673:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800676:	ff 45 e0             	incl   -0x20(%ebp)
  800679:	a1 20 30 80 00       	mov    0x803020,%eax
  80067e:	8b 50 74             	mov    0x74(%eax),%edx
  800681:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800684:	39 c2                	cmp    %eax,%edx
  800686:	77 d1                	ja     800659 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80068e:	74 14                	je     8006a4 <CheckWSWithoutLastIndex+0x159>
		panic(
  800690:	83 ec 04             	sub    $0x4,%esp
  800693:	68 98 28 80 00       	push   $0x802898
  800698:	6a 44                	push   $0x44
  80069a:	68 38 28 80 00       	push   $0x802838
  80069f:	e8 35 fe ff ff       	call   8004d9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006a4:	90                   	nop
  8006a5:	c9                   	leave  
  8006a6:	c3                   	ret    

008006a7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006a7:	55                   	push   %ebp
  8006a8:	89 e5                	mov    %esp,%ebp
  8006aa:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8006b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b8:	89 0a                	mov    %ecx,(%edx)
  8006ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8006bd:	88 d1                	mov    %dl,%cl
  8006bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006d0:	75 2c                	jne    8006fe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006d2:	a0 24 30 80 00       	mov    0x803024,%al
  8006d7:	0f b6 c0             	movzbl %al,%eax
  8006da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006dd:	8b 12                	mov    (%edx),%edx
  8006df:	89 d1                	mov    %edx,%ecx
  8006e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e4:	83 c2 08             	add    $0x8,%edx
  8006e7:	83 ec 04             	sub    $0x4,%esp
  8006ea:	50                   	push   %eax
  8006eb:	51                   	push   %ecx
  8006ec:	52                   	push   %edx
  8006ed:	e8 a9 14 00 00       	call   801b9b <sys_cputs>
  8006f2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800701:	8b 40 04             	mov    0x4(%eax),%eax
  800704:	8d 50 01             	lea    0x1(%eax),%edx
  800707:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80070d:	90                   	nop
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800719:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800720:	00 00 00 
	b.cnt = 0;
  800723:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80072a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80072d:	ff 75 0c             	pushl  0xc(%ebp)
  800730:	ff 75 08             	pushl  0x8(%ebp)
  800733:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800739:	50                   	push   %eax
  80073a:	68 a7 06 80 00       	push   $0x8006a7
  80073f:	e8 11 02 00 00       	call   800955 <vprintfmt>
  800744:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800747:	a0 24 30 80 00       	mov    0x803024,%al
  80074c:	0f b6 c0             	movzbl %al,%eax
  80074f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800755:	83 ec 04             	sub    $0x4,%esp
  800758:	50                   	push   %eax
  800759:	52                   	push   %edx
  80075a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800760:	83 c0 08             	add    $0x8,%eax
  800763:	50                   	push   %eax
  800764:	e8 32 14 00 00       	call   801b9b <sys_cputs>
  800769:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80076c:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800773:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800779:	c9                   	leave  
  80077a:	c3                   	ret    

0080077b <cprintf>:

int cprintf(const char *fmt, ...) {
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800781:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800788:	8d 45 0c             	lea    0xc(%ebp),%eax
  80078b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	ff 75 f4             	pushl  -0xc(%ebp)
  800797:	50                   	push   %eax
  800798:	e8 73 ff ff ff       	call   800710 <vcprintf>
  80079d:	83 c4 10             	add    $0x10,%esp
  8007a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a6:	c9                   	leave  
  8007a7:	c3                   	ret    

008007a8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007ae:	e8 f9 15 00 00       	call   801dac <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	e8 48 ff ff ff       	call   800710 <vcprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007ce:	e8 f3 15 00 00       	call   801dc6 <sys_enable_interrupt>
	return cnt;
  8007d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d6:	c9                   	leave  
  8007d7:	c3                   	ret    

008007d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	53                   	push   %ebx
  8007dc:	83 ec 14             	sub    $0x14,%esp
  8007df:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f6:	77 55                	ja     80084d <printnum+0x75>
  8007f8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007fb:	72 05                	jb     800802 <printnum+0x2a>
  8007fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800800:	77 4b                	ja     80084d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800802:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800805:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800808:	8b 45 18             	mov    0x18(%ebp),%eax
  80080b:	ba 00 00 00 00       	mov    $0x0,%edx
  800810:	52                   	push   %edx
  800811:	50                   	push   %eax
  800812:	ff 75 f4             	pushl  -0xc(%ebp)
  800815:	ff 75 f0             	pushl  -0x10(%ebp)
  800818:	e8 b3 19 00 00       	call   8021d0 <__udivdi3>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	83 ec 04             	sub    $0x4,%esp
  800823:	ff 75 20             	pushl  0x20(%ebp)
  800826:	53                   	push   %ebx
  800827:	ff 75 18             	pushl  0x18(%ebp)
  80082a:	52                   	push   %edx
  80082b:	50                   	push   %eax
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	ff 75 08             	pushl  0x8(%ebp)
  800832:	e8 a1 ff ff ff       	call   8007d8 <printnum>
  800837:	83 c4 20             	add    $0x20,%esp
  80083a:	eb 1a                	jmp    800856 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	ff 75 20             	pushl  0x20(%ebp)
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	ff d0                	call   *%eax
  80084a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80084d:	ff 4d 1c             	decl   0x1c(%ebp)
  800850:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800854:	7f e6                	jg     80083c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800856:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800859:	bb 00 00 00 00       	mov    $0x0,%ebx
  80085e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800861:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800864:	53                   	push   %ebx
  800865:	51                   	push   %ecx
  800866:	52                   	push   %edx
  800867:	50                   	push   %eax
  800868:	e8 73 1a 00 00       	call   8022e0 <__umoddi3>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	05 14 2b 80 00       	add    $0x802b14,%eax
  800875:	8a 00                	mov    (%eax),%al
  800877:	0f be c0             	movsbl %al,%eax
  80087a:	83 ec 08             	sub    $0x8,%esp
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	50                   	push   %eax
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	ff d0                	call   *%eax
  800886:	83 c4 10             	add    $0x10,%esp
}
  800889:	90                   	nop
  80088a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    

0080088f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800892:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800896:	7e 1c                	jle    8008b4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	8b 00                	mov    (%eax),%eax
  80089d:	8d 50 08             	lea    0x8(%eax),%edx
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	89 10                	mov    %edx,(%eax)
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	83 e8 08             	sub    $0x8,%eax
  8008ad:	8b 50 04             	mov    0x4(%eax),%edx
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	eb 40                	jmp    8008f4 <getuint+0x65>
	else if (lflag)
  8008b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b8:	74 1e                	je     8008d8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	8d 50 04             	lea    0x4(%eax),%edx
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	89 10                	mov    %edx,(%eax)
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	83 e8 04             	sub    $0x4,%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d6:	eb 1c                	jmp    8008f4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	8d 50 04             	lea    0x4(%eax),%edx
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	89 10                	mov    %edx,(%eax)
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	83 e8 04             	sub    $0x4,%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008f9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008fd:	7e 1c                	jle    80091b <getint+0x25>
		return va_arg(*ap, long long);
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	8d 50 08             	lea    0x8(%eax),%edx
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	89 10                	mov    %edx,(%eax)
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	83 e8 08             	sub    $0x8,%eax
  800914:	8b 50 04             	mov    0x4(%eax),%edx
  800917:	8b 00                	mov    (%eax),%eax
  800919:	eb 38                	jmp    800953 <getint+0x5d>
	else if (lflag)
  80091b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80091f:	74 1a                	je     80093b <getint+0x45>
		return va_arg(*ap, long);
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	8b 00                	mov    (%eax),%eax
  800926:	8d 50 04             	lea    0x4(%eax),%edx
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	89 10                	mov    %edx,(%eax)
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 00                	mov    (%eax),%eax
  800933:	83 e8 04             	sub    $0x4,%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	99                   	cltd   
  800939:	eb 18                	jmp    800953 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	8d 50 04             	lea    0x4(%eax),%edx
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	89 10                	mov    %edx,(%eax)
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	83 e8 04             	sub    $0x4,%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	99                   	cltd   
}
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	56                   	push   %esi
  800959:	53                   	push   %ebx
  80095a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80095d:	eb 17                	jmp    800976 <vprintfmt+0x21>
			if (ch == '\0')
  80095f:	85 db                	test   %ebx,%ebx
  800961:	0f 84 af 03 00 00    	je     800d16 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	53                   	push   %ebx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	ff d0                	call   *%eax
  800973:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800976:	8b 45 10             	mov    0x10(%ebp),%eax
  800979:	8d 50 01             	lea    0x1(%eax),%edx
  80097c:	89 55 10             	mov    %edx,0x10(%ebp)
  80097f:	8a 00                	mov    (%eax),%al
  800981:	0f b6 d8             	movzbl %al,%ebx
  800984:	83 fb 25             	cmp    $0x25,%ebx
  800987:	75 d6                	jne    80095f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800989:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80098d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800994:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80099b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ac:	8d 50 01             	lea    0x1(%eax),%edx
  8009af:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b2:	8a 00                	mov    (%eax),%al
  8009b4:	0f b6 d8             	movzbl %al,%ebx
  8009b7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ba:	83 f8 55             	cmp    $0x55,%eax
  8009bd:	0f 87 2b 03 00 00    	ja     800cee <vprintfmt+0x399>
  8009c3:	8b 04 85 38 2b 80 00 	mov    0x802b38(,%eax,4),%eax
  8009ca:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009cc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009d0:	eb d7                	jmp    8009a9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009d2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009d6:	eb d1                	jmp    8009a9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009e2:	89 d0                	mov    %edx,%eax
  8009e4:	c1 e0 02             	shl    $0x2,%eax
  8009e7:	01 d0                	add    %edx,%eax
  8009e9:	01 c0                	add    %eax,%eax
  8009eb:	01 d8                	add    %ebx,%eax
  8009ed:	83 e8 30             	sub    $0x30,%eax
  8009f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f6:	8a 00                	mov    (%eax),%al
  8009f8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009fb:	83 fb 2f             	cmp    $0x2f,%ebx
  8009fe:	7e 3e                	jle    800a3e <vprintfmt+0xe9>
  800a00:	83 fb 39             	cmp    $0x39,%ebx
  800a03:	7f 39                	jg     800a3e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a05:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a08:	eb d5                	jmp    8009df <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0d:	83 c0 04             	add    $0x4,%eax
  800a10:	89 45 14             	mov    %eax,0x14(%ebp)
  800a13:	8b 45 14             	mov    0x14(%ebp),%eax
  800a16:	83 e8 04             	sub    $0x4,%eax
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a1e:	eb 1f                	jmp    800a3f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a20:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a24:	79 83                	jns    8009a9 <vprintfmt+0x54>
				width = 0;
  800a26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a2d:	e9 77 ff ff ff       	jmp    8009a9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a32:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a39:	e9 6b ff ff ff       	jmp    8009a9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a3e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a43:	0f 89 60 ff ff ff    	jns    8009a9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a4f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a56:	e9 4e ff ff ff       	jmp    8009a9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a5b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a5e:	e9 46 ff ff ff       	jmp    8009a9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	83 c0 04             	add    $0x4,%eax
  800a69:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	83 e8 04             	sub    $0x4,%eax
  800a72:	8b 00                	mov    (%eax),%eax
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	50                   	push   %eax
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	ff d0                	call   *%eax
  800a80:	83 c4 10             	add    $0x10,%esp
			break;
  800a83:	e9 89 02 00 00       	jmp    800d11 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	83 c0 04             	add    $0x4,%eax
  800a8e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a91:	8b 45 14             	mov    0x14(%ebp),%eax
  800a94:	83 e8 04             	sub    $0x4,%eax
  800a97:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a99:	85 db                	test   %ebx,%ebx
  800a9b:	79 02                	jns    800a9f <vprintfmt+0x14a>
				err = -err;
  800a9d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a9f:	83 fb 64             	cmp    $0x64,%ebx
  800aa2:	7f 0b                	jg     800aaf <vprintfmt+0x15a>
  800aa4:	8b 34 9d 80 29 80 00 	mov    0x802980(,%ebx,4),%esi
  800aab:	85 f6                	test   %esi,%esi
  800aad:	75 19                	jne    800ac8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aaf:	53                   	push   %ebx
  800ab0:	68 25 2b 80 00       	push   $0x802b25
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	ff 75 08             	pushl  0x8(%ebp)
  800abb:	e8 5e 02 00 00       	call   800d1e <printfmt>
  800ac0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ac3:	e9 49 02 00 00       	jmp    800d11 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ac8:	56                   	push   %esi
  800ac9:	68 2e 2b 80 00       	push   $0x802b2e
  800ace:	ff 75 0c             	pushl  0xc(%ebp)
  800ad1:	ff 75 08             	pushl  0x8(%ebp)
  800ad4:	e8 45 02 00 00       	call   800d1e <printfmt>
  800ad9:	83 c4 10             	add    $0x10,%esp
			break;
  800adc:	e9 30 02 00 00       	jmp    800d11 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae4:	83 c0 04             	add    $0x4,%eax
  800ae7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	83 e8 04             	sub    $0x4,%eax
  800af0:	8b 30                	mov    (%eax),%esi
  800af2:	85 f6                	test   %esi,%esi
  800af4:	75 05                	jne    800afb <vprintfmt+0x1a6>
				p = "(null)";
  800af6:	be 31 2b 80 00       	mov    $0x802b31,%esi
			if (width > 0 && padc != '-')
  800afb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aff:	7e 6d                	jle    800b6e <vprintfmt+0x219>
  800b01:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b05:	74 67                	je     800b6e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b0a:	83 ec 08             	sub    $0x8,%esp
  800b0d:	50                   	push   %eax
  800b0e:	56                   	push   %esi
  800b0f:	e8 0c 03 00 00       	call   800e20 <strnlen>
  800b14:	83 c4 10             	add    $0x10,%esp
  800b17:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b1a:	eb 16                	jmp    800b32 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b1c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b20:	83 ec 08             	sub    $0x8,%esp
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	50                   	push   %eax
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	ff d0                	call   *%eax
  800b2c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b36:	7f e4                	jg     800b1c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b38:	eb 34                	jmp    800b6e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b3e:	74 1c                	je     800b5c <vprintfmt+0x207>
  800b40:	83 fb 1f             	cmp    $0x1f,%ebx
  800b43:	7e 05                	jle    800b4a <vprintfmt+0x1f5>
  800b45:	83 fb 7e             	cmp    $0x7e,%ebx
  800b48:	7e 12                	jle    800b5c <vprintfmt+0x207>
					putch('?', putdat);
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	6a 3f                	push   $0x3f
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
  800b5a:	eb 0f                	jmp    800b6b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	53                   	push   %ebx
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	ff d0                	call   *%eax
  800b68:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b6e:	89 f0                	mov    %esi,%eax
  800b70:	8d 70 01             	lea    0x1(%eax),%esi
  800b73:	8a 00                	mov    (%eax),%al
  800b75:	0f be d8             	movsbl %al,%ebx
  800b78:	85 db                	test   %ebx,%ebx
  800b7a:	74 24                	je     800ba0 <vprintfmt+0x24b>
  800b7c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b80:	78 b8                	js     800b3a <vprintfmt+0x1e5>
  800b82:	ff 4d e0             	decl   -0x20(%ebp)
  800b85:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b89:	79 af                	jns    800b3a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b8b:	eb 13                	jmp    800ba0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	ff 75 0c             	pushl  0xc(%ebp)
  800b93:	6a 20                	push   $0x20
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	ff d0                	call   *%eax
  800b9a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9d:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ba4:	7f e7                	jg     800b8d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ba6:	e9 66 01 00 00       	jmp    800d11 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	ff 75 e8             	pushl  -0x18(%ebp)
  800bb1:	8d 45 14             	lea    0x14(%ebp),%eax
  800bb4:	50                   	push   %eax
  800bb5:	e8 3c fd ff ff       	call   8008f6 <getint>
  800bba:	83 c4 10             	add    $0x10,%esp
  800bbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc9:	85 d2                	test   %edx,%edx
  800bcb:	79 23                	jns    800bf0 <vprintfmt+0x29b>
				putch('-', putdat);
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	6a 2d                	push   $0x2d
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	ff d0                	call   *%eax
  800bda:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be3:	f7 d8                	neg    %eax
  800be5:	83 d2 00             	adc    $0x0,%edx
  800be8:	f7 da                	neg    %edx
  800bea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bf0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf7:	e9 bc 00 00 00       	jmp    800cb8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bfc:	83 ec 08             	sub    $0x8,%esp
  800bff:	ff 75 e8             	pushl  -0x18(%ebp)
  800c02:	8d 45 14             	lea    0x14(%ebp),%eax
  800c05:	50                   	push   %eax
  800c06:	e8 84 fc ff ff       	call   80088f <getuint>
  800c0b:	83 c4 10             	add    $0x10,%esp
  800c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c11:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c14:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c1b:	e9 98 00 00 00       	jmp    800cb8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	6a 58                	push   $0x58
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c30:	83 ec 08             	sub    $0x8,%esp
  800c33:	ff 75 0c             	pushl  0xc(%ebp)
  800c36:	6a 58                	push   $0x58
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	ff d0                	call   *%eax
  800c3d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c40:	83 ec 08             	sub    $0x8,%esp
  800c43:	ff 75 0c             	pushl  0xc(%ebp)
  800c46:	6a 58                	push   $0x58
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	ff d0                	call   *%eax
  800c4d:	83 c4 10             	add    $0x10,%esp
			break;
  800c50:	e9 bc 00 00 00       	jmp    800d11 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c55:	83 ec 08             	sub    $0x8,%esp
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	6a 30                	push   $0x30
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	ff d0                	call   *%eax
  800c62:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	ff 75 0c             	pushl  0xc(%ebp)
  800c6b:	6a 78                	push   $0x78
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	ff d0                	call   *%eax
  800c72:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c75:	8b 45 14             	mov    0x14(%ebp),%eax
  800c78:	83 c0 04             	add    $0x4,%eax
  800c7b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c81:	83 e8 04             	sub    $0x4,%eax
  800c84:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c90:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c97:	eb 1f                	jmp    800cb8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c99:	83 ec 08             	sub    $0x8,%esp
  800c9c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c9f:	8d 45 14             	lea    0x14(%ebp),%eax
  800ca2:	50                   	push   %eax
  800ca3:	e8 e7 fb ff ff       	call   80088f <getuint>
  800ca8:	83 c4 10             	add    $0x10,%esp
  800cab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cb1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cb8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cbf:	83 ec 04             	sub    $0x4,%esp
  800cc2:	52                   	push   %edx
  800cc3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cc6:	50                   	push   %eax
  800cc7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cca:	ff 75 f0             	pushl  -0x10(%ebp)
  800ccd:	ff 75 0c             	pushl  0xc(%ebp)
  800cd0:	ff 75 08             	pushl  0x8(%ebp)
  800cd3:	e8 00 fb ff ff       	call   8007d8 <printnum>
  800cd8:	83 c4 20             	add    $0x20,%esp
			break;
  800cdb:	eb 34                	jmp    800d11 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cdd:	83 ec 08             	sub    $0x8,%esp
  800ce0:	ff 75 0c             	pushl  0xc(%ebp)
  800ce3:	53                   	push   %ebx
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	ff d0                	call   *%eax
  800ce9:	83 c4 10             	add    $0x10,%esp
			break;
  800cec:	eb 23                	jmp    800d11 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cee:	83 ec 08             	sub    $0x8,%esp
  800cf1:	ff 75 0c             	pushl  0xc(%ebp)
  800cf4:	6a 25                	push   $0x25
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	ff d0                	call   *%eax
  800cfb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cfe:	ff 4d 10             	decl   0x10(%ebp)
  800d01:	eb 03                	jmp    800d06 <vprintfmt+0x3b1>
  800d03:	ff 4d 10             	decl   0x10(%ebp)
  800d06:	8b 45 10             	mov    0x10(%ebp),%eax
  800d09:	48                   	dec    %eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	3c 25                	cmp    $0x25,%al
  800d0e:	75 f3                	jne    800d03 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d10:	90                   	nop
		}
	}
  800d11:	e9 47 fc ff ff       	jmp    80095d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d16:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d1a:	5b                   	pop    %ebx
  800d1b:	5e                   	pop    %esi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d24:	8d 45 10             	lea    0x10(%ebp),%eax
  800d27:	83 c0 04             	add    $0x4,%eax
  800d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d30:	ff 75 f4             	pushl  -0xc(%ebp)
  800d33:	50                   	push   %eax
  800d34:	ff 75 0c             	pushl  0xc(%ebp)
  800d37:	ff 75 08             	pushl  0x8(%ebp)
  800d3a:	e8 16 fc ff ff       	call   800955 <vprintfmt>
  800d3f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d42:	90                   	nop
  800d43:	c9                   	leave  
  800d44:	c3                   	ret    

00800d45 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4b:	8b 40 08             	mov    0x8(%eax),%eax
  800d4e:	8d 50 01             	lea    0x1(%eax),%edx
  800d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d54:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8b 10                	mov    (%eax),%edx
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8b 40 04             	mov    0x4(%eax),%eax
  800d62:	39 c2                	cmp    %eax,%edx
  800d64:	73 12                	jae    800d78 <sprintputch+0x33>
		*b->buf++ = ch;
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	8b 00                	mov    (%eax),%eax
  800d6b:	8d 48 01             	lea    0x1(%eax),%ecx
  800d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d71:	89 0a                	mov    %ecx,(%edx)
  800d73:	8b 55 08             	mov    0x8(%ebp),%edx
  800d76:	88 10                	mov    %dl,(%eax)
}
  800d78:	90                   	nop
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	01 d0                	add    %edx,%eax
  800d92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800da0:	74 06                	je     800da8 <vsnprintf+0x2d>
  800da2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da6:	7f 07                	jg     800daf <vsnprintf+0x34>
		return -E_INVAL;
  800da8:	b8 03 00 00 00       	mov    $0x3,%eax
  800dad:	eb 20                	jmp    800dcf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800daf:	ff 75 14             	pushl  0x14(%ebp)
  800db2:	ff 75 10             	pushl  0x10(%ebp)
  800db5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800db8:	50                   	push   %eax
  800db9:	68 45 0d 80 00       	push   $0x800d45
  800dbe:	e8 92 fb ff ff       	call   800955 <vprintfmt>
  800dc3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dc9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dcf:	c9                   	leave  
  800dd0:	c3                   	ret    

00800dd1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dd7:	8d 45 10             	lea    0x10(%ebp),%eax
  800dda:	83 c0 04             	add    $0x4,%eax
  800ddd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800de0:	8b 45 10             	mov    0x10(%ebp),%eax
  800de3:	ff 75 f4             	pushl  -0xc(%ebp)
  800de6:	50                   	push   %eax
  800de7:	ff 75 0c             	pushl  0xc(%ebp)
  800dea:	ff 75 08             	pushl  0x8(%ebp)
  800ded:	e8 89 ff ff ff       	call   800d7b <vsnprintf>
  800df2:	83 c4 10             	add    $0x10,%esp
  800df5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dfb:	c9                   	leave  
  800dfc:	c3                   	ret    

00800dfd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e0a:	eb 06                	jmp    800e12 <strlen+0x15>
		n++;
  800e0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0f:	ff 45 08             	incl   0x8(%ebp)
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	8a 00                	mov    (%eax),%al
  800e17:	84 c0                	test   %al,%al
  800e19:	75 f1                	jne    800e0c <strlen+0xf>
		n++;
	return n;
  800e1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2d:	eb 09                	jmp    800e38 <strnlen+0x18>
		n++;
  800e2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e32:	ff 45 08             	incl   0x8(%ebp)
  800e35:	ff 4d 0c             	decl   0xc(%ebp)
  800e38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e3c:	74 09                	je     800e47 <strnlen+0x27>
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	75 e8                	jne    800e2f <strnlen+0xf>
		n++;
	return n;
  800e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e58:	90                   	nop
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8d 50 01             	lea    0x1(%eax),%edx
  800e5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e6b:	8a 12                	mov    (%edx),%dl
  800e6d:	88 10                	mov    %dl,(%eax)
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	84 c0                	test   %al,%al
  800e73:	75 e4                	jne    800e59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8d:	eb 1f                	jmp    800eae <strncpy+0x34>
		*dst++ = *src;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8d 50 01             	lea    0x1(%eax),%edx
  800e95:	89 55 08             	mov    %edx,0x8(%ebp)
  800e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9b:	8a 12                	mov    (%edx),%dl
  800e9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	84 c0                	test   %al,%al
  800ea6:	74 03                	je     800eab <strncpy+0x31>
			src++;
  800ea8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eab:	ff 45 fc             	incl   -0x4(%ebp)
  800eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800eb4:	72 d9                	jb     800e8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eb9:	c9                   	leave  
  800eba:	c3                   	ret    

00800ebb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ec7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecb:	74 30                	je     800efd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ecd:	eb 16                	jmp    800ee5 <strlcpy+0x2a>
			*dst++ = *src++;
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	8d 50 01             	lea    0x1(%eax),%edx
  800ed5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800edb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ede:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ee1:	8a 12                	mov    (%edx),%dl
  800ee3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ee5:	ff 4d 10             	decl   0x10(%ebp)
  800ee8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eec:	74 09                	je     800ef7 <strlcpy+0x3c>
  800eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	84 c0                	test   %al,%al
  800ef5:	75 d8                	jne    800ecf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800efd:	8b 55 08             	mov    0x8(%ebp),%edx
  800f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f03:	29 c2                	sub    %eax,%edx
  800f05:	89 d0                	mov    %edx,%eax
}
  800f07:	c9                   	leave  
  800f08:	c3                   	ret    

00800f09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f0c:	eb 06                	jmp    800f14 <strcmp+0xb>
		p++, q++;
  800f0e:	ff 45 08             	incl   0x8(%ebp)
  800f11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	8a 00                	mov    (%eax),%al
  800f19:	84 c0                	test   %al,%al
  800f1b:	74 0e                	je     800f2b <strcmp+0x22>
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8a 10                	mov    (%eax),%dl
  800f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	38 c2                	cmp    %al,%dl
  800f29:	74 e3                	je     800f0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	8a 00                	mov    (%eax),%al
  800f30:	0f b6 d0             	movzbl %al,%edx
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	0f b6 c0             	movzbl %al,%eax
  800f3b:	29 c2                	sub    %eax,%edx
  800f3d:	89 d0                	mov    %edx,%eax
}
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    

00800f41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f44:	eb 09                	jmp    800f4f <strncmp+0xe>
		n--, p++, q++;
  800f46:	ff 4d 10             	decl   0x10(%ebp)
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f53:	74 17                	je     800f6c <strncmp+0x2b>
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	84 c0                	test   %al,%al
  800f5c:	74 0e                	je     800f6c <strncmp+0x2b>
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 10                	mov    (%eax),%dl
  800f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	38 c2                	cmp    %al,%dl
  800f6a:	74 da                	je     800f46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f70:	75 07                	jne    800f79 <strncmp+0x38>
		return 0;
  800f72:	b8 00 00 00 00       	mov    $0x0,%eax
  800f77:	eb 14                	jmp    800f8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	0f b6 d0             	movzbl %al,%edx
  800f81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	0f b6 c0             	movzbl %al,%eax
  800f89:	29 c2                	sub    %eax,%edx
  800f8b:	89 d0                	mov    %edx,%eax
}
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    

00800f8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	83 ec 04             	sub    $0x4,%esp
  800f95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f9b:	eb 12                	jmp    800faf <strchr+0x20>
		if (*s == c)
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa5:	75 05                	jne    800fac <strchr+0x1d>
			return (char *) s;
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	eb 11                	jmp    800fbd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fac:	ff 45 08             	incl   0x8(%ebp)
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	84 c0                	test   %al,%al
  800fb6:	75 e5                	jne    800f9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fbd:	c9                   	leave  
  800fbe:	c3                   	ret    

00800fbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	83 ec 04             	sub    $0x4,%esp
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fcb:	eb 0d                	jmp    800fda <strfind+0x1b>
		if (*s == c)
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd5:	74 0e                	je     800fe5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fd7:	ff 45 08             	incl   0x8(%ebp)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	75 ea                	jne    800fcd <strfind+0xe>
  800fe3:	eb 01                	jmp    800fe6 <strfind+0x27>
		if (*s == c)
			break;
  800fe5:	90                   	nop
	return (char *) s;
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ffd:	eb 0e                	jmp    80100d <memset+0x22>
		*p++ = c;
  800fff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801002:	8d 50 01             	lea    0x1(%eax),%edx
  801005:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801008:	8b 55 0c             	mov    0xc(%ebp),%edx
  80100b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80100d:	ff 4d f8             	decl   -0x8(%ebp)
  801010:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801014:	79 e9                	jns    800fff <memset+0x14>
		*p++ = c;

	return v;
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801019:	c9                   	leave  
  80101a:	c3                   	ret    

0080101b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80102d:	eb 16                	jmp    801045 <memcpy+0x2a>
		*d++ = *s++;
  80102f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801032:	8d 50 01             	lea    0x1(%eax),%edx
  801035:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801038:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80103b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80103e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801041:	8a 12                	mov    (%edx),%dl
  801043:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801045:	8b 45 10             	mov    0x10(%ebp),%eax
  801048:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104b:	89 55 10             	mov    %edx,0x10(%ebp)
  80104e:	85 c0                	test   %eax,%eax
  801050:	75 dd                	jne    80102f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801055:	c9                   	leave  
  801056:	c3                   	ret    

00801057 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80105d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801069:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80106f:	73 50                	jae    8010c1 <memmove+0x6a>
  801071:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801074:	8b 45 10             	mov    0x10(%ebp),%eax
  801077:	01 d0                	add    %edx,%eax
  801079:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107c:	76 43                	jbe    8010c1 <memmove+0x6a>
		s += n;
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801084:	8b 45 10             	mov    0x10(%ebp),%eax
  801087:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80108a:	eb 10                	jmp    80109c <memmove+0x45>
			*--d = *--s;
  80108c:	ff 4d f8             	decl   -0x8(%ebp)
  80108f:	ff 4d fc             	decl   -0x4(%ebp)
  801092:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801095:	8a 10                	mov    (%eax),%dl
  801097:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80109c:	8b 45 10             	mov    0x10(%ebp),%eax
  80109f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	75 e3                	jne    80108c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010a9:	eb 23                	jmp    8010ce <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ae:	8d 50 01             	lea    0x1(%eax),%edx
  8010b1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010bd:	8a 12                	mov    (%edx),%dl
  8010bf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ca:	85 c0                	test   %eax,%eax
  8010cc:	75 dd                	jne    8010ab <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010e5:	eb 2a                	jmp    801111 <memcmp+0x3e>
		if (*s1 != *s2)
  8010e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ea:	8a 10                	mov    (%eax),%dl
  8010ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	38 c2                	cmp    %al,%dl
  8010f3:	74 16                	je     80110b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	0f b6 d0             	movzbl %al,%edx
  8010fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801100:	8a 00                	mov    (%eax),%al
  801102:	0f b6 c0             	movzbl %al,%eax
  801105:	29 c2                	sub    %eax,%edx
  801107:	89 d0                	mov    %edx,%eax
  801109:	eb 18                	jmp    801123 <memcmp+0x50>
		s1++, s2++;
  80110b:	ff 45 fc             	incl   -0x4(%ebp)
  80110e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801111:	8b 45 10             	mov    0x10(%ebp),%eax
  801114:	8d 50 ff             	lea    -0x1(%eax),%edx
  801117:	89 55 10             	mov    %edx,0x10(%ebp)
  80111a:	85 c0                	test   %eax,%eax
  80111c:	75 c9                	jne    8010e7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80111e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801123:	c9                   	leave  
  801124:	c3                   	ret    

00801125 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80112b:	8b 55 08             	mov    0x8(%ebp),%edx
  80112e:	8b 45 10             	mov    0x10(%ebp),%eax
  801131:	01 d0                	add    %edx,%eax
  801133:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801136:	eb 15                	jmp    80114d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	0f b6 d0             	movzbl %al,%edx
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	0f b6 c0             	movzbl %al,%eax
  801146:	39 c2                	cmp    %eax,%edx
  801148:	74 0d                	je     801157 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80114a:	ff 45 08             	incl   0x8(%ebp)
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801153:	72 e3                	jb     801138 <memfind+0x13>
  801155:	eb 01                	jmp    801158 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801157:	90                   	nop
	return (void *) s;
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80115b:	c9                   	leave  
  80115c:	c3                   	ret    

0080115d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801163:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80116a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801171:	eb 03                	jmp    801176 <strtol+0x19>
		s++;
  801173:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 20                	cmp    $0x20,%al
  80117d:	74 f4                	je     801173 <strtol+0x16>
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	3c 09                	cmp    $0x9,%al
  801186:	74 eb                	je     801173 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	3c 2b                	cmp    $0x2b,%al
  80118f:	75 05                	jne    801196 <strtol+0x39>
		s++;
  801191:	ff 45 08             	incl   0x8(%ebp)
  801194:	eb 13                	jmp    8011a9 <strtol+0x4c>
	else if (*s == '-')
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	3c 2d                	cmp    $0x2d,%al
  80119d:	75 0a                	jne    8011a9 <strtol+0x4c>
		s++, neg = 1;
  80119f:	ff 45 08             	incl   0x8(%ebp)
  8011a2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ad:	74 06                	je     8011b5 <strtol+0x58>
  8011af:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011b3:	75 20                	jne    8011d5 <strtol+0x78>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	3c 30                	cmp    $0x30,%al
  8011bc:	75 17                	jne    8011d5 <strtol+0x78>
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	40                   	inc    %eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	3c 78                	cmp    $0x78,%al
  8011c6:	75 0d                	jne    8011d5 <strtol+0x78>
		s += 2, base = 16;
  8011c8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011cc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011d3:	eb 28                	jmp    8011fd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d9:	75 15                	jne    8011f0 <strtol+0x93>
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	3c 30                	cmp    $0x30,%al
  8011e2:	75 0c                	jne    8011f0 <strtol+0x93>
		s++, base = 8;
  8011e4:	ff 45 08             	incl   0x8(%ebp)
  8011e7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011ee:	eb 0d                	jmp    8011fd <strtol+0xa0>
	else if (base == 0)
  8011f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f4:	75 07                	jne    8011fd <strtol+0xa0>
		base = 10;
  8011f6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	3c 2f                	cmp    $0x2f,%al
  801204:	7e 19                	jle    80121f <strtol+0xc2>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 39                	cmp    $0x39,%al
  80120d:	7f 10                	jg     80121f <strtol+0xc2>
			dig = *s - '0';
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	8a 00                	mov    (%eax),%al
  801214:	0f be c0             	movsbl %al,%eax
  801217:	83 e8 30             	sub    $0x30,%eax
  80121a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121d:	eb 42                	jmp    801261 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	3c 60                	cmp    $0x60,%al
  801226:	7e 19                	jle    801241 <strtol+0xe4>
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 7a                	cmp    $0x7a,%al
  80122f:	7f 10                	jg     801241 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	0f be c0             	movsbl %al,%eax
  801239:	83 e8 57             	sub    $0x57,%eax
  80123c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123f:	eb 20                	jmp    801261 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	3c 40                	cmp    $0x40,%al
  801248:	7e 39                	jle    801283 <strtol+0x126>
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	3c 5a                	cmp    $0x5a,%al
  801251:	7f 30                	jg     801283 <strtol+0x126>
			dig = *s - 'A' + 10;
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	0f be c0             	movsbl %al,%eax
  80125b:	83 e8 37             	sub    $0x37,%eax
  80125e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801264:	3b 45 10             	cmp    0x10(%ebp),%eax
  801267:	7d 19                	jge    801282 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801269:	ff 45 08             	incl   0x8(%ebp)
  80126c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801273:	89 c2                	mov    %eax,%edx
  801275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801278:	01 d0                	add    %edx,%eax
  80127a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80127d:	e9 7b ff ff ff       	jmp    8011fd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801282:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801283:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801287:	74 08                	je     801291 <strtol+0x134>
		*endptr = (char *) s;
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128c:	8b 55 08             	mov    0x8(%ebp),%edx
  80128f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801291:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801295:	74 07                	je     80129e <strtol+0x141>
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	f7 d8                	neg    %eax
  80129c:	eb 03                	jmp    8012a1 <strtol+0x144>
  80129e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <ltostr>:

void
ltostr(long value, char *str)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012bb:	79 13                	jns    8012d0 <ltostr+0x2d>
	{
		neg = 1;
  8012bd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012ca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012cd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012d8:	99                   	cltd   
  8012d9:	f7 f9                	idiv   %ecx
  8012db:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e1:	8d 50 01             	lea    0x1(%eax),%edx
  8012e4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012e7:	89 c2                	mov    %eax,%edx
  8012e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012f1:	83 c2 30             	add    $0x30,%edx
  8012f4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012fe:	f7 e9                	imul   %ecx
  801300:	c1 fa 02             	sar    $0x2,%edx
  801303:	89 c8                	mov    %ecx,%eax
  801305:	c1 f8 1f             	sar    $0x1f,%eax
  801308:	29 c2                	sub    %eax,%edx
  80130a:	89 d0                	mov    %edx,%eax
  80130c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80130f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801312:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801317:	f7 e9                	imul   %ecx
  801319:	c1 fa 02             	sar    $0x2,%edx
  80131c:	89 c8                	mov    %ecx,%eax
  80131e:	c1 f8 1f             	sar    $0x1f,%eax
  801321:	29 c2                	sub    %eax,%edx
  801323:	89 d0                	mov    %edx,%eax
  801325:	c1 e0 02             	shl    $0x2,%eax
  801328:	01 d0                	add    %edx,%eax
  80132a:	01 c0                	add    %eax,%eax
  80132c:	29 c1                	sub    %eax,%ecx
  80132e:	89 ca                	mov    %ecx,%edx
  801330:	85 d2                	test   %edx,%edx
  801332:	75 9c                	jne    8012d0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801334:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80133b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133e:	48                   	dec    %eax
  80133f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801342:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801346:	74 3d                	je     801385 <ltostr+0xe2>
		start = 1 ;
  801348:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80134f:	eb 34                	jmp    801385 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801351:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	01 d0                	add    %edx,%eax
  801359:	8a 00                	mov    (%eax),%al
  80135b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80135e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	01 c2                	add    %eax,%edx
  801366:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	01 c8                	add    %ecx,%eax
  80136e:	8a 00                	mov    (%eax),%al
  801370:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801372:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	01 c2                	add    %eax,%edx
  80137a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80137d:	88 02                	mov    %al,(%edx)
		start++ ;
  80137f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801382:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801388:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80138b:	7c c4                	jl     801351 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80138d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801390:	8b 45 0c             	mov    0xc(%ebp),%eax
  801393:	01 d0                	add    %edx,%eax
  801395:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801398:	90                   	nop
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013a1:	ff 75 08             	pushl  0x8(%ebp)
  8013a4:	e8 54 fa ff ff       	call   800dfd <strlen>
  8013a9:	83 c4 04             	add    $0x4,%esp
  8013ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013af:	ff 75 0c             	pushl  0xc(%ebp)
  8013b2:	e8 46 fa ff ff       	call   800dfd <strlen>
  8013b7:	83 c4 04             	add    $0x4,%esp
  8013ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013cb:	eb 17                	jmp    8013e4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d3:	01 c2                	add    %eax,%edx
  8013d5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	01 c8                	add    %ecx,%eax
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013e1:	ff 45 fc             	incl   -0x4(%ebp)
  8013e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ea:	7c e1                	jl     8013cd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013fa:	eb 1f                	jmp    80141b <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ff:	8d 50 01             	lea    0x1(%eax),%edx
  801402:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801405:	89 c2                	mov    %eax,%edx
  801407:	8b 45 10             	mov    0x10(%ebp),%eax
  80140a:	01 c2                	add    %eax,%edx
  80140c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80140f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801412:	01 c8                	add    %ecx,%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801418:	ff 45 f8             	incl   -0x8(%ebp)
  80141b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80141e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801421:	7c d9                	jl     8013fc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801423:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801426:	8b 45 10             	mov    0x10(%ebp),%eax
  801429:	01 d0                	add    %edx,%eax
  80142b:	c6 00 00             	movb   $0x0,(%eax)
}
  80142e:	90                   	nop
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801434:	8b 45 14             	mov    0x14(%ebp),%eax
  801437:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80143d:	8b 45 14             	mov    0x14(%ebp),%eax
  801440:	8b 00                	mov    (%eax),%eax
  801442:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801449:	8b 45 10             	mov    0x10(%ebp),%eax
  80144c:	01 d0                	add    %edx,%eax
  80144e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801454:	eb 0c                	jmp    801462 <strsplit+0x31>
			*string++ = 0;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8d 50 01             	lea    0x1(%eax),%edx
  80145c:	89 55 08             	mov    %edx,0x8(%ebp)
  80145f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	8a 00                	mov    (%eax),%al
  801467:	84 c0                	test   %al,%al
  801469:	74 18                	je     801483 <strsplit+0x52>
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	0f be c0             	movsbl %al,%eax
  801473:	50                   	push   %eax
  801474:	ff 75 0c             	pushl  0xc(%ebp)
  801477:	e8 13 fb ff ff       	call   800f8f <strchr>
  80147c:	83 c4 08             	add    $0x8,%esp
  80147f:	85 c0                	test   %eax,%eax
  801481:	75 d3                	jne    801456 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	8a 00                	mov    (%eax),%al
  801488:	84 c0                	test   %al,%al
  80148a:	74 5a                	je     8014e6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80148c:	8b 45 14             	mov    0x14(%ebp),%eax
  80148f:	8b 00                	mov    (%eax),%eax
  801491:	83 f8 0f             	cmp    $0xf,%eax
  801494:	75 07                	jne    80149d <strsplit+0x6c>
		{
			return 0;
  801496:	b8 00 00 00 00       	mov    $0x0,%eax
  80149b:	eb 66                	jmp    801503 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80149d:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a0:	8b 00                	mov    (%eax),%eax
  8014a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8014a5:	8b 55 14             	mov    0x14(%ebp),%edx
  8014a8:	89 0a                	mov    %ecx,(%edx)
  8014aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b4:	01 c2                	add    %eax,%edx
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014bb:	eb 03                	jmp    8014c0 <strsplit+0x8f>
			string++;
  8014bd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	8a 00                	mov    (%eax),%al
  8014c5:	84 c0                	test   %al,%al
  8014c7:	74 8b                	je     801454 <strsplit+0x23>
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	8a 00                	mov    (%eax),%al
  8014ce:	0f be c0             	movsbl %al,%eax
  8014d1:	50                   	push   %eax
  8014d2:	ff 75 0c             	pushl  0xc(%ebp)
  8014d5:	e8 b5 fa ff ff       	call   800f8f <strchr>
  8014da:	83 c4 08             	add    $0x8,%esp
  8014dd:	85 c0                	test   %eax,%eax
  8014df:	74 dc                	je     8014bd <strsplit+0x8c>
			string++;
	}
  8014e1:	e9 6e ff ff ff       	jmp    801454 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014e6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ea:	8b 00                	mov    (%eax),%eax
  8014ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f6:	01 d0                	add    %edx,%eax
  8014f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  80150b:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801512:	8b 55 08             	mov    0x8(%ebp),%edx
  801515:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801518:	01 d0                	add    %edx,%eax
  80151a:	48                   	dec    %eax
  80151b:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80151e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801521:	ba 00 00 00 00       	mov    $0x0,%edx
  801526:	f7 75 ac             	divl   -0x54(%ebp)
  801529:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80152c:	29 d0                	sub    %edx,%eax
  80152e:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801531:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801538:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  80153f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801546:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80154d:	eb 3f                	jmp    80158e <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  80154f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801552:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801559:	83 ec 04             	sub    $0x4,%esp
  80155c:	50                   	push   %eax
  80155d:	ff 75 e8             	pushl  -0x18(%ebp)
  801560:	68 90 2c 80 00       	push   $0x802c90
  801565:	e8 11 f2 ff ff       	call   80077b <cprintf>
  80156a:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  80156d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801570:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801577:	83 ec 04             	sub    $0x4,%esp
  80157a:	50                   	push   %eax
  80157b:	ff 75 e8             	pushl  -0x18(%ebp)
  80157e:	68 a5 2c 80 00       	push   $0x802ca5
  801583:	e8 f3 f1 ff ff       	call   80077b <cprintf>
  801588:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  80158b:	ff 45 e8             	incl   -0x18(%ebp)
  80158e:	a1 28 30 80 00       	mov    0x803028,%eax
  801593:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801596:	7c b7                	jl     80154f <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801598:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  80159f:	e9 42 01 00 00       	jmp    8016e6 <malloc+0x1e1>
		int flag0=1;
  8015a4:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8015ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8015b1:	eb 6b                	jmp    80161e <malloc+0x119>
			for(int k=0;k<count;k++){
  8015b3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8015ba:	eb 42                	jmp    8015fe <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8015bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015bf:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8015c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015c9:	39 c2                	cmp    %eax,%edx
  8015cb:	77 2e                	ja     8015fb <malloc+0xf6>
  8015cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015d0:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8015d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015da:	39 c2                	cmp    %eax,%edx
  8015dc:	76 1d                	jbe    8015fb <malloc+0xf6>
					ni=arr_add[k].end-i;
  8015de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015e1:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8015e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015eb:	29 c2                	sub    %eax,%edx
  8015ed:	89 d0                	mov    %edx,%eax
  8015ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  8015f2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8015f9:	eb 0d                	jmp    801608 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8015fb:	ff 45 d8             	incl   -0x28(%ebp)
  8015fe:	a1 28 30 80 00       	mov    0x803028,%eax
  801603:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801606:	7c b4                	jl     8015bc <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801608:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80160c:	74 09                	je     801617 <malloc+0x112>
				flag0=0;
  80160e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801615:	eb 16                	jmp    80162d <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801617:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  80161e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	01 c2                	add    %eax,%edx
  801626:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801629:	39 c2                	cmp    %eax,%edx
  80162b:	77 86                	ja     8015b3 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  80162d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801631:	0f 84 a2 00 00 00    	je     8016d9 <malloc+0x1d4>

			int f=1;
  801637:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  80163e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801641:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801644:	89 c8                	mov    %ecx,%eax
  801646:	01 c0                	add    %eax,%eax
  801648:	01 c8                	add    %ecx,%eax
  80164a:	c1 e0 02             	shl    $0x2,%eax
  80164d:	05 20 31 80 00       	add    $0x803120,%eax
  801652:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801654:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80165d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801660:	89 d0                	mov    %edx,%eax
  801662:	01 c0                	add    %eax,%eax
  801664:	01 d0                	add    %edx,%eax
  801666:	c1 e0 02             	shl    $0x2,%eax
  801669:	05 24 31 80 00       	add    $0x803124,%eax
  80166e:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801670:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801673:	89 d0                	mov    %edx,%eax
  801675:	01 c0                	add    %eax,%eax
  801677:	01 d0                	add    %edx,%eax
  801679:	c1 e0 02             	shl    $0x2,%eax
  80167c:	05 28 31 80 00       	add    $0x803128,%eax
  801681:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801687:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  80168a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801691:	eb 36                	jmp    8016c9 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801693:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	01 c2                	add    %eax,%edx
  80169b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80169e:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8016a5:	39 c2                	cmp    %eax,%edx
  8016a7:	73 1d                	jae    8016c6 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  8016a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8016ac:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8016b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016b6:	29 c2                	sub    %eax,%edx
  8016b8:	89 d0                	mov    %edx,%eax
  8016ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  8016bd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  8016c4:	eb 0d                	jmp    8016d3 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  8016c6:	ff 45 d0             	incl   -0x30(%ebp)
  8016c9:	a1 28 30 80 00       	mov    0x803028,%eax
  8016ce:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8016d1:	7c c0                	jl     801693 <malloc+0x18e>
					break;

				}
			}

			if(f){
  8016d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8016d7:	75 1d                	jne    8016f6 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  8016d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8016e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e3:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8016e6:	a1 04 30 80 00       	mov    0x803004,%eax
  8016eb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016ee:	0f 8c b0 fe ff ff    	jl     8015a4 <malloc+0x9f>
  8016f4:	eb 01                	jmp    8016f7 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  8016f6:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8016f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016fb:	75 7a                	jne    801777 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  8016fd:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	01 d0                	add    %edx,%eax
  801708:	48                   	dec    %eax
  801709:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80170e:	7c 0a                	jl     80171a <malloc+0x215>
			return NULL;
  801710:	b8 00 00 00 00       	mov    $0x0,%eax
  801715:	e9 a4 02 00 00       	jmp    8019be <malloc+0x4b9>
		else{
			uint32 s=base_add;
  80171a:	a1 04 30 80 00       	mov    0x803004,%eax
  80171f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801722:	a1 28 30 80 00       	mov    0x803028,%eax
  801727:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  80172a:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  801731:	83 ec 08             	sub    $0x8,%esp
  801734:	ff 75 08             	pushl  0x8(%ebp)
  801737:	ff 75 a4             	pushl  -0x5c(%ebp)
  80173a:	e8 04 06 00 00       	call   801d43 <sys_allocateMem>
  80173f:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801742:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	01 d0                	add    %edx,%eax
  80174d:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  801752:	a1 28 30 80 00       	mov    0x803028,%eax
  801757:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80175d:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  801764:	a1 28 30 80 00       	mov    0x803028,%eax
  801769:	40                   	inc    %eax
  80176a:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  80176f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801772:	e9 47 02 00 00       	jmp    8019be <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801777:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80177e:	e9 ac 00 00 00       	jmp    80182f <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801783:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801786:	89 d0                	mov    %edx,%eax
  801788:	01 c0                	add    %eax,%eax
  80178a:	01 d0                	add    %edx,%eax
  80178c:	c1 e0 02             	shl    $0x2,%eax
  80178f:	05 24 31 80 00       	add    $0x803124,%eax
  801794:	8b 00                	mov    (%eax),%eax
  801796:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801799:	eb 7e                	jmp    801819 <malloc+0x314>
			int flag=0;
  80179b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  8017a2:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8017a9:	eb 57                	jmp    801802 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8017ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017ae:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8017b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017b8:	39 c2                	cmp    %eax,%edx
  8017ba:	77 1a                	ja     8017d6 <malloc+0x2d1>
  8017bc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017bf:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8017c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017c9:	39 c2                	cmp    %eax,%edx
  8017cb:	76 09                	jbe    8017d6 <malloc+0x2d1>
								flag=1;
  8017cd:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  8017d4:	eb 36                	jmp    80180c <malloc+0x307>
			arr[i].space++;
  8017d6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8017d9:	89 d0                	mov    %edx,%eax
  8017db:	01 c0                	add    %eax,%eax
  8017dd:	01 d0                	add    %edx,%eax
  8017df:	c1 e0 02             	shl    $0x2,%eax
  8017e2:	05 28 31 80 00       	add    $0x803128,%eax
  8017e7:	8b 00                	mov    (%eax),%eax
  8017e9:	8d 48 01             	lea    0x1(%eax),%ecx
  8017ec:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8017ef:	89 d0                	mov    %edx,%eax
  8017f1:	01 c0                	add    %eax,%eax
  8017f3:	01 d0                	add    %edx,%eax
  8017f5:	c1 e0 02             	shl    $0x2,%eax
  8017f8:	05 28 31 80 00       	add    $0x803128,%eax
  8017fd:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  8017ff:	ff 45 c0             	incl   -0x40(%ebp)
  801802:	a1 28 30 80 00       	mov    0x803028,%eax
  801807:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  80180a:	7c 9f                	jl     8017ab <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  80180c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801810:	75 19                	jne    80182b <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801812:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801819:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80181c:	a1 04 30 80 00       	mov    0x803004,%eax
  801821:	39 c2                	cmp    %eax,%edx
  801823:	0f 82 72 ff ff ff    	jb     80179b <malloc+0x296>
  801829:	eb 01                	jmp    80182c <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  80182b:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  80182c:	ff 45 cc             	incl   -0x34(%ebp)
  80182f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801832:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801835:	0f 8c 48 ff ff ff    	jl     801783 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  80183b:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801842:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801849:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801850:	eb 37                	jmp    801889 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801852:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801855:	89 d0                	mov    %edx,%eax
  801857:	01 c0                	add    %eax,%eax
  801859:	01 d0                	add    %edx,%eax
  80185b:	c1 e0 02             	shl    $0x2,%eax
  80185e:	05 28 31 80 00       	add    $0x803128,%eax
  801863:	8b 00                	mov    (%eax),%eax
  801865:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801868:	7d 1c                	jge    801886 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  80186a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80186d:	89 d0                	mov    %edx,%eax
  80186f:	01 c0                	add    %eax,%eax
  801871:	01 d0                	add    %edx,%eax
  801873:	c1 e0 02             	shl    $0x2,%eax
  801876:	05 28 31 80 00       	add    $0x803128,%eax
  80187b:	8b 00                	mov    (%eax),%eax
  80187d:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801880:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801883:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801886:	ff 45 b4             	incl   -0x4c(%ebp)
  801889:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80188c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80188f:	7c c1                	jl     801852 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801891:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801897:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  80189a:	89 c8                	mov    %ecx,%eax
  80189c:	01 c0                	add    %eax,%eax
  80189e:	01 c8                	add    %ecx,%eax
  8018a0:	c1 e0 02             	shl    $0x2,%eax
  8018a3:	05 20 31 80 00       	add    $0x803120,%eax
  8018a8:	8b 00                	mov    (%eax),%eax
  8018aa:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  8018b1:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8018b7:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8018ba:	89 c8                	mov    %ecx,%eax
  8018bc:	01 c0                	add    %eax,%eax
  8018be:	01 c8                	add    %ecx,%eax
  8018c0:	c1 e0 02             	shl    $0x2,%eax
  8018c3:	05 24 31 80 00       	add    $0x803124,%eax
  8018c8:	8b 00                	mov    (%eax),%eax
  8018ca:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  8018d1:	a1 28 30 80 00       	mov    0x803028,%eax
  8018d6:	40                   	inc    %eax
  8018d7:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  8018dc:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8018df:	89 d0                	mov    %edx,%eax
  8018e1:	01 c0                	add    %eax,%eax
  8018e3:	01 d0                	add    %edx,%eax
  8018e5:	c1 e0 02             	shl    $0x2,%eax
  8018e8:	05 20 31 80 00       	add    $0x803120,%eax
  8018ed:	8b 00                	mov    (%eax),%eax
  8018ef:	83 ec 08             	sub    $0x8,%esp
  8018f2:	ff 75 08             	pushl  0x8(%ebp)
  8018f5:	50                   	push   %eax
  8018f6:	e8 48 04 00 00       	call   801d43 <sys_allocateMem>
  8018fb:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  8018fe:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801905:	eb 78                	jmp    80197f <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801907:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80190a:	89 d0                	mov    %edx,%eax
  80190c:	01 c0                	add    %eax,%eax
  80190e:	01 d0                	add    %edx,%eax
  801910:	c1 e0 02             	shl    $0x2,%eax
  801913:	05 20 31 80 00       	add    $0x803120,%eax
  801918:	8b 00                	mov    (%eax),%eax
  80191a:	83 ec 04             	sub    $0x4,%esp
  80191d:	50                   	push   %eax
  80191e:	ff 75 b0             	pushl  -0x50(%ebp)
  801921:	68 90 2c 80 00       	push   $0x802c90
  801926:	e8 50 ee ff ff       	call   80077b <cprintf>
  80192b:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  80192e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801931:	89 d0                	mov    %edx,%eax
  801933:	01 c0                	add    %eax,%eax
  801935:	01 d0                	add    %edx,%eax
  801937:	c1 e0 02             	shl    $0x2,%eax
  80193a:	05 24 31 80 00       	add    $0x803124,%eax
  80193f:	8b 00                	mov    (%eax),%eax
  801941:	83 ec 04             	sub    $0x4,%esp
  801944:	50                   	push   %eax
  801945:	ff 75 b0             	pushl  -0x50(%ebp)
  801948:	68 a5 2c 80 00       	push   $0x802ca5
  80194d:	e8 29 ee ff ff       	call   80077b <cprintf>
  801952:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801955:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801958:	89 d0                	mov    %edx,%eax
  80195a:	01 c0                	add    %eax,%eax
  80195c:	01 d0                	add    %edx,%eax
  80195e:	c1 e0 02             	shl    $0x2,%eax
  801961:	05 28 31 80 00       	add    $0x803128,%eax
  801966:	8b 00                	mov    (%eax),%eax
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	50                   	push   %eax
  80196c:	ff 75 b0             	pushl  -0x50(%ebp)
  80196f:	68 b8 2c 80 00       	push   $0x802cb8
  801974:	e8 02 ee ff ff       	call   80077b <cprintf>
  801979:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  80197c:	ff 45 b0             	incl   -0x50(%ebp)
  80197f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801982:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801985:	7c 80                	jl     801907 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801987:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80198a:	89 d0                	mov    %edx,%eax
  80198c:	01 c0                	add    %eax,%eax
  80198e:	01 d0                	add    %edx,%eax
  801990:	c1 e0 02             	shl    $0x2,%eax
  801993:	05 20 31 80 00       	add    $0x803120,%eax
  801998:	8b 00                	mov    (%eax),%eax
  80199a:	83 ec 08             	sub    $0x8,%esp
  80199d:	50                   	push   %eax
  80199e:	68 cc 2c 80 00       	push   $0x802ccc
  8019a3:	e8 d3 ed ff ff       	call   80077b <cprintf>
  8019a8:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  8019ab:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8019ae:	89 d0                	mov    %edx,%eax
  8019b0:	01 c0                	add    %eax,%eax
  8019b2:	01 d0                	add    %edx,%eax
  8019b4:	c1 e0 02             	shl    $0x2,%eax
  8019b7:	05 20 31 80 00       	add    $0x803120,%eax
  8019bc:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  8019cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8019d3:	eb 4b                	jmp    801a20 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  8019d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d8:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8019df:	89 c2                	mov    %eax,%edx
  8019e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019e4:	39 c2                	cmp    %eax,%edx
  8019e6:	7f 35                	jg     801a1d <free+0x5d>
  8019e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019eb:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8019f2:	89 c2                	mov    %eax,%edx
  8019f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019f7:	39 c2                	cmp    %eax,%edx
  8019f9:	7e 22                	jle    801a1d <free+0x5d>
				start=arr_add[i].start;
  8019fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019fe:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801a08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a0b:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801a12:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801a15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801a1b:	eb 0d                	jmp    801a2a <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801a1d:	ff 45 ec             	incl   -0x14(%ebp)
  801a20:	a1 28 30 80 00       	mov    0x803028,%eax
  801a25:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801a28:	7c ab                	jl     8019d5 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2d:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a37:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801a3e:	29 c2                	sub    %eax,%edx
  801a40:	89 d0                	mov    %edx,%eax
  801a42:	83 ec 08             	sub    $0x8,%esp
  801a45:	50                   	push   %eax
  801a46:	ff 75 f4             	pushl  -0xc(%ebp)
  801a49:	e8 d9 02 00 00       	call   801d27 <sys_freeMem>
  801a4e:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a54:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a57:	eb 2d                	jmp    801a86 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801a59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a5c:	40                   	inc    %eax
  801a5d:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801a64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a67:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a71:	40                   	inc    %eax
  801a72:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801a79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a7c:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801a83:	ff 45 e8             	incl   -0x18(%ebp)
  801a86:	a1 28 30 80 00       	mov    0x803028,%eax
  801a8b:	48                   	dec    %eax
  801a8c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a8f:	7f c8                	jg     801a59 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801a91:	a1 28 30 80 00       	mov    0x803028,%eax
  801a96:	48                   	dec    %eax
  801a97:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801a9c:	90                   	nop
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 18             	sub    $0x18,%esp
  801aa5:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa8:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801aab:	83 ec 04             	sub    $0x4,%esp
  801aae:	68 e8 2c 80 00       	push   $0x802ce8
  801ab3:	68 18 01 00 00       	push   $0x118
  801ab8:	68 0b 2d 80 00       	push   $0x802d0b
  801abd:	e8 17 ea ff ff       	call   8004d9 <_panic>

00801ac2 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	68 e8 2c 80 00       	push   $0x802ce8
  801ad0:	68 1e 01 00 00       	push   $0x11e
  801ad5:	68 0b 2d 80 00       	push   $0x802d0b
  801ada:	e8 fa e9 ff ff       	call   8004d9 <_panic>

00801adf <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ae5:	83 ec 04             	sub    $0x4,%esp
  801ae8:	68 e8 2c 80 00       	push   $0x802ce8
  801aed:	68 24 01 00 00       	push   $0x124
  801af2:	68 0b 2d 80 00       	push   $0x802d0b
  801af7:	e8 dd e9 ff ff       	call   8004d9 <_panic>

00801afc <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b02:	83 ec 04             	sub    $0x4,%esp
  801b05:	68 e8 2c 80 00       	push   $0x802ce8
  801b0a:	68 29 01 00 00       	push   $0x129
  801b0f:	68 0b 2d 80 00       	push   $0x802d0b
  801b14:	e8 c0 e9 ff ff       	call   8004d9 <_panic>

00801b19 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	68 e8 2c 80 00       	push   $0x802ce8
  801b27:	68 2f 01 00 00       	push   $0x12f
  801b2c:	68 0b 2d 80 00       	push   $0x802d0b
  801b31:	e8 a3 e9 ff ff       	call   8004d9 <_panic>

00801b36 <shrink>:
}
void shrink(uint32 newSize)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b3c:	83 ec 04             	sub    $0x4,%esp
  801b3f:	68 e8 2c 80 00       	push   $0x802ce8
  801b44:	68 33 01 00 00       	push   $0x133
  801b49:	68 0b 2d 80 00       	push   $0x802d0b
  801b4e:	e8 86 e9 ff ff       	call   8004d9 <_panic>

00801b53 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b59:	83 ec 04             	sub    $0x4,%esp
  801b5c:	68 e8 2c 80 00       	push   $0x802ce8
  801b61:	68 38 01 00 00       	push   $0x138
  801b66:	68 0b 2d 80 00       	push   $0x802d0b
  801b6b:	e8 69 e9 ff ff       	call   8004d9 <_panic>

00801b70 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	57                   	push   %edi
  801b74:	56                   	push   %esi
  801b75:	53                   	push   %ebx
  801b76:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b82:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b85:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b88:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b8b:	cd 30                	int    $0x30
  801b8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b93:	83 c4 10             	add    $0x10,%esp
  801b96:	5b                   	pop    %ebx
  801b97:	5e                   	pop    %esi
  801b98:	5f                   	pop    %edi
  801b99:	5d                   	pop    %ebp
  801b9a:	c3                   	ret    

00801b9b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 04             	sub    $0x4,%esp
  801ba1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ba7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	52                   	push   %edx
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	50                   	push   %eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	e8 b2 ff ff ff       	call   801b70 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	90                   	nop
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_cgetc>:

int
sys_cgetc(void)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 01                	push   $0x1
  801bd3:	e8 98 ff ff ff       	call   801b70 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	50                   	push   %eax
  801bec:	6a 05                	push   $0x5
  801bee:	e8 7d ff ff ff       	call   801b70 <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 02                	push   $0x2
  801c07:	e8 64 ff ff ff       	call   801b70 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 03                	push   $0x3
  801c20:	e8 4b ff ff ff       	call   801b70 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 04                	push   $0x4
  801c39:	e8 32 ff ff ff       	call   801b70 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_env_exit>:


void sys_env_exit(void)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 06                	push   $0x6
  801c52:	e8 19 ff ff ff       	call   801b70 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	90                   	nop
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	52                   	push   %edx
  801c6d:	50                   	push   %eax
  801c6e:	6a 07                	push   $0x7
  801c70:	e8 fb fe ff ff       	call   801b70 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	56                   	push   %esi
  801c7e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c7f:	8b 75 18             	mov    0x18(%ebp),%esi
  801c82:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c85:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	56                   	push   %esi
  801c8f:	53                   	push   %ebx
  801c90:	51                   	push   %ecx
  801c91:	52                   	push   %edx
  801c92:	50                   	push   %eax
  801c93:	6a 08                	push   $0x8
  801c95:	e8 d6 fe ff ff       	call   801b70 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
}
  801c9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ca0:	5b                   	pop    %ebx
  801ca1:	5e                   	pop    %esi
  801ca2:	5d                   	pop    %ebp
  801ca3:	c3                   	ret    

00801ca4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ca7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	52                   	push   %edx
  801cb4:	50                   	push   %eax
  801cb5:	6a 09                	push   $0x9
  801cb7:	e8 b4 fe ff ff       	call   801b70 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	ff 75 0c             	pushl  0xc(%ebp)
  801ccd:	ff 75 08             	pushl  0x8(%ebp)
  801cd0:	6a 0a                	push   $0xa
  801cd2:	e8 99 fe ff ff       	call   801b70 <syscall>
  801cd7:	83 c4 18             	add    $0x18,%esp
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 0b                	push   $0xb
  801ceb:	e8 80 fe ff ff       	call   801b70 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 0c                	push   $0xc
  801d04:	e8 67 fe ff ff       	call   801b70 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 0d                	push   $0xd
  801d1d:	e8 4e fe ff ff       	call   801b70 <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	ff 75 08             	pushl  0x8(%ebp)
  801d36:	6a 11                	push   $0x11
  801d38:	e8 33 fe ff ff       	call   801b70 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
	return;
  801d40:	90                   	nop
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	ff 75 0c             	pushl  0xc(%ebp)
  801d4f:	ff 75 08             	pushl  0x8(%ebp)
  801d52:	6a 12                	push   $0x12
  801d54:	e8 17 fe ff ff       	call   801b70 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5c:	90                   	nop
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 0e                	push   $0xe
  801d6e:	e8 fd fd ff ff       	call   801b70 <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	ff 75 08             	pushl  0x8(%ebp)
  801d86:	6a 0f                	push   $0xf
  801d88:	e8 e3 fd ff ff       	call   801b70 <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 10                	push   $0x10
  801da1:	e8 ca fd ff ff       	call   801b70 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
}
  801da9:	90                   	nop
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 14                	push   $0x14
  801dbb:	e8 b0 fd ff ff       	call   801b70 <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
}
  801dc3:	90                   	nop
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 15                	push   $0x15
  801dd5:	e8 96 fd ff ff       	call   801b70 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
}
  801ddd:	90                   	nop
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <sys_cputc>:


void
sys_cputc(const char c)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 04             	sub    $0x4,%esp
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801dec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	50                   	push   %eax
  801df9:	6a 16                	push   $0x16
  801dfb:	e8 70 fd ff ff       	call   801b70 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	90                   	nop
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 17                	push   $0x17
  801e15:	e8 56 fd ff ff       	call   801b70 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
}
  801e1d:	90                   	nop
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	ff 75 0c             	pushl  0xc(%ebp)
  801e2f:	50                   	push   %eax
  801e30:	6a 18                	push   $0x18
  801e32:	e8 39 fd ff ff       	call   801b70 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
}
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	52                   	push   %edx
  801e4c:	50                   	push   %eax
  801e4d:	6a 1b                	push   $0x1b
  801e4f:	e8 1c fd ff ff       	call   801b70 <syscall>
  801e54:	83 c4 18             	add    $0x18,%esp
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	52                   	push   %edx
  801e69:	50                   	push   %eax
  801e6a:	6a 19                	push   $0x19
  801e6c:	e8 ff fc ff ff       	call   801b70 <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
}
  801e74:	90                   	nop
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	52                   	push   %edx
  801e87:	50                   	push   %eax
  801e88:	6a 1a                	push   $0x1a
  801e8a:	e8 e1 fc ff ff       	call   801b70 <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
}
  801e92:	90                   	nop
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 04             	sub    $0x4,%esp
  801e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ea1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ea4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	6a 00                	push   $0x0
  801ead:	51                   	push   %ecx
  801eae:	52                   	push   %edx
  801eaf:	ff 75 0c             	pushl  0xc(%ebp)
  801eb2:	50                   	push   %eax
  801eb3:	6a 1c                	push   $0x1c
  801eb5:	e8 b6 fc ff ff       	call   801b70 <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	52                   	push   %edx
  801ecf:	50                   	push   %eax
  801ed0:	6a 1d                	push   $0x1d
  801ed2:	e8 99 fc ff ff       	call   801b70 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801edf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	51                   	push   %ecx
  801eed:	52                   	push   %edx
  801eee:	50                   	push   %eax
  801eef:	6a 1e                	push   $0x1e
  801ef1:	e8 7a fc ff ff       	call   801b70 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801efe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	52                   	push   %edx
  801f0b:	50                   	push   %eax
  801f0c:	6a 1f                	push   $0x1f
  801f0e:	e8 5d fc ff ff       	call   801b70 <syscall>
  801f13:	83 c4 18             	add    $0x18,%esp
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 20                	push   $0x20
  801f27:	e8 44 fc ff ff       	call   801b70 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	6a 00                	push   $0x0
  801f39:	ff 75 14             	pushl  0x14(%ebp)
  801f3c:	ff 75 10             	pushl  0x10(%ebp)
  801f3f:	ff 75 0c             	pushl  0xc(%ebp)
  801f42:	50                   	push   %eax
  801f43:	6a 21                	push   $0x21
  801f45:	e8 26 fc ff ff       	call   801b70 <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	50                   	push   %eax
  801f5e:	6a 22                	push   $0x22
  801f60:	e8 0b fc ff ff       	call   801b70 <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	90                   	nop
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	50                   	push   %eax
  801f7a:	6a 23                	push   $0x23
  801f7c:	e8 ef fb ff ff       	call   801b70 <syscall>
  801f81:	83 c4 18             	add    $0x18,%esp
}
  801f84:	90                   	nop
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f8d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f90:	8d 50 04             	lea    0x4(%eax),%edx
  801f93:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	52                   	push   %edx
  801f9d:	50                   	push   %eax
  801f9e:	6a 24                	push   $0x24
  801fa0:	e8 cb fb ff ff       	call   801b70 <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
	return result;
  801fa8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fb1:	89 01                	mov    %eax,(%ecx)
  801fb3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	c9                   	leave  
  801fba:	c2 04 00             	ret    $0x4

00801fbd <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	ff 75 10             	pushl  0x10(%ebp)
  801fc7:	ff 75 0c             	pushl  0xc(%ebp)
  801fca:	ff 75 08             	pushl  0x8(%ebp)
  801fcd:	6a 13                	push   $0x13
  801fcf:	e8 9c fb ff ff       	call   801b70 <syscall>
  801fd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd7:	90                   	nop
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <sys_rcr2>:
uint32 sys_rcr2()
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 25                	push   $0x25
  801fe9:	e8 82 fb ff ff       	call   801b70 <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 04             	sub    $0x4,%esp
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fff:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	50                   	push   %eax
  80200c:	6a 26                	push   $0x26
  80200e:	e8 5d fb ff ff       	call   801b70 <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
	return ;
  802016:	90                   	nop
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <rsttst>:
void rsttst()
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 28                	push   $0x28
  802028:	e8 43 fb ff ff       	call   801b70 <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
	return ;
  802030:	90                   	nop
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 04             	sub    $0x4,%esp
  802039:	8b 45 14             	mov    0x14(%ebp),%eax
  80203c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80203f:	8b 55 18             	mov    0x18(%ebp),%edx
  802042:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802046:	52                   	push   %edx
  802047:	50                   	push   %eax
  802048:	ff 75 10             	pushl  0x10(%ebp)
  80204b:	ff 75 0c             	pushl  0xc(%ebp)
  80204e:	ff 75 08             	pushl  0x8(%ebp)
  802051:	6a 27                	push   $0x27
  802053:	e8 18 fb ff ff       	call   801b70 <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
	return ;
  80205b:	90                   	nop
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <chktst>:
void chktst(uint32 n)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	ff 75 08             	pushl  0x8(%ebp)
  80206c:	6a 29                	push   $0x29
  80206e:	e8 fd fa ff ff       	call   801b70 <syscall>
  802073:	83 c4 18             	add    $0x18,%esp
	return ;
  802076:	90                   	nop
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <inctst>:

void inctst()
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 2a                	push   $0x2a
  802088:	e8 e3 fa ff ff       	call   801b70 <syscall>
  80208d:	83 c4 18             	add    $0x18,%esp
	return ;
  802090:	90                   	nop
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <gettst>:
uint32 gettst()
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 2b                	push   $0x2b
  8020a2:	e8 c9 fa ff ff       	call   801b70 <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
}
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
  8020af:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 2c                	push   $0x2c
  8020be:	e8 ad fa ff ff       	call   801b70 <syscall>
  8020c3:	83 c4 18             	add    $0x18,%esp
  8020c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020c9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020cd:	75 07                	jne    8020d6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d4:	eb 05                	jmp    8020db <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
  8020e0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 2c                	push   $0x2c
  8020ef:	e8 7c fa ff ff       	call   801b70 <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
  8020f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020fa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020fe:	75 07                	jne    802107 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802100:	b8 01 00 00 00       	mov    $0x1,%eax
  802105:	eb 05                	jmp    80210c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802107:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 2c                	push   $0x2c
  802120:	e8 4b fa ff ff       	call   801b70 <syscall>
  802125:	83 c4 18             	add    $0x18,%esp
  802128:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80212b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80212f:	75 07                	jne    802138 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802131:	b8 01 00 00 00       	mov    $0x1,%eax
  802136:	eb 05                	jmp    80213d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802138:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 2c                	push   $0x2c
  802151:	e8 1a fa ff ff       	call   801b70 <syscall>
  802156:	83 c4 18             	add    $0x18,%esp
  802159:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80215c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802160:	75 07                	jne    802169 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802162:	b8 01 00 00 00       	mov    $0x1,%eax
  802167:	eb 05                	jmp    80216e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802169:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	6a 2d                	push   $0x2d
  802180:	e8 eb f9 ff ff       	call   801b70 <syscall>
  802185:	83 c4 18             	add    $0x18,%esp
	return ;
  802188:	90                   	nop
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80218f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802192:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802195:	8b 55 0c             	mov    0xc(%ebp),%edx
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	6a 00                	push   $0x0
  80219d:	53                   	push   %ebx
  80219e:	51                   	push   %ecx
  80219f:	52                   	push   %edx
  8021a0:	50                   	push   %eax
  8021a1:	6a 2e                	push   $0x2e
  8021a3:	e8 c8 f9 ff ff       	call   801b70 <syscall>
  8021a8:	83 c4 18             	add    $0x18,%esp
}
  8021ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	52                   	push   %edx
  8021c0:	50                   	push   %eax
  8021c1:	6a 2f                	push   $0x2f
  8021c3:	e8 a8 f9 ff ff       	call   801b70 <syscall>
  8021c8:	83 c4 18             	add    $0x18,%esp
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    
  8021cd:	66 90                	xchg   %ax,%ax
  8021cf:	90                   	nop

008021d0 <__udivdi3>:
  8021d0:	55                   	push   %ebp
  8021d1:	57                   	push   %edi
  8021d2:	56                   	push   %esi
  8021d3:	53                   	push   %ebx
  8021d4:	83 ec 1c             	sub    $0x1c,%esp
  8021d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8021db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021e7:	89 ca                	mov    %ecx,%edx
  8021e9:	89 f8                	mov    %edi,%eax
  8021eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8021ef:	85 f6                	test   %esi,%esi
  8021f1:	75 2d                	jne    802220 <__udivdi3+0x50>
  8021f3:	39 cf                	cmp    %ecx,%edi
  8021f5:	77 65                	ja     80225c <__udivdi3+0x8c>
  8021f7:	89 fd                	mov    %edi,%ebp
  8021f9:	85 ff                	test   %edi,%edi
  8021fb:	75 0b                	jne    802208 <__udivdi3+0x38>
  8021fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802202:	31 d2                	xor    %edx,%edx
  802204:	f7 f7                	div    %edi
  802206:	89 c5                	mov    %eax,%ebp
  802208:	31 d2                	xor    %edx,%edx
  80220a:	89 c8                	mov    %ecx,%eax
  80220c:	f7 f5                	div    %ebp
  80220e:	89 c1                	mov    %eax,%ecx
  802210:	89 d8                	mov    %ebx,%eax
  802212:	f7 f5                	div    %ebp
  802214:	89 cf                	mov    %ecx,%edi
  802216:	89 fa                	mov    %edi,%edx
  802218:	83 c4 1c             	add    $0x1c,%esp
  80221b:	5b                   	pop    %ebx
  80221c:	5e                   	pop    %esi
  80221d:	5f                   	pop    %edi
  80221e:	5d                   	pop    %ebp
  80221f:	c3                   	ret    
  802220:	39 ce                	cmp    %ecx,%esi
  802222:	77 28                	ja     80224c <__udivdi3+0x7c>
  802224:	0f bd fe             	bsr    %esi,%edi
  802227:	83 f7 1f             	xor    $0x1f,%edi
  80222a:	75 40                	jne    80226c <__udivdi3+0x9c>
  80222c:	39 ce                	cmp    %ecx,%esi
  80222e:	72 0a                	jb     80223a <__udivdi3+0x6a>
  802230:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802234:	0f 87 9e 00 00 00    	ja     8022d8 <__udivdi3+0x108>
  80223a:	b8 01 00 00 00       	mov    $0x1,%eax
  80223f:	89 fa                	mov    %edi,%edx
  802241:	83 c4 1c             	add    $0x1c,%esp
  802244:	5b                   	pop    %ebx
  802245:	5e                   	pop    %esi
  802246:	5f                   	pop    %edi
  802247:	5d                   	pop    %ebp
  802248:	c3                   	ret    
  802249:	8d 76 00             	lea    0x0(%esi),%esi
  80224c:	31 ff                	xor    %edi,%edi
  80224e:	31 c0                	xor    %eax,%eax
  802250:	89 fa                	mov    %edi,%edx
  802252:	83 c4 1c             	add    $0x1c,%esp
  802255:	5b                   	pop    %ebx
  802256:	5e                   	pop    %esi
  802257:	5f                   	pop    %edi
  802258:	5d                   	pop    %ebp
  802259:	c3                   	ret    
  80225a:	66 90                	xchg   %ax,%ax
  80225c:	89 d8                	mov    %ebx,%eax
  80225e:	f7 f7                	div    %edi
  802260:	31 ff                	xor    %edi,%edi
  802262:	89 fa                	mov    %edi,%edx
  802264:	83 c4 1c             	add    $0x1c,%esp
  802267:	5b                   	pop    %ebx
  802268:	5e                   	pop    %esi
  802269:	5f                   	pop    %edi
  80226a:	5d                   	pop    %ebp
  80226b:	c3                   	ret    
  80226c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802271:	89 eb                	mov    %ebp,%ebx
  802273:	29 fb                	sub    %edi,%ebx
  802275:	89 f9                	mov    %edi,%ecx
  802277:	d3 e6                	shl    %cl,%esi
  802279:	89 c5                	mov    %eax,%ebp
  80227b:	88 d9                	mov    %bl,%cl
  80227d:	d3 ed                	shr    %cl,%ebp
  80227f:	89 e9                	mov    %ebp,%ecx
  802281:	09 f1                	or     %esi,%ecx
  802283:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802287:	89 f9                	mov    %edi,%ecx
  802289:	d3 e0                	shl    %cl,%eax
  80228b:	89 c5                	mov    %eax,%ebp
  80228d:	89 d6                	mov    %edx,%esi
  80228f:	88 d9                	mov    %bl,%cl
  802291:	d3 ee                	shr    %cl,%esi
  802293:	89 f9                	mov    %edi,%ecx
  802295:	d3 e2                	shl    %cl,%edx
  802297:	8b 44 24 08          	mov    0x8(%esp),%eax
  80229b:	88 d9                	mov    %bl,%cl
  80229d:	d3 e8                	shr    %cl,%eax
  80229f:	09 c2                	or     %eax,%edx
  8022a1:	89 d0                	mov    %edx,%eax
  8022a3:	89 f2                	mov    %esi,%edx
  8022a5:	f7 74 24 0c          	divl   0xc(%esp)
  8022a9:	89 d6                	mov    %edx,%esi
  8022ab:	89 c3                	mov    %eax,%ebx
  8022ad:	f7 e5                	mul    %ebp
  8022af:	39 d6                	cmp    %edx,%esi
  8022b1:	72 19                	jb     8022cc <__udivdi3+0xfc>
  8022b3:	74 0b                	je     8022c0 <__udivdi3+0xf0>
  8022b5:	89 d8                	mov    %ebx,%eax
  8022b7:	31 ff                	xor    %edi,%edi
  8022b9:	e9 58 ff ff ff       	jmp    802216 <__udivdi3+0x46>
  8022be:	66 90                	xchg   %ax,%ax
  8022c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022c4:	89 f9                	mov    %edi,%ecx
  8022c6:	d3 e2                	shl    %cl,%edx
  8022c8:	39 c2                	cmp    %eax,%edx
  8022ca:	73 e9                	jae    8022b5 <__udivdi3+0xe5>
  8022cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022cf:	31 ff                	xor    %edi,%edi
  8022d1:	e9 40 ff ff ff       	jmp    802216 <__udivdi3+0x46>
  8022d6:	66 90                	xchg   %ax,%ax
  8022d8:	31 c0                	xor    %eax,%eax
  8022da:	e9 37 ff ff ff       	jmp    802216 <__udivdi3+0x46>
  8022df:	90                   	nop

008022e0 <__umoddi3>:
  8022e0:	55                   	push   %ebp
  8022e1:	57                   	push   %edi
  8022e2:	56                   	push   %esi
  8022e3:	53                   	push   %ebx
  8022e4:	83 ec 1c             	sub    $0x1c,%esp
  8022e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8022eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022ff:	89 f3                	mov    %esi,%ebx
  802301:	89 fa                	mov    %edi,%edx
  802303:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802307:	89 34 24             	mov    %esi,(%esp)
  80230a:	85 c0                	test   %eax,%eax
  80230c:	75 1a                	jne    802328 <__umoddi3+0x48>
  80230e:	39 f7                	cmp    %esi,%edi
  802310:	0f 86 a2 00 00 00    	jbe    8023b8 <__umoddi3+0xd8>
  802316:	89 c8                	mov    %ecx,%eax
  802318:	89 f2                	mov    %esi,%edx
  80231a:	f7 f7                	div    %edi
  80231c:	89 d0                	mov    %edx,%eax
  80231e:	31 d2                	xor    %edx,%edx
  802320:	83 c4 1c             	add    $0x1c,%esp
  802323:	5b                   	pop    %ebx
  802324:	5e                   	pop    %esi
  802325:	5f                   	pop    %edi
  802326:	5d                   	pop    %ebp
  802327:	c3                   	ret    
  802328:	39 f0                	cmp    %esi,%eax
  80232a:	0f 87 ac 00 00 00    	ja     8023dc <__umoddi3+0xfc>
  802330:	0f bd e8             	bsr    %eax,%ebp
  802333:	83 f5 1f             	xor    $0x1f,%ebp
  802336:	0f 84 ac 00 00 00    	je     8023e8 <__umoddi3+0x108>
  80233c:	bf 20 00 00 00       	mov    $0x20,%edi
  802341:	29 ef                	sub    %ebp,%edi
  802343:	89 fe                	mov    %edi,%esi
  802345:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802349:	89 e9                	mov    %ebp,%ecx
  80234b:	d3 e0                	shl    %cl,%eax
  80234d:	89 d7                	mov    %edx,%edi
  80234f:	89 f1                	mov    %esi,%ecx
  802351:	d3 ef                	shr    %cl,%edi
  802353:	09 c7                	or     %eax,%edi
  802355:	89 e9                	mov    %ebp,%ecx
  802357:	d3 e2                	shl    %cl,%edx
  802359:	89 14 24             	mov    %edx,(%esp)
  80235c:	89 d8                	mov    %ebx,%eax
  80235e:	d3 e0                	shl    %cl,%eax
  802360:	89 c2                	mov    %eax,%edx
  802362:	8b 44 24 08          	mov    0x8(%esp),%eax
  802366:	d3 e0                	shl    %cl,%eax
  802368:	89 44 24 04          	mov    %eax,0x4(%esp)
  80236c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802370:	89 f1                	mov    %esi,%ecx
  802372:	d3 e8                	shr    %cl,%eax
  802374:	09 d0                	or     %edx,%eax
  802376:	d3 eb                	shr    %cl,%ebx
  802378:	89 da                	mov    %ebx,%edx
  80237a:	f7 f7                	div    %edi
  80237c:	89 d3                	mov    %edx,%ebx
  80237e:	f7 24 24             	mull   (%esp)
  802381:	89 c6                	mov    %eax,%esi
  802383:	89 d1                	mov    %edx,%ecx
  802385:	39 d3                	cmp    %edx,%ebx
  802387:	0f 82 87 00 00 00    	jb     802414 <__umoddi3+0x134>
  80238d:	0f 84 91 00 00 00    	je     802424 <__umoddi3+0x144>
  802393:	8b 54 24 04          	mov    0x4(%esp),%edx
  802397:	29 f2                	sub    %esi,%edx
  802399:	19 cb                	sbb    %ecx,%ebx
  80239b:	89 d8                	mov    %ebx,%eax
  80239d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8023a1:	d3 e0                	shl    %cl,%eax
  8023a3:	89 e9                	mov    %ebp,%ecx
  8023a5:	d3 ea                	shr    %cl,%edx
  8023a7:	09 d0                	or     %edx,%eax
  8023a9:	89 e9                	mov    %ebp,%ecx
  8023ab:	d3 eb                	shr    %cl,%ebx
  8023ad:	89 da                	mov    %ebx,%edx
  8023af:	83 c4 1c             	add    $0x1c,%esp
  8023b2:	5b                   	pop    %ebx
  8023b3:	5e                   	pop    %esi
  8023b4:	5f                   	pop    %edi
  8023b5:	5d                   	pop    %ebp
  8023b6:	c3                   	ret    
  8023b7:	90                   	nop
  8023b8:	89 fd                	mov    %edi,%ebp
  8023ba:	85 ff                	test   %edi,%edi
  8023bc:	75 0b                	jne    8023c9 <__umoddi3+0xe9>
  8023be:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c3:	31 d2                	xor    %edx,%edx
  8023c5:	f7 f7                	div    %edi
  8023c7:	89 c5                	mov    %eax,%ebp
  8023c9:	89 f0                	mov    %esi,%eax
  8023cb:	31 d2                	xor    %edx,%edx
  8023cd:	f7 f5                	div    %ebp
  8023cf:	89 c8                	mov    %ecx,%eax
  8023d1:	f7 f5                	div    %ebp
  8023d3:	89 d0                	mov    %edx,%eax
  8023d5:	e9 44 ff ff ff       	jmp    80231e <__umoddi3+0x3e>
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	89 c8                	mov    %ecx,%eax
  8023de:	89 f2                	mov    %esi,%edx
  8023e0:	83 c4 1c             	add    $0x1c,%esp
  8023e3:	5b                   	pop    %ebx
  8023e4:	5e                   	pop    %esi
  8023e5:	5f                   	pop    %edi
  8023e6:	5d                   	pop    %ebp
  8023e7:	c3                   	ret    
  8023e8:	3b 04 24             	cmp    (%esp),%eax
  8023eb:	72 06                	jb     8023f3 <__umoddi3+0x113>
  8023ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8023f1:	77 0f                	ja     802402 <__umoddi3+0x122>
  8023f3:	89 f2                	mov    %esi,%edx
  8023f5:	29 f9                	sub    %edi,%ecx
  8023f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8023fb:	89 14 24             	mov    %edx,(%esp)
  8023fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802402:	8b 44 24 04          	mov    0x4(%esp),%eax
  802406:	8b 14 24             	mov    (%esp),%edx
  802409:	83 c4 1c             	add    $0x1c,%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    
  802411:	8d 76 00             	lea    0x0(%esi),%esi
  802414:	2b 04 24             	sub    (%esp),%eax
  802417:	19 fa                	sbb    %edi,%edx
  802419:	89 d1                	mov    %edx,%ecx
  80241b:	89 c6                	mov    %eax,%esi
  80241d:	e9 71 ff ff ff       	jmp    802393 <__umoddi3+0xb3>
  802422:	66 90                	xchg   %ax,%ax
  802424:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802428:	72 ea                	jb     802414 <__umoddi3+0x134>
  80242a:	89 d9                	mov    %ebx,%ecx
  80242c:	e9 62 ff ff ff       	jmp    802393 <__umoddi3+0xb3>
