
obj/user/tst_envfree4:     file format elf32-i386


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
  800031:	e8 0d 01 00 00       	call   800143 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing scenario 4: Freeing the allocated semaphores
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 e0 21 80 00       	push   $0x8021e0
  80004a:	e8 ff 17 00 00       	call   80184e <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 28 1a 00 00       	call   801a8b <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 a3 1a 00 00       	call   801b0e <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 f0 21 80 00       	push   $0x8021f0
  800079:	e8 ac 04 00 00       	call   80052a <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tsem1", 100,(myEnv->SecondListSize), 50);
  800081:	a1 20 30 80 00       	mov    0x803020,%eax
  800086:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	6a 64                	push   $0x64
  800091:	68 23 22 80 00       	push   $0x802223
  800096:	e8 45 1c 00 00       	call   801ce0 <sys_create_env>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8000a7:	e8 52 1c 00 00       	call   801cfe <sys_run_env>
  8000ac:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000af:	90                   	nop
  8000b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b3:	8b 00                	mov    (%eax),%eax
  8000b5:	83 f8 01             	cmp    $0x1,%eax
  8000b8:	75 f6                	jne    8000b0 <_main+0x78>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ba:	e8 cc 19 00 00       	call   801a8b <sys_calculate_free_frames>
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	50                   	push   %eax
  8000c3:	68 2c 22 80 00       	push   $0x80222c
  8000c8:	e8 5d 04 00 00       	call   80052a <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	sys_free_env(envIdProcessA);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d6:	e8 3f 1c 00 00       	call   801d1a <sys_free_env>
  8000db:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000de:	e8 a8 19 00 00       	call   801a8b <sys_calculate_free_frames>
  8000e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e6:	e8 23 1a 00 00       	call   801b0e <sys_pf_calculate_allocated_pages>
  8000eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f4:	74 27                	je     80011d <_main+0xe5>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fc:	68 60 22 80 00       	push   $0x802260
  800101:	e8 24 04 00 00       	call   80052a <cprintf>
  800106:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	68 b0 22 80 00       	push   $0x8022b0
  800111:	6a 1f                	push   $0x1f
  800113:	68 e6 22 80 00       	push   $0x8022e6
  800118:	e8 6b 01 00 00       	call   800288 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	ff 75 e4             	pushl  -0x1c(%ebp)
  800123:	68 fc 22 80 00       	push   $0x8022fc
  800128:	e8 fd 03 00 00       	call   80052a <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 4 for envfree completed successfully.\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 5c 23 80 00       	push   $0x80235c
  800138:	e8 ed 03 00 00       	call   80052a <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
	return;
  800140:	90                   	nop
}
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800149:	e8 72 18 00 00       	call   8019c0 <sys_getenvindex>
  80014e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800154:	89 d0                	mov    %edx,%eax
  800156:	c1 e0 03             	shl    $0x3,%eax
  800159:	01 d0                	add    %edx,%eax
  80015b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800162:	01 c8                	add    %ecx,%eax
  800164:	01 c0                	add    %eax,%eax
  800166:	01 d0                	add    %edx,%eax
  800168:	01 c0                	add    %eax,%eax
  80016a:	01 d0                	add    %edx,%eax
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	c1 e2 05             	shl    $0x5,%edx
  800171:	29 c2                	sub    %eax,%edx
  800173:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80017a:	89 c2                	mov    %eax,%edx
  80017c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800182:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800187:	a1 20 30 80 00       	mov    0x803020,%eax
  80018c:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800192:	84 c0                	test   %al,%al
  800194:	74 0f                	je     8001a5 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800196:	a1 20 30 80 00       	mov    0x803020,%eax
  80019b:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001a0:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a9:	7e 0a                	jle    8001b5 <libmain+0x72>
		binaryname = argv[0];
  8001ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ae:	8b 00                	mov    (%eax),%eax
  8001b0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	ff 75 0c             	pushl  0xc(%ebp)
  8001bb:	ff 75 08             	pushl  0x8(%ebp)
  8001be:	e8 75 fe ff ff       	call   800038 <_main>
  8001c3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001c6:	e8 90 19 00 00       	call   801b5b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	68 c0 23 80 00       	push   $0x8023c0
  8001d3:	e8 52 03 00 00       	call   80052a <cprintf>
  8001d8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001db:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e0:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8001e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001eb:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8001f1:	83 ec 04             	sub    $0x4,%esp
  8001f4:	52                   	push   %edx
  8001f5:	50                   	push   %eax
  8001f6:	68 e8 23 80 00       	push   $0x8023e8
  8001fb:	e8 2a 03 00 00       	call   80052a <cprintf>
  800200:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800203:	a1 20 30 80 00       	mov    0x803020,%eax
  800208:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80020e:	a1 20 30 80 00       	mov    0x803020,%eax
  800213:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800219:	83 ec 04             	sub    $0x4,%esp
  80021c:	52                   	push   %edx
  80021d:	50                   	push   %eax
  80021e:	68 10 24 80 00       	push   $0x802410
  800223:	e8 02 03 00 00       	call   80052a <cprintf>
  800228:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80022b:	a1 20 30 80 00       	mov    0x803020,%eax
  800230:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800236:	83 ec 08             	sub    $0x8,%esp
  800239:	50                   	push   %eax
  80023a:	68 51 24 80 00       	push   $0x802451
  80023f:	e8 e6 02 00 00       	call   80052a <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	68 c0 23 80 00       	push   $0x8023c0
  80024f:	e8 d6 02 00 00       	call   80052a <cprintf>
  800254:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800257:	e8 19 19 00 00       	call   801b75 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80025c:	e8 19 00 00 00       	call   80027a <exit>
}
  800261:	90                   	nop
  800262:	c9                   	leave  
  800263:	c3                   	ret    

00800264 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	6a 00                	push   $0x0
  80026f:	e8 18 17 00 00       	call   80198c <sys_env_destroy>
  800274:	83 c4 10             	add    $0x10,%esp
}
  800277:	90                   	nop
  800278:	c9                   	leave  
  800279:	c3                   	ret    

0080027a <exit>:

void
exit(void)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800280:	e8 6d 17 00 00       	call   8019f2 <sys_env_exit>
}
  800285:	90                   	nop
  800286:	c9                   	leave  
  800287:	c3                   	ret    

00800288 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80028e:	8d 45 10             	lea    0x10(%ebp),%eax
  800291:	83 c0 04             	add    $0x4,%eax
  800294:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800297:	a1 18 31 80 00       	mov    0x803118,%eax
  80029c:	85 c0                	test   %eax,%eax
  80029e:	74 16                	je     8002b6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a0:	a1 18 31 80 00       	mov    0x803118,%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	50                   	push   %eax
  8002a9:	68 68 24 80 00       	push   $0x802468
  8002ae:	e8 77 02 00 00       	call   80052a <cprintf>
  8002b3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b6:	a1 00 30 80 00       	mov    0x803000,%eax
  8002bb:	ff 75 0c             	pushl  0xc(%ebp)
  8002be:	ff 75 08             	pushl  0x8(%ebp)
  8002c1:	50                   	push   %eax
  8002c2:	68 6d 24 80 00       	push   $0x80246d
  8002c7:	e8 5e 02 00 00       	call   80052a <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d8:	50                   	push   %eax
  8002d9:	e8 e1 01 00 00       	call   8004bf <vcprintf>
  8002de:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002e1:	83 ec 08             	sub    $0x8,%esp
  8002e4:	6a 00                	push   $0x0
  8002e6:	68 89 24 80 00       	push   $0x802489
  8002eb:	e8 cf 01 00 00       	call   8004bf <vcprintf>
  8002f0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002f3:	e8 82 ff ff ff       	call   80027a <exit>

	// should not return here
	while (1) ;
  8002f8:	eb fe                	jmp    8002f8 <_panic+0x70>

