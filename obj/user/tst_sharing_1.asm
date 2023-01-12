
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 fd 02 00 00       	call   800333 <libmain>
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
  800087:	68 e0 23 80 00       	push   $0x8023e0
  80008c:	6a 12                	push   $0x12
  80008e:	68 fc 23 80 00       	push   $0x8023fc
  800093:	e8 e0 03 00 00       	call   800478 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 14 24 80 00       	push   $0x802414
  8000a0:	e8 75 06 00 00       	call   80071a <cprintf>
  8000a5:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000a8:	e8 ce 1b 00 00       	call   801c7b <sys_calculate_free_frames>
  8000ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b0:	83 ec 04             	sub    $0x4,%esp
  8000b3:	6a 01                	push   $0x1
  8000b5:	68 00 10 00 00       	push   $0x1000
  8000ba:	68 4b 24 80 00       	push   $0x80244b
  8000bf:	e8 7a 19 00 00       	call   801a3e <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000ca:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d1:	74 14                	je     8000e7 <_main+0xaf>
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	68 50 24 80 00       	push   $0x802450
  8000db:	6a 1a                	push   $0x1a
  8000dd:	68 fc 23 80 00       	push   $0x8023fc
  8000e2:	e8 91 03 00 00       	call   800478 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000e7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000ea:	e8 8c 1b 00 00       	call   801c7b <sys_calculate_free_frames>
  8000ef:	29 c3                	sub    %eax,%ebx
  8000f1:	89 d8                	mov    %ebx,%eax
  8000f3:	83 f8 04             	cmp    $0x4,%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 bc 24 80 00       	push   $0x8024bc
  800100:	6a 1b                	push   $0x1b
  800102:	68 fc 23 80 00       	push   $0x8023fc
  800107:	e8 6c 03 00 00       	call   800478 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80010c:	e8 6a 1b 00 00       	call   801c7b <sys_calculate_free_frames>
  800111:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	6a 01                	push   $0x1
  800119:	68 04 10 00 00       	push   $0x1004
  80011e:	68 3a 25 80 00       	push   $0x80253a
  800123:	e8 16 19 00 00       	call   801a3e <smalloc>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80012e:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 50 24 80 00       	push   $0x802450
  80013f:	6a 1f                	push   $0x1f
  800141:	68 fc 23 80 00       	push   $0x8023fc
  800146:	e8 2d 03 00 00       	call   800478 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80014b:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80014e:	e8 28 1b 00 00       	call   801c7b <sys_calculate_free_frames>
  800153:	29 c3                	sub    %eax,%ebx
  800155:	89 d8                	mov    %ebx,%eax
  800157:	83 f8 04             	cmp    $0x4,%eax
  80015a:	74 14                	je     800170 <_main+0x138>
  80015c:	83 ec 04             	sub    $0x4,%esp
  80015f:	68 bc 24 80 00       	push   $0x8024bc
  800164:	6a 20                	push   $0x20
  800166:	68 fc 23 80 00       	push   $0x8023fc
  80016b:	e8 08 03 00 00       	call   800478 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800170:	e8 06 1b 00 00       	call   801c7b <sys_calculate_free_frames>
  800175:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("y", 4, 1);
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	6a 01                	push   $0x1
  80017d:	6a 04                	push   $0x4
  80017f:	68 3c 25 80 00       	push   $0x80253c
  800184:	e8 b5 18 00 00       	call   801a3e <smalloc>
  800189:	83 c4 10             	add    $0x10,%esp
  80018c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80018f:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 50 24 80 00       	push   $0x802450
  8001a0:	6a 24                	push   $0x24
  8001a2:	68 fc 23 80 00       	push   $0x8023fc
  8001a7:	e8 cc 02 00 00       	call   800478 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001ac:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001af:	e8 c7 1a 00 00       	call   801c7b <sys_calculate_free_frames>
  8001b4:	29 c3                	sub    %eax,%ebx
  8001b6:	89 d8                	mov    %ebx,%eax
  8001b8:	83 f8 03             	cmp    $0x3,%eax
  8001bb:	74 14                	je     8001d1 <_main+0x199>
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	68 bc 24 80 00       	push   $0x8024bc
  8001c5:	6a 25                	push   $0x25
  8001c7:	68 fc 23 80 00       	push   $0x8023fc
  8001cc:	e8 a7 02 00 00       	call   800478 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	68 40 25 80 00       	push   $0x802540
  8001d9:	e8 3c 05 00 00       	call   80071a <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	68 68 25 80 00       	push   $0x802568
  8001e9:	e8 2c 05 00 00       	call   80071a <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  8001f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  8001f8:	eb 2d                	jmp    800227 <_main+0x1ef>
		{
			x[i] = -1;
  8001fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800204:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800207:	01 d0                	add    %edx,%eax
  800209:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  80020f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800212:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800219:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80021c:	01 d0                	add    %edx,%eax
  80021e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800224:	ff 45 ec             	incl   -0x14(%ebp)
  800227:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  80022e:	7e ca                	jle    8001fa <_main+0x1c2>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  800230:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800237:	eb 18                	jmp    800251 <_main+0x219>
		{
			z[i] = -1;
  800239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800243:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800246:	01 d0                	add    %edx,%eax
  800248:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  80024e:	ff 45 ec             	incl   -0x14(%ebp)
  800251:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800258:	7e df                	jle    800239 <_main+0x201>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80025a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80025d:	8b 00                	mov    (%eax),%eax
  80025f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 90 25 80 00       	push   $0x802590
  80026c:	6a 39                	push   $0x39
  80026e:	68 fc 23 80 00       	push   $0x8023fc
  800273:	e8 00 02 00 00       	call   800478 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027b:	05 fc 0f 00 00       	add    $0xffc,%eax
  800280:	8b 00                	mov    (%eax),%eax
  800282:	83 f8 ff             	cmp    $0xffffffff,%eax
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 90 25 80 00       	push   $0x802590
  80028f:	6a 3a                	push   $0x3a
  800291:	68 fc 23 80 00       	push   $0x8023fc
  800296:	e8 dd 01 00 00       	call   800478 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80029b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80029e:	8b 00                	mov    (%eax),%eax
  8002a0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002a3:	74 14                	je     8002b9 <_main+0x281>
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	68 90 25 80 00       	push   $0x802590
  8002ad:	6a 3c                	push   $0x3c
  8002af:	68 fc 23 80 00       	push   $0x8023fc
  8002b4:	e8 bf 01 00 00       	call   800478 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002bc:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002c1:	8b 00                	mov    (%eax),%eax
  8002c3:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002c6:	74 14                	je     8002dc <_main+0x2a4>
  8002c8:	83 ec 04             	sub    $0x4,%esp
  8002cb:	68 90 25 80 00       	push   $0x802590
  8002d0:	6a 3d                	push   $0x3d
  8002d2:	68 fc 23 80 00       	push   $0x8023fc
  8002d7:	e8 9c 01 00 00       	call   800478 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002df:	8b 00                	mov    (%eax),%eax
  8002e1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002e4:	74 14                	je     8002fa <_main+0x2c2>
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	68 90 25 80 00       	push   $0x802590
  8002ee:	6a 3f                	push   $0x3f
  8002f0:	68 fc 23 80 00       	push   $0x8023fc
  8002f5:	e8 7e 01 00 00       	call   800478 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fd:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800302:	8b 00                	mov    (%eax),%eax
  800304:	83 f8 ff             	cmp    $0xffffffff,%eax
  800307:	74 14                	je     80031d <_main+0x2e5>
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 90 25 80 00       	push   $0x802590
  800311:	6a 40                	push   $0x40
  800313:	68 fc 23 80 00       	push   $0x8023fc
  800318:	e8 5b 01 00 00       	call   800478 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80031d:	83 ec 0c             	sub    $0xc,%esp
  800320:	68 bc 25 80 00       	push   $0x8025bc
  800325:	e8 f0 03 00 00       	call   80071a <cprintf>
  80032a:	83 c4 10             	add    $0x10,%esp

	return;
  80032d:	90                   	nop
}
  80032e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800331:	c9                   	leave  
  800332:	c3                   	ret    

00800333 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800339:	e8 72 18 00 00       	call   801bb0 <sys_getenvindex>
  80033e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800341:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800344:	89 d0                	mov    %edx,%eax
  800346:	c1 e0 03             	shl    $0x3,%eax
  800349:	01 d0                	add    %edx,%eax
  80034b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800352:	01 c8                	add    %ecx,%eax
  800354:	01 c0                	add    %eax,%eax
  800356:	01 d0                	add    %edx,%eax
  800358:	01 c0                	add    %eax,%eax
  80035a:	01 d0                	add    %edx,%eax
  80035c:	89 c2                	mov    %eax,%edx
  80035e:	c1 e2 05             	shl    $0x5,%edx
  800361:	29 c2                	sub    %eax,%edx
  800363:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80036a:	89 c2                	mov    %eax,%edx
  80036c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800372:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800377:	a1 20 30 80 00       	mov    0x803020,%eax
  80037c:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800382:	84 c0                	test   %al,%al
  800384:	74 0f                	je     800395 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800386:	a1 20 30 80 00       	mov    0x803020,%eax
  80038b:	05 40 3c 01 00       	add    $0x13c40,%eax
  800390:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800395:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800399:	7e 0a                	jle    8003a5 <libmain+0x72>
		binaryname = argv[0];
  80039b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039e:	8b 00                	mov    (%eax),%eax
  8003a0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	ff 75 0c             	pushl  0xc(%ebp)
  8003ab:	ff 75 08             	pushl  0x8(%ebp)
  8003ae:	e8 85 fc ff ff       	call   800038 <_main>
  8003b3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003b6:	e8 90 19 00 00       	call   801d4b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 28 26 80 00       	push   $0x802628
  8003c3:	e8 52 03 00 00       	call   80071a <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d0:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8003d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003db:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8003e1:	83 ec 04             	sub    $0x4,%esp
  8003e4:	52                   	push   %edx
  8003e5:	50                   	push   %eax
  8003e6:	68 50 26 80 00       	push   $0x802650
  8003eb:	e8 2a 03 00 00       	call   80071a <cprintf>
  8003f0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8003f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f8:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8003fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800403:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800409:	83 ec 04             	sub    $0x4,%esp
  80040c:	52                   	push   %edx
  80040d:	50                   	push   %eax
  80040e:	68 78 26 80 00       	push   $0x802678
  800413:	e8 02 03 00 00       	call   80071a <cprintf>
  800418:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80041b:	a1 20 30 80 00       	mov    0x803020,%eax
  800420:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800426:	83 ec 08             	sub    $0x8,%esp
  800429:	50                   	push   %eax
  80042a:	68 b9 26 80 00       	push   $0x8026b9
  80042f:	e8 e6 02 00 00       	call   80071a <cprintf>
  800434:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800437:	83 ec 0c             	sub    $0xc,%esp
  80043a:	68 28 26 80 00       	push   $0x802628
  80043f:	e8 d6 02 00 00       	call   80071a <cprintf>
  800444:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800447:	e8 19 19 00 00       	call   801d65 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80044c:	e8 19 00 00 00       	call   80046a <exit>
}
  800451:	90                   	nop
  800452:	c9                   	leave  
  800453:	c3                   	ret    

00800454 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80045a:	83 ec 0c             	sub    $0xc,%esp
  80045d:	6a 00                	push   $0x0
  80045f:	e8 18 17 00 00       	call   801b7c <sys_env_destroy>
  800464:	83 c4 10             	add    $0x10,%esp
}
  800467:	90                   	nop
  800468:	c9                   	leave  
  800469:	c3                   	ret    

0080046a <exit>:

void
exit(void)
{
  80046a:	55                   	push   %ebp
  80046b:	89 e5                	mov    %esp,%ebp
  80046d:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800470:	e8 6d 17 00 00       	call   801be2 <sys_env_exit>
}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80047e:	8d 45 10             	lea    0x10(%ebp),%eax
  800481:	83 c0 04             	add    $0x4,%eax
  800484:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800487:	a1 18 31 80 00       	mov    0x803118,%eax
  80048c:	85 c0                	test   %eax,%eax
  80048e:	74 16                	je     8004a6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800490:	a1 18 31 80 00       	mov    0x803118,%eax
  800495:	83 ec 08             	sub    $0x8,%esp
  800498:	50                   	push   %eax
  800499:	68 d0 26 80 00       	push   $0x8026d0
  80049e:	e8 77 02 00 00       	call   80071a <cprintf>
  8004a3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004a6:	a1 00 30 80 00       	mov    0x803000,%eax
  8004ab:	ff 75 0c             	pushl  0xc(%ebp)
  8004ae:	ff 75 08             	pushl  0x8(%ebp)
  8004b1:	50                   	push   %eax
  8004b2:	68 d5 26 80 00       	push   $0x8026d5
  8004b7:	e8 5e 02 00 00       	call   80071a <cprintf>
  8004bc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004c8:	50                   	push   %eax
  8004c9:	e8 e1 01 00 00       	call   8006af <vcprintf>
  8004ce:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004d1:	83 ec 08             	sub    $0x8,%esp
  8004d4:	6a 00                	push   $0x0
  8004d6:	68 f1 26 80 00       	push   $0x8026f1
  8004db:	e8 cf 01 00 00       	call   8006af <vcprintf>
  8004e0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004e3:	e8 82 ff ff ff       	call   80046a <exit>

	// should not return here
	while (1) ;
  8004e8:	eb fe                	jmp    8004e8 <_panic+0x70>

