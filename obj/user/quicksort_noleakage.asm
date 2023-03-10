
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 0e 06 00 00       	call   800644 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_disable_interrupt();
  800041:	e8 1c 22 00 00       	call   802262 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 29 80 00       	push   $0x802900
  80004e:	e8 d8 09 00 00       	call   800a2b <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 29 80 00       	push   $0x802902
  80005e:	e8 c8 09 00 00       	call   800a2b <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 1b 29 80 00       	push   $0x80291b
  80006e:	e8 b8 09 00 00       	call   800a2b <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 29 80 00       	push   $0x802902
  80007e:	e8 a8 09 00 00       	call   800a2b <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 29 80 00       	push   $0x802900
  80008e:	e8 98 09 00 00       	call   800a2b <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 34 29 80 00       	push   $0x802934
  8000a5:	e8 03 10 00 00       	call   8010ad <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 53 15 00 00       	call   801613 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 e6 18 00 00       	call   8019bb <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 54 29 80 00       	push   $0x802954
  8000e3:	e8 43 09 00 00       	call   800a2b <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 76 29 80 00       	push   $0x802976
  8000f3:	e8 33 09 00 00       	call   800a2b <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 84 29 80 00       	push   $0x802984
  800103:	e8 23 09 00 00       	call   800a2b <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 93 29 80 00       	push   $0x802993
  800113:	e8 13 09 00 00       	call   800a2b <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 a3 29 80 00       	push   $0x8029a3
  800123:	e8 03 09 00 00       	call   800a2b <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 bc 04 00 00       	call   8005ec <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
			cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 64 04 00 00       	call   8005a4 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 57 04 00 00       	call   8005a4 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d ef 61          	cmpb   $0x61,-0x11(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d ef 62          	cmpb   $0x62,-0x11(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d ef 63          	cmpb   $0x63,-0x11(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 15 21 00 00       	call   80227c <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f4             	pushl  -0xc(%ebp)
  800180:	ff 75 f0             	pushl  -0x10(%ebp)
  800183:	e8 e4 02 00 00       	call   80046c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f4             	pushl  -0xc(%ebp)
  800193:	ff 75 f0             	pushl  -0x10(%ebp)
  800196:	e8 02 03 00 00       	call   80049d <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 24 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8001b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8001bc:	e8 11 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8001cd:	e8 df 00 00 00       	call   8002b1 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 88 20 00 00       	call   802262 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 ac 29 80 00       	push   $0x8029ac
  8001e2:	e8 44 08 00 00       	call   800a2b <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 8d 20 00 00       	call   80227c <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f8:	e8 c5 01 00 00       	call   8003c2 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 e0 29 80 00       	push   $0x8029e0
  800211:	6a 49                	push   $0x49
  800213:	68 02 2a 80 00       	push   $0x802a02
  800218:	e8 6c 05 00 00       	call   800789 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 40 20 00 00       	call   802262 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 20 2a 80 00       	push   $0x802a20
  80022a:	e8 fc 07 00 00       	call   800a2b <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 54 2a 80 00       	push   $0x802a54
  80023a:	e8 ec 07 00 00       	call   800a2b <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 88 2a 80 00       	push   $0x802a88
  80024a:	e8 dc 07 00 00       	call   800a2b <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 25 20 00 00       	call   80227c <sys_enable_interrupt>

		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 f0             	pushl  -0x10(%ebp)
  80025d:	e8 14 1c 00 00       	call   801e76 <free>
  800262:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800265:	e8 f8 1f 00 00       	call   802262 <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 ba 2a 80 00       	push   $0x802aba
  800272:	e8 b4 07 00 00       	call   800a2b <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80027a:	e8 6d 03 00 00       	call   8005ec <getchar>
  80027f:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800282:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 15 03 00 00       	call   8005a4 <cputchar>
  80028f:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 0a                	push   $0xa
  800297:	e8 08 03 00 00       	call   8005a4 <cputchar>
  80029c:	83 c4 10             	add    $0x10,%esp

		sys_enable_interrupt();
  80029f:	e8 d8 1f 00 00       	call   80227c <sys_enable_interrupt>

	} while (Chose == 'y');
  8002a4:	80 7d ef 79          	cmpb   $0x79,-0x11(%ebp)
  8002a8:	0f 84 93 fd ff ff    	je     800041 <_main+0x9>

}
  8002ae:	90                   	nop
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	48                   	dec    %eax
  8002bb:	50                   	push   %eax
  8002bc:	6a 00                	push   $0x0
  8002be:	ff 75 0c             	pushl  0xc(%ebp)
  8002c1:	ff 75 08             	pushl  0x8(%ebp)
  8002c4:	e8 06 00 00 00       	call   8002cf <QSort>
  8002c9:	83 c4 10             	add    $0x10,%esp
}
  8002cc:	90                   	nop
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d8:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002db:	0f 8d de 00 00 00    	jge    8003bf <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e4:	40                   	inc    %eax
  8002e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ee:	e9 80 00 00 00       	jmp    800373 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002f3:	ff 45 f4             	incl   -0xc(%ebp)
  8002f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fc:	7f 2b                	jg     800329 <QSort+0x5a>
  8002fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800301:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	8b 10                	mov    (%eax),%edx
  80030f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800312:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 c8                	add    %ecx,%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	39 c2                	cmp    %eax,%edx
  800322:	7d cf                	jge    8002f3 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800324:	eb 03                	jmp    800329 <QSort+0x5a>
  800326:	ff 4d f0             	decl   -0x10(%ebp)
  800329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80032f:	7e 26                	jle    800357 <QSort+0x88>
  800331:	8b 45 10             	mov    0x10(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 10                	mov    (%eax),%edx
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800345:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 c8                	add    %ecx,%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	39 c2                	cmp    %eax,%edx
  800355:	7e cf                	jle    800326 <QSort+0x57>

		if (i <= j)
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80035d:	7f 14                	jg     800373 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	ff 75 f0             	pushl  -0x10(%ebp)
  800365:	ff 75 f4             	pushl  -0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 a9 00 00 00       	call   800419 <Swap>
  800370:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800379:	0f 8e 77 ff ff ff    	jle    8002f6 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	ff 75 f0             	pushl  -0x10(%ebp)
  800385:	ff 75 10             	pushl  0x10(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	e8 89 00 00 00       	call   800419 <Swap>
  800390:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800396:	48                   	dec    %eax
  800397:	50                   	push   %eax
  800398:	ff 75 10             	pushl  0x10(%ebp)
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 29 ff ff ff       	call   8002cf <QSort>
  8003a6:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003a9:	ff 75 14             	pushl  0x14(%ebp)
  8003ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 08             	pushl  0x8(%ebp)
  8003b5:	e8 15 ff ff ff       	call   8002cf <QSort>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	eb 01                	jmp    8003c0 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003bf:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    

008003c2 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003c8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003d6:	eb 33                	jmp    80040b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	8b 10                	mov    (%eax),%edx
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	40                   	inc    %eax
  8003ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	7e 09                	jle    800408 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800406:	eb 0c                	jmp    800414 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800408:	ff 45 f8             	incl   -0x8(%ebp)
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	48                   	dec    %eax
  80040f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800412:	7f c4                	jg     8003d8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800414:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800417:	c9                   	leave  
  800418:	c3                   	ret    

00800419 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800433:	8b 45 0c             	mov    0xc(%ebp),%eax
  800436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	01 c2                	add    %eax,%edx
  800442:	8b 45 10             	mov    0x10(%ebp),%eax
  800445:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	01 c8                	add    %ecx,%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800455:	8b 45 10             	mov    0x10(%ebp),%eax
  800458:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	01 c2                	add    %eax,%edx
  800464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800467:	89 02                	mov    %eax,(%edx)
}
  800469:	90                   	nop
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800479:	eb 17                	jmp    800492 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80047b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c2                	add    %eax,%edx
  80048a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80048f:	ff 45 fc             	incl   -0x4(%ebp)
  800492:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800495:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800498:	7c e1                	jl     80047b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004aa:	eb 1b                	jmp    8004c7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	01 c2                	add    %eax,%edx
  8004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004be:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c4:	ff 45 fc             	incl   -0x4(%ebp)
  8004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cd:	7c dd                	jl     8004ac <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004cf:	90                   	nop
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004db:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004e0:	f7 e9                	imul   %ecx
  8004e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	29 c8                	sub    %ecx,%eax
  8004e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004f3:	eb 1e                	jmp    800513 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800508:	99                   	cltd   
  800509:	f7 7d f8             	idivl  -0x8(%ebp)
  80050c:	89 d0                	mov    %edx,%eax
  80050e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800510:	ff 45 fc             	incl   -0x4(%ebp)
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800519:	7c da                	jl     8004f5 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800524:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800532:	eb 42                	jmp    800576 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	99                   	cltd   
  800538:	f7 7d f0             	idivl  -0x10(%ebp)
  80053b:	89 d0                	mov    %edx,%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	75 10                	jne    800551 <PrintElements+0x33>
			cprintf("\n");
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	68 00 29 80 00       	push   $0x802900
  800549:	e8 dd 04 00 00       	call   800a2b <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	01 d0                	add    %edx,%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	50                   	push   %eax
  800566:	68 d8 2a 80 00       	push   $0x802ad8
  80056b:	e8 bb 04 00 00       	call   800a2b <cprintf>
  800570:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800573:	ff 45 f4             	incl   -0xc(%ebp)
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	48                   	dec    %eax
  80057a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80057d:	7f b5                	jg     800534 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80057f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800582:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	01 d0                	add    %edx,%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	50                   	push   %eax
  800594:	68 dd 2a 80 00       	push   $0x802add
  800599:	e8 8d 04 00 00       	call   800a2b <cprintf>
  80059e:	83 c4 10             	add    $0x10,%esp

}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005b0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	50                   	push   %eax
  8005b8:	e8 d9 1c 00 00       	call   802296 <sys_cputc>
  8005bd:	83 c4 10             	add    $0x10,%esp
}
  8005c0:	90                   	nop
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005c9:	e8 94 1c 00 00       	call   802262 <sys_disable_interrupt>
	char c = ch;
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005d4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	50                   	push   %eax
  8005dc:	e8 b5 1c 00 00       	call   802296 <sys_cputc>
  8005e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005e4:	e8 93 1c 00 00       	call   80227c <sys_enable_interrupt>
}
  8005e9:	90                   	nop
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    

008005ec <getchar>:

int
getchar(void)
{
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005f9:	eb 08                	jmp    800603 <getchar+0x17>
	{
		c = sys_cgetc();
  8005fb:	e8 7a 1a 00 00       	call   80207a <sys_cgetc>
  800600:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800607:	74 f2                	je     8005fb <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800609:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <atomic_getchar>:

int
atomic_getchar(void)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800614:	e8 49 1c 00 00       	call   802262 <sys_disable_interrupt>
	int c=0;
  800619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800620:	eb 08                	jmp    80062a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800622:	e8 53 1a 00 00       	call   80207a <sys_cgetc>
  800627:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80062a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80062e:	74 f2                	je     800622 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800630:	e8 47 1c 00 00       	call   80227c <sys_enable_interrupt>
	return c;
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800638:	c9                   	leave  
  800639:	c3                   	ret    

0080063a <iscons>:

int iscons(int fdnum)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80063d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800642:	5d                   	pop    %ebp
  800643:	c3                   	ret    

00800644 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80064a:	e8 78 1a 00 00       	call   8020c7 <sys_getenvindex>
  80064f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	c1 e0 03             	shl    $0x3,%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800663:	01 c8                	add    %ecx,%eax
  800665:	01 c0                	add    %eax,%eax
  800667:	01 d0                	add    %edx,%eax
  800669:	01 c0                	add    %eax,%eax
  80066b:	01 d0                	add    %edx,%eax
  80066d:	89 c2                	mov    %eax,%edx
  80066f:	c1 e2 05             	shl    $0x5,%edx
  800672:	29 c2                	sub    %eax,%edx
  800674:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80067b:	89 c2                	mov    %eax,%edx
  80067d:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800683:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800688:	a1 24 40 80 00       	mov    0x804024,%eax
  80068d:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800693:	84 c0                	test   %al,%al
  800695:	74 0f                	je     8006a6 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800697:	a1 24 40 80 00       	mov    0x804024,%eax
  80069c:	05 40 3c 01 00       	add    $0x13c40,%eax
  8006a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006aa:	7e 0a                	jle    8006b6 <libmain+0x72>
		binaryname = argv[0];
  8006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	ff 75 0c             	pushl  0xc(%ebp)
  8006bc:	ff 75 08             	pushl  0x8(%ebp)
  8006bf:	e8 74 f9 ff ff       	call   800038 <_main>
  8006c4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006c7:	e8 96 1b 00 00       	call   802262 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006cc:	83 ec 0c             	sub    $0xc,%esp
  8006cf:	68 fc 2a 80 00       	push   $0x802afc
  8006d4:	e8 52 03 00 00       	call   800a2b <cprintf>
  8006d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006dc:	a1 24 40 80 00       	mov    0x804024,%eax
  8006e1:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8006e7:	a1 24 40 80 00       	mov    0x804024,%eax
  8006ec:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	52                   	push   %edx
  8006f6:	50                   	push   %eax
  8006f7:	68 24 2b 80 00       	push   $0x802b24
  8006fc:	e8 2a 03 00 00       	call   800a2b <cprintf>
  800701:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800704:	a1 24 40 80 00       	mov    0x804024,%eax
  800709:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80070f:	a1 24 40 80 00       	mov    0x804024,%eax
  800714:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80071a:	83 ec 04             	sub    $0x4,%esp
  80071d:	52                   	push   %edx
  80071e:	50                   	push   %eax
  80071f:	68 4c 2b 80 00       	push   $0x802b4c
  800724:	e8 02 03 00 00       	call   800a2b <cprintf>
  800729:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80072c:	a1 24 40 80 00       	mov    0x804024,%eax
  800731:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800737:	83 ec 08             	sub    $0x8,%esp
  80073a:	50                   	push   %eax
  80073b:	68 8d 2b 80 00       	push   $0x802b8d
  800740:	e8 e6 02 00 00       	call   800a2b <cprintf>
  800745:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800748:	83 ec 0c             	sub    $0xc,%esp
  80074b:	68 fc 2a 80 00       	push   $0x802afc
  800750:	e8 d6 02 00 00       	call   800a2b <cprintf>
  800755:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800758:	e8 1f 1b 00 00       	call   80227c <sys_enable_interrupt>

	// exit gracefully
	exit();
  80075d:	e8 19 00 00 00       	call   80077b <exit>
}
  800762:	90                   	nop
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80076b:	83 ec 0c             	sub    $0xc,%esp
  80076e:	6a 00                	push   $0x0
  800770:	e8 1e 19 00 00       	call   802093 <sys_env_destroy>
  800775:	83 c4 10             	add    $0x10,%esp
}
  800778:	90                   	nop
  800779:	c9                   	leave  
  80077a:	c3                   	ret    

0080077b <exit>:

void
exit(void)
{
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800781:	e8 73 19 00 00       	call   8020f9 <sys_env_exit>
}
  800786:	90                   	nop
  800787:	c9                   	leave  
  800788:	c3                   	ret    

