
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 e7 05 00 00       	call   80061d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
#include <user/air.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 01 00 00    	sub    $0x19c,%esp
	int parentenvID = sys_getparentenvid();
  800044:	e8 6a 1e 00 00       	call   801eb3 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb f5 26 80 00       	mov    $0x8026f5,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb ff 26 80 00       	mov    $0x8026ff,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb 0b 27 80 00       	mov    $0x80270b,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb 1a 27 80 00       	mov    $0x80271a,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb 29 27 80 00       	mov    $0x802729,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb 3e 27 80 00       	mov    $0x80273e,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 53 27 80 00       	mov    $0x802753,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 64 27 80 00       	mov    $0x802764,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 75 27 80 00       	mov    $0x802775,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 86 27 80 00       	mov    $0x802786,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 8f 27 80 00       	mov    $0x80278f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 99 27 80 00       	mov    $0x802799,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb a4 27 80 00       	mov    $0x8027a4,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb b0 27 80 00       	mov    $0x8027b0,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb ba 27 80 00       	mov    $0x8027ba,%ebx
  80019b:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001a0:	89 c7                	mov    %eax,%edi
  8001a2:	89 de                	mov    %ebx,%esi
  8001a4:	89 d1                	mov    %edx,%ecx
  8001a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a8:	c7 85 e3 fe ff ff 63 	movl   $0x72656c63,-0x11d(%ebp)
  8001af:	6c 65 72 
  8001b2:	66 c7 85 e7 fe ff ff 	movw   $0x6b,-0x119(%ebp)
  8001b9:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001bb:	8d 85 d5 fe ff ff    	lea    -0x12b(%ebp),%eax
  8001c1:	bb c4 27 80 00       	mov    $0x8027c4,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb d2 27 80 00       	mov    $0x8027d2,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb e1 27 80 00       	mov    $0x8027e1,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb e8 27 80 00       	mov    $0x8027e8,%ebx
  80020e:	ba 07 00 00 00       	mov    $0x7,%edx
  800213:	89 c7                	mov    %eax,%edi
  800215:	89 de                	mov    %ebx,%esi
  800217:	89 d1                	mov    %edx,%ecx
  800219:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	8d 45 ae             	lea    -0x52(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	ff 75 e4             	pushl  -0x1c(%ebp)
  800225:	e8 21 1b 00 00       	call   801d4b <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 0c 1b 00 00       	call   801d4b <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 f7 1a 00 00       	call   801d4b <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 df 1a 00 00       	call   801d4b <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 c7 1a 00 00       	call   801d4b <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 af 1a 00 00       	call   801d4b <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 97 1a 00 00       	call   801d4b <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 7f 1a 00 00       	call   801d4b <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 67 1a 00 00       	call   801d4b <sget>
  8002e4:	83 c4 10             	add    $0x10,%esp
  8002e7:	89 45 c0             	mov    %eax,-0x40(%ebp)

	while(1==1)
	{
		int custId;
		//wait for a customer
		sys_waitSemaphore(parentenvID, _cust_ready);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  8002f3:	50                   	push   %eax
  8002f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f7:	e8 e6 1d 00 00       	call   8020e2 <sys_waitSemaphore>
  8002fc:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		sys_waitSemaphore(parentenvID, _custQueueCS);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	e8 d1 1d 00 00       	call   8020e2 <sys_waitSemaphore>
  800311:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  800314:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800317:	8b 00                	mov    (%eax),%eax
  800319:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800320:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800323:	01 d0                	add    %edx,%eax
  800325:	8b 00                	mov    (%eax),%eax
  800327:	89 45 bc             	mov    %eax,-0x44(%ebp)
			*queue_out = *queue_out +1;
  80032a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80032d:	8b 00                	mov    (%eax),%eax
  80032f:	8d 50 01             	lea    0x1(%eax),%edx
  800332:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800335:	89 10                	mov    %edx,(%eax)
		}
		sys_signalSemaphore(parentenvID, _custQueueCS);
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800340:	50                   	push   %eax
  800341:	ff 75 e4             	pushl  -0x1c(%ebp)
  800344:	e8 b7 1d 00 00       	call   802100 <sys_signalSemaphore>
  800349:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  80034c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800356:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	8b 00                	mov    (%eax),%eax
  80035d:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  800360:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800363:	83 f8 02             	cmp    $0x2,%eax
  800366:	0f 84 90 00 00 00    	je     8003fc <_main+0x3c4>
  80036c:	83 f8 03             	cmp    $0x3,%eax
  80036f:	0f 84 05 01 00 00    	je     80047a <_main+0x442>
  800375:	83 f8 01             	cmp    $0x1,%eax
  800378:	0f 85 f8 01 00 00    	jne    800576 <_main+0x53e>
		{
		case 1:
		{
			//Check and update Flight1
			sys_waitSemaphore(parentenvID, _flight1CS);
  80037e:	83 ec 08             	sub    $0x8,%esp
  800381:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800387:	50                   	push   %eax
  800388:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038b:	e8 52 1d 00 00       	call   8020e2 <sys_waitSemaphore>
  800390:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  800393:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	7e 46                	jle    8003e2 <_main+0x3aa>
				{
					*flight1Counter = *flight1Counter - 1;
  80039c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8003a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a7:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8003a9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8003bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8003d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	8d 50 01             	lea    0x1(%eax),%edx
  8003dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003e0:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight1CS);
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  8003eb:	50                   	push   %eax
  8003ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ef:	e8 0c 1d 00 00       	call   802100 <sys_signalSemaphore>
  8003f4:	83 c4 10             	add    $0x10,%esp
		}

		break;
  8003f7:	e9 91 01 00 00       	jmp    80058d <_main+0x555>
		case 2:
		{
			//Check and update Flight2
			sys_waitSemaphore(parentenvID, _flight2CS);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800405:	50                   	push   %eax
  800406:	ff 75 e4             	pushl  -0x1c(%ebp)
  800409:	e8 d4 1c 00 00       	call   8020e2 <sys_waitSemaphore>
  80040e:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800411:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	85 c0                	test   %eax,%eax
  800418:	7e 46                	jle    800460 <_main+0x428>
				{
					*flight2Counter = *flight2Counter - 1;
  80041a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800422:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800425:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800427:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80042a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	01 d0                	add    %edx,%eax
  800436:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  80043d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800449:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80044c:	01 c2                	add    %eax,%edx
  80044e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800451:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  800453:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	8d 50 01             	lea    0x1(%eax),%edx
  80045b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80045e:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800469:	50                   	push   %eax
  80046a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046d:	e8 8e 1c 00 00       	call   802100 <sys_signalSemaphore>
  800472:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800475:	e9 13 01 00 00       	jmp    80058d <_main+0x555>
		case 3:
		{
			//Check and update Both Flights
			sys_waitSemaphore(parentenvID, _flight1CS); sys_waitSemaphore(parentenvID, _flight2CS);
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800483:	50                   	push   %eax
  800484:	ff 75 e4             	pushl  -0x1c(%ebp)
  800487:	e8 56 1c 00 00       	call   8020e2 <sys_waitSemaphore>
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049c:	e8 41 1c 00 00       	call   8020e2 <sys_waitSemaphore>
  8004a1:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  8004a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	85 c0                	test   %eax,%eax
  8004ab:	0f 8e 99 00 00 00    	jle    80054a <_main+0x512>
  8004b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	85 c0                	test   %eax,%eax
  8004b8:	0f 8e 8c 00 00 00    	jle    80054a <_main+0x512>
				{
					*flight1Counter = *flight1Counter - 1;
  8004be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c9:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8004cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d8:	01 d0                	add    %edx,%eax
  8004da:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8004e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f0:	01 c2                	add    %eax,%edx
  8004f2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004f5:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8004f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 50 01             	lea    0x1(%eax),%edx
  8004ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800502:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  800504:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80050c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80050f:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800511:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800514:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80051b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051e:	01 d0                	add    %edx,%eax
  800520:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800527:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800533:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800536:	01 c2                	add    %eax,%edx
  800538:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80053b:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80053d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	8d 50 01             	lea    0x1(%eax),%edx
  800545:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800548:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS); sys_signalSemaphore(parentenvID, _flight1CS);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800553:	50                   	push   %eax
  800554:	ff 75 e4             	pushl  -0x1c(%ebp)
  800557:	e8 a4 1b 00 00       	call   802100 <sys_signalSemaphore>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	e8 8f 1b 00 00       	call   802100 <sys_signalSemaphore>
  800571:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800574:	eb 17                	jmp    80058d <_main+0x555>
		default:
			panic("customer must have flight type\n");
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	68 c0 26 80 00       	push   $0x8026c0
  80057e:	68 8f 00 00 00       	push   $0x8f
  800583:	68 e0 26 80 00       	push   $0x8026e0
  800588:	e8 d5 01 00 00       	call   800762 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  80058d:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800593:	bb ef 27 80 00       	mov    $0x8027ef,%ebx
  800598:	ba 0e 00 00 00       	mov    $0xe,%edx
  80059d:	89 c7                	mov    %eax,%edi
  80059f:	89 de                	mov    %ebx,%esi
  8005a1:	89 d1                	mov    %edx,%ecx
  8005a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005a5:	8d 95 a8 fe ff ff    	lea    -0x158(%ebp),%edx
  8005ab:	b9 04 00 00 00       	mov    $0x4,%ecx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	89 d7                	mov    %edx,%edi
  8005b7:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005c2:	50                   	push   %eax
  8005c3:	ff 75 bc             	pushl  -0x44(%ebp)
  8005c6:	e8 61 0f 00 00       	call   80152c <ltostr>
  8005cb:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005d7:	50                   	push   %eax
  8005d8:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005de:	50                   	push   %eax
  8005df:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8005e5:	50                   	push   %eax
  8005e6:	e8 39 10 00 00       	call   801624 <strcconcat>
  8005eb:	83 c4 10             	add    $0x10,%esp
		sys_signalSemaphore(parentenvID, sname);
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005f7:	50                   	push   %eax
  8005f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005fb:	e8 00 1b 00 00       	call   802100 <sys_signalSemaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		sys_signalSemaphore(parentenvID, _clerk);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80060c:	50                   	push   %eax
  80060d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800610:	e8 eb 1a 00 00       	call   802100 <sys_signalSemaphore>
  800615:	83 c4 10             	add    $0x10,%esp
	}
  800618:	e9 cd fc ff ff       	jmp    8002ea <_main+0x2b2>

0080061d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80061d:	55                   	push   %ebp
  80061e:	89 e5                	mov    %esp,%ebp
  800620:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800623:	e8 72 18 00 00       	call   801e9a <sys_getenvindex>
  800628:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80062b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062e:	89 d0                	mov    %edx,%eax
  800630:	c1 e0 03             	shl    $0x3,%eax
  800633:	01 d0                	add    %edx,%eax
  800635:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	01 c0                	add    %eax,%eax
  800640:	01 d0                	add    %edx,%eax
  800642:	01 c0                	add    %eax,%eax
  800644:	01 d0                	add    %edx,%eax
  800646:	89 c2                	mov    %eax,%edx
  800648:	c1 e2 05             	shl    $0x5,%edx
  80064b:	29 c2                	sub    %eax,%edx
  80064d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800654:	89 c2                	mov    %eax,%edx
  800656:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80065c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800661:	a1 20 30 80 00       	mov    0x803020,%eax
  800666:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80066c:	84 c0                	test   %al,%al
  80066e:	74 0f                	je     80067f <libmain+0x62>
		binaryname = myEnv->prog_name;
  800670:	a1 20 30 80 00       	mov    0x803020,%eax
  800675:	05 40 3c 01 00       	add    $0x13c40,%eax
  80067a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80067f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800683:	7e 0a                	jle    80068f <libmain+0x72>
		binaryname = argv[0];
  800685:	8b 45 0c             	mov    0xc(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	ff 75 0c             	pushl  0xc(%ebp)
  800695:	ff 75 08             	pushl  0x8(%ebp)
  800698:	e8 9b f9 ff ff       	call   800038 <_main>
  80069d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006a0:	e8 90 19 00 00       	call   802035 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006a5:	83 ec 0c             	sub    $0xc,%esp
  8006a8:	68 28 28 80 00       	push   $0x802828
  8006ad:	e8 52 03 00 00       	call   800a04 <cprintf>
  8006b2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8006ba:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8006c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8006c5:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8006cb:	83 ec 04             	sub    $0x4,%esp
  8006ce:	52                   	push   %edx
  8006cf:	50                   	push   %eax
  8006d0:	68 50 28 80 00       	push   $0x802850
  8006d5:	e8 2a 03 00 00       	call   800a04 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8006dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8006e2:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8006e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8006ed:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8006f3:	83 ec 04             	sub    $0x4,%esp
  8006f6:	52                   	push   %edx
  8006f7:	50                   	push   %eax
  8006f8:	68 78 28 80 00       	push   $0x802878
  8006fd:	e8 02 03 00 00       	call   800a04 <cprintf>
  800702:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800705:	a1 20 30 80 00       	mov    0x803020,%eax
  80070a:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	50                   	push   %eax
  800714:	68 b9 28 80 00       	push   $0x8028b9
  800719:	e8 e6 02 00 00       	call   800a04 <cprintf>
  80071e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800721:	83 ec 0c             	sub    $0xc,%esp
  800724:	68 28 28 80 00       	push   $0x802828
  800729:	e8 d6 02 00 00       	call   800a04 <cprintf>
  80072e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800731:	e8 19 19 00 00       	call   80204f <sys_enable_interrupt>

	// exit gracefully
	exit();
  800736:	e8 19 00 00 00       	call   800754 <exit>
}
  80073b:	90                   	nop
  80073c:	c9                   	leave  
  80073d:	c3                   	ret    

0080073e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80073e:	55                   	push   %ebp
  80073f:	89 e5                	mov    %esp,%ebp
  800741:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800744:	83 ec 0c             	sub    $0xc,%esp
  800747:	6a 00                	push   $0x0
  800749:	e8 18 17 00 00       	call   801e66 <sys_env_destroy>
  80074e:	83 c4 10             	add    $0x10,%esp
}
  800751:	90                   	nop
  800752:	c9                   	leave  
  800753:	c3                   	ret    

00800754 <exit>:

void
exit(void)
{
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
  800757:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80075a:	e8 6d 17 00 00       	call   801ecc <sys_env_exit>
}
  80075f:	90                   	nop
  800760:	c9                   	leave  
  800761:	c3                   	ret    

00800762 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
  800765:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800768:	8d 45 10             	lea    0x10(%ebp),%eax
  80076b:	83 c0 04             	add    $0x4,%eax
  80076e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800771:	a1 18 31 80 00       	mov    0x803118,%eax
  800776:	85 c0                	test   %eax,%eax
  800778:	74 16                	je     800790 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80077a:	a1 18 31 80 00       	mov    0x803118,%eax
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	50                   	push   %eax
  800783:	68 d0 28 80 00       	push   $0x8028d0
  800788:	e8 77 02 00 00       	call   800a04 <cprintf>
  80078d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800790:	a1 00 30 80 00       	mov    0x803000,%eax
  800795:	ff 75 0c             	pushl  0xc(%ebp)
  800798:	ff 75 08             	pushl  0x8(%ebp)
  80079b:	50                   	push   %eax
  80079c:	68 d5 28 80 00       	push   $0x8028d5
  8007a1:	e8 5e 02 00 00       	call   800a04 <cprintf>
  8007a6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b2:	50                   	push   %eax
  8007b3:	e8 e1 01 00 00       	call   800999 <vcprintf>
  8007b8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	6a 00                	push   $0x0
  8007c0:	68 f1 28 80 00       	push   $0x8028f1
  8007c5:	e8 cf 01 00 00       	call   800999 <vcprintf>
  8007ca:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007cd:	e8 82 ff ff ff       	call   800754 <exit>

	// should not return here
	while (1) ;
  8007d2:	eb fe                	jmp    8007d2 <_panic+0x70>

008007d4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007da:	a1 20 30 80 00       	mov    0x803020,%eax
  8007df:	8b 50 74             	mov    0x74(%eax),%edx
  8007e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e5:	39 c2                	cmp    %eax,%edx
  8007e7:	74 14                	je     8007fd <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	68 f4 28 80 00       	push   $0x8028f4
  8007f1:	6a 26                	push   $0x26
  8007f3:	68 40 29 80 00       	push   $0x802940
  8007f8:	e8 65 ff ff ff       	call   800762 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800804:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80080b:	e9 b6 00 00 00       	jmp    8008c6 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800813:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	01 d0                	add    %edx,%eax
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	85 c0                	test   %eax,%eax
  800823:	75 08                	jne    80082d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800825:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800828:	e9 96 00 00 00       	jmp    8008c3 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80082d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800834:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80083b:	eb 5d                	jmp    80089a <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80083d:	a1 20 30 80 00       	mov    0x803020,%eax
  800842:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800848:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80084b:	c1 e2 04             	shl    $0x4,%edx
  80084e:	01 d0                	add    %edx,%eax
  800850:	8a 40 04             	mov    0x4(%eax),%al
  800853:	84 c0                	test   %al,%al
  800855:	75 40                	jne    800897 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800857:	a1 20 30 80 00       	mov    0x803020,%eax
  80085c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800862:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800865:	c1 e2 04             	shl    $0x4,%edx
  800868:	01 d0                	add    %edx,%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80086f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800872:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800877:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	01 c8                	add    %ecx,%eax
  800888:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088a:	39 c2                	cmp    %eax,%edx
  80088c:	75 09                	jne    800897 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  80088e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800895:	eb 12                	jmp    8008a9 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800897:	ff 45 e8             	incl   -0x18(%ebp)
  80089a:	a1 20 30 80 00       	mov    0x803020,%eax
  80089f:	8b 50 74             	mov    0x74(%eax),%edx
  8008a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a5:	39 c2                	cmp    %eax,%edx
  8008a7:	77 94                	ja     80083d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008ad:	75 14                	jne    8008c3 <CheckWSWithoutLastIndex+0xef>
			panic(
  8008af:	83 ec 04             	sub    $0x4,%esp
  8008b2:	68 4c 29 80 00       	push   $0x80294c
  8008b7:	6a 3a                	push   $0x3a
  8008b9:	68 40 29 80 00       	push   $0x802940
  8008be:	e8 9f fe ff ff       	call   800762 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008c3:	ff 45 f0             	incl   -0x10(%ebp)
  8008c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008cc:	0f 8c 3e ff ff ff    	jl     800810 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008d2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008e0:	eb 20                	jmp    800902 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8008e7:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8008ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f0:	c1 e2 04             	shl    $0x4,%edx
  8008f3:	01 d0                	add    %edx,%eax
  8008f5:	8a 40 04             	mov    0x4(%eax),%al
  8008f8:	3c 01                	cmp    $0x1,%al
  8008fa:	75 03                	jne    8008ff <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8008fc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008ff:	ff 45 e0             	incl   -0x20(%ebp)
  800902:	a1 20 30 80 00       	mov    0x803020,%eax
  800907:	8b 50 74             	mov    0x74(%eax),%edx
  80090a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090d:	39 c2                	cmp    %eax,%edx
  80090f:	77 d1                	ja     8008e2 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800914:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800917:	74 14                	je     80092d <CheckWSWithoutLastIndex+0x159>
		panic(
  800919:	83 ec 04             	sub    $0x4,%esp
  80091c:	68 a0 29 80 00       	push   $0x8029a0
  800921:	6a 44                	push   $0x44
  800923:	68 40 29 80 00       	push   $0x802940
  800928:	e8 35 fe ff ff       	call   800762 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80092d:	90                   	nop
  80092e:	c9                   	leave  
  80092f:	c3                   	ret    

00800930 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800936:	8b 45 0c             	mov    0xc(%ebp),%eax
  800939:	8b 00                	mov    (%eax),%eax
  80093b:	8d 48 01             	lea    0x1(%eax),%ecx
  80093e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800941:	89 0a                	mov    %ecx,(%edx)
  800943:	8b 55 08             	mov    0x8(%ebp),%edx
  800946:	88 d1                	mov    %dl,%cl
  800948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80094f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	3d ff 00 00 00       	cmp    $0xff,%eax
  800959:	75 2c                	jne    800987 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80095b:	a0 24 30 80 00       	mov    0x803024,%al
  800960:	0f b6 c0             	movzbl %al,%eax
  800963:	8b 55 0c             	mov    0xc(%ebp),%edx
  800966:	8b 12                	mov    (%edx),%edx
  800968:	89 d1                	mov    %edx,%ecx
  80096a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096d:	83 c2 08             	add    $0x8,%edx
  800970:	83 ec 04             	sub    $0x4,%esp
  800973:	50                   	push   %eax
  800974:	51                   	push   %ecx
  800975:	52                   	push   %edx
  800976:	e8 a9 14 00 00       	call   801e24 <sys_cputs>
  80097b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80097e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800981:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	8b 40 04             	mov    0x4(%eax),%eax
  80098d:	8d 50 01             	lea    0x1(%eax),%edx
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	89 50 04             	mov    %edx,0x4(%eax)
}
  800996:	90                   	nop
  800997:	c9                   	leave  
  800998:	c3                   	ret    

00800999 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009a2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009a9:	00 00 00 
	b.cnt = 0;
  8009ac:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009b3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009b6:	ff 75 0c             	pushl  0xc(%ebp)
  8009b9:	ff 75 08             	pushl  0x8(%ebp)
  8009bc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009c2:	50                   	push   %eax
  8009c3:	68 30 09 80 00       	push   $0x800930
  8009c8:	e8 11 02 00 00       	call   800bde <vprintfmt>
  8009cd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009d0:	a0 24 30 80 00       	mov    0x803024,%al
  8009d5:	0f b6 c0             	movzbl %al,%eax
  8009d8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009de:	83 ec 04             	sub    $0x4,%esp
  8009e1:	50                   	push   %eax
  8009e2:	52                   	push   %edx
  8009e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009e9:	83 c0 08             	add    $0x8,%eax
  8009ec:	50                   	push   %eax
  8009ed:	e8 32 14 00 00       	call   801e24 <sys_cputs>
  8009f2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009f5:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8009fc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a02:	c9                   	leave  
  800a03:	c3                   	ret    

00800a04 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a0a:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800a11:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	83 ec 08             	sub    $0x8,%esp
  800a1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a20:	50                   	push   %eax
  800a21:	e8 73 ff ff ff       	call   800999 <vcprintf>
  800a26:	83 c4 10             	add    $0x10,%esp
  800a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2f:	c9                   	leave  
  800a30:	c3                   	ret    

00800a31 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a37:	e8 f9 15 00 00       	call   802035 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a3c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	83 ec 08             	sub    $0x8,%esp
  800a48:	ff 75 f4             	pushl  -0xc(%ebp)
  800a4b:	50                   	push   %eax
  800a4c:	e8 48 ff ff ff       	call   800999 <vcprintf>
  800a51:	83 c4 10             	add    $0x10,%esp
  800a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a57:	e8 f3 15 00 00       	call   80204f <sys_enable_interrupt>
	return cnt;
  800a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	53                   	push   %ebx
  800a65:	83 ec 14             	sub    $0x14,%esp
  800a68:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a74:	8b 45 18             	mov    0x18(%ebp),%eax
  800a77:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a7f:	77 55                	ja     800ad6 <printnum+0x75>
  800a81:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a84:	72 05                	jb     800a8b <printnum+0x2a>
  800a86:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a89:	77 4b                	ja     800ad6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a8b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a8e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a91:	8b 45 18             	mov    0x18(%ebp),%eax
  800a94:	ba 00 00 00 00       	mov    $0x0,%edx
  800a99:	52                   	push   %edx
  800a9a:	50                   	push   %eax
  800a9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a9e:	ff 75 f0             	pushl  -0x10(%ebp)
  800aa1:	e8 b2 19 00 00       	call   802458 <__udivdi3>
  800aa6:	83 c4 10             	add    $0x10,%esp
  800aa9:	83 ec 04             	sub    $0x4,%esp
  800aac:	ff 75 20             	pushl  0x20(%ebp)
  800aaf:	53                   	push   %ebx
  800ab0:	ff 75 18             	pushl  0x18(%ebp)
  800ab3:	52                   	push   %edx
  800ab4:	50                   	push   %eax
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	ff 75 08             	pushl  0x8(%ebp)
  800abb:	e8 a1 ff ff ff       	call   800a61 <printnum>
  800ac0:	83 c4 20             	add    $0x20,%esp
  800ac3:	eb 1a                	jmp    800adf <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 20             	pushl  0x20(%ebp)
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	ff d0                	call   *%eax
  800ad3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ad6:	ff 4d 1c             	decl   0x1c(%ebp)
  800ad9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800add:	7f e6                	jg     800ac5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800adf:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ae2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aed:	53                   	push   %ebx
  800aee:	51                   	push   %ecx
  800aef:	52                   	push   %edx
  800af0:	50                   	push   %eax
  800af1:	e8 72 1a 00 00       	call   802568 <__umoddi3>
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	05 14 2c 80 00       	add    $0x802c14,%eax
  800afe:	8a 00                	mov    (%eax),%al
  800b00:	0f be c0             	movsbl %al,%eax
  800b03:	83 ec 08             	sub    $0x8,%esp
  800b06:	ff 75 0c             	pushl  0xc(%ebp)
  800b09:	50                   	push   %eax
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	ff d0                	call   *%eax
  800b0f:	83 c4 10             	add    $0x10,%esp
}
  800b12:	90                   	nop
  800b13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b16:	c9                   	leave  
  800b17:	c3                   	ret    

00800b18 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b1b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b1f:	7e 1c                	jle    800b3d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	8d 50 08             	lea    0x8(%eax),%edx
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	89 10                	mov    %edx,(%eax)
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	83 e8 08             	sub    $0x8,%eax
  800b36:	8b 50 04             	mov    0x4(%eax),%edx
  800b39:	8b 00                	mov    (%eax),%eax
  800b3b:	eb 40                	jmp    800b7d <getuint+0x65>
	else if (lflag)
  800b3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b41:	74 1e                	je     800b61 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	8b 00                	mov    (%eax),%eax
  800b48:	8d 50 04             	lea    0x4(%eax),%edx
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	89 10                	mov    %edx,(%eax)
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	8b 00                	mov    (%eax),%eax
  800b55:	83 e8 04             	sub    $0x4,%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5f:	eb 1c                	jmp    800b7d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	8b 00                	mov    (%eax),%eax
  800b66:	8d 50 04             	lea    0x4(%eax),%edx
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	89 10                	mov    %edx,(%eax)
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8b 00                	mov    (%eax),%eax
  800b73:	83 e8 04             	sub    $0x4,%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b82:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b86:	7e 1c                	jle    800ba4 <getint+0x25>
		return va_arg(*ap, long long);
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 50 08             	lea    0x8(%eax),%edx
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	89 10                	mov    %edx,(%eax)
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	8b 00                	mov    (%eax),%eax
  800b9a:	83 e8 08             	sub    $0x8,%eax
  800b9d:	8b 50 04             	mov    0x4(%eax),%edx
  800ba0:	8b 00                	mov    (%eax),%eax
  800ba2:	eb 38                	jmp    800bdc <getint+0x5d>
	else if (lflag)
  800ba4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba8:	74 1a                	je     800bc4 <getint+0x45>
		return va_arg(*ap, long);
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	8b 00                	mov    (%eax),%eax
  800baf:	8d 50 04             	lea    0x4(%eax),%edx
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	89 10                	mov    %edx,(%eax)
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	8b 00                	mov    (%eax),%eax
  800bbc:	83 e8 04             	sub    $0x4,%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	99                   	cltd   
  800bc2:	eb 18                	jmp    800bdc <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	8d 50 04             	lea    0x4(%eax),%edx
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	89 10                	mov    %edx,(%eax)
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8b 00                	mov    (%eax),%eax
  800bd6:	83 e8 04             	sub    $0x4,%eax
  800bd9:	8b 00                	mov    (%eax),%eax
  800bdb:	99                   	cltd   
}
  800bdc:	5d                   	pop    %ebp
  800bdd:	c3                   	ret    

00800bde <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	56                   	push   %esi
  800be2:	53                   	push   %ebx
  800be3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be6:	eb 17                	jmp    800bff <vprintfmt+0x21>
			if (ch == '\0')
  800be8:	85 db                	test   %ebx,%ebx
  800bea:	0f 84 af 03 00 00    	je     800f9f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	ff 75 0c             	pushl  0xc(%ebp)
  800bf6:	53                   	push   %ebx
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	ff d0                	call   *%eax
  800bfc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bff:	8b 45 10             	mov    0x10(%ebp),%eax
  800c02:	8d 50 01             	lea    0x1(%eax),%edx
  800c05:	89 55 10             	mov    %edx,0x10(%ebp)
  800c08:	8a 00                	mov    (%eax),%al
  800c0a:	0f b6 d8             	movzbl %al,%ebx
  800c0d:	83 fb 25             	cmp    $0x25,%ebx
  800c10:	75 d6                	jne    800be8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c12:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c16:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c1d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c24:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c2b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c32:	8b 45 10             	mov    0x10(%ebp),%eax
  800c35:	8d 50 01             	lea    0x1(%eax),%edx
  800c38:	89 55 10             	mov    %edx,0x10(%ebp)
  800c3b:	8a 00                	mov    (%eax),%al
  800c3d:	0f b6 d8             	movzbl %al,%ebx
  800c40:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c43:	83 f8 55             	cmp    $0x55,%eax
  800c46:	0f 87 2b 03 00 00    	ja     800f77 <vprintfmt+0x399>
  800c4c:	8b 04 85 38 2c 80 00 	mov    0x802c38(,%eax,4),%eax
  800c53:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c55:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c59:	eb d7                	jmp    800c32 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c5b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c5f:	eb d1                	jmp    800c32 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c61:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c68:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c6b:	89 d0                	mov    %edx,%eax
  800c6d:	c1 e0 02             	shl    $0x2,%eax
  800c70:	01 d0                	add    %edx,%eax
  800c72:	01 c0                	add    %eax,%eax
  800c74:	01 d8                	add    %ebx,%eax
  800c76:	83 e8 30             	sub    $0x30,%eax
  800c79:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c84:	83 fb 2f             	cmp    $0x2f,%ebx
  800c87:	7e 3e                	jle    800cc7 <vprintfmt+0xe9>
  800c89:	83 fb 39             	cmp    $0x39,%ebx
  800c8c:	7f 39                	jg     800cc7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c8e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c91:	eb d5                	jmp    800c68 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c93:	8b 45 14             	mov    0x14(%ebp),%eax
  800c96:	83 c0 04             	add    $0x4,%eax
  800c99:	89 45 14             	mov    %eax,0x14(%ebp)
  800c9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9f:	83 e8 04             	sub    $0x4,%eax
  800ca2:	8b 00                	mov    (%eax),%eax
  800ca4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ca7:	eb 1f                	jmp    800cc8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ca9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cad:	79 83                	jns    800c32 <vprintfmt+0x54>
				width = 0;
  800caf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cb6:	e9 77 ff ff ff       	jmp    800c32 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cbb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cc2:	e9 6b ff ff ff       	jmp    800c32 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cc7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ccc:	0f 89 60 ff ff ff    	jns    800c32 <vprintfmt+0x54>
				width = precision, precision = -1;
  800cd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cd8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cdf:	e9 4e ff ff ff       	jmp    800c32 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ce4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ce7:	e9 46 ff ff ff       	jmp    800c32 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cec:	8b 45 14             	mov    0x14(%ebp),%eax
  800cef:	83 c0 04             	add    $0x4,%eax
  800cf2:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf8:	83 e8 04             	sub    $0x4,%eax
  800cfb:	8b 00                	mov    (%eax),%eax
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 0c             	pushl  0xc(%ebp)
  800d03:	50                   	push   %eax
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	ff d0                	call   *%eax
  800d09:	83 c4 10             	add    $0x10,%esp
			break;
  800d0c:	e9 89 02 00 00       	jmp    800f9a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d11:	8b 45 14             	mov    0x14(%ebp),%eax
  800d14:	83 c0 04             	add    $0x4,%eax
  800d17:	89 45 14             	mov    %eax,0x14(%ebp)
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	83 e8 04             	sub    $0x4,%eax
  800d20:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d22:	85 db                	test   %ebx,%ebx
  800d24:	79 02                	jns    800d28 <vprintfmt+0x14a>
				err = -err;
  800d26:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d28:	83 fb 64             	cmp    $0x64,%ebx
  800d2b:	7f 0b                	jg     800d38 <vprintfmt+0x15a>
  800d2d:	8b 34 9d 80 2a 80 00 	mov    0x802a80(,%ebx,4),%esi
  800d34:	85 f6                	test   %esi,%esi
  800d36:	75 19                	jne    800d51 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d38:	53                   	push   %ebx
  800d39:	68 25 2c 80 00       	push   $0x802c25
  800d3e:	ff 75 0c             	pushl  0xc(%ebp)
  800d41:	ff 75 08             	pushl  0x8(%ebp)
  800d44:	e8 5e 02 00 00       	call   800fa7 <printfmt>
  800d49:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d4c:	e9 49 02 00 00       	jmp    800f9a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d51:	56                   	push   %esi
  800d52:	68 2e 2c 80 00       	push   $0x802c2e
  800d57:	ff 75 0c             	pushl  0xc(%ebp)
  800d5a:	ff 75 08             	pushl  0x8(%ebp)
  800d5d:	e8 45 02 00 00       	call   800fa7 <printfmt>
  800d62:	83 c4 10             	add    $0x10,%esp
			break;
  800d65:	e9 30 02 00 00       	jmp    800f9a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6d:	83 c0 04             	add    $0x4,%eax
  800d70:	89 45 14             	mov    %eax,0x14(%ebp)
  800d73:	8b 45 14             	mov    0x14(%ebp),%eax
  800d76:	83 e8 04             	sub    $0x4,%eax
  800d79:	8b 30                	mov    (%eax),%esi
  800d7b:	85 f6                	test   %esi,%esi
  800d7d:	75 05                	jne    800d84 <vprintfmt+0x1a6>
				p = "(null)";
  800d7f:	be 31 2c 80 00       	mov    $0x802c31,%esi
			if (width > 0 && padc != '-')
  800d84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d88:	7e 6d                	jle    800df7 <vprintfmt+0x219>
  800d8a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d8e:	74 67                	je     800df7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	50                   	push   %eax
  800d97:	56                   	push   %esi
  800d98:	e8 0c 03 00 00       	call   8010a9 <strnlen>
  800d9d:	83 c4 10             	add    $0x10,%esp
  800da0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800da3:	eb 16                	jmp    800dbb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800da5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800da9:	83 ec 08             	sub    $0x8,%esp
  800dac:	ff 75 0c             	pushl  0xc(%ebp)
  800daf:	50                   	push   %eax
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	ff d0                	call   *%eax
  800db5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800db8:	ff 4d e4             	decl   -0x1c(%ebp)
  800dbb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbf:	7f e4                	jg     800da5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc1:	eb 34                	jmp    800df7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dc3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dc7:	74 1c                	je     800de5 <vprintfmt+0x207>
  800dc9:	83 fb 1f             	cmp    $0x1f,%ebx
  800dcc:	7e 05                	jle    800dd3 <vprintfmt+0x1f5>
  800dce:	83 fb 7e             	cmp    $0x7e,%ebx
  800dd1:	7e 12                	jle    800de5 <vprintfmt+0x207>
					putch('?', putdat);
  800dd3:	83 ec 08             	sub    $0x8,%esp
  800dd6:	ff 75 0c             	pushl  0xc(%ebp)
  800dd9:	6a 3f                	push   $0x3f
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	ff d0                	call   *%eax
  800de0:	83 c4 10             	add    $0x10,%esp
  800de3:	eb 0f                	jmp    800df4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800de5:	83 ec 08             	sub    $0x8,%esp
  800de8:	ff 75 0c             	pushl  0xc(%ebp)
  800deb:	53                   	push   %ebx
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	ff d0                	call   *%eax
  800df1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df4:	ff 4d e4             	decl   -0x1c(%ebp)
  800df7:	89 f0                	mov    %esi,%eax
  800df9:	8d 70 01             	lea    0x1(%eax),%esi
  800dfc:	8a 00                	mov    (%eax),%al
  800dfe:	0f be d8             	movsbl %al,%ebx
  800e01:	85 db                	test   %ebx,%ebx
  800e03:	74 24                	je     800e29 <vprintfmt+0x24b>
  800e05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e09:	78 b8                	js     800dc3 <vprintfmt+0x1e5>
  800e0b:	ff 4d e0             	decl   -0x20(%ebp)
  800e0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e12:	79 af                	jns    800dc3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e14:	eb 13                	jmp    800e29 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 0c             	pushl  0xc(%ebp)
  800e1c:	6a 20                	push   $0x20
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	ff d0                	call   *%eax
  800e23:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e26:	ff 4d e4             	decl   -0x1c(%ebp)
  800e29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e2d:	7f e7                	jg     800e16 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e2f:	e9 66 01 00 00       	jmp    800f9a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e34:	83 ec 08             	sub    $0x8,%esp
  800e37:	ff 75 e8             	pushl  -0x18(%ebp)
  800e3a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e3d:	50                   	push   %eax
  800e3e:	e8 3c fd ff ff       	call   800b7f <getint>
  800e43:	83 c4 10             	add    $0x10,%esp
  800e46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	85 d2                	test   %edx,%edx
  800e54:	79 23                	jns    800e79 <vprintfmt+0x29b>
				putch('-', putdat);
  800e56:	83 ec 08             	sub    $0x8,%esp
  800e59:	ff 75 0c             	pushl  0xc(%ebp)
  800e5c:	6a 2d                	push   $0x2d
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	ff d0                	call   *%eax
  800e63:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6c:	f7 d8                	neg    %eax
  800e6e:	83 d2 00             	adc    $0x0,%edx
  800e71:	f7 da                	neg    %edx
  800e73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e76:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e79:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e80:	e9 bc 00 00 00       	jmp    800f41 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e85:	83 ec 08             	sub    $0x8,%esp
  800e88:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e8e:	50                   	push   %eax
  800e8f:	e8 84 fc ff ff       	call   800b18 <getuint>
  800e94:	83 c4 10             	add    $0x10,%esp
  800e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e9d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ea4:	e9 98 00 00 00       	jmp    800f41 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ea9:	83 ec 08             	sub    $0x8,%esp
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	6a 58                	push   $0x58
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	ff d0                	call   *%eax
  800eb6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800eb9:	83 ec 08             	sub    $0x8,%esp
  800ebc:	ff 75 0c             	pushl  0xc(%ebp)
  800ebf:	6a 58                	push   $0x58
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	ff d0                	call   *%eax
  800ec6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	ff 75 0c             	pushl  0xc(%ebp)
  800ecf:	6a 58                	push   $0x58
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	ff d0                	call   *%eax
  800ed6:	83 c4 10             	add    $0x10,%esp
			break;
  800ed9:	e9 bc 00 00 00       	jmp    800f9a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ede:	83 ec 08             	sub    $0x8,%esp
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	6a 30                	push   $0x30
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	ff d0                	call   *%eax
  800eeb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800eee:	83 ec 08             	sub    $0x8,%esp
  800ef1:	ff 75 0c             	pushl  0xc(%ebp)
  800ef4:	6a 78                	push   $0x78
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	ff d0                	call   *%eax
  800efb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800efe:	8b 45 14             	mov    0x14(%ebp),%eax
  800f01:	83 c0 04             	add    $0x4,%eax
  800f04:	89 45 14             	mov    %eax,0x14(%ebp)
  800f07:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0a:	83 e8 04             	sub    $0x4,%eax
  800f0d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f19:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f20:	eb 1f                	jmp    800f41 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f22:	83 ec 08             	sub    $0x8,%esp
  800f25:	ff 75 e8             	pushl  -0x18(%ebp)
  800f28:	8d 45 14             	lea    0x14(%ebp),%eax
  800f2b:	50                   	push   %eax
  800f2c:	e8 e7 fb ff ff       	call   800b18 <getuint>
  800f31:	83 c4 10             	add    $0x10,%esp
  800f34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f37:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f41:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	52                   	push   %edx
  800f4c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f4f:	50                   	push   %eax
  800f50:	ff 75 f4             	pushl  -0xc(%ebp)
  800f53:	ff 75 f0             	pushl  -0x10(%ebp)
  800f56:	ff 75 0c             	pushl  0xc(%ebp)
  800f59:	ff 75 08             	pushl  0x8(%ebp)
  800f5c:	e8 00 fb ff ff       	call   800a61 <printnum>
  800f61:	83 c4 20             	add    $0x20,%esp
			break;
  800f64:	eb 34                	jmp    800f9a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f66:	83 ec 08             	sub    $0x8,%esp
  800f69:	ff 75 0c             	pushl  0xc(%ebp)
  800f6c:	53                   	push   %ebx
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	ff d0                	call   *%eax
  800f72:	83 c4 10             	add    $0x10,%esp
			break;
  800f75:	eb 23                	jmp    800f9a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f77:	83 ec 08             	sub    $0x8,%esp
  800f7a:	ff 75 0c             	pushl  0xc(%ebp)
  800f7d:	6a 25                	push   $0x25
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	ff d0                	call   *%eax
  800f84:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f87:	ff 4d 10             	decl   0x10(%ebp)
  800f8a:	eb 03                	jmp    800f8f <vprintfmt+0x3b1>
  800f8c:	ff 4d 10             	decl   0x10(%ebp)
  800f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f92:	48                   	dec    %eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	3c 25                	cmp    $0x25,%al
  800f97:	75 f3                	jne    800f8c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f99:	90                   	nop
		}
	}
  800f9a:	e9 47 fc ff ff       	jmp    800be6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f9f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fa3:	5b                   	pop    %ebx
  800fa4:	5e                   	pop    %esi
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    

