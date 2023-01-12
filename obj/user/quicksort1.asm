
obj/user/quicksort1:     file format elf32-i386


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
  800031:	e8 eb 05 00 00       	call   800621 <libmain>
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
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 21 21 00 00       	call   80216f <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 33 21 00 00       	call   802188 <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_disable_interrupt();
  80005d:	e8 dd 21 00 00       	call   80223f <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  800062:	83 ec 08             	sub    $0x8,%esp
  800065:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  80006b:	50                   	push   %eax
  80006c:	68 e0 28 80 00       	push   $0x8028e0
  800071:	e8 14 10 00 00       	call   80108a <readline>
  800076:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	6a 0a                	push   $0xa
  80007e:	6a 00                	push   $0x0
  800080:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800086:	50                   	push   %eax
  800087:	e8 64 15 00 00       	call   8015f0 <strtol>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800095:	c1 e0 02             	shl    $0x2,%eax
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	50                   	push   %eax
  80009c:	e8 f7 18 00 00       	call   801998 <malloc>
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Elements[NumOfElements] = 10 ;
  8000a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000b4:	01 d0                	add    %edx,%eax
  8000b6:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 00 29 80 00       	push   $0x802900
  8000c4:	e8 3f 09 00 00       	call   800a08 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	68 23 29 80 00       	push   $0x802923
  8000d4:	e8 2f 09 00 00       	call   800a08 <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 31 29 80 00       	push   $0x802931
  8000e4:	e8 1f 09 00 00       	call   800a08 <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 40 29 80 00       	push   $0x802940
  8000f4:	e8 0f 09 00 00       	call   800a08 <cprintf>
  8000f9:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 50 29 80 00       	push   $0x802950
  800104:	e8 ff 08 00 00       	call   800a08 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80010c:	e8 b8 04 00 00       	call   8005c9 <getchar>
  800111:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  800114:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	50                   	push   %eax
  80011c:	e8 60 04 00 00       	call   800581 <cputchar>
  800121:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	6a 0a                	push   $0xa
  800129:	e8 53 04 00 00       	call   800581 <cputchar>
  80012e:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800131:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  800135:	74 0c                	je     800143 <_main+0x10b>
  800137:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  80013b:	74 06                	je     800143 <_main+0x10b>
  80013d:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  800141:	75 b9                	jne    8000fc <_main+0xc4>

	sys_enable_interrupt();
  800143:	e8 11 21 00 00       	call   802259 <sys_enable_interrupt>
		int  i ;
		switch (Chose)
  800148:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80014c:	83 f8 62             	cmp    $0x62,%eax
  80014f:	74 1d                	je     80016e <_main+0x136>
  800151:	83 f8 63             	cmp    $0x63,%eax
  800154:	74 2b                	je     800181 <_main+0x149>
  800156:	83 f8 61             	cmp    $0x61,%eax
  800159:	75 39                	jne    800194 <_main+0x15c>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 ec             	pushl  -0x14(%ebp)
  800161:	ff 75 e8             	pushl  -0x18(%ebp)
  800164:	e8 e0 02 00 00       	call   800449 <InitializeAscending>
  800169:	83 c4 10             	add    $0x10,%esp
			break ;
  80016c:	eb 37                	jmp    8001a5 <_main+0x16d>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	ff 75 ec             	pushl  -0x14(%ebp)
  800174:	ff 75 e8             	pushl  -0x18(%ebp)
  800177:	e8 fe 02 00 00       	call   80047a <InitializeDescending>
  80017c:	83 c4 10             	add    $0x10,%esp
			break ;
  80017f:	eb 24                	jmp    8001a5 <_main+0x16d>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	ff 75 ec             	pushl  -0x14(%ebp)
  800187:	ff 75 e8             	pushl  -0x18(%ebp)
  80018a:	e8 20 03 00 00       	call   8004af <InitializeSemiRandom>
  80018f:	83 c4 10             	add    $0x10,%esp
			break ;
  800192:	eb 11                	jmp    8001a5 <_main+0x16d>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800194:	83 ec 08             	sub    $0x8,%esp
  800197:	ff 75 ec             	pushl  -0x14(%ebp)
  80019a:	ff 75 e8             	pushl  -0x18(%ebp)
  80019d:	e8 0d 03 00 00       	call   8004af <InitializeSemiRandom>
  8001a2:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001a5:	83 ec 08             	sub    $0x8,%esp
  8001a8:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ae:	e8 db 00 00 00       	call   80028e <QuickSort>
  8001b3:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bf:	e8 db 01 00 00       	call   80039f <CheckSorted>
  8001c4:	83 c4 10             	add    $0x10,%esp
  8001c7:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001ce:	75 14                	jne    8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 5c 29 80 00       	push   $0x80295c
  8001d8:	6a 47                	push   $0x47
  8001da:	68 7e 29 80 00       	push   $0x80297e
  8001df:	e8 82 05 00 00       	call   800766 <_panic>
		else
		{ 
			cprintf("\n===============================================\n") ;
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 90 29 80 00       	push   $0x802990
  8001ec:	e8 17 08 00 00       	call   800a08 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 c4 29 80 00       	push   $0x8029c4
  8001fc:	e8 07 08 00 00       	call   800a08 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800204:	83 ec 0c             	sub    $0xc,%esp
  800207:	68 f8 29 80 00       	push   $0x8029f8
  80020c:	e8 f7 07 00 00       	call   800a08 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800214:	83 ec 0c             	sub    $0xc,%esp
  800217:	68 2a 2a 80 00       	push   $0x802a2a
  80021c:	e8 e7 07 00 00       	call   800a08 <cprintf>
  800221:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	ff 75 e8             	pushl  -0x18(%ebp)
  80022a:	e8 24 1c 00 00       	call   801e53 <free>
  80022f:	83 c4 10             	add    $0x10,%esp

		///========================================================================
	sys_disable_interrupt();
  800232:	e8 08 20 00 00       	call   80223f <sys_disable_interrupt>
		cprintf("Do you want to repeat (y/n): ") ;
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 40 2a 80 00       	push   $0x802a40
  80023f:	e8 c4 07 00 00       	call   800a08 <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp

		Chose = getchar() ;
  800247:	e8 7d 03 00 00       	call   8005c9 <getchar>
  80024c:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80024f:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	50                   	push   %eax
  800257:	e8 25 03 00 00       	call   800581 <cputchar>
  80025c:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	6a 0a                	push   $0xa
  800264:	e8 18 03 00 00       	call   800581 <cputchar>
  800269:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	6a 0a                	push   $0xa
  800271:	e8 0b 03 00 00       	call   800581 <cputchar>
  800276:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800279:	e8 db 1f 00 00       	call   802259 <sys_enable_interrupt>

	} while (Chose == 'y');
  80027e:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  800282:	0f 84 c1 fd ff ff    	je     800049 <_main+0x11>

}
  800288:	90                   	nop
  800289:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    

0080028e <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	48                   	dec    %eax
  800298:	50                   	push   %eax
  800299:	6a 00                	push   $0x0
  80029b:	ff 75 0c             	pushl  0xc(%ebp)
  80029e:	ff 75 08             	pushl  0x8(%ebp)
  8002a1:	e8 06 00 00 00       	call   8002ac <QSort>
  8002a6:	83 c4 10             	add    $0x10,%esp
}
  8002a9:	90                   	nop
  8002aa:	c9                   	leave  
  8002ab:	c3                   	ret    

008002ac <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b5:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002b8:	0f 8d de 00 00 00    	jge    80039c <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002be:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c1:	40                   	inc    %eax
  8002c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8002c8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002cb:	e9 80 00 00 00       	jmp    800350 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002d0:	ff 45 f4             	incl   -0xc(%ebp)
  8002d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002d6:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002d9:	7f 2b                	jg     800306 <QSort+0x5a>
  8002db:	8b 45 10             	mov    0x10(%ebp),%eax
  8002de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e8:	01 d0                	add    %edx,%eax
  8002ea:	8b 10                	mov    (%eax),%edx
  8002ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7d cf                	jge    8002d0 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800301:	eb 03                	jmp    800306 <QSort+0x5a>
  800303:	ff 4d f0             	decl   -0x10(%ebp)
  800306:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800309:	3b 45 10             	cmp    0x10(%ebp),%eax
  80030c:	7e 26                	jle    800334 <QSort+0x88>
  80030e:	8b 45 10             	mov    0x10(%ebp),%eax
  800311:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800318:	8b 45 08             	mov    0x8(%ebp),%eax
  80031b:	01 d0                	add    %edx,%eax
  80031d:	8b 10                	mov    (%eax),%edx
  80031f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800322:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	01 c8                	add    %ecx,%eax
  80032e:	8b 00                	mov    (%eax),%eax
  800330:	39 c2                	cmp    %eax,%edx
  800332:	7e cf                	jle    800303 <QSort+0x57>

		if (i <= j)
  800334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800337:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80033a:	7f 14                	jg     800350 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80033c:	83 ec 04             	sub    $0x4,%esp
  80033f:	ff 75 f0             	pushl  -0x10(%ebp)
  800342:	ff 75 f4             	pushl  -0xc(%ebp)
  800345:	ff 75 08             	pushl  0x8(%ebp)
  800348:	e8 a9 00 00 00       	call   8003f6 <Swap>
  80034d:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800353:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800356:	0f 8e 77 ff ff ff    	jle    8002d3 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80035c:	83 ec 04             	sub    $0x4,%esp
  80035f:	ff 75 f0             	pushl  -0x10(%ebp)
  800362:	ff 75 10             	pushl  0x10(%ebp)
  800365:	ff 75 08             	pushl  0x8(%ebp)
  800368:	e8 89 00 00 00       	call   8003f6 <Swap>
  80036d:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800373:	48                   	dec    %eax
  800374:	50                   	push   %eax
  800375:	ff 75 10             	pushl  0x10(%ebp)
  800378:	ff 75 0c             	pushl  0xc(%ebp)
  80037b:	ff 75 08             	pushl  0x8(%ebp)
  80037e:	e8 29 ff ff ff       	call   8002ac <QSort>
  800383:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800386:	ff 75 14             	pushl  0x14(%ebp)
  800389:	ff 75 f4             	pushl  -0xc(%ebp)
  80038c:	ff 75 0c             	pushl  0xc(%ebp)
  80038f:	ff 75 08             	pushl  0x8(%ebp)
  800392:	e8 15 ff ff ff       	call   8002ac <QSort>
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	eb 01                	jmp    80039d <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80039c:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003a5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003b3:	eb 33                	jmp    8003e8 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c2:	01 d0                	add    %edx,%eax
  8003c4:	8b 10                	mov    (%eax),%edx
  8003c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003c9:	40                   	inc    %eax
  8003ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	01 c8                	add    %ecx,%eax
  8003d6:	8b 00                	mov    (%eax),%eax
  8003d8:	39 c2                	cmp    %eax,%edx
  8003da:	7e 09                	jle    8003e5 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003e3:	eb 0c                	jmp    8003f1 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e5:	ff 45 f8             	incl   -0x8(%ebp)
  8003e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003eb:	48                   	dec    %eax
  8003ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003ef:	7f c4                	jg     8003b5 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003f4:	c9                   	leave  
  8003f5:	c3                   	ret    

008003f6 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003f6:	55                   	push   %ebp
  8003f7:	89 e5                	mov    %esp,%ebp
  8003f9:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	01 d0                	add    %edx,%eax
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800410:	8b 45 0c             	mov    0xc(%ebp),%eax
  800413:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	01 c2                	add    %eax,%edx
  80041f:	8b 45 10             	mov    0x10(%ebp),%eax
  800422:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 c8                	add    %ecx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800432:	8b 45 10             	mov    0x10(%ebp),%eax
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 08             	mov    0x8(%ebp),%eax
  80043f:	01 c2                	add    %eax,%edx
  800441:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800444:	89 02                	mov    %eax,(%edx)
}
  800446:	90                   	nop
  800447:	c9                   	leave  
  800448:	c3                   	ret    

00800449 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800449:	55                   	push   %ebp
  80044a:	89 e5                	mov    %esp,%ebp
  80044c:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80044f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800456:	eb 17                	jmp    80046f <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800458:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80045b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	01 c2                	add    %eax,%edx
  800467:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80046a:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80046c:	ff 45 fc             	incl   -0x4(%ebp)
  80046f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800472:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800475:	7c e1                	jl     800458 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800477:	90                   	nop
  800478:	c9                   	leave  
  800479:	c3                   	ret    

0080047a <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80047a:	55                   	push   %ebp
  80047b:	89 e5                	mov    %esp,%ebp
  80047d:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800480:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800487:	eb 1b                	jmp    8004a4 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800489:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800493:	8b 45 08             	mov    0x8(%ebp),%eax
  800496:	01 c2                	add    %eax,%edx
  800498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049b:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80049e:	48                   	dec    %eax
  80049f:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a1:	ff 45 fc             	incl   -0x4(%ebp)
  8004a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004aa:	7c dd                	jl     800489 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004ac:	90                   	nop
  8004ad:	c9                   	leave  
  8004ae:	c3                   	ret    

008004af <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004af:	55                   	push   %ebp
  8004b0:	89 e5                	mov    %esp,%ebp
  8004b2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004b8:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004bd:	f7 e9                	imul   %ecx
  8004bf:	c1 f9 1f             	sar    $0x1f,%ecx
  8004c2:	89 d0                	mov    %edx,%eax
  8004c4:	29 c8                	sub    %ecx,%eax
  8004c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004d0:	eb 1e                	jmp    8004f0 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e5:	99                   	cltd   
  8004e6:	f7 7d f8             	idivl  -0x8(%ebp)
  8004e9:	89 d0                	mov    %edx,%eax
  8004eb:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004ed:	ff 45 fc             	incl   -0x4(%ebp)
  8004f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f6:	7c da                	jl     8004d2 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004f8:	90                   	nop
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800501:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800508:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80050f:	eb 42                	jmp    800553 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800514:	99                   	cltd   
  800515:	f7 7d f0             	idivl  -0x10(%ebp)
  800518:	89 d0                	mov    %edx,%eax
  80051a:	85 c0                	test   %eax,%eax
  80051c:	75 10                	jne    80052e <PrintElements+0x33>
			cprintf("\n");
  80051e:	83 ec 0c             	sub    $0xc,%esp
  800521:	68 5e 2a 80 00       	push   $0x802a5e
  800526:	e8 dd 04 00 00       	call   800a08 <cprintf>
  80052b:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80052e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800531:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	01 d0                	add    %edx,%eax
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	83 ec 08             	sub    $0x8,%esp
  800542:	50                   	push   %eax
  800543:	68 60 2a 80 00       	push   $0x802a60
  800548:	e8 bb 04 00 00       	call   800a08 <cprintf>
  80054d:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800550:	ff 45 f4             	incl   -0xc(%ebp)
  800553:	8b 45 0c             	mov    0xc(%ebp),%eax
  800556:	48                   	dec    %eax
  800557:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80055a:	7f b5                	jg     800511 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80055c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80055f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	01 d0                	add    %edx,%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	50                   	push   %eax
  800571:	68 65 2a 80 00       	push   $0x802a65
  800576:	e8 8d 04 00 00       	call   800a08 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp

}
  80057e:	90                   	nop
  80057f:	c9                   	leave  
  800580:	c3                   	ret    

00800581 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800581:	55                   	push   %ebp
  800582:	89 e5                	mov    %esp,%ebp
  800584:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80058d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	50                   	push   %eax
  800595:	e8 d9 1c 00 00       	call   802273 <sys_cputc>
  80059a:	83 c4 10             	add    $0x10,%esp
}
  80059d:	90                   	nop
  80059e:	c9                   	leave  
  80059f:	c3                   	ret    

008005a0 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
  8005a3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005a6:	e8 94 1c 00 00       	call   80223f <sys_disable_interrupt>
	char c = ch;
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005b1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005b5:	83 ec 0c             	sub    $0xc,%esp
  8005b8:	50                   	push   %eax
  8005b9:	e8 b5 1c 00 00       	call   802273 <sys_cputc>
  8005be:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005c1:	e8 93 1c 00 00       	call   802259 <sys_enable_interrupt>
}
  8005c6:	90                   	nop
  8005c7:	c9                   	leave  
  8005c8:	c3                   	ret    

008005c9 <getchar>:

