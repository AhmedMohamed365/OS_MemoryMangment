
obj/user/tst_best_fit_1:     file format elf32-i386


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
  800031:	e8 fc 0a 00 00       	call   800b32 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 c4 28 00 00       	call   80290e <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 23                	jmp    80007d <_main+0x45>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 40 80 00       	mov    0x804020,%eax
  80005f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	c1 e2 04             	shl    $0x4,%edx
  80006b:	01 d0                	add    %edx,%eax
  80006d:	8a 40 04             	mov    0x4(%eax),%al
  800070:	84 c0                	test   %al,%al
  800072:	74 06                	je     80007a <_main+0x42>
			{
				fullWS = 0;
  800074:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800078:	eb 12                	jmp    80008c <_main+0x54>
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007a:	ff 45 f0             	incl   -0x10(%ebp)
  80007d:	a1 20 40 80 00       	mov    0x804020,%eax
  800082:	8b 50 74             	mov    0x74(%eax),%edx
  800085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800088:	39 c2                	cmp    %eax,%edx
  80008a:	77 ce                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80008c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800090:	74 14                	je     8000a6 <_main+0x6e>
  800092:	83 ec 04             	sub    $0x4,%esp
  800095:	68 e0 2b 80 00       	push   $0x802be0
  80009a:	6a 15                	push   $0x15
  80009c:	68 fc 2b 80 00       	push   $0x802bfc
  8000a1:	e8 d1 0b 00 00       	call   800c77 <_panic>
	}

	int Mega = 1024*1024;
  8000a6:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000ad:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000b4:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000b7:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c1:	89 d7                	mov    %edx,%edi
  8000c3:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8000c5:	e8 b0 23 00 00       	call   80247a <sys_calculate_free_frames>
  8000ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000cd:	e8 2b 24 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  8000d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(3*Mega-kilo);
  8000d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000d8:	89 c2                	mov    %eax,%edx
  8000da:	01 d2                	add    %edx,%edx
  8000dc:	01 d0                	add    %edx,%eax
  8000de:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000e1:	83 ec 0c             	sub    $0xc,%esp
  8000e4:	50                   	push   %eax
  8000e5:	e8 b9 1b 00 00       	call   801ca3 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8000f0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000f3:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000f8:	74 14                	je     80010e <_main+0xd6>
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 14 2c 80 00       	push   $0x802c14
  800102:	6a 23                	push   $0x23
  800104:	68 fc 2b 80 00       	push   $0x802bfc
  800109:	e8 69 0b 00 00       	call   800c77 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  80010e:	e8 ea 23 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800113:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800116:	3d 00 03 00 00       	cmp    $0x300,%eax
  80011b:	74 14                	je     800131 <_main+0xf9>
  80011d:	83 ec 04             	sub    $0x4,%esp
  800120:	68 44 2c 80 00       	push   $0x802c44
  800125:	6a 25                	push   $0x25
  800127:	68 fc 2b 80 00       	push   $0x802bfc
  80012c:	e8 46 0b 00 00       	call   800c77 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800131:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800134:	e8 41 23 00 00       	call   80247a <sys_calculate_free_frames>
  800139:	29 c3                	sub    %eax,%ebx
  80013b:	89 d8                	mov    %ebx,%eax
  80013d:	83 f8 01             	cmp    $0x1,%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 61 2c 80 00       	push   $0x802c61
  80014a:	6a 26                	push   $0x26
  80014c:	68 fc 2b 80 00       	push   $0x802bfc
  800151:	e8 21 0b 00 00       	call   800c77 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800156:	e8 1f 23 00 00       	call   80247a <sys_calculate_free_frames>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80015e:	e8 9a 23 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800163:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800169:	89 c2                	mov    %eax,%edx
  80016b:	01 d2                	add    %edx,%edx
  80016d:	01 d0                	add    %edx,%eax
  80016f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	50                   	push   %eax
  800176:	e8 28 1b 00 00       	call   801ca3 <malloc>
  80017b:	83 c4 10             	add    $0x10,%esp
  80017e:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  800181:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800184:	89 c1                	mov    %eax,%ecx
  800186:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800189:	89 c2                	mov    %eax,%edx
  80018b:	01 d2                	add    %edx,%edx
  80018d:	01 d0                	add    %edx,%eax
  80018f:	05 00 00 00 80       	add    $0x80000000,%eax
  800194:	39 c1                	cmp    %eax,%ecx
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 14 2c 80 00       	push   $0x802c14
  8001a0:	6a 2c                	push   $0x2c
  8001a2:	68 fc 2b 80 00       	push   $0x802bfc
  8001a7:	e8 cb 0a 00 00       	call   800c77 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  8001ac:	e8 4c 23 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  8001b1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001b4:	3d 00 03 00 00       	cmp    $0x300,%eax
  8001b9:	74 14                	je     8001cf <_main+0x197>
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	68 44 2c 80 00       	push   $0x802c44
  8001c3:	6a 2e                	push   $0x2e
  8001c5:	68 fc 2b 80 00       	push   $0x802bfc
  8001ca:	e8 a8 0a 00 00       	call   800c77 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001cf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001d2:	e8 a3 22 00 00       	call   80247a <sys_calculate_free_frames>
  8001d7:	29 c3                	sub    %eax,%ebx
  8001d9:	89 d8                	mov    %ebx,%eax
  8001db:	83 f8 01             	cmp    $0x1,%eax
  8001de:	74 14                	je     8001f4 <_main+0x1bc>
  8001e0:	83 ec 04             	sub    $0x4,%esp
  8001e3:	68 61 2c 80 00       	push   $0x802c61
  8001e8:	6a 2f                	push   $0x2f
  8001ea:	68 fc 2b 80 00       	push   $0x802bfc
  8001ef:	e8 83 0a 00 00       	call   800c77 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8001f4:	e8 81 22 00 00       	call   80247a <sys_calculate_free_frames>
  8001f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001fc:	e8 fc 22 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800201:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*Mega-kilo);
  800204:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800207:	01 c0                	add    %eax,%eax
  800209:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	50                   	push   %eax
  800210:	e8 8e 1a 00 00       	call   801ca3 <malloc>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80021b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80021e:	89 c1                	mov    %eax,%ecx
  800220:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800223:	89 d0                	mov    %edx,%eax
  800225:	01 c0                	add    %eax,%eax
  800227:	01 d0                	add    %edx,%eax
  800229:	01 c0                	add    %eax,%eax
  80022b:	05 00 00 00 80       	add    $0x80000000,%eax
  800230:	39 c1                	cmp    %eax,%ecx
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 14 2c 80 00       	push   $0x802c14
  80023c:	6a 35                	push   $0x35
  80023e:	68 fc 2b 80 00       	push   $0x802bfc
  800243:	e8 2f 0a 00 00       	call   800c77 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800248:	e8 b0 22 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  80024d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800250:	3d 00 02 00 00       	cmp    $0x200,%eax
  800255:	74 14                	je     80026b <_main+0x233>
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	68 44 2c 80 00       	push   $0x802c44
  80025f:	6a 37                	push   $0x37
  800261:	68 fc 2b 80 00       	push   $0x802bfc
  800266:	e8 0c 0a 00 00       	call   800c77 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80026b:	e8 0a 22 00 00       	call   80247a <sys_calculate_free_frames>
  800270:	89 c2                	mov    %eax,%edx
  800272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800275:	39 c2                	cmp    %eax,%edx
  800277:	74 14                	je     80028d <_main+0x255>
  800279:	83 ec 04             	sub    $0x4,%esp
  80027c:	68 61 2c 80 00       	push   $0x802c61
  800281:	6a 38                	push   $0x38
  800283:	68 fc 2b 80 00       	push   $0x802bfc
  800288:	e8 ea 09 00 00       	call   800c77 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80028d:	e8 e8 21 00 00       	call   80247a <sys_calculate_free_frames>
  800292:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800295:	e8 63 22 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  80029a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*Mega-kilo);
  80029d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002a0:	01 c0                	add    %eax,%eax
  8002a2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	50                   	push   %eax
  8002a9:	e8 f5 19 00 00       	call   801ca3 <malloc>
  8002ae:	83 c4 10             	add    $0x10,%esp
  8002b1:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8002b4:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002b7:	89 c2                	mov    %eax,%edx
  8002b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002bc:	c1 e0 03             	shl    $0x3,%eax
  8002bf:	05 00 00 00 80       	add    $0x80000000,%eax
  8002c4:	39 c2                	cmp    %eax,%edx
  8002c6:	74 14                	je     8002dc <_main+0x2a4>
  8002c8:	83 ec 04             	sub    $0x4,%esp
  8002cb:	68 14 2c 80 00       	push   $0x802c14
  8002d0:	6a 3e                	push   $0x3e
  8002d2:	68 fc 2b 80 00       	push   $0x802bfc
  8002d7:	e8 9b 09 00 00       	call   800c77 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  8002dc:	e8 1c 22 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  8002e1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002e4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 44 2c 80 00       	push   $0x802c44
  8002f3:	6a 40                	push   $0x40
  8002f5:	68 fc 2b 80 00       	push   $0x802bfc
  8002fa:	e8 78 09 00 00       	call   800c77 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8002ff:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800302:	e8 73 21 00 00       	call   80247a <sys_calculate_free_frames>
  800307:	29 c3                	sub    %eax,%ebx
  800309:	89 d8                	mov    %ebx,%eax
  80030b:	83 f8 01             	cmp    $0x1,%eax
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 61 2c 80 00       	push   $0x802c61
  800318:	6a 41                	push   $0x41
  80031a:	68 fc 2b 80 00       	push   $0x802bfc
  80031f:	e8 53 09 00 00       	call   800c77 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800324:	e8 51 21 00 00       	call   80247a <sys_calculate_free_frames>
  800329:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80032c:	e8 cc 21 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800331:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(1*Mega-kilo);
  800334:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800337:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80033a:	83 ec 0c             	sub    $0xc,%esp
  80033d:	50                   	push   %eax
  80033e:	e8 60 19 00 00       	call   801ca3 <malloc>
  800343:	83 c4 10             	add    $0x10,%esp
  800346:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 10*Mega) ) panic("Wrong start address for the allocated space... ");
  800349:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80034c:	89 c1                	mov    %eax,%ecx
  80034e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800351:	89 d0                	mov    %edx,%eax
  800353:	c1 e0 02             	shl    $0x2,%eax
  800356:	01 d0                	add    %edx,%eax
  800358:	01 c0                	add    %eax,%eax
  80035a:	05 00 00 00 80       	add    $0x80000000,%eax
  80035f:	39 c1                	cmp    %eax,%ecx
  800361:	74 14                	je     800377 <_main+0x33f>
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 14 2c 80 00       	push   $0x802c14
  80036b:	6a 47                	push   $0x47
  80036d:	68 fc 2b 80 00       	push   $0x802bfc
  800372:	e8 00 09 00 00       	call   800c77 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800377:	e8 81 21 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  80037c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80037f:	3d 00 01 00 00       	cmp    $0x100,%eax
  800384:	74 14                	je     80039a <_main+0x362>
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 44 2c 80 00       	push   $0x802c44
  80038e:	6a 49                	push   $0x49
  800390:	68 fc 2b 80 00       	push   $0x802bfc
  800395:	e8 dd 08 00 00       	call   800c77 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80039a:	e8 db 20 00 00       	call   80247a <sys_calculate_free_frames>
  80039f:	89 c2                	mov    %eax,%edx
  8003a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <_main+0x384>
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 61 2c 80 00       	push   $0x802c61
  8003b0:	6a 4a                	push   $0x4a
  8003b2:	68 fc 2b 80 00       	push   $0x802bfc
  8003b7:	e8 bb 08 00 00       	call   800c77 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8003bc:	e8 b9 20 00 00       	call   80247a <sys_calculate_free_frames>
  8003c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003c4:	e8 34 21 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  8003c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(1*Mega-kilo);
  8003cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003cf:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003d2:	83 ec 0c             	sub    $0xc,%esp
  8003d5:	50                   	push   %eax
  8003d6:	e8 c8 18 00 00       	call   801ca3 <malloc>
  8003db:	83 c4 10             	add    $0x10,%esp
  8003de:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 11*Mega) ) panic("Wrong start address for the allocated space... ");
  8003e1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e4:	89 c1                	mov    %eax,%ecx
  8003e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003e9:	89 d0                	mov    %edx,%eax
  8003eb:	c1 e0 02             	shl    $0x2,%eax
  8003ee:	01 d0                	add    %edx,%eax
  8003f0:	01 c0                	add    %eax,%eax
  8003f2:	01 d0                	add    %edx,%eax
  8003f4:	05 00 00 00 80       	add    $0x80000000,%eax
  8003f9:	39 c1                	cmp    %eax,%ecx
  8003fb:	74 14                	je     800411 <_main+0x3d9>
  8003fd:	83 ec 04             	sub    $0x4,%esp
  800400:	68 14 2c 80 00       	push   $0x802c14
  800405:	6a 50                	push   $0x50
  800407:	68 fc 2b 80 00       	push   $0x802bfc
  80040c:	e8 66 08 00 00       	call   800c77 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800411:	e8 e7 20 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800416:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800419:	3d 00 01 00 00       	cmp    $0x100,%eax
  80041e:	74 14                	je     800434 <_main+0x3fc>
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	68 44 2c 80 00       	push   $0x802c44
  800428:	6a 52                	push   $0x52
  80042a:	68 fc 2b 80 00       	push   $0x802bfc
  80042f:	e8 43 08 00 00       	call   800c77 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800434:	e8 41 20 00 00       	call   80247a <sys_calculate_free_frames>
  800439:	89 c2                	mov    %eax,%edx
  80043b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80043e:	39 c2                	cmp    %eax,%edx
  800440:	74 14                	je     800456 <_main+0x41e>
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	68 61 2c 80 00       	push   $0x802c61
  80044a:	6a 53                	push   $0x53
  80044c:	68 fc 2b 80 00       	push   $0x802bfc
  800451:	e8 21 08 00 00       	call   800c77 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800456:	e8 1f 20 00 00       	call   80247a <sys_calculate_free_frames>
  80045b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80045e:	e8 9a 20 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800463:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(1*Mega-kilo);
  800466:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800469:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80046c:	83 ec 0c             	sub    $0xc,%esp
  80046f:	50                   	push   %eax
  800470:	e8 2e 18 00 00       	call   801ca3 <malloc>
  800475:	83 c4 10             	add    $0x10,%esp
  800478:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 12*Mega) ) panic("Wrong start address for the allocated space... ");
  80047b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80047e:	89 c1                	mov    %eax,%ecx
  800480:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800483:	89 d0                	mov    %edx,%eax
  800485:	01 c0                	add    %eax,%eax
  800487:	01 d0                	add    %edx,%eax
  800489:	c1 e0 02             	shl    $0x2,%eax
  80048c:	05 00 00 00 80       	add    $0x80000000,%eax
  800491:	39 c1                	cmp    %eax,%ecx
  800493:	74 14                	je     8004a9 <_main+0x471>
  800495:	83 ec 04             	sub    $0x4,%esp
  800498:	68 14 2c 80 00       	push   $0x802c14
  80049d:	6a 59                	push   $0x59
  80049f:	68 fc 2b 80 00       	push   $0x802bfc
  8004a4:	e8 ce 07 00 00       	call   800c77 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8004a9:	e8 4f 20 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  8004ae:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004b1:	3d 00 01 00 00       	cmp    $0x100,%eax
  8004b6:	74 14                	je     8004cc <_main+0x494>
  8004b8:	83 ec 04             	sub    $0x4,%esp
  8004bb:	68 44 2c 80 00       	push   $0x802c44
  8004c0:	6a 5b                	push   $0x5b
  8004c2:	68 fc 2b 80 00       	push   $0x802bfc
  8004c7:	e8 ab 07 00 00       	call   800c77 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004cc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004cf:	e8 a6 1f 00 00       	call   80247a <sys_calculate_free_frames>
  8004d4:	29 c3                	sub    %eax,%ebx
  8004d6:	89 d8                	mov    %ebx,%eax
  8004d8:	83 f8 01             	cmp    $0x1,%eax
  8004db:	74 14                	je     8004f1 <_main+0x4b9>
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	68 61 2c 80 00       	push   $0x802c61
  8004e5:	6a 5c                	push   $0x5c
  8004e7:	68 fc 2b 80 00       	push   $0x802bfc
  8004ec:	e8 86 07 00 00       	call   800c77 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8004f1:	e8 84 1f 00 00       	call   80247a <sys_calculate_free_frames>
  8004f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f9:	e8 ff 1f 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  8004fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(1*Mega-kilo);
  800501:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800504:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800507:	83 ec 0c             	sub    $0xc,%esp
  80050a:	50                   	push   %eax
  80050b:	e8 93 17 00 00       	call   801ca3 <malloc>
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 13*Mega)) panic("Wrong start address for the allocated space... ");
  800516:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800519:	89 c1                	mov    %eax,%ecx
  80051b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051e:	89 d0                	mov    %edx,%eax
  800520:	01 c0                	add    %eax,%eax
  800522:	01 d0                	add    %edx,%eax
  800524:	c1 e0 02             	shl    $0x2,%eax
  800527:	01 d0                	add    %edx,%eax
  800529:	05 00 00 00 80       	add    $0x80000000,%eax
  80052e:	39 c1                	cmp    %eax,%ecx
  800530:	74 14                	je     800546 <_main+0x50e>
  800532:	83 ec 04             	sub    $0x4,%esp
  800535:	68 14 2c 80 00       	push   $0x802c14
  80053a:	6a 62                	push   $0x62
  80053c:	68 fc 2b 80 00       	push   $0x802bfc
  800541:	e8 31 07 00 00       	call   800c77 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800546:	e8 b2 1f 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  80054b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80054e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800553:	74 14                	je     800569 <_main+0x531>
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	68 44 2c 80 00       	push   $0x802c44
  80055d:	6a 64                	push   $0x64
  80055f:	68 fc 2b 80 00       	push   $0x802bfc
  800564:	e8 0e 07 00 00       	call   800c77 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800569:	e8 0c 1f 00 00       	call   80247a <sys_calculate_free_frames>
  80056e:	89 c2                	mov    %eax,%edx
  800570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800573:	39 c2                	cmp    %eax,%edx
  800575:	74 14                	je     80058b <_main+0x553>
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	68 61 2c 80 00       	push   $0x802c61
  80057f:	6a 65                	push   $0x65
  800581:	68 fc 2b 80 00       	push   $0x802bfc
  800586:	e8 ec 06 00 00       	call   800c77 <_panic>
	}

	//[2] Free some to create holes
	{
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 ea 1e 00 00       	call   80247a <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 65 1f 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  80059b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 b7 1b 00 00       	call   80215e <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  3*256) panic("Wrong page file free: ");
  8005aa:	e8 4e 1f 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005bb:	74 14                	je     8005d1 <_main+0x599>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 74 2c 80 00       	push   $0x802c74
  8005c5:	6a 6f                	push   $0x6f
  8005c7:	68 fc 2b 80 00       	push   $0x802bfc
  8005cc:	e8 a6 06 00 00       	call   800c77 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005d1:	e8 a4 1e 00 00       	call   80247a <sys_calculate_free_frames>
  8005d6:	89 c2                	mov    %eax,%edx
  8005d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005db:	39 c2                	cmp    %eax,%edx
  8005dd:	74 14                	je     8005f3 <_main+0x5bb>
  8005df:	83 ec 04             	sub    $0x4,%esp
  8005e2:	68 8b 2c 80 00       	push   $0x802c8b
  8005e7:	6a 70                	push   $0x70
  8005e9:	68 fc 2b 80 00       	push   $0x802bfc
  8005ee:	e8 84 06 00 00       	call   800c77 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005f3:	e8 82 1e 00 00       	call   80247a <sys_calculate_free_frames>
  8005f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005fb:	e8 fd 1e 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800600:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800603:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800606:	83 ec 0c             	sub    $0xc,%esp
  800609:	50                   	push   %eax
  80060a:	e8 4f 1b 00 00       	call   80215e <free>
  80060f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  2*256) panic("Wrong page file free: ");
  800612:	e8 e6 1e 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800617:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80061a:	29 c2                	sub    %eax,%edx
  80061c:	89 d0                	mov    %edx,%eax
  80061e:	3d 00 02 00 00       	cmp    $0x200,%eax
  800623:	74 14                	je     800639 <_main+0x601>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 74 2c 80 00       	push   $0x802c74
  80062d:	6a 77                	push   $0x77
  80062f:	68 fc 2b 80 00       	push   $0x802bfc
  800634:	e8 3e 06 00 00       	call   800c77 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800639:	e8 3c 1e 00 00       	call   80247a <sys_calculate_free_frames>
  80063e:	89 c2                	mov    %eax,%edx
  800640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800643:	39 c2                	cmp    %eax,%edx
  800645:	74 14                	je     80065b <_main+0x623>
  800647:	83 ec 04             	sub    $0x4,%esp
  80064a:	68 8b 2c 80 00       	push   $0x802c8b
  80064f:	6a 78                	push   $0x78
  800651:	68 fc 2b 80 00       	push   $0x802bfc
  800656:	e8 1c 06 00 00       	call   800c77 <_panic>

		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80065b:	e8 1a 1e 00 00       	call   80247a <sys_calculate_free_frames>
  800660:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800663:	e8 95 1e 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800668:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80066b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80066e:	83 ec 0c             	sub    $0xc,%esp
  800671:	50                   	push   %eax
  800672:	e8 e7 1a 00 00       	call   80215e <free>
  800677:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80067a:	e8 7e 1e 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  80067f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800682:	29 c2                	sub    %eax,%edx
  800684:	89 d0                	mov    %edx,%eax
  800686:	3d 00 01 00 00       	cmp    $0x100,%eax
  80068b:	74 14                	je     8006a1 <_main+0x669>
  80068d:	83 ec 04             	sub    $0x4,%esp
  800690:	68 74 2c 80 00       	push   $0x802c74
  800695:	6a 7f                	push   $0x7f
  800697:	68 fc 2b 80 00       	push   $0x802bfc
  80069c:	e8 d6 05 00 00       	call   800c77 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006a1:	e8 d4 1d 00 00       	call   80247a <sys_calculate_free_frames>
  8006a6:	89 c2                	mov    %eax,%edx
  8006a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ab:	39 c2                	cmp    %eax,%edx
  8006ad:	74 17                	je     8006c6 <_main+0x68e>
  8006af:	83 ec 04             	sub    $0x4,%esp
  8006b2:	68 8b 2c 80 00       	push   $0x802c8b
  8006b7:	68 80 00 00 00       	push   $0x80
  8006bc:	68 fc 2b 80 00       	push   $0x802bfc
  8006c1:	e8 b1 05 00 00       	call   800c77 <_panic>
	}

	//[3] Allocate again [test best fit]
	{
		//Allocate 512 KB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8006c6:	e8 af 1d 00 00       	call   80247a <sys_calculate_free_frames>
  8006cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ce:	e8 2a 1e 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  8006d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo);
  8006d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006d9:	c1 e0 09             	shl    $0x9,%eax
  8006dc:	83 ec 0c             	sub    $0xc,%esp
  8006df:	50                   	push   %eax
  8006e0:	e8 be 15 00 00       	call   801ca3 <malloc>
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	89 45 b0             	mov    %eax,-0x50(%ebp)
		cprintf("address: %x",USER_HEAP_START + 11*Mega);
  8006eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006ee:	89 d0                	mov    %edx,%eax
  8006f0:	c1 e0 02             	shl    $0x2,%eax
  8006f3:	01 d0                	add    %edx,%eax
  8006f5:	01 c0                	add    %eax,%eax
  8006f7:	01 d0                	add    %edx,%eax
  8006f9:	05 00 00 00 80       	add    $0x80000000,%eax
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	50                   	push   %eax
  800702:	68 98 2c 80 00       	push   $0x802c98
  800707:	e8 0d 08 00 00       	call   800f19 <cprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  80070f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800712:	89 c1                	mov    %eax,%ecx
  800714:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800717:	89 d0                	mov    %edx,%eax
  800719:	c1 e0 02             	shl    $0x2,%eax
  80071c:	01 d0                	add    %edx,%eax
  80071e:	01 c0                	add    %eax,%eax
  800720:	01 d0                	add    %edx,%eax
  800722:	05 00 00 00 80       	add    $0x80000000,%eax
  800727:	39 c1                	cmp    %eax,%ecx
  800729:	74 17                	je     800742 <_main+0x70a>
  80072b:	83 ec 04             	sub    $0x4,%esp
  80072e:	68 14 2c 80 00       	push   $0x802c14
  800733:	68 8a 00 00 00       	push   $0x8a
  800738:	68 fc 2b 80 00       	push   $0x802bfc
  80073d:	e8 35 05 00 00       	call   800c77 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800742:	e8 b6 1d 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800747:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80074a:	3d 80 00 00 00       	cmp    $0x80,%eax
  80074f:	74 17                	je     800768 <_main+0x730>
  800751:	83 ec 04             	sub    $0x4,%esp
  800754:	68 44 2c 80 00       	push   $0x802c44
  800759:	68 8c 00 00 00       	push   $0x8c
  80075e:	68 fc 2b 80 00       	push   $0x802bfc
  800763:	e8 0f 05 00 00       	call   800c77 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800768:	e8 0d 1d 00 00       	call   80247a <sys_calculate_free_frames>
  80076d:	89 c2                	mov    %eax,%edx
  80076f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800772:	39 c2                	cmp    %eax,%edx
  800774:	74 17                	je     80078d <_main+0x755>
  800776:	83 ec 04             	sub    $0x4,%esp
  800779:	68 61 2c 80 00       	push   $0x802c61
  80077e:	68 8d 00 00 00       	push   $0x8d
  800783:	68 fc 2b 80 00       	push   $0x802bfc
  800788:	e8 ea 04 00 00       	call   800c77 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80078d:	e8 e8 1c 00 00       	call   80247a <sys_calculate_free_frames>
  800792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800795:	e8 63 1d 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  80079a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80079d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a0:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8007a3:	83 ec 0c             	sub    $0xc,%esp
  8007a6:	50                   	push   %eax
  8007a7:	e8 f7 14 00 00       	call   801ca3 <malloc>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		cprintf("address: %x",USER_HEAP_START + 8*Mega);
  8007b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b5:	c1 e0 03             	shl    $0x3,%eax
  8007b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	50                   	push   %eax
  8007c1:	68 98 2c 80 00       	push   $0x802c98
  8007c6:	e8 4e 07 00 00       	call   800f19 <cprintf>
  8007cb:	83 c4 10             	add    $0x10,%esp
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8007ce:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007d1:	89 c2                	mov    %eax,%edx
  8007d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007d6:	c1 e0 03             	shl    $0x3,%eax
  8007d9:	05 00 00 00 80       	add    $0x80000000,%eax
  8007de:	39 c2                	cmp    %eax,%edx
  8007e0:	74 17                	je     8007f9 <_main+0x7c1>
  8007e2:	83 ec 04             	sub    $0x4,%esp
  8007e5:	68 14 2c 80 00       	push   $0x802c14
  8007ea:	68 94 00 00 00       	push   $0x94
  8007ef:	68 fc 2b 80 00       	push   $0x802bfc
  8007f4:	e8 7e 04 00 00       	call   800c77 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007f9:	e8 ff 1c 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  8007fe:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800801:	3d 00 01 00 00       	cmp    $0x100,%eax
  800806:	74 17                	je     80081f <_main+0x7e7>
  800808:	83 ec 04             	sub    $0x4,%esp
  80080b:	68 44 2c 80 00       	push   $0x802c44
  800810:	68 96 00 00 00       	push   $0x96
  800815:	68 fc 2b 80 00       	push   $0x802bfc
  80081a:	e8 58 04 00 00       	call   800c77 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80081f:	e8 56 1c 00 00       	call   80247a <sys_calculate_free_frames>
  800824:	89 c2                	mov    %eax,%edx
  800826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800829:	39 c2                	cmp    %eax,%edx
  80082b:	74 17                	je     800844 <_main+0x80c>
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	68 61 2c 80 00       	push   $0x802c61
  800835:	68 97 00 00 00       	push   $0x97
  80083a:	68 fc 2b 80 00       	push   $0x802bfc
  80083f:	e8 33 04 00 00       	call   800c77 <_panic>

		//Allocate 256 KB - should be placed in remaining of 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800844:	e8 31 1c 00 00       	call   80247a <sys_calculate_free_frames>
  800849:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80084c:	e8 ac 1c 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800851:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  800854:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800857:	89 d0                	mov    %edx,%eax
  800859:	c1 e0 08             	shl    $0x8,%eax
  80085c:	29 d0                	sub    %edx,%eax
  80085e:	83 ec 0c             	sub    $0xc,%esp
  800861:	50                   	push   %eax
  800862:	e8 3c 14 00 00       	call   801ca3 <malloc>
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 11*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  80086d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800870:	89 c1                	mov    %eax,%ecx
  800872:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800875:	89 d0                	mov    %edx,%eax
  800877:	c1 e0 02             	shl    $0x2,%eax
  80087a:	01 d0                	add    %edx,%eax
  80087c:	01 c0                	add    %eax,%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	89 c2                	mov    %eax,%edx
  800882:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800885:	c1 e0 09             	shl    $0x9,%eax
  800888:	01 d0                	add    %edx,%eax
  80088a:	05 00 00 00 80       	add    $0x80000000,%eax
  80088f:	39 c1                	cmp    %eax,%ecx
  800891:	74 17                	je     8008aa <_main+0x872>
  800893:	83 ec 04             	sub    $0x4,%esp
  800896:	68 14 2c 80 00       	push   $0x802c14
  80089b:	68 9d 00 00 00       	push   $0x9d
  8008a0:	68 fc 2b 80 00       	push   $0x802bfc
  8008a5:	e8 cd 03 00 00       	call   800c77 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  8008aa:	e8 4e 1c 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  8008af:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008b2:	83 f8 40             	cmp    $0x40,%eax
  8008b5:	74 17                	je     8008ce <_main+0x896>
  8008b7:	83 ec 04             	sub    $0x4,%esp
  8008ba:	68 44 2c 80 00       	push   $0x802c44
  8008bf:	68 9f 00 00 00       	push   $0x9f
  8008c4:	68 fc 2b 80 00       	push   $0x802bfc
  8008c9:	e8 a9 03 00 00       	call   800c77 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008ce:	e8 a7 1b 00 00       	call   80247a <sys_calculate_free_frames>
  8008d3:	89 c2                	mov    %eax,%edx
  8008d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008d8:	39 c2                	cmp    %eax,%edx
  8008da:	74 17                	je     8008f3 <_main+0x8bb>
  8008dc:	83 ec 04             	sub    $0x4,%esp
  8008df:	68 61 2c 80 00       	push   $0x802c61
  8008e4:	68 a0 00 00 00       	push   $0xa0
  8008e9:	68 fc 2b 80 00       	push   $0x802bfc
  8008ee:	e8 84 03 00 00       	call   800c77 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008f3:	e8 82 1b 00 00       	call   80247a <sys_calculate_free_frames>
  8008f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008fb:	e8 fd 1b 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800900:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega - kilo);
  800903:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800906:	c1 e0 02             	shl    $0x2,%eax
  800909:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80090c:	83 ec 0c             	sub    $0xc,%esp
  80090f:	50                   	push   %eax
  800910:	e8 8e 13 00 00       	call   801ca3 <malloc>
  800915:	83 c4 10             	add    $0x10,%esp
  800918:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80091b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80091e:	89 c1                	mov    %eax,%ecx
  800920:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800923:	89 d0                	mov    %edx,%eax
  800925:	01 c0                	add    %eax,%eax
  800927:	01 d0                	add    %edx,%eax
  800929:	01 c0                	add    %eax,%eax
  80092b:	01 d0                	add    %edx,%eax
  80092d:	01 c0                	add    %eax,%eax
  80092f:	05 00 00 00 80       	add    $0x80000000,%eax
  800934:	39 c1                	cmp    %eax,%ecx
  800936:	74 17                	je     80094f <_main+0x917>
  800938:	83 ec 04             	sub    $0x4,%esp
  80093b:	68 14 2c 80 00       	push   $0x802c14
  800940:	68 a6 00 00 00       	push   $0xa6
  800945:	68 fc 2b 80 00       	push   $0x802bfc
  80094a:	e8 28 03 00 00       	call   800c77 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  80094f:	e8 a9 1b 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800954:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800957:	3d 00 04 00 00       	cmp    $0x400,%eax
  80095c:	74 17                	je     800975 <_main+0x93d>
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 44 2c 80 00       	push   $0x802c44
  800966:	68 a8 00 00 00       	push   $0xa8
  80096b:	68 fc 2b 80 00       	push   $0x802bfc
  800970:	e8 02 03 00 00       	call   800c77 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  800975:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800978:	e8 fd 1a 00 00       	call   80247a <sys_calculate_free_frames>
  80097d:	29 c3                	sub    %eax,%ebx
  80097f:	89 d8                	mov    %ebx,%eax
  800981:	83 f8 01             	cmp    $0x1,%eax
  800984:	74 17                	je     80099d <_main+0x965>
  800986:	83 ec 04             	sub    $0x4,%esp
  800989:	68 61 2c 80 00       	push   $0x802c61
  80098e:	68 a9 00 00 00       	push   $0xa9
  800993:	68 fc 2b 80 00       	push   $0x802bfc
  800998:	e8 da 02 00 00       	call   800c77 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1M Hole appended to already existing 1M hole in the middle
		freeFrames = sys_calculate_free_frames() ;
  80099d:	e8 d8 1a 00 00       	call   80247a <sys_calculate_free_frames>
  8009a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009a5:	e8 53 1b 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  8009aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  8009ad:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8009b0:	83 ec 0c             	sub    $0xc,%esp
  8009b3:	50                   	push   %eax
  8009b4:	e8 a5 17 00 00       	call   80215e <free>
  8009b9:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  8009bc:	e8 3c 1b 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  8009c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c4:	29 c2                	sub    %eax,%edx
  8009c6:	89 d0                	mov    %edx,%eax
  8009c8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8009cd:	74 17                	je     8009e6 <_main+0x9ae>
  8009cf:	83 ec 04             	sub    $0x4,%esp
  8009d2:	68 74 2c 80 00       	push   $0x802c74
  8009d7:	68 b3 00 00 00       	push   $0xb3
  8009dc:	68 fc 2b 80 00       	push   $0x802bfc
  8009e1:	e8 91 02 00 00       	call   800c77 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009e6:	e8 8f 1a 00 00       	call   80247a <sys_calculate_free_frames>
  8009eb:	89 c2                	mov    %eax,%edx
  8009ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009f0:	39 c2                	cmp    %eax,%edx
  8009f2:	74 17                	je     800a0b <_main+0x9d3>
  8009f4:	83 ec 04             	sub    $0x4,%esp
  8009f7:	68 8b 2c 80 00       	push   $0x802c8b
  8009fc:	68 b4 00 00 00       	push   $0xb4
  800a01:	68 fc 2b 80 00       	push   $0x802bfc
  800a06:	e8 6c 02 00 00       	call   800c77 <_panic>

		//another 512 KB Hole appended to the hole
		freeFrames = sys_calculate_free_frames() ;
  800a0b:	e8 6a 1a 00 00       	call   80247a <sys_calculate_free_frames>
  800a10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a13:	e8 e5 1a 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800a18:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[8]);
  800a1b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800a1e:	83 ec 0c             	sub    $0xc,%esp
  800a21:	50                   	push   %eax
  800a22:	e8 37 17 00 00       	call   80215e <free>
  800a27:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  128) panic("Wrong page file free: ");
  800a2a:	e8 ce 1a 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800a2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a32:	29 c2                	sub    %eax,%edx
  800a34:	89 d0                	mov    %edx,%eax
  800a36:	3d 80 00 00 00       	cmp    $0x80,%eax
  800a3b:	74 17                	je     800a54 <_main+0xa1c>
  800a3d:	83 ec 04             	sub    $0x4,%esp
  800a40:	68 74 2c 80 00       	push   $0x802c74
  800a45:	68 bb 00 00 00       	push   $0xbb
  800a4a:	68 fc 2b 80 00       	push   $0x802bfc
  800a4f:	e8 23 02 00 00       	call   800c77 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a54:	e8 21 1a 00 00       	call   80247a <sys_calculate_free_frames>
  800a59:	89 c2                	mov    %eax,%edx
  800a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a5e:	39 c2                	cmp    %eax,%edx
  800a60:	74 17                	je     800a79 <_main+0xa41>
  800a62:	83 ec 04             	sub    $0x4,%esp
  800a65:	68 8b 2c 80 00       	push   $0x802c8b
  800a6a:	68 bc 00 00 00       	push   $0xbc
  800a6f:	68 fc 2b 80 00       	push   $0x802bfc
  800a74:	e8 fe 01 00 00       	call   800c77 <_panic>
	}

	//[5] Allocate again [test best fit]
	{
		//Allocate 2 MB - should be placed in the contiguous hole (2 MB + 512 KB)
		freeFrames = sys_calculate_free_frames();
  800a79:	e8 fc 19 00 00       	call   80247a <sys_calculate_free_frames>
  800a7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a81:	e8 77 1a 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800a86:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(2*Mega - kilo);
  800a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a8c:	01 c0                	add    %eax,%eax
  800a8e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800a91:	83 ec 0c             	sub    $0xc,%esp
  800a94:	50                   	push   %eax
  800a95:	e8 09 12 00 00       	call   801ca3 <malloc>
  800a9a:	83 c4 10             	add    $0x10,%esp
  800a9d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 9*Mega)) panic("Wrong start address for the allocated space... ");
  800aa0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800aa3:	89 c1                	mov    %eax,%ecx
  800aa5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800aa8:	89 d0                	mov    %edx,%eax
  800aaa:	c1 e0 03             	shl    $0x3,%eax
  800aad:	01 d0                	add    %edx,%eax
  800aaf:	05 00 00 00 80       	add    $0x80000000,%eax
  800ab4:	39 c1                	cmp    %eax,%ecx
  800ab6:	74 17                	je     800acf <_main+0xa97>
  800ab8:	83 ec 04             	sub    $0x4,%esp
  800abb:	68 14 2c 80 00       	push   $0x802c14
  800ac0:	68 c5 00 00 00       	push   $0xc5
  800ac5:	68 fc 2b 80 00       	push   $0x802bfc
  800aca:	e8 a8 01 00 00       	call   800c77 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800acf:	e8 29 1a 00 00       	call   8024fd <sys_pf_calculate_allocated_pages>
  800ad4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800ad7:	3d 00 02 00 00       	cmp    $0x200,%eax
  800adc:	74 17                	je     800af5 <_main+0xabd>
  800ade:	83 ec 04             	sub    $0x4,%esp
  800ae1:	68 44 2c 80 00       	push   $0x802c44
  800ae6:	68 c7 00 00 00       	push   $0xc7
  800aeb:	68 fc 2b 80 00       	push   $0x802bfc
  800af0:	e8 82 01 00 00       	call   800c77 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800af5:	e8 80 19 00 00       	call   80247a <sys_calculate_free_frames>
  800afa:	89 c2                	mov    %eax,%edx
  800afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800aff:	39 c2                	cmp    %eax,%edx
  800b01:	74 17                	je     800b1a <_main+0xae2>
  800b03:	83 ec 04             	sub    $0x4,%esp
  800b06:	68 61 2c 80 00       	push   $0x802c61
  800b0b:	68 c8 00 00 00       	push   $0xc8
  800b10:	68 fc 2b 80 00       	push   $0x802bfc
  800b15:	e8 5d 01 00 00       	call   800c77 <_panic>
	}
	cprintf("Congratulations!! test BEST FIT allocation (1) completed successfully.\n");
  800b1a:	83 ec 0c             	sub    $0xc,%esp
  800b1d:	68 a4 2c 80 00       	push   $0x802ca4
  800b22:	e8 f2 03 00 00       	call   800f19 <cprintf>
  800b27:	83 c4 10             	add    $0x10,%esp

	return;
  800b2a:	90                   	nop
}
  800b2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b2e:	5b                   	pop    %ebx
  800b2f:	5f                   	pop    %edi
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b38:	e8 72 18 00 00       	call   8023af <sys_getenvindex>
  800b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b43:	89 d0                	mov    %edx,%eax
  800b45:	c1 e0 03             	shl    $0x3,%eax
  800b48:	01 d0                	add    %edx,%eax
  800b4a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800b51:	01 c8                	add    %ecx,%eax
  800b53:	01 c0                	add    %eax,%eax
  800b55:	01 d0                	add    %edx,%eax
  800b57:	01 c0                	add    %eax,%eax
  800b59:	01 d0                	add    %edx,%eax
  800b5b:	89 c2                	mov    %eax,%edx
  800b5d:	c1 e2 05             	shl    $0x5,%edx
  800b60:	29 c2                	sub    %eax,%edx
  800b62:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800b69:	89 c2                	mov    %eax,%edx
  800b6b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800b71:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b76:	a1 20 40 80 00       	mov    0x804020,%eax
  800b7b:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800b81:	84 c0                	test   %al,%al
  800b83:	74 0f                	je     800b94 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800b85:	a1 20 40 80 00       	mov    0x804020,%eax
  800b8a:	05 40 3c 01 00       	add    $0x13c40,%eax
  800b8f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b98:	7e 0a                	jle    800ba4 <libmain+0x72>
		binaryname = argv[0];
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800ba4:	83 ec 08             	sub    $0x8,%esp
  800ba7:	ff 75 0c             	pushl  0xc(%ebp)
  800baa:	ff 75 08             	pushl  0x8(%ebp)
  800bad:	e8 86 f4 ff ff       	call   800038 <_main>
  800bb2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bb5:	e8 90 19 00 00       	call   80254a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bba:	83 ec 0c             	sub    $0xc,%esp
  800bbd:	68 04 2d 80 00       	push   $0x802d04
  800bc2:	e8 52 03 00 00       	call   800f19 <cprintf>
  800bc7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bca:	a1 20 40 80 00       	mov    0x804020,%eax
  800bcf:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800bd5:	a1 20 40 80 00       	mov    0x804020,%eax
  800bda:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800be0:	83 ec 04             	sub    $0x4,%esp
  800be3:	52                   	push   %edx
  800be4:	50                   	push   %eax
  800be5:	68 2c 2d 80 00       	push   $0x802d2c
  800bea:	e8 2a 03 00 00       	call   800f19 <cprintf>
  800bef:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800bf2:	a1 20 40 80 00       	mov    0x804020,%eax
  800bf7:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800bfd:	a1 20 40 80 00       	mov    0x804020,%eax
  800c02:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800c08:	83 ec 04             	sub    $0x4,%esp
  800c0b:	52                   	push   %edx
  800c0c:	50                   	push   %eax
  800c0d:	68 54 2d 80 00       	push   $0x802d54
  800c12:	e8 02 03 00 00       	call   800f19 <cprintf>
  800c17:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c1a:	a1 20 40 80 00       	mov    0x804020,%eax
  800c1f:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800c25:	83 ec 08             	sub    $0x8,%esp
  800c28:	50                   	push   %eax
  800c29:	68 95 2d 80 00       	push   $0x802d95
  800c2e:	e8 e6 02 00 00       	call   800f19 <cprintf>
  800c33:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c36:	83 ec 0c             	sub    $0xc,%esp
  800c39:	68 04 2d 80 00       	push   $0x802d04
  800c3e:	e8 d6 02 00 00       	call   800f19 <cprintf>
  800c43:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c46:	e8 19 19 00 00       	call   802564 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c4b:	e8 19 00 00 00       	call   800c69 <exit>
}
  800c50:	90                   	nop
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800c59:	83 ec 0c             	sub    $0xc,%esp
  800c5c:	6a 00                	push   $0x0
  800c5e:	e8 18 17 00 00       	call   80237b <sys_env_destroy>
  800c63:	83 c4 10             	add    $0x10,%esp
}
  800c66:	90                   	nop
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <exit>:

void
exit(void)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800c6f:	e8 6d 17 00 00       	call   8023e1 <sys_env_exit>
}
  800c74:	90                   	nop
  800c75:	c9                   	leave  
  800c76:	c3                   	ret    

00800c77 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c7d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c80:	83 c0 04             	add    $0x4,%eax
  800c83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c86:	a1 18 41 80 00       	mov    0x804118,%eax
  800c8b:	85 c0                	test   %eax,%eax
  800c8d:	74 16                	je     800ca5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c8f:	a1 18 41 80 00       	mov    0x804118,%eax
  800c94:	83 ec 08             	sub    $0x8,%esp
  800c97:	50                   	push   %eax
  800c98:	68 ac 2d 80 00       	push   $0x802dac
  800c9d:	e8 77 02 00 00       	call   800f19 <cprintf>
  800ca2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ca5:	a1 00 40 80 00       	mov    0x804000,%eax
  800caa:	ff 75 0c             	pushl  0xc(%ebp)
  800cad:	ff 75 08             	pushl  0x8(%ebp)
  800cb0:	50                   	push   %eax
  800cb1:	68 b1 2d 80 00       	push   $0x802db1
  800cb6:	e8 5e 02 00 00       	call   800f19 <cprintf>
  800cbb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc1:	83 ec 08             	sub    $0x8,%esp
  800cc4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc7:	50                   	push   %eax
  800cc8:	e8 e1 01 00 00       	call   800eae <vcprintf>
  800ccd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800cd0:	83 ec 08             	sub    $0x8,%esp
  800cd3:	6a 00                	push   $0x0
  800cd5:	68 cd 2d 80 00       	push   $0x802dcd
  800cda:	e8 cf 01 00 00       	call   800eae <vcprintf>
  800cdf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800ce2:	e8 82 ff ff ff       	call   800c69 <exit>

	// should not return here
	while (1) ;
  800ce7:	eb fe                	jmp    800ce7 <_panic+0x70>

