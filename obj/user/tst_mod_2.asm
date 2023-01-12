
obj/user/tst_mod_2:     file format elf32-i386


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
  800031:	e8 2b 08 00 00       	call   800861 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */
#include <inc/lib.h>

int CheckWSEntries(volatile struct Env* e, uint32 startVA, uint32 endVA) ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
	int envID = sys_getenvid();
  800042:	e8 7e 20 00 00       	call   8020c5 <sys_getenvid>
  800047:	89 45 e8             	mov    %eax,-0x18(%ebp)
	cprintf("envID = %d\n",envID);
  80004a:	83 ec 08             	sub    $0x8,%esp
  80004d:	ff 75 e8             	pushl  -0x18(%ebp)
  800050:	68 00 29 80 00       	push   $0x802900
  800055:	e8 ee 0b 00 00       	call   800c48 <cprintf>
  80005a:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  80005d:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  800064:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)

	int numOfFreeWSEntries = 0;
  80006b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//("STEP 0: checking Initial WS free size...\n");
	{
		int i;
		for (i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800079:	eb 20                	jmp    80009b <_main+0x63>
		{
			if( myEnv->__uptr_pws[i].empty == 1)
  80007b:	a1 20 40 80 00       	mov    0x804020,%eax
  800080:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800086:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800089:	c1 e2 04             	shl    $0x4,%edx
  80008c:	01 d0                	add    %edx,%eax
  80008e:	8a 40 04             	mov    0x4(%eax),%al
  800091:	3c 01                	cmp    $0x1,%al
  800093:	75 03                	jne    800098 <_main+0x60>
				numOfFreeWSEntries++ ;
  800095:	ff 45 f4             	incl   -0xc(%ebp)

	int numOfFreeWSEntries = 0;
	//("STEP 0: checking Initial WS free size...\n");
	{
		int i;
		for (i = 0; i < myEnv->page_WS_max_size; ++i)
  800098:	ff 45 f0             	incl   -0x10(%ebp)
  80009b:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a0:	8b 50 74             	mov    0x74(%eax),%edx
  8000a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000a6:	39 c2                	cmp    %eax,%edx
  8000a8:	77 d1                	ja     80007b <_main+0x43>
		{
			if( myEnv->__uptr_pws[i].empty == 1)
				numOfFreeWSEntries++ ;
		}

		assert(numOfFreeWSEntries == (myEnv->page_WS_max_size - myEnv->page_last_WS_index));
  8000aa:	a1 20 40 80 00       	mov    0x804020,%eax
  8000af:	8b 50 74             	mov    0x74(%eax),%edx
  8000b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8000b7:	8b 80 18 3c 01 00    	mov    0x13c18(%eax),%eax
  8000bd:	29 c2                	sub    %eax,%edx
  8000bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c2:	39 c2                	cmp    %eax,%edx
  8000c4:	74 16                	je     8000dc <_main+0xa4>
  8000c6:	68 0c 29 80 00       	push   $0x80290c
  8000cb:	68 58 29 80 00       	push   $0x802958
  8000d0:	6a 19                	push   $0x19
  8000d2:	68 6d 29 80 00       	push   $0x80296d
  8000d7:	e8 ca 08 00 00       	call   8009a6 <_panic>
	}


	{
		//allocate Half WS free size in the heap [Should alloc in RAM and Page File]
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000dc:	e8 4b 21 00 00       	call   80222c <sys_pf_calculate_allocated_pages>
  8000e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000e4:	e8 c0 20 00 00       	call   8021a9 <sys_calculate_free_frames>
  8000e9:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int numOfReqPages1 = numOfFreeWSEntries/2 ;
  8000ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ef:	89 c2                	mov    %eax,%edx
  8000f1:	c1 ea 1f             	shr    $0x1f,%edx
  8000f4:	01 d0                	add    %edx,%eax
  8000f6:	d1 f8                	sar    %eax
  8000f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int numOfReqTables1 = ROUNDUP(numOfReqPages1, 1024) / 1024;
  8000fb:	c7 45 d0 00 04 00 00 	movl   $0x400,-0x30(%ebp)
  800102:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800105:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800108:	01 d0                	add    %edx,%eax
  80010a:	48                   	dec    %eax
  80010b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80010e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800111:	ba 00 00 00 00       	mov    $0x0,%edx
  800116:	f7 75 d0             	divl   -0x30(%ebp)
  800119:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80011c:	29 d0                	sub    %edx,%eax
  80011e:	85 c0                	test   %eax,%eax
  800120:	79 05                	jns    800127 <_main+0xef>
  800122:	05 ff 03 00 00       	add    $0x3ff,%eax
  800127:	c1 f8 0a             	sar    $0xa,%eax
  80012a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		int size1 = numOfReqPages1 * PAGE_SIZE;
  80012d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800130:	c1 e0 0c             	shl    $0xc,%eax
  800133:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int8 *x1 = malloc(size1) ;
  800136:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	50                   	push   %eax
  80013d:	e8 90 18 00 00       	call   8019d2 <malloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 c0             	mov    %eax,-0x40(%ebp)
		assert((uint32) x1 == USER_HEAP_START);
  800148:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80014b:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800150:	74 16                	je     800168 <_main+0x130>
  800152:	68 80 29 80 00       	push   $0x802980
  800157:	68 58 29 80 00       	push   $0x802958
  80015c:	6a 26                	push   $0x26
  80015e:	68 6d 29 80 00       	push   $0x80296d
  800163:	e8 3e 08 00 00       	call   8009a6 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (2*numOfReqTables1 + numOfReqPages1));
  800168:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80016b:	e8 39 20 00 00       	call   8021a9 <sys_calculate_free_frames>
  800170:	29 c3                	sub    %eax,%ebx
  800172:	89 da                	mov    %ebx,%edx
  800174:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800177:	01 c0                	add    %eax,%eax
  800179:	89 c1                	mov    %eax,%ecx
  80017b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80017e:	01 c8                	add    %ecx,%eax
  800180:	39 c2                	cmp    %eax,%edx
  800182:	74 16                	je     80019a <_main+0x162>
  800184:	68 a0 29 80 00       	push   $0x8029a0
  800189:	68 58 29 80 00       	push   $0x802958
  80018e:	6a 27                	push   $0x27
  800190:	68 6d 29 80 00       	push   $0x80296d
  800195:	e8 0c 08 00 00       	call   8009a6 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == numOfReqPages1);
  80019a:	e8 8d 20 00 00       	call   80222c <sys_pf_calculate_allocated_pages>
  80019f:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8001a2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001a5:	74 16                	je     8001bd <_main+0x185>
  8001a7:	68 f4 29 80 00       	push   $0x8029f4
  8001ac:	68 58 29 80 00       	push   $0x802958
  8001b1:	6a 28                	push   $0x28
  8001b3:	68 6d 29 80 00       	push   $0x80296d
  8001b8:	e8 e9 07 00 00       	call   8009a6 <_panic>
		assert(CheckWSEntries(myEnv, (uint32)x1, (uint32)x1+size1) == numOfReqPages1);
  8001bd:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8001c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001c3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8001c6:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	51                   	push   %ecx
  8001d2:	52                   	push   %edx
  8001d3:	50                   	push   %eax
  8001d4:	e8 e7 05 00 00       	call   8007c0 <CheckWSEntries>
  8001d9:	83 c4 10             	add    $0x10,%esp
  8001dc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001df:	74 16                	je     8001f7 <_main+0x1bf>
  8001e1:	68 3c 2a 80 00       	push   $0x802a3c
  8001e6:	68 58 29 80 00       	push   $0x802958
  8001eb:	6a 29                	push   $0x29
  8001ed:	68 6d 29 80 00       	push   $0x80296d
  8001f2:	e8 af 07 00 00       	call   8009a6 <_panic>

		//allocate original WS free size in the heap [should not be all. in RAM]
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f7:	e8 30 20 00 00       	call   80222c <sys_pf_calculate_allocated_pages>
  8001fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8001ff:	e8 a5 1f 00 00       	call   8021a9 <sys_calculate_free_frames>
  800204:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int numOfReqPages2 = numOfFreeWSEntries ;
  800207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80020a:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int numOfReqTables2 = (ROUNDUP(numOfReqPages1+numOfReqPages2, 1024) - ROUNDUP(numOfReqPages1, 1024)) / 1024;
  80020d:	c7 45 b8 00 04 00 00 	movl   $0x400,-0x48(%ebp)
  800214:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800217:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80021a:	01 d0                	add    %edx,%eax
  80021c:	89 c2                	mov    %eax,%edx
  80021e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800221:	01 d0                	add    %edx,%eax
  800223:	48                   	dec    %eax
  800224:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800227:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80022a:	ba 00 00 00 00       	mov    $0x0,%edx
  80022f:	f7 75 b8             	divl   -0x48(%ebp)
  800232:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800235:	29 d0                	sub    %edx,%eax
  800237:	89 c1                	mov    %eax,%ecx
  800239:	c7 45 b0 00 04 00 00 	movl   $0x400,-0x50(%ebp)
  800240:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800243:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800246:	01 d0                	add    %edx,%eax
  800248:	48                   	dec    %eax
  800249:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80024c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80024f:	ba 00 00 00 00       	mov    $0x0,%edx
  800254:	f7 75 b0             	divl   -0x50(%ebp)
  800257:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80025a:	29 d0                	sub    %edx,%eax
  80025c:	29 c1                	sub    %eax,%ecx
  80025e:	89 c8                	mov    %ecx,%eax
  800260:	85 c0                	test   %eax,%eax
  800262:	79 05                	jns    800269 <_main+0x231>
  800264:	05 ff 03 00 00       	add    $0x3ff,%eax
  800269:	c1 f8 0a             	sar    $0xa,%eax
  80026c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		int size2 = numOfReqPages2 * PAGE_SIZE;
  80026f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800272:	c1 e0 0c             	shl    $0xc,%eax
  800275:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		int8 *x2 = malloc(size2);
  800278:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	50                   	push   %eax
  80027f:	e8 4e 17 00 00       	call   8019d2 <malloc>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 a0             	mov    %eax,-0x60(%ebp)
		assert((uint32) x2 == USER_HEAP_START + size1);
  80028a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80028d:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800293:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800296:	39 c2                	cmp    %eax,%edx
  800298:	74 16                	je     8002b0 <_main+0x278>
  80029a:	68 84 2a 80 00       	push   $0x802a84
  80029f:	68 58 29 80 00       	push   $0x802958
  8002a4:	6a 32                	push   $0x32
  8002a6:	68 6d 29 80 00       	push   $0x80296d
  8002ab:	e8 f6 06 00 00       	call   8009a6 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1*numOfReqTables2));
  8002b0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8002b3:	e8 f1 1e 00 00       	call   8021a9 <sys_calculate_free_frames>
  8002b8:	29 c3                	sub    %eax,%ebx
  8002ba:	89 da                	mov    %ebx,%edx
  8002bc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8002bf:	39 c2                	cmp    %eax,%edx
  8002c1:	74 16                	je     8002d9 <_main+0x2a1>
  8002c3:	68 ac 2a 80 00       	push   $0x802aac
  8002c8:	68 58 29 80 00       	push   $0x802958
  8002cd:	6a 33                	push   $0x33
  8002cf:	68 6d 29 80 00       	push   $0x80296d
  8002d4:	e8 cd 06 00 00       	call   8009a6 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == numOfReqPages2);
  8002d9:	e8 4e 1f 00 00       	call   80222c <sys_pf_calculate_allocated_pages>
  8002de:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002e1:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8002e4:	74 16                	je     8002fc <_main+0x2c4>
  8002e6:	68 f0 2a 80 00       	push   $0x802af0
  8002eb:	68 58 29 80 00       	push   $0x802958
  8002f0:	6a 34                	push   $0x34
  8002f2:	68 6d 29 80 00       	push   $0x80296d
  8002f7:	e8 aa 06 00 00       	call   8009a6 <_panic>
		assert(CheckWSEntries(myEnv, (uint32)x2, (uint32)x2+size2) == 0);
  8002fc:	8b 55 a0             	mov    -0x60(%ebp),%edx
  8002ff:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800302:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800305:	8b 55 a0             	mov    -0x60(%ebp),%edx
  800308:	a1 20 40 80 00       	mov    0x804020,%eax
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	51                   	push   %ecx
  800311:	52                   	push   %edx
  800312:	50                   	push   %eax
  800313:	e8 a8 04 00 00       	call   8007c0 <CheckWSEntries>
  800318:	83 c4 10             	add    $0x10,%esp
  80031b:	85 c0                	test   %eax,%eax
  80031d:	74 16                	je     800335 <_main+0x2fd>
  80031f:	68 38 2b 80 00       	push   $0x802b38
  800324:	68 58 29 80 00       	push   $0x802958
  800329:	6a 35                	push   $0x35
  80032b:	68 6d 29 80 00       	push   $0x80296d
  800330:	e8 71 06 00 00       	call   8009a6 <_panic>

		//allocate Half the remaining WS free size in the heap [Should alloc in RAM and Page File]
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800335:	e8 f2 1e 00 00       	call   80222c <sys_pf_calculate_allocated_pages>
  80033a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80033d:	e8 67 1e 00 00       	call   8021a9 <sys_calculate_free_frames>
  800342:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int numOfReqPages3 = (numOfFreeWSEntries - numOfReqPages1) /2 ;
  800345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800348:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80034b:	89 c2                	mov    %eax,%edx
  80034d:	c1 ea 1f             	shr    $0x1f,%edx
  800350:	01 d0                	add    %edx,%eax
  800352:	d1 f8                	sar    %eax
  800354:	89 45 9c             	mov    %eax,-0x64(%ebp)
		int numOfReqTables3 = (ROUNDUP(numOfReqPages1+numOfReqPages2+numOfReqPages3, 1024) - ROUNDUP(numOfReqPages1+numOfReqPages2, 1024)) / 1024;
  800357:	c7 45 98 00 04 00 00 	movl   $0x400,-0x68(%ebp)
  80035e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800361:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800369:	01 d0                	add    %edx,%eax
  80036b:	89 c2                	mov    %eax,%edx
  80036d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800370:	01 d0                	add    %edx,%eax
  800372:	48                   	dec    %eax
  800373:	89 45 94             	mov    %eax,-0x6c(%ebp)
  800376:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800379:	ba 00 00 00 00       	mov    $0x0,%edx
  80037e:	f7 75 98             	divl   -0x68(%ebp)
  800381:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800384:	29 d0                	sub    %edx,%eax
  800386:	89 c1                	mov    %eax,%ecx
  800388:	c7 45 90 00 04 00 00 	movl   $0x400,-0x70(%ebp)
  80038f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800392:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800395:	01 d0                	add    %edx,%eax
  800397:	89 c2                	mov    %eax,%edx
  800399:	8b 45 90             	mov    -0x70(%ebp),%eax
  80039c:	01 d0                	add    %edx,%eax
  80039e:	48                   	dec    %eax
  80039f:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8003a2:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003aa:	f7 75 90             	divl   -0x70(%ebp)
  8003ad:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003b0:	29 d0                	sub    %edx,%eax
  8003b2:	29 c1                	sub    %eax,%ecx
  8003b4:	89 c8                	mov    %ecx,%eax
  8003b6:	85 c0                	test   %eax,%eax
  8003b8:	79 05                	jns    8003bf <_main+0x387>
  8003ba:	05 ff 03 00 00       	add    $0x3ff,%eax
  8003bf:	c1 f8 0a             	sar    $0xa,%eax
  8003c2:	89 45 88             	mov    %eax,-0x78(%ebp)
		int extraTable = 0;
  8003c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (numOfReqTables2 > 0)
  8003cc:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  8003d0:	7e 07                	jle    8003d9 <_main+0x3a1>
			extraTable = 1; //as numOfReqTables2 is not allocated in RAM for the prev. alloc.
  8003d2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
		int size3 = numOfReqPages3 * PAGE_SIZE;
  8003d9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003dc:	c1 e0 0c             	shl    $0xc,%eax
  8003df:	89 45 84             	mov    %eax,-0x7c(%ebp)
		int8 *x3 = malloc(size3);
  8003e2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	50                   	push   %eax
  8003e9:	e8 e4 15 00 00       	call   8019d2 <malloc>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	89 45 80             	mov    %eax,-0x80(%ebp)
		assert((uint32) x3 == USER_HEAP_START + size1 + size2);
  8003f4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003f7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fa:	01 d0                	add    %edx,%eax
  8003fc:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800402:	8b 45 80             	mov    -0x80(%ebp),%eax
  800405:	39 c2                	cmp    %eax,%edx
  800407:	74 16                	je     80041f <_main+0x3e7>
  800409:	68 74 2b 80 00       	push   $0x802b74
  80040e:	68 58 29 80 00       	push   $0x802958
  800413:	6a 41                	push   $0x41
  800415:	68 6d 29 80 00       	push   $0x80296d
  80041a:	e8 87 05 00 00       	call   8009a6 <_panic>
