
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 ae 0b 00 00       	call   800be4 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 76 29 00 00       	call   8029c0 <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 23                	jmp    80007d <_main+0x45>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 40 80 00       	mov    0x804020,%eax
  80005f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	c1 e2 04             	shl    $0x4,%edx
  80006b:	01 d0                	add    %edx,%eax
  80006d:	8a 40 04             	mov    0x4(%eax),%al
  800070:	84 c0                	test   %al,%al
  800072:	74 06                	je     80007a <_main+0x42>
			{
				fullWS = 0;
  800074:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800078:	eb 12                	jmp    80008c <_main+0x54>
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007a:	ff 45 f0             	incl   -0x10(%ebp)
  80007d:	a1 20 40 80 00       	mov    0x804020,%eax
  800082:	8b 50 74             	mov    0x74(%eax),%edx
  800085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800088:	39 c2                	cmp    %eax,%edx
  80008a:	77 ce                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80008c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800090:	74 14                	je     8000a6 <_main+0x6e>
  800092:	83 ec 04             	sub    $0x4,%esp
  800095:	68 a0 2c 80 00       	push   $0x802ca0
  80009a:	6a 15                	push   $0x15
  80009c:	68 bc 2c 80 00       	push   $0x802cbc
  8000a1:	e8 83 0c 00 00       	call   800d29 <_panic>
	}

	int Mega = 1024*1024;
  8000a6:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000ad:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000b4:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000b7:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c1:	89 d7                	mov    %edx,%edi
  8000c3:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000c5:	e8 62 24 00 00       	call   80252c <sys_calculate_free_frames>
  8000ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000cd:	e8 dd 24 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  8000d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000d8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	50                   	push   %eax
  8000df:	e8 71 1c 00 00       	call   801d55 <malloc>
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8000ea:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ed:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000f2:	74 14                	je     800108 <_main+0xd0>
  8000f4:	83 ec 04             	sub    $0x4,%esp
  8000f7:	68 d4 2c 80 00       	push   $0x802cd4
  8000fc:	6a 23                	push   $0x23
  8000fe:	68 bc 2c 80 00       	push   $0x802cbc
  800103:	e8 21 0c 00 00       	call   800d29 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800108:	e8 a2 24 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  80010d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800110:	3d 00 01 00 00       	cmp    $0x100,%eax
  800115:	74 14                	je     80012b <_main+0xf3>
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	68 04 2d 80 00       	push   $0x802d04
  80011f:	6a 25                	push   $0x25
  800121:	68 bc 2c 80 00       	push   $0x802cbc
  800126:	e8 fe 0b 00 00       	call   800d29 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  80012b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80012e:	e8 f9 23 00 00       	call   80252c <sys_calculate_free_frames>
  800133:	29 c3                	sub    %eax,%ebx
  800135:	89 d8                	mov    %ebx,%eax
  800137:	83 f8 01             	cmp    $0x1,%eax
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 21 2d 80 00       	push   $0x802d21
  800144:	6a 26                	push   $0x26
  800146:	68 bc 2c 80 00       	push   $0x802cbc
  80014b:	e8 d9 0b 00 00       	call   800d29 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800150:	e8 d7 23 00 00       	call   80252c <sys_calculate_free_frames>
  800155:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800158:	e8 52 24 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  80015d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800160:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800163:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	50                   	push   %eax
  80016a:	e8 e6 1b 00 00       	call   801d55 <malloc>
  80016f:	83 c4 10             	add    $0x10,%esp
  800172:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  800175:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800178:	89 c2                	mov    %eax,%edx
  80017a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017d:	05 00 00 00 80       	add    $0x80000000,%eax
  800182:	39 c2                	cmp    %eax,%edx
  800184:	74 14                	je     80019a <_main+0x162>
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	68 d4 2c 80 00       	push   $0x802cd4
  80018e:	6a 2c                	push   $0x2c
  800190:	68 bc 2c 80 00       	push   $0x802cbc
  800195:	e8 8f 0b 00 00       	call   800d29 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80019a:	e8 10 24 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  80019f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001a2:	3d 00 01 00 00       	cmp    $0x100,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 04 2d 80 00       	push   $0x802d04
  8001b1:	6a 2e                	push   $0x2e
  8001b3:	68 bc 2c 80 00       	push   $0x802cbc
  8001b8:	e8 6c 0b 00 00       	call   800d29 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001bd:	e8 6a 23 00 00       	call   80252c <sys_calculate_free_frames>
  8001c2:	89 c2                	mov    %eax,%edx
  8001c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c7:	39 c2                	cmp    %eax,%edx
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 21 2d 80 00       	push   $0x802d21
  8001d3:	6a 2f                	push   $0x2f
  8001d5:	68 bc 2c 80 00       	push   $0x802cbc
  8001da:	e8 4a 0b 00 00       	call   800d29 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 48 23 00 00       	call   80252c <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 c3 23 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  8001ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001f2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	e8 57 1b 00 00       	call   801d55 <malloc>
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800204:	8b 45 98             	mov    -0x68(%ebp),%eax
  800207:	89 c2                	mov    %eax,%edx
  800209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020c:	01 c0                	add    %eax,%eax
  80020e:	05 00 00 00 80       	add    $0x80000000,%eax
  800213:	39 c2                	cmp    %eax,%edx
  800215:	74 14                	je     80022b <_main+0x1f3>
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	68 d4 2c 80 00       	push   $0x802cd4
  80021f:	6a 35                	push   $0x35
  800221:	68 bc 2c 80 00       	push   $0x802cbc
  800226:	e8 fe 0a 00 00       	call   800d29 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80022b:	e8 7f 23 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800230:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800233:	3d 00 01 00 00       	cmp    $0x100,%eax
  800238:	74 14                	je     80024e <_main+0x216>
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	68 04 2d 80 00       	push   $0x802d04
  800242:	6a 37                	push   $0x37
  800244:	68 bc 2c 80 00       	push   $0x802cbc
  800249:	e8 db 0a 00 00       	call   800d29 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80024e:	e8 d9 22 00 00       	call   80252c <sys_calculate_free_frames>
  800253:	89 c2                	mov    %eax,%edx
  800255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800258:	39 c2                	cmp    %eax,%edx
  80025a:	74 14                	je     800270 <_main+0x238>
  80025c:	83 ec 04             	sub    $0x4,%esp
  80025f:	68 21 2d 80 00       	push   $0x802d21
  800264:	6a 38                	push   $0x38
  800266:	68 bc 2c 80 00       	push   $0x802cbc
  80026b:	e8 b9 0a 00 00       	call   800d29 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800270:	e8 b7 22 00 00       	call   80252c <sys_calculate_free_frames>
  800275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800278:	e8 32 23 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  80027d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800280:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800283:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 c6 1a 00 00       	call   801d55 <malloc>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  800295:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800298:	89 c1                	mov    %eax,%ecx
  80029a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80029d:	89 c2                	mov    %eax,%edx
  80029f:	01 d2                	add    %edx,%edx
  8002a1:	01 d0                	add    %edx,%eax
  8002a3:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a8:	39 c1                	cmp    %eax,%ecx
  8002aa:	74 14                	je     8002c0 <_main+0x288>
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 d4 2c 80 00       	push   $0x802cd4
  8002b4:	6a 3e                	push   $0x3e
  8002b6:	68 bc 2c 80 00       	push   $0x802cbc
  8002bb:	e8 69 0a 00 00       	call   800d29 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8002c0:	e8 ea 22 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  8002c5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002c8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002cd:	74 14                	je     8002e3 <_main+0x2ab>
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 04 2d 80 00       	push   $0x802d04
  8002d7:	6a 40                	push   $0x40
  8002d9:	68 bc 2c 80 00       	push   $0x802cbc
  8002de:	e8 46 0a 00 00       	call   800d29 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002e3:	e8 44 22 00 00       	call   80252c <sys_calculate_free_frames>
  8002e8:	89 c2                	mov    %eax,%edx
  8002ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ed:	39 c2                	cmp    %eax,%edx
  8002ef:	74 14                	je     800305 <_main+0x2cd>
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	68 21 2d 80 00       	push   $0x802d21
  8002f9:	6a 41                	push   $0x41
  8002fb:	68 bc 2c 80 00       	push   $0x802cbc
  800300:	e8 24 0a 00 00       	call   800d29 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800305:	e8 22 22 00 00       	call   80252c <sys_calculate_free_frames>
  80030a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80030d:	e8 9d 22 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800312:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800315:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800318:	01 c0                	add    %eax,%eax
  80031a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80031d:	83 ec 0c             	sub    $0xc,%esp
  800320:	50                   	push   %eax
  800321:	e8 2f 1a 00 00       	call   801d55 <malloc>
  800326:	83 c4 10             	add    $0x10,%esp
  800329:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  80032c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032f:	89 c2                	mov    %eax,%edx
  800331:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800334:	c1 e0 02             	shl    $0x2,%eax
  800337:	05 00 00 00 80       	add    $0x80000000,%eax
  80033c:	39 c2                	cmp    %eax,%edx
  80033e:	74 14                	je     800354 <_main+0x31c>
  800340:	83 ec 04             	sub    $0x4,%esp
  800343:	68 d4 2c 80 00       	push   $0x802cd4
  800348:	6a 47                	push   $0x47
  80034a:	68 bc 2c 80 00       	push   $0x802cbc
  80034f:	e8 d5 09 00 00       	call   800d29 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800354:	e8 56 22 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800359:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80035c:	3d 00 02 00 00       	cmp    $0x200,%eax
  800361:	74 14                	je     800377 <_main+0x33f>
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 04 2d 80 00       	push   $0x802d04
  80036b:	6a 49                	push   $0x49
  80036d:	68 bc 2c 80 00       	push   $0x802cbc
  800372:	e8 b2 09 00 00       	call   800d29 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  800377:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80037a:	e8 ad 21 00 00       	call   80252c <sys_calculate_free_frames>
  80037f:	29 c3                	sub    %eax,%ebx
  800381:	89 d8                	mov    %ebx,%eax
  800383:	83 f8 01             	cmp    $0x1,%eax
  800386:	74 14                	je     80039c <_main+0x364>
  800388:	83 ec 04             	sub    $0x4,%esp
  80038b:	68 21 2d 80 00       	push   $0x802d21
  800390:	6a 4a                	push   $0x4a
  800392:	68 bc 2c 80 00       	push   $0x802cbc
  800397:	e8 8d 09 00 00       	call   800d29 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80039c:	e8 8b 21 00 00       	call   80252c <sys_calculate_free_frames>
  8003a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003a4:	e8 06 22 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  8003a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  8003ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	50                   	push   %eax
  8003b8:	e8 98 19 00 00       	call   801d55 <malloc>
  8003bd:	83 c4 10             	add    $0x10,%esp
  8003c0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  8003c3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003c6:	89 c1                	mov    %eax,%ecx
  8003c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003cb:	89 d0                	mov    %edx,%eax
  8003cd:	01 c0                	add    %eax,%eax
  8003cf:	01 d0                	add    %edx,%eax
  8003d1:	01 c0                	add    %eax,%eax
  8003d3:	05 00 00 00 80       	add    $0x80000000,%eax
  8003d8:	39 c1                	cmp    %eax,%ecx
  8003da:	74 14                	je     8003f0 <_main+0x3b8>
  8003dc:	83 ec 04             	sub    $0x4,%esp
  8003df:	68 d4 2c 80 00       	push   $0x802cd4
  8003e4:	6a 50                	push   $0x50
  8003e6:	68 bc 2c 80 00       	push   $0x802cbc
  8003eb:	e8 39 09 00 00       	call   800d29 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8003f0:	e8 ba 21 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  8003f5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8003f8:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003fd:	74 14                	je     800413 <_main+0x3db>
  8003ff:	83 ec 04             	sub    $0x4,%esp
  800402:	68 04 2d 80 00       	push   $0x802d04
  800407:	6a 52                	push   $0x52
  800409:	68 bc 2c 80 00       	push   $0x802cbc
  80040e:	e8 16 09 00 00       	call   800d29 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800413:	e8 14 21 00 00       	call   80252c <sys_calculate_free_frames>
  800418:	89 c2                	mov    %eax,%edx
  80041a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	74 14                	je     800435 <_main+0x3fd>
  800421:	83 ec 04             	sub    $0x4,%esp
  800424:	68 21 2d 80 00       	push   $0x802d21
  800429:	6a 53                	push   $0x53
  80042b:	68 bc 2c 80 00       	push   $0x802cbc
  800430:	e8 f4 08 00 00       	call   800d29 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800435:	e8 f2 20 00 00       	call   80252c <sys_calculate_free_frames>
  80043a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80043d:	e8 6d 21 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800442:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800448:	89 c2                	mov    %eax,%edx
  80044a:	01 d2                	add    %edx,%edx
  80044c:	01 d0                	add    %edx,%eax
  80044e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	50                   	push   %eax
  800455:	e8 fb 18 00 00       	call   801d55 <malloc>
  80045a:	83 c4 10             	add    $0x10,%esp
  80045d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800460:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800463:	89 c2                	mov    %eax,%edx
  800465:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800468:	c1 e0 03             	shl    $0x3,%eax
  80046b:	05 00 00 00 80       	add    $0x80000000,%eax
  800470:	39 c2                	cmp    %eax,%edx
  800472:	74 14                	je     800488 <_main+0x450>
  800474:	83 ec 04             	sub    $0x4,%esp
  800477:	68 d4 2c 80 00       	push   $0x802cd4
  80047c:	6a 59                	push   $0x59
  80047e:	68 bc 2c 80 00       	push   $0x802cbc
  800483:	e8 a1 08 00 00       	call   800d29 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  768) panic("Wrong page file allocation: ");
  800488:	e8 22 21 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  80048d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800490:	3d 00 03 00 00       	cmp    $0x300,%eax
  800495:	74 14                	je     8004ab <_main+0x473>
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	68 04 2d 80 00       	push   $0x802d04
  80049f:	6a 5b                	push   $0x5b
  8004a1:	68 bc 2c 80 00       	push   $0x802cbc
  8004a6:	e8 7e 08 00 00       	call   800d29 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004ab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004ae:	e8 79 20 00 00       	call   80252c <sys_calculate_free_frames>
  8004b3:	29 c3                	sub    %eax,%ebx
  8004b5:	89 d8                	mov    %ebx,%eax
  8004b7:	83 f8 01             	cmp    $0x1,%eax
  8004ba:	74 14                	je     8004d0 <_main+0x498>
  8004bc:	83 ec 04             	sub    $0x4,%esp
  8004bf:	68 21 2d 80 00       	push   $0x802d21
  8004c4:	6a 5c                	push   $0x5c
  8004c6:	68 bc 2c 80 00       	push   $0x802cbc
  8004cb:	e8 59 08 00 00       	call   800d29 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004d0:	e8 57 20 00 00       	call   80252c <sys_calculate_free_frames>
  8004d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004d8:	e8 d2 20 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  8004dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8004e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004e3:	89 c2                	mov    %eax,%edx
  8004e5:	01 d2                	add    %edx,%edx
  8004e7:	01 d0                	add    %edx,%eax
  8004e9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	50                   	push   %eax
  8004f0:	e8 60 18 00 00       	call   801d55 <malloc>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004fb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8004fe:	89 c1                	mov    %eax,%ecx
  800500:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800503:	89 d0                	mov    %edx,%eax
  800505:	c1 e0 02             	shl    $0x2,%eax
  800508:	01 d0                	add    %edx,%eax
  80050a:	01 c0                	add    %eax,%eax
  80050c:	01 d0                	add    %edx,%eax
  80050e:	05 00 00 00 80       	add    $0x80000000,%eax
  800513:	39 c1                	cmp    %eax,%ecx
  800515:	74 14                	je     80052b <_main+0x4f3>
  800517:	83 ec 04             	sub    $0x4,%esp
  80051a:	68 d4 2c 80 00       	push   $0x802cd4
  80051f:	6a 62                	push   $0x62
  800521:	68 bc 2c 80 00       	push   $0x802cbc
  800526:	e8 fe 07 00 00       	call   800d29 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  768) panic("Wrong page file allocation: ");
  80052b:	e8 7f 20 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800530:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800533:	3d 00 03 00 00       	cmp    $0x300,%eax
  800538:	74 14                	je     80054e <_main+0x516>
  80053a:	83 ec 04             	sub    $0x4,%esp
  80053d:	68 04 2d 80 00       	push   $0x802d04
  800542:	6a 64                	push   $0x64
  800544:	68 bc 2c 80 00       	push   $0x802cbc
  800549:	e8 db 07 00 00       	call   800d29 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  80054e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800551:	e8 d6 1f 00 00       	call   80252c <sys_calculate_free_frames>
  800556:	29 c3                	sub    %eax,%ebx
  800558:	89 d8                	mov    %ebx,%eax
  80055a:	83 f8 01             	cmp    $0x1,%eax
  80055d:	74 14                	je     800573 <_main+0x53b>
  80055f:	83 ec 04             	sub    $0x4,%esp
  800562:	68 21 2d 80 00       	push   $0x802d21
  800567:	6a 65                	push   $0x65
  800569:	68 bc 2c 80 00       	push   $0x802cbc
  80056e:	e8 b6 07 00 00       	call   800d29 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800573:	e8 b4 1f 00 00       	call   80252c <sys_calculate_free_frames>
  800578:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80057b:	e8 2f 20 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800580:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800583:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800586:	83 ec 0c             	sub    $0xc,%esp
  800589:	50                   	push   %eax
  80058a:	e8 81 1c 00 00       	call   802210 <free>
  80058f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800592:	e8 18 20 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800597:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80059a:	29 c2                	sub    %eax,%edx
  80059c:	89 d0                	mov    %edx,%eax
  80059e:	3d 00 01 00 00       	cmp    $0x100,%eax
  8005a3:	74 14                	je     8005b9 <_main+0x581>
  8005a5:	83 ec 04             	sub    $0x4,%esp
  8005a8:	68 34 2d 80 00       	push   $0x802d34
  8005ad:	6a 6f                	push   $0x6f
  8005af:	68 bc 2c 80 00       	push   $0x802cbc
  8005b4:	e8 70 07 00 00       	call   800d29 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005b9:	e8 6e 1f 00 00       	call   80252c <sys_calculate_free_frames>
  8005be:	89 c2                	mov    %eax,%edx
  8005c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005c3:	39 c2                	cmp    %eax,%edx
  8005c5:	74 14                	je     8005db <_main+0x5a3>
  8005c7:	83 ec 04             	sub    $0x4,%esp
  8005ca:	68 4b 2d 80 00       	push   $0x802d4b
  8005cf:	6a 70                	push   $0x70
  8005d1:	68 bc 2c 80 00       	push   $0x802cbc
  8005d6:	e8 4e 07 00 00       	call   800d29 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005db:	e8 4c 1f 00 00       	call   80252c <sys_calculate_free_frames>
  8005e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005e3:	e8 c7 1f 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  8005eb:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8005ee:	83 ec 0c             	sub    $0xc,%esp
  8005f1:	50                   	push   %eax
  8005f2:	e8 19 1c 00 00       	call   802210 <free>
  8005f7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  512) panic("Wrong page file free: ");
  8005fa:	e8 b0 1f 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  8005ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800602:	29 c2                	sub    %eax,%edx
  800604:	89 d0                	mov    %edx,%eax
  800606:	3d 00 02 00 00       	cmp    $0x200,%eax
  80060b:	74 14                	je     800621 <_main+0x5e9>
  80060d:	83 ec 04             	sub    $0x4,%esp
  800610:	68 34 2d 80 00       	push   $0x802d34
  800615:	6a 77                	push   $0x77
  800617:	68 bc 2c 80 00       	push   $0x802cbc
  80061c:	e8 08 07 00 00       	call   800d29 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800621:	e8 06 1f 00 00       	call   80252c <sys_calculate_free_frames>
  800626:	89 c2                	mov    %eax,%edx
  800628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80062b:	39 c2                	cmp    %eax,%edx
  80062d:	74 14                	je     800643 <_main+0x60b>
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	68 4b 2d 80 00       	push   $0x802d4b
  800637:	6a 78                	push   $0x78
  800639:	68 bc 2c 80 00       	push   $0x802cbc
  80063e:	e8 e6 06 00 00       	call   800d29 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800643:	e8 e4 1e 00 00       	call   80252c <sys_calculate_free_frames>
  800648:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80064b:	e8 5f 1f 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800650:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  800653:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800656:	83 ec 0c             	sub    $0xc,%esp
  800659:	50                   	push   %eax
  80065a:	e8 b1 1b 00 00       	call   802210 <free>
  80065f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  800662:	e8 48 1f 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800667:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80066a:	29 c2                	sub    %eax,%edx
  80066c:	89 d0                	mov    %edx,%eax
  80066e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800673:	74 14                	je     800689 <_main+0x651>
  800675:	83 ec 04             	sub    $0x4,%esp
  800678:	68 34 2d 80 00       	push   $0x802d34
  80067d:	6a 7f                	push   $0x7f
  80067f:	68 bc 2c 80 00       	push   $0x802cbc
  800684:	e8 a0 06 00 00       	call   800d29 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800689:	e8 9e 1e 00 00       	call   80252c <sys_calculate_free_frames>
  80068e:	89 c2                	mov    %eax,%edx
  800690:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800693:	39 c2                	cmp    %eax,%edx
  800695:	74 17                	je     8006ae <_main+0x676>
  800697:	83 ec 04             	sub    $0x4,%esp
  80069a:	68 4b 2d 80 00       	push   $0x802d4b
  80069f:	68 80 00 00 00       	push   $0x80
  8006a4:	68 bc 2c 80 00       	push   $0x802cbc
  8006a9:	e8 7b 06 00 00       	call   800d29 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8006ae:	e8 79 1e 00 00       	call   80252c <sys_calculate_free_frames>
  8006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006b6:	e8 f4 1e 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  8006bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8006be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006c1:	89 d0                	mov    %edx,%eax
  8006c3:	c1 e0 09             	shl    $0x9,%eax
  8006c6:	29 d0                	sub    %edx,%eax
  8006c8:	83 ec 0c             	sub    $0xc,%esp
  8006cb:	50                   	push   %eax
  8006cc:	e8 84 16 00 00       	call   801d55 <malloc>
  8006d1:	83 c4 10             	add    $0x10,%esp
  8006d4:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8006d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006da:	89 c2                	mov    %eax,%edx
  8006dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006df:	05 00 00 00 80       	add    $0x80000000,%eax
  8006e4:	39 c2                	cmp    %eax,%edx
  8006e6:	74 17                	je     8006ff <_main+0x6c7>
  8006e8:	83 ec 04             	sub    $0x4,%esp
  8006eb:	68 d4 2c 80 00       	push   $0x802cd4
  8006f0:	68 89 00 00 00       	push   $0x89
  8006f5:	68 bc 2c 80 00       	push   $0x802cbc
  8006fa:	e8 2a 06 00 00       	call   800d29 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  8006ff:	e8 ab 1e 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800704:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800707:	3d 80 00 00 00       	cmp    $0x80,%eax
  80070c:	74 17                	je     800725 <_main+0x6ed>
  80070e:	83 ec 04             	sub    $0x4,%esp
  800711:	68 04 2d 80 00       	push   $0x802d04
  800716:	68 8b 00 00 00       	push   $0x8b
  80071b:	68 bc 2c 80 00       	push   $0x802cbc
  800720:	e8 04 06 00 00       	call   800d29 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800725:	e8 02 1e 00 00       	call   80252c <sys_calculate_free_frames>
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80072f:	39 c2                	cmp    %eax,%edx
  800731:	74 17                	je     80074a <_main+0x712>
  800733:	83 ec 04             	sub    $0x4,%esp
  800736:	68 21 2d 80 00       	push   $0x802d21
  80073b:	68 8c 00 00 00       	push   $0x8c
  800740:	68 bc 2c 80 00       	push   $0x802cbc
  800745:	e8 df 05 00 00       	call   800d29 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80074a:	e8 dd 1d 00 00       	call   80252c <sys_calculate_free_frames>
  80074f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800752:	e8 58 1e 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800757:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80075a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80075d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800760:	83 ec 0c             	sub    $0xc,%esp
  800763:	50                   	push   %eax
  800764:	e8 ec 15 00 00       	call   801d55 <malloc>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  80076f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800772:	89 c2                	mov    %eax,%edx
  800774:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800777:	c1 e0 02             	shl    $0x2,%eax
  80077a:	05 00 00 00 80       	add    $0x80000000,%eax
  80077f:	39 c2                	cmp    %eax,%edx
  800781:	74 17                	je     80079a <_main+0x762>
  800783:	83 ec 04             	sub    $0x4,%esp
  800786:	68 d4 2c 80 00       	push   $0x802cd4
  80078b:	68 92 00 00 00       	push   $0x92
  800790:	68 bc 2c 80 00       	push   $0x802cbc
  800795:	e8 8f 05 00 00       	call   800d29 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80079a:	e8 10 1e 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  80079f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007a2:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007a7:	74 17                	je     8007c0 <_main+0x788>
  8007a9:	83 ec 04             	sub    $0x4,%esp
  8007ac:	68 04 2d 80 00       	push   $0x802d04
  8007b1:	68 94 00 00 00       	push   $0x94
  8007b6:	68 bc 2c 80 00       	push   $0x802cbc
  8007bb:	e8 69 05 00 00       	call   800d29 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007c0:	e8 67 1d 00 00       	call   80252c <sys_calculate_free_frames>
  8007c5:	89 c2                	mov    %eax,%edx
  8007c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ca:	39 c2                	cmp    %eax,%edx
  8007cc:	74 17                	je     8007e5 <_main+0x7ad>
  8007ce:	83 ec 04             	sub    $0x4,%esp
  8007d1:	68 21 2d 80 00       	push   $0x802d21
  8007d6:	68 95 00 00 00       	push   $0x95
  8007db:	68 bc 2c 80 00       	push   $0x802cbc
  8007e0:	e8 44 05 00 00       	call   800d29 <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007e5:	e8 42 1d 00 00       	call   80252c <sys_calculate_free_frames>
  8007ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007ed:	e8 bd 1d 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  8007f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  8007f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007f8:	89 d0                	mov    %edx,%eax
  8007fa:	c1 e0 08             	shl    $0x8,%eax
  8007fd:	29 d0                	sub    %edx,%eax
  8007ff:	83 ec 0c             	sub    $0xc,%esp
  800802:	50                   	push   %eax
  800803:	e8 4d 15 00 00       	call   801d55 <malloc>
  800808:	83 c4 10             	add    $0x10,%esp
  80080b:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  80080e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800811:	89 c2                	mov    %eax,%edx
  800813:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800816:	c1 e0 09             	shl    $0x9,%eax
  800819:	89 c1                	mov    %eax,%ecx
  80081b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081e:	01 c8                	add    %ecx,%eax
  800820:	05 00 00 00 80       	add    $0x80000000,%eax
  800825:	39 c2                	cmp    %eax,%edx
  800827:	74 17                	je     800840 <_main+0x808>
  800829:	83 ec 04             	sub    $0x4,%esp
  80082c:	68 d4 2c 80 00       	push   $0x802cd4
  800831:	68 9b 00 00 00       	push   $0x9b
  800836:	68 bc 2c 80 00       	push   $0x802cbc
  80083b:	e8 e9 04 00 00       	call   800d29 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800840:	e8 6a 1d 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800845:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800848:	83 f8 40             	cmp    $0x40,%eax
  80084b:	74 17                	je     800864 <_main+0x82c>
  80084d:	83 ec 04             	sub    $0x4,%esp
  800850:	68 04 2d 80 00       	push   $0x802d04
  800855:	68 9d 00 00 00       	push   $0x9d
  80085a:	68 bc 2c 80 00       	push   $0x802cbc
  80085f:	e8 c5 04 00 00       	call   800d29 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800864:	e8 c3 1c 00 00       	call   80252c <sys_calculate_free_frames>
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80086e:	39 c2                	cmp    %eax,%edx
  800870:	74 17                	je     800889 <_main+0x851>
  800872:	83 ec 04             	sub    $0x4,%esp
  800875:	68 21 2d 80 00       	push   $0x802d21
  80087a:	68 9e 00 00 00       	push   $0x9e
  80087f:	68 bc 2c 80 00       	push   $0x802cbc
  800884:	e8 a0 04 00 00       	call   800d29 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800889:	e8 9e 1c 00 00       	call   80252c <sys_calculate_free_frames>
  80088e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800891:	e8 19 1d 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800896:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800899:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80089c:	01 c0                	add    %eax,%eax
  80089e:	83 ec 0c             	sub    $0xc,%esp
  8008a1:	50                   	push   %eax
  8008a2:	e8 ae 14 00 00       	call   801d55 <malloc>
  8008a7:	83 c4 10             	add    $0x10,%esp
  8008aa:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8008ad:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8008b0:	89 c2                	mov    %eax,%edx
  8008b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b5:	c1 e0 03             	shl    $0x3,%eax
  8008b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8008bd:	39 c2                	cmp    %eax,%edx
  8008bf:	74 17                	je     8008d8 <_main+0x8a0>
  8008c1:	83 ec 04             	sub    $0x4,%esp
  8008c4:	68 d4 2c 80 00       	push   $0x802cd4
  8008c9:	68 a4 00 00 00       	push   $0xa4
  8008ce:	68 bc 2c 80 00       	push   $0x802cbc
  8008d3:	e8 51 04 00 00       	call   800d29 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8008d8:	e8 d2 1c 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  8008dd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008e0:	3d 00 02 00 00       	cmp    $0x200,%eax
  8008e5:	74 17                	je     8008fe <_main+0x8c6>
  8008e7:	83 ec 04             	sub    $0x4,%esp
  8008ea:	68 04 2d 80 00       	push   $0x802d04
  8008ef:	68 a6 00 00 00       	push   $0xa6
  8008f4:	68 bc 2c 80 00       	push   $0x802cbc
  8008f9:	e8 2b 04 00 00       	call   800d29 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008fe:	e8 29 1c 00 00       	call   80252c <sys_calculate_free_frames>
  800903:	89 c2                	mov    %eax,%edx
  800905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800908:	39 c2                	cmp    %eax,%edx
  80090a:	74 17                	je     800923 <_main+0x8eb>
  80090c:	83 ec 04             	sub    $0x4,%esp
  80090f:	68 21 2d 80 00       	push   $0x802d21
  800914:	68 a7 00 00 00       	push   $0xa7
  800919:	68 bc 2c 80 00       	push   $0x802cbc
  80091e:	e8 06 04 00 00       	call   800d29 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800923:	e8 04 1c 00 00       	call   80252c <sys_calculate_free_frames>
  800928:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80092b:	e8 7f 1c 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800930:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  800933:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800936:	c1 e0 02             	shl    $0x2,%eax
  800939:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80093c:	83 ec 0c             	sub    $0xc,%esp
  80093f:	50                   	push   %eax
  800940:	e8 10 14 00 00       	call   801d55 <malloc>
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  80094b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80094e:	89 c1                	mov    %eax,%ecx
  800950:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800953:	89 d0                	mov    %edx,%eax
  800955:	01 c0                	add    %eax,%eax
  800957:	01 d0                	add    %edx,%eax
  800959:	01 c0                	add    %eax,%eax
  80095b:	01 d0                	add    %edx,%eax
  80095d:	01 c0                	add    %eax,%eax
  80095f:	05 00 00 00 80       	add    $0x80000000,%eax
  800964:	39 c1                	cmp    %eax,%ecx
  800966:	74 17                	je     80097f <_main+0x947>
  800968:	83 ec 04             	sub    $0x4,%esp
  80096b:	68 d4 2c 80 00       	push   $0x802cd4
  800970:	68 ad 00 00 00       	push   $0xad
  800975:	68 bc 2c 80 00       	push   $0x802cbc
  80097a:	e8 aa 03 00 00       	call   800d29 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  80097f:	e8 2b 1c 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800984:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800987:	3d 00 04 00 00       	cmp    $0x400,%eax
  80098c:	74 17                	je     8009a5 <_main+0x96d>
  80098e:	83 ec 04             	sub    $0x4,%esp
  800991:	68 04 2d 80 00       	push   $0x802d04
  800996:	68 af 00 00 00       	push   $0xaf
  80099b:	68 bc 2c 80 00       	push   $0x802cbc
  8009a0:	e8 84 03 00 00       	call   800d29 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8009a5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8009a8:	e8 7f 1b 00 00       	call   80252c <sys_calculate_free_frames>
  8009ad:	29 c3                	sub    %eax,%ebx
  8009af:	89 d8                	mov    %ebx,%eax
  8009b1:	83 f8 01             	cmp    $0x1,%eax
  8009b4:	74 17                	je     8009cd <_main+0x995>
  8009b6:	83 ec 04             	sub    $0x4,%esp
  8009b9:	68 21 2d 80 00       	push   $0x802d21
  8009be:	68 b0 00 00 00       	push   $0xb0
  8009c3:	68 bc 2c 80 00       	push   $0x802cbc
  8009c8:	e8 5c 03 00 00       	call   800d29 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8009cd:	e8 5a 1b 00 00       	call   80252c <sys_calculate_free_frames>
  8009d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d5:	e8 d5 1b 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  8009da:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8009dd:	8b 45 98             	mov    -0x68(%ebp),%eax
  8009e0:	83 ec 0c             	sub    $0xc,%esp
  8009e3:	50                   	push   %eax
  8009e4:	e8 27 18 00 00       	call   802210 <free>
  8009e9:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  8009ec:	e8 be 1b 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  8009f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f4:	29 c2                	sub    %eax,%edx
  8009f6:	89 d0                	mov    %edx,%eax
  8009f8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8009fd:	74 17                	je     800a16 <_main+0x9de>
  8009ff:	83 ec 04             	sub    $0x4,%esp
  800a02:	68 34 2d 80 00       	push   $0x802d34
  800a07:	68 ba 00 00 00       	push   $0xba
  800a0c:	68 bc 2c 80 00       	push   $0x802cbc
  800a11:	e8 13 03 00 00       	call   800d29 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a16:	e8 11 1b 00 00       	call   80252c <sys_calculate_free_frames>
  800a1b:	89 c2                	mov    %eax,%edx
  800a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a20:	39 c2                	cmp    %eax,%edx
  800a22:	74 17                	je     800a3b <_main+0xa03>
  800a24:	83 ec 04             	sub    $0x4,%esp
  800a27:	68 4b 2d 80 00       	push   $0x802d4b
  800a2c:	68 bb 00 00 00       	push   $0xbb
  800a31:	68 bc 2c 80 00       	push   $0x802cbc
  800a36:	e8 ee 02 00 00       	call   800d29 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a3b:	e8 ec 1a 00 00       	call   80252c <sys_calculate_free_frames>
  800a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a43:	e8 67 1b 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800a48:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[9]);
  800a4b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800a4e:	83 ec 0c             	sub    $0xc,%esp
  800a51:	50                   	push   %eax
  800a52:	e8 b9 17 00 00       	call   802210 <free>
  800a57:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800a5a:	e8 50 1b 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800a5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a62:	29 c2                	sub    %eax,%edx
  800a64:	89 d0                	mov    %edx,%eax
  800a66:	3d 00 01 00 00       	cmp    $0x100,%eax
  800a6b:	74 17                	je     800a84 <_main+0xa4c>
  800a6d:	83 ec 04             	sub    $0x4,%esp
  800a70:	68 34 2d 80 00       	push   $0x802d34
  800a75:	68 c2 00 00 00       	push   $0xc2
  800a7a:	68 bc 2c 80 00       	push   $0x802cbc
  800a7f:	e8 a5 02 00 00       	call   800d29 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a84:	e8 a3 1a 00 00       	call   80252c <sys_calculate_free_frames>
  800a89:	89 c2                	mov    %eax,%edx
  800a8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a8e:	39 c2                	cmp    %eax,%edx
  800a90:	74 17                	je     800aa9 <_main+0xa71>
  800a92:	83 ec 04             	sub    $0x4,%esp
  800a95:	68 4b 2d 80 00       	push   $0x802d4b
  800a9a:	68 c3 00 00 00       	push   $0xc3
  800a9f:	68 bc 2c 80 00       	push   $0x802cbc
  800aa4:	e8 80 02 00 00       	call   800d29 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800aa9:	e8 7e 1a 00 00       	call   80252c <sys_calculate_free_frames>
  800aae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ab1:	e8 f9 1a 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800ab6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800ab9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800abc:	83 ec 0c             	sub    $0xc,%esp
  800abf:	50                   	push   %eax
  800ac0:	e8 4b 17 00 00       	call   802210 <free>
  800ac5:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800ac8:	e8 e2 1a 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800acd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ad0:	29 c2                	sub    %eax,%edx
  800ad2:	89 d0                	mov    %edx,%eax
  800ad4:	3d 00 01 00 00       	cmp    $0x100,%eax
  800ad9:	74 17                	je     800af2 <_main+0xaba>
  800adb:	83 ec 04             	sub    $0x4,%esp
  800ade:	68 34 2d 80 00       	push   $0x802d34
  800ae3:	68 ca 00 00 00       	push   $0xca
  800ae8:	68 bc 2c 80 00       	push   $0x802cbc
  800aed:	e8 37 02 00 00       	call   800d29 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800af2:	e8 35 1a 00 00       	call   80252c <sys_calculate_free_frames>
  800af7:	89 c2                	mov    %eax,%edx
  800af9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800afc:	39 c2                	cmp    %eax,%edx
  800afe:	74 17                	je     800b17 <_main+0xadf>
  800b00:	83 ec 04             	sub    $0x4,%esp
  800b03:	68 4b 2d 80 00       	push   $0x802d4b
  800b08:	68 cb 00 00 00       	push   $0xcb
  800b0d:	68 bc 2c 80 00       	push   $0x802cbc
  800b12:	e8 12 02 00 00       	call   800d29 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800b17:	e8 10 1a 00 00       	call   80252c <sys_calculate_free_frames>
  800b1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b1f:	e8 8b 1a 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800b24:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[13] = malloc(4*Mega + 256*kilo - kilo);
  800b27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b2a:	c1 e0 06             	shl    $0x6,%eax
  800b2d:	89 c2                	mov    %eax,%edx
  800b2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b32:	01 d0                	add    %edx,%eax
  800b34:	c1 e0 02             	shl    $0x2,%eax
  800b37:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800b3a:	83 ec 0c             	sub    $0xc,%esp
  800b3d:	50                   	push   %eax
  800b3e:	e8 12 12 00 00       	call   801d55 <malloc>
  800b43:	83 c4 10             	add    $0x10,%esp
  800b46:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800b4c:	89 c1                	mov    %eax,%ecx
  800b4e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b51:	89 d0                	mov    %edx,%eax
  800b53:	01 c0                	add    %eax,%eax
  800b55:	01 d0                	add    %edx,%eax
  800b57:	c1 e0 08             	shl    $0x8,%eax
  800b5a:	89 c2                	mov    %eax,%edx
  800b5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5f:	01 d0                	add    %edx,%eax
  800b61:	05 00 00 00 80       	add    $0x80000000,%eax
  800b66:	39 c1                	cmp    %eax,%ecx
  800b68:	74 17                	je     800b81 <_main+0xb49>
  800b6a:	83 ec 04             	sub    $0x4,%esp
  800b6d:	68 d4 2c 80 00       	push   $0x802cd4
  800b72:	68 d5 00 00 00       	push   $0xd5
  800b77:	68 bc 2c 80 00       	push   $0x802cbc
  800b7c:	e8 a8 01 00 00       	call   800d29 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024+64) panic("Wrong page file allocation: ");
  800b81:	e8 29 1a 00 00       	call   8025af <sys_pf_calculate_allocated_pages>
  800b86:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800b89:	3d 40 04 00 00       	cmp    $0x440,%eax
  800b8e:	74 17                	je     800ba7 <_main+0xb6f>
  800b90:	83 ec 04             	sub    $0x4,%esp
  800b93:	68 04 2d 80 00       	push   $0x802d04
  800b98:	68 d7 00 00 00       	push   $0xd7
  800b9d:	68 bc 2c 80 00       	push   $0x802cbc
  800ba2:	e8 82 01 00 00       	call   800d29 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800ba7:	e8 80 19 00 00       	call   80252c <sys_calculate_free_frames>
  800bac:	89 c2                	mov    %eax,%edx
  800bae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bb1:	39 c2                	cmp    %eax,%edx
  800bb3:	74 17                	je     800bcc <_main+0xb94>
  800bb5:	83 ec 04             	sub    $0x4,%esp
  800bb8:	68 21 2d 80 00       	push   $0x802d21
  800bbd:	68 d8 00 00 00       	push   $0xd8
  800bc2:	68 bc 2c 80 00       	push   $0x802cbc
  800bc7:	e8 5d 01 00 00       	call   800d29 <_panic>
	}
	cprintf("Congratulations!! test FIRST FIT allocation (1) completed successfully.\n");
  800bcc:	83 ec 0c             	sub    $0xc,%esp
  800bcf:	68 58 2d 80 00       	push   $0x802d58
  800bd4:	e8 f2 03 00 00       	call   800fcb <cprintf>
  800bd9:	83 c4 10             	add    $0x10,%esp

	return;
  800bdc:	90                   	nop
}
  800bdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be0:	5b                   	pop    %ebx
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800bea:	e8 72 18 00 00       	call   802461 <sys_getenvindex>
  800bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800bf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf5:	89 d0                	mov    %edx,%eax
  800bf7:	c1 e0 03             	shl    $0x3,%eax
  800bfa:	01 d0                	add    %edx,%eax
  800bfc:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800c03:	01 c8                	add    %ecx,%eax
  800c05:	01 c0                	add    %eax,%eax
  800c07:	01 d0                	add    %edx,%eax
  800c09:	01 c0                	add    %eax,%eax
  800c0b:	01 d0                	add    %edx,%eax
  800c0d:	89 c2                	mov    %eax,%edx
  800c0f:	c1 e2 05             	shl    $0x5,%edx
  800c12:	29 c2                	sub    %eax,%edx
  800c14:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800c1b:	89 c2                	mov    %eax,%edx
  800c1d:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800c23:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800c28:	a1 20 40 80 00       	mov    0x804020,%eax
  800c2d:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800c33:	84 c0                	test   %al,%al
  800c35:	74 0f                	je     800c46 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800c37:	a1 20 40 80 00       	mov    0x804020,%eax
  800c3c:	05 40 3c 01 00       	add    $0x13c40,%eax
  800c41:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c4a:	7e 0a                	jle    800c56 <libmain+0x72>
		binaryname = argv[0];
  800c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4f:	8b 00                	mov    (%eax),%eax
  800c51:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800c56:	83 ec 08             	sub    $0x8,%esp
  800c59:	ff 75 0c             	pushl  0xc(%ebp)
  800c5c:	ff 75 08             	pushl  0x8(%ebp)
  800c5f:	e8 d4 f3 ff ff       	call   800038 <_main>
  800c64:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800c67:	e8 90 19 00 00       	call   8025fc <sys_disable_interrupt>
	cprintf("**************************************\n");
  800c6c:	83 ec 0c             	sub    $0xc,%esp
  800c6f:	68 bc 2d 80 00       	push   $0x802dbc
  800c74:	e8 52 03 00 00       	call   800fcb <cprintf>
  800c79:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800c7c:	a1 20 40 80 00       	mov    0x804020,%eax
  800c81:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800c87:	a1 20 40 80 00       	mov    0x804020,%eax
  800c8c:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800c92:	83 ec 04             	sub    $0x4,%esp
  800c95:	52                   	push   %edx
  800c96:	50                   	push   %eax
  800c97:	68 e4 2d 80 00       	push   $0x802de4
  800c9c:	e8 2a 03 00 00       	call   800fcb <cprintf>
  800ca1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800ca4:	a1 20 40 80 00       	mov    0x804020,%eax
  800ca9:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800caf:	a1 20 40 80 00       	mov    0x804020,%eax
  800cb4:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800cba:	83 ec 04             	sub    $0x4,%esp
  800cbd:	52                   	push   %edx
  800cbe:	50                   	push   %eax
  800cbf:	68 0c 2e 80 00       	push   $0x802e0c
  800cc4:	e8 02 03 00 00       	call   800fcb <cprintf>
  800cc9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ccc:	a1 20 40 80 00       	mov    0x804020,%eax
  800cd1:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800cd7:	83 ec 08             	sub    $0x8,%esp
  800cda:	50                   	push   %eax
  800cdb:	68 4d 2e 80 00       	push   $0x802e4d
  800ce0:	e8 e6 02 00 00       	call   800fcb <cprintf>
  800ce5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800ce8:	83 ec 0c             	sub    $0xc,%esp
  800ceb:	68 bc 2d 80 00       	push   $0x802dbc
  800cf0:	e8 d6 02 00 00       	call   800fcb <cprintf>
  800cf5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800cf8:	e8 19 19 00 00       	call   802616 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800cfd:	e8 19 00 00 00       	call   800d1b <exit>
}
  800d02:	90                   	nop
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800d0b:	83 ec 0c             	sub    $0xc,%esp
  800d0e:	6a 00                	push   $0x0
  800d10:	e8 18 17 00 00       	call   80242d <sys_env_destroy>
  800d15:	83 c4 10             	add    $0x10,%esp
}
  800d18:	90                   	nop
  800d19:	c9                   	leave  
  800d1a:	c3                   	ret    

