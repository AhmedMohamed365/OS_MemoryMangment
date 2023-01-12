
obj/user/tst_worstfit:     file format elf32-i386


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
  800031:	e8 e7 0b 00 00       	call   800c1d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 40 08 00 00    	sub    $0x840,%esp
	int Mega = 1024*1024;
  800043:	c7 45 e0 00 00 10 00 	movl   $0x100000,-0x20(%ebp)
	int kilo = 1024;
  80004a:	c7 45 dc 00 04 00 00 	movl   $0x400,-0x24(%ebp)

	int count = 0;
  800051:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	int totalNumberOfTests = 11;
  800058:	c7 45 d4 0b 00 00 00 	movl   $0xb,-0x2c(%ebp)

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  80005f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800062:	01 c0                	add    %eax,%eax
  800064:	89 c7                	mov    %eax,%edi
  800066:	b8 00 00 00 20       	mov    $0x20000000,%eax
  80006b:	ba 00 00 00 00       	mov    $0x0,%edx
  800070:	f7 f7                	div    %edi
  800072:	89 45 d0             	mov    %eax,-0x30(%ebp)
	assert(numOf2MBsInHeap == 256);
  800075:	81 7d d0 00 01 00 00 	cmpl   $0x100,-0x30(%ebp)
  80007c:	74 16                	je     800094 <_main+0x5c>
  80007e:	68 c0 2c 80 00       	push   $0x802cc0
  800083:	68 d7 2c 80 00       	push   $0x802cd7
  800088:	6a 11                	push   $0x11
  80008a:	68 ec 2c 80 00       	push   $0x802cec
  80008f:	e8 ce 0c 00 00       	call   800d62 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	6a 04                	push   $0x4
  800099:	e8 5b 29 00 00       	call   8029f9 <sys_set_uheap_strategy>
  80009e:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  8000a1:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  8000a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000ac:	eb 23                	jmp    8000d1 <_main+0x99>
		{
			if (myEnv->__uptr_pws[i].empty)
  8000ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8000b3:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8000b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8000bc:	c1 e2 04             	shl    $0x4,%edx
  8000bf:	01 d0                	add    %edx,%eax
  8000c1:	8a 40 04             	mov    0x4(%eax),%al
  8000c4:	84 c0                	test   %al,%al
  8000c6:	74 06                	je     8000ce <_main+0x96>
			{
				fullWS = 0;
  8000c8:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  8000cc:	eb 12                	jmp    8000e0 <_main+0xa8>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  8000ce:	ff 45 f0             	incl   -0x10(%ebp)
  8000d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8000d6:	8b 50 74             	mov    0x74(%eax),%edx
  8000d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000dc:	39 c2                	cmp    %eax,%edx
  8000de:	77 ce                	ja     8000ae <_main+0x76>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  8000e0:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 00 2d 80 00       	push   $0x802d00
  8000ee:	6a 23                	push   $0x23
  8000f0:	68 ec 2c 80 00       	push   $0x802cec
  8000f5:	e8 68 0c 00 00       	call   800d62 <_panic>
	}

	int freeFrames ;
	int usedDiskPages;

	cprintf("This test has %d tests. A pass message will be displayed after each one.\n", totalNumberOfTests);
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	ff 75 d4             	pushl  -0x2c(%ebp)
  800100:	68 1c 2d 80 00       	push   $0x802d1c
  800105:	e8 fa 0e 00 00       	call   801004 <cprintf>
  80010a:	83 c4 10             	add    $0x10,%esp

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80010d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800114:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
	int numOfEmptyWSLocs = 0;
  80011b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  800122:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800129:	eb 20                	jmp    80014b <_main+0x113>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  80012b:	a1 20 40 80 00       	mov    0x804020,%eax
  800130:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800136:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800139:	c1 e2 04             	shl    $0x4,%edx
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8a 40 04             	mov    0x4(%eax),%al
  800141:	3c 01                	cmp    $0x1,%al
  800143:	75 03                	jne    800148 <_main+0x110>
			numOfEmptyWSLocs++;
  800145:	ff 45 e8             	incl   -0x18(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  800148:	ff 45 ec             	incl   -0x14(%ebp)
  80014b:	a1 20 40 80 00       	mov    0x804020,%eax
  800150:	8b 50 74             	mov    0x74(%eax),%edx
  800153:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800156:	39 c2                	cmp    %eax,%edx
  800158:	77 d1                	ja     80012b <_main+0xf3>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  80015a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015d:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800160:	7d 14                	jge    800176 <_main+0x13e>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	68 68 2d 80 00       	push   $0x802d68
  80016a:	6a 35                	push   $0x35
  80016c:	68 ec 2c 80 00       	push   $0x802cec
  800171:	e8 ec 0b 00 00       	call   800d62 <_panic>

	void* ptr_allocations[512] = {0};
  800176:	8d 95 c0 f7 ff ff    	lea    -0x840(%ebp),%edx
  80017c:	b9 00 02 00 00       	mov    $0x200,%ecx
  800181:	b8 00 00 00 00       	mov    $0x0,%eax
  800186:	89 d7                	mov    %edx,%edi
  800188:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  80018a:	e8 d6 23 00 00       	call   802565 <sys_calculate_free_frames>
  80018f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800192:	e8 51 24 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  800197:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for(i = 0; i< 256;i++)
  80019a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001a1:	eb 20                	jmp    8001c3 <_main+0x18b>
	{
		ptr_allocations[i] = malloc(2*Mega);
  8001a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a6:	01 c0                	add    %eax,%eax
  8001a8:	83 ec 0c             	sub    $0xc,%esp
  8001ab:	50                   	push   %eax
  8001ac:	e8 dd 1b 00 00       	call   801d8e <malloc>
  8001b1:	83 c4 10             	add    $0x10,%esp
  8001b4:	89 c2                	mov    %eax,%edx
  8001b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001b9:	89 94 85 c0 f7 ff ff 	mov    %edx,-0x840(%ebp,%eax,4)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  8001c0:	ff 45 e4             	incl   -0x1c(%ebp)
  8001c3:	81 7d e4 ff 00 00 00 	cmpl   $0xff,-0x1c(%ebp)
  8001ca:	7e d7                	jle    8001a3 <_main+0x16b>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  8001cc:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  8001d2:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8001d7:	75 4e                	jne    800227 <_main+0x1ef>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  8001d9:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  8001df:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  8001e4:	75 41                	jne    800227 <_main+0x1ef>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  8001e6:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  8001ec:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  8001f1:	75 34                	jne    800227 <_main+0x1ef>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  8001f3:	8b 85 50 f9 ff ff    	mov    -0x6b0(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  8001f9:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  8001fe:	75 27                	jne    800227 <_main+0x1ef>
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800200:	8b 85 18 fa ff ff    	mov    -0x5e8(%ebp),%eax

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  800206:	3d 00 00 c0 92       	cmp    $0x92c00000,%eax
  80020b:	75 1a                	jne    800227 <_main+0x1ef>
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  80020d:	8b 85 e0 fa ff ff    	mov    -0x520(%ebp),%eax
	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800213:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  800218:	75 0d                	jne    800227 <_main+0x1ef>
			(uint32)ptr_allocations[200] != 0x99000000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80021a:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  800220:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  800225:	74 14                	je     80023b <_main+0x203>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  800227:	83 ec 04             	sub    $0x4,%esp
  80022a:	68 b8 2d 80 00       	push   $0x802db8
  80022f:	6a 4a                	push   $0x4a
  800231:	68 ec 2c 80 00       	push   $0x802cec
  800236:	e8 27 0b 00 00       	call   800d62 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80023b:	e8 a8 23 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  800240:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800243:	89 c2                	mov    %eax,%edx
  800245:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800248:	c1 e0 09             	shl    $0x9,%eax
  80024b:	85 c0                	test   %eax,%eax
  80024d:	79 05                	jns    800254 <_main+0x21c>
  80024f:	05 ff 0f 00 00       	add    $0xfff,%eax
  800254:	c1 f8 0c             	sar    $0xc,%eax
  800257:	39 c2                	cmp    %eax,%edx
  800259:	74 14                	je     80026f <_main+0x237>
  80025b:	83 ec 04             	sub    $0x4,%esp
  80025e:	68 f6 2d 80 00       	push   $0x802df6
  800263:	6a 4c                	push   $0x4c
  800265:	68 ec 2c 80 00       	push   $0x802cec
  80026a:	e8 f3 0a 00 00       	call   800d62 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  80026f:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  800272:	e8 ee 22 00 00       	call   802565 <sys_calculate_free_frames>
  800277:	29 c3                	sub    %eax,%ebx
  800279:	89 da                	mov    %ebx,%edx
  80027b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80027e:	c1 e0 09             	shl    $0x9,%eax
  800281:	85 c0                	test   %eax,%eax
  800283:	79 05                	jns    80028a <_main+0x252>
  800285:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80028a:	c1 f8 16             	sar    $0x16,%eax
  80028d:	39 c2                	cmp    %eax,%edx
  80028f:	74 14                	je     8002a5 <_main+0x26d>
  800291:	83 ec 04             	sub    $0x4,%esp
  800294:	68 13 2e 80 00       	push   $0x802e13
  800299:	6a 4d                	push   $0x4d
  80029b:	68 ec 2c 80 00       	push   $0x802cec
  8002a0:	e8 bd 0a 00 00       	call   800d62 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  8002a5:	e8 bb 22 00 00       	call   802565 <sys_calculate_free_frames>
  8002aa:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8002ad:	e8 36 23 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  8002b2:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  8002b5:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	50                   	push   %eax
  8002bf:	e8 85 1f 00 00       	call   802249 <free>
  8002c4:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  8002c7:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
  8002cd:	83 ec 0c             	sub    $0xc,%esp
  8002d0:	50                   	push   %eax
  8002d1:	e8 73 1f 00 00       	call   802249 <free>
  8002d6:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  8002d9:	8b 85 cc f7 ff ff    	mov    -0x834(%ebp),%eax
  8002df:	83 ec 0c             	sub    $0xc,%esp
  8002e2:	50                   	push   %eax
  8002e3:	e8 61 1f 00 00       	call   802249 <free>
  8002e8:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 3 = 6 M
  8002eb:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  8002f1:	83 ec 0c             	sub    $0xc,%esp
  8002f4:	50                   	push   %eax
  8002f5:	e8 4f 1f 00 00       	call   802249 <free>
  8002fa:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  8002fd:	8b 85 f0 f7 ff ff    	mov    -0x810(%ebp),%eax
  800303:	83 ec 0c             	sub    $0xc,%esp
  800306:	50                   	push   %eax
  800307:	e8 3d 1f 00 00       	call   802249 <free>
  80030c:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  80030f:	8b 85 ec f7 ff ff    	mov    -0x814(%ebp),%eax
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	50                   	push   %eax
  800319:	e8 2b 1f 00 00       	call   802249 <free>
  80031e:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[100]);		// Hole 4 = 10 M
  800321:	8b 85 50 f9 ff ff    	mov    -0x6b0(%ebp),%eax
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	50                   	push   %eax
  80032b:	e8 19 1f 00 00       	call   802249 <free>
  800330:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[104]);
  800333:	8b 85 60 f9 ff ff    	mov    -0x6a0(%ebp),%eax
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	50                   	push   %eax
  80033d:	e8 07 1f 00 00       	call   802249 <free>
  800342:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[103]);
  800345:	8b 85 5c f9 ff ff    	mov    -0x6a4(%ebp),%eax
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	50                   	push   %eax
  80034f:	e8 f5 1e 00 00       	call   802249 <free>
  800354:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[102]);
  800357:	8b 85 58 f9 ff ff    	mov    -0x6a8(%ebp),%eax
  80035d:	83 ec 0c             	sub    $0xc,%esp
  800360:	50                   	push   %eax
  800361:	e8 e3 1e 00 00       	call   802249 <free>
  800366:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[101]);
  800369:	8b 85 54 f9 ff ff    	mov    -0x6ac(%ebp),%eax
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	50                   	push   %eax
  800373:	e8 d1 1e 00 00       	call   802249 <free>
  800378:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[200]);		// Hole 5 = 8 M
  80037b:	8b 85 e0 fa ff ff    	mov    -0x520(%ebp),%eax
  800381:	83 ec 0c             	sub    $0xc,%esp
  800384:	50                   	push   %eax
  800385:	e8 bf 1e 00 00       	call   802249 <free>
  80038a:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[201]);
  80038d:	8b 85 e4 fa ff ff    	mov    -0x51c(%ebp),%eax
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	50                   	push   %eax
  800397:	e8 ad 1e 00 00       	call   802249 <free>
  80039c:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[202]);
  80039f:	8b 85 e8 fa ff ff    	mov    -0x518(%ebp),%eax
  8003a5:	83 ec 0c             	sub    $0xc,%esp
  8003a8:	50                   	push   %eax
  8003a9:	e8 9b 1e 00 00       	call   802249 <free>
  8003ae:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[203]);
  8003b1:	8b 85 ec fa ff ff    	mov    -0x514(%ebp),%eax
  8003b7:	83 ec 0c             	sub    $0xc,%esp
  8003ba:	50                   	push   %eax
  8003bb:	e8 89 1e 00 00       	call   802249 <free>
  8003c0:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 15*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8003c3:	e8 20 22 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  8003c8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003cb:	89 d1                	mov    %edx,%ecx
  8003cd:	29 c1                	sub    %eax,%ecx
  8003cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003df:	01 d0                	add    %edx,%eax
  8003e1:	01 c0                	add    %eax,%eax
  8003e3:	85 c0                	test   %eax,%eax
  8003e5:	79 05                	jns    8003ec <_main+0x3b4>
  8003e7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003ec:	c1 f8 0c             	sar    $0xc,%eax
  8003ef:	39 c1                	cmp    %eax,%ecx
  8003f1:	74 14                	je     800407 <_main+0x3cf>
  8003f3:	83 ec 04             	sub    $0x4,%esp
  8003f6:	68 24 2e 80 00       	push   $0x802e24
  8003fb:	6a 63                	push   $0x63
  8003fd:	68 ec 2c 80 00       	push   $0x802cec
  800402:	e8 5b 09 00 00       	call   800d62 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800407:	e8 59 21 00 00       	call   802565 <sys_calculate_free_frames>
  80040c:	89 c2                	mov    %eax,%edx
  80040e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800411:	39 c2                	cmp    %eax,%edx
  800413:	74 14                	je     800429 <_main+0x3f1>
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	68 60 2e 80 00       	push   $0x802e60
  80041d:	6a 64                	push   $0x64
  80041f:	68 ec 2c 80 00       	push   $0x802cec
  800424:	e8 39 09 00 00       	call   800d62 <_panic>

	// Test worst fit
	//[WORST FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  800429:	e8 37 21 00 00       	call   802565 <sys_calculate_free_frames>
  80042e:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800431:	e8 b2 21 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  800436:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	void* tempAddress = malloc(Mega);		// Use Hole 4 -> Hole 4 = 9 M
  800439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	50                   	push   %eax
  800440:	e8 49 19 00 00       	call   801d8e <malloc>
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x8C800000)
  80044b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80044e:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  800453:	74 14                	je     800469 <_main+0x431>
		panic("Worst Fit not working correctly");
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 a0 2e 80 00       	push   $0x802ea0
  80045d:	6a 6c                	push   $0x6c
  80045f:	68 ec 2c 80 00       	push   $0x802cec
  800464:	e8 f9 08 00 00       	call   800d62 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800469:	e8 7a 21 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  80046e:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800471:	89 c2                	mov    %eax,%edx
  800473:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800476:	85 c0                	test   %eax,%eax
  800478:	79 05                	jns    80047f <_main+0x447>
  80047a:	05 ff 0f 00 00       	add    $0xfff,%eax
  80047f:	c1 f8 0c             	sar    $0xc,%eax
  800482:	39 c2                	cmp    %eax,%edx
  800484:	74 14                	je     80049a <_main+0x462>
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 f6 2d 80 00       	push   $0x802df6
  80048e:	6a 6d                	push   $0x6d
  800490:	68 ec 2c 80 00       	push   $0x802cec
  800495:	e8 c8 08 00 00       	call   800d62 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80049a:	e8 c6 20 00 00       	call   802565 <sys_calculate_free_frames>
  80049f:	89 c2                	mov    %eax,%edx
  8004a1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a4:	39 c2                	cmp    %eax,%edx
  8004a6:	74 14                	je     8004bc <_main+0x484>
  8004a8:	83 ec 04             	sub    $0x4,%esp
  8004ab:	68 13 2e 80 00       	push   $0x802e13
  8004b0:	6a 6e                	push   $0x6e
  8004b2:	68 ec 2c 80 00       	push   $0x802cec
  8004b7:	e8 a6 08 00 00       	call   800d62 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8004bc:	ff 45 d8             	incl   -0x28(%ebp)
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c5:	68 c0 2e 80 00       	push   $0x802ec0
  8004ca:	e8 35 0b 00 00       	call   801004 <cprintf>
  8004cf:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8004d2:	e8 8e 20 00 00       	call   802565 <sys_calculate_free_frames>
  8004d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004da:	e8 09 21 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  8004df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(4 * Mega);			// Use Hole 4 -> Hole 4 = 5 M
  8004e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e5:	c1 e0 02             	shl    $0x2,%eax
  8004e8:	83 ec 0c             	sub    $0xc,%esp
  8004eb:	50                   	push   %eax
  8004ec:	e8 9d 18 00 00       	call   801d8e <malloc>
  8004f1:	83 c4 10             	add    $0x10,%esp
  8004f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x8C900000)
  8004f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8004fa:	3d 00 00 90 8c       	cmp    $0x8c900000,%eax
  8004ff:	74 14                	je     800515 <_main+0x4dd>
		panic("Worst Fit not working correctly");
  800501:	83 ec 04             	sub    $0x4,%esp
  800504:	68 a0 2e 80 00       	push   $0x802ea0
  800509:	6a 75                	push   $0x75
  80050b:	68 ec 2c 80 00       	push   $0x802cec
  800510:	e8 4d 08 00 00       	call   800d62 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800515:	e8 ce 20 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  80051a:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80051d:	89 c2                	mov    %eax,%edx
  80051f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800522:	c1 e0 02             	shl    $0x2,%eax
  800525:	85 c0                	test   %eax,%eax
  800527:	79 05                	jns    80052e <_main+0x4f6>
  800529:	05 ff 0f 00 00       	add    $0xfff,%eax
  80052e:	c1 f8 0c             	sar    $0xc,%eax
  800531:	39 c2                	cmp    %eax,%edx
  800533:	74 14                	je     800549 <_main+0x511>
  800535:	83 ec 04             	sub    $0x4,%esp
  800538:	68 f6 2d 80 00       	push   $0x802df6
  80053d:	6a 76                	push   $0x76
  80053f:	68 ec 2c 80 00       	push   $0x802cec
  800544:	e8 19 08 00 00       	call   800d62 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800549:	e8 17 20 00 00       	call   802565 <sys_calculate_free_frames>
  80054e:	89 c2                	mov    %eax,%edx
  800550:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800553:	39 c2                	cmp    %eax,%edx
  800555:	74 14                	je     80056b <_main+0x533>
  800557:	83 ec 04             	sub    $0x4,%esp
  80055a:	68 13 2e 80 00       	push   $0x802e13
  80055f:	6a 77                	push   $0x77
  800561:	68 ec 2c 80 00       	push   $0x802cec
  800566:	e8 f7 07 00 00       	call   800d62 <_panic>
	cprintf("Test %d Passed \n", ++count);
  80056b:	ff 45 d8             	incl   -0x28(%ebp)
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	ff 75 d8             	pushl  -0x28(%ebp)
  800574:	68 c0 2e 80 00       	push   $0x802ec0
  800579:	e8 86 0a 00 00       	call   801004 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800581:	e8 df 1f 00 00       	call   802565 <sys_calculate_free_frames>
  800586:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800589:	e8 5a 20 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  80058e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(6*Mega); 			   // Use Hole 5 -> Hole 5 = 2 M
  800591:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800594:	89 d0                	mov    %edx,%eax
  800596:	01 c0                	add    %eax,%eax
  800598:	01 d0                	add    %edx,%eax
  80059a:	01 c0                	add    %eax,%eax
  80059c:	83 ec 0c             	sub    $0xc,%esp
  80059f:	50                   	push   %eax
  8005a0:	e8 e9 17 00 00       	call   801d8e <malloc>
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x99000000)
  8005ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005ae:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  8005b3:	74 14                	je     8005c9 <_main+0x591>
		panic("Worst Fit not working correctly");
  8005b5:	83 ec 04             	sub    $0x4,%esp
  8005b8:	68 a0 2e 80 00       	push   $0x802ea0
  8005bd:	6a 7e                	push   $0x7e
  8005bf:	68 ec 2c 80 00       	push   $0x802cec
  8005c4:	e8 99 07 00 00       	call   800d62 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  6*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005c9:	e8 1a 20 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  8005ce:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8005d1:	89 c1                	mov    %eax,%ecx
  8005d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005d6:	89 d0                	mov    %edx,%eax
  8005d8:	01 c0                	add    %eax,%eax
  8005da:	01 d0                	add    %edx,%eax
  8005dc:	01 c0                	add    %eax,%eax
  8005de:	85 c0                	test   %eax,%eax
  8005e0:	79 05                	jns    8005e7 <_main+0x5af>
  8005e2:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005e7:	c1 f8 0c             	sar    $0xc,%eax
  8005ea:	39 c1                	cmp    %eax,%ecx
  8005ec:	74 14                	je     800602 <_main+0x5ca>
  8005ee:	83 ec 04             	sub    $0x4,%esp
  8005f1:	68 f6 2d 80 00       	push   $0x802df6
  8005f6:	6a 7f                	push   $0x7f
  8005f8:	68 ec 2c 80 00       	push   $0x802cec
  8005fd:	e8 60 07 00 00       	call   800d62 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800602:	e8 5e 1f 00 00       	call   802565 <sys_calculate_free_frames>
  800607:	89 c2                	mov    %eax,%edx
  800609:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060c:	39 c2                	cmp    %eax,%edx
  80060e:	74 17                	je     800627 <_main+0x5ef>
  800610:	83 ec 04             	sub    $0x4,%esp
  800613:	68 13 2e 80 00       	push   $0x802e13
  800618:	68 80 00 00 00       	push   $0x80
  80061d:	68 ec 2c 80 00       	push   $0x802cec
  800622:	e8 3b 07 00 00       	call   800d62 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800627:	ff 45 d8             	incl   -0x28(%ebp)
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 d8             	pushl  -0x28(%ebp)
  800630:	68 c0 2e 80 00       	push   $0x802ec0
  800635:	e8 ca 09 00 00       	call   801004 <cprintf>
  80063a:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80063d:	e8 23 1f 00 00       	call   802565 <sys_calculate_free_frames>
  800642:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800645:	e8 9e 1f 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  80064a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 3 -> Hole 3 = 1 M
  80064d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800650:	89 d0                	mov    %edx,%eax
  800652:	c1 e0 02             	shl    $0x2,%eax
  800655:	01 d0                	add    %edx,%eax
  800657:	83 ec 0c             	sub    $0xc,%esp
  80065a:	50                   	push   %eax
  80065b:	e8 2e 17 00 00       	call   801d8e <malloc>
  800660:	83 c4 10             	add    $0x10,%esp
  800663:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81400000)
  800666:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800669:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  80066e:	74 17                	je     800687 <_main+0x64f>
		panic("Worst Fit not working correctly");
  800670:	83 ec 04             	sub    $0x4,%esp
  800673:	68 a0 2e 80 00       	push   $0x802ea0
  800678:	68 87 00 00 00       	push   $0x87
  80067d:	68 ec 2c 80 00       	push   $0x802cec
  800682:	e8 db 06 00 00       	call   800d62 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800687:	e8 5c 1f 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  80068c:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80068f:	89 c1                	mov    %eax,%ecx
  800691:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800694:	89 d0                	mov    %edx,%eax
  800696:	c1 e0 02             	shl    $0x2,%eax
  800699:	01 d0                	add    %edx,%eax
  80069b:	85 c0                	test   %eax,%eax
  80069d:	79 05                	jns    8006a4 <_main+0x66c>
  80069f:	05 ff 0f 00 00       	add    $0xfff,%eax
  8006a4:	c1 f8 0c             	sar    $0xc,%eax
  8006a7:	39 c1                	cmp    %eax,%ecx
  8006a9:	74 17                	je     8006c2 <_main+0x68a>
  8006ab:	83 ec 04             	sub    $0x4,%esp
  8006ae:	68 f6 2d 80 00       	push   $0x802df6
  8006b3:	68 88 00 00 00       	push   $0x88
  8006b8:	68 ec 2c 80 00       	push   $0x802cec
  8006bd:	e8 a0 06 00 00       	call   800d62 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8006c2:	e8 9e 1e 00 00       	call   802565 <sys_calculate_free_frames>
  8006c7:	89 c2                	mov    %eax,%edx
  8006c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006cc:	39 c2                	cmp    %eax,%edx
  8006ce:	74 17                	je     8006e7 <_main+0x6af>
  8006d0:	83 ec 04             	sub    $0x4,%esp
  8006d3:	68 13 2e 80 00       	push   $0x802e13
  8006d8:	68 89 00 00 00       	push   $0x89
  8006dd:	68 ec 2c 80 00       	push   $0x802cec
  8006e2:	e8 7b 06 00 00       	call   800d62 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8006e7:	ff 45 d8             	incl   -0x28(%ebp)
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	ff 75 d8             	pushl  -0x28(%ebp)
  8006f0:	68 c0 2e 80 00       	push   $0x802ec0
  8006f5:	e8 0a 09 00 00       	call   801004 <cprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8006fd:	e8 63 1e 00 00       	call   802565 <sys_calculate_free_frames>
  800702:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800705:	e8 de 1e 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  80070a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(4*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  80070d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800710:	c1 e0 02             	shl    $0x2,%eax
  800713:	83 ec 0c             	sub    $0xc,%esp
  800716:	50                   	push   %eax
  800717:	e8 72 16 00 00       	call   801d8e <malloc>
  80071c:	83 c4 10             	add    $0x10,%esp
  80071f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x8CD00000)
  800722:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800725:	3d 00 00 d0 8c       	cmp    $0x8cd00000,%eax
  80072a:	74 17                	je     800743 <_main+0x70b>
		panic("Worst Fit not working correctly");
  80072c:	83 ec 04             	sub    $0x4,%esp
  80072f:	68 a0 2e 80 00       	push   $0x802ea0
  800734:	68 90 00 00 00       	push   $0x90
  800739:	68 ec 2c 80 00       	push   $0x802cec
  80073e:	e8 1f 06 00 00       	call   800d62 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800743:	e8 a0 1e 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  800748:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80074b:	89 c2                	mov    %eax,%edx
  80074d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800750:	c1 e0 02             	shl    $0x2,%eax
  800753:	85 c0                	test   %eax,%eax
  800755:	79 05                	jns    80075c <_main+0x724>
  800757:	05 ff 0f 00 00       	add    $0xfff,%eax
  80075c:	c1 f8 0c             	sar    $0xc,%eax
  80075f:	39 c2                	cmp    %eax,%edx
  800761:	74 17                	je     80077a <_main+0x742>
  800763:	83 ec 04             	sub    $0x4,%esp
  800766:	68 f6 2d 80 00       	push   $0x802df6
  80076b:	68 91 00 00 00       	push   $0x91
  800770:	68 ec 2c 80 00       	push   $0x802cec
  800775:	e8 e8 05 00 00       	call   800d62 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80077a:	e8 e6 1d 00 00       	call   802565 <sys_calculate_free_frames>
  80077f:	89 c2                	mov    %eax,%edx
  800781:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800784:	39 c2                	cmp    %eax,%edx
  800786:	74 17                	je     80079f <_main+0x767>
  800788:	83 ec 04             	sub    $0x4,%esp
  80078b:	68 13 2e 80 00       	push   $0x802e13
  800790:	68 92 00 00 00       	push   $0x92
  800795:	68 ec 2c 80 00       	push   $0x802cec
  80079a:	e8 c3 05 00 00       	call   800d62 <_panic>
	cprintf("Test %d Passed \n", ++count);
  80079f:	ff 45 d8             	incl   -0x28(%ebp)
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a8:	68 c0 2e 80 00       	push   $0x802ec0
  8007ad:	e8 52 08 00 00       	call   801004 <cprintf>
  8007b2:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8007b5:	e8 ab 1d 00 00       	call   802565 <sys_calculate_free_frames>
  8007ba:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8007bd:	e8 26 1e 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  8007c2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(2 * Mega); 			// Use Hole 2 -> Hole 2 = 2 M
  8007c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007c8:	01 c0                	add    %eax,%eax
  8007ca:	83 ec 0c             	sub    $0xc,%esp
  8007cd:	50                   	push   %eax
  8007ce:	e8 bb 15 00 00       	call   801d8e <malloc>
  8007d3:	83 c4 10             	add    $0x10,%esp
  8007d6:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80400000)
  8007d9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8007dc:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  8007e1:	74 17                	je     8007fa <_main+0x7c2>
		panic("Worst Fit not working correctly");
  8007e3:	83 ec 04             	sub    $0x4,%esp
  8007e6:	68 a0 2e 80 00       	push   $0x802ea0
  8007eb:	68 99 00 00 00       	push   $0x99
  8007f0:	68 ec 2c 80 00       	push   $0x802cec
  8007f5:	e8 68 05 00 00       	call   800d62 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8007fa:	e8 e9 1d 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  8007ff:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800802:	89 c2                	mov    %eax,%edx
  800804:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800807:	01 c0                	add    %eax,%eax
  800809:	85 c0                	test   %eax,%eax
  80080b:	79 05                	jns    800812 <_main+0x7da>
  80080d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800812:	c1 f8 0c             	sar    $0xc,%eax
  800815:	39 c2                	cmp    %eax,%edx
  800817:	74 17                	je     800830 <_main+0x7f8>
  800819:	83 ec 04             	sub    $0x4,%esp
  80081c:	68 f6 2d 80 00       	push   $0x802df6
  800821:	68 9a 00 00 00       	push   $0x9a
  800826:	68 ec 2c 80 00       	push   $0x802cec
  80082b:	e8 32 05 00 00       	call   800d62 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800830:	e8 30 1d 00 00       	call   802565 <sys_calculate_free_frames>
  800835:	89 c2                	mov    %eax,%edx
  800837:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80083a:	39 c2                	cmp    %eax,%edx
  80083c:	74 17                	je     800855 <_main+0x81d>
  80083e:	83 ec 04             	sub    $0x4,%esp
  800841:	68 13 2e 80 00       	push   $0x802e13
  800846:	68 9b 00 00 00       	push   $0x9b
  80084b:	68 ec 2c 80 00       	push   $0x802cec
  800850:	e8 0d 05 00 00       	call   800d62 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800855:	ff 45 d8             	incl   -0x28(%ebp)
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	ff 75 d8             	pushl  -0x28(%ebp)
  80085e:	68 c0 2e 80 00       	push   $0x802ec0
  800863:	e8 9c 07 00 00       	call   801004 <cprintf>
  800868:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80086b:	e8 f5 1c 00 00       	call   802565 <sys_calculate_free_frames>
  800870:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800873:	e8 70 1d 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  800878:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(1*Mega + 512*kilo);    // Use Hole 1 -> Hole 1 = 0.5 M
  80087b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80087e:	c1 e0 09             	shl    $0x9,%eax
  800881:	89 c2                	mov    %eax,%edx
  800883:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800886:	01 d0                	add    %edx,%eax
  800888:	83 ec 0c             	sub    $0xc,%esp
  80088b:	50                   	push   %eax
  80088c:	e8 fd 14 00 00       	call   801d8e <malloc>
  800891:	83 c4 10             	add    $0x10,%esp
  800894:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80000000)
  800897:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80089a:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80089f:	74 17                	je     8008b8 <_main+0x880>
		panic("Worst Fit not working correctly");
  8008a1:	83 ec 04             	sub    $0x4,%esp
  8008a4:	68 a0 2e 80 00       	push   $0x802ea0
  8008a9:	68 a2 00 00 00       	push   $0xa2
  8008ae:	68 ec 2c 80 00       	push   $0x802cec
  8008b3:	e8 aa 04 00 00       	call   800d62 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega + 512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  8008b8:	e8 2b 1d 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  8008bd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8008c0:	89 c2                	mov    %eax,%edx
  8008c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008c5:	c1 e0 09             	shl    $0x9,%eax
  8008c8:	89 c1                	mov    %eax,%ecx
  8008ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cd:	01 c8                	add    %ecx,%eax
  8008cf:	85 c0                	test   %eax,%eax
  8008d1:	79 05                	jns    8008d8 <_main+0x8a0>
  8008d3:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008d8:	c1 f8 0c             	sar    $0xc,%eax
  8008db:	39 c2                	cmp    %eax,%edx
  8008dd:	74 17                	je     8008f6 <_main+0x8be>
  8008df:	83 ec 04             	sub    $0x4,%esp
  8008e2:	68 f6 2d 80 00       	push   $0x802df6
  8008e7:	68 a3 00 00 00       	push   $0xa3
  8008ec:	68 ec 2c 80 00       	push   $0x802cec
  8008f1:	e8 6c 04 00 00       	call   800d62 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8008f6:	e8 6a 1c 00 00       	call   802565 <sys_calculate_free_frames>
  8008fb:	89 c2                	mov    %eax,%edx
  8008fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800900:	39 c2                	cmp    %eax,%edx
  800902:	74 17                	je     80091b <_main+0x8e3>
  800904:	83 ec 04             	sub    $0x4,%esp
  800907:	68 13 2e 80 00       	push   $0x802e13
  80090c:	68 a4 00 00 00       	push   $0xa4
  800911:	68 ec 2c 80 00       	push   $0x802cec
  800916:	e8 47 04 00 00       	call   800d62 <_panic>
	cprintf("Test %d Passed \n", ++count);
  80091b:	ff 45 d8             	incl   -0x28(%ebp)
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	ff 75 d8             	pushl  -0x28(%ebp)
  800924:	68 c0 2e 80 00       	push   $0x802ec0
  800929:	e8 d6 06 00 00       	call   801004 <cprintf>
  80092e:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800931:	e8 2f 1c 00 00       	call   802565 <sys_calculate_free_frames>
  800936:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800939:	e8 aa 1c 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  80093e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 2 -> Hole 2 = 1.5 M
  800941:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800944:	c1 e0 09             	shl    $0x9,%eax
  800947:	83 ec 0c             	sub    $0xc,%esp
  80094a:	50                   	push   %eax
  80094b:	e8 3e 14 00 00       	call   801d8e <malloc>
  800950:	83 c4 10             	add    $0x10,%esp
  800953:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80600000)
  800956:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800959:	3d 00 00 60 80       	cmp    $0x80600000,%eax
  80095e:	74 17                	je     800977 <_main+0x93f>
		panic("Worst Fit not working correctly");
  800960:	83 ec 04             	sub    $0x4,%esp
  800963:	68 a0 2e 80 00       	push   $0x802ea0
  800968:	68 ab 00 00 00       	push   $0xab
  80096d:	68 ec 2c 80 00       	push   $0x802cec
  800972:	e8 eb 03 00 00       	call   800d62 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800977:	e8 6c 1c 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  80097c:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80097f:	89 c2                	mov    %eax,%edx
  800981:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800984:	c1 e0 09             	shl    $0x9,%eax
  800987:	85 c0                	test   %eax,%eax
  800989:	79 05                	jns    800990 <_main+0x958>
  80098b:	05 ff 0f 00 00       	add    $0xfff,%eax
  800990:	c1 f8 0c             	sar    $0xc,%eax
  800993:	39 c2                	cmp    %eax,%edx
  800995:	74 17                	je     8009ae <_main+0x976>
  800997:	83 ec 04             	sub    $0x4,%esp
  80099a:	68 f6 2d 80 00       	push   $0x802df6
  80099f:	68 ac 00 00 00       	push   $0xac
  8009a4:	68 ec 2c 80 00       	push   $0x802cec
  8009a9:	e8 b4 03 00 00       	call   800d62 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8009ae:	e8 b2 1b 00 00       	call   802565 <sys_calculate_free_frames>
  8009b3:	89 c2                	mov    %eax,%edx
  8009b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8009b8:	39 c2                	cmp    %eax,%edx
  8009ba:	74 17                	je     8009d3 <_main+0x99b>
  8009bc:	83 ec 04             	sub    $0x4,%esp
  8009bf:	68 13 2e 80 00       	push   $0x802e13
  8009c4:	68 ad 00 00 00       	push   $0xad
  8009c9:	68 ec 2c 80 00       	push   $0x802cec
  8009ce:	e8 8f 03 00 00       	call   800d62 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8009d3:	ff 45 d8             	incl   -0x28(%ebp)
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8009dc:	68 c0 2e 80 00       	push   $0x802ec0
  8009e1:	e8 1e 06 00 00       	call   801004 <cprintf>
  8009e6:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8009e9:	e8 77 1b 00 00       	call   802565 <sys_calculate_free_frames>
  8009ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8009f1:	e8 f2 1b 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  8009f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo); 			   // Use Hole 5 -> Hole 5 = 2 M - K
  8009f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009fc:	83 ec 0c             	sub    $0xc,%esp
  8009ff:	50                   	push   %eax
  800a00:	e8 89 13 00 00       	call   801d8e <malloc>
  800a05:	83 c4 10             	add    $0x10,%esp
  800a08:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x99600000)
  800a0b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a0e:	3d 00 00 60 99       	cmp    $0x99600000,%eax
  800a13:	74 17                	je     800a2c <_main+0x9f4>
		panic("Worst Fit not working correctly");
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	68 a0 2e 80 00       	push   $0x802ea0
  800a1d:	68 b4 00 00 00       	push   $0xb4
  800a22:	68 ec 2c 80 00       	push   $0x802cec
  800a27:	e8 36 03 00 00       	call   800d62 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a2c:	e8 b7 1b 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  800a31:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800a34:	89 c2                	mov    %eax,%edx
  800a36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a39:	c1 e0 02             	shl    $0x2,%eax
  800a3c:	85 c0                	test   %eax,%eax
  800a3e:	79 05                	jns    800a45 <_main+0xa0d>
  800a40:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a45:	c1 f8 0c             	sar    $0xc,%eax
  800a48:	39 c2                	cmp    %eax,%edx
  800a4a:	74 17                	je     800a63 <_main+0xa2b>
  800a4c:	83 ec 04             	sub    $0x4,%esp
  800a4f:	68 f6 2d 80 00       	push   $0x802df6
  800a54:	68 b5 00 00 00       	push   $0xb5
  800a59:	68 ec 2c 80 00       	push   $0x802cec
  800a5e:	e8 ff 02 00 00       	call   800d62 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a63:	e8 fd 1a 00 00       	call   802565 <sys_calculate_free_frames>
  800a68:	89 c2                	mov    %eax,%edx
  800a6a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a6d:	39 c2                	cmp    %eax,%edx
  800a6f:	74 17                	je     800a88 <_main+0xa50>
  800a71:	83 ec 04             	sub    $0x4,%esp
  800a74:	68 13 2e 80 00       	push   $0x802e13
  800a79:	68 b6 00 00 00       	push   $0xb6
  800a7e:	68 ec 2c 80 00       	push   $0x802cec
  800a83:	e8 da 02 00 00       	call   800d62 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800a88:	ff 45 d8             	incl   -0x28(%ebp)
  800a8b:	83 ec 08             	sub    $0x8,%esp
  800a8e:	ff 75 d8             	pushl  -0x28(%ebp)
  800a91:	68 c0 2e 80 00       	push   $0x802ec0
  800a96:	e8 69 05 00 00       	call   801004 <cprintf>
  800a9b:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800a9e:	e8 c2 1a 00 00       	call   802565 <sys_calculate_free_frames>
  800aa3:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800aa6:	e8 3d 1b 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  800aab:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(2*Mega - 4*kilo); 		// Use Hole 5 -> Hole 5 = 0
  800aae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ab1:	01 c0                	add    %eax,%eax
  800ab3:	89 c2                	mov    %eax,%edx
  800ab5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab8:	29 d0                	sub    %edx,%eax
  800aba:	01 c0                	add    %eax,%eax
  800abc:	83 ec 0c             	sub    $0xc,%esp
  800abf:	50                   	push   %eax
  800ac0:	e8 c9 12 00 00       	call   801d8e <malloc>
  800ac5:	83 c4 10             	add    $0x10,%esp
  800ac8:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x99601000)
  800acb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ace:	3d 00 10 60 99       	cmp    $0x99601000,%eax
  800ad3:	74 17                	je     800aec <_main+0xab4>
		panic("Worst Fit not working correctly");
  800ad5:	83 ec 04             	sub    $0x4,%esp
  800ad8:	68 a0 2e 80 00       	push   $0x802ea0
  800add:	68 bd 00 00 00       	push   $0xbd
  800ae2:	68 ec 2c 80 00       	push   $0x802cec
  800ae7:	e8 76 02 00 00       	call   800d62 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (2*Mega - 4*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800aec:	e8 f7 1a 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  800af1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800af4:	89 c2                	mov    %eax,%edx
  800af6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800af9:	01 c0                	add    %eax,%eax
  800afb:	89 c1                	mov    %eax,%ecx
  800afd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b00:	29 c8                	sub    %ecx,%eax
  800b02:	01 c0                	add    %eax,%eax
  800b04:	85 c0                	test   %eax,%eax
  800b06:	79 05                	jns    800b0d <_main+0xad5>
  800b08:	05 ff 0f 00 00       	add    $0xfff,%eax
  800b0d:	c1 f8 0c             	sar    $0xc,%eax
  800b10:	39 c2                	cmp    %eax,%edx
  800b12:	74 17                	je     800b2b <_main+0xaf3>
  800b14:	83 ec 04             	sub    $0x4,%esp
  800b17:	68 f6 2d 80 00       	push   $0x802df6
  800b1c:	68 be 00 00 00       	push   $0xbe
  800b21:	68 ec 2c 80 00       	push   $0x802cec
  800b26:	e8 37 02 00 00       	call   800d62 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b2b:	e8 35 1a 00 00       	call   802565 <sys_calculate_free_frames>
  800b30:	89 c2                	mov    %eax,%edx
  800b32:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b35:	39 c2                	cmp    %eax,%edx
  800b37:	74 17                	je     800b50 <_main+0xb18>
  800b39:	83 ec 04             	sub    $0x4,%esp
  800b3c:	68 13 2e 80 00       	push   $0x802e13
  800b41:	68 bf 00 00 00       	push   $0xbf
  800b46:	68 ec 2c 80 00       	push   $0x802cec
  800b4b:	e8 12 02 00 00       	call   800d62 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800b50:	ff 45 d8             	incl   -0x28(%ebp)
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 d8             	pushl  -0x28(%ebp)
  800b59:	68 c0 2e 80 00       	push   $0x802ec0
  800b5e:	e8 a1 04 00 00       	call   801004 <cprintf>
  800b63:	83 c4 10             	add    $0x10,%esp

	// Check that worst fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800b66:	e8 fa 19 00 00       	call   802565 <sys_calculate_free_frames>
  800b6b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b6e:	e8 75 1a 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  800b73:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(4*Mega); 		//No Suitable hole
  800b76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b79:	c1 e0 02             	shl    $0x2,%eax
  800b7c:	83 ec 0c             	sub    $0xc,%esp
  800b7f:	50                   	push   %eax
  800b80:	e8 09 12 00 00       	call   801d8e <malloc>
  800b85:	83 c4 10             	add    $0x10,%esp
  800b88:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x0)
  800b8b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b8e:	85 c0                	test   %eax,%eax
  800b90:	74 17                	je     800ba9 <_main+0xb71>
		panic("Worst Fit not working correctly");
  800b92:	83 ec 04             	sub    $0x4,%esp
  800b95:	68 a0 2e 80 00       	push   $0x802ea0
  800b9a:	68 c7 00 00 00       	push   $0xc7
  800b9f:	68 ec 2c 80 00       	push   $0x802cec
  800ba4:	e8 b9 01 00 00       	call   800d62 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800ba9:	e8 3a 1a 00 00       	call   8025e8 <sys_pf_calculate_allocated_pages>
  800bae:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800bb1:	74 17                	je     800bca <_main+0xb92>
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	68 f6 2d 80 00       	push   $0x802df6
  800bbb:	68 c8 00 00 00       	push   $0xc8
  800bc0:	68 ec 2c 80 00       	push   $0x802cec
  800bc5:	e8 98 01 00 00       	call   800d62 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800bca:	e8 96 19 00 00       	call   802565 <sys_calculate_free_frames>
  800bcf:	89 c2                	mov    %eax,%edx
  800bd1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800bd4:	39 c2                	cmp    %eax,%edx
  800bd6:	74 17                	je     800bef <_main+0xbb7>
  800bd8:	83 ec 04             	sub    $0x4,%esp
  800bdb:	68 13 2e 80 00       	push   $0x802e13
  800be0:	68 c9 00 00 00       	push   $0xc9
  800be5:	68 ec 2c 80 00       	push   $0x802cec
  800bea:	e8 73 01 00 00       	call   800d62 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800bef:	ff 45 d8             	incl   -0x28(%ebp)
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 d8             	pushl  -0x28(%ebp)
  800bf8:	68 c0 2e 80 00       	push   $0x802ec0
  800bfd:	e8 02 04 00 00       	call   801004 <cprintf>
  800c02:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Worst Fit completed successfully.\n");
  800c05:	83 ec 0c             	sub    $0xc,%esp
  800c08:	68 d4 2e 80 00       	push   $0x802ed4
  800c0d:	e8 f2 03 00 00       	call   801004 <cprintf>
  800c12:	83 c4 10             	add    $0x10,%esp

	return;
  800c15:	90                   	nop
}
  800c16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c19:	5b                   	pop    %ebx
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800c23:	e8 72 18 00 00       	call   80249a <sys_getenvindex>
  800c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800c2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c2e:	89 d0                	mov    %edx,%eax
  800c30:	c1 e0 03             	shl    $0x3,%eax
  800c33:	01 d0                	add    %edx,%eax
  800c35:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800c3c:	01 c8                	add    %ecx,%eax
  800c3e:	01 c0                	add    %eax,%eax
  800c40:	01 d0                	add    %edx,%eax
  800c42:	01 c0                	add    %eax,%eax
  800c44:	01 d0                	add    %edx,%eax
  800c46:	89 c2                	mov    %eax,%edx
  800c48:	c1 e2 05             	shl    $0x5,%edx
  800c4b:	29 c2                	sub    %eax,%edx
  800c4d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800c54:	89 c2                	mov    %eax,%edx
  800c56:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800c5c:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800c61:	a1 20 40 80 00       	mov    0x804020,%eax
  800c66:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800c6c:	84 c0                	test   %al,%al
  800c6e:	74 0f                	je     800c7f <libmain+0x62>
		binaryname = myEnv->prog_name;
  800c70:	a1 20 40 80 00       	mov    0x804020,%eax
  800c75:	05 40 3c 01 00       	add    $0x13c40,%eax
  800c7a:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c83:	7e 0a                	jle    800c8f <libmain+0x72>
		binaryname = argv[0];
  800c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c88:	8b 00                	mov    (%eax),%eax
  800c8a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	ff 75 0c             	pushl  0xc(%ebp)
  800c95:	ff 75 08             	pushl  0x8(%ebp)
  800c98:	e8 9b f3 ff ff       	call   800038 <_main>
  800c9d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800ca0:	e8 90 19 00 00       	call   802635 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800ca5:	83 ec 0c             	sub    $0xc,%esp
  800ca8:	68 28 2f 80 00       	push   $0x802f28
  800cad:	e8 52 03 00 00       	call   801004 <cprintf>
  800cb2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800cb5:	a1 20 40 80 00       	mov    0x804020,%eax
  800cba:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800cc0:	a1 20 40 80 00       	mov    0x804020,%eax
  800cc5:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800ccb:	83 ec 04             	sub    $0x4,%esp
  800cce:	52                   	push   %edx
  800ccf:	50                   	push   %eax
  800cd0:	68 50 2f 80 00       	push   $0x802f50
  800cd5:	e8 2a 03 00 00       	call   801004 <cprintf>
  800cda:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800cdd:	a1 20 40 80 00       	mov    0x804020,%eax
  800ce2:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800ce8:	a1 20 40 80 00       	mov    0x804020,%eax
  800ced:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800cf3:	83 ec 04             	sub    $0x4,%esp
  800cf6:	52                   	push   %edx
  800cf7:	50                   	push   %eax
  800cf8:	68 78 2f 80 00       	push   $0x802f78
  800cfd:	e8 02 03 00 00       	call   801004 <cprintf>
  800d02:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800d05:	a1 20 40 80 00       	mov    0x804020,%eax
  800d0a:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800d10:	83 ec 08             	sub    $0x8,%esp
  800d13:	50                   	push   %eax
  800d14:	68 b9 2f 80 00       	push   $0x802fb9
  800d19:	e8 e6 02 00 00       	call   801004 <cprintf>
  800d1e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800d21:	83 ec 0c             	sub    $0xc,%esp
  800d24:	68 28 2f 80 00       	push   $0x802f28
  800d29:	e8 d6 02 00 00       	call   801004 <cprintf>
  800d2e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800d31:	e8 19 19 00 00       	call   80264f <sys_enable_interrupt>

	// exit gracefully
	exit();
  800d36:	e8 19 00 00 00       	call   800d54 <exit>
}
  800d3b:	90                   	nop
  800d3c:	c9                   	leave  
  800d3d:	c3                   	ret    

