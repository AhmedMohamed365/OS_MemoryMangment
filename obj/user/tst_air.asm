
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 15 0b 00 00       	call   800b4b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec fc 01 00 00    	sub    $0x1fc,%esp
	int envID = sys_getenvid();
  800044:	e8 66 23 00 00       	call   8023af <sys_getenvid>
  800049:	89 45 bc             	mov    %eax,-0x44(%ebp)

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************

	int numOfCustomers = 15;
  80004c:	c7 45 b8 0f 00 00 00 	movl   $0xf,-0x48(%ebp)
	int flight1Customers = 3;
  800053:	c7 45 b4 03 00 00 00 	movl   $0x3,-0x4c(%ebp)
	int flight2Customers = 8;
  80005a:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%ebp)
	int flight3Customers = 4;
  800061:	c7 45 ac 04 00 00 00 	movl   $0x4,-0x54(%ebp)

	int flight1NumOfTickets = 8;
  800068:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%ebp)
	int flight2NumOfTickets = 15;
  80006f:	c7 45 a4 0f 00 00 00 	movl   $0xf,-0x5c(%ebp)

	char _customers[] = "customers";
  800076:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  80007c:	bb 76 2f 80 00       	mov    $0x802f76,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800094:	bb 80 2f 80 00       	mov    $0x802f80,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  8000ac:	bb 8c 2f 80 00       	mov    $0x802f8c,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8000c4:	bb 9b 2f 80 00       	mov    $0x802f9b,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8000dc:	bb aa 2f 80 00       	mov    $0x802faa,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8000f4:	bb bf 2f 80 00       	mov    $0x802fbf,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  80010c:	bb d4 2f 80 00       	mov    $0x802fd4,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800124:	bb e5 2f 80 00       	mov    $0x802fe5,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80013c:	bb f6 2f 80 00       	mov    $0x802ff6,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800154:	bb 07 30 80 00       	mov    $0x803007,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80016c:	bb 10 30 80 00       	mov    $0x803010,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800184:	bb 1a 30 80 00       	mov    $0x80301a,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  80019c:	bb 25 30 80 00       	mov    $0x803025,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8001b4:	bb 31 30 80 00       	mov    $0x803031,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8001cc:	bb 3b 30 80 00       	mov    $0x80303b,%ebx
  8001d1:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001d6:	89 c7                	mov    %eax,%edi
  8001d8:	89 de                	mov    %ebx,%esi
  8001da:	89 d1                	mov    %edx,%ecx
  8001dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001de:	c7 85 9f fe ff ff 63 	movl   $0x72656c63,-0x161(%ebp)
  8001e5:	6c 65 72 
  8001e8:	66 c7 85 a3 fe ff ff 	movw   $0x6b,-0x15d(%ebp)
  8001ef:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001f1:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8001f7:	bb 45 30 80 00       	mov    $0x803045,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  80020f:	bb 53 30 80 00       	mov    $0x803053,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800227:	bb 62 30 80 00       	mov    $0x803062,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80023f:	bb 69 30 80 00       	mov    $0x803069,%ebx
  800244:	ba 07 00 00 00       	mov    $0x7,%edx
  800249:	89 c7                	mov    %eax,%edi
  80024b:	89 de                	mov    %ebx,%esi
  80024d:	89 d1                	mov    %edx,%ecx
  80024f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*numOfCustomers, 1);
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	c1 e0 03             	shl    $0x3,%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	6a 01                	push   $0x1
  80025c:	50                   	push   %eax
  80025d:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	e8 ed 1f 00 00       	call   802256 <smalloc>
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
  80026f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for(;f1<flight1Customers; ++f1)
  800276:	eb 2e                	jmp    8002a6 <_main+0x26e>
		{
			custs[f1].booked = 0;
  800278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800282:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f1].flightType = 1;
  80028e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800291:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800298:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8002a3:	ff 45 e4             	incl   -0x1c(%ebp)
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8002ac:	7c ca                	jl     800278 <_main+0x240>
		{
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
  8002ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8002b4:	eb 2e                	jmp    8002e4 <_main+0x2ac>
		{
			custs[f2].booked = 0;
  8002b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f2].flightType = 2;
  8002cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8002e1:	ff 45 e0             	incl   -0x20(%ebp)
  8002e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002ef:	7f c5                	jg     8002b6 <_main+0x27e>
		{
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
  8002f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8002f7:	eb 2e                	jmp    800327 <_main+0x2ef>
		{
			custs[f3].booked = 0;
  8002f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800303:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f3].flightType = 3;
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800324:	ff 45 dc             	incl   -0x24(%ebp)
  800327:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80032a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	7f c5                	jg     8002f9 <_main+0x2c1>
			custs[f3].booked = 0;
			custs[f3].flightType = 3;
		}
	}

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	6a 01                	push   $0x1
  800339:	6a 04                	push   $0x4
  80033b:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800341:	50                   	push   %eax
  800342:	e8 0f 1f 00 00       	call   802256 <smalloc>
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	*custCounter = 0;
  80034d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	6a 01                	push   $0x1
  80035b:	6a 04                	push   $0x4
  80035d:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  800363:	50                   	push   %eax
  800364:	e8 ed 1e 00 00       	call   802256 <smalloc>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	89 45 98             	mov    %eax,-0x68(%ebp)
	*flight1Counter = flight1NumOfTickets;
  80036f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800372:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800375:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	6a 01                	push   $0x1
  80037c:	6a 04                	push   $0x4
  80037e:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800384:	50                   	push   %eax
  800385:	e8 cc 1e 00 00       	call   802256 <smalloc>
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	89 45 94             	mov    %eax,-0x6c(%ebp)
	*flight2Counter = flight2NumOfTickets;
  800390:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800393:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800396:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	6a 01                	push   $0x1
  80039d:	6a 04                	push   $0x4
  80039f:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	e8 ab 1e 00 00       	call   802256 <smalloc>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	*flight1BookedCounter = 0;
  8003b1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	6a 01                	push   $0x1
  8003bf:	6a 04                	push   $0x4
  8003c1:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 89 1e 00 00       	call   802256 <smalloc>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 8c             	mov    %eax,-0x74(%ebp)
	*flight2BookedCounter = 0;
  8003d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  8003dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003df:	c1 e0 02             	shl    $0x2,%eax
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	6a 01                	push   $0x1
  8003e7:	50                   	push   %eax
  8003e8:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	e8 62 1e 00 00       	call   802256 <smalloc>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 45 88             	mov    %eax,-0x78(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  8003fa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fd:	c1 e0 02             	shl    $0x2,%eax
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	6a 01                	push   $0x1
  800405:	50                   	push   %eax
  800406:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 44 1e 00 00       	call   802256 <smalloc>
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	89 45 84             	mov    %eax,-0x7c(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*numOfCustomers, 1);
  800418:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80041b:	c1 e0 02             	shl    $0x2,%eax
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	6a 01                	push   $0x1
  800423:	50                   	push   %eax
  800424:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80042a:	50                   	push   %eax
  80042b:	e8 26 1e 00 00       	call   802256 <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 0d 1e 00 00       	call   802256 <smalloc>
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*queue_in = 0;
  800452:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	6a 01                	push   $0x1
  800463:	6a 04                	push   $0x4
  800465:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80046b:	50                   	push   %eax
  80046c:	e8 e5 1d 00 00       	call   802256 <smalloc>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*queue_out = 0;
  80047a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************
	sys_createSemaphore(_flight1CS, 1);
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	6a 01                	push   $0x1
  80048b:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  800491:	50                   	push   %eax
  800492:	e8 40 21 00 00       	call   8025d7 <sys_createSemaphore>
  800497:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_flight2CS, 1);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	6a 01                	push   $0x1
  80049f:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 2c 21 00 00       	call   8025d7 <sys_createSemaphore>
  8004ab:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custCounterCS, 1);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	6a 01                	push   $0x1
  8004b3:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8004b9:	50                   	push   %eax
  8004ba:	e8 18 21 00 00       	call   8025d7 <sys_createSemaphore>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_custQueueCS, 1);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 04 21 00 00       	call   8025d7 <sys_createSemaphore>
  8004d3:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_clerk, 3);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	6a 03                	push   $0x3
  8004db:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	e8 f0 20 00 00       	call   8025d7 <sys_createSemaphore>
  8004e7:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_cust_ready, 0);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	6a 00                	push   $0x0
  8004ef:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 dc 20 00 00       	call   8025d7 <sys_createSemaphore>
  8004fb:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custTerminated, 0);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	6a 00                	push   $0x0
  800503:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800509:	50                   	push   %eax
  80050a:	e8 c8 20 00 00       	call   8025d7 <sys_createSemaphore>
  80050f:	83 c4 10             	add    $0x10,%esp

	int s=0;
  800512:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800519:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800520:	eb 78                	jmp    80059a <_main+0x562>
	{
		char prefix[30]="cust_finished";
  800522:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  800528:	bb 70 30 80 00       	mov    $0x803070,%ebx
  80052d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800532:	89 c7                	mov    %eax,%edi
  800534:	89 de                	mov    %ebx,%esi
  800536:	89 d1                	mov    %edx,%ecx
  800538:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80053a:	8d 95 64 fe ff ff    	lea    -0x19c(%ebp),%edx
  800540:	b9 04 00 00 00       	mov    $0x4,%ecx
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	89 d7                	mov    %edx,%edi
  80054c:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800557:	50                   	push   %eax
  800558:	ff 75 d8             	pushl  -0x28(%ebp)
  80055b:	e8 fa 14 00 00       	call   801a5a <ltostr>
  800560:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  800563:	83 ec 04             	sub    $0x4,%esp
  800566:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80056c:	50                   	push   %eax
  80056d:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800573:	50                   	push   %eax
  800574:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	e8 d2 15 00 00       	call   801b52 <strcconcat>
  800580:	83 c4 10             	add    $0x10,%esp
		sys_createSemaphore(sname, 0);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	6a 00                	push   $0x0
  800588:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80058e:	50                   	push   %eax
  80058f:	e8 43 20 00 00       	call   8025d7 <sys_createSemaphore>
  800594:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_cust_ready, 0);

	sys_createSemaphore(_custTerminated, 0);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  800597:	ff 45 d8             	incl   -0x28(%ebp)
  80059a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80059d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8005a0:	7c 80                	jl     800522 <_main+0x4ea>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//3 clerks
	uint32 envId;
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8005a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8005a7:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8005ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8005b2:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  8005b8:	89 c1                	mov    %eax,%ecx
  8005ba:	a1 20 40 80 00       	mov    0x804020,%eax
  8005bf:	8b 40 74             	mov    0x74(%eax),%eax
  8005c2:	52                   	push   %edx
  8005c3:	51                   	push   %ecx
  8005c4:	50                   	push   %eax
  8005c5:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  8005cb:	50                   	push   %eax
  8005cc:	e8 17 21 00 00       	call   8026e8 <sys_create_env>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  8005da:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 1d 21 00 00       	call   802706 <sys_run_env>
  8005e9:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8005ec:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f1:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8005f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8005fc:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  800602:	89 c1                	mov    %eax,%ecx
  800604:	a1 20 40 80 00       	mov    0x804020,%eax
  800609:	8b 40 74             	mov    0x74(%eax),%eax
  80060c:	52                   	push   %edx
  80060d:	51                   	push   %ecx
  80060e:	50                   	push   %eax
  80060f:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800615:	50                   	push   %eax
  800616:	e8 cd 20 00 00       	call   8026e8 <sys_create_env>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  800624:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	50                   	push   %eax
  80062e:	e8 d3 20 00 00       	call   802706 <sys_run_env>
  800633:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800636:	a1 20 40 80 00       	mov    0x804020,%eax
  80063b:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800641:	a1 20 40 80 00       	mov    0x804020,%eax
  800646:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	a1 20 40 80 00       	mov    0x804020,%eax
  800653:	8b 40 74             	mov    0x74(%eax),%eax
  800656:	52                   	push   %edx
  800657:	51                   	push   %ecx
  800658:	50                   	push   %eax
  800659:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  80065f:	50                   	push   %eax
  800660:	e8 83 20 00 00       	call   8026e8 <sys_create_env>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  80066e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	50                   	push   %eax
  800678:	e8 89 20 00 00       	call   802706 <sys_run_env>
  80067d:	83 c4 10             	add    $0x10,%esp

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800680:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800687:	eb 6d                	jmp    8006f6 <_main+0x6be>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800689:	a1 20 40 80 00       	mov    0x804020,%eax
  80068e:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800694:	a1 20 40 80 00       	mov    0x804020,%eax
  800699:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	a1 20 40 80 00       	mov    0x804020,%eax
  8006a6:	8b 40 74             	mov    0x74(%eax),%eax
  8006a9:	52                   	push   %edx
  8006aa:	51                   	push   %ecx
  8006ab:	50                   	push   %eax
  8006ac:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  8006b2:	50                   	push   %eax
  8006b3:	e8 30 20 00 00       	call   8026e8 <sys_create_env>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  8006c1:	83 bd 74 ff ff ff ef 	cmpl   $0xffffffef,-0x8c(%ebp)
  8006c8:	75 17                	jne    8006e1 <_main+0x6a9>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	68 a0 2c 80 00       	push   $0x802ca0
  8006d2:	68 95 00 00 00       	push   $0x95
  8006d7:	68 e6 2c 80 00       	push   $0x802ce6
  8006dc:	e8 af 05 00 00       	call   800c90 <_panic>

		sys_run_env(envId);
  8006e1:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 16 20 00 00       	call   802706 <sys_run_env>
  8006f0:	83 c4 10             	add    $0x10,%esp
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(envId);

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  8006f3:	ff 45 d4             	incl   -0x2c(%ebp)
  8006f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8006fc:	7c 8b                	jl     800689 <_main+0x651>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8006fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800705:	eb 18                	jmp    80071f <_main+0x6e7>
	{
		sys_waitSemaphore(envID, _custTerminated);
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800710:	50                   	push   %eax
  800711:	ff 75 bc             	pushl  -0x44(%ebp)
  800714:	e8 f7 1e 00 00       	call   802610 <sys_waitSemaphore>
  800719:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  80071c:	ff 45 d4             	incl   -0x2c(%ebp)
  80071f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800722:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800725:	7c e0                	jl     800707 <_main+0x6cf>
	{
		sys_waitSemaphore(envID, _custTerminated);
	}

	env_sleep(1500);
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	68 dc 05 00 00       	push   $0x5dc
  80072f:	e8 50 22 00 00       	call   802984 <env_sleep>
  800734:	83 c4 10             	add    $0x10,%esp

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800737:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80073e:	eb 45                	jmp    800785 <_main+0x74d>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  800740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800758:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80075b:	01 d0                	add    %edx,%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800762:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800769:	8b 45 88             	mov    -0x78(%ebp),%eax
  80076c:	01 c8                	add    %ecx,%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 ec 04             	sub    $0x4,%esp
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	68 f8 2c 80 00       	push   $0x802cf8
  80077a:	e8 b3 07 00 00       	call   800f32 <cprintf>
  80077f:	83 c4 10             	add    $0x10,%esp

	env_sleep(1500);

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800782:	ff 45 d0             	incl   -0x30(%ebp)
  800785:	8b 45 90             	mov    -0x70(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80078d:	7f b1                	jg     800740 <_main+0x708>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  80078f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800796:	eb 45                	jmp    8007dd <_main+0x7a5>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800798:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80079b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007a2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007a5:	01 d0                	add    %edx,%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007b0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007b3:	01 d0                	add    %edx,%eax
  8007b5:	8b 10                	mov    (%eax),%edx
  8007b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007c1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007c4:	01 c8                	add    %ecx,%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 ec 04             	sub    $0x4,%esp
  8007cb:	52                   	push   %edx
  8007cc:	50                   	push   %eax
  8007cd:	68 28 2d 80 00       	push   $0x802d28
  8007d2:	e8 5b 07 00 00       	call   800f32 <cprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  8007da:	ff 45 d0             	incl   -0x30(%ebp)
  8007dd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8007e5:	7f b1                	jg     800798 <_main+0x760>
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
  8007e7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		for(;f1<flight1Customers; ++f1)
  8007ee:	eb 33                	jmp    800823 <_main+0x7eb>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f1) != 1)
  8007f0:	83 ec 04             	sub    $0x4,%esp
  8007f3:	ff 75 cc             	pushl  -0x34(%ebp)
  8007f6:	ff 75 a8             	pushl  -0x58(%ebp)
  8007f9:	ff 75 88             	pushl  -0x78(%ebp)
  8007fc:	e8 05 03 00 00       	call   800b06 <find>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	83 f8 01             	cmp    $0x1,%eax
  800807:	74 17                	je     800820 <_main+0x7e8>
			{
				panic("Error, wrong booking for user %d\n", f1);
  800809:	ff 75 cc             	pushl  -0x34(%ebp)
  80080c:	68 58 2d 80 00       	push   $0x802d58
  800811:	68 b5 00 00 00       	push   $0xb5
  800816:	68 e6 2c 80 00       	push   $0x802ce6
  80081b:	e8 70 04 00 00       	call   800c90 <_panic>
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  800820:	ff 45 cc             	incl   -0x34(%ebp)
  800823:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800826:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  800829:	7c c5                	jl     8007f0 <_main+0x7b8>
			{
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
  80082b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80082e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  800831:	eb 33                	jmp    800866 <_main+0x82e>
		{
			if(find(flight2BookedArr, flight2NumOfTickets, f2) != 1)
  800833:	83 ec 04             	sub    $0x4,%esp
  800836:	ff 75 c8             	pushl  -0x38(%ebp)
  800839:	ff 75 a4             	pushl  -0x5c(%ebp)
  80083c:	ff 75 84             	pushl  -0x7c(%ebp)
  80083f:	e8 c2 02 00 00       	call   800b06 <find>
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	83 f8 01             	cmp    $0x1,%eax
  80084a:	74 17                	je     800863 <_main+0x82b>
			{
				panic("Error, wrong booking for user %d\n", f2);
  80084c:	ff 75 c8             	pushl  -0x38(%ebp)
  80084f:	68 58 2d 80 00       	push   $0x802d58
  800854:	68 be 00 00 00       	push   $0xbe
  800859:	68 e6 2c 80 00       	push   $0x802ce6
  80085e:	e8 2d 04 00 00       	call   800c90 <_panic>
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  800863:	ff 45 c8             	incl   -0x38(%ebp)
  800866:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800869:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80086c:	01 d0                	add    %edx,%eax
  80086e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800871:	7f c0                	jg     800833 <_main+0x7fb>
			{
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
  800873:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800876:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  800879:	eb 4c                	jmp    8008c7 <_main+0x88f>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f3) != 1 || find(flight2BookedArr, flight2NumOfTickets, f3) != 1)
  80087b:	83 ec 04             	sub    $0x4,%esp
  80087e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800881:	ff 75 a8             	pushl  -0x58(%ebp)
  800884:	ff 75 88             	pushl  -0x78(%ebp)
  800887:	e8 7a 02 00 00       	call   800b06 <find>
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	83 f8 01             	cmp    $0x1,%eax
  800892:	75 19                	jne    8008ad <_main+0x875>
  800894:	83 ec 04             	sub    $0x4,%esp
  800897:	ff 75 c4             	pushl  -0x3c(%ebp)
  80089a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80089d:	ff 75 84             	pushl  -0x7c(%ebp)
  8008a0:	e8 61 02 00 00       	call   800b06 <find>
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	83 f8 01             	cmp    $0x1,%eax
  8008ab:	74 17                	je     8008c4 <_main+0x88c>
			{
				panic("Error, wrong booking for user %d\n", f3);
  8008ad:	ff 75 c4             	pushl  -0x3c(%ebp)
  8008b0:	68 58 2d 80 00       	push   $0x802d58
  8008b5:	68 c7 00 00 00       	push   $0xc7
  8008ba:	68 e6 2c 80 00       	push   $0x802ce6
  8008bf:	e8 cc 03 00 00       	call   800c90 <_panic>
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  8008c4:	ff 45 c4             	incl   -0x3c(%ebp)
  8008c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8008ca:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8008cd:	01 d0                	add    %edx,%eax
  8008cf:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8008d2:	7f a7                	jg     80087b <_main+0x843>
			{
				panic("Error, wrong booking for user %d\n", f3);
			}
		}

		assert(sys_getSemaphoreValue(envID, _flight1CS) == 1);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8008dd:	50                   	push   %eax
  8008de:	ff 75 bc             	pushl  -0x44(%ebp)
  8008e1:	e8 0d 1d 00 00       	call   8025f3 <sys_getSemaphoreValue>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	83 f8 01             	cmp    $0x1,%eax
  8008ec:	74 19                	je     800907 <_main+0x8cf>
  8008ee:	68 7c 2d 80 00       	push   $0x802d7c
  8008f3:	68 aa 2d 80 00       	push   $0x802daa
  8008f8:	68 cb 00 00 00       	push   $0xcb
  8008fd:	68 e6 2c 80 00       	push   $0x802ce6
  800902:	e8 89 03 00 00       	call   800c90 <_panic>
		assert(sys_getSemaphoreValue(envID, _flight2CS) == 1);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	ff 75 bc             	pushl  -0x44(%ebp)
  800914:	e8 da 1c 00 00       	call   8025f3 <sys_getSemaphoreValue>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	83 f8 01             	cmp    $0x1,%eax
  80091f:	74 19                	je     80093a <_main+0x902>
  800921:	68 c0 2d 80 00       	push   $0x802dc0
  800926:	68 aa 2d 80 00       	push   $0x802daa
  80092b:	68 cc 00 00 00       	push   $0xcc
  800930:	68 e6 2c 80 00       	push   $0x802ce6
  800935:	e8 56 03 00 00       	call   800c90 <_panic>

		assert(sys_getSemaphoreValue(envID, _custCounterCS) ==  1);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	ff 75 bc             	pushl  -0x44(%ebp)
  800947:	e8 a7 1c 00 00       	call   8025f3 <sys_getSemaphoreValue>
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	83 f8 01             	cmp    $0x1,%eax
  800952:	74 19                	je     80096d <_main+0x935>
  800954:	68 f0 2d 80 00       	push   $0x802df0
  800959:	68 aa 2d 80 00       	push   $0x802daa
  80095e:	68 ce 00 00 00       	push   $0xce
  800963:	68 e6 2c 80 00       	push   $0x802ce6
  800968:	e8 23 03 00 00       	call   800c90 <_panic>
		assert(sys_getSemaphoreValue(envID, _custQueueCS) ==  1);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	ff 75 bc             	pushl  -0x44(%ebp)
  80097a:	e8 74 1c 00 00       	call   8025f3 <sys_getSemaphoreValue>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	83 f8 01             	cmp    $0x1,%eax
  800985:	74 19                	je     8009a0 <_main+0x968>
  800987:	68 24 2e 80 00       	push   $0x802e24
  80098c:	68 aa 2d 80 00       	push   $0x802daa
  800991:	68 cf 00 00 00       	push   $0xcf
  800996:	68 e6 2c 80 00       	push   $0x802ce6
  80099b:	e8 f0 02 00 00       	call   800c90 <_panic>

		assert(sys_getSemaphoreValue(envID, _clerk) == 3);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8009ad:	e8 41 1c 00 00       	call   8025f3 <sys_getSemaphoreValue>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	83 f8 03             	cmp    $0x3,%eax
  8009b8:	74 19                	je     8009d3 <_main+0x99b>
  8009ba:	68 54 2e 80 00       	push   $0x802e54
  8009bf:	68 aa 2d 80 00       	push   $0x802daa
  8009c4:	68 d1 00 00 00       	push   $0xd1
  8009c9:	68 e6 2c 80 00       	push   $0x802ce6
  8009ce:	e8 bd 02 00 00       	call   800c90 <_panic>

		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8009e0:	e8 0e 1c 00 00       	call   8025f3 <sys_getSemaphoreValue>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8009eb:	74 19                	je     800a06 <_main+0x9ce>
  8009ed:	68 80 2e 80 00       	push   $0x802e80
  8009f2:	68 aa 2d 80 00       	push   $0x802daa
  8009f7:	68 d3 00 00 00       	push   $0xd3
  8009fc:	68 e6 2c 80 00       	push   $0x802ce6
  800a01:	e8 8a 02 00 00       	call   800c90 <_panic>

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	ff 75 bc             	pushl  -0x44(%ebp)
  800a13:	e8 db 1b 00 00       	call   8025f3 <sys_getSemaphoreValue>
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	74 19                	je     800a38 <_main+0xa00>
  800a1f:	68 b0 2e 80 00       	push   $0x802eb0
  800a24:	68 aa 2d 80 00       	push   $0x802daa
  800a29:	68 d5 00 00 00       	push   $0xd5
  800a2e:	68 e6 2c 80 00       	push   $0x802ce6
  800a33:	e8 58 02 00 00       	call   800c90 <_panic>

		int s=0;
  800a38:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800a3f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800a46:	e9 96 00 00 00       	jmp    800ae1 <_main+0xaa9>
		{
			char prefix[30]="cust_finished";
  800a4b:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800a51:	bb 70 30 80 00       	mov    $0x803070,%ebx
  800a56:	ba 0e 00 00 00       	mov    $0xe,%edx
  800a5b:	89 c7                	mov    %eax,%edi
  800a5d:	89 de                	mov    %ebx,%esi
  800a5f:	89 d1                	mov    %edx,%ecx
  800a61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800a63:	8d 95 41 fe ff ff    	lea    -0x1bf(%ebp),%edx
  800a69:	b9 04 00 00 00       	mov    $0x4,%ecx
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a73:	89 d7                	mov    %edx,%edi
  800a75:	f3 ab                	rep stos %eax,%es:(%edi)
			char id[5]; char cust_finishedSemaphoreName[50];
			ltostr(s, id);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a80:	50                   	push   %eax
  800a81:	ff 75 c0             	pushl  -0x40(%ebp)
  800a84:	e8 d1 0f 00 00       	call   801a5a <ltostr>
  800a89:	83 c4 10             	add    $0x10,%esp
			strcconcat(prefix, id, cust_finishedSemaphoreName);
  800a8c:	83 ec 04             	sub    $0x4,%esp
  800a8f:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800a95:	50                   	push   %eax
  800a96:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a9c:	50                   	push   %eax
  800a9d:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800aa3:	50                   	push   %eax
  800aa4:	e8 a9 10 00 00       	call   801b52 <strcconcat>
  800aa9:	83 c4 10             	add    $0x10,%esp
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 bc             	pushl  -0x44(%ebp)
  800ab9:	e8 35 1b 00 00       	call   8025f3 <sys_getSemaphoreValue>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 19                	je     800ade <_main+0xaa6>
  800ac5:	68 e4 2e 80 00       	push   $0x802ee4
  800aca:	68 aa 2d 80 00       	push   $0x802daa
  800acf:	68 de 00 00 00       	push   $0xde
  800ad4:	68 e6 2c 80 00       	push   $0x802ce6
  800ad9:	e8 b2 01 00 00       	call   800c90 <_panic>
		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800ade:	ff 45 c0             	incl   -0x40(%ebp)
  800ae1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ae4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800ae7:	0f 8c 5e ff ff ff    	jl     800a4b <_main+0xa13>
			ltostr(s, id);
			strcconcat(prefix, id, cust_finishedSemaphoreName);
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
		}

		cprintf("Congratulations, All reservations are successfully done... have a nice flight :)\n");
  800aed:	83 ec 0c             	sub    $0xc,%esp
  800af0:	68 24 2f 80 00       	push   $0x802f24
  800af5:	e8 38 04 00 00       	call   800f32 <cprintf>
  800afa:	83 c4 10             	add    $0x10,%esp
	}

}
  800afd:	90                   	nop
  800afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <find>:


int find(int* arr, int size, int val)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800b0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800b13:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800b1a:	eb 22                	jmp    800b3e <find+0x38>
	{
		if(arr[i] == val)
  800b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	01 d0                	add    %edx,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b30:	75 09                	jne    800b3b <find+0x35>
		{
			result = 1;
  800b32:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800b39:	eb 0b                	jmp    800b46 <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800b3b:	ff 45 f8             	incl   -0x8(%ebp)
  800b3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b41:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b44:	7c d6                	jl     800b1c <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b51:	e8 72 18 00 00       	call   8023c8 <sys_getenvindex>
  800b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5c:	89 d0                	mov    %edx,%eax
  800b5e:	c1 e0 03             	shl    $0x3,%eax
  800b61:	01 d0                	add    %edx,%eax
  800b63:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800b6a:	01 c8                	add    %ecx,%eax
  800b6c:	01 c0                	add    %eax,%eax
  800b6e:	01 d0                	add    %edx,%eax
  800b70:	01 c0                	add    %eax,%eax
  800b72:	01 d0                	add    %edx,%eax
  800b74:	89 c2                	mov    %eax,%edx
  800b76:	c1 e2 05             	shl    $0x5,%edx
  800b79:	29 c2                	sub    %eax,%edx
  800b7b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800b82:	89 c2                	mov    %eax,%edx
  800b84:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800b8a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b8f:	a1 20 40 80 00       	mov    0x804020,%eax
  800b94:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800b9a:	84 c0                	test   %al,%al
  800b9c:	74 0f                	je     800bad <libmain+0x62>
		binaryname = myEnv->prog_name;
  800b9e:	a1 20 40 80 00       	mov    0x804020,%eax
  800ba3:	05 40 3c 01 00       	add    $0x13c40,%eax
  800ba8:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bb1:	7e 0a                	jle    800bbd <libmain+0x72>
		binaryname = argv[0];
  800bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 0c             	pushl  0xc(%ebp)
  800bc3:	ff 75 08             	pushl  0x8(%ebp)
  800bc6:	e8 6d f4 ff ff       	call   800038 <_main>
  800bcb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bce:	e8 90 19 00 00       	call   802563 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bd3:	83 ec 0c             	sub    $0xc,%esp
  800bd6:	68 a8 30 80 00       	push   $0x8030a8
  800bdb:	e8 52 03 00 00       	call   800f32 <cprintf>
  800be0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800be3:	a1 20 40 80 00       	mov    0x804020,%eax
  800be8:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800bee:	a1 20 40 80 00       	mov    0x804020,%eax
  800bf3:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800bf9:	83 ec 04             	sub    $0x4,%esp
  800bfc:	52                   	push   %edx
  800bfd:	50                   	push   %eax
  800bfe:	68 d0 30 80 00       	push   $0x8030d0
  800c03:	e8 2a 03 00 00       	call   800f32 <cprintf>
  800c08:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800c0b:	a1 20 40 80 00       	mov    0x804020,%eax
  800c10:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800c16:	a1 20 40 80 00       	mov    0x804020,%eax
  800c1b:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800c21:	83 ec 04             	sub    $0x4,%esp
  800c24:	52                   	push   %edx
  800c25:	50                   	push   %eax
  800c26:	68 f8 30 80 00       	push   $0x8030f8
  800c2b:	e8 02 03 00 00       	call   800f32 <cprintf>
  800c30:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c33:	a1 20 40 80 00       	mov    0x804020,%eax
  800c38:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800c3e:	83 ec 08             	sub    $0x8,%esp
  800c41:	50                   	push   %eax
  800c42:	68 39 31 80 00       	push   $0x803139
  800c47:	e8 e6 02 00 00       	call   800f32 <cprintf>
  800c4c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c4f:	83 ec 0c             	sub    $0xc,%esp
  800c52:	68 a8 30 80 00       	push   $0x8030a8
  800c57:	e8 d6 02 00 00       	call   800f32 <cprintf>
  800c5c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c5f:	e8 19 19 00 00       	call   80257d <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c64:	e8 19 00 00 00       	call   800c82 <exit>
}
  800c69:	90                   	nop
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800c72:	83 ec 0c             	sub    $0xc,%esp
  800c75:	6a 00                	push   $0x0
  800c77:	e8 18 17 00 00       	call   802394 <sys_env_destroy>
  800c7c:	83 c4 10             	add    $0x10,%esp
}
  800c7f:	90                   	nop
  800c80:	c9                   	leave  
  800c81:	c3                   	ret    

00800c82 <exit>:

void
exit(void)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800c88:	e8 6d 17 00 00       	call   8023fa <sys_env_exit>
}
  800c8d:	90                   	nop
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    