00800789 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80078f:	8d 45 10             	lea    0x10(%ebp),%eax
  800792:	83 c0 04             	add    $0x4,%eax
  800795:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800798:	a1 18 41 80 00       	mov    0x804118,%eax
  80079d:	85 c0                	test   %eax,%eax
  80079f:	74 16                	je     8007b7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007a1:	a1 18 41 80 00       	mov    0x804118,%eax
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	50                   	push   %eax
  8007aa:	68 a4 2b 80 00       	push   $0x802ba4
  8007af:	e8 77 02 00 00       	call   800a2b <cprintf>
  8007b4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007b7:	a1 00 40 80 00       	mov    0x804000,%eax
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	ff 75 08             	pushl  0x8(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	68 a9 2b 80 00       	push   $0x802ba9
  8007c8:	e8 5e 02 00 00       	call   800a2b <cprintf>
  8007cd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d9:	50                   	push   %eax
  8007da:	e8 e1 01 00 00       	call   8009c0 <vcprintf>
  8007df:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	6a 00                	push   $0x0
  8007e7:	68 c5 2b 80 00       	push   $0x802bc5
  8007ec:	e8 cf 01 00 00       	call   8009c0 <vcprintf>
  8007f1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007f4:	e8 82 ff ff ff       	call   80077b <exit>

	// should not return here
	while (1) ;
  8007f9:	eb fe                	jmp    8007f9 <_panic+0x70>

008007fb <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
  8007fe:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800801:	a1 24 40 80 00       	mov    0x804024,%eax
  800806:	8b 50 74             	mov    0x74(%eax),%edx
  800809:	8b 45 0c             	mov    0xc(%ebp),%eax
  80080c:	39 c2                	cmp    %eax,%edx
  80080e:	74 14                	je     800824 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800810:	83 ec 04             	sub    $0x4,%esp
  800813:	68 c8 2b 80 00       	push   $0x802bc8
  800818:	6a 26                	push   $0x26
  80081a:	68 14 2c 80 00       	push   $0x802c14
  80081f:	e8 65 ff ff ff       	call   800789 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800824:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80082b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800832:	e9 b6 00 00 00       	jmp    8008ed <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	01 d0                	add    %edx,%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	85 c0                	test   %eax,%eax
  80084a:	75 08                	jne    800854 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80084c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80084f:	e9 96 00 00 00       	jmp    8008ea <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800854:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80085b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800862:	eb 5d                	jmp    8008c1 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800864:	a1 24 40 80 00       	mov    0x804024,%eax
  800869:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80086f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800872:	c1 e2 04             	shl    $0x4,%edx
  800875:	01 d0                	add    %edx,%eax
  800877:	8a 40 04             	mov    0x4(%eax),%al
  80087a:	84 c0                	test   %al,%al
  80087c:	75 40                	jne    8008be <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80087e:	a1 24 40 80 00       	mov    0x804024,%eax
  800883:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800889:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80088c:	c1 e2 04             	shl    $0x4,%edx
  80088f:	01 d0                	add    %edx,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800896:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800899:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80089e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	01 c8                	add    %ecx,%eax
  8008af:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b1:	39 c2                	cmp    %eax,%edx
  8008b3:	75 09                	jne    8008be <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8008b5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008bc:	eb 12                	jmp    8008d0 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008be:	ff 45 e8             	incl   -0x18(%ebp)
  8008c1:	a1 24 40 80 00       	mov    0x804024,%eax
  8008c6:	8b 50 74             	mov    0x74(%eax),%edx
  8008c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008cc:	39 c2                	cmp    %eax,%edx
  8008ce:	77 94                	ja     800864 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008d4:	75 14                	jne    8008ea <CheckWSWithoutLastIndex+0xef>
			panic(
  8008d6:	83 ec 04             	sub    $0x4,%esp
  8008d9:	68 20 2c 80 00       	push   $0x802c20
  8008de:	6a 3a                	push   $0x3a
  8008e0:	68 14 2c 80 00       	push   $0x802c14
  8008e5:	e8 9f fe ff ff       	call   800789 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008ea:	ff 45 f0             	incl   -0x10(%ebp)
  8008ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f3:	0f 8c 3e ff ff ff    	jl     800837 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008f9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800900:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800907:	eb 20                	jmp    800929 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800909:	a1 24 40 80 00       	mov    0x804024,%eax
  80090e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800914:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800917:	c1 e2 04             	shl    $0x4,%edx
  80091a:	01 d0                	add    %edx,%eax
  80091c:	8a 40 04             	mov    0x4(%eax),%al
  80091f:	3c 01                	cmp    $0x1,%al
  800921:	75 03                	jne    800926 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800923:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800926:	ff 45 e0             	incl   -0x20(%ebp)
  800929:	a1 24 40 80 00       	mov    0x804024,%eax
  80092e:	8b 50 74             	mov    0x74(%eax),%edx
  800931:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800934:	39 c2                	cmp    %eax,%edx
  800936:	77 d1                	ja     800909 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80093b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80093e:	74 14                	je     800954 <CheckWSWithoutLastIndex+0x159>
		panic(
  800940:	83 ec 04             	sub    $0x4,%esp
  800943:	68 74 2c 80 00       	push   $0x802c74
  800948:	6a 44                	push   $0x44
  80094a:	68 14 2c 80 00       	push   $0x802c14
  80094f:	e8 35 fe ff ff       	call   800789 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800954:	90                   	nop
  800955:	c9                   	leave  
  800956:	c3                   	ret    

00800957 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 00                	mov    (%eax),%eax
  800962:	8d 48 01             	lea    0x1(%eax),%ecx
  800965:	8b 55 0c             	mov    0xc(%ebp),%edx
  800968:	89 0a                	mov    %ecx,(%edx)
  80096a:	8b 55 08             	mov    0x8(%ebp),%edx
  80096d:	88 d1                	mov    %dl,%cl
  80096f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800972:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800976:	8b 45 0c             	mov    0xc(%ebp),%eax
  800979:	8b 00                	mov    (%eax),%eax
  80097b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800980:	75 2c                	jne    8009ae <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800982:	a0 28 40 80 00       	mov    0x804028,%al
  800987:	0f b6 c0             	movzbl %al,%eax
  80098a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098d:	8b 12                	mov    (%edx),%edx
  80098f:	89 d1                	mov    %edx,%ecx
  800991:	8b 55 0c             	mov    0xc(%ebp),%edx
  800994:	83 c2 08             	add    $0x8,%edx
  800997:	83 ec 04             	sub    $0x4,%esp
  80099a:	50                   	push   %eax
  80099b:	51                   	push   %ecx
  80099c:	52                   	push   %edx
  80099d:	e8 af 16 00 00       	call   802051 <sys_cputs>
  8009a2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	8b 40 04             	mov    0x4(%eax),%eax
  8009b4:	8d 50 01             	lea    0x1(%eax),%edx
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009bd:	90                   	nop
  8009be:	c9                   	leave  
  8009bf:	c3                   	ret    

008009c0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009d0:	00 00 00 
	b.cnt = 0;
  8009d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009da:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	ff 75 08             	pushl  0x8(%ebp)
  8009e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009e9:	50                   	push   %eax
  8009ea:	68 57 09 80 00       	push   $0x800957
  8009ef:	e8 11 02 00 00       	call   800c05 <vprintfmt>
  8009f4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009f7:	a0 28 40 80 00       	mov    0x804028,%al
  8009fc:	0f b6 c0             	movzbl %al,%eax
  8009ff:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a05:	83 ec 04             	sub    $0x4,%esp
  800a08:	50                   	push   %eax
  800a09:	52                   	push   %edx
  800a0a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a10:	83 c0 08             	add    $0x8,%eax
  800a13:	50                   	push   %eax
  800a14:	e8 38 16 00 00       	call   802051 <sys_cputs>
  800a19:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a1c:	c6 05 28 40 80 00 00 	movb   $0x0,0x804028
	return b.cnt;
  800a23:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a29:	c9                   	leave  
  800a2a:	c3                   	ret    

00800a2b <cprintf>:

int cprintf(const char *fmt, ...) {
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a31:	c6 05 28 40 80 00 01 	movb   $0x1,0x804028
	va_start(ap, fmt);
  800a38:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	ff 75 f4             	pushl  -0xc(%ebp)
  800a47:	50                   	push   %eax
  800a48:	e8 73 ff ff ff       	call   8009c0 <vcprintf>
  800a4d:	83 c4 10             	add    $0x10,%esp
  800a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a56:	c9                   	leave  
  800a57:	c3                   	ret    

00800a58 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a5e:	e8 ff 17 00 00       	call   802262 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a63:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a72:	50                   	push   %eax
  800a73:	e8 48 ff ff ff       	call   8009c0 <vcprintf>
  800a78:	83 c4 10             	add    $0x10,%esp
  800a7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a7e:	e8 f9 17 00 00       	call   80227c <sys_enable_interrupt>
	return cnt;
  800a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a86:	c9                   	leave  
  800a87:	c3                   	ret    

00800a88 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	53                   	push   %ebx
  800a8c:	83 ec 14             	sub    $0x14,%esp
  800a8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a95:	8b 45 14             	mov    0x14(%ebp),%eax
  800a98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a9b:	8b 45 18             	mov    0x18(%ebp),%eax
  800a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aa6:	77 55                	ja     800afd <printnum+0x75>
  800aa8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aab:	72 05                	jb     800ab2 <printnum+0x2a>
  800aad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ab0:	77 4b                	ja     800afd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ab2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ab5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ab8:	8b 45 18             	mov    0x18(%ebp),%eax
  800abb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac0:	52                   	push   %edx
  800ac1:	50                   	push   %eax
  800ac2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ac8:	e8 b7 1b 00 00       	call   802684 <__udivdi3>
  800acd:	83 c4 10             	add    $0x10,%esp
  800ad0:	83 ec 04             	sub    $0x4,%esp
  800ad3:	ff 75 20             	pushl  0x20(%ebp)
  800ad6:	53                   	push   %ebx
  800ad7:	ff 75 18             	pushl  0x18(%ebp)
  800ada:	52                   	push   %edx
  800adb:	50                   	push   %eax
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	ff 75 08             	pushl  0x8(%ebp)
  800ae2:	e8 a1 ff ff ff       	call   800a88 <printnum>
  800ae7:	83 c4 20             	add    $0x20,%esp
  800aea:	eb 1a                	jmp    800b06 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 20             	pushl  0x20(%ebp)
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	ff d0                	call   *%eax
  800afa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800afd:	ff 4d 1c             	decl   0x1c(%ebp)
  800b00:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b04:	7f e6                	jg     800aec <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b06:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b14:	53                   	push   %ebx
  800b15:	51                   	push   %ecx
  800b16:	52                   	push   %edx
  800b17:	50                   	push   %eax
  800b18:	e8 77 1c 00 00       	call   802794 <__umoddi3>
  800b1d:	83 c4 10             	add    $0x10,%esp
  800b20:	05 d4 2e 80 00       	add    $0x802ed4,%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	0f be c0             	movsbl %al,%eax
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	ff 75 0c             	pushl  0xc(%ebp)
  800b30:	50                   	push   %eax
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	ff d0                	call   *%eax
  800b36:	83 c4 10             	add    $0x10,%esp
}
  800b39:	90                   	nop
  800b3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b3d:	c9                   	leave  
  800b3e:	c3                   	ret    

00800b3f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b42:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b46:	7e 1c                	jle    800b64 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 00                	mov    (%eax),%eax
  800b4d:	8d 50 08             	lea    0x8(%eax),%edx
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	89 10                	mov    %edx,(%eax)
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	83 e8 08             	sub    $0x8,%eax
  800b5d:	8b 50 04             	mov    0x4(%eax),%edx
  800b60:	8b 00                	mov    (%eax),%eax
  800b62:	eb 40                	jmp    800ba4 <getuint+0x65>
	else if (lflag)
  800b64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b68:	74 1e                	je     800b88 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	8d 50 04             	lea    0x4(%eax),%edx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	89 10                	mov    %edx,(%eax)
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 00                	mov    (%eax),%eax
  800b81:	ba 00 00 00 00       	mov    $0x0,%edx
  800b86:	eb 1c                	jmp    800ba4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 50 04             	lea    0x4(%eax),%edx
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	89 10                	mov    %edx,(%eax)
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	8b 00                	mov    (%eax),%eax
  800b9a:	83 e8 04             	sub    $0x4,%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ba9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bad:	7e 1c                	jle    800bcb <getint+0x25>
		return va_arg(*ap, long long);
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	8d 50 08             	lea    0x8(%eax),%edx
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	89 10                	mov    %edx,(%eax)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	83 e8 08             	sub    $0x8,%eax
  800bc4:	8b 50 04             	mov    0x4(%eax),%edx
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	eb 38                	jmp    800c03 <getint+0x5d>
	else if (lflag)
  800bcb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bcf:	74 1a                	je     800beb <getint+0x45>
		return va_arg(*ap, long);
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8b 00                	mov    (%eax),%eax
  800bd6:	8d 50 04             	lea    0x4(%eax),%edx
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	89 10                	mov    %edx,(%eax)
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	83 e8 04             	sub    $0x4,%eax
  800be6:	8b 00                	mov    (%eax),%eax
  800be8:	99                   	cltd   
  800be9:	eb 18                	jmp    800c03 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	8d 50 04             	lea    0x4(%eax),%edx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	89 10                	mov    %edx,(%eax)
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	83 e8 04             	sub    $0x4,%eax
  800c00:	8b 00                	mov    (%eax),%eax
  800c02:	99                   	cltd   
}
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	56                   	push   %esi
  800c09:	53                   	push   %ebx
  800c0a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c0d:	eb 17                	jmp    800c26 <vprintfmt+0x21>
			if (ch == '\0')
  800c0f:	85 db                	test   %ebx,%ebx
  800c11:	0f 84 af 03 00 00    	je     800fc6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	53                   	push   %ebx
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	ff d0                	call   *%eax
  800c23:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c26:	8b 45 10             	mov    0x10(%ebp),%eax
  800c29:	8d 50 01             	lea    0x1(%eax),%edx
  800c2c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c2f:	8a 00                	mov    (%eax),%al
  800c31:	0f b6 d8             	movzbl %al,%ebx
  800c34:	83 fb 25             	cmp    $0x25,%ebx
  800c37:	75 d6                	jne    800c0f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c39:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c3d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c44:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c4b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c52:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c59:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5c:	8d 50 01             	lea    0x1(%eax),%edx
  800c5f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c62:	8a 00                	mov    (%eax),%al
  800c64:	0f b6 d8             	movzbl %al,%ebx
  800c67:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c6a:	83 f8 55             	cmp    $0x55,%eax
  800c6d:	0f 87 2b 03 00 00    	ja     800f9e <vprintfmt+0x399>
  800c73:	8b 04 85 f8 2e 80 00 	mov    0x802ef8(,%eax,4),%eax
  800c7a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c7c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c80:	eb d7                	jmp    800c59 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c82:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c86:	eb d1                	jmp    800c59 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c88:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c92:	89 d0                	mov    %edx,%eax
  800c94:	c1 e0 02             	shl    $0x2,%eax
  800c97:	01 d0                	add    %edx,%eax
  800c99:	01 c0                	add    %eax,%eax
  800c9b:	01 d8                	add    %ebx,%eax
  800c9d:	83 e8 30             	sub    $0x30,%eax
  800ca0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ca3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca6:	8a 00                	mov    (%eax),%al
  800ca8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cab:	83 fb 2f             	cmp    $0x2f,%ebx
  800cae:	7e 3e                	jle    800cee <vprintfmt+0xe9>
  800cb0:	83 fb 39             	cmp    $0x39,%ebx
  800cb3:	7f 39                	jg     800cee <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cb5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cb8:	eb d5                	jmp    800c8f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cba:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbd:	83 c0 04             	add    $0x4,%eax
  800cc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 e8 04             	sub    $0x4,%eax
  800cc9:	8b 00                	mov    (%eax),%eax
  800ccb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cce:	eb 1f                	jmp    800cef <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd4:	79 83                	jns    800c59 <vprintfmt+0x54>
				width = 0;
  800cd6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cdd:	e9 77 ff ff ff       	jmp    800c59 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ce2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ce9:	e9 6b ff ff ff       	jmp    800c59 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cee:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf3:	0f 89 60 ff ff ff    	jns    800c59 <vprintfmt+0x54>
				width = precision, precision = -1;
  800cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cfc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d06:	e9 4e ff ff ff       	jmp    800c59 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d0b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d0e:	e9 46 ff ff ff       	jmp    800c59 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d13:	8b 45 14             	mov    0x14(%ebp),%eax
  800d16:	83 c0 04             	add    $0x4,%eax
  800d19:	89 45 14             	mov    %eax,0x14(%ebp)
  800d1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1f:	83 e8 04             	sub    $0x4,%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	83 ec 08             	sub    $0x8,%esp
  800d27:	ff 75 0c             	pushl  0xc(%ebp)
  800d2a:	50                   	push   %eax
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	ff d0                	call   *%eax
  800d30:	83 c4 10             	add    $0x10,%esp
			break;
  800d33:	e9 89 02 00 00       	jmp    800fc1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d38:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3b:	83 c0 04             	add    $0x4,%eax
  800d3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 e8 04             	sub    $0x4,%eax
  800d47:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d49:	85 db                	test   %ebx,%ebx
  800d4b:	79 02                	jns    800d4f <vprintfmt+0x14a>
				err = -err;
  800d4d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d4f:	83 fb 64             	cmp    $0x64,%ebx
  800d52:	7f 0b                	jg     800d5f <vprintfmt+0x15a>
  800d54:	8b 34 9d 40 2d 80 00 	mov    0x802d40(,%ebx,4),%esi
  800d5b:	85 f6                	test   %esi,%esi
  800d5d:	75 19                	jne    800d78 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d5f:	53                   	push   %ebx
  800d60:	68 e5 2e 80 00       	push   $0x802ee5
  800d65:	ff 75 0c             	pushl  0xc(%ebp)
  800d68:	ff 75 08             	pushl  0x8(%ebp)
  800d6b:	e8 5e 02 00 00       	call   800fce <printfmt>
  800d70:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d73:	e9 49 02 00 00       	jmp    800fc1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d78:	56                   	push   %esi
  800d79:	68 ee 2e 80 00       	push   $0x802eee
  800d7e:	ff 75 0c             	pushl  0xc(%ebp)
  800d81:	ff 75 08             	pushl  0x8(%ebp)
  800d84:	e8 45 02 00 00       	call   800fce <printfmt>
  800d89:	83 c4 10             	add    $0x10,%esp
			break;
  800d8c:	e9 30 02 00 00       	jmp    800fc1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d91:	8b 45 14             	mov    0x14(%ebp),%eax
  800d94:	83 c0 04             	add    $0x4,%eax
  800d97:	89 45 14             	mov    %eax,0x14(%ebp)
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	83 e8 04             	sub    $0x4,%eax
  800da0:	8b 30                	mov    (%eax),%esi
  800da2:	85 f6                	test   %esi,%esi
  800da4:	75 05                	jne    800dab <vprintfmt+0x1a6>
				p = "(null)";
  800da6:	be f1 2e 80 00       	mov    $0x802ef1,%esi
			if (width > 0 && padc != '-')
  800dab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800daf:	7e 6d                	jle    800e1e <vprintfmt+0x219>
  800db1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800db5:	74 67                	je     800e1e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800db7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dba:	83 ec 08             	sub    $0x8,%esp
  800dbd:	50                   	push   %eax
  800dbe:	56                   	push   %esi
  800dbf:	e8 12 05 00 00       	call   8012d6 <strnlen>
  800dc4:	83 c4 10             	add    $0x10,%esp
  800dc7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dca:	eb 16                	jmp    800de2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dcc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dd0:	83 ec 08             	sub    $0x8,%esp
  800dd3:	ff 75 0c             	pushl  0xc(%ebp)
  800dd6:	50                   	push   %eax
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	ff d0                	call   *%eax
  800ddc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ddf:	ff 4d e4             	decl   -0x1c(%ebp)
  800de2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800de6:	7f e4                	jg     800dcc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800de8:	eb 34                	jmp    800e1e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dee:	74 1c                	je     800e0c <vprintfmt+0x207>
  800df0:	83 fb 1f             	cmp    $0x1f,%ebx
  800df3:	7e 05                	jle    800dfa <vprintfmt+0x1f5>
  800df5:	83 fb 7e             	cmp    $0x7e,%ebx
  800df8:	7e 12                	jle    800e0c <vprintfmt+0x207>
					putch('?', putdat);
  800dfa:	83 ec 08             	sub    $0x8,%esp
  800dfd:	ff 75 0c             	pushl  0xc(%ebp)
  800e00:	6a 3f                	push   $0x3f
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	ff d0                	call   *%eax
  800e07:	83 c4 10             	add    $0x10,%esp
  800e0a:	eb 0f                	jmp    800e1b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	ff 75 0c             	pushl  0xc(%ebp)
  800e12:	53                   	push   %ebx
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	ff d0                	call   *%eax
  800e18:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e1b:	ff 4d e4             	decl   -0x1c(%ebp)
  800e1e:	89 f0                	mov    %esi,%eax
  800e20:	8d 70 01             	lea    0x1(%eax),%esi
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f be d8             	movsbl %al,%ebx
  800e28:	85 db                	test   %ebx,%ebx
  800e2a:	74 24                	je     800e50 <vprintfmt+0x24b>
  800e2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e30:	78 b8                	js     800dea <vprintfmt+0x1e5>
  800e32:	ff 4d e0             	decl   -0x20(%ebp)
  800e35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e39:	79 af                	jns    800dea <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e3b:	eb 13                	jmp    800e50 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 0c             	pushl  0xc(%ebp)
  800e43:	6a 20                	push   $0x20
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	ff d0                	call   *%eax
  800e4a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e4d:	ff 4d e4             	decl   -0x1c(%ebp)
  800e50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e54:	7f e7                	jg     800e3d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e56:	e9 66 01 00 00       	jmp    800fc1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800e61:	8d 45 14             	lea    0x14(%ebp),%eax
  800e64:	50                   	push   %eax
  800e65:	e8 3c fd ff ff       	call   800ba6 <getint>
  800e6a:	83 c4 10             	add    $0x10,%esp
  800e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e79:	85 d2                	test   %edx,%edx
  800e7b:	79 23                	jns    800ea0 <vprintfmt+0x29b>
				putch('-', putdat);
  800e7d:	83 ec 08             	sub    $0x8,%esp
  800e80:	ff 75 0c             	pushl  0xc(%ebp)
  800e83:	6a 2d                	push   $0x2d
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	ff d0                	call   *%eax
  800e8a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e93:	f7 d8                	neg    %eax
  800e95:	83 d2 00             	adc    $0x0,%edx
  800e98:	f7 da                	neg    %edx
  800e9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ea0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ea7:	e9 bc 00 00 00       	jmp    800f68 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	ff 75 e8             	pushl  -0x18(%ebp)
  800eb2:	8d 45 14             	lea    0x14(%ebp),%eax
  800eb5:	50                   	push   %eax
  800eb6:	e8 84 fc ff ff       	call   800b3f <getuint>
  800ebb:	83 c4 10             	add    $0x10,%esp
  800ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ec4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ecb:	e9 98 00 00 00       	jmp    800f68 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	ff 75 0c             	pushl  0xc(%ebp)
  800ed6:	6a 58                	push   $0x58
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	ff d0                	call   *%eax
  800edd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	ff 75 0c             	pushl  0xc(%ebp)
  800ee6:	6a 58                	push   $0x58
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	ff d0                	call   *%eax
  800eed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ef0:	83 ec 08             	sub    $0x8,%esp
  800ef3:	ff 75 0c             	pushl  0xc(%ebp)
  800ef6:	6a 58                	push   $0x58
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	ff d0                	call   *%eax
  800efd:	83 c4 10             	add    $0x10,%esp
			break;
  800f00:	e9 bc 00 00 00       	jmp    800fc1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f05:	83 ec 08             	sub    $0x8,%esp
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	6a 30                	push   $0x30
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	ff d0                	call   *%eax
  800f12:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	ff 75 0c             	pushl  0xc(%ebp)
  800f1b:	6a 78                	push   $0x78
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	ff d0                	call   *%eax
  800f22:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f25:	8b 45 14             	mov    0x14(%ebp),%eax
  800f28:	83 c0 04             	add    $0x4,%eax
  800f2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	83 e8 04             	sub    $0x4,%eax
  800f34:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f40:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f47:	eb 1f                	jmp    800f68 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f49:	83 ec 08             	sub    $0x8,%esp
  800f4c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f4f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f52:	50                   	push   %eax
  800f53:	e8 e7 fb ff ff       	call   800b3f <getuint>
  800f58:	83 c4 10             	add    $0x10,%esp
  800f5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f61:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f68:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f6f:	83 ec 04             	sub    $0x4,%esp
  800f72:	52                   	push   %edx
  800f73:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f76:	50                   	push   %eax
  800f77:	ff 75 f4             	pushl  -0xc(%ebp)
  800f7a:	ff 75 f0             	pushl  -0x10(%ebp)
  800f7d:	ff 75 0c             	pushl  0xc(%ebp)
  800f80:	ff 75 08             	pushl  0x8(%ebp)
  800f83:	e8 00 fb ff ff       	call   800a88 <printnum>
  800f88:	83 c4 20             	add    $0x20,%esp
			break;
  800f8b:	eb 34                	jmp    800fc1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f8d:	83 ec 08             	sub    $0x8,%esp
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	53                   	push   %ebx
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	ff d0                	call   *%eax
  800f99:	83 c4 10             	add    $0x10,%esp
			break;
  800f9c:	eb 23                	jmp    800fc1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f9e:	83 ec 08             	sub    $0x8,%esp
  800fa1:	ff 75 0c             	pushl  0xc(%ebp)
  800fa4:	6a 25                	push   $0x25
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	ff d0                	call   *%eax
  800fab:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fae:	ff 4d 10             	decl   0x10(%ebp)
  800fb1:	eb 03                	jmp    800fb6 <vprintfmt+0x3b1>
  800fb3:	ff 4d 10             	decl   0x10(%ebp)
  800fb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb9:	48                   	dec    %eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	3c 25                	cmp    $0x25,%al
  800fbe:	75 f3                	jne    800fb3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fc0:	90                   	nop
		}
	}
  800fc1:	e9 47 fc ff ff       	jmp    800c0d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fc6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fca:	5b                   	pop    %ebx
  800fcb:	5e                   	pop    %esi
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    