//		cprintf("startVA = %x, size = %x, numOfReqTables = %d, numOfReqPages = %d\n", x3, size3, numOfReqTables3,numOfReqPages3);
//		cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames());
		assert((freeFrames - sys_calculate_free_frames()) == (extraTable + 2*numOfReqTables3 + numOfReqPages3));
  80041f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800422:	e8 82 1d 00 00       	call   8021a9 <sys_calculate_free_frames>
  800427:	29 c3                	sub    %eax,%ebx
  800429:	89 da                	mov    %ebx,%edx
  80042b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80042e:	01 c0                	add    %eax,%eax
  800430:	89 c1                	mov    %eax,%ecx
  800432:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800435:	01 c1                	add    %eax,%ecx
  800437:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80043a:	01 c8                	add    %ecx,%eax
  80043c:	39 c2                	cmp    %eax,%edx
  80043e:	74 16                	je     800456 <_main+0x41e>
  800440:	68 a4 2b 80 00       	push   $0x802ba4
  800445:	68 58 29 80 00       	push   $0x802958
  80044a:	6a 44                	push   $0x44
  80044c:	68 6d 29 80 00       	push   $0x80296d
  800451:	e8 50 05 00 00       	call   8009a6 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == numOfReqPages3);
  800456:	e8 d1 1d 00 00       	call   80222c <sys_pf_calculate_allocated_pages>
  80045b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80045e:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800461:	74 16                	je     800479 <_main+0x441>
  800463:	68 04 2c 80 00       	push   $0x802c04
  800468:	68 58 29 80 00       	push   $0x802958
  80046d:	6a 45                	push   $0x45
  80046f:	68 6d 29 80 00       	push   $0x80296d
  800474:	e8 2d 05 00 00       	call   8009a6 <_panic>
		assert(CheckWSEntries(myEnv, (uint32)x3, (uint32)x3+size3) == numOfReqPages3);
  800479:	8b 55 80             	mov    -0x80(%ebp),%edx
  80047c:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80047f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800482:	8b 55 80             	mov    -0x80(%ebp),%edx
  800485:	a1 20 40 80 00       	mov    0x804020,%eax
  80048a:	83 ec 04             	sub    $0x4,%esp
  80048d:	51                   	push   %ecx
  80048e:	52                   	push   %edx
  80048f:	50                   	push   %eax
  800490:	e8 2b 03 00 00       	call   8007c0 <CheckWSEntries>
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  80049b:	74 16                	je     8004b3 <_main+0x47b>
  80049d:	68 4c 2c 80 00       	push   $0x802c4c
  8004a2:	68 58 29 80 00       	push   $0x802958
  8004a7:	6a 46                	push   $0x46
  8004a9:	68 6d 29 80 00       	push   $0x80296d
  8004ae:	e8 f3 04 00 00       	call   8009a6 <_panic>

		//allocate half original WS free size in the heap [should not be all. in RAM]
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004b3:	e8 74 1d 00 00       	call   80222c <sys_pf_calculate_allocated_pages>
  8004b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8004bb:	e8 e9 1c 00 00       	call   8021a9 <sys_calculate_free_frames>
  8004c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int numOfReqPages4 = numOfFreeWSEntries/2 ;
  8004c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004c6:	89 c2                	mov    %eax,%edx
  8004c8:	c1 ea 1f             	shr    $0x1f,%edx
  8004cb:	01 d0                	add    %edx,%eax
  8004cd:	d1 f8                	sar    %eax
  8004cf:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		int numOfReqTables4 = (ROUNDUP(numOfReqPages1+numOfReqPages2+numOfReqPages3+numOfReqPages4, 1024) - ROUNDUP(numOfReqPages1+numOfReqPages2+numOfReqPages3, 1024)) / 1024;
  8004d5:	c7 85 78 ff ff ff 00 	movl   $0x400,-0x88(%ebp)
  8004dc:	04 00 00 
  8004df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004e2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004e5:	01 c2                	add    %eax,%edx
  8004e7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004ea:	01 c2                	add    %eax,%edx
  8004ec:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8004f2:	01 d0                	add    %edx,%eax
  8004f4:	89 c2                	mov    %eax,%edx
  8004f6:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8004fc:	01 d0                	add    %edx,%eax
  8004fe:	48                   	dec    %eax
  8004ff:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  800505:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80050b:	ba 00 00 00 00       	mov    $0x0,%edx
  800510:	f7 b5 78 ff ff ff    	divl   -0x88(%ebp)
  800516:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80051c:	29 d0                	sub    %edx,%eax
  80051e:	89 c1                	mov    %eax,%ecx
  800520:	c7 85 70 ff ff ff 00 	movl   $0x400,-0x90(%ebp)
  800527:	04 00 00 
  80052a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80052d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800530:	01 c2                	add    %eax,%edx
  800532:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800535:	01 d0                	add    %edx,%eax
  800537:	89 c2                	mov    %eax,%edx
  800539:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80053f:	01 d0                	add    %edx,%eax
  800541:	48                   	dec    %eax
  800542:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800548:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80054e:	ba 00 00 00 00       	mov    $0x0,%edx
  800553:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  800559:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80055f:	29 d0                	sub    %edx,%eax
  800561:	29 c1                	sub    %eax,%ecx
  800563:	89 c8                	mov    %ecx,%eax
  800565:	85 c0                	test   %eax,%eax
  800567:	79 05                	jns    80056e <_main+0x536>
  800569:	05 ff 03 00 00       	add    $0x3ff,%eax
  80056e:	c1 f8 0a             	sar    $0xa,%eax
  800571:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		int size4 = numOfReqPages4 * PAGE_SIZE;
  800577:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80057d:	c1 e0 0c             	shl    $0xc,%eax
  800580:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		int8 *x4 = malloc(size4);
  800586:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80058c:	83 ec 0c             	sub    $0xc,%esp
  80058f:	50                   	push   %eax
  800590:	e8 3d 14 00 00       	call   8019d2 <malloc>
  800595:	83 c4 10             	add    $0x10,%esp
  800598:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		assert((uint32) x4 == USER_HEAP_START + size1 + size2 + size3);
  80059e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005a1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8005a4:	01 c2                	add    %eax,%edx
  8005a6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005a9:	01 d0                	add    %edx,%eax
  8005ab:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8005b1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8005b7:	39 c2                	cmp    %eax,%edx
  8005b9:	74 16                	je     8005d1 <_main+0x599>
  8005bb:	68 94 2c 80 00       	push   $0x802c94
  8005c0:	68 58 29 80 00       	push   $0x802958
  8005c5:	6a 4f                	push   $0x4f
  8005c7:	68 6d 29 80 00       	push   $0x80296d
  8005cc:	e8 d5 03 00 00       	call   8009a6 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1*numOfReqTables4));
  8005d1:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8005d4:	e8 d0 1b 00 00       	call   8021a9 <sys_calculate_free_frames>
  8005d9:	29 c3                	sub    %eax,%ebx
  8005db:	89 da                	mov    %ebx,%edx
  8005dd:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8005e3:	39 c2                	cmp    %eax,%edx
  8005e5:	74 16                	je     8005fd <_main+0x5c5>
  8005e7:	68 cc 2c 80 00       	push   $0x802ccc
  8005ec:	68 58 29 80 00       	push   $0x802958
  8005f1:	6a 50                	push   $0x50
  8005f3:	68 6d 29 80 00       	push   $0x80296d
  8005f8:	e8 a9 03 00 00       	call   8009a6 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == numOfReqPages4);
  8005fd:	e8 2a 1c 00 00       	call   80222c <sys_pf_calculate_allocated_pages>
  800602:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800605:	3b 85 7c ff ff ff    	cmp    -0x84(%ebp),%eax
  80060b:	74 16                	je     800623 <_main+0x5eb>
  80060d:	68 10 2d 80 00       	push   $0x802d10
  800612:	68 58 29 80 00       	push   $0x802958
  800617:	6a 51                	push   $0x51
  800619:	68 6d 29 80 00       	push   $0x80296d
  80061e:	e8 83 03 00 00       	call   8009a6 <_panic>
		assert(CheckWSEntries(myEnv, (uint32)x4, (uint32)x4+size4) == 0);
  800623:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800629:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80062f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800632:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800638:	a1 20 40 80 00       	mov    0x804020,%eax
  80063d:	83 ec 04             	sub    $0x4,%esp
  800640:	51                   	push   %ecx
  800641:	52                   	push   %edx
  800642:	50                   	push   %eax
  800643:	e8 78 01 00 00       	call   8007c0 <CheckWSEntries>
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	85 c0                	test   %eax,%eax
  80064d:	74 16                	je     800665 <_main+0x62d>
  80064f:	68 58 2d 80 00       	push   $0x802d58
  800654:	68 58 29 80 00       	push   $0x802958
  800659:	6a 52                	push   $0x52
  80065b:	68 6d 29 80 00       	push   $0x80296d
  800660:	e8 41 03 00 00       	call   8009a6 <_panic>

		//Access already allocated in RAM and Page File
		freeFrames = sys_calculate_free_frames() ;
  800665:	e8 3f 1b 00 00       	call   8021a9 <sys_calculate_free_frames>
  80066a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80066d:	e8 ba 1b 00 00       	call   80222c <sys_pf_calculate_allocated_pages>
  800672:	89 45 dc             	mov    %eax,-0x24(%ebp)
		{
			x1[0] = -1 ;
  800675:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800678:	c6 00 ff             	movb   $0xff,(%eax)
			x3[0] = -1 ;
  80067b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80067e:	c6 00 ff             	movb   $0xff,(%eax)
		}
		assert(x1[0] == -1);
  800681:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800684:	8a 00                	mov    (%eax),%al
  800686:	3c ff                	cmp    $0xff,%al
  800688:	74 16                	je     8006a0 <_main+0x668>
  80068a:	68 91 2d 80 00       	push   $0x802d91
  80068f:	68 58 29 80 00       	push   $0x802958
  800694:	6a 5b                	push   $0x5b
  800696:	68 6d 29 80 00       	push   $0x80296d
  80069b:	e8 06 03 00 00       	call   8009a6 <_panic>
		assert(x3[0] == -1);
  8006a0:	8b 45 80             	mov    -0x80(%ebp),%eax
  8006a3:	8a 00                	mov    (%eax),%al
  8006a5:	3c ff                	cmp    $0xff,%al
  8006a7:	74 16                	je     8006bf <_main+0x687>
  8006a9:	68 9d 2d 80 00       	push   $0x802d9d
  8006ae:	68 58 29 80 00       	push   $0x802958
  8006b3:	6a 5c                	push   $0x5c
  8006b5:	68 6d 29 80 00       	push   $0x80296d
  8006ba:	e8 e7 02 00 00       	call   8009a6 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == 0 );
  8006bf:	e8 e5 1a 00 00       	call   8021a9 <sys_calculate_free_frames>
  8006c4:	89 c2                	mov    %eax,%edx
  8006c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c9:	39 c2                	cmp    %eax,%edx
  8006cb:	74 16                	je     8006e3 <_main+0x6ab>
  8006cd:	68 ac 2d 80 00       	push   $0x802dac
  8006d2:	68 58 29 80 00       	push   $0x802958
  8006d7:	6a 5d                	push   $0x5d
  8006d9:	68 6d 29 80 00       	push   $0x80296d
  8006de:	e8 c3 02 00 00       	call   8009a6 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  8006e3:	e8 44 1b 00 00       	call   80222c <sys_pf_calculate_allocated_pages>
  8006e8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006eb:	74 16                	je     800703 <_main+0x6cb>
  8006ed:	68 dc 2d 80 00       	push   $0x802ddc
  8006f2:	68 58 29 80 00       	push   $0x802958
  8006f7:	6a 5e                	push   $0x5e
  8006f9:	68 6d 29 80 00       	push   $0x80296d
  8006fe:	e8 a3 02 00 00       	call   8009a6 <_panic>

		//Access allocated in Page File ONLY
		freeFrames = sys_calculate_free_frames() ;
  800703:	e8 a1 1a 00 00       	call   8021a9 <sys_calculate_free_frames>
  800708:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80070b:	e8 1c 1b 00 00       	call   80222c <sys_pf_calculate_allocated_pages>
  800710:	89 45 dc             	mov    %eax,-0x24(%ebp)
		{
			x2[0] = -1 ;
  800713:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800716:	c6 00 ff             	movb   $0xff,(%eax)
			x4[0] = -1 ;
  800719:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80071f:	c6 00 ff             	movb   $0xff,(%eax)
		}
		assert(x2[0] == -1);
  800722:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800725:	8a 00                	mov    (%eax),%al
  800727:	3c ff                	cmp    $0xff,%al
  800729:	74 16                	je     800741 <_main+0x709>
  80072b:	68 16 2e 80 00       	push   $0x802e16
  800730:	68 58 29 80 00       	push   $0x802958
  800735:	6a 67                	push   $0x67
  800737:	68 6d 29 80 00       	push   $0x80296d
  80073c:	e8 65 02 00 00       	call   8009a6 <_panic>
		assert(x4[0] == -1);
  800741:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800747:	8a 00                	mov    (%eax),%al
  800749:	3c ff                	cmp    $0xff,%al
  80074b:	74 16                	je     800763 <_main+0x72b>
  80074d:	68 22 2e 80 00       	push   $0x802e22
  800752:	68 58 29 80 00       	push   $0x802958
  800757:	6a 68                	push   $0x68
  800759:	68 6d 29 80 00       	push   $0x80296d
  80075e:	e8 43 02 00 00       	call   8009a6 <_panic>
		
		assert((freeFrames - sys_calculate_free_frames()) >= 2);
  800763:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800766:	e8 3e 1a 00 00       	call   8021a9 <sys_calculate_free_frames>
  80076b:	29 c3                	sub    %eax,%ebx
  80076d:	89 d8                	mov    %ebx,%eax
  80076f:	83 f8 01             	cmp    $0x1,%eax
  800772:	77 16                	ja     80078a <_main+0x752>
  800774:	68 30 2e 80 00       	push   $0x802e30
  800779:	68 58 29 80 00       	push   $0x802958
  80077e:	6a 6a                	push   $0x6a
  800780:	68 6d 29 80 00       	push   $0x80296d
  800785:	e8 1c 02 00 00       	call   8009a6 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  80078a:	e8 9d 1a 00 00       	call   80222c <sys_pf_calculate_allocated_pages>
  80078f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800792:	74 16                	je     8007aa <_main+0x772>
  800794:	68 dc 2d 80 00       	push   $0x802ddc
  800799:	68 58 29 80 00       	push   $0x802958
  80079e:	6a 6b                	push   $0x6b
  8007a0:	68 6d 29 80 00       	push   $0x80296d
  8007a5:	e8 fc 01 00 00       	call   8009a6 <_panic>

	}
	cprintf("Congratulations!! your modification is completed successfully.\n");
  8007aa:	83 ec 0c             	sub    $0xc,%esp
  8007ad:	68 60 2e 80 00       	push   $0x802e60
  8007b2:	e8 91 04 00 00       	call   800c48 <cprintf>
  8007b7:	83 c4 10             	add    $0x10,%esp

	return;
  8007ba:	90                   	nop
}
  8007bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <CheckWSEntries>:



int CheckWSEntries(volatile struct Env* e, uint32 startVA, uint32 endVA)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	83 ec 20             	sub    $0x20,%esp
	uint32 va ;
	startVA = ROUNDDOWN(startVA, PAGE_SIZE);
  8007c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007d4:	89 45 0c             	mov    %eax,0xc(%ebp)
	endVA = ROUNDUP(endVA, PAGE_SIZE);
  8007d7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8007de:	8b 55 10             	mov    0x10(%ebp),%edx
  8007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e4:	01 d0                	add    %edx,%eax
  8007e6:	48                   	dec    %eax
  8007e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8007ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f2:	f7 75 ec             	divl   -0x14(%ebp)
  8007f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007f8:	29 d0                	sub    %edx,%eax
  8007fa:	89 45 10             	mov    %eax,0x10(%ebp)
	int totalNumOfFound = 0 ;
  8007fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (va = startVA; va < endVA; va+=PAGE_SIZE)
  800804:	8b 45 0c             	mov    0xc(%ebp),%eax
  800807:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80080a:	eb 48                	jmp    800854 <CheckWSEntries+0x94>
	{
		int i;
		for (i = 0; i < e->page_WS_max_size; ++i)
  80080c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800813:	eb 2b                	jmp    800840 <CheckWSEntries+0x80>
		{
			if( ROUNDDOWN(e->__uptr_pws[i].virtual_address,PAGE_SIZE) == va)
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80081e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800821:	c1 e2 04             	shl    $0x4,%edx
  800824:	01 d0                	add    %edx,%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80082b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80082e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800833:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800836:	75 05                	jne    80083d <CheckWSEntries+0x7d>
			{
				totalNumOfFound++ ;
  800838:	ff 45 f8             	incl   -0x8(%ebp)
				break;
  80083b:	eb 10                	jmp    80084d <CheckWSEntries+0x8d>
	endVA = ROUNDUP(endVA, PAGE_SIZE);
	int totalNumOfFound = 0 ;
	for (va = startVA; va < endVA; va+=PAGE_SIZE)
	{
		int i;
		for (i = 0; i < e->page_WS_max_size; ++i)
  80083d:	ff 45 f4             	incl   -0xc(%ebp)
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	8b 50 74             	mov    0x74(%eax),%edx
  800846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800849:	39 c2                	cmp    %eax,%edx
  80084b:	77 c8                	ja     800815 <CheckWSEntries+0x55>
{
	uint32 va ;
	startVA = ROUNDDOWN(startVA, PAGE_SIZE);
	endVA = ROUNDUP(endVA, PAGE_SIZE);
	int totalNumOfFound = 0 ;
	for (va = startVA; va < endVA; va+=PAGE_SIZE)
  80084d:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%ebp)
  800854:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800857:	3b 45 10             	cmp    0x10(%ebp),%eax
  80085a:	72 b0                	jb     80080c <CheckWSEntries+0x4c>
				totalNumOfFound++ ;
				break;
			}
		}
	}
	return totalNumOfFound;
  80085c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80085f:	c9                   	leave  
  800860:	c3                   	ret    

00800861 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
  800864:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800867:	e8 72 18 00 00       	call   8020de <sys_getenvindex>
  80086c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80086f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800872:	89 d0                	mov    %edx,%eax
  800874:	c1 e0 03             	shl    $0x3,%eax
  800877:	01 d0                	add    %edx,%eax
  800879:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800880:	01 c8                	add    %ecx,%eax
  800882:	01 c0                	add    %eax,%eax
  800884:	01 d0                	add    %edx,%eax
  800886:	01 c0                	add    %eax,%eax
  800888:	01 d0                	add    %edx,%eax
  80088a:	89 c2                	mov    %eax,%edx
  80088c:	c1 e2 05             	shl    $0x5,%edx
  80088f:	29 c2                	sub    %eax,%edx
  800891:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800898:	89 c2                	mov    %eax,%edx
  80089a:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8008a0:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8008a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8008aa:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8008b0:	84 c0                	test   %al,%al
  8008b2:	74 0f                	je     8008c3 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8008b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8008b9:	05 40 3c 01 00       	add    $0x13c40,%eax
  8008be:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008c7:	7e 0a                	jle    8008d3 <libmain+0x72>
		binaryname = argv[0];
  8008c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	ff 75 08             	pushl  0x8(%ebp)
  8008dc:	e8 57 f7 ff ff       	call   800038 <_main>
  8008e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8008e4:	e8 90 19 00 00       	call   802279 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8008e9:	83 ec 0c             	sub    $0xc,%esp
  8008ec:	68 b8 2e 80 00       	push   $0x802eb8
  8008f1:	e8 52 03 00 00       	call   800c48 <cprintf>
  8008f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8008fe:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800904:	a1 20 40 80 00       	mov    0x804020,%eax
  800909:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80090f:	83 ec 04             	sub    $0x4,%esp
  800912:	52                   	push   %edx
  800913:	50                   	push   %eax
  800914:	68 e0 2e 80 00       	push   $0x802ee0
  800919:	e8 2a 03 00 00       	call   800c48 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800921:	a1 20 40 80 00       	mov    0x804020,%eax
  800926:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80092c:	a1 20 40 80 00       	mov    0x804020,%eax
  800931:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800937:	83 ec 04             	sub    $0x4,%esp
  80093a:	52                   	push   %edx
  80093b:	50                   	push   %eax
  80093c:	68 08 2f 80 00       	push   $0x802f08
  800941:	e8 02 03 00 00       	call   800c48 <cprintf>
  800946:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800949:	a1 20 40 80 00       	mov    0x804020,%eax
  80094e:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	50                   	push   %eax
  800958:	68 49 2f 80 00       	push   $0x802f49
  80095d:	e8 e6 02 00 00       	call   800c48 <cprintf>
  800962:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800965:	83 ec 0c             	sub    $0xc,%esp
  800968:	68 b8 2e 80 00       	push   $0x802eb8
  80096d:	e8 d6 02 00 00       	call   800c48 <cprintf>
  800972:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800975:	e8 19 19 00 00       	call   802293 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80097a:	e8 19 00 00 00       	call   800998 <exit>
}
  80097f:	90                   	nop
  800980:	c9                   	leave  
  800981:	c3                   	ret    