00800c90 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c96:	8d 45 10             	lea    0x10(%ebp),%eax
  800c99:	83 c0 04             	add    $0x4,%eax
  800c9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c9f:	a1 18 41 80 00       	mov    0x804118,%eax
  800ca4:	85 c0                	test   %eax,%eax
  800ca6:	74 16                	je     800cbe <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ca8:	a1 18 41 80 00       	mov    0x804118,%eax
  800cad:	83 ec 08             	sub    $0x8,%esp
  800cb0:	50                   	push   %eax
  800cb1:	68 50 31 80 00       	push   $0x803150
  800cb6:	e8 77 02 00 00       	call   800f32 <cprintf>
  800cbb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cbe:	a1 00 40 80 00       	mov    0x804000,%eax
  800cc3:	ff 75 0c             	pushl  0xc(%ebp)
  800cc6:	ff 75 08             	pushl  0x8(%ebp)
  800cc9:	50                   	push   %eax
  800cca:	68 55 31 80 00       	push   $0x803155
  800ccf:	e8 5e 02 00 00       	call   800f32 <cprintf>
  800cd4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cda:	83 ec 08             	sub    $0x8,%esp
  800cdd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce0:	50                   	push   %eax
  800ce1:	e8 e1 01 00 00       	call   800ec7 <vcprintf>
  800ce6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	6a 00                	push   $0x0
  800cee:	68 71 31 80 00       	push   $0x803171
  800cf3:	e8 cf 01 00 00       	call   800ec7 <vcprintf>
  800cf8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800cfb:	e8 82 ff ff ff       	call   800c82 <exit>

	// should not return here
	while (1) ;
  800d00:	eb fe                	jmp    800d00 <_panic+0x70>