008004ea <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8004f5:	8b 50 74             	mov    0x74(%eax),%edx
  8004f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fb:	39 c2                	cmp    %eax,%edx
  8004fd:	74 14                	je     800513 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	68 f4 26 80 00       	push   $0x8026f4
  800507:	6a 26                	push   $0x26
  800509:	68 40 27 80 00       	push   $0x802740
  80050e:	e8 65 ff ff ff       	call   800478 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800513:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80051a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800521:	e9 b6 00 00 00       	jmp    8005dc <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800529:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800530:	8b 45 08             	mov    0x8(%ebp),%eax
  800533:	01 d0                	add    %edx,%eax
  800535:	8b 00                	mov    (%eax),%eax
  800537:	85 c0                	test   %eax,%eax
  800539:	75 08                	jne    800543 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80053b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80053e:	e9 96 00 00 00       	jmp    8005d9 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800543:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800551:	eb 5d                	jmp    8005b0 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800553:	a1 20 30 80 00       	mov    0x803020,%eax
  800558:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80055e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800561:	c1 e2 04             	shl    $0x4,%edx
  800564:	01 d0                	add    %edx,%eax
  800566:	8a 40 04             	mov    0x4(%eax),%al
  800569:	84 c0                	test   %al,%al
  80056b:	75 40                	jne    8005ad <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80056d:	a1 20 30 80 00       	mov    0x803020,%eax
  800572:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800578:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80057b:	c1 e2 04             	shl    $0x4,%edx
  80057e:	01 d0                	add    %edx,%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800585:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800588:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80058d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80058f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800592:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	01 c8                	add    %ecx,%eax
  80059e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a0:	39 c2                	cmp    %eax,%edx
  8005a2:	75 09                	jne    8005ad <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8005a4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005ab:	eb 12                	jmp    8005bf <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ad:	ff 45 e8             	incl   -0x18(%ebp)
  8005b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b5:	8b 50 74             	mov    0x74(%eax),%edx
  8005b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005bb:	39 c2                	cmp    %eax,%edx
  8005bd:	77 94                	ja     800553 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005c3:	75 14                	jne    8005d9 <CheckWSWithoutLastIndex+0xef>
			panic(
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	68 4c 27 80 00       	push   $0x80274c
  8005cd:	6a 3a                	push   $0x3a
  8005cf:	68 40 27 80 00       	push   $0x802740
  8005d4:	e8 9f fe ff ff       	call   800478 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005d9:	ff 45 f0             	incl   -0x10(%ebp)
  8005dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005e2:	0f 8c 3e ff ff ff    	jl     800526 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005f6:	eb 20                	jmp    800618 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fd:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800603:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800606:	c1 e2 04             	shl    $0x4,%edx
  800609:	01 d0                	add    %edx,%eax
  80060b:	8a 40 04             	mov    0x4(%eax),%al
  80060e:	3c 01                	cmp    $0x1,%al
  800610:	75 03                	jne    800615 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800612:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800615:	ff 45 e0             	incl   -0x20(%ebp)
  800618:	a1 20 30 80 00       	mov    0x803020,%eax
  80061d:	8b 50 74             	mov    0x74(%eax),%edx
  800620:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800623:	39 c2                	cmp    %eax,%edx
  800625:	77 d1                	ja     8005f8 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80062a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80062d:	74 14                	je     800643 <CheckWSWithoutLastIndex+0x159>
		panic(
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	68 a0 27 80 00       	push   $0x8027a0
  800637:	6a 44                	push   $0x44
  800639:	68 40 27 80 00       	push   $0x802740
  80063e:	e8 35 fe ff ff       	call   800478 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800643:	90                   	nop
  800644:	c9                   	leave  
  800645:	c3                   	ret    

00800646 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
  800649:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80064c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	8d 48 01             	lea    0x1(%eax),%ecx
  800654:	8b 55 0c             	mov    0xc(%ebp),%edx
  800657:	89 0a                	mov    %ecx,(%edx)
  800659:	8b 55 08             	mov    0x8(%ebp),%edx
  80065c:	88 d1                	mov    %dl,%cl
  80065e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800661:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800665:	8b 45 0c             	mov    0xc(%ebp),%eax
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80066f:	75 2c                	jne    80069d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800671:	a0 24 30 80 00       	mov    0x803024,%al
  800676:	0f b6 c0             	movzbl %al,%eax
  800679:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067c:	8b 12                	mov    (%edx),%edx
  80067e:	89 d1                	mov    %edx,%ecx
  800680:	8b 55 0c             	mov    0xc(%ebp),%edx
  800683:	83 c2 08             	add    $0x8,%edx
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	50                   	push   %eax
  80068a:	51                   	push   %ecx
  80068b:	52                   	push   %edx
  80068c:	e8 a9 14 00 00       	call   801b3a <sys_cputs>
  800691:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800694:	8b 45 0c             	mov    0xc(%ebp),%eax
  800697:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80069d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a0:	8b 40 04             	mov    0x4(%eax),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ac:	90                   	nop
  8006ad:	c9                   	leave  
  8006ae:	c3                   	ret    

008006af <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006af:	55                   	push   %ebp
  8006b0:	89 e5                	mov    %esp,%ebp
  8006b2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006bf:	00 00 00 
	b.cnt = 0;
  8006c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006c9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006cc:	ff 75 0c             	pushl  0xc(%ebp)
  8006cf:	ff 75 08             	pushl  0x8(%ebp)
  8006d2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006d8:	50                   	push   %eax
  8006d9:	68 46 06 80 00       	push   $0x800646
  8006de:	e8 11 02 00 00       	call   8008f4 <vprintfmt>
  8006e3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8006e6:	a0 24 30 80 00       	mov    0x803024,%al
  8006eb:	0f b6 c0             	movzbl %al,%eax
  8006ee:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	50                   	push   %eax
  8006f8:	52                   	push   %edx
  8006f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ff:	83 c0 08             	add    $0x8,%eax
  800702:	50                   	push   %eax
  800703:	e8 32 14 00 00       	call   801b3a <sys_cputs>
  800708:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80070b:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800712:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <cprintf>:

int cprintf(const char *fmt, ...) {
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800720:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800727:	8d 45 0c             	lea    0xc(%ebp),%eax
  80072a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 f4             	pushl  -0xc(%ebp)
  800736:	50                   	push   %eax
  800737:	e8 73 ff ff ff       	call   8006af <vcprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800742:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800745:	c9                   	leave  
  800746:	c3                   	ret    

00800747 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800747:	55                   	push   %ebp
  800748:	89 e5                	mov    %esp,%ebp
  80074a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80074d:	e8 f9 15 00 00       	call   801d4b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800752:	8d 45 0c             	lea    0xc(%ebp),%eax
  800755:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	ff 75 f4             	pushl  -0xc(%ebp)
  800761:	50                   	push   %eax
  800762:	e8 48 ff ff ff       	call   8006af <vcprintf>
  800767:	83 c4 10             	add    $0x10,%esp
  80076a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80076d:	e8 f3 15 00 00       	call   801d65 <sys_enable_interrupt>
	return cnt;
  800772:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800775:	c9                   	leave  
  800776:	c3                   	ret    

00800777 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	53                   	push   %ebx
  80077b:	83 ec 14             	sub    $0x14,%esp
  80077e:	8b 45 10             	mov    0x10(%ebp),%eax
  800781:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80078a:	8b 45 18             	mov    0x18(%ebp),%eax
  80078d:	ba 00 00 00 00       	mov    $0x0,%edx
  800792:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800795:	77 55                	ja     8007ec <printnum+0x75>
  800797:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80079a:	72 05                	jb     8007a1 <printnum+0x2a>
  80079c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80079f:	77 4b                	ja     8007ec <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007a1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007a4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007a7:	8b 45 18             	mov    0x18(%ebp),%eax
  8007aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8007af:	52                   	push   %edx
  8007b0:	50                   	push   %eax
  8007b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8007b7:	e8 b0 19 00 00       	call   80216c <__udivdi3>
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	ff 75 20             	pushl  0x20(%ebp)
  8007c5:	53                   	push   %ebx
  8007c6:	ff 75 18             	pushl  0x18(%ebp)
  8007c9:	52                   	push   %edx
  8007ca:	50                   	push   %eax
  8007cb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ce:	ff 75 08             	pushl  0x8(%ebp)
  8007d1:	e8 a1 ff ff ff       	call   800777 <printnum>
  8007d6:	83 c4 20             	add    $0x20,%esp
  8007d9:	eb 1a                	jmp    8007f5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 0c             	pushl  0xc(%ebp)
  8007e1:	ff 75 20             	pushl  0x20(%ebp)
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	ff d0                	call   *%eax
  8007e9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007ec:	ff 4d 1c             	decl   0x1c(%ebp)
  8007ef:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007f3:	7f e6                	jg     8007db <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007f5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800800:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800803:	53                   	push   %ebx
  800804:	51                   	push   %ecx
  800805:	52                   	push   %edx
  800806:	50                   	push   %eax
  800807:	e8 70 1a 00 00       	call   80227c <__umoddi3>
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	05 14 2a 80 00       	add    $0x802a14,%eax
  800814:	8a 00                	mov    (%eax),%al
  800816:	0f be c0             	movsbl %al,%eax
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	ff 75 0c             	pushl  0xc(%ebp)
  80081f:	50                   	push   %eax
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	ff d0                	call   *%eax
  800825:	83 c4 10             	add    $0x10,%esp
}
  800828:	90                   	nop
  800829:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082c:	c9                   	leave  
  80082d:	c3                   	ret    

0080082e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800831:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800835:	7e 1c                	jle    800853 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	8d 50 08             	lea    0x8(%eax),%edx
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	89 10                	mov    %edx,(%eax)
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	8b 00                	mov    (%eax),%eax
  800849:	83 e8 08             	sub    $0x8,%eax
  80084c:	8b 50 04             	mov    0x4(%eax),%edx
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	eb 40                	jmp    800893 <getuint+0x65>
	else if (lflag)
  800853:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800857:	74 1e                	je     800877 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	8d 50 04             	lea    0x4(%eax),%edx
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	89 10                	mov    %edx,(%eax)
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	83 e8 04             	sub    $0x4,%eax
  80086e:	8b 00                	mov    (%eax),%eax
  800870:	ba 00 00 00 00       	mov    $0x0,%edx
  800875:	eb 1c                	jmp    800893 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	8d 50 04             	lea    0x4(%eax),%edx
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	89 10                	mov    %edx,(%eax)
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	83 e8 04             	sub    $0x4,%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800898:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80089c:	7e 1c                	jle    8008ba <getint+0x25>
		return va_arg(*ap, long long);
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	8d 50 08             	lea    0x8(%eax),%edx
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	89 10                	mov    %edx,(%eax)
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	83 e8 08             	sub    $0x8,%eax
  8008b3:	8b 50 04             	mov    0x4(%eax),%edx
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	eb 38                	jmp    8008f2 <getint+0x5d>
	else if (lflag)
  8008ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008be:	74 1a                	je     8008da <getint+0x45>
		return va_arg(*ap, long);
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	8d 50 04             	lea    0x4(%eax),%edx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	89 10                	mov    %edx,(%eax)
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	83 e8 04             	sub    $0x4,%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	99                   	cltd   
  8008d8:	eb 18                	jmp    8008f2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	8d 50 04             	lea    0x4(%eax),%edx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	89 10                	mov    %edx,(%eax)
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	83 e8 04             	sub    $0x4,%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	99                   	cltd   
}
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	56                   	push   %esi
  8008f8:	53                   	push   %ebx
  8008f9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008fc:	eb 17                	jmp    800915 <vprintfmt+0x21>
			if (ch == '\0')
  8008fe:	85 db                	test   %ebx,%ebx
  800900:	0f 84 af 03 00 00    	je     800cb5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	53                   	push   %ebx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800915:	8b 45 10             	mov    0x10(%ebp),%eax
  800918:	8d 50 01             	lea    0x1(%eax),%edx
  80091b:	89 55 10             	mov    %edx,0x10(%ebp)
  80091e:	8a 00                	mov    (%eax),%al
  800920:	0f b6 d8             	movzbl %al,%ebx
  800923:	83 fb 25             	cmp    $0x25,%ebx
  800926:	75 d6                	jne    8008fe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800928:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80092c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800933:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80093a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800941:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	8d 50 01             	lea    0x1(%eax),%edx
  80094e:	89 55 10             	mov    %edx,0x10(%ebp)
  800951:	8a 00                	mov    (%eax),%al
  800953:	0f b6 d8             	movzbl %al,%ebx
  800956:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800959:	83 f8 55             	cmp    $0x55,%eax
  80095c:	0f 87 2b 03 00 00    	ja     800c8d <vprintfmt+0x399>
  800962:	8b 04 85 38 2a 80 00 	mov    0x802a38(,%eax,4),%eax
  800969:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80096b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80096f:	eb d7                	jmp    800948 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800971:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800975:	eb d1                	jmp    800948 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800977:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80097e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800981:	89 d0                	mov    %edx,%eax
  800983:	c1 e0 02             	shl    $0x2,%eax
  800986:	01 d0                	add    %edx,%eax
  800988:	01 c0                	add    %eax,%eax
  80098a:	01 d8                	add    %ebx,%eax
  80098c:	83 e8 30             	sub    $0x30,%eax
  80098f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800992:	8b 45 10             	mov    0x10(%ebp),%eax
  800995:	8a 00                	mov    (%eax),%al
  800997:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80099a:	83 fb 2f             	cmp    $0x2f,%ebx
  80099d:	7e 3e                	jle    8009dd <vprintfmt+0xe9>
  80099f:	83 fb 39             	cmp    $0x39,%ebx
  8009a2:	7f 39                	jg     8009dd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009a4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009a7:	eb d5                	jmp    80097e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ac:	83 c0 04             	add    $0x4,%eax
  8009af:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b5:	83 e8 04             	sub    $0x4,%eax
  8009b8:	8b 00                	mov    (%eax),%eax
  8009ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009bd:	eb 1f                	jmp    8009de <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c3:	79 83                	jns    800948 <vprintfmt+0x54>
				width = 0;
  8009c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009cc:	e9 77 ff ff ff       	jmp    800948 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009d1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009d8:	e9 6b ff ff ff       	jmp    800948 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009dd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e2:	0f 89 60 ff ff ff    	jns    800948 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009f5:	e9 4e ff ff ff       	jmp    800948 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009fa:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009fd:	e9 46 ff ff ff       	jmp    800948 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a02:	8b 45 14             	mov    0x14(%ebp),%eax
  800a05:	83 c0 04             	add    $0x4,%eax
  800a08:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0e:	83 e8 04             	sub    $0x4,%eax
  800a11:	8b 00                	mov    (%eax),%eax
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	50                   	push   %eax
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	ff d0                	call   *%eax
  800a1f:	83 c4 10             	add    $0x10,%esp
			break;
  800a22:	e9 89 02 00 00       	jmp    800cb0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a27:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2a:	83 c0 04             	add    $0x4,%eax
  800a2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	83 e8 04             	sub    $0x4,%eax
  800a36:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a38:	85 db                	test   %ebx,%ebx
  800a3a:	79 02                	jns    800a3e <vprintfmt+0x14a>
				err = -err;
  800a3c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a3e:	83 fb 64             	cmp    $0x64,%ebx
  800a41:	7f 0b                	jg     800a4e <vprintfmt+0x15a>
  800a43:	8b 34 9d 80 28 80 00 	mov    0x802880(,%ebx,4),%esi
  800a4a:	85 f6                	test   %esi,%esi
  800a4c:	75 19                	jne    800a67 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a4e:	53                   	push   %ebx
  800a4f:	68 25 2a 80 00       	push   $0x802a25
  800a54:	ff 75 0c             	pushl  0xc(%ebp)
  800a57:	ff 75 08             	pushl  0x8(%ebp)
  800a5a:	e8 5e 02 00 00       	call   800cbd <printfmt>
  800a5f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a62:	e9 49 02 00 00       	jmp    800cb0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a67:	56                   	push   %esi
  800a68:	68 2e 2a 80 00       	push   $0x802a2e
  800a6d:	ff 75 0c             	pushl  0xc(%ebp)
  800a70:	ff 75 08             	pushl  0x8(%ebp)
  800a73:	e8 45 02 00 00       	call   800cbd <printfmt>
  800a78:	83 c4 10             	add    $0x10,%esp
			break;
  800a7b:	e9 30 02 00 00       	jmp    800cb0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a80:	8b 45 14             	mov    0x14(%ebp),%eax
  800a83:	83 c0 04             	add    $0x4,%eax
  800a86:	89 45 14             	mov    %eax,0x14(%ebp)
  800a89:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8c:	83 e8 04             	sub    $0x4,%eax
  800a8f:	8b 30                	mov    (%eax),%esi
  800a91:	85 f6                	test   %esi,%esi
  800a93:	75 05                	jne    800a9a <vprintfmt+0x1a6>
				p = "(null)";
  800a95:	be 31 2a 80 00       	mov    $0x802a31,%esi
			if (width > 0 && padc != '-')
  800a9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a9e:	7e 6d                	jle    800b0d <vprintfmt+0x219>
  800aa0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800aa4:	74 67                	je     800b0d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	50                   	push   %eax
  800aad:	56                   	push   %esi
  800aae:	e8 0c 03 00 00       	call   800dbf <strnlen>
  800ab3:	83 c4 10             	add    $0x10,%esp
  800ab6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ab9:	eb 16                	jmp    800ad1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800abb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	50                   	push   %eax
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	ff d0                	call   *%eax
  800acb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ace:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad5:	7f e4                	jg     800abb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad7:	eb 34                	jmp    800b0d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ad9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800add:	74 1c                	je     800afb <vprintfmt+0x207>
  800adf:	83 fb 1f             	cmp    $0x1f,%ebx
  800ae2:	7e 05                	jle    800ae9 <vprintfmt+0x1f5>
  800ae4:	83 fb 7e             	cmp    $0x7e,%ebx
  800ae7:	7e 12                	jle    800afb <vprintfmt+0x207>
					putch('?', putdat);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	6a 3f                	push   $0x3f
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	ff d0                	call   *%eax
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	eb 0f                	jmp    800b0a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	ff 75 0c             	pushl  0xc(%ebp)
  800b01:	53                   	push   %ebx
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b0d:	89 f0                	mov    %esi,%eax
  800b0f:	8d 70 01             	lea    0x1(%eax),%esi
  800b12:	8a 00                	mov    (%eax),%al
  800b14:	0f be d8             	movsbl %al,%ebx
  800b17:	85 db                	test   %ebx,%ebx
  800b19:	74 24                	je     800b3f <vprintfmt+0x24b>
  800b1b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b1f:	78 b8                	js     800ad9 <vprintfmt+0x1e5>
  800b21:	ff 4d e0             	decl   -0x20(%ebp)
  800b24:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b28:	79 af                	jns    800ad9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b2a:	eb 13                	jmp    800b3f <vprintfmt+0x24b>
				putch(' ', putdat);
  800b2c:	83 ec 08             	sub    $0x8,%esp
  800b2f:	ff 75 0c             	pushl  0xc(%ebp)
  800b32:	6a 20                	push   $0x20
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	ff d0                	call   *%eax
  800b39:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b3c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b43:	7f e7                	jg     800b2c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b45:	e9 66 01 00 00       	jmp    800cb0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	ff 75 e8             	pushl  -0x18(%ebp)
  800b50:	8d 45 14             	lea    0x14(%ebp),%eax
  800b53:	50                   	push   %eax
  800b54:	e8 3c fd ff ff       	call   800895 <getint>
  800b59:	83 c4 10             	add    $0x10,%esp
  800b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b68:	85 d2                	test   %edx,%edx
  800b6a:	79 23                	jns    800b8f <vprintfmt+0x29b>
				putch('-', putdat);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	6a 2d                	push   $0x2d
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b82:	f7 d8                	neg    %eax
  800b84:	83 d2 00             	adc    $0x0,%edx
  800b87:	f7 da                	neg    %edx
  800b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b8f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b96:	e9 bc 00 00 00       	jmp    800c57 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba4:	50                   	push   %eax
  800ba5:	e8 84 fc ff ff       	call   80082e <getuint>
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bb3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bba:	e9 98 00 00 00       	jmp    800c57 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bbf:	83 ec 08             	sub    $0x8,%esp
  800bc2:	ff 75 0c             	pushl  0xc(%ebp)
  800bc5:	6a 58                	push   $0x58
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	ff d0                	call   *%eax
  800bcc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bcf:	83 ec 08             	sub    $0x8,%esp
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	6a 58                	push   $0x58
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	ff d0                	call   *%eax
  800bdc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	6a 58                	push   $0x58
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	ff d0                	call   *%eax
  800bec:	83 c4 10             	add    $0x10,%esp
			break;
  800bef:	e9 bc 00 00 00       	jmp    800cb0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800bf4:	83 ec 08             	sub    $0x8,%esp
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	6a 30                	push   $0x30
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	ff d0                	call   *%eax
  800c01:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c04:	83 ec 08             	sub    $0x8,%esp
  800c07:	ff 75 0c             	pushl  0xc(%ebp)
  800c0a:	6a 78                	push   $0x78
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	ff d0                	call   *%eax
  800c11:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c14:	8b 45 14             	mov    0x14(%ebp),%eax
  800c17:	83 c0 04             	add    $0x4,%eax
  800c1a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c20:	83 e8 04             	sub    $0x4,%eax
  800c23:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c2f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c36:	eb 1f                	jmp    800c57 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c38:	83 ec 08             	sub    $0x8,%esp
  800c3b:	ff 75 e8             	pushl  -0x18(%ebp)
  800c3e:	8d 45 14             	lea    0x14(%ebp),%eax
  800c41:	50                   	push   %eax
  800c42:	e8 e7 fb ff ff       	call   80082e <getuint>
  800c47:	83 c4 10             	add    $0x10,%esp
  800c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c50:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c57:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c5e:	83 ec 04             	sub    $0x4,%esp
  800c61:	52                   	push   %edx
  800c62:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c65:	50                   	push   %eax
  800c66:	ff 75 f4             	pushl  -0xc(%ebp)
  800c69:	ff 75 f0             	pushl  -0x10(%ebp)
  800c6c:	ff 75 0c             	pushl  0xc(%ebp)
  800c6f:	ff 75 08             	pushl  0x8(%ebp)
  800c72:	e8 00 fb ff ff       	call   800777 <printnum>
  800c77:	83 c4 20             	add    $0x20,%esp
			break;
  800c7a:	eb 34                	jmp    800cb0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c7c:	83 ec 08             	sub    $0x8,%esp
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	53                   	push   %ebx
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	ff d0                	call   *%eax
  800c88:	83 c4 10             	add    $0x10,%esp
			break;
  800c8b:	eb 23                	jmp    800cb0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c8d:	83 ec 08             	sub    $0x8,%esp
  800c90:	ff 75 0c             	pushl  0xc(%ebp)
  800c93:	6a 25                	push   $0x25
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	ff d0                	call   *%eax
  800c9a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c9d:	ff 4d 10             	decl   0x10(%ebp)
  800ca0:	eb 03                	jmp    800ca5 <vprintfmt+0x3b1>
  800ca2:	ff 4d 10             	decl   0x10(%ebp)
  800ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca8:	48                   	dec    %eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	3c 25                	cmp    $0x25,%al
  800cad:	75 f3                	jne    800ca2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800caf:	90                   	nop
		}
	}
  800cb0:	e9 47 fc ff ff       	jmp    8008fc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cb5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cb9:	5b                   	pop    %ebx
  800cba:	5e                   	pop    %esi
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    

