
obj/user/tst_nextfit:     file format elf32-i386


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
  800031:	e8 1c 0b 00 00       	call   800b52 <libmain>
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
  80003d:	81 ec 30 08 00 00    	sub    $0x830,%esp
	int Mega = 1024*1024;
  800043:	c7 45 e0 00 00 10 00 	movl   $0x100000,-0x20(%ebp)
	int kilo = 1024;
  80004a:	c7 45 dc 00 04 00 00 	movl   $0x400,-0x24(%ebp)

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  800051:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	89 c7                	mov    %eax,%edi
  800058:	b8 00 00 00 20       	mov    $0x20000000,%eax
  80005d:	ba 00 00 00 00       	mov    $0x0,%edx
  800062:	f7 f7                	div    %edi
  800064:	89 45 d8             	mov    %eax,-0x28(%ebp)
	assert(numOf2MBsInHeap == 256);
  800067:	81 7d d8 00 01 00 00 	cmpl   $0x100,-0x28(%ebp)
  80006e:	74 16                	je     800086 <_main+0x4e>
  800070:	68 00 2c 80 00       	push   $0x802c00
  800075:	68 17 2c 80 00       	push   $0x802c17
  80007a:	6a 0e                	push   $0xe
  80007c:	68 2c 2c 80 00       	push   $0x802c2c
  800081:	e8 11 0c 00 00       	call   800c97 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	6a 03                	push   $0x3
  80008b:	e8 9e 28 00 00       	call   80292e <sys_set_uheap_strategy>
  800090:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800093:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800097:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80009e:	eb 23                	jmp    8000c3 <_main+0x8b>
		{
			if (myEnv->__uptr_pws[i].empty)
  8000a0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a5:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8000ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8000ae:	c1 e2 04             	shl    $0x4,%edx
  8000b1:	01 d0                	add    %edx,%eax
  8000b3:	8a 40 04             	mov    0x4(%eax),%al
  8000b6:	84 c0                	test   %al,%al
  8000b8:	74 06                	je     8000c0 <_main+0x88>
			{
				fullWS = 0;
  8000ba:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  8000be:	eb 12                	jmp    8000d2 <_main+0x9a>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  8000c0:	ff 45 f0             	incl   -0x10(%ebp)
  8000c3:	a1 20 40 80 00       	mov    0x804020,%eax
  8000c8:	8b 50 74             	mov    0x74(%eax),%edx
  8000cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000ce:	39 c2                	cmp    %eax,%edx
  8000d0:	77 ce                	ja     8000a0 <_main+0x68>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  8000d2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8000d6:	74 14                	je     8000ec <_main+0xb4>
  8000d8:	83 ec 04             	sub    $0x4,%esp
  8000db:	68 3f 2c 80 00       	push   $0x802c3f
  8000e0:	6a 20                	push   $0x20
  8000e2:	68 2c 2c 80 00       	push   $0x802c2c
  8000e7:	e8 ab 0b 00 00       	call   800c97 <_panic>

	int freeFrames ;
	int usedDiskPages;

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  8000ec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  8000f3:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
	int numOfEmptyWSLocs = 0;
  8000fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  800101:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800108:	eb 20                	jmp    80012a <_main+0xf2>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  80010a:	a1 20 40 80 00       	mov    0x804020,%eax
  80010f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800115:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800118:	c1 e2 04             	shl    $0x4,%edx
  80011b:	01 d0                	add    %edx,%eax
  80011d:	8a 40 04             	mov    0x4(%eax),%al
  800120:	3c 01                	cmp    $0x1,%al
  800122:	75 03                	jne    800127 <_main+0xef>
			numOfEmptyWSLocs++;
  800124:	ff 45 e8             	incl   -0x18(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  800127:	ff 45 ec             	incl   -0x14(%ebp)
  80012a:	a1 20 40 80 00       	mov    0x804020,%eax
  80012f:	8b 50 74             	mov    0x74(%eax),%edx
  800132:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800135:	39 c2                	cmp    %eax,%edx
  800137:	77 d1                	ja     80010a <_main+0xd2>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  800139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80013f:	7d 14                	jge    800155 <_main+0x11d>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  800141:	83 ec 04             	sub    $0x4,%esp
  800144:	68 5c 2c 80 00       	push   $0x802c5c
  800149:	6a 31                	push   $0x31
  80014b:	68 2c 2c 80 00       	push   $0x802c2c
  800150:	e8 42 0b 00 00       	call   800c97 <_panic>


	void* ptr_allocations[512] = {0};
  800155:	8d 95 c8 f7 ff ff    	lea    -0x838(%ebp),%edx
  80015b:	b9 00 02 00 00       	mov    $0x200,%ecx
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	89 d7                	mov    %edx,%edi
  800167:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	68 ac 2c 80 00       	push   $0x802cac
  800171:	e8 c3 0d 00 00       	call   800f39 <cprintf>
  800176:	83 c4 10             	add    $0x10,%esp

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  800179:	e8 1c 23 00 00       	call   80249a <sys_calculate_free_frames>
  80017e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800181:	e8 97 23 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  800186:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for(i = 0; i< 256;i++)
  800189:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800190:	eb 20                	jmp    8001b2 <_main+0x17a>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	01 c0                	add    %eax,%eax
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	50                   	push   %eax
  80019b:	e8 23 1b 00 00       	call   801cc3 <malloc>
  8001a0:	83 c4 10             	add    $0x10,%esp
  8001a3:	89 c2                	mov    %eax,%edx
  8001a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a8:	89 94 85 c8 f7 ff ff 	mov    %edx,-0x838(%ebp,%eax,4)
	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  8001af:	ff 45 e4             	incl   -0x1c(%ebp)
  8001b2:	81 7d e4 ff 00 00 00 	cmpl   $0xff,-0x1c(%ebp)
  8001b9:	7e d7                	jle    800192 <_main+0x15a>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  8001bb:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
  8001c1:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8001c6:	75 5b                	jne    800223 <_main+0x1eb>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  8001c8:	8b 85 d0 f7 ff ff    	mov    -0x830(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  8001ce:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  8001d3:	75 4e                	jne    800223 <_main+0x1eb>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  8001d5:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  8001db:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  8001e0:	75 41                	jne    800223 <_main+0x1eb>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  8001e2:	8b 85 f0 f7 ff ff    	mov    -0x810(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  8001e8:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  8001ed:	75 34                	jne    800223 <_main+0x1eb>
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  8001ef:	8b 85 04 f8 ff ff    	mov    -0x7fc(%ebp),%eax

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  8001f5:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  8001fa:	75 27                	jne    800223 <_main+0x1eb>
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  8001fc:	8b 85 18 f8 ff ff    	mov    -0x7e8(%ebp),%eax
	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800202:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  800207:	75 1a                	jne    800223 <_main+0x1eb>
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  800209:	8b 85 2c f8 ff ff    	mov    -0x7d4(%ebp),%eax
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  80020f:	3d 00 00 20 83       	cmp    $0x83200000,%eax
  800214:	75 0d                	jne    800223 <_main+0x1eb>
			(uint32)ptr_allocations[25] != 0x83200000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  800216:	8b 85 c4 fb ff ff    	mov    -0x43c(%ebp),%eax
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  80021c:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  800221:	74 14                	je     800237 <_main+0x1ff>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  800223:	83 ec 04             	sub    $0x4,%esp
  800226:	68 fc 2c 80 00       	push   $0x802cfc
  80022b:	6a 4a                	push   $0x4a
  80022d:	68 2c 2c 80 00       	push   $0x802c2c
  800232:	e8 60 0a 00 00       	call   800c97 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800237:	e8 e1 22 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  80023c:	2b 45 cc             	sub    -0x34(%ebp),%eax
  80023f:	89 c2                	mov    %eax,%edx
  800241:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800244:	c1 e0 09             	shl    $0x9,%eax
  800247:	85 c0                	test   %eax,%eax
  800249:	79 05                	jns    800250 <_main+0x218>
  80024b:	05 ff 0f 00 00       	add    $0xfff,%eax
  800250:	c1 f8 0c             	sar    $0xc,%eax
  800253:	39 c2                	cmp    %eax,%edx
  800255:	74 14                	je     80026b <_main+0x233>
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	68 3a 2d 80 00       	push   $0x802d3a
  80025f:	6a 4c                	push   $0x4c
  800261:	68 2c 2c 80 00       	push   $0x802c2c
  800266:	e8 2c 0a 00 00       	call   800c97 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  80026b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80026e:	e8 27 22 00 00       	call   80249a <sys_calculate_free_frames>
  800273:	29 c3                	sub    %eax,%ebx
  800275:	89 da                	mov    %ebx,%edx
  800277:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80027a:	c1 e0 09             	shl    $0x9,%eax
  80027d:	85 c0                	test   %eax,%eax
  80027f:	79 05                	jns    800286 <_main+0x24e>
  800281:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  800286:	c1 f8 16             	sar    $0x16,%eax
  800289:	39 c2                	cmp    %eax,%edx
  80028b:	74 14                	je     8002a1 <_main+0x269>
  80028d:	83 ec 04             	sub    $0x4,%esp
  800290:	68 57 2d 80 00       	push   $0x802d57
  800295:	6a 4d                	push   $0x4d
  800297:	68 2c 2c 80 00       	push   $0x802c2c
  80029c:	e8 f6 09 00 00       	call   800c97 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  8002a1:	e8 f4 21 00 00       	call   80249a <sys_calculate_free_frames>
  8002a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8002a9:	e8 6f 22 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  8002ae:	89 45 cc             	mov    %eax,-0x34(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  8002b1:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
  8002b7:	83 ec 0c             	sub    $0xc,%esp
  8002ba:	50                   	push   %eax
  8002bb:	e8 be 1e 00 00       	call   80217e <free>
  8002c0:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  8002c3:	8b 85 d0 f7 ff ff    	mov    -0x830(%ebp),%eax
  8002c9:	83 ec 0c             	sub    $0xc,%esp
  8002cc:	50                   	push   %eax
  8002cd:	e8 ac 1e 00 00       	call   80217e <free>
  8002d2:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  8002d5:	8b 85 d4 f7 ff ff    	mov    -0x82c(%ebp),%eax
  8002db:	83 ec 0c             	sub    $0xc,%esp
  8002de:	50                   	push   %eax
  8002df:	e8 9a 1e 00 00       	call   80217e <free>
  8002e4:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[5]);		// Hole 3 = 2 M
  8002e7:	8b 85 dc f7 ff ff    	mov    -0x824(%ebp),%eax
  8002ed:	83 ec 0c             	sub    $0xc,%esp
  8002f0:	50                   	push   %eax
  8002f1:	e8 88 1e 00 00       	call   80217e <free>
  8002f6:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 4 = 6 M
  8002f9:	8b 85 f0 f7 ff ff    	mov    -0x810(%ebp),%eax
  8002ff:	83 ec 0c             	sub    $0xc,%esp
  800302:	50                   	push   %eax
  800303:	e8 76 1e 00 00       	call   80217e <free>
  800308:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  80030b:	8b 85 f8 f7 ff ff    	mov    -0x808(%ebp),%eax
  800311:	83 ec 0c             	sub    $0xc,%esp
  800314:	50                   	push   %eax
  800315:	e8 64 1e 00 00       	call   80217e <free>
  80031a:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  80031d:	8b 85 f4 f7 ff ff    	mov    -0x80c(%ebp),%eax
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	50                   	push   %eax
  800327:	e8 52 1e 00 00       	call   80217e <free>
  80032c:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[20]);		// Hole 5 = 2 M
  80032f:	8b 85 18 f8 ff ff    	mov    -0x7e8(%ebp),%eax
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	50                   	push   %eax
  800339:	e8 40 1e 00 00       	call   80217e <free>
  80033e:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[25]);		// Hole 6 = 2 M
  800341:	8b 85 2c f8 ff ff    	mov    -0x7d4(%ebp),%eax
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	50                   	push   %eax
  80034b:	e8 2e 1e 00 00       	call   80217e <free>
  800350:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[255]);		// Hole 7 = 2 M
  800353:	8b 85 c4 fb ff ff    	mov    -0x43c(%ebp),%eax
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	50                   	push   %eax
  80035d:	e8 1c 1e 00 00       	call   80217e <free>
  800362:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 10*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800365:	e8 b3 21 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  80036a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80036d:	89 d1                	mov    %edx,%ecx
  80036f:	29 c1                	sub    %eax,%ecx
  800371:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800374:	89 d0                	mov    %edx,%eax
  800376:	c1 e0 02             	shl    $0x2,%eax
  800379:	01 d0                	add    %edx,%eax
  80037b:	c1 e0 02             	shl    $0x2,%eax
  80037e:	85 c0                	test   %eax,%eax
  800380:	79 05                	jns    800387 <_main+0x34f>
  800382:	05 ff 0f 00 00       	add    $0xfff,%eax
  800387:	c1 f8 0c             	sar    $0xc,%eax
  80038a:	39 c1                	cmp    %eax,%ecx
  80038c:	74 14                	je     8003a2 <_main+0x36a>
  80038e:	83 ec 04             	sub    $0x4,%esp
  800391:	68 68 2d 80 00       	push   $0x802d68
  800396:	6a 5e                	push   $0x5e
  800398:	68 2c 2c 80 00       	push   $0x802c2c
  80039d:	e8 f5 08 00 00       	call   800c97 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  8003a2:	e8 f3 20 00 00       	call   80249a <sys_calculate_free_frames>
  8003a7:	89 c2                	mov    %eax,%edx
  8003a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003ac:	39 c2                	cmp    %eax,%edx
  8003ae:	74 14                	je     8003c4 <_main+0x38c>
  8003b0:	83 ec 04             	sub    $0x4,%esp
  8003b3:	68 a4 2d 80 00       	push   $0x802da4
  8003b8:	6a 5f                	push   $0x5f
  8003ba:	68 2c 2c 80 00       	push   $0x802c2c
  8003bf:	e8 d3 08 00 00       	call   800c97 <_panic>

	// Test next fit

	freeFrames = sys_calculate_free_frames() ;
  8003c4:	e8 d1 20 00 00       	call   80249a <sys_calculate_free_frames>
  8003c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8003cc:	e8 4c 21 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  8003d1:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void* tempAddress = malloc(Mega-kilo);		// Use Hole 1 -> Hole 1 = 1 M
  8003d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d7:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	50                   	push   %eax
  8003de:	e8 e0 18 00 00       	call   801cc3 <malloc>
  8003e3:	83 c4 10             	add    $0x10,%esp
  8003e6:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if((uint32)tempAddress != 0x80000000)
  8003e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8003ec:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8003f1:	74 14                	je     800407 <_main+0x3cf>
		panic("Next Fit not working correctly");
  8003f3:	83 ec 04             	sub    $0x4,%esp
  8003f6:	68 e4 2d 80 00       	push   $0x802de4
  8003fb:	6a 67                	push   $0x67
  8003fd:	68 2c 2c 80 00       	push   $0x802c2c
  800402:	e8 90 08 00 00       	call   800c97 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800407:	e8 11 21 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  80040c:	2b 45 cc             	sub    -0x34(%ebp),%eax
  80040f:	89 c2                	mov    %eax,%edx
  800411:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800414:	85 c0                	test   %eax,%eax
  800416:	79 05                	jns    80041d <_main+0x3e5>
  800418:	05 ff 0f 00 00       	add    $0xfff,%eax
  80041d:	c1 f8 0c             	sar    $0xc,%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	74 14                	je     800438 <_main+0x400>
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 3a 2d 80 00       	push   $0x802d3a
  80042c:	6a 68                	push   $0x68
  80042e:	68 2c 2c 80 00       	push   $0x802c2c
  800433:	e8 5f 08 00 00       	call   800c97 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800438:	e8 5d 20 00 00       	call   80249a <sys_calculate_free_frames>
  80043d:	89 c2                	mov    %eax,%edx
  80043f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800442:	39 c2                	cmp    %eax,%edx
  800444:	74 14                	je     80045a <_main+0x422>
  800446:	83 ec 04             	sub    $0x4,%esp
  800449:	68 57 2d 80 00       	push   $0x802d57
  80044e:	6a 69                	push   $0x69
  800450:	68 2c 2c 80 00       	push   $0x802c2c
  800455:	e8 3d 08 00 00       	call   800c97 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80045a:	e8 3b 20 00 00       	call   80249a <sys_calculate_free_frames>
  80045f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800462:	e8 b6 20 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  800467:	89 45 cc             	mov    %eax,-0x34(%ebp)
	tempAddress = malloc(kilo);					// Use Hole 1 -> Hole 1 = 1 M - Kilo
  80046a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80046d:	83 ec 0c             	sub    $0xc,%esp
  800470:	50                   	push   %eax
  800471:	e8 4d 18 00 00       	call   801cc3 <malloc>
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if((uint32)tempAddress != 0x80100000)
  80047c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80047f:	3d 00 00 10 80       	cmp    $0x80100000,%eax
  800484:	74 14                	je     80049a <_main+0x462>
		panic("Next Fit not working correctly");
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 e4 2d 80 00       	push   $0x802de4
  80048e:	6a 6f                	push   $0x6f
  800490:	68 2c 2c 80 00       	push   $0x802c2c
  800495:	e8 fd 07 00 00       	call   800c97 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  80049a:	e8 7e 20 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  80049f:	2b 45 cc             	sub    -0x34(%ebp),%eax
  8004a2:	89 c2                	mov    %eax,%edx
  8004a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a7:	c1 e0 02             	shl    $0x2,%eax
  8004aa:	85 c0                	test   %eax,%eax
  8004ac:	79 05                	jns    8004b3 <_main+0x47b>
  8004ae:	05 ff 0f 00 00       	add    $0xfff,%eax
  8004b3:	c1 f8 0c             	sar    $0xc,%eax
  8004b6:	39 c2                	cmp    %eax,%edx
  8004b8:	74 14                	je     8004ce <_main+0x496>
  8004ba:	83 ec 04             	sub    $0x4,%esp
  8004bd:	68 3a 2d 80 00       	push   $0x802d3a
  8004c2:	6a 70                	push   $0x70
  8004c4:	68 2c 2c 80 00       	push   $0x802c2c
  8004c9:	e8 c9 07 00 00       	call   800c97 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8004ce:	e8 c7 1f 00 00       	call   80249a <sys_calculate_free_frames>
  8004d3:	89 c2                	mov    %eax,%edx
  8004d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d8:	39 c2                	cmp    %eax,%edx
  8004da:	74 14                	je     8004f0 <_main+0x4b8>
  8004dc:	83 ec 04             	sub    $0x4,%esp
  8004df:	68 57 2d 80 00       	push   $0x802d57
  8004e4:	6a 71                	push   $0x71
  8004e6:	68 2c 2c 80 00       	push   $0x802c2c
  8004eb:	e8 a7 07 00 00       	call   800c97 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8004f0:	e8 a5 1f 00 00       	call   80249a <sys_calculate_free_frames>
  8004f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f8:	e8 20 20 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  8004fd:	89 45 cc             	mov    %eax,-0x34(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  800500:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800503:	89 d0                	mov    %edx,%eax
  800505:	c1 e0 02             	shl    $0x2,%eax
  800508:	01 d0                	add    %edx,%eax
  80050a:	83 ec 0c             	sub    $0xc,%esp
  80050d:	50                   	push   %eax
  80050e:	e8 b0 17 00 00       	call   801cc3 <malloc>
  800513:	83 c4 10             	add    $0x10,%esp
  800516:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if((uint32)tempAddress != 0x81400000)
  800519:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80051c:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800521:	74 14                	je     800537 <_main+0x4ff>
		panic("Next Fit not working correctly");
  800523:	83 ec 04             	sub    $0x4,%esp
  800526:	68 e4 2d 80 00       	push   $0x802de4
  80052b:	6a 77                	push   $0x77
  80052d:	68 2c 2c 80 00       	push   $0x802c2c
  800532:	e8 60 07 00 00       	call   800c97 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800537:	e8 e1 1f 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  80053c:	2b 45 cc             	sub    -0x34(%ebp),%eax
  80053f:	89 c1                	mov    %eax,%ecx
  800541:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800544:	89 d0                	mov    %edx,%eax
  800546:	c1 e0 02             	shl    $0x2,%eax
  800549:	01 d0                	add    %edx,%eax
  80054b:	85 c0                	test   %eax,%eax
  80054d:	79 05                	jns    800554 <_main+0x51c>
  80054f:	05 ff 0f 00 00       	add    $0xfff,%eax
  800554:	c1 f8 0c             	sar    $0xc,%eax
  800557:	39 c1                	cmp    %eax,%ecx
  800559:	74 14                	je     80056f <_main+0x537>
  80055b:	83 ec 04             	sub    $0x4,%esp
  80055e:	68 3a 2d 80 00       	push   $0x802d3a
  800563:	6a 78                	push   $0x78
  800565:	68 2c 2c 80 00       	push   $0x802c2c
  80056a:	e8 28 07 00 00       	call   800c97 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80056f:	e8 26 1f 00 00       	call   80249a <sys_calculate_free_frames>
  800574:	89 c2                	mov    %eax,%edx
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	74 14                	je     800591 <_main+0x559>
  80057d:	83 ec 04             	sub    $0x4,%esp
  800580:	68 57 2d 80 00       	push   $0x802d57
  800585:	6a 79                	push   $0x79
  800587:	68 2c 2c 80 00       	push   $0x802c2c
  80058c:	e8 06 07 00 00       	call   800c97 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800591:	e8 04 1f 00 00       	call   80249a <sys_calculate_free_frames>
  800596:	89 45 d0             	mov    %eax,-0x30(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800599:	e8 7f 1f 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  80059e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	tempAddress = malloc(1*Mega); 			   // Use Hole 4 -> Hole 4 = 0 M
  8005a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a4:	83 ec 0c             	sub    $0xc,%esp
  8005a7:	50                   	push   %eax
  8005a8:	e8 16 17 00 00       	call   801cc3 <malloc>
  8005ad:	83 c4 10             	add    $0x10,%esp
  8005b0:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if((uint32)tempAddress != 0x81900000)
  8005b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005b6:	3d 00 00 90 81       	cmp    $0x81900000,%eax
  8005bb:	74 14                	je     8005d1 <_main+0x599>
		panic("Next Fit not working correctly");
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 e4 2d 80 00       	push   $0x802de4
  8005c5:	6a 7f                	push   $0x7f
  8005c7:	68 2c 2c 80 00       	push   $0x802c2c
  8005cc:	e8 c6 06 00 00       	call   800c97 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005d1:	e8 47 1f 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  8005d6:	2b 45 cc             	sub    -0x34(%ebp),%eax
  8005d9:	89 c2                	mov    %eax,%edx
  8005db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005de:	85 c0                	test   %eax,%eax
  8005e0:	79 05                	jns    8005e7 <_main+0x5af>
  8005e2:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005e7:	c1 f8 0c             	sar    $0xc,%eax
  8005ea:	39 c2                	cmp    %eax,%edx
  8005ec:	74 17                	je     800605 <_main+0x5cd>
  8005ee:	83 ec 04             	sub    $0x4,%esp
  8005f1:	68 3a 2d 80 00       	push   $0x802d3a
  8005f6:	68 80 00 00 00       	push   $0x80
  8005fb:	68 2c 2c 80 00       	push   $0x802c2c
  800600:	e8 92 06 00 00       	call   800c97 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800605:	e8 90 1e 00 00       	call   80249a <sys_calculate_free_frames>
  80060a:	89 c2                	mov    %eax,%edx
  80060c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80060f:	39 c2                	cmp    %eax,%edx
  800611:	74 17                	je     80062a <_main+0x5f2>
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	68 57 2d 80 00       	push   $0x802d57
  80061b:	68 81 00 00 00       	push   $0x81
  800620:	68 2c 2c 80 00       	push   $0x802c2c
  800625:	e8 6d 06 00 00       	call   800c97 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  80062a:	e8 6b 1e 00 00       	call   80249a <sys_calculate_free_frames>
  80062f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800632:	e8 e6 1e 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  800637:	89 45 cc             	mov    %eax,-0x34(%ebp)
	free(ptr_allocations[15]);					// Make a new hole => 2 M
  80063a:	8b 85 04 f8 ff ff    	mov    -0x7fc(%ebp),%eax
  800640:	83 ec 0c             	sub    $0xc,%esp
  800643:	50                   	push   %eax
  800644:	e8 35 1b 00 00       	call   80217e <free>
  800649:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80064c:	e8 cc 1e 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  800651:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800654:	29 c2                	sub    %eax,%edx
  800656:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800659:	01 c0                	add    %eax,%eax
  80065b:	85 c0                	test   %eax,%eax
  80065d:	79 05                	jns    800664 <_main+0x62c>
  80065f:	05 ff 0f 00 00       	add    $0xfff,%eax
  800664:	c1 f8 0c             	sar    $0xc,%eax
  800667:	39 c2                	cmp    %eax,%edx
  800669:	74 17                	je     800682 <_main+0x64a>
  80066b:	83 ec 04             	sub    $0x4,%esp
  80066e:	68 68 2d 80 00       	push   $0x802d68
  800673:	68 87 00 00 00       	push   $0x87
  800678:	68 2c 2c 80 00       	push   $0x802c2c
  80067d:	e8 15 06 00 00       	call   800c97 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800682:	e8 13 1e 00 00       	call   80249a <sys_calculate_free_frames>
  800687:	89 c2                	mov    %eax,%edx
  800689:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80068c:	39 c2                	cmp    %eax,%edx
  80068e:	74 17                	je     8006a7 <_main+0x66f>
  800690:	83 ec 04             	sub    $0x4,%esp
  800693:	68 a4 2d 80 00       	push   $0x802da4
  800698:	68 88 00 00 00       	push   $0x88
  80069d:	68 2c 2c 80 00       	push   $0x802c2c
  8006a2:	e8 f0 05 00 00       	call   800c97 <_panic>

	//[NEXT FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  8006a7:	e8 ee 1d 00 00       	call   80249a <sys_calculate_free_frames>
  8006ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006af:	e8 69 1e 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  8006b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
	tempAddress = malloc(kilo); 			   // Use new Hole = 2 M - 4 kilo
  8006b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006ba:	83 ec 0c             	sub    $0xc,%esp
  8006bd:	50                   	push   %eax
  8006be:	e8 00 16 00 00       	call   801cc3 <malloc>
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if((uint32)tempAddress != 0x81E00000)
  8006c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006cc:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  8006d1:	74 17                	je     8006ea <_main+0x6b2>
		panic("Next Fit not working correctly");
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	68 e4 2d 80 00       	push   $0x802de4
  8006db:	68 8f 00 00 00       	push   $0x8f
  8006e0:	68 2c 2c 80 00       	push   $0x802c2c
  8006e5:	e8 ad 05 00 00       	call   800c97 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  8006ea:	e8 2e 1e 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  8006ef:	2b 45 cc             	sub    -0x34(%ebp),%eax
  8006f2:	89 c2                	mov    %eax,%edx
  8006f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006f7:	c1 e0 02             	shl    $0x2,%eax
  8006fa:	85 c0                	test   %eax,%eax
  8006fc:	79 05                	jns    800703 <_main+0x6cb>
  8006fe:	05 ff 0f 00 00       	add    $0xfff,%eax
  800703:	c1 f8 0c             	sar    $0xc,%eax
  800706:	39 c2                	cmp    %eax,%edx
  800708:	74 17                	je     800721 <_main+0x6e9>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 3a 2d 80 00       	push   $0x802d3a
  800712:	68 90 00 00 00       	push   $0x90
  800717:	68 2c 2c 80 00       	push   $0x802c2c
  80071c:	e8 76 05 00 00       	call   800c97 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800721:	e8 74 1d 00 00       	call   80249a <sys_calculate_free_frames>
  800726:	89 c2                	mov    %eax,%edx
  800728:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80072b:	39 c2                	cmp    %eax,%edx
  80072d:	74 17                	je     800746 <_main+0x70e>
  80072f:	83 ec 04             	sub    $0x4,%esp
  800732:	68 57 2d 80 00       	push   $0x802d57
  800737:	68 91 00 00 00       	push   $0x91
  80073c:	68 2c 2c 80 00       	push   $0x802c2c
  800741:	e8 51 05 00 00       	call   800c97 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800746:	e8 4f 1d 00 00       	call   80249a <sys_calculate_free_frames>
  80074b:	89 45 d0             	mov    %eax,-0x30(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80074e:	e8 ca 1d 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  800753:	89 45 cc             	mov    %eax,-0x34(%ebp)
	tempAddress = malloc(Mega + 1016*kilo); 	// Use new Hole = 4 kilo
  800756:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800759:	c1 e0 03             	shl    $0x3,%eax
  80075c:	89 c2                	mov    %eax,%edx
  80075e:	c1 e2 07             	shl    $0x7,%edx
  800761:	29 c2                	sub    %eax,%edx
  800763:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800766:	01 d0                	add    %edx,%eax
  800768:	83 ec 0c             	sub    $0xc,%esp
  80076b:	50                   	push   %eax
  80076c:	e8 52 15 00 00       	call   801cc3 <malloc>
  800771:	83 c4 10             	add    $0x10,%esp
  800774:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if((uint32)tempAddress != 0x81E01000)
  800777:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80077a:	3d 00 10 e0 81       	cmp    $0x81e01000,%eax
  80077f:	74 17                	je     800798 <_main+0x760>
		panic("Next Fit not working correctly");
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	68 e4 2d 80 00       	push   $0x802de4
  800789:	68 97 00 00 00       	push   $0x97
  80078e:	68 2c 2c 80 00       	push   $0x802c2c
  800793:	e8 ff 04 00 00       	call   800c97 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega+1016*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800798:	e8 80 1d 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  80079d:	2b 45 cc             	sub    -0x34(%ebp),%eax
  8007a0:	89 c2                	mov    %eax,%edx
  8007a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007a5:	c1 e0 03             	shl    $0x3,%eax
  8007a8:	89 c1                	mov    %eax,%ecx
  8007aa:	c1 e1 07             	shl    $0x7,%ecx
  8007ad:	29 c1                	sub    %eax,%ecx
  8007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b2:	01 c8                	add    %ecx,%eax
  8007b4:	85 c0                	test   %eax,%eax
  8007b6:	79 05                	jns    8007bd <_main+0x785>
  8007b8:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007bd:	c1 f8 0c             	sar    $0xc,%eax
  8007c0:	39 c2                	cmp    %eax,%edx
  8007c2:	74 17                	je     8007db <_main+0x7a3>
  8007c4:	83 ec 04             	sub    $0x4,%esp
  8007c7:	68 3a 2d 80 00       	push   $0x802d3a
  8007cc:	68 98 00 00 00       	push   $0x98
  8007d1:	68 2c 2c 80 00       	push   $0x802c2c
  8007d6:	e8 bc 04 00 00       	call   800c97 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8007db:	e8 ba 1c 00 00       	call   80249a <sys_calculate_free_frames>
  8007e0:	89 c2                	mov    %eax,%edx
  8007e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007e5:	39 c2                	cmp    %eax,%edx
  8007e7:	74 17                	je     800800 <_main+0x7c8>
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	68 57 2d 80 00       	push   $0x802d57
  8007f1:	68 99 00 00 00       	push   $0x99
  8007f6:	68 2c 2c 80 00       	push   $0x802c2c
  8007fb:	e8 97 04 00 00       	call   800c97 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800800:	e8 95 1c 00 00       	call   80249a <sys_calculate_free_frames>
  800805:	89 45 d0             	mov    %eax,-0x30(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800808:	e8 10 1d 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  80080d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 5 -> Hole 5 = 1.5 M
  800810:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800813:	c1 e0 09             	shl    $0x9,%eax
  800816:	83 ec 0c             	sub    $0xc,%esp
  800819:	50                   	push   %eax
  80081a:	e8 a4 14 00 00       	call   801cc3 <malloc>
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if((uint32)tempAddress != 0x82800000)
  800825:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800828:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  80082d:	74 17                	je     800846 <_main+0x80e>
		panic("Next Fit not working correctly");
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 e4 2d 80 00       	push   $0x802de4
  800837:	68 9f 00 00 00       	push   $0x9f
  80083c:	68 2c 2c 80 00       	push   $0x802c2c
  800841:	e8 51 04 00 00       	call   800c97 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800846:	e8 d2 1c 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  80084b:	2b 45 cc             	sub    -0x34(%ebp),%eax
  80084e:	89 c2                	mov    %eax,%edx
  800850:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800853:	c1 e0 09             	shl    $0x9,%eax
  800856:	85 c0                	test   %eax,%eax
  800858:	79 05                	jns    80085f <_main+0x827>
  80085a:	05 ff 0f 00 00       	add    $0xfff,%eax
  80085f:	c1 f8 0c             	sar    $0xc,%eax
  800862:	39 c2                	cmp    %eax,%edx
  800864:	74 17                	je     80087d <_main+0x845>
  800866:	83 ec 04             	sub    $0x4,%esp
  800869:	68 3a 2d 80 00       	push   $0x802d3a
  80086e:	68 a0 00 00 00       	push   $0xa0
  800873:	68 2c 2c 80 00       	push   $0x802c2c
  800878:	e8 1a 04 00 00       	call   800c97 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80087d:	e8 18 1c 00 00       	call   80249a <sys_calculate_free_frames>
  800882:	89 c2                	mov    %eax,%edx
  800884:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800887:	39 c2                	cmp    %eax,%edx
  800889:	74 17                	je     8008a2 <_main+0x86a>
  80088b:	83 ec 04             	sub    $0x4,%esp
  80088e:	68 57 2d 80 00       	push   $0x802d57
  800893:	68 a1 00 00 00       	push   $0xa1
  800898:	68 2c 2c 80 00       	push   $0x802c2c
  80089d:	e8 f5 03 00 00       	call   800c97 <_panic>

	cprintf("\nCASE1: (next fit without looping back) is succeeded...\n") ;
  8008a2:	83 ec 0c             	sub    $0xc,%esp
  8008a5:	68 04 2e 80 00       	push   $0x802e04
  8008aa:	e8 8a 06 00 00       	call   800f39 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp

	// Check that next fit is looping back to check for free space
	freeFrames = sys_calculate_free_frames() ;
  8008b2:	e8 e3 1b 00 00       	call   80249a <sys_calculate_free_frames>
  8008b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8008ba:	e8 5e 1c 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  8008bf:	89 45 cc             	mov    %eax,-0x34(%ebp)
	tempAddress = malloc(3*Mega + 512*kilo); 			   // Use Hole 2 -> Hole 2 = 0.5 M
  8008c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c5:	89 c2                	mov    %eax,%edx
  8008c7:	01 d2                	add    %edx,%edx
  8008c9:	01 c2                	add    %eax,%edx
  8008cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008ce:	c1 e0 09             	shl    $0x9,%eax
  8008d1:	01 d0                	add    %edx,%eax
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	50                   	push   %eax
  8008d7:	e8 e7 13 00 00       	call   801cc3 <malloc>
  8008dc:	83 c4 10             	add    $0x10,%esp
  8008df:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if((uint32)tempAddress != 0x80400000)
  8008e2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8008e5:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  8008ea:	74 17                	je     800903 <_main+0x8cb>
		panic("Next Fit not working correctly");
  8008ec:	83 ec 04             	sub    $0x4,%esp
  8008ef:	68 e4 2d 80 00       	push   $0x802de4
  8008f4:	68 aa 00 00 00       	push   $0xaa
  8008f9:	68 2c 2c 80 00       	push   $0x802c2c
  8008fe:	e8 94 03 00 00       	call   800c97 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (3*Mega+512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800903:	e8 15 1c 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  800908:	2b 45 cc             	sub    -0x34(%ebp),%eax
  80090b:	89 c2                	mov    %eax,%edx
  80090d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800910:	89 c1                	mov    %eax,%ecx
  800912:	01 c9                	add    %ecx,%ecx
  800914:	01 c1                	add    %eax,%ecx
  800916:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800919:	c1 e0 09             	shl    $0x9,%eax
  80091c:	01 c8                	add    %ecx,%eax
  80091e:	85 c0                	test   %eax,%eax
  800920:	79 05                	jns    800927 <_main+0x8ef>
  800922:	05 ff 0f 00 00       	add    $0xfff,%eax
  800927:	c1 f8 0c             	sar    $0xc,%eax
  80092a:	39 c2                	cmp    %eax,%edx
  80092c:	74 17                	je     800945 <_main+0x90d>
  80092e:	83 ec 04             	sub    $0x4,%esp
  800931:	68 3a 2d 80 00       	push   $0x802d3a
  800936:	68 ab 00 00 00       	push   $0xab
  80093b:	68 2c 2c 80 00       	push   $0x802c2c
  800940:	e8 52 03 00 00       	call   800c97 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800945:	e8 50 1b 00 00       	call   80249a <sys_calculate_free_frames>
  80094a:	89 c2                	mov    %eax,%edx
  80094c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80094f:	39 c2                	cmp    %eax,%edx
  800951:	74 17                	je     80096a <_main+0x932>
  800953:	83 ec 04             	sub    $0x4,%esp
  800956:	68 57 2d 80 00       	push   $0x802d57
  80095b:	68 ac 00 00 00       	push   $0xac
  800960:	68 2c 2c 80 00       	push   $0x802c2c
  800965:	e8 2d 03 00 00       	call   800c97 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  80096a:	e8 2b 1b 00 00       	call   80249a <sys_calculate_free_frames>
  80096f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800972:	e8 a6 1b 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  800977:	89 45 cc             	mov    %eax,-0x34(%ebp)
	free(ptr_allocations[24]);		// Increase size of Hole 6 to 4 M
  80097a:	8b 85 28 f8 ff ff    	mov    -0x7d8(%ebp),%eax
  800980:	83 ec 0c             	sub    $0xc,%esp
  800983:	50                   	push   %eax
  800984:	e8 f5 17 00 00       	call   80217e <free>
  800989:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80098c:	e8 8c 1b 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  800991:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800994:	29 c2                	sub    %eax,%edx
  800996:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800999:	01 c0                	add    %eax,%eax
  80099b:	85 c0                	test   %eax,%eax
  80099d:	79 05                	jns    8009a4 <_main+0x96c>
  80099f:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009a4:	c1 f8 0c             	sar    $0xc,%eax
  8009a7:	39 c2                	cmp    %eax,%edx
  8009a9:	74 17                	je     8009c2 <_main+0x98a>
  8009ab:	83 ec 04             	sub    $0x4,%esp
  8009ae:	68 68 2d 80 00       	push   $0x802d68
  8009b3:	68 b2 00 00 00       	push   $0xb2
  8009b8:	68 2c 2c 80 00       	push   $0x802c2c
  8009bd:	e8 d5 02 00 00       	call   800c97 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  8009c2:	e8 d3 1a 00 00       	call   80249a <sys_calculate_free_frames>
  8009c7:	89 c2                	mov    %eax,%edx
  8009c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009cc:	39 c2                	cmp    %eax,%edx
  8009ce:	74 17                	je     8009e7 <_main+0x9af>
  8009d0:	83 ec 04             	sub    $0x4,%esp
  8009d3:	68 a4 2d 80 00       	push   $0x802da4
  8009d8:	68 b3 00 00 00       	push   $0xb3
  8009dd:	68 2c 2c 80 00       	push   $0x802c2c
  8009e2:	e8 b0 02 00 00       	call   800c97 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  8009e7:	e8 ae 1a 00 00       	call   80249a <sys_calculate_free_frames>
  8009ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8009ef:	e8 29 1b 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  8009f4:	89 45 cc             	mov    %eax,-0x34(%ebp)
	tempAddress = malloc(4*Mega-kilo);		// Use Hole 6 -> Hole 6 = 0 M
  8009f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009fa:	c1 e0 02             	shl    $0x2,%eax
  8009fd:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800a00:	83 ec 0c             	sub    $0xc,%esp
  800a03:	50                   	push   %eax
  800a04:	e8 ba 12 00 00       	call   801cc3 <malloc>
  800a09:	83 c4 10             	add    $0x10,%esp
  800a0c:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if((uint32)tempAddress != 0x83000000)
  800a0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a12:	3d 00 00 00 83       	cmp    $0x83000000,%eax
  800a17:	74 17                	je     800a30 <_main+0x9f8>
		panic("Next Fit not working correctly");
  800a19:	83 ec 04             	sub    $0x4,%esp
  800a1c:	68 e4 2d 80 00       	push   $0x802de4
  800a21:	68 ba 00 00 00       	push   $0xba
  800a26:	68 2c 2c 80 00       	push   $0x802c2c
  800a2b:	e8 67 02 00 00       	call   800c97 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a30:	e8 e8 1a 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  800a35:	2b 45 cc             	sub    -0x34(%ebp),%eax
  800a38:	89 c2                	mov    %eax,%edx
  800a3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3d:	c1 e0 02             	shl    $0x2,%eax
  800a40:	85 c0                	test   %eax,%eax
  800a42:	79 05                	jns    800a49 <_main+0xa11>
  800a44:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a49:	c1 f8 0c             	sar    $0xc,%eax
  800a4c:	39 c2                	cmp    %eax,%edx
  800a4e:	74 17                	je     800a67 <_main+0xa2f>
  800a50:	83 ec 04             	sub    $0x4,%esp
  800a53:	68 3a 2d 80 00       	push   $0x802d3a
  800a58:	68 bb 00 00 00       	push   $0xbb
  800a5d:	68 2c 2c 80 00       	push   $0x802c2c
  800a62:	e8 30 02 00 00       	call   800c97 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a67:	e8 2e 1a 00 00       	call   80249a <sys_calculate_free_frames>
  800a6c:	89 c2                	mov    %eax,%edx
  800a6e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a71:	39 c2                	cmp    %eax,%edx
  800a73:	74 17                	je     800a8c <_main+0xa54>
  800a75:	83 ec 04             	sub    $0x4,%esp
  800a78:	68 57 2d 80 00       	push   $0x802d57
  800a7d:	68 bc 00 00 00       	push   $0xbc
  800a82:	68 2c 2c 80 00       	push   $0x802c2c
  800a87:	e8 0b 02 00 00       	call   800c97 <_panic>

	cprintf("\nCASE2: (next fit WITH looping back) is succeeded...\n") ;
  800a8c:	83 ec 0c             	sub    $0xc,%esp
  800a8f:	68 40 2e 80 00       	push   $0x802e40
  800a94:	e8 a0 04 00 00       	call   800f39 <cprintf>
  800a99:	83 c4 10             	add    $0x10,%esp

	// Check that next fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800a9c:	e8 f9 19 00 00       	call   80249a <sys_calculate_free_frames>
  800aa1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800aa4:	e8 74 1a 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  800aa9:	89 45 cc             	mov    %eax,-0x34(%ebp)
	tempAddress = malloc(6*Mega); 			   // No Suitable Hole is available
  800aac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aaf:	89 d0                	mov    %edx,%eax
  800ab1:	01 c0                	add    %eax,%eax
  800ab3:	01 d0                	add    %edx,%eax
  800ab5:	01 c0                	add    %eax,%eax
  800ab7:	83 ec 0c             	sub    $0xc,%esp
  800aba:	50                   	push   %eax
  800abb:	e8 03 12 00 00       	call   801cc3 <malloc>
  800ac0:	83 c4 10             	add    $0x10,%esp
  800ac3:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if((uint32)tempAddress != 0x0)
  800ac6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ac9:	85 c0                	test   %eax,%eax
  800acb:	74 17                	je     800ae4 <_main+0xaac>
		panic("Next Fit not working correctly");
  800acd:	83 ec 04             	sub    $0x4,%esp
  800ad0:	68 e4 2d 80 00       	push   $0x802de4
  800ad5:	68 c5 00 00 00       	push   $0xc5
  800ada:	68 2c 2c 80 00       	push   $0x802c2c
  800adf:	e8 b3 01 00 00       	call   800c97 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800ae4:	e8 34 1a 00 00       	call   80251d <sys_pf_calculate_allocated_pages>
  800ae9:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800aec:	74 17                	je     800b05 <_main+0xacd>
  800aee:	83 ec 04             	sub    $0x4,%esp
  800af1:	68 3a 2d 80 00       	push   $0x802d3a
  800af6:	68 c6 00 00 00       	push   $0xc6
  800afb:	68 2c 2c 80 00       	push   $0x802c2c
  800b00:	e8 92 01 00 00       	call   800c97 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b05:	e8 90 19 00 00       	call   80249a <sys_calculate_free_frames>
  800b0a:	89 c2                	mov    %eax,%edx
  800b0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b0f:	39 c2                	cmp    %eax,%edx
  800b11:	74 17                	je     800b2a <_main+0xaf2>
  800b13:	83 ec 04             	sub    $0x4,%esp
  800b16:	68 57 2d 80 00       	push   $0x802d57
  800b1b:	68 c7 00 00 00       	push   $0xc7
  800b20:	68 2c 2c 80 00       	push   $0x802c2c
  800b25:	e8 6d 01 00 00       	call   800c97 <_panic>

	cprintf("\nCASE3: (next fit with insufficient space) is succeeded...\n") ;
  800b2a:	83 ec 0c             	sub    $0xc,%esp
  800b2d:	68 78 2e 80 00       	push   $0x802e78
  800b32:	e8 02 04 00 00       	call   800f39 <cprintf>
  800b37:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Next Fit completed successfully.\n");
  800b3a:	83 ec 0c             	sub    $0xc,%esp
  800b3d:	68 b4 2e 80 00       	push   $0x802eb4
  800b42:	e8 f2 03 00 00       	call   800f39 <cprintf>
  800b47:	83 c4 10             	add    $0x10,%esp

	return;
  800b4a:	90                   	nop
}
  800b4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b4e:	5b                   	pop    %ebx
  800b4f:	5f                   	pop    %edi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    

00800b52 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b58:	e8 72 18 00 00       	call   8023cf <sys_getenvindex>
  800b5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b63:	89 d0                	mov    %edx,%eax
  800b65:	c1 e0 03             	shl    $0x3,%eax
  800b68:	01 d0                	add    %edx,%eax
  800b6a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800b71:	01 c8                	add    %ecx,%eax
  800b73:	01 c0                	add    %eax,%eax
  800b75:	01 d0                	add    %edx,%eax
  800b77:	01 c0                	add    %eax,%eax
  800b79:	01 d0                	add    %edx,%eax
  800b7b:	89 c2                	mov    %eax,%edx
  800b7d:	c1 e2 05             	shl    $0x5,%edx
  800b80:	29 c2                	sub    %eax,%edx
  800b82:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800b89:	89 c2                	mov    %eax,%edx
  800b8b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800b91:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b96:	a1 20 40 80 00       	mov    0x804020,%eax
  800b9b:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800ba1:	84 c0                	test   %al,%al
  800ba3:	74 0f                	je     800bb4 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800ba5:	a1 20 40 80 00       	mov    0x804020,%eax
  800baa:	05 40 3c 01 00       	add    $0x13c40,%eax
  800baf:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bb8:	7e 0a                	jle    800bc4 <libmain+0x72>
		binaryname = argv[0];
  800bba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbd:	8b 00                	mov    (%eax),%eax
  800bbf:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	ff 75 08             	pushl  0x8(%ebp)
  800bcd:	e8 66 f4 ff ff       	call   800038 <_main>
  800bd2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bd5:	e8 90 19 00 00       	call   80256a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bda:	83 ec 0c             	sub    $0xc,%esp
  800bdd:	68 08 2f 80 00       	push   $0x802f08
  800be2:	e8 52 03 00 00       	call   800f39 <cprintf>
  800be7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bea:	a1 20 40 80 00       	mov    0x804020,%eax
  800bef:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800bf5:	a1 20 40 80 00       	mov    0x804020,%eax
  800bfa:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800c00:	83 ec 04             	sub    $0x4,%esp
  800c03:	52                   	push   %edx
  800c04:	50                   	push   %eax
  800c05:	68 30 2f 80 00       	push   $0x802f30
  800c0a:	e8 2a 03 00 00       	call   800f39 <cprintf>
  800c0f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800c12:	a1 20 40 80 00       	mov    0x804020,%eax
  800c17:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800c1d:	a1 20 40 80 00       	mov    0x804020,%eax
  800c22:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800c28:	83 ec 04             	sub    $0x4,%esp
  800c2b:	52                   	push   %edx
  800c2c:	50                   	push   %eax
  800c2d:	68 58 2f 80 00       	push   $0x802f58
  800c32:	e8 02 03 00 00       	call   800f39 <cprintf>
  800c37:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c3a:	a1 20 40 80 00       	mov    0x804020,%eax
  800c3f:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	50                   	push   %eax
  800c49:	68 99 2f 80 00       	push   $0x802f99
  800c4e:	e8 e6 02 00 00       	call   800f39 <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c56:	83 ec 0c             	sub    $0xc,%esp
  800c59:	68 08 2f 80 00       	push   $0x802f08
  800c5e:	e8 d6 02 00 00       	call   800f39 <cprintf>
  800c63:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c66:	e8 19 19 00 00       	call   802584 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c6b:	e8 19 00 00 00       	call   800c89 <exit>
}
  800c70:	90                   	nop
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800c79:	83 ec 0c             	sub    $0xc,%esp
  800c7c:	6a 00                	push   $0x0
  800c7e:	e8 18 17 00 00       	call   80239b <sys_env_destroy>
  800c83:	83 c4 10             	add    $0x10,%esp
}
  800c86:	90                   	nop
  800c87:	c9                   	leave  
  800c88:	c3                   	ret    

00800c89 <exit>:

void
exit(void)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800c8f:	e8 6d 17 00 00       	call   802401 <sys_env_exit>
}
  800c94:	90                   	nop
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c9d:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca0:	83 c0 04             	add    $0x4,%eax
  800ca3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ca6:	a1 18 41 80 00       	mov    0x804118,%eax
  800cab:	85 c0                	test   %eax,%eax
  800cad:	74 16                	je     800cc5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800caf:	a1 18 41 80 00       	mov    0x804118,%eax
  800cb4:	83 ec 08             	sub    $0x8,%esp
  800cb7:	50                   	push   %eax
  800cb8:	68 b0 2f 80 00       	push   $0x802fb0
  800cbd:	e8 77 02 00 00       	call   800f39 <cprintf>
  800cc2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cc5:	a1 00 40 80 00       	mov    0x804000,%eax
  800cca:	ff 75 0c             	pushl  0xc(%ebp)
  800ccd:	ff 75 08             	pushl  0x8(%ebp)
  800cd0:	50                   	push   %eax
  800cd1:	68 b5 2f 80 00       	push   $0x802fb5
  800cd6:	e8 5e 02 00 00       	call   800f39 <cprintf>
  800cdb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cde:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce1:	83 ec 08             	sub    $0x8,%esp
  800ce4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce7:	50                   	push   %eax
  800ce8:	e8 e1 01 00 00       	call   800ece <vcprintf>
  800ced:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800cf0:	83 ec 08             	sub    $0x8,%esp
  800cf3:	6a 00                	push   $0x0
  800cf5:	68 d1 2f 80 00       	push   $0x802fd1
  800cfa:	e8 cf 01 00 00       	call   800ece <vcprintf>
  800cff:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d02:	e8 82 ff ff ff       	call   800c89 <exit>

	// should not return here
	while (1) ;
  800d07:	eb fe                	jmp    800d07 <_panic+0x70>

00800d09 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d0f:	a1 20 40 80 00       	mov    0x804020,%eax
  800d14:	8b 50 74             	mov    0x74(%eax),%edx
  800d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1a:	39 c2                	cmp    %eax,%edx
  800d1c:	74 14                	je     800d32 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d1e:	83 ec 04             	sub    $0x4,%esp
  800d21:	68 d4 2f 80 00       	push   $0x802fd4
  800d26:	6a 26                	push   $0x26
  800d28:	68 20 30 80 00       	push   $0x803020
  800d2d:	e8 65 ff ff ff       	call   800c97 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d39:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d40:	e9 b6 00 00 00       	jmp    800dfb <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	01 d0                	add    %edx,%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	85 c0                	test   %eax,%eax
  800d58:	75 08                	jne    800d62 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d5a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d5d:	e9 96 00 00 00       	jmp    800df8 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800d62:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d69:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d70:	eb 5d                	jmp    800dcf <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d72:	a1 20 40 80 00       	mov    0x804020,%eax
  800d77:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d7d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d80:	c1 e2 04             	shl    $0x4,%edx
  800d83:	01 d0                	add    %edx,%eax
  800d85:	8a 40 04             	mov    0x4(%eax),%al
  800d88:	84 c0                	test   %al,%al
  800d8a:	75 40                	jne    800dcc <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d8c:	a1 20 40 80 00       	mov    0x804020,%eax
  800d91:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d97:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d9a:	c1 e2 04             	shl    $0x4,%edx
  800d9d:	01 d0                	add    %edx,%eax
  800d9f:	8b 00                	mov    (%eax),%eax
  800da1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800da4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800da7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dac:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	01 c8                	add    %ecx,%eax
  800dbd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dbf:	39 c2                	cmp    %eax,%edx
  800dc1:	75 09                	jne    800dcc <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800dc3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800dca:	eb 12                	jmp    800dde <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dcc:	ff 45 e8             	incl   -0x18(%ebp)
  800dcf:	a1 20 40 80 00       	mov    0x804020,%eax
  800dd4:	8b 50 74             	mov    0x74(%eax),%edx
  800dd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dda:	39 c2                	cmp    %eax,%edx
  800ddc:	77 94                	ja     800d72 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dde:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800de2:	75 14                	jne    800df8 <CheckWSWithoutLastIndex+0xef>
			panic(
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	68 2c 30 80 00       	push   $0x80302c
  800dec:	6a 3a                	push   $0x3a
  800dee:	68 20 30 80 00       	push   $0x803020
  800df3:	e8 9f fe ff ff       	call   800c97 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800df8:	ff 45 f0             	incl   -0x10(%ebp)
  800dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e01:	0f 8c 3e ff ff ff    	jl     800d45 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e07:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e0e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e15:	eb 20                	jmp    800e37 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e17:	a1 20 40 80 00       	mov    0x804020,%eax
  800e1c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800e22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e25:	c1 e2 04             	shl    $0x4,%edx
  800e28:	01 d0                	add    %edx,%eax
  800e2a:	8a 40 04             	mov    0x4(%eax),%al
  800e2d:	3c 01                	cmp    $0x1,%al
  800e2f:	75 03                	jne    800e34 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800e31:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e34:	ff 45 e0             	incl   -0x20(%ebp)
  800e37:	a1 20 40 80 00       	mov    0x804020,%eax
  800e3c:	8b 50 74             	mov    0x74(%eax),%edx
  800e3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e42:	39 c2                	cmp    %eax,%edx
  800e44:	77 d1                	ja     800e17 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e49:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e4c:	74 14                	je     800e62 <CheckWSWithoutLastIndex+0x159>
		panic(
  800e4e:	83 ec 04             	sub    $0x4,%esp
  800e51:	68 80 30 80 00       	push   $0x803080
  800e56:	6a 44                	push   $0x44
  800e58:	68 20 30 80 00       	push   $0x803020
  800e5d:	e8 35 fe ff ff       	call   800c97 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e62:	90                   	nop
  800e63:	c9                   	leave  
  800e64:	c3                   	ret    

00800e65 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	8b 00                	mov    (%eax),%eax
  800e70:	8d 48 01             	lea    0x1(%eax),%ecx
  800e73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e76:	89 0a                	mov    %ecx,(%edx)
  800e78:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7b:	88 d1                	mov    %dl,%cl
  800e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e80:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	8b 00                	mov    (%eax),%eax
  800e89:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e8e:	75 2c                	jne    800ebc <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e90:	a0 24 40 80 00       	mov    0x804024,%al
  800e95:	0f b6 c0             	movzbl %al,%eax
  800e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9b:	8b 12                	mov    (%edx),%edx
  800e9d:	89 d1                	mov    %edx,%ecx
  800e9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea2:	83 c2 08             	add    $0x8,%edx
  800ea5:	83 ec 04             	sub    $0x4,%esp
  800ea8:	50                   	push   %eax
  800ea9:	51                   	push   %ecx
  800eaa:	52                   	push   %edx
  800eab:	e8 a9 14 00 00       	call   802359 <sys_cputs>
  800eb0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	8b 40 04             	mov    0x4(%eax),%eax
  800ec2:	8d 50 01             	lea    0x1(%eax),%edx
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ecb:	90                   	nop
  800ecc:	c9                   	leave  
  800ecd:	c3                   	ret    

00800ece <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ed7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ede:	00 00 00 
	b.cnt = 0;
  800ee1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ee8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eeb:	ff 75 0c             	pushl  0xc(%ebp)
  800eee:	ff 75 08             	pushl  0x8(%ebp)
  800ef1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ef7:	50                   	push   %eax
  800ef8:	68 65 0e 80 00       	push   $0x800e65
  800efd:	e8 11 02 00 00       	call   801113 <vprintfmt>
  800f02:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f05:	a0 24 40 80 00       	mov    0x804024,%al
  800f0a:	0f b6 c0             	movzbl %al,%eax
  800f0d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f13:	83 ec 04             	sub    $0x4,%esp
  800f16:	50                   	push   %eax
  800f17:	52                   	push   %edx
  800f18:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f1e:	83 c0 08             	add    $0x8,%eax
  800f21:	50                   	push   %eax
  800f22:	e8 32 14 00 00       	call   802359 <sys_cputs>
  800f27:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f2a:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800f31:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f37:	c9                   	leave  
  800f38:	c3                   	ret    

00800f39 <cprintf>:

int cprintf(const char *fmt, ...) {
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f3f:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800f46:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f49:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 f4             	pushl  -0xc(%ebp)
  800f55:	50                   	push   %eax
  800f56:	e8 73 ff ff ff       	call   800ece <vcprintf>
  800f5b:	83 c4 10             	add    $0x10,%esp
  800f5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f64:	c9                   	leave  
  800f65:	c3                   	ret    

00800f66 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f6c:	e8 f9 15 00 00       	call   80256a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f71:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	83 ec 08             	sub    $0x8,%esp
  800f7d:	ff 75 f4             	pushl  -0xc(%ebp)
  800f80:	50                   	push   %eax
  800f81:	e8 48 ff ff ff       	call   800ece <vcprintf>
  800f86:	83 c4 10             	add    $0x10,%esp
  800f89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f8c:	e8 f3 15 00 00       	call   802584 <sys_enable_interrupt>
	return cnt;
  800f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f94:	c9                   	leave  
  800f95:	c3                   	ret    

00800f96 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	53                   	push   %ebx
  800f9a:	83 ec 14             	sub    $0x14,%esp
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fa9:	8b 45 18             	mov    0x18(%ebp),%eax
  800fac:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fb4:	77 55                	ja     80100b <printnum+0x75>
  800fb6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fb9:	72 05                	jb     800fc0 <printnum+0x2a>
  800fbb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fbe:	77 4b                	ja     80100b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fc0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fc3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fc6:	8b 45 18             	mov    0x18(%ebp),%eax
  800fc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800fce:	52                   	push   %edx
  800fcf:	50                   	push   %eax
  800fd0:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd3:	ff 75 f0             	pushl  -0x10(%ebp)
  800fd6:	e8 b1 19 00 00       	call   80298c <__udivdi3>
  800fdb:	83 c4 10             	add    $0x10,%esp
  800fde:	83 ec 04             	sub    $0x4,%esp
  800fe1:	ff 75 20             	pushl  0x20(%ebp)
  800fe4:	53                   	push   %ebx
  800fe5:	ff 75 18             	pushl  0x18(%ebp)
  800fe8:	52                   	push   %edx
  800fe9:	50                   	push   %eax
  800fea:	ff 75 0c             	pushl  0xc(%ebp)
  800fed:	ff 75 08             	pushl  0x8(%ebp)
  800ff0:	e8 a1 ff ff ff       	call   800f96 <printnum>
  800ff5:	83 c4 20             	add    $0x20,%esp
  800ff8:	eb 1a                	jmp    801014 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ffa:	83 ec 08             	sub    $0x8,%esp
  800ffd:	ff 75 0c             	pushl  0xc(%ebp)
  801000:	ff 75 20             	pushl  0x20(%ebp)
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	ff d0                	call   *%eax
  801008:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80100b:	ff 4d 1c             	decl   0x1c(%ebp)
  80100e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801012:	7f e6                	jg     800ffa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801014:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801017:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801022:	53                   	push   %ebx
  801023:	51                   	push   %ecx
  801024:	52                   	push   %edx
  801025:	50                   	push   %eax
  801026:	e8 71 1a 00 00       	call   802a9c <__umoddi3>
  80102b:	83 c4 10             	add    $0x10,%esp
  80102e:	05 f4 32 80 00       	add    $0x8032f4,%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	0f be c0             	movsbl %al,%eax
  801038:	83 ec 08             	sub    $0x8,%esp
  80103b:	ff 75 0c             	pushl  0xc(%ebp)
  80103e:	50                   	push   %eax
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	ff d0                	call   *%eax
  801044:	83 c4 10             	add    $0x10,%esp
}
  801047:	90                   	nop
  801048:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801050:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801054:	7e 1c                	jle    801072 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8b 00                	mov    (%eax),%eax
  80105b:	8d 50 08             	lea    0x8(%eax),%edx
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	89 10                	mov    %edx,(%eax)
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8b 00                	mov    (%eax),%eax
  801068:	83 e8 08             	sub    $0x8,%eax
  80106b:	8b 50 04             	mov    0x4(%eax),%edx
  80106e:	8b 00                	mov    (%eax),%eax
  801070:	eb 40                	jmp    8010b2 <getuint+0x65>
	else if (lflag)
  801072:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801076:	74 1e                	je     801096 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8b 00                	mov    (%eax),%eax
  80107d:	8d 50 04             	lea    0x4(%eax),%edx
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	89 10                	mov    %edx,(%eax)
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8b 00                	mov    (%eax),%eax
  80108a:	83 e8 04             	sub    $0x4,%eax
  80108d:	8b 00                	mov    (%eax),%eax
  80108f:	ba 00 00 00 00       	mov    $0x0,%edx
  801094:	eb 1c                	jmp    8010b2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8b 00                	mov    (%eax),%eax
  80109b:	8d 50 04             	lea    0x4(%eax),%edx
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	89 10                	mov    %edx,(%eax)
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8b 00                	mov    (%eax),%eax
  8010a8:	83 e8 04             	sub    $0x4,%eax
  8010ab:	8b 00                	mov    (%eax),%eax
  8010ad:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010b2:	5d                   	pop    %ebp
  8010b3:	c3                   	ret    

008010b4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010b4:	55                   	push   %ebp
  8010b5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010b7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010bb:	7e 1c                	jle    8010d9 <getint+0x25>
		return va_arg(*ap, long long);
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8b 00                	mov    (%eax),%eax
  8010c2:	8d 50 08             	lea    0x8(%eax),%edx
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	89 10                	mov    %edx,(%eax)
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8b 00                	mov    (%eax),%eax
  8010cf:	83 e8 08             	sub    $0x8,%eax
  8010d2:	8b 50 04             	mov    0x4(%eax),%edx
  8010d5:	8b 00                	mov    (%eax),%eax
  8010d7:	eb 38                	jmp    801111 <getint+0x5d>
	else if (lflag)
  8010d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010dd:	74 1a                	je     8010f9 <getint+0x45>
		return va_arg(*ap, long);
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8b 00                	mov    (%eax),%eax
  8010e4:	8d 50 04             	lea    0x4(%eax),%edx
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	89 10                	mov    %edx,(%eax)
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8b 00                	mov    (%eax),%eax
  8010f1:	83 e8 04             	sub    $0x4,%eax
  8010f4:	8b 00                	mov    (%eax),%eax
  8010f6:	99                   	cltd   
  8010f7:	eb 18                	jmp    801111 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8b 00                	mov    (%eax),%eax
  8010fe:	8d 50 04             	lea    0x4(%eax),%edx
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	89 10                	mov    %edx,(%eax)
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8b 00                	mov    (%eax),%eax
  80110b:	83 e8 04             	sub    $0x4,%eax
  80110e:	8b 00                	mov    (%eax),%eax
  801110:	99                   	cltd   
}
  801111:	5d                   	pop    %ebp
  801112:	c3                   	ret    

00801113 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	56                   	push   %esi
  801117:	53                   	push   %ebx
  801118:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80111b:	eb 17                	jmp    801134 <vprintfmt+0x21>
			if (ch == '\0')
  80111d:	85 db                	test   %ebx,%ebx
  80111f:	0f 84 af 03 00 00    	je     8014d4 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801125:	83 ec 08             	sub    $0x8,%esp
  801128:	ff 75 0c             	pushl  0xc(%ebp)
  80112b:	53                   	push   %ebx
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	ff d0                	call   *%eax
  801131:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801134:	8b 45 10             	mov    0x10(%ebp),%eax
  801137:	8d 50 01             	lea    0x1(%eax),%edx
  80113a:	89 55 10             	mov    %edx,0x10(%ebp)
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	0f b6 d8             	movzbl %al,%ebx
  801142:	83 fb 25             	cmp    $0x25,%ebx
  801145:	75 d6                	jne    80111d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801147:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80114b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801152:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801159:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801160:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801167:	8b 45 10             	mov    0x10(%ebp),%eax
  80116a:	8d 50 01             	lea    0x1(%eax),%edx
  80116d:	89 55 10             	mov    %edx,0x10(%ebp)
  801170:	8a 00                	mov    (%eax),%al
  801172:	0f b6 d8             	movzbl %al,%ebx
  801175:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801178:	83 f8 55             	cmp    $0x55,%eax
  80117b:	0f 87 2b 03 00 00    	ja     8014ac <vprintfmt+0x399>
  801181:	8b 04 85 18 33 80 00 	mov    0x803318(,%eax,4),%eax
  801188:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80118a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80118e:	eb d7                	jmp    801167 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801190:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801194:	eb d1                	jmp    801167 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801196:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80119d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011a0:	89 d0                	mov    %edx,%eax
  8011a2:	c1 e0 02             	shl    $0x2,%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	01 c0                	add    %eax,%eax
  8011a9:	01 d8                	add    %ebx,%eax
  8011ab:	83 e8 30             	sub    $0x30,%eax
  8011ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	8a 00                	mov    (%eax),%al
  8011b6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011b9:	83 fb 2f             	cmp    $0x2f,%ebx
  8011bc:	7e 3e                	jle    8011fc <vprintfmt+0xe9>
  8011be:	83 fb 39             	cmp    $0x39,%ebx
  8011c1:	7f 39                	jg     8011fc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011c3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011c6:	eb d5                	jmp    80119d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cb:	83 c0 04             	add    $0x4,%eax
  8011ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8011d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d4:	83 e8 04             	sub    $0x4,%eax
  8011d7:	8b 00                	mov    (%eax),%eax
  8011d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011dc:	eb 1f                	jmp    8011fd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011e2:	79 83                	jns    801167 <vprintfmt+0x54>
				width = 0;
  8011e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011eb:	e9 77 ff ff ff       	jmp    801167 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011f0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011f7:	e9 6b ff ff ff       	jmp    801167 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011fc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801201:	0f 89 60 ff ff ff    	jns    801167 <vprintfmt+0x54>
				width = precision, precision = -1;
  801207:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80120a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80120d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801214:	e9 4e ff ff ff       	jmp    801167 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801219:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80121c:	e9 46 ff ff ff       	jmp    801167 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801221:	8b 45 14             	mov    0x14(%ebp),%eax
  801224:	83 c0 04             	add    $0x4,%eax
  801227:	89 45 14             	mov    %eax,0x14(%ebp)
  80122a:	8b 45 14             	mov    0x14(%ebp),%eax
  80122d:	83 e8 04             	sub    $0x4,%eax
  801230:	8b 00                	mov    (%eax),%eax
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	ff 75 0c             	pushl  0xc(%ebp)
  801238:	50                   	push   %eax
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	ff d0                	call   *%eax
  80123e:	83 c4 10             	add    $0x10,%esp
			break;
  801241:	e9 89 02 00 00       	jmp    8014cf <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801246:	8b 45 14             	mov    0x14(%ebp),%eax
  801249:	83 c0 04             	add    $0x4,%eax
  80124c:	89 45 14             	mov    %eax,0x14(%ebp)
  80124f:	8b 45 14             	mov    0x14(%ebp),%eax
  801252:	83 e8 04             	sub    $0x4,%eax
  801255:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801257:	85 db                	test   %ebx,%ebx
  801259:	79 02                	jns    80125d <vprintfmt+0x14a>
				err = -err;
  80125b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80125d:	83 fb 64             	cmp    $0x64,%ebx
  801260:	7f 0b                	jg     80126d <vprintfmt+0x15a>
  801262:	8b 34 9d 60 31 80 00 	mov    0x803160(,%ebx,4),%esi
  801269:	85 f6                	test   %esi,%esi
  80126b:	75 19                	jne    801286 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80126d:	53                   	push   %ebx
  80126e:	68 05 33 80 00       	push   $0x803305
  801273:	ff 75 0c             	pushl  0xc(%ebp)
  801276:	ff 75 08             	pushl  0x8(%ebp)
  801279:	e8 5e 02 00 00       	call   8014dc <printfmt>
  80127e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801281:	e9 49 02 00 00       	jmp    8014cf <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801286:	56                   	push   %esi
  801287:	68 0e 33 80 00       	push   $0x80330e
  80128c:	ff 75 0c             	pushl  0xc(%ebp)
  80128f:	ff 75 08             	pushl  0x8(%ebp)
  801292:	e8 45 02 00 00       	call   8014dc <printfmt>
  801297:	83 c4 10             	add    $0x10,%esp
			break;
  80129a:	e9 30 02 00 00       	jmp    8014cf <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80129f:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a2:	83 c0 04             	add    $0x4,%eax
  8012a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8012a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ab:	83 e8 04             	sub    $0x4,%eax
  8012ae:	8b 30                	mov    (%eax),%esi
  8012b0:	85 f6                	test   %esi,%esi
  8012b2:	75 05                	jne    8012b9 <vprintfmt+0x1a6>
				p = "(null)";
  8012b4:	be 11 33 80 00       	mov    $0x803311,%esi
			if (width > 0 && padc != '-')
  8012b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012bd:	7e 6d                	jle    80132c <vprintfmt+0x219>
  8012bf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012c3:	74 67                	je     80132c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c8:	83 ec 08             	sub    $0x8,%esp
  8012cb:	50                   	push   %eax
  8012cc:	56                   	push   %esi
  8012cd:	e8 0c 03 00 00       	call   8015de <strnlen>
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012d8:	eb 16                	jmp    8012f0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012da:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012de:	83 ec 08             	sub    $0x8,%esp
  8012e1:	ff 75 0c             	pushl  0xc(%ebp)
  8012e4:	50                   	push   %eax
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	ff d0                	call   *%eax
  8012ea:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ed:	ff 4d e4             	decl   -0x1c(%ebp)
  8012f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012f4:	7f e4                	jg     8012da <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012f6:	eb 34                	jmp    80132c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012f8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012fc:	74 1c                	je     80131a <vprintfmt+0x207>
  8012fe:	83 fb 1f             	cmp    $0x1f,%ebx
  801301:	7e 05                	jle    801308 <vprintfmt+0x1f5>
  801303:	83 fb 7e             	cmp    $0x7e,%ebx
  801306:	7e 12                	jle    80131a <vprintfmt+0x207>
					putch('?', putdat);
  801308:	83 ec 08             	sub    $0x8,%esp
  80130b:	ff 75 0c             	pushl  0xc(%ebp)
  80130e:	6a 3f                	push   $0x3f
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	ff d0                	call   *%eax
  801315:	83 c4 10             	add    $0x10,%esp
  801318:	eb 0f                	jmp    801329 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80131a:	83 ec 08             	sub    $0x8,%esp
  80131d:	ff 75 0c             	pushl  0xc(%ebp)
  801320:	53                   	push   %ebx
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	ff d0                	call   *%eax
  801326:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801329:	ff 4d e4             	decl   -0x1c(%ebp)
  80132c:	89 f0                	mov    %esi,%eax
  80132e:	8d 70 01             	lea    0x1(%eax),%esi
  801331:	8a 00                	mov    (%eax),%al
  801333:	0f be d8             	movsbl %al,%ebx
  801336:	85 db                	test   %ebx,%ebx
  801338:	74 24                	je     80135e <vprintfmt+0x24b>
  80133a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80133e:	78 b8                	js     8012f8 <vprintfmt+0x1e5>
  801340:	ff 4d e0             	decl   -0x20(%ebp)
  801343:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801347:	79 af                	jns    8012f8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801349:	eb 13                	jmp    80135e <vprintfmt+0x24b>
				putch(' ', putdat);
  80134b:	83 ec 08             	sub    $0x8,%esp
  80134e:	ff 75 0c             	pushl  0xc(%ebp)
  801351:	6a 20                	push   $0x20
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	ff d0                	call   *%eax
  801358:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80135b:	ff 4d e4             	decl   -0x1c(%ebp)
  80135e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801362:	7f e7                	jg     80134b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801364:	e9 66 01 00 00       	jmp    8014cf <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801369:	83 ec 08             	sub    $0x8,%esp
  80136c:	ff 75 e8             	pushl  -0x18(%ebp)
  80136f:	8d 45 14             	lea    0x14(%ebp),%eax
  801372:	50                   	push   %eax
  801373:	e8 3c fd ff ff       	call   8010b4 <getint>
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80137e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801384:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801387:	85 d2                	test   %edx,%edx
  801389:	79 23                	jns    8013ae <vprintfmt+0x29b>
				putch('-', putdat);
  80138b:	83 ec 08             	sub    $0x8,%esp
  80138e:	ff 75 0c             	pushl  0xc(%ebp)
  801391:	6a 2d                	push   $0x2d
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	ff d0                	call   *%eax
  801398:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80139b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a1:	f7 d8                	neg    %eax
  8013a3:	83 d2 00             	adc    $0x0,%edx
  8013a6:	f7 da                	neg    %edx
  8013a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013ae:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013b5:	e9 bc 00 00 00       	jmp    801476 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013ba:	83 ec 08             	sub    $0x8,%esp
  8013bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8013c0:	8d 45 14             	lea    0x14(%ebp),%eax
  8013c3:	50                   	push   %eax
  8013c4:	e8 84 fc ff ff       	call   80104d <getuint>
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013d2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013d9:	e9 98 00 00 00       	jmp    801476 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013de:	83 ec 08             	sub    $0x8,%esp
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	6a 58                	push   $0x58
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	ff d0                	call   *%eax
  8013eb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013ee:	83 ec 08             	sub    $0x8,%esp
  8013f1:	ff 75 0c             	pushl  0xc(%ebp)
  8013f4:	6a 58                	push   $0x58
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	ff d0                	call   *%eax
  8013fb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013fe:	83 ec 08             	sub    $0x8,%esp
  801401:	ff 75 0c             	pushl  0xc(%ebp)
  801404:	6a 58                	push   $0x58
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	ff d0                	call   *%eax
  80140b:	83 c4 10             	add    $0x10,%esp
			break;
  80140e:	e9 bc 00 00 00       	jmp    8014cf <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801413:	83 ec 08             	sub    $0x8,%esp
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	6a 30                	push   $0x30
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	ff d0                	call   *%eax
  801420:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801423:	83 ec 08             	sub    $0x8,%esp
  801426:	ff 75 0c             	pushl  0xc(%ebp)
  801429:	6a 78                	push   $0x78
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	ff d0                	call   *%eax
  801430:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801433:	8b 45 14             	mov    0x14(%ebp),%eax
  801436:	83 c0 04             	add    $0x4,%eax
  801439:	89 45 14             	mov    %eax,0x14(%ebp)
  80143c:	8b 45 14             	mov    0x14(%ebp),%eax
  80143f:	83 e8 04             	sub    $0x4,%eax
  801442:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801444:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801447:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80144e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801455:	eb 1f                	jmp    801476 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801457:	83 ec 08             	sub    $0x8,%esp
  80145a:	ff 75 e8             	pushl  -0x18(%ebp)
  80145d:	8d 45 14             	lea    0x14(%ebp),%eax
  801460:	50                   	push   %eax
  801461:	e8 e7 fb ff ff       	call   80104d <getuint>
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80146f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801476:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80147a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147d:	83 ec 04             	sub    $0x4,%esp
  801480:	52                   	push   %edx
  801481:	ff 75 e4             	pushl  -0x1c(%ebp)
  801484:	50                   	push   %eax
  801485:	ff 75 f4             	pushl  -0xc(%ebp)
  801488:	ff 75 f0             	pushl  -0x10(%ebp)
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	ff 75 08             	pushl  0x8(%ebp)
  801491:	e8 00 fb ff ff       	call   800f96 <printnum>
  801496:	83 c4 20             	add    $0x20,%esp
			break;
  801499:	eb 34                	jmp    8014cf <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80149b:	83 ec 08             	sub    $0x8,%esp
  80149e:	ff 75 0c             	pushl  0xc(%ebp)
  8014a1:	53                   	push   %ebx
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	ff d0                	call   *%eax
  8014a7:	83 c4 10             	add    $0x10,%esp
			break;
  8014aa:	eb 23                	jmp    8014cf <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	ff 75 0c             	pushl  0xc(%ebp)
  8014b2:	6a 25                	push   $0x25
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	ff d0                	call   *%eax
  8014b9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014bc:	ff 4d 10             	decl   0x10(%ebp)
  8014bf:	eb 03                	jmp    8014c4 <vprintfmt+0x3b1>
  8014c1:	ff 4d 10             	decl   0x10(%ebp)
  8014c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c7:	48                   	dec    %eax
  8014c8:	8a 00                	mov    (%eax),%al
  8014ca:	3c 25                	cmp    $0x25,%al
  8014cc:	75 f3                	jne    8014c1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014ce:	90                   	nop
		}
	}
  8014cf:	e9 47 fc ff ff       	jmp    80111b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014d4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d8:	5b                   	pop    %ebx
  8014d9:	5e                   	pop    %esi
  8014da:	5d                   	pop    %ebp
  8014db:	c3                   	ret    

008014dc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014e2:	8d 45 10             	lea    0x10(%ebp),%eax
  8014e5:	83 c0 04             	add    $0x4,%eax
  8014e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f1:	50                   	push   %eax
  8014f2:	ff 75 0c             	pushl  0xc(%ebp)
  8014f5:	ff 75 08             	pushl  0x8(%ebp)
  8014f8:	e8 16 fc ff ff       	call   801113 <vprintfmt>
  8014fd:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801500:	90                   	nop
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801506:	8b 45 0c             	mov    0xc(%ebp),%eax
  801509:	8b 40 08             	mov    0x8(%eax),%eax
  80150c:	8d 50 01             	lea    0x1(%eax),%edx
  80150f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801512:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801515:	8b 45 0c             	mov    0xc(%ebp),%eax
  801518:	8b 10                	mov    (%eax),%edx
  80151a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151d:	8b 40 04             	mov    0x4(%eax),%eax
  801520:	39 c2                	cmp    %eax,%edx
  801522:	73 12                	jae    801536 <sprintputch+0x33>
		*b->buf++ = ch;
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	8b 00                	mov    (%eax),%eax
  801529:	8d 48 01             	lea    0x1(%eax),%ecx
  80152c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152f:	89 0a                	mov    %ecx,(%edx)
  801531:	8b 55 08             	mov    0x8(%ebp),%edx
  801534:	88 10                	mov    %dl,(%eax)
}
  801536:	90                   	nop
  801537:	5d                   	pop    %ebp
  801538:	c3                   	ret    

00801539 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801545:	8b 45 0c             	mov    0xc(%ebp),%eax
  801548:	8d 50 ff             	lea    -0x1(%eax),%edx
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	01 d0                	add    %edx,%eax
  801550:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801553:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80155a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80155e:	74 06                	je     801566 <vsnprintf+0x2d>
  801560:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801564:	7f 07                	jg     80156d <vsnprintf+0x34>
		return -E_INVAL;
  801566:	b8 03 00 00 00       	mov    $0x3,%eax
  80156b:	eb 20                	jmp    80158d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80156d:	ff 75 14             	pushl  0x14(%ebp)
  801570:	ff 75 10             	pushl  0x10(%ebp)
  801573:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801576:	50                   	push   %eax
  801577:	68 03 15 80 00       	push   $0x801503
  80157c:	e8 92 fb ff ff       	call   801113 <vprintfmt>
  801581:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801584:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801587:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80158a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801595:	8d 45 10             	lea    0x10(%ebp),%eax
  801598:	83 c0 04             	add    $0x4,%eax
  80159b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80159e:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a4:	50                   	push   %eax
  8015a5:	ff 75 0c             	pushl  0xc(%ebp)
  8015a8:	ff 75 08             	pushl  0x8(%ebp)
  8015ab:	e8 89 ff ff ff       	call   801539 <vsnprintf>
  8015b0:	83 c4 10             	add    $0x10,%esp
  8015b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015c8:	eb 06                	jmp    8015d0 <strlen+0x15>
		n++;
  8015ca:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015cd:	ff 45 08             	incl   0x8(%ebp)
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	8a 00                	mov    (%eax),%al
  8015d5:	84 c0                	test   %al,%al
  8015d7:	75 f1                	jne    8015ca <strlen+0xf>
		n++;
	return n;
  8015d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015eb:	eb 09                	jmp    8015f6 <strnlen+0x18>
		n++;
  8015ed:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015f0:	ff 45 08             	incl   0x8(%ebp)
  8015f3:	ff 4d 0c             	decl   0xc(%ebp)
  8015f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015fa:	74 09                	je     801605 <strnlen+0x27>
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	8a 00                	mov    (%eax),%al
  801601:	84 c0                	test   %al,%al
  801603:	75 e8                	jne    8015ed <strnlen+0xf>
		n++;
	return n;
  801605:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801616:	90                   	nop
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	8d 50 01             	lea    0x1(%eax),%edx
  80161d:	89 55 08             	mov    %edx,0x8(%ebp)
  801620:	8b 55 0c             	mov    0xc(%ebp),%edx
  801623:	8d 4a 01             	lea    0x1(%edx),%ecx
  801626:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801629:	8a 12                	mov    (%edx),%dl
  80162b:	88 10                	mov    %dl,(%eax)
  80162d:	8a 00                	mov    (%eax),%al
  80162f:	84 c0                	test   %al,%al
  801631:	75 e4                	jne    801617 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801633:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801644:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80164b:	eb 1f                	jmp    80166c <strncpy+0x34>
		*dst++ = *src;
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	8d 50 01             	lea    0x1(%eax),%edx
  801653:	89 55 08             	mov    %edx,0x8(%ebp)
  801656:	8b 55 0c             	mov    0xc(%ebp),%edx
  801659:	8a 12                	mov    (%edx),%dl
  80165b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80165d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	84 c0                	test   %al,%al
  801664:	74 03                	je     801669 <strncpy+0x31>
			src++;
  801666:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801669:	ff 45 fc             	incl   -0x4(%ebp)
  80166c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801672:	72 d9                	jb     80164d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801674:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801685:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801689:	74 30                	je     8016bb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80168b:	eb 16                	jmp    8016a3 <strlcpy+0x2a>
			*dst++ = *src++;
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8d 50 01             	lea    0x1(%eax),%edx
  801693:	89 55 08             	mov    %edx,0x8(%ebp)
  801696:	8b 55 0c             	mov    0xc(%ebp),%edx
  801699:	8d 4a 01             	lea    0x1(%edx),%ecx
  80169c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80169f:	8a 12                	mov    (%edx),%dl
  8016a1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016a3:	ff 4d 10             	decl   0x10(%ebp)
  8016a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016aa:	74 09                	je     8016b5 <strlcpy+0x3c>
  8016ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016af:	8a 00                	mov    (%eax),%al
  8016b1:	84 c0                	test   %al,%al
  8016b3:	75 d8                	jne    80168d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c1:	29 c2                	sub    %eax,%edx
  8016c3:	89 d0                	mov    %edx,%eax
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016ca:	eb 06                	jmp    8016d2 <strcmp+0xb>
		p++, q++;
  8016cc:	ff 45 08             	incl   0x8(%ebp)
  8016cf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 00                	mov    (%eax),%al
  8016d7:	84 c0                	test   %al,%al
  8016d9:	74 0e                	je     8016e9 <strcmp+0x22>
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8a 10                	mov    (%eax),%dl
  8016e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	38 c2                	cmp    %al,%dl
  8016e7:	74 e3                	je     8016cc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	8a 00                	mov    (%eax),%al
  8016ee:	0f b6 d0             	movzbl %al,%edx
  8016f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f4:	8a 00                	mov    (%eax),%al
  8016f6:	0f b6 c0             	movzbl %al,%eax
  8016f9:	29 c2                	sub    %eax,%edx
  8016fb:	89 d0                	mov    %edx,%eax
}
  8016fd:	5d                   	pop    %ebp
  8016fe:	c3                   	ret    

