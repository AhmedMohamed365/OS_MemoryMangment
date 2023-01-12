
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 99 05 00 00       	call   8005cf <libmain>
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
  80003d:	83 ec 70             	sub    $0x70,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800040:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800044:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004b:	eb 23                	jmp    800070 <_main+0x38>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004d:	a1 20 30 80 00       	mov    0x803020,%eax
  800052:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800058:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005b:	c1 e2 04             	shl    $0x4,%edx
  80005e:	01 d0                	add    %edx,%eax
  800060:	8a 40 04             	mov    0x4(%eax),%al
  800063:	84 c0                	test   %al,%al
  800065:	74 06                	je     80006d <_main+0x35>
			{
				fullWS = 0;
  800067:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006b:	eb 12                	jmp    80007f <_main+0x47>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006d:	ff 45 f0             	incl   -0x10(%ebp)
  800070:	a1 20 30 80 00       	mov    0x803020,%eax
  800075:	8b 50 74             	mov    0x74(%eax),%edx
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	39 c2                	cmp    %eax,%edx
  80007d:	77 ce                	ja     80004d <_main+0x15>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007f:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800083:	74 14                	je     800099 <_main+0x61>
  800085:	83 ec 04             	sub    $0x4,%esp
  800088:	68 80 26 80 00       	push   $0x802680
  80008d:	6a 14                	push   $0x14
  80008f:	68 9c 26 80 00       	push   $0x80269c
  800094:	e8 7b 06 00 00       	call   800714 <_panic>
	}


	int Mega = 1024*1024;
  800099:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000a0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	void* ptr_allocations[20] = {0};
  8000a7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000aa:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	89 d7                	mov    %edx,%edi
  8000b6:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 5a 1e 00 00       	call   801f17 <sys_calculate_free_frames>
  8000bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c0:	e8 d5 1e 00 00       	call   801f9a <sys_pf_calculate_allocated_pages>
  8000c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cb:	01 c0                	add    %eax,%eax
  8000cd:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 67 16 00 00       	call   801740 <malloc>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000df:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000e2:	85 c0                	test   %eax,%eax
  8000e4:	79 0a                	jns    8000f0 <_main+0xb8>
  8000e6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000e9:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  8000ee:	76 14                	jbe    800104 <_main+0xcc>
  8000f0:	83 ec 04             	sub    $0x4,%esp
  8000f3:	68 b0 26 80 00       	push   $0x8026b0
  8000f8:	6a 20                	push   $0x20
  8000fa:	68 9c 26 80 00       	push   $0x80269c
  8000ff:	e8 10 06 00 00       	call   800714 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800104:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800107:	e8 0b 1e 00 00       	call   801f17 <sys_calculate_free_frames>
  80010c:	29 c3                	sub    %eax,%ebx
  80010e:	89 d8                	mov    %ebx,%eax
  800110:	83 f8 01             	cmp    $0x1,%eax
  800113:	74 14                	je     800129 <_main+0xf1>
  800115:	83 ec 04             	sub    $0x4,%esp
  800118:	68 e0 26 80 00       	push   $0x8026e0
  80011d:	6a 22                	push   $0x22
  80011f:	68 9c 26 80 00       	push   $0x80269c
  800124:	e8 eb 05 00 00       	call   800714 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800129:	e8 6c 1e 00 00       	call   801f9a <sys_pf_calculate_allocated_pages>
  80012e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800131:	3d 00 02 00 00       	cmp    $0x200,%eax
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 4c 27 80 00       	push   $0x80274c
  800140:	6a 23                	push   $0x23
  800142:	68 9c 26 80 00       	push   $0x80269c
  800147:	e8 c8 05 00 00       	call   800714 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80014c:	e8 c6 1d 00 00       	call   801f17 <sys_calculate_free_frames>
  800151:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800154:	e8 41 1e 00 00       	call   801f9a <sys_pf_calculate_allocated_pages>
  800159:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80015c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015f:	01 c0                	add    %eax,%eax
  800161:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	50                   	push   %eax
  800168:	e8 d3 15 00 00       	call   801740 <malloc>
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START + 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800173:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800176:	89 c2                	mov    %eax,%edx
  800178:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017b:	01 c0                	add    %eax,%eax
  80017d:	05 00 00 00 80       	add    $0x80000000,%eax
  800182:	39 c2                	cmp    %eax,%edx
  800184:	72 13                	jb     800199 <_main+0x161>
  800186:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800189:	89 c2                	mov    %eax,%edx
  80018b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018e:	01 c0                	add    %eax,%eax
  800190:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	76 14                	jbe    8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 b0 26 80 00       	push   $0x8026b0
  8001a1:	6a 28                	push   $0x28
  8001a3:	68 9c 26 80 00       	push   $0x80269c
  8001a8:	e8 67 05 00 00       	call   800714 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001ad:	e8 65 1d 00 00       	call   801f17 <sys_calculate_free_frames>
  8001b2:	89 c2                	mov    %eax,%edx
  8001b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001b7:	39 c2                	cmp    %eax,%edx
  8001b9:	74 14                	je     8001cf <_main+0x197>
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	68 e0 26 80 00       	push   $0x8026e0
  8001c3:	6a 2a                	push   $0x2a
  8001c5:	68 9c 26 80 00       	push   $0x80269c
  8001ca:	e8 45 05 00 00       	call   800714 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8001cf:	e8 c6 1d 00 00       	call   801f9a <sys_pf_calculate_allocated_pages>
  8001d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001d7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001dc:	74 14                	je     8001f2 <_main+0x1ba>
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	68 4c 27 80 00       	push   $0x80274c
  8001e6:	6a 2b                	push   $0x2b
  8001e8:	68 9c 26 80 00       	push   $0x80269c
  8001ed:	e8 22 05 00 00       	call   800714 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001f2:	e8 20 1d 00 00       	call   801f17 <sys_calculate_free_frames>
  8001f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001fa:	e8 9b 1d 00 00       	call   801f9a <sys_pf_calculate_allocated_pages>
  8001ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800205:	89 c2                	mov    %eax,%edx
  800207:	01 d2                	add    %edx,%edx
  800209:	01 d0                	add    %edx,%eax
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	50                   	push   %eax
  80020f:	e8 2c 15 00 00       	call   801740 <malloc>
  800214:	83 c4 10             	add    $0x10,%esp
  800217:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80021a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80021d:	89 c2                	mov    %eax,%edx
  80021f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800222:	c1 e0 02             	shl    $0x2,%eax
  800225:	05 00 00 00 80       	add    $0x80000000,%eax
  80022a:	39 c2                	cmp    %eax,%edx
  80022c:	72 14                	jb     800242 <_main+0x20a>
  80022e:	8b 45 98             	mov    -0x68(%ebp),%eax
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800236:	c1 e0 02             	shl    $0x2,%eax
  800239:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80023e:	39 c2                	cmp    %eax,%edx
  800240:	76 14                	jbe    800256 <_main+0x21e>
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	68 b0 26 80 00       	push   $0x8026b0
  80024a:	6a 30                	push   $0x30
  80024c:	68 9c 26 80 00       	push   $0x80269c
  800251:	e8 be 04 00 00       	call   800714 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800256:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800259:	e8 b9 1c 00 00       	call   801f17 <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 01             	cmp    $0x1,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 e0 26 80 00       	push   $0x8026e0
  80026f:	6a 32                	push   $0x32
  800271:	68 9c 26 80 00       	push   $0x80269c
  800276:	e8 99 04 00 00       	call   800714 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  80027b:	e8 1a 1d 00 00       	call   801f9a <sys_pf_calculate_allocated_pages>
  800280:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800283:	83 f8 01             	cmp    $0x1,%eax
  800286:	74 14                	je     80029c <_main+0x264>
  800288:	83 ec 04             	sub    $0x4,%esp
  80028b:	68 4c 27 80 00       	push   $0x80274c
  800290:	6a 33                	push   $0x33
  800292:	68 9c 26 80 00       	push   $0x80269c
  800297:	e8 78 04 00 00       	call   800714 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80029c:	e8 76 1c 00 00       	call   801f17 <sys_calculate_free_frames>
  8002a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002a4:	e8 f1 1c 00 00       	call   801f9a <sys_pf_calculate_allocated_pages>
  8002a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8002ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002af:	89 c2                	mov    %eax,%edx
  8002b1:	01 d2                	add    %edx,%edx
  8002b3:	01 d0                	add    %edx,%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 82 14 00 00       	call   801740 <malloc>
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8002c4:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002c7:	89 c2                	mov    %eax,%edx
  8002c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cc:	c1 e0 02             	shl    $0x2,%eax
  8002cf:	89 c1                	mov    %eax,%ecx
  8002d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d4:	c1 e0 02             	shl    $0x2,%eax
  8002d7:	01 c8                	add    %ecx,%eax
  8002d9:	05 00 00 00 80       	add    $0x80000000,%eax
  8002de:	39 c2                	cmp    %eax,%edx
  8002e0:	72 1e                	jb     800300 <_main+0x2c8>
  8002e2:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002e5:	89 c2                	mov    %eax,%edx
  8002e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002ea:	c1 e0 02             	shl    $0x2,%eax
  8002ed:	89 c1                	mov    %eax,%ecx
  8002ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f2:	c1 e0 02             	shl    $0x2,%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002fc:	39 c2                	cmp    %eax,%edx
  8002fe:	76 14                	jbe    800314 <_main+0x2dc>
  800300:	83 ec 04             	sub    $0x4,%esp
  800303:	68 b0 26 80 00       	push   $0x8026b0
  800308:	6a 38                	push   $0x38
  80030a:	68 9c 26 80 00       	push   $0x80269c
  80030f:	e8 00 04 00 00       	call   800714 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800314:	e8 fe 1b 00 00       	call   801f17 <sys_calculate_free_frames>
  800319:	89 c2                	mov    %eax,%edx
  80031b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031e:	39 c2                	cmp    %eax,%edx
  800320:	74 14                	je     800336 <_main+0x2fe>
  800322:	83 ec 04             	sub    $0x4,%esp
  800325:	68 e0 26 80 00       	push   $0x8026e0
  80032a:	6a 3a                	push   $0x3a
  80032c:	68 9c 26 80 00       	push   $0x80269c
  800331:	e8 de 03 00 00       	call   800714 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800336:	e8 5f 1c 00 00       	call   801f9a <sys_pf_calculate_allocated_pages>
  80033b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80033e:	83 f8 01             	cmp    $0x1,%eax
  800341:	74 14                	je     800357 <_main+0x31f>
  800343:	83 ec 04             	sub    $0x4,%esp
  800346:	68 4c 27 80 00       	push   $0x80274c
  80034b:	6a 3b                	push   $0x3b
  80034d:	68 9c 26 80 00       	push   $0x80269c
  800352:	e8 bd 03 00 00       	call   800714 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800357:	e8 bb 1b 00 00       	call   801f17 <sys_calculate_free_frames>
  80035c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035f:	e8 36 1c 00 00       	call   801f9a <sys_pf_calculate_allocated_pages>
  800364:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800367:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80036a:	89 d0                	mov    %edx,%eax
  80036c:	01 c0                	add    %eax,%eax
  80036e:	01 d0                	add    %edx,%eax
  800370:	01 c0                	add    %eax,%eax
  800372:	01 d0                	add    %edx,%eax
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	50                   	push   %eax
  800378:	e8 c3 13 00 00       	call   801740 <malloc>
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800383:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800386:	89 c2                	mov    %eax,%edx
  800388:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80038b:	c1 e0 02             	shl    $0x2,%eax
  80038e:	89 c1                	mov    %eax,%ecx
  800390:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800393:	c1 e0 03             	shl    $0x3,%eax
  800396:	01 c8                	add    %ecx,%eax
  800398:	05 00 00 00 80       	add    $0x80000000,%eax
  80039d:	39 c2                	cmp    %eax,%edx
  80039f:	72 1e                	jb     8003bf <_main+0x387>
  8003a1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003a4:	89 c2                	mov    %eax,%edx
  8003a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a9:	c1 e0 02             	shl    $0x2,%eax
  8003ac:	89 c1                	mov    %eax,%ecx
  8003ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b1:	c1 e0 03             	shl    $0x3,%eax
  8003b4:	01 c8                	add    %ecx,%eax
  8003b6:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8003bb:	39 c2                	cmp    %eax,%edx
  8003bd:	76 14                	jbe    8003d3 <_main+0x39b>
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	68 b0 26 80 00       	push   $0x8026b0
  8003c7:	6a 40                	push   $0x40
  8003c9:	68 9c 26 80 00       	push   $0x80269c
  8003ce:	e8 41 03 00 00       	call   800714 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003d3:	e8 3f 1b 00 00       	call   801f17 <sys_calculate_free_frames>
  8003d8:	89 c2                	mov    %eax,%edx
  8003da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003dd:	39 c2                	cmp    %eax,%edx
  8003df:	74 14                	je     8003f5 <_main+0x3bd>
  8003e1:	83 ec 04             	sub    $0x4,%esp
  8003e4:	68 e0 26 80 00       	push   $0x8026e0
  8003e9:	6a 42                	push   $0x42
  8003eb:	68 9c 26 80 00       	push   $0x80269c
  8003f0:	e8 1f 03 00 00       	call   800714 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  8003f5:	e8 a0 1b 00 00       	call   801f9a <sys_pf_calculate_allocated_pages>
  8003fa:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8003fd:	83 f8 02             	cmp    $0x2,%eax
  800400:	74 14                	je     800416 <_main+0x3de>
  800402:	83 ec 04             	sub    $0x4,%esp
  800405:	68 4c 27 80 00       	push   $0x80274c
  80040a:	6a 43                	push   $0x43
  80040c:	68 9c 26 80 00       	push   $0x80269c
  800411:	e8 fe 02 00 00       	call   800714 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800416:	e8 fc 1a 00 00       	call   801f17 <sys_calculate_free_frames>
  80041b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80041e:	e8 77 1b 00 00       	call   801f9a <sys_pf_calculate_allocated_pages>
  800423:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800429:	89 c2                	mov    %eax,%edx
  80042b:	01 d2                	add    %edx,%edx
  80042d:	01 d0                	add    %edx,%eax
  80042f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	50                   	push   %eax
  800436:	e8 05 13 00 00       	call   801740 <malloc>
  80043b:	83 c4 10             	add    $0x10,%esp
  80043e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800441:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800444:	89 c2                	mov    %eax,%edx
  800446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800449:	c1 e0 02             	shl    $0x2,%eax
  80044c:	89 c1                	mov    %eax,%ecx
  80044e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800451:	c1 e0 04             	shl    $0x4,%eax
  800454:	01 c8                	add    %ecx,%eax
  800456:	05 00 00 00 80       	add    $0x80000000,%eax
  80045b:	39 c2                	cmp    %eax,%edx
  80045d:	72 1e                	jb     80047d <_main+0x445>
  80045f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800462:	89 c2                	mov    %eax,%edx
  800464:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800467:	c1 e0 02             	shl    $0x2,%eax
  80046a:	89 c1                	mov    %eax,%ecx
  80046c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046f:	c1 e0 04             	shl    $0x4,%eax
  800472:	01 c8                	add    %ecx,%eax
  800474:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800479:	39 c2                	cmp    %eax,%edx
  80047b:	76 14                	jbe    800491 <_main+0x459>
  80047d:	83 ec 04             	sub    $0x4,%esp
  800480:	68 b0 26 80 00       	push   $0x8026b0
  800485:	6a 48                	push   $0x48
  800487:	68 9c 26 80 00       	push   $0x80269c
  80048c:	e8 83 02 00 00       	call   800714 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800491:	e8 81 1a 00 00       	call   801f17 <sys_calculate_free_frames>
  800496:	89 c2                	mov    %eax,%edx
  800498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80049b:	39 c2                	cmp    %eax,%edx
  80049d:	74 14                	je     8004b3 <_main+0x47b>
  80049f:	83 ec 04             	sub    $0x4,%esp
  8004a2:	68 7a 27 80 00       	push   $0x80277a
  8004a7:	6a 49                	push   $0x49
  8004a9:	68 9c 26 80 00       	push   $0x80269c
  8004ae:	e8 61 02 00 00       	call   800714 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  8004b3:	e8 e2 1a 00 00       	call   801f9a <sys_pf_calculate_allocated_pages>
  8004b8:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004bb:	89 c2                	mov    %eax,%edx
  8004bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c0:	89 c1                	mov    %eax,%ecx
  8004c2:	01 c9                	add    %ecx,%ecx
  8004c4:	01 c8                	add    %ecx,%eax
  8004c6:	85 c0                	test   %eax,%eax
  8004c8:	79 05                	jns    8004cf <_main+0x497>
  8004ca:	05 ff 0f 00 00       	add    $0xfff,%eax
  8004cf:	c1 f8 0c             	sar    $0xc,%eax
  8004d2:	39 c2                	cmp    %eax,%edx
  8004d4:	74 14                	je     8004ea <_main+0x4b2>
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	68 4c 27 80 00       	push   $0x80274c
  8004de:	6a 4a                	push   $0x4a
  8004e0:	68 9c 26 80 00       	push   $0x80269c
  8004e5:	e8 2a 02 00 00       	call   800714 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004ea:	e8 28 1a 00 00       	call   801f17 <sys_calculate_free_frames>
  8004ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004f2:	e8 a3 1a 00 00       	call   801f9a <sys_pf_calculate_allocated_pages>
  8004f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  8004fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004fd:	01 c0                	add    %eax,%eax
  8004ff:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	50                   	push   %eax
  800506:	e8 35 12 00 00       	call   801740 <malloc>
  80050b:	83 c4 10             	add    $0x10,%esp
  80050e:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800511:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800514:	89 c1                	mov    %eax,%ecx
  800516:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800519:	89 d0                	mov    %edx,%eax
  80051b:	01 c0                	add    %eax,%eax
  80051d:	01 d0                	add    %edx,%eax
  80051f:	01 c0                	add    %eax,%eax
  800521:	01 d0                	add    %edx,%eax
  800523:	89 c2                	mov    %eax,%edx
  800525:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800528:	c1 e0 04             	shl    $0x4,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	05 00 00 00 80       	add    $0x80000000,%eax
  800532:	39 c1                	cmp    %eax,%ecx
  800534:	72 25                	jb     80055b <_main+0x523>
  800536:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800539:	89 c1                	mov    %eax,%ecx
  80053b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	01 c0                	add    %eax,%eax
  800542:	01 d0                	add    %edx,%eax
  800544:	01 c0                	add    %eax,%eax
  800546:	01 d0                	add    %edx,%eax
  800548:	89 c2                	mov    %eax,%edx
  80054a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80054d:	c1 e0 04             	shl    $0x4,%eax
  800550:	01 d0                	add    %edx,%eax
  800552:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800557:	39 c1                	cmp    %eax,%ecx
  800559:	76 14                	jbe    80056f <_main+0x537>
  80055b:	83 ec 04             	sub    $0x4,%esp
  80055e:	68 b0 26 80 00       	push   $0x8026b0
  800563:	6a 4f                	push   $0x4f
  800565:	68 9c 26 80 00       	push   $0x80269c
  80056a:	e8 a5 01 00 00       	call   800714 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  80056f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800572:	e8 a0 19 00 00       	call   801f17 <sys_calculate_free_frames>
  800577:	29 c3                	sub    %eax,%ebx
  800579:	89 d8                	mov    %ebx,%eax
  80057b:	83 f8 01             	cmp    $0x1,%eax
  80057e:	74 14                	je     800594 <_main+0x55c>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 7a 27 80 00       	push   $0x80277a
  800588:	6a 50                	push   $0x50
  80058a:	68 9c 26 80 00       	push   $0x80269c
  80058f:	e8 80 01 00 00       	call   800714 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800594:	e8 01 1a 00 00       	call   801f9a <sys_pf_calculate_allocated_pages>
  800599:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80059c:	3d 00 02 00 00       	cmp    $0x200,%eax
  8005a1:	74 14                	je     8005b7 <_main+0x57f>
  8005a3:	83 ec 04             	sub    $0x4,%esp
  8005a6:	68 4c 27 80 00       	push   $0x80274c
  8005ab:	6a 51                	push   $0x51
  8005ad:	68 9c 26 80 00       	push   $0x80269c
  8005b2:	e8 5d 01 00 00       	call   800714 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  8005b7:	83 ec 0c             	sub    $0xc,%esp
  8005ba:	68 90 27 80 00       	push   $0x802790
  8005bf:	e8 f2 03 00 00       	call   8009b6 <cprintf>
  8005c4:	83 c4 10             	add    $0x10,%esp

	return;
  8005c7:	90                   	nop
}
  8005c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005cb:	5b                   	pop    %ebx
  8005cc:	5f                   	pop    %edi
  8005cd:	5d                   	pop    %ebp
  8005ce:	c3                   	ret    