00800982 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800988:	83 ec 0c             	sub    $0xc,%esp
  80098b:	6a 00                	push   $0x0
  80098d:	e8 18 17 00 00       	call   8020aa <sys_env_destroy>
  800992:	83 c4 10             	add    $0x10,%esp
}
  800995:	90                   	nop
  800996:	c9                   	leave  
  800997:	c3                   	ret    

00800998 <exit>:

void
exit(void)
{
  800998:	55                   	push   %ebp
  800999:	89 e5                	mov    %esp,%ebp
  80099b:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80099e:	e8 6d 17 00 00       	call   802110 <sys_env_exit>
}
  8009a3:	90                   	nop
  8009a4:	c9                   	leave  
  8009a5:	c3                   	ret    

008009a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009ac:	8d 45 10             	lea    0x10(%ebp),%eax
  8009af:	83 c0 04             	add    $0x4,%eax
  8009b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009b5:	a1 18 41 80 00       	mov    0x804118,%eax
  8009ba:	85 c0                	test   %eax,%eax
  8009bc:	74 16                	je     8009d4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009be:	a1 18 41 80 00       	mov    0x804118,%eax
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	50                   	push   %eax
  8009c7:	68 60 2f 80 00       	push   $0x802f60
  8009cc:	e8 77 02 00 00       	call   800c48 <cprintf>
  8009d1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009d4:	a1 00 40 80 00       	mov    0x804000,%eax
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	ff 75 08             	pushl  0x8(%ebp)
  8009df:	50                   	push   %eax
  8009e0:	68 65 2f 80 00       	push   $0x802f65
  8009e5:	e8 5e 02 00 00       	call   800c48 <cprintf>
  8009ea:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8009ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f6:	50                   	push   %eax
  8009f7:	e8 e1 01 00 00       	call   800bdd <vcprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	6a 00                	push   $0x0
  800a04:	68 81 2f 80 00       	push   $0x802f81
  800a09:	e8 cf 01 00 00       	call   800bdd <vcprintf>
  800a0e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a11:	e8 82 ff ff ff       	call   800998 <exit>

	// should not return here
	while (1) ;
  800a16:	eb fe                	jmp    800a16 <_panic+0x70>

00800a18 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a1e:	a1 20 40 80 00       	mov    0x804020,%eax
  800a23:	8b 50 74             	mov    0x74(%eax),%edx
  800a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a29:	39 c2                	cmp    %eax,%edx
  800a2b:	74 14                	je     800a41 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a2d:	83 ec 04             	sub    $0x4,%esp
  800a30:	68 84 2f 80 00       	push   $0x802f84
  800a35:	6a 26                	push   $0x26
  800a37:	68 d0 2f 80 00       	push   $0x802fd0
  800a3c:	e8 65 ff ff ff       	call   8009a6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a48:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a4f:	e9 b6 00 00 00       	jmp    800b0a <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a57:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	01 d0                	add    %edx,%eax
  800a63:	8b 00                	mov    (%eax),%eax
  800a65:	85 c0                	test   %eax,%eax
  800a67:	75 08                	jne    800a71 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800a69:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a6c:	e9 96 00 00 00       	jmp    800b07 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800a71:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a78:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a7f:	eb 5d                	jmp    800ade <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a81:	a1 20 40 80 00       	mov    0x804020,%eax
  800a86:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800a8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a8f:	c1 e2 04             	shl    $0x4,%edx
  800a92:	01 d0                	add    %edx,%eax
  800a94:	8a 40 04             	mov    0x4(%eax),%al
  800a97:	84 c0                	test   %al,%al
  800a99:	75 40                	jne    800adb <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a9b:	a1 20 40 80 00       	mov    0x804020,%eax
  800aa0:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800aa6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aa9:	c1 e2 04             	shl    $0x4,%edx
  800aac:	01 d0                	add    %edx,%eax
  800aae:	8b 00                	mov    (%eax),%eax
  800ab0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800ab3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ab6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800abb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	01 c8                	add    %ecx,%eax
  800acc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ace:	39 c2                	cmp    %eax,%edx
  800ad0:	75 09                	jne    800adb <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800ad2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800ad9:	eb 12                	jmp    800aed <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800adb:	ff 45 e8             	incl   -0x18(%ebp)
  800ade:	a1 20 40 80 00       	mov    0x804020,%eax
  800ae3:	8b 50 74             	mov    0x74(%eax),%edx
  800ae6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ae9:	39 c2                	cmp    %eax,%edx
  800aeb:	77 94                	ja     800a81 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800aed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800af1:	75 14                	jne    800b07 <CheckWSWithoutLastIndex+0xef>
			panic(
  800af3:	83 ec 04             	sub    $0x4,%esp
  800af6:	68 dc 2f 80 00       	push   $0x802fdc
  800afb:	6a 3a                	push   $0x3a
  800afd:	68 d0 2f 80 00       	push   $0x802fd0
  800b02:	e8 9f fe ff ff       	call   8009a6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b07:	ff 45 f0             	incl   -0x10(%ebp)
  800b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b10:	0f 8c 3e ff ff ff    	jl     800a54 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b16:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b1d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b24:	eb 20                	jmp    800b46 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b26:	a1 20 40 80 00       	mov    0x804020,%eax
  800b2b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b31:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b34:	c1 e2 04             	shl    $0x4,%edx
  800b37:	01 d0                	add    %edx,%eax
  800b39:	8a 40 04             	mov    0x4(%eax),%al
  800b3c:	3c 01                	cmp    $0x1,%al
  800b3e:	75 03                	jne    800b43 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800b40:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b43:	ff 45 e0             	incl   -0x20(%ebp)
  800b46:	a1 20 40 80 00       	mov    0x804020,%eax
  800b4b:	8b 50 74             	mov    0x74(%eax),%edx
  800b4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b51:	39 c2                	cmp    %eax,%edx
  800b53:	77 d1                	ja     800b26 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b58:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b5b:	74 14                	je     800b71 <CheckWSWithoutLastIndex+0x159>
		panic(
  800b5d:	83 ec 04             	sub    $0x4,%esp
  800b60:	68 30 30 80 00       	push   $0x803030
  800b65:	6a 44                	push   $0x44
  800b67:	68 d0 2f 80 00       	push   $0x802fd0
  800b6c:	e8 35 fe ff ff       	call   8009a6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b71:	90                   	nop
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7d:	8b 00                	mov    (%eax),%eax
  800b7f:	8d 48 01             	lea    0x1(%eax),%ecx
  800b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b85:	89 0a                	mov    %ecx,(%edx)
  800b87:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8a:	88 d1                	mov    %dl,%cl
  800b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b96:	8b 00                	mov    (%eax),%eax
  800b98:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b9d:	75 2c                	jne    800bcb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b9f:	a0 24 40 80 00       	mov    0x804024,%al
  800ba4:	0f b6 c0             	movzbl %al,%eax
  800ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800baa:	8b 12                	mov    (%edx),%edx
  800bac:	89 d1                	mov    %edx,%ecx
  800bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb1:	83 c2 08             	add    $0x8,%edx
  800bb4:	83 ec 04             	sub    $0x4,%esp
  800bb7:	50                   	push   %eax
  800bb8:	51                   	push   %ecx
  800bb9:	52                   	push   %edx
  800bba:	e8 a9 14 00 00       	call   802068 <sys_cputs>
  800bbf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bce:	8b 40 04             	mov    0x4(%eax),%eax
  800bd1:	8d 50 01             	lea    0x1(%eax),%edx
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	89 50 04             	mov    %edx,0x4(%eax)
}
  800bda:	90                   	nop
  800bdb:	c9                   	leave  
  800bdc:	c3                   	ret    

00800bdd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800be6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bed:	00 00 00 
	b.cnt = 0;
  800bf0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bf7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	ff 75 08             	pushl  0x8(%ebp)
  800c00:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c06:	50                   	push   %eax
  800c07:	68 74 0b 80 00       	push   $0x800b74
  800c0c:	e8 11 02 00 00       	call   800e22 <vprintfmt>
  800c11:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800c14:	a0 24 40 80 00       	mov    0x804024,%al
  800c19:	0f b6 c0             	movzbl %al,%eax
  800c1c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c22:	83 ec 04             	sub    $0x4,%esp
  800c25:	50                   	push   %eax
  800c26:	52                   	push   %edx
  800c27:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c2d:	83 c0 08             	add    $0x8,%eax
  800c30:	50                   	push   %eax
  800c31:	e8 32 14 00 00       	call   802068 <sys_cputs>
  800c36:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c39:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800c40:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c46:	c9                   	leave  
  800c47:	c3                   	ret    

00800c48 <cprintf>:

int cprintf(const char *fmt, ...) {
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c4e:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800c55:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	ff 75 f4             	pushl  -0xc(%ebp)
  800c64:	50                   	push   %eax
  800c65:	e8 73 ff ff ff       	call   800bdd <vcprintf>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c73:	c9                   	leave  
  800c74:	c3                   	ret    

00800c75 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c7b:	e8 f9 15 00 00       	call   802279 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c80:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8f:	50                   	push   %eax
  800c90:	e8 48 ff ff ff       	call   800bdd <vcprintf>
  800c95:	83 c4 10             	add    $0x10,%esp
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c9b:	e8 f3 15 00 00       	call   802293 <sys_enable_interrupt>
	return cnt;
  800ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca3:	c9                   	leave  
  800ca4:	c3                   	ret    

00800ca5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 14             	sub    $0x14,%esp
  800cac:	8b 45 10             	mov    0x10(%ebp),%eax
  800caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cb8:	8b 45 18             	mov    0x18(%ebp),%eax
  800cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cc3:	77 55                	ja     800d1a <printnum+0x75>
  800cc5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cc8:	72 05                	jb     800ccf <printnum+0x2a>
  800cca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ccd:	77 4b                	ja     800d1a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ccf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cd2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cd5:	8b 45 18             	mov    0x18(%ebp),%eax
  800cd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdd:	52                   	push   %edx
  800cde:	50                   	push   %eax
  800cdf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ce5:	e8 b2 19 00 00       	call   80269c <__udivdi3>
  800cea:	83 c4 10             	add    $0x10,%esp
  800ced:	83 ec 04             	sub    $0x4,%esp
  800cf0:	ff 75 20             	pushl  0x20(%ebp)
  800cf3:	53                   	push   %ebx
  800cf4:	ff 75 18             	pushl  0x18(%ebp)
  800cf7:	52                   	push   %edx
  800cf8:	50                   	push   %eax
  800cf9:	ff 75 0c             	pushl  0xc(%ebp)
  800cfc:	ff 75 08             	pushl  0x8(%ebp)
  800cff:	e8 a1 ff ff ff       	call   800ca5 <printnum>
  800d04:	83 c4 20             	add    $0x20,%esp
  800d07:	eb 1a                	jmp    800d23 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d09:	83 ec 08             	sub    $0x8,%esp
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 20             	pushl  0x20(%ebp)
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	ff d0                	call   *%eax
  800d17:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d1a:	ff 4d 1c             	decl   0x1c(%ebp)
  800d1d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d21:	7f e6                	jg     800d09 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d23:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d31:	53                   	push   %ebx
  800d32:	51                   	push   %ecx
  800d33:	52                   	push   %edx
  800d34:	50                   	push   %eax
  800d35:	e8 72 1a 00 00       	call   8027ac <__umoddi3>
  800d3a:	83 c4 10             	add    $0x10,%esp
  800d3d:	05 94 32 80 00       	add    $0x803294,%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	0f be c0             	movsbl %al,%eax
  800d47:	83 ec 08             	sub    $0x8,%esp
  800d4a:	ff 75 0c             	pushl  0xc(%ebp)
  800d4d:	50                   	push   %eax
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	ff d0                	call   *%eax
  800d53:	83 c4 10             	add    $0x10,%esp
}
  800d56:	90                   	nop
  800d57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d5a:	c9                   	leave  
  800d5b:	c3                   	ret    

00800d5c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d5f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d63:	7e 1c                	jle    800d81 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8b 00                	mov    (%eax),%eax
  800d6a:	8d 50 08             	lea    0x8(%eax),%edx
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	89 10                	mov    %edx,(%eax)
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8b 00                	mov    (%eax),%eax
  800d77:	83 e8 08             	sub    $0x8,%eax
  800d7a:	8b 50 04             	mov    0x4(%eax),%edx
  800d7d:	8b 00                	mov    (%eax),%eax
  800d7f:	eb 40                	jmp    800dc1 <getuint+0x65>
	else if (lflag)
  800d81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d85:	74 1e                	je     800da5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	8d 50 04             	lea    0x4(%eax),%edx
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	89 10                	mov    %edx,(%eax)
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8b 00                	mov    (%eax),%eax
  800d99:	83 e8 04             	sub    $0x4,%eax
  800d9c:	8b 00                	mov    (%eax),%eax
  800d9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800da3:	eb 1c                	jmp    800dc1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8b 00                	mov    (%eax),%eax
  800daa:	8d 50 04             	lea    0x4(%eax),%edx
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	89 10                	mov    %edx,(%eax)
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8b 00                	mov    (%eax),%eax
  800db7:	83 e8 04             	sub    $0x4,%eax
  800dba:	8b 00                	mov    (%eax),%eax
  800dbc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dc6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dca:	7e 1c                	jle    800de8 <getint+0x25>
		return va_arg(*ap, long long);
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8b 00                	mov    (%eax),%eax
  800dd1:	8d 50 08             	lea    0x8(%eax),%edx
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	89 10                	mov    %edx,(%eax)
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8b 00                	mov    (%eax),%eax
  800dde:	83 e8 08             	sub    $0x8,%eax
  800de1:	8b 50 04             	mov    0x4(%eax),%edx
  800de4:	8b 00                	mov    (%eax),%eax
  800de6:	eb 38                	jmp    800e20 <getint+0x5d>
	else if (lflag)
  800de8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dec:	74 1a                	je     800e08 <getint+0x45>
		return va_arg(*ap, long);
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8b 00                	mov    (%eax),%eax
  800df3:	8d 50 04             	lea    0x4(%eax),%edx
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 10                	mov    %edx,(%eax)
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8b 00                	mov    (%eax),%eax
  800e00:	83 e8 04             	sub    $0x4,%eax
  800e03:	8b 00                	mov    (%eax),%eax
  800e05:	99                   	cltd   
  800e06:	eb 18                	jmp    800e20 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8b 00                	mov    (%eax),%eax
  800e0d:	8d 50 04             	lea    0x4(%eax),%edx
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	89 10                	mov    %edx,(%eax)
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8b 00                	mov    (%eax),%eax
  800e1a:	83 e8 04             	sub    $0x4,%eax
  800e1d:	8b 00                	mov    (%eax),%eax
  800e1f:	99                   	cltd   
}
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    

