
obj/user/tst_realloc_3:     file format elf32-i386


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
  800031:	e8 29 06 00 00       	call   80065f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 40             	sub    $0x40,%esp
	int Mega = 1024*1024;
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[5] = {0};
  80004e:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800051:	b9 05 00 00 00       	mov    $0x5,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 00 27 80 00       	push   $0x802700
  800067:	e8 da 09 00 00       	call   800a46 <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 100 KB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 33 1f 00 00       	call   801fa7 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 ae 1f 00 00       	call   80202a <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(100*kilo - kilo);
  80007f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800082:	89 d0                	mov    %edx,%eax
  800084:	01 c0                	add    %eax,%eax
  800086:	01 d0                	add    %edx,%eax
  800088:	89 c2                	mov    %eax,%edx
  80008a:	c1 e2 05             	shl    $0x5,%edx
  80008d:	01 d0                	add    %edx,%eax
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	e8 38 17 00 00       	call   8017d0 <malloc>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8000a1:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a6:	74 14                	je     8000bc <_main+0x84>
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 24 27 80 00       	push   $0x802724
  8000b0:	6a 11                	push   $0x11
  8000b2:	68 54 27 80 00       	push   $0x802754
  8000b7:	e8 e8 06 00 00       	call   8007a4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000bf:	e8 e3 1e 00 00       	call   801fa7 <sys_calculate_free_frames>
  8000c4:	29 c3                	sub    %eax,%ebx
  8000c6:	89 d8                	mov    %ebx,%eax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	74 14                	je     8000e1 <_main+0xa9>
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 6c 27 80 00       	push   $0x80276c
  8000d5:	6a 13                	push   $0x13
  8000d7:	68 54 27 80 00       	push   $0x802754
  8000dc:	e8 c3 06 00 00       	call   8007a4 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are allocated in PageFile");
  8000e1:	e8 44 1f 00 00       	call   80202a <sys_pf_calculate_allocated_pages>
  8000e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000e9:	83 f8 19             	cmp    $0x19,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 d8 27 80 00       	push   $0x8027d8
  8000f6:	6a 14                	push   $0x14
  8000f8:	68 54 27 80 00       	push   $0x802754
  8000fd:	e8 a2 06 00 00       	call   8007a4 <_panic>

		//Allocate 20 KB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 a0 1e 00 00       	call   801fa7 <sys_calculate_free_frames>
  800107:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 1b 1f 00 00       	call   80202a <sys_pf_calculate_allocated_pages>
  80010f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(20*kilo-kilo);
  800112:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800115:	89 d0                	mov    %edx,%eax
  800117:	c1 e0 03             	shl    $0x3,%eax
  80011a:	01 d0                	add    %edx,%eax
  80011c:	01 c0                	add    %eax,%eax
  80011e:	01 d0                	add    %edx,%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 a7 16 00 00       	call   8017d0 <malloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 100 * kilo)) panic("Wrong start address for the allocated space... ");
  80012f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800132:	89 c1                	mov    %eax,%ecx
  800134:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800137:	89 d0                	mov    %edx,%eax
  800139:	c1 e0 02             	shl    $0x2,%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800145:	01 d0                	add    %edx,%eax
  800147:	c1 e0 02             	shl    $0x2,%eax
  80014a:	05 00 00 00 80       	add    $0x80000000,%eax
  80014f:	39 c1                	cmp    %eax,%ecx
  800151:	74 14                	je     800167 <_main+0x12f>
  800153:	83 ec 04             	sub    $0x4,%esp
  800156:	68 24 27 80 00       	push   $0x802724
  80015b:	6a 1a                	push   $0x1a
  80015d:	68 54 27 80 00       	push   $0x802754
  800162:	e8 3d 06 00 00       	call   8007a4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800167:	e8 3b 1e 00 00       	call   801fa7 <sys_calculate_free_frames>
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 6c 27 80 00       	push   $0x80276c
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 54 27 80 00       	push   $0x802754
  800184:	e8 1b 06 00 00       	call   8007a4 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 5) panic("Extra or less pages are allocated in PageFile");
  800189:	e8 9c 1e 00 00       	call   80202a <sys_pf_calculate_allocated_pages>
  80018e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800191:	83 f8 05             	cmp    $0x5,%eax
  800194:	74 14                	je     8001aa <_main+0x172>
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	68 d8 27 80 00       	push   $0x8027d8
  80019e:	6a 1d                	push   $0x1d
  8001a0:	68 54 27 80 00       	push   $0x802754
  8001a5:	e8 fa 05 00 00       	call   8007a4 <_panic>

		//Allocate 30 KB
		freeFrames = sys_calculate_free_frames() ;
  8001aa:	e8 f8 1d 00 00       	call   801fa7 <sys_calculate_free_frames>
  8001af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b2:	e8 73 1e 00 00       	call   80202a <sys_pf_calculate_allocated_pages>
  8001b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(30 * kilo -kilo);
  8001ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001bd:	89 d0                	mov    %edx,%eax
  8001bf:	01 c0                	add    %eax,%eax
  8001c1:	01 d0                	add    %edx,%eax
  8001c3:	01 c0                	add    %eax,%eax
  8001c5:	01 d0                	add    %edx,%eax
  8001c7:	c1 e0 02             	shl    $0x2,%eax
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	e8 fb 15 00 00       	call   8017d0 <malloc>
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 120 * kilo)) panic("Wrong start address for the allocated space... ");
  8001db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001de:	89 c1                	mov    %eax,%ecx
  8001e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001e3:	89 d0                	mov    %edx,%eax
  8001e5:	01 c0                	add    %eax,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f0:	01 d0                	add    %edx,%eax
  8001f2:	c1 e0 03             	shl    $0x3,%eax
  8001f5:	05 00 00 00 80       	add    $0x80000000,%eax
  8001fa:	39 c1                	cmp    %eax,%ecx
  8001fc:	74 14                	je     800212 <_main+0x1da>
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	68 24 27 80 00       	push   $0x802724
  800206:	6a 23                	push   $0x23
  800208:	68 54 27 80 00       	push   $0x802754
  80020d:	e8 92 05 00 00       	call   8007a4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800212:	e8 90 1d 00 00       	call   801fa7 <sys_calculate_free_frames>
  800217:	89 c2                	mov    %eax,%edx
  800219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 6c 27 80 00       	push   $0x80276c
  800228:	6a 25                	push   $0x25
  80022a:	68 54 27 80 00       	push   $0x802754
  80022f:	e8 70 05 00 00       	call   8007a4 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8) panic("Extra or less pages are allocated in PageFile");
  800234:	e8 f1 1d 00 00       	call   80202a <sys_pf_calculate_allocated_pages>
  800239:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023c:	83 f8 08             	cmp    $0x8,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 d8 27 80 00       	push   $0x8027d8
  800249:	6a 26                	push   $0x26
  80024b:	68 54 27 80 00       	push   $0x802754
  800250:	e8 4f 05 00 00       	call   8007a4 <_panic>

		//Allocate 40 KB
		freeFrames = sys_calculate_free_frames() ;
  800255:	e8 4d 1d 00 00       	call   801fa7 <sys_calculate_free_frames>
  80025a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025d:	e8 c8 1d 00 00       	call   80202a <sys_pf_calculate_allocated_pages>
  800262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(40 * kilo -kilo);
  800265:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800268:	89 d0                	mov    %edx,%eax
  80026a:	c1 e0 03             	shl    $0x3,%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	01 c0                	add    %eax,%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	01 c0                	add    %eax,%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	50                   	push   %eax
  80027b:	e8 50 15 00 00       	call   8017d0 <malloc>
  800280:	83 c4 10             	add    $0x10,%esp
  800283:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 152 * kilo)) panic("Wrong start address for the allocated space... ");
  800286:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800289:	89 c1                	mov    %eax,%ecx
  80028b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80028e:	89 d0                	mov    %edx,%eax
  800290:	c1 e0 03             	shl    $0x3,%eax
  800293:	01 d0                	add    %edx,%eax
  800295:	01 c0                	add    %eax,%eax
  800297:	01 d0                	add    %edx,%eax
  800299:	c1 e0 03             	shl    $0x3,%eax
  80029c:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a1:	39 c1                	cmp    %eax,%ecx
  8002a3:	74 14                	je     8002b9 <_main+0x281>
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	68 24 27 80 00       	push   $0x802724
  8002ad:	6a 2c                	push   $0x2c
  8002af:	68 54 27 80 00       	push   $0x802754
  8002b4:	e8 eb 04 00 00       	call   8007a4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002b9:	e8 e9 1c 00 00       	call   801fa7 <sys_calculate_free_frames>
  8002be:	89 c2                	mov    %eax,%edx
  8002c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 6c 27 80 00       	push   $0x80276c
  8002cf:	6a 2e                	push   $0x2e
  8002d1:	68 54 27 80 00       	push   $0x802754
  8002d6:	e8 c9 04 00 00       	call   8007a4 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 10) panic("Extra or less pages are allocated in PageFile");
  8002db:	e8 4a 1d 00 00       	call   80202a <sys_pf_calculate_allocated_pages>
  8002e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002e3:	83 f8 0a             	cmp    $0xa,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 d8 27 80 00       	push   $0x8027d8
  8002f0:	6a 2f                	push   $0x2f
  8002f2:	68 54 27 80 00       	push   $0x802754
  8002f7:	e8 a8 04 00 00       	call   8007a4 <_panic>


	}


	int cnt = 0;
  8002fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	//[2] Test Re-allocation
	{
		/*Reallocate the first array (100 KB) to the last hole*/

		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
  800303:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800306:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  800309:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80030c:	89 d0                	mov    %edx,%eax
  80030e:	c1 e0 02             	shl    $0x2,%eax
  800311:	01 d0                	add    %edx,%eax
  800313:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031a:	01 d0                	add    %edx,%eax
  80031c:	c1 e0 02             	shl    $0x2,%eax
  80031f:	c1 e8 02             	shr    $0x2,%eax
  800322:	48                   	dec    %eax
  800323:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int i = 0;
  800326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for (i=0; i < lastIndexOfInt1 ; i++)
  80032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800334:	eb 17                	jmp    80034d <_main+0x315>
		{
			intArr[i] = i ;
  800336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800340:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800343:	01 c2                	add    %eax,%edx
  800345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800348:	89 02                	mov    %eax,(%edx)
		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		int i = 0;
		for (i=0; i < lastIndexOfInt1 ; i++)
  80034a:	ff 45 f4             	incl   -0xc(%ebp)
  80034d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800350:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800353:	7c e1                	jl     800336 <_main+0x2fe>
		{
			intArr[i] = i ;
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  800355:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800358:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  80035b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80035e:	89 d0                	mov    %edx,%eax
  800360:	c1 e0 02             	shl    $0x2,%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	c1 e0 02             	shl    $0x2,%eax
  800368:	c1 e8 02             	shr    $0x2,%eax
  80036b:	48                   	dec    %eax
  80036c:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  80036f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800376:	eb 17                	jmp    80038f <_main+0x357>
		{
			intArr[i] = i ;
  800378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800382:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800385:	01 c2                	add    %eax,%edx
  800387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038a:	89 02                	mov    %eax,(%edx)

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80038c:	ff 45 f4             	incl   -0xc(%ebp)
  80038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800392:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800395:	7c e1                	jl     800378 <_main+0x340>
		{
			intArr[i] = i ;
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800397:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80039a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80039d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003a0:	89 d0                	mov    %edx,%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ad:	01 d0                	add    %edx,%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	c1 e8 02             	shr    $0x2,%eax
  8003b4:	48                   	dec    %eax
  8003b5:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003bf:	eb 17                	jmp    8003d8 <_main+0x3a0>
		{
			intArr[i] = i ;
  8003c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003d5:	ff 45 f4             	incl   -0xc(%ebp)
  8003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003db:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003de:	7c e1                	jl     8003c1 <_main+0x389>
		{
			intArr[i] = i ;
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8003e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8003e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003e9:	89 d0                	mov    %edx,%eax
  8003eb:	c1 e0 02             	shl    $0x2,%eax
  8003ee:	01 d0                	add    %edx,%eax
  8003f0:	c1 e0 03             	shl    $0x3,%eax
  8003f3:	c1 e8 02             	shr    $0x2,%eax
  8003f6:	48                   	dec    %eax
  8003f7:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800401:	eb 17                	jmp    80041a <_main+0x3e2>
		{
			intArr[i] = i ;
  800403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800406:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800410:	01 c2                	add    %eax,%edx
  800412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800415:	89 02                	mov    %eax,(%edx)

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800417:	ff 45 f4             	incl   -0xc(%ebp)
  80041a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800420:	7c e1                	jl     800403 <_main+0x3cb>
			intArr[i] = i ;
		}


		//Reallocate the first array to 200 KB [should be moved to after the fourth one]
		freeFrames = sys_calculate_free_frames() ;
  800422:	e8 80 1b 00 00       	call   801fa7 <sys_calculate_free_frames>
  800427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042a:	e8 fb 1b 00 00       	call   80202a <sys_pf_calculate_allocated_pages>
  80042f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 200 * kilo - kilo);
  800432:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800435:	89 d0                	mov    %edx,%eax
  800437:	01 c0                	add    %eax,%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	89 c1                	mov    %eax,%ecx
  80043d:	c1 e1 05             	shl    $0x5,%ecx
  800440:	01 c8                	add    %ecx,%eax
  800442:	01 c0                	add    %eax,%eax
  800444:	01 d0                	add    %edx,%eax
  800446:	89 c2                	mov    %eax,%edx
  800448:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	52                   	push   %edx
  80044f:	50                   	push   %eax
  800450:	e8 72 19 00 00       	call   801dc7 <realloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 192 * kilo)) panic("Wrong start address for the re-allocated space... ");
  80045b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	c1 e0 06             	shl    $0x6,%eax
  80046c:	05 00 00 00 80       	add    $0x80000000,%eax
  800471:	39 c1                	cmp    %eax,%ecx
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 08 28 80 00       	push   $0x802808
  80047d:	6a 6b                	push   $0x6b
  80047f:	68 54 27 80 00       	push   $0x802754
  800484:	e8 1b 03 00 00       	call   8007a4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		//if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are re-allocated in PageFile");
  800489:	e8 9c 1b 00 00       	call   80202a <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 19             	cmp    $0x19,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 3c 28 80 00       	push   $0x80283c
  80049e:	6a 6e                	push   $0x6e
  8004a0:	68 54 27 80 00       	push   $0x802754
  8004a5:	e8 fa 02 00 00       	call   8007a4 <_panic>


		vcprintf("\b\b\b50%", NULL);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	6a 00                	push   $0x0
  8004af:	68 6d 28 80 00       	push   $0x80286d
  8004b4:	e8 22 05 00 00       	call   8009db <vcprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
  8004bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  8004c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004c5:	89 d0                	mov    %edx,%eax
  8004c7:	c1 e0 02             	shl    $0x2,%eax
  8004ca:	01 d0                	add    %edx,%eax
  8004cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 02             	shl    $0x2,%eax
  8004d8:	c1 e8 02             	shr    $0x2,%eax
  8004db:	48                   	dec    %eax
  8004dc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8004df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004e6:	eb 2d                	jmp    800515 <_main+0x4dd>
		{
			if(intArr[i] != i)
  8004e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004f5:	01 d0                	add    %edx,%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004fc:	74 14                	je     800512 <_main+0x4da>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 74 28 80 00       	push   $0x802874
  800506:	6a 7a                	push   $0x7a
  800508:	68 54 27 80 00       	push   $0x802754
  80050d:	e8 92 02 00 00       	call   8007a4 <_panic>

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800512:	ff 45 f4             	incl   -0xc(%ebp)
  800515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800518:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80051b:	7c cb                	jl     8004e8 <_main+0x4b0>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  80051d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800520:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  800523:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 02             	shl    $0x2,%eax
  800530:	c1 e8 02             	shr    $0x2,%eax
  800533:	48                   	dec    %eax
  800534:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800537:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80053e:	eb 30                	jmp    800570 <_main+0x538>
		{
			if(intArr[i] != i)
  800540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800543:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054d:	01 d0                	add    %edx,%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800554:	74 17                	je     80056d <_main+0x535>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 74 28 80 00       	push   $0x802874
  80055e:	68 84 00 00 00       	push   $0x84
  800563:	68 54 27 80 00       	push   $0x802754
  800568:	e8 37 02 00 00       	call   8007a4 <_panic>

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80056d:	ff 45 f4             	incl   -0xc(%ebp)
  800570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800573:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800576:	7c c8                	jl     800540 <_main+0x508>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800578:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80057e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800581:	89 d0                	mov    %edx,%eax
  800583:	01 c0                	add    %eax,%eax
  800585:	01 d0                	add    %edx,%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	01 d0                	add    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	c1 e8 02             	shr    $0x2,%eax
  800595:	48                   	dec    %eax
  800596:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005a0:	eb 30                	jmp    8005d2 <_main+0x59a>
		{
			if(intArr[i] != i)
  8005a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005b6:	74 17                	je     8005cf <_main+0x597>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 74 28 80 00       	push   $0x802874
  8005c0:	68 8e 00 00 00       	push   $0x8e
  8005c5:	68 54 27 80 00       	push   $0x802754
  8005ca:	e8 d5 01 00 00       	call   8007a4 <_panic>

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005cf:	ff 45 f4             	incl   -0xc(%ebp)
  8005d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8005d8:	7c c8                	jl     8005a2 <_main+0x56a>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8005da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8005e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	c1 e0 03             	shl    $0x3,%eax
  8005ed:	c1 e8 02             	shr    $0x2,%eax
  8005f0:	48                   	dec    %eax
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005fb:	eb 30                	jmp    80062d <_main+0x5f5>
		{
			if(intArr[i] != i)
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800600:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800611:	74 17                	je     80062a <_main+0x5f2>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	68 74 28 80 00       	push   $0x802874
  80061b:	68 98 00 00 00       	push   $0x98
  800620:	68 54 27 80 00       	push   $0x802754
  800625:	e8 7a 01 00 00       	call   8007a4 <_panic>

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80062a:	ff 45 f4             	incl   -0xc(%ebp)
  80062d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800630:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800633:	7c c8                	jl     8005fd <_main+0x5c5>
				panic("Wrong re-allocation: stored values are wrongly changed!");

		}


		vcprintf("\b\b\b100%\n", NULL);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	6a 00                	push   $0x0
  80063a:	68 ac 28 80 00       	push   $0x8028ac
  80063f:	e8 97 03 00 00       	call   8009db <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [3] completed successfully.\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 b8 28 80 00       	push   $0x8028b8
  80064f:	e8 f2 03 00 00       	call   800a46 <cprintf>
  800654:	83 c4 10             	add    $0x10,%esp

	return;
  800657:	90                   	nop
}
  800658:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80065b:	5b                   	pop    %ebx
  80065c:	5f                   	pop    %edi
  80065d:	5d                   	pop    %ebp
  80065e:	c3                   	ret    

0080065f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800665:	e8 72 18 00 00       	call   801edc <sys_getenvindex>
  80066a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80066d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	c1 e0 03             	shl    $0x3,%eax
  800675:	01 d0                	add    %edx,%eax
  800677:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80067e:	01 c8                	add    %ecx,%eax
  800680:	01 c0                	add    %eax,%eax
  800682:	01 d0                	add    %edx,%eax
  800684:	01 c0                	add    %eax,%eax
  800686:	01 d0                	add    %edx,%eax
  800688:	89 c2                	mov    %eax,%edx
  80068a:	c1 e2 05             	shl    $0x5,%edx
  80068d:	29 c2                	sub    %eax,%edx
  80068f:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800696:	89 c2                	mov    %eax,%edx
  800698:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80069e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a8:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8006ae:	84 c0                	test   %al,%al
  8006b0:	74 0f                	je     8006c1 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8006b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8006b7:	05 40 3c 01 00       	add    $0x13c40,%eax
  8006bc:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006c5:	7e 0a                	jle    8006d1 <libmain+0x72>
		binaryname = argv[0];
  8006c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	ff 75 0c             	pushl  0xc(%ebp)
  8006d7:	ff 75 08             	pushl  0x8(%ebp)
  8006da:	e8 59 f9 ff ff       	call   800038 <_main>
  8006df:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006e2:	e8 90 19 00 00       	call   802077 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	68 0c 29 80 00       	push   $0x80290c
  8006ef:	e8 52 03 00 00       	call   800a46 <cprintf>
  8006f4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006f7:	a1 20 30 80 00       	mov    0x803020,%eax
  8006fc:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800702:	a1 20 30 80 00       	mov    0x803020,%eax
  800707:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80070d:	83 ec 04             	sub    $0x4,%esp
  800710:	52                   	push   %edx
  800711:	50                   	push   %eax
  800712:	68 34 29 80 00       	push   $0x802934
  800717:	e8 2a 03 00 00       	call   800a46 <cprintf>
  80071c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80071f:	a1 20 30 80 00       	mov    0x803020,%eax
  800724:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80072a:	a1 20 30 80 00       	mov    0x803020,%eax
  80072f:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800735:	83 ec 04             	sub    $0x4,%esp
  800738:	52                   	push   %edx
  800739:	50                   	push   %eax
  80073a:	68 5c 29 80 00       	push   $0x80295c
  80073f:	e8 02 03 00 00       	call   800a46 <cprintf>
  800744:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800747:	a1 20 30 80 00       	mov    0x803020,%eax
  80074c:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	50                   	push   %eax
  800756:	68 9d 29 80 00       	push   $0x80299d
  80075b:	e8 e6 02 00 00       	call   800a46 <cprintf>
  800760:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	68 0c 29 80 00       	push   $0x80290c
  80076b:	e8 d6 02 00 00       	call   800a46 <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800773:	e8 19 19 00 00       	call   802091 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800778:	e8 19 00 00 00       	call   800796 <exit>
}
  80077d:	90                   	nop
  80077e:	c9                   	leave  
  80077f:	c3                   	ret    

00800780 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800786:	83 ec 0c             	sub    $0xc,%esp
  800789:	6a 00                	push   $0x0
  80078b:	e8 18 17 00 00       	call   801ea8 <sys_env_destroy>
  800790:	83 c4 10             	add    $0x10,%esp
}
  800793:	90                   	nop
  800794:	c9                   	leave  
  800795:	c3                   	ret    

00800796 <exit>:

void
exit(void)
{
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
  800799:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80079c:	e8 6d 17 00 00       	call   801f0e <sys_env_exit>
}
  8007a1:	90                   	nop
  8007a2:	c9                   	leave  
  8007a3:	c3                   	ret    

008007a4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007aa:	8d 45 10             	lea    0x10(%ebp),%eax
  8007ad:	83 c0 04             	add    $0x4,%eax
  8007b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007b3:	a1 18 31 80 00       	mov    0x803118,%eax
  8007b8:	85 c0                	test   %eax,%eax
  8007ba:	74 16                	je     8007d2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007bc:	a1 18 31 80 00       	mov    0x803118,%eax
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	50                   	push   %eax
  8007c5:	68 b4 29 80 00       	push   $0x8029b4
  8007ca:	e8 77 02 00 00       	call   800a46 <cprintf>
  8007cf:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007d2:	a1 00 30 80 00       	mov    0x803000,%eax
  8007d7:	ff 75 0c             	pushl  0xc(%ebp)
  8007da:	ff 75 08             	pushl  0x8(%ebp)
  8007dd:	50                   	push   %eax
  8007de:	68 b9 29 80 00       	push   $0x8029b9
  8007e3:	e8 5e 02 00 00       	call   800a46 <cprintf>
  8007e8:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f4:	50                   	push   %eax
  8007f5:	e8 e1 01 00 00       	call   8009db <vcprintf>
  8007fa:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	6a 00                	push   $0x0
  800802:	68 d5 29 80 00       	push   $0x8029d5
  800807:	e8 cf 01 00 00       	call   8009db <vcprintf>
  80080c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80080f:	e8 82 ff ff ff       	call   800796 <exit>

	// should not return here
	while (1) ;
  800814:	eb fe                	jmp    800814 <_panic+0x70>

00800816 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80081c:	a1 20 30 80 00       	mov    0x803020,%eax
  800821:	8b 50 74             	mov    0x74(%eax),%edx
  800824:	8b 45 0c             	mov    0xc(%ebp),%eax
  800827:	39 c2                	cmp    %eax,%edx
  800829:	74 14                	je     80083f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	68 d8 29 80 00       	push   $0x8029d8
  800833:	6a 26                	push   $0x26
  800835:	68 24 2a 80 00       	push   $0x802a24
  80083a:	e8 65 ff ff ff       	call   8007a4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80083f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800846:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80084d:	e9 b6 00 00 00       	jmp    800908 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800855:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	01 d0                	add    %edx,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	85 c0                	test   %eax,%eax
  800865:	75 08                	jne    80086f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800867:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80086a:	e9 96 00 00 00       	jmp    800905 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80086f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800876:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80087d:	eb 5d                	jmp    8008dc <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80087f:	a1 20 30 80 00       	mov    0x803020,%eax
  800884:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80088a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80088d:	c1 e2 04             	shl    $0x4,%edx
  800890:	01 d0                	add    %edx,%eax
  800892:	8a 40 04             	mov    0x4(%eax),%al
  800895:	84 c0                	test   %al,%al
  800897:	75 40                	jne    8008d9 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800899:	a1 20 30 80 00       	mov    0x803020,%eax
  80089e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8008a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a7:	c1 e2 04             	shl    $0x4,%edx
  8008aa:	01 d0                	add    %edx,%eax
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008b9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008be:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	01 c8                	add    %ecx,%eax
  8008ca:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008cc:	39 c2                	cmp    %eax,%edx
  8008ce:	75 09                	jne    8008d9 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8008d0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008d7:	eb 12                	jmp    8008eb <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d9:	ff 45 e8             	incl   -0x18(%ebp)
  8008dc:	a1 20 30 80 00       	mov    0x803020,%eax
  8008e1:	8b 50 74             	mov    0x74(%eax),%edx
  8008e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e7:	39 c2                	cmp    %eax,%edx
  8008e9:	77 94                	ja     80087f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008ef:	75 14                	jne    800905 <CheckWSWithoutLastIndex+0xef>
			panic(
  8008f1:	83 ec 04             	sub    $0x4,%esp
  8008f4:	68 30 2a 80 00       	push   $0x802a30
  8008f9:	6a 3a                	push   $0x3a
  8008fb:	68 24 2a 80 00       	push   $0x802a24
  800900:	e8 9f fe ff ff       	call   8007a4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800905:	ff 45 f0             	incl   -0x10(%ebp)
  800908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80090e:	0f 8c 3e ff ff ff    	jl     800852 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800914:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80091b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800922:	eb 20                	jmp    800944 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800924:	a1 20 30 80 00       	mov    0x803020,%eax
  800929:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80092f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800932:	c1 e2 04             	shl    $0x4,%edx
  800935:	01 d0                	add    %edx,%eax
  800937:	8a 40 04             	mov    0x4(%eax),%al
  80093a:	3c 01                	cmp    $0x1,%al
  80093c:	75 03                	jne    800941 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80093e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800941:	ff 45 e0             	incl   -0x20(%ebp)
  800944:	a1 20 30 80 00       	mov    0x803020,%eax
  800949:	8b 50 74             	mov    0x74(%eax),%edx
  80094c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094f:	39 c2                	cmp    %eax,%edx
  800951:	77 d1                	ja     800924 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800956:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800959:	74 14                	je     80096f <CheckWSWithoutLastIndex+0x159>
		panic(
  80095b:	83 ec 04             	sub    $0x4,%esp
  80095e:	68 84 2a 80 00       	push   $0x802a84
  800963:	6a 44                	push   $0x44
  800965:	68 24 2a 80 00       	push   $0x802a24
  80096a:	e8 35 fe ff ff       	call   8007a4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80096f:	90                   	nop
  800970:	c9                   	leave  
  800971:	c3                   	ret    

00800972 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	8d 48 01             	lea    0x1(%eax),%ecx
  800980:	8b 55 0c             	mov    0xc(%ebp),%edx
  800983:	89 0a                	mov    %ecx,(%edx)
  800985:	8b 55 08             	mov    0x8(%ebp),%edx
  800988:	88 d1                	mov    %dl,%cl
  80098a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800991:	8b 45 0c             	mov    0xc(%ebp),%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	3d ff 00 00 00       	cmp    $0xff,%eax
  80099b:	75 2c                	jne    8009c9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80099d:	a0 24 30 80 00       	mov    0x803024,%al
  8009a2:	0f b6 c0             	movzbl %al,%eax
  8009a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a8:	8b 12                	mov    (%edx),%edx
  8009aa:	89 d1                	mov    %edx,%ecx
  8009ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009af:	83 c2 08             	add    $0x8,%edx
  8009b2:	83 ec 04             	sub    $0x4,%esp
  8009b5:	50                   	push   %eax
  8009b6:	51                   	push   %ecx
  8009b7:	52                   	push   %edx
  8009b8:	e8 a9 14 00 00       	call   801e66 <sys_cputs>
  8009bd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	8b 40 04             	mov    0x4(%eax),%eax
  8009cf:	8d 50 01             	lea    0x1(%eax),%edx
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009d8:	90                   	nop
  8009d9:	c9                   	leave  
  8009da:	c3                   	ret    

008009db <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009e4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009eb:	00 00 00 
	b.cnt = 0;
  8009ee:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009f5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009f8:	ff 75 0c             	pushl  0xc(%ebp)
  8009fb:	ff 75 08             	pushl  0x8(%ebp)
  8009fe:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a04:	50                   	push   %eax
  800a05:	68 72 09 80 00       	push   $0x800972
  800a0a:	e8 11 02 00 00       	call   800c20 <vprintfmt>
  800a0f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a12:	a0 24 30 80 00       	mov    0x803024,%al
  800a17:	0f b6 c0             	movzbl %al,%eax
  800a1a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a20:	83 ec 04             	sub    $0x4,%esp
  800a23:	50                   	push   %eax
  800a24:	52                   	push   %edx
  800a25:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2b:	83 c0 08             	add    $0x8,%eax
  800a2e:	50                   	push   %eax
  800a2f:	e8 32 14 00 00       	call   801e66 <sys_cputs>
  800a34:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a37:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800a3e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a44:	c9                   	leave  
  800a45:	c3                   	ret    

00800a46 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a4c:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800a53:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a62:	50                   	push   %eax
  800a63:	e8 73 ff ff ff       	call   8009db <vcprintf>
  800a68:	83 c4 10             	add    $0x10,%esp
  800a6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a71:	c9                   	leave  
  800a72:	c3                   	ret    

00800a73 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a79:	e8 f9 15 00 00       	call   802077 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a7e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8d:	50                   	push   %eax
  800a8e:	e8 48 ff ff ff       	call   8009db <vcprintf>
  800a93:	83 c4 10             	add    $0x10,%esp
  800a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a99:	e8 f3 15 00 00       	call   802091 <sys_enable_interrupt>
	return cnt;
  800a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa1:	c9                   	leave  
  800aa2:	c3                   	ret    

00800aa3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	53                   	push   %ebx
  800aa7:	83 ec 14             	sub    $0x14,%esp
  800aaa:	8b 45 10             	mov    0x10(%ebp),%eax
  800aad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ab6:	8b 45 18             	mov    0x18(%ebp),%eax
  800ab9:	ba 00 00 00 00       	mov    $0x0,%edx
  800abe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac1:	77 55                	ja     800b18 <printnum+0x75>
  800ac3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac6:	72 05                	jb     800acd <printnum+0x2a>
  800ac8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800acb:	77 4b                	ja     800b18 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800acd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ad0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ad3:	8b 45 18             	mov    0x18(%ebp),%eax
  800ad6:	ba 00 00 00 00       	mov    $0x0,%edx
  800adb:	52                   	push   %edx
  800adc:	50                   	push   %eax
  800add:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ae3:	e8 b0 19 00 00       	call   802498 <__udivdi3>
  800ae8:	83 c4 10             	add    $0x10,%esp
  800aeb:	83 ec 04             	sub    $0x4,%esp
  800aee:	ff 75 20             	pushl  0x20(%ebp)
  800af1:	53                   	push   %ebx
  800af2:	ff 75 18             	pushl  0x18(%ebp)
  800af5:	52                   	push   %edx
  800af6:	50                   	push   %eax
  800af7:	ff 75 0c             	pushl  0xc(%ebp)
  800afa:	ff 75 08             	pushl  0x8(%ebp)
  800afd:	e8 a1 ff ff ff       	call   800aa3 <printnum>
  800b02:	83 c4 20             	add    $0x20,%esp
  800b05:	eb 1a                	jmp    800b21 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 0c             	pushl  0xc(%ebp)
  800b0d:	ff 75 20             	pushl  0x20(%ebp)
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	ff d0                	call   *%eax
  800b15:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b18:	ff 4d 1c             	decl   0x1c(%ebp)
  800b1b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b1f:	7f e6                	jg     800b07 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b21:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b2f:	53                   	push   %ebx
  800b30:	51                   	push   %ecx
  800b31:	52                   	push   %edx
  800b32:	50                   	push   %eax
  800b33:	e8 70 1a 00 00       	call   8025a8 <__umoddi3>
  800b38:	83 c4 10             	add    $0x10,%esp
  800b3b:	05 f4 2c 80 00       	add    $0x802cf4,%eax
  800b40:	8a 00                	mov    (%eax),%al
  800b42:	0f be c0             	movsbl %al,%eax
  800b45:	83 ec 08             	sub    $0x8,%esp
  800b48:	ff 75 0c             	pushl  0xc(%ebp)
  800b4b:	50                   	push   %eax
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	ff d0                	call   *%eax
  800b51:	83 c4 10             	add    $0x10,%esp
}
  800b54:	90                   	nop
  800b55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b58:	c9                   	leave  
  800b59:	c3                   	ret    

00800b5a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b5d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b61:	7e 1c                	jle    800b7f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	8d 50 08             	lea    0x8(%eax),%edx
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	89 10                	mov    %edx,(%eax)
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	8b 00                	mov    (%eax),%eax
  800b75:	83 e8 08             	sub    $0x8,%eax
  800b78:	8b 50 04             	mov    0x4(%eax),%edx
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	eb 40                	jmp    800bbf <getuint+0x65>
	else if (lflag)
  800b7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b83:	74 1e                	je     800ba3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	8d 50 04             	lea    0x4(%eax),%edx
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	89 10                	mov    %edx,(%eax)
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	83 e8 04             	sub    $0x4,%eax
  800b9a:	8b 00                	mov    (%eax),%eax
  800b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba1:	eb 1c                	jmp    800bbf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	8b 00                	mov    (%eax),%eax
  800ba8:	8d 50 04             	lea    0x4(%eax),%edx
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	89 10                	mov    %edx,(%eax)
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8b 00                	mov    (%eax),%eax
  800bb5:	83 e8 04             	sub    $0x4,%eax
  800bb8:	8b 00                	mov    (%eax),%eax
  800bba:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bc4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bc8:	7e 1c                	jle    800be6 <getint+0x25>
		return va_arg(*ap, long long);
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8b 00                	mov    (%eax),%eax
  800bcf:	8d 50 08             	lea    0x8(%eax),%edx
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	89 10                	mov    %edx,(%eax)
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	8b 00                	mov    (%eax),%eax
  800bdc:	83 e8 08             	sub    $0x8,%eax
  800bdf:	8b 50 04             	mov    0x4(%eax),%edx
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	eb 38                	jmp    800c1e <getint+0x5d>
	else if (lflag)
  800be6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bea:	74 1a                	je     800c06 <getint+0x45>
		return va_arg(*ap, long);
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	8d 50 04             	lea    0x4(%eax),%edx
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	89 10                	mov    %edx,(%eax)
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8b 00                	mov    (%eax),%eax
  800bfe:	83 e8 04             	sub    $0x4,%eax
  800c01:	8b 00                	mov    (%eax),%eax
  800c03:	99                   	cltd   
  800c04:	eb 18                	jmp    800c1e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8b 00                	mov    (%eax),%eax
  800c0b:	8d 50 04             	lea    0x4(%eax),%edx
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	89 10                	mov    %edx,(%eax)
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8b 00                	mov    (%eax),%eax
  800c18:	83 e8 04             	sub    $0x4,%eax
  800c1b:	8b 00                	mov    (%eax),%eax
  800c1d:	99                   	cltd   
}
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	56                   	push   %esi
  800c24:	53                   	push   %ebx
  800c25:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c28:	eb 17                	jmp    800c41 <vprintfmt+0x21>
			if (ch == '\0')
  800c2a:	85 db                	test   %ebx,%ebx
  800c2c:	0f 84 af 03 00 00    	je     800fe1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	53                   	push   %ebx
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	ff d0                	call   *%eax
  800c3e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c41:	8b 45 10             	mov    0x10(%ebp),%eax
  800c44:	8d 50 01             	lea    0x1(%eax),%edx
  800c47:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4a:	8a 00                	mov    (%eax),%al
  800c4c:	0f b6 d8             	movzbl %al,%ebx
  800c4f:	83 fb 25             	cmp    $0x25,%ebx
  800c52:	75 d6                	jne    800c2a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c54:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c58:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c5f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c66:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c6d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c74:	8b 45 10             	mov    0x10(%ebp),%eax
  800c77:	8d 50 01             	lea    0x1(%eax),%edx
  800c7a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	0f b6 d8             	movzbl %al,%ebx
  800c82:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c85:	83 f8 55             	cmp    $0x55,%eax
  800c88:	0f 87 2b 03 00 00    	ja     800fb9 <vprintfmt+0x399>
  800c8e:	8b 04 85 18 2d 80 00 	mov    0x802d18(,%eax,4),%eax
  800c95:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c97:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c9b:	eb d7                	jmp    800c74 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c9d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ca1:	eb d1                	jmp    800c74 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800caa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cad:	89 d0                	mov    %edx,%eax
  800caf:	c1 e0 02             	shl    $0x2,%eax
  800cb2:	01 d0                	add    %edx,%eax
  800cb4:	01 c0                	add    %eax,%eax
  800cb6:	01 d8                	add    %ebx,%eax
  800cb8:	83 e8 30             	sub    $0x30,%eax
  800cbb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cc6:	83 fb 2f             	cmp    $0x2f,%ebx
  800cc9:	7e 3e                	jle    800d09 <vprintfmt+0xe9>
  800ccb:	83 fb 39             	cmp    $0x39,%ebx
  800cce:	7f 39                	jg     800d09 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cd3:	eb d5                	jmp    800caa <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cd5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd8:	83 c0 04             	add    $0x4,%eax
  800cdb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cde:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce1:	83 e8 04             	sub    $0x4,%eax
  800ce4:	8b 00                	mov    (%eax),%eax
  800ce6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ce9:	eb 1f                	jmp    800d0a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ceb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cef:	79 83                	jns    800c74 <vprintfmt+0x54>
				width = 0;
  800cf1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cf8:	e9 77 ff ff ff       	jmp    800c74 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cfd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d04:	e9 6b ff ff ff       	jmp    800c74 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d09:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0e:	0f 89 60 ff ff ff    	jns    800c74 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d1a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d21:	e9 4e ff ff ff       	jmp    800c74 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d26:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d29:	e9 46 ff ff ff       	jmp    800c74 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d31:	83 c0 04             	add    $0x4,%eax
  800d34:	89 45 14             	mov    %eax,0x14(%ebp)
  800d37:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3a:	83 e8 04             	sub    $0x4,%eax
  800d3d:	8b 00                	mov    (%eax),%eax
  800d3f:	83 ec 08             	sub    $0x8,%esp
  800d42:	ff 75 0c             	pushl  0xc(%ebp)
  800d45:	50                   	push   %eax
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	ff d0                	call   *%eax
  800d4b:	83 c4 10             	add    $0x10,%esp
			break;
  800d4e:	e9 89 02 00 00       	jmp    800fdc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d53:	8b 45 14             	mov    0x14(%ebp),%eax
  800d56:	83 c0 04             	add    $0x4,%eax
  800d59:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5f:	83 e8 04             	sub    $0x4,%eax
  800d62:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d64:	85 db                	test   %ebx,%ebx
  800d66:	79 02                	jns    800d6a <vprintfmt+0x14a>
				err = -err;
  800d68:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d6a:	83 fb 64             	cmp    $0x64,%ebx
  800d6d:	7f 0b                	jg     800d7a <vprintfmt+0x15a>
  800d6f:	8b 34 9d 60 2b 80 00 	mov    0x802b60(,%ebx,4),%esi
  800d76:	85 f6                	test   %esi,%esi
  800d78:	75 19                	jne    800d93 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d7a:	53                   	push   %ebx
  800d7b:	68 05 2d 80 00       	push   $0x802d05
  800d80:	ff 75 0c             	pushl  0xc(%ebp)
  800d83:	ff 75 08             	pushl  0x8(%ebp)
  800d86:	e8 5e 02 00 00       	call   800fe9 <printfmt>
  800d8b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d8e:	e9 49 02 00 00       	jmp    800fdc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d93:	56                   	push   %esi
  800d94:	68 0e 2d 80 00       	push   $0x802d0e
  800d99:	ff 75 0c             	pushl  0xc(%ebp)
  800d9c:	ff 75 08             	pushl  0x8(%ebp)
  800d9f:	e8 45 02 00 00       	call   800fe9 <printfmt>
  800da4:	83 c4 10             	add    $0x10,%esp
			break;
  800da7:	e9 30 02 00 00       	jmp    800fdc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dac:	8b 45 14             	mov    0x14(%ebp),%eax
  800daf:	83 c0 04             	add    $0x4,%eax
  800db2:	89 45 14             	mov    %eax,0x14(%ebp)
  800db5:	8b 45 14             	mov    0x14(%ebp),%eax
  800db8:	83 e8 04             	sub    $0x4,%eax
  800dbb:	8b 30                	mov    (%eax),%esi
  800dbd:	85 f6                	test   %esi,%esi
  800dbf:	75 05                	jne    800dc6 <vprintfmt+0x1a6>
				p = "(null)";
  800dc1:	be 11 2d 80 00       	mov    $0x802d11,%esi
			if (width > 0 && padc != '-')
  800dc6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dca:	7e 6d                	jle    800e39 <vprintfmt+0x219>
  800dcc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dd0:	74 67                	je     800e39 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dd5:	83 ec 08             	sub    $0x8,%esp
  800dd8:	50                   	push   %eax
  800dd9:	56                   	push   %esi
  800dda:	e8 0c 03 00 00       	call   8010eb <strnlen>
  800ddf:	83 c4 10             	add    $0x10,%esp
  800de2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800de5:	eb 16                	jmp    800dfd <vprintfmt+0x1dd>
					putch(padc, putdat);
  800de7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800deb:	83 ec 08             	sub    $0x8,%esp
  800dee:	ff 75 0c             	pushl  0xc(%ebp)
  800df1:	50                   	push   %eax
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	ff d0                	call   *%eax
  800df7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dfa:	ff 4d e4             	decl   -0x1c(%ebp)
  800dfd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e01:	7f e4                	jg     800de7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e03:	eb 34                	jmp    800e39 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e05:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e09:	74 1c                	je     800e27 <vprintfmt+0x207>
  800e0b:	83 fb 1f             	cmp    $0x1f,%ebx
  800e0e:	7e 05                	jle    800e15 <vprintfmt+0x1f5>
  800e10:	83 fb 7e             	cmp    $0x7e,%ebx
  800e13:	7e 12                	jle    800e27 <vprintfmt+0x207>
					putch('?', putdat);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	6a 3f                	push   $0x3f
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	ff d0                	call   *%eax
  800e22:	83 c4 10             	add    $0x10,%esp
  800e25:	eb 0f                	jmp    800e36 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e27:	83 ec 08             	sub    $0x8,%esp
  800e2a:	ff 75 0c             	pushl  0xc(%ebp)
  800e2d:	53                   	push   %ebx
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	ff d0                	call   *%eax
  800e33:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e36:	ff 4d e4             	decl   -0x1c(%ebp)
  800e39:	89 f0                	mov    %esi,%eax
  800e3b:	8d 70 01             	lea    0x1(%eax),%esi
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	0f be d8             	movsbl %al,%ebx
  800e43:	85 db                	test   %ebx,%ebx
  800e45:	74 24                	je     800e6b <vprintfmt+0x24b>
  800e47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e4b:	78 b8                	js     800e05 <vprintfmt+0x1e5>
  800e4d:	ff 4d e0             	decl   -0x20(%ebp)
  800e50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e54:	79 af                	jns    800e05 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e56:	eb 13                	jmp    800e6b <vprintfmt+0x24b>
				putch(' ', putdat);
  800e58:	83 ec 08             	sub    $0x8,%esp
  800e5b:	ff 75 0c             	pushl  0xc(%ebp)
  800e5e:	6a 20                	push   $0x20
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	ff d0                	call   *%eax
  800e65:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e68:	ff 4d e4             	decl   -0x1c(%ebp)
  800e6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6f:	7f e7                	jg     800e58 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e71:	e9 66 01 00 00       	jmp    800fdc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e76:	83 ec 08             	sub    $0x8,%esp
  800e79:	ff 75 e8             	pushl  -0x18(%ebp)
  800e7c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e7f:	50                   	push   %eax
  800e80:	e8 3c fd ff ff       	call   800bc1 <getint>
  800e85:	83 c4 10             	add    $0x10,%esp
  800e88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e94:	85 d2                	test   %edx,%edx
  800e96:	79 23                	jns    800ebb <vprintfmt+0x29b>
				putch('-', putdat);
  800e98:	83 ec 08             	sub    $0x8,%esp
  800e9b:	ff 75 0c             	pushl  0xc(%ebp)
  800e9e:	6a 2d                	push   $0x2d
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	ff d0                	call   *%eax
  800ea5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eae:	f7 d8                	neg    %eax
  800eb0:	83 d2 00             	adc    $0x0,%edx
  800eb3:	f7 da                	neg    %edx
  800eb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ebb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ec2:	e9 bc 00 00 00       	jmp    800f83 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	ff 75 e8             	pushl  -0x18(%ebp)
  800ecd:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed0:	50                   	push   %eax
  800ed1:	e8 84 fc ff ff       	call   800b5a <getuint>
  800ed6:	83 c4 10             	add    $0x10,%esp
  800ed9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800edf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ee6:	e9 98 00 00 00       	jmp    800f83 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eeb:	83 ec 08             	sub    $0x8,%esp
  800eee:	ff 75 0c             	pushl  0xc(%ebp)
  800ef1:	6a 58                	push   $0x58
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	ff d0                	call   *%eax
  800ef8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800efb:	83 ec 08             	sub    $0x8,%esp
  800efe:	ff 75 0c             	pushl  0xc(%ebp)
  800f01:	6a 58                	push   $0x58
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	ff d0                	call   *%eax
  800f08:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f0b:	83 ec 08             	sub    $0x8,%esp
  800f0e:	ff 75 0c             	pushl  0xc(%ebp)
  800f11:	6a 58                	push   $0x58
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	ff d0                	call   *%eax
  800f18:	83 c4 10             	add    $0x10,%esp
			break;
  800f1b:	e9 bc 00 00 00       	jmp    800fdc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	6a 30                	push   $0x30
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	ff d0                	call   *%eax
  800f2d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	6a 78                	push   $0x78
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	ff d0                	call   *%eax
  800f3d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f40:	8b 45 14             	mov    0x14(%ebp),%eax
  800f43:	83 c0 04             	add    $0x4,%eax
  800f46:	89 45 14             	mov    %eax,0x14(%ebp)
  800f49:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4c:	83 e8 04             	sub    $0x4,%eax
  800f4f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f62:	eb 1f                	jmp    800f83 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f64:	83 ec 08             	sub    $0x8,%esp
  800f67:	ff 75 e8             	pushl  -0x18(%ebp)
  800f6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800f6d:	50                   	push   %eax
  800f6e:	e8 e7 fb ff ff       	call   800b5a <getuint>
  800f73:	83 c4 10             	add    $0x10,%esp
  800f76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f83:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f8a:	83 ec 04             	sub    $0x4,%esp
  800f8d:	52                   	push   %edx
  800f8e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f91:	50                   	push   %eax
  800f92:	ff 75 f4             	pushl  -0xc(%ebp)
  800f95:	ff 75 f0             	pushl  -0x10(%ebp)
  800f98:	ff 75 0c             	pushl  0xc(%ebp)
  800f9b:	ff 75 08             	pushl  0x8(%ebp)
  800f9e:	e8 00 fb ff ff       	call   800aa3 <printnum>
  800fa3:	83 c4 20             	add    $0x20,%esp
			break;
  800fa6:	eb 34                	jmp    800fdc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa8:	83 ec 08             	sub    $0x8,%esp
  800fab:	ff 75 0c             	pushl  0xc(%ebp)
  800fae:	53                   	push   %ebx
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	ff d0                	call   *%eax
  800fb4:	83 c4 10             	add    $0x10,%esp
			break;
  800fb7:	eb 23                	jmp    800fdc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	6a 25                	push   $0x25
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	ff d0                	call   *%eax
  800fc6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fc9:	ff 4d 10             	decl   0x10(%ebp)
  800fcc:	eb 03                	jmp    800fd1 <vprintfmt+0x3b1>
  800fce:	ff 4d 10             	decl   0x10(%ebp)
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	48                   	dec    %eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 25                	cmp    $0x25,%al
  800fd9:	75 f3                	jne    800fce <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fdb:	90                   	nop
		}
	}
  800fdc:	e9 47 fc ff ff       	jmp    800c28 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fe1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fe2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fe5:	5b                   	pop    %ebx
  800fe6:	5e                   	pop    %esi
  800fe7:	5d                   	pop    %ebp
  800fe8:	c3                   	ret    

00800fe9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fef:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff2:	83 c0 04             	add    $0x4,%eax
  800ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ff8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ffe:	50                   	push   %eax
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	ff 75 08             	pushl  0x8(%ebp)
  801005:	e8 16 fc ff ff       	call   800c20 <vprintfmt>
  80100a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80100d:	90                   	nop
  80100e:	c9                   	leave  
  80100f:	c3                   	ret    

00801010 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801013:	8b 45 0c             	mov    0xc(%ebp),%eax
  801016:	8b 40 08             	mov    0x8(%eax),%eax
  801019:	8d 50 01             	lea    0x1(%eax),%edx
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801022:	8b 45 0c             	mov    0xc(%ebp),%eax
  801025:	8b 10                	mov    (%eax),%edx
  801027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102a:	8b 40 04             	mov    0x4(%eax),%eax
  80102d:	39 c2                	cmp    %eax,%edx
  80102f:	73 12                	jae    801043 <sprintputch+0x33>
		*b->buf++ = ch;
  801031:	8b 45 0c             	mov    0xc(%ebp),%eax
  801034:	8b 00                	mov    (%eax),%eax
  801036:	8d 48 01             	lea    0x1(%eax),%ecx
  801039:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103c:	89 0a                	mov    %ecx,(%edx)
  80103e:	8b 55 08             	mov    0x8(%ebp),%edx
  801041:	88 10                	mov    %dl,(%eax)
}
  801043:	90                   	nop
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    

00801046 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801052:	8b 45 0c             	mov    0xc(%ebp),%eax
  801055:	8d 50 ff             	lea    -0x1(%eax),%edx
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	01 d0                	add    %edx,%eax
  80105d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801060:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801067:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106b:	74 06                	je     801073 <vsnprintf+0x2d>
  80106d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801071:	7f 07                	jg     80107a <vsnprintf+0x34>
		return -E_INVAL;
  801073:	b8 03 00 00 00       	mov    $0x3,%eax
  801078:	eb 20                	jmp    80109a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80107a:	ff 75 14             	pushl  0x14(%ebp)
  80107d:	ff 75 10             	pushl  0x10(%ebp)
  801080:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801083:	50                   	push   %eax
  801084:	68 10 10 80 00       	push   $0x801010
  801089:	e8 92 fb ff ff       	call   800c20 <vprintfmt>
  80108e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801091:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801094:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801097:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80109a:	c9                   	leave  
  80109b:	c3                   	ret    

0080109c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010a2:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a5:	83 c0 04             	add    $0x4,%eax
  8010a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b1:	50                   	push   %eax
  8010b2:	ff 75 0c             	pushl  0xc(%ebp)
  8010b5:	ff 75 08             	pushl  0x8(%ebp)
  8010b8:	e8 89 ff ff ff       	call   801046 <vsnprintf>
  8010bd:	83 c4 10             	add    $0x10,%esp
  8010c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010c6:	c9                   	leave  
  8010c7:	c3                   	ret    

008010c8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010d5:	eb 06                	jmp    8010dd <strlen+0x15>
		n++;
  8010d7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010da:	ff 45 08             	incl   0x8(%ebp)
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	84 c0                	test   %al,%al
  8010e4:	75 f1                	jne    8010d7 <strlen+0xf>
		n++;
	return n;
  8010e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010e9:	c9                   	leave  
  8010ea:	c3                   	ret    

008010eb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010f8:	eb 09                	jmp    801103 <strnlen+0x18>
		n++;
  8010fa:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010fd:	ff 45 08             	incl   0x8(%ebp)
  801100:	ff 4d 0c             	decl   0xc(%ebp)
  801103:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801107:	74 09                	je     801112 <strnlen+0x27>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	8a 00                	mov    (%eax),%al
  80110e:	84 c0                	test   %al,%al
  801110:	75 e8                	jne    8010fa <strnlen+0xf>
		n++;
	return n;
  801112:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801115:	c9                   	leave  
  801116:	c3                   	ret    

00801117 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801123:	90                   	nop
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	8d 50 01             	lea    0x1(%eax),%edx
  80112a:	89 55 08             	mov    %edx,0x8(%ebp)
  80112d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801130:	8d 4a 01             	lea    0x1(%edx),%ecx
  801133:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801136:	8a 12                	mov    (%edx),%dl
  801138:	88 10                	mov    %dl,(%eax)
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	84 c0                	test   %al,%al
  80113e:	75 e4                	jne    801124 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801140:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801151:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801158:	eb 1f                	jmp    801179 <strncpy+0x34>
		*dst++ = *src;
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8d 50 01             	lea    0x1(%eax),%edx
  801160:	89 55 08             	mov    %edx,0x8(%ebp)
  801163:	8b 55 0c             	mov    0xc(%ebp),%edx
  801166:	8a 12                	mov    (%edx),%dl
  801168:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80116a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	84 c0                	test   %al,%al
  801171:	74 03                	je     801176 <strncpy+0x31>
			src++;
  801173:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801176:	ff 45 fc             	incl   -0x4(%ebp)
  801179:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80117f:	72 d9                	jb     80115a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801192:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801196:	74 30                	je     8011c8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801198:	eb 16                	jmp    8011b0 <strlcpy+0x2a>
			*dst++ = *src++;
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8d 50 01             	lea    0x1(%eax),%edx
  8011a0:	89 55 08             	mov    %edx,0x8(%ebp)
  8011a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011ac:	8a 12                	mov    (%edx),%dl
  8011ae:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011b0:	ff 4d 10             	decl   0x10(%ebp)
  8011b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b7:	74 09                	je     8011c2 <strlcpy+0x3c>
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	84 c0                	test   %al,%al
  8011c0:	75 d8                	jne    80119a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ce:	29 c2                	sub    %eax,%edx
  8011d0:	89 d0                	mov    %edx,%eax
}
  8011d2:	c9                   	leave  
  8011d3:	c3                   	ret    

