
obj/user/tst_mod_r1:     file format elf32-i386


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
  800031:	e8 49 07 00 00       	call   80077f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 2000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp


	int Mega = 1024*1024;
  80003f:	c7 45 f4 00 00 10 00 	movl   $0x100000,-0xc(%ebp)
	int kilo = 1024;
  800046:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)


	int8 *x ;
	{
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80004d:	e8 f8 20 00 00       	call   80214a <sys_pf_calculate_allocated_pages>
  800052:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800055:	e8 6d 20 00 00       	call   8020c7 <sys_calculate_free_frames>
  80005a:	89 45 e8             	mov    %eax,-0x18(%ebp)

		//allocate 2 MB in the heap

		x = malloc(2*Mega) ;
  80005d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800060:	01 c0                	add    %eax,%eax
  800062:	83 ec 0c             	sub    $0xc,%esp
  800065:	50                   	push   %eax
  800066:	e8 85 18 00 00       	call   8018f0 <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		assert((uint32) x == USER_HEAP_START);
  800071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800074:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800079:	74 16                	je     800091 <_main+0x59>
  80007b:	68 20 28 80 00       	push   $0x802820
  800080:	68 3e 28 80 00       	push   $0x80283e
  800085:	6a 16                	push   $0x16
  800087:	68 53 28 80 00       	push   $0x802853
  80008c:	e8 33 08 00 00       	call   8008c4 <_panic>
		//		cprintf("Allocated frames = %d\n", (freeFrames - sys_calculate_free_frames())) ;
		assert((freeFrames - sys_calculate_free_frames()) == (1 + 1 + 2 * Mega / PAGE_SIZE));
  800091:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800094:	e8 2e 20 00 00       	call   8020c7 <sys_calculate_free_frames>
  800099:	29 c3                	sub    %eax,%ebx
  80009b:	89 da                	mov    %ebx,%edx
  80009d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a0:	01 c0                	add    %eax,%eax
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	79 05                	jns    8000ab <_main+0x73>
  8000a6:	05 ff 0f 00 00       	add    $0xfff,%eax
  8000ab:	c1 f8 0c             	sar    $0xc,%eax
  8000ae:	83 c0 02             	add    $0x2,%eax
  8000b1:	39 c2                	cmp    %eax,%edx
  8000b3:	74 16                	je     8000cb <_main+0x93>
  8000b5:	68 68 28 80 00       	push   $0x802868
  8000ba:	68 3e 28 80 00       	push   $0x80283e
  8000bf:	6a 18                	push   $0x18
  8000c1:	68 53 28 80 00       	push   $0x802853
  8000c6:	e8 f9 07 00 00       	call   8008c4 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 2 * Mega / PAGE_SIZE);
  8000cb:	e8 7a 20 00 00       	call   80214a <sys_pf_calculate_allocated_pages>
  8000d0:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d3:	89 c2                	mov    %eax,%edx
  8000d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d8:	01 c0                	add    %eax,%eax
  8000da:	85 c0                	test   %eax,%eax
  8000dc:	79 05                	jns    8000e3 <_main+0xab>
  8000de:	05 ff 0f 00 00       	add    $0xfff,%eax
  8000e3:	c1 f8 0c             	sar    $0xc,%eax
  8000e6:	39 c2                	cmp    %eax,%edx
  8000e8:	74 16                	je     800100 <_main+0xc8>
  8000ea:	68 b8 28 80 00       	push   $0x8028b8
  8000ef:	68 3e 28 80 00       	push   $0x80283e
  8000f4:	6a 19                	push   $0x19
  8000f6:	68 53 28 80 00       	push   $0x802853
  8000fb:	e8 c4 07 00 00       	call   8008c4 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800100:	e8 c2 1f 00 00       	call   8020c7 <sys_calculate_free_frames>
  800105:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800108:	e8 3d 20 00 00       	call   80214a <sys_pf_calculate_allocated_pages>
  80010d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		assert((uint32)malloc(2*Mega) == USER_HEAP_START + 2*Mega) ;
  800110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800113:	01 c0                	add    %eax,%eax
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	50                   	push   %eax
  800119:	e8 d2 17 00 00       	call   8018f0 <malloc>
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	89 c2                	mov    %eax,%edx
  800123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800126:	01 c0                	add    %eax,%eax
  800128:	05 00 00 00 80       	add    $0x80000000,%eax
  80012d:	39 c2                	cmp    %eax,%edx
  80012f:	74 16                	je     800147 <_main+0x10f>
  800131:	68 08 29 80 00       	push   $0x802908
  800136:	68 3e 28 80 00       	push   $0x80283e
  80013b:	6a 1d                	push   $0x1d
  80013d:	68 53 28 80 00       	push   $0x802853
  800142:	e8 7d 07 00 00       	call   8008c4 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (2 * Mega / PAGE_SIZE));
  800147:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80014a:	e8 78 1f 00 00       	call   8020c7 <sys_calculate_free_frames>
  80014f:	29 c3                	sub    %eax,%ebx
  800151:	89 da                	mov    %ebx,%edx
  800153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800156:	01 c0                	add    %eax,%eax
  800158:	85 c0                	test   %eax,%eax
  80015a:	79 05                	jns    800161 <_main+0x129>
  80015c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800161:	c1 f8 0c             	sar    $0xc,%eax
  800164:	39 c2                	cmp    %eax,%edx
  800166:	74 16                	je     80017e <_main+0x146>
  800168:	68 3c 29 80 00       	push   $0x80293c
  80016d:	68 3e 28 80 00       	push   $0x80283e
  800172:	6a 1e                	push   $0x1e
  800174:	68 53 28 80 00       	push   $0x802853
  800179:	e8 46 07 00 00       	call   8008c4 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 2 * Mega / PAGE_SIZE);
  80017e:	e8 c7 1f 00 00       	call   80214a <sys_pf_calculate_allocated_pages>
  800183:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800186:	89 c2                	mov    %eax,%edx
  800188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80018b:	01 c0                	add    %eax,%eax
  80018d:	85 c0                	test   %eax,%eax
  80018f:	79 05                	jns    800196 <_main+0x15e>
  800191:	05 ff 0f 00 00       	add    $0xfff,%eax
  800196:	c1 f8 0c             	sar    $0xc,%eax
  800199:	39 c2                	cmp    %eax,%edx
  80019b:	74 16                	je     8001b3 <_main+0x17b>
  80019d:	68 b8 28 80 00       	push   $0x8028b8
  8001a2:	68 3e 28 80 00       	push   $0x80283e
  8001a7:	6a 1f                	push   $0x1f
  8001a9:	68 53 28 80 00       	push   $0x802853
  8001ae:	e8 11 07 00 00       	call   8008c4 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001b3:	e8 0f 1f 00 00       	call   8020c7 <sys_calculate_free_frames>
  8001b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001bb:	e8 8a 1f 00 00       	call   80214a <sys_pf_calculate_allocated_pages>
  8001c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		assert((uint32)malloc(3*Mega) == USER_HEAP_START + 4*Mega) ;
  8001c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001c6:	89 c2                	mov    %eax,%edx
  8001c8:	01 d2                	add    %edx,%edx
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	e8 1b 17 00 00       	call   8018f0 <malloc>
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	89 c2                	mov    %eax,%edx
  8001da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001dd:	c1 e0 02             	shl    $0x2,%eax
  8001e0:	05 00 00 00 80       	add    $0x80000000,%eax
  8001e5:	39 c2                	cmp    %eax,%edx
  8001e7:	74 16                	je     8001ff <_main+0x1c7>
  8001e9:	68 84 29 80 00       	push   $0x802984
  8001ee:	68 3e 28 80 00       	push   $0x80283e
  8001f3:	6a 23                	push   $0x23
  8001f5:	68 53 28 80 00       	push   $0x802853
  8001fa:	e8 c5 06 00 00       	call   8008c4 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1 + 1 + 3 * Mega / PAGE_SIZE));
  8001ff:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800202:	e8 c0 1e 00 00       	call   8020c7 <sys_calculate_free_frames>
  800207:	29 c3                	sub    %eax,%ebx
  800209:	89 d9                	mov    %ebx,%ecx
  80020b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80020e:	89 c2                	mov    %eax,%edx
  800210:	01 d2                	add    %edx,%edx
  800212:	01 d0                	add    %edx,%eax
  800214:	85 c0                	test   %eax,%eax
  800216:	79 05                	jns    80021d <_main+0x1e5>
  800218:	05 ff 0f 00 00       	add    $0xfff,%eax
  80021d:	c1 f8 0c             	sar    $0xc,%eax
  800220:	83 c0 02             	add    $0x2,%eax
  800223:	39 c1                	cmp    %eax,%ecx
  800225:	74 16                	je     80023d <_main+0x205>
  800227:	68 b8 29 80 00       	push   $0x8029b8
  80022c:	68 3e 28 80 00       	push   $0x80283e
  800231:	6a 24                	push   $0x24
  800233:	68 53 28 80 00       	push   $0x802853
  800238:	e8 87 06 00 00       	call   8008c4 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 3 * Mega / PAGE_SIZE);
  80023d:	e8 08 1f 00 00       	call   80214a <sys_pf_calculate_allocated_pages>
  800242:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800245:	89 c2                	mov    %eax,%edx
  800247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80024a:	89 c1                	mov    %eax,%ecx
  80024c:	01 c9                	add    %ecx,%ecx
  80024e:	01 c8                	add    %ecx,%eax
  800250:	85 c0                	test   %eax,%eax
  800252:	79 05                	jns    800259 <_main+0x221>
  800254:	05 ff 0f 00 00       	add    $0xfff,%eax
  800259:	c1 f8 0c             	sar    $0xc,%eax
  80025c:	39 c2                	cmp    %eax,%edx
  80025e:	74 16                	je     800276 <_main+0x23e>
  800260:	68 08 2a 80 00       	push   $0x802a08
  800265:	68 3e 28 80 00       	push   $0x80283e
  80026a:	6a 25                	push   $0x25
  80026c:	68 53 28 80 00       	push   $0x802853
  800271:	e8 4e 06 00 00       	call   8008c4 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800276:	e8 4c 1e 00 00       	call   8020c7 <sys_calculate_free_frames>
  80027b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027e:	e8 c7 1e 00 00       	call   80214a <sys_pf_calculate_allocated_pages>
  800283:	89 45 ec             	mov    %eax,-0x14(%ebp)
		assert((uint32)malloc(2*kilo) == USER_HEAP_START + 7*Mega) ;
  800286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800289:	01 c0                	add    %eax,%eax
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	50                   	push   %eax
  80028f:	e8 5c 16 00 00       	call   8018f0 <malloc>
  800294:	83 c4 10             	add    $0x10,%esp
  800297:	89 c1                	mov    %eax,%ecx
  800299:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80029c:	89 d0                	mov    %edx,%eax
  80029e:	01 c0                	add    %eax,%eax
  8002a0:	01 d0                	add    %edx,%eax
  8002a2:	01 c0                	add    %eax,%eax
  8002a4:	01 d0                	add    %edx,%eax
  8002a6:	05 00 00 00 80       	add    $0x80000000,%eax
  8002ab:	39 c1                	cmp    %eax,%ecx
  8002ad:	74 16                	je     8002c5 <_main+0x28d>
  8002af:	68 58 2a 80 00       	push   $0x802a58
  8002b4:	68 3e 28 80 00       	push   $0x80283e
  8002b9:	6a 29                	push   $0x29
  8002bb:	68 53 28 80 00       	push   $0x802853
  8002c0:	e8 ff 05 00 00       	call   8008c4 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1));
  8002c5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8002c8:	e8 fa 1d 00 00       	call   8020c7 <sys_calculate_free_frames>
  8002cd:	29 c3                	sub    %eax,%ebx
  8002cf:	89 d8                	mov    %ebx,%eax
  8002d1:	83 f8 01             	cmp    $0x1,%eax
  8002d4:	74 16                	je     8002ec <_main+0x2b4>
  8002d6:	68 8c 2a 80 00       	push   $0x802a8c
  8002db:	68 3e 28 80 00       	push   $0x80283e
  8002e0:	6a 2a                	push   $0x2a
  8002e2:	68 53 28 80 00       	push   $0x802853
  8002e7:	e8 d8 05 00 00       	call   8008c4 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1);
  8002ec:	e8 59 1e 00 00       	call   80214a <sys_pf_calculate_allocated_pages>
  8002f1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002f4:	83 f8 01             	cmp    $0x1,%eax
  8002f7:	74 16                	je     80030f <_main+0x2d7>
  8002f9:	68 c0 2a 80 00       	push   $0x802ac0
  8002fe:	68 3e 28 80 00       	push   $0x80283e
  800303:	6a 2b                	push   $0x2b
  800305:	68 53 28 80 00       	push   $0x802853
  80030a:	e8 b5 05 00 00       	call   8008c4 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80030f:	e8 b3 1d 00 00       	call   8020c7 <sys_calculate_free_frames>
  800314:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800317:	e8 2e 1e 00 00       	call   80214a <sys_pf_calculate_allocated_pages>
  80031c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		assert((uint32)malloc(2*kilo) == USER_HEAP_START + 7*Mega + 4*kilo) ;
  80031f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800322:	01 c0                	add    %eax,%eax
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	50                   	push   %eax
  800328:	e8 c3 15 00 00       	call   8018f0 <malloc>
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	89 c1                	mov    %eax,%ecx
  800332:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800335:	89 d0                	mov    %edx,%eax
  800337:	01 c0                	add    %eax,%eax
  800339:	01 d0                	add    %edx,%eax
  80033b:	01 c0                	add    %eax,%eax
  80033d:	01 d0                	add    %edx,%eax
  80033f:	89 c2                	mov    %eax,%edx
  800341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800344:	c1 e0 02             	shl    $0x2,%eax
  800347:	01 d0                	add    %edx,%eax
  800349:	05 00 00 00 80       	add    $0x80000000,%eax
  80034e:	39 c1                	cmp    %eax,%ecx
  800350:	74 16                	je     800368 <_main+0x330>
  800352:	68 fc 2a 80 00       	push   $0x802afc
  800357:	68 3e 28 80 00       	push   $0x80283e
  80035c:	6a 2f                	push   $0x2f
  80035e:	68 53 28 80 00       	push   $0x802853
  800363:	e8 5c 05 00 00       	call   8008c4 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1));
  800368:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80036b:	e8 57 1d 00 00       	call   8020c7 <sys_calculate_free_frames>
  800370:	29 c3                	sub    %eax,%ebx
  800372:	89 d8                	mov    %ebx,%eax
  800374:	83 f8 01             	cmp    $0x1,%eax
  800377:	74 16                	je     80038f <_main+0x357>
  800379:	68 8c 2a 80 00       	push   $0x802a8c
  80037e:	68 3e 28 80 00       	push   $0x80283e
  800383:	6a 30                	push   $0x30
  800385:	68 53 28 80 00       	push   $0x802853
  80038a:	e8 35 05 00 00       	call   8008c4 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1);
  80038f:	e8 b6 1d 00 00       	call   80214a <sys_pf_calculate_allocated_pages>
  800394:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800397:	83 f8 01             	cmp    $0x1,%eax
  80039a:	74 16                	je     8003b2 <_main+0x37a>
  80039c:	68 c0 2a 80 00       	push   $0x802ac0
  8003a1:	68 3e 28 80 00       	push   $0x80283e
  8003a6:	6a 31                	push   $0x31
  8003a8:	68 53 28 80 00       	push   $0x802853
  8003ad:	e8 12 05 00 00       	call   8008c4 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8003b2:	e8 10 1d 00 00       	call   8020c7 <sys_calculate_free_frames>
  8003b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ba:	e8 8b 1d 00 00       	call   80214a <sys_pf_calculate_allocated_pages>
  8003bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		assert((uint32)malloc(7*kilo) == USER_HEAP_START + 7*Mega + 8*kilo) ;
  8003c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8003c5:	89 d0                	mov    %edx,%eax
  8003c7:	01 c0                	add    %eax,%eax
  8003c9:	01 d0                	add    %edx,%eax
  8003cb:	01 c0                	add    %eax,%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	50                   	push   %eax
  8003d3:	e8 18 15 00 00       	call   8018f0 <malloc>
  8003d8:	83 c4 10             	add    $0x10,%esp
  8003db:	89 c1                	mov    %eax,%ecx
  8003dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003e0:	89 d0                	mov    %edx,%eax
  8003e2:	01 c0                	add    %eax,%eax
  8003e4:	01 d0                	add    %edx,%eax
  8003e6:	01 c0                	add    %eax,%eax
  8003e8:	01 d0                	add    %edx,%eax
  8003ea:	89 c2                	mov    %eax,%edx
  8003ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ef:	c1 e0 03             	shl    $0x3,%eax
  8003f2:	01 d0                	add    %edx,%eax
  8003f4:	05 00 00 00 80       	add    $0x80000000,%eax
  8003f9:	39 c1                	cmp    %eax,%ecx
  8003fb:	74 16                	je     800413 <_main+0x3db>
  8003fd:	68 38 2b 80 00       	push   $0x802b38
  800402:	68 3e 28 80 00       	push   $0x80283e
  800407:	6a 35                	push   $0x35
  800409:	68 53 28 80 00       	push   $0x802853
  80040e:	e8 b1 04 00 00       	call   8008c4 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (2));
  800413:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800416:	e8 ac 1c 00 00       	call   8020c7 <sys_calculate_free_frames>
  80041b:	29 c3                	sub    %eax,%ebx
  80041d:	89 d8                	mov    %ebx,%eax
  80041f:	83 f8 02             	cmp    $0x2,%eax
  800422:	74 16                	je     80043a <_main+0x402>
  800424:	68 74 2b 80 00       	push   $0x802b74
  800429:	68 3e 28 80 00       	push   $0x80283e
  80042e:	6a 36                	push   $0x36
  800430:	68 53 28 80 00       	push   $0x802853
  800435:	e8 8a 04 00 00       	call   8008c4 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 2);
  80043a:	e8 0b 1d 00 00       	call   80214a <sys_pf_calculate_allocated_pages>
  80043f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800442:	83 f8 02             	cmp    $0x2,%eax
  800445:	74 16                	je     80045d <_main+0x425>
  800447:	68 a8 2b 80 00       	push   $0x802ba8
  80044c:	68 3e 28 80 00       	push   $0x80283e
  800451:	6a 37                	push   $0x37
  800453:	68 53 28 80 00       	push   $0x802853
  800458:	e8 67 04 00 00       	call   8008c4 <_panic>
	}

	///====================


	int freeFrames = sys_calculate_free_frames() ;
  80045d:	e8 65 1c 00 00       	call   8020c7 <sys_calculate_free_frames>
  800462:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800465:	e8 e0 1c 00 00       	call   80214a <sys_pf_calculate_allocated_pages>
  80046a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	{
		x[0] = -1 ;
  80046d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800470:	c6 00 ff             	movb   $0xff,(%eax)
		x[2*Mega] = -1 ;
  800473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800476:	01 c0                	add    %eax,%eax
  800478:	89 c2                	mov    %eax,%edx
  80047a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80047d:	01 d0                	add    %edx,%eax
  80047f:	c6 00 ff             	movb   $0xff,(%eax)
		x[3*Mega] = -1 ;
  800482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800485:	89 c2                	mov    %eax,%edx
  800487:	01 d2                	add    %edx,%edx
  800489:	01 d0                	add    %edx,%eax
  80048b:	89 c2                	mov    %eax,%edx
  80048d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800490:	01 d0                	add    %edx,%eax
  800492:	c6 00 ff             	movb   $0xff,(%eax)
		x[4*Mega] = -1 ;
  800495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800498:	c1 e0 02             	shl    $0x2,%eax
  80049b:	89 c2                	mov    %eax,%edx
  80049d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	c6 00 ff             	movb   $0xff,(%eax)
		x[5*Mega] = -1 ;
  8004a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004a8:	89 d0                	mov    %edx,%eax
  8004aa:	c1 e0 02             	shl    $0x2,%eax
  8004ad:	01 d0                	add    %edx,%eax
  8004af:	89 c2                	mov    %eax,%edx
  8004b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004b4:	01 d0                	add    %edx,%eax
  8004b6:	c6 00 ff             	movb   $0xff,(%eax)
		x[6*Mega] = -1 ;
  8004b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004bc:	89 d0                	mov    %edx,%eax
  8004be:	01 c0                	add    %eax,%eax
  8004c0:	01 d0                	add    %edx,%eax
  8004c2:	01 c0                	add    %eax,%eax
  8004c4:	89 c2                	mov    %eax,%edx
  8004c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004c9:	01 d0                	add    %edx,%eax
  8004cb:	c6 00 ff             	movb   $0xff,(%eax)
		x[7*Mega-1] = -1 ;
  8004ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004d1:	89 d0                	mov    %edx,%eax
  8004d3:	01 c0                	add    %eax,%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	01 c0                	add    %eax,%eax
  8004d9:	01 d0                	add    %edx,%eax
  8004db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	c6 00 ff             	movb   $0xff,(%eax)
		x[7*Mega+1*kilo] = -1 ;
  8004e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004e9:	89 d0                	mov    %edx,%eax
  8004eb:	01 c0                	add    %eax,%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	01 c0                	add    %eax,%eax
  8004f1:	01 c2                	add    %eax,%edx
  8004f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	89 c2                	mov    %eax,%edx
  8004fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004fd:	01 d0                	add    %edx,%eax
  8004ff:	c6 00 ff             	movb   $0xff,(%eax)
		x[7*Mega+5*kilo] = -1 ;
  800502:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800505:	89 d0                	mov    %edx,%eax
  800507:	01 c0                	add    %eax,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	01 c0                	add    %eax,%eax
  80050d:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800510:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800513:	89 d0                	mov    %edx,%eax
  800515:	c1 e0 02             	shl    $0x2,%eax
  800518:	01 d0                	add    %edx,%eax
  80051a:	01 c8                	add    %ecx,%eax
  80051c:	89 c2                	mov    %eax,%edx
  80051e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800521:	01 d0                	add    %edx,%eax
  800523:	c6 00 ff             	movb   $0xff,(%eax)
		x[7*Mega+10*kilo] = -1 ;
  800526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800529:	89 d0                	mov    %edx,%eax
  80052b:	01 c0                	add    %eax,%eax
  80052d:	01 d0                	add    %edx,%eax
  80052f:	01 c0                	add    %eax,%eax
  800531:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800534:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800537:	89 d0                	mov    %edx,%eax
  800539:	c1 e0 02             	shl    $0x2,%eax
  80053c:	01 d0                	add    %edx,%eax
  80053e:	01 c0                	add    %eax,%eax
  800540:	01 c8                	add    %ecx,%eax
  800542:	89 c2                	mov    %eax,%edx
  800544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	c6 00 ff             	movb   $0xff,(%eax)
	}

	assert(x[0] == -1);
  80054c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80054f:	8a 00                	mov    (%eax),%al
  800551:	3c ff                	cmp    $0xff,%al
  800553:	74 16                	je     80056b <_main+0x533>
  800555:	68 e2 2b 80 00       	push   $0x802be2
  80055a:	68 3e 28 80 00       	push   $0x80283e
  80055f:	6a 4c                	push   $0x4c
  800561:	68 53 28 80 00       	push   $0x802853
  800566:	e8 59 03 00 00       	call   8008c4 <_panic>
	assert(x[2*Mega] == -1 );
  80056b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80056e:	01 c0                	add    %eax,%eax
  800570:	89 c2                	mov    %eax,%edx
  800572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800575:	01 d0                	add    %edx,%eax
  800577:	8a 00                	mov    (%eax),%al
  800579:	3c ff                	cmp    $0xff,%al
  80057b:	74 16                	je     800593 <_main+0x55b>
  80057d:	68 ed 2b 80 00       	push   $0x802bed
  800582:	68 3e 28 80 00       	push   $0x80283e
  800587:	6a 4d                	push   $0x4d
  800589:	68 53 28 80 00       	push   $0x802853
  80058e:	e8 31 03 00 00       	call   8008c4 <_panic>
	assert(x[3*Mega] == -1 );
  800593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800596:	89 c2                	mov    %eax,%edx
  800598:	01 d2                	add    %edx,%edx
  80059a:	01 d0                	add    %edx,%eax
  80059c:	89 c2                	mov    %eax,%edx
  80059e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005a1:	01 d0                	add    %edx,%eax
  8005a3:	8a 00                	mov    (%eax),%al
  8005a5:	3c ff                	cmp    $0xff,%al
  8005a7:	74 16                	je     8005bf <_main+0x587>
  8005a9:	68 fd 2b 80 00       	push   $0x802bfd
  8005ae:	68 3e 28 80 00       	push   $0x80283e
  8005b3:	6a 4e                	push   $0x4e
  8005b5:	68 53 28 80 00       	push   $0x802853
  8005ba:	e8 05 03 00 00       	call   8008c4 <_panic>
	assert(x[4*Mega] == -1 );
  8005bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c2:	c1 e0 02             	shl    $0x2,%eax
  8005c5:	89 c2                	mov    %eax,%edx
  8005c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ca:	01 d0                	add    %edx,%eax
  8005cc:	8a 00                	mov    (%eax),%al
  8005ce:	3c ff                	cmp    $0xff,%al
  8005d0:	74 16                	je     8005e8 <_main+0x5b0>
  8005d2:	68 0d 2c 80 00       	push   $0x802c0d
  8005d7:	68 3e 28 80 00       	push   $0x80283e
  8005dc:	6a 4f                	push   $0x4f
  8005de:	68 53 28 80 00       	push   $0x802853
  8005e3:	e8 dc 02 00 00       	call   8008c4 <_panic>
	assert(x[5*Mega] == -1 );
  8005e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005eb:	89 d0                	mov    %edx,%eax
  8005ed:	c1 e0 02             	shl    $0x2,%eax
  8005f0:	01 d0                	add    %edx,%eax
  8005f2:	89 c2                	mov    %eax,%edx
  8005f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f7:	01 d0                	add    %edx,%eax
  8005f9:	8a 00                	mov    (%eax),%al
  8005fb:	3c ff                	cmp    $0xff,%al
  8005fd:	74 16                	je     800615 <_main+0x5dd>
  8005ff:	68 1d 2c 80 00       	push   $0x802c1d
  800604:	68 3e 28 80 00       	push   $0x80283e
  800609:	6a 50                	push   $0x50
  80060b:	68 53 28 80 00       	push   $0x802853
  800610:	e8 af 02 00 00       	call   8008c4 <_panic>
	assert(x[6*Mega] == -1 );
  800615:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800618:	89 d0                	mov    %edx,%eax
  80061a:	01 c0                	add    %eax,%eax
  80061c:	01 d0                	add    %edx,%eax
  80061e:	01 c0                	add    %eax,%eax
  800620:	89 c2                	mov    %eax,%edx
  800622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800625:	01 d0                	add    %edx,%eax
  800627:	8a 00                	mov    (%eax),%al
  800629:	3c ff                	cmp    $0xff,%al
  80062b:	74 16                	je     800643 <_main+0x60b>
  80062d:	68 2d 2c 80 00       	push   $0x802c2d
  800632:	68 3e 28 80 00       	push   $0x80283e
  800637:	6a 51                	push   $0x51
  800639:	68 53 28 80 00       	push   $0x802853
  80063e:	e8 81 02 00 00       	call   8008c4 <_panic>
	assert(x[7*Mega-1] == -1 );
  800643:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800646:	89 d0                	mov    %edx,%eax
  800648:	01 c0                	add    %eax,%eax
  80064a:	01 d0                	add    %edx,%eax
  80064c:	01 c0                	add    %eax,%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	8d 50 ff             	lea    -0x1(%eax),%edx
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	01 d0                	add    %edx,%eax
  800658:	8a 00                	mov    (%eax),%al
  80065a:	3c ff                	cmp    $0xff,%al
  80065c:	74 16                	je     800674 <_main+0x63c>
  80065e:	68 3d 2c 80 00       	push   $0x802c3d
  800663:	68 3e 28 80 00       	push   $0x80283e
  800668:	6a 52                	push   $0x52
  80066a:	68 53 28 80 00       	push   $0x802853
  80066f:	e8 50 02 00 00       	call   8008c4 <_panic>
	assert(x[7*Mega+1*kilo] == -1 );
  800674:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800677:	89 d0                	mov    %edx,%eax
  800679:	01 c0                	add    %eax,%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	01 c0                	add    %eax,%eax
  80067f:	01 c2                	add    %eax,%edx
  800681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800684:	01 d0                	add    %edx,%eax
  800686:	89 c2                	mov    %eax,%edx
  800688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068b:	01 d0                	add    %edx,%eax
  80068d:	8a 00                	mov    (%eax),%al
  80068f:	3c ff                	cmp    $0xff,%al
  800691:	74 16                	je     8006a9 <_main+0x671>
  800693:	68 4f 2c 80 00       	push   $0x802c4f
  800698:	68 3e 28 80 00       	push   $0x80283e
  80069d:	6a 53                	push   $0x53
  80069f:	68 53 28 80 00       	push   $0x802853
  8006a4:	e8 1b 02 00 00       	call   8008c4 <_panic>
	assert(x[7*Mega+5*kilo] == -1 );
  8006a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ac:	89 d0                	mov    %edx,%eax
  8006ae:	01 c0                	add    %eax,%eax
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	01 c0                	add    %eax,%eax
  8006b4:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8006b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006ba:	89 d0                	mov    %edx,%eax
  8006bc:	c1 e0 02             	shl    $0x2,%eax
  8006bf:	01 d0                	add    %edx,%eax
  8006c1:	01 c8                	add    %ecx,%eax
  8006c3:	89 c2                	mov    %eax,%edx
  8006c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c8:	01 d0                	add    %edx,%eax
  8006ca:	8a 00                	mov    (%eax),%al
  8006cc:	3c ff                	cmp    $0xff,%al
  8006ce:	74 16                	je     8006e6 <_main+0x6ae>
  8006d0:	68 66 2c 80 00       	push   $0x802c66
  8006d5:	68 3e 28 80 00       	push   $0x80283e
  8006da:	6a 54                	push   $0x54
  8006dc:	68 53 28 80 00       	push   $0x802853
  8006e1:	e8 de 01 00 00       	call   8008c4 <_panic>
	assert(x[7*Mega+10*kilo] == -1 );
  8006e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e9:	89 d0                	mov    %edx,%eax
  8006eb:	01 c0                	add    %eax,%eax
  8006ed:	01 d0                	add    %edx,%eax
  8006ef:	01 c0                	add    %eax,%eax
  8006f1:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8006f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006f7:	89 d0                	mov    %edx,%eax
  8006f9:	c1 e0 02             	shl    $0x2,%eax
  8006fc:	01 d0                	add    %edx,%eax
  8006fe:	01 c0                	add    %eax,%eax
  800700:	01 c8                	add    %ecx,%eax
  800702:	89 c2                	mov    %eax,%edx
  800704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800707:	01 d0                	add    %edx,%eax
  800709:	8a 00                	mov    (%eax),%al
  80070b:	3c ff                	cmp    $0xff,%al
  80070d:	74 16                	je     800725 <_main+0x6ed>
  80070f:	68 7d 2c 80 00       	push   $0x802c7d
  800714:	68 3e 28 80 00       	push   $0x80283e
  800719:	6a 55                	push   $0x55
  80071b:	68 53 28 80 00       	push   $0x802853
  800720:	e8 9f 01 00 00       	call   8008c4 <_panic>
	assert((freeFrames - sys_calculate_free_frames()) == 0 );
  800725:	e8 9d 19 00 00       	call   8020c7 <sys_calculate_free_frames>
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072f:	39 c2                	cmp    %eax,%edx
  800731:	74 16                	je     800749 <_main+0x711>
  800733:	68 98 2c 80 00       	push   $0x802c98
  800738:	68 3e 28 80 00       	push   $0x80283e
  80073d:	6a 56                	push   $0x56
  80073f:	68 53 28 80 00       	push   $0x802853
  800744:	e8 7b 01 00 00       	call   8008c4 <_panic>
	assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  800749:	e8 fc 19 00 00       	call   80214a <sys_pf_calculate_allocated_pages>
  80074e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800751:	74 16                	je     800769 <_main+0x731>
  800753:	68 c8 2c 80 00       	push   $0x802cc8
  800758:	68 3e 28 80 00       	push   $0x80283e
  80075d:	6a 57                	push   $0x57
  80075f:	68 53 28 80 00       	push   $0x802853
  800764:	e8 5b 01 00 00       	call   8008c4 <_panic>

	cprintf("Congratulations!! your modification is completed successfully.\n");
  800769:	83 ec 0c             	sub    $0xc,%esp
  80076c:	68 04 2d 80 00       	push   $0x802d04
  800771:	e8 f0 03 00 00       	call   800b66 <cprintf>
  800776:	83 c4 10             	add    $0x10,%esp

	return;
  800779:	90                   	nop
}
  80077a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80077d:	c9                   	leave  
  80077e:	c3                   	ret    