00800e22 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	56                   	push   %esi
  800e26:	53                   	push   %ebx
  800e27:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e2a:	eb 17                	jmp    800e43 <vprintfmt+0x21>
			if (ch == '\0')
  800e2c:	85 db                	test   %ebx,%ebx
  800e2e:	0f 84 af 03 00 00    	je     8011e3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800e34:	83 ec 08             	sub    $0x8,%esp
  800e37:	ff 75 0c             	pushl  0xc(%ebp)
  800e3a:	53                   	push   %ebx
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	ff d0                	call   *%eax
  800e40:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e43:	8b 45 10             	mov    0x10(%ebp),%eax
  800e46:	8d 50 01             	lea    0x1(%eax),%edx
  800e49:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	0f b6 d8             	movzbl %al,%ebx
  800e51:	83 fb 25             	cmp    $0x25,%ebx
  800e54:	75 d6                	jne    800e2c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e56:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e5a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e61:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e68:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e6f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e76:	8b 45 10             	mov    0x10(%ebp),%eax
  800e79:	8d 50 01             	lea    0x1(%eax),%edx
  800e7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7f:	8a 00                	mov    (%eax),%al
  800e81:	0f b6 d8             	movzbl %al,%ebx
  800e84:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e87:	83 f8 55             	cmp    $0x55,%eax
  800e8a:	0f 87 2b 03 00 00    	ja     8011bb <vprintfmt+0x399>
  800e90:	8b 04 85 b8 32 80 00 	mov    0x8032b8(,%eax,4),%eax
  800e97:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e99:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e9d:	eb d7                	jmp    800e76 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e9f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ea3:	eb d1                	jmp    800e76 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ea5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800eaf:	89 d0                	mov    %edx,%eax
  800eb1:	c1 e0 02             	shl    $0x2,%eax
  800eb4:	01 d0                	add    %edx,%eax
  800eb6:	01 c0                	add    %eax,%eax
  800eb8:	01 d8                	add    %ebx,%eax
  800eba:	83 e8 30             	sub    $0x30,%eax
  800ebd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ec8:	83 fb 2f             	cmp    $0x2f,%ebx
  800ecb:	7e 3e                	jle    800f0b <vprintfmt+0xe9>
  800ecd:	83 fb 39             	cmp    $0x39,%ebx
  800ed0:	7f 39                	jg     800f0b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ed2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ed5:	eb d5                	jmp    800eac <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ed7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eda:	83 c0 04             	add    $0x4,%eax
  800edd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee3:	83 e8 04             	sub    $0x4,%eax
  800ee6:	8b 00                	mov    (%eax),%eax
  800ee8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800eeb:	eb 1f                	jmp    800f0c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800eed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef1:	79 83                	jns    800e76 <vprintfmt+0x54>
				width = 0;
  800ef3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800efa:	e9 77 ff ff ff       	jmp    800e76 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800eff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f06:	e9 6b ff ff ff       	jmp    800e76 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f0b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f10:	0f 89 60 ff ff ff    	jns    800e76 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f1c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f23:	e9 4e ff ff ff       	jmp    800e76 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f28:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f2b:	e9 46 ff ff ff       	jmp    800e76 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f30:	8b 45 14             	mov    0x14(%ebp),%eax
  800f33:	83 c0 04             	add    $0x4,%eax
  800f36:	89 45 14             	mov    %eax,0x14(%ebp)
  800f39:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3c:	83 e8 04             	sub    $0x4,%eax
  800f3f:	8b 00                	mov    (%eax),%eax
  800f41:	83 ec 08             	sub    $0x8,%esp
  800f44:	ff 75 0c             	pushl  0xc(%ebp)
  800f47:	50                   	push   %eax
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	ff d0                	call   *%eax
  800f4d:	83 c4 10             	add    $0x10,%esp
			break;
  800f50:	e9 89 02 00 00       	jmp    8011de <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f55:	8b 45 14             	mov    0x14(%ebp),%eax
  800f58:	83 c0 04             	add    $0x4,%eax
  800f5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f61:	83 e8 04             	sub    $0x4,%eax
  800f64:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f66:	85 db                	test   %ebx,%ebx
  800f68:	79 02                	jns    800f6c <vprintfmt+0x14a>
				err = -err;
  800f6a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f6c:	83 fb 64             	cmp    $0x64,%ebx
  800f6f:	7f 0b                	jg     800f7c <vprintfmt+0x15a>
  800f71:	8b 34 9d 00 31 80 00 	mov    0x803100(,%ebx,4),%esi
  800f78:	85 f6                	test   %esi,%esi
  800f7a:	75 19                	jne    800f95 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f7c:	53                   	push   %ebx
  800f7d:	68 a5 32 80 00       	push   $0x8032a5
  800f82:	ff 75 0c             	pushl  0xc(%ebp)
  800f85:	ff 75 08             	pushl  0x8(%ebp)
  800f88:	e8 5e 02 00 00       	call   8011eb <printfmt>
  800f8d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f90:	e9 49 02 00 00       	jmp    8011de <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f95:	56                   	push   %esi
  800f96:	68 ae 32 80 00       	push   $0x8032ae
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	ff 75 08             	pushl  0x8(%ebp)
  800fa1:	e8 45 02 00 00       	call   8011eb <printfmt>
  800fa6:	83 c4 10             	add    $0x10,%esp
			break;
  800fa9:	e9 30 02 00 00       	jmp    8011de <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fae:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb1:	83 c0 04             	add    $0x4,%eax
  800fb4:	89 45 14             	mov    %eax,0x14(%ebp)
  800fb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fba:	83 e8 04             	sub    $0x4,%eax
  800fbd:	8b 30                	mov    (%eax),%esi
  800fbf:	85 f6                	test   %esi,%esi
  800fc1:	75 05                	jne    800fc8 <vprintfmt+0x1a6>
				p = "(null)";
  800fc3:	be b1 32 80 00       	mov    $0x8032b1,%esi
			if (width > 0 && padc != '-')
  800fc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fcc:	7e 6d                	jle    80103b <vprintfmt+0x219>
  800fce:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fd2:	74 67                	je     80103b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd7:	83 ec 08             	sub    $0x8,%esp
  800fda:	50                   	push   %eax
  800fdb:	56                   	push   %esi
  800fdc:	e8 0c 03 00 00       	call   8012ed <strnlen>
  800fe1:	83 c4 10             	add    $0x10,%esp
  800fe4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fe7:	eb 16                	jmp    800fff <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fe9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fed:	83 ec 08             	sub    $0x8,%esp
  800ff0:	ff 75 0c             	pushl  0xc(%ebp)
  800ff3:	50                   	push   %eax
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	ff d0                	call   *%eax
  800ff9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ffc:	ff 4d e4             	decl   -0x1c(%ebp)
  800fff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801003:	7f e4                	jg     800fe9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801005:	eb 34                	jmp    80103b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801007:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80100b:	74 1c                	je     801029 <vprintfmt+0x207>
  80100d:	83 fb 1f             	cmp    $0x1f,%ebx
  801010:	7e 05                	jle    801017 <vprintfmt+0x1f5>
  801012:	83 fb 7e             	cmp    $0x7e,%ebx
  801015:	7e 12                	jle    801029 <vprintfmt+0x207>
					putch('?', putdat);
  801017:	83 ec 08             	sub    $0x8,%esp
  80101a:	ff 75 0c             	pushl  0xc(%ebp)
  80101d:	6a 3f                	push   $0x3f
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	ff d0                	call   *%eax
  801024:	83 c4 10             	add    $0x10,%esp
  801027:	eb 0f                	jmp    801038 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801029:	83 ec 08             	sub    $0x8,%esp
  80102c:	ff 75 0c             	pushl  0xc(%ebp)
  80102f:	53                   	push   %ebx
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	ff d0                	call   *%eax
  801035:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801038:	ff 4d e4             	decl   -0x1c(%ebp)
  80103b:	89 f0                	mov    %esi,%eax
  80103d:	8d 70 01             	lea    0x1(%eax),%esi
  801040:	8a 00                	mov    (%eax),%al
  801042:	0f be d8             	movsbl %al,%ebx
  801045:	85 db                	test   %ebx,%ebx
  801047:	74 24                	je     80106d <vprintfmt+0x24b>
  801049:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80104d:	78 b8                	js     801007 <vprintfmt+0x1e5>
  80104f:	ff 4d e0             	decl   -0x20(%ebp)
  801052:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801056:	79 af                	jns    801007 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801058:	eb 13                	jmp    80106d <vprintfmt+0x24b>
				putch(' ', putdat);
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	6a 20                	push   $0x20
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	ff d0                	call   *%eax
  801067:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80106a:	ff 4d e4             	decl   -0x1c(%ebp)
  80106d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801071:	7f e7                	jg     80105a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801073:	e9 66 01 00 00       	jmp    8011de <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801078:	83 ec 08             	sub    $0x8,%esp
  80107b:	ff 75 e8             	pushl  -0x18(%ebp)
  80107e:	8d 45 14             	lea    0x14(%ebp),%eax
  801081:	50                   	push   %eax
  801082:	e8 3c fd ff ff       	call   800dc3 <getint>
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801093:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801096:	85 d2                	test   %edx,%edx
  801098:	79 23                	jns    8010bd <vprintfmt+0x29b>
				putch('-', putdat);
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	6a 2d                	push   $0x2d
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	ff d0                	call   *%eax
  8010a7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b0:	f7 d8                	neg    %eax
  8010b2:	83 d2 00             	adc    $0x0,%edx
  8010b5:	f7 da                	neg    %edx
  8010b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010c4:	e9 bc 00 00 00       	jmp    801185 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010c9:	83 ec 08             	sub    $0x8,%esp
  8010cc:	ff 75 e8             	pushl  -0x18(%ebp)
  8010cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8010d2:	50                   	push   %eax
  8010d3:	e8 84 fc ff ff       	call   800d5c <getuint>
  8010d8:	83 c4 10             	add    $0x10,%esp
  8010db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010de:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010e8:	e9 98 00 00 00       	jmp    801185 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	6a 58                	push   $0x58
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010fd:	83 ec 08             	sub    $0x8,%esp
  801100:	ff 75 0c             	pushl  0xc(%ebp)
  801103:	6a 58                	push   $0x58
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	ff d0                	call   *%eax
  80110a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80110d:	83 ec 08             	sub    $0x8,%esp
  801110:	ff 75 0c             	pushl  0xc(%ebp)
  801113:	6a 58                	push   $0x58
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	ff d0                	call   *%eax
  80111a:	83 c4 10             	add    $0x10,%esp
			break;
  80111d:	e9 bc 00 00 00       	jmp    8011de <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	6a 30                	push   $0x30
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	ff d0                	call   *%eax
  80112f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801132:	83 ec 08             	sub    $0x8,%esp
  801135:	ff 75 0c             	pushl  0xc(%ebp)
  801138:	6a 78                	push   $0x78
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	ff d0                	call   *%eax
  80113f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801142:	8b 45 14             	mov    0x14(%ebp),%eax
  801145:	83 c0 04             	add    $0x4,%eax
  801148:	89 45 14             	mov    %eax,0x14(%ebp)
  80114b:	8b 45 14             	mov    0x14(%ebp),%eax
  80114e:	83 e8 04             	sub    $0x4,%eax
  801151:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801153:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801156:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80115d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801164:	eb 1f                	jmp    801185 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801166:	83 ec 08             	sub    $0x8,%esp
  801169:	ff 75 e8             	pushl  -0x18(%ebp)
  80116c:	8d 45 14             	lea    0x14(%ebp),%eax
  80116f:	50                   	push   %eax
  801170:	e8 e7 fb ff ff       	call   800d5c <getuint>
  801175:	83 c4 10             	add    $0x10,%esp
  801178:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80117b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80117e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801185:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801189:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80118c:	83 ec 04             	sub    $0x4,%esp
  80118f:	52                   	push   %edx
  801190:	ff 75 e4             	pushl  -0x1c(%ebp)
  801193:	50                   	push   %eax
  801194:	ff 75 f4             	pushl  -0xc(%ebp)
  801197:	ff 75 f0             	pushl  -0x10(%ebp)
  80119a:	ff 75 0c             	pushl  0xc(%ebp)
  80119d:	ff 75 08             	pushl  0x8(%ebp)
  8011a0:	e8 00 fb ff ff       	call   800ca5 <printnum>
  8011a5:	83 c4 20             	add    $0x20,%esp
			break;
  8011a8:	eb 34                	jmp    8011de <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011aa:	83 ec 08             	sub    $0x8,%esp
  8011ad:	ff 75 0c             	pushl  0xc(%ebp)
  8011b0:	53                   	push   %ebx
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	ff d0                	call   *%eax
  8011b6:	83 c4 10             	add    $0x10,%esp
			break;
  8011b9:	eb 23                	jmp    8011de <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	ff 75 0c             	pushl  0xc(%ebp)
  8011c1:	6a 25                	push   $0x25
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	ff d0                	call   *%eax
  8011c8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011cb:	ff 4d 10             	decl   0x10(%ebp)
  8011ce:	eb 03                	jmp    8011d3 <vprintfmt+0x3b1>
  8011d0:	ff 4d 10             	decl   0x10(%ebp)
  8011d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d6:	48                   	dec    %eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	3c 25                	cmp    $0x25,%al
  8011db:	75 f3                	jne    8011d0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8011dd:	90                   	nop
		}
	}
  8011de:	e9 47 fc ff ff       	jmp    800e2a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011e3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011e7:	5b                   	pop    %ebx
  8011e8:	5e                   	pop    %esi
  8011e9:	5d                   	pop    %ebp
  8011ea:	c3                   	ret    

008011eb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8011f4:	83 c0 04             	add    $0x4,%eax
  8011f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801200:	50                   	push   %eax
  801201:	ff 75 0c             	pushl  0xc(%ebp)
  801204:	ff 75 08             	pushl  0x8(%ebp)
  801207:	e8 16 fc ff ff       	call   800e22 <vprintfmt>
  80120c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80120f:	90                   	nop
  801210:	c9                   	leave  
  801211:	c3                   	ret    

00801212 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801215:	8b 45 0c             	mov    0xc(%ebp),%eax
  801218:	8b 40 08             	mov    0x8(%eax),%eax
  80121b:	8d 50 01             	lea    0x1(%eax),%edx
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801224:	8b 45 0c             	mov    0xc(%ebp),%eax
  801227:	8b 10                	mov    (%eax),%edx
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	8b 40 04             	mov    0x4(%eax),%eax
  80122f:	39 c2                	cmp    %eax,%edx
  801231:	73 12                	jae    801245 <sprintputch+0x33>
		*b->buf++ = ch;
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	8b 00                	mov    (%eax),%eax
  801238:	8d 48 01             	lea    0x1(%eax),%ecx
  80123b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123e:	89 0a                	mov    %ecx,(%edx)
  801240:	8b 55 08             	mov    0x8(%ebp),%edx
  801243:	88 10                	mov    %dl,(%eax)
}
  801245:	90                   	nop
  801246:	5d                   	pop    %ebp
  801247:	c3                   	ret    

00801248 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
  80124b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	8d 50 ff             	lea    -0x1(%eax),%edx
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801262:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801269:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80126d:	74 06                	je     801275 <vsnprintf+0x2d>
  80126f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801273:	7f 07                	jg     80127c <vsnprintf+0x34>
		return -E_INVAL;
  801275:	b8 03 00 00 00       	mov    $0x3,%eax
  80127a:	eb 20                	jmp    80129c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80127c:	ff 75 14             	pushl  0x14(%ebp)
  80127f:	ff 75 10             	pushl  0x10(%ebp)
  801282:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801285:	50                   	push   %eax
  801286:	68 12 12 80 00       	push   $0x801212
  80128b:	e8 92 fb ff ff       	call   800e22 <vprintfmt>
  801290:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801293:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801296:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801299:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80129c:	c9                   	leave  
  80129d:	c3                   	ret    

0080129e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8012a7:	83 c0 04             	add    $0x4,%eax
  8012aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b3:	50                   	push   %eax
  8012b4:	ff 75 0c             	pushl  0xc(%ebp)
  8012b7:	ff 75 08             	pushl  0x8(%ebp)
  8012ba:	e8 89 ff ff ff       	call   801248 <vsnprintf>
  8012bf:	83 c4 10             	add    $0x10,%esp
  8012c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d7:	eb 06                	jmp    8012df <strlen+0x15>
		n++;
  8012d9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012dc:	ff 45 08             	incl   0x8(%ebp)
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	84 c0                	test   %al,%al
  8012e6:	75 f1                	jne    8012d9 <strlen+0xf>
		n++;
	return n;
  8012e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fa:	eb 09                	jmp    801305 <strnlen+0x18>
		n++;
  8012fc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ff:	ff 45 08             	incl   0x8(%ebp)
  801302:	ff 4d 0c             	decl   0xc(%ebp)
  801305:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801309:	74 09                	je     801314 <strnlen+0x27>
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	84 c0                	test   %al,%al
  801312:	75 e8                	jne    8012fc <strnlen+0xf>
		n++;
	return n;
  801314:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801325:	90                   	nop
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8d 50 01             	lea    0x1(%eax),%edx
  80132c:	89 55 08             	mov    %edx,0x8(%ebp)
  80132f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801332:	8d 4a 01             	lea    0x1(%edx),%ecx
  801335:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801338:	8a 12                	mov    (%edx),%dl
  80133a:	88 10                	mov    %dl,(%eax)
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	84 c0                	test   %al,%al
  801340:	75 e4                	jne    801326 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801342:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801345:	c9                   	leave  
  801346:	c3                   	ret    