008005cf <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005cf:	55                   	push   %ebp
  8005d0:	89 e5                	mov    %esp,%ebp
  8005d2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005d5:	e8 72 18 00 00       	call   801e4c <sys_getenvindex>
  8005da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005e0:	89 d0                	mov    %edx,%eax
  8005e2:	c1 e0 03             	shl    $0x3,%eax
  8005e5:	01 d0                	add    %edx,%eax
  8005e7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8005ee:	01 c8                	add    %ecx,%eax
  8005f0:	01 c0                	add    %eax,%eax
  8005f2:	01 d0                	add    %edx,%eax
  8005f4:	01 c0                	add    %eax,%eax
  8005f6:	01 d0                	add    %edx,%eax
  8005f8:	89 c2                	mov    %eax,%edx
  8005fa:	c1 e2 05             	shl    $0x5,%edx
  8005fd:	29 c2                	sub    %eax,%edx
  8005ff:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800606:	89 c2                	mov    %eax,%edx
  800608:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80060e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800613:	a1 20 30 80 00       	mov    0x803020,%eax
  800618:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80061e:	84 c0                	test   %al,%al
  800620:	74 0f                	je     800631 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800622:	a1 20 30 80 00       	mov    0x803020,%eax
  800627:	05 40 3c 01 00       	add    $0x13c40,%eax
  80062c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800631:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800635:	7e 0a                	jle    800641 <libmain+0x72>
		binaryname = argv[0];
  800637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	ff 75 0c             	pushl  0xc(%ebp)
  800647:	ff 75 08             	pushl  0x8(%ebp)
  80064a:	e8 e9 f9 ff ff       	call   800038 <_main>
  80064f:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800652:	e8 90 19 00 00       	call   801fe7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800657:	83 ec 0c             	sub    $0xc,%esp
  80065a:	68 e4 27 80 00       	push   $0x8027e4
  80065f:	e8 52 03 00 00       	call   8009b6 <cprintf>
  800664:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800667:	a1 20 30 80 00       	mov    0x803020,%eax
  80066c:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800672:	a1 20 30 80 00       	mov    0x803020,%eax
  800677:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	52                   	push   %edx
  800681:	50                   	push   %eax
  800682:	68 0c 28 80 00       	push   $0x80280c
  800687:	e8 2a 03 00 00       	call   8009b6 <cprintf>
  80068c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80068f:	a1 20 30 80 00       	mov    0x803020,%eax
  800694:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80069a:	a1 20 30 80 00       	mov    0x803020,%eax
  80069f:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8006a5:	83 ec 04             	sub    $0x4,%esp
  8006a8:	52                   	push   %edx
  8006a9:	50                   	push   %eax
  8006aa:	68 34 28 80 00       	push   $0x802834
  8006af:	e8 02 03 00 00       	call   8009b6 <cprintf>
  8006b4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8006bc:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	50                   	push   %eax
  8006c6:	68 75 28 80 00       	push   $0x802875
  8006cb:	e8 e6 02 00 00       	call   8009b6 <cprintf>
  8006d0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006d3:	83 ec 0c             	sub    $0xc,%esp
  8006d6:	68 e4 27 80 00       	push   $0x8027e4
  8006db:	e8 d6 02 00 00       	call   8009b6 <cprintf>
  8006e0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006e3:	e8 19 19 00 00       	call   802001 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006e8:	e8 19 00 00 00       	call   800706 <exit>
}
  8006ed:	90                   	nop
  8006ee:	c9                   	leave  
  8006ef:	c3                   	ret    

008006f0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	6a 00                	push   $0x0
  8006fb:	e8 18 17 00 00       	call   801e18 <sys_env_destroy>
  800700:	83 c4 10             	add    $0x10,%esp
}
  800703:	90                   	nop
  800704:	c9                   	leave  
  800705:	c3                   	ret    

00800706 <exit>:

void
exit(void)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80070c:	e8 6d 17 00 00       	call   801e7e <sys_env_exit>
}
  800711:	90                   	nop
  800712:	c9                   	leave  
  800713:	c3                   	ret    

00800714 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80071a:	8d 45 10             	lea    0x10(%ebp),%eax
  80071d:	83 c0 04             	add    $0x4,%eax
  800720:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800723:	a1 18 31 80 00       	mov    0x803118,%eax
  800728:	85 c0                	test   %eax,%eax
  80072a:	74 16                	je     800742 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80072c:	a1 18 31 80 00       	mov    0x803118,%eax
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	50                   	push   %eax
  800735:	68 8c 28 80 00       	push   $0x80288c
  80073a:	e8 77 02 00 00       	call   8009b6 <cprintf>
  80073f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800742:	a1 00 30 80 00       	mov    0x803000,%eax
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 08             	pushl  0x8(%ebp)
  80074d:	50                   	push   %eax
  80074e:	68 91 28 80 00       	push   $0x802891
  800753:	e8 5e 02 00 00       	call   8009b6 <cprintf>
  800758:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80075b:	8b 45 10             	mov    0x10(%ebp),%eax
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	ff 75 f4             	pushl  -0xc(%ebp)
  800764:	50                   	push   %eax
  800765:	e8 e1 01 00 00       	call   80094b <vcprintf>
  80076a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	6a 00                	push   $0x0
  800772:	68 ad 28 80 00       	push   $0x8028ad
  800777:	e8 cf 01 00 00       	call   80094b <vcprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80077f:	e8 82 ff ff ff       	call   800706 <exit>

	// should not return here
	while (1) ;
  800784:	eb fe                	jmp    800784 <_panic+0x70>

