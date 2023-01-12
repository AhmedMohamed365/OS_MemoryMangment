
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 f7 04 00 00       	call   80052d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 80 1b 00 00       	call   801bc3 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 aa 1b 00 00       	call   801bf5 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80004e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800055:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e0 25 80 00       	push   $0x8025e0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 21 1a 00 00       	call   801a8d <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e4 25 80 00       	push   $0x8025e4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 0b 1a 00 00       	call   801a8d <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 ec 25 80 00       	push   $0x8025ec
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 ee 19 00 00       	call   801a8d <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 fa 25 80 00       	push   $0x8025fa
  8000b8:	e8 ad 19 00 00       	call   801a6a <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		tmpArray[i] = sharedArray[i];
  8000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	01 c2                	add    %eax,%edx
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e8:	01 c8                	add    %ecx,%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	89 02                	mov    %eax,(%edx)

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	8d 55 b4             	lea    -0x4c(%ebp),%edx
  800106:	52                   	push   %edx
  800107:	8d 55 b8             	lea    -0x48(%ebp),%edx
  80010a:	52                   	push   %edx
  80010b:	8d 55 bc             	lea    -0x44(%ebp),%edx
  80010e:	52                   	push   %edx
  80010f:	8d 55 c0             	lea    -0x40(%ebp),%edx
  800112:	52                   	push   %edx
  800113:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800116:	52                   	push   %edx
  800117:	50                   	push   %eax
  800118:	ff 75 dc             	pushl  -0x24(%ebp)
  80011b:	e8 55 02 00 00       	call   800375 <ArrayStats>
  800120:	83 c4 20             	add    $0x20,%esp
	cprintf("Stats Calculations are Finished!!!!\n") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 04 26 80 00       	push   $0x802604
  80012b:	e8 16 06 00 00       	call   800746 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 29 26 80 00       	push   $0x802629
  80013f:	e8 26 19 00 00       	call   801a6a <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 2e 26 80 00       	push   $0x80262e
  80015e:	e8 07 19 00 00       	call   801a6a <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 32 26 80 00       	push   $0x802632
  80017d:	e8 e8 18 00 00       	call   801a6a <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 36 26 80 00       	push   $0x802636
  80019c:	e8 c9 18 00 00       	call   801a6a <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 3a 26 80 00       	push   $0x80263a
  8001bb:	e8 aa 18 00 00       	call   801a6a <smalloc>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001c6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001cc:	89 10                	mov    %edx,(%eax)

	(*finishedCount)++ ;
  8001ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d1:	8b 00                	mov    (%eax),%eax
  8001d3:	8d 50 01             	lea    0x1(%eax),%edx
  8001d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)

}
  8001db:	90                   	nop
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  8001e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8001ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ed:	48                   	dec    %eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	52                   	push   %edx
  8001f2:	50                   	push   %eax
  8001f3:	6a 00                	push   $0x0
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 05 00 00 00       	call   800205 <QSort>
  800200:	83 c4 20             	add    $0x20,%esp
}
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  80020b:	8b 45 10             	mov    0x10(%ebp),%eax
  80020e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800211:	7c 16                	jl     800229 <QSort+0x24>
  800213:	8b 45 14             	mov    0x14(%ebp),%eax
  800216:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021d:	8b 45 08             	mov    0x8(%ebp),%eax
  800220:	01 d0                	add    %edx,%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	e9 4a 01 00 00       	jmp    800373 <QSort+0x16e>

	int pvtIndex = RAND(startIndex, finalIndex) ;
  800229:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	e8 1d 1d 00 00       	call   801f52 <sys_get_virtual_time>
  800235:	83 c4 0c             	add    $0xc,%esp
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 55 14             	mov    0x14(%ebp),%edx
  80023e:	2b 55 10             	sub    0x10(%ebp),%edx
  800241:	89 d1                	mov    %edx,%ecx
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 f1                	div    %ecx
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	ff 75 ec             	pushl  -0x14(%ebp)
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	e8 77 02 00 00       	call   8004da <Swap>
  800263:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  800266:	8b 45 10             	mov    0x10(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80026d:	8b 45 14             	mov    0x14(%ebp),%eax
  800270:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800273:	e9 80 00 00 00       	jmp    8002f8 <QSort+0xf3>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800278:	ff 45 f4             	incl   -0xc(%ebp)
  80027b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	7f 2b                	jg     8002ae <QSort+0xa9>
  800283:	8b 45 10             	mov    0x10(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 10                	mov    (%eax),%edx
  800294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800297:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	01 c8                	add    %ecx,%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	39 c2                	cmp    %eax,%edx
  8002a7:	7d cf                	jge    800278 <QSort+0x73>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002a9:	eb 03                	jmp    8002ae <QSort+0xa9>
  8002ab:	ff 4d f0             	decl   -0x10(%ebp)
  8002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002b4:	7e 26                	jle    8002dc <QSort+0xd7>
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 c8                	add    %ecx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	7e cf                	jle    8002ab <QSort+0xa6>

		if (i <= j)
  8002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e2:	7f 14                	jg     8002f8 <QSort+0xf3>
		{
			Swap(Elements, i, j);
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8002ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	e8 e5 01 00 00       	call   8004da <Swap>
  8002f5:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fe:	0f 8e 77 ff ff ff    	jle    80027b <QSort+0x76>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 f0             	pushl  -0x10(%ebp)
  80030a:	ff 75 10             	pushl  0x10(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 c5 01 00 00       	call   8004da <Swap>
  800315:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  800318:	8b 45 18             	mov    0x18(%ebp),%eax
  80031b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031e:	75 13                	jne    800333 <QSort+0x12e>
		return Elements[kIndex] ;
  800320:	8b 45 18             	mov    0x18(%ebp),%eax
  800323:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	eb 40                	jmp    800373 <QSort+0x16e>
	else if (kIndex < j)
  800333:	8b 45 18             	mov    0x18(%ebp),%eax
  800336:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800339:	7d 1e                	jge    800359 <QSort+0x154>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  80033b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033e:	48                   	dec    %eax
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 18             	pushl  0x18(%ebp)
  800345:	50                   	push   %eax
  800346:	ff 75 10             	pushl  0x10(%ebp)
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 b1 fe ff ff       	call   800205 <QSort>
  800354:	83 c4 20             	add    $0x20,%esp
  800357:	eb 1a                	jmp    800373 <QSort+0x16e>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 18             	pushl  0x18(%ebp)
  80035f:	ff 75 14             	pushl  0x14(%ebp)
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	ff 75 0c             	pushl  0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 95 fe ff ff       	call   800205 <QSort>
  800370:	83 c4 20             	add    $0x20,%esp
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	53                   	push   %ebx
  800379:	83 ec 14             	sub    $0x14,%esp
	int i ;
	*mean =0 ;
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*min = 0x7FFFFFFF ;
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  80038e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800391:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80039e:	e9 80 00 00 00       	jmp    800423 <ArrayStats+0xae>
	{
		(*mean) += Elements[i];
  8003a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a6:	8b 10                	mov    (%eax),%edx
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	01 c2                	add    %eax,%edx
  8003bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003be:	89 10                	mov    %edx,(%eax)
		if (Elements[i] < (*min))
  8003c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	8b 10                	mov    (%eax),%edx
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	7d 16                	jge    8003f0 <ArrayStats+0x7b>
		{
			(*min) = Elements[i];
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8003f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	8b 10                	mov    (%eax),%edx
  800401:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	7e 16                	jle    800420 <ArrayStats+0xab>
		{
			(*max) = Elements[i];
  80040a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	01 d0                	add    %edx,%eax
  800419:	8b 10                	mov    (%eax),%edx
  80041b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 f4             	incl   -0xc(%ebp)
  800423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	0f 8c 74 ff ff ff    	jl     8003a3 <ArrayStats+0x2e>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);
  80042f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800432:	89 c2                	mov    %eax,%edx
  800434:	c1 ea 1f             	shr    $0x1f,%edx
  800437:	01 d0                	add    %edx,%eax
  800439:	d1 f8                	sar    %eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	50                   	push   %eax
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 08             	pushl  0x8(%ebp)
  800445:	e8 94 fd ff ff       	call   8001de <KthElement>
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	8b 45 20             	mov    0x20(%ebp),%eax
  800452:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800454:	8b 45 10             	mov    0x10(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	99                   	cltd   
  80045a:	f7 7d 0c             	idivl  0xc(%ebp)
  80045d:	89 c2                	mov    %eax,%edx
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
	(*var) = 0;
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80046d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800474:	eb 46                	jmp    8004bc <ArrayStats+0x147>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c8                	add    %ecx,%eax
  80048a:	8b 08                	mov    (%eax),%ecx
  80048c:	8b 45 10             	mov    0x10(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	89 cb                	mov    %ecx,%ebx
  800493:	29 c3                	sub    %eax,%ebx
  800495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800498:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 08                	mov    (%eax),%ecx
  8004a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	29 c1                	sub    %eax,%ecx
  8004ad:	89 c8                	mov    %ecx,%eax
  8004af:	0f af c3             	imul   %ebx,%eax
  8004b2:	01 c2                	add    %eax,%edx
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b9:	ff 45 f4             	incl   -0xc(%ebp)
  8004bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004c2:	7c b2                	jl     800476 <ArrayStats+0x101>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
	}
	(*var) /= NumOfElements;
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	f7 7d 0c             	idivl  0xc(%ebp)
  8004cd:	89 c2                	mov    %eax,%edx
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
}
  8004d4:	90                   	nop
  8004d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	01 c2                	add    %eax,%edx
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	01 c8                	add    %ecx,%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800516:	8b 45 10             	mov    0x10(%ebp),%eax
  800519:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	01 c2                	add    %eax,%edx
  800525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800528:	89 02                	mov    %eax,(%edx)
}
  80052a:	90                   	nop
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800533:	e8 a4 16 00 00       	call   801bdc <sys_getenvindex>
  800538:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80053b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	c1 e0 03             	shl    $0x3,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80054c:	01 c8                	add    %ecx,%eax
  80054e:	01 c0                	add    %eax,%eax
  800550:	01 d0                	add    %edx,%eax
  800552:	01 c0                	add    %eax,%eax
  800554:	01 d0                	add    %edx,%eax
  800556:	89 c2                	mov    %eax,%edx
  800558:	c1 e2 05             	shl    $0x5,%edx
  80055b:	29 c2                	sub    %eax,%edx
  80055d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800564:	89 c2                	mov    %eax,%edx
  800566:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80056c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800571:	a1 20 30 80 00       	mov    0x803020,%eax
  800576:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80057c:	84 c0                	test   %al,%al
  80057e:	74 0f                	je     80058f <libmain+0x62>
		binaryname = myEnv->prog_name;
  800580:	a1 20 30 80 00       	mov    0x803020,%eax
  800585:	05 40 3c 01 00       	add    $0x13c40,%eax
  80058a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80058f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800593:	7e 0a                	jle    80059f <libmain+0x72>
		binaryname = argv[0];
  800595:	8b 45 0c             	mov    0xc(%ebp),%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	ff 75 0c             	pushl  0xc(%ebp)
  8005a5:	ff 75 08             	pushl  0x8(%ebp)
  8005a8:	e8 8b fa ff ff       	call   800038 <_main>
  8005ad:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005b0:	e8 c2 17 00 00       	call   801d77 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005b5:	83 ec 0c             	sub    $0xc,%esp
  8005b8:	68 58 26 80 00       	push   $0x802658
  8005bd:	e8 84 01 00 00       	call   800746 <cprintf>
  8005c2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ca:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8005d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8005d5:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8005db:	83 ec 04             	sub    $0x4,%esp
  8005de:	52                   	push   %edx
  8005df:	50                   	push   %eax
  8005e0:	68 80 26 80 00       	push   $0x802680
  8005e5:	e8 5c 01 00 00       	call   800746 <cprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8005ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f2:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8005f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fd:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800603:	83 ec 04             	sub    $0x4,%esp
  800606:	52                   	push   %edx
  800607:	50                   	push   %eax
  800608:	68 a8 26 80 00       	push   $0x8026a8
  80060d:	e8 34 01 00 00       	call   800746 <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800615:	a1 20 30 80 00       	mov    0x803020,%eax
  80061a:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	50                   	push   %eax
  800624:	68 e9 26 80 00       	push   $0x8026e9
  800629:	e8 18 01 00 00       	call   800746 <cprintf>
  80062e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800631:	83 ec 0c             	sub    $0xc,%esp
  800634:	68 58 26 80 00       	push   $0x802658
  800639:	e8 08 01 00 00       	call   800746 <cprintf>
  80063e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800641:	e8 4b 17 00 00       	call   801d91 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800646:	e8 19 00 00 00       	call   800664 <exit>
}
  80064b:	90                   	nop
  80064c:	c9                   	leave  
  80064d:	c3                   	ret    

0080064e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80064e:	55                   	push   %ebp
  80064f:	89 e5                	mov    %esp,%ebp
  800651:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800654:	83 ec 0c             	sub    $0xc,%esp
  800657:	6a 00                	push   $0x0
  800659:	e8 4a 15 00 00       	call   801ba8 <sys_env_destroy>
  80065e:	83 c4 10             	add    $0x10,%esp
}
  800661:	90                   	nop
  800662:	c9                   	leave  
  800663:	c3                   	ret    

00800664 <exit>:

void
exit(void)
{
  800664:	55                   	push   %ebp
  800665:	89 e5                	mov    %esp,%ebp
  800667:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80066a:	e8 9f 15 00 00       	call   801c0e <sys_env_exit>
}
  80066f:	90                   	nop
  800670:	c9                   	leave  
  800671:	c3                   	ret    

00800672 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800672:	55                   	push   %ebp
  800673:	89 e5                	mov    %esp,%ebp
  800675:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800678:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	8d 48 01             	lea    0x1(%eax),%ecx
  800680:	8b 55 0c             	mov    0xc(%ebp),%edx
  800683:	89 0a                	mov    %ecx,(%edx)
  800685:	8b 55 08             	mov    0x8(%ebp),%edx
  800688:	88 d1                	mov    %dl,%cl
  80068a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800691:	8b 45 0c             	mov    0xc(%ebp),%eax
  800694:	8b 00                	mov    (%eax),%eax
  800696:	3d ff 00 00 00       	cmp    $0xff,%eax
  80069b:	75 2c                	jne    8006c9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80069d:	a0 24 30 80 00       	mov    0x803024,%al
  8006a2:	0f b6 c0             	movzbl %al,%eax
  8006a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a8:	8b 12                	mov    (%edx),%edx
  8006aa:	89 d1                	mov    %edx,%ecx
  8006ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006af:	83 c2 08             	add    $0x8,%edx
  8006b2:	83 ec 04             	sub    $0x4,%esp
  8006b5:	50                   	push   %eax
  8006b6:	51                   	push   %ecx
  8006b7:	52                   	push   %edx
  8006b8:	e8 a9 14 00 00       	call   801b66 <sys_cputs>
  8006bd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cc:	8b 40 04             	mov    0x4(%eax),%eax
  8006cf:	8d 50 01             	lea    0x1(%eax),%edx
  8006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006d8:	90                   	nop
  8006d9:	c9                   	leave  
  8006da:	c3                   	ret    

008006db <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006db:	55                   	push   %ebp
  8006dc:	89 e5                	mov    %esp,%ebp
  8006de:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006e4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006eb:	00 00 00 
	b.cnt = 0;
  8006ee:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006f5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006f8:	ff 75 0c             	pushl  0xc(%ebp)
  8006fb:	ff 75 08             	pushl  0x8(%ebp)
  8006fe:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800704:	50                   	push   %eax
  800705:	68 72 06 80 00       	push   $0x800672
  80070a:	e8 11 02 00 00       	call   800920 <vprintfmt>
  80070f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800712:	a0 24 30 80 00       	mov    0x803024,%al
  800717:	0f b6 c0             	movzbl %al,%eax
  80071a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800720:	83 ec 04             	sub    $0x4,%esp
  800723:	50                   	push   %eax
  800724:	52                   	push   %edx
  800725:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072b:	83 c0 08             	add    $0x8,%eax
  80072e:	50                   	push   %eax
  80072f:	e8 32 14 00 00       	call   801b66 <sys_cputs>
  800734:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800737:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80073e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <cprintf>:

int cprintf(const char *fmt, ...) {
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80074c:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800753:	8d 45 0c             	lea    0xc(%ebp),%eax
  800756:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 f4             	pushl  -0xc(%ebp)
  800762:	50                   	push   %eax
  800763:	e8 73 ff ff ff       	call   8006db <vcprintf>
  800768:	83 c4 10             	add    $0x10,%esp
  80076b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80076e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800771:	c9                   	leave  
  800772:	c3                   	ret    

00800773 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800773:	55                   	push   %ebp
  800774:	89 e5                	mov    %esp,%ebp
  800776:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800779:	e8 f9 15 00 00       	call   801d77 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80077e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 f4             	pushl  -0xc(%ebp)
  80078d:	50                   	push   %eax
  80078e:	e8 48 ff ff ff       	call   8006db <vcprintf>
  800793:	83 c4 10             	add    $0x10,%esp
  800796:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800799:	e8 f3 15 00 00       	call   801d91 <sys_enable_interrupt>
	return cnt;
  80079e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a1:	c9                   	leave  
  8007a2:	c3                   	ret    

008007a3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	53                   	push   %ebx
  8007a7:	83 ec 14             	sub    $0x14,%esp
  8007aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007b6:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007be:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c1:	77 55                	ja     800818 <printnum+0x75>
  8007c3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c6:	72 05                	jb     8007cd <printnum+0x2a>
  8007c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007cb:	77 4b                	ja     800818 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007cd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007d0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8007d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007db:	52                   	push   %edx
  8007dc:	50                   	push   %eax
  8007dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8007e3:	e8 80 1b 00 00       	call   802368 <__udivdi3>
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	83 ec 04             	sub    $0x4,%esp
  8007ee:	ff 75 20             	pushl  0x20(%ebp)
  8007f1:	53                   	push   %ebx
  8007f2:	ff 75 18             	pushl  0x18(%ebp)
  8007f5:	52                   	push   %edx
  8007f6:	50                   	push   %eax
  8007f7:	ff 75 0c             	pushl  0xc(%ebp)
  8007fa:	ff 75 08             	pushl  0x8(%ebp)
  8007fd:	e8 a1 ff ff ff       	call   8007a3 <printnum>
  800802:	83 c4 20             	add    $0x20,%esp
  800805:	eb 1a                	jmp    800821 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	ff 75 0c             	pushl  0xc(%ebp)
  80080d:	ff 75 20             	pushl  0x20(%ebp)
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	ff d0                	call   *%eax
  800815:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800818:	ff 4d 1c             	decl   0x1c(%ebp)
  80081b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80081f:	7f e6                	jg     800807 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800821:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800824:	bb 00 00 00 00       	mov    $0x0,%ebx
  800829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80082f:	53                   	push   %ebx
  800830:	51                   	push   %ecx
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	e8 40 1c 00 00       	call   802478 <__umoddi3>
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	05 14 29 80 00       	add    $0x802914,%eax
  800840:	8a 00                	mov    (%eax),%al
  800842:	0f be c0             	movsbl %al,%eax
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	50                   	push   %eax
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	ff d0                	call   *%eax
  800851:	83 c4 10             	add    $0x10,%esp
}
  800854:	90                   	nop
  800855:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800858:	c9                   	leave  
  800859:	c3                   	ret    

0080085a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80085d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800861:	7e 1c                	jle    80087f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	8d 50 08             	lea    0x8(%eax),%edx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	89 10                	mov    %edx,(%eax)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	83 e8 08             	sub    $0x8,%eax
  800878:	8b 50 04             	mov    0x4(%eax),%edx
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	eb 40                	jmp    8008bf <getuint+0x65>
	else if (lflag)
  80087f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800883:	74 1e                	je     8008a3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	8d 50 04             	lea    0x4(%eax),%edx
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	89 10                	mov    %edx,(%eax)
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a1:	eb 1c                	jmp    8008bf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	8b 00                	mov    (%eax),%eax
  8008a8:	8d 50 04             	lea    0x4(%eax),%edx
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	89 10                	mov    %edx,(%eax)
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	8b 00                	mov    (%eax),%eax
  8008b5:	83 e8 04             	sub    $0x4,%eax
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008bf:	5d                   	pop    %ebp
  8008c0:	c3                   	ret    

008008c1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c8:	7e 1c                	jle    8008e6 <getint+0x25>
		return va_arg(*ap, long long);
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	8d 50 08             	lea    0x8(%eax),%edx
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	89 10                	mov    %edx,(%eax)
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	83 e8 08             	sub    $0x8,%eax
  8008df:	8b 50 04             	mov    0x4(%eax),%edx
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	eb 38                	jmp    80091e <getint+0x5d>
	else if (lflag)
  8008e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ea:	74 1a                	je     800906 <getint+0x45>
		return va_arg(*ap, long);
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	8d 50 04             	lea    0x4(%eax),%edx
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	89 10                	mov    %edx,(%eax)
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	83 e8 04             	sub    $0x4,%eax
  800901:	8b 00                	mov    (%eax),%eax
  800903:	99                   	cltd   
  800904:	eb 18                	jmp    80091e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	8d 50 04             	lea    0x4(%eax),%edx
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	89 10                	mov    %edx,(%eax)
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	83 e8 04             	sub    $0x4,%eax
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	99                   	cltd   
}
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	56                   	push   %esi
  800924:	53                   	push   %ebx
  800925:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800928:	eb 17                	jmp    800941 <vprintfmt+0x21>
			if (ch == '\0')
  80092a:	85 db                	test   %ebx,%ebx
  80092c:	0f 84 af 03 00 00    	je     800ce1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	53                   	push   %ebx
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	ff d0                	call   *%eax
  80093e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800941:	8b 45 10             	mov    0x10(%ebp),%eax
  800944:	8d 50 01             	lea    0x1(%eax),%edx
  800947:	89 55 10             	mov    %edx,0x10(%ebp)
  80094a:	8a 00                	mov    (%eax),%al
  80094c:	0f b6 d8             	movzbl %al,%ebx
  80094f:	83 fb 25             	cmp    $0x25,%ebx
  800952:	75 d6                	jne    80092a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800954:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800958:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80095f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800966:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80096d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800974:	8b 45 10             	mov    0x10(%ebp),%eax
  800977:	8d 50 01             	lea    0x1(%eax),%edx
  80097a:	89 55 10             	mov    %edx,0x10(%ebp)
  80097d:	8a 00                	mov    (%eax),%al
  80097f:	0f b6 d8             	movzbl %al,%ebx
  800982:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800985:	83 f8 55             	cmp    $0x55,%eax
  800988:	0f 87 2b 03 00 00    	ja     800cb9 <vprintfmt+0x399>
  80098e:	8b 04 85 38 29 80 00 	mov    0x802938(,%eax,4),%eax
  800995:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800997:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80099b:	eb d7                	jmp    800974 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80099d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009a1:	eb d1                	jmp    800974 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009ad:	89 d0                	mov    %edx,%eax
  8009af:	c1 e0 02             	shl    $0x2,%eax
  8009b2:	01 d0                	add    %edx,%eax
  8009b4:	01 c0                	add    %eax,%eax
  8009b6:	01 d8                	add    %ebx,%eax
  8009b8:	83 e8 30             	sub    $0x30,%eax
  8009bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009be:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009c6:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c9:	7e 3e                	jle    800a09 <vprintfmt+0xe9>
  8009cb:	83 fb 39             	cmp    $0x39,%ebx
  8009ce:	7f 39                	jg     800a09 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009d3:	eb d5                	jmp    8009aa <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 c0 04             	add    $0x4,%eax
  8009db:	89 45 14             	mov    %eax,0x14(%ebp)
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	83 e8 04             	sub    $0x4,%eax
  8009e4:	8b 00                	mov    (%eax),%eax
  8009e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e9:	eb 1f                	jmp    800a0a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ef:	79 83                	jns    800974 <vprintfmt+0x54>
				width = 0;
  8009f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009f8:	e9 77 ff ff ff       	jmp    800974 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009fd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a04:	e9 6b ff ff ff       	jmp    800974 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a09:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a0e:	0f 89 60 ff ff ff    	jns    800974 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a1a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a21:	e9 4e ff ff ff       	jmp    800974 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a26:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a29:	e9 46 ff ff ff       	jmp    800974 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 c0 04             	add    $0x4,%eax
  800a34:	89 45 14             	mov    %eax,0x14(%ebp)
  800a37:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3a:	83 e8 04             	sub    $0x4,%eax
  800a3d:	8b 00                	mov    (%eax),%eax
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	ff 75 0c             	pushl  0xc(%ebp)
  800a45:	50                   	push   %eax
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	ff d0                	call   *%eax
  800a4b:	83 c4 10             	add    $0x10,%esp
			break;
  800a4e:	e9 89 02 00 00       	jmp    800cdc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	83 c0 04             	add    $0x4,%eax
  800a59:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5f:	83 e8 04             	sub    $0x4,%eax
  800a62:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a64:	85 db                	test   %ebx,%ebx
  800a66:	79 02                	jns    800a6a <vprintfmt+0x14a>
				err = -err;
  800a68:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a6a:	83 fb 64             	cmp    $0x64,%ebx
  800a6d:	7f 0b                	jg     800a7a <vprintfmt+0x15a>
  800a6f:	8b 34 9d 80 27 80 00 	mov    0x802780(,%ebx,4),%esi
  800a76:	85 f6                	test   %esi,%esi
  800a78:	75 19                	jne    800a93 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a7a:	53                   	push   %ebx
  800a7b:	68 25 29 80 00       	push   $0x802925
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	ff 75 08             	pushl  0x8(%ebp)
  800a86:	e8 5e 02 00 00       	call   800ce9 <printfmt>
  800a8b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a8e:	e9 49 02 00 00       	jmp    800cdc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a93:	56                   	push   %esi
  800a94:	68 2e 29 80 00       	push   $0x80292e
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	ff 75 08             	pushl  0x8(%ebp)
  800a9f:	e8 45 02 00 00       	call   800ce9 <printfmt>
  800aa4:	83 c4 10             	add    $0x10,%esp
			break;
  800aa7:	e9 30 02 00 00       	jmp    800cdc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	83 c0 04             	add    $0x4,%eax
  800ab2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab8:	83 e8 04             	sub    $0x4,%eax
  800abb:	8b 30                	mov    (%eax),%esi
  800abd:	85 f6                	test   %esi,%esi
  800abf:	75 05                	jne    800ac6 <vprintfmt+0x1a6>
				p = "(null)";
  800ac1:	be 31 29 80 00       	mov    $0x802931,%esi
			if (width > 0 && padc != '-')
  800ac6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aca:	7e 6d                	jle    800b39 <vprintfmt+0x219>
  800acc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ad0:	74 67                	je     800b39 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	50                   	push   %eax
  800ad9:	56                   	push   %esi
  800ada:	e8 0c 03 00 00       	call   800deb <strnlen>
  800adf:	83 c4 10             	add    $0x10,%esp
  800ae2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ae5:	eb 16                	jmp    800afd <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ae7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	50                   	push   %eax
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	ff d0                	call   *%eax
  800af7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800afa:	ff 4d e4             	decl   -0x1c(%ebp)
  800afd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b01:	7f e4                	jg     800ae7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b03:	eb 34                	jmp    800b39 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b05:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b09:	74 1c                	je     800b27 <vprintfmt+0x207>
  800b0b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b0e:	7e 05                	jle    800b15 <vprintfmt+0x1f5>
  800b10:	83 fb 7e             	cmp    $0x7e,%ebx
  800b13:	7e 12                	jle    800b27 <vprintfmt+0x207>
					putch('?', putdat);
  800b15:	83 ec 08             	sub    $0x8,%esp
  800b18:	ff 75 0c             	pushl  0xc(%ebp)
  800b1b:	6a 3f                	push   $0x3f
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	ff d0                	call   *%eax
  800b22:	83 c4 10             	add    $0x10,%esp
  800b25:	eb 0f                	jmp    800b36 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	53                   	push   %ebx
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	ff d0                	call   *%eax
  800b33:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b36:	ff 4d e4             	decl   -0x1c(%ebp)
  800b39:	89 f0                	mov    %esi,%eax
  800b3b:	8d 70 01             	lea    0x1(%eax),%esi
  800b3e:	8a 00                	mov    (%eax),%al
  800b40:	0f be d8             	movsbl %al,%ebx
  800b43:	85 db                	test   %ebx,%ebx
  800b45:	74 24                	je     800b6b <vprintfmt+0x24b>
  800b47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4b:	78 b8                	js     800b05 <vprintfmt+0x1e5>
  800b4d:	ff 4d e0             	decl   -0x20(%ebp)
  800b50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b54:	79 af                	jns    800b05 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b56:	eb 13                	jmp    800b6b <vprintfmt+0x24b>
				putch(' ', putdat);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	6a 20                	push   $0x20
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	ff d0                	call   *%eax
  800b65:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b68:	ff 4d e4             	decl   -0x1c(%ebp)
  800b6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6f:	7f e7                	jg     800b58 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b71:	e9 66 01 00 00       	jmp    800cdc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b76:	83 ec 08             	sub    $0x8,%esp
  800b79:	ff 75 e8             	pushl  -0x18(%ebp)
  800b7c:	8d 45 14             	lea    0x14(%ebp),%eax
  800b7f:	50                   	push   %eax
  800b80:	e8 3c fd ff ff       	call   8008c1 <getint>
  800b85:	83 c4 10             	add    $0x10,%esp
  800b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b94:	85 d2                	test   %edx,%edx
  800b96:	79 23                	jns    800bbb <vprintfmt+0x29b>
				putch('-', putdat);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	6a 2d                	push   $0x2d
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	ff d0                	call   *%eax
  800ba5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bae:	f7 d8                	neg    %eax
  800bb0:	83 d2 00             	adc    $0x0,%edx
  800bb3:	f7 da                	neg    %edx
  800bb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bbb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bc2:	e9 bc 00 00 00       	jmp    800c83 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 e8             	pushl  -0x18(%ebp)
  800bcd:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd0:	50                   	push   %eax
  800bd1:	e8 84 fc ff ff       	call   80085a <getuint>
  800bd6:	83 c4 10             	add    $0x10,%esp
  800bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bdf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800be6:	e9 98 00 00 00       	jmp    800c83 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800beb:	83 ec 08             	sub    $0x8,%esp
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	6a 58                	push   $0x58
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	ff d0                	call   *%eax
  800bf8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bfb:	83 ec 08             	sub    $0x8,%esp
  800bfe:	ff 75 0c             	pushl  0xc(%ebp)
  800c01:	6a 58                	push   $0x58
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	ff d0                	call   *%eax
  800c08:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 0c             	pushl  0xc(%ebp)
  800c11:	6a 58                	push   $0x58
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	ff d0                	call   *%eax
  800c18:	83 c4 10             	add    $0x10,%esp
			break;
  800c1b:	e9 bc 00 00 00       	jmp    800cdc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	6a 30                	push   $0x30
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c30:	83 ec 08             	sub    $0x8,%esp
  800c33:	ff 75 0c             	pushl  0xc(%ebp)
  800c36:	6a 78                	push   $0x78
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	ff d0                	call   *%eax
  800c3d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c40:	8b 45 14             	mov    0x14(%ebp),%eax
  800c43:	83 c0 04             	add    $0x4,%eax
  800c46:	89 45 14             	mov    %eax,0x14(%ebp)
  800c49:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4c:	83 e8 04             	sub    $0x4,%eax
  800c4f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c62:	eb 1f                	jmp    800c83 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 e8             	pushl  -0x18(%ebp)
  800c6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c6d:	50                   	push   %eax
  800c6e:	e8 e7 fb ff ff       	call   80085a <getuint>
  800c73:	83 c4 10             	add    $0x10,%esp
  800c76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c83:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c8a:	83 ec 04             	sub    $0x4,%esp
  800c8d:	52                   	push   %edx
  800c8e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c91:	50                   	push   %eax
  800c92:	ff 75 f4             	pushl  -0xc(%ebp)
  800c95:	ff 75 f0             	pushl  -0x10(%ebp)
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	ff 75 08             	pushl  0x8(%ebp)
  800c9e:	e8 00 fb ff ff       	call   8007a3 <printnum>
  800ca3:	83 c4 20             	add    $0x20,%esp
			break;
  800ca6:	eb 34                	jmp    800cdc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 0c             	pushl  0xc(%ebp)
  800cae:	53                   	push   %ebx
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	ff d0                	call   *%eax
  800cb4:	83 c4 10             	add    $0x10,%esp
			break;
  800cb7:	eb 23                	jmp    800cdc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cb9:	83 ec 08             	sub    $0x8,%esp
  800cbc:	ff 75 0c             	pushl  0xc(%ebp)
  800cbf:	6a 25                	push   $0x25
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	ff d0                	call   *%eax
  800cc6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc9:	ff 4d 10             	decl   0x10(%ebp)
  800ccc:	eb 03                	jmp    800cd1 <vprintfmt+0x3b1>
  800cce:	ff 4d 10             	decl   0x10(%ebp)
  800cd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd4:	48                   	dec    %eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	3c 25                	cmp    $0x25,%al
  800cd9:	75 f3                	jne    800cce <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cdb:	90                   	nop
		}
	}
  800cdc:	e9 47 fc ff ff       	jmp    800928 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ce1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ce2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    