00801347 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80134d:	8b 45 08             	mov    0x8(%ebp),%eax
  801350:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801353:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80135a:	eb 1f                	jmp    80137b <strncpy+0x34>
		*dst++ = *src;
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	8d 50 01             	lea    0x1(%eax),%edx
  801362:	89 55 08             	mov    %edx,0x8(%ebp)
  801365:	8b 55 0c             	mov    0xc(%ebp),%edx
  801368:	8a 12                	mov    (%edx),%dl
  80136a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	84 c0                	test   %al,%al
  801373:	74 03                	je     801378 <strncpy+0x31>
			src++;
  801375:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801378:	ff 45 fc             	incl   -0x4(%ebp)
  80137b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801381:	72 d9                	jb     80135c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801383:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801394:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801398:	74 30                	je     8013ca <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80139a:	eb 16                	jmp    8013b2 <strlcpy+0x2a>
			*dst++ = *src++;
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8d 50 01             	lea    0x1(%eax),%edx
  8013a2:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013ab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013ae:	8a 12                	mov    (%edx),%dl
  8013b0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013b2:	ff 4d 10             	decl   0x10(%ebp)
  8013b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b9:	74 09                	je     8013c4 <strlcpy+0x3c>
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	84 c0                	test   %al,%al
  8013c2:	75 d8                	jne    80139c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8013cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d0:	29 c2                	sub    %eax,%edx
  8013d2:	89 d0                	mov    %edx,%eax
}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013d9:	eb 06                	jmp    8013e1 <strcmp+0xb>
		p++, q++;
  8013db:	ff 45 08             	incl   0x8(%ebp)
  8013de:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	84 c0                	test   %al,%al
  8013e8:	74 0e                	je     8013f8 <strcmp+0x22>
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 10                	mov    (%eax),%dl
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	8a 00                	mov    (%eax),%al
  8013f4:	38 c2                	cmp    %al,%dl
  8013f6:	74 e3                	je     8013db <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	8a 00                	mov    (%eax),%al
  8013fd:	0f b6 d0             	movzbl %al,%edx
  801400:	8b 45 0c             	mov    0xc(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	0f b6 c0             	movzbl %al,%eax
  801408:	29 c2                	sub    %eax,%edx
  80140a:	89 d0                	mov    %edx,%eax
}
  80140c:	5d                   	pop    %ebp
  80140d:	c3                   	ret    

0080140e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801411:	eb 09                	jmp    80141c <strncmp+0xe>
		n--, p++, q++;
  801413:	ff 4d 10             	decl   0x10(%ebp)
  801416:	ff 45 08             	incl   0x8(%ebp)
  801419:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80141c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801420:	74 17                	je     801439 <strncmp+0x2b>
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	84 c0                	test   %al,%al
  801429:	74 0e                	je     801439 <strncmp+0x2b>
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	8a 10                	mov    (%eax),%dl
  801430:	8b 45 0c             	mov    0xc(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	38 c2                	cmp    %al,%dl
  801437:	74 da                	je     801413 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801439:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143d:	75 07                	jne    801446 <strncmp+0x38>
		return 0;
  80143f:	b8 00 00 00 00       	mov    $0x0,%eax
  801444:	eb 14                	jmp    80145a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	8a 00                	mov    (%eax),%al
  80144b:	0f b6 d0             	movzbl %al,%edx
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	0f b6 c0             	movzbl %al,%eax
  801456:	29 c2                	sub    %eax,%edx
  801458:	89 d0                	mov    %edx,%eax
}
  80145a:	5d                   	pop    %ebp
  80145b:	c3                   	ret    

0080145c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 04             	sub    $0x4,%esp
  801462:	8b 45 0c             	mov    0xc(%ebp),%eax
  801465:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801468:	eb 12                	jmp    80147c <strchr+0x20>
		if (*s == c)
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801472:	75 05                	jne    801479 <strchr+0x1d>
			return (char *) s;
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	eb 11                	jmp    80148a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801479:	ff 45 08             	incl   0x8(%ebp)
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	8a 00                	mov    (%eax),%al
  801481:	84 c0                	test   %al,%al
  801483:	75 e5                	jne    80146a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801485:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	8b 45 0c             	mov    0xc(%ebp),%eax
  801495:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801498:	eb 0d                	jmp    8014a7 <strfind+0x1b>
		if (*s == c)
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8a 00                	mov    (%eax),%al
  80149f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014a2:	74 0e                	je     8014b2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014a4:	ff 45 08             	incl   0x8(%ebp)
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	84 c0                	test   %al,%al
  8014ae:	75 ea                	jne    80149a <strfind+0xe>
  8014b0:	eb 01                	jmp    8014b3 <strfind+0x27>
		if (*s == c)
			break;
  8014b2:	90                   	nop
	return (char *) s;
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
  8014bb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014ca:	eb 0e                	jmp    8014da <memset+0x22>
		*p++ = c;
  8014cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cf:	8d 50 01             	lea    0x1(%eax),%edx
  8014d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014da:	ff 4d f8             	decl   -0x8(%ebp)
  8014dd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014e1:	79 e9                	jns    8014cc <memset+0x14>
		*p++ = c;

	return v;
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014fa:	eb 16                	jmp    801512 <memcpy+0x2a>
		*d++ = *s++;
  8014fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ff:	8d 50 01             	lea    0x1(%eax),%edx
  801502:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801505:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801508:	8d 4a 01             	lea    0x1(%edx),%ecx
  80150b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80150e:	8a 12                	mov    (%edx),%dl
  801510:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801512:	8b 45 10             	mov    0x10(%ebp),%eax
  801515:	8d 50 ff             	lea    -0x1(%eax),%edx
  801518:	89 55 10             	mov    %edx,0x10(%ebp)
  80151b:	85 c0                	test   %eax,%eax
  80151d:	75 dd                	jne    8014fc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80152a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801536:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801539:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153c:	73 50                	jae    80158e <memmove+0x6a>
  80153e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801541:	8b 45 10             	mov    0x10(%ebp),%eax
  801544:	01 d0                	add    %edx,%eax
  801546:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801549:	76 43                	jbe    80158e <memmove+0x6a>
		s += n;
  80154b:	8b 45 10             	mov    0x10(%ebp),%eax
  80154e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801551:	8b 45 10             	mov    0x10(%ebp),%eax
  801554:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801557:	eb 10                	jmp    801569 <memmove+0x45>
			*--d = *--s;
  801559:	ff 4d f8             	decl   -0x8(%ebp)
  80155c:	ff 4d fc             	decl   -0x4(%ebp)
  80155f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801562:	8a 10                	mov    (%eax),%dl
  801564:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801567:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801569:	8b 45 10             	mov    0x10(%ebp),%eax
  80156c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80156f:	89 55 10             	mov    %edx,0x10(%ebp)
  801572:	85 c0                	test   %eax,%eax
  801574:	75 e3                	jne    801559 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801576:	eb 23                	jmp    80159b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801578:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157b:	8d 50 01             	lea    0x1(%eax),%edx
  80157e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801581:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801584:	8d 4a 01             	lea    0x1(%edx),%ecx
  801587:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80158a:	8a 12                	mov    (%edx),%dl
  80158c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	8d 50 ff             	lea    -0x1(%eax),%edx
  801594:	89 55 10             	mov    %edx,0x10(%ebp)
  801597:	85 c0                	test   %eax,%eax
  801599:	75 dd                	jne    801578 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80159b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015af:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015b2:	eb 2a                	jmp    8015de <memcmp+0x3e>
		if (*s1 != *s2)
  8015b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b7:	8a 10                	mov    (%eax),%dl
  8015b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	38 c2                	cmp    %al,%dl
  8015c0:	74 16                	je     8015d8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	0f b6 d0             	movzbl %al,%edx
  8015ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015cd:	8a 00                	mov    (%eax),%al
  8015cf:	0f b6 c0             	movzbl %al,%eax
  8015d2:	29 c2                	sub    %eax,%edx
  8015d4:	89 d0                	mov    %edx,%eax
  8015d6:	eb 18                	jmp    8015f0 <memcmp+0x50>
		s1++, s2++;
  8015d8:	ff 45 fc             	incl   -0x4(%ebp)
  8015db:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015de:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	75 c9                	jne    8015b4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fe:	01 d0                	add    %edx,%eax
  801600:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801603:	eb 15                	jmp    80161a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	8a 00                	mov    (%eax),%al
  80160a:	0f b6 d0             	movzbl %al,%edx
  80160d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801610:	0f b6 c0             	movzbl %al,%eax
  801613:	39 c2                	cmp    %eax,%edx
  801615:	74 0d                	je     801624 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801620:	72 e3                	jb     801605 <memfind+0x13>
  801622:	eb 01                	jmp    801625 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801624:	90                   	nop
	return (void *) s;
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801630:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801637:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80163e:	eb 03                	jmp    801643 <strtol+0x19>
		s++;
  801640:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	8a 00                	mov    (%eax),%al
  801648:	3c 20                	cmp    $0x20,%al
  80164a:	74 f4                	je     801640 <strtol+0x16>
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	3c 09                	cmp    $0x9,%al
  801653:	74 eb                	je     801640 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	3c 2b                	cmp    $0x2b,%al
  80165c:	75 05                	jne    801663 <strtol+0x39>
		s++;
  80165e:	ff 45 08             	incl   0x8(%ebp)
  801661:	eb 13                	jmp    801676 <strtol+0x4c>
	else if (*s == '-')
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	8a 00                	mov    (%eax),%al
  801668:	3c 2d                	cmp    $0x2d,%al
  80166a:	75 0a                	jne    801676 <strtol+0x4c>
		s++, neg = 1;
  80166c:	ff 45 08             	incl   0x8(%ebp)
  80166f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801676:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80167a:	74 06                	je     801682 <strtol+0x58>
  80167c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801680:	75 20                	jne    8016a2 <strtol+0x78>
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	8a 00                	mov    (%eax),%al
  801687:	3c 30                	cmp    $0x30,%al
  801689:	75 17                	jne    8016a2 <strtol+0x78>
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	40                   	inc    %eax
  80168f:	8a 00                	mov    (%eax),%al
  801691:	3c 78                	cmp    $0x78,%al
  801693:	75 0d                	jne    8016a2 <strtol+0x78>
		s += 2, base = 16;
  801695:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801699:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016a0:	eb 28                	jmp    8016ca <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a6:	75 15                	jne    8016bd <strtol+0x93>
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	3c 30                	cmp    $0x30,%al
  8016af:	75 0c                	jne    8016bd <strtol+0x93>
		s++, base = 8;
  8016b1:	ff 45 08             	incl   0x8(%ebp)
  8016b4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016bb:	eb 0d                	jmp    8016ca <strtol+0xa0>
	else if (base == 0)
  8016bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c1:	75 07                	jne    8016ca <strtol+0xa0>
		base = 10;
  8016c3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	8a 00                	mov    (%eax),%al
  8016cf:	3c 2f                	cmp    $0x2f,%al
  8016d1:	7e 19                	jle    8016ec <strtol+0xc2>
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	3c 39                	cmp    $0x39,%al
  8016da:	7f 10                	jg     8016ec <strtol+0xc2>
			dig = *s - '0';
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	8a 00                	mov    (%eax),%al
  8016e1:	0f be c0             	movsbl %al,%eax
  8016e4:	83 e8 30             	sub    $0x30,%eax
  8016e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ea:	eb 42                	jmp    80172e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ef:	8a 00                	mov    (%eax),%al
  8016f1:	3c 60                	cmp    $0x60,%al
  8016f3:	7e 19                	jle    80170e <strtol+0xe4>
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	8a 00                	mov    (%eax),%al
  8016fa:	3c 7a                	cmp    $0x7a,%al
  8016fc:	7f 10                	jg     80170e <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	8a 00                	mov    (%eax),%al
  801703:	0f be c0             	movsbl %al,%eax
  801706:	83 e8 57             	sub    $0x57,%eax
  801709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80170c:	eb 20                	jmp    80172e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	3c 40                	cmp    $0x40,%al
  801715:	7e 39                	jle    801750 <strtol+0x126>
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	3c 5a                	cmp    $0x5a,%al
  80171e:	7f 30                	jg     801750 <strtol+0x126>
			dig = *s - 'A' + 10;
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	8a 00                	mov    (%eax),%al
  801725:	0f be c0             	movsbl %al,%eax
  801728:	83 e8 37             	sub    $0x37,%eax
  80172b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80172e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801731:	3b 45 10             	cmp    0x10(%ebp),%eax
  801734:	7d 19                	jge    80174f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801736:	ff 45 08             	incl   0x8(%ebp)
  801739:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801740:	89 c2                	mov    %eax,%edx
  801742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801745:	01 d0                	add    %edx,%eax
  801747:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80174a:	e9 7b ff ff ff       	jmp    8016ca <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80174f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801750:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801754:	74 08                	je     80175e <strtol+0x134>
		*endptr = (char *) s;
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	8b 55 08             	mov    0x8(%ebp),%edx
  80175c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80175e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801762:	74 07                	je     80176b <strtol+0x141>
  801764:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801767:	f7 d8                	neg    %eax
  801769:	eb 03                	jmp    80176e <strtol+0x144>
  80176b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <ltostr>:

void
ltostr(long value, char *str)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801776:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80177d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801784:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801788:	79 13                	jns    80179d <ltostr+0x2d>
	{
		neg = 1;
  80178a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801791:	8b 45 0c             	mov    0xc(%ebp),%eax
  801794:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801797:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80179a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017a5:	99                   	cltd   
  8017a6:	f7 f9                	idiv   %ecx
  8017a8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ae:	8d 50 01             	lea    0x1(%eax),%edx
  8017b1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b4:	89 c2                	mov    %eax,%edx
  8017b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b9:	01 d0                	add    %edx,%eax
  8017bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017be:	83 c2 30             	add    $0x30,%edx
  8017c1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017cb:	f7 e9                	imul   %ecx
  8017cd:	c1 fa 02             	sar    $0x2,%edx
  8017d0:	89 c8                	mov    %ecx,%eax
  8017d2:	c1 f8 1f             	sar    $0x1f,%eax
  8017d5:	29 c2                	sub    %eax,%edx
  8017d7:	89 d0                	mov    %edx,%eax
  8017d9:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017df:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017e4:	f7 e9                	imul   %ecx
  8017e6:	c1 fa 02             	sar    $0x2,%edx
  8017e9:	89 c8                	mov    %ecx,%eax
  8017eb:	c1 f8 1f             	sar    $0x1f,%eax
  8017ee:	29 c2                	sub    %eax,%edx
  8017f0:	89 d0                	mov    %edx,%eax
  8017f2:	c1 e0 02             	shl    $0x2,%eax
  8017f5:	01 d0                	add    %edx,%eax
  8017f7:	01 c0                	add    %eax,%eax
  8017f9:	29 c1                	sub    %eax,%ecx
  8017fb:	89 ca                	mov    %ecx,%edx
  8017fd:	85 d2                	test   %edx,%edx
  8017ff:	75 9c                	jne    80179d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801801:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801808:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180b:	48                   	dec    %eax
  80180c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80180f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801813:	74 3d                	je     801852 <ltostr+0xe2>
		start = 1 ;
  801815:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80181c:	eb 34                	jmp    801852 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80181e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801821:	8b 45 0c             	mov    0xc(%ebp),%eax
  801824:	01 d0                	add    %edx,%eax
  801826:	8a 00                	mov    (%eax),%al
  801828:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80182b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80182e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801831:	01 c2                	add    %eax,%edx
  801833:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801836:	8b 45 0c             	mov    0xc(%ebp),%eax
  801839:	01 c8                	add    %ecx,%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80183f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801842:	8b 45 0c             	mov    0xc(%ebp),%eax
  801845:	01 c2                	add    %eax,%edx
  801847:	8a 45 eb             	mov    -0x15(%ebp),%al
  80184a:	88 02                	mov    %al,(%edx)
		start++ ;
  80184c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80184f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801855:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801858:	7c c4                	jl     80181e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80185a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80185d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801860:	01 d0                	add    %edx,%eax
  801862:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801865:	90                   	nop
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80186e:	ff 75 08             	pushl  0x8(%ebp)
  801871:	e8 54 fa ff ff       	call   8012ca <strlen>
  801876:	83 c4 04             	add    $0x4,%esp
  801879:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80187c:	ff 75 0c             	pushl  0xc(%ebp)
  80187f:	e8 46 fa ff ff       	call   8012ca <strlen>
  801884:	83 c4 04             	add    $0x4,%esp
  801887:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80188a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801891:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801898:	eb 17                	jmp    8018b1 <strcconcat+0x49>
		final[s] = str1[s] ;
  80189a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189d:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a0:	01 c2                	add    %eax,%edx
  8018a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	01 c8                	add    %ecx,%eax
  8018aa:	8a 00                	mov    (%eax),%al
  8018ac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018ae:	ff 45 fc             	incl   -0x4(%ebp)
  8018b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018b7:	7c e1                	jl     80189a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018c7:	eb 1f                	jmp    8018e8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cc:	8d 50 01             	lea    0x1(%eax),%edx
  8018cf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018d2:	89 c2                	mov    %eax,%edx
  8018d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d7:	01 c2                	add    %eax,%edx
  8018d9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018df:	01 c8                	add    %ecx,%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018e5:	ff 45 f8             	incl   -0x8(%ebp)
  8018e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018ee:	7c d9                	jl     8018c9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f6:	01 d0                	add    %edx,%eax
  8018f8:	c6 00 00             	movb   $0x0,(%eax)
}
  8018fb:	90                   	nop
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801901:	8b 45 14             	mov    0x14(%ebp),%eax
  801904:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80190a:	8b 45 14             	mov    0x14(%ebp),%eax
  80190d:	8b 00                	mov    (%eax),%eax
  80190f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801916:	8b 45 10             	mov    0x10(%ebp),%eax
  801919:	01 d0                	add    %edx,%eax
  80191b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801921:	eb 0c                	jmp    80192f <strsplit+0x31>
			*string++ = 0;
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	8d 50 01             	lea    0x1(%eax),%edx
  801929:	89 55 08             	mov    %edx,0x8(%ebp)
  80192c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	8a 00                	mov    (%eax),%al
  801934:	84 c0                	test   %al,%al
  801936:	74 18                	je     801950 <strsplit+0x52>
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	8a 00                	mov    (%eax),%al
  80193d:	0f be c0             	movsbl %al,%eax
  801940:	50                   	push   %eax
  801941:	ff 75 0c             	pushl  0xc(%ebp)
  801944:	e8 13 fb ff ff       	call   80145c <strchr>
  801949:	83 c4 08             	add    $0x8,%esp
  80194c:	85 c0                	test   %eax,%eax
  80194e:	75 d3                	jne    801923 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	8a 00                	mov    (%eax),%al
  801955:	84 c0                	test   %al,%al
  801957:	74 5a                	je     8019b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801959:	8b 45 14             	mov    0x14(%ebp),%eax
  80195c:	8b 00                	mov    (%eax),%eax
  80195e:	83 f8 0f             	cmp    $0xf,%eax
  801961:	75 07                	jne    80196a <strsplit+0x6c>
		{
			return 0;
  801963:	b8 00 00 00 00       	mov    $0x0,%eax
  801968:	eb 66                	jmp    8019d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80196a:	8b 45 14             	mov    0x14(%ebp),%eax
  80196d:	8b 00                	mov    (%eax),%eax
  80196f:	8d 48 01             	lea    0x1(%eax),%ecx
  801972:	8b 55 14             	mov    0x14(%ebp),%edx
  801975:	89 0a                	mov    %ecx,(%edx)
  801977:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80197e:	8b 45 10             	mov    0x10(%ebp),%eax
  801981:	01 c2                	add    %eax,%edx
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801988:	eb 03                	jmp    80198d <strsplit+0x8f>
			string++;
  80198a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	8a 00                	mov    (%eax),%al
  801992:	84 c0                	test   %al,%al
  801994:	74 8b                	je     801921 <strsplit+0x23>
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	8a 00                	mov    (%eax),%al
  80199b:	0f be c0             	movsbl %al,%eax
  80199e:	50                   	push   %eax
  80199f:	ff 75 0c             	pushl  0xc(%ebp)
  8019a2:	e8 b5 fa ff ff       	call   80145c <strchr>
  8019a7:	83 c4 08             	add    $0x8,%esp
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	74 dc                	je     80198a <strsplit+0x8c>
			string++;
	}
  8019ae:	e9 6e ff ff ff       	jmp    801921 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b7:	8b 00                	mov    (%eax),%eax
  8019b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c3:	01 d0                	add    %edx,%eax
  8019c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8019d8:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8019df:	8b 55 08             	mov    0x8(%ebp),%edx
  8019e2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8019e5:	01 d0                	add    %edx,%eax
  8019e7:	48                   	dec    %eax
  8019e8:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8019eb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8019ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f3:	f7 75 ac             	divl   -0x54(%ebp)
  8019f6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8019f9:	29 d0                	sub    %edx,%eax
  8019fb:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8019fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801a05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801a0c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801a13:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a1a:	eb 3f                	jmp    801a5b <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801a1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a1f:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801a26:	83 ec 04             	sub    $0x4,%esp
  801a29:	50                   	push   %eax
  801a2a:	ff 75 e8             	pushl  -0x18(%ebp)
  801a2d:	68 10 34 80 00       	push   $0x803410
  801a32:	e8 11 f2 ff ff       	call   800c48 <cprintf>
  801a37:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801a3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a3d:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801a44:	83 ec 04             	sub    $0x4,%esp
  801a47:	50                   	push   %eax
  801a48:	ff 75 e8             	pushl  -0x18(%ebp)
  801a4b:	68 25 34 80 00       	push   $0x803425
  801a50:	e8 f3 f1 ff ff       	call   800c48 <cprintf>
  801a55:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801a58:	ff 45 e8             	incl   -0x18(%ebp)
  801a5b:	a1 28 40 80 00       	mov    0x804028,%eax
  801a60:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801a63:	7c b7                	jl     801a1c <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801a65:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801a6c:	e9 42 01 00 00       	jmp    801bb3 <malloc+0x1e1>
		int flag0=1;
  801a71:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801a78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a7e:	eb 6b                	jmp    801aeb <malloc+0x119>
			for(int k=0;k<count;k++){
  801a80:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801a87:	eb 42                	jmp    801acb <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a8c:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801a93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a96:	39 c2                	cmp    %eax,%edx
  801a98:	77 2e                	ja     801ac8 <malloc+0xf6>
  801a9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a9d:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801aa4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aa7:	39 c2                	cmp    %eax,%edx
  801aa9:	76 1d                	jbe    801ac8 <malloc+0xf6>
					ni=arr_add[k].end-i;
  801aab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801aae:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801ab5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ab8:	29 c2                	sub    %eax,%edx
  801aba:	89 d0                	mov    %edx,%eax
  801abc:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801abf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801ac6:	eb 0d                	jmp    801ad5 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801ac8:	ff 45 d8             	incl   -0x28(%ebp)
  801acb:	a1 28 40 80 00       	mov    0x804028,%eax
  801ad0:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801ad3:	7c b4                	jl     801a89 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801ad5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ad9:	74 09                	je     801ae4 <malloc+0x112>
				flag0=0;
  801adb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801ae2:	eb 16                	jmp    801afa <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801ae4:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801aeb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	01 c2                	add    %eax,%edx
  801af3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801af6:	39 c2                	cmp    %eax,%edx
  801af8:	77 86                	ja     801a80 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801afa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801afe:	0f 84 a2 00 00 00    	je     801ba6 <malloc+0x1d4>

			int f=1;
  801b04:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801b0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b0e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801b11:	89 c8                	mov    %ecx,%eax
  801b13:	01 c0                	add    %eax,%eax
  801b15:	01 c8                	add    %ecx,%eax
  801b17:	c1 e0 02             	shl    $0x2,%eax
  801b1a:	05 20 41 80 00       	add    $0x804120,%eax
  801b1f:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801b21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801b2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2d:	89 d0                	mov    %edx,%eax
  801b2f:	01 c0                	add    %eax,%eax
  801b31:	01 d0                	add    %edx,%eax
  801b33:	c1 e0 02             	shl    $0x2,%eax
  801b36:	05 24 41 80 00       	add    $0x804124,%eax
  801b3b:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801b3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b40:	89 d0                	mov    %edx,%eax
  801b42:	01 c0                	add    %eax,%eax
  801b44:	01 d0                	add    %edx,%eax
  801b46:	c1 e0 02             	shl    $0x2,%eax
  801b49:	05 28 41 80 00       	add    $0x804128,%eax
  801b4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801b54:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801b57:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801b5e:	eb 36                	jmp    801b96 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801b60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	01 c2                	add    %eax,%edx
  801b68:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b6b:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801b72:	39 c2                	cmp    %eax,%edx
  801b74:	73 1d                	jae    801b93 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801b76:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b79:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801b80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b83:	29 c2                	sub    %eax,%edx
  801b85:	89 d0                	mov    %edx,%eax
  801b87:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801b8a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801b91:	eb 0d                	jmp    801ba0 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801b93:	ff 45 d0             	incl   -0x30(%ebp)
  801b96:	a1 28 40 80 00       	mov    0x804028,%eax
  801b9b:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801b9e:	7c c0                	jl     801b60 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801ba0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801ba4:	75 1d                	jne    801bc3 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801ba6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801bad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb0:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801bb3:	a1 04 40 80 00       	mov    0x804004,%eax
  801bb8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bbb:	0f 8c b0 fe ff ff    	jl     801a71 <malloc+0x9f>
  801bc1:	eb 01                	jmp    801bc4 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801bc3:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bc8:	75 7a                	jne    801c44 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801bca:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	01 d0                	add    %edx,%eax
  801bd5:	48                   	dec    %eax
  801bd6:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801bdb:	7c 0a                	jl     801be7 <malloc+0x215>
			return NULL;
  801bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801be2:	e9 a4 02 00 00       	jmp    801e8b <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801be7:	a1 04 40 80 00       	mov    0x804004,%eax
  801bec:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801bef:	a1 28 40 80 00       	mov    0x804028,%eax
  801bf4:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801bf7:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801bfe:	83 ec 08             	sub    $0x8,%esp
  801c01:	ff 75 08             	pushl  0x8(%ebp)
  801c04:	ff 75 a4             	pushl  -0x5c(%ebp)
  801c07:	e8 04 06 00 00       	call   802210 <sys_allocateMem>
  801c0c:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801c0f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	01 d0                	add    %edx,%eax
  801c1a:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801c1f:	a1 28 40 80 00       	mov    0x804028,%eax
  801c24:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c2a:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801c31:	a1 28 40 80 00       	mov    0x804028,%eax
  801c36:	40                   	inc    %eax
  801c37:	a3 28 40 80 00       	mov    %eax,0x804028

			return (void*)s;
  801c3c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801c3f:	e9 47 02 00 00       	jmp    801e8b <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801c44:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801c4b:	e9 ac 00 00 00       	jmp    801cfc <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801c50:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801c53:	89 d0                	mov    %edx,%eax
  801c55:	01 c0                	add    %eax,%eax
  801c57:	01 d0                	add    %edx,%eax
  801c59:	c1 e0 02             	shl    $0x2,%eax
  801c5c:	05 24 41 80 00       	add    $0x804124,%eax
  801c61:	8b 00                	mov    (%eax),%eax
  801c63:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801c66:	eb 7e                	jmp    801ce6 <malloc+0x314>
			int flag=0;
  801c68:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801c6f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801c76:	eb 57                	jmp    801ccf <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801c78:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c7b:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801c82:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c85:	39 c2                	cmp    %eax,%edx
  801c87:	77 1a                	ja     801ca3 <malloc+0x2d1>
  801c89:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c8c:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801c93:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c96:	39 c2                	cmp    %eax,%edx
  801c98:	76 09                	jbe    801ca3 <malloc+0x2d1>
								flag=1;
  801c9a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801ca1:	eb 36                	jmp    801cd9 <malloc+0x307>
			arr[i].space++;
  801ca3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801ca6:	89 d0                	mov    %edx,%eax
  801ca8:	01 c0                	add    %eax,%eax
  801caa:	01 d0                	add    %edx,%eax
  801cac:	c1 e0 02             	shl    $0x2,%eax
  801caf:	05 28 41 80 00       	add    $0x804128,%eax
  801cb4:	8b 00                	mov    (%eax),%eax
  801cb6:	8d 48 01             	lea    0x1(%eax),%ecx
  801cb9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801cbc:	89 d0                	mov    %edx,%eax
  801cbe:	01 c0                	add    %eax,%eax
  801cc0:	01 d0                	add    %edx,%eax
  801cc2:	c1 e0 02             	shl    $0x2,%eax
  801cc5:	05 28 41 80 00       	add    $0x804128,%eax
  801cca:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801ccc:	ff 45 c0             	incl   -0x40(%ebp)
  801ccf:	a1 28 40 80 00       	mov    0x804028,%eax
  801cd4:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801cd7:	7c 9f                	jl     801c78 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801cd9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801cdd:	75 19                	jne    801cf8 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801cdf:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801ce6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801ce9:	a1 04 40 80 00       	mov    0x804004,%eax
  801cee:	39 c2                	cmp    %eax,%edx
  801cf0:	0f 82 72 ff ff ff    	jb     801c68 <malloc+0x296>
  801cf6:	eb 01                	jmp    801cf9 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801cf8:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801cf9:	ff 45 cc             	incl   -0x34(%ebp)
  801cfc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801cff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d02:	0f 8c 48 ff ff ff    	jl     801c50 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801d08:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801d0f:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801d16:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801d1d:	eb 37                	jmp    801d56 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801d1f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801d22:	89 d0                	mov    %edx,%eax
  801d24:	01 c0                	add    %eax,%eax
  801d26:	01 d0                	add    %edx,%eax
  801d28:	c1 e0 02             	shl    $0x2,%eax
  801d2b:	05 28 41 80 00       	add    $0x804128,%eax
  801d30:	8b 00                	mov    (%eax),%eax
  801d32:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801d35:	7d 1c                	jge    801d53 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801d37:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801d3a:	89 d0                	mov    %edx,%eax
  801d3c:	01 c0                	add    %eax,%eax
  801d3e:	01 d0                	add    %edx,%eax
  801d40:	c1 e0 02             	shl    $0x2,%eax
  801d43:	05 28 41 80 00       	add    $0x804128,%eax
  801d48:	8b 00                	mov    (%eax),%eax
  801d4a:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801d4d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801d50:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801d53:	ff 45 b4             	incl   -0x4c(%ebp)
  801d56:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801d59:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d5c:	7c c1                	jl     801d1f <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801d5e:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801d64:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801d67:	89 c8                	mov    %ecx,%eax
  801d69:	01 c0                	add    %eax,%eax
  801d6b:	01 c8                	add    %ecx,%eax
  801d6d:	c1 e0 02             	shl    $0x2,%eax
  801d70:	05 20 41 80 00       	add    $0x804120,%eax
  801d75:	8b 00                	mov    (%eax),%eax
  801d77:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801d7e:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801d84:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801d87:	89 c8                	mov    %ecx,%eax
  801d89:	01 c0                	add    %eax,%eax
  801d8b:	01 c8                	add    %ecx,%eax
  801d8d:	c1 e0 02             	shl    $0x2,%eax
  801d90:	05 24 41 80 00       	add    $0x804124,%eax
  801d95:	8b 00                	mov    (%eax),%eax
  801d97:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  801d9e:	a1 28 40 80 00       	mov    0x804028,%eax
  801da3:	40                   	inc    %eax
  801da4:	a3 28 40 80 00       	mov    %eax,0x804028


		sys_allocateMem(arr[index].start,size);
  801da9:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801dac:	89 d0                	mov    %edx,%eax
  801dae:	01 c0                	add    %eax,%eax
  801db0:	01 d0                	add    %edx,%eax
  801db2:	c1 e0 02             	shl    $0x2,%eax
  801db5:	05 20 41 80 00       	add    $0x804120,%eax
  801dba:	8b 00                	mov    (%eax),%eax
  801dbc:	83 ec 08             	sub    $0x8,%esp
  801dbf:	ff 75 08             	pushl  0x8(%ebp)
  801dc2:	50                   	push   %eax
  801dc3:	e8 48 04 00 00       	call   802210 <sys_allocateMem>
  801dc8:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801dcb:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801dd2:	eb 78                	jmp    801e4c <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801dd4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801dd7:	89 d0                	mov    %edx,%eax
  801dd9:	01 c0                	add    %eax,%eax
  801ddb:	01 d0                	add    %edx,%eax
  801ddd:	c1 e0 02             	shl    $0x2,%eax
  801de0:	05 20 41 80 00       	add    $0x804120,%eax
  801de5:	8b 00                	mov    (%eax),%eax
  801de7:	83 ec 04             	sub    $0x4,%esp
  801dea:	50                   	push   %eax
  801deb:	ff 75 b0             	pushl  -0x50(%ebp)
  801dee:	68 10 34 80 00       	push   $0x803410
  801df3:	e8 50 ee ff ff       	call   800c48 <cprintf>
  801df8:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801dfb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801dfe:	89 d0                	mov    %edx,%eax
  801e00:	01 c0                	add    %eax,%eax
  801e02:	01 d0                	add    %edx,%eax
  801e04:	c1 e0 02             	shl    $0x2,%eax
  801e07:	05 24 41 80 00       	add    $0x804124,%eax
  801e0c:	8b 00                	mov    (%eax),%eax
  801e0e:	83 ec 04             	sub    $0x4,%esp
  801e11:	50                   	push   %eax
  801e12:	ff 75 b0             	pushl  -0x50(%ebp)
  801e15:	68 25 34 80 00       	push   $0x803425
  801e1a:	e8 29 ee ff ff       	call   800c48 <cprintf>
  801e1f:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801e22:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e25:	89 d0                	mov    %edx,%eax
  801e27:	01 c0                	add    %eax,%eax
  801e29:	01 d0                	add    %edx,%eax
  801e2b:	c1 e0 02             	shl    $0x2,%eax
  801e2e:	05 28 41 80 00       	add    $0x804128,%eax
  801e33:	8b 00                	mov    (%eax),%eax
  801e35:	83 ec 04             	sub    $0x4,%esp
  801e38:	50                   	push   %eax
  801e39:	ff 75 b0             	pushl  -0x50(%ebp)
  801e3c:	68 38 34 80 00       	push   $0x803438
  801e41:	e8 02 ee ff ff       	call   800c48 <cprintf>
  801e46:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801e49:	ff 45 b0             	incl   -0x50(%ebp)
  801e4c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801e4f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e52:	7c 80                	jl     801dd4 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801e54:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e57:	89 d0                	mov    %edx,%eax
  801e59:	01 c0                	add    %eax,%eax
  801e5b:	01 d0                	add    %edx,%eax
  801e5d:	c1 e0 02             	shl    $0x2,%eax
  801e60:	05 20 41 80 00       	add    $0x804120,%eax
  801e65:	8b 00                	mov    (%eax),%eax
  801e67:	83 ec 08             	sub    $0x8,%esp
  801e6a:	50                   	push   %eax
  801e6b:	68 4c 34 80 00       	push   $0x80344c
  801e70:	e8 d3 ed ff ff       	call   800c48 <cprintf>
  801e75:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801e78:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e7b:	89 d0                	mov    %edx,%eax
  801e7d:	01 c0                	add    %eax,%eax
  801e7f:	01 d0                	add    %edx,%eax
  801e81:	c1 e0 02             	shl    $0x2,%eax
  801e84:	05 20 41 80 00       	add    $0x804120,%eax
  801e89:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801e99:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801ea0:	eb 4b                	jmp    801eed <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea5:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801eac:	89 c2                	mov    %eax,%edx
  801eae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eb1:	39 c2                	cmp    %eax,%edx
  801eb3:	7f 35                	jg     801eea <free+0x5d>
  801eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb8:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801ebf:	89 c2                	mov    %eax,%edx
  801ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ec4:	39 c2                	cmp    %eax,%edx
  801ec6:	7e 22                	jle    801eea <free+0x5d>
				start=arr_add[i].start;
  801ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ecb:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801ed2:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801ed5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed8:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801edf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801ee2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801ee8:	eb 0d                	jmp    801ef7 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801eea:	ff 45 ec             	incl   -0x14(%ebp)
  801eed:	a1 28 40 80 00       	mov    0x804028,%eax
  801ef2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801ef5:	7c ab                	jl     801ea2 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efa:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f04:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801f0b:	29 c2                	sub    %eax,%edx
  801f0d:	89 d0                	mov    %edx,%eax
  801f0f:	83 ec 08             	sub    $0x8,%esp
  801f12:	50                   	push   %eax
  801f13:	ff 75 f4             	pushl  -0xc(%ebp)
  801f16:	e8 d9 02 00 00       	call   8021f4 <sys_freeMem>
  801f1b:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f21:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f24:	eb 2d                	jmp    801f53 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801f26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f29:	40                   	inc    %eax
  801f2a:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801f31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f34:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f3e:	40                   	inc    %eax
  801f3f:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801f46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f49:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801f50:	ff 45 e8             	incl   -0x18(%ebp)
  801f53:	a1 28 40 80 00       	mov    0x804028,%eax
  801f58:	48                   	dec    %eax
  801f59:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f5c:	7f c8                	jg     801f26 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801f5e:	a1 28 40 80 00       	mov    0x804028,%eax
  801f63:	48                   	dec    %eax
  801f64:	a3 28 40 80 00       	mov    %eax,0x804028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801f69:	90                   	nop
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	83 ec 18             	sub    $0x18,%esp
  801f72:	8b 45 10             	mov    0x10(%ebp),%eax
  801f75:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801f78:	83 ec 04             	sub    $0x4,%esp
  801f7b:	68 68 34 80 00       	push   $0x803468
  801f80:	68 18 01 00 00       	push   $0x118
  801f85:	68 8b 34 80 00       	push   $0x80348b
  801f8a:	e8 17 ea ff ff       	call   8009a6 <_panic>

00801f8f <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f95:	83 ec 04             	sub    $0x4,%esp
  801f98:	68 68 34 80 00       	push   $0x803468
  801f9d:	68 1e 01 00 00       	push   $0x11e
  801fa2:	68 8b 34 80 00       	push   $0x80348b
  801fa7:	e8 fa e9 ff ff       	call   8009a6 <_panic>

00801fac <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fb2:	83 ec 04             	sub    $0x4,%esp
  801fb5:	68 68 34 80 00       	push   $0x803468
  801fba:	68 24 01 00 00       	push   $0x124
  801fbf:	68 8b 34 80 00       	push   $0x80348b
  801fc4:	e8 dd e9 ff ff       	call   8009a6 <_panic>

00801fc9 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fcf:	83 ec 04             	sub    $0x4,%esp
  801fd2:	68 68 34 80 00       	push   $0x803468
  801fd7:	68 29 01 00 00       	push   $0x129
  801fdc:	68 8b 34 80 00       	push   $0x80348b
  801fe1:	e8 c0 e9 ff ff       	call   8009a6 <_panic>

00801fe6 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fec:	83 ec 04             	sub    $0x4,%esp
  801fef:	68 68 34 80 00       	push   $0x803468
  801ff4:	68 2f 01 00 00       	push   $0x12f
  801ff9:	68 8b 34 80 00       	push   $0x80348b
  801ffe:	e8 a3 e9 ff ff       	call   8009a6 <_panic>

00802003 <shrink>:
}
void shrink(uint32 newSize)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802009:	83 ec 04             	sub    $0x4,%esp
  80200c:	68 68 34 80 00       	push   $0x803468
  802011:	68 33 01 00 00       	push   $0x133
  802016:	68 8b 34 80 00       	push   $0x80348b
  80201b:	e8 86 e9 ff ff       	call   8009a6 <_panic>