008002fa <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800300:	a1 20 30 80 00       	mov    0x803020,%eax
  800305:	8b 50 74             	mov    0x74(%eax),%edx
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030b:	39 c2                	cmp    %eax,%edx
  80030d:	74 14                	je     800323 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 8c 24 80 00       	push   $0x80248c
  800317:	6a 26                	push   $0x26
  800319:	68 d8 24 80 00       	push   $0x8024d8
  80031e:	e8 65 ff ff ff       	call   800288 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800323:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80032a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800331:	e9 b6 00 00 00       	jmp    8003ec <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800340:	8b 45 08             	mov    0x8(%ebp),%eax
  800343:	01 d0                	add    %edx,%eax
  800345:	8b 00                	mov    (%eax),%eax
  800347:	85 c0                	test   %eax,%eax
  800349:	75 08                	jne    800353 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80034b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80034e:	e9 96 00 00 00       	jmp    8003e9 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800353:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80035a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800361:	eb 5d                	jmp    8003c0 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800363:	a1 20 30 80 00       	mov    0x803020,%eax
  800368:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80036e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800371:	c1 e2 04             	shl    $0x4,%edx
  800374:	01 d0                	add    %edx,%eax
  800376:	8a 40 04             	mov    0x4(%eax),%al
  800379:	84 c0                	test   %al,%al
  80037b:	75 40                	jne    8003bd <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037d:	a1 20 30 80 00       	mov    0x803020,%eax
  800382:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800388:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80038b:	c1 e2 04             	shl    $0x4,%edx
  80038e:	01 d0                	add    %edx,%eax
  800390:	8b 00                	mov    (%eax),%eax
  800392:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800395:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800398:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80039d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80039f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ac:	01 c8                	add    %ecx,%eax
  8003ae:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b0:	39 c2                	cmp    %eax,%edx
  8003b2:	75 09                	jne    8003bd <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8003b4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003bb:	eb 12                	jmp    8003cf <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003bd:	ff 45 e8             	incl   -0x18(%ebp)
  8003c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c5:	8b 50 74             	mov    0x74(%eax),%edx
  8003c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003cb:	39 c2                	cmp    %eax,%edx
  8003cd:	77 94                	ja     800363 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d3:	75 14                	jne    8003e9 <CheckWSWithoutLastIndex+0xef>
			panic(
  8003d5:	83 ec 04             	sub    $0x4,%esp
  8003d8:	68 e4 24 80 00       	push   $0x8024e4
  8003dd:	6a 3a                	push   $0x3a
  8003df:	68 d8 24 80 00       	push   $0x8024d8
  8003e4:	e8 9f fe ff ff       	call   800288 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e9:	ff 45 f0             	incl   -0x10(%ebp)
  8003ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f2:	0f 8c 3e ff ff ff    	jl     800336 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800406:	eb 20                	jmp    800428 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800408:	a1 20 30 80 00       	mov    0x803020,%eax
  80040d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800413:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800416:	c1 e2 04             	shl    $0x4,%edx
  800419:	01 d0                	add    %edx,%eax
  80041b:	8a 40 04             	mov    0x4(%eax),%al
  80041e:	3c 01                	cmp    $0x1,%al
  800420:	75 03                	jne    800425 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800422:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800425:	ff 45 e0             	incl   -0x20(%ebp)
  800428:	a1 20 30 80 00       	mov    0x803020,%eax
  80042d:	8b 50 74             	mov    0x74(%eax),%edx
  800430:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800433:	39 c2                	cmp    %eax,%edx
  800435:	77 d1                	ja     800408 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80043d:	74 14                	je     800453 <CheckWSWithoutLastIndex+0x159>
		panic(
  80043f:	83 ec 04             	sub    $0x4,%esp
  800442:	68 38 25 80 00       	push   $0x802538
  800447:	6a 44                	push   $0x44
  800449:	68 d8 24 80 00       	push   $0x8024d8
  80044e:	e8 35 fe ff ff       	call   800288 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800453:	90                   	nop
  800454:	c9                   	leave  
  800455:	c3                   	ret    

00800456 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800456:	55                   	push   %ebp
  800457:	89 e5                	mov    %esp,%ebp
  800459:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80045c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045f:	8b 00                	mov    (%eax),%eax
  800461:	8d 48 01             	lea    0x1(%eax),%ecx
  800464:	8b 55 0c             	mov    0xc(%ebp),%edx
  800467:	89 0a                	mov    %ecx,(%edx)
  800469:	8b 55 08             	mov    0x8(%ebp),%edx
  80046c:	88 d1                	mov    %dl,%cl
  80046e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800471:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800475:	8b 45 0c             	mov    0xc(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80047f:	75 2c                	jne    8004ad <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800481:	a0 24 30 80 00       	mov    0x803024,%al
  800486:	0f b6 c0             	movzbl %al,%eax
  800489:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048c:	8b 12                	mov    (%edx),%edx
  80048e:	89 d1                	mov    %edx,%ecx
  800490:	8b 55 0c             	mov    0xc(%ebp),%edx
  800493:	83 c2 08             	add    $0x8,%edx
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	50                   	push   %eax
  80049a:	51                   	push   %ecx
  80049b:	52                   	push   %edx
  80049c:	e8 a9 14 00 00       	call   80194a <sys_cputs>
  8004a1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	8b 40 04             	mov    0x4(%eax),%eax
  8004b3:	8d 50 01             	lea    0x1(%eax),%edx
  8004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004bc:	90                   	nop
  8004bd:	c9                   	leave  
  8004be:	c3                   	ret    

008004bf <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004bf:	55                   	push   %ebp
  8004c0:	89 e5                	mov    %esp,%ebp
  8004c2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004cf:	00 00 00 
	b.cnt = 0;
  8004d2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004dc:	ff 75 0c             	pushl  0xc(%ebp)
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e8:	50                   	push   %eax
  8004e9:	68 56 04 80 00       	push   $0x800456
  8004ee:	e8 11 02 00 00       	call   800704 <vprintfmt>
  8004f3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f6:	a0 24 30 80 00       	mov    0x803024,%al
  8004fb:	0f b6 c0             	movzbl %al,%eax
  8004fe:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800504:	83 ec 04             	sub    $0x4,%esp
  800507:	50                   	push   %eax
  800508:	52                   	push   %edx
  800509:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80050f:	83 c0 08             	add    $0x8,%eax
  800512:	50                   	push   %eax
  800513:	e8 32 14 00 00       	call   80194a <sys_cputs>
  800518:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80051b:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800522:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800528:	c9                   	leave  
  800529:	c3                   	ret    

0080052a <cprintf>:

int cprintf(const char *fmt, ...) {
  80052a:	55                   	push   %ebp
  80052b:	89 e5                	mov    %esp,%ebp
  80052d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800530:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800537:	8d 45 0c             	lea    0xc(%ebp),%eax
  80053a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053d:	8b 45 08             	mov    0x8(%ebp),%eax
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	ff 75 f4             	pushl  -0xc(%ebp)
  800546:	50                   	push   %eax
  800547:	e8 73 ff ff ff       	call   8004bf <vcprintf>
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800552:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800555:	c9                   	leave  
  800556:	c3                   	ret    

00800557 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800557:	55                   	push   %ebp
  800558:	89 e5                	mov    %esp,%ebp
  80055a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80055d:	e8 f9 15 00 00       	call   801b5b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800562:	8d 45 0c             	lea    0xc(%ebp),%eax
  800565:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	ff 75 f4             	pushl  -0xc(%ebp)
  800571:	50                   	push   %eax
  800572:	e8 48 ff ff ff       	call   8004bf <vcprintf>
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80057d:	e8 f3 15 00 00       	call   801b75 <sys_enable_interrupt>
	return cnt;
  800582:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800585:	c9                   	leave  
  800586:	c3                   	ret    

00800587 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800587:	55                   	push   %ebp
  800588:	89 e5                	mov    %esp,%ebp
  80058a:	53                   	push   %ebx
  80058b:	83 ec 14             	sub    $0x14,%esp
  80058e:	8b 45 10             	mov    0x10(%ebp),%eax
  800591:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059a:	8b 45 18             	mov    0x18(%ebp),%eax
  80059d:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a5:	77 55                	ja     8005fc <printnum+0x75>
  8005a7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005aa:	72 05                	jb     8005b1 <printnum+0x2a>
  8005ac:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005af:	77 4b                	ja     8005fc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005b4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bf:	52                   	push   %edx
  8005c0:	50                   	push   %eax
  8005c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c7:	e8 b0 19 00 00       	call   801f7c <__udivdi3>
  8005cc:	83 c4 10             	add    $0x10,%esp
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	ff 75 20             	pushl  0x20(%ebp)
  8005d5:	53                   	push   %ebx
  8005d6:	ff 75 18             	pushl  0x18(%ebp)
  8005d9:	52                   	push   %edx
  8005da:	50                   	push   %eax
  8005db:	ff 75 0c             	pushl  0xc(%ebp)
  8005de:	ff 75 08             	pushl  0x8(%ebp)
  8005e1:	e8 a1 ff ff ff       	call   800587 <printnum>
  8005e6:	83 c4 20             	add    $0x20,%esp
  8005e9:	eb 1a                	jmp    800605 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	ff 75 0c             	pushl  0xc(%ebp)
  8005f1:	ff 75 20             	pushl  0x20(%ebp)
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	ff d0                	call   *%eax
  8005f9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fc:	ff 4d 1c             	decl   0x1c(%ebp)
  8005ff:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800603:	7f e6                	jg     8005eb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800605:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800608:	bb 00 00 00 00       	mov    $0x0,%ebx
  80060d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800610:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800613:	53                   	push   %ebx
  800614:	51                   	push   %ecx
  800615:	52                   	push   %edx
  800616:	50                   	push   %eax
  800617:	e8 70 1a 00 00       	call   80208c <__umoddi3>
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	05 b4 27 80 00       	add    $0x8027b4,%eax
  800624:	8a 00                	mov    (%eax),%al
  800626:	0f be c0             	movsbl %al,%eax
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	ff 75 0c             	pushl  0xc(%ebp)
  80062f:	50                   	push   %eax
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	ff d0                	call   *%eax
  800635:	83 c4 10             	add    $0x10,%esp
}
  800638:	90                   	nop
  800639:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80063c:	c9                   	leave  
  80063d:	c3                   	ret    

0080063e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80063e:	55                   	push   %ebp
  80063f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800641:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800645:	7e 1c                	jle    800663 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	8d 50 08             	lea    0x8(%eax),%edx
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	89 10                	mov    %edx,(%eax)
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	83 e8 08             	sub    $0x8,%eax
  80065c:	8b 50 04             	mov    0x4(%eax),%edx
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	eb 40                	jmp    8006a3 <getuint+0x65>
	else if (lflag)
  800663:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800667:	74 1e                	je     800687 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	8d 50 04             	lea    0x4(%eax),%edx
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	89 10                	mov    %edx,(%eax)
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	83 e8 04             	sub    $0x4,%eax
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	ba 00 00 00 00       	mov    $0x0,%edx
  800685:	eb 1c                	jmp    8006a3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8d 50 04             	lea    0x4(%eax),%edx
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	89 10                	mov    %edx,(%eax)
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	83 e8 04             	sub    $0x4,%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a3:	5d                   	pop    %ebp
  8006a4:	c3                   	ret    

008006a5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ac:	7e 1c                	jle    8006ca <getint+0x25>
		return va_arg(*ap, long long);
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	8d 50 08             	lea    0x8(%eax),%edx
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	89 10                	mov    %edx,(%eax)
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	83 e8 08             	sub    $0x8,%eax
  8006c3:	8b 50 04             	mov    0x4(%eax),%edx
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	eb 38                	jmp    800702 <getint+0x5d>
	else if (lflag)
  8006ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ce:	74 1a                	je     8006ea <getint+0x45>
		return va_arg(*ap, long);
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	8d 50 04             	lea    0x4(%eax),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	89 10                	mov    %edx,(%eax)
  8006dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	83 e8 04             	sub    $0x4,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	99                   	cltd   
  8006e8:	eb 18                	jmp    800702 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 04             	lea    0x4(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 04             	sub    $0x4,%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	99                   	cltd   
}
  800702:	5d                   	pop    %ebp
  800703:	c3                   	ret    

00800704 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	56                   	push   %esi
  800708:	53                   	push   %ebx
  800709:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070c:	eb 17                	jmp    800725 <vprintfmt+0x21>
			if (ch == '\0')
  80070e:	85 db                	test   %ebx,%ebx
  800710:	0f 84 af 03 00 00    	je     800ac5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	53                   	push   %ebx
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	ff d0                	call   *%eax
  800722:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800725:	8b 45 10             	mov    0x10(%ebp),%eax
  800728:	8d 50 01             	lea    0x1(%eax),%edx
  80072b:	89 55 10             	mov    %edx,0x10(%ebp)
  80072e:	8a 00                	mov    (%eax),%al
  800730:	0f b6 d8             	movzbl %al,%ebx
  800733:	83 fb 25             	cmp    $0x25,%ebx
  800736:	75 d6                	jne    80070e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800738:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80073c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800743:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80074a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800751:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800758:	8b 45 10             	mov    0x10(%ebp),%eax
  80075b:	8d 50 01             	lea    0x1(%eax),%edx
  80075e:	89 55 10             	mov    %edx,0x10(%ebp)
  800761:	8a 00                	mov    (%eax),%al
  800763:	0f b6 d8             	movzbl %al,%ebx
  800766:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800769:	83 f8 55             	cmp    $0x55,%eax
  80076c:	0f 87 2b 03 00 00    	ja     800a9d <vprintfmt+0x399>
  800772:	8b 04 85 d8 27 80 00 	mov    0x8027d8(,%eax,4),%eax
  800779:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80077b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80077f:	eb d7                	jmp    800758 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800781:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800785:	eb d1                	jmp    800758 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800787:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80078e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800791:	89 d0                	mov    %edx,%eax
  800793:	c1 e0 02             	shl    $0x2,%eax
  800796:	01 d0                	add    %edx,%eax
  800798:	01 c0                	add    %eax,%eax
  80079a:	01 d8                	add    %ebx,%eax
  80079c:	83 e8 30             	sub    $0x30,%eax
  80079f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a5:	8a 00                	mov    (%eax),%al
  8007a7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007aa:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ad:	7e 3e                	jle    8007ed <vprintfmt+0xe9>
  8007af:	83 fb 39             	cmp    $0x39,%ebx
  8007b2:	7f 39                	jg     8007ed <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b7:	eb d5                	jmp    80078e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	83 c0 04             	add    $0x4,%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 e8 04             	sub    $0x4,%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007cd:	eb 1f                	jmp    8007ee <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d3:	79 83                	jns    800758 <vprintfmt+0x54>
				width = 0;
  8007d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007dc:	e9 77 ff ff ff       	jmp    800758 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e8:	e9 6b ff ff ff       	jmp    800758 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007ed:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f2:	0f 89 60 ff ff ff    	jns    800758 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007fe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800805:	e9 4e ff ff ff       	jmp    800758 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80080d:	e9 46 ff ff ff       	jmp    800758 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	83 c0 04             	add    $0x4,%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	83 e8 04             	sub    $0x4,%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	ff 75 0c             	pushl  0xc(%ebp)
  800829:	50                   	push   %eax
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	ff d0                	call   *%eax
  80082f:	83 c4 10             	add    $0x10,%esp
			break;
  800832:	e9 89 02 00 00       	jmp    800ac0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	83 c0 04             	add    $0x4,%eax
  80083d:	89 45 14             	mov    %eax,0x14(%ebp)
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	83 e8 04             	sub    $0x4,%eax
  800846:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800848:	85 db                	test   %ebx,%ebx
  80084a:	79 02                	jns    80084e <vprintfmt+0x14a>
				err = -err;
  80084c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80084e:	83 fb 64             	cmp    $0x64,%ebx
  800851:	7f 0b                	jg     80085e <vprintfmt+0x15a>
  800853:	8b 34 9d 20 26 80 00 	mov    0x802620(,%ebx,4),%esi
  80085a:	85 f6                	test   %esi,%esi
  80085c:	75 19                	jne    800877 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085e:	53                   	push   %ebx
  80085f:	68 c5 27 80 00       	push   $0x8027c5
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	ff 75 08             	pushl  0x8(%ebp)
  80086a:	e8 5e 02 00 00       	call   800acd <printfmt>
  80086f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800872:	e9 49 02 00 00       	jmp    800ac0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800877:	56                   	push   %esi
  800878:	68 ce 27 80 00       	push   $0x8027ce
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	ff 75 08             	pushl  0x8(%ebp)
  800883:	e8 45 02 00 00       	call   800acd <printfmt>
  800888:	83 c4 10             	add    $0x10,%esp
			break;
  80088b:	e9 30 02 00 00       	jmp    800ac0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800890:	8b 45 14             	mov    0x14(%ebp),%eax
  800893:	83 c0 04             	add    $0x4,%eax
  800896:	89 45 14             	mov    %eax,0x14(%ebp)
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	83 e8 04             	sub    $0x4,%eax
  80089f:	8b 30                	mov    (%eax),%esi
  8008a1:	85 f6                	test   %esi,%esi
  8008a3:	75 05                	jne    8008aa <vprintfmt+0x1a6>
				p = "(null)";
  8008a5:	be d1 27 80 00       	mov    $0x8027d1,%esi
			if (width > 0 && padc != '-')
  8008aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ae:	7e 6d                	jle    80091d <vprintfmt+0x219>
  8008b0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008b4:	74 67                	je     80091d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	50                   	push   %eax
  8008bd:	56                   	push   %esi
  8008be:	e8 0c 03 00 00       	call   800bcf <strnlen>
  8008c3:	83 c4 10             	add    $0x10,%esp
  8008c6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c9:	eb 16                	jmp    8008e1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008cb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008cf:	83 ec 08             	sub    $0x8,%esp
  8008d2:	ff 75 0c             	pushl  0xc(%ebp)
  8008d5:	50                   	push   %eax
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	ff d0                	call   *%eax
  8008db:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008de:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e5:	7f e4                	jg     8008cb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e7:	eb 34                	jmp    80091d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008ed:	74 1c                	je     80090b <vprintfmt+0x207>
  8008ef:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f2:	7e 05                	jle    8008f9 <vprintfmt+0x1f5>
  8008f4:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f7:	7e 12                	jle    80090b <vprintfmt+0x207>
					putch('?', putdat);
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	ff 75 0c             	pushl  0xc(%ebp)
  8008ff:	6a 3f                	push   $0x3f
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	ff d0                	call   *%eax
  800906:	83 c4 10             	add    $0x10,%esp
  800909:	eb 0f                	jmp    80091a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	ff 75 0c             	pushl  0xc(%ebp)
  800911:	53                   	push   %ebx
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	ff d0                	call   *%eax
  800917:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091a:	ff 4d e4             	decl   -0x1c(%ebp)
  80091d:	89 f0                	mov    %esi,%eax
  80091f:	8d 70 01             	lea    0x1(%eax),%esi
  800922:	8a 00                	mov    (%eax),%al
  800924:	0f be d8             	movsbl %al,%ebx
  800927:	85 db                	test   %ebx,%ebx
  800929:	74 24                	je     80094f <vprintfmt+0x24b>
  80092b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092f:	78 b8                	js     8008e9 <vprintfmt+0x1e5>
  800931:	ff 4d e0             	decl   -0x20(%ebp)
  800934:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800938:	79 af                	jns    8008e9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093a:	eb 13                	jmp    80094f <vprintfmt+0x24b>
				putch(' ', putdat);
  80093c:	83 ec 08             	sub    $0x8,%esp
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	6a 20                	push   $0x20
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094c:	ff 4d e4             	decl   -0x1c(%ebp)
  80094f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800953:	7f e7                	jg     80093c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800955:	e9 66 01 00 00       	jmp    800ac0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	ff 75 e8             	pushl  -0x18(%ebp)
  800960:	8d 45 14             	lea    0x14(%ebp),%eax
  800963:	50                   	push   %eax
  800964:	e8 3c fd ff ff       	call   8006a5 <getint>
  800969:	83 c4 10             	add    $0x10,%esp
  80096c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800975:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800978:	85 d2                	test   %edx,%edx
  80097a:	79 23                	jns    80099f <vprintfmt+0x29b>
				putch('-', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	6a 2d                	push   $0x2d
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	ff d0                	call   *%eax
  800989:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80098c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800992:	f7 d8                	neg    %eax
  800994:	83 d2 00             	adc    $0x0,%edx
  800997:	f7 da                	neg    %edx
  800999:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80099f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a6:	e9 bc 00 00 00       	jmp    800a67 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b4:	50                   	push   %eax
  8009b5:	e8 84 fc ff ff       	call   80063e <getuint>
  8009ba:	83 c4 10             	add    $0x10,%esp
  8009bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009c3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ca:	e9 98 00 00 00       	jmp    800a67 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	ff 75 0c             	pushl  0xc(%ebp)
  8009d5:	6a 58                	push   $0x58
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	ff d0                	call   *%eax
  8009dc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	6a 58                	push   $0x58
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	ff d0                	call   *%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 58                	push   $0x58
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
			break;
  8009ff:	e9 bc 00 00 00       	jmp    800ac0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	6a 30                	push   $0x30
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	ff d0                	call   *%eax
  800a11:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a14:	83 ec 08             	sub    $0x8,%esp
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	6a 78                	push   $0x78
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	ff d0                	call   *%eax
  800a21:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	83 c0 04             	add    $0x4,%eax
  800a2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 e8 04             	sub    $0x4,%eax
  800a33:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a3f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a46:	eb 1f                	jmp    800a67 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a51:	50                   	push   %eax
  800a52:	e8 e7 fb ff ff       	call   80063e <getuint>
  800a57:	83 c4 10             	add    $0x10,%esp
  800a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a60:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a67:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	52                   	push   %edx
  800a72:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a75:	50                   	push   %eax
  800a76:	ff 75 f4             	pushl  -0xc(%ebp)
  800a79:	ff 75 f0             	pushl  -0x10(%ebp)
  800a7c:	ff 75 0c             	pushl  0xc(%ebp)
  800a7f:	ff 75 08             	pushl  0x8(%ebp)
  800a82:	e8 00 fb ff ff       	call   800587 <printnum>
  800a87:	83 c4 20             	add    $0x20,%esp
			break;
  800a8a:	eb 34                	jmp    800ac0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8c:	83 ec 08             	sub    $0x8,%esp
  800a8f:	ff 75 0c             	pushl  0xc(%ebp)
  800a92:	53                   	push   %ebx
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	ff d0                	call   *%eax
  800a98:	83 c4 10             	add    $0x10,%esp
			break;
  800a9b:	eb 23                	jmp    800ac0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a9d:	83 ec 08             	sub    $0x8,%esp
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	6a 25                	push   $0x25
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	ff d0                	call   *%eax
  800aaa:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aad:	ff 4d 10             	decl   0x10(%ebp)
  800ab0:	eb 03                	jmp    800ab5 <vprintfmt+0x3b1>
  800ab2:	ff 4d 10             	decl   0x10(%ebp)
  800ab5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab8:	48                   	dec    %eax
  800ab9:	8a 00                	mov    (%eax),%al
  800abb:	3c 25                	cmp    $0x25,%al
  800abd:	75 f3                	jne    800ab2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800abf:	90                   	nop
		}
	}
  800ac0:	e9 47 fc ff ff       	jmp    80070c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac9:	5b                   	pop    %ebx
  800aca:	5e                   	pop    %esi
  800acb:	5d                   	pop    %ebp
  800acc:	c3                   	ret    

00800acd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ad3:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad6:	83 c0 04             	add    $0x4,%eax
  800ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800adc:	8b 45 10             	mov    0x10(%ebp),%eax
  800adf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae2:	50                   	push   %eax
  800ae3:	ff 75 0c             	pushl  0xc(%ebp)
  800ae6:	ff 75 08             	pushl  0x8(%ebp)
  800ae9:	e8 16 fc ff ff       	call   800704 <vprintfmt>
  800aee:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800af1:	90                   	nop
  800af2:	c9                   	leave  
  800af3:	c3                   	ret    

00800af4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afa:	8b 40 08             	mov    0x8(%eax),%eax
  800afd:	8d 50 01             	lea    0x1(%eax),%edx
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	8b 10                	mov    (%eax),%edx
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	8b 40 04             	mov    0x4(%eax),%eax
  800b11:	39 c2                	cmp    %eax,%edx
  800b13:	73 12                	jae    800b27 <sprintputch+0x33>
		*b->buf++ = ch;
  800b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b18:	8b 00                	mov    (%eax),%eax
  800b1a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b20:	89 0a                	mov    %ecx,(%edx)
  800b22:	8b 55 08             	mov    0x8(%ebp),%edx
  800b25:	88 10                	mov    %dl,(%eax)
}
  800b27:	90                   	nop
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b39:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	01 d0                	add    %edx,%eax
  800b41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b4f:	74 06                	je     800b57 <vsnprintf+0x2d>
  800b51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b55:	7f 07                	jg     800b5e <vsnprintf+0x34>
		return -E_INVAL;
  800b57:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5c:	eb 20                	jmp    800b7e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5e:	ff 75 14             	pushl  0x14(%ebp)
  800b61:	ff 75 10             	pushl  0x10(%ebp)
  800b64:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b67:	50                   	push   %eax
  800b68:	68 f4 0a 80 00       	push   $0x800af4
  800b6d:	e8 92 fb ff ff       	call   800704 <vprintfmt>
  800b72:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b78:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b7e:	c9                   	leave  
  800b7f:	c3                   	ret    

00800b80 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b86:	8d 45 10             	lea    0x10(%ebp),%eax
  800b89:	83 c0 04             	add    $0x4,%eax
  800b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b92:	ff 75 f4             	pushl  -0xc(%ebp)
  800b95:	50                   	push   %eax
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	ff 75 08             	pushl  0x8(%ebp)
  800b9c:	e8 89 ff ff ff       	call   800b2a <vsnprintf>
  800ba1:	83 c4 10             	add    $0x10,%esp
  800ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800baa:	c9                   	leave  
  800bab:	c3                   	ret    

00800bac <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb9:	eb 06                	jmp    800bc1 <strlen+0x15>
		n++;
  800bbb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbe:	ff 45 08             	incl   0x8(%ebp)
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8a 00                	mov    (%eax),%al
  800bc6:	84 c0                	test   %al,%al
  800bc8:	75 f1                	jne    800bbb <strlen+0xf>
		n++;
	return n;
  800bca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bcd:	c9                   	leave  
  800bce:	c3                   	ret    

00800bcf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bdc:	eb 09                	jmp    800be7 <strnlen+0x18>
		n++;
  800bde:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be1:	ff 45 08             	incl   0x8(%ebp)
  800be4:	ff 4d 0c             	decl   0xc(%ebp)
  800be7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800beb:	74 09                	je     800bf6 <strnlen+0x27>
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8a 00                	mov    (%eax),%al
  800bf2:	84 c0                	test   %al,%al
  800bf4:	75 e8                	jne    800bde <strnlen+0xf>
		n++;
	return n;
  800bf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf9:	c9                   	leave  
  800bfa:	c3                   	ret    

00800bfb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c07:	90                   	nop
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c14:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c17:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c1a:	8a 12                	mov    (%edx),%dl
  800c1c:	88 10                	mov    %dl,(%eax)
  800c1e:	8a 00                	mov    (%eax),%al
  800c20:	84 c0                	test   %al,%al
  800c22:	75 e4                	jne    800c08 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c24:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c27:	c9                   	leave  
  800c28:	c3                   	ret    

00800c29 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3c:	eb 1f                	jmp    800c5d <strncpy+0x34>
		*dst++ = *src;
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	8d 50 01             	lea    0x1(%eax),%edx
  800c44:	89 55 08             	mov    %edx,0x8(%ebp)
  800c47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4a:	8a 12                	mov    (%edx),%dl
  800c4c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c51:	8a 00                	mov    (%eax),%al
  800c53:	84 c0                	test   %al,%al
  800c55:	74 03                	je     800c5a <strncpy+0x31>
			src++;
  800c57:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c5a:	ff 45 fc             	incl   -0x4(%ebp)
  800c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c60:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c63:	72 d9                	jb     800c3e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c65:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c68:	c9                   	leave  
  800c69:	c3                   	ret    

00800c6a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7a:	74 30                	je     800cac <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c7c:	eb 16                	jmp    800c94 <strlcpy+0x2a>
			*dst++ = *src++;
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8d 50 01             	lea    0x1(%eax),%edx
  800c84:	89 55 08             	mov    %edx,0x8(%ebp)
  800c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c90:	8a 12                	mov    (%edx),%dl
  800c92:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c94:	ff 4d 10             	decl   0x10(%ebp)
  800c97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9b:	74 09                	je     800ca6 <strlcpy+0x3c>
  800c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	84 c0                	test   %al,%al
  800ca4:	75 d8                	jne    800c7e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb2:	29 c2                	sub    %eax,%edx
  800cb4:	89 d0                	mov    %edx,%eax
}
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    