00800fce <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fd4:	8d 45 10             	lea    0x10(%ebp),%eax
  800fd7:	83 c0 04             	add    $0x4,%eax
  800fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe3:	50                   	push   %eax
  800fe4:	ff 75 0c             	pushl  0xc(%ebp)
  800fe7:	ff 75 08             	pushl  0x8(%ebp)
  800fea:	e8 16 fc ff ff       	call   800c05 <vprintfmt>
  800fef:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ff2:	90                   	nop
  800ff3:	c9                   	leave  
  800ff4:	c3                   	ret    

00800ff5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	8b 40 08             	mov    0x8(%eax),%eax
  800ffe:	8d 50 01             	lea    0x1(%eax),%edx
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801007:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100a:	8b 10                	mov    (%eax),%edx
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	8b 40 04             	mov    0x4(%eax),%eax
  801012:	39 c2                	cmp    %eax,%edx
  801014:	73 12                	jae    801028 <sprintputch+0x33>
		*b->buf++ = ch;
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	8b 00                	mov    (%eax),%eax
  80101b:	8d 48 01             	lea    0x1(%eax),%ecx
  80101e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801021:	89 0a                	mov    %ecx,(%edx)
  801023:	8b 55 08             	mov    0x8(%ebp),%edx
  801026:	88 10                	mov    %dl,(%eax)
}
  801028:	90                   	nop
  801029:	5d                   	pop    %ebp
  80102a:	c3                   	ret    

0080102b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	01 d0                	add    %edx,%eax
  801042:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801045:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80104c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801050:	74 06                	je     801058 <vsnprintf+0x2d>
  801052:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801056:	7f 07                	jg     80105f <vsnprintf+0x34>
		return -E_INVAL;
  801058:	b8 03 00 00 00       	mov    $0x3,%eax
  80105d:	eb 20                	jmp    80107f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80105f:	ff 75 14             	pushl  0x14(%ebp)
  801062:	ff 75 10             	pushl  0x10(%ebp)
  801065:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801068:	50                   	push   %eax
  801069:	68 f5 0f 80 00       	push   $0x800ff5
  80106e:	e8 92 fb ff ff       	call   800c05 <vprintfmt>
  801073:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801076:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801079:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80107c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80107f:	c9                   	leave  
  801080:	c3                   	ret    