00800786 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80078c:	a1 20 30 80 00       	mov    0x803020,%eax
  800791:	8b 50 74             	mov    0x74(%eax),%edx
  800794:	8b 45 0c             	mov    0xc(%ebp),%eax
  800797:	39 c2                	cmp    %eax,%edx
  800799:	74 14                	je     8007af <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80079b:	83 ec 04             	sub    $0x4,%esp
  80079e:	68 b0 28 80 00       	push   $0x8028b0
  8007a3:	6a 26                	push   $0x26
  8007a5:	68 fc 28 80 00       	push   $0x8028fc
  8007aa:	e8 65 ff ff ff       	call   800714 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007bd:	e9 b6 00 00 00       	jmp    800878 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8007c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	01 d0                	add    %edx,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	85 c0                	test   %eax,%eax
  8007d5:	75 08                	jne    8007df <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007d7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007da:	e9 96 00 00 00       	jmp    800875 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8007df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007e6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ed:	eb 5d                	jmp    80084c <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8007f4:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8007fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007fd:	c1 e2 04             	shl    $0x4,%edx
  800800:	01 d0                	add    %edx,%eax
  800802:	8a 40 04             	mov    0x4(%eax),%al
  800805:	84 c0                	test   %al,%al
  800807:	75 40                	jne    800849 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800809:	a1 20 30 80 00       	mov    0x803020,%eax
  80080e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800814:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800817:	c1 e2 04             	shl    $0x4,%edx
  80081a:	01 d0                	add    %edx,%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800821:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800824:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800829:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80082b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	01 c8                	add    %ecx,%eax
  80083a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80083c:	39 c2                	cmp    %eax,%edx
  80083e:	75 09                	jne    800849 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800840:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800847:	eb 12                	jmp    80085b <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800849:	ff 45 e8             	incl   -0x18(%ebp)
  80084c:	a1 20 30 80 00       	mov    0x803020,%eax
  800851:	8b 50 74             	mov    0x74(%eax),%edx
  800854:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800857:	39 c2                	cmp    %eax,%edx
  800859:	77 94                	ja     8007ef <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80085b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80085f:	75 14                	jne    800875 <CheckWSWithoutLastIndex+0xef>
			panic(
  800861:	83 ec 04             	sub    $0x4,%esp
  800864:	68 08 29 80 00       	push   $0x802908
  800869:	6a 3a                	push   $0x3a
  80086b:	68 fc 28 80 00       	push   $0x8028fc
  800870:	e8 9f fe ff ff       	call   800714 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800875:	ff 45 f0             	incl   -0x10(%ebp)
  800878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80087e:	0f 8c 3e ff ff ff    	jl     8007c2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800884:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800892:	eb 20                	jmp    8008b4 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800894:	a1 20 30 80 00       	mov    0x803020,%eax
  800899:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80089f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a2:	c1 e2 04             	shl    $0x4,%edx
  8008a5:	01 d0                	add    %edx,%eax
  8008a7:	8a 40 04             	mov    0x4(%eax),%al
  8008aa:	3c 01                	cmp    $0x1,%al
  8008ac:	75 03                	jne    8008b1 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8008ae:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008b1:	ff 45 e0             	incl   -0x20(%ebp)
  8008b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8008b9:	8b 50 74             	mov    0x74(%eax),%edx
  8008bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008bf:	39 c2                	cmp    %eax,%edx
  8008c1:	77 d1                	ja     800894 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008c9:	74 14                	je     8008df <CheckWSWithoutLastIndex+0x159>
		panic(
  8008cb:	83 ec 04             	sub    $0x4,%esp
  8008ce:	68 5c 29 80 00       	push   $0x80295c
  8008d3:	6a 44                	push   $0x44
  8008d5:	68 fc 28 80 00       	push   $0x8028fc
  8008da:	e8 35 fe ff ff       	call   800714 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008df:	90                   	nop
  8008e0:	c9                   	leave  
  8008e1:	c3                   	ret    

008008e2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008eb:	8b 00                	mov    (%eax),%eax
  8008ed:	8d 48 01             	lea    0x1(%eax),%ecx
  8008f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f3:	89 0a                	mov    %ecx,(%edx)
  8008f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f8:	88 d1                	mov    %dl,%cl
  8008fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800901:	8b 45 0c             	mov    0xc(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	3d ff 00 00 00       	cmp    $0xff,%eax
  80090b:	75 2c                	jne    800939 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80090d:	a0 24 30 80 00       	mov    0x803024,%al
  800912:	0f b6 c0             	movzbl %al,%eax
  800915:	8b 55 0c             	mov    0xc(%ebp),%edx
  800918:	8b 12                	mov    (%edx),%edx
  80091a:	89 d1                	mov    %edx,%ecx
  80091c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091f:	83 c2 08             	add    $0x8,%edx
  800922:	83 ec 04             	sub    $0x4,%esp
  800925:	50                   	push   %eax
  800926:	51                   	push   %ecx
  800927:	52                   	push   %edx
  800928:	e8 a9 14 00 00       	call   801dd6 <sys_cputs>
  80092d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800930:	8b 45 0c             	mov    0xc(%ebp),%eax
  800933:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093c:	8b 40 04             	mov    0x4(%eax),%eax
  80093f:	8d 50 01             	lea    0x1(%eax),%edx
  800942:	8b 45 0c             	mov    0xc(%ebp),%eax
  800945:	89 50 04             	mov    %edx,0x4(%eax)
}
  800948:	90                   	nop
  800949:	c9                   	leave  
  80094a:	c3                   	ret    

0080094b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800954:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80095b:	00 00 00 
	b.cnt = 0;
  80095e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800965:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800968:	ff 75 0c             	pushl  0xc(%ebp)
  80096b:	ff 75 08             	pushl  0x8(%ebp)
  80096e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800974:	50                   	push   %eax
  800975:	68 e2 08 80 00       	push   $0x8008e2
  80097a:	e8 11 02 00 00       	call   800b90 <vprintfmt>
  80097f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800982:	a0 24 30 80 00       	mov    0x803024,%al
  800987:	0f b6 c0             	movzbl %al,%eax
  80098a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800990:	83 ec 04             	sub    $0x4,%esp
  800993:	50                   	push   %eax
  800994:	52                   	push   %edx
  800995:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80099b:	83 c0 08             	add    $0x8,%eax
  80099e:	50                   	push   %eax
  80099f:	e8 32 14 00 00       	call   801dd6 <sys_cputs>
  8009a4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009a7:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8009ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009b4:	c9                   	leave  
  8009b5:	c3                   	ret    

008009b6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009bc:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009c3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	83 ec 08             	sub    $0x8,%esp
  8009cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d2:	50                   	push   %eax
  8009d3:	e8 73 ff ff ff       	call   80094b <vcprintf>
  8009d8:	83 c4 10             	add    $0x10,%esp
  8009db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009e1:	c9                   	leave  
  8009e2:	c3                   	ret    

008009e3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009e9:	e8 f9 15 00 00       	call   801fe7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009ee:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	83 ec 08             	sub    $0x8,%esp
  8009fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8009fd:	50                   	push   %eax
  8009fe:	e8 48 ff ff ff       	call   80094b <vcprintf>
  800a03:	83 c4 10             	add    $0x10,%esp
  800a06:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a09:	e8 f3 15 00 00       	call   802001 <sys_enable_interrupt>
	return cnt;
  800a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a11:	c9                   	leave  
  800a12:	c3                   	ret    

00800a13 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	53                   	push   %ebx
  800a17:	83 ec 14             	sub    $0x14,%esp
  800a1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a20:	8b 45 14             	mov    0x14(%ebp),%eax
  800a23:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a26:	8b 45 18             	mov    0x18(%ebp),%eax
  800a29:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a31:	77 55                	ja     800a88 <printnum+0x75>
  800a33:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a36:	72 05                	jb     800a3d <printnum+0x2a>
  800a38:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a3b:	77 4b                	ja     800a88 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a3d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a40:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a43:	8b 45 18             	mov    0x18(%ebp),%eax
  800a46:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4b:	52                   	push   %edx
  800a4c:	50                   	push   %eax
  800a4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a50:	ff 75 f0             	pushl  -0x10(%ebp)
  800a53:	e8 b0 19 00 00       	call   802408 <__udivdi3>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	83 ec 04             	sub    $0x4,%esp
  800a5e:	ff 75 20             	pushl  0x20(%ebp)
  800a61:	53                   	push   %ebx
  800a62:	ff 75 18             	pushl  0x18(%ebp)
  800a65:	52                   	push   %edx
  800a66:	50                   	push   %eax
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	ff 75 08             	pushl  0x8(%ebp)
  800a6d:	e8 a1 ff ff ff       	call   800a13 <printnum>
  800a72:	83 c4 20             	add    $0x20,%esp
  800a75:	eb 1a                	jmp    800a91 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	ff 75 20             	pushl  0x20(%ebp)
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	ff d0                	call   *%eax
  800a85:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a88:	ff 4d 1c             	decl   0x1c(%ebp)
  800a8b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a8f:	7f e6                	jg     800a77 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a91:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9f:	53                   	push   %ebx
  800aa0:	51                   	push   %ecx
  800aa1:	52                   	push   %edx
  800aa2:	50                   	push   %eax
  800aa3:	e8 70 1a 00 00       	call   802518 <__umoddi3>
  800aa8:	83 c4 10             	add    $0x10,%esp
  800aab:	05 d4 2b 80 00       	add    $0x802bd4,%eax
  800ab0:	8a 00                	mov    (%eax),%al
  800ab2:	0f be c0             	movsbl %al,%eax
  800ab5:	83 ec 08             	sub    $0x8,%esp
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	50                   	push   %eax
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
}
  800ac4:	90                   	nop
  800ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ac8:	c9                   	leave  
  800ac9:	c3                   	ret    

00800aca <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800acd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ad1:	7e 1c                	jle    800aef <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	8b 00                	mov    (%eax),%eax
  800ad8:	8d 50 08             	lea    0x8(%eax),%edx
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	89 10                	mov    %edx,(%eax)
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	83 e8 08             	sub    $0x8,%eax
  800ae8:	8b 50 04             	mov    0x4(%eax),%edx
  800aeb:	8b 00                	mov    (%eax),%eax
  800aed:	eb 40                	jmp    800b2f <getuint+0x65>
	else if (lflag)
  800aef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af3:	74 1e                	je     800b13 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	8b 00                	mov    (%eax),%eax
  800afa:	8d 50 04             	lea    0x4(%eax),%edx
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	89 10                	mov    %edx,(%eax)
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	8b 00                	mov    (%eax),%eax
  800b07:	83 e8 04             	sub    $0x4,%eax
  800b0a:	8b 00                	mov    (%eax),%eax
  800b0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b11:	eb 1c                	jmp    800b2f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	8b 00                	mov    (%eax),%eax
  800b18:	8d 50 04             	lea    0x4(%eax),%edx
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	89 10                	mov    %edx,(%eax)
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	8b 00                	mov    (%eax),%eax
  800b25:	83 e8 04             	sub    $0x4,%eax
  800b28:	8b 00                	mov    (%eax),%eax
  800b2a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    

00800b31 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b34:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b38:	7e 1c                	jle    800b56 <getint+0x25>
		return va_arg(*ap, long long);
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	8b 00                	mov    (%eax),%eax
  800b3f:	8d 50 08             	lea    0x8(%eax),%edx
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	89 10                	mov    %edx,(%eax)
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	8b 00                	mov    (%eax),%eax
  800b4c:	83 e8 08             	sub    $0x8,%eax
  800b4f:	8b 50 04             	mov    0x4(%eax),%edx
  800b52:	8b 00                	mov    (%eax),%eax
  800b54:	eb 38                	jmp    800b8e <getint+0x5d>
	else if (lflag)
  800b56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5a:	74 1a                	je     800b76 <getint+0x45>
		return va_arg(*ap, long);
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	8d 50 04             	lea    0x4(%eax),%edx
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	89 10                	mov    %edx,(%eax)
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 00                	mov    (%eax),%eax
  800b6e:	83 e8 04             	sub    $0x4,%eax
  800b71:	8b 00                	mov    (%eax),%eax
  800b73:	99                   	cltd   
  800b74:	eb 18                	jmp    800b8e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 00                	mov    (%eax),%eax
  800b7b:	8d 50 04             	lea    0x4(%eax),%edx
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	89 10                	mov    %edx,(%eax)
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8b 00                	mov    (%eax),%eax
  800b88:	83 e8 04             	sub    $0x4,%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	99                   	cltd   
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
  800b95:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b98:	eb 17                	jmp    800bb1 <vprintfmt+0x21>
			if (ch == '\0')
  800b9a:	85 db                	test   %ebx,%ebx
  800b9c:	0f 84 af 03 00 00    	je     800f51 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ba2:	83 ec 08             	sub    $0x8,%esp
  800ba5:	ff 75 0c             	pushl  0xc(%ebp)
  800ba8:	53                   	push   %ebx
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	ff d0                	call   *%eax
  800bae:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb4:	8d 50 01             	lea    0x1(%eax),%edx
  800bb7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	0f b6 d8             	movzbl %al,%ebx
  800bbf:	83 fb 25             	cmp    $0x25,%ebx
  800bc2:	75 d6                	jne    800b9a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bc4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bc8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bcf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bd6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bdd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800be4:	8b 45 10             	mov    0x10(%ebp),%eax
  800be7:	8d 50 01             	lea    0x1(%eax),%edx
  800bea:	89 55 10             	mov    %edx,0x10(%ebp)
  800bed:	8a 00                	mov    (%eax),%al
  800bef:	0f b6 d8             	movzbl %al,%ebx
  800bf2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bf5:	83 f8 55             	cmp    $0x55,%eax
  800bf8:	0f 87 2b 03 00 00    	ja     800f29 <vprintfmt+0x399>
  800bfe:	8b 04 85 f8 2b 80 00 	mov    0x802bf8(,%eax,4),%eax
  800c05:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c07:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c0b:	eb d7                	jmp    800be4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c0d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c11:	eb d1                	jmp    800be4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c13:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c1d:	89 d0                	mov    %edx,%eax
  800c1f:	c1 e0 02             	shl    $0x2,%eax
  800c22:	01 d0                	add    %edx,%eax
  800c24:	01 c0                	add    %eax,%eax
  800c26:	01 d8                	add    %ebx,%eax
  800c28:	83 e8 30             	sub    $0x30,%eax
  800c2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	8a 00                	mov    (%eax),%al
  800c33:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c36:	83 fb 2f             	cmp    $0x2f,%ebx
  800c39:	7e 3e                	jle    800c79 <vprintfmt+0xe9>
  800c3b:	83 fb 39             	cmp    $0x39,%ebx
  800c3e:	7f 39                	jg     800c79 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c40:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c43:	eb d5                	jmp    800c1a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c45:	8b 45 14             	mov    0x14(%ebp),%eax
  800c48:	83 c0 04             	add    $0x4,%eax
  800c4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c51:	83 e8 04             	sub    $0x4,%eax
  800c54:	8b 00                	mov    (%eax),%eax
  800c56:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c59:	eb 1f                	jmp    800c7a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5f:	79 83                	jns    800be4 <vprintfmt+0x54>
				width = 0;
  800c61:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c68:	e9 77 ff ff ff       	jmp    800be4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c6d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c74:	e9 6b ff ff ff       	jmp    800be4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c79:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7e:	0f 89 60 ff ff ff    	jns    800be4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c8a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c91:	e9 4e ff ff ff       	jmp    800be4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c96:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c99:	e9 46 ff ff ff       	jmp    800be4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca1:	83 c0 04             	add    $0x4,%eax
  800ca4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  800caa:	83 e8 04             	sub    $0x4,%eax
  800cad:	8b 00                	mov    (%eax),%eax
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	50                   	push   %eax
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			break;
  800cbe:	e9 89 02 00 00       	jmp    800f4c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 c0 04             	add    $0x4,%eax
  800cc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccf:	83 e8 04             	sub    $0x4,%eax
  800cd2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cd4:	85 db                	test   %ebx,%ebx
  800cd6:	79 02                	jns    800cda <vprintfmt+0x14a>
				err = -err;
  800cd8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cda:	83 fb 64             	cmp    $0x64,%ebx
  800cdd:	7f 0b                	jg     800cea <vprintfmt+0x15a>
  800cdf:	8b 34 9d 40 2a 80 00 	mov    0x802a40(,%ebx,4),%esi
  800ce6:	85 f6                	test   %esi,%esi
  800ce8:	75 19                	jne    800d03 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cea:	53                   	push   %ebx
  800ceb:	68 e5 2b 80 00       	push   $0x802be5
  800cf0:	ff 75 0c             	pushl  0xc(%ebp)
  800cf3:	ff 75 08             	pushl  0x8(%ebp)
  800cf6:	e8 5e 02 00 00       	call   800f59 <printfmt>
  800cfb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cfe:	e9 49 02 00 00       	jmp    800f4c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d03:	56                   	push   %esi
  800d04:	68 ee 2b 80 00       	push   $0x802bee
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	ff 75 08             	pushl  0x8(%ebp)
  800d0f:	e8 45 02 00 00       	call   800f59 <printfmt>
  800d14:	83 c4 10             	add    $0x10,%esp
			break;
  800d17:	e9 30 02 00 00       	jmp    800f4c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1f:	83 c0 04             	add    $0x4,%eax
  800d22:	89 45 14             	mov    %eax,0x14(%ebp)
  800d25:	8b 45 14             	mov    0x14(%ebp),%eax
  800d28:	83 e8 04             	sub    $0x4,%eax
  800d2b:	8b 30                	mov    (%eax),%esi
  800d2d:	85 f6                	test   %esi,%esi
  800d2f:	75 05                	jne    800d36 <vprintfmt+0x1a6>
				p = "(null)";
  800d31:	be f1 2b 80 00       	mov    $0x802bf1,%esi
			if (width > 0 && padc != '-')
  800d36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3a:	7e 6d                	jle    800da9 <vprintfmt+0x219>
  800d3c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d40:	74 67                	je     800da9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	50                   	push   %eax
  800d49:	56                   	push   %esi
  800d4a:	e8 0c 03 00 00       	call   80105b <strnlen>
  800d4f:	83 c4 10             	add    $0x10,%esp
  800d52:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d55:	eb 16                	jmp    800d6d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d57:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d5b:	83 ec 08             	sub    $0x8,%esp
  800d5e:	ff 75 0c             	pushl  0xc(%ebp)
  800d61:	50                   	push   %eax
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	ff d0                	call   *%eax
  800d67:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d6a:	ff 4d e4             	decl   -0x1c(%ebp)
  800d6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d71:	7f e4                	jg     800d57 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d73:	eb 34                	jmp    800da9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d75:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d79:	74 1c                	je     800d97 <vprintfmt+0x207>
  800d7b:	83 fb 1f             	cmp    $0x1f,%ebx
  800d7e:	7e 05                	jle    800d85 <vprintfmt+0x1f5>
  800d80:	83 fb 7e             	cmp    $0x7e,%ebx
  800d83:	7e 12                	jle    800d97 <vprintfmt+0x207>
					putch('?', putdat);
  800d85:	83 ec 08             	sub    $0x8,%esp
  800d88:	ff 75 0c             	pushl  0xc(%ebp)
  800d8b:	6a 3f                	push   $0x3f
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	ff d0                	call   *%eax
  800d92:	83 c4 10             	add    $0x10,%esp
  800d95:	eb 0f                	jmp    800da6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	53                   	push   %ebx
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	ff d0                	call   *%eax
  800da3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800da6:	ff 4d e4             	decl   -0x1c(%ebp)
  800da9:	89 f0                	mov    %esi,%eax
  800dab:	8d 70 01             	lea    0x1(%eax),%esi
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	0f be d8             	movsbl %al,%ebx
  800db3:	85 db                	test   %ebx,%ebx
  800db5:	74 24                	je     800ddb <vprintfmt+0x24b>
  800db7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dbb:	78 b8                	js     800d75 <vprintfmt+0x1e5>
  800dbd:	ff 4d e0             	decl   -0x20(%ebp)
  800dc0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dc4:	79 af                	jns    800d75 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dc6:	eb 13                	jmp    800ddb <vprintfmt+0x24b>
				putch(' ', putdat);
  800dc8:	83 ec 08             	sub    $0x8,%esp
  800dcb:	ff 75 0c             	pushl  0xc(%ebp)
  800dce:	6a 20                	push   $0x20
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	ff d0                	call   *%eax
  800dd5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dd8:	ff 4d e4             	decl   -0x1c(%ebp)
  800ddb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ddf:	7f e7                	jg     800dc8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800de1:	e9 66 01 00 00       	jmp    800f4c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800de6:	83 ec 08             	sub    $0x8,%esp
  800de9:	ff 75 e8             	pushl  -0x18(%ebp)
  800dec:	8d 45 14             	lea    0x14(%ebp),%eax
  800def:	50                   	push   %eax
  800df0:	e8 3c fd ff ff       	call   800b31 <getint>
  800df5:	83 c4 10             	add    $0x10,%esp
  800df8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e04:	85 d2                	test   %edx,%edx
  800e06:	79 23                	jns    800e2b <vprintfmt+0x29b>
				putch('-', putdat);
  800e08:	83 ec 08             	sub    $0x8,%esp
  800e0b:	ff 75 0c             	pushl  0xc(%ebp)
  800e0e:	6a 2d                	push   $0x2d
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	ff d0                	call   *%eax
  800e15:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1e:	f7 d8                	neg    %eax
  800e20:	83 d2 00             	adc    $0x0,%edx
  800e23:	f7 da                	neg    %edx
  800e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e28:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e2b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e32:	e9 bc 00 00 00       	jmp    800ef3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e37:	83 ec 08             	sub    $0x8,%esp
  800e3a:	ff 75 e8             	pushl  -0x18(%ebp)
  800e3d:	8d 45 14             	lea    0x14(%ebp),%eax
  800e40:	50                   	push   %eax
  800e41:	e8 84 fc ff ff       	call   800aca <getuint>
  800e46:	83 c4 10             	add    $0x10,%esp
  800e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e56:	e9 98 00 00 00       	jmp    800ef3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	ff 75 0c             	pushl  0xc(%ebp)
  800e61:	6a 58                	push   $0x58
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	ff d0                	call   *%eax
  800e68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e6b:	83 ec 08             	sub    $0x8,%esp
  800e6e:	ff 75 0c             	pushl  0xc(%ebp)
  800e71:	6a 58                	push   $0x58
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	ff d0                	call   *%eax
  800e78:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e7b:	83 ec 08             	sub    $0x8,%esp
  800e7e:	ff 75 0c             	pushl  0xc(%ebp)
  800e81:	6a 58                	push   $0x58
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	ff d0                	call   *%eax
  800e88:	83 c4 10             	add    $0x10,%esp
			break;
  800e8b:	e9 bc 00 00 00       	jmp    800f4c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e90:	83 ec 08             	sub    $0x8,%esp
  800e93:	ff 75 0c             	pushl  0xc(%ebp)
  800e96:	6a 30                	push   $0x30
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	ff d0                	call   *%eax
  800e9d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 0c             	pushl  0xc(%ebp)
  800ea6:	6a 78                	push   $0x78
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	ff d0                	call   *%eax
  800ead:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800eb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb3:	83 c0 04             	add    $0x4,%eax
  800eb6:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebc:	83 e8 04             	sub    $0x4,%eax
  800ebf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ec1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ecb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ed2:	eb 1f                	jmp    800ef3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ed4:	83 ec 08             	sub    $0x8,%esp
  800ed7:	ff 75 e8             	pushl  -0x18(%ebp)
  800eda:	8d 45 14             	lea    0x14(%ebp),%eax
  800edd:	50                   	push   %eax
  800ede:	e8 e7 fb ff ff       	call   800aca <getuint>
  800ee3:	83 c4 10             	add    $0x10,%esp
  800ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eec:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ef3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ef7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800efa:	83 ec 04             	sub    $0x4,%esp
  800efd:	52                   	push   %edx
  800efe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f01:	50                   	push   %eax
  800f02:	ff 75 f4             	pushl  -0xc(%ebp)
  800f05:	ff 75 f0             	pushl  -0x10(%ebp)
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	ff 75 08             	pushl  0x8(%ebp)
  800f0e:	e8 00 fb ff ff       	call   800a13 <printnum>
  800f13:	83 c4 20             	add    $0x20,%esp
			break;
  800f16:	eb 34                	jmp    800f4c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f18:	83 ec 08             	sub    $0x8,%esp
  800f1b:	ff 75 0c             	pushl  0xc(%ebp)
  800f1e:	53                   	push   %ebx
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	ff d0                	call   *%eax
  800f24:	83 c4 10             	add    $0x10,%esp
			break;
  800f27:	eb 23                	jmp    800f4c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f29:	83 ec 08             	sub    $0x8,%esp
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	6a 25                	push   $0x25
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	ff d0                	call   *%eax
  800f36:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f39:	ff 4d 10             	decl   0x10(%ebp)
  800f3c:	eb 03                	jmp    800f41 <vprintfmt+0x3b1>
  800f3e:	ff 4d 10             	decl   0x10(%ebp)
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	48                   	dec    %eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	3c 25                	cmp    $0x25,%al
  800f49:	75 f3                	jne    800f3e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f4b:	90                   	nop
		}
	}
  800f4c:	e9 47 fc ff ff       	jmp    800b98 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f51:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f55:	5b                   	pop    %ebx
  800f56:	5e                   	pop    %esi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f5f:	8d 45 10             	lea    0x10(%ebp),%eax
  800f62:	83 c0 04             	add    $0x4,%eax
  800f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f68:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f6e:	50                   	push   %eax
  800f6f:	ff 75 0c             	pushl  0xc(%ebp)
  800f72:	ff 75 08             	pushl  0x8(%ebp)
  800f75:	e8 16 fc ff ff       	call   800b90 <vprintfmt>
  800f7a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f7d:	90                   	nop
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f86:	8b 40 08             	mov    0x8(%eax),%eax
  800f89:	8d 50 01             	lea    0x1(%eax),%edx
  800f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	8b 10                	mov    (%eax),%edx
  800f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9a:	8b 40 04             	mov    0x4(%eax),%eax
  800f9d:	39 c2                	cmp    %eax,%edx
  800f9f:	73 12                	jae    800fb3 <sprintputch+0x33>
		*b->buf++ = ch;
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	8b 00                	mov    (%eax),%eax
  800fa6:	8d 48 01             	lea    0x1(%eax),%ecx
  800fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fac:	89 0a                	mov    %ecx,(%edx)
  800fae:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb1:	88 10                	mov    %dl,(%eax)
}
  800fb3:	90                   	nop
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	01 d0                	add    %edx,%eax
  800fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fdb:	74 06                	je     800fe3 <vsnprintf+0x2d>
  800fdd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fe1:	7f 07                	jg     800fea <vsnprintf+0x34>
		return -E_INVAL;
  800fe3:	b8 03 00 00 00       	mov    $0x3,%eax
  800fe8:	eb 20                	jmp    80100a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fea:	ff 75 14             	pushl  0x14(%ebp)
  800fed:	ff 75 10             	pushl  0x10(%ebp)
  800ff0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ff3:	50                   	push   %eax
  800ff4:	68 80 0f 80 00       	push   $0x800f80
  800ff9:	e8 92 fb ff ff       	call   800b90 <vprintfmt>
  800ffe:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801004:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801007:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801012:	8d 45 10             	lea    0x10(%ebp),%eax
  801015:	83 c0 04             	add    $0x4,%eax
  801018:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80101b:	8b 45 10             	mov    0x10(%ebp),%eax
  80101e:	ff 75 f4             	pushl  -0xc(%ebp)
  801021:	50                   	push   %eax
  801022:	ff 75 0c             	pushl  0xc(%ebp)
  801025:	ff 75 08             	pushl  0x8(%ebp)
  801028:	e8 89 ff ff ff       	call   800fb6 <vsnprintf>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801033:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801036:	c9                   	leave  
  801037:	c3                   	ret    