00800cb8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cbb:	eb 06                	jmp    800cc3 <strcmp+0xb>
		p++, q++;
  800cbd:	ff 45 08             	incl   0x8(%ebp)
  800cc0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	84 c0                	test   %al,%al
  800cca:	74 0e                	je     800cda <strcmp+0x22>
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 10                	mov    (%eax),%dl
  800cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	38 c2                	cmp    %al,%dl
  800cd8:	74 e3                	je     800cbd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	0f b6 d0             	movzbl %al,%edx
  800ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	0f b6 c0             	movzbl %al,%eax
  800cea:	29 c2                	sub    %eax,%edx
  800cec:	89 d0                	mov    %edx,%eax
}
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf3:	eb 09                	jmp    800cfe <strncmp+0xe>
		n--, p++, q++;
  800cf5:	ff 4d 10             	decl   0x10(%ebp)
  800cf8:	ff 45 08             	incl   0x8(%ebp)
  800cfb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d02:	74 17                	je     800d1b <strncmp+0x2b>
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8a 00                	mov    (%eax),%al
  800d09:	84 c0                	test   %al,%al
  800d0b:	74 0e                	je     800d1b <strncmp+0x2b>
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 10                	mov    (%eax),%dl
  800d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d15:	8a 00                	mov    (%eax),%al
  800d17:	38 c2                	cmp    %al,%dl
  800d19:	74 da                	je     800cf5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1f:	75 07                	jne    800d28 <strncmp+0x38>
		return 0;
  800d21:	b8 00 00 00 00       	mov    $0x0,%eax
  800d26:	eb 14                	jmp    800d3c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	0f b6 d0             	movzbl %al,%edx
  800d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	0f b6 c0             	movzbl %al,%eax
  800d38:	29 c2                	sub    %eax,%edx
  800d3a:	89 d0                	mov    %edx,%eax
}
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    

