
obj/user/tst1:     file format elf32-i386


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
  800031:	e8 a7 03 00 00       	call   8003dd <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 6c             	sub    $0x6c,%esp
	

	
	

	rsttst();
  800041:	e8 4e 1e 00 00       	call   801e94 <rsttst>
	int Mega = 1024*1024;
  800046:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  80004d:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	void* ptr_allocations[20] = {0};
  800054:	8d 55 8c             	lea    -0x74(%ebp),%edx
  800057:	b9 14 00 00 00       	mov    $0x14,%ecx
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	89 d7                	mov    %edx,%edi
  800063:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  800065:	e8 ed 1a 00 00       	call   801b57 <sys_calculate_free_frames>
  80006a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  80006d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800070:	01 c0                	add    %eax,%eax
  800072:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800075:	83 ec 0c             	sub    $0xc,%esp
  800078:	50                   	push   %eax
  800079:	e8 02 13 00 00       	call   801380 <malloc>
  80007e:	83 c4 10             	add    $0x10,%esp
  800081:	89 45 8c             	mov    %eax,-0x74(%ebp)
		tst((uint32) ptr_allocations[0], USER_HEAP_START,USER_HEAP_START + PAGE_SIZE, 'b', 0);
  800084:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	6a 00                	push   $0x0
  80008c:	6a 62                	push   $0x62
  80008e:	68 00 10 00 80       	push   $0x80001000
  800093:	68 00 00 00 80       	push   $0x80000000
  800098:	50                   	push   %eax
  800099:	e8 10 1e 00 00       	call   801eae <tst>
  80009e:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  8000a1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8000a4:	e8 ae 1a 00 00       	call   801b57 <sys_calculate_free_frames>
  8000a9:	29 c3                	sub    %eax,%ebx
  8000ab:	89 d8                	mov    %ebx,%eax
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	6a 65                	push   $0x65
  8000b4:	6a 00                	push   $0x0
  8000b6:	68 01 02 00 00       	push   $0x201
  8000bb:	50                   	push   %eax
  8000bc:	e8 ed 1d 00 00       	call   801eae <tst>
  8000c1:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  8000c4:	e8 8e 1a 00 00       	call   801b57 <sys_calculate_free_frames>
  8000c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  8000cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 a3 12 00 00       	call   801380 <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 45 90             	mov    %eax,-0x70(%ebp)
		tst((uint32) ptr_allocations[1], USER_HEAP_START+ 2*Mega,USER_HEAP_START + 2*Mega + PAGE_SIZE, 'b', 0);
  8000e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e6:	01 c0                	add    %eax,%eax
  8000e8:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8000ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f1:	01 c0                	add    %eax,%eax
  8000f3:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8000f9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	6a 00                	push   $0x0
  800101:	6a 62                	push   $0x62
  800103:	51                   	push   %ecx
  800104:	52                   	push   %edx
  800105:	50                   	push   %eax
  800106:	e8 a3 1d 00 00       	call   801eae <tst>
  80010b:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512 ,0, 'e', 0);
  80010e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800111:	e8 41 1a 00 00       	call   801b57 <sys_calculate_free_frames>
  800116:	29 c3                	sub    %eax,%ebx
  800118:	89 d8                	mov    %ebx,%eax
  80011a:	83 ec 0c             	sub    $0xc,%esp
  80011d:	6a 00                	push   $0x0
  80011f:	6a 65                	push   $0x65
  800121:	6a 00                	push   $0x0
  800123:	68 00 02 00 00       	push   $0x200
  800128:	50                   	push   %eax
  800129:	e8 80 1d 00 00       	call   801eae <tst>
  80012e:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800131:	e8 21 1a 00 00       	call   801b57 <sys_calculate_free_frames>
  800136:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800139:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80013c:	01 c0                	add    %eax,%eax
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	50                   	push   %eax
  800142:	e8 39 12 00 00       	call   801380 <malloc>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		tst((uint32) ptr_allocations[2], USER_HEAP_START+ 4*Mega,USER_HEAP_START + 4*Mega + PAGE_SIZE, 'b', 0);
  80014d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800150:	c1 e0 02             	shl    $0x2,%eax
  800153:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80015c:	c1 e0 02             	shl    $0x2,%eax
  80015f:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800165:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800168:	83 ec 0c             	sub    $0xc,%esp
  80016b:	6a 00                	push   $0x0
  80016d:	6a 62                	push   $0x62
  80016f:	51                   	push   %ecx
  800170:	52                   	push   %edx
  800171:	50                   	push   %eax
  800172:	e8 37 1d 00 00       	call   801eae <tst>
  800177:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1+1 ,0, 'e', 0);
  80017a:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80017d:	e8 d5 19 00 00       	call   801b57 <sys_calculate_free_frames>
  800182:	29 c3                	sub    %eax,%ebx
  800184:	89 d8                	mov    %ebx,%eax
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	6a 00                	push   $0x0
  80018b:	6a 65                	push   $0x65
  80018d:	6a 00                	push   $0x0
  80018f:	6a 02                	push   $0x2
  800191:	50                   	push   %eax
  800192:	e8 17 1d 00 00       	call   801eae <tst>
  800197:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 b8 19 00 00       	call   801b57 <sys_calculate_free_frames>
  80019f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8001a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a5:	01 c0                	add    %eax,%eax
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	50                   	push   %eax
  8001ab:	e8 d0 11 00 00       	call   801380 <malloc>
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	89 45 98             	mov    %eax,-0x68(%ebp)
		tst((uint32) ptr_allocations[3], USER_HEAP_START+ 4*Mega + 4*kilo,USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE, 'b', 0);
  8001b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001b9:	c1 e0 02             	shl    $0x2,%eax
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c1:	c1 e0 02             	shl    $0x2,%eax
  8001c4:	01 d0                	add    %edx,%eax
  8001c6:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8001cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001cf:	c1 e0 02             	shl    $0x2,%eax
  8001d2:	89 c2                	mov    %eax,%edx
  8001d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d7:	c1 e0 02             	shl    $0x2,%eax
  8001da:	01 d0                	add    %edx,%eax
  8001dc:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8001e2:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	6a 00                	push   $0x0
  8001ea:	6a 62                	push   $0x62
  8001ec:	51                   	push   %ecx
  8001ed:	52                   	push   %edx
  8001ee:	50                   	push   %eax
  8001ef:	e8 ba 1c 00 00       	call   801eae <tst>
  8001f4:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1 ,0, 'e', 0);
  8001f7:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001fa:	e8 58 19 00 00       	call   801b57 <sys_calculate_free_frames>
  8001ff:	29 c3                	sub    %eax,%ebx
  800201:	89 d8                	mov    %ebx,%eax
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	6a 00                	push   $0x0
  800208:	6a 65                	push   $0x65
  80020a:	6a 00                	push   $0x0
  80020c:	6a 01                	push   $0x1
  80020e:	50                   	push   %eax
  80020f:	e8 9a 1c 00 00       	call   801eae <tst>
  800214:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800217:	e8 3b 19 00 00       	call   801b57 <sys_calculate_free_frames>
  80021c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80021f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800222:	89 d0                	mov    %edx,%eax
  800224:	01 c0                	add    %eax,%eax
  800226:	01 d0                	add    %edx,%eax
  800228:	01 c0                	add    %eax,%eax
  80022a:	01 d0                	add    %edx,%eax
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	e8 4b 11 00 00       	call   801380 <malloc>
  800235:	83 c4 10             	add    $0x10,%esp
  800238:	89 45 9c             	mov    %eax,-0x64(%ebp)
		tst((uint32) ptr_allocations[4], USER_HEAP_START+ 4*Mega + 8*kilo,USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE, 'b', 0);
  80023b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023e:	c1 e0 02             	shl    $0x2,%eax
  800241:	89 c2                	mov    %eax,%edx
  800243:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800246:	c1 e0 03             	shl    $0x3,%eax
  800249:	01 d0                	add    %edx,%eax
  80024b:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800251:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800254:	c1 e0 02             	shl    $0x2,%eax
  800257:	89 c2                	mov    %eax,%edx
  800259:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80025c:	c1 e0 03             	shl    $0x3,%eax
  80025f:	01 d0                	add    %edx,%eax
  800261:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800267:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	6a 00                	push   $0x0
  80026f:	6a 62                	push   $0x62
  800271:	51                   	push   %ecx
  800272:	52                   	push   %edx
  800273:	50                   	push   %eax
  800274:	e8 35 1c 00 00       	call   801eae <tst>
  800279:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 2 ,0, 'e', 0);
  80027c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80027f:	e8 d3 18 00 00       	call   801b57 <sys_calculate_free_frames>
  800284:	29 c3                	sub    %eax,%ebx
  800286:	89 d8                	mov    %ebx,%eax
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	6a 00                	push   $0x0
  80028d:	6a 65                	push   $0x65
  80028f:	6a 00                	push   $0x0
  800291:	6a 02                	push   $0x2
  800293:	50                   	push   %eax
  800294:	e8 15 1c 00 00       	call   801eae <tst>
  800299:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  80029c:	e8 b6 18 00 00       	call   801b57 <sys_calculate_free_frames>
  8002a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8002a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a7:	89 c2                	mov    %eax,%edx
  8002a9:	01 d2                	add    %edx,%edx
  8002ab:	01 d0                	add    %edx,%eax
  8002ad:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002b0:	83 ec 0c             	sub    $0xc,%esp
  8002b3:	50                   	push   %eax
  8002b4:	e8 c7 10 00 00       	call   801380 <malloc>
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	89 45 a0             	mov    %eax,-0x60(%ebp)
		tst((uint32) ptr_allocations[5], USER_HEAP_START+ 4*Mega + 16*kilo,USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE, 'b', 0);
  8002bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002c2:	c1 e0 02             	shl    $0x2,%eax
  8002c5:	89 c2                	mov    %eax,%edx
  8002c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ca:	c1 e0 04             	shl    $0x4,%eax
  8002cd:	01 d0                	add    %edx,%eax
  8002cf:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8002d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002d8:	c1 e0 02             	shl    $0x2,%eax
  8002db:	89 c2                	mov    %eax,%edx
  8002dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e0:	c1 e0 04             	shl    $0x4,%eax
  8002e3:	01 d0                	add    %edx,%eax
  8002e5:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8002eb:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002ee:	83 ec 0c             	sub    $0xc,%esp
  8002f1:	6a 00                	push   $0x0
  8002f3:	6a 62                	push   $0x62
  8002f5:	51                   	push   %ecx
  8002f6:	52                   	push   %edx
  8002f7:	50                   	push   %eax
  8002f8:	e8 b1 1b 00 00       	call   801eae <tst>
  8002fd:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 3*Mega/4096 ,0, 'e', 0);
  800300:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800303:	89 c2                	mov    %eax,%edx
  800305:	01 d2                	add    %edx,%edx
  800307:	01 d0                	add    %edx,%eax
  800309:	85 c0                	test   %eax,%eax
  80030b:	79 05                	jns    800312 <_main+0x2da>
  80030d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800312:	c1 f8 0c             	sar    $0xc,%eax
  800315:	89 c3                	mov    %eax,%ebx
  800317:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80031a:	e8 38 18 00 00       	call   801b57 <sys_calculate_free_frames>
  80031f:	29 c6                	sub    %eax,%esi
  800321:	89 f0                	mov    %esi,%eax
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	6a 00                	push   $0x0
  800328:	6a 65                	push   $0x65
  80032a:	6a 00                	push   $0x0
  80032c:	53                   	push   %ebx
  80032d:	50                   	push   %eax
  80032e:	e8 7b 1b 00 00       	call   801eae <tst>
  800333:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800336:	e8 1c 18 00 00       	call   801b57 <sys_calculate_free_frames>
  80033b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  80033e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800341:	01 c0                	add    %eax,%eax
  800343:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800346:	83 ec 0c             	sub    $0xc,%esp
  800349:	50                   	push   %eax
  80034a:	e8 31 10 00 00       	call   801380 <malloc>
  80034f:	83 c4 10             	add    $0x10,%esp
  800352:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		tst((uint32) ptr_allocations[6], USER_HEAP_START+ 7*Mega + 16*kilo,USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE, 'b', 0);
  800355:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800358:	89 d0                	mov    %edx,%eax
  80035a:	01 c0                	add    %eax,%eax
  80035c:	01 d0                	add    %edx,%eax
  80035e:	01 c0                	add    %eax,%eax
  800360:	01 d0                	add    %edx,%eax
  800362:	89 c2                	mov    %eax,%edx
  800364:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800367:	c1 e0 04             	shl    $0x4,%eax
  80036a:	01 d0                	add    %edx,%eax
  80036c:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800372:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800375:	89 d0                	mov    %edx,%eax
  800377:	01 c0                	add    %eax,%eax
  800379:	01 d0                	add    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	01 d0                	add    %edx,%eax
  80037f:	89 c2                	mov    %eax,%edx
  800381:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800384:	c1 e0 04             	shl    $0x4,%eax
  800387:	01 d0                	add    %edx,%eax
  800389:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80038f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800392:	83 ec 0c             	sub    $0xc,%esp
  800395:	6a 00                	push   $0x0
  800397:	6a 62                	push   $0x62
  800399:	51                   	push   %ecx
  80039a:	52                   	push   %edx
  80039b:	50                   	push   %eax
  80039c:	e8 0d 1b 00 00       	call   801eae <tst>
  8003a1:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  8003a4:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003a7:	e8 ab 17 00 00       	call   801b57 <sys_calculate_free_frames>
  8003ac:	29 c3                	sub    %eax,%ebx
  8003ae:	89 d8                	mov    %ebx,%eax
  8003b0:	83 ec 0c             	sub    $0xc,%esp
  8003b3:	6a 00                	push   $0x0
  8003b5:	6a 65                	push   $0x65
  8003b7:	6a 00                	push   $0x0
  8003b9:	68 01 02 00 00       	push   $0x201
  8003be:	50                   	push   %eax
  8003bf:	e8 ea 1a 00 00       	call   801eae <tst>
  8003c4:	83 c4 20             	add    $0x20,%esp
	}

	chktst(14);
  8003c7:	83 ec 0c             	sub    $0xc,%esp
  8003ca:	6a 0e                	push   $0xe
  8003cc:	e8 08 1b 00 00       	call   801ed9 <chktst>
  8003d1:	83 c4 10             	add    $0x10,%esp

	return;
  8003d4:	90                   	nop
}
  8003d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d8:	5b                   	pop    %ebx
  8003d9:	5e                   	pop    %esi
  8003da:	5f                   	pop    %edi
  8003db:	5d                   	pop    %ebp
  8003dc:	c3                   	ret    