00801038 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80103e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801045:	eb 06                	jmp    80104d <strlen+0x15>
		n++;
  801047:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80104a:	ff 45 08             	incl   0x8(%ebp)
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	84 c0                	test   %al,%al
  801054:	75 f1                	jne    801047 <strlen+0xf>
		n++;
	return n;
  801056:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801068:	eb 09                	jmp    801073 <strnlen+0x18>
		n++;
  80106a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106d:	ff 45 08             	incl   0x8(%ebp)
  801070:	ff 4d 0c             	decl   0xc(%ebp)
  801073:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801077:	74 09                	je     801082 <strnlen+0x27>
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	84 c0                	test   %al,%al
  801080:	75 e8                	jne    80106a <strnlen+0xf>
		n++;
	return n;
  801082:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801085:	c9                   	leave  
  801086:	c3                   	ret    

00801087 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801093:	90                   	nop
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	8d 50 01             	lea    0x1(%eax),%edx
  80109a:	89 55 08             	mov    %edx,0x8(%ebp)
  80109d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010a6:	8a 12                	mov    (%edx),%dl
  8010a8:	88 10                	mov    %dl,(%eax)
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	84 c0                	test   %al,%al
  8010ae:	75 e4                	jne    801094 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b3:	c9                   	leave  
  8010b4:	c3                   	ret    

008010b5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010c8:	eb 1f                	jmp    8010e9 <strncpy+0x34>
		*dst++ = *src;
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8d 50 01             	lea    0x1(%eax),%edx
  8010d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8010d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d6:	8a 12                	mov    (%edx),%dl
  8010d8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	84 c0                	test   %al,%al
  8010e1:	74 03                	je     8010e6 <strncpy+0x31>
			src++;
  8010e3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010e6:	ff 45 fc             	incl   -0x4(%ebp)
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ef:	72 d9                	jb     8010ca <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

008010f6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	74 30                	je     801138 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801108:	eb 16                	jmp    801120 <strlcpy+0x2a>
			*dst++ = *src++;
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8d 50 01             	lea    0x1(%eax),%edx
  801110:	89 55 08             	mov    %edx,0x8(%ebp)
  801113:	8b 55 0c             	mov    0xc(%ebp),%edx
  801116:	8d 4a 01             	lea    0x1(%edx),%ecx
  801119:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80111c:	8a 12                	mov    (%edx),%dl
  80111e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801120:	ff 4d 10             	decl   0x10(%ebp)
  801123:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801127:	74 09                	je     801132 <strlcpy+0x3c>
  801129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	84 c0                	test   %al,%al
  801130:	75 d8                	jne    80110a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801138:	8b 55 08             	mov    0x8(%ebp),%edx
  80113b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113e:	29 c2                	sub    %eax,%edx
  801140:	89 d0                	mov    %edx,%eax
}
  801142:	c9                   	leave  
  801143:	c3                   	ret    

00801144 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801147:	eb 06                	jmp    80114f <strcmp+0xb>
		p++, q++;
  801149:	ff 45 08             	incl   0x8(%ebp)
  80114c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	84 c0                	test   %al,%al
  801156:	74 0e                	je     801166 <strcmp+0x22>
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 10                	mov    (%eax),%dl
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	38 c2                	cmp    %al,%dl
  801164:	74 e3                	je     801149 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	0f b6 d0             	movzbl %al,%edx
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	0f b6 c0             	movzbl %al,%eax
  801176:	29 c2                	sub    %eax,%edx
  801178:	89 d0                	mov    %edx,%eax
}
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    

0080117c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80117f:	eb 09                	jmp    80118a <strncmp+0xe>
		n--, p++, q++;
  801181:	ff 4d 10             	decl   0x10(%ebp)
  801184:	ff 45 08             	incl   0x8(%ebp)
  801187:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80118a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118e:	74 17                	je     8011a7 <strncmp+0x2b>
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	84 c0                	test   %al,%al
  801197:	74 0e                	je     8011a7 <strncmp+0x2b>
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	8a 10                	mov    (%eax),%dl
  80119e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	38 c2                	cmp    %al,%dl
  8011a5:	74 da                	je     801181 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ab:	75 07                	jne    8011b4 <strncmp+0x38>
		return 0;
  8011ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b2:	eb 14                	jmp    8011c8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	0f b6 d0             	movzbl %al,%edx
  8011bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	0f b6 c0             	movzbl %al,%eax
  8011c4:	29 c2                	sub    %eax,%edx
  8011c6:	89 d0                	mov    %edx,%eax
}
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    

008011ca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	83 ec 04             	sub    $0x4,%esp
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011d6:	eb 12                	jmp    8011ea <strchr+0x20>
		if (*s == c)
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011e0:	75 05                	jne    8011e7 <strchr+0x1d>
			return (char *) s;
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	eb 11                	jmp    8011f8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011e7:	ff 45 08             	incl   0x8(%ebp)
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	84 c0                	test   %al,%al
  8011f1:	75 e5                	jne    8011d8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 04             	sub    $0x4,%esp
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801206:	eb 0d                	jmp    801215 <strfind+0x1b>
		if (*s == c)
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801210:	74 0e                	je     801220 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801212:	ff 45 08             	incl   0x8(%ebp)
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	84 c0                	test   %al,%al
  80121c:	75 ea                	jne    801208 <strfind+0xe>
  80121e:	eb 01                	jmp    801221 <strfind+0x27>
		if (*s == c)
			break;
  801220:	90                   	nop
	return (char *) s;
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801224:	c9                   	leave  
  801225:	c3                   	ret    

00801226 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
  801229:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801232:	8b 45 10             	mov    0x10(%ebp),%eax
  801235:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801238:	eb 0e                	jmp    801248 <memset+0x22>
		*p++ = c;
  80123a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123d:	8d 50 01             	lea    0x1(%eax),%edx
  801240:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801243:	8b 55 0c             	mov    0xc(%ebp),%edx
  801246:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801248:	ff 4d f8             	decl   -0x8(%ebp)
  80124b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80124f:	79 e9                	jns    80123a <memset+0x14>
		*p++ = c;

	return v;
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801254:	c9                   	leave  
  801255:	c3                   	ret    