00800d3e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	83 ec 04             	sub    $0x4,%esp
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d4a:	eb 12                	jmp    800d5e <strchr+0x20>
		if (*s == c)
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d54:	75 05                	jne    800d5b <strchr+0x1d>
			return (char *) s;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	eb 11                	jmp    800d6c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d5b:	ff 45 08             	incl   0x8(%ebp)
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	84 c0                	test   %al,%al
  800d65:	75 e5                	jne    800d4c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6c:	c9                   	leave  
  800d6d:	c3                   	ret    

00800d6e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	83 ec 04             	sub    $0x4,%esp
  800d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d77:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7a:	eb 0d                	jmp    800d89 <strfind+0x1b>
		if (*s == c)
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8a 00                	mov    (%eax),%al
  800d81:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d84:	74 0e                	je     800d94 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d86:	ff 45 08             	incl   0x8(%ebp)
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	75 ea                	jne    800d7c <strfind+0xe>
  800d92:	eb 01                	jmp    800d95 <strfind+0x27>
		if (*s == c)
			break;
  800d94:	90                   	nop
	return (char *) s;
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d98:	c9                   	leave  
  800d99:	c3                   	ret    

00800d9a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da6:	8b 45 10             	mov    0x10(%ebp),%eax
  800da9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dac:	eb 0e                	jmp    800dbc <memset+0x22>
		*p++ = c;
  800dae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db1:	8d 50 01             	lea    0x1(%eax),%edx
  800db4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dba:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dbc:	ff 4d f8             	decl   -0x8(%ebp)
  800dbf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dc3:	79 e9                	jns    800dae <memset+0x14>
		*p++ = c;

	return v;
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc8:	c9                   	leave  
  800dc9:	c3                   	ret    

00800dca <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ddc:	eb 16                	jmp    800df4 <memcpy+0x2a>
		*d++ = *s++;
  800dde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de1:	8d 50 01             	lea    0x1(%eax),%edx
  800de4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ded:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df0:	8a 12                	mov    (%edx),%dl
  800df2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800df4:	8b 45 10             	mov    0x10(%ebp),%eax
  800df7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfa:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfd:	85 c0                	test   %eax,%eax
  800dff:	75 dd                	jne    800dde <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1e:	73 50                	jae    800e70 <memmove+0x6a>
  800e20:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e23:	8b 45 10             	mov    0x10(%ebp),%eax
  800e26:	01 d0                	add    %edx,%eax
  800e28:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2b:	76 43                	jbe    800e70 <memmove+0x6a>
		s += n;
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e33:	8b 45 10             	mov    0x10(%ebp),%eax
  800e36:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e39:	eb 10                	jmp    800e4b <memmove+0x45>
			*--d = *--s;
  800e3b:	ff 4d f8             	decl   -0x8(%ebp)
  800e3e:	ff 4d fc             	decl   -0x4(%ebp)
  800e41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e44:	8a 10                	mov    (%eax),%dl
  800e46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e49:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e51:	89 55 10             	mov    %edx,0x10(%ebp)
  800e54:	85 c0                	test   %eax,%eax
  800e56:	75 e3                	jne    800e3b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e58:	eb 23                	jmp    800e7d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5d:	8d 50 01             	lea    0x1(%eax),%edx
  800e60:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e69:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e6c:	8a 12                	mov    (%edx),%dl
  800e6e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e70:	8b 45 10             	mov    0x10(%ebp),%eax
  800e73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e76:	89 55 10             	mov    %edx,0x10(%ebp)
  800e79:	85 c0                	test   %eax,%eax
  800e7b:	75 dd                	jne    800e5a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e80:	c9                   	leave  
  800e81:	c3                   	ret    

00800e82 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e94:	eb 2a                	jmp    800ec0 <memcmp+0x3e>
		if (*s1 != *s2)
  800e96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e99:	8a 10                	mov    (%eax),%dl
  800e9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9e:	8a 00                	mov    (%eax),%al
  800ea0:	38 c2                	cmp    %al,%dl
  800ea2:	74 16                	je     800eba <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	0f b6 d0             	movzbl %al,%edx
  800eac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaf:	8a 00                	mov    (%eax),%al
  800eb1:	0f b6 c0             	movzbl %al,%eax
  800eb4:	29 c2                	sub    %eax,%edx
  800eb6:	89 d0                	mov    %edx,%eax
  800eb8:	eb 18                	jmp    800ed2 <memcmp+0x50>
		s1++, s2++;
  800eba:	ff 45 fc             	incl   -0x4(%ebp)
  800ebd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec9:	85 c0                	test   %eax,%eax
  800ecb:	75 c9                	jne    800e96 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ecd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed2:	c9                   	leave  
  800ed3:	c3                   	ret    

00800ed4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eda:	8b 55 08             	mov    0x8(%ebp),%edx
  800edd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee5:	eb 15                	jmp    800efc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8a 00                	mov    (%eax),%al
  800eec:	0f b6 d0             	movzbl %al,%edx
  800eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef2:	0f b6 c0             	movzbl %al,%eax
  800ef5:	39 c2                	cmp    %eax,%edx
  800ef7:	74 0d                	je     800f06 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef9:	ff 45 08             	incl   0x8(%ebp)
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f02:	72 e3                	jb     800ee7 <memfind+0x13>
  800f04:	eb 01                	jmp    800f07 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f06:	90                   	nop
	return (void *) s;
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f19:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f20:	eb 03                	jmp    800f25 <strtol+0x19>
		s++;
  800f22:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	3c 20                	cmp    $0x20,%al
  800f2c:	74 f4                	je     800f22 <strtol+0x16>
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 09                	cmp    $0x9,%al
  800f35:	74 eb                	je     800f22 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	3c 2b                	cmp    $0x2b,%al
  800f3e:	75 05                	jne    800f45 <strtol+0x39>
		s++;
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	eb 13                	jmp    800f58 <strtol+0x4c>
	else if (*s == '-')
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	3c 2d                	cmp    $0x2d,%al
  800f4c:	75 0a                	jne    800f58 <strtol+0x4c>
		s++, neg = 1;
  800f4e:	ff 45 08             	incl   0x8(%ebp)
  800f51:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5c:	74 06                	je     800f64 <strtol+0x58>
  800f5e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f62:	75 20                	jne    800f84 <strtol+0x78>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	3c 30                	cmp    $0x30,%al
  800f6b:	75 17                	jne    800f84 <strtol+0x78>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	40                   	inc    %eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 78                	cmp    $0x78,%al
  800f75:	75 0d                	jne    800f84 <strtol+0x78>
		s += 2, base = 16;
  800f77:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f7b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f82:	eb 28                	jmp    800fac <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	75 15                	jne    800f9f <strtol+0x93>
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8a 00                	mov    (%eax),%al
  800f8f:	3c 30                	cmp    $0x30,%al
  800f91:	75 0c                	jne    800f9f <strtol+0x93>
		s++, base = 8;
  800f93:	ff 45 08             	incl   0x8(%ebp)
  800f96:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f9d:	eb 0d                	jmp    800fac <strtol+0xa0>
	else if (base == 0)
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	75 07                	jne    800fac <strtol+0xa0>
		base = 10;
  800fa5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3c 2f                	cmp    $0x2f,%al
  800fb3:	7e 19                	jle    800fce <strtol+0xc2>
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 39                	cmp    $0x39,%al
  800fbc:	7f 10                	jg     800fce <strtol+0xc2>
			dig = *s - '0';
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	0f be c0             	movsbl %al,%eax
  800fc6:	83 e8 30             	sub    $0x30,%eax
  800fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fcc:	eb 42                	jmp    801010 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	3c 60                	cmp    $0x60,%al
  800fd5:	7e 19                	jle    800ff0 <strtol+0xe4>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 7a                	cmp    $0x7a,%al
  800fde:	7f 10                	jg     800ff0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	0f be c0             	movsbl %al,%eax
  800fe8:	83 e8 57             	sub    $0x57,%eax
  800feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fee:	eb 20                	jmp    801010 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	3c 40                	cmp    $0x40,%al
  800ff7:	7e 39                	jle    801032 <strtol+0x126>
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 5a                	cmp    $0x5a,%al
  801000:	7f 30                	jg     801032 <strtol+0x126>
			dig = *s - 'A' + 10;
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	0f be c0             	movsbl %al,%eax
  80100a:	83 e8 37             	sub    $0x37,%eax
  80100d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801013:	3b 45 10             	cmp    0x10(%ebp),%eax
  801016:	7d 19                	jge    801031 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801018:	ff 45 08             	incl   0x8(%ebp)
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801022:	89 c2                	mov    %eax,%edx
  801024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801027:	01 d0                	add    %edx,%eax
  801029:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80102c:	e9 7b ff ff ff       	jmp    800fac <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801031:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801032:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801036:	74 08                	je     801040 <strtol+0x134>
		*endptr = (char *) s;
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	8b 55 08             	mov    0x8(%ebp),%edx
  80103e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801040:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801044:	74 07                	je     80104d <strtol+0x141>
  801046:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801049:	f7 d8                	neg    %eax
  80104b:	eb 03                	jmp    801050 <strtol+0x144>
  80104d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <ltostr>:

void
ltostr(long value, char *str)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801058:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80105f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801066:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106a:	79 13                	jns    80107f <ltostr+0x2d>
	{
		neg = 1;
  80106c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801079:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80107c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801087:	99                   	cltd   
  801088:	f7 f9                	idiv   %ecx
  80108a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801090:	8d 50 01             	lea    0x1(%eax),%edx
  801093:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801096:	89 c2                	mov    %eax,%edx
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	01 d0                	add    %edx,%eax
  80109d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a0:	83 c2 30             	add    $0x30,%edx
  8010a3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ad:	f7 e9                	imul   %ecx
  8010af:	c1 fa 02             	sar    $0x2,%edx
  8010b2:	89 c8                	mov    %ecx,%eax
  8010b4:	c1 f8 1f             	sar    $0x1f,%eax
  8010b7:	29 c2                	sub    %eax,%edx
  8010b9:	89 d0                	mov    %edx,%eax
  8010bb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c6:	f7 e9                	imul   %ecx
  8010c8:	c1 fa 02             	sar    $0x2,%edx
  8010cb:	89 c8                	mov    %ecx,%eax
  8010cd:	c1 f8 1f             	sar    $0x1f,%eax
  8010d0:	29 c2                	sub    %eax,%edx
  8010d2:	89 d0                	mov    %edx,%eax
  8010d4:	c1 e0 02             	shl    $0x2,%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	01 c0                	add    %eax,%eax
  8010db:	29 c1                	sub    %eax,%ecx
  8010dd:	89 ca                	mov    %ecx,%edx
  8010df:	85 d2                	test   %edx,%edx
  8010e1:	75 9c                	jne    80107f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ed:	48                   	dec    %eax
  8010ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f5:	74 3d                	je     801134 <ltostr+0xe2>
		start = 1 ;
  8010f7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010fe:	eb 34                	jmp    801134 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801100:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801103:	8b 45 0c             	mov    0xc(%ebp),%eax
  801106:	01 d0                	add    %edx,%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80110d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801110:	8b 45 0c             	mov    0xc(%ebp),%eax
  801113:	01 c2                	add    %eax,%edx
  801115:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	01 c8                	add    %ecx,%eax
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801121:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 c2                	add    %eax,%edx
  801129:	8a 45 eb             	mov    -0x15(%ebp),%al
  80112c:	88 02                	mov    %al,(%edx)
		start++ ;
  80112e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801131:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801137:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80113a:	7c c4                	jl     801100 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80113c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	01 d0                	add    %edx,%eax
  801144:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801147:	90                   	nop
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801150:	ff 75 08             	pushl  0x8(%ebp)
  801153:	e8 54 fa ff ff       	call   800bac <strlen>
  801158:	83 c4 04             	add    $0x4,%esp
  80115b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80115e:	ff 75 0c             	pushl  0xc(%ebp)
  801161:	e8 46 fa ff ff       	call   800bac <strlen>
  801166:	83 c4 04             	add    $0x4,%esp
  801169:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80116c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801173:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117a:	eb 17                	jmp    801193 <strcconcat+0x49>
		final[s] = str1[s] ;
  80117c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117f:	8b 45 10             	mov    0x10(%ebp),%eax
  801182:	01 c2                	add    %eax,%edx
  801184:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	01 c8                	add    %ecx,%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801190:	ff 45 fc             	incl   -0x4(%ebp)
  801193:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801196:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801199:	7c e1                	jl     80117c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80119b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011a2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a9:	eb 1f                	jmp    8011ca <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ae:	8d 50 01             	lea    0x1(%eax),%edx
  8011b1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011b4:	89 c2                	mov    %eax,%edx
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	01 c2                	add    %eax,%edx
  8011bb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	01 c8                	add    %ecx,%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c7:	ff 45 f8             	incl   -0x8(%ebp)
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d0:	7c d9                	jl     8011ab <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d8:	01 d0                	add    %edx,%eax
  8011da:	c6 00 00             	movb   $0x0,(%eax)
}
  8011dd:	90                   	nop
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ef:	8b 00                	mov    (%eax),%eax
  8011f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fb:	01 d0                	add    %edx,%eax
  8011fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801203:	eb 0c                	jmp    801211 <strsplit+0x31>
			*string++ = 0;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8d 50 01             	lea    0x1(%eax),%edx
  80120b:	89 55 08             	mov    %edx,0x8(%ebp)
  80120e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	84 c0                	test   %al,%al
  801218:	74 18                	je     801232 <strsplit+0x52>
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	0f be c0             	movsbl %al,%eax
  801222:	50                   	push   %eax
  801223:	ff 75 0c             	pushl  0xc(%ebp)
  801226:	e8 13 fb ff ff       	call   800d3e <strchr>
  80122b:	83 c4 08             	add    $0x8,%esp
  80122e:	85 c0                	test   %eax,%eax
  801230:	75 d3                	jne    801205 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	8a 00                	mov    (%eax),%al
  801237:	84 c0                	test   %al,%al
  801239:	74 5a                	je     801295 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80123b:	8b 45 14             	mov    0x14(%ebp),%eax
  80123e:	8b 00                	mov    (%eax),%eax
  801240:	83 f8 0f             	cmp    $0xf,%eax
  801243:	75 07                	jne    80124c <strsplit+0x6c>
		{
			return 0;
  801245:	b8 00 00 00 00       	mov    $0x0,%eax
  80124a:	eb 66                	jmp    8012b2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80124c:	8b 45 14             	mov    0x14(%ebp),%eax
  80124f:	8b 00                	mov    (%eax),%eax
  801251:	8d 48 01             	lea    0x1(%eax),%ecx
  801254:	8b 55 14             	mov    0x14(%ebp),%edx
  801257:	89 0a                	mov    %ecx,(%edx)
  801259:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	01 c2                	add    %eax,%edx
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126a:	eb 03                	jmp    80126f <strsplit+0x8f>
			string++;
  80126c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	84 c0                	test   %al,%al
  801276:	74 8b                	je     801203 <strsplit+0x23>
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	0f be c0             	movsbl %al,%eax
  801280:	50                   	push   %eax
  801281:	ff 75 0c             	pushl  0xc(%ebp)
  801284:	e8 b5 fa ff ff       	call   800d3e <strchr>
  801289:	83 c4 08             	add    $0x8,%esp
  80128c:	85 c0                	test   %eax,%eax
  80128e:	74 dc                	je     80126c <strsplit+0x8c>
			string++;
	}
  801290:	e9 6e ff ff ff       	jmp    801203 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801295:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801296:	8b 45 14             	mov    0x14(%ebp),%eax
  801299:	8b 00                	mov    (%eax),%eax
  80129b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a5:	01 d0                	add    %edx,%eax
  8012a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ad:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8012ba:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8012c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8012c7:	01 d0                	add    %edx,%eax
  8012c9:	48                   	dec    %eax
  8012ca:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8012cd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8012d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d5:	f7 75 ac             	divl   -0x54(%ebp)
  8012d8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8012db:	29 d0                	sub    %edx,%eax
  8012dd:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8012e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8012e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8012ee:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8012f5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8012fc:	eb 3f                	jmp    80133d <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8012fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801301:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801308:	83 ec 04             	sub    $0x4,%esp
  80130b:	50                   	push   %eax
  80130c:	ff 75 e8             	pushl  -0x18(%ebp)
  80130f:	68 30 29 80 00       	push   $0x802930
  801314:	e8 11 f2 ff ff       	call   80052a <cprintf>
  801319:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  80131c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80131f:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801326:	83 ec 04             	sub    $0x4,%esp
  801329:	50                   	push   %eax
  80132a:	ff 75 e8             	pushl  -0x18(%ebp)
  80132d:	68 45 29 80 00       	push   $0x802945
  801332:	e8 f3 f1 ff ff       	call   80052a <cprintf>
  801337:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  80133a:	ff 45 e8             	incl   -0x18(%ebp)
  80133d:	a1 28 30 80 00       	mov    0x803028,%eax
  801342:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801345:	7c b7                	jl     8012fe <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801347:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  80134e:	e9 42 01 00 00       	jmp    801495 <malloc+0x1e1>
		int flag0=1;
  801353:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  80135a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80135d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801360:	eb 6b                	jmp    8013cd <malloc+0x119>
			for(int k=0;k<count;k++){
  801362:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801369:	eb 42                	jmp    8013ad <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  80136b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80136e:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801375:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801378:	39 c2                	cmp    %eax,%edx
  80137a:	77 2e                	ja     8013aa <malloc+0xf6>
  80137c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80137f:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801386:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801389:	39 c2                	cmp    %eax,%edx
  80138b:	76 1d                	jbe    8013aa <malloc+0xf6>
					ni=arr_add[k].end-i;
  80138d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801390:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801397:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80139a:	29 c2                	sub    %eax,%edx
  80139c:	89 d0                	mov    %edx,%eax
  80139e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  8013a1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8013a8:	eb 0d                	jmp    8013b7 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8013aa:	ff 45 d8             	incl   -0x28(%ebp)
  8013ad:	a1 28 30 80 00       	mov    0x803028,%eax
  8013b2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8013b5:	7c b4                	jl     80136b <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8013b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013bb:	74 09                	je     8013c6 <malloc+0x112>
				flag0=0;
  8013bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8013c4:	eb 16                	jmp    8013dc <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8013c6:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8013cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	01 c2                	add    %eax,%edx
  8013d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013d8:	39 c2                	cmp    %eax,%edx
  8013da:	77 86                	ja     801362 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8013dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013e0:	0f 84 a2 00 00 00    	je     801488 <malloc+0x1d4>

			int f=1;
  8013e6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  8013ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013f0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8013f3:	89 c8                	mov    %ecx,%eax
  8013f5:	01 c0                	add    %eax,%eax
  8013f7:	01 c8                	add    %ecx,%eax
  8013f9:	c1 e0 02             	shl    $0x2,%eax
  8013fc:	05 20 31 80 00       	add    $0x803120,%eax
  801401:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801403:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80140c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140f:	89 d0                	mov    %edx,%eax
  801411:	01 c0                	add    %eax,%eax
  801413:	01 d0                	add    %edx,%eax
  801415:	c1 e0 02             	shl    $0x2,%eax
  801418:	05 24 31 80 00       	add    $0x803124,%eax
  80141d:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  80141f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801422:	89 d0                	mov    %edx,%eax
  801424:	01 c0                	add    %eax,%eax
  801426:	01 d0                	add    %edx,%eax
  801428:	c1 e0 02             	shl    $0x2,%eax
  80142b:	05 28 31 80 00       	add    $0x803128,%eax
  801430:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801436:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801439:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801440:	eb 36                	jmp    801478 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801442:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	01 c2                	add    %eax,%edx
  80144a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80144d:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801454:	39 c2                	cmp    %eax,%edx
  801456:	73 1d                	jae    801475 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801458:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80145b:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801462:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801465:	29 c2                	sub    %eax,%edx
  801467:	89 d0                	mov    %edx,%eax
  801469:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  80146c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801473:	eb 0d                	jmp    801482 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801475:	ff 45 d0             	incl   -0x30(%ebp)
  801478:	a1 28 30 80 00       	mov    0x803028,%eax
  80147d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801480:	7c c0                	jl     801442 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801482:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801486:	75 1d                	jne    8014a5 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801488:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  80148f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801492:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801495:	a1 04 30 80 00       	mov    0x803004,%eax
  80149a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80149d:	0f 8c b0 fe ff ff    	jl     801353 <malloc+0x9f>
  8014a3:	eb 01                	jmp    8014a6 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  8014a5:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8014a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014aa:	75 7a                	jne    801526 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  8014ac:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	01 d0                	add    %edx,%eax
  8014b7:	48                   	dec    %eax
  8014b8:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8014bd:	7c 0a                	jl     8014c9 <malloc+0x215>
			return NULL;
  8014bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c4:	e9 a4 02 00 00       	jmp    80176d <malloc+0x4b9>
		else{
			uint32 s=base_add;
  8014c9:	a1 04 30 80 00       	mov    0x803004,%eax
  8014ce:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8014d1:	a1 28 30 80 00       	mov    0x803028,%eax
  8014d6:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8014d9:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  8014e0:	83 ec 08             	sub    $0x8,%esp
  8014e3:	ff 75 08             	pushl  0x8(%ebp)
  8014e6:	ff 75 a4             	pushl  -0x5c(%ebp)
  8014e9:	e8 04 06 00 00       	call   801af2 <sys_allocateMem>
  8014ee:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  8014f1:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	01 d0                	add    %edx,%eax
  8014fc:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  801501:	a1 28 30 80 00       	mov    0x803028,%eax
  801506:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80150c:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  801513:	a1 28 30 80 00       	mov    0x803028,%eax
  801518:	40                   	inc    %eax
  801519:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  80151e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801521:	e9 47 02 00 00       	jmp    80176d <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801526:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80152d:	e9 ac 00 00 00       	jmp    8015de <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801532:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801535:	89 d0                	mov    %edx,%eax
  801537:	01 c0                	add    %eax,%eax
  801539:	01 d0                	add    %edx,%eax
  80153b:	c1 e0 02             	shl    $0x2,%eax
  80153e:	05 24 31 80 00       	add    $0x803124,%eax
  801543:	8b 00                	mov    (%eax),%eax
  801545:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801548:	eb 7e                	jmp    8015c8 <malloc+0x314>
			int flag=0;
  80154a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801551:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801558:	eb 57                	jmp    8015b1 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  80155a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80155d:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801564:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801567:	39 c2                	cmp    %eax,%edx
  801569:	77 1a                	ja     801585 <malloc+0x2d1>
  80156b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80156e:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801575:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801578:	39 c2                	cmp    %eax,%edx
  80157a:	76 09                	jbe    801585 <malloc+0x2d1>
								flag=1;
  80157c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801583:	eb 36                	jmp    8015bb <malloc+0x307>
			arr[i].space++;
  801585:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801588:	89 d0                	mov    %edx,%eax
  80158a:	01 c0                	add    %eax,%eax
  80158c:	01 d0                	add    %edx,%eax
  80158e:	c1 e0 02             	shl    $0x2,%eax
  801591:	05 28 31 80 00       	add    $0x803128,%eax
  801596:	8b 00                	mov    (%eax),%eax
  801598:	8d 48 01             	lea    0x1(%eax),%ecx
  80159b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80159e:	89 d0                	mov    %edx,%eax
  8015a0:	01 c0                	add    %eax,%eax
  8015a2:	01 d0                	add    %edx,%eax
  8015a4:	c1 e0 02             	shl    $0x2,%eax
  8015a7:	05 28 31 80 00       	add    $0x803128,%eax
  8015ac:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  8015ae:	ff 45 c0             	incl   -0x40(%ebp)
  8015b1:	a1 28 30 80 00       	mov    0x803028,%eax
  8015b6:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  8015b9:	7c 9f                	jl     80155a <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  8015bb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8015bf:	75 19                	jne    8015da <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8015c1:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8015c8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8015cb:	a1 04 30 80 00       	mov    0x803004,%eax
  8015d0:	39 c2                	cmp    %eax,%edx
  8015d2:	0f 82 72 ff ff ff    	jb     80154a <malloc+0x296>
  8015d8:	eb 01                	jmp    8015db <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  8015da:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  8015db:	ff 45 cc             	incl   -0x34(%ebp)
  8015de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8015e1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015e4:	0f 8c 48 ff ff ff    	jl     801532 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  8015ea:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  8015f1:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  8015f8:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  8015ff:	eb 37                	jmp    801638 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801601:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801604:	89 d0                	mov    %edx,%eax
  801606:	01 c0                	add    %eax,%eax
  801608:	01 d0                	add    %edx,%eax
  80160a:	c1 e0 02             	shl    $0x2,%eax
  80160d:	05 28 31 80 00       	add    $0x803128,%eax
  801612:	8b 00                	mov    (%eax),%eax
  801614:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801617:	7d 1c                	jge    801635 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801619:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80161c:	89 d0                	mov    %edx,%eax
  80161e:	01 c0                	add    %eax,%eax
  801620:	01 d0                	add    %edx,%eax
  801622:	c1 e0 02             	shl    $0x2,%eax
  801625:	05 28 31 80 00       	add    $0x803128,%eax
  80162a:	8b 00                	mov    (%eax),%eax
  80162c:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  80162f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801632:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801635:	ff 45 b4             	incl   -0x4c(%ebp)
  801638:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80163b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80163e:	7c c1                	jl     801601 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801640:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801646:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801649:	89 c8                	mov    %ecx,%eax
  80164b:	01 c0                	add    %eax,%eax
  80164d:	01 c8                	add    %ecx,%eax
  80164f:	c1 e0 02             	shl    $0x2,%eax
  801652:	05 20 31 80 00       	add    $0x803120,%eax
  801657:	8b 00                	mov    (%eax),%eax
  801659:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801660:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801666:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801669:	89 c8                	mov    %ecx,%eax
  80166b:	01 c0                	add    %eax,%eax
  80166d:	01 c8                	add    %ecx,%eax
  80166f:	c1 e0 02             	shl    $0x2,%eax
  801672:	05 24 31 80 00       	add    $0x803124,%eax
  801677:	8b 00                	mov    (%eax),%eax
  801679:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  801680:	a1 28 30 80 00       	mov    0x803028,%eax
  801685:	40                   	inc    %eax
  801686:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  80168b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80168e:	89 d0                	mov    %edx,%eax
  801690:	01 c0                	add    %eax,%eax
  801692:	01 d0                	add    %edx,%eax
  801694:	c1 e0 02             	shl    $0x2,%eax
  801697:	05 20 31 80 00       	add    $0x803120,%eax
  80169c:	8b 00                	mov    (%eax),%eax
  80169e:	83 ec 08             	sub    $0x8,%esp
  8016a1:	ff 75 08             	pushl  0x8(%ebp)
  8016a4:	50                   	push   %eax
  8016a5:	e8 48 04 00 00       	call   801af2 <sys_allocateMem>
  8016aa:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  8016ad:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8016b4:	eb 78                	jmp    80172e <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8016b6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8016b9:	89 d0                	mov    %edx,%eax
  8016bb:	01 c0                	add    %eax,%eax
  8016bd:	01 d0                	add    %edx,%eax
  8016bf:	c1 e0 02             	shl    $0x2,%eax
  8016c2:	05 20 31 80 00       	add    $0x803120,%eax
  8016c7:	8b 00                	mov    (%eax),%eax
  8016c9:	83 ec 04             	sub    $0x4,%esp
  8016cc:	50                   	push   %eax
  8016cd:	ff 75 b0             	pushl  -0x50(%ebp)
  8016d0:	68 30 29 80 00       	push   $0x802930
  8016d5:	e8 50 ee ff ff       	call   80052a <cprintf>
  8016da:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8016dd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8016e0:	89 d0                	mov    %edx,%eax
  8016e2:	01 c0                	add    %eax,%eax
  8016e4:	01 d0                	add    %edx,%eax
  8016e6:	c1 e0 02             	shl    $0x2,%eax
  8016e9:	05 24 31 80 00       	add    $0x803124,%eax
  8016ee:	8b 00                	mov    (%eax),%eax
  8016f0:	83 ec 04             	sub    $0x4,%esp
  8016f3:	50                   	push   %eax
  8016f4:	ff 75 b0             	pushl  -0x50(%ebp)
  8016f7:	68 45 29 80 00       	push   $0x802945
  8016fc:	e8 29 ee ff ff       	call   80052a <cprintf>
  801701:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801704:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801707:	89 d0                	mov    %edx,%eax
  801709:	01 c0                	add    %eax,%eax
  80170b:	01 d0                	add    %edx,%eax
  80170d:	c1 e0 02             	shl    $0x2,%eax
  801710:	05 28 31 80 00       	add    $0x803128,%eax
  801715:	8b 00                	mov    (%eax),%eax
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	50                   	push   %eax
  80171b:	ff 75 b0             	pushl  -0x50(%ebp)
  80171e:	68 58 29 80 00       	push   $0x802958
  801723:	e8 02 ee ff ff       	call   80052a <cprintf>
  801728:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  80172b:	ff 45 b0             	incl   -0x50(%ebp)
  80172e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801731:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801734:	7c 80                	jl     8016b6 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801736:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801739:	89 d0                	mov    %edx,%eax
  80173b:	01 c0                	add    %eax,%eax
  80173d:	01 d0                	add    %edx,%eax
  80173f:	c1 e0 02             	shl    $0x2,%eax
  801742:	05 20 31 80 00       	add    $0x803120,%eax
  801747:	8b 00                	mov    (%eax),%eax
  801749:	83 ec 08             	sub    $0x8,%esp
  80174c:	50                   	push   %eax
  80174d:	68 6c 29 80 00       	push   $0x80296c
  801752:	e8 d3 ed ff ff       	call   80052a <cprintf>
  801757:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  80175a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80175d:	89 d0                	mov    %edx,%eax
  80175f:	01 c0                	add    %eax,%eax
  801761:	01 d0                	add    %edx,%eax
  801763:	c1 e0 02             	shl    $0x2,%eax
  801766:	05 20 31 80 00       	add    $0x803120,%eax
  80176b:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  80177b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801782:	eb 4b                	jmp    8017cf <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801784:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801787:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80178e:	89 c2                	mov    %eax,%edx
  801790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801793:	39 c2                	cmp    %eax,%edx
  801795:	7f 35                	jg     8017cc <free+0x5d>
  801797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179a:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8017a1:	89 c2                	mov    %eax,%edx
  8017a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a6:	39 c2                	cmp    %eax,%edx
  8017a8:	7e 22                	jle    8017cc <free+0x5d>
				start=arr_add[i].start;
  8017aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ad:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8017b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8017b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ba:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8017c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8017c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8017ca:	eb 0d                	jmp    8017d9 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8017cc:	ff 45 ec             	incl   -0x14(%ebp)
  8017cf:	a1 28 30 80 00       	mov    0x803028,%eax
  8017d4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8017d7:	7c ab                	jl     801784 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8017d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017dc:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8017e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e6:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8017ed:	29 c2                	sub    %eax,%edx
  8017ef:	89 d0                	mov    %edx,%eax
  8017f1:	83 ec 08             	sub    $0x8,%esp
  8017f4:	50                   	push   %eax
  8017f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f8:	e8 d9 02 00 00       	call   801ad6 <sys_freeMem>
  8017fd:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801803:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801806:	eb 2d                	jmp    801835 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801808:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80180b:	40                   	inc    %eax
  80180c:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801813:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801816:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  80181d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801820:	40                   	inc    %eax
  801821:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801828:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80182b:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801832:	ff 45 e8             	incl   -0x18(%ebp)
  801835:	a1 28 30 80 00       	mov    0x803028,%eax
  80183a:	48                   	dec    %eax
  80183b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80183e:	7f c8                	jg     801808 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801840:	a1 28 30 80 00       	mov    0x803028,%eax
  801845:	48                   	dec    %eax
  801846:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  80184b:	90                   	nop
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	83 ec 18             	sub    $0x18,%esp
  801854:	8b 45 10             	mov    0x10(%ebp),%eax
  801857:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  80185a:	83 ec 04             	sub    $0x4,%esp
  80185d:	68 88 29 80 00       	push   $0x802988
  801862:	68 18 01 00 00       	push   $0x118
  801867:	68 ab 29 80 00       	push   $0x8029ab
  80186c:	e8 17 ea ff ff       	call   800288 <_panic>

00801871 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801877:	83 ec 04             	sub    $0x4,%esp
  80187a:	68 88 29 80 00       	push   $0x802988
  80187f:	68 1e 01 00 00       	push   $0x11e
  801884:	68 ab 29 80 00       	push   $0x8029ab
  801889:	e8 fa e9 ff ff       	call   800288 <_panic>

0080188e <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	68 88 29 80 00       	push   $0x802988
  80189c:	68 24 01 00 00       	push   $0x124
  8018a1:	68 ab 29 80 00       	push   $0x8029ab
  8018a6:	e8 dd e9 ff ff       	call   800288 <_panic>

008018ab <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018b1:	83 ec 04             	sub    $0x4,%esp
  8018b4:	68 88 29 80 00       	push   $0x802988
  8018b9:	68 29 01 00 00       	push   $0x129
  8018be:	68 ab 29 80 00       	push   $0x8029ab
  8018c3:	e8 c0 e9 ff ff       	call   800288 <_panic>

008018c8 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	68 88 29 80 00       	push   $0x802988
  8018d6:	68 2f 01 00 00       	push   $0x12f
  8018db:	68 ab 29 80 00       	push   $0x8029ab
  8018e0:	e8 a3 e9 ff ff       	call   800288 <_panic>

008018e5 <shrink>:
}
void shrink(uint32 newSize)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018eb:	83 ec 04             	sub    $0x4,%esp
  8018ee:	68 88 29 80 00       	push   $0x802988
  8018f3:	68 33 01 00 00       	push   $0x133
  8018f8:	68 ab 29 80 00       	push   $0x8029ab
  8018fd:	e8 86 e9 ff ff       	call   800288 <_panic>

00801902 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	68 88 29 80 00       	push   $0x802988
  801910:	68 38 01 00 00       	push   $0x138
  801915:	68 ab 29 80 00       	push   $0x8029ab
  80191a:	e8 69 e9 ff ff       	call   800288 <_panic>

0080191f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	57                   	push   %edi
  801923:	56                   	push   %esi
  801924:	53                   	push   %ebx
  801925:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801931:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801934:	8b 7d 18             	mov    0x18(%ebp),%edi
  801937:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80193a:	cd 30                	int    $0x30
  80193c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80193f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	5b                   	pop    %ebx
  801946:	5e                   	pop    %esi
  801947:	5f                   	pop    %edi
  801948:	5d                   	pop    %ebp
  801949:	c3                   	ret    

0080194a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	8b 45 10             	mov    0x10(%ebp),%eax
  801953:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801956:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	52                   	push   %edx
  801962:	ff 75 0c             	pushl  0xc(%ebp)
  801965:	50                   	push   %eax
  801966:	6a 00                	push   $0x0
  801968:	e8 b2 ff ff ff       	call   80191f <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
}
  801970:	90                   	nop
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_cgetc>:

int
sys_cgetc(void)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 01                	push   $0x1
  801982:	e8 98 ff ff ff       	call   80191f <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	50                   	push   %eax
  80199b:	6a 05                	push   $0x5
  80199d:	e8 7d ff ff ff       	call   80191f <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 02                	push   $0x2
  8019b6:	e8 64 ff ff ff       	call   80191f <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 03                	push   $0x3
  8019cf:	e8 4b ff ff ff       	call   80191f <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 04                	push   $0x4
  8019e8:	e8 32 ff ff ff       	call   80191f <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_env_exit>:


void sys_env_exit(void)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 06                	push   $0x6
  801a01:	e8 19 ff ff ff       	call   80191f <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	90                   	nop
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	52                   	push   %edx
  801a1c:	50                   	push   %eax
  801a1d:	6a 07                	push   $0x7
  801a1f:	e8 fb fe ff ff       	call   80191f <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	56                   	push   %esi
  801a2d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a2e:	8b 75 18             	mov    0x18(%ebp),%esi
  801a31:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	56                   	push   %esi
  801a3e:	53                   	push   %ebx
  801a3f:	51                   	push   %ecx
  801a40:	52                   	push   %edx
  801a41:	50                   	push   %eax
  801a42:	6a 08                	push   $0x8
  801a44:	e8 d6 fe ff ff       	call   80191f <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4f:	5b                   	pop    %ebx
  801a50:	5e                   	pop    %esi
  801a51:	5d                   	pop    %ebp
  801a52:	c3                   	ret    