008011d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011d7:	eb 06                	jmp    8011df <strcmp+0xb>
		p++, q++;
  8011d9:	ff 45 08             	incl   0x8(%ebp)
  8011dc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	84 c0                	test   %al,%al
  8011e6:	74 0e                	je     8011f6 <strcmp+0x22>
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 10                	mov    (%eax),%dl
  8011ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f0:	8a 00                	mov    (%eax),%al
  8011f2:	38 c2                	cmp    %al,%dl
  8011f4:	74 e3                	je     8011d9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	0f b6 d0             	movzbl %al,%edx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	0f b6 c0             	movzbl %al,%eax
  801206:	29 c2                	sub    %eax,%edx
  801208:	89 d0                	mov    %edx,%eax
}
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    

0080120c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80120f:	eb 09                	jmp    80121a <strncmp+0xe>
		n--, p++, q++;
  801211:	ff 4d 10             	decl   0x10(%ebp)
  801214:	ff 45 08             	incl   0x8(%ebp)
  801217:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80121a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121e:	74 17                	je     801237 <strncmp+0x2b>
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	84 c0                	test   %al,%al
  801227:	74 0e                	je     801237 <strncmp+0x2b>
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8a 10                	mov    (%eax),%dl
  80122e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	38 c2                	cmp    %al,%dl
  801235:	74 da                	je     801211 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801237:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80123b:	75 07                	jne    801244 <strncmp+0x38>
		return 0;
  80123d:	b8 00 00 00 00       	mov    $0x0,%eax
  801242:	eb 14                	jmp    801258 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	8a 00                	mov    (%eax),%al
  801249:	0f b6 d0             	movzbl %al,%edx
  80124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	0f b6 c0             	movzbl %al,%eax
  801254:	29 c2                	sub    %eax,%edx
  801256:	89 d0                	mov    %edx,%eax
}
  801258:	5d                   	pop    %ebp
  801259:	c3                   	ret    