00800fa7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fad:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb0:	83 c0 04             	add    $0x4,%eax
  800fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbc:	50                   	push   %eax
  800fbd:	ff 75 0c             	pushl  0xc(%ebp)
  800fc0:	ff 75 08             	pushl  0x8(%ebp)
  800fc3:	e8 16 fc ff ff       	call   800bde <vprintfmt>
  800fc8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fcb:	90                   	nop
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	8b 40 08             	mov    0x8(%eax),%eax
  800fd7:	8d 50 01             	lea    0x1(%eax),%edx
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe3:	8b 10                	mov    (%eax),%edx
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	8b 40 04             	mov    0x4(%eax),%eax
  800feb:	39 c2                	cmp    %eax,%edx
  800fed:	73 12                	jae    801001 <sprintputch+0x33>
		*b->buf++ = ch;
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	8b 00                	mov    (%eax),%eax
  800ff4:	8d 48 01             	lea    0x1(%eax),%ecx
  800ff7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffa:	89 0a                	mov    %ecx,(%edx)
  800ffc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fff:	88 10                	mov    %dl,(%eax)
}
  801001:	90                   	nop
  801002:	5d                   	pop    %ebp
  801003:	c3                   	ret    

00801004 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	8d 50 ff             	lea    -0x1(%eax),%edx
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	01 d0                	add    %edx,%eax
  80101b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80101e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801025:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801029:	74 06                	je     801031 <vsnprintf+0x2d>
  80102b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102f:	7f 07                	jg     801038 <vsnprintf+0x34>
		return -E_INVAL;
  801031:	b8 03 00 00 00       	mov    $0x3,%eax
  801036:	eb 20                	jmp    801058 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801038:	ff 75 14             	pushl  0x14(%ebp)
  80103b:	ff 75 10             	pushl  0x10(%ebp)
  80103e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801041:	50                   	push   %eax
  801042:	68 ce 0f 80 00       	push   $0x800fce
  801047:	e8 92 fb ff ff       	call   800bde <vprintfmt>
  80104c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80104f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801052:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801055:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801060:	8d 45 10             	lea    0x10(%ebp),%eax
  801063:	83 c0 04             	add    $0x4,%eax
  801066:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801069:	8b 45 10             	mov    0x10(%ebp),%eax
  80106c:	ff 75 f4             	pushl  -0xc(%ebp)
  80106f:	50                   	push   %eax
  801070:	ff 75 0c             	pushl  0xc(%ebp)
  801073:	ff 75 08             	pushl  0x8(%ebp)
  801076:	e8 89 ff ff ff       	call   801004 <vsnprintf>
  80107b:	83 c4 10             	add    $0x10,%esp
  80107e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801081:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801084:	c9                   	leave  
  801085:	c3                   	ret    