00800ce9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cef:	a1 20 40 80 00       	mov    0x804020,%eax
  800cf4:	8b 50 74             	mov    0x74(%eax),%edx
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	39 c2                	cmp    %eax,%edx
  800cfc:	74 14                	je     800d12 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800cfe:	83 ec 04             	sub    $0x4,%esp
  800d01:	68 d0 2d 80 00       	push   $0x802dd0
  800d06:	6a 26                	push   $0x26
  800d08:	68 1c 2e 80 00       	push   $0x802e1c
  800d0d:	e8 65 ff ff ff       	call   800c77 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d19:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d20:	e9 b6 00 00 00       	jmp    800ddb <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	01 d0                	add    %edx,%eax
  800d34:	8b 00                	mov    (%eax),%eax
  800d36:	85 c0                	test   %eax,%eax
  800d38:	75 08                	jne    800d42 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d3a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d3d:	e9 96 00 00 00       	jmp    800dd8 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800d42:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d49:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d50:	eb 5d                	jmp    800daf <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d52:	a1 20 40 80 00       	mov    0x804020,%eax
  800d57:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d5d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d60:	c1 e2 04             	shl    $0x4,%edx
  800d63:	01 d0                	add    %edx,%eax
  800d65:	8a 40 04             	mov    0x4(%eax),%al
  800d68:	84 c0                	test   %al,%al
  800d6a:	75 40                	jne    800dac <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d6c:	a1 20 40 80 00       	mov    0x804020,%eax
  800d71:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d77:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d7a:	c1 e2 04             	shl    $0x4,%edx
  800d7d:	01 d0                	add    %edx,%eax
  800d7f:	8b 00                	mov    (%eax),%eax
  800d81:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d87:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d8c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d91:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	01 c8                	add    %ecx,%eax
  800d9d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d9f:	39 c2                	cmp    %eax,%edx
  800da1:	75 09                	jne    800dac <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800da3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800daa:	eb 12                	jmp    800dbe <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dac:	ff 45 e8             	incl   -0x18(%ebp)
  800daf:	a1 20 40 80 00       	mov    0x804020,%eax
  800db4:	8b 50 74             	mov    0x74(%eax),%edx
  800db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dba:	39 c2                	cmp    %eax,%edx
  800dbc:	77 94                	ja     800d52 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dc2:	75 14                	jne    800dd8 <CheckWSWithoutLastIndex+0xef>
			panic(
  800dc4:	83 ec 04             	sub    $0x4,%esp
  800dc7:	68 28 2e 80 00       	push   $0x802e28
  800dcc:	6a 3a                	push   $0x3a
  800dce:	68 1c 2e 80 00       	push   $0x802e1c
  800dd3:	e8 9f fe ff ff       	call   800c77 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800dd8:	ff 45 f0             	incl   -0x10(%ebp)
  800ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dde:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800de1:	0f 8c 3e ff ff ff    	jl     800d25 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800de7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dee:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800df5:	eb 20                	jmp    800e17 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800df7:	a1 20 40 80 00       	mov    0x804020,%eax
  800dfc:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800e02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e05:	c1 e2 04             	shl    $0x4,%edx
  800e08:	01 d0                	add    %edx,%eax
  800e0a:	8a 40 04             	mov    0x4(%eax),%al
  800e0d:	3c 01                	cmp    $0x1,%al
  800e0f:	75 03                	jne    800e14 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800e11:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e14:	ff 45 e0             	incl   -0x20(%ebp)
  800e17:	a1 20 40 80 00       	mov    0x804020,%eax
  800e1c:	8b 50 74             	mov    0x74(%eax),%edx
  800e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e22:	39 c2                	cmp    %eax,%edx
  800e24:	77 d1                	ja     800df7 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e29:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e2c:	74 14                	je     800e42 <CheckWSWithoutLastIndex+0x159>
		panic(
  800e2e:	83 ec 04             	sub    $0x4,%esp
  800e31:	68 7c 2e 80 00       	push   $0x802e7c
  800e36:	6a 44                	push   $0x44
  800e38:	68 1c 2e 80 00       	push   $0x802e1c
  800e3d:	e8 35 fe ff ff       	call   800c77 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e42:	90                   	nop
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	8b 00                	mov    (%eax),%eax
  800e50:	8d 48 01             	lea    0x1(%eax),%ecx
  800e53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e56:	89 0a                	mov    %ecx,(%edx)
  800e58:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5b:	88 d1                	mov    %dl,%cl
  800e5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e60:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	8b 00                	mov    (%eax),%eax
  800e69:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e6e:	75 2c                	jne    800e9c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e70:	a0 24 40 80 00       	mov    0x804024,%al
  800e75:	0f b6 c0             	movzbl %al,%eax
  800e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7b:	8b 12                	mov    (%edx),%edx
  800e7d:	89 d1                	mov    %edx,%ecx
  800e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e82:	83 c2 08             	add    $0x8,%edx
  800e85:	83 ec 04             	sub    $0x4,%esp
  800e88:	50                   	push   %eax
  800e89:	51                   	push   %ecx
  800e8a:	52                   	push   %edx
  800e8b:	e8 a9 14 00 00       	call   802339 <sys_cputs>
  800e90:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9f:	8b 40 04             	mov    0x4(%eax),%eax
  800ea2:	8d 50 01             	lea    0x1(%eax),%edx
  800ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea8:	89 50 04             	mov    %edx,0x4(%eax)
}
  800eab:	90                   	nop
  800eac:	c9                   	leave  
  800ead:	c3                   	ret    

00800eae <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800eb7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ebe:	00 00 00 
	b.cnt = 0;
  800ec1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ec8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ecb:	ff 75 0c             	pushl  0xc(%ebp)
  800ece:	ff 75 08             	pushl  0x8(%ebp)
  800ed1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ed7:	50                   	push   %eax
  800ed8:	68 45 0e 80 00       	push   $0x800e45
  800edd:	e8 11 02 00 00       	call   8010f3 <vprintfmt>
  800ee2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ee5:	a0 24 40 80 00       	mov    0x804024,%al
  800eea:	0f b6 c0             	movzbl %al,%eax
  800eed:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ef3:	83 ec 04             	sub    $0x4,%esp
  800ef6:	50                   	push   %eax
  800ef7:	52                   	push   %edx
  800ef8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800efe:	83 c0 08             	add    $0x8,%eax
  800f01:	50                   	push   %eax
  800f02:	e8 32 14 00 00       	call   802339 <sys_cputs>
  800f07:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f0a:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800f11:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f17:	c9                   	leave  
  800f18:	c3                   	ret    

00800f19 <cprintf>:

int cprintf(const char *fmt, ...) {
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f1f:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800f26:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	83 ec 08             	sub    $0x8,%esp
  800f32:	ff 75 f4             	pushl  -0xc(%ebp)
  800f35:	50                   	push   %eax
  800f36:	e8 73 ff ff ff       	call   800eae <vcprintf>
  800f3b:	83 c4 10             	add    $0x10,%esp
  800f3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    

00800f46 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f4c:	e8 f9 15 00 00       	call   80254a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f51:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f54:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800f60:	50                   	push   %eax
  800f61:	e8 48 ff ff ff       	call   800eae <vcprintf>
  800f66:	83 c4 10             	add    $0x10,%esp
  800f69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f6c:	e8 f3 15 00 00       	call   802564 <sys_enable_interrupt>
	return cnt;
  800f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	53                   	push   %ebx
  800f7a:	83 ec 14             	sub    $0x14,%esp
  800f7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f83:	8b 45 14             	mov    0x14(%ebp),%eax
  800f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f89:	8b 45 18             	mov    0x18(%ebp),%eax
  800f8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f91:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f94:	77 55                	ja     800feb <printnum+0x75>
  800f96:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f99:	72 05                	jb     800fa0 <printnum+0x2a>
  800f9b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f9e:	77 4b                	ja     800feb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fa0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fa3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fa6:	8b 45 18             	mov    0x18(%ebp),%eax
  800fa9:	ba 00 00 00 00       	mov    $0x0,%edx
  800fae:	52                   	push   %edx
  800faf:	50                   	push   %eax
  800fb0:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb3:	ff 75 f0             	pushl  -0x10(%ebp)
  800fb6:	e8 b1 19 00 00       	call   80296c <__udivdi3>
  800fbb:	83 c4 10             	add    $0x10,%esp
  800fbe:	83 ec 04             	sub    $0x4,%esp
  800fc1:	ff 75 20             	pushl  0x20(%ebp)
  800fc4:	53                   	push   %ebx
  800fc5:	ff 75 18             	pushl  0x18(%ebp)
  800fc8:	52                   	push   %edx
  800fc9:	50                   	push   %eax
  800fca:	ff 75 0c             	pushl  0xc(%ebp)
  800fcd:	ff 75 08             	pushl  0x8(%ebp)
  800fd0:	e8 a1 ff ff ff       	call   800f76 <printnum>
  800fd5:	83 c4 20             	add    $0x20,%esp
  800fd8:	eb 1a                	jmp    800ff4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800fda:	83 ec 08             	sub    $0x8,%esp
  800fdd:	ff 75 0c             	pushl  0xc(%ebp)
  800fe0:	ff 75 20             	pushl  0x20(%ebp)
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	ff d0                	call   *%eax
  800fe8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800feb:	ff 4d 1c             	decl   0x1c(%ebp)
  800fee:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ff2:	7f e6                	jg     800fda <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ff4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ff7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801002:	53                   	push   %ebx
  801003:	51                   	push   %ecx
  801004:	52                   	push   %edx
  801005:	50                   	push   %eax
  801006:	e8 71 1a 00 00       	call   802a7c <__umoddi3>
  80100b:	83 c4 10             	add    $0x10,%esp
  80100e:	05 f4 30 80 00       	add    $0x8030f4,%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	0f be c0             	movsbl %al,%eax
  801018:	83 ec 08             	sub    $0x8,%esp
  80101b:	ff 75 0c             	pushl  0xc(%ebp)
  80101e:	50                   	push   %eax
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	ff d0                	call   *%eax
  801024:	83 c4 10             	add    $0x10,%esp
}
  801027:	90                   	nop
  801028:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801030:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801034:	7e 1c                	jle    801052 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8b 00                	mov    (%eax),%eax
  80103b:	8d 50 08             	lea    0x8(%eax),%edx
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	89 10                	mov    %edx,(%eax)
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	8b 00                	mov    (%eax),%eax
  801048:	83 e8 08             	sub    $0x8,%eax
  80104b:	8b 50 04             	mov    0x4(%eax),%edx
  80104e:	8b 00                	mov    (%eax),%eax
  801050:	eb 40                	jmp    801092 <getuint+0x65>
	else if (lflag)
  801052:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801056:	74 1e                	je     801076 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8b 00                	mov    (%eax),%eax
  80105d:	8d 50 04             	lea    0x4(%eax),%edx
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	89 10                	mov    %edx,(%eax)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8b 00                	mov    (%eax),%eax
  80106a:	83 e8 04             	sub    $0x4,%eax
  80106d:	8b 00                	mov    (%eax),%eax
  80106f:	ba 00 00 00 00       	mov    $0x0,%edx
  801074:	eb 1c                	jmp    801092 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8b 00                	mov    (%eax),%eax
  80107b:	8d 50 04             	lea    0x4(%eax),%edx
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	89 10                	mov    %edx,(%eax)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8b 00                	mov    (%eax),%eax
  801088:	83 e8 04             	sub    $0x4,%eax
  80108b:	8b 00                	mov    (%eax),%eax
  80108d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    

00801094 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801097:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80109b:	7e 1c                	jle    8010b9 <getint+0x25>
		return va_arg(*ap, long long);
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 50 08             	lea    0x8(%eax),%edx
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	89 10                	mov    %edx,(%eax)
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	83 e8 08             	sub    $0x8,%eax
  8010b2:	8b 50 04             	mov    0x4(%eax),%edx
  8010b5:	8b 00                	mov    (%eax),%eax
  8010b7:	eb 38                	jmp    8010f1 <getint+0x5d>
	else if (lflag)
  8010b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010bd:	74 1a                	je     8010d9 <getint+0x45>
		return va_arg(*ap, long);
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8b 00                	mov    (%eax),%eax
  8010c4:	8d 50 04             	lea    0x4(%eax),%edx
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	89 10                	mov    %edx,(%eax)
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	83 e8 04             	sub    $0x4,%eax
  8010d4:	8b 00                	mov    (%eax),%eax
  8010d6:	99                   	cltd   
  8010d7:	eb 18                	jmp    8010f1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	8b 00                	mov    (%eax),%eax
  8010de:	8d 50 04             	lea    0x4(%eax),%edx
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	89 10                	mov    %edx,(%eax)
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8b 00                	mov    (%eax),%eax
  8010eb:	83 e8 04             	sub    $0x4,%eax
  8010ee:	8b 00                	mov    (%eax),%eax
  8010f0:	99                   	cltd   
}
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    

