
obj/user/tst_malloc_4:     file format elf32-i386


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
  800031:	e8 3e 08 00 00       	call   800874 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */
//test allocation of small sizes with large sizes
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 c4 80             	add    $0xffffff80,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;//pointer to page working set array
  800040:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800044:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004b:	eb 23                	jmp    800070 <_main+0x38>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004d:	a1 20 40 80 00       	mov    0x804020,%eax
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
		uint8 fullWS = 1;//pointer to page working set array
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006d:	ff 45 f0             	incl   -0x10(%ebp)
  800070:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800088:	68 20 29 80 00       	push   $0x802920
  80008d:	6a 14                	push   $0x14
  80008f:	68 3c 29 80 00       	push   $0x80293c
  800094:	e8 20 09 00 00       	call   8009b9 <_panic>
	}

	int Mega = 1024*1024;
  800099:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000a0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	void* ptr_allocations[20] = {0};
  8000a7:	8d 55 80             	lea    -0x80(%ebp),%edx
  8000aa:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	89 d7                	mov    %edx,%edi
  8000b6:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 Mega
		int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 ff 20 00 00       	call   8021bc <sys_calculate_free_frames>
  8000bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c0:	e8 7a 21 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  8000c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cb:	01 c0                	add    %eax,%eax
  8000cd:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 0c 19 00 00       	call   8019e5 <malloc>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE))
  8000df:	8b 45 80             	mov    -0x80(%ebp),%eax
  8000e2:	85 c0                	test   %eax,%eax
  8000e4:	79 0a                	jns    8000f0 <_main+0xb8>
  8000e6:	8b 45 80             	mov    -0x80(%ebp),%eax
  8000e9:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  8000ee:	76 14                	jbe    800104 <_main+0xcc>
		{
			panic("Wrong start address for the allocated space... ");
  8000f0:	83 ec 04             	sub    $0x4,%esp
  8000f3:	68 50 29 80 00       	push   $0x802950
  8000f8:	6a 22                	push   $0x22
  8000fa:	68 3c 29 80 00       	push   $0x80293c
  8000ff:	e8 b5 08 00 00       	call   8009b9 <_panic>
		}
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800104:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800107:	e8 b0 20 00 00       	call   8021bc <sys_calculate_free_frames>
  80010c:	29 c3                	sub    %eax,%ebx
  80010e:	89 d8                	mov    %ebx,%eax
  800110:	83 f8 01             	cmp    $0x1,%eax
  800113:	74 14                	je     800129 <_main+0xf1>
  800115:	83 ec 04             	sub    $0x4,%esp
  800118:	68 80 29 80 00       	push   $0x802980
  80011d:	6a 24                	push   $0x24
  80011f:	68 3c 29 80 00       	push   $0x80293c
  800124:	e8 90 08 00 00       	call   8009b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800129:	e8 11 21 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  80012e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800131:	3d 00 02 00 00       	cmp    $0x200,%eax
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 ec 29 80 00       	push   $0x8029ec
  800140:	6a 25                	push   $0x25
  800142:	68 3c 29 80 00       	push   $0x80293c
  800147:	e8 6d 08 00 00       	call   8009b9 <_panic>

		//2 Mega
		freeFrames = sys_calculate_free_frames() ;
  80014c:	e8 6b 20 00 00       	call   8021bc <sys_calculate_free_frames>
  800151:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800154:	e8 e6 20 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  800159:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80015c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015f:	01 c0                	add    %eax,%eax
  800161:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	50                   	push   %eax
  800168:	e8 78 18 00 00       	call   8019e5 <malloc>
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START + 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800173:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800176:	89 c2                	mov    %eax,%edx
  800178:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017b:	01 c0                	add    %eax,%eax
  80017d:	05 00 00 00 80       	add    $0x80000000,%eax
  800182:	39 c2                	cmp    %eax,%edx
  800184:	72 13                	jb     800199 <_main+0x161>
  800186:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800189:	89 c2                	mov    %eax,%edx
  80018b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018e:	01 c0                	add    %eax,%eax
  800190:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	76 14                	jbe    8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 50 29 80 00       	push   $0x802950
  8001a1:	6a 2b                	push   $0x2b
  8001a3:	68 3c 29 80 00       	push   $0x80293c
  8001a8:	e8 0c 08 00 00       	call   8009b9 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001ad:	e8 0a 20 00 00       	call   8021bc <sys_calculate_free_frames>
  8001b2:	89 c2                	mov    %eax,%edx
  8001b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001b7:	39 c2                	cmp    %eax,%edx
  8001b9:	74 14                	je     8001cf <_main+0x197>
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	68 80 29 80 00       	push   $0x802980
  8001c3:	6a 2c                	push   $0x2c
  8001c5:	68 3c 29 80 00       	push   $0x80293c
  8001ca:	e8 ea 07 00 00       	call   8009b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8001cf:	e8 6b 20 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  8001d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001d7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001dc:	74 14                	je     8001f2 <_main+0x1ba>
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	68 ec 29 80 00       	push   $0x8029ec
  8001e6:	6a 2d                	push   $0x2d
  8001e8:	68 3c 29 80 00       	push   $0x80293c
  8001ed:	e8 c7 07 00 00       	call   8009b9 <_panic>

		//1 KB
		//round down the addresses to the nearest page to allow for right node or left node allocation in buddy system
		freeFrames = sys_calculate_free_frames() ;
  8001f2:	e8 c5 1f 00 00       	call   8021bc <sys_calculate_free_frames>
  8001f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001fa:	e8 40 20 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  8001ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(1*kilo);
  800202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	50                   	push   %eax
  800209:	e8 d7 17 00 00       	call   8019e5 <malloc>
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800214:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800217:	e8 a0 1f 00 00       	call   8021bc <sys_calculate_free_frames>
  80021c:	29 c3                	sub    %eax,%ebx
  80021e:	89 d8                	mov    %ebx,%eax
  800220:	83 f8 01             	cmp    $0x1,%eax
  800223:	74 14                	je     800239 <_main+0x201>
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	68 80 29 80 00       	push   $0x802980
  80022d:	6a 34                	push   $0x34
  80022f:	68 3c 29 80 00       	push   $0x80293c
  800234:	e8 80 07 00 00       	call   8009b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800239:	e8 01 20 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  80023e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800241:	83 f8 01             	cmp    $0x1,%eax
  800244:	74 14                	je     80025a <_main+0x222>
  800246:	83 ec 04             	sub    $0x4,%esp
  800249:	68 ec 29 80 00       	push   $0x8029ec
  80024e:	6a 35                	push   $0x35
  800250:	68 3c 29 80 00       	push   $0x80293c
  800255:	e8 5f 07 00 00       	call   8009b9 <_panic>
		freeFrames = sys_calculate_free_frames() ;
  80025a:	e8 5d 1f 00 00       	call   8021bc <sys_calculate_free_frames>
  80025f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800262:	e8 d8 1f 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  800267:	89 45 e0             	mov    %eax,-0x20(%ebp)

		//1 KB
		ptr_allocations[3] = malloc(1*kilo);
  80026a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80026d:	83 ec 0c             	sub    $0xc,%esp
  800270:	50                   	push   %eax
  800271:	e8 6f 17 00 00       	call   8019e5 <malloc>
  800276:	83 c4 10             	add    $0x10,%esp
  800279:	89 45 8c             	mov    %eax,-0x74(%ebp)
		//swap the two addresses if the left node address is not in allocation 2
		if(ptr_allocations[2]>ptr_allocations[3])
  80027c:	8b 55 88             	mov    -0x78(%ebp),%edx
  80027f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800282:	39 c2                	cmp    %eax,%edx
  800284:	76 12                	jbe    800298 <_main+0x260>
		{
			uint32* temp =ptr_allocations[3];
  800286:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800289:	89 45 dc             	mov    %eax,-0x24(%ebp)
			ptr_allocations[3]=ptr_allocations[2];
  80028c:	8b 45 88             	mov    -0x78(%ebp),%eax
  80028f:	89 45 8c             	mov    %eax,-0x74(%ebp)
			ptr_allocations[2]=temp;
  800292:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800295:	89 45 88             	mov    %eax,-0x78(%ebp)
		}
		uint32 start_of_page = ROUNDDOWN((uint32)ptr_allocations[2], PAGE_SIZE);
  800298:	8b 45 88             	mov    -0x78(%ebp),%eax
  80029b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80029e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		//test the address of the first 1 kilo
		if ((uint32)ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8002a9:	8b 45 88             	mov    -0x78(%ebp),%eax
  8002ac:	89 c2                	mov    %eax,%edx
  8002ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b1:	c1 e0 02             	shl    $0x2,%eax
  8002b4:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b9:	39 c2                	cmp    %eax,%edx
  8002bb:	72 14                	jb     8002d1 <_main+0x299>
  8002bd:	8b 45 88             	mov    -0x78(%ebp),%eax
  8002c0:	89 c2                	mov    %eax,%edx
  8002c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c5:	c1 e0 02             	shl    $0x2,%eax
  8002c8:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002cd:	39 c2                	cmp    %eax,%edx
  8002cf:	76 14                	jbe    8002e5 <_main+0x2ad>
  8002d1:	83 ec 04             	sub    $0x4,%esp
  8002d4:	68 50 29 80 00       	push   $0x802950
  8002d9:	6a 44                	push   $0x44
  8002db:	68 3c 29 80 00       	push   $0x80293c
  8002e0:	e8 d4 06 00 00       	call   8009b9 <_panic>
		//test the address of the second 1 kilo
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega+ 1*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8002e5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002e8:	89 c2                	mov    %eax,%edx
  8002ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002ed:	c1 e0 02             	shl    $0x2,%eax
  8002f0:	89 c1                	mov    %eax,%ecx
  8002f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	05 00 00 00 80       	add    $0x80000000,%eax
  8002fc:	39 c2                	cmp    %eax,%edx
  8002fe:	72 14                	jb     800314 <_main+0x2dc>
  800300:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800303:	89 c2                	mov    %eax,%edx
  800305:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800308:	c1 e0 02             	shl    $0x2,%eax
  80030b:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800310:	39 c2                	cmp    %eax,%edx
  800312:	76 14                	jbe    800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 50 29 80 00       	push   $0x802950
  80031c:	6a 46                	push   $0x46
  80031e:	68 3c 29 80 00       	push   $0x80293c
  800323:	e8 91 06 00 00       	call   8009b9 <_panic>

		//2 Bytes
		ptr_allocations[2] = malloc(2);
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	6a 02                	push   $0x2
  80032d:	e8 b3 16 00 00       	call   8019e5 <malloc>
  800332:	83 c4 10             	add    $0x10,%esp
  800335:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800338:	8b 45 88             	mov    -0x78(%ebp),%eax
  80033b:	89 c2                	mov    %eax,%edx
  80033d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800340:	c1 e0 02             	shl    $0x2,%eax
  800343:	05 00 00 00 80       	add    $0x80000000,%eax
  800348:	39 c2                	cmp    %eax,%edx
  80034a:	72 14                	jb     800360 <_main+0x328>
  80034c:	8b 45 88             	mov    -0x78(%ebp),%eax
  80034f:	89 c2                	mov    %eax,%edx
  800351:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800354:	c1 e0 02             	shl    $0x2,%eax
  800357:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80035c:	39 c2                	cmp    %eax,%edx
  80035e:	76 14                	jbe    800374 <_main+0x33c>
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	68 50 29 80 00       	push   $0x802950
  800368:	6a 4a                	push   $0x4a
  80036a:	68 3c 29 80 00       	push   $0x80293c
  80036f:	e8 45 06 00 00       	call   8009b9 <_panic>

		//1023 Bytes
		ptr_allocations[3] = malloc(1023);
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	68 ff 03 00 00       	push   $0x3ff
  80037c:	e8 64 16 00 00       	call   8019e5 <malloc>
  800381:	83 c4 10             	add    $0x10,%esp
  800384:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800387:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80038a:	89 c2                	mov    %eax,%edx
  80038c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80038f:	c1 e0 02             	shl    $0x2,%eax
  800392:	05 00 00 00 80       	add    $0x80000000,%eax
  800397:	39 c2                	cmp    %eax,%edx
  800399:	72 14                	jb     8003af <_main+0x377>
  80039b:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80039e:	89 c2                	mov    %eax,%edx
  8003a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a3:	c1 e0 02             	shl    $0x2,%eax
  8003a6:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	76 14                	jbe    8003c3 <_main+0x38b>
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	68 50 29 80 00       	push   $0x802950
  8003b7:	6a 4e                	push   $0x4e
  8003b9:	68 3c 29 80 00       	push   $0x80293c
  8003be:	e8 f6 05 00 00       	call   8009b9 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003c3:	e8 f4 1d 00 00       	call   8021bc <sys_calculate_free_frames>
  8003c8:	89 c2                	mov    %eax,%edx
  8003ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003cd:	39 c2                	cmp    %eax,%edx
  8003cf:	74 14                	je     8003e5 <_main+0x3ad>
  8003d1:	83 ec 04             	sub    $0x4,%esp
  8003d4:	68 80 29 80 00       	push   $0x802980
  8003d9:	6a 4f                	push   $0x4f
  8003db:	68 3c 29 80 00       	push   $0x80293c
  8003e0:	e8 d4 05 00 00       	call   8009b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003e5:	e8 55 1e 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  8003ea:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003ed:	74 14                	je     800403 <_main+0x3cb>
  8003ef:	83 ec 04             	sub    $0x4,%esp
  8003f2:	68 ec 29 80 00       	push   $0x8029ec
  8003f7:	6a 50                	push   $0x50
  8003f9:	68 3c 29 80 00       	push   $0x80293c
  8003fe:	e8 b6 05 00 00       	call   8009b9 <_panic>

		//NEW PAGE => 2000 Bytes
		freeFrames = sys_calculate_free_frames() ;
  800403:	e8 b4 1d 00 00       	call   8021bc <sys_calculate_free_frames>
  800408:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80040b:	e8 2f 1e 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  800410:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2000);
  800413:	83 ec 0c             	sub    $0xc,%esp
  800416:	68 d0 07 00 00       	push   $0x7d0
  80041b:	e8 c5 15 00 00       	call   8019e5 <malloc>
  800420:	83 c4 10             	add    $0x10,%esp
  800423:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile %d", (freeFrames - sys_calculate_free_frames()));
  800426:	e8 91 1d 00 00       	call   8021bc <sys_calculate_free_frames>
  80042b:	89 c2                	mov    %eax,%edx
  80042d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800430:	39 c2                	cmp    %eax,%edx
  800432:	74 1e                	je     800452 <_main+0x41a>
  800434:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800437:	e8 80 1d 00 00       	call   8021bc <sys_calculate_free_frames>
  80043c:	29 c3                	sub    %eax,%ebx
  80043e:	89 d8                	mov    %ebx,%eax
  800440:	50                   	push   %eax
  800441:	68 1c 2a 80 00       	push   $0x802a1c
  800446:	6a 56                	push   $0x56
  800448:	68 3c 29 80 00       	push   $0x80293c
  80044d:	e8 67 05 00 00       	call   8009b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800452:	e8 e8 1d 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  800457:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80045a:	83 f8 01             	cmp    $0x1,%eax
  80045d:	74 14                	je     800473 <_main+0x43b>
  80045f:	83 ec 04             	sub    $0x4,%esp
  800462:	68 ec 29 80 00       	push   $0x8029ec
  800467:	6a 57                	push   $0x57
  800469:	68 3c 29 80 00       	push   $0x80293c
  80046e:	e8 46 05 00 00       	call   8009b9 <_panic>

		//2048 Bytes
		freeFrames = sys_calculate_free_frames() ;
  800473:	e8 44 1d 00 00       	call   8021bc <sys_calculate_free_frames>
  800478:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80047b:	e8 bf 1d 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  800480:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2048);
  800483:	83 ec 0c             	sub    $0xc,%esp
  800486:	68 00 08 00 00       	push   $0x800
  80048b:	e8 55 15 00 00       	call   8019e5 <malloc>
  800490:	83 c4 10             	add    $0x10,%esp
  800493:	89 45 8c             	mov    %eax,-0x74(%ebp)
		//swap the two addresses if the left node address is not in allocation 2
		if(ptr_allocations[2]>ptr_allocations[3])
  800496:	8b 55 88             	mov    -0x78(%ebp),%edx
  800499:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80049c:	39 c2                	cmp    %eax,%edx
  80049e:	76 12                	jbe    8004b2 <_main+0x47a>
		{
			uint32* temp =ptr_allocations[3];
  8004a0:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[3]=ptr_allocations[2];
  8004a6:	8b 45 88             	mov    -0x78(%ebp),%eax
  8004a9:	89 45 8c             	mov    %eax,-0x74(%ebp)
			ptr_allocations[2]=temp;
  8004ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004af:	89 45 88             	mov    %eax,-0x78(%ebp)
		}
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004b2:	e8 05 1d 00 00       	call   8021bc <sys_calculate_free_frames>
  8004b7:	89 c2                	mov    %eax,%edx
  8004b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004bc:	39 c2                	cmp    %eax,%edx
  8004be:	74 14                	je     8004d4 <_main+0x49c>
  8004c0:	83 ec 04             	sub    $0x4,%esp
  8004c3:	68 80 29 80 00       	push   $0x802980
  8004c8:	6a 64                	push   $0x64
  8004ca:	68 3c 29 80 00       	push   $0x80293c
  8004cf:	e8 e5 04 00 00       	call   8009b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004d4:	e8 66 1d 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  8004d9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <_main+0x4ba>
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 ec 29 80 00       	push   $0x8029ec
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 3c 29 80 00       	push   $0x80293c
  8004ed:	e8 c7 04 00 00       	call   8009b9 <_panic>
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega+ PAGE_SIZE) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8004f2:	8b 45 88             	mov    -0x78(%ebp),%eax
  8004f5:	89 c2                	mov    %eax,%edx
  8004f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004fa:	c1 e0 02             	shl    $0x2,%eax
  8004fd:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800502:	39 c2                	cmp    %eax,%edx
  800504:	72 14                	jb     80051a <_main+0x4e2>
  800506:	8b 45 88             	mov    -0x78(%ebp),%eax
  800509:	89 c2                	mov    %eax,%edx
  80050b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80050e:	c1 e0 02             	shl    $0x2,%eax
  800511:	2d 00 e0 ff 7f       	sub    $0x7fffe000,%eax
  800516:	39 c2                	cmp    %eax,%edx
  800518:	76 14                	jbe    80052e <_main+0x4f6>
  80051a:	83 ec 04             	sub    $0x4,%esp
  80051d:	68 50 29 80 00       	push   $0x802950
  800522:	6a 66                	push   $0x66
  800524:	68 3c 29 80 00       	push   $0x80293c
  800529:	e8 8b 04 00 00       	call   8009b9 <_panic>
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega+ PAGE_SIZE + 2*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + PAGE_SIZE + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80052e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800531:	89 c2                	mov    %eax,%edx
  800533:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800536:	c1 e0 02             	shl    $0x2,%eax
  800539:	89 c1                	mov    %eax,%ecx
  80053b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80053e:	01 c0                	add    %eax,%eax
  800540:	01 c8                	add    %ecx,%eax
  800542:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800547:	39 c2                	cmp    %eax,%edx
  800549:	72 14                	jb     80055f <_main+0x527>
  80054b:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80054e:	89 c2                	mov    %eax,%edx
  800550:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800553:	c1 e0 02             	shl    $0x2,%eax
  800556:	2d 00 e0 ff 7f       	sub    $0x7fffe000,%eax
  80055b:	39 c2                	cmp    %eax,%edx
  80055d:	76 14                	jbe    800573 <_main+0x53b>
  80055f:	83 ec 04             	sub    $0x4,%esp
  800562:	68 50 29 80 00       	push   $0x802950
  800567:	6a 67                	push   $0x67
  800569:	68 3c 29 80 00       	push   $0x80293c
  80056e:	e8 46 04 00 00       	call   8009b9 <_panic>

		//7 Kilo
		freeFrames = sys_calculate_free_frames() ;
  800573:	e8 44 1c 00 00       	call   8021bc <sys_calculate_free_frames>
  800578:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80057b:	e8 bf 1c 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  800580:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800583:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800586:	89 d0                	mov    %edx,%eax
  800588:	01 c0                	add    %eax,%eax
  80058a:	01 d0                	add    %edx,%eax
  80058c:	01 c0                	add    %eax,%eax
  80058e:	01 d0                	add    %edx,%eax
  800590:	83 ec 0c             	sub    $0xc,%esp
  800593:	50                   	push   %eax
  800594:	e8 4c 14 00 00       	call   8019e5 <malloc>
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 2*PAGE_SIZE) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + 2*PAGE_SIZE + 2*PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80059f:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005a2:	89 c2                	mov    %eax,%edx
  8005a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a7:	c1 e0 02             	shl    $0x2,%eax
  8005aa:	2d 00 e0 ff 7f       	sub    $0x7fffe000,%eax
  8005af:	39 c2                	cmp    %eax,%edx
  8005b1:	72 14                	jb     8005c7 <_main+0x58f>
  8005b3:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005b6:	89 c2                	mov    %eax,%edx
  8005b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005bb:	c1 e0 02             	shl    $0x2,%eax
  8005be:	2d 00 c0 ff 7f       	sub    $0x7fffc000,%eax
  8005c3:	39 c2                	cmp    %eax,%edx
  8005c5:	76 14                	jbe    8005db <_main+0x5a3>
  8005c7:	83 ec 04             	sub    $0x4,%esp
  8005ca:	68 50 29 80 00       	push   $0x802950
  8005cf:	6a 6d                	push   $0x6d
  8005d1:	68 3c 29 80 00       	push   $0x80293c
  8005d6:	e8 de 03 00 00       	call   8009b9 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8005db:	e8 dc 1b 00 00       	call   8021bc <sys_calculate_free_frames>
  8005e0:	89 c2                	mov    %eax,%edx
  8005e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005e5:	39 c2                	cmp    %eax,%edx
  8005e7:	74 14                	je     8005fd <_main+0x5c5>
  8005e9:	83 ec 04             	sub    $0x4,%esp
  8005ec:	68 80 29 80 00       	push   $0x802980
  8005f1:	6a 6e                	push   $0x6e
  8005f3:	68 3c 29 80 00       	push   $0x80293c
  8005f8:	e8 bc 03 00 00       	call   8009b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  8005fd:	e8 3d 1c 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  800602:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800605:	83 f8 02             	cmp    $0x2,%eax
  800608:	74 14                	je     80061e <_main+0x5e6>
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 ec 29 80 00       	push   $0x8029ec
  800612:	6a 6f                	push   $0x6f
  800614:	68 3c 29 80 00       	push   $0x80293c
  800619:	e8 9b 03 00 00       	call   8009b9 <_panic>

		//3 Mega
		freeFrames = sys_calculate_free_frames() ;
  80061e:	e8 99 1b 00 00       	call   8021bc <sys_calculate_free_frames>
  800623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800626:	e8 14 1c 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  80062b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  80062e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800631:	89 c2                	mov    %eax,%edx
  800633:	01 d2                	add    %edx,%edx
  800635:	01 d0                	add    %edx,%eax
  800637:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	50                   	push   %eax
  80063e:	e8 a2 13 00 00       	call   8019e5 <malloc>
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800649:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80064c:	89 c2                	mov    %eax,%edx
  80064e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800651:	c1 e0 02             	shl    $0x2,%eax
  800654:	89 c1                	mov    %eax,%ecx
  800656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800659:	c1 e0 04             	shl    $0x4,%eax
  80065c:	01 c8                	add    %ecx,%eax
  80065e:	05 00 00 00 80       	add    $0x80000000,%eax
  800663:	39 c2                	cmp    %eax,%edx
  800665:	72 25                	jb     80068c <_main+0x654>
  800667:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80066a:	89 c1                	mov    %eax,%ecx
  80066c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80066f:	89 d0                	mov    %edx,%eax
  800671:	01 c0                	add    %eax,%eax
  800673:	01 d0                	add    %edx,%eax
  800675:	01 c0                	add    %eax,%eax
  800677:	01 d0                	add    %edx,%eax
  800679:	89 c2                	mov    %eax,%edx
  80067b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80067e:	c1 e0 04             	shl    $0x4,%eax
  800681:	01 d0                	add    %edx,%eax
  800683:	05 00 00 00 80       	add    $0x80000000,%eax
  800688:	39 c1                	cmp    %eax,%ecx
  80068a:	76 14                	jbe    8006a0 <_main+0x668>
  80068c:	83 ec 04             	sub    $0x4,%esp
  80068f:	68 50 29 80 00       	push   $0x802950
  800694:	6a 75                	push   $0x75
  800696:	68 3c 29 80 00       	push   $0x80293c
  80069b:	e8 19 03 00 00       	call   8009b9 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8006a0:	e8 17 1b 00 00       	call   8021bc <sys_calculate_free_frames>
  8006a5:	89 c2                	mov    %eax,%edx
  8006a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006aa:	39 c2                	cmp    %eax,%edx
  8006ac:	74 14                	je     8006c2 <_main+0x68a>
  8006ae:	83 ec 04             	sub    $0x4,%esp
  8006b1:	68 80 29 80 00       	push   $0x802980
  8006b6:	6a 76                	push   $0x76
  8006b8:	68 3c 29 80 00       	push   $0x80293c
  8006bd:	e8 f7 02 00 00       	call   8009b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  8006c2:	e8 78 1b 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  8006c7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006cf:	89 c1                	mov    %eax,%ecx
  8006d1:	01 c9                	add    %ecx,%ecx
  8006d3:	01 c8                	add    %ecx,%eax
  8006d5:	85 c0                	test   %eax,%eax
  8006d7:	79 05                	jns    8006de <_main+0x6a6>
  8006d9:	05 ff 0f 00 00       	add    $0xfff,%eax
  8006de:	c1 f8 0c             	sar    $0xc,%eax
  8006e1:	39 c2                	cmp    %eax,%edx
  8006e3:	74 14                	je     8006f9 <_main+0x6c1>
  8006e5:	83 ec 04             	sub    $0x4,%esp
  8006e8:	68 ec 29 80 00       	push   $0x8029ec
  8006ed:	6a 77                	push   $0x77
  8006ef:	68 3c 29 80 00       	push   $0x80293c
  8006f4:	e8 c0 02 00 00       	call   8009b9 <_panic>

		//2 Mega
		freeFrames = sys_calculate_free_frames() ;
  8006f9:	e8 be 1a 00 00       	call   8021bc <sys_calculate_free_frames>
  8006fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800701:	e8 39 1b 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  800706:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  800709:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80070c:	01 c0                	add    %eax,%eax
  80070e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800711:	83 ec 0c             	sub    $0xc,%esp
  800714:	50                   	push   %eax
  800715:	e8 cb 12 00 00       	call   8019e5 <malloc>
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 9*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800720:	8b 45 98             	mov    -0x68(%ebp),%eax
  800723:	89 c1                	mov    %eax,%ecx
  800725:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800728:	89 d0                	mov    %edx,%eax
  80072a:	01 c0                	add    %eax,%eax
  80072c:	01 d0                	add    %edx,%eax
  80072e:	01 c0                	add    %eax,%eax
  800730:	01 d0                	add    %edx,%eax
  800732:	89 c2                	mov    %eax,%edx
  800734:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800737:	c1 e0 04             	shl    $0x4,%eax
  80073a:	01 d0                	add    %edx,%eax
  80073c:	05 00 00 00 80       	add    $0x80000000,%eax
  800741:	39 c1                	cmp    %eax,%ecx
  800743:	72 22                	jb     800767 <_main+0x72f>
  800745:	8b 45 98             	mov    -0x68(%ebp),%eax
  800748:	89 c1                	mov    %eax,%ecx
  80074a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80074d:	89 d0                	mov    %edx,%eax
  80074f:	c1 e0 03             	shl    $0x3,%eax
  800752:	01 d0                	add    %edx,%eax
  800754:	89 c2                	mov    %eax,%edx
  800756:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800759:	c1 e0 04             	shl    $0x4,%eax
  80075c:	01 d0                	add    %edx,%eax
  80075e:	05 00 00 00 80       	add    $0x80000000,%eax
  800763:	39 c1                	cmp    %eax,%ecx
  800765:	76 14                	jbe    80077b <_main+0x743>
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 50 29 80 00       	push   $0x802950
  80076f:	6a 7d                	push   $0x7d
  800771:	68 3c 29 80 00       	push   $0x80293c
  800776:	e8 3e 02 00 00       	call   8009b9 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80077b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80077e:	e8 39 1a 00 00       	call   8021bc <sys_calculate_free_frames>
  800783:	29 c3                	sub    %eax,%ebx
  800785:	89 d8                	mov    %ebx,%eax
  800787:	83 f8 01             	cmp    $0x1,%eax
  80078a:	74 14                	je     8007a0 <_main+0x768>
  80078c:	83 ec 04             	sub    $0x4,%esp
  80078f:	68 80 29 80 00       	push   $0x802980
  800794:	6a 7e                	push   $0x7e
  800796:	68 3c 29 80 00       	push   $0x80293c
  80079b:	e8 19 02 00 00       	call   8009b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8007a0:	e8 9a 1a 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  8007a5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007a8:	3d 00 02 00 00       	cmp    $0x200,%eax
  8007ad:	74 14                	je     8007c3 <_main+0x78b>
  8007af:	83 ec 04             	sub    $0x4,%esp
  8007b2:	68 ec 29 80 00       	push   $0x8029ec
  8007b7:	6a 7f                	push   $0x7f
  8007b9:	68 3c 29 80 00       	push   $0x80293c
  8007be:	e8 f6 01 00 00       	call   8009b9 <_panic>

		//257 Bytes
		freeFrames = sys_calculate_free_frames() ;
  8007c3:	e8 f4 19 00 00       	call   8021bc <sys_calculate_free_frames>
  8007c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007cb:	e8 6f 1a 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  8007d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(510);
  8007d3:	83 ec 0c             	sub    $0xc,%esp
  8007d6:	68 fe 01 00 00       	push   $0x1fe
  8007db:	e8 05 12 00 00       	call   8019e5 <malloc>
  8007e0:	83 c4 10             	add    $0x10,%esp
  8007e3:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[7] < (start_of_page) || (uint32) ptr_allocations[7] > (start_of_page + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8007e6:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8007e9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8007ec:	72 11                	jb     8007ff <_main+0x7c7>
  8007ee:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8007f1:	89 c2                	mov    %eax,%edx
  8007f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007f6:	05 00 10 00 00       	add    $0x1000,%eax
  8007fb:	39 c2                	cmp    %eax,%edx
  8007fd:	76 17                	jbe    800816 <_main+0x7de>
  8007ff:	83 ec 04             	sub    $0x4,%esp
  800802:	68 50 29 80 00       	push   $0x802950
  800807:	68 85 00 00 00       	push   $0x85
  80080c:	68 3c 29 80 00       	push   $0x80293c
  800811:	e8 a3 01 00 00       	call   8009b9 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800816:	e8 a1 19 00 00       	call   8021bc <sys_calculate_free_frames>
  80081b:	89 c2                	mov    %eax,%edx
  80081d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800820:	39 c2                	cmp    %eax,%edx
  800822:	74 17                	je     80083b <_main+0x803>
  800824:	83 ec 04             	sub    $0x4,%esp
  800827:	68 80 29 80 00       	push   $0x802980
  80082c:	68 86 00 00 00       	push   $0x86
  800831:	68 3c 29 80 00       	push   $0x80293c
  800836:	e8 7e 01 00 00       	call   8009b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80083b:	e8 ff 19 00 00       	call   80223f <sys_pf_calculate_allocated_pages>
  800840:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800843:	74 17                	je     80085c <_main+0x824>
  800845:	83 ec 04             	sub    $0x4,%esp
  800848:	68 ec 29 80 00       	push   $0x8029ec
  80084d:	68 87 00 00 00       	push   $0x87
  800852:	68 3c 29 80 00       	push   $0x80293c
  800857:	e8 5d 01 00 00       	call   8009b9 <_panic>
	}
	cprintf("Congratulations!! test malloc (4) completed successfully.\n");
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	68 8c 2a 80 00       	push   $0x802a8c
  800864:	e8 f2 03 00 00       	call   800c5b <cprintf>
  800869:	83 c4 10             	add    $0x10,%esp

	return;
  80086c:	90                   	nop
}
  80086d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800870:	5b                   	pop    %ebx
  800871:	5f                   	pop    %edi
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    