00801086 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80108c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801093:	eb 06                	jmp    80109b <strlen+0x15>
		n++;
  801095:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801098:	ff 45 08             	incl   0x8(%ebp)
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	84 c0                	test   %al,%al
  8010a2:	75 f1                	jne    801095 <strlen+0xf>
		n++;
	return n;
  8010a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a7:	c9                   	leave  
  8010a8:	c3                   	ret    

008010a9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b6:	eb 09                	jmp    8010c1 <strnlen+0x18>
		n++;
  8010b8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010bb:	ff 45 08             	incl   0x8(%ebp)
  8010be:	ff 4d 0c             	decl   0xc(%ebp)
  8010c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010c5:	74 09                	je     8010d0 <strnlen+0x27>
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	84 c0                	test   %al,%al
  8010ce:	75 e8                	jne    8010b8 <strnlen+0xf>
		n++;
	return n;
  8010d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010e1:	90                   	nop
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8d 50 01             	lea    0x1(%eax),%edx
  8010e8:	89 55 08             	mov    %edx,0x8(%ebp)
  8010eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010f4:	8a 12                	mov    (%edx),%dl
  8010f6:	88 10                	mov    %dl,(%eax)
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	84 c0                	test   %al,%al
  8010fc:	75 e4                	jne    8010e2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80110f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801116:	eb 1f                	jmp    801137 <strncpy+0x34>
		*dst++ = *src;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8d 50 01             	lea    0x1(%eax),%edx
  80111e:	89 55 08             	mov    %edx,0x8(%ebp)
  801121:	8b 55 0c             	mov    0xc(%ebp),%edx
  801124:	8a 12                	mov    (%edx),%dl
  801126:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	84 c0                	test   %al,%al
  80112f:	74 03                	je     801134 <strncpy+0x31>
			src++;
  801131:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801134:	ff 45 fc             	incl   -0x4(%ebp)
  801137:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80113d:	72 d9                	jb     801118 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80113f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801142:	c9                   	leave  
  801143:	c3                   	ret    

