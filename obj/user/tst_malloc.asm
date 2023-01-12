
obj/user/tst_malloc:     file format elf32-i386


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
  800031:	e8 ee 03 00 00       	call   800424 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
///MAKE SURE PAGE_WS_MAX_SIZE = 15
///MAKE SURE TABLE_WS_MAX_SIZE = 15
#include <inc/lib.h>

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
//	cprintf("envID = %d\n",envID);

	
	

	int Mega = 1024*1024;
  80003f:	c7 45 f4 00 00 10 00 	movl   $0x100000,-0xc(%ebp)
	int kilo = 1024;
  800046:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)


	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80004d:	e8 9d 1d 00 00       	call   801def <sys_pf_calculate_allocated_pages>
  800052:	89 45 ec             	mov    %eax,-0x14(%ebp)
	{
		int freeFrames = sys_calculate_free_frames() ;
  800055:	e8 12 1d 00 00       	call   801d6c <sys_calculate_free_frames>
  80005a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if ((uint32)malloc(2*Mega) != USER_HEAP_START) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80005d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800060:	01 c0                	add    %eax,%eax
  800062:	83 ec 0c             	sub    $0xc,%esp
  800065:	50                   	push   %eax
  800066:	e8 2a 15 00 00       	call   801595 <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800073:	74 14                	je     800089 <_main+0x51>
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	68 e0 24 80 00       	push   $0x8024e0
  80007d:	6a 14                	push   $0x14
  80007f:	68 45 25 80 00       	push   $0x802545
  800084:	e8 e0 04 00 00       	call   800569 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1*1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800089:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80008c:	e8 db 1c 00 00       	call   801d6c <sys_calculate_free_frames>
  800091:	29 c3                	sub    %eax,%ebx
  800093:	89 d8                	mov    %ebx,%eax
  800095:	83 f8 01             	cmp    $0x1,%eax
  800098:	74 14                	je     8000ae <_main+0x76>
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	68 58 25 80 00       	push   $0x802558
  8000a2:	6a 15                	push   $0x15
  8000a4:	68 45 25 80 00       	push   $0x802545
  8000a9:	e8 bb 04 00 00       	call   800569 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 b9 1c 00 00       	call   801d6c <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if ((uint32)malloc(2*Mega) != USER_HEAP_START + 2*Mega) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8000b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b9:	01 c0                	add    %eax,%eax
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	50                   	push   %eax
  8000bf:	e8 d1 14 00 00       	call   801595 <malloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	01 c0                	add    %eax,%eax
  8000ce:	05 00 00 00 80       	add    $0x80000000,%eax
  8000d3:	39 c2                	cmp    %eax,%edx
  8000d5:	74 14                	je     8000eb <_main+0xb3>
  8000d7:	83 ec 04             	sub    $0x4,%esp
  8000da:	68 e0 24 80 00       	push   $0x8024e0
  8000df:	6a 18                	push   $0x18
  8000e1:	68 45 25 80 00       	push   $0x802545
  8000e6:	e8 7e 04 00 00       	call   800569 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000eb:	e8 7c 1c 00 00       	call   801d6c <sys_calculate_free_frames>
  8000f0:	89 c2                	mov    %eax,%edx
  8000f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f5:	39 c2                	cmp    %eax,%edx
  8000f7:	74 14                	je     80010d <_main+0xd5>
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 58 25 80 00       	push   $0x802558
  800101:	6a 19                	push   $0x19
  800103:	68 45 25 80 00       	push   $0x802545
  800108:	e8 5c 04 00 00       	call   800569 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80010d:	e8 5a 1c 00 00       	call   801d6c <sys_calculate_free_frames>
  800112:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if ((uint32)malloc(2*kilo) != USER_HEAP_START+ 4*Mega) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800115:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800118:	01 c0                	add    %eax,%eax
  80011a:	83 ec 0c             	sub    $0xc,%esp
  80011d:	50                   	push   %eax
  80011e:	e8 72 14 00 00       	call   801595 <malloc>
  800123:	83 c4 10             	add    $0x10,%esp
  800126:	89 c2                	mov    %eax,%edx
  800128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80012b:	c1 e0 02             	shl    $0x2,%eax
  80012e:	05 00 00 00 80       	add    $0x80000000,%eax
  800133:	39 c2                	cmp    %eax,%edx
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 e0 24 80 00       	push   $0x8024e0
  80013f:	6a 1c                	push   $0x1c
  800141:	68 45 25 80 00       	push   $0x802545
  800146:	e8 1e 04 00 00       	call   800569 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1*1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80014b:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80014e:	e8 19 1c 00 00       	call   801d6c <sys_calculate_free_frames>
  800153:	29 c3                	sub    %eax,%ebx
  800155:	89 d8                	mov    %ebx,%eax
  800157:	83 f8 01             	cmp    $0x1,%eax
  80015a:	74 14                	je     800170 <_main+0x138>
  80015c:	83 ec 04             	sub    $0x4,%esp
  80015f:	68 58 25 80 00       	push   $0x802558
  800164:	6a 1d                	push   $0x1d
  800166:	68 45 25 80 00       	push   $0x802545
  80016b:	e8 f9 03 00 00       	call   800569 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800170:	e8 f7 1b 00 00       	call   801d6c <sys_calculate_free_frames>
  800175:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if ((uint32)malloc(3*kilo) != USER_HEAP_START+ 4*Mega+ 2*kilo) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80017b:	89 c2                	mov    %eax,%edx
  80017d:	01 d2                	add    %edx,%edx
  80017f:	01 d0                	add    %edx,%eax
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	50                   	push   %eax
  800185:	e8 0b 14 00 00       	call   801595 <malloc>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	89 c2                	mov    %eax,%edx
  80018f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800192:	c1 e0 02             	shl    $0x2,%eax
  800195:	89 c1                	mov    %eax,%ecx
  800197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80019a:	01 c0                	add    %eax,%eax
  80019c:	01 c8                	add    %ecx,%eax
  80019e:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a3:	39 c2                	cmp    %eax,%edx
  8001a5:	74 14                	je     8001bb <_main+0x183>
  8001a7:	83 ec 04             	sub    $0x4,%esp
  8001aa:	68 e0 24 80 00       	push   $0x8024e0
  8001af:	6a 20                	push   $0x20
  8001b1:	68 45 25 80 00       	push   $0x802545
  8001b6:	e8 ae 03 00 00       	call   800569 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0)panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001bb:	e8 ac 1b 00 00       	call   801d6c <sys_calculate_free_frames>
  8001c0:	89 c2                	mov    %eax,%edx
  8001c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c5:	39 c2                	cmp    %eax,%edx
  8001c7:	74 14                	je     8001dd <_main+0x1a5>
  8001c9:	83 ec 04             	sub    $0x4,%esp
  8001cc:	68 58 25 80 00       	push   $0x802558
  8001d1:	6a 21                	push   $0x21
  8001d3:	68 45 25 80 00       	push   $0x802545
  8001d8:	e8 8c 03 00 00       	call   800569 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001dd:	e8 8a 1b 00 00       	call   801d6c <sys_calculate_free_frames>
  8001e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if ((uint32)malloc(3*Mega) != USER_HEAP_START + 4*Mega + 5*kilo)  panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8001e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e8:	89 c2                	mov    %eax,%edx
  8001ea:	01 d2                	add    %edx,%edx
  8001ec:	01 d0                	add    %edx,%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 9e 13 00 00       	call   801595 <malloc>
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	89 c1                	mov    %eax,%ecx
  8001fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001ff:	c1 e0 02             	shl    $0x2,%eax
  800202:	89 c3                	mov    %eax,%ebx
  800204:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800207:	89 d0                	mov    %edx,%eax
  800209:	c1 e0 02             	shl    $0x2,%eax
  80020c:	01 d0                	add    %edx,%eax
  80020e:	01 d8                	add    %ebx,%eax
  800210:	05 00 00 00 80       	add    $0x80000000,%eax
  800215:	39 c1                	cmp    %eax,%ecx
  800217:	74 14                	je     80022d <_main+0x1f5>
  800219:	83 ec 04             	sub    $0x4,%esp
  80021c:	68 e0 24 80 00       	push   $0x8024e0
  800221:	6a 24                	push   $0x24
  800223:	68 45 25 80 00       	push   $0x802545
  800228:	e8 3c 03 00 00       	call   800569 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80022d:	e8 3a 1b 00 00       	call   801d6c <sys_calculate_free_frames>
  800232:	89 c2                	mov    %eax,%edx
  800234:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800237:	39 c2                	cmp    %eax,%edx
  800239:	74 14                	je     80024f <_main+0x217>
  80023b:	83 ec 04             	sub    $0x4,%esp
  80023e:	68 58 25 80 00       	push   $0x802558
  800243:	6a 25                	push   $0x25
  800245:	68 45 25 80 00       	push   $0x802545
  80024a:	e8 1a 03 00 00       	call   800569 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80024f:	e8 18 1b 00 00       	call   801d6c <sys_calculate_free_frames>
  800254:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if ((uint32)malloc(2*Mega) != USER_HEAP_START + 7*Mega  + 5*kilo) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025a:	01 c0                	add    %eax,%eax
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	e8 30 13 00 00       	call   801595 <malloc>
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	89 c1                	mov    %eax,%ecx
  80026a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80026d:	89 d0                	mov    %edx,%eax
  80026f:	01 c0                	add    %eax,%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	01 c0                	add    %eax,%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	89 c3                	mov    %eax,%ebx
  800279:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80027c:	89 d0                	mov    %edx,%eax
  80027e:	c1 e0 02             	shl    $0x2,%eax
  800281:	01 d0                	add    %edx,%eax
  800283:	01 d8                	add    %ebx,%eax
  800285:	05 00 00 00 80       	add    $0x80000000,%eax
  80028a:	39 c1                	cmp    %eax,%ecx
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 e0 24 80 00       	push   $0x8024e0
  800296:	6a 28                	push   $0x28
  800298:	68 45 25 80 00       	push   $0x802545
  80029d:	e8 c7 02 00 00       	call   800569 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1*1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002a2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8002a5:	e8 c2 1a 00 00       	call   801d6c <sys_calculate_free_frames>
  8002aa:	29 c3                	sub    %eax,%ebx
  8002ac:	89 d8                	mov    %ebx,%eax
  8002ae:	83 f8 01             	cmp    $0x1,%eax
  8002b1:	74 14                	je     8002c7 <_main+0x28f>
  8002b3:	83 ec 04             	sub    $0x4,%esp
  8002b6:	68 58 25 80 00       	push   $0x802558
  8002bb:	6a 29                	push   $0x29
  8002bd:	68 45 25 80 00       	push   $0x802545
  8002c2:	e8 a2 02 00 00       	call   800569 <_panic>
	}
	//make sure that the pages added to page file = 9MB / 4KB
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != (9<<8)+2 ) panic("Extra or less pages are allocated in PageFile");
  8002c7:	e8 23 1b 00 00       	call   801def <sys_pf_calculate_allocated_pages>
  8002cc:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002cf:	3d 02 09 00 00       	cmp    $0x902,%eax
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 c4 25 80 00       	push   $0x8025c4
  8002de:	6a 2c                	push   $0x2c
  8002e0:	68 45 25 80 00       	push   $0x802545
  8002e5:	e8 7f 02 00 00       	call   800569 <_panic>

	cprintf("Step A of test malloc completed successfully.\n\n\n");
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	68 f4 25 80 00       	push   $0x8025f4
  8002f2:	e8 14 05 00 00       	call   80080b <cprintf>
  8002f7:	83 c4 10             	add    $0x10,%esp

	///====================

	int freeFrames = sys_calculate_free_frames() ;
  8002fa:	e8 6d 1a 00 00       	call   801d6c <sys_calculate_free_frames>
  8002ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	{
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800302:	e8 e8 1a 00 00       	call   801def <sys_pf_calculate_allocated_pages>
  800307:	89 45 ec             	mov    %eax,-0x14(%ebp)
		malloc(2*kilo);
  80030a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030d:	01 c0                	add    %eax,%eax
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	50                   	push   %eax
  800313:	e8 7d 12 00 00       	call   801595 <malloc>
  800318:	83 c4 10             	add    $0x10,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0 ) panic("Extra or less pages are allocated in PageFile.. check allocation boundaries (make sure of rounding up and down)");
  80031b:	e8 cf 1a 00 00       	call   801def <sys_pf_calculate_allocated_pages>
  800320:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800323:	74 14                	je     800339 <_main+0x301>
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	68 28 26 80 00       	push   $0x802628
  80032d:	6a 36                	push   $0x36
  80032f:	68 45 25 80 00       	push   $0x802545
  800334:	e8 30 02 00 00       	call   800569 <_panic>

		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800339:	e8 b1 1a 00 00       	call   801def <sys_pf_calculate_allocated_pages>
  80033e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		malloc(2*kilo);
  800341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800344:	01 c0                	add    %eax,%eax
  800346:	83 ec 0c             	sub    $0xc,%esp
  800349:	50                   	push   %eax
  80034a:	e8 46 12 00 00       	call   801595 <malloc>
  80034f:	83 c4 10             	add    $0x10,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1 ) panic("Extra or less pages are allocated in PageFile.. check allocation boundaries (make sure of rounding up and down)");
  800352:	e8 98 1a 00 00       	call   801def <sys_pf_calculate_allocated_pages>
  800357:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80035a:	83 f8 01             	cmp    $0x1,%eax
  80035d:	74 14                	je     800373 <_main+0x33b>
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	68 28 26 80 00       	push   $0x802628
  800367:	6a 3a                	push   $0x3a
  800369:	68 45 25 80 00       	push   $0x802545
  80036e:	e8 f6 01 00 00       	call   800569 <_panic>

		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800373:	e8 77 1a 00 00       	call   801def <sys_pf_calculate_allocated_pages>
  800378:	89 45 ec             	mov    %eax,-0x14(%ebp)
		malloc(3*kilo);
  80037b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037e:	89 c2                	mov    %eax,%edx
  800380:	01 d2                	add    %edx,%edx
  800382:	01 d0                	add    %edx,%eax
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	50                   	push   %eax
  800388:	e8 08 12 00 00       	call   801595 <malloc>
  80038d:	83 c4 10             	add    $0x10,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0 ) panic("Extra or less pages are allocated in PageFile.. check allocation boundaries (make sure of rounding up and down)");
  800390:	e8 5a 1a 00 00       	call   801def <sys_pf_calculate_allocated_pages>
  800395:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800398:	74 14                	je     8003ae <_main+0x376>
  80039a:	83 ec 04             	sub    $0x4,%esp
  80039d:	68 28 26 80 00       	push   $0x802628
  8003a2:	6a 3e                	push   $0x3e
  8003a4:	68 45 25 80 00       	push   $0x802545
  8003a9:	e8 bb 01 00 00       	call   800569 <_panic>

		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ae:	e8 3c 1a 00 00       	call   801def <sys_pf_calculate_allocated_pages>
  8003b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		malloc(3*kilo);
  8003b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b9:	89 c2                	mov    %eax,%edx
  8003bb:	01 d2                	add    %edx,%edx
  8003bd:	01 d0                	add    %edx,%eax
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	50                   	push   %eax
  8003c3:	e8 cd 11 00 00       	call   801595 <malloc>
  8003c8:	83 c4 10             	add    $0x10,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1 ) panic("Extra or less pages are allocated in PageFile.. check allocation boundaries (make sure of rounding up and down)");
  8003cb:	e8 1f 1a 00 00       	call   801def <sys_pf_calculate_allocated_pages>
  8003d0:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8003d3:	83 f8 01             	cmp    $0x1,%eax
  8003d6:	74 14                	je     8003ec <_main+0x3b4>
  8003d8:	83 ec 04             	sub    $0x4,%esp
  8003db:	68 28 26 80 00       	push   $0x802628
  8003e0:	6a 42                	push   $0x42
  8003e2:	68 45 25 80 00       	push   $0x802545
  8003e7:	e8 7d 01 00 00       	call   800569 <_panic>
	}

	if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory");
  8003ec:	e8 7b 19 00 00       	call   801d6c <sys_calculate_free_frames>
  8003f1:	89 c2                	mov    %eax,%edx
  8003f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003f6:	39 c2                	cmp    %eax,%edx
  8003f8:	74 14                	je     80040e <_main+0x3d6>
  8003fa:	83 ec 04             	sub    $0x4,%esp
  8003fd:	68 98 26 80 00       	push   $0x802698
  800402:	6a 45                	push   $0x45
  800404:	68 45 25 80 00       	push   $0x802545
  800409:	e8 5b 01 00 00       	call   800569 <_panic>

	cprintf("Congratulations!! test malloc completed successfully.\n");
  80040e:	83 ec 0c             	sub    $0xc,%esp
  800411:	68 d8 26 80 00       	push   $0x8026d8
  800416:	e8 f0 03 00 00       	call   80080b <cprintf>
  80041b:	83 c4 10             	add    $0x10,%esp

	return;
  80041e:	90                   	nop
}
  80041f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800422:	c9                   	leave  
  800423:	c3                   	ret    