008016ff <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801702:	eb 09                	jmp    80170d <strncmp+0xe>
		n--, p++, q++;
  801704:	ff 4d 10             	decl   0x10(%ebp)
  801707:	ff 45 08             	incl   0x8(%ebp)
  80170a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80170d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801711:	74 17                	je     80172a <strncmp+0x2b>
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	8a 00                	mov    (%eax),%al
  801718:	84 c0                	test   %al,%al
  80171a:	74 0e                	je     80172a <strncmp+0x2b>
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	8a 10                	mov    (%eax),%dl
  801721:	8b 45 0c             	mov    0xc(%ebp),%eax
  801724:	8a 00                	mov    (%eax),%al
  801726:	38 c2                	cmp    %al,%dl
  801728:	74 da                	je     801704 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80172a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80172e:	75 07                	jne    801737 <strncmp+0x38>
		return 0;
  801730:	b8 00 00 00 00       	mov    $0x0,%eax
  801735:	eb 14                	jmp    80174b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	8a 00                	mov    (%eax),%al
  80173c:	0f b6 d0             	movzbl %al,%edx
  80173f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801742:	8a 00                	mov    (%eax),%al
  801744:	0f b6 c0             	movzbl %al,%eax
  801747:	29 c2                	sub    %eax,%edx
  801749:	89 d0                	mov    %edx,%eax
}
  80174b:	5d                   	pop    %ebp
  80174c:	c3                   	ret    