00800874 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80087a:	e8 72 18 00 00       	call   8020f1 <sys_getenvindex>
  80087f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800882:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800885:	89 d0                	mov    %edx,%eax
  800887:	c1 e0 03             	shl    $0x3,%eax
  80088a:	01 d0                	add    %edx,%eax
  80088c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800893:	01 c8                	add    %ecx,%eax
  800895:	01 c0                	add    %eax,%eax
  800897:	01 d0                	add    %edx,%eax
  800899:	01 c0                	add    %eax,%eax
  80089b:	01 d0                	add    %edx,%eax
  80089d:	89 c2                	mov    %eax,%edx
  80089f:	c1 e2 05             	shl    $0x5,%edx
  8008a2:	29 c2                	sub    %eax,%edx
  8008a4:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8008ab:	89 c2                	mov    %eax,%edx
  8008ad:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8008b3:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8008b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8008bd:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8008c3:	84 c0                	test   %al,%al
  8008c5:	74 0f                	je     8008d6 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8008c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8008cc:	05 40 3c 01 00       	add    $0x13c40,%eax
  8008d1:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008da:	7e 0a                	jle    8008e6 <libmain+0x72>
		binaryname = argv[0];
  8008dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ec:	ff 75 08             	pushl  0x8(%ebp)
  8008ef:	e8 44 f7 ff ff       	call   800038 <_main>
  8008f4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8008f7:	e8 90 19 00 00       	call   80228c <sys_disable_interrupt>
	cprintf("**************************************\n");
  8008fc:	83 ec 0c             	sub    $0xc,%esp
  8008ff:	68 e0 2a 80 00       	push   $0x802ae0
  800904:	e8 52 03 00 00       	call   800c5b <cprintf>
  800909:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80090c:	a1 20 40 80 00       	mov    0x804020,%eax
  800911:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800917:	a1 20 40 80 00       	mov    0x804020,%eax
  80091c:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800922:	83 ec 04             	sub    $0x4,%esp
  800925:	52                   	push   %edx
  800926:	50                   	push   %eax
  800927:	68 08 2b 80 00       	push   $0x802b08
  80092c:	e8 2a 03 00 00       	call   800c5b <cprintf>
  800931:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800934:	a1 20 40 80 00       	mov    0x804020,%eax
  800939:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80093f:	a1 20 40 80 00       	mov    0x804020,%eax
  800944:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80094a:	83 ec 04             	sub    $0x4,%esp
  80094d:	52                   	push   %edx
  80094e:	50                   	push   %eax
  80094f:	68 30 2b 80 00       	push   $0x802b30
  800954:	e8 02 03 00 00       	call   800c5b <cprintf>
  800959:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80095c:	a1 20 40 80 00       	mov    0x804020,%eax
  800961:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	50                   	push   %eax
  80096b:	68 71 2b 80 00       	push   $0x802b71
  800970:	e8 e6 02 00 00       	call   800c5b <cprintf>
  800975:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800978:	83 ec 0c             	sub    $0xc,%esp
  80097b:	68 e0 2a 80 00       	push   $0x802ae0
  800980:	e8 d6 02 00 00       	call   800c5b <cprintf>
  800985:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800988:	e8 19 19 00 00       	call   8022a6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80098d:	e8 19 00 00 00       	call   8009ab <exit>
}
  800992:	90                   	nop
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80099b:	83 ec 0c             	sub    $0xc,%esp
  80099e:	6a 00                	push   $0x0
  8009a0:	e8 18 17 00 00       	call   8020bd <sys_env_destroy>
  8009a5:	83 c4 10             	add    $0x10,%esp
}
  8009a8:	90                   	nop
  8009a9:	c9                   	leave  
  8009aa:	c3                   	ret    

