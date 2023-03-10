
obj/user/tst_mod_7:     file format elf32-i386


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
  800031:	e8 08 0a 00 00       	call   800a3e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

#include <inc/lib.h>
extern void freeHeap();

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 74             	sub    $0x74,%esp
	int envID = sys_getenvid();
  80003f:	e8 5e 22 00 00       	call   8022a2 <sys_getenvid>
  800044:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//	cprintf("envID = %d\n",envID);

	int kilo = 1024;
  800047:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	int Mega = 1024*1024;
  80004e:	c7 45 e0 00 00 10 00 	movl   $0x100000,-0x20(%ebp)
	int freeFrames, origFreeFrames, usedDiskPages, origDiskPages;
	uint32 size ;
	/// testing freeHeap()
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800055:	e8 2c 23 00 00       	call   802386 <sys_calculate_free_frames>
  80005a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		origFreeFrames = freeFrames ;
  80005d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800060:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800063:	e8 a1 23 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  800068:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		origDiskPages = usedDiskPages ;
  80006b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80006e:	89 45 d0             	mov    %eax,-0x30(%ebp)

		size = 1*Mega;
  800071:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800074:	89 45 cc             	mov    %eax,-0x34(%ebp)
		unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800077:	83 ec 0c             	sub    $0xc,%esp
  80007a:	ff 75 cc             	pushl  -0x34(%ebp)
  80007d:	e8 2d 1b 00 00       	call   801baf <malloc>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 c8             	mov    %eax,-0x38(%ebp)

		assert((uint32) x == USER_HEAP_START);
  800088:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80008b:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800090:	74 16                	je     8000a8 <_main+0x70>
  800092:	68 e0 2a 80 00       	push   $0x802ae0
  800097:	68 fe 2a 80 00       	push   $0x802afe
  80009c:	6a 1c                	push   $0x1c
  80009e:	68 13 2b 80 00       	push   $0x802b13
  8000a3:	e8 db 0a 00 00       	call   800b83 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == 1);
  8000a8:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8000ab:	e8 d6 22 00 00       	call   802386 <sys_calculate_free_frames>
  8000b0:	29 c3                	sub    %eax,%ebx
  8000b2:	89 d8                	mov    %ebx,%eax
  8000b4:	83 f8 01             	cmp    $0x1,%eax
  8000b7:	74 16                	je     8000cf <_main+0x97>
  8000b9:	68 24 2b 80 00       	push   $0x802b24
  8000be:	68 fe 2a 80 00       	push   $0x802afe
  8000c3:	6a 1d                	push   $0x1d
  8000c5:	68 13 2b 80 00       	push   $0x802b13
  8000ca:	e8 b4 0a 00 00       	call   800b83 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1*Mega/PAGE_SIZE);
  8000cf:	e8 35 23 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  8000d4:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8000d7:	89 c2                	mov    %eax,%edx
  8000d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	79 05                	jns    8000e5 <_main+0xad>
  8000e0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8000e5:	c1 f8 0c             	sar    $0xc,%eax
  8000e8:	39 c2                	cmp    %eax,%edx
  8000ea:	74 16                	je     800102 <_main+0xca>
  8000ec:	68 54 2b 80 00       	push   $0x802b54
  8000f1:	68 fe 2a 80 00       	push   $0x802afe
  8000f6:	6a 1e                	push   $0x1e
  8000f8:	68 13 2b 80 00       	push   $0x802b13
  8000fd:	e8 81 0a 00 00       	call   800b83 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 7f 22 00 00       	call   802386 <sys_calculate_free_frames>
  800107:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 fa 22 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  80010f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		size = 1*Mega;
  800112:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800115:	89 45 cc             	mov    %eax,-0x34(%ebp)
		unsigned char *t1 = malloc(sizeof(unsigned char)*size) ;
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	ff 75 cc             	pushl  -0x34(%ebp)
  80011e:	e8 8c 1a 00 00       	call   801baf <malloc>
  800123:	83 c4 10             	add    $0x10,%esp
  800126:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		assert((uint32) t1 == USER_HEAP_START + 1*Mega);
  800129:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012c:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800132:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800135:	39 c2                	cmp    %eax,%edx
  800137:	74 16                	je     80014f <_main+0x117>
  800139:	68 a0 2b 80 00       	push   $0x802ba0
  80013e:	68 fe 2a 80 00       	push   $0x802afe
  800143:	6a 27                	push   $0x27
  800145:	68 13 2b 80 00       	push   $0x802b13
  80014a:	e8 34 0a 00 00       	call   800b83 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == 0);
  80014f:	e8 32 22 00 00       	call   802386 <sys_calculate_free_frames>
  800154:	89 c2                	mov    %eax,%edx
  800156:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800159:	39 c2                	cmp    %eax,%edx
  80015b:	74 16                	je     800173 <_main+0x13b>
  80015d:	68 c8 2b 80 00       	push   $0x802bc8
  800162:	68 fe 2a 80 00       	push   $0x802afe
  800167:	6a 28                	push   $0x28
  800169:	68 13 2b 80 00       	push   $0x802b13
  80016e:	e8 10 0a 00 00       	call   800b83 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1*Mega/PAGE_SIZE);
  800173:	e8 91 22 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  800178:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80017b:	89 c2                	mov    %eax,%edx
  80017d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800180:	85 c0                	test   %eax,%eax
  800182:	79 05                	jns    800189 <_main+0x151>
  800184:	05 ff 0f 00 00       	add    $0xfff,%eax
  800189:	c1 f8 0c             	sar    $0xc,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	74 16                	je     8001a6 <_main+0x16e>
  800190:	68 54 2b 80 00       	push   $0x802b54
  800195:	68 fe 2a 80 00       	push   $0x802afe
  80019a:	6a 29                	push   $0x29
  80019c:	68 13 2b 80 00       	push   $0x802b13
  8001a1:	e8 dd 09 00 00       	call   800b83 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8001a6:	e8 db 21 00 00       	call   802386 <sys_calculate_free_frames>
  8001ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001ae:	e8 56 22 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  8001b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		size = 2*Mega;
  8001b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b9:	01 c0                	add    %eax,%eax
  8001bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		unsigned char *t2 = malloc(sizeof(unsigned char)*size) ;
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	ff 75 cc             	pushl  -0x34(%ebp)
  8001c4:	e8 e6 19 00 00       	call   801baf <malloc>
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	89 45 c0             	mov    %eax,-0x40(%ebp)

		assert((uint32) t2 == USER_HEAP_START + 2*Mega);
  8001cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d2:	01 c0                	add    %eax,%eax
  8001d4:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8001da:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001dd:	39 c2                	cmp    %eax,%edx
  8001df:	74 16                	je     8001f7 <_main+0x1bf>
  8001e1:	68 f8 2b 80 00       	push   $0x802bf8
  8001e6:	68 fe 2a 80 00       	push   $0x802afe
  8001eb:	6a 32                	push   $0x32
  8001ed:	68 13 2b 80 00       	push   $0x802b13
  8001f2:	e8 8c 09 00 00       	call   800b83 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == 0);
  8001f7:	e8 8a 21 00 00       	call   802386 <sys_calculate_free_frames>
  8001fc:	89 c2                	mov    %eax,%edx
  8001fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800201:	39 c2                	cmp    %eax,%edx
  800203:	74 16                	je     80021b <_main+0x1e3>
  800205:	68 c8 2b 80 00       	push   $0x802bc8
  80020a:	68 fe 2a 80 00       	push   $0x802afe
  80020f:	6a 33                	push   $0x33
  800211:	68 13 2b 80 00       	push   $0x802b13
  800216:	e8 68 09 00 00       	call   800b83 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 2*Mega/PAGE_SIZE);
  80021b:	e8 e9 21 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  800220:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800223:	89 c2                	mov    %eax,%edx
  800225:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800228:	01 c0                	add    %eax,%eax
  80022a:	85 c0                	test   %eax,%eax
  80022c:	79 05                	jns    800233 <_main+0x1fb>
  80022e:	05 ff 0f 00 00       	add    $0xfff,%eax
  800233:	c1 f8 0c             	sar    $0xc,%eax
  800236:	39 c2                	cmp    %eax,%edx
  800238:	74 16                	je     800250 <_main+0x218>
  80023a:	68 20 2c 80 00       	push   $0x802c20
  80023f:	68 fe 2a 80 00       	push   $0x802afe
  800244:	6a 34                	push   $0x34
  800246:	68 13 2b 80 00       	push   $0x802b13
  80024b:	e8 33 09 00 00       	call   800b83 <_panic>

		//Allocate 4 MB
		freeFrames = sys_calculate_free_frames() ;
  800250:	e8 31 21 00 00       	call   802386 <sys_calculate_free_frames>
  800255:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800258:	e8 ac 21 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  80025d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		size = 4*Mega;
  800260:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800263:	c1 e0 02             	shl    $0x2,%eax
  800266:	89 45 cc             	mov    %eax,-0x34(%ebp)
		unsigned char *t3 = malloc(sizeof(unsigned char)*size) ;
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	ff 75 cc             	pushl  -0x34(%ebp)
  80026f:	e8 3b 19 00 00       	call   801baf <malloc>
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	89 45 bc             	mov    %eax,-0x44(%ebp)

		assert((uint32) t3 == USER_HEAP_START + 4*Mega);
  80027a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80027d:	c1 e0 02             	shl    $0x2,%eax
  800280:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800286:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800289:	39 c2                	cmp    %eax,%edx
  80028b:	74 16                	je     8002a3 <_main+0x26b>
  80028d:	68 6c 2c 80 00       	push   $0x802c6c
  800292:	68 fe 2a 80 00       	push   $0x802afe
  800297:	6a 3d                	push   $0x3d
  800299:	68 13 2b 80 00       	push   $0x802b13
  80029e:	e8 e0 08 00 00       	call   800b83 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1));
  8002a3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002a6:	e8 db 20 00 00       	call   802386 <sys_calculate_free_frames>
  8002ab:	29 c3                	sub    %eax,%ebx
  8002ad:	89 d8                	mov    %ebx,%eax
  8002af:	83 f8 01             	cmp    $0x1,%eax
  8002b2:	74 16                	je     8002ca <_main+0x292>
  8002b4:	68 94 2c 80 00       	push   $0x802c94
  8002b9:	68 fe 2a 80 00       	push   $0x802afe
  8002be:	6a 3e                	push   $0x3e
  8002c0:	68 13 2b 80 00       	push   $0x802b13
  8002c5:	e8 b9 08 00 00       	call   800b83 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 4*Mega/PAGE_SIZE);
  8002ca:	e8 3a 21 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  8002cf:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8002d2:	89 c2                	mov    %eax,%edx
  8002d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d7:	c1 e0 02             	shl    $0x2,%eax
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	79 05                	jns    8002e3 <_main+0x2ab>
  8002de:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002e3:	c1 f8 0c             	sar    $0xc,%eax
  8002e6:	39 c2                	cmp    %eax,%edx
  8002e8:	74 16                	je     800300 <_main+0x2c8>
  8002ea:	68 c8 2c 80 00       	push   $0x802cc8
  8002ef:	68 fe 2a 80 00       	push   $0x802afe
  8002f4:	6a 3f                	push   $0x3f
  8002f6:	68 13 2b 80 00       	push   $0x802b13
  8002fb:	e8 83 08 00 00       	call   800b83 <_panic>

		//Allocate 4 MB
		freeFrames = sys_calculate_free_frames() ;
  800300:	e8 81 20 00 00       	call   802386 <sys_calculate_free_frames>
  800305:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800308:	e8 fc 20 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  80030d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		size = 4*Mega;
  800310:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800313:	c1 e0 02             	shl    $0x2,%eax
  800316:	89 45 cc             	mov    %eax,-0x34(%ebp)
		unsigned char *t4 = malloc(sizeof(unsigned char)*size) ;
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	ff 75 cc             	pushl  -0x34(%ebp)
  80031f:	e8 8b 18 00 00       	call   801baf <malloc>
  800324:	83 c4 10             	add    $0x10,%esp
  800327:	89 45 b8             	mov    %eax,-0x48(%ebp)

		assert((uint32) t4 == USER_HEAP_START + 8*Mega);
  80032a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032d:	c1 e0 03             	shl    $0x3,%eax
  800330:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800336:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800339:	39 c2                	cmp    %eax,%edx
  80033b:	74 16                	je     800353 <_main+0x31b>
  80033d:	68 14 2d 80 00       	push   $0x802d14
  800342:	68 fe 2a 80 00       	push   $0x802afe
  800347:	6a 48                	push   $0x48
  800349:	68 13 2b 80 00       	push   $0x802b13
  80034e:	e8 30 08 00 00       	call   800b83 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1));
  800353:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800356:	e8 2b 20 00 00       	call   802386 <sys_calculate_free_frames>
  80035b:	29 c3                	sub    %eax,%ebx
  80035d:	89 d8                	mov    %ebx,%eax
  80035f:	83 f8 01             	cmp    $0x1,%eax
  800362:	74 16                	je     80037a <_main+0x342>
  800364:	68 94 2c 80 00       	push   $0x802c94
  800369:	68 fe 2a 80 00       	push   $0x802afe
  80036e:	6a 49                	push   $0x49
  800370:	68 13 2b 80 00       	push   $0x802b13
  800375:	e8 09 08 00 00       	call   800b83 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 4*Mega/PAGE_SIZE);
  80037a:	e8 8a 20 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  80037f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800382:	89 c2                	mov    %eax,%edx
  800384:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800387:	c1 e0 02             	shl    $0x2,%eax
  80038a:	85 c0                	test   %eax,%eax
  80038c:	79 05                	jns    800393 <_main+0x35b>
  80038e:	05 ff 0f 00 00       	add    $0xfff,%eax
  800393:	c1 f8 0c             	sar    $0xc,%eax
  800396:	39 c2                	cmp    %eax,%edx
  800398:	74 16                	je     8003b0 <_main+0x378>
  80039a:	68 c8 2c 80 00       	push   $0x802cc8
  80039f:	68 fe 2a 80 00       	push   $0x802afe
  8003a4:	6a 4a                	push   $0x4a
  8003a6:	68 13 2b 80 00       	push   $0x802b13
  8003ab:	e8 d3 07 00 00       	call   800b83 <_panic>

		//Allocate 2 KB
		freeFrames = sys_calculate_free_frames() ;
  8003b0:	e8 d1 1f 00 00       	call   802386 <sys_calculate_free_frames>
  8003b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003b8:	e8 4c 20 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  8003bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		size = 2*kilo;
  8003c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003c3:	01 c0                	add    %eax,%eax
  8003c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
		unsigned char *y = malloc(sizeof(unsigned char)*size) ;
  8003c8:	83 ec 0c             	sub    $0xc,%esp
  8003cb:	ff 75 cc             	pushl  -0x34(%ebp)
  8003ce:	e8 dc 17 00 00       	call   801baf <malloc>
  8003d3:	83 c4 10             	add    $0x10,%esp
  8003d6:	89 45 b4             	mov    %eax,-0x4c(%ebp)

		assert((uint32) y == USER_HEAP_START + 12*Mega);
  8003d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003dc:	89 d0                	mov    %edx,%eax
  8003de:	01 c0                	add    %eax,%eax
  8003e0:	01 d0                	add    %edx,%eax
  8003e2:	c1 e0 02             	shl    $0x2,%eax
  8003e5:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8003eb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8003ee:	39 c2                	cmp    %eax,%edx
  8003f0:	74 16                	je     800408 <_main+0x3d0>
  8003f2:	68 3c 2d 80 00       	push   $0x802d3c
  8003f7:	68 fe 2a 80 00       	push   $0x802afe
  8003fc:	6a 53                	push   $0x53
  8003fe:	68 13 2b 80 00       	push   $0x802b13
  800403:	e8 7b 07 00 00       	call   800b83 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == 1);
  800408:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80040b:	e8 76 1f 00 00       	call   802386 <sys_calculate_free_frames>
  800410:	29 c3                	sub    %eax,%ebx
  800412:	89 d8                	mov    %ebx,%eax
  800414:	83 f8 01             	cmp    $0x1,%eax
  800417:	74 16                	je     80042f <_main+0x3f7>
  800419:	68 24 2b 80 00       	push   $0x802b24
  80041e:	68 fe 2a 80 00       	push   $0x802afe
  800423:	6a 54                	push   $0x54
  800425:	68 13 2b 80 00       	push   $0x802b13
  80042a:	e8 54 07 00 00       	call   800b83 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1);
  80042f:	e8 d5 1f 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  800434:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800437:	83 f8 01             	cmp    $0x1,%eax
  80043a:	74 16                	je     800452 <_main+0x41a>
  80043c:	68 64 2d 80 00       	push   $0x802d64
  800441:	68 fe 2a 80 00       	push   $0x802afe
  800446:	6a 55                	push   $0x55
  800448:	68 13 2b 80 00       	push   $0x802b13
  80044d:	e8 31 07 00 00       	call   800b83 <_panic>

		//Memory access
		freeFrames = sys_calculate_free_frames() ;
  800452:	e8 2f 1f 00 00       	call   802386 <sys_calculate_free_frames>
  800457:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80045a:	e8 aa 1f 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  80045f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		x[1]='A';
  800462:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800465:	40                   	inc    %eax
  800466:	c6 00 41             	movb   $0x41,(%eax)
		x[512*kilo]='B';
  800469:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046c:	c1 e0 09             	shl    $0x9,%eax
  80046f:	89 c2                	mov    %eax,%edx
  800471:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800474:	01 d0                	add    %edx,%eax
  800476:	c6 00 42             	movb   $0x42,(%eax)
		x[1*Mega] = 'C' ;
  800479:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80047c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80047f:	01 d0                	add    %edx,%eax
  800481:	c6 00 43             	movb   $0x43,(%eax)
		x[8*Mega] = 'D';
  800484:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800487:	c1 e0 03             	shl    $0x3,%eax
  80048a:	89 c2                	mov    %eax,%edx
  80048c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80048f:	01 d0                	add    %edx,%eax
  800491:	c6 00 44             	movb   $0x44,(%eax)
		y[0] = 'E';
  800494:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800497:	c6 00 45             	movb   $0x45,(%eax)

		assert(x[1]='A');
  80049a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80049d:	40                   	inc    %eax
  80049e:	c6 00 41             	movb   $0x41,(%eax)
		assert(x[512*kilo]='B');
  8004a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a4:	c1 e0 09             	shl    $0x9,%eax
  8004a7:	89 c2                	mov    %eax,%edx
  8004a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004ac:	01 d0                	add    %edx,%eax
  8004ae:	c6 00 42             	movb   $0x42,(%eax)
		assert(x[1*Mega] == 'C' );
  8004b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004b7:	01 d0                	add    %edx,%eax
  8004b9:	8a 00                	mov    (%eax),%al
  8004bb:	3c 43                	cmp    $0x43,%al
  8004bd:	74 16                	je     8004d5 <_main+0x49d>
  8004bf:	68 9e 2d 80 00       	push   $0x802d9e
  8004c4:	68 fe 2a 80 00       	push   $0x802afe
  8004c9:	6a 63                	push   $0x63
  8004cb:	68 13 2b 80 00       	push   $0x802b13
  8004d0:	e8 ae 06 00 00       	call   800b83 <_panic>
		assert(x[8*Mega] == 'D');
  8004d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d8:	c1 e0 03             	shl    $0x3,%eax
  8004db:	89 c2                	mov    %eax,%edx
  8004dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004e0:	01 d0                	add    %edx,%eax
  8004e2:	8a 00                	mov    (%eax),%al
  8004e4:	3c 44                	cmp    $0x44,%al
  8004e6:	74 16                	je     8004fe <_main+0x4c6>
  8004e8:	68 af 2d 80 00       	push   $0x802daf
  8004ed:	68 fe 2a 80 00       	push   $0x802afe
  8004f2:	6a 64                	push   $0x64
  8004f4:	68 13 2b 80 00       	push   $0x802b13
  8004f9:	e8 85 06 00 00       	call   800b83 <_panic>
		assert(y[0] == 'E');
  8004fe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800501:	8a 00                	mov    (%eax),%al
  800503:	3c 45                	cmp    $0x45,%al
  800505:	74 16                	je     80051d <_main+0x4e5>
  800507:	68 c0 2d 80 00       	push   $0x802dc0
  80050c:	68 fe 2a 80 00       	push   $0x802afe
  800511:	6a 65                	push   $0x65
  800513:	68 13 2b 80 00       	push   $0x802b13
  800518:	e8 66 06 00 00       	call   800b83 <_panic>

		assert((freeFrames - sys_calculate_free_frames()) == 3 + 5);
  80051d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800520:	e8 61 1e 00 00       	call   802386 <sys_calculate_free_frames>
  800525:	29 c3                	sub    %eax,%ebx
  800527:	89 d8                	mov    %ebx,%eax
  800529:	83 f8 08             	cmp    $0x8,%eax
  80052c:	74 16                	je     800544 <_main+0x50c>
  80052e:	68 cc 2d 80 00       	push   $0x802dcc
  800533:	68 fe 2a 80 00       	push   $0x802afe
  800538:	6a 67                	push   $0x67
  80053a:	68 13 2b 80 00       	push   $0x802b13
  80053f:	e8 3f 06 00 00       	call   800b83 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  800544:	e8 c0 1e 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  800549:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80054c:	74 16                	je     800564 <_main+0x52c>
  80054e:	68 00 2e 80 00       	push   $0x802e00
  800553:	68 fe 2a 80 00       	push   $0x802afe
  800558:	6a 68                	push   $0x68
  80055a:	68 13 2b 80 00       	push   $0x802b13
  80055f:	e8 1f 06 00 00       	call   800b83 <_panic>

		//Free 2nd 1 MB
		int freeFrames = sys_calculate_free_frames() ;
  800564:	e8 1d 1e 00 00       	call   802386 <sys_calculate_free_frames>
  800569:	89 45 b0             	mov    %eax,-0x50(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80056c:	e8 98 1e 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  800571:	89 45 ac             	mov    %eax,-0x54(%ebp)
		free(t1);
  800574:	83 ec 0c             	sub    $0xc,%esp
  800577:	ff 75 c4             	pushl  -0x3c(%ebp)
  80057a:	e8 eb 1a 00 00       	call   80206a <free>
  80057f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800582:	e8 82 1e 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  800587:	8b 55 ac             	mov    -0x54(%ebp),%edx
  80058a:	29 c2                	sub    %eax,%edx
  80058c:	89 d0                	mov    %edx,%eax
  80058e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800593:	74 14                	je     8005a9 <_main+0x571>
  800595:	83 ec 04             	sub    $0x4,%esp
  800598:	68 3c 2e 80 00       	push   $0x802e3c
  80059d:	6a 6e                	push   $0x6e
  80059f:	68 13 2b 80 00       	push   $0x802b13
  8005a4:	e8 da 05 00 00       	call   800b83 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8005a9:	e8 d8 1d 00 00       	call   802386 <sys_calculate_free_frames>
  8005ae:	89 c2                	mov    %eax,%edx
  8005b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005b3:	29 c2                	sub    %eax,%edx
  8005b5:	89 d0                	mov    %edx,%eax
  8005b7:	83 f8 01             	cmp    $0x1,%eax
  8005ba:	74 14                	je     8005d0 <_main+0x598>
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	68 78 2e 80 00       	push   $0x802e78
  8005c4:	6a 6f                	push   $0x6f
  8005c6:	68 13 2b 80 00       	push   $0x802b13
  8005cb:	e8 b3 05 00 00       	call   800b83 <_panic>
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005d7:	eb 50                	jmp    800629 <_main+0x5f1>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(x[1*Mega])), PAGE_SIZE))
  8005d9:	a1 20 40 80 00       	mov    0x804020,%eax
  8005de:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8005e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005e7:	c1 e2 04             	shl    $0x4,%edx
  8005ea:	01 d0                	add    %edx,%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8005f1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8005f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005f9:	89 c1                	mov    %eax,%ecx
  8005fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800601:	01 d0                	add    %edx,%eax
  800603:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  800606:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800609:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80060e:	39 c1                	cmp    %eax,%ecx
  800610:	75 14                	jne    800626 <_main+0x5ee>
				panic("free: page is not removed from WS");
  800612:	83 ec 04             	sub    $0x4,%esp
  800615:	68 c4 2e 80 00       	push   $0x802ec4
  80061a:	6a 74                	push   $0x74
  80061c:	68 13 2b 80 00       	push   $0x802b13
  800621:	e8 5d 05 00 00       	call   800b83 <_panic>
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(t1);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800626:	ff 45 f4             	incl   -0xc(%ebp)
  800629:	a1 20 40 80 00       	mov    0x804020,%eax
  80062e:	8b 50 74             	mov    0x74(%eax),%edx
  800631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800634:	39 c2                	cmp    %eax,%edx
  800636:	77 a1                	ja     8005d9 <_main+0x5a1>


		//Free the entire Heap

		{
			freeHeap();
  800638:	e8 c0 1b 00 00       	call   8021fd <freeHeap>

			//cprintf("diff = %d\n", origFreeFrames - sys_calculate_free_frames());

			assert((origFreeFrames - sys_calculate_free_frames()) == 4);
  80063d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800640:	e8 41 1d 00 00       	call   802386 <sys_calculate_free_frames>
  800645:	29 c3                	sub    %eax,%ebx
  800647:	89 d8                	mov    %ebx,%eax
  800649:	83 f8 04             	cmp    $0x4,%eax
  80064c:	74 16                	je     800664 <_main+0x62c>
  80064e:	68 e8 2e 80 00       	push   $0x802ee8
  800653:	68 fe 2a 80 00       	push   $0x802afe
  800658:	6a 7f                	push   $0x7f
  80065a:	68 13 2b 80 00       	push   $0x802b13
  80065f:	e8 1f 05 00 00       	call   800b83 <_panic>
			assert((sys_pf_calculate_allocated_pages() - origDiskPages) == 0);
  800664:	e8 a0 1d 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  800669:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80066c:	74 19                	je     800687 <_main+0x64f>
  80066e:	68 1c 2f 80 00       	push   $0x802f1c
  800673:	68 fe 2a 80 00       	push   $0x802afe
  800678:	68 80 00 00 00       	push   $0x80
  80067d:	68 13 2b 80 00       	push   $0x802b13
  800682:	e8 fc 04 00 00       	call   800b83 <_panic>

		//Check memory access after kfreeall
		{
			//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
			//and continue executing the remaining code
			sys_bypassPageFault(3);
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	6a 03                	push   $0x3
  80068c:	e8 0c 20 00 00       	call   80269d <sys_bypassPageFault>
  800691:	83 c4 10             	add    $0x10,%esp

			x[1]=-1;
  800694:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800697:	40                   	inc    %eax
  800698:	c6 00 ff             	movb   $0xff,(%eax)
			assert(sys_rcr2() == (uint32)&(x[1]));
  80069b:	e8 e4 1f 00 00       	call   802684 <sys_rcr2>
  8006a0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8006a3:	42                   	inc    %edx
  8006a4:	39 d0                	cmp    %edx,%eax
  8006a6:	74 19                	je     8006c1 <_main+0x689>
  8006a8:	68 56 2f 80 00       	push   $0x802f56
  8006ad:	68 fe 2a 80 00       	push   $0x802afe
  8006b2:	68 8a 00 00 00       	push   $0x8a
  8006b7:	68 13 2b 80 00       	push   $0x802b13
  8006bc:	e8 c2 04 00 00       	call   800b83 <_panic>

			x[8*Mega] = -1;
  8006c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c4:	c1 e0 03             	shl    $0x3,%eax
  8006c7:	89 c2                	mov    %eax,%edx
  8006c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006cc:	01 d0                	add    %edx,%eax
  8006ce:	c6 00 ff             	movb   $0xff,(%eax)
			assert(sys_rcr2() == (uint32)&(x[8*Mega]));
  8006d1:	e8 ae 1f 00 00       	call   802684 <sys_rcr2>
  8006d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d9:	c1 e2 03             	shl    $0x3,%edx
  8006dc:	89 d1                	mov    %edx,%ecx
  8006de:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8006e1:	01 ca                	add    %ecx,%edx
  8006e3:	39 d0                	cmp    %edx,%eax
  8006e5:	74 19                	je     800700 <_main+0x6c8>
  8006e7:	68 74 2f 80 00       	push   $0x802f74
  8006ec:	68 fe 2a 80 00       	push   $0x802afe
  8006f1:	68 8d 00 00 00       	push   $0x8d
  8006f6:	68 13 2b 80 00       	push   $0x802b13
  8006fb:	e8 83 04 00 00       	call   800b83 <_panic>

			x[512*kilo]=-1;
  800700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800703:	c1 e0 09             	shl    $0x9,%eax
  800706:	89 c2                	mov    %eax,%edx
  800708:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80070b:	01 d0                	add    %edx,%eax
  80070d:	c6 00 ff             	movb   $0xff,(%eax)
			assert(sys_rcr2() == (uint32)&(x[512*kilo]));
  800710:	e8 6f 1f 00 00       	call   802684 <sys_rcr2>
  800715:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800718:	c1 e2 09             	shl    $0x9,%edx
  80071b:	89 d1                	mov    %edx,%ecx
  80071d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800720:	01 ca                	add    %ecx,%edx
  800722:	39 d0                	cmp    %edx,%eax
  800724:	74 19                	je     80073f <_main+0x707>
  800726:	68 98 2f 80 00       	push   $0x802f98
  80072b:	68 fe 2a 80 00       	push   $0x802afe
  800730:	68 90 00 00 00       	push   $0x90
  800735:	68 13 2b 80 00       	push   $0x802b13
  80073a:	e8 44 04 00 00       	call   800b83 <_panic>

			y[0] = -1;
  80073f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800742:	c6 00 ff             	movb   $0xff,(%eax)
			assert(sys_rcr2() == (uint32)&(y[0]));
  800745:	e8 3a 1f 00 00       	call   802684 <sys_rcr2>
  80074a:	89 c2                	mov    %eax,%edx
  80074c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80074f:	39 c2                	cmp    %eax,%edx
  800751:	74 19                	je     80076c <_main+0x734>
  800753:	68 bd 2f 80 00       	push   $0x802fbd
  800758:	68 fe 2a 80 00       	push   $0x802afe
  80075d:	68 93 00 00 00       	push   $0x93
  800762:	68 13 2b 80 00       	push   $0x802b13
  800767:	e8 17 04 00 00       	call   800b83 <_panic>

			//set it to 0 again to cancel the bypassing option
			sys_bypassPageFault(0);
  80076c:	83 ec 0c             	sub    $0xc,%esp
  80076f:	6a 00                	push   $0x0
  800771:	e8 27 1f 00 00       	call   80269d <sys_bypassPageFault>
  800776:	83 c4 10             	add    $0x10,%esp

		//Checking if freeHeap RESET the HEAP POINTER or not
		{

			//1 KB
			freeFrames = sys_calculate_free_frames() ;
  800779:	e8 08 1c 00 00       	call   802386 <sys_calculate_free_frames>
  80077e:	89 45 b0             	mov    %eax,-0x50(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800781:	e8 83 1c 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  800786:	89 45 ac             	mov    %eax,-0x54(%ebp)

			unsigned char *w = malloc(sizeof(unsigned char)*kilo) ;
  800789:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80078c:	83 ec 0c             	sub    $0xc,%esp
  80078f:	50                   	push   %eax
  800790:	e8 1a 14 00 00       	call   801baf <malloc>
  800795:	83 c4 10             	add    $0x10,%esp
  800798:	89 45 a0             	mov    %eax,-0x60(%ebp)

			assert((uint32)w == USER_HEAP_START);
  80079b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80079e:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8007a3:	74 19                	je     8007be <_main+0x786>
  8007a5:	68 db 2f 80 00       	push   $0x802fdb
  8007aa:	68 fe 2a 80 00       	push   $0x802afe
  8007af:	68 a2 00 00 00       	push   $0xa2
  8007b4:	68 13 2b 80 00       	push   $0x802b13
  8007b9:	e8 c5 03 00 00       	call   800b83 <_panic>
			assert((freeFrames - sys_calculate_free_frames()) == 0);
  8007be:	e8 c3 1b 00 00       	call   802386 <sys_calculate_free_frames>
  8007c3:	89 c2                	mov    %eax,%edx
  8007c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8007c8:	39 c2                	cmp    %eax,%edx
  8007ca:	74 19                	je     8007e5 <_main+0x7ad>
  8007cc:	68 c8 2b 80 00       	push   $0x802bc8
  8007d1:	68 fe 2a 80 00       	push   $0x802afe
  8007d6:	68 a3 00 00 00       	push   $0xa3
  8007db:	68 13 2b 80 00       	push   $0x802b13
  8007e0:	e8 9e 03 00 00       	call   800b83 <_panic>
			assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1);
  8007e5:	e8 1f 1c 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  8007ea:	2b 45 ac             	sub    -0x54(%ebp),%eax
  8007ed:	83 f8 01             	cmp    $0x1,%eax
  8007f0:	74 19                	je     80080b <_main+0x7d3>
  8007f2:	68 64 2d 80 00       	push   $0x802d64
  8007f7:	68 fe 2a 80 00       	push   $0x802afe
  8007fc:	68 a4 00 00 00       	push   $0xa4
  800801:	68 13 2b 80 00       	push   $0x802b13
  800806:	e8 78 03 00 00       	call   800b83 <_panic>

			//1 B
			freeFrames = sys_calculate_free_frames() ;
  80080b:	e8 76 1b 00 00       	call   802386 <sys_calculate_free_frames>
  800810:	89 45 b0             	mov    %eax,-0x50(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800813:	e8 f1 1b 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  800818:	89 45 ac             	mov    %eax,-0x54(%ebp)

			unsigned char *f = malloc(sizeof(unsigned char)*1) ;
  80081b:	83 ec 0c             	sub    $0xc,%esp
  80081e:	6a 01                	push   $0x1
  800820:	e8 8a 13 00 00       	call   801baf <malloc>
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	89 45 9c             	mov    %eax,-0x64(%ebp)

			assert((uint32)f == USER_HEAP_START + PAGE_SIZE);
  80082b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80082e:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800833:	74 19                	je     80084e <_main+0x816>
  800835:	68 f8 2f 80 00       	push   $0x802ff8
  80083a:	68 fe 2a 80 00       	push   $0x802afe
  80083f:	68 ac 00 00 00       	push   $0xac
  800844:	68 13 2b 80 00       	push   $0x802b13
  800849:	e8 35 03 00 00       	call   800b83 <_panic>
			assert((freeFrames - sys_calculate_free_frames()) == 0);
  80084e:	e8 33 1b 00 00       	call   802386 <sys_calculate_free_frames>
  800853:	89 c2                	mov    %eax,%edx
  800855:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800858:	39 c2                	cmp    %eax,%edx
  80085a:	74 19                	je     800875 <_main+0x83d>
  80085c:	68 c8 2b 80 00       	push   $0x802bc8
  800861:	68 fe 2a 80 00       	push   $0x802afe
  800866:	68 ad 00 00 00       	push   $0xad
  80086b:	68 13 2b 80 00       	push   $0x802b13
  800870:	e8 0e 03 00 00       	call   800b83 <_panic>
			assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1);
  800875:	e8 8f 1b 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  80087a:	2b 45 ac             	sub    -0x54(%ebp),%eax
  80087d:	83 f8 01             	cmp    $0x1,%eax
  800880:	74 19                	je     80089b <_main+0x863>
  800882:	68 64 2d 80 00       	push   $0x802d64
  800887:	68 fe 2a 80 00       	push   $0x802afe
  80088c:	68 ae 00 00 00       	push   $0xae
  800891:	68 13 2b 80 00       	push   $0x802b13
  800896:	e8 e8 02 00 00       	call   800b83 <_panic>

			f[0] = -1;
  80089b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80089e:	c6 00 ff             	movb   $0xff,(%eax)

			//1 MB
			freeFrames = sys_calculate_free_frames() ;
  8008a1:	e8 e0 1a 00 00       	call   802386 <sys_calculate_free_frames>
  8008a6:	89 45 b0             	mov    %eax,-0x50(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008a9:	e8 5b 1b 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  8008ae:	89 45 ac             	mov    %eax,-0x54(%ebp)

			unsigned char *z = malloc(sizeof(unsigned char)*Mega) ;
  8008b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b4:	83 ec 0c             	sub    $0xc,%esp
  8008b7:	50                   	push   %eax
  8008b8:	e8 f2 12 00 00       	call   801baf <malloc>
  8008bd:	83 c4 10             	add    $0x10,%esp
  8008c0:	89 45 98             	mov    %eax,-0x68(%ebp)

			assert((uint32)z == USER_HEAP_START + 2*PAGE_SIZE);
  8008c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008c6:	3d 00 20 00 80       	cmp    $0x80002000,%eax
  8008cb:	74 19                	je     8008e6 <_main+0x8ae>
  8008cd:	68 24 30 80 00       	push   $0x803024
  8008d2:	68 fe 2a 80 00       	push   $0x802afe
  8008d7:	68 b8 00 00 00       	push   $0xb8
  8008dc:	68 13 2b 80 00       	push   $0x802b13
  8008e1:	e8 9d 02 00 00       	call   800b83 <_panic>
			assert((freeFrames - sys_calculate_free_frames()) == 0);
  8008e6:	e8 9b 1a 00 00       	call   802386 <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 19                	je     80090d <_main+0x8d5>
  8008f4:	68 c8 2b 80 00       	push   $0x802bc8
  8008f9:	68 fe 2a 80 00       	push   $0x802afe
  8008fe:	68 b9 00 00 00       	push   $0xb9
  800903:	68 13 2b 80 00       	push   $0x802b13
  800908:	e8 76 02 00 00       	call   800b83 <_panic>
			assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == Mega/PAGE_SIZE);
  80090d:	e8 f7 1a 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  800912:	2b 45 ac             	sub    -0x54(%ebp),%eax
  800915:	89 c2                	mov    %eax,%edx
  800917:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091a:	85 c0                	test   %eax,%eax
  80091c:	79 05                	jns    800923 <_main+0x8eb>
  80091e:	05 ff 0f 00 00       	add    $0xfff,%eax
  800923:	c1 f8 0c             	sar    $0xc,%eax
  800926:	39 c2                	cmp    %eax,%edx
  800928:	74 19                	je     800943 <_main+0x90b>
  80092a:	68 50 30 80 00       	push   $0x803050
  80092f:	68 fe 2a 80 00       	push   $0x802afe
  800934:	68 ba 00 00 00       	push   $0xba
  800939:	68 13 2b 80 00       	push   $0x802b13
  80093e:	e8 40 02 00 00       	call   800b83 <_panic>

			//Free 1 KB
			int freeFrames = sys_calculate_free_frames() ;
  800943:	e8 3e 1a 00 00       	call   802386 <sys_calculate_free_frames>
  800948:	89 45 94             	mov    %eax,-0x6c(%ebp)
			int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80094b:	e8 b9 1a 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  800950:	89 45 90             	mov    %eax,-0x70(%ebp)
			free(w);
  800953:	83 ec 0c             	sub    $0xc,%esp
  800956:	ff 75 a0             	pushl  -0x60(%ebp)
  800959:	e8 0c 17 00 00       	call   80206a <free>
  80095e:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  800961:	e8 a3 1a 00 00       	call   802409 <sys_pf_calculate_allocated_pages>
  800966:	8b 55 90             	mov    -0x70(%ebp),%edx
  800969:	29 c2                	sub    %eax,%edx
  80096b:	89 d0                	mov    %edx,%eax
  80096d:	83 f8 01             	cmp    $0x1,%eax
  800970:	74 17                	je     800989 <_main+0x951>
  800972:	83 ec 04             	sub    $0x4,%esp
  800975:	68 3c 2e 80 00       	push   $0x802e3c
  80097a:	68 c0 00 00 00       	push   $0xc0
  80097f:	68 13 2b 80 00       	push   $0x802b13
  800984:	e8 fa 01 00 00       	call   800b83 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 0 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800989:	e8 f8 19 00 00       	call   802386 <sys_calculate_free_frames>
  80098e:	89 c2                	mov    %eax,%edx
  800990:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800993:	39 c2                	cmp    %eax,%edx
  800995:	74 17                	je     8009ae <_main+0x976>
  800997:	83 ec 04             	sub    $0x4,%esp
  80099a:	68 78 2e 80 00       	push   $0x802e78
  80099f:	68 c1 00 00 00       	push   $0xc1
  8009a4:	68 13 2b 80 00       	push   $0x802b13
  8009a9:	e8 d5 01 00 00       	call   800b83 <_panic>
			int var;
			int found = 0;
  8009ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8009b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009bc:	eb 3e                	jmp    8009fc <_main+0x9c4>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(f[0])), PAGE_SIZE))
  8009be:	a1 20 40 80 00       	mov    0x804020,%eax
  8009c3:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8009c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8009cc:	c1 e2 04             	shl    $0x4,%edx
  8009cf:	01 d0                	add    %edx,%eax
  8009d1:	8b 00                	mov    (%eax),%eax
  8009d3:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8009d6:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8009d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009de:	89 c2                	mov    %eax,%edx
  8009e0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8009e3:	89 45 88             	mov    %eax,-0x78(%ebp)
  8009e6:	8b 45 88             	mov    -0x78(%ebp),%eax
  8009e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009ee:	39 c2                	cmp    %eax,%edx
  8009f0:	75 07                	jne    8009f9 <_main+0x9c1>
					found = 1;
  8009f2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			free(w);
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
			if ((sys_calculate_free_frames() - freeFrames) != 0 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
			int var;
			int found = 0;
			for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8009f9:	ff 45 f0             	incl   -0x10(%ebp)
  8009fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800a01:	8b 50 74             	mov    0x74(%eax),%edx
  800a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a07:	39 c2                	cmp    %eax,%edx
  800a09:	77 b3                	ja     8009be <_main+0x986>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(f[0])), PAGE_SIZE))
					found = 1;
			}

			if (!found)
  800a0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a0f:	75 17                	jne    800a28 <_main+0x9f0>
				panic("free: variables are not removed correctly");
  800a11:	83 ec 04             	sub    $0x4,%esp
  800a14:	68 98 30 80 00       	push   $0x803098
  800a19:	68 cb 00 00 00       	push   $0xcb
  800a1e:	68 13 2b 80 00       	push   $0x802b13
  800a23:	e8 5b 01 00 00       	call   800b83 <_panic>

		}



		cprintf("Congratulations!! your modification is completed successfully.\n");
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	68 c4 30 80 00       	push   $0x8030c4
  800a30:	e8 f0 03 00 00       	call   800e25 <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp

	}

	return;
  800a38:	90                   	nop
}
  800a39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a3c:	c9                   	leave  
  800a3d:	c3                   	ret    