int
getchar(void)
{
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005d6:	eb 08                	jmp    8005e0 <getchar+0x17>
	{
		c = sys_cgetc();
  8005d8:	e8 7a 1a 00 00       	call   802057 <sys_cgetc>
  8005dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005e4:	74 f2                	je     8005d8 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005e9:	c9                   	leave  
  8005ea:	c3                   	ret    

008005eb <atomic_getchar>:

int
atomic_getchar(void)
{
  8005eb:	55                   	push   %ebp
  8005ec:	89 e5                	mov    %esp,%ebp
  8005ee:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005f1:	e8 49 1c 00 00       	call   80223f <sys_disable_interrupt>
	int c=0;
  8005f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005fd:	eb 08                	jmp    800607 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005ff:	e8 53 1a 00 00       	call   802057 <sys_cgetc>
  800604:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80060b:	74 f2                	je     8005ff <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  80060d:	e8 47 1c 00 00       	call   802259 <sys_enable_interrupt>
	return c;
  800612:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800615:	c9                   	leave  
  800616:	c3                   	ret    

00800617 <iscons>:

int iscons(int fdnum)
{
  800617:	55                   	push   %ebp
  800618:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80061a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80061f:	5d                   	pop    %ebp
  800620:	c3                   	ret    

00800621 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800621:	55                   	push   %ebp
  800622:	89 e5                	mov    %esp,%ebp
  800624:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800627:	e8 78 1a 00 00       	call   8020a4 <sys_getenvindex>
  80062c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80062f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800632:	89 d0                	mov    %edx,%eax
  800634:	c1 e0 03             	shl    $0x3,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800640:	01 c8                	add    %ecx,%eax
  800642:	01 c0                	add    %eax,%eax
  800644:	01 d0                	add    %edx,%eax
  800646:	01 c0                	add    %eax,%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	89 c2                	mov    %eax,%edx
  80064c:	c1 e2 05             	shl    $0x5,%edx
  80064f:	29 c2                	sub    %eax,%edx
  800651:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800658:	89 c2                	mov    %eax,%edx
  80065a:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800660:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800665:	a1 24 40 80 00       	mov    0x804024,%eax
  80066a:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800670:	84 c0                	test   %al,%al
  800672:	74 0f                	je     800683 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800674:	a1 24 40 80 00       	mov    0x804024,%eax
  800679:	05 40 3c 01 00       	add    $0x13c40,%eax
  80067e:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800683:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800687:	7e 0a                	jle    800693 <libmain+0x72>
		binaryname = argv[0];
  800689:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068c:	8b 00                	mov    (%eax),%eax
  80068e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	ff 75 0c             	pushl  0xc(%ebp)
  800699:	ff 75 08             	pushl  0x8(%ebp)
  80069c:	e8 97 f9 ff ff       	call   800038 <_main>
  8006a1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006a4:	e8 96 1b 00 00       	call   80223f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	68 84 2a 80 00       	push   $0x802a84
  8006b1:	e8 52 03 00 00       	call   800a08 <cprintf>
  8006b6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006b9:	a1 24 40 80 00       	mov    0x804024,%eax
  8006be:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8006c4:	a1 24 40 80 00       	mov    0x804024,%eax
  8006c9:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	52                   	push   %edx
  8006d3:	50                   	push   %eax
  8006d4:	68 ac 2a 80 00       	push   $0x802aac
  8006d9:	e8 2a 03 00 00       	call   800a08 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8006e1:	a1 24 40 80 00       	mov    0x804024,%eax
  8006e6:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8006ec:	a1 24 40 80 00       	mov    0x804024,%eax
  8006f1:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8006f7:	83 ec 04             	sub    $0x4,%esp
  8006fa:	52                   	push   %edx
  8006fb:	50                   	push   %eax
  8006fc:	68 d4 2a 80 00       	push   $0x802ad4
  800701:	e8 02 03 00 00       	call   800a08 <cprintf>
  800706:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800709:	a1 24 40 80 00       	mov    0x804024,%eax
  80070e:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	50                   	push   %eax
  800718:	68 15 2b 80 00       	push   $0x802b15
  80071d:	e8 e6 02 00 00       	call   800a08 <cprintf>
  800722:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	68 84 2a 80 00       	push   $0x802a84
  80072d:	e8 d6 02 00 00       	call   800a08 <cprintf>
  800732:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800735:	e8 1f 1b 00 00       	call   802259 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80073a:	e8 19 00 00 00       	call   800758 <exit>
}
  80073f:	90                   	nop
  800740:	c9                   	leave  
  800741:	c3                   	ret    

00800742 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800748:	83 ec 0c             	sub    $0xc,%esp
  80074b:	6a 00                	push   $0x0
  80074d:	e8 1e 19 00 00       	call   802070 <sys_env_destroy>
  800752:	83 c4 10             	add    $0x10,%esp
}
  800755:	90                   	nop
  800756:	c9                   	leave  
  800757:	c3                   	ret    

00800758 <exit>:

void
exit(void)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80075e:	e8 73 19 00 00       	call   8020d6 <sys_env_exit>
}
  800763:	90                   	nop
  800764:	c9                   	leave  
  800765:	c3                   	ret    

00800766 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800766:	55                   	push   %ebp
  800767:	89 e5                	mov    %esp,%ebp
  800769:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80076c:	8d 45 10             	lea    0x10(%ebp),%eax
  80076f:	83 c0 04             	add    $0x4,%eax
  800772:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800775:	a1 18 41 80 00       	mov    0x804118,%eax
  80077a:	85 c0                	test   %eax,%eax
  80077c:	74 16                	je     800794 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80077e:	a1 18 41 80 00       	mov    0x804118,%eax
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	50                   	push   %eax
  800787:	68 2c 2b 80 00       	push   $0x802b2c
  80078c:	e8 77 02 00 00       	call   800a08 <cprintf>
  800791:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800794:	a1 00 40 80 00       	mov    0x804000,%eax
  800799:	ff 75 0c             	pushl  0xc(%ebp)
  80079c:	ff 75 08             	pushl  0x8(%ebp)
  80079f:	50                   	push   %eax
  8007a0:	68 31 2b 80 00       	push   $0x802b31
  8007a5:	e8 5e 02 00 00       	call   800a08 <cprintf>
  8007aa:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b6:	50                   	push   %eax
  8007b7:	e8 e1 01 00 00       	call   80099d <vcprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	6a 00                	push   $0x0
  8007c4:	68 4d 2b 80 00       	push   $0x802b4d
  8007c9:	e8 cf 01 00 00       	call   80099d <vcprintf>
  8007ce:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007d1:	e8 82 ff ff ff       	call   800758 <exit>

	// should not return here
	while (1) ;
  8007d6:	eb fe                	jmp    8007d6 <_panic+0x70>

008007d8 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007de:	a1 24 40 80 00       	mov    0x804024,%eax
  8007e3:	8b 50 74             	mov    0x74(%eax),%edx
  8007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e9:	39 c2                	cmp    %eax,%edx
  8007eb:	74 14                	je     800801 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007ed:	83 ec 04             	sub    $0x4,%esp
  8007f0:	68 50 2b 80 00       	push   $0x802b50
  8007f5:	6a 26                	push   $0x26
  8007f7:	68 9c 2b 80 00       	push   $0x802b9c
  8007fc:	e8 65 ff ff ff       	call   800766 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800801:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800808:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80080f:	e9 b6 00 00 00       	jmp    8008ca <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800817:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	01 d0                	add    %edx,%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	85 c0                	test   %eax,%eax
  800827:	75 08                	jne    800831 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800829:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80082c:	e9 96 00 00 00       	jmp    8008c7 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800831:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800838:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80083f:	eb 5d                	jmp    80089e <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800841:	a1 24 40 80 00       	mov    0x804024,%eax
  800846:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80084c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80084f:	c1 e2 04             	shl    $0x4,%edx
  800852:	01 d0                	add    %edx,%eax
  800854:	8a 40 04             	mov    0x4(%eax),%al
  800857:	84 c0                	test   %al,%al
  800859:	75 40                	jne    80089b <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80085b:	a1 24 40 80 00       	mov    0x804024,%eax
  800860:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800866:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800869:	c1 e2 04             	shl    $0x4,%edx
  80086c:	01 d0                	add    %edx,%eax
  80086e:	8b 00                	mov    (%eax),%eax
  800870:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800873:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800876:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80087d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800880:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	01 c8                	add    %ecx,%eax
  80088c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088e:	39 c2                	cmp    %eax,%edx
  800890:	75 09                	jne    80089b <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800892:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800899:	eb 12                	jmp    8008ad <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089b:	ff 45 e8             	incl   -0x18(%ebp)
  80089e:	a1 24 40 80 00       	mov    0x804024,%eax
  8008a3:	8b 50 74             	mov    0x74(%eax),%edx
  8008a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a9:	39 c2                	cmp    %eax,%edx
  8008ab:	77 94                	ja     800841 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008b1:	75 14                	jne    8008c7 <CheckWSWithoutLastIndex+0xef>
			panic(
  8008b3:	83 ec 04             	sub    $0x4,%esp
  8008b6:	68 a8 2b 80 00       	push   $0x802ba8
  8008bb:	6a 3a                	push   $0x3a
  8008bd:	68 9c 2b 80 00       	push   $0x802b9c
  8008c2:	e8 9f fe ff ff       	call   800766 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008c7:	ff 45 f0             	incl   -0x10(%ebp)
  8008ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008d0:	0f 8c 3e ff ff ff    	jl     800814 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008e4:	eb 20                	jmp    800906 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008e6:	a1 24 40 80 00       	mov    0x804024,%eax
  8008eb:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8008f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f4:	c1 e2 04             	shl    $0x4,%edx
  8008f7:	01 d0                	add    %edx,%eax
  8008f9:	8a 40 04             	mov    0x4(%eax),%al
  8008fc:	3c 01                	cmp    $0x1,%al
  8008fe:	75 03                	jne    800903 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800900:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800903:	ff 45 e0             	incl   -0x20(%ebp)
  800906:	a1 24 40 80 00       	mov    0x804024,%eax
  80090b:	8b 50 74             	mov    0x74(%eax),%edx
  80090e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800911:	39 c2                	cmp    %eax,%edx
  800913:	77 d1                	ja     8008e6 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800918:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80091b:	74 14                	je     800931 <CheckWSWithoutLastIndex+0x159>
		panic(
  80091d:	83 ec 04             	sub    $0x4,%esp
  800920:	68 fc 2b 80 00       	push   $0x802bfc
  800925:	6a 44                	push   $0x44
  800927:	68 9c 2b 80 00       	push   $0x802b9c
  80092c:	e8 35 fe ff ff       	call   800766 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800931:	90                   	nop
  800932:	c9                   	leave  
  800933:	c3                   	ret    

00800934 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80093a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	8d 48 01             	lea    0x1(%eax),%ecx
  800942:	8b 55 0c             	mov    0xc(%ebp),%edx
  800945:	89 0a                	mov    %ecx,(%edx)
  800947:	8b 55 08             	mov    0x8(%ebp),%edx
  80094a:	88 d1                	mov    %dl,%cl
  80094c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800953:	8b 45 0c             	mov    0xc(%ebp),%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	3d ff 00 00 00       	cmp    $0xff,%eax
  80095d:	75 2c                	jne    80098b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80095f:	a0 28 40 80 00       	mov    0x804028,%al
  800964:	0f b6 c0             	movzbl %al,%eax
  800967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096a:	8b 12                	mov    (%edx),%edx
  80096c:	89 d1                	mov    %edx,%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	83 c2 08             	add    $0x8,%edx
  800974:	83 ec 04             	sub    $0x4,%esp
  800977:	50                   	push   %eax
  800978:	51                   	push   %ecx
  800979:	52                   	push   %edx
  80097a:	e8 af 16 00 00       	call   80202e <sys_cputs>
  80097f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800982:	8b 45 0c             	mov    0xc(%ebp),%eax
  800985:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80098b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098e:	8b 40 04             	mov    0x4(%eax),%eax
  800991:	8d 50 01             	lea    0x1(%eax),%edx
  800994:	8b 45 0c             	mov    0xc(%ebp),%eax
  800997:	89 50 04             	mov    %edx,0x4(%eax)
}
  80099a:	90                   	nop
  80099b:	c9                   	leave  
  80099c:	c3                   	ret    

0080099d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009a6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009ad:	00 00 00 
	b.cnt = 0;
  8009b0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009b7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009ba:	ff 75 0c             	pushl  0xc(%ebp)
  8009bd:	ff 75 08             	pushl  0x8(%ebp)
  8009c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009c6:	50                   	push   %eax
  8009c7:	68 34 09 80 00       	push   $0x800934
  8009cc:	e8 11 02 00 00       	call   800be2 <vprintfmt>
  8009d1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009d4:	a0 28 40 80 00       	mov    0x804028,%al
  8009d9:	0f b6 c0             	movzbl %al,%eax
  8009dc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009e2:	83 ec 04             	sub    $0x4,%esp
  8009e5:	50                   	push   %eax
  8009e6:	52                   	push   %edx
  8009e7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009ed:	83 c0 08             	add    $0x8,%eax
  8009f0:	50                   	push   %eax
  8009f1:	e8 38 16 00 00       	call   80202e <sys_cputs>
  8009f6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009f9:	c6 05 28 40 80 00 00 	movb   $0x0,0x804028
	return b.cnt;
  800a00:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a06:	c9                   	leave  
  800a07:	c3                   	ret    

00800a08 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a0e:	c6 05 28 40 80 00 01 	movb   $0x1,0x804028
	va_start(ap, fmt);
  800a15:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a18:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 f4             	pushl  -0xc(%ebp)
  800a24:	50                   	push   %eax
  800a25:	e8 73 ff ff ff       	call   80099d <vcprintf>
  800a2a:	83 c4 10             	add    $0x10,%esp
  800a2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a3b:	e8 ff 17 00 00       	call   80223f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a40:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a4f:	50                   	push   %eax
  800a50:	e8 48 ff ff ff       	call   80099d <vcprintf>
  800a55:	83 c4 10             	add    $0x10,%esp
  800a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a5b:	e8 f9 17 00 00       	call   802259 <sys_enable_interrupt>
	return cnt;
  800a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a63:	c9                   	leave  
  800a64:	c3                   	ret    

00800a65 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	53                   	push   %ebx
  800a69:	83 ec 14             	sub    $0x14,%esp
  800a6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a78:	8b 45 18             	mov    0x18(%ebp),%eax
  800a7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a80:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a83:	77 55                	ja     800ada <printnum+0x75>
  800a85:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a88:	72 05                	jb     800a8f <printnum+0x2a>
  800a8a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a8d:	77 4b                	ja     800ada <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a8f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a92:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a95:	8b 45 18             	mov    0x18(%ebp),%eax
  800a98:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9d:	52                   	push   %edx
  800a9e:	50                   	push   %eax
  800a9f:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa2:	ff 75 f0             	pushl  -0x10(%ebp)
  800aa5:	e8 b6 1b 00 00       	call   802660 <__udivdi3>
  800aaa:	83 c4 10             	add    $0x10,%esp
  800aad:	83 ec 04             	sub    $0x4,%esp
  800ab0:	ff 75 20             	pushl  0x20(%ebp)
  800ab3:	53                   	push   %ebx
  800ab4:	ff 75 18             	pushl  0x18(%ebp)
  800ab7:	52                   	push   %edx
  800ab8:	50                   	push   %eax
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	ff 75 08             	pushl  0x8(%ebp)
  800abf:	e8 a1 ff ff ff       	call   800a65 <printnum>
  800ac4:	83 c4 20             	add    $0x20,%esp
  800ac7:	eb 1a                	jmp    800ae3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ac9:	83 ec 08             	sub    $0x8,%esp
  800acc:	ff 75 0c             	pushl  0xc(%ebp)
  800acf:	ff 75 20             	pushl  0x20(%ebp)
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ada:	ff 4d 1c             	decl   0x1c(%ebp)
  800add:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ae1:	7f e6                	jg     800ac9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ae3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ae6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af1:	53                   	push   %ebx
  800af2:	51                   	push   %ecx
  800af3:	52                   	push   %edx
  800af4:	50                   	push   %eax
  800af5:	e8 76 1c 00 00       	call   802770 <__umoddi3>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	05 74 2e 80 00       	add    $0x802e74,%eax
  800b02:	8a 00                	mov    (%eax),%al
  800b04:	0f be c0             	movsbl %al,%eax
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 0c             	pushl  0xc(%ebp)
  800b0d:	50                   	push   %eax
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	ff d0                	call   *%eax
  800b13:	83 c4 10             	add    $0x10,%esp
}
  800b16:	90                   	nop
  800b17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b1f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b23:	7e 1c                	jle    800b41 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	8b 00                	mov    (%eax),%eax
  800b2a:	8d 50 08             	lea    0x8(%eax),%edx
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	89 10                	mov    %edx,(%eax)
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8b 00                	mov    (%eax),%eax
  800b37:	83 e8 08             	sub    $0x8,%eax
  800b3a:	8b 50 04             	mov    0x4(%eax),%edx
  800b3d:	8b 00                	mov    (%eax),%eax
  800b3f:	eb 40                	jmp    800b81 <getuint+0x65>
	else if (lflag)
  800b41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b45:	74 1e                	je     800b65 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	8b 00                	mov    (%eax),%eax
  800b4c:	8d 50 04             	lea    0x4(%eax),%edx
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	89 10                	mov    %edx,(%eax)
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	8b 00                	mov    (%eax),%eax
  800b59:	83 e8 04             	sub    $0x4,%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b63:	eb 1c                	jmp    800b81 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	8b 00                	mov    (%eax),%eax
  800b6a:	8d 50 04             	lea    0x4(%eax),%edx
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	89 10                	mov    %edx,(%eax)
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	8b 00                	mov    (%eax),%eax
  800b77:	83 e8 04             	sub    $0x4,%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b86:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8a:	7e 1c                	jle    800ba8 <getint+0x25>
		return va_arg(*ap, long long);
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8b 00                	mov    (%eax),%eax
  800b91:	8d 50 08             	lea    0x8(%eax),%edx
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	89 10                	mov    %edx,(%eax)
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 00                	mov    (%eax),%eax
  800b9e:	83 e8 08             	sub    $0x8,%eax
  800ba1:	8b 50 04             	mov    0x4(%eax),%edx
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	eb 38                	jmp    800be0 <getint+0x5d>
	else if (lflag)
  800ba8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bac:	74 1a                	je     800bc8 <getint+0x45>
		return va_arg(*ap, long);
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8b 00                	mov    (%eax),%eax
  800bb3:	8d 50 04             	lea    0x4(%eax),%edx
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	89 10                	mov    %edx,(%eax)
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	8b 00                	mov    (%eax),%eax
  800bc0:	83 e8 04             	sub    $0x4,%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	99                   	cltd   
  800bc6:	eb 18                	jmp    800be0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	8b 00                	mov    (%eax),%eax
  800bcd:	8d 50 04             	lea    0x4(%eax),%edx
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	89 10                	mov    %edx,(%eax)
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	8b 00                	mov    (%eax),%eax
  800bda:	83 e8 04             	sub    $0x4,%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	99                   	cltd   
}
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    