00800424 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80042a:	e8 72 18 00 00       	call   801ca1 <sys_getenvindex>
  80042f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800435:	89 d0                	mov    %edx,%eax
  800437:	c1 e0 03             	shl    $0x3,%eax
  80043a:	01 d0                	add    %edx,%eax
  80043c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800443:	01 c8                	add    %ecx,%eax
  800445:	01 c0                	add    %eax,%eax
  800447:	01 d0                	add    %edx,%eax
  800449:	01 c0                	add    %eax,%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	c1 e2 05             	shl    $0x5,%edx
  800452:	29 c2                	sub    %eax,%edx
  800454:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80045b:	89 c2                	mov    %eax,%edx
  80045d:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800463:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800468:	a1 20 30 80 00       	mov    0x803020,%eax
  80046d:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800473:	84 c0                	test   %al,%al
  800475:	74 0f                	je     800486 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800477:	a1 20 30 80 00       	mov    0x803020,%eax
  80047c:	05 40 3c 01 00       	add    $0x13c40,%eax
  800481:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800486:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80048a:	7e 0a                	jle    800496 <libmain+0x72>
		binaryname = argv[0];
  80048c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	ff 75 0c             	pushl  0xc(%ebp)
  80049c:	ff 75 08             	pushl  0x8(%ebp)
  80049f:	e8 94 fb ff ff       	call   800038 <_main>
  8004a4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004a7:	e8 90 19 00 00       	call   801e3c <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004ac:	83 ec 0c             	sub    $0xc,%esp
  8004af:	68 28 27 80 00       	push   $0x802728
  8004b4:	e8 52 03 00 00       	call   80080b <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004bc:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c1:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8004c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8004cc:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	52                   	push   %edx
  8004d6:	50                   	push   %eax
  8004d7:	68 50 27 80 00       	push   $0x802750
  8004dc:	e8 2a 03 00 00       	call   80080b <cprintf>
  8004e1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8004e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e9:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8004ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8004f4:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8004fa:	83 ec 04             	sub    $0x4,%esp
  8004fd:	52                   	push   %edx
  8004fe:	50                   	push   %eax
  8004ff:	68 78 27 80 00       	push   $0x802778
  800504:	e8 02 03 00 00       	call   80080b <cprintf>
  800509:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80050c:	a1 20 30 80 00       	mov    0x803020,%eax
  800511:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800517:	83 ec 08             	sub    $0x8,%esp
  80051a:	50                   	push   %eax
  80051b:	68 b9 27 80 00       	push   $0x8027b9
  800520:	e8 e6 02 00 00       	call   80080b <cprintf>
  800525:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800528:	83 ec 0c             	sub    $0xc,%esp
  80052b:	68 28 27 80 00       	push   $0x802728
  800530:	e8 d6 02 00 00       	call   80080b <cprintf>
  800535:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800538:	e8 19 19 00 00       	call   801e56 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80053d:	e8 19 00 00 00       	call   80055b <exit>
}
  800542:	90                   	nop
  800543:	c9                   	leave  
  800544:	c3                   	ret    

00800545 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800545:	55                   	push   %ebp
  800546:	89 e5                	mov    %esp,%ebp
  800548:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80054b:	83 ec 0c             	sub    $0xc,%esp
  80054e:	6a 00                	push   $0x0
  800550:	e8 18 17 00 00       	call   801c6d <sys_env_destroy>
  800555:	83 c4 10             	add    $0x10,%esp
}
  800558:	90                   	nop
  800559:	c9                   	leave  
  80055a:	c3                   	ret    

0080055b <exit>:

void
exit(void)
{
  80055b:	55                   	push   %ebp
  80055c:	89 e5                	mov    %esp,%ebp
  80055e:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800561:	e8 6d 17 00 00       	call   801cd3 <sys_env_exit>
}
  800566:	90                   	nop
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80056f:	8d 45 10             	lea    0x10(%ebp),%eax
  800572:	83 c0 04             	add    $0x4,%eax
  800575:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800578:	a1 18 31 80 00       	mov    0x803118,%eax
  80057d:	85 c0                	test   %eax,%eax
  80057f:	74 16                	je     800597 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800581:	a1 18 31 80 00       	mov    0x803118,%eax
  800586:	83 ec 08             	sub    $0x8,%esp
  800589:	50                   	push   %eax
  80058a:	68 d0 27 80 00       	push   $0x8027d0
  80058f:	e8 77 02 00 00       	call   80080b <cprintf>
  800594:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800597:	a1 00 30 80 00       	mov    0x803000,%eax
  80059c:	ff 75 0c             	pushl  0xc(%ebp)
  80059f:	ff 75 08             	pushl  0x8(%ebp)
  8005a2:	50                   	push   %eax
  8005a3:	68 d5 27 80 00       	push   $0x8027d5
  8005a8:	e8 5e 02 00 00       	call   80080b <cprintf>
  8005ad:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b9:	50                   	push   %eax
  8005ba:	e8 e1 01 00 00       	call   8007a0 <vcprintf>
  8005bf:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	6a 00                	push   $0x0
  8005c7:	68 f1 27 80 00       	push   $0x8027f1
  8005cc:	e8 cf 01 00 00       	call   8007a0 <vcprintf>
  8005d1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005d4:	e8 82 ff ff ff       	call   80055b <exit>

	// should not return here
	while (1) ;
  8005d9:	eb fe                	jmp    8005d9 <_panic+0x70>