00800a3e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800a44:	e8 72 18 00 00       	call   8022bb <sys_getenvindex>
  800a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800a4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a4f:	89 d0                	mov    %edx,%eax
  800a51:	c1 e0 03             	shl    $0x3,%eax
  800a54:	01 d0                	add    %edx,%eax
  800a56:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800a5d:	01 c8                	add    %ecx,%eax
  800a5f:	01 c0                	add    %eax,%eax
  800a61:	01 d0                	add    %edx,%eax
  800a63:	01 c0                	add    %eax,%eax
  800a65:	01 d0                	add    %edx,%eax
  800a67:	89 c2                	mov    %eax,%edx
  800a69:	c1 e2 05             	shl    $0x5,%edx
  800a6c:	29 c2                	sub    %eax,%edx
  800a6e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800a75:	89 c2                	mov    %eax,%edx
  800a77:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800a7d:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800a82:	a1 20 40 80 00       	mov    0x804020,%eax
  800a87:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800a8d:	84 c0                	test   %al,%al
  800a8f:	74 0f                	je     800aa0 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800a91:	a1 20 40 80 00       	mov    0x804020,%eax
  800a96:	05 40 3c 01 00       	add    $0x13c40,%eax
  800a9b:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800aa0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aa4:	7e 0a                	jle    800ab0 <libmain+0x72>
		binaryname = argv[0];
  800aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	ff 75 08             	pushl  0x8(%ebp)
  800ab9:	e8 7a f5 ff ff       	call   800038 <_main>
  800abe:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800ac1:	e8 90 19 00 00       	call   802456 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800ac6:	83 ec 0c             	sub    $0xc,%esp
  800ac9:	68 1c 31 80 00       	push   $0x80311c
  800ace:	e8 52 03 00 00       	call   800e25 <cprintf>
  800ad3:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800ad6:	a1 20 40 80 00       	mov    0x804020,%eax
  800adb:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800ae1:	a1 20 40 80 00       	mov    0x804020,%eax
  800ae6:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800aec:	83 ec 04             	sub    $0x4,%esp
  800aef:	52                   	push   %edx
  800af0:	50                   	push   %eax
  800af1:	68 44 31 80 00       	push   $0x803144
  800af6:	e8 2a 03 00 00       	call   800e25 <cprintf>
  800afb:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800afe:	a1 20 40 80 00       	mov    0x804020,%eax
  800b03:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800b09:	a1 20 40 80 00       	mov    0x804020,%eax
  800b0e:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800b14:	83 ec 04             	sub    $0x4,%esp
  800b17:	52                   	push   %edx
  800b18:	50                   	push   %eax
  800b19:	68 6c 31 80 00       	push   $0x80316c
  800b1e:	e8 02 03 00 00       	call   800e25 <cprintf>
  800b23:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800b26:	a1 20 40 80 00       	mov    0x804020,%eax
  800b2b:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	50                   	push   %eax
  800b35:	68 ad 31 80 00       	push   $0x8031ad
  800b3a:	e8 e6 02 00 00       	call   800e25 <cprintf>
  800b3f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800b42:	83 ec 0c             	sub    $0xc,%esp
  800b45:	68 1c 31 80 00       	push   $0x80311c
  800b4a:	e8 d6 02 00 00       	call   800e25 <cprintf>
  800b4f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800b52:	e8 19 19 00 00       	call   802470 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800b57:	e8 19 00 00 00       	call   800b75 <exit>
}
  800b5c:	90                   	nop
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800b65:	83 ec 0c             	sub    $0xc,%esp
  800b68:	6a 00                	push   $0x0
  800b6a:	e8 18 17 00 00       	call   802287 <sys_env_destroy>
  800b6f:	83 c4 10             	add    $0x10,%esp
}
  800b72:	90                   	nop
  800b73:	c9                   	leave  
  800b74:	c3                   	ret    