0080125a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	83 ec 04             	sub    $0x4,%esp
  801260:	8b 45 0c             	mov    0xc(%ebp),%eax
  801263:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801266:	eb 12                	jmp    80127a <strchr+0x20>
		if (*s == c)
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	8a 00                	mov    (%eax),%al
  80126d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801270:	75 05                	jne    801277 <strchr+0x1d>
			return (char *) s;
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	eb 11                	jmp    801288 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801277:	ff 45 08             	incl   0x8(%ebp)
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	84 c0                	test   %al,%al
  801281:	75 e5                	jne    801268 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801283:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	83 ec 04             	sub    $0x4,%esp
  801290:	8b 45 0c             	mov    0xc(%ebp),%eax
  801293:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801296:	eb 0d                	jmp    8012a5 <strfind+0x1b>
		if (*s == c)
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012a0:	74 0e                	je     8012b0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012a2:	ff 45 08             	incl   0x8(%ebp)
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	84 c0                	test   %al,%al
  8012ac:	75 ea                	jne    801298 <strfind+0xe>
  8012ae:	eb 01                	jmp    8012b1 <strfind+0x27>
		if (*s == c)
			break;
  8012b0:	90                   	nop
	return (char *) s;
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    

008012b6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012c8:	eb 0e                	jmp    8012d8 <memset+0x22>
		*p++ = c;
  8012ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012cd:	8d 50 01             	lea    0x1(%eax),%edx
  8012d0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012d8:	ff 4d f8             	decl   -0x8(%ebp)
  8012db:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012df:	79 e9                	jns    8012ca <memset+0x14>
		*p++ = c;

	return v;
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8012f8:	eb 16                	jmp    801310 <memcpy+0x2a>
		*d++ = *s++;
  8012fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fd:	8d 50 01             	lea    0x1(%eax),%edx
  801300:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801303:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801306:	8d 4a 01             	lea    0x1(%edx),%ecx
  801309:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80130c:	8a 12                	mov    (%edx),%dl
  80130e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	8d 50 ff             	lea    -0x1(%eax),%edx
  801316:	89 55 10             	mov    %edx,0x10(%ebp)
  801319:	85 c0                	test   %eax,%eax
  80131b:	75 dd                	jne    8012fa <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801320:	c9                   	leave  
  801321:	c3                   	ret    