00800d3e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800d44:	83 ec 0c             	sub    $0xc,%esp
  800d47:	6a 00                	push   $0x0
  800d49:	e8 18 17 00 00       	call   802466 <sys_env_destroy>
  800d4e:	83 c4 10             	add    $0x10,%esp
}
  800d51:	90                   	nop
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <exit>:

void
exit(void)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800d5a:	e8 6d 17 00 00       	call   8024cc <sys_env_exit>
}
  800d5f:	90                   	nop
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d68:	8d 45 10             	lea    0x10(%ebp),%eax
  800d6b:	83 c0 04             	add    $0x4,%eax
  800d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d71:	a1 18 41 80 00       	mov    0x804118,%eax
  800d76:	85 c0                	test   %eax,%eax
  800d78:	74 16                	je     800d90 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d7a:	a1 18 41 80 00       	mov    0x804118,%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	50                   	push   %eax
  800d83:	68 d0 2f 80 00       	push   $0x802fd0
  800d88:	e8 77 02 00 00       	call   801004 <cprintf>
  800d8d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d90:	a1 00 40 80 00       	mov    0x804000,%eax
  800d95:	ff 75 0c             	pushl  0xc(%ebp)
  800d98:	ff 75 08             	pushl  0x8(%ebp)
  800d9b:	50                   	push   %eax
  800d9c:	68 d5 2f 80 00       	push   $0x802fd5
  800da1:	e8 5e 02 00 00       	call   801004 <cprintf>
  800da6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800da9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dac:	83 ec 08             	sub    $0x8,%esp
  800daf:	ff 75 f4             	pushl  -0xc(%ebp)
  800db2:	50                   	push   %eax
  800db3:	e8 e1 01 00 00       	call   800f99 <vcprintf>
  800db8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	6a 00                	push   $0x0
  800dc0:	68 f1 2f 80 00       	push   $0x802ff1
  800dc5:	e8 cf 01 00 00       	call   800f99 <vcprintf>
  800dca:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800dcd:	e8 82 ff ff ff       	call   800d54 <exit>

	// should not return here
	while (1) ;
  800dd2:	eb fe                	jmp    800dd2 <_panic+0x70>