008005db <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005db:	55                   	push   %ebp
  8005dc:	89 e5                	mov    %esp,%ebp
  8005de:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e6:	8b 50 74             	mov    0x74(%eax),%edx
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	39 c2                	cmp    %eax,%edx
  8005ee:	74 14                	je     800604 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	68 f4 27 80 00       	push   $0x8027f4
  8005f8:	6a 26                	push   $0x26
  8005fa:	68 40 28 80 00       	push   $0x802840
  8005ff:	e8 65 ff ff ff       	call   800569 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800604:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80060b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800612:	e9 b6 00 00 00       	jmp    8006cd <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	01 d0                	add    %edx,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	85 c0                	test   %eax,%eax
  80062a:	75 08                	jne    800634 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80062c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80062f:	e9 96 00 00 00       	jmp    8006ca <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800634:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800642:	eb 5d                	jmp    8006a1 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800644:	a1 20 30 80 00       	mov    0x803020,%eax
  800649:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80064f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800652:	c1 e2 04             	shl    $0x4,%edx
  800655:	01 d0                	add    %edx,%eax
  800657:	8a 40 04             	mov    0x4(%eax),%al
  80065a:	84 c0                	test   %al,%al
  80065c:	75 40                	jne    80069e <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80065e:	a1 20 30 80 00       	mov    0x803020,%eax
  800663:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800669:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80066c:	c1 e2 04             	shl    $0x4,%edx
  80066f:	01 d0                	add    %edx,%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800676:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800679:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80067e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800683:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	01 c8                	add    %ecx,%eax
  80068f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800691:	39 c2                	cmp    %eax,%edx
  800693:	75 09                	jne    80069e <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800695:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80069c:	eb 12                	jmp    8006b0 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80069e:	ff 45 e8             	incl   -0x18(%ebp)
  8006a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a6:	8b 50 74             	mov    0x74(%eax),%edx
  8006a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006ac:	39 c2                	cmp    %eax,%edx
  8006ae:	77 94                	ja     800644 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006b4:	75 14                	jne    8006ca <CheckWSWithoutLastIndex+0xef>
			panic(
  8006b6:	83 ec 04             	sub    $0x4,%esp
  8006b9:	68 4c 28 80 00       	push   $0x80284c
  8006be:	6a 3a                	push   $0x3a
  8006c0:	68 40 28 80 00       	push   $0x802840
  8006c5:	e8 9f fe ff ff       	call   800569 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006ca:	ff 45 f0             	incl   -0x10(%ebp)
  8006cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006d3:	0f 8c 3e ff ff ff    	jl     800617 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006e7:	eb 20                	jmp    800709 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8006ee:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8006f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006f7:	c1 e2 04             	shl    $0x4,%edx
  8006fa:	01 d0                	add    %edx,%eax
  8006fc:	8a 40 04             	mov    0x4(%eax),%al
  8006ff:	3c 01                	cmp    $0x1,%al
  800701:	75 03                	jne    800706 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800703:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800706:	ff 45 e0             	incl   -0x20(%ebp)
  800709:	a1 20 30 80 00       	mov    0x803020,%eax
  80070e:	8b 50 74             	mov    0x74(%eax),%edx
  800711:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800714:	39 c2                	cmp    %eax,%edx
  800716:	77 d1                	ja     8006e9 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80071b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80071e:	74 14                	je     800734 <CheckWSWithoutLastIndex+0x159>
		panic(
  800720:	83 ec 04             	sub    $0x4,%esp
  800723:	68 a0 28 80 00       	push   $0x8028a0
  800728:	6a 44                	push   $0x44
  80072a:	68 40 28 80 00       	push   $0x802840
  80072f:	e8 35 fe ff ff       	call   800569 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800734:	90                   	nop
  800735:	c9                   	leave  
  800736:	c3                   	ret    

00800737 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800737:	55                   	push   %ebp
  800738:	89 e5                	mov    %esp,%ebp
  80073a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80073d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	8d 48 01             	lea    0x1(%eax),%ecx
  800745:	8b 55 0c             	mov    0xc(%ebp),%edx
  800748:	89 0a                	mov    %ecx,(%edx)
  80074a:	8b 55 08             	mov    0x8(%ebp),%edx
  80074d:	88 d1                	mov    %dl,%cl
  80074f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800752:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800756:	8b 45 0c             	mov    0xc(%ebp),%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800760:	75 2c                	jne    80078e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800762:	a0 24 30 80 00       	mov    0x803024,%al
  800767:	0f b6 c0             	movzbl %al,%eax
  80076a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80076d:	8b 12                	mov    (%edx),%edx
  80076f:	89 d1                	mov    %edx,%ecx
  800771:	8b 55 0c             	mov    0xc(%ebp),%edx
  800774:	83 c2 08             	add    $0x8,%edx
  800777:	83 ec 04             	sub    $0x4,%esp
  80077a:	50                   	push   %eax
  80077b:	51                   	push   %ecx
  80077c:	52                   	push   %edx
  80077d:	e8 a9 14 00 00       	call   801c2b <sys_cputs>
  800782:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800785:	8b 45 0c             	mov    0xc(%ebp),%eax
  800788:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80078e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800791:	8b 40 04             	mov    0x4(%eax),%eax
  800794:	8d 50 01             	lea    0x1(%eax),%edx
  800797:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80079d:	90                   	nop
  80079e:	c9                   	leave  
  80079f:	c3                   	ret    

008007a0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007a9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007b0:	00 00 00 
	b.cnt = 0;
  8007b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007ba:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007bd:	ff 75 0c             	pushl  0xc(%ebp)
  8007c0:	ff 75 08             	pushl  0x8(%ebp)
  8007c3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007c9:	50                   	push   %eax
  8007ca:	68 37 07 80 00       	push   $0x800737
  8007cf:	e8 11 02 00 00       	call   8009e5 <vprintfmt>
  8007d4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007d7:	a0 24 30 80 00       	mov    0x803024,%al
  8007dc:	0f b6 c0             	movzbl %al,%eax
  8007df:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007e5:	83 ec 04             	sub    $0x4,%esp
  8007e8:	50                   	push   %eax
  8007e9:	52                   	push   %edx
  8007ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007f0:	83 c0 08             	add    $0x8,%eax
  8007f3:	50                   	push   %eax
  8007f4:	e8 32 14 00 00       	call   801c2b <sys_cputs>
  8007f9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007fc:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800803:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800809:	c9                   	leave  
  80080a:	c3                   	ret    

0080080b <cprintf>:

int cprintf(const char *fmt, ...) {
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800811:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800818:	8d 45 0c             	lea    0xc(%ebp),%eax
  80081b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 f4             	pushl  -0xc(%ebp)
  800827:	50                   	push   %eax
  800828:	e8 73 ff ff ff       	call   8007a0 <vcprintf>
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800833:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800836:	c9                   	leave  
  800837:	c3                   	ret    

00800838 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80083e:	e8 f9 15 00 00       	call   801e3c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800843:	8d 45 0c             	lea    0xc(%ebp),%eax
  800846:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 f4             	pushl  -0xc(%ebp)
  800852:	50                   	push   %eax
  800853:	e8 48 ff ff ff       	call   8007a0 <vcprintf>
  800858:	83 c4 10             	add    $0x10,%esp
  80085b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80085e:	e8 f3 15 00 00       	call   801e56 <sys_enable_interrupt>
	return cnt;
  800863:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800866:	c9                   	leave  
  800867:	c3                   	ret    

00800868 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	53                   	push   %ebx
  80086c:	83 ec 14             	sub    $0x14,%esp
  80086f:	8b 45 10             	mov    0x10(%ebp),%eax
  800872:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80087b:	8b 45 18             	mov    0x18(%ebp),%eax
  80087e:	ba 00 00 00 00       	mov    $0x0,%edx
  800883:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800886:	77 55                	ja     8008dd <printnum+0x75>
  800888:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80088b:	72 05                	jb     800892 <printnum+0x2a>
  80088d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800890:	77 4b                	ja     8008dd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800892:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800895:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800898:	8b 45 18             	mov    0x18(%ebp),%eax
  80089b:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a8:	e8 b3 19 00 00       	call   802260 <__udivdi3>
  8008ad:	83 c4 10             	add    $0x10,%esp
  8008b0:	83 ec 04             	sub    $0x4,%esp
  8008b3:	ff 75 20             	pushl  0x20(%ebp)
  8008b6:	53                   	push   %ebx
  8008b7:	ff 75 18             	pushl  0x18(%ebp)
  8008ba:	52                   	push   %edx
  8008bb:	50                   	push   %eax
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 a1 ff ff ff       	call   800868 <printnum>
  8008c7:	83 c4 20             	add    $0x20,%esp
  8008ca:	eb 1a                	jmp    8008e6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008cc:	83 ec 08             	sub    $0x8,%esp
  8008cf:	ff 75 0c             	pushl  0xc(%ebp)
  8008d2:	ff 75 20             	pushl  0x20(%ebp)
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	ff d0                	call   *%eax
  8008da:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008dd:	ff 4d 1c             	decl   0x1c(%ebp)
  8008e0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008e4:	7f e6                	jg     8008cc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008e6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008f4:	53                   	push   %ebx
  8008f5:	51                   	push   %ecx
  8008f6:	52                   	push   %edx
  8008f7:	50                   	push   %eax
  8008f8:	e8 73 1a 00 00       	call   802370 <__umoddi3>
  8008fd:	83 c4 10             	add    $0x10,%esp
  800900:	05 14 2b 80 00       	add    $0x802b14,%eax
  800905:	8a 00                	mov    (%eax),%al
  800907:	0f be c0             	movsbl %al,%eax
  80090a:	83 ec 08             	sub    $0x8,%esp
  80090d:	ff 75 0c             	pushl  0xc(%ebp)
  800910:	50                   	push   %eax
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	ff d0                	call   *%eax
  800916:	83 c4 10             	add    $0x10,%esp
}
  800919:	90                   	nop
  80091a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80091d:	c9                   	leave  
  80091e:	c3                   	ret    

0080091f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800922:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800926:	7e 1c                	jle    800944 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	8d 50 08             	lea    0x8(%eax),%edx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	89 10                	mov    %edx,(%eax)
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	83 e8 08             	sub    $0x8,%eax
  80093d:	8b 50 04             	mov    0x4(%eax),%edx
  800940:	8b 00                	mov    (%eax),%eax
  800942:	eb 40                	jmp    800984 <getuint+0x65>
	else if (lflag)
  800944:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800948:	74 1e                	je     800968 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	8d 50 04             	lea    0x4(%eax),%edx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	89 10                	mov    %edx,(%eax)
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	83 e8 04             	sub    $0x4,%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	ba 00 00 00 00       	mov    $0x0,%edx
  800966:	eb 1c                	jmp    800984 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	8d 50 04             	lea    0x4(%eax),%edx
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	89 10                	mov    %edx,(%eax)
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8b 00                	mov    (%eax),%eax
  80097a:	83 e8 04             	sub    $0x4,%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    

00800986 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800989:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80098d:	7e 1c                	jle    8009ab <getint+0x25>
		return va_arg(*ap, long long);
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	8d 50 08             	lea    0x8(%eax),%edx
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	89 10                	mov    %edx,(%eax)
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	8b 00                	mov    (%eax),%eax
  8009a1:	83 e8 08             	sub    $0x8,%eax
  8009a4:	8b 50 04             	mov    0x4(%eax),%edx
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	eb 38                	jmp    8009e3 <getint+0x5d>
	else if (lflag)
  8009ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009af:	74 1a                	je     8009cb <getint+0x45>
		return va_arg(*ap, long);
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	8d 50 04             	lea    0x4(%eax),%edx
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	89 10                	mov    %edx,(%eax)
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	83 e8 04             	sub    $0x4,%eax
  8009c6:	8b 00                	mov    (%eax),%eax
  8009c8:	99                   	cltd   
  8009c9:	eb 18                	jmp    8009e3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	8d 50 04             	lea    0x4(%eax),%edx
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	89 10                	mov    %edx,(%eax)
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	83 e8 04             	sub    $0x4,%eax
  8009e0:	8b 00                	mov    (%eax),%eax
  8009e2:	99                   	cltd   
}
  8009e3:	5d                   	pop    %ebp
  8009e4:	c3                   	ret    

008009e5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	56                   	push   %esi
  8009e9:	53                   	push   %ebx
  8009ea:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ed:	eb 17                	jmp    800a06 <vprintfmt+0x21>
			if (ch == '\0')
  8009ef:	85 db                	test   %ebx,%ebx
  8009f1:	0f 84 af 03 00 00    	je     800da6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009f7:	83 ec 08             	sub    $0x8,%esp
  8009fa:	ff 75 0c             	pushl  0xc(%ebp)
  8009fd:	53                   	push   %ebx
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	ff d0                	call   *%eax
  800a03:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a06:	8b 45 10             	mov    0x10(%ebp),%eax
  800a09:	8d 50 01             	lea    0x1(%eax),%edx
  800a0c:	89 55 10             	mov    %edx,0x10(%ebp)
  800a0f:	8a 00                	mov    (%eax),%al
  800a11:	0f b6 d8             	movzbl %al,%ebx
  800a14:	83 fb 25             	cmp    $0x25,%ebx
  800a17:	75 d6                	jne    8009ef <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a19:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a1d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a24:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a2b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a32:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a39:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3c:	8d 50 01             	lea    0x1(%eax),%edx
  800a3f:	89 55 10             	mov    %edx,0x10(%ebp)
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	0f b6 d8             	movzbl %al,%ebx
  800a47:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a4a:	83 f8 55             	cmp    $0x55,%eax
  800a4d:	0f 87 2b 03 00 00    	ja     800d7e <vprintfmt+0x399>
  800a53:	8b 04 85 38 2b 80 00 	mov    0x802b38(,%eax,4),%eax
  800a5a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a5c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a60:	eb d7                	jmp    800a39 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a62:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a66:	eb d1                	jmp    800a39 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a68:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a72:	89 d0                	mov    %edx,%eax
  800a74:	c1 e0 02             	shl    $0x2,%eax
  800a77:	01 d0                	add    %edx,%eax
  800a79:	01 c0                	add    %eax,%eax
  800a7b:	01 d8                	add    %ebx,%eax
  800a7d:	83 e8 30             	sub    $0x30,%eax
  800a80:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a83:	8b 45 10             	mov    0x10(%ebp),%eax
  800a86:	8a 00                	mov    (%eax),%al
  800a88:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a8b:	83 fb 2f             	cmp    $0x2f,%ebx
  800a8e:	7e 3e                	jle    800ace <vprintfmt+0xe9>
  800a90:	83 fb 39             	cmp    $0x39,%ebx
  800a93:	7f 39                	jg     800ace <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a95:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a98:	eb d5                	jmp    800a6f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9d:	83 c0 04             	add    $0x4,%eax
  800aa0:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 e8 04             	sub    $0x4,%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aae:	eb 1f                	jmp    800acf <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ab0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab4:	79 83                	jns    800a39 <vprintfmt+0x54>
				width = 0;
  800ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800abd:	e9 77 ff ff ff       	jmp    800a39 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ac2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ac9:	e9 6b ff ff ff       	jmp    800a39 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ace:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800acf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad3:	0f 89 60 ff ff ff    	jns    800a39 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800adc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800adf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ae6:	e9 4e ff ff ff       	jmp    800a39 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aeb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800aee:	e9 46 ff ff ff       	jmp    800a39 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800af3:	8b 45 14             	mov    0x14(%ebp),%eax
  800af6:	83 c0 04             	add    $0x4,%eax
  800af9:	89 45 14             	mov    %eax,0x14(%ebp)
  800afc:	8b 45 14             	mov    0x14(%ebp),%eax
  800aff:	83 e8 04             	sub    $0x4,%eax
  800b02:	8b 00                	mov    (%eax),%eax
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	ff 75 0c             	pushl  0xc(%ebp)
  800b0a:	50                   	push   %eax
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	ff d0                	call   *%eax
  800b10:	83 c4 10             	add    $0x10,%esp
			break;
  800b13:	e9 89 02 00 00       	jmp    800da1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	83 c0 04             	add    $0x4,%eax
  800b1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	83 e8 04             	sub    $0x4,%eax
  800b27:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b29:	85 db                	test   %ebx,%ebx
  800b2b:	79 02                	jns    800b2f <vprintfmt+0x14a>
				err = -err;
  800b2d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b2f:	83 fb 64             	cmp    $0x64,%ebx
  800b32:	7f 0b                	jg     800b3f <vprintfmt+0x15a>
  800b34:	8b 34 9d 80 29 80 00 	mov    0x802980(,%ebx,4),%esi
  800b3b:	85 f6                	test   %esi,%esi
  800b3d:	75 19                	jne    800b58 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b3f:	53                   	push   %ebx
  800b40:	68 25 2b 80 00       	push   $0x802b25
  800b45:	ff 75 0c             	pushl  0xc(%ebp)
  800b48:	ff 75 08             	pushl  0x8(%ebp)
  800b4b:	e8 5e 02 00 00       	call   800dae <printfmt>
  800b50:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b53:	e9 49 02 00 00       	jmp    800da1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b58:	56                   	push   %esi
  800b59:	68 2e 2b 80 00       	push   $0x802b2e
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	ff 75 08             	pushl  0x8(%ebp)
  800b64:	e8 45 02 00 00       	call   800dae <printfmt>
  800b69:	83 c4 10             	add    $0x10,%esp
			break;
  800b6c:	e9 30 02 00 00       	jmp    800da1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b71:	8b 45 14             	mov    0x14(%ebp),%eax
  800b74:	83 c0 04             	add    $0x4,%eax
  800b77:	89 45 14             	mov    %eax,0x14(%ebp)
  800b7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7d:	83 e8 04             	sub    $0x4,%eax
  800b80:	8b 30                	mov    (%eax),%esi
  800b82:	85 f6                	test   %esi,%esi
  800b84:	75 05                	jne    800b8b <vprintfmt+0x1a6>
				p = "(null)";
  800b86:	be 31 2b 80 00       	mov    $0x802b31,%esi
			if (width > 0 && padc != '-')
  800b8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b8f:	7e 6d                	jle    800bfe <vprintfmt+0x219>
  800b91:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b95:	74 67                	je     800bfe <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	50                   	push   %eax
  800b9e:	56                   	push   %esi
  800b9f:	e8 0c 03 00 00       	call   800eb0 <strnlen>
  800ba4:	83 c4 10             	add    $0x10,%esp
  800ba7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800baa:	eb 16                	jmp    800bc2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bac:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bb0:	83 ec 08             	sub    $0x8,%esp
  800bb3:	ff 75 0c             	pushl  0xc(%ebp)
  800bb6:	50                   	push   %eax
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	ff d0                	call   *%eax
  800bbc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bbf:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc6:	7f e4                	jg     800bac <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bc8:	eb 34                	jmp    800bfe <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bce:	74 1c                	je     800bec <vprintfmt+0x207>
  800bd0:	83 fb 1f             	cmp    $0x1f,%ebx
  800bd3:	7e 05                	jle    800bda <vprintfmt+0x1f5>
  800bd5:	83 fb 7e             	cmp    $0x7e,%ebx
  800bd8:	7e 12                	jle    800bec <vprintfmt+0x207>
					putch('?', putdat);
  800bda:	83 ec 08             	sub    $0x8,%esp
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	6a 3f                	push   $0x3f
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	ff d0                	call   *%eax
  800be7:	83 c4 10             	add    $0x10,%esp
  800bea:	eb 0f                	jmp    800bfb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bec:	83 ec 08             	sub    $0x8,%esp
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	53                   	push   %ebx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	ff d0                	call   *%eax
  800bf8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bfb:	ff 4d e4             	decl   -0x1c(%ebp)
  800bfe:	89 f0                	mov    %esi,%eax
  800c00:	8d 70 01             	lea    0x1(%eax),%esi
  800c03:	8a 00                	mov    (%eax),%al
  800c05:	0f be d8             	movsbl %al,%ebx
  800c08:	85 db                	test   %ebx,%ebx
  800c0a:	74 24                	je     800c30 <vprintfmt+0x24b>
  800c0c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c10:	78 b8                	js     800bca <vprintfmt+0x1e5>
  800c12:	ff 4d e0             	decl   -0x20(%ebp)
  800c15:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c19:	79 af                	jns    800bca <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c1b:	eb 13                	jmp    800c30 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c1d:	83 ec 08             	sub    $0x8,%esp
  800c20:	ff 75 0c             	pushl  0xc(%ebp)
  800c23:	6a 20                	push   $0x20
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	ff d0                	call   *%eax
  800c2a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c2d:	ff 4d e4             	decl   -0x1c(%ebp)
  800c30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c34:	7f e7                	jg     800c1d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c36:	e9 66 01 00 00       	jmp    800da1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c41:	8d 45 14             	lea    0x14(%ebp),%eax
  800c44:	50                   	push   %eax
  800c45:	e8 3c fd ff ff       	call   800986 <getint>
  800c4a:	83 c4 10             	add    $0x10,%esp
  800c4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c50:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c59:	85 d2                	test   %edx,%edx
  800c5b:	79 23                	jns    800c80 <vprintfmt+0x29b>
				putch('-', putdat);
  800c5d:	83 ec 08             	sub    $0x8,%esp
  800c60:	ff 75 0c             	pushl  0xc(%ebp)
  800c63:	6a 2d                	push   $0x2d
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	ff d0                	call   *%eax
  800c6a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c73:	f7 d8                	neg    %eax
  800c75:	83 d2 00             	adc    $0x0,%edx
  800c78:	f7 da                	neg    %edx
  800c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c80:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c87:	e9 bc 00 00 00       	jmp    800d48 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 e8             	pushl  -0x18(%ebp)
  800c92:	8d 45 14             	lea    0x14(%ebp),%eax
  800c95:	50                   	push   %eax
  800c96:	e8 84 fc ff ff       	call   80091f <getuint>
  800c9b:	83 c4 10             	add    $0x10,%esp
  800c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ca4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cab:	e9 98 00 00 00       	jmp    800d48 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	6a 58                	push   $0x58
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	ff d0                	call   *%eax
  800cbd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cc0:	83 ec 08             	sub    $0x8,%esp
  800cc3:	ff 75 0c             	pushl  0xc(%ebp)
  800cc6:	6a 58                	push   $0x58
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	ff d0                	call   *%eax
  800ccd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cd0:	83 ec 08             	sub    $0x8,%esp
  800cd3:	ff 75 0c             	pushl  0xc(%ebp)
  800cd6:	6a 58                	push   $0x58
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	ff d0                	call   *%eax
  800cdd:	83 c4 10             	add    $0x10,%esp
			break;
  800ce0:	e9 bc 00 00 00       	jmp    800da1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ce5:	83 ec 08             	sub    $0x8,%esp
  800ce8:	ff 75 0c             	pushl  0xc(%ebp)
  800ceb:	6a 30                	push   $0x30
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	ff d0                	call   *%eax
  800cf2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cf5:	83 ec 08             	sub    $0x8,%esp
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	6a 78                	push   $0x78
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	ff d0                	call   *%eax
  800d02:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d05:	8b 45 14             	mov    0x14(%ebp),%eax
  800d08:	83 c0 04             	add    $0x4,%eax
  800d0b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d11:	83 e8 04             	sub    $0x4,%eax
  800d14:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d20:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d27:	eb 1f                	jmp    800d48 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d29:	83 ec 08             	sub    $0x8,%esp
  800d2c:	ff 75 e8             	pushl  -0x18(%ebp)
  800d2f:	8d 45 14             	lea    0x14(%ebp),%eax
  800d32:	50                   	push   %eax
  800d33:	e8 e7 fb ff ff       	call   80091f <getuint>
  800d38:	83 c4 10             	add    $0x10,%esp
  800d3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d41:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d48:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d4f:	83 ec 04             	sub    $0x4,%esp
  800d52:	52                   	push   %edx
  800d53:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d56:	50                   	push   %eax
  800d57:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5a:	ff 75 f0             	pushl  -0x10(%ebp)
  800d5d:	ff 75 0c             	pushl  0xc(%ebp)
  800d60:	ff 75 08             	pushl  0x8(%ebp)
  800d63:	e8 00 fb ff ff       	call   800868 <printnum>
  800d68:	83 c4 20             	add    $0x20,%esp
			break;
  800d6b:	eb 34                	jmp    800da1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d6d:	83 ec 08             	sub    $0x8,%esp
  800d70:	ff 75 0c             	pushl  0xc(%ebp)
  800d73:	53                   	push   %ebx
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	ff d0                	call   *%eax
  800d79:	83 c4 10             	add    $0x10,%esp
			break;
  800d7c:	eb 23                	jmp    800da1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d7e:	83 ec 08             	sub    $0x8,%esp
  800d81:	ff 75 0c             	pushl  0xc(%ebp)
  800d84:	6a 25                	push   $0x25
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	ff d0                	call   *%eax
  800d8b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d8e:	ff 4d 10             	decl   0x10(%ebp)
  800d91:	eb 03                	jmp    800d96 <vprintfmt+0x3b1>
  800d93:	ff 4d 10             	decl   0x10(%ebp)
  800d96:	8b 45 10             	mov    0x10(%ebp),%eax
  800d99:	48                   	dec    %eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	3c 25                	cmp    $0x25,%al
  800d9e:	75 f3                	jne    800d93 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800da0:	90                   	nop
		}
	}
  800da1:	e9 47 fc ff ff       	jmp    8009ed <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800da6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800da7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800daa:	5b                   	pop    %ebx
  800dab:	5e                   	pop    %esi
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    