00800ce9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cef:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf2:	83 c0 04             	add    $0x4,%eax
  800cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfe:	50                   	push   %eax
  800cff:	ff 75 0c             	pushl  0xc(%ebp)
  800d02:	ff 75 08             	pushl  0x8(%ebp)
  800d05:	e8 16 fc ff ff       	call   800920 <vprintfmt>
  800d0a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d0d:	90                   	nop
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	8b 40 08             	mov    0x8(%eax),%eax
  800d19:	8d 50 01             	lea    0x1(%eax),%edx
  800d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8b 10                	mov    (%eax),%edx
  800d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2a:	8b 40 04             	mov    0x4(%eax),%eax
  800d2d:	39 c2                	cmp    %eax,%edx
  800d2f:	73 12                	jae    800d43 <sprintputch+0x33>
		*b->buf++ = ch;
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8b 00                	mov    (%eax),%eax
  800d36:	8d 48 01             	lea    0x1(%eax),%ecx
  800d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3c:	89 0a                	mov    %ecx,(%edx)
  800d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d41:	88 10                	mov    %dl,(%eax)
}
  800d43:	90                   	nop
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	01 d0                	add    %edx,%eax
  800d5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d6b:	74 06                	je     800d73 <vsnprintf+0x2d>
  800d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d71:	7f 07                	jg     800d7a <vsnprintf+0x34>
		return -E_INVAL;
  800d73:	b8 03 00 00 00       	mov    $0x3,%eax
  800d78:	eb 20                	jmp    800d9a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d7a:	ff 75 14             	pushl  0x14(%ebp)
  800d7d:	ff 75 10             	pushl  0x10(%ebp)
  800d80:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d83:	50                   	push   %eax
  800d84:	68 10 0d 80 00       	push   $0x800d10
  800d89:	e8 92 fb ff ff       	call   800920 <vprintfmt>
  800d8e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d94:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d9a:	c9                   	leave  
  800d9b:	c3                   	ret    