00800d02 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d08:	a1 20 40 80 00       	mov    0x804020,%eax
  800d0d:	8b 50 74             	mov    0x74(%eax),%edx
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	39 c2                	cmp    %eax,%edx
  800d15:	74 14                	je     800d2b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d17:	83 ec 04             	sub    $0x4,%esp
  800d1a:	68 74 31 80 00       	push   $0x803174
  800d1f:	6a 26                	push   $0x26
  800d21:	68 c0 31 80 00       	push   $0x8031c0
  800d26:	e8 65 ff ff ff       	call   800c90 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d32:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d39:	e9 b6 00 00 00       	jmp    800df4 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	01 d0                	add    %edx,%eax
  800d4d:	8b 00                	mov    (%eax),%eax
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	75 08                	jne    800d5b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d53:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d56:	e9 96 00 00 00       	jmp    800df1 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800d5b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d62:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d69:	eb 5d                	jmp    800dc8 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d6b:	a1 20 40 80 00       	mov    0x804020,%eax
  800d70:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d76:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d79:	c1 e2 04             	shl    $0x4,%edx
  800d7c:	01 d0                	add    %edx,%eax
  800d7e:	8a 40 04             	mov    0x4(%eax),%al
  800d81:	84 c0                	test   %al,%al
  800d83:	75 40                	jne    800dc5 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d85:	a1 20 40 80 00       	mov    0x804020,%eax
  800d8a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d93:	c1 e2 04             	shl    $0x4,%edx
  800d96:	01 d0                	add    %edx,%eax
  800d98:	8b 00                	mov    (%eax),%eax
  800d9a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800da0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800da5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800daa:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	01 c8                	add    %ecx,%eax
  800db6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800db8:	39 c2                	cmp    %eax,%edx
  800dba:	75 09                	jne    800dc5 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800dbc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800dc3:	eb 12                	jmp    800dd7 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc5:	ff 45 e8             	incl   -0x18(%ebp)
  800dc8:	a1 20 40 80 00       	mov    0x804020,%eax
  800dcd:	8b 50 74             	mov    0x74(%eax),%edx
  800dd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dd3:	39 c2                	cmp    %eax,%edx
  800dd5:	77 94                	ja     800d6b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dd7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ddb:	75 14                	jne    800df1 <CheckWSWithoutLastIndex+0xef>
			panic(
  800ddd:	83 ec 04             	sub    $0x4,%esp
  800de0:	68 cc 31 80 00       	push   $0x8031cc
  800de5:	6a 3a                	push   $0x3a
  800de7:	68 c0 31 80 00       	push   $0x8031c0
  800dec:	e8 9f fe ff ff       	call   800c90 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800df1:	ff 45 f0             	incl   -0x10(%ebp)
  800df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dfa:	0f 8c 3e ff ff ff    	jl     800d3e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e07:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e0e:	eb 20                	jmp    800e30 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e10:	a1 20 40 80 00       	mov    0x804020,%eax
  800e15:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800e1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e1e:	c1 e2 04             	shl    $0x4,%edx
  800e21:	01 d0                	add    %edx,%eax
  800e23:	8a 40 04             	mov    0x4(%eax),%al
  800e26:	3c 01                	cmp    $0x1,%al
  800e28:	75 03                	jne    800e2d <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800e2a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e2d:	ff 45 e0             	incl   -0x20(%ebp)
  800e30:	a1 20 40 80 00       	mov    0x804020,%eax
  800e35:	8b 50 74             	mov    0x74(%eax),%edx
  800e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e3b:	39 c2                	cmp    %eax,%edx
  800e3d:	77 d1                	ja     800e10 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e42:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e45:	74 14                	je     800e5b <CheckWSWithoutLastIndex+0x159>
		panic(
  800e47:	83 ec 04             	sub    $0x4,%esp
  800e4a:	68 20 32 80 00       	push   $0x803220
  800e4f:	6a 44                	push   $0x44
  800e51:	68 c0 31 80 00       	push   $0x8031c0
  800e56:	e8 35 fe ff ff       	call   800c90 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e5b:	90                   	nop
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	8b 00                	mov    (%eax),%eax
  800e69:	8d 48 01             	lea    0x1(%eax),%ecx
  800e6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6f:	89 0a                	mov    %ecx,(%edx)
  800e71:	8b 55 08             	mov    0x8(%ebp),%edx
  800e74:	88 d1                	mov    %dl,%cl
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e80:	8b 00                	mov    (%eax),%eax
  800e82:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e87:	75 2c                	jne    800eb5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e89:	a0 24 40 80 00       	mov    0x804024,%al
  800e8e:	0f b6 c0             	movzbl %al,%eax
  800e91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e94:	8b 12                	mov    (%edx),%edx
  800e96:	89 d1                	mov    %edx,%ecx
  800e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9b:	83 c2 08             	add    $0x8,%edx
  800e9e:	83 ec 04             	sub    $0x4,%esp
  800ea1:	50                   	push   %eax
  800ea2:	51                   	push   %ecx
  800ea3:	52                   	push   %edx
  800ea4:	e8 a9 14 00 00       	call   802352 <sys_cputs>
  800ea9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	8b 40 04             	mov    0x4(%eax),%eax
  800ebb:	8d 50 01             	lea    0x1(%eax),%edx
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ec4:	90                   	nop
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ed0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ed7:	00 00 00 
	b.cnt = 0;
  800eda:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ee1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ee4:	ff 75 0c             	pushl  0xc(%ebp)
  800ee7:	ff 75 08             	pushl  0x8(%ebp)
  800eea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ef0:	50                   	push   %eax
  800ef1:	68 5e 0e 80 00       	push   $0x800e5e
  800ef6:	e8 11 02 00 00       	call   80110c <vprintfmt>
  800efb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800efe:	a0 24 40 80 00       	mov    0x804024,%al
  800f03:	0f b6 c0             	movzbl %al,%eax
  800f06:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f0c:	83 ec 04             	sub    $0x4,%esp
  800f0f:	50                   	push   %eax
  800f10:	52                   	push   %edx
  800f11:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f17:	83 c0 08             	add    $0x8,%eax
  800f1a:	50                   	push   %eax
  800f1b:	e8 32 14 00 00       	call   802352 <sys_cputs>
  800f20:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f23:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800f2a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <cprintf>:

int cprintf(const char *fmt, ...) {
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f38:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800f3f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	83 ec 08             	sub    $0x8,%esp
  800f4b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4e:	50                   	push   %eax
  800f4f:	e8 73 ff ff ff       	call   800ec7 <vcprintf>
  800f54:	83 c4 10             	add    $0x10,%esp
  800f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f65:	e8 f9 15 00 00       	call   802563 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f6a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	83 ec 08             	sub    $0x8,%esp
  800f76:	ff 75 f4             	pushl  -0xc(%ebp)
  800f79:	50                   	push   %eax
  800f7a:	e8 48 ff ff ff       	call   800ec7 <vcprintf>
  800f7f:	83 c4 10             	add    $0x10,%esp
  800f82:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f85:	e8 f3 15 00 00       	call   80257d <sys_enable_interrupt>
	return cnt;
  800f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f8d:	c9                   	leave  
  800f8e:	c3                   	ret    

00800f8f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	53                   	push   %ebx
  800f93:	83 ec 14             	sub    $0x14,%esp
  800f96:	8b 45 10             	mov    0x10(%ebp),%eax
  800f99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fa2:	8b 45 18             	mov    0x18(%ebp),%eax
  800fa5:	ba 00 00 00 00       	mov    $0x0,%edx
  800faa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fad:	77 55                	ja     801004 <printnum+0x75>
  800faf:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fb2:	72 05                	jb     800fb9 <printnum+0x2a>
  800fb4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fb7:	77 4b                	ja     801004 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fb9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fbc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fbf:	8b 45 18             	mov    0x18(%ebp),%eax
  800fc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc7:	52                   	push   %edx
  800fc8:	50                   	push   %eax
  800fc9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fcc:	ff 75 f0             	pushl  -0x10(%ebp)
  800fcf:	e8 64 1a 00 00       	call   802a38 <__udivdi3>
  800fd4:	83 c4 10             	add    $0x10,%esp
  800fd7:	83 ec 04             	sub    $0x4,%esp
  800fda:	ff 75 20             	pushl  0x20(%ebp)
  800fdd:	53                   	push   %ebx
  800fde:	ff 75 18             	pushl  0x18(%ebp)
  800fe1:	52                   	push   %edx
  800fe2:	50                   	push   %eax
  800fe3:	ff 75 0c             	pushl  0xc(%ebp)
  800fe6:	ff 75 08             	pushl  0x8(%ebp)
  800fe9:	e8 a1 ff ff ff       	call   800f8f <printnum>
  800fee:	83 c4 20             	add    $0x20,%esp
  800ff1:	eb 1a                	jmp    80100d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ff3:	83 ec 08             	sub    $0x8,%esp
  800ff6:	ff 75 0c             	pushl  0xc(%ebp)
  800ff9:	ff 75 20             	pushl  0x20(%ebp)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	ff d0                	call   *%eax
  801001:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801004:	ff 4d 1c             	decl   0x1c(%ebp)
  801007:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80100b:	7f e6                	jg     800ff3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80100d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801010:	bb 00 00 00 00       	mov    $0x0,%ebx
  801015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801018:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101b:	53                   	push   %ebx
  80101c:	51                   	push   %ecx
  80101d:	52                   	push   %edx
  80101e:	50                   	push   %eax
  80101f:	e8 24 1b 00 00       	call   802b48 <__umoddi3>
  801024:	83 c4 10             	add    $0x10,%esp
  801027:	05 94 34 80 00       	add    $0x803494,%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	0f be c0             	movsbl %al,%eax
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	ff 75 0c             	pushl  0xc(%ebp)
  801037:	50                   	push   %eax
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	ff d0                	call   *%eax
  80103d:	83 c4 10             	add    $0x10,%esp
}
  801040:	90                   	nop
  801041:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801049:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80104d:	7e 1c                	jle    80106b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	8b 00                	mov    (%eax),%eax
  801054:	8d 50 08             	lea    0x8(%eax),%edx
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	89 10                	mov    %edx,(%eax)
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8b 00                	mov    (%eax),%eax
  801061:	83 e8 08             	sub    $0x8,%eax
  801064:	8b 50 04             	mov    0x4(%eax),%edx
  801067:	8b 00                	mov    (%eax),%eax
  801069:	eb 40                	jmp    8010ab <getuint+0x65>
	else if (lflag)
  80106b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80106f:	74 1e                	je     80108f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8b 00                	mov    (%eax),%eax
  801076:	8d 50 04             	lea    0x4(%eax),%edx
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	89 10                	mov    %edx,(%eax)
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8b 00                	mov    (%eax),%eax
  801083:	83 e8 04             	sub    $0x4,%eax
  801086:	8b 00                	mov    (%eax),%eax
  801088:	ba 00 00 00 00       	mov    $0x0,%edx
  80108d:	eb 1c                	jmp    8010ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8b 00                	mov    (%eax),%eax
  801094:	8d 50 04             	lea    0x4(%eax),%edx
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	89 10                	mov    %edx,(%eax)
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8b 00                	mov    (%eax),%eax
  8010a1:	83 e8 04             	sub    $0x4,%eax
  8010a4:	8b 00                	mov    (%eax),%eax
  8010a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    

008010ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010b4:	7e 1c                	jle    8010d2 <getint+0x25>
		return va_arg(*ap, long long);
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8b 00                	mov    (%eax),%eax
  8010bb:	8d 50 08             	lea    0x8(%eax),%edx
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	89 10                	mov    %edx,(%eax)
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8b 00                	mov    (%eax),%eax
  8010c8:	83 e8 08             	sub    $0x8,%eax
  8010cb:	8b 50 04             	mov    0x4(%eax),%edx
  8010ce:	8b 00                	mov    (%eax),%eax
  8010d0:	eb 38                	jmp    80110a <getint+0x5d>
	else if (lflag)
  8010d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d6:	74 1a                	je     8010f2 <getint+0x45>
		return va_arg(*ap, long);
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8b 00                	mov    (%eax),%eax
  8010dd:	8d 50 04             	lea    0x4(%eax),%edx
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	89 10                	mov    %edx,(%eax)
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8b 00                	mov    (%eax),%eax
  8010ea:	83 e8 04             	sub    $0x4,%eax
  8010ed:	8b 00                	mov    (%eax),%eax
  8010ef:	99                   	cltd   
  8010f0:	eb 18                	jmp    80110a <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8b 00                	mov    (%eax),%eax
  8010f7:	8d 50 04             	lea    0x4(%eax),%edx
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	89 10                	mov    %edx,(%eax)
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	8b 00                	mov    (%eax),%eax
  801104:	83 e8 04             	sub    $0x4,%eax
  801107:	8b 00                	mov    (%eax),%eax
  801109:	99                   	cltd   
}
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    

0080110c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	56                   	push   %esi
  801110:	53                   	push   %ebx
  801111:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801114:	eb 17                	jmp    80112d <vprintfmt+0x21>
			if (ch == '\0')
  801116:	85 db                	test   %ebx,%ebx
  801118:	0f 84 af 03 00 00    	je     8014cd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80111e:	83 ec 08             	sub    $0x8,%esp
  801121:	ff 75 0c             	pushl  0xc(%ebp)
  801124:	53                   	push   %ebx
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	ff d0                	call   *%eax
  80112a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80112d:	8b 45 10             	mov    0x10(%ebp),%eax
  801130:	8d 50 01             	lea    0x1(%eax),%edx
  801133:	89 55 10             	mov    %edx,0x10(%ebp)
  801136:	8a 00                	mov    (%eax),%al
  801138:	0f b6 d8             	movzbl %al,%ebx
  80113b:	83 fb 25             	cmp    $0x25,%ebx
  80113e:	75 d6                	jne    801116 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801140:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801144:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80114b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801152:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801159:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801160:	8b 45 10             	mov    0x10(%ebp),%eax
  801163:	8d 50 01             	lea    0x1(%eax),%edx
  801166:	89 55 10             	mov    %edx,0x10(%ebp)
  801169:	8a 00                	mov    (%eax),%al
  80116b:	0f b6 d8             	movzbl %al,%ebx
  80116e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801171:	83 f8 55             	cmp    $0x55,%eax
  801174:	0f 87 2b 03 00 00    	ja     8014a5 <vprintfmt+0x399>
  80117a:	8b 04 85 b8 34 80 00 	mov    0x8034b8(,%eax,4),%eax
  801181:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801183:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801187:	eb d7                	jmp    801160 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801189:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80118d:	eb d1                	jmp    801160 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80118f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801196:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801199:	89 d0                	mov    %edx,%eax
  80119b:	c1 e0 02             	shl    $0x2,%eax
  80119e:	01 d0                	add    %edx,%eax
  8011a0:	01 c0                	add    %eax,%eax
  8011a2:	01 d8                	add    %ebx,%eax
  8011a4:	83 e8 30             	sub    $0x30,%eax
  8011a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8011b5:	7e 3e                	jle    8011f5 <vprintfmt+0xe9>
  8011b7:	83 fb 39             	cmp    $0x39,%ebx
  8011ba:	7f 39                	jg     8011f5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011bc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011bf:	eb d5                	jmp    801196 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c4:	83 c0 04             	add    $0x4,%eax
  8011c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8011ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cd:	83 e8 04             	sub    $0x4,%eax
  8011d0:	8b 00                	mov    (%eax),%eax
  8011d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011d5:	eb 1f                	jmp    8011f6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011db:	79 83                	jns    801160 <vprintfmt+0x54>
				width = 0;
  8011dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011e4:	e9 77 ff ff ff       	jmp    801160 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011f0:	e9 6b ff ff ff       	jmp    801160 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011f5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011fa:	0f 89 60 ff ff ff    	jns    801160 <vprintfmt+0x54>
				width = precision, precision = -1;
  801200:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801203:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801206:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80120d:	e9 4e ff ff ff       	jmp    801160 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801212:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801215:	e9 46 ff ff ff       	jmp    801160 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80121a:	8b 45 14             	mov    0x14(%ebp),%eax
  80121d:	83 c0 04             	add    $0x4,%eax
  801220:	89 45 14             	mov    %eax,0x14(%ebp)
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	83 e8 04             	sub    $0x4,%eax
  801229:	8b 00                	mov    (%eax),%eax
  80122b:	83 ec 08             	sub    $0x8,%esp
  80122e:	ff 75 0c             	pushl  0xc(%ebp)
  801231:	50                   	push   %eax
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	ff d0                	call   *%eax
  801237:	83 c4 10             	add    $0x10,%esp
			break;
  80123a:	e9 89 02 00 00       	jmp    8014c8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80123f:	8b 45 14             	mov    0x14(%ebp),%eax
  801242:	83 c0 04             	add    $0x4,%eax
  801245:	89 45 14             	mov    %eax,0x14(%ebp)
  801248:	8b 45 14             	mov    0x14(%ebp),%eax
  80124b:	83 e8 04             	sub    $0x4,%eax
  80124e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801250:	85 db                	test   %ebx,%ebx
  801252:	79 02                	jns    801256 <vprintfmt+0x14a>
				err = -err;
  801254:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801256:	83 fb 64             	cmp    $0x64,%ebx
  801259:	7f 0b                	jg     801266 <vprintfmt+0x15a>
  80125b:	8b 34 9d 00 33 80 00 	mov    0x803300(,%ebx,4),%esi
  801262:	85 f6                	test   %esi,%esi
  801264:	75 19                	jne    80127f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801266:	53                   	push   %ebx
  801267:	68 a5 34 80 00       	push   $0x8034a5
  80126c:	ff 75 0c             	pushl  0xc(%ebp)
  80126f:	ff 75 08             	pushl  0x8(%ebp)
  801272:	e8 5e 02 00 00       	call   8014d5 <printfmt>
  801277:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80127a:	e9 49 02 00 00       	jmp    8014c8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80127f:	56                   	push   %esi
  801280:	68 ae 34 80 00       	push   $0x8034ae
  801285:	ff 75 0c             	pushl  0xc(%ebp)
  801288:	ff 75 08             	pushl  0x8(%ebp)
  80128b:	e8 45 02 00 00       	call   8014d5 <printfmt>
  801290:	83 c4 10             	add    $0x10,%esp
			break;
  801293:	e9 30 02 00 00       	jmp    8014c8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801298:	8b 45 14             	mov    0x14(%ebp),%eax
  80129b:	83 c0 04             	add    $0x4,%eax
  80129e:	89 45 14             	mov    %eax,0x14(%ebp)
  8012a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a4:	83 e8 04             	sub    $0x4,%eax
  8012a7:	8b 30                	mov    (%eax),%esi
  8012a9:	85 f6                	test   %esi,%esi
  8012ab:	75 05                	jne    8012b2 <vprintfmt+0x1a6>
				p = "(null)";
  8012ad:	be b1 34 80 00       	mov    $0x8034b1,%esi
			if (width > 0 && padc != '-')
  8012b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012b6:	7e 6d                	jle    801325 <vprintfmt+0x219>
  8012b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012bc:	74 67                	je     801325 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c1:	83 ec 08             	sub    $0x8,%esp
  8012c4:	50                   	push   %eax
  8012c5:	56                   	push   %esi
  8012c6:	e8 0c 03 00 00       	call   8015d7 <strnlen>
  8012cb:	83 c4 10             	add    $0x10,%esp
  8012ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012d1:	eb 16                	jmp    8012e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012d7:	83 ec 08             	sub    $0x8,%esp
  8012da:	ff 75 0c             	pushl  0xc(%ebp)
  8012dd:	50                   	push   %eax
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	ff d0                	call   *%eax
  8012e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8012e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012ed:	7f e4                	jg     8012d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012ef:	eb 34                	jmp    801325 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012f5:	74 1c                	je     801313 <vprintfmt+0x207>
  8012f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8012fa:	7e 05                	jle    801301 <vprintfmt+0x1f5>
  8012fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8012ff:	7e 12                	jle    801313 <vprintfmt+0x207>
					putch('?', putdat);
  801301:	83 ec 08             	sub    $0x8,%esp
  801304:	ff 75 0c             	pushl  0xc(%ebp)
  801307:	6a 3f                	push   $0x3f
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	ff d0                	call   *%eax
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	eb 0f                	jmp    801322 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801313:	83 ec 08             	sub    $0x8,%esp
  801316:	ff 75 0c             	pushl  0xc(%ebp)
  801319:	53                   	push   %ebx
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	ff d0                	call   *%eax
  80131f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801322:	ff 4d e4             	decl   -0x1c(%ebp)
  801325:	89 f0                	mov    %esi,%eax
  801327:	8d 70 01             	lea    0x1(%eax),%esi
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	0f be d8             	movsbl %al,%ebx
  80132f:	85 db                	test   %ebx,%ebx
  801331:	74 24                	je     801357 <vprintfmt+0x24b>
  801333:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801337:	78 b8                	js     8012f1 <vprintfmt+0x1e5>
  801339:	ff 4d e0             	decl   -0x20(%ebp)
  80133c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801340:	79 af                	jns    8012f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801342:	eb 13                	jmp    801357 <vprintfmt+0x24b>
				putch(' ', putdat);
  801344:	83 ec 08             	sub    $0x8,%esp
  801347:	ff 75 0c             	pushl  0xc(%ebp)
  80134a:	6a 20                	push   $0x20
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	ff d0                	call   *%eax
  801351:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801354:	ff 4d e4             	decl   -0x1c(%ebp)
  801357:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80135b:	7f e7                	jg     801344 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80135d:	e9 66 01 00 00       	jmp    8014c8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	ff 75 e8             	pushl  -0x18(%ebp)
  801368:	8d 45 14             	lea    0x14(%ebp),%eax
  80136b:	50                   	push   %eax
  80136c:	e8 3c fd ff ff       	call   8010ad <getint>
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801377:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80137a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801380:	85 d2                	test   %edx,%edx
  801382:	79 23                	jns    8013a7 <vprintfmt+0x29b>
				putch('-', putdat);
  801384:	83 ec 08             	sub    $0x8,%esp
  801387:	ff 75 0c             	pushl  0xc(%ebp)
  80138a:	6a 2d                	push   $0x2d
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	ff d0                	call   *%eax
  801391:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801397:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139a:	f7 d8                	neg    %eax
  80139c:	83 d2 00             	adc    $0x0,%edx
  80139f:	f7 da                	neg    %edx
  8013a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013a7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013ae:	e9 bc 00 00 00       	jmp    80146f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8013b9:	8d 45 14             	lea    0x14(%ebp),%eax
  8013bc:	50                   	push   %eax
  8013bd:	e8 84 fc ff ff       	call   801046 <getuint>
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013d2:	e9 98 00 00 00       	jmp    80146f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	6a 58                	push   $0x58
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	ff d0                	call   *%eax
  8013e4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	ff 75 0c             	pushl  0xc(%ebp)
  8013ed:	6a 58                	push   $0x58
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	ff d0                	call   *%eax
  8013f4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013f7:	83 ec 08             	sub    $0x8,%esp
  8013fa:	ff 75 0c             	pushl  0xc(%ebp)
  8013fd:	6a 58                	push   $0x58
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	ff d0                	call   *%eax
  801404:	83 c4 10             	add    $0x10,%esp
			break;
  801407:	e9 bc 00 00 00       	jmp    8014c8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80140c:	83 ec 08             	sub    $0x8,%esp
  80140f:	ff 75 0c             	pushl  0xc(%ebp)
  801412:	6a 30                	push   $0x30
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	ff d0                	call   *%eax
  801419:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80141c:	83 ec 08             	sub    $0x8,%esp
  80141f:	ff 75 0c             	pushl  0xc(%ebp)
  801422:	6a 78                	push   $0x78
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	ff d0                	call   *%eax
  801429:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80142c:	8b 45 14             	mov    0x14(%ebp),%eax
  80142f:	83 c0 04             	add    $0x4,%eax
  801432:	89 45 14             	mov    %eax,0x14(%ebp)
  801435:	8b 45 14             	mov    0x14(%ebp),%eax
  801438:	83 e8 04             	sub    $0x4,%eax
  80143b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80143d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801440:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801447:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80144e:	eb 1f                	jmp    80146f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801450:	83 ec 08             	sub    $0x8,%esp
  801453:	ff 75 e8             	pushl  -0x18(%ebp)
  801456:	8d 45 14             	lea    0x14(%ebp),%eax
  801459:	50                   	push   %eax
  80145a:	e8 e7 fb ff ff       	call   801046 <getuint>
  80145f:	83 c4 10             	add    $0x10,%esp
  801462:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801465:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801468:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80146f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801473:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801476:	83 ec 04             	sub    $0x4,%esp
  801479:	52                   	push   %edx
  80147a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80147d:	50                   	push   %eax
  80147e:	ff 75 f4             	pushl  -0xc(%ebp)
  801481:	ff 75 f0             	pushl  -0x10(%ebp)
  801484:	ff 75 0c             	pushl  0xc(%ebp)
  801487:	ff 75 08             	pushl  0x8(%ebp)
  80148a:	e8 00 fb ff ff       	call   800f8f <printnum>
  80148f:	83 c4 20             	add    $0x20,%esp
			break;
  801492:	eb 34                	jmp    8014c8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801494:	83 ec 08             	sub    $0x8,%esp
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	53                   	push   %ebx
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	ff d0                	call   *%eax
  8014a0:	83 c4 10             	add    $0x10,%esp
			break;
  8014a3:	eb 23                	jmp    8014c8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014a5:	83 ec 08             	sub    $0x8,%esp
  8014a8:	ff 75 0c             	pushl  0xc(%ebp)
  8014ab:	6a 25                	push   $0x25
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	ff d0                	call   *%eax
  8014b2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014b5:	ff 4d 10             	decl   0x10(%ebp)
  8014b8:	eb 03                	jmp    8014bd <vprintfmt+0x3b1>
  8014ba:	ff 4d 10             	decl   0x10(%ebp)
  8014bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c0:	48                   	dec    %eax
  8014c1:	8a 00                	mov    (%eax),%al
  8014c3:	3c 25                	cmp    $0x25,%al
  8014c5:	75 f3                	jne    8014ba <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014c7:	90                   	nop
		}
	}
  8014c8:	e9 47 fc ff ff       	jmp    801114 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014cd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d1:	5b                   	pop    %ebx
  8014d2:	5e                   	pop    %esi
  8014d3:	5d                   	pop    %ebp
  8014d4:	c3                   	ret    