0080077f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80077f:	55                   	push   %ebp
  800780:	89 e5                	mov    %esp,%ebp
  800782:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800785:	e8 72 18 00 00       	call   801ffc <sys_getenvindex>
  80078a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80078d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800790:	89 d0                	mov    %edx,%eax
  800792:	c1 e0 03             	shl    $0x3,%eax
  800795:	01 d0                	add    %edx,%eax
  800797:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80079e:	01 c8                	add    %ecx,%eax
  8007a0:	01 c0                	add    %eax,%eax
  8007a2:	01 d0                	add    %edx,%eax
  8007a4:	01 c0                	add    %eax,%eax
  8007a6:	01 d0                	add    %edx,%eax
  8007a8:	89 c2                	mov    %eax,%edx
  8007aa:	c1 e2 05             	shl    $0x5,%edx
  8007ad:	29 c2                	sub    %eax,%edx
  8007af:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8007b6:	89 c2                	mov    %eax,%edx
  8007b8:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8007be:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007c3:	a1 20 40 80 00       	mov    0x804020,%eax
  8007c8:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8007ce:	84 c0                	test   %al,%al
  8007d0:	74 0f                	je     8007e1 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8007d2:	a1 20 40 80 00       	mov    0x804020,%eax
  8007d7:	05 40 3c 01 00       	add    $0x13c40,%eax
  8007dc:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007e5:	7e 0a                	jle    8007f1 <libmain+0x72>
		binaryname = argv[0];
  8007e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	ff 75 08             	pushl  0x8(%ebp)
  8007fa:	e8 39 f8 ff ff       	call   800038 <_main>
  8007ff:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800802:	e8 90 19 00 00       	call   802197 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800807:	83 ec 0c             	sub    $0xc,%esp
  80080a:	68 5c 2d 80 00       	push   $0x802d5c
  80080f:	e8 52 03 00 00       	call   800b66 <cprintf>
  800814:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800817:	a1 20 40 80 00       	mov    0x804020,%eax
  80081c:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800822:	a1 20 40 80 00       	mov    0x804020,%eax
  800827:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	52                   	push   %edx
  800831:	50                   	push   %eax
  800832:	68 84 2d 80 00       	push   $0x802d84
  800837:	e8 2a 03 00 00       	call   800b66 <cprintf>
  80083c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80083f:	a1 20 40 80 00       	mov    0x804020,%eax
  800844:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80084a:	a1 20 40 80 00       	mov    0x804020,%eax
  80084f:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800855:	83 ec 04             	sub    $0x4,%esp
  800858:	52                   	push   %edx
  800859:	50                   	push   %eax
  80085a:	68 ac 2d 80 00       	push   $0x802dac
  80085f:	e8 02 03 00 00       	call   800b66 <cprintf>
  800864:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800867:	a1 20 40 80 00       	mov    0x804020,%eax
  80086c:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	50                   	push   %eax
  800876:	68 ed 2d 80 00       	push   $0x802ded
  80087b:	e8 e6 02 00 00       	call   800b66 <cprintf>
  800880:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800883:	83 ec 0c             	sub    $0xc,%esp
  800886:	68 5c 2d 80 00       	push   $0x802d5c
  80088b:	e8 d6 02 00 00       	call   800b66 <cprintf>
  800890:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800893:	e8 19 19 00 00       	call   8021b1 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800898:	e8 19 00 00 00       	call   8008b6 <exit>
}
  80089d:	90                   	nop
  80089e:	c9                   	leave  
  80089f:	c3                   	ret    