008003dd <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003dd:	55                   	push   %ebp
  8003de:	89 e5                	mov    %esp,%ebp
  8003e0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003e3:	e8 a4 16 00 00       	call   801a8c <sys_getenvindex>
  8003e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ee:	89 d0                	mov    %edx,%eax
  8003f0:	c1 e0 03             	shl    $0x3,%eax
  8003f3:	01 d0                	add    %edx,%eax
  8003f5:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003fc:	01 c8                	add    %ecx,%eax
  8003fe:	01 c0                	add    %eax,%eax
  800400:	01 d0                	add    %edx,%eax
  800402:	01 c0                	add    %eax,%eax
  800404:	01 d0                	add    %edx,%eax
  800406:	89 c2                	mov    %eax,%edx
  800408:	c1 e2 05             	shl    $0x5,%edx
  80040b:	29 c2                	sub    %eax,%edx
  80040d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800414:	89 c2                	mov    %eax,%edx
  800416:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80041c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800421:	a1 20 30 80 00       	mov    0x803020,%eax
  800426:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80042c:	84 c0                	test   %al,%al
  80042e:	74 0f                	je     80043f <libmain+0x62>
		binaryname = myEnv->prog_name;
  800430:	a1 20 30 80 00       	mov    0x803020,%eax
  800435:	05 40 3c 01 00       	add    $0x13c40,%eax
  80043a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80043f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800443:	7e 0a                	jle    80044f <libmain+0x72>
		binaryname = argv[0];
  800445:	8b 45 0c             	mov    0xc(%ebp),%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80044f:	83 ec 08             	sub    $0x8,%esp
  800452:	ff 75 0c             	pushl  0xc(%ebp)
  800455:	ff 75 08             	pushl  0x8(%ebp)
  800458:	e8 db fb ff ff       	call   800038 <_main>
  80045d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800460:	e8 c2 17 00 00       	call   801c27 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800465:	83 ec 0c             	sub    $0xc,%esp
  800468:	68 98 24 80 00       	push   $0x802498
  80046d:	e8 84 01 00 00       	call   8005f6 <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800475:	a1 20 30 80 00       	mov    0x803020,%eax
  80047a:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800480:	a1 20 30 80 00       	mov    0x803020,%eax
  800485:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80048b:	83 ec 04             	sub    $0x4,%esp
  80048e:	52                   	push   %edx
  80048f:	50                   	push   %eax
  800490:	68 c0 24 80 00       	push   $0x8024c0
  800495:	e8 5c 01 00 00       	call   8005f6 <cprintf>
  80049a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80049d:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a2:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8004a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ad:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8004b3:	83 ec 04             	sub    $0x4,%esp
  8004b6:	52                   	push   %edx
  8004b7:	50                   	push   %eax
  8004b8:	68 e8 24 80 00       	push   $0x8024e8
  8004bd:	e8 34 01 00 00       	call   8005f6 <cprintf>
  8004c2:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ca:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8004d0:	83 ec 08             	sub    $0x8,%esp
  8004d3:	50                   	push   %eax
  8004d4:	68 29 25 80 00       	push   $0x802529
  8004d9:	e8 18 01 00 00       	call   8005f6 <cprintf>
  8004de:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004e1:	83 ec 0c             	sub    $0xc,%esp
  8004e4:	68 98 24 80 00       	push   $0x802498
  8004e9:	e8 08 01 00 00       	call   8005f6 <cprintf>
  8004ee:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004f1:	e8 4b 17 00 00       	call   801c41 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004f6:	e8 19 00 00 00       	call   800514 <exit>
}
  8004fb:	90                   	nop
  8004fc:	c9                   	leave  
  8004fd:	c3                   	ret    

008004fe <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
  800501:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	6a 00                	push   $0x0
  800509:	e8 4a 15 00 00       	call   801a58 <sys_env_destroy>
  80050e:	83 c4 10             	add    $0x10,%esp
}
  800511:	90                   	nop
  800512:	c9                   	leave  
  800513:	c3                   	ret    

00800514 <exit>:

void
exit(void)
{
  800514:	55                   	push   %ebp
  800515:	89 e5                	mov    %esp,%ebp
  800517:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80051a:	e8 9f 15 00 00       	call   801abe <sys_env_exit>
}
  80051f:	90                   	nop
  800520:	c9                   	leave  
  800521:	c3                   	ret    

00800522 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800522:	55                   	push   %ebp
  800523:	89 e5                	mov    %esp,%ebp
  800525:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052b:	8b 00                	mov    (%eax),%eax
  80052d:	8d 48 01             	lea    0x1(%eax),%ecx
  800530:	8b 55 0c             	mov    0xc(%ebp),%edx
  800533:	89 0a                	mov    %ecx,(%edx)
  800535:	8b 55 08             	mov    0x8(%ebp),%edx
  800538:	88 d1                	mov    %dl,%cl
  80053a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800541:	8b 45 0c             	mov    0xc(%ebp),%eax
  800544:	8b 00                	mov    (%eax),%eax
  800546:	3d ff 00 00 00       	cmp    $0xff,%eax
  80054b:	75 2c                	jne    800579 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80054d:	a0 24 30 80 00       	mov    0x803024,%al
  800552:	0f b6 c0             	movzbl %al,%eax
  800555:	8b 55 0c             	mov    0xc(%ebp),%edx
  800558:	8b 12                	mov    (%edx),%edx
  80055a:	89 d1                	mov    %edx,%ecx
  80055c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055f:	83 c2 08             	add    $0x8,%edx
  800562:	83 ec 04             	sub    $0x4,%esp
  800565:	50                   	push   %eax
  800566:	51                   	push   %ecx
  800567:	52                   	push   %edx
  800568:	e8 a9 14 00 00       	call   801a16 <sys_cputs>
  80056d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800570:	8b 45 0c             	mov    0xc(%ebp),%eax
  800573:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057c:	8b 40 04             	mov    0x4(%eax),%eax
  80057f:	8d 50 01             	lea    0x1(%eax),%edx
  800582:	8b 45 0c             	mov    0xc(%ebp),%eax
  800585:	89 50 04             	mov    %edx,0x4(%eax)
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800594:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80059b:	00 00 00 
	b.cnt = 0;
  80059e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005a5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005a8:	ff 75 0c             	pushl  0xc(%ebp)
  8005ab:	ff 75 08             	pushl  0x8(%ebp)
  8005ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b4:	50                   	push   %eax
  8005b5:	68 22 05 80 00       	push   $0x800522
  8005ba:	e8 11 02 00 00       	call   8007d0 <vprintfmt>
  8005bf:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005c2:	a0 24 30 80 00       	mov    0x803024,%al
  8005c7:	0f b6 c0             	movzbl %al,%eax
  8005ca:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	50                   	push   %eax
  8005d4:	52                   	push   %edx
  8005d5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005db:	83 c0 08             	add    $0x8,%eax
  8005de:	50                   	push   %eax
  8005df:	e8 32 14 00 00       	call   801a16 <sys_cputs>
  8005e4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005e7:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8005ee:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005f4:	c9                   	leave  
  8005f5:	c3                   	ret    

008005f6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005fc:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800603:	8d 45 0c             	lea    0xc(%ebp),%eax
  800606:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	ff 75 f4             	pushl  -0xc(%ebp)
  800612:	50                   	push   %eax
  800613:	e8 73 ff ff ff       	call   80058b <vcprintf>
  800618:	83 c4 10             	add    $0x10,%esp
  80061b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80061e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800621:	c9                   	leave  
  800622:	c3                   	ret    

00800623 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
  800626:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800629:	e8 f9 15 00 00       	call   801c27 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80062e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800631:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	ff 75 f4             	pushl  -0xc(%ebp)
  80063d:	50                   	push   %eax
  80063e:	e8 48 ff ff ff       	call   80058b <vcprintf>
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800649:	e8 f3 15 00 00       	call   801c41 <sys_enable_interrupt>
	return cnt;
  80064e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800651:	c9                   	leave  
  800652:	c3                   	ret    

00800653 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800653:	55                   	push   %ebp
  800654:	89 e5                	mov    %esp,%ebp
  800656:	53                   	push   %ebx
  800657:	83 ec 14             	sub    $0x14,%esp
  80065a:	8b 45 10             	mov    0x10(%ebp),%eax
  80065d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800666:	8b 45 18             	mov    0x18(%ebp),%eax
  800669:	ba 00 00 00 00       	mov    $0x0,%edx
  80066e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800671:	77 55                	ja     8006c8 <printnum+0x75>
  800673:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800676:	72 05                	jb     80067d <printnum+0x2a>
  800678:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80067b:	77 4b                	ja     8006c8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80067d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800680:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800683:	8b 45 18             	mov    0x18(%ebp),%eax
  800686:	ba 00 00 00 00       	mov    $0x0,%edx
  80068b:	52                   	push   %edx
  80068c:	50                   	push   %eax
  80068d:	ff 75 f4             	pushl  -0xc(%ebp)
  800690:	ff 75 f0             	pushl  -0x10(%ebp)
  800693:	e8 80 1b 00 00       	call   802218 <__udivdi3>
  800698:	83 c4 10             	add    $0x10,%esp
  80069b:	83 ec 04             	sub    $0x4,%esp
  80069e:	ff 75 20             	pushl  0x20(%ebp)
  8006a1:	53                   	push   %ebx
  8006a2:	ff 75 18             	pushl  0x18(%ebp)
  8006a5:	52                   	push   %edx
  8006a6:	50                   	push   %eax
  8006a7:	ff 75 0c             	pushl  0xc(%ebp)
  8006aa:	ff 75 08             	pushl  0x8(%ebp)
  8006ad:	e8 a1 ff ff ff       	call   800653 <printnum>
  8006b2:	83 c4 20             	add    $0x20,%esp
  8006b5:	eb 1a                	jmp    8006d1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006b7:	83 ec 08             	sub    $0x8,%esp
  8006ba:	ff 75 0c             	pushl  0xc(%ebp)
  8006bd:	ff 75 20             	pushl  0x20(%ebp)
  8006c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c3:	ff d0                	call   *%eax
  8006c5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006c8:	ff 4d 1c             	decl   0x1c(%ebp)
  8006cb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006cf:	7f e6                	jg     8006b7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006d1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006df:	53                   	push   %ebx
  8006e0:	51                   	push   %ecx
  8006e1:	52                   	push   %edx
  8006e2:	50                   	push   %eax
  8006e3:	e8 40 1c 00 00       	call   802328 <__umoddi3>
  8006e8:	83 c4 10             	add    $0x10,%esp
  8006eb:	05 54 27 80 00       	add    $0x802754,%eax
  8006f0:	8a 00                	mov    (%eax),%al
  8006f2:	0f be c0             	movsbl %al,%eax
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 0c             	pushl  0xc(%ebp)
  8006fb:	50                   	push   %eax
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	ff d0                	call   *%eax
  800701:	83 c4 10             	add    $0x10,%esp
}
  800704:	90                   	nop
  800705:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800708:	c9                   	leave  
  800709:	c3                   	ret    

0080070a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80070a:	55                   	push   %ebp
  80070b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80070d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800711:	7e 1c                	jle    80072f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	8d 50 08             	lea    0x8(%eax),%edx
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	89 10                	mov    %edx,(%eax)
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	83 e8 08             	sub    $0x8,%eax
  800728:	8b 50 04             	mov    0x4(%eax),%edx
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	eb 40                	jmp    80076f <getuint+0x65>
	else if (lflag)
  80072f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800733:	74 1e                	je     800753 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	8d 50 04             	lea    0x4(%eax),%edx
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	89 10                	mov    %edx,(%eax)
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	83 e8 04             	sub    $0x4,%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	ba 00 00 00 00       	mov    $0x0,%edx
  800751:	eb 1c                	jmp    80076f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	8d 50 04             	lea    0x4(%eax),%edx
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	89 10                	mov    %edx,(%eax)
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	83 e8 04             	sub    $0x4,%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80076f:	5d                   	pop    %ebp
  800770:	c3                   	ret    

00800771 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800771:	55                   	push   %ebp
  800772:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800774:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800778:	7e 1c                	jle    800796 <getint+0x25>
		return va_arg(*ap, long long);
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	8d 50 08             	lea    0x8(%eax),%edx
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	89 10                	mov    %edx,(%eax)
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	8b 00                	mov    (%eax),%eax
  80078c:	83 e8 08             	sub    $0x8,%eax
  80078f:	8b 50 04             	mov    0x4(%eax),%edx
  800792:	8b 00                	mov    (%eax),%eax
  800794:	eb 38                	jmp    8007ce <getint+0x5d>
	else if (lflag)
  800796:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80079a:	74 1a                	je     8007b6 <getint+0x45>
		return va_arg(*ap, long);
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	8d 50 04             	lea    0x4(%eax),%edx
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	89 10                	mov    %edx,(%eax)
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	83 e8 04             	sub    $0x4,%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	99                   	cltd   
  8007b4:	eb 18                	jmp    8007ce <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	8d 50 04             	lea    0x4(%eax),%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	89 10                	mov    %edx,(%eax)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 e8 04             	sub    $0x4,%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	99                   	cltd   
}
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    