00800b75 <exit>:

void
exit(void)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800b7b:	e8 6d 17 00 00       	call   8022ed <sys_env_exit>
}
  800b80:	90                   	nop
  800b81:	c9                   	leave  
  800b82:	c3                   	ret    

00800b83 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800b89:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8c:	83 c0 04             	add    $0x4,%eax
  800b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800b92:	a1 18 41 80 00       	mov    0x804118,%eax
  800b97:	85 c0                	test   %eax,%eax
  800b99:	74 16                	je     800bb1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800b9b:	a1 18 41 80 00       	mov    0x804118,%eax
  800ba0:	83 ec 08             	sub    $0x8,%esp
  800ba3:	50                   	push   %eax
  800ba4:	68 c4 31 80 00       	push   $0x8031c4
  800ba9:	e8 77 02 00 00       	call   800e25 <cprintf>
  800bae:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800bb1:	a1 00 40 80 00       	mov    0x804000,%eax
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	ff 75 08             	pushl  0x8(%ebp)
  800bbc:	50                   	push   %eax
  800bbd:	68 c9 31 80 00       	push   $0x8031c9
  800bc2:	e8 5e 02 00 00       	call   800e25 <cprintf>
  800bc7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800bca:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd3:	50                   	push   %eax
  800bd4:	e8 e1 01 00 00       	call   800dba <vcprintf>
  800bd9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	6a 00                	push   $0x0
  800be1:	68 e5 31 80 00       	push   $0x8031e5
  800be6:	e8 cf 01 00 00       	call   800dba <vcprintf>
  800beb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800bee:	e8 82 ff ff ff       	call   800b75 <exit>

	// should not return here
	while (1) ;
  800bf3:	eb fe                	jmp    800bf3 <_panic+0x70>

00800bf5 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800bfb:	a1 20 40 80 00       	mov    0x804020,%eax
  800c00:	8b 50 74             	mov    0x74(%eax),%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	39 c2                	cmp    %eax,%edx
  800c08:	74 14                	je     800c1e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800c0a:	83 ec 04             	sub    $0x4,%esp
  800c0d:	68 e8 31 80 00       	push   $0x8031e8
  800c12:	6a 26                	push   $0x26
  800c14:	68 34 32 80 00       	push   $0x803234
  800c19:	e8 65 ff ff ff       	call   800b83 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800c1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800c25:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c2c:	e9 b6 00 00 00       	jmp    800ce7 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	01 d0                	add    %edx,%eax
  800c40:	8b 00                	mov    (%eax),%eax
  800c42:	85 c0                	test   %eax,%eax
  800c44:	75 08                	jne    800c4e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800c46:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800c49:	e9 96 00 00 00       	jmp    800ce4 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800c4e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c55:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800c5c:	eb 5d                	jmp    800cbb <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800c5e:	a1 20 40 80 00       	mov    0x804020,%eax
  800c63:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800c69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c6c:	c1 e2 04             	shl    $0x4,%edx
  800c6f:	01 d0                	add    %edx,%eax
  800c71:	8a 40 04             	mov    0x4(%eax),%al
  800c74:	84 c0                	test   %al,%al
  800c76:	75 40                	jne    800cb8 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800c78:	a1 20 40 80 00       	mov    0x804020,%eax
  800c7d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800c83:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c86:	c1 e2 04             	shl    $0x4,%edx
  800c89:	01 d0                	add    %edx,%eax
  800c8b:	8b 00                	mov    (%eax),%eax
  800c8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800c90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c98:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	01 c8                	add    %ecx,%eax
  800ca9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800cab:	39 c2                	cmp    %eax,%edx
  800cad:	75 09                	jne    800cb8 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800caf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800cb6:	eb 12                	jmp    800cca <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800cb8:	ff 45 e8             	incl   -0x18(%ebp)
  800cbb:	a1 20 40 80 00       	mov    0x804020,%eax
  800cc0:	8b 50 74             	mov    0x74(%eax),%edx
  800cc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800cc6:	39 c2                	cmp    %eax,%edx
  800cc8:	77 94                	ja     800c5e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800cca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800cce:	75 14                	jne    800ce4 <CheckWSWithoutLastIndex+0xef>
			panic(
  800cd0:	83 ec 04             	sub    $0x4,%esp
  800cd3:	68 40 32 80 00       	push   $0x803240
  800cd8:	6a 3a                	push   $0x3a
  800cda:	68 34 32 80 00       	push   $0x803234
  800cdf:	e8 9f fe ff ff       	call   800b83 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800ce4:	ff 45 f0             	incl   -0x10(%ebp)
  800ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800ced:	0f 8c 3e ff ff ff    	jl     800c31 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800cf3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800cfa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800d01:	eb 20                	jmp    800d23 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800d03:	a1 20 40 80 00       	mov    0x804020,%eax
  800d08:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d11:	c1 e2 04             	shl    $0x4,%edx
  800d14:	01 d0                	add    %edx,%eax
  800d16:	8a 40 04             	mov    0x4(%eax),%al
  800d19:	3c 01                	cmp    $0x1,%al
  800d1b:	75 03                	jne    800d20 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800d1d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d20:	ff 45 e0             	incl   -0x20(%ebp)
  800d23:	a1 20 40 80 00       	mov    0x804020,%eax
  800d28:	8b 50 74             	mov    0x74(%eax),%edx
  800d2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d2e:	39 c2                	cmp    %eax,%edx
  800d30:	77 d1                	ja     800d03 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d35:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800d38:	74 14                	je     800d4e <CheckWSWithoutLastIndex+0x159>
		panic(
  800d3a:	83 ec 04             	sub    $0x4,%esp
  800d3d:	68 94 32 80 00       	push   $0x803294
  800d42:	6a 44                	push   $0x44
  800d44:	68 34 32 80 00       	push   $0x803234
  800d49:	e8 35 fe ff ff       	call   800b83 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800d4e:	90                   	nop
  800d4f:	c9                   	leave  
  800d50:	c3                   	ret    

00800d51 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8b 00                	mov    (%eax),%eax
  800d5c:	8d 48 01             	lea    0x1(%eax),%ecx
  800d5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d62:	89 0a                	mov    %ecx,(%edx)
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	88 d1                	mov    %dl,%cl
  800d69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8b 00                	mov    (%eax),%eax
  800d75:	3d ff 00 00 00       	cmp    $0xff,%eax
  800d7a:	75 2c                	jne    800da8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800d7c:	a0 24 40 80 00       	mov    0x804024,%al
  800d81:	0f b6 c0             	movzbl %al,%eax
  800d84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d87:	8b 12                	mov    (%edx),%edx
  800d89:	89 d1                	mov    %edx,%ecx
  800d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8e:	83 c2 08             	add    $0x8,%edx
  800d91:	83 ec 04             	sub    $0x4,%esp
  800d94:	50                   	push   %eax
  800d95:	51                   	push   %ecx
  800d96:	52                   	push   %edx
  800d97:	e8 a9 14 00 00       	call   802245 <sys_cputs>
  800d9c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	8b 40 04             	mov    0x4(%eax),%eax
  800dae:	8d 50 01             	lea    0x1(%eax),%edx
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	89 50 04             	mov    %edx,0x4(%eax)
}
  800db7:	90                   	nop
  800db8:	c9                   	leave  
  800db9:	c3                   	ret    

00800dba <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800dc3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800dca:	00 00 00 
	b.cnt = 0;
  800dcd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800dd4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800dd7:	ff 75 0c             	pushl  0xc(%ebp)
  800dda:	ff 75 08             	pushl  0x8(%ebp)
  800ddd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800de3:	50                   	push   %eax
  800de4:	68 51 0d 80 00       	push   $0x800d51
  800de9:	e8 11 02 00 00       	call   800fff <vprintfmt>
  800dee:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800df1:	a0 24 40 80 00       	mov    0x804024,%al
  800df6:	0f b6 c0             	movzbl %al,%eax
  800df9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800dff:	83 ec 04             	sub    $0x4,%esp
  800e02:	50                   	push   %eax
  800e03:	52                   	push   %edx
  800e04:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800e0a:	83 c0 08             	add    $0x8,%eax
  800e0d:	50                   	push   %eax
  800e0e:	e8 32 14 00 00       	call   802245 <sys_cputs>
  800e13:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800e16:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800e1d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <cprintf>:

int cprintf(const char *fmt, ...) {
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800e2b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800e32:	8d 45 0c             	lea    0xc(%ebp),%eax
  800e35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	83 ec 08             	sub    $0x8,%esp
  800e3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e41:	50                   	push   %eax
  800e42:	e8 73 ff ff ff       	call   800dba <vcprintf>
  800e47:	83 c4 10             	add    $0x10,%esp
  800e4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e50:	c9                   	leave  
  800e51:	c3                   	ret    

00800e52 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800e58:	e8 f9 15 00 00       	call   802456 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800e5d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800e60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	83 ec 08             	sub    $0x8,%esp
  800e69:	ff 75 f4             	pushl  -0xc(%ebp)
  800e6c:	50                   	push   %eax
  800e6d:	e8 48 ff ff ff       	call   800dba <vcprintf>
  800e72:	83 c4 10             	add    $0x10,%esp
  800e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800e78:	e8 f3 15 00 00       	call   802470 <sys_enable_interrupt>
	return cnt;
  800e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e80:	c9                   	leave  
  800e81:	c3                   	ret    

00800e82 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	53                   	push   %ebx
  800e86:	83 ec 14             	sub    $0x14,%esp
  800e89:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e95:	8b 45 18             	mov    0x18(%ebp),%eax
  800e98:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ea0:	77 55                	ja     800ef7 <printnum+0x75>
  800ea2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ea5:	72 05                	jb     800eac <printnum+0x2a>
  800ea7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800eaa:	77 4b                	ja     800ef7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800eac:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800eaf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800eb2:	8b 45 18             	mov    0x18(%ebp),%eax
  800eb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800eba:	52                   	push   %edx
  800ebb:	50                   	push   %eax
  800ebc:	ff 75 f4             	pushl  -0xc(%ebp)
  800ebf:	ff 75 f0             	pushl  -0x10(%ebp)
  800ec2:	e8 b1 19 00 00       	call   802878 <__udivdi3>
  800ec7:	83 c4 10             	add    $0x10,%esp
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	ff 75 20             	pushl  0x20(%ebp)
  800ed0:	53                   	push   %ebx
  800ed1:	ff 75 18             	pushl  0x18(%ebp)
  800ed4:	52                   	push   %edx
  800ed5:	50                   	push   %eax
  800ed6:	ff 75 0c             	pushl  0xc(%ebp)
  800ed9:	ff 75 08             	pushl  0x8(%ebp)
  800edc:	e8 a1 ff ff ff       	call   800e82 <printnum>
  800ee1:	83 c4 20             	add    $0x20,%esp
  800ee4:	eb 1a                	jmp    800f00 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ee6:	83 ec 08             	sub    $0x8,%esp
  800ee9:	ff 75 0c             	pushl  0xc(%ebp)
  800eec:	ff 75 20             	pushl  0x20(%ebp)
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	ff d0                	call   *%eax
  800ef4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ef7:	ff 4d 1c             	decl   0x1c(%ebp)
  800efa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800efe:	7f e6                	jg     800ee6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800f00:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800f03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0e:	53                   	push   %ebx
  800f0f:	51                   	push   %ecx
  800f10:	52                   	push   %edx
  800f11:	50                   	push   %eax
  800f12:	e8 71 1a 00 00       	call   802988 <__umoddi3>
  800f17:	83 c4 10             	add    $0x10,%esp
  800f1a:	05 f4 34 80 00       	add    $0x8034f4,%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	0f be c0             	movsbl %al,%eax
  800f24:	83 ec 08             	sub    $0x8,%esp
  800f27:	ff 75 0c             	pushl  0xc(%ebp)
  800f2a:	50                   	push   %eax
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	ff d0                	call   *%eax
  800f30:	83 c4 10             	add    $0x10,%esp
}
  800f33:	90                   	nop
  800f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f37:	c9                   	leave  
  800f38:	c3                   	ret    

00800f39 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800f3c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f40:	7e 1c                	jle    800f5e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8b 00                	mov    (%eax),%eax
  800f47:	8d 50 08             	lea    0x8(%eax),%edx
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	89 10                	mov    %edx,(%eax)
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8b 00                	mov    (%eax),%eax
  800f54:	83 e8 08             	sub    $0x8,%eax
  800f57:	8b 50 04             	mov    0x4(%eax),%edx
  800f5a:	8b 00                	mov    (%eax),%eax
  800f5c:	eb 40                	jmp    800f9e <getuint+0x65>
	else if (lflag)
  800f5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f62:	74 1e                	je     800f82 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8b 00                	mov    (%eax),%eax
  800f69:	8d 50 04             	lea    0x4(%eax),%edx
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	89 10                	mov    %edx,(%eax)
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8b 00                	mov    (%eax),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax
  800f7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f80:	eb 1c                	jmp    800f9e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8b 00                	mov    (%eax),%eax
  800f87:	8d 50 04             	lea    0x4(%eax),%edx
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	89 10                	mov    %edx,(%eax)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8b 00                	mov    (%eax),%eax
  800f94:	83 e8 04             	sub    $0x4,%eax
  800f97:	8b 00                	mov    (%eax),%eax
  800f99:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800fa3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800fa7:	7e 1c                	jle    800fc5 <getint+0x25>
		return va_arg(*ap, long long);
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8b 00                	mov    (%eax),%eax
  800fae:	8d 50 08             	lea    0x8(%eax),%edx
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	89 10                	mov    %edx,(%eax)
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8b 00                	mov    (%eax),%eax
  800fbb:	83 e8 08             	sub    $0x8,%eax
  800fbe:	8b 50 04             	mov    0x4(%eax),%edx
  800fc1:	8b 00                	mov    (%eax),%eax
  800fc3:	eb 38                	jmp    800ffd <getint+0x5d>
	else if (lflag)
  800fc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc9:	74 1a                	je     800fe5 <getint+0x45>
		return va_arg(*ap, long);
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8b 00                	mov    (%eax),%eax
  800fd0:	8d 50 04             	lea    0x4(%eax),%edx
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	89 10                	mov    %edx,(%eax)
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8b 00                	mov    (%eax),%eax
  800fdd:	83 e8 04             	sub    $0x4,%eax
  800fe0:	8b 00                	mov    (%eax),%eax
  800fe2:	99                   	cltd   
  800fe3:	eb 18                	jmp    800ffd <getint+0x5d>
	else
		return va_arg(*ap, int);
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8b 00                	mov    (%eax),%eax
  800fea:	8d 50 04             	lea    0x4(%eax),%edx
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	89 10                	mov    %edx,(%eax)
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8b 00                	mov    (%eax),%eax
  800ff7:	83 e8 04             	sub    $0x4,%eax
  800ffa:	8b 00                	mov    (%eax),%eax
  800ffc:	99                   	cltd   
}
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    