00800d9c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800da2:	8d 45 10             	lea    0x10(%ebp),%eax
  800da5:	83 c0 04             	add    $0x4,%eax
  800da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dab:	8b 45 10             	mov    0x10(%ebp),%eax
  800dae:	ff 75 f4             	pushl  -0xc(%ebp)
  800db1:	50                   	push   %eax
  800db2:	ff 75 0c             	pushl  0xc(%ebp)
  800db5:	ff 75 08             	pushl  0x8(%ebp)
  800db8:	e8 89 ff ff ff       	call   800d46 <vsnprintf>
  800dbd:	83 c4 10             	add    $0x10,%esp
  800dc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd5:	eb 06                	jmp    800ddd <strlen+0x15>
		n++;
  800dd7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dda:	ff 45 08             	incl   0x8(%ebp)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	84 c0                	test   %al,%al
  800de4:	75 f1                	jne    800dd7 <strlen+0xf>
		n++;
	return n;
  800de6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800df8:	eb 09                	jmp    800e03 <strnlen+0x18>
		n++;
  800dfa:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dfd:	ff 45 08             	incl   0x8(%ebp)
  800e00:	ff 4d 0c             	decl   0xc(%ebp)
  800e03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e07:	74 09                	je     800e12 <strnlen+0x27>
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	84 c0                	test   %al,%al
  800e10:	75 e8                	jne    800dfa <strnlen+0xf>
		n++;
	return n;
  800e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e23:	90                   	nop
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8d 50 01             	lea    0x1(%eax),%edx
  800e2a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e30:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e33:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e36:	8a 12                	mov    (%edx),%dl
  800e38:	88 10                	mov    %dl,(%eax)
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	84 c0                	test   %al,%al
  800e3e:	75 e4                	jne    800e24 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e40:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 1f                	jmp    800e79 <strncpy+0x34>
		*dst++ = *src;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	8d 50 01             	lea    0x1(%eax),%edx
  800e60:	89 55 08             	mov    %edx,0x8(%ebp)
  800e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e66:	8a 12                	mov    (%edx),%dl
  800e68:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	84 c0                	test   %al,%al
  800e71:	74 03                	je     800e76 <strncpy+0x31>
			src++;
  800e73:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e76:	ff 45 fc             	incl   -0x4(%ebp)
  800e79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e7f:	72 d9                	jb     800e5a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e96:	74 30                	je     800ec8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e98:	eb 16                	jmp    800eb0 <strlcpy+0x2a>
			*dst++ = *src++;
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eac:	8a 12                	mov    (%edx),%dl
  800eae:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eb0:	ff 4d 10             	decl   0x10(%ebp)
  800eb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb7:	74 09                	je     800ec2 <strlcpy+0x3c>
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	84 c0                	test   %al,%al
  800ec0:	75 d8                	jne    800e9a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ece:	29 c2                	sub    %eax,%edx
  800ed0:	89 d0                	mov    %edx,%eax
}
  800ed2:	c9                   	leave  
  800ed3:	c3                   	ret    

00800ed4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ed7:	eb 06                	jmp    800edf <strcmp+0xb>
		p++, q++;
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 00                	mov    (%eax),%al
  800ee4:	84 c0                	test   %al,%al
  800ee6:	74 0e                	je     800ef6 <strcmp+0x22>
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 10                	mov    (%eax),%dl
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	38 c2                	cmp    %al,%dl
  800ef4:	74 e3                	je     800ed9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	0f b6 d0             	movzbl %al,%edx
  800efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	0f b6 c0             	movzbl %al,%eax
  800f06:	29 c2                	sub    %eax,%edx
  800f08:	89 d0                	mov    %edx,%eax
}
  800f0a:	5d                   	pop    %ebp
  800f0b:	c3                   	ret    

00800f0c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f0f:	eb 09                	jmp    800f1a <strncmp+0xe>
		n--, p++, q++;
  800f11:	ff 4d 10             	decl   0x10(%ebp)
  800f14:	ff 45 08             	incl   0x8(%ebp)
  800f17:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1e:	74 17                	je     800f37 <strncmp+0x2b>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	84 c0                	test   %al,%al
  800f27:	74 0e                	je     800f37 <strncmp+0x2b>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 10                	mov    (%eax),%dl
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	38 c2                	cmp    %al,%dl
  800f35:	74 da                	je     800f11 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3b:	75 07                	jne    800f44 <strncmp+0x38>
		return 0;
  800f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f42:	eb 14                	jmp    800f58 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	0f b6 d0             	movzbl %al,%edx
  800f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	0f b6 c0             	movzbl %al,%eax
  800f54:	29 c2                	sub    %eax,%edx
  800f56:	89 d0                	mov    %edx,%eax
}
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 04             	sub    $0x4,%esp
  800f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f63:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f66:	eb 12                	jmp    800f7a <strchr+0x20>
		if (*s == c)
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f70:	75 05                	jne    800f77 <strchr+0x1d>
			return (char *) s;
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	eb 11                	jmp    800f88 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f77:	ff 45 08             	incl   0x8(%ebp)
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	84 c0                	test   %al,%al
  800f81:	75 e5                	jne    800f68 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	83 ec 04             	sub    $0x4,%esp
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f96:	eb 0d                	jmp    800fa5 <strfind+0x1b>
		if (*s == c)
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa0:	74 0e                	je     800fb0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fa2:	ff 45 08             	incl   0x8(%ebp)
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	84 c0                	test   %al,%al
  800fac:	75 ea                	jne    800f98 <strfind+0xe>
  800fae:	eb 01                	jmp    800fb1 <strfind+0x27>
		if (*s == c)
			break;
  800fb0:	90                   	nop
	return (char *) s;
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb4:	c9                   	leave  
  800fb5:	c3                   	ret    

