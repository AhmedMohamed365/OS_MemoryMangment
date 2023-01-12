
obj/user/tst4:     file format elf32-i386


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
  800031:	e8 a9 08 00 00       	call   8008df <libmain>
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
  80003e:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	

	rsttst();
  800044:	e8 4d 23 00 00       	call   802396 <rsttst>
	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 03                	push   $0x3
  80004e:	e8 1d 23 00 00       	call   802370 <sys_bypassPageFault>
  800053:	83 c4 10             	add    $0x10,%esp


	
	

	int Mega = 1024*1024;
  800056:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  80005d:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  800064:	e8 f0 1f 00 00       	call   802059 <sys_calculate_free_frames>
  800069:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//ALLOCATE ALL
	void* ptr_allocations[20] = {0};
  80006c:	8d 55 80             	lea    -0x80(%ebp),%edx
  80006f:	b9 14 00 00 00       	mov    $0x14,%ecx
  800074:	b8 00 00 00 00       	mov    $0x0,%eax
  800079:	89 d7                	mov    %edx,%edi
  80007b:	f3 ab                	rep stos %eax,%es:(%edi)
	int lastIndices[20] = {0};
  80007d:	8d 95 30 ff ff ff    	lea    -0xd0(%ebp),%edx
  800083:	b9 14 00 00 00       	mov    $0x14,%ecx
  800088:	b8 00 00 00 00       	mov    $0x0,%eax
  80008d:	89 d7                	mov    %edx,%edi
  80008f:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  800091:	e8 c3 1f 00 00       	call   802059 <sys_calculate_free_frames>
  800096:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800099:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80009c:	01 c0                	add    %eax,%eax
  80009e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	50                   	push   %eax
  8000a5:	e8 d8 17 00 00       	call   801882 <malloc>
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	89 45 80             	mov    %eax,-0x80(%ebp)
		tst((uint32) ptr_allocations[0], USER_HEAP_START,USER_HEAP_START + PAGE_SIZE, 'b', 0);
  8000b0:	8b 45 80             	mov    -0x80(%ebp),%eax
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 62                	push   $0x62
  8000ba:	68 00 10 00 80       	push   $0x80001000
  8000bf:	68 00 00 00 80       	push   $0x80000000
  8000c4:	50                   	push   %eax
  8000c5:	e8 e6 22 00 00       	call   8023b0 <tst>
  8000ca:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  8000cd:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8000d0:	e8 84 1f 00 00       	call   802059 <sys_calculate_free_frames>
  8000d5:	29 c3                	sub    %eax,%ebx
  8000d7:	89 d8                	mov    %ebx,%eax
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	6a 00                	push   $0x0
  8000de:	6a 65                	push   $0x65
  8000e0:	6a 00                	push   $0x0
  8000e2:	68 01 02 00 00       	push   $0x201
  8000e7:	50                   	push   %eax
  8000e8:	e8 c3 22 00 00       	call   8023b0 <tst>
  8000ed:	83 c4 20             	add    $0x20,%esp
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  8000f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f3:	01 c0                	add    %eax,%eax
  8000f5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000f8:	48                   	dec    %eax
  8000f9:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8000ff:	e8 55 1f 00 00       	call   802059 <sys_calculate_free_frames>
  800104:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800107:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80010a:	01 c0                	add    %eax,%eax
  80010c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	50                   	push   %eax
  800113:	e8 6a 17 00 00       	call   801882 <malloc>
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	89 45 84             	mov    %eax,-0x7c(%ebp)
		tst((uint32) ptr_allocations[1], USER_HEAP_START+ 2*Mega,USER_HEAP_START + 2*Mega + PAGE_SIZE, 'b', 0);
  80011e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800121:	01 c0                	add    %eax,%eax
  800123:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012c:	01 c0                	add    %eax,%eax
  80012e:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800134:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	6a 00                	push   $0x0
  80013c:	6a 62                	push   $0x62
  80013e:	51                   	push   %ecx
  80013f:	52                   	push   %edx
  800140:	50                   	push   %eax
  800141:	e8 6a 22 00 00       	call   8023b0 <tst>
  800146:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512 ,0, 'e', 0);
  800149:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80014c:	e8 08 1f 00 00       	call   802059 <sys_calculate_free_frames>
  800151:	29 c3                	sub    %eax,%ebx
  800153:	89 d8                	mov    %ebx,%eax
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	6a 00                	push   $0x0
  80015a:	6a 65                	push   $0x65
  80015c:	6a 00                	push   $0x0
  80015e:	68 00 02 00 00       	push   $0x200
  800163:	50                   	push   %eax
  800164:	e8 47 22 00 00       	call   8023b0 <tst>
  800169:	83 c4 20             	add    $0x20,%esp
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  80016c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016f:	01 c0                	add    %eax,%eax
  800171:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800174:	48                   	dec    %eax
  800175:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  80017b:	e8 d9 1e 00 00       	call   802059 <sys_calculate_free_frames>
  800180:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800183:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800186:	01 c0                	add    %eax,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	50                   	push   %eax
  80018c:	e8 f1 16 00 00       	call   801882 <malloc>
  800191:	83 c4 10             	add    $0x10,%esp
  800194:	89 45 88             	mov    %eax,-0x78(%ebp)
		tst((uint32) ptr_allocations[2], USER_HEAP_START+ 4*Mega,USER_HEAP_START + 4*Mega + PAGE_SIZE, 'b', 0);
  800197:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80019a:	c1 e0 02             	shl    $0x2,%eax
  80019d:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8001a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a6:	c1 e0 02             	shl    $0x2,%eax
  8001a9:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8001af:	8b 45 88             	mov    -0x78(%ebp),%eax
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	6a 00                	push   $0x0
  8001b7:	6a 62                	push   $0x62
  8001b9:	51                   	push   %ecx
  8001ba:	52                   	push   %edx
  8001bb:	50                   	push   %eax
  8001bc:	e8 ef 21 00 00       	call   8023b0 <tst>
  8001c1:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1+1 ,0, 'e', 0);
  8001c4:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8001c7:	e8 8d 1e 00 00       	call   802059 <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	6a 00                	push   $0x0
  8001d5:	6a 65                	push   $0x65
  8001d7:	6a 00                	push   $0x0
  8001d9:	6a 02                	push   $0x2
  8001db:	50                   	push   %eax
  8001dc:	e8 cf 21 00 00       	call   8023b0 <tst>
  8001e1:	83 c4 20             	add    $0x20,%esp
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  8001e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e7:	01 c0                	add    %eax,%eax
  8001e9:	48                   	dec    %eax
  8001ea:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  8001f0:	e8 64 1e 00 00       	call   802059 <sys_calculate_free_frames>
  8001f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8001f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001fb:	01 c0                	add    %eax,%eax
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	50                   	push   %eax
  800201:	e8 7c 16 00 00       	call   801882 <malloc>
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	89 45 8c             	mov    %eax,-0x74(%ebp)
		tst((uint32) ptr_allocations[3], USER_HEAP_START+ 4*Mega + 4*kilo,USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE, 'b', 0);
  80020c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020f:	c1 e0 02             	shl    $0x2,%eax
  800212:	89 c2                	mov    %eax,%edx
  800214:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800217:	c1 e0 02             	shl    $0x2,%eax
  80021a:	01 d0                	add    %edx,%eax
  80021c:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800225:	c1 e0 02             	shl    $0x2,%eax
  800228:	89 c2                	mov    %eax,%edx
  80022a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022d:	c1 e0 02             	shl    $0x2,%eax
  800230:	01 d0                	add    %edx,%eax
  800232:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800238:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	6a 00                	push   $0x0
  800240:	6a 62                	push   $0x62
  800242:	51                   	push   %ecx
  800243:	52                   	push   %edx
  800244:	50                   	push   %eax
  800245:	e8 66 21 00 00       	call   8023b0 <tst>
  80024a:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1 ,0, 'e', 0);
  80024d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800250:	e8 04 1e 00 00       	call   802059 <sys_calculate_free_frames>
  800255:	29 c3                	sub    %eax,%ebx
  800257:	89 d8                	mov    %ebx,%eax
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	6a 00                	push   $0x0
  80025e:	6a 65                	push   $0x65
  800260:	6a 00                	push   $0x0
  800262:	6a 01                	push   $0x1
  800264:	50                   	push   %eax
  800265:	e8 46 21 00 00       	call   8023b0 <tst>
  80026a:	83 c4 20             	add    $0x20,%esp
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  80026d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800270:	01 c0                	add    %eax,%eax
  800272:	48                   	dec    %eax
  800273:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  800279:	e8 db 1d 00 00       	call   802059 <sys_calculate_free_frames>
  80027e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800281:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800284:	89 d0                	mov    %edx,%eax
  800286:	01 c0                	add    %eax,%eax
  800288:	01 d0                	add    %edx,%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	01 d0                	add    %edx,%eax
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	e8 eb 15 00 00       	call   801882 <malloc>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 90             	mov    %eax,-0x70(%ebp)
		tst((uint32) ptr_allocations[4], USER_HEAP_START+ 4*Mega + 8*kilo,USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE, 'b', 0);
  80029d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a0:	c1 e0 02             	shl    $0x2,%eax
  8002a3:	89 c2                	mov    %eax,%edx
  8002a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a8:	c1 e0 03             	shl    $0x3,%eax
  8002ab:	01 d0                	add    %edx,%eax
  8002ad:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8002b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b6:	c1 e0 02             	shl    $0x2,%eax
  8002b9:	89 c2                	mov    %eax,%edx
  8002bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002be:	c1 e0 03             	shl    $0x3,%eax
  8002c1:	01 d0                	add    %edx,%eax
  8002c3:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8002c9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	6a 00                	push   $0x0
  8002d1:	6a 62                	push   $0x62
  8002d3:	51                   	push   %ecx
  8002d4:	52                   	push   %edx
  8002d5:	50                   	push   %eax
  8002d6:	e8 d5 20 00 00       	call   8023b0 <tst>
  8002db:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 2 ,0, 'e', 0);
  8002de:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8002e1:	e8 73 1d 00 00       	call   802059 <sys_calculate_free_frames>
  8002e6:	29 c3                	sub    %eax,%ebx
  8002e8:	89 d8                	mov    %ebx,%eax
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	6a 00                	push   $0x0
  8002ef:	6a 65                	push   $0x65
  8002f1:	6a 00                	push   $0x0
  8002f3:	6a 02                	push   $0x2
  8002f5:	50                   	push   %eax
  8002f6:	e8 b5 20 00 00       	call   8023b0 <tst>
  8002fb:	83 c4 20             	add    $0x20,%esp
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  8002fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800301:	89 d0                	mov    %edx,%eax
  800303:	01 c0                	add    %eax,%eax
  800305:	01 d0                	add    %edx,%eax
  800307:	01 c0                	add    %eax,%eax
  800309:	01 d0                	add    %edx,%eax
  80030b:	48                   	dec    %eax
  80030c:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  800312:	e8 42 1d 00 00       	call   802059 <sys_calculate_free_frames>
  800317:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	89 c2                	mov    %eax,%edx
  80031f:	01 d2                	add    %edx,%edx
  800321:	01 d0                	add    %edx,%eax
  800323:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	50                   	push   %eax
  80032a:	e8 53 15 00 00       	call   801882 <malloc>
  80032f:	83 c4 10             	add    $0x10,%esp
  800332:	89 45 94             	mov    %eax,-0x6c(%ebp)
		tst((uint32) ptr_allocations[5], USER_HEAP_START+ 4*Mega + 16*kilo,USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE, 'b', 0);
  800335:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800338:	c1 e0 02             	shl    $0x2,%eax
  80033b:	89 c2                	mov    %eax,%edx
  80033d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800340:	c1 e0 04             	shl    $0x4,%eax
  800343:	01 d0                	add    %edx,%eax
  800345:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  80034b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80034e:	c1 e0 02             	shl    $0x2,%eax
  800351:	89 c2                	mov    %eax,%edx
  800353:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800356:	c1 e0 04             	shl    $0x4,%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800361:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	6a 00                	push   $0x0
  800369:	6a 62                	push   $0x62
  80036b:	51                   	push   %ecx
  80036c:	52                   	push   %edx
  80036d:	50                   	push   %eax
  80036e:	e8 3d 20 00 00       	call   8023b0 <tst>
  800373:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 3*Mega/4096 ,0, 'e', 0);
  800376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800379:	89 c2                	mov    %eax,%edx
  80037b:	01 d2                	add    %edx,%edx
  80037d:	01 d0                	add    %edx,%eax
  80037f:	85 c0                	test   %eax,%eax
  800381:	79 05                	jns    800388 <_main+0x350>
  800383:	05 ff 0f 00 00       	add    $0xfff,%eax
  800388:	c1 f8 0c             	sar    $0xc,%eax
  80038b:	89 c3                	mov    %eax,%ebx
  80038d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800390:	e8 c4 1c 00 00       	call   802059 <sys_calculate_free_frames>
  800395:	29 c6                	sub    %eax,%esi
  800397:	89 f0                	mov    %esi,%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	6a 00                	push   $0x0
  80039e:	6a 65                	push   $0x65
  8003a0:	6a 00                	push   $0x0
  8003a2:	53                   	push   %ebx
  8003a3:	50                   	push   %eax
  8003a4:	e8 07 20 00 00       	call   8023b0 <tst>
  8003a9:	83 c4 20             	add    $0x20,%esp
		lastIndices[5] = (3*Mega - kilo)/sizeof(char) - 1;
  8003ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003af:	89 c2                	mov    %eax,%edx
  8003b1:	01 d2                	add    %edx,%edx
  8003b3:	01 d0                	add    %edx,%eax
  8003b5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8003b8:	48                   	dec    %eax
  8003b9:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  8003bf:	e8 95 1c 00 00       	call   802059 <sys_calculate_free_frames>
  8003c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  8003c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ca:	01 c0                	add    %eax,%eax
  8003cc:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	50                   	push   %eax
  8003d3:	e8 aa 14 00 00       	call   801882 <malloc>
  8003d8:	83 c4 10             	add    $0x10,%esp
  8003db:	89 45 98             	mov    %eax,-0x68(%ebp)
		tst((uint32) ptr_allocations[6], USER_HEAP_START+ 7*Mega + 16*kilo,USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE, 'b', 0);
  8003de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003e1:	89 d0                	mov    %edx,%eax
  8003e3:	01 c0                	add    %eax,%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	01 c0                	add    %eax,%eax
  8003e9:	01 d0                	add    %edx,%eax
  8003eb:	89 c2                	mov    %eax,%edx
  8003ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f0:	c1 e0 04             	shl    $0x4,%eax
  8003f3:	01 d0                	add    %edx,%eax
  8003f5:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8003fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	01 c0                	add    %eax,%eax
  800402:	01 d0                	add    %edx,%eax
  800404:	01 c0                	add    %eax,%eax
  800406:	01 d0                	add    %edx,%eax
  800408:	89 c2                	mov    %eax,%edx
  80040a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80040d:	c1 e0 04             	shl    $0x4,%eax
  800410:	01 d0                	add    %edx,%eax
  800412:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800418:	8b 45 98             	mov    -0x68(%ebp),%eax
  80041b:	83 ec 0c             	sub    $0xc,%esp
  80041e:	6a 00                	push   $0x0
  800420:	6a 62                	push   $0x62
  800422:	51                   	push   %ecx
  800423:	52                   	push   %edx
  800424:	50                   	push   %eax
  800425:	e8 86 1f 00 00       	call   8023b0 <tst>
  80042a:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  80042d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800430:	e8 24 1c 00 00       	call   802059 <sys_calculate_free_frames>
  800435:	29 c3                	sub    %eax,%ebx
  800437:	89 d8                	mov    %ebx,%eax
  800439:	83 ec 0c             	sub    $0xc,%esp
  80043c:	6a 00                	push   $0x0
  80043e:	6a 65                	push   $0x65
  800440:	6a 00                	push   $0x0
  800442:	68 01 02 00 00       	push   $0x201
  800447:	50                   	push   %eax
  800448:	e8 63 1f 00 00       	call   8023b0 <tst>
  80044d:	83 c4 20             	add    $0x20,%esp
		lastIndices[6] = (2*Mega - kilo)/sizeof(char) - 1;
  800450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800453:	01 c0                	add    %eax,%eax
  800455:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800458:	48                   	dec    %eax
  800459:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	char x ;
	int y;
	char *byteArr ;
	//FREE ALL
	{
		int freeFrames = sys_calculate_free_frames() ;
  80045f:	e8 f5 1b 00 00       	call   802059 <sys_calculate_free_frames>
  800464:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800467:	8b 45 80             	mov    -0x80(%ebp),%eax
  80046a:	83 ec 0c             	sub    $0xc,%esp
  80046d:	50                   	push   %eax
  80046e:	e8 ca 18 00 00       	call   801d3d <free>
  800473:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512 ,0, 'e', 0);
  800476:	e8 de 1b 00 00       	call   802059 <sys_calculate_free_frames>
  80047b:	89 c2                	mov    %eax,%edx
  80047d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800480:	29 c2                	sub    %eax,%edx
  800482:	89 d0                	mov    %edx,%eax
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	6a 00                	push   $0x0
  800489:	6a 65                	push   $0x65
  80048b:	6a 00                	push   $0x0
  80048d:	68 00 02 00 00       	push   $0x200
  800492:	50                   	push   %eax
  800493:	e8 18 1f 00 00       	call   8023b0 <tst>
  800498:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[0];
  80049b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80049e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004a4:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  8004a7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8004aa:	e8 a8 1e 00 00       	call   802357 <sys_rcr2>
  8004af:	83 ec 0c             	sub    $0xc,%esp
  8004b2:	6a 00                	push   $0x0
  8004b4:	6a 65                	push   $0x65
  8004b6:	6a 00                	push   $0x0
  8004b8:	53                   	push   %ebx
  8004b9:	50                   	push   %eax
  8004ba:	e8 f1 1e 00 00       	call   8023b0 <tst>
  8004bf:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[0]] = 10;
  8004c2:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004c8:	89 c2                	mov    %eax,%edx
  8004ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[0]]) ,0, 'e', 0);
  8004d2:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004d8:	89 c2                	mov    %eax,%edx
  8004da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004dd:	01 d0                	add    %edx,%eax
  8004df:	89 c3                	mov    %eax,%ebx
  8004e1:	e8 71 1e 00 00       	call   802357 <sys_rcr2>
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	6a 00                	push   $0x0
  8004eb:	6a 65                	push   $0x65
  8004ed:	6a 00                	push   $0x0
  8004ef:	53                   	push   %ebx
  8004f0:	50                   	push   %eax
  8004f1:	e8 ba 1e 00 00       	call   8023b0 <tst>
  8004f6:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  8004f9:	e8 5b 1b 00 00       	call   802059 <sys_calculate_free_frames>
  8004fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800501:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	50                   	push   %eax
  800508:	e8 30 18 00 00       	call   801d3d <free>
  80050d:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512 +1,0, 'e', 0);
  800510:	e8 44 1b 00 00       	call   802059 <sys_calculate_free_frames>
  800515:	89 c2                	mov    %eax,%edx
  800517:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80051a:	29 c2                	sub    %eax,%edx
  80051c:	89 d0                	mov    %edx,%eax
  80051e:	83 ec 0c             	sub    $0xc,%esp
  800521:	6a 00                	push   $0x0
  800523:	6a 65                	push   $0x65
  800525:	6a 00                	push   $0x0
  800527:	68 01 02 00 00       	push   $0x201
  80052c:	50                   	push   %eax
  80052d:	e8 7e 1e 00 00       	call   8023b0 <tst>
  800532:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[1];
  800535:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800538:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80053b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80053e:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  800541:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800544:	e8 0e 1e 00 00       	call   802357 <sys_rcr2>
  800549:	83 ec 0c             	sub    $0xc,%esp
  80054c:	6a 00                	push   $0x0
  80054e:	6a 65                	push   $0x65
  800550:	6a 00                	push   $0x0
  800552:	53                   	push   %ebx
  800553:	50                   	push   %eax
  800554:	e8 57 1e 00 00       	call   8023b0 <tst>
  800559:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[1]] = 10;
  80055c:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800562:	89 c2                	mov    %eax,%edx
  800564:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800567:	01 d0                	add    %edx,%eax
  800569:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[1]]) ,0, 'e', 0);
  80056c:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800572:	89 c2                	mov    %eax,%edx
  800574:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800577:	01 d0                	add    %edx,%eax
  800579:	89 c3                	mov    %eax,%ebx
  80057b:	e8 d7 1d 00 00       	call   802357 <sys_rcr2>
  800580:	83 ec 0c             	sub    $0xc,%esp
  800583:	6a 00                	push   $0x0
  800585:	6a 65                	push   $0x65
  800587:	6a 00                	push   $0x0
  800589:	53                   	push   %ebx
  80058a:	50                   	push   %eax
  80058b:	e8 20 1e 00 00       	call   8023b0 <tst>
  800590:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800593:	e8 c1 1a 00 00       	call   802059 <sys_calculate_free_frames>
  800598:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  80059b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 96 17 00 00       	call   801d3d <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 1 ,0, 'e', 0);
  8005aa:	e8 aa 1a 00 00       	call   802059 <sys_calculate_free_frames>
  8005af:	89 c2                	mov    %eax,%edx
  8005b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b4:	29 c2                	sub    %eax,%edx
  8005b6:	89 d0                	mov    %edx,%eax
  8005b8:	83 ec 0c             	sub    $0xc,%esp
  8005bb:	6a 00                	push   $0x0
  8005bd:	6a 65                	push   $0x65
  8005bf:	6a 00                	push   $0x0
  8005c1:	6a 01                	push   $0x1
  8005c3:	50                   	push   %eax
  8005c4:	e8 e7 1d 00 00       	call   8023b0 <tst>
  8005c9:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[2];
  8005cc:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8005d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005d5:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  8005d8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8005db:	e8 77 1d 00 00       	call   802357 <sys_rcr2>
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	6a 00                	push   $0x0
  8005e5:	6a 65                	push   $0x65
  8005e7:	6a 00                	push   $0x0
  8005e9:	53                   	push   %ebx
  8005ea:	50                   	push   %eax
  8005eb:	e8 c0 1d 00 00       	call   8023b0 <tst>
  8005f0:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[2]] = 10;
  8005f3:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  8005f9:	89 c2                	mov    %eax,%edx
  8005fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005fe:	01 d0                	add    %edx,%eax
  800600:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[2]]) ,0, 'e', 0);
  800603:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800609:	89 c2                	mov    %eax,%edx
  80060b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80060e:	01 d0                	add    %edx,%eax
  800610:	89 c3                	mov    %eax,%ebx
  800612:	e8 40 1d 00 00       	call   802357 <sys_rcr2>
  800617:	83 ec 0c             	sub    $0xc,%esp
  80061a:	6a 00                	push   $0x0
  80061c:	6a 65                	push   $0x65
  80061e:	6a 00                	push   $0x0
  800620:	53                   	push   %ebx
  800621:	50                   	push   %eax
  800622:	e8 89 1d 00 00       	call   8023b0 <tst>
  800627:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  80062a:	e8 2a 1a 00 00       	call   802059 <sys_calculate_free_frames>
  80062f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800632:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	50                   	push   %eax
  800639:	e8 ff 16 00 00       	call   801d3d <free>
  80063e:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 1 ,0, 'e', 0);
  800641:	e8 13 1a 00 00       	call   802059 <sys_calculate_free_frames>
  800646:	89 c2                	mov    %eax,%edx
  800648:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064b:	29 c2                	sub    %eax,%edx
  80064d:	89 d0                	mov    %edx,%eax
  80064f:	83 ec 0c             	sub    $0xc,%esp
  800652:	6a 00                	push   $0x0
  800654:	6a 65                	push   $0x65
  800656:	6a 00                	push   $0x0
  800658:	6a 01                	push   $0x1
  80065a:	50                   	push   %eax
  80065b:	e8 50 1d 00 00       	call   8023b0 <tst>
  800660:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[3];
  800663:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800666:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800669:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80066c:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  80066f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800672:	e8 e0 1c 00 00       	call   802357 <sys_rcr2>
  800677:	83 ec 0c             	sub    $0xc,%esp
  80067a:	6a 00                	push   $0x0
  80067c:	6a 65                	push   $0x65
  80067e:	6a 00                	push   $0x0
  800680:	53                   	push   %ebx
  800681:	50                   	push   %eax
  800682:	e8 29 1d 00 00       	call   8023b0 <tst>
  800687:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[3]] = 10;
  80068a:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800690:	89 c2                	mov    %eax,%edx
  800692:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800695:	01 d0                	add    %edx,%eax
  800697:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[3]]) ,0, 'e', 0);
  80069a:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006a0:	89 c2                	mov    %eax,%edx
  8006a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006a5:	01 d0                	add    %edx,%eax
  8006a7:	89 c3                	mov    %eax,%ebx
  8006a9:	e8 a9 1c 00 00       	call   802357 <sys_rcr2>
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	6a 00                	push   $0x0
  8006b3:	6a 65                	push   $0x65
  8006b5:	6a 00                	push   $0x0
  8006b7:	53                   	push   %ebx
  8006b8:	50                   	push   %eax
  8006b9:	e8 f2 1c 00 00       	call   8023b0 <tst>
  8006be:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  8006c1:	e8 93 19 00 00       	call   802059 <sys_calculate_free_frames>
  8006c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  8006c9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006cc:	83 ec 0c             	sub    $0xc,%esp
  8006cf:	50                   	push   %eax
  8006d0:	e8 68 16 00 00       	call   801d3d <free>
  8006d5:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 2 ,0, 'e', 0);
  8006d8:	e8 7c 19 00 00       	call   802059 <sys_calculate_free_frames>
  8006dd:	89 c2                	mov    %eax,%edx
  8006df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e2:	29 c2                	sub    %eax,%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	83 ec 0c             	sub    $0xc,%esp
  8006e9:	6a 00                	push   $0x0
  8006eb:	6a 65                	push   $0x65
  8006ed:	6a 00                	push   $0x0
  8006ef:	6a 02                	push   $0x2
  8006f1:	50                   	push   %eax
  8006f2:	e8 b9 1c 00 00       	call   8023b0 <tst>
  8006f7:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[4];
  8006fa:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800700:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800703:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  800706:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800709:	e8 49 1c 00 00       	call   802357 <sys_rcr2>
  80070e:	83 ec 0c             	sub    $0xc,%esp
  800711:	6a 00                	push   $0x0
  800713:	6a 65                	push   $0x65
  800715:	6a 00                	push   $0x0
  800717:	53                   	push   %ebx
  800718:	50                   	push   %eax
  800719:	e8 92 1c 00 00       	call   8023b0 <tst>
  80071e:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[4]] = 10;
  800721:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800727:	89 c2                	mov    %eax,%edx
  800729:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80072c:	01 d0                	add    %edx,%eax
  80072e:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[4]]) ,0, 'e', 0);
  800731:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800737:	89 c2                	mov    %eax,%edx
  800739:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80073c:	01 d0                	add    %edx,%eax
  80073e:	89 c3                	mov    %eax,%ebx
  800740:	e8 12 1c 00 00       	call   802357 <sys_rcr2>
  800745:	83 ec 0c             	sub    $0xc,%esp
  800748:	6a 00                	push   $0x0
  80074a:	6a 65                	push   $0x65
  80074c:	6a 00                	push   $0x0
  80074e:	53                   	push   %ebx
  80074f:	50                   	push   %eax
  800750:	e8 5b 1c 00 00       	call   8023b0 <tst>
  800755:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800758:	e8 fc 18 00 00       	call   802059 <sys_calculate_free_frames>
  80075d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  800760:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	50                   	push   %eax
  800767:	e8 d1 15 00 00       	call   801d3d <free>
  80076c:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 3*Mega/4096 ,0, 'e', 0);
  80076f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800772:	89 c2                	mov    %eax,%edx
  800774:	01 d2                	add    %edx,%edx
  800776:	01 d0                	add    %edx,%eax
  800778:	85 c0                	test   %eax,%eax
  80077a:	79 05                	jns    800781 <_main+0x749>
  80077c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800781:	c1 f8 0c             	sar    $0xc,%eax
  800784:	89 c3                	mov    %eax,%ebx
  800786:	e8 ce 18 00 00       	call   802059 <sys_calculate_free_frames>
  80078b:	89 c2                	mov    %eax,%edx
  80078d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800790:	29 c2                	sub    %eax,%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	83 ec 0c             	sub    $0xc,%esp
  800797:	6a 00                	push   $0x0
  800799:	6a 65                	push   $0x65
  80079b:	6a 00                	push   $0x0
  80079d:	53                   	push   %ebx
  80079e:	50                   	push   %eax
  80079f:	e8 0c 1c 00 00       	call   8023b0 <tst>
  8007a4:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[5];
  8007a7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8007ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b0:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  8007b3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8007b6:	e8 9c 1b 00 00       	call   802357 <sys_rcr2>
  8007bb:	83 ec 0c             	sub    $0xc,%esp
  8007be:	6a 00                	push   $0x0
  8007c0:	6a 65                	push   $0x65
  8007c2:	6a 00                	push   $0x0
  8007c4:	53                   	push   %ebx
  8007c5:	50                   	push   %eax
  8007c6:	e8 e5 1b 00 00       	call   8023b0 <tst>
  8007cb:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[5]] = 10;
  8007ce:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8007d4:	89 c2                	mov    %eax,%edx
  8007d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007d9:	01 d0                	add    %edx,%eax
  8007db:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[5]]) ,0, 'e', 0);
  8007de:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8007e4:	89 c2                	mov    %eax,%edx
  8007e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007e9:	01 d0                	add    %edx,%eax
  8007eb:	89 c3                	mov    %eax,%ebx
  8007ed:	e8 65 1b 00 00       	call   802357 <sys_rcr2>
  8007f2:	83 ec 0c             	sub    $0xc,%esp
  8007f5:	6a 00                	push   $0x0
  8007f7:	6a 65                	push   $0x65
  8007f9:	6a 00                	push   $0x0
  8007fb:	53                   	push   %ebx
  8007fc:	50                   	push   %eax
  8007fd:	e8 ae 1b 00 00       	call   8023b0 <tst>
  800802:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800805:	e8 4f 18 00 00       	call   802059 <sys_calculate_free_frames>
  80080a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  80080d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800810:	83 ec 0c             	sub    $0xc,%esp
  800813:	50                   	push   %eax
  800814:	e8 24 15 00 00       	call   801d3d <free>
  800819:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512+2,0, 'e', 0);
  80081c:	e8 38 18 00 00       	call   802059 <sys_calculate_free_frames>
  800821:	89 c2                	mov    %eax,%edx
  800823:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800826:	29 c2                	sub    %eax,%edx
  800828:	89 d0                	mov    %edx,%eax
  80082a:	83 ec 0c             	sub    $0xc,%esp
  80082d:	6a 00                	push   $0x0
  80082f:	6a 65                	push   $0x65
  800831:	6a 00                	push   $0x0
  800833:	68 02 02 00 00       	push   $0x202
  800838:	50                   	push   %eax
  800839:	e8 72 1b 00 00       	call   8023b0 <tst>
  80083e:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[6];
  800841:	8b 45 98             	mov    -0x68(%ebp),%eax
  800844:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800847:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80084a:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  80084d:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800850:	e8 02 1b 00 00       	call   802357 <sys_rcr2>
  800855:	83 ec 0c             	sub    $0xc,%esp
  800858:	6a 00                	push   $0x0
  80085a:	6a 65                	push   $0x65
  80085c:	6a 00                	push   $0x0
  80085e:	53                   	push   %ebx
  80085f:	50                   	push   %eax
  800860:	e8 4b 1b 00 00       	call   8023b0 <tst>
  800865:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[6]] = 10;
  800868:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80086e:	89 c2                	mov    %eax,%edx
  800870:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800873:	01 d0                	add    %edx,%eax
  800875:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[6]]) ,0, 'e', 0);
  800878:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80087e:	89 c2                	mov    %eax,%edx
  800880:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800883:	01 d0                	add    %edx,%eax
  800885:	89 c3                	mov    %eax,%ebx
  800887:	e8 cb 1a 00 00       	call   802357 <sys_rcr2>
  80088c:	83 ec 0c             	sub    $0xc,%esp
  80088f:	6a 00                	push   $0x0
  800891:	6a 65                	push   $0x65
  800893:	6a 00                	push   $0x0
  800895:	53                   	push   %ebx
  800896:	50                   	push   %eax
  800897:	e8 14 1b 00 00       	call   8023b0 <tst>
  80089c:	83 c4 20             	add    $0x20,%esp

		tst(start_freeFrames, sys_calculate_free_frames() ,0, 'e', 0);
  80089f:	e8 b5 17 00 00       	call   802059 <sys_calculate_free_frames>
  8008a4:	89 c2                	mov    %eax,%edx
  8008a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008a9:	83 ec 0c             	sub    $0xc,%esp
  8008ac:	6a 00                	push   $0x0
  8008ae:	6a 65                	push   $0x65
  8008b0:	6a 00                	push   $0x0
  8008b2:	52                   	push   %edx
  8008b3:	50                   	push   %eax
  8008b4:	e8 f7 1a 00 00       	call   8023b0 <tst>
  8008b9:	83 c4 20             	add    $0x20,%esp
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  8008bc:	83 ec 0c             	sub    $0xc,%esp
  8008bf:	6a 00                	push   $0x0
  8008c1:	e8 aa 1a 00 00       	call   802370 <sys_bypassPageFault>
  8008c6:	83 c4 10             	add    $0x10,%esp

	chktst(36);
  8008c9:	83 ec 0c             	sub    $0xc,%esp
  8008cc:	6a 24                	push   $0x24
  8008ce:	e8 08 1b 00 00       	call   8023db <chktst>
  8008d3:	83 c4 10             	add    $0x10,%esp

	return;
  8008d6:	90                   	nop
}
  8008d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008da:	5b                   	pop    %ebx
  8008db:	5e                   	pop    %esi
  8008dc:	5f                   	pop    %edi
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8008e5:	e8 a4 16 00 00       	call   801f8e <sys_getenvindex>
  8008ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8008ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008f0:	89 d0                	mov    %edx,%eax
  8008f2:	c1 e0 03             	shl    $0x3,%eax
  8008f5:	01 d0                	add    %edx,%eax
  8008f7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8008fe:	01 c8                	add    %ecx,%eax
  800900:	01 c0                	add    %eax,%eax
  800902:	01 d0                	add    %edx,%eax
  800904:	01 c0                	add    %eax,%eax
  800906:	01 d0                	add    %edx,%eax
  800908:	89 c2                	mov    %eax,%edx
  80090a:	c1 e2 05             	shl    $0x5,%edx
  80090d:	29 c2                	sub    %eax,%edx
  80090f:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800916:	89 c2                	mov    %eax,%edx
  800918:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80091e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800923:	a1 20 30 80 00       	mov    0x803020,%eax
  800928:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80092e:	84 c0                	test   %al,%al
  800930:	74 0f                	je     800941 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800932:	a1 20 30 80 00       	mov    0x803020,%eax
  800937:	05 40 3c 01 00       	add    $0x13c40,%eax
  80093c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800941:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800945:	7e 0a                	jle    800951 <libmain+0x72>
		binaryname = argv[0];
  800947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	ff 75 08             	pushl  0x8(%ebp)
  80095a:	e8 d9 f6 ff ff       	call   800038 <_main>
  80095f:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800962:	e8 c2 17 00 00       	call   802129 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800967:	83 ec 0c             	sub    $0xc,%esp
  80096a:	68 98 29 80 00       	push   $0x802998
  80096f:	e8 84 01 00 00       	call   800af8 <cprintf>
  800974:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800977:	a1 20 30 80 00       	mov    0x803020,%eax
  80097c:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800982:	a1 20 30 80 00       	mov    0x803020,%eax
  800987:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80098d:	83 ec 04             	sub    $0x4,%esp
  800990:	52                   	push   %edx
  800991:	50                   	push   %eax
  800992:	68 c0 29 80 00       	push   $0x8029c0
  800997:	e8 5c 01 00 00       	call   800af8 <cprintf>
  80099c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80099f:	a1 20 30 80 00       	mov    0x803020,%eax
  8009a4:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8009aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8009af:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8009b5:	83 ec 04             	sub    $0x4,%esp
  8009b8:	52                   	push   %edx
  8009b9:	50                   	push   %eax
  8009ba:	68 e8 29 80 00       	push   $0x8029e8
  8009bf:	e8 34 01 00 00       	call   800af8 <cprintf>
  8009c4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8009cc:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8009d2:	83 ec 08             	sub    $0x8,%esp
  8009d5:	50                   	push   %eax
  8009d6:	68 29 2a 80 00       	push   $0x802a29
  8009db:	e8 18 01 00 00       	call   800af8 <cprintf>
  8009e0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e3:	83 ec 0c             	sub    $0xc,%esp
  8009e6:	68 98 29 80 00       	push   $0x802998
  8009eb:	e8 08 01 00 00       	call   800af8 <cprintf>
  8009f0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f3:	e8 4b 17 00 00       	call   802143 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8009f8:	e8 19 00 00 00       	call   800a16 <exit>
}
  8009fd:	90                   	nop
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    

