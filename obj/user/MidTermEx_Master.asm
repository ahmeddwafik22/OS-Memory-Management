
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 14 02 00 00       	call   80024a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 00 23 80 00       	push   $0x802300
  80004a:	e8 38 17 00 00       	call   801787 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 04 23 80 00       	push   $0x802304
  800066:	e8 f8 03 00 00       	call   800463 <cprintf>
  80006b:	83 c4 10             	add    $0x10,%esp
	char select = getchar() ;
  80006e:	e8 7f 01 00 00       	call   8001f2 <getchar>
  800073:	88 45 f3             	mov    %al,-0xd(%ebp)
	cputchar(select);
  800076:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  80007a:	83 ec 0c             	sub    $0xc,%esp
  80007d:	50                   	push   %eax
  80007e:	e8 27 01 00 00       	call   8001aa <cputchar>
  800083:	83 c4 10             	add    $0x10,%esp
	cputchar('\n');
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	e8 1a 01 00 00       	call   8001aa <cputchar>
  800090:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 00                	push   $0x0
  800098:	6a 04                	push   $0x4
  80009a:	68 29 23 80 00       	push   $0x802329
  80009f:	e8 e3 16 00 00       	call   801787 <smalloc>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  8000aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  8000b3:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  8000b7:	74 06                	je     8000bf <_main+0x87>
  8000b9:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  8000bd:	75 09                	jne    8000c8 <_main+0x90>
		*useSem = 1 ;
  8000bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  8000c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cb:	8b 00                	mov    (%eax),%eax
  8000cd:	83 f8 01             	cmp    $0x1,%eax
  8000d0:	75 12                	jne    8000e4 <_main+0xac>
	{
		sys_createSemaphore("T", 0);
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	68 30 23 80 00       	push   $0x802330
  8000dc:	e8 27 1a 00 00       	call   801b08 <sys_createSemaphore>
  8000e1:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	6a 01                	push   $0x1
  8000e9:	6a 04                	push   $0x4
  8000eb:	68 32 23 80 00       	push   $0x802332
  8000f0:	e8 92 16 00 00       	call   801787 <smalloc>
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800104:	a1 20 30 80 00       	mov    0x803020,%eax
  800109:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80010f:	a1 20 30 80 00       	mov    0x803020,%eax
  800114:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  80011a:	89 c1                	mov    %eax,%ecx
  80011c:	a1 20 30 80 00       	mov    0x803020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	52                   	push   %edx
  800125:	51                   	push   %ecx
  800126:	50                   	push   %eax
  800127:	68 40 23 80 00       	push   $0x802340
  80012c:	e8 e8 1a 00 00       	call   801c19 <sys_create_env>
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800137:	a1 20 30 80 00       	mov    0x803020,%eax
  80013c:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800142:	a1 20 30 80 00       	mov    0x803020,%eax
  800147:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  80014d:	89 c1                	mov    %eax,%ecx
  80014f:	a1 20 30 80 00       	mov    0x803020,%eax
  800154:	8b 40 74             	mov    0x74(%eax),%eax
  800157:	52                   	push   %edx
  800158:	51                   	push   %ecx
  800159:	50                   	push   %eax
  80015a:	68 4a 23 80 00       	push   $0x80234a
  80015f:	e8 b5 1a 00 00       	call   801c19 <sys_create_env>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800170:	e8 c2 1a 00 00       	call   801c37 <sys_run_env>
  800175:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 b4 1a 00 00       	call   801c37 <sys_run_env>
  800183:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800186:	90                   	nop
  800187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80018a:	8b 00                	mov    (%eax),%eax
  80018c:	83 f8 02             	cmp    $0x2,%eax
  80018f:	75 f6                	jne    800187 <_main+0x14f>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  800191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	50                   	push   %eax
  80019a:	68 54 23 80 00       	push   $0x802354
  80019f:	e8 bf 02 00 00       	call   800463 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp

	return;
  8001a7:	90                   	nop
}
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001b6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	50                   	push   %eax
  8001be:	e8 05 19 00 00       	call   801ac8 <sys_cputc>
  8001c3:	83 c4 10             	add    $0x10,%esp
}
  8001c6:	90                   	nop
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8001cf:	e8 c0 18 00 00       	call   801a94 <sys_disable_interrupt>
	char c = ch;
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001da:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	50                   	push   %eax
  8001e2:	e8 e1 18 00 00       	call   801ac8 <sys_cputc>
  8001e7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ea:	e8 bf 18 00 00       	call   801aae <sys_enable_interrupt>
}
  8001ef:	90                   	nop
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <getchar>:

int
getchar(void)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8001f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8001ff:	eb 08                	jmp    800209 <getchar+0x17>
	{
		c = sys_cgetc();
  800201:	e8 a6 16 00 00       	call   8018ac <sys_cgetc>
  800206:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80020d:	74 f2                	je     800201 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80020f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800212:	c9                   	leave  
  800213:	c3                   	ret    

00800214 <atomic_getchar>:

int
atomic_getchar(void)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80021a:	e8 75 18 00 00       	call   801a94 <sys_disable_interrupt>
	int c=0;
  80021f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800226:	eb 08                	jmp    800230 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800228:	e8 7f 16 00 00       	call   8018ac <sys_cgetc>
  80022d:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800230:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800234:	74 f2                	je     800228 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800236:	e8 73 18 00 00       	call   801aae <sys_enable_interrupt>
	return c;
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <iscons>:

int iscons(int fdnum)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800243:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800248:	5d                   	pop    %ebp
  800249:	c3                   	ret    

0080024a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800250:	e8 a4 16 00 00       	call   8018f9 <sys_getenvindex>
  800255:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80025b:	89 d0                	mov    %edx,%eax
  80025d:	c1 e0 03             	shl    $0x3,%eax
  800260:	01 d0                	add    %edx,%eax
  800262:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800269:	01 c8                	add    %ecx,%eax
  80026b:	01 c0                	add    %eax,%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	01 c0                	add    %eax,%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	89 c2                	mov    %eax,%edx
  800275:	c1 e2 05             	shl    $0x5,%edx
  800278:	29 c2                	sub    %eax,%edx
  80027a:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800281:	89 c2                	mov    %eax,%edx
  800283:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800289:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80028e:	a1 20 30 80 00       	mov    0x803020,%eax
  800293:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800299:	84 c0                	test   %al,%al
  80029b:	74 0f                	je     8002ac <libmain+0x62>
		binaryname = myEnv->prog_name;
  80029d:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a2:	05 40 3c 01 00       	add    $0x13c40,%eax
  8002a7:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002b0:	7e 0a                	jle    8002bc <libmain+0x72>
		binaryname = argv[0];
  8002b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8002bc:	83 ec 08             	sub    $0x8,%esp
  8002bf:	ff 75 0c             	pushl  0xc(%ebp)
  8002c2:	ff 75 08             	pushl  0x8(%ebp)
  8002c5:	e8 6e fd ff ff       	call   800038 <_main>
  8002ca:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002cd:	e8 c2 17 00 00       	call   801a94 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002d2:	83 ec 0c             	sub    $0xc,%esp
  8002d5:	68 84 23 80 00       	push   $0x802384
  8002da:	e8 84 01 00 00       	call   800463 <cprintf>
  8002df:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e7:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8002ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f2:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	52                   	push   %edx
  8002fc:	50                   	push   %eax
  8002fd:	68 ac 23 80 00       	push   $0x8023ac
  800302:	e8 5c 01 00 00       	call   800463 <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80030a:	a1 20 30 80 00       	mov    0x803020,%eax
  80030f:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800315:	a1 20 30 80 00       	mov    0x803020,%eax
  80031a:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800320:	83 ec 04             	sub    $0x4,%esp
  800323:	52                   	push   %edx
  800324:	50                   	push   %eax
  800325:	68 d4 23 80 00       	push   $0x8023d4
  80032a:	e8 34 01 00 00       	call   800463 <cprintf>
  80032f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800332:	a1 20 30 80 00       	mov    0x803020,%eax
  800337:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	50                   	push   %eax
  800341:	68 15 24 80 00       	push   $0x802415
  800346:	e8 18 01 00 00       	call   800463 <cprintf>
  80034b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 84 23 80 00       	push   $0x802384
  800356:	e8 08 01 00 00       	call   800463 <cprintf>
  80035b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035e:	e8 4b 17 00 00       	call   801aae <sys_enable_interrupt>

	// exit gracefully
	exit();
  800363:	e8 19 00 00 00       	call   800381 <exit>
}
  800368:	90                   	nop
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	6a 00                	push   $0x0
  800376:	e8 4a 15 00 00       	call   8018c5 <sys_env_destroy>
  80037b:	83 c4 10             	add    $0x10,%esp
}
  80037e:	90                   	nop
  80037f:	c9                   	leave  
  800380:	c3                   	ret    

00800381 <exit>:

void
exit(void)
{
  800381:	55                   	push   %ebp
  800382:	89 e5                	mov    %esp,%ebp
  800384:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800387:	e8 9f 15 00 00       	call   80192b <sys_env_exit>
}
  80038c:	90                   	nop
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    

0080038f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800395:	8b 45 0c             	mov    0xc(%ebp),%eax
  800398:	8b 00                	mov    (%eax),%eax
  80039a:	8d 48 01             	lea    0x1(%eax),%ecx
  80039d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a0:	89 0a                	mov    %ecx,(%edx)
  8003a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a5:	88 d1                	mov    %dl,%cl
  8003a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003aa:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b1:	8b 00                	mov    (%eax),%eax
  8003b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b8:	75 2c                	jne    8003e6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003ba:	a0 24 30 80 00       	mov    0x803024,%al
  8003bf:	0f b6 c0             	movzbl %al,%eax
  8003c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c5:	8b 12                	mov    (%edx),%edx
  8003c7:	89 d1                	mov    %edx,%ecx
  8003c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cc:	83 c2 08             	add    $0x8,%edx
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	50                   	push   %eax
  8003d3:	51                   	push   %ecx
  8003d4:	52                   	push   %edx
  8003d5:	e8 a9 14 00 00       	call   801883 <sys_cputs>
  8003da:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e9:	8b 40 04             	mov    0x4(%eax),%eax
  8003ec:	8d 50 01             	lea    0x1(%eax),%edx
  8003ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003f5:	90                   	nop
  8003f6:	c9                   	leave  
  8003f7:	c3                   	ret    

008003f8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003f8:	55                   	push   %ebp
  8003f9:	89 e5                	mov    %esp,%ebp
  8003fb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800401:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800408:	00 00 00 
	b.cnt = 0;
  80040b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800412:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800415:	ff 75 0c             	pushl  0xc(%ebp)
  800418:	ff 75 08             	pushl  0x8(%ebp)
  80041b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800421:	50                   	push   %eax
  800422:	68 8f 03 80 00       	push   $0x80038f
  800427:	e8 11 02 00 00       	call   80063d <vprintfmt>
  80042c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80042f:	a0 24 30 80 00       	mov    0x803024,%al
  800434:	0f b6 c0             	movzbl %al,%eax
  800437:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80043d:	83 ec 04             	sub    $0x4,%esp
  800440:	50                   	push   %eax
  800441:	52                   	push   %edx
  800442:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800448:	83 c0 08             	add    $0x8,%eax
  80044b:	50                   	push   %eax
  80044c:	e8 32 14 00 00       	call   801883 <sys_cputs>
  800451:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800454:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80045b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800461:	c9                   	leave  
  800462:	c3                   	ret    

00800463 <cprintf>:

int cprintf(const char *fmt, ...) {
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800469:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800470:	8d 45 0c             	lea    0xc(%ebp),%eax
  800473:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	83 ec 08             	sub    $0x8,%esp
  80047c:	ff 75 f4             	pushl  -0xc(%ebp)
  80047f:	50                   	push   %eax
  800480:	e8 73 ff ff ff       	call   8003f8 <vcprintf>
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80048b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800496:	e8 f9 15 00 00       	call   801a94 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80049b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80049e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8004aa:	50                   	push   %eax
  8004ab:	e8 48 ff ff ff       	call   8003f8 <vcprintf>
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004b6:	e8 f3 15 00 00       	call   801aae <sys_enable_interrupt>
	return cnt;
  8004bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	53                   	push   %ebx
  8004c4:	83 ec 14             	sub    $0x14,%esp
  8004c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004de:	77 55                	ja     800535 <printnum+0x75>
  8004e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e3:	72 05                	jb     8004ea <printnum+0x2a>
  8004e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004e8:	77 4b                	ja     800535 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ea:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004ed:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004f0:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f8:	52                   	push   %edx
  8004f9:	50                   	push   %eax
  8004fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fd:	ff 75 f0             	pushl  -0x10(%ebp)
  800500:	e8 7f 1b 00 00       	call   802084 <__udivdi3>
  800505:	83 c4 10             	add    $0x10,%esp
  800508:	83 ec 04             	sub    $0x4,%esp
  80050b:	ff 75 20             	pushl  0x20(%ebp)
  80050e:	53                   	push   %ebx
  80050f:	ff 75 18             	pushl  0x18(%ebp)
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	ff 75 0c             	pushl  0xc(%ebp)
  800517:	ff 75 08             	pushl  0x8(%ebp)
  80051a:	e8 a1 ff ff ff       	call   8004c0 <printnum>
  80051f:	83 c4 20             	add    $0x20,%esp
  800522:	eb 1a                	jmp    80053e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800524:	83 ec 08             	sub    $0x8,%esp
  800527:	ff 75 0c             	pushl  0xc(%ebp)
  80052a:	ff 75 20             	pushl  0x20(%ebp)
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	ff d0                	call   *%eax
  800532:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800535:	ff 4d 1c             	decl   0x1c(%ebp)
  800538:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80053c:	7f e6                	jg     800524 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80053e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800541:	bb 00 00 00 00       	mov    $0x0,%ebx
  800546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800549:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80054c:	53                   	push   %ebx
  80054d:	51                   	push   %ecx
  80054e:	52                   	push   %edx
  80054f:	50                   	push   %eax
  800550:	e8 3f 1c 00 00       	call   802194 <__umoddi3>
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	05 54 26 80 00       	add    $0x802654,%eax
  80055d:	8a 00                	mov    (%eax),%al
  80055f:	0f be c0             	movsbl %al,%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	ff 75 0c             	pushl  0xc(%ebp)
  800568:	50                   	push   %eax
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	ff d0                	call   *%eax
  80056e:	83 c4 10             	add    $0x10,%esp
}
  800571:	90                   	nop
  800572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80057a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80057e:	7e 1c                	jle    80059c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	8d 50 08             	lea    0x8(%eax),%edx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	89 10                	mov    %edx,(%eax)
  80058d:	8b 45 08             	mov    0x8(%ebp),%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	83 e8 08             	sub    $0x8,%eax
  800595:	8b 50 04             	mov    0x4(%eax),%edx
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	eb 40                	jmp    8005dc <getuint+0x65>
	else if (lflag)
  80059c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005a0:	74 1e                	je     8005c0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	8d 50 04             	lea    0x4(%eax),%edx
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	89 10                	mov    %edx,(%eax)
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	83 e8 04             	sub    $0x4,%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005be:	eb 1c                	jmp    8005dc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	8d 50 04             	lea    0x4(%eax),%edx
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	89 10                	mov    %edx,(%eax)
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	83 e8 04             	sub    $0x4,%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005dc:	5d                   	pop    %ebp
  8005dd:	c3                   	ret    

008005de <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005de:	55                   	push   %ebp
  8005df:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005e5:	7e 1c                	jle    800603 <getint+0x25>
		return va_arg(*ap, long long);
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	8d 50 08             	lea    0x8(%eax),%edx
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	89 10                	mov    %edx,(%eax)
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	83 e8 08             	sub    $0x8,%eax
  8005fc:	8b 50 04             	mov    0x4(%eax),%edx
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	eb 38                	jmp    80063b <getint+0x5d>
	else if (lflag)
  800603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800607:	74 1a                	je     800623 <getint+0x45>
		return va_arg(*ap, long);
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	8d 50 04             	lea    0x4(%eax),%edx
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	89 10                	mov    %edx,(%eax)
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	83 e8 04             	sub    $0x4,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	99                   	cltd   
  800621:	eb 18                	jmp    80063b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800623:	8b 45 08             	mov    0x8(%ebp),%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	8d 50 04             	lea    0x4(%eax),%edx
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	89 10                	mov    %edx,(%eax)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	83 e8 04             	sub    $0x4,%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	99                   	cltd   
}
  80063b:	5d                   	pop    %ebp
  80063c:	c3                   	ret    

0080063d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	56                   	push   %esi
  800641:	53                   	push   %ebx
  800642:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800645:	eb 17                	jmp    80065e <vprintfmt+0x21>
			if (ch == '\0')
  800647:	85 db                	test   %ebx,%ebx
  800649:	0f 84 af 03 00 00    	je     8009fe <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	ff 75 0c             	pushl  0xc(%ebp)
  800655:	53                   	push   %ebx
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	ff d0                	call   *%eax
  80065b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065e:	8b 45 10             	mov    0x10(%ebp),%eax
  800661:	8d 50 01             	lea    0x1(%eax),%edx
  800664:	89 55 10             	mov    %edx,0x10(%ebp)
  800667:	8a 00                	mov    (%eax),%al
  800669:	0f b6 d8             	movzbl %al,%ebx
  80066c:	83 fb 25             	cmp    $0x25,%ebx
  80066f:	75 d6                	jne    800647 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800671:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800675:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80067c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800683:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80068a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800691:	8b 45 10             	mov    0x10(%ebp),%eax
  800694:	8d 50 01             	lea    0x1(%eax),%edx
  800697:	89 55 10             	mov    %edx,0x10(%ebp)
  80069a:	8a 00                	mov    (%eax),%al
  80069c:	0f b6 d8             	movzbl %al,%ebx
  80069f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006a2:	83 f8 55             	cmp    $0x55,%eax
  8006a5:	0f 87 2b 03 00 00    	ja     8009d6 <vprintfmt+0x399>
  8006ab:	8b 04 85 78 26 80 00 	mov    0x802678(,%eax,4),%eax
  8006b2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006b4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006b8:	eb d7                	jmp    800691 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006ba:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006be:	eb d1                	jmp    800691 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006ca:	89 d0                	mov    %edx,%eax
  8006cc:	c1 e0 02             	shl    $0x2,%eax
  8006cf:	01 d0                	add    %edx,%eax
  8006d1:	01 c0                	add    %eax,%eax
  8006d3:	01 d8                	add    %ebx,%eax
  8006d5:	83 e8 30             	sub    $0x30,%eax
  8006d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006db:	8b 45 10             	mov    0x10(%ebp),%eax
  8006de:	8a 00                	mov    (%eax),%al
  8006e0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006e3:	83 fb 2f             	cmp    $0x2f,%ebx
  8006e6:	7e 3e                	jle    800726 <vprintfmt+0xe9>
  8006e8:	83 fb 39             	cmp    $0x39,%ebx
  8006eb:	7f 39                	jg     800726 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ed:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006f0:	eb d5                	jmp    8006c7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	83 c0 04             	add    $0x4,%eax
  8006f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	83 e8 04             	sub    $0x4,%eax
  800701:	8b 00                	mov    (%eax),%eax
  800703:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800706:	eb 1f                	jmp    800727 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800708:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070c:	79 83                	jns    800691 <vprintfmt+0x54>
				width = 0;
  80070e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800715:	e9 77 ff ff ff       	jmp    800691 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80071a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800721:	e9 6b ff ff ff       	jmp    800691 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800726:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800727:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072b:	0f 89 60 ff ff ff    	jns    800691 <vprintfmt+0x54>
				width = precision, precision = -1;
  800731:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800737:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80073e:	e9 4e ff ff ff       	jmp    800691 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800743:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800746:	e9 46 ff ff ff       	jmp    800691 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	83 c0 04             	add    $0x4,%eax
  800751:	89 45 14             	mov    %eax,0x14(%ebp)
  800754:	8b 45 14             	mov    0x14(%ebp),%eax
  800757:	83 e8 04             	sub    $0x4,%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	50                   	push   %eax
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	ff d0                	call   *%eax
  800768:	83 c4 10             	add    $0x10,%esp
			break;
  80076b:	e9 89 02 00 00       	jmp    8009f9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 c0 04             	add    $0x4,%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	83 e8 04             	sub    $0x4,%eax
  80077f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800781:	85 db                	test   %ebx,%ebx
  800783:	79 02                	jns    800787 <vprintfmt+0x14a>
				err = -err;
  800785:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800787:	83 fb 64             	cmp    $0x64,%ebx
  80078a:	7f 0b                	jg     800797 <vprintfmt+0x15a>
  80078c:	8b 34 9d c0 24 80 00 	mov    0x8024c0(,%ebx,4),%esi
  800793:	85 f6                	test   %esi,%esi
  800795:	75 19                	jne    8007b0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800797:	53                   	push   %ebx
  800798:	68 65 26 80 00       	push   $0x802665
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	ff 75 08             	pushl  0x8(%ebp)
  8007a3:	e8 5e 02 00 00       	call   800a06 <printfmt>
  8007a8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007ab:	e9 49 02 00 00       	jmp    8009f9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007b0:	56                   	push   %esi
  8007b1:	68 6e 26 80 00       	push   $0x80266e
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	ff 75 08             	pushl  0x8(%ebp)
  8007bc:	e8 45 02 00 00       	call   800a06 <printfmt>
  8007c1:	83 c4 10             	add    $0x10,%esp
			break;
  8007c4:	e9 30 02 00 00       	jmp    8009f9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 c0 04             	add    $0x4,%eax
  8007cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	83 e8 04             	sub    $0x4,%eax
  8007d8:	8b 30                	mov    (%eax),%esi
  8007da:	85 f6                	test   %esi,%esi
  8007dc:	75 05                	jne    8007e3 <vprintfmt+0x1a6>
				p = "(null)";
  8007de:	be 71 26 80 00       	mov    $0x802671,%esi
			if (width > 0 && padc != '-')
  8007e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e7:	7e 6d                	jle    800856 <vprintfmt+0x219>
  8007e9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007ed:	74 67                	je     800856 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	50                   	push   %eax
  8007f6:	56                   	push   %esi
  8007f7:	e8 0c 03 00 00       	call   800b08 <strnlen>
  8007fc:	83 c4 10             	add    $0x10,%esp
  8007ff:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800802:	eb 16                	jmp    80081a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800804:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	ff d0                	call   *%eax
  800814:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800817:	ff 4d e4             	decl   -0x1c(%ebp)
  80081a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081e:	7f e4                	jg     800804 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800820:	eb 34                	jmp    800856 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800822:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800826:	74 1c                	je     800844 <vprintfmt+0x207>
  800828:	83 fb 1f             	cmp    $0x1f,%ebx
  80082b:	7e 05                	jle    800832 <vprintfmt+0x1f5>
  80082d:	83 fb 7e             	cmp    $0x7e,%ebx
  800830:	7e 12                	jle    800844 <vprintfmt+0x207>
					putch('?', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	6a 3f                	push   $0x3f
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	eb 0f                	jmp    800853 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	ff 75 0c             	pushl  0xc(%ebp)
  80084a:	53                   	push   %ebx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	ff d0                	call   *%eax
  800850:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800853:	ff 4d e4             	decl   -0x1c(%ebp)
  800856:	89 f0                	mov    %esi,%eax
  800858:	8d 70 01             	lea    0x1(%eax),%esi
  80085b:	8a 00                	mov    (%eax),%al
  80085d:	0f be d8             	movsbl %al,%ebx
  800860:	85 db                	test   %ebx,%ebx
  800862:	74 24                	je     800888 <vprintfmt+0x24b>
  800864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800868:	78 b8                	js     800822 <vprintfmt+0x1e5>
  80086a:	ff 4d e0             	decl   -0x20(%ebp)
  80086d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800871:	79 af                	jns    800822 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800873:	eb 13                	jmp    800888 <vprintfmt+0x24b>
				putch(' ', putdat);
  800875:	83 ec 08             	sub    $0x8,%esp
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	6a 20                	push   $0x20
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	ff d0                	call   *%eax
  800882:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800885:	ff 4d e4             	decl   -0x1c(%ebp)
  800888:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088c:	7f e7                	jg     800875 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80088e:	e9 66 01 00 00       	jmp    8009f9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	ff 75 e8             	pushl  -0x18(%ebp)
  800899:	8d 45 14             	lea    0x14(%ebp),%eax
  80089c:	50                   	push   %eax
  80089d:	e8 3c fd ff ff       	call   8005de <getint>
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b1:	85 d2                	test   %edx,%edx
  8008b3:	79 23                	jns    8008d8 <vprintfmt+0x29b>
				putch('-', putdat);
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	ff 75 0c             	pushl  0xc(%ebp)
  8008bb:	6a 2d                	push   $0x2d
  8008bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c0:	ff d0                	call   *%eax
  8008c2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008cb:	f7 d8                	neg    %eax
  8008cd:	83 d2 00             	adc    $0x0,%edx
  8008d0:	f7 da                	neg    %edx
  8008d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008d8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008df:	e9 bc 00 00 00       	jmp    8009a0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ed:	50                   	push   %eax
  8008ee:	e8 84 fc ff ff       	call   800577 <getuint>
  8008f3:	83 c4 10             	add    $0x10,%esp
  8008f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008fc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800903:	e9 98 00 00 00       	jmp    8009a0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	6a 58                	push   $0x58
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	ff d0                	call   *%eax
  800915:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	6a 58                	push   $0x58
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	ff d0                	call   *%eax
  800925:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800928:	83 ec 08             	sub    $0x8,%esp
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	6a 58                	push   $0x58
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
			break;
  800938:	e9 bc 00 00 00       	jmp    8009f9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	6a 30                	push   $0x30
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	ff d0                	call   *%eax
  80094a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80094d:	83 ec 08             	sub    $0x8,%esp
  800950:	ff 75 0c             	pushl  0xc(%ebp)
  800953:	6a 78                	push   $0x78
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	ff d0                	call   *%eax
  80095a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	83 c0 04             	add    $0x4,%eax
  800963:	89 45 14             	mov    %eax,0x14(%ebp)
  800966:	8b 45 14             	mov    0x14(%ebp),%eax
  800969:	83 e8 04             	sub    $0x4,%eax
  80096c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80096e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800971:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800978:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80097f:	eb 1f                	jmp    8009a0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	ff 75 e8             	pushl  -0x18(%ebp)
  800987:	8d 45 14             	lea    0x14(%ebp),%eax
  80098a:	50                   	push   %eax
  80098b:	e8 e7 fb ff ff       	call   800577 <getuint>
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800999:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009a0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a7:	83 ec 04             	sub    $0x4,%esp
  8009aa:	52                   	push   %edx
  8009ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009ae:	50                   	push   %eax
  8009af:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b5:	ff 75 0c             	pushl  0xc(%ebp)
  8009b8:	ff 75 08             	pushl  0x8(%ebp)
  8009bb:	e8 00 fb ff ff       	call   8004c0 <printnum>
  8009c0:	83 c4 20             	add    $0x20,%esp
			break;
  8009c3:	eb 34                	jmp    8009f9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	53                   	push   %ebx
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	ff d0                	call   *%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
			break;
  8009d4:	eb 23                	jmp    8009f9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	6a 25                	push   $0x25
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e6:	ff 4d 10             	decl   0x10(%ebp)
  8009e9:	eb 03                	jmp    8009ee <vprintfmt+0x3b1>
  8009eb:	ff 4d 10             	decl   0x10(%ebp)
  8009ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f1:	48                   	dec    %eax
  8009f2:	8a 00                	mov    (%eax),%al
  8009f4:	3c 25                	cmp    $0x25,%al
  8009f6:	75 f3                	jne    8009eb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009f8:	90                   	nop
		}
	}
  8009f9:	e9 47 fc ff ff       	jmp    800645 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009fe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a02:	5b                   	pop    %ebx
  800a03:	5e                   	pop    %esi
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    