00800d1b <exit>:

void
exit(void)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800d21:	e8 6d 17 00 00       	call   802493 <sys_env_exit>
}
  800d26:	90                   	nop
  800d27:	c9                   	leave  
  800d28:	c3                   	ret    

00800d29 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d2f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d32:	83 c0 04             	add    $0x4,%eax
  800d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d38:	a1 18 41 80 00       	mov    0x804118,%eax
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	74 16                	je     800d57 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d41:	a1 18 41 80 00       	mov    0x804118,%eax
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	50                   	push   %eax
  800d4a:	68 64 2e 80 00       	push   $0x802e64
  800d4f:	e8 77 02 00 00       	call   800fcb <cprintf>
  800d54:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d57:	a1 00 40 80 00       	mov    0x804000,%eax
  800d5c:	ff 75 0c             	pushl  0xc(%ebp)
  800d5f:	ff 75 08             	pushl  0x8(%ebp)
  800d62:	50                   	push   %eax
  800d63:	68 69 2e 80 00       	push   $0x802e69
  800d68:	e8 5e 02 00 00       	call   800fcb <cprintf>
  800d6d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800d70:	8b 45 10             	mov    0x10(%ebp),%eax
  800d73:	83 ec 08             	sub    $0x8,%esp
  800d76:	ff 75 f4             	pushl  -0xc(%ebp)
  800d79:	50                   	push   %eax
  800d7a:	e8 e1 01 00 00       	call   800f60 <vcprintf>
  800d7f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d82:	83 ec 08             	sub    $0x8,%esp
  800d85:	6a 00                	push   $0x0
  800d87:	68 85 2e 80 00       	push   $0x802e85
  800d8c:	e8 cf 01 00 00       	call   800f60 <vcprintf>
  800d91:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d94:	e8 82 ff ff ff       	call   800d1b <exit>

	// should not return here
	while (1) ;
  800d99:	eb fe                	jmp    800d99 <_panic+0x70>