00800cbd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cc3:	8d 45 10             	lea    0x10(%ebp),%eax
  800cc6:	83 c0 04             	add    $0x4,%eax
  800cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ccc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccf:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd2:	50                   	push   %eax
  800cd3:	ff 75 0c             	pushl  0xc(%ebp)
  800cd6:	ff 75 08             	pushl  0x8(%ebp)
  800cd9:	e8 16 fc ff ff       	call   8008f4 <vprintfmt>
  800cde:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ce1:	90                   	nop
  800ce2:	c9                   	leave  
  800ce3:	c3                   	ret    

00800ce4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cea:	8b 40 08             	mov    0x8(%eax),%eax
  800ced:	8d 50 01             	lea    0x1(%eax),%edx
  800cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf9:	8b 10                	mov    (%eax),%edx
  800cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfe:	8b 40 04             	mov    0x4(%eax),%eax
  800d01:	39 c2                	cmp    %eax,%edx
  800d03:	73 12                	jae    800d17 <sprintputch+0x33>
		*b->buf++ = ch;
  800d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d08:	8b 00                	mov    (%eax),%eax
  800d0a:	8d 48 01             	lea    0x1(%eax),%ecx
  800d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d10:	89 0a                	mov    %ecx,(%edx)
  800d12:	8b 55 08             	mov    0x8(%ebp),%edx
  800d15:	88 10                	mov    %dl,(%eax)
}
  800d17:	90                   	nop
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    

00800d1a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d29:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	01 d0                	add    %edx,%eax
  800d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d3f:	74 06                	je     800d47 <vsnprintf+0x2d>
  800d41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d45:	7f 07                	jg     800d4e <vsnprintf+0x34>
		return -E_INVAL;
  800d47:	b8 03 00 00 00       	mov    $0x3,%eax
  800d4c:	eb 20                	jmp    800d6e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d4e:	ff 75 14             	pushl  0x14(%ebp)
  800d51:	ff 75 10             	pushl  0x10(%ebp)
  800d54:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d57:	50                   	push   %eax
  800d58:	68 e4 0c 80 00       	push   $0x800ce4
  800d5d:	e8 92 fb ff ff       	call   8008f4 <vprintfmt>
  800d62:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d68:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d76:	8d 45 10             	lea    0x10(%ebp),%eax
  800d79:	83 c0 04             	add    $0x4,%eax
  800d7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	ff 75 f4             	pushl  -0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	ff 75 0c             	pushl  0xc(%ebp)
  800d89:	ff 75 08             	pushl  0x8(%ebp)
  800d8c:	e8 89 ff ff ff       	call   800d1a <vsnprintf>
  800d91:	83 c4 10             	add    $0x10,%esp
  800d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d9a:	c9                   	leave  
  800d9b:	c3                   	ret    