00800dae <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800db4:	8d 45 10             	lea    0x10(%ebp),%eax
  800db7:	83 c0 04             	add    $0x4,%eax
  800dba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc0:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc3:	50                   	push   %eax
  800dc4:	ff 75 0c             	pushl  0xc(%ebp)
  800dc7:	ff 75 08             	pushl  0x8(%ebp)
  800dca:	e8 16 fc ff ff       	call   8009e5 <vprintfmt>
  800dcf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dd2:	90                   	nop
  800dd3:	c9                   	leave  
  800dd4:	c3                   	ret    

00800dd5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddb:	8b 40 08             	mov    0x8(%eax),%eax
  800dde:	8d 50 01             	lea    0x1(%eax),%edx
  800de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	8b 10                	mov    (%eax),%edx
  800dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800def:	8b 40 04             	mov    0x4(%eax),%eax
  800df2:	39 c2                	cmp    %eax,%edx
  800df4:	73 12                	jae    800e08 <sprintputch+0x33>
		*b->buf++ = ch;
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	8b 00                	mov    (%eax),%eax
  800dfb:	8d 48 01             	lea    0x1(%eax),%ecx
  800dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e01:	89 0a                	mov    %ecx,(%edx)
  800e03:	8b 55 08             	mov    0x8(%ebp),%edx
  800e06:	88 10                	mov    %dl,(%eax)
}
  800e08:	90                   	nop
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    

00800e0b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	01 d0                	add    %edx,%eax
  800e22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e30:	74 06                	je     800e38 <vsnprintf+0x2d>
  800e32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e36:	7f 07                	jg     800e3f <vsnprintf+0x34>
		return -E_INVAL;
  800e38:	b8 03 00 00 00       	mov    $0x3,%eax
  800e3d:	eb 20                	jmp    800e5f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e3f:	ff 75 14             	pushl  0x14(%ebp)
  800e42:	ff 75 10             	pushl  0x10(%ebp)
  800e45:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e48:	50                   	push   %eax
  800e49:	68 d5 0d 80 00       	push   $0x800dd5
  800e4e:	e8 92 fb ff ff       	call   8009e5 <vprintfmt>
  800e53:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e59:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e5f:	c9                   	leave  
  800e60:	c3                   	ret    

00800e61 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e67:	8d 45 10             	lea    0x10(%ebp),%eax
  800e6a:	83 c0 04             	add    $0x4,%eax
  800e6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e70:	8b 45 10             	mov    0x10(%ebp),%eax
  800e73:	ff 75 f4             	pushl  -0xc(%ebp)
  800e76:	50                   	push   %eax
  800e77:	ff 75 0c             	pushl  0xc(%ebp)
  800e7a:	ff 75 08             	pushl  0x8(%ebp)
  800e7d:	e8 89 ff ff ff       	call   800e0b <vsnprintf>
  800e82:	83 c4 10             	add    $0x10,%esp
  800e85:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9a:	eb 06                	jmp    800ea2 <strlen+0x15>
		n++;
  800e9c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e9f:	ff 45 08             	incl   0x8(%ebp)
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	84 c0                	test   %al,%al
  800ea9:	75 f1                	jne    800e9c <strlen+0xf>
		n++;
	return n;
  800eab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eae:	c9                   	leave  
  800eaf:	c3                   	ret    

00800eb0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ebd:	eb 09                	jmp    800ec8 <strnlen+0x18>
		n++;
  800ebf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ec2:	ff 45 08             	incl   0x8(%ebp)
  800ec5:	ff 4d 0c             	decl   0xc(%ebp)
  800ec8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ecc:	74 09                	je     800ed7 <strnlen+0x27>
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	84 c0                	test   %al,%al
  800ed5:	75 e8                	jne    800ebf <strnlen+0xf>
		n++;
	return n;
  800ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eda:	c9                   	leave  
  800edb:	c3                   	ret    

00800edc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ee8:	90                   	nop
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8d 50 01             	lea    0x1(%eax),%edx
  800eef:	89 55 08             	mov    %edx,0x8(%ebp)
  800ef2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800efb:	8a 12                	mov    (%edx),%dl
  800efd:	88 10                	mov    %dl,(%eax)
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	84 c0                	test   %al,%al
  800f03:	75 e4                	jne    800ee9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f05:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f08:	c9                   	leave  
  800f09:	c3                   	ret    

00800f0a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f1d:	eb 1f                	jmp    800f3e <strncpy+0x34>
		*dst++ = *src;
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8d 50 01             	lea    0x1(%eax),%edx
  800f25:	89 55 08             	mov    %edx,0x8(%ebp)
  800f28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2b:	8a 12                	mov    (%edx),%dl
  800f2d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	84 c0                	test   %al,%al
  800f36:	74 03                	je     800f3b <strncpy+0x31>
			src++;
  800f38:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f3b:	ff 45 fc             	incl   -0x4(%ebp)
  800f3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f41:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f44:	72 d9                	jb     800f1f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f49:	c9                   	leave  
  800f4a:	c3                   	ret    

00800f4b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5b:	74 30                	je     800f8d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f5d:	eb 16                	jmp    800f75 <strlcpy+0x2a>
			*dst++ = *src++;
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8d 50 01             	lea    0x1(%eax),%edx
  800f65:	89 55 08             	mov    %edx,0x8(%ebp)
  800f68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f71:	8a 12                	mov    (%edx),%dl
  800f73:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f75:	ff 4d 10             	decl   0x10(%ebp)
  800f78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7c:	74 09                	je     800f87 <strlcpy+0x3c>
  800f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	84 c0                	test   %al,%al
  800f85:	75 d8                	jne    800f5f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f93:	29 c2                	sub    %eax,%edx
  800f95:	89 d0                	mov    %edx,%eax
}
  800f97:	c9                   	leave  
  800f98:	c3                   	ret    

00800f99 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f9c:	eb 06                	jmp    800fa4 <strcmp+0xb>
		p++, q++;
  800f9e:	ff 45 08             	incl   0x8(%ebp)
  800fa1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	84 c0                	test   %al,%al
  800fab:	74 0e                	je     800fbb <strcmp+0x22>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 10                	mov    (%eax),%dl
  800fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	38 c2                	cmp    %al,%dl
  800fb9:	74 e3                	je     800f9e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	0f b6 d0             	movzbl %al,%edx
  800fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	0f b6 c0             	movzbl %al,%eax
  800fcb:	29 c2                	sub    %eax,%edx
  800fcd:	89 d0                	mov    %edx,%eax
}
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    

00800fd1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fd4:	eb 09                	jmp    800fdf <strncmp+0xe>
		n--, p++, q++;
  800fd6:	ff 4d 10             	decl   0x10(%ebp)
  800fd9:	ff 45 08             	incl   0x8(%ebp)
  800fdc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	74 17                	je     800ffc <strncmp+0x2b>
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	84 c0                	test   %al,%al
  800fec:	74 0e                	je     800ffc <strncmp+0x2b>
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 10                	mov    (%eax),%dl
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	38 c2                	cmp    %al,%dl
  800ffa:	74 da                	je     800fd6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ffc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801000:	75 07                	jne    801009 <strncmp+0x38>
		return 0;
  801002:	b8 00 00 00 00       	mov    $0x0,%eax
  801007:	eb 14                	jmp    80101d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	0f b6 d0             	movzbl %al,%edx
  801011:	8b 45 0c             	mov    0xc(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	0f b6 c0             	movzbl %al,%eax
  801019:	29 c2                	sub    %eax,%edx
  80101b:	89 d0                	mov    %edx,%eax
}
  80101d:	5d                   	pop    %ebp
  80101e:	c3                   	ret    

0080101f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	83 ec 04             	sub    $0x4,%esp
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80102b:	eb 12                	jmp    80103f <strchr+0x20>
		if (*s == c)
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801035:	75 05                	jne    80103c <strchr+0x1d>
			return (char *) s;
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	eb 11                	jmp    80104d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80103c:	ff 45 08             	incl   0x8(%ebp)
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	84 c0                	test   %al,%al
  801046:	75 e5                	jne    80102d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801048:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 04             	sub    $0x4,%esp
  801055:	8b 45 0c             	mov    0xc(%ebp),%eax
  801058:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80105b:	eb 0d                	jmp    80106a <strfind+0x1b>
		if (*s == c)
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801065:	74 0e                	je     801075 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801067:	ff 45 08             	incl   0x8(%ebp)
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	84 c0                	test   %al,%al
  801071:	75 ea                	jne    80105d <strfind+0xe>
  801073:	eb 01                	jmp    801076 <strfind+0x27>
		if (*s == c)
			break;
  801075:	90                   	nop
	return (char *) s;
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801079:	c9                   	leave  
  80107a:	c3                   	ret    

0080107b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
  80108a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80108d:	eb 0e                	jmp    80109d <memset+0x22>
		*p++ = c;
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801092:	8d 50 01             	lea    0x1(%eax),%edx
  801095:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801098:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80109d:	ff 4d f8             	decl   -0x8(%ebp)
  8010a0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010a4:	79 e9                	jns    80108f <memset+0x14>
		*p++ = c;

	return v;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010bd:	eb 16                	jmp    8010d5 <memcpy+0x2a>
		*d++ = *s++;
  8010bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c2:	8d 50 01             	lea    0x1(%eax),%edx
  8010c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ce:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010d1:	8a 12                	mov    (%edx),%dl
  8010d3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010db:	89 55 10             	mov    %edx,0x10(%ebp)
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	75 dd                	jne    8010bf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ff:	73 50                	jae    801151 <memmove+0x6a>
  801101:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801104:	8b 45 10             	mov    0x10(%ebp),%eax
  801107:	01 d0                	add    %edx,%eax
  801109:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80110c:	76 43                	jbe    801151 <memmove+0x6a>
		s += n;
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801114:	8b 45 10             	mov    0x10(%ebp),%eax
  801117:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80111a:	eb 10                	jmp    80112c <memmove+0x45>
			*--d = *--s;
  80111c:	ff 4d f8             	decl   -0x8(%ebp)
  80111f:	ff 4d fc             	decl   -0x4(%ebp)
  801122:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801125:	8a 10                	mov    (%eax),%dl
  801127:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80112c:	8b 45 10             	mov    0x10(%ebp),%eax
  80112f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801132:	89 55 10             	mov    %edx,0x10(%ebp)
  801135:	85 c0                	test   %eax,%eax
  801137:	75 e3                	jne    80111c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801139:	eb 23                	jmp    80115e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80113b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113e:	8d 50 01             	lea    0x1(%eax),%edx
  801141:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801144:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801147:	8d 4a 01             	lea    0x1(%edx),%ecx
  80114a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80114d:	8a 12                	mov    (%edx),%dl
  80114f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801151:	8b 45 10             	mov    0x10(%ebp),%eax
  801154:	8d 50 ff             	lea    -0x1(%eax),%edx
  801157:	89 55 10             	mov    %edx,0x10(%ebp)
  80115a:	85 c0                	test   %eax,%eax
  80115c:	75 dd                	jne    80113b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80116f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801172:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801175:	eb 2a                	jmp    8011a1 <memcmp+0x3e>
		if (*s1 != *s2)
  801177:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117a:	8a 10                	mov    (%eax),%dl
  80117c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	38 c2                	cmp    %al,%dl
  801183:	74 16                	je     80119b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801185:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	0f b6 d0             	movzbl %al,%edx
  80118d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	0f b6 c0             	movzbl %al,%eax
  801195:	29 c2                	sub    %eax,%edx
  801197:	89 d0                	mov    %edx,%eax
  801199:	eb 18                	jmp    8011b3 <memcmp+0x50>
		s1++, s2++;
  80119b:	ff 45 fc             	incl   -0x4(%ebp)
  80119e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011aa:	85 c0                	test   %eax,%eax
  8011ac:	75 c9                	jne    801177 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b3:	c9                   	leave  
  8011b4:	c3                   	ret    