008010f3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	56                   	push   %esi
  8010f7:	53                   	push   %ebx
  8010f8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010fb:	eb 17                	jmp    801114 <vprintfmt+0x21>
			if (ch == '\0')
  8010fd:	85 db                	test   %ebx,%ebx
  8010ff:	0f 84 af 03 00 00    	je     8014b4 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801105:	83 ec 08             	sub    $0x8,%esp
  801108:	ff 75 0c             	pushl  0xc(%ebp)
  80110b:	53                   	push   %ebx
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	ff d0                	call   *%eax
  801111:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801114:	8b 45 10             	mov    0x10(%ebp),%eax
  801117:	8d 50 01             	lea    0x1(%eax),%edx
  80111a:	89 55 10             	mov    %edx,0x10(%ebp)
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	0f b6 d8             	movzbl %al,%ebx
  801122:	83 fb 25             	cmp    $0x25,%ebx
  801125:	75 d6                	jne    8010fd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801127:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80112b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801132:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801139:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801140:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801147:	8b 45 10             	mov    0x10(%ebp),%eax
  80114a:	8d 50 01             	lea    0x1(%eax),%edx
  80114d:	89 55 10             	mov    %edx,0x10(%ebp)
  801150:	8a 00                	mov    (%eax),%al
  801152:	0f b6 d8             	movzbl %al,%ebx
  801155:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801158:	83 f8 55             	cmp    $0x55,%eax
  80115b:	0f 87 2b 03 00 00    	ja     80148c <vprintfmt+0x399>
  801161:	8b 04 85 18 31 80 00 	mov    0x803118(,%eax,4),%eax
  801168:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80116a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80116e:	eb d7                	jmp    801147 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801170:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801174:	eb d1                	jmp    801147 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801176:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80117d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801180:	89 d0                	mov    %edx,%eax
  801182:	c1 e0 02             	shl    $0x2,%eax
  801185:	01 d0                	add    %edx,%eax
  801187:	01 c0                	add    %eax,%eax
  801189:	01 d8                	add    %ebx,%eax
  80118b:	83 e8 30             	sub    $0x30,%eax
  80118e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801191:	8b 45 10             	mov    0x10(%ebp),%eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801199:	83 fb 2f             	cmp    $0x2f,%ebx
  80119c:	7e 3e                	jle    8011dc <vprintfmt+0xe9>
  80119e:	83 fb 39             	cmp    $0x39,%ebx
  8011a1:	7f 39                	jg     8011dc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011a3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011a6:	eb d5                	jmp    80117d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ab:	83 c0 04             	add    $0x4,%eax
  8011ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8011b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b4:	83 e8 04             	sub    $0x4,%eax
  8011b7:	8b 00                	mov    (%eax),%eax
  8011b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011bc:	eb 1f                	jmp    8011dd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011c2:	79 83                	jns    801147 <vprintfmt+0x54>
				width = 0;
  8011c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011cb:	e9 77 ff ff ff       	jmp    801147 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011d0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011d7:	e9 6b ff ff ff       	jmp    801147 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011dc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011e1:	0f 89 60 ff ff ff    	jns    801147 <vprintfmt+0x54>
				width = precision, precision = -1;
  8011e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011ed:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8011f4:	e9 4e ff ff ff       	jmp    801147 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8011f9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8011fc:	e9 46 ff ff ff       	jmp    801147 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801201:	8b 45 14             	mov    0x14(%ebp),%eax
  801204:	83 c0 04             	add    $0x4,%eax
  801207:	89 45 14             	mov    %eax,0x14(%ebp)
  80120a:	8b 45 14             	mov    0x14(%ebp),%eax
  80120d:	83 e8 04             	sub    $0x4,%eax
  801210:	8b 00                	mov    (%eax),%eax
  801212:	83 ec 08             	sub    $0x8,%esp
  801215:	ff 75 0c             	pushl  0xc(%ebp)
  801218:	50                   	push   %eax
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	ff d0                	call   *%eax
  80121e:	83 c4 10             	add    $0x10,%esp
			break;
  801221:	e9 89 02 00 00       	jmp    8014af <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801226:	8b 45 14             	mov    0x14(%ebp),%eax
  801229:	83 c0 04             	add    $0x4,%eax
  80122c:	89 45 14             	mov    %eax,0x14(%ebp)
  80122f:	8b 45 14             	mov    0x14(%ebp),%eax
  801232:	83 e8 04             	sub    $0x4,%eax
  801235:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801237:	85 db                	test   %ebx,%ebx
  801239:	79 02                	jns    80123d <vprintfmt+0x14a>
				err = -err;
  80123b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80123d:	83 fb 64             	cmp    $0x64,%ebx
  801240:	7f 0b                	jg     80124d <vprintfmt+0x15a>
  801242:	8b 34 9d 60 2f 80 00 	mov    0x802f60(,%ebx,4),%esi
  801249:	85 f6                	test   %esi,%esi
  80124b:	75 19                	jne    801266 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80124d:	53                   	push   %ebx
  80124e:	68 05 31 80 00       	push   $0x803105
  801253:	ff 75 0c             	pushl  0xc(%ebp)
  801256:	ff 75 08             	pushl  0x8(%ebp)
  801259:	e8 5e 02 00 00       	call   8014bc <printfmt>
  80125e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801261:	e9 49 02 00 00       	jmp    8014af <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801266:	56                   	push   %esi
  801267:	68 0e 31 80 00       	push   $0x80310e
  80126c:	ff 75 0c             	pushl  0xc(%ebp)
  80126f:	ff 75 08             	pushl  0x8(%ebp)
  801272:	e8 45 02 00 00       	call   8014bc <printfmt>
  801277:	83 c4 10             	add    $0x10,%esp
			break;
  80127a:	e9 30 02 00 00       	jmp    8014af <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80127f:	8b 45 14             	mov    0x14(%ebp),%eax
  801282:	83 c0 04             	add    $0x4,%eax
  801285:	89 45 14             	mov    %eax,0x14(%ebp)
  801288:	8b 45 14             	mov    0x14(%ebp),%eax
  80128b:	83 e8 04             	sub    $0x4,%eax
  80128e:	8b 30                	mov    (%eax),%esi
  801290:	85 f6                	test   %esi,%esi
  801292:	75 05                	jne    801299 <vprintfmt+0x1a6>
				p = "(null)";
  801294:	be 11 31 80 00       	mov    $0x803111,%esi
			if (width > 0 && padc != '-')
  801299:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80129d:	7e 6d                	jle    80130c <vprintfmt+0x219>
  80129f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012a3:	74 67                	je     80130c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012a8:	83 ec 08             	sub    $0x8,%esp
  8012ab:	50                   	push   %eax
  8012ac:	56                   	push   %esi
  8012ad:	e8 0c 03 00 00       	call   8015be <strnlen>
  8012b2:	83 c4 10             	add    $0x10,%esp
  8012b5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012b8:	eb 16                	jmp    8012d0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012ba:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012be:	83 ec 08             	sub    $0x8,%esp
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	50                   	push   %eax
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	ff d0                	call   *%eax
  8012ca:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012cd:	ff 4d e4             	decl   -0x1c(%ebp)
  8012d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012d4:	7f e4                	jg     8012ba <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012d6:	eb 34                	jmp    80130c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012dc:	74 1c                	je     8012fa <vprintfmt+0x207>
  8012de:	83 fb 1f             	cmp    $0x1f,%ebx
  8012e1:	7e 05                	jle    8012e8 <vprintfmt+0x1f5>
  8012e3:	83 fb 7e             	cmp    $0x7e,%ebx
  8012e6:	7e 12                	jle    8012fa <vprintfmt+0x207>
					putch('?', putdat);
  8012e8:	83 ec 08             	sub    $0x8,%esp
  8012eb:	ff 75 0c             	pushl  0xc(%ebp)
  8012ee:	6a 3f                	push   $0x3f
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	ff d0                	call   *%eax
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	eb 0f                	jmp    801309 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8012fa:	83 ec 08             	sub    $0x8,%esp
  8012fd:	ff 75 0c             	pushl  0xc(%ebp)
  801300:	53                   	push   %ebx
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	ff d0                	call   *%eax
  801306:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801309:	ff 4d e4             	decl   -0x1c(%ebp)
  80130c:	89 f0                	mov    %esi,%eax
  80130e:	8d 70 01             	lea    0x1(%eax),%esi
  801311:	8a 00                	mov    (%eax),%al
  801313:	0f be d8             	movsbl %al,%ebx
  801316:	85 db                	test   %ebx,%ebx
  801318:	74 24                	je     80133e <vprintfmt+0x24b>
  80131a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80131e:	78 b8                	js     8012d8 <vprintfmt+0x1e5>
  801320:	ff 4d e0             	decl   -0x20(%ebp)
  801323:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801327:	79 af                	jns    8012d8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801329:	eb 13                	jmp    80133e <vprintfmt+0x24b>
				putch(' ', putdat);
  80132b:	83 ec 08             	sub    $0x8,%esp
  80132e:	ff 75 0c             	pushl  0xc(%ebp)
  801331:	6a 20                	push   $0x20
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	ff d0                	call   *%eax
  801338:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80133b:	ff 4d e4             	decl   -0x1c(%ebp)
  80133e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801342:	7f e7                	jg     80132b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801344:	e9 66 01 00 00       	jmp    8014af <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801349:	83 ec 08             	sub    $0x8,%esp
  80134c:	ff 75 e8             	pushl  -0x18(%ebp)
  80134f:	8d 45 14             	lea    0x14(%ebp),%eax
  801352:	50                   	push   %eax
  801353:	e8 3c fd ff ff       	call   801094 <getint>
  801358:	83 c4 10             	add    $0x10,%esp
  80135b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80135e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801367:	85 d2                	test   %edx,%edx
  801369:	79 23                	jns    80138e <vprintfmt+0x29b>
				putch('-', putdat);
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	ff 75 0c             	pushl  0xc(%ebp)
  801371:	6a 2d                	push   $0x2d
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	ff d0                	call   *%eax
  801378:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80137b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801381:	f7 d8                	neg    %eax
  801383:	83 d2 00             	adc    $0x0,%edx
  801386:	f7 da                	neg    %edx
  801388:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80138b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80138e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801395:	e9 bc 00 00 00       	jmp    801456 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80139a:	83 ec 08             	sub    $0x8,%esp
  80139d:	ff 75 e8             	pushl  -0x18(%ebp)
  8013a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8013a3:	50                   	push   %eax
  8013a4:	e8 84 fc ff ff       	call   80102d <getuint>
  8013a9:	83 c4 10             	add    $0x10,%esp
  8013ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013b2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013b9:	e9 98 00 00 00       	jmp    801456 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013be:	83 ec 08             	sub    $0x8,%esp
  8013c1:	ff 75 0c             	pushl  0xc(%ebp)
  8013c4:	6a 58                	push   $0x58
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	ff d0                	call   *%eax
  8013cb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013ce:	83 ec 08             	sub    $0x8,%esp
  8013d1:	ff 75 0c             	pushl  0xc(%ebp)
  8013d4:	6a 58                	push   $0x58
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	ff d0                	call   *%eax
  8013db:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013de:	83 ec 08             	sub    $0x8,%esp
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	6a 58                	push   $0x58
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	ff d0                	call   *%eax
  8013eb:	83 c4 10             	add    $0x10,%esp
			break;
  8013ee:	e9 bc 00 00 00       	jmp    8014af <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8013f3:	83 ec 08             	sub    $0x8,%esp
  8013f6:	ff 75 0c             	pushl  0xc(%ebp)
  8013f9:	6a 30                	push   $0x30
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	ff d0                	call   *%eax
  801400:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801403:	83 ec 08             	sub    $0x8,%esp
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	6a 78                	push   $0x78
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	ff d0                	call   *%eax
  801410:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801413:	8b 45 14             	mov    0x14(%ebp),%eax
  801416:	83 c0 04             	add    $0x4,%eax
  801419:	89 45 14             	mov    %eax,0x14(%ebp)
  80141c:	8b 45 14             	mov    0x14(%ebp),%eax
  80141f:	83 e8 04             	sub    $0x4,%eax
  801422:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801424:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801427:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80142e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801435:	eb 1f                	jmp    801456 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801437:	83 ec 08             	sub    $0x8,%esp
  80143a:	ff 75 e8             	pushl  -0x18(%ebp)
  80143d:	8d 45 14             	lea    0x14(%ebp),%eax
  801440:	50                   	push   %eax
  801441:	e8 e7 fb ff ff       	call   80102d <getuint>
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80144c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80144f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801456:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80145a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80145d:	83 ec 04             	sub    $0x4,%esp
  801460:	52                   	push   %edx
  801461:	ff 75 e4             	pushl  -0x1c(%ebp)
  801464:	50                   	push   %eax
  801465:	ff 75 f4             	pushl  -0xc(%ebp)
  801468:	ff 75 f0             	pushl  -0x10(%ebp)
  80146b:	ff 75 0c             	pushl  0xc(%ebp)
  80146e:	ff 75 08             	pushl  0x8(%ebp)
  801471:	e8 00 fb ff ff       	call   800f76 <printnum>
  801476:	83 c4 20             	add    $0x20,%esp
			break;
  801479:	eb 34                	jmp    8014af <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80147b:	83 ec 08             	sub    $0x8,%esp
  80147e:	ff 75 0c             	pushl  0xc(%ebp)
  801481:	53                   	push   %ebx
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	ff d0                	call   *%eax
  801487:	83 c4 10             	add    $0x10,%esp
			break;
  80148a:	eb 23                	jmp    8014af <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80148c:	83 ec 08             	sub    $0x8,%esp
  80148f:	ff 75 0c             	pushl  0xc(%ebp)
  801492:	6a 25                	push   $0x25
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	ff d0                	call   *%eax
  801499:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80149c:	ff 4d 10             	decl   0x10(%ebp)
  80149f:	eb 03                	jmp    8014a4 <vprintfmt+0x3b1>
  8014a1:	ff 4d 10             	decl   0x10(%ebp)
  8014a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a7:	48                   	dec    %eax
  8014a8:	8a 00                	mov    (%eax),%al
  8014aa:	3c 25                	cmp    $0x25,%al
  8014ac:	75 f3                	jne    8014a1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014ae:	90                   	nop
		}
	}
  8014af:	e9 47 fc ff ff       	jmp    8010fb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014b4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014b8:	5b                   	pop    %ebx
  8014b9:	5e                   	pop    %esi
  8014ba:	5d                   	pop    %ebp
  8014bb:	c3                   	ret    

008014bc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8014c5:	83 c0 04             	add    $0x4,%eax
  8014c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8014d1:	50                   	push   %eax
  8014d2:	ff 75 0c             	pushl  0xc(%ebp)
  8014d5:	ff 75 08             	pushl  0x8(%ebp)
  8014d8:	e8 16 fc ff ff       	call   8010f3 <vprintfmt>
  8014dd:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014e0:	90                   	nop
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e9:	8b 40 08             	mov    0x8(%eax),%eax
  8014ec:	8d 50 01             	lea    0x1(%eax),%edx
  8014ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	8b 10                	mov    (%eax),%edx
  8014fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fd:	8b 40 04             	mov    0x4(%eax),%eax
  801500:	39 c2                	cmp    %eax,%edx
  801502:	73 12                	jae    801516 <sprintputch+0x33>
		*b->buf++ = ch;
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8b 00                	mov    (%eax),%eax
  801509:	8d 48 01             	lea    0x1(%eax),%ecx
  80150c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150f:	89 0a                	mov    %ecx,(%edx)
  801511:	8b 55 08             	mov    0x8(%ebp),%edx
  801514:	88 10                	mov    %dl,(%eax)
}
  801516:	90                   	nop
  801517:	5d                   	pop    %ebp
  801518:	c3                   	ret    

00801519 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	8d 50 ff             	lea    -0x1(%eax),%edx
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	01 d0                	add    %edx,%eax
  801530:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801533:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80153a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80153e:	74 06                	je     801546 <vsnprintf+0x2d>
  801540:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801544:	7f 07                	jg     80154d <vsnprintf+0x34>
		return -E_INVAL;
  801546:	b8 03 00 00 00       	mov    $0x3,%eax
  80154b:	eb 20                	jmp    80156d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80154d:	ff 75 14             	pushl  0x14(%ebp)
  801550:	ff 75 10             	pushl  0x10(%ebp)
  801553:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801556:	50                   	push   %eax
  801557:	68 e3 14 80 00       	push   $0x8014e3
  80155c:	e8 92 fb ff ff       	call   8010f3 <vprintfmt>
  801561:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801567:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80156a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801575:	8d 45 10             	lea    0x10(%ebp),%eax
  801578:	83 c0 04             	add    $0x4,%eax
  80157b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80157e:	8b 45 10             	mov    0x10(%ebp),%eax
  801581:	ff 75 f4             	pushl  -0xc(%ebp)
  801584:	50                   	push   %eax
  801585:	ff 75 0c             	pushl  0xc(%ebp)
  801588:	ff 75 08             	pushl  0x8(%ebp)
  80158b:	e8 89 ff ff ff       	call   801519 <vsnprintf>
  801590:	83 c4 10             	add    $0x10,%esp
  801593:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801596:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015a8:	eb 06                	jmp    8015b0 <strlen+0x15>
		n++;
  8015aa:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015ad:	ff 45 08             	incl   0x8(%ebp)
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8a 00                	mov    (%eax),%al
  8015b5:	84 c0                	test   %al,%al
  8015b7:	75 f1                	jne    8015aa <strlen+0xf>
		n++;
	return n;
  8015b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015cb:	eb 09                	jmp    8015d6 <strnlen+0x18>
		n++;
  8015cd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015d0:	ff 45 08             	incl   0x8(%ebp)
  8015d3:	ff 4d 0c             	decl   0xc(%ebp)
  8015d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015da:	74 09                	je     8015e5 <strnlen+0x27>
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	8a 00                	mov    (%eax),%al
  8015e1:	84 c0                	test   %al,%al
  8015e3:	75 e8                	jne    8015cd <strnlen+0xf>
		n++;
	return n;
  8015e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015f6:	90                   	nop
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8d 50 01             	lea    0x1(%eax),%edx
  8015fd:	89 55 08             	mov    %edx,0x8(%ebp)
  801600:	8b 55 0c             	mov    0xc(%ebp),%edx
  801603:	8d 4a 01             	lea    0x1(%edx),%ecx
  801606:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801609:	8a 12                	mov    (%edx),%dl
  80160b:	88 10                	mov    %dl,(%eax)
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	84 c0                	test   %al,%al
  801611:	75 e4                	jne    8015f7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801613:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801616:	c9                   	leave  
  801617:	c3                   	ret    