008009ab <exit>:

void
exit(void)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8009b1:	e8 6d 17 00 00       	call   802123 <sys_env_exit>
}
  8009b6:	90                   	nop
  8009b7:	c9                   	leave  
  8009b8:	c3                   	ret    

008009b9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009bf:	8d 45 10             	lea    0x10(%ebp),%eax
  8009c2:	83 c0 04             	add    $0x4,%eax
  8009c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009c8:	a1 18 41 80 00       	mov    0x804118,%eax
  8009cd:	85 c0                	test   %eax,%eax
  8009cf:	74 16                	je     8009e7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009d1:	a1 18 41 80 00       	mov    0x804118,%eax
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	50                   	push   %eax
  8009da:	68 88 2b 80 00       	push   $0x802b88
  8009df:	e8 77 02 00 00       	call   800c5b <cprintf>
  8009e4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009e7:	a1 00 40 80 00       	mov    0x804000,%eax
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	ff 75 08             	pushl  0x8(%ebp)
  8009f2:	50                   	push   %eax
  8009f3:	68 8d 2b 80 00       	push   $0x802b8d
  8009f8:	e8 5e 02 00 00       	call   800c5b <cprintf>
  8009fd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800a00:	8b 45 10             	mov    0x10(%ebp),%eax
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 f4             	pushl  -0xc(%ebp)
  800a09:	50                   	push   %eax
  800a0a:	e8 e1 01 00 00       	call   800bf0 <vcprintf>
  800a0f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	6a 00                	push   $0x0
  800a17:	68 a9 2b 80 00       	push   $0x802ba9
  800a1c:	e8 cf 01 00 00       	call   800bf0 <vcprintf>
  800a21:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a24:	e8 82 ff ff ff       	call   8009ab <exit>

	// should not return here
	while (1) ;
  800a29:	eb fe                	jmp    800a29 <_panic+0x70>

00800a2b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a31:	a1 20 40 80 00       	mov    0x804020,%eax
  800a36:	8b 50 74             	mov    0x74(%eax),%edx
  800a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3c:	39 c2                	cmp    %eax,%edx
  800a3e:	74 14                	je     800a54 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a40:	83 ec 04             	sub    $0x4,%esp
  800a43:	68 ac 2b 80 00       	push   $0x802bac
  800a48:	6a 26                	push   $0x26
  800a4a:	68 f8 2b 80 00       	push   $0x802bf8
  800a4f:	e8 65 ff ff ff       	call   8009b9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a5b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a62:	e9 b6 00 00 00       	jmp    800b1d <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	01 d0                	add    %edx,%eax
  800a76:	8b 00                	mov    (%eax),%eax
  800a78:	85 c0                	test   %eax,%eax
  800a7a:	75 08                	jne    800a84 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800a7c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a7f:	e9 96 00 00 00       	jmp    800b1a <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800a84:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a92:	eb 5d                	jmp    800af1 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a94:	a1 20 40 80 00       	mov    0x804020,%eax
  800a99:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800a9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aa2:	c1 e2 04             	shl    $0x4,%edx
  800aa5:	01 d0                	add    %edx,%eax
  800aa7:	8a 40 04             	mov    0x4(%eax),%al
  800aaa:	84 c0                	test   %al,%al
  800aac:	75 40                	jne    800aee <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800aae:	a1 20 40 80 00       	mov    0x804020,%eax
  800ab3:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800ab9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800abc:	c1 e2 04             	shl    $0x4,%edx
  800abf:	01 d0                	add    %edx,%eax
  800ac1:	8b 00                	mov    (%eax),%eax
  800ac3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800ac6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ac9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ace:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	01 c8                	add    %ecx,%eax
  800adf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ae1:	39 c2                	cmp    %eax,%edx
  800ae3:	75 09                	jne    800aee <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800ae5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800aec:	eb 12                	jmp    800b00 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aee:	ff 45 e8             	incl   -0x18(%ebp)
  800af1:	a1 20 40 80 00       	mov    0x804020,%eax
  800af6:	8b 50 74             	mov    0x74(%eax),%edx
  800af9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800afc:	39 c2                	cmp    %eax,%edx
  800afe:	77 94                	ja     800a94 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b00:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b04:	75 14                	jne    800b1a <CheckWSWithoutLastIndex+0xef>
			panic(
  800b06:	83 ec 04             	sub    $0x4,%esp
  800b09:	68 04 2c 80 00       	push   $0x802c04
  800b0e:	6a 3a                	push   $0x3a
  800b10:	68 f8 2b 80 00       	push   $0x802bf8
  800b15:	e8 9f fe ff ff       	call   8009b9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b1a:	ff 45 f0             	incl   -0x10(%ebp)
  800b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b20:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b23:	0f 8c 3e ff ff ff    	jl     800a67 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b30:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b37:	eb 20                	jmp    800b59 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b39:	a1 20 40 80 00       	mov    0x804020,%eax
  800b3e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b47:	c1 e2 04             	shl    $0x4,%edx
  800b4a:	01 d0                	add    %edx,%eax
  800b4c:	8a 40 04             	mov    0x4(%eax),%al
  800b4f:	3c 01                	cmp    $0x1,%al
  800b51:	75 03                	jne    800b56 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800b53:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b56:	ff 45 e0             	incl   -0x20(%ebp)
  800b59:	a1 20 40 80 00       	mov    0x804020,%eax
  800b5e:	8b 50 74             	mov    0x74(%eax),%edx
  800b61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b64:	39 c2                	cmp    %eax,%edx
  800b66:	77 d1                	ja     800b39 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b6b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b6e:	74 14                	je     800b84 <CheckWSWithoutLastIndex+0x159>
		panic(
  800b70:	83 ec 04             	sub    $0x4,%esp
  800b73:	68 58 2c 80 00       	push   $0x802c58
  800b78:	6a 44                	push   $0x44
  800b7a:	68 f8 2b 80 00       	push   $0x802bf8
  800b7f:	e8 35 fe ff ff       	call   8009b9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b84:	90                   	nop
  800b85:	c9                   	leave  
  800b86:	c3                   	ret    

00800b87 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	8d 48 01             	lea    0x1(%eax),%ecx
  800b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b98:	89 0a                	mov    %ecx,(%edx)
  800b9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9d:	88 d1                	mov    %dl,%cl
  800b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bb0:	75 2c                	jne    800bde <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800bb2:	a0 24 40 80 00       	mov    0x804024,%al
  800bb7:	0f b6 c0             	movzbl %al,%eax
  800bba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbd:	8b 12                	mov    (%edx),%edx
  800bbf:	89 d1                	mov    %edx,%ecx
  800bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc4:	83 c2 08             	add    $0x8,%edx
  800bc7:	83 ec 04             	sub    $0x4,%esp
  800bca:	50                   	push   %eax
  800bcb:	51                   	push   %ecx
  800bcc:	52                   	push   %edx
  800bcd:	e8 a9 14 00 00       	call   80207b <sys_cputs>
  800bd2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be1:	8b 40 04             	mov    0x4(%eax),%eax
  800be4:	8d 50 01             	lea    0x1(%eax),%edx
  800be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bea:	89 50 04             	mov    %edx,0x4(%eax)
}
  800bed:	90                   	nop
  800bee:	c9                   	leave  
  800bef:	c3                   	ret    

00800bf0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bf9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c00:	00 00 00 
	b.cnt = 0;
  800c03:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c0a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	ff 75 08             	pushl  0x8(%ebp)
  800c13:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c19:	50                   	push   %eax
  800c1a:	68 87 0b 80 00       	push   $0x800b87
  800c1f:	e8 11 02 00 00       	call   800e35 <vprintfmt>
  800c24:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800c27:	a0 24 40 80 00       	mov    0x804024,%al
  800c2c:	0f b6 c0             	movzbl %al,%eax
  800c2f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c35:	83 ec 04             	sub    $0x4,%esp
  800c38:	50                   	push   %eax
  800c39:	52                   	push   %edx
  800c3a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c40:	83 c0 08             	add    $0x8,%eax
  800c43:	50                   	push   %eax
  800c44:	e8 32 14 00 00       	call   80207b <sys_cputs>
  800c49:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c4c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800c53:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c59:	c9                   	leave  
  800c5a:	c3                   	ret    

00800c5b <cprintf>:

int cprintf(const char *fmt, ...) {
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c61:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800c68:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	83 ec 08             	sub    $0x8,%esp
  800c74:	ff 75 f4             	pushl  -0xc(%ebp)
  800c77:	50                   	push   %eax
  800c78:	e8 73 ff ff ff       	call   800bf0 <vcprintf>
  800c7d:	83 c4 10             	add    $0x10,%esp
  800c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c8e:	e8 f9 15 00 00       	call   80228c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c93:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	83 ec 08             	sub    $0x8,%esp
  800c9f:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca2:	50                   	push   %eax
  800ca3:	e8 48 ff ff ff       	call   800bf0 <vcprintf>
  800ca8:	83 c4 10             	add    $0x10,%esp
  800cab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800cae:	e8 f3 15 00 00       	call   8022a6 <sys_enable_interrupt>
	return cnt;
  800cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    

00800cb8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	53                   	push   %ebx
  800cbc:	83 ec 14             	sub    $0x14,%esp
  800cbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ccb:	8b 45 18             	mov    0x18(%ebp),%eax
  800cce:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd6:	77 55                	ja     800d2d <printnum+0x75>
  800cd8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cdb:	72 05                	jb     800ce2 <printnum+0x2a>
  800cdd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ce0:	77 4b                	ja     800d2d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ce2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ce5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ce8:	8b 45 18             	mov    0x18(%ebp),%eax
  800ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf0:	52                   	push   %edx
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf8:	e8 b3 19 00 00       	call   8026b0 <__udivdi3>
  800cfd:	83 c4 10             	add    $0x10,%esp
  800d00:	83 ec 04             	sub    $0x4,%esp
  800d03:	ff 75 20             	pushl  0x20(%ebp)
  800d06:	53                   	push   %ebx
  800d07:	ff 75 18             	pushl  0x18(%ebp)
  800d0a:	52                   	push   %edx
  800d0b:	50                   	push   %eax
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 08             	pushl  0x8(%ebp)
  800d12:	e8 a1 ff ff ff       	call   800cb8 <printnum>
  800d17:	83 c4 20             	add    $0x20,%esp
  800d1a:	eb 1a                	jmp    800d36 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 0c             	pushl  0xc(%ebp)
  800d22:	ff 75 20             	pushl  0x20(%ebp)
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	ff d0                	call   *%eax
  800d2a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d2d:	ff 4d 1c             	decl   0x1c(%ebp)
  800d30:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d34:	7f e6                	jg     800d1c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d36:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d44:	53                   	push   %ebx
  800d45:	51                   	push   %ecx
  800d46:	52                   	push   %edx
  800d47:	50                   	push   %eax
  800d48:	e8 73 1a 00 00       	call   8027c0 <__umoddi3>
  800d4d:	83 c4 10             	add    $0x10,%esp
  800d50:	05 d4 2e 80 00       	add    $0x802ed4,%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f be c0             	movsbl %al,%eax
  800d5a:	83 ec 08             	sub    $0x8,%esp
  800d5d:	ff 75 0c             	pushl  0xc(%ebp)
  800d60:	50                   	push   %eax
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	ff d0                	call   *%eax
  800d66:	83 c4 10             	add    $0x10,%esp
}
  800d69:	90                   	nop
  800d6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d6d:	c9                   	leave  
  800d6e:	c3                   	ret    

00800d6f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d72:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d76:	7e 1c                	jle    800d94 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8b 00                	mov    (%eax),%eax
  800d7d:	8d 50 08             	lea    0x8(%eax),%edx
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	89 10                	mov    %edx,(%eax)
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8b 00                	mov    (%eax),%eax
  800d8a:	83 e8 08             	sub    $0x8,%eax
  800d8d:	8b 50 04             	mov    0x4(%eax),%edx
  800d90:	8b 00                	mov    (%eax),%eax
  800d92:	eb 40                	jmp    800dd4 <getuint+0x65>
	else if (lflag)
  800d94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d98:	74 1e                	je     800db8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8b 00                	mov    (%eax),%eax
  800d9f:	8d 50 04             	lea    0x4(%eax),%edx
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	89 10                	mov    %edx,(%eax)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8b 00                	mov    (%eax),%eax
  800dac:	83 e8 04             	sub    $0x4,%eax
  800daf:	8b 00                	mov    (%eax),%eax
  800db1:	ba 00 00 00 00       	mov    $0x0,%edx
  800db6:	eb 1c                	jmp    800dd4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8b 00                	mov    (%eax),%eax
  800dbd:	8d 50 04             	lea    0x4(%eax),%edx
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	89 10                	mov    %edx,(%eax)
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8b 00                	mov    (%eax),%eax
  800dca:	83 e8 04             	sub    $0x4,%eax
  800dcd:	8b 00                	mov    (%eax),%eax
  800dcf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dd9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ddd:	7e 1c                	jle    800dfb <getint+0x25>
		return va_arg(*ap, long long);
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	8b 00                	mov    (%eax),%eax
  800de4:	8d 50 08             	lea    0x8(%eax),%edx
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	89 10                	mov    %edx,(%eax)
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	83 e8 08             	sub    $0x8,%eax
  800df4:	8b 50 04             	mov    0x4(%eax),%edx
  800df7:	8b 00                	mov    (%eax),%eax
  800df9:	eb 38                	jmp    800e33 <getint+0x5d>
	else if (lflag)
  800dfb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dff:	74 1a                	je     800e1b <getint+0x45>
		return va_arg(*ap, long);
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8b 00                	mov    (%eax),%eax
  800e06:	8d 50 04             	lea    0x4(%eax),%edx
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	89 10                	mov    %edx,(%eax)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8b 00                	mov    (%eax),%eax
  800e13:	83 e8 04             	sub    $0x4,%eax
  800e16:	8b 00                	mov    (%eax),%eax
  800e18:	99                   	cltd   
  800e19:	eb 18                	jmp    800e33 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8b 00                	mov    (%eax),%eax
  800e20:	8d 50 04             	lea    0x4(%eax),%edx
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	89 10                	mov    %edx,(%eax)
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	83 e8 04             	sub    $0x4,%eax
  800e30:	8b 00                	mov    (%eax),%eax
  800e32:	99                   	cltd   
}
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    