00801256 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801268:	eb 16                	jmp    801280 <memcpy+0x2a>
		*d++ = *s++;
  80126a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126d:	8d 50 01             	lea    0x1(%eax),%edx
  801270:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801273:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801276:	8d 4a 01             	lea    0x1(%edx),%ecx
  801279:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80127c:	8a 12                	mov    (%edx),%dl
  80127e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	8d 50 ff             	lea    -0x1(%eax),%edx
  801286:	89 55 10             	mov    %edx,0x10(%ebp)
  801289:	85 c0                	test   %eax,%eax
  80128b:	75 dd                	jne    80126a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012aa:	73 50                	jae    8012fc <memmove+0x6a>
  8012ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012af:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b2:	01 d0                	add    %edx,%eax
  8012b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012b7:	76 43                	jbe    8012fc <memmove+0x6a>
		s += n;
  8012b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012c5:	eb 10                	jmp    8012d7 <memmove+0x45>
			*--d = *--s;
  8012c7:	ff 4d f8             	decl   -0x8(%ebp)
  8012ca:	ff 4d fc             	decl   -0x4(%ebp)
  8012cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d0:	8a 10                	mov    (%eax),%dl
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	75 e3                	jne    8012c7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012e4:	eb 23                	jmp    801309 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e9:	8d 50 01             	lea    0x1(%eax),%edx
  8012ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012f5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012f8:	8a 12                	mov    (%edx),%dl
  8012fa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801302:	89 55 10             	mov    %edx,0x10(%ebp)
  801305:	85 c0                	test   %eax,%eax
  801307:	75 dd                	jne    8012e6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801320:	eb 2a                	jmp    80134c <memcmp+0x3e>
		if (*s1 != *s2)
  801322:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801325:	8a 10                	mov    (%eax),%dl
  801327:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	38 c2                	cmp    %al,%dl
  80132e:	74 16                	je     801346 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801330:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801333:	8a 00                	mov    (%eax),%al
  801335:	0f b6 d0             	movzbl %al,%edx
  801338:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	0f b6 c0             	movzbl %al,%eax
  801340:	29 c2                	sub    %eax,%edx
  801342:	89 d0                	mov    %edx,%eax
  801344:	eb 18                	jmp    80135e <memcmp+0x50>
		s1++, s2++;
  801346:	ff 45 fc             	incl   -0x4(%ebp)
  801349:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80134c:	8b 45 10             	mov    0x10(%ebp),%eax
  80134f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801352:	89 55 10             	mov    %edx,0x10(%ebp)
  801355:	85 c0                	test   %eax,%eax
  801357:	75 c9                	jne    801322 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801359:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    

00801360 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801366:	8b 55 08             	mov    0x8(%ebp),%edx
  801369:	8b 45 10             	mov    0x10(%ebp),%eax
  80136c:	01 d0                	add    %edx,%eax
  80136e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801371:	eb 15                	jmp    801388 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	0f b6 d0             	movzbl %al,%edx
  80137b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137e:	0f b6 c0             	movzbl %al,%eax
  801381:	39 c2                	cmp    %eax,%edx
  801383:	74 0d                	je     801392 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801385:	ff 45 08             	incl   0x8(%ebp)
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80138e:	72 e3                	jb     801373 <memfind+0x13>
  801390:	eb 01                	jmp    801393 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801392:	90                   	nop
	return (void *) s;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80139e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013ac:	eb 03                	jmp    8013b1 <strtol+0x19>
		s++;
  8013ae:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	3c 20                	cmp    $0x20,%al
  8013b8:	74 f4                	je     8013ae <strtol+0x16>
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	3c 09                	cmp    $0x9,%al
  8013c1:	74 eb                	je     8013ae <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 00                	mov    (%eax),%al
  8013c8:	3c 2b                	cmp    $0x2b,%al
  8013ca:	75 05                	jne    8013d1 <strtol+0x39>
		s++;
  8013cc:	ff 45 08             	incl   0x8(%ebp)
  8013cf:	eb 13                	jmp    8013e4 <strtol+0x4c>
	else if (*s == '-')
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	3c 2d                	cmp    $0x2d,%al
  8013d8:	75 0a                	jne    8013e4 <strtol+0x4c>
		s++, neg = 1;
  8013da:	ff 45 08             	incl   0x8(%ebp)
  8013dd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e8:	74 06                	je     8013f0 <strtol+0x58>
  8013ea:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013ee:	75 20                	jne    801410 <strtol+0x78>
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	8a 00                	mov    (%eax),%al
  8013f5:	3c 30                	cmp    $0x30,%al
  8013f7:	75 17                	jne    801410 <strtol+0x78>
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	40                   	inc    %eax
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	3c 78                	cmp    $0x78,%al
  801401:	75 0d                	jne    801410 <strtol+0x78>
		s += 2, base = 16;
  801403:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801407:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80140e:	eb 28                	jmp    801438 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801410:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801414:	75 15                	jne    80142b <strtol+0x93>
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	3c 30                	cmp    $0x30,%al
  80141d:	75 0c                	jne    80142b <strtol+0x93>
		s++, base = 8;
  80141f:	ff 45 08             	incl   0x8(%ebp)
  801422:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801429:	eb 0d                	jmp    801438 <strtol+0xa0>
	else if (base == 0)
  80142b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142f:	75 07                	jne    801438 <strtol+0xa0>
		base = 10;
  801431:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	3c 2f                	cmp    $0x2f,%al
  80143f:	7e 19                	jle    80145a <strtol+0xc2>
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	3c 39                	cmp    $0x39,%al
  801448:	7f 10                	jg     80145a <strtol+0xc2>
			dig = *s - '0';
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	0f be c0             	movsbl %al,%eax
  801452:	83 e8 30             	sub    $0x30,%eax
  801455:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801458:	eb 42                	jmp    80149c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	3c 60                	cmp    $0x60,%al
  801461:	7e 19                	jle    80147c <strtol+0xe4>
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	3c 7a                	cmp    $0x7a,%al
  80146a:	7f 10                	jg     80147c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	0f be c0             	movsbl %al,%eax
  801474:	83 e8 57             	sub    $0x57,%eax
  801477:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80147a:	eb 20                	jmp    80149c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	8a 00                	mov    (%eax),%al
  801481:	3c 40                	cmp    $0x40,%al
  801483:	7e 39                	jle    8014be <strtol+0x126>
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	8a 00                	mov    (%eax),%al
  80148a:	3c 5a                	cmp    $0x5a,%al
  80148c:	7f 30                	jg     8014be <strtol+0x126>
			dig = *s - 'A' + 10;
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8a 00                	mov    (%eax),%al
  801493:	0f be c0             	movsbl %al,%eax
  801496:	83 e8 37             	sub    $0x37,%eax
  801499:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80149c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014a2:	7d 19                	jge    8014bd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014a4:	ff 45 08             	incl   0x8(%ebp)
  8014a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014aa:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014ae:	89 c2                	mov    %eax,%edx
  8014b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b3:	01 d0                	add    %edx,%eax
  8014b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014b8:	e9 7b ff ff ff       	jmp    801438 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014bd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014c2:	74 08                	je     8014cc <strtol+0x134>
		*endptr = (char *) s;
  8014c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ca:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014d0:	74 07                	je     8014d9 <strtol+0x141>
  8014d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d5:	f7 d8                	neg    %eax
  8014d7:	eb 03                	jmp    8014dc <strtol+0x144>
  8014d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <ltostr>:

void
ltostr(long value, char *str)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014eb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f6:	79 13                	jns    80150b <ltostr+0x2d>
	{
		neg = 1;
  8014f8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801502:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801505:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801508:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801513:	99                   	cltd   
  801514:	f7 f9                	idiv   %ecx
  801516:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801519:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151c:	8d 50 01             	lea    0x1(%eax),%edx
  80151f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801522:	89 c2                	mov    %eax,%edx
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	01 d0                	add    %edx,%eax
  801529:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80152c:	83 c2 30             	add    $0x30,%edx
  80152f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801531:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801534:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801539:	f7 e9                	imul   %ecx
  80153b:	c1 fa 02             	sar    $0x2,%edx
  80153e:	89 c8                	mov    %ecx,%eax
  801540:	c1 f8 1f             	sar    $0x1f,%eax
  801543:	29 c2                	sub    %eax,%edx
  801545:	89 d0                	mov    %edx,%eax
  801547:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80154a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801552:	f7 e9                	imul   %ecx
  801554:	c1 fa 02             	sar    $0x2,%edx
  801557:	89 c8                	mov    %ecx,%eax
  801559:	c1 f8 1f             	sar    $0x1f,%eax
  80155c:	29 c2                	sub    %eax,%edx
  80155e:	89 d0                	mov    %edx,%eax
  801560:	c1 e0 02             	shl    $0x2,%eax
  801563:	01 d0                	add    %edx,%eax
  801565:	01 c0                	add    %eax,%eax
  801567:	29 c1                	sub    %eax,%ecx
  801569:	89 ca                	mov    %ecx,%edx
  80156b:	85 d2                	test   %edx,%edx
  80156d:	75 9c                	jne    80150b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80156f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801576:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801579:	48                   	dec    %eax
  80157a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80157d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801581:	74 3d                	je     8015c0 <ltostr+0xe2>
		start = 1 ;
  801583:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80158a:	eb 34                	jmp    8015c0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80158c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	01 d0                	add    %edx,%eax
  801594:	8a 00                	mov    (%eax),%al
  801596:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801599:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159f:	01 c2                	add    %eax,%edx
  8015a1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a7:	01 c8                	add    %ecx,%eax
  8015a9:	8a 00                	mov    (%eax),%al
  8015ab:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b3:	01 c2                	add    %eax,%edx
  8015b5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015b8:	88 02                	mov    %al,(%edx)
		start++ ;
  8015ba:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015bd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015c6:	7c c4                	jl     80158c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015c8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ce:	01 d0                	add    %edx,%eax
  8015d0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015d3:	90                   	nop
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015dc:	ff 75 08             	pushl  0x8(%ebp)
  8015df:	e8 54 fa ff ff       	call   801038 <strlen>
  8015e4:	83 c4 04             	add    $0x4,%esp
  8015e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015ea:	ff 75 0c             	pushl  0xc(%ebp)
  8015ed:	e8 46 fa ff ff       	call   801038 <strlen>
  8015f2:	83 c4 04             	add    $0x4,%esp
  8015f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801606:	eb 17                	jmp    80161f <strcconcat+0x49>
		final[s] = str1[s] ;
  801608:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160b:	8b 45 10             	mov    0x10(%ebp),%eax
  80160e:	01 c2                	add    %eax,%edx
  801610:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	01 c8                	add    %ecx,%eax
  801618:	8a 00                	mov    (%eax),%al
  80161a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80161c:	ff 45 fc             	incl   -0x4(%ebp)
  80161f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801622:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801625:	7c e1                	jl     801608 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801627:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80162e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801635:	eb 1f                	jmp    801656 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801637:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163a:	8d 50 01             	lea    0x1(%eax),%edx
  80163d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801640:	89 c2                	mov    %eax,%edx
  801642:	8b 45 10             	mov    0x10(%ebp),%eax
  801645:	01 c2                	add    %eax,%edx
  801647:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80164a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164d:	01 c8                	add    %ecx,%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801653:	ff 45 f8             	incl   -0x8(%ebp)
  801656:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801659:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165c:	7c d9                	jl     801637 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80165e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801661:	8b 45 10             	mov    0x10(%ebp),%eax
  801664:	01 d0                	add    %edx,%eax
  801666:	c6 00 00             	movb   $0x0,(%eax)
}
  801669:	90                   	nop
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80166f:	8b 45 14             	mov    0x14(%ebp),%eax
  801672:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801678:	8b 45 14             	mov    0x14(%ebp),%eax
  80167b:	8b 00                	mov    (%eax),%eax
  80167d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801684:	8b 45 10             	mov    0x10(%ebp),%eax
  801687:	01 d0                	add    %edx,%eax
  801689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80168f:	eb 0c                	jmp    80169d <strsplit+0x31>
			*string++ = 0;
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8d 50 01             	lea    0x1(%eax),%edx
  801697:	89 55 08             	mov    %edx,0x8(%ebp)
  80169a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8a 00                	mov    (%eax),%al
  8016a2:	84 c0                	test   %al,%al
  8016a4:	74 18                	je     8016be <strsplit+0x52>
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	0f be c0             	movsbl %al,%eax
  8016ae:	50                   	push   %eax
  8016af:	ff 75 0c             	pushl  0xc(%ebp)
  8016b2:	e8 13 fb ff ff       	call   8011ca <strchr>
  8016b7:	83 c4 08             	add    $0x8,%esp
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	75 d3                	jne    801691 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8a 00                	mov    (%eax),%al
  8016c3:	84 c0                	test   %al,%al
  8016c5:	74 5a                	je     801721 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ca:	8b 00                	mov    (%eax),%eax
  8016cc:	83 f8 0f             	cmp    $0xf,%eax
  8016cf:	75 07                	jne    8016d8 <strsplit+0x6c>
		{
			return 0;
  8016d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d6:	eb 66                	jmp    80173e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016db:	8b 00                	mov    (%eax),%eax
  8016dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8016e0:	8b 55 14             	mov    0x14(%ebp),%edx
  8016e3:	89 0a                	mov    %ecx,(%edx)
  8016e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ef:	01 c2                	add    %eax,%edx
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016f6:	eb 03                	jmp    8016fb <strsplit+0x8f>
			string++;
  8016f8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8a 00                	mov    (%eax),%al
  801700:	84 c0                	test   %al,%al
  801702:	74 8b                	je     80168f <strsplit+0x23>
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	0f be c0             	movsbl %al,%eax
  80170c:	50                   	push   %eax
  80170d:	ff 75 0c             	pushl  0xc(%ebp)
  801710:	e8 b5 fa ff ff       	call   8011ca <strchr>
  801715:	83 c4 08             	add    $0x8,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 dc                	je     8016f8 <strsplit+0x8c>
			string++;
	}
  80171c:	e9 6e ff ff ff       	jmp    80168f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801721:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801722:	8b 45 14             	mov    0x14(%ebp),%eax
  801725:	8b 00                	mov    (%eax),%eax
  801727:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80172e:	8b 45 10             	mov    0x10(%ebp),%eax
  801731:	01 d0                	add    %edx,%eax
  801733:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801739:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801746:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  80174d:	8b 55 08             	mov    0x8(%ebp),%edx
  801750:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801753:	01 d0                	add    %edx,%eax
  801755:	48                   	dec    %eax
  801756:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801759:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80175c:	ba 00 00 00 00       	mov    $0x0,%edx
  801761:	f7 75 ac             	divl   -0x54(%ebp)
  801764:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801767:	29 d0                	sub    %edx,%eax
  801769:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  80176c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801773:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  80177a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801781:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801788:	eb 3f                	jmp    8017c9 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  80178a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80178d:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801794:	83 ec 04             	sub    $0x4,%esp
  801797:	50                   	push   %eax
  801798:	ff 75 e8             	pushl  -0x18(%ebp)
  80179b:	68 50 2d 80 00       	push   $0x802d50
  8017a0:	e8 11 f2 ff ff       	call   8009b6 <cprintf>
  8017a5:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  8017a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ab:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8017b2:	83 ec 04             	sub    $0x4,%esp
  8017b5:	50                   	push   %eax
  8017b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8017b9:	68 65 2d 80 00       	push   $0x802d65
  8017be:	e8 f3 f1 ff ff       	call   8009b6 <cprintf>
  8017c3:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  8017c6:	ff 45 e8             	incl   -0x18(%ebp)
  8017c9:	a1 28 30 80 00       	mov    0x803028,%eax
  8017ce:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8017d1:	7c b7                	jl     80178a <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8017d3:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  8017da:	e9 42 01 00 00       	jmp    801921 <malloc+0x1e1>
		int flag0=1;
  8017df:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8017e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017ec:	eb 6b                	jmp    801859 <malloc+0x119>
			for(int k=0;k<count;k++){
  8017ee:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8017f5:	eb 42                	jmp    801839 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8017f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017fa:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801801:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801804:	39 c2                	cmp    %eax,%edx
  801806:	77 2e                	ja     801836 <malloc+0xf6>
  801808:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80180b:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801812:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801815:	39 c2                	cmp    %eax,%edx
  801817:	76 1d                	jbe    801836 <malloc+0xf6>
					ni=arr_add[k].end-i;
  801819:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80181c:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801823:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801826:	29 c2                	sub    %eax,%edx
  801828:	89 d0                	mov    %edx,%eax
  80182a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  80182d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801834:	eb 0d                	jmp    801843 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801836:	ff 45 d8             	incl   -0x28(%ebp)
  801839:	a1 28 30 80 00       	mov    0x803028,%eax
  80183e:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801841:	7c b4                	jl     8017f7 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801843:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801847:	74 09                	je     801852 <malloc+0x112>
				flag0=0;
  801849:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801850:	eb 16                	jmp    801868 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801852:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801859:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	01 c2                	add    %eax,%edx
  801861:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801864:	39 c2                	cmp    %eax,%edx
  801866:	77 86                	ja     8017ee <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801868:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80186c:	0f 84 a2 00 00 00    	je     801914 <malloc+0x1d4>

			int f=1;
  801872:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801879:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80187c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80187f:	89 c8                	mov    %ecx,%eax
  801881:	01 c0                	add    %eax,%eax
  801883:	01 c8                	add    %ecx,%eax
  801885:	c1 e0 02             	shl    $0x2,%eax
  801888:	05 20 31 80 00       	add    $0x803120,%eax
  80188d:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  80188f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80189b:	89 d0                	mov    %edx,%eax
  80189d:	01 c0                	add    %eax,%eax
  80189f:	01 d0                	add    %edx,%eax
  8018a1:	c1 e0 02             	shl    $0x2,%eax
  8018a4:	05 24 31 80 00       	add    $0x803124,%eax
  8018a9:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  8018ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ae:	89 d0                	mov    %edx,%eax
  8018b0:	01 c0                	add    %eax,%eax
  8018b2:	01 d0                	add    %edx,%eax
  8018b4:	c1 e0 02             	shl    $0x2,%eax
  8018b7:	05 28 31 80 00       	add    $0x803128,%eax
  8018bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  8018c2:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  8018c5:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8018cc:	eb 36                	jmp    801904 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  8018ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	01 c2                	add    %eax,%edx
  8018d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8018d9:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8018e0:	39 c2                	cmp    %eax,%edx
  8018e2:	73 1d                	jae    801901 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  8018e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8018e7:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8018ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018f1:	29 c2                	sub    %eax,%edx
  8018f3:	89 d0                	mov    %edx,%eax
  8018f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  8018f8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  8018ff:	eb 0d                	jmp    80190e <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801901:	ff 45 d0             	incl   -0x30(%ebp)
  801904:	a1 28 30 80 00       	mov    0x803028,%eax
  801909:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  80190c:	7c c0                	jl     8018ce <malloc+0x18e>
					break;

				}
			}

			if(f){
  80190e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801912:	75 1d                	jne    801931 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801914:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  80191b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191e:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801921:	a1 04 30 80 00       	mov    0x803004,%eax
  801926:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801929:	0f 8c b0 fe ff ff    	jl     8017df <malloc+0x9f>
  80192f:	eb 01                	jmp    801932 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801931:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801932:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801936:	75 7a                	jne    8019b2 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801938:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	01 d0                	add    %edx,%eax
  801943:	48                   	dec    %eax
  801944:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801949:	7c 0a                	jl     801955 <malloc+0x215>
			return NULL;
  80194b:	b8 00 00 00 00       	mov    $0x0,%eax
  801950:	e9 a4 02 00 00       	jmp    801bf9 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801955:	a1 04 30 80 00       	mov    0x803004,%eax
  80195a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  80195d:	a1 28 30 80 00       	mov    0x803028,%eax
  801962:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801965:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  80196c:	83 ec 08             	sub    $0x8,%esp
  80196f:	ff 75 08             	pushl  0x8(%ebp)
  801972:	ff 75 a4             	pushl  -0x5c(%ebp)
  801975:	e8 04 06 00 00       	call   801f7e <sys_allocateMem>
  80197a:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  80197d:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	01 d0                	add    %edx,%eax
  801988:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  80198d:	a1 28 30 80 00       	mov    0x803028,%eax
  801992:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801998:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  80199f:	a1 28 30 80 00       	mov    0x803028,%eax
  8019a4:	40                   	inc    %eax
  8019a5:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  8019aa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8019ad:	e9 47 02 00 00       	jmp    801bf9 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  8019b2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8019b9:	e9 ac 00 00 00       	jmp    801a6a <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8019be:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8019c1:	89 d0                	mov    %edx,%eax
  8019c3:	01 c0                	add    %eax,%eax
  8019c5:	01 d0                	add    %edx,%eax
  8019c7:	c1 e0 02             	shl    $0x2,%eax
  8019ca:	05 24 31 80 00       	add    $0x803124,%eax
  8019cf:	8b 00                	mov    (%eax),%eax
  8019d1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8019d4:	eb 7e                	jmp    801a54 <malloc+0x314>
			int flag=0;
  8019d6:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  8019dd:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8019e4:	eb 57                	jmp    801a3d <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8019e6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019e9:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8019f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019f3:	39 c2                	cmp    %eax,%edx
  8019f5:	77 1a                	ja     801a11 <malloc+0x2d1>
  8019f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019fa:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801a01:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a04:	39 c2                	cmp    %eax,%edx
  801a06:	76 09                	jbe    801a11 <malloc+0x2d1>
								flag=1;
  801a08:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801a0f:	eb 36                	jmp    801a47 <malloc+0x307>
			arr[i].space++;
  801a11:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801a14:	89 d0                	mov    %edx,%eax
  801a16:	01 c0                	add    %eax,%eax
  801a18:	01 d0                	add    %edx,%eax
  801a1a:	c1 e0 02             	shl    $0x2,%eax
  801a1d:	05 28 31 80 00       	add    $0x803128,%eax
  801a22:	8b 00                	mov    (%eax),%eax
  801a24:	8d 48 01             	lea    0x1(%eax),%ecx
  801a27:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801a2a:	89 d0                	mov    %edx,%eax
  801a2c:	01 c0                	add    %eax,%eax
  801a2e:	01 d0                	add    %edx,%eax
  801a30:	c1 e0 02             	shl    $0x2,%eax
  801a33:	05 28 31 80 00       	add    $0x803128,%eax
  801a38:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801a3a:	ff 45 c0             	incl   -0x40(%ebp)
  801a3d:	a1 28 30 80 00       	mov    0x803028,%eax
  801a42:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801a45:	7c 9f                	jl     8019e6 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801a47:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801a4b:	75 19                	jne    801a66 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801a4d:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801a54:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801a57:	a1 04 30 80 00       	mov    0x803004,%eax
  801a5c:	39 c2                	cmp    %eax,%edx
  801a5e:	0f 82 72 ff ff ff    	jb     8019d6 <malloc+0x296>
  801a64:	eb 01                	jmp    801a67 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801a66:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801a67:	ff 45 cc             	incl   -0x34(%ebp)
  801a6a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a6d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a70:	0f 8c 48 ff ff ff    	jl     8019be <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801a76:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801a7d:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801a84:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801a8b:	eb 37                	jmp    801ac4 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801a8d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801a90:	89 d0                	mov    %edx,%eax
  801a92:	01 c0                	add    %eax,%eax
  801a94:	01 d0                	add    %edx,%eax
  801a96:	c1 e0 02             	shl    $0x2,%eax
  801a99:	05 28 31 80 00       	add    $0x803128,%eax
  801a9e:	8b 00                	mov    (%eax),%eax
  801aa0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801aa3:	7d 1c                	jge    801ac1 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801aa5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801aa8:	89 d0                	mov    %edx,%eax
  801aaa:	01 c0                	add    %eax,%eax
  801aac:	01 d0                	add    %edx,%eax
  801aae:	c1 e0 02             	shl    $0x2,%eax
  801ab1:	05 28 31 80 00       	add    $0x803128,%eax
  801ab6:	8b 00                	mov    (%eax),%eax
  801ab8:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801abb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801abe:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801ac1:	ff 45 b4             	incl   -0x4c(%ebp)
  801ac4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801ac7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801aca:	7c c1                	jl     801a8d <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801acc:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801ad2:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801ad5:	89 c8                	mov    %ecx,%eax
  801ad7:	01 c0                	add    %eax,%eax
  801ad9:	01 c8                	add    %ecx,%eax
  801adb:	c1 e0 02             	shl    $0x2,%eax
  801ade:	05 20 31 80 00       	add    $0x803120,%eax
  801ae3:	8b 00                	mov    (%eax),%eax
  801ae5:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801aec:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801af2:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801af5:	89 c8                	mov    %ecx,%eax
  801af7:	01 c0                	add    %eax,%eax
  801af9:	01 c8                	add    %ecx,%eax
  801afb:	c1 e0 02             	shl    $0x2,%eax
  801afe:	05 24 31 80 00       	add    $0x803124,%eax
  801b03:	8b 00                	mov    (%eax),%eax
  801b05:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  801b0c:	a1 28 30 80 00       	mov    0x803028,%eax
  801b11:	40                   	inc    %eax
  801b12:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  801b17:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801b1a:	89 d0                	mov    %edx,%eax
  801b1c:	01 c0                	add    %eax,%eax
  801b1e:	01 d0                	add    %edx,%eax
  801b20:	c1 e0 02             	shl    $0x2,%eax
  801b23:	05 20 31 80 00       	add    $0x803120,%eax
  801b28:	8b 00                	mov    (%eax),%eax
  801b2a:	83 ec 08             	sub    $0x8,%esp
  801b2d:	ff 75 08             	pushl  0x8(%ebp)
  801b30:	50                   	push   %eax
  801b31:	e8 48 04 00 00       	call   801f7e <sys_allocateMem>
  801b36:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801b39:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801b40:	eb 78                	jmp    801bba <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801b42:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801b45:	89 d0                	mov    %edx,%eax
  801b47:	01 c0                	add    %eax,%eax
  801b49:	01 d0                	add    %edx,%eax
  801b4b:	c1 e0 02             	shl    $0x2,%eax
  801b4e:	05 20 31 80 00       	add    $0x803120,%eax
  801b53:	8b 00                	mov    (%eax),%eax
  801b55:	83 ec 04             	sub    $0x4,%esp
  801b58:	50                   	push   %eax
  801b59:	ff 75 b0             	pushl  -0x50(%ebp)
  801b5c:	68 50 2d 80 00       	push   $0x802d50
  801b61:	e8 50 ee ff ff       	call   8009b6 <cprintf>
  801b66:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801b69:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801b6c:	89 d0                	mov    %edx,%eax
  801b6e:	01 c0                	add    %eax,%eax
  801b70:	01 d0                	add    %edx,%eax
  801b72:	c1 e0 02             	shl    $0x2,%eax
  801b75:	05 24 31 80 00       	add    $0x803124,%eax
  801b7a:	8b 00                	mov    (%eax),%eax
  801b7c:	83 ec 04             	sub    $0x4,%esp
  801b7f:	50                   	push   %eax
  801b80:	ff 75 b0             	pushl  -0x50(%ebp)
  801b83:	68 65 2d 80 00       	push   $0x802d65
  801b88:	e8 29 ee ff ff       	call   8009b6 <cprintf>
  801b8d:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801b90:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801b93:	89 d0                	mov    %edx,%eax
  801b95:	01 c0                	add    %eax,%eax
  801b97:	01 d0                	add    %edx,%eax
  801b99:	c1 e0 02             	shl    $0x2,%eax
  801b9c:	05 28 31 80 00       	add    $0x803128,%eax
  801ba1:	8b 00                	mov    (%eax),%eax
  801ba3:	83 ec 04             	sub    $0x4,%esp
  801ba6:	50                   	push   %eax
  801ba7:	ff 75 b0             	pushl  -0x50(%ebp)
  801baa:	68 78 2d 80 00       	push   $0x802d78
  801baf:	e8 02 ee ff ff       	call   8009b6 <cprintf>
  801bb4:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801bb7:	ff 45 b0             	incl   -0x50(%ebp)
  801bba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801bbd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bc0:	7c 80                	jl     801b42 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801bc2:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801bc5:	89 d0                	mov    %edx,%eax
  801bc7:	01 c0                	add    %eax,%eax
  801bc9:	01 d0                	add    %edx,%eax
  801bcb:	c1 e0 02             	shl    $0x2,%eax
  801bce:	05 20 31 80 00       	add    $0x803120,%eax
  801bd3:	8b 00                	mov    (%eax),%eax
  801bd5:	83 ec 08             	sub    $0x8,%esp
  801bd8:	50                   	push   %eax
  801bd9:	68 8c 2d 80 00       	push   $0x802d8c
  801bde:	e8 d3 ed ff ff       	call   8009b6 <cprintf>
  801be3:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801be6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801be9:	89 d0                	mov    %edx,%eax
  801beb:	01 c0                	add    %eax,%eax
  801bed:	01 d0                	add    %edx,%eax
  801bef:	c1 e0 02             	shl    $0x2,%eax
  801bf2:	05 20 31 80 00       	add    $0x803120,%eax
  801bf7:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801c07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801c0e:	eb 4b                	jmp    801c5b <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c13:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801c1a:	89 c2                	mov    %eax,%edx
  801c1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c1f:	39 c2                	cmp    %eax,%edx
  801c21:	7f 35                	jg     801c58 <free+0x5d>
  801c23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c26:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801c2d:	89 c2                	mov    %eax,%edx
  801c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c32:	39 c2                	cmp    %eax,%edx
  801c34:	7e 22                	jle    801c58 <free+0x5d>
				start=arr_add[i].start;
  801c36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c39:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801c40:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c46:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801c4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801c50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c53:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801c56:	eb 0d                	jmp    801c65 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801c58:	ff 45 ec             	incl   -0x14(%ebp)
  801c5b:	a1 28 30 80 00       	mov    0x803028,%eax
  801c60:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801c63:	7c ab                	jl     801c10 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c68:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c72:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801c79:	29 c2                	sub    %eax,%edx
  801c7b:	89 d0                	mov    %edx,%eax
  801c7d:	83 ec 08             	sub    $0x8,%esp
  801c80:	50                   	push   %eax
  801c81:	ff 75 f4             	pushl  -0xc(%ebp)
  801c84:	e8 d9 02 00 00       	call   801f62 <sys_freeMem>
  801c89:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c92:	eb 2d                	jmp    801cc1 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801c94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c97:	40                   	inc    %eax
  801c98:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801c9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ca2:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801ca9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cac:	40                   	inc    %eax
  801cad:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801cb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cb7:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801cbe:	ff 45 e8             	incl   -0x18(%ebp)
  801cc1:	a1 28 30 80 00       	mov    0x803028,%eax
  801cc6:	48                   	dec    %eax
  801cc7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801cca:	7f c8                	jg     801c94 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801ccc:	a1 28 30 80 00       	mov    0x803028,%eax
  801cd1:	48                   	dec    %eax
  801cd2:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801cd7:	90                   	nop
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 18             	sub    $0x18,%esp
  801ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce3:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801ce6:	83 ec 04             	sub    $0x4,%esp
  801ce9:	68 a8 2d 80 00       	push   $0x802da8
  801cee:	68 18 01 00 00       	push   $0x118
  801cf3:	68 cb 2d 80 00       	push   $0x802dcb
  801cf8:	e8 17 ea ff ff       	call   800714 <_panic>

00801cfd <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d03:	83 ec 04             	sub    $0x4,%esp
  801d06:	68 a8 2d 80 00       	push   $0x802da8
  801d0b:	68 1e 01 00 00       	push   $0x11e
  801d10:	68 cb 2d 80 00       	push   $0x802dcb
  801d15:	e8 fa e9 ff ff       	call   800714 <_panic>

00801d1a <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d20:	83 ec 04             	sub    $0x4,%esp
  801d23:	68 a8 2d 80 00       	push   $0x802da8
  801d28:	68 24 01 00 00       	push   $0x124
  801d2d:	68 cb 2d 80 00       	push   $0x802dcb
  801d32:	e8 dd e9 ff ff       	call   800714 <_panic>

00801d37 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d3d:	83 ec 04             	sub    $0x4,%esp
  801d40:	68 a8 2d 80 00       	push   $0x802da8
  801d45:	68 29 01 00 00       	push   $0x129
  801d4a:	68 cb 2d 80 00       	push   $0x802dcb
  801d4f:	e8 c0 e9 ff ff       	call   800714 <_panic>

00801d54 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d5a:	83 ec 04             	sub    $0x4,%esp
  801d5d:	68 a8 2d 80 00       	push   $0x802da8
  801d62:	68 2f 01 00 00       	push   $0x12f
  801d67:	68 cb 2d 80 00       	push   $0x802dcb
  801d6c:	e8 a3 e9 ff ff       	call   800714 <_panic>

00801d71 <shrink>:
}
void shrink(uint32 newSize)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d77:	83 ec 04             	sub    $0x4,%esp
  801d7a:	68 a8 2d 80 00       	push   $0x802da8
  801d7f:	68 33 01 00 00       	push   $0x133
  801d84:	68 cb 2d 80 00       	push   $0x802dcb
  801d89:	e8 86 e9 ff ff       	call   800714 <_panic>