00800dd4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800dda:	a1 20 40 80 00       	mov    0x804020,%eax
  800ddf:	8b 50 74             	mov    0x74(%eax),%edx
  800de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de5:	39 c2                	cmp    %eax,%edx
  800de7:	74 14                	je     800dfd <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800de9:	83 ec 04             	sub    $0x4,%esp
  800dec:	68 f4 2f 80 00       	push   $0x802ff4
  800df1:	6a 26                	push   $0x26
  800df3:	68 40 30 80 00       	push   $0x803040
  800df8:	e8 65 ff ff ff       	call   800d62 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800dfd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800e04:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e0b:	e9 b6 00 00 00       	jmp    800ec6 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	01 d0                	add    %edx,%eax
  800e1f:	8b 00                	mov    (%eax),%eax
  800e21:	85 c0                	test   %eax,%eax
  800e23:	75 08                	jne    800e2d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800e25:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800e28:	e9 96 00 00 00       	jmp    800ec3 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800e2d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e34:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e3b:	eb 5d                	jmp    800e9a <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e3d:	a1 20 40 80 00       	mov    0x804020,%eax
  800e42:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800e48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e4b:	c1 e2 04             	shl    $0x4,%edx
  800e4e:	01 d0                	add    %edx,%eax
  800e50:	8a 40 04             	mov    0x4(%eax),%al
  800e53:	84 c0                	test   %al,%al
  800e55:	75 40                	jne    800e97 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e57:	a1 20 40 80 00       	mov    0x804020,%eax
  800e5c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800e62:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e65:	c1 e2 04             	shl    $0x4,%edx
  800e68:	01 d0                	add    %edx,%eax
  800e6a:	8b 00                	mov    (%eax),%eax
  800e6c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e77:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	01 c8                	add    %ecx,%eax
  800e88:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e8a:	39 c2                	cmp    %eax,%edx
  800e8c:	75 09                	jne    800e97 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800e8e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800e95:	eb 12                	jmp    800ea9 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e97:	ff 45 e8             	incl   -0x18(%ebp)
  800e9a:	a1 20 40 80 00       	mov    0x804020,%eax
  800e9f:	8b 50 74             	mov    0x74(%eax),%edx
  800ea2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ea5:	39 c2                	cmp    %eax,%edx
  800ea7:	77 94                	ja     800e3d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800ea9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ead:	75 14                	jne    800ec3 <CheckWSWithoutLastIndex+0xef>
			panic(
  800eaf:	83 ec 04             	sub    $0x4,%esp
  800eb2:	68 4c 30 80 00       	push   $0x80304c
  800eb7:	6a 3a                	push   $0x3a
  800eb9:	68 40 30 80 00       	push   $0x803040
  800ebe:	e8 9f fe ff ff       	call   800d62 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800ec3:	ff 45 f0             	incl   -0x10(%ebp)
  800ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800ecc:	0f 8c 3e ff ff ff    	jl     800e10 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ed2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ed9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ee0:	eb 20                	jmp    800f02 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ee2:	a1 20 40 80 00       	mov    0x804020,%eax
  800ee7:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800eed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ef0:	c1 e2 04             	shl    $0x4,%edx
  800ef3:	01 d0                	add    %edx,%eax
  800ef5:	8a 40 04             	mov    0x4(%eax),%al
  800ef8:	3c 01                	cmp    $0x1,%al
  800efa:	75 03                	jne    800eff <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800efc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800eff:	ff 45 e0             	incl   -0x20(%ebp)
  800f02:	a1 20 40 80 00       	mov    0x804020,%eax
  800f07:	8b 50 74             	mov    0x74(%eax),%edx
  800f0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f0d:	39 c2                	cmp    %eax,%edx
  800f0f:	77 d1                	ja     800ee2 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f14:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800f17:	74 14                	je     800f2d <CheckWSWithoutLastIndex+0x159>
		panic(
  800f19:	83 ec 04             	sub    $0x4,%esp
  800f1c:	68 a0 30 80 00       	push   $0x8030a0
  800f21:	6a 44                	push   $0x44
  800f23:	68 40 30 80 00       	push   $0x803040
  800f28:	e8 35 fe ff ff       	call   800d62 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800f2d:	90                   	nop
  800f2e:	c9                   	leave  
  800f2f:	c3                   	ret    

00800f30 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	8d 48 01             	lea    0x1(%eax),%ecx
  800f3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f41:	89 0a                	mov    %ecx,(%edx)
  800f43:	8b 55 08             	mov    0x8(%ebp),%edx
  800f46:	88 d1                	mov    %dl,%cl
  800f48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f52:	8b 00                	mov    (%eax),%eax
  800f54:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f59:	75 2c                	jne    800f87 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800f5b:	a0 24 40 80 00       	mov    0x804024,%al
  800f60:	0f b6 c0             	movzbl %al,%eax
  800f63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f66:	8b 12                	mov    (%edx),%edx
  800f68:	89 d1                	mov    %edx,%ecx
  800f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6d:	83 c2 08             	add    $0x8,%edx
  800f70:	83 ec 04             	sub    $0x4,%esp
  800f73:	50                   	push   %eax
  800f74:	51                   	push   %ecx
  800f75:	52                   	push   %edx
  800f76:	e8 a9 14 00 00       	call   802424 <sys_cputs>
  800f7b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	8b 40 04             	mov    0x4(%eax),%eax
  800f8d:	8d 50 01             	lea    0x1(%eax),%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f96:	90                   	nop
  800f97:	c9                   	leave  
  800f98:	c3                   	ret    

00800f99 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800fa2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800fa9:	00 00 00 
	b.cnt = 0;
  800fac:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800fb3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800fb6:	ff 75 0c             	pushl  0xc(%ebp)
  800fb9:	ff 75 08             	pushl  0x8(%ebp)
  800fbc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fc2:	50                   	push   %eax
  800fc3:	68 30 0f 80 00       	push   $0x800f30
  800fc8:	e8 11 02 00 00       	call   8011de <vprintfmt>
  800fcd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800fd0:	a0 24 40 80 00       	mov    0x804024,%al
  800fd5:	0f b6 c0             	movzbl %al,%eax
  800fd8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800fde:	83 ec 04             	sub    $0x4,%esp
  800fe1:	50                   	push   %eax
  800fe2:	52                   	push   %edx
  800fe3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fe9:	83 c0 08             	add    $0x8,%eax
  800fec:	50                   	push   %eax
  800fed:	e8 32 14 00 00       	call   802424 <sys_cputs>
  800ff2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ff5:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800ffc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801002:	c9                   	leave  
  801003:	c3                   	ret    

00801004 <cprintf>:

int cprintf(const char *fmt, ...) {
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80100a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  801011:	8d 45 0c             	lea    0xc(%ebp),%eax
  801014:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	83 ec 08             	sub    $0x8,%esp
  80101d:	ff 75 f4             	pushl  -0xc(%ebp)
  801020:	50                   	push   %eax
  801021:	e8 73 ff ff ff       	call   800f99 <vcprintf>
  801026:	83 c4 10             	add    $0x10,%esp
  801029:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80102c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801037:	e8 f9 15 00 00       	call   802635 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80103c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80103f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	83 ec 08             	sub    $0x8,%esp
  801048:	ff 75 f4             	pushl  -0xc(%ebp)
  80104b:	50                   	push   %eax
  80104c:	e8 48 ff ff ff       	call   800f99 <vcprintf>
  801051:	83 c4 10             	add    $0x10,%esp
  801054:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801057:	e8 f3 15 00 00       	call   80264f <sys_enable_interrupt>
	return cnt;
  80105c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80105f:	c9                   	leave  
  801060:	c3                   	ret    

00801061 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	53                   	push   %ebx
  801065:	83 ec 14             	sub    $0x14,%esp
  801068:	8b 45 10             	mov    0x10(%ebp),%eax
  80106b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80106e:	8b 45 14             	mov    0x14(%ebp),%eax
  801071:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801074:	8b 45 18             	mov    0x18(%ebp),%eax
  801077:	ba 00 00 00 00       	mov    $0x0,%edx
  80107c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80107f:	77 55                	ja     8010d6 <printnum+0x75>
  801081:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801084:	72 05                	jb     80108b <printnum+0x2a>
  801086:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801089:	77 4b                	ja     8010d6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80108b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80108e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801091:	8b 45 18             	mov    0x18(%ebp),%eax
  801094:	ba 00 00 00 00       	mov    $0x0,%edx
  801099:	52                   	push   %edx
  80109a:	50                   	push   %eax
  80109b:	ff 75 f4             	pushl  -0xc(%ebp)
  80109e:	ff 75 f0             	pushl  -0x10(%ebp)
  8010a1:	e8 b2 19 00 00       	call   802a58 <__udivdi3>
  8010a6:	83 c4 10             	add    $0x10,%esp
  8010a9:	83 ec 04             	sub    $0x4,%esp
  8010ac:	ff 75 20             	pushl  0x20(%ebp)
  8010af:	53                   	push   %ebx
  8010b0:	ff 75 18             	pushl  0x18(%ebp)
  8010b3:	52                   	push   %edx
  8010b4:	50                   	push   %eax
  8010b5:	ff 75 0c             	pushl  0xc(%ebp)
  8010b8:	ff 75 08             	pushl  0x8(%ebp)
  8010bb:	e8 a1 ff ff ff       	call   801061 <printnum>
  8010c0:	83 c4 20             	add    $0x20,%esp
  8010c3:	eb 1a                	jmp    8010df <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8010c5:	83 ec 08             	sub    $0x8,%esp
  8010c8:	ff 75 0c             	pushl  0xc(%ebp)
  8010cb:	ff 75 20             	pushl  0x20(%ebp)
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	ff d0                	call   *%eax
  8010d3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010d6:	ff 4d 1c             	decl   0x1c(%ebp)
  8010d9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8010dd:	7f e6                	jg     8010c5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010df:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8010e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ed:	53                   	push   %ebx
  8010ee:	51                   	push   %ecx
  8010ef:	52                   	push   %edx
  8010f0:	50                   	push   %eax
  8010f1:	e8 72 1a 00 00       	call   802b68 <__umoddi3>
  8010f6:	83 c4 10             	add    $0x10,%esp
  8010f9:	05 14 33 80 00       	add    $0x803314,%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	0f be c0             	movsbl %al,%eax
  801103:	83 ec 08             	sub    $0x8,%esp
  801106:	ff 75 0c             	pushl  0xc(%ebp)
  801109:	50                   	push   %eax
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	ff d0                	call   *%eax
  80110f:	83 c4 10             	add    $0x10,%esp
}
  801112:	90                   	nop
  801113:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801116:	c9                   	leave  
  801117:	c3                   	ret    

00801118 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80111b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80111f:	7e 1c                	jle    80113d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8b 00                	mov    (%eax),%eax
  801126:	8d 50 08             	lea    0x8(%eax),%edx
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	89 10                	mov    %edx,(%eax)
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8b 00                	mov    (%eax),%eax
  801133:	83 e8 08             	sub    $0x8,%eax
  801136:	8b 50 04             	mov    0x4(%eax),%edx
  801139:	8b 00                	mov    (%eax),%eax
  80113b:	eb 40                	jmp    80117d <getuint+0x65>
	else if (lflag)
  80113d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801141:	74 1e                	je     801161 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8b 00                	mov    (%eax),%eax
  801148:	8d 50 04             	lea    0x4(%eax),%edx
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	89 10                	mov    %edx,(%eax)
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8b 00                	mov    (%eax),%eax
  801155:	83 e8 04             	sub    $0x4,%eax
  801158:	8b 00                	mov    (%eax),%eax
  80115a:	ba 00 00 00 00       	mov    $0x0,%edx
  80115f:	eb 1c                	jmp    80117d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8b 00                	mov    (%eax),%eax
  801166:	8d 50 04             	lea    0x4(%eax),%edx
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	89 10                	mov    %edx,(%eax)
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8b 00                	mov    (%eax),%eax
  801173:	83 e8 04             	sub    $0x4,%eax
  801176:	8b 00                	mov    (%eax),%eax
  801178:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80117d:	5d                   	pop    %ebp
  80117e:	c3                   	ret    

0080117f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801182:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801186:	7e 1c                	jle    8011a4 <getint+0x25>
		return va_arg(*ap, long long);
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8b 00                	mov    (%eax),%eax
  80118d:	8d 50 08             	lea    0x8(%eax),%edx
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	89 10                	mov    %edx,(%eax)
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8b 00                	mov    (%eax),%eax
  80119a:	83 e8 08             	sub    $0x8,%eax
  80119d:	8b 50 04             	mov    0x4(%eax),%edx
  8011a0:	8b 00                	mov    (%eax),%eax
  8011a2:	eb 38                	jmp    8011dc <getint+0x5d>
	else if (lflag)
  8011a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a8:	74 1a                	je     8011c4 <getint+0x45>
		return va_arg(*ap, long);
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8b 00                	mov    (%eax),%eax
  8011af:	8d 50 04             	lea    0x4(%eax),%edx
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	89 10                	mov    %edx,(%eax)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8b 00                	mov    (%eax),%eax
  8011bc:	83 e8 04             	sub    $0x4,%eax
  8011bf:	8b 00                	mov    (%eax),%eax
  8011c1:	99                   	cltd   
  8011c2:	eb 18                	jmp    8011dc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	8d 50 04             	lea    0x4(%eax),%edx
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	89 10                	mov    %edx,(%eax)
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	83 e8 04             	sub    $0x4,%eax
  8011d9:	8b 00                	mov    (%eax),%eax
  8011db:	99                   	cltd   
}
  8011dc:	5d                   	pop    %ebp
  8011dd:	c3                   	ret    

008011de <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	56                   	push   %esi
  8011e2:	53                   	push   %ebx
  8011e3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011e6:	eb 17                	jmp    8011ff <vprintfmt+0x21>
			if (ch == '\0')
  8011e8:	85 db                	test   %ebx,%ebx
  8011ea:	0f 84 af 03 00 00    	je     80159f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8011f0:	83 ec 08             	sub    $0x8,%esp
  8011f3:	ff 75 0c             	pushl  0xc(%ebp)
  8011f6:	53                   	push   %ebx
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	ff d0                	call   *%eax
  8011fc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801202:	8d 50 01             	lea    0x1(%eax),%edx
  801205:	89 55 10             	mov    %edx,0x10(%ebp)
  801208:	8a 00                	mov    (%eax),%al
  80120a:	0f b6 d8             	movzbl %al,%ebx
  80120d:	83 fb 25             	cmp    $0x25,%ebx
  801210:	75 d6                	jne    8011e8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801212:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801216:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80121d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801224:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80122b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801232:	8b 45 10             	mov    0x10(%ebp),%eax
  801235:	8d 50 01             	lea    0x1(%eax),%edx
  801238:	89 55 10             	mov    %edx,0x10(%ebp)
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	0f b6 d8             	movzbl %al,%ebx
  801240:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801243:	83 f8 55             	cmp    $0x55,%eax
  801246:	0f 87 2b 03 00 00    	ja     801577 <vprintfmt+0x399>
  80124c:	8b 04 85 38 33 80 00 	mov    0x803338(,%eax,4),%eax
  801253:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801255:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801259:	eb d7                	jmp    801232 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80125b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80125f:	eb d1                	jmp    801232 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801261:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801268:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80126b:	89 d0                	mov    %edx,%eax
  80126d:	c1 e0 02             	shl    $0x2,%eax
  801270:	01 d0                	add    %edx,%eax
  801272:	01 c0                	add    %eax,%eax
  801274:	01 d8                	add    %ebx,%eax
  801276:	83 e8 30             	sub    $0x30,%eax
  801279:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	8a 00                	mov    (%eax),%al
  801281:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801284:	83 fb 2f             	cmp    $0x2f,%ebx
  801287:	7e 3e                	jle    8012c7 <vprintfmt+0xe9>
  801289:	83 fb 39             	cmp    $0x39,%ebx
  80128c:	7f 39                	jg     8012c7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80128e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801291:	eb d5                	jmp    801268 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	83 c0 04             	add    $0x4,%eax
  801299:	89 45 14             	mov    %eax,0x14(%ebp)
  80129c:	8b 45 14             	mov    0x14(%ebp),%eax
  80129f:	83 e8 04             	sub    $0x4,%eax
  8012a2:	8b 00                	mov    (%eax),%eax
  8012a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8012a7:	eb 1f                	jmp    8012c8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8012a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012ad:	79 83                	jns    801232 <vprintfmt+0x54>
				width = 0;
  8012af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8012b6:	e9 77 ff ff ff       	jmp    801232 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8012bb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8012c2:	e9 6b ff ff ff       	jmp    801232 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8012c7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8012c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012cc:	0f 89 60 ff ff ff    	jns    801232 <vprintfmt+0x54>
				width = precision, precision = -1;
  8012d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012d8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8012df:	e9 4e ff ff ff       	jmp    801232 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012e4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8012e7:	e9 46 ff ff ff       	jmp    801232 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8012ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ef:	83 c0 04             	add    $0x4,%eax
  8012f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8012f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f8:	83 e8 04             	sub    $0x4,%eax
  8012fb:	8b 00                	mov    (%eax),%eax
  8012fd:	83 ec 08             	sub    $0x8,%esp
  801300:	ff 75 0c             	pushl  0xc(%ebp)
  801303:	50                   	push   %eax
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	ff d0                	call   *%eax
  801309:	83 c4 10             	add    $0x10,%esp
			break;
  80130c:	e9 89 02 00 00       	jmp    80159a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801311:	8b 45 14             	mov    0x14(%ebp),%eax
  801314:	83 c0 04             	add    $0x4,%eax
  801317:	89 45 14             	mov    %eax,0x14(%ebp)
  80131a:	8b 45 14             	mov    0x14(%ebp),%eax
  80131d:	83 e8 04             	sub    $0x4,%eax
  801320:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801322:	85 db                	test   %ebx,%ebx
  801324:	79 02                	jns    801328 <vprintfmt+0x14a>
				err = -err;
  801326:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801328:	83 fb 64             	cmp    $0x64,%ebx
  80132b:	7f 0b                	jg     801338 <vprintfmt+0x15a>
  80132d:	8b 34 9d 80 31 80 00 	mov    0x803180(,%ebx,4),%esi
  801334:	85 f6                	test   %esi,%esi
  801336:	75 19                	jne    801351 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801338:	53                   	push   %ebx
  801339:	68 25 33 80 00       	push   $0x803325
  80133e:	ff 75 0c             	pushl  0xc(%ebp)
  801341:	ff 75 08             	pushl  0x8(%ebp)
  801344:	e8 5e 02 00 00       	call   8015a7 <printfmt>
  801349:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80134c:	e9 49 02 00 00       	jmp    80159a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801351:	56                   	push   %esi
  801352:	68 2e 33 80 00       	push   $0x80332e
  801357:	ff 75 0c             	pushl  0xc(%ebp)
  80135a:	ff 75 08             	pushl  0x8(%ebp)
  80135d:	e8 45 02 00 00       	call   8015a7 <printfmt>
  801362:	83 c4 10             	add    $0x10,%esp
			break;
  801365:	e9 30 02 00 00       	jmp    80159a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80136a:	8b 45 14             	mov    0x14(%ebp),%eax
  80136d:	83 c0 04             	add    $0x4,%eax
  801370:	89 45 14             	mov    %eax,0x14(%ebp)
  801373:	8b 45 14             	mov    0x14(%ebp),%eax
  801376:	83 e8 04             	sub    $0x4,%eax
  801379:	8b 30                	mov    (%eax),%esi
  80137b:	85 f6                	test   %esi,%esi
  80137d:	75 05                	jne    801384 <vprintfmt+0x1a6>
				p = "(null)";
  80137f:	be 31 33 80 00       	mov    $0x803331,%esi
			if (width > 0 && padc != '-')
  801384:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801388:	7e 6d                	jle    8013f7 <vprintfmt+0x219>
  80138a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80138e:	74 67                	je     8013f7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801390:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801393:	83 ec 08             	sub    $0x8,%esp
  801396:	50                   	push   %eax
  801397:	56                   	push   %esi
  801398:	e8 0c 03 00 00       	call   8016a9 <strnlen>
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8013a3:	eb 16                	jmp    8013bb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8013a5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8013a9:	83 ec 08             	sub    $0x8,%esp
  8013ac:	ff 75 0c             	pushl  0xc(%ebp)
  8013af:	50                   	push   %eax
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	ff d0                	call   *%eax
  8013b5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013b8:	ff 4d e4             	decl   -0x1c(%ebp)
  8013bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013bf:	7f e4                	jg     8013a5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013c1:	eb 34                	jmp    8013f7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8013c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8013c7:	74 1c                	je     8013e5 <vprintfmt+0x207>
  8013c9:	83 fb 1f             	cmp    $0x1f,%ebx
  8013cc:	7e 05                	jle    8013d3 <vprintfmt+0x1f5>
  8013ce:	83 fb 7e             	cmp    $0x7e,%ebx
  8013d1:	7e 12                	jle    8013e5 <vprintfmt+0x207>
					putch('?', putdat);
  8013d3:	83 ec 08             	sub    $0x8,%esp
  8013d6:	ff 75 0c             	pushl  0xc(%ebp)
  8013d9:	6a 3f                	push   $0x3f
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	ff d0                	call   *%eax
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	eb 0f                	jmp    8013f4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8013e5:	83 ec 08             	sub    $0x8,%esp
  8013e8:	ff 75 0c             	pushl  0xc(%ebp)
  8013eb:	53                   	push   %ebx
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	ff d0                	call   *%eax
  8013f1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013f4:	ff 4d e4             	decl   -0x1c(%ebp)
  8013f7:	89 f0                	mov    %esi,%eax
  8013f9:	8d 70 01             	lea    0x1(%eax),%esi
  8013fc:	8a 00                	mov    (%eax),%al
  8013fe:	0f be d8             	movsbl %al,%ebx
  801401:	85 db                	test   %ebx,%ebx
  801403:	74 24                	je     801429 <vprintfmt+0x24b>
  801405:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801409:	78 b8                	js     8013c3 <vprintfmt+0x1e5>
  80140b:	ff 4d e0             	decl   -0x20(%ebp)
  80140e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801412:	79 af                	jns    8013c3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801414:	eb 13                	jmp    801429 <vprintfmt+0x24b>
				putch(' ', putdat);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	ff 75 0c             	pushl  0xc(%ebp)
  80141c:	6a 20                	push   $0x20
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	ff d0                	call   *%eax
  801423:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801426:	ff 4d e4             	decl   -0x1c(%ebp)
  801429:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80142d:	7f e7                	jg     801416 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80142f:	e9 66 01 00 00       	jmp    80159a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801434:	83 ec 08             	sub    $0x8,%esp
  801437:	ff 75 e8             	pushl  -0x18(%ebp)
  80143a:	8d 45 14             	lea    0x14(%ebp),%eax
  80143d:	50                   	push   %eax
  80143e:	e8 3c fd ff ff       	call   80117f <getint>
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801449:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80144c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801452:	85 d2                	test   %edx,%edx
  801454:	79 23                	jns    801479 <vprintfmt+0x29b>
				putch('-', putdat);
  801456:	83 ec 08             	sub    $0x8,%esp
  801459:	ff 75 0c             	pushl  0xc(%ebp)
  80145c:	6a 2d                	push   $0x2d
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	ff d0                	call   *%eax
  801463:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801469:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80146c:	f7 d8                	neg    %eax
  80146e:	83 d2 00             	adc    $0x0,%edx
  801471:	f7 da                	neg    %edx
  801473:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801476:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801479:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801480:	e9 bc 00 00 00       	jmp    801541 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801485:	83 ec 08             	sub    $0x8,%esp
  801488:	ff 75 e8             	pushl  -0x18(%ebp)
  80148b:	8d 45 14             	lea    0x14(%ebp),%eax
  80148e:	50                   	push   %eax
  80148f:	e8 84 fc ff ff       	call   801118 <getuint>
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80149a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80149d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8014a4:	e9 98 00 00 00       	jmp    801541 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8014a9:	83 ec 08             	sub    $0x8,%esp
  8014ac:	ff 75 0c             	pushl  0xc(%ebp)
  8014af:	6a 58                	push   $0x58
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	ff d0                	call   *%eax
  8014b6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	6a 58                	push   $0x58
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	ff d0                	call   *%eax
  8014c6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	ff 75 0c             	pushl  0xc(%ebp)
  8014cf:	6a 58                	push   $0x58
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	ff d0                	call   *%eax
  8014d6:	83 c4 10             	add    $0x10,%esp
			break;
  8014d9:	e9 bc 00 00 00       	jmp    80159a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8014de:	83 ec 08             	sub    $0x8,%esp
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	6a 30                	push   $0x30
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	ff d0                	call   *%eax
  8014eb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	ff 75 0c             	pushl  0xc(%ebp)
  8014f4:	6a 78                	push   $0x78
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	ff d0                	call   *%eax
  8014fb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8014fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801501:	83 c0 04             	add    $0x4,%eax
  801504:	89 45 14             	mov    %eax,0x14(%ebp)
  801507:	8b 45 14             	mov    0x14(%ebp),%eax
  80150a:	83 e8 04             	sub    $0x4,%eax
  80150d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80150f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801512:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801519:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801520:	eb 1f                	jmp    801541 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801522:	83 ec 08             	sub    $0x8,%esp
  801525:	ff 75 e8             	pushl  -0x18(%ebp)
  801528:	8d 45 14             	lea    0x14(%ebp),%eax
  80152b:	50                   	push   %eax
  80152c:	e8 e7 fb ff ff       	call   801118 <getuint>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801537:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80153a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801541:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801545:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801548:	83 ec 04             	sub    $0x4,%esp
  80154b:	52                   	push   %edx
  80154c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80154f:	50                   	push   %eax
  801550:	ff 75 f4             	pushl  -0xc(%ebp)
  801553:	ff 75 f0             	pushl  -0x10(%ebp)
  801556:	ff 75 0c             	pushl  0xc(%ebp)
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 00 fb ff ff       	call   801061 <printnum>
  801561:	83 c4 20             	add    $0x20,%esp
			break;
  801564:	eb 34                	jmp    80159a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801566:	83 ec 08             	sub    $0x8,%esp
  801569:	ff 75 0c             	pushl  0xc(%ebp)
  80156c:	53                   	push   %ebx
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	ff d0                	call   *%eax
  801572:	83 c4 10             	add    $0x10,%esp
			break;
  801575:	eb 23                	jmp    80159a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801577:	83 ec 08             	sub    $0x8,%esp
  80157a:	ff 75 0c             	pushl  0xc(%ebp)
  80157d:	6a 25                	push   $0x25
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	ff d0                	call   *%eax
  801584:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801587:	ff 4d 10             	decl   0x10(%ebp)
  80158a:	eb 03                	jmp    80158f <vprintfmt+0x3b1>
  80158c:	ff 4d 10             	decl   0x10(%ebp)
  80158f:	8b 45 10             	mov    0x10(%ebp),%eax
  801592:	48                   	dec    %eax
  801593:	8a 00                	mov    (%eax),%al
  801595:	3c 25                	cmp    $0x25,%al
  801597:	75 f3                	jne    80158c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801599:	90                   	nop
		}
	}
  80159a:	e9 47 fc ff ff       	jmp    8011e6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80159f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8015a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a3:	5b                   	pop    %ebx
  8015a4:	5e                   	pop    %esi
  8015a5:	5d                   	pop    %ebp
  8015a6:	c3                   	ret    