00800be2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	56                   	push   %esi
  800be6:	53                   	push   %ebx
  800be7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bea:	eb 17                	jmp    800c03 <vprintfmt+0x21>
			if (ch == '\0')
  800bec:	85 db                	test   %ebx,%ebx
  800bee:	0f 84 af 03 00 00    	je     800fa3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bf4:	83 ec 08             	sub    $0x8,%esp
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	53                   	push   %ebx
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	ff d0                	call   *%eax
  800c00:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c03:	8b 45 10             	mov    0x10(%ebp),%eax
  800c06:	8d 50 01             	lea    0x1(%eax),%edx
  800c09:	89 55 10             	mov    %edx,0x10(%ebp)
  800c0c:	8a 00                	mov    (%eax),%al
  800c0e:	0f b6 d8             	movzbl %al,%ebx
  800c11:	83 fb 25             	cmp    $0x25,%ebx
  800c14:	75 d6                	jne    800bec <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c16:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c1a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c21:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c2f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c36:	8b 45 10             	mov    0x10(%ebp),%eax
  800c39:	8d 50 01             	lea    0x1(%eax),%edx
  800c3c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	0f b6 d8             	movzbl %al,%ebx
  800c44:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c47:	83 f8 55             	cmp    $0x55,%eax
  800c4a:	0f 87 2b 03 00 00    	ja     800f7b <vprintfmt+0x399>
  800c50:	8b 04 85 98 2e 80 00 	mov    0x802e98(,%eax,4),%eax
  800c57:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c59:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c5d:	eb d7                	jmp    800c36 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c5f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c63:	eb d1                	jmp    800c36 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c6c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c6f:	89 d0                	mov    %edx,%eax
  800c71:	c1 e0 02             	shl    $0x2,%eax
  800c74:	01 d0                	add    %edx,%eax
  800c76:	01 c0                	add    %eax,%eax
  800c78:	01 d8                	add    %ebx,%eax
  800c7a:	83 e8 30             	sub    $0x30,%eax
  800c7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c80:	8b 45 10             	mov    0x10(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c88:	83 fb 2f             	cmp    $0x2f,%ebx
  800c8b:	7e 3e                	jle    800ccb <vprintfmt+0xe9>
  800c8d:	83 fb 39             	cmp    $0x39,%ebx
  800c90:	7f 39                	jg     800ccb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c92:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c95:	eb d5                	jmp    800c6c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c97:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9a:	83 c0 04             	add    $0x4,%eax
  800c9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 e8 04             	sub    $0x4,%eax
  800ca6:	8b 00                	mov    (%eax),%eax
  800ca8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cab:	eb 1f                	jmp    800ccc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cb1:	79 83                	jns    800c36 <vprintfmt+0x54>
				width = 0;
  800cb3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cba:	e9 77 ff ff ff       	jmp    800c36 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cbf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cc6:	e9 6b ff ff ff       	jmp    800c36 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ccb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ccc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd0:	0f 89 60 ff ff ff    	jns    800c36 <vprintfmt+0x54>
				width = precision, precision = -1;
  800cd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cdc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ce3:	e9 4e ff ff ff       	jmp    800c36 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ce8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ceb:	e9 46 ff ff ff       	jmp    800c36 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf3:	83 c0 04             	add    $0x4,%eax
  800cf6:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfc:	83 e8 04             	sub    $0x4,%eax
  800cff:	8b 00                	mov    (%eax),%eax
  800d01:	83 ec 08             	sub    $0x8,%esp
  800d04:	ff 75 0c             	pushl  0xc(%ebp)
  800d07:	50                   	push   %eax
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	ff d0                	call   *%eax
  800d0d:	83 c4 10             	add    $0x10,%esp
			break;
  800d10:	e9 89 02 00 00       	jmp    800f9e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d15:	8b 45 14             	mov    0x14(%ebp),%eax
  800d18:	83 c0 04             	add    $0x4,%eax
  800d1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d21:	83 e8 04             	sub    $0x4,%eax
  800d24:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d26:	85 db                	test   %ebx,%ebx
  800d28:	79 02                	jns    800d2c <vprintfmt+0x14a>
				err = -err;
  800d2a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d2c:	83 fb 64             	cmp    $0x64,%ebx
  800d2f:	7f 0b                	jg     800d3c <vprintfmt+0x15a>
  800d31:	8b 34 9d e0 2c 80 00 	mov    0x802ce0(,%ebx,4),%esi
  800d38:	85 f6                	test   %esi,%esi
  800d3a:	75 19                	jne    800d55 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d3c:	53                   	push   %ebx
  800d3d:	68 85 2e 80 00       	push   $0x802e85
  800d42:	ff 75 0c             	pushl  0xc(%ebp)
  800d45:	ff 75 08             	pushl  0x8(%ebp)
  800d48:	e8 5e 02 00 00       	call   800fab <printfmt>
  800d4d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d50:	e9 49 02 00 00       	jmp    800f9e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d55:	56                   	push   %esi
  800d56:	68 8e 2e 80 00       	push   $0x802e8e
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	e8 45 02 00 00       	call   800fab <printfmt>
  800d66:	83 c4 10             	add    $0x10,%esp
			break;
  800d69:	e9 30 02 00 00       	jmp    800f9e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d71:	83 c0 04             	add    $0x4,%eax
  800d74:	89 45 14             	mov    %eax,0x14(%ebp)
  800d77:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7a:	83 e8 04             	sub    $0x4,%eax
  800d7d:	8b 30                	mov    (%eax),%esi
  800d7f:	85 f6                	test   %esi,%esi
  800d81:	75 05                	jne    800d88 <vprintfmt+0x1a6>
				p = "(null)";
  800d83:	be 91 2e 80 00       	mov    $0x802e91,%esi
			if (width > 0 && padc != '-')
  800d88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8c:	7e 6d                	jle    800dfb <vprintfmt+0x219>
  800d8e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d92:	74 67                	je     800dfb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	50                   	push   %eax
  800d9b:	56                   	push   %esi
  800d9c:	e8 12 05 00 00       	call   8012b3 <strnlen>
  800da1:	83 c4 10             	add    $0x10,%esp
  800da4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800da7:	eb 16                	jmp    800dbf <vprintfmt+0x1dd>
					putch(padc, putdat);
  800da9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dad:	83 ec 08             	sub    $0x8,%esp
  800db0:	ff 75 0c             	pushl  0xc(%ebp)
  800db3:	50                   	push   %eax
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	ff d0                	call   *%eax
  800db9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dbc:	ff 4d e4             	decl   -0x1c(%ebp)
  800dbf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc3:	7f e4                	jg     800da9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc5:	eb 34                	jmp    800dfb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dc7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dcb:	74 1c                	je     800de9 <vprintfmt+0x207>
  800dcd:	83 fb 1f             	cmp    $0x1f,%ebx
  800dd0:	7e 05                	jle    800dd7 <vprintfmt+0x1f5>
  800dd2:	83 fb 7e             	cmp    $0x7e,%ebx
  800dd5:	7e 12                	jle    800de9 <vprintfmt+0x207>
					putch('?', putdat);
  800dd7:	83 ec 08             	sub    $0x8,%esp
  800dda:	ff 75 0c             	pushl  0xc(%ebp)
  800ddd:	6a 3f                	push   $0x3f
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	ff d0                	call   *%eax
  800de4:	83 c4 10             	add    $0x10,%esp
  800de7:	eb 0f                	jmp    800df8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800de9:	83 ec 08             	sub    $0x8,%esp
  800dec:	ff 75 0c             	pushl  0xc(%ebp)
  800def:	53                   	push   %ebx
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	ff d0                	call   *%eax
  800df5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df8:	ff 4d e4             	decl   -0x1c(%ebp)
  800dfb:	89 f0                	mov    %esi,%eax
  800dfd:	8d 70 01             	lea    0x1(%eax),%esi
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	0f be d8             	movsbl %al,%ebx
  800e05:	85 db                	test   %ebx,%ebx
  800e07:	74 24                	je     800e2d <vprintfmt+0x24b>
  800e09:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e0d:	78 b8                	js     800dc7 <vprintfmt+0x1e5>
  800e0f:	ff 4d e0             	decl   -0x20(%ebp)
  800e12:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e16:	79 af                	jns    800dc7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e18:	eb 13                	jmp    800e2d <vprintfmt+0x24b>
				putch(' ', putdat);
  800e1a:	83 ec 08             	sub    $0x8,%esp
  800e1d:	ff 75 0c             	pushl  0xc(%ebp)
  800e20:	6a 20                	push   $0x20
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	ff d0                	call   *%eax
  800e27:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e2a:	ff 4d e4             	decl   -0x1c(%ebp)
  800e2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e31:	7f e7                	jg     800e1a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e33:	e9 66 01 00 00       	jmp    800f9e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 e8             	pushl  -0x18(%ebp)
  800e3e:	8d 45 14             	lea    0x14(%ebp),%eax
  800e41:	50                   	push   %eax
  800e42:	e8 3c fd ff ff       	call   800b83 <getint>
  800e47:	83 c4 10             	add    $0x10,%esp
  800e4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e56:	85 d2                	test   %edx,%edx
  800e58:	79 23                	jns    800e7d <vprintfmt+0x29b>
				putch('-', putdat);
  800e5a:	83 ec 08             	sub    $0x8,%esp
  800e5d:	ff 75 0c             	pushl  0xc(%ebp)
  800e60:	6a 2d                	push   $0x2d
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	ff d0                	call   *%eax
  800e67:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e70:	f7 d8                	neg    %eax
  800e72:	83 d2 00             	adc    $0x0,%edx
  800e75:	f7 da                	neg    %edx
  800e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e7d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e84:	e9 bc 00 00 00       	jmp    800f45 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8f:	8d 45 14             	lea    0x14(%ebp),%eax
  800e92:	50                   	push   %eax
  800e93:	e8 84 fc ff ff       	call   800b1c <getuint>
  800e98:	83 c4 10             	add    $0x10,%esp
  800e9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ea1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ea8:	e9 98 00 00 00       	jmp    800f45 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ead:	83 ec 08             	sub    $0x8,%esp
  800eb0:	ff 75 0c             	pushl  0xc(%ebp)
  800eb3:	6a 58                	push   $0x58
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	ff d0                	call   *%eax
  800eba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ebd:	83 ec 08             	sub    $0x8,%esp
  800ec0:	ff 75 0c             	pushl  0xc(%ebp)
  800ec3:	6a 58                	push   $0x58
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	ff d0                	call   *%eax
  800eca:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ecd:	83 ec 08             	sub    $0x8,%esp
  800ed0:	ff 75 0c             	pushl  0xc(%ebp)
  800ed3:	6a 58                	push   $0x58
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	ff d0                	call   *%eax
  800eda:	83 c4 10             	add    $0x10,%esp
			break;
  800edd:	e9 bc 00 00 00       	jmp    800f9e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ee2:	83 ec 08             	sub    $0x8,%esp
  800ee5:	ff 75 0c             	pushl  0xc(%ebp)
  800ee8:	6a 30                	push   $0x30
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	ff d0                	call   *%eax
  800eef:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ef2:	83 ec 08             	sub    $0x8,%esp
  800ef5:	ff 75 0c             	pushl  0xc(%ebp)
  800ef8:	6a 78                	push   $0x78
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	ff d0                	call   *%eax
  800eff:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f02:	8b 45 14             	mov    0x14(%ebp),%eax
  800f05:	83 c0 04             	add    $0x4,%eax
  800f08:	89 45 14             	mov    %eax,0x14(%ebp)
  800f0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0e:	83 e8 04             	sub    $0x4,%eax
  800f11:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f1d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f24:	eb 1f                	jmp    800f45 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f26:	83 ec 08             	sub    $0x8,%esp
  800f29:	ff 75 e8             	pushl  -0x18(%ebp)
  800f2c:	8d 45 14             	lea    0x14(%ebp),%eax
  800f2f:	50                   	push   %eax
  800f30:	e8 e7 fb ff ff       	call   800b1c <getuint>
  800f35:	83 c4 10             	add    $0x10,%esp
  800f38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f3e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f45:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	52                   	push   %edx
  800f50:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f53:	50                   	push   %eax
  800f54:	ff 75 f4             	pushl  -0xc(%ebp)
  800f57:	ff 75 f0             	pushl  -0x10(%ebp)
  800f5a:	ff 75 0c             	pushl  0xc(%ebp)
  800f5d:	ff 75 08             	pushl  0x8(%ebp)
  800f60:	e8 00 fb ff ff       	call   800a65 <printnum>
  800f65:	83 c4 20             	add    $0x20,%esp
			break;
  800f68:	eb 34                	jmp    800f9e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f6a:	83 ec 08             	sub    $0x8,%esp
  800f6d:	ff 75 0c             	pushl  0xc(%ebp)
  800f70:	53                   	push   %ebx
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	ff d0                	call   *%eax
  800f76:	83 c4 10             	add    $0x10,%esp
			break;
  800f79:	eb 23                	jmp    800f9e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f7b:	83 ec 08             	sub    $0x8,%esp
  800f7e:	ff 75 0c             	pushl  0xc(%ebp)
  800f81:	6a 25                	push   $0x25
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	ff d0                	call   *%eax
  800f88:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f8b:	ff 4d 10             	decl   0x10(%ebp)
  800f8e:	eb 03                	jmp    800f93 <vprintfmt+0x3b1>
  800f90:	ff 4d 10             	decl   0x10(%ebp)
  800f93:	8b 45 10             	mov    0x10(%ebp),%eax
  800f96:	48                   	dec    %eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	3c 25                	cmp    $0x25,%al
  800f9b:	75 f3                	jne    800f90 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f9d:	90                   	nop
		}
	}
  800f9e:	e9 47 fc ff ff       	jmp    800bea <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fa3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fa4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fa7:	5b                   	pop    %ebx
  800fa8:	5e                   	pop    %esi
  800fa9:	5d                   	pop    %ebp
  800faa:	c3                   	ret    