00801081 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801087:	8d 45 10             	lea    0x10(%ebp),%eax
  80108a:	83 c0 04             	add    $0x4,%eax
  80108d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801090:	8b 45 10             	mov    0x10(%ebp),%eax
  801093:	ff 75 f4             	pushl  -0xc(%ebp)
  801096:	50                   	push   %eax
  801097:	ff 75 0c             	pushl  0xc(%ebp)
  80109a:	ff 75 08             	pushl  0x8(%ebp)
  80109d:	e8 89 ff ff ff       	call   80102b <vsnprintf>
  8010a2:	83 c4 10             	add    $0x10,%esp
  8010a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b7:	74 13                	je     8010cc <readline+0x1f>
		cprintf("%s", prompt);
  8010b9:	83 ec 08             	sub    $0x8,%esp
  8010bc:	ff 75 08             	pushl  0x8(%ebp)
  8010bf:	68 50 30 80 00       	push   $0x803050
  8010c4:	e8 62 f9 ff ff       	call   800a2b <cprintf>
  8010c9:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010d3:	83 ec 0c             	sub    $0xc,%esp
  8010d6:	6a 00                	push   $0x0
  8010d8:	e8 5d f5 ff ff       	call   80063a <iscons>
  8010dd:	83 c4 10             	add    $0x10,%esp
  8010e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010e3:	e8 04 f5 ff ff       	call   8005ec <getchar>
  8010e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010ef:	79 22                	jns    801113 <readline+0x66>
			if (c != -E_EOF)
  8010f1:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010f5:	0f 84 ad 00 00 00    	je     8011a8 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 ec             	pushl  -0x14(%ebp)
  801101:	68 53 30 80 00       	push   $0x803053
  801106:	e8 20 f9 ff ff       	call   800a2b <cprintf>
  80110b:	83 c4 10             	add    $0x10,%esp
			return;
  80110e:	e9 95 00 00 00       	jmp    8011a8 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801113:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801117:	7e 34                	jle    80114d <readline+0xa0>
  801119:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801120:	7f 2b                	jg     80114d <readline+0xa0>
			if (echoing)
  801122:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801126:	74 0e                	je     801136 <readline+0x89>
				cputchar(c);
  801128:	83 ec 0c             	sub    $0xc,%esp
  80112b:	ff 75 ec             	pushl  -0x14(%ebp)
  80112e:	e8 71 f4 ff ff       	call   8005a4 <cputchar>
  801133:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801139:	8d 50 01             	lea    0x1(%eax),%edx
  80113c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80113f:	89 c2                	mov    %eax,%edx
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	01 d0                	add    %edx,%eax
  801146:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801149:	88 10                	mov    %dl,(%eax)
  80114b:	eb 56                	jmp    8011a3 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80114d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801151:	75 1f                	jne    801172 <readline+0xc5>
  801153:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801157:	7e 19                	jle    801172 <readline+0xc5>
			if (echoing)
  801159:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80115d:	74 0e                	je     80116d <readline+0xc0>
				cputchar(c);
  80115f:	83 ec 0c             	sub    $0xc,%esp
  801162:	ff 75 ec             	pushl  -0x14(%ebp)
  801165:	e8 3a f4 ff ff       	call   8005a4 <cputchar>
  80116a:	83 c4 10             	add    $0x10,%esp

			i--;
  80116d:	ff 4d f4             	decl   -0xc(%ebp)
  801170:	eb 31                	jmp    8011a3 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801172:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801176:	74 0a                	je     801182 <readline+0xd5>
  801178:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80117c:	0f 85 61 ff ff ff    	jne    8010e3 <readline+0x36>
			if (echoing)
  801182:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801186:	74 0e                	je     801196 <readline+0xe9>
				cputchar(c);
  801188:	83 ec 0c             	sub    $0xc,%esp
  80118b:	ff 75 ec             	pushl  -0x14(%ebp)
  80118e:	e8 11 f4 ff ff       	call   8005a4 <cputchar>
  801193:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801196:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	01 d0                	add    %edx,%eax
  80119e:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011a1:	eb 06                	jmp    8011a9 <readline+0xfc>
		}
	}
  8011a3:	e9 3b ff ff ff       	jmp    8010e3 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011a8:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011b1:	e8 ac 10 00 00       	call   802262 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ba:	74 13                	je     8011cf <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011bc:	83 ec 08             	sub    $0x8,%esp
  8011bf:	ff 75 08             	pushl  0x8(%ebp)
  8011c2:	68 50 30 80 00       	push   $0x803050
  8011c7:	e8 5f f8 ff ff       	call   800a2b <cprintf>
  8011cc:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011d6:	83 ec 0c             	sub    $0xc,%esp
  8011d9:	6a 00                	push   $0x0
  8011db:	e8 5a f4 ff ff       	call   80063a <iscons>
  8011e0:	83 c4 10             	add    $0x10,%esp
  8011e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011e6:	e8 01 f4 ff ff       	call   8005ec <getchar>
  8011eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011f2:	79 23                	jns    801217 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011f4:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011f8:	74 13                	je     80120d <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011fa:	83 ec 08             	sub    $0x8,%esp
  8011fd:	ff 75 ec             	pushl  -0x14(%ebp)
  801200:	68 53 30 80 00       	push   $0x803053
  801205:	e8 21 f8 ff ff       	call   800a2b <cprintf>
  80120a:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80120d:	e8 6a 10 00 00       	call   80227c <sys_enable_interrupt>
			return;
  801212:	e9 9a 00 00 00       	jmp    8012b1 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801217:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80121b:	7e 34                	jle    801251 <atomic_readline+0xa6>
  80121d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801224:	7f 2b                	jg     801251 <atomic_readline+0xa6>
			if (echoing)
  801226:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80122a:	74 0e                	je     80123a <atomic_readline+0x8f>
				cputchar(c);
  80122c:	83 ec 0c             	sub    $0xc,%esp
  80122f:	ff 75 ec             	pushl  -0x14(%ebp)
  801232:	e8 6d f3 ff ff       	call   8005a4 <cputchar>
  801237:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80123a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123d:	8d 50 01             	lea    0x1(%eax),%edx
  801240:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801243:	89 c2                	mov    %eax,%edx
  801245:	8b 45 0c             	mov    0xc(%ebp),%eax
  801248:	01 d0                	add    %edx,%eax
  80124a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80124d:	88 10                	mov    %dl,(%eax)
  80124f:	eb 5b                	jmp    8012ac <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801251:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801255:	75 1f                	jne    801276 <atomic_readline+0xcb>
  801257:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80125b:	7e 19                	jle    801276 <atomic_readline+0xcb>
			if (echoing)
  80125d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801261:	74 0e                	je     801271 <atomic_readline+0xc6>
				cputchar(c);
  801263:	83 ec 0c             	sub    $0xc,%esp
  801266:	ff 75 ec             	pushl  -0x14(%ebp)
  801269:	e8 36 f3 ff ff       	call   8005a4 <cputchar>
  80126e:	83 c4 10             	add    $0x10,%esp
			i--;
  801271:	ff 4d f4             	decl   -0xc(%ebp)
  801274:	eb 36                	jmp    8012ac <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801276:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80127a:	74 0a                	je     801286 <atomic_readline+0xdb>
  80127c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801280:	0f 85 60 ff ff ff    	jne    8011e6 <atomic_readline+0x3b>
			if (echoing)
  801286:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80128a:	74 0e                	je     80129a <atomic_readline+0xef>
				cputchar(c);
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	ff 75 ec             	pushl  -0x14(%ebp)
  801292:	e8 0d f3 ff ff       	call   8005a4 <cputchar>
  801297:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  80129a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a0:	01 d0                	add    %edx,%eax
  8012a2:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012a5:	e8 d2 0f 00 00       	call   80227c <sys_enable_interrupt>
			return;
  8012aa:	eb 05                	jmp    8012b1 <atomic_readline+0x106>
		}
	}
  8012ac:	e9 35 ff ff ff       	jmp    8011e6 <atomic_readline+0x3b>
}
  8012b1:	c9                   	leave  
  8012b2:	c3                   	ret    

008012b3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c0:	eb 06                	jmp    8012c8 <strlen+0x15>
		n++;
  8012c2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c5:	ff 45 08             	incl   0x8(%ebp)
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	84 c0                	test   %al,%al
  8012cf:	75 f1                	jne    8012c2 <strlen+0xf>
		n++;
	return n;
  8012d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012d4:	c9                   	leave  
  8012d5:	c3                   	ret    

008012d6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e3:	eb 09                	jmp    8012ee <strnlen+0x18>
		n++;
  8012e5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e8:	ff 45 08             	incl   0x8(%ebp)
  8012eb:	ff 4d 0c             	decl   0xc(%ebp)
  8012ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012f2:	74 09                	je     8012fd <strnlen+0x27>
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	84 c0                	test   %al,%al
  8012fb:	75 e8                	jne    8012e5 <strnlen+0xf>
		n++;
	return n;
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801300:	c9                   	leave  
  801301:	c3                   	ret    

00801302 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80130e:	90                   	nop
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	8d 50 01             	lea    0x1(%eax),%edx
  801315:	89 55 08             	mov    %edx,0x8(%ebp)
  801318:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80131e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801321:	8a 12                	mov    (%edx),%dl
  801323:	88 10                	mov    %dl,(%eax)
  801325:	8a 00                	mov    (%eax),%al
  801327:	84 c0                	test   %al,%al
  801329:	75 e4                	jne    80130f <strcpy+0xd>
		/* do nothing */;
	return ret;
  80132b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80133c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801343:	eb 1f                	jmp    801364 <strncpy+0x34>
		*dst++ = *src;
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	8d 50 01             	lea    0x1(%eax),%edx
  80134b:	89 55 08             	mov    %edx,0x8(%ebp)
  80134e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801351:	8a 12                	mov    (%edx),%dl
  801353:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	8a 00                	mov    (%eax),%al
  80135a:	84 c0                	test   %al,%al
  80135c:	74 03                	je     801361 <strncpy+0x31>
			src++;
  80135e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801361:	ff 45 fc             	incl   -0x4(%ebp)
  801364:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801367:	3b 45 10             	cmp    0x10(%ebp),%eax
  80136a:	72 d9                	jb     801345 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80136c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80137d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801381:	74 30                	je     8013b3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801383:	eb 16                	jmp    80139b <strlcpy+0x2a>
			*dst++ = *src++;
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8d 50 01             	lea    0x1(%eax),%edx
  80138b:	89 55 08             	mov    %edx,0x8(%ebp)
  80138e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801391:	8d 4a 01             	lea    0x1(%edx),%ecx
  801394:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801397:	8a 12                	mov    (%edx),%dl
  801399:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80139b:	ff 4d 10             	decl   0x10(%ebp)
  80139e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a2:	74 09                	je     8013ad <strlcpy+0x3c>
  8013a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a7:	8a 00                	mov    (%eax),%al
  8013a9:	84 c0                	test   %al,%al
  8013ab:	75 d8                	jne    801385 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b9:	29 c2                	sub    %eax,%edx
  8013bb:	89 d0                	mov    %edx,%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013c2:	eb 06                	jmp    8013ca <strcmp+0xb>
		p++, q++;
  8013c4:	ff 45 08             	incl   0x8(%ebp)
  8013c7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	84 c0                	test   %al,%al
  8013d1:	74 0e                	je     8013e1 <strcmp+0x22>
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8a 10                	mov    (%eax),%dl
  8013d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013db:	8a 00                	mov    (%eax),%al
  8013dd:	38 c2                	cmp    %al,%dl
  8013df:	74 e3                	je     8013c4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	0f b6 d0             	movzbl %al,%edx
  8013e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	0f b6 c0             	movzbl %al,%eax
  8013f1:	29 c2                	sub    %eax,%edx
  8013f3:	89 d0                	mov    %edx,%eax
}
  8013f5:	5d                   	pop    %ebp
  8013f6:	c3                   	ret    

008013f7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013fa:	eb 09                	jmp    801405 <strncmp+0xe>
		n--, p++, q++;
  8013fc:	ff 4d 10             	decl   0x10(%ebp)
  8013ff:	ff 45 08             	incl   0x8(%ebp)
  801402:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801405:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801409:	74 17                	je     801422 <strncmp+0x2b>
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	84 c0                	test   %al,%al
  801412:	74 0e                	je     801422 <strncmp+0x2b>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 10                	mov    (%eax),%dl
  801419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141c:	8a 00                	mov    (%eax),%al
  80141e:	38 c2                	cmp    %al,%dl
  801420:	74 da                	je     8013fc <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801422:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801426:	75 07                	jne    80142f <strncmp+0x38>
		return 0;
  801428:	b8 00 00 00 00       	mov    $0x0,%eax
  80142d:	eb 14                	jmp    801443 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	0f b6 d0             	movzbl %al,%edx
  801437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	0f b6 c0             	movzbl %al,%eax
  80143f:	29 c2                	sub    %eax,%edx
  801441:	89 d0                	mov    %edx,%eax
}
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    

00801445 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	83 ec 04             	sub    $0x4,%esp
  80144b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801451:	eb 12                	jmp    801465 <strchr+0x20>
		if (*s == c)
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80145b:	75 05                	jne    801462 <strchr+0x1d>
			return (char *) s;
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	eb 11                	jmp    801473 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801462:	ff 45 08             	incl   0x8(%ebp)
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8a 00                	mov    (%eax),%al
  80146a:	84 c0                	test   %al,%al
  80146c:	75 e5                	jne    801453 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80146e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	83 ec 04             	sub    $0x4,%esp
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801481:	eb 0d                	jmp    801490 <strfind+0x1b>
		if (*s == c)
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	8a 00                	mov    (%eax),%al
  801488:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80148b:	74 0e                	je     80149b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80148d:	ff 45 08             	incl   0x8(%ebp)
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	8a 00                	mov    (%eax),%al
  801495:	84 c0                	test   %al,%al
  801497:	75 ea                	jne    801483 <strfind+0xe>
  801499:	eb 01                	jmp    80149c <strfind+0x27>
		if (*s == c)
			break;
  80149b:	90                   	nop
	return (char *) s;
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    