00800d9c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800da2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800da9:	eb 06                	jmp    800db1 <strlen+0x15>
		n++;
  800dab:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dae:	ff 45 08             	incl   0x8(%ebp)
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	84 c0                	test   %al,%al
  800db8:	75 f1                	jne    800dab <strlen+0xf>
		n++;
	return n;
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dcc:	eb 09                	jmp    800dd7 <strnlen+0x18>
		n++;
  800dce:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd1:	ff 45 08             	incl   0x8(%ebp)
  800dd4:	ff 4d 0c             	decl   0xc(%ebp)
  800dd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ddb:	74 09                	je     800de6 <strnlen+0x27>
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	84 c0                	test   %al,%al
  800de4:	75 e8                	jne    800dce <strnlen+0xf>
		n++;
	return n;
  800de6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800df7:	90                   	nop
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8d 50 01             	lea    0x1(%eax),%edx
  800dfe:	89 55 08             	mov    %edx,0x8(%ebp)
  800e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e07:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0a:	8a 12                	mov    (%edx),%dl
  800e0c:	88 10                	mov    %dl,(%eax)
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	84 c0                	test   %al,%al
  800e12:	75 e4                	jne    800df8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e17:	c9                   	leave  
  800e18:	c3                   	ret    

00800e19 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2c:	eb 1f                	jmp    800e4d <strncpy+0x34>
		*dst++ = *src;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8d 50 01             	lea    0x1(%eax),%edx
  800e34:	89 55 08             	mov    %edx,0x8(%ebp)
  800e37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3a:	8a 12                	mov    (%edx),%dl
  800e3c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	74 03                	je     800e4a <strncpy+0x31>
			src++;
  800e47:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e4a:	ff 45 fc             	incl   -0x4(%ebp)
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e53:	72 d9                	jb     800e2e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e55:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e6a:	74 30                	je     800e9c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e6c:	eb 16                	jmp    800e84 <strlcpy+0x2a>
			*dst++ = *src++;
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	8d 50 01             	lea    0x1(%eax),%edx
  800e74:	89 55 08             	mov    %edx,0x8(%ebp)
  800e77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e7d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e80:	8a 12                	mov    (%edx),%dl
  800e82:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e84:	ff 4d 10             	decl   0x10(%ebp)
  800e87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8b:	74 09                	je     800e96 <strlcpy+0x3c>
  800e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e90:	8a 00                	mov    (%eax),%al
  800e92:	84 c0                	test   %al,%al
  800e94:	75 d8                	jne    800e6e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	29 c2                	sub    %eax,%edx
  800ea4:	89 d0                	mov    %edx,%eax
}
  800ea6:	c9                   	leave  
  800ea7:	c3                   	ret    

00800ea8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eab:	eb 06                	jmp    800eb3 <strcmp+0xb>
		p++, q++;
  800ead:	ff 45 08             	incl   0x8(%ebp)
  800eb0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	84 c0                	test   %al,%al
  800eba:	74 0e                	je     800eca <strcmp+0x22>
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	8a 10                	mov    (%eax),%dl
  800ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	38 c2                	cmp    %al,%dl
  800ec8:	74 e3                	je     800ead <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	0f b6 d0             	movzbl %al,%edx
  800ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	0f b6 c0             	movzbl %al,%eax
  800eda:	29 c2                	sub    %eax,%edx
  800edc:	89 d0                	mov    %edx,%eax
}
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    

00800ee0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ee3:	eb 09                	jmp    800eee <strncmp+0xe>
		n--, p++, q++;
  800ee5:	ff 4d 10             	decl   0x10(%ebp)
  800ee8:	ff 45 08             	incl   0x8(%ebp)
  800eeb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800eee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef2:	74 17                	je     800f0b <strncmp+0x2b>
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	84 c0                	test   %al,%al
  800efb:	74 0e                	je     800f0b <strncmp+0x2b>
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 10                	mov    (%eax),%dl
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	38 c2                	cmp    %al,%dl
  800f09:	74 da                	je     800ee5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0f:	75 07                	jne    800f18 <strncmp+0x38>
		return 0;
  800f11:	b8 00 00 00 00       	mov    $0x0,%eax
  800f16:	eb 14                	jmp    800f2c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	0f b6 d0             	movzbl %al,%edx
  800f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	0f b6 c0             	movzbl %al,%eax
  800f28:	29 c2                	sub    %eax,%edx
  800f2a:	89 d0                	mov    %edx,%eax
}
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    

00800f2e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	83 ec 04             	sub    $0x4,%esp
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f3a:	eb 12                	jmp    800f4e <strchr+0x20>
		if (*s == c)
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f44:	75 05                	jne    800f4b <strchr+0x1d>
			return (char *) s;
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	eb 11                	jmp    800f5c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f4b:	ff 45 08             	incl   0x8(%ebp)
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	84 c0                	test   %al,%al
  800f55:	75 e5                	jne    800f3c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 04             	sub    $0x4,%esp
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f6a:	eb 0d                	jmp    800f79 <strfind+0x1b>
		if (*s == c)
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f74:	74 0e                	je     800f84 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f76:	ff 45 08             	incl   0x8(%ebp)
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	84 c0                	test   %al,%al
  800f80:	75 ea                	jne    800f6c <strfind+0xe>
  800f82:	eb 01                	jmp    800f85 <strfind+0x27>
		if (*s == c)
			break;
  800f84:	90                   	nop
	return (char *) s;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f96:	8b 45 10             	mov    0x10(%ebp),%eax
  800f99:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f9c:	eb 0e                	jmp    800fac <memset+0x22>
		*p++ = c;
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	8d 50 01             	lea    0x1(%eax),%edx
  800fa4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800faa:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fac:	ff 4d f8             	decl   -0x8(%ebp)
  800faf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fb3:	79 e9                	jns    800f9e <memset+0x14>
		*p++ = c;

	return v;
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb8:	c9                   	leave  
  800fb9:	c3                   	ret    

00800fba <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fcc:	eb 16                	jmp    800fe4 <memcpy+0x2a>
		*d++ = *s++;
  800fce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd1:	8d 50 01             	lea    0x1(%eax),%edx
  800fd4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fda:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fdd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fe0:	8a 12                	mov    (%edx),%dl
  800fe2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800fe4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fea:	89 55 10             	mov    %edx,0x10(%ebp)
  800fed:	85 c0                	test   %eax,%eax
  800fef:	75 dd                	jne    800fce <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801008:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80100e:	73 50                	jae    801060 <memmove+0x6a>
  801010:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801013:	8b 45 10             	mov    0x10(%ebp),%eax
  801016:	01 d0                	add    %edx,%eax
  801018:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80101b:	76 43                	jbe    801060 <memmove+0x6a>
		s += n;
  80101d:	8b 45 10             	mov    0x10(%ebp),%eax
  801020:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801023:	8b 45 10             	mov    0x10(%ebp),%eax
  801026:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801029:	eb 10                	jmp    80103b <memmove+0x45>
			*--d = *--s;
  80102b:	ff 4d f8             	decl   -0x8(%ebp)
  80102e:	ff 4d fc             	decl   -0x4(%ebp)
  801031:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801034:	8a 10                	mov    (%eax),%dl
  801036:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801039:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80103b:	8b 45 10             	mov    0x10(%ebp),%eax
  80103e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801041:	89 55 10             	mov    %edx,0x10(%ebp)
  801044:	85 c0                	test   %eax,%eax
  801046:	75 e3                	jne    80102b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801048:	eb 23                	jmp    80106d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80104a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104d:	8d 50 01             	lea    0x1(%eax),%edx
  801050:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801053:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801056:	8d 4a 01             	lea    0x1(%edx),%ecx
  801059:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80105c:	8a 12                	mov    (%edx),%dl
  80105e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801060:	8b 45 10             	mov    0x10(%ebp),%eax
  801063:	8d 50 ff             	lea    -0x1(%eax),%edx
  801066:	89 55 10             	mov    %edx,0x10(%ebp)
  801069:	85 c0                	test   %eax,%eax
  80106b:	75 dd                	jne    80104a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80107e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801081:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801084:	eb 2a                	jmp    8010b0 <memcmp+0x3e>
		if (*s1 != *s2)
  801086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801089:	8a 10                	mov    (%eax),%dl
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	38 c2                	cmp    %al,%dl
  801092:	74 16                	je     8010aa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	8a 00                	mov    (%eax),%al
  801099:	0f b6 d0             	movzbl %al,%edx
  80109c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	0f b6 c0             	movzbl %al,%eax
  8010a4:	29 c2                	sub    %eax,%edx
  8010a6:	89 d0                	mov    %edx,%eax
  8010a8:	eb 18                	jmp    8010c2 <memcmp+0x50>
		s1++, s2++;
  8010aa:	ff 45 fc             	incl   -0x4(%ebp)
  8010ad:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	75 c9                	jne    801086 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    

008010c4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d0:	01 d0                	add    %edx,%eax
  8010d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010d5:	eb 15                	jmp    8010ec <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	0f b6 d0             	movzbl %al,%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	0f b6 c0             	movzbl %al,%eax
  8010e5:	39 c2                	cmp    %eax,%edx
  8010e7:	74 0d                	je     8010f6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010e9:	ff 45 08             	incl   0x8(%ebp)
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010f2:	72 e3                	jb     8010d7 <memfind+0x13>
  8010f4:	eb 01                	jmp    8010f7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010f6:	90                   	nop
	return (void *) s;
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    

008010fc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801102:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801109:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801110:	eb 03                	jmp    801115 <strtol+0x19>
		s++;
  801112:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	3c 20                	cmp    $0x20,%al
  80111c:	74 f4                	je     801112 <strtol+0x16>
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8a 00                	mov    (%eax),%al
  801123:	3c 09                	cmp    $0x9,%al
  801125:	74 eb                	je     801112 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 2b                	cmp    $0x2b,%al
  80112e:	75 05                	jne    801135 <strtol+0x39>
		s++;
  801130:	ff 45 08             	incl   0x8(%ebp)
  801133:	eb 13                	jmp    801148 <strtol+0x4c>
	else if (*s == '-')
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	3c 2d                	cmp    $0x2d,%al
  80113c:	75 0a                	jne    801148 <strtol+0x4c>
		s++, neg = 1;
  80113e:	ff 45 08             	incl   0x8(%ebp)
  801141:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801148:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114c:	74 06                	je     801154 <strtol+0x58>
  80114e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801152:	75 20                	jne    801174 <strtol+0x78>
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	3c 30                	cmp    $0x30,%al
  80115b:	75 17                	jne    801174 <strtol+0x78>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	40                   	inc    %eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	3c 78                	cmp    $0x78,%al
  801165:	75 0d                	jne    801174 <strtol+0x78>
		s += 2, base = 16;
  801167:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80116b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801172:	eb 28                	jmp    80119c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801178:	75 15                	jne    80118f <strtol+0x93>
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	3c 30                	cmp    $0x30,%al
  801181:	75 0c                	jne    80118f <strtol+0x93>
		s++, base = 8;
  801183:	ff 45 08             	incl   0x8(%ebp)
  801186:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80118d:	eb 0d                	jmp    80119c <strtol+0xa0>
	else if (base == 0)
  80118f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801193:	75 07                	jne    80119c <strtol+0xa0>
		base = 10;
  801195:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	3c 2f                	cmp    $0x2f,%al
  8011a3:	7e 19                	jle    8011be <strtol+0xc2>
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3c 39                	cmp    $0x39,%al
  8011ac:	7f 10                	jg     8011be <strtol+0xc2>
			dig = *s - '0';
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	8a 00                	mov    (%eax),%al
  8011b3:	0f be c0             	movsbl %al,%eax
  8011b6:	83 e8 30             	sub    $0x30,%eax
  8011b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011bc:	eb 42                	jmp    801200 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	3c 60                	cmp    $0x60,%al
  8011c5:	7e 19                	jle    8011e0 <strtol+0xe4>
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	3c 7a                	cmp    $0x7a,%al
  8011ce:	7f 10                	jg     8011e0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f be c0             	movsbl %al,%eax
  8011d8:	83 e8 57             	sub    $0x57,%eax
  8011db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011de:	eb 20                	jmp    801200 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 40                	cmp    $0x40,%al
  8011e7:	7e 39                	jle    801222 <strtol+0x126>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	3c 5a                	cmp    $0x5a,%al
  8011f0:	7f 30                	jg     801222 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	0f be c0             	movsbl %al,%eax
  8011fa:	83 e8 37             	sub    $0x37,%eax
  8011fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801203:	3b 45 10             	cmp    0x10(%ebp),%eax
  801206:	7d 19                	jge    801221 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801208:	ff 45 08             	incl   0x8(%ebp)
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801212:	89 c2                	mov    %eax,%edx
  801214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801217:	01 d0                	add    %edx,%eax
  801219:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80121c:	e9 7b ff ff ff       	jmp    80119c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801221:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801222:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801226:	74 08                	je     801230 <strtol+0x134>
		*endptr = (char *) s;
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	8b 55 08             	mov    0x8(%ebp),%edx
  80122e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801230:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801234:	74 07                	je     80123d <strtol+0x141>
  801236:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801239:	f7 d8                	neg    %eax
  80123b:	eb 03                	jmp    801240 <strtol+0x144>
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <ltostr>:

void
ltostr(long value, char *str)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80124f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801256:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80125a:	79 13                	jns    80126f <ltostr+0x2d>
	{
		neg = 1;
  80125c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801263:	8b 45 0c             	mov    0xc(%ebp),%eax
  801266:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801269:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80126c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801277:	99                   	cltd   
  801278:	f7 f9                	idiv   %ecx
  80127a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80127d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801280:	8d 50 01             	lea    0x1(%eax),%edx
  801283:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801286:	89 c2                	mov    %eax,%edx
  801288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128b:	01 d0                	add    %edx,%eax
  80128d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801290:	83 c2 30             	add    $0x30,%edx
  801293:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801295:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801298:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80129d:	f7 e9                	imul   %ecx
  80129f:	c1 fa 02             	sar    $0x2,%edx
  8012a2:	89 c8                	mov    %ecx,%eax
  8012a4:	c1 f8 1f             	sar    $0x1f,%eax
  8012a7:	29 c2                	sub    %eax,%edx
  8012a9:	89 d0                	mov    %edx,%eax
  8012ab:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012b1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012b6:	f7 e9                	imul   %ecx
  8012b8:	c1 fa 02             	sar    $0x2,%edx
  8012bb:	89 c8                	mov    %ecx,%eax
  8012bd:	c1 f8 1f             	sar    $0x1f,%eax
  8012c0:	29 c2                	sub    %eax,%edx
  8012c2:	89 d0                	mov    %edx,%eax
  8012c4:	c1 e0 02             	shl    $0x2,%eax
  8012c7:	01 d0                	add    %edx,%eax
  8012c9:	01 c0                	add    %eax,%eax
  8012cb:	29 c1                	sub    %eax,%ecx
  8012cd:	89 ca                	mov    %ecx,%edx
  8012cf:	85 d2                	test   %edx,%edx
  8012d1:	75 9c                	jne    80126f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012dd:	48                   	dec    %eax
  8012de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012e5:	74 3d                	je     801324 <ltostr+0xe2>
		start = 1 ;
  8012e7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012ee:	eb 34                	jmp    801324 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8012f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f6:	01 d0                	add    %edx,%eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801300:	8b 45 0c             	mov    0xc(%ebp),%eax
  801303:	01 c2                	add    %eax,%edx
  801305:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130b:	01 c8                	add    %ecx,%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801311:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	01 c2                	add    %eax,%edx
  801319:	8a 45 eb             	mov    -0x15(%ebp),%al
  80131c:	88 02                	mov    %al,(%edx)
		start++ ;
  80131e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801321:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801327:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80132a:	7c c4                	jl     8012f0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80132c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80132f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801332:	01 d0                	add    %edx,%eax
  801334:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801337:	90                   	nop
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801340:	ff 75 08             	pushl  0x8(%ebp)
  801343:	e8 54 fa ff ff       	call   800d9c <strlen>
  801348:	83 c4 04             	add    $0x4,%esp
  80134b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80134e:	ff 75 0c             	pushl  0xc(%ebp)
  801351:	e8 46 fa ff ff       	call   800d9c <strlen>
  801356:	83 c4 04             	add    $0x4,%esp
  801359:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80135c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136a:	eb 17                	jmp    801383 <strcconcat+0x49>
		final[s] = str1[s] ;
  80136c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80136f:	8b 45 10             	mov    0x10(%ebp),%eax
  801372:	01 c2                	add    %eax,%edx
  801374:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	01 c8                	add    %ecx,%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801380:	ff 45 fc             	incl   -0x4(%ebp)
  801383:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801386:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801389:	7c e1                	jl     80136c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80138b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801392:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801399:	eb 1f                	jmp    8013ba <strcconcat+0x80>
		final[s++] = str2[i] ;
  80139b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80139e:	8d 50 01             	lea    0x1(%eax),%edx
  8013a1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013a4:	89 c2                	mov    %eax,%edx
  8013a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a9:	01 c2                	add    %eax,%edx
  8013ab:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b1:	01 c8                	add    %ecx,%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013b7:	ff 45 f8             	incl   -0x8(%ebp)
  8013ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013c0:	7c d9                	jl     80139b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c8:	01 d0                	add    %edx,%eax
  8013ca:	c6 00 00             	movb   $0x0,(%eax)
}
  8013cd:	90                   	nop
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 d0                	add    %edx,%eax
  8013ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013f3:	eb 0c                	jmp    801401 <strsplit+0x31>
			*string++ = 0;
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8d 50 01             	lea    0x1(%eax),%edx
  8013fb:	89 55 08             	mov    %edx,0x8(%ebp)
  8013fe:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	84 c0                	test   %al,%al
  801408:	74 18                	je     801422 <strsplit+0x52>
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	0f be c0             	movsbl %al,%eax
  801412:	50                   	push   %eax
  801413:	ff 75 0c             	pushl  0xc(%ebp)
  801416:	e8 13 fb ff ff       	call   800f2e <strchr>
  80141b:	83 c4 08             	add    $0x8,%esp
  80141e:	85 c0                	test   %eax,%eax
  801420:	75 d3                	jne    8013f5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	84 c0                	test   %al,%al
  801429:	74 5a                	je     801485 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80142b:	8b 45 14             	mov    0x14(%ebp),%eax
  80142e:	8b 00                	mov    (%eax),%eax
  801430:	83 f8 0f             	cmp    $0xf,%eax
  801433:	75 07                	jne    80143c <strsplit+0x6c>
		{
			return 0;
  801435:	b8 00 00 00 00       	mov    $0x0,%eax
  80143a:	eb 66                	jmp    8014a2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80143c:	8b 45 14             	mov    0x14(%ebp),%eax
  80143f:	8b 00                	mov    (%eax),%eax
  801441:	8d 48 01             	lea    0x1(%eax),%ecx
  801444:	8b 55 14             	mov    0x14(%ebp),%edx
  801447:	89 0a                	mov    %ecx,(%edx)
  801449:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801450:	8b 45 10             	mov    0x10(%ebp),%eax
  801453:	01 c2                	add    %eax,%edx
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80145a:	eb 03                	jmp    80145f <strsplit+0x8f>
			string++;
  80145c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	84 c0                	test   %al,%al
  801466:	74 8b                	je     8013f3 <strsplit+0x23>
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	8a 00                	mov    (%eax),%al
  80146d:	0f be c0             	movsbl %al,%eax
  801470:	50                   	push   %eax
  801471:	ff 75 0c             	pushl  0xc(%ebp)
  801474:	e8 b5 fa ff ff       	call   800f2e <strchr>
  801479:	83 c4 08             	add    $0x8,%esp
  80147c:	85 c0                	test   %eax,%eax
  80147e:	74 dc                	je     80145c <strsplit+0x8c>
			string++;
	}
  801480:	e9 6e ff ff ff       	jmp    8013f3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801485:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801486:	8b 45 14             	mov    0x14(%ebp),%eax
  801489:	8b 00                	mov    (%eax),%eax
  80148b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801492:	8b 45 10             	mov    0x10(%ebp),%eax
  801495:	01 d0                	add    %edx,%eax
  801497:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80149d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8014aa:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8014b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8014b7:	01 d0                	add    %edx,%eax
  8014b9:	48                   	dec    %eax
  8014ba:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8014bd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8014c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c5:	f7 75 ac             	divl   -0x54(%ebp)
  8014c8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8014cb:	29 d0                	sub    %edx,%eax
  8014cd:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8014d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8014d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8014de:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8014e5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8014ec:	eb 3f                	jmp    80152d <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8014ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014f1:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8014f8:	83 ec 04             	sub    $0x4,%esp
  8014fb:	50                   	push   %eax
  8014fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8014ff:	68 90 2b 80 00       	push   $0x802b90
  801504:	e8 11 f2 ff ff       	call   80071a <cprintf>
  801509:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  80150c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80150f:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801516:	83 ec 04             	sub    $0x4,%esp
  801519:	50                   	push   %eax
  80151a:	ff 75 e8             	pushl  -0x18(%ebp)
  80151d:	68 a5 2b 80 00       	push   $0x802ba5
  801522:	e8 f3 f1 ff ff       	call   80071a <cprintf>
  801527:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  80152a:	ff 45 e8             	incl   -0x18(%ebp)
  80152d:	a1 28 30 80 00       	mov    0x803028,%eax
  801532:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801535:	7c b7                	jl     8014ee <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801537:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  80153e:	e9 42 01 00 00       	jmp    801685 <malloc+0x1e1>
		int flag0=1;
  801543:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  80154a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80154d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801550:	eb 6b                	jmp    8015bd <malloc+0x119>
			for(int k=0;k<count;k++){
  801552:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801559:	eb 42                	jmp    80159d <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  80155b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80155e:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801565:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801568:	39 c2                	cmp    %eax,%edx
  80156a:	77 2e                	ja     80159a <malloc+0xf6>
  80156c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80156f:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801576:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801579:	39 c2                	cmp    %eax,%edx
  80157b:	76 1d                	jbe    80159a <malloc+0xf6>
					ni=arr_add[k].end-i;
  80157d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801580:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80158a:	29 c2                	sub    %eax,%edx
  80158c:	89 d0                	mov    %edx,%eax
  80158e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801591:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801598:	eb 0d                	jmp    8015a7 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  80159a:	ff 45 d8             	incl   -0x28(%ebp)
  80159d:	a1 28 30 80 00       	mov    0x803028,%eax
  8015a2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8015a5:	7c b4                	jl     80155b <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8015a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015ab:	74 09                	je     8015b6 <malloc+0x112>
				flag0=0;
  8015ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8015b4:	eb 16                	jmp    8015cc <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8015b6:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8015bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	01 c2                	add    %eax,%edx
  8015c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015c8:	39 c2                	cmp    %eax,%edx
  8015ca:	77 86                	ja     801552 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8015cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015d0:	0f 84 a2 00 00 00    	je     801678 <malloc+0x1d4>

			int f=1;
  8015d6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  8015dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015e0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8015e3:	89 c8                	mov    %ecx,%eax
  8015e5:	01 c0                	add    %eax,%eax
  8015e7:	01 c8                	add    %ecx,%eax
  8015e9:	c1 e0 02             	shl    $0x2,%eax
  8015ec:	05 20 31 80 00       	add    $0x803120,%eax
  8015f1:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  8015f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8015fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ff:	89 d0                	mov    %edx,%eax
  801601:	01 c0                	add    %eax,%eax
  801603:	01 d0                	add    %edx,%eax
  801605:	c1 e0 02             	shl    $0x2,%eax
  801608:	05 24 31 80 00       	add    $0x803124,%eax
  80160d:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  80160f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801612:	89 d0                	mov    %edx,%eax
  801614:	01 c0                	add    %eax,%eax
  801616:	01 d0                	add    %edx,%eax
  801618:	c1 e0 02             	shl    $0x2,%eax
  80161b:	05 28 31 80 00       	add    $0x803128,%eax
  801620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801626:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801629:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801630:	eb 36                	jmp    801668 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801632:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	01 c2                	add    %eax,%edx
  80163a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80163d:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801644:	39 c2                	cmp    %eax,%edx
  801646:	73 1d                	jae    801665 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801648:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80164b:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801655:	29 c2                	sub    %eax,%edx
  801657:	89 d0                	mov    %edx,%eax
  801659:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  80165c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801663:	eb 0d                	jmp    801672 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801665:	ff 45 d0             	incl   -0x30(%ebp)
  801668:	a1 28 30 80 00       	mov    0x803028,%eax
  80166d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801670:	7c c0                	jl     801632 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801672:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801676:	75 1d                	jne    801695 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801678:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  80167f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801682:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801685:	a1 04 30 80 00       	mov    0x803004,%eax
  80168a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80168d:	0f 8c b0 fe ff ff    	jl     801543 <malloc+0x9f>
  801693:	eb 01                	jmp    801696 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801695:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801696:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80169a:	75 7a                	jne    801716 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  80169c:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	01 d0                	add    %edx,%eax
  8016a7:	48                   	dec    %eax
  8016a8:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8016ad:	7c 0a                	jl     8016b9 <malloc+0x215>
			return NULL;
  8016af:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b4:	e9 a4 02 00 00       	jmp    80195d <malloc+0x4b9>
		else{
			uint32 s=base_add;
  8016b9:	a1 04 30 80 00       	mov    0x803004,%eax
  8016be:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8016c1:	a1 28 30 80 00       	mov    0x803028,%eax
  8016c6:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8016c9:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  8016d0:	83 ec 08             	sub    $0x8,%esp
  8016d3:	ff 75 08             	pushl  0x8(%ebp)
  8016d6:	ff 75 a4             	pushl  -0x5c(%ebp)
  8016d9:	e8 04 06 00 00       	call   801ce2 <sys_allocateMem>
  8016de:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  8016e1:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	01 d0                	add    %edx,%eax
  8016ec:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  8016f1:	a1 28 30 80 00       	mov    0x803028,%eax
  8016f6:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8016fc:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  801703:	a1 28 30 80 00       	mov    0x803028,%eax
  801708:	40                   	inc    %eax
  801709:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  80170e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801711:	e9 47 02 00 00       	jmp    80195d <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801716:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80171d:	e9 ac 00 00 00       	jmp    8017ce <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801722:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801725:	89 d0                	mov    %edx,%eax
  801727:	01 c0                	add    %eax,%eax
  801729:	01 d0                	add    %edx,%eax
  80172b:	c1 e0 02             	shl    $0x2,%eax
  80172e:	05 24 31 80 00       	add    $0x803124,%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801738:	eb 7e                	jmp    8017b8 <malloc+0x314>
			int flag=0;
  80173a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801741:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801748:	eb 57                	jmp    8017a1 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  80174a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80174d:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801754:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801757:	39 c2                	cmp    %eax,%edx
  801759:	77 1a                	ja     801775 <malloc+0x2d1>
  80175b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80175e:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801765:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801768:	39 c2                	cmp    %eax,%edx
  80176a:	76 09                	jbe    801775 <malloc+0x2d1>
								flag=1;
  80176c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801773:	eb 36                	jmp    8017ab <malloc+0x307>
			arr[i].space++;
  801775:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801778:	89 d0                	mov    %edx,%eax
  80177a:	01 c0                	add    %eax,%eax
  80177c:	01 d0                	add    %edx,%eax
  80177e:	c1 e0 02             	shl    $0x2,%eax
  801781:	05 28 31 80 00       	add    $0x803128,%eax
  801786:	8b 00                	mov    (%eax),%eax
  801788:	8d 48 01             	lea    0x1(%eax),%ecx
  80178b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80178e:	89 d0                	mov    %edx,%eax
  801790:	01 c0                	add    %eax,%eax
  801792:	01 d0                	add    %edx,%eax
  801794:	c1 e0 02             	shl    $0x2,%eax
  801797:	05 28 31 80 00       	add    $0x803128,%eax
  80179c:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  80179e:	ff 45 c0             	incl   -0x40(%ebp)
  8017a1:	a1 28 30 80 00       	mov    0x803028,%eax
  8017a6:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  8017a9:	7c 9f                	jl     80174a <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  8017ab:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8017af:	75 19                	jne    8017ca <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8017b1:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8017b8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8017bb:	a1 04 30 80 00       	mov    0x803004,%eax
  8017c0:	39 c2                	cmp    %eax,%edx
  8017c2:	0f 82 72 ff ff ff    	jb     80173a <malloc+0x296>
  8017c8:	eb 01                	jmp    8017cb <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  8017ca:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  8017cb:	ff 45 cc             	incl   -0x34(%ebp)
  8017ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017d4:	0f 8c 48 ff ff ff    	jl     801722 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  8017da:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  8017e1:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  8017e8:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  8017ef:	eb 37                	jmp    801828 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  8017f1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8017f4:	89 d0                	mov    %edx,%eax
  8017f6:	01 c0                	add    %eax,%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	c1 e0 02             	shl    $0x2,%eax
  8017fd:	05 28 31 80 00       	add    $0x803128,%eax
  801802:	8b 00                	mov    (%eax),%eax
  801804:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801807:	7d 1c                	jge    801825 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801809:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80180c:	89 d0                	mov    %edx,%eax
  80180e:	01 c0                	add    %eax,%eax
  801810:	01 d0                	add    %edx,%eax
  801812:	c1 e0 02             	shl    $0x2,%eax
  801815:	05 28 31 80 00       	add    $0x803128,%eax
  80181a:	8b 00                	mov    (%eax),%eax
  80181c:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  80181f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801822:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801825:	ff 45 b4             	incl   -0x4c(%ebp)
  801828:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80182b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80182e:	7c c1                	jl     8017f1 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801830:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801836:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801839:	89 c8                	mov    %ecx,%eax
  80183b:	01 c0                	add    %eax,%eax
  80183d:	01 c8                	add    %ecx,%eax
  80183f:	c1 e0 02             	shl    $0x2,%eax
  801842:	05 20 31 80 00       	add    $0x803120,%eax
  801847:	8b 00                	mov    (%eax),%eax
  801849:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801850:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801856:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801859:	89 c8                	mov    %ecx,%eax
  80185b:	01 c0                	add    %eax,%eax
  80185d:	01 c8                	add    %ecx,%eax
  80185f:	c1 e0 02             	shl    $0x2,%eax
  801862:	05 24 31 80 00       	add    $0x803124,%eax
  801867:	8b 00                	mov    (%eax),%eax
  801869:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  801870:	a1 28 30 80 00       	mov    0x803028,%eax
  801875:	40                   	inc    %eax
  801876:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  80187b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80187e:	89 d0                	mov    %edx,%eax
  801880:	01 c0                	add    %eax,%eax
  801882:	01 d0                	add    %edx,%eax
  801884:	c1 e0 02             	shl    $0x2,%eax
  801887:	05 20 31 80 00       	add    $0x803120,%eax
  80188c:	8b 00                	mov    (%eax),%eax
  80188e:	83 ec 08             	sub    $0x8,%esp
  801891:	ff 75 08             	pushl  0x8(%ebp)
  801894:	50                   	push   %eax
  801895:	e8 48 04 00 00       	call   801ce2 <sys_allocateMem>
  80189a:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  80189d:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8018a4:	eb 78                	jmp    80191e <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8018a6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8018a9:	89 d0                	mov    %edx,%eax
  8018ab:	01 c0                	add    %eax,%eax
  8018ad:	01 d0                	add    %edx,%eax
  8018af:	c1 e0 02             	shl    $0x2,%eax
  8018b2:	05 20 31 80 00       	add    $0x803120,%eax
  8018b7:	8b 00                	mov    (%eax),%eax
  8018b9:	83 ec 04             	sub    $0x4,%esp
  8018bc:	50                   	push   %eax
  8018bd:	ff 75 b0             	pushl  -0x50(%ebp)
  8018c0:	68 90 2b 80 00       	push   $0x802b90
  8018c5:	e8 50 ee ff ff       	call   80071a <cprintf>
  8018ca:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8018cd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8018d0:	89 d0                	mov    %edx,%eax
  8018d2:	01 c0                	add    %eax,%eax
  8018d4:	01 d0                	add    %edx,%eax
  8018d6:	c1 e0 02             	shl    $0x2,%eax
  8018d9:	05 24 31 80 00       	add    $0x803124,%eax
  8018de:	8b 00                	mov    (%eax),%eax
  8018e0:	83 ec 04             	sub    $0x4,%esp
  8018e3:	50                   	push   %eax
  8018e4:	ff 75 b0             	pushl  -0x50(%ebp)
  8018e7:	68 a5 2b 80 00       	push   $0x802ba5
  8018ec:	e8 29 ee ff ff       	call   80071a <cprintf>
  8018f1:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  8018f4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8018f7:	89 d0                	mov    %edx,%eax
  8018f9:	01 c0                	add    %eax,%eax
  8018fb:	01 d0                	add    %edx,%eax
  8018fd:	c1 e0 02             	shl    $0x2,%eax
  801900:	05 28 31 80 00       	add    $0x803128,%eax
  801905:	8b 00                	mov    (%eax),%eax
  801907:	83 ec 04             	sub    $0x4,%esp
  80190a:	50                   	push   %eax
  80190b:	ff 75 b0             	pushl  -0x50(%ebp)
  80190e:	68 b8 2b 80 00       	push   $0x802bb8
  801913:	e8 02 ee ff ff       	call   80071a <cprintf>
  801918:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  80191b:	ff 45 b0             	incl   -0x50(%ebp)
  80191e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801921:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801924:	7c 80                	jl     8018a6 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801926:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801929:	89 d0                	mov    %edx,%eax
  80192b:	01 c0                	add    %eax,%eax
  80192d:	01 d0                	add    %edx,%eax
  80192f:	c1 e0 02             	shl    $0x2,%eax
  801932:	05 20 31 80 00       	add    $0x803120,%eax
  801937:	8b 00                	mov    (%eax),%eax
  801939:	83 ec 08             	sub    $0x8,%esp
  80193c:	50                   	push   %eax
  80193d:	68 cc 2b 80 00       	push   $0x802bcc
  801942:	e8 d3 ed ff ff       	call   80071a <cprintf>
  801947:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  80194a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80194d:	89 d0                	mov    %edx,%eax
  80194f:	01 c0                	add    %eax,%eax
  801951:	01 d0                	add    %edx,%eax
  801953:	c1 e0 02             	shl    $0x2,%eax
  801956:	05 20 31 80 00       	add    $0x803120,%eax
  80195b:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  80196b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801972:	eb 4b                	jmp    8019bf <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801977:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80197e:	89 c2                	mov    %eax,%edx
  801980:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801983:	39 c2                	cmp    %eax,%edx
  801985:	7f 35                	jg     8019bc <free+0x5d>
  801987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80198a:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801991:	89 c2                	mov    %eax,%edx
  801993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801996:	39 c2                	cmp    %eax,%edx
  801998:	7e 22                	jle    8019bc <free+0x5d>
				start=arr_add[i].start;
  80199a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199d:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8019a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8019a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019aa:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8019b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8019b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8019ba:	eb 0d                	jmp    8019c9 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8019bc:	ff 45 ec             	incl   -0x14(%ebp)
  8019bf:	a1 28 30 80 00       	mov    0x803028,%eax
  8019c4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8019c7:	7c ab                	jl     801974 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8019c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cc:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8019d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d6:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8019dd:	29 c2                	sub    %eax,%edx
  8019df:	89 d0                	mov    %edx,%eax
  8019e1:	83 ec 08             	sub    $0x8,%esp
  8019e4:	50                   	push   %eax
  8019e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e8:	e8 d9 02 00 00       	call   801cc6 <sys_freeMem>
  8019ed:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  8019f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019f6:	eb 2d                	jmp    801a25 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  8019f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019fb:	40                   	inc    %eax
  8019fc:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801a03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a06:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a10:	40                   	inc    %eax
  801a11:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a1b:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801a22:	ff 45 e8             	incl   -0x18(%ebp)
  801a25:	a1 28 30 80 00       	mov    0x803028,%eax
  801a2a:	48                   	dec    %eax
  801a2b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a2e:	7f c8                	jg     8019f8 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801a30:	a1 28 30 80 00       	mov    0x803028,%eax
  801a35:	48                   	dec    %eax
  801a36:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801a3b:	90                   	nop
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	83 ec 18             	sub    $0x18,%esp
  801a44:	8b 45 10             	mov    0x10(%ebp),%eax
  801a47:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801a4a:	83 ec 04             	sub    $0x4,%esp
  801a4d:	68 e8 2b 80 00       	push   $0x802be8
  801a52:	68 18 01 00 00       	push   $0x118
  801a57:	68 0b 2c 80 00       	push   $0x802c0b
  801a5c:	e8 17 ea ff ff       	call   800478 <_panic>

00801a61 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a67:	83 ec 04             	sub    $0x4,%esp
  801a6a:	68 e8 2b 80 00       	push   $0x802be8
  801a6f:	68 1e 01 00 00       	push   $0x11e
  801a74:	68 0b 2c 80 00       	push   $0x802c0b
  801a79:	e8 fa e9 ff ff       	call   800478 <_panic>

00801a7e <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	68 e8 2b 80 00       	push   $0x802be8
  801a8c:	68 24 01 00 00       	push   $0x124
  801a91:	68 0b 2c 80 00       	push   $0x802c0b
  801a96:	e8 dd e9 ff ff       	call   800478 <_panic>

00801a9b <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801aa1:	83 ec 04             	sub    $0x4,%esp
  801aa4:	68 e8 2b 80 00       	push   $0x802be8
  801aa9:	68 29 01 00 00       	push   $0x129
  801aae:	68 0b 2c 80 00       	push   $0x802c0b
  801ab3:	e8 c0 e9 ff ff       	call   800478 <_panic>

00801ab8 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801abe:	83 ec 04             	sub    $0x4,%esp
  801ac1:	68 e8 2b 80 00       	push   $0x802be8
  801ac6:	68 2f 01 00 00       	push   $0x12f
  801acb:	68 0b 2c 80 00       	push   $0x802c0b
  801ad0:	e8 a3 e9 ff ff       	call   800478 <_panic>

00801ad5 <shrink>:
}
void shrink(uint32 newSize)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801adb:	83 ec 04             	sub    $0x4,%esp
  801ade:	68 e8 2b 80 00       	push   $0x802be8
  801ae3:	68 33 01 00 00       	push   $0x133
  801ae8:	68 0b 2c 80 00       	push   $0x802c0b
  801aed:	e8 86 e9 ff ff       	call   800478 <_panic>

00801af2 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801af8:	83 ec 04             	sub    $0x4,%esp
  801afb:	68 e8 2b 80 00       	push   $0x802be8
  801b00:	68 38 01 00 00       	push   $0x138
  801b05:	68 0b 2c 80 00       	push   $0x802c0b
  801b0a:	e8 69 e9 ff ff       	call   800478 <_panic>

00801b0f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	57                   	push   %edi
  801b13:	56                   	push   %esi
  801b14:	53                   	push   %ebx
  801b15:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b18:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b21:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b24:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b27:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b2a:	cd 30                	int    $0x30
  801b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b32:	83 c4 10             	add    $0x10,%esp
  801b35:	5b                   	pop    %ebx
  801b36:	5e                   	pop    %esi
  801b37:	5f                   	pop    %edi
  801b38:	5d                   	pop    %ebp
  801b39:	c3                   	ret    

00801b3a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 04             	sub    $0x4,%esp
  801b40:	8b 45 10             	mov    0x10(%ebp),%eax
  801b43:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b46:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	52                   	push   %edx
  801b52:	ff 75 0c             	pushl  0xc(%ebp)
  801b55:	50                   	push   %eax
  801b56:	6a 00                	push   $0x0
  801b58:	e8 b2 ff ff ff       	call   801b0f <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	90                   	nop
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 01                	push   $0x1
  801b72:	e8 98 ff ff ff       	call   801b0f <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	50                   	push   %eax
  801b8b:	6a 05                	push   $0x5
  801b8d:	e8 7d ff ff ff       	call   801b0f <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 02                	push   $0x2
  801ba6:	e8 64 ff ff ff       	call   801b0f <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 03                	push   $0x3
  801bbf:	e8 4b ff ff ff       	call   801b0f <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 04                	push   $0x4
  801bd8:	e8 32 ff ff ff       	call   801b0f <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_env_exit>:


void sys_env_exit(void)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 06                	push   $0x6
  801bf1:	e8 19 ff ff ff       	call   801b0f <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801bff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	52                   	push   %edx
  801c0c:	50                   	push   %eax
  801c0d:	6a 07                	push   $0x7
  801c0f:	e8 fb fe ff ff       	call   801b0f <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	56                   	push   %esi
  801c1d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c1e:	8b 75 18             	mov    0x18(%ebp),%esi
  801c21:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	56                   	push   %esi
  801c2e:	53                   	push   %ebx
  801c2f:	51                   	push   %ecx
  801c30:	52                   	push   %edx
  801c31:	50                   	push   %eax
  801c32:	6a 08                	push   $0x8
  801c34:	e8 d6 fe ff ff       	call   801b0f <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c3f:	5b                   	pop    %ebx
  801c40:	5e                   	pop    %esi
  801c41:	5d                   	pop    %ebp
  801c42:	c3                   	ret    

00801c43 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	52                   	push   %edx
  801c53:	50                   	push   %eax
  801c54:	6a 09                	push   $0x9
  801c56:	e8 b4 fe ff ff       	call   801b0f <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	ff 75 0c             	pushl  0xc(%ebp)
  801c6c:	ff 75 08             	pushl  0x8(%ebp)
  801c6f:	6a 0a                	push   $0xa
  801c71:	e8 99 fe ff ff       	call   801b0f <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 0b                	push   $0xb
  801c8a:	e8 80 fe ff ff       	call   801b0f <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
}
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 0c                	push   $0xc
  801ca3:	e8 67 fe ff ff       	call   801b0f <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 0d                	push   $0xd
  801cbc:	e8 4e fe ff ff       	call   801b0f <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	ff 75 0c             	pushl  0xc(%ebp)
  801cd2:	ff 75 08             	pushl  0x8(%ebp)
  801cd5:	6a 11                	push   $0x11
  801cd7:	e8 33 fe ff ff       	call   801b0f <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
	return;
  801cdf:	90                   	nop
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	ff 75 0c             	pushl  0xc(%ebp)
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	6a 12                	push   $0x12
  801cf3:	e8 17 fe ff ff       	call   801b0f <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfb:	90                   	nop
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 0e                	push   $0xe
  801d0d:	e8 fd fd ff ff       	call   801b0f <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	ff 75 08             	pushl  0x8(%ebp)
  801d25:	6a 0f                	push   $0xf
  801d27:	e8 e3 fd ff ff       	call   801b0f <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 10                	push   $0x10
  801d40:	e8 ca fd ff ff       	call   801b0f <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
}
  801d48:	90                   	nop
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 14                	push   $0x14
  801d5a:	e8 b0 fd ff ff       	call   801b0f <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
}
  801d62:	90                   	nop
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 15                	push   $0x15
  801d74:	e8 96 fd ff ff       	call   801b0f <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
}
  801d7c:	90                   	nop
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <sys_cputc>:


void
sys_cputc(const char c)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	83 ec 04             	sub    $0x4,%esp
  801d85:	8b 45 08             	mov    0x8(%ebp),%eax
  801d88:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d8b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	50                   	push   %eax
  801d98:	6a 16                	push   $0x16
  801d9a:	e8 70 fd ff ff       	call   801b0f <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	90                   	nop
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 17                	push   $0x17
  801db4:	e8 56 fd ff ff       	call   801b0f <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
}
  801dbc:	90                   	nop
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	ff 75 0c             	pushl  0xc(%ebp)
  801dce:	50                   	push   %eax
  801dcf:	6a 18                	push   $0x18
  801dd1:	e8 39 fd ff ff       	call   801b0f <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de1:	8b 45 08             	mov    0x8(%ebp),%eax
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	52                   	push   %edx
  801deb:	50                   	push   %eax
  801dec:	6a 1b                	push   $0x1b
  801dee:	e8 1c fd ff ff       	call   801b0f <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	52                   	push   %edx
  801e08:	50                   	push   %eax
  801e09:	6a 19                	push   $0x19
  801e0b:	e8 ff fc ff ff       	call   801b0f <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
}
  801e13:	90                   	nop
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	52                   	push   %edx
  801e26:	50                   	push   %eax
  801e27:	6a 1a                	push   $0x1a
  801e29:	e8 e1 fc ff ff       	call   801b0f <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
}
  801e31:	90                   	nop
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	83 ec 04             	sub    $0x4,%esp
  801e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e40:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e43:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	6a 00                	push   $0x0
  801e4c:	51                   	push   %ecx
  801e4d:	52                   	push   %edx
  801e4e:	ff 75 0c             	pushl  0xc(%ebp)
  801e51:	50                   	push   %eax
  801e52:	6a 1c                	push   $0x1c
  801e54:	e8 b6 fc ff ff       	call   801b0f <syscall>
  801e59:	83 c4 18             	add    $0x18,%esp
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e64:	8b 45 08             	mov    0x8(%ebp),%eax
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	52                   	push   %edx
  801e6e:	50                   	push   %eax
  801e6f:	6a 1d                	push   $0x1d
  801e71:	e8 99 fc ff ff       	call   801b0f <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	51                   	push   %ecx
  801e8c:	52                   	push   %edx
  801e8d:	50                   	push   %eax
  801e8e:	6a 1e                	push   $0x1e
  801e90:	e8 7a fc ff ff       	call   801b0f <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	52                   	push   %edx
  801eaa:	50                   	push   %eax
  801eab:	6a 1f                	push   $0x1f
  801ead:	e8 5d fc ff ff       	call   801b0f <syscall>
  801eb2:	83 c4 18             	add    $0x18,%esp
}
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 20                	push   $0x20
  801ec6:	e8 44 fc ff ff       	call   801b0f <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	6a 00                	push   $0x0
  801ed8:	ff 75 14             	pushl  0x14(%ebp)
  801edb:	ff 75 10             	pushl  0x10(%ebp)
  801ede:	ff 75 0c             	pushl  0xc(%ebp)
  801ee1:	50                   	push   %eax
  801ee2:	6a 21                	push   $0x21
  801ee4:	e8 26 fc ff ff       	call   801b0f <syscall>
  801ee9:	83 c4 18             	add    $0x18,%esp
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	50                   	push   %eax
  801efd:	6a 22                	push   $0x22
  801eff:	e8 0b fc ff ff       	call   801b0f <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
}
  801f07:	90                   	nop
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	50                   	push   %eax
  801f19:	6a 23                	push   $0x23
  801f1b:	e8 ef fb ff ff       	call   801b0f <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
}
  801f23:	90                   	nop
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f2c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f2f:	8d 50 04             	lea    0x4(%eax),%edx
  801f32:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	52                   	push   %edx
  801f3c:	50                   	push   %eax
  801f3d:	6a 24                	push   $0x24
  801f3f:	e8 cb fb ff ff       	call   801b0f <syscall>
  801f44:	83 c4 18             	add    $0x18,%esp
	return result;
  801f47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f50:	89 01                	mov    %eax,(%ecx)
  801f52:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	c9                   	leave  
  801f59:	c2 04 00             	ret    $0x4