0080174d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	8b 45 0c             	mov    0xc(%ebp),%eax
  801756:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801759:	eb 12                	jmp    80176d <strchr+0x20>
		if (*s == c)
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801763:	75 05                	jne    80176a <strchr+0x1d>
			return (char *) s;
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	eb 11                	jmp    80177b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80176a:	ff 45 08             	incl   0x8(%ebp)
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8a 00                	mov    (%eax),%al
  801772:	84 c0                	test   %al,%al
  801774:	75 e5                	jne    80175b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801776:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 04             	sub    $0x4,%esp
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801789:	eb 0d                	jmp    801798 <strfind+0x1b>
		if (*s == c)
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	8a 00                	mov    (%eax),%al
  801790:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801793:	74 0e                	je     8017a3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801795:	ff 45 08             	incl   0x8(%ebp)
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
  80179b:	8a 00                	mov    (%eax),%al
  80179d:	84 c0                	test   %al,%al
  80179f:	75 ea                	jne    80178b <strfind+0xe>
  8017a1:	eb 01                	jmp    8017a4 <strfind+0x27>
		if (*s == c)
			break;
  8017a3:	90                   	nop
	return (char *) s;
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017bb:	eb 0e                	jmp    8017cb <memset+0x22>
		*p++ = c;
  8017bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c0:	8d 50 01             	lea    0x1(%eax),%edx
  8017c3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017cb:	ff 4d f8             	decl   -0x8(%ebp)
  8017ce:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017d2:	79 e9                	jns    8017bd <memset+0x14>
		*p++ = c;

	return v;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017eb:	eb 16                	jmp    801803 <memcpy+0x2a>
		*d++ = *s++;
  8017ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f0:	8d 50 01             	lea    0x1(%eax),%edx
  8017f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017fc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017ff:	8a 12                	mov    (%edx),%dl
  801801:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801803:	8b 45 10             	mov    0x10(%ebp),%eax
  801806:	8d 50 ff             	lea    -0x1(%eax),%edx
  801809:	89 55 10             	mov    %edx,0x10(%ebp)
  80180c:	85 c0                	test   %eax,%eax
  80180e:	75 dd                	jne    8017ed <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80181b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801827:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80182d:	73 50                	jae    80187f <memmove+0x6a>
  80182f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801832:	8b 45 10             	mov    0x10(%ebp),%eax
  801835:	01 d0                	add    %edx,%eax
  801837:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80183a:	76 43                	jbe    80187f <memmove+0x6a>
		s += n;
  80183c:	8b 45 10             	mov    0x10(%ebp),%eax
  80183f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801842:	8b 45 10             	mov    0x10(%ebp),%eax
  801845:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801848:	eb 10                	jmp    80185a <memmove+0x45>
			*--d = *--s;
  80184a:	ff 4d f8             	decl   -0x8(%ebp)
  80184d:	ff 4d fc             	decl   -0x4(%ebp)
  801850:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801853:	8a 10                	mov    (%eax),%dl
  801855:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801858:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80185a:	8b 45 10             	mov    0x10(%ebp),%eax
  80185d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801860:	89 55 10             	mov    %edx,0x10(%ebp)
  801863:	85 c0                	test   %eax,%eax
  801865:	75 e3                	jne    80184a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801867:	eb 23                	jmp    80188c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801869:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186c:	8d 50 01             	lea    0x1(%eax),%edx
  80186f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801872:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801875:	8d 4a 01             	lea    0x1(%edx),%ecx
  801878:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80187b:	8a 12                	mov    (%edx),%dl
  80187d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	8d 50 ff             	lea    -0x1(%eax),%edx
  801885:	89 55 10             	mov    %edx,0x10(%ebp)
  801888:	85 c0                	test   %eax,%eax
  80188a:	75 dd                	jne    801869 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80189d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018a3:	eb 2a                	jmp    8018cf <memcmp+0x3e>
		if (*s1 != *s2)
  8018a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a8:	8a 10                	mov    (%eax),%dl
  8018aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ad:	8a 00                	mov    (%eax),%al
  8018af:	38 c2                	cmp    %al,%dl
  8018b1:	74 16                	je     8018c9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b6:	8a 00                	mov    (%eax),%al
  8018b8:	0f b6 d0             	movzbl %al,%edx
  8018bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018be:	8a 00                	mov    (%eax),%al
  8018c0:	0f b6 c0             	movzbl %al,%eax
  8018c3:	29 c2                	sub    %eax,%edx
  8018c5:	89 d0                	mov    %edx,%eax
  8018c7:	eb 18                	jmp    8018e1 <memcmp+0x50>
		s1++, s2++;
  8018c9:	ff 45 fc             	incl   -0x4(%ebp)
  8018cc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018d5:	89 55 10             	mov    %edx,0x10(%ebp)
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	75 c9                	jne    8018a5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ef:	01 d0                	add    %edx,%eax
  8018f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018f4:	eb 15                	jmp    80190b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	8a 00                	mov    (%eax),%al
  8018fb:	0f b6 d0             	movzbl %al,%edx
  8018fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801901:	0f b6 c0             	movzbl %al,%eax
  801904:	39 c2                	cmp    %eax,%edx
  801906:	74 0d                	je     801915 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801908:	ff 45 08             	incl   0x8(%ebp)
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801911:	72 e3                	jb     8018f6 <memfind+0x13>
  801913:	eb 01                	jmp    801916 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801915:	90                   	nop
	return (void *) s;
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801921:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801928:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80192f:	eb 03                	jmp    801934 <strtol+0x19>
		s++;
  801931:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8a 00                	mov    (%eax),%al
  801939:	3c 20                	cmp    $0x20,%al
  80193b:	74 f4                	je     801931 <strtol+0x16>
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	8a 00                	mov    (%eax),%al
  801942:	3c 09                	cmp    $0x9,%al
  801944:	74 eb                	je     801931 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	8a 00                	mov    (%eax),%al
  80194b:	3c 2b                	cmp    $0x2b,%al
  80194d:	75 05                	jne    801954 <strtol+0x39>
		s++;
  80194f:	ff 45 08             	incl   0x8(%ebp)
  801952:	eb 13                	jmp    801967 <strtol+0x4c>
	else if (*s == '-')
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	8a 00                	mov    (%eax),%al
  801959:	3c 2d                	cmp    $0x2d,%al
  80195b:	75 0a                	jne    801967 <strtol+0x4c>
		s++, neg = 1;
  80195d:	ff 45 08             	incl   0x8(%ebp)
  801960:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801967:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196b:	74 06                	je     801973 <strtol+0x58>
  80196d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801971:	75 20                	jne    801993 <strtol+0x78>
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	8a 00                	mov    (%eax),%al
  801978:	3c 30                	cmp    $0x30,%al
  80197a:	75 17                	jne    801993 <strtol+0x78>
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	40                   	inc    %eax
  801980:	8a 00                	mov    (%eax),%al
  801982:	3c 78                	cmp    $0x78,%al
  801984:	75 0d                	jne    801993 <strtol+0x78>
		s += 2, base = 16;
  801986:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80198a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801991:	eb 28                	jmp    8019bb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801993:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801997:	75 15                	jne    8019ae <strtol+0x93>
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	3c 30                	cmp    $0x30,%al
  8019a0:	75 0c                	jne    8019ae <strtol+0x93>
		s++, base = 8;
  8019a2:	ff 45 08             	incl   0x8(%ebp)
  8019a5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019ac:	eb 0d                	jmp    8019bb <strtol+0xa0>
	else if (base == 0)
  8019ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019b2:	75 07                	jne    8019bb <strtol+0xa0>
		base = 10;
  8019b4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	8a 00                	mov    (%eax),%al
  8019c0:	3c 2f                	cmp    $0x2f,%al
  8019c2:	7e 19                	jle    8019dd <strtol+0xc2>
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	8a 00                	mov    (%eax),%al
  8019c9:	3c 39                	cmp    $0x39,%al
  8019cb:	7f 10                	jg     8019dd <strtol+0xc2>
			dig = *s - '0';
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	8a 00                	mov    (%eax),%al
  8019d2:	0f be c0             	movsbl %al,%eax
  8019d5:	83 e8 30             	sub    $0x30,%eax
  8019d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019db:	eb 42                	jmp    801a1f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	8a 00                	mov    (%eax),%al
  8019e2:	3c 60                	cmp    $0x60,%al
  8019e4:	7e 19                	jle    8019ff <strtol+0xe4>
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	8a 00                	mov    (%eax),%al
  8019eb:	3c 7a                	cmp    $0x7a,%al
  8019ed:	7f 10                	jg     8019ff <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	8a 00                	mov    (%eax),%al
  8019f4:	0f be c0             	movsbl %al,%eax
  8019f7:	83 e8 57             	sub    $0x57,%eax
  8019fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019fd:	eb 20                	jmp    801a1f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	3c 40                	cmp    $0x40,%al
  801a06:	7e 39                	jle    801a41 <strtol+0x126>
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	8a 00                	mov    (%eax),%al
  801a0d:	3c 5a                	cmp    $0x5a,%al
  801a0f:	7f 30                	jg     801a41 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	8a 00                	mov    (%eax),%al
  801a16:	0f be c0             	movsbl %al,%eax
  801a19:	83 e8 37             	sub    $0x37,%eax
  801a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a22:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a25:	7d 19                	jge    801a40 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a27:	ff 45 08             	incl   0x8(%ebp)
  801a2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a31:	89 c2                	mov    %eax,%edx
  801a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a36:	01 d0                	add    %edx,%eax
  801a38:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a3b:	e9 7b ff ff ff       	jmp    8019bb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a40:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a45:	74 08                	je     801a4f <strtol+0x134>
		*endptr = (char *) s;
  801a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4a:	8b 55 08             	mov    0x8(%ebp),%edx
  801a4d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a53:	74 07                	je     801a5c <strtol+0x141>
  801a55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a58:	f7 d8                	neg    %eax
  801a5a:	eb 03                	jmp    801a5f <strtol+0x144>
  801a5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <ltostr>:

void
ltostr(long value, char *str)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a6e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a79:	79 13                	jns    801a8e <ltostr+0x2d>
	{
		neg = 1;
  801a7b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a85:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a88:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a8b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a96:	99                   	cltd   
  801a97:	f7 f9                	idiv   %ecx
  801a99:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a9f:	8d 50 01             	lea    0x1(%eax),%edx
  801aa2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aa5:	89 c2                	mov    %eax,%edx
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	01 d0                	add    %edx,%eax
  801aac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801aaf:	83 c2 30             	add    $0x30,%edx
  801ab2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ab4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801abc:	f7 e9                	imul   %ecx
  801abe:	c1 fa 02             	sar    $0x2,%edx
  801ac1:	89 c8                	mov    %ecx,%eax
  801ac3:	c1 f8 1f             	sar    $0x1f,%eax
  801ac6:	29 c2                	sub    %eax,%edx
  801ac8:	89 d0                	mov    %edx,%eax
  801aca:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801acd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ad5:	f7 e9                	imul   %ecx
  801ad7:	c1 fa 02             	sar    $0x2,%edx
  801ada:	89 c8                	mov    %ecx,%eax
  801adc:	c1 f8 1f             	sar    $0x1f,%eax
  801adf:	29 c2                	sub    %eax,%edx
  801ae1:	89 d0                	mov    %edx,%eax
  801ae3:	c1 e0 02             	shl    $0x2,%eax
  801ae6:	01 d0                	add    %edx,%eax
  801ae8:	01 c0                	add    %eax,%eax
  801aea:	29 c1                	sub    %eax,%ecx
  801aec:	89 ca                	mov    %ecx,%edx
  801aee:	85 d2                	test   %edx,%edx
  801af0:	75 9c                	jne    801a8e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801af2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801af9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afc:	48                   	dec    %eax
  801afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b00:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b04:	74 3d                	je     801b43 <ltostr+0xe2>
		start = 1 ;
  801b06:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b0d:	eb 34                	jmp    801b43 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b15:	01 d0                	add    %edx,%eax
  801b17:	8a 00                	mov    (%eax),%al
  801b19:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b22:	01 c2                	add    %eax,%edx
  801b24:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2a:	01 c8                	add    %ecx,%eax
  801b2c:	8a 00                	mov    (%eax),%al
  801b2e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b36:	01 c2                	add    %eax,%edx
  801b38:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b3b:	88 02                	mov    %al,(%edx)
		start++ ;
  801b3d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b40:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b46:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b49:	7c c4                	jl     801b0f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b4b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b51:	01 d0                	add    %edx,%eax
  801b53:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b56:	90                   	nop
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b5f:	ff 75 08             	pushl  0x8(%ebp)
  801b62:	e8 54 fa ff ff       	call   8015bb <strlen>
  801b67:	83 c4 04             	add    $0x4,%esp
  801b6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b6d:	ff 75 0c             	pushl  0xc(%ebp)
  801b70:	e8 46 fa ff ff       	call   8015bb <strlen>
  801b75:	83 c4 04             	add    $0x4,%esp
  801b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b89:	eb 17                	jmp    801ba2 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b8b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b91:	01 c2                	add    %eax,%edx
  801b93:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	01 c8                	add    %ecx,%eax
  801b9b:	8a 00                	mov    (%eax),%al
  801b9d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b9f:	ff 45 fc             	incl   -0x4(%ebp)
  801ba2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ba5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ba8:	7c e1                	jl     801b8b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801baa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bb1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bb8:	eb 1f                	jmp    801bd9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bbd:	8d 50 01             	lea    0x1(%eax),%edx
  801bc0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bc3:	89 c2                	mov    %eax,%edx
  801bc5:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc8:	01 c2                	add    %eax,%edx
  801bca:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd0:	01 c8                	add    %ecx,%eax
  801bd2:	8a 00                	mov    (%eax),%al
  801bd4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bd6:	ff 45 f8             	incl   -0x8(%ebp)
  801bd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bdc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bdf:	7c d9                	jl     801bba <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801be1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be4:	8b 45 10             	mov    0x10(%ebp),%eax
  801be7:	01 d0                	add    %edx,%eax
  801be9:	c6 00 00             	movb   $0x0,(%eax)
}
  801bec:	90                   	nop
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bf2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bfb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfe:	8b 00                	mov    (%eax),%eax
  801c00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c07:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0a:	01 d0                	add    %edx,%eax
  801c0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c12:	eb 0c                	jmp    801c20 <strsplit+0x31>
			*string++ = 0;
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	8d 50 01             	lea    0x1(%eax),%edx
  801c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  801c1d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	8a 00                	mov    (%eax),%al
  801c25:	84 c0                	test   %al,%al
  801c27:	74 18                	je     801c41 <strsplit+0x52>
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8a 00                	mov    (%eax),%al
  801c2e:	0f be c0             	movsbl %al,%eax
  801c31:	50                   	push   %eax
  801c32:	ff 75 0c             	pushl  0xc(%ebp)
  801c35:	e8 13 fb ff ff       	call   80174d <strchr>
  801c3a:	83 c4 08             	add    $0x8,%esp
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	75 d3                	jne    801c14 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	8a 00                	mov    (%eax),%al
  801c46:	84 c0                	test   %al,%al
  801c48:	74 5a                	je     801ca4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4d:	8b 00                	mov    (%eax),%eax
  801c4f:	83 f8 0f             	cmp    $0xf,%eax
  801c52:	75 07                	jne    801c5b <strsplit+0x6c>
		{
			return 0;
  801c54:	b8 00 00 00 00       	mov    $0x0,%eax
  801c59:	eb 66                	jmp    801cc1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5e:	8b 00                	mov    (%eax),%eax
  801c60:	8d 48 01             	lea    0x1(%eax),%ecx
  801c63:	8b 55 14             	mov    0x14(%ebp),%edx
  801c66:	89 0a                	mov    %ecx,(%edx)
  801c68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c72:	01 c2                	add    %eax,%edx
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c79:	eb 03                	jmp    801c7e <strsplit+0x8f>
			string++;
  801c7b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	8a 00                	mov    (%eax),%al
  801c83:	84 c0                	test   %al,%al
  801c85:	74 8b                	je     801c12 <strsplit+0x23>
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	8a 00                	mov    (%eax),%al
  801c8c:	0f be c0             	movsbl %al,%eax
  801c8f:	50                   	push   %eax
  801c90:	ff 75 0c             	pushl  0xc(%ebp)
  801c93:	e8 b5 fa ff ff       	call   80174d <strchr>
  801c98:	83 c4 08             	add    $0x8,%esp
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	74 dc                	je     801c7b <strsplit+0x8c>
			string++;
	}
  801c9f:	e9 6e ff ff ff       	jmp    801c12 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ca4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca8:	8b 00                	mov    (%eax),%eax
  801caa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cb1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb4:	01 d0                	add    %edx,%eax
  801cb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cbc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801cc9:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801cd0:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801cd6:	01 d0                	add    %edx,%eax
  801cd8:	48                   	dec    %eax
  801cd9:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801cdc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801cdf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce4:	f7 75 ac             	divl   -0x54(%ebp)
  801ce7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801cea:	29 d0                	sub    %edx,%eax
  801cec:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801cef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801cf6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801cfd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801d04:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801d0b:	eb 3f                	jmp    801d4c <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801d0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d10:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801d17:	83 ec 04             	sub    $0x4,%esp
  801d1a:	50                   	push   %eax
  801d1b:	ff 75 e8             	pushl  -0x18(%ebp)
  801d1e:	68 70 34 80 00       	push   $0x803470
  801d23:	e8 11 f2 ff ff       	call   800f39 <cprintf>
  801d28:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801d2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d2e:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801d35:	83 ec 04             	sub    $0x4,%esp
  801d38:	50                   	push   %eax
  801d39:	ff 75 e8             	pushl  -0x18(%ebp)
  801d3c:	68 85 34 80 00       	push   $0x803485
  801d41:	e8 f3 f1 ff ff       	call   800f39 <cprintf>
  801d46:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801d49:	ff 45 e8             	incl   -0x18(%ebp)
  801d4c:	a1 28 40 80 00       	mov    0x804028,%eax
  801d51:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801d54:	7c b7                	jl     801d0d <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801d56:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801d5d:	e9 42 01 00 00       	jmp    801ea4 <malloc+0x1e1>
		int flag0=1;
  801d62:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801d69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d6c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d6f:	eb 6b                	jmp    801ddc <malloc+0x119>
			for(int k=0;k<count;k++){
  801d71:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801d78:	eb 42                	jmp    801dbc <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801d7a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d7d:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801d84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d87:	39 c2                	cmp    %eax,%edx
  801d89:	77 2e                	ja     801db9 <malloc+0xf6>
  801d8b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d8e:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801d95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d98:	39 c2                	cmp    %eax,%edx
  801d9a:	76 1d                	jbe    801db9 <malloc+0xf6>
					ni=arr_add[k].end-i;
  801d9c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d9f:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801da9:	29 c2                	sub    %eax,%edx
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801db0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801db7:	eb 0d                	jmp    801dc6 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801db9:	ff 45 d8             	incl   -0x28(%ebp)
  801dbc:	a1 28 40 80 00       	mov    0x804028,%eax
  801dc1:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801dc4:	7c b4                	jl     801d7a <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801dc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dca:	74 09                	je     801dd5 <malloc+0x112>
				flag0=0;
  801dcc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801dd3:	eb 16                	jmp    801deb <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801dd5:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801ddc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	01 c2                	add    %eax,%edx
  801de4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801de7:	39 c2                	cmp    %eax,%edx
  801de9:	77 86                	ja     801d71 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801deb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801def:	0f 84 a2 00 00 00    	je     801e97 <malloc+0x1d4>

			int f=1;
  801df5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801dfc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801dff:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e02:	89 c8                	mov    %ecx,%eax
  801e04:	01 c0                	add    %eax,%eax
  801e06:	01 c8                	add    %ecx,%eax
  801e08:	c1 e0 02             	shl    $0x2,%eax
  801e0b:	05 20 41 80 00       	add    $0x804120,%eax
  801e10:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801e12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e15:	8b 45 08             	mov    0x8(%ebp),%eax
  801e18:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801e1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e1e:	89 d0                	mov    %edx,%eax
  801e20:	01 c0                	add    %eax,%eax
  801e22:	01 d0                	add    %edx,%eax
  801e24:	c1 e0 02             	shl    $0x2,%eax
  801e27:	05 24 41 80 00       	add    $0x804124,%eax
  801e2c:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801e2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e31:	89 d0                	mov    %edx,%eax
  801e33:	01 c0                	add    %eax,%eax
  801e35:	01 d0                	add    %edx,%eax
  801e37:	c1 e0 02             	shl    $0x2,%eax
  801e3a:	05 28 41 80 00       	add    $0x804128,%eax
  801e3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801e45:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801e48:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801e4f:	eb 36                	jmp    801e87 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801e51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	01 c2                	add    %eax,%edx
  801e59:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e5c:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801e63:	39 c2                	cmp    %eax,%edx
  801e65:	73 1d                	jae    801e84 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801e67:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e6a:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801e71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e74:	29 c2                	sub    %eax,%edx
  801e76:	89 d0                	mov    %edx,%eax
  801e78:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801e7b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801e82:	eb 0d                	jmp    801e91 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801e84:	ff 45 d0             	incl   -0x30(%ebp)
  801e87:	a1 28 40 80 00       	mov    0x804028,%eax
  801e8c:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801e8f:	7c c0                	jl     801e51 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801e91:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801e95:	75 1d                	jne    801eb4 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801e97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801e9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea1:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801ea4:	a1 04 40 80 00       	mov    0x804004,%eax
  801ea9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801eac:	0f 8c b0 fe ff ff    	jl     801d62 <malloc+0x9f>
  801eb2:	eb 01                	jmp    801eb5 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801eb4:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801eb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb9:	75 7a                	jne    801f35 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801ebb:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	01 d0                	add    %edx,%eax
  801ec6:	48                   	dec    %eax
  801ec7:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801ecc:	7c 0a                	jl     801ed8 <malloc+0x215>
			return NULL;
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed3:	e9 a4 02 00 00       	jmp    80217c <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801ed8:	a1 04 40 80 00       	mov    0x804004,%eax
  801edd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801ee0:	a1 28 40 80 00       	mov    0x804028,%eax
  801ee5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801ee8:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801eef:	83 ec 08             	sub    $0x8,%esp
  801ef2:	ff 75 08             	pushl  0x8(%ebp)
  801ef5:	ff 75 a4             	pushl  -0x5c(%ebp)
  801ef8:	e8 04 06 00 00       	call   802501 <sys_allocateMem>
  801efd:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801f00:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	01 d0                	add    %edx,%eax
  801f0b:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801f10:	a1 28 40 80 00       	mov    0x804028,%eax
  801f15:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f1b:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801f22:	a1 28 40 80 00       	mov    0x804028,%eax
  801f27:	40                   	inc    %eax
  801f28:	a3 28 40 80 00       	mov    %eax,0x804028

			return (void*)s;
  801f2d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801f30:	e9 47 02 00 00       	jmp    80217c <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801f35:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801f3c:	e9 ac 00 00 00       	jmp    801fed <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801f41:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801f44:	89 d0                	mov    %edx,%eax
  801f46:	01 c0                	add    %eax,%eax
  801f48:	01 d0                	add    %edx,%eax
  801f4a:	c1 e0 02             	shl    $0x2,%eax
  801f4d:	05 24 41 80 00       	add    $0x804124,%eax
  801f52:	8b 00                	mov    (%eax),%eax
  801f54:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801f57:	eb 7e                	jmp    801fd7 <malloc+0x314>
			int flag=0;
  801f59:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801f60:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801f67:	eb 57                	jmp    801fc0 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801f69:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f6c:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801f73:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f76:	39 c2                	cmp    %eax,%edx
  801f78:	77 1a                	ja     801f94 <malloc+0x2d1>
  801f7a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f7d:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801f84:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f87:	39 c2                	cmp    %eax,%edx
  801f89:	76 09                	jbe    801f94 <malloc+0x2d1>
								flag=1;
  801f8b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801f92:	eb 36                	jmp    801fca <malloc+0x307>
			arr[i].space++;
  801f94:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801f97:	89 d0                	mov    %edx,%eax
  801f99:	01 c0                	add    %eax,%eax
  801f9b:	01 d0                	add    %edx,%eax
  801f9d:	c1 e0 02             	shl    $0x2,%eax
  801fa0:	05 28 41 80 00       	add    $0x804128,%eax
  801fa5:	8b 00                	mov    (%eax),%eax
  801fa7:	8d 48 01             	lea    0x1(%eax),%ecx
  801faa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801fad:	89 d0                	mov    %edx,%eax
  801faf:	01 c0                	add    %eax,%eax
  801fb1:	01 d0                	add    %edx,%eax
  801fb3:	c1 e0 02             	shl    $0x2,%eax
  801fb6:	05 28 41 80 00       	add    $0x804128,%eax
  801fbb:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801fbd:	ff 45 c0             	incl   -0x40(%ebp)
  801fc0:	a1 28 40 80 00       	mov    0x804028,%eax
  801fc5:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801fc8:	7c 9f                	jl     801f69 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801fca:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801fce:	75 19                	jne    801fe9 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801fd0:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801fd7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801fda:	a1 04 40 80 00       	mov    0x804004,%eax
  801fdf:	39 c2                	cmp    %eax,%edx
  801fe1:	0f 82 72 ff ff ff    	jb     801f59 <malloc+0x296>
  801fe7:	eb 01                	jmp    801fea <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801fe9:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801fea:	ff 45 cc             	incl   -0x34(%ebp)
  801fed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ff0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ff3:	0f 8c 48 ff ff ff    	jl     801f41 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801ff9:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  802000:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  802007:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  80200e:	eb 37                	jmp    802047 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  802010:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  802013:	89 d0                	mov    %edx,%eax
  802015:	01 c0                	add    %eax,%eax
  802017:	01 d0                	add    %edx,%eax
  802019:	c1 e0 02             	shl    $0x2,%eax
  80201c:	05 28 41 80 00       	add    $0x804128,%eax
  802021:	8b 00                	mov    (%eax),%eax
  802023:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802026:	7d 1c                	jge    802044 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  802028:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80202b:	89 d0                	mov    %edx,%eax
  80202d:	01 c0                	add    %eax,%eax
  80202f:	01 d0                	add    %edx,%eax
  802031:	c1 e0 02             	shl    $0x2,%eax
  802034:	05 28 41 80 00       	add    $0x804128,%eax
  802039:	8b 00                	mov    (%eax),%eax
  80203b:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  80203e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802041:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  802044:	ff 45 b4             	incl   -0x4c(%ebp)
  802047:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80204a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80204d:	7c c1                	jl     802010 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  80204f:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802055:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  802058:	89 c8                	mov    %ecx,%eax
  80205a:	01 c0                	add    %eax,%eax
  80205c:	01 c8                	add    %ecx,%eax
  80205e:	c1 e0 02             	shl    $0x2,%eax
  802061:	05 20 41 80 00       	add    $0x804120,%eax
  802066:	8b 00                	mov    (%eax),%eax
  802068:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  80206f:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802075:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  802078:	89 c8                	mov    %ecx,%eax
  80207a:	01 c0                	add    %eax,%eax
  80207c:	01 c8                	add    %ecx,%eax
  80207e:	c1 e0 02             	shl    $0x2,%eax
  802081:	05 24 41 80 00       	add    $0x804124,%eax
  802086:	8b 00                	mov    (%eax),%eax
  802088:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  80208f:	a1 28 40 80 00       	mov    0x804028,%eax
  802094:	40                   	inc    %eax
  802095:	a3 28 40 80 00       	mov    %eax,0x804028


		sys_allocateMem(arr[index].start,size);
  80209a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80209d:	89 d0                	mov    %edx,%eax
  80209f:	01 c0                	add    %eax,%eax
  8020a1:	01 d0                	add    %edx,%eax
  8020a3:	c1 e0 02             	shl    $0x2,%eax
  8020a6:	05 20 41 80 00       	add    $0x804120,%eax
  8020ab:	8b 00                	mov    (%eax),%eax
  8020ad:	83 ec 08             	sub    $0x8,%esp
  8020b0:	ff 75 08             	pushl  0x8(%ebp)
  8020b3:	50                   	push   %eax
  8020b4:	e8 48 04 00 00       	call   802501 <sys_allocateMem>
  8020b9:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  8020bc:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8020c3:	eb 78                	jmp    80213d <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8020c5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8020c8:	89 d0                	mov    %edx,%eax
  8020ca:	01 c0                	add    %eax,%eax
  8020cc:	01 d0                	add    %edx,%eax
  8020ce:	c1 e0 02             	shl    $0x2,%eax
  8020d1:	05 20 41 80 00       	add    $0x804120,%eax
  8020d6:	8b 00                	mov    (%eax),%eax
  8020d8:	83 ec 04             	sub    $0x4,%esp
  8020db:	50                   	push   %eax
  8020dc:	ff 75 b0             	pushl  -0x50(%ebp)
  8020df:	68 70 34 80 00       	push   $0x803470
  8020e4:	e8 50 ee ff ff       	call   800f39 <cprintf>
  8020e9:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8020ec:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8020ef:	89 d0                	mov    %edx,%eax
  8020f1:	01 c0                	add    %eax,%eax
  8020f3:	01 d0                	add    %edx,%eax
  8020f5:	c1 e0 02             	shl    $0x2,%eax
  8020f8:	05 24 41 80 00       	add    $0x804124,%eax
  8020fd:	8b 00                	mov    (%eax),%eax
  8020ff:	83 ec 04             	sub    $0x4,%esp
  802102:	50                   	push   %eax
  802103:	ff 75 b0             	pushl  -0x50(%ebp)
  802106:	68 85 34 80 00       	push   $0x803485
  80210b:	e8 29 ee ff ff       	call   800f39 <cprintf>
  802110:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  802113:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802116:	89 d0                	mov    %edx,%eax
  802118:	01 c0                	add    %eax,%eax
  80211a:	01 d0                	add    %edx,%eax
  80211c:	c1 e0 02             	shl    $0x2,%eax
  80211f:	05 28 41 80 00       	add    $0x804128,%eax
  802124:	8b 00                	mov    (%eax),%eax
  802126:	83 ec 04             	sub    $0x4,%esp
  802129:	50                   	push   %eax
  80212a:	ff 75 b0             	pushl  -0x50(%ebp)
  80212d:	68 98 34 80 00       	push   $0x803498
  802132:	e8 02 ee ff ff       	call   800f39 <cprintf>
  802137:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  80213a:	ff 45 b0             	incl   -0x50(%ebp)
  80213d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802140:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802143:	7c 80                	jl     8020c5 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  802145:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802148:	89 d0                	mov    %edx,%eax
  80214a:	01 c0                	add    %eax,%eax
  80214c:	01 d0                	add    %edx,%eax
  80214e:	c1 e0 02             	shl    $0x2,%eax
  802151:	05 20 41 80 00       	add    $0x804120,%eax
  802156:	8b 00                	mov    (%eax),%eax
  802158:	83 ec 08             	sub    $0x8,%esp
  80215b:	50                   	push   %eax
  80215c:	68 ac 34 80 00       	push   $0x8034ac
  802161:	e8 d3 ed ff ff       	call   800f39 <cprintf>
  802166:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  802169:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80216c:	89 d0                	mov    %edx,%eax
  80216e:	01 c0                	add    %eax,%eax
  802170:	01 d0                	add    %edx,%eax
  802172:	c1 e0 02             	shl    $0x2,%eax
  802175:	05 20 41 80 00       	add    $0x804120,%eax
  80217a:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  80218a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802191:	eb 4b                	jmp    8021de <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  802193:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802196:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  80219d:	89 c2                	mov    %eax,%edx
  80219f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021a2:	39 c2                	cmp    %eax,%edx
  8021a4:	7f 35                	jg     8021db <free+0x5d>
  8021a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a9:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  8021b0:	89 c2                	mov    %eax,%edx
  8021b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021b5:	39 c2                	cmp    %eax,%edx
  8021b7:	7e 22                	jle    8021db <free+0x5d>
				start=arr_add[i].start;
  8021b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bc:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  8021c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8021c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c9:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  8021d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8021d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8021d9:	eb 0d                	jmp    8021e8 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8021db:	ff 45 ec             	incl   -0x14(%ebp)
  8021de:	a1 28 40 80 00       	mov    0x804028,%eax
  8021e3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8021e6:	7c ab                	jl     802193 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8021e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021eb:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  8021f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f5:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  8021fc:	29 c2                	sub    %eax,%edx
  8021fe:	89 d0                	mov    %edx,%eax
  802200:	83 ec 08             	sub    $0x8,%esp
  802203:	50                   	push   %eax
  802204:	ff 75 f4             	pushl  -0xc(%ebp)
  802207:	e8 d9 02 00 00       	call   8024e5 <sys_freeMem>
  80220c:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  80220f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802212:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802215:	eb 2d                	jmp    802244 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  802217:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80221a:	40                   	inc    %eax
  80221b:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  802222:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802225:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  80222c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80222f:	40                   	inc    %eax
  802230:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  802237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80223a:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  802241:	ff 45 e8             	incl   -0x18(%ebp)
  802244:	a1 28 40 80 00       	mov    0x804028,%eax
  802249:	48                   	dec    %eax
  80224a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80224d:	7f c8                	jg     802217 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  80224f:	a1 28 40 80 00       	mov    0x804028,%eax
  802254:	48                   	dec    %eax
  802255:	a3 28 40 80 00       	mov    %eax,0x804028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  80225a:	90                   	nop
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	83 ec 18             	sub    $0x18,%esp
  802263:	8b 45 10             	mov    0x10(%ebp),%eax
  802266:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  802269:	83 ec 04             	sub    $0x4,%esp
  80226c:	68 c8 34 80 00       	push   $0x8034c8
  802271:	68 18 01 00 00       	push   $0x118
  802276:	68 eb 34 80 00       	push   $0x8034eb
  80227b:	e8 17 ea ff ff       	call   800c97 <_panic>

00802280 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802286:	83 ec 04             	sub    $0x4,%esp
  802289:	68 c8 34 80 00       	push   $0x8034c8
  80228e:	68 1e 01 00 00       	push   $0x11e
  802293:	68 eb 34 80 00       	push   $0x8034eb
  802298:	e8 fa e9 ff ff       	call   800c97 <_panic>

0080229d <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
  8022a0:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8022a3:	83 ec 04             	sub    $0x4,%esp
  8022a6:	68 c8 34 80 00       	push   $0x8034c8
  8022ab:	68 24 01 00 00       	push   $0x124
  8022b0:	68 eb 34 80 00       	push   $0x8034eb
  8022b5:	e8 dd e9 ff ff       	call   800c97 <_panic>

008022ba <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8022c0:	83 ec 04             	sub    $0x4,%esp
  8022c3:	68 c8 34 80 00       	push   $0x8034c8
  8022c8:	68 29 01 00 00       	push   $0x129
  8022cd:	68 eb 34 80 00       	push   $0x8034eb
  8022d2:	e8 c0 e9 ff ff       	call   800c97 <_panic>

008022d7 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
  8022da:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8022dd:	83 ec 04             	sub    $0x4,%esp
  8022e0:	68 c8 34 80 00       	push   $0x8034c8
  8022e5:	68 2f 01 00 00       	push   $0x12f
  8022ea:	68 eb 34 80 00       	push   $0x8034eb
  8022ef:	e8 a3 e9 ff ff       	call   800c97 <_panic>

008022f4 <shrink>:
}
void shrink(uint32 newSize)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8022fa:	83 ec 04             	sub    $0x4,%esp
  8022fd:	68 c8 34 80 00       	push   $0x8034c8
  802302:	68 33 01 00 00       	push   $0x133
  802307:	68 eb 34 80 00       	push   $0x8034eb
  80230c:	e8 86 e9 ff ff       	call   800c97 <_panic>