00800fb6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fc8:	eb 0e                	jmp    800fd8 <memset+0x22>
		*p++ = c;
  800fca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcd:	8d 50 01             	lea    0x1(%eax),%edx
  800fd0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fd8:	ff 4d f8             	decl   -0x8(%ebp)
  800fdb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fdf:	79 e9                	jns    800fca <memset+0x14>
		*p++ = c;

	return v;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe4:	c9                   	leave  
  800fe5:	c3                   	ret    

00800fe6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ff8:	eb 16                	jmp    801010 <memcpy+0x2a>
		*d++ = *s++;
  800ffa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffd:	8d 50 01             	lea    0x1(%eax),%edx
  801000:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801003:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801006:	8d 4a 01             	lea    0x1(%edx),%ecx
  801009:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80100c:	8a 12                	mov    (%edx),%dl
  80100e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801010:	8b 45 10             	mov    0x10(%ebp),%eax
  801013:	8d 50 ff             	lea    -0x1(%eax),%edx
  801016:	89 55 10             	mov    %edx,0x10(%ebp)
  801019:	85 c0                	test   %eax,%eax
  80101b:	75 dd                	jne    800ffa <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801020:	c9                   	leave  
  801021:	c3                   	ret    

00801022 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801034:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801037:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80103a:	73 50                	jae    80108c <memmove+0x6a>
  80103c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	01 d0                	add    %edx,%eax
  801044:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801047:	76 43                	jbe    80108c <memmove+0x6a>
		s += n;
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80104f:	8b 45 10             	mov    0x10(%ebp),%eax
  801052:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801055:	eb 10                	jmp    801067 <memmove+0x45>
			*--d = *--s;
  801057:	ff 4d f8             	decl   -0x8(%ebp)
  80105a:	ff 4d fc             	decl   -0x4(%ebp)
  80105d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801060:	8a 10                	mov    (%eax),%dl
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106d:	89 55 10             	mov    %edx,0x10(%ebp)
  801070:	85 c0                	test   %eax,%eax
  801072:	75 e3                	jne    801057 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801074:	eb 23                	jmp    801099 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801076:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801079:	8d 50 01             	lea    0x1(%eax),%edx
  80107c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801082:	8d 4a 01             	lea    0x1(%edx),%ecx
  801085:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801088:	8a 12                	mov    (%edx),%dl
  80108a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80108c:	8b 45 10             	mov    0x10(%ebp),%eax
  80108f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801092:	89 55 10             	mov    %edx,0x10(%ebp)
  801095:	85 c0                	test   %eax,%eax
  801097:	75 dd                	jne    801076 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ad:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010b0:	eb 2a                	jmp    8010dc <memcmp+0x3e>
		if (*s1 != *s2)
  8010b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b5:	8a 10                	mov    (%eax),%dl
  8010b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	38 c2                	cmp    %al,%dl
  8010be:	74 16                	je     8010d6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	0f b6 d0             	movzbl %al,%edx
  8010c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	0f b6 c0             	movzbl %al,%eax
  8010d0:	29 c2                	sub    %eax,%edx
  8010d2:	89 d0                	mov    %edx,%eax
  8010d4:	eb 18                	jmp    8010ee <memcmp+0x50>
		s1++, s2++;
  8010d6:	ff 45 fc             	incl   -0x4(%ebp)
  8010d9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	75 c9                	jne    8010b2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fc:	01 d0                	add    %edx,%eax
  8010fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801101:	eb 15                	jmp    801118 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	8a 00                	mov    (%eax),%al
  801108:	0f b6 d0             	movzbl %al,%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	0f b6 c0             	movzbl %al,%eax
  801111:	39 c2                	cmp    %eax,%edx
  801113:	74 0d                	je     801122 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801115:	ff 45 08             	incl   0x8(%ebp)
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80111e:	72 e3                	jb     801103 <memfind+0x13>
  801120:	eb 01                	jmp    801123 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801122:	90                   	nop
	return (void *) s;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801126:	c9                   	leave  
  801127:	c3                   	ret    

00801128 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80112e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801135:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80113c:	eb 03                	jmp    801141 <strtol+0x19>
		s++;
  80113e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 20                	cmp    $0x20,%al
  801148:	74 f4                	je     80113e <strtol+0x16>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 09                	cmp    $0x9,%al
  801151:	74 eb                	je     80113e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	3c 2b                	cmp    $0x2b,%al
  80115a:	75 05                	jne    801161 <strtol+0x39>
		s++;
  80115c:	ff 45 08             	incl   0x8(%ebp)
  80115f:	eb 13                	jmp    801174 <strtol+0x4c>
	else if (*s == '-')
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	3c 2d                	cmp    $0x2d,%al
  801168:	75 0a                	jne    801174 <strtol+0x4c>
		s++, neg = 1;
  80116a:	ff 45 08             	incl   0x8(%ebp)
  80116d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801178:	74 06                	je     801180 <strtol+0x58>
  80117a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80117e:	75 20                	jne    8011a0 <strtol+0x78>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	3c 30                	cmp    $0x30,%al
  801187:	75 17                	jne    8011a0 <strtol+0x78>
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	40                   	inc    %eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 78                	cmp    $0x78,%al
  801191:	75 0d                	jne    8011a0 <strtol+0x78>
		s += 2, base = 16;
  801193:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801197:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80119e:	eb 28                	jmp    8011c8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a4:	75 15                	jne    8011bb <strtol+0x93>
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	3c 30                	cmp    $0x30,%al
  8011ad:	75 0c                	jne    8011bb <strtol+0x93>
		s++, base = 8;
  8011af:	ff 45 08             	incl   0x8(%ebp)
  8011b2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011b9:	eb 0d                	jmp    8011c8 <strtol+0xa0>
	else if (base == 0)
  8011bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bf:	75 07                	jne    8011c8 <strtol+0xa0>
		base = 10;
  8011c1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3c 2f                	cmp    $0x2f,%al
  8011cf:	7e 19                	jle    8011ea <strtol+0xc2>
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	3c 39                	cmp    $0x39,%al
  8011d8:	7f 10                	jg     8011ea <strtol+0xc2>
			dig = *s - '0';
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	0f be c0             	movsbl %al,%eax
  8011e2:	83 e8 30             	sub    $0x30,%eax
  8011e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011e8:	eb 42                	jmp    80122c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 60                	cmp    $0x60,%al
  8011f1:	7e 19                	jle    80120c <strtol+0xe4>
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	3c 7a                	cmp    $0x7a,%al
  8011fa:	7f 10                	jg     80120c <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	0f be c0             	movsbl %al,%eax
  801204:	83 e8 57             	sub    $0x57,%eax
  801207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80120a:	eb 20                	jmp    80122c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 40                	cmp    $0x40,%al
  801213:	7e 39                	jle    80124e <strtol+0x126>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	3c 5a                	cmp    $0x5a,%al
  80121c:	7f 30                	jg     80124e <strtol+0x126>
			dig = *s - 'A' + 10;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f be c0             	movsbl %al,%eax
  801226:	83 e8 37             	sub    $0x37,%eax
  801229:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801232:	7d 19                	jge    80124d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801234:	ff 45 08             	incl   0x8(%ebp)
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80123e:	89 c2                	mov    %eax,%edx
  801240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801243:	01 d0                	add    %edx,%eax
  801245:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801248:	e9 7b ff ff ff       	jmp    8011c8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80124d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80124e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801252:	74 08                	je     80125c <strtol+0x134>
		*endptr = (char *) s;
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	8b 55 08             	mov    0x8(%ebp),%edx
  80125a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80125c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801260:	74 07                	je     801269 <strtol+0x141>
  801262:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801265:	f7 d8                	neg    %eax
  801267:	eb 03                	jmp    80126c <strtol+0x144>
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <ltostr>:

void
ltostr(long value, char *str)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801274:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80127b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801282:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801286:	79 13                	jns    80129b <ltostr+0x2d>
	{
		neg = 1;
  801288:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80128f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801292:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801295:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801298:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012a3:	99                   	cltd   
  8012a4:	f7 f9                	idiv   %ecx
  8012a6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ac:	8d 50 01             	lea    0x1(%eax),%edx
  8012af:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012b2:	89 c2                	mov    %eax,%edx
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	01 d0                	add    %edx,%eax
  8012b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012bc:	83 c2 30             	add    $0x30,%edx
  8012bf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012c9:	f7 e9                	imul   %ecx
  8012cb:	c1 fa 02             	sar    $0x2,%edx
  8012ce:	89 c8                	mov    %ecx,%eax
  8012d0:	c1 f8 1f             	sar    $0x1f,%eax
  8012d3:	29 c2                	sub    %eax,%edx
  8012d5:	89 d0                	mov    %edx,%eax
  8012d7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012dd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012e2:	f7 e9                	imul   %ecx
  8012e4:	c1 fa 02             	sar    $0x2,%edx
  8012e7:	89 c8                	mov    %ecx,%eax
  8012e9:	c1 f8 1f             	sar    $0x1f,%eax
  8012ec:	29 c2                	sub    %eax,%edx
  8012ee:	89 d0                	mov    %edx,%eax
  8012f0:	c1 e0 02             	shl    $0x2,%eax
  8012f3:	01 d0                	add    %edx,%eax
  8012f5:	01 c0                	add    %eax,%eax
  8012f7:	29 c1                	sub    %eax,%ecx
  8012f9:	89 ca                	mov    %ecx,%edx
  8012fb:	85 d2                	test   %edx,%edx
  8012fd:	75 9c                	jne    80129b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801309:	48                   	dec    %eax
  80130a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80130d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801311:	74 3d                	je     801350 <ltostr+0xe2>
		start = 1 ;
  801313:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80131a:	eb 34                	jmp    801350 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80131c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801322:	01 d0                	add    %edx,%eax
  801324:	8a 00                	mov    (%eax),%al
  801326:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	01 c2                	add    %eax,%edx
  801331:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	01 c8                	add    %ecx,%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80133d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	01 c2                	add    %eax,%edx
  801345:	8a 45 eb             	mov    -0x15(%ebp),%al
  801348:	88 02                	mov    %al,(%edx)
		start++ ;
  80134a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80134d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801353:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801356:	7c c4                	jl     80131c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801358:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	01 d0                	add    %edx,%eax
  801360:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801363:	90                   	nop
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80136c:	ff 75 08             	pushl  0x8(%ebp)
  80136f:	e8 54 fa ff ff       	call   800dc8 <strlen>
  801374:	83 c4 04             	add    $0x4,%esp
  801377:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80137a:	ff 75 0c             	pushl  0xc(%ebp)
  80137d:	e8 46 fa ff ff       	call   800dc8 <strlen>
  801382:	83 c4 04             	add    $0x4,%esp
  801385:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80138f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801396:	eb 17                	jmp    8013af <strcconcat+0x49>
		final[s] = str1[s] ;
  801398:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80139b:	8b 45 10             	mov    0x10(%ebp),%eax
  80139e:	01 c2                	add    %eax,%edx
  8013a0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	01 c8                	add    %ecx,%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013ac:	ff 45 fc             	incl   -0x4(%ebp)
  8013af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013b5:	7c e1                	jl     801398 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013c5:	eb 1f                	jmp    8013e6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ca:	8d 50 01             	lea    0x1(%eax),%edx
  8013cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013d0:	89 c2                	mov    %eax,%edx
  8013d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d5:	01 c2                	add    %eax,%edx
  8013d7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	01 c8                	add    %ecx,%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013e3:	ff 45 f8             	incl   -0x8(%ebp)
  8013e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ec:	7c d9                	jl     8013c7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f4:	01 d0                	add    %edx,%eax
  8013f6:	c6 00 00             	movb   $0x0,(%eax)
}
  8013f9:	90                   	nop
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801402:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801408:	8b 45 14             	mov    0x14(%ebp),%eax
  80140b:	8b 00                	mov    (%eax),%eax
  80140d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801414:	8b 45 10             	mov    0x10(%ebp),%eax
  801417:	01 d0                	add    %edx,%eax
  801419:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80141f:	eb 0c                	jmp    80142d <strsplit+0x31>
			*string++ = 0;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8d 50 01             	lea    0x1(%eax),%edx
  801427:	89 55 08             	mov    %edx,0x8(%ebp)
  80142a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	84 c0                	test   %al,%al
  801434:	74 18                	je     80144e <strsplit+0x52>
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	0f be c0             	movsbl %al,%eax
  80143e:	50                   	push   %eax
  80143f:	ff 75 0c             	pushl  0xc(%ebp)
  801442:	e8 13 fb ff ff       	call   800f5a <strchr>
  801447:	83 c4 08             	add    $0x8,%esp
  80144a:	85 c0                	test   %eax,%eax
  80144c:	75 d3                	jne    801421 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	74 5a                	je     8014b1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801457:	8b 45 14             	mov    0x14(%ebp),%eax
  80145a:	8b 00                	mov    (%eax),%eax
  80145c:	83 f8 0f             	cmp    $0xf,%eax
  80145f:	75 07                	jne    801468 <strsplit+0x6c>
		{
			return 0;
  801461:	b8 00 00 00 00       	mov    $0x0,%eax
  801466:	eb 66                	jmp    8014ce <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8d 48 01             	lea    0x1(%eax),%ecx
  801470:	8b 55 14             	mov    0x14(%ebp),%edx
  801473:	89 0a                	mov    %ecx,(%edx)
  801475:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80147c:	8b 45 10             	mov    0x10(%ebp),%eax
  80147f:	01 c2                	add    %eax,%edx
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801486:	eb 03                	jmp    80148b <strsplit+0x8f>
			string++;
  801488:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	84 c0                	test   %al,%al
  801492:	74 8b                	je     80141f <strsplit+0x23>
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	0f be c0             	movsbl %al,%eax
  80149c:	50                   	push   %eax
  80149d:	ff 75 0c             	pushl  0xc(%ebp)
  8014a0:	e8 b5 fa ff ff       	call   800f5a <strchr>
  8014a5:	83 c4 08             	add    $0x8,%esp
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	74 dc                	je     801488 <strsplit+0x8c>
			string++;
	}
  8014ac:	e9 6e ff ff ff       	jmp    80141f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014b1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b5:	8b 00                	mov    (%eax),%eax
  8014b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014be:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c1:	01 d0                	add    %edx,%eax
  8014c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8014d6:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8014dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8014e3:	01 d0                	add    %edx,%eax
  8014e5:	48                   	dec    %eax
  8014e6:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8014e9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8014ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f1:	f7 75 ac             	divl   -0x54(%ebp)
  8014f4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8014f7:	29 d0                	sub    %edx,%eax
  8014f9:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8014fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801503:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  80150a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801511:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801518:	eb 3f                	jmp    801559 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  80151a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80151d:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801524:	83 ec 04             	sub    $0x4,%esp
  801527:	50                   	push   %eax
  801528:	ff 75 e8             	pushl  -0x18(%ebp)
  80152b:	68 90 2a 80 00       	push   $0x802a90
  801530:	e8 11 f2 ff ff       	call   800746 <cprintf>
  801535:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801538:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80153b:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801542:	83 ec 04             	sub    $0x4,%esp
  801545:	50                   	push   %eax
  801546:	ff 75 e8             	pushl  -0x18(%ebp)
  801549:	68 a5 2a 80 00       	push   $0x802aa5
  80154e:	e8 f3 f1 ff ff       	call   800746 <cprintf>
  801553:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801556:	ff 45 e8             	incl   -0x18(%ebp)
  801559:	a1 28 30 80 00       	mov    0x803028,%eax
  80155e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801561:	7c b7                	jl     80151a <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801563:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  80156a:	e9 42 01 00 00       	jmp    8016b1 <malloc+0x1e1>
		int flag0=1;
  80156f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801579:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80157c:	eb 6b                	jmp    8015e9 <malloc+0x119>
			for(int k=0;k<count;k++){
  80157e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801585:	eb 42                	jmp    8015c9 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801587:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80158a:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801591:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801594:	39 c2                	cmp    %eax,%edx
  801596:	77 2e                	ja     8015c6 <malloc+0xf6>
  801598:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80159b:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8015a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015a5:	39 c2                	cmp    %eax,%edx
  8015a7:	76 1d                	jbe    8015c6 <malloc+0xf6>
					ni=arr_add[k].end-i;
  8015a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015ac:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8015b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015b6:	29 c2                	sub    %eax,%edx
  8015b8:	89 d0                	mov    %edx,%eax
  8015ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  8015bd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8015c4:	eb 0d                	jmp    8015d3 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8015c6:	ff 45 d8             	incl   -0x28(%ebp)
  8015c9:	a1 28 30 80 00       	mov    0x803028,%eax
  8015ce:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8015d1:	7c b4                	jl     801587 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8015d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015d7:	74 09                	je     8015e2 <malloc+0x112>
				flag0=0;
  8015d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8015e0:	eb 16                	jmp    8015f8 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8015e2:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8015e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	01 c2                	add    %eax,%edx
  8015f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015f4:	39 c2                	cmp    %eax,%edx
  8015f6:	77 86                	ja     80157e <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8015f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015fc:	0f 84 a2 00 00 00    	je     8016a4 <malloc+0x1d4>

			int f=1;
  801602:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801609:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80160c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80160f:	89 c8                	mov    %ecx,%eax
  801611:	01 c0                	add    %eax,%eax
  801613:	01 c8                	add    %ecx,%eax
  801615:	c1 e0 02             	shl    $0x2,%eax
  801618:	05 20 31 80 00       	add    $0x803120,%eax
  80161d:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  80161f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801628:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162b:	89 d0                	mov    %edx,%eax
  80162d:	01 c0                	add    %eax,%eax
  80162f:	01 d0                	add    %edx,%eax
  801631:	c1 e0 02             	shl    $0x2,%eax
  801634:	05 24 31 80 00       	add    $0x803124,%eax
  801639:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  80163b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80163e:	89 d0                	mov    %edx,%eax
  801640:	01 c0                	add    %eax,%eax
  801642:	01 d0                	add    %edx,%eax
  801644:	c1 e0 02             	shl    $0x2,%eax
  801647:	05 28 31 80 00       	add    $0x803128,%eax
  80164c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801652:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801655:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80165c:	eb 36                	jmp    801694 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  80165e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	01 c2                	add    %eax,%edx
  801666:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801669:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801670:	39 c2                	cmp    %eax,%edx
  801672:	73 1d                	jae    801691 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801674:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801677:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80167e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801681:	29 c2                	sub    %eax,%edx
  801683:	89 d0                	mov    %edx,%eax
  801685:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801688:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  80168f:	eb 0d                	jmp    80169e <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801691:	ff 45 d0             	incl   -0x30(%ebp)
  801694:	a1 28 30 80 00       	mov    0x803028,%eax
  801699:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  80169c:	7c c0                	jl     80165e <malloc+0x18e>
					break;

				}
			}

			if(f){
  80169e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8016a2:	75 1d                	jne    8016c1 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  8016a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8016ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ae:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8016b1:	a1 04 30 80 00       	mov    0x803004,%eax
  8016b6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016b9:	0f 8c b0 fe ff ff    	jl     80156f <malloc+0x9f>
  8016bf:	eb 01                	jmp    8016c2 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  8016c1:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8016c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016c6:	75 7a                	jne    801742 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  8016c8:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	01 d0                	add    %edx,%eax
  8016d3:	48                   	dec    %eax
  8016d4:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8016d9:	7c 0a                	jl     8016e5 <malloc+0x215>
			return NULL;
  8016db:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e0:	e9 a4 02 00 00       	jmp    801989 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  8016e5:	a1 04 30 80 00       	mov    0x803004,%eax
  8016ea:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8016ed:	a1 28 30 80 00       	mov    0x803028,%eax
  8016f2:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8016f5:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  8016fc:	83 ec 08             	sub    $0x8,%esp
  8016ff:	ff 75 08             	pushl  0x8(%ebp)
  801702:	ff 75 a4             	pushl  -0x5c(%ebp)
  801705:	e8 04 06 00 00       	call   801d0e <sys_allocateMem>
  80170a:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  80170d:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	01 d0                	add    %edx,%eax
  801718:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  80171d:	a1 28 30 80 00       	mov    0x803028,%eax
  801722:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801728:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  80172f:	a1 28 30 80 00       	mov    0x803028,%eax
  801734:	40                   	inc    %eax
  801735:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  80173a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80173d:	e9 47 02 00 00       	jmp    801989 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801742:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801749:	e9 ac 00 00 00       	jmp    8017fa <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  80174e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801751:	89 d0                	mov    %edx,%eax
  801753:	01 c0                	add    %eax,%eax
  801755:	01 d0                	add    %edx,%eax
  801757:	c1 e0 02             	shl    $0x2,%eax
  80175a:	05 24 31 80 00       	add    $0x803124,%eax
  80175f:	8b 00                	mov    (%eax),%eax
  801761:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801764:	eb 7e                	jmp    8017e4 <malloc+0x314>
			int flag=0;
  801766:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  80176d:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801774:	eb 57                	jmp    8017cd <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801776:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801779:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801780:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801783:	39 c2                	cmp    %eax,%edx
  801785:	77 1a                	ja     8017a1 <malloc+0x2d1>
  801787:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80178a:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801791:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801794:	39 c2                	cmp    %eax,%edx
  801796:	76 09                	jbe    8017a1 <malloc+0x2d1>
								flag=1;
  801798:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  80179f:	eb 36                	jmp    8017d7 <malloc+0x307>
			arr[i].space++;
  8017a1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8017a4:	89 d0                	mov    %edx,%eax
  8017a6:	01 c0                	add    %eax,%eax
  8017a8:	01 d0                	add    %edx,%eax
  8017aa:	c1 e0 02             	shl    $0x2,%eax
  8017ad:	05 28 31 80 00       	add    $0x803128,%eax
  8017b2:	8b 00                	mov    (%eax),%eax
  8017b4:	8d 48 01             	lea    0x1(%eax),%ecx
  8017b7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8017ba:	89 d0                	mov    %edx,%eax
  8017bc:	01 c0                	add    %eax,%eax
  8017be:	01 d0                	add    %edx,%eax
  8017c0:	c1 e0 02             	shl    $0x2,%eax
  8017c3:	05 28 31 80 00       	add    $0x803128,%eax
  8017c8:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  8017ca:	ff 45 c0             	incl   -0x40(%ebp)
  8017cd:	a1 28 30 80 00       	mov    0x803028,%eax
  8017d2:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  8017d5:	7c 9f                	jl     801776 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  8017d7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8017db:	75 19                	jne    8017f6 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8017dd:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8017e4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8017e7:	a1 04 30 80 00       	mov    0x803004,%eax
  8017ec:	39 c2                	cmp    %eax,%edx
  8017ee:	0f 82 72 ff ff ff    	jb     801766 <malloc+0x296>
  8017f4:	eb 01                	jmp    8017f7 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  8017f6:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  8017f7:	ff 45 cc             	incl   -0x34(%ebp)
  8017fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801800:	0f 8c 48 ff ff ff    	jl     80174e <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801806:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  80180d:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801814:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  80181b:	eb 37                	jmp    801854 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  80181d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801820:	89 d0                	mov    %edx,%eax
  801822:	01 c0                	add    %eax,%eax
  801824:	01 d0                	add    %edx,%eax
  801826:	c1 e0 02             	shl    $0x2,%eax
  801829:	05 28 31 80 00       	add    $0x803128,%eax
  80182e:	8b 00                	mov    (%eax),%eax
  801830:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801833:	7d 1c                	jge    801851 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801835:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801838:	89 d0                	mov    %edx,%eax
  80183a:	01 c0                	add    %eax,%eax
  80183c:	01 d0                	add    %edx,%eax
  80183e:	c1 e0 02             	shl    $0x2,%eax
  801841:	05 28 31 80 00       	add    $0x803128,%eax
  801846:	8b 00                	mov    (%eax),%eax
  801848:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  80184b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80184e:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801851:	ff 45 b4             	incl   -0x4c(%ebp)
  801854:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801857:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80185a:	7c c1                	jl     80181d <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  80185c:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801862:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801865:	89 c8                	mov    %ecx,%eax
  801867:	01 c0                	add    %eax,%eax
  801869:	01 c8                	add    %ecx,%eax
  80186b:	c1 e0 02             	shl    $0x2,%eax
  80186e:	05 20 31 80 00       	add    $0x803120,%eax
  801873:	8b 00                	mov    (%eax),%eax
  801875:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  80187c:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801882:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801885:	89 c8                	mov    %ecx,%eax
  801887:	01 c0                	add    %eax,%eax
  801889:	01 c8                	add    %ecx,%eax
  80188b:	c1 e0 02             	shl    $0x2,%eax
  80188e:	05 24 31 80 00       	add    $0x803124,%eax
  801893:	8b 00                	mov    (%eax),%eax
  801895:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  80189c:	a1 28 30 80 00       	mov    0x803028,%eax
  8018a1:	40                   	inc    %eax
  8018a2:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  8018a7:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8018aa:	89 d0                	mov    %edx,%eax
  8018ac:	01 c0                	add    %eax,%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	c1 e0 02             	shl    $0x2,%eax
  8018b3:	05 20 31 80 00       	add    $0x803120,%eax
  8018b8:	8b 00                	mov    (%eax),%eax
  8018ba:	83 ec 08             	sub    $0x8,%esp
  8018bd:	ff 75 08             	pushl  0x8(%ebp)
  8018c0:	50                   	push   %eax
  8018c1:	e8 48 04 00 00       	call   801d0e <sys_allocateMem>
  8018c6:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  8018c9:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8018d0:	eb 78                	jmp    80194a <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8018d2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8018d5:	89 d0                	mov    %edx,%eax
  8018d7:	01 c0                	add    %eax,%eax
  8018d9:	01 d0                	add    %edx,%eax
  8018db:	c1 e0 02             	shl    $0x2,%eax
  8018de:	05 20 31 80 00       	add    $0x803120,%eax
  8018e3:	8b 00                	mov    (%eax),%eax
  8018e5:	83 ec 04             	sub    $0x4,%esp
  8018e8:	50                   	push   %eax
  8018e9:	ff 75 b0             	pushl  -0x50(%ebp)
  8018ec:	68 90 2a 80 00       	push   $0x802a90
  8018f1:	e8 50 ee ff ff       	call   800746 <cprintf>
  8018f6:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8018f9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8018fc:	89 d0                	mov    %edx,%eax
  8018fe:	01 c0                	add    %eax,%eax
  801900:	01 d0                	add    %edx,%eax
  801902:	c1 e0 02             	shl    $0x2,%eax
  801905:	05 24 31 80 00       	add    $0x803124,%eax
  80190a:	8b 00                	mov    (%eax),%eax
  80190c:	83 ec 04             	sub    $0x4,%esp
  80190f:	50                   	push   %eax
  801910:	ff 75 b0             	pushl  -0x50(%ebp)
  801913:	68 a5 2a 80 00       	push   $0x802aa5
  801918:	e8 29 ee ff ff       	call   800746 <cprintf>
  80191d:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801920:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801923:	89 d0                	mov    %edx,%eax
  801925:	01 c0                	add    %eax,%eax
  801927:	01 d0                	add    %edx,%eax
  801929:	c1 e0 02             	shl    $0x2,%eax
  80192c:	05 28 31 80 00       	add    $0x803128,%eax
  801931:	8b 00                	mov    (%eax),%eax
  801933:	83 ec 04             	sub    $0x4,%esp
  801936:	50                   	push   %eax
  801937:	ff 75 b0             	pushl  -0x50(%ebp)
  80193a:	68 b8 2a 80 00       	push   $0x802ab8
  80193f:	e8 02 ee ff ff       	call   800746 <cprintf>
  801944:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801947:	ff 45 b0             	incl   -0x50(%ebp)
  80194a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80194d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801950:	7c 80                	jl     8018d2 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801952:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801955:	89 d0                	mov    %edx,%eax
  801957:	01 c0                	add    %eax,%eax
  801959:	01 d0                	add    %edx,%eax
  80195b:	c1 e0 02             	shl    $0x2,%eax
  80195e:	05 20 31 80 00       	add    $0x803120,%eax
  801963:	8b 00                	mov    (%eax),%eax
  801965:	83 ec 08             	sub    $0x8,%esp
  801968:	50                   	push   %eax
  801969:	68 cc 2a 80 00       	push   $0x802acc
  80196e:	e8 d3 ed ff ff       	call   800746 <cprintf>
  801973:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801976:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801979:	89 d0                	mov    %edx,%eax
  80197b:	01 c0                	add    %eax,%eax
  80197d:	01 d0                	add    %edx,%eax
  80197f:	c1 e0 02             	shl    $0x2,%eax
  801982:	05 20 31 80 00       	add    $0x803120,%eax
  801987:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801997:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80199e:	eb 4b                	jmp    8019eb <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  8019a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a3:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8019aa:	89 c2                	mov    %eax,%edx
  8019ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019af:	39 c2                	cmp    %eax,%edx
  8019b1:	7f 35                	jg     8019e8 <free+0x5d>
  8019b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b6:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8019bd:	89 c2                	mov    %eax,%edx
  8019bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019c2:	39 c2                	cmp    %eax,%edx
  8019c4:	7e 22                	jle    8019e8 <free+0x5d>
				start=arr_add[i].start;
  8019c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c9:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8019d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8019d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d6:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8019dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8019e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8019e6:	eb 0d                	jmp    8019f5 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8019e8:	ff 45 ec             	incl   -0x14(%ebp)
  8019eb:	a1 28 30 80 00       	mov    0x803028,%eax
  8019f0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8019f3:	7c ab                	jl     8019a0 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8019f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f8:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8019ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a02:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801a09:	29 c2                	sub    %eax,%edx
  801a0b:	89 d0                	mov    %edx,%eax
  801a0d:	83 ec 08             	sub    $0x8,%esp
  801a10:	50                   	push   %eax
  801a11:	ff 75 f4             	pushl  -0xc(%ebp)
  801a14:	e8 d9 02 00 00       	call   801cf2 <sys_freeMem>
  801a19:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a22:	eb 2d                	jmp    801a51 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a27:	40                   	inc    %eax
  801a28:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801a2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a32:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a3c:	40                   	inc    %eax
  801a3d:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801a44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a47:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801a4e:	ff 45 e8             	incl   -0x18(%ebp)
  801a51:	a1 28 30 80 00       	mov    0x803028,%eax
  801a56:	48                   	dec    %eax
  801a57:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a5a:	7f c8                	jg     801a24 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801a5c:	a1 28 30 80 00       	mov    0x803028,%eax
  801a61:	48                   	dec    %eax
  801a62:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801a67:	90                   	nop
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	83 ec 18             	sub    $0x18,%esp
  801a70:	8b 45 10             	mov    0x10(%ebp),%eax
  801a73:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801a76:	83 ec 04             	sub    $0x4,%esp
  801a79:	68 e8 2a 80 00       	push   $0x802ae8
  801a7e:	68 18 01 00 00       	push   $0x118
  801a83:	68 0b 2b 80 00       	push   $0x802b0b
  801a88:	e8 0b 07 00 00       	call   802198 <_panic>

00801a8d <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a93:	83 ec 04             	sub    $0x4,%esp
  801a96:	68 e8 2a 80 00       	push   $0x802ae8
  801a9b:	68 1e 01 00 00       	push   $0x11e
  801aa0:	68 0b 2b 80 00       	push   $0x802b0b
  801aa5:	e8 ee 06 00 00       	call   802198 <_panic>

00801aaa <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ab0:	83 ec 04             	sub    $0x4,%esp
  801ab3:	68 e8 2a 80 00       	push   $0x802ae8
  801ab8:	68 24 01 00 00       	push   $0x124
  801abd:	68 0b 2b 80 00       	push   $0x802b0b
  801ac2:	e8 d1 06 00 00       	call   802198 <_panic>

00801ac7 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801acd:	83 ec 04             	sub    $0x4,%esp
  801ad0:	68 e8 2a 80 00       	push   $0x802ae8
  801ad5:	68 29 01 00 00       	push   $0x129
  801ada:	68 0b 2b 80 00       	push   $0x802b0b
  801adf:	e8 b4 06 00 00       	call   802198 <_panic>

00801ae4 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801aea:	83 ec 04             	sub    $0x4,%esp
  801aed:	68 e8 2a 80 00       	push   $0x802ae8
  801af2:	68 2f 01 00 00       	push   $0x12f
  801af7:	68 0b 2b 80 00       	push   $0x802b0b
  801afc:	e8 97 06 00 00       	call   802198 <_panic>

00801b01 <shrink>:
}
void shrink(uint32 newSize)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b07:	83 ec 04             	sub    $0x4,%esp
  801b0a:	68 e8 2a 80 00       	push   $0x802ae8
  801b0f:	68 33 01 00 00       	push   $0x133
  801b14:	68 0b 2b 80 00       	push   $0x802b0b
  801b19:	e8 7a 06 00 00       	call   802198 <_panic>