00800a06 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800a0f:	83 c0 04             	add    $0x4,%eax
  800a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a15:	8b 45 10             	mov    0x10(%ebp),%eax
  800a18:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1b:	50                   	push   %eax
  800a1c:	ff 75 0c             	pushl  0xc(%ebp)
  800a1f:	ff 75 08             	pushl  0x8(%ebp)
  800a22:	e8 16 fc ff ff       	call   80063d <vprintfmt>
  800a27:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a2a:	90                   	nop
  800a2b:	c9                   	leave  
  800a2c:	c3                   	ret    

00800a2d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a33:	8b 40 08             	mov    0x8(%eax),%eax
  800a36:	8d 50 01             	lea    0x1(%eax),%edx
  800a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a42:	8b 10                	mov    (%eax),%edx
  800a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a47:	8b 40 04             	mov    0x4(%eax),%eax
  800a4a:	39 c2                	cmp    %eax,%edx
  800a4c:	73 12                	jae    800a60 <sprintputch+0x33>
		*b->buf++ = ch;
  800a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a51:	8b 00                	mov    (%eax),%eax
  800a53:	8d 48 01             	lea    0x1(%eax),%ecx
  800a56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a59:	89 0a                	mov    %ecx,(%edx)
  800a5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a5e:	88 10                	mov    %dl,(%eax)
}
  800a60:	90                   	nop
  800a61:	5d                   	pop    %ebp
  800a62:	c3                   	ret    

00800a63 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	01 d0                	add    %edx,%eax
  800a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a88:	74 06                	je     800a90 <vsnprintf+0x2d>
  800a8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8e:	7f 07                	jg     800a97 <vsnprintf+0x34>
		return -E_INVAL;
  800a90:	b8 03 00 00 00       	mov    $0x3,%eax
  800a95:	eb 20                	jmp    800ab7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a97:	ff 75 14             	pushl  0x14(%ebp)
  800a9a:	ff 75 10             	pushl  0x10(%ebp)
  800a9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aa0:	50                   	push   %eax
  800aa1:	68 2d 0a 80 00       	push   $0x800a2d
  800aa6:	e8 92 fb ff ff       	call   80063d <vprintfmt>
  800aab:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ab7:	c9                   	leave  
  800ab8:	c3                   	ret    

00800ab9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800abf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ac2:	83 c0 04             	add    $0x4,%eax
  800ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ac8:	8b 45 10             	mov    0x10(%ebp),%eax
  800acb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ace:	50                   	push   %eax
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	ff 75 08             	pushl  0x8(%ebp)
  800ad5:	e8 89 ff ff ff       	call   800a63 <vsnprintf>
  800ada:	83 c4 10             	add    $0x10,%esp
  800add:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ae3:	c9                   	leave  
  800ae4:	c3                   	ret    

00800ae5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800aeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800af2:	eb 06                	jmp    800afa <strlen+0x15>
		n++;
  800af4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800af7:	ff 45 08             	incl   0x8(%ebp)
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	8a 00                	mov    (%eax),%al
  800aff:	84 c0                	test   %al,%al
  800b01:	75 f1                	jne    800af4 <strlen+0xf>
		n++;
	return n;
  800b03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b06:	c9                   	leave  
  800b07:	c3                   	ret    

00800b08 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b15:	eb 09                	jmp    800b20 <strnlen+0x18>
		n++;
  800b17:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b1a:	ff 45 08             	incl   0x8(%ebp)
  800b1d:	ff 4d 0c             	decl   0xc(%ebp)
  800b20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b24:	74 09                	je     800b2f <strnlen+0x27>
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8a 00                	mov    (%eax),%al
  800b2b:	84 c0                	test   %al,%al
  800b2d:	75 e8                	jne    800b17 <strnlen+0xf>
		n++;
	return n;
  800b2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b40:	90                   	nop
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	8d 50 01             	lea    0x1(%eax),%edx
  800b47:	89 55 08             	mov    %edx,0x8(%ebp)
  800b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b50:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b53:	8a 12                	mov    (%edx),%dl
  800b55:	88 10                	mov    %dl,(%eax)
  800b57:	8a 00                	mov    (%eax),%al
  800b59:	84 c0                	test   %al,%al
  800b5b:	75 e4                	jne    800b41 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b60:	c9                   	leave  
  800b61:	c3                   	ret    

00800b62 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b75:	eb 1f                	jmp    800b96 <strncpy+0x34>
		*dst++ = *src;
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8d 50 01             	lea    0x1(%eax),%edx
  800b7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b83:	8a 12                	mov    (%edx),%dl
  800b85:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8a:	8a 00                	mov    (%eax),%al
  800b8c:	84 c0                	test   %al,%al
  800b8e:	74 03                	je     800b93 <strncpy+0x31>
			src++;
  800b90:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b93:	ff 45 fc             	incl   -0x4(%ebp)
  800b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b99:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b9c:	72 d9                	jb     800b77 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ba1:	c9                   	leave  
  800ba2:	c3                   	ret    

00800ba3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800baf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bb3:	74 30                	je     800be5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bb5:	eb 16                	jmp    800bcd <strlcpy+0x2a>
			*dst++ = *src++;
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	8d 50 01             	lea    0x1(%eax),%edx
  800bbd:	89 55 08             	mov    %edx,0x8(%ebp)
  800bc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc9:	8a 12                	mov    (%edx),%dl
  800bcb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bcd:	ff 4d 10             	decl   0x10(%ebp)
  800bd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bd4:	74 09                	je     800bdf <strlcpy+0x3c>
  800bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd9:	8a 00                	mov    (%eax),%al
  800bdb:	84 c0                	test   %al,%al
  800bdd:	75 d8                	jne    800bb7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800be5:	8b 55 08             	mov    0x8(%ebp),%edx
  800be8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800beb:	29 c2                	sub    %eax,%edx
  800bed:	89 d0                	mov    %edx,%eax
}
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bf4:	eb 06                	jmp    800bfc <strcmp+0xb>
		p++, q++;
  800bf6:	ff 45 08             	incl   0x8(%ebp)
  800bf9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8a 00                	mov    (%eax),%al
  800c01:	84 c0                	test   %al,%al
  800c03:	74 0e                	je     800c13 <strcmp+0x22>
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8a 10                	mov    (%eax),%dl
  800c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0d:	8a 00                	mov    (%eax),%al
  800c0f:	38 c2                	cmp    %al,%dl
  800c11:	74 e3                	je     800bf6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8a 00                	mov    (%eax),%al
  800c18:	0f b6 d0             	movzbl %al,%edx
  800c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1e:	8a 00                	mov    (%eax),%al
  800c20:	0f b6 c0             	movzbl %al,%eax
  800c23:	29 c2                	sub    %eax,%edx
  800c25:	89 d0                	mov    %edx,%eax
}
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c2c:	eb 09                	jmp    800c37 <strncmp+0xe>
		n--, p++, q++;
  800c2e:	ff 4d 10             	decl   0x10(%ebp)
  800c31:	ff 45 08             	incl   0x8(%ebp)
  800c34:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c3b:	74 17                	je     800c54 <strncmp+0x2b>
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	84 c0                	test   %al,%al
  800c44:	74 0e                	je     800c54 <strncmp+0x2b>
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	8a 10                	mov    (%eax),%dl
  800c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4e:	8a 00                	mov    (%eax),%al
  800c50:	38 c2                	cmp    %al,%dl
  800c52:	74 da                	je     800c2e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c58:	75 07                	jne    800c61 <strncmp+0x38>
		return 0;
  800c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5f:	eb 14                	jmp    800c75 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	8a 00                	mov    (%eax),%al
  800c66:	0f b6 d0             	movzbl %al,%edx
  800c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6c:	8a 00                	mov    (%eax),%al
  800c6e:	0f b6 c0             	movzbl %al,%eax
  800c71:	29 c2                	sub    %eax,%edx
  800c73:	89 d0                	mov    %edx,%eax
}
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    

00800c77 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	83 ec 04             	sub    $0x4,%esp
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c83:	eb 12                	jmp    800c97 <strchr+0x20>
		if (*s == c)
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c8d:	75 05                	jne    800c94 <strchr+0x1d>
			return (char *) s;
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	eb 11                	jmp    800ca5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c94:	ff 45 08             	incl   0x8(%ebp)
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8a 00                	mov    (%eax),%al
  800c9c:	84 c0                	test   %al,%al
  800c9e:	75 e5                	jne    800c85 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 04             	sub    $0x4,%esp
  800cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cb3:	eb 0d                	jmp    800cc2 <strfind+0x1b>
		if (*s == c)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cbd:	74 0e                	je     800ccd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cbf:	ff 45 08             	incl   0x8(%ebp)
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	84 c0                	test   %al,%al
  800cc9:	75 ea                	jne    800cb5 <strfind+0xe>
  800ccb:	eb 01                	jmp    800cce <strfind+0x27>
		if (*s == c)
			break;
  800ccd:	90                   	nop
	return (char *) s;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ce5:	eb 0e                	jmp    800cf5 <memset+0x22>
		*p++ = c;
  800ce7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cea:	8d 50 01             	lea    0x1(%eax),%edx
  800ced:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cf5:	ff 4d f8             	decl   -0x8(%ebp)
  800cf8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cfc:	79 e9                	jns    800ce7 <memset+0x14>
		*p++ = c;

	return v;
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d01:	c9                   	leave  
  800d02:	c3                   	ret    

00800d03 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d15:	eb 16                	jmp    800d2d <memcpy+0x2a>
		*d++ = *s++;
  800d17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1a:	8d 50 01             	lea    0x1(%eax),%edx
  800d1d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d20:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d23:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d26:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d29:	8a 12                	mov    (%edx),%dl
  800d2b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d30:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d33:	89 55 10             	mov    %edx,0x10(%ebp)
  800d36:	85 c0                	test   %eax,%eax
  800d38:	75 dd                	jne    800d17 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d3d:	c9                   	leave  
  800d3e:	c3                   	ret    