00802311 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802317:	83 ec 04             	sub    $0x4,%esp
  80231a:	68 c8 34 80 00       	push   $0x8034c8
  80231f:	68 38 01 00 00       	push   $0x138
  802324:	68 eb 34 80 00       	push   $0x8034eb
  802329:	e8 69 e9 ff ff       	call   800c97 <_panic>

0080232e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	57                   	push   %edi
  802332:	56                   	push   %esi
  802333:	53                   	push   %ebx
  802334:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802340:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802343:	8b 7d 18             	mov    0x18(%ebp),%edi
  802346:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802349:	cd 30                	int    $0x30
  80234b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80234e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802351:	83 c4 10             	add    $0x10,%esp
  802354:	5b                   	pop    %ebx
  802355:	5e                   	pop    %esi
  802356:	5f                   	pop    %edi
  802357:	5d                   	pop    %ebp
  802358:	c3                   	ret    

00802359 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	83 ec 04             	sub    $0x4,%esp
  80235f:	8b 45 10             	mov    0x10(%ebp),%eax
  802362:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802365:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	52                   	push   %edx
  802371:	ff 75 0c             	pushl  0xc(%ebp)
  802374:	50                   	push   %eax
  802375:	6a 00                	push   $0x0
  802377:	e8 b2 ff ff ff       	call   80232e <syscall>
  80237c:	83 c4 18             	add    $0x18,%esp
}
  80237f:	90                   	nop
  802380:	c9                   	leave  
  802381:	c3                   	ret    