008007d0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	56                   	push   %esi
  8007d4:	53                   	push   %ebx
  8007d5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d8:	eb 17                	jmp    8007f1 <vprintfmt+0x21>
			if (ch == '\0')
  8007da:	85 db                	test   %ebx,%ebx
  8007dc:	0f 84 af 03 00 00    	je     800b91 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	ff 75 0c             	pushl  0xc(%ebp)
  8007e8:	53                   	push   %ebx
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	ff d0                	call   *%eax
  8007ee:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f4:	8d 50 01             	lea    0x1(%eax),%edx
  8007f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8007fa:	8a 00                	mov    (%eax),%al
  8007fc:	0f b6 d8             	movzbl %al,%ebx
  8007ff:	83 fb 25             	cmp    $0x25,%ebx
  800802:	75 d6                	jne    8007da <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800804:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800808:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80080f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800816:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80081d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800824:	8b 45 10             	mov    0x10(%ebp),%eax
  800827:	8d 50 01             	lea    0x1(%eax),%edx
  80082a:	89 55 10             	mov    %edx,0x10(%ebp)
  80082d:	8a 00                	mov    (%eax),%al
  80082f:	0f b6 d8             	movzbl %al,%ebx
  800832:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800835:	83 f8 55             	cmp    $0x55,%eax
  800838:	0f 87 2b 03 00 00    	ja     800b69 <vprintfmt+0x399>
  80083e:	8b 04 85 78 27 80 00 	mov    0x802778(,%eax,4),%eax
  800845:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800847:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80084b:	eb d7                	jmp    800824 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80084d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800851:	eb d1                	jmp    800824 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800853:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80085a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80085d:	89 d0                	mov    %edx,%eax
  80085f:	c1 e0 02             	shl    $0x2,%eax
  800862:	01 d0                	add    %edx,%eax
  800864:	01 c0                	add    %eax,%eax
  800866:	01 d8                	add    %ebx,%eax
  800868:	83 e8 30             	sub    $0x30,%eax
  80086b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80086e:	8b 45 10             	mov    0x10(%ebp),%eax
  800871:	8a 00                	mov    (%eax),%al
  800873:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800876:	83 fb 2f             	cmp    $0x2f,%ebx
  800879:	7e 3e                	jle    8008b9 <vprintfmt+0xe9>
  80087b:	83 fb 39             	cmp    $0x39,%ebx
  80087e:	7f 39                	jg     8008b9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800880:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800883:	eb d5                	jmp    80085a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	83 c0 04             	add    $0x4,%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800899:	eb 1f                	jmp    8008ba <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80089b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089f:	79 83                	jns    800824 <vprintfmt+0x54>
				width = 0;
  8008a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008a8:	e9 77 ff ff ff       	jmp    800824 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008ad:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008b4:	e9 6b ff ff ff       	jmp    800824 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008b9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008be:	0f 89 60 ff ff ff    	jns    800824 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ca:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008d1:	e9 4e ff ff ff       	jmp    800824 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008d6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008d9:	e9 46 ff ff ff       	jmp    800824 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008de:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e1:	83 c0 04             	add    $0x4,%eax
  8008e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	83 e8 04             	sub    $0x4,%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	50                   	push   %eax
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
			break;
  8008fe:	e9 89 02 00 00       	jmp    800b8c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800914:	85 db                	test   %ebx,%ebx
  800916:	79 02                	jns    80091a <vprintfmt+0x14a>
				err = -err;
  800918:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80091a:	83 fb 64             	cmp    $0x64,%ebx
  80091d:	7f 0b                	jg     80092a <vprintfmt+0x15a>
  80091f:	8b 34 9d c0 25 80 00 	mov    0x8025c0(,%ebx,4),%esi
  800926:	85 f6                	test   %esi,%esi
  800928:	75 19                	jne    800943 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80092a:	53                   	push   %ebx
  80092b:	68 65 27 80 00       	push   $0x802765
  800930:	ff 75 0c             	pushl  0xc(%ebp)
  800933:	ff 75 08             	pushl  0x8(%ebp)
  800936:	e8 5e 02 00 00       	call   800b99 <printfmt>
  80093b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80093e:	e9 49 02 00 00       	jmp    800b8c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800943:	56                   	push   %esi
  800944:	68 6e 27 80 00       	push   $0x80276e
  800949:	ff 75 0c             	pushl  0xc(%ebp)
  80094c:	ff 75 08             	pushl  0x8(%ebp)
  80094f:	e8 45 02 00 00       	call   800b99 <printfmt>
  800954:	83 c4 10             	add    $0x10,%esp
			break;
  800957:	e9 30 02 00 00       	jmp    800b8c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80095c:	8b 45 14             	mov    0x14(%ebp),%eax
  80095f:	83 c0 04             	add    $0x4,%eax
  800962:	89 45 14             	mov    %eax,0x14(%ebp)
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	83 e8 04             	sub    $0x4,%eax
  80096b:	8b 30                	mov    (%eax),%esi
  80096d:	85 f6                	test   %esi,%esi
  80096f:	75 05                	jne    800976 <vprintfmt+0x1a6>
				p = "(null)";
  800971:	be 71 27 80 00       	mov    $0x802771,%esi
			if (width > 0 && padc != '-')
  800976:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097a:	7e 6d                	jle    8009e9 <vprintfmt+0x219>
  80097c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800980:	74 67                	je     8009e9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800982:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	50                   	push   %eax
  800989:	56                   	push   %esi
  80098a:	e8 0c 03 00 00       	call   800c9b <strnlen>
  80098f:	83 c4 10             	add    $0x10,%esp
  800992:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800995:	eb 16                	jmp    8009ad <vprintfmt+0x1dd>
					putch(padc, putdat);
  800997:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	50                   	push   %eax
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	ff d0                	call   *%eax
  8009a7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009aa:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b1:	7f e4                	jg     800997 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b3:	eb 34                	jmp    8009e9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009b5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009b9:	74 1c                	je     8009d7 <vprintfmt+0x207>
  8009bb:	83 fb 1f             	cmp    $0x1f,%ebx
  8009be:	7e 05                	jle    8009c5 <vprintfmt+0x1f5>
  8009c0:	83 fb 7e             	cmp    $0x7e,%ebx
  8009c3:	7e 12                	jle    8009d7 <vprintfmt+0x207>
					putch('?', putdat);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	6a 3f                	push   $0x3f
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	ff d0                	call   *%eax
  8009d2:	83 c4 10             	add    $0x10,%esp
  8009d5:	eb 0f                	jmp    8009e6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	53                   	push   %ebx
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e9:	89 f0                	mov    %esi,%eax
  8009eb:	8d 70 01             	lea    0x1(%eax),%esi
  8009ee:	8a 00                	mov    (%eax),%al
  8009f0:	0f be d8             	movsbl %al,%ebx
  8009f3:	85 db                	test   %ebx,%ebx
  8009f5:	74 24                	je     800a1b <vprintfmt+0x24b>
  8009f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009fb:	78 b8                	js     8009b5 <vprintfmt+0x1e5>
  8009fd:	ff 4d e0             	decl   -0x20(%ebp)
  800a00:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a04:	79 af                	jns    8009b5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a06:	eb 13                	jmp    800a1b <vprintfmt+0x24b>
				putch(' ', putdat);
  800a08:	83 ec 08             	sub    $0x8,%esp
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	6a 20                	push   $0x20
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	ff d0                	call   *%eax
  800a15:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a18:	ff 4d e4             	decl   -0x1c(%ebp)
  800a1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1f:	7f e7                	jg     800a08 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a21:	e9 66 01 00 00       	jmp    800b8c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 e8             	pushl  -0x18(%ebp)
  800a2c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a2f:	50                   	push   %eax
  800a30:	e8 3c fd ff ff       	call   800771 <getint>
  800a35:	83 c4 10             	add    $0x10,%esp
  800a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a44:	85 d2                	test   %edx,%edx
  800a46:	79 23                	jns    800a6b <vprintfmt+0x29b>
				putch('-', putdat);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	ff 75 0c             	pushl  0xc(%ebp)
  800a4e:	6a 2d                	push   $0x2d
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	ff d0                	call   *%eax
  800a55:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5e:	f7 d8                	neg    %eax
  800a60:	83 d2 00             	adc    $0x0,%edx
  800a63:	f7 da                	neg    %edx
  800a65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a6b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a72:	e9 bc 00 00 00       	jmp    800b33 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a7d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a80:	50                   	push   %eax
  800a81:	e8 84 fc ff ff       	call   80070a <getuint>
  800a86:	83 c4 10             	add    $0x10,%esp
  800a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a8f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a96:	e9 98 00 00 00       	jmp    800b33 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	6a 58                	push   $0x58
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	ff d0                	call   *%eax
  800aa8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	6a 58                	push   $0x58
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	ff d0                	call   *%eax
  800ab8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	6a 58                	push   $0x58
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	ff d0                	call   *%eax
  800ac8:	83 c4 10             	add    $0x10,%esp
			break;
  800acb:	e9 bc 00 00 00       	jmp    800b8c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ad0:	83 ec 08             	sub    $0x8,%esp
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	6a 30                	push   $0x30
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	ff 75 0c             	pushl  0xc(%ebp)
  800ae6:	6a 78                	push   $0x78
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	ff d0                	call   *%eax
  800aed:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	83 c0 04             	add    $0x4,%eax
  800af6:	89 45 14             	mov    %eax,0x14(%ebp)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	83 e8 04             	sub    $0x4,%eax
  800aff:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b0b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b12:	eb 1f                	jmp    800b33 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 e8             	pushl  -0x18(%ebp)
  800b1a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b1d:	50                   	push   %eax
  800b1e:	e8 e7 fb ff ff       	call   80070a <getuint>
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b29:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b2c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b33:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b3a:	83 ec 04             	sub    $0x4,%esp
  800b3d:	52                   	push   %edx
  800b3e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b41:	50                   	push   %eax
  800b42:	ff 75 f4             	pushl  -0xc(%ebp)
  800b45:	ff 75 f0             	pushl  -0x10(%ebp)
  800b48:	ff 75 0c             	pushl  0xc(%ebp)
  800b4b:	ff 75 08             	pushl  0x8(%ebp)
  800b4e:	e8 00 fb ff ff       	call   800653 <printnum>
  800b53:	83 c4 20             	add    $0x20,%esp
			break;
  800b56:	eb 34                	jmp    800b8c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	53                   	push   %ebx
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	ff d0                	call   *%eax
  800b64:	83 c4 10             	add    $0x10,%esp
			break;
  800b67:	eb 23                	jmp    800b8c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	6a 25                	push   $0x25
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	ff d0                	call   *%eax
  800b76:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b79:	ff 4d 10             	decl   0x10(%ebp)
  800b7c:	eb 03                	jmp    800b81 <vprintfmt+0x3b1>
  800b7e:	ff 4d 10             	decl   0x10(%ebp)
  800b81:	8b 45 10             	mov    0x10(%ebp),%eax
  800b84:	48                   	dec    %eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	3c 25                	cmp    $0x25,%al
  800b89:	75 f3                	jne    800b7e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b8b:	90                   	nop
		}
	}
  800b8c:	e9 47 fc ff ff       	jmp    8007d8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b91:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b95:	5b                   	pop    %ebx
  800b96:	5e                   	pop    %esi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b9f:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba2:	83 c0 04             	add    $0x4,%eax
  800ba5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ba8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bab:	ff 75 f4             	pushl  -0xc(%ebp)
  800bae:	50                   	push   %eax
  800baf:	ff 75 0c             	pushl  0xc(%ebp)
  800bb2:	ff 75 08             	pushl  0x8(%ebp)
  800bb5:	e8 16 fc ff ff       	call   8007d0 <vprintfmt>
  800bba:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bbd:	90                   	nop
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc6:	8b 40 08             	mov    0x8(%eax),%eax
  800bc9:	8d 50 01             	lea    0x1(%eax),%edx
  800bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd5:	8b 10                	mov    (%eax),%edx
  800bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bda:	8b 40 04             	mov    0x4(%eax),%eax
  800bdd:	39 c2                	cmp    %eax,%edx
  800bdf:	73 12                	jae    800bf3 <sprintputch+0x33>
		*b->buf++ = ch;
  800be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be4:	8b 00                	mov    (%eax),%eax
  800be6:	8d 48 01             	lea    0x1(%eax),%ecx
  800be9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bec:	89 0a                	mov    %ecx,(%edx)
  800bee:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf1:	88 10                	mov    %dl,(%eax)
}
  800bf3:	90                   	nop
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c05:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	01 d0                	add    %edx,%eax
  800c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c1b:	74 06                	je     800c23 <vsnprintf+0x2d>
  800c1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c21:	7f 07                	jg     800c2a <vsnprintf+0x34>
		return -E_INVAL;
  800c23:	b8 03 00 00 00       	mov    $0x3,%eax
  800c28:	eb 20                	jmp    800c4a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c2a:	ff 75 14             	pushl  0x14(%ebp)
  800c2d:	ff 75 10             	pushl  0x10(%ebp)
  800c30:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c33:	50                   	push   %eax
  800c34:	68 c0 0b 80 00       	push   $0x800bc0
  800c39:	e8 92 fb ff ff       	call   8007d0 <vprintfmt>
  800c3e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c44:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    

00800c4c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c52:	8d 45 10             	lea    0x10(%ebp),%eax
  800c55:	83 c0 04             	add    $0x4,%eax
  800c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c61:	50                   	push   %eax
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	ff 75 08             	pushl  0x8(%ebp)
  800c68:	e8 89 ff ff ff       	call   800bf6 <vsnprintf>
  800c6d:	83 c4 10             	add    $0x10,%esp
  800c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c85:	eb 06                	jmp    800c8d <strlen+0x15>
		n++;
  800c87:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c8a:	ff 45 08             	incl   0x8(%ebp)
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	84 c0                	test   %al,%al
  800c94:	75 f1                	jne    800c87 <strlen+0xf>
		n++;
	return n;
  800c96:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca8:	eb 09                	jmp    800cb3 <strnlen+0x18>
		n++;
  800caa:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cad:	ff 45 08             	incl   0x8(%ebp)
  800cb0:	ff 4d 0c             	decl   0xc(%ebp)
  800cb3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb7:	74 09                	je     800cc2 <strnlen+0x27>
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 e8                	jne    800caa <strnlen+0xf>
		n++;
	return n;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cd3:	90                   	nop
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8d 50 01             	lea    0x1(%eax),%edx
  800cda:	89 55 08             	mov    %edx,0x8(%ebp)
  800cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce6:	8a 12                	mov    (%edx),%dl
  800ce8:	88 10                	mov    %dl,(%eax)
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	84 c0                	test   %al,%al
  800cee:	75 e4                	jne    800cd4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf3:	c9                   	leave  
  800cf4:	c3                   	ret    