008008a0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8008a6:	83 ec 0c             	sub    $0xc,%esp
  8008a9:	6a 00                	push   $0x0
  8008ab:	e8 18 17 00 00       	call   801fc8 <sys_env_destroy>
  8008b0:	83 c4 10             	add    $0x10,%esp
}
  8008b3:	90                   	nop
  8008b4:	c9                   	leave  
  8008b5:	c3                   	ret    

008008b6 <exit>:

void
exit(void)
{
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8008bc:	e8 6d 17 00 00       	call   80202e <sys_env_exit>
}
  8008c1:	90                   	nop
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

008008c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008ca:	8d 45 10             	lea    0x10(%ebp),%eax
  8008cd:	83 c0 04             	add    $0x4,%eax
  8008d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008d3:	a1 18 41 80 00       	mov    0x804118,%eax
  8008d8:	85 c0                	test   %eax,%eax
  8008da:	74 16                	je     8008f2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008dc:	a1 18 41 80 00       	mov    0x804118,%eax
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	50                   	push   %eax
  8008e5:	68 04 2e 80 00       	push   $0x802e04
  8008ea:	e8 77 02 00 00       	call   800b66 <cprintf>
  8008ef:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008f2:	a1 00 40 80 00       	mov    0x804000,%eax
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	ff 75 08             	pushl  0x8(%ebp)
  8008fd:	50                   	push   %eax
  8008fe:	68 09 2e 80 00       	push   $0x802e09
  800903:	e8 5e 02 00 00       	call   800b66 <cprintf>
  800908:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80090b:	8b 45 10             	mov    0x10(%ebp),%eax
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 f4             	pushl  -0xc(%ebp)
  800914:	50                   	push   %eax
  800915:	e8 e1 01 00 00       	call   800afb <vcprintf>
  80091a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80091d:	83 ec 08             	sub    $0x8,%esp
  800920:	6a 00                	push   $0x0
  800922:	68 25 2e 80 00       	push   $0x802e25
  800927:	e8 cf 01 00 00       	call   800afb <vcprintf>
  80092c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80092f:	e8 82 ff ff ff       	call   8008b6 <exit>

	// should not return here
	while (1) ;
  800934:	eb fe                	jmp    800934 <_panic+0x70>

00800936 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80093c:	a1 20 40 80 00       	mov    0x804020,%eax
  800941:	8b 50 74             	mov    0x74(%eax),%edx
  800944:	8b 45 0c             	mov    0xc(%ebp),%eax
  800947:	39 c2                	cmp    %eax,%edx
  800949:	74 14                	je     80095f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80094b:	83 ec 04             	sub    $0x4,%esp
  80094e:	68 28 2e 80 00       	push   $0x802e28
  800953:	6a 26                	push   $0x26
  800955:	68 74 2e 80 00       	push   $0x802e74
  80095a:	e8 65 ff ff ff       	call   8008c4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80095f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800966:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80096d:	e9 b6 00 00 00       	jmp    800a28 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800975:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	01 d0                	add    %edx,%eax
  800981:	8b 00                	mov    (%eax),%eax
  800983:	85 c0                	test   %eax,%eax
  800985:	75 08                	jne    80098f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800987:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80098a:	e9 96 00 00 00       	jmp    800a25 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80098f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800996:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80099d:	eb 5d                	jmp    8009fc <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80099f:	a1 20 40 80 00       	mov    0x804020,%eax
  8009a4:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8009aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ad:	c1 e2 04             	shl    $0x4,%edx
  8009b0:	01 d0                	add    %edx,%eax
  8009b2:	8a 40 04             	mov    0x4(%eax),%al
  8009b5:	84 c0                	test   %al,%al
  8009b7:	75 40                	jne    8009f9 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009b9:	a1 20 40 80 00       	mov    0x804020,%eax
  8009be:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8009c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009c7:	c1 e2 04             	shl    $0x4,%edx
  8009ca:	01 d0                	add    %edx,%eax
  8009cc:	8b 00                	mov    (%eax),%eax
  8009ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009d9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	01 c8                	add    %ecx,%eax
  8009ea:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ec:	39 c2                	cmp    %eax,%edx
  8009ee:	75 09                	jne    8009f9 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8009f0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009f7:	eb 12                	jmp    800a0b <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009f9:	ff 45 e8             	incl   -0x18(%ebp)
  8009fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800a01:	8b 50 74             	mov    0x74(%eax),%edx
  800a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a07:	39 c2                	cmp    %eax,%edx
  800a09:	77 94                	ja     80099f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a0f:	75 14                	jne    800a25 <CheckWSWithoutLastIndex+0xef>
			panic(
  800a11:	83 ec 04             	sub    $0x4,%esp
  800a14:	68 80 2e 80 00       	push   $0x802e80
  800a19:	6a 3a                	push   $0x3a
  800a1b:	68 74 2e 80 00       	push   $0x802e74
  800a20:	e8 9f fe ff ff       	call   8008c4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a25:	ff 45 f0             	incl   -0x10(%ebp)
  800a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a2e:	0f 8c 3e ff ff ff    	jl     800972 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a34:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a3b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a42:	eb 20                	jmp    800a64 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a44:	a1 20 40 80 00       	mov    0x804020,%eax
  800a49:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800a4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a52:	c1 e2 04             	shl    $0x4,%edx
  800a55:	01 d0                	add    %edx,%eax
  800a57:	8a 40 04             	mov    0x4(%eax),%al
  800a5a:	3c 01                	cmp    $0x1,%al
  800a5c:	75 03                	jne    800a61 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800a5e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a61:	ff 45 e0             	incl   -0x20(%ebp)
  800a64:	a1 20 40 80 00       	mov    0x804020,%eax
  800a69:	8b 50 74             	mov    0x74(%eax),%edx
  800a6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6f:	39 c2                	cmp    %eax,%edx
  800a71:	77 d1                	ja     800a44 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a76:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a79:	74 14                	je     800a8f <CheckWSWithoutLastIndex+0x159>
		panic(
  800a7b:	83 ec 04             	sub    $0x4,%esp
  800a7e:	68 d4 2e 80 00       	push   $0x802ed4
  800a83:	6a 44                	push   $0x44
  800a85:	68 74 2e 80 00       	push   $0x802e74
  800a8a:	e8 35 fe ff ff       	call   8008c4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a8f:	90                   	nop
  800a90:	c9                   	leave  
  800a91:	c3                   	ret    

00800a92 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9b:	8b 00                	mov    (%eax),%eax
  800a9d:	8d 48 01             	lea    0x1(%eax),%ecx
  800aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa3:	89 0a                	mov    %ecx,(%edx)
  800aa5:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa8:	88 d1                	mov    %dl,%cl
  800aaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aad:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab4:	8b 00                	mov    (%eax),%eax
  800ab6:	3d ff 00 00 00       	cmp    $0xff,%eax
  800abb:	75 2c                	jne    800ae9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800abd:	a0 24 40 80 00       	mov    0x804024,%al
  800ac2:	0f b6 c0             	movzbl %al,%eax
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac8:	8b 12                	mov    (%edx),%edx
  800aca:	89 d1                	mov    %edx,%ecx
  800acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acf:	83 c2 08             	add    $0x8,%edx
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	50                   	push   %eax
  800ad6:	51                   	push   %ecx
  800ad7:	52                   	push   %edx
  800ad8:	e8 a9 14 00 00       	call   801f86 <sys_cputs>
  800add:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aec:	8b 40 04             	mov    0x4(%eax),%eax
  800aef:	8d 50 01             	lea    0x1(%eax),%edx
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	89 50 04             	mov    %edx,0x4(%eax)
}
  800af8:	90                   	nop
  800af9:	c9                   	leave  
  800afa:	c3                   	ret    

00800afb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b04:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b0b:	00 00 00 
	b.cnt = 0;
  800b0e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b15:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b18:	ff 75 0c             	pushl  0xc(%ebp)
  800b1b:	ff 75 08             	pushl  0x8(%ebp)
  800b1e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b24:	50                   	push   %eax
  800b25:	68 92 0a 80 00       	push   $0x800a92
  800b2a:	e8 11 02 00 00       	call   800d40 <vprintfmt>
  800b2f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b32:	a0 24 40 80 00       	mov    0x804024,%al
  800b37:	0f b6 c0             	movzbl %al,%eax
  800b3a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b40:	83 ec 04             	sub    $0x4,%esp
  800b43:	50                   	push   %eax
  800b44:	52                   	push   %edx
  800b45:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b4b:	83 c0 08             	add    $0x8,%eax
  800b4e:	50                   	push   %eax
  800b4f:	e8 32 14 00 00       	call   801f86 <sys_cputs>
  800b54:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b57:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800b5e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b64:	c9                   	leave  
  800b65:	c3                   	ret    

00800b66 <cprintf>:

int cprintf(const char *fmt, ...) {
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b6c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800b73:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	83 ec 08             	sub    $0x8,%esp
  800b7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b82:	50                   	push   %eax
  800b83:	e8 73 ff ff ff       	call   800afb <vcprintf>
  800b88:	83 c4 10             	add    $0x10,%esp
  800b8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    

00800b93 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b99:	e8 f9 15 00 00       	call   802197 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b9e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	83 ec 08             	sub    $0x8,%esp
  800baa:	ff 75 f4             	pushl  -0xc(%ebp)
  800bad:	50                   	push   %eax
  800bae:	e8 48 ff ff ff       	call   800afb <vcprintf>
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bb9:	e8 f3 15 00 00       	call   8021b1 <sys_enable_interrupt>
	return cnt;
  800bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc1:	c9                   	leave  
  800bc2:	c3                   	ret    

00800bc3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	53                   	push   %ebx
  800bc7:	83 ec 14             	sub    $0x14,%esp
  800bca:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bd6:	8b 45 18             	mov    0x18(%ebp),%eax
  800bd9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bde:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800be1:	77 55                	ja     800c38 <printnum+0x75>
  800be3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800be6:	72 05                	jb     800bed <printnum+0x2a>
  800be8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800beb:	77 4b                	ja     800c38 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bed:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bf0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bf3:	8b 45 18             	mov    0x18(%ebp),%eax
  800bf6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfb:	52                   	push   %edx
  800bfc:	50                   	push   %eax
  800bfd:	ff 75 f4             	pushl  -0xc(%ebp)
  800c00:	ff 75 f0             	pushl  -0x10(%ebp)
  800c03:	e8 b0 19 00 00       	call   8025b8 <__udivdi3>
  800c08:	83 c4 10             	add    $0x10,%esp
  800c0b:	83 ec 04             	sub    $0x4,%esp
  800c0e:	ff 75 20             	pushl  0x20(%ebp)
  800c11:	53                   	push   %ebx
  800c12:	ff 75 18             	pushl  0x18(%ebp)
  800c15:	52                   	push   %edx
  800c16:	50                   	push   %eax
  800c17:	ff 75 0c             	pushl  0xc(%ebp)
  800c1a:	ff 75 08             	pushl  0x8(%ebp)
  800c1d:	e8 a1 ff ff ff       	call   800bc3 <printnum>
  800c22:	83 c4 20             	add    $0x20,%esp
  800c25:	eb 1a                	jmp    800c41 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	ff 75 20             	pushl  0x20(%ebp)
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	ff d0                	call   *%eax
  800c35:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c38:	ff 4d 1c             	decl   0x1c(%ebp)
  800c3b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c3f:	7f e6                	jg     800c27 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c41:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4f:	53                   	push   %ebx
  800c50:	51                   	push   %ecx
  800c51:	52                   	push   %edx
  800c52:	50                   	push   %eax
  800c53:	e8 70 1a 00 00       	call   8026c8 <__umoddi3>
  800c58:	83 c4 10             	add    $0x10,%esp
  800c5b:	05 34 31 80 00       	add    $0x803134,%eax
  800c60:	8a 00                	mov    (%eax),%al
  800c62:	0f be c0             	movsbl %al,%eax
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	ff 75 0c             	pushl  0xc(%ebp)
  800c6b:	50                   	push   %eax
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
}
  800c74:	90                   	nop
  800c75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c7d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c81:	7e 1c                	jle    800c9f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8b 00                	mov    (%eax),%eax
  800c88:	8d 50 08             	lea    0x8(%eax),%edx
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	89 10                	mov    %edx,(%eax)
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	83 e8 08             	sub    $0x8,%eax
  800c98:	8b 50 04             	mov    0x4(%eax),%edx
  800c9b:	8b 00                	mov    (%eax),%eax
  800c9d:	eb 40                	jmp    800cdf <getuint+0x65>
	else if (lflag)
  800c9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca3:	74 1e                	je     800cc3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8b 00                	mov    (%eax),%eax
  800caa:	8d 50 04             	lea    0x4(%eax),%edx
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	89 10                	mov    %edx,(%eax)
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8b 00                	mov    (%eax),%eax
  800cb7:	83 e8 04             	sub    $0x4,%eax
  800cba:	8b 00                	mov    (%eax),%eax
  800cbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc1:	eb 1c                	jmp    800cdf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8b 00                	mov    (%eax),%eax
  800cc8:	8d 50 04             	lea    0x4(%eax),%edx
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	89 10                	mov    %edx,(%eax)
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8b 00                	mov    (%eax),%eax
  800cd5:	83 e8 04             	sub    $0x4,%eax
  800cd8:	8b 00                	mov    (%eax),%eax
  800cda:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cdf:	5d                   	pop    %ebp
  800ce0:	c3                   	ret    

00800ce1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ce4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ce8:	7e 1c                	jle    800d06 <getint+0x25>
		return va_arg(*ap, long long);
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	8d 50 08             	lea    0x8(%eax),%edx
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	89 10                	mov    %edx,(%eax)
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8b 00                	mov    (%eax),%eax
  800cfc:	83 e8 08             	sub    $0x8,%eax
  800cff:	8b 50 04             	mov    0x4(%eax),%edx
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	eb 38                	jmp    800d3e <getint+0x5d>
	else if (lflag)
  800d06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d0a:	74 1a                	je     800d26 <getint+0x45>
		return va_arg(*ap, long);
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8b 00                	mov    (%eax),%eax
  800d11:	8d 50 04             	lea    0x4(%eax),%edx
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	89 10                	mov    %edx,(%eax)
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8b 00                	mov    (%eax),%eax
  800d1e:	83 e8 04             	sub    $0x4,%eax
  800d21:	8b 00                	mov    (%eax),%eax
  800d23:	99                   	cltd   
  800d24:	eb 18                	jmp    800d3e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8b 00                	mov    (%eax),%eax
  800d2b:	8d 50 04             	lea    0x4(%eax),%edx
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	89 10                	mov    %edx,(%eax)
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	8b 00                	mov    (%eax),%eax
  800d38:	83 e8 04             	sub    $0x4,%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	99                   	cltd   
}
  800d3e:	5d                   	pop    %ebp
  800d3f:	c3                   	ret    