00802382 <sys_cgetc>:

int
sys_cgetc(void)
{
  802382:	55                   	push   %ebp
  802383:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 01                	push   $0x1
  802391:	e8 98 ff ff ff       	call   80232e <syscall>
  802396:	83 c4 18             	add    $0x18,%esp
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	50                   	push   %eax
  8023aa:	6a 05                	push   $0x5
  8023ac:	e8 7d ff ff ff       	call   80232e <syscall>
  8023b1:	83 c4 18             	add    $0x18,%esp
}
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

008023b6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 02                	push   $0x2
  8023c5:	e8 64 ff ff ff       	call   80232e <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 03                	push   $0x3
  8023de:	e8 4b ff ff ff       	call   80232e <syscall>
  8023e3:	83 c4 18             	add    $0x18,%esp
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 04                	push   $0x4
  8023f7:	e8 32 ff ff ff       	call   80232e <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
}
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <sys_env_exit>:


void sys_env_exit(void)
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 06                	push   $0x6
  802410:	e8 19 ff ff ff       	call   80232e <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
}
  802418:	90                   	nop
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80241e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	52                   	push   %edx
  80242b:	50                   	push   %eax
  80242c:	6a 07                	push   $0x7
  80242e:	e8 fb fe ff ff       	call   80232e <syscall>
  802433:	83 c4 18             	add    $0x18,%esp
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	56                   	push   %esi
  80243c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80243d:	8b 75 18             	mov    0x18(%ebp),%esi
  802440:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802443:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802446:	8b 55 0c             	mov    0xc(%ebp),%edx
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	56                   	push   %esi
  80244d:	53                   	push   %ebx
  80244e:	51                   	push   %ecx
  80244f:	52                   	push   %edx
  802450:	50                   	push   %eax
  802451:	6a 08                	push   $0x8
  802453:	e8 d6 fe ff ff       	call   80232e <syscall>
  802458:	83 c4 18             	add    $0x18,%esp
}
  80245b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80245e:	5b                   	pop    %ebx
  80245f:	5e                   	pop    %esi
  802460:	5d                   	pop    %ebp
  802461:	c3                   	ret    