00801322 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801334:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801337:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80133a:	73 50                	jae    80138c <memmove+0x6a>
  80133c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80133f:	8b 45 10             	mov    0x10(%ebp),%eax
  801342:	01 d0                	add    %edx,%eax
  801344:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801347:	76 43                	jbe    80138c <memmove+0x6a>
		s += n;
  801349:	8b 45 10             	mov    0x10(%ebp),%eax
  80134c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80134f:	8b 45 10             	mov    0x10(%ebp),%eax
  801352:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801355:	eb 10                	jmp    801367 <memmove+0x45>
			*--d = *--s;
  801357:	ff 4d f8             	decl   -0x8(%ebp)
  80135a:	ff 4d fc             	decl   -0x4(%ebp)
  80135d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801360:	8a 10                	mov    (%eax),%dl
  801362:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801365:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801367:	8b 45 10             	mov    0x10(%ebp),%eax
  80136a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80136d:	89 55 10             	mov    %edx,0x10(%ebp)
  801370:	85 c0                	test   %eax,%eax
  801372:	75 e3                	jne    801357 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801374:	eb 23                	jmp    801399 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801376:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801379:	8d 50 01             	lea    0x1(%eax),%edx
  80137c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80137f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801382:	8d 4a 01             	lea    0x1(%edx),%ecx
  801385:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801388:	8a 12                	mov    (%edx),%dl
  80138a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80138c:	8b 45 10             	mov    0x10(%ebp),%eax
  80138f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801392:	89 55 10             	mov    %edx,0x10(%ebp)
  801395:	85 c0                	test   %eax,%eax
  801397:	75 dd                	jne    801376 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80139c:	c9                   	leave  
  80139d:	c3                   	ret    