008011b5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011be:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c1:	01 d0                	add    %edx,%eax
  8011c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011c6:	eb 15                	jmp    8011dd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	0f b6 d0             	movzbl %al,%edx
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	0f b6 c0             	movzbl %al,%eax
  8011d6:	39 c2                	cmp    %eax,%edx
  8011d8:	74 0d                	je     8011e7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011da:	ff 45 08             	incl   0x8(%ebp)
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011e3:	72 e3                	jb     8011c8 <memfind+0x13>
  8011e5:	eb 01                	jmp    8011e8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011e7:	90                   	nop
	return (void *) s;
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801201:	eb 03                	jmp    801206 <strtol+0x19>
		s++;
  801203:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 20                	cmp    $0x20,%al
  80120d:	74 f4                	je     801203 <strtol+0x16>
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	8a 00                	mov    (%eax),%al
  801214:	3c 09                	cmp    $0x9,%al
  801216:	74 eb                	je     801203 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
  80121b:	8a 00                	mov    (%eax),%al
  80121d:	3c 2b                	cmp    $0x2b,%al
  80121f:	75 05                	jne    801226 <strtol+0x39>
		s++;
  801221:	ff 45 08             	incl   0x8(%ebp)
  801224:	eb 13                	jmp    801239 <strtol+0x4c>
	else if (*s == '-')
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	3c 2d                	cmp    $0x2d,%al
  80122d:	75 0a                	jne    801239 <strtol+0x4c>
		s++, neg = 1;
  80122f:	ff 45 08             	incl   0x8(%ebp)
  801232:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801239:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80123d:	74 06                	je     801245 <strtol+0x58>
  80123f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801243:	75 20                	jne    801265 <strtol+0x78>
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	3c 30                	cmp    $0x30,%al
  80124c:	75 17                	jne    801265 <strtol+0x78>
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	40                   	inc    %eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	3c 78                	cmp    $0x78,%al
  801256:	75 0d                	jne    801265 <strtol+0x78>
		s += 2, base = 16;
  801258:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80125c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801263:	eb 28                	jmp    80128d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801265:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801269:	75 15                	jne    801280 <strtol+0x93>
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	3c 30                	cmp    $0x30,%al
  801272:	75 0c                	jne    801280 <strtol+0x93>
		s++, base = 8;
  801274:	ff 45 08             	incl   0x8(%ebp)
  801277:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80127e:	eb 0d                	jmp    80128d <strtol+0xa0>
	else if (base == 0)
  801280:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801284:	75 07                	jne    80128d <strtol+0xa0>
		base = 10;
  801286:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	3c 2f                	cmp    $0x2f,%al
  801294:	7e 19                	jle    8012af <strtol+0xc2>
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	3c 39                	cmp    $0x39,%al
  80129d:	7f 10                	jg     8012af <strtol+0xc2>
			dig = *s - '0';
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	0f be c0             	movsbl %al,%eax
  8012a7:	83 e8 30             	sub    $0x30,%eax
  8012aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ad:	eb 42                	jmp    8012f1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	3c 60                	cmp    $0x60,%al
  8012b6:	7e 19                	jle    8012d1 <strtol+0xe4>
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	3c 7a                	cmp    $0x7a,%al
  8012bf:	7f 10                	jg     8012d1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	0f be c0             	movsbl %al,%eax
  8012c9:	83 e8 57             	sub    $0x57,%eax
  8012cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012cf:	eb 20                	jmp    8012f1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	3c 40                	cmp    $0x40,%al
  8012d8:	7e 39                	jle    801313 <strtol+0x126>
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	3c 5a                	cmp    $0x5a,%al
  8012e1:	7f 30                	jg     801313 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	8a 00                	mov    (%eax),%al
  8012e8:	0f be c0             	movsbl %al,%eax
  8012eb:	83 e8 37             	sub    $0x37,%eax
  8012ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012f7:	7d 19                	jge    801312 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012f9:	ff 45 08             	incl   0x8(%ebp)
  8012fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ff:	0f af 45 10          	imul   0x10(%ebp),%eax
  801303:	89 c2                	mov    %eax,%edx
  801305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801308:	01 d0                	add    %edx,%eax
  80130a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80130d:	e9 7b ff ff ff       	jmp    80128d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801312:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801313:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801317:	74 08                	je     801321 <strtol+0x134>
		*endptr = (char *) s;
  801319:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131c:	8b 55 08             	mov    0x8(%ebp),%edx
  80131f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801321:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801325:	74 07                	je     80132e <strtol+0x141>
  801327:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132a:	f7 d8                	neg    %eax
  80132c:	eb 03                	jmp    801331 <strtol+0x144>
  80132e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <ltostr>:

void
ltostr(long value, char *str)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801339:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801340:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801347:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80134b:	79 13                	jns    801360 <ltostr+0x2d>
	{
		neg = 1;
  80134d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80135a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80135d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801368:	99                   	cltd   
  801369:	f7 f9                	idiv   %ecx
  80136b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80136e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801371:	8d 50 01             	lea    0x1(%eax),%edx
  801374:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801377:	89 c2                	mov    %eax,%edx
  801379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137c:	01 d0                	add    %edx,%eax
  80137e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801381:	83 c2 30             	add    $0x30,%edx
  801384:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801386:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801389:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80138e:	f7 e9                	imul   %ecx
  801390:	c1 fa 02             	sar    $0x2,%edx
  801393:	89 c8                	mov    %ecx,%eax
  801395:	c1 f8 1f             	sar    $0x1f,%eax
  801398:	29 c2                	sub    %eax,%edx
  80139a:	89 d0                	mov    %edx,%eax
  80139c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80139f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013a7:	f7 e9                	imul   %ecx
  8013a9:	c1 fa 02             	sar    $0x2,%edx
  8013ac:	89 c8                	mov    %ecx,%eax
  8013ae:	c1 f8 1f             	sar    $0x1f,%eax
  8013b1:	29 c2                	sub    %eax,%edx
  8013b3:	89 d0                	mov    %edx,%eax
  8013b5:	c1 e0 02             	shl    $0x2,%eax
  8013b8:	01 d0                	add    %edx,%eax
  8013ba:	01 c0                	add    %eax,%eax
  8013bc:	29 c1                	sub    %eax,%ecx
  8013be:	89 ca                	mov    %ecx,%edx
  8013c0:	85 d2                	test   %edx,%edx
  8013c2:	75 9c                	jne    801360 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ce:	48                   	dec    %eax
  8013cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013d6:	74 3d                	je     801415 <ltostr+0xe2>
		start = 1 ;
  8013d8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013df:	eb 34                	jmp    801415 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	01 d0                	add    %edx,%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f4:	01 c2                	add    %eax,%edx
  8013f6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fc:	01 c8                	add    %ecx,%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801402:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801405:	8b 45 0c             	mov    0xc(%ebp),%eax
  801408:	01 c2                	add    %eax,%edx
  80140a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80140d:	88 02                	mov    %al,(%edx)
		start++ ;
  80140f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801412:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801418:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80141b:	7c c4                	jl     8013e1 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80141d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801420:	8b 45 0c             	mov    0xc(%ebp),%eax
  801423:	01 d0                	add    %edx,%eax
  801425:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801428:	90                   	nop
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801431:	ff 75 08             	pushl  0x8(%ebp)
  801434:	e8 54 fa ff ff       	call   800e8d <strlen>
  801439:	83 c4 04             	add    $0x4,%esp
  80143c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80143f:	ff 75 0c             	pushl  0xc(%ebp)
  801442:	e8 46 fa ff ff       	call   800e8d <strlen>
  801447:	83 c4 04             	add    $0x4,%esp
  80144a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80144d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801454:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80145b:	eb 17                	jmp    801474 <strcconcat+0x49>
		final[s] = str1[s] ;
  80145d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801460:	8b 45 10             	mov    0x10(%ebp),%eax
  801463:	01 c2                	add    %eax,%edx
  801465:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	01 c8                	add    %ecx,%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801471:	ff 45 fc             	incl   -0x4(%ebp)
  801474:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801477:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80147a:	7c e1                	jl     80145d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80147c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801483:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80148a:	eb 1f                	jmp    8014ab <strcconcat+0x80>
		final[s++] = str2[i] ;
  80148c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148f:	8d 50 01             	lea    0x1(%eax),%edx
  801492:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801495:	89 c2                	mov    %eax,%edx
  801497:	8b 45 10             	mov    0x10(%ebp),%eax
  80149a:	01 c2                	add    %eax,%edx
  80149c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80149f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a2:	01 c8                	add    %ecx,%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014a8:	ff 45 f8             	incl   -0x8(%ebp)
  8014ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014b1:	7c d9                	jl     80148c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b9:	01 d0                	add    %edx,%eax
  8014bb:	c6 00 00             	movb   $0x0,(%eax)
}
  8014be:	90                   	nop
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d0:	8b 00                	mov    (%eax),%eax
  8014d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014e4:	eb 0c                	jmp    8014f2 <strsplit+0x31>
			*string++ = 0;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	8d 50 01             	lea    0x1(%eax),%edx
  8014ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ef:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	84 c0                	test   %al,%al
  8014f9:	74 18                	je     801513 <strsplit+0x52>
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	0f be c0             	movsbl %al,%eax
  801503:	50                   	push   %eax
  801504:	ff 75 0c             	pushl  0xc(%ebp)
  801507:	e8 13 fb ff ff       	call   80101f <strchr>
  80150c:	83 c4 08             	add    $0x8,%esp
  80150f:	85 c0                	test   %eax,%eax
  801511:	75 d3                	jne    8014e6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	8a 00                	mov    (%eax),%al
  801518:	84 c0                	test   %al,%al
  80151a:	74 5a                	je     801576 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80151c:	8b 45 14             	mov    0x14(%ebp),%eax
  80151f:	8b 00                	mov    (%eax),%eax
  801521:	83 f8 0f             	cmp    $0xf,%eax
  801524:	75 07                	jne    80152d <strsplit+0x6c>
		{
			return 0;
  801526:	b8 00 00 00 00       	mov    $0x0,%eax
  80152b:	eb 66                	jmp    801593 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80152d:	8b 45 14             	mov    0x14(%ebp),%eax
  801530:	8b 00                	mov    (%eax),%eax
  801532:	8d 48 01             	lea    0x1(%eax),%ecx
  801535:	8b 55 14             	mov    0x14(%ebp),%edx
  801538:	89 0a                	mov    %ecx,(%edx)
  80153a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801541:	8b 45 10             	mov    0x10(%ebp),%eax
  801544:	01 c2                	add    %eax,%edx
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80154b:	eb 03                	jmp    801550 <strsplit+0x8f>
			string++;
  80154d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	8a 00                	mov    (%eax),%al
  801555:	84 c0                	test   %al,%al
  801557:	74 8b                	je     8014e4 <strsplit+0x23>
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	0f be c0             	movsbl %al,%eax
  801561:	50                   	push   %eax
  801562:	ff 75 0c             	pushl  0xc(%ebp)
  801565:	e8 b5 fa ff ff       	call   80101f <strchr>
  80156a:	83 c4 08             	add    $0x8,%esp
  80156d:	85 c0                	test   %eax,%eax
  80156f:	74 dc                	je     80154d <strsplit+0x8c>
			string++;
	}
  801571:	e9 6e ff ff ff       	jmp    8014e4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801576:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801577:	8b 45 14             	mov    0x14(%ebp),%eax
  80157a:	8b 00                	mov    (%eax),%eax
  80157c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801583:	8b 45 10             	mov    0x10(%ebp),%eax
  801586:	01 d0                	add    %edx,%eax
  801588:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80158e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  80159b:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8015a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8015a8:	01 d0                	add    %edx,%eax
  8015aa:	48                   	dec    %eax
  8015ab:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8015ae:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8015b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b6:	f7 75 ac             	divl   -0x54(%ebp)
  8015b9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8015bc:	29 d0                	sub    %edx,%eax
  8015be:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8015c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8015c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8015cf:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8015d6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8015dd:	eb 3f                	jmp    80161e <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8015df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015e2:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	50                   	push   %eax
  8015ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8015f0:	68 90 2c 80 00       	push   $0x802c90
  8015f5:	e8 11 f2 ff ff       	call   80080b <cprintf>
  8015fa:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  8015fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801600:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801607:	83 ec 04             	sub    $0x4,%esp
  80160a:	50                   	push   %eax
  80160b:	ff 75 e8             	pushl  -0x18(%ebp)
  80160e:	68 a5 2c 80 00       	push   $0x802ca5
  801613:	e8 f3 f1 ff ff       	call   80080b <cprintf>
  801618:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  80161b:	ff 45 e8             	incl   -0x18(%ebp)
  80161e:	a1 28 30 80 00       	mov    0x803028,%eax
  801623:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801626:	7c b7                	jl     8015df <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801628:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  80162f:	e9 42 01 00 00       	jmp    801776 <malloc+0x1e1>
		int flag0=1;
  801634:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  80163b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80163e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801641:	eb 6b                	jmp    8016ae <malloc+0x119>
			for(int k=0;k<count;k++){
  801643:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80164a:	eb 42                	jmp    80168e <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  80164c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80164f:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801656:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801659:	39 c2                	cmp    %eax,%edx
  80165b:	77 2e                	ja     80168b <malloc+0xf6>
  80165d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801660:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801667:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80166a:	39 c2                	cmp    %eax,%edx
  80166c:	76 1d                	jbe    80168b <malloc+0xf6>
					ni=arr_add[k].end-i;
  80166e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801671:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80167b:	29 c2                	sub    %eax,%edx
  80167d:	89 d0                	mov    %edx,%eax
  80167f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801682:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801689:	eb 0d                	jmp    801698 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  80168b:	ff 45 d8             	incl   -0x28(%ebp)
  80168e:	a1 28 30 80 00       	mov    0x803028,%eax
  801693:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801696:	7c b4                	jl     80164c <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801698:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80169c:	74 09                	je     8016a7 <malloc+0x112>
				flag0=0;
  80169e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8016a5:	eb 16                	jmp    8016bd <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8016a7:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8016ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	01 c2                	add    %eax,%edx
  8016b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016b9:	39 c2                	cmp    %eax,%edx
  8016bb:	77 86                	ja     801643 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8016bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016c1:	0f 84 a2 00 00 00    	je     801769 <malloc+0x1d4>

			int f=1;
  8016c7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  8016ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016d1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8016d4:	89 c8                	mov    %ecx,%eax
  8016d6:	01 c0                	add    %eax,%eax
  8016d8:	01 c8                	add    %ecx,%eax
  8016da:	c1 e0 02             	shl    $0x2,%eax
  8016dd:	05 20 31 80 00       	add    $0x803120,%eax
  8016e2:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  8016e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8016ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f0:	89 d0                	mov    %edx,%eax
  8016f2:	01 c0                	add    %eax,%eax
  8016f4:	01 d0                	add    %edx,%eax
  8016f6:	c1 e0 02             	shl    $0x2,%eax
  8016f9:	05 24 31 80 00       	add    $0x803124,%eax
  8016fe:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801700:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801703:	89 d0                	mov    %edx,%eax
  801705:	01 c0                	add    %eax,%eax
  801707:	01 d0                	add    %edx,%eax
  801709:	c1 e0 02             	shl    $0x2,%eax
  80170c:	05 28 31 80 00       	add    $0x803128,%eax
  801711:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801717:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  80171a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801721:	eb 36                	jmp    801759 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801723:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	01 c2                	add    %eax,%edx
  80172b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80172e:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801735:	39 c2                	cmp    %eax,%edx
  801737:	73 1d                	jae    801756 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801739:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80173c:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801746:	29 c2                	sub    %eax,%edx
  801748:	89 d0                	mov    %edx,%eax
  80174a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  80174d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801754:	eb 0d                	jmp    801763 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801756:	ff 45 d0             	incl   -0x30(%ebp)
  801759:	a1 28 30 80 00       	mov    0x803028,%eax
  80175e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801761:	7c c0                	jl     801723 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801763:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801767:	75 1d                	jne    801786 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801769:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801770:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801773:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801776:	a1 04 30 80 00       	mov    0x803004,%eax
  80177b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80177e:	0f 8c b0 fe ff ff    	jl     801634 <malloc+0x9f>
  801784:	eb 01                	jmp    801787 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801786:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801787:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80178b:	75 7a                	jne    801807 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  80178d:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	01 d0                	add    %edx,%eax
  801798:	48                   	dec    %eax
  801799:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80179e:	7c 0a                	jl     8017aa <malloc+0x215>
			return NULL;
  8017a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a5:	e9 a4 02 00 00       	jmp    801a4e <malloc+0x4b9>
		else{
			uint32 s=base_add;
  8017aa:	a1 04 30 80 00       	mov    0x803004,%eax
  8017af:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8017b2:	a1 28 30 80 00       	mov    0x803028,%eax
  8017b7:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8017ba:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  8017c1:	83 ec 08             	sub    $0x8,%esp
  8017c4:	ff 75 08             	pushl  0x8(%ebp)
  8017c7:	ff 75 a4             	pushl  -0x5c(%ebp)
  8017ca:	e8 04 06 00 00       	call   801dd3 <sys_allocateMem>
  8017cf:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  8017d2:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	01 d0                	add    %edx,%eax
  8017dd:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  8017e2:	a1 28 30 80 00       	mov    0x803028,%eax
  8017e7:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8017ed:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  8017f4:	a1 28 30 80 00       	mov    0x803028,%eax
  8017f9:	40                   	inc    %eax
  8017fa:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  8017ff:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801802:	e9 47 02 00 00       	jmp    801a4e <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801807:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80180e:	e9 ac 00 00 00       	jmp    8018bf <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801813:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801816:	89 d0                	mov    %edx,%eax
  801818:	01 c0                	add    %eax,%eax
  80181a:	01 d0                	add    %edx,%eax
  80181c:	c1 e0 02             	shl    $0x2,%eax
  80181f:	05 24 31 80 00       	add    $0x803124,%eax
  801824:	8b 00                	mov    (%eax),%eax
  801826:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801829:	eb 7e                	jmp    8018a9 <malloc+0x314>
			int flag=0;
  80182b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801832:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801839:	eb 57                	jmp    801892 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  80183b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80183e:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801845:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801848:	39 c2                	cmp    %eax,%edx
  80184a:	77 1a                	ja     801866 <malloc+0x2d1>
  80184c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80184f:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801856:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801859:	39 c2                	cmp    %eax,%edx
  80185b:	76 09                	jbe    801866 <malloc+0x2d1>
								flag=1;
  80185d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801864:	eb 36                	jmp    80189c <malloc+0x307>
			arr[i].space++;
  801866:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801869:	89 d0                	mov    %edx,%eax
  80186b:	01 c0                	add    %eax,%eax
  80186d:	01 d0                	add    %edx,%eax
  80186f:	c1 e0 02             	shl    $0x2,%eax
  801872:	05 28 31 80 00       	add    $0x803128,%eax
  801877:	8b 00                	mov    (%eax),%eax
  801879:	8d 48 01             	lea    0x1(%eax),%ecx
  80187c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80187f:	89 d0                	mov    %edx,%eax
  801881:	01 c0                	add    %eax,%eax
  801883:	01 d0                	add    %edx,%eax
  801885:	c1 e0 02             	shl    $0x2,%eax
  801888:	05 28 31 80 00       	add    $0x803128,%eax
  80188d:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  80188f:	ff 45 c0             	incl   -0x40(%ebp)
  801892:	a1 28 30 80 00       	mov    0x803028,%eax
  801897:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  80189a:	7c 9f                	jl     80183b <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  80189c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8018a0:	75 19                	jne    8018bb <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8018a2:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8018a9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8018ac:	a1 04 30 80 00       	mov    0x803004,%eax
  8018b1:	39 c2                	cmp    %eax,%edx
  8018b3:	0f 82 72 ff ff ff    	jb     80182b <malloc+0x296>
  8018b9:	eb 01                	jmp    8018bc <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  8018bb:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  8018bc:	ff 45 cc             	incl   -0x34(%ebp)
  8018bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018c5:	0f 8c 48 ff ff ff    	jl     801813 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  8018cb:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  8018d2:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  8018d9:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  8018e0:	eb 37                	jmp    801919 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  8018e2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8018e5:	89 d0                	mov    %edx,%eax
  8018e7:	01 c0                	add    %eax,%eax
  8018e9:	01 d0                	add    %edx,%eax
  8018eb:	c1 e0 02             	shl    $0x2,%eax
  8018ee:	05 28 31 80 00       	add    $0x803128,%eax
  8018f3:	8b 00                	mov    (%eax),%eax
  8018f5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8018f8:	7d 1c                	jge    801916 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  8018fa:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8018fd:	89 d0                	mov    %edx,%eax
  8018ff:	01 c0                	add    %eax,%eax
  801901:	01 d0                	add    %edx,%eax
  801903:	c1 e0 02             	shl    $0x2,%eax
  801906:	05 28 31 80 00       	add    $0x803128,%eax
  80190b:	8b 00                	mov    (%eax),%eax
  80190d:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801910:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801913:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801916:	ff 45 b4             	incl   -0x4c(%ebp)
  801919:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80191c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80191f:	7c c1                	jl     8018e2 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801921:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801927:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  80192a:	89 c8                	mov    %ecx,%eax
  80192c:	01 c0                	add    %eax,%eax
  80192e:	01 c8                	add    %ecx,%eax
  801930:	c1 e0 02             	shl    $0x2,%eax
  801933:	05 20 31 80 00       	add    $0x803120,%eax
  801938:	8b 00                	mov    (%eax),%eax
  80193a:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801941:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801947:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  80194a:	89 c8                	mov    %ecx,%eax
  80194c:	01 c0                	add    %eax,%eax
  80194e:	01 c8                	add    %ecx,%eax
  801950:	c1 e0 02             	shl    $0x2,%eax
  801953:	05 24 31 80 00       	add    $0x803124,%eax
  801958:	8b 00                	mov    (%eax),%eax
  80195a:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  801961:	a1 28 30 80 00       	mov    0x803028,%eax
  801966:	40                   	inc    %eax
  801967:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  80196c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80196f:	89 d0                	mov    %edx,%eax
  801971:	01 c0                	add    %eax,%eax
  801973:	01 d0                	add    %edx,%eax
  801975:	c1 e0 02             	shl    $0x2,%eax
  801978:	05 20 31 80 00       	add    $0x803120,%eax
  80197d:	8b 00                	mov    (%eax),%eax
  80197f:	83 ec 08             	sub    $0x8,%esp
  801982:	ff 75 08             	pushl  0x8(%ebp)
  801985:	50                   	push   %eax
  801986:	e8 48 04 00 00       	call   801dd3 <sys_allocateMem>
  80198b:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  80198e:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801995:	eb 78                	jmp    801a0f <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801997:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80199a:	89 d0                	mov    %edx,%eax
  80199c:	01 c0                	add    %eax,%eax
  80199e:	01 d0                	add    %edx,%eax
  8019a0:	c1 e0 02             	shl    $0x2,%eax
  8019a3:	05 20 31 80 00       	add    $0x803120,%eax
  8019a8:	8b 00                	mov    (%eax),%eax
  8019aa:	83 ec 04             	sub    $0x4,%esp
  8019ad:	50                   	push   %eax
  8019ae:	ff 75 b0             	pushl  -0x50(%ebp)
  8019b1:	68 90 2c 80 00       	push   $0x802c90
  8019b6:	e8 50 ee ff ff       	call   80080b <cprintf>
  8019bb:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8019be:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8019c1:	89 d0                	mov    %edx,%eax
  8019c3:	01 c0                	add    %eax,%eax
  8019c5:	01 d0                	add    %edx,%eax
  8019c7:	c1 e0 02             	shl    $0x2,%eax
  8019ca:	05 24 31 80 00       	add    $0x803124,%eax
  8019cf:	8b 00                	mov    (%eax),%eax
  8019d1:	83 ec 04             	sub    $0x4,%esp
  8019d4:	50                   	push   %eax
  8019d5:	ff 75 b0             	pushl  -0x50(%ebp)
  8019d8:	68 a5 2c 80 00       	push   $0x802ca5
  8019dd:	e8 29 ee ff ff       	call   80080b <cprintf>
  8019e2:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  8019e5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8019e8:	89 d0                	mov    %edx,%eax
  8019ea:	01 c0                	add    %eax,%eax
  8019ec:	01 d0                	add    %edx,%eax
  8019ee:	c1 e0 02             	shl    $0x2,%eax
  8019f1:	05 28 31 80 00       	add    $0x803128,%eax
  8019f6:	8b 00                	mov    (%eax),%eax
  8019f8:	83 ec 04             	sub    $0x4,%esp
  8019fb:	50                   	push   %eax
  8019fc:	ff 75 b0             	pushl  -0x50(%ebp)
  8019ff:	68 b8 2c 80 00       	push   $0x802cb8
  801a04:	e8 02 ee ff ff       	call   80080b <cprintf>
  801a09:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801a0c:	ff 45 b0             	incl   -0x50(%ebp)
  801a0f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801a12:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a15:	7c 80                	jl     801997 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801a17:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801a1a:	89 d0                	mov    %edx,%eax
  801a1c:	01 c0                	add    %eax,%eax
  801a1e:	01 d0                	add    %edx,%eax
  801a20:	c1 e0 02             	shl    $0x2,%eax
  801a23:	05 20 31 80 00       	add    $0x803120,%eax
  801a28:	8b 00                	mov    (%eax),%eax
  801a2a:	83 ec 08             	sub    $0x8,%esp
  801a2d:	50                   	push   %eax
  801a2e:	68 cc 2c 80 00       	push   $0x802ccc
  801a33:	e8 d3 ed ff ff       	call   80080b <cprintf>
  801a38:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801a3b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801a3e:	89 d0                	mov    %edx,%eax
  801a40:	01 c0                	add    %eax,%eax
  801a42:	01 d0                	add    %edx,%eax
  801a44:	c1 e0 02             	shl    $0x2,%eax
  801a47:	05 20 31 80 00       	add    $0x803120,%eax
  801a4c:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801a5c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801a63:	eb 4b                	jmp    801ab0 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a68:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801a6f:	89 c2                	mov    %eax,%edx
  801a71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a74:	39 c2                	cmp    %eax,%edx
  801a76:	7f 35                	jg     801aad <free+0x5d>
  801a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a7b:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801a82:	89 c2                	mov    %eax,%edx
  801a84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a87:	39 c2                	cmp    %eax,%edx
  801a89:	7e 22                	jle    801aad <free+0x5d>
				start=arr_add[i].start;
  801a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a8e:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a9b:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801aa2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801aab:	eb 0d                	jmp    801aba <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801aad:	ff 45 ec             	incl   -0x14(%ebp)
  801ab0:	a1 28 30 80 00       	mov    0x803028,%eax
  801ab5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801ab8:	7c ab                	jl     801a65 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abd:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac7:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801ace:	29 c2                	sub    %eax,%edx
  801ad0:	89 d0                	mov    %edx,%eax
  801ad2:	83 ec 08             	sub    $0x8,%esp
  801ad5:	50                   	push   %eax
  801ad6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad9:	e8 d9 02 00 00       	call   801db7 <sys_freeMem>
  801ade:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ae7:	eb 2d                	jmp    801b16 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801ae9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aec:	40                   	inc    %eax
  801aed:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801af4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801af7:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b01:	40                   	inc    %eax
  801b02:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801b09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b0c:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801b13:	ff 45 e8             	incl   -0x18(%ebp)
  801b16:	a1 28 30 80 00       	mov    0x803028,%eax
  801b1b:	48                   	dec    %eax
  801b1c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b1f:	7f c8                	jg     801ae9 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801b21:	a1 28 30 80 00       	mov    0x803028,%eax
  801b26:	48                   	dec    %eax
  801b27:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801b2c:	90                   	nop
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	83 ec 18             	sub    $0x18,%esp
  801b35:	8b 45 10             	mov    0x10(%ebp),%eax
  801b38:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801b3b:	83 ec 04             	sub    $0x4,%esp
  801b3e:	68 e8 2c 80 00       	push   $0x802ce8
  801b43:	68 18 01 00 00       	push   $0x118
  801b48:	68 0b 2d 80 00       	push   $0x802d0b
  801b4d:	e8 17 ea ff ff       	call   800569 <_panic>

00801b52 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b58:	83 ec 04             	sub    $0x4,%esp
  801b5b:	68 e8 2c 80 00       	push   $0x802ce8
  801b60:	68 1e 01 00 00       	push   $0x11e
  801b65:	68 0b 2d 80 00       	push   $0x802d0b
  801b6a:	e8 fa e9 ff ff       	call   800569 <_panic>

00801b6f <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b75:	83 ec 04             	sub    $0x4,%esp
  801b78:	68 e8 2c 80 00       	push   $0x802ce8
  801b7d:	68 24 01 00 00       	push   $0x124
  801b82:	68 0b 2d 80 00       	push   $0x802d0b
  801b87:	e8 dd e9 ff ff       	call   800569 <_panic>

00801b8c <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b92:	83 ec 04             	sub    $0x4,%esp
  801b95:	68 e8 2c 80 00       	push   $0x802ce8
  801b9a:	68 29 01 00 00       	push   $0x129
  801b9f:	68 0b 2d 80 00       	push   $0x802d0b
  801ba4:	e8 c0 e9 ff ff       	call   800569 <_panic>

00801ba9 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	68 e8 2c 80 00       	push   $0x802ce8
  801bb7:	68 2f 01 00 00       	push   $0x12f
  801bbc:	68 0b 2d 80 00       	push   $0x802d0b
  801bc1:	e8 a3 e9 ff ff       	call   800569 <_panic>

00801bc6 <shrink>:
}
void shrink(uint32 newSize)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801bcc:	83 ec 04             	sub    $0x4,%esp
  801bcf:	68 e8 2c 80 00       	push   $0x802ce8
  801bd4:	68 33 01 00 00       	push   $0x133
  801bd9:	68 0b 2d 80 00       	push   $0x802d0b
  801bde:	e8 86 e9 ff ff       	call   800569 <_panic>

00801be3 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801be9:	83 ec 04             	sub    $0x4,%esp
  801bec:	68 e8 2c 80 00       	push   $0x802ce8
  801bf1:	68 38 01 00 00       	push   $0x138
  801bf6:	68 0b 2d 80 00       	push   $0x802d0b
  801bfb:	e8 69 e9 ff ff       	call   800569 <_panic>

00801c00 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	57                   	push   %edi
  801c04:	56                   	push   %esi
  801c05:	53                   	push   %ebx
  801c06:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c12:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c15:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c18:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c1b:	cd 30                	int    $0x30
  801c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c23:	83 c4 10             	add    $0x10,%esp
  801c26:	5b                   	pop    %ebx
  801c27:	5e                   	pop    %esi
  801c28:	5f                   	pop    %edi
  801c29:	5d                   	pop    %ebp
  801c2a:	c3                   	ret    

00801c2b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	8b 45 10             	mov    0x10(%ebp),%eax
  801c34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c37:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	52                   	push   %edx
  801c43:	ff 75 0c             	pushl  0xc(%ebp)
  801c46:	50                   	push   %eax
  801c47:	6a 00                	push   $0x0
  801c49:	e8 b2 ff ff ff       	call   801c00 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	90                   	nop
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 01                	push   $0x1
  801c63:	e8 98 ff ff ff       	call   801c00 <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	50                   	push   %eax
  801c7c:	6a 05                	push   $0x5
  801c7e:	e8 7d ff ff ff       	call   801c00 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 02                	push   $0x2
  801c97:	e8 64 ff ff ff       	call   801c00 <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 03                	push   $0x3
  801cb0:	e8 4b ff ff ff       	call   801c00 <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 04                	push   $0x4
  801cc9:	e8 32 ff ff ff       	call   801c00 <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_env_exit>:


void sys_env_exit(void)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 06                	push   $0x6
  801ce2:	e8 19 ff ff ff       	call   801c00 <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
}
  801cea:	90                   	nop
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	52                   	push   %edx
  801cfd:	50                   	push   %eax
  801cfe:	6a 07                	push   $0x7
  801d00:	e8 fb fe ff ff       	call   801c00 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	56                   	push   %esi
  801d0e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d0f:	8b 75 18             	mov    0x18(%ebp),%esi
  801d12:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d15:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	56                   	push   %esi
  801d1f:	53                   	push   %ebx
  801d20:	51                   	push   %ecx
  801d21:	52                   	push   %edx
  801d22:	50                   	push   %eax
  801d23:	6a 08                	push   $0x8
  801d25:	e8 d6 fe ff ff       	call   801c00 <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
}
  801d2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d30:	5b                   	pop    %ebx
  801d31:	5e                   	pop    %esi
  801d32:	5d                   	pop    %ebp
  801d33:	c3                   	ret    