00800d3f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d54:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d57:	73 50                	jae    800da9 <memmove+0x6a>
  800d59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5f:	01 d0                	add    %edx,%eax
  800d61:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d64:	76 43                	jbe    800da9 <memmove+0x6a>
		s += n;
  800d66:	8b 45 10             	mov    0x10(%ebp),%eax
  800d69:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d72:	eb 10                	jmp    800d84 <memmove+0x45>
			*--d = *--s;
  800d74:	ff 4d f8             	decl   -0x8(%ebp)
  800d77:	ff 4d fc             	decl   -0x4(%ebp)
  800d7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7d:	8a 10                	mov    (%eax),%dl
  800d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d82:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d84:	8b 45 10             	mov    0x10(%ebp),%eax
  800d87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	75 e3                	jne    800d74 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d91:	eb 23                	jmp    800db6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d96:	8d 50 01             	lea    0x1(%eax),%edx
  800d99:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d9c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d9f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800da5:	8a 12                	mov    (%edx),%dl
  800da7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800da9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800daf:	89 55 10             	mov    %edx,0x10(%ebp)
  800db2:	85 c0                	test   %eax,%eax
  800db4:	75 dd                	jne    800d93 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db9:	c9                   	leave  
  800dba:	c3                   	ret    

00800dbb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dca:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dcd:	eb 2a                	jmp    800df9 <memcmp+0x3e>
		if (*s1 != *s2)
  800dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd2:	8a 10                	mov    (%eax),%dl
  800dd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	38 c2                	cmp    %al,%dl
  800ddb:	74 16                	je     800df3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	0f b6 d0             	movzbl %al,%edx
  800de5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f b6 c0             	movzbl %al,%eax
  800ded:	29 c2                	sub    %eax,%edx
  800def:	89 d0                	mov    %edx,%eax
  800df1:	eb 18                	jmp    800e0b <memcmp+0x50>
		s1++, s2++;
  800df3:	ff 45 fc             	incl   -0x4(%ebp)
  800df6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800df9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dff:	89 55 10             	mov    %edx,0x10(%ebp)
  800e02:	85 c0                	test   %eax,%eax
  800e04:	75 c9                	jne    800dcf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e13:	8b 55 08             	mov    0x8(%ebp),%edx
  800e16:	8b 45 10             	mov    0x10(%ebp),%eax
  800e19:	01 d0                	add    %edx,%eax
  800e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e1e:	eb 15                	jmp    800e35 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 d0             	movzbl %al,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	0f b6 c0             	movzbl %al,%eax
  800e2e:	39 c2                	cmp    %eax,%edx
  800e30:	74 0d                	je     800e3f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e32:	ff 45 08             	incl   0x8(%ebp)
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e3b:	72 e3                	jb     800e20 <memfind+0x13>
  800e3d:	eb 01                	jmp    800e40 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e3f:	90                   	nop
	return (void *) s;
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e52:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e59:	eb 03                	jmp    800e5e <strtol+0x19>
		s++;
  800e5b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	3c 20                	cmp    $0x20,%al
  800e65:	74 f4                	je     800e5b <strtol+0x16>
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	3c 09                	cmp    $0x9,%al
  800e6e:	74 eb                	je     800e5b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	3c 2b                	cmp    $0x2b,%al
  800e77:	75 05                	jne    800e7e <strtol+0x39>
		s++;
  800e79:	ff 45 08             	incl   0x8(%ebp)
  800e7c:	eb 13                	jmp    800e91 <strtol+0x4c>
	else if (*s == '-')
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	3c 2d                	cmp    $0x2d,%al
  800e85:	75 0a                	jne    800e91 <strtol+0x4c>
		s++, neg = 1;
  800e87:	ff 45 08             	incl   0x8(%ebp)
  800e8a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e95:	74 06                	je     800e9d <strtol+0x58>
  800e97:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e9b:	75 20                	jne    800ebd <strtol+0x78>
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	3c 30                	cmp    $0x30,%al
  800ea4:	75 17                	jne    800ebd <strtol+0x78>
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	40                   	inc    %eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	3c 78                	cmp    $0x78,%al
  800eae:	75 0d                	jne    800ebd <strtol+0x78>
		s += 2, base = 16;
  800eb0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eb4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ebb:	eb 28                	jmp    800ee5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ebd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec1:	75 15                	jne    800ed8 <strtol+0x93>
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	3c 30                	cmp    $0x30,%al
  800eca:	75 0c                	jne    800ed8 <strtol+0x93>
		s++, base = 8;
  800ecc:	ff 45 08             	incl   0x8(%ebp)
  800ecf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ed6:	eb 0d                	jmp    800ee5 <strtol+0xa0>
	else if (base == 0)
  800ed8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800edc:	75 07                	jne    800ee5 <strtol+0xa0>
		base = 10;
  800ede:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	3c 2f                	cmp    $0x2f,%al
  800eec:	7e 19                	jle    800f07 <strtol+0xc2>
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	3c 39                	cmp    $0x39,%al
  800ef5:	7f 10                	jg     800f07 <strtol+0xc2>
			dig = *s - '0';
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	0f be c0             	movsbl %al,%eax
  800eff:	83 e8 30             	sub    $0x30,%eax
  800f02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f05:	eb 42                	jmp    800f49 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3c 60                	cmp    $0x60,%al
  800f0e:	7e 19                	jle    800f29 <strtol+0xe4>
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	3c 7a                	cmp    $0x7a,%al
  800f17:	7f 10                	jg     800f29 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	0f be c0             	movsbl %al,%eax
  800f21:	83 e8 57             	sub    $0x57,%eax
  800f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f27:	eb 20                	jmp    800f49 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 40                	cmp    $0x40,%al
  800f30:	7e 39                	jle    800f6b <strtol+0x126>
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	3c 5a                	cmp    $0x5a,%al
  800f39:	7f 30                	jg     800f6b <strtol+0x126>
			dig = *s - 'A' + 10;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	0f be c0             	movsbl %al,%eax
  800f43:	83 e8 37             	sub    $0x37,%eax
  800f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f4c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f4f:	7d 19                	jge    800f6a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f51:	ff 45 08             	incl   0x8(%ebp)
  800f54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f57:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f5b:	89 c2                	mov    %eax,%edx
  800f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f65:	e9 7b ff ff ff       	jmp    800ee5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f6a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f6f:	74 08                	je     800f79 <strtol+0x134>
		*endptr = (char *) s;
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8b 55 08             	mov    0x8(%ebp),%edx
  800f77:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f79:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f7d:	74 07                	je     800f86 <strtol+0x141>
  800f7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f82:	f7 d8                	neg    %eax
  800f84:	eb 03                	jmp    800f89 <strtol+0x144>
  800f86:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <ltostr>:

void
ltostr(long value, char *str)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f98:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa3:	79 13                	jns    800fb8 <ltostr+0x2d>
	{
		neg = 1;
  800fa5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fb2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fb5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fc0:	99                   	cltd   
  800fc1:	f7 f9                	idiv   %ecx
  800fc3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	8d 50 01             	lea    0x1(%eax),%edx
  800fcc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fcf:	89 c2                	mov    %eax,%edx
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	01 d0                	add    %edx,%eax
  800fd6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd9:	83 c2 30             	add    $0x30,%edx
  800fdc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fde:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fe6:	f7 e9                	imul   %ecx
  800fe8:	c1 fa 02             	sar    $0x2,%edx
  800feb:	89 c8                	mov    %ecx,%eax
  800fed:	c1 f8 1f             	sar    $0x1f,%eax
  800ff0:	29 c2                	sub    %eax,%edx
  800ff2:	89 d0                	mov    %edx,%eax
  800ff4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800ff7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ffa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fff:	f7 e9                	imul   %ecx
  801001:	c1 fa 02             	sar    $0x2,%edx
  801004:	89 c8                	mov    %ecx,%eax
  801006:	c1 f8 1f             	sar    $0x1f,%eax
  801009:	29 c2                	sub    %eax,%edx
  80100b:	89 d0                	mov    %edx,%eax
  80100d:	c1 e0 02             	shl    $0x2,%eax
  801010:	01 d0                	add    %edx,%eax
  801012:	01 c0                	add    %eax,%eax
  801014:	29 c1                	sub    %eax,%ecx
  801016:	89 ca                	mov    %ecx,%edx
  801018:	85 d2                	test   %edx,%edx
  80101a:	75 9c                	jne    800fb8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80101c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801026:	48                   	dec    %eax
  801027:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80102a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80102e:	74 3d                	je     80106d <ltostr+0xe2>
		start = 1 ;
  801030:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801037:	eb 34                	jmp    80106d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801039:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	01 d0                	add    %edx,%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801046:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	01 c2                	add    %eax,%edx
  80104e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	01 c8                	add    %ecx,%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80105a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80105d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801060:	01 c2                	add    %eax,%edx
  801062:	8a 45 eb             	mov    -0x15(%ebp),%al
  801065:	88 02                	mov    %al,(%edx)
		start++ ;
  801067:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80106a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80106d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801070:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801073:	7c c4                	jl     801039 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801075:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	01 d0                	add    %edx,%eax
  80107d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801080:	90                   	nop
  801081:	c9                   	leave  
  801082:	c3                   	ret    

00801083 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801089:	ff 75 08             	pushl  0x8(%ebp)
  80108c:	e8 54 fa ff ff       	call   800ae5 <strlen>
  801091:	83 c4 04             	add    $0x4,%esp
  801094:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801097:	ff 75 0c             	pushl  0xc(%ebp)
  80109a:	e8 46 fa ff ff       	call   800ae5 <strlen>
  80109f:	83 c4 04             	add    $0x4,%esp
  8010a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b3:	eb 17                	jmp    8010cc <strcconcat+0x49>
		final[s] = str1[s] ;
  8010b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bb:	01 c2                	add    %eax,%edx
  8010bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	01 c8                	add    %ecx,%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c9:	ff 45 fc             	incl   -0x4(%ebp)
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d2:	7c e1                	jl     8010b5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010e2:	eb 1f                	jmp    801103 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e7:	8d 50 01             	lea    0x1(%eax),%edx
  8010ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010ed:	89 c2                	mov    %eax,%edx
  8010ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f2:	01 c2                	add    %eax,%edx
  8010f4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	01 c8                	add    %ecx,%eax
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801100:	ff 45 f8             	incl   -0x8(%ebp)
  801103:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801106:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801109:	7c d9                	jl     8010e4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80110b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	c6 00 00             	movb   $0x0,(%eax)
}
  801116:	90                   	nop
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80111c:	8b 45 14             	mov    0x14(%ebp),%eax
  80111f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801125:	8b 45 14             	mov    0x14(%ebp),%eax
  801128:	8b 00                	mov    (%eax),%eax
  80112a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801131:	8b 45 10             	mov    0x10(%ebp),%eax
  801134:	01 d0                	add    %edx,%eax
  801136:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80113c:	eb 0c                	jmp    80114a <strsplit+0x31>
			*string++ = 0;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8d 50 01             	lea    0x1(%eax),%edx
  801144:	89 55 08             	mov    %edx,0x8(%ebp)
  801147:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	84 c0                	test   %al,%al
  801151:	74 18                	je     80116b <strsplit+0x52>
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	0f be c0             	movsbl %al,%eax
  80115b:	50                   	push   %eax
  80115c:	ff 75 0c             	pushl  0xc(%ebp)
  80115f:	e8 13 fb ff ff       	call   800c77 <strchr>
  801164:	83 c4 08             	add    $0x8,%esp
  801167:	85 c0                	test   %eax,%eax
  801169:	75 d3                	jne    80113e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	84 c0                	test   %al,%al
  801172:	74 5a                	je     8011ce <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801174:	8b 45 14             	mov    0x14(%ebp),%eax
  801177:	8b 00                	mov    (%eax),%eax
  801179:	83 f8 0f             	cmp    $0xf,%eax
  80117c:	75 07                	jne    801185 <strsplit+0x6c>
		{
			return 0;
  80117e:	b8 00 00 00 00       	mov    $0x0,%eax
  801183:	eb 66                	jmp    8011eb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801185:	8b 45 14             	mov    0x14(%ebp),%eax
  801188:	8b 00                	mov    (%eax),%eax
  80118a:	8d 48 01             	lea    0x1(%eax),%ecx
  80118d:	8b 55 14             	mov    0x14(%ebp),%edx
  801190:	89 0a                	mov    %ecx,(%edx)
  801192:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801199:	8b 45 10             	mov    0x10(%ebp),%eax
  80119c:	01 c2                	add    %eax,%edx
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a3:	eb 03                	jmp    8011a8 <strsplit+0x8f>
			string++;
  8011a5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	84 c0                	test   %al,%al
  8011af:	74 8b                	je     80113c <strsplit+0x23>
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	8a 00                	mov    (%eax),%al
  8011b6:	0f be c0             	movsbl %al,%eax
  8011b9:	50                   	push   %eax
  8011ba:	ff 75 0c             	pushl  0xc(%ebp)
  8011bd:	e8 b5 fa ff ff       	call   800c77 <strchr>
  8011c2:	83 c4 08             	add    $0x8,%esp
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	74 dc                	je     8011a5 <strsplit+0x8c>
			string++;
	}
  8011c9:	e9 6e ff ff ff       	jmp    80113c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011ce:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d2:	8b 00                	mov    (%eax),%eax
  8011d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011db:	8b 45 10             	mov    0x10(%ebp),%eax
  8011de:	01 d0                	add    %edx,%eax
  8011e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  8011f3:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8011fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801200:	01 d0                	add    %edx,%eax
  801202:	48                   	dec    %eax
  801203:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801206:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801209:	ba 00 00 00 00       	mov    $0x0,%edx
  80120e:	f7 75 ac             	divl   -0x54(%ebp)
  801211:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801214:	29 d0                	sub    %edx,%eax
  801216:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801219:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801220:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801227:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  80122e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801235:	eb 3f                	jmp    801276 <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80123a:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801241:	83 ec 04             	sub    $0x4,%esp
  801244:	50                   	push   %eax
  801245:	ff 75 e8             	pushl  -0x18(%ebp)
  801248:	68 d0 27 80 00       	push   $0x8027d0
  80124d:	e8 11 f2 ff ff       	call   800463 <cprintf>
  801252:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801255:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801258:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  80125f:	83 ec 04             	sub    $0x4,%esp
  801262:	50                   	push   %eax
  801263:	ff 75 e8             	pushl  -0x18(%ebp)
  801266:	68 e5 27 80 00       	push   $0x8027e5
  80126b:	e8 f3 f1 ff ff       	call   800463 <cprintf>
  801270:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801273:	ff 45 e8             	incl   -0x18(%ebp)
  801276:	a1 28 30 80 00       	mov    0x803028,%eax
  80127b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80127e:	7c b7                	jl     801237 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801280:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801287:	e9 42 01 00 00       	jmp    8013ce <malloc+0x1e1>
		int flag0=1;
  80128c:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801296:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801299:	eb 6b                	jmp    801306 <malloc+0x119>
			for(int k=0;k<count;k++){
  80129b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8012a2:	eb 42                	jmp    8012e6 <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  8012a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012a7:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8012ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012b1:	39 c2                	cmp    %eax,%edx
  8012b3:	77 2e                	ja     8012e3 <malloc+0xf6>
  8012b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012b8:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8012bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012c2:	39 c2                	cmp    %eax,%edx
  8012c4:	76 1d                	jbe    8012e3 <malloc+0xf6>
					ni=arr_add[k].end-i;
  8012c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012c9:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8012d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d3:	29 c2                	sub    %eax,%edx
  8012d5:	89 d0                	mov    %edx,%eax
  8012d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  8012da:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  8012e1:	eb 0d                	jmp    8012f0 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  8012e3:	ff 45 d8             	incl   -0x28(%ebp)
  8012e6:	a1 28 30 80 00       	mov    0x803028,%eax
  8012eb:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8012ee:	7c b4                	jl     8012a4 <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  8012f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012f4:	74 09                	je     8012ff <malloc+0x112>
				flag0=0;
  8012f6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8012fd:	eb 16                	jmp    801315 <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8012ff:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801306:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	01 c2                	add    %eax,%edx
  80130e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801311:	39 c2                	cmp    %eax,%edx
  801313:	77 86                	ja     80129b <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801315:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801319:	0f 84 a2 00 00 00    	je     8013c1 <malloc+0x1d4>

			int f=1;
  80131f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801326:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801329:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80132c:	89 c8                	mov    %ecx,%eax
  80132e:	01 c0                	add    %eax,%eax
  801330:	01 c8                	add    %ecx,%eax
  801332:	c1 e0 02             	shl    $0x2,%eax
  801335:	05 20 31 80 00       	add    $0x803120,%eax
  80133a:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  80133c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801348:	89 d0                	mov    %edx,%eax
  80134a:	01 c0                	add    %eax,%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	c1 e0 02             	shl    $0x2,%eax
  801351:	05 24 31 80 00       	add    $0x803124,%eax
  801356:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801358:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135b:	89 d0                	mov    %edx,%eax
  80135d:	01 c0                	add    %eax,%eax
  80135f:	01 d0                	add    %edx,%eax
  801361:	c1 e0 02             	shl    $0x2,%eax
  801364:	05 28 31 80 00       	add    $0x803128,%eax
  801369:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  80136f:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801372:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801379:	eb 36                	jmp    8013b1 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  80137b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	01 c2                	add    %eax,%edx
  801383:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801386:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80138d:	39 c2                	cmp    %eax,%edx
  80138f:	73 1d                	jae    8013ae <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801391:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801394:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80139b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80139e:	29 c2                	sub    %eax,%edx
  8013a0:	89 d0                	mov    %edx,%eax
  8013a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  8013a5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  8013ac:	eb 0d                	jmp    8013bb <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  8013ae:	ff 45 d0             	incl   -0x30(%ebp)
  8013b1:	a1 28 30 80 00       	mov    0x803028,%eax
  8013b6:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8013b9:	7c c0                	jl     80137b <malloc+0x18e>
					break;

				}
			}

			if(f){
  8013bb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8013bf:	75 1d                	jne    8013de <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  8013c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8013c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013cb:	01 45 e4             	add    %eax,-0x1c(%ebp)
  8013ce:	a1 04 30 80 00       	mov    0x803004,%eax
  8013d3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8013d6:	0f 8c b0 fe ff ff    	jl     80128c <malloc+0x9f>
  8013dc:	eb 01                	jmp    8013df <malloc+0x1f2>

				}
			}

			if(f){
				break;
  8013de:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  8013df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013e3:	75 7a                	jne    80145f <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  8013e5:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	01 d0                	add    %edx,%eax
  8013f0:	48                   	dec    %eax
  8013f1:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8013f6:	7c 0a                	jl     801402 <malloc+0x215>
			return NULL;
  8013f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fd:	e9 a4 02 00 00       	jmp    8016a6 <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801402:	a1 04 30 80 00       	mov    0x803004,%eax
  801407:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  80140a:	a1 28 30 80 00       	mov    0x803028,%eax
  80140f:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801412:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  801419:	83 ec 08             	sub    $0x8,%esp
  80141c:	ff 75 08             	pushl  0x8(%ebp)
  80141f:	ff 75 a4             	pushl  -0x5c(%ebp)
  801422:	e8 04 06 00 00       	call   801a2b <sys_allocateMem>
  801427:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  80142a:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	01 d0                	add    %edx,%eax
  801435:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  80143a:	a1 28 30 80 00       	mov    0x803028,%eax
  80143f:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801445:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  80144c:	a1 28 30 80 00       	mov    0x803028,%eax
  801451:	40                   	inc    %eax
  801452:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  801457:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80145a:	e9 47 02 00 00       	jmp    8016a6 <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  80145f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801466:	e9 ac 00 00 00       	jmp    801517 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  80146b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80146e:	89 d0                	mov    %edx,%eax
  801470:	01 c0                	add    %eax,%eax
  801472:	01 d0                	add    %edx,%eax
  801474:	c1 e0 02             	shl    $0x2,%eax
  801477:	05 24 31 80 00       	add    $0x803124,%eax
  80147c:	8b 00                	mov    (%eax),%eax
  80147e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801481:	eb 7e                	jmp    801501 <malloc+0x314>
			int flag=0;
  801483:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  80148a:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801491:	eb 57                	jmp    8014ea <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801493:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801496:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80149d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014a0:	39 c2                	cmp    %eax,%edx
  8014a2:	77 1a                	ja     8014be <malloc+0x2d1>
  8014a4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8014a7:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8014ae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014b1:	39 c2                	cmp    %eax,%edx
  8014b3:	76 09                	jbe    8014be <malloc+0x2d1>
								flag=1;
  8014b5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  8014bc:	eb 36                	jmp    8014f4 <malloc+0x307>
			arr[i].space++;
  8014be:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8014c1:	89 d0                	mov    %edx,%eax
  8014c3:	01 c0                	add    %eax,%eax
  8014c5:	01 d0                	add    %edx,%eax
  8014c7:	c1 e0 02             	shl    $0x2,%eax
  8014ca:	05 28 31 80 00       	add    $0x803128,%eax
  8014cf:	8b 00                	mov    (%eax),%eax
  8014d1:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8014d7:	89 d0                	mov    %edx,%eax
  8014d9:	01 c0                	add    %eax,%eax
  8014db:	01 d0                	add    %edx,%eax
  8014dd:	c1 e0 02             	shl    $0x2,%eax
  8014e0:	05 28 31 80 00       	add    $0x803128,%eax
  8014e5:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  8014e7:	ff 45 c0             	incl   -0x40(%ebp)
  8014ea:	a1 28 30 80 00       	mov    0x803028,%eax
  8014ef:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  8014f2:	7c 9f                	jl     801493 <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  8014f4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8014f8:	75 19                	jne    801513 <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8014fa:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801501:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801504:	a1 04 30 80 00       	mov    0x803004,%eax
  801509:	39 c2                	cmp    %eax,%edx
  80150b:	0f 82 72 ff ff ff    	jb     801483 <malloc+0x296>
  801511:	eb 01                	jmp    801514 <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801513:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801514:	ff 45 cc             	incl   -0x34(%ebp)
  801517:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80151a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80151d:	0f 8c 48 ff ff ff    	jl     80146b <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801523:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  80152a:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801531:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801538:	eb 37                	jmp    801571 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  80153a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  80153d:	89 d0                	mov    %edx,%eax
  80153f:	01 c0                	add    %eax,%eax
  801541:	01 d0                	add    %edx,%eax
  801543:	c1 e0 02             	shl    $0x2,%eax
  801546:	05 28 31 80 00       	add    $0x803128,%eax
  80154b:	8b 00                	mov    (%eax),%eax
  80154d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801550:	7d 1c                	jge    80156e <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801552:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801555:	89 d0                	mov    %edx,%eax
  801557:	01 c0                	add    %eax,%eax
  801559:	01 d0                	add    %edx,%eax
  80155b:	c1 e0 02             	shl    $0x2,%eax
  80155e:	05 28 31 80 00       	add    $0x803128,%eax
  801563:	8b 00                	mov    (%eax),%eax
  801565:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801568:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80156b:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  80156e:	ff 45 b4             	incl   -0x4c(%ebp)
  801571:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801574:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801577:	7c c1                	jl     80153a <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801579:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80157f:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801582:	89 c8                	mov    %ecx,%eax
  801584:	01 c0                	add    %eax,%eax
  801586:	01 c8                	add    %ecx,%eax
  801588:	c1 e0 02             	shl    $0x2,%eax
  80158b:	05 20 31 80 00       	add    $0x803120,%eax
  801590:	8b 00                	mov    (%eax),%eax
  801592:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801599:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80159f:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8015a2:	89 c8                	mov    %ecx,%eax
  8015a4:	01 c0                	add    %eax,%eax
  8015a6:	01 c8                	add    %ecx,%eax
  8015a8:	c1 e0 02             	shl    $0x2,%eax
  8015ab:	05 24 31 80 00       	add    $0x803124,%eax
  8015b0:	8b 00                	mov    (%eax),%eax
  8015b2:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  8015b9:	a1 28 30 80 00       	mov    0x803028,%eax
  8015be:	40                   	inc    %eax
  8015bf:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  8015c4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8015c7:	89 d0                	mov    %edx,%eax
  8015c9:	01 c0                	add    %eax,%eax
  8015cb:	01 d0                	add    %edx,%eax
  8015cd:	c1 e0 02             	shl    $0x2,%eax
  8015d0:	05 20 31 80 00       	add    $0x803120,%eax
  8015d5:	8b 00                	mov    (%eax),%eax
  8015d7:	83 ec 08             	sub    $0x8,%esp
  8015da:	ff 75 08             	pushl  0x8(%ebp)
  8015dd:	50                   	push   %eax
  8015de:	e8 48 04 00 00       	call   801a2b <sys_allocateMem>
  8015e3:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  8015e6:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  8015ed:	eb 78                	jmp    801667 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  8015ef:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8015f2:	89 d0                	mov    %edx,%eax
  8015f4:	01 c0                	add    %eax,%eax
  8015f6:	01 d0                	add    %edx,%eax
  8015f8:	c1 e0 02             	shl    $0x2,%eax
  8015fb:	05 20 31 80 00       	add    $0x803120,%eax
  801600:	8b 00                	mov    (%eax),%eax
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	50                   	push   %eax
  801606:	ff 75 b0             	pushl  -0x50(%ebp)
  801609:	68 d0 27 80 00       	push   $0x8027d0
  80160e:	e8 50 ee ff ff       	call   800463 <cprintf>
  801613:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801616:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801619:	89 d0                	mov    %edx,%eax
  80161b:	01 c0                	add    %eax,%eax
  80161d:	01 d0                	add    %edx,%eax
  80161f:	c1 e0 02             	shl    $0x2,%eax
  801622:	05 24 31 80 00       	add    $0x803124,%eax
  801627:	8b 00                	mov    (%eax),%eax
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	50                   	push   %eax
  80162d:	ff 75 b0             	pushl  -0x50(%ebp)
  801630:	68 e5 27 80 00       	push   $0x8027e5
  801635:	e8 29 ee ff ff       	call   800463 <cprintf>
  80163a:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  80163d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801640:	89 d0                	mov    %edx,%eax
  801642:	01 c0                	add    %eax,%eax
  801644:	01 d0                	add    %edx,%eax
  801646:	c1 e0 02             	shl    $0x2,%eax
  801649:	05 28 31 80 00       	add    $0x803128,%eax
  80164e:	8b 00                	mov    (%eax),%eax
  801650:	83 ec 04             	sub    $0x4,%esp
  801653:	50                   	push   %eax
  801654:	ff 75 b0             	pushl  -0x50(%ebp)
  801657:	68 f8 27 80 00       	push   $0x8027f8
  80165c:	e8 02 ee ff ff       	call   800463 <cprintf>
  801661:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801664:	ff 45 b0             	incl   -0x50(%ebp)
  801667:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80166a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80166d:	7c 80                	jl     8015ef <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  80166f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801672:	89 d0                	mov    %edx,%eax
  801674:	01 c0                	add    %eax,%eax
  801676:	01 d0                	add    %edx,%eax
  801678:	c1 e0 02             	shl    $0x2,%eax
  80167b:	05 20 31 80 00       	add    $0x803120,%eax
  801680:	8b 00                	mov    (%eax),%eax
  801682:	83 ec 08             	sub    $0x8,%esp
  801685:	50                   	push   %eax
  801686:	68 0c 28 80 00       	push   $0x80280c
  80168b:	e8 d3 ed ff ff       	call   800463 <cprintf>
  801690:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801693:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801696:	89 d0                	mov    %edx,%eax
  801698:	01 c0                	add    %eax,%eax
  80169a:	01 d0                	add    %edx,%eax
  80169c:	c1 e0 02             	shl    $0x2,%eax
  80169f:	05 20 31 80 00       	add    $0x803120,%eax
  8016a4:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  8016b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8016bb:	eb 4b                	jmp    801708 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  8016bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c0:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8016c7:	89 c2                	mov    %eax,%edx
  8016c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016cc:	39 c2                	cmp    %eax,%edx
  8016ce:	7f 35                	jg     801705 <free+0x5d>
  8016d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d3:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8016da:	89 c2                	mov    %eax,%edx
  8016dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016df:	39 c2                	cmp    %eax,%edx
  8016e1:	7e 22                	jle    801705 <free+0x5d>
				start=arr_add[i].start;
  8016e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e6:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8016ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  8016f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f3:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8016fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8016fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801700:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801703:	eb 0d                	jmp    801712 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801705:	ff 45 ec             	incl   -0x14(%ebp)
  801708:	a1 28 30 80 00       	mov    0x803028,%eax
  80170d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801710:	7c ab                	jl     8016bd <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801715:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  80171c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171f:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801726:	29 c2                	sub    %eax,%edx
  801728:	89 d0                	mov    %edx,%eax
  80172a:	83 ec 08             	sub    $0x8,%esp
  80172d:	50                   	push   %eax
  80172e:	ff 75 f4             	pushl  -0xc(%ebp)
  801731:	e8 d9 02 00 00       	call   801a0f <sys_freeMem>
  801736:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80173f:	eb 2d                	jmp    80176e <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801741:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801744:	40                   	inc    %eax
  801745:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  80174c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80174f:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801756:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801759:	40                   	inc    %eax
  80175a:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801761:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801764:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  80176b:	ff 45 e8             	incl   -0x18(%ebp)
  80176e:	a1 28 30 80 00       	mov    0x803028,%eax
  801773:	48                   	dec    %eax
  801774:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801777:	7f c8                	jg     801741 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801779:	a1 28 30 80 00       	mov    0x803028,%eax
  80177e:	48                   	dec    %eax
  80177f:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801784:	90                   	nop
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 18             	sub    $0x18,%esp
  80178d:	8b 45 10             	mov    0x10(%ebp),%eax
  801790:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801793:	83 ec 04             	sub    $0x4,%esp
  801796:	68 28 28 80 00       	push   $0x802828
  80179b:	68 18 01 00 00       	push   $0x118
  8017a0:	68 4b 28 80 00       	push   $0x80284b
  8017a5:	e8 0b 07 00 00       	call   801eb5 <_panic>

008017aa <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017b0:	83 ec 04             	sub    $0x4,%esp
  8017b3:	68 28 28 80 00       	push   $0x802828
  8017b8:	68 1e 01 00 00       	push   $0x11e
  8017bd:	68 4b 28 80 00       	push   $0x80284b
  8017c2:	e8 ee 06 00 00       	call   801eb5 <_panic>

008017c7 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017cd:	83 ec 04             	sub    $0x4,%esp
  8017d0:	68 28 28 80 00       	push   $0x802828
  8017d5:	68 24 01 00 00       	push   $0x124
  8017da:	68 4b 28 80 00       	push   $0x80284b
  8017df:	e8 d1 06 00 00       	call   801eb5 <_panic>

008017e4 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017ea:	83 ec 04             	sub    $0x4,%esp
  8017ed:	68 28 28 80 00       	push   $0x802828
  8017f2:	68 29 01 00 00       	push   $0x129
  8017f7:	68 4b 28 80 00       	push   $0x80284b
  8017fc:	e8 b4 06 00 00       	call   801eb5 <_panic>

00801801 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801807:	83 ec 04             	sub    $0x4,%esp
  80180a:	68 28 28 80 00       	push   $0x802828
  80180f:	68 2f 01 00 00       	push   $0x12f
  801814:	68 4b 28 80 00       	push   $0x80284b
  801819:	e8 97 06 00 00       	call   801eb5 <_panic>

0080181e <shrink>:
}
void shrink(uint32 newSize)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801824:	83 ec 04             	sub    $0x4,%esp
  801827:	68 28 28 80 00       	push   $0x802828
  80182c:	68 33 01 00 00       	push   $0x133
  801831:	68 4b 28 80 00       	push   $0x80284b
  801836:	e8 7a 06 00 00       	call   801eb5 <_panic>