008014d5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014db:	8d 45 10             	lea    0x10(%ebp),%eax
  8014de:	83 c0 04             	add    $0x4,%eax
  8014e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ea:	50                   	push   %eax
  8014eb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ee:	ff 75 08             	pushl  0x8(%ebp)
  8014f1:	e8 16 fc ff ff       	call   80110c <vprintfmt>
  8014f6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014f9:	90                   	nop
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801502:	8b 40 08             	mov    0x8(%eax),%eax
  801505:	8d 50 01             	lea    0x1(%eax),%edx
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80150e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801511:	8b 10                	mov    (%eax),%edx
  801513:	8b 45 0c             	mov    0xc(%ebp),%eax
  801516:	8b 40 04             	mov    0x4(%eax),%eax
  801519:	39 c2                	cmp    %eax,%edx
  80151b:	73 12                	jae    80152f <sprintputch+0x33>
		*b->buf++ = ch;
  80151d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801520:	8b 00                	mov    (%eax),%eax
  801522:	8d 48 01             	lea    0x1(%eax),%ecx
  801525:	8b 55 0c             	mov    0xc(%ebp),%edx
  801528:	89 0a                	mov    %ecx,(%edx)
  80152a:	8b 55 08             	mov    0x8(%ebp),%edx
  80152d:	88 10                	mov    %dl,(%eax)
}
  80152f:	90                   	nop
  801530:	5d                   	pop    %ebp
  801531:	c3                   	ret    

00801532 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80153e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801541:	8d 50 ff             	lea    -0x1(%eax),%edx
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	01 d0                	add    %edx,%eax
  801549:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80154c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801553:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801557:	74 06                	je     80155f <vsnprintf+0x2d>
  801559:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80155d:	7f 07                	jg     801566 <vsnprintf+0x34>
		return -E_INVAL;
  80155f:	b8 03 00 00 00       	mov    $0x3,%eax
  801564:	eb 20                	jmp    801586 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801566:	ff 75 14             	pushl  0x14(%ebp)
  801569:	ff 75 10             	pushl  0x10(%ebp)
  80156c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80156f:	50                   	push   %eax
  801570:	68 fc 14 80 00       	push   $0x8014fc
  801575:	e8 92 fb ff ff       	call   80110c <vprintfmt>
  80157a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80157d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801580:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801583:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80158e:	8d 45 10             	lea    0x10(%ebp),%eax
  801591:	83 c0 04             	add    $0x4,%eax
  801594:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801597:	8b 45 10             	mov    0x10(%ebp),%eax
  80159a:	ff 75 f4             	pushl  -0xc(%ebp)
  80159d:	50                   	push   %eax
  80159e:	ff 75 0c             	pushl  0xc(%ebp)
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 89 ff ff ff       	call   801532 <vsnprintf>
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015af:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015c1:	eb 06                	jmp    8015c9 <strlen+0x15>
		n++;
  8015c3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015c6:	ff 45 08             	incl   0x8(%ebp)
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8a 00                	mov    (%eax),%al
  8015ce:	84 c0                	test   %al,%al
  8015d0:	75 f1                	jne    8015c3 <strlen+0xf>
		n++;
	return n;
  8015d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e4:	eb 09                	jmp    8015ef <strnlen+0x18>
		n++;
  8015e6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015e9:	ff 45 08             	incl   0x8(%ebp)
  8015ec:	ff 4d 0c             	decl   0xc(%ebp)
  8015ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015f3:	74 09                	je     8015fe <strnlen+0x27>
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	75 e8                	jne    8015e6 <strnlen+0xf>
		n++;
	return n;
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80160f:	90                   	nop
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	8d 50 01             	lea    0x1(%eax),%edx
  801616:	89 55 08             	mov    %edx,0x8(%ebp)
  801619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801622:	8a 12                	mov    (%edx),%dl
  801624:	88 10                	mov    %dl,(%eax)
  801626:	8a 00                	mov    (%eax),%al
  801628:	84 c0                	test   %al,%al
  80162a:	75 e4                	jne    801610 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80162c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80163d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801644:	eb 1f                	jmp    801665 <strncpy+0x34>
		*dst++ = *src;
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8d 50 01             	lea    0x1(%eax),%edx
  80164c:	89 55 08             	mov    %edx,0x8(%ebp)
  80164f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801652:	8a 12                	mov    (%edx),%dl
  801654:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801656:	8b 45 0c             	mov    0xc(%ebp),%eax
  801659:	8a 00                	mov    (%eax),%al
  80165b:	84 c0                	test   %al,%al
  80165d:	74 03                	je     801662 <strncpy+0x31>
			src++;
  80165f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801662:	ff 45 fc             	incl   -0x4(%ebp)
  801665:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801668:	3b 45 10             	cmp    0x10(%ebp),%eax
  80166b:	72 d9                	jb     801646 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80166d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80167e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801682:	74 30                	je     8016b4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801684:	eb 16                	jmp    80169c <strlcpy+0x2a>
			*dst++ = *src++;
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8d 50 01             	lea    0x1(%eax),%edx
  80168c:	89 55 08             	mov    %edx,0x8(%ebp)
  80168f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801692:	8d 4a 01             	lea    0x1(%edx),%ecx
  801695:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801698:	8a 12                	mov    (%edx),%dl
  80169a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80169c:	ff 4d 10             	decl   0x10(%ebp)
  80169f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a3:	74 09                	je     8016ae <strlcpy+0x3c>
  8016a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a8:	8a 00                	mov    (%eax),%al
  8016aa:	84 c0                	test   %al,%al
  8016ac:	75 d8                	jne    801686 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ba:	29 c2                	sub    %eax,%edx
  8016bc:	89 d0                	mov    %edx,%eax
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016c3:	eb 06                	jmp    8016cb <strcmp+0xb>
		p++, q++;
  8016c5:	ff 45 08             	incl   0x8(%ebp)
  8016c8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	8a 00                	mov    (%eax),%al
  8016d0:	84 c0                	test   %al,%al
  8016d2:	74 0e                	je     8016e2 <strcmp+0x22>
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	8a 10                	mov    (%eax),%dl
  8016d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	38 c2                	cmp    %al,%dl
  8016e0:	74 e3                	je     8016c5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8a 00                	mov    (%eax),%al
  8016e7:	0f b6 d0             	movzbl %al,%edx
  8016ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ed:	8a 00                	mov    (%eax),%al
  8016ef:	0f b6 c0             	movzbl %al,%eax
  8016f2:	29 c2                	sub    %eax,%edx
  8016f4:	89 d0                	mov    %edx,%eax
}
  8016f6:	5d                   	pop    %ebp
  8016f7:	c3                   	ret    

008016f8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016fb:	eb 09                	jmp    801706 <strncmp+0xe>
		n--, p++, q++;
  8016fd:	ff 4d 10             	decl   0x10(%ebp)
  801700:	ff 45 08             	incl   0x8(%ebp)
  801703:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801706:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80170a:	74 17                	je     801723 <strncmp+0x2b>
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	8a 00                	mov    (%eax),%al
  801711:	84 c0                	test   %al,%al
  801713:	74 0e                	je     801723 <strncmp+0x2b>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 10                	mov    (%eax),%dl
  80171a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	38 c2                	cmp    %al,%dl
  801721:	74 da                	je     8016fd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801723:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801727:	75 07                	jne    801730 <strncmp+0x38>
		return 0;
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
  80172e:	eb 14                	jmp    801744 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	8a 00                	mov    (%eax),%al
  801735:	0f b6 d0             	movzbl %al,%edx
  801738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	0f b6 c0             	movzbl %al,%eax
  801740:	29 c2                	sub    %eax,%edx
  801742:	89 d0                	mov    %edx,%eax
}
  801744:	5d                   	pop    %ebp
  801745:	c3                   	ret    