00801144 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801150:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801154:	74 30                	je     801186 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801156:	eb 16                	jmp    80116e <strlcpy+0x2a>
			*dst++ = *src++;
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8d 50 01             	lea    0x1(%eax),%edx
  80115e:	89 55 08             	mov    %edx,0x8(%ebp)
  801161:	8b 55 0c             	mov    0xc(%ebp),%edx
  801164:	8d 4a 01             	lea    0x1(%edx),%ecx
  801167:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80116a:	8a 12                	mov    (%edx),%dl
  80116c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80116e:	ff 4d 10             	decl   0x10(%ebp)
  801171:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801175:	74 09                	je     801180 <strlcpy+0x3c>
  801177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	84 c0                	test   %al,%al
  80117e:	75 d8                	jne    801158 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801186:	8b 55 08             	mov    0x8(%ebp),%edx
  801189:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118c:	29 c2                	sub    %eax,%edx
  80118e:	89 d0                	mov    %edx,%eax
}
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801195:	eb 06                	jmp    80119d <strcmp+0xb>
		p++, q++;
  801197:	ff 45 08             	incl   0x8(%ebp)
  80119a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	84 c0                	test   %al,%al
  8011a4:	74 0e                	je     8011b4 <strcmp+0x22>
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 10                	mov    (%eax),%dl
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	38 c2                	cmp    %al,%dl
  8011b2:	74 e3                	je     801197 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	0f b6 d0             	movzbl %al,%edx
  8011bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	0f b6 c0             	movzbl %al,%eax
  8011c4:	29 c2                	sub    %eax,%edx
  8011c6:	89 d0                	mov    %edx,%eax
}
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    

008011ca <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011cd:	eb 09                	jmp    8011d8 <strncmp+0xe>
		n--, p++, q++;
  8011cf:	ff 4d 10             	decl   0x10(%ebp)
  8011d2:	ff 45 08             	incl   0x8(%ebp)
  8011d5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011dc:	74 17                	je     8011f5 <strncmp+0x2b>
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	84 c0                	test   %al,%al
  8011e5:	74 0e                	je     8011f5 <strncmp+0x2b>
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 10                	mov    (%eax),%dl
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	8a 00                	mov    (%eax),%al
  8011f1:	38 c2                	cmp    %al,%dl
  8011f3:	74 da                	je     8011cf <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f9:	75 07                	jne    801202 <strncmp+0x38>
		return 0;
  8011fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801200:	eb 14                	jmp    801216 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	0f b6 d0             	movzbl %al,%edx
  80120a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120d:	8a 00                	mov    (%eax),%al
  80120f:	0f b6 c0             	movzbl %al,%eax
  801212:	29 c2                	sub    %eax,%edx
  801214:	89 d0                	mov    %edx,%eax
}
  801216:	5d                   	pop    %ebp
  801217:	c3                   	ret    

00801218 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801224:	eb 12                	jmp    801238 <strchr+0x20>
		if (*s == c)
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80122e:	75 05                	jne    801235 <strchr+0x1d>
			return (char *) s;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	eb 11                	jmp    801246 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801235:	ff 45 08             	incl   0x8(%ebp)
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	84 c0                	test   %al,%al
  80123f:	75 e5                	jne    801226 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801241:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801246:	c9                   	leave  
  801247:	c3                   	ret    

00801248 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
  80124b:	83 ec 04             	sub    $0x4,%esp
  80124e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801251:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801254:	eb 0d                	jmp    801263 <strfind+0x1b>
		if (*s == c)
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80125e:	74 0e                	je     80126e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801260:	ff 45 08             	incl   0x8(%ebp)
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	84 c0                	test   %al,%al
  80126a:	75 ea                	jne    801256 <strfind+0xe>
  80126c:	eb 01                	jmp    80126f <strfind+0x27>
		if (*s == c)
			break;
  80126e:	90                   	nop
	return (char *) s;
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801272:	c9                   	leave  
  801273:	c3                   	ret    

00801274 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801286:	eb 0e                	jmp    801296 <memset+0x22>
		*p++ = c;
  801288:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128b:	8d 50 01             	lea    0x1(%eax),%edx
  80128e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801291:	8b 55 0c             	mov    0xc(%ebp),%edx
  801294:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801296:	ff 4d f8             	decl   -0x8(%ebp)
  801299:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80129d:	79 e9                	jns    801288 <memset+0x14>
		*p++ = c;

	return v;
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8012b6:	eb 16                	jmp    8012ce <memcpy+0x2a>
		*d++ = *s++;
  8012b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012bb:	8d 50 01             	lea    0x1(%eax),%edx
  8012be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012ca:	8a 12                	mov    (%edx),%dl
  8012cc:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	75 dd                	jne    8012b8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012f8:	73 50                	jae    80134a <memmove+0x6a>
  8012fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 d0                	add    %edx,%eax
  801302:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801305:	76 43                	jbe    80134a <memmove+0x6a>
		s += n;
  801307:	8b 45 10             	mov    0x10(%ebp),%eax
  80130a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80130d:	8b 45 10             	mov    0x10(%ebp),%eax
  801310:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801313:	eb 10                	jmp    801325 <memmove+0x45>
			*--d = *--s;
  801315:	ff 4d f8             	decl   -0x8(%ebp)
  801318:	ff 4d fc             	decl   -0x4(%ebp)
  80131b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131e:	8a 10                	mov    (%eax),%dl
  801320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801323:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801325:	8b 45 10             	mov    0x10(%ebp),%eax
  801328:	8d 50 ff             	lea    -0x1(%eax),%edx
  80132b:	89 55 10             	mov    %edx,0x10(%ebp)
  80132e:	85 c0                	test   %eax,%eax
  801330:	75 e3                	jne    801315 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801332:	eb 23                	jmp    801357 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801334:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801337:	8d 50 01             	lea    0x1(%eax),%edx
  80133a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80133d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801340:	8d 4a 01             	lea    0x1(%edx),%ecx
  801343:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801346:	8a 12                	mov    (%edx),%dl
  801348:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80134a:	8b 45 10             	mov    0x10(%ebp),%eax
  80134d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801350:	89 55 10             	mov    %edx,0x10(%ebp)
  801353:	85 c0                	test   %eax,%eax
  801355:	75 dd                	jne    801334 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80136e:	eb 2a                	jmp    80139a <memcmp+0x3e>
		if (*s1 != *s2)
  801370:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801373:	8a 10                	mov    (%eax),%dl
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801378:	8a 00                	mov    (%eax),%al
  80137a:	38 c2                	cmp    %al,%dl
  80137c:	74 16                	je     801394 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80137e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	0f b6 d0             	movzbl %al,%edx
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801389:	8a 00                	mov    (%eax),%al
  80138b:	0f b6 c0             	movzbl %al,%eax
  80138e:	29 c2                	sub    %eax,%edx
  801390:	89 d0                	mov    %edx,%eax
  801392:	eb 18                	jmp    8013ac <memcmp+0x50>
		s1++, s2++;
  801394:	ff 45 fc             	incl   -0x4(%ebp)
  801397:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	75 c9                	jne    801370 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ba:	01 d0                	add    %edx,%eax
  8013bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013bf:	eb 15                	jmp    8013d6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	0f b6 d0             	movzbl %al,%edx
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cc:	0f b6 c0             	movzbl %al,%eax
  8013cf:	39 c2                	cmp    %eax,%edx
  8013d1:	74 0d                	je     8013e0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013d3:	ff 45 08             	incl   0x8(%ebp)
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013dc:	72 e3                	jb     8013c1 <memfind+0x13>
  8013de:	eb 01                	jmp    8013e1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013e0:	90                   	nop
	return (void *) s;
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    

008013e6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
  8013e9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013fa:	eb 03                	jmp    8013ff <strtol+0x19>
		s++;
  8013fc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	3c 20                	cmp    $0x20,%al
  801406:	74 f4                	je     8013fc <strtol+0x16>
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	3c 09                	cmp    $0x9,%al
  80140f:	74 eb                	je     8013fc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 2b                	cmp    $0x2b,%al
  801418:	75 05                	jne    80141f <strtol+0x39>
		s++;
  80141a:	ff 45 08             	incl   0x8(%ebp)
  80141d:	eb 13                	jmp    801432 <strtol+0x4c>
	else if (*s == '-')
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	3c 2d                	cmp    $0x2d,%al
  801426:	75 0a                	jne    801432 <strtol+0x4c>
		s++, neg = 1;
  801428:	ff 45 08             	incl   0x8(%ebp)
  80142b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801432:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801436:	74 06                	je     80143e <strtol+0x58>
  801438:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80143c:	75 20                	jne    80145e <strtol+0x78>
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	3c 30                	cmp    $0x30,%al
  801445:	75 17                	jne    80145e <strtol+0x78>
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	40                   	inc    %eax
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	3c 78                	cmp    $0x78,%al
  80144f:	75 0d                	jne    80145e <strtol+0x78>
		s += 2, base = 16;
  801451:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801455:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80145c:	eb 28                	jmp    801486 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80145e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801462:	75 15                	jne    801479 <strtol+0x93>
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	3c 30                	cmp    $0x30,%al
  80146b:	75 0c                	jne    801479 <strtol+0x93>
		s++, base = 8;
  80146d:	ff 45 08             	incl   0x8(%ebp)
  801470:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801477:	eb 0d                	jmp    801486 <strtol+0xa0>
	else if (base == 0)
  801479:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147d:	75 07                	jne    801486 <strtol+0xa0>
		base = 10;
  80147f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	8a 00                	mov    (%eax),%al
  80148b:	3c 2f                	cmp    $0x2f,%al
  80148d:	7e 19                	jle    8014a8 <strtol+0xc2>
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	3c 39                	cmp    $0x39,%al
  801496:	7f 10                	jg     8014a8 <strtol+0xc2>
			dig = *s - '0';
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	0f be c0             	movsbl %al,%eax
  8014a0:	83 e8 30             	sub    $0x30,%eax
  8014a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014a6:	eb 42                	jmp    8014ea <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	8a 00                	mov    (%eax),%al
  8014ad:	3c 60                	cmp    $0x60,%al
  8014af:	7e 19                	jle    8014ca <strtol+0xe4>
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	3c 7a                	cmp    $0x7a,%al
  8014b8:	7f 10                	jg     8014ca <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	0f be c0             	movsbl %al,%eax
  8014c2:	83 e8 57             	sub    $0x57,%eax
  8014c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014c8:	eb 20                	jmp    8014ea <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	3c 40                	cmp    $0x40,%al
  8014d1:	7e 39                	jle    80150c <strtol+0x126>
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	3c 5a                	cmp    $0x5a,%al
  8014da:	7f 30                	jg     80150c <strtol+0x126>
			dig = *s - 'A' + 10;
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	0f be c0             	movsbl %al,%eax
  8014e4:	83 e8 37             	sub    $0x37,%eax
  8014e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ed:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f0:	7d 19                	jge    80150b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014f2:	ff 45 08             	incl   0x8(%ebp)
  8014f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014fc:	89 c2                	mov    %eax,%edx
  8014fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801501:	01 d0                	add    %edx,%eax
  801503:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801506:	e9 7b ff ff ff       	jmp    801486 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80150b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80150c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801510:	74 08                	je     80151a <strtol+0x134>
		*endptr = (char *) s;
  801512:	8b 45 0c             	mov    0xc(%ebp),%eax
  801515:	8b 55 08             	mov    0x8(%ebp),%edx
  801518:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80151a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80151e:	74 07                	je     801527 <strtol+0x141>
  801520:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801523:	f7 d8                	neg    %eax
  801525:	eb 03                	jmp    80152a <strtol+0x144>
  801527:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <ltostr>:

void
ltostr(long value, char *str)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801532:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801539:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801540:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801544:	79 13                	jns    801559 <ltostr+0x2d>
	{
		neg = 1;
  801546:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801553:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801556:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801561:	99                   	cltd   
  801562:	f7 f9                	idiv   %ecx
  801564:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801567:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156a:	8d 50 01             	lea    0x1(%eax),%edx
  80156d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801570:	89 c2                	mov    %eax,%edx
  801572:	8b 45 0c             	mov    0xc(%ebp),%eax
  801575:	01 d0                	add    %edx,%eax
  801577:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80157a:	83 c2 30             	add    $0x30,%edx
  80157d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80157f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801582:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801587:	f7 e9                	imul   %ecx
  801589:	c1 fa 02             	sar    $0x2,%edx
  80158c:	89 c8                	mov    %ecx,%eax
  80158e:	c1 f8 1f             	sar    $0x1f,%eax
  801591:	29 c2                	sub    %eax,%edx
  801593:	89 d0                	mov    %edx,%eax
  801595:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801598:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80159b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015a0:	f7 e9                	imul   %ecx
  8015a2:	c1 fa 02             	sar    $0x2,%edx
  8015a5:	89 c8                	mov    %ecx,%eax
  8015a7:	c1 f8 1f             	sar    $0x1f,%eax
  8015aa:	29 c2                	sub    %eax,%edx
  8015ac:	89 d0                	mov    %edx,%eax
  8015ae:	c1 e0 02             	shl    $0x2,%eax
  8015b1:	01 d0                	add    %edx,%eax
  8015b3:	01 c0                	add    %eax,%eax
  8015b5:	29 c1                	sub    %eax,%ecx
  8015b7:	89 ca                	mov    %ecx,%edx
  8015b9:	85 d2                	test   %edx,%edx
  8015bb:	75 9c                	jne    801559 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c7:	48                   	dec    %eax
  8015c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015cf:	74 3d                	je     80160e <ltostr+0xe2>
		start = 1 ;
  8015d1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015d8:	eb 34                	jmp    80160e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e0:	01 d0                	add    %edx,%eax
  8015e2:	8a 00                	mov    (%eax),%al
  8015e4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ed:	01 c2                	add    %eax,%edx
  8015ef:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f5:	01 c8                	add    %ecx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801601:	01 c2                	add    %eax,%edx
  801603:	8a 45 eb             	mov    -0x15(%ebp),%al
  801606:	88 02                	mov    %al,(%edx)
		start++ ;
  801608:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80160b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80160e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801611:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801614:	7c c4                	jl     8015da <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801616:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801619:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161c:	01 d0                	add    %edx,%eax
  80161e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801621:	90                   	nop
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80162a:	ff 75 08             	pushl  0x8(%ebp)
  80162d:	e8 54 fa ff ff       	call   801086 <strlen>
  801632:	83 c4 04             	add    $0x4,%esp
  801635:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801638:	ff 75 0c             	pushl  0xc(%ebp)
  80163b:	e8 46 fa ff ff       	call   801086 <strlen>
  801640:	83 c4 04             	add    $0x4,%esp
  801643:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801646:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80164d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801654:	eb 17                	jmp    80166d <strcconcat+0x49>
		final[s] = str1[s] ;
  801656:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801659:	8b 45 10             	mov    0x10(%ebp),%eax
  80165c:	01 c2                	add    %eax,%edx
  80165e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	01 c8                	add    %ecx,%eax
  801666:	8a 00                	mov    (%eax),%al
  801668:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80166a:	ff 45 fc             	incl   -0x4(%ebp)
  80166d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801670:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801673:	7c e1                	jl     801656 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801675:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80167c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801683:	eb 1f                	jmp    8016a4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801685:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801688:	8d 50 01             	lea    0x1(%eax),%edx
  80168b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80168e:	89 c2                	mov    %eax,%edx
  801690:	8b 45 10             	mov    0x10(%ebp),%eax
  801693:	01 c2                	add    %eax,%edx
  801695:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169b:	01 c8                	add    %ecx,%eax
  80169d:	8a 00                	mov    (%eax),%al
  80169f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016a1:	ff 45 f8             	incl   -0x8(%ebp)
  8016a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016aa:	7c d9                	jl     801685 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	01 d0                	add    %edx,%eax
  8016b4:	c6 00 00             	movb   $0x0,(%eax)
}
  8016b7:	90                   	nop
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c9:	8b 00                	mov    (%eax),%eax
  8016cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d5:	01 d0                	add    %edx,%eax
  8016d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016dd:	eb 0c                	jmp    8016eb <strsplit+0x31>
			*string++ = 0;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8d 50 01             	lea    0x1(%eax),%edx
  8016e5:	89 55 08             	mov    %edx,0x8(%ebp)
  8016e8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	84 c0                	test   %al,%al
  8016f2:	74 18                	je     80170c <strsplit+0x52>
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	8a 00                	mov    (%eax),%al
  8016f9:	0f be c0             	movsbl %al,%eax
  8016fc:	50                   	push   %eax
  8016fd:	ff 75 0c             	pushl  0xc(%ebp)
  801700:	e8 13 fb ff ff       	call   801218 <strchr>
  801705:	83 c4 08             	add    $0x8,%esp
  801708:	85 c0                	test   %eax,%eax
  80170a:	75 d3                	jne    8016df <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	8a 00                	mov    (%eax),%al
  801711:	84 c0                	test   %al,%al
  801713:	74 5a                	je     80176f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801715:	8b 45 14             	mov    0x14(%ebp),%eax
  801718:	8b 00                	mov    (%eax),%eax
  80171a:	83 f8 0f             	cmp    $0xf,%eax
  80171d:	75 07                	jne    801726 <strsplit+0x6c>
		{
			return 0;
  80171f:	b8 00 00 00 00       	mov    $0x0,%eax
  801724:	eb 66                	jmp    80178c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801726:	8b 45 14             	mov    0x14(%ebp),%eax
  801729:	8b 00                	mov    (%eax),%eax
  80172b:	8d 48 01             	lea    0x1(%eax),%ecx
  80172e:	8b 55 14             	mov    0x14(%ebp),%edx
  801731:	89 0a                	mov    %ecx,(%edx)
  801733:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80173a:	8b 45 10             	mov    0x10(%ebp),%eax
  80173d:	01 c2                	add    %eax,%edx
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801744:	eb 03                	jmp    801749 <strsplit+0x8f>
			string++;
  801746:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8a 00                	mov    (%eax),%al
  80174e:	84 c0                	test   %al,%al
  801750:	74 8b                	je     8016dd <strsplit+0x23>
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	0f be c0             	movsbl %al,%eax
  80175a:	50                   	push   %eax
  80175b:	ff 75 0c             	pushl  0xc(%ebp)
  80175e:	e8 b5 fa ff ff       	call   801218 <strchr>
  801763:	83 c4 08             	add    $0x8,%esp
  801766:	85 c0                	test   %eax,%eax
  801768:	74 dc                	je     801746 <strsplit+0x8c>
			string++;
	}
  80176a:	e9 6e ff ff ff       	jmp    8016dd <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80176f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801770:	8b 45 14             	mov    0x14(%ebp),%eax
  801773:	8b 00                	mov    (%eax),%eax
  801775:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80177c:	8b 45 10             	mov    0x10(%ebp),%eax
  80177f:	01 d0                	add    %edx,%eax
  801781:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801787:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801794:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  80179b:	8b 55 08             	mov    0x8(%ebp),%edx
  80179e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8017a1:	01 d0                	add    %edx,%eax
  8017a3:	48                   	dec    %eax
  8017a4:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8017a7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8017aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8017af:	f7 75 ac             	divl   -0x54(%ebp)
  8017b2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8017b5:	29 d0                	sub    %edx,%eax
  8017b7:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8017ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8017c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8017c8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8017cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8017d6:	eb 3f                	jmp    801817 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8017d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017db:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8017e2:	83 ec 04             	sub    $0x4,%esp
  8017e5:	50                   	push   %eax
  8017e6:	ff 75 e8             	pushl  -0x18(%ebp)
  8017e9:	68 90 2d 80 00       	push   $0x802d90
  8017ee:	e8 11 f2 ff ff       	call   800a04 <cprintf>
  8017f3:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  8017f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017f9:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801800:	83 ec 04             	sub    $0x4,%esp
  801803:	50                   	push   %eax
  801804:	ff 75 e8             	pushl  -0x18(%ebp)
  801807:	68 a5 2d 80 00       	push   $0x802da5
  80180c:	e8 f3 f1 ff ff       	call   800a04 <cprintf>
  801811:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801814:	ff 45 e8             	incl   -0x18(%ebp)
  801817:	a1 28 30 80 00       	mov    0x803028,%eax
  80181c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80181f:	7c b7                	jl     8017d8 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801821:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801828:	e9 42 01 00 00       	jmp    80196f <malloc+0x1e1>
		int flag0=1;
  80182d:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801837:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80183a:	eb 6b                	jmp    8018a7 <malloc+0x119>
			for(int k=0;k<count;k++){
  80183c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801843:	eb 42                	jmp    801887 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801845:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801848:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80184f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801852:	39 c2                	cmp    %eax,%edx
  801854:	77 2e                	ja     801884 <malloc+0xf6>
  801856:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801859:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801860:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801863:	39 c2                	cmp    %eax,%edx
  801865:	76 1d                	jbe    801884 <malloc+0xf6>
					ni=arr_add[k].end-i;
  801867:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80186a:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801874:	29 c2                	sub    %eax,%edx
  801876:	89 d0                	mov    %edx,%eax
  801878:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  80187b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801882:	eb 0d                	jmp    801891 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801884:	ff 45 d8             	incl   -0x28(%ebp)
  801887:	a1 28 30 80 00       	mov    0x803028,%eax
  80188c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80188f:	7c b4                	jl     801845 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801891:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801895:	74 09                	je     8018a0 <malloc+0x112>
				flag0=0;
  801897:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  80189e:	eb 16                	jmp    8018b6 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8018a0:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8018a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	01 c2                	add    %eax,%edx
  8018af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018b2:	39 c2                	cmp    %eax,%edx
  8018b4:	77 86                	ja     80183c <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8018b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018ba:	0f 84 a2 00 00 00    	je     801962 <malloc+0x1d4>

			int f=1;
  8018c0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  8018c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018ca:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8018cd:	89 c8                	mov    %ecx,%eax
  8018cf:	01 c0                	add    %eax,%eax
  8018d1:	01 c8                	add    %ecx,%eax
  8018d3:	c1 e0 02             	shl    $0x2,%eax
  8018d6:	05 20 31 80 00       	add    $0x803120,%eax
  8018db:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  8018dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8018e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e9:	89 d0                	mov    %edx,%eax
  8018eb:	01 c0                	add    %eax,%eax
  8018ed:	01 d0                	add    %edx,%eax
  8018ef:	c1 e0 02             	shl    $0x2,%eax
  8018f2:	05 24 31 80 00       	add    $0x803124,%eax
  8018f7:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  8018f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018fc:	89 d0                	mov    %edx,%eax
  8018fe:	01 c0                	add    %eax,%eax
  801900:	01 d0                	add    %edx,%eax
  801902:	c1 e0 02             	shl    $0x2,%eax
  801905:	05 28 31 80 00       	add    $0x803128,%eax
  80190a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801910:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801913:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80191a:	eb 36                	jmp    801952 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  80191c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	01 c2                	add    %eax,%edx
  801924:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801927:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80192e:	39 c2                	cmp    %eax,%edx
  801930:	73 1d                	jae    80194f <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801932:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801935:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80193c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80193f:	29 c2                	sub    %eax,%edx
  801941:	89 d0                	mov    %edx,%eax
  801943:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801946:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  80194d:	eb 0d                	jmp    80195c <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  80194f:	ff 45 d0             	incl   -0x30(%ebp)
  801952:	a1 28 30 80 00       	mov    0x803028,%eax
  801957:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  80195a:	7c c0                	jl     80191c <malloc+0x18e>
					break;

				}
			}

			if(f){
  80195c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801960:	75 1d                	jne    80197f <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801962:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801969:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196c:	01 45 e4             	add    %eax,-0x1c(%ebp)
  80196f:	a1 04 30 80 00       	mov    0x803004,%eax
  801974:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801977:	0f 8c b0 fe ff ff    	jl     80182d <malloc+0x9f>
  80197d:	eb 01                	jmp    801980 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  80197f:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801980:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801984:	75 7a                	jne    801a00 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801986:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	01 d0                	add    %edx,%eax
  801991:	48                   	dec    %eax
  801992:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801997:	7c 0a                	jl     8019a3 <malloc+0x215>
			return NULL;
  801999:	b8 00 00 00 00       	mov    $0x0,%eax
  80199e:	e9 a4 02 00 00       	jmp    801c47 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  8019a3:	a1 04 30 80 00       	mov    0x803004,%eax
  8019a8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8019ab:	a1 28 30 80 00       	mov    0x803028,%eax
  8019b0:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8019b3:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  8019ba:	83 ec 08             	sub    $0x8,%esp
  8019bd:	ff 75 08             	pushl  0x8(%ebp)
  8019c0:	ff 75 a4             	pushl  -0x5c(%ebp)
  8019c3:	e8 04 06 00 00       	call   801fcc <sys_allocateMem>
  8019c8:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  8019cb:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	01 d0                	add    %edx,%eax
  8019d6:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  8019db:	a1 28 30 80 00       	mov    0x803028,%eax
  8019e0:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8019e6:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  8019ed:	a1 28 30 80 00       	mov    0x803028,%eax
  8019f2:	40                   	inc    %eax
  8019f3:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  8019f8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8019fb:	e9 47 02 00 00       	jmp    801c47 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801a00:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801a07:	e9 ac 00 00 00       	jmp    801ab8 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801a0c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801a0f:	89 d0                	mov    %edx,%eax
  801a11:	01 c0                	add    %eax,%eax
  801a13:	01 d0                	add    %edx,%eax
  801a15:	c1 e0 02             	shl    $0x2,%eax
  801a18:	05 24 31 80 00       	add    $0x803124,%eax
  801a1d:	8b 00                	mov    (%eax),%eax
  801a1f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801a22:	eb 7e                	jmp    801aa2 <malloc+0x314>
			int flag=0;
  801a24:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801a2b:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801a32:	eb 57                	jmp    801a8b <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801a34:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a37:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801a3e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a41:	39 c2                	cmp    %eax,%edx
  801a43:	77 1a                	ja     801a5f <malloc+0x2d1>
  801a45:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a48:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801a4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a52:	39 c2                	cmp    %eax,%edx
  801a54:	76 09                	jbe    801a5f <malloc+0x2d1>
								flag=1;
  801a56:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801a5d:	eb 36                	jmp    801a95 <malloc+0x307>
			arr[i].space++;
  801a5f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801a62:	89 d0                	mov    %edx,%eax
  801a64:	01 c0                	add    %eax,%eax
  801a66:	01 d0                	add    %edx,%eax
  801a68:	c1 e0 02             	shl    $0x2,%eax
  801a6b:	05 28 31 80 00       	add    $0x803128,%eax
  801a70:	8b 00                	mov    (%eax),%eax
  801a72:	8d 48 01             	lea    0x1(%eax),%ecx
  801a75:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801a78:	89 d0                	mov    %edx,%eax
  801a7a:	01 c0                	add    %eax,%eax
  801a7c:	01 d0                	add    %edx,%eax
  801a7e:	c1 e0 02             	shl    $0x2,%eax
  801a81:	05 28 31 80 00       	add    $0x803128,%eax
  801a86:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801a88:	ff 45 c0             	incl   -0x40(%ebp)
  801a8b:	a1 28 30 80 00       	mov    0x803028,%eax
  801a90:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801a93:	7c 9f                	jl     801a34 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801a95:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801a99:	75 19                	jne    801ab4 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801a9b:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801aa2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801aa5:	a1 04 30 80 00       	mov    0x803004,%eax
  801aaa:	39 c2                	cmp    %eax,%edx
  801aac:	0f 82 72 ff ff ff    	jb     801a24 <malloc+0x296>
  801ab2:	eb 01                	jmp    801ab5 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801ab4:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801ab5:	ff 45 cc             	incl   -0x34(%ebp)
  801ab8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801abb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801abe:	0f 8c 48 ff ff ff    	jl     801a0c <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801ac4:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801acb:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801ad2:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801ad9:	eb 37                	jmp    801b12 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801adb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801ade:	89 d0                	mov    %edx,%eax
  801ae0:	01 c0                	add    %eax,%eax
  801ae2:	01 d0                	add    %edx,%eax
  801ae4:	c1 e0 02             	shl    $0x2,%eax
  801ae7:	05 28 31 80 00       	add    $0x803128,%eax
  801aec:	8b 00                	mov    (%eax),%eax
  801aee:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801af1:	7d 1c                	jge    801b0f <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801af3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801af6:	89 d0                	mov    %edx,%eax
  801af8:	01 c0                	add    %eax,%eax
  801afa:	01 d0                	add    %edx,%eax
  801afc:	c1 e0 02             	shl    $0x2,%eax
  801aff:	05 28 31 80 00       	add    $0x803128,%eax
  801b04:	8b 00                	mov    (%eax),%eax
  801b06:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801b09:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801b0c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801b0f:	ff 45 b4             	incl   -0x4c(%ebp)
  801b12:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801b15:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b18:	7c c1                	jl     801adb <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801b1a:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801b20:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801b23:	89 c8                	mov    %ecx,%eax
  801b25:	01 c0                	add    %eax,%eax
  801b27:	01 c8                	add    %ecx,%eax
  801b29:	c1 e0 02             	shl    $0x2,%eax
  801b2c:	05 20 31 80 00       	add    $0x803120,%eax
  801b31:	8b 00                	mov    (%eax),%eax
  801b33:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801b3a:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801b40:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801b43:	89 c8                	mov    %ecx,%eax
  801b45:	01 c0                	add    %eax,%eax
  801b47:	01 c8                	add    %ecx,%eax
  801b49:	c1 e0 02             	shl    $0x2,%eax
  801b4c:	05 24 31 80 00       	add    $0x803124,%eax
  801b51:	8b 00                	mov    (%eax),%eax
  801b53:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  801b5a:	a1 28 30 80 00       	mov    0x803028,%eax
  801b5f:	40                   	inc    %eax
  801b60:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  801b65:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801b68:	89 d0                	mov    %edx,%eax
  801b6a:	01 c0                	add    %eax,%eax
  801b6c:	01 d0                	add    %edx,%eax
  801b6e:	c1 e0 02             	shl    $0x2,%eax
  801b71:	05 20 31 80 00       	add    $0x803120,%eax
  801b76:	8b 00                	mov    (%eax),%eax
  801b78:	83 ec 08             	sub    $0x8,%esp
  801b7b:	ff 75 08             	pushl  0x8(%ebp)
  801b7e:	50                   	push   %eax
  801b7f:	e8 48 04 00 00       	call   801fcc <sys_allocateMem>
  801b84:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801b87:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801b8e:	eb 78                	jmp    801c08 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801b90:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801b93:	89 d0                	mov    %edx,%eax
  801b95:	01 c0                	add    %eax,%eax
  801b97:	01 d0                	add    %edx,%eax
  801b99:	c1 e0 02             	shl    $0x2,%eax
  801b9c:	05 20 31 80 00       	add    $0x803120,%eax
  801ba1:	8b 00                	mov    (%eax),%eax
  801ba3:	83 ec 04             	sub    $0x4,%esp
  801ba6:	50                   	push   %eax
  801ba7:	ff 75 b0             	pushl  -0x50(%ebp)
  801baa:	68 90 2d 80 00       	push   $0x802d90
  801baf:	e8 50 ee ff ff       	call   800a04 <cprintf>
  801bb4:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801bb7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801bba:	89 d0                	mov    %edx,%eax
  801bbc:	01 c0                	add    %eax,%eax
  801bbe:	01 d0                	add    %edx,%eax
  801bc0:	c1 e0 02             	shl    $0x2,%eax
  801bc3:	05 24 31 80 00       	add    $0x803124,%eax
  801bc8:	8b 00                	mov    (%eax),%eax
  801bca:	83 ec 04             	sub    $0x4,%esp
  801bcd:	50                   	push   %eax
  801bce:	ff 75 b0             	pushl  -0x50(%ebp)
  801bd1:	68 a5 2d 80 00       	push   $0x802da5
  801bd6:	e8 29 ee ff ff       	call   800a04 <cprintf>
  801bdb:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801bde:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801be1:	89 d0                	mov    %edx,%eax
  801be3:	01 c0                	add    %eax,%eax
  801be5:	01 d0                	add    %edx,%eax
  801be7:	c1 e0 02             	shl    $0x2,%eax
  801bea:	05 28 31 80 00       	add    $0x803128,%eax
  801bef:	8b 00                	mov    (%eax),%eax
  801bf1:	83 ec 04             	sub    $0x4,%esp
  801bf4:	50                   	push   %eax
  801bf5:	ff 75 b0             	pushl  -0x50(%ebp)
  801bf8:	68 b8 2d 80 00       	push   $0x802db8
  801bfd:	e8 02 ee ff ff       	call   800a04 <cprintf>
  801c02:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801c05:	ff 45 b0             	incl   -0x50(%ebp)
  801c08:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801c0b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c0e:	7c 80                	jl     801b90 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801c10:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801c13:	89 d0                	mov    %edx,%eax
  801c15:	01 c0                	add    %eax,%eax
  801c17:	01 d0                	add    %edx,%eax
  801c19:	c1 e0 02             	shl    $0x2,%eax
  801c1c:	05 20 31 80 00       	add    $0x803120,%eax
  801c21:	8b 00                	mov    (%eax),%eax
  801c23:	83 ec 08             	sub    $0x8,%esp
  801c26:	50                   	push   %eax
  801c27:	68 cc 2d 80 00       	push   $0x802dcc
  801c2c:	e8 d3 ed ff ff       	call   800a04 <cprintf>
  801c31:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801c34:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801c37:	89 d0                	mov    %edx,%eax
  801c39:	01 c0                	add    %eax,%eax
  801c3b:	01 d0                	add    %edx,%eax
  801c3d:	c1 e0 02             	shl    $0x2,%eax
  801c40:	05 20 31 80 00       	add    $0x803120,%eax
  801c45:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801c55:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801c5c:	eb 4b                	jmp    801ca9 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801c5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c61:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801c68:	89 c2                	mov    %eax,%edx
  801c6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c6d:	39 c2                	cmp    %eax,%edx
  801c6f:	7f 35                	jg     801ca6 <free+0x5d>
  801c71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c74:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801c7b:	89 c2                	mov    %eax,%edx
  801c7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c80:	39 c2                	cmp    %eax,%edx
  801c82:	7e 22                	jle    801ca6 <free+0x5d>
				start=arr_add[i].start;
  801c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c87:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801c91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c94:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801c9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801c9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801ca4:	eb 0d                	jmp    801cb3 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801ca6:	ff 45 ec             	incl   -0x14(%ebp)
  801ca9:	a1 28 30 80 00       	mov    0x803028,%eax
  801cae:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801cb1:	7c ab                	jl     801c5e <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb6:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc0:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801cc7:	29 c2                	sub    %eax,%edx
  801cc9:	89 d0                	mov    %edx,%eax
  801ccb:	83 ec 08             	sub    $0x8,%esp
  801cce:	50                   	push   %eax
  801ccf:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd2:	e8 d9 02 00 00       	call   801fb0 <sys_freeMem>
  801cd7:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ce0:	eb 2d                	jmp    801d0f <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ce5:	40                   	inc    %eax
  801ce6:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801ced:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cf0:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801cf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cfa:	40                   	inc    %eax
  801cfb:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801d02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d05:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801d0c:	ff 45 e8             	incl   -0x18(%ebp)
  801d0f:	a1 28 30 80 00       	mov    0x803028,%eax
  801d14:	48                   	dec    %eax
  801d15:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801d18:	7f c8                	jg     801ce2 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801d1a:	a1 28 30 80 00       	mov    0x803028,%eax
  801d1f:	48                   	dec    %eax
  801d20:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801d25:	90                   	nop
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 18             	sub    $0x18,%esp
  801d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d31:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801d34:	83 ec 04             	sub    $0x4,%esp
  801d37:	68 e8 2d 80 00       	push   $0x802de8
  801d3c:	68 18 01 00 00       	push   $0x118
  801d41:	68 0b 2e 80 00       	push   $0x802e0b
  801d46:	e8 17 ea ff ff       	call   800762 <_panic>

00801d4b <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d51:	83 ec 04             	sub    $0x4,%esp
  801d54:	68 e8 2d 80 00       	push   $0x802de8
  801d59:	68 1e 01 00 00       	push   $0x11e
  801d5e:	68 0b 2e 80 00       	push   $0x802e0b
  801d63:	e8 fa e9 ff ff       	call   800762 <_panic>

00801d68 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d6e:	83 ec 04             	sub    $0x4,%esp
  801d71:	68 e8 2d 80 00       	push   $0x802de8
  801d76:	68 24 01 00 00       	push   $0x124
  801d7b:	68 0b 2e 80 00       	push   $0x802e0b
  801d80:	e8 dd e9 ff ff       	call   800762 <_panic>

00801d85 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d8b:	83 ec 04             	sub    $0x4,%esp
  801d8e:	68 e8 2d 80 00       	push   $0x802de8
  801d93:	68 29 01 00 00       	push   $0x129
  801d98:	68 0b 2e 80 00       	push   $0x802e0b
  801d9d:	e8 c0 e9 ff ff       	call   800762 <_panic>

00801da2 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801da8:	83 ec 04             	sub    $0x4,%esp
  801dab:	68 e8 2d 80 00       	push   $0x802de8
  801db0:	68 2f 01 00 00       	push   $0x12f
  801db5:	68 0b 2e 80 00       	push   $0x802e0b
  801dba:	e8 a3 e9 ff ff       	call   800762 <_panic>

00801dbf <shrink>:
}
void shrink(uint32 newSize)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801dc5:	83 ec 04             	sub    $0x4,%esp
  801dc8:	68 e8 2d 80 00       	push   $0x802de8
  801dcd:	68 33 01 00 00       	push   $0x133
  801dd2:	68 0b 2e 80 00       	push   $0x802e0b
  801dd7:	e8 86 e9 ff ff       	call   800762 <_panic>