00801b1e <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b24:	83 ec 04             	sub    $0x4,%esp
  801b27:	68 e8 2a 80 00       	push   $0x802ae8
  801b2c:	68 38 01 00 00       	push   $0x138
  801b31:	68 0b 2b 80 00       	push   $0x802b0b
  801b36:	e8 5d 06 00 00       	call   802198 <_panic>

00801b3b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	57                   	push   %edi
  801b3f:	56                   	push   %esi
  801b40:	53                   	push   %ebx
  801b41:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b4d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b50:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b53:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b56:	cd 30                	int    $0x30
  801b58:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	5b                   	pop    %ebx
  801b62:	5e                   	pop    %esi
  801b63:	5f                   	pop    %edi
  801b64:	5d                   	pop    %ebp
  801b65:	c3                   	ret    

00801b66 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	83 ec 04             	sub    $0x4,%esp
  801b6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b72:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	52                   	push   %edx
  801b7e:	ff 75 0c             	pushl  0xc(%ebp)
  801b81:	50                   	push   %eax
  801b82:	6a 00                	push   $0x0
  801b84:	e8 b2 ff ff ff       	call   801b3b <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
}
  801b8c:	90                   	nop
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_cgetc>:

int
sys_cgetc(void)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 01                	push   $0x1
  801b9e:	e8 98 ff ff ff       	call   801b3b <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	50                   	push   %eax
  801bb7:	6a 05                	push   $0x5
  801bb9:	e8 7d ff ff ff       	call   801b3b <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 02                	push   $0x2
  801bd2:	e8 64 ff ff ff       	call   801b3b <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 03                	push   $0x3
  801beb:	e8 4b ff ff ff       	call   801b3b <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 04                	push   $0x4
  801c04:	e8 32 ff ff ff       	call   801b3b <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_env_exit>:


void sys_env_exit(void)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 06                	push   $0x6
  801c1d:	e8 19 ff ff ff       	call   801b3b <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	90                   	nop
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	52                   	push   %edx
  801c38:	50                   	push   %eax
  801c39:	6a 07                	push   $0x7
  801c3b:	e8 fb fe ff ff       	call   801b3b <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	56                   	push   %esi
  801c49:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c4a:	8b 75 18             	mov    0x18(%ebp),%esi
  801c4d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c50:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	56                   	push   %esi
  801c5a:	53                   	push   %ebx
  801c5b:	51                   	push   %ecx
  801c5c:	52                   	push   %edx
  801c5d:	50                   	push   %eax
  801c5e:	6a 08                	push   $0x8
  801c60:	e8 d6 fe ff ff       	call   801b3b <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c6b:	5b                   	pop    %ebx
  801c6c:	5e                   	pop    %esi
  801c6d:	5d                   	pop    %ebp
  801c6e:	c3                   	ret    

00801c6f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	52                   	push   %edx
  801c7f:	50                   	push   %eax
  801c80:	6a 09                	push   $0x9
  801c82:	e8 b4 fe ff ff       	call   801b3b <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	ff 75 0c             	pushl  0xc(%ebp)
  801c98:	ff 75 08             	pushl  0x8(%ebp)
  801c9b:	6a 0a                	push   $0xa
  801c9d:	e8 99 fe ff ff       	call   801b3b <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 0b                	push   $0xb
  801cb6:	e8 80 fe ff ff       	call   801b3b <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 0c                	push   $0xc
  801ccf:	e8 67 fe ff ff       	call   801b3b <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 0d                	push   $0xd
  801ce8:	e8 4e fe ff ff       	call   801b3b <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	ff 75 0c             	pushl  0xc(%ebp)
  801cfe:	ff 75 08             	pushl  0x8(%ebp)
  801d01:	6a 11                	push   $0x11
  801d03:	e8 33 fe ff ff       	call   801b3b <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
	return;
  801d0b:	90                   	nop
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	ff 75 0c             	pushl  0xc(%ebp)
  801d1a:	ff 75 08             	pushl  0x8(%ebp)
  801d1d:	6a 12                	push   $0x12
  801d1f:	e8 17 fe ff ff       	call   801b3b <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
	return ;
  801d27:	90                   	nop
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 0e                	push   $0xe
  801d39:	e8 fd fd ff ff       	call   801b3b <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	ff 75 08             	pushl  0x8(%ebp)
  801d51:	6a 0f                	push   $0xf
  801d53:	e8 e3 fd ff ff       	call   801b3b <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 10                	push   $0x10
  801d6c:	e8 ca fd ff ff       	call   801b3b <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
}
  801d74:	90                   	nop
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 14                	push   $0x14
  801d86:	e8 b0 fd ff ff       	call   801b3b <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	90                   	nop
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 15                	push   $0x15
  801da0:	e8 96 fd ff ff       	call   801b3b <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
}
  801da8:	90                   	nop
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_cputc>:


void
sys_cputc(const char c)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	83 ec 04             	sub    $0x4,%esp
  801db1:	8b 45 08             	mov    0x8(%ebp),%eax
  801db4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801db7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	50                   	push   %eax
  801dc4:	6a 16                	push   $0x16
  801dc6:	e8 70 fd ff ff       	call   801b3b <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
}
  801dce:	90                   	nop
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 17                	push   $0x17
  801de0:	e8 56 fd ff ff       	call   801b3b <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
}
  801de8:	90                   	nop
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	ff 75 0c             	pushl  0xc(%ebp)
  801dfa:	50                   	push   %eax
  801dfb:	6a 18                	push   $0x18
  801dfd:	e8 39 fd ff ff       	call   801b3b <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	52                   	push   %edx
  801e17:	50                   	push   %eax
  801e18:	6a 1b                	push   $0x1b
  801e1a:	e8 1c fd ff ff       	call   801b3b <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	52                   	push   %edx
  801e34:	50                   	push   %eax
  801e35:	6a 19                	push   $0x19
  801e37:	e8 ff fc ff ff       	call   801b3b <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	90                   	nop
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	52                   	push   %edx
  801e52:	50                   	push   %eax
  801e53:	6a 1a                	push   $0x1a
  801e55:	e8 e1 fc ff ff       	call   801b3b <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	90                   	nop
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	83 ec 04             	sub    $0x4,%esp
  801e66:	8b 45 10             	mov    0x10(%ebp),%eax
  801e69:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e6c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e6f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	6a 00                	push   $0x0
  801e78:	51                   	push   %ecx
  801e79:	52                   	push   %edx
  801e7a:	ff 75 0c             	pushl  0xc(%ebp)
  801e7d:	50                   	push   %eax
  801e7e:	6a 1c                	push   $0x1c
  801e80:	e8 b6 fc ff ff       	call   801b3b <syscall>
  801e85:	83 c4 18             	add    $0x18,%esp
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	52                   	push   %edx
  801e9a:	50                   	push   %eax
  801e9b:	6a 1d                	push   $0x1d
  801e9d:	e8 99 fc ff ff       	call   801b3b <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801eaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	51                   	push   %ecx
  801eb8:	52                   	push   %edx
  801eb9:	50                   	push   %eax
  801eba:	6a 1e                	push   $0x1e
  801ebc:	e8 7a fc ff ff       	call   801b3b <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ec9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	52                   	push   %edx
  801ed6:	50                   	push   %eax
  801ed7:	6a 1f                	push   $0x1f
  801ed9:	e8 5d fc ff ff       	call   801b3b <syscall>
  801ede:	83 c4 18             	add    $0x18,%esp
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 20                	push   $0x20
  801ef2:	e8 44 fc ff ff       	call   801b3b <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	6a 00                	push   $0x0
  801f04:	ff 75 14             	pushl  0x14(%ebp)
  801f07:	ff 75 10             	pushl  0x10(%ebp)
  801f0a:	ff 75 0c             	pushl  0xc(%ebp)
  801f0d:	50                   	push   %eax
  801f0e:	6a 21                	push   $0x21
  801f10:	e8 26 fc ff ff       	call   801b3b <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	50                   	push   %eax
  801f29:	6a 22                	push   $0x22
  801f2b:	e8 0b fc ff ff       	call   801b3b <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
}
  801f33:	90                   	nop
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	50                   	push   %eax
  801f45:	6a 23                	push   $0x23
  801f47:	e8 ef fb ff ff       	call   801b3b <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
}
  801f4f:	90                   	nop
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f58:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f5b:	8d 50 04             	lea    0x4(%eax),%edx
  801f5e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	52                   	push   %edx
  801f68:	50                   	push   %eax
  801f69:	6a 24                	push   $0x24
  801f6b:	e8 cb fb ff ff       	call   801b3b <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
	return result;
  801f73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f7c:	89 01                	mov    %eax,(%ecx)
  801f7e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	c9                   	leave  
  801f85:	c2 04 00             	ret    $0x4

00801f88 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	ff 75 10             	pushl  0x10(%ebp)
  801f92:	ff 75 0c             	pushl  0xc(%ebp)
  801f95:	ff 75 08             	pushl  0x8(%ebp)
  801f98:	6a 13                	push   $0x13
  801f9a:	e8 9c fb ff ff       	call   801b3b <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa2:	90                   	nop
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 25                	push   $0x25
  801fb4:	e8 82 fb ff ff       	call   801b3b <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	83 ec 04             	sub    $0x4,%esp
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fca:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	50                   	push   %eax
  801fd7:	6a 26                	push   $0x26
  801fd9:	e8 5d fb ff ff       	call   801b3b <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe1:	90                   	nop
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <rsttst>:
void rsttst()
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 28                	push   $0x28
  801ff3:	e8 43 fb ff ff       	call   801b3b <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffb:	90                   	nop
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 04             	sub    $0x4,%esp
  802004:	8b 45 14             	mov    0x14(%ebp),%eax
  802007:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80200a:	8b 55 18             	mov    0x18(%ebp),%edx
  80200d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802011:	52                   	push   %edx
  802012:	50                   	push   %eax
  802013:	ff 75 10             	pushl  0x10(%ebp)
  802016:	ff 75 0c             	pushl  0xc(%ebp)
  802019:	ff 75 08             	pushl  0x8(%ebp)
  80201c:	6a 27                	push   $0x27
  80201e:	e8 18 fb ff ff       	call   801b3b <syscall>
  802023:	83 c4 18             	add    $0x18,%esp
	return ;
  802026:	90                   	nop
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <chktst>:
void chktst(uint32 n)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	ff 75 08             	pushl  0x8(%ebp)
  802037:	6a 29                	push   $0x29
  802039:	e8 fd fa ff ff       	call   801b3b <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
	return ;
  802041:	90                   	nop
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <inctst>:

void inctst()
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 2a                	push   $0x2a
  802053:	e8 e3 fa ff ff       	call   801b3b <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
	return ;
  80205b:	90                   	nop
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <gettst>:
uint32 gettst()
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 2b                	push   $0x2b
  80206d:	e8 c9 fa ff ff       	call   801b3b <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 2c                	push   $0x2c
  802089:	e8 ad fa ff ff       	call   801b3b <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
  802091:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802094:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802098:	75 07                	jne    8020a1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80209a:	b8 01 00 00 00       	mov    $0x1,%eax
  80209f:	eb 05                	jmp    8020a6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 2c                	push   $0x2c
  8020ba:	e8 7c fa ff ff       	call   801b3b <syscall>
  8020bf:	83 c4 18             	add    $0x18,%esp
  8020c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020c5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020c9:	75 07                	jne    8020d2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d0:	eb 05                	jmp    8020d7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 2c                	push   $0x2c
  8020eb:	e8 4b fa ff ff       	call   801b3b <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
  8020f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020f6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020fa:	75 07                	jne    802103 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020fc:	b8 01 00 00 00       	mov    $0x1,%eax
  802101:	eb 05                	jmp    802108 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 2c                	push   $0x2c
  80211c:	e8 1a fa ff ff       	call   801b3b <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
  802124:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802127:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80212b:	75 07                	jne    802134 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80212d:	b8 01 00 00 00       	mov    $0x1,%eax
  802132:	eb 05                	jmp    802139 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802134:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	ff 75 08             	pushl  0x8(%ebp)
  802149:	6a 2d                	push   $0x2d
  80214b:	e8 eb f9 ff ff       	call   801b3b <syscall>
  802150:	83 c4 18             	add    $0x18,%esp
	return ;
  802153:	90                   	nop
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80215a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80215d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802160:	8b 55 0c             	mov    0xc(%ebp),%edx
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	6a 00                	push   $0x0
  802168:	53                   	push   %ebx
  802169:	51                   	push   %ecx
  80216a:	52                   	push   %edx
  80216b:	50                   	push   %eax
  80216c:	6a 2e                	push   $0x2e
  80216e:	e8 c8 f9 ff ff       	call   801b3b <syscall>
  802173:	83 c4 18             	add    $0x18,%esp
}
  802176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80217e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	52                   	push   %edx
  80218b:	50                   	push   %eax
  80218c:	6a 2f                	push   $0x2f
  80218e:	e8 a8 f9 ff ff       	call   801b3b <syscall>
  802193:	83 c4 18             	add    $0x18,%esp
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80219e:	8d 45 10             	lea    0x10(%ebp),%eax
  8021a1:	83 c0 04             	add    $0x4,%eax
  8021a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8021a7:	a1 60 3e 83 00       	mov    0x833e60,%eax
  8021ac:	85 c0                	test   %eax,%eax
  8021ae:	74 16                	je     8021c6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8021b0:	a1 60 3e 83 00       	mov    0x833e60,%eax
  8021b5:	83 ec 08             	sub    $0x8,%esp
  8021b8:	50                   	push   %eax
  8021b9:	68 18 2b 80 00       	push   $0x802b18
  8021be:	e8 83 e5 ff ff       	call   800746 <cprintf>
  8021c3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8021c6:	a1 00 30 80 00       	mov    0x803000,%eax
  8021cb:	ff 75 0c             	pushl  0xc(%ebp)
  8021ce:	ff 75 08             	pushl  0x8(%ebp)
  8021d1:	50                   	push   %eax
  8021d2:	68 1d 2b 80 00       	push   $0x802b1d
  8021d7:	e8 6a e5 ff ff       	call   800746 <cprintf>
  8021dc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8021df:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e2:	83 ec 08             	sub    $0x8,%esp
  8021e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e8:	50                   	push   %eax
  8021e9:	e8 ed e4 ff ff       	call   8006db <vcprintf>
  8021ee:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8021f1:	83 ec 08             	sub    $0x8,%esp
  8021f4:	6a 00                	push   $0x0
  8021f6:	68 39 2b 80 00       	push   $0x802b39
  8021fb:	e8 db e4 ff ff       	call   8006db <vcprintf>
  802200:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802203:	e8 5c e4 ff ff       	call   800664 <exit>

	// should not return here
	while (1) ;
  802208:	eb fe                	jmp    802208 <_panic+0x70>