00800fab <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fb1:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb4:	83 c0 04             	add    $0x4,%eax
  800fb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fba:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc0:	50                   	push   %eax
  800fc1:	ff 75 0c             	pushl  0xc(%ebp)
  800fc4:	ff 75 08             	pushl  0x8(%ebp)
  800fc7:	e8 16 fc ff ff       	call   800be2 <vprintfmt>
  800fcc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fcf:	90                   	nop
  800fd0:	c9                   	leave  
  800fd1:	c3                   	ret    

00800fd2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd8:	8b 40 08             	mov    0x8(%eax),%eax
  800fdb:	8d 50 01             	lea    0x1(%eax),%edx
  800fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe7:	8b 10                	mov    (%eax),%edx
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	8b 40 04             	mov    0x4(%eax),%eax
  800fef:	39 c2                	cmp    %eax,%edx
  800ff1:	73 12                	jae    801005 <sprintputch+0x33>
		*b->buf++ = ch;
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	8b 00                	mov    (%eax),%eax
  800ff8:	8d 48 01             	lea    0x1(%eax),%ecx
  800ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffe:	89 0a                	mov    %ecx,(%edx)
  801000:	8b 55 08             	mov    0x8(%ebp),%edx
  801003:	88 10                	mov    %dl,(%eax)
}
  801005:	90                   	nop
  801006:	5d                   	pop    %ebp
  801007:	c3                   	ret    

00801008 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	01 d0                	add    %edx,%eax
  80101f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801022:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801029:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80102d:	74 06                	je     801035 <vsnprintf+0x2d>
  80102f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801033:	7f 07                	jg     80103c <vsnprintf+0x34>
		return -E_INVAL;
  801035:	b8 03 00 00 00       	mov    $0x3,%eax
  80103a:	eb 20                	jmp    80105c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80103c:	ff 75 14             	pushl  0x14(%ebp)
  80103f:	ff 75 10             	pushl  0x10(%ebp)
  801042:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801045:	50                   	push   %eax
  801046:	68 d2 0f 80 00       	push   $0x800fd2
  80104b:	e8 92 fb ff ff       	call   800be2 <vprintfmt>
  801050:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801053:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801056:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801059:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801064:	8d 45 10             	lea    0x10(%ebp),%eax
  801067:	83 c0 04             	add    $0x4,%eax
  80106a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80106d:	8b 45 10             	mov    0x10(%ebp),%eax
  801070:	ff 75 f4             	pushl  -0xc(%ebp)
  801073:	50                   	push   %eax
  801074:	ff 75 0c             	pushl  0xc(%ebp)
  801077:	ff 75 08             	pushl  0x8(%ebp)
  80107a:	e8 89 ff ff ff       	call   801008 <vsnprintf>
  80107f:	83 c4 10             	add    $0x10,%esp
  801082:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801085:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801090:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801094:	74 13                	je     8010a9 <readline+0x1f>
		cprintf("%s", prompt);
  801096:	83 ec 08             	sub    $0x8,%esp
  801099:	ff 75 08             	pushl  0x8(%ebp)
  80109c:	68 f0 2f 80 00       	push   $0x802ff0
  8010a1:	e8 62 f9 ff ff       	call   800a08 <cprintf>
  8010a6:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	6a 00                	push   $0x0
  8010b5:	e8 5d f5 ff ff       	call   800617 <iscons>
  8010ba:	83 c4 10             	add    $0x10,%esp
  8010bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010c0:	e8 04 f5 ff ff       	call   8005c9 <getchar>
  8010c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010cc:	79 22                	jns    8010f0 <readline+0x66>
			if (c != -E_EOF)
  8010ce:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010d2:	0f 84 ad 00 00 00    	je     801185 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010d8:	83 ec 08             	sub    $0x8,%esp
  8010db:	ff 75 ec             	pushl  -0x14(%ebp)
  8010de:	68 f3 2f 80 00       	push   $0x802ff3
  8010e3:	e8 20 f9 ff ff       	call   800a08 <cprintf>
  8010e8:	83 c4 10             	add    $0x10,%esp
			return;
  8010eb:	e9 95 00 00 00       	jmp    801185 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010f0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010f4:	7e 34                	jle    80112a <readline+0xa0>
  8010f6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8010fd:	7f 2b                	jg     80112a <readline+0xa0>
			if (echoing)
  8010ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801103:	74 0e                	je     801113 <readline+0x89>
				cputchar(c);
  801105:	83 ec 0c             	sub    $0xc,%esp
  801108:	ff 75 ec             	pushl  -0x14(%ebp)
  80110b:	e8 71 f4 ff ff       	call   800581 <cputchar>
  801110:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801116:	8d 50 01             	lea    0x1(%eax),%edx
  801119:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80111c:	89 c2                	mov    %eax,%edx
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	01 d0                	add    %edx,%eax
  801123:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801126:	88 10                	mov    %dl,(%eax)
  801128:	eb 56                	jmp    801180 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80112a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80112e:	75 1f                	jne    80114f <readline+0xc5>
  801130:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801134:	7e 19                	jle    80114f <readline+0xc5>
			if (echoing)
  801136:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80113a:	74 0e                	je     80114a <readline+0xc0>
				cputchar(c);
  80113c:	83 ec 0c             	sub    $0xc,%esp
  80113f:	ff 75 ec             	pushl  -0x14(%ebp)
  801142:	e8 3a f4 ff ff       	call   800581 <cputchar>
  801147:	83 c4 10             	add    $0x10,%esp

			i--;
  80114a:	ff 4d f4             	decl   -0xc(%ebp)
  80114d:	eb 31                	jmp    801180 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80114f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801153:	74 0a                	je     80115f <readline+0xd5>
  801155:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801159:	0f 85 61 ff ff ff    	jne    8010c0 <readline+0x36>
			if (echoing)
  80115f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801163:	74 0e                	je     801173 <readline+0xe9>
				cputchar(c);
  801165:	83 ec 0c             	sub    $0xc,%esp
  801168:	ff 75 ec             	pushl  -0x14(%ebp)
  80116b:	e8 11 f4 ff ff       	call   800581 <cputchar>
  801170:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801173:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	01 d0                	add    %edx,%eax
  80117b:	c6 00 00             	movb   $0x0,(%eax)
			return;
  80117e:	eb 06                	jmp    801186 <readline+0xfc>
		}
	}
  801180:	e9 3b ff ff ff       	jmp    8010c0 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801185:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80118e:	e8 ac 10 00 00       	call   80223f <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801197:	74 13                	je     8011ac <atomic_readline+0x24>
		cprintf("%s", prompt);
  801199:	83 ec 08             	sub    $0x8,%esp
  80119c:	ff 75 08             	pushl  0x8(%ebp)
  80119f:	68 f0 2f 80 00       	push   $0x802ff0
  8011a4:	e8 5f f8 ff ff       	call   800a08 <cprintf>
  8011a9:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011b3:	83 ec 0c             	sub    $0xc,%esp
  8011b6:	6a 00                	push   $0x0
  8011b8:	e8 5a f4 ff ff       	call   800617 <iscons>
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011c3:	e8 01 f4 ff ff       	call   8005c9 <getchar>
  8011c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011cf:	79 23                	jns    8011f4 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011d1:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011d5:	74 13                	je     8011ea <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011d7:	83 ec 08             	sub    $0x8,%esp
  8011da:	ff 75 ec             	pushl  -0x14(%ebp)
  8011dd:	68 f3 2f 80 00       	push   $0x802ff3
  8011e2:	e8 21 f8 ff ff       	call   800a08 <cprintf>
  8011e7:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011ea:	e8 6a 10 00 00       	call   802259 <sys_enable_interrupt>
			return;
  8011ef:	e9 9a 00 00 00       	jmp    80128e <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011f4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011f8:	7e 34                	jle    80122e <atomic_readline+0xa6>
  8011fa:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801201:	7f 2b                	jg     80122e <atomic_readline+0xa6>
			if (echoing)
  801203:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801207:	74 0e                	je     801217 <atomic_readline+0x8f>
				cputchar(c);
  801209:	83 ec 0c             	sub    $0xc,%esp
  80120c:	ff 75 ec             	pushl  -0x14(%ebp)
  80120f:	e8 6d f3 ff ff       	call   800581 <cputchar>
  801214:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80121a:	8d 50 01             	lea    0x1(%eax),%edx
  80121d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801220:	89 c2                	mov    %eax,%edx
  801222:	8b 45 0c             	mov    0xc(%ebp),%eax
  801225:	01 d0                	add    %edx,%eax
  801227:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80122a:	88 10                	mov    %dl,(%eax)
  80122c:	eb 5b                	jmp    801289 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80122e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801232:	75 1f                	jne    801253 <atomic_readline+0xcb>
  801234:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801238:	7e 19                	jle    801253 <atomic_readline+0xcb>
			if (echoing)
  80123a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80123e:	74 0e                	je     80124e <atomic_readline+0xc6>
				cputchar(c);
  801240:	83 ec 0c             	sub    $0xc,%esp
  801243:	ff 75 ec             	pushl  -0x14(%ebp)
  801246:	e8 36 f3 ff ff       	call   800581 <cputchar>
  80124b:	83 c4 10             	add    $0x10,%esp
			i--;
  80124e:	ff 4d f4             	decl   -0xc(%ebp)
  801251:	eb 36                	jmp    801289 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801253:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801257:	74 0a                	je     801263 <atomic_readline+0xdb>
  801259:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80125d:	0f 85 60 ff ff ff    	jne    8011c3 <atomic_readline+0x3b>
			if (echoing)
  801263:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801267:	74 0e                	je     801277 <atomic_readline+0xef>
				cputchar(c);
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	ff 75 ec             	pushl  -0x14(%ebp)
  80126f:	e8 0d f3 ff ff       	call   800581 <cputchar>
  801274:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801277:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127d:	01 d0                	add    %edx,%eax
  80127f:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801282:	e8 d2 0f 00 00       	call   802259 <sys_enable_interrupt>
			return;
  801287:	eb 05                	jmp    80128e <atomic_readline+0x106>
		}
	}
  801289:	e9 35 ff ff ff       	jmp    8011c3 <atomic_readline+0x3b>
}
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801296:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80129d:	eb 06                	jmp    8012a5 <strlen+0x15>
		n++;
  80129f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a2:	ff 45 08             	incl   0x8(%ebp)
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	84 c0                	test   %al,%al
  8012ac:	75 f1                	jne    80129f <strlen+0xf>
		n++;
	return n;
  8012ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012b1:	c9                   	leave  
  8012b2:	c3                   	ret    

008012b3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c0:	eb 09                	jmp    8012cb <strnlen+0x18>
		n++;
  8012c2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012c5:	ff 45 08             	incl   0x8(%ebp)
  8012c8:	ff 4d 0c             	decl   0xc(%ebp)
  8012cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012cf:	74 09                	je     8012da <strnlen+0x27>
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 e8                	jne    8012c2 <strnlen+0xf>
		n++;
	return n;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012eb:	90                   	nop
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	8d 50 01             	lea    0x1(%eax),%edx
  8012f2:	89 55 08             	mov    %edx,0x8(%ebp)
  8012f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012fb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012fe:	8a 12                	mov    (%edx),%dl
  801300:	88 10                	mov    %dl,(%eax)
  801302:	8a 00                	mov    (%eax),%al
  801304:	84 c0                	test   %al,%al
  801306:	75 e4                	jne    8012ec <strcpy+0xd>
		/* do nothing */;
	return ret;
  801308:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801319:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801320:	eb 1f                	jmp    801341 <strncpy+0x34>
		*dst++ = *src;
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	8d 50 01             	lea    0x1(%eax),%edx
  801328:	89 55 08             	mov    %edx,0x8(%ebp)
  80132b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132e:	8a 12                	mov    (%edx),%dl
  801330:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801332:	8b 45 0c             	mov    0xc(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	84 c0                	test   %al,%al
  801339:	74 03                	je     80133e <strncpy+0x31>
			src++;
  80133b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80133e:	ff 45 fc             	incl   -0x4(%ebp)
  801341:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801344:	3b 45 10             	cmp    0x10(%ebp),%eax
  801347:	72 d9                	jb     801322 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801349:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801354:	8b 45 08             	mov    0x8(%ebp),%eax
  801357:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80135a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80135e:	74 30                	je     801390 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801360:	eb 16                	jmp    801378 <strlcpy+0x2a>
			*dst++ = *src++;
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8d 50 01             	lea    0x1(%eax),%edx
  801368:	89 55 08             	mov    %edx,0x8(%ebp)
  80136b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801371:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801374:	8a 12                	mov    (%edx),%dl
  801376:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801378:	ff 4d 10             	decl   0x10(%ebp)
  80137b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137f:	74 09                	je     80138a <strlcpy+0x3c>
  801381:	8b 45 0c             	mov    0xc(%ebp),%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	84 c0                	test   %al,%al
  801388:	75 d8                	jne    801362 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801390:	8b 55 08             	mov    0x8(%ebp),%edx
  801393:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801396:	29 c2                	sub    %eax,%edx
  801398:	89 d0                	mov    %edx,%eax
}
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80139f:	eb 06                	jmp    8013a7 <strcmp+0xb>
		p++, q++;
  8013a1:	ff 45 08             	incl   0x8(%ebp)
  8013a4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	8a 00                	mov    (%eax),%al
  8013ac:	84 c0                	test   %al,%al
  8013ae:	74 0e                	je     8013be <strcmp+0x22>
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 10                	mov    (%eax),%dl
  8013b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b8:	8a 00                	mov    (%eax),%al
  8013ba:	38 c2                	cmp    %al,%dl
  8013bc:	74 e3                	je     8013a1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	0f b6 d0             	movzbl %al,%edx
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	0f b6 c0             	movzbl %al,%eax
  8013ce:	29 c2                	sub    %eax,%edx
  8013d0:	89 d0                	mov    %edx,%eax
}
  8013d2:	5d                   	pop    %ebp
  8013d3:	c3                   	ret    

008013d4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013d7:	eb 09                	jmp    8013e2 <strncmp+0xe>
		n--, p++, q++;
  8013d9:	ff 4d 10             	decl   0x10(%ebp)
  8013dc:	ff 45 08             	incl   0x8(%ebp)
  8013df:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e6:	74 17                	je     8013ff <strncmp+0x2b>
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	8a 00                	mov    (%eax),%al
  8013ed:	84 c0                	test   %al,%al
  8013ef:	74 0e                	je     8013ff <strncmp+0x2b>
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	8a 10                	mov    (%eax),%dl
  8013f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	38 c2                	cmp    %al,%dl
  8013fd:	74 da                	je     8013d9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801403:	75 07                	jne    80140c <strncmp+0x38>
		return 0;
  801405:	b8 00 00 00 00       	mov    $0x0,%eax
  80140a:	eb 14                	jmp    801420 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	0f b6 d0             	movzbl %al,%edx
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	0f b6 c0             	movzbl %al,%eax
  80141c:	29 c2                	sub    %eax,%edx
  80141e:	89 d0                	mov    %edx,%eax
}
  801420:	5d                   	pop    %ebp
  801421:	c3                   	ret    