0080183b <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801841:	83 ec 04             	sub    $0x4,%esp
  801844:	68 28 28 80 00       	push   $0x802828
  801849:	68 38 01 00 00       	push   $0x138
  80184e:	68 4b 28 80 00       	push   $0x80284b
  801853:	e8 5d 06 00 00       	call   801eb5 <_panic>

00801858 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	57                   	push   %edi
  80185c:	56                   	push   %esi
  80185d:	53                   	push   %ebx
  80185e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	8b 55 0c             	mov    0xc(%ebp),%edx
  801867:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80186d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801870:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801873:	cd 30                	int    $0x30
  801875:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801878:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80187b:	83 c4 10             	add    $0x10,%esp
  80187e:	5b                   	pop    %ebx
  80187f:	5e                   	pop    %esi
  801880:	5f                   	pop    %edi
  801881:	5d                   	pop    %ebp
  801882:	c3                   	ret    

00801883 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	8b 45 10             	mov    0x10(%ebp),%eax
  80188c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80188f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	52                   	push   %edx
  80189b:	ff 75 0c             	pushl  0xc(%ebp)
  80189e:	50                   	push   %eax
  80189f:	6a 00                	push   $0x0
  8018a1:	e8 b2 ff ff ff       	call   801858 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	90                   	nop
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_cgetc>:

int
sys_cgetc(void)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 01                	push   $0x1
  8018bb:	e8 98 ff ff ff       	call   801858 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	50                   	push   %eax
  8018d4:	6a 05                	push   $0x5
  8018d6:	e8 7d ff ff ff       	call   801858 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 02                	push   $0x2
  8018ef:	e8 64 ff ff ff       	call   801858 <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 03                	push   $0x3
  801908:	e8 4b ff ff ff       	call   801858 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 04                	push   $0x4
  801921:	e8 32 ff ff ff       	call   801858 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_env_exit>:


void sys_env_exit(void)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 06                	push   $0x6
  80193a:	e8 19 ff ff ff       	call   801858 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	90                   	nop
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	52                   	push   %edx
  801955:	50                   	push   %eax
  801956:	6a 07                	push   $0x7
  801958:	e8 fb fe ff ff       	call   801858 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	56                   	push   %esi
  801966:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801967:	8b 75 18             	mov    0x18(%ebp),%esi
  80196a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80196d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801970:	8b 55 0c             	mov    0xc(%ebp),%edx
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	56                   	push   %esi
  801977:	53                   	push   %ebx
  801978:	51                   	push   %ecx
  801979:	52                   	push   %edx
  80197a:	50                   	push   %eax
  80197b:	6a 08                	push   $0x8
  80197d:	e8 d6 fe ff ff       	call   801858 <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801988:	5b                   	pop    %ebx
  801989:	5e                   	pop    %esi
  80198a:	5d                   	pop    %ebp
  80198b:	c3                   	ret    

0080198c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80198f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	52                   	push   %edx
  80199c:	50                   	push   %eax
  80199d:	6a 09                	push   $0x9
  80199f:	e8 b4 fe ff ff       	call   801858 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	ff 75 08             	pushl  0x8(%ebp)
  8019b8:	6a 0a                	push   $0xa
  8019ba:	e8 99 fe ff ff       	call   801858 <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 0b                	push   $0xb
  8019d3:	e8 80 fe ff ff       	call   801858 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 0c                	push   $0xc
  8019ec:	e8 67 fe ff ff       	call   801858 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 0d                	push   $0xd
  801a05:	e8 4e fe ff ff       	call   801858 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	ff 75 0c             	pushl  0xc(%ebp)
  801a1b:	ff 75 08             	pushl  0x8(%ebp)
  801a1e:	6a 11                	push   $0x11
  801a20:	e8 33 fe ff ff       	call   801858 <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
	return;
  801a28:	90                   	nop
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	ff 75 08             	pushl  0x8(%ebp)
  801a3a:	6a 12                	push   $0x12
  801a3c:	e8 17 fe ff ff       	call   801858 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
	return ;
  801a44:	90                   	nop
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 0e                	push   $0xe
  801a56:	e8 fd fd ff ff       	call   801858 <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	ff 75 08             	pushl  0x8(%ebp)
  801a6e:	6a 0f                	push   $0xf
  801a70:	e8 e3 fd ff ff       	call   801858 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 10                	push   $0x10
  801a89:	e8 ca fd ff ff       	call   801858 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	90                   	nop
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 14                	push   $0x14
  801aa3:	e8 b0 fd ff ff       	call   801858 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	90                   	nop
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 15                	push   $0x15
  801abd:	e8 96 fd ff ff       	call   801858 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	90                   	nop
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ad4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	50                   	push   %eax
  801ae1:	6a 16                	push   $0x16
  801ae3:	e8 70 fd ff ff       	call   801858 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	90                   	nop
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 17                	push   $0x17
  801afd:	e8 56 fd ff ff       	call   801858 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	90                   	nop
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	ff 75 0c             	pushl  0xc(%ebp)
  801b17:	50                   	push   %eax
  801b18:	6a 18                	push   $0x18
  801b1a:	e8 39 fd ff ff       	call   801858 <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	52                   	push   %edx
  801b34:	50                   	push   %eax
  801b35:	6a 1b                	push   $0x1b
  801b37:	e8 1c fd ff ff       	call   801858 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	52                   	push   %edx
  801b51:	50                   	push   %eax
  801b52:	6a 19                	push   $0x19
  801b54:	e8 ff fc ff ff       	call   801858 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	90                   	nop
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	52                   	push   %edx
  801b6f:	50                   	push   %eax
  801b70:	6a 1a                	push   $0x1a
  801b72:	e8 e1 fc ff ff       	call   801858 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	90                   	nop
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	83 ec 04             	sub    $0x4,%esp
  801b83:	8b 45 10             	mov    0x10(%ebp),%eax
  801b86:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b89:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b8c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	6a 00                	push   $0x0
  801b95:	51                   	push   %ecx
  801b96:	52                   	push   %edx
  801b97:	ff 75 0c             	pushl  0xc(%ebp)
  801b9a:	50                   	push   %eax
  801b9b:	6a 1c                	push   $0x1c
  801b9d:	e8 b6 fc ff ff       	call   801858 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801baa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	52                   	push   %edx
  801bb7:	50                   	push   %eax
  801bb8:	6a 1d                	push   $0x1d
  801bba:	e8 99 fc ff ff       	call   801858 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	51                   	push   %ecx
  801bd5:	52                   	push   %edx
  801bd6:	50                   	push   %eax
  801bd7:	6a 1e                	push   $0x1e
  801bd9:	e8 7a fc ff ff       	call   801858 <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	52                   	push   %edx
  801bf3:	50                   	push   %eax
  801bf4:	6a 1f                	push   $0x1f
  801bf6:	e8 5d fc ff ff       	call   801858 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 20                	push   $0x20
  801c0f:	e8 44 fc ff ff       	call   801858 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	6a 00                	push   $0x0
  801c21:	ff 75 14             	pushl  0x14(%ebp)
  801c24:	ff 75 10             	pushl  0x10(%ebp)
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	50                   	push   %eax
  801c2b:	6a 21                	push   $0x21
  801c2d:	e8 26 fc ff ff       	call   801858 <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	50                   	push   %eax
  801c46:	6a 22                	push   $0x22
  801c48:	e8 0b fc ff ff       	call   801858 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	90                   	nop
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	50                   	push   %eax
  801c62:	6a 23                	push   $0x23
  801c64:	e8 ef fb ff ff       	call   801858 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	90                   	nop
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c75:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c78:	8d 50 04             	lea    0x4(%eax),%edx
  801c7b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	52                   	push   %edx
  801c85:	50                   	push   %eax
  801c86:	6a 24                	push   $0x24
  801c88:	e8 cb fb ff ff       	call   801858 <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
	return result;
  801c90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c96:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c99:	89 01                	mov    %eax,(%ecx)
  801c9b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	c9                   	leave  
  801ca2:	c2 04 00             	ret    $0x4