00800a00 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800a06:	83 ec 0c             	sub    $0xc,%esp
  800a09:	6a 00                	push   $0x0
  800a0b:	e8 4a 15 00 00       	call   801f5a <sys_env_destroy>
  800a10:	83 c4 10             	add    $0x10,%esp
}
  800a13:	90                   	nop
  800a14:	c9                   	leave  
  800a15:	c3                   	ret    

00800a16 <exit>:

void
exit(void)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800a1c:	e8 9f 15 00 00       	call   801fc0 <sys_env_exit>
}
  800a21:	90                   	nop
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2d:	8b 00                	mov    (%eax),%eax
  800a2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800a32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a35:	89 0a                	mov    %ecx,(%edx)
  800a37:	8b 55 08             	mov    0x8(%ebp),%edx
  800a3a:	88 d1                	mov    %dl,%cl
  800a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a46:	8b 00                	mov    (%eax),%eax
  800a48:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a4d:	75 2c                	jne    800a7b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a4f:	a0 24 30 80 00       	mov    0x803024,%al
  800a54:	0f b6 c0             	movzbl %al,%eax
  800a57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5a:	8b 12                	mov    (%edx),%edx
  800a5c:	89 d1                	mov    %edx,%ecx
  800a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a61:	83 c2 08             	add    $0x8,%edx
  800a64:	83 ec 04             	sub    $0x4,%esp
  800a67:	50                   	push   %eax
  800a68:	51                   	push   %ecx
  800a69:	52                   	push   %edx
  800a6a:	e8 a9 14 00 00       	call   801f18 <sys_cputs>
  800a6f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7e:	8b 40 04             	mov    0x4(%eax),%eax
  800a81:	8d 50 01             	lea    0x1(%eax),%edx
  800a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a87:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a8a:	90                   	nop
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a96:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a9d:	00 00 00 
	b.cnt = 0;
  800aa0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800aa7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800aaa:	ff 75 0c             	pushl  0xc(%ebp)
  800aad:	ff 75 08             	pushl  0x8(%ebp)
  800ab0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ab6:	50                   	push   %eax
  800ab7:	68 24 0a 80 00       	push   $0x800a24
  800abc:	e8 11 02 00 00       	call   800cd2 <vprintfmt>
  800ac1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ac4:	a0 24 30 80 00       	mov    0x803024,%al
  800ac9:	0f b6 c0             	movzbl %al,%eax
  800acc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	50                   	push   %eax
  800ad6:	52                   	push   %edx
  800ad7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800add:	83 c0 08             	add    $0x8,%eax
  800ae0:	50                   	push   %eax
  800ae1:	e8 32 14 00 00       	call   801f18 <sys_cputs>
  800ae6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ae9:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800af0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800af6:	c9                   	leave  
  800af7:	c3                   	ret    