00801422 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	83 ec 04             	sub    $0x4,%esp
  801428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80142e:	eb 12                	jmp    801442 <strchr+0x20>
		if (*s == c)
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801438:	75 05                	jne    80143f <strchr+0x1d>
			return (char *) s;
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	eb 11                	jmp    801450 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80143f:	ff 45 08             	incl   0x8(%ebp)
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	84 c0                	test   %al,%al
  801449:	75 e5                	jne    801430 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80144b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 04             	sub    $0x4,%esp
  801458:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80145e:	eb 0d                	jmp    80146d <strfind+0x1b>
		if (*s == c)
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	8a 00                	mov    (%eax),%al
  801465:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801468:	74 0e                	je     801478 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80146a:	ff 45 08             	incl   0x8(%ebp)
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	84 c0                	test   %al,%al
  801474:	75 ea                	jne    801460 <strfind+0xe>
  801476:	eb 01                	jmp    801479 <strfind+0x27>
		if (*s == c)
			break;
  801478:	90                   	nop
	return (char *) s;
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801490:	eb 0e                	jmp    8014a0 <memset+0x22>
		*p++ = c;
  801492:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801495:	8d 50 01             	lea    0x1(%eax),%edx
  801498:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80149b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014a0:	ff 4d f8             	decl   -0x8(%ebp)
  8014a3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014a7:	79 e9                	jns    801492 <memset+0x14>
		*p++ = c;

	return v;
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014c0:	eb 16                	jmp    8014d8 <memcpy+0x2a>
		*d++ = *s++;
  8014c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c5:	8d 50 01             	lea    0x1(%eax),%edx
  8014c8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014d1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014d4:	8a 12                	mov    (%edx),%dl
  8014d6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014de:	89 55 10             	mov    %edx,0x10(%ebp)
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	75 dd                	jne    8014c2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801502:	73 50                	jae    801554 <memmove+0x6a>
  801504:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801507:	8b 45 10             	mov    0x10(%ebp),%eax
  80150a:	01 d0                	add    %edx,%eax
  80150c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80150f:	76 43                	jbe    801554 <memmove+0x6a>
		s += n;
  801511:	8b 45 10             	mov    0x10(%ebp),%eax
  801514:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801517:	8b 45 10             	mov    0x10(%ebp),%eax
  80151a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80151d:	eb 10                	jmp    80152f <memmove+0x45>
			*--d = *--s;
  80151f:	ff 4d f8             	decl   -0x8(%ebp)
  801522:	ff 4d fc             	decl   -0x4(%ebp)
  801525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801528:	8a 10                	mov    (%eax),%dl
  80152a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80152f:	8b 45 10             	mov    0x10(%ebp),%eax
  801532:	8d 50 ff             	lea    -0x1(%eax),%edx
  801535:	89 55 10             	mov    %edx,0x10(%ebp)
  801538:	85 c0                	test   %eax,%eax
  80153a:	75 e3                	jne    80151f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80153c:	eb 23                	jmp    801561 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80153e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801541:	8d 50 01             	lea    0x1(%eax),%edx
  801544:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801547:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80154a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80154d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801550:	8a 12                	mov    (%edx),%dl
  801552:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	8d 50 ff             	lea    -0x1(%eax),%edx
  80155a:	89 55 10             	mov    %edx,0x10(%ebp)
  80155d:	85 c0                	test   %eax,%eax
  80155f:	75 dd                	jne    80153e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801572:	8b 45 0c             	mov    0xc(%ebp),%eax
  801575:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801578:	eb 2a                	jmp    8015a4 <memcmp+0x3e>
		if (*s1 != *s2)
  80157a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80157d:	8a 10                	mov    (%eax),%dl
  80157f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801582:	8a 00                	mov    (%eax),%al
  801584:	38 c2                	cmp    %al,%dl
  801586:	74 16                	je     80159e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801588:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80158b:	8a 00                	mov    (%eax),%al
  80158d:	0f b6 d0             	movzbl %al,%edx
  801590:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801593:	8a 00                	mov    (%eax),%al
  801595:	0f b6 c0             	movzbl %al,%eax
  801598:	29 c2                	sub    %eax,%edx
  80159a:	89 d0                	mov    %edx,%eax
  80159c:	eb 18                	jmp    8015b6 <memcmp+0x50>
		s1++, s2++;
  80159e:	ff 45 fc             	incl   -0x4(%ebp)
  8015a1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	75 c9                	jne    80157a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015be:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c4:	01 d0                	add    %edx,%eax
  8015c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015c9:	eb 15                	jmp    8015e0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	8a 00                	mov    (%eax),%al
  8015d0:	0f b6 d0             	movzbl %al,%edx
  8015d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d6:	0f b6 c0             	movzbl %al,%eax
  8015d9:	39 c2                	cmp    %eax,%edx
  8015db:	74 0d                	je     8015ea <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015dd:	ff 45 08             	incl   0x8(%ebp)
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015e6:	72 e3                	jb     8015cb <memfind+0x13>
  8015e8:	eb 01                	jmp    8015eb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015ea:	90                   	nop
	return (void *) s;
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801604:	eb 03                	jmp    801609 <strtol+0x19>
		s++;
  801606:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	8a 00                	mov    (%eax),%al
  80160e:	3c 20                	cmp    $0x20,%al
  801610:	74 f4                	je     801606 <strtol+0x16>
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	8a 00                	mov    (%eax),%al
  801617:	3c 09                	cmp    $0x9,%al
  801619:	74 eb                	je     801606 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8a 00                	mov    (%eax),%al
  801620:	3c 2b                	cmp    $0x2b,%al
  801622:	75 05                	jne    801629 <strtol+0x39>
		s++;
  801624:	ff 45 08             	incl   0x8(%ebp)
  801627:	eb 13                	jmp    80163c <strtol+0x4c>
	else if (*s == '-')
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	8a 00                	mov    (%eax),%al
  80162e:	3c 2d                	cmp    $0x2d,%al
  801630:	75 0a                	jne    80163c <strtol+0x4c>
		s++, neg = 1;
  801632:	ff 45 08             	incl   0x8(%ebp)
  801635:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80163c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801640:	74 06                	je     801648 <strtol+0x58>
  801642:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801646:	75 20                	jne    801668 <strtol+0x78>
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	8a 00                	mov    (%eax),%al
  80164d:	3c 30                	cmp    $0x30,%al
  80164f:	75 17                	jne    801668 <strtol+0x78>
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	40                   	inc    %eax
  801655:	8a 00                	mov    (%eax),%al
  801657:	3c 78                	cmp    $0x78,%al
  801659:	75 0d                	jne    801668 <strtol+0x78>
		s += 2, base = 16;
  80165b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80165f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801666:	eb 28                	jmp    801690 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801668:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80166c:	75 15                	jne    801683 <strtol+0x93>
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	8a 00                	mov    (%eax),%al
  801673:	3c 30                	cmp    $0x30,%al
  801675:	75 0c                	jne    801683 <strtol+0x93>
		s++, base = 8;
  801677:	ff 45 08             	incl   0x8(%ebp)
  80167a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801681:	eb 0d                	jmp    801690 <strtol+0xa0>
	else if (base == 0)
  801683:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801687:	75 07                	jne    801690 <strtol+0xa0>
		base = 10;
  801689:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	3c 2f                	cmp    $0x2f,%al
  801697:	7e 19                	jle    8016b2 <strtol+0xc2>
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	8a 00                	mov    (%eax),%al
  80169e:	3c 39                	cmp    $0x39,%al
  8016a0:	7f 10                	jg     8016b2 <strtol+0xc2>
			dig = *s - '0';
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	8a 00                	mov    (%eax),%al
  8016a7:	0f be c0             	movsbl %al,%eax
  8016aa:	83 e8 30             	sub    $0x30,%eax
  8016ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016b0:	eb 42                	jmp    8016f4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8a 00                	mov    (%eax),%al
  8016b7:	3c 60                	cmp    $0x60,%al
  8016b9:	7e 19                	jle    8016d4 <strtol+0xe4>
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	3c 7a                	cmp    $0x7a,%al
  8016c2:	7f 10                	jg     8016d4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	8a 00                	mov    (%eax),%al
  8016c9:	0f be c0             	movsbl %al,%eax
  8016cc:	83 e8 57             	sub    $0x57,%eax
  8016cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d2:	eb 20                	jmp    8016f4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	8a 00                	mov    (%eax),%al
  8016d9:	3c 40                	cmp    $0x40,%al
  8016db:	7e 39                	jle    801716 <strtol+0x126>
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8a 00                	mov    (%eax),%al
  8016e2:	3c 5a                	cmp    $0x5a,%al
  8016e4:	7f 30                	jg     801716 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	8a 00                	mov    (%eax),%al
  8016eb:	0f be c0             	movsbl %al,%eax
  8016ee:	83 e8 37             	sub    $0x37,%eax
  8016f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016fa:	7d 19                	jge    801715 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016fc:	ff 45 08             	incl   0x8(%ebp)
  8016ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801702:	0f af 45 10          	imul   0x10(%ebp),%eax
  801706:	89 c2                	mov    %eax,%edx
  801708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170b:	01 d0                	add    %edx,%eax
  80170d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801710:	e9 7b ff ff ff       	jmp    801690 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801715:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801716:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80171a:	74 08                	je     801724 <strtol+0x134>
		*endptr = (char *) s;
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	8b 55 08             	mov    0x8(%ebp),%edx
  801722:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801724:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801728:	74 07                	je     801731 <strtol+0x141>
  80172a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172d:	f7 d8                	neg    %eax
  80172f:	eb 03                	jmp    801734 <strtol+0x144>
  801731:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <ltostr>:

void
ltostr(long value, char *str)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80173c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801743:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80174a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80174e:	79 13                	jns    801763 <ltostr+0x2d>
	{
		neg = 1;
  801750:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80175d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801760:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80176b:	99                   	cltd   
  80176c:	f7 f9                	idiv   %ecx
  80176e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801771:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801774:	8d 50 01             	lea    0x1(%eax),%edx
  801777:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80177a:	89 c2                	mov    %eax,%edx
  80177c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177f:	01 d0                	add    %edx,%eax
  801781:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801784:	83 c2 30             	add    $0x30,%edx
  801787:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801789:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80178c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801791:	f7 e9                	imul   %ecx
  801793:	c1 fa 02             	sar    $0x2,%edx
  801796:	89 c8                	mov    %ecx,%eax
  801798:	c1 f8 1f             	sar    $0x1f,%eax
  80179b:	29 c2                	sub    %eax,%edx
  80179d:	89 d0                	mov    %edx,%eax
  80179f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017a5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017aa:	f7 e9                	imul   %ecx
  8017ac:	c1 fa 02             	sar    $0x2,%edx
  8017af:	89 c8                	mov    %ecx,%eax
  8017b1:	c1 f8 1f             	sar    $0x1f,%eax
  8017b4:	29 c2                	sub    %eax,%edx
  8017b6:	89 d0                	mov    %edx,%eax
  8017b8:	c1 e0 02             	shl    $0x2,%eax
  8017bb:	01 d0                	add    %edx,%eax
  8017bd:	01 c0                	add    %eax,%eax
  8017bf:	29 c1                	sub    %eax,%ecx
  8017c1:	89 ca                	mov    %ecx,%edx
  8017c3:	85 d2                	test   %edx,%edx
  8017c5:	75 9c                	jne    801763 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d1:	48                   	dec    %eax
  8017d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017d9:	74 3d                	je     801818 <ltostr+0xe2>
		start = 1 ;
  8017db:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017e2:	eb 34                	jmp    801818 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ea:	01 d0                	add    %edx,%eax
  8017ec:	8a 00                	mov    (%eax),%al
  8017ee:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f7:	01 c2                	add    %eax,%edx
  8017f9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ff:	01 c8                	add    %ecx,%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801805:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801808:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180b:	01 c2                	add    %eax,%edx
  80180d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801810:	88 02                	mov    %al,(%edx)
		start++ ;
  801812:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801815:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80181e:	7c c4                	jl     8017e4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801820:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801823:	8b 45 0c             	mov    0xc(%ebp),%eax
  801826:	01 d0                	add    %edx,%eax
  801828:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80182b:	90                   	nop
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801834:	ff 75 08             	pushl  0x8(%ebp)
  801837:	e8 54 fa ff ff       	call   801290 <strlen>
  80183c:	83 c4 04             	add    $0x4,%esp
  80183f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801842:	ff 75 0c             	pushl  0xc(%ebp)
  801845:	e8 46 fa ff ff       	call   801290 <strlen>
  80184a:	83 c4 04             	add    $0x4,%esp
  80184d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801850:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801857:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80185e:	eb 17                	jmp    801877 <strcconcat+0x49>
		final[s] = str1[s] ;
  801860:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801863:	8b 45 10             	mov    0x10(%ebp),%eax
  801866:	01 c2                	add    %eax,%edx
  801868:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	01 c8                	add    %ecx,%eax
  801870:	8a 00                	mov    (%eax),%al
  801872:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801874:	ff 45 fc             	incl   -0x4(%ebp)
  801877:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80187a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80187d:	7c e1                	jl     801860 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80187f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801886:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80188d:	eb 1f                	jmp    8018ae <strcconcat+0x80>
		final[s++] = str2[i] ;
  80188f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801892:	8d 50 01             	lea    0x1(%eax),%edx
  801895:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801898:	89 c2                	mov    %eax,%edx
  80189a:	8b 45 10             	mov    0x10(%ebp),%eax
  80189d:	01 c2                	add    %eax,%edx
  80189f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a5:	01 c8                	add    %ecx,%eax
  8018a7:	8a 00                	mov    (%eax),%al
  8018a9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018ab:	ff 45 f8             	incl   -0x8(%ebp)
  8018ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018b4:	7c d9                	jl     80188f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bc:	01 d0                	add    %edx,%eax
  8018be:	c6 00 00             	movb   $0x0,(%eax)
}
  8018c1:	90                   	nop
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d3:	8b 00                	mov    (%eax),%eax
  8018d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018df:	01 d0                	add    %edx,%eax
  8018e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018e7:	eb 0c                	jmp    8018f5 <strsplit+0x31>
			*string++ = 0;
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	8d 50 01             	lea    0x1(%eax),%edx
  8018ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8018f2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	8a 00                	mov    (%eax),%al
  8018fa:	84 c0                	test   %al,%al
  8018fc:	74 18                	je     801916 <strsplit+0x52>
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	8a 00                	mov    (%eax),%al
  801903:	0f be c0             	movsbl %al,%eax
  801906:	50                   	push   %eax
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	e8 13 fb ff ff       	call   801422 <strchr>
  80190f:	83 c4 08             	add    $0x8,%esp
  801912:	85 c0                	test   %eax,%eax
  801914:	75 d3                	jne    8018e9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	8a 00                	mov    (%eax),%al
  80191b:	84 c0                	test   %al,%al
  80191d:	74 5a                	je     801979 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80191f:	8b 45 14             	mov    0x14(%ebp),%eax
  801922:	8b 00                	mov    (%eax),%eax
  801924:	83 f8 0f             	cmp    $0xf,%eax
  801927:	75 07                	jne    801930 <strsplit+0x6c>
		{
			return 0;
  801929:	b8 00 00 00 00       	mov    $0x0,%eax
  80192e:	eb 66                	jmp    801996 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801930:	8b 45 14             	mov    0x14(%ebp),%eax
  801933:	8b 00                	mov    (%eax),%eax
  801935:	8d 48 01             	lea    0x1(%eax),%ecx
  801938:	8b 55 14             	mov    0x14(%ebp),%edx
  80193b:	89 0a                	mov    %ecx,(%edx)
  80193d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801944:	8b 45 10             	mov    0x10(%ebp),%eax
  801947:	01 c2                	add    %eax,%edx
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80194e:	eb 03                	jmp    801953 <strsplit+0x8f>
			string++;
  801950:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8a 00                	mov    (%eax),%al
  801958:	84 c0                	test   %al,%al
  80195a:	74 8b                	je     8018e7 <strsplit+0x23>
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	8a 00                	mov    (%eax),%al
  801961:	0f be c0             	movsbl %al,%eax
  801964:	50                   	push   %eax
  801965:	ff 75 0c             	pushl  0xc(%ebp)
  801968:	e8 b5 fa ff ff       	call   801422 <strchr>
  80196d:	83 c4 08             	add    $0x8,%esp
  801970:	85 c0                	test   %eax,%eax
  801972:	74 dc                	je     801950 <strsplit+0x8c>
			string++;
	}
  801974:	e9 6e ff ff ff       	jmp    8018e7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801979:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80197a:	8b 45 14             	mov    0x14(%ebp),%eax
  80197d:	8b 00                	mov    (%eax),%eax
  80197f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801986:	8b 45 10             	mov    0x10(%ebp),%eax
  801989:	01 d0                	add    %edx,%eax
  80198b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801991:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  80199e:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8019a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8019ab:	01 d0                	add    %edx,%eax
  8019ad:	48                   	dec    %eax
  8019ae:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8019b1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8019b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b9:	f7 75 ac             	divl   -0x54(%ebp)
  8019bc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8019bf:	29 d0                	sub    %edx,%eax
  8019c1:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8019c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8019cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8019d2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8019d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8019e0:	eb 3f                	jmp    801a21 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8019e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019e5:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  8019ec:	83 ec 04             	sub    $0x4,%esp
  8019ef:	50                   	push   %eax
  8019f0:	ff 75 e8             	pushl  -0x18(%ebp)
  8019f3:	68 04 30 80 00       	push   $0x803004
  8019f8:	e8 0b f0 ff ff       	call   800a08 <cprintf>
  8019fd:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801a00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a03:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801a0a:	83 ec 04             	sub    $0x4,%esp
  801a0d:	50                   	push   %eax
  801a0e:	ff 75 e8             	pushl  -0x18(%ebp)
  801a11:	68 19 30 80 00       	push   $0x803019
  801a16:	e8 ed ef ff ff       	call   800a08 <cprintf>
  801a1b:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801a1e:	ff 45 e8             	incl   -0x18(%ebp)
  801a21:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801a26:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801a29:	7c b7                	jl     8019e2 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801a2b:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801a32:	e9 42 01 00 00       	jmp    801b79 <malloc+0x1e1>
		int flag0=1;
  801a37:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801a3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a41:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a44:	eb 6b                	jmp    801ab1 <malloc+0x119>
			for(int k=0;k<count;k++){
  801a46:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801a4d:	eb 42                	jmp    801a91 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801a4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a52:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801a59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a5c:	39 c2                	cmp    %eax,%edx
  801a5e:	77 2e                	ja     801a8e <malloc+0xf6>
  801a60:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a63:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801a6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a6d:	39 c2                	cmp    %eax,%edx
  801a6f:	76 1d                	jbe    801a8e <malloc+0xf6>
					ni=arr_add[k].end-i;
  801a71:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a74:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801a7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a7e:	29 c2                	sub    %eax,%edx
  801a80:	89 d0                	mov    %edx,%eax
  801a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801a85:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801a8c:	eb 0d                	jmp    801a9b <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801a8e:	ff 45 d8             	incl   -0x28(%ebp)
  801a91:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801a96:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801a99:	7c b4                	jl     801a4f <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801a9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a9f:	74 09                	je     801aaa <malloc+0x112>
				flag0=0;
  801aa1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801aa8:	eb 16                	jmp    801ac0 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801aaa:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801ab1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	01 c2                	add    %eax,%edx
  801ab9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801abc:	39 c2                	cmp    %eax,%edx
  801abe:	77 86                	ja     801a46 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801ac0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ac4:	0f 84 a2 00 00 00    	je     801b6c <malloc+0x1d4>

			int f=1;
  801aca:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801ad1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ad4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ad7:	89 c8                	mov    %ecx,%eax
  801ad9:	01 c0                	add    %eax,%eax
  801adb:	01 c8                	add    %ecx,%eax
  801add:	c1 e0 02             	shl    $0x2,%eax
  801ae0:	05 20 41 80 00       	add    $0x804120,%eax
  801ae5:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801ae7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801af0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af3:	89 d0                	mov    %edx,%eax
  801af5:	01 c0                	add    %eax,%eax
  801af7:	01 d0                	add    %edx,%eax
  801af9:	c1 e0 02             	shl    $0x2,%eax
  801afc:	05 24 41 80 00       	add    $0x804124,%eax
  801b01:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801b03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b06:	89 d0                	mov    %edx,%eax
  801b08:	01 c0                	add    %eax,%eax
  801b0a:	01 d0                	add    %edx,%eax
  801b0c:	c1 e0 02             	shl    $0x2,%eax
  801b0f:	05 28 41 80 00       	add    $0x804128,%eax
  801b14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801b1a:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801b1d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801b24:	eb 36                	jmp    801b5c <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801b26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	01 c2                	add    %eax,%edx
  801b2e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b31:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801b38:	39 c2                	cmp    %eax,%edx
  801b3a:	73 1d                	jae    801b59 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801b3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b3f:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801b46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b49:	29 c2                	sub    %eax,%edx
  801b4b:	89 d0                	mov    %edx,%eax
  801b4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801b50:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801b57:	eb 0d                	jmp    801b66 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801b59:	ff 45 d0             	incl   -0x30(%ebp)
  801b5c:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801b61:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801b64:	7c c0                	jl     801b26 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801b66:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801b6a:	75 1d                	jne    801b89 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801b6c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b76:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801b79:	a1 04 40 80 00       	mov    0x804004,%eax
  801b7e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b81:	0f 8c b0 fe ff ff    	jl     801a37 <malloc+0x9f>
  801b87:	eb 01                	jmp    801b8a <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801b89:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b8e:	75 7a                	jne    801c0a <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801b90:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	01 d0                	add    %edx,%eax
  801b9b:	48                   	dec    %eax
  801b9c:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801ba1:	7c 0a                	jl     801bad <malloc+0x215>
			return NULL;
  801ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba8:	e9 a4 02 00 00       	jmp    801e51 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801bad:	a1 04 40 80 00       	mov    0x804004,%eax
  801bb2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801bb5:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bba:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801bbd:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801bc4:	83 ec 08             	sub    $0x8,%esp
  801bc7:	ff 75 08             	pushl  0x8(%ebp)
  801bca:	ff 75 a4             	pushl  -0x5c(%ebp)
  801bcd:	e8 04 06 00 00       	call   8021d6 <sys_allocateMem>
  801bd2:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801bd5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bde:	01 d0                	add    %edx,%eax
  801be0:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801be5:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bea:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bf0:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801bf7:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bfc:	40                   	inc    %eax
  801bfd:	a3 2c 40 80 00       	mov    %eax,0x80402c

			return (void*)s;
  801c02:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801c05:	e9 47 02 00 00       	jmp    801e51 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801c0a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801c11:	e9 ac 00 00 00       	jmp    801cc2 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801c16:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801c19:	89 d0                	mov    %edx,%eax
  801c1b:	01 c0                	add    %eax,%eax
  801c1d:	01 d0                	add    %edx,%eax
  801c1f:	c1 e0 02             	shl    $0x2,%eax
  801c22:	05 24 41 80 00       	add    $0x804124,%eax
  801c27:	8b 00                	mov    (%eax),%eax
  801c29:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801c2c:	eb 7e                	jmp    801cac <malloc+0x314>
			int flag=0;
  801c2e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801c35:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801c3c:	eb 57                	jmp    801c95 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801c3e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c41:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801c48:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c4b:	39 c2                	cmp    %eax,%edx
  801c4d:	77 1a                	ja     801c69 <malloc+0x2d1>
  801c4f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c52:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801c59:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c5c:	39 c2                	cmp    %eax,%edx
  801c5e:	76 09                	jbe    801c69 <malloc+0x2d1>
								flag=1;
  801c60:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801c67:	eb 36                	jmp    801c9f <malloc+0x307>
			arr[i].space++;
  801c69:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801c6c:	89 d0                	mov    %edx,%eax
  801c6e:	01 c0                	add    %eax,%eax
  801c70:	01 d0                	add    %edx,%eax
  801c72:	c1 e0 02             	shl    $0x2,%eax
  801c75:	05 28 41 80 00       	add    $0x804128,%eax
  801c7a:	8b 00                	mov    (%eax),%eax
  801c7c:	8d 48 01             	lea    0x1(%eax),%ecx
  801c7f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801c82:	89 d0                	mov    %edx,%eax
  801c84:	01 c0                	add    %eax,%eax
  801c86:	01 d0                	add    %edx,%eax
  801c88:	c1 e0 02             	shl    $0x2,%eax
  801c8b:	05 28 41 80 00       	add    $0x804128,%eax
  801c90:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801c92:	ff 45 c0             	incl   -0x40(%ebp)
  801c95:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801c9a:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801c9d:	7c 9f                	jl     801c3e <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801c9f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801ca3:	75 19                	jne    801cbe <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801ca5:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801cac:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801caf:	a1 04 40 80 00       	mov    0x804004,%eax
  801cb4:	39 c2                	cmp    %eax,%edx
  801cb6:	0f 82 72 ff ff ff    	jb     801c2e <malloc+0x296>
  801cbc:	eb 01                	jmp    801cbf <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801cbe:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801cbf:	ff 45 cc             	incl   -0x34(%ebp)
  801cc2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801cc5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801cc8:	0f 8c 48 ff ff ff    	jl     801c16 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801cce:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801cd5:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801cdc:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801ce3:	eb 37                	jmp    801d1c <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801ce5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801ce8:	89 d0                	mov    %edx,%eax
  801cea:	01 c0                	add    %eax,%eax
  801cec:	01 d0                	add    %edx,%eax
  801cee:	c1 e0 02             	shl    $0x2,%eax
  801cf1:	05 28 41 80 00       	add    $0x804128,%eax
  801cf6:	8b 00                	mov    (%eax),%eax
  801cf8:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801cfb:	7d 1c                	jge    801d19 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801cfd:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801d00:	89 d0                	mov    %edx,%eax
  801d02:	01 c0                	add    %eax,%eax
  801d04:	01 d0                	add    %edx,%eax
  801d06:	c1 e0 02             	shl    $0x2,%eax
  801d09:	05 28 41 80 00       	add    $0x804128,%eax
  801d0e:	8b 00                	mov    (%eax),%eax
  801d10:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801d13:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801d16:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801d19:	ff 45 b4             	incl   -0x4c(%ebp)
  801d1c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801d1f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d22:	7c c1                	jl     801ce5 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801d24:	8b 15 2c 40 80 00    	mov    0x80402c,%edx
  801d2a:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801d2d:	89 c8                	mov    %ecx,%eax
  801d2f:	01 c0                	add    %eax,%eax
  801d31:	01 c8                	add    %ecx,%eax
  801d33:	c1 e0 02             	shl    $0x2,%eax
  801d36:	05 20 41 80 00       	add    $0x804120,%eax
  801d3b:	8b 00                	mov    (%eax),%eax
  801d3d:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801d44:	8b 15 2c 40 80 00    	mov    0x80402c,%edx
  801d4a:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801d4d:	89 c8                	mov    %ecx,%eax
  801d4f:	01 c0                	add    %eax,%eax
  801d51:	01 c8                	add    %ecx,%eax
  801d53:	c1 e0 02             	shl    $0x2,%eax
  801d56:	05 24 41 80 00       	add    $0x804124,%eax
  801d5b:	8b 00                	mov    (%eax),%eax
  801d5d:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  801d64:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801d69:	40                   	inc    %eax
  801d6a:	a3 2c 40 80 00       	mov    %eax,0x80402c


		sys_allocateMem(arr[index].start,size);
  801d6f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801d72:	89 d0                	mov    %edx,%eax
  801d74:	01 c0                	add    %eax,%eax
  801d76:	01 d0                	add    %edx,%eax
  801d78:	c1 e0 02             	shl    $0x2,%eax
  801d7b:	05 20 41 80 00       	add    $0x804120,%eax
  801d80:	8b 00                	mov    (%eax),%eax
  801d82:	83 ec 08             	sub    $0x8,%esp
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	50                   	push   %eax
  801d89:	e8 48 04 00 00       	call   8021d6 <sys_allocateMem>
  801d8e:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801d91:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801d98:	eb 78                	jmp    801e12 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801d9a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801d9d:	89 d0                	mov    %edx,%eax
  801d9f:	01 c0                	add    %eax,%eax
  801da1:	01 d0                	add    %edx,%eax
  801da3:	c1 e0 02             	shl    $0x2,%eax
  801da6:	05 20 41 80 00       	add    $0x804120,%eax
  801dab:	8b 00                	mov    (%eax),%eax
  801dad:	83 ec 04             	sub    $0x4,%esp
  801db0:	50                   	push   %eax
  801db1:	ff 75 b0             	pushl  -0x50(%ebp)
  801db4:	68 04 30 80 00       	push   $0x803004
  801db9:	e8 4a ec ff ff       	call   800a08 <cprintf>
  801dbe:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801dc1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801dc4:	89 d0                	mov    %edx,%eax
  801dc6:	01 c0                	add    %eax,%eax
  801dc8:	01 d0                	add    %edx,%eax
  801dca:	c1 e0 02             	shl    $0x2,%eax
  801dcd:	05 24 41 80 00       	add    $0x804124,%eax
  801dd2:	8b 00                	mov    (%eax),%eax
  801dd4:	83 ec 04             	sub    $0x4,%esp
  801dd7:	50                   	push   %eax
  801dd8:	ff 75 b0             	pushl  -0x50(%ebp)
  801ddb:	68 19 30 80 00       	push   $0x803019
  801de0:	e8 23 ec ff ff       	call   800a08 <cprintf>
  801de5:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801de8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801deb:	89 d0                	mov    %edx,%eax
  801ded:	01 c0                	add    %eax,%eax
  801def:	01 d0                	add    %edx,%eax
  801df1:	c1 e0 02             	shl    $0x2,%eax
  801df4:	05 28 41 80 00       	add    $0x804128,%eax
  801df9:	8b 00                	mov    (%eax),%eax
  801dfb:	83 ec 04             	sub    $0x4,%esp
  801dfe:	50                   	push   %eax
  801dff:	ff 75 b0             	pushl  -0x50(%ebp)
  801e02:	68 2c 30 80 00       	push   $0x80302c
  801e07:	e8 fc eb ff ff       	call   800a08 <cprintf>
  801e0c:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801e0f:	ff 45 b0             	incl   -0x50(%ebp)
  801e12:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801e15:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e18:	7c 80                	jl     801d9a <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801e1a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e1d:	89 d0                	mov    %edx,%eax
  801e1f:	01 c0                	add    %eax,%eax
  801e21:	01 d0                	add    %edx,%eax
  801e23:	c1 e0 02             	shl    $0x2,%eax
  801e26:	05 20 41 80 00       	add    $0x804120,%eax
  801e2b:	8b 00                	mov    (%eax),%eax
  801e2d:	83 ec 08             	sub    $0x8,%esp
  801e30:	50                   	push   %eax
  801e31:	68 40 30 80 00       	push   $0x803040
  801e36:	e8 cd eb ff ff       	call   800a08 <cprintf>
  801e3b:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801e3e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e41:	89 d0                	mov    %edx,%eax
  801e43:	01 c0                	add    %eax,%eax
  801e45:	01 d0                	add    %edx,%eax
  801e47:	c1 e0 02             	shl    $0x2,%eax
  801e4a:	05 20 41 80 00       	add    $0x804120,%eax
  801e4f:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801e5f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801e66:	eb 4b                	jmp    801eb3 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e6b:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801e72:	89 c2                	mov    %eax,%edx
  801e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e77:	39 c2                	cmp    %eax,%edx
  801e79:	7f 35                	jg     801eb0 <free+0x5d>
  801e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e7e:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801e85:	89 c2                	mov    %eax,%edx
  801e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e8a:	39 c2                	cmp    %eax,%edx
  801e8c:	7e 22                	jle    801eb0 <free+0x5d>
				start=arr_add[i].start;
  801e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e91:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801e98:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801e9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e9e:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eab:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801eae:	eb 0d                	jmp    801ebd <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801eb0:	ff 45 ec             	incl   -0x14(%ebp)
  801eb3:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801eb8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801ebb:	7c ab                	jl     801e68 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec0:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eca:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801ed1:	29 c2                	sub    %eax,%edx
  801ed3:	89 d0                	mov    %edx,%eax
  801ed5:	83 ec 08             	sub    $0x8,%esp
  801ed8:	50                   	push   %eax
  801ed9:	ff 75 f4             	pushl  -0xc(%ebp)
  801edc:	e8 d9 02 00 00       	call   8021ba <sys_freeMem>
  801ee1:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801eea:	eb 2d                	jmp    801f19 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801eec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801eef:	40                   	inc    %eax
  801ef0:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801ef7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801efa:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801f01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f04:	40                   	inc    %eax
  801f05:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801f0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f0f:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801f16:	ff 45 e8             	incl   -0x18(%ebp)
  801f19:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801f1e:	48                   	dec    %eax
  801f1f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f22:	7f c8                	jg     801eec <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801f24:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801f29:	48                   	dec    %eax
  801f2a:	a3 2c 40 80 00       	mov    %eax,0x80402c
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801f2f:	90                   	nop
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	83 ec 18             	sub    $0x18,%esp
  801f38:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3b:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801f3e:	83 ec 04             	sub    $0x4,%esp
  801f41:	68 5c 30 80 00       	push   $0x80305c
  801f46:	68 18 01 00 00       	push   $0x118
  801f4b:	68 7f 30 80 00       	push   $0x80307f
  801f50:	e8 11 e8 ff ff       	call   800766 <_panic>

00801f55 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f5b:	83 ec 04             	sub    $0x4,%esp
  801f5e:	68 5c 30 80 00       	push   $0x80305c
  801f63:	68 1e 01 00 00       	push   $0x11e
  801f68:	68 7f 30 80 00       	push   $0x80307f
  801f6d:	e8 f4 e7 ff ff       	call   800766 <_panic>

00801f72 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f78:	83 ec 04             	sub    $0x4,%esp
  801f7b:	68 5c 30 80 00       	push   $0x80305c
  801f80:	68 24 01 00 00       	push   $0x124
  801f85:	68 7f 30 80 00       	push   $0x80307f
  801f8a:	e8 d7 e7 ff ff       	call   800766 <_panic>

00801f8f <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f95:	83 ec 04             	sub    $0x4,%esp
  801f98:	68 5c 30 80 00       	push   $0x80305c
  801f9d:	68 29 01 00 00       	push   $0x129
  801fa2:	68 7f 30 80 00       	push   $0x80307f
  801fa7:	e8 ba e7 ff ff       	call   800766 <_panic>

00801fac <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fb2:	83 ec 04             	sub    $0x4,%esp
  801fb5:	68 5c 30 80 00       	push   $0x80305c
  801fba:	68 2f 01 00 00       	push   $0x12f
  801fbf:	68 7f 30 80 00       	push   $0x80307f
  801fc4:	e8 9d e7 ff ff       	call   800766 <_panic>

00801fc9 <shrink>:
}
void shrink(uint32 newSize)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fcf:	83 ec 04             	sub    $0x4,%esp
  801fd2:	68 5c 30 80 00       	push   $0x80305c
  801fd7:	68 33 01 00 00       	push   $0x133
  801fdc:	68 7f 30 80 00       	push   $0x80307f
  801fe1:	e8 80 e7 ff ff       	call   800766 <_panic>