008014a1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014b3:	eb 0e                	jmp    8014c3 <memset+0x22>
		*p++ = c;
  8014b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b8:	8d 50 01             	lea    0x1(%eax),%edx
  8014bb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014c3:	ff 4d f8             	decl   -0x8(%ebp)
  8014c6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014ca:	79 e9                	jns    8014b5 <memset+0x14>
		*p++ = c;

	return v;
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014e3:	eb 16                	jmp    8014fb <memcpy+0x2a>
		*d++ = *s++;
  8014e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e8:	8d 50 01             	lea    0x1(%eax),%edx
  8014eb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014f4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014f7:	8a 12                	mov    (%edx),%dl
  8014f9:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  801501:	89 55 10             	mov    %edx,0x10(%ebp)
  801504:	85 c0                	test   %eax,%eax
  801506:	75 dd                	jne    8014e5 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801513:	8b 45 0c             	mov    0xc(%ebp),%eax
  801516:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80151f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801522:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801525:	73 50                	jae    801577 <memmove+0x6a>
  801527:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80152a:	8b 45 10             	mov    0x10(%ebp),%eax
  80152d:	01 d0                	add    %edx,%eax
  80152f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801532:	76 43                	jbe    801577 <memmove+0x6a>
		s += n;
  801534:	8b 45 10             	mov    0x10(%ebp),%eax
  801537:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80153a:	8b 45 10             	mov    0x10(%ebp),%eax
  80153d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801540:	eb 10                	jmp    801552 <memmove+0x45>
			*--d = *--s;
  801542:	ff 4d f8             	decl   -0x8(%ebp)
  801545:	ff 4d fc             	decl   -0x4(%ebp)
  801548:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154b:	8a 10                	mov    (%eax),%dl
  80154d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801550:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801552:	8b 45 10             	mov    0x10(%ebp),%eax
  801555:	8d 50 ff             	lea    -0x1(%eax),%edx
  801558:	89 55 10             	mov    %edx,0x10(%ebp)
  80155b:	85 c0                	test   %eax,%eax
  80155d:	75 e3                	jne    801542 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80155f:	eb 23                	jmp    801584 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801561:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801564:	8d 50 01             	lea    0x1(%eax),%edx
  801567:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80156a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80156d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801570:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801573:	8a 12                	mov    (%edx),%dl
  801575:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801577:	8b 45 10             	mov    0x10(%ebp),%eax
  80157a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80157d:	89 55 10             	mov    %edx,0x10(%ebp)
  801580:	85 c0                	test   %eax,%eax
  801582:	75 dd                	jne    801561 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801595:	8b 45 0c             	mov    0xc(%ebp),%eax
  801598:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80159b:	eb 2a                	jmp    8015c7 <memcmp+0x3e>
		if (*s1 != *s2)
  80159d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a0:	8a 10                	mov    (%eax),%dl
  8015a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	38 c2                	cmp    %al,%dl
  8015a9:	74 16                	je     8015c1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	0f b6 d0             	movzbl %al,%edx
  8015b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	0f b6 c0             	movzbl %al,%eax
  8015bb:	29 c2                	sub    %eax,%edx
  8015bd:	89 d0                	mov    %edx,%eax
  8015bf:	eb 18                	jmp    8015d9 <memcmp+0x50>
		s1++, s2++;
  8015c1:	ff 45 fc             	incl   -0x4(%ebp)
  8015c4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8015d0:	85 c0                	test   %eax,%eax
  8015d2:	75 c9                	jne    80159d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e7:	01 d0                	add    %edx,%eax
  8015e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015ec:	eb 15                	jmp    801603 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	8a 00                	mov    (%eax),%al
  8015f3:	0f b6 d0             	movzbl %al,%edx
  8015f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f9:	0f b6 c0             	movzbl %al,%eax
  8015fc:	39 c2                	cmp    %eax,%edx
  8015fe:	74 0d                	je     80160d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801600:	ff 45 08             	incl   0x8(%ebp)
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801609:	72 e3                	jb     8015ee <memfind+0x13>
  80160b:	eb 01                	jmp    80160e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80160d:	90                   	nop
	return (void *) s;
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801619:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801620:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801627:	eb 03                	jmp    80162c <strtol+0x19>
		s++;
  801629:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8a 00                	mov    (%eax),%al
  801631:	3c 20                	cmp    $0x20,%al
  801633:	74 f4                	je     801629 <strtol+0x16>
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	3c 09                	cmp    $0x9,%al
  80163c:	74 eb                	je     801629 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	3c 2b                	cmp    $0x2b,%al
  801645:	75 05                	jne    80164c <strtol+0x39>
		s++;
  801647:	ff 45 08             	incl   0x8(%ebp)
  80164a:	eb 13                	jmp    80165f <strtol+0x4c>
	else if (*s == '-')
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	3c 2d                	cmp    $0x2d,%al
  801653:	75 0a                	jne    80165f <strtol+0x4c>
		s++, neg = 1;
  801655:	ff 45 08             	incl   0x8(%ebp)
  801658:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80165f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801663:	74 06                	je     80166b <strtol+0x58>
  801665:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801669:	75 20                	jne    80168b <strtol+0x78>
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	3c 30                	cmp    $0x30,%al
  801672:	75 17                	jne    80168b <strtol+0x78>
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	40                   	inc    %eax
  801678:	8a 00                	mov    (%eax),%al
  80167a:	3c 78                	cmp    $0x78,%al
  80167c:	75 0d                	jne    80168b <strtol+0x78>
		s += 2, base = 16;
  80167e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801682:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801689:	eb 28                	jmp    8016b3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80168b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168f:	75 15                	jne    8016a6 <strtol+0x93>
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8a 00                	mov    (%eax),%al
  801696:	3c 30                	cmp    $0x30,%al
  801698:	75 0c                	jne    8016a6 <strtol+0x93>
		s++, base = 8;
  80169a:	ff 45 08             	incl   0x8(%ebp)
  80169d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016a4:	eb 0d                	jmp    8016b3 <strtol+0xa0>
	else if (base == 0)
  8016a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016aa:	75 07                	jne    8016b3 <strtol+0xa0>
		base = 10;
  8016ac:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	8a 00                	mov    (%eax),%al
  8016b8:	3c 2f                	cmp    $0x2f,%al
  8016ba:	7e 19                	jle    8016d5 <strtol+0xc2>
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8a 00                	mov    (%eax),%al
  8016c1:	3c 39                	cmp    $0x39,%al
  8016c3:	7f 10                	jg     8016d5 <strtol+0xc2>
			dig = *s - '0';
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8a 00                	mov    (%eax),%al
  8016ca:	0f be c0             	movsbl %al,%eax
  8016cd:	83 e8 30             	sub    $0x30,%eax
  8016d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d3:	eb 42                	jmp    801717 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	8a 00                	mov    (%eax),%al
  8016da:	3c 60                	cmp    $0x60,%al
  8016dc:	7e 19                	jle    8016f7 <strtol+0xe4>
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8a 00                	mov    (%eax),%al
  8016e3:	3c 7a                	cmp    $0x7a,%al
  8016e5:	7f 10                	jg     8016f7 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8a 00                	mov    (%eax),%al
  8016ec:	0f be c0             	movsbl %al,%eax
  8016ef:	83 e8 57             	sub    $0x57,%eax
  8016f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016f5:	eb 20                	jmp    801717 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	8a 00                	mov    (%eax),%al
  8016fc:	3c 40                	cmp    $0x40,%al
  8016fe:	7e 39                	jle    801739 <strtol+0x126>
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	3c 5a                	cmp    $0x5a,%al
  801707:	7f 30                	jg     801739 <strtol+0x126>
			dig = *s - 'A' + 10;
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	0f be c0             	movsbl %al,%eax
  801711:	83 e8 37             	sub    $0x37,%eax
  801714:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80171d:	7d 19                	jge    801738 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80171f:	ff 45 08             	incl   0x8(%ebp)
  801722:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801725:	0f af 45 10          	imul   0x10(%ebp),%eax
  801729:	89 c2                	mov    %eax,%edx
  80172b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172e:	01 d0                	add    %edx,%eax
  801730:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801733:	e9 7b ff ff ff       	jmp    8016b3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801738:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801739:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80173d:	74 08                	je     801747 <strtol+0x134>
		*endptr = (char *) s;
  80173f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801742:	8b 55 08             	mov    0x8(%ebp),%edx
  801745:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801747:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80174b:	74 07                	je     801754 <strtol+0x141>
  80174d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801750:	f7 d8                	neg    %eax
  801752:	eb 03                	jmp    801757 <strtol+0x144>
  801754:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <ltostr>:

void
ltostr(long value, char *str)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80175f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801766:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80176d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801771:	79 13                	jns    801786 <ltostr+0x2d>
	{
		neg = 1;
  801773:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80177a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801780:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801783:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80178e:	99                   	cltd   
  80178f:	f7 f9                	idiv   %ecx
  801791:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801794:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801797:	8d 50 01             	lea    0x1(%eax),%edx
  80179a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80179d:	89 c2                	mov    %eax,%edx
  80179f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a2:	01 d0                	add    %edx,%eax
  8017a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017a7:	83 c2 30             	add    $0x30,%edx
  8017aa:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017af:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017b4:	f7 e9                	imul   %ecx
  8017b6:	c1 fa 02             	sar    $0x2,%edx
  8017b9:	89 c8                	mov    %ecx,%eax
  8017bb:	c1 f8 1f             	sar    $0x1f,%eax
  8017be:	29 c2                	sub    %eax,%edx
  8017c0:	89 d0                	mov    %edx,%eax
  8017c2:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017cd:	f7 e9                	imul   %ecx
  8017cf:	c1 fa 02             	sar    $0x2,%edx
  8017d2:	89 c8                	mov    %ecx,%eax
  8017d4:	c1 f8 1f             	sar    $0x1f,%eax
  8017d7:	29 c2                	sub    %eax,%edx
  8017d9:	89 d0                	mov    %edx,%eax
  8017db:	c1 e0 02             	shl    $0x2,%eax
  8017de:	01 d0                	add    %edx,%eax
  8017e0:	01 c0                	add    %eax,%eax
  8017e2:	29 c1                	sub    %eax,%ecx
  8017e4:	89 ca                	mov    %ecx,%edx
  8017e6:	85 d2                	test   %edx,%edx
  8017e8:	75 9c                	jne    801786 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f4:	48                   	dec    %eax
  8017f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017fc:	74 3d                	je     80183b <ltostr+0xe2>
		start = 1 ;
  8017fe:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801805:	eb 34                	jmp    80183b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801807:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80180a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180d:	01 d0                	add    %edx,%eax
  80180f:	8a 00                	mov    (%eax),%al
  801811:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801814:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801817:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181a:	01 c2                	add    %eax,%edx
  80181c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80181f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801822:	01 c8                	add    %ecx,%eax
  801824:	8a 00                	mov    (%eax),%al
  801826:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801828:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80182b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182e:	01 c2                	add    %eax,%edx
  801830:	8a 45 eb             	mov    -0x15(%ebp),%al
  801833:	88 02                	mov    %al,(%edx)
		start++ ;
  801835:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801838:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80183b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801841:	7c c4                	jl     801807 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801843:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801846:	8b 45 0c             	mov    0xc(%ebp),%eax
  801849:	01 d0                	add    %edx,%eax
  80184b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80184e:	90                   	nop
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801857:	ff 75 08             	pushl  0x8(%ebp)
  80185a:	e8 54 fa ff ff       	call   8012b3 <strlen>
  80185f:	83 c4 04             	add    $0x4,%esp
  801862:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801865:	ff 75 0c             	pushl  0xc(%ebp)
  801868:	e8 46 fa ff ff       	call   8012b3 <strlen>
  80186d:	83 c4 04             	add    $0x4,%esp
  801870:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801873:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80187a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801881:	eb 17                	jmp    80189a <strcconcat+0x49>
		final[s] = str1[s] ;
  801883:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801886:	8b 45 10             	mov    0x10(%ebp),%eax
  801889:	01 c2                	add    %eax,%edx
  80188b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	01 c8                	add    %ecx,%eax
  801893:	8a 00                	mov    (%eax),%al
  801895:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801897:	ff 45 fc             	incl   -0x4(%ebp)
  80189a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80189d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018a0:	7c e1                	jl     801883 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018a2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018b0:	eb 1f                	jmp    8018d1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b5:	8d 50 01             	lea    0x1(%eax),%edx
  8018b8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018bb:	89 c2                	mov    %eax,%edx
  8018bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c0:	01 c2                	add    %eax,%edx
  8018c2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c8:	01 c8                	add    %ecx,%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018ce:	ff 45 f8             	incl   -0x8(%ebp)
  8018d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018d7:	7c d9                	jl     8018b2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018df:	01 d0                	add    %edx,%eax
  8018e1:	c6 00 00             	movb   $0x0,(%eax)
}
  8018e4:	90                   	nop
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f6:	8b 00                	mov    (%eax),%eax
  8018f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801902:	01 d0                	add    %edx,%eax
  801904:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80190a:	eb 0c                	jmp    801918 <strsplit+0x31>
			*string++ = 0;
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	8d 50 01             	lea    0x1(%eax),%edx
  801912:	89 55 08             	mov    %edx,0x8(%ebp)
  801915:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8a 00                	mov    (%eax),%al
  80191d:	84 c0                	test   %al,%al
  80191f:	74 18                	je     801939 <strsplit+0x52>
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	8a 00                	mov    (%eax),%al
  801926:	0f be c0             	movsbl %al,%eax
  801929:	50                   	push   %eax
  80192a:	ff 75 0c             	pushl  0xc(%ebp)
  80192d:	e8 13 fb ff ff       	call   801445 <strchr>
  801932:	83 c4 08             	add    $0x8,%esp
  801935:	85 c0                	test   %eax,%eax
  801937:	75 d3                	jne    80190c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	8a 00                	mov    (%eax),%al
  80193e:	84 c0                	test   %al,%al
  801940:	74 5a                	je     80199c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801942:	8b 45 14             	mov    0x14(%ebp),%eax
  801945:	8b 00                	mov    (%eax),%eax
  801947:	83 f8 0f             	cmp    $0xf,%eax
  80194a:	75 07                	jne    801953 <strsplit+0x6c>
		{
			return 0;
  80194c:	b8 00 00 00 00       	mov    $0x0,%eax
  801951:	eb 66                	jmp    8019b9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801953:	8b 45 14             	mov    0x14(%ebp),%eax
  801956:	8b 00                	mov    (%eax),%eax
  801958:	8d 48 01             	lea    0x1(%eax),%ecx
  80195b:	8b 55 14             	mov    0x14(%ebp),%edx
  80195e:	89 0a                	mov    %ecx,(%edx)
  801960:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801967:	8b 45 10             	mov    0x10(%ebp),%eax
  80196a:	01 c2                	add    %eax,%edx
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801971:	eb 03                	jmp    801976 <strsplit+0x8f>
			string++;
  801973:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	8a 00                	mov    (%eax),%al
  80197b:	84 c0                	test   %al,%al
  80197d:	74 8b                	je     80190a <strsplit+0x23>
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	0f be c0             	movsbl %al,%eax
  801987:	50                   	push   %eax
  801988:	ff 75 0c             	pushl  0xc(%ebp)
  80198b:	e8 b5 fa ff ff       	call   801445 <strchr>
  801990:	83 c4 08             	add    $0x8,%esp
  801993:	85 c0                	test   %eax,%eax
  801995:	74 dc                	je     801973 <strsplit+0x8c>
			string++;
	}
  801997:	e9 6e ff ff ff       	jmp    80190a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80199c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80199d:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a0:	8b 00                	mov    (%eax),%eax
  8019a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ac:	01 d0                	add    %edx,%eax
  8019ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019b4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8019c1:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8019c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8019cb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8019ce:	01 d0                	add    %edx,%eax
  8019d0:	48                   	dec    %eax
  8019d1:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8019d4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8019d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019dc:	f7 75 ac             	divl   -0x54(%ebp)
  8019df:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8019e2:	29 d0                	sub    %edx,%eax
  8019e4:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8019e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8019ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8019f5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8019fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a03:	eb 3f                	jmp    801a44 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801a05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a08:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	50                   	push   %eax
  801a13:	ff 75 e8             	pushl  -0x18(%ebp)
  801a16:	68 64 30 80 00       	push   $0x803064
  801a1b:	e8 0b f0 ff ff       	call   800a2b <cprintf>
  801a20:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a26:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801a2d:	83 ec 04             	sub    $0x4,%esp
  801a30:	50                   	push   %eax
  801a31:	ff 75 e8             	pushl  -0x18(%ebp)
  801a34:	68 79 30 80 00       	push   $0x803079
  801a39:	e8 ed ef ff ff       	call   800a2b <cprintf>
  801a3e:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801a41:	ff 45 e8             	incl   -0x18(%ebp)
  801a44:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801a49:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801a4c:	7c b7                	jl     801a05 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801a4e:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801a55:	e9 42 01 00 00       	jmp    801b9c <malloc+0x1e1>
		int flag0=1;
  801a5a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a64:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a67:	eb 6b                	jmp    801ad4 <malloc+0x119>
			for(int k=0;k<count;k++){
  801a69:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801a70:	eb 42                	jmp    801ab4 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801a72:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a75:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801a7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a7f:	39 c2                	cmp    %eax,%edx
  801a81:	77 2e                	ja     801ab1 <malloc+0xf6>
  801a83:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a86:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801a8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a90:	39 c2                	cmp    %eax,%edx
  801a92:	76 1d                	jbe    801ab1 <malloc+0xf6>
					ni=arr_add[k].end-i;
  801a94:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a97:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801a9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aa1:	29 c2                	sub    %eax,%edx
  801aa3:	89 d0                	mov    %edx,%eax
  801aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801aa8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801aaf:	eb 0d                	jmp    801abe <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801ab1:	ff 45 d8             	incl   -0x28(%ebp)
  801ab4:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801ab9:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801abc:	7c b4                	jl     801a72 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801abe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ac2:	74 09                	je     801acd <malloc+0x112>
				flag0=0;
  801ac4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801acb:	eb 16                	jmp    801ae3 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801acd:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801ad4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	01 c2                	add    %eax,%edx
  801adc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801adf:	39 c2                	cmp    %eax,%edx
  801ae1:	77 86                	ja     801a69 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801ae3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ae7:	0f 84 a2 00 00 00    	je     801b8f <malloc+0x1d4>

			int f=1;
  801aed:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801af4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801af7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801afa:	89 c8                	mov    %ecx,%eax
  801afc:	01 c0                	add    %eax,%eax
  801afe:	01 c8                	add    %ecx,%eax
  801b00:	c1 e0 02             	shl    $0x2,%eax
  801b03:	05 20 41 80 00       	add    $0x804120,%eax
  801b08:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801b0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b16:	89 d0                	mov    %edx,%eax
  801b18:	01 c0                	add    %eax,%eax
  801b1a:	01 d0                	add    %edx,%eax
  801b1c:	c1 e0 02             	shl    $0x2,%eax
  801b1f:	05 24 41 80 00       	add    $0x804124,%eax
  801b24:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801b26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b29:	89 d0                	mov    %edx,%eax
  801b2b:	01 c0                	add    %eax,%eax
  801b2d:	01 d0                	add    %edx,%eax
  801b2f:	c1 e0 02             	shl    $0x2,%eax
  801b32:	05 28 41 80 00       	add    $0x804128,%eax
  801b37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801b3d:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801b40:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801b47:	eb 36                	jmp    801b7f <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801b49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	01 c2                	add    %eax,%edx
  801b51:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b54:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801b5b:	39 c2                	cmp    %eax,%edx
  801b5d:	73 1d                	jae    801b7c <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801b5f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b62:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801b69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b6c:	29 c2                	sub    %eax,%edx
  801b6e:	89 d0                	mov    %edx,%eax
  801b70:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801b73:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801b7a:	eb 0d                	jmp    801b89 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801b7c:	ff 45 d0             	incl   -0x30(%ebp)
  801b7f:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801b84:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801b87:	7c c0                	jl     801b49 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801b89:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801b8d:	75 1d                	jne    801bac <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801b8f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b99:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801b9c:	a1 04 40 80 00       	mov    0x804004,%eax
  801ba1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ba4:	0f 8c b0 fe ff ff    	jl     801a5a <malloc+0x9f>
  801baa:	eb 01                	jmp    801bad <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801bac:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801bad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bb1:	75 7a                	jne    801c2d <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801bb3:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	01 d0                	add    %edx,%eax
  801bbe:	48                   	dec    %eax
  801bbf:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801bc4:	7c 0a                	jl     801bd0 <malloc+0x215>
			return NULL;
  801bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcb:	e9 a4 02 00 00       	jmp    801e74 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801bd0:	a1 04 40 80 00       	mov    0x804004,%eax
  801bd5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801bd8:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bdd:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801be0:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801be7:	83 ec 08             	sub    $0x8,%esp
  801bea:	ff 75 08             	pushl  0x8(%ebp)
  801bed:	ff 75 a4             	pushl  -0x5c(%ebp)
  801bf0:	e8 04 06 00 00       	call   8021f9 <sys_allocateMem>
  801bf5:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801bf8:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	01 d0                	add    %edx,%eax
  801c03:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801c08:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801c0d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c13:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801c1a:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801c1f:	40                   	inc    %eax
  801c20:	a3 2c 40 80 00       	mov    %eax,0x80402c

			return (void*)s;
  801c25:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801c28:	e9 47 02 00 00       	jmp    801e74 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801c2d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801c34:	e9 ac 00 00 00       	jmp    801ce5 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801c39:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801c3c:	89 d0                	mov    %edx,%eax
  801c3e:	01 c0                	add    %eax,%eax
  801c40:	01 d0                	add    %edx,%eax
  801c42:	c1 e0 02             	shl    $0x2,%eax
  801c45:	05 24 41 80 00       	add    $0x804124,%eax
  801c4a:	8b 00                	mov    (%eax),%eax
  801c4c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801c4f:	eb 7e                	jmp    801ccf <malloc+0x314>
			int flag=0;
  801c51:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801c58:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801c5f:	eb 57                	jmp    801cb8 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801c61:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c64:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801c6b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c6e:	39 c2                	cmp    %eax,%edx
  801c70:	77 1a                	ja     801c8c <malloc+0x2d1>
  801c72:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c75:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801c7c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c7f:	39 c2                	cmp    %eax,%edx
  801c81:	76 09                	jbe    801c8c <malloc+0x2d1>
								flag=1;
  801c83:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801c8a:	eb 36                	jmp    801cc2 <malloc+0x307>
			arr[i].space++;
  801c8c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801c8f:	89 d0                	mov    %edx,%eax
  801c91:	01 c0                	add    %eax,%eax
  801c93:	01 d0                	add    %edx,%eax
  801c95:	c1 e0 02             	shl    $0x2,%eax
  801c98:	05 28 41 80 00       	add    $0x804128,%eax
  801c9d:	8b 00                	mov    (%eax),%eax
  801c9f:	8d 48 01             	lea    0x1(%eax),%ecx
  801ca2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801ca5:	89 d0                	mov    %edx,%eax
  801ca7:	01 c0                	add    %eax,%eax
  801ca9:	01 d0                	add    %edx,%eax
  801cab:	c1 e0 02             	shl    $0x2,%eax
  801cae:	05 28 41 80 00       	add    $0x804128,%eax
  801cb3:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801cb5:	ff 45 c0             	incl   -0x40(%ebp)
  801cb8:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801cbd:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801cc0:	7c 9f                	jl     801c61 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801cc2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801cc6:	75 19                	jne    801ce1 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801cc8:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801ccf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801cd2:	a1 04 40 80 00       	mov    0x804004,%eax
  801cd7:	39 c2                	cmp    %eax,%edx
  801cd9:	0f 82 72 ff ff ff    	jb     801c51 <malloc+0x296>
  801cdf:	eb 01                	jmp    801ce2 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801ce1:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801ce2:	ff 45 cc             	incl   -0x34(%ebp)
  801ce5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ce8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ceb:	0f 8c 48 ff ff ff    	jl     801c39 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801cf1:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801cf8:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801cff:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801d06:	eb 37                	jmp    801d3f <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801d08:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801d0b:	89 d0                	mov    %edx,%eax
  801d0d:	01 c0                	add    %eax,%eax
  801d0f:	01 d0                	add    %edx,%eax
  801d11:	c1 e0 02             	shl    $0x2,%eax
  801d14:	05 28 41 80 00       	add    $0x804128,%eax
  801d19:	8b 00                	mov    (%eax),%eax
  801d1b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801d1e:	7d 1c                	jge    801d3c <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801d20:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801d23:	89 d0                	mov    %edx,%eax
  801d25:	01 c0                	add    %eax,%eax
  801d27:	01 d0                	add    %edx,%eax
  801d29:	c1 e0 02             	shl    $0x2,%eax
  801d2c:	05 28 41 80 00       	add    $0x804128,%eax
  801d31:	8b 00                	mov    (%eax),%eax
  801d33:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801d36:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801d39:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801d3c:	ff 45 b4             	incl   -0x4c(%ebp)
  801d3f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801d42:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d45:	7c c1                	jl     801d08 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801d47:	8b 15 2c 40 80 00    	mov    0x80402c,%edx
  801d4d:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801d50:	89 c8                	mov    %ecx,%eax
  801d52:	01 c0                	add    %eax,%eax
  801d54:	01 c8                	add    %ecx,%eax
  801d56:	c1 e0 02             	shl    $0x2,%eax
  801d59:	05 20 41 80 00       	add    $0x804120,%eax
  801d5e:	8b 00                	mov    (%eax),%eax
  801d60:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801d67:	8b 15 2c 40 80 00    	mov    0x80402c,%edx
  801d6d:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801d70:	89 c8                	mov    %ecx,%eax
  801d72:	01 c0                	add    %eax,%eax
  801d74:	01 c8                	add    %ecx,%eax
  801d76:	c1 e0 02             	shl    $0x2,%eax
  801d79:	05 24 41 80 00       	add    $0x804124,%eax
  801d7e:	8b 00                	mov    (%eax),%eax
  801d80:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  801d87:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801d8c:	40                   	inc    %eax
  801d8d:	a3 2c 40 80 00       	mov    %eax,0x80402c


		sys_allocateMem(arr[index].start,size);
  801d92:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801d95:	89 d0                	mov    %edx,%eax
  801d97:	01 c0                	add    %eax,%eax
  801d99:	01 d0                	add    %edx,%eax
  801d9b:	c1 e0 02             	shl    $0x2,%eax
  801d9e:	05 20 41 80 00       	add    $0x804120,%eax
  801da3:	8b 00                	mov    (%eax),%eax
  801da5:	83 ec 08             	sub    $0x8,%esp
  801da8:	ff 75 08             	pushl  0x8(%ebp)
  801dab:	50                   	push   %eax
  801dac:	e8 48 04 00 00       	call   8021f9 <sys_allocateMem>
  801db1:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801db4:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801dbb:	eb 78                	jmp    801e35 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801dbd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801dc0:	89 d0                	mov    %edx,%eax
  801dc2:	01 c0                	add    %eax,%eax
  801dc4:	01 d0                	add    %edx,%eax
  801dc6:	c1 e0 02             	shl    $0x2,%eax
  801dc9:	05 20 41 80 00       	add    $0x804120,%eax
  801dce:	8b 00                	mov    (%eax),%eax
  801dd0:	83 ec 04             	sub    $0x4,%esp
  801dd3:	50                   	push   %eax
  801dd4:	ff 75 b0             	pushl  -0x50(%ebp)
  801dd7:	68 64 30 80 00       	push   $0x803064
  801ddc:	e8 4a ec ff ff       	call   800a2b <cprintf>
  801de1:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801de4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801de7:	89 d0                	mov    %edx,%eax
  801de9:	01 c0                	add    %eax,%eax
  801deb:	01 d0                	add    %edx,%eax
  801ded:	c1 e0 02             	shl    $0x2,%eax
  801df0:	05 24 41 80 00       	add    $0x804124,%eax
  801df5:	8b 00                	mov    (%eax),%eax
  801df7:	83 ec 04             	sub    $0x4,%esp
  801dfa:	50                   	push   %eax
  801dfb:	ff 75 b0             	pushl  -0x50(%ebp)
  801dfe:	68 79 30 80 00       	push   $0x803079
  801e03:	e8 23 ec ff ff       	call   800a2b <cprintf>
  801e08:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801e0b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e0e:	89 d0                	mov    %edx,%eax
  801e10:	01 c0                	add    %eax,%eax
  801e12:	01 d0                	add    %edx,%eax
  801e14:	c1 e0 02             	shl    $0x2,%eax
  801e17:	05 28 41 80 00       	add    $0x804128,%eax
  801e1c:	8b 00                	mov    (%eax),%eax
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	50                   	push   %eax
  801e22:	ff 75 b0             	pushl  -0x50(%ebp)
  801e25:	68 8c 30 80 00       	push   $0x80308c
  801e2a:	e8 fc eb ff ff       	call   800a2b <cprintf>
  801e2f:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801e32:	ff 45 b0             	incl   -0x50(%ebp)
  801e35:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801e38:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e3b:	7c 80                	jl     801dbd <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801e3d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e40:	89 d0                	mov    %edx,%eax
  801e42:	01 c0                	add    %eax,%eax
  801e44:	01 d0                	add    %edx,%eax
  801e46:	c1 e0 02             	shl    $0x2,%eax
  801e49:	05 20 41 80 00       	add    $0x804120,%eax
  801e4e:	8b 00                	mov    (%eax),%eax
  801e50:	83 ec 08             	sub    $0x8,%esp
  801e53:	50                   	push   %eax
  801e54:	68 a0 30 80 00       	push   $0x8030a0
  801e59:	e8 cd eb ff ff       	call   800a2b <cprintf>
  801e5e:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801e61:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e64:	89 d0                	mov    %edx,%eax
  801e66:	01 c0                	add    %eax,%eax
  801e68:	01 d0                	add    %edx,%eax
  801e6a:	c1 e0 02             	shl    $0x2,%eax
  801e6d:	05 20 41 80 00       	add    $0x804120,%eax
  801e72:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801e82:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801e89:	eb 4b                	jmp    801ed6 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e8e:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801e95:	89 c2                	mov    %eax,%edx
  801e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e9a:	39 c2                	cmp    %eax,%edx
  801e9c:	7f 35                	jg     801ed3 <free+0x5d>
  801e9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea1:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801ea8:	89 c2                	mov    %eax,%edx
  801eaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ead:	39 c2                	cmp    %eax,%edx
  801eaf:	7e 22                	jle    801ed3 <free+0x5d>
				start=arr_add[i].start;
  801eb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb4:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801ebb:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec1:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801ec8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ece:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801ed1:	eb 0d                	jmp    801ee0 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801ed3:	ff 45 ec             	incl   -0x14(%ebp)
  801ed6:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801edb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801ede:	7c ab                	jl     801e8b <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee3:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eed:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801ef4:	29 c2                	sub    %eax,%edx
  801ef6:	89 d0                	mov    %edx,%eax
  801ef8:	83 ec 08             	sub    $0x8,%esp
  801efb:	50                   	push   %eax
  801efc:	ff 75 f4             	pushl  -0xc(%ebp)
  801eff:	e8 d9 02 00 00       	call   8021dd <sys_freeMem>
  801f04:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f0d:	eb 2d                	jmp    801f3c <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801f0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f12:	40                   	inc    %eax
  801f13:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801f1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f1d:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801f24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f27:	40                   	inc    %eax
  801f28:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801f2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f32:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801f39:	ff 45 e8             	incl   -0x18(%ebp)
  801f3c:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801f41:	48                   	dec    %eax
  801f42:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f45:	7f c8                	jg     801f0f <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801f47:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801f4c:	48                   	dec    %eax
  801f4d:	a3 2c 40 80 00       	mov    %eax,0x80402c
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801f52:	90                   	nop
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 18             	sub    $0x18,%esp
  801f5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5e:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801f61:	83 ec 04             	sub    $0x4,%esp
  801f64:	68 bc 30 80 00       	push   $0x8030bc
  801f69:	68 18 01 00 00       	push   $0x118
  801f6e:	68 df 30 80 00       	push   $0x8030df
  801f73:	e8 11 e8 ff ff       	call   800789 <_panic>

00801f78 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f7e:	83 ec 04             	sub    $0x4,%esp
  801f81:	68 bc 30 80 00       	push   $0x8030bc
  801f86:	68 1e 01 00 00       	push   $0x11e
  801f8b:	68 df 30 80 00       	push   $0x8030df
  801f90:	e8 f4 e7 ff ff       	call   800789 <_panic>

00801f95 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f9b:	83 ec 04             	sub    $0x4,%esp
  801f9e:	68 bc 30 80 00       	push   $0x8030bc
  801fa3:	68 24 01 00 00       	push   $0x124
  801fa8:	68 df 30 80 00       	push   $0x8030df
  801fad:	e8 d7 e7 ff ff       	call   800789 <_panic>

00801fb2 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fb8:	83 ec 04             	sub    $0x4,%esp
  801fbb:	68 bc 30 80 00       	push   $0x8030bc
  801fc0:	68 29 01 00 00       	push   $0x129
  801fc5:	68 df 30 80 00       	push   $0x8030df
  801fca:	e8 ba e7 ff ff       	call   800789 <_panic>

00801fcf <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fd5:	83 ec 04             	sub    $0x4,%esp
  801fd8:	68 bc 30 80 00       	push   $0x8030bc
  801fdd:	68 2f 01 00 00       	push   $0x12f
  801fe2:	68 df 30 80 00       	push   $0x8030df
  801fe7:	e8 9d e7 ff ff       	call   800789 <_panic>

00801fec <shrink>:
}
void shrink(uint32 newSize)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ff2:	83 ec 04             	sub    $0x4,%esp
  801ff5:	68 bc 30 80 00       	push   $0x8030bc
  801ffa:	68 33 01 00 00       	push   $0x133
  801fff:	68 df 30 80 00       	push   $0x8030df
  802004:	e8 80 e7 ff ff       	call   800789 <_panic>

00802009 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80200f:	83 ec 04             	sub    $0x4,%esp
  802012:	68 bc 30 80 00       	push   $0x8030bc
  802017:	68 38 01 00 00       	push   $0x138
  80201c:	68 df 30 80 00       	push   $0x8030df
  802021:	e8 63 e7 ff ff       	call   800789 <_panic>