00800af8 <cprintf>:

int cprintf(const char *fmt, ...) {
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800afe:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800b05:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	ff 75 f4             	pushl  -0xc(%ebp)
  800b14:	50                   	push   %eax
  800b15:	e8 73 ff ff ff       	call   800a8d <vcprintf>
  800b1a:	83 c4 10             	add    $0x10,%esp
  800b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b23:	c9                   	leave  
  800b24:	c3                   	ret    

00800b25 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b2b:	e8 f9 15 00 00       	call   802129 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b30:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	83 ec 08             	sub    $0x8,%esp
  800b3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3f:	50                   	push   %eax
  800b40:	e8 48 ff ff ff       	call   800a8d <vcprintf>
  800b45:	83 c4 10             	add    $0x10,%esp
  800b48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800b4b:	e8 f3 15 00 00       	call   802143 <sys_enable_interrupt>
	return cnt;
  800b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	53                   	push   %ebx
  800b59:	83 ec 14             	sub    $0x14,%esp
  800b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b62:	8b 45 14             	mov    0x14(%ebp),%eax
  800b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b68:	8b 45 18             	mov    0x18(%ebp),%eax
  800b6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b70:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b73:	77 55                	ja     800bca <printnum+0x75>
  800b75:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b78:	72 05                	jb     800b7f <printnum+0x2a>
  800b7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b7d:	77 4b                	ja     800bca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b7f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b82:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b85:	8b 45 18             	mov    0x18(%ebp),%eax
  800b88:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8d:	52                   	push   %edx
  800b8e:	50                   	push   %eax
  800b8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b92:	ff 75 f0             	pushl  -0x10(%ebp)
  800b95:	e8 7e 1b 00 00       	call   802718 <__udivdi3>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	83 ec 04             	sub    $0x4,%esp
  800ba0:	ff 75 20             	pushl  0x20(%ebp)
  800ba3:	53                   	push   %ebx
  800ba4:	ff 75 18             	pushl  0x18(%ebp)
  800ba7:	52                   	push   %edx
  800ba8:	50                   	push   %eax
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	ff 75 08             	pushl  0x8(%ebp)
  800baf:	e8 a1 ff ff ff       	call   800b55 <printnum>
  800bb4:	83 c4 20             	add    $0x20,%esp
  800bb7:	eb 1a                	jmp    800bd3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bb9:	83 ec 08             	sub    $0x8,%esp
  800bbc:	ff 75 0c             	pushl  0xc(%ebp)
  800bbf:	ff 75 20             	pushl  0x20(%ebp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	ff d0                	call   *%eax
  800bc7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bca:	ff 4d 1c             	decl   0x1c(%ebp)
  800bcd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bd1:	7f e6                	jg     800bb9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bd3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be1:	53                   	push   %ebx
  800be2:	51                   	push   %ecx
  800be3:	52                   	push   %edx
  800be4:	50                   	push   %eax
  800be5:	e8 3e 1c 00 00       	call   802828 <__umoddi3>
  800bea:	83 c4 10             	add    $0x10,%esp
  800bed:	05 54 2c 80 00       	add    $0x802c54,%eax
  800bf2:	8a 00                	mov    (%eax),%al
  800bf4:	0f be c0             	movsbl %al,%eax
  800bf7:	83 ec 08             	sub    $0x8,%esp
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	50                   	push   %eax
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
}
  800c06:	90                   	nop
  800c07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c0f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c13:	7e 1c                	jle    800c31 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	8b 00                	mov    (%eax),%eax
  800c1a:	8d 50 08             	lea    0x8(%eax),%edx
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	89 10                	mov    %edx,(%eax)
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8b 00                	mov    (%eax),%eax
  800c27:	83 e8 08             	sub    $0x8,%eax
  800c2a:	8b 50 04             	mov    0x4(%eax),%edx
  800c2d:	8b 00                	mov    (%eax),%eax
  800c2f:	eb 40                	jmp    800c71 <getuint+0x65>
	else if (lflag)
  800c31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c35:	74 1e                	je     800c55 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	8b 00                	mov    (%eax),%eax
  800c3c:	8d 50 04             	lea    0x4(%eax),%edx
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	89 10                	mov    %edx,(%eax)
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8b 00                	mov    (%eax),%eax
  800c49:	83 e8 04             	sub    $0x4,%eax
  800c4c:	8b 00                	mov    (%eax),%eax
  800c4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c53:	eb 1c                	jmp    800c71 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8b 00                	mov    (%eax),%eax
  800c5a:	8d 50 04             	lea    0x4(%eax),%edx
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	89 10                	mov    %edx,(%eax)
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	8b 00                	mov    (%eax),%eax
  800c67:	83 e8 04             	sub    $0x4,%eax
  800c6a:	8b 00                	mov    (%eax),%eax
  800c6c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c76:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c7a:	7e 1c                	jle    800c98 <getint+0x25>
		return va_arg(*ap, long long);
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8b 00                	mov    (%eax),%eax
  800c81:	8d 50 08             	lea    0x8(%eax),%edx
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	89 10                	mov    %edx,(%eax)
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	83 e8 08             	sub    $0x8,%eax
  800c91:	8b 50 04             	mov    0x4(%eax),%edx
  800c94:	8b 00                	mov    (%eax),%eax
  800c96:	eb 38                	jmp    800cd0 <getint+0x5d>
	else if (lflag)
  800c98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9c:	74 1a                	je     800cb8 <getint+0x45>
		return va_arg(*ap, long);
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	8b 00                	mov    (%eax),%eax
  800ca3:	8d 50 04             	lea    0x4(%eax),%edx
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	89 10                	mov    %edx,(%eax)
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8b 00                	mov    (%eax),%eax
  800cb0:	83 e8 04             	sub    $0x4,%eax
  800cb3:	8b 00                	mov    (%eax),%eax
  800cb5:	99                   	cltd   
  800cb6:	eb 18                	jmp    800cd0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8b 00                	mov    (%eax),%eax
  800cbd:	8d 50 04             	lea    0x4(%eax),%edx
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 10                	mov    %edx,(%eax)
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8b 00                	mov    (%eax),%eax
  800cca:	83 e8 04             	sub    $0x4,%eax
  800ccd:	8b 00                	mov    (%eax),%eax
  800ccf:	99                   	cltd   
}
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    