00801d8e <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d94:	83 ec 04             	sub    $0x4,%esp
  801d97:	68 a8 2d 80 00       	push   $0x802da8
  801d9c:	68 38 01 00 00       	push   $0x138
  801da1:	68 cb 2d 80 00       	push   $0x802dcb
  801da6:	e8 69 e9 ff ff       	call   800714 <_panic>

00801dab <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	57                   	push   %edi
  801daf:	56                   	push   %esi
  801db0:	53                   	push   %ebx
  801db1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dbd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dc0:	8b 7d 18             	mov    0x18(%ebp),%edi
  801dc3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801dc6:	cd 30                	int    $0x30
  801dc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801dce:	83 c4 10             	add    $0x10,%esp
  801dd1:	5b                   	pop    %ebx
  801dd2:	5e                   	pop    %esi
  801dd3:	5f                   	pop    %edi
  801dd4:	5d                   	pop    %ebp
  801dd5:	c3                   	ret    

00801dd6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 04             	sub    $0x4,%esp
  801ddc:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801de2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	52                   	push   %edx
  801dee:	ff 75 0c             	pushl  0xc(%ebp)
  801df1:	50                   	push   %eax
  801df2:	6a 00                	push   $0x0
  801df4:	e8 b2 ff ff ff       	call   801dab <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	90                   	nop
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_cgetc>:

int
sys_cgetc(void)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 01                	push   $0x1
  801e0e:	e8 98 ff ff ff       	call   801dab <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	50                   	push   %eax
  801e27:	6a 05                	push   $0x5
  801e29:	e8 7d ff ff ff       	call   801dab <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 02                	push   $0x2
  801e42:	e8 64 ff ff ff       	call   801dab <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 03                	push   $0x3
  801e5b:	e8 4b ff ff ff       	call   801dab <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 04                	push   $0x4
  801e74:	e8 32 ff ff ff       	call   801dab <syscall>
  801e79:	83 c4 18             	add    $0x18,%esp
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <sys_env_exit>:


void sys_env_exit(void)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 06                	push   $0x6
  801e8d:	e8 19 ff ff ff       	call   801dab <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
}
  801e95:	90                   	nop
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	52                   	push   %edx
  801ea8:	50                   	push   %eax
  801ea9:	6a 07                	push   $0x7
  801eab:	e8 fb fe ff ff       	call   801dab <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	56                   	push   %esi
  801eb9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801eba:	8b 75 18             	mov    0x18(%ebp),%esi
  801ebd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ec0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	56                   	push   %esi
  801eca:	53                   	push   %ebx
  801ecb:	51                   	push   %ecx
  801ecc:	52                   	push   %edx
  801ecd:	50                   	push   %eax
  801ece:	6a 08                	push   $0x8
  801ed0:	e8 d6 fe ff ff       	call   801dab <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801edb:	5b                   	pop    %ebx
  801edc:	5e                   	pop    %esi
  801edd:	5d                   	pop    %ebp
  801ede:	c3                   	ret    

00801edf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ee2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	52                   	push   %edx
  801eef:	50                   	push   %eax
  801ef0:	6a 09                	push   $0x9
  801ef2:	e8 b4 fe ff ff       	call   801dab <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	ff 75 0c             	pushl  0xc(%ebp)
  801f08:	ff 75 08             	pushl  0x8(%ebp)
  801f0b:	6a 0a                	push   $0xa
  801f0d:	e8 99 fe ff ff       	call   801dab <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 0b                	push   $0xb
  801f26:	e8 80 fe ff ff       	call   801dab <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 0c                	push   $0xc
  801f3f:	e8 67 fe ff ff       	call   801dab <syscall>
  801f44:	83 c4 18             	add    $0x18,%esp
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 0d                	push   $0xd
  801f58:	e8 4e fe ff ff       	call   801dab <syscall>
  801f5d:	83 c4 18             	add    $0x18,%esp
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	ff 75 0c             	pushl  0xc(%ebp)
  801f6e:	ff 75 08             	pushl  0x8(%ebp)
  801f71:	6a 11                	push   $0x11
  801f73:	e8 33 fe ff ff       	call   801dab <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
	return;
  801f7b:	90                   	nop
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	ff 75 0c             	pushl  0xc(%ebp)
  801f8a:	ff 75 08             	pushl  0x8(%ebp)
  801f8d:	6a 12                	push   $0x12
  801f8f:	e8 17 fe ff ff       	call   801dab <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
	return ;
  801f97:	90                   	nop
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 0e                	push   $0xe
  801fa9:	e8 fd fd ff ff       	call   801dab <syscall>
  801fae:	83 c4 18             	add    $0x18,%esp
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	ff 75 08             	pushl  0x8(%ebp)
  801fc1:	6a 0f                	push   $0xf
  801fc3:	e8 e3 fd ff ff       	call   801dab <syscall>
  801fc8:	83 c4 18             	add    $0x18,%esp
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <sys_scarce_memory>:

void sys_scarce_memory()
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 10                	push   $0x10
  801fdc:	e8 ca fd ff ff       	call   801dab <syscall>
  801fe1:	83 c4 18             	add    $0x18,%esp
}
  801fe4:	90                   	nop
  801fe5:	c9                   	leave  
  801fe6:	c3                   	ret    

00801fe7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 14                	push   $0x14
  801ff6:	e8 b0 fd ff ff       	call   801dab <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
}
  801ffe:	90                   	nop
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 15                	push   $0x15
  802010:	e8 96 fd ff ff       	call   801dab <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
}
  802018:	90                   	nop
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_cputc>:


void
sys_cputc(const char c)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 04             	sub    $0x4,%esp
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802027:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	50                   	push   %eax
  802034:	6a 16                	push   $0x16
  802036:	e8 70 fd ff ff       	call   801dab <syscall>
  80203b:	83 c4 18             	add    $0x18,%esp
}
  80203e:	90                   	nop
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 17                	push   $0x17
  802050:	e8 56 fd ff ff       	call   801dab <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
}
  802058:	90                   	nop
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	ff 75 0c             	pushl  0xc(%ebp)
  80206a:	50                   	push   %eax
  80206b:	6a 18                	push   $0x18
  80206d:	e8 39 fd ff ff       	call   801dab <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80207a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	52                   	push   %edx
  802087:	50                   	push   %eax
  802088:	6a 1b                	push   $0x1b
  80208a:	e8 1c fd ff ff       	call   801dab <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802097:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	52                   	push   %edx
  8020a4:	50                   	push   %eax
  8020a5:	6a 19                	push   $0x19
  8020a7:	e8 ff fc ff ff       	call   801dab <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
}
  8020af:	90                   	nop
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	52                   	push   %edx
  8020c2:	50                   	push   %eax
  8020c3:	6a 1a                	push   $0x1a
  8020c5:	e8 e1 fc ff ff       	call   801dab <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
}
  8020cd:	90                   	nop
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 04             	sub    $0x4,%esp
  8020d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020dc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020df:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	6a 00                	push   $0x0
  8020e8:	51                   	push   %ecx
  8020e9:	52                   	push   %edx
  8020ea:	ff 75 0c             	pushl  0xc(%ebp)
  8020ed:	50                   	push   %eax
  8020ee:	6a 1c                	push   $0x1c
  8020f0:	e8 b6 fc ff ff       	call   801dab <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8020fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	52                   	push   %edx
  80210a:	50                   	push   %eax
  80210b:	6a 1d                	push   $0x1d
  80210d:	e8 99 fc ff ff       	call   801dab <syscall>
  802112:	83 c4 18             	add    $0x18,%esp
}
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80211a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	51                   	push   %ecx
  802128:	52                   	push   %edx
  802129:	50                   	push   %eax
  80212a:	6a 1e                	push   $0x1e
  80212c:	e8 7a fc ff ff       	call   801dab <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802139:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	52                   	push   %edx
  802146:	50                   	push   %eax
  802147:	6a 1f                	push   $0x1f
  802149:	e8 5d fc ff ff       	call   801dab <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 20                	push   $0x20
  802162:	e8 44 fc ff ff       	call   801dab <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	6a 00                	push   $0x0
  802174:	ff 75 14             	pushl  0x14(%ebp)
  802177:	ff 75 10             	pushl  0x10(%ebp)
  80217a:	ff 75 0c             	pushl  0xc(%ebp)
  80217d:	50                   	push   %eax
  80217e:	6a 21                	push   $0x21
  802180:	e8 26 fc ff ff       	call   801dab <syscall>
  802185:	83 c4 18             	add    $0x18,%esp
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	50                   	push   %eax
  802199:	6a 22                	push   $0x22
  80219b:	e8 0b fc ff ff       	call   801dab <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
}
  8021a3:	90                   	nop
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	50                   	push   %eax
  8021b5:	6a 23                	push   $0x23
  8021b7:	e8 ef fb ff ff       	call   801dab <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
}
  8021bf:	90                   	nop
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021c8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021cb:	8d 50 04             	lea    0x4(%eax),%edx
  8021ce:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	52                   	push   %edx
  8021d8:	50                   	push   %eax
  8021d9:	6a 24                	push   $0x24
  8021db:	e8 cb fb ff ff       	call   801dab <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
	return result;
  8021e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021ec:	89 01                	mov    %eax,(%ecx)
  8021ee:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	c9                   	leave  
  8021f5:	c2 04 00             	ret    $0x4

008021f8 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	ff 75 10             	pushl  0x10(%ebp)
  802202:	ff 75 0c             	pushl  0xc(%ebp)
  802205:	ff 75 08             	pushl  0x8(%ebp)
  802208:	6a 13                	push   $0x13
  80220a:	e8 9c fb ff ff       	call   801dab <syscall>
  80220f:	83 c4 18             	add    $0x18,%esp
	return ;
  802212:	90                   	nop
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <sys_rcr2>:
uint32 sys_rcr2()
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 25                	push   $0x25
  802224:	e8 82 fb ff ff       	call   801dab <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80223a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	50                   	push   %eax
  802247:	6a 26                	push   $0x26
  802249:	e8 5d fb ff ff       	call   801dab <syscall>
  80224e:	83 c4 18             	add    $0x18,%esp
	return ;
  802251:	90                   	nop
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <rsttst>:
void rsttst()
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 28                	push   $0x28
  802263:	e8 43 fb ff ff       	call   801dab <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
	return ;
  80226b:	90                   	nop
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	83 ec 04             	sub    $0x4,%esp
  802274:	8b 45 14             	mov    0x14(%ebp),%eax
  802277:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80227a:	8b 55 18             	mov    0x18(%ebp),%edx
  80227d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802281:	52                   	push   %edx
  802282:	50                   	push   %eax
  802283:	ff 75 10             	pushl  0x10(%ebp)
  802286:	ff 75 0c             	pushl  0xc(%ebp)
  802289:	ff 75 08             	pushl  0x8(%ebp)
  80228c:	6a 27                	push   $0x27
  80228e:	e8 18 fb ff ff       	call   801dab <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
	return ;
  802296:	90                   	nop
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <chktst>:
void chktst(uint32 n)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	ff 75 08             	pushl  0x8(%ebp)
  8022a7:	6a 29                	push   $0x29
  8022a9:	e8 fd fa ff ff       	call   801dab <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b1:	90                   	nop
}
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <inctst>:

void inctst()
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 2a                	push   $0x2a
  8022c3:	e8 e3 fa ff ff       	call   801dab <syscall>
  8022c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8022cb:	90                   	nop
}
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <gettst>:
uint32 gettst()
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 2b                	push   $0x2b
  8022dd:	e8 c9 fa ff ff       	call   801dab <syscall>
  8022e2:	83 c4 18             	add    $0x18,%esp
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
  8022ea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 2c                	push   $0x2c
  8022f9:	e8 ad fa ff ff       	call   801dab <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
  802301:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802304:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802308:	75 07                	jne    802311 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80230a:	b8 01 00 00 00       	mov    $0x1,%eax
  80230f:	eb 05                	jmp    802316 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802311:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 2c                	push   $0x2c
  80232a:	e8 7c fa ff ff       	call   801dab <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
  802332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802335:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802339:	75 07                	jne    802342 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80233b:	b8 01 00 00 00       	mov    $0x1,%eax
  802340:	eb 05                	jmp    802347 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802342:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
  80234c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 2c                	push   $0x2c
  80235b:	e8 4b fa ff ff       	call   801dab <syscall>
  802360:	83 c4 18             	add    $0x18,%esp
  802363:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802366:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80236a:	75 07                	jne    802373 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80236c:	b8 01 00 00 00       	mov    $0x1,%eax
  802371:	eb 05                	jmp    802378 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802373:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 2c                	push   $0x2c
  80238c:	e8 1a fa ff ff       	call   801dab <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
  802394:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802397:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80239b:	75 07                	jne    8023a4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80239d:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a2:	eb 05                	jmp    8023a9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	ff 75 08             	pushl  0x8(%ebp)
  8023b9:	6a 2d                	push   $0x2d
  8023bb:	e8 eb f9 ff ff       	call   801dab <syscall>
  8023c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c3:	90                   	nop
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
  8023c9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	6a 00                	push   $0x0
  8023d8:	53                   	push   %ebx
  8023d9:	51                   	push   %ecx
  8023da:	52                   	push   %edx
  8023db:	50                   	push   %eax
  8023dc:	6a 2e                	push   $0x2e
  8023de:	e8 c8 f9 ff ff       	call   801dab <syscall>
  8023e3:	83 c4 18             	add    $0x18,%esp
}
  8023e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    