00800d9b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800da1:	a1 20 40 80 00       	mov    0x804020,%eax
  800da6:	8b 50 74             	mov    0x74(%eax),%edx
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	39 c2                	cmp    %eax,%edx
  800dae:	74 14                	je     800dc4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800db0:	83 ec 04             	sub    $0x4,%esp
  800db3:	68 88 2e 80 00       	push   $0x802e88
  800db8:	6a 26                	push   $0x26
  800dba:	68 d4 2e 80 00       	push   $0x802ed4
  800dbf:	e8 65 ff ff ff       	call   800d29 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800dc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800dcb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dd2:	e9 b6 00 00 00       	jmp    800e8d <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	01 d0                	add    %edx,%eax
  800de6:	8b 00                	mov    (%eax),%eax
  800de8:	85 c0                	test   %eax,%eax
  800dea:	75 08                	jne    800df4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800dec:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800def:	e9 96 00 00 00       	jmp    800e8a <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800df4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dfb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e02:	eb 5d                	jmp    800e61 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e04:	a1 20 40 80 00       	mov    0x804020,%eax
  800e09:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800e0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e12:	c1 e2 04             	shl    $0x4,%edx
  800e15:	01 d0                	add    %edx,%eax
  800e17:	8a 40 04             	mov    0x4(%eax),%al
  800e1a:	84 c0                	test   %al,%al
  800e1c:	75 40                	jne    800e5e <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e1e:	a1 20 40 80 00       	mov    0x804020,%eax
  800e23:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800e29:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e2c:	c1 e2 04             	shl    $0x4,%edx
  800e2f:	01 d0                	add    %edx,%eax
  800e31:	8b 00                	mov    (%eax),%eax
  800e33:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e3e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e43:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	01 c8                	add    %ecx,%eax
  800e4f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e51:	39 c2                	cmp    %eax,%edx
  800e53:	75 09                	jne    800e5e <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800e55:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800e5c:	eb 12                	jmp    800e70 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e5e:	ff 45 e8             	incl   -0x18(%ebp)
  800e61:	a1 20 40 80 00       	mov    0x804020,%eax
  800e66:	8b 50 74             	mov    0x74(%eax),%edx
  800e69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e6c:	39 c2                	cmp    %eax,%edx
  800e6e:	77 94                	ja     800e04 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800e70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e74:	75 14                	jne    800e8a <CheckWSWithoutLastIndex+0xef>
			panic(
  800e76:	83 ec 04             	sub    $0x4,%esp
  800e79:	68 e0 2e 80 00       	push   $0x802ee0
  800e7e:	6a 3a                	push   $0x3a
  800e80:	68 d4 2e 80 00       	push   $0x802ed4
  800e85:	e8 9f fe ff ff       	call   800d29 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e8a:	ff 45 f0             	incl   -0x10(%ebp)
  800e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e90:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e93:	0f 8c 3e ff ff ff    	jl     800dd7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e99:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ea0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ea7:	eb 20                	jmp    800ec9 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ea9:	a1 20 40 80 00       	mov    0x804020,%eax
  800eae:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800eb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800eb7:	c1 e2 04             	shl    $0x4,%edx
  800eba:	01 d0                	add    %edx,%eax
  800ebc:	8a 40 04             	mov    0x4(%eax),%al
  800ebf:	3c 01                	cmp    $0x1,%al
  800ec1:	75 03                	jne    800ec6 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800ec3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ec6:	ff 45 e0             	incl   -0x20(%ebp)
  800ec9:	a1 20 40 80 00       	mov    0x804020,%eax
  800ece:	8b 50 74             	mov    0x74(%eax),%edx
  800ed1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ed4:	39 c2                	cmp    %eax,%edx
  800ed6:	77 d1                	ja     800ea9 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800edb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ede:	74 14                	je     800ef4 <CheckWSWithoutLastIndex+0x159>
		panic(
  800ee0:	83 ec 04             	sub    $0x4,%esp
  800ee3:	68 34 2f 80 00       	push   $0x802f34
  800ee8:	6a 44                	push   $0x44
  800eea:	68 d4 2e 80 00       	push   $0x802ed4
  800eef:	e8 35 fe ff ff       	call   800d29 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ef4:	90                   	nop
  800ef5:	c9                   	leave  
  800ef6:	c3                   	ret    

00800ef7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	8b 00                	mov    (%eax),%eax
  800f02:	8d 48 01             	lea    0x1(%eax),%ecx
  800f05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f08:	89 0a                	mov    %ecx,(%edx)
  800f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0d:	88 d1                	mov    %dl,%cl
  800f0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f12:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	8b 00                	mov    (%eax),%eax
  800f1b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f20:	75 2c                	jne    800f4e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800f22:	a0 24 40 80 00       	mov    0x804024,%al
  800f27:	0f b6 c0             	movzbl %al,%eax
  800f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2d:	8b 12                	mov    (%edx),%edx
  800f2f:	89 d1                	mov    %edx,%ecx
  800f31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f34:	83 c2 08             	add    $0x8,%edx
  800f37:	83 ec 04             	sub    $0x4,%esp
  800f3a:	50                   	push   %eax
  800f3b:	51                   	push   %ecx
  800f3c:	52                   	push   %edx
  800f3d:	e8 a9 14 00 00       	call   8023eb <sys_cputs>
  800f42:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	8b 40 04             	mov    0x4(%eax),%eax
  800f54:	8d 50 01             	lea    0x1(%eax),%edx
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f5d:	90                   	nop
  800f5e:	c9                   	leave  
  800f5f:	c3                   	ret    

00800f60 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800f69:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f70:	00 00 00 
	b.cnt = 0;
  800f73:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f7a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f7d:	ff 75 0c             	pushl  0xc(%ebp)
  800f80:	ff 75 08             	pushl  0x8(%ebp)
  800f83:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f89:	50                   	push   %eax
  800f8a:	68 f7 0e 80 00       	push   $0x800ef7
  800f8f:	e8 11 02 00 00       	call   8011a5 <vprintfmt>
  800f94:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f97:	a0 24 40 80 00       	mov    0x804024,%al
  800f9c:	0f b6 c0             	movzbl %al,%eax
  800f9f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800fa5:	83 ec 04             	sub    $0x4,%esp
  800fa8:	50                   	push   %eax
  800fa9:	52                   	push   %edx
  800faa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fb0:	83 c0 08             	add    $0x8,%eax
  800fb3:	50                   	push   %eax
  800fb4:	e8 32 14 00 00       	call   8023eb <sys_cputs>
  800fb9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800fbc:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800fc3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <cprintf>:

int cprintf(const char *fmt, ...) {
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800fd1:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800fd8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	83 ec 08             	sub    $0x8,%esp
  800fe4:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe7:	50                   	push   %eax
  800fe8:	e8 73 ff ff ff       	call   800f60 <vcprintf>
  800fed:	83 c4 10             	add    $0x10,%esp
  800ff0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ff6:	c9                   	leave  
  800ff7:	c3                   	ret    

00800ff8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800ffe:	e8 f9 15 00 00       	call   8025fc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801003:	8d 45 0c             	lea    0xc(%ebp),%eax
  801006:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	ff 75 f4             	pushl  -0xc(%ebp)
  801012:	50                   	push   %eax
  801013:	e8 48 ff ff ff       	call   800f60 <vcprintf>
  801018:	83 c4 10             	add    $0x10,%esp
  80101b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80101e:	e8 f3 15 00 00       	call   802616 <sys_enable_interrupt>
	return cnt;
  801023:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	53                   	push   %ebx
  80102c:	83 ec 14             	sub    $0x14,%esp
  80102f:	8b 45 10             	mov    0x10(%ebp),%eax
  801032:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801035:	8b 45 14             	mov    0x14(%ebp),%eax
  801038:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80103b:	8b 45 18             	mov    0x18(%ebp),%eax
  80103e:	ba 00 00 00 00       	mov    $0x0,%edx
  801043:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801046:	77 55                	ja     80109d <printnum+0x75>
  801048:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80104b:	72 05                	jb     801052 <printnum+0x2a>
  80104d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801050:	77 4b                	ja     80109d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801052:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801055:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801058:	8b 45 18             	mov    0x18(%ebp),%eax
  80105b:	ba 00 00 00 00       	mov    $0x0,%edx
  801060:	52                   	push   %edx
  801061:	50                   	push   %eax
  801062:	ff 75 f4             	pushl  -0xc(%ebp)
  801065:	ff 75 f0             	pushl  -0x10(%ebp)
  801068:	e8 b3 19 00 00       	call   802a20 <__udivdi3>
  80106d:	83 c4 10             	add    $0x10,%esp
  801070:	83 ec 04             	sub    $0x4,%esp
  801073:	ff 75 20             	pushl  0x20(%ebp)
  801076:	53                   	push   %ebx
  801077:	ff 75 18             	pushl  0x18(%ebp)
  80107a:	52                   	push   %edx
  80107b:	50                   	push   %eax
  80107c:	ff 75 0c             	pushl  0xc(%ebp)
  80107f:	ff 75 08             	pushl  0x8(%ebp)
  801082:	e8 a1 ff ff ff       	call   801028 <printnum>
  801087:	83 c4 20             	add    $0x20,%esp
  80108a:	eb 1a                	jmp    8010a6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80108c:	83 ec 08             	sub    $0x8,%esp
  80108f:	ff 75 0c             	pushl  0xc(%ebp)
  801092:	ff 75 20             	pushl  0x20(%ebp)
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	ff d0                	call   *%eax
  80109a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80109d:	ff 4d 1c             	decl   0x1c(%ebp)
  8010a0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8010a4:	7f e6                	jg     80108c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010a6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8010a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b4:	53                   	push   %ebx
  8010b5:	51                   	push   %ecx
  8010b6:	52                   	push   %edx
  8010b7:	50                   	push   %eax
  8010b8:	e8 73 1a 00 00       	call   802b30 <__umoddi3>
  8010bd:	83 c4 10             	add    $0x10,%esp
  8010c0:	05 94 31 80 00       	add    $0x803194,%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	0f be c0             	movsbl %al,%eax
  8010ca:	83 ec 08             	sub    $0x8,%esp
  8010cd:	ff 75 0c             	pushl  0xc(%ebp)
  8010d0:	50                   	push   %eax
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	ff d0                	call   *%eax
  8010d6:	83 c4 10             	add    $0x10,%esp
}
  8010d9:	90                   	nop
  8010da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010dd:	c9                   	leave  
  8010de:	c3                   	ret    

008010df <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010e2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010e6:	7e 1c                	jle    801104 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8b 00                	mov    (%eax),%eax
  8010ed:	8d 50 08             	lea    0x8(%eax),%edx
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	89 10                	mov    %edx,(%eax)
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8b 00                	mov    (%eax),%eax
  8010fa:	83 e8 08             	sub    $0x8,%eax
  8010fd:	8b 50 04             	mov    0x4(%eax),%edx
  801100:	8b 00                	mov    (%eax),%eax
  801102:	eb 40                	jmp    801144 <getuint+0x65>
	else if (lflag)
  801104:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801108:	74 1e                	je     801128 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8b 00                	mov    (%eax),%eax
  80110f:	8d 50 04             	lea    0x4(%eax),%edx
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	89 10                	mov    %edx,(%eax)
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8b 00                	mov    (%eax),%eax
  80111c:	83 e8 04             	sub    $0x4,%eax
  80111f:	8b 00                	mov    (%eax),%eax
  801121:	ba 00 00 00 00       	mov    $0x0,%edx
  801126:	eb 1c                	jmp    801144 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8b 00                	mov    (%eax),%eax
  80112d:	8d 50 04             	lea    0x4(%eax),%edx
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	89 10                	mov    %edx,(%eax)
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8b 00                	mov    (%eax),%eax
  80113a:	83 e8 04             	sub    $0x4,%eax
  80113d:	8b 00                	mov    (%eax),%eax
  80113f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    

00801146 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801149:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80114d:	7e 1c                	jle    80116b <getint+0x25>
		return va_arg(*ap, long long);
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	8b 00                	mov    (%eax),%eax
  801154:	8d 50 08             	lea    0x8(%eax),%edx
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	89 10                	mov    %edx,(%eax)
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8b 00                	mov    (%eax),%eax
  801161:	83 e8 08             	sub    $0x8,%eax
  801164:	8b 50 04             	mov    0x4(%eax),%edx
  801167:	8b 00                	mov    (%eax),%eax
  801169:	eb 38                	jmp    8011a3 <getint+0x5d>
	else if (lflag)
  80116b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80116f:	74 1a                	je     80118b <getint+0x45>
		return va_arg(*ap, long);
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8b 00                	mov    (%eax),%eax
  801176:	8d 50 04             	lea    0x4(%eax),%edx
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	89 10                	mov    %edx,(%eax)
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8b 00                	mov    (%eax),%eax
  801183:	83 e8 04             	sub    $0x4,%eax
  801186:	8b 00                	mov    (%eax),%eax
  801188:	99                   	cltd   
  801189:	eb 18                	jmp    8011a3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8b 00                	mov    (%eax),%eax
  801190:	8d 50 04             	lea    0x4(%eax),%edx
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	89 10                	mov    %edx,(%eax)
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8b 00                	mov    (%eax),%eax
  80119d:	83 e8 04             	sub    $0x4,%eax
  8011a0:	8b 00                	mov    (%eax),%eax
  8011a2:	99                   	cltd   
}
  8011a3:	5d                   	pop    %ebp
  8011a4:	c3                   	ret    

008011a5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	56                   	push   %esi
  8011a9:	53                   	push   %ebx
  8011aa:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011ad:	eb 17                	jmp    8011c6 <vprintfmt+0x21>
			if (ch == '\0')
  8011af:	85 db                	test   %ebx,%ebx
  8011b1:	0f 84 af 03 00 00    	je     801566 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8011b7:	83 ec 08             	sub    $0x8,%esp
  8011ba:	ff 75 0c             	pushl  0xc(%ebp)
  8011bd:	53                   	push   %ebx
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	ff d0                	call   *%eax
  8011c3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	8d 50 01             	lea    0x1(%eax),%edx
  8011cc:	89 55 10             	mov    %edx,0x10(%ebp)
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	0f b6 d8             	movzbl %al,%ebx
  8011d4:	83 fb 25             	cmp    $0x25,%ebx
  8011d7:	75 d6                	jne    8011af <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8011d9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8011dd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8011e4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8011eb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8011f2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	8d 50 01             	lea    0x1(%eax),%edx
  8011ff:	89 55 10             	mov    %edx,0x10(%ebp)
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f b6 d8             	movzbl %al,%ebx
  801207:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80120a:	83 f8 55             	cmp    $0x55,%eax
  80120d:	0f 87 2b 03 00 00    	ja     80153e <vprintfmt+0x399>
  801213:	8b 04 85 b8 31 80 00 	mov    0x8031b8(,%eax,4),%eax
  80121a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80121c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801220:	eb d7                	jmp    8011f9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801222:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801226:	eb d1                	jmp    8011f9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801228:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80122f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801232:	89 d0                	mov    %edx,%eax
  801234:	c1 e0 02             	shl    $0x2,%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	01 c0                	add    %eax,%eax
  80123b:	01 d8                	add    %ebx,%eax
  80123d:	83 e8 30             	sub    $0x30,%eax
  801240:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801243:	8b 45 10             	mov    0x10(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80124b:	83 fb 2f             	cmp    $0x2f,%ebx
  80124e:	7e 3e                	jle    80128e <vprintfmt+0xe9>
  801250:	83 fb 39             	cmp    $0x39,%ebx
  801253:	7f 39                	jg     80128e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801255:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801258:	eb d5                	jmp    80122f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80125a:	8b 45 14             	mov    0x14(%ebp),%eax
  80125d:	83 c0 04             	add    $0x4,%eax
  801260:	89 45 14             	mov    %eax,0x14(%ebp)
  801263:	8b 45 14             	mov    0x14(%ebp),%eax
  801266:	83 e8 04             	sub    $0x4,%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80126e:	eb 1f                	jmp    80128f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801270:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801274:	79 83                	jns    8011f9 <vprintfmt+0x54>
				width = 0;
  801276:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80127d:	e9 77 ff ff ff       	jmp    8011f9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801282:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801289:	e9 6b ff ff ff       	jmp    8011f9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80128e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80128f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801293:	0f 89 60 ff ff ff    	jns    8011f9 <vprintfmt+0x54>
				width = precision, precision = -1;
  801299:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80129c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80129f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8012a6:	e9 4e ff ff ff       	jmp    8011f9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012ab:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8012ae:	e9 46 ff ff ff       	jmp    8011f9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8012b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b6:	83 c0 04             	add    $0x4,%eax
  8012b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8012bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012bf:	83 e8 04             	sub    $0x4,%eax
  8012c2:	8b 00                	mov    (%eax),%eax
  8012c4:	83 ec 08             	sub    $0x8,%esp
  8012c7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ca:	50                   	push   %eax
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	ff d0                	call   *%eax
  8012d0:	83 c4 10             	add    $0x10,%esp
			break;
  8012d3:	e9 89 02 00 00       	jmp    801561 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8012d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012db:	83 c0 04             	add    $0x4,%eax
  8012de:	89 45 14             	mov    %eax,0x14(%ebp)
  8012e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e4:	83 e8 04             	sub    $0x4,%eax
  8012e7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8012e9:	85 db                	test   %ebx,%ebx
  8012eb:	79 02                	jns    8012ef <vprintfmt+0x14a>
				err = -err;
  8012ed:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8012ef:	83 fb 64             	cmp    $0x64,%ebx
  8012f2:	7f 0b                	jg     8012ff <vprintfmt+0x15a>
  8012f4:	8b 34 9d 00 30 80 00 	mov    0x803000(,%ebx,4),%esi
  8012fb:	85 f6                	test   %esi,%esi
  8012fd:	75 19                	jne    801318 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8012ff:	53                   	push   %ebx
  801300:	68 a5 31 80 00       	push   $0x8031a5
  801305:	ff 75 0c             	pushl  0xc(%ebp)
  801308:	ff 75 08             	pushl  0x8(%ebp)
  80130b:	e8 5e 02 00 00       	call   80156e <printfmt>
  801310:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801313:	e9 49 02 00 00       	jmp    801561 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801318:	56                   	push   %esi
  801319:	68 ae 31 80 00       	push   $0x8031ae
  80131e:	ff 75 0c             	pushl  0xc(%ebp)
  801321:	ff 75 08             	pushl  0x8(%ebp)
  801324:	e8 45 02 00 00       	call   80156e <printfmt>
  801329:	83 c4 10             	add    $0x10,%esp
			break;
  80132c:	e9 30 02 00 00       	jmp    801561 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801331:	8b 45 14             	mov    0x14(%ebp),%eax
  801334:	83 c0 04             	add    $0x4,%eax
  801337:	89 45 14             	mov    %eax,0x14(%ebp)
  80133a:	8b 45 14             	mov    0x14(%ebp),%eax
  80133d:	83 e8 04             	sub    $0x4,%eax
  801340:	8b 30                	mov    (%eax),%esi
  801342:	85 f6                	test   %esi,%esi
  801344:	75 05                	jne    80134b <vprintfmt+0x1a6>
				p = "(null)";
  801346:	be b1 31 80 00       	mov    $0x8031b1,%esi
			if (width > 0 && padc != '-')
  80134b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80134f:	7e 6d                	jle    8013be <vprintfmt+0x219>
  801351:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801355:	74 67                	je     8013be <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801357:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	50                   	push   %eax
  80135e:	56                   	push   %esi
  80135f:	e8 0c 03 00 00       	call   801670 <strnlen>
  801364:	83 c4 10             	add    $0x10,%esp
  801367:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80136a:	eb 16                	jmp    801382 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80136c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	ff 75 0c             	pushl  0xc(%ebp)
  801376:	50                   	push   %eax
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	ff d0                	call   *%eax
  80137c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80137f:	ff 4d e4             	decl   -0x1c(%ebp)
  801382:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801386:	7f e4                	jg     80136c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801388:	eb 34                	jmp    8013be <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80138a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80138e:	74 1c                	je     8013ac <vprintfmt+0x207>
  801390:	83 fb 1f             	cmp    $0x1f,%ebx
  801393:	7e 05                	jle    80139a <vprintfmt+0x1f5>
  801395:	83 fb 7e             	cmp    $0x7e,%ebx
  801398:	7e 12                	jle    8013ac <vprintfmt+0x207>
					putch('?', putdat);
  80139a:	83 ec 08             	sub    $0x8,%esp
  80139d:	ff 75 0c             	pushl  0xc(%ebp)
  8013a0:	6a 3f                	push   $0x3f
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	ff d0                	call   *%eax
  8013a7:	83 c4 10             	add    $0x10,%esp
  8013aa:	eb 0f                	jmp    8013bb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8013ac:	83 ec 08             	sub    $0x8,%esp
  8013af:	ff 75 0c             	pushl  0xc(%ebp)
  8013b2:	53                   	push   %ebx
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	ff d0                	call   *%eax
  8013b8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013bb:	ff 4d e4             	decl   -0x1c(%ebp)
  8013be:	89 f0                	mov    %esi,%eax
  8013c0:	8d 70 01             	lea    0x1(%eax),%esi
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	0f be d8             	movsbl %al,%ebx
  8013c8:	85 db                	test   %ebx,%ebx
  8013ca:	74 24                	je     8013f0 <vprintfmt+0x24b>
  8013cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013d0:	78 b8                	js     80138a <vprintfmt+0x1e5>
  8013d2:	ff 4d e0             	decl   -0x20(%ebp)
  8013d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013d9:	79 af                	jns    80138a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013db:	eb 13                	jmp    8013f0 <vprintfmt+0x24b>
				putch(' ', putdat);
  8013dd:	83 ec 08             	sub    $0x8,%esp
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	6a 20                	push   $0x20
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	ff d0                	call   *%eax
  8013ea:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013ed:	ff 4d e4             	decl   -0x1c(%ebp)
  8013f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013f4:	7f e7                	jg     8013dd <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8013f6:	e9 66 01 00 00       	jmp    801561 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8013fb:	83 ec 08             	sub    $0x8,%esp
  8013fe:	ff 75 e8             	pushl  -0x18(%ebp)
  801401:	8d 45 14             	lea    0x14(%ebp),%eax
  801404:	50                   	push   %eax
  801405:	e8 3c fd ff ff       	call   801146 <getint>
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801410:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801416:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801419:	85 d2                	test   %edx,%edx
  80141b:	79 23                	jns    801440 <vprintfmt+0x29b>
				putch('-', putdat);
  80141d:	83 ec 08             	sub    $0x8,%esp
  801420:	ff 75 0c             	pushl  0xc(%ebp)
  801423:	6a 2d                	push   $0x2d
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	ff d0                	call   *%eax
  80142a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80142d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801430:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801433:	f7 d8                	neg    %eax
  801435:	83 d2 00             	adc    $0x0,%edx
  801438:	f7 da                	neg    %edx
  80143a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80143d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801440:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801447:	e9 bc 00 00 00       	jmp    801508 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	ff 75 e8             	pushl  -0x18(%ebp)
  801452:	8d 45 14             	lea    0x14(%ebp),%eax
  801455:	50                   	push   %eax
  801456:	e8 84 fc ff ff       	call   8010df <getuint>
  80145b:	83 c4 10             	add    $0x10,%esp
  80145e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801461:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801464:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80146b:	e9 98 00 00 00       	jmp    801508 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801470:	83 ec 08             	sub    $0x8,%esp
  801473:	ff 75 0c             	pushl  0xc(%ebp)
  801476:	6a 58                	push   $0x58
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	ff d0                	call   *%eax
  80147d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801480:	83 ec 08             	sub    $0x8,%esp
  801483:	ff 75 0c             	pushl  0xc(%ebp)
  801486:	6a 58                	push   $0x58
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	ff d0                	call   *%eax
  80148d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801490:	83 ec 08             	sub    $0x8,%esp
  801493:	ff 75 0c             	pushl  0xc(%ebp)
  801496:	6a 58                	push   $0x58
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	ff d0                	call   *%eax
  80149d:	83 c4 10             	add    $0x10,%esp
			break;
  8014a0:	e9 bc 00 00 00       	jmp    801561 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8014a5:	83 ec 08             	sub    $0x8,%esp
  8014a8:	ff 75 0c             	pushl  0xc(%ebp)
  8014ab:	6a 30                	push   $0x30
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	ff d0                	call   *%eax
  8014b2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8014b5:	83 ec 08             	sub    $0x8,%esp
  8014b8:	ff 75 0c             	pushl  0xc(%ebp)
  8014bb:	6a 78                	push   $0x78
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	ff d0                	call   *%eax
  8014c2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8014c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c8:	83 c0 04             	add    $0x4,%eax
  8014cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8014ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d1:	83 e8 04             	sub    $0x4,%eax
  8014d4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8014e0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8014e7:	eb 1f                	jmp    801508 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8014e9:	83 ec 08             	sub    $0x8,%esp
  8014ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8014ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8014f2:	50                   	push   %eax
  8014f3:	e8 e7 fb ff ff       	call   8010df <getuint>
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801501:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801508:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80150c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80150f:	83 ec 04             	sub    $0x4,%esp
  801512:	52                   	push   %edx
  801513:	ff 75 e4             	pushl  -0x1c(%ebp)
  801516:	50                   	push   %eax
  801517:	ff 75 f4             	pushl  -0xc(%ebp)
  80151a:	ff 75 f0             	pushl  -0x10(%ebp)
  80151d:	ff 75 0c             	pushl  0xc(%ebp)
  801520:	ff 75 08             	pushl  0x8(%ebp)
  801523:	e8 00 fb ff ff       	call   801028 <printnum>
  801528:	83 c4 20             	add    $0x20,%esp
			break;
  80152b:	eb 34                	jmp    801561 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80152d:	83 ec 08             	sub    $0x8,%esp
  801530:	ff 75 0c             	pushl  0xc(%ebp)
  801533:	53                   	push   %ebx
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	ff d0                	call   *%eax
  801539:	83 c4 10             	add    $0x10,%esp
			break;
  80153c:	eb 23                	jmp    801561 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	6a 25                	push   $0x25
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	ff d0                	call   *%eax
  80154b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80154e:	ff 4d 10             	decl   0x10(%ebp)
  801551:	eb 03                	jmp    801556 <vprintfmt+0x3b1>
  801553:	ff 4d 10             	decl   0x10(%ebp)
  801556:	8b 45 10             	mov    0x10(%ebp),%eax
  801559:	48                   	dec    %eax
  80155a:	8a 00                	mov    (%eax),%al
  80155c:	3c 25                	cmp    $0x25,%al
  80155e:	75 f3                	jne    801553 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801560:	90                   	nop
		}
	}
  801561:	e9 47 fc ff ff       	jmp    8011ad <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801566:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801567:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80156a:	5b                   	pop    %ebx
  80156b:	5e                   	pop    %esi
  80156c:	5d                   	pop    %ebp
  80156d:	c3                   	ret    