008015a7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8015ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8015b0:	83 c0 04             	add    $0x4,%eax
  8015b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8015b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8015bc:	50                   	push   %eax
  8015bd:	ff 75 0c             	pushl  0xc(%ebp)
  8015c0:	ff 75 08             	pushl  0x8(%ebp)
  8015c3:	e8 16 fc ff ff       	call   8011de <vprintfmt>
  8015c8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8015cb:	90                   	nop
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8015d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d4:	8b 40 08             	mov    0x8(%eax),%eax
  8015d7:	8d 50 01             	lea    0x1(%eax),%edx
  8015da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8015e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e3:	8b 10                	mov    (%eax),%edx
  8015e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e8:	8b 40 04             	mov    0x4(%eax),%eax
  8015eb:	39 c2                	cmp    %eax,%edx
  8015ed:	73 12                	jae    801601 <sprintputch+0x33>
		*b->buf++ = ch;
  8015ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f2:	8b 00                	mov    (%eax),%eax
  8015f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8015f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fa:	89 0a                	mov    %ecx,(%edx)
  8015fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ff:	88 10                	mov    %dl,(%eax)
}
  801601:	90                   	nop
  801602:	5d                   	pop    %ebp
  801603:	c3                   	ret    

00801604 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801610:	8b 45 0c             	mov    0xc(%ebp),%eax
  801613:	8d 50 ff             	lea    -0x1(%eax),%edx
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	01 d0                	add    %edx,%eax
  80161b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80161e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801625:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801629:	74 06                	je     801631 <vsnprintf+0x2d>
  80162b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80162f:	7f 07                	jg     801638 <vsnprintf+0x34>
		return -E_INVAL;
  801631:	b8 03 00 00 00       	mov    $0x3,%eax
  801636:	eb 20                	jmp    801658 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801638:	ff 75 14             	pushl  0x14(%ebp)
  80163b:	ff 75 10             	pushl  0x10(%ebp)
  80163e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801641:	50                   	push   %eax
  801642:	68 ce 15 80 00       	push   $0x8015ce
  801647:	e8 92 fb ff ff       	call   8011de <vprintfmt>
  80164c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80164f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801652:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801655:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801660:	8d 45 10             	lea    0x10(%ebp),%eax
  801663:	83 c0 04             	add    $0x4,%eax
  801666:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801669:	8b 45 10             	mov    0x10(%ebp),%eax
  80166c:	ff 75 f4             	pushl  -0xc(%ebp)
  80166f:	50                   	push   %eax
  801670:	ff 75 0c             	pushl  0xc(%ebp)
  801673:	ff 75 08             	pushl  0x8(%ebp)
  801676:	e8 89 ff ff ff       	call   801604 <vsnprintf>
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801681:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80168c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801693:	eb 06                	jmp    80169b <strlen+0x15>
		n++;
  801695:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801698:	ff 45 08             	incl   0x8(%ebp)
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	8a 00                	mov    (%eax),%al
  8016a0:	84 c0                	test   %al,%al
  8016a2:	75 f1                	jne    801695 <strlen+0xf>
		n++;
	return n;
  8016a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016b6:	eb 09                	jmp    8016c1 <strnlen+0x18>
		n++;
  8016b8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016bb:	ff 45 08             	incl   0x8(%ebp)
  8016be:	ff 4d 0c             	decl   0xc(%ebp)
  8016c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016c5:	74 09                	je     8016d0 <strnlen+0x27>
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	8a 00                	mov    (%eax),%al
  8016cc:	84 c0                	test   %al,%al
  8016ce:	75 e8                	jne    8016b8 <strnlen+0xf>
		n++;
	return n;
  8016d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016e1:	90                   	nop
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8d 50 01             	lea    0x1(%eax),%edx
  8016e8:	89 55 08             	mov    %edx,0x8(%ebp)
  8016eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016f1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016f4:	8a 12                	mov    (%edx),%dl
  8016f6:	88 10                	mov    %dl,(%eax)
  8016f8:	8a 00                	mov    (%eax),%al
  8016fa:	84 c0                	test   %al,%al
  8016fc:	75 e4                	jne    8016e2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80170f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801716:	eb 1f                	jmp    801737 <strncpy+0x34>
		*dst++ = *src;
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	8d 50 01             	lea    0x1(%eax),%edx
  80171e:	89 55 08             	mov    %edx,0x8(%ebp)
  801721:	8b 55 0c             	mov    0xc(%ebp),%edx
  801724:	8a 12                	mov    (%edx),%dl
  801726:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172b:	8a 00                	mov    (%eax),%al
  80172d:	84 c0                	test   %al,%al
  80172f:	74 03                	je     801734 <strncpy+0x31>
			src++;
  801731:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801734:	ff 45 fc             	incl   -0x4(%ebp)
  801737:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80173a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80173d:	72 d9                	jb     801718 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80173f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801750:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801754:	74 30                	je     801786 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801756:	eb 16                	jmp    80176e <strlcpy+0x2a>
			*dst++ = *src++;
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	8d 50 01             	lea    0x1(%eax),%edx
  80175e:	89 55 08             	mov    %edx,0x8(%ebp)
  801761:	8b 55 0c             	mov    0xc(%ebp),%edx
  801764:	8d 4a 01             	lea    0x1(%edx),%ecx
  801767:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80176a:	8a 12                	mov    (%edx),%dl
  80176c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80176e:	ff 4d 10             	decl   0x10(%ebp)
  801771:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801775:	74 09                	je     801780 <strlcpy+0x3c>
  801777:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177a:	8a 00                	mov    (%eax),%al
  80177c:	84 c0                	test   %al,%al
  80177e:	75 d8                	jne    801758 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801786:	8b 55 08             	mov    0x8(%ebp),%edx
  801789:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80178c:	29 c2                	sub    %eax,%edx
  80178e:	89 d0                	mov    %edx,%eax
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801795:	eb 06                	jmp    80179d <strcmp+0xb>
		p++, q++;
  801797:	ff 45 08             	incl   0x8(%ebp)
  80179a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8a 00                	mov    (%eax),%al
  8017a2:	84 c0                	test   %al,%al
  8017a4:	74 0e                	je     8017b4 <strcmp+0x22>
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	8a 10                	mov    (%eax),%dl
  8017ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ae:	8a 00                	mov    (%eax),%al
  8017b0:	38 c2                	cmp    %al,%dl
  8017b2:	74 e3                	je     801797 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	8a 00                	mov    (%eax),%al
  8017b9:	0f b6 d0             	movzbl %al,%edx
  8017bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bf:	8a 00                	mov    (%eax),%al
  8017c1:	0f b6 c0             	movzbl %al,%eax
  8017c4:	29 c2                	sub    %eax,%edx
  8017c6:	89 d0                	mov    %edx,%eax
}
  8017c8:	5d                   	pop    %ebp
  8017c9:	c3                   	ret    