008023eb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	52                   	push   %edx
  8023fb:	50                   	push   %eax
  8023fc:	6a 2f                	push   $0x2f
  8023fe:	e8 a8 f9 ff ff       	call   801dab <syscall>
  802403:	83 c4 18             	add    $0x18,%esp
}
  802406:	c9                   	leave  
  802407:	c3                   	ret    

00802408 <__udivdi3>:
  802408:	55                   	push   %ebp
  802409:	57                   	push   %edi
  80240a:	56                   	push   %esi
  80240b:	53                   	push   %ebx
  80240c:	83 ec 1c             	sub    $0x1c,%esp
  80240f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802413:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802417:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80241b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80241f:	89 ca                	mov    %ecx,%edx
  802421:	89 f8                	mov    %edi,%eax
  802423:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802427:	85 f6                	test   %esi,%esi
  802429:	75 2d                	jne    802458 <__udivdi3+0x50>
  80242b:	39 cf                	cmp    %ecx,%edi
  80242d:	77 65                	ja     802494 <__udivdi3+0x8c>
  80242f:	89 fd                	mov    %edi,%ebp
  802431:	85 ff                	test   %edi,%edi
  802433:	75 0b                	jne    802440 <__udivdi3+0x38>
  802435:	b8 01 00 00 00       	mov    $0x1,%eax
  80243a:	31 d2                	xor    %edx,%edx
  80243c:	f7 f7                	div    %edi
  80243e:	89 c5                	mov    %eax,%ebp
  802440:	31 d2                	xor    %edx,%edx
  802442:	89 c8                	mov    %ecx,%eax
  802444:	f7 f5                	div    %ebp
  802446:	89 c1                	mov    %eax,%ecx
  802448:	89 d8                	mov    %ebx,%eax
  80244a:	f7 f5                	div    %ebp
  80244c:	89 cf                	mov    %ecx,%edi
  80244e:	89 fa                	mov    %edi,%edx
  802450:	83 c4 1c             	add    $0x1c,%esp
  802453:	5b                   	pop    %ebx
  802454:	5e                   	pop    %esi
  802455:	5f                   	pop    %edi
  802456:	5d                   	pop    %ebp
  802457:	c3                   	ret    
  802458:	39 ce                	cmp    %ecx,%esi
  80245a:	77 28                	ja     802484 <__udivdi3+0x7c>
  80245c:	0f bd fe             	bsr    %esi,%edi
  80245f:	83 f7 1f             	xor    $0x1f,%edi
  802462:	75 40                	jne    8024a4 <__udivdi3+0x9c>
  802464:	39 ce                	cmp    %ecx,%esi
  802466:	72 0a                	jb     802472 <__udivdi3+0x6a>
  802468:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80246c:	0f 87 9e 00 00 00    	ja     802510 <__udivdi3+0x108>
  802472:	b8 01 00 00 00       	mov    $0x1,%eax
  802477:	89 fa                	mov    %edi,%edx
  802479:	83 c4 1c             	add    $0x1c,%esp
  80247c:	5b                   	pop    %ebx
  80247d:	5e                   	pop    %esi
  80247e:	5f                   	pop    %edi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    
  802481:	8d 76 00             	lea    0x0(%esi),%esi
  802484:	31 ff                	xor    %edi,%edi
  802486:	31 c0                	xor    %eax,%eax
  802488:	89 fa                	mov    %edi,%edx
  80248a:	83 c4 1c             	add    $0x1c,%esp
  80248d:	5b                   	pop    %ebx
  80248e:	5e                   	pop    %esi
  80248f:	5f                   	pop    %edi
  802490:	5d                   	pop    %ebp
  802491:	c3                   	ret    
  802492:	66 90                	xchg   %ax,%ax
  802494:	89 d8                	mov    %ebx,%eax
  802496:	f7 f7                	div    %edi
  802498:	31 ff                	xor    %edi,%edi
  80249a:	89 fa                	mov    %edi,%edx
  80249c:	83 c4 1c             	add    $0x1c,%esp
  80249f:	5b                   	pop    %ebx
  8024a0:	5e                   	pop    %esi
  8024a1:	5f                   	pop    %edi
  8024a2:	5d                   	pop    %ebp
  8024a3:	c3                   	ret    
  8024a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8024a9:	89 eb                	mov    %ebp,%ebx
  8024ab:	29 fb                	sub    %edi,%ebx
  8024ad:	89 f9                	mov    %edi,%ecx
  8024af:	d3 e6                	shl    %cl,%esi
  8024b1:	89 c5                	mov    %eax,%ebp
  8024b3:	88 d9                	mov    %bl,%cl
  8024b5:	d3 ed                	shr    %cl,%ebp
  8024b7:	89 e9                	mov    %ebp,%ecx
  8024b9:	09 f1                	or     %esi,%ecx
  8024bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8024bf:	89 f9                	mov    %edi,%ecx
  8024c1:	d3 e0                	shl    %cl,%eax
  8024c3:	89 c5                	mov    %eax,%ebp
  8024c5:	89 d6                	mov    %edx,%esi
  8024c7:	88 d9                	mov    %bl,%cl
  8024c9:	d3 ee                	shr    %cl,%esi
  8024cb:	89 f9                	mov    %edi,%ecx
  8024cd:	d3 e2                	shl    %cl,%edx
  8024cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024d3:	88 d9                	mov    %bl,%cl
  8024d5:	d3 e8                	shr    %cl,%eax
  8024d7:	09 c2                	or     %eax,%edx
  8024d9:	89 d0                	mov    %edx,%eax
  8024db:	89 f2                	mov    %esi,%edx
  8024dd:	f7 74 24 0c          	divl   0xc(%esp)
  8024e1:	89 d6                	mov    %edx,%esi
  8024e3:	89 c3                	mov    %eax,%ebx
  8024e5:	f7 e5                	mul    %ebp
  8024e7:	39 d6                	cmp    %edx,%esi
  8024e9:	72 19                	jb     802504 <__udivdi3+0xfc>
  8024eb:	74 0b                	je     8024f8 <__udivdi3+0xf0>
  8024ed:	89 d8                	mov    %ebx,%eax
  8024ef:	31 ff                	xor    %edi,%edi
  8024f1:	e9 58 ff ff ff       	jmp    80244e <__udivdi3+0x46>
  8024f6:	66 90                	xchg   %ax,%ax
  8024f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8024fc:	89 f9                	mov    %edi,%ecx
  8024fe:	d3 e2                	shl    %cl,%edx
  802500:	39 c2                	cmp    %eax,%edx
  802502:	73 e9                	jae    8024ed <__udivdi3+0xe5>
  802504:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802507:	31 ff                	xor    %edi,%edi
  802509:	e9 40 ff ff ff       	jmp    80244e <__udivdi3+0x46>
  80250e:	66 90                	xchg   %ax,%ax
  802510:	31 c0                	xor    %eax,%eax
  802512:	e9 37 ff ff ff       	jmp    80244e <__udivdi3+0x46>
  802517:	90                   	nop

00802518 <__umoddi3>:
  802518:	55                   	push   %ebp
  802519:	57                   	push   %edi
  80251a:	56                   	push   %esi
  80251b:	53                   	push   %ebx
  80251c:	83 ec 1c             	sub    $0x1c,%esp
  80251f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802523:	8b 74 24 34          	mov    0x34(%esp),%esi
  802527:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80252b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80252f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802533:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802537:	89 f3                	mov    %esi,%ebx
  802539:	89 fa                	mov    %edi,%edx
  80253b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80253f:	89 34 24             	mov    %esi,(%esp)
  802542:	85 c0                	test   %eax,%eax
  802544:	75 1a                	jne    802560 <__umoddi3+0x48>
  802546:	39 f7                	cmp    %esi,%edi
  802548:	0f 86 a2 00 00 00    	jbe    8025f0 <__umoddi3+0xd8>
  80254e:	89 c8                	mov    %ecx,%eax
  802550:	89 f2                	mov    %esi,%edx
  802552:	f7 f7                	div    %edi
  802554:	89 d0                	mov    %edx,%eax
  802556:	31 d2                	xor    %edx,%edx
  802558:	83 c4 1c             	add    $0x1c,%esp
  80255b:	5b                   	pop    %ebx
  80255c:	5e                   	pop    %esi
  80255d:	5f                   	pop    %edi
  80255e:	5d                   	pop    %ebp
  80255f:	c3                   	ret    
  802560:	39 f0                	cmp    %esi,%eax
  802562:	0f 87 ac 00 00 00    	ja     802614 <__umoddi3+0xfc>
  802568:	0f bd e8             	bsr    %eax,%ebp
  80256b:	83 f5 1f             	xor    $0x1f,%ebp
  80256e:	0f 84 ac 00 00 00    	je     802620 <__umoddi3+0x108>
  802574:	bf 20 00 00 00       	mov    $0x20,%edi
  802579:	29 ef                	sub    %ebp,%edi
  80257b:	89 fe                	mov    %edi,%esi
  80257d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802581:	89 e9                	mov    %ebp,%ecx
  802583:	d3 e0                	shl    %cl,%eax
  802585:	89 d7                	mov    %edx,%edi
  802587:	89 f1                	mov    %esi,%ecx
  802589:	d3 ef                	shr    %cl,%edi
  80258b:	09 c7                	or     %eax,%edi
  80258d:	89 e9                	mov    %ebp,%ecx
  80258f:	d3 e2                	shl    %cl,%edx
  802591:	89 14 24             	mov    %edx,(%esp)
  802594:	89 d8                	mov    %ebx,%eax
  802596:	d3 e0                	shl    %cl,%eax
  802598:	89 c2                	mov    %eax,%edx
  80259a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80259e:	d3 e0                	shl    %cl,%eax
  8025a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025a8:	89 f1                	mov    %esi,%ecx
  8025aa:	d3 e8                	shr    %cl,%eax
  8025ac:	09 d0                	or     %edx,%eax
  8025ae:	d3 eb                	shr    %cl,%ebx
  8025b0:	89 da                	mov    %ebx,%edx
  8025b2:	f7 f7                	div    %edi
  8025b4:	89 d3                	mov    %edx,%ebx
  8025b6:	f7 24 24             	mull   (%esp)
  8025b9:	89 c6                	mov    %eax,%esi
  8025bb:	89 d1                	mov    %edx,%ecx
  8025bd:	39 d3                	cmp    %edx,%ebx
  8025bf:	0f 82 87 00 00 00    	jb     80264c <__umoddi3+0x134>
  8025c5:	0f 84 91 00 00 00    	je     80265c <__umoddi3+0x144>
  8025cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025cf:	29 f2                	sub    %esi,%edx
  8025d1:	19 cb                	sbb    %ecx,%ebx
  8025d3:	89 d8                	mov    %ebx,%eax
  8025d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8025d9:	d3 e0                	shl    %cl,%eax
  8025db:	89 e9                	mov    %ebp,%ecx
  8025dd:	d3 ea                	shr    %cl,%edx
  8025df:	09 d0                	or     %edx,%eax
  8025e1:	89 e9                	mov    %ebp,%ecx
  8025e3:	d3 eb                	shr    %cl,%ebx
  8025e5:	89 da                	mov    %ebx,%edx
  8025e7:	83 c4 1c             	add    $0x1c,%esp
  8025ea:	5b                   	pop    %ebx
  8025eb:	5e                   	pop    %esi
  8025ec:	5f                   	pop    %edi
  8025ed:	5d                   	pop    %ebp
  8025ee:	c3                   	ret    
  8025ef:	90                   	nop
  8025f0:	89 fd                	mov    %edi,%ebp
  8025f2:	85 ff                	test   %edi,%edi
  8025f4:	75 0b                	jne    802601 <__umoddi3+0xe9>
  8025f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025fb:	31 d2                	xor    %edx,%edx
  8025fd:	f7 f7                	div    %edi
  8025ff:	89 c5                	mov    %eax,%ebp
  802601:	89 f0                	mov    %esi,%eax
  802603:	31 d2                	xor    %edx,%edx
  802605:	f7 f5                	div    %ebp
  802607:	89 c8                	mov    %ecx,%eax
  802609:	f7 f5                	div    %ebp
  80260b:	89 d0                	mov    %edx,%eax
  80260d:	e9 44 ff ff ff       	jmp    802556 <__umoddi3+0x3e>
  802612:	66 90                	xchg   %ax,%ax
  802614:	89 c8                	mov    %ecx,%eax
  802616:	89 f2                	mov    %esi,%edx
  802618:	83 c4 1c             	add    $0x1c,%esp
  80261b:	5b                   	pop    %ebx
  80261c:	5e                   	pop    %esi
  80261d:	5f                   	pop    %edi
  80261e:	5d                   	pop    %ebp
  80261f:	c3                   	ret    
  802620:	3b 04 24             	cmp    (%esp),%eax
  802623:	72 06                	jb     80262b <__umoddi3+0x113>
  802625:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802629:	77 0f                	ja     80263a <__umoddi3+0x122>
  80262b:	89 f2                	mov    %esi,%edx
  80262d:	29 f9                	sub    %edi,%ecx
  80262f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802633:	89 14 24             	mov    %edx,(%esp)
  802636:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80263a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80263e:	8b 14 24             	mov    (%esp),%edx
  802641:	83 c4 1c             	add    $0x1c,%esp
  802644:	5b                   	pop    %ebx
  802645:	5e                   	pop    %esi
  802646:	5f                   	pop    %edi
  802647:	5d                   	pop    %ebp
  802648:	c3                   	ret    
  802649:	8d 76 00             	lea    0x0(%esi),%esi
  80264c:	2b 04 24             	sub    (%esp),%eax
  80264f:	19 fa                	sbb    %edi,%edx
  802651:	89 d1                	mov    %edx,%ecx
  802653:	89 c6                	mov    %eax,%esi
  802655:	e9 71 ff ff ff       	jmp    8025cb <__umoddi3+0xb3>
  80265a:	66 90                	xchg   %ax,%ax
  80265c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802660:	72 ea                	jb     80264c <__umoddi3+0x134>
  802662:	89 d9                	mov    %ebx,%ecx
  802664:	e9 62 ff ff ff       	jmp    8025cb <__umoddi3+0xb3>