00801ddc <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801de2:	83 ec 04             	sub    $0x4,%esp
  801de5:	68 e8 2d 80 00       	push   $0x802de8
  801dea:	68 38 01 00 00       	push   $0x138
  801def:	68 0b 2e 80 00       	push   $0x802e0b
  801df4:	e8 69 e9 ff ff       	call   800762 <_panic>

00801df9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	57                   	push   %edi
  801dfd:	56                   	push   %esi
  801dfe:	53                   	push   %ebx
  801dff:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e02:	8b 45 08             	mov    0x8(%ebp),%eax
  801e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e0b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e0e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e11:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e14:	cd 30                	int    $0x30
  801e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e1c:	83 c4 10             	add    $0x10,%esp
  801e1f:	5b                   	pop    %ebx
  801e20:	5e                   	pop    %esi
  801e21:	5f                   	pop    %edi
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    

00801e24 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 04             	sub    $0x4,%esp
  801e2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e30:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	52                   	push   %edx
  801e3c:	ff 75 0c             	pushl  0xc(%ebp)
  801e3f:	50                   	push   %eax
  801e40:	6a 00                	push   $0x0
  801e42:	e8 b2 ff ff ff       	call   801df9 <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
}
  801e4a:	90                   	nop
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_cgetc>:

int
sys_cgetc(void)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 01                	push   $0x1
  801e5c:	e8 98 ff ff ff       	call   801df9 <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	50                   	push   %eax
  801e75:	6a 05                	push   $0x5
  801e77:	e8 7d ff ff ff       	call   801df9 <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 02                	push   $0x2
  801e90:	e8 64 ff ff ff       	call   801df9 <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 03                	push   $0x3
  801ea9:	e8 4b ff ff ff       	call   801df9 <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 04                	push   $0x4
  801ec2:	e8 32 ff ff ff       	call   801df9 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <sys_env_exit>:


void sys_env_exit(void)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 06                	push   $0x6
  801edb:	e8 19 ff ff ff       	call   801df9 <syscall>
  801ee0:	83 c4 18             	add    $0x18,%esp
}
  801ee3:	90                   	nop
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eec:	8b 45 08             	mov    0x8(%ebp),%eax
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	52                   	push   %edx
  801ef6:	50                   	push   %eax
  801ef7:	6a 07                	push   $0x7
  801ef9:	e8 fb fe ff ff       	call   801df9 <syscall>
  801efe:	83 c4 18             	add    $0x18,%esp
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	56                   	push   %esi
  801f07:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f08:	8b 75 18             	mov    0x18(%ebp),%esi
  801f0b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	56                   	push   %esi
  801f18:	53                   	push   %ebx
  801f19:	51                   	push   %ecx
  801f1a:	52                   	push   %edx
  801f1b:	50                   	push   %eax
  801f1c:	6a 08                	push   $0x8
  801f1e:	e8 d6 fe ff ff       	call   801df9 <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f29:	5b                   	pop    %ebx
  801f2a:	5e                   	pop    %esi
  801f2b:	5d                   	pop    %ebp
  801f2c:	c3                   	ret    

00801f2d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	52                   	push   %edx
  801f3d:	50                   	push   %eax
  801f3e:	6a 09                	push   $0x9
  801f40:	e8 b4 fe ff ff       	call   801df9 <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	ff 75 0c             	pushl  0xc(%ebp)
  801f56:	ff 75 08             	pushl  0x8(%ebp)
  801f59:	6a 0a                	push   $0xa
  801f5b:	e8 99 fe ff ff       	call   801df9 <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 0b                	push   $0xb
  801f74:	e8 80 fe ff ff       	call   801df9 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 0c                	push   $0xc
  801f8d:	e8 67 fe ff ff       	call   801df9 <syscall>
  801f92:	83 c4 18             	add    $0x18,%esp
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 0d                	push   $0xd
  801fa6:	e8 4e fe ff ff       	call   801df9 <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	ff 75 0c             	pushl  0xc(%ebp)
  801fbc:	ff 75 08             	pushl  0x8(%ebp)
  801fbf:	6a 11                	push   $0x11
  801fc1:	e8 33 fe ff ff       	call   801df9 <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
	return;
  801fc9:	90                   	nop
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	ff 75 0c             	pushl  0xc(%ebp)
  801fd8:	ff 75 08             	pushl  0x8(%ebp)
  801fdb:	6a 12                	push   $0x12
  801fdd:	e8 17 fe ff ff       	call   801df9 <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe5:	90                   	nop
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 0e                	push   $0xe
  801ff7:	e8 fd fd ff ff       	call   801df9 <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	ff 75 08             	pushl  0x8(%ebp)
  80200f:	6a 0f                	push   $0xf
  802011:	e8 e3 fd ff ff       	call   801df9 <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 10                	push   $0x10
  80202a:	e8 ca fd ff ff       	call   801df9 <syscall>
  80202f:	83 c4 18             	add    $0x18,%esp
}
  802032:	90                   	nop
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 14                	push   $0x14
  802044:	e8 b0 fd ff ff       	call   801df9 <syscall>
  802049:	83 c4 18             	add    $0x18,%esp
}
  80204c:	90                   	nop
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 15                	push   $0x15
  80205e:	e8 96 fd ff ff       	call   801df9 <syscall>
  802063:	83 c4 18             	add    $0x18,%esp
}
  802066:	90                   	nop
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <sys_cputc>:


void
sys_cputc(const char c)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	83 ec 04             	sub    $0x4,%esp
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802075:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	50                   	push   %eax
  802082:	6a 16                	push   $0x16
  802084:	e8 70 fd ff ff       	call   801df9 <syscall>
  802089:	83 c4 18             	add    $0x18,%esp
}
  80208c:	90                   	nop
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 17                	push   $0x17
  80209e:	e8 56 fd ff ff       	call   801df9 <syscall>
  8020a3:	83 c4 18             	add    $0x18,%esp
}
  8020a6:	90                   	nop
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	ff 75 0c             	pushl  0xc(%ebp)
  8020b8:	50                   	push   %eax
  8020b9:	6a 18                	push   $0x18
  8020bb:	e8 39 fd ff ff       	call   801df9 <syscall>
  8020c0:	83 c4 18             	add    $0x18,%esp
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	52                   	push   %edx
  8020d5:	50                   	push   %eax
  8020d6:	6a 1b                	push   $0x1b
  8020d8:	e8 1c fd ff ff       	call   801df9 <syscall>
  8020dd:	83 c4 18             	add    $0x18,%esp
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	52                   	push   %edx
  8020f2:	50                   	push   %eax
  8020f3:	6a 19                	push   $0x19
  8020f5:	e8 ff fc ff ff       	call   801df9 <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
}
  8020fd:	90                   	nop
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802103:	8b 55 0c             	mov    0xc(%ebp),%edx
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	52                   	push   %edx
  802110:	50                   	push   %eax
  802111:	6a 1a                	push   $0x1a
  802113:	e8 e1 fc ff ff       	call   801df9 <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
}
  80211b:	90                   	nop
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 04             	sub    $0x4,%esp
  802124:	8b 45 10             	mov    0x10(%ebp),%eax
  802127:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80212a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80212d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	6a 00                	push   $0x0
  802136:	51                   	push   %ecx
  802137:	52                   	push   %edx
  802138:	ff 75 0c             	pushl  0xc(%ebp)
  80213b:	50                   	push   %eax
  80213c:	6a 1c                	push   $0x1c
  80213e:	e8 b6 fc ff ff       	call   801df9 <syscall>
  802143:	83 c4 18             	add    $0x18,%esp
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80214b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	52                   	push   %edx
  802158:	50                   	push   %eax
  802159:	6a 1d                	push   $0x1d
  80215b:	e8 99 fc ff ff       	call   801df9 <syscall>
  802160:	83 c4 18             	add    $0x18,%esp
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802168:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80216b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	51                   	push   %ecx
  802176:	52                   	push   %edx
  802177:	50                   	push   %eax
  802178:	6a 1e                	push   $0x1e
  80217a:	e8 7a fc ff ff       	call   801df9 <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	52                   	push   %edx
  802194:	50                   	push   %eax
  802195:	6a 1f                	push   $0x1f
  802197:	e8 5d fc ff ff       	call   801df9 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 20                	push   $0x20
  8021b0:	e8 44 fc ff ff       	call   801df9 <syscall>
  8021b5:	83 c4 18             	add    $0x18,%esp
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	6a 00                	push   $0x0
  8021c2:	ff 75 14             	pushl  0x14(%ebp)
  8021c5:	ff 75 10             	pushl  0x10(%ebp)
  8021c8:	ff 75 0c             	pushl  0xc(%ebp)
  8021cb:	50                   	push   %eax
  8021cc:	6a 21                	push   $0x21
  8021ce:	e8 26 fc ff ff       	call   801df9 <syscall>
  8021d3:	83 c4 18             	add    $0x18,%esp
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	50                   	push   %eax
  8021e7:	6a 22                	push   $0x22
  8021e9:	e8 0b fc ff ff       	call   801df9 <syscall>
  8021ee:	83 c4 18             	add    $0x18,%esp
}
  8021f1:	90                   	nop
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	50                   	push   %eax
  802203:	6a 23                	push   $0x23
  802205:	e8 ef fb ff ff       	call   801df9 <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
}
  80220d:	90                   	nop
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
  802213:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802216:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802219:	8d 50 04             	lea    0x4(%eax),%edx
  80221c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	52                   	push   %edx
  802226:	50                   	push   %eax
  802227:	6a 24                	push   $0x24
  802229:	e8 cb fb ff ff       	call   801df9 <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
	return result;
  802231:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802234:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802237:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80223a:	89 01                	mov    %eax,(%ecx)
  80223c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	c9                   	leave  
  802243:	c2 04 00             	ret    $0x4

00802246 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	ff 75 10             	pushl  0x10(%ebp)
  802250:	ff 75 0c             	pushl  0xc(%ebp)
  802253:	ff 75 08             	pushl  0x8(%ebp)
  802256:	6a 13                	push   $0x13
  802258:	e8 9c fb ff ff       	call   801df9 <syscall>
  80225d:	83 c4 18             	add    $0x18,%esp
	return ;
  802260:	90                   	nop
}
  802261:	c9                   	leave  
  802262:	c3                   	ret    

00802263 <sys_rcr2>:
uint32 sys_rcr2()
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 25                	push   $0x25
  802272:	e8 82 fb ff ff       	call   801df9 <syscall>
  802277:	83 c4 18             	add    $0x18,%esp
}
  80227a:	c9                   	leave  
  80227b:	c3                   	ret    

0080227c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
  80227f:	83 ec 04             	sub    $0x4,%esp
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802288:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	50                   	push   %eax
  802295:	6a 26                	push   $0x26
  802297:	e8 5d fb ff ff       	call   801df9 <syscall>
  80229c:	83 c4 18             	add    $0x18,%esp
	return ;
  80229f:	90                   	nop
}
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    

008022a2 <rsttst>:
void rsttst()
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 28                	push   $0x28
  8022b1:	e8 43 fb ff ff       	call   801df9 <syscall>
  8022b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b9:	90                   	nop
}
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	83 ec 04             	sub    $0x4,%esp
  8022c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022c8:	8b 55 18             	mov    0x18(%ebp),%edx
  8022cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022cf:	52                   	push   %edx
  8022d0:	50                   	push   %eax
  8022d1:	ff 75 10             	pushl  0x10(%ebp)
  8022d4:	ff 75 0c             	pushl  0xc(%ebp)
  8022d7:	ff 75 08             	pushl  0x8(%ebp)
  8022da:	6a 27                	push   $0x27
  8022dc:	e8 18 fb ff ff       	call   801df9 <syscall>
  8022e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e4:	90                   	nop
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <chktst>:
void chktst(uint32 n)
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	ff 75 08             	pushl  0x8(%ebp)
  8022f5:	6a 29                	push   $0x29
  8022f7:	e8 fd fa ff ff       	call   801df9 <syscall>
  8022fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ff:	90                   	nop
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <inctst>:

void inctst()
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 2a                	push   $0x2a
  802311:	e8 e3 fa ff ff       	call   801df9 <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
	return ;
  802319:	90                   	nop
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <gettst>:
uint32 gettst()
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 2b                	push   $0x2b
  80232b:	e8 c9 fa ff ff       	call   801df9 <syscall>
  802330:	83 c4 18             	add    $0x18,%esp
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 2c                	push   $0x2c
  802347:	e8 ad fa ff ff       	call   801df9 <syscall>
  80234c:	83 c4 18             	add    $0x18,%esp
  80234f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802352:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802356:	75 07                	jne    80235f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802358:	b8 01 00 00 00       	mov    $0x1,%eax
  80235d:	eb 05                	jmp    802364 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80235f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
  802369:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 2c                	push   $0x2c
  802378:	e8 7c fa ff ff       	call   801df9 <syscall>
  80237d:	83 c4 18             	add    $0x18,%esp
  802380:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802383:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802387:	75 07                	jne    802390 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802389:	b8 01 00 00 00       	mov    $0x1,%eax
  80238e:	eb 05                	jmp    802395 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802390:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
  80239a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 2c                	push   $0x2c
  8023a9:	e8 4b fa ff ff       	call   801df9 <syscall>
  8023ae:	83 c4 18             	add    $0x18,%esp
  8023b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023b4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023b8:	75 07                	jne    8023c1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bf:	eb 05                	jmp    8023c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 2c                	push   $0x2c
  8023da:	e8 1a fa ff ff       	call   801df9 <syscall>
  8023df:	83 c4 18             	add    $0x18,%esp
  8023e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023e5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023e9:	75 07                	jne    8023f2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f0:	eb 05                	jmp    8023f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f7:	c9                   	leave  
  8023f8:	c3                   	ret    

008023f9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	ff 75 08             	pushl  0x8(%ebp)
  802407:	6a 2d                	push   $0x2d
  802409:	e8 eb f9 ff ff       	call   801df9 <syscall>
  80240e:	83 c4 18             	add    $0x18,%esp
	return ;
  802411:	90                   	nop
}
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
  802417:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802418:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80241b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80241e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	6a 00                	push   $0x0
  802426:	53                   	push   %ebx
  802427:	51                   	push   %ecx
  802428:	52                   	push   %edx
  802429:	50                   	push   %eax
  80242a:	6a 2e                	push   $0x2e
  80242c:	e8 c8 f9 ff ff       	call   801df9 <syscall>
  802431:	83 c4 18             	add    $0x18,%esp
}
  802434:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802437:	c9                   	leave  
  802438:	c3                   	ret    