00800cf5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d08:	eb 1f                	jmp    800d29 <strncpy+0x34>
		*dst++ = *src;
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8d 50 01             	lea    0x1(%eax),%edx
  800d10:	89 55 08             	mov    %edx,0x8(%ebp)
  800d13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d16:	8a 12                	mov    (%edx),%dl
  800d18:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	84 c0                	test   %al,%al
  800d21:	74 03                	je     800d26 <strncpy+0x31>
			src++;
  800d23:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d26:	ff 45 fc             	incl   -0x4(%ebp)
  800d29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d2f:	72 d9                	jb     800d0a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d31:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d34:	c9                   	leave  
  800d35:	c3                   	ret    

00800d36 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d46:	74 30                	je     800d78 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d48:	eb 16                	jmp    800d60 <strlcpy+0x2a>
			*dst++ = *src++;
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8d 50 01             	lea    0x1(%eax),%edx
  800d50:	89 55 08             	mov    %edx,0x8(%ebp)
  800d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d56:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d59:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d5c:	8a 12                	mov    (%edx),%dl
  800d5e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d60:	ff 4d 10             	decl   0x10(%ebp)
  800d63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d67:	74 09                	je     800d72 <strlcpy+0x3c>
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	84 c0                	test   %al,%al
  800d70:	75 d8                	jne    800d4a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d78:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7e:	29 c2                	sub    %eax,%edx
  800d80:	89 d0                	mov    %edx,%eax
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d87:	eb 06                	jmp    800d8f <strcmp+0xb>
		p++, q++;
  800d89:	ff 45 08             	incl   0x8(%ebp)
  800d8c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	84 c0                	test   %al,%al
  800d96:	74 0e                	je     800da6 <strcmp+0x22>
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8a 10                	mov    (%eax),%dl
  800d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	38 c2                	cmp    %al,%dl
  800da4:	74 e3                	je     800d89 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	0f b6 d0             	movzbl %al,%edx
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	0f b6 c0             	movzbl %al,%eax
  800db6:	29 c2                	sub    %eax,%edx
  800db8:	89 d0                	mov    %edx,%eax
}
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    

00800dbc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dbf:	eb 09                	jmp    800dca <strncmp+0xe>
		n--, p++, q++;
  800dc1:	ff 4d 10             	decl   0x10(%ebp)
  800dc4:	ff 45 08             	incl   0x8(%ebp)
  800dc7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dce:	74 17                	je     800de7 <strncmp+0x2b>
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	84 c0                	test   %al,%al
  800dd7:	74 0e                	je     800de7 <strncmp+0x2b>
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8a 10                	mov    (%eax),%dl
  800dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	38 c2                	cmp    %al,%dl
  800de5:	74 da                	je     800dc1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800de7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800deb:	75 07                	jne    800df4 <strncmp+0x38>
		return 0;
  800ded:	b8 00 00 00 00       	mov    $0x0,%eax
  800df2:	eb 14                	jmp    800e08 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d0             	movzbl %al,%edx
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	0f b6 c0             	movzbl %al,%eax
  800e04:	29 c2                	sub    %eax,%edx
  800e06:	89 d0                	mov    %edx,%eax
}
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 04             	sub    $0x4,%esp
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e16:	eb 12                	jmp    800e2a <strchr+0x20>
		if (*s == c)
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e20:	75 05                	jne    800e27 <strchr+0x1d>
			return (char *) s;
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	eb 11                	jmp    800e38 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e27:	ff 45 08             	incl   0x8(%ebp)
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	84 c0                	test   %al,%al
  800e31:	75 e5                	jne    800e18 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	83 ec 04             	sub    $0x4,%esp
  800e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e43:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e46:	eb 0d                	jmp    800e55 <strfind+0x1b>
		if (*s == c)
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e50:	74 0e                	je     800e60 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e52:	ff 45 08             	incl   0x8(%ebp)
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	84 c0                	test   %al,%al
  800e5c:	75 ea                	jne    800e48 <strfind+0xe>
  800e5e:	eb 01                	jmp    800e61 <strfind+0x27>
		if (*s == c)
			break;
  800e60:	90                   	nop
	return (char *) s;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e72:	8b 45 10             	mov    0x10(%ebp),%eax
  800e75:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e78:	eb 0e                	jmp    800e88 <memset+0x22>
		*p++ = c;
  800e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7d:	8d 50 01             	lea    0x1(%eax),%edx
  800e80:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e86:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e88:	ff 4d f8             	decl   -0x8(%ebp)
  800e8b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e8f:	79 e9                	jns    800e7a <memset+0x14>
		*p++ = c;

	return v;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e94:	c9                   	leave  
  800e95:	c3                   	ret    

00800e96 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ea8:	eb 16                	jmp    800ec0 <memcpy+0x2a>
		*d++ = *s++;
  800eaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ead:	8d 50 01             	lea    0x1(%eax),%edx
  800eb0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eb3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eb6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ebc:	8a 12                	mov    (%edx),%dl
  800ebe:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec9:	85 c0                	test   %eax,%eax
  800ecb:	75 dd                	jne    800eaa <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eea:	73 50                	jae    800f3c <memmove+0x6a>
  800eec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eef:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef2:	01 d0                	add    %edx,%eax
  800ef4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ef7:	76 43                	jbe    800f3c <memmove+0x6a>
		s += n;
  800ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  800efc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f05:	eb 10                	jmp    800f17 <memmove+0x45>
			*--d = *--s;
  800f07:	ff 4d f8             	decl   -0x8(%ebp)
  800f0a:	ff 4d fc             	decl   -0x4(%ebp)
  800f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f10:	8a 10                	mov    (%eax),%dl
  800f12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f15:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f20:	85 c0                	test   %eax,%eax
  800f22:	75 e3                	jne    800f07 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f24:	eb 23                	jmp    800f49 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f29:	8d 50 01             	lea    0x1(%eax),%edx
  800f2c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f35:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f38:	8a 12                	mov    (%edx),%dl
  800f3a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f42:	89 55 10             	mov    %edx,0x10(%ebp)
  800f45:	85 c0                	test   %eax,%eax
  800f47:	75 dd                	jne    800f26 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4c:	c9                   	leave  
  800f4d:	c3                   	ret    

00800f4e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f60:	eb 2a                	jmp    800f8c <memcmp+0x3e>
		if (*s1 != *s2)
  800f62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f65:	8a 10                	mov    (%eax),%dl
  800f67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	38 c2                	cmp    %al,%dl
  800f6e:	74 16                	je     800f86 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	0f b6 d0             	movzbl %al,%edx
  800f78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	0f b6 c0             	movzbl %al,%eax
  800f80:	29 c2                	sub    %eax,%edx
  800f82:	89 d0                	mov    %edx,%eax
  800f84:	eb 18                	jmp    800f9e <memcmp+0x50>
		s1++, s2++;
  800f86:	ff 45 fc             	incl   -0x4(%ebp)
  800f89:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f92:	89 55 10             	mov    %edx,0x10(%ebp)
  800f95:	85 c0                	test   %eax,%eax
  800f97:	75 c9                	jne    800f62 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9e:	c9                   	leave  
  800f9f:	c3                   	ret    

00800fa0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	01 d0                	add    %edx,%eax
  800fae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fb1:	eb 15                	jmp    800fc8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	0f b6 d0             	movzbl %al,%edx
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	0f b6 c0             	movzbl %al,%eax
  800fc1:	39 c2                	cmp    %eax,%edx
  800fc3:	74 0d                	je     800fd2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fc5:	ff 45 08             	incl   0x8(%ebp)
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fce:	72 e3                	jb     800fb3 <memfind+0x13>
  800fd0:	eb 01                	jmp    800fd3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fd2:	90                   	nop
	return (void *) s;
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd6:	c9                   	leave  
  800fd7:	c3                   	ret    

00800fd8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fe5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fec:	eb 03                	jmp    800ff1 <strtol+0x19>
		s++;
  800fee:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 20                	cmp    $0x20,%al
  800ff8:	74 f4                	je     800fee <strtol+0x16>
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 09                	cmp    $0x9,%al
  801001:	74 eb                	je     800fee <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 2b                	cmp    $0x2b,%al
  80100a:	75 05                	jne    801011 <strtol+0x39>
		s++;
  80100c:	ff 45 08             	incl   0x8(%ebp)
  80100f:	eb 13                	jmp    801024 <strtol+0x4c>
	else if (*s == '-')
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	3c 2d                	cmp    $0x2d,%al
  801018:	75 0a                	jne    801024 <strtol+0x4c>
		s++, neg = 1;
  80101a:	ff 45 08             	incl   0x8(%ebp)
  80101d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801024:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801028:	74 06                	je     801030 <strtol+0x58>
  80102a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80102e:	75 20                	jne    801050 <strtol+0x78>
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 30                	cmp    $0x30,%al
  801037:	75 17                	jne    801050 <strtol+0x78>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	40                   	inc    %eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 78                	cmp    $0x78,%al
  801041:	75 0d                	jne    801050 <strtol+0x78>
		s += 2, base = 16;
  801043:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801047:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80104e:	eb 28                	jmp    801078 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801050:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801054:	75 15                	jne    80106b <strtol+0x93>
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8a 00                	mov    (%eax),%al
  80105b:	3c 30                	cmp    $0x30,%al
  80105d:	75 0c                	jne    80106b <strtol+0x93>
		s++, base = 8;
  80105f:	ff 45 08             	incl   0x8(%ebp)
  801062:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801069:	eb 0d                	jmp    801078 <strtol+0xa0>
	else if (base == 0)
  80106b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80106f:	75 07                	jne    801078 <strtol+0xa0>
		base = 10;
  801071:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8a 00                	mov    (%eax),%al
  80107d:	3c 2f                	cmp    $0x2f,%al
  80107f:	7e 19                	jle    80109a <strtol+0xc2>
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	8a 00                	mov    (%eax),%al
  801086:	3c 39                	cmp    $0x39,%al
  801088:	7f 10                	jg     80109a <strtol+0xc2>
			dig = *s - '0';
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	0f be c0             	movsbl %al,%eax
  801092:	83 e8 30             	sub    $0x30,%eax
  801095:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801098:	eb 42                	jmp    8010dc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	3c 60                	cmp    $0x60,%al
  8010a1:	7e 19                	jle    8010bc <strtol+0xe4>
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 7a                	cmp    $0x7a,%al
  8010aa:	7f 10                	jg     8010bc <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	0f be c0             	movsbl %al,%eax
  8010b4:	83 e8 57             	sub    $0x57,%eax
  8010b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ba:	eb 20                	jmp    8010dc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	8a 00                	mov    (%eax),%al
  8010c1:	3c 40                	cmp    $0x40,%al
  8010c3:	7e 39                	jle    8010fe <strtol+0x126>
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8a 00                	mov    (%eax),%al
  8010ca:	3c 5a                	cmp    $0x5a,%al
  8010cc:	7f 30                	jg     8010fe <strtol+0x126>
			dig = *s - 'A' + 10;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	8a 00                	mov    (%eax),%al
  8010d3:	0f be c0             	movsbl %al,%eax
  8010d6:	83 e8 37             	sub    $0x37,%eax
  8010d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010df:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010e2:	7d 19                	jge    8010fd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010e4:	ff 45 08             	incl   0x8(%ebp)
  8010e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ea:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010f8:	e9 7b ff ff ff       	jmp    801078 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010fd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801102:	74 08                	je     80110c <strtol+0x134>
		*endptr = (char *) s;
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	8b 55 08             	mov    0x8(%ebp),%edx
  80110a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80110c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801110:	74 07                	je     801119 <strtol+0x141>
  801112:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801115:	f7 d8                	neg    %eax
  801117:	eb 03                	jmp    80111c <strtol+0x144>
  801119:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80111c:	c9                   	leave  
  80111d:	c3                   	ret    

0080111e <ltostr>:

void
ltostr(long value, char *str)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801124:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80112b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801132:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801136:	79 13                	jns    80114b <ltostr+0x2d>
	{
		neg = 1;
  801138:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801145:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801148:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801153:	99                   	cltd   
  801154:	f7 f9                	idiv   %ecx
  801156:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801159:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115c:	8d 50 01             	lea    0x1(%eax),%edx
  80115f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801162:	89 c2                	mov    %eax,%edx
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	01 d0                	add    %edx,%eax
  801169:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80116c:	83 c2 30             	add    $0x30,%edx
  80116f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801171:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801174:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801179:	f7 e9                	imul   %ecx
  80117b:	c1 fa 02             	sar    $0x2,%edx
  80117e:	89 c8                	mov    %ecx,%eax
  801180:	c1 f8 1f             	sar    $0x1f,%eax
  801183:	29 c2                	sub    %eax,%edx
  801185:	89 d0                	mov    %edx,%eax
  801187:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80118a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80118d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801192:	f7 e9                	imul   %ecx
  801194:	c1 fa 02             	sar    $0x2,%edx
  801197:	89 c8                	mov    %ecx,%eax
  801199:	c1 f8 1f             	sar    $0x1f,%eax
  80119c:	29 c2                	sub    %eax,%edx
  80119e:	89 d0                	mov    %edx,%eax
  8011a0:	c1 e0 02             	shl    $0x2,%eax
  8011a3:	01 d0                	add    %edx,%eax
  8011a5:	01 c0                	add    %eax,%eax
  8011a7:	29 c1                	sub    %eax,%ecx
  8011a9:	89 ca                	mov    %ecx,%edx
  8011ab:	85 d2                	test   %edx,%edx
  8011ad:	75 9c                	jne    80114b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b9:	48                   	dec    %eax
  8011ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c1:	74 3d                	je     801200 <ltostr+0xe2>
		start = 1 ;
  8011c3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011ca:	eb 34                	jmp    801200 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	01 d0                	add    %edx,%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011df:	01 c2                	add    %eax,%edx
  8011e1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e7:	01 c8                	add    %ecx,%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	01 c2                	add    %eax,%edx
  8011f5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011f8:	88 02                	mov    %al,(%edx)
		start++ ;
  8011fa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011fd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801203:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801206:	7c c4                	jl     8011cc <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801208:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80120b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120e:	01 d0                	add    %edx,%eax
  801210:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801213:	90                   	nop
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80121c:	ff 75 08             	pushl  0x8(%ebp)
  80121f:	e8 54 fa ff ff       	call   800c78 <strlen>
  801224:	83 c4 04             	add    $0x4,%esp
  801227:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80122a:	ff 75 0c             	pushl  0xc(%ebp)
  80122d:	e8 46 fa ff ff       	call   800c78 <strlen>
  801232:	83 c4 04             	add    $0x4,%esp
  801235:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801238:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80123f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801246:	eb 17                	jmp    80125f <strcconcat+0x49>
		final[s] = str1[s] ;
  801248:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80124b:	8b 45 10             	mov    0x10(%ebp),%eax
  80124e:	01 c2                	add    %eax,%edx
  801250:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	01 c8                	add    %ecx,%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80125c:	ff 45 fc             	incl   -0x4(%ebp)
  80125f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801262:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801265:	7c e1                	jl     801248 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801267:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80126e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801275:	eb 1f                	jmp    801296 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801277:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80127a:	8d 50 01             	lea    0x1(%eax),%edx
  80127d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801280:	89 c2                	mov    %eax,%edx
  801282:	8b 45 10             	mov    0x10(%ebp),%eax
  801285:	01 c2                	add    %eax,%edx
  801287:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80128a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128d:	01 c8                	add    %ecx,%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801293:	ff 45 f8             	incl   -0x8(%ebp)
  801296:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801299:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80129c:	7c d9                	jl     801277 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80129e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a4:	01 d0                	add    %edx,%eax
  8012a6:	c6 00 00             	movb   $0x0,(%eax)
}
  8012a9:	90                   	nop
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012af:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012bb:	8b 00                	mov    (%eax),%eax
  8012bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c7:	01 d0                	add    %edx,%eax
  8012c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012cf:	eb 0c                	jmp    8012dd <strsplit+0x31>
			*string++ = 0;
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8d 50 01             	lea    0x1(%eax),%edx
  8012d7:	89 55 08             	mov    %edx,0x8(%ebp)
  8012da:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	8a 00                	mov    (%eax),%al
  8012e2:	84 c0                	test   %al,%al
  8012e4:	74 18                	je     8012fe <strsplit+0x52>
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	0f be c0             	movsbl %al,%eax
  8012ee:	50                   	push   %eax
  8012ef:	ff 75 0c             	pushl  0xc(%ebp)
  8012f2:	e8 13 fb ff ff       	call   800e0a <strchr>
  8012f7:	83 c4 08             	add    $0x8,%esp
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	75 d3                	jne    8012d1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	8a 00                	mov    (%eax),%al
  801303:	84 c0                	test   %al,%al
  801305:	74 5a                	je     801361 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801307:	8b 45 14             	mov    0x14(%ebp),%eax
  80130a:	8b 00                	mov    (%eax),%eax
  80130c:	83 f8 0f             	cmp    $0xf,%eax
  80130f:	75 07                	jne    801318 <strsplit+0x6c>
		{
			return 0;
  801311:	b8 00 00 00 00       	mov    $0x0,%eax
  801316:	eb 66                	jmp    80137e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801318:	8b 45 14             	mov    0x14(%ebp),%eax
  80131b:	8b 00                	mov    (%eax),%eax
  80131d:	8d 48 01             	lea    0x1(%eax),%ecx
  801320:	8b 55 14             	mov    0x14(%ebp),%edx
  801323:	89 0a                	mov    %ecx,(%edx)
  801325:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80132c:	8b 45 10             	mov    0x10(%ebp),%eax
  80132f:	01 c2                	add    %eax,%edx
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801336:	eb 03                	jmp    80133b <strsplit+0x8f>
			string++;
  801338:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	8a 00                	mov    (%eax),%al
  801340:	84 c0                	test   %al,%al
  801342:	74 8b                	je     8012cf <strsplit+0x23>
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	8a 00                	mov    (%eax),%al
  801349:	0f be c0             	movsbl %al,%eax
  80134c:	50                   	push   %eax
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	e8 b5 fa ff ff       	call   800e0a <strchr>
  801355:	83 c4 08             	add    $0x8,%esp
  801358:	85 c0                	test   %eax,%eax
  80135a:	74 dc                	je     801338 <strsplit+0x8c>
			string++;
	}
  80135c:	e9 6e ff ff ff       	jmp    8012cf <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801361:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801362:	8b 45 14             	mov    0x14(%ebp),%eax
  801365:	8b 00                	mov    (%eax),%eax
  801367:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136e:	8b 45 10             	mov    0x10(%ebp),%eax
  801371:	01 d0                	add    %edx,%eax
  801373:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801379:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801386:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  80138d:	8b 55 08             	mov    0x8(%ebp),%edx
  801390:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801393:	01 d0                	add    %edx,%eax
  801395:	48                   	dec    %eax
  801396:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801399:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80139c:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a1:	f7 75 ac             	divl   -0x54(%ebp)
  8013a4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8013a7:	29 d0                	sub    %edx,%eax
  8013a9:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8013ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8013b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8013ba:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8013c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8013c8:	eb 3f                	jmp    801409 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8013ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013cd:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	50                   	push   %eax
  8013d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8013db:	68 d0 28 80 00       	push   $0x8028d0
  8013e0:	e8 11 f2 ff ff       	call   8005f6 <cprintf>
  8013e5:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  8013e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013eb:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8013f2:	83 ec 04             	sub    $0x4,%esp
  8013f5:	50                   	push   %eax
  8013f6:	ff 75 e8             	pushl  -0x18(%ebp)
  8013f9:	68 e5 28 80 00       	push   $0x8028e5
  8013fe:	e8 f3 f1 ff ff       	call   8005f6 <cprintf>
  801403:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801406:	ff 45 e8             	incl   -0x18(%ebp)
  801409:	a1 28 30 80 00       	mov    0x803028,%eax
  80140e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801411:	7c b7                	jl     8013ca <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801413:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  80141a:	e9 42 01 00 00       	jmp    801561 <malloc+0x1e1>
		int flag0=1;
  80141f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801426:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801429:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80142c:	eb 6b                	jmp    801499 <malloc+0x119>
			for(int k=0;k<count;k++){
  80142e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801435:	eb 42                	jmp    801479 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801437:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80143a:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801441:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801444:	39 c2                	cmp    %eax,%edx
  801446:	77 2e                	ja     801476 <malloc+0xf6>
  801448:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80144b:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801452:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801455:	39 c2                	cmp    %eax,%edx
  801457:	76 1d                	jbe    801476 <malloc+0xf6>
					ni=arr_add[k].end-i;
  801459:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80145c:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801466:	29 c2                	sub    %eax,%edx
  801468:	89 d0                	mov    %edx,%eax
  80146a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  80146d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801474:	eb 0d                	jmp    801483 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801476:	ff 45 d8             	incl   -0x28(%ebp)
  801479:	a1 28 30 80 00       	mov    0x803028,%eax
  80147e:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801481:	7c b4                	jl     801437 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801483:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801487:	74 09                	je     801492 <malloc+0x112>
				flag0=0;
  801489:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801490:	eb 16                	jmp    8014a8 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801492:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801499:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	01 c2                	add    %eax,%edx
  8014a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014a4:	39 c2                	cmp    %eax,%edx
  8014a6:	77 86                	ja     80142e <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8014a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014ac:	0f 84 a2 00 00 00    	je     801554 <malloc+0x1d4>

			int f=1;
  8014b2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  8014b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014bc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8014bf:	89 c8                	mov    %ecx,%eax
  8014c1:	01 c0                	add    %eax,%eax
  8014c3:	01 c8                	add    %ecx,%eax
  8014c5:	c1 e0 02             	shl    $0x2,%eax
  8014c8:	05 20 31 80 00       	add    $0x803120,%eax
  8014cd:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  8014cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8014d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014db:	89 d0                	mov    %edx,%eax
  8014dd:	01 c0                	add    %eax,%eax
  8014df:	01 d0                	add    %edx,%eax
  8014e1:	c1 e0 02             	shl    $0x2,%eax
  8014e4:	05 24 31 80 00       	add    $0x803124,%eax
  8014e9:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  8014eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ee:	89 d0                	mov    %edx,%eax
  8014f0:	01 c0                	add    %eax,%eax
  8014f2:	01 d0                	add    %edx,%eax
  8014f4:	c1 e0 02             	shl    $0x2,%eax
  8014f7:	05 28 31 80 00       	add    $0x803128,%eax
  8014fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801502:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801505:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80150c:	eb 36                	jmp    801544 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  80150e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	01 c2                	add    %eax,%edx
  801516:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801519:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801520:	39 c2                	cmp    %eax,%edx
  801522:	73 1d                	jae    801541 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801524:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801527:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80152e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801531:	29 c2                	sub    %eax,%edx
  801533:	89 d0                	mov    %edx,%eax
  801535:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801538:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  80153f:	eb 0d                	jmp    80154e <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801541:	ff 45 d0             	incl   -0x30(%ebp)
  801544:	a1 28 30 80 00       	mov    0x803028,%eax
  801549:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  80154c:	7c c0                	jl     80150e <malloc+0x18e>
					break;

				}
			}

			if(f){
  80154e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801552:	75 1d                	jne    801571 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801554:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  80155b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80155e:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801561:	a1 04 30 80 00       	mov    0x803004,%eax
  801566:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801569:	0f 8c b0 fe ff ff    	jl     80141f <malloc+0x9f>
  80156f:	eb 01                	jmp    801572 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801571:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801572:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801576:	75 7a                	jne    8015f2 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801578:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	01 d0                	add    %edx,%eax
  801583:	48                   	dec    %eax
  801584:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801589:	7c 0a                	jl     801595 <malloc+0x215>
			return NULL;
  80158b:	b8 00 00 00 00       	mov    $0x0,%eax
  801590:	e9 a4 02 00 00       	jmp    801839 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801595:	a1 04 30 80 00       	mov    0x803004,%eax
  80159a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  80159d:	a1 28 30 80 00       	mov    0x803028,%eax
  8015a2:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8015a5:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  8015ac:	83 ec 08             	sub    $0x8,%esp
  8015af:	ff 75 08             	pushl  0x8(%ebp)
  8015b2:	ff 75 a4             	pushl  -0x5c(%ebp)
  8015b5:	e8 04 06 00 00       	call   801bbe <sys_allocateMem>
  8015ba:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  8015bd:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	01 d0                	add    %edx,%eax
  8015c8:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  8015cd:	a1 28 30 80 00       	mov    0x803028,%eax
  8015d2:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015d8:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  8015df:	a1 28 30 80 00       	mov    0x803028,%eax
  8015e4:	40                   	inc    %eax
  8015e5:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  8015ea:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8015ed:	e9 47 02 00 00       	jmp    801839 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  8015f2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8015f9:	e9 ac 00 00 00       	jmp    8016aa <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8015fe:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801601:	89 d0                	mov    %edx,%eax
  801603:	01 c0                	add    %eax,%eax
  801605:	01 d0                	add    %edx,%eax
  801607:	c1 e0 02             	shl    $0x2,%eax
  80160a:	05 24 31 80 00       	add    $0x803124,%eax
  80160f:	8b 00                	mov    (%eax),%eax
  801611:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801614:	eb 7e                	jmp    801694 <malloc+0x314>
			int flag=0;
  801616:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  80161d:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801624:	eb 57                	jmp    80167d <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801626:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801629:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801630:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801633:	39 c2                	cmp    %eax,%edx
  801635:	77 1a                	ja     801651 <malloc+0x2d1>
  801637:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80163a:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801641:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801644:	39 c2                	cmp    %eax,%edx
  801646:	76 09                	jbe    801651 <malloc+0x2d1>
								flag=1;
  801648:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  80164f:	eb 36                	jmp    801687 <malloc+0x307>
			arr[i].space++;
  801651:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801654:	89 d0                	mov    %edx,%eax
  801656:	01 c0                	add    %eax,%eax
  801658:	01 d0                	add    %edx,%eax
  80165a:	c1 e0 02             	shl    $0x2,%eax
  80165d:	05 28 31 80 00       	add    $0x803128,%eax
  801662:	8b 00                	mov    (%eax),%eax
  801664:	8d 48 01             	lea    0x1(%eax),%ecx
  801667:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80166a:	89 d0                	mov    %edx,%eax
  80166c:	01 c0                	add    %eax,%eax
  80166e:	01 d0                	add    %edx,%eax
  801670:	c1 e0 02             	shl    $0x2,%eax
  801673:	05 28 31 80 00       	add    $0x803128,%eax
  801678:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  80167a:	ff 45 c0             	incl   -0x40(%ebp)
  80167d:	a1 28 30 80 00       	mov    0x803028,%eax
  801682:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801685:	7c 9f                	jl     801626 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801687:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80168b:	75 19                	jne    8016a6 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  80168d:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801694:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801697:	a1 04 30 80 00       	mov    0x803004,%eax
  80169c:	39 c2                	cmp    %eax,%edx
  80169e:	0f 82 72 ff ff ff    	jb     801616 <malloc+0x296>
  8016a4:	eb 01                	jmp    8016a7 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  8016a6:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  8016a7:	ff 45 cc             	incl   -0x34(%ebp)
  8016aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8016ad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016b0:	0f 8c 48 ff ff ff    	jl     8015fe <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  8016b6:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  8016bd:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  8016c4:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  8016cb:	eb 37                	jmp    801704 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  8016cd:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8016d0:	89 d0                	mov    %edx,%eax
  8016d2:	01 c0                	add    %eax,%eax
  8016d4:	01 d0                	add    %edx,%eax
  8016d6:	c1 e0 02             	shl    $0x2,%eax
  8016d9:	05 28 31 80 00       	add    $0x803128,%eax
  8016de:	8b 00                	mov    (%eax),%eax
  8016e0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8016e3:	7d 1c                	jge    801701 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  8016e5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8016e8:	89 d0                	mov    %edx,%eax
  8016ea:	01 c0                	add    %eax,%eax
  8016ec:	01 d0                	add    %edx,%eax
  8016ee:	c1 e0 02             	shl    $0x2,%eax
  8016f1:	05 28 31 80 00       	add    $0x803128,%eax
  8016f6:	8b 00                	mov    (%eax),%eax
  8016f8:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  8016fb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8016fe:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801701:	ff 45 b4             	incl   -0x4c(%ebp)
  801704:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801707:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80170a:	7c c1                	jl     8016cd <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  80170c:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801712:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801715:	89 c8                	mov    %ecx,%eax
  801717:	01 c0                	add    %eax,%eax
  801719:	01 c8                	add    %ecx,%eax
  80171b:	c1 e0 02             	shl    $0x2,%eax
  80171e:	05 20 31 80 00       	add    $0x803120,%eax
  801723:	8b 00                	mov    (%eax),%eax
  801725:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  80172c:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801732:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801735:	89 c8                	mov    %ecx,%eax
  801737:	01 c0                	add    %eax,%eax
  801739:	01 c8                	add    %ecx,%eax
  80173b:	c1 e0 02             	shl    $0x2,%eax
  80173e:	05 24 31 80 00       	add    $0x803124,%eax
  801743:	8b 00                	mov    (%eax),%eax
  801745:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  80174c:	a1 28 30 80 00       	mov    0x803028,%eax
  801751:	40                   	inc    %eax
  801752:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  801757:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80175a:	89 d0                	mov    %edx,%eax
  80175c:	01 c0                	add    %eax,%eax
  80175e:	01 d0                	add    %edx,%eax
  801760:	c1 e0 02             	shl    $0x2,%eax
  801763:	05 20 31 80 00       	add    $0x803120,%eax
  801768:	8b 00                	mov    (%eax),%eax
  80176a:	83 ec 08             	sub    $0x8,%esp
  80176d:	ff 75 08             	pushl  0x8(%ebp)
  801770:	50                   	push   %eax
  801771:	e8 48 04 00 00       	call   801bbe <sys_allocateMem>
  801776:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801779:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801780:	eb 78                	jmp    8017fa <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801782:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801785:	89 d0                	mov    %edx,%eax
  801787:	01 c0                	add    %eax,%eax
  801789:	01 d0                	add    %edx,%eax
  80178b:	c1 e0 02             	shl    $0x2,%eax
  80178e:	05 20 31 80 00       	add    $0x803120,%eax
  801793:	8b 00                	mov    (%eax),%eax
  801795:	83 ec 04             	sub    $0x4,%esp
  801798:	50                   	push   %eax
  801799:	ff 75 b0             	pushl  -0x50(%ebp)
  80179c:	68 d0 28 80 00       	push   $0x8028d0
  8017a1:	e8 50 ee ff ff       	call   8005f6 <cprintf>
  8017a6:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8017a9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8017ac:	89 d0                	mov    %edx,%eax
  8017ae:	01 c0                	add    %eax,%eax
  8017b0:	01 d0                	add    %edx,%eax
  8017b2:	c1 e0 02             	shl    $0x2,%eax
  8017b5:	05 24 31 80 00       	add    $0x803124,%eax
  8017ba:	8b 00                	mov    (%eax),%eax
  8017bc:	83 ec 04             	sub    $0x4,%esp
  8017bf:	50                   	push   %eax
  8017c0:	ff 75 b0             	pushl  -0x50(%ebp)
  8017c3:	68 e5 28 80 00       	push   $0x8028e5
  8017c8:	e8 29 ee ff ff       	call   8005f6 <cprintf>
  8017cd:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  8017d0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8017d3:	89 d0                	mov    %edx,%eax
  8017d5:	01 c0                	add    %eax,%eax
  8017d7:	01 d0                	add    %edx,%eax
  8017d9:	c1 e0 02             	shl    $0x2,%eax
  8017dc:	05 28 31 80 00       	add    $0x803128,%eax
  8017e1:	8b 00                	mov    (%eax),%eax
  8017e3:	83 ec 04             	sub    $0x4,%esp
  8017e6:	50                   	push   %eax
  8017e7:	ff 75 b0             	pushl  -0x50(%ebp)
  8017ea:	68 f8 28 80 00       	push   $0x8028f8
  8017ef:	e8 02 ee ff ff       	call   8005f6 <cprintf>
  8017f4:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  8017f7:	ff 45 b0             	incl   -0x50(%ebp)
  8017fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8017fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801800:	7c 80                	jl     801782 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801802:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801805:	89 d0                	mov    %edx,%eax
  801807:	01 c0                	add    %eax,%eax
  801809:	01 d0                	add    %edx,%eax
  80180b:	c1 e0 02             	shl    $0x2,%eax
  80180e:	05 20 31 80 00       	add    $0x803120,%eax
  801813:	8b 00                	mov    (%eax),%eax
  801815:	83 ec 08             	sub    $0x8,%esp
  801818:	50                   	push   %eax
  801819:	68 0c 29 80 00       	push   $0x80290c
  80181e:	e8 d3 ed ff ff       	call   8005f6 <cprintf>
  801823:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801826:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801829:	89 d0                	mov    %edx,%eax
  80182b:	01 c0                	add    %eax,%eax
  80182d:	01 d0                	add    %edx,%eax
  80182f:	c1 e0 02             	shl    $0x2,%eax
  801832:	05 20 31 80 00       	add    $0x803120,%eax
  801837:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801847:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80184e:	eb 4b                	jmp    80189b <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801853:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80185a:	89 c2                	mov    %eax,%edx
  80185c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80185f:	39 c2                	cmp    %eax,%edx
  801861:	7f 35                	jg     801898 <free+0x5d>
  801863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801866:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  80186d:	89 c2                	mov    %eax,%edx
  80186f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801872:	39 c2                	cmp    %eax,%edx
  801874:	7e 22                	jle    801898 <free+0x5d>
				start=arr_add[i].start;
  801876:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801879:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801880:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801883:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801886:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  80188d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801890:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801893:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801896:	eb 0d                	jmp    8018a5 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801898:	ff 45 ec             	incl   -0x14(%ebp)
  80189b:	a1 28 30 80 00       	mov    0x803028,%eax
  8018a0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8018a3:	7c ab                	jl     801850 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8018a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a8:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8018af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b2:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8018b9:	29 c2                	sub    %eax,%edx
  8018bb:	89 d0                	mov    %edx,%eax
  8018bd:	83 ec 08             	sub    $0x8,%esp
  8018c0:	50                   	push   %eax
  8018c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c4:	e8 d9 02 00 00       	call   801ba2 <sys_freeMem>
  8018c9:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  8018cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018d2:	eb 2d                	jmp    801901 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  8018d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d7:	40                   	inc    %eax
  8018d8:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8018df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018e2:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  8018e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ec:	40                   	inc    %eax
  8018ed:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8018f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f7:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  8018fe:	ff 45 e8             	incl   -0x18(%ebp)
  801901:	a1 28 30 80 00       	mov    0x803028,%eax
  801906:	48                   	dec    %eax
  801907:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80190a:	7f c8                	jg     8018d4 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  80190c:	a1 28 30 80 00       	mov    0x803028,%eax
  801911:	48                   	dec    %eax
  801912:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801917:	90                   	nop
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 18             	sub    $0x18,%esp
  801920:	8b 45 10             	mov    0x10(%ebp),%eax
  801923:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	68 28 29 80 00       	push   $0x802928
  80192e:	68 18 01 00 00       	push   $0x118
  801933:	68 4b 29 80 00       	push   $0x80294b
  801938:	e8 0b 07 00 00       	call   802048 <_panic>

0080193d <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801943:	83 ec 04             	sub    $0x4,%esp
  801946:	68 28 29 80 00       	push   $0x802928
  80194b:	68 1e 01 00 00       	push   $0x11e
  801950:	68 4b 29 80 00       	push   $0x80294b
  801955:	e8 ee 06 00 00       	call   802048 <_panic>

0080195a <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801960:	83 ec 04             	sub    $0x4,%esp
  801963:	68 28 29 80 00       	push   $0x802928
  801968:	68 24 01 00 00       	push   $0x124
  80196d:	68 4b 29 80 00       	push   $0x80294b
  801972:	e8 d1 06 00 00       	call   802048 <_panic>

00801977 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80197d:	83 ec 04             	sub    $0x4,%esp
  801980:	68 28 29 80 00       	push   $0x802928
  801985:	68 29 01 00 00       	push   $0x129
  80198a:	68 4b 29 80 00       	push   $0x80294b
  80198f:	e8 b4 06 00 00       	call   802048 <_panic>

00801994 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80199a:	83 ec 04             	sub    $0x4,%esp
  80199d:	68 28 29 80 00       	push   $0x802928
  8019a2:	68 2f 01 00 00       	push   $0x12f
  8019a7:	68 4b 29 80 00       	push   $0x80294b
  8019ac:	e8 97 06 00 00       	call   802048 <_panic>

008019b1 <shrink>:
}
void shrink(uint32 newSize)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	68 28 29 80 00       	push   $0x802928
  8019bf:	68 33 01 00 00       	push   $0x133
  8019c4:	68 4b 29 80 00       	push   $0x80294b
  8019c9:	e8 7a 06 00 00       	call   802048 <_panic>