00801746 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801752:	eb 12                	jmp    801766 <strchr+0x20>
		if (*s == c)
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	8a 00                	mov    (%eax),%al
  801759:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80175c:	75 05                	jne    801763 <strchr+0x1d>
			return (char *) s;
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	eb 11                	jmp    801774 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801763:	ff 45 08             	incl   0x8(%ebp)
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	8a 00                	mov    (%eax),%al
  80176b:	84 c0                	test   %al,%al
  80176d:	75 e5                	jne    801754 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80176f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 04             	sub    $0x4,%esp
  80177c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801782:	eb 0d                	jmp    801791 <strfind+0x1b>
		if (*s == c)
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8a 00                	mov    (%eax),%al
  801789:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80178c:	74 0e                	je     80179c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80178e:	ff 45 08             	incl   0x8(%ebp)
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	84 c0                	test   %al,%al
  801798:	75 ea                	jne    801784 <strfind+0xe>
  80179a:	eb 01                	jmp    80179d <strfind+0x27>
		if (*s == c)
			break;
  80179c:	90                   	nop
	return (char *) s;
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017b4:	eb 0e                	jmp    8017c4 <memset+0x22>
		*p++ = c;
  8017b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017b9:	8d 50 01             	lea    0x1(%eax),%edx
  8017bc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017c4:	ff 4d f8             	decl   -0x8(%ebp)
  8017c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017cb:	79 e9                	jns    8017b6 <memset+0x14>
		*p++ = c;

	return v;
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017e4:	eb 16                	jmp    8017fc <memcpy+0x2a>
		*d++ = *s++;
  8017e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e9:	8d 50 01             	lea    0x1(%eax),%edx
  8017ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017f5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017f8:	8a 12                	mov    (%edx),%dl
  8017fa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801802:	89 55 10             	mov    %edx,0x10(%ebp)
  801805:	85 c0                	test   %eax,%eax
  801807:	75 dd                	jne    8017e6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801814:	8b 45 0c             	mov    0xc(%ebp),%eax
  801817:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801820:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801823:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801826:	73 50                	jae    801878 <memmove+0x6a>
  801828:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80182b:	8b 45 10             	mov    0x10(%ebp),%eax
  80182e:	01 d0                	add    %edx,%eax
  801830:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801833:	76 43                	jbe    801878 <memmove+0x6a>
		s += n;
  801835:	8b 45 10             	mov    0x10(%ebp),%eax
  801838:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80183b:	8b 45 10             	mov    0x10(%ebp),%eax
  80183e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801841:	eb 10                	jmp    801853 <memmove+0x45>
			*--d = *--s;
  801843:	ff 4d f8             	decl   -0x8(%ebp)
  801846:	ff 4d fc             	decl   -0x4(%ebp)
  801849:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184c:	8a 10                	mov    (%eax),%dl
  80184e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801851:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801853:	8b 45 10             	mov    0x10(%ebp),%eax
  801856:	8d 50 ff             	lea    -0x1(%eax),%edx
  801859:	89 55 10             	mov    %edx,0x10(%ebp)
  80185c:	85 c0                	test   %eax,%eax
  80185e:	75 e3                	jne    801843 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801860:	eb 23                	jmp    801885 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801862:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801865:	8d 50 01             	lea    0x1(%eax),%edx
  801868:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80186b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80186e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801871:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801874:	8a 12                	mov    (%edx),%dl
  801876:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801878:	8b 45 10             	mov    0x10(%ebp),%eax
  80187b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80187e:	89 55 10             	mov    %edx,0x10(%ebp)
  801881:	85 c0                	test   %eax,%eax
  801883:	75 dd                	jne    801862 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801896:	8b 45 0c             	mov    0xc(%ebp),%eax
  801899:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80189c:	eb 2a                	jmp    8018c8 <memcmp+0x3e>
		if (*s1 != *s2)
  80189e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a1:	8a 10                	mov    (%eax),%dl
  8018a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a6:	8a 00                	mov    (%eax),%al
  8018a8:	38 c2                	cmp    %al,%dl
  8018aa:	74 16                	je     8018c2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	0f b6 d0             	movzbl %al,%edx
  8018b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b7:	8a 00                	mov    (%eax),%al
  8018b9:	0f b6 c0             	movzbl %al,%eax
  8018bc:	29 c2                	sub    %eax,%edx
  8018be:	89 d0                	mov    %edx,%eax
  8018c0:	eb 18                	jmp    8018da <memcmp+0x50>
		s1++, s2++;
  8018c2:	ff 45 fc             	incl   -0x4(%ebp)
  8018c5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	75 c9                	jne    80189e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 d0                	add    %edx,%eax
  8018ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018ed:	eb 15                	jmp    801904 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	8a 00                	mov    (%eax),%al
  8018f4:	0f b6 d0             	movzbl %al,%edx
  8018f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fa:	0f b6 c0             	movzbl %al,%eax
  8018fd:	39 c2                	cmp    %eax,%edx
  8018ff:	74 0d                	je     80190e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801901:	ff 45 08             	incl   0x8(%ebp)
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80190a:	72 e3                	jb     8018ef <memfind+0x13>
  80190c:	eb 01                	jmp    80190f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80190e:	90                   	nop
	return (void *) s;
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80191a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801921:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801928:	eb 03                	jmp    80192d <strtol+0x19>
		s++;
  80192a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	8a 00                	mov    (%eax),%al
  801932:	3c 20                	cmp    $0x20,%al
  801934:	74 f4                	je     80192a <strtol+0x16>
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	8a 00                	mov    (%eax),%al
  80193b:	3c 09                	cmp    $0x9,%al
  80193d:	74 eb                	je     80192a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	8a 00                	mov    (%eax),%al
  801944:	3c 2b                	cmp    $0x2b,%al
  801946:	75 05                	jne    80194d <strtol+0x39>
		s++;
  801948:	ff 45 08             	incl   0x8(%ebp)
  80194b:	eb 13                	jmp    801960 <strtol+0x4c>
	else if (*s == '-')
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	8a 00                	mov    (%eax),%al
  801952:	3c 2d                	cmp    $0x2d,%al
  801954:	75 0a                	jne    801960 <strtol+0x4c>
		s++, neg = 1;
  801956:	ff 45 08             	incl   0x8(%ebp)
  801959:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801960:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801964:	74 06                	je     80196c <strtol+0x58>
  801966:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80196a:	75 20                	jne    80198c <strtol+0x78>
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	8a 00                	mov    (%eax),%al
  801971:	3c 30                	cmp    $0x30,%al
  801973:	75 17                	jne    80198c <strtol+0x78>
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	40                   	inc    %eax
  801979:	8a 00                	mov    (%eax),%al
  80197b:	3c 78                	cmp    $0x78,%al
  80197d:	75 0d                	jne    80198c <strtol+0x78>
		s += 2, base = 16;
  80197f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801983:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80198a:	eb 28                	jmp    8019b4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80198c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801990:	75 15                	jne    8019a7 <strtol+0x93>
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	8a 00                	mov    (%eax),%al
  801997:	3c 30                	cmp    $0x30,%al
  801999:	75 0c                	jne    8019a7 <strtol+0x93>
		s++, base = 8;
  80199b:	ff 45 08             	incl   0x8(%ebp)
  80199e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019a5:	eb 0d                	jmp    8019b4 <strtol+0xa0>
	else if (base == 0)
  8019a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019ab:	75 07                	jne    8019b4 <strtol+0xa0>
		base = 10;
  8019ad:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	8a 00                	mov    (%eax),%al
  8019b9:	3c 2f                	cmp    $0x2f,%al
  8019bb:	7e 19                	jle    8019d6 <strtol+0xc2>
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8a 00                	mov    (%eax),%al
  8019c2:	3c 39                	cmp    $0x39,%al
  8019c4:	7f 10                	jg     8019d6 <strtol+0xc2>
			dig = *s - '0';
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	0f be c0             	movsbl %al,%eax
  8019ce:	83 e8 30             	sub    $0x30,%eax
  8019d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019d4:	eb 42                	jmp    801a18 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	8a 00                	mov    (%eax),%al
  8019db:	3c 60                	cmp    $0x60,%al
  8019dd:	7e 19                	jle    8019f8 <strtol+0xe4>
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8a 00                	mov    (%eax),%al
  8019e4:	3c 7a                	cmp    $0x7a,%al
  8019e6:	7f 10                	jg     8019f8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	0f be c0             	movsbl %al,%eax
  8019f0:	83 e8 57             	sub    $0x57,%eax
  8019f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019f6:	eb 20                	jmp    801a18 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	8a 00                	mov    (%eax),%al
  8019fd:	3c 40                	cmp    $0x40,%al
  8019ff:	7e 39                	jle    801a3a <strtol+0x126>
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	3c 5a                	cmp    $0x5a,%al
  801a08:	7f 30                	jg     801a3a <strtol+0x126>
			dig = *s - 'A' + 10;
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	0f be c0             	movsbl %al,%eax
  801a12:	83 e8 37             	sub    $0x37,%eax
  801a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1b:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a1e:	7d 19                	jge    801a39 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a20:	ff 45 08             	incl   0x8(%ebp)
  801a23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a26:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a2a:	89 c2                	mov    %eax,%edx
  801a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2f:	01 d0                	add    %edx,%eax
  801a31:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a34:	e9 7b ff ff ff       	jmp    8019b4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a39:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a3e:	74 08                	je     801a48 <strtol+0x134>
		*endptr = (char *) s;
  801a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a43:	8b 55 08             	mov    0x8(%ebp),%edx
  801a46:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a48:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a4c:	74 07                	je     801a55 <strtol+0x141>
  801a4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a51:	f7 d8                	neg    %eax
  801a53:	eb 03                	jmp    801a58 <strtol+0x144>
  801a55:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <ltostr>:

void
ltostr(long value, char *str)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a67:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a72:	79 13                	jns    801a87 <ltostr+0x2d>
	{
		neg = 1;
  801a74:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a81:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a84:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a8f:	99                   	cltd   
  801a90:	f7 f9                	idiv   %ecx
  801a92:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a98:	8d 50 01             	lea    0x1(%eax),%edx
  801a9b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a9e:	89 c2                	mov    %eax,%edx
  801aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa3:	01 d0                	add    %edx,%eax
  801aa5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801aa8:	83 c2 30             	add    $0x30,%edx
  801aab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801aad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ab5:	f7 e9                	imul   %ecx
  801ab7:	c1 fa 02             	sar    $0x2,%edx
  801aba:	89 c8                	mov    %ecx,%eax
  801abc:	c1 f8 1f             	sar    $0x1f,%eax
  801abf:	29 c2                	sub    %eax,%edx
  801ac1:	89 d0                	mov    %edx,%eax
  801ac3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801ac6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ac9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ace:	f7 e9                	imul   %ecx
  801ad0:	c1 fa 02             	sar    $0x2,%edx
  801ad3:	89 c8                	mov    %ecx,%eax
  801ad5:	c1 f8 1f             	sar    $0x1f,%eax
  801ad8:	29 c2                	sub    %eax,%edx
  801ada:	89 d0                	mov    %edx,%eax
  801adc:	c1 e0 02             	shl    $0x2,%eax
  801adf:	01 d0                	add    %edx,%eax
  801ae1:	01 c0                	add    %eax,%eax
  801ae3:	29 c1                	sub    %eax,%ecx
  801ae5:	89 ca                	mov    %ecx,%edx
  801ae7:	85 d2                	test   %edx,%edx
  801ae9:	75 9c                	jne    801a87 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801aeb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801af2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801af5:	48                   	dec    %eax
  801af6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801af9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801afd:	74 3d                	je     801b3c <ltostr+0xe2>
		start = 1 ;
  801aff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b06:	eb 34                	jmp    801b3c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0e:	01 d0                	add    %edx,%eax
  801b10:	8a 00                	mov    (%eax),%al
  801b12:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1b:	01 c2                	add    %eax,%edx
  801b1d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b23:	01 c8                	add    %ecx,%eax
  801b25:	8a 00                	mov    (%eax),%al
  801b27:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2f:	01 c2                	add    %eax,%edx
  801b31:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b34:	88 02                	mov    %al,(%edx)
		start++ ;
  801b36:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b39:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b42:	7c c4                	jl     801b08 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b44:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4a:	01 d0                	add    %edx,%eax
  801b4c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b4f:	90                   	nop
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b58:	ff 75 08             	pushl  0x8(%ebp)
  801b5b:	e8 54 fa ff ff       	call   8015b4 <strlen>
  801b60:	83 c4 04             	add    $0x4,%esp
  801b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	e8 46 fa ff ff       	call   8015b4 <strlen>
  801b6e:	83 c4 04             	add    $0x4,%esp
  801b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b82:	eb 17                	jmp    801b9b <strcconcat+0x49>
		final[s] = str1[s] ;
  801b84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b87:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8a:	01 c2                	add    %eax,%edx
  801b8c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	01 c8                	add    %ecx,%eax
  801b94:	8a 00                	mov    (%eax),%al
  801b96:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b98:	ff 45 fc             	incl   -0x4(%ebp)
  801b9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b9e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ba1:	7c e1                	jl     801b84 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801ba3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801baa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bb1:	eb 1f                	jmp    801bd2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bb6:	8d 50 01             	lea    0x1(%eax),%edx
  801bb9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bbc:	89 c2                	mov    %eax,%edx
  801bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc1:	01 c2                	add    %eax,%edx
  801bc3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc9:	01 c8                	add    %ecx,%eax
  801bcb:	8a 00                	mov    (%eax),%al
  801bcd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bcf:	ff 45 f8             	incl   -0x8(%ebp)
  801bd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bd5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bd8:	7c d9                	jl     801bb3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801bda:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bdd:	8b 45 10             	mov    0x10(%ebp),%eax
  801be0:	01 d0                	add    %edx,%eax
  801be2:	c6 00 00             	movb   $0x0,(%eax)
}
  801be5:	90                   	nop
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801beb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf7:	8b 00                	mov    (%eax),%eax
  801bf9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c00:	8b 45 10             	mov    0x10(%ebp),%eax
  801c03:	01 d0                	add    %edx,%eax
  801c05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c0b:	eb 0c                	jmp    801c19 <strsplit+0x31>
			*string++ = 0;
  801c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c10:	8d 50 01             	lea    0x1(%eax),%edx
  801c13:	89 55 08             	mov    %edx,0x8(%ebp)
  801c16:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	8a 00                	mov    (%eax),%al
  801c1e:	84 c0                	test   %al,%al
  801c20:	74 18                	je     801c3a <strsplit+0x52>
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	8a 00                	mov    (%eax),%al
  801c27:	0f be c0             	movsbl %al,%eax
  801c2a:	50                   	push   %eax
  801c2b:	ff 75 0c             	pushl  0xc(%ebp)
  801c2e:	e8 13 fb ff ff       	call   801746 <strchr>
  801c33:	83 c4 08             	add    $0x8,%esp
  801c36:	85 c0                	test   %eax,%eax
  801c38:	75 d3                	jne    801c0d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	8a 00                	mov    (%eax),%al
  801c3f:	84 c0                	test   %al,%al
  801c41:	74 5a                	je     801c9d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c43:	8b 45 14             	mov    0x14(%ebp),%eax
  801c46:	8b 00                	mov    (%eax),%eax
  801c48:	83 f8 0f             	cmp    $0xf,%eax
  801c4b:	75 07                	jne    801c54 <strsplit+0x6c>
		{
			return 0;
  801c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c52:	eb 66                	jmp    801cba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c54:	8b 45 14             	mov    0x14(%ebp),%eax
  801c57:	8b 00                	mov    (%eax),%eax
  801c59:	8d 48 01             	lea    0x1(%eax),%ecx
  801c5c:	8b 55 14             	mov    0x14(%ebp),%edx
  801c5f:	89 0a                	mov    %ecx,(%edx)
  801c61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	01 c2                	add    %eax,%edx
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c72:	eb 03                	jmp    801c77 <strsplit+0x8f>
			string++;
  801c74:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	8a 00                	mov    (%eax),%al
  801c7c:	84 c0                	test   %al,%al
  801c7e:	74 8b                	je     801c0b <strsplit+0x23>
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	8a 00                	mov    (%eax),%al
  801c85:	0f be c0             	movsbl %al,%eax
  801c88:	50                   	push   %eax
  801c89:	ff 75 0c             	pushl  0xc(%ebp)
  801c8c:	e8 b5 fa ff ff       	call   801746 <strchr>
  801c91:	83 c4 08             	add    $0x8,%esp
  801c94:	85 c0                	test   %eax,%eax
  801c96:	74 dc                	je     801c74 <strsplit+0x8c>
			string++;
	}
  801c98:	e9 6e ff ff ff       	jmp    801c0b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c9d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	8b 00                	mov    (%eax),%eax
  801ca3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801caa:	8b 45 10             	mov    0x10(%ebp),%eax
  801cad:	01 d0                	add    %edx,%eax
  801caf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cb5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801cc2:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  801ccc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801ccf:	01 d0                	add    %edx,%eax
  801cd1:	48                   	dec    %eax
  801cd2:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801cd5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801cd8:	ba 00 00 00 00       	mov    $0x0,%edx
  801cdd:	f7 75 ac             	divl   -0x54(%ebp)
  801ce0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801ce3:	29 d0                	sub    %edx,%eax
  801ce5:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801ce8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801cef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801cf6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801cfd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801d04:	eb 3f                	jmp    801d45 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801d06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d09:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801d10:	83 ec 04             	sub    $0x4,%esp
  801d13:	50                   	push   %eax
  801d14:	ff 75 e8             	pushl  -0x18(%ebp)
  801d17:	68 10 36 80 00       	push   $0x803610
  801d1c:	e8 11 f2 ff ff       	call   800f32 <cprintf>
  801d21:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801d24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d27:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801d2e:	83 ec 04             	sub    $0x4,%esp
  801d31:	50                   	push   %eax
  801d32:	ff 75 e8             	pushl  -0x18(%ebp)
  801d35:	68 25 36 80 00       	push   $0x803625
  801d3a:	e8 f3 f1 ff ff       	call   800f32 <cprintf>
  801d3f:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801d42:	ff 45 e8             	incl   -0x18(%ebp)
  801d45:	a1 28 40 80 00       	mov    0x804028,%eax
  801d4a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801d4d:	7c b7                	jl     801d06 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801d4f:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801d56:	e9 42 01 00 00       	jmp    801e9d <malloc+0x1e1>
		int flag0=1;
  801d5b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801d62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d65:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d68:	eb 6b                	jmp    801dd5 <malloc+0x119>
			for(int k=0;k<count;k++){
  801d6a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801d71:	eb 42                	jmp    801db5 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801d73:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d76:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801d7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d80:	39 c2                	cmp    %eax,%edx
  801d82:	77 2e                	ja     801db2 <malloc+0xf6>
  801d84:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d87:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801d8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d91:	39 c2                	cmp    %eax,%edx
  801d93:	76 1d                	jbe    801db2 <malloc+0xf6>
					ni=arr_add[k].end-i;
  801d95:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d98:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801d9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801da2:	29 c2                	sub    %eax,%edx
  801da4:	89 d0                	mov    %edx,%eax
  801da6:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801da9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801db0:	eb 0d                	jmp    801dbf <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801db2:	ff 45 d8             	incl   -0x28(%ebp)
  801db5:	a1 28 40 80 00       	mov    0x804028,%eax
  801dba:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801dbd:	7c b4                	jl     801d73 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801dbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dc3:	74 09                	je     801dce <malloc+0x112>
				flag0=0;
  801dc5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801dcc:	eb 16                	jmp    801de4 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801dce:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801dd5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddb:	01 c2                	add    %eax,%edx
  801ddd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801de0:	39 c2                	cmp    %eax,%edx
  801de2:	77 86                	ja     801d6a <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801de4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801de8:	0f 84 a2 00 00 00    	je     801e90 <malloc+0x1d4>

			int f=1;
  801dee:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801df5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801df8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801dfb:	89 c8                	mov    %ecx,%eax
  801dfd:	01 c0                	add    %eax,%eax
  801dff:	01 c8                	add    %ecx,%eax
  801e01:	c1 e0 02             	shl    $0x2,%eax
  801e04:	05 20 41 80 00       	add    $0x804120,%eax
  801e09:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801e0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801e14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e17:	89 d0                	mov    %edx,%eax
  801e19:	01 c0                	add    %eax,%eax
  801e1b:	01 d0                	add    %edx,%eax
  801e1d:	c1 e0 02             	shl    $0x2,%eax
  801e20:	05 24 41 80 00       	add    $0x804124,%eax
  801e25:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801e27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2a:	89 d0                	mov    %edx,%eax
  801e2c:	01 c0                	add    %eax,%eax
  801e2e:	01 d0                	add    %edx,%eax
  801e30:	c1 e0 02             	shl    $0x2,%eax
  801e33:	05 28 41 80 00       	add    $0x804128,%eax
  801e38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801e3e:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801e41:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801e48:	eb 36                	jmp    801e80 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801e4a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e50:	01 c2                	add    %eax,%edx
  801e52:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e55:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801e5c:	39 c2                	cmp    %eax,%edx
  801e5e:	73 1d                	jae    801e7d <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801e60:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e63:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801e6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e6d:	29 c2                	sub    %eax,%edx
  801e6f:	89 d0                	mov    %edx,%eax
  801e71:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801e74:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801e7b:	eb 0d                	jmp    801e8a <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801e7d:	ff 45 d0             	incl   -0x30(%ebp)
  801e80:	a1 28 40 80 00       	mov    0x804028,%eax
  801e85:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801e88:	7c c0                	jl     801e4a <malloc+0x18e>
					break;

				}
			}

			if(f){
  801e8a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801e8e:	75 1d                	jne    801ead <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801e90:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801e97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e9a:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801e9d:	a1 04 40 80 00       	mov    0x804004,%eax
  801ea2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ea5:	0f 8c b0 fe ff ff    	jl     801d5b <malloc+0x9f>
  801eab:	eb 01                	jmp    801eae <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801ead:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801eae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb2:	75 7a                	jne    801f2e <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801eb4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	01 d0                	add    %edx,%eax
  801ebf:	48                   	dec    %eax
  801ec0:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801ec5:	7c 0a                	jl     801ed1 <malloc+0x215>
			return NULL;
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecc:	e9 a4 02 00 00       	jmp    802175 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801ed1:	a1 04 40 80 00       	mov    0x804004,%eax
  801ed6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801ed9:	a1 28 40 80 00       	mov    0x804028,%eax
  801ede:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801ee1:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801ee8:	83 ec 08             	sub    $0x8,%esp
  801eeb:	ff 75 08             	pushl  0x8(%ebp)
  801eee:	ff 75 a4             	pushl  -0x5c(%ebp)
  801ef1:	e8 04 06 00 00       	call   8024fa <sys_allocateMem>
  801ef6:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801ef9:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	01 d0                	add    %edx,%eax
  801f04:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801f09:	a1 28 40 80 00       	mov    0x804028,%eax
  801f0e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f14:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801f1b:	a1 28 40 80 00       	mov    0x804028,%eax
  801f20:	40                   	inc    %eax
  801f21:	a3 28 40 80 00       	mov    %eax,0x804028

			return (void*)s;
  801f26:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801f29:	e9 47 02 00 00       	jmp    802175 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801f2e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801f35:	e9 ac 00 00 00       	jmp    801fe6 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801f3a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801f3d:	89 d0                	mov    %edx,%eax
  801f3f:	01 c0                	add    %eax,%eax
  801f41:	01 d0                	add    %edx,%eax
  801f43:	c1 e0 02             	shl    $0x2,%eax
  801f46:	05 24 41 80 00       	add    $0x804124,%eax
  801f4b:	8b 00                	mov    (%eax),%eax
  801f4d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801f50:	eb 7e                	jmp    801fd0 <malloc+0x314>
			int flag=0;
  801f52:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801f59:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801f60:	eb 57                	jmp    801fb9 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801f62:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f65:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801f6c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f6f:	39 c2                	cmp    %eax,%edx
  801f71:	77 1a                	ja     801f8d <malloc+0x2d1>
  801f73:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f76:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801f7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f80:	39 c2                	cmp    %eax,%edx
  801f82:	76 09                	jbe    801f8d <malloc+0x2d1>
								flag=1;
  801f84:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801f8b:	eb 36                	jmp    801fc3 <malloc+0x307>
			arr[i].space++;
  801f8d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801f90:	89 d0                	mov    %edx,%eax
  801f92:	01 c0                	add    %eax,%eax
  801f94:	01 d0                	add    %edx,%eax
  801f96:	c1 e0 02             	shl    $0x2,%eax
  801f99:	05 28 41 80 00       	add    $0x804128,%eax
  801f9e:	8b 00                	mov    (%eax),%eax
  801fa0:	8d 48 01             	lea    0x1(%eax),%ecx
  801fa3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801fa6:	89 d0                	mov    %edx,%eax
  801fa8:	01 c0                	add    %eax,%eax
  801faa:	01 d0                	add    %edx,%eax
  801fac:	c1 e0 02             	shl    $0x2,%eax
  801faf:	05 28 41 80 00       	add    $0x804128,%eax
  801fb4:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801fb6:	ff 45 c0             	incl   -0x40(%ebp)
  801fb9:	a1 28 40 80 00       	mov    0x804028,%eax
  801fbe:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801fc1:	7c 9f                	jl     801f62 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801fc3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801fc7:	75 19                	jne    801fe2 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801fc9:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801fd0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801fd3:	a1 04 40 80 00       	mov    0x804004,%eax
  801fd8:	39 c2                	cmp    %eax,%edx
  801fda:	0f 82 72 ff ff ff    	jb     801f52 <malloc+0x296>
  801fe0:	eb 01                	jmp    801fe3 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801fe2:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801fe3:	ff 45 cc             	incl   -0x34(%ebp)
  801fe6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fe9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801fec:	0f 8c 48 ff ff ff    	jl     801f3a <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801ff2:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801ff9:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  802000:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  802007:	eb 37                	jmp    802040 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  802009:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80200c:	89 d0                	mov    %edx,%eax
  80200e:	01 c0                	add    %eax,%eax
  802010:	01 d0                	add    %edx,%eax
  802012:	c1 e0 02             	shl    $0x2,%eax
  802015:	05 28 41 80 00       	add    $0x804128,%eax
  80201a:	8b 00                	mov    (%eax),%eax
  80201c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80201f:	7d 1c                	jge    80203d <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  802021:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  802024:	89 d0                	mov    %edx,%eax
  802026:	01 c0                	add    %eax,%eax
  802028:	01 d0                	add    %edx,%eax
  80202a:	c1 e0 02             	shl    $0x2,%eax
  80202d:	05 28 41 80 00       	add    $0x804128,%eax
  802032:	8b 00                	mov    (%eax),%eax
  802034:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  802037:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80203a:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  80203d:	ff 45 b4             	incl   -0x4c(%ebp)
  802040:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802043:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802046:	7c c1                	jl     802009 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  802048:	8b 15 28 40 80 00    	mov    0x804028,%edx
  80204e:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  802051:	89 c8                	mov    %ecx,%eax
  802053:	01 c0                	add    %eax,%eax
  802055:	01 c8                	add    %ecx,%eax
  802057:	c1 e0 02             	shl    $0x2,%eax
  80205a:	05 20 41 80 00       	add    $0x804120,%eax
  80205f:	8b 00                	mov    (%eax),%eax
  802061:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  802068:	8b 15 28 40 80 00    	mov    0x804028,%edx
  80206e:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  802071:	89 c8                	mov    %ecx,%eax
  802073:	01 c0                	add    %eax,%eax
  802075:	01 c8                	add    %ecx,%eax
  802077:	c1 e0 02             	shl    $0x2,%eax
  80207a:	05 24 41 80 00       	add    $0x804124,%eax
  80207f:	8b 00                	mov    (%eax),%eax
  802081:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  802088:	a1 28 40 80 00       	mov    0x804028,%eax
  80208d:	40                   	inc    %eax
  80208e:	a3 28 40 80 00       	mov    %eax,0x804028


		sys_allocateMem(arr[index].start,size);
  802093:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802096:	89 d0                	mov    %edx,%eax
  802098:	01 c0                	add    %eax,%eax
  80209a:	01 d0                	add    %edx,%eax
  80209c:	c1 e0 02             	shl    $0x2,%eax
  80209f:	05 20 41 80 00       	add    $0x804120,%eax
  8020a4:	8b 00                	mov    (%eax),%eax
  8020a6:	83 ec 08             	sub    $0x8,%esp
  8020a9:	ff 75 08             	pushl  0x8(%ebp)
  8020ac:	50                   	push   %eax
  8020ad:	e8 48 04 00 00       	call   8024fa <sys_allocateMem>
  8020b2:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  8020b5:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8020bc:	eb 78                	jmp    802136 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8020be:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8020c1:	89 d0                	mov    %edx,%eax
  8020c3:	01 c0                	add    %eax,%eax
  8020c5:	01 d0                	add    %edx,%eax
  8020c7:	c1 e0 02             	shl    $0x2,%eax
  8020ca:	05 20 41 80 00       	add    $0x804120,%eax
  8020cf:	8b 00                	mov    (%eax),%eax
  8020d1:	83 ec 04             	sub    $0x4,%esp
  8020d4:	50                   	push   %eax
  8020d5:	ff 75 b0             	pushl  -0x50(%ebp)
  8020d8:	68 10 36 80 00       	push   $0x803610
  8020dd:	e8 50 ee ff ff       	call   800f32 <cprintf>
  8020e2:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8020e5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8020e8:	89 d0                	mov    %edx,%eax
  8020ea:	01 c0                	add    %eax,%eax
  8020ec:	01 d0                	add    %edx,%eax
  8020ee:	c1 e0 02             	shl    $0x2,%eax
  8020f1:	05 24 41 80 00       	add    $0x804124,%eax
  8020f6:	8b 00                	mov    (%eax),%eax
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	50                   	push   %eax
  8020fc:	ff 75 b0             	pushl  -0x50(%ebp)
  8020ff:	68 25 36 80 00       	push   $0x803625
  802104:	e8 29 ee ff ff       	call   800f32 <cprintf>
  802109:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  80210c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80210f:	89 d0                	mov    %edx,%eax
  802111:	01 c0                	add    %eax,%eax
  802113:	01 d0                	add    %edx,%eax
  802115:	c1 e0 02             	shl    $0x2,%eax
  802118:	05 28 41 80 00       	add    $0x804128,%eax
  80211d:	8b 00                	mov    (%eax),%eax
  80211f:	83 ec 04             	sub    $0x4,%esp
  802122:	50                   	push   %eax
  802123:	ff 75 b0             	pushl  -0x50(%ebp)
  802126:	68 38 36 80 00       	push   $0x803638
  80212b:	e8 02 ee ff ff       	call   800f32 <cprintf>
  802130:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  802133:	ff 45 b0             	incl   -0x50(%ebp)
  802136:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802139:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80213c:	7c 80                	jl     8020be <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  80213e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802141:	89 d0                	mov    %edx,%eax
  802143:	01 c0                	add    %eax,%eax
  802145:	01 d0                	add    %edx,%eax
  802147:	c1 e0 02             	shl    $0x2,%eax
  80214a:	05 20 41 80 00       	add    $0x804120,%eax
  80214f:	8b 00                	mov    (%eax),%eax
  802151:	83 ec 08             	sub    $0x8,%esp
  802154:	50                   	push   %eax
  802155:	68 4c 36 80 00       	push   $0x80364c
  80215a:	e8 d3 ed ff ff       	call   800f32 <cprintf>
  80215f:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  802162:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802165:	89 d0                	mov    %edx,%eax
  802167:	01 c0                	add    %eax,%eax
  802169:	01 d0                	add    %edx,%eax
  80216b:	c1 e0 02             	shl    $0x2,%eax
  80216e:	05 20 41 80 00       	add    $0x804120,%eax
  802173:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  802183:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80218a:	eb 4b                	jmp    8021d7 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  80218c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80218f:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  802196:	89 c2                	mov    %eax,%edx
  802198:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80219b:	39 c2                	cmp    %eax,%edx
  80219d:	7f 35                	jg     8021d4 <free+0x5d>
  80219f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a2:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  8021a9:	89 c2                	mov    %eax,%edx
  8021ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021ae:	39 c2                	cmp    %eax,%edx
  8021b0:	7e 22                	jle    8021d4 <free+0x5d>
				start=arr_add[i].start;
  8021b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b5:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  8021bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8021bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c2:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  8021c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8021cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8021d2:	eb 0d                	jmp    8021e1 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8021d4:	ff 45 ec             	incl   -0x14(%ebp)
  8021d7:	a1 28 40 80 00       	mov    0x804028,%eax
  8021dc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8021df:	7c ab                	jl     80218c <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8021e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e4:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  8021eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ee:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  8021f5:	29 c2                	sub    %eax,%edx
  8021f7:	89 d0                	mov    %edx,%eax
  8021f9:	83 ec 08             	sub    $0x8,%esp
  8021fc:	50                   	push   %eax
  8021fd:	ff 75 f4             	pushl  -0xc(%ebp)
  802200:	e8 d9 02 00 00       	call   8024de <sys_freeMem>
  802205:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  802208:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80220e:	eb 2d                	jmp    80223d <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  802210:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802213:	40                   	inc    %eax
  802214:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  80221b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80221e:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  802225:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802228:	40                   	inc    %eax
  802229:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  802230:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802233:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  80223a:	ff 45 e8             	incl   -0x18(%ebp)
  80223d:	a1 28 40 80 00       	mov    0x804028,%eax
  802242:	48                   	dec    %eax
  802243:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802246:	7f c8                	jg     802210 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  802248:	a1 28 40 80 00       	mov    0x804028,%eax
  80224d:	48                   	dec    %eax
  80224e:	a3 28 40 80 00       	mov    %eax,0x804028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  802253:	90                   	nop
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 18             	sub    $0x18,%esp
  80225c:	8b 45 10             	mov    0x10(%ebp),%eax
  80225f:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  802262:	83 ec 04             	sub    $0x4,%esp
  802265:	68 68 36 80 00       	push   $0x803668
  80226a:	68 18 01 00 00       	push   $0x118
  80226f:	68 8b 36 80 00       	push   $0x80368b
  802274:	e8 17 ea ff ff       	call   800c90 <_panic>

00802279 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80227f:	83 ec 04             	sub    $0x4,%esp
  802282:	68 68 36 80 00       	push   $0x803668
  802287:	68 1e 01 00 00       	push   $0x11e
  80228c:	68 8b 36 80 00       	push   $0x80368b
  802291:	e8 fa e9 ff ff       	call   800c90 <_panic>

00802296 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80229c:	83 ec 04             	sub    $0x4,%esp
  80229f:	68 68 36 80 00       	push   $0x803668
  8022a4:	68 24 01 00 00       	push   $0x124
  8022a9:	68 8b 36 80 00       	push   $0x80368b
  8022ae:	e8 dd e9 ff ff       	call   800c90 <_panic>

008022b3 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
  8022b6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8022b9:	83 ec 04             	sub    $0x4,%esp
  8022bc:	68 68 36 80 00       	push   $0x803668
  8022c1:	68 29 01 00 00       	push   $0x129
  8022c6:	68 8b 36 80 00       	push   $0x80368b
  8022cb:	e8 c0 e9 ff ff       	call   800c90 <_panic>

008022d0 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8022d6:	83 ec 04             	sub    $0x4,%esp
  8022d9:	68 68 36 80 00       	push   $0x803668
  8022de:	68 2f 01 00 00       	push   $0x12f
  8022e3:	68 8b 36 80 00       	push   $0x80368b
  8022e8:	e8 a3 e9 ff ff       	call   800c90 <_panic>

008022ed <shrink>:
}
void shrink(uint32 newSize)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
  8022f0:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8022f3:	83 ec 04             	sub    $0x4,%esp
  8022f6:	68 68 36 80 00       	push   $0x803668
  8022fb:	68 33 01 00 00       	push   $0x133
  802300:	68 8b 36 80 00       	push   $0x80368b
  802305:	e8 86 e9 ff ff       	call   800c90 <_panic>

0080230a <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
  80230d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802310:	83 ec 04             	sub    $0x4,%esp
  802313:	68 68 36 80 00       	push   $0x803668
  802318:	68 38 01 00 00       	push   $0x138
  80231d:	68 8b 36 80 00       	push   $0x80368b
  802322:	e8 69 e9 ff ff       	call   800c90 <_panic>

00802327 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	57                   	push   %edi
  80232b:	56                   	push   %esi
  80232c:	53                   	push   %ebx
  80232d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	8b 55 0c             	mov    0xc(%ebp),%edx
  802336:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802339:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80233c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80233f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802342:	cd 30                	int    $0x30
  802344:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802347:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80234a:	83 c4 10             	add    $0x10,%esp
  80234d:	5b                   	pop    %ebx
  80234e:	5e                   	pop    %esi
  80234f:	5f                   	pop    %edi
  802350:	5d                   	pop    %ebp
  802351:	c3                   	ret    

00802352 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	83 ec 04             	sub    $0x4,%esp
  802358:	8b 45 10             	mov    0x10(%ebp),%eax
  80235b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80235e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	52                   	push   %edx
  80236a:	ff 75 0c             	pushl  0xc(%ebp)
  80236d:	50                   	push   %eax
  80236e:	6a 00                	push   $0x0
  802370:	e8 b2 ff ff ff       	call   802327 <syscall>
  802375:	83 c4 18             	add    $0x18,%esp
}
  802378:	90                   	nop
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <sys_cgetc>:

int
sys_cgetc(void)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 01                	push   $0x1
  80238a:	e8 98 ff ff ff       	call   802327 <syscall>
  80238f:	83 c4 18             	add    $0x18,%esp
}
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802397:	8b 45 08             	mov    0x8(%ebp),%eax
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	50                   	push   %eax
  8023a3:	6a 05                	push   $0x5
  8023a5:	e8 7d ff ff ff       	call   802327 <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
}
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    

008023af <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 02                	push   $0x2
  8023be:	e8 64 ff ff ff       	call   802327 <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 03                	push   $0x3
  8023d7:	e8 4b ff ff ff       	call   802327 <syscall>
  8023dc:	83 c4 18             	add    $0x18,%esp
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 04                	push   $0x4
  8023f0:	e8 32 ff ff ff       	call   802327 <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
}
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <sys_env_exit>:


void sys_env_exit(void)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 06                	push   $0x6
  802409:	e8 19 ff ff ff       	call   802327 <syscall>
  80240e:	83 c4 18             	add    $0x18,%esp
}
  802411:	90                   	nop
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802417:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	52                   	push   %edx
  802424:	50                   	push   %eax
  802425:	6a 07                	push   $0x7
  802427:	e8 fb fe ff ff       	call   802327 <syscall>
  80242c:	83 c4 18             	add    $0x18,%esp
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	56                   	push   %esi
  802435:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802436:	8b 75 18             	mov    0x18(%ebp),%esi
  802439:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80243c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80243f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	56                   	push   %esi
  802446:	53                   	push   %ebx
  802447:	51                   	push   %ecx
  802448:	52                   	push   %edx
  802449:	50                   	push   %eax
  80244a:	6a 08                	push   $0x8
  80244c:	e8 d6 fe ff ff       	call   802327 <syscall>
  802451:	83 c4 18             	add    $0x18,%esp
}
  802454:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802457:	5b                   	pop    %ebx
  802458:	5e                   	pop    %esi
  802459:	5d                   	pop    %ebp
  80245a:	c3                   	ret    

0080245b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80245e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	52                   	push   %edx
  80246b:	50                   	push   %eax
  80246c:	6a 09                	push   $0x9
  80246e:	e8 b4 fe ff ff       	call   802327 <syscall>
  802473:	83 c4 18             	add    $0x18,%esp
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	ff 75 0c             	pushl  0xc(%ebp)
  802484:	ff 75 08             	pushl  0x8(%ebp)
  802487:	6a 0a                	push   $0xa
  802489:	e8 99 fe ff ff       	call   802327 <syscall>
  80248e:	83 c4 18             	add    $0x18,%esp
}
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 0b                	push   $0xb
  8024a2:	e8 80 fe ff ff       	call   802327 <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 0c                	push   $0xc
  8024bb:	e8 67 fe ff ff       	call   802327 <syscall>
  8024c0:	83 c4 18             	add    $0x18,%esp
}
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    

008024c5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 0d                	push   $0xd
  8024d4:	e8 4e fe ff ff       	call   802327 <syscall>
  8024d9:	83 c4 18             	add    $0x18,%esp
}
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	ff 75 0c             	pushl  0xc(%ebp)
  8024ea:	ff 75 08             	pushl  0x8(%ebp)
  8024ed:	6a 11                	push   $0x11
  8024ef:	e8 33 fe ff ff       	call   802327 <syscall>
  8024f4:	83 c4 18             	add    $0x18,%esp
	return;
  8024f7:	90                   	nop
}
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    

008024fa <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	ff 75 0c             	pushl  0xc(%ebp)
  802506:	ff 75 08             	pushl  0x8(%ebp)
  802509:	6a 12                	push   $0x12
  80250b:	e8 17 fe ff ff       	call   802327 <syscall>
  802510:	83 c4 18             	add    $0x18,%esp
	return ;
  802513:	90                   	nop
}
  802514:	c9                   	leave  
  802515:	c3                   	ret    

00802516 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 0e                	push   $0xe
  802525:	e8 fd fd ff ff       	call   802327 <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	ff 75 08             	pushl  0x8(%ebp)
  80253d:	6a 0f                	push   $0xf
  80253f:	e8 e3 fd ff ff       	call   802327 <syscall>
  802544:	83 c4 18             	add    $0x18,%esp
}
  802547:	c9                   	leave  
  802548:	c3                   	ret    

00802549 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 10                	push   $0x10
  802558:	e8 ca fd ff ff       	call   802327 <syscall>
  80255d:	83 c4 18             	add    $0x18,%esp
}
  802560:	90                   	nop
  802561:	c9                   	leave  
  802562:	c3                   	ret    

00802563 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 14                	push   $0x14
  802572:	e8 b0 fd ff ff       	call   802327 <syscall>
  802577:	83 c4 18             	add    $0x18,%esp
}
  80257a:	90                   	nop
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    

0080257d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 15                	push   $0x15
  80258c:	e8 96 fd ff ff       	call   802327 <syscall>
  802591:	83 c4 18             	add    $0x18,%esp
}
  802594:	90                   	nop
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <sys_cputc>:


void
sys_cputc(const char c)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
  80259a:	83 ec 04             	sub    $0x4,%esp
  80259d:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8025a3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	50                   	push   %eax
  8025b0:	6a 16                	push   $0x16
  8025b2:	e8 70 fd ff ff       	call   802327 <syscall>
  8025b7:	83 c4 18             	add    $0x18,%esp
}
  8025ba:	90                   	nop
  8025bb:	c9                   	leave  
  8025bc:	c3                   	ret    

008025bd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 17                	push   $0x17
  8025cc:	e8 56 fd ff ff       	call   802327 <syscall>
  8025d1:	83 c4 18             	add    $0x18,%esp
}
  8025d4:	90                   	nop
  8025d5:	c9                   	leave  
  8025d6:	c3                   	ret    

008025d7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025da:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	ff 75 0c             	pushl  0xc(%ebp)
  8025e6:	50                   	push   %eax
  8025e7:	6a 18                	push   $0x18
  8025e9:	e8 39 fd ff ff       	call   802327 <syscall>
  8025ee:	83 c4 18             	add    $0x18,%esp
}
  8025f1:	c9                   	leave  
  8025f2:	c3                   	ret    

008025f3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8025f3:	55                   	push   %ebp
  8025f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	52                   	push   %edx
  802603:	50                   	push   %eax
  802604:	6a 1b                	push   $0x1b
  802606:	e8 1c fd ff ff       	call   802327 <syscall>
  80260b:	83 c4 18             	add    $0x18,%esp
}
  80260e:	c9                   	leave  
  80260f:	c3                   	ret    

00802610 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802613:	8b 55 0c             	mov    0xc(%ebp),%edx
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	52                   	push   %edx
  802620:	50                   	push   %eax
  802621:	6a 19                	push   $0x19
  802623:	e8 ff fc ff ff       	call   802327 <syscall>
  802628:	83 c4 18             	add    $0x18,%esp
}
  80262b:	90                   	nop
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802631:	8b 55 0c             	mov    0xc(%ebp),%edx
  802634:	8b 45 08             	mov    0x8(%ebp),%eax
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	52                   	push   %edx
  80263e:	50                   	push   %eax
  80263f:	6a 1a                	push   $0x1a
  802641:	e8 e1 fc ff ff       	call   802327 <syscall>
  802646:	83 c4 18             	add    $0x18,%esp
}
  802649:	90                   	nop
  80264a:	c9                   	leave  
  80264b:	c3                   	ret    

0080264c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	83 ec 04             	sub    $0x4,%esp
  802652:	8b 45 10             	mov    0x10(%ebp),%eax
  802655:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802658:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80265b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80265f:	8b 45 08             	mov    0x8(%ebp),%eax
  802662:	6a 00                	push   $0x0
  802664:	51                   	push   %ecx
  802665:	52                   	push   %edx
  802666:	ff 75 0c             	pushl  0xc(%ebp)
  802669:	50                   	push   %eax
  80266a:	6a 1c                	push   $0x1c
  80266c:	e8 b6 fc ff ff       	call   802327 <syscall>
  802671:	83 c4 18             	add    $0x18,%esp
}
  802674:	c9                   	leave  
  802675:	c3                   	ret    

00802676 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802679:	8b 55 0c             	mov    0xc(%ebp),%edx
  80267c:	8b 45 08             	mov    0x8(%ebp),%eax
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	52                   	push   %edx
  802686:	50                   	push   %eax
  802687:	6a 1d                	push   $0x1d
  802689:	e8 99 fc ff ff       	call   802327 <syscall>
  80268e:	83 c4 18             	add    $0x18,%esp
}
  802691:	c9                   	leave  
  802692:	c3                   	ret    

00802693 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802693:	55                   	push   %ebp
  802694:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802696:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269c:	8b 45 08             	mov    0x8(%ebp),%eax
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 00                	push   $0x0
  8026a3:	51                   	push   %ecx
  8026a4:	52                   	push   %edx
  8026a5:	50                   	push   %eax
  8026a6:	6a 1e                	push   $0x1e
  8026a8:	e8 7a fc ff ff       	call   802327 <syscall>
  8026ad:	83 c4 18             	add    $0x18,%esp
}
  8026b0:	c9                   	leave  
  8026b1:	c3                   	ret    

008026b2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8026b2:	55                   	push   %ebp
  8026b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8026b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	52                   	push   %edx
  8026c2:	50                   	push   %eax
  8026c3:	6a 1f                	push   $0x1f
  8026c5:	e8 5d fc ff ff       	call   802327 <syscall>
  8026ca:	83 c4 18             	add    $0x18,%esp
}
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    

008026cf <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 20                	push   $0x20
  8026de:	e8 44 fc ff ff       	call   802327 <syscall>
  8026e3:	83 c4 18             	add    $0x18,%esp
}
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ee:	6a 00                	push   $0x0
  8026f0:	ff 75 14             	pushl  0x14(%ebp)
  8026f3:	ff 75 10             	pushl  0x10(%ebp)
  8026f6:	ff 75 0c             	pushl  0xc(%ebp)
  8026f9:	50                   	push   %eax
  8026fa:	6a 21                	push   $0x21
  8026fc:	e8 26 fc ff ff       	call   802327 <syscall>
  802701:	83 c4 18             	add    $0x18,%esp
}
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802709:	8b 45 08             	mov    0x8(%ebp),%eax
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	50                   	push   %eax
  802715:	6a 22                	push   $0x22
  802717:	e8 0b fc ff ff       	call   802327 <syscall>
  80271c:	83 c4 18             	add    $0x18,%esp
}
  80271f:	90                   	nop
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802725:	8b 45 08             	mov    0x8(%ebp),%eax
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	50                   	push   %eax
  802731:	6a 23                	push   $0x23
  802733:	e8 ef fb ff ff       	call   802327 <syscall>
  802738:	83 c4 18             	add    $0x18,%esp
}
  80273b:	90                   	nop
  80273c:	c9                   	leave  
  80273d:	c3                   	ret    

0080273e <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
  802741:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802744:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802747:	8d 50 04             	lea    0x4(%eax),%edx
  80274a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80274d:	6a 00                	push   $0x0
  80274f:	6a 00                	push   $0x0
  802751:	6a 00                	push   $0x0
  802753:	52                   	push   %edx
  802754:	50                   	push   %eax
  802755:	6a 24                	push   $0x24
  802757:	e8 cb fb ff ff       	call   802327 <syscall>
  80275c:	83 c4 18             	add    $0x18,%esp
	return result;
  80275f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802762:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802765:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802768:	89 01                	mov    %eax,(%ecx)
  80276a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80276d:	8b 45 08             	mov    0x8(%ebp),%eax
  802770:	c9                   	leave  
  802771:	c2 04 00             	ret    $0x4

00802774 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	ff 75 10             	pushl  0x10(%ebp)
  80277e:	ff 75 0c             	pushl  0xc(%ebp)
  802781:	ff 75 08             	pushl  0x8(%ebp)
  802784:	6a 13                	push   $0x13
  802786:	e8 9c fb ff ff       	call   802327 <syscall>
  80278b:	83 c4 18             	add    $0x18,%esp
	return ;
  80278e:	90                   	nop
}
  80278f:	c9                   	leave  
  802790:	c3                   	ret    

00802791 <sys_rcr2>:
uint32 sys_rcr2()
{
  802791:	55                   	push   %ebp
  802792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 25                	push   $0x25
  8027a0:	e8 82 fb ff ff       	call   802327 <syscall>
  8027a5:	83 c4 18             	add    $0x18,%esp
}
  8027a8:	c9                   	leave  
  8027a9:	c3                   	ret    

008027aa <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027aa:	55                   	push   %ebp
  8027ab:	89 e5                	mov    %esp,%ebp
  8027ad:	83 ec 04             	sub    $0x4,%esp
  8027b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027b6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027ba:	6a 00                	push   $0x0
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	50                   	push   %eax
  8027c3:	6a 26                	push   $0x26
  8027c5:	e8 5d fb ff ff       	call   802327 <syscall>
  8027ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8027cd:	90                   	nop
}
  8027ce:	c9                   	leave  
  8027cf:	c3                   	ret    

008027d0 <rsttst>:
void rsttst()
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 28                	push   $0x28
  8027df:	e8 43 fb ff ff       	call   802327 <syscall>
  8027e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8027e7:	90                   	nop
}
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    

008027ea <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	83 ec 04             	sub    $0x4,%esp
  8027f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8027f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8027f6:	8b 55 18             	mov    0x18(%ebp),%edx
  8027f9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027fd:	52                   	push   %edx
  8027fe:	50                   	push   %eax
  8027ff:	ff 75 10             	pushl  0x10(%ebp)
  802802:	ff 75 0c             	pushl  0xc(%ebp)
  802805:	ff 75 08             	pushl  0x8(%ebp)
  802808:	6a 27                	push   $0x27
  80280a:	e8 18 fb ff ff       	call   802327 <syscall>
  80280f:	83 c4 18             	add    $0x18,%esp
	return ;
  802812:	90                   	nop
}
  802813:	c9                   	leave  
  802814:	c3                   	ret    

00802815 <chktst>:
void chktst(uint32 n)
{
  802815:	55                   	push   %ebp
  802816:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802818:	6a 00                	push   $0x0
  80281a:	6a 00                	push   $0x0
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	ff 75 08             	pushl  0x8(%ebp)
  802823:	6a 29                	push   $0x29
  802825:	e8 fd fa ff ff       	call   802327 <syscall>
  80282a:	83 c4 18             	add    $0x18,%esp
	return ;
  80282d:	90                   	nop
}
  80282e:	c9                   	leave  
  80282f:	c3                   	ret    

00802830 <inctst>:

void inctst()
{
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802833:	6a 00                	push   $0x0
  802835:	6a 00                	push   $0x0
  802837:	6a 00                	push   $0x0
  802839:	6a 00                	push   $0x0
  80283b:	6a 00                	push   $0x0
  80283d:	6a 2a                	push   $0x2a
  80283f:	e8 e3 fa ff ff       	call   802327 <syscall>
  802844:	83 c4 18             	add    $0x18,%esp
	return ;
  802847:	90                   	nop
}
  802848:	c9                   	leave  
  802849:	c3                   	ret    

0080284a <gettst>:
uint32 gettst()
{
  80284a:	55                   	push   %ebp
  80284b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	6a 2b                	push   $0x2b
  802859:	e8 c9 fa ff ff       	call   802327 <syscall>
  80285e:	83 c4 18             	add    $0x18,%esp
}
  802861:	c9                   	leave  
  802862:	c3                   	ret    

00802863 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802863:	55                   	push   %ebp
  802864:	89 e5                	mov    %esp,%ebp
  802866:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802869:	6a 00                	push   $0x0
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	6a 00                	push   $0x0
  802873:	6a 2c                	push   $0x2c
  802875:	e8 ad fa ff ff       	call   802327 <syscall>
  80287a:	83 c4 18             	add    $0x18,%esp
  80287d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802880:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802884:	75 07                	jne    80288d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802886:	b8 01 00 00 00       	mov    $0x1,%eax
  80288b:	eb 05                	jmp    802892 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80288d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802892:	c9                   	leave  
  802893:	c3                   	ret    

00802894 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802894:	55                   	push   %ebp
  802895:	89 e5                	mov    %esp,%ebp
  802897:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 2c                	push   $0x2c
  8028a6:	e8 7c fa ff ff       	call   802327 <syscall>
  8028ab:	83 c4 18             	add    $0x18,%esp
  8028ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8028b1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8028b5:	75 07                	jne    8028be <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8028b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8028bc:	eb 05                	jmp    8028c3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8028be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028c3:	c9                   	leave  
  8028c4:	c3                   	ret    

008028c5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8028c5:	55                   	push   %ebp
  8028c6:	89 e5                	mov    %esp,%ebp
  8028c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028cb:	6a 00                	push   $0x0
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 00                	push   $0x0
  8028d1:	6a 00                	push   $0x0
  8028d3:	6a 00                	push   $0x0
  8028d5:	6a 2c                	push   $0x2c
  8028d7:	e8 4b fa ff ff       	call   802327 <syscall>
  8028dc:	83 c4 18             	add    $0x18,%esp
  8028df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8028e2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8028e6:	75 07                	jne    8028ef <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8028e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ed:	eb 05                	jmp    8028f4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8028ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f4:	c9                   	leave  
  8028f5:	c3                   	ret    

008028f6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8028f6:	55                   	push   %ebp
  8028f7:	89 e5                	mov    %esp,%ebp
  8028f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028fc:	6a 00                	push   $0x0
  8028fe:	6a 00                	push   $0x0
  802900:	6a 00                	push   $0x0
  802902:	6a 00                	push   $0x0
  802904:	6a 00                	push   $0x0
  802906:	6a 2c                	push   $0x2c
  802908:	e8 1a fa ff ff       	call   802327 <syscall>
  80290d:	83 c4 18             	add    $0x18,%esp
  802910:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802913:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802917:	75 07                	jne    802920 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802919:	b8 01 00 00 00       	mov    $0x1,%eax
  80291e:	eb 05                	jmp    802925 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802920:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802925:	c9                   	leave  
  802926:	c3                   	ret    

00802927 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802927:	55                   	push   %ebp
  802928:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80292a:	6a 00                	push   $0x0
  80292c:	6a 00                	push   $0x0
  80292e:	6a 00                	push   $0x0
  802930:	6a 00                	push   $0x0
  802932:	ff 75 08             	pushl  0x8(%ebp)
  802935:	6a 2d                	push   $0x2d
  802937:	e8 eb f9 ff ff       	call   802327 <syscall>
  80293c:	83 c4 18             	add    $0x18,%esp
	return ;
  80293f:	90                   	nop
}
  802940:	c9                   	leave  
  802941:	c3                   	ret    