0080139e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ad:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013b0:	eb 2a                	jmp    8013dc <memcmp+0x3e>
		if (*s1 != *s2)
  8013b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b5:	8a 10                	mov    (%eax),%dl
  8013b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ba:	8a 00                	mov    (%eax),%al
  8013bc:	38 c2                	cmp    %al,%dl
  8013be:	74 16                	je     8013d6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	0f b6 d0             	movzbl %al,%edx
  8013c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	0f b6 c0             	movzbl %al,%eax
  8013d0:	29 c2                	sub    %eax,%edx
  8013d2:	89 d0                	mov    %edx,%eax
  8013d4:	eb 18                	jmp    8013ee <memcmp+0x50>
		s1++, s2++;
  8013d6:	ff 45 fc             	incl   -0x4(%ebp)
  8013d9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	75 c9                	jne    8013b2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fc:	01 d0                	add    %edx,%eax
  8013fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801401:	eb 15                	jmp    801418 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	0f b6 d0             	movzbl %al,%edx
  80140b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140e:	0f b6 c0             	movzbl %al,%eax
  801411:	39 c2                	cmp    %eax,%edx
  801413:	74 0d                	je     801422 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801415:	ff 45 08             	incl   0x8(%ebp)
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80141e:	72 e3                	jb     801403 <memfind+0x13>
  801420:	eb 01                	jmp    801423 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801422:	90                   	nop
	return (void *) s;
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80142e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801435:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80143c:	eb 03                	jmp    801441 <strtol+0x19>
		s++;
  80143e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	3c 20                	cmp    $0x20,%al
  801448:	74 f4                	je     80143e <strtol+0x16>
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3c 09                	cmp    $0x9,%al
  801451:	74 eb                	je     80143e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	3c 2b                	cmp    $0x2b,%al
  80145a:	75 05                	jne    801461 <strtol+0x39>
		s++;
  80145c:	ff 45 08             	incl   0x8(%ebp)
  80145f:	eb 13                	jmp    801474 <strtol+0x4c>
	else if (*s == '-')
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	8a 00                	mov    (%eax),%al
  801466:	3c 2d                	cmp    $0x2d,%al
  801468:	75 0a                	jne    801474 <strtol+0x4c>
		s++, neg = 1;
  80146a:	ff 45 08             	incl   0x8(%ebp)
  80146d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801474:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801478:	74 06                	je     801480 <strtol+0x58>
  80147a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80147e:	75 20                	jne    8014a0 <strtol+0x78>
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	8a 00                	mov    (%eax),%al
  801485:	3c 30                	cmp    $0x30,%al
  801487:	75 17                	jne    8014a0 <strtol+0x78>
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	40                   	inc    %eax
  80148d:	8a 00                	mov    (%eax),%al
  80148f:	3c 78                	cmp    $0x78,%al
  801491:	75 0d                	jne    8014a0 <strtol+0x78>
		s += 2, base = 16;
  801493:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801497:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80149e:	eb 28                	jmp    8014c8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a4:	75 15                	jne    8014bb <strtol+0x93>
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	8a 00                	mov    (%eax),%al
  8014ab:	3c 30                	cmp    $0x30,%al
  8014ad:	75 0c                	jne    8014bb <strtol+0x93>
		s++, base = 8;
  8014af:	ff 45 08             	incl   0x8(%ebp)
  8014b2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014b9:	eb 0d                	jmp    8014c8 <strtol+0xa0>
	else if (base == 0)
  8014bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014bf:	75 07                	jne    8014c8 <strtol+0xa0>
		base = 10;
  8014c1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	8a 00                	mov    (%eax),%al
  8014cd:	3c 2f                	cmp    $0x2f,%al
  8014cf:	7e 19                	jle    8014ea <strtol+0xc2>
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	3c 39                	cmp    $0x39,%al
  8014d8:	7f 10                	jg     8014ea <strtol+0xc2>
			dig = *s - '0';
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	0f be c0             	movsbl %al,%eax
  8014e2:	83 e8 30             	sub    $0x30,%eax
  8014e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e8:	eb 42                	jmp    80152c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	3c 60                	cmp    $0x60,%al
  8014f1:	7e 19                	jle    80150c <strtol+0xe4>
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	3c 7a                	cmp    $0x7a,%al
  8014fa:	7f 10                	jg     80150c <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	0f be c0             	movsbl %al,%eax
  801504:	83 e8 57             	sub    $0x57,%eax
  801507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80150a:	eb 20                	jmp    80152c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	8a 00                	mov    (%eax),%al
  801511:	3c 40                	cmp    $0x40,%al
  801513:	7e 39                	jle    80154e <strtol+0x126>
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8a 00                	mov    (%eax),%al
  80151a:	3c 5a                	cmp    $0x5a,%al
  80151c:	7f 30                	jg     80154e <strtol+0x126>
			dig = *s - 'A' + 10;
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	0f be c0             	movsbl %al,%eax
  801526:	83 e8 37             	sub    $0x37,%eax
  801529:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80152c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801532:	7d 19                	jge    80154d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801534:	ff 45 08             	incl   0x8(%ebp)
  801537:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80153e:	89 c2                	mov    %eax,%edx
  801540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801548:	e9 7b ff ff ff       	jmp    8014c8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80154d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80154e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801552:	74 08                	je     80155c <strtol+0x134>
		*endptr = (char *) s;
  801554:	8b 45 0c             	mov    0xc(%ebp),%eax
  801557:	8b 55 08             	mov    0x8(%ebp),%edx
  80155a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80155c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801560:	74 07                	je     801569 <strtol+0x141>
  801562:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801565:	f7 d8                	neg    %eax
  801567:	eb 03                	jmp    80156c <strtol+0x144>
  801569:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <ltostr>:

void
ltostr(long value, char *str)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801574:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80157b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801582:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801586:	79 13                	jns    80159b <ltostr+0x2d>
	{
		neg = 1;
  801588:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801595:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801598:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80159b:	8b 45 08             	mov    0x8(%ebp),%eax
  80159e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015a3:	99                   	cltd   
  8015a4:	f7 f9                	idiv   %ecx
  8015a6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ac:	8d 50 01             	lea    0x1(%eax),%edx
  8015af:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015b2:	89 c2                	mov    %eax,%edx
  8015b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b7:	01 d0                	add    %edx,%eax
  8015b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015bc:	83 c2 30             	add    $0x30,%edx
  8015bf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015c4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015c9:	f7 e9                	imul   %ecx
  8015cb:	c1 fa 02             	sar    $0x2,%edx
  8015ce:	89 c8                	mov    %ecx,%eax
  8015d0:	c1 f8 1f             	sar    $0x1f,%eax
  8015d3:	29 c2                	sub    %eax,%edx
  8015d5:	89 d0                	mov    %edx,%eax
  8015d7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015dd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015e2:	f7 e9                	imul   %ecx
  8015e4:	c1 fa 02             	sar    $0x2,%edx
  8015e7:	89 c8                	mov    %ecx,%eax
  8015e9:	c1 f8 1f             	sar    $0x1f,%eax
  8015ec:	29 c2                	sub    %eax,%edx
  8015ee:	89 d0                	mov    %edx,%eax
  8015f0:	c1 e0 02             	shl    $0x2,%eax
  8015f3:	01 d0                	add    %edx,%eax
  8015f5:	01 c0                	add    %eax,%eax
  8015f7:	29 c1                	sub    %eax,%ecx
  8015f9:	89 ca                	mov    %ecx,%edx
  8015fb:	85 d2                	test   %edx,%edx
  8015fd:	75 9c                	jne    80159b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801606:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801609:	48                   	dec    %eax
  80160a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80160d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801611:	74 3d                	je     801650 <ltostr+0xe2>
		start = 1 ;
  801613:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80161a:	eb 34                	jmp    801650 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80161c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801622:	01 d0                	add    %edx,%eax
  801624:	8a 00                	mov    (%eax),%al
  801626:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801629:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162f:	01 c2                	add    %eax,%edx
  801631:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801634:	8b 45 0c             	mov    0xc(%ebp),%eax
  801637:	01 c8                	add    %ecx,%eax
  801639:	8a 00                	mov    (%eax),%al
  80163b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80163d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801640:	8b 45 0c             	mov    0xc(%ebp),%eax
  801643:	01 c2                	add    %eax,%edx
  801645:	8a 45 eb             	mov    -0x15(%ebp),%al
  801648:	88 02                	mov    %al,(%edx)
		start++ ;
  80164a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80164d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801653:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801656:	7c c4                	jl     80161c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801658:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80165b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165e:	01 d0                	add    %edx,%eax
  801660:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801663:	90                   	nop
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80166c:	ff 75 08             	pushl  0x8(%ebp)
  80166f:	e8 54 fa ff ff       	call   8010c8 <strlen>
  801674:	83 c4 04             	add    $0x4,%esp
  801677:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80167a:	ff 75 0c             	pushl  0xc(%ebp)
  80167d:	e8 46 fa ff ff       	call   8010c8 <strlen>
  801682:	83 c4 04             	add    $0x4,%esp
  801685:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801688:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80168f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801696:	eb 17                	jmp    8016af <strcconcat+0x49>
		final[s] = str1[s] ;
  801698:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80169b:	8b 45 10             	mov    0x10(%ebp),%eax
  80169e:	01 c2                	add    %eax,%edx
  8016a0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	01 c8                	add    %ecx,%eax
  8016a8:	8a 00                	mov    (%eax),%al
  8016aa:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016ac:	ff 45 fc             	incl   -0x4(%ebp)
  8016af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016b5:	7c e1                	jl     801698 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016c5:	eb 1f                	jmp    8016e6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ca:	8d 50 01             	lea    0x1(%eax),%edx
  8016cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016d0:	89 c2                	mov    %eax,%edx
  8016d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d5:	01 c2                	add    %eax,%edx
  8016d7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dd:	01 c8                	add    %ecx,%eax
  8016df:	8a 00                	mov    (%eax),%al
  8016e1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016e3:	ff 45 f8             	incl   -0x8(%ebp)
  8016e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016ec:	7c d9                	jl     8016c7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f4:	01 d0                	add    %edx,%eax
  8016f6:	c6 00 00             	movb   $0x0,(%eax)
}
  8016f9:	90                   	nop
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801702:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801708:	8b 45 14             	mov    0x14(%ebp),%eax
  80170b:	8b 00                	mov    (%eax),%eax
  80170d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801714:	8b 45 10             	mov    0x10(%ebp),%eax
  801717:	01 d0                	add    %edx,%eax
  801719:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80171f:	eb 0c                	jmp    80172d <strsplit+0x31>
			*string++ = 0;
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	8d 50 01             	lea    0x1(%eax),%edx
  801727:	89 55 08             	mov    %edx,0x8(%ebp)
  80172a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	8a 00                	mov    (%eax),%al
  801732:	84 c0                	test   %al,%al
  801734:	74 18                	je     80174e <strsplit+0x52>
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8a 00                	mov    (%eax),%al
  80173b:	0f be c0             	movsbl %al,%eax
  80173e:	50                   	push   %eax
  80173f:	ff 75 0c             	pushl  0xc(%ebp)
  801742:	e8 13 fb ff ff       	call   80125a <strchr>
  801747:	83 c4 08             	add    $0x8,%esp
  80174a:	85 c0                	test   %eax,%eax
  80174c:	75 d3                	jne    801721 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8a 00                	mov    (%eax),%al
  801753:	84 c0                	test   %al,%al
  801755:	74 5a                	je     8017b1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801757:	8b 45 14             	mov    0x14(%ebp),%eax
  80175a:	8b 00                	mov    (%eax),%eax
  80175c:	83 f8 0f             	cmp    $0xf,%eax
  80175f:	75 07                	jne    801768 <strsplit+0x6c>
		{
			return 0;
  801761:	b8 00 00 00 00       	mov    $0x0,%eax
  801766:	eb 66                	jmp    8017ce <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801768:	8b 45 14             	mov    0x14(%ebp),%eax
  80176b:	8b 00                	mov    (%eax),%eax
  80176d:	8d 48 01             	lea    0x1(%eax),%ecx
  801770:	8b 55 14             	mov    0x14(%ebp),%edx
  801773:	89 0a                	mov    %ecx,(%edx)
  801775:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80177c:	8b 45 10             	mov    0x10(%ebp),%eax
  80177f:	01 c2                	add    %eax,%edx
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801786:	eb 03                	jmp    80178b <strsplit+0x8f>
			string++;
  801788:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	8a 00                	mov    (%eax),%al
  801790:	84 c0                	test   %al,%al
  801792:	74 8b                	je     80171f <strsplit+0x23>
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	0f be c0             	movsbl %al,%eax
  80179c:	50                   	push   %eax
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	e8 b5 fa ff ff       	call   80125a <strchr>
  8017a5:	83 c4 08             	add    $0x8,%esp
  8017a8:	85 c0                	test   %eax,%eax
  8017aa:	74 dc                	je     801788 <strsplit+0x8c>
			string++;
	}
  8017ac:	e9 6e ff ff ff       	jmp    80171f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017b1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b5:	8b 00                	mov    (%eax),%eax
  8017b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017be:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c1:	01 d0                	add    %edx,%eax
  8017c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8017d6:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8017dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8017e3:	01 d0                	add    %edx,%eax
  8017e5:	48                   	dec    %eax
  8017e6:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8017e9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8017ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f1:	f7 75 ac             	divl   -0x54(%ebp)
  8017f4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8017f7:	29 d0                	sub    %edx,%eax
  8017f9:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8017fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801803:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  80180a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801811:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801818:	eb 3f                	jmp    801859 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  80181a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80181d:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801824:	83 ec 04             	sub    $0x4,%esp
  801827:	50                   	push   %eax
  801828:	ff 75 e8             	pushl  -0x18(%ebp)
  80182b:	68 70 2e 80 00       	push   $0x802e70
  801830:	e8 11 f2 ff ff       	call   800a46 <cprintf>
  801835:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801838:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80183b:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801842:	83 ec 04             	sub    $0x4,%esp
  801845:	50                   	push   %eax
  801846:	ff 75 e8             	pushl  -0x18(%ebp)
  801849:	68 85 2e 80 00       	push   $0x802e85
  80184e:	e8 f3 f1 ff ff       	call   800a46 <cprintf>
  801853:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801856:	ff 45 e8             	incl   -0x18(%ebp)
  801859:	a1 28 30 80 00       	mov    0x803028,%eax
  80185e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801861:	7c b7                	jl     80181a <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801863:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  80186a:	e9 42 01 00 00       	jmp    8019b1 <malloc+0x1e1>
		int flag0=1;
  80186f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801876:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801879:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80187c:	eb 6b                	jmp    8018e9 <malloc+0x119>
			for(int k=0;k<count;k++){
  80187e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801885:	eb 42                	jmp    8018c9 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801887:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80188a:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801891:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801894:	39 c2                	cmp    %eax,%edx
  801896:	77 2e                	ja     8018c6 <malloc+0xf6>
  801898:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80189b:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8018a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018a5:	39 c2                	cmp    %eax,%edx
  8018a7:	76 1d                	jbe    8018c6 <malloc+0xf6>
					ni=arr_add[k].end-i;
  8018a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018ac:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8018b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018b6:	29 c2                	sub    %eax,%edx
  8018b8:	89 d0                	mov    %edx,%eax
  8018ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  8018bd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8018c4:	eb 0d                	jmp    8018d3 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8018c6:	ff 45 d8             	incl   -0x28(%ebp)
  8018c9:	a1 28 30 80 00       	mov    0x803028,%eax
  8018ce:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8018d1:	7c b4                	jl     801887 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8018d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018d7:	74 09                	je     8018e2 <malloc+0x112>
				flag0=0;
  8018d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8018e0:	eb 16                	jmp    8018f8 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8018e2:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8018e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	01 c2                	add    %eax,%edx
  8018f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018f4:	39 c2                	cmp    %eax,%edx
  8018f6:	77 86                	ja     80187e <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8018f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018fc:	0f 84 a2 00 00 00    	je     8019a4 <malloc+0x1d4>

			int f=1;
  801902:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801909:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80190c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80190f:	89 c8                	mov    %ecx,%eax
  801911:	01 c0                	add    %eax,%eax
  801913:	01 c8                	add    %ecx,%eax
  801915:	c1 e0 02             	shl    $0x2,%eax
  801918:	05 20 31 80 00       	add    $0x803120,%eax
  80191d:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  80191f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801928:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192b:	89 d0                	mov    %edx,%eax
  80192d:	01 c0                	add    %eax,%eax
  80192f:	01 d0                	add    %edx,%eax
  801931:	c1 e0 02             	shl    $0x2,%eax
  801934:	05 24 31 80 00       	add    $0x803124,%eax
  801939:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  80193b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80193e:	89 d0                	mov    %edx,%eax
  801940:	01 c0                	add    %eax,%eax
  801942:	01 d0                	add    %edx,%eax
  801944:	c1 e0 02             	shl    $0x2,%eax
  801947:	05 28 31 80 00       	add    $0x803128,%eax
  80194c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801952:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801955:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80195c:	eb 36                	jmp    801994 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  80195e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	01 c2                	add    %eax,%edx
  801966:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801969:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801970:	39 c2                	cmp    %eax,%edx
  801972:	73 1d                	jae    801991 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801974:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801977:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80197e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801981:	29 c2                	sub    %eax,%edx
  801983:	89 d0                	mov    %edx,%eax
  801985:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801988:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  80198f:	eb 0d                	jmp    80199e <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801991:	ff 45 d0             	incl   -0x30(%ebp)
  801994:	a1 28 30 80 00       	mov    0x803028,%eax
  801999:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  80199c:	7c c0                	jl     80195e <malloc+0x18e>
					break;

				}
			}

			if(f){
  80199e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8019a2:	75 1d                	jne    8019c1 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  8019a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8019ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ae:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8019b1:	a1 04 30 80 00       	mov    0x803004,%eax
  8019b6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019b9:	0f 8c b0 fe ff ff    	jl     80186f <malloc+0x9f>
  8019bf:	eb 01                	jmp    8019c2 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  8019c1:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8019c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019c6:	75 7a                	jne    801a42 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  8019c8:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	01 d0                	add    %edx,%eax
  8019d3:	48                   	dec    %eax
  8019d4:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8019d9:	7c 0a                	jl     8019e5 <malloc+0x215>
			return NULL;
  8019db:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e0:	e9 a4 02 00 00       	jmp    801c89 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  8019e5:	a1 04 30 80 00       	mov    0x803004,%eax
  8019ea:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8019ed:	a1 28 30 80 00       	mov    0x803028,%eax
  8019f2:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8019f5:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  8019fc:	83 ec 08             	sub    $0x8,%esp
  8019ff:	ff 75 08             	pushl  0x8(%ebp)
  801a02:	ff 75 a4             	pushl  -0x5c(%ebp)
  801a05:	e8 04 06 00 00       	call   80200e <sys_allocateMem>
  801a0a:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801a0d:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	01 d0                	add    %edx,%eax
  801a18:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  801a1d:	a1 28 30 80 00       	mov    0x803028,%eax
  801a22:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801a28:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  801a2f:	a1 28 30 80 00       	mov    0x803028,%eax
  801a34:	40                   	inc    %eax
  801a35:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  801a3a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801a3d:	e9 47 02 00 00       	jmp    801c89 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801a42:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801a49:	e9 ac 00 00 00       	jmp    801afa <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801a4e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801a51:	89 d0                	mov    %edx,%eax
  801a53:	01 c0                	add    %eax,%eax
  801a55:	01 d0                	add    %edx,%eax
  801a57:	c1 e0 02             	shl    $0x2,%eax
  801a5a:	05 24 31 80 00       	add    $0x803124,%eax
  801a5f:	8b 00                	mov    (%eax),%eax
  801a61:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801a64:	eb 7e                	jmp    801ae4 <malloc+0x314>
			int flag=0;
  801a66:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801a6d:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801a74:	eb 57                	jmp    801acd <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801a76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a79:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801a80:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a83:	39 c2                	cmp    %eax,%edx
  801a85:	77 1a                	ja     801aa1 <malloc+0x2d1>
  801a87:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a8a:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801a91:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a94:	39 c2                	cmp    %eax,%edx
  801a96:	76 09                	jbe    801aa1 <malloc+0x2d1>
								flag=1;
  801a98:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801a9f:	eb 36                	jmp    801ad7 <malloc+0x307>
			arr[i].space++;
  801aa1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801aa4:	89 d0                	mov    %edx,%eax
  801aa6:	01 c0                	add    %eax,%eax
  801aa8:	01 d0                	add    %edx,%eax
  801aaa:	c1 e0 02             	shl    $0x2,%eax
  801aad:	05 28 31 80 00       	add    $0x803128,%eax
  801ab2:	8b 00                	mov    (%eax),%eax
  801ab4:	8d 48 01             	lea    0x1(%eax),%ecx
  801ab7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801aba:	89 d0                	mov    %edx,%eax
  801abc:	01 c0                	add    %eax,%eax
  801abe:	01 d0                	add    %edx,%eax
  801ac0:	c1 e0 02             	shl    $0x2,%eax
  801ac3:	05 28 31 80 00       	add    $0x803128,%eax
  801ac8:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801aca:	ff 45 c0             	incl   -0x40(%ebp)
  801acd:	a1 28 30 80 00       	mov    0x803028,%eax
  801ad2:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801ad5:	7c 9f                	jl     801a76 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801ad7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801adb:	75 19                	jne    801af6 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801add:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801ae4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801ae7:	a1 04 30 80 00       	mov    0x803004,%eax
  801aec:	39 c2                	cmp    %eax,%edx
  801aee:	0f 82 72 ff ff ff    	jb     801a66 <malloc+0x296>
  801af4:	eb 01                	jmp    801af7 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801af6:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801af7:	ff 45 cc             	incl   -0x34(%ebp)
  801afa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801afd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b00:	0f 8c 48 ff ff ff    	jl     801a4e <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801b06:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801b0d:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801b14:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801b1b:	eb 37                	jmp    801b54 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801b1d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801b20:	89 d0                	mov    %edx,%eax
  801b22:	01 c0                	add    %eax,%eax
  801b24:	01 d0                	add    %edx,%eax
  801b26:	c1 e0 02             	shl    $0x2,%eax
  801b29:	05 28 31 80 00       	add    $0x803128,%eax
  801b2e:	8b 00                	mov    (%eax),%eax
  801b30:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801b33:	7d 1c                	jge    801b51 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801b35:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801b38:	89 d0                	mov    %edx,%eax
  801b3a:	01 c0                	add    %eax,%eax
  801b3c:	01 d0                	add    %edx,%eax
  801b3e:	c1 e0 02             	shl    $0x2,%eax
  801b41:	05 28 31 80 00       	add    $0x803128,%eax
  801b46:	8b 00                	mov    (%eax),%eax
  801b48:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801b4b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801b4e:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801b51:	ff 45 b4             	incl   -0x4c(%ebp)
  801b54:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801b57:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b5a:	7c c1                	jl     801b1d <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801b5c:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801b62:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801b65:	89 c8                	mov    %ecx,%eax
  801b67:	01 c0                	add    %eax,%eax
  801b69:	01 c8                	add    %ecx,%eax
  801b6b:	c1 e0 02             	shl    $0x2,%eax
  801b6e:	05 20 31 80 00       	add    $0x803120,%eax
  801b73:	8b 00                	mov    (%eax),%eax
  801b75:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801b7c:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801b82:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801b85:	89 c8                	mov    %ecx,%eax
  801b87:	01 c0                	add    %eax,%eax
  801b89:	01 c8                	add    %ecx,%eax
  801b8b:	c1 e0 02             	shl    $0x2,%eax
  801b8e:	05 24 31 80 00       	add    $0x803124,%eax
  801b93:	8b 00                	mov    (%eax),%eax
  801b95:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  801b9c:	a1 28 30 80 00       	mov    0x803028,%eax
  801ba1:	40                   	inc    %eax
  801ba2:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  801ba7:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801baa:	89 d0                	mov    %edx,%eax
  801bac:	01 c0                	add    %eax,%eax
  801bae:	01 d0                	add    %edx,%eax
  801bb0:	c1 e0 02             	shl    $0x2,%eax
  801bb3:	05 20 31 80 00       	add    $0x803120,%eax
  801bb8:	8b 00                	mov    (%eax),%eax
  801bba:	83 ec 08             	sub    $0x8,%esp
  801bbd:	ff 75 08             	pushl  0x8(%ebp)
  801bc0:	50                   	push   %eax
  801bc1:	e8 48 04 00 00       	call   80200e <sys_allocateMem>
  801bc6:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801bc9:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801bd0:	eb 78                	jmp    801c4a <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801bd2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801bd5:	89 d0                	mov    %edx,%eax
  801bd7:	01 c0                	add    %eax,%eax
  801bd9:	01 d0                	add    %edx,%eax
  801bdb:	c1 e0 02             	shl    $0x2,%eax
  801bde:	05 20 31 80 00       	add    $0x803120,%eax
  801be3:	8b 00                	mov    (%eax),%eax
  801be5:	83 ec 04             	sub    $0x4,%esp
  801be8:	50                   	push   %eax
  801be9:	ff 75 b0             	pushl  -0x50(%ebp)
  801bec:	68 70 2e 80 00       	push   $0x802e70
  801bf1:	e8 50 ee ff ff       	call   800a46 <cprintf>
  801bf6:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801bf9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801bfc:	89 d0                	mov    %edx,%eax
  801bfe:	01 c0                	add    %eax,%eax
  801c00:	01 d0                	add    %edx,%eax
  801c02:	c1 e0 02             	shl    $0x2,%eax
  801c05:	05 24 31 80 00       	add    $0x803124,%eax
  801c0a:	8b 00                	mov    (%eax),%eax
  801c0c:	83 ec 04             	sub    $0x4,%esp
  801c0f:	50                   	push   %eax
  801c10:	ff 75 b0             	pushl  -0x50(%ebp)
  801c13:	68 85 2e 80 00       	push   $0x802e85
  801c18:	e8 29 ee ff ff       	call   800a46 <cprintf>
  801c1d:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801c20:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801c23:	89 d0                	mov    %edx,%eax
  801c25:	01 c0                	add    %eax,%eax
  801c27:	01 d0                	add    %edx,%eax
  801c29:	c1 e0 02             	shl    $0x2,%eax
  801c2c:	05 28 31 80 00       	add    $0x803128,%eax
  801c31:	8b 00                	mov    (%eax),%eax
  801c33:	83 ec 04             	sub    $0x4,%esp
  801c36:	50                   	push   %eax
  801c37:	ff 75 b0             	pushl  -0x50(%ebp)
  801c3a:	68 98 2e 80 00       	push   $0x802e98
  801c3f:	e8 02 ee ff ff       	call   800a46 <cprintf>
  801c44:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801c47:	ff 45 b0             	incl   -0x50(%ebp)
  801c4a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801c4d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c50:	7c 80                	jl     801bd2 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801c52:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801c55:	89 d0                	mov    %edx,%eax
  801c57:	01 c0                	add    %eax,%eax
  801c59:	01 d0                	add    %edx,%eax
  801c5b:	c1 e0 02             	shl    $0x2,%eax
  801c5e:	05 20 31 80 00       	add    $0x803120,%eax
  801c63:	8b 00                	mov    (%eax),%eax
  801c65:	83 ec 08             	sub    $0x8,%esp
  801c68:	50                   	push   %eax
  801c69:	68 ac 2e 80 00       	push   $0x802eac
  801c6e:	e8 d3 ed ff ff       	call   800a46 <cprintf>
  801c73:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801c76:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801c79:	89 d0                	mov    %edx,%eax
  801c7b:	01 c0                	add    %eax,%eax
  801c7d:	01 d0                	add    %edx,%eax
  801c7f:	c1 e0 02             	shl    $0x2,%eax
  801c82:	05 20 31 80 00       	add    $0x803120,%eax
  801c87:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801c97:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801c9e:	eb 4b                	jmp    801ceb <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ca3:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801caa:	89 c2                	mov    %eax,%edx
  801cac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801caf:	39 c2                	cmp    %eax,%edx
  801cb1:	7f 35                	jg     801ce8 <free+0x5d>
  801cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb6:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801cbd:	89 c2                	mov    %eax,%edx
  801cbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cc2:	39 c2                	cmp    %eax,%edx
  801cc4:	7e 22                	jle    801ce8 <free+0x5d>
				start=arr_add[i].start;
  801cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc9:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801cd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd6:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801cdd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801ce0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ce3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801ce6:	eb 0d                	jmp    801cf5 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801ce8:	ff 45 ec             	incl   -0x14(%ebp)
  801ceb:	a1 28 30 80 00       	mov    0x803028,%eax
  801cf0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801cf3:	7c ab                	jl     801ca0 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf8:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d02:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801d09:	29 c2                	sub    %eax,%edx
  801d0b:	89 d0                	mov    %edx,%eax
  801d0d:	83 ec 08             	sub    $0x8,%esp
  801d10:	50                   	push   %eax
  801d11:	ff 75 f4             	pushl  -0xc(%ebp)
  801d14:	e8 d9 02 00 00       	call   801ff2 <sys_freeMem>
  801d19:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d22:	eb 2d                	jmp    801d51 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801d24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d27:	40                   	inc    %eax
  801d28:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801d2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d32:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801d39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d3c:	40                   	inc    %eax
  801d3d:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801d44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d47:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801d4e:	ff 45 e8             	incl   -0x18(%ebp)
  801d51:	a1 28 30 80 00       	mov    0x803028,%eax
  801d56:	48                   	dec    %eax
  801d57:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801d5a:	7f c8                	jg     801d24 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801d5c:	a1 28 30 80 00       	mov    0x803028,%eax
  801d61:	48                   	dec    %eax
  801d62:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801d67:	90                   	nop
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 18             	sub    $0x18,%esp
  801d70:	8b 45 10             	mov    0x10(%ebp),%eax
  801d73:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801d76:	83 ec 04             	sub    $0x4,%esp
  801d79:	68 c8 2e 80 00       	push   $0x802ec8
  801d7e:	68 18 01 00 00       	push   $0x118
  801d83:	68 eb 2e 80 00       	push   $0x802eeb
  801d88:	e8 17 ea ff ff       	call   8007a4 <_panic>

00801d8d <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d93:	83 ec 04             	sub    $0x4,%esp
  801d96:	68 c8 2e 80 00       	push   $0x802ec8
  801d9b:	68 1e 01 00 00       	push   $0x11e
  801da0:	68 eb 2e 80 00       	push   $0x802eeb
  801da5:	e8 fa e9 ff ff       	call   8007a4 <_panic>

00801daa <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801db0:	83 ec 04             	sub    $0x4,%esp
  801db3:	68 c8 2e 80 00       	push   $0x802ec8
  801db8:	68 24 01 00 00       	push   $0x124
  801dbd:	68 eb 2e 80 00       	push   $0x802eeb
  801dc2:	e8 dd e9 ff ff       	call   8007a4 <_panic>

00801dc7 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801dcd:	83 ec 04             	sub    $0x4,%esp
  801dd0:	68 c8 2e 80 00       	push   $0x802ec8
  801dd5:	68 29 01 00 00       	push   $0x129
  801dda:	68 eb 2e 80 00       	push   $0x802eeb
  801ddf:	e8 c0 e9 ff ff       	call   8007a4 <_panic>

00801de4 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801dea:	83 ec 04             	sub    $0x4,%esp
  801ded:	68 c8 2e 80 00       	push   $0x802ec8
  801df2:	68 2f 01 00 00       	push   $0x12f
  801df7:	68 eb 2e 80 00       	push   $0x802eeb
  801dfc:	e8 a3 e9 ff ff       	call   8007a4 <_panic>

00801e01 <shrink>:
}
void shrink(uint32 newSize)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e07:	83 ec 04             	sub    $0x4,%esp
  801e0a:	68 c8 2e 80 00       	push   $0x802ec8
  801e0f:	68 33 01 00 00       	push   $0x133
  801e14:	68 eb 2e 80 00       	push   $0x802eeb
  801e19:	e8 86 e9 ff ff       	call   8007a4 <_panic>