00801a53 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	52                   	push   %edx
  801a63:	50                   	push   %eax
  801a64:	6a 09                	push   $0x9
  801a66:	e8 b4 fe ff ff       	call   80191f <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	ff 75 0c             	pushl  0xc(%ebp)
  801a7c:	ff 75 08             	pushl  0x8(%ebp)
  801a7f:	6a 0a                	push   $0xa
  801a81:	e8 99 fe ff ff       	call   80191f <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 0b                	push   $0xb
  801a9a:	e8 80 fe ff ff       	call   80191f <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 0c                	push   $0xc
  801ab3:	e8 67 fe ff ff       	call   80191f <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 0d                	push   $0xd
  801acc:	e8 4e fe ff ff       	call   80191f <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	ff 75 08             	pushl  0x8(%ebp)
  801ae5:	6a 11                	push   $0x11
  801ae7:	e8 33 fe ff ff       	call   80191f <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
	return;
  801aef:	90                   	nop
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	ff 75 08             	pushl  0x8(%ebp)
  801b01:	6a 12                	push   $0x12
  801b03:	e8 17 fe ff ff       	call   80191f <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0b:	90                   	nop
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 0e                	push   $0xe
  801b1d:	e8 fd fd ff ff       	call   80191f <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	ff 75 08             	pushl  0x8(%ebp)
  801b35:	6a 0f                	push   $0xf
  801b37:	e8 e3 fd ff ff       	call   80191f <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 10                	push   $0x10
  801b50:	e8 ca fd ff ff       	call   80191f <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	90                   	nop
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 14                	push   $0x14
  801b6a:	e8 b0 fd ff ff       	call   80191f <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	90                   	nop
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 15                	push   $0x15
  801b84:	e8 96 fd ff ff       	call   80191f <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
}
  801b8c:	90                   	nop
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_cputc>:


void
sys_cputc(const char c)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 04             	sub    $0x4,%esp
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b9b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	50                   	push   %eax
  801ba8:	6a 16                	push   $0x16
  801baa:	e8 70 fd ff ff       	call   80191f <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	90                   	nop
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 17                	push   $0x17
  801bc4:	e8 56 fd ff ff       	call   80191f <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	90                   	nop
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	ff 75 0c             	pushl  0xc(%ebp)
  801bde:	50                   	push   %eax
  801bdf:	6a 18                	push   $0x18
  801be1:	e8 39 fd ff ff       	call   80191f <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	52                   	push   %edx
  801bfb:	50                   	push   %eax
  801bfc:	6a 1b                	push   $0x1b
  801bfe:	e8 1c fd ff ff       	call   80191f <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	52                   	push   %edx
  801c18:	50                   	push   %eax
  801c19:	6a 19                	push   $0x19
  801c1b:	e8 ff fc ff ff       	call   80191f <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	90                   	nop
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	52                   	push   %edx
  801c36:	50                   	push   %eax
  801c37:	6a 1a                	push   $0x1a
  801c39:	e8 e1 fc ff ff       	call   80191f <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	90                   	nop
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 04             	sub    $0x4,%esp
  801c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c50:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c53:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	6a 00                	push   $0x0
  801c5c:	51                   	push   %ecx
  801c5d:	52                   	push   %edx
  801c5e:	ff 75 0c             	pushl  0xc(%ebp)
  801c61:	50                   	push   %eax
  801c62:	6a 1c                	push   $0x1c
  801c64:	e8 b6 fc ff ff       	call   80191f <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	52                   	push   %edx
  801c7e:	50                   	push   %eax
  801c7f:	6a 1d                	push   $0x1d
  801c81:	e8 99 fc ff ff       	call   80191f <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	51                   	push   %ecx
  801c9c:	52                   	push   %edx
  801c9d:	50                   	push   %eax
  801c9e:	6a 1e                	push   $0x1e
  801ca0:	e8 7a fc ff ff       	call   80191f <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	52                   	push   %edx
  801cba:	50                   	push   %eax
  801cbb:	6a 1f                	push   $0x1f
  801cbd:	e8 5d fc ff ff       	call   80191f <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 20                	push   $0x20
  801cd6:	e8 44 fc ff ff       	call   80191f <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	6a 00                	push   $0x0
  801ce8:	ff 75 14             	pushl  0x14(%ebp)
  801ceb:	ff 75 10             	pushl  0x10(%ebp)
  801cee:	ff 75 0c             	pushl  0xc(%ebp)
  801cf1:	50                   	push   %eax
  801cf2:	6a 21                	push   $0x21
  801cf4:	e8 26 fc ff ff       	call   80191f <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	50                   	push   %eax
  801d0d:	6a 22                	push   $0x22
  801d0f:	e8 0b fc ff ff       	call   80191f <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	90                   	nop
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	50                   	push   %eax
  801d29:	6a 23                	push   $0x23
  801d2b:	e8 ef fb ff ff       	call   80191f <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	90                   	nop
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d3c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d3f:	8d 50 04             	lea    0x4(%eax),%edx
  801d42:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	52                   	push   %edx
  801d4c:	50                   	push   %eax
  801d4d:	6a 24                	push   $0x24
  801d4f:	e8 cb fb ff ff       	call   80191f <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
	return result;
  801d57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d60:	89 01                	mov    %eax,(%ecx)
  801d62:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	c9                   	leave  
  801d69:	c2 04 00             	ret    $0x4

00801d6c <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	ff 75 10             	pushl  0x10(%ebp)
  801d76:	ff 75 0c             	pushl  0xc(%ebp)
  801d79:	ff 75 08             	pushl  0x8(%ebp)
  801d7c:	6a 13                	push   $0x13
  801d7e:	e8 9c fb ff ff       	call   80191f <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
	return ;
  801d86:	90                   	nop
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 25                	push   $0x25
  801d98:	e8 82 fb ff ff       	call   80191f <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dae:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	50                   	push   %eax
  801dbb:	6a 26                	push   $0x26
  801dbd:	e8 5d fb ff ff       	call   80191f <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc5:	90                   	nop
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <rsttst>:
void rsttst()
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 28                	push   $0x28
  801dd7:	e8 43 fb ff ff       	call   80191f <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddf:	90                   	nop
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 04             	sub    $0x4,%esp
  801de8:	8b 45 14             	mov    0x14(%ebp),%eax
  801deb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dee:	8b 55 18             	mov    0x18(%ebp),%edx
  801df1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801df5:	52                   	push   %edx
  801df6:	50                   	push   %eax
  801df7:	ff 75 10             	pushl  0x10(%ebp)
  801dfa:	ff 75 0c             	pushl  0xc(%ebp)
  801dfd:	ff 75 08             	pushl  0x8(%ebp)
  801e00:	6a 27                	push   $0x27
  801e02:	e8 18 fb ff ff       	call   80191f <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0a:	90                   	nop
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <chktst>:
void chktst(uint32 n)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	ff 75 08             	pushl  0x8(%ebp)
  801e1b:	6a 29                	push   $0x29
  801e1d:	e8 fd fa ff ff       	call   80191f <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
	return ;
  801e25:	90                   	nop
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <inctst>:

void inctst()
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 2a                	push   $0x2a
  801e37:	e8 e3 fa ff ff       	call   80191f <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3f:	90                   	nop
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <gettst>:
uint32 gettst()
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 2b                	push   $0x2b
  801e51:	e8 c9 fa ff ff       	call   80191f <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 2c                	push   $0x2c
  801e6d:	e8 ad fa ff ff       	call   80191f <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
  801e75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e78:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e7c:	75 07                	jne    801e85 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e83:	eb 05                	jmp    801e8a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 2c                	push   $0x2c
  801e9e:	e8 7c fa ff ff       	call   80191f <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
  801ea6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ea9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ead:	75 07                	jne    801eb6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eaf:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb4:	eb 05                	jmp    801ebb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 2c                	push   $0x2c
  801ecf:	e8 4b fa ff ff       	call   80191f <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
  801ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eda:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ede:	75 07                	jne    801ee7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ee0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee5:	eb 05                	jmp    801eec <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 2c                	push   $0x2c
  801f00:	e8 1a fa ff ff       	call   80191f <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
  801f08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f0b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f0f:	75 07                	jne    801f18 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f11:	b8 01 00 00 00       	mov    $0x1,%eax
  801f16:	eb 05                	jmp    801f1d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	ff 75 08             	pushl  0x8(%ebp)
  801f2d:	6a 2d                	push   $0x2d
  801f2f:	e8 eb f9 ff ff       	call   80191f <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
	return ;
  801f37:	90                   	nop
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f3e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f41:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	6a 00                	push   $0x0
  801f4c:	53                   	push   %ebx
  801f4d:	51                   	push   %ecx
  801f4e:	52                   	push   %edx
  801f4f:	50                   	push   %eax
  801f50:	6a 2e                	push   $0x2e
  801f52:	e8 c8 f9 ff ff       	call   80191f <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
}
  801f5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	52                   	push   %edx
  801f6f:	50                   	push   %eax
  801f70:	6a 2f                	push   $0x2f
  801f72:	e8 a8 f9 ff ff       	call   80191f <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <__udivdi3>:
  801f7c:	55                   	push   %ebp
  801f7d:	57                   	push   %edi
  801f7e:	56                   	push   %esi
  801f7f:	53                   	push   %ebx
  801f80:	83 ec 1c             	sub    $0x1c,%esp
  801f83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f93:	89 ca                	mov    %ecx,%edx
  801f95:	89 f8                	mov    %edi,%eax
  801f97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f9b:	85 f6                	test   %esi,%esi
  801f9d:	75 2d                	jne    801fcc <__udivdi3+0x50>
  801f9f:	39 cf                	cmp    %ecx,%edi
  801fa1:	77 65                	ja     802008 <__udivdi3+0x8c>
  801fa3:	89 fd                	mov    %edi,%ebp
  801fa5:	85 ff                	test   %edi,%edi
  801fa7:	75 0b                	jne    801fb4 <__udivdi3+0x38>
  801fa9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fae:	31 d2                	xor    %edx,%edx
  801fb0:	f7 f7                	div    %edi
  801fb2:	89 c5                	mov    %eax,%ebp
  801fb4:	31 d2                	xor    %edx,%edx
  801fb6:	89 c8                	mov    %ecx,%eax
  801fb8:	f7 f5                	div    %ebp
  801fba:	89 c1                	mov    %eax,%ecx
  801fbc:	89 d8                	mov    %ebx,%eax
  801fbe:	f7 f5                	div    %ebp
  801fc0:	89 cf                	mov    %ecx,%edi
  801fc2:	89 fa                	mov    %edi,%edx
  801fc4:	83 c4 1c             	add    $0x1c,%esp
  801fc7:	5b                   	pop    %ebx
  801fc8:	5e                   	pop    %esi
  801fc9:	5f                   	pop    %edi
  801fca:	5d                   	pop    %ebp
  801fcb:	c3                   	ret    
  801fcc:	39 ce                	cmp    %ecx,%esi
  801fce:	77 28                	ja     801ff8 <__udivdi3+0x7c>
  801fd0:	0f bd fe             	bsr    %esi,%edi
  801fd3:	83 f7 1f             	xor    $0x1f,%edi
  801fd6:	75 40                	jne    802018 <__udivdi3+0x9c>
  801fd8:	39 ce                	cmp    %ecx,%esi
  801fda:	72 0a                	jb     801fe6 <__udivdi3+0x6a>
  801fdc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801fe0:	0f 87 9e 00 00 00    	ja     802084 <__udivdi3+0x108>
  801fe6:	b8 01 00 00 00       	mov    $0x1,%eax
  801feb:	89 fa                	mov    %edi,%edx
  801fed:	83 c4 1c             	add    $0x1c,%esp
  801ff0:	5b                   	pop    %ebx
  801ff1:	5e                   	pop    %esi
  801ff2:	5f                   	pop    %edi
  801ff3:	5d                   	pop    %ebp
  801ff4:	c3                   	ret    
  801ff5:	8d 76 00             	lea    0x0(%esi),%esi
  801ff8:	31 ff                	xor    %edi,%edi
  801ffa:	31 c0                	xor    %eax,%eax
  801ffc:	89 fa                	mov    %edi,%edx
  801ffe:	83 c4 1c             	add    $0x1c,%esp
  802001:	5b                   	pop    %ebx
  802002:	5e                   	pop    %esi
  802003:	5f                   	pop    %edi
  802004:	5d                   	pop    %ebp
  802005:	c3                   	ret    
  802006:	66 90                	xchg   %ax,%ax
  802008:	89 d8                	mov    %ebx,%eax
  80200a:	f7 f7                	div    %edi
  80200c:	31 ff                	xor    %edi,%edi
  80200e:	89 fa                	mov    %edi,%edx
  802010:	83 c4 1c             	add    $0x1c,%esp
  802013:	5b                   	pop    %ebx
  802014:	5e                   	pop    %esi
  802015:	5f                   	pop    %edi
  802016:	5d                   	pop    %ebp
  802017:	c3                   	ret    
  802018:	bd 20 00 00 00       	mov    $0x20,%ebp
  80201d:	89 eb                	mov    %ebp,%ebx
  80201f:	29 fb                	sub    %edi,%ebx
  802021:	89 f9                	mov    %edi,%ecx
  802023:	d3 e6                	shl    %cl,%esi
  802025:	89 c5                	mov    %eax,%ebp
  802027:	88 d9                	mov    %bl,%cl
  802029:	d3 ed                	shr    %cl,%ebp
  80202b:	89 e9                	mov    %ebp,%ecx
  80202d:	09 f1                	or     %esi,%ecx
  80202f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802033:	89 f9                	mov    %edi,%ecx
  802035:	d3 e0                	shl    %cl,%eax
  802037:	89 c5                	mov    %eax,%ebp
  802039:	89 d6                	mov    %edx,%esi
  80203b:	88 d9                	mov    %bl,%cl
  80203d:	d3 ee                	shr    %cl,%esi
  80203f:	89 f9                	mov    %edi,%ecx
  802041:	d3 e2                	shl    %cl,%edx
  802043:	8b 44 24 08          	mov    0x8(%esp),%eax
  802047:	88 d9                	mov    %bl,%cl
  802049:	d3 e8                	shr    %cl,%eax
  80204b:	09 c2                	or     %eax,%edx
  80204d:	89 d0                	mov    %edx,%eax
  80204f:	89 f2                	mov    %esi,%edx
  802051:	f7 74 24 0c          	divl   0xc(%esp)
  802055:	89 d6                	mov    %edx,%esi
  802057:	89 c3                	mov    %eax,%ebx
  802059:	f7 e5                	mul    %ebp
  80205b:	39 d6                	cmp    %edx,%esi
  80205d:	72 19                	jb     802078 <__udivdi3+0xfc>
  80205f:	74 0b                	je     80206c <__udivdi3+0xf0>
  802061:	89 d8                	mov    %ebx,%eax
  802063:	31 ff                	xor    %edi,%edi
  802065:	e9 58 ff ff ff       	jmp    801fc2 <__udivdi3+0x46>
  80206a:	66 90                	xchg   %ax,%ax
  80206c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802070:	89 f9                	mov    %edi,%ecx
  802072:	d3 e2                	shl    %cl,%edx
  802074:	39 c2                	cmp    %eax,%edx
  802076:	73 e9                	jae    802061 <__udivdi3+0xe5>
  802078:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80207b:	31 ff                	xor    %edi,%edi
  80207d:	e9 40 ff ff ff       	jmp    801fc2 <__udivdi3+0x46>
  802082:	66 90                	xchg   %ax,%ax
  802084:	31 c0                	xor    %eax,%eax
  802086:	e9 37 ff ff ff       	jmp    801fc2 <__udivdi3+0x46>
  80208b:	90                   	nop

0080208c <__umoddi3>:
  80208c:	55                   	push   %ebp
  80208d:	57                   	push   %edi
  80208e:	56                   	push   %esi
  80208f:	53                   	push   %ebx
  802090:	83 ec 1c             	sub    $0x1c,%esp
  802093:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802097:	8b 74 24 34          	mov    0x34(%esp),%esi
  80209b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80209f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8020a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020ab:	89 f3                	mov    %esi,%ebx
  8020ad:	89 fa                	mov    %edi,%edx
  8020af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020b3:	89 34 24             	mov    %esi,(%esp)
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	75 1a                	jne    8020d4 <__umoddi3+0x48>
  8020ba:	39 f7                	cmp    %esi,%edi
  8020bc:	0f 86 a2 00 00 00    	jbe    802164 <__umoddi3+0xd8>
  8020c2:	89 c8                	mov    %ecx,%eax
  8020c4:	89 f2                	mov    %esi,%edx
  8020c6:	f7 f7                	div    %edi
  8020c8:	89 d0                	mov    %edx,%eax
  8020ca:	31 d2                	xor    %edx,%edx
  8020cc:	83 c4 1c             	add    $0x1c,%esp
  8020cf:	5b                   	pop    %ebx
  8020d0:	5e                   	pop    %esi
  8020d1:	5f                   	pop    %edi
  8020d2:	5d                   	pop    %ebp
  8020d3:	c3                   	ret    
  8020d4:	39 f0                	cmp    %esi,%eax
  8020d6:	0f 87 ac 00 00 00    	ja     802188 <__umoddi3+0xfc>
  8020dc:	0f bd e8             	bsr    %eax,%ebp
  8020df:	83 f5 1f             	xor    $0x1f,%ebp
  8020e2:	0f 84 ac 00 00 00    	je     802194 <__umoddi3+0x108>
  8020e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8020ed:	29 ef                	sub    %ebp,%edi
  8020ef:	89 fe                	mov    %edi,%esi
  8020f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020f5:	89 e9                	mov    %ebp,%ecx
  8020f7:	d3 e0                	shl    %cl,%eax
  8020f9:	89 d7                	mov    %edx,%edi
  8020fb:	89 f1                	mov    %esi,%ecx
  8020fd:	d3 ef                	shr    %cl,%edi
  8020ff:	09 c7                	or     %eax,%edi
  802101:	89 e9                	mov    %ebp,%ecx
  802103:	d3 e2                	shl    %cl,%edx
  802105:	89 14 24             	mov    %edx,(%esp)
  802108:	89 d8                	mov    %ebx,%eax
  80210a:	d3 e0                	shl    %cl,%eax
  80210c:	89 c2                	mov    %eax,%edx
  80210e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802112:	d3 e0                	shl    %cl,%eax
  802114:	89 44 24 04          	mov    %eax,0x4(%esp)
  802118:	8b 44 24 08          	mov    0x8(%esp),%eax
  80211c:	89 f1                	mov    %esi,%ecx
  80211e:	d3 e8                	shr    %cl,%eax
  802120:	09 d0                	or     %edx,%eax
  802122:	d3 eb                	shr    %cl,%ebx
  802124:	89 da                	mov    %ebx,%edx
  802126:	f7 f7                	div    %edi
  802128:	89 d3                	mov    %edx,%ebx
  80212a:	f7 24 24             	mull   (%esp)
  80212d:	89 c6                	mov    %eax,%esi
  80212f:	89 d1                	mov    %edx,%ecx
  802131:	39 d3                	cmp    %edx,%ebx
  802133:	0f 82 87 00 00 00    	jb     8021c0 <__umoddi3+0x134>
  802139:	0f 84 91 00 00 00    	je     8021d0 <__umoddi3+0x144>
  80213f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802143:	29 f2                	sub    %esi,%edx
  802145:	19 cb                	sbb    %ecx,%ebx
  802147:	89 d8                	mov    %ebx,%eax
  802149:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80214d:	d3 e0                	shl    %cl,%eax
  80214f:	89 e9                	mov    %ebp,%ecx
  802151:	d3 ea                	shr    %cl,%edx
  802153:	09 d0                	or     %edx,%eax
  802155:	89 e9                	mov    %ebp,%ecx
  802157:	d3 eb                	shr    %cl,%ebx
  802159:	89 da                	mov    %ebx,%edx
  80215b:	83 c4 1c             	add    $0x1c,%esp
  80215e:	5b                   	pop    %ebx
  80215f:	5e                   	pop    %esi
  802160:	5f                   	pop    %edi
  802161:	5d                   	pop    %ebp
  802162:	c3                   	ret    
  802163:	90                   	nop
  802164:	89 fd                	mov    %edi,%ebp
  802166:	85 ff                	test   %edi,%edi
  802168:	75 0b                	jne    802175 <__umoddi3+0xe9>
  80216a:	b8 01 00 00 00       	mov    $0x1,%eax
  80216f:	31 d2                	xor    %edx,%edx
  802171:	f7 f7                	div    %edi
  802173:	89 c5                	mov    %eax,%ebp
  802175:	89 f0                	mov    %esi,%eax
  802177:	31 d2                	xor    %edx,%edx
  802179:	f7 f5                	div    %ebp
  80217b:	89 c8                	mov    %ecx,%eax
  80217d:	f7 f5                	div    %ebp
  80217f:	89 d0                	mov    %edx,%eax
  802181:	e9 44 ff ff ff       	jmp    8020ca <__umoddi3+0x3e>
  802186:	66 90                	xchg   %ax,%ax
  802188:	89 c8                	mov    %ecx,%eax
  80218a:	89 f2                	mov    %esi,%edx
  80218c:	83 c4 1c             	add    $0x1c,%esp
  80218f:	5b                   	pop    %ebx
  802190:	5e                   	pop    %esi
  802191:	5f                   	pop    %edi
  802192:	5d                   	pop    %ebp
  802193:	c3                   	ret    
  802194:	3b 04 24             	cmp    (%esp),%eax
  802197:	72 06                	jb     80219f <__umoddi3+0x113>
  802199:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80219d:	77 0f                	ja     8021ae <__umoddi3+0x122>
  80219f:	89 f2                	mov    %esi,%edx
  8021a1:	29 f9                	sub    %edi,%ecx
  8021a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8021a7:	89 14 24             	mov    %edx,(%esp)
  8021aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021b2:	8b 14 24             	mov    (%esp),%edx
  8021b5:	83 c4 1c             	add    $0x1c,%esp
  8021b8:	5b                   	pop    %ebx
  8021b9:	5e                   	pop    %esi
  8021ba:	5f                   	pop    %edi
  8021bb:	5d                   	pop    %ebp
  8021bc:	c3                   	ret    
  8021bd:	8d 76 00             	lea    0x0(%esi),%esi
  8021c0:	2b 04 24             	sub    (%esp),%eax
  8021c3:	19 fa                	sbb    %edi,%edx
  8021c5:	89 d1                	mov    %edx,%ecx
  8021c7:	89 c6                	mov    %eax,%esi
  8021c9:	e9 71 ff ff ff       	jmp    80213f <__umoddi3+0xb3>
  8021ce:	66 90                	xchg   %ax,%ax
  8021d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8021d4:	72 ea                	jb     8021c0 <__umoddi3+0x134>
  8021d6:	89 d9                	mov    %ebx,%ecx
  8021d8:	e9 62 ff ff ff       	jmp    80213f <__umoddi3+0xb3>