00802439 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80243c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	52                   	push   %edx
  802449:	50                   	push   %eax
  80244a:	6a 2f                	push   $0x2f
  80244c:	e8 a8 f9 ff ff       	call   801df9 <syscall>
  802451:	83 c4 18             	add    $0x18,%esp
}
  802454:	c9                   	leave  
  802455:	c3                   	ret    
  802456:	66 90                	xchg   %ax,%ax

00802458 <__udivdi3>:
  802458:	55                   	push   %ebp
  802459:	57                   	push   %edi
  80245a:	56                   	push   %esi
  80245b:	53                   	push   %ebx
  80245c:	83 ec 1c             	sub    $0x1c,%esp
  80245f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802463:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802467:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80246b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80246f:	89 ca                	mov    %ecx,%edx
  802471:	89 f8                	mov    %edi,%eax
  802473:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802477:	85 f6                	test   %esi,%esi
  802479:	75 2d                	jne    8024a8 <__udivdi3+0x50>
  80247b:	39 cf                	cmp    %ecx,%edi
  80247d:	77 65                	ja     8024e4 <__udivdi3+0x8c>
  80247f:	89 fd                	mov    %edi,%ebp
  802481:	85 ff                	test   %edi,%edi
  802483:	75 0b                	jne    802490 <__udivdi3+0x38>
  802485:	b8 01 00 00 00       	mov    $0x1,%eax
  80248a:	31 d2                	xor    %edx,%edx
  80248c:	f7 f7                	div    %edi
  80248e:	89 c5                	mov    %eax,%ebp
  802490:	31 d2                	xor    %edx,%edx
  802492:	89 c8                	mov    %ecx,%eax
  802494:	f7 f5                	div    %ebp
  802496:	89 c1                	mov    %eax,%ecx
  802498:	89 d8                	mov    %ebx,%eax
  80249a:	f7 f5                	div    %ebp
  80249c:	89 cf                	mov    %ecx,%edi
  80249e:	89 fa                	mov    %edi,%edx
  8024a0:	83 c4 1c             	add    $0x1c,%esp
  8024a3:	5b                   	pop    %ebx
  8024a4:	5e                   	pop    %esi
  8024a5:	5f                   	pop    %edi
  8024a6:	5d                   	pop    %ebp
  8024a7:	c3                   	ret    
  8024a8:	39 ce                	cmp    %ecx,%esi
  8024aa:	77 28                	ja     8024d4 <__udivdi3+0x7c>
  8024ac:	0f bd fe             	bsr    %esi,%edi
  8024af:	83 f7 1f             	xor    $0x1f,%edi
  8024b2:	75 40                	jne    8024f4 <__udivdi3+0x9c>
  8024b4:	39 ce                	cmp    %ecx,%esi
  8024b6:	72 0a                	jb     8024c2 <__udivdi3+0x6a>
  8024b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8024bc:	0f 87 9e 00 00 00    	ja     802560 <__udivdi3+0x108>
  8024c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c7:	89 fa                	mov    %edi,%edx
  8024c9:	83 c4 1c             	add    $0x1c,%esp
  8024cc:	5b                   	pop    %ebx
  8024cd:	5e                   	pop    %esi
  8024ce:	5f                   	pop    %edi
  8024cf:	5d                   	pop    %ebp
  8024d0:	c3                   	ret    
  8024d1:	8d 76 00             	lea    0x0(%esi),%esi
  8024d4:	31 ff                	xor    %edi,%edi
  8024d6:	31 c0                	xor    %eax,%eax
  8024d8:	89 fa                	mov    %edi,%edx
  8024da:	83 c4 1c             	add    $0x1c,%esp
  8024dd:	5b                   	pop    %ebx
  8024de:	5e                   	pop    %esi
  8024df:	5f                   	pop    %edi
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    
  8024e2:	66 90                	xchg   %ax,%ax
  8024e4:	89 d8                	mov    %ebx,%eax
  8024e6:	f7 f7                	div    %edi
  8024e8:	31 ff                	xor    %edi,%edi
  8024ea:	89 fa                	mov    %edi,%edx
  8024ec:	83 c4 1c             	add    $0x1c,%esp
  8024ef:	5b                   	pop    %ebx
  8024f0:	5e                   	pop    %esi
  8024f1:	5f                   	pop    %edi
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    
  8024f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8024f9:	89 eb                	mov    %ebp,%ebx
  8024fb:	29 fb                	sub    %edi,%ebx
  8024fd:	89 f9                	mov    %edi,%ecx
  8024ff:	d3 e6                	shl    %cl,%esi
  802501:	89 c5                	mov    %eax,%ebp
  802503:	88 d9                	mov    %bl,%cl
  802505:	d3 ed                	shr    %cl,%ebp
  802507:	89 e9                	mov    %ebp,%ecx
  802509:	09 f1                	or     %esi,%ecx
  80250b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80250f:	89 f9                	mov    %edi,%ecx
  802511:	d3 e0                	shl    %cl,%eax
  802513:	89 c5                	mov    %eax,%ebp
  802515:	89 d6                	mov    %edx,%esi
  802517:	88 d9                	mov    %bl,%cl
  802519:	d3 ee                	shr    %cl,%esi
  80251b:	89 f9                	mov    %edi,%ecx
  80251d:	d3 e2                	shl    %cl,%edx
  80251f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802523:	88 d9                	mov    %bl,%cl
  802525:	d3 e8                	shr    %cl,%eax
  802527:	09 c2                	or     %eax,%edx
  802529:	89 d0                	mov    %edx,%eax
  80252b:	89 f2                	mov    %esi,%edx
  80252d:	f7 74 24 0c          	divl   0xc(%esp)
  802531:	89 d6                	mov    %edx,%esi
  802533:	89 c3                	mov    %eax,%ebx
  802535:	f7 e5                	mul    %ebp
  802537:	39 d6                	cmp    %edx,%esi
  802539:	72 19                	jb     802554 <__udivdi3+0xfc>
  80253b:	74 0b                	je     802548 <__udivdi3+0xf0>
  80253d:	89 d8                	mov    %ebx,%eax
  80253f:	31 ff                	xor    %edi,%edi
  802541:	e9 58 ff ff ff       	jmp    80249e <__udivdi3+0x46>
  802546:	66 90                	xchg   %ax,%ax
  802548:	8b 54 24 08          	mov    0x8(%esp),%edx
  80254c:	89 f9                	mov    %edi,%ecx
  80254e:	d3 e2                	shl    %cl,%edx
  802550:	39 c2                	cmp    %eax,%edx
  802552:	73 e9                	jae    80253d <__udivdi3+0xe5>
  802554:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802557:	31 ff                	xor    %edi,%edi
  802559:	e9 40 ff ff ff       	jmp    80249e <__udivdi3+0x46>
  80255e:	66 90                	xchg   %ax,%ax
  802560:	31 c0                	xor    %eax,%eax
  802562:	e9 37 ff ff ff       	jmp    80249e <__udivdi3+0x46>
  802567:	90                   	nop

00802568 <__umoddi3>:
  802568:	55                   	push   %ebp
  802569:	57                   	push   %edi
  80256a:	56                   	push   %esi
  80256b:	53                   	push   %ebx
  80256c:	83 ec 1c             	sub    $0x1c,%esp
  80256f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802573:	8b 74 24 34          	mov    0x34(%esp),%esi
  802577:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80257b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80257f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802583:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802587:	89 f3                	mov    %esi,%ebx
  802589:	89 fa                	mov    %edi,%edx
  80258b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80258f:	89 34 24             	mov    %esi,(%esp)
  802592:	85 c0                	test   %eax,%eax
  802594:	75 1a                	jne    8025b0 <__umoddi3+0x48>
  802596:	39 f7                	cmp    %esi,%edi
  802598:	0f 86 a2 00 00 00    	jbe    802640 <__umoddi3+0xd8>
  80259e:	89 c8                	mov    %ecx,%eax
  8025a0:	89 f2                	mov    %esi,%edx
  8025a2:	f7 f7                	div    %edi
  8025a4:	89 d0                	mov    %edx,%eax
  8025a6:	31 d2                	xor    %edx,%edx
  8025a8:	83 c4 1c             	add    $0x1c,%esp
  8025ab:	5b                   	pop    %ebx
  8025ac:	5e                   	pop    %esi
  8025ad:	5f                   	pop    %edi
  8025ae:	5d                   	pop    %ebp
  8025af:	c3                   	ret    
  8025b0:	39 f0                	cmp    %esi,%eax
  8025b2:	0f 87 ac 00 00 00    	ja     802664 <__umoddi3+0xfc>
  8025b8:	0f bd e8             	bsr    %eax,%ebp
  8025bb:	83 f5 1f             	xor    $0x1f,%ebp
  8025be:	0f 84 ac 00 00 00    	je     802670 <__umoddi3+0x108>
  8025c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8025c9:	29 ef                	sub    %ebp,%edi
  8025cb:	89 fe                	mov    %edi,%esi
  8025cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025d1:	89 e9                	mov    %ebp,%ecx
  8025d3:	d3 e0                	shl    %cl,%eax
  8025d5:	89 d7                	mov    %edx,%edi
  8025d7:	89 f1                	mov    %esi,%ecx
  8025d9:	d3 ef                	shr    %cl,%edi
  8025db:	09 c7                	or     %eax,%edi
  8025dd:	89 e9                	mov    %ebp,%ecx
  8025df:	d3 e2                	shl    %cl,%edx
  8025e1:	89 14 24             	mov    %edx,(%esp)
  8025e4:	89 d8                	mov    %ebx,%eax
  8025e6:	d3 e0                	shl    %cl,%eax
  8025e8:	89 c2                	mov    %eax,%edx
  8025ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025ee:	d3 e0                	shl    %cl,%eax
  8025f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025f8:	89 f1                	mov    %esi,%ecx
  8025fa:	d3 e8                	shr    %cl,%eax
  8025fc:	09 d0                	or     %edx,%eax
  8025fe:	d3 eb                	shr    %cl,%ebx
  802600:	89 da                	mov    %ebx,%edx
  802602:	f7 f7                	div    %edi
  802604:	89 d3                	mov    %edx,%ebx
  802606:	f7 24 24             	mull   (%esp)
  802609:	89 c6                	mov    %eax,%esi
  80260b:	89 d1                	mov    %edx,%ecx
  80260d:	39 d3                	cmp    %edx,%ebx
  80260f:	0f 82 87 00 00 00    	jb     80269c <__umoddi3+0x134>
  802615:	0f 84 91 00 00 00    	je     8026ac <__umoddi3+0x144>
  80261b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80261f:	29 f2                	sub    %esi,%edx
  802621:	19 cb                	sbb    %ecx,%ebx
  802623:	89 d8                	mov    %ebx,%eax
  802625:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802629:	d3 e0                	shl    %cl,%eax
  80262b:	89 e9                	mov    %ebp,%ecx
  80262d:	d3 ea                	shr    %cl,%edx
  80262f:	09 d0                	or     %edx,%eax
  802631:	89 e9                	mov    %ebp,%ecx
  802633:	d3 eb                	shr    %cl,%ebx
  802635:	89 da                	mov    %ebx,%edx
  802637:	83 c4 1c             	add    $0x1c,%esp
  80263a:	5b                   	pop    %ebx
  80263b:	5e                   	pop    %esi
  80263c:	5f                   	pop    %edi
  80263d:	5d                   	pop    %ebp
  80263e:	c3                   	ret    
  80263f:	90                   	nop
  802640:	89 fd                	mov    %edi,%ebp
  802642:	85 ff                	test   %edi,%edi
  802644:	75 0b                	jne    802651 <__umoddi3+0xe9>
  802646:	b8 01 00 00 00       	mov    $0x1,%eax
  80264b:	31 d2                	xor    %edx,%edx
  80264d:	f7 f7                	div    %edi
  80264f:	89 c5                	mov    %eax,%ebp
  802651:	89 f0                	mov    %esi,%eax
  802653:	31 d2                	xor    %edx,%edx
  802655:	f7 f5                	div    %ebp
  802657:	89 c8                	mov    %ecx,%eax
  802659:	f7 f5                	div    %ebp
  80265b:	89 d0                	mov    %edx,%eax
  80265d:	e9 44 ff ff ff       	jmp    8025a6 <__umoddi3+0x3e>
  802662:	66 90                	xchg   %ax,%ax
  802664:	89 c8                	mov    %ecx,%eax
  802666:	89 f2                	mov    %esi,%edx
  802668:	83 c4 1c             	add    $0x1c,%esp
  80266b:	5b                   	pop    %ebx
  80266c:	5e                   	pop    %esi
  80266d:	5f                   	pop    %edi
  80266e:	5d                   	pop    %ebp
  80266f:	c3                   	ret    
  802670:	3b 04 24             	cmp    (%esp),%eax
  802673:	72 06                	jb     80267b <__umoddi3+0x113>
  802675:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802679:	77 0f                	ja     80268a <__umoddi3+0x122>
  80267b:	89 f2                	mov    %esi,%edx
  80267d:	29 f9                	sub    %edi,%ecx
  80267f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802683:	89 14 24             	mov    %edx,(%esp)
  802686:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80268a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80268e:	8b 14 24             	mov    (%esp),%edx
  802691:	83 c4 1c             	add    $0x1c,%esp
  802694:	5b                   	pop    %ebx
  802695:	5e                   	pop    %esi
  802696:	5f                   	pop    %edi
  802697:	5d                   	pop    %ebp
  802698:	c3                   	ret    
  802699:	8d 76 00             	lea    0x0(%esi),%esi
  80269c:	2b 04 24             	sub    (%esp),%eax
  80269f:	19 fa                	sbb    %edi,%edx
  8026a1:	89 d1                	mov    %edx,%ecx
  8026a3:	89 c6                	mov    %eax,%esi
  8026a5:	e9 71 ff ff ff       	jmp    80261b <__umoddi3+0xb3>
  8026aa:	66 90                	xchg   %ax,%ax
  8026ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8026b0:	72 ea                	jb     80269c <__umoddi3+0x134>
  8026b2:	89 d9                	mov    %ebx,%ecx
  8026b4:	e9 62 ff ff ff       	jmp    80261b <__umoddi3+0xb3>