0080156e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801574:	8d 45 10             	lea    0x10(%ebp),%eax
  801577:	83 c0 04             	add    $0x4,%eax
  80157a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80157d:	8b 45 10             	mov    0x10(%ebp),%eax
  801580:	ff 75 f4             	pushl  -0xc(%ebp)
  801583:	50                   	push   %eax
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	ff 75 08             	pushl  0x8(%ebp)
  80158a:	e8 16 fc ff ff       	call   8011a5 <vprintfmt>
  80158f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801592:	90                   	nop
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	8b 40 08             	mov    0x8(%eax),%eax
  80159e:	8d 50 01             	lea    0x1(%eax),%edx
  8015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8015a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015aa:	8b 10                	mov    (%eax),%edx
  8015ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015af:	8b 40 04             	mov    0x4(%eax),%eax
  8015b2:	39 c2                	cmp    %eax,%edx
  8015b4:	73 12                	jae    8015c8 <sprintputch+0x33>
		*b->buf++ = ch;
  8015b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b9:	8b 00                	mov    (%eax),%eax
  8015bb:	8d 48 01             	lea    0x1(%eax),%ecx
  8015be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c1:	89 0a                	mov    %ecx,(%edx)
  8015c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c6:	88 10                	mov    %dl,(%eax)
}
  8015c8:	90                   	nop
  8015c9:	5d                   	pop    %ebp
  8015ca:	c3                   	ret    

008015cb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	01 d0                	add    %edx,%eax
  8015e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8015ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015f0:	74 06                	je     8015f8 <vsnprintf+0x2d>
  8015f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015f6:	7f 07                	jg     8015ff <vsnprintf+0x34>
		return -E_INVAL;
  8015f8:	b8 03 00 00 00       	mov    $0x3,%eax
  8015fd:	eb 20                	jmp    80161f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8015ff:	ff 75 14             	pushl  0x14(%ebp)
  801602:	ff 75 10             	pushl  0x10(%ebp)
  801605:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801608:	50                   	push   %eax
  801609:	68 95 15 80 00       	push   $0x801595
  80160e:	e8 92 fb ff ff       	call   8011a5 <vprintfmt>
  801613:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801616:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801619:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80161c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801627:	8d 45 10             	lea    0x10(%ebp),%eax
  80162a:	83 c0 04             	add    $0x4,%eax
  80162d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801630:	8b 45 10             	mov    0x10(%ebp),%eax
  801633:	ff 75 f4             	pushl  -0xc(%ebp)
  801636:	50                   	push   %eax
  801637:	ff 75 0c             	pushl  0xc(%ebp)
  80163a:	ff 75 08             	pushl  0x8(%ebp)
  80163d:	e8 89 ff ff ff       	call   8015cb <vsnprintf>
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801648:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801653:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80165a:	eb 06                	jmp    801662 <strlen+0x15>
		n++;
  80165c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80165f:	ff 45 08             	incl   0x8(%ebp)
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	84 c0                	test   %al,%al
  801669:	75 f1                	jne    80165c <strlen+0xf>
		n++;
	return n;
  80166b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801676:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80167d:	eb 09                	jmp    801688 <strnlen+0x18>
		n++;
  80167f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801682:	ff 45 08             	incl   0x8(%ebp)
  801685:	ff 4d 0c             	decl   0xc(%ebp)
  801688:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80168c:	74 09                	je     801697 <strnlen+0x27>
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	8a 00                	mov    (%eax),%al
  801693:	84 c0                	test   %al,%al
  801695:	75 e8                	jne    80167f <strnlen+0xf>
		n++;
	return n;
  801697:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016a8:	90                   	nop
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	8d 50 01             	lea    0x1(%eax),%edx
  8016af:	89 55 08             	mov    %edx,0x8(%ebp)
  8016b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016b8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016bb:	8a 12                	mov    (%edx),%dl
  8016bd:	88 10                	mov    %dl,(%eax)
  8016bf:	8a 00                	mov    (%eax),%al
  8016c1:	84 c0                	test   %al,%al
  8016c3:	75 e4                	jne    8016a9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8016d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016dd:	eb 1f                	jmp    8016fe <strncpy+0x34>
		*dst++ = *src;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8d 50 01             	lea    0x1(%eax),%edx
  8016e5:	89 55 08             	mov    %edx,0x8(%ebp)
  8016e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016eb:	8a 12                	mov    (%edx),%dl
  8016ed:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8016ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	84 c0                	test   %al,%al
  8016f6:	74 03                	je     8016fb <strncpy+0x31>
			src++;
  8016f8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8016fb:	ff 45 fc             	incl   -0x4(%ebp)
  8016fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801701:	3b 45 10             	cmp    0x10(%ebp),%eax
  801704:	72 d9                	jb     8016df <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801706:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801717:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80171b:	74 30                	je     80174d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80171d:	eb 16                	jmp    801735 <strlcpy+0x2a>
			*dst++ = *src++;
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	8d 50 01             	lea    0x1(%eax),%edx
  801725:	89 55 08             	mov    %edx,0x8(%ebp)
  801728:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80172e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801731:	8a 12                	mov    (%edx),%dl
  801733:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801735:	ff 4d 10             	decl   0x10(%ebp)
  801738:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80173c:	74 09                	je     801747 <strlcpy+0x3c>
  80173e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801741:	8a 00                	mov    (%eax),%al
  801743:	84 c0                	test   %al,%al
  801745:	75 d8                	jne    80171f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801747:	8b 45 08             	mov    0x8(%ebp),%eax
  80174a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80174d:	8b 55 08             	mov    0x8(%ebp),%edx
  801750:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801753:	29 c2                	sub    %eax,%edx
  801755:	89 d0                	mov    %edx,%eax
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80175c:	eb 06                	jmp    801764 <strcmp+0xb>
		p++, q++;
  80175e:	ff 45 08             	incl   0x8(%ebp)
  801761:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	84 c0                	test   %al,%al
  80176b:	74 0e                	je     80177b <strcmp+0x22>
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8a 10                	mov    (%eax),%dl
  801772:	8b 45 0c             	mov    0xc(%ebp),%eax
  801775:	8a 00                	mov    (%eax),%al
  801777:	38 c2                	cmp    %al,%dl
  801779:	74 e3                	je     80175e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	8a 00                	mov    (%eax),%al
  801780:	0f b6 d0             	movzbl %al,%edx
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	8a 00                	mov    (%eax),%al
  801788:	0f b6 c0             	movzbl %al,%eax
  80178b:	29 c2                	sub    %eax,%edx
  80178d:	89 d0                	mov    %edx,%eax
}
  80178f:	5d                   	pop    %ebp
  801790:	c3                   	ret    