00800fff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	56                   	push   %esi
  801003:	53                   	push   %ebx
  801004:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801007:	eb 17                	jmp    801020 <vprintfmt+0x21>
			if (ch == '\0')
  801009:	85 db                	test   %ebx,%ebx
  80100b:	0f 84 af 03 00 00    	je     8013c0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801011:	83 ec 08             	sub    $0x8,%esp
  801014:	ff 75 0c             	pushl  0xc(%ebp)
  801017:	53                   	push   %ebx
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	ff d0                	call   *%eax
  80101d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801020:	8b 45 10             	mov    0x10(%ebp),%eax
  801023:	8d 50 01             	lea    0x1(%eax),%edx
  801026:	89 55 10             	mov    %edx,0x10(%ebp)
  801029:	8a 00                	mov    (%eax),%al
  80102b:	0f b6 d8             	movzbl %al,%ebx
  80102e:	83 fb 25             	cmp    $0x25,%ebx
  801031:	75 d6                	jne    801009 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801033:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801037:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80103e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801045:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80104c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801053:	8b 45 10             	mov    0x10(%ebp),%eax
  801056:	8d 50 01             	lea    0x1(%eax),%edx
  801059:	89 55 10             	mov    %edx,0x10(%ebp)
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	0f b6 d8             	movzbl %al,%ebx
  801061:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801064:	83 f8 55             	cmp    $0x55,%eax
  801067:	0f 87 2b 03 00 00    	ja     801398 <vprintfmt+0x399>
  80106d:	8b 04 85 18 35 80 00 	mov    0x803518(,%eax,4),%eax
  801074:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801076:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80107a:	eb d7                	jmp    801053 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80107c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801080:	eb d1                	jmp    801053 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801082:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801089:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80108c:	89 d0                	mov    %edx,%eax
  80108e:	c1 e0 02             	shl    $0x2,%eax
  801091:	01 d0                	add    %edx,%eax
  801093:	01 c0                	add    %eax,%eax
  801095:	01 d8                	add    %ebx,%eax
  801097:	83 e8 30             	sub    $0x30,%eax
  80109a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80109d:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a0:	8a 00                	mov    (%eax),%al
  8010a2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8010a5:	83 fb 2f             	cmp    $0x2f,%ebx
  8010a8:	7e 3e                	jle    8010e8 <vprintfmt+0xe9>
  8010aa:	83 fb 39             	cmp    $0x39,%ebx
  8010ad:	7f 39                	jg     8010e8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8010af:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8010b2:	eb d5                	jmp    801089 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8010b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b7:	83 c0 04             	add    $0x4,%eax
  8010ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8010bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c0:	83 e8 04             	sub    $0x4,%eax
  8010c3:	8b 00                	mov    (%eax),%eax
  8010c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8010c8:	eb 1f                	jmp    8010e9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8010ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ce:	79 83                	jns    801053 <vprintfmt+0x54>
				width = 0;
  8010d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8010d7:	e9 77 ff ff ff       	jmp    801053 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8010dc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8010e3:	e9 6b ff ff ff       	jmp    801053 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8010e8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8010e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ed:	0f 89 60 ff ff ff    	jns    801053 <vprintfmt+0x54>
				width = precision, precision = -1;
  8010f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801100:	e9 4e ff ff ff       	jmp    801053 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801105:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801108:	e9 46 ff ff ff       	jmp    801053 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80110d:	8b 45 14             	mov    0x14(%ebp),%eax
  801110:	83 c0 04             	add    $0x4,%eax
  801113:	89 45 14             	mov    %eax,0x14(%ebp)
  801116:	8b 45 14             	mov    0x14(%ebp),%eax
  801119:	83 e8 04             	sub    $0x4,%eax
  80111c:	8b 00                	mov    (%eax),%eax
  80111e:	83 ec 08             	sub    $0x8,%esp
  801121:	ff 75 0c             	pushl  0xc(%ebp)
  801124:	50                   	push   %eax
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	ff d0                	call   *%eax
  80112a:	83 c4 10             	add    $0x10,%esp
			break;
  80112d:	e9 89 02 00 00       	jmp    8013bb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801132:	8b 45 14             	mov    0x14(%ebp),%eax
  801135:	83 c0 04             	add    $0x4,%eax
  801138:	89 45 14             	mov    %eax,0x14(%ebp)
  80113b:	8b 45 14             	mov    0x14(%ebp),%eax
  80113e:	83 e8 04             	sub    $0x4,%eax
  801141:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801143:	85 db                	test   %ebx,%ebx
  801145:	79 02                	jns    801149 <vprintfmt+0x14a>
				err = -err;
  801147:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801149:	83 fb 64             	cmp    $0x64,%ebx
  80114c:	7f 0b                	jg     801159 <vprintfmt+0x15a>
  80114e:	8b 34 9d 60 33 80 00 	mov    0x803360(,%ebx,4),%esi
  801155:	85 f6                	test   %esi,%esi
  801157:	75 19                	jne    801172 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801159:	53                   	push   %ebx
  80115a:	68 05 35 80 00       	push   $0x803505
  80115f:	ff 75 0c             	pushl  0xc(%ebp)
  801162:	ff 75 08             	pushl  0x8(%ebp)
  801165:	e8 5e 02 00 00       	call   8013c8 <printfmt>
  80116a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80116d:	e9 49 02 00 00       	jmp    8013bb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801172:	56                   	push   %esi
  801173:	68 0e 35 80 00       	push   $0x80350e
  801178:	ff 75 0c             	pushl  0xc(%ebp)
  80117b:	ff 75 08             	pushl  0x8(%ebp)
  80117e:	e8 45 02 00 00       	call   8013c8 <printfmt>
  801183:	83 c4 10             	add    $0x10,%esp
			break;
  801186:	e9 30 02 00 00       	jmp    8013bb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80118b:	8b 45 14             	mov    0x14(%ebp),%eax
  80118e:	83 c0 04             	add    $0x4,%eax
  801191:	89 45 14             	mov    %eax,0x14(%ebp)
  801194:	8b 45 14             	mov    0x14(%ebp),%eax
  801197:	83 e8 04             	sub    $0x4,%eax
  80119a:	8b 30                	mov    (%eax),%esi
  80119c:	85 f6                	test   %esi,%esi
  80119e:	75 05                	jne    8011a5 <vprintfmt+0x1a6>
				p = "(null)";
  8011a0:	be 11 35 80 00       	mov    $0x803511,%esi
			if (width > 0 && padc != '-')
  8011a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a9:	7e 6d                	jle    801218 <vprintfmt+0x219>
  8011ab:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8011af:	74 67                	je     801218 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8011b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011b4:	83 ec 08             	sub    $0x8,%esp
  8011b7:	50                   	push   %eax
  8011b8:	56                   	push   %esi
  8011b9:	e8 0c 03 00 00       	call   8014ca <strnlen>
  8011be:	83 c4 10             	add    $0x10,%esp
  8011c1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8011c4:	eb 16                	jmp    8011dc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8011c6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8011ca:	83 ec 08             	sub    $0x8,%esp
  8011cd:	ff 75 0c             	pushl  0xc(%ebp)
  8011d0:	50                   	push   %eax
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	ff d0                	call   *%eax
  8011d6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8011d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8011dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011e0:	7f e4                	jg     8011c6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011e2:	eb 34                	jmp    801218 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8011e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8011e8:	74 1c                	je     801206 <vprintfmt+0x207>
  8011ea:	83 fb 1f             	cmp    $0x1f,%ebx
  8011ed:	7e 05                	jle    8011f4 <vprintfmt+0x1f5>
  8011ef:	83 fb 7e             	cmp    $0x7e,%ebx
  8011f2:	7e 12                	jle    801206 <vprintfmt+0x207>
					putch('?', putdat);
  8011f4:	83 ec 08             	sub    $0x8,%esp
  8011f7:	ff 75 0c             	pushl  0xc(%ebp)
  8011fa:	6a 3f                	push   $0x3f
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	ff d0                	call   *%eax
  801201:	83 c4 10             	add    $0x10,%esp
  801204:	eb 0f                	jmp    801215 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801206:	83 ec 08             	sub    $0x8,%esp
  801209:	ff 75 0c             	pushl  0xc(%ebp)
  80120c:	53                   	push   %ebx
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	ff d0                	call   *%eax
  801212:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801215:	ff 4d e4             	decl   -0x1c(%ebp)
  801218:	89 f0                	mov    %esi,%eax
  80121a:	8d 70 01             	lea    0x1(%eax),%esi
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	0f be d8             	movsbl %al,%ebx
  801222:	85 db                	test   %ebx,%ebx
  801224:	74 24                	je     80124a <vprintfmt+0x24b>
  801226:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80122a:	78 b8                	js     8011e4 <vprintfmt+0x1e5>
  80122c:	ff 4d e0             	decl   -0x20(%ebp)
  80122f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801233:	79 af                	jns    8011e4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801235:	eb 13                	jmp    80124a <vprintfmt+0x24b>
				putch(' ', putdat);
  801237:	83 ec 08             	sub    $0x8,%esp
  80123a:	ff 75 0c             	pushl  0xc(%ebp)
  80123d:	6a 20                	push   $0x20
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	ff d0                	call   *%eax
  801244:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801247:	ff 4d e4             	decl   -0x1c(%ebp)
  80124a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80124e:	7f e7                	jg     801237 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801250:	e9 66 01 00 00       	jmp    8013bb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801255:	83 ec 08             	sub    $0x8,%esp
  801258:	ff 75 e8             	pushl  -0x18(%ebp)
  80125b:	8d 45 14             	lea    0x14(%ebp),%eax
  80125e:	50                   	push   %eax
  80125f:	e8 3c fd ff ff       	call   800fa0 <getint>
  801264:	83 c4 10             	add    $0x10,%esp
  801267:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80126a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80126d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801273:	85 d2                	test   %edx,%edx
  801275:	79 23                	jns    80129a <vprintfmt+0x29b>
				putch('-', putdat);
  801277:	83 ec 08             	sub    $0x8,%esp
  80127a:	ff 75 0c             	pushl  0xc(%ebp)
  80127d:	6a 2d                	push   $0x2d
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	ff d0                	call   *%eax
  801284:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128d:	f7 d8                	neg    %eax
  80128f:	83 d2 00             	adc    $0x0,%edx
  801292:	f7 da                	neg    %edx
  801294:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801297:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80129a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8012a1:	e9 bc 00 00 00       	jmp    801362 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8012ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8012af:	50                   	push   %eax
  8012b0:	e8 84 fc ff ff       	call   800f39 <getuint>
  8012b5:	83 c4 10             	add    $0x10,%esp
  8012b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8012be:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8012c5:	e9 98 00 00 00       	jmp    801362 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8012ca:	83 ec 08             	sub    $0x8,%esp
  8012cd:	ff 75 0c             	pushl  0xc(%ebp)
  8012d0:	6a 58                	push   $0x58
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	ff d0                	call   *%eax
  8012d7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	6a 58                	push   $0x58
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	ff d0                	call   *%eax
  8012e7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8012ea:	83 ec 08             	sub    $0x8,%esp
  8012ed:	ff 75 0c             	pushl  0xc(%ebp)
  8012f0:	6a 58                	push   $0x58
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	ff d0                	call   *%eax
  8012f7:	83 c4 10             	add    $0x10,%esp
			break;
  8012fa:	e9 bc 00 00 00       	jmp    8013bb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8012ff:	83 ec 08             	sub    $0x8,%esp
  801302:	ff 75 0c             	pushl  0xc(%ebp)
  801305:	6a 30                	push   $0x30
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	ff d0                	call   *%eax
  80130c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80130f:	83 ec 08             	sub    $0x8,%esp
  801312:	ff 75 0c             	pushl  0xc(%ebp)
  801315:	6a 78                	push   $0x78
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	ff d0                	call   *%eax
  80131c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80131f:	8b 45 14             	mov    0x14(%ebp),%eax
  801322:	83 c0 04             	add    $0x4,%eax
  801325:	89 45 14             	mov    %eax,0x14(%ebp)
  801328:	8b 45 14             	mov    0x14(%ebp),%eax
  80132b:	83 e8 04             	sub    $0x4,%eax
  80132e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801330:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801333:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80133a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801341:	eb 1f                	jmp    801362 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801343:	83 ec 08             	sub    $0x8,%esp
  801346:	ff 75 e8             	pushl  -0x18(%ebp)
  801349:	8d 45 14             	lea    0x14(%ebp),%eax
  80134c:	50                   	push   %eax
  80134d:	e8 e7 fb ff ff       	call   800f39 <getuint>
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801358:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80135b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801362:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801366:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801369:	83 ec 04             	sub    $0x4,%esp
  80136c:	52                   	push   %edx
  80136d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801370:	50                   	push   %eax
  801371:	ff 75 f4             	pushl  -0xc(%ebp)
  801374:	ff 75 f0             	pushl  -0x10(%ebp)
  801377:	ff 75 0c             	pushl  0xc(%ebp)
  80137a:	ff 75 08             	pushl  0x8(%ebp)
  80137d:	e8 00 fb ff ff       	call   800e82 <printnum>
  801382:	83 c4 20             	add    $0x20,%esp
			break;
  801385:	eb 34                	jmp    8013bb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801387:	83 ec 08             	sub    $0x8,%esp
  80138a:	ff 75 0c             	pushl  0xc(%ebp)
  80138d:	53                   	push   %ebx
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	ff d0                	call   *%eax
  801393:	83 c4 10             	add    $0x10,%esp
			break;
  801396:	eb 23                	jmp    8013bb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801398:	83 ec 08             	sub    $0x8,%esp
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	6a 25                	push   $0x25
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	ff d0                	call   *%eax
  8013a5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8013a8:	ff 4d 10             	decl   0x10(%ebp)
  8013ab:	eb 03                	jmp    8013b0 <vprintfmt+0x3b1>
  8013ad:	ff 4d 10             	decl   0x10(%ebp)
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	48                   	dec    %eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	3c 25                	cmp    $0x25,%al
  8013b8:	75 f3                	jne    8013ad <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8013ba:	90                   	nop
		}
	}
  8013bb:	e9 47 fc ff ff       	jmp    801007 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8013c0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8013c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013c4:	5b                   	pop    %ebx
  8013c5:	5e                   	pop    %esi
  8013c6:	5d                   	pop    %ebp
  8013c7:	c3                   	ret    

008013c8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8013ce:	8d 45 10             	lea    0x10(%ebp),%eax
  8013d1:	83 c0 04             	add    $0x4,%eax
  8013d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8013d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013da:	ff 75 f4             	pushl  -0xc(%ebp)
  8013dd:	50                   	push   %eax
  8013de:	ff 75 0c             	pushl  0xc(%ebp)
  8013e1:	ff 75 08             	pushl  0x8(%ebp)
  8013e4:	e8 16 fc ff ff       	call   800fff <vprintfmt>
  8013e9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8013ec:	90                   	nop
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8b 40 08             	mov    0x8(%eax),%eax
  8013f8:	8d 50 01             	lea    0x1(%eax),%edx
  8013fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fe:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801401:	8b 45 0c             	mov    0xc(%ebp),%eax
  801404:	8b 10                	mov    (%eax),%edx
  801406:	8b 45 0c             	mov    0xc(%ebp),%eax
  801409:	8b 40 04             	mov    0x4(%eax),%eax
  80140c:	39 c2                	cmp    %eax,%edx
  80140e:	73 12                	jae    801422 <sprintputch+0x33>
		*b->buf++ = ch;
  801410:	8b 45 0c             	mov    0xc(%ebp),%eax
  801413:	8b 00                	mov    (%eax),%eax
  801415:	8d 48 01             	lea    0x1(%eax),%ecx
  801418:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141b:	89 0a                	mov    %ecx,(%edx)
  80141d:	8b 55 08             	mov    0x8(%ebp),%edx
  801420:	88 10                	mov    %dl,(%eax)
}
  801422:	90                   	nop
  801423:	5d                   	pop    %ebp
  801424:	c3                   	ret    