00800e35 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	56                   	push   %esi
  800e39:	53                   	push   %ebx
  800e3a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e3d:	eb 17                	jmp    800e56 <vprintfmt+0x21>
			if (ch == '\0')
  800e3f:	85 db                	test   %ebx,%ebx
  800e41:	0f 84 af 03 00 00    	je     8011f6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800e47:	83 ec 08             	sub    $0x8,%esp
  800e4a:	ff 75 0c             	pushl  0xc(%ebp)
  800e4d:	53                   	push   %ebx
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	ff d0                	call   *%eax
  800e53:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e56:	8b 45 10             	mov    0x10(%ebp),%eax
  800e59:	8d 50 01             	lea    0x1(%eax),%edx
  800e5c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	0f b6 d8             	movzbl %al,%ebx
  800e64:	83 fb 25             	cmp    $0x25,%ebx
  800e67:	75 d6                	jne    800e3f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e69:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e6d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e74:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e7b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e82:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e89:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8c:	8d 50 01             	lea    0x1(%eax),%edx
  800e8f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e92:	8a 00                	mov    (%eax),%al
  800e94:	0f b6 d8             	movzbl %al,%ebx
  800e97:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e9a:	83 f8 55             	cmp    $0x55,%eax
  800e9d:	0f 87 2b 03 00 00    	ja     8011ce <vprintfmt+0x399>
  800ea3:	8b 04 85 f8 2e 80 00 	mov    0x802ef8(,%eax,4),%eax
  800eaa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800eac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800eb0:	eb d7                	jmp    800e89 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800eb2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800eb6:	eb d1                	jmp    800e89 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ebf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	c1 e0 02             	shl    $0x2,%eax
  800ec7:	01 d0                	add    %edx,%eax
  800ec9:	01 c0                	add    %eax,%eax
  800ecb:	01 d8                	add    %ebx,%eax
  800ecd:	83 e8 30             	sub    $0x30,%eax
  800ed0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	8a 00                	mov    (%eax),%al
  800ed8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800edb:	83 fb 2f             	cmp    $0x2f,%ebx
  800ede:	7e 3e                	jle    800f1e <vprintfmt+0xe9>
  800ee0:	83 fb 39             	cmp    $0x39,%ebx
  800ee3:	7f 39                	jg     800f1e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ee5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ee8:	eb d5                	jmp    800ebf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800eea:	8b 45 14             	mov    0x14(%ebp),%eax
  800eed:	83 c0 04             	add    $0x4,%eax
  800ef0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ef3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef6:	83 e8 04             	sub    $0x4,%eax
  800ef9:	8b 00                	mov    (%eax),%eax
  800efb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800efe:	eb 1f                	jmp    800f1f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f04:	79 83                	jns    800e89 <vprintfmt+0x54>
				width = 0;
  800f06:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f0d:	e9 77 ff ff ff       	jmp    800e89 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f12:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f19:	e9 6b ff ff ff       	jmp    800e89 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f1e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f23:	0f 89 60 ff ff ff    	jns    800e89 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f2f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f36:	e9 4e ff ff ff       	jmp    800e89 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f3b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f3e:	e9 46 ff ff ff       	jmp    800e89 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f43:	8b 45 14             	mov    0x14(%ebp),%eax
  800f46:	83 c0 04             	add    $0x4,%eax
  800f49:	89 45 14             	mov    %eax,0x14(%ebp)
  800f4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4f:	83 e8 04             	sub    $0x4,%eax
  800f52:	8b 00                	mov    (%eax),%eax
  800f54:	83 ec 08             	sub    $0x8,%esp
  800f57:	ff 75 0c             	pushl  0xc(%ebp)
  800f5a:	50                   	push   %eax
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	ff d0                	call   *%eax
  800f60:	83 c4 10             	add    $0x10,%esp
			break;
  800f63:	e9 89 02 00 00       	jmp    8011f1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f68:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6b:	83 c0 04             	add    $0x4,%eax
  800f6e:	89 45 14             	mov    %eax,0x14(%ebp)
  800f71:	8b 45 14             	mov    0x14(%ebp),%eax
  800f74:	83 e8 04             	sub    $0x4,%eax
  800f77:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f79:	85 db                	test   %ebx,%ebx
  800f7b:	79 02                	jns    800f7f <vprintfmt+0x14a>
				err = -err;
  800f7d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f7f:	83 fb 64             	cmp    $0x64,%ebx
  800f82:	7f 0b                	jg     800f8f <vprintfmt+0x15a>
  800f84:	8b 34 9d 40 2d 80 00 	mov    0x802d40(,%ebx,4),%esi
  800f8b:	85 f6                	test   %esi,%esi
  800f8d:	75 19                	jne    800fa8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f8f:	53                   	push   %ebx
  800f90:	68 e5 2e 80 00       	push   $0x802ee5
  800f95:	ff 75 0c             	pushl  0xc(%ebp)
  800f98:	ff 75 08             	pushl  0x8(%ebp)
  800f9b:	e8 5e 02 00 00       	call   8011fe <printfmt>
  800fa0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800fa3:	e9 49 02 00 00       	jmp    8011f1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fa8:	56                   	push   %esi
  800fa9:	68 ee 2e 80 00       	push   $0x802eee
  800fae:	ff 75 0c             	pushl  0xc(%ebp)
  800fb1:	ff 75 08             	pushl  0x8(%ebp)
  800fb4:	e8 45 02 00 00       	call   8011fe <printfmt>
  800fb9:	83 c4 10             	add    $0x10,%esp
			break;
  800fbc:	e9 30 02 00 00       	jmp    8011f1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fc1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc4:	83 c0 04             	add    $0x4,%eax
  800fc7:	89 45 14             	mov    %eax,0x14(%ebp)
  800fca:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcd:	83 e8 04             	sub    $0x4,%eax
  800fd0:	8b 30                	mov    (%eax),%esi
  800fd2:	85 f6                	test   %esi,%esi
  800fd4:	75 05                	jne    800fdb <vprintfmt+0x1a6>
				p = "(null)";
  800fd6:	be f1 2e 80 00       	mov    $0x802ef1,%esi
			if (width > 0 && padc != '-')
  800fdb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fdf:	7e 6d                	jle    80104e <vprintfmt+0x219>
  800fe1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fe5:	74 67                	je     80104e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fea:	83 ec 08             	sub    $0x8,%esp
  800fed:	50                   	push   %eax
  800fee:	56                   	push   %esi
  800fef:	e8 0c 03 00 00       	call   801300 <strnlen>
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ffa:	eb 16                	jmp    801012 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ffc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801000:	83 ec 08             	sub    $0x8,%esp
  801003:	ff 75 0c             	pushl  0xc(%ebp)
  801006:	50                   	push   %eax
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	ff d0                	call   *%eax
  80100c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80100f:	ff 4d e4             	decl   -0x1c(%ebp)
  801012:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801016:	7f e4                	jg     800ffc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801018:	eb 34                	jmp    80104e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80101a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80101e:	74 1c                	je     80103c <vprintfmt+0x207>
  801020:	83 fb 1f             	cmp    $0x1f,%ebx
  801023:	7e 05                	jle    80102a <vprintfmt+0x1f5>
  801025:	83 fb 7e             	cmp    $0x7e,%ebx
  801028:	7e 12                	jle    80103c <vprintfmt+0x207>
					putch('?', putdat);
  80102a:	83 ec 08             	sub    $0x8,%esp
  80102d:	ff 75 0c             	pushl  0xc(%ebp)
  801030:	6a 3f                	push   $0x3f
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	ff d0                	call   *%eax
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	eb 0f                	jmp    80104b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80103c:	83 ec 08             	sub    $0x8,%esp
  80103f:	ff 75 0c             	pushl  0xc(%ebp)
  801042:	53                   	push   %ebx
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	ff d0                	call   *%eax
  801048:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80104b:	ff 4d e4             	decl   -0x1c(%ebp)
  80104e:	89 f0                	mov    %esi,%eax
  801050:	8d 70 01             	lea    0x1(%eax),%esi
  801053:	8a 00                	mov    (%eax),%al
  801055:	0f be d8             	movsbl %al,%ebx
  801058:	85 db                	test   %ebx,%ebx
  80105a:	74 24                	je     801080 <vprintfmt+0x24b>
  80105c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801060:	78 b8                	js     80101a <vprintfmt+0x1e5>
  801062:	ff 4d e0             	decl   -0x20(%ebp)
  801065:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801069:	79 af                	jns    80101a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80106b:	eb 13                	jmp    801080 <vprintfmt+0x24b>
				putch(' ', putdat);
  80106d:	83 ec 08             	sub    $0x8,%esp
  801070:	ff 75 0c             	pushl  0xc(%ebp)
  801073:	6a 20                	push   $0x20
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	ff d0                	call   *%eax
  80107a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80107d:	ff 4d e4             	decl   -0x1c(%ebp)
  801080:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801084:	7f e7                	jg     80106d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801086:	e9 66 01 00 00       	jmp    8011f1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80108b:	83 ec 08             	sub    $0x8,%esp
  80108e:	ff 75 e8             	pushl  -0x18(%ebp)
  801091:	8d 45 14             	lea    0x14(%ebp),%eax
  801094:	50                   	push   %eax
  801095:	e8 3c fd ff ff       	call   800dd6 <getint>
  80109a:	83 c4 10             	add    $0x10,%esp
  80109d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8010a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a9:	85 d2                	test   %edx,%edx
  8010ab:	79 23                	jns    8010d0 <vprintfmt+0x29b>
				putch('-', putdat);
  8010ad:	83 ec 08             	sub    $0x8,%esp
  8010b0:	ff 75 0c             	pushl  0xc(%ebp)
  8010b3:	6a 2d                	push   $0x2d
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	ff d0                	call   *%eax
  8010ba:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c3:	f7 d8                	neg    %eax
  8010c5:	83 d2 00             	adc    $0x0,%edx
  8010c8:	f7 da                	neg    %edx
  8010ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010d0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010d7:	e9 bc 00 00 00       	jmp    801198 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010dc:	83 ec 08             	sub    $0x8,%esp
  8010df:	ff 75 e8             	pushl  -0x18(%ebp)
  8010e2:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e5:	50                   	push   %eax
  8010e6:	e8 84 fc ff ff       	call   800d6f <getuint>
  8010eb:	83 c4 10             	add    $0x10,%esp
  8010ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010f4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010fb:	e9 98 00 00 00       	jmp    801198 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801100:	83 ec 08             	sub    $0x8,%esp
  801103:	ff 75 0c             	pushl  0xc(%ebp)
  801106:	6a 58                	push   $0x58
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	ff d0                	call   *%eax
  80110d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801110:	83 ec 08             	sub    $0x8,%esp
  801113:	ff 75 0c             	pushl  0xc(%ebp)
  801116:	6a 58                	push   $0x58
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	ff d0                	call   *%eax
  80111d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801120:	83 ec 08             	sub    $0x8,%esp
  801123:	ff 75 0c             	pushl  0xc(%ebp)
  801126:	6a 58                	push   $0x58
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	ff d0                	call   *%eax
  80112d:	83 c4 10             	add    $0x10,%esp
			break;
  801130:	e9 bc 00 00 00       	jmp    8011f1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801135:	83 ec 08             	sub    $0x8,%esp
  801138:	ff 75 0c             	pushl  0xc(%ebp)
  80113b:	6a 30                	push   $0x30
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	ff d0                	call   *%eax
  801142:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801145:	83 ec 08             	sub    $0x8,%esp
  801148:	ff 75 0c             	pushl  0xc(%ebp)
  80114b:	6a 78                	push   $0x78
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	ff d0                	call   *%eax
  801152:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801155:	8b 45 14             	mov    0x14(%ebp),%eax
  801158:	83 c0 04             	add    $0x4,%eax
  80115b:	89 45 14             	mov    %eax,0x14(%ebp)
  80115e:	8b 45 14             	mov    0x14(%ebp),%eax
  801161:	83 e8 04             	sub    $0x4,%eax
  801164:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801166:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801169:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801170:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801177:	eb 1f                	jmp    801198 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801179:	83 ec 08             	sub    $0x8,%esp
  80117c:	ff 75 e8             	pushl  -0x18(%ebp)
  80117f:	8d 45 14             	lea    0x14(%ebp),%eax
  801182:	50                   	push   %eax
  801183:	e8 e7 fb ff ff       	call   800d6f <getuint>
  801188:	83 c4 10             	add    $0x10,%esp
  80118b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80118e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801191:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801198:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80119c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119f:	83 ec 04             	sub    $0x4,%esp
  8011a2:	52                   	push   %edx
  8011a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011a6:	50                   	push   %eax
  8011a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8011aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8011ad:	ff 75 0c             	pushl  0xc(%ebp)
  8011b0:	ff 75 08             	pushl  0x8(%ebp)
  8011b3:	e8 00 fb ff ff       	call   800cb8 <printnum>
  8011b8:	83 c4 20             	add    $0x20,%esp
			break;
  8011bb:	eb 34                	jmp    8011f1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011bd:	83 ec 08             	sub    $0x8,%esp
  8011c0:	ff 75 0c             	pushl  0xc(%ebp)
  8011c3:	53                   	push   %ebx
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	ff d0                	call   *%eax
  8011c9:	83 c4 10             	add    $0x10,%esp
			break;
  8011cc:	eb 23                	jmp    8011f1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011ce:	83 ec 08             	sub    $0x8,%esp
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	6a 25                	push   $0x25
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	ff d0                	call   *%eax
  8011db:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011de:	ff 4d 10             	decl   0x10(%ebp)
  8011e1:	eb 03                	jmp    8011e6 <vprintfmt+0x3b1>
  8011e3:	ff 4d 10             	decl   0x10(%ebp)
  8011e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e9:	48                   	dec    %eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	3c 25                	cmp    $0x25,%al
  8011ee:	75 f3                	jne    8011e3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8011f0:	90                   	nop
		}
	}
  8011f1:	e9 47 fc ff ff       	jmp    800e3d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011f6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011fa:	5b                   	pop    %ebx
  8011fb:	5e                   	pop    %esi
  8011fc:	5d                   	pop    %ebp
  8011fd:	c3                   	ret    

008011fe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801204:	8d 45 10             	lea    0x10(%ebp),%eax
  801207:	83 c0 04             	add    $0x4,%eax
  80120a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80120d:	8b 45 10             	mov    0x10(%ebp),%eax
  801210:	ff 75 f4             	pushl  -0xc(%ebp)
  801213:	50                   	push   %eax
  801214:	ff 75 0c             	pushl  0xc(%ebp)
  801217:	ff 75 08             	pushl  0x8(%ebp)
  80121a:	e8 16 fc ff ff       	call   800e35 <vprintfmt>
  80121f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801222:	90                   	nop
  801223:	c9                   	leave  
  801224:	c3                   	ret    

00801225 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	8b 40 08             	mov    0x8(%eax),%eax
  80122e:	8d 50 01             	lea    0x1(%eax),%edx
  801231:	8b 45 0c             	mov    0xc(%ebp),%eax
  801234:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8b 10                	mov    (%eax),%edx
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	8b 40 04             	mov    0x4(%eax),%eax
  801242:	39 c2                	cmp    %eax,%edx
  801244:	73 12                	jae    801258 <sprintputch+0x33>
		*b->buf++ = ch;
  801246:	8b 45 0c             	mov    0xc(%ebp),%eax
  801249:	8b 00                	mov    (%eax),%eax
  80124b:	8d 48 01             	lea    0x1(%eax),%ecx
  80124e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801251:	89 0a                	mov    %ecx,(%edx)
  801253:	8b 55 08             	mov    0x8(%ebp),%edx
  801256:	88 10                	mov    %dl,(%eax)
}
  801258:	90                   	nop
  801259:	5d                   	pop    %ebp
  80125a:	c3                   	ret    

0080125b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	01 d0                	add    %edx,%eax
  801272:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801275:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80127c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801280:	74 06                	je     801288 <vsnprintf+0x2d>
  801282:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801286:	7f 07                	jg     80128f <vsnprintf+0x34>
		return -E_INVAL;
  801288:	b8 03 00 00 00       	mov    $0x3,%eax
  80128d:	eb 20                	jmp    8012af <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80128f:	ff 75 14             	pushl  0x14(%ebp)
  801292:	ff 75 10             	pushl  0x10(%ebp)
  801295:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801298:	50                   	push   %eax
  801299:	68 25 12 80 00       	push   $0x801225
  80129e:	e8 92 fb ff ff       	call   800e35 <vprintfmt>
  8012a3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012b7:	8d 45 10             	lea    0x10(%ebp),%eax
  8012ba:	83 c0 04             	add    $0x4,%eax
  8012bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c6:	50                   	push   %eax
  8012c7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ca:	ff 75 08             	pushl  0x8(%ebp)
  8012cd:	e8 89 ff ff ff       	call   80125b <vsnprintf>
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012db:	c9                   	leave  
  8012dc:	c3                   	ret    