00800d40 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	56                   	push   %esi
  800d44:	53                   	push   %ebx
  800d45:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d48:	eb 17                	jmp    800d61 <vprintfmt+0x21>
			if (ch == '\0')
  800d4a:	85 db                	test   %ebx,%ebx
  800d4c:	0f 84 af 03 00 00    	je     801101 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d52:	83 ec 08             	sub    $0x8,%esp
  800d55:	ff 75 0c             	pushl  0xc(%ebp)
  800d58:	53                   	push   %ebx
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	ff d0                	call   *%eax
  800d5e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d61:	8b 45 10             	mov    0x10(%ebp),%eax
  800d64:	8d 50 01             	lea    0x1(%eax),%edx
  800d67:	89 55 10             	mov    %edx,0x10(%ebp)
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	0f b6 d8             	movzbl %al,%ebx
  800d6f:	83 fb 25             	cmp    $0x25,%ebx
  800d72:	75 d6                	jne    800d4a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d74:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d78:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d7f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d86:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d8d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d94:	8b 45 10             	mov    0x10(%ebp),%eax
  800d97:	8d 50 01             	lea    0x1(%eax),%edx
  800d9a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	0f b6 d8             	movzbl %al,%ebx
  800da2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800da5:	83 f8 55             	cmp    $0x55,%eax
  800da8:	0f 87 2b 03 00 00    	ja     8010d9 <vprintfmt+0x399>
  800dae:	8b 04 85 58 31 80 00 	mov    0x803158(,%eax,4),%eax
  800db5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800db7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800dbb:	eb d7                	jmp    800d94 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800dbd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800dc1:	eb d1                	jmp    800d94 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dc3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800dca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dcd:	89 d0                	mov    %edx,%eax
  800dcf:	c1 e0 02             	shl    $0x2,%eax
  800dd2:	01 d0                	add    %edx,%eax
  800dd4:	01 c0                	add    %eax,%eax
  800dd6:	01 d8                	add    %ebx,%eax
  800dd8:	83 e8 30             	sub    $0x30,%eax
  800ddb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dde:	8b 45 10             	mov    0x10(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800de6:	83 fb 2f             	cmp    $0x2f,%ebx
  800de9:	7e 3e                	jle    800e29 <vprintfmt+0xe9>
  800deb:	83 fb 39             	cmp    $0x39,%ebx
  800dee:	7f 39                	jg     800e29 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800df0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800df3:	eb d5                	jmp    800dca <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800df5:	8b 45 14             	mov    0x14(%ebp),%eax
  800df8:	83 c0 04             	add    $0x4,%eax
  800dfb:	89 45 14             	mov    %eax,0x14(%ebp)
  800dfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800e01:	83 e8 04             	sub    $0x4,%eax
  800e04:	8b 00                	mov    (%eax),%eax
  800e06:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e09:	eb 1f                	jmp    800e2a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e0f:	79 83                	jns    800d94 <vprintfmt+0x54>
				width = 0;
  800e11:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e18:	e9 77 ff ff ff       	jmp    800d94 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e1d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e24:	e9 6b ff ff ff       	jmp    800d94 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e29:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e2e:	0f 89 60 ff ff ff    	jns    800d94 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e3a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e41:	e9 4e ff ff ff       	jmp    800d94 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e46:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e49:	e9 46 ff ff ff       	jmp    800d94 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e51:	83 c0 04             	add    $0x4,%eax
  800e54:	89 45 14             	mov    %eax,0x14(%ebp)
  800e57:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5a:	83 e8 04             	sub    $0x4,%eax
  800e5d:	8b 00                	mov    (%eax),%eax
  800e5f:	83 ec 08             	sub    $0x8,%esp
  800e62:	ff 75 0c             	pushl  0xc(%ebp)
  800e65:	50                   	push   %eax
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	ff d0                	call   *%eax
  800e6b:	83 c4 10             	add    $0x10,%esp
			break;
  800e6e:	e9 89 02 00 00       	jmp    8010fc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e73:	8b 45 14             	mov    0x14(%ebp),%eax
  800e76:	83 c0 04             	add    $0x4,%eax
  800e79:	89 45 14             	mov    %eax,0x14(%ebp)
  800e7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7f:	83 e8 04             	sub    $0x4,%eax
  800e82:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e84:	85 db                	test   %ebx,%ebx
  800e86:	79 02                	jns    800e8a <vprintfmt+0x14a>
				err = -err;
  800e88:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e8a:	83 fb 64             	cmp    $0x64,%ebx
  800e8d:	7f 0b                	jg     800e9a <vprintfmt+0x15a>
  800e8f:	8b 34 9d a0 2f 80 00 	mov    0x802fa0(,%ebx,4),%esi
  800e96:	85 f6                	test   %esi,%esi
  800e98:	75 19                	jne    800eb3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e9a:	53                   	push   %ebx
  800e9b:	68 45 31 80 00       	push   $0x803145
  800ea0:	ff 75 0c             	pushl  0xc(%ebp)
  800ea3:	ff 75 08             	pushl  0x8(%ebp)
  800ea6:	e8 5e 02 00 00       	call   801109 <printfmt>
  800eab:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800eae:	e9 49 02 00 00       	jmp    8010fc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800eb3:	56                   	push   %esi
  800eb4:	68 4e 31 80 00       	push   $0x80314e
  800eb9:	ff 75 0c             	pushl  0xc(%ebp)
  800ebc:	ff 75 08             	pushl  0x8(%ebp)
  800ebf:	e8 45 02 00 00       	call   801109 <printfmt>
  800ec4:	83 c4 10             	add    $0x10,%esp
			break;
  800ec7:	e9 30 02 00 00       	jmp    8010fc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecf:	83 c0 04             	add    $0x4,%eax
  800ed2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 30                	mov    (%eax),%esi
  800edd:	85 f6                	test   %esi,%esi
  800edf:	75 05                	jne    800ee6 <vprintfmt+0x1a6>
				p = "(null)";
  800ee1:	be 51 31 80 00       	mov    $0x803151,%esi
			if (width > 0 && padc != '-')
  800ee6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eea:	7e 6d                	jle    800f59 <vprintfmt+0x219>
  800eec:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ef0:	74 67                	je     800f59 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ef2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ef5:	83 ec 08             	sub    $0x8,%esp
  800ef8:	50                   	push   %eax
  800ef9:	56                   	push   %esi
  800efa:	e8 0c 03 00 00       	call   80120b <strnlen>
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f05:	eb 16                	jmp    800f1d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f07:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f0b:	83 ec 08             	sub    $0x8,%esp
  800f0e:	ff 75 0c             	pushl  0xc(%ebp)
  800f11:	50                   	push   %eax
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	ff d0                	call   *%eax
  800f17:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f1a:	ff 4d e4             	decl   -0x1c(%ebp)
  800f1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f21:	7f e4                	jg     800f07 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f23:	eb 34                	jmp    800f59 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f25:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f29:	74 1c                	je     800f47 <vprintfmt+0x207>
  800f2b:	83 fb 1f             	cmp    $0x1f,%ebx
  800f2e:	7e 05                	jle    800f35 <vprintfmt+0x1f5>
  800f30:	83 fb 7e             	cmp    $0x7e,%ebx
  800f33:	7e 12                	jle    800f47 <vprintfmt+0x207>
					putch('?', putdat);
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	ff 75 0c             	pushl  0xc(%ebp)
  800f3b:	6a 3f                	push   $0x3f
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	ff d0                	call   *%eax
  800f42:	83 c4 10             	add    $0x10,%esp
  800f45:	eb 0f                	jmp    800f56 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f47:	83 ec 08             	sub    $0x8,%esp
  800f4a:	ff 75 0c             	pushl  0xc(%ebp)
  800f4d:	53                   	push   %ebx
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	ff d0                	call   *%eax
  800f53:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f56:	ff 4d e4             	decl   -0x1c(%ebp)
  800f59:	89 f0                	mov    %esi,%eax
  800f5b:	8d 70 01             	lea    0x1(%eax),%esi
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	0f be d8             	movsbl %al,%ebx
  800f63:	85 db                	test   %ebx,%ebx
  800f65:	74 24                	je     800f8b <vprintfmt+0x24b>
  800f67:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f6b:	78 b8                	js     800f25 <vprintfmt+0x1e5>
  800f6d:	ff 4d e0             	decl   -0x20(%ebp)
  800f70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f74:	79 af                	jns    800f25 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f76:	eb 13                	jmp    800f8b <vprintfmt+0x24b>
				putch(' ', putdat);
  800f78:	83 ec 08             	sub    $0x8,%esp
  800f7b:	ff 75 0c             	pushl  0xc(%ebp)
  800f7e:	6a 20                	push   $0x20
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	ff d0                	call   *%eax
  800f85:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f88:	ff 4d e4             	decl   -0x1c(%ebp)
  800f8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f8f:	7f e7                	jg     800f78 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f91:	e9 66 01 00 00       	jmp    8010fc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 e8             	pushl  -0x18(%ebp)
  800f9c:	8d 45 14             	lea    0x14(%ebp),%eax
  800f9f:	50                   	push   %eax
  800fa0:	e8 3c fd ff ff       	call   800ce1 <getint>
  800fa5:	83 c4 10             	add    $0x10,%esp
  800fa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb4:	85 d2                	test   %edx,%edx
  800fb6:	79 23                	jns    800fdb <vprintfmt+0x29b>
				putch('-', putdat);
  800fb8:	83 ec 08             	sub    $0x8,%esp
  800fbb:	ff 75 0c             	pushl  0xc(%ebp)
  800fbe:	6a 2d                	push   $0x2d
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	ff d0                	call   *%eax
  800fc5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fce:	f7 d8                	neg    %eax
  800fd0:	83 d2 00             	adc    $0x0,%edx
  800fd3:	f7 da                	neg    %edx
  800fd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fdb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fe2:	e9 bc 00 00 00       	jmp    8010a3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fe7:	83 ec 08             	sub    $0x8,%esp
  800fea:	ff 75 e8             	pushl  -0x18(%ebp)
  800fed:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff0:	50                   	push   %eax
  800ff1:	e8 84 fc ff ff       	call   800c7a <getuint>
  800ff6:	83 c4 10             	add    $0x10,%esp
  800ff9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801006:	e9 98 00 00 00       	jmp    8010a3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80100b:	83 ec 08             	sub    $0x8,%esp
  80100e:	ff 75 0c             	pushl  0xc(%ebp)
  801011:	6a 58                	push   $0x58
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	ff d0                	call   *%eax
  801018:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80101b:	83 ec 08             	sub    $0x8,%esp
  80101e:	ff 75 0c             	pushl  0xc(%ebp)
  801021:	6a 58                	push   $0x58
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	ff d0                	call   *%eax
  801028:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	6a 58                	push   $0x58
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	ff d0                	call   *%eax
  801038:	83 c4 10             	add    $0x10,%esp
			break;
  80103b:	e9 bc 00 00 00       	jmp    8010fc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801040:	83 ec 08             	sub    $0x8,%esp
  801043:	ff 75 0c             	pushl  0xc(%ebp)
  801046:	6a 30                	push   $0x30
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	ff d0                	call   *%eax
  80104d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801050:	83 ec 08             	sub    $0x8,%esp
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	6a 78                	push   $0x78
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	ff d0                	call   *%eax
  80105d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801060:	8b 45 14             	mov    0x14(%ebp),%eax
  801063:	83 c0 04             	add    $0x4,%eax
  801066:	89 45 14             	mov    %eax,0x14(%ebp)
  801069:	8b 45 14             	mov    0x14(%ebp),%eax
  80106c:	83 e8 04             	sub    $0x4,%eax
  80106f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801071:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801074:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80107b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801082:	eb 1f                	jmp    8010a3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801084:	83 ec 08             	sub    $0x8,%esp
  801087:	ff 75 e8             	pushl  -0x18(%ebp)
  80108a:	8d 45 14             	lea    0x14(%ebp),%eax
  80108d:	50                   	push   %eax
  80108e:	e8 e7 fb ff ff       	call   800c7a <getuint>
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801099:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80109c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010a3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010aa:	83 ec 04             	sub    $0x4,%esp
  8010ad:	52                   	push   %edx
  8010ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010b1:	50                   	push   %eax
  8010b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8010b8:	ff 75 0c             	pushl  0xc(%ebp)
  8010bb:	ff 75 08             	pushl  0x8(%ebp)
  8010be:	e8 00 fb ff ff       	call   800bc3 <printnum>
  8010c3:	83 c4 20             	add    $0x20,%esp
			break;
  8010c6:	eb 34                	jmp    8010fc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010c8:	83 ec 08             	sub    $0x8,%esp
  8010cb:	ff 75 0c             	pushl  0xc(%ebp)
  8010ce:	53                   	push   %ebx
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	ff d0                	call   *%eax
  8010d4:	83 c4 10             	add    $0x10,%esp
			break;
  8010d7:	eb 23                	jmp    8010fc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010d9:	83 ec 08             	sub    $0x8,%esp
  8010dc:	ff 75 0c             	pushl  0xc(%ebp)
  8010df:	6a 25                	push   $0x25
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	ff d0                	call   *%eax
  8010e6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010e9:	ff 4d 10             	decl   0x10(%ebp)
  8010ec:	eb 03                	jmp    8010f1 <vprintfmt+0x3b1>
  8010ee:	ff 4d 10             	decl   0x10(%ebp)
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	48                   	dec    %eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	3c 25                	cmp    $0x25,%al
  8010f9:	75 f3                	jne    8010ee <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8010fb:	90                   	nop
		}
	}
  8010fc:	e9 47 fc ff ff       	jmp    800d48 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801101:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801102:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801105:	5b                   	pop    %ebx
  801106:	5e                   	pop    %esi
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    

00801109 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80110f:	8d 45 10             	lea    0x10(%ebp),%eax
  801112:	83 c0 04             	add    $0x4,%eax
  801115:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801118:	8b 45 10             	mov    0x10(%ebp),%eax
  80111b:	ff 75 f4             	pushl  -0xc(%ebp)
  80111e:	50                   	push   %eax
  80111f:	ff 75 0c             	pushl  0xc(%ebp)
  801122:	ff 75 08             	pushl  0x8(%ebp)
  801125:	e8 16 fc ff ff       	call   800d40 <vprintfmt>
  80112a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80112d:	90                   	nop
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801133:	8b 45 0c             	mov    0xc(%ebp),%eax
  801136:	8b 40 08             	mov    0x8(%eax),%eax
  801139:	8d 50 01             	lea    0x1(%eax),%edx
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	8b 10                	mov    (%eax),%edx
  801147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114a:	8b 40 04             	mov    0x4(%eax),%eax
  80114d:	39 c2                	cmp    %eax,%edx
  80114f:	73 12                	jae    801163 <sprintputch+0x33>
		*b->buf++ = ch;
  801151:	8b 45 0c             	mov    0xc(%ebp),%eax
  801154:	8b 00                	mov    (%eax),%eax
  801156:	8d 48 01             	lea    0x1(%eax),%ecx
  801159:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115c:	89 0a                	mov    %ecx,(%edx)
  80115e:	8b 55 08             	mov    0x8(%ebp),%edx
  801161:	88 10                	mov    %dl,(%eax)
}
  801163:	90                   	nop
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	8d 50 ff             	lea    -0x1(%eax),%edx
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	01 d0                	add    %edx,%eax
  80117d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801180:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801187:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80118b:	74 06                	je     801193 <vsnprintf+0x2d>
  80118d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801191:	7f 07                	jg     80119a <vsnprintf+0x34>
		return -E_INVAL;
  801193:	b8 03 00 00 00       	mov    $0x3,%eax
  801198:	eb 20                	jmp    8011ba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80119a:	ff 75 14             	pushl  0x14(%ebp)
  80119d:	ff 75 10             	pushl  0x10(%ebp)
  8011a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011a3:	50                   	push   %eax
  8011a4:	68 30 11 80 00       	push   $0x801130
  8011a9:	e8 92 fb ff ff       	call   800d40 <vprintfmt>
  8011ae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8011c5:	83 c0 04             	add    $0x4,%eax
  8011c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8011d1:	50                   	push   %eax
  8011d2:	ff 75 0c             	pushl  0xc(%ebp)
  8011d5:	ff 75 08             	pushl  0x8(%ebp)
  8011d8:	e8 89 ff ff ff       	call   801166 <vsnprintf>
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8011ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011f5:	eb 06                	jmp    8011fd <strlen+0x15>
		n++;
  8011f7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011fa:	ff 45 08             	incl   0x8(%ebp)
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	84 c0                	test   %al,%al
  801204:	75 f1                	jne    8011f7 <strlen+0xf>
		n++;
	return n;
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801211:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801218:	eb 09                	jmp    801223 <strnlen+0x18>
		n++;
  80121a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80121d:	ff 45 08             	incl   0x8(%ebp)
  801220:	ff 4d 0c             	decl   0xc(%ebp)
  801223:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801227:	74 09                	je     801232 <strnlen+0x27>
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	84 c0                	test   %al,%al
  801230:	75 e8                	jne    80121a <strnlen+0xf>
		n++;
	return n;
  801232:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801243:	90                   	nop
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	8d 50 01             	lea    0x1(%eax),%edx
  80124a:	89 55 08             	mov    %edx,0x8(%ebp)
  80124d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801250:	8d 4a 01             	lea    0x1(%edx),%ecx
  801253:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801256:	8a 12                	mov    (%edx),%dl
  801258:	88 10                	mov    %dl,(%eax)
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	84 c0                	test   %al,%al
  80125e:	75 e4                	jne    801244 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801260:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801271:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801278:	eb 1f                	jmp    801299 <strncpy+0x34>
		*dst++ = *src;
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8d 50 01             	lea    0x1(%eax),%edx
  801280:	89 55 08             	mov    %edx,0x8(%ebp)
  801283:	8b 55 0c             	mov    0xc(%ebp),%edx
  801286:	8a 12                	mov    (%edx),%dl
  801288:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80128a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	84 c0                	test   %al,%al
  801291:	74 03                	je     801296 <strncpy+0x31>
			src++;
  801293:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801296:	ff 45 fc             	incl   -0x4(%ebp)
  801299:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80129f:	72 d9                	jb     80127a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b6:	74 30                	je     8012e8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012b8:	eb 16                	jmp    8012d0 <strlcpy+0x2a>
			*dst++ = *src++;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	8d 50 01             	lea    0x1(%eax),%edx
  8012c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012cc:	8a 12                	mov    (%edx),%dl
  8012ce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012d0:	ff 4d 10             	decl   0x10(%ebp)
  8012d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d7:	74 09                	je     8012e2 <strlcpy+0x3c>
  8012d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	84 c0                	test   %al,%al
  8012e0:	75 d8                	jne    8012ba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8012e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8012eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ee:	29 c2                	sub    %eax,%edx
  8012f0:	89 d0                	mov    %edx,%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8012f7:	eb 06                	jmp    8012ff <strcmp+0xb>
		p++, q++;
  8012f9:	ff 45 08             	incl   0x8(%ebp)
  8012fc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	8a 00                	mov    (%eax),%al
  801304:	84 c0                	test   %al,%al
  801306:	74 0e                	je     801316 <strcmp+0x22>
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	8a 10                	mov    (%eax),%dl
  80130d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	38 c2                	cmp    %al,%dl
  801314:	74 e3                	je     8012f9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	0f b6 d0             	movzbl %al,%edx
  80131e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801321:	8a 00                	mov    (%eax),%al
  801323:	0f b6 c0             	movzbl %al,%eax
  801326:	29 c2                	sub    %eax,%edx
  801328:	89 d0                	mov    %edx,%eax
}
  80132a:	5d                   	pop    %ebp
  80132b:	c3                   	ret    