00801ca5 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	ff 75 10             	pushl  0x10(%ebp)
  801caf:	ff 75 0c             	pushl  0xc(%ebp)
  801cb2:	ff 75 08             	pushl  0x8(%ebp)
  801cb5:	6a 13                	push   $0x13
  801cb7:	e8 9c fb ff ff       	call   801858 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbf:	90                   	nop
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 25                	push   $0x25
  801cd1:	e8 82 fb ff ff       	call   801858 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	83 ec 04             	sub    $0x4,%esp
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ce7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	50                   	push   %eax
  801cf4:	6a 26                	push   $0x26
  801cf6:	e8 5d fb ff ff       	call   801858 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfe:	90                   	nop
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <rsttst>:
void rsttst()
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 28                	push   $0x28
  801d10:	e8 43 fb ff ff       	call   801858 <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
	return ;
  801d18:	90                   	nop
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 04             	sub    $0x4,%esp
  801d21:	8b 45 14             	mov    0x14(%ebp),%eax
  801d24:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d27:	8b 55 18             	mov    0x18(%ebp),%edx
  801d2a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d2e:	52                   	push   %edx
  801d2f:	50                   	push   %eax
  801d30:	ff 75 10             	pushl  0x10(%ebp)
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	ff 75 08             	pushl  0x8(%ebp)
  801d39:	6a 27                	push   $0x27
  801d3b:	e8 18 fb ff ff       	call   801858 <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
	return ;
  801d43:	90                   	nop
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <chktst>:
void chktst(uint32 n)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	ff 75 08             	pushl  0x8(%ebp)
  801d54:	6a 29                	push   $0x29
  801d56:	e8 fd fa ff ff       	call   801858 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5e:	90                   	nop
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <inctst>:

void inctst()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 2a                	push   $0x2a
  801d70:	e8 e3 fa ff ff       	call   801858 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
	return ;
  801d78:	90                   	nop
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <gettst>:
uint32 gettst()
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 2b                	push   $0x2b
  801d8a:	e8 c9 fa ff ff       	call   801858 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 2c                	push   $0x2c
  801da6:	e8 ad fa ff ff       	call   801858 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
  801dae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801db1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801db5:	75 07                	jne    801dbe <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801db7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbc:	eb 05                	jmp    801dc3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 2c                	push   $0x2c
  801dd7:	e8 7c fa ff ff       	call   801858 <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
  801ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801de2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801de6:	75 07                	jne    801def <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801de8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ded:	eb 05                	jmp    801df4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801def:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 2c                	push   $0x2c
  801e08:	e8 4b fa ff ff       	call   801858 <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
  801e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e13:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e17:	75 07                	jne    801e20 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e19:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1e:	eb 05                	jmp    801e25 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 2c                	push   $0x2c
  801e39:	e8 1a fa ff ff       	call   801858 <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
  801e41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e44:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e48:	75 07                	jne    801e51 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4f:	eb 05                	jmp    801e56 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	ff 75 08             	pushl  0x8(%ebp)
  801e66:	6a 2d                	push   $0x2d
  801e68:	e8 eb f9 ff ff       	call   801858 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e70:	90                   	nop
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e77:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	6a 00                	push   $0x0
  801e85:	53                   	push   %ebx
  801e86:	51                   	push   %ecx
  801e87:	52                   	push   %edx
  801e88:	50                   	push   %eax
  801e89:	6a 2e                	push   $0x2e
  801e8b:	e8 c8 f9 ff ff       	call   801858 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	52                   	push   %edx
  801ea8:	50                   	push   %eax
  801ea9:	6a 2f                	push   $0x2f
  801eab:	e8 a8 f9 ff ff       	call   801858 <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801ebb:	8d 45 10             	lea    0x10(%ebp),%eax
  801ebe:	83 c0 04             	add    $0x4,%eax
  801ec1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801ec4:	a1 60 3e 83 00       	mov    0x833e60,%eax
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	74 16                	je     801ee3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801ecd:	a1 60 3e 83 00       	mov    0x833e60,%eax
  801ed2:	83 ec 08             	sub    $0x8,%esp
  801ed5:	50                   	push   %eax
  801ed6:	68 58 28 80 00       	push   $0x802858
  801edb:	e8 83 e5 ff ff       	call   800463 <cprintf>
  801ee0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801ee3:	a1 00 30 80 00       	mov    0x803000,%eax
  801ee8:	ff 75 0c             	pushl  0xc(%ebp)
  801eeb:	ff 75 08             	pushl  0x8(%ebp)
  801eee:	50                   	push   %eax
  801eef:	68 5d 28 80 00       	push   $0x80285d
  801ef4:	e8 6a e5 ff ff       	call   800463 <cprintf>
  801ef9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801efc:	8b 45 10             	mov    0x10(%ebp),%eax
  801eff:	83 ec 08             	sub    $0x8,%esp
  801f02:	ff 75 f4             	pushl  -0xc(%ebp)
  801f05:	50                   	push   %eax
  801f06:	e8 ed e4 ff ff       	call   8003f8 <vcprintf>
  801f0b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801f0e:	83 ec 08             	sub    $0x8,%esp
  801f11:	6a 00                	push   $0x0
  801f13:	68 79 28 80 00       	push   $0x802879
  801f18:	e8 db e4 ff ff       	call   8003f8 <vcprintf>
  801f1d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801f20:	e8 5c e4 ff ff       	call   800381 <exit>

	// should not return here
	while (1) ;
  801f25:	eb fe                	jmp    801f25 <_panic+0x70>