00801618 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
  80161b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801624:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80162b:	eb 1f                	jmp    80164c <strncpy+0x34>
		*dst++ = *src;
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	8d 50 01             	lea    0x1(%eax),%edx
  801633:	89 55 08             	mov    %edx,0x8(%ebp)
  801636:	8b 55 0c             	mov    0xc(%ebp),%edx
  801639:	8a 12                	mov    (%edx),%dl
  80163b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	8a 00                	mov    (%eax),%al
  801642:	84 c0                	test   %al,%al
  801644:	74 03                	je     801649 <strncpy+0x31>
			src++;
  801646:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801649:	ff 45 fc             	incl   -0x4(%ebp)
  80164c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801652:	72 d9                	jb     80162d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801654:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801665:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801669:	74 30                	je     80169b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80166b:	eb 16                	jmp    801683 <strlcpy+0x2a>
			*dst++ = *src++;
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8d 50 01             	lea    0x1(%eax),%edx
  801673:	89 55 08             	mov    %edx,0x8(%ebp)
  801676:	8b 55 0c             	mov    0xc(%ebp),%edx
  801679:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80167f:	8a 12                	mov    (%edx),%dl
  801681:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801683:	ff 4d 10             	decl   0x10(%ebp)
  801686:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168a:	74 09                	je     801695 <strlcpy+0x3c>
  80168c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168f:	8a 00                	mov    (%eax),%al
  801691:	84 c0                	test   %al,%al
  801693:	75 d8                	jne    80166d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80169b:	8b 55 08             	mov    0x8(%ebp),%edx
  80169e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a1:	29 c2                	sub    %eax,%edx
  8016a3:	89 d0                	mov    %edx,%eax
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016aa:	eb 06                	jmp    8016b2 <strcmp+0xb>
		p++, q++;
  8016ac:	ff 45 08             	incl   0x8(%ebp)
  8016af:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8a 00                	mov    (%eax),%al
  8016b7:	84 c0                	test   %al,%al
  8016b9:	74 0e                	je     8016c9 <strcmp+0x22>
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 10                	mov    (%eax),%dl
  8016c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c3:	8a 00                	mov    (%eax),%al
  8016c5:	38 c2                	cmp    %al,%dl
  8016c7:	74 e3                	je     8016ac <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8a 00                	mov    (%eax),%al
  8016ce:	0f b6 d0             	movzbl %al,%edx
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f b6 c0             	movzbl %al,%eax
  8016d9:	29 c2                	sub    %eax,%edx
  8016db:	89 d0                	mov    %edx,%eax
}
  8016dd:	5d                   	pop    %ebp
  8016de:	c3                   	ret    

008016df <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016e2:	eb 09                	jmp    8016ed <strncmp+0xe>
		n--, p++, q++;
  8016e4:	ff 4d 10             	decl   0x10(%ebp)
  8016e7:	ff 45 08             	incl   0x8(%ebp)
  8016ea:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016f1:	74 17                	je     80170a <strncmp+0x2b>
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	8a 00                	mov    (%eax),%al
  8016f8:	84 c0                	test   %al,%al
  8016fa:	74 0e                	je     80170a <strncmp+0x2b>
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	8a 10                	mov    (%eax),%dl
  801701:	8b 45 0c             	mov    0xc(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	38 c2                	cmp    %al,%dl
  801708:	74 da                	je     8016e4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80170a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80170e:	75 07                	jne    801717 <strncmp+0x38>
		return 0;
  801710:	b8 00 00 00 00       	mov    $0x0,%eax
  801715:	eb 14                	jmp    80172b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	0f b6 d0             	movzbl %al,%edx
  80171f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801722:	8a 00                	mov    (%eax),%al
  801724:	0f b6 c0             	movzbl %al,%eax
  801727:	29 c2                	sub    %eax,%edx
  801729:	89 d0                	mov    %edx,%eax
}
  80172b:	5d                   	pop    %ebp
  80172c:	c3                   	ret    

0080172d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 04             	sub    $0x4,%esp
  801733:	8b 45 0c             	mov    0xc(%ebp),%eax
  801736:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801739:	eb 12                	jmp    80174d <strchr+0x20>
		if (*s == c)
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8a 00                	mov    (%eax),%al
  801740:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801743:	75 05                	jne    80174a <strchr+0x1d>
			return (char *) s;
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	eb 11                	jmp    80175b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80174a:	ff 45 08             	incl   0x8(%ebp)
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	8a 00                	mov    (%eax),%al
  801752:	84 c0                	test   %al,%al
  801754:	75 e5                	jne    80173b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	8b 45 0c             	mov    0xc(%ebp),%eax
  801766:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801769:	eb 0d                	jmp    801778 <strfind+0x1b>
		if (*s == c)
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	8a 00                	mov    (%eax),%al
  801770:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801773:	74 0e                	je     801783 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801775:	ff 45 08             	incl   0x8(%ebp)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	84 c0                	test   %al,%al
  80177f:	75 ea                	jne    80176b <strfind+0xe>
  801781:	eb 01                	jmp    801784 <strfind+0x27>
		if (*s == c)
			break;
  801783:	90                   	nop
	return (char *) s;
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801795:	8b 45 10             	mov    0x10(%ebp),%eax
  801798:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80179b:	eb 0e                	jmp    8017ab <memset+0x22>
		*p++ = c;
  80179d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017a0:	8d 50 01             	lea    0x1(%eax),%edx
  8017a3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017ab:	ff 4d f8             	decl   -0x8(%ebp)
  8017ae:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017b2:	79 e9                	jns    80179d <memset+0x14>
		*p++ = c;

	return v;
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017cb:	eb 16                	jmp    8017e3 <memcpy+0x2a>
		*d++ = *s++;
  8017cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d0:	8d 50 01             	lea    0x1(%eax),%edx
  8017d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017dc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017df:	8a 12                	mov    (%edx),%dl
  8017e1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	75 dd                	jne    8017cd <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801807:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80180a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80180d:	73 50                	jae    80185f <memmove+0x6a>
  80180f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801812:	8b 45 10             	mov    0x10(%ebp),%eax
  801815:	01 d0                	add    %edx,%eax
  801817:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80181a:	76 43                	jbe    80185f <memmove+0x6a>
		s += n;
  80181c:	8b 45 10             	mov    0x10(%ebp),%eax
  80181f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801822:	8b 45 10             	mov    0x10(%ebp),%eax
  801825:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801828:	eb 10                	jmp    80183a <memmove+0x45>
			*--d = *--s;
  80182a:	ff 4d f8             	decl   -0x8(%ebp)
  80182d:	ff 4d fc             	decl   -0x4(%ebp)
  801830:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801833:	8a 10                	mov    (%eax),%dl
  801835:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801838:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80183a:	8b 45 10             	mov    0x10(%ebp),%eax
  80183d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801840:	89 55 10             	mov    %edx,0x10(%ebp)
  801843:	85 c0                	test   %eax,%eax
  801845:	75 e3                	jne    80182a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801847:	eb 23                	jmp    80186c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801849:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184c:	8d 50 01             	lea    0x1(%eax),%edx
  80184f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801852:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801855:	8d 4a 01             	lea    0x1(%edx),%ecx
  801858:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80185b:	8a 12                	mov    (%edx),%dl
  80185d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80185f:	8b 45 10             	mov    0x10(%ebp),%eax
  801862:	8d 50 ff             	lea    -0x1(%eax),%edx
  801865:	89 55 10             	mov    %edx,0x10(%ebp)
  801868:	85 c0                	test   %eax,%eax
  80186a:	75 dd                	jne    801849 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80187d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801880:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801883:	eb 2a                	jmp    8018af <memcmp+0x3e>
		if (*s1 != *s2)
  801885:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801888:	8a 10                	mov    (%eax),%dl
  80188a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80188d:	8a 00                	mov    (%eax),%al
  80188f:	38 c2                	cmp    %al,%dl
  801891:	74 16                	je     8018a9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801893:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801896:	8a 00                	mov    (%eax),%al
  801898:	0f b6 d0             	movzbl %al,%edx
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	8a 00                	mov    (%eax),%al
  8018a0:	0f b6 c0             	movzbl %al,%eax
  8018a3:	29 c2                	sub    %eax,%edx
  8018a5:	89 d0                	mov    %edx,%eax
  8018a7:	eb 18                	jmp    8018c1 <memcmp+0x50>
		s1++, s2++;
  8018a9:	ff 45 fc             	incl   -0x4(%ebp)
  8018ac:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018af:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	75 c9                	jne    801885 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8018cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018cf:	01 d0                	add    %edx,%eax
  8018d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018d4:	eb 15                	jmp    8018eb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	8a 00                	mov    (%eax),%al
  8018db:	0f b6 d0             	movzbl %al,%edx
  8018de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e1:	0f b6 c0             	movzbl %al,%eax
  8018e4:	39 c2                	cmp    %eax,%edx
  8018e6:	74 0d                	je     8018f5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018e8:	ff 45 08             	incl   0x8(%ebp)
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018f1:	72 e3                	jb     8018d6 <memfind+0x13>
  8018f3:	eb 01                	jmp    8018f6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018f5:	90                   	nop
	return (void *) s;
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801901:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801908:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80190f:	eb 03                	jmp    801914 <strtol+0x19>
		s++;
  801911:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	8a 00                	mov    (%eax),%al
  801919:	3c 20                	cmp    $0x20,%al
  80191b:	74 f4                	je     801911 <strtol+0x16>
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	8a 00                	mov    (%eax),%al
  801922:	3c 09                	cmp    $0x9,%al
  801924:	74 eb                	je     801911 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8a 00                	mov    (%eax),%al
  80192b:	3c 2b                	cmp    $0x2b,%al
  80192d:	75 05                	jne    801934 <strtol+0x39>
		s++;
  80192f:	ff 45 08             	incl   0x8(%ebp)
  801932:	eb 13                	jmp    801947 <strtol+0x4c>
	else if (*s == '-')
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8a 00                	mov    (%eax),%al
  801939:	3c 2d                	cmp    $0x2d,%al
  80193b:	75 0a                	jne    801947 <strtol+0x4c>
		s++, neg = 1;
  80193d:	ff 45 08             	incl   0x8(%ebp)
  801940:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801947:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80194b:	74 06                	je     801953 <strtol+0x58>
  80194d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801951:	75 20                	jne    801973 <strtol+0x78>
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8a 00                	mov    (%eax),%al
  801958:	3c 30                	cmp    $0x30,%al
  80195a:	75 17                	jne    801973 <strtol+0x78>
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	40                   	inc    %eax
  801960:	8a 00                	mov    (%eax),%al
  801962:	3c 78                	cmp    $0x78,%al
  801964:	75 0d                	jne    801973 <strtol+0x78>
		s += 2, base = 16;
  801966:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80196a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801971:	eb 28                	jmp    80199b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801973:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801977:	75 15                	jne    80198e <strtol+0x93>
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	3c 30                	cmp    $0x30,%al
  801980:	75 0c                	jne    80198e <strtol+0x93>
		s++, base = 8;
  801982:	ff 45 08             	incl   0x8(%ebp)
  801985:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80198c:	eb 0d                	jmp    80199b <strtol+0xa0>
	else if (base == 0)
  80198e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801992:	75 07                	jne    80199b <strtol+0xa0>
		base = 10;
  801994:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	3c 2f                	cmp    $0x2f,%al
  8019a2:	7e 19                	jle    8019bd <strtol+0xc2>
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	8a 00                	mov    (%eax),%al
  8019a9:	3c 39                	cmp    $0x39,%al
  8019ab:	7f 10                	jg     8019bd <strtol+0xc2>
			dig = *s - '0';
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	8a 00                	mov    (%eax),%al
  8019b2:	0f be c0             	movsbl %al,%eax
  8019b5:	83 e8 30             	sub    $0x30,%eax
  8019b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019bb:	eb 42                	jmp    8019ff <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8a 00                	mov    (%eax),%al
  8019c2:	3c 60                	cmp    $0x60,%al
  8019c4:	7e 19                	jle    8019df <strtol+0xe4>
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	3c 7a                	cmp    $0x7a,%al
  8019cd:	7f 10                	jg     8019df <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	8a 00                	mov    (%eax),%al
  8019d4:	0f be c0             	movsbl %al,%eax
  8019d7:	83 e8 57             	sub    $0x57,%eax
  8019da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019dd:	eb 20                	jmp    8019ff <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8a 00                	mov    (%eax),%al
  8019e4:	3c 40                	cmp    $0x40,%al
  8019e6:	7e 39                	jle    801a21 <strtol+0x126>
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	3c 5a                	cmp    $0x5a,%al
  8019ef:	7f 30                	jg     801a21 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8a 00                	mov    (%eax),%al
  8019f6:	0f be c0             	movsbl %al,%eax
  8019f9:	83 e8 37             	sub    $0x37,%eax
  8019fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a02:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a05:	7d 19                	jge    801a20 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a07:	ff 45 08             	incl   0x8(%ebp)
  801a0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a11:	89 c2                	mov    %eax,%edx
  801a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a16:	01 d0                	add    %edx,%eax
  801a18:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a1b:	e9 7b ff ff ff       	jmp    80199b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a20:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a25:	74 08                	je     801a2f <strtol+0x134>
		*endptr = (char *) s;
  801a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2a:	8b 55 08             	mov    0x8(%ebp),%edx
  801a2d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a33:	74 07                	je     801a3c <strtol+0x141>
  801a35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a38:	f7 d8                	neg    %eax
  801a3a:	eb 03                	jmp    801a3f <strtol+0x144>
  801a3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <ltostr>:

void
ltostr(long value, char *str)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a4e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a59:	79 13                	jns    801a6e <ltostr+0x2d>
	{
		neg = 1;
  801a5b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a65:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a68:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a6b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a76:	99                   	cltd   
  801a77:	f7 f9                	idiv   %ecx
  801a79:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a7f:	8d 50 01             	lea    0x1(%eax),%edx
  801a82:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a85:	89 c2                	mov    %eax,%edx
  801a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8a:	01 d0                	add    %edx,%eax
  801a8c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a8f:	83 c2 30             	add    $0x30,%edx
  801a92:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a97:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a9c:	f7 e9                	imul   %ecx
  801a9e:	c1 fa 02             	sar    $0x2,%edx
  801aa1:	89 c8                	mov    %ecx,%eax
  801aa3:	c1 f8 1f             	sar    $0x1f,%eax
  801aa6:	29 c2                	sub    %eax,%edx
  801aa8:	89 d0                	mov    %edx,%eax
  801aaa:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801aad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ab5:	f7 e9                	imul   %ecx
  801ab7:	c1 fa 02             	sar    $0x2,%edx
  801aba:	89 c8                	mov    %ecx,%eax
  801abc:	c1 f8 1f             	sar    $0x1f,%eax
  801abf:	29 c2                	sub    %eax,%edx
  801ac1:	89 d0                	mov    %edx,%eax
  801ac3:	c1 e0 02             	shl    $0x2,%eax
  801ac6:	01 d0                	add    %edx,%eax
  801ac8:	01 c0                	add    %eax,%eax
  801aca:	29 c1                	sub    %eax,%ecx
  801acc:	89 ca                	mov    %ecx,%edx
  801ace:	85 d2                	test   %edx,%edx
  801ad0:	75 9c                	jne    801a6e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801ad2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ad9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801adc:	48                   	dec    %eax
  801add:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801ae0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ae4:	74 3d                	je     801b23 <ltostr+0xe2>
		start = 1 ;
  801ae6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801aed:	eb 34                	jmp    801b23 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af5:	01 d0                	add    %edx,%eax
  801af7:	8a 00                	mov    (%eax),%al
  801af9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801afc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b02:	01 c2                	add    %eax,%edx
  801b04:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0a:	01 c8                	add    %ecx,%eax
  801b0c:	8a 00                	mov    (%eax),%al
  801b0e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b16:	01 c2                	add    %eax,%edx
  801b18:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b1b:	88 02                	mov    %al,(%edx)
		start++ ;
  801b1d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b20:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b26:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b29:	7c c4                	jl     801aef <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b2b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b31:	01 d0                	add    %edx,%eax
  801b33:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b36:	90                   	nop
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b3f:	ff 75 08             	pushl  0x8(%ebp)
  801b42:	e8 54 fa ff ff       	call   80159b <strlen>
  801b47:	83 c4 04             	add    $0x4,%esp
  801b4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b4d:	ff 75 0c             	pushl  0xc(%ebp)
  801b50:	e8 46 fa ff ff       	call   80159b <strlen>
  801b55:	83 c4 04             	add    $0x4,%esp
  801b58:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b69:	eb 17                	jmp    801b82 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b71:	01 c2                	add    %eax,%edx
  801b73:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	01 c8                	add    %ecx,%eax
  801b7b:	8a 00                	mov    (%eax),%al
  801b7d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b7f:	ff 45 fc             	incl   -0x4(%ebp)
  801b82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b85:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b88:	7c e1                	jl     801b6b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b8a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b91:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b98:	eb 1f                	jmp    801bb9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b9d:	8d 50 01             	lea    0x1(%eax),%edx
  801ba0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ba3:	89 c2                	mov    %eax,%edx
  801ba5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba8:	01 c2                	add    %eax,%edx
  801baa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb0:	01 c8                	add    %ecx,%eax
  801bb2:	8a 00                	mov    (%eax),%al
  801bb4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bb6:	ff 45 f8             	incl   -0x8(%ebp)
  801bb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bbc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bbf:	7c d9                	jl     801b9a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801bc1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc7:	01 d0                	add    %edx,%eax
  801bc9:	c6 00 00             	movb   $0x0,(%eax)
}
  801bcc:	90                   	nop
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bdb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bde:	8b 00                	mov    (%eax),%eax
  801be0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801be7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bea:	01 d0                	add    %edx,%eax
  801bec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bf2:	eb 0c                	jmp    801c00 <strsplit+0x31>
			*string++ = 0;
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	8d 50 01             	lea    0x1(%eax),%edx
  801bfa:	89 55 08             	mov    %edx,0x8(%ebp)
  801bfd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	8a 00                	mov    (%eax),%al
  801c05:	84 c0                	test   %al,%al
  801c07:	74 18                	je     801c21 <strsplit+0x52>
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	8a 00                	mov    (%eax),%al
  801c0e:	0f be c0             	movsbl %al,%eax
  801c11:	50                   	push   %eax
  801c12:	ff 75 0c             	pushl  0xc(%ebp)
  801c15:	e8 13 fb ff ff       	call   80172d <strchr>
  801c1a:	83 c4 08             	add    $0x8,%esp
  801c1d:	85 c0                	test   %eax,%eax
  801c1f:	75 d3                	jne    801bf4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	8a 00                	mov    (%eax),%al
  801c26:	84 c0                	test   %al,%al
  801c28:	74 5a                	je     801c84 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c2a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c2d:	8b 00                	mov    (%eax),%eax
  801c2f:	83 f8 0f             	cmp    $0xf,%eax
  801c32:	75 07                	jne    801c3b <strsplit+0x6c>
		{
			return 0;
  801c34:	b8 00 00 00 00       	mov    $0x0,%eax
  801c39:	eb 66                	jmp    801ca1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3e:	8b 00                	mov    (%eax),%eax
  801c40:	8d 48 01             	lea    0x1(%eax),%ecx
  801c43:	8b 55 14             	mov    0x14(%ebp),%edx
  801c46:	89 0a                	mov    %ecx,(%edx)
  801c48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c52:	01 c2                	add    %eax,%edx
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c59:	eb 03                	jmp    801c5e <strsplit+0x8f>
			string++;
  801c5b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	8a 00                	mov    (%eax),%al
  801c63:	84 c0                	test   %al,%al
  801c65:	74 8b                	je     801bf2 <strsplit+0x23>
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	8a 00                	mov    (%eax),%al
  801c6c:	0f be c0             	movsbl %al,%eax
  801c6f:	50                   	push   %eax
  801c70:	ff 75 0c             	pushl  0xc(%ebp)
  801c73:	e8 b5 fa ff ff       	call   80172d <strchr>
  801c78:	83 c4 08             	add    $0x8,%esp
  801c7b:	85 c0                	test   %eax,%eax
  801c7d:	74 dc                	je     801c5b <strsplit+0x8c>
			string++;
	}
  801c7f:	e9 6e ff ff ff       	jmp    801bf2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c84:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c85:	8b 45 14             	mov    0x14(%ebp),%eax
  801c88:	8b 00                	mov    (%eax),%eax
  801c8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c91:	8b 45 10             	mov    0x10(%ebp),%eax
  801c94:	01 d0                	add    %edx,%eax
  801c96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c9c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801ca9:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  801cb3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801cb6:	01 d0                	add    %edx,%eax
  801cb8:	48                   	dec    %eax
  801cb9:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801cbc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801cbf:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc4:	f7 75 ac             	divl   -0x54(%ebp)
  801cc7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801cca:	29 d0                	sub    %edx,%eax
  801ccc:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801ccf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801cd6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801cdd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801ce4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ceb:	eb 3f                	jmp    801d2c <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801ced:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cf0:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801cf7:	83 ec 04             	sub    $0x4,%esp
  801cfa:	50                   	push   %eax
  801cfb:	ff 75 e8             	pushl  -0x18(%ebp)
  801cfe:	68 70 32 80 00       	push   $0x803270
  801d03:	e8 11 f2 ff ff       	call   800f19 <cprintf>
  801d08:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801d0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d0e:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801d15:	83 ec 04             	sub    $0x4,%esp
  801d18:	50                   	push   %eax
  801d19:	ff 75 e8             	pushl  -0x18(%ebp)
  801d1c:	68 85 32 80 00       	push   $0x803285
  801d21:	e8 f3 f1 ff ff       	call   800f19 <cprintf>
  801d26:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801d29:	ff 45 e8             	incl   -0x18(%ebp)
  801d2c:	a1 28 40 80 00       	mov    0x804028,%eax
  801d31:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801d34:	7c b7                	jl     801ced <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801d36:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801d3d:	e9 42 01 00 00       	jmp    801e84 <malloc+0x1e1>
		int flag0=1;
  801d42:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801d49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d4f:	eb 6b                	jmp    801dbc <malloc+0x119>
			for(int k=0;k<count;k++){
  801d51:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801d58:	eb 42                	jmp    801d9c <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801d5a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d5d:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801d64:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d67:	39 c2                	cmp    %eax,%edx
  801d69:	77 2e                	ja     801d99 <malloc+0xf6>
  801d6b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d6e:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801d75:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d78:	39 c2                	cmp    %eax,%edx
  801d7a:	76 1d                	jbe    801d99 <malloc+0xf6>
					ni=arr_add[k].end-i;
  801d7c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d7f:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d89:	29 c2                	sub    %eax,%edx
  801d8b:	89 d0                	mov    %edx,%eax
  801d8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801d90:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801d97:	eb 0d                	jmp    801da6 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801d99:	ff 45 d8             	incl   -0x28(%ebp)
  801d9c:	a1 28 40 80 00       	mov    0x804028,%eax
  801da1:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801da4:	7c b4                	jl     801d5a <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801da6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801daa:	74 09                	je     801db5 <malloc+0x112>
				flag0=0;
  801dac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801db3:	eb 16                	jmp    801dcb <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801db5:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801dbc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	01 c2                	add    %eax,%edx
  801dc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dc7:	39 c2                	cmp    %eax,%edx
  801dc9:	77 86                	ja     801d51 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801dcb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dcf:	0f 84 a2 00 00 00    	je     801e77 <malloc+0x1d4>

			int f=1;
  801dd5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801ddc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ddf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801de2:	89 c8                	mov    %ecx,%eax
  801de4:	01 c0                	add    %eax,%eax
  801de6:	01 c8                	add    %ecx,%eax
  801de8:	c1 e0 02             	shl    $0x2,%eax
  801deb:	05 20 41 80 00       	add    $0x804120,%eax
  801df0:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801df2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801dfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dfe:	89 d0                	mov    %edx,%eax
  801e00:	01 c0                	add    %eax,%eax
  801e02:	01 d0                	add    %edx,%eax
  801e04:	c1 e0 02             	shl    $0x2,%eax
  801e07:	05 24 41 80 00       	add    $0x804124,%eax
  801e0c:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801e0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e11:	89 d0                	mov    %edx,%eax
  801e13:	01 c0                	add    %eax,%eax
  801e15:	01 d0                	add    %edx,%eax
  801e17:	c1 e0 02             	shl    $0x2,%eax
  801e1a:	05 28 41 80 00       	add    $0x804128,%eax
  801e1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801e25:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801e28:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801e2f:	eb 36                	jmp    801e67 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801e31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	01 c2                	add    %eax,%edx
  801e39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e3c:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801e43:	39 c2                	cmp    %eax,%edx
  801e45:	73 1d                	jae    801e64 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801e47:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e4a:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801e51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e54:	29 c2                	sub    %eax,%edx
  801e56:	89 d0                	mov    %edx,%eax
  801e58:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801e5b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801e62:	eb 0d                	jmp    801e71 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801e64:	ff 45 d0             	incl   -0x30(%ebp)
  801e67:	a1 28 40 80 00       	mov    0x804028,%eax
  801e6c:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801e6f:	7c c0                	jl     801e31 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801e71:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801e75:	75 1d                	jne    801e94 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801e77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e81:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801e84:	a1 04 40 80 00       	mov    0x804004,%eax
  801e89:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e8c:	0f 8c b0 fe ff ff    	jl     801d42 <malloc+0x9f>
  801e92:	eb 01                	jmp    801e95 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801e94:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801e95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e99:	75 7a                	jne    801f15 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801e9b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	01 d0                	add    %edx,%eax
  801ea6:	48                   	dec    %eax
  801ea7:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801eac:	7c 0a                	jl     801eb8 <malloc+0x215>
			return NULL;
  801eae:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb3:	e9 a4 02 00 00       	jmp    80215c <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801eb8:	a1 04 40 80 00       	mov    0x804004,%eax
  801ebd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801ec0:	a1 28 40 80 00       	mov    0x804028,%eax
  801ec5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801ec8:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801ecf:	83 ec 08             	sub    $0x8,%esp
  801ed2:	ff 75 08             	pushl  0x8(%ebp)
  801ed5:	ff 75 a4             	pushl  -0x5c(%ebp)
  801ed8:	e8 04 06 00 00       	call   8024e1 <sys_allocateMem>
  801edd:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801ee0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	01 d0                	add    %edx,%eax
  801eeb:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801ef0:	a1 28 40 80 00       	mov    0x804028,%eax
  801ef5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801efb:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801f02:	a1 28 40 80 00       	mov    0x804028,%eax
  801f07:	40                   	inc    %eax
  801f08:	a3 28 40 80 00       	mov    %eax,0x804028

			return (void*)s;
  801f0d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801f10:	e9 47 02 00 00       	jmp    80215c <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801f15:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801f1c:	e9 ac 00 00 00       	jmp    801fcd <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801f21:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801f24:	89 d0                	mov    %edx,%eax
  801f26:	01 c0                	add    %eax,%eax
  801f28:	01 d0                	add    %edx,%eax
  801f2a:	c1 e0 02             	shl    $0x2,%eax
  801f2d:	05 24 41 80 00       	add    $0x804124,%eax
  801f32:	8b 00                	mov    (%eax),%eax
  801f34:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801f37:	eb 7e                	jmp    801fb7 <malloc+0x314>
			int flag=0;
  801f39:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801f40:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801f47:	eb 57                	jmp    801fa0 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801f49:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f4c:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801f53:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f56:	39 c2                	cmp    %eax,%edx
  801f58:	77 1a                	ja     801f74 <malloc+0x2d1>
  801f5a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f5d:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801f64:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f67:	39 c2                	cmp    %eax,%edx
  801f69:	76 09                	jbe    801f74 <malloc+0x2d1>
								flag=1;
  801f6b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801f72:	eb 36                	jmp    801faa <malloc+0x307>
			arr[i].space++;
  801f74:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801f77:	89 d0                	mov    %edx,%eax
  801f79:	01 c0                	add    %eax,%eax
  801f7b:	01 d0                	add    %edx,%eax
  801f7d:	c1 e0 02             	shl    $0x2,%eax
  801f80:	05 28 41 80 00       	add    $0x804128,%eax
  801f85:	8b 00                	mov    (%eax),%eax
  801f87:	8d 48 01             	lea    0x1(%eax),%ecx
  801f8a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801f8d:	89 d0                	mov    %edx,%eax
  801f8f:	01 c0                	add    %eax,%eax
  801f91:	01 d0                	add    %edx,%eax
  801f93:	c1 e0 02             	shl    $0x2,%eax
  801f96:	05 28 41 80 00       	add    $0x804128,%eax
  801f9b:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801f9d:	ff 45 c0             	incl   -0x40(%ebp)
  801fa0:	a1 28 40 80 00       	mov    0x804028,%eax
  801fa5:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801fa8:	7c 9f                	jl     801f49 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801faa:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801fae:	75 19                	jne    801fc9 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801fb0:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801fb7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801fba:	a1 04 40 80 00       	mov    0x804004,%eax
  801fbf:	39 c2                	cmp    %eax,%edx
  801fc1:	0f 82 72 ff ff ff    	jb     801f39 <malloc+0x296>
  801fc7:	eb 01                	jmp    801fca <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801fc9:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801fca:	ff 45 cc             	incl   -0x34(%ebp)
  801fcd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fd0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801fd3:	0f 8c 48 ff ff ff    	jl     801f21 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801fd9:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801fe0:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801fe7:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801fee:	eb 37                	jmp    802027 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801ff0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801ff3:	89 d0                	mov    %edx,%eax
  801ff5:	01 c0                	add    %eax,%eax
  801ff7:	01 d0                	add    %edx,%eax
  801ff9:	c1 e0 02             	shl    $0x2,%eax
  801ffc:	05 28 41 80 00       	add    $0x804128,%eax
  802001:	8b 00                	mov    (%eax),%eax
  802003:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802006:	7d 1c                	jge    802024 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  802008:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80200b:	89 d0                	mov    %edx,%eax
  80200d:	01 c0                	add    %eax,%eax
  80200f:	01 d0                	add    %edx,%eax
  802011:	c1 e0 02             	shl    $0x2,%eax
  802014:	05 28 41 80 00       	add    $0x804128,%eax
  802019:	8b 00                	mov    (%eax),%eax
  80201b:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  80201e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802021:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  802024:	ff 45 b4             	incl   -0x4c(%ebp)
  802027:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80202a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80202d:	7c c1                	jl     801ff0 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  80202f:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802035:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  802038:	89 c8                	mov    %ecx,%eax
  80203a:	01 c0                	add    %eax,%eax
  80203c:	01 c8                	add    %ecx,%eax
  80203e:	c1 e0 02             	shl    $0x2,%eax
  802041:	05 20 41 80 00       	add    $0x804120,%eax
  802046:	8b 00                	mov    (%eax),%eax
  802048:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  80204f:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802055:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  802058:	89 c8                	mov    %ecx,%eax
  80205a:	01 c0                	add    %eax,%eax
  80205c:	01 c8                	add    %ecx,%eax
  80205e:	c1 e0 02             	shl    $0x2,%eax
  802061:	05 24 41 80 00       	add    $0x804124,%eax
  802066:	8b 00                	mov    (%eax),%eax
  802068:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  80206f:	a1 28 40 80 00       	mov    0x804028,%eax
  802074:	40                   	inc    %eax
  802075:	a3 28 40 80 00       	mov    %eax,0x804028


		sys_allocateMem(arr[index].start,size);
  80207a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80207d:	89 d0                	mov    %edx,%eax
  80207f:	01 c0                	add    %eax,%eax
  802081:	01 d0                	add    %edx,%eax
  802083:	c1 e0 02             	shl    $0x2,%eax
  802086:	05 20 41 80 00       	add    $0x804120,%eax
  80208b:	8b 00                	mov    (%eax),%eax
  80208d:	83 ec 08             	sub    $0x8,%esp
  802090:	ff 75 08             	pushl  0x8(%ebp)
  802093:	50                   	push   %eax
  802094:	e8 48 04 00 00       	call   8024e1 <sys_allocateMem>
  802099:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  80209c:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8020a3:	eb 78                	jmp    80211d <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8020a5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8020a8:	89 d0                	mov    %edx,%eax
  8020aa:	01 c0                	add    %eax,%eax
  8020ac:	01 d0                	add    %edx,%eax
  8020ae:	c1 e0 02             	shl    $0x2,%eax
  8020b1:	05 20 41 80 00       	add    $0x804120,%eax
  8020b6:	8b 00                	mov    (%eax),%eax
  8020b8:	83 ec 04             	sub    $0x4,%esp
  8020bb:	50                   	push   %eax
  8020bc:	ff 75 b0             	pushl  -0x50(%ebp)
  8020bf:	68 70 32 80 00       	push   $0x803270
  8020c4:	e8 50 ee ff ff       	call   800f19 <cprintf>
  8020c9:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8020cc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8020cf:	89 d0                	mov    %edx,%eax
  8020d1:	01 c0                	add    %eax,%eax
  8020d3:	01 d0                	add    %edx,%eax
  8020d5:	c1 e0 02             	shl    $0x2,%eax
  8020d8:	05 24 41 80 00       	add    $0x804124,%eax
  8020dd:	8b 00                	mov    (%eax),%eax
  8020df:	83 ec 04             	sub    $0x4,%esp
  8020e2:	50                   	push   %eax
  8020e3:	ff 75 b0             	pushl  -0x50(%ebp)
  8020e6:	68 85 32 80 00       	push   $0x803285
  8020eb:	e8 29 ee ff ff       	call   800f19 <cprintf>
  8020f0:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  8020f3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8020f6:	89 d0                	mov    %edx,%eax
  8020f8:	01 c0                	add    %eax,%eax
  8020fa:	01 d0                	add    %edx,%eax
  8020fc:	c1 e0 02             	shl    $0x2,%eax
  8020ff:	05 28 41 80 00       	add    $0x804128,%eax
  802104:	8b 00                	mov    (%eax),%eax
  802106:	83 ec 04             	sub    $0x4,%esp
  802109:	50                   	push   %eax
  80210a:	ff 75 b0             	pushl  -0x50(%ebp)
  80210d:	68 98 32 80 00       	push   $0x803298
  802112:	e8 02 ee ff ff       	call   800f19 <cprintf>
  802117:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  80211a:	ff 45 b0             	incl   -0x50(%ebp)
  80211d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802120:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802123:	7c 80                	jl     8020a5 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  802125:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802128:	89 d0                	mov    %edx,%eax
  80212a:	01 c0                	add    %eax,%eax
  80212c:	01 d0                	add    %edx,%eax
  80212e:	c1 e0 02             	shl    $0x2,%eax
  802131:	05 20 41 80 00       	add    $0x804120,%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	83 ec 08             	sub    $0x8,%esp
  80213b:	50                   	push   %eax
  80213c:	68 ac 32 80 00       	push   $0x8032ac
  802141:	e8 d3 ed ff ff       	call   800f19 <cprintf>
  802146:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  802149:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80214c:	89 d0                	mov    %edx,%eax
  80214e:	01 c0                	add    %eax,%eax
  802150:	01 d0                	add    %edx,%eax
  802152:	c1 e0 02             	shl    $0x2,%eax
  802155:	05 20 41 80 00       	add    $0x804120,%eax
  80215a:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  80216a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802171:	eb 4b                	jmp    8021be <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  802173:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802176:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  80217d:	89 c2                	mov    %eax,%edx
  80217f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802182:	39 c2                	cmp    %eax,%edx
  802184:	7f 35                	jg     8021bb <free+0x5d>
  802186:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802189:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  802190:	89 c2                	mov    %eax,%edx
  802192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802195:	39 c2                	cmp    %eax,%edx
  802197:	7e 22                	jle    8021bb <free+0x5d>
				start=arr_add[i].start;
  802199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219c:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  8021a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8021a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a9:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  8021b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8021b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8021b9:	eb 0d                	jmp    8021c8 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8021bb:	ff 45 ec             	incl   -0x14(%ebp)
  8021be:	a1 28 40 80 00       	mov    0x804028,%eax
  8021c3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8021c6:	7c ab                	jl     802173 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8021c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cb:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  8021d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d5:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  8021dc:	29 c2                	sub    %eax,%edx
  8021de:	89 d0                	mov    %edx,%eax
  8021e0:	83 ec 08             	sub    $0x8,%esp
  8021e3:	50                   	push   %eax
  8021e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e7:	e8 d9 02 00 00       	call   8024c5 <sys_freeMem>
  8021ec:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  8021ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021f5:	eb 2d                	jmp    802224 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  8021f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021fa:	40                   	inc    %eax
  8021fb:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  802202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802205:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  80220c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80220f:	40                   	inc    %eax
  802210:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  802217:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80221a:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  802221:	ff 45 e8             	incl   -0x18(%ebp)
  802224:	a1 28 40 80 00       	mov    0x804028,%eax
  802229:	48                   	dec    %eax
  80222a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80222d:	7f c8                	jg     8021f7 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  80222f:	a1 28 40 80 00       	mov    0x804028,%eax
  802234:	48                   	dec    %eax
  802235:	a3 28 40 80 00       	mov    %eax,0x804028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  80223a:	90                   	nop
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	83 ec 18             	sub    $0x18,%esp
  802243:	8b 45 10             	mov    0x10(%ebp),%eax
  802246:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  802249:	83 ec 04             	sub    $0x4,%esp
  80224c:	68 c8 32 80 00       	push   $0x8032c8
  802251:	68 18 01 00 00       	push   $0x118
  802256:	68 eb 32 80 00       	push   $0x8032eb
  80225b:	e8 17 ea ff ff       	call   800c77 <_panic>

00802260 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802266:	83 ec 04             	sub    $0x4,%esp
  802269:	68 c8 32 80 00       	push   $0x8032c8
  80226e:	68 1e 01 00 00       	push   $0x11e
  802273:	68 eb 32 80 00       	push   $0x8032eb
  802278:	e8 fa e9 ff ff       	call   800c77 <_panic>

0080227d <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802283:	83 ec 04             	sub    $0x4,%esp
  802286:	68 c8 32 80 00       	push   $0x8032c8
  80228b:	68 24 01 00 00       	push   $0x124
  802290:	68 eb 32 80 00       	push   $0x8032eb
  802295:	e8 dd e9 ff ff       	call   800c77 <_panic>

0080229a <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8022a0:	83 ec 04             	sub    $0x4,%esp
  8022a3:	68 c8 32 80 00       	push   $0x8032c8
  8022a8:	68 29 01 00 00       	push   $0x129
  8022ad:	68 eb 32 80 00       	push   $0x8032eb
  8022b2:	e8 c0 e9 ff ff       	call   800c77 <_panic>

008022b7 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
  8022ba:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8022bd:	83 ec 04             	sub    $0x4,%esp
  8022c0:	68 c8 32 80 00       	push   $0x8032c8
  8022c5:	68 2f 01 00 00       	push   $0x12f
  8022ca:	68 eb 32 80 00       	push   $0x8032eb
  8022cf:	e8 a3 e9 ff ff       	call   800c77 <_panic>

008022d4 <shrink>:
}
void shrink(uint32 newSize)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
  8022d7:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8022da:	83 ec 04             	sub    $0x4,%esp
  8022dd:	68 c8 32 80 00       	push   $0x8032c8
  8022e2:	68 33 01 00 00       	push   $0x133
  8022e7:	68 eb 32 80 00       	push   $0x8032eb
  8022ec:	e8 86 e9 ff ff       	call   800c77 <_panic>