0080220a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802210:	a1 20 30 80 00       	mov    0x803020,%eax
  802215:	8b 50 74             	mov    0x74(%eax),%edx
  802218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221b:	39 c2                	cmp    %eax,%edx
  80221d:	74 14                	je     802233 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80221f:	83 ec 04             	sub    $0x4,%esp
  802222:	68 3c 2b 80 00       	push   $0x802b3c
  802227:	6a 26                	push   $0x26
  802229:	68 88 2b 80 00       	push   $0x802b88
  80222e:	e8 65 ff ff ff       	call   802198 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802233:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80223a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802241:	e9 b6 00 00 00       	jmp    8022fc <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  802246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802249:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	01 d0                	add    %edx,%eax
  802255:	8b 00                	mov    (%eax),%eax
  802257:	85 c0                	test   %eax,%eax
  802259:	75 08                	jne    802263 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80225b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80225e:	e9 96 00 00 00       	jmp    8022f9 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  802263:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80226a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802271:	eb 5d                	jmp    8022d0 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802273:	a1 20 30 80 00       	mov    0x803020,%eax
  802278:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80227e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802281:	c1 e2 04             	shl    $0x4,%edx
  802284:	01 d0                	add    %edx,%eax
  802286:	8a 40 04             	mov    0x4(%eax),%al
  802289:	84 c0                	test   %al,%al
  80228b:	75 40                	jne    8022cd <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80228d:	a1 20 30 80 00       	mov    0x803020,%eax
  802292:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802298:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80229b:	c1 e2 04             	shl    $0x4,%edx
  80229e:	01 d0                	add    %edx,%eax
  8022a0:	8b 00                	mov    (%eax),%eax
  8022a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8022a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8022ad:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8022af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	01 c8                	add    %ecx,%eax
  8022be:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8022c0:	39 c2                	cmp    %eax,%edx
  8022c2:	75 09                	jne    8022cd <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8022c4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8022cb:	eb 12                	jmp    8022df <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8022cd:	ff 45 e8             	incl   -0x18(%ebp)
  8022d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8022d5:	8b 50 74             	mov    0x74(%eax),%edx
  8022d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022db:	39 c2                	cmp    %eax,%edx
  8022dd:	77 94                	ja     802273 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8022df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022e3:	75 14                	jne    8022f9 <CheckWSWithoutLastIndex+0xef>
			panic(
  8022e5:	83 ec 04             	sub    $0x4,%esp
  8022e8:	68 94 2b 80 00       	push   $0x802b94
  8022ed:	6a 3a                	push   $0x3a
  8022ef:	68 88 2b 80 00       	push   $0x802b88
  8022f4:	e8 9f fe ff ff       	call   802198 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8022f9:	ff 45 f0             	incl   -0x10(%ebp)
  8022fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802302:	0f 8c 3e ff ff ff    	jl     802246 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802308:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80230f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802316:	eb 20                	jmp    802338 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802318:	a1 20 30 80 00       	mov    0x803020,%eax
  80231d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802323:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802326:	c1 e2 04             	shl    $0x4,%edx
  802329:	01 d0                	add    %edx,%eax
  80232b:	8a 40 04             	mov    0x4(%eax),%al
  80232e:	3c 01                	cmp    $0x1,%al
  802330:	75 03                	jne    802335 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  802332:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802335:	ff 45 e0             	incl   -0x20(%ebp)
  802338:	a1 20 30 80 00       	mov    0x803020,%eax
  80233d:	8b 50 74             	mov    0x74(%eax),%edx
  802340:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802343:	39 c2                	cmp    %eax,%edx
  802345:	77 d1                	ja     802318 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80234d:	74 14                	je     802363 <CheckWSWithoutLastIndex+0x159>
		panic(
  80234f:	83 ec 04             	sub    $0x4,%esp
  802352:	68 e8 2b 80 00       	push   $0x802be8
  802357:	6a 44                	push   $0x44
  802359:	68 88 2b 80 00       	push   $0x802b88
  80235e:	e8 35 fe ff ff       	call   802198 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802363:	90                   	nop
  802364:	c9                   	leave  
  802365:	c3                   	ret    
  802366:	66 90                	xchg   %ax,%ax

00802368 <__udivdi3>:
  802368:	55                   	push   %ebp
  802369:	57                   	push   %edi
  80236a:	56                   	push   %esi
  80236b:	53                   	push   %ebx
  80236c:	83 ec 1c             	sub    $0x1c,%esp
  80236f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802373:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802377:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80237b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80237f:	89 ca                	mov    %ecx,%edx
  802381:	89 f8                	mov    %edi,%eax
  802383:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802387:	85 f6                	test   %esi,%esi
  802389:	75 2d                	jne    8023b8 <__udivdi3+0x50>
  80238b:	39 cf                	cmp    %ecx,%edi
  80238d:	77 65                	ja     8023f4 <__udivdi3+0x8c>
  80238f:	89 fd                	mov    %edi,%ebp
  802391:	85 ff                	test   %edi,%edi
  802393:	75 0b                	jne    8023a0 <__udivdi3+0x38>
  802395:	b8 01 00 00 00       	mov    $0x1,%eax
  80239a:	31 d2                	xor    %edx,%edx
  80239c:	f7 f7                	div    %edi
  80239e:	89 c5                	mov    %eax,%ebp
  8023a0:	31 d2                	xor    %edx,%edx
  8023a2:	89 c8                	mov    %ecx,%eax
  8023a4:	f7 f5                	div    %ebp
  8023a6:	89 c1                	mov    %eax,%ecx
  8023a8:	89 d8                	mov    %ebx,%eax
  8023aa:	f7 f5                	div    %ebp
  8023ac:	89 cf                	mov    %ecx,%edi
  8023ae:	89 fa                	mov    %edi,%edx
  8023b0:	83 c4 1c             	add    $0x1c,%esp
  8023b3:	5b                   	pop    %ebx
  8023b4:	5e                   	pop    %esi
  8023b5:	5f                   	pop    %edi
  8023b6:	5d                   	pop    %ebp
  8023b7:	c3                   	ret    
  8023b8:	39 ce                	cmp    %ecx,%esi
  8023ba:	77 28                	ja     8023e4 <__udivdi3+0x7c>
  8023bc:	0f bd fe             	bsr    %esi,%edi
  8023bf:	83 f7 1f             	xor    $0x1f,%edi
  8023c2:	75 40                	jne    802404 <__udivdi3+0x9c>
  8023c4:	39 ce                	cmp    %ecx,%esi
  8023c6:	72 0a                	jb     8023d2 <__udivdi3+0x6a>
  8023c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8023cc:	0f 87 9e 00 00 00    	ja     802470 <__udivdi3+0x108>
  8023d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d7:	89 fa                	mov    %edi,%edx
  8023d9:	83 c4 1c             	add    $0x1c,%esp
  8023dc:	5b                   	pop    %ebx
  8023dd:	5e                   	pop    %esi
  8023de:	5f                   	pop    %edi
  8023df:	5d                   	pop    %ebp
  8023e0:	c3                   	ret    
  8023e1:	8d 76 00             	lea    0x0(%esi),%esi
  8023e4:	31 ff                	xor    %edi,%edi
  8023e6:	31 c0                	xor    %eax,%eax
  8023e8:	89 fa                	mov    %edi,%edx
  8023ea:	83 c4 1c             	add    $0x1c,%esp
  8023ed:	5b                   	pop    %ebx
  8023ee:	5e                   	pop    %esi
  8023ef:	5f                   	pop    %edi
  8023f0:	5d                   	pop    %ebp
  8023f1:	c3                   	ret    
  8023f2:	66 90                	xchg   %ax,%ax
  8023f4:	89 d8                	mov    %ebx,%eax
  8023f6:	f7 f7                	div    %edi
  8023f8:	31 ff                	xor    %edi,%edi
  8023fa:	89 fa                	mov    %edi,%edx
  8023fc:	83 c4 1c             	add    $0x1c,%esp
  8023ff:	5b                   	pop    %ebx
  802400:	5e                   	pop    %esi
  802401:	5f                   	pop    %edi
  802402:	5d                   	pop    %ebp
  802403:	c3                   	ret    
  802404:	bd 20 00 00 00       	mov    $0x20,%ebp
  802409:	89 eb                	mov    %ebp,%ebx
  80240b:	29 fb                	sub    %edi,%ebx
  80240d:	89 f9                	mov    %edi,%ecx
  80240f:	d3 e6                	shl    %cl,%esi
  802411:	89 c5                	mov    %eax,%ebp
  802413:	88 d9                	mov    %bl,%cl
  802415:	d3 ed                	shr    %cl,%ebp
  802417:	89 e9                	mov    %ebp,%ecx
  802419:	09 f1                	or     %esi,%ecx
  80241b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80241f:	89 f9                	mov    %edi,%ecx
  802421:	d3 e0                	shl    %cl,%eax
  802423:	89 c5                	mov    %eax,%ebp
  802425:	89 d6                	mov    %edx,%esi
  802427:	88 d9                	mov    %bl,%cl
  802429:	d3 ee                	shr    %cl,%esi
  80242b:	89 f9                	mov    %edi,%ecx
  80242d:	d3 e2                	shl    %cl,%edx
  80242f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802433:	88 d9                	mov    %bl,%cl
  802435:	d3 e8                	shr    %cl,%eax
  802437:	09 c2                	or     %eax,%edx
  802439:	89 d0                	mov    %edx,%eax
  80243b:	89 f2                	mov    %esi,%edx
  80243d:	f7 74 24 0c          	divl   0xc(%esp)
  802441:	89 d6                	mov    %edx,%esi
  802443:	89 c3                	mov    %eax,%ebx
  802445:	f7 e5                	mul    %ebp
  802447:	39 d6                	cmp    %edx,%esi
  802449:	72 19                	jb     802464 <__udivdi3+0xfc>
  80244b:	74 0b                	je     802458 <__udivdi3+0xf0>
  80244d:	89 d8                	mov    %ebx,%eax
  80244f:	31 ff                	xor    %edi,%edi
  802451:	e9 58 ff ff ff       	jmp    8023ae <__udivdi3+0x46>
  802456:	66 90                	xchg   %ax,%ax
  802458:	8b 54 24 08          	mov    0x8(%esp),%edx
  80245c:	89 f9                	mov    %edi,%ecx
  80245e:	d3 e2                	shl    %cl,%edx
  802460:	39 c2                	cmp    %eax,%edx
  802462:	73 e9                	jae    80244d <__udivdi3+0xe5>
  802464:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802467:	31 ff                	xor    %edi,%edi
  802469:	e9 40 ff ff ff       	jmp    8023ae <__udivdi3+0x46>
  80246e:	66 90                	xchg   %ax,%ax
  802470:	31 c0                	xor    %eax,%eax
  802472:	e9 37 ff ff ff       	jmp    8023ae <__udivdi3+0x46>
  802477:	90                   	nop

00802478 <__umoddi3>:
  802478:	55                   	push   %ebp
  802479:	57                   	push   %edi
  80247a:	56                   	push   %esi
  80247b:	53                   	push   %ebx
  80247c:	83 ec 1c             	sub    $0x1c,%esp
  80247f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802483:	8b 74 24 34          	mov    0x34(%esp),%esi
  802487:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80248b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80248f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802493:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802497:	89 f3                	mov    %esi,%ebx
  802499:	89 fa                	mov    %edi,%edx
  80249b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80249f:	89 34 24             	mov    %esi,(%esp)
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	75 1a                	jne    8024c0 <__umoddi3+0x48>
  8024a6:	39 f7                	cmp    %esi,%edi
  8024a8:	0f 86 a2 00 00 00    	jbe    802550 <__umoddi3+0xd8>
  8024ae:	89 c8                	mov    %ecx,%eax
  8024b0:	89 f2                	mov    %esi,%edx
  8024b2:	f7 f7                	div    %edi
  8024b4:	89 d0                	mov    %edx,%eax
  8024b6:	31 d2                	xor    %edx,%edx
  8024b8:	83 c4 1c             	add    $0x1c,%esp
  8024bb:	5b                   	pop    %ebx
  8024bc:	5e                   	pop    %esi
  8024bd:	5f                   	pop    %edi
  8024be:	5d                   	pop    %ebp
  8024bf:	c3                   	ret    
  8024c0:	39 f0                	cmp    %esi,%eax
  8024c2:	0f 87 ac 00 00 00    	ja     802574 <__umoddi3+0xfc>
  8024c8:	0f bd e8             	bsr    %eax,%ebp
  8024cb:	83 f5 1f             	xor    $0x1f,%ebp
  8024ce:	0f 84 ac 00 00 00    	je     802580 <__umoddi3+0x108>
  8024d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8024d9:	29 ef                	sub    %ebp,%edi
  8024db:	89 fe                	mov    %edi,%esi
  8024dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024e1:	89 e9                	mov    %ebp,%ecx
  8024e3:	d3 e0                	shl    %cl,%eax
  8024e5:	89 d7                	mov    %edx,%edi
  8024e7:	89 f1                	mov    %esi,%ecx
  8024e9:	d3 ef                	shr    %cl,%edi
  8024eb:	09 c7                	or     %eax,%edi
  8024ed:	89 e9                	mov    %ebp,%ecx
  8024ef:	d3 e2                	shl    %cl,%edx
  8024f1:	89 14 24             	mov    %edx,(%esp)
  8024f4:	89 d8                	mov    %ebx,%eax
  8024f6:	d3 e0                	shl    %cl,%eax
  8024f8:	89 c2                	mov    %eax,%edx
  8024fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024fe:	d3 e0                	shl    %cl,%eax
  802500:	89 44 24 04          	mov    %eax,0x4(%esp)
  802504:	8b 44 24 08          	mov    0x8(%esp),%eax
  802508:	89 f1                	mov    %esi,%ecx
  80250a:	d3 e8                	shr    %cl,%eax
  80250c:	09 d0                	or     %edx,%eax
  80250e:	d3 eb                	shr    %cl,%ebx
  802510:	89 da                	mov    %ebx,%edx
  802512:	f7 f7                	div    %edi
  802514:	89 d3                	mov    %edx,%ebx
  802516:	f7 24 24             	mull   (%esp)
  802519:	89 c6                	mov    %eax,%esi
  80251b:	89 d1                	mov    %edx,%ecx
  80251d:	39 d3                	cmp    %edx,%ebx
  80251f:	0f 82 87 00 00 00    	jb     8025ac <__umoddi3+0x134>
  802525:	0f 84 91 00 00 00    	je     8025bc <__umoddi3+0x144>
  80252b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80252f:	29 f2                	sub    %esi,%edx
  802531:	19 cb                	sbb    %ecx,%ebx
  802533:	89 d8                	mov    %ebx,%eax
  802535:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802539:	d3 e0                	shl    %cl,%eax
  80253b:	89 e9                	mov    %ebp,%ecx
  80253d:	d3 ea                	shr    %cl,%edx
  80253f:	09 d0                	or     %edx,%eax
  802541:	89 e9                	mov    %ebp,%ecx
  802543:	d3 eb                	shr    %cl,%ebx
  802545:	89 da                	mov    %ebx,%edx
  802547:	83 c4 1c             	add    $0x1c,%esp
  80254a:	5b                   	pop    %ebx
  80254b:	5e                   	pop    %esi
  80254c:	5f                   	pop    %edi
  80254d:	5d                   	pop    %ebp
  80254e:	c3                   	ret    
  80254f:	90                   	nop
  802550:	89 fd                	mov    %edi,%ebp
  802552:	85 ff                	test   %edi,%edi
  802554:	75 0b                	jne    802561 <__umoddi3+0xe9>
  802556:	b8 01 00 00 00       	mov    $0x1,%eax
  80255b:	31 d2                	xor    %edx,%edx
  80255d:	f7 f7                	div    %edi
  80255f:	89 c5                	mov    %eax,%ebp
  802561:	89 f0                	mov    %esi,%eax
  802563:	31 d2                	xor    %edx,%edx
  802565:	f7 f5                	div    %ebp
  802567:	89 c8                	mov    %ecx,%eax
  802569:	f7 f5                	div    %ebp
  80256b:	89 d0                	mov    %edx,%eax
  80256d:	e9 44 ff ff ff       	jmp    8024b6 <__umoddi3+0x3e>
  802572:	66 90                	xchg   %ax,%ax
  802574:	89 c8                	mov    %ecx,%eax
  802576:	89 f2                	mov    %esi,%edx
  802578:	83 c4 1c             	add    $0x1c,%esp
  80257b:	5b                   	pop    %ebx
  80257c:	5e                   	pop    %esi
  80257d:	5f                   	pop    %edi
  80257e:	5d                   	pop    %ebp
  80257f:	c3                   	ret    
  802580:	3b 04 24             	cmp    (%esp),%eax
  802583:	72 06                	jb     80258b <__umoddi3+0x113>
  802585:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802589:	77 0f                	ja     80259a <__umoddi3+0x122>
  80258b:	89 f2                	mov    %esi,%edx
  80258d:	29 f9                	sub    %edi,%ecx
  80258f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802593:	89 14 24             	mov    %edx,(%esp)
  802596:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80259a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80259e:	8b 14 24             	mov    (%esp),%edx
  8025a1:	83 c4 1c             	add    $0x1c,%esp
  8025a4:	5b                   	pop    %ebx
  8025a5:	5e                   	pop    %esi
  8025a6:	5f                   	pop    %edi
  8025a7:	5d                   	pop    %ebp
  8025a8:	c3                   	ret    
  8025a9:	8d 76 00             	lea    0x0(%esi),%esi
  8025ac:	2b 04 24             	sub    (%esp),%eax
  8025af:	19 fa                	sbb    %edi,%edx
  8025b1:	89 d1                	mov    %edx,%ecx
  8025b3:	89 c6                	mov    %eax,%esi
  8025b5:	e9 71 ff ff ff       	jmp    80252b <__umoddi3+0xb3>
  8025ba:	66 90                	xchg   %ax,%ax
  8025bc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8025c0:	72 ea                	jb     8025ac <__umoddi3+0x134>
  8025c2:	89 d9                	mov    %ebx,%ecx
  8025c4:	e9 62 ff ff ff       	jmp    80252b <__umoddi3+0xb3>