008012dd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ea:	eb 06                	jmp    8012f2 <strlen+0x15>
		n++;
  8012ec:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ef:	ff 45 08             	incl   0x8(%ebp)
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	84 c0                	test   %al,%al
  8012f9:	75 f1                	jne    8012ec <strlen+0xf>
		n++;
	return n;
  8012fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801306:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80130d:	eb 09                	jmp    801318 <strnlen+0x18>
		n++;
  80130f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801312:	ff 45 08             	incl   0x8(%ebp)
  801315:	ff 4d 0c             	decl   0xc(%ebp)
  801318:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131c:	74 09                	je     801327 <strnlen+0x27>
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	8a 00                	mov    (%eax),%al
  801323:	84 c0                	test   %al,%al
  801325:	75 e8                	jne    80130f <strnlen+0xf>
		n++;
	return n;
  801327:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801338:	90                   	nop
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8d 50 01             	lea    0x1(%eax),%edx
  80133f:	89 55 08             	mov    %edx,0x8(%ebp)
  801342:	8b 55 0c             	mov    0xc(%ebp),%edx
  801345:	8d 4a 01             	lea    0x1(%edx),%ecx
  801348:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80134b:	8a 12                	mov    (%edx),%dl
  80134d:	88 10                	mov    %dl,(%eax)
  80134f:	8a 00                	mov    (%eax),%al
  801351:	84 c0                	test   %al,%al
  801353:	75 e4                	jne    801339 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801355:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801366:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136d:	eb 1f                	jmp    80138e <strncpy+0x34>
		*dst++ = *src;
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	8d 50 01             	lea    0x1(%eax),%edx
  801375:	89 55 08             	mov    %edx,0x8(%ebp)
  801378:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137b:	8a 12                	mov    (%edx),%dl
  80137d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	84 c0                	test   %al,%al
  801386:	74 03                	je     80138b <strncpy+0x31>
			src++;
  801388:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80138b:	ff 45 fc             	incl   -0x4(%ebp)
  80138e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801391:	3b 45 10             	cmp    0x10(%ebp),%eax
  801394:	72 d9                	jb     80136f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801396:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ab:	74 30                	je     8013dd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013ad:	eb 16                	jmp    8013c5 <strlcpy+0x2a>
			*dst++ = *src++;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8d 50 01             	lea    0x1(%eax),%edx
  8013b5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013bb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013be:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013c1:	8a 12                	mov    (%edx),%dl
  8013c3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013c5:	ff 4d 10             	decl   0x10(%ebp)
  8013c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013cc:	74 09                	je     8013d7 <strlcpy+0x3c>
  8013ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	84 c0                	test   %al,%al
  8013d5:	75 d8                	jne    8013af <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e3:	29 c2                	sub    %eax,%edx
  8013e5:	89 d0                	mov    %edx,%eax
}
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013ec:	eb 06                	jmp    8013f4 <strcmp+0xb>
		p++, q++;
  8013ee:	ff 45 08             	incl   0x8(%ebp)
  8013f1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	84 c0                	test   %al,%al
  8013fb:	74 0e                	je     80140b <strcmp+0x22>
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	8a 10                	mov    (%eax),%dl
  801402:	8b 45 0c             	mov    0xc(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	38 c2                	cmp    %al,%dl
  801409:	74 e3                	je     8013ee <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	0f b6 d0             	movzbl %al,%edx
  801413:	8b 45 0c             	mov    0xc(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	0f b6 c0             	movzbl %al,%eax
  80141b:	29 c2                	sub    %eax,%edx
  80141d:	89 d0                	mov    %edx,%eax
}
  80141f:	5d                   	pop    %ebp
  801420:	c3                   	ret    

00801421 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801424:	eb 09                	jmp    80142f <strncmp+0xe>
		n--, p++, q++;
  801426:	ff 4d 10             	decl   0x10(%ebp)
  801429:	ff 45 08             	incl   0x8(%ebp)
  80142c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80142f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801433:	74 17                	je     80144c <strncmp+0x2b>
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	84 c0                	test   %al,%al
  80143c:	74 0e                	je     80144c <strncmp+0x2b>
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	8a 10                	mov    (%eax),%dl
  801443:	8b 45 0c             	mov    0xc(%ebp),%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	38 c2                	cmp    %al,%dl
  80144a:	74 da                	je     801426 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80144c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801450:	75 07                	jne    801459 <strncmp+0x38>
		return 0;
  801452:	b8 00 00 00 00       	mov    $0x0,%eax
  801457:	eb 14                	jmp    80146d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8a 00                	mov    (%eax),%al
  80145e:	0f b6 d0             	movzbl %al,%edx
  801461:	8b 45 0c             	mov    0xc(%ebp),%eax
  801464:	8a 00                	mov    (%eax),%al
  801466:	0f b6 c0             	movzbl %al,%eax
  801469:	29 c2                	sub    %eax,%edx
  80146b:	89 d0                	mov    %edx,%eax
}
  80146d:	5d                   	pop    %ebp
  80146e:	c3                   	ret    

0080146f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	83 ec 04             	sub    $0x4,%esp
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80147b:	eb 12                	jmp    80148f <strchr+0x20>
		if (*s == c)
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801485:	75 05                	jne    80148c <strchr+0x1d>
			return (char *) s;
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	eb 11                	jmp    80149d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80148c:	ff 45 08             	incl   0x8(%ebp)
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	84 c0                	test   %al,%al
  801496:	75 e5                	jne    80147d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801498:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	83 ec 04             	sub    $0x4,%esp
  8014a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014ab:	eb 0d                	jmp    8014ba <strfind+0x1b>
		if (*s == c)
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	8a 00                	mov    (%eax),%al
  8014b2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014b5:	74 0e                	je     8014c5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014b7:	ff 45 08             	incl   0x8(%ebp)
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	84 c0                	test   %al,%al
  8014c1:	75 ea                	jne    8014ad <strfind+0xe>
  8014c3:	eb 01                	jmp    8014c6 <strfind+0x27>
		if (*s == c)
			break;
  8014c5:	90                   	nop
	return (char *) s;
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014dd:	eb 0e                	jmp    8014ed <memset+0x22>
		*p++ = c;
  8014df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e2:	8d 50 01             	lea    0x1(%eax),%edx
  8014e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014eb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014ed:	ff 4d f8             	decl   -0x8(%ebp)
  8014f0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014f4:	79 e9                	jns    8014df <memset+0x14>
		*p++ = c;

	return v;
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801501:	8b 45 0c             	mov    0xc(%ebp),%eax
  801504:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80150d:	eb 16                	jmp    801525 <memcpy+0x2a>
		*d++ = *s++;
  80150f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801512:	8d 50 01             	lea    0x1(%eax),%edx
  801515:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801518:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801521:	8a 12                	mov    (%edx),%dl
  801523:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801525:	8b 45 10             	mov    0x10(%ebp),%eax
  801528:	8d 50 ff             	lea    -0x1(%eax),%edx
  80152b:	89 55 10             	mov    %edx,0x10(%ebp)
  80152e:	85 c0                	test   %eax,%eax
  801530:	75 dd                	jne    80150f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80153d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801540:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801549:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80154f:	73 50                	jae    8015a1 <memmove+0x6a>
  801551:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	01 d0                	add    %edx,%eax
  801559:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80155c:	76 43                	jbe    8015a1 <memmove+0x6a>
		s += n;
  80155e:	8b 45 10             	mov    0x10(%ebp),%eax
  801561:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801564:	8b 45 10             	mov    0x10(%ebp),%eax
  801567:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80156a:	eb 10                	jmp    80157c <memmove+0x45>
			*--d = *--s;
  80156c:	ff 4d f8             	decl   -0x8(%ebp)
  80156f:	ff 4d fc             	decl   -0x4(%ebp)
  801572:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801575:	8a 10                	mov    (%eax),%dl
  801577:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80157c:	8b 45 10             	mov    0x10(%ebp),%eax
  80157f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801582:	89 55 10             	mov    %edx,0x10(%ebp)
  801585:	85 c0                	test   %eax,%eax
  801587:	75 e3                	jne    80156c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801589:	eb 23                	jmp    8015ae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80158b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158e:	8d 50 01             	lea    0x1(%eax),%edx
  801591:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801594:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801597:	8d 4a 01             	lea    0x1(%edx),%ecx
  80159a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80159d:	8a 12                	mov    (%edx),%dl
  80159f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8015a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	75 dd                	jne    80158b <memmove+0x54>
			*d++ = *s++;

	return dst;
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015c5:	eb 2a                	jmp    8015f1 <memcmp+0x3e>
		if (*s1 != *s2)
  8015c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ca:	8a 10                	mov    (%eax),%dl
  8015cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	38 c2                	cmp    %al,%dl
  8015d3:	74 16                	je     8015eb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d8:	8a 00                	mov    (%eax),%al
  8015da:	0f b6 d0             	movzbl %al,%edx
  8015dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e0:	8a 00                	mov    (%eax),%al
  8015e2:	0f b6 c0             	movzbl %al,%eax
  8015e5:	29 c2                	sub    %eax,%edx
  8015e7:	89 d0                	mov    %edx,%eax
  8015e9:	eb 18                	jmp    801603 <memcmp+0x50>
		s1++, s2++;
  8015eb:	ff 45 fc             	incl   -0x4(%ebp)
  8015ee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8015fa:	85 c0                	test   %eax,%eax
  8015fc:	75 c9                	jne    8015c7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80160b:	8b 55 08             	mov    0x8(%ebp),%edx
  80160e:	8b 45 10             	mov    0x10(%ebp),%eax
  801611:	01 d0                	add    %edx,%eax
  801613:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801616:	eb 15                	jmp    80162d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	8a 00                	mov    (%eax),%al
  80161d:	0f b6 d0             	movzbl %al,%edx
  801620:	8b 45 0c             	mov    0xc(%ebp),%eax
  801623:	0f b6 c0             	movzbl %al,%eax
  801626:	39 c2                	cmp    %eax,%edx
  801628:	74 0d                	je     801637 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80162a:	ff 45 08             	incl   0x8(%ebp)
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801633:	72 e3                	jb     801618 <memfind+0x13>
  801635:	eb 01                	jmp    801638 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801637:	90                   	nop
	return (void *) s;
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801643:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80164a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801651:	eb 03                	jmp    801656 <strtol+0x19>
		s++;
  801653:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	8a 00                	mov    (%eax),%al
  80165b:	3c 20                	cmp    $0x20,%al
  80165d:	74 f4                	je     801653 <strtol+0x16>
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	8a 00                	mov    (%eax),%al
  801664:	3c 09                	cmp    $0x9,%al
  801666:	74 eb                	je     801653 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	3c 2b                	cmp    $0x2b,%al
  80166f:	75 05                	jne    801676 <strtol+0x39>
		s++;
  801671:	ff 45 08             	incl   0x8(%ebp)
  801674:	eb 13                	jmp    801689 <strtol+0x4c>
	else if (*s == '-')
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	3c 2d                	cmp    $0x2d,%al
  80167d:	75 0a                	jne    801689 <strtol+0x4c>
		s++, neg = 1;
  80167f:	ff 45 08             	incl   0x8(%ebp)
  801682:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801689:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168d:	74 06                	je     801695 <strtol+0x58>
  80168f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801693:	75 20                	jne    8016b5 <strtol+0x78>
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	8a 00                	mov    (%eax),%al
  80169a:	3c 30                	cmp    $0x30,%al
  80169c:	75 17                	jne    8016b5 <strtol+0x78>
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	40                   	inc    %eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	3c 78                	cmp    $0x78,%al
  8016a6:	75 0d                	jne    8016b5 <strtol+0x78>
		s += 2, base = 16;
  8016a8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8016ac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016b3:	eb 28                	jmp    8016dd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b9:	75 15                	jne    8016d0 <strtol+0x93>
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	3c 30                	cmp    $0x30,%al
  8016c2:	75 0c                	jne    8016d0 <strtol+0x93>
		s++, base = 8;
  8016c4:	ff 45 08             	incl   0x8(%ebp)
  8016c7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016ce:	eb 0d                	jmp    8016dd <strtol+0xa0>
	else if (base == 0)
  8016d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d4:	75 07                	jne    8016dd <strtol+0xa0>
		base = 10;
  8016d6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8a 00                	mov    (%eax),%al
  8016e2:	3c 2f                	cmp    $0x2f,%al
  8016e4:	7e 19                	jle    8016ff <strtol+0xc2>
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	8a 00                	mov    (%eax),%al
  8016eb:	3c 39                	cmp    $0x39,%al
  8016ed:	7f 10                	jg     8016ff <strtol+0xc2>
			dig = *s - '0';
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	0f be c0             	movsbl %al,%eax
  8016f7:	83 e8 30             	sub    $0x30,%eax
  8016fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016fd:	eb 42                	jmp    801741 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	8a 00                	mov    (%eax),%al
  801704:	3c 60                	cmp    $0x60,%al
  801706:	7e 19                	jle    801721 <strtol+0xe4>
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	8a 00                	mov    (%eax),%al
  80170d:	3c 7a                	cmp    $0x7a,%al
  80170f:	7f 10                	jg     801721 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8a 00                	mov    (%eax),%al
  801716:	0f be c0             	movsbl %al,%eax
  801719:	83 e8 57             	sub    $0x57,%eax
  80171c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80171f:	eb 20                	jmp    801741 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	8a 00                	mov    (%eax),%al
  801726:	3c 40                	cmp    $0x40,%al
  801728:	7e 39                	jle    801763 <strtol+0x126>
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8a 00                	mov    (%eax),%al
  80172f:	3c 5a                	cmp    $0x5a,%al
  801731:	7f 30                	jg     801763 <strtol+0x126>
			dig = *s - 'A' + 10;
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	8a 00                	mov    (%eax),%al
  801738:	0f be c0             	movsbl %al,%eax
  80173b:	83 e8 37             	sub    $0x37,%eax
  80173e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801744:	3b 45 10             	cmp    0x10(%ebp),%eax
  801747:	7d 19                	jge    801762 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801749:	ff 45 08             	incl   0x8(%ebp)
  80174c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80174f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801753:	89 c2                	mov    %eax,%edx
  801755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801758:	01 d0                	add    %edx,%eax
  80175a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80175d:	e9 7b ff ff ff       	jmp    8016dd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801762:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801763:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801767:	74 08                	je     801771 <strtol+0x134>
		*endptr = (char *) s;
  801769:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176c:	8b 55 08             	mov    0x8(%ebp),%edx
  80176f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801771:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801775:	74 07                	je     80177e <strtol+0x141>
  801777:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177a:	f7 d8                	neg    %eax
  80177c:	eb 03                	jmp    801781 <strtol+0x144>
  80177e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <ltostr>:

void
ltostr(long value, char *str)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801789:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801790:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801797:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80179b:	79 13                	jns    8017b0 <ltostr+0x2d>
	{
		neg = 1;
  80179d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8017a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8017aa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8017ad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017b8:	99                   	cltd   
  8017b9:	f7 f9                	idiv   %ecx
  8017bb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c1:	8d 50 01             	lea    0x1(%eax),%edx
  8017c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017c7:	89 c2                	mov    %eax,%edx
  8017c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cc:	01 d0                	add    %edx,%eax
  8017ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017d1:	83 c2 30             	add    $0x30,%edx
  8017d4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017de:	f7 e9                	imul   %ecx
  8017e0:	c1 fa 02             	sar    $0x2,%edx
  8017e3:	89 c8                	mov    %ecx,%eax
  8017e5:	c1 f8 1f             	sar    $0x1f,%eax
  8017e8:	29 c2                	sub    %eax,%edx
  8017ea:	89 d0                	mov    %edx,%eax
  8017ec:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017f7:	f7 e9                	imul   %ecx
  8017f9:	c1 fa 02             	sar    $0x2,%edx
  8017fc:	89 c8                	mov    %ecx,%eax
  8017fe:	c1 f8 1f             	sar    $0x1f,%eax
  801801:	29 c2                	sub    %eax,%edx
  801803:	89 d0                	mov    %edx,%eax
  801805:	c1 e0 02             	shl    $0x2,%eax
  801808:	01 d0                	add    %edx,%eax
  80180a:	01 c0                	add    %eax,%eax
  80180c:	29 c1                	sub    %eax,%ecx
  80180e:	89 ca                	mov    %ecx,%edx
  801810:	85 d2                	test   %edx,%edx
  801812:	75 9c                	jne    8017b0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801814:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80181b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80181e:	48                   	dec    %eax
  80181f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801822:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801826:	74 3d                	je     801865 <ltostr+0xe2>
		start = 1 ;
  801828:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80182f:	eb 34                	jmp    801865 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801831:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801834:	8b 45 0c             	mov    0xc(%ebp),%eax
  801837:	01 d0                	add    %edx,%eax
  801839:	8a 00                	mov    (%eax),%al
  80183b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80183e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801841:	8b 45 0c             	mov    0xc(%ebp),%eax
  801844:	01 c2                	add    %eax,%edx
  801846:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184c:	01 c8                	add    %ecx,%eax
  80184e:	8a 00                	mov    (%eax),%al
  801850:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801852:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801855:	8b 45 0c             	mov    0xc(%ebp),%eax
  801858:	01 c2                	add    %eax,%edx
  80185a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80185d:	88 02                	mov    %al,(%edx)
		start++ ;
  80185f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801862:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801868:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80186b:	7c c4                	jl     801831 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80186d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801870:	8b 45 0c             	mov    0xc(%ebp),%eax
  801873:	01 d0                	add    %edx,%eax
  801875:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801878:	90                   	nop
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801881:	ff 75 08             	pushl  0x8(%ebp)
  801884:	e8 54 fa ff ff       	call   8012dd <strlen>
  801889:	83 c4 04             	add    $0x4,%esp
  80188c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80188f:	ff 75 0c             	pushl  0xc(%ebp)
  801892:	e8 46 fa ff ff       	call   8012dd <strlen>
  801897:	83 c4 04             	add    $0x4,%esp
  80189a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80189d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8018a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ab:	eb 17                	jmp    8018c4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8018ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b3:	01 c2                	add    %eax,%edx
  8018b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	01 c8                	add    %ecx,%eax
  8018bd:	8a 00                	mov    (%eax),%al
  8018bf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018c1:	ff 45 fc             	incl   -0x4(%ebp)
  8018c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018ca:	7c e1                	jl     8018ad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018da:	eb 1f                	jmp    8018fb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018df:	8d 50 01             	lea    0x1(%eax),%edx
  8018e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018e5:	89 c2                	mov    %eax,%edx
  8018e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ea:	01 c2                	add    %eax,%edx
  8018ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f2:	01 c8                	add    %ecx,%eax
  8018f4:	8a 00                	mov    (%eax),%al
  8018f6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018f8:	ff 45 f8             	incl   -0x8(%ebp)
  8018fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801901:	7c d9                	jl     8018dc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801903:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801906:	8b 45 10             	mov    0x10(%ebp),%eax
  801909:	01 d0                	add    %edx,%eax
  80190b:	c6 00 00             	movb   $0x0,(%eax)
}
  80190e:	90                   	nop
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801914:	8b 45 14             	mov    0x14(%ebp),%eax
  801917:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80191d:	8b 45 14             	mov    0x14(%ebp),%eax
  801920:	8b 00                	mov    (%eax),%eax
  801922:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801929:	8b 45 10             	mov    0x10(%ebp),%eax
  80192c:	01 d0                	add    %edx,%eax
  80192e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801934:	eb 0c                	jmp    801942 <strsplit+0x31>
			*string++ = 0;
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	8d 50 01             	lea    0x1(%eax),%edx
  80193c:	89 55 08             	mov    %edx,0x8(%ebp)
  80193f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	8a 00                	mov    (%eax),%al
  801947:	84 c0                	test   %al,%al
  801949:	74 18                	je     801963 <strsplit+0x52>
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	8a 00                	mov    (%eax),%al
  801950:	0f be c0             	movsbl %al,%eax
  801953:	50                   	push   %eax
  801954:	ff 75 0c             	pushl  0xc(%ebp)
  801957:	e8 13 fb ff ff       	call   80146f <strchr>
  80195c:	83 c4 08             	add    $0x8,%esp
  80195f:	85 c0                	test   %eax,%eax
  801961:	75 d3                	jne    801936 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	8a 00                	mov    (%eax),%al
  801968:	84 c0                	test   %al,%al
  80196a:	74 5a                	je     8019c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80196c:	8b 45 14             	mov    0x14(%ebp),%eax
  80196f:	8b 00                	mov    (%eax),%eax
  801971:	83 f8 0f             	cmp    $0xf,%eax
  801974:	75 07                	jne    80197d <strsplit+0x6c>
		{
			return 0;
  801976:	b8 00 00 00 00       	mov    $0x0,%eax
  80197b:	eb 66                	jmp    8019e3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80197d:	8b 45 14             	mov    0x14(%ebp),%eax
  801980:	8b 00                	mov    (%eax),%eax
  801982:	8d 48 01             	lea    0x1(%eax),%ecx
  801985:	8b 55 14             	mov    0x14(%ebp),%edx
  801988:	89 0a                	mov    %ecx,(%edx)
  80198a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801991:	8b 45 10             	mov    0x10(%ebp),%eax
  801994:	01 c2                	add    %eax,%edx
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80199b:	eb 03                	jmp    8019a0 <strsplit+0x8f>
			string++;
  80199d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	8a 00                	mov    (%eax),%al
  8019a5:	84 c0                	test   %al,%al
  8019a7:	74 8b                	je     801934 <strsplit+0x23>
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	8a 00                	mov    (%eax),%al
  8019ae:	0f be c0             	movsbl %al,%eax
  8019b1:	50                   	push   %eax
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	e8 b5 fa ff ff       	call   80146f <strchr>
  8019ba:	83 c4 08             	add    $0x8,%esp
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	74 dc                	je     80199d <strsplit+0x8c>
			string++;
	}
  8019c1:	e9 6e ff ff ff       	jmp    801934 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ca:	8b 00                	mov    (%eax),%eax
  8019cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d6:	01 d0                	add    %edx,%eax
  8019d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8019eb:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8019f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8019f8:	01 d0                	add    %edx,%eax
  8019fa:	48                   	dec    %eax
  8019fb:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8019fe:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801a01:	ba 00 00 00 00       	mov    $0x0,%edx
  801a06:	f7 75 ac             	divl   -0x54(%ebp)
  801a09:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801a0c:	29 d0                	sub    %edx,%eax
  801a0e:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801a11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801a18:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801a1f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801a26:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a2d:	eb 3f                	jmp    801a6e <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801a2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a32:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801a39:	83 ec 04             	sub    $0x4,%esp
  801a3c:	50                   	push   %eax
  801a3d:	ff 75 e8             	pushl  -0x18(%ebp)
  801a40:	68 50 30 80 00       	push   $0x803050
  801a45:	e8 11 f2 ff ff       	call   800c5b <cprintf>
  801a4a:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a50:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801a57:	83 ec 04             	sub    $0x4,%esp
  801a5a:	50                   	push   %eax
  801a5b:	ff 75 e8             	pushl  -0x18(%ebp)
  801a5e:	68 65 30 80 00       	push   $0x803065
  801a63:	e8 f3 f1 ff ff       	call   800c5b <cprintf>
  801a68:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801a6b:	ff 45 e8             	incl   -0x18(%ebp)
  801a6e:	a1 28 40 80 00       	mov    0x804028,%eax
  801a73:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801a76:	7c b7                	jl     801a2f <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801a78:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801a7f:	e9 42 01 00 00       	jmp    801bc6 <malloc+0x1e1>
		int flag0=1;
  801a84:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801a8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a8e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a91:	eb 6b                	jmp    801afe <malloc+0x119>
			for(int k=0;k<count;k++){
  801a93:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801a9a:	eb 42                	jmp    801ade <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801a9c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a9f:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801aa6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aa9:	39 c2                	cmp    %eax,%edx
  801aab:	77 2e                	ja     801adb <malloc+0xf6>
  801aad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ab0:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801ab7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aba:	39 c2                	cmp    %eax,%edx
  801abc:	76 1d                	jbe    801adb <malloc+0xf6>
					ni=arr_add[k].end-i;
  801abe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ac1:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801ac8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801acb:	29 c2                	sub    %eax,%edx
  801acd:	89 d0                	mov    %edx,%eax
  801acf:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801ad2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801ad9:	eb 0d                	jmp    801ae8 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801adb:	ff 45 d8             	incl   -0x28(%ebp)
  801ade:	a1 28 40 80 00       	mov    0x804028,%eax
  801ae3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801ae6:	7c b4                	jl     801a9c <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801ae8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801aec:	74 09                	je     801af7 <malloc+0x112>
				flag0=0;
  801aee:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801af5:	eb 16                	jmp    801b0d <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801af7:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801afe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	01 c2                	add    %eax,%edx
  801b06:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b09:	39 c2                	cmp    %eax,%edx
  801b0b:	77 86                	ja     801a93 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801b0d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b11:	0f 84 a2 00 00 00    	je     801bb9 <malloc+0x1d4>

			int f=1;
  801b17:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801b1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b21:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801b24:	89 c8                	mov    %ecx,%eax
  801b26:	01 c0                	add    %eax,%eax
  801b28:	01 c8                	add    %ecx,%eax
  801b2a:	c1 e0 02             	shl    $0x2,%eax
  801b2d:	05 20 41 80 00       	add    $0x804120,%eax
  801b32:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801b34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801b3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b40:	89 d0                	mov    %edx,%eax
  801b42:	01 c0                	add    %eax,%eax
  801b44:	01 d0                	add    %edx,%eax
  801b46:	c1 e0 02             	shl    $0x2,%eax
  801b49:	05 24 41 80 00       	add    $0x804124,%eax
  801b4e:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b53:	89 d0                	mov    %edx,%eax
  801b55:	01 c0                	add    %eax,%eax
  801b57:	01 d0                	add    %edx,%eax
  801b59:	c1 e0 02             	shl    $0x2,%eax
  801b5c:	05 28 41 80 00       	add    $0x804128,%eax
  801b61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801b67:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801b6a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801b71:	eb 36                	jmp    801ba9 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801b73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	01 c2                	add    %eax,%edx
  801b7b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b7e:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801b85:	39 c2                	cmp    %eax,%edx
  801b87:	73 1d                	jae    801ba6 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801b89:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b8c:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801b93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b96:	29 c2                	sub    %eax,%edx
  801b98:	89 d0                	mov    %edx,%eax
  801b9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801b9d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801ba4:	eb 0d                	jmp    801bb3 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801ba6:	ff 45 d0             	incl   -0x30(%ebp)
  801ba9:	a1 28 40 80 00       	mov    0x804028,%eax
  801bae:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801bb1:	7c c0                	jl     801b73 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801bb3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801bb7:	75 1d                	jne    801bd6 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801bb9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801bc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc3:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801bc6:	a1 04 40 80 00       	mov    0x804004,%eax
  801bcb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bce:	0f 8c b0 fe ff ff    	jl     801a84 <malloc+0x9f>
  801bd4:	eb 01                	jmp    801bd7 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801bd6:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801bd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bdb:	75 7a                	jne    801c57 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801bdd:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	01 d0                	add    %edx,%eax
  801be8:	48                   	dec    %eax
  801be9:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801bee:	7c 0a                	jl     801bfa <malloc+0x215>
			return NULL;
  801bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf5:	e9 a4 02 00 00       	jmp    801e9e <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801bfa:	a1 04 40 80 00       	mov    0x804004,%eax
  801bff:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801c02:	a1 28 40 80 00       	mov    0x804028,%eax
  801c07:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801c0a:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801c11:	83 ec 08             	sub    $0x8,%esp
  801c14:	ff 75 08             	pushl  0x8(%ebp)
  801c17:	ff 75 a4             	pushl  -0x5c(%ebp)
  801c1a:	e8 04 06 00 00       	call   802223 <sys_allocateMem>
  801c1f:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801c22:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	01 d0                	add    %edx,%eax
  801c2d:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801c32:	a1 28 40 80 00       	mov    0x804028,%eax
  801c37:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c3d:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801c44:	a1 28 40 80 00       	mov    0x804028,%eax
  801c49:	40                   	inc    %eax
  801c4a:	a3 28 40 80 00       	mov    %eax,0x804028

			return (void*)s;
  801c4f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801c52:	e9 47 02 00 00       	jmp    801e9e <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801c57:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801c5e:	e9 ac 00 00 00       	jmp    801d0f <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801c63:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801c66:	89 d0                	mov    %edx,%eax
  801c68:	01 c0                	add    %eax,%eax
  801c6a:	01 d0                	add    %edx,%eax
  801c6c:	c1 e0 02             	shl    $0x2,%eax
  801c6f:	05 24 41 80 00       	add    $0x804124,%eax
  801c74:	8b 00                	mov    (%eax),%eax
  801c76:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801c79:	eb 7e                	jmp    801cf9 <malloc+0x314>
			int flag=0;
  801c7b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801c82:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801c89:	eb 57                	jmp    801ce2 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801c8b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c8e:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801c95:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c98:	39 c2                	cmp    %eax,%edx
  801c9a:	77 1a                	ja     801cb6 <malloc+0x2d1>
  801c9c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c9f:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801ca6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ca9:	39 c2                	cmp    %eax,%edx
  801cab:	76 09                	jbe    801cb6 <malloc+0x2d1>
								flag=1;
  801cad:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801cb4:	eb 36                	jmp    801cec <malloc+0x307>
			arr[i].space++;
  801cb6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801cb9:	89 d0                	mov    %edx,%eax
  801cbb:	01 c0                	add    %eax,%eax
  801cbd:	01 d0                	add    %edx,%eax
  801cbf:	c1 e0 02             	shl    $0x2,%eax
  801cc2:	05 28 41 80 00       	add    $0x804128,%eax
  801cc7:	8b 00                	mov    (%eax),%eax
  801cc9:	8d 48 01             	lea    0x1(%eax),%ecx
  801ccc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801ccf:	89 d0                	mov    %edx,%eax
  801cd1:	01 c0                	add    %eax,%eax
  801cd3:	01 d0                	add    %edx,%eax
  801cd5:	c1 e0 02             	shl    $0x2,%eax
  801cd8:	05 28 41 80 00       	add    $0x804128,%eax
  801cdd:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801cdf:	ff 45 c0             	incl   -0x40(%ebp)
  801ce2:	a1 28 40 80 00       	mov    0x804028,%eax
  801ce7:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801cea:	7c 9f                	jl     801c8b <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801cec:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801cf0:	75 19                	jne    801d0b <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801cf2:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801cf9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801cfc:	a1 04 40 80 00       	mov    0x804004,%eax
  801d01:	39 c2                	cmp    %eax,%edx
  801d03:	0f 82 72 ff ff ff    	jb     801c7b <malloc+0x296>
  801d09:	eb 01                	jmp    801d0c <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801d0b:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801d0c:	ff 45 cc             	incl   -0x34(%ebp)
  801d0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d12:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d15:	0f 8c 48 ff ff ff    	jl     801c63 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801d1b:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801d22:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801d29:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801d30:	eb 37                	jmp    801d69 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801d32:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801d35:	89 d0                	mov    %edx,%eax
  801d37:	01 c0                	add    %eax,%eax
  801d39:	01 d0                	add    %edx,%eax
  801d3b:	c1 e0 02             	shl    $0x2,%eax
  801d3e:	05 28 41 80 00       	add    $0x804128,%eax
  801d43:	8b 00                	mov    (%eax),%eax
  801d45:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801d48:	7d 1c                	jge    801d66 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801d4a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801d4d:	89 d0                	mov    %edx,%eax
  801d4f:	01 c0                	add    %eax,%eax
  801d51:	01 d0                	add    %edx,%eax
  801d53:	c1 e0 02             	shl    $0x2,%eax
  801d56:	05 28 41 80 00       	add    $0x804128,%eax
  801d5b:	8b 00                	mov    (%eax),%eax
  801d5d:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801d60:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801d63:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801d66:	ff 45 b4             	incl   -0x4c(%ebp)
  801d69:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801d6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d6f:	7c c1                	jl     801d32 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801d71:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801d77:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801d7a:	89 c8                	mov    %ecx,%eax
  801d7c:	01 c0                	add    %eax,%eax
  801d7e:	01 c8                	add    %ecx,%eax
  801d80:	c1 e0 02             	shl    $0x2,%eax
  801d83:	05 20 41 80 00       	add    $0x804120,%eax
  801d88:	8b 00                	mov    (%eax),%eax
  801d8a:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801d91:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801d97:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801d9a:	89 c8                	mov    %ecx,%eax
  801d9c:	01 c0                	add    %eax,%eax
  801d9e:	01 c8                	add    %ecx,%eax
  801da0:	c1 e0 02             	shl    $0x2,%eax
  801da3:	05 24 41 80 00       	add    $0x804124,%eax
  801da8:	8b 00                	mov    (%eax),%eax
  801daa:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  801db1:	a1 28 40 80 00       	mov    0x804028,%eax
  801db6:	40                   	inc    %eax
  801db7:	a3 28 40 80 00       	mov    %eax,0x804028


		sys_allocateMem(arr[index].start,size);
  801dbc:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801dbf:	89 d0                	mov    %edx,%eax
  801dc1:	01 c0                	add    %eax,%eax
  801dc3:	01 d0                	add    %edx,%eax
  801dc5:	c1 e0 02             	shl    $0x2,%eax
  801dc8:	05 20 41 80 00       	add    $0x804120,%eax
  801dcd:	8b 00                	mov    (%eax),%eax
  801dcf:	83 ec 08             	sub    $0x8,%esp
  801dd2:	ff 75 08             	pushl  0x8(%ebp)
  801dd5:	50                   	push   %eax
  801dd6:	e8 48 04 00 00       	call   802223 <sys_allocateMem>
  801ddb:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801dde:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801de5:	eb 78                	jmp    801e5f <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801de7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801dea:	89 d0                	mov    %edx,%eax
  801dec:	01 c0                	add    %eax,%eax
  801dee:	01 d0                	add    %edx,%eax
  801df0:	c1 e0 02             	shl    $0x2,%eax
  801df3:	05 20 41 80 00       	add    $0x804120,%eax
  801df8:	8b 00                	mov    (%eax),%eax
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	50                   	push   %eax
  801dfe:	ff 75 b0             	pushl  -0x50(%ebp)
  801e01:	68 50 30 80 00       	push   $0x803050
  801e06:	e8 50 ee ff ff       	call   800c5b <cprintf>
  801e0b:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801e0e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e11:	89 d0                	mov    %edx,%eax
  801e13:	01 c0                	add    %eax,%eax
  801e15:	01 d0                	add    %edx,%eax
  801e17:	c1 e0 02             	shl    $0x2,%eax
  801e1a:	05 24 41 80 00       	add    $0x804124,%eax
  801e1f:	8b 00                	mov    (%eax),%eax
  801e21:	83 ec 04             	sub    $0x4,%esp
  801e24:	50                   	push   %eax
  801e25:	ff 75 b0             	pushl  -0x50(%ebp)
  801e28:	68 65 30 80 00       	push   $0x803065
  801e2d:	e8 29 ee ff ff       	call   800c5b <cprintf>
  801e32:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801e35:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e38:	89 d0                	mov    %edx,%eax
  801e3a:	01 c0                	add    %eax,%eax
  801e3c:	01 d0                	add    %edx,%eax
  801e3e:	c1 e0 02             	shl    $0x2,%eax
  801e41:	05 28 41 80 00       	add    $0x804128,%eax
  801e46:	8b 00                	mov    (%eax),%eax
  801e48:	83 ec 04             	sub    $0x4,%esp
  801e4b:	50                   	push   %eax
  801e4c:	ff 75 b0             	pushl  -0x50(%ebp)
  801e4f:	68 78 30 80 00       	push   $0x803078
  801e54:	e8 02 ee ff ff       	call   800c5b <cprintf>
  801e59:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801e5c:	ff 45 b0             	incl   -0x50(%ebp)
  801e5f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801e62:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e65:	7c 80                	jl     801de7 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801e67:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e6a:	89 d0                	mov    %edx,%eax
  801e6c:	01 c0                	add    %eax,%eax
  801e6e:	01 d0                	add    %edx,%eax
  801e70:	c1 e0 02             	shl    $0x2,%eax
  801e73:	05 20 41 80 00       	add    $0x804120,%eax
  801e78:	8b 00                	mov    (%eax),%eax
  801e7a:	83 ec 08             	sub    $0x8,%esp
  801e7d:	50                   	push   %eax
  801e7e:	68 8c 30 80 00       	push   $0x80308c
  801e83:	e8 d3 ed ff ff       	call   800c5b <cprintf>
  801e88:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801e8b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e8e:	89 d0                	mov    %edx,%eax
  801e90:	01 c0                	add    %eax,%eax
  801e92:	01 d0                	add    %edx,%eax
  801e94:	c1 e0 02             	shl    $0x2,%eax
  801e97:	05 20 41 80 00       	add    $0x804120,%eax
  801e9c:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801eac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801eb3:	eb 4b                	jmp    801f00 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb8:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801ebf:	89 c2                	mov    %eax,%edx
  801ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ec4:	39 c2                	cmp    %eax,%edx
  801ec6:	7f 35                	jg     801efd <free+0x5d>
  801ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ecb:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801ed2:	89 c2                	mov    %eax,%edx
  801ed4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ed7:	39 c2                	cmp    %eax,%edx
  801ed9:	7e 22                	jle    801efd <free+0x5d>
				start=arr_add[i].start;
  801edb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ede:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801ee8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eeb:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801ef2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801efb:	eb 0d                	jmp    801f0a <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801efd:	ff 45 ec             	incl   -0x14(%ebp)
  801f00:	a1 28 40 80 00       	mov    0x804028,%eax
  801f05:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801f08:	7c ab                	jl     801eb5 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0d:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f17:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801f1e:	29 c2                	sub    %eax,%edx
  801f20:	89 d0                	mov    %edx,%eax
  801f22:	83 ec 08             	sub    $0x8,%esp
  801f25:	50                   	push   %eax
  801f26:	ff 75 f4             	pushl  -0xc(%ebp)
  801f29:	e8 d9 02 00 00       	call   802207 <sys_freeMem>
  801f2e:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f34:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f37:	eb 2d                	jmp    801f66 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801f39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f3c:	40                   	inc    %eax
  801f3d:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801f44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f47:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801f4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f51:	40                   	inc    %eax
  801f52:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801f59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f5c:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801f63:	ff 45 e8             	incl   -0x18(%ebp)
  801f66:	a1 28 40 80 00       	mov    0x804028,%eax
  801f6b:	48                   	dec    %eax
  801f6c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f6f:	7f c8                	jg     801f39 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801f71:	a1 28 40 80 00       	mov    0x804028,%eax
  801f76:	48                   	dec    %eax
  801f77:	a3 28 40 80 00       	mov    %eax,0x804028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801f7c:	90                   	nop
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 18             	sub    $0x18,%esp
  801f85:	8b 45 10             	mov    0x10(%ebp),%eax
  801f88:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801f8b:	83 ec 04             	sub    $0x4,%esp
  801f8e:	68 a8 30 80 00       	push   $0x8030a8
  801f93:	68 18 01 00 00       	push   $0x118
  801f98:	68 cb 30 80 00       	push   $0x8030cb
  801f9d:	e8 17 ea ff ff       	call   8009b9 <_panic>

00801fa2 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fa8:	83 ec 04             	sub    $0x4,%esp
  801fab:	68 a8 30 80 00       	push   $0x8030a8
  801fb0:	68 1e 01 00 00       	push   $0x11e
  801fb5:	68 cb 30 80 00       	push   $0x8030cb
  801fba:	e8 fa e9 ff ff       	call   8009b9 <_panic>

00801fbf <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fc5:	83 ec 04             	sub    $0x4,%esp
  801fc8:	68 a8 30 80 00       	push   $0x8030a8
  801fcd:	68 24 01 00 00       	push   $0x124
  801fd2:	68 cb 30 80 00       	push   $0x8030cb
  801fd7:	e8 dd e9 ff ff       	call   8009b9 <_panic>

00801fdc <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fe2:	83 ec 04             	sub    $0x4,%esp
  801fe5:	68 a8 30 80 00       	push   $0x8030a8
  801fea:	68 29 01 00 00       	push   $0x129
  801fef:	68 cb 30 80 00       	push   $0x8030cb
  801ff4:	e8 c0 e9 ff ff       	call   8009b9 <_panic>

00801ff9 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fff:	83 ec 04             	sub    $0x4,%esp
  802002:	68 a8 30 80 00       	push   $0x8030a8
  802007:	68 2f 01 00 00       	push   $0x12f
  80200c:	68 cb 30 80 00       	push   $0x8030cb
  802011:	e8 a3 e9 ff ff       	call   8009b9 <_panic>

00802016 <shrink>:
}
void shrink(uint32 newSize)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80201c:	83 ec 04             	sub    $0x4,%esp
  80201f:	68 a8 30 80 00       	push   $0x8030a8
  802024:	68 33 01 00 00       	push   $0x133
  802029:	68 cb 30 80 00       	push   $0x8030cb
  80202e:	e8 86 e9 ff ff       	call   8009b9 <_panic>