0080132c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80132f:	eb 09                	jmp    80133a <strncmp+0xe>
		n--, p++, q++;
  801331:	ff 4d 10             	decl   0x10(%ebp)
  801334:	ff 45 08             	incl   0x8(%ebp)
  801337:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80133a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80133e:	74 17                	je     801357 <strncmp+0x2b>
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	84 c0                	test   %al,%al
  801347:	74 0e                	je     801357 <strncmp+0x2b>
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 10                	mov    (%eax),%dl
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	38 c2                	cmp    %al,%dl
  801355:	74 da                	je     801331 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801357:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80135b:	75 07                	jne    801364 <strncmp+0x38>
		return 0;
  80135d:	b8 00 00 00 00       	mov    $0x0,%eax
  801362:	eb 14                	jmp    801378 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8a 00                	mov    (%eax),%al
  801369:	0f b6 d0             	movzbl %al,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	0f b6 c0             	movzbl %al,%eax
  801374:	29 c2                	sub    %eax,%edx
  801376:	89 d0                	mov    %edx,%eax
}
  801378:	5d                   	pop    %ebp
  801379:	c3                   	ret    

0080137a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 04             	sub    $0x4,%esp
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801386:	eb 12                	jmp    80139a <strchr+0x20>
		if (*s == c)
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	8a 00                	mov    (%eax),%al
  80138d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801390:	75 05                	jne    801397 <strchr+0x1d>
			return (char *) s;
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	eb 11                	jmp    8013a8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801397:	ff 45 08             	incl   0x8(%ebp)
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8a 00                	mov    (%eax),%al
  80139f:	84 c0                	test   %al,%al
  8013a1:	75 e5                	jne    801388 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 04             	sub    $0x4,%esp
  8013b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013b6:	eb 0d                	jmp    8013c5 <strfind+0x1b>
		if (*s == c)
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013c0:	74 0e                	je     8013d0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013c2:	ff 45 08             	incl   0x8(%ebp)
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	8a 00                	mov    (%eax),%al
  8013ca:	84 c0                	test   %al,%al
  8013cc:	75 ea                	jne    8013b8 <strfind+0xe>
  8013ce:	eb 01                	jmp    8013d1 <strfind+0x27>
		if (*s == c)
			break;
  8013d0:	90                   	nop
	return (char *) s;
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8013e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8013e8:	eb 0e                	jmp    8013f8 <memset+0x22>
		*p++ = c;
  8013ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ed:	8d 50 01             	lea    0x1(%eax),%edx
  8013f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8013f8:	ff 4d f8             	decl   -0x8(%ebp)
  8013fb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8013ff:	79 e9                	jns    8013ea <memset+0x14>
		*p++ = c;

	return v;
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80140c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801418:	eb 16                	jmp    801430 <memcpy+0x2a>
		*d++ = *s++;
  80141a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80141d:	8d 50 01             	lea    0x1(%eax),%edx
  801420:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801423:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801426:	8d 4a 01             	lea    0x1(%edx),%ecx
  801429:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80142c:	8a 12                	mov    (%edx),%dl
  80142e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801430:	8b 45 10             	mov    0x10(%ebp),%eax
  801433:	8d 50 ff             	lea    -0x1(%eax),%edx
  801436:	89 55 10             	mov    %edx,0x10(%ebp)
  801439:	85 c0                	test   %eax,%eax
  80143b:	75 dd                	jne    80141a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801440:	c9                   	leave  
  801441:	c3                   	ret    

00801442 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801454:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801457:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80145a:	73 50                	jae    8014ac <memmove+0x6a>
  80145c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145f:	8b 45 10             	mov    0x10(%ebp),%eax
  801462:	01 d0                	add    %edx,%eax
  801464:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801467:	76 43                	jbe    8014ac <memmove+0x6a>
		s += n;
  801469:	8b 45 10             	mov    0x10(%ebp),%eax
  80146c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80146f:	8b 45 10             	mov    0x10(%ebp),%eax
  801472:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801475:	eb 10                	jmp    801487 <memmove+0x45>
			*--d = *--s;
  801477:	ff 4d f8             	decl   -0x8(%ebp)
  80147a:	ff 4d fc             	decl   -0x4(%ebp)
  80147d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801480:	8a 10                	mov    (%eax),%dl
  801482:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801485:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801487:	8b 45 10             	mov    0x10(%ebp),%eax
  80148a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80148d:	89 55 10             	mov    %edx,0x10(%ebp)
  801490:	85 c0                	test   %eax,%eax
  801492:	75 e3                	jne    801477 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801494:	eb 23                	jmp    8014b9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801496:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801499:	8d 50 01             	lea    0x1(%eax),%edx
  80149c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80149f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014a8:	8a 12                	mov    (%edx),%dl
  8014aa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8014af:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014b2:	89 55 10             	mov    %edx,0x10(%ebp)
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	75 dd                	jne    801496 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8014ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8014d0:	eb 2a                	jmp    8014fc <memcmp+0x3e>
		if (*s1 != *s2)
  8014d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d5:	8a 10                	mov    (%eax),%dl
  8014d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014da:	8a 00                	mov    (%eax),%al
  8014dc:	38 c2                	cmp    %al,%dl
  8014de:	74 16                	je     8014f6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8014e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e3:	8a 00                	mov    (%eax),%al
  8014e5:	0f b6 d0             	movzbl %al,%edx
  8014e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	0f b6 c0             	movzbl %al,%eax
  8014f0:	29 c2                	sub    %eax,%edx
  8014f2:	89 d0                	mov    %edx,%eax
  8014f4:	eb 18                	jmp    80150e <memcmp+0x50>
		s1++, s2++;
  8014f6:	ff 45 fc             	incl   -0x4(%ebp)
  8014f9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8014fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801502:	89 55 10             	mov    %edx,0x10(%ebp)
  801505:	85 c0                	test   %eax,%eax
  801507:	75 c9                	jne    8014d2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801509:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801516:	8b 55 08             	mov    0x8(%ebp),%edx
  801519:	8b 45 10             	mov    0x10(%ebp),%eax
  80151c:	01 d0                	add    %edx,%eax
  80151e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801521:	eb 15                	jmp    801538 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8a 00                	mov    (%eax),%al
  801528:	0f b6 d0             	movzbl %al,%edx
  80152b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152e:	0f b6 c0             	movzbl %al,%eax
  801531:	39 c2                	cmp    %eax,%edx
  801533:	74 0d                	je     801542 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801535:	ff 45 08             	incl   0x8(%ebp)
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80153e:	72 e3                	jb     801523 <memfind+0x13>
  801540:	eb 01                	jmp    801543 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801542:	90                   	nop
	return (void *) s;
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80154e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801555:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80155c:	eb 03                	jmp    801561 <strtol+0x19>
		s++;
  80155e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	8a 00                	mov    (%eax),%al
  801566:	3c 20                	cmp    $0x20,%al
  801568:	74 f4                	je     80155e <strtol+0x16>
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	8a 00                	mov    (%eax),%al
  80156f:	3c 09                	cmp    $0x9,%al
  801571:	74 eb                	je     80155e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	3c 2b                	cmp    $0x2b,%al
  80157a:	75 05                	jne    801581 <strtol+0x39>
		s++;
  80157c:	ff 45 08             	incl   0x8(%ebp)
  80157f:	eb 13                	jmp    801594 <strtol+0x4c>
	else if (*s == '-')
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	8a 00                	mov    (%eax),%al
  801586:	3c 2d                	cmp    $0x2d,%al
  801588:	75 0a                	jne    801594 <strtol+0x4c>
		s++, neg = 1;
  80158a:	ff 45 08             	incl   0x8(%ebp)
  80158d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801594:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801598:	74 06                	je     8015a0 <strtol+0x58>
  80159a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80159e:	75 20                	jne    8015c0 <strtol+0x78>
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	8a 00                	mov    (%eax),%al
  8015a5:	3c 30                	cmp    $0x30,%al
  8015a7:	75 17                	jne    8015c0 <strtol+0x78>
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	40                   	inc    %eax
  8015ad:	8a 00                	mov    (%eax),%al
  8015af:	3c 78                	cmp    $0x78,%al
  8015b1:	75 0d                	jne    8015c0 <strtol+0x78>
		s += 2, base = 16;
  8015b3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015b7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015be:	eb 28                	jmp    8015e8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8015c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015c4:	75 15                	jne    8015db <strtol+0x93>
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	3c 30                	cmp    $0x30,%al
  8015cd:	75 0c                	jne    8015db <strtol+0x93>
		s++, base = 8;
  8015cf:	ff 45 08             	incl   0x8(%ebp)
  8015d2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8015d9:	eb 0d                	jmp    8015e8 <strtol+0xa0>
	else if (base == 0)
  8015db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015df:	75 07                	jne    8015e8 <strtol+0xa0>
		base = 10;
  8015e1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	3c 2f                	cmp    $0x2f,%al
  8015ef:	7e 19                	jle    80160a <strtol+0xc2>
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	8a 00                	mov    (%eax),%al
  8015f6:	3c 39                	cmp    $0x39,%al
  8015f8:	7f 10                	jg     80160a <strtol+0xc2>
			dig = *s - '0';
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	8a 00                	mov    (%eax),%al
  8015ff:	0f be c0             	movsbl %al,%eax
  801602:	83 e8 30             	sub    $0x30,%eax
  801605:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801608:	eb 42                	jmp    80164c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	3c 60                	cmp    $0x60,%al
  801611:	7e 19                	jle    80162c <strtol+0xe4>
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	8a 00                	mov    (%eax),%al
  801618:	3c 7a                	cmp    $0x7a,%al
  80161a:	7f 10                	jg     80162c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	8a 00                	mov    (%eax),%al
  801621:	0f be c0             	movsbl %al,%eax
  801624:	83 e8 57             	sub    $0x57,%eax
  801627:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80162a:	eb 20                	jmp    80164c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8a 00                	mov    (%eax),%al
  801631:	3c 40                	cmp    $0x40,%al
  801633:	7e 39                	jle    80166e <strtol+0x126>
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	3c 5a                	cmp    $0x5a,%al
  80163c:	7f 30                	jg     80166e <strtol+0x126>
			dig = *s - 'A' + 10;
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	0f be c0             	movsbl %al,%eax
  801646:	83 e8 37             	sub    $0x37,%eax
  801649:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80164c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801652:	7d 19                	jge    80166d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801654:	ff 45 08             	incl   0x8(%ebp)
  801657:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80165e:	89 c2                	mov    %eax,%edx
  801660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801663:	01 d0                	add    %edx,%eax
  801665:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801668:	e9 7b ff ff ff       	jmp    8015e8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80166d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80166e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801672:	74 08                	je     80167c <strtol+0x134>
		*endptr = (char *) s;
  801674:	8b 45 0c             	mov    0xc(%ebp),%eax
  801677:	8b 55 08             	mov    0x8(%ebp),%edx
  80167a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80167c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801680:	74 07                	je     801689 <strtol+0x141>
  801682:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801685:	f7 d8                	neg    %eax
  801687:	eb 03                	jmp    80168c <strtol+0x144>
  801689:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <ltostr>:

void
ltostr(long value, char *str)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801694:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80169b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016a6:	79 13                	jns    8016bb <ltostr+0x2d>
	{
		neg = 1;
  8016a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016b5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016b8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016c3:	99                   	cltd   
  8016c4:	f7 f9                	idiv   %ecx
  8016c6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8016c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cc:	8d 50 01             	lea    0x1(%eax),%edx
  8016cf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016d2:	89 c2                	mov    %eax,%edx
  8016d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d7:	01 d0                	add    %edx,%eax
  8016d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016dc:	83 c2 30             	add    $0x30,%edx
  8016df:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8016e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8016e9:	f7 e9                	imul   %ecx
  8016eb:	c1 fa 02             	sar    $0x2,%edx
  8016ee:	89 c8                	mov    %ecx,%eax
  8016f0:	c1 f8 1f             	sar    $0x1f,%eax
  8016f3:	29 c2                	sub    %eax,%edx
  8016f5:	89 d0                	mov    %edx,%eax
  8016f7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8016fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016fd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801702:	f7 e9                	imul   %ecx
  801704:	c1 fa 02             	sar    $0x2,%edx
  801707:	89 c8                	mov    %ecx,%eax
  801709:	c1 f8 1f             	sar    $0x1f,%eax
  80170c:	29 c2                	sub    %eax,%edx
  80170e:	89 d0                	mov    %edx,%eax
  801710:	c1 e0 02             	shl    $0x2,%eax
  801713:	01 d0                	add    %edx,%eax
  801715:	01 c0                	add    %eax,%eax
  801717:	29 c1                	sub    %eax,%ecx
  801719:	89 ca                	mov    %ecx,%edx
  80171b:	85 d2                	test   %edx,%edx
  80171d:	75 9c                	jne    8016bb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80171f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801726:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801729:	48                   	dec    %eax
  80172a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80172d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801731:	74 3d                	je     801770 <ltostr+0xe2>
		start = 1 ;
  801733:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80173a:	eb 34                	jmp    801770 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80173c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801742:	01 d0                	add    %edx,%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801749:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174f:	01 c2                	add    %eax,%edx
  801751:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801754:	8b 45 0c             	mov    0xc(%ebp),%eax
  801757:	01 c8                	add    %ecx,%eax
  801759:	8a 00                	mov    (%eax),%al
  80175b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80175d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801760:	8b 45 0c             	mov    0xc(%ebp),%eax
  801763:	01 c2                	add    %eax,%edx
  801765:	8a 45 eb             	mov    -0x15(%ebp),%al
  801768:	88 02                	mov    %al,(%edx)
		start++ ;
  80176a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80176d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801773:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801776:	7c c4                	jl     80173c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801778:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80177b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177e:	01 d0                	add    %edx,%eax
  801780:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801783:	90                   	nop
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	e8 54 fa ff ff       	call   8011e8 <strlen>
  801794:	83 c4 04             	add    $0x4,%esp
  801797:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80179a:	ff 75 0c             	pushl  0xc(%ebp)
  80179d:	e8 46 fa ff ff       	call   8011e8 <strlen>
  8017a2:	83 c4 04             	add    $0x4,%esp
  8017a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b6:	eb 17                	jmp    8017cf <strcconcat+0x49>
		final[s] = str1[s] ;
  8017b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017be:	01 c2                	add    %eax,%edx
  8017c0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	01 c8                	add    %ecx,%eax
  8017c8:	8a 00                	mov    (%eax),%al
  8017ca:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8017cc:	ff 45 fc             	incl   -0x4(%ebp)
  8017cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017d5:	7c e1                	jl     8017b8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8017d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8017de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8017e5:	eb 1f                	jmp    801806 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8017e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017ea:	8d 50 01             	lea    0x1(%eax),%edx
  8017ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017f0:	89 c2                	mov    %eax,%edx
  8017f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f5:	01 c2                	add    %eax,%edx
  8017f7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8017fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fd:	01 c8                	add    %ecx,%eax
  8017ff:	8a 00                	mov    (%eax),%al
  801801:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801803:	ff 45 f8             	incl   -0x8(%ebp)
  801806:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801809:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80180c:	7c d9                	jl     8017e7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80180e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801811:	8b 45 10             	mov    0x10(%ebp),%eax
  801814:	01 d0                	add    %edx,%eax
  801816:	c6 00 00             	movb   $0x0,(%eax)
}
  801819:	90                   	nop
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80181f:	8b 45 14             	mov    0x14(%ebp),%eax
  801822:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801828:	8b 45 14             	mov    0x14(%ebp),%eax
  80182b:	8b 00                	mov    (%eax),%eax
  80182d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801834:	8b 45 10             	mov    0x10(%ebp),%eax
  801837:	01 d0                	add    %edx,%eax
  801839:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80183f:	eb 0c                	jmp    80184d <strsplit+0x31>
			*string++ = 0;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8d 50 01             	lea    0x1(%eax),%edx
  801847:	89 55 08             	mov    %edx,0x8(%ebp)
  80184a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	8a 00                	mov    (%eax),%al
  801852:	84 c0                	test   %al,%al
  801854:	74 18                	je     80186e <strsplit+0x52>
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	0f be c0             	movsbl %al,%eax
  80185e:	50                   	push   %eax
  80185f:	ff 75 0c             	pushl  0xc(%ebp)
  801862:	e8 13 fb ff ff       	call   80137a <strchr>
  801867:	83 c4 08             	add    $0x8,%esp
  80186a:	85 c0                	test   %eax,%eax
  80186c:	75 d3                	jne    801841 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	8a 00                	mov    (%eax),%al
  801873:	84 c0                	test   %al,%al
  801875:	74 5a                	je     8018d1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801877:	8b 45 14             	mov    0x14(%ebp),%eax
  80187a:	8b 00                	mov    (%eax),%eax
  80187c:	83 f8 0f             	cmp    $0xf,%eax
  80187f:	75 07                	jne    801888 <strsplit+0x6c>
		{
			return 0;
  801881:	b8 00 00 00 00       	mov    $0x0,%eax
  801886:	eb 66                	jmp    8018ee <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801888:	8b 45 14             	mov    0x14(%ebp),%eax
  80188b:	8b 00                	mov    (%eax),%eax
  80188d:	8d 48 01             	lea    0x1(%eax),%ecx
  801890:	8b 55 14             	mov    0x14(%ebp),%edx
  801893:	89 0a                	mov    %ecx,(%edx)
  801895:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80189c:	8b 45 10             	mov    0x10(%ebp),%eax
  80189f:	01 c2                	add    %eax,%edx
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018a6:	eb 03                	jmp    8018ab <strsplit+0x8f>
			string++;
  8018a8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	8a 00                	mov    (%eax),%al
  8018b0:	84 c0                	test   %al,%al
  8018b2:	74 8b                	je     80183f <strsplit+0x23>
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	8a 00                	mov    (%eax),%al
  8018b9:	0f be c0             	movsbl %al,%eax
  8018bc:	50                   	push   %eax
  8018bd:	ff 75 0c             	pushl  0xc(%ebp)
  8018c0:	e8 b5 fa ff ff       	call   80137a <strchr>
  8018c5:	83 c4 08             	add    $0x8,%esp
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	74 dc                	je     8018a8 <strsplit+0x8c>
			string++;
	}
  8018cc:	e9 6e ff ff ff       	jmp    80183f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8018d1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8018d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d5:	8b 00                	mov    (%eax),%eax
  8018d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018de:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e1:	01 d0                	add    %edx,%eax
  8018e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8018e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8018f6:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8018fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801900:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801903:	01 d0                	add    %edx,%eax
  801905:	48                   	dec    %eax
  801906:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801909:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80190c:	ba 00 00 00 00       	mov    $0x0,%edx
  801911:	f7 75 ac             	divl   -0x54(%ebp)
  801914:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801917:	29 d0                	sub    %edx,%eax
  801919:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  80191c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801923:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  80192a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801931:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801938:	eb 3f                	jmp    801979 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  80193a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80193d:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801944:	83 ec 04             	sub    $0x4,%esp
  801947:	50                   	push   %eax
  801948:	ff 75 e8             	pushl  -0x18(%ebp)
  80194b:	68 b0 32 80 00       	push   $0x8032b0
  801950:	e8 11 f2 ff ff       	call   800b66 <cprintf>
  801955:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801958:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80195b:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	50                   	push   %eax
  801966:	ff 75 e8             	pushl  -0x18(%ebp)
  801969:	68 c5 32 80 00       	push   $0x8032c5
  80196e:	e8 f3 f1 ff ff       	call   800b66 <cprintf>
  801973:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801976:	ff 45 e8             	incl   -0x18(%ebp)
  801979:	a1 28 40 80 00       	mov    0x804028,%eax
  80197e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801981:	7c b7                	jl     80193a <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801983:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  80198a:	e9 42 01 00 00       	jmp    801ad1 <malloc+0x1e1>
		int flag0=1;
  80198f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801996:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801999:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80199c:	eb 6b                	jmp    801a09 <malloc+0x119>
			for(int k=0;k<count;k++){
  80199e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8019a5:	eb 42                	jmp    8019e9 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8019a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019aa:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  8019b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019b4:	39 c2                	cmp    %eax,%edx
  8019b6:	77 2e                	ja     8019e6 <malloc+0xf6>
  8019b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019bb:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  8019c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019c5:	39 c2                	cmp    %eax,%edx
  8019c7:	76 1d                	jbe    8019e6 <malloc+0xf6>
					ni=arr_add[k].end-i;
  8019c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019cc:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  8019d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019d6:	29 c2                	sub    %eax,%edx
  8019d8:	89 d0                	mov    %edx,%eax
  8019da:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  8019dd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8019e4:	eb 0d                	jmp    8019f3 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8019e6:	ff 45 d8             	incl   -0x28(%ebp)
  8019e9:	a1 28 40 80 00       	mov    0x804028,%eax
  8019ee:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8019f1:	7c b4                	jl     8019a7 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8019f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019f7:	74 09                	je     801a02 <malloc+0x112>
				flag0=0;
  8019f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801a00:	eb 16                	jmp    801a18 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801a02:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801a09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	01 c2                	add    %eax,%edx
  801a11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a14:	39 c2                	cmp    %eax,%edx
  801a16:	77 86                	ja     80199e <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801a18:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a1c:	0f 84 a2 00 00 00    	je     801ac4 <malloc+0x1d4>

			int f=1;
  801a22:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801a29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a2c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801a2f:	89 c8                	mov    %ecx,%eax
  801a31:	01 c0                	add    %eax,%eax
  801a33:	01 c8                	add    %ecx,%eax
  801a35:	c1 e0 02             	shl    $0x2,%eax
  801a38:	05 20 41 80 00       	add    $0x804120,%eax
  801a3d:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801a3f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801a48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a4b:	89 d0                	mov    %edx,%eax
  801a4d:	01 c0                	add    %eax,%eax
  801a4f:	01 d0                	add    %edx,%eax
  801a51:	c1 e0 02             	shl    $0x2,%eax
  801a54:	05 24 41 80 00       	add    $0x804124,%eax
  801a59:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a5e:	89 d0                	mov    %edx,%eax
  801a60:	01 c0                	add    %eax,%eax
  801a62:	01 d0                	add    %edx,%eax
  801a64:	c1 e0 02             	shl    $0x2,%eax
  801a67:	05 28 41 80 00       	add    $0x804128,%eax
  801a6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801a72:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801a75:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801a7c:	eb 36                	jmp    801ab4 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801a7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	01 c2                	add    %eax,%edx
  801a86:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a89:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801a90:	39 c2                	cmp    %eax,%edx
  801a92:	73 1d                	jae    801ab1 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801a94:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a97:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801a9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aa1:	29 c2                	sub    %eax,%edx
  801aa3:	89 d0                	mov    %edx,%eax
  801aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801aa8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801aaf:	eb 0d                	jmp    801abe <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801ab1:	ff 45 d0             	incl   -0x30(%ebp)
  801ab4:	a1 28 40 80 00       	mov    0x804028,%eax
  801ab9:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801abc:	7c c0                	jl     801a7e <malloc+0x18e>
					break;

				}
			}

			if(f){
  801abe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801ac2:	75 1d                	jne    801ae1 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801ac4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ace:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801ad1:	a1 04 40 80 00       	mov    0x804004,%eax
  801ad6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ad9:	0f 8c b0 fe ff ff    	jl     80198f <malloc+0x9f>
  801adf:	eb 01                	jmp    801ae2 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801ae1:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801ae2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ae6:	75 7a                	jne    801b62 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801ae8:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	01 d0                	add    %edx,%eax
  801af3:	48                   	dec    %eax
  801af4:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801af9:	7c 0a                	jl     801b05 <malloc+0x215>
			return NULL;
  801afb:	b8 00 00 00 00       	mov    $0x0,%eax
  801b00:	e9 a4 02 00 00       	jmp    801da9 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801b05:	a1 04 40 80 00       	mov    0x804004,%eax
  801b0a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801b0d:	a1 28 40 80 00       	mov    0x804028,%eax
  801b12:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801b15:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801b1c:	83 ec 08             	sub    $0x8,%esp
  801b1f:	ff 75 08             	pushl  0x8(%ebp)
  801b22:	ff 75 a4             	pushl  -0x5c(%ebp)
  801b25:	e8 04 06 00 00       	call   80212e <sys_allocateMem>
  801b2a:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801b2d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	01 d0                	add    %edx,%eax
  801b38:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801b3d:	a1 28 40 80 00       	mov    0x804028,%eax
  801b42:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b48:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801b4f:	a1 28 40 80 00       	mov    0x804028,%eax
  801b54:	40                   	inc    %eax
  801b55:	a3 28 40 80 00       	mov    %eax,0x804028

			return (void*)s;
  801b5a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801b5d:	e9 47 02 00 00       	jmp    801da9 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801b62:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801b69:	e9 ac 00 00 00       	jmp    801c1a <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801b6e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801b71:	89 d0                	mov    %edx,%eax
  801b73:	01 c0                	add    %eax,%eax
  801b75:	01 d0                	add    %edx,%eax
  801b77:	c1 e0 02             	shl    $0x2,%eax
  801b7a:	05 24 41 80 00       	add    $0x804124,%eax
  801b7f:	8b 00                	mov    (%eax),%eax
  801b81:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801b84:	eb 7e                	jmp    801c04 <malloc+0x314>
			int flag=0;
  801b86:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801b8d:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801b94:	eb 57                	jmp    801bed <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801b96:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b99:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801ba0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ba3:	39 c2                	cmp    %eax,%edx
  801ba5:	77 1a                	ja     801bc1 <malloc+0x2d1>
  801ba7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801baa:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801bb1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bb4:	39 c2                	cmp    %eax,%edx
  801bb6:	76 09                	jbe    801bc1 <malloc+0x2d1>
								flag=1;
  801bb8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801bbf:	eb 36                	jmp    801bf7 <malloc+0x307>
			arr[i].space++;
  801bc1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801bc4:	89 d0                	mov    %edx,%eax
  801bc6:	01 c0                	add    %eax,%eax
  801bc8:	01 d0                	add    %edx,%eax
  801bca:	c1 e0 02             	shl    $0x2,%eax
  801bcd:	05 28 41 80 00       	add    $0x804128,%eax
  801bd2:	8b 00                	mov    (%eax),%eax
  801bd4:	8d 48 01             	lea    0x1(%eax),%ecx
  801bd7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801bda:	89 d0                	mov    %edx,%eax
  801bdc:	01 c0                	add    %eax,%eax
  801bde:	01 d0                	add    %edx,%eax
  801be0:	c1 e0 02             	shl    $0x2,%eax
  801be3:	05 28 41 80 00       	add    $0x804128,%eax
  801be8:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801bea:	ff 45 c0             	incl   -0x40(%ebp)
  801bed:	a1 28 40 80 00       	mov    0x804028,%eax
  801bf2:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801bf5:	7c 9f                	jl     801b96 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801bf7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801bfb:	75 19                	jne    801c16 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801bfd:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801c04:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801c07:	a1 04 40 80 00       	mov    0x804004,%eax
  801c0c:	39 c2                	cmp    %eax,%edx
  801c0e:	0f 82 72 ff ff ff    	jb     801b86 <malloc+0x296>
  801c14:	eb 01                	jmp    801c17 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801c16:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801c17:	ff 45 cc             	incl   -0x34(%ebp)
  801c1a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c1d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c20:	0f 8c 48 ff ff ff    	jl     801b6e <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801c26:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801c2d:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801c34:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801c3b:	eb 37                	jmp    801c74 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801c3d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801c40:	89 d0                	mov    %edx,%eax
  801c42:	01 c0                	add    %eax,%eax
  801c44:	01 d0                	add    %edx,%eax
  801c46:	c1 e0 02             	shl    $0x2,%eax
  801c49:	05 28 41 80 00       	add    $0x804128,%eax
  801c4e:	8b 00                	mov    (%eax),%eax
  801c50:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801c53:	7d 1c                	jge    801c71 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801c55:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801c58:	89 d0                	mov    %edx,%eax
  801c5a:	01 c0                	add    %eax,%eax
  801c5c:	01 d0                	add    %edx,%eax
  801c5e:	c1 e0 02             	shl    $0x2,%eax
  801c61:	05 28 41 80 00       	add    $0x804128,%eax
  801c66:	8b 00                	mov    (%eax),%eax
  801c68:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801c6b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801c6e:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801c71:	ff 45 b4             	incl   -0x4c(%ebp)
  801c74:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801c77:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c7a:	7c c1                	jl     801c3d <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801c7c:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801c82:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801c85:	89 c8                	mov    %ecx,%eax
  801c87:	01 c0                	add    %eax,%eax
  801c89:	01 c8                	add    %ecx,%eax
  801c8b:	c1 e0 02             	shl    $0x2,%eax
  801c8e:	05 20 41 80 00       	add    $0x804120,%eax
  801c93:	8b 00                	mov    (%eax),%eax
  801c95:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801c9c:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801ca2:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801ca5:	89 c8                	mov    %ecx,%eax
  801ca7:	01 c0                	add    %eax,%eax
  801ca9:	01 c8                	add    %ecx,%eax
  801cab:	c1 e0 02             	shl    $0x2,%eax
  801cae:	05 24 41 80 00       	add    $0x804124,%eax
  801cb3:	8b 00                	mov    (%eax),%eax
  801cb5:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  801cbc:	a1 28 40 80 00       	mov    0x804028,%eax
  801cc1:	40                   	inc    %eax
  801cc2:	a3 28 40 80 00       	mov    %eax,0x804028


		sys_allocateMem(arr[index].start,size);
  801cc7:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801cca:	89 d0                	mov    %edx,%eax
  801ccc:	01 c0                	add    %eax,%eax
  801cce:	01 d0                	add    %edx,%eax
  801cd0:	c1 e0 02             	shl    $0x2,%eax
  801cd3:	05 20 41 80 00       	add    $0x804120,%eax
  801cd8:	8b 00                	mov    (%eax),%eax
  801cda:	83 ec 08             	sub    $0x8,%esp
  801cdd:	ff 75 08             	pushl  0x8(%ebp)
  801ce0:	50                   	push   %eax
  801ce1:	e8 48 04 00 00       	call   80212e <sys_allocateMem>
  801ce6:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801ce9:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801cf0:	eb 78                	jmp    801d6a <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801cf2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801cf5:	89 d0                	mov    %edx,%eax
  801cf7:	01 c0                	add    %eax,%eax
  801cf9:	01 d0                	add    %edx,%eax
  801cfb:	c1 e0 02             	shl    $0x2,%eax
  801cfe:	05 20 41 80 00       	add    $0x804120,%eax
  801d03:	8b 00                	mov    (%eax),%eax
  801d05:	83 ec 04             	sub    $0x4,%esp
  801d08:	50                   	push   %eax
  801d09:	ff 75 b0             	pushl  -0x50(%ebp)
  801d0c:	68 b0 32 80 00       	push   $0x8032b0
  801d11:	e8 50 ee ff ff       	call   800b66 <cprintf>
  801d16:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801d19:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801d1c:	89 d0                	mov    %edx,%eax
  801d1e:	01 c0                	add    %eax,%eax
  801d20:	01 d0                	add    %edx,%eax
  801d22:	c1 e0 02             	shl    $0x2,%eax
  801d25:	05 24 41 80 00       	add    $0x804124,%eax
  801d2a:	8b 00                	mov    (%eax),%eax
  801d2c:	83 ec 04             	sub    $0x4,%esp
  801d2f:	50                   	push   %eax
  801d30:	ff 75 b0             	pushl  -0x50(%ebp)
  801d33:	68 c5 32 80 00       	push   $0x8032c5
  801d38:	e8 29 ee ff ff       	call   800b66 <cprintf>
  801d3d:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801d40:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801d43:	89 d0                	mov    %edx,%eax
  801d45:	01 c0                	add    %eax,%eax
  801d47:	01 d0                	add    %edx,%eax
  801d49:	c1 e0 02             	shl    $0x2,%eax
  801d4c:	05 28 41 80 00       	add    $0x804128,%eax
  801d51:	8b 00                	mov    (%eax),%eax
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	50                   	push   %eax
  801d57:	ff 75 b0             	pushl  -0x50(%ebp)
  801d5a:	68 d8 32 80 00       	push   $0x8032d8
  801d5f:	e8 02 ee ff ff       	call   800b66 <cprintf>
  801d64:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801d67:	ff 45 b0             	incl   -0x50(%ebp)
  801d6a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801d6d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d70:	7c 80                	jl     801cf2 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801d72:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801d75:	89 d0                	mov    %edx,%eax
  801d77:	01 c0                	add    %eax,%eax
  801d79:	01 d0                	add    %edx,%eax
  801d7b:	c1 e0 02             	shl    $0x2,%eax
  801d7e:	05 20 41 80 00       	add    $0x804120,%eax
  801d83:	8b 00                	mov    (%eax),%eax
  801d85:	83 ec 08             	sub    $0x8,%esp
  801d88:	50                   	push   %eax
  801d89:	68 ec 32 80 00       	push   $0x8032ec
  801d8e:	e8 d3 ed ff ff       	call   800b66 <cprintf>
  801d93:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801d96:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801d99:	89 d0                	mov    %edx,%eax
  801d9b:	01 c0                	add    %eax,%eax
  801d9d:	01 d0                	add    %edx,%eax
  801d9f:	c1 e0 02             	shl    $0x2,%eax
  801da2:	05 20 41 80 00       	add    $0x804120,%eax
  801da7:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801db1:	8b 45 08             	mov    0x8(%ebp),%eax
  801db4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801db7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801dbe:	eb 4b                	jmp    801e0b <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801dc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc3:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801dca:	89 c2                	mov    %eax,%edx
  801dcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dcf:	39 c2                	cmp    %eax,%edx
  801dd1:	7f 35                	jg     801e08 <free+0x5d>
  801dd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dd6:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801ddd:	89 c2                	mov    %eax,%edx
  801ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801de2:	39 c2                	cmp    %eax,%edx
  801de4:	7e 22                	jle    801e08 <free+0x5d>
				start=arr_add[i].start;
  801de6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de9:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801df0:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801df3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df6:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801dfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801e00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e03:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801e06:	eb 0d                	jmp    801e15 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801e08:	ff 45 ec             	incl   -0x14(%ebp)
  801e0b:	a1 28 40 80 00       	mov    0x804028,%eax
  801e10:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801e13:	7c ab                	jl     801dc0 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e18:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e22:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801e29:	29 c2                	sub    %eax,%edx
  801e2b:	89 d0                	mov    %edx,%eax
  801e2d:	83 ec 08             	sub    $0x8,%esp
  801e30:	50                   	push   %eax
  801e31:	ff 75 f4             	pushl  -0xc(%ebp)
  801e34:	e8 d9 02 00 00       	call   802112 <sys_freeMem>
  801e39:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e42:	eb 2d                	jmp    801e71 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801e44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e47:	40                   	inc    %eax
  801e48:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801e4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e52:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801e59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e5c:	40                   	inc    %eax
  801e5d:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e67:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801e6e:	ff 45 e8             	incl   -0x18(%ebp)
  801e71:	a1 28 40 80 00       	mov    0x804028,%eax
  801e76:	48                   	dec    %eax
  801e77:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e7a:	7f c8                	jg     801e44 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801e7c:	a1 28 40 80 00       	mov    0x804028,%eax
  801e81:	48                   	dec    %eax
  801e82:	a3 28 40 80 00       	mov    %eax,0x804028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801e87:	90                   	nop
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 18             	sub    $0x18,%esp
  801e90:	8b 45 10             	mov    0x10(%ebp),%eax
  801e93:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801e96:	83 ec 04             	sub    $0x4,%esp
  801e99:	68 08 33 80 00       	push   $0x803308
  801e9e:	68 18 01 00 00       	push   $0x118
  801ea3:	68 2b 33 80 00       	push   $0x80332b
  801ea8:	e8 17 ea ff ff       	call   8008c4 <_panic>

00801ead <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801eb3:	83 ec 04             	sub    $0x4,%esp
  801eb6:	68 08 33 80 00       	push   $0x803308
  801ebb:	68 1e 01 00 00       	push   $0x11e
  801ec0:	68 2b 33 80 00       	push   $0x80332b
  801ec5:	e8 fa e9 ff ff       	call   8008c4 <_panic>

00801eca <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ed0:	83 ec 04             	sub    $0x4,%esp
  801ed3:	68 08 33 80 00       	push   $0x803308
  801ed8:	68 24 01 00 00       	push   $0x124
  801edd:	68 2b 33 80 00       	push   $0x80332b
  801ee2:	e8 dd e9 ff ff       	call   8008c4 <_panic>

00801ee7 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801eed:	83 ec 04             	sub    $0x4,%esp
  801ef0:	68 08 33 80 00       	push   $0x803308
  801ef5:	68 29 01 00 00       	push   $0x129
  801efa:	68 2b 33 80 00       	push   $0x80332b
  801eff:	e8 c0 e9 ff ff       	call   8008c4 <_panic>

00801f04 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f0a:	83 ec 04             	sub    $0x4,%esp
  801f0d:	68 08 33 80 00       	push   $0x803308
  801f12:	68 2f 01 00 00       	push   $0x12f
  801f17:	68 2b 33 80 00       	push   $0x80332b
  801f1c:	e8 a3 e9 ff ff       	call   8008c4 <_panic>

00801f21 <shrink>:
}
void shrink(uint32 newSize)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f27:	83 ec 04             	sub    $0x4,%esp
  801f2a:	68 08 33 80 00       	push   $0x803308
  801f2f:	68 33 01 00 00       	push   $0x133
  801f34:	68 2b 33 80 00       	push   $0x80332b
  801f39:	e8 86 e9 ff ff       	call   8008c4 <_panic>