00801f27 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801f2d:	a1 20 30 80 00       	mov    0x803020,%eax
  801f32:	8b 50 74             	mov    0x74(%eax),%edx
  801f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f38:	39 c2                	cmp    %eax,%edx
  801f3a:	74 14                	je     801f50 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801f3c:	83 ec 04             	sub    $0x4,%esp
  801f3f:	68 7c 28 80 00       	push   $0x80287c
  801f44:	6a 26                	push   $0x26
  801f46:	68 c8 28 80 00       	push   $0x8028c8
  801f4b:	e8 65 ff ff ff       	call   801eb5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801f50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801f57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801f5e:	e9 b6 00 00 00       	jmp    802019 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  801f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	01 d0                	add    %edx,%eax
  801f72:	8b 00                	mov    (%eax),%eax
  801f74:	85 c0                	test   %eax,%eax
  801f76:	75 08                	jne    801f80 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801f78:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801f7b:	e9 96 00 00 00       	jmp    802016 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  801f80:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801f87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801f8e:	eb 5d                	jmp    801fed <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801f90:	a1 20 30 80 00       	mov    0x803020,%eax
  801f95:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801f9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f9e:	c1 e2 04             	shl    $0x4,%edx
  801fa1:	01 d0                	add    %edx,%eax
  801fa3:	8a 40 04             	mov    0x4(%eax),%al
  801fa6:	84 c0                	test   %al,%al
  801fa8:	75 40                	jne    801fea <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801faa:	a1 20 30 80 00       	mov    0x803020,%eax
  801faf:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801fb5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fb8:	c1 e2 04             	shl    $0x4,%edx
  801fbb:	01 d0                	add    %edx,%eax
  801fbd:	8b 00                	mov    (%eax),%eax
  801fbf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801fc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fc5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801fca:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	01 c8                	add    %ecx,%eax
  801fdb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801fdd:	39 c2                	cmp    %eax,%edx
  801fdf:	75 09                	jne    801fea <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  801fe1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801fe8:	eb 12                	jmp    801ffc <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801fea:	ff 45 e8             	incl   -0x18(%ebp)
  801fed:	a1 20 30 80 00       	mov    0x803020,%eax
  801ff2:	8b 50 74             	mov    0x74(%eax),%edx
  801ff5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ff8:	39 c2                	cmp    %eax,%edx
  801ffa:	77 94                	ja     801f90 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801ffc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802000:	75 14                	jne    802016 <CheckWSWithoutLastIndex+0xef>
			panic(
  802002:	83 ec 04             	sub    $0x4,%esp
  802005:	68 d4 28 80 00       	push   $0x8028d4
  80200a:	6a 3a                	push   $0x3a
  80200c:	68 c8 28 80 00       	push   $0x8028c8
  802011:	e8 9f fe ff ff       	call   801eb5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802016:	ff 45 f0             	incl   -0x10(%ebp)
  802019:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80201f:	0f 8c 3e ff ff ff    	jl     801f63 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802025:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80202c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802033:	eb 20                	jmp    802055 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802035:	a1 20 30 80 00       	mov    0x803020,%eax
  80203a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802040:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802043:	c1 e2 04             	shl    $0x4,%edx
  802046:	01 d0                	add    %edx,%eax
  802048:	8a 40 04             	mov    0x4(%eax),%al
  80204b:	3c 01                	cmp    $0x1,%al
  80204d:	75 03                	jne    802052 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80204f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802052:	ff 45 e0             	incl   -0x20(%ebp)
  802055:	a1 20 30 80 00       	mov    0x803020,%eax
  80205a:	8b 50 74             	mov    0x74(%eax),%edx
  80205d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802060:	39 c2                	cmp    %eax,%edx
  802062:	77 d1                	ja     802035 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80206a:	74 14                	je     802080 <CheckWSWithoutLastIndex+0x159>
		panic(
  80206c:	83 ec 04             	sub    $0x4,%esp
  80206f:	68 28 29 80 00       	push   $0x802928
  802074:	6a 44                	push   $0x44
  802076:	68 c8 28 80 00       	push   $0x8028c8
  80207b:	e8 35 fe ff ff       	call   801eb5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802080:	90                   	nop
  802081:	c9                   	leave  
  802082:	c3                   	ret    
  802083:	90                   	nop

00802084 <__udivdi3>:
  802084:	55                   	push   %ebp
  802085:	57                   	push   %edi
  802086:	56                   	push   %esi
  802087:	53                   	push   %ebx
  802088:	83 ec 1c             	sub    $0x1c,%esp
  80208b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80208f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802093:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802097:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80209b:	89 ca                	mov    %ecx,%edx
  80209d:	89 f8                	mov    %edi,%eax
  80209f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020a3:	85 f6                	test   %esi,%esi
  8020a5:	75 2d                	jne    8020d4 <__udivdi3+0x50>
  8020a7:	39 cf                	cmp    %ecx,%edi
  8020a9:	77 65                	ja     802110 <__udivdi3+0x8c>
  8020ab:	89 fd                	mov    %edi,%ebp
  8020ad:	85 ff                	test   %edi,%edi
  8020af:	75 0b                	jne    8020bc <__udivdi3+0x38>
  8020b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b6:	31 d2                	xor    %edx,%edx
  8020b8:	f7 f7                	div    %edi
  8020ba:	89 c5                	mov    %eax,%ebp
  8020bc:	31 d2                	xor    %edx,%edx
  8020be:	89 c8                	mov    %ecx,%eax
  8020c0:	f7 f5                	div    %ebp
  8020c2:	89 c1                	mov    %eax,%ecx
  8020c4:	89 d8                	mov    %ebx,%eax
  8020c6:	f7 f5                	div    %ebp
  8020c8:	89 cf                	mov    %ecx,%edi
  8020ca:	89 fa                	mov    %edi,%edx
  8020cc:	83 c4 1c             	add    $0x1c,%esp
  8020cf:	5b                   	pop    %ebx
  8020d0:	5e                   	pop    %esi
  8020d1:	5f                   	pop    %edi
  8020d2:	5d                   	pop    %ebp
  8020d3:	c3                   	ret    
  8020d4:	39 ce                	cmp    %ecx,%esi
  8020d6:	77 28                	ja     802100 <__udivdi3+0x7c>
  8020d8:	0f bd fe             	bsr    %esi,%edi
  8020db:	83 f7 1f             	xor    $0x1f,%edi
  8020de:	75 40                	jne    802120 <__udivdi3+0x9c>
  8020e0:	39 ce                	cmp    %ecx,%esi
  8020e2:	72 0a                	jb     8020ee <__udivdi3+0x6a>
  8020e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8020e8:	0f 87 9e 00 00 00    	ja     80218c <__udivdi3+0x108>
  8020ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f3:	89 fa                	mov    %edi,%edx
  8020f5:	83 c4 1c             	add    $0x1c,%esp
  8020f8:	5b                   	pop    %ebx
  8020f9:	5e                   	pop    %esi
  8020fa:	5f                   	pop    %edi
  8020fb:	5d                   	pop    %ebp
  8020fc:	c3                   	ret    
  8020fd:	8d 76 00             	lea    0x0(%esi),%esi
  802100:	31 ff                	xor    %edi,%edi
  802102:	31 c0                	xor    %eax,%eax
  802104:	89 fa                	mov    %edi,%edx
  802106:	83 c4 1c             	add    $0x1c,%esp
  802109:	5b                   	pop    %ebx
  80210a:	5e                   	pop    %esi
  80210b:	5f                   	pop    %edi
  80210c:	5d                   	pop    %ebp
  80210d:	c3                   	ret    
  80210e:	66 90                	xchg   %ax,%ax
  802110:	89 d8                	mov    %ebx,%eax
  802112:	f7 f7                	div    %edi
  802114:	31 ff                	xor    %edi,%edi
  802116:	89 fa                	mov    %edi,%edx
  802118:	83 c4 1c             	add    $0x1c,%esp
  80211b:	5b                   	pop    %ebx
  80211c:	5e                   	pop    %esi
  80211d:	5f                   	pop    %edi
  80211e:	5d                   	pop    %ebp
  80211f:	c3                   	ret    
  802120:	bd 20 00 00 00       	mov    $0x20,%ebp
  802125:	89 eb                	mov    %ebp,%ebx
  802127:	29 fb                	sub    %edi,%ebx
  802129:	89 f9                	mov    %edi,%ecx
  80212b:	d3 e6                	shl    %cl,%esi
  80212d:	89 c5                	mov    %eax,%ebp
  80212f:	88 d9                	mov    %bl,%cl
  802131:	d3 ed                	shr    %cl,%ebp
  802133:	89 e9                	mov    %ebp,%ecx
  802135:	09 f1                	or     %esi,%ecx
  802137:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80213b:	89 f9                	mov    %edi,%ecx
  80213d:	d3 e0                	shl    %cl,%eax
  80213f:	89 c5                	mov    %eax,%ebp
  802141:	89 d6                	mov    %edx,%esi
  802143:	88 d9                	mov    %bl,%cl
  802145:	d3 ee                	shr    %cl,%esi
  802147:	89 f9                	mov    %edi,%ecx
  802149:	d3 e2                	shl    %cl,%edx
  80214b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80214f:	88 d9                	mov    %bl,%cl
  802151:	d3 e8                	shr    %cl,%eax
  802153:	09 c2                	or     %eax,%edx
  802155:	89 d0                	mov    %edx,%eax
  802157:	89 f2                	mov    %esi,%edx
  802159:	f7 74 24 0c          	divl   0xc(%esp)
  80215d:	89 d6                	mov    %edx,%esi
  80215f:	89 c3                	mov    %eax,%ebx
  802161:	f7 e5                	mul    %ebp
  802163:	39 d6                	cmp    %edx,%esi
  802165:	72 19                	jb     802180 <__udivdi3+0xfc>
  802167:	74 0b                	je     802174 <__udivdi3+0xf0>
  802169:	89 d8                	mov    %ebx,%eax
  80216b:	31 ff                	xor    %edi,%edi
  80216d:	e9 58 ff ff ff       	jmp    8020ca <__udivdi3+0x46>
  802172:	66 90                	xchg   %ax,%ax
  802174:	8b 54 24 08          	mov    0x8(%esp),%edx
  802178:	89 f9                	mov    %edi,%ecx
  80217a:	d3 e2                	shl    %cl,%edx
  80217c:	39 c2                	cmp    %eax,%edx
  80217e:	73 e9                	jae    802169 <__udivdi3+0xe5>
  802180:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802183:	31 ff                	xor    %edi,%edi
  802185:	e9 40 ff ff ff       	jmp    8020ca <__udivdi3+0x46>
  80218a:	66 90                	xchg   %ax,%ax
  80218c:	31 c0                	xor    %eax,%eax
  80218e:	e9 37 ff ff ff       	jmp    8020ca <__udivdi3+0x46>
  802193:	90                   	nop

00802194 <__umoddi3>:
  802194:	55                   	push   %ebp
  802195:	57                   	push   %edi
  802196:	56                   	push   %esi
  802197:	53                   	push   %ebx
  802198:	83 ec 1c             	sub    $0x1c,%esp
  80219b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80219f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021a7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021b3:	89 f3                	mov    %esi,%ebx
  8021b5:	89 fa                	mov    %edi,%edx
  8021b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021bb:	89 34 24             	mov    %esi,(%esp)
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	75 1a                	jne    8021dc <__umoddi3+0x48>
  8021c2:	39 f7                	cmp    %esi,%edi
  8021c4:	0f 86 a2 00 00 00    	jbe    80226c <__umoddi3+0xd8>
  8021ca:	89 c8                	mov    %ecx,%eax
  8021cc:	89 f2                	mov    %esi,%edx
  8021ce:	f7 f7                	div    %edi
  8021d0:	89 d0                	mov    %edx,%eax
  8021d2:	31 d2                	xor    %edx,%edx
  8021d4:	83 c4 1c             	add    $0x1c,%esp
  8021d7:	5b                   	pop    %ebx
  8021d8:	5e                   	pop    %esi
  8021d9:	5f                   	pop    %edi
  8021da:	5d                   	pop    %ebp
  8021db:	c3                   	ret    
  8021dc:	39 f0                	cmp    %esi,%eax
  8021de:	0f 87 ac 00 00 00    	ja     802290 <__umoddi3+0xfc>
  8021e4:	0f bd e8             	bsr    %eax,%ebp
  8021e7:	83 f5 1f             	xor    $0x1f,%ebp
  8021ea:	0f 84 ac 00 00 00    	je     80229c <__umoddi3+0x108>
  8021f0:	bf 20 00 00 00       	mov    $0x20,%edi
  8021f5:	29 ef                	sub    %ebp,%edi
  8021f7:	89 fe                	mov    %edi,%esi
  8021f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021fd:	89 e9                	mov    %ebp,%ecx
  8021ff:	d3 e0                	shl    %cl,%eax
  802201:	89 d7                	mov    %edx,%edi
  802203:	89 f1                	mov    %esi,%ecx
  802205:	d3 ef                	shr    %cl,%edi
  802207:	09 c7                	or     %eax,%edi
  802209:	89 e9                	mov    %ebp,%ecx
  80220b:	d3 e2                	shl    %cl,%edx
  80220d:	89 14 24             	mov    %edx,(%esp)
  802210:	89 d8                	mov    %ebx,%eax
  802212:	d3 e0                	shl    %cl,%eax
  802214:	89 c2                	mov    %eax,%edx
  802216:	8b 44 24 08          	mov    0x8(%esp),%eax
  80221a:	d3 e0                	shl    %cl,%eax
  80221c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802220:	8b 44 24 08          	mov    0x8(%esp),%eax
  802224:	89 f1                	mov    %esi,%ecx
  802226:	d3 e8                	shr    %cl,%eax
  802228:	09 d0                	or     %edx,%eax
  80222a:	d3 eb                	shr    %cl,%ebx
  80222c:	89 da                	mov    %ebx,%edx
  80222e:	f7 f7                	div    %edi
  802230:	89 d3                	mov    %edx,%ebx
  802232:	f7 24 24             	mull   (%esp)
  802235:	89 c6                	mov    %eax,%esi
  802237:	89 d1                	mov    %edx,%ecx
  802239:	39 d3                	cmp    %edx,%ebx
  80223b:	0f 82 87 00 00 00    	jb     8022c8 <__umoddi3+0x134>
  802241:	0f 84 91 00 00 00    	je     8022d8 <__umoddi3+0x144>
  802247:	8b 54 24 04          	mov    0x4(%esp),%edx
  80224b:	29 f2                	sub    %esi,%edx
  80224d:	19 cb                	sbb    %ecx,%ebx
  80224f:	89 d8                	mov    %ebx,%eax
  802251:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802255:	d3 e0                	shl    %cl,%eax
  802257:	89 e9                	mov    %ebp,%ecx
  802259:	d3 ea                	shr    %cl,%edx
  80225b:	09 d0                	or     %edx,%eax
  80225d:	89 e9                	mov    %ebp,%ecx
  80225f:	d3 eb                	shr    %cl,%ebx
  802261:	89 da                	mov    %ebx,%edx
  802263:	83 c4 1c             	add    $0x1c,%esp
  802266:	5b                   	pop    %ebx
  802267:	5e                   	pop    %esi
  802268:	5f                   	pop    %edi
  802269:	5d                   	pop    %ebp
  80226a:	c3                   	ret    
  80226b:	90                   	nop
  80226c:	89 fd                	mov    %edi,%ebp
  80226e:	85 ff                	test   %edi,%edi
  802270:	75 0b                	jne    80227d <__umoddi3+0xe9>
  802272:	b8 01 00 00 00       	mov    $0x1,%eax
  802277:	31 d2                	xor    %edx,%edx
  802279:	f7 f7                	div    %edi
  80227b:	89 c5                	mov    %eax,%ebp
  80227d:	89 f0                	mov    %esi,%eax
  80227f:	31 d2                	xor    %edx,%edx
  802281:	f7 f5                	div    %ebp
  802283:	89 c8                	mov    %ecx,%eax
  802285:	f7 f5                	div    %ebp
  802287:	89 d0                	mov    %edx,%eax
  802289:	e9 44 ff ff ff       	jmp    8021d2 <__umoddi3+0x3e>
  80228e:	66 90                	xchg   %ax,%ax
  802290:	89 c8                	mov    %ecx,%eax
  802292:	89 f2                	mov    %esi,%edx
  802294:	83 c4 1c             	add    $0x1c,%esp
  802297:	5b                   	pop    %ebx
  802298:	5e                   	pop    %esi
  802299:	5f                   	pop    %edi
  80229a:	5d                   	pop    %ebp
  80229b:	c3                   	ret    
  80229c:	3b 04 24             	cmp    (%esp),%eax
  80229f:	72 06                	jb     8022a7 <__umoddi3+0x113>
  8022a1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8022a5:	77 0f                	ja     8022b6 <__umoddi3+0x122>
  8022a7:	89 f2                	mov    %esi,%edx
  8022a9:	29 f9                	sub    %edi,%ecx
  8022ab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8022af:	89 14 24             	mov    %edx,(%esp)
  8022b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022b6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022ba:	8b 14 24             	mov    (%esp),%edx
  8022bd:	83 c4 1c             	add    $0x1c,%esp
  8022c0:	5b                   	pop    %ebx
  8022c1:	5e                   	pop    %esi
  8022c2:	5f                   	pop    %edi
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    
  8022c5:	8d 76 00             	lea    0x0(%esi),%esi
  8022c8:	2b 04 24             	sub    (%esp),%eax
  8022cb:	19 fa                	sbb    %edi,%edx
  8022cd:	89 d1                	mov    %edx,%ecx
  8022cf:	89 c6                	mov    %eax,%esi
  8022d1:	e9 71 ff ff ff       	jmp    802247 <__umoddi3+0xb3>
  8022d6:	66 90                	xchg   %ax,%ax
  8022d8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8022dc:	72 ea                	jb     8022c8 <__umoddi3+0x134>
  8022de:	89 d9                	mov    %ebx,%ecx
  8022e0:	e9 62 ff ff ff       	jmp    802247 <__umoddi3+0xb3>