00800cd2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cda:	eb 17                	jmp    800cf3 <vprintfmt+0x21>
			if (ch == '\0')
  800cdc:	85 db                	test   %ebx,%ebx
  800cde:	0f 84 af 03 00 00    	je     801093 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 0c             	pushl  0xc(%ebp)
  800cea:	53                   	push   %ebx
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	ff d0                	call   *%eax
  800cf0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf6:	8d 50 01             	lea    0x1(%eax),%edx
  800cf9:	89 55 10             	mov    %edx,0x10(%ebp)
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	0f b6 d8             	movzbl %al,%ebx
  800d01:	83 fb 25             	cmp    $0x25,%ebx
  800d04:	75 d6                	jne    800cdc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d06:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d0a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d11:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d18:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d1f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d26:	8b 45 10             	mov    0x10(%ebp),%eax
  800d29:	8d 50 01             	lea    0x1(%eax),%edx
  800d2c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	0f b6 d8             	movzbl %al,%ebx
  800d34:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d37:	83 f8 55             	cmp    $0x55,%eax
  800d3a:	0f 87 2b 03 00 00    	ja     80106b <vprintfmt+0x399>
  800d40:	8b 04 85 78 2c 80 00 	mov    0x802c78(,%eax,4),%eax
  800d47:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d49:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d4d:	eb d7                	jmp    800d26 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d4f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d53:	eb d1                	jmp    800d26 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d55:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d5f:	89 d0                	mov    %edx,%eax
  800d61:	c1 e0 02             	shl    $0x2,%eax
  800d64:	01 d0                	add    %edx,%eax
  800d66:	01 c0                	add    %eax,%eax
  800d68:	01 d8                	add    %ebx,%eax
  800d6a:	83 e8 30             	sub    $0x30,%eax
  800d6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d70:	8b 45 10             	mov    0x10(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d78:	83 fb 2f             	cmp    $0x2f,%ebx
  800d7b:	7e 3e                	jle    800dbb <vprintfmt+0xe9>
  800d7d:	83 fb 39             	cmp    $0x39,%ebx
  800d80:	7f 39                	jg     800dbb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d82:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d85:	eb d5                	jmp    800d5c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d87:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8a:	83 c0 04             	add    $0x4,%eax
  800d8d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d90:	8b 45 14             	mov    0x14(%ebp),%eax
  800d93:	83 e8 04             	sub    $0x4,%eax
  800d96:	8b 00                	mov    (%eax),%eax
  800d98:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d9b:	eb 1f                	jmp    800dbc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d9d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800da1:	79 83                	jns    800d26 <vprintfmt+0x54>
				width = 0;
  800da3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800daa:	e9 77 ff ff ff       	jmp    800d26 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800daf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800db6:	e9 6b ff ff ff       	jmp    800d26 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800dbb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800dbc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc0:	0f 89 60 ff ff ff    	jns    800d26 <vprintfmt+0x54>
				width = precision, precision = -1;
  800dc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dcc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800dd3:	e9 4e ff ff ff       	jmp    800d26 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dd8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ddb:	e9 46 ff ff ff       	jmp    800d26 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800de0:	8b 45 14             	mov    0x14(%ebp),%eax
  800de3:	83 c0 04             	add    $0x4,%eax
  800de6:	89 45 14             	mov    %eax,0x14(%ebp)
  800de9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dec:	83 e8 04             	sub    $0x4,%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	83 ec 08             	sub    $0x8,%esp
  800df4:	ff 75 0c             	pushl  0xc(%ebp)
  800df7:	50                   	push   %eax
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	ff d0                	call   *%eax
  800dfd:	83 c4 10             	add    $0x10,%esp
			break;
  800e00:	e9 89 02 00 00       	jmp    80108e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e05:	8b 45 14             	mov    0x14(%ebp),%eax
  800e08:	83 c0 04             	add    $0x4,%eax
  800e0b:	89 45 14             	mov    %eax,0x14(%ebp)
  800e0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e11:	83 e8 04             	sub    $0x4,%eax
  800e14:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e16:	85 db                	test   %ebx,%ebx
  800e18:	79 02                	jns    800e1c <vprintfmt+0x14a>
				err = -err;
  800e1a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e1c:	83 fb 64             	cmp    $0x64,%ebx
  800e1f:	7f 0b                	jg     800e2c <vprintfmt+0x15a>
  800e21:	8b 34 9d c0 2a 80 00 	mov    0x802ac0(,%ebx,4),%esi
  800e28:	85 f6                	test   %esi,%esi
  800e2a:	75 19                	jne    800e45 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e2c:	53                   	push   %ebx
  800e2d:	68 65 2c 80 00       	push   $0x802c65
  800e32:	ff 75 0c             	pushl  0xc(%ebp)
  800e35:	ff 75 08             	pushl  0x8(%ebp)
  800e38:	e8 5e 02 00 00       	call   80109b <printfmt>
  800e3d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e40:	e9 49 02 00 00       	jmp    80108e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e45:	56                   	push   %esi
  800e46:	68 6e 2c 80 00       	push   $0x802c6e
  800e4b:	ff 75 0c             	pushl  0xc(%ebp)
  800e4e:	ff 75 08             	pushl  0x8(%ebp)
  800e51:	e8 45 02 00 00       	call   80109b <printfmt>
  800e56:	83 c4 10             	add    $0x10,%esp
			break;
  800e59:	e9 30 02 00 00       	jmp    80108e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e61:	83 c0 04             	add    $0x4,%eax
  800e64:	89 45 14             	mov    %eax,0x14(%ebp)
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	83 e8 04             	sub    $0x4,%eax
  800e6d:	8b 30                	mov    (%eax),%esi
  800e6f:	85 f6                	test   %esi,%esi
  800e71:	75 05                	jne    800e78 <vprintfmt+0x1a6>
				p = "(null)";
  800e73:	be 71 2c 80 00       	mov    $0x802c71,%esi
			if (width > 0 && padc != '-')
  800e78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7c:	7e 6d                	jle    800eeb <vprintfmt+0x219>
  800e7e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e82:	74 67                	je     800eeb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e87:	83 ec 08             	sub    $0x8,%esp
  800e8a:	50                   	push   %eax
  800e8b:	56                   	push   %esi
  800e8c:	e8 0c 03 00 00       	call   80119d <strnlen>
  800e91:	83 c4 10             	add    $0x10,%esp
  800e94:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e97:	eb 16                	jmp    800eaf <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e99:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e9d:	83 ec 08             	sub    $0x8,%esp
  800ea0:	ff 75 0c             	pushl  0xc(%ebp)
  800ea3:	50                   	push   %eax
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	ff d0                	call   *%eax
  800ea9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eac:	ff 4d e4             	decl   -0x1c(%ebp)
  800eaf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eb3:	7f e4                	jg     800e99 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eb5:	eb 34                	jmp    800eeb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800eb7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ebb:	74 1c                	je     800ed9 <vprintfmt+0x207>
  800ebd:	83 fb 1f             	cmp    $0x1f,%ebx
  800ec0:	7e 05                	jle    800ec7 <vprintfmt+0x1f5>
  800ec2:	83 fb 7e             	cmp    $0x7e,%ebx
  800ec5:	7e 12                	jle    800ed9 <vprintfmt+0x207>
					putch('?', putdat);
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	6a 3f                	push   $0x3f
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	ff d0                	call   *%eax
  800ed4:	83 c4 10             	add    $0x10,%esp
  800ed7:	eb 0f                	jmp    800ee8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 0c             	pushl  0xc(%ebp)
  800edf:	53                   	push   %ebx
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	ff d0                	call   *%eax
  800ee5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ee8:	ff 4d e4             	decl   -0x1c(%ebp)
  800eeb:	89 f0                	mov    %esi,%eax
  800eed:	8d 70 01             	lea    0x1(%eax),%esi
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	0f be d8             	movsbl %al,%ebx
  800ef5:	85 db                	test   %ebx,%ebx
  800ef7:	74 24                	je     800f1d <vprintfmt+0x24b>
  800ef9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800efd:	78 b8                	js     800eb7 <vprintfmt+0x1e5>
  800eff:	ff 4d e0             	decl   -0x20(%ebp)
  800f02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f06:	79 af                	jns    800eb7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f08:	eb 13                	jmp    800f1d <vprintfmt+0x24b>
				putch(' ', putdat);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	6a 20                	push   $0x20
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	ff d0                	call   *%eax
  800f17:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f1a:	ff 4d e4             	decl   -0x1c(%ebp)
  800f1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f21:	7f e7                	jg     800f0a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f23:	e9 66 01 00 00       	jmp    80108e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f28:	83 ec 08             	sub    $0x8,%esp
  800f2b:	ff 75 e8             	pushl  -0x18(%ebp)
  800f2e:	8d 45 14             	lea    0x14(%ebp),%eax
  800f31:	50                   	push   %eax
  800f32:	e8 3c fd ff ff       	call   800c73 <getint>
  800f37:	83 c4 10             	add    $0x10,%esp
  800f3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f46:	85 d2                	test   %edx,%edx
  800f48:	79 23                	jns    800f6d <vprintfmt+0x29b>
				putch('-', putdat);
  800f4a:	83 ec 08             	sub    $0x8,%esp
  800f4d:	ff 75 0c             	pushl  0xc(%ebp)
  800f50:	6a 2d                	push   $0x2d
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	ff d0                	call   *%eax
  800f57:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f60:	f7 d8                	neg    %eax
  800f62:	83 d2 00             	adc    $0x0,%edx
  800f65:	f7 da                	neg    %edx
  800f67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f6d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f74:	e9 bc 00 00 00       	jmp    801035 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f79:	83 ec 08             	sub    $0x8,%esp
  800f7c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f82:	50                   	push   %eax
  800f83:	e8 84 fc ff ff       	call   800c0c <getuint>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f91:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f98:	e9 98 00 00 00       	jmp    801035 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	ff 75 0c             	pushl  0xc(%ebp)
  800fa3:	6a 58                	push   $0x58
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fad:	83 ec 08             	sub    $0x8,%esp
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	6a 58                	push   $0x58
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	ff d0                	call   *%eax
  800fba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fbd:	83 ec 08             	sub    $0x8,%esp
  800fc0:	ff 75 0c             	pushl  0xc(%ebp)
  800fc3:	6a 58                	push   $0x58
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	ff d0                	call   *%eax
  800fca:	83 c4 10             	add    $0x10,%esp
			break;
  800fcd:	e9 bc 00 00 00       	jmp    80108e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	6a 30                	push   $0x30
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	ff d0                	call   *%eax
  800fdf:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fe2:	83 ec 08             	sub    $0x8,%esp
  800fe5:	ff 75 0c             	pushl  0xc(%ebp)
  800fe8:	6a 78                	push   $0x78
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	ff d0                	call   *%eax
  800fef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ff2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff5:	83 c0 04             	add    $0x4,%eax
  800ff8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ffb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffe:	83 e8 04             	sub    $0x4,%eax
  801001:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801003:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801006:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80100d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801014:	eb 1f                	jmp    801035 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801016:	83 ec 08             	sub    $0x8,%esp
  801019:	ff 75 e8             	pushl  -0x18(%ebp)
  80101c:	8d 45 14             	lea    0x14(%ebp),%eax
  80101f:	50                   	push   %eax
  801020:	e8 e7 fb ff ff       	call   800c0c <getuint>
  801025:	83 c4 10             	add    $0x10,%esp
  801028:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80102b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80102e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801035:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801039:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80103c:	83 ec 04             	sub    $0x4,%esp
  80103f:	52                   	push   %edx
  801040:	ff 75 e4             	pushl  -0x1c(%ebp)
  801043:	50                   	push   %eax
  801044:	ff 75 f4             	pushl  -0xc(%ebp)
  801047:	ff 75 f0             	pushl  -0x10(%ebp)
  80104a:	ff 75 0c             	pushl  0xc(%ebp)
  80104d:	ff 75 08             	pushl  0x8(%ebp)
  801050:	e8 00 fb ff ff       	call   800b55 <printnum>
  801055:	83 c4 20             	add    $0x20,%esp
			break;
  801058:	eb 34                	jmp    80108e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	53                   	push   %ebx
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	ff d0                	call   *%eax
  801066:	83 c4 10             	add    $0x10,%esp
			break;
  801069:	eb 23                	jmp    80108e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80106b:	83 ec 08             	sub    $0x8,%esp
  80106e:	ff 75 0c             	pushl  0xc(%ebp)
  801071:	6a 25                	push   $0x25
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	ff d0                	call   *%eax
  801078:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80107b:	ff 4d 10             	decl   0x10(%ebp)
  80107e:	eb 03                	jmp    801083 <vprintfmt+0x3b1>
  801080:	ff 4d 10             	decl   0x10(%ebp)
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	48                   	dec    %eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	3c 25                	cmp    $0x25,%al
  80108b:	75 f3                	jne    801080 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80108d:	90                   	nop
		}
	}
  80108e:	e9 47 fc ff ff       	jmp    800cda <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801093:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801094:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801097:	5b                   	pop    %ebx
  801098:	5e                   	pop    %esi
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    

0080109b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b0:	50                   	push   %eax
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	e8 16 fc ff ff       	call   800cd2 <vprintfmt>
  8010bc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010bf:	90                   	nop
  8010c0:	c9                   	leave  
  8010c1:	c3                   	ret    

008010c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	8b 40 08             	mov    0x8(%eax),%eax
  8010cb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d7:	8b 10                	mov    (%eax),%edx
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	8b 40 04             	mov    0x4(%eax),%eax
  8010df:	39 c2                	cmp    %eax,%edx
  8010e1:	73 12                	jae    8010f5 <sprintputch+0x33>
		*b->buf++ = ch;
  8010e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e6:	8b 00                	mov    (%eax),%eax
  8010e8:	8d 48 01             	lea    0x1(%eax),%ecx
  8010eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ee:	89 0a                	mov    %ecx,(%edx)
  8010f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f3:	88 10                	mov    %dl,(%eax)
}
  8010f5:	90                   	nop
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    

008010f8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	01 d0                	add    %edx,%eax
  80110f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801112:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801119:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111d:	74 06                	je     801125 <vsnprintf+0x2d>
  80111f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801123:	7f 07                	jg     80112c <vsnprintf+0x34>
		return -E_INVAL;
  801125:	b8 03 00 00 00       	mov    $0x3,%eax
  80112a:	eb 20                	jmp    80114c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80112c:	ff 75 14             	pushl  0x14(%ebp)
  80112f:	ff 75 10             	pushl  0x10(%ebp)
  801132:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801135:	50                   	push   %eax
  801136:	68 c2 10 80 00       	push   $0x8010c2
  80113b:	e8 92 fb ff ff       	call   800cd2 <vprintfmt>
  801140:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801143:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801146:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801149:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801154:	8d 45 10             	lea    0x10(%ebp),%eax
  801157:	83 c0 04             	add    $0x4,%eax
  80115a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80115d:	8b 45 10             	mov    0x10(%ebp),%eax
  801160:	ff 75 f4             	pushl  -0xc(%ebp)
  801163:	50                   	push   %eax
  801164:	ff 75 0c             	pushl  0xc(%ebp)
  801167:	ff 75 08             	pushl  0x8(%ebp)
  80116a:	e8 89 ff ff ff       	call   8010f8 <vsnprintf>
  80116f:	83 c4 10             	add    $0x10,%esp
  801172:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801175:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801180:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801187:	eb 06                	jmp    80118f <strlen+0x15>
		n++;
  801189:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80118c:	ff 45 08             	incl   0x8(%ebp)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	84 c0                	test   %al,%al
  801196:	75 f1                	jne    801189 <strlen+0xf>
		n++;
	return n;
  801198:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    

0080119d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011aa:	eb 09                	jmp    8011b5 <strnlen+0x18>
		n++;
  8011ac:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011af:	ff 45 08             	incl   0x8(%ebp)
  8011b2:	ff 4d 0c             	decl   0xc(%ebp)
  8011b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b9:	74 09                	je     8011c4 <strnlen+0x27>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	84 c0                	test   %al,%al
  8011c2:	75 e8                	jne    8011ac <strnlen+0xf>
		n++;
	return n;
  8011c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011c7:	c9                   	leave  
  8011c8:	c3                   	ret    

008011c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011d5:	90                   	nop
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	8d 50 01             	lea    0x1(%eax),%edx
  8011dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8011df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011e5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011e8:	8a 12                	mov    (%edx),%dl
  8011ea:	88 10                	mov    %dl,(%eax)
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	84 c0                	test   %al,%al
  8011f0:	75 e4                	jne    8011d6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801203:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80120a:	eb 1f                	jmp    80122b <strncpy+0x34>
		*dst++ = *src;
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8d 50 01             	lea    0x1(%eax),%edx
  801212:	89 55 08             	mov    %edx,0x8(%ebp)
  801215:	8b 55 0c             	mov    0xc(%ebp),%edx
  801218:	8a 12                	mov    (%edx),%dl
  80121a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	84 c0                	test   %al,%al
  801223:	74 03                	je     801228 <strncpy+0x31>
			src++;
  801225:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801228:	ff 45 fc             	incl   -0x4(%ebp)
  80122b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801231:	72 d9                	jb     80120c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801233:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801248:	74 30                	je     80127a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80124a:	eb 16                	jmp    801262 <strlcpy+0x2a>
			*dst++ = *src++;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8d 50 01             	lea    0x1(%eax),%edx
  801252:	89 55 08             	mov    %edx,0x8(%ebp)
  801255:	8b 55 0c             	mov    0xc(%ebp),%edx
  801258:	8d 4a 01             	lea    0x1(%edx),%ecx
  80125b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80125e:	8a 12                	mov    (%edx),%dl
  801260:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801262:	ff 4d 10             	decl   0x10(%ebp)
  801265:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801269:	74 09                	je     801274 <strlcpy+0x3c>
  80126b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	84 c0                	test   %al,%al
  801272:	75 d8                	jne    80124c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80127a:	8b 55 08             	mov    0x8(%ebp),%edx
  80127d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801280:	29 c2                	sub    %eax,%edx
  801282:	89 d0                	mov    %edx,%eax
}
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801289:	eb 06                	jmp    801291 <strcmp+0xb>
		p++, q++;
  80128b:	ff 45 08             	incl   0x8(%ebp)
  80128e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	84 c0                	test   %al,%al
  801298:	74 0e                	je     8012a8 <strcmp+0x22>
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	8a 10                	mov    (%eax),%dl
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	38 c2                	cmp    %al,%dl
  8012a6:	74 e3                	je     80128b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	0f b6 d0             	movzbl %al,%edx
  8012b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	0f b6 c0             	movzbl %al,%eax
  8012b8:	29 c2                	sub    %eax,%edx
  8012ba:	89 d0                	mov    %edx,%eax
}
  8012bc:	5d                   	pop    %ebp
  8012bd:	c3                   	ret    

008012be <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8012c1:	eb 09                	jmp    8012cc <strncmp+0xe>
		n--, p++, q++;
  8012c3:	ff 4d 10             	decl   0x10(%ebp)
  8012c6:	ff 45 08             	incl   0x8(%ebp)
  8012c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d0:	74 17                	je     8012e9 <strncmp+0x2b>
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	8a 00                	mov    (%eax),%al
  8012d7:	84 c0                	test   %al,%al
  8012d9:	74 0e                	je     8012e9 <strncmp+0x2b>
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	8a 10                	mov    (%eax),%dl
  8012e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e3:	8a 00                	mov    (%eax),%al
  8012e5:	38 c2                	cmp    %al,%dl
  8012e7:	74 da                	je     8012c3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ed:	75 07                	jne    8012f6 <strncmp+0x38>
		return 0;
  8012ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f4:	eb 14                	jmp    80130a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	0f b6 d0             	movzbl %al,%edx
  8012fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801301:	8a 00                	mov    (%eax),%al
  801303:	0f b6 c0             	movzbl %al,%eax
  801306:	29 c2                	sub    %eax,%edx
  801308:	89 d0                	mov    %edx,%eax
}
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 04             	sub    $0x4,%esp
  801312:	8b 45 0c             	mov    0xc(%ebp),%eax
  801315:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801318:	eb 12                	jmp    80132c <strchr+0x20>
		if (*s == c)
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801322:	75 05                	jne    801329 <strchr+0x1d>
			return (char *) s;
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	eb 11                	jmp    80133a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801329:	ff 45 08             	incl   0x8(%ebp)
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	84 c0                	test   %al,%al
  801333:	75 e5                	jne    80131a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801335:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	83 ec 04             	sub    $0x4,%esp
  801342:	8b 45 0c             	mov    0xc(%ebp),%eax
  801345:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801348:	eb 0d                	jmp    801357 <strfind+0x1b>
		if (*s == c)
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801352:	74 0e                	je     801362 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801354:	ff 45 08             	incl   0x8(%ebp)
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	84 c0                	test   %al,%al
  80135e:	75 ea                	jne    80134a <strfind+0xe>
  801360:	eb 01                	jmp    801363 <strfind+0x27>
		if (*s == c)
			break;
  801362:	90                   	nop
	return (char *) s;
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801374:	8b 45 10             	mov    0x10(%ebp),%eax
  801377:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80137a:	eb 0e                	jmp    80138a <memset+0x22>
		*p++ = c;
  80137c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137f:	8d 50 01             	lea    0x1(%eax),%edx
  801382:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801385:	8b 55 0c             	mov    0xc(%ebp),%edx
  801388:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80138a:	ff 4d f8             	decl   -0x8(%ebp)
  80138d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801391:	79 e9                	jns    80137c <memset+0x14>
		*p++ = c;

	return v;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80139e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8013aa:	eb 16                	jmp    8013c2 <memcpy+0x2a>
		*d++ = *s++;
  8013ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013af:	8d 50 01             	lea    0x1(%eax),%edx
  8013b2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013bb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013be:	8a 12                	mov    (%edx),%dl
  8013c0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8013c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	75 dd                	jne    8013ac <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    