00801425 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801431:	8b 45 0c             	mov    0xc(%ebp),%eax
  801434:	8d 50 ff             	lea    -0x1(%eax),%edx
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	01 d0                	add    %edx,%eax
  80143c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80143f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801446:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80144a:	74 06                	je     801452 <vsnprintf+0x2d>
  80144c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801450:	7f 07                	jg     801459 <vsnprintf+0x34>
		return -E_INVAL;
  801452:	b8 03 00 00 00       	mov    $0x3,%eax
  801457:	eb 20                	jmp    801479 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801459:	ff 75 14             	pushl  0x14(%ebp)
  80145c:	ff 75 10             	pushl  0x10(%ebp)
  80145f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801462:	50                   	push   %eax
  801463:	68 ef 13 80 00       	push   $0x8013ef
  801468:	e8 92 fb ff ff       	call   800fff <vprintfmt>
  80146d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801470:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801473:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801476:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801481:	8d 45 10             	lea    0x10(%ebp),%eax
  801484:	83 c0 04             	add    $0x4,%eax
  801487:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	ff 75 f4             	pushl  -0xc(%ebp)
  801490:	50                   	push   %eax
  801491:	ff 75 0c             	pushl  0xc(%ebp)
  801494:	ff 75 08             	pushl  0x8(%ebp)
  801497:	e8 89 ff ff ff       	call   801425 <vsnprintf>
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8014a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    

008014a7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014b4:	eb 06                	jmp    8014bc <strlen+0x15>
		n++;
  8014b6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014b9:	ff 45 08             	incl   0x8(%ebp)
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	84 c0                	test   %al,%al
  8014c3:	75 f1                	jne    8014b6 <strlen+0xf>
		n++;
	return n;
  8014c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014d7:	eb 09                	jmp    8014e2 <strnlen+0x18>
		n++;
  8014d9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014dc:	ff 45 08             	incl   0x8(%ebp)
  8014df:	ff 4d 0c             	decl   0xc(%ebp)
  8014e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014e6:	74 09                	je     8014f1 <strnlen+0x27>
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	84 c0                	test   %al,%al
  8014ef:	75 e8                	jne    8014d9 <strnlen+0xf>
		n++;
	return n;
  8014f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801502:	90                   	nop
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	8d 50 01             	lea    0x1(%eax),%edx
  801509:	89 55 08             	mov    %edx,0x8(%ebp)
  80150c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801512:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801515:	8a 12                	mov    (%edx),%dl
  801517:	88 10                	mov    %dl,(%eax)
  801519:	8a 00                	mov    (%eax),%al
  80151b:	84 c0                	test   %al,%al
  80151d:	75 e4                	jne    801503 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80151f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801530:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801537:	eb 1f                	jmp    801558 <strncpy+0x34>
		*dst++ = *src;
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	8d 50 01             	lea    0x1(%eax),%edx
  80153f:	89 55 08             	mov    %edx,0x8(%ebp)
  801542:	8b 55 0c             	mov    0xc(%ebp),%edx
  801545:	8a 12                	mov    (%edx),%dl
  801547:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8a 00                	mov    (%eax),%al
  80154e:	84 c0                	test   %al,%al
  801550:	74 03                	je     801555 <strncpy+0x31>
			src++;
  801552:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801555:	ff 45 fc             	incl   -0x4(%ebp)
  801558:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80155e:	72 d9                	jb     801539 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801560:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801571:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801575:	74 30                	je     8015a7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801577:	eb 16                	jmp    80158f <strlcpy+0x2a>
			*dst++ = *src++;
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8d 50 01             	lea    0x1(%eax),%edx
  80157f:	89 55 08             	mov    %edx,0x8(%ebp)
  801582:	8b 55 0c             	mov    0xc(%ebp),%edx
  801585:	8d 4a 01             	lea    0x1(%edx),%ecx
  801588:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80158b:	8a 12                	mov    (%edx),%dl
  80158d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80158f:	ff 4d 10             	decl   0x10(%ebp)
  801592:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801596:	74 09                	je     8015a1 <strlcpy+0x3c>
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	8a 00                	mov    (%eax),%al
  80159d:	84 c0                	test   %al,%al
  80159f:	75 d8                	jne    801579 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8015aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ad:	29 c2                	sub    %eax,%edx
  8015af:	89 d0                	mov    %edx,%eax
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015b6:	eb 06                	jmp    8015be <strcmp+0xb>
		p++, q++;
  8015b8:	ff 45 08             	incl   0x8(%ebp)
  8015bb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	8a 00                	mov    (%eax),%al
  8015c3:	84 c0                	test   %al,%al
  8015c5:	74 0e                	je     8015d5 <strcmp+0x22>
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	8a 10                	mov    (%eax),%dl
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	38 c2                	cmp    %al,%dl
  8015d3:	74 e3                	je     8015b8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	8a 00                	mov    (%eax),%al
  8015da:	0f b6 d0             	movzbl %al,%edx
  8015dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e0:	8a 00                	mov    (%eax),%al
  8015e2:	0f b6 c0             	movzbl %al,%eax
  8015e5:	29 c2                	sub    %eax,%edx
  8015e7:	89 d0                	mov    %edx,%eax
}
  8015e9:	5d                   	pop    %ebp
  8015ea:	c3                   	ret    

008015eb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8015ee:	eb 09                	jmp    8015f9 <strncmp+0xe>
		n--, p++, q++;
  8015f0:	ff 4d 10             	decl   0x10(%ebp)
  8015f3:	ff 45 08             	incl   0x8(%ebp)
  8015f6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8015f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015fd:	74 17                	je     801616 <strncmp+0x2b>
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	8a 00                	mov    (%eax),%al
  801604:	84 c0                	test   %al,%al
  801606:	74 0e                	je     801616 <strncmp+0x2b>
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 10                	mov    (%eax),%dl
  80160d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	38 c2                	cmp    %al,%dl
  801614:	74 da                	je     8015f0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801616:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80161a:	75 07                	jne    801623 <strncmp+0x38>
		return 0;
  80161c:	b8 00 00 00 00       	mov    $0x0,%eax
  801621:	eb 14                	jmp    801637 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	0f b6 d0             	movzbl %al,%edx
  80162b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	0f b6 c0             	movzbl %al,%eax
  801633:	29 c2                	sub    %eax,%edx
  801635:	89 d0                	mov    %edx,%eax
}
  801637:	5d                   	pop    %ebp
  801638:	c3                   	ret    

00801639 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801642:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801645:	eb 12                	jmp    801659 <strchr+0x20>
		if (*s == c)
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80164f:	75 05                	jne    801656 <strchr+0x1d>
			return (char *) s;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	eb 11                	jmp    801667 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801656:	ff 45 08             	incl   0x8(%ebp)
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	8a 00                	mov    (%eax),%al
  80165e:	84 c0                	test   %al,%al
  801660:	75 e5                	jne    801647 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801662:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 04             	sub    $0x4,%esp
  80166f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801672:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801675:	eb 0d                	jmp    801684 <strfind+0x1b>
		if (*s == c)
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	8a 00                	mov    (%eax),%al
  80167c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80167f:	74 0e                	je     80168f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801681:	ff 45 08             	incl   0x8(%ebp)
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	84 c0                	test   %al,%al
  80168b:	75 ea                	jne    801677 <strfind+0xe>
  80168d:	eb 01                	jmp    801690 <strfind+0x27>
		if (*s == c)
			break;
  80168f:	90                   	nop
	return (char *) s;
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016a7:	eb 0e                	jmp    8016b7 <memset+0x22>
		*p++ = c;
  8016a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ac:	8d 50 01             	lea    0x1(%eax),%edx
  8016af:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016b7:	ff 4d f8             	decl   -0x8(%ebp)
  8016ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016be:	79 e9                	jns    8016a9 <memset+0x14>
		*p++ = c;

	return v;
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8016d7:	eb 16                	jmp    8016ef <memcpy+0x2a>
		*d++ = *s++;
  8016d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dc:	8d 50 01             	lea    0x1(%eax),%edx
  8016df:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016e8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016eb:	8a 12                	mov    (%edx),%dl
  8016ed:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8016ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f8:	85 c0                	test   %eax,%eax
  8016fa:	75 dd                	jne    8016d9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801707:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801713:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801716:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801719:	73 50                	jae    80176b <memmove+0x6a>
  80171b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171e:	8b 45 10             	mov    0x10(%ebp),%eax
  801721:	01 d0                	add    %edx,%eax
  801723:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801726:	76 43                	jbe    80176b <memmove+0x6a>
		s += n;
  801728:	8b 45 10             	mov    0x10(%ebp),%eax
  80172b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80172e:	8b 45 10             	mov    0x10(%ebp),%eax
  801731:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801734:	eb 10                	jmp    801746 <memmove+0x45>
			*--d = *--s;
  801736:	ff 4d f8             	decl   -0x8(%ebp)
  801739:	ff 4d fc             	decl   -0x4(%ebp)
  80173c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80173f:	8a 10                	mov    (%eax),%dl
  801741:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801744:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801746:	8b 45 10             	mov    0x10(%ebp),%eax
  801749:	8d 50 ff             	lea    -0x1(%eax),%edx
  80174c:	89 55 10             	mov    %edx,0x10(%ebp)
  80174f:	85 c0                	test   %eax,%eax
  801751:	75 e3                	jne    801736 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801753:	eb 23                	jmp    801778 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801755:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801758:	8d 50 01             	lea    0x1(%eax),%edx
  80175b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80175e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801761:	8d 4a 01             	lea    0x1(%edx),%ecx
  801764:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801767:	8a 12                	mov    (%edx),%dl
  801769:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80176b:	8b 45 10             	mov    0x10(%ebp),%eax
  80176e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801771:	89 55 10             	mov    %edx,0x10(%ebp)
  801774:	85 c0                	test   %eax,%eax
  801776:	75 dd                	jne    801755 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
  801786:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801789:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80178f:	eb 2a                	jmp    8017bb <memcmp+0x3e>
		if (*s1 != *s2)
  801791:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801794:	8a 10                	mov    (%eax),%dl
  801796:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	38 c2                	cmp    %al,%dl
  80179d:	74 16                	je     8017b5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80179f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	0f b6 d0             	movzbl %al,%edx
  8017a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017aa:	8a 00                	mov    (%eax),%al
  8017ac:	0f b6 c0             	movzbl %al,%eax
  8017af:	29 c2                	sub    %eax,%edx
  8017b1:	89 d0                	mov    %edx,%eax
  8017b3:	eb 18                	jmp    8017cd <memcmp+0x50>
		s1++, s2++;
  8017b5:	ff 45 fc             	incl   -0x4(%ebp)
  8017b8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017be:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017c1:	89 55 10             	mov    %edx,0x10(%ebp)
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	75 c9                	jne    801791 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8017d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017db:	01 d0                	add    %edx,%eax
  8017dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8017e0:	eb 15                	jmp    8017f7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	0f b6 d0             	movzbl %al,%edx
  8017ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ed:	0f b6 c0             	movzbl %al,%eax
  8017f0:	39 c2                	cmp    %eax,%edx
  8017f2:	74 0d                	je     801801 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017f4:	ff 45 08             	incl   0x8(%ebp)
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017fd:	72 e3                	jb     8017e2 <memfind+0x13>
  8017ff:	eb 01                	jmp    801802 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801801:	90                   	nop
	return (void *) s;
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80180d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801814:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80181b:	eb 03                	jmp    801820 <strtol+0x19>
		s++;
  80181d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	8a 00                	mov    (%eax),%al
  801825:	3c 20                	cmp    $0x20,%al
  801827:	74 f4                	je     80181d <strtol+0x16>
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8a 00                	mov    (%eax),%al
  80182e:	3c 09                	cmp    $0x9,%al
  801830:	74 eb                	je     80181d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	8a 00                	mov    (%eax),%al
  801837:	3c 2b                	cmp    $0x2b,%al
  801839:	75 05                	jne    801840 <strtol+0x39>
		s++;
  80183b:	ff 45 08             	incl   0x8(%ebp)
  80183e:	eb 13                	jmp    801853 <strtol+0x4c>
	else if (*s == '-')
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	3c 2d                	cmp    $0x2d,%al
  801847:	75 0a                	jne    801853 <strtol+0x4c>
		s++, neg = 1;
  801849:	ff 45 08             	incl   0x8(%ebp)
  80184c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801853:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801857:	74 06                	je     80185f <strtol+0x58>
  801859:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80185d:	75 20                	jne    80187f <strtol+0x78>
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	3c 30                	cmp    $0x30,%al
  801866:	75 17                	jne    80187f <strtol+0x78>
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	40                   	inc    %eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	3c 78                	cmp    $0x78,%al
  801870:	75 0d                	jne    80187f <strtol+0x78>
		s += 2, base = 16;
  801872:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801876:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80187d:	eb 28                	jmp    8018a7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80187f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801883:	75 15                	jne    80189a <strtol+0x93>
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	8a 00                	mov    (%eax),%al
  80188a:	3c 30                	cmp    $0x30,%al
  80188c:	75 0c                	jne    80189a <strtol+0x93>
		s++, base = 8;
  80188e:	ff 45 08             	incl   0x8(%ebp)
  801891:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801898:	eb 0d                	jmp    8018a7 <strtol+0xa0>
	else if (base == 0)
  80189a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80189e:	75 07                	jne    8018a7 <strtol+0xa0>
		base = 10;
  8018a0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	8a 00                	mov    (%eax),%al
  8018ac:	3c 2f                	cmp    $0x2f,%al
  8018ae:	7e 19                	jle    8018c9 <strtol+0xc2>
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	8a 00                	mov    (%eax),%al
  8018b5:	3c 39                	cmp    $0x39,%al
  8018b7:	7f 10                	jg     8018c9 <strtol+0xc2>
			dig = *s - '0';
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	8a 00                	mov    (%eax),%al
  8018be:	0f be c0             	movsbl %al,%eax
  8018c1:	83 e8 30             	sub    $0x30,%eax
  8018c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018c7:	eb 42                	jmp    80190b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8a 00                	mov    (%eax),%al
  8018ce:	3c 60                	cmp    $0x60,%al
  8018d0:	7e 19                	jle    8018eb <strtol+0xe4>
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	8a 00                	mov    (%eax),%al
  8018d7:	3c 7a                	cmp    $0x7a,%al
  8018d9:	7f 10                	jg     8018eb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	8a 00                	mov    (%eax),%al
  8018e0:	0f be c0             	movsbl %al,%eax
  8018e3:	83 e8 57             	sub    $0x57,%eax
  8018e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018e9:	eb 20                	jmp    80190b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	8a 00                	mov    (%eax),%al
  8018f0:	3c 40                	cmp    $0x40,%al
  8018f2:	7e 39                	jle    80192d <strtol+0x126>
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	8a 00                	mov    (%eax),%al
  8018f9:	3c 5a                	cmp    $0x5a,%al
  8018fb:	7f 30                	jg     80192d <strtol+0x126>
			dig = *s - 'A' + 10;
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	8a 00                	mov    (%eax),%al
  801902:	0f be c0             	movsbl %al,%eax
  801905:	83 e8 37             	sub    $0x37,%eax
  801908:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80190b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801911:	7d 19                	jge    80192c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801913:	ff 45 08             	incl   0x8(%ebp)
  801916:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801919:	0f af 45 10          	imul   0x10(%ebp),%eax
  80191d:	89 c2                	mov    %eax,%edx
  80191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801922:	01 d0                	add    %edx,%eax
  801924:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801927:	e9 7b ff ff ff       	jmp    8018a7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80192c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80192d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801931:	74 08                	je     80193b <strtol+0x134>
		*endptr = (char *) s;
  801933:	8b 45 0c             	mov    0xc(%ebp),%eax
  801936:	8b 55 08             	mov    0x8(%ebp),%edx
  801939:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80193b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80193f:	74 07                	je     801948 <strtol+0x141>
  801941:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801944:	f7 d8                	neg    %eax
  801946:	eb 03                	jmp    80194b <strtol+0x144>
  801948:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <ltostr>:

void
ltostr(long value, char *str)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801953:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80195a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801961:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801965:	79 13                	jns    80197a <ltostr+0x2d>
	{
		neg = 1;
  801967:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80196e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801971:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801974:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801977:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801982:	99                   	cltd   
  801983:	f7 f9                	idiv   %ecx
  801985:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801988:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80198b:	8d 50 01             	lea    0x1(%eax),%edx
  80198e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801991:	89 c2                	mov    %eax,%edx
  801993:	8b 45 0c             	mov    0xc(%ebp),%eax
  801996:	01 d0                	add    %edx,%eax
  801998:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80199b:	83 c2 30             	add    $0x30,%edx
  80199e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019a3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019a8:	f7 e9                	imul   %ecx
  8019aa:	c1 fa 02             	sar    $0x2,%edx
  8019ad:	89 c8                	mov    %ecx,%eax
  8019af:	c1 f8 1f             	sar    $0x1f,%eax
  8019b2:	29 c2                	sub    %eax,%edx
  8019b4:	89 d0                	mov    %edx,%eax
  8019b6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8019b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019c1:	f7 e9                	imul   %ecx
  8019c3:	c1 fa 02             	sar    $0x2,%edx
  8019c6:	89 c8                	mov    %ecx,%eax
  8019c8:	c1 f8 1f             	sar    $0x1f,%eax
  8019cb:	29 c2                	sub    %eax,%edx
  8019cd:	89 d0                	mov    %edx,%eax
  8019cf:	c1 e0 02             	shl    $0x2,%eax
  8019d2:	01 d0                	add    %edx,%eax
  8019d4:	01 c0                	add    %eax,%eax
  8019d6:	29 c1                	sub    %eax,%ecx
  8019d8:	89 ca                	mov    %ecx,%edx
  8019da:	85 d2                	test   %edx,%edx
  8019dc:	75 9c                	jne    80197a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8019de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8019e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019e8:	48                   	dec    %eax
  8019e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8019ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019f0:	74 3d                	je     801a2f <ltostr+0xe2>
		start = 1 ;
  8019f2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8019f9:	eb 34                	jmp    801a2f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8019fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a01:	01 d0                	add    %edx,%eax
  801a03:	8a 00                	mov    (%eax),%al
  801a05:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0e:	01 c2                	add    %eax,%edx
  801a10:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a16:	01 c8                	add    %ecx,%eax
  801a18:	8a 00                	mov    (%eax),%al
  801a1a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a22:	01 c2                	add    %eax,%edx
  801a24:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a27:	88 02                	mov    %al,(%edx)
		start++ ;
  801a29:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a2c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a32:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a35:	7c c4                	jl     8019fb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a37:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3d:	01 d0                	add    %edx,%eax
  801a3f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a42:	90                   	nop
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a4b:	ff 75 08             	pushl  0x8(%ebp)
  801a4e:	e8 54 fa ff ff       	call   8014a7 <strlen>
  801a53:	83 c4 04             	add    $0x4,%esp
  801a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a59:	ff 75 0c             	pushl  0xc(%ebp)
  801a5c:	e8 46 fa ff ff       	call   8014a7 <strlen>
  801a61:	83 c4 04             	add    $0x4,%esp
  801a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a75:	eb 17                	jmp    801a8e <strcconcat+0x49>
		final[s] = str1[s] ;
  801a77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7d:	01 c2                	add    %eax,%edx
  801a7f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	01 c8                	add    %ecx,%eax
  801a87:	8a 00                	mov    (%eax),%al
  801a89:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a8b:	ff 45 fc             	incl   -0x4(%ebp)
  801a8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a91:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a94:	7c e1                	jl     801a77 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a96:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a9d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801aa4:	eb 1f                	jmp    801ac5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801aa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa9:	8d 50 01             	lea    0x1(%eax),%edx
  801aac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801aaf:	89 c2                	mov    %eax,%edx
  801ab1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab4:	01 c2                	add    %eax,%edx
  801ab6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abc:	01 c8                	add    %ecx,%eax
  801abe:	8a 00                	mov    (%eax),%al
  801ac0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801ac2:	ff 45 f8             	incl   -0x8(%ebp)
  801ac5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801acb:	7c d9                	jl     801aa6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801acd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad3:	01 d0                	add    %edx,%eax
  801ad5:	c6 00 00             	movb   $0x0,(%eax)
}
  801ad8:	90                   	nop
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ade:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aea:	8b 00                	mov    (%eax),%eax
  801aec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af3:	8b 45 10             	mov    0x10(%ebp),%eax
  801af6:	01 d0                	add    %edx,%eax
  801af8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801afe:	eb 0c                	jmp    801b0c <strsplit+0x31>
			*string++ = 0;
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	8d 50 01             	lea    0x1(%eax),%edx
  801b06:	89 55 08             	mov    %edx,0x8(%ebp)
  801b09:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	8a 00                	mov    (%eax),%al
  801b11:	84 c0                	test   %al,%al
  801b13:	74 18                	je     801b2d <strsplit+0x52>
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	8a 00                	mov    (%eax),%al
  801b1a:	0f be c0             	movsbl %al,%eax
  801b1d:	50                   	push   %eax
  801b1e:	ff 75 0c             	pushl  0xc(%ebp)
  801b21:	e8 13 fb ff ff       	call   801639 <strchr>
  801b26:	83 c4 08             	add    $0x8,%esp
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	75 d3                	jne    801b00 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	8a 00                	mov    (%eax),%al
  801b32:	84 c0                	test   %al,%al
  801b34:	74 5a                	je     801b90 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b36:	8b 45 14             	mov    0x14(%ebp),%eax
  801b39:	8b 00                	mov    (%eax),%eax
  801b3b:	83 f8 0f             	cmp    $0xf,%eax
  801b3e:	75 07                	jne    801b47 <strsplit+0x6c>
		{
			return 0;
  801b40:	b8 00 00 00 00       	mov    $0x0,%eax
  801b45:	eb 66                	jmp    801bad <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b47:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4a:	8b 00                	mov    (%eax),%eax
  801b4c:	8d 48 01             	lea    0x1(%eax),%ecx
  801b4f:	8b 55 14             	mov    0x14(%ebp),%edx
  801b52:	89 0a                	mov    %ecx,(%edx)
  801b54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5e:	01 c2                	add    %eax,%edx
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b65:	eb 03                	jmp    801b6a <strsplit+0x8f>
			string++;
  801b67:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	8a 00                	mov    (%eax),%al
  801b6f:	84 c0                	test   %al,%al
  801b71:	74 8b                	je     801afe <strsplit+0x23>
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	8a 00                	mov    (%eax),%al
  801b78:	0f be c0             	movsbl %al,%eax
  801b7b:	50                   	push   %eax
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	e8 b5 fa ff ff       	call   801639 <strchr>
  801b84:	83 c4 08             	add    $0x8,%esp
  801b87:	85 c0                	test   %eax,%eax
  801b89:	74 dc                	je     801b67 <strsplit+0x8c>
			string++;
	}
  801b8b:	e9 6e ff ff ff       	jmp    801afe <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b90:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b91:	8b 45 14             	mov    0x14(%ebp),%eax
  801b94:	8b 00                	mov    (%eax),%eax
  801b96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba0:	01 d0                	add    %edx,%eax
  801ba2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ba8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801bb5:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801bbc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbf:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801bc2:	01 d0                	add    %edx,%eax
  801bc4:	48                   	dec    %eax
  801bc5:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801bc8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd0:	f7 75 ac             	divl   -0x54(%ebp)
  801bd3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801bd6:	29 d0                	sub    %edx,%eax
  801bd8:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801bdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801be2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801be9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801bf0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801bf7:	eb 3f                	jmp    801c38 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801bf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bfc:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801c03:	83 ec 04             	sub    $0x4,%esp
  801c06:	50                   	push   %eax
  801c07:	ff 75 e8             	pushl  -0x18(%ebp)
  801c0a:	68 70 36 80 00       	push   $0x803670
  801c0f:	e8 11 f2 ff ff       	call   800e25 <cprintf>
  801c14:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801c17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c1a:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	50                   	push   %eax
  801c25:	ff 75 e8             	pushl  -0x18(%ebp)
  801c28:	68 85 36 80 00       	push   $0x803685
  801c2d:	e8 f3 f1 ff ff       	call   800e25 <cprintf>
  801c32:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801c35:	ff 45 e8             	incl   -0x18(%ebp)
  801c38:	a1 28 40 80 00       	mov    0x804028,%eax
  801c3d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801c40:	7c b7                	jl     801bf9 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801c42:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801c49:	e9 42 01 00 00       	jmp    801d90 <malloc+0x1e1>
		int flag0=1;
  801c4e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c58:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c5b:	eb 6b                	jmp    801cc8 <malloc+0x119>
			for(int k=0;k<count;k++){
  801c5d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801c64:	eb 42                	jmp    801ca8 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801c66:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c69:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801c70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c73:	39 c2                	cmp    %eax,%edx
  801c75:	77 2e                	ja     801ca5 <malloc+0xf6>
  801c77:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c7a:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801c81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c84:	39 c2                	cmp    %eax,%edx
  801c86:	76 1d                	jbe    801ca5 <malloc+0xf6>
					ni=arr_add[k].end-i;
  801c88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c8b:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801c92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c95:	29 c2                	sub    %eax,%edx
  801c97:	89 d0                	mov    %edx,%eax
  801c99:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801c9c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801ca3:	eb 0d                	jmp    801cb2 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801ca5:	ff 45 d8             	incl   -0x28(%ebp)
  801ca8:	a1 28 40 80 00       	mov    0x804028,%eax
  801cad:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801cb0:	7c b4                	jl     801c66 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801cb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cb6:	74 09                	je     801cc1 <malloc+0x112>
				flag0=0;
  801cb8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801cbf:	eb 16                	jmp    801cd7 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801cc1:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801cc8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	01 c2                	add    %eax,%edx
  801cd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cd3:	39 c2                	cmp    %eax,%edx
  801cd5:	77 86                	ja     801c5d <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801cd7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cdb:	0f 84 a2 00 00 00    	je     801d83 <malloc+0x1d4>

			int f=1;
  801ce1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801ce8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ceb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801cee:	89 c8                	mov    %ecx,%eax
  801cf0:	01 c0                	add    %eax,%eax
  801cf2:	01 c8                	add    %ecx,%eax
  801cf4:	c1 e0 02             	shl    $0x2,%eax
  801cf7:	05 20 41 80 00       	add    $0x804120,%eax
  801cfc:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801cfe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801d07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d0a:	89 d0                	mov    %edx,%eax
  801d0c:	01 c0                	add    %eax,%eax
  801d0e:	01 d0                	add    %edx,%eax
  801d10:	c1 e0 02             	shl    $0x2,%eax
  801d13:	05 24 41 80 00       	add    $0x804124,%eax
  801d18:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801d1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d1d:	89 d0                	mov    %edx,%eax
  801d1f:	01 c0                	add    %eax,%eax
  801d21:	01 d0                	add    %edx,%eax
  801d23:	c1 e0 02             	shl    $0x2,%eax
  801d26:	05 28 41 80 00       	add    $0x804128,%eax
  801d2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801d31:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801d34:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801d3b:	eb 36                	jmp    801d73 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801d3d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d40:	8b 45 08             	mov    0x8(%ebp),%eax
  801d43:	01 c2                	add    %eax,%edx
  801d45:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d48:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801d4f:	39 c2                	cmp    %eax,%edx
  801d51:	73 1d                	jae    801d70 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801d53:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d56:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801d5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d60:	29 c2                	sub    %eax,%edx
  801d62:	89 d0                	mov    %edx,%eax
  801d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801d67:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801d6e:	eb 0d                	jmp    801d7d <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801d70:	ff 45 d0             	incl   -0x30(%ebp)
  801d73:	a1 28 40 80 00       	mov    0x804028,%eax
  801d78:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801d7b:	7c c0                	jl     801d3d <malloc+0x18e>
					break;

				}
			}

			if(f){
  801d7d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801d81:	75 1d                	jne    801da0 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801d83:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801d8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d8d:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801d90:	a1 04 40 80 00       	mov    0x804004,%eax
  801d95:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d98:	0f 8c b0 fe ff ff    	jl     801c4e <malloc+0x9f>
  801d9e:	eb 01                	jmp    801da1 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801da0:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801da1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da5:	75 7a                	jne    801e21 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801da7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801dad:	8b 45 08             	mov    0x8(%ebp),%eax
  801db0:	01 d0                	add    %edx,%eax
  801db2:	48                   	dec    %eax
  801db3:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801db8:	7c 0a                	jl     801dc4 <malloc+0x215>
			return NULL;
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbf:	e9 a4 02 00 00       	jmp    802068 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801dc4:	a1 04 40 80 00       	mov    0x804004,%eax
  801dc9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801dcc:	a1 28 40 80 00       	mov    0x804028,%eax
  801dd1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801dd4:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801ddb:	83 ec 08             	sub    $0x8,%esp
  801dde:	ff 75 08             	pushl  0x8(%ebp)
  801de1:	ff 75 a4             	pushl  -0x5c(%ebp)
  801de4:	e8 04 06 00 00       	call   8023ed <sys_allocateMem>
  801de9:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801dec:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	01 d0                	add    %edx,%eax
  801df7:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801dfc:	a1 28 40 80 00       	mov    0x804028,%eax
  801e01:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801e07:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801e0e:	a1 28 40 80 00       	mov    0x804028,%eax
  801e13:	40                   	inc    %eax
  801e14:	a3 28 40 80 00       	mov    %eax,0x804028

			return (void*)s;
  801e19:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801e1c:	e9 47 02 00 00       	jmp    802068 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801e21:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801e28:	e9 ac 00 00 00       	jmp    801ed9 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801e2d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801e30:	89 d0                	mov    %edx,%eax
  801e32:	01 c0                	add    %eax,%eax
  801e34:	01 d0                	add    %edx,%eax
  801e36:	c1 e0 02             	shl    $0x2,%eax
  801e39:	05 24 41 80 00       	add    $0x804124,%eax
  801e3e:	8b 00                	mov    (%eax),%eax
  801e40:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801e43:	eb 7e                	jmp    801ec3 <malloc+0x314>
			int flag=0;
  801e45:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801e4c:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801e53:	eb 57                	jmp    801eac <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801e55:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e58:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801e5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e62:	39 c2                	cmp    %eax,%edx
  801e64:	77 1a                	ja     801e80 <malloc+0x2d1>
  801e66:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e69:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801e70:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e73:	39 c2                	cmp    %eax,%edx
  801e75:	76 09                	jbe    801e80 <malloc+0x2d1>
								flag=1;
  801e77:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801e7e:	eb 36                	jmp    801eb6 <malloc+0x307>
			arr[i].space++;
  801e80:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801e83:	89 d0                	mov    %edx,%eax
  801e85:	01 c0                	add    %eax,%eax
  801e87:	01 d0                	add    %edx,%eax
  801e89:	c1 e0 02             	shl    $0x2,%eax
  801e8c:	05 28 41 80 00       	add    $0x804128,%eax
  801e91:	8b 00                	mov    (%eax),%eax
  801e93:	8d 48 01             	lea    0x1(%eax),%ecx
  801e96:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801e99:	89 d0                	mov    %edx,%eax
  801e9b:	01 c0                	add    %eax,%eax
  801e9d:	01 d0                	add    %edx,%eax
  801e9f:	c1 e0 02             	shl    $0x2,%eax
  801ea2:	05 28 41 80 00       	add    $0x804128,%eax
  801ea7:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801ea9:	ff 45 c0             	incl   -0x40(%ebp)
  801eac:	a1 28 40 80 00       	mov    0x804028,%eax
  801eb1:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801eb4:	7c 9f                	jl     801e55 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801eb6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801eba:	75 19                	jne    801ed5 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801ebc:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801ec3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801ec6:	a1 04 40 80 00       	mov    0x804004,%eax
  801ecb:	39 c2                	cmp    %eax,%edx
  801ecd:	0f 82 72 ff ff ff    	jb     801e45 <malloc+0x296>
  801ed3:	eb 01                	jmp    801ed6 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801ed5:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801ed6:	ff 45 cc             	incl   -0x34(%ebp)
  801ed9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801edc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801edf:	0f 8c 48 ff ff ff    	jl     801e2d <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801ee5:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801eec:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801ef3:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801efa:	eb 37                	jmp    801f33 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801efc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801eff:	89 d0                	mov    %edx,%eax
  801f01:	01 c0                	add    %eax,%eax
  801f03:	01 d0                	add    %edx,%eax
  801f05:	c1 e0 02             	shl    $0x2,%eax
  801f08:	05 28 41 80 00       	add    $0x804128,%eax
  801f0d:	8b 00                	mov    (%eax),%eax
  801f0f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801f12:	7d 1c                	jge    801f30 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801f14:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801f17:	89 d0                	mov    %edx,%eax
  801f19:	01 c0                	add    %eax,%eax
  801f1b:	01 d0                	add    %edx,%eax
  801f1d:	c1 e0 02             	shl    $0x2,%eax
  801f20:	05 28 41 80 00       	add    $0x804128,%eax
  801f25:	8b 00                	mov    (%eax),%eax
  801f27:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801f2a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801f2d:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801f30:	ff 45 b4             	incl   -0x4c(%ebp)
  801f33:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801f36:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f39:	7c c1                	jl     801efc <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801f3b:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801f41:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801f44:	89 c8                	mov    %ecx,%eax
  801f46:	01 c0                	add    %eax,%eax
  801f48:	01 c8                	add    %ecx,%eax
  801f4a:	c1 e0 02             	shl    $0x2,%eax
  801f4d:	05 20 41 80 00       	add    $0x804120,%eax
  801f52:	8b 00                	mov    (%eax),%eax
  801f54:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801f5b:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801f61:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801f64:	89 c8                	mov    %ecx,%eax
  801f66:	01 c0                	add    %eax,%eax
  801f68:	01 c8                	add    %ecx,%eax
  801f6a:	c1 e0 02             	shl    $0x2,%eax
  801f6d:	05 24 41 80 00       	add    $0x804124,%eax
  801f72:	8b 00                	mov    (%eax),%eax
  801f74:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  801f7b:	a1 28 40 80 00       	mov    0x804028,%eax
  801f80:	40                   	inc    %eax
  801f81:	a3 28 40 80 00       	mov    %eax,0x804028


		sys_allocateMem(arr[index].start,size);
  801f86:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801f89:	89 d0                	mov    %edx,%eax
  801f8b:	01 c0                	add    %eax,%eax
  801f8d:	01 d0                	add    %edx,%eax
  801f8f:	c1 e0 02             	shl    $0x2,%eax
  801f92:	05 20 41 80 00       	add    $0x804120,%eax
  801f97:	8b 00                	mov    (%eax),%eax
  801f99:	83 ec 08             	sub    $0x8,%esp
  801f9c:	ff 75 08             	pushl  0x8(%ebp)
  801f9f:	50                   	push   %eax
  801fa0:	e8 48 04 00 00       	call   8023ed <sys_allocateMem>
  801fa5:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801fa8:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801faf:	eb 78                	jmp    802029 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801fb1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801fb4:	89 d0                	mov    %edx,%eax
  801fb6:	01 c0                	add    %eax,%eax
  801fb8:	01 d0                	add    %edx,%eax
  801fba:	c1 e0 02             	shl    $0x2,%eax
  801fbd:	05 20 41 80 00       	add    $0x804120,%eax
  801fc2:	8b 00                	mov    (%eax),%eax
  801fc4:	83 ec 04             	sub    $0x4,%esp
  801fc7:	50                   	push   %eax
  801fc8:	ff 75 b0             	pushl  -0x50(%ebp)
  801fcb:	68 70 36 80 00       	push   $0x803670
  801fd0:	e8 50 ee ff ff       	call   800e25 <cprintf>
  801fd5:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801fd8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801fdb:	89 d0                	mov    %edx,%eax
  801fdd:	01 c0                	add    %eax,%eax
  801fdf:	01 d0                	add    %edx,%eax
  801fe1:	c1 e0 02             	shl    $0x2,%eax
  801fe4:	05 24 41 80 00       	add    $0x804124,%eax
  801fe9:	8b 00                	mov    (%eax),%eax
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	50                   	push   %eax
  801fef:	ff 75 b0             	pushl  -0x50(%ebp)
  801ff2:	68 85 36 80 00       	push   $0x803685
  801ff7:	e8 29 ee ff ff       	call   800e25 <cprintf>
  801ffc:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801fff:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802002:	89 d0                	mov    %edx,%eax
  802004:	01 c0                	add    %eax,%eax
  802006:	01 d0                	add    %edx,%eax
  802008:	c1 e0 02             	shl    $0x2,%eax
  80200b:	05 28 41 80 00       	add    $0x804128,%eax
  802010:	8b 00                	mov    (%eax),%eax
  802012:	83 ec 04             	sub    $0x4,%esp
  802015:	50                   	push   %eax
  802016:	ff 75 b0             	pushl  -0x50(%ebp)
  802019:	68 98 36 80 00       	push   $0x803698
  80201e:	e8 02 ee ff ff       	call   800e25 <cprintf>
  802023:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  802026:	ff 45 b0             	incl   -0x50(%ebp)
  802029:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80202c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80202f:	7c 80                	jl     801fb1 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  802031:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802034:	89 d0                	mov    %edx,%eax
  802036:	01 c0                	add    %eax,%eax
  802038:	01 d0                	add    %edx,%eax
  80203a:	c1 e0 02             	shl    $0x2,%eax
  80203d:	05 20 41 80 00       	add    $0x804120,%eax
  802042:	8b 00                	mov    (%eax),%eax
  802044:	83 ec 08             	sub    $0x8,%esp
  802047:	50                   	push   %eax
  802048:	68 ac 36 80 00       	push   $0x8036ac
  80204d:	e8 d3 ed ff ff       	call   800e25 <cprintf>
  802052:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  802055:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802058:	89 d0                	mov    %edx,%eax
  80205a:	01 c0                	add    %eax,%eax
  80205c:	01 d0                	add    %edx,%eax
  80205e:	c1 e0 02             	shl    $0x2,%eax
  802061:	05 20 41 80 00       	add    $0x804120,%eax
  802066:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  802076:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80207d:	eb 4b                	jmp    8020ca <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  80207f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802082:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  802089:	89 c2                	mov    %eax,%edx
  80208b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80208e:	39 c2                	cmp    %eax,%edx
  802090:	7f 35                	jg     8020c7 <free+0x5d>
  802092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802095:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  80209c:	89 c2                	mov    %eax,%edx
  80209e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020a1:	39 c2                	cmp    %eax,%edx
  8020a3:	7e 22                	jle    8020c7 <free+0x5d>
				start=arr_add[i].start;
  8020a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a8:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  8020af:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8020b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b5:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  8020bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8020bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8020c5:	eb 0d                	jmp    8020d4 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8020c7:	ff 45 ec             	incl   -0x14(%ebp)
  8020ca:	a1 28 40 80 00       	mov    0x804028,%eax
  8020cf:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8020d2:	7c ab                	jl     80207f <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8020d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d7:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  8020de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e1:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  8020e8:	29 c2                	sub    %eax,%edx
  8020ea:	89 d0                	mov    %edx,%eax
  8020ec:	83 ec 08             	sub    $0x8,%esp
  8020ef:	50                   	push   %eax
  8020f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f3:	e8 d9 02 00 00       	call   8023d1 <sys_freeMem>
  8020f8:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  8020fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802101:	eb 2d                	jmp    802130 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  802103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802106:	40                   	inc    %eax
  802107:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  80210e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802111:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  802118:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80211b:	40                   	inc    %eax
  80211c:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  802123:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802126:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  80212d:	ff 45 e8             	incl   -0x18(%ebp)
  802130:	a1 28 40 80 00       	mov    0x804028,%eax
  802135:	48                   	dec    %eax
  802136:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802139:	7f c8                	jg     802103 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  80213b:	a1 28 40 80 00       	mov    0x804028,%eax
  802140:	48                   	dec    %eax
  802141:	a3 28 40 80 00       	mov    %eax,0x804028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  802146:	90                   	nop
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	83 ec 18             	sub    $0x18,%esp
  80214f:	8b 45 10             	mov    0x10(%ebp),%eax
  802152:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  802155:	83 ec 04             	sub    $0x4,%esp
  802158:	68 c8 36 80 00       	push   $0x8036c8
  80215d:	68 18 01 00 00       	push   $0x118
  802162:	68 eb 36 80 00       	push   $0x8036eb
  802167:	e8 17 ea ff ff       	call   800b83 <_panic>

0080216c <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802172:	83 ec 04             	sub    $0x4,%esp
  802175:	68 c8 36 80 00       	push   $0x8036c8
  80217a:	68 1e 01 00 00       	push   $0x11e
  80217f:	68 eb 36 80 00       	push   $0x8036eb
  802184:	e8 fa e9 ff ff       	call   800b83 <_panic>

00802189 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80218f:	83 ec 04             	sub    $0x4,%esp
  802192:	68 c8 36 80 00       	push   $0x8036c8
  802197:	68 24 01 00 00       	push   $0x124
  80219c:	68 eb 36 80 00       	push   $0x8036eb
  8021a1:	e8 dd e9 ff ff       	call   800b83 <_panic>

008021a6 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8021ac:	83 ec 04             	sub    $0x4,%esp
  8021af:	68 c8 36 80 00       	push   $0x8036c8
  8021b4:	68 29 01 00 00       	push   $0x129
  8021b9:	68 eb 36 80 00       	push   $0x8036eb
  8021be:	e8 c0 e9 ff ff       	call   800b83 <_panic>

008021c3 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8021c9:	83 ec 04             	sub    $0x4,%esp
  8021cc:	68 c8 36 80 00       	push   $0x8036c8
  8021d1:	68 2f 01 00 00       	push   $0x12f
  8021d6:	68 eb 36 80 00       	push   $0x8036eb
  8021db:	e8 a3 e9 ff ff       	call   800b83 <_panic>

008021e0 <shrink>:
}
void shrink(uint32 newSize)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8021e6:	83 ec 04             	sub    $0x4,%esp
  8021e9:	68 c8 36 80 00       	push   $0x8036c8
  8021ee:	68 33 01 00 00       	push   $0x133
  8021f3:	68 eb 36 80 00       	push   $0x8036eb
  8021f8:	e8 86 e9 ff ff       	call   800b83 <_panic>