00801e1e <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e24:	83 ec 04             	sub    $0x4,%esp
  801e27:	68 c8 2e 80 00       	push   $0x802ec8
  801e2c:	68 38 01 00 00       	push   $0x138
  801e31:	68 eb 2e 80 00       	push   $0x802eeb
  801e36:	e8 69 e9 ff ff       	call   8007a4 <_panic>

00801e3b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	57                   	push   %edi
  801e3f:	56                   	push   %esi
  801e40:	53                   	push   %ebx
  801e41:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e4d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e50:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e53:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e56:	cd 30                	int    $0x30
  801e58:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e5e:	83 c4 10             	add    $0x10,%esp
  801e61:	5b                   	pop    %ebx
  801e62:	5e                   	pop    %esi
  801e63:	5f                   	pop    %edi
  801e64:	5d                   	pop    %ebp
  801e65:	c3                   	ret    

00801e66 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e72:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	52                   	push   %edx
  801e7e:	ff 75 0c             	pushl  0xc(%ebp)
  801e81:	50                   	push   %eax
  801e82:	6a 00                	push   $0x0
  801e84:	e8 b2 ff ff ff       	call   801e3b <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
}
  801e8c:	90                   	nop
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_cgetc>:

int
sys_cgetc(void)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 01                	push   $0x1
  801e9e:	e8 98 ff ff ff       	call   801e3b <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	50                   	push   %eax
  801eb7:	6a 05                	push   $0x5
  801eb9:	e8 7d ff ff ff       	call   801e3b <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 02                	push   $0x2
  801ed2:	e8 64 ff ff ff       	call   801e3b <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 03                	push   $0x3
  801eeb:	e8 4b ff ff ff       	call   801e3b <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 04                	push   $0x4
  801f04:	e8 32 ff ff ff       	call   801e3b <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
}
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <sys_env_exit>:


void sys_env_exit(void)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 06                	push   $0x6
  801f1d:	e8 19 ff ff ff       	call   801e3b <syscall>
  801f22:	83 c4 18             	add    $0x18,%esp
}
  801f25:	90                   	nop
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	52                   	push   %edx
  801f38:	50                   	push   %eax
  801f39:	6a 07                	push   $0x7
  801f3b:	e8 fb fe ff ff       	call   801e3b <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	56                   	push   %esi
  801f49:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f4a:	8b 75 18             	mov    0x18(%ebp),%esi
  801f4d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f50:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f56:	8b 45 08             	mov    0x8(%ebp),%eax
  801f59:	56                   	push   %esi
  801f5a:	53                   	push   %ebx
  801f5b:	51                   	push   %ecx
  801f5c:	52                   	push   %edx
  801f5d:	50                   	push   %eax
  801f5e:	6a 08                	push   $0x8
  801f60:	e8 d6 fe ff ff       	call   801e3b <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f6b:	5b                   	pop    %ebx
  801f6c:	5e                   	pop    %esi
  801f6d:	5d                   	pop    %ebp
  801f6e:	c3                   	ret    

00801f6f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	52                   	push   %edx
  801f7f:	50                   	push   %eax
  801f80:	6a 09                	push   $0x9
  801f82:	e8 b4 fe ff ff       	call   801e3b <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	ff 75 0c             	pushl  0xc(%ebp)
  801f98:	ff 75 08             	pushl  0x8(%ebp)
  801f9b:	6a 0a                	push   $0xa
  801f9d:	e8 99 fe ff ff       	call   801e3b <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 0b                	push   $0xb
  801fb6:	e8 80 fe ff ff       	call   801e3b <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 0c                	push   $0xc
  801fcf:	e8 67 fe ff ff       	call   801e3b <syscall>
  801fd4:	83 c4 18             	add    $0x18,%esp
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 0d                	push   $0xd
  801fe8:	e8 4e fe ff ff       	call   801e3b <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
}
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	ff 75 0c             	pushl  0xc(%ebp)
  801ffe:	ff 75 08             	pushl  0x8(%ebp)
  802001:	6a 11                	push   $0x11
  802003:	e8 33 fe ff ff       	call   801e3b <syscall>
  802008:	83 c4 18             	add    $0x18,%esp
	return;
  80200b:	90                   	nop
}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	ff 75 0c             	pushl  0xc(%ebp)
  80201a:	ff 75 08             	pushl  0x8(%ebp)
  80201d:	6a 12                	push   $0x12
  80201f:	e8 17 fe ff ff       	call   801e3b <syscall>
  802024:	83 c4 18             	add    $0x18,%esp
	return ;
  802027:	90                   	nop
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 0e                	push   $0xe
  802039:	e8 fd fd ff ff       	call   801e3b <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	ff 75 08             	pushl  0x8(%ebp)
  802051:	6a 0f                	push   $0xf
  802053:	e8 e3 fd ff ff       	call   801e3b <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 10                	push   $0x10
  80206c:	e8 ca fd ff ff       	call   801e3b <syscall>
  802071:	83 c4 18             	add    $0x18,%esp
}
  802074:	90                   	nop
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 14                	push   $0x14
  802086:	e8 b0 fd ff ff       	call   801e3b <syscall>
  80208b:	83 c4 18             	add    $0x18,%esp
}
  80208e:	90                   	nop
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 15                	push   $0x15
  8020a0:	e8 96 fd ff ff       	call   801e3b <syscall>
  8020a5:	83 c4 18             	add    $0x18,%esp
}
  8020a8:	90                   	nop
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <sys_cputc>:


void
sys_cputc(const char c)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	83 ec 04             	sub    $0x4,%esp
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020b7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	50                   	push   %eax
  8020c4:	6a 16                	push   $0x16
  8020c6:	e8 70 fd ff ff       	call   801e3b <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
}
  8020ce:	90                   	nop
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 17                	push   $0x17
  8020e0:	e8 56 fd ff ff       	call   801e3b <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
}
  8020e8:	90                   	nop
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	ff 75 0c             	pushl  0xc(%ebp)
  8020fa:	50                   	push   %eax
  8020fb:	6a 18                	push   $0x18
  8020fd:	e8 39 fd ff ff       	call   801e3b <syscall>
  802102:	83 c4 18             	add    $0x18,%esp
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80210a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	52                   	push   %edx
  802117:	50                   	push   %eax
  802118:	6a 1b                	push   $0x1b
  80211a:	e8 1c fd ff ff       	call   801e3b <syscall>
  80211f:	83 c4 18             	add    $0x18,%esp
}
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802127:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	52                   	push   %edx
  802134:	50                   	push   %eax
  802135:	6a 19                	push   $0x19
  802137:	e8 ff fc ff ff       	call   801e3b <syscall>
  80213c:	83 c4 18             	add    $0x18,%esp
}
  80213f:	90                   	nop
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802145:	8b 55 0c             	mov    0xc(%ebp),%edx
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	52                   	push   %edx
  802152:	50                   	push   %eax
  802153:	6a 1a                	push   $0x1a
  802155:	e8 e1 fc ff ff       	call   801e3b <syscall>
  80215a:	83 c4 18             	add    $0x18,%esp
}
  80215d:	90                   	nop
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 04             	sub    $0x4,%esp
  802166:	8b 45 10             	mov    0x10(%ebp),%eax
  802169:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80216c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80216f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	6a 00                	push   $0x0
  802178:	51                   	push   %ecx
  802179:	52                   	push   %edx
  80217a:	ff 75 0c             	pushl  0xc(%ebp)
  80217d:	50                   	push   %eax
  80217e:	6a 1c                	push   $0x1c
  802180:	e8 b6 fc ff ff       	call   801e3b <syscall>
  802185:	83 c4 18             	add    $0x18,%esp
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80218d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	52                   	push   %edx
  80219a:	50                   	push   %eax
  80219b:	6a 1d                	push   $0x1d
  80219d:	e8 99 fc ff ff       	call   801e3b <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	51                   	push   %ecx
  8021b8:	52                   	push   %edx
  8021b9:	50                   	push   %eax
  8021ba:	6a 1e                	push   $0x1e
  8021bc:	e8 7a fc ff ff       	call   801e3b <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	52                   	push   %edx
  8021d6:	50                   	push   %eax
  8021d7:	6a 1f                	push   $0x1f
  8021d9:	e8 5d fc ff ff       	call   801e3b <syscall>
  8021de:	83 c4 18             	add    $0x18,%esp
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 20                	push   $0x20
  8021f2:	e8 44 fc ff ff       	call   801e3b <syscall>
  8021f7:	83 c4 18             	add    $0x18,%esp
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802202:	6a 00                	push   $0x0
  802204:	ff 75 14             	pushl  0x14(%ebp)
  802207:	ff 75 10             	pushl  0x10(%ebp)
  80220a:	ff 75 0c             	pushl  0xc(%ebp)
  80220d:	50                   	push   %eax
  80220e:	6a 21                	push   $0x21
  802210:	e8 26 fc ff ff       	call   801e3b <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	50                   	push   %eax
  802229:	6a 22                	push   $0x22
  80222b:	e8 0b fc ff ff       	call   801e3b <syscall>
  802230:	83 c4 18             	add    $0x18,%esp
}
  802233:	90                   	nop
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	50                   	push   %eax
  802245:	6a 23                	push   $0x23
  802247:	e8 ef fb ff ff       	call   801e3b <syscall>
  80224c:	83 c4 18             	add    $0x18,%esp
}
  80224f:	90                   	nop
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802258:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80225b:	8d 50 04             	lea    0x4(%eax),%edx
  80225e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	52                   	push   %edx
  802268:	50                   	push   %eax
  802269:	6a 24                	push   $0x24
  80226b:	e8 cb fb ff ff       	call   801e3b <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
	return result;
  802273:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802276:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802279:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80227c:	89 01                	mov    %eax,(%ecx)
  80227e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	c9                   	leave  
  802285:	c2 04 00             	ret    $0x4

00802288 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	ff 75 10             	pushl  0x10(%ebp)
  802292:	ff 75 0c             	pushl  0xc(%ebp)
  802295:	ff 75 08             	pushl  0x8(%ebp)
  802298:	6a 13                	push   $0x13
  80229a:	e8 9c fb ff ff       	call   801e3b <syscall>
  80229f:	83 c4 18             	add    $0x18,%esp
	return ;
  8022a2:	90                   	nop
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 25                	push   $0x25
  8022b4:	e8 82 fb ff ff       	call   801e3b <syscall>
  8022b9:	83 c4 18             	add    $0x18,%esp
}
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	83 ec 04             	sub    $0x4,%esp
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022ca:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	50                   	push   %eax
  8022d7:	6a 26                	push   $0x26
  8022d9:	e8 5d fb ff ff       	call   801e3b <syscall>
  8022de:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e1:	90                   	nop
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <rsttst>:
void rsttst()
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 28                	push   $0x28
  8022f3:	e8 43 fb ff ff       	call   801e3b <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8022fb:	90                   	nop
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 04             	sub    $0x4,%esp
  802304:	8b 45 14             	mov    0x14(%ebp),%eax
  802307:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80230a:	8b 55 18             	mov    0x18(%ebp),%edx
  80230d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802311:	52                   	push   %edx
  802312:	50                   	push   %eax
  802313:	ff 75 10             	pushl  0x10(%ebp)
  802316:	ff 75 0c             	pushl  0xc(%ebp)
  802319:	ff 75 08             	pushl  0x8(%ebp)
  80231c:	6a 27                	push   $0x27
  80231e:	e8 18 fb ff ff       	call   801e3b <syscall>
  802323:	83 c4 18             	add    $0x18,%esp
	return ;
  802326:	90                   	nop
}
  802327:	c9                   	leave  
  802328:	c3                   	ret    

00802329 <chktst>:
void chktst(uint32 n)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	ff 75 08             	pushl  0x8(%ebp)
  802337:	6a 29                	push   $0x29
  802339:	e8 fd fa ff ff       	call   801e3b <syscall>
  80233e:	83 c4 18             	add    $0x18,%esp
	return ;
  802341:	90                   	nop
}
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <inctst>:

void inctst()
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 2a                	push   $0x2a
  802353:	e8 e3 fa ff ff       	call   801e3b <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
	return ;
  80235b:	90                   	nop
}
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <gettst>:
uint32 gettst()
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 2b                	push   $0x2b
  80236d:	e8 c9 fa ff ff       	call   801e3b <syscall>
  802372:	83 c4 18             	add    $0x18,%esp
}
  802375:	c9                   	leave  
  802376:	c3                   	ret    

00802377 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
  80237a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 2c                	push   $0x2c
  802389:	e8 ad fa ff ff       	call   801e3b <syscall>
  80238e:	83 c4 18             	add    $0x18,%esp
  802391:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802394:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802398:	75 07                	jne    8023a1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80239a:	b8 01 00 00 00       	mov    $0x1,%eax
  80239f:	eb 05                	jmp    8023a6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
  8023ab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 2c                	push   $0x2c
  8023ba:	e8 7c fa ff ff       	call   801e3b <syscall>
  8023bf:	83 c4 18             	add    $0x18,%esp
  8023c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023c5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023c9:	75 07                	jne    8023d2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d0:	eb 05                	jmp    8023d7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
  8023dc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 2c                	push   $0x2c
  8023eb:	e8 4b fa ff ff       	call   801e3b <syscall>
  8023f0:	83 c4 18             	add    $0x18,%esp
  8023f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023f6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023fa:	75 07                	jne    802403 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023fc:	b8 01 00 00 00       	mov    $0x1,%eax
  802401:	eb 05                	jmp    802408 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802403:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802408:	c9                   	leave  
  802409:	c3                   	ret    

0080240a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
  80240d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 2c                	push   $0x2c
  80241c:	e8 1a fa ff ff       	call   801e3b <syscall>
  802421:	83 c4 18             	add    $0x18,%esp
  802424:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802427:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80242b:	75 07                	jne    802434 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80242d:	b8 01 00 00 00       	mov    $0x1,%eax
  802432:	eb 05                	jmp    802439 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802434:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802439:	c9                   	leave  
  80243a:	c3                   	ret    