00801791 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801794:	eb 09                	jmp    80179f <strncmp+0xe>
		n--, p++, q++;
  801796:	ff 4d 10             	decl   0x10(%ebp)
  801799:	ff 45 08             	incl   0x8(%ebp)
  80179c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80179f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017a3:	74 17                	je     8017bc <strncmp+0x2b>
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	8a 00                	mov    (%eax),%al
  8017aa:	84 c0                	test   %al,%al
  8017ac:	74 0e                	je     8017bc <strncmp+0x2b>
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	8a 10                	mov    (%eax),%dl
  8017b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	38 c2                	cmp    %al,%dl
  8017ba:	74 da                	je     801796 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c0:	75 07                	jne    8017c9 <strncmp+0x38>
		return 0;
  8017c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c7:	eb 14                	jmp    8017dd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	0f b6 d0             	movzbl %al,%edx
  8017d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d4:	8a 00                	mov    (%eax),%al
  8017d6:	0f b6 c0             	movzbl %al,%eax
  8017d9:	29 c2                	sub    %eax,%edx
  8017db:	89 d0                	mov    %edx,%eax
}
  8017dd:	5d                   	pop    %ebp
  8017de:	c3                   	ret    

008017df <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	83 ec 04             	sub    $0x4,%esp
  8017e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017eb:	eb 12                	jmp    8017ff <strchr+0x20>
		if (*s == c)
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	8a 00                	mov    (%eax),%al
  8017f2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017f5:	75 05                	jne    8017fc <strchr+0x1d>
			return (char *) s;
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	eb 11                	jmp    80180d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8017fc:	ff 45 08             	incl   0x8(%ebp)
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	8a 00                	mov    (%eax),%al
  801804:	84 c0                	test   %al,%al
  801806:	75 e5                	jne    8017ed <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801808:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	83 ec 04             	sub    $0x4,%esp
  801815:	8b 45 0c             	mov    0xc(%ebp),%eax
  801818:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80181b:	eb 0d                	jmp    80182a <strfind+0x1b>
		if (*s == c)
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	8a 00                	mov    (%eax),%al
  801822:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801825:	74 0e                	je     801835 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801827:	ff 45 08             	incl   0x8(%ebp)
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	8a 00                	mov    (%eax),%al
  80182f:	84 c0                	test   %al,%al
  801831:	75 ea                	jne    80181d <strfind+0xe>
  801833:	eb 01                	jmp    801836 <strfind+0x27>
		if (*s == c)
			break;
  801835:	90                   	nop
	return (char *) s;
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801847:	8b 45 10             	mov    0x10(%ebp),%eax
  80184a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80184d:	eb 0e                	jmp    80185d <memset+0x22>
		*p++ = c;
  80184f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801852:	8d 50 01             	lea    0x1(%eax),%edx
  801855:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801858:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80185d:	ff 4d f8             	decl   -0x8(%ebp)
  801860:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801864:	79 e9                	jns    80184f <memset+0x14>
		*p++ = c;

	return v;
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801871:	8b 45 0c             	mov    0xc(%ebp),%eax
  801874:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80187d:	eb 16                	jmp    801895 <memcpy+0x2a>
		*d++ = *s++;
  80187f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801882:	8d 50 01             	lea    0x1(%eax),%edx
  801885:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801888:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80188e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801891:	8a 12                	mov    (%edx),%dl
  801893:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801895:	8b 45 10             	mov    0x10(%ebp),%eax
  801898:	8d 50 ff             	lea    -0x1(%eax),%edx
  80189b:	89 55 10             	mov    %edx,0x10(%ebp)
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	75 dd                	jne    80187f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018bf:	73 50                	jae    801911 <memmove+0x6a>
  8018c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c7:	01 d0                	add    %edx,%eax
  8018c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018cc:	76 43                	jbe    801911 <memmove+0x6a>
		s += n;
  8018ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018da:	eb 10                	jmp    8018ec <memmove+0x45>
			*--d = *--s;
  8018dc:	ff 4d f8             	decl   -0x8(%ebp)
  8018df:	ff 4d fc             	decl   -0x4(%ebp)
  8018e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018e5:	8a 10                	mov    (%eax),%dl
  8018e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ea:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	75 e3                	jne    8018dc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018f9:	eb 23                	jmp    80191e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8018fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fe:	8d 50 01             	lea    0x1(%eax),%edx
  801901:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801904:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801907:	8d 4a 01             	lea    0x1(%edx),%ecx
  80190a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80190d:	8a 12                	mov    (%edx),%dl
  80190f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801911:	8b 45 10             	mov    0x10(%ebp),%eax
  801914:	8d 50 ff             	lea    -0x1(%eax),%edx
  801917:	89 55 10             	mov    %edx,0x10(%ebp)
  80191a:	85 c0                	test   %eax,%eax
  80191c:	75 dd                	jne    8018fb <memmove+0x54>
			*d++ = *s++;

	return dst;
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80192f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801932:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801935:	eb 2a                	jmp    801961 <memcmp+0x3e>
		if (*s1 != *s2)
  801937:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80193a:	8a 10                	mov    (%eax),%dl
  80193c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	38 c2                	cmp    %al,%dl
  801943:	74 16                	je     80195b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801945:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801948:	8a 00                	mov    (%eax),%al
  80194a:	0f b6 d0             	movzbl %al,%edx
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	8a 00                	mov    (%eax),%al
  801952:	0f b6 c0             	movzbl %al,%eax
  801955:	29 c2                	sub    %eax,%edx
  801957:	89 d0                	mov    %edx,%eax
  801959:	eb 18                	jmp    801973 <memcmp+0x50>
		s1++, s2++;
  80195b:	ff 45 fc             	incl   -0x4(%ebp)
  80195e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801961:	8b 45 10             	mov    0x10(%ebp),%eax
  801964:	8d 50 ff             	lea    -0x1(%eax),%edx
  801967:	89 55 10             	mov    %edx,0x10(%ebp)
  80196a:	85 c0                	test   %eax,%eax
  80196c:	75 c9                	jne    801937 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80196e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80197b:	8b 55 08             	mov    0x8(%ebp),%edx
  80197e:	8b 45 10             	mov    0x10(%ebp),%eax
  801981:	01 d0                	add    %edx,%eax
  801983:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801986:	eb 15                	jmp    80199d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	8a 00                	mov    (%eax),%al
  80198d:	0f b6 d0             	movzbl %al,%edx
  801990:	8b 45 0c             	mov    0xc(%ebp),%eax
  801993:	0f b6 c0             	movzbl %al,%eax
  801996:	39 c2                	cmp    %eax,%edx
  801998:	74 0d                	je     8019a7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80199a:	ff 45 08             	incl   0x8(%ebp)
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019a3:	72 e3                	jb     801988 <memfind+0x13>
  8019a5:	eb 01                	jmp    8019a8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019a7:	90                   	nop
	return (void *) s;
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019c1:	eb 03                	jmp    8019c6 <strtol+0x19>
		s++;
  8019c3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	3c 20                	cmp    $0x20,%al
  8019cd:	74 f4                	je     8019c3 <strtol+0x16>
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	8a 00                	mov    (%eax),%al
  8019d4:	3c 09                	cmp    $0x9,%al
  8019d6:	74 eb                	je     8019c3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	8a 00                	mov    (%eax),%al
  8019dd:	3c 2b                	cmp    $0x2b,%al
  8019df:	75 05                	jne    8019e6 <strtol+0x39>
		s++;
  8019e1:	ff 45 08             	incl   0x8(%ebp)
  8019e4:	eb 13                	jmp    8019f9 <strtol+0x4c>
	else if (*s == '-')
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	8a 00                	mov    (%eax),%al
  8019eb:	3c 2d                	cmp    $0x2d,%al
  8019ed:	75 0a                	jne    8019f9 <strtol+0x4c>
		s++, neg = 1;
  8019ef:	ff 45 08             	incl   0x8(%ebp)
  8019f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019fd:	74 06                	je     801a05 <strtol+0x58>
  8019ff:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a03:	75 20                	jne    801a25 <strtol+0x78>
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	8a 00                	mov    (%eax),%al
  801a0a:	3c 30                	cmp    $0x30,%al
  801a0c:	75 17                	jne    801a25 <strtol+0x78>
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	40                   	inc    %eax
  801a12:	8a 00                	mov    (%eax),%al
  801a14:	3c 78                	cmp    $0x78,%al
  801a16:	75 0d                	jne    801a25 <strtol+0x78>
		s += 2, base = 16;
  801a18:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a1c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a23:	eb 28                	jmp    801a4d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a29:	75 15                	jne    801a40 <strtol+0x93>
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	8a 00                	mov    (%eax),%al
  801a30:	3c 30                	cmp    $0x30,%al
  801a32:	75 0c                	jne    801a40 <strtol+0x93>
		s++, base = 8;
  801a34:	ff 45 08             	incl   0x8(%ebp)
  801a37:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a3e:	eb 0d                	jmp    801a4d <strtol+0xa0>
	else if (base == 0)
  801a40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a44:	75 07                	jne    801a4d <strtol+0xa0>
		base = 10;
  801a46:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	8a 00                	mov    (%eax),%al
  801a52:	3c 2f                	cmp    $0x2f,%al
  801a54:	7e 19                	jle    801a6f <strtol+0xc2>
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	8a 00                	mov    (%eax),%al
  801a5b:	3c 39                	cmp    $0x39,%al
  801a5d:	7f 10                	jg     801a6f <strtol+0xc2>
			dig = *s - '0';
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8a 00                	mov    (%eax),%al
  801a64:	0f be c0             	movsbl %al,%eax
  801a67:	83 e8 30             	sub    $0x30,%eax
  801a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a6d:	eb 42                	jmp    801ab1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	8a 00                	mov    (%eax),%al
  801a74:	3c 60                	cmp    $0x60,%al
  801a76:	7e 19                	jle    801a91 <strtol+0xe4>
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	8a 00                	mov    (%eax),%al
  801a7d:	3c 7a                	cmp    $0x7a,%al
  801a7f:	7f 10                	jg     801a91 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	0f be c0             	movsbl %al,%eax
  801a89:	83 e8 57             	sub    $0x57,%eax
  801a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a8f:	eb 20                	jmp    801ab1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	8a 00                	mov    (%eax),%al
  801a96:	3c 40                	cmp    $0x40,%al
  801a98:	7e 39                	jle    801ad3 <strtol+0x126>
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	8a 00                	mov    (%eax),%al
  801a9f:	3c 5a                	cmp    $0x5a,%al
  801aa1:	7f 30                	jg     801ad3 <strtol+0x126>
			dig = *s - 'A' + 10;
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	8a 00                	mov    (%eax),%al
  801aa8:	0f be c0             	movsbl %al,%eax
  801aab:	83 e8 37             	sub    $0x37,%eax
  801aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab4:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ab7:	7d 19                	jge    801ad2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801ab9:	ff 45 08             	incl   0x8(%ebp)
  801abc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abf:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ac3:	89 c2                	mov    %eax,%edx
  801ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac8:	01 d0                	add    %edx,%eax
  801aca:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801acd:	e9 7b ff ff ff       	jmp    801a4d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ad2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ad3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ad7:	74 08                	je     801ae1 <strtol+0x134>
		*endptr = (char *) s;
  801ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adc:	8b 55 08             	mov    0x8(%ebp),%edx
  801adf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801ae1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ae5:	74 07                	je     801aee <strtol+0x141>
  801ae7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aea:	f7 d8                	neg    %eax
  801aec:	eb 03                	jmp    801af1 <strtol+0x144>
  801aee:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <ltostr>:

void
ltostr(long value, char *str)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801af9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801b00:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b0b:	79 13                	jns    801b20 <ltostr+0x2d>
	{
		neg = 1;
  801b0d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b17:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b1a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b1d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b28:	99                   	cltd   
  801b29:	f7 f9                	idiv   %ecx
  801b2b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b31:	8d 50 01             	lea    0x1(%eax),%edx
  801b34:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b37:	89 c2                	mov    %eax,%edx
  801b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3c:	01 d0                	add    %edx,%eax
  801b3e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b41:	83 c2 30             	add    $0x30,%edx
  801b44:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b49:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b4e:	f7 e9                	imul   %ecx
  801b50:	c1 fa 02             	sar    $0x2,%edx
  801b53:	89 c8                	mov    %ecx,%eax
  801b55:	c1 f8 1f             	sar    $0x1f,%eax
  801b58:	29 c2                	sub    %eax,%edx
  801b5a:	89 d0                	mov    %edx,%eax
  801b5c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801b5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b62:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b67:	f7 e9                	imul   %ecx
  801b69:	c1 fa 02             	sar    $0x2,%edx
  801b6c:	89 c8                	mov    %ecx,%eax
  801b6e:	c1 f8 1f             	sar    $0x1f,%eax
  801b71:	29 c2                	sub    %eax,%edx
  801b73:	89 d0                	mov    %edx,%eax
  801b75:	c1 e0 02             	shl    $0x2,%eax
  801b78:	01 d0                	add    %edx,%eax
  801b7a:	01 c0                	add    %eax,%eax
  801b7c:	29 c1                	sub    %eax,%ecx
  801b7e:	89 ca                	mov    %ecx,%edx
  801b80:	85 d2                	test   %edx,%edx
  801b82:	75 9c                	jne    801b20 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b8e:	48                   	dec    %eax
  801b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b92:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b96:	74 3d                	je     801bd5 <ltostr+0xe2>
		start = 1 ;
  801b98:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b9f:	eb 34                	jmp    801bd5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801ba1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba7:	01 d0                	add    %edx,%eax
  801ba9:	8a 00                	mov    (%eax),%al
  801bab:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb4:	01 c2                	add    %eax,%edx
  801bb6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbc:	01 c8                	add    %ecx,%eax
  801bbe:	8a 00                	mov    (%eax),%al
  801bc0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801bc2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc8:	01 c2                	add    %eax,%edx
  801bca:	8a 45 eb             	mov    -0x15(%ebp),%al
  801bcd:	88 02                	mov    %al,(%edx)
		start++ ;
  801bcf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801bd2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bdb:	7c c4                	jl     801ba1 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801bdd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be3:	01 d0                	add    %edx,%eax
  801be5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801be8:	90                   	nop
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801bf1:	ff 75 08             	pushl  0x8(%ebp)
  801bf4:	e8 54 fa ff ff       	call   80164d <strlen>
  801bf9:	83 c4 04             	add    $0x4,%esp
  801bfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801bff:	ff 75 0c             	pushl  0xc(%ebp)
  801c02:	e8 46 fa ff ff       	call   80164d <strlen>
  801c07:	83 c4 04             	add    $0x4,%esp
  801c0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801c14:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c1b:	eb 17                	jmp    801c34 <strcconcat+0x49>
		final[s] = str1[s] ;
  801c1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c20:	8b 45 10             	mov    0x10(%ebp),%eax
  801c23:	01 c2                	add    %eax,%edx
  801c25:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	01 c8                	add    %ecx,%eax
  801c2d:	8a 00                	mov    (%eax),%al
  801c2f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c31:	ff 45 fc             	incl   -0x4(%ebp)
  801c34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c37:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c3a:	7c e1                	jl     801c1d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c3c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c43:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c4a:	eb 1f                	jmp    801c6b <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c4f:	8d 50 01             	lea    0x1(%eax),%edx
  801c52:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c55:	89 c2                	mov    %eax,%edx
  801c57:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5a:	01 c2                	add    %eax,%edx
  801c5c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c62:	01 c8                	add    %ecx,%eax
  801c64:	8a 00                	mov    (%eax),%al
  801c66:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c68:	ff 45 f8             	incl   -0x8(%ebp)
  801c6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c71:	7c d9                	jl     801c4c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c73:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c76:	8b 45 10             	mov    0x10(%ebp),%eax
  801c79:	01 d0                	add    %edx,%eax
  801c7b:	c6 00 00             	movb   $0x0,(%eax)
}
  801c7e:	90                   	nop
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c84:	8b 45 14             	mov    0x14(%ebp),%eax
  801c87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c90:	8b 00                	mov    (%eax),%eax
  801c92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c99:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9c:	01 d0                	add    %edx,%eax
  801c9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ca4:	eb 0c                	jmp    801cb2 <strsplit+0x31>
			*string++ = 0;
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	8d 50 01             	lea    0x1(%eax),%edx
  801cac:	89 55 08             	mov    %edx,0x8(%ebp)
  801caf:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	8a 00                	mov    (%eax),%al
  801cb7:	84 c0                	test   %al,%al
  801cb9:	74 18                	je     801cd3 <strsplit+0x52>
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	8a 00                	mov    (%eax),%al
  801cc0:	0f be c0             	movsbl %al,%eax
  801cc3:	50                   	push   %eax
  801cc4:	ff 75 0c             	pushl  0xc(%ebp)
  801cc7:	e8 13 fb ff ff       	call   8017df <strchr>
  801ccc:	83 c4 08             	add    $0x8,%esp
  801ccf:	85 c0                	test   %eax,%eax
  801cd1:	75 d3                	jne    801ca6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	8a 00                	mov    (%eax),%al
  801cd8:	84 c0                	test   %al,%al
  801cda:	74 5a                	je     801d36 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801cdc:	8b 45 14             	mov    0x14(%ebp),%eax
  801cdf:	8b 00                	mov    (%eax),%eax
  801ce1:	83 f8 0f             	cmp    $0xf,%eax
  801ce4:	75 07                	jne    801ced <strsplit+0x6c>
		{
			return 0;
  801ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ceb:	eb 66                	jmp    801d53 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ced:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf0:	8b 00                	mov    (%eax),%eax
  801cf2:	8d 48 01             	lea    0x1(%eax),%ecx
  801cf5:	8b 55 14             	mov    0x14(%ebp),%edx
  801cf8:	89 0a                	mov    %ecx,(%edx)
  801cfa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d01:	8b 45 10             	mov    0x10(%ebp),%eax
  801d04:	01 c2                	add    %eax,%edx
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d0b:	eb 03                	jmp    801d10 <strsplit+0x8f>
			string++;
  801d0d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	8a 00                	mov    (%eax),%al
  801d15:	84 c0                	test   %al,%al
  801d17:	74 8b                	je     801ca4 <strsplit+0x23>
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	8a 00                	mov    (%eax),%al
  801d1e:	0f be c0             	movsbl %al,%eax
  801d21:	50                   	push   %eax
  801d22:	ff 75 0c             	pushl  0xc(%ebp)
  801d25:	e8 b5 fa ff ff       	call   8017df <strchr>
  801d2a:	83 c4 08             	add    $0x8,%esp
  801d2d:	85 c0                	test   %eax,%eax
  801d2f:	74 dc                	je     801d0d <strsplit+0x8c>
			string++;
	}
  801d31:	e9 6e ff ff ff       	jmp    801ca4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d36:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d37:	8b 45 14             	mov    0x14(%ebp),%eax
  801d3a:	8b 00                	mov    (%eax),%eax
  801d3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d43:	8b 45 10             	mov    0x10(%ebp),%eax
  801d46:	01 d0                	add    %edx,%eax
  801d48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d4e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801d5b:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801d62:	8b 55 08             	mov    0x8(%ebp),%edx
  801d65:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801d68:	01 d0                	add    %edx,%eax
  801d6a:	48                   	dec    %eax
  801d6b:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801d6e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801d71:	ba 00 00 00 00       	mov    $0x0,%edx
  801d76:	f7 75 ac             	divl   -0x54(%ebp)
  801d79:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801d7c:	29 d0                	sub    %edx,%eax
  801d7e:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801d81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801d88:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801d8f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801d96:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801d9d:	eb 3f                	jmp    801dde <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801d9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801da2:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801da9:	83 ec 04             	sub    $0x4,%esp
  801dac:	50                   	push   %eax
  801dad:	ff 75 e8             	pushl  -0x18(%ebp)
  801db0:	68 10 33 80 00       	push   $0x803310
  801db5:	e8 11 f2 ff ff       	call   800fcb <cprintf>
  801dba:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dc0:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801dc7:	83 ec 04             	sub    $0x4,%esp
  801dca:	50                   	push   %eax
  801dcb:	ff 75 e8             	pushl  -0x18(%ebp)
  801dce:	68 25 33 80 00       	push   $0x803325
  801dd3:	e8 f3 f1 ff ff       	call   800fcb <cprintf>
  801dd8:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801ddb:	ff 45 e8             	incl   -0x18(%ebp)
  801dde:	a1 28 40 80 00       	mov    0x804028,%eax
  801de3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801de6:	7c b7                	jl     801d9f <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801de8:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801def:	e9 42 01 00 00       	jmp    801f36 <malloc+0x1e1>
		int flag0=1;
  801df4:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dfe:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e01:	eb 6b                	jmp    801e6e <malloc+0x119>
			for(int k=0;k<count;k++){
  801e03:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801e0a:	eb 42                	jmp    801e4e <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801e0c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e0f:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801e16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e19:	39 c2                	cmp    %eax,%edx
  801e1b:	77 2e                	ja     801e4b <malloc+0xf6>
  801e1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e20:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801e27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e2a:	39 c2                	cmp    %eax,%edx
  801e2c:	76 1d                	jbe    801e4b <malloc+0xf6>
					ni=arr_add[k].end-i;
  801e2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e31:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801e38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e3b:	29 c2                	sub    %eax,%edx
  801e3d:	89 d0                	mov    %edx,%eax
  801e3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801e42:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801e49:	eb 0d                	jmp    801e58 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801e4b:	ff 45 d8             	incl   -0x28(%ebp)
  801e4e:	a1 28 40 80 00       	mov    0x804028,%eax
  801e53:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801e56:	7c b4                	jl     801e0c <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801e58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e5c:	74 09                	je     801e67 <malloc+0x112>
				flag0=0;
  801e5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801e65:	eb 16                	jmp    801e7d <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801e67:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801e6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	01 c2                	add    %eax,%edx
  801e76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e79:	39 c2                	cmp    %eax,%edx
  801e7b:	77 86                	ja     801e03 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801e7d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e81:	0f 84 a2 00 00 00    	je     801f29 <malloc+0x1d4>

			int f=1;
  801e87:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801e8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e91:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e94:	89 c8                	mov    %ecx,%eax
  801e96:	01 c0                	add    %eax,%eax
  801e98:	01 c8                	add    %ecx,%eax
  801e9a:	c1 e0 02             	shl    $0x2,%eax
  801e9d:	05 20 41 80 00       	add    $0x804120,%eax
  801ea2:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801ea4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb0:	89 d0                	mov    %edx,%eax
  801eb2:	01 c0                	add    %eax,%eax
  801eb4:	01 d0                	add    %edx,%eax
  801eb6:	c1 e0 02             	shl    $0x2,%eax
  801eb9:	05 24 41 80 00       	add    $0x804124,%eax
  801ebe:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801ec0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec3:	89 d0                	mov    %edx,%eax
  801ec5:	01 c0                	add    %eax,%eax
  801ec7:	01 d0                	add    %edx,%eax
  801ec9:	c1 e0 02             	shl    $0x2,%eax
  801ecc:	05 28 41 80 00       	add    $0x804128,%eax
  801ed1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801ed7:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801eda:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801ee1:	eb 36                	jmp    801f19 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801ee3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	01 c2                	add    %eax,%edx
  801eeb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801eee:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801ef5:	39 c2                	cmp    %eax,%edx
  801ef7:	73 1d                	jae    801f16 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801ef9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801efc:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f06:	29 c2                	sub    %eax,%edx
  801f08:	89 d0                	mov    %edx,%eax
  801f0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801f0d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801f14:	eb 0d                	jmp    801f23 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801f16:	ff 45 d0             	incl   -0x30(%ebp)
  801f19:	a1 28 40 80 00       	mov    0x804028,%eax
  801f1e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801f21:	7c c0                	jl     801ee3 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801f23:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801f27:	75 1d                	jne    801f46 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801f29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801f30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f33:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801f36:	a1 04 40 80 00       	mov    0x804004,%eax
  801f3b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f3e:	0f 8c b0 fe ff ff    	jl     801df4 <malloc+0x9f>
  801f44:	eb 01                	jmp    801f47 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801f46:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801f47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4b:	75 7a                	jne    801fc7 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801f4d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	01 d0                	add    %edx,%eax
  801f58:	48                   	dec    %eax
  801f59:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801f5e:	7c 0a                	jl     801f6a <malloc+0x215>
			return NULL;
  801f60:	b8 00 00 00 00       	mov    $0x0,%eax
  801f65:	e9 a4 02 00 00       	jmp    80220e <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801f6a:	a1 04 40 80 00       	mov    0x804004,%eax
  801f6f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801f72:	a1 28 40 80 00       	mov    0x804028,%eax
  801f77:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801f7a:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801f81:	83 ec 08             	sub    $0x8,%esp
  801f84:	ff 75 08             	pushl  0x8(%ebp)
  801f87:	ff 75 a4             	pushl  -0x5c(%ebp)
  801f8a:	e8 04 06 00 00       	call   802593 <sys_allocateMem>
  801f8f:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801f92:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	01 d0                	add    %edx,%eax
  801f9d:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801fa2:	a1 28 40 80 00       	mov    0x804028,%eax
  801fa7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801fad:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801fb4:	a1 28 40 80 00       	mov    0x804028,%eax
  801fb9:	40                   	inc    %eax
  801fba:	a3 28 40 80 00       	mov    %eax,0x804028

			return (void*)s;
  801fbf:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801fc2:	e9 47 02 00 00       	jmp    80220e <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801fc7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801fce:	e9 ac 00 00 00       	jmp    80207f <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801fd3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801fd6:	89 d0                	mov    %edx,%eax
  801fd8:	01 c0                	add    %eax,%eax
  801fda:	01 d0                	add    %edx,%eax
  801fdc:	c1 e0 02             	shl    $0x2,%eax
  801fdf:	05 24 41 80 00       	add    $0x804124,%eax
  801fe4:	8b 00                	mov    (%eax),%eax
  801fe6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801fe9:	eb 7e                	jmp    802069 <malloc+0x314>
			int flag=0;
  801feb:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801ff2:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801ff9:	eb 57                	jmp    802052 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801ffb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ffe:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  802005:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802008:	39 c2                	cmp    %eax,%edx
  80200a:	77 1a                	ja     802026 <malloc+0x2d1>
  80200c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80200f:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  802016:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802019:	39 c2                	cmp    %eax,%edx
  80201b:	76 09                	jbe    802026 <malloc+0x2d1>
								flag=1;
  80201d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  802024:	eb 36                	jmp    80205c <malloc+0x307>
			arr[i].space++;
  802026:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802029:	89 d0                	mov    %edx,%eax
  80202b:	01 c0                	add    %eax,%eax
  80202d:	01 d0                	add    %edx,%eax
  80202f:	c1 e0 02             	shl    $0x2,%eax
  802032:	05 28 41 80 00       	add    $0x804128,%eax
  802037:	8b 00                	mov    (%eax),%eax
  802039:	8d 48 01             	lea    0x1(%eax),%ecx
  80203c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80203f:	89 d0                	mov    %edx,%eax
  802041:	01 c0                	add    %eax,%eax
  802043:	01 d0                	add    %edx,%eax
  802045:	c1 e0 02             	shl    $0x2,%eax
  802048:	05 28 41 80 00       	add    $0x804128,%eax
  80204d:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  80204f:	ff 45 c0             	incl   -0x40(%ebp)
  802052:	a1 28 40 80 00       	mov    0x804028,%eax
  802057:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  80205a:	7c 9f                	jl     801ffb <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  80205c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  802060:	75 19                	jne    80207b <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  802062:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  802069:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80206c:	a1 04 40 80 00       	mov    0x804004,%eax
  802071:	39 c2                	cmp    %eax,%edx
  802073:	0f 82 72 ff ff ff    	jb     801feb <malloc+0x296>
  802079:	eb 01                	jmp    80207c <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  80207b:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  80207c:	ff 45 cc             	incl   -0x34(%ebp)
  80207f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802082:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802085:	0f 8c 48 ff ff ff    	jl     801fd3 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  80208b:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  802092:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  802099:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  8020a0:	eb 37                	jmp    8020d9 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  8020a2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8020a5:	89 d0                	mov    %edx,%eax
  8020a7:	01 c0                	add    %eax,%eax
  8020a9:	01 d0                	add    %edx,%eax
  8020ab:	c1 e0 02             	shl    $0x2,%eax
  8020ae:	05 28 41 80 00       	add    $0x804128,%eax
  8020b3:	8b 00                	mov    (%eax),%eax
  8020b5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020b8:	7d 1c                	jge    8020d6 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  8020ba:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8020bd:	89 d0                	mov    %edx,%eax
  8020bf:	01 c0                	add    %eax,%eax
  8020c1:	01 d0                	add    %edx,%eax
  8020c3:	c1 e0 02             	shl    $0x2,%eax
  8020c6:	05 28 41 80 00       	add    $0x804128,%eax
  8020cb:	8b 00                	mov    (%eax),%eax
  8020cd:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  8020d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8020d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  8020d6:	ff 45 b4             	incl   -0x4c(%ebp)
  8020d9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8020dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8020df:	7c c1                	jl     8020a2 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  8020e1:	8b 15 28 40 80 00    	mov    0x804028,%edx
  8020e7:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8020ea:	89 c8                	mov    %ecx,%eax
  8020ec:	01 c0                	add    %eax,%eax
  8020ee:	01 c8                	add    %ecx,%eax
  8020f0:	c1 e0 02             	shl    $0x2,%eax
  8020f3:	05 20 41 80 00       	add    $0x804120,%eax
  8020f8:	8b 00                	mov    (%eax),%eax
  8020fa:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  802101:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802107:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  80210a:	89 c8                	mov    %ecx,%eax
  80210c:	01 c0                	add    %eax,%eax
  80210e:	01 c8                	add    %ecx,%eax
  802110:	c1 e0 02             	shl    $0x2,%eax
  802113:	05 24 41 80 00       	add    $0x804124,%eax
  802118:	8b 00                	mov    (%eax),%eax
  80211a:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  802121:	a1 28 40 80 00       	mov    0x804028,%eax
  802126:	40                   	inc    %eax
  802127:	a3 28 40 80 00       	mov    %eax,0x804028


		sys_allocateMem(arr[index].start,size);
  80212c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80212f:	89 d0                	mov    %edx,%eax
  802131:	01 c0                	add    %eax,%eax
  802133:	01 d0                	add    %edx,%eax
  802135:	c1 e0 02             	shl    $0x2,%eax
  802138:	05 20 41 80 00       	add    $0x804120,%eax
  80213d:	8b 00                	mov    (%eax),%eax
  80213f:	83 ec 08             	sub    $0x8,%esp
  802142:	ff 75 08             	pushl  0x8(%ebp)
  802145:	50                   	push   %eax
  802146:	e8 48 04 00 00       	call   802593 <sys_allocateMem>
  80214b:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  80214e:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  802155:	eb 78                	jmp    8021cf <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  802157:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80215a:	89 d0                	mov    %edx,%eax
  80215c:	01 c0                	add    %eax,%eax
  80215e:	01 d0                	add    %edx,%eax
  802160:	c1 e0 02             	shl    $0x2,%eax
  802163:	05 20 41 80 00       	add    $0x804120,%eax
  802168:	8b 00                	mov    (%eax),%eax
  80216a:	83 ec 04             	sub    $0x4,%esp
  80216d:	50                   	push   %eax
  80216e:	ff 75 b0             	pushl  -0x50(%ebp)
  802171:	68 10 33 80 00       	push   $0x803310
  802176:	e8 50 ee ff ff       	call   800fcb <cprintf>
  80217b:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  80217e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802181:	89 d0                	mov    %edx,%eax
  802183:	01 c0                	add    %eax,%eax
  802185:	01 d0                	add    %edx,%eax
  802187:	c1 e0 02             	shl    $0x2,%eax
  80218a:	05 24 41 80 00       	add    $0x804124,%eax
  80218f:	8b 00                	mov    (%eax),%eax
  802191:	83 ec 04             	sub    $0x4,%esp
  802194:	50                   	push   %eax
  802195:	ff 75 b0             	pushl  -0x50(%ebp)
  802198:	68 25 33 80 00       	push   $0x803325
  80219d:	e8 29 ee ff ff       	call   800fcb <cprintf>
  8021a2:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  8021a5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021a8:	89 d0                	mov    %edx,%eax
  8021aa:	01 c0                	add    %eax,%eax
  8021ac:	01 d0                	add    %edx,%eax
  8021ae:	c1 e0 02             	shl    $0x2,%eax
  8021b1:	05 28 41 80 00       	add    $0x804128,%eax
  8021b6:	8b 00                	mov    (%eax),%eax
  8021b8:	83 ec 04             	sub    $0x4,%esp
  8021bb:	50                   	push   %eax
  8021bc:	ff 75 b0             	pushl  -0x50(%ebp)
  8021bf:	68 38 33 80 00       	push   $0x803338
  8021c4:	e8 02 ee ff ff       	call   800fcb <cprintf>
  8021c9:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  8021cc:	ff 45 b0             	incl   -0x50(%ebp)
  8021cf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021d5:	7c 80                	jl     802157 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  8021d7:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8021da:	89 d0                	mov    %edx,%eax
  8021dc:	01 c0                	add    %eax,%eax
  8021de:	01 d0                	add    %edx,%eax
  8021e0:	c1 e0 02             	shl    $0x2,%eax
  8021e3:	05 20 41 80 00       	add    $0x804120,%eax
  8021e8:	8b 00                	mov    (%eax),%eax
  8021ea:	83 ec 08             	sub    $0x8,%esp
  8021ed:	50                   	push   %eax
  8021ee:	68 4c 33 80 00       	push   $0x80334c
  8021f3:	e8 d3 ed ff ff       	call   800fcb <cprintf>
  8021f8:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  8021fb:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8021fe:	89 d0                	mov    %edx,%eax
  802200:	01 c0                	add    %eax,%eax
  802202:	01 d0                	add    %edx,%eax
  802204:	c1 e0 02             	shl    $0x2,%eax
  802207:	05 20 41 80 00       	add    $0x804120,%eax
  80220c:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
  802213:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  80221c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802223:	eb 4b                	jmp    802270 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  802225:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802228:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  80222f:	89 c2                	mov    %eax,%edx
  802231:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802234:	39 c2                	cmp    %eax,%edx
  802236:	7f 35                	jg     80226d <free+0x5d>
  802238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223b:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  802242:	89 c2                	mov    %eax,%edx
  802244:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802247:	39 c2                	cmp    %eax,%edx
  802249:	7e 22                	jle    80226d <free+0x5d>
				start=arr_add[i].start;
  80224b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224e:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  802255:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  802258:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225b:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  802262:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  802265:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802268:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  80226b:	eb 0d                	jmp    80227a <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  80226d:	ff 45 ec             	incl   -0x14(%ebp)
  802270:	a1 28 40 80 00       	mov    0x804028,%eax
  802275:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802278:	7c ab                	jl     802225 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  80227a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227d:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  802284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802287:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  80228e:	29 c2                	sub    %eax,%edx
  802290:	89 d0                	mov    %edx,%eax
  802292:	83 ec 08             	sub    $0x8,%esp
  802295:	50                   	push   %eax
  802296:	ff 75 f4             	pushl  -0xc(%ebp)
  802299:	e8 d9 02 00 00       	call   802577 <sys_freeMem>
  80229e:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  8022a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022a7:	eb 2d                	jmp    8022d6 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  8022a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ac:	40                   	inc    %eax
  8022ad:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  8022b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b7:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  8022be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022c1:	40                   	inc    %eax
  8022c2:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  8022c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022cc:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  8022d3:	ff 45 e8             	incl   -0x18(%ebp)
  8022d6:	a1 28 40 80 00       	mov    0x804028,%eax
  8022db:	48                   	dec    %eax
  8022dc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8022df:	7f c8                	jg     8022a9 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  8022e1:	a1 28 40 80 00       	mov    0x804028,%eax
  8022e6:	48                   	dec    %eax
  8022e7:	a3 28 40 80 00       	mov    %eax,0x804028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  8022ec:	90                   	nop
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    

008022ef <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
  8022f2:	83 ec 18             	sub    $0x18,%esp
  8022f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f8:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8022fb:	83 ec 04             	sub    $0x4,%esp
  8022fe:	68 68 33 80 00       	push   $0x803368
  802303:	68 18 01 00 00       	push   $0x118
  802308:	68 8b 33 80 00       	push   $0x80338b
  80230d:	e8 17 ea ff ff       	call   800d29 <_panic>

00802312 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
  802315:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802318:	83 ec 04             	sub    $0x4,%esp
  80231b:	68 68 33 80 00       	push   $0x803368
  802320:	68 1e 01 00 00       	push   $0x11e
  802325:	68 8b 33 80 00       	push   $0x80338b
  80232a:	e8 fa e9 ff ff       	call   800d29 <_panic>

0080232f <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802335:	83 ec 04             	sub    $0x4,%esp
  802338:	68 68 33 80 00       	push   $0x803368
  80233d:	68 24 01 00 00       	push   $0x124
  802342:	68 8b 33 80 00       	push   $0x80338b
  802347:	e8 dd e9 ff ff       	call   800d29 <_panic>

0080234c <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802352:	83 ec 04             	sub    $0x4,%esp
  802355:	68 68 33 80 00       	push   $0x803368
  80235a:	68 29 01 00 00       	push   $0x129
  80235f:	68 8b 33 80 00       	push   $0x80338b
  802364:	e8 c0 e9 ff ff       	call   800d29 <_panic>

00802369 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
  80236c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80236f:	83 ec 04             	sub    $0x4,%esp
  802372:	68 68 33 80 00       	push   $0x803368
  802377:	68 2f 01 00 00       	push   $0x12f
  80237c:	68 8b 33 80 00       	push   $0x80338b
  802381:	e8 a3 e9 ff ff       	call   800d29 <_panic>

00802386 <shrink>:
}
void shrink(uint32 newSize)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80238c:	83 ec 04             	sub    $0x4,%esp
  80238f:	68 68 33 80 00       	push   $0x803368
  802394:	68 33 01 00 00       	push   $0x133
  802399:	68 8b 33 80 00       	push   $0x80338b
  80239e:	e8 86 e9 ff ff       	call   800d29 <_panic>