00802020 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	68 68 34 80 00       	push   $0x803468
  80202e:	68 38 01 00 00       	push   $0x138
  802033:	68 8b 34 80 00       	push   $0x80348b
  802038:	e8 69 e9 ff ff       	call   8009a6 <_panic>

0080203d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	57                   	push   %edi
  802041:	56                   	push   %esi
  802042:	53                   	push   %ebx
  802043:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80204f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802052:	8b 7d 18             	mov    0x18(%ebp),%edi
  802055:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802058:	cd 30                	int    $0x30
  80205a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80205d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802060:	83 c4 10             	add    $0x10,%esp
  802063:	5b                   	pop    %ebx
  802064:	5e                   	pop    %esi
  802065:	5f                   	pop    %edi
  802066:	5d                   	pop    %ebp
  802067:	c3                   	ret    

00802068 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	83 ec 04             	sub    $0x4,%esp
  80206e:	8b 45 10             	mov    0x10(%ebp),%eax
  802071:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802074:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	52                   	push   %edx
  802080:	ff 75 0c             	pushl  0xc(%ebp)
  802083:	50                   	push   %eax
  802084:	6a 00                	push   $0x0
  802086:	e8 b2 ff ff ff       	call   80203d <syscall>
  80208b:	83 c4 18             	add    $0x18,%esp
}
  80208e:	90                   	nop
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <sys_cgetc>:

int
sys_cgetc(void)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 01                	push   $0x1
  8020a0:	e8 98 ff ff ff       	call   80203d <syscall>
  8020a5:	83 c4 18             	add    $0x18,%esp
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	50                   	push   %eax
  8020b9:	6a 05                	push   $0x5
  8020bb:	e8 7d ff ff ff       	call   80203d <syscall>
  8020c0:	83 c4 18             	add    $0x18,%esp
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 02                	push   $0x2
  8020d4:	e8 64 ff ff ff       	call   80203d <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
}
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 03                	push   $0x3
  8020ed:	e8 4b ff ff ff       	call   80203d <syscall>
  8020f2:	83 c4 18             	add    $0x18,%esp
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 04                	push   $0x4
  802106:	e8 32 ff ff ff       	call   80203d <syscall>
  80210b:	83 c4 18             	add    $0x18,%esp
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <sys_env_exit>:


void sys_env_exit(void)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 06                	push   $0x6
  80211f:	e8 19 ff ff ff       	call   80203d <syscall>
  802124:	83 c4 18             	add    $0x18,%esp
}
  802127:	90                   	nop
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80212d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	52                   	push   %edx
  80213a:	50                   	push   %eax
  80213b:	6a 07                	push   $0x7
  80213d:	e8 fb fe ff ff       	call   80203d <syscall>
  802142:	83 c4 18             	add    $0x18,%esp
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	56                   	push   %esi
  80214b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80214c:	8b 75 18             	mov    0x18(%ebp),%esi
  80214f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802152:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802155:	8b 55 0c             	mov    0xc(%ebp),%edx
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	56                   	push   %esi
  80215c:	53                   	push   %ebx
  80215d:	51                   	push   %ecx
  80215e:	52                   	push   %edx
  80215f:	50                   	push   %eax
  802160:	6a 08                	push   $0x8
  802162:	e8 d6 fe ff ff       	call   80203d <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
}
  80216a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80216d:	5b                   	pop    %ebx
  80216e:	5e                   	pop    %esi
  80216f:	5d                   	pop    %ebp
  802170:	c3                   	ret    

00802171 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802174:	8b 55 0c             	mov    0xc(%ebp),%edx
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	52                   	push   %edx
  802181:	50                   	push   %eax
  802182:	6a 09                	push   $0x9
  802184:	e8 b4 fe ff ff       	call   80203d <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	ff 75 0c             	pushl  0xc(%ebp)
  80219a:	ff 75 08             	pushl  0x8(%ebp)
  80219d:	6a 0a                	push   $0xa
  80219f:	e8 99 fe ff ff       	call   80203d <syscall>
  8021a4:	83 c4 18             	add    $0x18,%esp
}
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 0b                	push   $0xb
  8021b8:	e8 80 fe ff ff       	call   80203d <syscall>
  8021bd:	83 c4 18             	add    $0x18,%esp
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 0c                	push   $0xc
  8021d1:	e8 67 fe ff ff       	call   80203d <syscall>
  8021d6:	83 c4 18             	add    $0x18,%esp
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 0d                	push   $0xd
  8021ea:	e8 4e fe ff ff       	call   80203d <syscall>
  8021ef:	83 c4 18             	add    $0x18,%esp
}
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	ff 75 0c             	pushl  0xc(%ebp)
  802200:	ff 75 08             	pushl  0x8(%ebp)
  802203:	6a 11                	push   $0x11
  802205:	e8 33 fe ff ff       	call   80203d <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
	return;
  80220d:	90                   	nop
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	ff 75 0c             	pushl  0xc(%ebp)
  80221c:	ff 75 08             	pushl  0x8(%ebp)
  80221f:	6a 12                	push   $0x12
  802221:	e8 17 fe ff ff       	call   80203d <syscall>
  802226:	83 c4 18             	add    $0x18,%esp
	return ;
  802229:	90                   	nop
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 0e                	push   $0xe
  80223b:	e8 fd fd ff ff       	call   80203d <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	ff 75 08             	pushl  0x8(%ebp)
  802253:	6a 0f                	push   $0xf
  802255:	e8 e3 fd ff ff       	call   80203d <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 10                	push   $0x10
  80226e:	e8 ca fd ff ff       	call   80203d <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
}
  802276:	90                   	nop
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 14                	push   $0x14
  802288:	e8 b0 fd ff ff       	call   80203d <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
}
  802290:	90                   	nop
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 15                	push   $0x15
  8022a2:	e8 96 fd ff ff       	call   80203d <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
}
  8022aa:	90                   	nop
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_cputc>:


void
sys_cputc(const char c)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	83 ec 04             	sub    $0x4,%esp
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022b9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	50                   	push   %eax
  8022c6:	6a 16                	push   $0x16
  8022c8:	e8 70 fd ff ff       	call   80203d <syscall>
  8022cd:	83 c4 18             	add    $0x18,%esp
}
  8022d0:	90                   	nop
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    

008022d3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 17                	push   $0x17
  8022e2:	e8 56 fd ff ff       	call   80203d <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
}
  8022ea:	90                   	nop
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	ff 75 0c             	pushl  0xc(%ebp)
  8022fc:	50                   	push   %eax
  8022fd:	6a 18                	push   $0x18
  8022ff:	e8 39 fd ff ff       	call   80203d <syscall>
  802304:	83 c4 18             	add    $0x18,%esp
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80230c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	52                   	push   %edx
  802319:	50                   	push   %eax
  80231a:	6a 1b                	push   $0x1b
  80231c:	e8 1c fd ff ff       	call   80203d <syscall>
  802321:	83 c4 18             	add    $0x18,%esp
}
  802324:	c9                   	leave  
  802325:	c3                   	ret    

00802326 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802329:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	52                   	push   %edx
  802336:	50                   	push   %eax
  802337:	6a 19                	push   $0x19
  802339:	e8 ff fc ff ff       	call   80203d <syscall>
  80233e:	83 c4 18             	add    $0x18,%esp
}
  802341:	90                   	nop
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802347:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	52                   	push   %edx
  802354:	50                   	push   %eax
  802355:	6a 1a                	push   $0x1a
  802357:	e8 e1 fc ff ff       	call   80203d <syscall>
  80235c:	83 c4 18             	add    $0x18,%esp
}
  80235f:	90                   	nop
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	83 ec 04             	sub    $0x4,%esp
  802368:	8b 45 10             	mov    0x10(%ebp),%eax
  80236b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80236e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802371:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	6a 00                	push   $0x0
  80237a:	51                   	push   %ecx
  80237b:	52                   	push   %edx
  80237c:	ff 75 0c             	pushl  0xc(%ebp)
  80237f:	50                   	push   %eax
  802380:	6a 1c                	push   $0x1c
  802382:	e8 b6 fc ff ff       	call   80203d <syscall>
  802387:	83 c4 18             	add    $0x18,%esp
}
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80238f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	52                   	push   %edx
  80239c:	50                   	push   %eax
  80239d:	6a 1d                	push   $0x1d
  80239f:	e8 99 fc ff ff       	call   80203d <syscall>
  8023a4:	83 c4 18             	add    $0x18,%esp
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	51                   	push   %ecx
  8023ba:	52                   	push   %edx
  8023bb:	50                   	push   %eax
  8023bc:	6a 1e                	push   $0x1e
  8023be:	e8 7a fc ff ff       	call   80203d <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	52                   	push   %edx
  8023d8:	50                   	push   %eax
  8023d9:	6a 1f                	push   $0x1f
  8023db:	e8 5d fc ff ff       	call   80203d <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 20                	push   $0x20
  8023f4:	e8 44 fc ff ff       	call   80203d <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	6a 00                	push   $0x0
  802406:	ff 75 14             	pushl  0x14(%ebp)
  802409:	ff 75 10             	pushl  0x10(%ebp)
  80240c:	ff 75 0c             	pushl  0xc(%ebp)
  80240f:	50                   	push   %eax
  802410:	6a 21                	push   $0x21
  802412:	e8 26 fc ff ff       	call   80203d <syscall>
  802417:	83 c4 18             	add    $0x18,%esp
}
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	50                   	push   %eax
  80242b:	6a 22                	push   $0x22
  80242d:	e8 0b fc ff ff       	call   80203d <syscall>
  802432:	83 c4 18             	add    $0x18,%esp
}
  802435:	90                   	nop
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	50                   	push   %eax
  802447:	6a 23                	push   $0x23
  802449:	e8 ef fb ff ff       	call   80203d <syscall>
  80244e:	83 c4 18             	add    $0x18,%esp
}
  802451:	90                   	nop
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
  802457:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80245a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80245d:	8d 50 04             	lea    0x4(%eax),%edx
  802460:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	52                   	push   %edx
  80246a:	50                   	push   %eax
  80246b:	6a 24                	push   $0x24
  80246d:	e8 cb fb ff ff       	call   80203d <syscall>
  802472:	83 c4 18             	add    $0x18,%esp
	return result;
  802475:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802478:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80247b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80247e:	89 01                	mov    %eax,(%ecx)
  802480:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802483:	8b 45 08             	mov    0x8(%ebp),%eax
  802486:	c9                   	leave  
  802487:	c2 04 00             	ret    $0x4

0080248a <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	ff 75 10             	pushl  0x10(%ebp)
  802494:	ff 75 0c             	pushl  0xc(%ebp)
  802497:	ff 75 08             	pushl  0x8(%ebp)
  80249a:	6a 13                	push   $0x13
  80249c:	e8 9c fb ff ff       	call   80203d <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a4:	90                   	nop
}
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 25                	push   $0x25
  8024b6:	e8 82 fb ff ff       	call   80203d <syscall>
  8024bb:	83 c4 18             	add    $0x18,%esp
}
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	83 ec 04             	sub    $0x4,%esp
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024cc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	50                   	push   %eax
  8024d9:	6a 26                	push   $0x26
  8024db:	e8 5d fb ff ff       	call   80203d <syscall>
  8024e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e3:	90                   	nop
}
  8024e4:	c9                   	leave  
  8024e5:	c3                   	ret    

008024e6 <rsttst>:
void rsttst()
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 28                	push   $0x28
  8024f5:	e8 43 fb ff ff       	call   80203d <syscall>
  8024fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8024fd:	90                   	nop
}
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    

00802500 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	83 ec 04             	sub    $0x4,%esp
  802506:	8b 45 14             	mov    0x14(%ebp),%eax
  802509:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80250c:	8b 55 18             	mov    0x18(%ebp),%edx
  80250f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802513:	52                   	push   %edx
  802514:	50                   	push   %eax
  802515:	ff 75 10             	pushl  0x10(%ebp)
  802518:	ff 75 0c             	pushl  0xc(%ebp)
  80251b:	ff 75 08             	pushl  0x8(%ebp)
  80251e:	6a 27                	push   $0x27
  802520:	e8 18 fb ff ff       	call   80203d <syscall>
  802525:	83 c4 18             	add    $0x18,%esp
	return ;
  802528:	90                   	nop
}
  802529:	c9                   	leave  
  80252a:	c3                   	ret    

0080252b <chktst>:
void chktst(uint32 n)
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	ff 75 08             	pushl  0x8(%ebp)
  802539:	6a 29                	push   $0x29
  80253b:	e8 fd fa ff ff       	call   80203d <syscall>
  802540:	83 c4 18             	add    $0x18,%esp
	return ;
  802543:	90                   	nop
}
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <inctst>:

void inctst()
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 2a                	push   $0x2a
  802555:	e8 e3 fa ff ff       	call   80203d <syscall>
  80255a:	83 c4 18             	add    $0x18,%esp
	return ;
  80255d:	90                   	nop
}
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <gettst>:
uint32 gettst()
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 2b                	push   $0x2b
  80256f:	e8 c9 fa ff ff       	call   80203d <syscall>
  802574:	83 c4 18             	add    $0x18,%esp
}
  802577:	c9                   	leave  
  802578:	c3                   	ret    

00802579 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
  80257c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 2c                	push   $0x2c
  80258b:	e8 ad fa ff ff       	call   80203d <syscall>
  802590:	83 c4 18             	add    $0x18,%esp
  802593:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802596:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80259a:	75 07                	jne    8025a3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80259c:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a1:	eb 05                	jmp    8025a8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    

008025aa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
  8025ad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 2c                	push   $0x2c
  8025bc:	e8 7c fa ff ff       	call   80203d <syscall>
  8025c1:	83 c4 18             	add    $0x18,%esp
  8025c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025c7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025cb:	75 07                	jne    8025d4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d2:	eb 05                	jmp    8025d9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d9:	c9                   	leave  
  8025da:	c3                   	ret    

008025db <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
  8025de:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 2c                	push   $0x2c
  8025ed:	e8 4b fa ff ff       	call   80203d <syscall>
  8025f2:	83 c4 18             	add    $0x18,%esp
  8025f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025f8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025fc:	75 07                	jne    802605 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802603:	eb 05                	jmp    80260a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802605:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80260a:	c9                   	leave  
  80260b:	c3                   	ret    

0080260c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80260c:	55                   	push   %ebp
  80260d:	89 e5                	mov    %esp,%ebp
  80260f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 2c                	push   $0x2c
  80261e:	e8 1a fa ff ff       	call   80203d <syscall>
  802623:	83 c4 18             	add    $0x18,%esp
  802626:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802629:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80262d:	75 07                	jne    802636 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80262f:	b8 01 00 00 00       	mov    $0x1,%eax
  802634:	eb 05                	jmp    80263b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802636:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	6a 00                	push   $0x0
  802648:	ff 75 08             	pushl  0x8(%ebp)
  80264b:	6a 2d                	push   $0x2d
  80264d:	e8 eb f9 ff ff       	call   80203d <syscall>
  802652:	83 c4 18             	add    $0x18,%esp
	return ;
  802655:	90                   	nop
}
  802656:	c9                   	leave  
  802657:	c3                   	ret    

00802658 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802658:	55                   	push   %ebp
  802659:	89 e5                	mov    %esp,%ebp
  80265b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80265c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80265f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802662:	8b 55 0c             	mov    0xc(%ebp),%edx
  802665:	8b 45 08             	mov    0x8(%ebp),%eax
  802668:	6a 00                	push   $0x0
  80266a:	53                   	push   %ebx
  80266b:	51                   	push   %ecx
  80266c:	52                   	push   %edx
  80266d:	50                   	push   %eax
  80266e:	6a 2e                	push   $0x2e
  802670:	e8 c8 f9 ff ff       	call   80203d <syscall>
  802675:	83 c4 18             	add    $0x18,%esp
}
  802678:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802680:	8b 55 0c             	mov    0xc(%ebp),%edx
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	52                   	push   %edx
  80268d:	50                   	push   %eax
  80268e:	6a 2f                	push   $0x2f
  802690:	e8 a8 f9 ff ff       	call   80203d <syscall>
  802695:	83 c4 18             	add    $0x18,%esp
}
  802698:	c9                   	leave  
  802699:	c3                   	ret    
  80269a:	66 90                	xchg   %ax,%ax

0080269c <__udivdi3>:
  80269c:	55                   	push   %ebp
  80269d:	57                   	push   %edi
  80269e:	56                   	push   %esi
  80269f:	53                   	push   %ebx
  8026a0:	83 ec 1c             	sub    $0x1c,%esp
  8026a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8026a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8026ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026b3:	89 ca                	mov    %ecx,%edx
  8026b5:	89 f8                	mov    %edi,%eax
  8026b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8026bb:	85 f6                	test   %esi,%esi
  8026bd:	75 2d                	jne    8026ec <__udivdi3+0x50>
  8026bf:	39 cf                	cmp    %ecx,%edi
  8026c1:	77 65                	ja     802728 <__udivdi3+0x8c>
  8026c3:	89 fd                	mov    %edi,%ebp
  8026c5:	85 ff                	test   %edi,%edi
  8026c7:	75 0b                	jne    8026d4 <__udivdi3+0x38>
  8026c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ce:	31 d2                	xor    %edx,%edx
  8026d0:	f7 f7                	div    %edi
  8026d2:	89 c5                	mov    %eax,%ebp
  8026d4:	31 d2                	xor    %edx,%edx
  8026d6:	89 c8                	mov    %ecx,%eax
  8026d8:	f7 f5                	div    %ebp
  8026da:	89 c1                	mov    %eax,%ecx
  8026dc:	89 d8                	mov    %ebx,%eax
  8026de:	f7 f5                	div    %ebp
  8026e0:	89 cf                	mov    %ecx,%edi
  8026e2:	89 fa                	mov    %edi,%edx
  8026e4:	83 c4 1c             	add    $0x1c,%esp
  8026e7:	5b                   	pop    %ebx
  8026e8:	5e                   	pop    %esi
  8026e9:	5f                   	pop    %edi
  8026ea:	5d                   	pop    %ebp
  8026eb:	c3                   	ret    
  8026ec:	39 ce                	cmp    %ecx,%esi
  8026ee:	77 28                	ja     802718 <__udivdi3+0x7c>
  8026f0:	0f bd fe             	bsr    %esi,%edi
  8026f3:	83 f7 1f             	xor    $0x1f,%edi
  8026f6:	75 40                	jne    802738 <__udivdi3+0x9c>
  8026f8:	39 ce                	cmp    %ecx,%esi
  8026fa:	72 0a                	jb     802706 <__udivdi3+0x6a>
  8026fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802700:	0f 87 9e 00 00 00    	ja     8027a4 <__udivdi3+0x108>
  802706:	b8 01 00 00 00       	mov    $0x1,%eax
  80270b:	89 fa                	mov    %edi,%edx
  80270d:	83 c4 1c             	add    $0x1c,%esp
  802710:	5b                   	pop    %ebx
  802711:	5e                   	pop    %esi
  802712:	5f                   	pop    %edi
  802713:	5d                   	pop    %ebp
  802714:	c3                   	ret    
  802715:	8d 76 00             	lea    0x0(%esi),%esi
  802718:	31 ff                	xor    %edi,%edi
  80271a:	31 c0                	xor    %eax,%eax
  80271c:	89 fa                	mov    %edi,%edx
  80271e:	83 c4 1c             	add    $0x1c,%esp
  802721:	5b                   	pop    %ebx
  802722:	5e                   	pop    %esi
  802723:	5f                   	pop    %edi
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    
  802726:	66 90                	xchg   %ax,%ax
  802728:	89 d8                	mov    %ebx,%eax
  80272a:	f7 f7                	div    %edi
  80272c:	31 ff                	xor    %edi,%edi
  80272e:	89 fa                	mov    %edi,%edx
  802730:	83 c4 1c             	add    $0x1c,%esp
  802733:	5b                   	pop    %ebx
  802734:	5e                   	pop    %esi
  802735:	5f                   	pop    %edi
  802736:	5d                   	pop    %ebp
  802737:	c3                   	ret    
  802738:	bd 20 00 00 00       	mov    $0x20,%ebp
  80273d:	89 eb                	mov    %ebp,%ebx
  80273f:	29 fb                	sub    %edi,%ebx
  802741:	89 f9                	mov    %edi,%ecx
  802743:	d3 e6                	shl    %cl,%esi
  802745:	89 c5                	mov    %eax,%ebp
  802747:	88 d9                	mov    %bl,%cl
  802749:	d3 ed                	shr    %cl,%ebp
  80274b:	89 e9                	mov    %ebp,%ecx
  80274d:	09 f1                	or     %esi,%ecx
  80274f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802753:	89 f9                	mov    %edi,%ecx
  802755:	d3 e0                	shl    %cl,%eax
  802757:	89 c5                	mov    %eax,%ebp
  802759:	89 d6                	mov    %edx,%esi
  80275b:	88 d9                	mov    %bl,%cl
  80275d:	d3 ee                	shr    %cl,%esi
  80275f:	89 f9                	mov    %edi,%ecx
  802761:	d3 e2                	shl    %cl,%edx
  802763:	8b 44 24 08          	mov    0x8(%esp),%eax
  802767:	88 d9                	mov    %bl,%cl
  802769:	d3 e8                	shr    %cl,%eax
  80276b:	09 c2                	or     %eax,%edx
  80276d:	89 d0                	mov    %edx,%eax
  80276f:	89 f2                	mov    %esi,%edx
  802771:	f7 74 24 0c          	divl   0xc(%esp)
  802775:	89 d6                	mov    %edx,%esi
  802777:	89 c3                	mov    %eax,%ebx
  802779:	f7 e5                	mul    %ebp
  80277b:	39 d6                	cmp    %edx,%esi
  80277d:	72 19                	jb     802798 <__udivdi3+0xfc>
  80277f:	74 0b                	je     80278c <__udivdi3+0xf0>
  802781:	89 d8                	mov    %ebx,%eax
  802783:	31 ff                	xor    %edi,%edi
  802785:	e9 58 ff ff ff       	jmp    8026e2 <__udivdi3+0x46>
  80278a:	66 90                	xchg   %ax,%ax
  80278c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802790:	89 f9                	mov    %edi,%ecx
  802792:	d3 e2                	shl    %cl,%edx
  802794:	39 c2                	cmp    %eax,%edx
  802796:	73 e9                	jae    802781 <__udivdi3+0xe5>
  802798:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80279b:	31 ff                	xor    %edi,%edi
  80279d:	e9 40 ff ff ff       	jmp    8026e2 <__udivdi3+0x46>
  8027a2:	66 90                	xchg   %ax,%ax
  8027a4:	31 c0                	xor    %eax,%eax
  8027a6:	e9 37 ff ff ff       	jmp    8026e2 <__udivdi3+0x46>
  8027ab:	90                   	nop

008027ac <__umoddi3>:
  8027ac:	55                   	push   %ebp
  8027ad:	57                   	push   %edi
  8027ae:	56                   	push   %esi
  8027af:	53                   	push   %ebx
  8027b0:	83 ec 1c             	sub    $0x1c,%esp
  8027b3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8027b7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027bf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8027c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027cb:	89 f3                	mov    %esi,%ebx
  8027cd:	89 fa                	mov    %edi,%edx
  8027cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8027d3:	89 34 24             	mov    %esi,(%esp)
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	75 1a                	jne    8027f4 <__umoddi3+0x48>
  8027da:	39 f7                	cmp    %esi,%edi
  8027dc:	0f 86 a2 00 00 00    	jbe    802884 <__umoddi3+0xd8>
  8027e2:	89 c8                	mov    %ecx,%eax
  8027e4:	89 f2                	mov    %esi,%edx
  8027e6:	f7 f7                	div    %edi
  8027e8:	89 d0                	mov    %edx,%eax
  8027ea:	31 d2                	xor    %edx,%edx
  8027ec:	83 c4 1c             	add    $0x1c,%esp
  8027ef:	5b                   	pop    %ebx
  8027f0:	5e                   	pop    %esi
  8027f1:	5f                   	pop    %edi
  8027f2:	5d                   	pop    %ebp
  8027f3:	c3                   	ret    
  8027f4:	39 f0                	cmp    %esi,%eax
  8027f6:	0f 87 ac 00 00 00    	ja     8028a8 <__umoddi3+0xfc>
  8027fc:	0f bd e8             	bsr    %eax,%ebp
  8027ff:	83 f5 1f             	xor    $0x1f,%ebp
  802802:	0f 84 ac 00 00 00    	je     8028b4 <__umoddi3+0x108>
  802808:	bf 20 00 00 00       	mov    $0x20,%edi
  80280d:	29 ef                	sub    %ebp,%edi
  80280f:	89 fe                	mov    %edi,%esi
  802811:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802815:	89 e9                	mov    %ebp,%ecx
  802817:	d3 e0                	shl    %cl,%eax
  802819:	89 d7                	mov    %edx,%edi
  80281b:	89 f1                	mov    %esi,%ecx
  80281d:	d3 ef                	shr    %cl,%edi
  80281f:	09 c7                	or     %eax,%edi
  802821:	89 e9                	mov    %ebp,%ecx
  802823:	d3 e2                	shl    %cl,%edx
  802825:	89 14 24             	mov    %edx,(%esp)
  802828:	89 d8                	mov    %ebx,%eax
  80282a:	d3 e0                	shl    %cl,%eax
  80282c:	89 c2                	mov    %eax,%edx
  80282e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802832:	d3 e0                	shl    %cl,%eax
  802834:	89 44 24 04          	mov    %eax,0x4(%esp)
  802838:	8b 44 24 08          	mov    0x8(%esp),%eax
  80283c:	89 f1                	mov    %esi,%ecx
  80283e:	d3 e8                	shr    %cl,%eax
  802840:	09 d0                	or     %edx,%eax
  802842:	d3 eb                	shr    %cl,%ebx
  802844:	89 da                	mov    %ebx,%edx
  802846:	f7 f7                	div    %edi
  802848:	89 d3                	mov    %edx,%ebx
  80284a:	f7 24 24             	mull   (%esp)
  80284d:	89 c6                	mov    %eax,%esi
  80284f:	89 d1                	mov    %edx,%ecx
  802851:	39 d3                	cmp    %edx,%ebx
  802853:	0f 82 87 00 00 00    	jb     8028e0 <__umoddi3+0x134>
  802859:	0f 84 91 00 00 00    	je     8028f0 <__umoddi3+0x144>
  80285f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802863:	29 f2                	sub    %esi,%edx
  802865:	19 cb                	sbb    %ecx,%ebx
  802867:	89 d8                	mov    %ebx,%eax
  802869:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80286d:	d3 e0                	shl    %cl,%eax
  80286f:	89 e9                	mov    %ebp,%ecx
  802871:	d3 ea                	shr    %cl,%edx
  802873:	09 d0                	or     %edx,%eax
  802875:	89 e9                	mov    %ebp,%ecx
  802877:	d3 eb                	shr    %cl,%ebx
  802879:	89 da                	mov    %ebx,%edx
  80287b:	83 c4 1c             	add    $0x1c,%esp
  80287e:	5b                   	pop    %ebx
  80287f:	5e                   	pop    %esi
  802880:	5f                   	pop    %edi
  802881:	5d                   	pop    %ebp
  802882:	c3                   	ret    
  802883:	90                   	nop
  802884:	89 fd                	mov    %edi,%ebp
  802886:	85 ff                	test   %edi,%edi
  802888:	75 0b                	jne    802895 <__umoddi3+0xe9>
  80288a:	b8 01 00 00 00       	mov    $0x1,%eax
  80288f:	31 d2                	xor    %edx,%edx
  802891:	f7 f7                	div    %edi
  802893:	89 c5                	mov    %eax,%ebp
  802895:	89 f0                	mov    %esi,%eax
  802897:	31 d2                	xor    %edx,%edx
  802899:	f7 f5                	div    %ebp
  80289b:	89 c8                	mov    %ecx,%eax
  80289d:	f7 f5                	div    %ebp
  80289f:	89 d0                	mov    %edx,%eax
  8028a1:	e9 44 ff ff ff       	jmp    8027ea <__umoddi3+0x3e>
  8028a6:	66 90                	xchg   %ax,%ax
  8028a8:	89 c8                	mov    %ecx,%eax
  8028aa:	89 f2                	mov    %esi,%edx
  8028ac:	83 c4 1c             	add    $0x1c,%esp
  8028af:	5b                   	pop    %ebx
  8028b0:	5e                   	pop    %esi
  8028b1:	5f                   	pop    %edi
  8028b2:	5d                   	pop    %ebp
  8028b3:	c3                   	ret    
  8028b4:	3b 04 24             	cmp    (%esp),%eax
  8028b7:	72 06                	jb     8028bf <__umoddi3+0x113>
  8028b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8028bd:	77 0f                	ja     8028ce <__umoddi3+0x122>
  8028bf:	89 f2                	mov    %esi,%edx
  8028c1:	29 f9                	sub    %edi,%ecx
  8028c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8028c7:	89 14 24             	mov    %edx,(%esp)
  8028ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8028d2:	8b 14 24             	mov    (%esp),%edx
  8028d5:	83 c4 1c             	add    $0x1c,%esp
  8028d8:	5b                   	pop    %ebx
  8028d9:	5e                   	pop    %esi
  8028da:	5f                   	pop    %edi
  8028db:	5d                   	pop    %ebp
  8028dc:	c3                   	ret    
  8028dd:	8d 76 00             	lea    0x0(%esi),%esi
  8028e0:	2b 04 24             	sub    (%esp),%eax
  8028e3:	19 fa                	sbb    %edi,%edx
  8028e5:	89 d1                	mov    %edx,%ecx
  8028e7:	89 c6                	mov    %eax,%esi
  8028e9:	e9 71 ff ff ff       	jmp    80285f <__umoddi3+0xb3>
  8028ee:	66 90                	xchg   %ax,%ax
  8028f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8028f4:	72 ea                	jb     8028e0 <__umoddi3+0x134>
  8028f6:	89 d9                	mov    %ebx,%ecx
  8028f8:	e9 62 ff ff ff       	jmp    80285f <__umoddi3+0xb3>