008013d4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8013e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013ec:	73 50                	jae    80143e <memmove+0x6a>
  8013ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f4:	01 d0                	add    %edx,%eax
  8013f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013f9:	76 43                	jbe    80143e <memmove+0x6a>
		s += n;
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801401:	8b 45 10             	mov    0x10(%ebp),%eax
  801404:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801407:	eb 10                	jmp    801419 <memmove+0x45>
			*--d = *--s;
  801409:	ff 4d f8             	decl   -0x8(%ebp)
  80140c:	ff 4d fc             	decl   -0x4(%ebp)
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	8a 10                	mov    (%eax),%dl
  801414:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801417:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801419:	8b 45 10             	mov    0x10(%ebp),%eax
  80141c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80141f:	89 55 10             	mov    %edx,0x10(%ebp)
  801422:	85 c0                	test   %eax,%eax
  801424:	75 e3                	jne    801409 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801426:	eb 23                	jmp    80144b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801428:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142b:	8d 50 01             	lea    0x1(%eax),%edx
  80142e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801431:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801434:	8d 4a 01             	lea    0x1(%edx),%ecx
  801437:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80143a:	8a 12                	mov    (%edx),%dl
  80143c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80143e:	8b 45 10             	mov    0x10(%ebp),%eax
  801441:	8d 50 ff             	lea    -0x1(%eax),%edx
  801444:	89 55 10             	mov    %edx,0x10(%ebp)
  801447:	85 c0                	test   %eax,%eax
  801449:	75 dd                	jne    801428 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801462:	eb 2a                	jmp    80148e <memcmp+0x3e>
		if (*s1 != *s2)
  801464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801467:	8a 10                	mov    (%eax),%dl
  801469:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	38 c2                	cmp    %al,%dl
  801470:	74 16                	je     801488 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801472:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	0f b6 d0             	movzbl %al,%edx
  80147a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	0f b6 c0             	movzbl %al,%eax
  801482:	29 c2                	sub    %eax,%edx
  801484:	89 d0                	mov    %edx,%eax
  801486:	eb 18                	jmp    8014a0 <memcmp+0x50>
		s1++, s2++;
  801488:	ff 45 fc             	incl   -0x4(%ebp)
  80148b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80148e:	8b 45 10             	mov    0x10(%ebp),%eax
  801491:	8d 50 ff             	lea    -0x1(%eax),%edx
  801494:	89 55 10             	mov    %edx,0x10(%ebp)
  801497:	85 c0                	test   %eax,%eax
  801499:	75 c9                	jne    801464 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80149b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8014a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ae:	01 d0                	add    %edx,%eax
  8014b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8014b3:	eb 15                	jmp    8014ca <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	0f b6 d0             	movzbl %al,%edx
  8014bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c0:	0f b6 c0             	movzbl %al,%eax
  8014c3:	39 c2                	cmp    %eax,%edx
  8014c5:	74 0d                	je     8014d4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014c7:	ff 45 08             	incl   0x8(%ebp)
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014d0:	72 e3                	jb     8014b5 <memfind+0x13>
  8014d2:	eb 01                	jmp    8014d5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014d4:	90                   	nop
	return (void *) s;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8014e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8014e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ee:	eb 03                	jmp    8014f3 <strtol+0x19>
		s++;
  8014f0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	3c 20                	cmp    $0x20,%al
  8014fa:	74 f4                	je     8014f0 <strtol+0x16>
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	3c 09                	cmp    $0x9,%al
  801503:	74 eb                	je     8014f0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8a 00                	mov    (%eax),%al
  80150a:	3c 2b                	cmp    $0x2b,%al
  80150c:	75 05                	jne    801513 <strtol+0x39>
		s++;
  80150e:	ff 45 08             	incl   0x8(%ebp)
  801511:	eb 13                	jmp    801526 <strtol+0x4c>
	else if (*s == '-')
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	8a 00                	mov    (%eax),%al
  801518:	3c 2d                	cmp    $0x2d,%al
  80151a:	75 0a                	jne    801526 <strtol+0x4c>
		s++, neg = 1;
  80151c:	ff 45 08             	incl   0x8(%ebp)
  80151f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801526:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152a:	74 06                	je     801532 <strtol+0x58>
  80152c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801530:	75 20                	jne    801552 <strtol+0x78>
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8a 00                	mov    (%eax),%al
  801537:	3c 30                	cmp    $0x30,%al
  801539:	75 17                	jne    801552 <strtol+0x78>
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	40                   	inc    %eax
  80153f:	8a 00                	mov    (%eax),%al
  801541:	3c 78                	cmp    $0x78,%al
  801543:	75 0d                	jne    801552 <strtol+0x78>
		s += 2, base = 16;
  801545:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801549:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801550:	eb 28                	jmp    80157a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801552:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801556:	75 15                	jne    80156d <strtol+0x93>
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	8a 00                	mov    (%eax),%al
  80155d:	3c 30                	cmp    $0x30,%al
  80155f:	75 0c                	jne    80156d <strtol+0x93>
		s++, base = 8;
  801561:	ff 45 08             	incl   0x8(%ebp)
  801564:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80156b:	eb 0d                	jmp    80157a <strtol+0xa0>
	else if (base == 0)
  80156d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801571:	75 07                	jne    80157a <strtol+0xa0>
		base = 10;
  801573:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	8a 00                	mov    (%eax),%al
  80157f:	3c 2f                	cmp    $0x2f,%al
  801581:	7e 19                	jle    80159c <strtol+0xc2>
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	3c 39                	cmp    $0x39,%al
  80158a:	7f 10                	jg     80159c <strtol+0xc2>
			dig = *s - '0';
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	0f be c0             	movsbl %al,%eax
  801594:	83 e8 30             	sub    $0x30,%eax
  801597:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80159a:	eb 42                	jmp    8015de <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	3c 60                	cmp    $0x60,%al
  8015a3:	7e 19                	jle    8015be <strtol+0xe4>
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	8a 00                	mov    (%eax),%al
  8015aa:	3c 7a                	cmp    $0x7a,%al
  8015ac:	7f 10                	jg     8015be <strtol+0xe4>
			dig = *s - 'a' + 10;
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	8a 00                	mov    (%eax),%al
  8015b3:	0f be c0             	movsbl %al,%eax
  8015b6:	83 e8 57             	sub    $0x57,%eax
  8015b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015bc:	eb 20                	jmp    8015de <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	8a 00                	mov    (%eax),%al
  8015c3:	3c 40                	cmp    $0x40,%al
  8015c5:	7e 39                	jle    801600 <strtol+0x126>
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	8a 00                	mov    (%eax),%al
  8015cc:	3c 5a                	cmp    $0x5a,%al
  8015ce:	7f 30                	jg     801600 <strtol+0x126>
			dig = *s - 'A' + 10;
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	8a 00                	mov    (%eax),%al
  8015d5:	0f be c0             	movsbl %al,%eax
  8015d8:	83 e8 37             	sub    $0x37,%eax
  8015db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8015de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015e4:	7d 19                	jge    8015ff <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8015e6:	ff 45 08             	incl   0x8(%ebp)
  8015e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ec:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015f0:	89 c2                	mov    %eax,%edx
  8015f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f5:	01 d0                	add    %edx,%eax
  8015f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015fa:	e9 7b ff ff ff       	jmp    80157a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015ff:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801600:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801604:	74 08                	je     80160e <strtol+0x134>
		*endptr = (char *) s;
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	8b 55 08             	mov    0x8(%ebp),%edx
  80160c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80160e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801612:	74 07                	je     80161b <strtol+0x141>
  801614:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801617:	f7 d8                	neg    %eax
  801619:	eb 03                	jmp    80161e <strtol+0x144>
  80161b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <ltostr>:

void
ltostr(long value, char *str)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801626:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80162d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801634:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801638:	79 13                	jns    80164d <ltostr+0x2d>
	{
		neg = 1;
  80163a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801641:	8b 45 0c             	mov    0xc(%ebp),%eax
  801644:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801647:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80164a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801655:	99                   	cltd   
  801656:	f7 f9                	idiv   %ecx
  801658:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80165b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165e:	8d 50 01             	lea    0x1(%eax),%edx
  801661:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801664:	89 c2                	mov    %eax,%edx
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	01 d0                	add    %edx,%eax
  80166b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80166e:	83 c2 30             	add    $0x30,%edx
  801671:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801673:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801676:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80167b:	f7 e9                	imul   %ecx
  80167d:	c1 fa 02             	sar    $0x2,%edx
  801680:	89 c8                	mov    %ecx,%eax
  801682:	c1 f8 1f             	sar    $0x1f,%eax
  801685:	29 c2                	sub    %eax,%edx
  801687:	89 d0                	mov    %edx,%eax
  801689:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80168c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80168f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801694:	f7 e9                	imul   %ecx
  801696:	c1 fa 02             	sar    $0x2,%edx
  801699:	89 c8                	mov    %ecx,%eax
  80169b:	c1 f8 1f             	sar    $0x1f,%eax
  80169e:	29 c2                	sub    %eax,%edx
  8016a0:	89 d0                	mov    %edx,%eax
  8016a2:	c1 e0 02             	shl    $0x2,%eax
  8016a5:	01 d0                	add    %edx,%eax
  8016a7:	01 c0                	add    %eax,%eax
  8016a9:	29 c1                	sub    %eax,%ecx
  8016ab:	89 ca                	mov    %ecx,%edx
  8016ad:	85 d2                	test   %edx,%edx
  8016af:	75 9c                	jne    80164d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8016b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8016b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016bb:	48                   	dec    %eax
  8016bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8016bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016c3:	74 3d                	je     801702 <ltostr+0xe2>
		start = 1 ;
  8016c5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8016cc:	eb 34                	jmp    801702 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8016ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	01 d0                	add    %edx,%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8016db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e1:	01 c2                	add    %eax,%edx
  8016e3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e9:	01 c8                	add    %ecx,%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8016ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f5:	01 c2                	add    %eax,%edx
  8016f7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8016fa:	88 02                	mov    %al,(%edx)
		start++ ;
  8016fc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016ff:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801705:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801708:	7c c4                	jl     8016ce <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80170a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80170d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801715:	90                   	nop
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80171e:	ff 75 08             	pushl  0x8(%ebp)
  801721:	e8 54 fa ff ff       	call   80117a <strlen>
  801726:	83 c4 04             	add    $0x4,%esp
  801729:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80172c:	ff 75 0c             	pushl  0xc(%ebp)
  80172f:	e8 46 fa ff ff       	call   80117a <strlen>
  801734:	83 c4 04             	add    $0x4,%esp
  801737:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80173a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801741:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801748:	eb 17                	jmp    801761 <strcconcat+0x49>
		final[s] = str1[s] ;
  80174a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80174d:	8b 45 10             	mov    0x10(%ebp),%eax
  801750:	01 c2                	add    %eax,%edx
  801752:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	01 c8                	add    %ecx,%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80175e:	ff 45 fc             	incl   -0x4(%ebp)
  801761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801764:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801767:	7c e1                	jl     80174a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801769:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801770:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801777:	eb 1f                	jmp    801798 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801779:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177c:	8d 50 01             	lea    0x1(%eax),%edx
  80177f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801782:	89 c2                	mov    %eax,%edx
  801784:	8b 45 10             	mov    0x10(%ebp),%eax
  801787:	01 c2                	add    %eax,%edx
  801789:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80178c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178f:	01 c8                	add    %ecx,%eax
  801791:	8a 00                	mov    (%eax),%al
  801793:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801795:	ff 45 f8             	incl   -0x8(%ebp)
  801798:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80179b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80179e:	7c d9                	jl     801779 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8017a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a6:	01 d0                	add    %edx,%eax
  8017a8:	c6 00 00             	movb   $0x0,(%eax)
}
  8017ab:	90                   	nop
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8017b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8017ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bd:	8b 00                	mov    (%eax),%eax
  8017bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c9:	01 d0                	add    %edx,%eax
  8017cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017d1:	eb 0c                	jmp    8017df <strsplit+0x31>
			*string++ = 0;
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	8d 50 01             	lea    0x1(%eax),%edx
  8017d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8017dc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8a 00                	mov    (%eax),%al
  8017e4:	84 c0                	test   %al,%al
  8017e6:	74 18                	je     801800 <strsplit+0x52>
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	8a 00                	mov    (%eax),%al
  8017ed:	0f be c0             	movsbl %al,%eax
  8017f0:	50                   	push   %eax
  8017f1:	ff 75 0c             	pushl  0xc(%ebp)
  8017f4:	e8 13 fb ff ff       	call   80130c <strchr>
  8017f9:	83 c4 08             	add    $0x8,%esp
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	75 d3                	jne    8017d3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	8a 00                	mov    (%eax),%al
  801805:	84 c0                	test   %al,%al
  801807:	74 5a                	je     801863 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801809:	8b 45 14             	mov    0x14(%ebp),%eax
  80180c:	8b 00                	mov    (%eax),%eax
  80180e:	83 f8 0f             	cmp    $0xf,%eax
  801811:	75 07                	jne    80181a <strsplit+0x6c>
		{
			return 0;
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
  801818:	eb 66                	jmp    801880 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80181a:	8b 45 14             	mov    0x14(%ebp),%eax
  80181d:	8b 00                	mov    (%eax),%eax
  80181f:	8d 48 01             	lea    0x1(%eax),%ecx
  801822:	8b 55 14             	mov    0x14(%ebp),%edx
  801825:	89 0a                	mov    %ecx,(%edx)
  801827:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80182e:	8b 45 10             	mov    0x10(%ebp),%eax
  801831:	01 c2                	add    %eax,%edx
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801838:	eb 03                	jmp    80183d <strsplit+0x8f>
			string++;
  80183a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	84 c0                	test   %al,%al
  801844:	74 8b                	je     8017d1 <strsplit+0x23>
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	0f be c0             	movsbl %al,%eax
  80184e:	50                   	push   %eax
  80184f:	ff 75 0c             	pushl  0xc(%ebp)
  801852:	e8 b5 fa ff ff       	call   80130c <strchr>
  801857:	83 c4 08             	add    $0x8,%esp
  80185a:	85 c0                	test   %eax,%eax
  80185c:	74 dc                	je     80183a <strsplit+0x8c>
			string++;
	}
  80185e:	e9 6e ff ff ff       	jmp    8017d1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801863:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801864:	8b 45 14             	mov    0x14(%ebp),%eax
  801867:	8b 00                	mov    (%eax),%eax
  801869:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801870:	8b 45 10             	mov    0x10(%ebp),%eax
  801873:	01 d0                	add    %edx,%eax
  801875:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80187b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801888:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  80188f:	8b 55 08             	mov    0x8(%ebp),%edx
  801892:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801895:	01 d0                	add    %edx,%eax
  801897:	48                   	dec    %eax
  801898:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80189b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80189e:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a3:	f7 75 ac             	divl   -0x54(%ebp)
  8018a6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8018a9:	29 d0                	sub    %edx,%eax
  8018ab:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8018ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8018b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8018bc:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8018c3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018ca:	eb 3f                	jmp    80190b <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8018cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018cf:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8018d6:	83 ec 04             	sub    $0x4,%esp
  8018d9:	50                   	push   %eax
  8018da:	ff 75 e8             	pushl  -0x18(%ebp)
  8018dd:	68 d0 2d 80 00       	push   $0x802dd0
  8018e2:	e8 11 f2 ff ff       	call   800af8 <cprintf>
  8018e7:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  8018ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ed:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	50                   	push   %eax
  8018f8:	ff 75 e8             	pushl  -0x18(%ebp)
  8018fb:	68 e5 2d 80 00       	push   $0x802de5
  801900:	e8 f3 f1 ff ff       	call   800af8 <cprintf>
  801905:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801908:	ff 45 e8             	incl   -0x18(%ebp)
  80190b:	a1 28 30 80 00       	mov    0x803028,%eax
  801910:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801913:	7c b7                	jl     8018cc <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801915:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  80191c:	e9 42 01 00 00       	jmp    801a63 <malloc+0x1e1>
		int flag0=1;
  801921:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801928:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80192b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80192e:	eb 6b                	jmp    80199b <malloc+0x119>
			for(int k=0;k<count;k++){
  801930:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801937:	eb 42                	jmp    80197b <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801939:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80193c:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801943:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801946:	39 c2                	cmp    %eax,%edx
  801948:	77 2e                	ja     801978 <malloc+0xf6>
  80194a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80194d:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801954:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801957:	39 c2                	cmp    %eax,%edx
  801959:	76 1d                	jbe    801978 <malloc+0xf6>
					ni=arr_add[k].end-i;
  80195b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80195e:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801965:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801968:	29 c2                	sub    %eax,%edx
  80196a:	89 d0                	mov    %edx,%eax
  80196c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  80196f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801976:	eb 0d                	jmp    801985 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801978:	ff 45 d8             	incl   -0x28(%ebp)
  80197b:	a1 28 30 80 00       	mov    0x803028,%eax
  801980:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801983:	7c b4                	jl     801939 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801985:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801989:	74 09                	je     801994 <malloc+0x112>
				flag0=0;
  80198b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801992:	eb 16                	jmp    8019aa <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801994:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  80199b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	01 c2                	add    %eax,%edx
  8019a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019a6:	39 c2                	cmp    %eax,%edx
  8019a8:	77 86                	ja     801930 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8019aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019ae:	0f 84 a2 00 00 00    	je     801a56 <malloc+0x1d4>

			int f=1;
  8019b4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  8019bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8019c1:	89 c8                	mov    %ecx,%eax
  8019c3:	01 c0                	add    %eax,%eax
  8019c5:	01 c8                	add    %ecx,%eax
  8019c7:	c1 e0 02             	shl    $0x2,%eax
  8019ca:	05 20 31 80 00       	add    $0x803120,%eax
  8019cf:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  8019d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8019da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019dd:	89 d0                	mov    %edx,%eax
  8019df:	01 c0                	add    %eax,%eax
  8019e1:	01 d0                	add    %edx,%eax
  8019e3:	c1 e0 02             	shl    $0x2,%eax
  8019e6:	05 24 31 80 00       	add    $0x803124,%eax
  8019eb:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  8019ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f0:	89 d0                	mov    %edx,%eax
  8019f2:	01 c0                	add    %eax,%eax
  8019f4:	01 d0                	add    %edx,%eax
  8019f6:	c1 e0 02             	shl    $0x2,%eax
  8019f9:	05 28 31 80 00       	add    $0x803128,%eax
  8019fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801a04:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801a07:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801a0e:	eb 36                	jmp    801a46 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801a10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	01 c2                	add    %eax,%edx
  801a18:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a1b:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801a22:	39 c2                	cmp    %eax,%edx
  801a24:	73 1d                	jae    801a43 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801a26:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a29:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a33:	29 c2                	sub    %eax,%edx
  801a35:	89 d0                	mov    %edx,%eax
  801a37:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801a3a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801a41:	eb 0d                	jmp    801a50 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801a43:	ff 45 d0             	incl   -0x30(%ebp)
  801a46:	a1 28 30 80 00       	mov    0x803028,%eax
  801a4b:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801a4e:	7c c0                	jl     801a10 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801a50:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a54:	75 1d                	jne    801a73 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801a56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a60:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801a63:	a1 04 30 80 00       	mov    0x803004,%eax
  801a68:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a6b:	0f 8c b0 fe ff ff    	jl     801921 <malloc+0x9f>
  801a71:	eb 01                	jmp    801a74 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801a73:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801a74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a78:	75 7a                	jne    801af4 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801a7a:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	01 d0                	add    %edx,%eax
  801a85:	48                   	dec    %eax
  801a86:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801a8b:	7c 0a                	jl     801a97 <malloc+0x215>
			return NULL;
  801a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a92:	e9 a4 02 00 00       	jmp    801d3b <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801a97:	a1 04 30 80 00       	mov    0x803004,%eax
  801a9c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801a9f:	a1 28 30 80 00       	mov    0x803028,%eax
  801aa4:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801aa7:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  801aae:	83 ec 08             	sub    $0x8,%esp
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	ff 75 a4             	pushl  -0x5c(%ebp)
  801ab7:	e8 04 06 00 00       	call   8020c0 <sys_allocateMem>
  801abc:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801abf:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	01 d0                	add    %edx,%eax
  801aca:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  801acf:	a1 28 30 80 00       	mov    0x803028,%eax
  801ad4:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801ada:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  801ae1:	a1 28 30 80 00       	mov    0x803028,%eax
  801ae6:	40                   	inc    %eax
  801ae7:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  801aec:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801aef:	e9 47 02 00 00       	jmp    801d3b <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801af4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801afb:	e9 ac 00 00 00       	jmp    801bac <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801b00:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801b03:	89 d0                	mov    %edx,%eax
  801b05:	01 c0                	add    %eax,%eax
  801b07:	01 d0                	add    %edx,%eax
  801b09:	c1 e0 02             	shl    $0x2,%eax
  801b0c:	05 24 31 80 00       	add    $0x803124,%eax
  801b11:	8b 00                	mov    (%eax),%eax
  801b13:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801b16:	eb 7e                	jmp    801b96 <malloc+0x314>
			int flag=0;
  801b18:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801b1f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801b26:	eb 57                	jmp    801b7f <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801b28:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b2b:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801b32:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b35:	39 c2                	cmp    %eax,%edx
  801b37:	77 1a                	ja     801b53 <malloc+0x2d1>
  801b39:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b3c:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801b43:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b46:	39 c2                	cmp    %eax,%edx
  801b48:	76 09                	jbe    801b53 <malloc+0x2d1>
								flag=1;
  801b4a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801b51:	eb 36                	jmp    801b89 <malloc+0x307>
			arr[i].space++;
  801b53:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801b56:	89 d0                	mov    %edx,%eax
  801b58:	01 c0                	add    %eax,%eax
  801b5a:	01 d0                	add    %edx,%eax
  801b5c:	c1 e0 02             	shl    $0x2,%eax
  801b5f:	05 28 31 80 00       	add    $0x803128,%eax
  801b64:	8b 00                	mov    (%eax),%eax
  801b66:	8d 48 01             	lea    0x1(%eax),%ecx
  801b69:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801b6c:	89 d0                	mov    %edx,%eax
  801b6e:	01 c0                	add    %eax,%eax
  801b70:	01 d0                	add    %edx,%eax
  801b72:	c1 e0 02             	shl    $0x2,%eax
  801b75:	05 28 31 80 00       	add    $0x803128,%eax
  801b7a:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801b7c:	ff 45 c0             	incl   -0x40(%ebp)
  801b7f:	a1 28 30 80 00       	mov    0x803028,%eax
  801b84:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801b87:	7c 9f                	jl     801b28 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801b89:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801b8d:	75 19                	jne    801ba8 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801b8f:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801b96:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801b99:	a1 04 30 80 00       	mov    0x803004,%eax
  801b9e:	39 c2                	cmp    %eax,%edx
  801ba0:	0f 82 72 ff ff ff    	jb     801b18 <malloc+0x296>
  801ba6:	eb 01                	jmp    801ba9 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801ba8:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801ba9:	ff 45 cc             	incl   -0x34(%ebp)
  801bac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801baf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bb2:	0f 8c 48 ff ff ff    	jl     801b00 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801bb8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801bbf:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801bc6:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801bcd:	eb 37                	jmp    801c06 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801bcf:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801bd2:	89 d0                	mov    %edx,%eax
  801bd4:	01 c0                	add    %eax,%eax
  801bd6:	01 d0                	add    %edx,%eax
  801bd8:	c1 e0 02             	shl    $0x2,%eax
  801bdb:	05 28 31 80 00       	add    $0x803128,%eax
  801be0:	8b 00                	mov    (%eax),%eax
  801be2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801be5:	7d 1c                	jge    801c03 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801be7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801bea:	89 d0                	mov    %edx,%eax
  801bec:	01 c0                	add    %eax,%eax
  801bee:	01 d0                	add    %edx,%eax
  801bf0:	c1 e0 02             	shl    $0x2,%eax
  801bf3:	05 28 31 80 00       	add    $0x803128,%eax
  801bf8:	8b 00                	mov    (%eax),%eax
  801bfa:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801bfd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801c00:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801c03:	ff 45 b4             	incl   -0x4c(%ebp)
  801c06:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801c09:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c0c:	7c c1                	jl     801bcf <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801c0e:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801c14:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801c17:	89 c8                	mov    %ecx,%eax
  801c19:	01 c0                	add    %eax,%eax
  801c1b:	01 c8                	add    %ecx,%eax
  801c1d:	c1 e0 02             	shl    $0x2,%eax
  801c20:	05 20 31 80 00       	add    $0x803120,%eax
  801c25:	8b 00                	mov    (%eax),%eax
  801c27:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801c2e:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801c34:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801c37:	89 c8                	mov    %ecx,%eax
  801c39:	01 c0                	add    %eax,%eax
  801c3b:	01 c8                	add    %ecx,%eax
  801c3d:	c1 e0 02             	shl    $0x2,%eax
  801c40:	05 24 31 80 00       	add    $0x803124,%eax
  801c45:	8b 00                	mov    (%eax),%eax
  801c47:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  801c4e:	a1 28 30 80 00       	mov    0x803028,%eax
  801c53:	40                   	inc    %eax
  801c54:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  801c59:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801c5c:	89 d0                	mov    %edx,%eax
  801c5e:	01 c0                	add    %eax,%eax
  801c60:	01 d0                	add    %edx,%eax
  801c62:	c1 e0 02             	shl    $0x2,%eax
  801c65:	05 20 31 80 00       	add    $0x803120,%eax
  801c6a:	8b 00                	mov    (%eax),%eax
  801c6c:	83 ec 08             	sub    $0x8,%esp
  801c6f:	ff 75 08             	pushl  0x8(%ebp)
  801c72:	50                   	push   %eax
  801c73:	e8 48 04 00 00       	call   8020c0 <sys_allocateMem>
  801c78:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801c7b:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801c82:	eb 78                	jmp    801cfc <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801c84:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801c87:	89 d0                	mov    %edx,%eax
  801c89:	01 c0                	add    %eax,%eax
  801c8b:	01 d0                	add    %edx,%eax
  801c8d:	c1 e0 02             	shl    $0x2,%eax
  801c90:	05 20 31 80 00       	add    $0x803120,%eax
  801c95:	8b 00                	mov    (%eax),%eax
  801c97:	83 ec 04             	sub    $0x4,%esp
  801c9a:	50                   	push   %eax
  801c9b:	ff 75 b0             	pushl  -0x50(%ebp)
  801c9e:	68 d0 2d 80 00       	push   $0x802dd0
  801ca3:	e8 50 ee ff ff       	call   800af8 <cprintf>
  801ca8:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801cab:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801cae:	89 d0                	mov    %edx,%eax
  801cb0:	01 c0                	add    %eax,%eax
  801cb2:	01 d0                	add    %edx,%eax
  801cb4:	c1 e0 02             	shl    $0x2,%eax
  801cb7:	05 24 31 80 00       	add    $0x803124,%eax
  801cbc:	8b 00                	mov    (%eax),%eax
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	50                   	push   %eax
  801cc2:	ff 75 b0             	pushl  -0x50(%ebp)
  801cc5:	68 e5 2d 80 00       	push   $0x802de5
  801cca:	e8 29 ee ff ff       	call   800af8 <cprintf>
  801ccf:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801cd2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801cd5:	89 d0                	mov    %edx,%eax
  801cd7:	01 c0                	add    %eax,%eax
  801cd9:	01 d0                	add    %edx,%eax
  801cdb:	c1 e0 02             	shl    $0x2,%eax
  801cde:	05 28 31 80 00       	add    $0x803128,%eax
  801ce3:	8b 00                	mov    (%eax),%eax
  801ce5:	83 ec 04             	sub    $0x4,%esp
  801ce8:	50                   	push   %eax
  801ce9:	ff 75 b0             	pushl  -0x50(%ebp)
  801cec:	68 f8 2d 80 00       	push   $0x802df8
  801cf1:	e8 02 ee ff ff       	call   800af8 <cprintf>
  801cf6:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801cf9:	ff 45 b0             	incl   -0x50(%ebp)
  801cfc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801cff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d02:	7c 80                	jl     801c84 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801d04:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801d07:	89 d0                	mov    %edx,%eax
  801d09:	01 c0                	add    %eax,%eax
  801d0b:	01 d0                	add    %edx,%eax
  801d0d:	c1 e0 02             	shl    $0x2,%eax
  801d10:	05 20 31 80 00       	add    $0x803120,%eax
  801d15:	8b 00                	mov    (%eax),%eax
  801d17:	83 ec 08             	sub    $0x8,%esp
  801d1a:	50                   	push   %eax
  801d1b:	68 0c 2e 80 00       	push   $0x802e0c
  801d20:	e8 d3 ed ff ff       	call   800af8 <cprintf>
  801d25:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801d28:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801d2b:	89 d0                	mov    %edx,%eax
  801d2d:	01 c0                	add    %eax,%eax
  801d2f:	01 d0                	add    %edx,%eax
  801d31:	c1 e0 02             	shl    $0x2,%eax
  801d34:	05 20 31 80 00       	add    $0x803120,%eax
  801d39:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801d49:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801d50:	eb 4b                	jmp    801d9d <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801d52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d55:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801d5c:	89 c2                	mov    %eax,%edx
  801d5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d61:	39 c2                	cmp    %eax,%edx
  801d63:	7f 35                	jg     801d9a <free+0x5d>
  801d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d68:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801d6f:	89 c2                	mov    %eax,%edx
  801d71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d74:	39 c2                	cmp    %eax,%edx
  801d76:	7e 22                	jle    801d9a <free+0x5d>
				start=arr_add[i].start;
  801d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7b:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801d85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d88:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801d8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d95:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801d98:	eb 0d                	jmp    801da7 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801d9a:	ff 45 ec             	incl   -0x14(%ebp)
  801d9d:	a1 28 30 80 00       	mov    0x803028,%eax
  801da2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801da5:	7c ab                	jl     801d52 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801daa:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db4:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801dbb:	29 c2                	sub    %eax,%edx
  801dbd:	89 d0                	mov    %edx,%eax
  801dbf:	83 ec 08             	sub    $0x8,%esp
  801dc2:	50                   	push   %eax
  801dc3:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc6:	e8 d9 02 00 00       	call   8020a4 <sys_freeMem>
  801dcb:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801dd4:	eb 2d                	jmp    801e03 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801dd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dd9:	40                   	inc    %eax
  801dda:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801de1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801de4:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801deb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dee:	40                   	inc    %eax
  801def:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801df9:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801e00:	ff 45 e8             	incl   -0x18(%ebp)
  801e03:	a1 28 30 80 00       	mov    0x803028,%eax
  801e08:	48                   	dec    %eax
  801e09:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e0c:	7f c8                	jg     801dd6 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801e0e:	a1 28 30 80 00       	mov    0x803028,%eax
  801e13:	48                   	dec    %eax
  801e14:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801e19:	90                   	nop
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 18             	sub    $0x18,%esp
  801e22:	8b 45 10             	mov    0x10(%ebp),%eax
  801e25:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801e28:	83 ec 04             	sub    $0x4,%esp
  801e2b:	68 28 2e 80 00       	push   $0x802e28
  801e30:	68 18 01 00 00       	push   $0x118
  801e35:	68 4b 2e 80 00       	push   $0x802e4b
  801e3a:	e8 0b 07 00 00       	call   80254a <_panic>

00801e3f <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e45:	83 ec 04             	sub    $0x4,%esp
  801e48:	68 28 2e 80 00       	push   $0x802e28
  801e4d:	68 1e 01 00 00       	push   $0x11e
  801e52:	68 4b 2e 80 00       	push   $0x802e4b
  801e57:	e8 ee 06 00 00       	call   80254a <_panic>

00801e5c <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e62:	83 ec 04             	sub    $0x4,%esp
  801e65:	68 28 2e 80 00       	push   $0x802e28
  801e6a:	68 24 01 00 00       	push   $0x124
  801e6f:	68 4b 2e 80 00       	push   $0x802e4b
  801e74:	e8 d1 06 00 00       	call   80254a <_panic>

00801e79 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e7f:	83 ec 04             	sub    $0x4,%esp
  801e82:	68 28 2e 80 00       	push   $0x802e28
  801e87:	68 29 01 00 00       	push   $0x129
  801e8c:	68 4b 2e 80 00       	push   $0x802e4b
  801e91:	e8 b4 06 00 00       	call   80254a <_panic>

00801e96 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e9c:	83 ec 04             	sub    $0x4,%esp
  801e9f:	68 28 2e 80 00       	push   $0x802e28
  801ea4:	68 2f 01 00 00       	push   $0x12f
  801ea9:	68 4b 2e 80 00       	push   $0x802e4b
  801eae:	e8 97 06 00 00       	call   80254a <_panic>

00801eb3 <shrink>:
}
void shrink(uint32 newSize)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801eb9:	83 ec 04             	sub    $0x4,%esp
  801ebc:	68 28 2e 80 00       	push   $0x802e28
  801ec1:	68 33 01 00 00       	push   $0x133
  801ec6:	68 4b 2e 80 00       	push   $0x802e4b
  801ecb:	e8 7a 06 00 00       	call   80254a <_panic>

00801ed0 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ed6:	83 ec 04             	sub    $0x4,%esp
  801ed9:	68 28 2e 80 00       	push   $0x802e28
  801ede:	68 38 01 00 00       	push   $0x138
  801ee3:	68 4b 2e 80 00       	push   $0x802e4b
  801ee8:	e8 5d 06 00 00       	call   80254a <_panic>