00802026 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	57                   	push   %edi
  80202a:	56                   	push   %esi
  80202b:	53                   	push   %ebx
  80202c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	8b 55 0c             	mov    0xc(%ebp),%edx
  802035:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802038:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80203b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80203e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802041:	cd 30                	int    $0x30
  802043:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802046:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802049:	83 c4 10             	add    $0x10,%esp
  80204c:	5b                   	pop    %ebx
  80204d:	5e                   	pop    %esi
  80204e:	5f                   	pop    %edi
  80204f:	5d                   	pop    %ebp
  802050:	c3                   	ret    

00802051 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 04             	sub    $0x4,%esp
  802057:	8b 45 10             	mov    0x10(%ebp),%eax
  80205a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80205d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	52                   	push   %edx
  802069:	ff 75 0c             	pushl  0xc(%ebp)
  80206c:	50                   	push   %eax
  80206d:	6a 00                	push   $0x0
  80206f:	e8 b2 ff ff ff       	call   802026 <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	90                   	nop
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <sys_cgetc>:

int
sys_cgetc(void)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 01                	push   $0x1
  802089:	e8 98 ff ff ff       	call   802026 <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	50                   	push   %eax
  8020a2:	6a 05                	push   $0x5
  8020a4:	e8 7d ff ff ff       	call   802026 <syscall>
  8020a9:	83 c4 18             	add    $0x18,%esp
}
  8020ac:	c9                   	leave  
  8020ad:	c3                   	ret    

008020ae <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 02                	push   $0x2
  8020bd:	e8 64 ff ff ff       	call   802026 <syscall>
  8020c2:	83 c4 18             	add    $0x18,%esp
}
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 03                	push   $0x3
  8020d6:	e8 4b ff ff ff       	call   802026 <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 04                	push   $0x4
  8020ef:	e8 32 ff ff ff       	call   802026 <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <sys_env_exit>:


void sys_env_exit(void)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 06                	push   $0x6
  802108:	e8 19 ff ff ff       	call   802026 <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
}
  802110:	90                   	nop
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802116:	8b 55 0c             	mov    0xc(%ebp),%edx
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	52                   	push   %edx
  802123:	50                   	push   %eax
  802124:	6a 07                	push   $0x7
  802126:	e8 fb fe ff ff       	call   802026 <syscall>
  80212b:	83 c4 18             	add    $0x18,%esp
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	56                   	push   %esi
  802134:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802135:	8b 75 18             	mov    0x18(%ebp),%esi
  802138:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80213b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80213e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	56                   	push   %esi
  802145:	53                   	push   %ebx
  802146:	51                   	push   %ecx
  802147:	52                   	push   %edx
  802148:	50                   	push   %eax
  802149:	6a 08                	push   $0x8
  80214b:	e8 d6 fe ff ff       	call   802026 <syscall>
  802150:	83 c4 18             	add    $0x18,%esp
}
  802153:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802156:	5b                   	pop    %ebx
  802157:	5e                   	pop    %esi
  802158:	5d                   	pop    %ebp
  802159:	c3                   	ret    

0080215a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80215d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	52                   	push   %edx
  80216a:	50                   	push   %eax
  80216b:	6a 09                	push   $0x9
  80216d:	e8 b4 fe ff ff       	call   802026 <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	ff 75 0c             	pushl  0xc(%ebp)
  802183:	ff 75 08             	pushl  0x8(%ebp)
  802186:	6a 0a                	push   $0xa
  802188:	e8 99 fe ff ff       	call   802026 <syscall>
  80218d:	83 c4 18             	add    $0x18,%esp
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 0b                	push   $0xb
  8021a1:	e8 80 fe ff ff       	call   802026 <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 0c                	push   $0xc
  8021ba:	e8 67 fe ff ff       	call   802026 <syscall>
  8021bf:	83 c4 18             	add    $0x18,%esp
}
  8021c2:	c9                   	leave  
  8021c3:	c3                   	ret    

008021c4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 0d                	push   $0xd
  8021d3:	e8 4e fe ff ff       	call   802026 <syscall>
  8021d8:	83 c4 18             	add    $0x18,%esp
}
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    

008021dd <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	ff 75 0c             	pushl  0xc(%ebp)
  8021e9:	ff 75 08             	pushl  0x8(%ebp)
  8021ec:	6a 11                	push   $0x11
  8021ee:	e8 33 fe ff ff       	call   802026 <syscall>
  8021f3:	83 c4 18             	add    $0x18,%esp
	return;
  8021f6:	90                   	nop
}
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	ff 75 0c             	pushl  0xc(%ebp)
  802205:	ff 75 08             	pushl  0x8(%ebp)
  802208:	6a 12                	push   $0x12
  80220a:	e8 17 fe ff ff       	call   802026 <syscall>
  80220f:	83 c4 18             	add    $0x18,%esp
	return ;
  802212:	90                   	nop
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 0e                	push   $0xe
  802224:	e8 fd fd ff ff       	call   802026 <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	ff 75 08             	pushl  0x8(%ebp)
  80223c:	6a 0f                	push   $0xf
  80223e:	e8 e3 fd ff ff       	call   802026 <syscall>
  802243:	83 c4 18             	add    $0x18,%esp
}
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 10                	push   $0x10
  802257:	e8 ca fd ff ff       	call   802026 <syscall>
  80225c:	83 c4 18             	add    $0x18,%esp
}
  80225f:	90                   	nop
  802260:	c9                   	leave  
  802261:	c3                   	ret    

00802262 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 14                	push   $0x14
  802271:	e8 b0 fd ff ff       	call   802026 <syscall>
  802276:	83 c4 18             	add    $0x18,%esp
}
  802279:	90                   	nop
  80227a:	c9                   	leave  
  80227b:	c3                   	ret    

0080227c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 15                	push   $0x15
  80228b:	e8 96 fd ff ff       	call   802026 <syscall>
  802290:	83 c4 18             	add    $0x18,%esp
}
  802293:	90                   	nop
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <sys_cputc>:


void
sys_cputc(const char c)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	83 ec 04             	sub    $0x4,%esp
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022a2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	50                   	push   %eax
  8022af:	6a 16                	push   $0x16
  8022b1:	e8 70 fd ff ff       	call   802026 <syscall>
  8022b6:	83 c4 18             	add    $0x18,%esp
}
  8022b9:	90                   	nop
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 17                	push   $0x17
  8022cb:	e8 56 fd ff ff       	call   802026 <syscall>
  8022d0:	83 c4 18             	add    $0x18,%esp
}
  8022d3:	90                   	nop
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	ff 75 0c             	pushl  0xc(%ebp)
  8022e5:	50                   	push   %eax
  8022e6:	6a 18                	push   $0x18
  8022e8:	e8 39 fd ff ff       	call   802026 <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
}
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	52                   	push   %edx
  802302:	50                   	push   %eax
  802303:	6a 1b                	push   $0x1b
  802305:	e8 1c fd ff ff       	call   802026 <syscall>
  80230a:	83 c4 18             	add    $0x18,%esp
}
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    

0080230f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802312:	8b 55 0c             	mov    0xc(%ebp),%edx
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	52                   	push   %edx
  80231f:	50                   	push   %eax
  802320:	6a 19                	push   $0x19
  802322:	e8 ff fc ff ff       	call   802026 <syscall>
  802327:	83 c4 18             	add    $0x18,%esp
}
  80232a:	90                   	nop
  80232b:	c9                   	leave  
  80232c:	c3                   	ret    

0080232d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802330:	8b 55 0c             	mov    0xc(%ebp),%edx
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	52                   	push   %edx
  80233d:	50                   	push   %eax
  80233e:	6a 1a                	push   $0x1a
  802340:	e8 e1 fc ff ff       	call   802026 <syscall>
  802345:	83 c4 18             	add    $0x18,%esp
}
  802348:	90                   	nop
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	83 ec 04             	sub    $0x4,%esp
  802351:	8b 45 10             	mov    0x10(%ebp),%eax
  802354:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802357:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80235a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	6a 00                	push   $0x0
  802363:	51                   	push   %ecx
  802364:	52                   	push   %edx
  802365:	ff 75 0c             	pushl  0xc(%ebp)
  802368:	50                   	push   %eax
  802369:	6a 1c                	push   $0x1c
  80236b:	e8 b6 fc ff ff       	call   802026 <syscall>
  802370:	83 c4 18             	add    $0x18,%esp
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802378:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	52                   	push   %edx
  802385:	50                   	push   %eax
  802386:	6a 1d                	push   $0x1d
  802388:	e8 99 fc ff ff       	call   802026 <syscall>
  80238d:	83 c4 18             	add    $0x18,%esp
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802395:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802398:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	51                   	push   %ecx
  8023a3:	52                   	push   %edx
  8023a4:	50                   	push   %eax
  8023a5:	6a 1e                	push   $0x1e
  8023a7:	e8 7a fc ff ff       	call   802026 <syscall>
  8023ac:	83 c4 18             	add    $0x18,%esp
}
  8023af:	c9                   	leave  
  8023b0:	c3                   	ret    

008023b1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	52                   	push   %edx
  8023c1:	50                   	push   %eax
  8023c2:	6a 1f                	push   $0x1f
  8023c4:	e8 5d fc ff ff       	call   802026 <syscall>
  8023c9:	83 c4 18             	add    $0x18,%esp
}
  8023cc:	c9                   	leave  
  8023cd:	c3                   	ret    

008023ce <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 20                	push   $0x20
  8023dd:	e8 44 fc ff ff       	call   802026 <syscall>
  8023e2:	83 c4 18             	add    $0x18,%esp
}
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	6a 00                	push   $0x0
  8023ef:	ff 75 14             	pushl  0x14(%ebp)
  8023f2:	ff 75 10             	pushl  0x10(%ebp)
  8023f5:	ff 75 0c             	pushl  0xc(%ebp)
  8023f8:	50                   	push   %eax
  8023f9:	6a 21                	push   $0x21
  8023fb:	e8 26 fc ff ff       	call   802026 <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	50                   	push   %eax
  802414:	6a 22                	push   $0x22
  802416:	e8 0b fc ff ff       	call   802026 <syscall>
  80241b:	83 c4 18             	add    $0x18,%esp
}
  80241e:	90                   	nop
  80241f:	c9                   	leave  
  802420:	c3                   	ret    

00802421 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	50                   	push   %eax
  802430:	6a 23                	push   $0x23
  802432:	e8 ef fb ff ff       	call   802026 <syscall>
  802437:	83 c4 18             	add    $0x18,%esp
}
  80243a:	90                   	nop
  80243b:	c9                   	leave  
  80243c:	c3                   	ret    

0080243d <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80243d:	55                   	push   %ebp
  80243e:	89 e5                	mov    %esp,%ebp
  802440:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802443:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802446:	8d 50 04             	lea    0x4(%eax),%edx
  802449:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	52                   	push   %edx
  802453:	50                   	push   %eax
  802454:	6a 24                	push   $0x24
  802456:	e8 cb fb ff ff       	call   802026 <syscall>
  80245b:	83 c4 18             	add    $0x18,%esp
	return result;
  80245e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802461:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802464:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802467:	89 01                	mov    %eax,(%ecx)
  802469:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80246c:	8b 45 08             	mov    0x8(%ebp),%eax
  80246f:	c9                   	leave  
  802470:	c2 04 00             	ret    $0x4

00802473 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	ff 75 10             	pushl  0x10(%ebp)
  80247d:	ff 75 0c             	pushl  0xc(%ebp)
  802480:	ff 75 08             	pushl  0x8(%ebp)
  802483:	6a 13                	push   $0x13
  802485:	e8 9c fb ff ff       	call   802026 <syscall>
  80248a:	83 c4 18             	add    $0x18,%esp
	return ;
  80248d:	90                   	nop
}
  80248e:	c9                   	leave  
  80248f:	c3                   	ret    

00802490 <sys_rcr2>:
uint32 sys_rcr2()
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 25                	push   $0x25
  80249f:	e8 82 fb ff ff       	call   802026 <syscall>
  8024a4:	83 c4 18             	add    $0x18,%esp
}
  8024a7:	c9                   	leave  
  8024a8:	c3                   	ret    

008024a9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024a9:	55                   	push   %ebp
  8024aa:	89 e5                	mov    %esp,%ebp
  8024ac:	83 ec 04             	sub    $0x4,%esp
  8024af:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024b5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	50                   	push   %eax
  8024c2:	6a 26                	push   $0x26
  8024c4:	e8 5d fb ff ff       	call   802026 <syscall>
  8024c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024cc:	90                   	nop
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <rsttst>:
void rsttst()
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 28                	push   $0x28
  8024de:	e8 43 fb ff ff       	call   802026 <syscall>
  8024e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e6:	90                   	nop
}
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	83 ec 04             	sub    $0x4,%esp
  8024ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8024f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024f5:	8b 55 18             	mov    0x18(%ebp),%edx
  8024f8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024fc:	52                   	push   %edx
  8024fd:	50                   	push   %eax
  8024fe:	ff 75 10             	pushl  0x10(%ebp)
  802501:	ff 75 0c             	pushl  0xc(%ebp)
  802504:	ff 75 08             	pushl  0x8(%ebp)
  802507:	6a 27                	push   $0x27
  802509:	e8 18 fb ff ff       	call   802026 <syscall>
  80250e:	83 c4 18             	add    $0x18,%esp
	return ;
  802511:	90                   	nop
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <chktst>:
void chktst(uint32 n)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	ff 75 08             	pushl  0x8(%ebp)
  802522:	6a 29                	push   $0x29
  802524:	e8 fd fa ff ff       	call   802026 <syscall>
  802529:	83 c4 18             	add    $0x18,%esp
	return ;
  80252c:	90                   	nop
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <inctst>:

void inctst()
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 2a                	push   $0x2a
  80253e:	e8 e3 fa ff ff       	call   802026 <syscall>
  802543:	83 c4 18             	add    $0x18,%esp
	return ;
  802546:	90                   	nop
}
  802547:	c9                   	leave  
  802548:	c3                   	ret    

00802549 <gettst>:
uint32 gettst()
{
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 2b                	push   $0x2b
  802558:	e8 c9 fa ff ff       	call   802026 <syscall>
  80255d:	83 c4 18             	add    $0x18,%esp
}
  802560:	c9                   	leave  
  802561:	c3                   	ret    

00802562 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
  802565:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 2c                	push   $0x2c
  802574:	e8 ad fa ff ff       	call   802026 <syscall>
  802579:	83 c4 18             	add    $0x18,%esp
  80257c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80257f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802583:	75 07                	jne    80258c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802585:	b8 01 00 00 00       	mov    $0x1,%eax
  80258a:	eb 05                	jmp    802591 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80258c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802591:	c9                   	leave  
  802592:	c3                   	ret    

00802593 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
  802596:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 2c                	push   $0x2c
  8025a5:	e8 7c fa ff ff       	call   802026 <syscall>
  8025aa:	83 c4 18             	add    $0x18,%esp
  8025ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025b0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025b4:	75 07                	jne    8025bd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bb:	eb 05                	jmp    8025c2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 2c                	push   $0x2c
  8025d6:	e8 4b fa ff ff       	call   802026 <syscall>
  8025db:	83 c4 18             	add    $0x18,%esp
  8025de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025e1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025e5:	75 07                	jne    8025ee <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ec:	eb 05                	jmp    8025f3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    

008025f5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
  8025f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 2c                	push   $0x2c
  802607:	e8 1a fa ff ff       	call   802026 <syscall>
  80260c:	83 c4 18             	add    $0x18,%esp
  80260f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802612:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802616:	75 07                	jne    80261f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802618:	b8 01 00 00 00       	mov    $0x1,%eax
  80261d:	eb 05                	jmp    802624 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80261f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802624:	c9                   	leave  
  802625:	c3                   	ret    