00802462 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802465:	8b 55 0c             	mov    0xc(%ebp),%edx
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	52                   	push   %edx
  802472:	50                   	push   %eax
  802473:	6a 09                	push   $0x9
  802475:	e8 b4 fe ff ff       	call   80232e <syscall>
  80247a:	83 c4 18             	add    $0x18,%esp
}
  80247d:	c9                   	leave  
  80247e:	c3                   	ret    

0080247f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80247f:	55                   	push   %ebp
  802480:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	ff 75 0c             	pushl  0xc(%ebp)
  80248b:	ff 75 08             	pushl  0x8(%ebp)
  80248e:	6a 0a                	push   $0xa
  802490:	e8 99 fe ff ff       	call   80232e <syscall>
  802495:	83 c4 18             	add    $0x18,%esp
}
  802498:	c9                   	leave  
  802499:	c3                   	ret    

0080249a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 0b                	push   $0xb
  8024a9:	e8 80 fe ff ff       	call   80232e <syscall>
  8024ae:	83 c4 18             	add    $0x18,%esp
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 0c                	push   $0xc
  8024c2:	e8 67 fe ff ff       	call   80232e <syscall>
  8024c7:	83 c4 18             	add    $0x18,%esp
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 0d                	push   $0xd
  8024db:	e8 4e fe ff ff       	call   80232e <syscall>
  8024e0:	83 c4 18             	add    $0x18,%esp
}
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    

008024e5 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	ff 75 0c             	pushl  0xc(%ebp)
  8024f1:	ff 75 08             	pushl  0x8(%ebp)
  8024f4:	6a 11                	push   $0x11
  8024f6:	e8 33 fe ff ff       	call   80232e <syscall>
  8024fb:	83 c4 18             	add    $0x18,%esp
	return;
  8024fe:	90                   	nop
}
  8024ff:	c9                   	leave  
  802500:	c3                   	ret    

00802501 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802501:	55                   	push   %ebp
  802502:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	ff 75 0c             	pushl  0xc(%ebp)
  80250d:	ff 75 08             	pushl  0x8(%ebp)
  802510:	6a 12                	push   $0x12
  802512:	e8 17 fe ff ff       	call   80232e <syscall>
  802517:	83 c4 18             	add    $0x18,%esp
	return ;
  80251a:	90                   	nop
}
  80251b:	c9                   	leave  
  80251c:	c3                   	ret    

0080251d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80251d:	55                   	push   %ebp
  80251e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 0e                	push   $0xe
  80252c:	e8 fd fd ff ff       	call   80232e <syscall>
  802531:	83 c4 18             	add    $0x18,%esp
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	ff 75 08             	pushl  0x8(%ebp)
  802544:	6a 0f                	push   $0xf
  802546:	e8 e3 fd ff ff       	call   80232e <syscall>
  80254b:	83 c4 18             	add    $0x18,%esp
}
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 10                	push   $0x10
  80255f:	e8 ca fd ff ff       	call   80232e <syscall>
  802564:	83 c4 18             	add    $0x18,%esp
}
  802567:	90                   	nop
  802568:	c9                   	leave  
  802569:	c3                   	ret    

0080256a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80256a:	55                   	push   %ebp
  80256b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 14                	push   $0x14
  802579:	e8 b0 fd ff ff       	call   80232e <syscall>
  80257e:	83 c4 18             	add    $0x18,%esp
}
  802581:	90                   	nop
  802582:	c9                   	leave  
  802583:	c3                   	ret    

00802584 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	6a 15                	push   $0x15
  802593:	e8 96 fd ff ff       	call   80232e <syscall>
  802598:	83 c4 18             	add    $0x18,%esp
}
  80259b:	90                   	nop
  80259c:	c9                   	leave  
  80259d:	c3                   	ret    

0080259e <sys_cputc>:


void
sys_cputc(const char c)
{
  80259e:	55                   	push   %ebp
  80259f:	89 e5                	mov    %esp,%ebp
  8025a1:	83 ec 04             	sub    $0x4,%esp
  8025a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8025aa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	50                   	push   %eax
  8025b7:	6a 16                	push   $0x16
  8025b9:	e8 70 fd ff ff       	call   80232e <syscall>
  8025be:	83 c4 18             	add    $0x18,%esp
}
  8025c1:	90                   	nop
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 17                	push   $0x17
  8025d3:	e8 56 fd ff ff       	call   80232e <syscall>
  8025d8:	83 c4 18             	add    $0x18,%esp
}
  8025db:	90                   	nop
  8025dc:	c9                   	leave  
  8025dd:	c3                   	ret    

008025de <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8025de:	55                   	push   %ebp
  8025df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	ff 75 0c             	pushl  0xc(%ebp)
  8025ed:	50                   	push   %eax
  8025ee:	6a 18                	push   $0x18
  8025f0:	e8 39 fd ff ff       	call   80232e <syscall>
  8025f5:	83 c4 18             	add    $0x18,%esp
}
  8025f8:	c9                   	leave  
  8025f9:	c3                   	ret    

008025fa <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802600:	8b 45 08             	mov    0x8(%ebp),%eax
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	52                   	push   %edx
  80260a:	50                   	push   %eax
  80260b:	6a 1b                	push   $0x1b
  80260d:	e8 1c fd ff ff       	call   80232e <syscall>
  802612:	83 c4 18             	add    $0x18,%esp
}
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80261a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	52                   	push   %edx
  802627:	50                   	push   %eax
  802628:	6a 19                	push   $0x19
  80262a:	e8 ff fc ff ff       	call   80232e <syscall>
  80262f:	83 c4 18             	add    $0x18,%esp
}
  802632:	90                   	nop
  802633:	c9                   	leave  
  802634:	c3                   	ret    

00802635 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802638:	8b 55 0c             	mov    0xc(%ebp),%edx
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	52                   	push   %edx
  802645:	50                   	push   %eax
  802646:	6a 1a                	push   $0x1a
  802648:	e8 e1 fc ff ff       	call   80232e <syscall>
  80264d:	83 c4 18             	add    $0x18,%esp
}
  802650:	90                   	nop
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
  802656:	83 ec 04             	sub    $0x4,%esp
  802659:	8b 45 10             	mov    0x10(%ebp),%eax
  80265c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80265f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802662:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802666:	8b 45 08             	mov    0x8(%ebp),%eax
  802669:	6a 00                	push   $0x0
  80266b:	51                   	push   %ecx
  80266c:	52                   	push   %edx
  80266d:	ff 75 0c             	pushl  0xc(%ebp)
  802670:	50                   	push   %eax
  802671:	6a 1c                	push   $0x1c
  802673:	e8 b6 fc ff ff       	call   80232e <syscall>
  802678:	83 c4 18             	add    $0x18,%esp
}
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802680:	8b 55 0c             	mov    0xc(%ebp),%edx
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	52                   	push   %edx
  80268d:	50                   	push   %eax
  80268e:	6a 1d                	push   $0x1d
  802690:	e8 99 fc ff ff       	call   80232e <syscall>
  802695:	83 c4 18             	add    $0x18,%esp
}
  802698:	c9                   	leave  
  802699:	c3                   	ret    

0080269a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80269a:	55                   	push   %ebp
  80269b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80269d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	51                   	push   %ecx
  8026ab:	52                   	push   %edx
  8026ac:	50                   	push   %eax
  8026ad:	6a 1e                	push   $0x1e
  8026af:	e8 7a fc ff ff       	call   80232e <syscall>
  8026b4:	83 c4 18             	add    $0x18,%esp
}
  8026b7:	c9                   	leave  
  8026b8:	c3                   	ret    

008026b9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8026b9:	55                   	push   %ebp
  8026ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8026bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	52                   	push   %edx
  8026c9:	50                   	push   %eax
  8026ca:	6a 1f                	push   $0x1f
  8026cc:	e8 5d fc ff ff       	call   80232e <syscall>
  8026d1:	83 c4 18             	add    $0x18,%esp
}
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    

008026d6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8026d6:	55                   	push   %ebp
  8026d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 20                	push   $0x20
  8026e5:	e8 44 fc ff ff       	call   80232e <syscall>
  8026ea:	83 c4 18             	add    $0x18,%esp
}
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	6a 00                	push   $0x0
  8026f7:	ff 75 14             	pushl  0x14(%ebp)
  8026fa:	ff 75 10             	pushl  0x10(%ebp)
  8026fd:	ff 75 0c             	pushl  0xc(%ebp)
  802700:	50                   	push   %eax
  802701:	6a 21                	push   $0x21
  802703:	e8 26 fc ff ff       	call   80232e <syscall>
  802708:	83 c4 18             	add    $0x18,%esp
}
  80270b:	c9                   	leave  
  80270c:	c3                   	ret    

0080270d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802710:	8b 45 08             	mov    0x8(%ebp),%eax
  802713:	6a 00                	push   $0x0
  802715:	6a 00                	push   $0x0
  802717:	6a 00                	push   $0x0
  802719:	6a 00                	push   $0x0
  80271b:	50                   	push   %eax
  80271c:	6a 22                	push   $0x22
  80271e:	e8 0b fc ff ff       	call   80232e <syscall>
  802723:	83 c4 18             	add    $0x18,%esp
}
  802726:	90                   	nop
  802727:	c9                   	leave  
  802728:	c3                   	ret    

00802729 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80272c:	8b 45 08             	mov    0x8(%ebp),%eax
  80272f:	6a 00                	push   $0x0
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	50                   	push   %eax
  802738:	6a 23                	push   $0x23
  80273a:	e8 ef fb ff ff       	call   80232e <syscall>
  80273f:	83 c4 18             	add    $0x18,%esp
}
  802742:	90                   	nop
  802743:	c9                   	leave  
  802744:	c3                   	ret    

00802745 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802745:	55                   	push   %ebp
  802746:	89 e5                	mov    %esp,%ebp
  802748:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80274b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80274e:	8d 50 04             	lea    0x4(%eax),%edx
  802751:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	52                   	push   %edx
  80275b:	50                   	push   %eax
  80275c:	6a 24                	push   $0x24
  80275e:	e8 cb fb ff ff       	call   80232e <syscall>
  802763:	83 c4 18             	add    $0x18,%esp
	return result;
  802766:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802769:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80276c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80276f:	89 01                	mov    %eax,(%ecx)
  802771:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	c9                   	leave  
  802778:	c2 04 00             	ret    $0x4

0080277b <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80277b:	55                   	push   %ebp
  80277c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	ff 75 10             	pushl  0x10(%ebp)
  802785:	ff 75 0c             	pushl  0xc(%ebp)
  802788:	ff 75 08             	pushl  0x8(%ebp)
  80278b:	6a 13                	push   $0x13
  80278d:	e8 9c fb ff ff       	call   80232e <syscall>
  802792:	83 c4 18             	add    $0x18,%esp
	return ;
  802795:	90                   	nop
}
  802796:	c9                   	leave  
  802797:	c3                   	ret    

00802798 <sys_rcr2>:
uint32 sys_rcr2()
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80279b:	6a 00                	push   $0x0
  80279d:	6a 00                	push   $0x0
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 25                	push   $0x25
  8027a7:	e8 82 fb ff ff       	call   80232e <syscall>
  8027ac:	83 c4 18             	add    $0x18,%esp
}
  8027af:	c9                   	leave  
  8027b0:	c3                   	ret    

008027b1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
  8027b4:	83 ec 04             	sub    $0x4,%esp
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027bd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 00                	push   $0x0
  8027c9:	50                   	push   %eax
  8027ca:	6a 26                	push   $0x26
  8027cc:	e8 5d fb ff ff       	call   80232e <syscall>
  8027d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8027d4:	90                   	nop
}
  8027d5:	c9                   	leave  
  8027d6:	c3                   	ret    

008027d7 <rsttst>:
void rsttst()
{
  8027d7:	55                   	push   %ebp
  8027d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8027da:	6a 00                	push   $0x0
  8027dc:	6a 00                	push   $0x0
  8027de:	6a 00                	push   $0x0
  8027e0:	6a 00                	push   $0x0
  8027e2:	6a 00                	push   $0x0
  8027e4:	6a 28                	push   $0x28
  8027e6:	e8 43 fb ff ff       	call   80232e <syscall>
  8027eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8027ee:	90                   	nop
}
  8027ef:	c9                   	leave  
  8027f0:	c3                   	ret    

008027f1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
  8027f4:	83 ec 04             	sub    $0x4,%esp
  8027f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8027fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8027fd:	8b 55 18             	mov    0x18(%ebp),%edx
  802800:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802804:	52                   	push   %edx
  802805:	50                   	push   %eax
  802806:	ff 75 10             	pushl  0x10(%ebp)
  802809:	ff 75 0c             	pushl  0xc(%ebp)
  80280c:	ff 75 08             	pushl  0x8(%ebp)
  80280f:	6a 27                	push   $0x27
  802811:	e8 18 fb ff ff       	call   80232e <syscall>
  802816:	83 c4 18             	add    $0x18,%esp
	return ;
  802819:	90                   	nop
}
  80281a:	c9                   	leave  
  80281b:	c3                   	ret    

0080281c <chktst>:
void chktst(uint32 n)
{
  80281c:	55                   	push   %ebp
  80281d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80281f:	6a 00                	push   $0x0
  802821:	6a 00                	push   $0x0
  802823:	6a 00                	push   $0x0
  802825:	6a 00                	push   $0x0
  802827:	ff 75 08             	pushl  0x8(%ebp)
  80282a:	6a 29                	push   $0x29
  80282c:	e8 fd fa ff ff       	call   80232e <syscall>
  802831:	83 c4 18             	add    $0x18,%esp
	return ;
  802834:	90                   	nop
}
  802835:	c9                   	leave  
  802836:	c3                   	ret    