008019ce <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019d4:	83 ec 04             	sub    $0x4,%esp
  8019d7:	68 28 29 80 00       	push   $0x802928
  8019dc:	68 38 01 00 00       	push   $0x138
  8019e1:	68 4b 29 80 00       	push   $0x80294b
  8019e6:	e8 5d 06 00 00       	call   802048 <_panic>

008019eb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	57                   	push   %edi
  8019ef:	56                   	push   %esi
  8019f0:	53                   	push   %ebx
  8019f1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a00:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a03:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a06:	cd 30                	int    $0x30
  801a08:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a0e:	83 c4 10             	add    $0x10,%esp
  801a11:	5b                   	pop    %ebx
  801a12:	5e                   	pop    %esi
  801a13:	5f                   	pop    %edi
  801a14:	5d                   	pop    %ebp
  801a15:	c3                   	ret    

00801a16 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 04             	sub    $0x4,%esp
  801a1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a22:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a26:	8b 45 08             	mov    0x8(%ebp),%eax
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	52                   	push   %edx
  801a2e:	ff 75 0c             	pushl  0xc(%ebp)
  801a31:	50                   	push   %eax
  801a32:	6a 00                	push   $0x0
  801a34:	e8 b2 ff ff ff       	call   8019eb <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	90                   	nop
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_cgetc>:

int
sys_cgetc(void)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 01                	push   $0x1
  801a4e:	e8 98 ff ff ff       	call   8019eb <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	50                   	push   %eax
  801a67:	6a 05                	push   $0x5
  801a69:	e8 7d ff ff ff       	call   8019eb <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 02                	push   $0x2
  801a82:	e8 64 ff ff ff       	call   8019eb <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 03                	push   $0x3
  801a9b:	e8 4b ff ff ff       	call   8019eb <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 04                	push   $0x4
  801ab4:	e8 32 ff ff ff       	call   8019eb <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_env_exit>:


void sys_env_exit(void)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 06                	push   $0x6
  801acd:	e8 19 ff ff ff       	call   8019eb <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	90                   	nop
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	52                   	push   %edx
  801ae8:	50                   	push   %eax
  801ae9:	6a 07                	push   $0x7
  801aeb:	e8 fb fe ff ff       	call   8019eb <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	56                   	push   %esi
  801af9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801afa:	8b 75 18             	mov    0x18(%ebp),%esi
  801afd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	56                   	push   %esi
  801b0a:	53                   	push   %ebx
  801b0b:	51                   	push   %ecx
  801b0c:	52                   	push   %edx
  801b0d:	50                   	push   %eax
  801b0e:	6a 08                	push   $0x8
  801b10:	e8 d6 fe ff ff       	call   8019eb <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1b:	5b                   	pop    %ebx
  801b1c:	5e                   	pop    %esi
  801b1d:	5d                   	pop    %ebp
  801b1e:	c3                   	ret    

00801b1f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	52                   	push   %edx
  801b2f:	50                   	push   %eax
  801b30:	6a 09                	push   $0x9
  801b32:	e8 b4 fe ff ff       	call   8019eb <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	ff 75 08             	pushl  0x8(%ebp)
  801b4b:	6a 0a                	push   $0xa
  801b4d:	e8 99 fe ff ff       	call   8019eb <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 0b                	push   $0xb
  801b66:	e8 80 fe ff ff       	call   8019eb <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 0c                	push   $0xc
  801b7f:	e8 67 fe ff ff       	call   8019eb <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 0d                	push   $0xd
  801b98:	e8 4e fe ff ff       	call   8019eb <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	ff 75 0c             	pushl  0xc(%ebp)
  801bae:	ff 75 08             	pushl  0x8(%ebp)
  801bb1:	6a 11                	push   $0x11
  801bb3:	e8 33 fe ff ff       	call   8019eb <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
	return;
  801bbb:	90                   	nop
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	ff 75 0c             	pushl  0xc(%ebp)
  801bca:	ff 75 08             	pushl  0x8(%ebp)
  801bcd:	6a 12                	push   $0x12
  801bcf:	e8 17 fe ff ff       	call   8019eb <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd7:	90                   	nop
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 0e                	push   $0xe
  801be9:	e8 fd fd ff ff       	call   8019eb <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	ff 75 08             	pushl  0x8(%ebp)
  801c01:	6a 0f                	push   $0xf
  801c03:	e8 e3 fd ff ff       	call   8019eb <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 10                	push   $0x10
  801c1c:	e8 ca fd ff ff       	call   8019eb <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
}
  801c24:	90                   	nop
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 14                	push   $0x14
  801c36:	e8 b0 fd ff ff       	call   8019eb <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
}
  801c3e:	90                   	nop
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 15                	push   $0x15
  801c50:	e8 96 fd ff ff       	call   8019eb <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	90                   	nop
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_cputc>:


void
sys_cputc(const char c)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 04             	sub    $0x4,%esp
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c67:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	50                   	push   %eax
  801c74:	6a 16                	push   $0x16
  801c76:	e8 70 fd ff ff       	call   8019eb <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	90                   	nop
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 17                	push   $0x17
  801c90:	e8 56 fd ff ff       	call   8019eb <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	90                   	nop
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	ff 75 0c             	pushl  0xc(%ebp)
  801caa:	50                   	push   %eax
  801cab:	6a 18                	push   $0x18
  801cad:	e8 39 fd ff ff       	call   8019eb <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	52                   	push   %edx
  801cc7:	50                   	push   %eax
  801cc8:	6a 1b                	push   $0x1b
  801cca:	e8 1c fd ff ff       	call   8019eb <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	52                   	push   %edx
  801ce4:	50                   	push   %eax
  801ce5:	6a 19                	push   $0x19
  801ce7:	e8 ff fc ff ff       	call   8019eb <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	90                   	nop
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	52                   	push   %edx
  801d02:	50                   	push   %eax
  801d03:	6a 1a                	push   $0x1a
  801d05:	e8 e1 fc ff ff       	call   8019eb <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	90                   	nop
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 04             	sub    $0x4,%esp
  801d16:	8b 45 10             	mov    0x10(%ebp),%eax
  801d19:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d1c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d1f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	6a 00                	push   $0x0
  801d28:	51                   	push   %ecx
  801d29:	52                   	push   %edx
  801d2a:	ff 75 0c             	pushl  0xc(%ebp)
  801d2d:	50                   	push   %eax
  801d2e:	6a 1c                	push   $0x1c
  801d30:	e8 b6 fc ff ff       	call   8019eb <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d40:	8b 45 08             	mov    0x8(%ebp),%eax
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	52                   	push   %edx
  801d4a:	50                   	push   %eax
  801d4b:	6a 1d                	push   $0x1d
  801d4d:	e8 99 fc ff ff       	call   8019eb <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	51                   	push   %ecx
  801d68:	52                   	push   %edx
  801d69:	50                   	push   %eax
  801d6a:	6a 1e                	push   $0x1e
  801d6c:	e8 7a fc ff ff       	call   8019eb <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	52                   	push   %edx
  801d86:	50                   	push   %eax
  801d87:	6a 1f                	push   $0x1f
  801d89:	e8 5d fc ff ff       	call   8019eb <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 20                	push   $0x20
  801da2:	e8 44 fc ff ff       	call   8019eb <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	6a 00                	push   $0x0
  801db4:	ff 75 14             	pushl  0x14(%ebp)
  801db7:	ff 75 10             	pushl  0x10(%ebp)
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	50                   	push   %eax
  801dbe:	6a 21                	push   $0x21
  801dc0:	e8 26 fc ff ff       	call   8019eb <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	50                   	push   %eax
  801dd9:	6a 22                	push   $0x22
  801ddb:	e8 0b fc ff ff       	call   8019eb <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
}
  801de3:	90                   	nop
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	50                   	push   %eax
  801df5:	6a 23                	push   $0x23
  801df7:	e8 ef fb ff ff       	call   8019eb <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
}
  801dff:	90                   	nop
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e08:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e0b:	8d 50 04             	lea    0x4(%eax),%edx
  801e0e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	52                   	push   %edx
  801e18:	50                   	push   %eax
  801e19:	6a 24                	push   $0x24
  801e1b:	e8 cb fb ff ff       	call   8019eb <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
	return result;
  801e23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e2c:	89 01                	mov    %eax,(%ecx)
  801e2e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	c9                   	leave  
  801e35:	c2 04 00             	ret    $0x4

00801e38 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	ff 75 10             	pushl  0x10(%ebp)
  801e42:	ff 75 0c             	pushl  0xc(%ebp)
  801e45:	ff 75 08             	pushl  0x8(%ebp)
  801e48:	6a 13                	push   $0x13
  801e4a:	e8 9c fb ff ff       	call   8019eb <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e52:	90                   	nop
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 25                	push   $0x25
  801e64:	e8 82 fb ff ff       	call   8019eb <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 04             	sub    $0x4,%esp
  801e74:	8b 45 08             	mov    0x8(%ebp),%eax
  801e77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e7a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	50                   	push   %eax
  801e87:	6a 26                	push   $0x26
  801e89:	e8 5d fb ff ff       	call   8019eb <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e91:	90                   	nop
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <rsttst>:
void rsttst()
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 28                	push   $0x28
  801ea3:	e8 43 fb ff ff       	call   8019eb <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
	return ;
  801eab:	90                   	nop
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	83 ec 04             	sub    $0x4,%esp
  801eb4:	8b 45 14             	mov    0x14(%ebp),%eax
  801eb7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801eba:	8b 55 18             	mov    0x18(%ebp),%edx
  801ebd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ec1:	52                   	push   %edx
  801ec2:	50                   	push   %eax
  801ec3:	ff 75 10             	pushl  0x10(%ebp)
  801ec6:	ff 75 0c             	pushl  0xc(%ebp)
  801ec9:	ff 75 08             	pushl  0x8(%ebp)
  801ecc:	6a 27                	push   $0x27
  801ece:	e8 18 fb ff ff       	call   8019eb <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed6:	90                   	nop
}
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <chktst>:
void chktst(uint32 n)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	ff 75 08             	pushl  0x8(%ebp)
  801ee7:	6a 29                	push   $0x29
  801ee9:	e8 fd fa ff ff       	call   8019eb <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef1:	90                   	nop
}
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <inctst>:

void inctst()
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 2a                	push   $0x2a
  801f03:	e8 e3 fa ff ff       	call   8019eb <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0b:	90                   	nop
}
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <gettst>:
uint32 gettst()
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 2b                	push   $0x2b
  801f1d:	e8 c9 fa ff ff       	call   8019eb <syscall>
  801f22:	83 c4 18             	add    $0x18,%esp
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 2c                	push   $0x2c
  801f39:	e8 ad fa ff ff       	call   8019eb <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
  801f41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f44:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f48:	75 07                	jne    801f51 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4f:	eb 05                	jmp    801f56 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 2c                	push   $0x2c
  801f6a:	e8 7c fa ff ff       	call   8019eb <syscall>
  801f6f:	83 c4 18             	add    $0x18,%esp
  801f72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f75:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f79:	75 07                	jne    801f82 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f7b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f80:	eb 05                	jmp    801f87 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 2c                	push   $0x2c
  801f9b:	e8 4b fa ff ff       	call   8019eb <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
  801fa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fa6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801faa:	75 07                	jne    801fb3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fac:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb1:	eb 05                	jmp    801fb8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 2c                	push   $0x2c
  801fcc:	e8 1a fa ff ff       	call   8019eb <syscall>
  801fd1:	83 c4 18             	add    $0x18,%esp
  801fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fd7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fdb:	75 07                	jne    801fe4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fdd:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe2:	eb 05                	jmp    801fe9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fe4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	ff 75 08             	pushl  0x8(%ebp)
  801ff9:	6a 2d                	push   $0x2d
  801ffb:	e8 eb f9 ff ff       	call   8019eb <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
	return ;
  802003:	90                   	nop
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80200a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80200d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802010:	8b 55 0c             	mov    0xc(%ebp),%edx
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	6a 00                	push   $0x0
  802018:	53                   	push   %ebx
  802019:	51                   	push   %ecx
  80201a:	52                   	push   %edx
  80201b:	50                   	push   %eax
  80201c:	6a 2e                	push   $0x2e
  80201e:	e8 c8 f9 ff ff       	call   8019eb <syscall>
  802023:	83 c4 18             	add    $0x18,%esp
}
  802026:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80202e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	52                   	push   %edx
  80203b:	50                   	push   %eax
  80203c:	6a 2f                	push   $0x2f
  80203e:	e8 a8 f9 ff ff       	call   8019eb <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80204e:	8d 45 10             	lea    0x10(%ebp),%eax
  802051:	83 c0 04             	add    $0x4,%eax
  802054:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802057:	a1 60 3e 83 00       	mov    0x833e60,%eax
  80205c:	85 c0                	test   %eax,%eax
  80205e:	74 16                	je     802076 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802060:	a1 60 3e 83 00       	mov    0x833e60,%eax
  802065:	83 ec 08             	sub    $0x8,%esp
  802068:	50                   	push   %eax
  802069:	68 58 29 80 00       	push   $0x802958
  80206e:	e8 83 e5 ff ff       	call   8005f6 <cprintf>
  802073:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802076:	a1 00 30 80 00       	mov    0x803000,%eax
  80207b:	ff 75 0c             	pushl  0xc(%ebp)
  80207e:	ff 75 08             	pushl  0x8(%ebp)
  802081:	50                   	push   %eax
  802082:	68 5d 29 80 00       	push   $0x80295d
  802087:	e8 6a e5 ff ff       	call   8005f6 <cprintf>
  80208c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80208f:	8b 45 10             	mov    0x10(%ebp),%eax
  802092:	83 ec 08             	sub    $0x8,%esp
  802095:	ff 75 f4             	pushl  -0xc(%ebp)
  802098:	50                   	push   %eax
  802099:	e8 ed e4 ff ff       	call   80058b <vcprintf>
  80209e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8020a1:	83 ec 08             	sub    $0x8,%esp
  8020a4:	6a 00                	push   $0x0
  8020a6:	68 79 29 80 00       	push   $0x802979
  8020ab:	e8 db e4 ff ff       	call   80058b <vcprintf>
  8020b0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8020b3:	e8 5c e4 ff ff       	call   800514 <exit>

	// should not return here
	while (1) ;
  8020b8:	eb fe                	jmp    8020b8 <_panic+0x70>