008017ca <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8017cd:	eb 09                	jmp    8017d8 <strncmp+0xe>
		n--, p++, q++;
  8017cf:	ff 4d 10             	decl   0x10(%ebp)
  8017d2:	ff 45 08             	incl   0x8(%ebp)
  8017d5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8017d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017dc:	74 17                	je     8017f5 <strncmp+0x2b>
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	84 c0                	test   %al,%al
  8017e5:	74 0e                	je     8017f5 <strncmp+0x2b>
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	8a 10                	mov    (%eax),%dl
  8017ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ef:	8a 00                	mov    (%eax),%al
  8017f1:	38 c2                	cmp    %al,%dl
  8017f3:	74 da                	je     8017cf <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f9:	75 07                	jne    801802 <strncmp+0x38>
		return 0;
  8017fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801800:	eb 14                	jmp    801816 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	8a 00                	mov    (%eax),%al
  801807:	0f b6 d0             	movzbl %al,%edx
  80180a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180d:	8a 00                	mov    (%eax),%al
  80180f:	0f b6 c0             	movzbl %al,%eax
  801812:	29 c2                	sub    %eax,%edx
  801814:	89 d0                	mov    %edx,%eax
}
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    

00801818 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 04             	sub    $0x4,%esp
  80181e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801821:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801824:	eb 12                	jmp    801838 <strchr+0x20>
		if (*s == c)
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80182e:	75 05                	jne    801835 <strchr+0x1d>
			return (char *) s;
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	eb 11                	jmp    801846 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801835:	ff 45 08             	incl   0x8(%ebp)
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	84 c0                	test   %al,%al
  80183f:	75 e5                	jne    801826 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801841:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 04             	sub    $0x4,%esp
  80184e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801851:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801854:	eb 0d                	jmp    801863 <strfind+0x1b>
		if (*s == c)
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80185e:	74 0e                	je     80186e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801860:	ff 45 08             	incl   0x8(%ebp)
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	8a 00                	mov    (%eax),%al
  801868:	84 c0                	test   %al,%al
  80186a:	75 ea                	jne    801856 <strfind+0xe>
  80186c:	eb 01                	jmp    80186f <strfind+0x27>
		if (*s == c)
			break;
  80186e:	90                   	nop
	return (char *) s;
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801880:	8b 45 10             	mov    0x10(%ebp),%eax
  801883:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801886:	eb 0e                	jmp    801896 <memset+0x22>
		*p++ = c;
  801888:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80188b:	8d 50 01             	lea    0x1(%eax),%edx
  80188e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801891:	8b 55 0c             	mov    0xc(%ebp),%edx
  801894:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801896:	ff 4d f8             	decl   -0x8(%ebp)
  801899:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80189d:	79 e9                	jns    801888 <memset+0x14>
		*p++ = c;

	return v;
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8018b6:	eb 16                	jmp    8018ce <memcpy+0x2a>
		*d++ = *s++;
  8018b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018bb:	8d 50 01             	lea    0x1(%eax),%edx
  8018be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018c7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018ca:	8a 12                	mov    (%edx),%dl
  8018cc:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8018ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8018d7:	85 c0                	test   %eax,%eax
  8018d9:	75 dd                	jne    8018b8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018f8:	73 50                	jae    80194a <memmove+0x6a>
  8018fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801900:	01 d0                	add    %edx,%eax
  801902:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801905:	76 43                	jbe    80194a <memmove+0x6a>
		s += n;
  801907:	8b 45 10             	mov    0x10(%ebp),%eax
  80190a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80190d:	8b 45 10             	mov    0x10(%ebp),%eax
  801910:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801913:	eb 10                	jmp    801925 <memmove+0x45>
			*--d = *--s;
  801915:	ff 4d f8             	decl   -0x8(%ebp)
  801918:	ff 4d fc             	decl   -0x4(%ebp)
  80191b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80191e:	8a 10                	mov    (%eax),%dl
  801920:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801923:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801925:	8b 45 10             	mov    0x10(%ebp),%eax
  801928:	8d 50 ff             	lea    -0x1(%eax),%edx
  80192b:	89 55 10             	mov    %edx,0x10(%ebp)
  80192e:	85 c0                	test   %eax,%eax
  801930:	75 e3                	jne    801915 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801932:	eb 23                	jmp    801957 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801934:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801937:	8d 50 01             	lea    0x1(%eax),%edx
  80193a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80193d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801940:	8d 4a 01             	lea    0x1(%edx),%ecx
  801943:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801946:	8a 12                	mov    (%edx),%dl
  801948:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80194a:	8b 45 10             	mov    0x10(%ebp),%eax
  80194d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801950:	89 55 10             	mov    %edx,0x10(%ebp)
  801953:	85 c0                	test   %eax,%eax
  801955:	75 dd                	jne    801934 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80196e:	eb 2a                	jmp    80199a <memcmp+0x3e>
		if (*s1 != *s2)
  801970:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801973:	8a 10                	mov    (%eax),%dl
  801975:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801978:	8a 00                	mov    (%eax),%al
  80197a:	38 c2                	cmp    %al,%dl
  80197c:	74 16                	je     801994 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80197e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801981:	8a 00                	mov    (%eax),%al
  801983:	0f b6 d0             	movzbl %al,%edx
  801986:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801989:	8a 00                	mov    (%eax),%al
  80198b:	0f b6 c0             	movzbl %al,%eax
  80198e:	29 c2                	sub    %eax,%edx
  801990:	89 d0                	mov    %edx,%eax
  801992:	eb 18                	jmp    8019ac <memcmp+0x50>
		s1++, s2++;
  801994:	ff 45 fc             	incl   -0x4(%ebp)
  801997:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80199a:	8b 45 10             	mov    0x10(%ebp),%eax
  80199d:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	75 c9                	jne    801970 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8019a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8019b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8019b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ba:	01 d0                	add    %edx,%eax
  8019bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8019bf:	eb 15                	jmp    8019d6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	8a 00                	mov    (%eax),%al
  8019c6:	0f b6 d0             	movzbl %al,%edx
  8019c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cc:	0f b6 c0             	movzbl %al,%eax
  8019cf:	39 c2                	cmp    %eax,%edx
  8019d1:	74 0d                	je     8019e0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019d3:	ff 45 08             	incl   0x8(%ebp)
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019dc:	72 e3                	jb     8019c1 <memfind+0x13>
  8019de:	eb 01                	jmp    8019e1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019e0:	90                   	nop
	return (void *) s;
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019fa:	eb 03                	jmp    8019ff <strtol+0x19>
		s++;
  8019fc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	3c 20                	cmp    $0x20,%al
  801a06:	74 f4                	je     8019fc <strtol+0x16>
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	8a 00                	mov    (%eax),%al
  801a0d:	3c 09                	cmp    $0x9,%al
  801a0f:	74 eb                	je     8019fc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	8a 00                	mov    (%eax),%al
  801a16:	3c 2b                	cmp    $0x2b,%al
  801a18:	75 05                	jne    801a1f <strtol+0x39>
		s++;
  801a1a:	ff 45 08             	incl   0x8(%ebp)
  801a1d:	eb 13                	jmp    801a32 <strtol+0x4c>
	else if (*s == '-')
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	8a 00                	mov    (%eax),%al
  801a24:	3c 2d                	cmp    $0x2d,%al
  801a26:	75 0a                	jne    801a32 <strtol+0x4c>
		s++, neg = 1;
  801a28:	ff 45 08             	incl   0x8(%ebp)
  801a2b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a36:	74 06                	je     801a3e <strtol+0x58>
  801a38:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a3c:	75 20                	jne    801a5e <strtol+0x78>
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	3c 30                	cmp    $0x30,%al
  801a45:	75 17                	jne    801a5e <strtol+0x78>
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	40                   	inc    %eax
  801a4b:	8a 00                	mov    (%eax),%al
  801a4d:	3c 78                	cmp    $0x78,%al
  801a4f:	75 0d                	jne    801a5e <strtol+0x78>
		s += 2, base = 16;
  801a51:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a55:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a5c:	eb 28                	jmp    801a86 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a62:	75 15                	jne    801a79 <strtol+0x93>
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8a 00                	mov    (%eax),%al
  801a69:	3c 30                	cmp    $0x30,%al
  801a6b:	75 0c                	jne    801a79 <strtol+0x93>
		s++, base = 8;
  801a6d:	ff 45 08             	incl   0x8(%ebp)
  801a70:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a77:	eb 0d                	jmp    801a86 <strtol+0xa0>
	else if (base == 0)
  801a79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a7d:	75 07                	jne    801a86 <strtol+0xa0>
		base = 10;
  801a7f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	8a 00                	mov    (%eax),%al
  801a8b:	3c 2f                	cmp    $0x2f,%al
  801a8d:	7e 19                	jle    801aa8 <strtol+0xc2>
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	8a 00                	mov    (%eax),%al
  801a94:	3c 39                	cmp    $0x39,%al
  801a96:	7f 10                	jg     801aa8 <strtol+0xc2>
			dig = *s - '0';
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	8a 00                	mov    (%eax),%al
  801a9d:	0f be c0             	movsbl %al,%eax
  801aa0:	83 e8 30             	sub    $0x30,%eax
  801aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aa6:	eb 42                	jmp    801aea <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	8a 00                	mov    (%eax),%al
  801aad:	3c 60                	cmp    $0x60,%al
  801aaf:	7e 19                	jle    801aca <strtol+0xe4>
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	8a 00                	mov    (%eax),%al
  801ab6:	3c 7a                	cmp    $0x7a,%al
  801ab8:	7f 10                	jg     801aca <strtol+0xe4>
			dig = *s - 'a' + 10;
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	8a 00                	mov    (%eax),%al
  801abf:	0f be c0             	movsbl %al,%eax
  801ac2:	83 e8 57             	sub    $0x57,%eax
  801ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ac8:	eb 20                	jmp    801aea <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	8a 00                	mov    (%eax),%al
  801acf:	3c 40                	cmp    $0x40,%al
  801ad1:	7e 39                	jle    801b0c <strtol+0x126>
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	8a 00                	mov    (%eax),%al
  801ad8:	3c 5a                	cmp    $0x5a,%al
  801ada:	7f 30                	jg     801b0c <strtol+0x126>
			dig = *s - 'A' + 10;
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	8a 00                	mov    (%eax),%al
  801ae1:	0f be c0             	movsbl %al,%eax
  801ae4:	83 e8 37             	sub    $0x37,%eax
  801ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aed:	3b 45 10             	cmp    0x10(%ebp),%eax
  801af0:	7d 19                	jge    801b0b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801af2:	ff 45 08             	incl   0x8(%ebp)
  801af5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801af8:	0f af 45 10          	imul   0x10(%ebp),%eax
  801afc:	89 c2                	mov    %eax,%edx
  801afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b01:	01 d0                	add    %edx,%eax
  801b03:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801b06:	e9 7b ff ff ff       	jmp    801a86 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801b0b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801b0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b10:	74 08                	je     801b1a <strtol+0x134>
		*endptr = (char *) s;
  801b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b15:	8b 55 08             	mov    0x8(%ebp),%edx
  801b18:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801b1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b1e:	74 07                	je     801b27 <strtol+0x141>
  801b20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b23:	f7 d8                	neg    %eax
  801b25:	eb 03                	jmp    801b2a <strtol+0x144>
  801b27:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <ltostr>:

void
ltostr(long value, char *str)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801b32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801b39:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b44:	79 13                	jns    801b59 <ltostr+0x2d>
	{
		neg = 1;
  801b46:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b50:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b53:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b56:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b61:	99                   	cltd   
  801b62:	f7 f9                	idiv   %ecx
  801b64:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b6a:	8d 50 01             	lea    0x1(%eax),%edx
  801b6d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b70:	89 c2                	mov    %eax,%edx
  801b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b75:	01 d0                	add    %edx,%eax
  801b77:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b7a:	83 c2 30             	add    $0x30,%edx
  801b7d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b82:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b87:	f7 e9                	imul   %ecx
  801b89:	c1 fa 02             	sar    $0x2,%edx
  801b8c:	89 c8                	mov    %ecx,%eax
  801b8e:	c1 f8 1f             	sar    $0x1f,%eax
  801b91:	29 c2                	sub    %eax,%edx
  801b93:	89 d0                	mov    %edx,%eax
  801b95:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801b98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b9b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ba0:	f7 e9                	imul   %ecx
  801ba2:	c1 fa 02             	sar    $0x2,%edx
  801ba5:	89 c8                	mov    %ecx,%eax
  801ba7:	c1 f8 1f             	sar    $0x1f,%eax
  801baa:	29 c2                	sub    %eax,%edx
  801bac:	89 d0                	mov    %edx,%eax
  801bae:	c1 e0 02             	shl    $0x2,%eax
  801bb1:	01 d0                	add    %edx,%eax
  801bb3:	01 c0                	add    %eax,%eax
  801bb5:	29 c1                	sub    %eax,%ecx
  801bb7:	89 ca                	mov    %ecx,%edx
  801bb9:	85 d2                	test   %edx,%edx
  801bbb:	75 9c                	jne    801b59 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801bbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801bc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc7:	48                   	dec    %eax
  801bc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801bcb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bcf:	74 3d                	je     801c0e <ltostr+0xe2>
		start = 1 ;
  801bd1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801bd8:	eb 34                	jmp    801c0e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be0:	01 d0                	add    %edx,%eax
  801be2:	8a 00                	mov    (%eax),%al
  801be4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bed:	01 c2                	add    %eax,%edx
  801bef:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf5:	01 c8                	add    %ecx,%eax
  801bf7:	8a 00                	mov    (%eax),%al
  801bf9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801bfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c01:	01 c2                	add    %eax,%edx
  801c03:	8a 45 eb             	mov    -0x15(%ebp),%al
  801c06:	88 02                	mov    %al,(%edx)
		start++ ;
  801c08:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801c0b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c11:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c14:	7c c4                	jl     801bda <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801c16:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1c:	01 d0                	add    %edx,%eax
  801c1e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801c21:	90                   	nop
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c2a:	ff 75 08             	pushl  0x8(%ebp)
  801c2d:	e8 54 fa ff ff       	call   801686 <strlen>
  801c32:	83 c4 04             	add    $0x4,%esp
  801c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c38:	ff 75 0c             	pushl  0xc(%ebp)
  801c3b:	e8 46 fa ff ff       	call   801686 <strlen>
  801c40:	83 c4 04             	add    $0x4,%esp
  801c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801c4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c54:	eb 17                	jmp    801c6d <strcconcat+0x49>
		final[s] = str1[s] ;
  801c56:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c59:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5c:	01 c2                	add    %eax,%edx
  801c5e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	01 c8                	add    %ecx,%eax
  801c66:	8a 00                	mov    (%eax),%al
  801c68:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c6a:	ff 45 fc             	incl   -0x4(%ebp)
  801c6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c70:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c73:	7c e1                	jl     801c56 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c75:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c7c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c83:	eb 1f                	jmp    801ca4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c88:	8d 50 01             	lea    0x1(%eax),%edx
  801c8b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c8e:	89 c2                	mov    %eax,%edx
  801c90:	8b 45 10             	mov    0x10(%ebp),%eax
  801c93:	01 c2                	add    %eax,%edx
  801c95:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9b:	01 c8                	add    %ecx,%eax
  801c9d:	8a 00                	mov    (%eax),%al
  801c9f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801ca1:	ff 45 f8             	incl   -0x8(%ebp)
  801ca4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801caa:	7c d9                	jl     801c85 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801cac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801caf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb2:	01 d0                	add    %edx,%eax
  801cb4:	c6 00 00             	movb   $0x0,(%eax)
}
  801cb7:	90                   	nop
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801cbd:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801cc6:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc9:	8b 00                	mov    (%eax),%eax
  801ccb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cd2:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd5:	01 d0                	add    %edx,%eax
  801cd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cdd:	eb 0c                	jmp    801ceb <strsplit+0x31>
			*string++ = 0;
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	8d 50 01             	lea    0x1(%eax),%edx
  801ce5:	89 55 08             	mov    %edx,0x8(%ebp)
  801ce8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	8a 00                	mov    (%eax),%al
  801cf0:	84 c0                	test   %al,%al
  801cf2:	74 18                	je     801d0c <strsplit+0x52>
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	8a 00                	mov    (%eax),%al
  801cf9:	0f be c0             	movsbl %al,%eax
  801cfc:	50                   	push   %eax
  801cfd:	ff 75 0c             	pushl  0xc(%ebp)
  801d00:	e8 13 fb ff ff       	call   801818 <strchr>
  801d05:	83 c4 08             	add    $0x8,%esp
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	75 d3                	jne    801cdf <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	8a 00                	mov    (%eax),%al
  801d11:	84 c0                	test   %al,%al
  801d13:	74 5a                	je     801d6f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801d15:	8b 45 14             	mov    0x14(%ebp),%eax
  801d18:	8b 00                	mov    (%eax),%eax
  801d1a:	83 f8 0f             	cmp    $0xf,%eax
  801d1d:	75 07                	jne    801d26 <strsplit+0x6c>
		{
			return 0;
  801d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d24:	eb 66                	jmp    801d8c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801d26:	8b 45 14             	mov    0x14(%ebp),%eax
  801d29:	8b 00                	mov    (%eax),%eax
  801d2b:	8d 48 01             	lea    0x1(%eax),%ecx
  801d2e:	8b 55 14             	mov    0x14(%ebp),%edx
  801d31:	89 0a                	mov    %ecx,(%edx)
  801d33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d3d:	01 c2                	add    %eax,%edx
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d44:	eb 03                	jmp    801d49 <strsplit+0x8f>
			string++;
  801d46:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d49:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4c:	8a 00                	mov    (%eax),%al
  801d4e:	84 c0                	test   %al,%al
  801d50:	74 8b                	je     801cdd <strsplit+0x23>
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	8a 00                	mov    (%eax),%al
  801d57:	0f be c0             	movsbl %al,%eax
  801d5a:	50                   	push   %eax
  801d5b:	ff 75 0c             	pushl  0xc(%ebp)
  801d5e:	e8 b5 fa ff ff       	call   801818 <strchr>
  801d63:	83 c4 08             	add    $0x8,%esp
  801d66:	85 c0                	test   %eax,%eax
  801d68:	74 dc                	je     801d46 <strsplit+0x8c>
			string++;
	}
  801d6a:	e9 6e ff ff ff       	jmp    801cdd <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d6f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d70:	8b 45 14             	mov    0x14(%ebp),%eax
  801d73:	8b 00                	mov    (%eax),%eax
  801d75:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7f:	01 d0                	add    %edx,%eax
  801d81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d87:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801d94:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  801d9e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801da1:	01 d0                	add    %edx,%eax
  801da3:	48                   	dec    %eax
  801da4:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801da7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801daa:	ba 00 00 00 00       	mov    $0x0,%edx
  801daf:	f7 75 ac             	divl   -0x54(%ebp)
  801db2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801db5:	29 d0                	sub    %edx,%eax
  801db7:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801dba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801dc1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801dc8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801dcf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801dd6:	eb 3f                	jmp    801e17 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801dd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ddb:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801de2:	83 ec 04             	sub    $0x4,%esp
  801de5:	50                   	push   %eax
  801de6:	ff 75 e8             	pushl  -0x18(%ebp)
  801de9:	68 90 34 80 00       	push   $0x803490
  801dee:	e8 11 f2 ff ff       	call   801004 <cprintf>
  801df3:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801df9:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801e00:	83 ec 04             	sub    $0x4,%esp
  801e03:	50                   	push   %eax
  801e04:	ff 75 e8             	pushl  -0x18(%ebp)
  801e07:	68 a5 34 80 00       	push   $0x8034a5
  801e0c:	e8 f3 f1 ff ff       	call   801004 <cprintf>
  801e11:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801e14:	ff 45 e8             	incl   -0x18(%ebp)
  801e17:	a1 28 40 80 00       	mov    0x804028,%eax
  801e1c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801e1f:	7c b7                	jl     801dd8 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801e21:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801e28:	e9 42 01 00 00       	jmp    801f6f <malloc+0x1e1>
		int flag0=1;
  801e2d:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801e34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e37:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e3a:	eb 6b                	jmp    801ea7 <malloc+0x119>
			for(int k=0;k<count;k++){
  801e3c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801e43:	eb 42                	jmp    801e87 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801e45:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e48:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801e4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e52:	39 c2                	cmp    %eax,%edx
  801e54:	77 2e                	ja     801e84 <malloc+0xf6>
  801e56:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e59:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801e60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e63:	39 c2                	cmp    %eax,%edx
  801e65:	76 1d                	jbe    801e84 <malloc+0xf6>
					ni=arr_add[k].end-i;
  801e67:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e6a:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801e71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e74:	29 c2                	sub    %eax,%edx
  801e76:	89 d0                	mov    %edx,%eax
  801e78:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801e7b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801e82:	eb 0d                	jmp    801e91 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801e84:	ff 45 d8             	incl   -0x28(%ebp)
  801e87:	a1 28 40 80 00       	mov    0x804028,%eax
  801e8c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801e8f:	7c b4                	jl     801e45 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801e91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e95:	74 09                	je     801ea0 <malloc+0x112>
				flag0=0;
  801e97:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801e9e:	eb 16                	jmp    801eb6 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801ea0:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801ea7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ead:	01 c2                	add    %eax,%edx
  801eaf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eb2:	39 c2                	cmp    %eax,%edx
  801eb4:	77 86                	ja     801e3c <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801eb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801eba:	0f 84 a2 00 00 00    	je     801f62 <malloc+0x1d4>

			int f=1;
  801ec0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801ec7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801eca:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ecd:	89 c8                	mov    %ecx,%eax
  801ecf:	01 c0                	add    %eax,%eax
  801ed1:	01 c8                	add    %ecx,%eax
  801ed3:	c1 e0 02             	shl    $0x2,%eax
  801ed6:	05 20 41 80 00       	add    $0x804120,%eax
  801edb:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801edd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801ee6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee9:	89 d0                	mov    %edx,%eax
  801eeb:	01 c0                	add    %eax,%eax
  801eed:	01 d0                	add    %edx,%eax
  801eef:	c1 e0 02             	shl    $0x2,%eax
  801ef2:	05 24 41 80 00       	add    $0x804124,%eax
  801ef7:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801ef9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efc:	89 d0                	mov    %edx,%eax
  801efe:	01 c0                	add    %eax,%eax
  801f00:	01 d0                	add    %edx,%eax
  801f02:	c1 e0 02             	shl    $0x2,%eax
  801f05:	05 28 41 80 00       	add    $0x804128,%eax
  801f0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801f10:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801f13:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801f1a:	eb 36                	jmp    801f52 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801f1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	01 c2                	add    %eax,%edx
  801f24:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f27:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801f2e:	39 c2                	cmp    %eax,%edx
  801f30:	73 1d                	jae    801f4f <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801f32:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f35:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f3f:	29 c2                	sub    %eax,%edx
  801f41:	89 d0                	mov    %edx,%eax
  801f43:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801f46:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801f4d:	eb 0d                	jmp    801f5c <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801f4f:	ff 45 d0             	incl   -0x30(%ebp)
  801f52:	a1 28 40 80 00       	mov    0x804028,%eax
  801f57:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801f5a:	7c c0                	jl     801f1c <malloc+0x18e>
					break;

				}
			}

			if(f){
  801f5c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801f60:	75 1d                	jne    801f7f <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801f62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f6c:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801f6f:	a1 04 40 80 00       	mov    0x804004,%eax
  801f74:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f77:	0f 8c b0 fe ff ff    	jl     801e2d <malloc+0x9f>
  801f7d:	eb 01                	jmp    801f80 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801f7f:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801f80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f84:	75 7a                	jne    802000 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801f86:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	01 d0                	add    %edx,%eax
  801f91:	48                   	dec    %eax
  801f92:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801f97:	7c 0a                	jl     801fa3 <malloc+0x215>
			return NULL;
  801f99:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9e:	e9 a4 02 00 00       	jmp    802247 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801fa3:	a1 04 40 80 00       	mov    0x804004,%eax
  801fa8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801fab:	a1 28 40 80 00       	mov    0x804028,%eax
  801fb0:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801fb3:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801fba:	83 ec 08             	sub    $0x8,%esp
  801fbd:	ff 75 08             	pushl  0x8(%ebp)
  801fc0:	ff 75 a4             	pushl  -0x5c(%ebp)
  801fc3:	e8 04 06 00 00       	call   8025cc <sys_allocateMem>
  801fc8:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801fcb:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	01 d0                	add    %edx,%eax
  801fd6:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801fdb:	a1 28 40 80 00       	mov    0x804028,%eax
  801fe0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801fe6:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801fed:	a1 28 40 80 00       	mov    0x804028,%eax
  801ff2:	40                   	inc    %eax
  801ff3:	a3 28 40 80 00       	mov    %eax,0x804028

			return (void*)s;
  801ff8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801ffb:	e9 47 02 00 00       	jmp    802247 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  802000:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802007:	e9 ac 00 00 00       	jmp    8020b8 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  80200c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80200f:	89 d0                	mov    %edx,%eax
  802011:	01 c0                	add    %eax,%eax
  802013:	01 d0                	add    %edx,%eax
  802015:	c1 e0 02             	shl    $0x2,%eax
  802018:	05 24 41 80 00       	add    $0x804124,%eax
  80201d:	8b 00                	mov    (%eax),%eax
  80201f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802022:	eb 7e                	jmp    8020a2 <malloc+0x314>
			int flag=0;
  802024:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  80202b:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  802032:	eb 57                	jmp    80208b <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  802034:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802037:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  80203e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802041:	39 c2                	cmp    %eax,%edx
  802043:	77 1a                	ja     80205f <malloc+0x2d1>
  802045:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802048:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  80204f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802052:	39 c2                	cmp    %eax,%edx
  802054:	76 09                	jbe    80205f <malloc+0x2d1>
								flag=1;
  802056:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  80205d:	eb 36                	jmp    802095 <malloc+0x307>
			arr[i].space++;
  80205f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802062:	89 d0                	mov    %edx,%eax
  802064:	01 c0                	add    %eax,%eax
  802066:	01 d0                	add    %edx,%eax
  802068:	c1 e0 02             	shl    $0x2,%eax
  80206b:	05 28 41 80 00       	add    $0x804128,%eax
  802070:	8b 00                	mov    (%eax),%eax
  802072:	8d 48 01             	lea    0x1(%eax),%ecx
  802075:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802078:	89 d0                	mov    %edx,%eax
  80207a:	01 c0                	add    %eax,%eax
  80207c:	01 d0                	add    %edx,%eax
  80207e:	c1 e0 02             	shl    $0x2,%eax
  802081:	05 28 41 80 00       	add    $0x804128,%eax
  802086:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  802088:	ff 45 c0             	incl   -0x40(%ebp)
  80208b:	a1 28 40 80 00       	mov    0x804028,%eax
  802090:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  802093:	7c 9f                	jl     802034 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  802095:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  802099:	75 19                	jne    8020b4 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  80209b:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8020a2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8020a5:	a1 04 40 80 00       	mov    0x804004,%eax
  8020aa:	39 c2                	cmp    %eax,%edx
  8020ac:	0f 82 72 ff ff ff    	jb     802024 <malloc+0x296>
  8020b2:	eb 01                	jmp    8020b5 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  8020b4:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  8020b5:	ff 45 cc             	incl   -0x34(%ebp)
  8020b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8020be:	0f 8c 48 ff ff ff    	jl     80200c <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  8020c4:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  8020cb:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  8020d2:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  8020d9:	eb 37                	jmp    802112 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  8020db:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8020de:	89 d0                	mov    %edx,%eax
  8020e0:	01 c0                	add    %eax,%eax
  8020e2:	01 d0                	add    %edx,%eax
  8020e4:	c1 e0 02             	shl    $0x2,%eax
  8020e7:	05 28 41 80 00       	add    $0x804128,%eax
  8020ec:	8b 00                	mov    (%eax),%eax
  8020ee:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020f1:	7d 1c                	jge    80210f <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  8020f3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8020f6:	89 d0                	mov    %edx,%eax
  8020f8:	01 c0                	add    %eax,%eax
  8020fa:	01 d0                	add    %edx,%eax
  8020fc:	c1 e0 02             	shl    $0x2,%eax
  8020ff:	05 28 41 80 00       	add    $0x804128,%eax
  802104:	8b 00                	mov    (%eax),%eax
  802106:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  802109:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80210c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  80210f:	ff 45 b4             	incl   -0x4c(%ebp)
  802112:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802115:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802118:	7c c1                	jl     8020db <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  80211a:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802120:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  802123:	89 c8                	mov    %ecx,%eax
  802125:	01 c0                	add    %eax,%eax
  802127:	01 c8                	add    %ecx,%eax
  802129:	c1 e0 02             	shl    $0x2,%eax
  80212c:	05 20 41 80 00       	add    $0x804120,%eax
  802131:	8b 00                	mov    (%eax),%eax
  802133:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  80213a:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802140:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  802143:	89 c8                	mov    %ecx,%eax
  802145:	01 c0                	add    %eax,%eax
  802147:	01 c8                	add    %ecx,%eax
  802149:	c1 e0 02             	shl    $0x2,%eax
  80214c:	05 24 41 80 00       	add    $0x804124,%eax
  802151:	8b 00                	mov    (%eax),%eax
  802153:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  80215a:	a1 28 40 80 00       	mov    0x804028,%eax
  80215f:	40                   	inc    %eax
  802160:	a3 28 40 80 00       	mov    %eax,0x804028


		sys_allocateMem(arr[index].start,size);
  802165:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802168:	89 d0                	mov    %edx,%eax
  80216a:	01 c0                	add    %eax,%eax
  80216c:	01 d0                	add    %edx,%eax
  80216e:	c1 e0 02             	shl    $0x2,%eax
  802171:	05 20 41 80 00       	add    $0x804120,%eax
  802176:	8b 00                	mov    (%eax),%eax
  802178:	83 ec 08             	sub    $0x8,%esp
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	50                   	push   %eax
  80217f:	e8 48 04 00 00       	call   8025cc <sys_allocateMem>
  802184:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  802187:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  80218e:	eb 78                	jmp    802208 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  802190:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802193:	89 d0                	mov    %edx,%eax
  802195:	01 c0                	add    %eax,%eax
  802197:	01 d0                	add    %edx,%eax
  802199:	c1 e0 02             	shl    $0x2,%eax
  80219c:	05 20 41 80 00       	add    $0x804120,%eax
  8021a1:	8b 00                	mov    (%eax),%eax
  8021a3:	83 ec 04             	sub    $0x4,%esp
  8021a6:	50                   	push   %eax
  8021a7:	ff 75 b0             	pushl  -0x50(%ebp)
  8021aa:	68 90 34 80 00       	push   $0x803490
  8021af:	e8 50 ee ff ff       	call   801004 <cprintf>
  8021b4:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8021b7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021ba:	89 d0                	mov    %edx,%eax
  8021bc:	01 c0                	add    %eax,%eax
  8021be:	01 d0                	add    %edx,%eax
  8021c0:	c1 e0 02             	shl    $0x2,%eax
  8021c3:	05 24 41 80 00       	add    $0x804124,%eax
  8021c8:	8b 00                	mov    (%eax),%eax
  8021ca:	83 ec 04             	sub    $0x4,%esp
  8021cd:	50                   	push   %eax
  8021ce:	ff 75 b0             	pushl  -0x50(%ebp)
  8021d1:	68 a5 34 80 00       	push   $0x8034a5
  8021d6:	e8 29 ee ff ff       	call   801004 <cprintf>
  8021db:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  8021de:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021e1:	89 d0                	mov    %edx,%eax
  8021e3:	01 c0                	add    %eax,%eax
  8021e5:	01 d0                	add    %edx,%eax
  8021e7:	c1 e0 02             	shl    $0x2,%eax
  8021ea:	05 28 41 80 00       	add    $0x804128,%eax
  8021ef:	8b 00                	mov    (%eax),%eax
  8021f1:	83 ec 04             	sub    $0x4,%esp
  8021f4:	50                   	push   %eax
  8021f5:	ff 75 b0             	pushl  -0x50(%ebp)
  8021f8:	68 b8 34 80 00       	push   $0x8034b8
  8021fd:	e8 02 ee ff ff       	call   801004 <cprintf>
  802202:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  802205:	ff 45 b0             	incl   -0x50(%ebp)
  802208:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80220b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80220e:	7c 80                	jl     802190 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  802210:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802213:	89 d0                	mov    %edx,%eax
  802215:	01 c0                	add    %eax,%eax
  802217:	01 d0                	add    %edx,%eax
  802219:	c1 e0 02             	shl    $0x2,%eax
  80221c:	05 20 41 80 00       	add    $0x804120,%eax
  802221:	8b 00                	mov    (%eax),%eax
  802223:	83 ec 08             	sub    $0x8,%esp
  802226:	50                   	push   %eax
  802227:	68 cc 34 80 00       	push   $0x8034cc
  80222c:	e8 d3 ed ff ff       	call   801004 <cprintf>
  802231:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  802234:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802237:	89 d0                	mov    %edx,%eax
  802239:	01 c0                	add    %eax,%eax
  80223b:	01 d0                	add    %edx,%eax
  80223d:	c1 e0 02             	shl    $0x2,%eax
  802240:	05 20 41 80 00       	add    $0x804120,%eax
  802245:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  802247:	c9                   	leave  
  802248:	c3                   	ret    

00802249 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  80224f:	8b 45 08             	mov    0x8(%ebp),%eax
  802252:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  802255:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80225c:	eb 4b                	jmp    8022a9 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  80225e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802261:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  802268:	89 c2                	mov    %eax,%edx
  80226a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80226d:	39 c2                	cmp    %eax,%edx
  80226f:	7f 35                	jg     8022a6 <free+0x5d>
  802271:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802274:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  80227b:	89 c2                	mov    %eax,%edx
  80227d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802280:	39 c2                	cmp    %eax,%edx
  802282:	7e 22                	jle    8022a6 <free+0x5d>
				start=arr_add[i].start;
  802284:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802287:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  80228e:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  802291:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802294:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  80229b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  80229e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8022a4:	eb 0d                	jmp    8022b3 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8022a6:	ff 45 ec             	incl   -0x14(%ebp)
  8022a9:	a1 28 40 80 00       	mov    0x804028,%eax
  8022ae:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8022b1:	7c ab                	jl     80225e <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8022b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b6:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  8022bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c0:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  8022c7:	29 c2                	sub    %eax,%edx
  8022c9:	89 d0                	mov    %edx,%eax
  8022cb:	83 ec 08             	sub    $0x8,%esp
  8022ce:	50                   	push   %eax
  8022cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d2:	e8 d9 02 00 00       	call   8025b0 <sys_freeMem>
  8022d7:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  8022da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022e0:	eb 2d                	jmp    80230f <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  8022e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022e5:	40                   	inc    %eax
  8022e6:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  8022ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022f0:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  8022f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022fa:	40                   	inc    %eax
  8022fb:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  802302:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802305:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  80230c:	ff 45 e8             	incl   -0x18(%ebp)
  80230f:	a1 28 40 80 00       	mov    0x804028,%eax
  802314:	48                   	dec    %eax
  802315:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802318:	7f c8                	jg     8022e2 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  80231a:	a1 28 40 80 00       	mov    0x804028,%eax
  80231f:	48                   	dec    %eax
  802320:	a3 28 40 80 00       	mov    %eax,0x804028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  802325:	90                   	nop
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	83 ec 18             	sub    $0x18,%esp
  80232e:	8b 45 10             	mov    0x10(%ebp),%eax
  802331:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  802334:	83 ec 04             	sub    $0x4,%esp
  802337:	68 e8 34 80 00       	push   $0x8034e8
  80233c:	68 18 01 00 00       	push   $0x118
  802341:	68 0b 35 80 00       	push   $0x80350b
  802346:	e8 17 ea ff ff       	call   800d62 <_panic>

0080234b <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	68 e8 34 80 00       	push   $0x8034e8
  802359:	68 1e 01 00 00       	push   $0x11e
  80235e:	68 0b 35 80 00       	push   $0x80350b
  802363:	e8 fa e9 ff ff       	call   800d62 <_panic>

00802368 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80236e:	83 ec 04             	sub    $0x4,%esp
  802371:	68 e8 34 80 00       	push   $0x8034e8
  802376:	68 24 01 00 00       	push   $0x124
  80237b:	68 0b 35 80 00       	push   $0x80350b
  802380:	e8 dd e9 ff ff       	call   800d62 <_panic>

00802385 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80238b:	83 ec 04             	sub    $0x4,%esp
  80238e:	68 e8 34 80 00       	push   $0x8034e8
  802393:	68 29 01 00 00       	push   $0x129
  802398:	68 0b 35 80 00       	push   $0x80350b
  80239d:	e8 c0 e9 ff ff       	call   800d62 <_panic>

008023a2 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8023a8:	83 ec 04             	sub    $0x4,%esp
  8023ab:	68 e8 34 80 00       	push   $0x8034e8
  8023b0:	68 2f 01 00 00       	push   $0x12f
  8023b5:	68 0b 35 80 00       	push   $0x80350b
  8023ba:	e8 a3 e9 ff ff       	call   800d62 <_panic>

008023bf <shrink>:
}
void shrink(uint32 newSize)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8023c5:	83 ec 04             	sub    $0x4,%esp
  8023c8:	68 e8 34 80 00       	push   $0x8034e8
  8023cd:	68 33 01 00 00       	push   $0x133
  8023d2:	68 0b 35 80 00       	push   $0x80350b
  8023d7:	e8 86 e9 ff ff       	call   800d62 <_panic>