00802837 <inctst>:

void inctst()
{
  802837:	55                   	push   %ebp
  802838:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80283a:	6a 00                	push   $0x0
  80283c:	6a 00                	push   $0x0
  80283e:	6a 00                	push   $0x0
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	6a 2a                	push   $0x2a
  802846:	e8 e3 fa ff ff       	call   80232e <syscall>
  80284b:	83 c4 18             	add    $0x18,%esp
	return ;
  80284e:	90                   	nop
}
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <gettst>:
uint32 gettst()
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	6a 2b                	push   $0x2b
  802860:	e8 c9 fa ff ff       	call   80232e <syscall>
  802865:	83 c4 18             	add    $0x18,%esp
}
  802868:	c9                   	leave  
  802869:	c3                   	ret    

0080286a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80286a:	55                   	push   %ebp
  80286b:	89 e5                	mov    %esp,%ebp
  80286d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802870:	6a 00                	push   $0x0
  802872:	6a 00                	push   $0x0
  802874:	6a 00                	push   $0x0
  802876:	6a 00                	push   $0x0
  802878:	6a 00                	push   $0x0
  80287a:	6a 2c                	push   $0x2c
  80287c:	e8 ad fa ff ff       	call   80232e <syscall>
  802881:	83 c4 18             	add    $0x18,%esp
  802884:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802887:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80288b:	75 07                	jne    802894 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80288d:	b8 01 00 00 00       	mov    $0x1,%eax
  802892:	eb 05                	jmp    802899 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802894:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802899:	c9                   	leave  
  80289a:	c3                   	ret    

0080289b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80289b:	55                   	push   %ebp
  80289c:	89 e5                	mov    %esp,%ebp
  80289e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028a1:	6a 00                	push   $0x0
  8028a3:	6a 00                	push   $0x0
  8028a5:	6a 00                	push   $0x0
  8028a7:	6a 00                	push   $0x0
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 2c                	push   $0x2c
  8028ad:	e8 7c fa ff ff       	call   80232e <syscall>
  8028b2:	83 c4 18             	add    $0x18,%esp
  8028b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8028b8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8028bc:	75 07                	jne    8028c5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8028be:	b8 01 00 00 00       	mov    $0x1,%eax
  8028c3:	eb 05                	jmp    8028ca <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8028c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ca:	c9                   	leave  
  8028cb:	c3                   	ret    

008028cc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8028cc:	55                   	push   %ebp
  8028cd:	89 e5                	mov    %esp,%ebp
  8028cf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 00                	push   $0x0
  8028dc:	6a 2c                	push   $0x2c
  8028de:	e8 4b fa ff ff       	call   80232e <syscall>
  8028e3:	83 c4 18             	add    $0x18,%esp
  8028e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8028e9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8028ed:	75 07                	jne    8028f6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8028ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f4:	eb 05                	jmp    8028fb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8028f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028fb:	c9                   	leave  
  8028fc:	c3                   	ret    

008028fd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8028fd:	55                   	push   %ebp
  8028fe:	89 e5                	mov    %esp,%ebp
  802900:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802903:	6a 00                	push   $0x0
  802905:	6a 00                	push   $0x0
  802907:	6a 00                	push   $0x0
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 2c                	push   $0x2c
  80290f:	e8 1a fa ff ff       	call   80232e <syscall>
  802914:	83 c4 18             	add    $0x18,%esp
  802917:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80291a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80291e:	75 07                	jne    802927 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802920:	b8 01 00 00 00       	mov    $0x1,%eax
  802925:	eb 05                	jmp    80292c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802927:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80292c:	c9                   	leave  
  80292d:	c3                   	ret    

0080292e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80292e:	55                   	push   %ebp
  80292f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802931:	6a 00                	push   $0x0
  802933:	6a 00                	push   $0x0
  802935:	6a 00                	push   $0x0
  802937:	6a 00                	push   $0x0
  802939:	ff 75 08             	pushl  0x8(%ebp)
  80293c:	6a 2d                	push   $0x2d
  80293e:	e8 eb f9 ff ff       	call   80232e <syscall>
  802943:	83 c4 18             	add    $0x18,%esp
	return ;
  802946:	90                   	nop
}
  802947:	c9                   	leave  
  802948:	c3                   	ret    

00802949 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802949:	55                   	push   %ebp
  80294a:	89 e5                	mov    %esp,%ebp
  80294c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80294d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802950:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802953:	8b 55 0c             	mov    0xc(%ebp),%edx
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	6a 00                	push   $0x0
  80295b:	53                   	push   %ebx
  80295c:	51                   	push   %ecx
  80295d:	52                   	push   %edx
  80295e:	50                   	push   %eax
  80295f:	6a 2e                	push   $0x2e
  802961:	e8 c8 f9 ff ff       	call   80232e <syscall>
  802966:	83 c4 18             	add    $0x18,%esp
}
  802969:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80296c:	c9                   	leave  
  80296d:	c3                   	ret    

0080296e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802971:	8b 55 0c             	mov    0xc(%ebp),%edx
  802974:	8b 45 08             	mov    0x8(%ebp),%eax
  802977:	6a 00                	push   $0x0
  802979:	6a 00                	push   $0x0
  80297b:	6a 00                	push   $0x0
  80297d:	52                   	push   %edx
  80297e:	50                   	push   %eax
  80297f:	6a 2f                	push   $0x2f
  802981:	e8 a8 f9 ff ff       	call   80232e <syscall>
  802986:	83 c4 18             	add    $0x18,%esp
}
  802989:	c9                   	leave  
  80298a:	c3                   	ret    
  80298b:	90                   	nop

0080298c <__udivdi3>:
  80298c:	55                   	push   %ebp
  80298d:	57                   	push   %edi
  80298e:	56                   	push   %esi
  80298f:	53                   	push   %ebx
  802990:	83 ec 1c             	sub    $0x1c,%esp
  802993:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802997:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80299b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80299f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029a3:	89 ca                	mov    %ecx,%edx
  8029a5:	89 f8                	mov    %edi,%eax
  8029a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8029ab:	85 f6                	test   %esi,%esi
  8029ad:	75 2d                	jne    8029dc <__udivdi3+0x50>
  8029af:	39 cf                	cmp    %ecx,%edi
  8029b1:	77 65                	ja     802a18 <__udivdi3+0x8c>
  8029b3:	89 fd                	mov    %edi,%ebp
  8029b5:	85 ff                	test   %edi,%edi
  8029b7:	75 0b                	jne    8029c4 <__udivdi3+0x38>
  8029b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8029be:	31 d2                	xor    %edx,%edx
  8029c0:	f7 f7                	div    %edi
  8029c2:	89 c5                	mov    %eax,%ebp
  8029c4:	31 d2                	xor    %edx,%edx
  8029c6:	89 c8                	mov    %ecx,%eax
  8029c8:	f7 f5                	div    %ebp
  8029ca:	89 c1                	mov    %eax,%ecx
  8029cc:	89 d8                	mov    %ebx,%eax
  8029ce:	f7 f5                	div    %ebp
  8029d0:	89 cf                	mov    %ecx,%edi
  8029d2:	89 fa                	mov    %edi,%edx
  8029d4:	83 c4 1c             	add    $0x1c,%esp
  8029d7:	5b                   	pop    %ebx
  8029d8:	5e                   	pop    %esi
  8029d9:	5f                   	pop    %edi
  8029da:	5d                   	pop    %ebp
  8029db:	c3                   	ret    
  8029dc:	39 ce                	cmp    %ecx,%esi
  8029de:	77 28                	ja     802a08 <__udivdi3+0x7c>
  8029e0:	0f bd fe             	bsr    %esi,%edi
  8029e3:	83 f7 1f             	xor    $0x1f,%edi
  8029e6:	75 40                	jne    802a28 <__udivdi3+0x9c>
  8029e8:	39 ce                	cmp    %ecx,%esi
  8029ea:	72 0a                	jb     8029f6 <__udivdi3+0x6a>
  8029ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8029f0:	0f 87 9e 00 00 00    	ja     802a94 <__udivdi3+0x108>
  8029f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029fb:	89 fa                	mov    %edi,%edx
  8029fd:	83 c4 1c             	add    $0x1c,%esp
  802a00:	5b                   	pop    %ebx
  802a01:	5e                   	pop    %esi
  802a02:	5f                   	pop    %edi
  802a03:	5d                   	pop    %ebp
  802a04:	c3                   	ret    
  802a05:	8d 76 00             	lea    0x0(%esi),%esi
  802a08:	31 ff                	xor    %edi,%edi
  802a0a:	31 c0                	xor    %eax,%eax
  802a0c:	89 fa                	mov    %edi,%edx
  802a0e:	83 c4 1c             	add    $0x1c,%esp
  802a11:	5b                   	pop    %ebx
  802a12:	5e                   	pop    %esi
  802a13:	5f                   	pop    %edi
  802a14:	5d                   	pop    %ebp
  802a15:	c3                   	ret    
  802a16:	66 90                	xchg   %ax,%ax
  802a18:	89 d8                	mov    %ebx,%eax
  802a1a:	f7 f7                	div    %edi
  802a1c:	31 ff                	xor    %edi,%edi
  802a1e:	89 fa                	mov    %edi,%edx
  802a20:	83 c4 1c             	add    $0x1c,%esp
  802a23:	5b                   	pop    %ebx
  802a24:	5e                   	pop    %esi
  802a25:	5f                   	pop    %edi
  802a26:	5d                   	pop    %ebp
  802a27:	c3                   	ret    
  802a28:	bd 20 00 00 00       	mov    $0x20,%ebp
  802a2d:	89 eb                	mov    %ebp,%ebx
  802a2f:	29 fb                	sub    %edi,%ebx
  802a31:	89 f9                	mov    %edi,%ecx
  802a33:	d3 e6                	shl    %cl,%esi
  802a35:	89 c5                	mov    %eax,%ebp
  802a37:	88 d9                	mov    %bl,%cl
  802a39:	d3 ed                	shr    %cl,%ebp
  802a3b:	89 e9                	mov    %ebp,%ecx
  802a3d:	09 f1                	or     %esi,%ecx
  802a3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802a43:	89 f9                	mov    %edi,%ecx
  802a45:	d3 e0                	shl    %cl,%eax
  802a47:	89 c5                	mov    %eax,%ebp
  802a49:	89 d6                	mov    %edx,%esi
  802a4b:	88 d9                	mov    %bl,%cl
  802a4d:	d3 ee                	shr    %cl,%esi
  802a4f:	89 f9                	mov    %edi,%ecx
  802a51:	d3 e2                	shl    %cl,%edx
  802a53:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a57:	88 d9                	mov    %bl,%cl
  802a59:	d3 e8                	shr    %cl,%eax
  802a5b:	09 c2                	or     %eax,%edx
  802a5d:	89 d0                	mov    %edx,%eax
  802a5f:	89 f2                	mov    %esi,%edx
  802a61:	f7 74 24 0c          	divl   0xc(%esp)
  802a65:	89 d6                	mov    %edx,%esi
  802a67:	89 c3                	mov    %eax,%ebx
  802a69:	f7 e5                	mul    %ebp
  802a6b:	39 d6                	cmp    %edx,%esi
  802a6d:	72 19                	jb     802a88 <__udivdi3+0xfc>
  802a6f:	74 0b                	je     802a7c <__udivdi3+0xf0>
  802a71:	89 d8                	mov    %ebx,%eax
  802a73:	31 ff                	xor    %edi,%edi
  802a75:	e9 58 ff ff ff       	jmp    8029d2 <__udivdi3+0x46>
  802a7a:	66 90                	xchg   %ax,%ax
  802a7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a80:	89 f9                	mov    %edi,%ecx
  802a82:	d3 e2                	shl    %cl,%edx
  802a84:	39 c2                	cmp    %eax,%edx
  802a86:	73 e9                	jae    802a71 <__udivdi3+0xe5>
  802a88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a8b:	31 ff                	xor    %edi,%edi
  802a8d:	e9 40 ff ff ff       	jmp    8029d2 <__udivdi3+0x46>
  802a92:	66 90                	xchg   %ax,%ax
  802a94:	31 c0                	xor    %eax,%eax
  802a96:	e9 37 ff ff ff       	jmp    8029d2 <__udivdi3+0x46>
  802a9b:	90                   	nop

00802a9c <__umoddi3>:
  802a9c:	55                   	push   %ebp
  802a9d:	57                   	push   %edi
  802a9e:	56                   	push   %esi
  802a9f:	53                   	push   %ebx
  802aa0:	83 ec 1c             	sub    $0x1c,%esp
  802aa3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802aa7:	8b 74 24 34          	mov    0x34(%esp),%esi
  802aab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802aaf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802ab3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ab7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802abb:	89 f3                	mov    %esi,%ebx
  802abd:	89 fa                	mov    %edi,%edx
  802abf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ac3:	89 34 24             	mov    %esi,(%esp)
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	75 1a                	jne    802ae4 <__umoddi3+0x48>
  802aca:	39 f7                	cmp    %esi,%edi
  802acc:	0f 86 a2 00 00 00    	jbe    802b74 <__umoddi3+0xd8>
  802ad2:	89 c8                	mov    %ecx,%eax
  802ad4:	89 f2                	mov    %esi,%edx
  802ad6:	f7 f7                	div    %edi
  802ad8:	89 d0                	mov    %edx,%eax
  802ada:	31 d2                	xor    %edx,%edx
  802adc:	83 c4 1c             	add    $0x1c,%esp
  802adf:	5b                   	pop    %ebx
  802ae0:	5e                   	pop    %esi
  802ae1:	5f                   	pop    %edi
  802ae2:	5d                   	pop    %ebp
  802ae3:	c3                   	ret    
  802ae4:	39 f0                	cmp    %esi,%eax
  802ae6:	0f 87 ac 00 00 00    	ja     802b98 <__umoddi3+0xfc>
  802aec:	0f bd e8             	bsr    %eax,%ebp
  802aef:	83 f5 1f             	xor    $0x1f,%ebp
  802af2:	0f 84 ac 00 00 00    	je     802ba4 <__umoddi3+0x108>
  802af8:	bf 20 00 00 00       	mov    $0x20,%edi
  802afd:	29 ef                	sub    %ebp,%edi
  802aff:	89 fe                	mov    %edi,%esi
  802b01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b05:	89 e9                	mov    %ebp,%ecx
  802b07:	d3 e0                	shl    %cl,%eax
  802b09:	89 d7                	mov    %edx,%edi
  802b0b:	89 f1                	mov    %esi,%ecx
  802b0d:	d3 ef                	shr    %cl,%edi
  802b0f:	09 c7                	or     %eax,%edi
  802b11:	89 e9                	mov    %ebp,%ecx
  802b13:	d3 e2                	shl    %cl,%edx
  802b15:	89 14 24             	mov    %edx,(%esp)
  802b18:	89 d8                	mov    %ebx,%eax
  802b1a:	d3 e0                	shl    %cl,%eax
  802b1c:	89 c2                	mov    %eax,%edx
  802b1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b22:	d3 e0                	shl    %cl,%eax
  802b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b28:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b2c:	89 f1                	mov    %esi,%ecx
  802b2e:	d3 e8                	shr    %cl,%eax
  802b30:	09 d0                	or     %edx,%eax
  802b32:	d3 eb                	shr    %cl,%ebx
  802b34:	89 da                	mov    %ebx,%edx
  802b36:	f7 f7                	div    %edi
  802b38:	89 d3                	mov    %edx,%ebx
  802b3a:	f7 24 24             	mull   (%esp)
  802b3d:	89 c6                	mov    %eax,%esi
  802b3f:	89 d1                	mov    %edx,%ecx
  802b41:	39 d3                	cmp    %edx,%ebx
  802b43:	0f 82 87 00 00 00    	jb     802bd0 <__umoddi3+0x134>
  802b49:	0f 84 91 00 00 00    	je     802be0 <__umoddi3+0x144>
  802b4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b53:	29 f2                	sub    %esi,%edx
  802b55:	19 cb                	sbb    %ecx,%ebx
  802b57:	89 d8                	mov    %ebx,%eax
  802b59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802b5d:	d3 e0                	shl    %cl,%eax
  802b5f:	89 e9                	mov    %ebp,%ecx
  802b61:	d3 ea                	shr    %cl,%edx
  802b63:	09 d0                	or     %edx,%eax
  802b65:	89 e9                	mov    %ebp,%ecx
  802b67:	d3 eb                	shr    %cl,%ebx
  802b69:	89 da                	mov    %ebx,%edx
  802b6b:	83 c4 1c             	add    $0x1c,%esp
  802b6e:	5b                   	pop    %ebx
  802b6f:	5e                   	pop    %esi
  802b70:	5f                   	pop    %edi
  802b71:	5d                   	pop    %ebp
  802b72:	c3                   	ret    
  802b73:	90                   	nop
  802b74:	89 fd                	mov    %edi,%ebp
  802b76:	85 ff                	test   %edi,%edi
  802b78:	75 0b                	jne    802b85 <__umoddi3+0xe9>
  802b7a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b7f:	31 d2                	xor    %edx,%edx
  802b81:	f7 f7                	div    %edi
  802b83:	89 c5                	mov    %eax,%ebp
  802b85:	89 f0                	mov    %esi,%eax
  802b87:	31 d2                	xor    %edx,%edx
  802b89:	f7 f5                	div    %ebp
  802b8b:	89 c8                	mov    %ecx,%eax
  802b8d:	f7 f5                	div    %ebp
  802b8f:	89 d0                	mov    %edx,%eax
  802b91:	e9 44 ff ff ff       	jmp    802ada <__umoddi3+0x3e>
  802b96:	66 90                	xchg   %ax,%ax
  802b98:	89 c8                	mov    %ecx,%eax
  802b9a:	89 f2                	mov    %esi,%edx
  802b9c:	83 c4 1c             	add    $0x1c,%esp
  802b9f:	5b                   	pop    %ebx
  802ba0:	5e                   	pop    %esi
  802ba1:	5f                   	pop    %edi
  802ba2:	5d                   	pop    %ebp
  802ba3:	c3                   	ret    
  802ba4:	3b 04 24             	cmp    (%esp),%eax
  802ba7:	72 06                	jb     802baf <__umoddi3+0x113>
  802ba9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802bad:	77 0f                	ja     802bbe <__umoddi3+0x122>
  802baf:	89 f2                	mov    %esi,%edx
  802bb1:	29 f9                	sub    %edi,%ecx
  802bb3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802bb7:	89 14 24             	mov    %edx,(%esp)
  802bba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802bbe:	8b 44 24 04          	mov    0x4(%esp),%eax
  802bc2:	8b 14 24             	mov    (%esp),%edx
  802bc5:	83 c4 1c             	add    $0x1c,%esp
  802bc8:	5b                   	pop    %ebx
  802bc9:	5e                   	pop    %esi
  802bca:	5f                   	pop    %edi
  802bcb:	5d                   	pop    %ebp
  802bcc:	c3                   	ret    
  802bcd:	8d 76 00             	lea    0x0(%esi),%esi
  802bd0:	2b 04 24             	sub    (%esp),%eax
  802bd3:	19 fa                	sbb    %edi,%edx
  802bd5:	89 d1                	mov    %edx,%ecx
  802bd7:	89 c6                	mov    %eax,%esi
  802bd9:	e9 71 ff ff ff       	jmp    802b4f <__umoddi3+0xb3>
  802bde:	66 90                	xchg   %ax,%ax
  802be0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802be4:	72 ea                	jb     802bd0 <__umoddi3+0x134>
  802be6:	89 d9                	mov    %ebx,%ecx
  802be8:	e9 62 ff ff ff       	jmp    802b4f <__umoddi3+0xb3>