00801fe6 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fec:	83 ec 04             	sub    $0x4,%esp
  801fef:	68 5c 30 80 00       	push   $0x80305c
  801ff4:	68 38 01 00 00       	push   $0x138
  801ff9:	68 7f 30 80 00       	push   $0x80307f
  801ffe:	e8 63 e7 ff ff       	call   800766 <_panic>

00802003 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	57                   	push   %edi
  802007:	56                   	push   %esi
  802008:	53                   	push   %ebx
  802009:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802012:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802015:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802018:	8b 7d 18             	mov    0x18(%ebp),%edi
  80201b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80201e:	cd 30                	int    $0x30
  802020:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802023:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802026:	83 c4 10             	add    $0x10,%esp
  802029:	5b                   	pop    %ebx
  80202a:	5e                   	pop    %esi
  80202b:	5f                   	pop    %edi
  80202c:	5d                   	pop    %ebp
  80202d:	c3                   	ret    

0080202e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	83 ec 04             	sub    $0x4,%esp
  802034:	8b 45 10             	mov    0x10(%ebp),%eax
  802037:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80203a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	52                   	push   %edx
  802046:	ff 75 0c             	pushl  0xc(%ebp)
  802049:	50                   	push   %eax
  80204a:	6a 00                	push   $0x0
  80204c:	e8 b2 ff ff ff       	call   802003 <syscall>
  802051:	83 c4 18             	add    $0x18,%esp
}
  802054:	90                   	nop
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <sys_cgetc>:

int
sys_cgetc(void)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 01                	push   $0x1
  802066:	e8 98 ff ff ff       	call   802003 <syscall>
  80206b:	83 c4 18             	add    $0x18,%esp
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	50                   	push   %eax
  80207f:	6a 05                	push   $0x5
  802081:	e8 7d ff ff ff       	call   802003 <syscall>
  802086:	83 c4 18             	add    $0x18,%esp
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 02                	push   $0x2
  80209a:	e8 64 ff ff ff       	call   802003 <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
}
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 03                	push   $0x3
  8020b3:	e8 4b ff ff ff       	call   802003 <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 04                	push   $0x4
  8020cc:	e8 32 ff ff ff       	call   802003 <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_env_exit>:


void sys_env_exit(void)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 06                	push   $0x6
  8020e5:	e8 19 ff ff ff       	call   802003 <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	90                   	nop
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	52                   	push   %edx
  802100:	50                   	push   %eax
  802101:	6a 07                	push   $0x7
  802103:	e8 fb fe ff ff       	call   802003 <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
  802110:	56                   	push   %esi
  802111:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802112:	8b 75 18             	mov    0x18(%ebp),%esi
  802115:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802118:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211e:	8b 45 08             	mov    0x8(%ebp),%eax
  802121:	56                   	push   %esi
  802122:	53                   	push   %ebx
  802123:	51                   	push   %ecx
  802124:	52                   	push   %edx
  802125:	50                   	push   %eax
  802126:	6a 08                	push   $0x8
  802128:	e8 d6 fe ff ff       	call   802003 <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
}
  802130:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802133:	5b                   	pop    %ebx
  802134:	5e                   	pop    %esi
  802135:	5d                   	pop    %ebp
  802136:	c3                   	ret    

00802137 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80213a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	52                   	push   %edx
  802147:	50                   	push   %eax
  802148:	6a 09                	push   $0x9
  80214a:	e8 b4 fe ff ff       	call   802003 <syscall>
  80214f:	83 c4 18             	add    $0x18,%esp
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	ff 75 0c             	pushl  0xc(%ebp)
  802160:	ff 75 08             	pushl  0x8(%ebp)
  802163:	6a 0a                	push   $0xa
  802165:	e8 99 fe ff ff       	call   802003 <syscall>
  80216a:	83 c4 18             	add    $0x18,%esp
}
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 0b                	push   $0xb
  80217e:	e8 80 fe ff ff       	call   802003 <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 0c                	push   $0xc
  802197:	e8 67 fe ff ff       	call   802003 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 0d                	push   $0xd
  8021b0:	e8 4e fe ff ff       	call   802003 <syscall>
  8021b5:	83 c4 18             	add    $0x18,%esp
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	ff 75 0c             	pushl  0xc(%ebp)
  8021c6:	ff 75 08             	pushl  0x8(%ebp)
  8021c9:	6a 11                	push   $0x11
  8021cb:	e8 33 fe ff ff       	call   802003 <syscall>
  8021d0:	83 c4 18             	add    $0x18,%esp
	return;
  8021d3:	90                   	nop
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	ff 75 0c             	pushl  0xc(%ebp)
  8021e2:	ff 75 08             	pushl  0x8(%ebp)
  8021e5:	6a 12                	push   $0x12
  8021e7:	e8 17 fe ff ff       	call   802003 <syscall>
  8021ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ef:	90                   	nop
}
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 0e                	push   $0xe
  802201:	e8 fd fd ff ff       	call   802003 <syscall>
  802206:	83 c4 18             	add    $0x18,%esp
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	ff 75 08             	pushl  0x8(%ebp)
  802219:	6a 0f                	push   $0xf
  80221b:	e8 e3 fd ff ff       	call   802003 <syscall>
  802220:	83 c4 18             	add    $0x18,%esp
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 10                	push   $0x10
  802234:	e8 ca fd ff ff       	call   802003 <syscall>
  802239:	83 c4 18             	add    $0x18,%esp
}
  80223c:	90                   	nop
  80223d:	c9                   	leave  
  80223e:	c3                   	ret    

0080223f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 14                	push   $0x14
  80224e:	e8 b0 fd ff ff       	call   802003 <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
}
  802256:	90                   	nop
  802257:	c9                   	leave  
  802258:	c3                   	ret    

00802259 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 15                	push   $0x15
  802268:	e8 96 fd ff ff       	call   802003 <syscall>
  80226d:	83 c4 18             	add    $0x18,%esp
}
  802270:	90                   	nop
  802271:	c9                   	leave  
  802272:	c3                   	ret    

00802273 <sys_cputc>:


void
sys_cputc(const char c)
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
  802276:	83 ec 04             	sub    $0x4,%esp
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80227f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	50                   	push   %eax
  80228c:	6a 16                	push   $0x16
  80228e:	e8 70 fd ff ff       	call   802003 <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
}
  802296:	90                   	nop
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 17                	push   $0x17
  8022a8:	e8 56 fd ff ff       	call   802003 <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
}
  8022b0:	90                   	nop
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	ff 75 0c             	pushl  0xc(%ebp)
  8022c2:	50                   	push   %eax
  8022c3:	6a 18                	push   $0x18
  8022c5:	e8 39 fd ff ff       	call   802003 <syscall>
  8022ca:	83 c4 18             	add    $0x18,%esp
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	52                   	push   %edx
  8022df:	50                   	push   %eax
  8022e0:	6a 1b                	push   $0x1b
  8022e2:	e8 1c fd ff ff       	call   802003 <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
}
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    

008022ec <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	52                   	push   %edx
  8022fc:	50                   	push   %eax
  8022fd:	6a 19                	push   $0x19
  8022ff:	e8 ff fc ff ff       	call   802003 <syscall>
  802304:	83 c4 18             	add    $0x18,%esp
}
  802307:	90                   	nop
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80230d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	52                   	push   %edx
  80231a:	50                   	push   %eax
  80231b:	6a 1a                	push   $0x1a
  80231d:	e8 e1 fc ff ff       	call   802003 <syscall>
  802322:	83 c4 18             	add    $0x18,%esp
}
  802325:	90                   	nop
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	83 ec 04             	sub    $0x4,%esp
  80232e:	8b 45 10             	mov    0x10(%ebp),%eax
  802331:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802334:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802337:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	6a 00                	push   $0x0
  802340:	51                   	push   %ecx
  802341:	52                   	push   %edx
  802342:	ff 75 0c             	pushl  0xc(%ebp)
  802345:	50                   	push   %eax
  802346:	6a 1c                	push   $0x1c
  802348:	e8 b6 fc ff ff       	call   802003 <syscall>
  80234d:	83 c4 18             	add    $0x18,%esp
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802355:	8b 55 0c             	mov    0xc(%ebp),%edx
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	52                   	push   %edx
  802362:	50                   	push   %eax
  802363:	6a 1d                	push   $0x1d
  802365:	e8 99 fc ff ff       	call   802003 <syscall>
  80236a:	83 c4 18             	add    $0x18,%esp
}
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802372:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802375:	8b 55 0c             	mov    0xc(%ebp),%edx
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	51                   	push   %ecx
  802380:	52                   	push   %edx
  802381:	50                   	push   %eax
  802382:	6a 1e                	push   $0x1e
  802384:	e8 7a fc ff ff       	call   802003 <syscall>
  802389:	83 c4 18             	add    $0x18,%esp
}
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802391:	8b 55 0c             	mov    0xc(%ebp),%edx
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	52                   	push   %edx
  80239e:	50                   	push   %eax
  80239f:	6a 1f                	push   $0x1f
  8023a1:	e8 5d fc ff ff       	call   802003 <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 20                	push   $0x20
  8023ba:	e8 44 fc ff ff       	call   802003 <syscall>
  8023bf:	83 c4 18             	add    $0x18,%esp
}
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	6a 00                	push   $0x0
  8023cc:	ff 75 14             	pushl  0x14(%ebp)
  8023cf:	ff 75 10             	pushl  0x10(%ebp)
  8023d2:	ff 75 0c             	pushl  0xc(%ebp)
  8023d5:	50                   	push   %eax
  8023d6:	6a 21                	push   $0x21
  8023d8:	e8 26 fc ff ff       	call   802003 <syscall>
  8023dd:	83 c4 18             	add    $0x18,%esp
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	50                   	push   %eax
  8023f1:	6a 22                	push   $0x22
  8023f3:	e8 0b fc ff ff       	call   802003 <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
}
  8023fb:	90                   	nop
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	50                   	push   %eax
  80240d:	6a 23                	push   $0x23
  80240f:	e8 ef fb ff ff       	call   802003 <syscall>
  802414:	83 c4 18             	add    $0x18,%esp
}
  802417:	90                   	nop
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802420:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802423:	8d 50 04             	lea    0x4(%eax),%edx
  802426:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	52                   	push   %edx
  802430:	50                   	push   %eax
  802431:	6a 24                	push   $0x24
  802433:	e8 cb fb ff ff       	call   802003 <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
	return result;
  80243b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80243e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802441:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802444:	89 01                	mov    %eax,(%ecx)
  802446:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	c9                   	leave  
  80244d:	c2 04 00             	ret    $0x4

00802450 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	ff 75 10             	pushl  0x10(%ebp)
  80245a:	ff 75 0c             	pushl  0xc(%ebp)
  80245d:	ff 75 08             	pushl  0x8(%ebp)
  802460:	6a 13                	push   $0x13
  802462:	e8 9c fb ff ff       	call   802003 <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
	return ;
  80246a:	90                   	nop
}
  80246b:	c9                   	leave  
  80246c:	c3                   	ret    

0080246d <sys_rcr2>:
uint32 sys_rcr2()
{
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 25                	push   $0x25
  80247c:	e8 82 fb ff ff       	call   802003 <syscall>
  802481:	83 c4 18             	add    $0x18,%esp
}
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	83 ec 04             	sub    $0x4,%esp
  80248c:	8b 45 08             	mov    0x8(%ebp),%eax
  80248f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802492:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	50                   	push   %eax
  80249f:	6a 26                	push   $0x26
  8024a1:	e8 5d fb ff ff       	call   802003 <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a9:	90                   	nop
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <rsttst>:
void rsttst()
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 28                	push   $0x28
  8024bb:	e8 43 fb ff ff       	call   802003 <syscall>
  8024c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c3:	90                   	nop
}
  8024c4:	c9                   	leave  
  8024c5:	c3                   	ret    

008024c6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
  8024c9:	83 ec 04             	sub    $0x4,%esp
  8024cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8024cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024d2:	8b 55 18             	mov    0x18(%ebp),%edx
  8024d5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024d9:	52                   	push   %edx
  8024da:	50                   	push   %eax
  8024db:	ff 75 10             	pushl  0x10(%ebp)
  8024de:	ff 75 0c             	pushl  0xc(%ebp)
  8024e1:	ff 75 08             	pushl  0x8(%ebp)
  8024e4:	6a 27                	push   $0x27
  8024e6:	e8 18 fb ff ff       	call   802003 <syscall>
  8024eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ee:	90                   	nop
}
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <chktst>:
void chktst(uint32 n)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	ff 75 08             	pushl  0x8(%ebp)
  8024ff:	6a 29                	push   $0x29
  802501:	e8 fd fa ff ff       	call   802003 <syscall>
  802506:	83 c4 18             	add    $0x18,%esp
	return ;
  802509:	90                   	nop
}
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <inctst>:

void inctst()
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 2a                	push   $0x2a
  80251b:	e8 e3 fa ff ff       	call   802003 <syscall>
  802520:	83 c4 18             	add    $0x18,%esp
	return ;
  802523:	90                   	nop
}
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <gettst>:
uint32 gettst()
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	6a 2b                	push   $0x2b
  802535:	e8 c9 fa ff ff       	call   802003 <syscall>
  80253a:	83 c4 18             	add    $0x18,%esp
}
  80253d:	c9                   	leave  
  80253e:	c3                   	ret    

0080253f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80253f:	55                   	push   %ebp
  802540:	89 e5                	mov    %esp,%ebp
  802542:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 2c                	push   $0x2c
  802551:	e8 ad fa ff ff       	call   802003 <syscall>
  802556:	83 c4 18             	add    $0x18,%esp
  802559:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80255c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802560:	75 07                	jne    802569 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802562:	b8 01 00 00 00       	mov    $0x1,%eax
  802567:	eb 05                	jmp    80256e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802569:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80256e:	c9                   	leave  
  80256f:	c3                   	ret    

00802570 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 2c                	push   $0x2c
  802582:	e8 7c fa ff ff       	call   802003 <syscall>
  802587:	83 c4 18             	add    $0x18,%esp
  80258a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80258d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802591:	75 07                	jne    80259a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802593:	b8 01 00 00 00       	mov    $0x1,%eax
  802598:	eb 05                	jmp    80259f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80259a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80259f:	c9                   	leave  
  8025a0:	c3                   	ret    