00801f3e <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f44:	83 ec 04             	sub    $0x4,%esp
  801f47:	68 08 33 80 00       	push   $0x803308
  801f4c:	68 38 01 00 00       	push   $0x138
  801f51:	68 2b 33 80 00       	push   $0x80332b
  801f56:	e8 69 e9 ff ff       	call   8008c4 <_panic>

00801f5b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	57                   	push   %edi
  801f5f:	56                   	push   %esi
  801f60:	53                   	push   %ebx
  801f61:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f6d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f70:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f73:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f76:	cd 30                	int    $0x30
  801f78:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f7e:	83 c4 10             	add    $0x10,%esp
  801f81:	5b                   	pop    %ebx
  801f82:	5e                   	pop    %esi
  801f83:	5f                   	pop    %edi
  801f84:	5d                   	pop    %ebp
  801f85:	c3                   	ret    

00801f86 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 04             	sub    $0x4,%esp
  801f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f92:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	52                   	push   %edx
  801f9e:	ff 75 0c             	pushl  0xc(%ebp)
  801fa1:	50                   	push   %eax
  801fa2:	6a 00                	push   $0x0
  801fa4:	e8 b2 ff ff ff       	call   801f5b <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	90                   	nop
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_cgetc>:

int
sys_cgetc(void)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 01                	push   $0x1
  801fbe:	e8 98 ff ff ff       	call   801f5b <syscall>
  801fc3:	83 c4 18             	add    $0x18,%esp
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	50                   	push   %eax
  801fd7:	6a 05                	push   $0x5
  801fd9:	e8 7d ff ff ff       	call   801f5b <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 02                	push   $0x2
  801ff2:	e8 64 ff ff ff       	call   801f5b <syscall>
  801ff7:	83 c4 18             	add    $0x18,%esp
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 03                	push   $0x3
  80200b:	e8 4b ff ff ff       	call   801f5b <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 04                	push   $0x4
  802024:	e8 32 ff ff ff       	call   801f5b <syscall>
  802029:	83 c4 18             	add    $0x18,%esp
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <sys_env_exit>:


void sys_env_exit(void)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 06                	push   $0x6
  80203d:	e8 19 ff ff ff       	call   801f5b <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	90                   	nop
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80204b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	52                   	push   %edx
  802058:	50                   	push   %eax
  802059:	6a 07                	push   $0x7
  80205b:	e8 fb fe ff ff       	call   801f5b <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	56                   	push   %esi
  802069:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80206a:	8b 75 18             	mov    0x18(%ebp),%esi
  80206d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802070:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802073:	8b 55 0c             	mov    0xc(%ebp),%edx
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	56                   	push   %esi
  80207a:	53                   	push   %ebx
  80207b:	51                   	push   %ecx
  80207c:	52                   	push   %edx
  80207d:	50                   	push   %eax
  80207e:	6a 08                	push   $0x8
  802080:	e8 d6 fe ff ff       	call   801f5b <syscall>
  802085:	83 c4 18             	add    $0x18,%esp
}
  802088:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80208b:	5b                   	pop    %ebx
  80208c:	5e                   	pop    %esi
  80208d:	5d                   	pop    %ebp
  80208e:	c3                   	ret    

0080208f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802092:	8b 55 0c             	mov    0xc(%ebp),%edx
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	52                   	push   %edx
  80209f:	50                   	push   %eax
  8020a0:	6a 09                	push   $0x9
  8020a2:	e8 b4 fe ff ff       	call   801f5b <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
}
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	ff 75 0c             	pushl  0xc(%ebp)
  8020b8:	ff 75 08             	pushl  0x8(%ebp)
  8020bb:	6a 0a                	push   $0xa
  8020bd:	e8 99 fe ff ff       	call   801f5b <syscall>
  8020c2:	83 c4 18             	add    $0x18,%esp
}
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 0b                	push   $0xb
  8020d6:	e8 80 fe ff ff       	call   801f5b <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 0c                	push   $0xc
  8020ef:	e8 67 fe ff ff       	call   801f5b <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 0d                	push   $0xd
  802108:	e8 4e fe ff ff       	call   801f5b <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	ff 75 0c             	pushl  0xc(%ebp)
  80211e:	ff 75 08             	pushl  0x8(%ebp)
  802121:	6a 11                	push   $0x11
  802123:	e8 33 fe ff ff       	call   801f5b <syscall>
  802128:	83 c4 18             	add    $0x18,%esp
	return;
  80212b:	90                   	nop
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	ff 75 0c             	pushl  0xc(%ebp)
  80213a:	ff 75 08             	pushl  0x8(%ebp)
  80213d:	6a 12                	push   $0x12
  80213f:	e8 17 fe ff ff       	call   801f5b <syscall>
  802144:	83 c4 18             	add    $0x18,%esp
	return ;
  802147:	90                   	nop
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 0e                	push   $0xe
  802159:	e8 fd fd ff ff       	call   801f5b <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
}
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	ff 75 08             	pushl  0x8(%ebp)
  802171:	6a 0f                	push   $0xf
  802173:	e8 e3 fd ff ff       	call   801f5b <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
}
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 10                	push   $0x10
  80218c:	e8 ca fd ff ff       	call   801f5b <syscall>
  802191:	83 c4 18             	add    $0x18,%esp
}
  802194:	90                   	nop
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 14                	push   $0x14
  8021a6:	e8 b0 fd ff ff       	call   801f5b <syscall>
  8021ab:	83 c4 18             	add    $0x18,%esp
}
  8021ae:	90                   	nop
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 15                	push   $0x15
  8021c0:	e8 96 fd ff ff       	call   801f5b <syscall>
  8021c5:	83 c4 18             	add    $0x18,%esp
}
  8021c8:	90                   	nop
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <sys_cputc>:


void
sys_cputc(const char c)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 04             	sub    $0x4,%esp
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021d7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	50                   	push   %eax
  8021e4:	6a 16                	push   $0x16
  8021e6:	e8 70 fd ff ff       	call   801f5b <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
}
  8021ee:	90                   	nop
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 17                	push   $0x17
  802200:	e8 56 fd ff ff       	call   801f5b <syscall>
  802205:	83 c4 18             	add    $0x18,%esp
}
  802208:	90                   	nop
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	ff 75 0c             	pushl  0xc(%ebp)
  80221a:	50                   	push   %eax
  80221b:	6a 18                	push   $0x18
  80221d:	e8 39 fd ff ff       	call   801f5b <syscall>
  802222:	83 c4 18             	add    $0x18,%esp
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80222a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	52                   	push   %edx
  802237:	50                   	push   %eax
  802238:	6a 1b                	push   $0x1b
  80223a:	e8 1c fd ff ff       	call   801f5b <syscall>
  80223f:	83 c4 18             	add    $0x18,%esp
}
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	52                   	push   %edx
  802254:	50                   	push   %eax
  802255:	6a 19                	push   $0x19
  802257:	e8 ff fc ff ff       	call   801f5b <syscall>
  80225c:	83 c4 18             	add    $0x18,%esp
}
  80225f:	90                   	nop
  802260:	c9                   	leave  
  802261:	c3                   	ret    

00802262 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802265:	8b 55 0c             	mov    0xc(%ebp),%edx
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	52                   	push   %edx
  802272:	50                   	push   %eax
  802273:	6a 1a                	push   $0x1a
  802275:	e8 e1 fc ff ff       	call   801f5b <syscall>
  80227a:	83 c4 18             	add    $0x18,%esp
}
  80227d:	90                   	nop
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	83 ec 04             	sub    $0x4,%esp
  802286:	8b 45 10             	mov    0x10(%ebp),%eax
  802289:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80228c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80228f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	6a 00                	push   $0x0
  802298:	51                   	push   %ecx
  802299:	52                   	push   %edx
  80229a:	ff 75 0c             	pushl  0xc(%ebp)
  80229d:	50                   	push   %eax
  80229e:	6a 1c                	push   $0x1c
  8022a0:	e8 b6 fc ff ff       	call   801f5b <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8022ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	52                   	push   %edx
  8022ba:	50                   	push   %eax
  8022bb:	6a 1d                	push   $0x1d
  8022bd:	e8 99 fc ff ff       	call   801f5b <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8022ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	51                   	push   %ecx
  8022d8:	52                   	push   %edx
  8022d9:	50                   	push   %eax
  8022da:	6a 1e                	push   $0x1e
  8022dc:	e8 7a fc ff ff       	call   801f5b <syscall>
  8022e1:	83 c4 18             	add    $0x18,%esp
}
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8022e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	52                   	push   %edx
  8022f6:	50                   	push   %eax
  8022f7:	6a 1f                	push   $0x1f
  8022f9:	e8 5d fc ff ff       	call   801f5b <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
}
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 20                	push   $0x20
  802312:	e8 44 fc ff ff       	call   801f5b <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	6a 00                	push   $0x0
  802324:	ff 75 14             	pushl  0x14(%ebp)
  802327:	ff 75 10             	pushl  0x10(%ebp)
  80232a:	ff 75 0c             	pushl  0xc(%ebp)
  80232d:	50                   	push   %eax
  80232e:	6a 21                	push   $0x21
  802330:	e8 26 fc ff ff       	call   801f5b <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
}
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80233d:	8b 45 08             	mov    0x8(%ebp),%eax
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	50                   	push   %eax
  802349:	6a 22                	push   $0x22
  80234b:	e8 0b fc ff ff       	call   801f5b <syscall>
  802350:	83 c4 18             	add    $0x18,%esp
}
  802353:	90                   	nop
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	50                   	push   %eax
  802365:	6a 23                	push   $0x23
  802367:	e8 ef fb ff ff       	call   801f5b <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
}
  80236f:	90                   	nop
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
  802375:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802378:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80237b:	8d 50 04             	lea    0x4(%eax),%edx
  80237e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	52                   	push   %edx
  802388:	50                   	push   %eax
  802389:	6a 24                	push   $0x24
  80238b:	e8 cb fb ff ff       	call   801f5b <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
	return result;
  802393:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802396:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802399:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80239c:	89 01                	mov    %eax,(%ecx)
  80239e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	c9                   	leave  
  8023a5:	c2 04 00             	ret    $0x4

008023a8 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	ff 75 10             	pushl  0x10(%ebp)
  8023b2:	ff 75 0c             	pushl  0xc(%ebp)
  8023b5:	ff 75 08             	pushl  0x8(%ebp)
  8023b8:	6a 13                	push   $0x13
  8023ba:	e8 9c fb ff ff       	call   801f5b <syscall>
  8023bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c2:	90                   	nop
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 25                	push   $0x25
  8023d4:	e8 82 fb ff ff       	call   801f5b <syscall>
  8023d9:	83 c4 18             	add    $0x18,%esp
}
  8023dc:	c9                   	leave  
  8023dd:	c3                   	ret    

008023de <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
  8023e1:	83 ec 04             	sub    $0x4,%esp
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023ea:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	50                   	push   %eax
  8023f7:	6a 26                	push   $0x26
  8023f9:	e8 5d fb ff ff       	call   801f5b <syscall>
  8023fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802401:	90                   	nop
}
  802402:	c9                   	leave  
  802403:	c3                   	ret    

00802404 <rsttst>:
void rsttst()
{
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 28                	push   $0x28
  802413:	e8 43 fb ff ff       	call   801f5b <syscall>
  802418:	83 c4 18             	add    $0x18,%esp
	return ;
  80241b:	90                   	nop
}
  80241c:	c9                   	leave  
  80241d:	c3                   	ret    

0080241e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	83 ec 04             	sub    $0x4,%esp
  802424:	8b 45 14             	mov    0x14(%ebp),%eax
  802427:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80242a:	8b 55 18             	mov    0x18(%ebp),%edx
  80242d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802431:	52                   	push   %edx
  802432:	50                   	push   %eax
  802433:	ff 75 10             	pushl  0x10(%ebp)
  802436:	ff 75 0c             	pushl  0xc(%ebp)
  802439:	ff 75 08             	pushl  0x8(%ebp)
  80243c:	6a 27                	push   $0x27
  80243e:	e8 18 fb ff ff       	call   801f5b <syscall>
  802443:	83 c4 18             	add    $0x18,%esp
	return ;
  802446:	90                   	nop
}
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <chktst>:
void chktst(uint32 n)
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	ff 75 08             	pushl  0x8(%ebp)
  802457:	6a 29                	push   $0x29
  802459:	e8 fd fa ff ff       	call   801f5b <syscall>
  80245e:	83 c4 18             	add    $0x18,%esp
	return ;
  802461:	90                   	nop
}
  802462:	c9                   	leave  
  802463:	c3                   	ret    