008023a3 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8023a9:	83 ec 04             	sub    $0x4,%esp
  8023ac:	68 68 33 80 00       	push   $0x803368
  8023b1:	68 38 01 00 00       	push   $0x138
  8023b6:	68 8b 33 80 00       	push   $0x80338b
  8023bb:	e8 69 e9 ff ff       	call   800d29 <_panic>

008023c0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
  8023c3:	57                   	push   %edi
  8023c4:	56                   	push   %esi
  8023c5:	53                   	push   %ebx
  8023c6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023d5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8023d8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8023db:	cd 30                	int    $0x30
  8023dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8023e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8023e3:	83 c4 10             	add    $0x10,%esp
  8023e6:	5b                   	pop    %ebx
  8023e7:	5e                   	pop    %esi
  8023e8:	5f                   	pop    %edi
  8023e9:	5d                   	pop    %ebp
  8023ea:	c3                   	ret    

008023eb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	83 ec 04             	sub    $0x4,%esp
  8023f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8023f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8023f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	52                   	push   %edx
  802403:	ff 75 0c             	pushl  0xc(%ebp)
  802406:	50                   	push   %eax
  802407:	6a 00                	push   $0x0
  802409:	e8 b2 ff ff ff       	call   8023c0 <syscall>
  80240e:	83 c4 18             	add    $0x18,%esp
}
  802411:	90                   	nop
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <sys_cgetc>:

int
sys_cgetc(void)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 01                	push   $0x1
  802423:	e8 98 ff ff ff       	call   8023c0 <syscall>
  802428:	83 c4 18             	add    $0x18,%esp
}
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    

0080242d <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	50                   	push   %eax
  80243c:	6a 05                	push   $0x5
  80243e:	e8 7d ff ff ff       	call   8023c0 <syscall>
  802443:	83 c4 18             	add    $0x18,%esp
}
  802446:	c9                   	leave  
  802447:	c3                   	ret    

00802448 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802448:	55                   	push   %ebp
  802449:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 02                	push   $0x2
  802457:	e8 64 ff ff ff       	call   8023c0 <syscall>
  80245c:	83 c4 18             	add    $0x18,%esp
}
  80245f:	c9                   	leave  
  802460:	c3                   	ret    

00802461 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 03                	push   $0x3
  802470:	e8 4b ff ff ff       	call   8023c0 <syscall>
  802475:	83 c4 18             	add    $0x18,%esp
}
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 04                	push   $0x4
  802489:	e8 32 ff ff ff       	call   8023c0 <syscall>
  80248e:	83 c4 18             	add    $0x18,%esp
}
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <sys_env_exit>:


void sys_env_exit(void)
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 06                	push   $0x6
  8024a2:	e8 19 ff ff ff       	call   8023c0 <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
}
  8024aa:	90                   	nop
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8024b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	52                   	push   %edx
  8024bd:	50                   	push   %eax
  8024be:	6a 07                	push   $0x7
  8024c0:	e8 fb fe ff ff       	call   8023c0 <syscall>
  8024c5:	83 c4 18             	add    $0x18,%esp
}
  8024c8:	c9                   	leave  
  8024c9:	c3                   	ret    

008024ca <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
  8024cd:	56                   	push   %esi
  8024ce:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8024cf:	8b 75 18             	mov    0x18(%ebp),%esi
  8024d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	56                   	push   %esi
  8024df:	53                   	push   %ebx
  8024e0:	51                   	push   %ecx
  8024e1:	52                   	push   %edx
  8024e2:	50                   	push   %eax
  8024e3:	6a 08                	push   $0x8
  8024e5:	e8 d6 fe ff ff       	call   8023c0 <syscall>
  8024ea:	83 c4 18             	add    $0x18,%esp
}
  8024ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024f0:	5b                   	pop    %ebx
  8024f1:	5e                   	pop    %esi
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    

008024f4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8024f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	52                   	push   %edx
  802504:	50                   	push   %eax
  802505:	6a 09                	push   $0x9
  802507:	e8 b4 fe ff ff       	call   8023c0 <syscall>
  80250c:	83 c4 18             	add    $0x18,%esp
}
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	ff 75 0c             	pushl  0xc(%ebp)
  80251d:	ff 75 08             	pushl  0x8(%ebp)
  802520:	6a 0a                	push   $0xa
  802522:	e8 99 fe ff ff       	call   8023c0 <syscall>
  802527:	83 c4 18             	add    $0x18,%esp
}
  80252a:	c9                   	leave  
  80252b:	c3                   	ret    

0080252c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 0b                	push   $0xb
  80253b:	e8 80 fe ff ff       	call   8023c0 <syscall>
  802540:	83 c4 18             	add    $0x18,%esp
}
  802543:	c9                   	leave  
  802544:	c3                   	ret    

00802545 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802545:	55                   	push   %ebp
  802546:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 0c                	push   $0xc
  802554:	e8 67 fe ff ff       	call   8023c0 <syscall>
  802559:	83 c4 18             	add    $0x18,%esp
}
  80255c:	c9                   	leave  
  80255d:	c3                   	ret    

0080255e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 0d                	push   $0xd
  80256d:	e8 4e fe ff ff       	call   8023c0 <syscall>
  802572:	83 c4 18             	add    $0x18,%esp
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	ff 75 0c             	pushl  0xc(%ebp)
  802583:	ff 75 08             	pushl  0x8(%ebp)
  802586:	6a 11                	push   $0x11
  802588:	e8 33 fe ff ff       	call   8023c0 <syscall>
  80258d:	83 c4 18             	add    $0x18,%esp
	return;
  802590:	90                   	nop
}
  802591:	c9                   	leave  
  802592:	c3                   	ret    

00802593 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	ff 75 0c             	pushl  0xc(%ebp)
  80259f:	ff 75 08             	pushl  0x8(%ebp)
  8025a2:	6a 12                	push   $0x12
  8025a4:	e8 17 fe ff ff       	call   8023c0 <syscall>
  8025a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ac:	90                   	nop
}
  8025ad:	c9                   	leave  
  8025ae:	c3                   	ret    

008025af <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 0e                	push   $0xe
  8025be:	e8 fd fd ff ff       	call   8023c0 <syscall>
  8025c3:	83 c4 18             	add    $0x18,%esp
}
  8025c6:	c9                   	leave  
  8025c7:	c3                   	ret    

008025c8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	ff 75 08             	pushl  0x8(%ebp)
  8025d6:	6a 0f                	push   $0xf
  8025d8:	e8 e3 fd ff ff       	call   8023c0 <syscall>
  8025dd:	83 c4 18             	add    $0x18,%esp
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 10                	push   $0x10
  8025f1:	e8 ca fd ff ff       	call   8023c0 <syscall>
  8025f6:	83 c4 18             	add    $0x18,%esp
}
  8025f9:	90                   	nop
  8025fa:	c9                   	leave  
  8025fb:	c3                   	ret    

008025fc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	6a 14                	push   $0x14
  80260b:	e8 b0 fd ff ff       	call   8023c0 <syscall>
  802610:	83 c4 18             	add    $0x18,%esp
}
  802613:	90                   	nop
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 15                	push   $0x15
  802625:	e8 96 fd ff ff       	call   8023c0 <syscall>
  80262a:	83 c4 18             	add    $0x18,%esp
}
  80262d:	90                   	nop
  80262e:	c9                   	leave  
  80262f:	c3                   	ret    

00802630 <sys_cputc>:


void
sys_cputc(const char c)
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	83 ec 04             	sub    $0x4,%esp
  802636:	8b 45 08             	mov    0x8(%ebp),%eax
  802639:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80263c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	6a 00                	push   $0x0
  802648:	50                   	push   %eax
  802649:	6a 16                	push   $0x16
  80264b:	e8 70 fd ff ff       	call   8023c0 <syscall>
  802650:	83 c4 18             	add    $0x18,%esp
}
  802653:	90                   	nop
  802654:	c9                   	leave  
  802655:	c3                   	ret    

00802656 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 17                	push   $0x17
  802665:	e8 56 fd ff ff       	call   8023c0 <syscall>
  80266a:	83 c4 18             	add    $0x18,%esp
}
  80266d:	90                   	nop
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802673:	8b 45 08             	mov    0x8(%ebp),%eax
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	ff 75 0c             	pushl  0xc(%ebp)
  80267f:	50                   	push   %eax
  802680:	6a 18                	push   $0x18
  802682:	e8 39 fd ff ff       	call   8023c0 <syscall>
  802687:	83 c4 18             	add    $0x18,%esp
}
  80268a:	c9                   	leave  
  80268b:	c3                   	ret    

0080268c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80268c:	55                   	push   %ebp
  80268d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80268f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802692:	8b 45 08             	mov    0x8(%ebp),%eax
  802695:	6a 00                	push   $0x0
  802697:	6a 00                	push   $0x0
  802699:	6a 00                	push   $0x0
  80269b:	52                   	push   %edx
  80269c:	50                   	push   %eax
  80269d:	6a 1b                	push   $0x1b
  80269f:	e8 1c fd ff ff       	call   8023c0 <syscall>
  8026a4:	83 c4 18             	add    $0x18,%esp
}
  8026a7:	c9                   	leave  
  8026a8:	c3                   	ret    

008026a9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026a9:	55                   	push   %ebp
  8026aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	52                   	push   %edx
  8026b9:	50                   	push   %eax
  8026ba:	6a 19                	push   $0x19
  8026bc:	e8 ff fc ff ff       	call   8023c0 <syscall>
  8026c1:	83 c4 18             	add    $0x18,%esp
}
  8026c4:	90                   	nop
  8026c5:	c9                   	leave  
  8026c6:	c3                   	ret    

008026c7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	52                   	push   %edx
  8026d7:	50                   	push   %eax
  8026d8:	6a 1a                	push   $0x1a
  8026da:	e8 e1 fc ff ff       	call   8023c0 <syscall>
  8026df:	83 c4 18             	add    $0x18,%esp
}
  8026e2:	90                   	nop
  8026e3:	c9                   	leave  
  8026e4:	c3                   	ret    

008026e5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
  8026e8:	83 ec 04             	sub    $0x4,%esp
  8026eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8026f1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026f4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	6a 00                	push   $0x0
  8026fd:	51                   	push   %ecx
  8026fe:	52                   	push   %edx
  8026ff:	ff 75 0c             	pushl  0xc(%ebp)
  802702:	50                   	push   %eax
  802703:	6a 1c                	push   $0x1c
  802705:	e8 b6 fc ff ff       	call   8023c0 <syscall>
  80270a:	83 c4 18             	add    $0x18,%esp
}
  80270d:	c9                   	leave  
  80270e:	c3                   	ret    

0080270f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802712:	8b 55 0c             	mov    0xc(%ebp),%edx
  802715:	8b 45 08             	mov    0x8(%ebp),%eax
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	52                   	push   %edx
  80271f:	50                   	push   %eax
  802720:	6a 1d                	push   $0x1d
  802722:	e8 99 fc ff ff       	call   8023c0 <syscall>
  802727:	83 c4 18             	add    $0x18,%esp
}
  80272a:	c9                   	leave  
  80272b:	c3                   	ret    

0080272c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80272f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802732:	8b 55 0c             	mov    0xc(%ebp),%edx
  802735:	8b 45 08             	mov    0x8(%ebp),%eax
  802738:	6a 00                	push   $0x0
  80273a:	6a 00                	push   $0x0
  80273c:	51                   	push   %ecx
  80273d:	52                   	push   %edx
  80273e:	50                   	push   %eax
  80273f:	6a 1e                	push   $0x1e
  802741:	e8 7a fc ff ff       	call   8023c0 <syscall>
  802746:	83 c4 18             	add    $0x18,%esp
}
  802749:	c9                   	leave  
  80274a:	c3                   	ret    

0080274b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80274b:	55                   	push   %ebp
  80274c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80274e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	52                   	push   %edx
  80275b:	50                   	push   %eax
  80275c:	6a 1f                	push   $0x1f
  80275e:	e8 5d fc ff ff       	call   8023c0 <syscall>
  802763:	83 c4 18             	add    $0x18,%esp
}
  802766:	c9                   	leave  
  802767:	c3                   	ret    

00802768 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	6a 20                	push   $0x20
  802777:	e8 44 fc ff ff       	call   8023c0 <syscall>
  80277c:	83 c4 18             	add    $0x18,%esp
}
  80277f:	c9                   	leave  
  802780:	c3                   	ret    

00802781 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802781:	55                   	push   %ebp
  802782:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802784:	8b 45 08             	mov    0x8(%ebp),%eax
  802787:	6a 00                	push   $0x0
  802789:	ff 75 14             	pushl  0x14(%ebp)
  80278c:	ff 75 10             	pushl  0x10(%ebp)
  80278f:	ff 75 0c             	pushl  0xc(%ebp)
  802792:	50                   	push   %eax
  802793:	6a 21                	push   $0x21
  802795:	e8 26 fc ff ff       	call   8023c0 <syscall>
  80279a:	83 c4 18             	add    $0x18,%esp
}
  80279d:	c9                   	leave  
  80279e:	c3                   	ret    

0080279f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80279f:	55                   	push   %ebp
  8027a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8027a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	50                   	push   %eax
  8027ae:	6a 22                	push   $0x22
  8027b0:	e8 0b fc ff ff       	call   8023c0 <syscall>
  8027b5:	83 c4 18             	add    $0x18,%esp
}
  8027b8:	90                   	nop
  8027b9:	c9                   	leave  
  8027ba:	c3                   	ret    

008027bb <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8027be:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 00                	push   $0x0
  8027c9:	50                   	push   %eax
  8027ca:	6a 23                	push   $0x23
  8027cc:	e8 ef fb ff ff       	call   8023c0 <syscall>
  8027d1:	83 c4 18             	add    $0x18,%esp
}
  8027d4:	90                   	nop
  8027d5:	c9                   	leave  
  8027d6:	c3                   	ret    

008027d7 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8027d7:	55                   	push   %ebp
  8027d8:	89 e5                	mov    %esp,%ebp
  8027da:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8027dd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8027e0:	8d 50 04             	lea    0x4(%eax),%edx
  8027e3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8027e6:	6a 00                	push   $0x0
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 00                	push   $0x0
  8027ec:	52                   	push   %edx
  8027ed:	50                   	push   %eax
  8027ee:	6a 24                	push   $0x24
  8027f0:	e8 cb fb ff ff       	call   8023c0 <syscall>
  8027f5:	83 c4 18             	add    $0x18,%esp
	return result;
  8027f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802801:	89 01                	mov    %eax,(%ecx)
  802803:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	c9                   	leave  
  80280a:	c2 04 00             	ret    $0x4

0080280d <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802810:	6a 00                	push   $0x0
  802812:	6a 00                	push   $0x0
  802814:	ff 75 10             	pushl  0x10(%ebp)
  802817:	ff 75 0c             	pushl  0xc(%ebp)
  80281a:	ff 75 08             	pushl  0x8(%ebp)
  80281d:	6a 13                	push   $0x13
  80281f:	e8 9c fb ff ff       	call   8023c0 <syscall>
  802824:	83 c4 18             	add    $0x18,%esp
	return ;
  802827:	90                   	nop
}
  802828:	c9                   	leave  
  802829:	c3                   	ret    

0080282a <sys_rcr2>:
uint32 sys_rcr2()
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80282d:	6a 00                	push   $0x0
  80282f:	6a 00                	push   $0x0
  802831:	6a 00                	push   $0x0
  802833:	6a 00                	push   $0x0
  802835:	6a 00                	push   $0x0
  802837:	6a 25                	push   $0x25
  802839:	e8 82 fb ff ff       	call   8023c0 <syscall>
  80283e:	83 c4 18             	add    $0x18,%esp
}
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	83 ec 04             	sub    $0x4,%esp
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80284f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	6a 00                	push   $0x0
  802859:	6a 00                	push   $0x0
  80285b:	50                   	push   %eax
  80285c:	6a 26                	push   $0x26
  80285e:	e8 5d fb ff ff       	call   8023c0 <syscall>
  802863:	83 c4 18             	add    $0x18,%esp
	return ;
  802866:	90                   	nop
}
  802867:	c9                   	leave  
  802868:	c3                   	ret    

00802869 <rsttst>:
void rsttst()
{
  802869:	55                   	push   %ebp
  80286a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80286c:	6a 00                	push   $0x0
  80286e:	6a 00                	push   $0x0
  802870:	6a 00                	push   $0x0
  802872:	6a 00                	push   $0x0
  802874:	6a 00                	push   $0x0
  802876:	6a 28                	push   $0x28
  802878:	e8 43 fb ff ff       	call   8023c0 <syscall>
  80287d:	83 c4 18             	add    $0x18,%esp
	return ;
  802880:	90                   	nop
}
  802881:	c9                   	leave  
  802882:	c3                   	ret    

00802883 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802883:	55                   	push   %ebp
  802884:	89 e5                	mov    %esp,%ebp
  802886:	83 ec 04             	sub    $0x4,%esp
  802889:	8b 45 14             	mov    0x14(%ebp),%eax
  80288c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80288f:	8b 55 18             	mov    0x18(%ebp),%edx
  802892:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802896:	52                   	push   %edx
  802897:	50                   	push   %eax
  802898:	ff 75 10             	pushl  0x10(%ebp)
  80289b:	ff 75 0c             	pushl  0xc(%ebp)
  80289e:	ff 75 08             	pushl  0x8(%ebp)
  8028a1:	6a 27                	push   $0x27
  8028a3:	e8 18 fb ff ff       	call   8023c0 <syscall>
  8028a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8028ab:	90                   	nop
}
  8028ac:	c9                   	leave  
  8028ad:	c3                   	ret    

008028ae <chktst>:
void chktst(uint32 n)
{
  8028ae:	55                   	push   %ebp
  8028af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8028b1:	6a 00                	push   $0x0
  8028b3:	6a 00                	push   $0x0
  8028b5:	6a 00                	push   $0x0
  8028b7:	6a 00                	push   $0x0
  8028b9:	ff 75 08             	pushl  0x8(%ebp)
  8028bc:	6a 29                	push   $0x29
  8028be:	e8 fd fa ff ff       	call   8023c0 <syscall>
  8028c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8028c6:	90                   	nop
}
  8028c7:	c9                   	leave  
  8028c8:	c3                   	ret    

008028c9 <inctst>:

void inctst()
{
  8028c9:	55                   	push   %ebp
  8028ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8028cc:	6a 00                	push   $0x0
  8028ce:	6a 00                	push   $0x0
  8028d0:	6a 00                	push   $0x0
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 2a                	push   $0x2a
  8028d8:	e8 e3 fa ff ff       	call   8023c0 <syscall>
  8028dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8028e0:	90                   	nop
}
  8028e1:	c9                   	leave  
  8028e2:	c3                   	ret    