00801d34 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	52                   	push   %edx
  801d44:	50                   	push   %eax
  801d45:	6a 09                	push   $0x9
  801d47:	e8 b4 fe ff ff       	call   801c00 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	ff 75 0c             	pushl  0xc(%ebp)
  801d5d:	ff 75 08             	pushl  0x8(%ebp)
  801d60:	6a 0a                	push   $0xa
  801d62:	e8 99 fe ff ff       	call   801c00 <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 0b                	push   $0xb
  801d7b:	e8 80 fe ff ff       	call   801c00 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 0c                	push   $0xc
  801d94:	e8 67 fe ff ff       	call   801c00 <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 0d                	push   $0xd
  801dad:	e8 4e fe ff ff       	call   801c00 <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	ff 75 0c             	pushl  0xc(%ebp)
  801dc3:	ff 75 08             	pushl  0x8(%ebp)
  801dc6:	6a 11                	push   $0x11
  801dc8:	e8 33 fe ff ff       	call   801c00 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
	return;
  801dd0:	90                   	nop
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	ff 75 0c             	pushl  0xc(%ebp)
  801ddf:	ff 75 08             	pushl  0x8(%ebp)
  801de2:	6a 12                	push   $0x12
  801de4:	e8 17 fe ff ff       	call   801c00 <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dec:	90                   	nop
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 0e                	push   $0xe
  801dfe:	e8 fd fd ff ff       	call   801c00 <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	ff 75 08             	pushl  0x8(%ebp)
  801e16:	6a 0f                	push   $0xf
  801e18:	e8 e3 fd ff ff       	call   801c00 <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 10                	push   $0x10
  801e31:	e8 ca fd ff ff       	call   801c00 <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	90                   	nop
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 14                	push   $0x14
  801e4b:	e8 b0 fd ff ff       	call   801c00 <syscall>
  801e50:	83 c4 18             	add    $0x18,%esp
}
  801e53:	90                   	nop
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 15                	push   $0x15
  801e65:	e8 96 fd ff ff       	call   801c00 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
}
  801e6d:	90                   	nop
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 04             	sub    $0x4,%esp
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e7c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	50                   	push   %eax
  801e89:	6a 16                	push   $0x16
  801e8b:	e8 70 fd ff ff       	call   801c00 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	90                   	nop
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 17                	push   $0x17
  801ea5:	e8 56 fd ff ff       	call   801c00 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	90                   	nop
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	ff 75 0c             	pushl  0xc(%ebp)
  801ebf:	50                   	push   %eax
  801ec0:	6a 18                	push   $0x18
  801ec2:	e8 39 fd ff ff       	call   801c00 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	52                   	push   %edx
  801edc:	50                   	push   %eax
  801edd:	6a 1b                	push   $0x1b
  801edf:	e8 1c fd ff ff       	call   801c00 <syscall>
  801ee4:	83 c4 18             	add    $0x18,%esp
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	52                   	push   %edx
  801ef9:	50                   	push   %eax
  801efa:	6a 19                	push   $0x19
  801efc:	e8 ff fc ff ff       	call   801c00 <syscall>
  801f01:	83 c4 18             	add    $0x18,%esp
}
  801f04:	90                   	nop
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	52                   	push   %edx
  801f17:	50                   	push   %eax
  801f18:	6a 1a                	push   $0x1a
  801f1a:	e8 e1 fc ff ff       	call   801c00 <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
}
  801f22:	90                   	nop
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
  801f28:	83 ec 04             	sub    $0x4,%esp
  801f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f31:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f34:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	51                   	push   %ecx
  801f3e:	52                   	push   %edx
  801f3f:	ff 75 0c             	pushl  0xc(%ebp)
  801f42:	50                   	push   %eax
  801f43:	6a 1c                	push   $0x1c
  801f45:	e8 b6 fc ff ff       	call   801c00 <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	52                   	push   %edx
  801f5f:	50                   	push   %eax
  801f60:	6a 1d                	push   $0x1d
  801f62:	e8 99 fc ff ff       	call   801c00 <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	51                   	push   %ecx
  801f7d:	52                   	push   %edx
  801f7e:	50                   	push   %eax
  801f7f:	6a 1e                	push   $0x1e
  801f81:	e8 7a fc ff ff       	call   801c00 <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	52                   	push   %edx
  801f9b:	50                   	push   %eax
  801f9c:	6a 1f                	push   $0x1f
  801f9e:	e8 5d fc ff ff       	call   801c00 <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 20                	push   $0x20
  801fb7:	e8 44 fc ff ff       	call   801c00 <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	6a 00                	push   $0x0
  801fc9:	ff 75 14             	pushl  0x14(%ebp)
  801fcc:	ff 75 10             	pushl  0x10(%ebp)
  801fcf:	ff 75 0c             	pushl  0xc(%ebp)
  801fd2:	50                   	push   %eax
  801fd3:	6a 21                	push   $0x21
  801fd5:	e8 26 fc ff ff       	call   801c00 <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	50                   	push   %eax
  801fee:	6a 22                	push   $0x22
  801ff0:	e8 0b fc ff ff       	call   801c00 <syscall>
  801ff5:	83 c4 18             	add    $0x18,%esp
}
  801ff8:	90                   	nop
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	50                   	push   %eax
  80200a:	6a 23                	push   $0x23
  80200c:	e8 ef fb ff ff       	call   801c00 <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	90                   	nop
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80201d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802020:	8d 50 04             	lea    0x4(%eax),%edx
  802023:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	52                   	push   %edx
  80202d:	50                   	push   %eax
  80202e:	6a 24                	push   $0x24
  802030:	e8 cb fb ff ff       	call   801c00 <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
	return result;
  802038:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80203b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80203e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802041:	89 01                	mov    %eax,(%ecx)
  802043:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	c9                   	leave  
  80204a:	c2 04 00             	ret    $0x4

0080204d <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	ff 75 10             	pushl  0x10(%ebp)
  802057:	ff 75 0c             	pushl  0xc(%ebp)
  80205a:	ff 75 08             	pushl  0x8(%ebp)
  80205d:	6a 13                	push   $0x13
  80205f:	e8 9c fb ff ff       	call   801c00 <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
	return ;
  802067:	90                   	nop
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_rcr2>:
uint32 sys_rcr2()
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 25                	push   $0x25
  802079:	e8 82 fb ff ff       	call   801c00 <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	83 ec 04             	sub    $0x4,%esp
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80208f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	50                   	push   %eax
  80209c:	6a 26                	push   $0x26
  80209e:	e8 5d fb ff ff       	call   801c00 <syscall>
  8020a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a6:	90                   	nop
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <rsttst>:
void rsttst()
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 28                	push   $0x28
  8020b8:	e8 43 fb ff ff       	call   801c00 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c0:	90                   	nop
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 04             	sub    $0x4,%esp
  8020c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8020cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020cf:	8b 55 18             	mov    0x18(%ebp),%edx
  8020d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020d6:	52                   	push   %edx
  8020d7:	50                   	push   %eax
  8020d8:	ff 75 10             	pushl  0x10(%ebp)
  8020db:	ff 75 0c             	pushl  0xc(%ebp)
  8020de:	ff 75 08             	pushl  0x8(%ebp)
  8020e1:	6a 27                	push   $0x27
  8020e3:	e8 18 fb ff ff       	call   801c00 <syscall>
  8020e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8020eb:	90                   	nop
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <chktst>:
void chktst(uint32 n)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	ff 75 08             	pushl  0x8(%ebp)
  8020fc:	6a 29                	push   $0x29
  8020fe:	e8 fd fa ff ff       	call   801c00 <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
	return ;
  802106:	90                   	nop
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <inctst>:

void inctst()
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 2a                	push   $0x2a
  802118:	e8 e3 fa ff ff       	call   801c00 <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
	return ;
  802120:	90                   	nop
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <gettst>:
uint32 gettst()
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 2b                	push   $0x2b
  802132:	e8 c9 fa ff ff       	call   801c00 <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 2c                	push   $0x2c
  80214e:	e8 ad fa ff ff       	call   801c00 <syscall>
  802153:	83 c4 18             	add    $0x18,%esp
  802156:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802159:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80215d:	75 07                	jne    802166 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80215f:	b8 01 00 00 00       	mov    $0x1,%eax
  802164:	eb 05                	jmp    80216b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802166:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 2c                	push   $0x2c
  80217f:	e8 7c fa ff ff       	call   801c00 <syscall>
  802184:	83 c4 18             	add    $0x18,%esp
  802187:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80218a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80218e:	75 07                	jne    802197 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802190:	b8 01 00 00 00       	mov    $0x1,%eax
  802195:	eb 05                	jmp    80219c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802197:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 2c                	push   $0x2c
  8021b0:	e8 4b fa ff ff       	call   801c00 <syscall>
  8021b5:	83 c4 18             	add    $0x18,%esp
  8021b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021bb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021bf:	75 07                	jne    8021c8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c6:	eb 05                	jmp    8021cd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 2c                	push   $0x2c
  8021e1:	e8 1a fa ff ff       	call   801c00 <syscall>
  8021e6:	83 c4 18             	add    $0x18,%esp
  8021e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021ec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021f0:	75 07                	jne    8021f9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f7:	eb 05                	jmp    8021fe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	ff 75 08             	pushl  0x8(%ebp)
  80220e:	6a 2d                	push   $0x2d
  802210:	e8 eb f9 ff ff       	call   801c00 <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
	return ;
  802218:	90                   	nop
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80221f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802222:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802225:	8b 55 0c             	mov    0xc(%ebp),%edx
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	6a 00                	push   $0x0
  80222d:	53                   	push   %ebx
  80222e:	51                   	push   %ecx
  80222f:	52                   	push   %edx
  802230:	50                   	push   %eax
  802231:	6a 2e                	push   $0x2e
  802233:	e8 c8 f9 ff ff       	call   801c00 <syscall>
  802238:	83 c4 18             	add    $0x18,%esp
}
  80223b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802243:	8b 55 0c             	mov    0xc(%ebp),%edx
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	52                   	push   %edx
  802250:	50                   	push   %eax
  802251:	6a 2f                	push   $0x2f
  802253:	e8 a8 f9 ff ff       	call   801c00 <syscall>
  802258:	83 c4 18             	add    $0x18,%esp
}
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    
  80225d:	66 90                	xchg   %ax,%ax
  80225f:	90                   	nop