00802464 <inctst>:

void inctst()
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 2a                	push   $0x2a
  802473:	e8 e3 fa ff ff       	call   801f5b <syscall>
  802478:	83 c4 18             	add    $0x18,%esp
	return ;
  80247b:	90                   	nop
}
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <gettst>:
uint32 gettst()
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 2b                	push   $0x2b
  80248d:	e8 c9 fa ff ff       	call   801f5b <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 2c                	push   $0x2c
  8024a9:	e8 ad fa ff ff       	call   801f5b <syscall>
  8024ae:	83 c4 18             	add    $0x18,%esp
  8024b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024b4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024b8:	75 07                	jne    8024c1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8024bf:	eb 05                	jmp    8024c6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c6:	c9                   	leave  
  8024c7:	c3                   	ret    

008024c8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
  8024cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 2c                	push   $0x2c
  8024da:	e8 7c fa ff ff       	call   801f5b <syscall>
  8024df:	83 c4 18             	add    $0x18,%esp
  8024e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024e5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024e9:	75 07                	jne    8024f2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f0:	eb 05                	jmp    8024f7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 2c                	push   $0x2c
  80250b:	e8 4b fa ff ff       	call   801f5b <syscall>
  802510:	83 c4 18             	add    $0x18,%esp
  802513:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802516:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80251a:	75 07                	jne    802523 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80251c:	b8 01 00 00 00       	mov    $0x1,%eax
  802521:	eb 05                	jmp    802528 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
  80252d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 2c                	push   $0x2c
  80253c:	e8 1a fa ff ff       	call   801f5b <syscall>
  802541:	83 c4 18             	add    $0x18,%esp
  802544:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802547:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80254b:	75 07                	jne    802554 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80254d:	b8 01 00 00 00       	mov    $0x1,%eax
  802552:	eb 05                	jmp    802559 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802554:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802559:	c9                   	leave  
  80255a:	c3                   	ret    

0080255b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	ff 75 08             	pushl  0x8(%ebp)
  802569:	6a 2d                	push   $0x2d
  80256b:	e8 eb f9 ff ff       	call   801f5b <syscall>
  802570:	83 c4 18             	add    $0x18,%esp
	return ;
  802573:	90                   	nop
}
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
  802579:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80257a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80257d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802580:	8b 55 0c             	mov    0xc(%ebp),%edx
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	6a 00                	push   $0x0
  802588:	53                   	push   %ebx
  802589:	51                   	push   %ecx
  80258a:	52                   	push   %edx
  80258b:	50                   	push   %eax
  80258c:	6a 2e                	push   $0x2e
  80258e:	e8 c8 f9 ff ff       	call   801f5b <syscall>
  802593:	83 c4 18             	add    $0x18,%esp
}
  802596:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802599:	c9                   	leave  
  80259a:	c3                   	ret    

0080259b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80259e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	52                   	push   %edx
  8025ab:	50                   	push   %eax
  8025ac:	6a 2f                	push   $0x2f
  8025ae:	e8 a8 f9 ff ff       	call   801f5b <syscall>
  8025b3:	83 c4 18             	add    $0x18,%esp
}
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <__udivdi3>:
  8025b8:	55                   	push   %ebp
  8025b9:	57                   	push   %edi
  8025ba:	56                   	push   %esi
  8025bb:	53                   	push   %ebx
  8025bc:	83 ec 1c             	sub    $0x1c,%esp
  8025bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8025c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8025c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025cf:	89 ca                	mov    %ecx,%edx
  8025d1:	89 f8                	mov    %edi,%eax
  8025d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8025d7:	85 f6                	test   %esi,%esi
  8025d9:	75 2d                	jne    802608 <__udivdi3+0x50>
  8025db:	39 cf                	cmp    %ecx,%edi
  8025dd:	77 65                	ja     802644 <__udivdi3+0x8c>
  8025df:	89 fd                	mov    %edi,%ebp
  8025e1:	85 ff                	test   %edi,%edi
  8025e3:	75 0b                	jne    8025f0 <__udivdi3+0x38>
  8025e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ea:	31 d2                	xor    %edx,%edx
  8025ec:	f7 f7                	div    %edi
  8025ee:	89 c5                	mov    %eax,%ebp
  8025f0:	31 d2                	xor    %edx,%edx
  8025f2:	89 c8                	mov    %ecx,%eax
  8025f4:	f7 f5                	div    %ebp
  8025f6:	89 c1                	mov    %eax,%ecx
  8025f8:	89 d8                	mov    %ebx,%eax
  8025fa:	f7 f5                	div    %ebp
  8025fc:	89 cf                	mov    %ecx,%edi
  8025fe:	89 fa                	mov    %edi,%edx
  802600:	83 c4 1c             	add    $0x1c,%esp
  802603:	5b                   	pop    %ebx
  802604:	5e                   	pop    %esi
  802605:	5f                   	pop    %edi
  802606:	5d                   	pop    %ebp
  802607:	c3                   	ret    
  802608:	39 ce                	cmp    %ecx,%esi
  80260a:	77 28                	ja     802634 <__udivdi3+0x7c>
  80260c:	0f bd fe             	bsr    %esi,%edi
  80260f:	83 f7 1f             	xor    $0x1f,%edi
  802612:	75 40                	jne    802654 <__udivdi3+0x9c>
  802614:	39 ce                	cmp    %ecx,%esi
  802616:	72 0a                	jb     802622 <__udivdi3+0x6a>
  802618:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80261c:	0f 87 9e 00 00 00    	ja     8026c0 <__udivdi3+0x108>
  802622:	b8 01 00 00 00       	mov    $0x1,%eax
  802627:	89 fa                	mov    %edi,%edx
  802629:	83 c4 1c             	add    $0x1c,%esp
  80262c:	5b                   	pop    %ebx
  80262d:	5e                   	pop    %esi
  80262e:	5f                   	pop    %edi
  80262f:	5d                   	pop    %ebp
  802630:	c3                   	ret    
  802631:	8d 76 00             	lea    0x0(%esi),%esi
  802634:	31 ff                	xor    %edi,%edi
  802636:	31 c0                	xor    %eax,%eax
  802638:	89 fa                	mov    %edi,%edx
  80263a:	83 c4 1c             	add    $0x1c,%esp
  80263d:	5b                   	pop    %ebx
  80263e:	5e                   	pop    %esi
  80263f:	5f                   	pop    %edi
  802640:	5d                   	pop    %ebp
  802641:	c3                   	ret    
  802642:	66 90                	xchg   %ax,%ax
  802644:	89 d8                	mov    %ebx,%eax
  802646:	f7 f7                	div    %edi
  802648:	31 ff                	xor    %edi,%edi
  80264a:	89 fa                	mov    %edi,%edx
  80264c:	83 c4 1c             	add    $0x1c,%esp
  80264f:	5b                   	pop    %ebx
  802650:	5e                   	pop    %esi
  802651:	5f                   	pop    %edi
  802652:	5d                   	pop    %ebp
  802653:	c3                   	ret    
  802654:	bd 20 00 00 00       	mov    $0x20,%ebp
  802659:	89 eb                	mov    %ebp,%ebx
  80265b:	29 fb                	sub    %edi,%ebx
  80265d:	89 f9                	mov    %edi,%ecx
  80265f:	d3 e6                	shl    %cl,%esi
  802661:	89 c5                	mov    %eax,%ebp
  802663:	88 d9                	mov    %bl,%cl
  802665:	d3 ed                	shr    %cl,%ebp
  802667:	89 e9                	mov    %ebp,%ecx
  802669:	09 f1                	or     %esi,%ecx
  80266b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80266f:	89 f9                	mov    %edi,%ecx
  802671:	d3 e0                	shl    %cl,%eax
  802673:	89 c5                	mov    %eax,%ebp
  802675:	89 d6                	mov    %edx,%esi
  802677:	88 d9                	mov    %bl,%cl
  802679:	d3 ee                	shr    %cl,%esi
  80267b:	89 f9                	mov    %edi,%ecx
  80267d:	d3 e2                	shl    %cl,%edx
  80267f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802683:	88 d9                	mov    %bl,%cl
  802685:	d3 e8                	shr    %cl,%eax
  802687:	09 c2                	or     %eax,%edx
  802689:	89 d0                	mov    %edx,%eax
  80268b:	89 f2                	mov    %esi,%edx
  80268d:	f7 74 24 0c          	divl   0xc(%esp)
  802691:	89 d6                	mov    %edx,%esi
  802693:	89 c3                	mov    %eax,%ebx
  802695:	f7 e5                	mul    %ebp
  802697:	39 d6                	cmp    %edx,%esi
  802699:	72 19                	jb     8026b4 <__udivdi3+0xfc>
  80269b:	74 0b                	je     8026a8 <__udivdi3+0xf0>
  80269d:	89 d8                	mov    %ebx,%eax
  80269f:	31 ff                	xor    %edi,%edi
  8026a1:	e9 58 ff ff ff       	jmp    8025fe <__udivdi3+0x46>
  8026a6:	66 90                	xchg   %ax,%ax
  8026a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8026ac:	89 f9                	mov    %edi,%ecx
  8026ae:	d3 e2                	shl    %cl,%edx
  8026b0:	39 c2                	cmp    %eax,%edx
  8026b2:	73 e9                	jae    80269d <__udivdi3+0xe5>
  8026b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026b7:	31 ff                	xor    %edi,%edi
  8026b9:	e9 40 ff ff ff       	jmp    8025fe <__udivdi3+0x46>
  8026be:	66 90                	xchg   %ax,%ax
  8026c0:	31 c0                	xor    %eax,%eax
  8026c2:	e9 37 ff ff ff       	jmp    8025fe <__udivdi3+0x46>
  8026c7:	90                   	nop

008026c8 <__umoddi3>:
  8026c8:	55                   	push   %ebp
  8026c9:	57                   	push   %edi
  8026ca:	56                   	push   %esi
  8026cb:	53                   	push   %ebx
  8026cc:	83 ec 1c             	sub    $0x1c,%esp
  8026cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8026d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8026d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8026df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026e7:	89 f3                	mov    %esi,%ebx
  8026e9:	89 fa                	mov    %edi,%edx
  8026eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8026ef:	89 34 24             	mov    %esi,(%esp)
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	75 1a                	jne    802710 <__umoddi3+0x48>
  8026f6:	39 f7                	cmp    %esi,%edi
  8026f8:	0f 86 a2 00 00 00    	jbe    8027a0 <__umoddi3+0xd8>
  8026fe:	89 c8                	mov    %ecx,%eax
  802700:	89 f2                	mov    %esi,%edx
  802702:	f7 f7                	div    %edi
  802704:	89 d0                	mov    %edx,%eax
  802706:	31 d2                	xor    %edx,%edx
  802708:	83 c4 1c             	add    $0x1c,%esp
  80270b:	5b                   	pop    %ebx
  80270c:	5e                   	pop    %esi
  80270d:	5f                   	pop    %edi
  80270e:	5d                   	pop    %ebp
  80270f:	c3                   	ret    
  802710:	39 f0                	cmp    %esi,%eax
  802712:	0f 87 ac 00 00 00    	ja     8027c4 <__umoddi3+0xfc>
  802718:	0f bd e8             	bsr    %eax,%ebp
  80271b:	83 f5 1f             	xor    $0x1f,%ebp
  80271e:	0f 84 ac 00 00 00    	je     8027d0 <__umoddi3+0x108>
  802724:	bf 20 00 00 00       	mov    $0x20,%edi
  802729:	29 ef                	sub    %ebp,%edi
  80272b:	89 fe                	mov    %edi,%esi
  80272d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802731:	89 e9                	mov    %ebp,%ecx
  802733:	d3 e0                	shl    %cl,%eax
  802735:	89 d7                	mov    %edx,%edi
  802737:	89 f1                	mov    %esi,%ecx
  802739:	d3 ef                	shr    %cl,%edi
  80273b:	09 c7                	or     %eax,%edi
  80273d:	89 e9                	mov    %ebp,%ecx
  80273f:	d3 e2                	shl    %cl,%edx
  802741:	89 14 24             	mov    %edx,(%esp)
  802744:	89 d8                	mov    %ebx,%eax
  802746:	d3 e0                	shl    %cl,%eax
  802748:	89 c2                	mov    %eax,%edx
  80274a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80274e:	d3 e0                	shl    %cl,%eax
  802750:	89 44 24 04          	mov    %eax,0x4(%esp)
  802754:	8b 44 24 08          	mov    0x8(%esp),%eax
  802758:	89 f1                	mov    %esi,%ecx
  80275a:	d3 e8                	shr    %cl,%eax
  80275c:	09 d0                	or     %edx,%eax
  80275e:	d3 eb                	shr    %cl,%ebx
  802760:	89 da                	mov    %ebx,%edx
  802762:	f7 f7                	div    %edi
  802764:	89 d3                	mov    %edx,%ebx
  802766:	f7 24 24             	mull   (%esp)
  802769:	89 c6                	mov    %eax,%esi
  80276b:	89 d1                	mov    %edx,%ecx
  80276d:	39 d3                	cmp    %edx,%ebx
  80276f:	0f 82 87 00 00 00    	jb     8027fc <__umoddi3+0x134>
  802775:	0f 84 91 00 00 00    	je     80280c <__umoddi3+0x144>
  80277b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80277f:	29 f2                	sub    %esi,%edx
  802781:	19 cb                	sbb    %ecx,%ebx
  802783:	89 d8                	mov    %ebx,%eax
  802785:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802789:	d3 e0                	shl    %cl,%eax
  80278b:	89 e9                	mov    %ebp,%ecx
  80278d:	d3 ea                	shr    %cl,%edx
  80278f:	09 d0                	or     %edx,%eax
  802791:	89 e9                	mov    %ebp,%ecx
  802793:	d3 eb                	shr    %cl,%ebx
  802795:	89 da                	mov    %ebx,%edx
  802797:	83 c4 1c             	add    $0x1c,%esp
  80279a:	5b                   	pop    %ebx
  80279b:	5e                   	pop    %esi
  80279c:	5f                   	pop    %edi
  80279d:	5d                   	pop    %ebp
  80279e:	c3                   	ret    
  80279f:	90                   	nop
  8027a0:	89 fd                	mov    %edi,%ebp
  8027a2:	85 ff                	test   %edi,%edi
  8027a4:	75 0b                	jne    8027b1 <__umoddi3+0xe9>
  8027a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ab:	31 d2                	xor    %edx,%edx
  8027ad:	f7 f7                	div    %edi
  8027af:	89 c5                	mov    %eax,%ebp
  8027b1:	89 f0                	mov    %esi,%eax
  8027b3:	31 d2                	xor    %edx,%edx
  8027b5:	f7 f5                	div    %ebp
  8027b7:	89 c8                	mov    %ecx,%eax
  8027b9:	f7 f5                	div    %ebp
  8027bb:	89 d0                	mov    %edx,%eax
  8027bd:	e9 44 ff ff ff       	jmp    802706 <__umoddi3+0x3e>
  8027c2:	66 90                	xchg   %ax,%ax
  8027c4:	89 c8                	mov    %ecx,%eax
  8027c6:	89 f2                	mov    %esi,%edx
  8027c8:	83 c4 1c             	add    $0x1c,%esp
  8027cb:	5b                   	pop    %ebx
  8027cc:	5e                   	pop    %esi
  8027cd:	5f                   	pop    %edi
  8027ce:	5d                   	pop    %ebp
  8027cf:	c3                   	ret    
  8027d0:	3b 04 24             	cmp    (%esp),%eax
  8027d3:	72 06                	jb     8027db <__umoddi3+0x113>
  8027d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8027d9:	77 0f                	ja     8027ea <__umoddi3+0x122>
  8027db:	89 f2                	mov    %esi,%edx
  8027dd:	29 f9                	sub    %edi,%ecx
  8027df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8027e3:	89 14 24             	mov    %edx,(%esp)
  8027e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8027ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027ee:	8b 14 24             	mov    (%esp),%edx
  8027f1:	83 c4 1c             	add    $0x1c,%esp
  8027f4:	5b                   	pop    %ebx
  8027f5:	5e                   	pop    %esi
  8027f6:	5f                   	pop    %edi
  8027f7:	5d                   	pop    %ebp
  8027f8:	c3                   	ret    
  8027f9:	8d 76 00             	lea    0x0(%esi),%esi
  8027fc:	2b 04 24             	sub    (%esp),%eax
  8027ff:	19 fa                	sbb    %edi,%edx
  802801:	89 d1                	mov    %edx,%ecx
  802803:	89 c6                	mov    %eax,%esi
  802805:	e9 71 ff ff ff       	jmp    80277b <__umoddi3+0xb3>
  80280a:	66 90                	xchg   %ax,%ax
  80280c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802810:	72 ea                	jb     8027fc <__umoddi3+0x134>
  802812:	89 d9                	mov    %ebx,%ecx
  802814:	e9 62 ff ff ff       	jmp    80277b <__umoddi3+0xb3>