008020ba <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8020c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8020c5:	8b 50 74             	mov    0x74(%eax),%edx
  8020c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cb:	39 c2                	cmp    %eax,%edx
  8020cd:	74 14                	je     8020e3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8020cf:	83 ec 04             	sub    $0x4,%esp
  8020d2:	68 7c 29 80 00       	push   $0x80297c
  8020d7:	6a 26                	push   $0x26
  8020d9:	68 c8 29 80 00       	push   $0x8029c8
  8020de:	e8 65 ff ff ff       	call   802048 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8020e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8020ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8020f1:	e9 b6 00 00 00       	jmp    8021ac <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8020f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	01 d0                	add    %edx,%eax
  802105:	8b 00                	mov    (%eax),%eax
  802107:	85 c0                	test   %eax,%eax
  802109:	75 08                	jne    802113 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80210b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80210e:	e9 96 00 00 00       	jmp    8021a9 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  802113:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80211a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802121:	eb 5d                	jmp    802180 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802123:	a1 20 30 80 00       	mov    0x803020,%eax
  802128:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80212e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802131:	c1 e2 04             	shl    $0x4,%edx
  802134:	01 d0                	add    %edx,%eax
  802136:	8a 40 04             	mov    0x4(%eax),%al
  802139:	84 c0                	test   %al,%al
  80213b:	75 40                	jne    80217d <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80213d:	a1 20 30 80 00       	mov    0x803020,%eax
  802142:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802148:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80214b:	c1 e2 04             	shl    $0x4,%edx
  80214e:	01 d0                	add    %edx,%eax
  802150:	8b 00                	mov    (%eax),%eax
  802152:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802155:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802158:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80215d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80215f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802162:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	01 c8                	add    %ecx,%eax
  80216e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802170:	39 c2                	cmp    %eax,%edx
  802172:	75 09                	jne    80217d <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  802174:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80217b:	eb 12                	jmp    80218f <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80217d:	ff 45 e8             	incl   -0x18(%ebp)
  802180:	a1 20 30 80 00       	mov    0x803020,%eax
  802185:	8b 50 74             	mov    0x74(%eax),%edx
  802188:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80218b:	39 c2                	cmp    %eax,%edx
  80218d:	77 94                	ja     802123 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80218f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802193:	75 14                	jne    8021a9 <CheckWSWithoutLastIndex+0xef>
			panic(
  802195:	83 ec 04             	sub    $0x4,%esp
  802198:	68 d4 29 80 00       	push   $0x8029d4
  80219d:	6a 3a                	push   $0x3a
  80219f:	68 c8 29 80 00       	push   $0x8029c8
  8021a4:	e8 9f fe ff ff       	call   802048 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8021a9:	ff 45 f0             	incl   -0x10(%ebp)
  8021ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021b2:	0f 8c 3e ff ff ff    	jl     8020f6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8021b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8021bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8021c6:	eb 20                	jmp    8021e8 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8021c8:	a1 20 30 80 00       	mov    0x803020,%eax
  8021cd:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8021d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021d6:	c1 e2 04             	shl    $0x4,%edx
  8021d9:	01 d0                	add    %edx,%eax
  8021db:	8a 40 04             	mov    0x4(%eax),%al
  8021de:	3c 01                	cmp    $0x1,%al
  8021e0:	75 03                	jne    8021e5 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8021e2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8021e5:	ff 45 e0             	incl   -0x20(%ebp)
  8021e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8021ed:	8b 50 74             	mov    0x74(%eax),%edx
  8021f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021f3:	39 c2                	cmp    %eax,%edx
  8021f5:	77 d1                	ja     8021c8 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8021f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fa:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8021fd:	74 14                	je     802213 <CheckWSWithoutLastIndex+0x159>
		panic(
  8021ff:	83 ec 04             	sub    $0x4,%esp
  802202:	68 28 2a 80 00       	push   $0x802a28
  802207:	6a 44                	push   $0x44
  802209:	68 c8 29 80 00       	push   $0x8029c8
  80220e:	e8 35 fe ff ff       	call   802048 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802213:	90                   	nop
  802214:	c9                   	leave  
  802215:	c3                   	ret    
  802216:	66 90                	xchg   %ax,%ax

00802218 <__udivdi3>:
  802218:	55                   	push   %ebp
  802219:	57                   	push   %edi
  80221a:	56                   	push   %esi
  80221b:	53                   	push   %ebx
  80221c:	83 ec 1c             	sub    $0x1c,%esp
  80221f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802223:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802227:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80222b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80222f:	89 ca                	mov    %ecx,%edx
  802231:	89 f8                	mov    %edi,%eax
  802233:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802237:	85 f6                	test   %esi,%esi
  802239:	75 2d                	jne    802268 <__udivdi3+0x50>
  80223b:	39 cf                	cmp    %ecx,%edi
  80223d:	77 65                	ja     8022a4 <__udivdi3+0x8c>
  80223f:	89 fd                	mov    %edi,%ebp
  802241:	85 ff                	test   %edi,%edi
  802243:	75 0b                	jne    802250 <__udivdi3+0x38>
  802245:	b8 01 00 00 00       	mov    $0x1,%eax
  80224a:	31 d2                	xor    %edx,%edx
  80224c:	f7 f7                	div    %edi
  80224e:	89 c5                	mov    %eax,%ebp
  802250:	31 d2                	xor    %edx,%edx
  802252:	89 c8                	mov    %ecx,%eax
  802254:	f7 f5                	div    %ebp
  802256:	89 c1                	mov    %eax,%ecx
  802258:	89 d8                	mov    %ebx,%eax
  80225a:	f7 f5                	div    %ebp
  80225c:	89 cf                	mov    %ecx,%edi
  80225e:	89 fa                	mov    %edi,%edx
  802260:	83 c4 1c             	add    $0x1c,%esp
  802263:	5b                   	pop    %ebx
  802264:	5e                   	pop    %esi
  802265:	5f                   	pop    %edi
  802266:	5d                   	pop    %ebp
  802267:	c3                   	ret    
  802268:	39 ce                	cmp    %ecx,%esi
  80226a:	77 28                	ja     802294 <__udivdi3+0x7c>
  80226c:	0f bd fe             	bsr    %esi,%edi
  80226f:	83 f7 1f             	xor    $0x1f,%edi
  802272:	75 40                	jne    8022b4 <__udivdi3+0x9c>
  802274:	39 ce                	cmp    %ecx,%esi
  802276:	72 0a                	jb     802282 <__udivdi3+0x6a>
  802278:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80227c:	0f 87 9e 00 00 00    	ja     802320 <__udivdi3+0x108>
  802282:	b8 01 00 00 00       	mov    $0x1,%eax
  802287:	89 fa                	mov    %edi,%edx
  802289:	83 c4 1c             	add    $0x1c,%esp
  80228c:	5b                   	pop    %ebx
  80228d:	5e                   	pop    %esi
  80228e:	5f                   	pop    %edi
  80228f:	5d                   	pop    %ebp
  802290:	c3                   	ret    
  802291:	8d 76 00             	lea    0x0(%esi),%esi
  802294:	31 ff                	xor    %edi,%edi
  802296:	31 c0                	xor    %eax,%eax
  802298:	89 fa                	mov    %edi,%edx
  80229a:	83 c4 1c             	add    $0x1c,%esp
  80229d:	5b                   	pop    %ebx
  80229e:	5e                   	pop    %esi
  80229f:	5f                   	pop    %edi
  8022a0:	5d                   	pop    %ebp
  8022a1:	c3                   	ret    
  8022a2:	66 90                	xchg   %ax,%ax
  8022a4:	89 d8                	mov    %ebx,%eax
  8022a6:	f7 f7                	div    %edi
  8022a8:	31 ff                	xor    %edi,%edi
  8022aa:	89 fa                	mov    %edi,%edx
  8022ac:	83 c4 1c             	add    $0x1c,%esp
  8022af:	5b                   	pop    %ebx
  8022b0:	5e                   	pop    %esi
  8022b1:	5f                   	pop    %edi
  8022b2:	5d                   	pop    %ebp
  8022b3:	c3                   	ret    
  8022b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8022b9:	89 eb                	mov    %ebp,%ebx
  8022bb:	29 fb                	sub    %edi,%ebx
  8022bd:	89 f9                	mov    %edi,%ecx
  8022bf:	d3 e6                	shl    %cl,%esi
  8022c1:	89 c5                	mov    %eax,%ebp
  8022c3:	88 d9                	mov    %bl,%cl
  8022c5:	d3 ed                	shr    %cl,%ebp
  8022c7:	89 e9                	mov    %ebp,%ecx
  8022c9:	09 f1                	or     %esi,%ecx
  8022cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8022cf:	89 f9                	mov    %edi,%ecx
  8022d1:	d3 e0                	shl    %cl,%eax
  8022d3:	89 c5                	mov    %eax,%ebp
  8022d5:	89 d6                	mov    %edx,%esi
  8022d7:	88 d9                	mov    %bl,%cl
  8022d9:	d3 ee                	shr    %cl,%esi
  8022db:	89 f9                	mov    %edi,%ecx
  8022dd:	d3 e2                	shl    %cl,%edx
  8022df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022e3:	88 d9                	mov    %bl,%cl
  8022e5:	d3 e8                	shr    %cl,%eax
  8022e7:	09 c2                	or     %eax,%edx
  8022e9:	89 d0                	mov    %edx,%eax
  8022eb:	89 f2                	mov    %esi,%edx
  8022ed:	f7 74 24 0c          	divl   0xc(%esp)
  8022f1:	89 d6                	mov    %edx,%esi
  8022f3:	89 c3                	mov    %eax,%ebx
  8022f5:	f7 e5                	mul    %ebp
  8022f7:	39 d6                	cmp    %edx,%esi
  8022f9:	72 19                	jb     802314 <__udivdi3+0xfc>
  8022fb:	74 0b                	je     802308 <__udivdi3+0xf0>
  8022fd:	89 d8                	mov    %ebx,%eax
  8022ff:	31 ff                	xor    %edi,%edi
  802301:	e9 58 ff ff ff       	jmp    80225e <__udivdi3+0x46>
  802306:	66 90                	xchg   %ax,%ax
  802308:	8b 54 24 08          	mov    0x8(%esp),%edx
  80230c:	89 f9                	mov    %edi,%ecx
  80230e:	d3 e2                	shl    %cl,%edx
  802310:	39 c2                	cmp    %eax,%edx
  802312:	73 e9                	jae    8022fd <__udivdi3+0xe5>
  802314:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802317:	31 ff                	xor    %edi,%edi
  802319:	e9 40 ff ff ff       	jmp    80225e <__udivdi3+0x46>
  80231e:	66 90                	xchg   %ax,%ax
  802320:	31 c0                	xor    %eax,%eax
  802322:	e9 37 ff ff ff       	jmp    80225e <__udivdi3+0x46>
  802327:	90                   	nop

00802328 <__umoddi3>:
  802328:	55                   	push   %ebp
  802329:	57                   	push   %edi
  80232a:	56                   	push   %esi
  80232b:	53                   	push   %ebx
  80232c:	83 ec 1c             	sub    $0x1c,%esp
  80232f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802333:	8b 74 24 34          	mov    0x34(%esp),%esi
  802337:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80233b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80233f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802343:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802347:	89 f3                	mov    %esi,%ebx
  802349:	89 fa                	mov    %edi,%edx
  80234b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80234f:	89 34 24             	mov    %esi,(%esp)
  802352:	85 c0                	test   %eax,%eax
  802354:	75 1a                	jne    802370 <__umoddi3+0x48>
  802356:	39 f7                	cmp    %esi,%edi
  802358:	0f 86 a2 00 00 00    	jbe    802400 <__umoddi3+0xd8>
  80235e:	89 c8                	mov    %ecx,%eax
  802360:	89 f2                	mov    %esi,%edx
  802362:	f7 f7                	div    %edi
  802364:	89 d0                	mov    %edx,%eax
  802366:	31 d2                	xor    %edx,%edx
  802368:	83 c4 1c             	add    $0x1c,%esp
  80236b:	5b                   	pop    %ebx
  80236c:	5e                   	pop    %esi
  80236d:	5f                   	pop    %edi
  80236e:	5d                   	pop    %ebp
  80236f:	c3                   	ret    
  802370:	39 f0                	cmp    %esi,%eax
  802372:	0f 87 ac 00 00 00    	ja     802424 <__umoddi3+0xfc>
  802378:	0f bd e8             	bsr    %eax,%ebp
  80237b:	83 f5 1f             	xor    $0x1f,%ebp
  80237e:	0f 84 ac 00 00 00    	je     802430 <__umoddi3+0x108>
  802384:	bf 20 00 00 00       	mov    $0x20,%edi
  802389:	29 ef                	sub    %ebp,%edi
  80238b:	89 fe                	mov    %edi,%esi
  80238d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802391:	89 e9                	mov    %ebp,%ecx
  802393:	d3 e0                	shl    %cl,%eax
  802395:	89 d7                	mov    %edx,%edi
  802397:	89 f1                	mov    %esi,%ecx
  802399:	d3 ef                	shr    %cl,%edi
  80239b:	09 c7                	or     %eax,%edi
  80239d:	89 e9                	mov    %ebp,%ecx
  80239f:	d3 e2                	shl    %cl,%edx
  8023a1:	89 14 24             	mov    %edx,(%esp)
  8023a4:	89 d8                	mov    %ebx,%eax
  8023a6:	d3 e0                	shl    %cl,%eax
  8023a8:	89 c2                	mov    %eax,%edx
  8023aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023ae:	d3 e0                	shl    %cl,%eax
  8023b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023b8:	89 f1                	mov    %esi,%ecx
  8023ba:	d3 e8                	shr    %cl,%eax
  8023bc:	09 d0                	or     %edx,%eax
  8023be:	d3 eb                	shr    %cl,%ebx
  8023c0:	89 da                	mov    %ebx,%edx
  8023c2:	f7 f7                	div    %edi
  8023c4:	89 d3                	mov    %edx,%ebx
  8023c6:	f7 24 24             	mull   (%esp)
  8023c9:	89 c6                	mov    %eax,%esi
  8023cb:	89 d1                	mov    %edx,%ecx
  8023cd:	39 d3                	cmp    %edx,%ebx
  8023cf:	0f 82 87 00 00 00    	jb     80245c <__umoddi3+0x134>
  8023d5:	0f 84 91 00 00 00    	je     80246c <__umoddi3+0x144>
  8023db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023df:	29 f2                	sub    %esi,%edx
  8023e1:	19 cb                	sbb    %ecx,%ebx
  8023e3:	89 d8                	mov    %ebx,%eax
  8023e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8023e9:	d3 e0                	shl    %cl,%eax
  8023eb:	89 e9                	mov    %ebp,%ecx
  8023ed:	d3 ea                	shr    %cl,%edx
  8023ef:	09 d0                	or     %edx,%eax
  8023f1:	89 e9                	mov    %ebp,%ecx
  8023f3:	d3 eb                	shr    %cl,%ebx
  8023f5:	89 da                	mov    %ebx,%edx
  8023f7:	83 c4 1c             	add    $0x1c,%esp
  8023fa:	5b                   	pop    %ebx
  8023fb:	5e                   	pop    %esi
  8023fc:	5f                   	pop    %edi
  8023fd:	5d                   	pop    %ebp
  8023fe:	c3                   	ret    
  8023ff:	90                   	nop
  802400:	89 fd                	mov    %edi,%ebp
  802402:	85 ff                	test   %edi,%edi
  802404:	75 0b                	jne    802411 <__umoddi3+0xe9>
  802406:	b8 01 00 00 00       	mov    $0x1,%eax
  80240b:	31 d2                	xor    %edx,%edx
  80240d:	f7 f7                	div    %edi
  80240f:	89 c5                	mov    %eax,%ebp
  802411:	89 f0                	mov    %esi,%eax
  802413:	31 d2                	xor    %edx,%edx
  802415:	f7 f5                	div    %ebp
  802417:	89 c8                	mov    %ecx,%eax
  802419:	f7 f5                	div    %ebp
  80241b:	89 d0                	mov    %edx,%eax
  80241d:	e9 44 ff ff ff       	jmp    802366 <__umoddi3+0x3e>
  802422:	66 90                	xchg   %ax,%ax
  802424:	89 c8                	mov    %ecx,%eax
  802426:	89 f2                	mov    %esi,%edx
  802428:	83 c4 1c             	add    $0x1c,%esp
  80242b:	5b                   	pop    %ebx
  80242c:	5e                   	pop    %esi
  80242d:	5f                   	pop    %edi
  80242e:	5d                   	pop    %ebp
  80242f:	c3                   	ret    
  802430:	3b 04 24             	cmp    (%esp),%eax
  802433:	72 06                	jb     80243b <__umoddi3+0x113>
  802435:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802439:	77 0f                	ja     80244a <__umoddi3+0x122>
  80243b:	89 f2                	mov    %esi,%edx
  80243d:	29 f9                	sub    %edi,%ecx
  80243f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802443:	89 14 24             	mov    %edx,(%esp)
  802446:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80244a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80244e:	8b 14 24             	mov    (%esp),%edx
  802451:	83 c4 1c             	add    $0x1c,%esp
  802454:	5b                   	pop    %ebx
  802455:	5e                   	pop    %esi
  802456:	5f                   	pop    %edi
  802457:	5d                   	pop    %ebp
  802458:	c3                   	ret    
  802459:	8d 76 00             	lea    0x0(%esi),%esi
  80245c:	2b 04 24             	sub    (%esp),%eax
  80245f:	19 fa                	sbb    %edi,%edx
  802461:	89 d1                	mov    %edx,%ecx
  802463:	89 c6                	mov    %eax,%esi
  802465:	e9 71 ff ff ff       	jmp    8023db <__umoddi3+0xb3>
  80246a:	66 90                	xchg   %ax,%ax
  80246c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802470:	72 ea                	jb     80245c <__umoddi3+0x134>
  802472:	89 d9                	mov    %ebx,%ecx
  802474:	e9 62 ff ff ff       	jmp    8023db <__umoddi3+0xb3>