008028e3 <gettst>:
uint32 gettst()
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8028e6:	6a 00                	push   $0x0
  8028e8:	6a 00                	push   $0x0
  8028ea:	6a 00                	push   $0x0
  8028ec:	6a 00                	push   $0x0
  8028ee:	6a 00                	push   $0x0
  8028f0:	6a 2b                	push   $0x2b
  8028f2:	e8 c9 fa ff ff       	call   8023c0 <syscall>
  8028f7:	83 c4 18             	add    $0x18,%esp
}
  8028fa:	c9                   	leave  
  8028fb:	c3                   	ret    

008028fc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8028fc:	55                   	push   %ebp
  8028fd:	89 e5                	mov    %esp,%ebp
  8028ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802902:	6a 00                	push   $0x0
  802904:	6a 00                	push   $0x0
  802906:	6a 00                	push   $0x0
  802908:	6a 00                	push   $0x0
  80290a:	6a 00                	push   $0x0
  80290c:	6a 2c                	push   $0x2c
  80290e:	e8 ad fa ff ff       	call   8023c0 <syscall>
  802913:	83 c4 18             	add    $0x18,%esp
  802916:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802919:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80291d:	75 07                	jne    802926 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80291f:	b8 01 00 00 00       	mov    $0x1,%eax
  802924:	eb 05                	jmp    80292b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802926:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80292b:	c9                   	leave  
  80292c:	c3                   	ret    

0080292d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80292d:	55                   	push   %ebp
  80292e:	89 e5                	mov    %esp,%ebp
  802930:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802933:	6a 00                	push   $0x0
  802935:	6a 00                	push   $0x0
  802937:	6a 00                	push   $0x0
  802939:	6a 00                	push   $0x0
  80293b:	6a 00                	push   $0x0
  80293d:	6a 2c                	push   $0x2c
  80293f:	e8 7c fa ff ff       	call   8023c0 <syscall>
  802944:	83 c4 18             	add    $0x18,%esp
  802947:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80294a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80294e:	75 07                	jne    802957 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802950:	b8 01 00 00 00       	mov    $0x1,%eax
  802955:	eb 05                	jmp    80295c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802957:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80295c:	c9                   	leave  
  80295d:	c3                   	ret    

0080295e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80295e:	55                   	push   %ebp
  80295f:	89 e5                	mov    %esp,%ebp
  802961:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802964:	6a 00                	push   $0x0
  802966:	6a 00                	push   $0x0
  802968:	6a 00                	push   $0x0
  80296a:	6a 00                	push   $0x0
  80296c:	6a 00                	push   $0x0
  80296e:	6a 2c                	push   $0x2c
  802970:	e8 4b fa ff ff       	call   8023c0 <syscall>
  802975:	83 c4 18             	add    $0x18,%esp
  802978:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80297b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80297f:	75 07                	jne    802988 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802981:	b8 01 00 00 00       	mov    $0x1,%eax
  802986:	eb 05                	jmp    80298d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802988:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80298d:	c9                   	leave  
  80298e:	c3                   	ret    

0080298f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80298f:	55                   	push   %ebp
  802990:	89 e5                	mov    %esp,%ebp
  802992:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802995:	6a 00                	push   $0x0
  802997:	6a 00                	push   $0x0
  802999:	6a 00                	push   $0x0
  80299b:	6a 00                	push   $0x0
  80299d:	6a 00                	push   $0x0
  80299f:	6a 2c                	push   $0x2c
  8029a1:	e8 1a fa ff ff       	call   8023c0 <syscall>
  8029a6:	83 c4 18             	add    $0x18,%esp
  8029a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8029ac:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8029b0:	75 07                	jne    8029b9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8029b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8029b7:	eb 05                	jmp    8029be <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8029b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029be:	c9                   	leave  
  8029bf:	c3                   	ret    

008029c0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8029c0:	55                   	push   %ebp
  8029c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8029c3:	6a 00                	push   $0x0
  8029c5:	6a 00                	push   $0x0
  8029c7:	6a 00                	push   $0x0
  8029c9:	6a 00                	push   $0x0
  8029cb:	ff 75 08             	pushl  0x8(%ebp)
  8029ce:	6a 2d                	push   $0x2d
  8029d0:	e8 eb f9 ff ff       	call   8023c0 <syscall>
  8029d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8029d8:	90                   	nop
}
  8029d9:	c9                   	leave  
  8029da:	c3                   	ret    

008029db <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8029db:	55                   	push   %ebp
  8029dc:	89 e5                	mov    %esp,%ebp
  8029de:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8029df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8029e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	6a 00                	push   $0x0
  8029ed:	53                   	push   %ebx
  8029ee:	51                   	push   %ecx
  8029ef:	52                   	push   %edx
  8029f0:	50                   	push   %eax
  8029f1:	6a 2e                	push   $0x2e
  8029f3:	e8 c8 f9 ff ff       	call   8023c0 <syscall>
  8029f8:	83 c4 18             	add    $0x18,%esp
}
  8029fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029fe:	c9                   	leave  
  8029ff:	c3                   	ret    

00802a00 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	6a 00                	push   $0x0
  802a0b:	6a 00                	push   $0x0
  802a0d:	6a 00                	push   $0x0
  802a0f:	52                   	push   %edx
  802a10:	50                   	push   %eax
  802a11:	6a 2f                	push   $0x2f
  802a13:	e8 a8 f9 ff ff       	call   8023c0 <syscall>
  802a18:	83 c4 18             	add    $0x18,%esp
}
  802a1b:	c9                   	leave  
  802a1c:	c3                   	ret    
  802a1d:	66 90                	xchg   %ax,%ax
  802a1f:	90                   	nop

00802a20 <__udivdi3>:
  802a20:	55                   	push   %ebp
  802a21:	57                   	push   %edi
  802a22:	56                   	push   %esi
  802a23:	53                   	push   %ebx
  802a24:	83 ec 1c             	sub    $0x1c,%esp
  802a27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802a2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802a2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a37:	89 ca                	mov    %ecx,%edx
  802a39:	89 f8                	mov    %edi,%eax
  802a3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802a3f:	85 f6                	test   %esi,%esi
  802a41:	75 2d                	jne    802a70 <__udivdi3+0x50>
  802a43:	39 cf                	cmp    %ecx,%edi
  802a45:	77 65                	ja     802aac <__udivdi3+0x8c>
  802a47:	89 fd                	mov    %edi,%ebp
  802a49:	85 ff                	test   %edi,%edi
  802a4b:	75 0b                	jne    802a58 <__udivdi3+0x38>
  802a4d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a52:	31 d2                	xor    %edx,%edx
  802a54:	f7 f7                	div    %edi
  802a56:	89 c5                	mov    %eax,%ebp
  802a58:	31 d2                	xor    %edx,%edx
  802a5a:	89 c8                	mov    %ecx,%eax
  802a5c:	f7 f5                	div    %ebp
  802a5e:	89 c1                	mov    %eax,%ecx
  802a60:	89 d8                	mov    %ebx,%eax
  802a62:	f7 f5                	div    %ebp
  802a64:	89 cf                	mov    %ecx,%edi
  802a66:	89 fa                	mov    %edi,%edx
  802a68:	83 c4 1c             	add    $0x1c,%esp
  802a6b:	5b                   	pop    %ebx
  802a6c:	5e                   	pop    %esi
  802a6d:	5f                   	pop    %edi
  802a6e:	5d                   	pop    %ebp
  802a6f:	c3                   	ret    
  802a70:	39 ce                	cmp    %ecx,%esi
  802a72:	77 28                	ja     802a9c <__udivdi3+0x7c>
  802a74:	0f bd fe             	bsr    %esi,%edi
  802a77:	83 f7 1f             	xor    $0x1f,%edi
  802a7a:	75 40                	jne    802abc <__udivdi3+0x9c>
  802a7c:	39 ce                	cmp    %ecx,%esi
  802a7e:	72 0a                	jb     802a8a <__udivdi3+0x6a>
  802a80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802a84:	0f 87 9e 00 00 00    	ja     802b28 <__udivdi3+0x108>
  802a8a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a8f:	89 fa                	mov    %edi,%edx
  802a91:	83 c4 1c             	add    $0x1c,%esp
  802a94:	5b                   	pop    %ebx
  802a95:	5e                   	pop    %esi
  802a96:	5f                   	pop    %edi
  802a97:	5d                   	pop    %ebp
  802a98:	c3                   	ret    
  802a99:	8d 76 00             	lea    0x0(%esi),%esi
  802a9c:	31 ff                	xor    %edi,%edi
  802a9e:	31 c0                	xor    %eax,%eax
  802aa0:	89 fa                	mov    %edi,%edx
  802aa2:	83 c4 1c             	add    $0x1c,%esp
  802aa5:	5b                   	pop    %ebx
  802aa6:	5e                   	pop    %esi
  802aa7:	5f                   	pop    %edi
  802aa8:	5d                   	pop    %ebp
  802aa9:	c3                   	ret    
  802aaa:	66 90                	xchg   %ax,%ax
  802aac:	89 d8                	mov    %ebx,%eax
  802aae:	f7 f7                	div    %edi
  802ab0:	31 ff                	xor    %edi,%edi
  802ab2:	89 fa                	mov    %edi,%edx
  802ab4:	83 c4 1c             	add    $0x1c,%esp
  802ab7:	5b                   	pop    %ebx
  802ab8:	5e                   	pop    %esi
  802ab9:	5f                   	pop    %edi
  802aba:	5d                   	pop    %ebp
  802abb:	c3                   	ret    
  802abc:	bd 20 00 00 00       	mov    $0x20,%ebp
  802ac1:	89 eb                	mov    %ebp,%ebx
  802ac3:	29 fb                	sub    %edi,%ebx
  802ac5:	89 f9                	mov    %edi,%ecx
  802ac7:	d3 e6                	shl    %cl,%esi
  802ac9:	89 c5                	mov    %eax,%ebp
  802acb:	88 d9                	mov    %bl,%cl
  802acd:	d3 ed                	shr    %cl,%ebp
  802acf:	89 e9                	mov    %ebp,%ecx
  802ad1:	09 f1                	or     %esi,%ecx
  802ad3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802ad7:	89 f9                	mov    %edi,%ecx
  802ad9:	d3 e0                	shl    %cl,%eax
  802adb:	89 c5                	mov    %eax,%ebp
  802add:	89 d6                	mov    %edx,%esi
  802adf:	88 d9                	mov    %bl,%cl
  802ae1:	d3 ee                	shr    %cl,%esi
  802ae3:	89 f9                	mov    %edi,%ecx
  802ae5:	d3 e2                	shl    %cl,%edx
  802ae7:	8b 44 24 08          	mov    0x8(%esp),%eax
  802aeb:	88 d9                	mov    %bl,%cl
  802aed:	d3 e8                	shr    %cl,%eax
  802aef:	09 c2                	or     %eax,%edx
  802af1:	89 d0                	mov    %edx,%eax
  802af3:	89 f2                	mov    %esi,%edx
  802af5:	f7 74 24 0c          	divl   0xc(%esp)
  802af9:	89 d6                	mov    %edx,%esi
  802afb:	89 c3                	mov    %eax,%ebx
  802afd:	f7 e5                	mul    %ebp
  802aff:	39 d6                	cmp    %edx,%esi
  802b01:	72 19                	jb     802b1c <__udivdi3+0xfc>
  802b03:	74 0b                	je     802b10 <__udivdi3+0xf0>
  802b05:	89 d8                	mov    %ebx,%eax
  802b07:	31 ff                	xor    %edi,%edi
  802b09:	e9 58 ff ff ff       	jmp    802a66 <__udivdi3+0x46>
  802b0e:	66 90                	xchg   %ax,%ax
  802b10:	8b 54 24 08          	mov    0x8(%esp),%edx
  802b14:	89 f9                	mov    %edi,%ecx
  802b16:	d3 e2                	shl    %cl,%edx
  802b18:	39 c2                	cmp    %eax,%edx
  802b1a:	73 e9                	jae    802b05 <__udivdi3+0xe5>
  802b1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b1f:	31 ff                	xor    %edi,%edi
  802b21:	e9 40 ff ff ff       	jmp    802a66 <__udivdi3+0x46>
  802b26:	66 90                	xchg   %ax,%ax
  802b28:	31 c0                	xor    %eax,%eax
  802b2a:	e9 37 ff ff ff       	jmp    802a66 <__udivdi3+0x46>
  802b2f:	90                   	nop

00802b30 <__umoddi3>:
  802b30:	55                   	push   %ebp
  802b31:	57                   	push   %edi
  802b32:	56                   	push   %esi
  802b33:	53                   	push   %ebx
  802b34:	83 ec 1c             	sub    $0x1c,%esp
  802b37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802b3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b4f:	89 f3                	mov    %esi,%ebx
  802b51:	89 fa                	mov    %edi,%edx
  802b53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b57:	89 34 24             	mov    %esi,(%esp)
  802b5a:	85 c0                	test   %eax,%eax
  802b5c:	75 1a                	jne    802b78 <__umoddi3+0x48>
  802b5e:	39 f7                	cmp    %esi,%edi
  802b60:	0f 86 a2 00 00 00    	jbe    802c08 <__umoddi3+0xd8>
  802b66:	89 c8                	mov    %ecx,%eax
  802b68:	89 f2                	mov    %esi,%edx
  802b6a:	f7 f7                	div    %edi
  802b6c:	89 d0                	mov    %edx,%eax
  802b6e:	31 d2                	xor    %edx,%edx
  802b70:	83 c4 1c             	add    $0x1c,%esp
  802b73:	5b                   	pop    %ebx
  802b74:	5e                   	pop    %esi
  802b75:	5f                   	pop    %edi
  802b76:	5d                   	pop    %ebp
  802b77:	c3                   	ret    
  802b78:	39 f0                	cmp    %esi,%eax
  802b7a:	0f 87 ac 00 00 00    	ja     802c2c <__umoddi3+0xfc>
  802b80:	0f bd e8             	bsr    %eax,%ebp
  802b83:	83 f5 1f             	xor    $0x1f,%ebp
  802b86:	0f 84 ac 00 00 00    	je     802c38 <__umoddi3+0x108>
  802b8c:	bf 20 00 00 00       	mov    $0x20,%edi
  802b91:	29 ef                	sub    %ebp,%edi
  802b93:	89 fe                	mov    %edi,%esi
  802b95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b99:	89 e9                	mov    %ebp,%ecx
  802b9b:	d3 e0                	shl    %cl,%eax
  802b9d:	89 d7                	mov    %edx,%edi
  802b9f:	89 f1                	mov    %esi,%ecx
  802ba1:	d3 ef                	shr    %cl,%edi
  802ba3:	09 c7                	or     %eax,%edi
  802ba5:	89 e9                	mov    %ebp,%ecx
  802ba7:	d3 e2                	shl    %cl,%edx
  802ba9:	89 14 24             	mov    %edx,(%esp)
  802bac:	89 d8                	mov    %ebx,%eax
  802bae:	d3 e0                	shl    %cl,%eax
  802bb0:	89 c2                	mov    %eax,%edx
  802bb2:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bb6:	d3 e0                	shl    %cl,%eax
  802bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bbc:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bc0:	89 f1                	mov    %esi,%ecx
  802bc2:	d3 e8                	shr    %cl,%eax
  802bc4:	09 d0                	or     %edx,%eax
  802bc6:	d3 eb                	shr    %cl,%ebx
  802bc8:	89 da                	mov    %ebx,%edx
  802bca:	f7 f7                	div    %edi
  802bcc:	89 d3                	mov    %edx,%ebx
  802bce:	f7 24 24             	mull   (%esp)
  802bd1:	89 c6                	mov    %eax,%esi
  802bd3:	89 d1                	mov    %edx,%ecx
  802bd5:	39 d3                	cmp    %edx,%ebx
  802bd7:	0f 82 87 00 00 00    	jb     802c64 <__umoddi3+0x134>
  802bdd:	0f 84 91 00 00 00    	je     802c74 <__umoddi3+0x144>
  802be3:	8b 54 24 04          	mov    0x4(%esp),%edx
  802be7:	29 f2                	sub    %esi,%edx
  802be9:	19 cb                	sbb    %ecx,%ebx
  802beb:	89 d8                	mov    %ebx,%eax
  802bed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802bf1:	d3 e0                	shl    %cl,%eax
  802bf3:	89 e9                	mov    %ebp,%ecx
  802bf5:	d3 ea                	shr    %cl,%edx
  802bf7:	09 d0                	or     %edx,%eax
  802bf9:	89 e9                	mov    %ebp,%ecx
  802bfb:	d3 eb                	shr    %cl,%ebx
  802bfd:	89 da                	mov    %ebx,%edx
  802bff:	83 c4 1c             	add    $0x1c,%esp
  802c02:	5b                   	pop    %ebx
  802c03:	5e                   	pop    %esi
  802c04:	5f                   	pop    %edi
  802c05:	5d                   	pop    %ebp
  802c06:	c3                   	ret    
  802c07:	90                   	nop
  802c08:	89 fd                	mov    %edi,%ebp
  802c0a:	85 ff                	test   %edi,%edi
  802c0c:	75 0b                	jne    802c19 <__umoddi3+0xe9>
  802c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c13:	31 d2                	xor    %edx,%edx
  802c15:	f7 f7                	div    %edi
  802c17:	89 c5                	mov    %eax,%ebp
  802c19:	89 f0                	mov    %esi,%eax
  802c1b:	31 d2                	xor    %edx,%edx
  802c1d:	f7 f5                	div    %ebp
  802c1f:	89 c8                	mov    %ecx,%eax
  802c21:	f7 f5                	div    %ebp
  802c23:	89 d0                	mov    %edx,%eax
  802c25:	e9 44 ff ff ff       	jmp    802b6e <__umoddi3+0x3e>
  802c2a:	66 90                	xchg   %ax,%ax
  802c2c:	89 c8                	mov    %ecx,%eax
  802c2e:	89 f2                	mov    %esi,%edx
  802c30:	83 c4 1c             	add    $0x1c,%esp
  802c33:	5b                   	pop    %ebx
  802c34:	5e                   	pop    %esi
  802c35:	5f                   	pop    %edi
  802c36:	5d                   	pop    %ebp
  802c37:	c3                   	ret    
  802c38:	3b 04 24             	cmp    (%esp),%eax
  802c3b:	72 06                	jb     802c43 <__umoddi3+0x113>
  802c3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802c41:	77 0f                	ja     802c52 <__umoddi3+0x122>
  802c43:	89 f2                	mov    %esi,%edx
  802c45:	29 f9                	sub    %edi,%ecx
  802c47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802c4b:	89 14 24             	mov    %edx,(%esp)
  802c4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c52:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c56:	8b 14 24             	mov    (%esp),%edx
  802c59:	83 c4 1c             	add    $0x1c,%esp
  802c5c:	5b                   	pop    %ebx
  802c5d:	5e                   	pop    %esi
  802c5e:	5f                   	pop    %edi
  802c5f:	5d                   	pop    %ebp
  802c60:	c3                   	ret    
  802c61:	8d 76 00             	lea    0x0(%esi),%esi
  802c64:	2b 04 24             	sub    (%esp),%eax
  802c67:	19 fa                	sbb    %edi,%edx
  802c69:	89 d1                	mov    %edx,%ecx
  802c6b:	89 c6                	mov    %eax,%esi
  802c6d:	e9 71 ff ff ff       	jmp    802be3 <__umoddi3+0xb3>
  802c72:	66 90                	xchg   %ax,%ax
  802c74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802c78:	72 ea                	jb     802c64 <__umoddi3+0x134>
  802c7a:	89 d9                	mov    %ebx,%ecx
  802c7c:	e9 62 ff ff ff       	jmp    802be3 <__umoddi3+0xb3>