008023dc <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
  8023df:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8023e2:	83 ec 04             	sub    $0x4,%esp
  8023e5:	68 e8 34 80 00       	push   $0x8034e8
  8023ea:	68 38 01 00 00       	push   $0x138
  8023ef:	68 0b 35 80 00       	push   $0x80350b
  8023f4:	e8 69 e9 ff ff       	call   800d62 <_panic>

008023f9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
  8023fc:	57                   	push   %edi
  8023fd:	56                   	push   %esi
  8023fe:	53                   	push   %ebx
  8023ff:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	8b 55 0c             	mov    0xc(%ebp),%edx
  802408:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80240b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80240e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802411:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802414:	cd 30                	int    $0x30
  802416:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802419:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80241c:	83 c4 10             	add    $0x10,%esp
  80241f:	5b                   	pop    %ebx
  802420:	5e                   	pop    %esi
  802421:	5f                   	pop    %edi
  802422:	5d                   	pop    %ebp
  802423:	c3                   	ret    

00802424 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
  802427:	83 ec 04             	sub    $0x4,%esp
  80242a:	8b 45 10             	mov    0x10(%ebp),%eax
  80242d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802430:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	52                   	push   %edx
  80243c:	ff 75 0c             	pushl  0xc(%ebp)
  80243f:	50                   	push   %eax
  802440:	6a 00                	push   $0x0
  802442:	e8 b2 ff ff ff       	call   8023f9 <syscall>
  802447:	83 c4 18             	add    $0x18,%esp
}
  80244a:	90                   	nop
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <sys_cgetc>:

int
sys_cgetc(void)
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 01                	push   $0x1
  80245c:	e8 98 ff ff ff       	call   8023f9 <syscall>
  802461:	83 c4 18             	add    $0x18,%esp
}
  802464:	c9                   	leave  
  802465:	c3                   	ret    

00802466 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	50                   	push   %eax
  802475:	6a 05                	push   $0x5
  802477:	e8 7d ff ff ff       	call   8023f9 <syscall>
  80247c:	83 c4 18             	add    $0x18,%esp
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 02                	push   $0x2
  802490:	e8 64 ff ff ff       	call   8023f9 <syscall>
  802495:	83 c4 18             	add    $0x18,%esp
}
  802498:	c9                   	leave  
  802499:	c3                   	ret    

0080249a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 03                	push   $0x3
  8024a9:	e8 4b ff ff ff       	call   8023f9 <syscall>
  8024ae:	83 c4 18             	add    $0x18,%esp
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 04                	push   $0x4
  8024c2:	e8 32 ff ff ff       	call   8023f9 <syscall>
  8024c7:	83 c4 18             	add    $0x18,%esp
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <sys_env_exit>:


void sys_env_exit(void)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 06                	push   $0x6
  8024db:	e8 19 ff ff ff       	call   8023f9 <syscall>
  8024e0:	83 c4 18             	add    $0x18,%esp
}
  8024e3:	90                   	nop
  8024e4:	c9                   	leave  
  8024e5:	c3                   	ret    

008024e6 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8024e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	52                   	push   %edx
  8024f6:	50                   	push   %eax
  8024f7:	6a 07                	push   $0x7
  8024f9:	e8 fb fe ff ff       	call   8023f9 <syscall>
  8024fe:	83 c4 18             	add    $0x18,%esp
}
  802501:	c9                   	leave  
  802502:	c3                   	ret    

00802503 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
  802506:	56                   	push   %esi
  802507:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802508:	8b 75 18             	mov    0x18(%ebp),%esi
  80250b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80250e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802511:	8b 55 0c             	mov    0xc(%ebp),%edx
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	56                   	push   %esi
  802518:	53                   	push   %ebx
  802519:	51                   	push   %ecx
  80251a:	52                   	push   %edx
  80251b:	50                   	push   %eax
  80251c:	6a 08                	push   $0x8
  80251e:	e8 d6 fe ff ff       	call   8023f9 <syscall>
  802523:	83 c4 18             	add    $0x18,%esp
}
  802526:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802529:	5b                   	pop    %ebx
  80252a:	5e                   	pop    %esi
  80252b:	5d                   	pop    %ebp
  80252c:	c3                   	ret    

0080252d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802530:	8b 55 0c             	mov    0xc(%ebp),%edx
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	52                   	push   %edx
  80253d:	50                   	push   %eax
  80253e:	6a 09                	push   $0x9
  802540:	e8 b4 fe ff ff       	call   8023f9 <syscall>
  802545:	83 c4 18             	add    $0x18,%esp
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	ff 75 0c             	pushl  0xc(%ebp)
  802556:	ff 75 08             	pushl  0x8(%ebp)
  802559:	6a 0a                	push   $0xa
  80255b:	e8 99 fe ff ff       	call   8023f9 <syscall>
  802560:	83 c4 18             	add    $0x18,%esp
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 0b                	push   $0xb
  802574:	e8 80 fe ff ff       	call   8023f9 <syscall>
  802579:	83 c4 18             	add    $0x18,%esp
}
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    

0080257e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 0c                	push   $0xc
  80258d:	e8 67 fe ff ff       	call   8023f9 <syscall>
  802592:	83 c4 18             	add    $0x18,%esp
}
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 0d                	push   $0xd
  8025a6:	e8 4e fe ff ff       	call   8023f9 <syscall>
  8025ab:	83 c4 18             	add    $0x18,%esp
}
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	ff 75 0c             	pushl  0xc(%ebp)
  8025bc:	ff 75 08             	pushl  0x8(%ebp)
  8025bf:	6a 11                	push   $0x11
  8025c1:	e8 33 fe ff ff       	call   8023f9 <syscall>
  8025c6:	83 c4 18             	add    $0x18,%esp
	return;
  8025c9:	90                   	nop
}
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	ff 75 0c             	pushl  0xc(%ebp)
  8025d8:	ff 75 08             	pushl  0x8(%ebp)
  8025db:	6a 12                	push   $0x12
  8025dd:	e8 17 fe ff ff       	call   8023f9 <syscall>
  8025e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8025e5:	90                   	nop
}
  8025e6:	c9                   	leave  
  8025e7:	c3                   	ret    

008025e8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 0e                	push   $0xe
  8025f7:	e8 fd fd ff ff       	call   8023f9 <syscall>
  8025fc:	83 c4 18             	add    $0x18,%esp
}
  8025ff:	c9                   	leave  
  802600:	c3                   	ret    

00802601 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	ff 75 08             	pushl  0x8(%ebp)
  80260f:	6a 0f                	push   $0xf
  802611:	e8 e3 fd ff ff       	call   8023f9 <syscall>
  802616:	83 c4 18             	add    $0x18,%esp
}
  802619:	c9                   	leave  
  80261a:	c3                   	ret    

0080261b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	6a 10                	push   $0x10
  80262a:	e8 ca fd ff ff       	call   8023f9 <syscall>
  80262f:	83 c4 18             	add    $0x18,%esp
}
  802632:	90                   	nop
  802633:	c9                   	leave  
  802634:	c3                   	ret    

00802635 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 14                	push   $0x14
  802644:	e8 b0 fd ff ff       	call   8023f9 <syscall>
  802649:	83 c4 18             	add    $0x18,%esp
}
  80264c:	90                   	nop
  80264d:	c9                   	leave  
  80264e:	c3                   	ret    

0080264f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80264f:	55                   	push   %ebp
  802650:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 15                	push   $0x15
  80265e:	e8 96 fd ff ff       	call   8023f9 <syscall>
  802663:	83 c4 18             	add    $0x18,%esp
}
  802666:	90                   	nop
  802667:	c9                   	leave  
  802668:	c3                   	ret    

00802669 <sys_cputc>:


void
sys_cputc(const char c)
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
  80266c:	83 ec 04             	sub    $0x4,%esp
  80266f:	8b 45 08             	mov    0x8(%ebp),%eax
  802672:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802675:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	50                   	push   %eax
  802682:	6a 16                	push   $0x16
  802684:	e8 70 fd ff ff       	call   8023f9 <syscall>
  802689:	83 c4 18             	add    $0x18,%esp
}
  80268c:	90                   	nop
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 17                	push   $0x17
  80269e:	e8 56 fd ff ff       	call   8023f9 <syscall>
  8026a3:	83 c4 18             	add    $0x18,%esp
}
  8026a6:	90                   	nop
  8026a7:	c9                   	leave  
  8026a8:	c3                   	ret    

008026a9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8026a9:	55                   	push   %ebp
  8026aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8026ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	ff 75 0c             	pushl  0xc(%ebp)
  8026b8:	50                   	push   %eax
  8026b9:	6a 18                	push   $0x18
  8026bb:	e8 39 fd ff ff       	call   8023f9 <syscall>
  8026c0:	83 c4 18             	add    $0x18,%esp
}
  8026c3:	c9                   	leave  
  8026c4:	c3                   	ret    

008026c5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8026c5:	55                   	push   %ebp
  8026c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 00                	push   $0x0
  8026d4:	52                   	push   %edx
  8026d5:	50                   	push   %eax
  8026d6:	6a 1b                	push   $0x1b
  8026d8:	e8 1c fd ff ff       	call   8023f9 <syscall>
  8026dd:	83 c4 18             	add    $0x18,%esp
}
  8026e0:	c9                   	leave  
  8026e1:	c3                   	ret    

008026e2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	52                   	push   %edx
  8026f2:	50                   	push   %eax
  8026f3:	6a 19                	push   $0x19
  8026f5:	e8 ff fc ff ff       	call   8023f9 <syscall>
  8026fa:	83 c4 18             	add    $0x18,%esp
}
  8026fd:	90                   	nop
  8026fe:	c9                   	leave  
  8026ff:	c3                   	ret    

00802700 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802700:	55                   	push   %ebp
  802701:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802703:	8b 55 0c             	mov    0xc(%ebp),%edx
  802706:	8b 45 08             	mov    0x8(%ebp),%eax
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	6a 00                	push   $0x0
  80270f:	52                   	push   %edx
  802710:	50                   	push   %eax
  802711:	6a 1a                	push   $0x1a
  802713:	e8 e1 fc ff ff       	call   8023f9 <syscall>
  802718:	83 c4 18             	add    $0x18,%esp
}
  80271b:	90                   	nop
  80271c:	c9                   	leave  
  80271d:	c3                   	ret    

0080271e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
  802721:	83 ec 04             	sub    $0x4,%esp
  802724:	8b 45 10             	mov    0x10(%ebp),%eax
  802727:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80272a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80272d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802731:	8b 45 08             	mov    0x8(%ebp),%eax
  802734:	6a 00                	push   $0x0
  802736:	51                   	push   %ecx
  802737:	52                   	push   %edx
  802738:	ff 75 0c             	pushl  0xc(%ebp)
  80273b:	50                   	push   %eax
  80273c:	6a 1c                	push   $0x1c
  80273e:	e8 b6 fc ff ff       	call   8023f9 <syscall>
  802743:	83 c4 18             	add    $0x18,%esp
}
  802746:	c9                   	leave  
  802747:	c3                   	ret    

00802748 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80274b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80274e:	8b 45 08             	mov    0x8(%ebp),%eax
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	52                   	push   %edx
  802758:	50                   	push   %eax
  802759:	6a 1d                	push   $0x1d
  80275b:	e8 99 fc ff ff       	call   8023f9 <syscall>
  802760:	83 c4 18             	add    $0x18,%esp
}
  802763:	c9                   	leave  
  802764:	c3                   	ret    

00802765 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802765:	55                   	push   %ebp
  802766:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802768:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80276b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276e:	8b 45 08             	mov    0x8(%ebp),%eax
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	51                   	push   %ecx
  802776:	52                   	push   %edx
  802777:	50                   	push   %eax
  802778:	6a 1e                	push   $0x1e
  80277a:	e8 7a fc ff ff       	call   8023f9 <syscall>
  80277f:	83 c4 18             	add    $0x18,%esp
}
  802782:	c9                   	leave  
  802783:	c3                   	ret    

00802784 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802784:	55                   	push   %ebp
  802785:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80278a:	8b 45 08             	mov    0x8(%ebp),%eax
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	6a 00                	push   $0x0
  802793:	52                   	push   %edx
  802794:	50                   	push   %eax
  802795:	6a 1f                	push   $0x1f
  802797:	e8 5d fc ff ff       	call   8023f9 <syscall>
  80279c:	83 c4 18             	add    $0x18,%esp
}
  80279f:	c9                   	leave  
  8027a0:	c3                   	ret    

008027a1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8027a1:	55                   	push   %ebp
  8027a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 00                	push   $0x0
  8027ac:	6a 00                	push   $0x0
  8027ae:	6a 20                	push   $0x20
  8027b0:	e8 44 fc ff ff       	call   8023f9 <syscall>
  8027b5:	83 c4 18             	add    $0x18,%esp
}
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    

008027ba <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8027ba:	55                   	push   %ebp
  8027bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	6a 00                	push   $0x0
  8027c2:	ff 75 14             	pushl  0x14(%ebp)
  8027c5:	ff 75 10             	pushl  0x10(%ebp)
  8027c8:	ff 75 0c             	pushl  0xc(%ebp)
  8027cb:	50                   	push   %eax
  8027cc:	6a 21                	push   $0x21
  8027ce:	e8 26 fc ff ff       	call   8023f9 <syscall>
  8027d3:	83 c4 18             	add    $0x18,%esp
}
  8027d6:	c9                   	leave  
  8027d7:	c3                   	ret    

008027d8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8027d8:	55                   	push   %ebp
  8027d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8027db:	8b 45 08             	mov    0x8(%ebp),%eax
  8027de:	6a 00                	push   $0x0
  8027e0:	6a 00                	push   $0x0
  8027e2:	6a 00                	push   $0x0
  8027e4:	6a 00                	push   $0x0
  8027e6:	50                   	push   %eax
  8027e7:	6a 22                	push   $0x22
  8027e9:	e8 0b fc ff ff       	call   8023f9 <syscall>
  8027ee:	83 c4 18             	add    $0x18,%esp
}
  8027f1:	90                   	nop
  8027f2:	c9                   	leave  
  8027f3:	c3                   	ret    

008027f4 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8027f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fa:	6a 00                	push   $0x0
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	6a 00                	push   $0x0
  802802:	50                   	push   %eax
  802803:	6a 23                	push   $0x23
  802805:	e8 ef fb ff ff       	call   8023f9 <syscall>
  80280a:	83 c4 18             	add    $0x18,%esp
}
  80280d:	90                   	nop
  80280e:	c9                   	leave  
  80280f:	c3                   	ret    

00802810 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
  802813:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802816:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802819:	8d 50 04             	lea    0x4(%eax),%edx
  80281c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80281f:	6a 00                	push   $0x0
  802821:	6a 00                	push   $0x0
  802823:	6a 00                	push   $0x0
  802825:	52                   	push   %edx
  802826:	50                   	push   %eax
  802827:	6a 24                	push   $0x24
  802829:	e8 cb fb ff ff       	call   8023f9 <syscall>
  80282e:	83 c4 18             	add    $0x18,%esp
	return result;
  802831:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802834:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802837:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80283a:	89 01                	mov    %eax,(%ecx)
  80283c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	c9                   	leave  
  802843:	c2 04 00             	ret    $0x4

00802846 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802849:	6a 00                	push   $0x0
  80284b:	6a 00                	push   $0x0
  80284d:	ff 75 10             	pushl  0x10(%ebp)
  802850:	ff 75 0c             	pushl  0xc(%ebp)
  802853:	ff 75 08             	pushl  0x8(%ebp)
  802856:	6a 13                	push   $0x13
  802858:	e8 9c fb ff ff       	call   8023f9 <syscall>
  80285d:	83 c4 18             	add    $0x18,%esp
	return ;
  802860:	90                   	nop
}
  802861:	c9                   	leave  
  802862:	c3                   	ret    

00802863 <sys_rcr2>:
uint32 sys_rcr2()
{
  802863:	55                   	push   %ebp
  802864:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	6a 00                	push   $0x0
  80286c:	6a 00                	push   $0x0
  80286e:	6a 00                	push   $0x0
  802870:	6a 25                	push   $0x25
  802872:	e8 82 fb ff ff       	call   8023f9 <syscall>
  802877:	83 c4 18             	add    $0x18,%esp
}
  80287a:	c9                   	leave  
  80287b:	c3                   	ret    

0080287c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80287c:	55                   	push   %ebp
  80287d:	89 e5                	mov    %esp,%ebp
  80287f:	83 ec 04             	sub    $0x4,%esp
  802882:	8b 45 08             	mov    0x8(%ebp),%eax
  802885:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802888:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80288c:	6a 00                	push   $0x0
  80288e:	6a 00                	push   $0x0
  802890:	6a 00                	push   $0x0
  802892:	6a 00                	push   $0x0
  802894:	50                   	push   %eax
  802895:	6a 26                	push   $0x26
  802897:	e8 5d fb ff ff       	call   8023f9 <syscall>
  80289c:	83 c4 18             	add    $0x18,%esp
	return ;
  80289f:	90                   	nop
}
  8028a0:	c9                   	leave  
  8028a1:	c3                   	ret    

008028a2 <rsttst>:
void rsttst()
{
  8028a2:	55                   	push   %ebp
  8028a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8028a5:	6a 00                	push   $0x0
  8028a7:	6a 00                	push   $0x0
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 00                	push   $0x0
  8028ad:	6a 00                	push   $0x0
  8028af:	6a 28                	push   $0x28
  8028b1:	e8 43 fb ff ff       	call   8023f9 <syscall>
  8028b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8028b9:	90                   	nop
}
  8028ba:	c9                   	leave  
  8028bb:	c3                   	ret    

008028bc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8028bc:	55                   	push   %ebp
  8028bd:	89 e5                	mov    %esp,%ebp
  8028bf:	83 ec 04             	sub    $0x4,%esp
  8028c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8028c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8028c8:	8b 55 18             	mov    0x18(%ebp),%edx
  8028cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028cf:	52                   	push   %edx
  8028d0:	50                   	push   %eax
  8028d1:	ff 75 10             	pushl  0x10(%ebp)
  8028d4:	ff 75 0c             	pushl  0xc(%ebp)
  8028d7:	ff 75 08             	pushl  0x8(%ebp)
  8028da:	6a 27                	push   $0x27
  8028dc:	e8 18 fb ff ff       	call   8023f9 <syscall>
  8028e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8028e4:	90                   	nop
}
  8028e5:	c9                   	leave  
  8028e6:	c3                   	ret    