00802260 <__udivdi3>:
  802260:	55                   	push   %ebp
  802261:	57                   	push   %edi
  802262:	56                   	push   %esi
  802263:	53                   	push   %ebx
  802264:	83 ec 1c             	sub    $0x1c,%esp
  802267:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80226b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80226f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802273:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802277:	89 ca                	mov    %ecx,%edx
  802279:	89 f8                	mov    %edi,%eax
  80227b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80227f:	85 f6                	test   %esi,%esi
  802281:	75 2d                	jne    8022b0 <__udivdi3+0x50>
  802283:	39 cf                	cmp    %ecx,%edi
  802285:	77 65                	ja     8022ec <__udivdi3+0x8c>
  802287:	89 fd                	mov    %edi,%ebp
  802289:	85 ff                	test   %edi,%edi
  80228b:	75 0b                	jne    802298 <__udivdi3+0x38>
  80228d:	b8 01 00 00 00       	mov    $0x1,%eax
  802292:	31 d2                	xor    %edx,%edx
  802294:	f7 f7                	div    %edi
  802296:	89 c5                	mov    %eax,%ebp
  802298:	31 d2                	xor    %edx,%edx
  80229a:	89 c8                	mov    %ecx,%eax
  80229c:	f7 f5                	div    %ebp
  80229e:	89 c1                	mov    %eax,%ecx
  8022a0:	89 d8                	mov    %ebx,%eax
  8022a2:	f7 f5                	div    %ebp
  8022a4:	89 cf                	mov    %ecx,%edi
  8022a6:	89 fa                	mov    %edi,%edx
  8022a8:	83 c4 1c             	add    $0x1c,%esp
  8022ab:	5b                   	pop    %ebx
  8022ac:	5e                   	pop    %esi
  8022ad:	5f                   	pop    %edi
  8022ae:	5d                   	pop    %ebp
  8022af:	c3                   	ret    
  8022b0:	39 ce                	cmp    %ecx,%esi
  8022b2:	77 28                	ja     8022dc <__udivdi3+0x7c>
  8022b4:	0f bd fe             	bsr    %esi,%edi
  8022b7:	83 f7 1f             	xor    $0x1f,%edi
  8022ba:	75 40                	jne    8022fc <__udivdi3+0x9c>
  8022bc:	39 ce                	cmp    %ecx,%esi
  8022be:	72 0a                	jb     8022ca <__udivdi3+0x6a>
  8022c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8022c4:	0f 87 9e 00 00 00    	ja     802368 <__udivdi3+0x108>
  8022ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cf:	89 fa                	mov    %edi,%edx
  8022d1:	83 c4 1c             	add    $0x1c,%esp
  8022d4:	5b                   	pop    %ebx
  8022d5:	5e                   	pop    %esi
  8022d6:	5f                   	pop    %edi
  8022d7:	5d                   	pop    %ebp
  8022d8:	c3                   	ret    
  8022d9:	8d 76 00             	lea    0x0(%esi),%esi
  8022dc:	31 ff                	xor    %edi,%edi
  8022de:	31 c0                	xor    %eax,%eax
  8022e0:	89 fa                	mov    %edi,%edx
  8022e2:	83 c4 1c             	add    $0x1c,%esp
  8022e5:	5b                   	pop    %ebx
  8022e6:	5e                   	pop    %esi
  8022e7:	5f                   	pop    %edi
  8022e8:	5d                   	pop    %ebp
  8022e9:	c3                   	ret    
  8022ea:	66 90                	xchg   %ax,%ax
  8022ec:	89 d8                	mov    %ebx,%eax
  8022ee:	f7 f7                	div    %edi
  8022f0:	31 ff                	xor    %edi,%edi
  8022f2:	89 fa                	mov    %edi,%edx
  8022f4:	83 c4 1c             	add    $0x1c,%esp
  8022f7:	5b                   	pop    %ebx
  8022f8:	5e                   	pop    %esi
  8022f9:	5f                   	pop    %edi
  8022fa:	5d                   	pop    %ebp
  8022fb:	c3                   	ret    
  8022fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  802301:	89 eb                	mov    %ebp,%ebx
  802303:	29 fb                	sub    %edi,%ebx
  802305:	89 f9                	mov    %edi,%ecx
  802307:	d3 e6                	shl    %cl,%esi
  802309:	89 c5                	mov    %eax,%ebp
  80230b:	88 d9                	mov    %bl,%cl
  80230d:	d3 ed                	shr    %cl,%ebp
  80230f:	89 e9                	mov    %ebp,%ecx
  802311:	09 f1                	or     %esi,%ecx
  802313:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802317:	89 f9                	mov    %edi,%ecx
  802319:	d3 e0                	shl    %cl,%eax
  80231b:	89 c5                	mov    %eax,%ebp
  80231d:	89 d6                	mov    %edx,%esi
  80231f:	88 d9                	mov    %bl,%cl
  802321:	d3 ee                	shr    %cl,%esi
  802323:	89 f9                	mov    %edi,%ecx
  802325:	d3 e2                	shl    %cl,%edx
  802327:	8b 44 24 08          	mov    0x8(%esp),%eax
  80232b:	88 d9                	mov    %bl,%cl
  80232d:	d3 e8                	shr    %cl,%eax
  80232f:	09 c2                	or     %eax,%edx
  802331:	89 d0                	mov    %edx,%eax
  802333:	89 f2                	mov    %esi,%edx
  802335:	f7 74 24 0c          	divl   0xc(%esp)
  802339:	89 d6                	mov    %edx,%esi
  80233b:	89 c3                	mov    %eax,%ebx
  80233d:	f7 e5                	mul    %ebp
  80233f:	39 d6                	cmp    %edx,%esi
  802341:	72 19                	jb     80235c <__udivdi3+0xfc>
  802343:	74 0b                	je     802350 <__udivdi3+0xf0>
  802345:	89 d8                	mov    %ebx,%eax
  802347:	31 ff                	xor    %edi,%edi
  802349:	e9 58 ff ff ff       	jmp    8022a6 <__udivdi3+0x46>
  80234e:	66 90                	xchg   %ax,%ax
  802350:	8b 54 24 08          	mov    0x8(%esp),%edx
  802354:	89 f9                	mov    %edi,%ecx
  802356:	d3 e2                	shl    %cl,%edx
  802358:	39 c2                	cmp    %eax,%edx
  80235a:	73 e9                	jae    802345 <__udivdi3+0xe5>
  80235c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80235f:	31 ff                	xor    %edi,%edi
  802361:	e9 40 ff ff ff       	jmp    8022a6 <__udivdi3+0x46>
  802366:	66 90                	xchg   %ax,%ax
  802368:	31 c0                	xor    %eax,%eax
  80236a:	e9 37 ff ff ff       	jmp    8022a6 <__udivdi3+0x46>
  80236f:	90                   	nop

00802370 <__umoddi3>:
  802370:	55                   	push   %ebp
  802371:	57                   	push   %edi
  802372:	56                   	push   %esi
  802373:	53                   	push   %ebx
  802374:	83 ec 1c             	sub    $0x1c,%esp
  802377:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80237b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80237f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802383:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802387:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80238b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80238f:	89 f3                	mov    %esi,%ebx
  802391:	89 fa                	mov    %edi,%edx
  802393:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802397:	89 34 24             	mov    %esi,(%esp)
  80239a:	85 c0                	test   %eax,%eax
  80239c:	75 1a                	jne    8023b8 <__umoddi3+0x48>
  80239e:	39 f7                	cmp    %esi,%edi
  8023a0:	0f 86 a2 00 00 00    	jbe    802448 <__umoddi3+0xd8>
  8023a6:	89 c8                	mov    %ecx,%eax
  8023a8:	89 f2                	mov    %esi,%edx
  8023aa:	f7 f7                	div    %edi
  8023ac:	89 d0                	mov    %edx,%eax
  8023ae:	31 d2                	xor    %edx,%edx
  8023b0:	83 c4 1c             	add    $0x1c,%esp
  8023b3:	5b                   	pop    %ebx
  8023b4:	5e                   	pop    %esi
  8023b5:	5f                   	pop    %edi
  8023b6:	5d                   	pop    %ebp
  8023b7:	c3                   	ret    
  8023b8:	39 f0                	cmp    %esi,%eax
  8023ba:	0f 87 ac 00 00 00    	ja     80246c <__umoddi3+0xfc>
  8023c0:	0f bd e8             	bsr    %eax,%ebp
  8023c3:	83 f5 1f             	xor    $0x1f,%ebp
  8023c6:	0f 84 ac 00 00 00    	je     802478 <__umoddi3+0x108>
  8023cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8023d1:	29 ef                	sub    %ebp,%edi
  8023d3:	89 fe                	mov    %edi,%esi
  8023d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023d9:	89 e9                	mov    %ebp,%ecx
  8023db:	d3 e0                	shl    %cl,%eax
  8023dd:	89 d7                	mov    %edx,%edi
  8023df:	89 f1                	mov    %esi,%ecx
  8023e1:	d3 ef                	shr    %cl,%edi
  8023e3:	09 c7                	or     %eax,%edi
  8023e5:	89 e9                	mov    %ebp,%ecx
  8023e7:	d3 e2                	shl    %cl,%edx
  8023e9:	89 14 24             	mov    %edx,(%esp)
  8023ec:	89 d8                	mov    %ebx,%eax
  8023ee:	d3 e0                	shl    %cl,%eax
  8023f0:	89 c2                	mov    %eax,%edx
  8023f2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023f6:	d3 e0                	shl    %cl,%eax
  8023f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023fc:	8b 44 24 08          	mov    0x8(%esp),%eax
  802400:	89 f1                	mov    %esi,%ecx
  802402:	d3 e8                	shr    %cl,%eax
  802404:	09 d0                	or     %edx,%eax
  802406:	d3 eb                	shr    %cl,%ebx
  802408:	89 da                	mov    %ebx,%edx
  80240a:	f7 f7                	div    %edi
  80240c:	89 d3                	mov    %edx,%ebx
  80240e:	f7 24 24             	mull   (%esp)
  802411:	89 c6                	mov    %eax,%esi
  802413:	89 d1                	mov    %edx,%ecx
  802415:	39 d3                	cmp    %edx,%ebx
  802417:	0f 82 87 00 00 00    	jb     8024a4 <__umoddi3+0x134>
  80241d:	0f 84 91 00 00 00    	je     8024b4 <__umoddi3+0x144>
  802423:	8b 54 24 04          	mov    0x4(%esp),%edx
  802427:	29 f2                	sub    %esi,%edx
  802429:	19 cb                	sbb    %ecx,%ebx
  80242b:	89 d8                	mov    %ebx,%eax
  80242d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802431:	d3 e0                	shl    %cl,%eax
  802433:	89 e9                	mov    %ebp,%ecx
  802435:	d3 ea                	shr    %cl,%edx
  802437:	09 d0                	or     %edx,%eax
  802439:	89 e9                	mov    %ebp,%ecx
  80243b:	d3 eb                	shr    %cl,%ebx
  80243d:	89 da                	mov    %ebx,%edx
  80243f:	83 c4 1c             	add    $0x1c,%esp
  802442:	5b                   	pop    %ebx
  802443:	5e                   	pop    %esi
  802444:	5f                   	pop    %edi
  802445:	5d                   	pop    %ebp
  802446:	c3                   	ret    
  802447:	90                   	nop
  802448:	89 fd                	mov    %edi,%ebp
  80244a:	85 ff                	test   %edi,%edi
  80244c:	75 0b                	jne    802459 <__umoddi3+0xe9>
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	31 d2                	xor    %edx,%edx
  802455:	f7 f7                	div    %edi
  802457:	89 c5                	mov    %eax,%ebp
  802459:	89 f0                	mov    %esi,%eax
  80245b:	31 d2                	xor    %edx,%edx
  80245d:	f7 f5                	div    %ebp
  80245f:	89 c8                	mov    %ecx,%eax
  802461:	f7 f5                	div    %ebp
  802463:	89 d0                	mov    %edx,%eax
  802465:	e9 44 ff ff ff       	jmp    8023ae <__umoddi3+0x3e>
  80246a:	66 90                	xchg   %ax,%ax
  80246c:	89 c8                	mov    %ecx,%eax
  80246e:	89 f2                	mov    %esi,%edx
  802470:	83 c4 1c             	add    $0x1c,%esp
  802473:	5b                   	pop    %ebx
  802474:	5e                   	pop    %esi
  802475:	5f                   	pop    %edi
  802476:	5d                   	pop    %ebp
  802477:	c3                   	ret    
  802478:	3b 04 24             	cmp    (%esp),%eax
  80247b:	72 06                	jb     802483 <__umoddi3+0x113>
  80247d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802481:	77 0f                	ja     802492 <__umoddi3+0x122>
  802483:	89 f2                	mov    %esi,%edx
  802485:	29 f9                	sub    %edi,%ecx
  802487:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80248b:	89 14 24             	mov    %edx,(%esp)
  80248e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802492:	8b 44 24 04          	mov    0x4(%esp),%eax
  802496:	8b 14 24             	mov    (%esp),%edx
  802499:	83 c4 1c             	add    $0x1c,%esp
  80249c:	5b                   	pop    %ebx
  80249d:	5e                   	pop    %esi
  80249e:	5f                   	pop    %edi
  80249f:	5d                   	pop    %ebp
  8024a0:	c3                   	ret    
  8024a1:	8d 76 00             	lea    0x0(%esi),%esi
  8024a4:	2b 04 24             	sub    (%esp),%eax
  8024a7:	19 fa                	sbb    %edi,%edx
  8024a9:	89 d1                	mov    %edx,%ecx
  8024ab:	89 c6                	mov    %eax,%esi
  8024ad:	e9 71 ff ff ff       	jmp    802423 <__umoddi3+0xb3>
  8024b2:	66 90                	xchg   %ax,%ax
  8024b4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8024b8:	72 ea                	jb     8024a4 <__umoddi3+0x134>
  8024ba:	89 d9                	mov    %ebx,%ecx
  8024bc:	e9 62 ff ff ff       	jmp    802423 <__umoddi3+0xb3>