00801eed <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
  801ef0:	57                   	push   %edi
  801ef1:	56                   	push   %esi
  801ef2:	53                   	push   %ebx
  801ef3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f02:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f05:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f08:	cd 30                	int    $0x30
  801f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	5b                   	pop    %ebx
  801f14:	5e                   	pop    %esi
  801f15:	5f                   	pop    %edi
  801f16:	5d                   	pop    %ebp
  801f17:	c3                   	ret    

00801f18 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	83 ec 04             	sub    $0x4,%esp
  801f1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f21:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f24:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	52                   	push   %edx
  801f30:	ff 75 0c             	pushl  0xc(%ebp)
  801f33:	50                   	push   %eax
  801f34:	6a 00                	push   $0x0
  801f36:	e8 b2 ff ff ff       	call   801eed <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
}
  801f3e:	90                   	nop
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 01                	push   $0x1
  801f50:	e8 98 ff ff ff       	call   801eed <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	50                   	push   %eax
  801f69:	6a 05                	push   $0x5
  801f6b:	e8 7d ff ff ff       	call   801eed <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 02                	push   $0x2
  801f84:	e8 64 ff ff ff       	call   801eed <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 03                	push   $0x3
  801f9d:	e8 4b ff ff ff       	call   801eed <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 04                	push   $0x4
  801fb6:	e8 32 ff ff ff       	call   801eed <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <sys_env_exit>:


void sys_env_exit(void)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 06                	push   $0x6
  801fcf:	e8 19 ff ff ff       	call   801eed <syscall>
  801fd4:	83 c4 18             	add    $0x18,%esp
}
  801fd7:	90                   	nop
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	52                   	push   %edx
  801fea:	50                   	push   %eax
  801feb:	6a 07                	push   $0x7
  801fed:	e8 fb fe ff ff       	call   801eed <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	56                   	push   %esi
  801ffb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ffc:	8b 75 18             	mov    0x18(%ebp),%esi
  801fff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802002:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802005:	8b 55 0c             	mov    0xc(%ebp),%edx
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	56                   	push   %esi
  80200c:	53                   	push   %ebx
  80200d:	51                   	push   %ecx
  80200e:	52                   	push   %edx
  80200f:	50                   	push   %eax
  802010:	6a 08                	push   $0x8
  802012:	e8 d6 fe ff ff       	call   801eed <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
}
  80201a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80201d:	5b                   	pop    %ebx
  80201e:	5e                   	pop    %esi
  80201f:	5d                   	pop    %ebp
  802020:	c3                   	ret    

00802021 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802024:	8b 55 0c             	mov    0xc(%ebp),%edx
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	52                   	push   %edx
  802031:	50                   	push   %eax
  802032:	6a 09                	push   $0x9
  802034:	e8 b4 fe ff ff       	call   801eed <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	ff 75 0c             	pushl  0xc(%ebp)
  80204a:	ff 75 08             	pushl  0x8(%ebp)
  80204d:	6a 0a                	push   $0xa
  80204f:	e8 99 fe ff ff       	call   801eed <syscall>
  802054:	83 c4 18             	add    $0x18,%esp
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 0b                	push   $0xb
  802068:	e8 80 fe ff ff       	call   801eed <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
}
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 0c                	push   $0xc
  802081:	e8 67 fe ff ff       	call   801eed <syscall>
  802086:	83 c4 18             	add    $0x18,%esp
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 0d                	push   $0xd
  80209a:	e8 4e fe ff ff       	call   801eed <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
}
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	ff 75 0c             	pushl  0xc(%ebp)
  8020b0:	ff 75 08             	pushl  0x8(%ebp)
  8020b3:	6a 11                	push   $0x11
  8020b5:	e8 33 fe ff ff       	call   801eed <syscall>
  8020ba:	83 c4 18             	add    $0x18,%esp
	return;
  8020bd:	90                   	nop
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	ff 75 0c             	pushl  0xc(%ebp)
  8020cc:	ff 75 08             	pushl  0x8(%ebp)
  8020cf:	6a 12                	push   $0x12
  8020d1:	e8 17 fe ff ff       	call   801eed <syscall>
  8020d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d9:	90                   	nop
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 0e                	push   $0xe
  8020eb:	e8 fd fd ff ff       	call   801eed <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	ff 75 08             	pushl  0x8(%ebp)
  802103:	6a 0f                	push   $0xf
  802105:	e8 e3 fd ff ff       	call   801eed <syscall>
  80210a:	83 c4 18             	add    $0x18,%esp
}
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 10                	push   $0x10
  80211e:	e8 ca fd ff ff       	call   801eed <syscall>
  802123:	83 c4 18             	add    $0x18,%esp
}
  802126:	90                   	nop
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 14                	push   $0x14
  802138:	e8 b0 fd ff ff       	call   801eed <syscall>
  80213d:	83 c4 18             	add    $0x18,%esp
}
  802140:	90                   	nop
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 15                	push   $0x15
  802152:	e8 96 fd ff ff       	call   801eed <syscall>
  802157:	83 c4 18             	add    $0x18,%esp
}
  80215a:	90                   	nop
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <sys_cputc>:


void
sys_cputc(const char c)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 04             	sub    $0x4,%esp
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802169:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	50                   	push   %eax
  802176:	6a 16                	push   $0x16
  802178:	e8 70 fd ff ff       	call   801eed <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
}
  802180:	90                   	nop
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 17                	push   $0x17
  802192:	e8 56 fd ff ff       	call   801eed <syscall>
  802197:	83 c4 18             	add    $0x18,%esp
}
  80219a:	90                   	nop
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	ff 75 0c             	pushl  0xc(%ebp)
  8021ac:	50                   	push   %eax
  8021ad:	6a 18                	push   $0x18
  8021af:	e8 39 fd ff ff       	call   801eed <syscall>
  8021b4:	83 c4 18             	add    $0x18,%esp
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	52                   	push   %edx
  8021c9:	50                   	push   %eax
  8021ca:	6a 1b                	push   $0x1b
  8021cc:	e8 1c fd ff ff       	call   801eed <syscall>
  8021d1:	83 c4 18             	add    $0x18,%esp
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	52                   	push   %edx
  8021e6:	50                   	push   %eax
  8021e7:	6a 19                	push   $0x19
  8021e9:	e8 ff fc ff ff       	call   801eed <syscall>
  8021ee:	83 c4 18             	add    $0x18,%esp
}
  8021f1:	90                   	nop
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	52                   	push   %edx
  802204:	50                   	push   %eax
  802205:	6a 1a                	push   $0x1a
  802207:	e8 e1 fc ff ff       	call   801eed <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	90                   	nop
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 04             	sub    $0x4,%esp
  802218:	8b 45 10             	mov    0x10(%ebp),%eax
  80221b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80221e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802221:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	6a 00                	push   $0x0
  80222a:	51                   	push   %ecx
  80222b:	52                   	push   %edx
  80222c:	ff 75 0c             	pushl  0xc(%ebp)
  80222f:	50                   	push   %eax
  802230:	6a 1c                	push   $0x1c
  802232:	e8 b6 fc ff ff       	call   801eed <syscall>
  802237:	83 c4 18             	add    $0x18,%esp
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80223f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	52                   	push   %edx
  80224c:	50                   	push   %eax
  80224d:	6a 1d                	push   $0x1d
  80224f:	e8 99 fc ff ff       	call   801eed <syscall>
  802254:	83 c4 18             	add    $0x18,%esp
}
  802257:	c9                   	leave  
  802258:	c3                   	ret    

00802259 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80225c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80225f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	51                   	push   %ecx
  80226a:	52                   	push   %edx
  80226b:	50                   	push   %eax
  80226c:	6a 1e                	push   $0x1e
  80226e:	e8 7a fc ff ff       	call   801eed <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
}
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80227b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	52                   	push   %edx
  802288:	50                   	push   %eax
  802289:	6a 1f                	push   $0x1f
  80228b:	e8 5d fc ff ff       	call   801eed <syscall>
  802290:	83 c4 18             	add    $0x18,%esp
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 20                	push   $0x20
  8022a4:	e8 44 fc ff ff       	call   801eed <syscall>
  8022a9:	83 c4 18             	add    $0x18,%esp
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	6a 00                	push   $0x0
  8022b6:	ff 75 14             	pushl  0x14(%ebp)
  8022b9:	ff 75 10             	pushl  0x10(%ebp)
  8022bc:	ff 75 0c             	pushl  0xc(%ebp)
  8022bf:	50                   	push   %eax
  8022c0:	6a 21                	push   $0x21
  8022c2:	e8 26 fc ff ff       	call   801eed <syscall>
  8022c7:	83 c4 18             	add    $0x18,%esp
}
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	50                   	push   %eax
  8022db:	6a 22                	push   $0x22
  8022dd:	e8 0b fc ff ff       	call   801eed <syscall>
  8022e2:	83 c4 18             	add    $0x18,%esp
}
  8022e5:	90                   	nop
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	50                   	push   %eax
  8022f7:	6a 23                	push   $0x23
  8022f9:	e8 ef fb ff ff       	call   801eed <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
}
  802301:	90                   	nop
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
  802307:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80230a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80230d:	8d 50 04             	lea    0x4(%eax),%edx
  802310:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	52                   	push   %edx
  80231a:	50                   	push   %eax
  80231b:	6a 24                	push   $0x24
  80231d:	e8 cb fb ff ff       	call   801eed <syscall>
  802322:	83 c4 18             	add    $0x18,%esp
	return result;
  802325:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802328:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80232b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80232e:	89 01                	mov    %eax,(%ecx)
  802330:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	c9                   	leave  
  802337:	c2 04 00             	ret    $0x4

0080233a <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	ff 75 10             	pushl  0x10(%ebp)
  802344:	ff 75 0c             	pushl  0xc(%ebp)
  802347:	ff 75 08             	pushl  0x8(%ebp)
  80234a:	6a 13                	push   $0x13
  80234c:	e8 9c fb ff ff       	call   801eed <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
	return ;
  802354:	90                   	nop
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <sys_rcr2>:
uint32 sys_rcr2()
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 25                	push   $0x25
  802366:	e8 82 fb ff ff       	call   801eed <syscall>
  80236b:	83 c4 18             	add    $0x18,%esp
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 04             	sub    $0x4,%esp
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80237c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	50                   	push   %eax
  802389:	6a 26                	push   $0x26
  80238b:	e8 5d fb ff ff       	call   801eed <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
	return ;
  802393:	90                   	nop
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <rsttst>:
void rsttst()
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 28                	push   $0x28
  8023a5:	e8 43 fb ff ff       	call   801eed <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ad:	90                   	nop
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 04             	sub    $0x4,%esp
  8023b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023bc:	8b 55 18             	mov    0x18(%ebp),%edx
  8023bf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023c3:	52                   	push   %edx
  8023c4:	50                   	push   %eax
  8023c5:	ff 75 10             	pushl  0x10(%ebp)
  8023c8:	ff 75 0c             	pushl  0xc(%ebp)
  8023cb:	ff 75 08             	pushl  0x8(%ebp)
  8023ce:	6a 27                	push   $0x27
  8023d0:	e8 18 fb ff ff       	call   801eed <syscall>
  8023d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d8:	90                   	nop
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <chktst>:
void chktst(uint32 n)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	ff 75 08             	pushl  0x8(%ebp)
  8023e9:	6a 29                	push   $0x29
  8023eb:	e8 fd fa ff ff       	call   801eed <syscall>
  8023f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f3:	90                   	nop
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <inctst>:

void inctst()
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 2a                	push   $0x2a
  802405:	e8 e3 fa ff ff       	call   801eed <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
	return ;
  80240d:	90                   	nop
}
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <gettst>:
uint32 gettst()
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 2b                	push   $0x2b
  80241f:	e8 c9 fa ff ff       	call   801eed <syscall>
  802424:	83 c4 18             	add    $0x18,%esp
}
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
  80242c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 2c                	push   $0x2c
  80243b:	e8 ad fa ff ff       	call   801eed <syscall>
  802440:	83 c4 18             	add    $0x18,%esp
  802443:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802446:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80244a:	75 07                	jne    802453 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80244c:	b8 01 00 00 00       	mov    $0x1,%eax
  802451:	eb 05                	jmp    802458 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 2c                	push   $0x2c
  80246c:	e8 7c fa ff ff       	call   801eed <syscall>
  802471:	83 c4 18             	add    $0x18,%esp
  802474:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802477:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80247b:	75 07                	jne    802484 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80247d:	b8 01 00 00 00       	mov    $0x1,%eax
  802482:	eb 05                	jmp    802489 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802484:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
  80248e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 2c                	push   $0x2c
  80249d:	e8 4b fa ff ff       	call   801eed <syscall>
  8024a2:	83 c4 18             	add    $0x18,%esp
  8024a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024a8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024ac:	75 07                	jne    8024b5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b3:	eb 05                	jmp    8024ba <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 2c                	push   $0x2c
  8024ce:	e8 1a fa ff ff       	call   801eed <syscall>
  8024d3:	83 c4 18             	add    $0x18,%esp
  8024d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024d9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024dd:	75 07                	jne    8024e6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024df:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e4:	eb 05                	jmp    8024eb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	ff 75 08             	pushl  0x8(%ebp)
  8024fb:	6a 2d                	push   $0x2d
  8024fd:	e8 eb f9 ff ff       	call   801eed <syscall>
  802502:	83 c4 18             	add    $0x18,%esp
	return ;
  802505:	90                   	nop
}
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
  80250b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80250c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80250f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802512:	8b 55 0c             	mov    0xc(%ebp),%edx
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	6a 00                	push   $0x0
  80251a:	53                   	push   %ebx
  80251b:	51                   	push   %ecx
  80251c:	52                   	push   %edx
  80251d:	50                   	push   %eax
  80251e:	6a 2e                	push   $0x2e
  802520:	e8 c8 f9 ff ff       	call   801eed <syscall>
  802525:	83 c4 18             	add    $0x18,%esp
}
  802528:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802530:	8b 55 0c             	mov    0xc(%ebp),%edx
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	52                   	push   %edx
  80253d:	50                   	push   %eax
  80253e:	6a 2f                	push   $0x2f
  802540:	e8 a8 f9 ff ff       	call   801eed <syscall>
  802545:	83 c4 18             	add    $0x18,%esp
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
  80254d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802550:	8d 45 10             	lea    0x10(%ebp),%eax
  802553:	83 c0 04             	add    $0x4,%eax
  802556:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802559:	a1 60 3e 83 00       	mov    0x833e60,%eax
  80255e:	85 c0                	test   %eax,%eax
  802560:	74 16                	je     802578 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802562:	a1 60 3e 83 00       	mov    0x833e60,%eax
  802567:	83 ec 08             	sub    $0x8,%esp
  80256a:	50                   	push   %eax
  80256b:	68 58 2e 80 00       	push   $0x802e58
  802570:	e8 83 e5 ff ff       	call   800af8 <cprintf>
  802575:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802578:	a1 00 30 80 00       	mov    0x803000,%eax
  80257d:	ff 75 0c             	pushl  0xc(%ebp)
  802580:	ff 75 08             	pushl  0x8(%ebp)
  802583:	50                   	push   %eax
  802584:	68 5d 2e 80 00       	push   $0x802e5d
  802589:	e8 6a e5 ff ff       	call   800af8 <cprintf>
  80258e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802591:	8b 45 10             	mov    0x10(%ebp),%eax
  802594:	83 ec 08             	sub    $0x8,%esp
  802597:	ff 75 f4             	pushl  -0xc(%ebp)
  80259a:	50                   	push   %eax
  80259b:	e8 ed e4 ff ff       	call   800a8d <vcprintf>
  8025a0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8025a3:	83 ec 08             	sub    $0x8,%esp
  8025a6:	6a 00                	push   $0x0
  8025a8:	68 79 2e 80 00       	push   $0x802e79
  8025ad:	e8 db e4 ff ff       	call   800a8d <vcprintf>
  8025b2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8025b5:	e8 5c e4 ff ff       	call   800a16 <exit>

	// should not return here
	while (1) ;
  8025ba:	eb fe                	jmp    8025ba <_panic+0x70>