008021fd <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802203:	83 ec 04             	sub    $0x4,%esp
  802206:	68 c8 36 80 00       	push   $0x8036c8
  80220b:	68 38 01 00 00       	push   $0x138
  802210:	68 eb 36 80 00       	push   $0x8036eb
  802215:	e8 69 e9 ff ff       	call   800b83 <_panic>

0080221a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	57                   	push   %edi
  80221e:	56                   	push   %esi
  80221f:	53                   	push   %ebx
  802220:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	8b 55 0c             	mov    0xc(%ebp),%edx
  802229:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80222c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80222f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802232:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802235:	cd 30                	int    $0x30
  802237:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80223a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80223d:	83 c4 10             	add    $0x10,%esp
  802240:	5b                   	pop    %ebx
  802241:	5e                   	pop    %esi
  802242:	5f                   	pop    %edi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    

00802245 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	83 ec 04             	sub    $0x4,%esp
  80224b:	8b 45 10             	mov    0x10(%ebp),%eax
  80224e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802251:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	52                   	push   %edx
  80225d:	ff 75 0c             	pushl  0xc(%ebp)
  802260:	50                   	push   %eax
  802261:	6a 00                	push   $0x0
  802263:	e8 b2 ff ff ff       	call   80221a <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
}
  80226b:	90                   	nop
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <sys_cgetc>:

int
sys_cgetc(void)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 01                	push   $0x1
  80227d:	e8 98 ff ff ff       	call   80221a <syscall>
  802282:	83 c4 18             	add    $0x18,%esp
}
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	50                   	push   %eax
  802296:	6a 05                	push   $0x5
  802298:	e8 7d ff ff ff       	call   80221a <syscall>
  80229d:	83 c4 18             	add    $0x18,%esp
}
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    

008022a2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 02                	push   $0x2
  8022b1:	e8 64 ff ff ff       	call   80221a <syscall>
  8022b6:	83 c4 18             	add    $0x18,%esp
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 03                	push   $0x3
  8022ca:	e8 4b ff ff ff       	call   80221a <syscall>
  8022cf:	83 c4 18             	add    $0x18,%esp
}
  8022d2:	c9                   	leave  
  8022d3:	c3                   	ret    

008022d4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 04                	push   $0x4
  8022e3:	e8 32 ff ff ff       	call   80221a <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <sys_env_exit>:


void sys_env_exit(void)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 06                	push   $0x6
  8022fc:	e8 19 ff ff ff       	call   80221a <syscall>
  802301:	83 c4 18             	add    $0x18,%esp
}
  802304:	90                   	nop
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80230a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	52                   	push   %edx
  802317:	50                   	push   %eax
  802318:	6a 07                	push   $0x7
  80231a:	e8 fb fe ff ff       	call   80221a <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	56                   	push   %esi
  802328:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802329:	8b 75 18             	mov    0x18(%ebp),%esi
  80232c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80232f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802332:	8b 55 0c             	mov    0xc(%ebp),%edx
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	56                   	push   %esi
  802339:	53                   	push   %ebx
  80233a:	51                   	push   %ecx
  80233b:	52                   	push   %edx
  80233c:	50                   	push   %eax
  80233d:	6a 08                	push   $0x8
  80233f:	e8 d6 fe ff ff       	call   80221a <syscall>
  802344:	83 c4 18             	add    $0x18,%esp
}
  802347:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80234a:	5b                   	pop    %ebx
  80234b:	5e                   	pop    %esi
  80234c:	5d                   	pop    %ebp
  80234d:	c3                   	ret    

0080234e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802351:	8b 55 0c             	mov    0xc(%ebp),%edx
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	52                   	push   %edx
  80235e:	50                   	push   %eax
  80235f:	6a 09                	push   $0x9
  802361:	e8 b4 fe ff ff       	call   80221a <syscall>
  802366:	83 c4 18             	add    $0x18,%esp
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	ff 75 0c             	pushl  0xc(%ebp)
  802377:	ff 75 08             	pushl  0x8(%ebp)
  80237a:	6a 0a                	push   $0xa
  80237c:	e8 99 fe ff ff       	call   80221a <syscall>
  802381:	83 c4 18             	add    $0x18,%esp
}
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 0b                	push   $0xb
  802395:	e8 80 fe ff ff       	call   80221a <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 0c                	push   $0xc
  8023ae:	e8 67 fe ff ff       	call   80221a <syscall>
  8023b3:	83 c4 18             	add    $0x18,%esp
}
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    

008023b8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 0d                	push   $0xd
  8023c7:	e8 4e fe ff ff       	call   80221a <syscall>
  8023cc:	83 c4 18             	add    $0x18,%esp
}
  8023cf:	c9                   	leave  
  8023d0:	c3                   	ret    

008023d1 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8023d1:	55                   	push   %ebp
  8023d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	ff 75 0c             	pushl  0xc(%ebp)
  8023dd:	ff 75 08             	pushl  0x8(%ebp)
  8023e0:	6a 11                	push   $0x11
  8023e2:	e8 33 fe ff ff       	call   80221a <syscall>
  8023e7:	83 c4 18             	add    $0x18,%esp
	return;
  8023ea:	90                   	nop
}
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    

008023ed <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	ff 75 0c             	pushl  0xc(%ebp)
  8023f9:	ff 75 08             	pushl  0x8(%ebp)
  8023fc:	6a 12                	push   $0x12
  8023fe:	e8 17 fe ff ff       	call   80221a <syscall>
  802403:	83 c4 18             	add    $0x18,%esp
	return ;
  802406:	90                   	nop
}
  802407:	c9                   	leave  
  802408:	c3                   	ret    

00802409 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 0e                	push   $0xe
  802418:	e8 fd fd ff ff       	call   80221a <syscall>
  80241d:	83 c4 18             	add    $0x18,%esp
}
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	ff 75 08             	pushl  0x8(%ebp)
  802430:	6a 0f                	push   $0xf
  802432:	e8 e3 fd ff ff       	call   80221a <syscall>
  802437:	83 c4 18             	add    $0x18,%esp
}
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 10                	push   $0x10
  80244b:	e8 ca fd ff ff       	call   80221a <syscall>
  802450:	83 c4 18             	add    $0x18,%esp
}
  802453:	90                   	nop
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 14                	push   $0x14
  802465:	e8 b0 fd ff ff       	call   80221a <syscall>
  80246a:	83 c4 18             	add    $0x18,%esp
}
  80246d:	90                   	nop
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 15                	push   $0x15
  80247f:	e8 96 fd ff ff       	call   80221a <syscall>
  802484:	83 c4 18             	add    $0x18,%esp
}
  802487:	90                   	nop
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <sys_cputc>:


void
sys_cputc(const char c)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	83 ec 04             	sub    $0x4,%esp
  802490:	8b 45 08             	mov    0x8(%ebp),%eax
  802493:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802496:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	50                   	push   %eax
  8024a3:	6a 16                	push   $0x16
  8024a5:	e8 70 fd ff ff       	call   80221a <syscall>
  8024aa:	83 c4 18             	add    $0x18,%esp
}
  8024ad:	90                   	nop
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 17                	push   $0x17
  8024bf:	e8 56 fd ff ff       	call   80221a <syscall>
  8024c4:	83 c4 18             	add    $0x18,%esp
}
  8024c7:	90                   	nop
  8024c8:	c9                   	leave  
  8024c9:	c3                   	ret    

008024ca <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8024cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	ff 75 0c             	pushl  0xc(%ebp)
  8024d9:	50                   	push   %eax
  8024da:	6a 18                	push   $0x18
  8024dc:	e8 39 fd ff ff       	call   80221a <syscall>
  8024e1:	83 c4 18             	add    $0x18,%esp
}
  8024e4:	c9                   	leave  
  8024e5:	c3                   	ret    

008024e6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	52                   	push   %edx
  8024f6:	50                   	push   %eax
  8024f7:	6a 1b                	push   $0x1b
  8024f9:	e8 1c fd ff ff       	call   80221a <syscall>
  8024fe:	83 c4 18             	add    $0x18,%esp
}
  802501:	c9                   	leave  
  802502:	c3                   	ret    

00802503 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802506:	8b 55 0c             	mov    0xc(%ebp),%edx
  802509:	8b 45 08             	mov    0x8(%ebp),%eax
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	52                   	push   %edx
  802513:	50                   	push   %eax
  802514:	6a 19                	push   $0x19
  802516:	e8 ff fc ff ff       	call   80221a <syscall>
  80251b:	83 c4 18             	add    $0x18,%esp
}
  80251e:	90                   	nop
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802524:	8b 55 0c             	mov    0xc(%ebp),%edx
  802527:	8b 45 08             	mov    0x8(%ebp),%eax
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	52                   	push   %edx
  802531:	50                   	push   %eax
  802532:	6a 1a                	push   $0x1a
  802534:	e8 e1 fc ff ff       	call   80221a <syscall>
  802539:	83 c4 18             	add    $0x18,%esp
}
  80253c:	90                   	nop
  80253d:	c9                   	leave  
  80253e:	c3                   	ret    

0080253f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80253f:	55                   	push   %ebp
  802540:	89 e5                	mov    %esp,%ebp
  802542:	83 ec 04             	sub    $0x4,%esp
  802545:	8b 45 10             	mov    0x10(%ebp),%eax
  802548:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80254b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80254e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802552:	8b 45 08             	mov    0x8(%ebp),%eax
  802555:	6a 00                	push   $0x0
  802557:	51                   	push   %ecx
  802558:	52                   	push   %edx
  802559:	ff 75 0c             	pushl  0xc(%ebp)
  80255c:	50                   	push   %eax
  80255d:	6a 1c                	push   $0x1c
  80255f:	e8 b6 fc ff ff       	call   80221a <syscall>
  802564:	83 c4 18             	add    $0x18,%esp
}
  802567:	c9                   	leave  
  802568:	c3                   	ret    

00802569 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80256c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	52                   	push   %edx
  802579:	50                   	push   %eax
  80257a:	6a 1d                	push   $0x1d
  80257c:	e8 99 fc ff ff       	call   80221a <syscall>
  802581:	83 c4 18             	add    $0x18,%esp
}
  802584:	c9                   	leave  
  802585:	c3                   	ret    

00802586 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802589:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80258c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80258f:	8b 45 08             	mov    0x8(%ebp),%eax
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	51                   	push   %ecx
  802597:	52                   	push   %edx
  802598:	50                   	push   %eax
  802599:	6a 1e                	push   $0x1e
  80259b:	e8 7a fc ff ff       	call   80221a <syscall>
  8025a0:	83 c4 18             	add    $0x18,%esp
}
  8025a3:	c9                   	leave  
  8025a4:	c3                   	ret    

008025a5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	52                   	push   %edx
  8025b5:	50                   	push   %eax
  8025b6:	6a 1f                	push   $0x1f
  8025b8:	e8 5d fc ff ff       	call   80221a <syscall>
  8025bd:	83 c4 18             	add    $0x18,%esp
}
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 20                	push   $0x20
  8025d1:	e8 44 fc ff ff       	call   80221a <syscall>
  8025d6:	83 c4 18             	add    $0x18,%esp
}
  8025d9:	c9                   	leave  
  8025da:	c3                   	ret    

008025db <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025de:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e1:	6a 00                	push   $0x0
  8025e3:	ff 75 14             	pushl  0x14(%ebp)
  8025e6:	ff 75 10             	pushl  0x10(%ebp)
  8025e9:	ff 75 0c             	pushl  0xc(%ebp)
  8025ec:	50                   	push   %eax
  8025ed:	6a 21                	push   $0x21
  8025ef:	e8 26 fc ff ff       	call   80221a <syscall>
  8025f4:	83 c4 18             	add    $0x18,%esp
}
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	50                   	push   %eax
  802608:	6a 22                	push   $0x22
  80260a:	e8 0b fc ff ff       	call   80221a <syscall>
  80260f:	83 c4 18             	add    $0x18,%esp
}
  802612:	90                   	nop
  802613:	c9                   	leave  
  802614:	c3                   	ret    

00802615 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802615:	55                   	push   %ebp
  802616:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802618:	8b 45 08             	mov    0x8(%ebp),%eax
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	50                   	push   %eax
  802624:	6a 23                	push   $0x23
  802626:	e8 ef fb ff ff       	call   80221a <syscall>
  80262b:	83 c4 18             	add    $0x18,%esp
}
  80262e:	90                   	nop
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
  802634:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802637:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80263a:	8d 50 04             	lea    0x4(%eax),%edx
  80263d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	52                   	push   %edx
  802647:	50                   	push   %eax
  802648:	6a 24                	push   $0x24
  80264a:	e8 cb fb ff ff       	call   80221a <syscall>
  80264f:	83 c4 18             	add    $0x18,%esp
	return result;
  802652:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802655:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802658:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80265b:	89 01                	mov    %eax,(%ecx)
  80265d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	c9                   	leave  
  802664:	c2 04 00             	ret    $0x4

00802667 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802667:	55                   	push   %ebp
  802668:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	ff 75 10             	pushl  0x10(%ebp)
  802671:	ff 75 0c             	pushl  0xc(%ebp)
  802674:	ff 75 08             	pushl  0x8(%ebp)
  802677:	6a 13                	push   $0x13
  802679:	e8 9c fb ff ff       	call   80221a <syscall>
  80267e:	83 c4 18             	add    $0x18,%esp
	return ;
  802681:	90                   	nop
}
  802682:	c9                   	leave  
  802683:	c3                   	ret    

00802684 <sys_rcr2>:
uint32 sys_rcr2()
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802687:	6a 00                	push   $0x0
  802689:	6a 00                	push   $0x0
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	6a 25                	push   $0x25
  802693:	e8 82 fb ff ff       	call   80221a <syscall>
  802698:	83 c4 18             	add    $0x18,%esp
}
  80269b:	c9                   	leave  
  80269c:	c3                   	ret    

0080269d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80269d:	55                   	push   %ebp
  80269e:	89 e5                	mov    %esp,%ebp
  8026a0:	83 ec 04             	sub    $0x4,%esp
  8026a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026a9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	50                   	push   %eax
  8026b6:	6a 26                	push   $0x26
  8026b8:	e8 5d fb ff ff       	call   80221a <syscall>
  8026bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c0:	90                   	nop
}
  8026c1:	c9                   	leave  
  8026c2:	c3                   	ret    

008026c3 <rsttst>:
void rsttst()
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 28                	push   $0x28
  8026d2:	e8 43 fb ff ff       	call   80221a <syscall>
  8026d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8026da:	90                   	nop
}
  8026db:	c9                   	leave  
  8026dc:	c3                   	ret    

008026dd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026dd:	55                   	push   %ebp
  8026de:	89 e5                	mov    %esp,%ebp
  8026e0:	83 ec 04             	sub    $0x4,%esp
  8026e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8026e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026e9:	8b 55 18             	mov    0x18(%ebp),%edx
  8026ec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026f0:	52                   	push   %edx
  8026f1:	50                   	push   %eax
  8026f2:	ff 75 10             	pushl  0x10(%ebp)
  8026f5:	ff 75 0c             	pushl  0xc(%ebp)
  8026f8:	ff 75 08             	pushl  0x8(%ebp)
  8026fb:	6a 27                	push   $0x27
  8026fd:	e8 18 fb ff ff       	call   80221a <syscall>
  802702:	83 c4 18             	add    $0x18,%esp
	return ;
  802705:	90                   	nop
}
  802706:	c9                   	leave  
  802707:	c3                   	ret    