008022f1 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8022f7:	83 ec 04             	sub    $0x4,%esp
  8022fa:	68 c8 32 80 00       	push   $0x8032c8
  8022ff:	68 38 01 00 00       	push   $0x138
  802304:	68 eb 32 80 00       	push   $0x8032eb
  802309:	e8 69 e9 ff ff       	call   800c77 <_panic>

0080230e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	57                   	push   %edi
  802312:	56                   	push   %esi
  802313:	53                   	push   %ebx
  802314:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802320:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802323:	8b 7d 18             	mov    0x18(%ebp),%edi
  802326:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802329:	cd 30                	int    $0x30
  80232b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80232e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802331:	83 c4 10             	add    $0x10,%esp
  802334:	5b                   	pop    %ebx
  802335:	5e                   	pop    %esi
  802336:	5f                   	pop    %edi
  802337:	5d                   	pop    %ebp
  802338:	c3                   	ret    

00802339 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	83 ec 04             	sub    $0x4,%esp
  80233f:	8b 45 10             	mov    0x10(%ebp),%eax
  802342:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802345:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	52                   	push   %edx
  802351:	ff 75 0c             	pushl  0xc(%ebp)
  802354:	50                   	push   %eax
  802355:	6a 00                	push   $0x0
  802357:	e8 b2 ff ff ff       	call   80230e <syscall>
  80235c:	83 c4 18             	add    $0x18,%esp
}
  80235f:	90                   	nop
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <sys_cgetc>:

int
sys_cgetc(void)
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 01                	push   $0x1
  802371:	e8 98 ff ff ff       	call   80230e <syscall>
  802376:	83 c4 18             	add    $0x18,%esp
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	50                   	push   %eax
  80238a:	6a 05                	push   $0x5
  80238c:	e8 7d ff ff ff       	call   80230e <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 02                	push   $0x2
  8023a5:	e8 64 ff ff ff       	call   80230e <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
}
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    

008023af <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 03                	push   $0x3
  8023be:	e8 4b ff ff ff       	call   80230e <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 04                	push   $0x4
  8023d7:	e8 32 ff ff ff       	call   80230e <syscall>
  8023dc:	83 c4 18             	add    $0x18,%esp
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <sys_env_exit>:


void sys_env_exit(void)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 06                	push   $0x6
  8023f0:	e8 19 ff ff ff       	call   80230e <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
}
  8023f8:	90                   	nop
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	52                   	push   %edx
  80240b:	50                   	push   %eax
  80240c:	6a 07                	push   $0x7
  80240e:	e8 fb fe ff ff       	call   80230e <syscall>
  802413:	83 c4 18             	add    $0x18,%esp
}
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
  80241b:	56                   	push   %esi
  80241c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80241d:	8b 75 18             	mov    0x18(%ebp),%esi
  802420:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802423:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802426:	8b 55 0c             	mov    0xc(%ebp),%edx
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	56                   	push   %esi
  80242d:	53                   	push   %ebx
  80242e:	51                   	push   %ecx
  80242f:	52                   	push   %edx
  802430:	50                   	push   %eax
  802431:	6a 08                	push   $0x8
  802433:	e8 d6 fe ff ff       	call   80230e <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
}
  80243b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80243e:	5b                   	pop    %ebx
  80243f:	5e                   	pop    %esi
  802440:	5d                   	pop    %ebp
  802441:	c3                   	ret    

00802442 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802445:	8b 55 0c             	mov    0xc(%ebp),%edx
  802448:	8b 45 08             	mov    0x8(%ebp),%eax
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	52                   	push   %edx
  802452:	50                   	push   %eax
  802453:	6a 09                	push   $0x9
  802455:	e8 b4 fe ff ff       	call   80230e <syscall>
  80245a:	83 c4 18             	add    $0x18,%esp
}
  80245d:	c9                   	leave  
  80245e:	c3                   	ret    

0080245f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	ff 75 0c             	pushl  0xc(%ebp)
  80246b:	ff 75 08             	pushl  0x8(%ebp)
  80246e:	6a 0a                	push   $0xa
  802470:	e8 99 fe ff ff       	call   80230e <syscall>
  802475:	83 c4 18             	add    $0x18,%esp
}
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 0b                	push   $0xb
  802489:	e8 80 fe ff ff       	call   80230e <syscall>
  80248e:	83 c4 18             	add    $0x18,%esp
}
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 0c                	push   $0xc
  8024a2:	e8 67 fe ff ff       	call   80230e <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 0d                	push   $0xd
  8024bb:	e8 4e fe ff ff       	call   80230e <syscall>
  8024c0:	83 c4 18             	add    $0x18,%esp
}
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    

008024c5 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	ff 75 0c             	pushl  0xc(%ebp)
  8024d1:	ff 75 08             	pushl  0x8(%ebp)
  8024d4:	6a 11                	push   $0x11
  8024d6:	e8 33 fe ff ff       	call   80230e <syscall>
  8024db:	83 c4 18             	add    $0x18,%esp
	return;
  8024de:	90                   	nop
}
  8024df:	c9                   	leave  
  8024e0:	c3                   	ret    

008024e1 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	ff 75 0c             	pushl  0xc(%ebp)
  8024ed:	ff 75 08             	pushl  0x8(%ebp)
  8024f0:	6a 12                	push   $0x12
  8024f2:	e8 17 fe ff ff       	call   80230e <syscall>
  8024f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8024fa:	90                   	nop
}
  8024fb:	c9                   	leave  
  8024fc:	c3                   	ret    

008024fd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024fd:	55                   	push   %ebp
  8024fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 0e                	push   $0xe
  80250c:	e8 fd fd ff ff       	call   80230e <syscall>
  802511:	83 c4 18             	add    $0x18,%esp
}
  802514:	c9                   	leave  
  802515:	c3                   	ret    

00802516 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	ff 75 08             	pushl  0x8(%ebp)
  802524:	6a 0f                	push   $0xf
  802526:	e8 e3 fd ff ff       	call   80230e <syscall>
  80252b:	83 c4 18             	add    $0x18,%esp
}
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 10                	push   $0x10
  80253f:	e8 ca fd ff ff       	call   80230e <syscall>
  802544:	83 c4 18             	add    $0x18,%esp
}
  802547:	90                   	nop
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 14                	push   $0x14
  802559:	e8 b0 fd ff ff       	call   80230e <syscall>
  80255e:	83 c4 18             	add    $0x18,%esp
}
  802561:	90                   	nop
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	6a 15                	push   $0x15
  802573:	e8 96 fd ff ff       	call   80230e <syscall>
  802578:	83 c4 18             	add    $0x18,%esp
}
  80257b:	90                   	nop
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    

0080257e <sys_cputc>:


void
sys_cputc(const char c)
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
  802581:	83 ec 04             	sub    $0x4,%esp
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80258a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	50                   	push   %eax
  802597:	6a 16                	push   $0x16
  802599:	e8 70 fd ff ff       	call   80230e <syscall>
  80259e:	83 c4 18             	add    $0x18,%esp
}
  8025a1:	90                   	nop
  8025a2:	c9                   	leave  
  8025a3:	c3                   	ret    

008025a4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8025a4:	55                   	push   %ebp
  8025a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 17                	push   $0x17
  8025b3:	e8 56 fd ff ff       	call   80230e <syscall>
  8025b8:	83 c4 18             	add    $0x18,%esp
}
  8025bb:	90                   	nop
  8025bc:	c9                   	leave  
  8025bd:	c3                   	ret    

008025be <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8025be:	55                   	push   %ebp
  8025bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	ff 75 0c             	pushl  0xc(%ebp)
  8025cd:	50                   	push   %eax
  8025ce:	6a 18                	push   $0x18
  8025d0:	e8 39 fd ff ff       	call   80230e <syscall>
  8025d5:	83 c4 18             	add    $0x18,%esp
}
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	52                   	push   %edx
  8025ea:	50                   	push   %eax
  8025eb:	6a 1b                	push   $0x1b
  8025ed:	e8 1c fd ff ff       	call   80230e <syscall>
  8025f2:	83 c4 18             	add    $0x18,%esp
}
  8025f5:	c9                   	leave  
  8025f6:	c3                   	ret    

008025f7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	52                   	push   %edx
  802607:	50                   	push   %eax
  802608:	6a 19                	push   $0x19
  80260a:	e8 ff fc ff ff       	call   80230e <syscall>
  80260f:	83 c4 18             	add    $0x18,%esp
}
  802612:	90                   	nop
  802613:	c9                   	leave  
  802614:	c3                   	ret    

00802615 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802615:	55                   	push   %ebp
  802616:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802618:	8b 55 0c             	mov    0xc(%ebp),%edx
  80261b:	8b 45 08             	mov    0x8(%ebp),%eax
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	52                   	push   %edx
  802625:	50                   	push   %eax
  802626:	6a 1a                	push   $0x1a
  802628:	e8 e1 fc ff ff       	call   80230e <syscall>
  80262d:	83 c4 18             	add    $0x18,%esp
}
  802630:	90                   	nop
  802631:	c9                   	leave  
  802632:	c3                   	ret    

00802633 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
  802636:	83 ec 04             	sub    $0x4,%esp
  802639:	8b 45 10             	mov    0x10(%ebp),%eax
  80263c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80263f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802642:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	6a 00                	push   $0x0
  80264b:	51                   	push   %ecx
  80264c:	52                   	push   %edx
  80264d:	ff 75 0c             	pushl  0xc(%ebp)
  802650:	50                   	push   %eax
  802651:	6a 1c                	push   $0x1c
  802653:	e8 b6 fc ff ff       	call   80230e <syscall>
  802658:	83 c4 18             	add    $0x18,%esp
}
  80265b:	c9                   	leave  
  80265c:	c3                   	ret    

0080265d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802660:	8b 55 0c             	mov    0xc(%ebp),%edx
  802663:	8b 45 08             	mov    0x8(%ebp),%eax
  802666:	6a 00                	push   $0x0
  802668:	6a 00                	push   $0x0
  80266a:	6a 00                	push   $0x0
  80266c:	52                   	push   %edx
  80266d:	50                   	push   %eax
  80266e:	6a 1d                	push   $0x1d
  802670:	e8 99 fc ff ff       	call   80230e <syscall>
  802675:	83 c4 18             	add    $0x18,%esp
}
  802678:	c9                   	leave  
  802679:	c3                   	ret    

0080267a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80267a:	55                   	push   %ebp
  80267b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80267d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802680:	8b 55 0c             	mov    0xc(%ebp),%edx
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	51                   	push   %ecx
  80268b:	52                   	push   %edx
  80268c:	50                   	push   %eax
  80268d:	6a 1e                	push   $0x1e
  80268f:	e8 7a fc ff ff       	call   80230e <syscall>
  802694:	83 c4 18             	add    $0x18,%esp
}
  802697:	c9                   	leave  
  802698:	c3                   	ret    

00802699 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802699:	55                   	push   %ebp
  80269a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80269c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269f:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a2:	6a 00                	push   $0x0
  8026a4:	6a 00                	push   $0x0
  8026a6:	6a 00                	push   $0x0
  8026a8:	52                   	push   %edx
  8026a9:	50                   	push   %eax
  8026aa:	6a 1f                	push   $0x1f
  8026ac:	e8 5d fc ff ff       	call   80230e <syscall>
  8026b1:	83 c4 18             	add    $0x18,%esp
}
  8026b4:	c9                   	leave  
  8026b5:	c3                   	ret    

008026b6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 20                	push   $0x20
  8026c5:	e8 44 fc ff ff       	call   80230e <syscall>
  8026ca:	83 c4 18             	add    $0x18,%esp
}
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    

008026cf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d5:	6a 00                	push   $0x0
  8026d7:	ff 75 14             	pushl  0x14(%ebp)
  8026da:	ff 75 10             	pushl  0x10(%ebp)
  8026dd:	ff 75 0c             	pushl  0xc(%ebp)
  8026e0:	50                   	push   %eax
  8026e1:	6a 21                	push   $0x21
  8026e3:	e8 26 fc ff ff       	call   80230e <syscall>
  8026e8:	83 c4 18             	add    $0x18,%esp
}
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 00                	push   $0x0
  8026f9:	6a 00                	push   $0x0
  8026fb:	50                   	push   %eax
  8026fc:	6a 22                	push   $0x22
  8026fe:	e8 0b fc ff ff       	call   80230e <syscall>
  802703:	83 c4 18             	add    $0x18,%esp
}
  802706:	90                   	nop
  802707:	c9                   	leave  
  802708:	c3                   	ret    

00802709 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	6a 00                	push   $0x0
  802715:	6a 00                	push   $0x0
  802717:	50                   	push   %eax
  802718:	6a 23                	push   $0x23
  80271a:	e8 ef fb ff ff       	call   80230e <syscall>
  80271f:	83 c4 18             	add    $0x18,%esp
}
  802722:	90                   	nop
  802723:	c9                   	leave  
  802724:	c3                   	ret    

00802725 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802725:	55                   	push   %ebp
  802726:	89 e5                	mov    %esp,%ebp
  802728:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80272b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80272e:	8d 50 04             	lea    0x4(%eax),%edx
  802731:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802734:	6a 00                	push   $0x0
  802736:	6a 00                	push   $0x0
  802738:	6a 00                	push   $0x0
  80273a:	52                   	push   %edx
  80273b:	50                   	push   %eax
  80273c:	6a 24                	push   $0x24
  80273e:	e8 cb fb ff ff       	call   80230e <syscall>
  802743:	83 c4 18             	add    $0x18,%esp
	return result;
  802746:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802749:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80274c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80274f:	89 01                	mov    %eax,(%ecx)
  802751:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	c9                   	leave  
  802758:	c2 04 00             	ret    $0x4

0080275b <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80275b:	55                   	push   %ebp
  80275c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80275e:	6a 00                	push   $0x0
  802760:	6a 00                	push   $0x0
  802762:	ff 75 10             	pushl  0x10(%ebp)
  802765:	ff 75 0c             	pushl  0xc(%ebp)
  802768:	ff 75 08             	pushl  0x8(%ebp)
  80276b:	6a 13                	push   $0x13
  80276d:	e8 9c fb ff ff       	call   80230e <syscall>
  802772:	83 c4 18             	add    $0x18,%esp
	return ;
  802775:	90                   	nop
}
  802776:	c9                   	leave  
  802777:	c3                   	ret    

00802778 <sys_rcr2>:
uint32 sys_rcr2()
{
  802778:	55                   	push   %ebp
  802779:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 00                	push   $0x0
  802781:	6a 00                	push   $0x0
  802783:	6a 00                	push   $0x0
  802785:	6a 25                	push   $0x25
  802787:	e8 82 fb ff ff       	call   80230e <syscall>
  80278c:	83 c4 18             	add    $0x18,%esp
}
  80278f:	c9                   	leave  
  802790:	c3                   	ret    

00802791 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802791:	55                   	push   %ebp
  802792:	89 e5                	mov    %esp,%ebp
  802794:	83 ec 04             	sub    $0x4,%esp
  802797:	8b 45 08             	mov    0x8(%ebp),%eax
  80279a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80279d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	50                   	push   %eax
  8027aa:	6a 26                	push   $0x26
  8027ac:	e8 5d fb ff ff       	call   80230e <syscall>
  8027b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8027b4:	90                   	nop
}
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <rsttst>:
void rsttst()
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8027ba:	6a 00                	push   $0x0
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 28                	push   $0x28
  8027c6:	e8 43 fb ff ff       	call   80230e <syscall>
  8027cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8027ce:	90                   	nop
}
  8027cf:	c9                   	leave  
  8027d0:	c3                   	ret    

008027d1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8027d1:	55                   	push   %ebp
  8027d2:	89 e5                	mov    %esp,%ebp
  8027d4:	83 ec 04             	sub    $0x4,%esp
  8027d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8027da:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8027dd:	8b 55 18             	mov    0x18(%ebp),%edx
  8027e0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027e4:	52                   	push   %edx
  8027e5:	50                   	push   %eax
  8027e6:	ff 75 10             	pushl  0x10(%ebp)
  8027e9:	ff 75 0c             	pushl  0xc(%ebp)
  8027ec:	ff 75 08             	pushl  0x8(%ebp)
  8027ef:	6a 27                	push   $0x27
  8027f1:	e8 18 fb ff ff       	call   80230e <syscall>
  8027f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8027f9:	90                   	nop
}
  8027fa:	c9                   	leave  
  8027fb:	c3                   	ret    

008027fc <chktst>:
void chktst(uint32 n)
{
  8027fc:	55                   	push   %ebp
  8027fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8027ff:	6a 00                	push   $0x0
  802801:	6a 00                	push   $0x0
  802803:	6a 00                	push   $0x0
  802805:	6a 00                	push   $0x0
  802807:	ff 75 08             	pushl  0x8(%ebp)
  80280a:	6a 29                	push   $0x29
  80280c:	e8 fd fa ff ff       	call   80230e <syscall>
  802811:	83 c4 18             	add    $0x18,%esp
	return ;
  802814:	90                   	nop
}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <inctst>:

void inctst()
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80281a:	6a 00                	push   $0x0
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	6a 2a                	push   $0x2a
  802826:	e8 e3 fa ff ff       	call   80230e <syscall>
  80282b:	83 c4 18             	add    $0x18,%esp
	return ;
  80282e:	90                   	nop
}
  80282f:	c9                   	leave  
  802830:	c3                   	ret    

00802831 <gettst>:
uint32 gettst()
{
  802831:	55                   	push   %ebp
  802832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802834:	6a 00                	push   $0x0
  802836:	6a 00                	push   $0x0
  802838:	6a 00                	push   $0x0
  80283a:	6a 00                	push   $0x0
  80283c:	6a 00                	push   $0x0
  80283e:	6a 2b                	push   $0x2b
  802840:	e8 c9 fa ff ff       	call   80230e <syscall>
  802845:	83 c4 18             	add    $0x18,%esp
}
  802848:	c9                   	leave  
  802849:	c3                   	ret    

0080284a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80284a:	55                   	push   %ebp
  80284b:	89 e5                	mov    %esp,%ebp
  80284d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802850:	6a 00                	push   $0x0
  802852:	6a 00                	push   $0x0
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 2c                	push   $0x2c
  80285c:	e8 ad fa ff ff       	call   80230e <syscall>
  802861:	83 c4 18             	add    $0x18,%esp
  802864:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802867:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80286b:	75 07                	jne    802874 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80286d:	b8 01 00 00 00       	mov    $0x1,%eax
  802872:	eb 05                	jmp    802879 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802874:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802879:	c9                   	leave  
  80287a:	c3                   	ret    

0080287b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80287b:	55                   	push   %ebp
  80287c:	89 e5                	mov    %esp,%ebp
  80287e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802881:	6a 00                	push   $0x0
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 2c                	push   $0x2c
  80288d:	e8 7c fa ff ff       	call   80230e <syscall>
  802892:	83 c4 18             	add    $0x18,%esp
  802895:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802898:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80289c:	75 07                	jne    8028a5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80289e:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a3:	eb 05                	jmp    8028aa <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8028a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028aa:	c9                   	leave  
  8028ab:	c3                   	ret    

008028ac <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
  8028af:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028b2:	6a 00                	push   $0x0
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 2c                	push   $0x2c
  8028be:	e8 4b fa ff ff       	call   80230e <syscall>
  8028c3:	83 c4 18             	add    $0x18,%esp
  8028c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8028c9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8028cd:	75 07                	jne    8028d6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8028cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d4:	eb 05                	jmp    8028db <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8028d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028db:	c9                   	leave  
  8028dc:	c3                   	ret    

008028dd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8028dd:	55                   	push   %ebp
  8028de:	89 e5                	mov    %esp,%ebp
  8028e0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028e3:	6a 00                	push   $0x0
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 00                	push   $0x0
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 2c                	push   $0x2c
  8028ef:	e8 1a fa ff ff       	call   80230e <syscall>
  8028f4:	83 c4 18             	add    $0x18,%esp
  8028f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8028fa:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8028fe:	75 07                	jne    802907 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802900:	b8 01 00 00 00       	mov    $0x1,%eax
  802905:	eb 05                	jmp    80290c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802907:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80290c:	c9                   	leave  
  80290d:	c3                   	ret    

0080290e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80290e:	55                   	push   %ebp
  80290f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	6a 00                	push   $0x0
  802919:	ff 75 08             	pushl  0x8(%ebp)
  80291c:	6a 2d                	push   $0x2d
  80291e:	e8 eb f9 ff ff       	call   80230e <syscall>
  802923:	83 c4 18             	add    $0x18,%esp
	return ;
  802926:	90                   	nop
}
  802927:	c9                   	leave  
  802928:	c3                   	ret    

00802929 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802929:	55                   	push   %ebp
  80292a:	89 e5                	mov    %esp,%ebp
  80292c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80292d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802930:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802933:	8b 55 0c             	mov    0xc(%ebp),%edx
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	6a 00                	push   $0x0
  80293b:	53                   	push   %ebx
  80293c:	51                   	push   %ecx
  80293d:	52                   	push   %edx
  80293e:	50                   	push   %eax
  80293f:	6a 2e                	push   $0x2e
  802941:	e8 c8 f9 ff ff       	call   80230e <syscall>
  802946:	83 c4 18             	add    $0x18,%esp
}
  802949:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80294c:	c9                   	leave  
  80294d:	c3                   	ret    

0080294e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802951:	8b 55 0c             	mov    0xc(%ebp),%edx
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	6a 00                	push   $0x0
  802959:	6a 00                	push   $0x0
  80295b:	6a 00                	push   $0x0
  80295d:	52                   	push   %edx
  80295e:	50                   	push   %eax
  80295f:	6a 2f                	push   $0x2f
  802961:	e8 a8 f9 ff ff       	call   80230e <syscall>
  802966:	83 c4 18             	add    $0x18,%esp
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    
  80296b:	90                   	nop

0080296c <__udivdi3>:
  80296c:	55                   	push   %ebp
  80296d:	57                   	push   %edi
  80296e:	56                   	push   %esi
  80296f:	53                   	push   %ebx
  802970:	83 ec 1c             	sub    $0x1c,%esp
  802973:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802977:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80297b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80297f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802983:	89 ca                	mov    %ecx,%edx
  802985:	89 f8                	mov    %edi,%eax
  802987:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80298b:	85 f6                	test   %esi,%esi
  80298d:	75 2d                	jne    8029bc <__udivdi3+0x50>
  80298f:	39 cf                	cmp    %ecx,%edi
  802991:	77 65                	ja     8029f8 <__udivdi3+0x8c>
  802993:	89 fd                	mov    %edi,%ebp
  802995:	85 ff                	test   %edi,%edi
  802997:	75 0b                	jne    8029a4 <__udivdi3+0x38>
  802999:	b8 01 00 00 00       	mov    $0x1,%eax
  80299e:	31 d2                	xor    %edx,%edx
  8029a0:	f7 f7                	div    %edi
  8029a2:	89 c5                	mov    %eax,%ebp
  8029a4:	31 d2                	xor    %edx,%edx
  8029a6:	89 c8                	mov    %ecx,%eax
  8029a8:	f7 f5                	div    %ebp
  8029aa:	89 c1                	mov    %eax,%ecx
  8029ac:	89 d8                	mov    %ebx,%eax
  8029ae:	f7 f5                	div    %ebp
  8029b0:	89 cf                	mov    %ecx,%edi
  8029b2:	89 fa                	mov    %edi,%edx
  8029b4:	83 c4 1c             	add    $0x1c,%esp
  8029b7:	5b                   	pop    %ebx
  8029b8:	5e                   	pop    %esi
  8029b9:	5f                   	pop    %edi
  8029ba:	5d                   	pop    %ebp
  8029bb:	c3                   	ret    
  8029bc:	39 ce                	cmp    %ecx,%esi
  8029be:	77 28                	ja     8029e8 <__udivdi3+0x7c>
  8029c0:	0f bd fe             	bsr    %esi,%edi
  8029c3:	83 f7 1f             	xor    $0x1f,%edi
  8029c6:	75 40                	jne    802a08 <__udivdi3+0x9c>
  8029c8:	39 ce                	cmp    %ecx,%esi
  8029ca:	72 0a                	jb     8029d6 <__udivdi3+0x6a>
  8029cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8029d0:	0f 87 9e 00 00 00    	ja     802a74 <__udivdi3+0x108>
  8029d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029db:	89 fa                	mov    %edi,%edx
  8029dd:	83 c4 1c             	add    $0x1c,%esp
  8029e0:	5b                   	pop    %ebx
  8029e1:	5e                   	pop    %esi
  8029e2:	5f                   	pop    %edi
  8029e3:	5d                   	pop    %ebp
  8029e4:	c3                   	ret    
  8029e5:	8d 76 00             	lea    0x0(%esi),%esi
  8029e8:	31 ff                	xor    %edi,%edi
  8029ea:	31 c0                	xor    %eax,%eax
  8029ec:	89 fa                	mov    %edi,%edx
  8029ee:	83 c4 1c             	add    $0x1c,%esp
  8029f1:	5b                   	pop    %ebx
  8029f2:	5e                   	pop    %esi
  8029f3:	5f                   	pop    %edi
  8029f4:	5d                   	pop    %ebp
  8029f5:	c3                   	ret    
  8029f6:	66 90                	xchg   %ax,%ax
  8029f8:	89 d8                	mov    %ebx,%eax
  8029fa:	f7 f7                	div    %edi
  8029fc:	31 ff                	xor    %edi,%edi
  8029fe:	89 fa                	mov    %edi,%edx
  802a00:	83 c4 1c             	add    $0x1c,%esp
  802a03:	5b                   	pop    %ebx
  802a04:	5e                   	pop    %esi
  802a05:	5f                   	pop    %edi
  802a06:	5d                   	pop    %ebp
  802a07:	c3                   	ret    
  802a08:	bd 20 00 00 00       	mov    $0x20,%ebp
  802a0d:	89 eb                	mov    %ebp,%ebx
  802a0f:	29 fb                	sub    %edi,%ebx
  802a11:	89 f9                	mov    %edi,%ecx
  802a13:	d3 e6                	shl    %cl,%esi
  802a15:	89 c5                	mov    %eax,%ebp
  802a17:	88 d9                	mov    %bl,%cl
  802a19:	d3 ed                	shr    %cl,%ebp
  802a1b:	89 e9                	mov    %ebp,%ecx
  802a1d:	09 f1                	or     %esi,%ecx
  802a1f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802a23:	89 f9                	mov    %edi,%ecx
  802a25:	d3 e0                	shl    %cl,%eax
  802a27:	89 c5                	mov    %eax,%ebp
  802a29:	89 d6                	mov    %edx,%esi
  802a2b:	88 d9                	mov    %bl,%cl
  802a2d:	d3 ee                	shr    %cl,%esi
  802a2f:	89 f9                	mov    %edi,%ecx
  802a31:	d3 e2                	shl    %cl,%edx
  802a33:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a37:	88 d9                	mov    %bl,%cl
  802a39:	d3 e8                	shr    %cl,%eax
  802a3b:	09 c2                	or     %eax,%edx
  802a3d:	89 d0                	mov    %edx,%eax
  802a3f:	89 f2                	mov    %esi,%edx
  802a41:	f7 74 24 0c          	divl   0xc(%esp)
  802a45:	89 d6                	mov    %edx,%esi
  802a47:	89 c3                	mov    %eax,%ebx
  802a49:	f7 e5                	mul    %ebp
  802a4b:	39 d6                	cmp    %edx,%esi
  802a4d:	72 19                	jb     802a68 <__udivdi3+0xfc>
  802a4f:	74 0b                	je     802a5c <__udivdi3+0xf0>
  802a51:	89 d8                	mov    %ebx,%eax
  802a53:	31 ff                	xor    %edi,%edi
  802a55:	e9 58 ff ff ff       	jmp    8029b2 <__udivdi3+0x46>
  802a5a:	66 90                	xchg   %ax,%ax
  802a5c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a60:	89 f9                	mov    %edi,%ecx
  802a62:	d3 e2                	shl    %cl,%edx
  802a64:	39 c2                	cmp    %eax,%edx
  802a66:	73 e9                	jae    802a51 <__udivdi3+0xe5>
  802a68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a6b:	31 ff                	xor    %edi,%edi
  802a6d:	e9 40 ff ff ff       	jmp    8029b2 <__udivdi3+0x46>
  802a72:	66 90                	xchg   %ax,%ax
  802a74:	31 c0                	xor    %eax,%eax
  802a76:	e9 37 ff ff ff       	jmp    8029b2 <__udivdi3+0x46>
  802a7b:	90                   	nop

00802a7c <__umoddi3>:
  802a7c:	55                   	push   %ebp
  802a7d:	57                   	push   %edi
  802a7e:	56                   	push   %esi
  802a7f:	53                   	push   %ebx
  802a80:	83 ec 1c             	sub    $0x1c,%esp
  802a83:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a87:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a8f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a9b:	89 f3                	mov    %esi,%ebx
  802a9d:	89 fa                	mov    %edi,%edx
  802a9f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802aa3:	89 34 24             	mov    %esi,(%esp)
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	75 1a                	jne    802ac4 <__umoddi3+0x48>
  802aaa:	39 f7                	cmp    %esi,%edi
  802aac:	0f 86 a2 00 00 00    	jbe    802b54 <__umoddi3+0xd8>
  802ab2:	89 c8                	mov    %ecx,%eax
  802ab4:	89 f2                	mov    %esi,%edx
  802ab6:	f7 f7                	div    %edi
  802ab8:	89 d0                	mov    %edx,%eax
  802aba:	31 d2                	xor    %edx,%edx
  802abc:	83 c4 1c             	add    $0x1c,%esp
  802abf:	5b                   	pop    %ebx
  802ac0:	5e                   	pop    %esi
  802ac1:	5f                   	pop    %edi
  802ac2:	5d                   	pop    %ebp
  802ac3:	c3                   	ret    
  802ac4:	39 f0                	cmp    %esi,%eax
  802ac6:	0f 87 ac 00 00 00    	ja     802b78 <__umoddi3+0xfc>
  802acc:	0f bd e8             	bsr    %eax,%ebp
  802acf:	83 f5 1f             	xor    $0x1f,%ebp
  802ad2:	0f 84 ac 00 00 00    	je     802b84 <__umoddi3+0x108>
  802ad8:	bf 20 00 00 00       	mov    $0x20,%edi
  802add:	29 ef                	sub    %ebp,%edi
  802adf:	89 fe                	mov    %edi,%esi
  802ae1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ae5:	89 e9                	mov    %ebp,%ecx
  802ae7:	d3 e0                	shl    %cl,%eax
  802ae9:	89 d7                	mov    %edx,%edi
  802aeb:	89 f1                	mov    %esi,%ecx
  802aed:	d3 ef                	shr    %cl,%edi
  802aef:	09 c7                	or     %eax,%edi
  802af1:	89 e9                	mov    %ebp,%ecx
  802af3:	d3 e2                	shl    %cl,%edx
  802af5:	89 14 24             	mov    %edx,(%esp)
  802af8:	89 d8                	mov    %ebx,%eax
  802afa:	d3 e0                	shl    %cl,%eax
  802afc:	89 c2                	mov    %eax,%edx
  802afe:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b02:	d3 e0                	shl    %cl,%eax
  802b04:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b08:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b0c:	89 f1                	mov    %esi,%ecx
  802b0e:	d3 e8                	shr    %cl,%eax
  802b10:	09 d0                	or     %edx,%eax
  802b12:	d3 eb                	shr    %cl,%ebx
  802b14:	89 da                	mov    %ebx,%edx
  802b16:	f7 f7                	div    %edi
  802b18:	89 d3                	mov    %edx,%ebx
  802b1a:	f7 24 24             	mull   (%esp)
  802b1d:	89 c6                	mov    %eax,%esi
  802b1f:	89 d1                	mov    %edx,%ecx
  802b21:	39 d3                	cmp    %edx,%ebx
  802b23:	0f 82 87 00 00 00    	jb     802bb0 <__umoddi3+0x134>
  802b29:	0f 84 91 00 00 00    	je     802bc0 <__umoddi3+0x144>
  802b2f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b33:	29 f2                	sub    %esi,%edx
  802b35:	19 cb                	sbb    %ecx,%ebx
  802b37:	89 d8                	mov    %ebx,%eax
  802b39:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802b3d:	d3 e0                	shl    %cl,%eax
  802b3f:	89 e9                	mov    %ebp,%ecx
  802b41:	d3 ea                	shr    %cl,%edx
  802b43:	09 d0                	or     %edx,%eax
  802b45:	89 e9                	mov    %ebp,%ecx
  802b47:	d3 eb                	shr    %cl,%ebx
  802b49:	89 da                	mov    %ebx,%edx
  802b4b:	83 c4 1c             	add    $0x1c,%esp
  802b4e:	5b                   	pop    %ebx
  802b4f:	5e                   	pop    %esi
  802b50:	5f                   	pop    %edi
  802b51:	5d                   	pop    %ebp
  802b52:	c3                   	ret    
  802b53:	90                   	nop
  802b54:	89 fd                	mov    %edi,%ebp
  802b56:	85 ff                	test   %edi,%edi
  802b58:	75 0b                	jne    802b65 <__umoddi3+0xe9>
  802b5a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b5f:	31 d2                	xor    %edx,%edx
  802b61:	f7 f7                	div    %edi
  802b63:	89 c5                	mov    %eax,%ebp
  802b65:	89 f0                	mov    %esi,%eax
  802b67:	31 d2                	xor    %edx,%edx
  802b69:	f7 f5                	div    %ebp
  802b6b:	89 c8                	mov    %ecx,%eax
  802b6d:	f7 f5                	div    %ebp
  802b6f:	89 d0                	mov    %edx,%eax
  802b71:	e9 44 ff ff ff       	jmp    802aba <__umoddi3+0x3e>
  802b76:	66 90                	xchg   %ax,%ax
  802b78:	89 c8                	mov    %ecx,%eax
  802b7a:	89 f2                	mov    %esi,%edx
  802b7c:	83 c4 1c             	add    $0x1c,%esp
  802b7f:	5b                   	pop    %ebx
  802b80:	5e                   	pop    %esi
  802b81:	5f                   	pop    %edi
  802b82:	5d                   	pop    %ebp
  802b83:	c3                   	ret    
  802b84:	3b 04 24             	cmp    (%esp),%eax
  802b87:	72 06                	jb     802b8f <__umoddi3+0x113>
  802b89:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802b8d:	77 0f                	ja     802b9e <__umoddi3+0x122>
  802b8f:	89 f2                	mov    %esi,%edx
  802b91:	29 f9                	sub    %edi,%ecx
  802b93:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802b97:	89 14 24             	mov    %edx,(%esp)
  802b9a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b9e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802ba2:	8b 14 24             	mov    (%esp),%edx
  802ba5:	83 c4 1c             	add    $0x1c,%esp
  802ba8:	5b                   	pop    %ebx
  802ba9:	5e                   	pop    %esi
  802baa:	5f                   	pop    %edi
  802bab:	5d                   	pop    %ebp
  802bac:	c3                   	ret    
  802bad:	8d 76 00             	lea    0x0(%esi),%esi
  802bb0:	2b 04 24             	sub    (%esp),%eax
  802bb3:	19 fa                	sbb    %edi,%edx
  802bb5:	89 d1                	mov    %edx,%ecx
  802bb7:	89 c6                	mov    %eax,%esi
  802bb9:	e9 71 ff ff ff       	jmp    802b2f <__umoddi3+0xb3>
  802bbe:	66 90                	xchg   %ax,%ax
  802bc0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802bc4:	72 ea                	jb     802bb0 <__umoddi3+0x134>
  802bc6:	89 d9                	mov    %ebx,%ecx
  802bc8:	e9 62 ff ff ff       	jmp    802b2f <__umoddi3+0xb3>