008025bc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8025bc:	55                   	push   %ebp
  8025bd:	89 e5                	mov    %esp,%ebp
  8025bf:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8025c2:	a1 20 30 80 00       	mov    0x803020,%eax
  8025c7:	8b 50 74             	mov    0x74(%eax),%edx
  8025ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025cd:	39 c2                	cmp    %eax,%edx
  8025cf:	74 14                	je     8025e5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8025d1:	83 ec 04             	sub    $0x4,%esp
  8025d4:	68 7c 2e 80 00       	push   $0x802e7c
  8025d9:	6a 26                	push   $0x26
  8025db:	68 c8 2e 80 00       	push   $0x802ec8
  8025e0:	e8 65 ff ff ff       	call   80254a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8025e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8025ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8025f3:	e9 b6 00 00 00       	jmp    8026ae <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8025f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802602:	8b 45 08             	mov    0x8(%ebp),%eax
  802605:	01 d0                	add    %edx,%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	75 08                	jne    802615 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80260d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802610:	e9 96 00 00 00       	jmp    8026ab <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  802615:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80261c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802623:	eb 5d                	jmp    802682 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802625:	a1 20 30 80 00       	mov    0x803020,%eax
  80262a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802630:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802633:	c1 e2 04             	shl    $0x4,%edx
  802636:	01 d0                	add    %edx,%eax
  802638:	8a 40 04             	mov    0x4(%eax),%al
  80263b:	84 c0                	test   %al,%al
  80263d:	75 40                	jne    80267f <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80263f:	a1 20 30 80 00       	mov    0x803020,%eax
  802644:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80264a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80264d:	c1 e2 04             	shl    $0x4,%edx
  802650:	01 d0                	add    %edx,%eax
  802652:	8b 00                	mov    (%eax),%eax
  802654:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802657:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80265a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80265f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802661:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802664:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	01 c8                	add    %ecx,%eax
  802670:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802672:	39 c2                	cmp    %eax,%edx
  802674:	75 09                	jne    80267f <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  802676:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80267d:	eb 12                	jmp    802691 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80267f:	ff 45 e8             	incl   -0x18(%ebp)
  802682:	a1 20 30 80 00       	mov    0x803020,%eax
  802687:	8b 50 74             	mov    0x74(%eax),%edx
  80268a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80268d:	39 c2                	cmp    %eax,%edx
  80268f:	77 94                	ja     802625 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802691:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802695:	75 14                	jne    8026ab <CheckWSWithoutLastIndex+0xef>
			panic(
  802697:	83 ec 04             	sub    $0x4,%esp
  80269a:	68 d4 2e 80 00       	push   $0x802ed4
  80269f:	6a 3a                	push   $0x3a
  8026a1:	68 c8 2e 80 00       	push   $0x802ec8
  8026a6:	e8 9f fe ff ff       	call   80254a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8026ab:	ff 45 f0             	incl   -0x10(%ebp)
  8026ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8026b4:	0f 8c 3e ff ff ff    	jl     8025f8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8026ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8026c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8026c8:	eb 20                	jmp    8026ea <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8026ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8026cf:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8026d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026d8:	c1 e2 04             	shl    $0x4,%edx
  8026db:	01 d0                	add    %edx,%eax
  8026dd:	8a 40 04             	mov    0x4(%eax),%al
  8026e0:	3c 01                	cmp    $0x1,%al
  8026e2:	75 03                	jne    8026e7 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8026e4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8026e7:	ff 45 e0             	incl   -0x20(%ebp)
  8026ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8026ef:	8b 50 74             	mov    0x74(%eax),%edx
  8026f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f5:	39 c2                	cmp    %eax,%edx
  8026f7:	77 d1                	ja     8026ca <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8026ff:	74 14                	je     802715 <CheckWSWithoutLastIndex+0x159>
		panic(
  802701:	83 ec 04             	sub    $0x4,%esp
  802704:	68 28 2f 80 00       	push   $0x802f28
  802709:	6a 44                	push   $0x44
  80270b:	68 c8 2e 80 00       	push   $0x802ec8
  802710:	e8 35 fe ff ff       	call   80254a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802715:	90                   	nop
  802716:	c9                   	leave  
  802717:	c3                   	ret    

00802718 <__udivdi3>:
  802718:	55                   	push   %ebp
  802719:	57                   	push   %edi
  80271a:	56                   	push   %esi
  80271b:	53                   	push   %ebx
  80271c:	83 ec 1c             	sub    $0x1c,%esp
  80271f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802723:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802727:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80272b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80272f:	89 ca                	mov    %ecx,%edx
  802731:	89 f8                	mov    %edi,%eax
  802733:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802737:	85 f6                	test   %esi,%esi
  802739:	75 2d                	jne    802768 <__udivdi3+0x50>
  80273b:	39 cf                	cmp    %ecx,%edi
  80273d:	77 65                	ja     8027a4 <__udivdi3+0x8c>
  80273f:	89 fd                	mov    %edi,%ebp
  802741:	85 ff                	test   %edi,%edi
  802743:	75 0b                	jne    802750 <__udivdi3+0x38>
  802745:	b8 01 00 00 00       	mov    $0x1,%eax
  80274a:	31 d2                	xor    %edx,%edx
  80274c:	f7 f7                	div    %edi
  80274e:	89 c5                	mov    %eax,%ebp
  802750:	31 d2                	xor    %edx,%edx
  802752:	89 c8                	mov    %ecx,%eax
  802754:	f7 f5                	div    %ebp
  802756:	89 c1                	mov    %eax,%ecx
  802758:	89 d8                	mov    %ebx,%eax
  80275a:	f7 f5                	div    %ebp
  80275c:	89 cf                	mov    %ecx,%edi
  80275e:	89 fa                	mov    %edi,%edx
  802760:	83 c4 1c             	add    $0x1c,%esp
  802763:	5b                   	pop    %ebx
  802764:	5e                   	pop    %esi
  802765:	5f                   	pop    %edi
  802766:	5d                   	pop    %ebp
  802767:	c3                   	ret    
  802768:	39 ce                	cmp    %ecx,%esi
  80276a:	77 28                	ja     802794 <__udivdi3+0x7c>
  80276c:	0f bd fe             	bsr    %esi,%edi
  80276f:	83 f7 1f             	xor    $0x1f,%edi
  802772:	75 40                	jne    8027b4 <__udivdi3+0x9c>
  802774:	39 ce                	cmp    %ecx,%esi
  802776:	72 0a                	jb     802782 <__udivdi3+0x6a>
  802778:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80277c:	0f 87 9e 00 00 00    	ja     802820 <__udivdi3+0x108>
  802782:	b8 01 00 00 00       	mov    $0x1,%eax
  802787:	89 fa                	mov    %edi,%edx
  802789:	83 c4 1c             	add    $0x1c,%esp
  80278c:	5b                   	pop    %ebx
  80278d:	5e                   	pop    %esi
  80278e:	5f                   	pop    %edi
  80278f:	5d                   	pop    %ebp
  802790:	c3                   	ret    
  802791:	8d 76 00             	lea    0x0(%esi),%esi
  802794:	31 ff                	xor    %edi,%edi
  802796:	31 c0                	xor    %eax,%eax
  802798:	89 fa                	mov    %edi,%edx
  80279a:	83 c4 1c             	add    $0x1c,%esp
  80279d:	5b                   	pop    %ebx
  80279e:	5e                   	pop    %esi
  80279f:	5f                   	pop    %edi
  8027a0:	5d                   	pop    %ebp
  8027a1:	c3                   	ret    
  8027a2:	66 90                	xchg   %ax,%ax
  8027a4:	89 d8                	mov    %ebx,%eax
  8027a6:	f7 f7                	div    %edi
  8027a8:	31 ff                	xor    %edi,%edi
  8027aa:	89 fa                	mov    %edi,%edx
  8027ac:	83 c4 1c             	add    $0x1c,%esp
  8027af:	5b                   	pop    %ebx
  8027b0:	5e                   	pop    %esi
  8027b1:	5f                   	pop    %edi
  8027b2:	5d                   	pop    %ebp
  8027b3:	c3                   	ret    
  8027b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027b9:	89 eb                	mov    %ebp,%ebx
  8027bb:	29 fb                	sub    %edi,%ebx
  8027bd:	89 f9                	mov    %edi,%ecx
  8027bf:	d3 e6                	shl    %cl,%esi
  8027c1:	89 c5                	mov    %eax,%ebp
  8027c3:	88 d9                	mov    %bl,%cl
  8027c5:	d3 ed                	shr    %cl,%ebp
  8027c7:	89 e9                	mov    %ebp,%ecx
  8027c9:	09 f1                	or     %esi,%ecx
  8027cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8027cf:	89 f9                	mov    %edi,%ecx
  8027d1:	d3 e0                	shl    %cl,%eax
  8027d3:	89 c5                	mov    %eax,%ebp
  8027d5:	89 d6                	mov    %edx,%esi
  8027d7:	88 d9                	mov    %bl,%cl
  8027d9:	d3 ee                	shr    %cl,%esi
  8027db:	89 f9                	mov    %edi,%ecx
  8027dd:	d3 e2                	shl    %cl,%edx
  8027df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027e3:	88 d9                	mov    %bl,%cl
  8027e5:	d3 e8                	shr    %cl,%eax
  8027e7:	09 c2                	or     %eax,%edx
  8027e9:	89 d0                	mov    %edx,%eax
  8027eb:	89 f2                	mov    %esi,%edx
  8027ed:	f7 74 24 0c          	divl   0xc(%esp)
  8027f1:	89 d6                	mov    %edx,%esi
  8027f3:	89 c3                	mov    %eax,%ebx
  8027f5:	f7 e5                	mul    %ebp
  8027f7:	39 d6                	cmp    %edx,%esi
  8027f9:	72 19                	jb     802814 <__udivdi3+0xfc>
  8027fb:	74 0b                	je     802808 <__udivdi3+0xf0>
  8027fd:	89 d8                	mov    %ebx,%eax
  8027ff:	31 ff                	xor    %edi,%edi
  802801:	e9 58 ff ff ff       	jmp    80275e <__udivdi3+0x46>
  802806:	66 90                	xchg   %ax,%ax
  802808:	8b 54 24 08          	mov    0x8(%esp),%edx
  80280c:	89 f9                	mov    %edi,%ecx
  80280e:	d3 e2                	shl    %cl,%edx
  802810:	39 c2                	cmp    %eax,%edx
  802812:	73 e9                	jae    8027fd <__udivdi3+0xe5>
  802814:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802817:	31 ff                	xor    %edi,%edi
  802819:	e9 40 ff ff ff       	jmp    80275e <__udivdi3+0x46>
  80281e:	66 90                	xchg   %ax,%ax
  802820:	31 c0                	xor    %eax,%eax
  802822:	e9 37 ff ff ff       	jmp    80275e <__udivdi3+0x46>
  802827:	90                   	nop

00802828 <__umoddi3>:
  802828:	55                   	push   %ebp
  802829:	57                   	push   %edi
  80282a:	56                   	push   %esi
  80282b:	53                   	push   %ebx
  80282c:	83 ec 1c             	sub    $0x1c,%esp
  80282f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802833:	8b 74 24 34          	mov    0x34(%esp),%esi
  802837:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80283b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80283f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802843:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802847:	89 f3                	mov    %esi,%ebx
  802849:	89 fa                	mov    %edi,%edx
  80284b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80284f:	89 34 24             	mov    %esi,(%esp)
  802852:	85 c0                	test   %eax,%eax
  802854:	75 1a                	jne    802870 <__umoddi3+0x48>
  802856:	39 f7                	cmp    %esi,%edi
  802858:	0f 86 a2 00 00 00    	jbe    802900 <__umoddi3+0xd8>
  80285e:	89 c8                	mov    %ecx,%eax
  802860:	89 f2                	mov    %esi,%edx
  802862:	f7 f7                	div    %edi
  802864:	89 d0                	mov    %edx,%eax
  802866:	31 d2                	xor    %edx,%edx
  802868:	83 c4 1c             	add    $0x1c,%esp
  80286b:	5b                   	pop    %ebx
  80286c:	5e                   	pop    %esi
  80286d:	5f                   	pop    %edi
  80286e:	5d                   	pop    %ebp
  80286f:	c3                   	ret    
  802870:	39 f0                	cmp    %esi,%eax
  802872:	0f 87 ac 00 00 00    	ja     802924 <__umoddi3+0xfc>
  802878:	0f bd e8             	bsr    %eax,%ebp
  80287b:	83 f5 1f             	xor    $0x1f,%ebp
  80287e:	0f 84 ac 00 00 00    	je     802930 <__umoddi3+0x108>
  802884:	bf 20 00 00 00       	mov    $0x20,%edi
  802889:	29 ef                	sub    %ebp,%edi
  80288b:	89 fe                	mov    %edi,%esi
  80288d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802891:	89 e9                	mov    %ebp,%ecx
  802893:	d3 e0                	shl    %cl,%eax
  802895:	89 d7                	mov    %edx,%edi
  802897:	89 f1                	mov    %esi,%ecx
  802899:	d3 ef                	shr    %cl,%edi
  80289b:	09 c7                	or     %eax,%edi
  80289d:	89 e9                	mov    %ebp,%ecx
  80289f:	d3 e2                	shl    %cl,%edx
  8028a1:	89 14 24             	mov    %edx,(%esp)
  8028a4:	89 d8                	mov    %ebx,%eax
  8028a6:	d3 e0                	shl    %cl,%eax
  8028a8:	89 c2                	mov    %eax,%edx
  8028aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028ae:	d3 e0                	shl    %cl,%eax
  8028b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028b8:	89 f1                	mov    %esi,%ecx
  8028ba:	d3 e8                	shr    %cl,%eax
  8028bc:	09 d0                	or     %edx,%eax
  8028be:	d3 eb                	shr    %cl,%ebx
  8028c0:	89 da                	mov    %ebx,%edx
  8028c2:	f7 f7                	div    %edi
  8028c4:	89 d3                	mov    %edx,%ebx
  8028c6:	f7 24 24             	mull   (%esp)
  8028c9:	89 c6                	mov    %eax,%esi
  8028cb:	89 d1                	mov    %edx,%ecx
  8028cd:	39 d3                	cmp    %edx,%ebx
  8028cf:	0f 82 87 00 00 00    	jb     80295c <__umoddi3+0x134>
  8028d5:	0f 84 91 00 00 00    	je     80296c <__umoddi3+0x144>
  8028db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028df:	29 f2                	sub    %esi,%edx
  8028e1:	19 cb                	sbb    %ecx,%ebx
  8028e3:	89 d8                	mov    %ebx,%eax
  8028e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8028e9:	d3 e0                	shl    %cl,%eax
  8028eb:	89 e9                	mov    %ebp,%ecx
  8028ed:	d3 ea                	shr    %cl,%edx
  8028ef:	09 d0                	or     %edx,%eax
  8028f1:	89 e9                	mov    %ebp,%ecx
  8028f3:	d3 eb                	shr    %cl,%ebx
  8028f5:	89 da                	mov    %ebx,%edx
  8028f7:	83 c4 1c             	add    $0x1c,%esp
  8028fa:	5b                   	pop    %ebx
  8028fb:	5e                   	pop    %esi
  8028fc:	5f                   	pop    %edi
  8028fd:	5d                   	pop    %ebp
  8028fe:	c3                   	ret    
  8028ff:	90                   	nop
  802900:	89 fd                	mov    %edi,%ebp
  802902:	85 ff                	test   %edi,%edi
  802904:	75 0b                	jne    802911 <__umoddi3+0xe9>
  802906:	b8 01 00 00 00       	mov    $0x1,%eax
  80290b:	31 d2                	xor    %edx,%edx
  80290d:	f7 f7                	div    %edi
  80290f:	89 c5                	mov    %eax,%ebp
  802911:	89 f0                	mov    %esi,%eax
  802913:	31 d2                	xor    %edx,%edx
  802915:	f7 f5                	div    %ebp
  802917:	89 c8                	mov    %ecx,%eax
  802919:	f7 f5                	div    %ebp
  80291b:	89 d0                	mov    %edx,%eax
  80291d:	e9 44 ff ff ff       	jmp    802866 <__umoddi3+0x3e>
  802922:	66 90                	xchg   %ax,%ax
  802924:	89 c8                	mov    %ecx,%eax
  802926:	89 f2                	mov    %esi,%edx
  802928:	83 c4 1c             	add    $0x1c,%esp
  80292b:	5b                   	pop    %ebx
  80292c:	5e                   	pop    %esi
  80292d:	5f                   	pop    %edi
  80292e:	5d                   	pop    %ebp
  80292f:	c3                   	ret    
  802930:	3b 04 24             	cmp    (%esp),%eax
  802933:	72 06                	jb     80293b <__umoddi3+0x113>
  802935:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802939:	77 0f                	ja     80294a <__umoddi3+0x122>
  80293b:	89 f2                	mov    %esi,%edx
  80293d:	29 f9                	sub    %edi,%ecx
  80293f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802943:	89 14 24             	mov    %edx,(%esp)
  802946:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80294a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80294e:	8b 14 24             	mov    (%esp),%edx
  802951:	83 c4 1c             	add    $0x1c,%esp
  802954:	5b                   	pop    %ebx
  802955:	5e                   	pop    %esi
  802956:	5f                   	pop    %edi
  802957:	5d                   	pop    %ebp
  802958:	c3                   	ret    
  802959:	8d 76 00             	lea    0x0(%esi),%esi
  80295c:	2b 04 24             	sub    (%esp),%eax
  80295f:	19 fa                	sbb    %edi,%edx
  802961:	89 d1                	mov    %edx,%ecx
  802963:	89 c6                	mov    %eax,%esi
  802965:	e9 71 ff ff ff       	jmp    8028db <__umoddi3+0xb3>
  80296a:	66 90                	xchg   %ax,%ax
  80296c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802970:	72 ea                	jb     80295c <__umoddi3+0x134>
  802972:	89 d9                	mov    %ebx,%ecx
  802974:	e9 62 ff ff ff       	jmp    8028db <__umoddi3+0xb3>