00802708 <chktst>:
void chktst(uint32 n)
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80270b:	6a 00                	push   $0x0
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	ff 75 08             	pushl  0x8(%ebp)
  802716:	6a 29                	push   $0x29
  802718:	e8 fd fa ff ff       	call   80221a <syscall>
  80271d:	83 c4 18             	add    $0x18,%esp
	return ;
  802720:	90                   	nop
}
  802721:	c9                   	leave  
  802722:	c3                   	ret    

00802723 <inctst>:

void inctst()
{
  802723:	55                   	push   %ebp
  802724:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802726:	6a 00                	push   $0x0
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	6a 2a                	push   $0x2a
  802732:	e8 e3 fa ff ff       	call   80221a <syscall>
  802737:	83 c4 18             	add    $0x18,%esp
	return ;
  80273a:	90                   	nop
}
  80273b:	c9                   	leave  
  80273c:	c3                   	ret    

0080273d <gettst>:
uint32 gettst()
{
  80273d:	55                   	push   %ebp
  80273e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802740:	6a 00                	push   $0x0
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	6a 2b                	push   $0x2b
  80274c:	e8 c9 fa ff ff       	call   80221a <syscall>
  802751:	83 c4 18             	add    $0x18,%esp
}
  802754:	c9                   	leave  
  802755:	c3                   	ret    

00802756 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 00                	push   $0x0
  802762:	6a 00                	push   $0x0
  802764:	6a 00                	push   $0x0
  802766:	6a 2c                	push   $0x2c
  802768:	e8 ad fa ff ff       	call   80221a <syscall>
  80276d:	83 c4 18             	add    $0x18,%esp
  802770:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802773:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802777:	75 07                	jne    802780 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802779:	b8 01 00 00 00       	mov    $0x1,%eax
  80277e:	eb 05                	jmp    802785 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802780:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802785:	c9                   	leave  
  802786:	c3                   	ret    

00802787 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
  80278a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	6a 00                	push   $0x0
  802793:	6a 00                	push   $0x0
  802795:	6a 00                	push   $0x0
  802797:	6a 2c                	push   $0x2c
  802799:	e8 7c fa ff ff       	call   80221a <syscall>
  80279e:	83 c4 18             	add    $0x18,%esp
  8027a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8027a4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8027a8:	75 07                	jne    8027b1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8027aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8027af:	eb 05                	jmp    8027b6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8027b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b6:	c9                   	leave  
  8027b7:	c3                   	ret    

008027b8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
  8027bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 2c                	push   $0x2c
  8027ca:	e8 4b fa ff ff       	call   80221a <syscall>
  8027cf:	83 c4 18             	add    $0x18,%esp
  8027d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027d5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027d9:	75 07                	jne    8027e2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027db:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e0:	eb 05                	jmp    8027e7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e7:	c9                   	leave  
  8027e8:	c3                   	ret    

008027e9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027e9:	55                   	push   %ebp
  8027ea:	89 e5                	mov    %esp,%ebp
  8027ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 2c                	push   $0x2c
  8027fb:	e8 1a fa ff ff       	call   80221a <syscall>
  802800:	83 c4 18             	add    $0x18,%esp
  802803:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802806:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80280a:	75 07                	jne    802813 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80280c:	b8 01 00 00 00       	mov    $0x1,%eax
  802811:	eb 05                	jmp    802818 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802813:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802818:	c9                   	leave  
  802819:	c3                   	ret    

0080281a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80281a:	55                   	push   %ebp
  80281b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80281d:	6a 00                	push   $0x0
  80281f:	6a 00                	push   $0x0
  802821:	6a 00                	push   $0x0
  802823:	6a 00                	push   $0x0
  802825:	ff 75 08             	pushl  0x8(%ebp)
  802828:	6a 2d                	push   $0x2d
  80282a:	e8 eb f9 ff ff       	call   80221a <syscall>
  80282f:	83 c4 18             	add    $0x18,%esp
	return ;
  802832:	90                   	nop
}
  802833:	c9                   	leave  
  802834:	c3                   	ret    

00802835 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
  802838:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802839:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80283c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80283f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802842:	8b 45 08             	mov    0x8(%ebp),%eax
  802845:	6a 00                	push   $0x0
  802847:	53                   	push   %ebx
  802848:	51                   	push   %ecx
  802849:	52                   	push   %edx
  80284a:	50                   	push   %eax
  80284b:	6a 2e                	push   $0x2e
  80284d:	e8 c8 f9 ff ff       	call   80221a <syscall>
  802852:	83 c4 18             	add    $0x18,%esp
}
  802855:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802858:	c9                   	leave  
  802859:	c3                   	ret    

0080285a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80285d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	6a 00                	push   $0x0
  802865:	6a 00                	push   $0x0
  802867:	6a 00                	push   $0x0
  802869:	52                   	push   %edx
  80286a:	50                   	push   %eax
  80286b:	6a 2f                	push   $0x2f
  80286d:	e8 a8 f9 ff ff       	call   80221a <syscall>
  802872:	83 c4 18             	add    $0x18,%esp
}
  802875:	c9                   	leave  
  802876:	c3                   	ret    
  802877:	90                   	nop

00802878 <__udivdi3>:
  802878:	55                   	push   %ebp
  802879:	57                   	push   %edi
  80287a:	56                   	push   %esi
  80287b:	53                   	push   %ebx
  80287c:	83 ec 1c             	sub    $0x1c,%esp
  80287f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802883:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802887:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80288b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80288f:	89 ca                	mov    %ecx,%edx
  802891:	89 f8                	mov    %edi,%eax
  802893:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802897:	85 f6                	test   %esi,%esi
  802899:	75 2d                	jne    8028c8 <__udivdi3+0x50>
  80289b:	39 cf                	cmp    %ecx,%edi
  80289d:	77 65                	ja     802904 <__udivdi3+0x8c>
  80289f:	89 fd                	mov    %edi,%ebp
  8028a1:	85 ff                	test   %edi,%edi
  8028a3:	75 0b                	jne    8028b0 <__udivdi3+0x38>
  8028a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8028aa:	31 d2                	xor    %edx,%edx
  8028ac:	f7 f7                	div    %edi
  8028ae:	89 c5                	mov    %eax,%ebp
  8028b0:	31 d2                	xor    %edx,%edx
  8028b2:	89 c8                	mov    %ecx,%eax
  8028b4:	f7 f5                	div    %ebp
  8028b6:	89 c1                	mov    %eax,%ecx
  8028b8:	89 d8                	mov    %ebx,%eax
  8028ba:	f7 f5                	div    %ebp
  8028bc:	89 cf                	mov    %ecx,%edi
  8028be:	89 fa                	mov    %edi,%edx
  8028c0:	83 c4 1c             	add    $0x1c,%esp
  8028c3:	5b                   	pop    %ebx
  8028c4:	5e                   	pop    %esi
  8028c5:	5f                   	pop    %edi
  8028c6:	5d                   	pop    %ebp
  8028c7:	c3                   	ret    
  8028c8:	39 ce                	cmp    %ecx,%esi
  8028ca:	77 28                	ja     8028f4 <__udivdi3+0x7c>
  8028cc:	0f bd fe             	bsr    %esi,%edi
  8028cf:	83 f7 1f             	xor    $0x1f,%edi
  8028d2:	75 40                	jne    802914 <__udivdi3+0x9c>
  8028d4:	39 ce                	cmp    %ecx,%esi
  8028d6:	72 0a                	jb     8028e2 <__udivdi3+0x6a>
  8028d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8028dc:	0f 87 9e 00 00 00    	ja     802980 <__udivdi3+0x108>
  8028e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028e7:	89 fa                	mov    %edi,%edx
  8028e9:	83 c4 1c             	add    $0x1c,%esp
  8028ec:	5b                   	pop    %ebx
  8028ed:	5e                   	pop    %esi
  8028ee:	5f                   	pop    %edi
  8028ef:	5d                   	pop    %ebp
  8028f0:	c3                   	ret    
  8028f1:	8d 76 00             	lea    0x0(%esi),%esi
  8028f4:	31 ff                	xor    %edi,%edi
  8028f6:	31 c0                	xor    %eax,%eax
  8028f8:	89 fa                	mov    %edi,%edx
  8028fa:	83 c4 1c             	add    $0x1c,%esp
  8028fd:	5b                   	pop    %ebx
  8028fe:	5e                   	pop    %esi
  8028ff:	5f                   	pop    %edi
  802900:	5d                   	pop    %ebp
  802901:	c3                   	ret    
  802902:	66 90                	xchg   %ax,%ax
  802904:	89 d8                	mov    %ebx,%eax
  802906:	f7 f7                	div    %edi
  802908:	31 ff                	xor    %edi,%edi
  80290a:	89 fa                	mov    %edi,%edx
  80290c:	83 c4 1c             	add    $0x1c,%esp
  80290f:	5b                   	pop    %ebx
  802910:	5e                   	pop    %esi
  802911:	5f                   	pop    %edi
  802912:	5d                   	pop    %ebp
  802913:	c3                   	ret    
  802914:	bd 20 00 00 00       	mov    $0x20,%ebp
  802919:	89 eb                	mov    %ebp,%ebx
  80291b:	29 fb                	sub    %edi,%ebx
  80291d:	89 f9                	mov    %edi,%ecx
  80291f:	d3 e6                	shl    %cl,%esi
  802921:	89 c5                	mov    %eax,%ebp
  802923:	88 d9                	mov    %bl,%cl
  802925:	d3 ed                	shr    %cl,%ebp
  802927:	89 e9                	mov    %ebp,%ecx
  802929:	09 f1                	or     %esi,%ecx
  80292b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80292f:	89 f9                	mov    %edi,%ecx
  802931:	d3 e0                	shl    %cl,%eax
  802933:	89 c5                	mov    %eax,%ebp
  802935:	89 d6                	mov    %edx,%esi
  802937:	88 d9                	mov    %bl,%cl
  802939:	d3 ee                	shr    %cl,%esi
  80293b:	89 f9                	mov    %edi,%ecx
  80293d:	d3 e2                	shl    %cl,%edx
  80293f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802943:	88 d9                	mov    %bl,%cl
  802945:	d3 e8                	shr    %cl,%eax
  802947:	09 c2                	or     %eax,%edx
  802949:	89 d0                	mov    %edx,%eax
  80294b:	89 f2                	mov    %esi,%edx
  80294d:	f7 74 24 0c          	divl   0xc(%esp)
  802951:	89 d6                	mov    %edx,%esi
  802953:	89 c3                	mov    %eax,%ebx
  802955:	f7 e5                	mul    %ebp
  802957:	39 d6                	cmp    %edx,%esi
  802959:	72 19                	jb     802974 <__udivdi3+0xfc>
  80295b:	74 0b                	je     802968 <__udivdi3+0xf0>
  80295d:	89 d8                	mov    %ebx,%eax
  80295f:	31 ff                	xor    %edi,%edi
  802961:	e9 58 ff ff ff       	jmp    8028be <__udivdi3+0x46>
  802966:	66 90                	xchg   %ax,%ax
  802968:	8b 54 24 08          	mov    0x8(%esp),%edx
  80296c:	89 f9                	mov    %edi,%ecx
  80296e:	d3 e2                	shl    %cl,%edx
  802970:	39 c2                	cmp    %eax,%edx
  802972:	73 e9                	jae    80295d <__udivdi3+0xe5>
  802974:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802977:	31 ff                	xor    %edi,%edi
  802979:	e9 40 ff ff ff       	jmp    8028be <__udivdi3+0x46>
  80297e:	66 90                	xchg   %ax,%ax
  802980:	31 c0                	xor    %eax,%eax
  802982:	e9 37 ff ff ff       	jmp    8028be <__udivdi3+0x46>
  802987:	90                   	nop

00802988 <__umoddi3>:
  802988:	55                   	push   %ebp
  802989:	57                   	push   %edi
  80298a:	56                   	push   %esi
  80298b:	53                   	push   %ebx
  80298c:	83 ec 1c             	sub    $0x1c,%esp
  80298f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802993:	8b 74 24 34          	mov    0x34(%esp),%esi
  802997:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80299b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80299f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029a7:	89 f3                	mov    %esi,%ebx
  8029a9:	89 fa                	mov    %edi,%edx
  8029ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029af:	89 34 24             	mov    %esi,(%esp)
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	75 1a                	jne    8029d0 <__umoddi3+0x48>
  8029b6:	39 f7                	cmp    %esi,%edi
  8029b8:	0f 86 a2 00 00 00    	jbe    802a60 <__umoddi3+0xd8>
  8029be:	89 c8                	mov    %ecx,%eax
  8029c0:	89 f2                	mov    %esi,%edx
  8029c2:	f7 f7                	div    %edi
  8029c4:	89 d0                	mov    %edx,%eax
  8029c6:	31 d2                	xor    %edx,%edx
  8029c8:	83 c4 1c             	add    $0x1c,%esp
  8029cb:	5b                   	pop    %ebx
  8029cc:	5e                   	pop    %esi
  8029cd:	5f                   	pop    %edi
  8029ce:	5d                   	pop    %ebp
  8029cf:	c3                   	ret    
  8029d0:	39 f0                	cmp    %esi,%eax
  8029d2:	0f 87 ac 00 00 00    	ja     802a84 <__umoddi3+0xfc>
  8029d8:	0f bd e8             	bsr    %eax,%ebp
  8029db:	83 f5 1f             	xor    $0x1f,%ebp
  8029de:	0f 84 ac 00 00 00    	je     802a90 <__umoddi3+0x108>
  8029e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8029e9:	29 ef                	sub    %ebp,%edi
  8029eb:	89 fe                	mov    %edi,%esi
  8029ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029f1:	89 e9                	mov    %ebp,%ecx
  8029f3:	d3 e0                	shl    %cl,%eax
  8029f5:	89 d7                	mov    %edx,%edi
  8029f7:	89 f1                	mov    %esi,%ecx
  8029f9:	d3 ef                	shr    %cl,%edi
  8029fb:	09 c7                	or     %eax,%edi
  8029fd:	89 e9                	mov    %ebp,%ecx
  8029ff:	d3 e2                	shl    %cl,%edx
  802a01:	89 14 24             	mov    %edx,(%esp)
  802a04:	89 d8                	mov    %ebx,%eax
  802a06:	d3 e0                	shl    %cl,%eax
  802a08:	89 c2                	mov    %eax,%edx
  802a0a:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a0e:	d3 e0                	shl    %cl,%eax
  802a10:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a14:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a18:	89 f1                	mov    %esi,%ecx
  802a1a:	d3 e8                	shr    %cl,%eax
  802a1c:	09 d0                	or     %edx,%eax
  802a1e:	d3 eb                	shr    %cl,%ebx
  802a20:	89 da                	mov    %ebx,%edx
  802a22:	f7 f7                	div    %edi
  802a24:	89 d3                	mov    %edx,%ebx
  802a26:	f7 24 24             	mull   (%esp)
  802a29:	89 c6                	mov    %eax,%esi
  802a2b:	89 d1                	mov    %edx,%ecx
  802a2d:	39 d3                	cmp    %edx,%ebx
  802a2f:	0f 82 87 00 00 00    	jb     802abc <__umoddi3+0x134>
  802a35:	0f 84 91 00 00 00    	je     802acc <__umoddi3+0x144>
  802a3b:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a3f:	29 f2                	sub    %esi,%edx
  802a41:	19 cb                	sbb    %ecx,%ebx
  802a43:	89 d8                	mov    %ebx,%eax
  802a45:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802a49:	d3 e0                	shl    %cl,%eax
  802a4b:	89 e9                	mov    %ebp,%ecx
  802a4d:	d3 ea                	shr    %cl,%edx
  802a4f:	09 d0                	or     %edx,%eax
  802a51:	89 e9                	mov    %ebp,%ecx
  802a53:	d3 eb                	shr    %cl,%ebx
  802a55:	89 da                	mov    %ebx,%edx
  802a57:	83 c4 1c             	add    $0x1c,%esp
  802a5a:	5b                   	pop    %ebx
  802a5b:	5e                   	pop    %esi
  802a5c:	5f                   	pop    %edi
  802a5d:	5d                   	pop    %ebp
  802a5e:	c3                   	ret    
  802a5f:	90                   	nop
  802a60:	89 fd                	mov    %edi,%ebp
  802a62:	85 ff                	test   %edi,%edi
  802a64:	75 0b                	jne    802a71 <__umoddi3+0xe9>
  802a66:	b8 01 00 00 00       	mov    $0x1,%eax
  802a6b:	31 d2                	xor    %edx,%edx
  802a6d:	f7 f7                	div    %edi
  802a6f:	89 c5                	mov    %eax,%ebp
  802a71:	89 f0                	mov    %esi,%eax
  802a73:	31 d2                	xor    %edx,%edx
  802a75:	f7 f5                	div    %ebp
  802a77:	89 c8                	mov    %ecx,%eax
  802a79:	f7 f5                	div    %ebp
  802a7b:	89 d0                	mov    %edx,%eax
  802a7d:	e9 44 ff ff ff       	jmp    8029c6 <__umoddi3+0x3e>
  802a82:	66 90                	xchg   %ax,%ax
  802a84:	89 c8                	mov    %ecx,%eax
  802a86:	89 f2                	mov    %esi,%edx
  802a88:	83 c4 1c             	add    $0x1c,%esp
  802a8b:	5b                   	pop    %ebx
  802a8c:	5e                   	pop    %esi
  802a8d:	5f                   	pop    %edi
  802a8e:	5d                   	pop    %ebp
  802a8f:	c3                   	ret    
  802a90:	3b 04 24             	cmp    (%esp),%eax
  802a93:	72 06                	jb     802a9b <__umoddi3+0x113>
  802a95:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802a99:	77 0f                	ja     802aaa <__umoddi3+0x122>
  802a9b:	89 f2                	mov    %esi,%edx
  802a9d:	29 f9                	sub    %edi,%ecx
  802a9f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802aa3:	89 14 24             	mov    %edx,(%esp)
  802aa6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802aaa:	8b 44 24 04          	mov    0x4(%esp),%eax
  802aae:	8b 14 24             	mov    (%esp),%edx
  802ab1:	83 c4 1c             	add    $0x1c,%esp
  802ab4:	5b                   	pop    %ebx
  802ab5:	5e                   	pop    %esi
  802ab6:	5f                   	pop    %edi
  802ab7:	5d                   	pop    %ebp
  802ab8:	c3                   	ret    
  802ab9:	8d 76 00             	lea    0x0(%esi),%esi
  802abc:	2b 04 24             	sub    (%esp),%eax
  802abf:	19 fa                	sbb    %edi,%edx
  802ac1:	89 d1                	mov    %edx,%ecx
  802ac3:	89 c6                	mov    %eax,%esi
  802ac5:	e9 71 ff ff ff       	jmp    802a3b <__umoddi3+0xb3>
  802aca:	66 90                	xchg   %ax,%ax
  802acc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802ad0:	72 ea                	jb     802abc <__umoddi3+0x134>
  802ad2:	89 d9                	mov    %ebx,%ecx
  802ad4:	e9 62 ff ff ff       	jmp    802a3b <__umoddi3+0xb3>