00802626 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	ff 75 08             	pushl  0x8(%ebp)
  802634:	6a 2d                	push   $0x2d
  802636:	e8 eb f9 ff ff       	call   802026 <syscall>
  80263b:	83 c4 18             	add    $0x18,%esp
	return ;
  80263e:	90                   	nop
}
  80263f:	c9                   	leave  
  802640:	c3                   	ret    

00802641 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802641:	55                   	push   %ebp
  802642:	89 e5                	mov    %esp,%ebp
  802644:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802645:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802648:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80264b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80264e:	8b 45 08             	mov    0x8(%ebp),%eax
  802651:	6a 00                	push   $0x0
  802653:	53                   	push   %ebx
  802654:	51                   	push   %ecx
  802655:	52                   	push   %edx
  802656:	50                   	push   %eax
  802657:	6a 2e                	push   $0x2e
  802659:	e8 c8 f9 ff ff       	call   802026 <syscall>
  80265e:	83 c4 18             	add    $0x18,%esp
}
  802661:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802669:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266c:	8b 45 08             	mov    0x8(%ebp),%eax
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	52                   	push   %edx
  802676:	50                   	push   %eax
  802677:	6a 2f                	push   $0x2f
  802679:	e8 a8 f9 ff ff       	call   802026 <syscall>
  80267e:	83 c4 18             	add    $0x18,%esp
}
  802681:	c9                   	leave  
  802682:	c3                   	ret    
  802683:	90                   	nop

00802684 <__udivdi3>:
  802684:	55                   	push   %ebp
  802685:	57                   	push   %edi
  802686:	56                   	push   %esi
  802687:	53                   	push   %ebx
  802688:	83 ec 1c             	sub    $0x1c,%esp
  80268b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80268f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802693:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802697:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80269b:	89 ca                	mov    %ecx,%edx
  80269d:	89 f8                	mov    %edi,%eax
  80269f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8026a3:	85 f6                	test   %esi,%esi
  8026a5:	75 2d                	jne    8026d4 <__udivdi3+0x50>
  8026a7:	39 cf                	cmp    %ecx,%edi
  8026a9:	77 65                	ja     802710 <__udivdi3+0x8c>
  8026ab:	89 fd                	mov    %edi,%ebp
  8026ad:	85 ff                	test   %edi,%edi
  8026af:	75 0b                	jne    8026bc <__udivdi3+0x38>
  8026b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8026b6:	31 d2                	xor    %edx,%edx
  8026b8:	f7 f7                	div    %edi
  8026ba:	89 c5                	mov    %eax,%ebp
  8026bc:	31 d2                	xor    %edx,%edx
  8026be:	89 c8                	mov    %ecx,%eax
  8026c0:	f7 f5                	div    %ebp
  8026c2:	89 c1                	mov    %eax,%ecx
  8026c4:	89 d8                	mov    %ebx,%eax
  8026c6:	f7 f5                	div    %ebp
  8026c8:	89 cf                	mov    %ecx,%edi
  8026ca:	89 fa                	mov    %edi,%edx
  8026cc:	83 c4 1c             	add    $0x1c,%esp
  8026cf:	5b                   	pop    %ebx
  8026d0:	5e                   	pop    %esi
  8026d1:	5f                   	pop    %edi
  8026d2:	5d                   	pop    %ebp
  8026d3:	c3                   	ret    
  8026d4:	39 ce                	cmp    %ecx,%esi
  8026d6:	77 28                	ja     802700 <__udivdi3+0x7c>
  8026d8:	0f bd fe             	bsr    %esi,%edi
  8026db:	83 f7 1f             	xor    $0x1f,%edi
  8026de:	75 40                	jne    802720 <__udivdi3+0x9c>
  8026e0:	39 ce                	cmp    %ecx,%esi
  8026e2:	72 0a                	jb     8026ee <__udivdi3+0x6a>
  8026e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8026e8:	0f 87 9e 00 00 00    	ja     80278c <__udivdi3+0x108>
  8026ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f3:	89 fa                	mov    %edi,%edx
  8026f5:	83 c4 1c             	add    $0x1c,%esp
  8026f8:	5b                   	pop    %ebx
  8026f9:	5e                   	pop    %esi
  8026fa:	5f                   	pop    %edi
  8026fb:	5d                   	pop    %ebp
  8026fc:	c3                   	ret    
  8026fd:	8d 76 00             	lea    0x0(%esi),%esi
  802700:	31 ff                	xor    %edi,%edi
  802702:	31 c0                	xor    %eax,%eax
  802704:	89 fa                	mov    %edi,%edx
  802706:	83 c4 1c             	add    $0x1c,%esp
  802709:	5b                   	pop    %ebx
  80270a:	5e                   	pop    %esi
  80270b:	5f                   	pop    %edi
  80270c:	5d                   	pop    %ebp
  80270d:	c3                   	ret    
  80270e:	66 90                	xchg   %ax,%ax
  802710:	89 d8                	mov    %ebx,%eax
  802712:	f7 f7                	div    %edi
  802714:	31 ff                	xor    %edi,%edi
  802716:	89 fa                	mov    %edi,%edx
  802718:	83 c4 1c             	add    $0x1c,%esp
  80271b:	5b                   	pop    %ebx
  80271c:	5e                   	pop    %esi
  80271d:	5f                   	pop    %edi
  80271e:	5d                   	pop    %ebp
  80271f:	c3                   	ret    
  802720:	bd 20 00 00 00       	mov    $0x20,%ebp
  802725:	89 eb                	mov    %ebp,%ebx
  802727:	29 fb                	sub    %edi,%ebx
  802729:	89 f9                	mov    %edi,%ecx
  80272b:	d3 e6                	shl    %cl,%esi
  80272d:	89 c5                	mov    %eax,%ebp
  80272f:	88 d9                	mov    %bl,%cl
  802731:	d3 ed                	shr    %cl,%ebp
  802733:	89 e9                	mov    %ebp,%ecx
  802735:	09 f1                	or     %esi,%ecx
  802737:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80273b:	89 f9                	mov    %edi,%ecx
  80273d:	d3 e0                	shl    %cl,%eax
  80273f:	89 c5                	mov    %eax,%ebp
  802741:	89 d6                	mov    %edx,%esi
  802743:	88 d9                	mov    %bl,%cl
  802745:	d3 ee                	shr    %cl,%esi
  802747:	89 f9                	mov    %edi,%ecx
  802749:	d3 e2                	shl    %cl,%edx
  80274b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80274f:	88 d9                	mov    %bl,%cl
  802751:	d3 e8                	shr    %cl,%eax
  802753:	09 c2                	or     %eax,%edx
  802755:	89 d0                	mov    %edx,%eax
  802757:	89 f2                	mov    %esi,%edx
  802759:	f7 74 24 0c          	divl   0xc(%esp)
  80275d:	89 d6                	mov    %edx,%esi
  80275f:	89 c3                	mov    %eax,%ebx
  802761:	f7 e5                	mul    %ebp
  802763:	39 d6                	cmp    %edx,%esi
  802765:	72 19                	jb     802780 <__udivdi3+0xfc>
  802767:	74 0b                	je     802774 <__udivdi3+0xf0>
  802769:	89 d8                	mov    %ebx,%eax
  80276b:	31 ff                	xor    %edi,%edi
  80276d:	e9 58 ff ff ff       	jmp    8026ca <__udivdi3+0x46>
  802772:	66 90                	xchg   %ax,%ax
  802774:	8b 54 24 08          	mov    0x8(%esp),%edx
  802778:	89 f9                	mov    %edi,%ecx
  80277a:	d3 e2                	shl    %cl,%edx
  80277c:	39 c2                	cmp    %eax,%edx
  80277e:	73 e9                	jae    802769 <__udivdi3+0xe5>
  802780:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802783:	31 ff                	xor    %edi,%edi
  802785:	e9 40 ff ff ff       	jmp    8026ca <__udivdi3+0x46>
  80278a:	66 90                	xchg   %ax,%ax
  80278c:	31 c0                	xor    %eax,%eax
  80278e:	e9 37 ff ff ff       	jmp    8026ca <__udivdi3+0x46>
  802793:	90                   	nop

00802794 <__umoddi3>:
  802794:	55                   	push   %ebp
  802795:	57                   	push   %edi
  802796:	56                   	push   %esi
  802797:	53                   	push   %ebx
  802798:	83 ec 1c             	sub    $0x1c,%esp
  80279b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80279f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027a7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8027ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027b3:	89 f3                	mov    %esi,%ebx
  8027b5:	89 fa                	mov    %edi,%edx
  8027b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8027bb:	89 34 24             	mov    %esi,(%esp)
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	75 1a                	jne    8027dc <__umoddi3+0x48>
  8027c2:	39 f7                	cmp    %esi,%edi
  8027c4:	0f 86 a2 00 00 00    	jbe    80286c <__umoddi3+0xd8>
  8027ca:	89 c8                	mov    %ecx,%eax
  8027cc:	89 f2                	mov    %esi,%edx
  8027ce:	f7 f7                	div    %edi
  8027d0:	89 d0                	mov    %edx,%eax
  8027d2:	31 d2                	xor    %edx,%edx
  8027d4:	83 c4 1c             	add    $0x1c,%esp
  8027d7:	5b                   	pop    %ebx
  8027d8:	5e                   	pop    %esi
  8027d9:	5f                   	pop    %edi
  8027da:	5d                   	pop    %ebp
  8027db:	c3                   	ret    
  8027dc:	39 f0                	cmp    %esi,%eax
  8027de:	0f 87 ac 00 00 00    	ja     802890 <__umoddi3+0xfc>
  8027e4:	0f bd e8             	bsr    %eax,%ebp
  8027e7:	83 f5 1f             	xor    $0x1f,%ebp
  8027ea:	0f 84 ac 00 00 00    	je     80289c <__umoddi3+0x108>
  8027f0:	bf 20 00 00 00       	mov    $0x20,%edi
  8027f5:	29 ef                	sub    %ebp,%edi
  8027f7:	89 fe                	mov    %edi,%esi
  8027f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027fd:	89 e9                	mov    %ebp,%ecx
  8027ff:	d3 e0                	shl    %cl,%eax
  802801:	89 d7                	mov    %edx,%edi
  802803:	89 f1                	mov    %esi,%ecx
  802805:	d3 ef                	shr    %cl,%edi
  802807:	09 c7                	or     %eax,%edi
  802809:	89 e9                	mov    %ebp,%ecx
  80280b:	d3 e2                	shl    %cl,%edx
  80280d:	89 14 24             	mov    %edx,(%esp)
  802810:	89 d8                	mov    %ebx,%eax
  802812:	d3 e0                	shl    %cl,%eax
  802814:	89 c2                	mov    %eax,%edx
  802816:	8b 44 24 08          	mov    0x8(%esp),%eax
  80281a:	d3 e0                	shl    %cl,%eax
  80281c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802820:	8b 44 24 08          	mov    0x8(%esp),%eax
  802824:	89 f1                	mov    %esi,%ecx
  802826:	d3 e8                	shr    %cl,%eax
  802828:	09 d0                	or     %edx,%eax
  80282a:	d3 eb                	shr    %cl,%ebx
  80282c:	89 da                	mov    %ebx,%edx
  80282e:	f7 f7                	div    %edi
  802830:	89 d3                	mov    %edx,%ebx
  802832:	f7 24 24             	mull   (%esp)
  802835:	89 c6                	mov    %eax,%esi
  802837:	89 d1                	mov    %edx,%ecx
  802839:	39 d3                	cmp    %edx,%ebx
  80283b:	0f 82 87 00 00 00    	jb     8028c8 <__umoddi3+0x134>
  802841:	0f 84 91 00 00 00    	je     8028d8 <__umoddi3+0x144>
  802847:	8b 54 24 04          	mov    0x4(%esp),%edx
  80284b:	29 f2                	sub    %esi,%edx
  80284d:	19 cb                	sbb    %ecx,%ebx
  80284f:	89 d8                	mov    %ebx,%eax
  802851:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802855:	d3 e0                	shl    %cl,%eax
  802857:	89 e9                	mov    %ebp,%ecx
  802859:	d3 ea                	shr    %cl,%edx
  80285b:	09 d0                	or     %edx,%eax
  80285d:	89 e9                	mov    %ebp,%ecx
  80285f:	d3 eb                	shr    %cl,%ebx
  802861:	89 da                	mov    %ebx,%edx
  802863:	83 c4 1c             	add    $0x1c,%esp
  802866:	5b                   	pop    %ebx
  802867:	5e                   	pop    %esi
  802868:	5f                   	pop    %edi
  802869:	5d                   	pop    %ebp
  80286a:	c3                   	ret    
  80286b:	90                   	nop
  80286c:	89 fd                	mov    %edi,%ebp
  80286e:	85 ff                	test   %edi,%edi
  802870:	75 0b                	jne    80287d <__umoddi3+0xe9>
  802872:	b8 01 00 00 00       	mov    $0x1,%eax
  802877:	31 d2                	xor    %edx,%edx
  802879:	f7 f7                	div    %edi
  80287b:	89 c5                	mov    %eax,%ebp
  80287d:	89 f0                	mov    %esi,%eax
  80287f:	31 d2                	xor    %edx,%edx
  802881:	f7 f5                	div    %ebp
  802883:	89 c8                	mov    %ecx,%eax
  802885:	f7 f5                	div    %ebp
  802887:	89 d0                	mov    %edx,%eax
  802889:	e9 44 ff ff ff       	jmp    8027d2 <__umoddi3+0x3e>
  80288e:	66 90                	xchg   %ax,%ax
  802890:	89 c8                	mov    %ecx,%eax
  802892:	89 f2                	mov    %esi,%edx
  802894:	83 c4 1c             	add    $0x1c,%esp
  802897:	5b                   	pop    %ebx
  802898:	5e                   	pop    %esi
  802899:	5f                   	pop    %edi
  80289a:	5d                   	pop    %ebp
  80289b:	c3                   	ret    
  80289c:	3b 04 24             	cmp    (%esp),%eax
  80289f:	72 06                	jb     8028a7 <__umoddi3+0x113>
  8028a1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8028a5:	77 0f                	ja     8028b6 <__umoddi3+0x122>
  8028a7:	89 f2                	mov    %esi,%edx
  8028a9:	29 f9                	sub    %edi,%ecx
  8028ab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8028af:	89 14 24             	mov    %edx,(%esp)
  8028b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028b6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8028ba:	8b 14 24             	mov    (%esp),%edx
  8028bd:	83 c4 1c             	add    $0x1c,%esp
  8028c0:	5b                   	pop    %ebx
  8028c1:	5e                   	pop    %esi
  8028c2:	5f                   	pop    %edi
  8028c3:	5d                   	pop    %ebp
  8028c4:	c3                   	ret    
  8028c5:	8d 76 00             	lea    0x0(%esi),%esi
  8028c8:	2b 04 24             	sub    (%esp),%eax
  8028cb:	19 fa                	sbb    %edi,%edx
  8028cd:	89 d1                	mov    %edx,%ecx
  8028cf:	89 c6                	mov    %eax,%esi
  8028d1:	e9 71 ff ff ff       	jmp    802847 <__umoddi3+0xb3>
  8028d6:	66 90                	xchg   %ax,%ax
  8028d8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8028dc:	72 ea                	jb     8028c8 <__umoddi3+0x134>
  8028de:	89 d9                	mov    %ebx,%ecx
  8028e0:	e9 62 ff ff ff       	jmp    802847 <__umoddi3+0xb3>