008028e7 <chktst>:
void chktst(uint32 n)
{
  8028e7:	55                   	push   %ebp
  8028e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8028ea:	6a 00                	push   $0x0
  8028ec:	6a 00                	push   $0x0
  8028ee:	6a 00                	push   $0x0
  8028f0:	6a 00                	push   $0x0
  8028f2:	ff 75 08             	pushl  0x8(%ebp)
  8028f5:	6a 29                	push   $0x29
  8028f7:	e8 fd fa ff ff       	call   8023f9 <syscall>
  8028fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8028ff:	90                   	nop
}
  802900:	c9                   	leave  
  802901:	c3                   	ret    

00802902 <inctst>:

void inctst()
{
  802902:	55                   	push   %ebp
  802903:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802905:	6a 00                	push   $0x0
  802907:	6a 00                	push   $0x0
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 2a                	push   $0x2a
  802911:	e8 e3 fa ff ff       	call   8023f9 <syscall>
  802916:	83 c4 18             	add    $0x18,%esp
	return ;
  802919:	90                   	nop
}
  80291a:	c9                   	leave  
  80291b:	c3                   	ret    

0080291c <gettst>:
uint32 gettst()
{
  80291c:	55                   	push   %ebp
  80291d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80291f:	6a 00                	push   $0x0
  802921:	6a 00                	push   $0x0
  802923:	6a 00                	push   $0x0
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 2b                	push   $0x2b
  80292b:	e8 c9 fa ff ff       	call   8023f9 <syscall>
  802930:	83 c4 18             	add    $0x18,%esp
}
  802933:	c9                   	leave  
  802934:	c3                   	ret    

00802935 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
  802938:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80293b:	6a 00                	push   $0x0
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	6a 00                	push   $0x0
  802943:	6a 00                	push   $0x0
  802945:	6a 2c                	push   $0x2c
  802947:	e8 ad fa ff ff       	call   8023f9 <syscall>
  80294c:	83 c4 18             	add    $0x18,%esp
  80294f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802952:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802956:	75 07                	jne    80295f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802958:	b8 01 00 00 00       	mov    $0x1,%eax
  80295d:	eb 05                	jmp    802964 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80295f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802964:	c9                   	leave  
  802965:	c3                   	ret    

00802966 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802966:	55                   	push   %ebp
  802967:	89 e5                	mov    %esp,%ebp
  802969:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80296c:	6a 00                	push   $0x0
  80296e:	6a 00                	push   $0x0
  802970:	6a 00                	push   $0x0
  802972:	6a 00                	push   $0x0
  802974:	6a 00                	push   $0x0
  802976:	6a 2c                	push   $0x2c
  802978:	e8 7c fa ff ff       	call   8023f9 <syscall>
  80297d:	83 c4 18             	add    $0x18,%esp
  802980:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802983:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802987:	75 07                	jne    802990 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802989:	b8 01 00 00 00       	mov    $0x1,%eax
  80298e:	eb 05                	jmp    802995 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802990:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802995:	c9                   	leave  
  802996:	c3                   	ret    

00802997 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802997:	55                   	push   %ebp
  802998:	89 e5                	mov    %esp,%ebp
  80299a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80299d:	6a 00                	push   $0x0
  80299f:	6a 00                	push   $0x0
  8029a1:	6a 00                	push   $0x0
  8029a3:	6a 00                	push   $0x0
  8029a5:	6a 00                	push   $0x0
  8029a7:	6a 2c                	push   $0x2c
  8029a9:	e8 4b fa ff ff       	call   8023f9 <syscall>
  8029ae:	83 c4 18             	add    $0x18,%esp
  8029b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8029b4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8029b8:	75 07                	jne    8029c1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8029ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8029bf:	eb 05                	jmp    8029c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8029c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c6:	c9                   	leave  
  8029c7:	c3                   	ret    

008029c8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
  8029cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029ce:	6a 00                	push   $0x0
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 2c                	push   $0x2c
  8029da:	e8 1a fa ff ff       	call   8023f9 <syscall>
  8029df:	83 c4 18             	add    $0x18,%esp
  8029e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8029e5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8029e9:	75 07                	jne    8029f2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8029eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8029f0:	eb 05                	jmp    8029f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8029f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f7:	c9                   	leave  
  8029f8:	c3                   	ret    

008029f9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8029f9:	55                   	push   %ebp
  8029fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8029fc:	6a 00                	push   $0x0
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 00                	push   $0x0
  802a02:	6a 00                	push   $0x0
  802a04:	ff 75 08             	pushl  0x8(%ebp)
  802a07:	6a 2d                	push   $0x2d
  802a09:	e8 eb f9 ff ff       	call   8023f9 <syscall>
  802a0e:	83 c4 18             	add    $0x18,%esp
	return ;
  802a11:	90                   	nop
}
  802a12:	c9                   	leave  
  802a13:	c3                   	ret    

00802a14 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802a14:	55                   	push   %ebp
  802a15:	89 e5                	mov    %esp,%ebp
  802a17:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802a18:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	6a 00                	push   $0x0
  802a26:	53                   	push   %ebx
  802a27:	51                   	push   %ecx
  802a28:	52                   	push   %edx
  802a29:	50                   	push   %eax
  802a2a:	6a 2e                	push   $0x2e
  802a2c:	e8 c8 f9 ff ff       	call   8023f9 <syscall>
  802a31:	83 c4 18             	add    $0x18,%esp
}
  802a34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a37:	c9                   	leave  
  802a38:	c3                   	ret    

00802a39 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802a39:	55                   	push   %ebp
  802a3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	6a 00                	push   $0x0
  802a44:	6a 00                	push   $0x0
  802a46:	6a 00                	push   $0x0
  802a48:	52                   	push   %edx
  802a49:	50                   	push   %eax
  802a4a:	6a 2f                	push   $0x2f
  802a4c:	e8 a8 f9 ff ff       	call   8023f9 <syscall>
  802a51:	83 c4 18             	add    $0x18,%esp
}
  802a54:	c9                   	leave  
  802a55:	c3                   	ret    
  802a56:	66 90                	xchg   %ax,%ax

00802a58 <__udivdi3>:
  802a58:	55                   	push   %ebp
  802a59:	57                   	push   %edi
  802a5a:	56                   	push   %esi
  802a5b:	53                   	push   %ebx
  802a5c:	83 ec 1c             	sub    $0x1c,%esp
  802a5f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802a63:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802a67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a6f:	89 ca                	mov    %ecx,%edx
  802a71:	89 f8                	mov    %edi,%eax
  802a73:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802a77:	85 f6                	test   %esi,%esi
  802a79:	75 2d                	jne    802aa8 <__udivdi3+0x50>
  802a7b:	39 cf                	cmp    %ecx,%edi
  802a7d:	77 65                	ja     802ae4 <__udivdi3+0x8c>
  802a7f:	89 fd                	mov    %edi,%ebp
  802a81:	85 ff                	test   %edi,%edi
  802a83:	75 0b                	jne    802a90 <__udivdi3+0x38>
  802a85:	b8 01 00 00 00       	mov    $0x1,%eax
  802a8a:	31 d2                	xor    %edx,%edx
  802a8c:	f7 f7                	div    %edi
  802a8e:	89 c5                	mov    %eax,%ebp
  802a90:	31 d2                	xor    %edx,%edx
  802a92:	89 c8                	mov    %ecx,%eax
  802a94:	f7 f5                	div    %ebp
  802a96:	89 c1                	mov    %eax,%ecx
  802a98:	89 d8                	mov    %ebx,%eax
  802a9a:	f7 f5                	div    %ebp
  802a9c:	89 cf                	mov    %ecx,%edi
  802a9e:	89 fa                	mov    %edi,%edx
  802aa0:	83 c4 1c             	add    $0x1c,%esp
  802aa3:	5b                   	pop    %ebx
  802aa4:	5e                   	pop    %esi
  802aa5:	5f                   	pop    %edi
  802aa6:	5d                   	pop    %ebp
  802aa7:	c3                   	ret    
  802aa8:	39 ce                	cmp    %ecx,%esi
  802aaa:	77 28                	ja     802ad4 <__udivdi3+0x7c>
  802aac:	0f bd fe             	bsr    %esi,%edi
  802aaf:	83 f7 1f             	xor    $0x1f,%edi
  802ab2:	75 40                	jne    802af4 <__udivdi3+0x9c>
  802ab4:	39 ce                	cmp    %ecx,%esi
  802ab6:	72 0a                	jb     802ac2 <__udivdi3+0x6a>
  802ab8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802abc:	0f 87 9e 00 00 00    	ja     802b60 <__udivdi3+0x108>
  802ac2:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac7:	89 fa                	mov    %edi,%edx
  802ac9:	83 c4 1c             	add    $0x1c,%esp
  802acc:	5b                   	pop    %ebx
  802acd:	5e                   	pop    %esi
  802ace:	5f                   	pop    %edi
  802acf:	5d                   	pop    %ebp
  802ad0:	c3                   	ret    
  802ad1:	8d 76 00             	lea    0x0(%esi),%esi
  802ad4:	31 ff                	xor    %edi,%edi
  802ad6:	31 c0                	xor    %eax,%eax
  802ad8:	89 fa                	mov    %edi,%edx
  802ada:	83 c4 1c             	add    $0x1c,%esp
  802add:	5b                   	pop    %ebx
  802ade:	5e                   	pop    %esi
  802adf:	5f                   	pop    %edi
  802ae0:	5d                   	pop    %ebp
  802ae1:	c3                   	ret    
  802ae2:	66 90                	xchg   %ax,%ax
  802ae4:	89 d8                	mov    %ebx,%eax
  802ae6:	f7 f7                	div    %edi
  802ae8:	31 ff                	xor    %edi,%edi
  802aea:	89 fa                	mov    %edi,%edx
  802aec:	83 c4 1c             	add    $0x1c,%esp
  802aef:	5b                   	pop    %ebx
  802af0:	5e                   	pop    %esi
  802af1:	5f                   	pop    %edi
  802af2:	5d                   	pop    %ebp
  802af3:	c3                   	ret    
  802af4:	bd 20 00 00 00       	mov    $0x20,%ebp
  802af9:	89 eb                	mov    %ebp,%ebx
  802afb:	29 fb                	sub    %edi,%ebx
  802afd:	89 f9                	mov    %edi,%ecx
  802aff:	d3 e6                	shl    %cl,%esi
  802b01:	89 c5                	mov    %eax,%ebp
  802b03:	88 d9                	mov    %bl,%cl
  802b05:	d3 ed                	shr    %cl,%ebp
  802b07:	89 e9                	mov    %ebp,%ecx
  802b09:	09 f1                	or     %esi,%ecx
  802b0b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802b0f:	89 f9                	mov    %edi,%ecx
  802b11:	d3 e0                	shl    %cl,%eax
  802b13:	89 c5                	mov    %eax,%ebp
  802b15:	89 d6                	mov    %edx,%esi
  802b17:	88 d9                	mov    %bl,%cl
  802b19:	d3 ee                	shr    %cl,%esi
  802b1b:	89 f9                	mov    %edi,%ecx
  802b1d:	d3 e2                	shl    %cl,%edx
  802b1f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b23:	88 d9                	mov    %bl,%cl
  802b25:	d3 e8                	shr    %cl,%eax
  802b27:	09 c2                	or     %eax,%edx
  802b29:	89 d0                	mov    %edx,%eax
  802b2b:	89 f2                	mov    %esi,%edx
  802b2d:	f7 74 24 0c          	divl   0xc(%esp)
  802b31:	89 d6                	mov    %edx,%esi
  802b33:	89 c3                	mov    %eax,%ebx
  802b35:	f7 e5                	mul    %ebp
  802b37:	39 d6                	cmp    %edx,%esi
  802b39:	72 19                	jb     802b54 <__udivdi3+0xfc>
  802b3b:	74 0b                	je     802b48 <__udivdi3+0xf0>
  802b3d:	89 d8                	mov    %ebx,%eax
  802b3f:	31 ff                	xor    %edi,%edi
  802b41:	e9 58 ff ff ff       	jmp    802a9e <__udivdi3+0x46>
  802b46:	66 90                	xchg   %ax,%ax
  802b48:	8b 54 24 08          	mov    0x8(%esp),%edx
  802b4c:	89 f9                	mov    %edi,%ecx
  802b4e:	d3 e2                	shl    %cl,%edx
  802b50:	39 c2                	cmp    %eax,%edx
  802b52:	73 e9                	jae    802b3d <__udivdi3+0xe5>
  802b54:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b57:	31 ff                	xor    %edi,%edi
  802b59:	e9 40 ff ff ff       	jmp    802a9e <__udivdi3+0x46>
  802b5e:	66 90                	xchg   %ax,%ax
  802b60:	31 c0                	xor    %eax,%eax
  802b62:	e9 37 ff ff ff       	jmp    802a9e <__udivdi3+0x46>
  802b67:	90                   	nop

00802b68 <__umoddi3>:
  802b68:	55                   	push   %ebp
  802b69:	57                   	push   %edi
  802b6a:	56                   	push   %esi
  802b6b:	53                   	push   %ebx
  802b6c:	83 ec 1c             	sub    $0x1c,%esp
  802b6f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802b73:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b87:	89 f3                	mov    %esi,%ebx
  802b89:	89 fa                	mov    %edi,%edx
  802b8b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b8f:	89 34 24             	mov    %esi,(%esp)
  802b92:	85 c0                	test   %eax,%eax
  802b94:	75 1a                	jne    802bb0 <__umoddi3+0x48>
  802b96:	39 f7                	cmp    %esi,%edi
  802b98:	0f 86 a2 00 00 00    	jbe    802c40 <__umoddi3+0xd8>
  802b9e:	89 c8                	mov    %ecx,%eax
  802ba0:	89 f2                	mov    %esi,%edx
  802ba2:	f7 f7                	div    %edi
  802ba4:	89 d0                	mov    %edx,%eax
  802ba6:	31 d2                	xor    %edx,%edx
  802ba8:	83 c4 1c             	add    $0x1c,%esp
  802bab:	5b                   	pop    %ebx
  802bac:	5e                   	pop    %esi
  802bad:	5f                   	pop    %edi
  802bae:	5d                   	pop    %ebp
  802baf:	c3                   	ret    
  802bb0:	39 f0                	cmp    %esi,%eax
  802bb2:	0f 87 ac 00 00 00    	ja     802c64 <__umoddi3+0xfc>
  802bb8:	0f bd e8             	bsr    %eax,%ebp
  802bbb:	83 f5 1f             	xor    $0x1f,%ebp
  802bbe:	0f 84 ac 00 00 00    	je     802c70 <__umoddi3+0x108>
  802bc4:	bf 20 00 00 00       	mov    $0x20,%edi
  802bc9:	29 ef                	sub    %ebp,%edi
  802bcb:	89 fe                	mov    %edi,%esi
  802bcd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bd1:	89 e9                	mov    %ebp,%ecx
  802bd3:	d3 e0                	shl    %cl,%eax
  802bd5:	89 d7                	mov    %edx,%edi
  802bd7:	89 f1                	mov    %esi,%ecx
  802bd9:	d3 ef                	shr    %cl,%edi
  802bdb:	09 c7                	or     %eax,%edi
  802bdd:	89 e9                	mov    %ebp,%ecx
  802bdf:	d3 e2                	shl    %cl,%edx
  802be1:	89 14 24             	mov    %edx,(%esp)
  802be4:	89 d8                	mov    %ebx,%eax
  802be6:	d3 e0                	shl    %cl,%eax
  802be8:	89 c2                	mov    %eax,%edx
  802bea:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bee:	d3 e0                	shl    %cl,%eax
  802bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bf4:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bf8:	89 f1                	mov    %esi,%ecx
  802bfa:	d3 e8                	shr    %cl,%eax
  802bfc:	09 d0                	or     %edx,%eax
  802bfe:	d3 eb                	shr    %cl,%ebx
  802c00:	89 da                	mov    %ebx,%edx
  802c02:	f7 f7                	div    %edi
  802c04:	89 d3                	mov    %edx,%ebx
  802c06:	f7 24 24             	mull   (%esp)
  802c09:	89 c6                	mov    %eax,%esi
  802c0b:	89 d1                	mov    %edx,%ecx
  802c0d:	39 d3                	cmp    %edx,%ebx
  802c0f:	0f 82 87 00 00 00    	jb     802c9c <__umoddi3+0x134>
  802c15:	0f 84 91 00 00 00    	je     802cac <__umoddi3+0x144>
  802c1b:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c1f:	29 f2                	sub    %esi,%edx
  802c21:	19 cb                	sbb    %ecx,%ebx
  802c23:	89 d8                	mov    %ebx,%eax
  802c25:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802c29:	d3 e0                	shl    %cl,%eax
  802c2b:	89 e9                	mov    %ebp,%ecx
  802c2d:	d3 ea                	shr    %cl,%edx
  802c2f:	09 d0                	or     %edx,%eax
  802c31:	89 e9                	mov    %ebp,%ecx
  802c33:	d3 eb                	shr    %cl,%ebx
  802c35:	89 da                	mov    %ebx,%edx
  802c37:	83 c4 1c             	add    $0x1c,%esp
  802c3a:	5b                   	pop    %ebx
  802c3b:	5e                   	pop    %esi
  802c3c:	5f                   	pop    %edi
  802c3d:	5d                   	pop    %ebp
  802c3e:	c3                   	ret    
  802c3f:	90                   	nop
  802c40:	89 fd                	mov    %edi,%ebp
  802c42:	85 ff                	test   %edi,%edi
  802c44:	75 0b                	jne    802c51 <__umoddi3+0xe9>
  802c46:	b8 01 00 00 00       	mov    $0x1,%eax
  802c4b:	31 d2                	xor    %edx,%edx
  802c4d:	f7 f7                	div    %edi
  802c4f:	89 c5                	mov    %eax,%ebp
  802c51:	89 f0                	mov    %esi,%eax
  802c53:	31 d2                	xor    %edx,%edx
  802c55:	f7 f5                	div    %ebp
  802c57:	89 c8                	mov    %ecx,%eax
  802c59:	f7 f5                	div    %ebp
  802c5b:	89 d0                	mov    %edx,%eax
  802c5d:	e9 44 ff ff ff       	jmp    802ba6 <__umoddi3+0x3e>
  802c62:	66 90                	xchg   %ax,%ax
  802c64:	89 c8                	mov    %ecx,%eax
  802c66:	89 f2                	mov    %esi,%edx
  802c68:	83 c4 1c             	add    $0x1c,%esp
  802c6b:	5b                   	pop    %ebx
  802c6c:	5e                   	pop    %esi
  802c6d:	5f                   	pop    %edi
  802c6e:	5d                   	pop    %ebp
  802c6f:	c3                   	ret    
  802c70:	3b 04 24             	cmp    (%esp),%eax
  802c73:	72 06                	jb     802c7b <__umoddi3+0x113>
  802c75:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802c79:	77 0f                	ja     802c8a <__umoddi3+0x122>
  802c7b:	89 f2                	mov    %esi,%edx
  802c7d:	29 f9                	sub    %edi,%ecx
  802c7f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802c83:	89 14 24             	mov    %edx,(%esp)
  802c86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c8a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c8e:	8b 14 24             	mov    (%esp),%edx
  802c91:	83 c4 1c             	add    $0x1c,%esp
  802c94:	5b                   	pop    %ebx
  802c95:	5e                   	pop    %esi
  802c96:	5f                   	pop    %edi
  802c97:	5d                   	pop    %ebp
  802c98:	c3                   	ret    
  802c99:	8d 76 00             	lea    0x0(%esi),%esi
  802c9c:	2b 04 24             	sub    (%esp),%eax
  802c9f:	19 fa                	sbb    %edi,%edx
  802ca1:	89 d1                	mov    %edx,%ecx
  802ca3:	89 c6                	mov    %eax,%esi
  802ca5:	e9 71 ff ff ff       	jmp    802c1b <__umoddi3+0xb3>
  802caa:	66 90                	xchg   %ax,%ax
  802cac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802cb0:	72 ea                	jb     802c9c <__umoddi3+0x134>
  802cb2:	89 d9                	mov    %ebx,%ecx
  802cb4:	e9 62 ff ff ff       	jmp    802c1b <__umoddi3+0xb3>