00802033 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802039:	83 ec 04             	sub    $0x4,%esp
  80203c:	68 a8 30 80 00       	push   $0x8030a8
  802041:	68 38 01 00 00       	push   $0x138
  802046:	68 cb 30 80 00       	push   $0x8030cb
  80204b:	e8 69 e9 ff ff       	call   8009b9 <_panic>

00802050 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	57                   	push   %edi
  802054:	56                   	push   %esi
  802055:	53                   	push   %ebx
  802056:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802062:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802065:	8b 7d 18             	mov    0x18(%ebp),%edi
  802068:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80206b:	cd 30                	int    $0x30
  80206d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802070:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802073:	83 c4 10             	add    $0x10,%esp
  802076:	5b                   	pop    %ebx
  802077:	5e                   	pop    %esi
  802078:	5f                   	pop    %edi
  802079:	5d                   	pop    %ebp
  80207a:	c3                   	ret    

0080207b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	83 ec 04             	sub    $0x4,%esp
  802081:	8b 45 10             	mov    0x10(%ebp),%eax
  802084:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802087:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	52                   	push   %edx
  802093:	ff 75 0c             	pushl  0xc(%ebp)
  802096:	50                   	push   %eax
  802097:	6a 00                	push   $0x0
  802099:	e8 b2 ff ff ff       	call   802050 <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
}
  8020a1:	90                   	nop
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 01                	push   $0x1
  8020b3:	e8 98 ff ff ff       	call   802050 <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	50                   	push   %eax
  8020cc:	6a 05                	push   $0x5
  8020ce:	e8 7d ff ff ff       	call   802050 <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 02                	push   $0x2
  8020e7:	e8 64 ff ff ff       	call   802050 <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 03                	push   $0x3
  802100:	e8 4b ff ff ff       	call   802050 <syscall>
  802105:	83 c4 18             	add    $0x18,%esp
}
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 04                	push   $0x4
  802119:	e8 32 ff ff ff       	call   802050 <syscall>
  80211e:	83 c4 18             	add    $0x18,%esp
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <sys_env_exit>:


void sys_env_exit(void)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 06                	push   $0x6
  802132:	e8 19 ff ff ff       	call   802050 <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
}
  80213a:	90                   	nop
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802140:	8b 55 0c             	mov    0xc(%ebp),%edx
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	52                   	push   %edx
  80214d:	50                   	push   %eax
  80214e:	6a 07                	push   $0x7
  802150:	e8 fb fe ff ff       	call   802050 <syscall>
  802155:	83 c4 18             	add    $0x18,%esp
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	56                   	push   %esi
  80215e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80215f:	8b 75 18             	mov    0x18(%ebp),%esi
  802162:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802165:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802168:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	56                   	push   %esi
  80216f:	53                   	push   %ebx
  802170:	51                   	push   %ecx
  802171:	52                   	push   %edx
  802172:	50                   	push   %eax
  802173:	6a 08                	push   $0x8
  802175:	e8 d6 fe ff ff       	call   802050 <syscall>
  80217a:	83 c4 18             	add    $0x18,%esp
}
  80217d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802180:	5b                   	pop    %ebx
  802181:	5e                   	pop    %esi
  802182:	5d                   	pop    %ebp
  802183:	c3                   	ret    

00802184 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	52                   	push   %edx
  802194:	50                   	push   %eax
  802195:	6a 09                	push   $0x9
  802197:	e8 b4 fe ff ff       	call   802050 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	ff 75 0c             	pushl  0xc(%ebp)
  8021ad:	ff 75 08             	pushl  0x8(%ebp)
  8021b0:	6a 0a                	push   $0xa
  8021b2:	e8 99 fe ff ff       	call   802050 <syscall>
  8021b7:	83 c4 18             	add    $0x18,%esp
}
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 0b                	push   $0xb
  8021cb:	e8 80 fe ff ff       	call   802050 <syscall>
  8021d0:	83 c4 18             	add    $0x18,%esp
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 0c                	push   $0xc
  8021e4:	e8 67 fe ff ff       	call   802050 <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
}
  8021ec:	c9                   	leave  
  8021ed:	c3                   	ret    

008021ee <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 0d                	push   $0xd
  8021fd:	e8 4e fe ff ff       	call   802050 <syscall>
  802202:	83 c4 18             	add    $0x18,%esp
}
  802205:	c9                   	leave  
  802206:	c3                   	ret    

00802207 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	ff 75 0c             	pushl  0xc(%ebp)
  802213:	ff 75 08             	pushl  0x8(%ebp)
  802216:	6a 11                	push   $0x11
  802218:	e8 33 fe ff ff       	call   802050 <syscall>
  80221d:	83 c4 18             	add    $0x18,%esp
	return;
  802220:	90                   	nop
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	ff 75 0c             	pushl  0xc(%ebp)
  80222f:	ff 75 08             	pushl  0x8(%ebp)
  802232:	6a 12                	push   $0x12
  802234:	e8 17 fe ff ff       	call   802050 <syscall>
  802239:	83 c4 18             	add    $0x18,%esp
	return ;
  80223c:	90                   	nop
}
  80223d:	c9                   	leave  
  80223e:	c3                   	ret    

0080223f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 0e                	push   $0xe
  80224e:	e8 fd fd ff ff       	call   802050 <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	ff 75 08             	pushl  0x8(%ebp)
  802266:	6a 0f                	push   $0xf
  802268:	e8 e3 fd ff ff       	call   802050 <syscall>
  80226d:	83 c4 18             	add    $0x18,%esp
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 10                	push   $0x10
  802281:	e8 ca fd ff ff       	call   802050 <syscall>
  802286:	83 c4 18             	add    $0x18,%esp
}
  802289:	90                   	nop
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 14                	push   $0x14
  80229b:	e8 b0 fd ff ff       	call   802050 <syscall>
  8022a0:	83 c4 18             	add    $0x18,%esp
}
  8022a3:	90                   	nop
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 15                	push   $0x15
  8022b5:	e8 96 fd ff ff       	call   802050 <syscall>
  8022ba:	83 c4 18             	add    $0x18,%esp
}
  8022bd:	90                   	nop
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <sys_cputc>:


void
sys_cputc(const char c)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	83 ec 04             	sub    $0x4,%esp
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022cc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	50                   	push   %eax
  8022d9:	6a 16                	push   $0x16
  8022db:	e8 70 fd ff ff       	call   802050 <syscall>
  8022e0:	83 c4 18             	add    $0x18,%esp
}
  8022e3:	90                   	nop
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 17                	push   $0x17
  8022f5:	e8 56 fd ff ff       	call   802050 <syscall>
  8022fa:	83 c4 18             	add    $0x18,%esp
}
  8022fd:	90                   	nop
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	ff 75 0c             	pushl  0xc(%ebp)
  80230f:	50                   	push   %eax
  802310:	6a 18                	push   $0x18
  802312:	e8 39 fd ff ff       	call   802050 <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80231f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	52                   	push   %edx
  80232c:	50                   	push   %eax
  80232d:	6a 1b                	push   $0x1b
  80232f:	e8 1c fd ff ff       	call   802050 <syscall>
  802334:	83 c4 18             	add    $0x18,%esp
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80233c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	52                   	push   %edx
  802349:	50                   	push   %eax
  80234a:	6a 19                	push   $0x19
  80234c:	e8 ff fc ff ff       	call   802050 <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
}
  802354:	90                   	nop
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80235a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	52                   	push   %edx
  802367:	50                   	push   %eax
  802368:	6a 1a                	push   $0x1a
  80236a:	e8 e1 fc ff ff       	call   802050 <syscall>
  80236f:	83 c4 18             	add    $0x18,%esp
}
  802372:	90                   	nop
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
  802378:	83 ec 04             	sub    $0x4,%esp
  80237b:	8b 45 10             	mov    0x10(%ebp),%eax
  80237e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802381:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802384:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	6a 00                	push   $0x0
  80238d:	51                   	push   %ecx
  80238e:	52                   	push   %edx
  80238f:	ff 75 0c             	pushl  0xc(%ebp)
  802392:	50                   	push   %eax
  802393:	6a 1c                	push   $0x1c
  802395:	e8 b6 fc ff ff       	call   802050 <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	52                   	push   %edx
  8023af:	50                   	push   %eax
  8023b0:	6a 1d                	push   $0x1d
  8023b2:	e8 99 fc ff ff       	call   802050 <syscall>
  8023b7:	83 c4 18             	add    $0x18,%esp
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	51                   	push   %ecx
  8023cd:	52                   	push   %edx
  8023ce:	50                   	push   %eax
  8023cf:	6a 1e                	push   $0x1e
  8023d1:	e8 7a fc ff ff       	call   802050 <syscall>
  8023d6:	83 c4 18             	add    $0x18,%esp
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	52                   	push   %edx
  8023eb:	50                   	push   %eax
  8023ec:	6a 1f                	push   $0x1f
  8023ee:	e8 5d fc ff ff       	call   802050 <syscall>
  8023f3:	83 c4 18             	add    $0x18,%esp
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 20                	push   $0x20
  802407:	e8 44 fc ff ff       	call   802050 <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	6a 00                	push   $0x0
  802419:	ff 75 14             	pushl  0x14(%ebp)
  80241c:	ff 75 10             	pushl  0x10(%ebp)
  80241f:	ff 75 0c             	pushl  0xc(%ebp)
  802422:	50                   	push   %eax
  802423:	6a 21                	push   $0x21
  802425:	e8 26 fc ff ff       	call   802050 <syscall>
  80242a:	83 c4 18             	add    $0x18,%esp
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	50                   	push   %eax
  80243e:	6a 22                	push   $0x22
  802440:	e8 0b fc ff ff       	call   802050 <syscall>
  802445:	83 c4 18             	add    $0x18,%esp
}
  802448:	90                   	nop
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	50                   	push   %eax
  80245a:	6a 23                	push   $0x23
  80245c:	e8 ef fb ff ff       	call   802050 <syscall>
  802461:	83 c4 18             	add    $0x18,%esp
}
  802464:	90                   	nop
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80246d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802470:	8d 50 04             	lea    0x4(%eax),%edx
  802473:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	52                   	push   %edx
  80247d:	50                   	push   %eax
  80247e:	6a 24                	push   $0x24
  802480:	e8 cb fb ff ff       	call   802050 <syscall>
  802485:	83 c4 18             	add    $0x18,%esp
	return result;
  802488:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80248b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80248e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802491:	89 01                	mov    %eax,(%ecx)
  802493:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802496:	8b 45 08             	mov    0x8(%ebp),%eax
  802499:	c9                   	leave  
  80249a:	c2 04 00             	ret    $0x4

0080249d <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	ff 75 10             	pushl  0x10(%ebp)
  8024a7:	ff 75 0c             	pushl  0xc(%ebp)
  8024aa:	ff 75 08             	pushl  0x8(%ebp)
  8024ad:	6a 13                	push   $0x13
  8024af:	e8 9c fb ff ff       	call   802050 <syscall>
  8024b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8024b7:	90                   	nop
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <sys_rcr2>:
uint32 sys_rcr2()
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 25                	push   $0x25
  8024c9:	e8 82 fb ff ff       	call   802050 <syscall>
  8024ce:	83 c4 18             	add    $0x18,%esp
}
  8024d1:	c9                   	leave  
  8024d2:	c3                   	ret    

008024d3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
  8024d6:	83 ec 04             	sub    $0x4,%esp
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024df:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	50                   	push   %eax
  8024ec:	6a 26                	push   $0x26
  8024ee:	e8 5d fb ff ff       	call   802050 <syscall>
  8024f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f6:	90                   	nop
}
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <rsttst>:
void rsttst()
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 28                	push   $0x28
  802508:	e8 43 fb ff ff       	call   802050 <syscall>
  80250d:	83 c4 18             	add    $0x18,%esp
	return ;
  802510:	90                   	nop
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	83 ec 04             	sub    $0x4,%esp
  802519:	8b 45 14             	mov    0x14(%ebp),%eax
  80251c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80251f:	8b 55 18             	mov    0x18(%ebp),%edx
  802522:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802526:	52                   	push   %edx
  802527:	50                   	push   %eax
  802528:	ff 75 10             	pushl  0x10(%ebp)
  80252b:	ff 75 0c             	pushl  0xc(%ebp)
  80252e:	ff 75 08             	pushl  0x8(%ebp)
  802531:	6a 27                	push   $0x27
  802533:	e8 18 fb ff ff       	call   802050 <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
	return ;
  80253b:	90                   	nop
}
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <chktst>:
void chktst(uint32 n)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	ff 75 08             	pushl  0x8(%ebp)
  80254c:	6a 29                	push   $0x29
  80254e:	e8 fd fa ff ff       	call   802050 <syscall>
  802553:	83 c4 18             	add    $0x18,%esp
	return ;
  802556:	90                   	nop
}
  802557:	c9                   	leave  
  802558:	c3                   	ret    

00802559 <inctst>:

void inctst()
{
  802559:	55                   	push   %ebp
  80255a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 2a                	push   $0x2a
  802568:	e8 e3 fa ff ff       	call   802050 <syscall>
  80256d:	83 c4 18             	add    $0x18,%esp
	return ;
  802570:	90                   	nop
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <gettst>:
uint32 gettst()
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 2b                	push   $0x2b
  802582:	e8 c9 fa ff ff       	call   802050 <syscall>
  802587:	83 c4 18             	add    $0x18,%esp
}
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    