00801f5c <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	ff 75 10             	pushl  0x10(%ebp)
  801f66:	ff 75 0c             	pushl  0xc(%ebp)
  801f69:	ff 75 08             	pushl  0x8(%ebp)
  801f6c:	6a 13                	push   $0x13
  801f6e:	e8 9c fb ff ff       	call   801b0f <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
	return ;
  801f76:	90                   	nop
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 25                	push   $0x25
  801f88:	e8 82 fb ff ff       	call   801b0f <syscall>
  801f8d:	83 c4 18             	add    $0x18,%esp
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	83 ec 04             	sub    $0x4,%esp
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f9e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	50                   	push   %eax
  801fab:	6a 26                	push   $0x26
  801fad:	e8 5d fb ff ff       	call   801b0f <syscall>
  801fb2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb5:	90                   	nop
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <rsttst>:
void rsttst()
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 28                	push   $0x28
  801fc7:	e8 43 fb ff ff       	call   801b0f <syscall>
  801fcc:	83 c4 18             	add    $0x18,%esp
	return ;
  801fcf:	90                   	nop
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 04             	sub    $0x4,%esp
  801fd8:	8b 45 14             	mov    0x14(%ebp),%eax
  801fdb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fde:	8b 55 18             	mov    0x18(%ebp),%edx
  801fe1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fe5:	52                   	push   %edx
  801fe6:	50                   	push   %eax
  801fe7:	ff 75 10             	pushl  0x10(%ebp)
  801fea:	ff 75 0c             	pushl  0xc(%ebp)
  801fed:	ff 75 08             	pushl  0x8(%ebp)
  801ff0:	6a 27                	push   $0x27
  801ff2:	e8 18 fb ff ff       	call   801b0f <syscall>
  801ff7:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffa:	90                   	nop
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <chktst>:
void chktst(uint32 n)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	ff 75 08             	pushl  0x8(%ebp)
  80200b:	6a 29                	push   $0x29
  80200d:	e8 fd fa ff ff       	call   801b0f <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
	return ;
  802015:	90                   	nop
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <inctst>:

void inctst()
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 2a                	push   $0x2a
  802027:	e8 e3 fa ff ff       	call   801b0f <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
	return ;
  80202f:	90                   	nop
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <gettst>:
uint32 gettst()
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 2b                	push   $0x2b
  802041:	e8 c9 fa ff ff       	call   801b0f <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 2c                	push   $0x2c
  80205d:	e8 ad fa ff ff       	call   801b0f <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
  802065:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802068:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80206c:	75 07                	jne    802075 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80206e:	b8 01 00 00 00       	mov    $0x1,%eax
  802073:	eb 05                	jmp    80207a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802075:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 2c                	push   $0x2c
  80208e:	e8 7c fa ff ff       	call   801b0f <syscall>
  802093:	83 c4 18             	add    $0x18,%esp
  802096:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802099:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80209d:	75 07                	jne    8020a6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80209f:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a4:	eb 05                	jmp    8020ab <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 2c                	push   $0x2c
  8020bf:	e8 4b fa ff ff       	call   801b0f <syscall>
  8020c4:	83 c4 18             	add    $0x18,%esp
  8020c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020ca:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020ce:	75 07                	jne    8020d7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d5:	eb 05                	jmp    8020dc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 2c                	push   $0x2c
  8020f0:	e8 1a fa ff ff       	call   801b0f <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
  8020f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020fb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020ff:	75 07                	jne    802108 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802101:	b8 01 00 00 00       	mov    $0x1,%eax
  802106:	eb 05                	jmp    80210d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802108:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	ff 75 08             	pushl  0x8(%ebp)
  80211d:	6a 2d                	push   $0x2d
  80211f:	e8 eb f9 ff ff       	call   801b0f <syscall>
  802124:	83 c4 18             	add    $0x18,%esp
	return ;
  802127:	90                   	nop
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80212e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802131:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802134:	8b 55 0c             	mov    0xc(%ebp),%edx
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	6a 00                	push   $0x0
  80213c:	53                   	push   %ebx
  80213d:	51                   	push   %ecx
  80213e:	52                   	push   %edx
  80213f:	50                   	push   %eax
  802140:	6a 2e                	push   $0x2e
  802142:	e8 c8 f9 ff ff       	call   801b0f <syscall>
  802147:	83 c4 18             	add    $0x18,%esp
}
  80214a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802152:	8b 55 0c             	mov    0xc(%ebp),%edx
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	52                   	push   %edx
  80215f:	50                   	push   %eax
  802160:	6a 2f                	push   $0x2f
  802162:	e8 a8 f9 ff ff       	call   801b0f <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <__udivdi3>:
  80216c:	55                   	push   %ebp
  80216d:	57                   	push   %edi
  80216e:	56                   	push   %esi
  80216f:	53                   	push   %ebx
  802170:	83 ec 1c             	sub    $0x1c,%esp
  802173:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802177:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80217b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80217f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802183:	89 ca                	mov    %ecx,%edx
  802185:	89 f8                	mov    %edi,%eax
  802187:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80218b:	85 f6                	test   %esi,%esi
  80218d:	75 2d                	jne    8021bc <__udivdi3+0x50>
  80218f:	39 cf                	cmp    %ecx,%edi
  802191:	77 65                	ja     8021f8 <__udivdi3+0x8c>
  802193:	89 fd                	mov    %edi,%ebp
  802195:	85 ff                	test   %edi,%edi
  802197:	75 0b                	jne    8021a4 <__udivdi3+0x38>
  802199:	b8 01 00 00 00       	mov    $0x1,%eax
  80219e:	31 d2                	xor    %edx,%edx
  8021a0:	f7 f7                	div    %edi
  8021a2:	89 c5                	mov    %eax,%ebp
  8021a4:	31 d2                	xor    %edx,%edx
  8021a6:	89 c8                	mov    %ecx,%eax
  8021a8:	f7 f5                	div    %ebp
  8021aa:	89 c1                	mov    %eax,%ecx
  8021ac:	89 d8                	mov    %ebx,%eax
  8021ae:	f7 f5                	div    %ebp
  8021b0:	89 cf                	mov    %ecx,%edi
  8021b2:	89 fa                	mov    %edi,%edx
  8021b4:	83 c4 1c             	add    $0x1c,%esp
  8021b7:	5b                   	pop    %ebx
  8021b8:	5e                   	pop    %esi
  8021b9:	5f                   	pop    %edi
  8021ba:	5d                   	pop    %ebp
  8021bb:	c3                   	ret    
  8021bc:	39 ce                	cmp    %ecx,%esi
  8021be:	77 28                	ja     8021e8 <__udivdi3+0x7c>
  8021c0:	0f bd fe             	bsr    %esi,%edi
  8021c3:	83 f7 1f             	xor    $0x1f,%edi
  8021c6:	75 40                	jne    802208 <__udivdi3+0x9c>
  8021c8:	39 ce                	cmp    %ecx,%esi
  8021ca:	72 0a                	jb     8021d6 <__udivdi3+0x6a>
  8021cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8021d0:	0f 87 9e 00 00 00    	ja     802274 <__udivdi3+0x108>
  8021d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021db:	89 fa                	mov    %edi,%edx
  8021dd:	83 c4 1c             	add    $0x1c,%esp
  8021e0:	5b                   	pop    %ebx
  8021e1:	5e                   	pop    %esi
  8021e2:	5f                   	pop    %edi
  8021e3:	5d                   	pop    %ebp
  8021e4:	c3                   	ret    
  8021e5:	8d 76 00             	lea    0x0(%esi),%esi
  8021e8:	31 ff                	xor    %edi,%edi
  8021ea:	31 c0                	xor    %eax,%eax
  8021ec:	89 fa                	mov    %edi,%edx
  8021ee:	83 c4 1c             	add    $0x1c,%esp
  8021f1:	5b                   	pop    %ebx
  8021f2:	5e                   	pop    %esi
  8021f3:	5f                   	pop    %edi
  8021f4:	5d                   	pop    %ebp
  8021f5:	c3                   	ret    
  8021f6:	66 90                	xchg   %ax,%ax
  8021f8:	89 d8                	mov    %ebx,%eax
  8021fa:	f7 f7                	div    %edi
  8021fc:	31 ff                	xor    %edi,%edi
  8021fe:	89 fa                	mov    %edi,%edx
  802200:	83 c4 1c             	add    $0x1c,%esp
  802203:	5b                   	pop    %ebx
  802204:	5e                   	pop    %esi
  802205:	5f                   	pop    %edi
  802206:	5d                   	pop    %ebp
  802207:	c3                   	ret    
  802208:	bd 20 00 00 00       	mov    $0x20,%ebp
  80220d:	89 eb                	mov    %ebp,%ebx
  80220f:	29 fb                	sub    %edi,%ebx
  802211:	89 f9                	mov    %edi,%ecx
  802213:	d3 e6                	shl    %cl,%esi
  802215:	89 c5                	mov    %eax,%ebp
  802217:	88 d9                	mov    %bl,%cl
  802219:	d3 ed                	shr    %cl,%ebp
  80221b:	89 e9                	mov    %ebp,%ecx
  80221d:	09 f1                	or     %esi,%ecx
  80221f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802223:	89 f9                	mov    %edi,%ecx
  802225:	d3 e0                	shl    %cl,%eax
  802227:	89 c5                	mov    %eax,%ebp
  802229:	89 d6                	mov    %edx,%esi
  80222b:	88 d9                	mov    %bl,%cl
  80222d:	d3 ee                	shr    %cl,%esi
  80222f:	89 f9                	mov    %edi,%ecx
  802231:	d3 e2                	shl    %cl,%edx
  802233:	8b 44 24 08          	mov    0x8(%esp),%eax
  802237:	88 d9                	mov    %bl,%cl
  802239:	d3 e8                	shr    %cl,%eax
  80223b:	09 c2                	or     %eax,%edx
  80223d:	89 d0                	mov    %edx,%eax
  80223f:	89 f2                	mov    %esi,%edx
  802241:	f7 74 24 0c          	divl   0xc(%esp)
  802245:	89 d6                	mov    %edx,%esi
  802247:	89 c3                	mov    %eax,%ebx
  802249:	f7 e5                	mul    %ebp
  80224b:	39 d6                	cmp    %edx,%esi
  80224d:	72 19                	jb     802268 <__udivdi3+0xfc>
  80224f:	74 0b                	je     80225c <__udivdi3+0xf0>
  802251:	89 d8                	mov    %ebx,%eax
  802253:	31 ff                	xor    %edi,%edi
  802255:	e9 58 ff ff ff       	jmp    8021b2 <__udivdi3+0x46>
  80225a:	66 90                	xchg   %ax,%ax
  80225c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802260:	89 f9                	mov    %edi,%ecx
  802262:	d3 e2                	shl    %cl,%edx
  802264:	39 c2                	cmp    %eax,%edx
  802266:	73 e9                	jae    802251 <__udivdi3+0xe5>
  802268:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80226b:	31 ff                	xor    %edi,%edi
  80226d:	e9 40 ff ff ff       	jmp    8021b2 <__udivdi3+0x46>
  802272:	66 90                	xchg   %ax,%ax
  802274:	31 c0                	xor    %eax,%eax
  802276:	e9 37 ff ff ff       	jmp    8021b2 <__udivdi3+0x46>
  80227b:	90                   	nop

0080227c <__umoddi3>:
  80227c:	55                   	push   %ebp
  80227d:	57                   	push   %edi
  80227e:	56                   	push   %esi
  80227f:	53                   	push   %ebx
  802280:	83 ec 1c             	sub    $0x1c,%esp
  802283:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802287:	8b 74 24 34          	mov    0x34(%esp),%esi
  80228b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80228f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802293:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802297:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80229b:	89 f3                	mov    %esi,%ebx
  80229d:	89 fa                	mov    %edi,%edx
  80229f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022a3:	89 34 24             	mov    %esi,(%esp)
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	75 1a                	jne    8022c4 <__umoddi3+0x48>
  8022aa:	39 f7                	cmp    %esi,%edi
  8022ac:	0f 86 a2 00 00 00    	jbe    802354 <__umoddi3+0xd8>
  8022b2:	89 c8                	mov    %ecx,%eax
  8022b4:	89 f2                	mov    %esi,%edx
  8022b6:	f7 f7                	div    %edi
  8022b8:	89 d0                	mov    %edx,%eax
  8022ba:	31 d2                	xor    %edx,%edx
  8022bc:	83 c4 1c             	add    $0x1c,%esp
  8022bf:	5b                   	pop    %ebx
  8022c0:	5e                   	pop    %esi
  8022c1:	5f                   	pop    %edi
  8022c2:	5d                   	pop    %ebp
  8022c3:	c3                   	ret    
  8022c4:	39 f0                	cmp    %esi,%eax
  8022c6:	0f 87 ac 00 00 00    	ja     802378 <__umoddi3+0xfc>
  8022cc:	0f bd e8             	bsr    %eax,%ebp
  8022cf:	83 f5 1f             	xor    $0x1f,%ebp
  8022d2:	0f 84 ac 00 00 00    	je     802384 <__umoddi3+0x108>
  8022d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8022dd:	29 ef                	sub    %ebp,%edi
  8022df:	89 fe                	mov    %edi,%esi
  8022e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022e5:	89 e9                	mov    %ebp,%ecx
  8022e7:	d3 e0                	shl    %cl,%eax
  8022e9:	89 d7                	mov    %edx,%edi
  8022eb:	89 f1                	mov    %esi,%ecx
  8022ed:	d3 ef                	shr    %cl,%edi
  8022ef:	09 c7                	or     %eax,%edi
  8022f1:	89 e9                	mov    %ebp,%ecx
  8022f3:	d3 e2                	shl    %cl,%edx
  8022f5:	89 14 24             	mov    %edx,(%esp)
  8022f8:	89 d8                	mov    %ebx,%eax
  8022fa:	d3 e0                	shl    %cl,%eax
  8022fc:	89 c2                	mov    %eax,%edx
  8022fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  802302:	d3 e0                	shl    %cl,%eax
  802304:	89 44 24 04          	mov    %eax,0x4(%esp)
  802308:	8b 44 24 08          	mov    0x8(%esp),%eax
  80230c:	89 f1                	mov    %esi,%ecx
  80230e:	d3 e8                	shr    %cl,%eax
  802310:	09 d0                	or     %edx,%eax
  802312:	d3 eb                	shr    %cl,%ebx
  802314:	89 da                	mov    %ebx,%edx
  802316:	f7 f7                	div    %edi
  802318:	89 d3                	mov    %edx,%ebx
  80231a:	f7 24 24             	mull   (%esp)
  80231d:	89 c6                	mov    %eax,%esi
  80231f:	89 d1                	mov    %edx,%ecx
  802321:	39 d3                	cmp    %edx,%ebx
  802323:	0f 82 87 00 00 00    	jb     8023b0 <__umoddi3+0x134>
  802329:	0f 84 91 00 00 00    	je     8023c0 <__umoddi3+0x144>
  80232f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802333:	29 f2                	sub    %esi,%edx
  802335:	19 cb                	sbb    %ecx,%ebx
  802337:	89 d8                	mov    %ebx,%eax
  802339:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80233d:	d3 e0                	shl    %cl,%eax
  80233f:	89 e9                	mov    %ebp,%ecx
  802341:	d3 ea                	shr    %cl,%edx
  802343:	09 d0                	or     %edx,%eax
  802345:	89 e9                	mov    %ebp,%ecx
  802347:	d3 eb                	shr    %cl,%ebx
  802349:	89 da                	mov    %ebx,%edx
  80234b:	83 c4 1c             	add    $0x1c,%esp
  80234e:	5b                   	pop    %ebx
  80234f:	5e                   	pop    %esi
  802350:	5f                   	pop    %edi
  802351:	5d                   	pop    %ebp
  802352:	c3                   	ret    
  802353:	90                   	nop
  802354:	89 fd                	mov    %edi,%ebp
  802356:	85 ff                	test   %edi,%edi
  802358:	75 0b                	jne    802365 <__umoddi3+0xe9>
  80235a:	b8 01 00 00 00       	mov    $0x1,%eax
  80235f:	31 d2                	xor    %edx,%edx
  802361:	f7 f7                	div    %edi
  802363:	89 c5                	mov    %eax,%ebp
  802365:	89 f0                	mov    %esi,%eax
  802367:	31 d2                	xor    %edx,%edx
  802369:	f7 f5                	div    %ebp
  80236b:	89 c8                	mov    %ecx,%eax
  80236d:	f7 f5                	div    %ebp
  80236f:	89 d0                	mov    %edx,%eax
  802371:	e9 44 ff ff ff       	jmp    8022ba <__umoddi3+0x3e>
  802376:	66 90                	xchg   %ax,%ax
  802378:	89 c8                	mov    %ecx,%eax
  80237a:	89 f2                	mov    %esi,%edx
  80237c:	83 c4 1c             	add    $0x1c,%esp
  80237f:	5b                   	pop    %ebx
  802380:	5e                   	pop    %esi
  802381:	5f                   	pop    %edi
  802382:	5d                   	pop    %ebp
  802383:	c3                   	ret    
  802384:	3b 04 24             	cmp    (%esp),%eax
  802387:	72 06                	jb     80238f <__umoddi3+0x113>
  802389:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80238d:	77 0f                	ja     80239e <__umoddi3+0x122>
  80238f:	89 f2                	mov    %esi,%edx
  802391:	29 f9                	sub    %edi,%ecx
  802393:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802397:	89 14 24             	mov    %edx,(%esp)
  80239a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80239e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023a2:	8b 14 24             	mov    (%esp),%edx
  8023a5:	83 c4 1c             	add    $0x1c,%esp
  8023a8:	5b                   	pop    %ebx
  8023a9:	5e                   	pop    %esi
  8023aa:	5f                   	pop    %edi
  8023ab:	5d                   	pop    %ebp
  8023ac:	c3                   	ret    
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	2b 04 24             	sub    (%esp),%eax
  8023b3:	19 fa                	sbb    %edi,%edx
  8023b5:	89 d1                	mov    %edx,%ecx
  8023b7:	89 c6                	mov    %eax,%esi
  8023b9:	e9 71 ff ff ff       	jmp    80232f <__umoddi3+0xb3>
  8023be:	66 90                	xchg   %ax,%ax
  8023c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8023c4:	72 ea                	jb     8023b0 <__umoddi3+0x134>
  8023c6:	89 d9                	mov    %ebx,%ecx
  8023c8:	e9 62 ff ff ff       	jmp    80232f <__umoddi3+0xb3>