008025a1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025a1:	55                   	push   %ebp
  8025a2:	89 e5                	mov    %esp,%ebp
  8025a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 2c                	push   $0x2c
  8025b3:	e8 4b fa ff ff       	call   802003 <syscall>
  8025b8:	83 c4 18             	add    $0x18,%esp
  8025bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025be:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025c2:	75 07                	jne    8025cb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c9:	eb 05                	jmp    8025d0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    

008025d2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
  8025d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 2c                	push   $0x2c
  8025e4:	e8 1a fa ff ff       	call   802003 <syscall>
  8025e9:	83 c4 18             	add    $0x18,%esp
  8025ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025ef:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8025f3:	75 07                	jne    8025fc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8025f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8025fa:	eb 05                	jmp    802601 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8025fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802601:	c9                   	leave  
  802602:	c3                   	ret    

00802603 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	ff 75 08             	pushl  0x8(%ebp)
  802611:	6a 2d                	push   $0x2d
  802613:	e8 eb f9 ff ff       	call   802003 <syscall>
  802618:	83 c4 18             	add    $0x18,%esp
	return ;
  80261b:	90                   	nop
}
  80261c:	c9                   	leave  
  80261d:	c3                   	ret    

0080261e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80261e:	55                   	push   %ebp
  80261f:	89 e5                	mov    %esp,%ebp
  802621:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802622:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802625:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80262b:	8b 45 08             	mov    0x8(%ebp),%eax
  80262e:	6a 00                	push   $0x0
  802630:	53                   	push   %ebx
  802631:	51                   	push   %ecx
  802632:	52                   	push   %edx
  802633:	50                   	push   %eax
  802634:	6a 2e                	push   $0x2e
  802636:	e8 c8 f9 ff ff       	call   802003 <syscall>
  80263b:	83 c4 18             	add    $0x18,%esp
}
  80263e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802641:	c9                   	leave  
  802642:	c3                   	ret    

00802643 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802646:	8b 55 0c             	mov    0xc(%ebp),%edx
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	52                   	push   %edx
  802653:	50                   	push   %eax
  802654:	6a 2f                	push   $0x2f
  802656:	e8 a8 f9 ff ff       	call   802003 <syscall>
  80265b:	83 c4 18             	add    $0x18,%esp
}
  80265e:	c9                   	leave  
  80265f:	c3                   	ret    

00802660 <__udivdi3>:
  802660:	55                   	push   %ebp
  802661:	57                   	push   %edi
  802662:	56                   	push   %esi
  802663:	53                   	push   %ebx
  802664:	83 ec 1c             	sub    $0x1c,%esp
  802667:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80266b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80266f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802673:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802677:	89 ca                	mov    %ecx,%edx
  802679:	89 f8                	mov    %edi,%eax
  80267b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80267f:	85 f6                	test   %esi,%esi
  802681:	75 2d                	jne    8026b0 <__udivdi3+0x50>
  802683:	39 cf                	cmp    %ecx,%edi
  802685:	77 65                	ja     8026ec <__udivdi3+0x8c>
  802687:	89 fd                	mov    %edi,%ebp
  802689:	85 ff                	test   %edi,%edi
  80268b:	75 0b                	jne    802698 <__udivdi3+0x38>
  80268d:	b8 01 00 00 00       	mov    $0x1,%eax
  802692:	31 d2                	xor    %edx,%edx
  802694:	f7 f7                	div    %edi
  802696:	89 c5                	mov    %eax,%ebp
  802698:	31 d2                	xor    %edx,%edx
  80269a:	89 c8                	mov    %ecx,%eax
  80269c:	f7 f5                	div    %ebp
  80269e:	89 c1                	mov    %eax,%ecx
  8026a0:	89 d8                	mov    %ebx,%eax
  8026a2:	f7 f5                	div    %ebp
  8026a4:	89 cf                	mov    %ecx,%edi
  8026a6:	89 fa                	mov    %edi,%edx
  8026a8:	83 c4 1c             	add    $0x1c,%esp
  8026ab:	5b                   	pop    %ebx
  8026ac:	5e                   	pop    %esi
  8026ad:	5f                   	pop    %edi
  8026ae:	5d                   	pop    %ebp
  8026af:	c3                   	ret    
  8026b0:	39 ce                	cmp    %ecx,%esi
  8026b2:	77 28                	ja     8026dc <__udivdi3+0x7c>
  8026b4:	0f bd fe             	bsr    %esi,%edi
  8026b7:	83 f7 1f             	xor    $0x1f,%edi
  8026ba:	75 40                	jne    8026fc <__udivdi3+0x9c>
  8026bc:	39 ce                	cmp    %ecx,%esi
  8026be:	72 0a                	jb     8026ca <__udivdi3+0x6a>
  8026c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8026c4:	0f 87 9e 00 00 00    	ja     802768 <__udivdi3+0x108>
  8026ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8026cf:	89 fa                	mov    %edi,%edx
  8026d1:	83 c4 1c             	add    $0x1c,%esp
  8026d4:	5b                   	pop    %ebx
  8026d5:	5e                   	pop    %esi
  8026d6:	5f                   	pop    %edi
  8026d7:	5d                   	pop    %ebp
  8026d8:	c3                   	ret    
  8026d9:	8d 76 00             	lea    0x0(%esi),%esi
  8026dc:	31 ff                	xor    %edi,%edi
  8026de:	31 c0                	xor    %eax,%eax
  8026e0:	89 fa                	mov    %edi,%edx
  8026e2:	83 c4 1c             	add    $0x1c,%esp
  8026e5:	5b                   	pop    %ebx
  8026e6:	5e                   	pop    %esi
  8026e7:	5f                   	pop    %edi
  8026e8:	5d                   	pop    %ebp
  8026e9:	c3                   	ret    
  8026ea:	66 90                	xchg   %ax,%ax
  8026ec:	89 d8                	mov    %ebx,%eax
  8026ee:	f7 f7                	div    %edi
  8026f0:	31 ff                	xor    %edi,%edi
  8026f2:	89 fa                	mov    %edi,%edx
  8026f4:	83 c4 1c             	add    $0x1c,%esp
  8026f7:	5b                   	pop    %ebx
  8026f8:	5e                   	pop    %esi
  8026f9:	5f                   	pop    %edi
  8026fa:	5d                   	pop    %ebp
  8026fb:	c3                   	ret    
  8026fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  802701:	89 eb                	mov    %ebp,%ebx
  802703:	29 fb                	sub    %edi,%ebx
  802705:	89 f9                	mov    %edi,%ecx
  802707:	d3 e6                	shl    %cl,%esi
  802709:	89 c5                	mov    %eax,%ebp
  80270b:	88 d9                	mov    %bl,%cl
  80270d:	d3 ed                	shr    %cl,%ebp
  80270f:	89 e9                	mov    %ebp,%ecx
  802711:	09 f1                	or     %esi,%ecx
  802713:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802717:	89 f9                	mov    %edi,%ecx
  802719:	d3 e0                	shl    %cl,%eax
  80271b:	89 c5                	mov    %eax,%ebp
  80271d:	89 d6                	mov    %edx,%esi
  80271f:	88 d9                	mov    %bl,%cl
  802721:	d3 ee                	shr    %cl,%esi
  802723:	89 f9                	mov    %edi,%ecx
  802725:	d3 e2                	shl    %cl,%edx
  802727:	8b 44 24 08          	mov    0x8(%esp),%eax
  80272b:	88 d9                	mov    %bl,%cl
  80272d:	d3 e8                	shr    %cl,%eax
  80272f:	09 c2                	or     %eax,%edx
  802731:	89 d0                	mov    %edx,%eax
  802733:	89 f2                	mov    %esi,%edx
  802735:	f7 74 24 0c          	divl   0xc(%esp)
  802739:	89 d6                	mov    %edx,%esi
  80273b:	89 c3                	mov    %eax,%ebx
  80273d:	f7 e5                	mul    %ebp
  80273f:	39 d6                	cmp    %edx,%esi
  802741:	72 19                	jb     80275c <__udivdi3+0xfc>
  802743:	74 0b                	je     802750 <__udivdi3+0xf0>
  802745:	89 d8                	mov    %ebx,%eax
  802747:	31 ff                	xor    %edi,%edi
  802749:	e9 58 ff ff ff       	jmp    8026a6 <__udivdi3+0x46>
  80274e:	66 90                	xchg   %ax,%ax
  802750:	8b 54 24 08          	mov    0x8(%esp),%edx
  802754:	89 f9                	mov    %edi,%ecx
  802756:	d3 e2                	shl    %cl,%edx
  802758:	39 c2                	cmp    %eax,%edx
  80275a:	73 e9                	jae    802745 <__udivdi3+0xe5>
  80275c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80275f:	31 ff                	xor    %edi,%edi
  802761:	e9 40 ff ff ff       	jmp    8026a6 <__udivdi3+0x46>
  802766:	66 90                	xchg   %ax,%ax
  802768:	31 c0                	xor    %eax,%eax
  80276a:	e9 37 ff ff ff       	jmp    8026a6 <__udivdi3+0x46>
  80276f:	90                   	nop

00802770 <__umoddi3>:
  802770:	55                   	push   %ebp
  802771:	57                   	push   %edi
  802772:	56                   	push   %esi
  802773:	53                   	push   %ebx
  802774:	83 ec 1c             	sub    $0x1c,%esp
  802777:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80277b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80277f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802783:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802787:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80278b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80278f:	89 f3                	mov    %esi,%ebx
  802791:	89 fa                	mov    %edi,%edx
  802793:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802797:	89 34 24             	mov    %esi,(%esp)
  80279a:	85 c0                	test   %eax,%eax
  80279c:	75 1a                	jne    8027b8 <__umoddi3+0x48>
  80279e:	39 f7                	cmp    %esi,%edi
  8027a0:	0f 86 a2 00 00 00    	jbe    802848 <__umoddi3+0xd8>
  8027a6:	89 c8                	mov    %ecx,%eax
  8027a8:	89 f2                	mov    %esi,%edx
  8027aa:	f7 f7                	div    %edi
  8027ac:	89 d0                	mov    %edx,%eax
  8027ae:	31 d2                	xor    %edx,%edx
  8027b0:	83 c4 1c             	add    $0x1c,%esp
  8027b3:	5b                   	pop    %ebx
  8027b4:	5e                   	pop    %esi
  8027b5:	5f                   	pop    %edi
  8027b6:	5d                   	pop    %ebp
  8027b7:	c3                   	ret    
  8027b8:	39 f0                	cmp    %esi,%eax
  8027ba:	0f 87 ac 00 00 00    	ja     80286c <__umoddi3+0xfc>
  8027c0:	0f bd e8             	bsr    %eax,%ebp
  8027c3:	83 f5 1f             	xor    $0x1f,%ebp
  8027c6:	0f 84 ac 00 00 00    	je     802878 <__umoddi3+0x108>
  8027cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8027d1:	29 ef                	sub    %ebp,%edi
  8027d3:	89 fe                	mov    %edi,%esi
  8027d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027d9:	89 e9                	mov    %ebp,%ecx
  8027db:	d3 e0                	shl    %cl,%eax
  8027dd:	89 d7                	mov    %edx,%edi
  8027df:	89 f1                	mov    %esi,%ecx
  8027e1:	d3 ef                	shr    %cl,%edi
  8027e3:	09 c7                	or     %eax,%edi
  8027e5:	89 e9                	mov    %ebp,%ecx
  8027e7:	d3 e2                	shl    %cl,%edx
  8027e9:	89 14 24             	mov    %edx,(%esp)
  8027ec:	89 d8                	mov    %ebx,%eax
  8027ee:	d3 e0                	shl    %cl,%eax
  8027f0:	89 c2                	mov    %eax,%edx
  8027f2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027f6:	d3 e0                	shl    %cl,%eax
  8027f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027fc:	8b 44 24 08          	mov    0x8(%esp),%eax
  802800:	89 f1                	mov    %esi,%ecx
  802802:	d3 e8                	shr    %cl,%eax
  802804:	09 d0                	or     %edx,%eax
  802806:	d3 eb                	shr    %cl,%ebx
  802808:	89 da                	mov    %ebx,%edx
  80280a:	f7 f7                	div    %edi
  80280c:	89 d3                	mov    %edx,%ebx
  80280e:	f7 24 24             	mull   (%esp)
  802811:	89 c6                	mov    %eax,%esi
  802813:	89 d1                	mov    %edx,%ecx
  802815:	39 d3                	cmp    %edx,%ebx
  802817:	0f 82 87 00 00 00    	jb     8028a4 <__umoddi3+0x134>
  80281d:	0f 84 91 00 00 00    	je     8028b4 <__umoddi3+0x144>
  802823:	8b 54 24 04          	mov    0x4(%esp),%edx
  802827:	29 f2                	sub    %esi,%edx
  802829:	19 cb                	sbb    %ecx,%ebx
  80282b:	89 d8                	mov    %ebx,%eax
  80282d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802831:	d3 e0                	shl    %cl,%eax
  802833:	89 e9                	mov    %ebp,%ecx
  802835:	d3 ea                	shr    %cl,%edx
  802837:	09 d0                	or     %edx,%eax
  802839:	89 e9                	mov    %ebp,%ecx
  80283b:	d3 eb                	shr    %cl,%ebx
  80283d:	89 da                	mov    %ebx,%edx
  80283f:	83 c4 1c             	add    $0x1c,%esp
  802842:	5b                   	pop    %ebx
  802843:	5e                   	pop    %esi
  802844:	5f                   	pop    %edi
  802845:	5d                   	pop    %ebp
  802846:	c3                   	ret    
  802847:	90                   	nop
  802848:	89 fd                	mov    %edi,%ebp
  80284a:	85 ff                	test   %edi,%edi
  80284c:	75 0b                	jne    802859 <__umoddi3+0xe9>
  80284e:	b8 01 00 00 00       	mov    $0x1,%eax
  802853:	31 d2                	xor    %edx,%edx
  802855:	f7 f7                	div    %edi
  802857:	89 c5                	mov    %eax,%ebp
  802859:	89 f0                	mov    %esi,%eax
  80285b:	31 d2                	xor    %edx,%edx
  80285d:	f7 f5                	div    %ebp
  80285f:	89 c8                	mov    %ecx,%eax
  802861:	f7 f5                	div    %ebp
  802863:	89 d0                	mov    %edx,%eax
  802865:	e9 44 ff ff ff       	jmp    8027ae <__umoddi3+0x3e>
  80286a:	66 90                	xchg   %ax,%ax
  80286c:	89 c8                	mov    %ecx,%eax
  80286e:	89 f2                	mov    %esi,%edx
  802870:	83 c4 1c             	add    $0x1c,%esp
  802873:	5b                   	pop    %ebx
  802874:	5e                   	pop    %esi
  802875:	5f                   	pop    %edi
  802876:	5d                   	pop    %ebp
  802877:	c3                   	ret    
  802878:	3b 04 24             	cmp    (%esp),%eax
  80287b:	72 06                	jb     802883 <__umoddi3+0x113>
  80287d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802881:	77 0f                	ja     802892 <__umoddi3+0x122>
  802883:	89 f2                	mov    %esi,%edx
  802885:	29 f9                	sub    %edi,%ecx
  802887:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80288b:	89 14 24             	mov    %edx,(%esp)
  80288e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802892:	8b 44 24 04          	mov    0x4(%esp),%eax
  802896:	8b 14 24             	mov    (%esp),%edx
  802899:	83 c4 1c             	add    $0x1c,%esp
  80289c:	5b                   	pop    %ebx
  80289d:	5e                   	pop    %esi
  80289e:	5f                   	pop    %edi
  80289f:	5d                   	pop    %ebp
  8028a0:	c3                   	ret    
  8028a1:	8d 76 00             	lea    0x0(%esi),%esi
  8028a4:	2b 04 24             	sub    (%esp),%eax
  8028a7:	19 fa                	sbb    %edi,%edx
  8028a9:	89 d1                	mov    %edx,%ecx
  8028ab:	89 c6                	mov    %eax,%esi
  8028ad:	e9 71 ff ff ff       	jmp    802823 <__umoddi3+0xb3>
  8028b2:	66 90                	xchg   %ax,%ax
  8028b4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8028b8:	72 ea                	jb     8028a4 <__umoddi3+0x134>
  8028ba:	89 d9                	mov    %ebx,%ecx
  8028bc:	e9 62 ff ff ff       	jmp    802823 <__umoddi3+0xb3>