0080258c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
  80258f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 2c                	push   $0x2c
  80259e:	e8 ad fa ff ff       	call   802050 <syscall>
  8025a3:	83 c4 18             	add    $0x18,%esp
  8025a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025a9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025ad:	75 07                	jne    8025b6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025af:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b4:	eb 05                	jmp    8025bb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025bb:	c9                   	leave  
  8025bc:	c3                   	ret    

008025bd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
  8025c0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 2c                	push   $0x2c
  8025cf:	e8 7c fa ff ff       	call   802050 <syscall>
  8025d4:	83 c4 18             	add    $0x18,%esp
  8025d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025da:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025de:	75 07                	jne    8025e7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e5:	eb 05                	jmp    8025ec <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ec:	c9                   	leave  
  8025ed:	c3                   	ret    

008025ee <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025ee:	55                   	push   %ebp
  8025ef:	89 e5                	mov    %esp,%ebp
  8025f1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 2c                	push   $0x2c
  802600:	e8 4b fa ff ff       	call   802050 <syscall>
  802605:	83 c4 18             	add    $0x18,%esp
  802608:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80260b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80260f:	75 07                	jne    802618 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802611:	b8 01 00 00 00       	mov    $0x1,%eax
  802616:	eb 05                	jmp    80261d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261d:	c9                   	leave  
  80261e:	c3                   	ret    

0080261f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80261f:	55                   	push   %ebp
  802620:	89 e5                	mov    %esp,%ebp
  802622:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 2c                	push   $0x2c
  802631:	e8 1a fa ff ff       	call   802050 <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
  802639:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80263c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802640:	75 07                	jne    802649 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802642:	b8 01 00 00 00       	mov    $0x1,%eax
  802647:	eb 05                	jmp    80264e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802649:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264e:	c9                   	leave  
  80264f:	c3                   	ret    

00802650 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	ff 75 08             	pushl  0x8(%ebp)
  80265e:	6a 2d                	push   $0x2d
  802660:	e8 eb f9 ff ff       	call   802050 <syscall>
  802665:	83 c4 18             	add    $0x18,%esp
	return ;
  802668:	90                   	nop
}
  802669:	c9                   	leave  
  80266a:	c3                   	ret    

0080266b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
  80266e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80266f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802672:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802675:	8b 55 0c             	mov    0xc(%ebp),%edx
  802678:	8b 45 08             	mov    0x8(%ebp),%eax
  80267b:	6a 00                	push   $0x0
  80267d:	53                   	push   %ebx
  80267e:	51                   	push   %ecx
  80267f:	52                   	push   %edx
  802680:	50                   	push   %eax
  802681:	6a 2e                	push   $0x2e
  802683:	e8 c8 f9 ff ff       	call   802050 <syscall>
  802688:	83 c4 18             	add    $0x18,%esp
}
  80268b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802693:	8b 55 0c             	mov    0xc(%ebp),%edx
  802696:	8b 45 08             	mov    0x8(%ebp),%eax
  802699:	6a 00                	push   $0x0
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	52                   	push   %edx
  8026a0:	50                   	push   %eax
  8026a1:	6a 2f                	push   $0x2f
  8026a3:	e8 a8 f9 ff ff       	call   802050 <syscall>
  8026a8:	83 c4 18             	add    $0x18,%esp
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    
  8026ad:	66 90                	xchg   %ax,%ax
  8026af:	90                   	nop

008026b0 <__udivdi3>:
  8026b0:	55                   	push   %ebp
  8026b1:	57                   	push   %edi
  8026b2:	56                   	push   %esi
  8026b3:	53                   	push   %ebx
  8026b4:	83 ec 1c             	sub    $0x1c,%esp
  8026b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8026bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8026bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026c7:	89 ca                	mov    %ecx,%edx
  8026c9:	89 f8                	mov    %edi,%eax
  8026cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8026cf:	85 f6                	test   %esi,%esi
  8026d1:	75 2d                	jne    802700 <__udivdi3+0x50>
  8026d3:	39 cf                	cmp    %ecx,%edi
  8026d5:	77 65                	ja     80273c <__udivdi3+0x8c>
  8026d7:	89 fd                	mov    %edi,%ebp
  8026d9:	85 ff                	test   %edi,%edi
  8026db:	75 0b                	jne    8026e8 <__udivdi3+0x38>
  8026dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8026e2:	31 d2                	xor    %edx,%edx
  8026e4:	f7 f7                	div    %edi
  8026e6:	89 c5                	mov    %eax,%ebp
  8026e8:	31 d2                	xor    %edx,%edx
  8026ea:	89 c8                	mov    %ecx,%eax
  8026ec:	f7 f5                	div    %ebp
  8026ee:	89 c1                	mov    %eax,%ecx
  8026f0:	89 d8                	mov    %ebx,%eax
  8026f2:	f7 f5                	div    %ebp
  8026f4:	89 cf                	mov    %ecx,%edi
  8026f6:	89 fa                	mov    %edi,%edx
  8026f8:	83 c4 1c             	add    $0x1c,%esp
  8026fb:	5b                   	pop    %ebx
  8026fc:	5e                   	pop    %esi
  8026fd:	5f                   	pop    %edi
  8026fe:	5d                   	pop    %ebp
  8026ff:	c3                   	ret    
  802700:	39 ce                	cmp    %ecx,%esi
  802702:	77 28                	ja     80272c <__udivdi3+0x7c>
  802704:	0f bd fe             	bsr    %esi,%edi
  802707:	83 f7 1f             	xor    $0x1f,%edi
  80270a:	75 40                	jne    80274c <__udivdi3+0x9c>
  80270c:	39 ce                	cmp    %ecx,%esi
  80270e:	72 0a                	jb     80271a <__udivdi3+0x6a>
  802710:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802714:	0f 87 9e 00 00 00    	ja     8027b8 <__udivdi3+0x108>
  80271a:	b8 01 00 00 00       	mov    $0x1,%eax
  80271f:	89 fa                	mov    %edi,%edx
  802721:	83 c4 1c             	add    $0x1c,%esp
  802724:	5b                   	pop    %ebx
  802725:	5e                   	pop    %esi
  802726:	5f                   	pop    %edi
  802727:	5d                   	pop    %ebp
  802728:	c3                   	ret    
  802729:	8d 76 00             	lea    0x0(%esi),%esi
  80272c:	31 ff                	xor    %edi,%edi
  80272e:	31 c0                	xor    %eax,%eax
  802730:	89 fa                	mov    %edi,%edx
  802732:	83 c4 1c             	add    $0x1c,%esp
  802735:	5b                   	pop    %ebx
  802736:	5e                   	pop    %esi
  802737:	5f                   	pop    %edi
  802738:	5d                   	pop    %ebp
  802739:	c3                   	ret    
  80273a:	66 90                	xchg   %ax,%ax
  80273c:	89 d8                	mov    %ebx,%eax
  80273e:	f7 f7                	div    %edi
  802740:	31 ff                	xor    %edi,%edi
  802742:	89 fa                	mov    %edi,%edx
  802744:	83 c4 1c             	add    $0x1c,%esp
  802747:	5b                   	pop    %ebx
  802748:	5e                   	pop    %esi
  802749:	5f                   	pop    %edi
  80274a:	5d                   	pop    %ebp
  80274b:	c3                   	ret    
  80274c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802751:	89 eb                	mov    %ebp,%ebx
  802753:	29 fb                	sub    %edi,%ebx
  802755:	89 f9                	mov    %edi,%ecx
  802757:	d3 e6                	shl    %cl,%esi
  802759:	89 c5                	mov    %eax,%ebp
  80275b:	88 d9                	mov    %bl,%cl
  80275d:	d3 ed                	shr    %cl,%ebp
  80275f:	89 e9                	mov    %ebp,%ecx
  802761:	09 f1                	or     %esi,%ecx
  802763:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802767:	89 f9                	mov    %edi,%ecx
  802769:	d3 e0                	shl    %cl,%eax
  80276b:	89 c5                	mov    %eax,%ebp
  80276d:	89 d6                	mov    %edx,%esi
  80276f:	88 d9                	mov    %bl,%cl
  802771:	d3 ee                	shr    %cl,%esi
  802773:	89 f9                	mov    %edi,%ecx
  802775:	d3 e2                	shl    %cl,%edx
  802777:	8b 44 24 08          	mov    0x8(%esp),%eax
  80277b:	88 d9                	mov    %bl,%cl
  80277d:	d3 e8                	shr    %cl,%eax
  80277f:	09 c2                	or     %eax,%edx
  802781:	89 d0                	mov    %edx,%eax
  802783:	89 f2                	mov    %esi,%edx
  802785:	f7 74 24 0c          	divl   0xc(%esp)
  802789:	89 d6                	mov    %edx,%esi
  80278b:	89 c3                	mov    %eax,%ebx
  80278d:	f7 e5                	mul    %ebp
  80278f:	39 d6                	cmp    %edx,%esi
  802791:	72 19                	jb     8027ac <__udivdi3+0xfc>
  802793:	74 0b                	je     8027a0 <__udivdi3+0xf0>
  802795:	89 d8                	mov    %ebx,%eax
  802797:	31 ff                	xor    %edi,%edi
  802799:	e9 58 ff ff ff       	jmp    8026f6 <__udivdi3+0x46>
  80279e:	66 90                	xchg   %ax,%ax
  8027a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8027a4:	89 f9                	mov    %edi,%ecx
  8027a6:	d3 e2                	shl    %cl,%edx
  8027a8:	39 c2                	cmp    %eax,%edx
  8027aa:	73 e9                	jae    802795 <__udivdi3+0xe5>
  8027ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8027af:	31 ff                	xor    %edi,%edi
  8027b1:	e9 40 ff ff ff       	jmp    8026f6 <__udivdi3+0x46>
  8027b6:	66 90                	xchg   %ax,%ax
  8027b8:	31 c0                	xor    %eax,%eax
  8027ba:	e9 37 ff ff ff       	jmp    8026f6 <__udivdi3+0x46>
  8027bf:	90                   	nop

008027c0 <__umoddi3>:
  8027c0:	55                   	push   %ebp
  8027c1:	57                   	push   %edi
  8027c2:	56                   	push   %esi
  8027c3:	53                   	push   %ebx
  8027c4:	83 ec 1c             	sub    $0x1c,%esp
  8027c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8027cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8027d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027df:	89 f3                	mov    %esi,%ebx
  8027e1:	89 fa                	mov    %edi,%edx
  8027e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8027e7:	89 34 24             	mov    %esi,(%esp)
  8027ea:	85 c0                	test   %eax,%eax
  8027ec:	75 1a                	jne    802808 <__umoddi3+0x48>
  8027ee:	39 f7                	cmp    %esi,%edi
  8027f0:	0f 86 a2 00 00 00    	jbe    802898 <__umoddi3+0xd8>
  8027f6:	89 c8                	mov    %ecx,%eax
  8027f8:	89 f2                	mov    %esi,%edx
  8027fa:	f7 f7                	div    %edi
  8027fc:	89 d0                	mov    %edx,%eax
  8027fe:	31 d2                	xor    %edx,%edx
  802800:	83 c4 1c             	add    $0x1c,%esp
  802803:	5b                   	pop    %ebx
  802804:	5e                   	pop    %esi
  802805:	5f                   	pop    %edi
  802806:	5d                   	pop    %ebp
  802807:	c3                   	ret    
  802808:	39 f0                	cmp    %esi,%eax
  80280a:	0f 87 ac 00 00 00    	ja     8028bc <__umoddi3+0xfc>
  802810:	0f bd e8             	bsr    %eax,%ebp
  802813:	83 f5 1f             	xor    $0x1f,%ebp
  802816:	0f 84 ac 00 00 00    	je     8028c8 <__umoddi3+0x108>
  80281c:	bf 20 00 00 00       	mov    $0x20,%edi
  802821:	29 ef                	sub    %ebp,%edi
  802823:	89 fe                	mov    %edi,%esi
  802825:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802829:	89 e9                	mov    %ebp,%ecx
  80282b:	d3 e0                	shl    %cl,%eax
  80282d:	89 d7                	mov    %edx,%edi
  80282f:	89 f1                	mov    %esi,%ecx
  802831:	d3 ef                	shr    %cl,%edi
  802833:	09 c7                	or     %eax,%edi
  802835:	89 e9                	mov    %ebp,%ecx
  802837:	d3 e2                	shl    %cl,%edx
  802839:	89 14 24             	mov    %edx,(%esp)
  80283c:	89 d8                	mov    %ebx,%eax
  80283e:	d3 e0                	shl    %cl,%eax
  802840:	89 c2                	mov    %eax,%edx
  802842:	8b 44 24 08          	mov    0x8(%esp),%eax
  802846:	d3 e0                	shl    %cl,%eax
  802848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80284c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802850:	89 f1                	mov    %esi,%ecx
  802852:	d3 e8                	shr    %cl,%eax
  802854:	09 d0                	or     %edx,%eax
  802856:	d3 eb                	shr    %cl,%ebx
  802858:	89 da                	mov    %ebx,%edx
  80285a:	f7 f7                	div    %edi
  80285c:	89 d3                	mov    %edx,%ebx
  80285e:	f7 24 24             	mull   (%esp)
  802861:	89 c6                	mov    %eax,%esi
  802863:	89 d1                	mov    %edx,%ecx
  802865:	39 d3                	cmp    %edx,%ebx
  802867:	0f 82 87 00 00 00    	jb     8028f4 <__umoddi3+0x134>
  80286d:	0f 84 91 00 00 00    	je     802904 <__umoddi3+0x144>
  802873:	8b 54 24 04          	mov    0x4(%esp),%edx
  802877:	29 f2                	sub    %esi,%edx
  802879:	19 cb                	sbb    %ecx,%ebx
  80287b:	89 d8                	mov    %ebx,%eax
  80287d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802881:	d3 e0                	shl    %cl,%eax
  802883:	89 e9                	mov    %ebp,%ecx
  802885:	d3 ea                	shr    %cl,%edx
  802887:	09 d0                	or     %edx,%eax
  802889:	89 e9                	mov    %ebp,%ecx
  80288b:	d3 eb                	shr    %cl,%ebx
  80288d:	89 da                	mov    %ebx,%edx
  80288f:	83 c4 1c             	add    $0x1c,%esp
  802892:	5b                   	pop    %ebx
  802893:	5e                   	pop    %esi
  802894:	5f                   	pop    %edi
  802895:	5d                   	pop    %ebp
  802896:	c3                   	ret    
  802897:	90                   	nop
  802898:	89 fd                	mov    %edi,%ebp
  80289a:	85 ff                	test   %edi,%edi
  80289c:	75 0b                	jne    8028a9 <__umoddi3+0xe9>
  80289e:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a3:	31 d2                	xor    %edx,%edx
  8028a5:	f7 f7                	div    %edi
  8028a7:	89 c5                	mov    %eax,%ebp
  8028a9:	89 f0                	mov    %esi,%eax
  8028ab:	31 d2                	xor    %edx,%edx
  8028ad:	f7 f5                	div    %ebp
  8028af:	89 c8                	mov    %ecx,%eax
  8028b1:	f7 f5                	div    %ebp
  8028b3:	89 d0                	mov    %edx,%eax
  8028b5:	e9 44 ff ff ff       	jmp    8027fe <__umoddi3+0x3e>
  8028ba:	66 90                	xchg   %ax,%ax
  8028bc:	89 c8                	mov    %ecx,%eax
  8028be:	89 f2                	mov    %esi,%edx
  8028c0:	83 c4 1c             	add    $0x1c,%esp
  8028c3:	5b                   	pop    %ebx
  8028c4:	5e                   	pop    %esi
  8028c5:	5f                   	pop    %edi
  8028c6:	5d                   	pop    %ebp
  8028c7:	c3                   	ret    
  8028c8:	3b 04 24             	cmp    (%esp),%eax
  8028cb:	72 06                	jb     8028d3 <__umoddi3+0x113>
  8028cd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8028d1:	77 0f                	ja     8028e2 <__umoddi3+0x122>
  8028d3:	89 f2                	mov    %esi,%edx
  8028d5:	29 f9                	sub    %edi,%ecx
  8028d7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8028db:	89 14 24             	mov    %edx,(%esp)
  8028de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028e2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8028e6:	8b 14 24             	mov    (%esp),%edx
  8028e9:	83 c4 1c             	add    $0x1c,%esp
  8028ec:	5b                   	pop    %ebx
  8028ed:	5e                   	pop    %esi
  8028ee:	5f                   	pop    %edi
  8028ef:	5d                   	pop    %ebp
  8028f0:	c3                   	ret    
  8028f1:	8d 76 00             	lea    0x0(%esi),%esi
  8028f4:	2b 04 24             	sub    (%esp),%eax
  8028f7:	19 fa                	sbb    %edi,%edx
  8028f9:	89 d1                	mov    %edx,%ecx
  8028fb:	89 c6                	mov    %eax,%esi
  8028fd:	e9 71 ff ff ff       	jmp    802873 <__umoddi3+0xb3>
  802902:	66 90                	xchg   %ax,%ax
  802904:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802908:	72 ea                	jb     8028f4 <__umoddi3+0x134>
  80290a:	89 d9                	mov    %ebx,%ecx
  80290c:	e9 62 ff ff ff       	jmp    802873 <__umoddi3+0xb3>