00802942 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802942:	55                   	push   %ebp
  802943:	89 e5                	mov    %esp,%ebp
  802945:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802946:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802949:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80294c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	6a 00                	push   $0x0
  802954:	53                   	push   %ebx
  802955:	51                   	push   %ecx
  802956:	52                   	push   %edx
  802957:	50                   	push   %eax
  802958:	6a 2e                	push   $0x2e
  80295a:	e8 c8 f9 ff ff       	call   802327 <syscall>
  80295f:	83 c4 18             	add    $0x18,%esp
}
  802962:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802965:	c9                   	leave  
  802966:	c3                   	ret    

00802967 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802967:	55                   	push   %ebp
  802968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80296a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	6a 00                	push   $0x0
  802972:	6a 00                	push   $0x0
  802974:	6a 00                	push   $0x0
  802976:	52                   	push   %edx
  802977:	50                   	push   %eax
  802978:	6a 2f                	push   $0x2f
  80297a:	e8 a8 f9 ff ff       	call   802327 <syscall>
  80297f:	83 c4 18             	add    $0x18,%esp
}
  802982:	c9                   	leave  
  802983:	c3                   	ret    

00802984 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802984:	55                   	push   %ebp
  802985:	89 e5                	mov    %esp,%ebp
  802987:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80298a:	8b 55 08             	mov    0x8(%ebp),%edx
  80298d:	89 d0                	mov    %edx,%eax
  80298f:	c1 e0 02             	shl    $0x2,%eax
  802992:	01 d0                	add    %edx,%eax
  802994:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80299b:	01 d0                	add    %edx,%eax
  80299d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8029a4:	01 d0                	add    %edx,%eax
  8029a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8029ad:	01 d0                	add    %edx,%eax
  8029af:	c1 e0 04             	shl    $0x4,%eax
  8029b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8029b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8029bc:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8029bf:	83 ec 0c             	sub    $0xc,%esp
  8029c2:	50                   	push   %eax
  8029c3:	e8 76 fd ff ff       	call   80273e <sys_get_virtual_time>
  8029c8:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8029cb:	eb 41                	jmp    802a0e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8029cd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8029d0:	83 ec 0c             	sub    $0xc,%esp
  8029d3:	50                   	push   %eax
  8029d4:	e8 65 fd ff ff       	call   80273e <sys_get_virtual_time>
  8029d9:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8029dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e2:	29 c2                	sub    %eax,%edx
  8029e4:	89 d0                	mov    %edx,%eax
  8029e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8029e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ef:	89 d1                	mov    %edx,%ecx
  8029f1:	29 c1                	sub    %eax,%ecx
  8029f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8029f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029f9:	39 c2                	cmp    %eax,%edx
  8029fb:	0f 97 c0             	seta   %al
  8029fe:	0f b6 c0             	movzbl %al,%eax
  802a01:	29 c1                	sub    %eax,%ecx
  802a03:	89 c8                	mov    %ecx,%eax
  802a05:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802a08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a14:	72 b7                	jb     8029cd <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802a16:	90                   	nop
  802a17:	c9                   	leave  
  802a18:	c3                   	ret    

00802a19 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802a19:	55                   	push   %ebp
  802a1a:	89 e5                	mov    %esp,%ebp
  802a1c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802a1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802a26:	eb 03                	jmp    802a2b <busy_wait+0x12>
  802a28:	ff 45 fc             	incl   -0x4(%ebp)
  802a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a31:	72 f5                	jb     802a28 <busy_wait+0xf>
	return i;
  802a33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802a36:	c9                   	leave  
  802a37:	c3                   	ret    

00802a38 <__udivdi3>:
  802a38:	55                   	push   %ebp
  802a39:	57                   	push   %edi
  802a3a:	56                   	push   %esi
  802a3b:	53                   	push   %ebx
  802a3c:	83 ec 1c             	sub    $0x1c,%esp
  802a3f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802a43:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802a47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a4f:	89 ca                	mov    %ecx,%edx
  802a51:	89 f8                	mov    %edi,%eax
  802a53:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802a57:	85 f6                	test   %esi,%esi
  802a59:	75 2d                	jne    802a88 <__udivdi3+0x50>
  802a5b:	39 cf                	cmp    %ecx,%edi
  802a5d:	77 65                	ja     802ac4 <__udivdi3+0x8c>
  802a5f:	89 fd                	mov    %edi,%ebp
  802a61:	85 ff                	test   %edi,%edi
  802a63:	75 0b                	jne    802a70 <__udivdi3+0x38>
  802a65:	b8 01 00 00 00       	mov    $0x1,%eax
  802a6a:	31 d2                	xor    %edx,%edx
  802a6c:	f7 f7                	div    %edi
  802a6e:	89 c5                	mov    %eax,%ebp
  802a70:	31 d2                	xor    %edx,%edx
  802a72:	89 c8                	mov    %ecx,%eax
  802a74:	f7 f5                	div    %ebp
  802a76:	89 c1                	mov    %eax,%ecx
  802a78:	89 d8                	mov    %ebx,%eax
  802a7a:	f7 f5                	div    %ebp
  802a7c:	89 cf                	mov    %ecx,%edi
  802a7e:	89 fa                	mov    %edi,%edx
  802a80:	83 c4 1c             	add    $0x1c,%esp
  802a83:	5b                   	pop    %ebx
  802a84:	5e                   	pop    %esi
  802a85:	5f                   	pop    %edi
  802a86:	5d                   	pop    %ebp
  802a87:	c3                   	ret    
  802a88:	39 ce                	cmp    %ecx,%esi
  802a8a:	77 28                	ja     802ab4 <__udivdi3+0x7c>
  802a8c:	0f bd fe             	bsr    %esi,%edi
  802a8f:	83 f7 1f             	xor    $0x1f,%edi
  802a92:	75 40                	jne    802ad4 <__udivdi3+0x9c>
  802a94:	39 ce                	cmp    %ecx,%esi
  802a96:	72 0a                	jb     802aa2 <__udivdi3+0x6a>
  802a98:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802a9c:	0f 87 9e 00 00 00    	ja     802b40 <__udivdi3+0x108>
  802aa2:	b8 01 00 00 00       	mov    $0x1,%eax
  802aa7:	89 fa                	mov    %edi,%edx
  802aa9:	83 c4 1c             	add    $0x1c,%esp
  802aac:	5b                   	pop    %ebx
  802aad:	5e                   	pop    %esi
  802aae:	5f                   	pop    %edi
  802aaf:	5d                   	pop    %ebp
  802ab0:	c3                   	ret    
  802ab1:	8d 76 00             	lea    0x0(%esi),%esi
  802ab4:	31 ff                	xor    %edi,%edi
  802ab6:	31 c0                	xor    %eax,%eax
  802ab8:	89 fa                	mov    %edi,%edx
  802aba:	83 c4 1c             	add    $0x1c,%esp
  802abd:	5b                   	pop    %ebx
  802abe:	5e                   	pop    %esi
  802abf:	5f                   	pop    %edi
  802ac0:	5d                   	pop    %ebp
  802ac1:	c3                   	ret    
  802ac2:	66 90                	xchg   %ax,%ax
  802ac4:	89 d8                	mov    %ebx,%eax
  802ac6:	f7 f7                	div    %edi
  802ac8:	31 ff                	xor    %edi,%edi
  802aca:	89 fa                	mov    %edi,%edx
  802acc:	83 c4 1c             	add    $0x1c,%esp
  802acf:	5b                   	pop    %ebx
  802ad0:	5e                   	pop    %esi
  802ad1:	5f                   	pop    %edi
  802ad2:	5d                   	pop    %ebp
  802ad3:	c3                   	ret    
  802ad4:	bd 20 00 00 00       	mov    $0x20,%ebp
  802ad9:	89 eb                	mov    %ebp,%ebx
  802adb:	29 fb                	sub    %edi,%ebx
  802add:	89 f9                	mov    %edi,%ecx
  802adf:	d3 e6                	shl    %cl,%esi
  802ae1:	89 c5                	mov    %eax,%ebp
  802ae3:	88 d9                	mov    %bl,%cl
  802ae5:	d3 ed                	shr    %cl,%ebp
  802ae7:	89 e9                	mov    %ebp,%ecx
  802ae9:	09 f1                	or     %esi,%ecx
  802aeb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802aef:	89 f9                	mov    %edi,%ecx
  802af1:	d3 e0                	shl    %cl,%eax
  802af3:	89 c5                	mov    %eax,%ebp
  802af5:	89 d6                	mov    %edx,%esi
  802af7:	88 d9                	mov    %bl,%cl
  802af9:	d3 ee                	shr    %cl,%esi
  802afb:	89 f9                	mov    %edi,%ecx
  802afd:	d3 e2                	shl    %cl,%edx
  802aff:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b03:	88 d9                	mov    %bl,%cl
  802b05:	d3 e8                	shr    %cl,%eax
  802b07:	09 c2                	or     %eax,%edx
  802b09:	89 d0                	mov    %edx,%eax
  802b0b:	89 f2                	mov    %esi,%edx
  802b0d:	f7 74 24 0c          	divl   0xc(%esp)
  802b11:	89 d6                	mov    %edx,%esi
  802b13:	89 c3                	mov    %eax,%ebx
  802b15:	f7 e5                	mul    %ebp
  802b17:	39 d6                	cmp    %edx,%esi
  802b19:	72 19                	jb     802b34 <__udivdi3+0xfc>
  802b1b:	74 0b                	je     802b28 <__udivdi3+0xf0>
  802b1d:	89 d8                	mov    %ebx,%eax
  802b1f:	31 ff                	xor    %edi,%edi
  802b21:	e9 58 ff ff ff       	jmp    802a7e <__udivdi3+0x46>
  802b26:	66 90                	xchg   %ax,%ax
  802b28:	8b 54 24 08          	mov    0x8(%esp),%edx
  802b2c:	89 f9                	mov    %edi,%ecx
  802b2e:	d3 e2                	shl    %cl,%edx
  802b30:	39 c2                	cmp    %eax,%edx
  802b32:	73 e9                	jae    802b1d <__udivdi3+0xe5>
  802b34:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b37:	31 ff                	xor    %edi,%edi
  802b39:	e9 40 ff ff ff       	jmp    802a7e <__udivdi3+0x46>
  802b3e:	66 90                	xchg   %ax,%ax
  802b40:	31 c0                	xor    %eax,%eax
  802b42:	e9 37 ff ff ff       	jmp    802a7e <__udivdi3+0x46>
  802b47:	90                   	nop

00802b48 <__umoddi3>:
  802b48:	55                   	push   %ebp
  802b49:	57                   	push   %edi
  802b4a:	56                   	push   %esi
  802b4b:	53                   	push   %ebx
  802b4c:	83 ec 1c             	sub    $0x1c,%esp
  802b4f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802b53:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b67:	89 f3                	mov    %esi,%ebx
  802b69:	89 fa                	mov    %edi,%edx
  802b6b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b6f:	89 34 24             	mov    %esi,(%esp)
  802b72:	85 c0                	test   %eax,%eax
  802b74:	75 1a                	jne    802b90 <__umoddi3+0x48>
  802b76:	39 f7                	cmp    %esi,%edi
  802b78:	0f 86 a2 00 00 00    	jbe    802c20 <__umoddi3+0xd8>
  802b7e:	89 c8                	mov    %ecx,%eax
  802b80:	89 f2                	mov    %esi,%edx
  802b82:	f7 f7                	div    %edi
  802b84:	89 d0                	mov    %edx,%eax
  802b86:	31 d2                	xor    %edx,%edx
  802b88:	83 c4 1c             	add    $0x1c,%esp
  802b8b:	5b                   	pop    %ebx
  802b8c:	5e                   	pop    %esi
  802b8d:	5f                   	pop    %edi
  802b8e:	5d                   	pop    %ebp
  802b8f:	c3                   	ret    
  802b90:	39 f0                	cmp    %esi,%eax
  802b92:	0f 87 ac 00 00 00    	ja     802c44 <__umoddi3+0xfc>
  802b98:	0f bd e8             	bsr    %eax,%ebp
  802b9b:	83 f5 1f             	xor    $0x1f,%ebp
  802b9e:	0f 84 ac 00 00 00    	je     802c50 <__umoddi3+0x108>
  802ba4:	bf 20 00 00 00       	mov    $0x20,%edi
  802ba9:	29 ef                	sub    %ebp,%edi
  802bab:	89 fe                	mov    %edi,%esi
  802bad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bb1:	89 e9                	mov    %ebp,%ecx
  802bb3:	d3 e0                	shl    %cl,%eax
  802bb5:	89 d7                	mov    %edx,%edi
  802bb7:	89 f1                	mov    %esi,%ecx
  802bb9:	d3 ef                	shr    %cl,%edi
  802bbb:	09 c7                	or     %eax,%edi
  802bbd:	89 e9                	mov    %ebp,%ecx
  802bbf:	d3 e2                	shl    %cl,%edx
  802bc1:	89 14 24             	mov    %edx,(%esp)
  802bc4:	89 d8                	mov    %ebx,%eax
  802bc6:	d3 e0                	shl    %cl,%eax
  802bc8:	89 c2                	mov    %eax,%edx
  802bca:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bce:	d3 e0                	shl    %cl,%eax
  802bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bd4:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bd8:	89 f1                	mov    %esi,%ecx
  802bda:	d3 e8                	shr    %cl,%eax
  802bdc:	09 d0                	or     %edx,%eax
  802bde:	d3 eb                	shr    %cl,%ebx
  802be0:	89 da                	mov    %ebx,%edx
  802be2:	f7 f7                	div    %edi
  802be4:	89 d3                	mov    %edx,%ebx
  802be6:	f7 24 24             	mull   (%esp)
  802be9:	89 c6                	mov    %eax,%esi
  802beb:	89 d1                	mov    %edx,%ecx
  802bed:	39 d3                	cmp    %edx,%ebx
  802bef:	0f 82 87 00 00 00    	jb     802c7c <__umoddi3+0x134>
  802bf5:	0f 84 91 00 00 00    	je     802c8c <__umoddi3+0x144>
  802bfb:	8b 54 24 04          	mov    0x4(%esp),%edx
  802bff:	29 f2                	sub    %esi,%edx
  802c01:	19 cb                	sbb    %ecx,%ebx
  802c03:	89 d8                	mov    %ebx,%eax
  802c05:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802c09:	d3 e0                	shl    %cl,%eax
  802c0b:	89 e9                	mov    %ebp,%ecx
  802c0d:	d3 ea                	shr    %cl,%edx
  802c0f:	09 d0                	or     %edx,%eax
  802c11:	89 e9                	mov    %ebp,%ecx
  802c13:	d3 eb                	shr    %cl,%ebx
  802c15:	89 da                	mov    %ebx,%edx
  802c17:	83 c4 1c             	add    $0x1c,%esp
  802c1a:	5b                   	pop    %ebx
  802c1b:	5e                   	pop    %esi
  802c1c:	5f                   	pop    %edi
  802c1d:	5d                   	pop    %ebp
  802c1e:	c3                   	ret    
  802c1f:	90                   	nop
  802c20:	89 fd                	mov    %edi,%ebp
  802c22:	85 ff                	test   %edi,%edi
  802c24:	75 0b                	jne    802c31 <__umoddi3+0xe9>
  802c26:	b8 01 00 00 00       	mov    $0x1,%eax
  802c2b:	31 d2                	xor    %edx,%edx
  802c2d:	f7 f7                	div    %edi
  802c2f:	89 c5                	mov    %eax,%ebp
  802c31:	89 f0                	mov    %esi,%eax
  802c33:	31 d2                	xor    %edx,%edx
  802c35:	f7 f5                	div    %ebp
  802c37:	89 c8                	mov    %ecx,%eax
  802c39:	f7 f5                	div    %ebp
  802c3b:	89 d0                	mov    %edx,%eax
  802c3d:	e9 44 ff ff ff       	jmp    802b86 <__umoddi3+0x3e>
  802c42:	66 90                	xchg   %ax,%ax
  802c44:	89 c8                	mov    %ecx,%eax
  802c46:	89 f2                	mov    %esi,%edx
  802c48:	83 c4 1c             	add    $0x1c,%esp
  802c4b:	5b                   	pop    %ebx
  802c4c:	5e                   	pop    %esi
  802c4d:	5f                   	pop    %edi
  802c4e:	5d                   	pop    %ebp
  802c4f:	c3                   	ret    
  802c50:	3b 04 24             	cmp    (%esp),%eax
  802c53:	72 06                	jb     802c5b <__umoddi3+0x113>
  802c55:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802c59:	77 0f                	ja     802c6a <__umoddi3+0x122>
  802c5b:	89 f2                	mov    %esi,%edx
  802c5d:	29 f9                	sub    %edi,%ecx
  802c5f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802c63:	89 14 24             	mov    %edx,(%esp)
  802c66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c6a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c6e:	8b 14 24             	mov    (%esp),%edx
  802c71:	83 c4 1c             	add    $0x1c,%esp
  802c74:	5b                   	pop    %ebx
  802c75:	5e                   	pop    %esi
  802c76:	5f                   	pop    %edi
  802c77:	5d                   	pop    %ebp
  802c78:	c3                   	ret    
  802c79:	8d 76 00             	lea    0x0(%esi),%esi
  802c7c:	2b 04 24             	sub    (%esp),%eax
  802c7f:	19 fa                	sbb    %edi,%edx
  802c81:	89 d1                	mov    %edx,%ecx
  802c83:	89 c6                	mov    %eax,%esi
  802c85:	e9 71 ff ff ff       	jmp    802bfb <__umoddi3+0xb3>
  802c8a:	66 90                	xchg   %ax,%ax
  802c8c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802c90:	72 ea                	jb     802c7c <__umoddi3+0x134>
  802c92:	89 d9                	mov    %ebx,%ecx
  802c94:	e9 62 ff ff ff       	jmp    802bfb <__umoddi3+0xb3>