0080243b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	ff 75 08             	pushl  0x8(%ebp)
  802449:	6a 2d                	push   $0x2d
  80244b:	e8 eb f9 ff ff       	call   801e3b <syscall>
  802450:	83 c4 18             	add    $0x18,%esp
	return ;
  802453:	90                   	nop
}
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
  802459:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80245a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80245d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802460:	8b 55 0c             	mov    0xc(%ebp),%edx
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	6a 00                	push   $0x0
  802468:	53                   	push   %ebx
  802469:	51                   	push   %ecx
  80246a:	52                   	push   %edx
  80246b:	50                   	push   %eax
  80246c:	6a 2e                	push   $0x2e
  80246e:	e8 c8 f9 ff ff       	call   801e3b <syscall>
  802473:	83 c4 18             	add    $0x18,%esp
}
  802476:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802479:	c9                   	leave  
  80247a:	c3                   	ret    

0080247b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80247e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802481:	8b 45 08             	mov    0x8(%ebp),%eax
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	52                   	push   %edx
  80248b:	50                   	push   %eax
  80248c:	6a 2f                	push   $0x2f
  80248e:	e8 a8 f9 ff ff       	call   801e3b <syscall>
  802493:	83 c4 18             	add    $0x18,%esp
}
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <__udivdi3>:
  802498:	55                   	push   %ebp
  802499:	57                   	push   %edi
  80249a:	56                   	push   %esi
  80249b:	53                   	push   %ebx
  80249c:	83 ec 1c             	sub    $0x1c,%esp
  80249f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8024a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8024a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024af:	89 ca                	mov    %ecx,%edx
  8024b1:	89 f8                	mov    %edi,%eax
  8024b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8024b7:	85 f6                	test   %esi,%esi
  8024b9:	75 2d                	jne    8024e8 <__udivdi3+0x50>
  8024bb:	39 cf                	cmp    %ecx,%edi
  8024bd:	77 65                	ja     802524 <__udivdi3+0x8c>
  8024bf:	89 fd                	mov    %edi,%ebp
  8024c1:	85 ff                	test   %edi,%edi
  8024c3:	75 0b                	jne    8024d0 <__udivdi3+0x38>
  8024c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ca:	31 d2                	xor    %edx,%edx
  8024cc:	f7 f7                	div    %edi
  8024ce:	89 c5                	mov    %eax,%ebp
  8024d0:	31 d2                	xor    %edx,%edx
  8024d2:	89 c8                	mov    %ecx,%eax
  8024d4:	f7 f5                	div    %ebp
  8024d6:	89 c1                	mov    %eax,%ecx
  8024d8:	89 d8                	mov    %ebx,%eax
  8024da:	f7 f5                	div    %ebp
  8024dc:	89 cf                	mov    %ecx,%edi
  8024de:	89 fa                	mov    %edi,%edx
  8024e0:	83 c4 1c             	add    $0x1c,%esp
  8024e3:	5b                   	pop    %ebx
  8024e4:	5e                   	pop    %esi
  8024e5:	5f                   	pop    %edi
  8024e6:	5d                   	pop    %ebp
  8024e7:	c3                   	ret    
  8024e8:	39 ce                	cmp    %ecx,%esi
  8024ea:	77 28                	ja     802514 <__udivdi3+0x7c>
  8024ec:	0f bd fe             	bsr    %esi,%edi
  8024ef:	83 f7 1f             	xor    $0x1f,%edi
  8024f2:	75 40                	jne    802534 <__udivdi3+0x9c>
  8024f4:	39 ce                	cmp    %ecx,%esi
  8024f6:	72 0a                	jb     802502 <__udivdi3+0x6a>
  8024f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8024fc:	0f 87 9e 00 00 00    	ja     8025a0 <__udivdi3+0x108>
  802502:	b8 01 00 00 00       	mov    $0x1,%eax
  802507:	89 fa                	mov    %edi,%edx
  802509:	83 c4 1c             	add    $0x1c,%esp
  80250c:	5b                   	pop    %ebx
  80250d:	5e                   	pop    %esi
  80250e:	5f                   	pop    %edi
  80250f:	5d                   	pop    %ebp
  802510:	c3                   	ret    
  802511:	8d 76 00             	lea    0x0(%esi),%esi
  802514:	31 ff                	xor    %edi,%edi
  802516:	31 c0                	xor    %eax,%eax
  802518:	89 fa                	mov    %edi,%edx
  80251a:	83 c4 1c             	add    $0x1c,%esp
  80251d:	5b                   	pop    %ebx
  80251e:	5e                   	pop    %esi
  80251f:	5f                   	pop    %edi
  802520:	5d                   	pop    %ebp
  802521:	c3                   	ret    
  802522:	66 90                	xchg   %ax,%ax
  802524:	89 d8                	mov    %ebx,%eax
  802526:	f7 f7                	div    %edi
  802528:	31 ff                	xor    %edi,%edi
  80252a:	89 fa                	mov    %edi,%edx
  80252c:	83 c4 1c             	add    $0x1c,%esp
  80252f:	5b                   	pop    %ebx
  802530:	5e                   	pop    %esi
  802531:	5f                   	pop    %edi
  802532:	5d                   	pop    %ebp
  802533:	c3                   	ret    
  802534:	bd 20 00 00 00       	mov    $0x20,%ebp
  802539:	89 eb                	mov    %ebp,%ebx
  80253b:	29 fb                	sub    %edi,%ebx
  80253d:	89 f9                	mov    %edi,%ecx
  80253f:	d3 e6                	shl    %cl,%esi
  802541:	89 c5                	mov    %eax,%ebp
  802543:	88 d9                	mov    %bl,%cl
  802545:	d3 ed                	shr    %cl,%ebp
  802547:	89 e9                	mov    %ebp,%ecx
  802549:	09 f1                	or     %esi,%ecx
  80254b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80254f:	89 f9                	mov    %edi,%ecx
  802551:	d3 e0                	shl    %cl,%eax
  802553:	89 c5                	mov    %eax,%ebp
  802555:	89 d6                	mov    %edx,%esi
  802557:	88 d9                	mov    %bl,%cl
  802559:	d3 ee                	shr    %cl,%esi
  80255b:	89 f9                	mov    %edi,%ecx
  80255d:	d3 e2                	shl    %cl,%edx
  80255f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802563:	88 d9                	mov    %bl,%cl
  802565:	d3 e8                	shr    %cl,%eax
  802567:	09 c2                	or     %eax,%edx
  802569:	89 d0                	mov    %edx,%eax
  80256b:	89 f2                	mov    %esi,%edx
  80256d:	f7 74 24 0c          	divl   0xc(%esp)
  802571:	89 d6                	mov    %edx,%esi
  802573:	89 c3                	mov    %eax,%ebx
  802575:	f7 e5                	mul    %ebp
  802577:	39 d6                	cmp    %edx,%esi
  802579:	72 19                	jb     802594 <__udivdi3+0xfc>
  80257b:	74 0b                	je     802588 <__udivdi3+0xf0>
  80257d:	89 d8                	mov    %ebx,%eax
  80257f:	31 ff                	xor    %edi,%edi
  802581:	e9 58 ff ff ff       	jmp    8024de <__udivdi3+0x46>
  802586:	66 90                	xchg   %ax,%ax
  802588:	8b 54 24 08          	mov    0x8(%esp),%edx
  80258c:	89 f9                	mov    %edi,%ecx
  80258e:	d3 e2                	shl    %cl,%edx
  802590:	39 c2                	cmp    %eax,%edx
  802592:	73 e9                	jae    80257d <__udivdi3+0xe5>
  802594:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802597:	31 ff                	xor    %edi,%edi
  802599:	e9 40 ff ff ff       	jmp    8024de <__udivdi3+0x46>
  80259e:	66 90                	xchg   %ax,%ax
  8025a0:	31 c0                	xor    %eax,%eax
  8025a2:	e9 37 ff ff ff       	jmp    8024de <__udivdi3+0x46>
  8025a7:	90                   	nop

008025a8 <__umoddi3>:
  8025a8:	55                   	push   %ebp
  8025a9:	57                   	push   %edi
  8025aa:	56                   	push   %esi
  8025ab:	53                   	push   %ebx
  8025ac:	83 ec 1c             	sub    $0x1c,%esp
  8025af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8025b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8025b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025c7:	89 f3                	mov    %esi,%ebx
  8025c9:	89 fa                	mov    %edi,%edx
  8025cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025cf:	89 34 24             	mov    %esi,(%esp)
  8025d2:	85 c0                	test   %eax,%eax
  8025d4:	75 1a                	jne    8025f0 <__umoddi3+0x48>
  8025d6:	39 f7                	cmp    %esi,%edi
  8025d8:	0f 86 a2 00 00 00    	jbe    802680 <__umoddi3+0xd8>
  8025de:	89 c8                	mov    %ecx,%eax
  8025e0:	89 f2                	mov    %esi,%edx
  8025e2:	f7 f7                	div    %edi
  8025e4:	89 d0                	mov    %edx,%eax
  8025e6:	31 d2                	xor    %edx,%edx
  8025e8:	83 c4 1c             	add    $0x1c,%esp
  8025eb:	5b                   	pop    %ebx
  8025ec:	5e                   	pop    %esi
  8025ed:	5f                   	pop    %edi
  8025ee:	5d                   	pop    %ebp
  8025ef:	c3                   	ret    
  8025f0:	39 f0                	cmp    %esi,%eax
  8025f2:	0f 87 ac 00 00 00    	ja     8026a4 <__umoddi3+0xfc>
  8025f8:	0f bd e8             	bsr    %eax,%ebp
  8025fb:	83 f5 1f             	xor    $0x1f,%ebp
  8025fe:	0f 84 ac 00 00 00    	je     8026b0 <__umoddi3+0x108>
  802604:	bf 20 00 00 00       	mov    $0x20,%edi
  802609:	29 ef                	sub    %ebp,%edi
  80260b:	89 fe                	mov    %edi,%esi
  80260d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802611:	89 e9                	mov    %ebp,%ecx
  802613:	d3 e0                	shl    %cl,%eax
  802615:	89 d7                	mov    %edx,%edi
  802617:	89 f1                	mov    %esi,%ecx
  802619:	d3 ef                	shr    %cl,%edi
  80261b:	09 c7                	or     %eax,%edi
  80261d:	89 e9                	mov    %ebp,%ecx
  80261f:	d3 e2                	shl    %cl,%edx
  802621:	89 14 24             	mov    %edx,(%esp)
  802624:	89 d8                	mov    %ebx,%eax
  802626:	d3 e0                	shl    %cl,%eax
  802628:	89 c2                	mov    %eax,%edx
  80262a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80262e:	d3 e0                	shl    %cl,%eax
  802630:	89 44 24 04          	mov    %eax,0x4(%esp)
  802634:	8b 44 24 08          	mov    0x8(%esp),%eax
  802638:	89 f1                	mov    %esi,%ecx
  80263a:	d3 e8                	shr    %cl,%eax
  80263c:	09 d0                	or     %edx,%eax
  80263e:	d3 eb                	shr    %cl,%ebx
  802640:	89 da                	mov    %ebx,%edx
  802642:	f7 f7                	div    %edi
  802644:	89 d3                	mov    %edx,%ebx
  802646:	f7 24 24             	mull   (%esp)
  802649:	89 c6                	mov    %eax,%esi
  80264b:	89 d1                	mov    %edx,%ecx
  80264d:	39 d3                	cmp    %edx,%ebx
  80264f:	0f 82 87 00 00 00    	jb     8026dc <__umoddi3+0x134>
  802655:	0f 84 91 00 00 00    	je     8026ec <__umoddi3+0x144>
  80265b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80265f:	29 f2                	sub    %esi,%edx
  802661:	19 cb                	sbb    %ecx,%ebx
  802663:	89 d8                	mov    %ebx,%eax
  802665:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802669:	d3 e0                	shl    %cl,%eax
  80266b:	89 e9                	mov    %ebp,%ecx
  80266d:	d3 ea                	shr    %cl,%edx
  80266f:	09 d0                	or     %edx,%eax
  802671:	89 e9                	mov    %ebp,%ecx
  802673:	d3 eb                	shr    %cl,%ebx
  802675:	89 da                	mov    %ebx,%edx
  802677:	83 c4 1c             	add    $0x1c,%esp
  80267a:	5b                   	pop    %ebx
  80267b:	5e                   	pop    %esi
  80267c:	5f                   	pop    %edi
  80267d:	5d                   	pop    %ebp
  80267e:	c3                   	ret    
  80267f:	90                   	nop
  802680:	89 fd                	mov    %edi,%ebp
  802682:	85 ff                	test   %edi,%edi
  802684:	75 0b                	jne    802691 <__umoddi3+0xe9>
  802686:	b8 01 00 00 00       	mov    $0x1,%eax
  80268b:	31 d2                	xor    %edx,%edx
  80268d:	f7 f7                	div    %edi
  80268f:	89 c5                	mov    %eax,%ebp
  802691:	89 f0                	mov    %esi,%eax
  802693:	31 d2                	xor    %edx,%edx
  802695:	f7 f5                	div    %ebp
  802697:	89 c8                	mov    %ecx,%eax
  802699:	f7 f5                	div    %ebp
  80269b:	89 d0                	mov    %edx,%eax
  80269d:	e9 44 ff ff ff       	jmp    8025e6 <__umoddi3+0x3e>
  8026a2:	66 90                	xchg   %ax,%ax
  8026a4:	89 c8                	mov    %ecx,%eax
  8026a6:	89 f2                	mov    %esi,%edx
  8026a8:	83 c4 1c             	add    $0x1c,%esp
  8026ab:	5b                   	pop    %ebx
  8026ac:	5e                   	pop    %esi
  8026ad:	5f                   	pop    %edi
  8026ae:	5d                   	pop    %ebp
  8026af:	c3                   	ret    
  8026b0:	3b 04 24             	cmp    (%esp),%eax
  8026b3:	72 06                	jb     8026bb <__umoddi3+0x113>
  8026b5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8026b9:	77 0f                	ja     8026ca <__umoddi3+0x122>
  8026bb:	89 f2                	mov    %esi,%edx
  8026bd:	29 f9                	sub    %edi,%ecx
  8026bf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8026c3:	89 14 24             	mov    %edx,(%esp)
  8026c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8026ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026ce:	8b 14 24             	mov    (%esp),%edx
  8026d1:	83 c4 1c             	add    $0x1c,%esp
  8026d4:	5b                   	pop    %ebx
  8026d5:	5e                   	pop    %esi
  8026d6:	5f                   	pop    %edi
  8026d7:	5d                   	pop    %ebp
  8026d8:	c3                   	ret    
  8026d9:	8d 76 00             	lea    0x0(%esi),%esi
  8026dc:	2b 04 24             	sub    (%esp),%eax
  8026df:	19 fa                	sbb    %edi,%edx
  8026e1:	89 d1                	mov    %edx,%ecx
  8026e3:	89 c6                	mov    %eax,%esi
  8026e5:	e9 71 ff ff ff       	jmp    80265b <__umoddi3+0xb3>
  8026ea:	66 90                	xchg   %ax,%ax
  8026ec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8026f0:	72 ea                	jb     8026dc <__umoddi3+0x134>
  8026f2:	89 d9                	mov    %ebx,%ecx
  8026f4:	e9 62 ff ff ff       	jmp    80265b <__umoddi3+0xb3>
