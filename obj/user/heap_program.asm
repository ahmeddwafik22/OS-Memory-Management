
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 ed 01 00 00       	call   800223 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int kilo = 1024;
  800041:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 d0             	pushl  -0x30(%ebp)
  800066:	e8 29 13 00 00       	call   801394 <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 18 13 00 00       	call   801394 <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 67 1b 00 00       	call   801bee <sys_pf_calculate_allocated_pages>
  800087:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-1;
  80008a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000a8:	c1 e0 03             	shl    $0x3,%eax
  8000ab:	89 c2                	mov    %eax,%edx
  8000ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000b0:	01 d0                	add    %edx,%eax
  8000b2:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	89 d0                	mov    %edx,%eax
  8000ba:	01 c0                	add    %eax,%eax
  8000bc:	01 d0                	add    %edx,%eax
  8000be:	c1 e0 02             	shl    $0x2,%eax
  8000c1:	89 c2                	mov    %eax,%edx
  8000c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000c6:	01 d0                	add    %edx,%eax
  8000c8:	c6 00 ff             	movb   $0xff,(%eax)

		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;

		free(x);
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	ff 75 cc             	pushl  -0x34(%ebp)
  8000d1:	e8 79 17 00 00       	call   80184f <free>
  8000d6:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	ff 75 c8             	pushl  -0x38(%ebp)
  8000df:	e8 6b 17 00 00       	call   80184f <free>
  8000e4:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  8000e7:	e8 7f 1a 00 00       	call   801b6b <sys_calculate_free_frames>
  8000ec:	89 45 c0             	mov    %eax,-0x40(%ebp)

		x = malloc(sizeof(char)*size) ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	ff 75 d0             	pushl  -0x30(%ebp)
  8000f5:	e8 9a 12 00 00       	call   801394 <malloc>
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	89 45 cc             	mov    %eax,-0x34(%ebp)

		x[1]=-2;
  800100:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800103:	40                   	inc    %eax
  800104:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  800107:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80010a:	89 d0                	mov    %edx,%eax
  80010c:	c1 e0 02             	shl    $0x2,%eax
  80010f:	01 d0                	add    %edx,%eax
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800116:	01 d0                	add    %edx,%eax
  800118:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80011b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80011e:	c1 e0 03             	shl    $0x3,%eax
  800121:	89 c2                	mov    %eax,%edx
  800123:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800126:	01 d0                	add    %edx,%eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[12*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	01 c0                	add    %eax,%eax
  800132:	01 d0                	add    %edx,%eax
  800134:	c1 e0 02             	shl    $0x2,%eax
  800137:	89 c2                	mov    %eax,%edx
  800139:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	c6 00 fe             	movb   $0xfe,(%eax)

		uint32 pageWSEntries[8] = {0x802000, 0x80500000, 0x80800000, 0x80c00000, 0x80000000, 0x801000, 0x800000, 0xeebfd000};
  800141:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800144:	bb 80 23 80 00       	mov    $0x802380,%ebx
  800149:	ba 08 00 00 00       	mov    $0x8,%edx
  80014e:	89 c7                	mov    %eax,%edi
  800150:	89 de                	mov    %ebx,%esi
  800152:	89 d1                	mov    %edx,%ecx
  800154:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800156:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < (myEnv->page_WS_max_size); i++)
  80015d:	eb 73                	jmp    8001d2 <_main+0x19a>
		{
			int found = 0 ;
  80015f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800166:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80016d:	eb 37                	jmp    8001a6 <_main+0x16e>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  80016f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800172:	8b 54 85 9c          	mov    -0x64(%ebp,%eax,4),%edx
  800176:	a1 20 30 80 00       	mov    0x803020,%eax
  80017b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800181:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800184:	c1 e1 04             	shl    $0x4,%ecx
  800187:	01 c8                	add    %ecx,%eax
  800189:	8b 00                	mov    (%eax),%eax
  80018b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80018e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800191:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800196:	39 c2                	cmp    %eax,%edx
  800198:	75 09                	jne    8001a3 <_main+0x16b>
				{
					found = 1 ;
  80019a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001a1:	eb 12                	jmp    8001b5 <_main+0x17d>

		int i = 0, j ;
		for (; i < (myEnv->page_WS_max_size); i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001a3:	ff 45 e0             	incl   -0x20(%ebp)
  8001a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ab:	8b 50 74             	mov    0x74(%eax),%edx
  8001ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b1:	39 c2                	cmp    %eax,%edx
  8001b3:	77 ba                	ja     80016f <_main+0x137>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001b5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001b9:	75 14                	jne    8001cf <_main+0x197>
				panic("PAGE Placement algorithm failed after applying freeHeap");
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	68 c0 22 80 00       	push   $0x8022c0
  8001c3:	6a 41                	push   $0x41
  8001c5:	68 f8 22 80 00       	push   $0x8022f8
  8001ca:	e8 99 01 00 00       	call   800368 <_panic>
		x[12*Mega]=-2;

		uint32 pageWSEntries[8] = {0x802000, 0x80500000, 0x80800000, 0x80c00000, 0x80000000, 0x801000, 0x800000, 0xeebfd000};

		int i = 0, j ;
		for (; i < (myEnv->page_WS_max_size); i++)
  8001cf:	ff 45 e4             	incl   -0x1c(%ebp)
  8001d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d7:	8b 50 74             	mov    0x74(%eax),%edx
  8001da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001dd:	39 c2                	cmp    %eax,%edx
  8001df:	0f 87 7a ff ff ff    	ja     80015f <_main+0x127>
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap");
		}


		if( (freePages - sys_calculate_free_frames() ) != 8 ) panic("Extra/Less memory are wrongly allocated");
  8001e5:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8001e8:	e8 7e 19 00 00       	call   801b6b <sys_calculate_free_frames>
  8001ed:	29 c3                	sub    %eax,%ebx
  8001ef:	89 d8                	mov    %ebx,%eax
  8001f1:	83 f8 08             	cmp    $0x8,%eax
  8001f4:	74 14                	je     80020a <_main+0x1d2>
  8001f6:	83 ec 04             	sub    $0x4,%esp
  8001f9:	68 0c 23 80 00       	push   $0x80230c
  8001fe:	6a 45                	push   $0x45
  800200:	68 f8 22 80 00       	push   $0x8022f8
  800205:	e8 5e 01 00 00       	call   800368 <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	68 34 23 80 00       	push   $0x802334
  800212:	e8 f3 03 00 00       	call   80060a <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp


	return;
  80021a:	90                   	nop
}
  80021b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80021e:	5b                   	pop    %ebx
  80021f:	5e                   	pop    %esi
  800220:	5f                   	pop    %edi
  800221:	5d                   	pop    %ebp
  800222:	c3                   	ret    

00800223 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800229:	e8 72 18 00 00       	call   801aa0 <sys_getenvindex>
  80022e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800231:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800234:	89 d0                	mov    %edx,%eax
  800236:	c1 e0 03             	shl    $0x3,%eax
  800239:	01 d0                	add    %edx,%eax
  80023b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800242:	01 c8                	add    %ecx,%eax
  800244:	01 c0                	add    %eax,%eax
  800246:	01 d0                	add    %edx,%eax
  800248:	01 c0                	add    %eax,%eax
  80024a:	01 d0                	add    %edx,%eax
  80024c:	89 c2                	mov    %eax,%edx
  80024e:	c1 e2 05             	shl    $0x5,%edx
  800251:	29 c2                	sub    %eax,%edx
  800253:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80025a:	89 c2                	mov    %eax,%edx
  80025c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800262:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800267:	a1 20 30 80 00       	mov    0x803020,%eax
  80026c:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800272:	84 c0                	test   %al,%al
  800274:	74 0f                	je     800285 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800276:	a1 20 30 80 00       	mov    0x803020,%eax
  80027b:	05 40 3c 01 00       	add    $0x13c40,%eax
  800280:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800285:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800289:	7e 0a                	jle    800295 <libmain+0x72>
		binaryname = argv[0];
  80028b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028e:	8b 00                	mov    (%eax),%eax
  800290:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800295:	83 ec 08             	sub    $0x8,%esp
  800298:	ff 75 0c             	pushl  0xc(%ebp)
  80029b:	ff 75 08             	pushl  0x8(%ebp)
  80029e:	e8 95 fd ff ff       	call   800038 <_main>
  8002a3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002a6:	e8 90 19 00 00       	call   801c3b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 b8 23 80 00       	push   $0x8023b8
  8002b3:	e8 52 03 00 00       	call   80060a <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c0:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8002c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cb:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8002d1:	83 ec 04             	sub    $0x4,%esp
  8002d4:	52                   	push   %edx
  8002d5:	50                   	push   %eax
  8002d6:	68 e0 23 80 00       	push   $0x8023e0
  8002db:	e8 2a 03 00 00       	call   80060a <cprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8002e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e8:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8002ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f3:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	52                   	push   %edx
  8002fd:	50                   	push   %eax
  8002fe:	68 08 24 80 00       	push   $0x802408
  800303:	e8 02 03 00 00       	call   80060a <cprintf>
  800308:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80030b:	a1 20 30 80 00       	mov    0x803020,%eax
  800310:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	50                   	push   %eax
  80031a:	68 49 24 80 00       	push   $0x802449
  80031f:	e8 e6 02 00 00       	call   80060a <cprintf>
  800324:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	68 b8 23 80 00       	push   $0x8023b8
  80032f:	e8 d6 02 00 00       	call   80060a <cprintf>
  800334:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800337:	e8 19 19 00 00       	call   801c55 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80033c:	e8 19 00 00 00       	call   80035a <exit>
}
  800341:	90                   	nop
  800342:	c9                   	leave  
  800343:	c3                   	ret    

00800344 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	6a 00                	push   $0x0
  80034f:	e8 18 17 00 00       	call   801a6c <sys_env_destroy>
  800354:	83 c4 10             	add    $0x10,%esp
}
  800357:	90                   	nop
  800358:	c9                   	leave  
  800359:	c3                   	ret    

0080035a <exit>:

void
exit(void)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800360:	e8 6d 17 00 00       	call   801ad2 <sys_env_exit>
}
  800365:	90                   	nop
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80036e:	8d 45 10             	lea    0x10(%ebp),%eax
  800371:	83 c0 04             	add    $0x4,%eax
  800374:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800377:	a1 18 31 80 00       	mov    0x803118,%eax
  80037c:	85 c0                	test   %eax,%eax
  80037e:	74 16                	je     800396 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800380:	a1 18 31 80 00       	mov    0x803118,%eax
  800385:	83 ec 08             	sub    $0x8,%esp
  800388:	50                   	push   %eax
  800389:	68 60 24 80 00       	push   $0x802460
  80038e:	e8 77 02 00 00       	call   80060a <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800396:	a1 00 30 80 00       	mov    0x803000,%eax
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	50                   	push   %eax
  8003a2:	68 65 24 80 00       	push   $0x802465
  8003a7:	e8 5e 02 00 00       	call   80060a <cprintf>
  8003ac:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003af:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b2:	83 ec 08             	sub    $0x8,%esp
  8003b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8003b8:	50                   	push   %eax
  8003b9:	e8 e1 01 00 00       	call   80059f <vcprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	6a 00                	push   $0x0
  8003c6:	68 81 24 80 00       	push   $0x802481
  8003cb:	e8 cf 01 00 00       	call   80059f <vcprintf>
  8003d0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003d3:	e8 82 ff ff ff       	call   80035a <exit>

	// should not return here
	while (1) ;
  8003d8:	eb fe                	jmp    8003d8 <_panic+0x70>

008003da <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e5:	8b 50 74             	mov    0x74(%eax),%edx
  8003e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003eb:	39 c2                	cmp    %eax,%edx
  8003ed:	74 14                	je     800403 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003ef:	83 ec 04             	sub    $0x4,%esp
  8003f2:	68 84 24 80 00       	push   $0x802484
  8003f7:	6a 26                	push   $0x26
  8003f9:	68 d0 24 80 00       	push   $0x8024d0
  8003fe:	e8 65 ff ff ff       	call   800368 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800403:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80040a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800411:	e9 b6 00 00 00       	jmp    8004cc <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800416:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800419:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800420:	8b 45 08             	mov    0x8(%ebp),%eax
  800423:	01 d0                	add    %edx,%eax
  800425:	8b 00                	mov    (%eax),%eax
  800427:	85 c0                	test   %eax,%eax
  800429:	75 08                	jne    800433 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80042b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80042e:	e9 96 00 00 00       	jmp    8004c9 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800433:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800441:	eb 5d                	jmp    8004a0 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800443:	a1 20 30 80 00       	mov    0x803020,%eax
  800448:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80044e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800451:	c1 e2 04             	shl    $0x4,%edx
  800454:	01 d0                	add    %edx,%eax
  800456:	8a 40 04             	mov    0x4(%eax),%al
  800459:	84 c0                	test   %al,%al
  80045b:	75 40                	jne    80049d <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80045d:	a1 20 30 80 00       	mov    0x803020,%eax
  800462:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800468:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80046b:	c1 e2 04             	shl    $0x4,%edx
  80046e:	01 d0                	add    %edx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800475:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800478:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80047d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800482:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800489:	8b 45 08             	mov    0x8(%ebp),%eax
  80048c:	01 c8                	add    %ecx,%eax
  80048e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800490:	39 c2                	cmp    %eax,%edx
  800492:	75 09                	jne    80049d <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800494:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80049b:	eb 12                	jmp    8004af <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80049d:	ff 45 e8             	incl   -0x18(%ebp)
  8004a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a5:	8b 50 74             	mov    0x74(%eax),%edx
  8004a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ab:	39 c2                	cmp    %eax,%edx
  8004ad:	77 94                	ja     800443 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004b3:	75 14                	jne    8004c9 <CheckWSWithoutLastIndex+0xef>
			panic(
  8004b5:	83 ec 04             	sub    $0x4,%esp
  8004b8:	68 dc 24 80 00       	push   $0x8024dc
  8004bd:	6a 3a                	push   $0x3a
  8004bf:	68 d0 24 80 00       	push   $0x8024d0
  8004c4:	e8 9f fe ff ff       	call   800368 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004c9:	ff 45 f0             	incl   -0x10(%ebp)
  8004cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004d2:	0f 8c 3e ff ff ff    	jl     800416 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004e6:	eb 20                	jmp    800508 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ed:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8004f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004f6:	c1 e2 04             	shl    $0x4,%edx
  8004f9:	01 d0                	add    %edx,%eax
  8004fb:	8a 40 04             	mov    0x4(%eax),%al
  8004fe:	3c 01                	cmp    $0x1,%al
  800500:	75 03                	jne    800505 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800502:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800505:	ff 45 e0             	incl   -0x20(%ebp)
  800508:	a1 20 30 80 00       	mov    0x803020,%eax
  80050d:	8b 50 74             	mov    0x74(%eax),%edx
  800510:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800513:	39 c2                	cmp    %eax,%edx
  800515:	77 d1                	ja     8004e8 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80051d:	74 14                	je     800533 <CheckWSWithoutLastIndex+0x159>
		panic(
  80051f:	83 ec 04             	sub    $0x4,%esp
  800522:	68 30 25 80 00       	push   $0x802530
  800527:	6a 44                	push   $0x44
  800529:	68 d0 24 80 00       	push   $0x8024d0
  80052e:	e8 35 fe ff ff       	call   800368 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800533:	90                   	nop
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80053c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	8d 48 01             	lea    0x1(%eax),%ecx
  800544:	8b 55 0c             	mov    0xc(%ebp),%edx
  800547:	89 0a                	mov    %ecx,(%edx)
  800549:	8b 55 08             	mov    0x8(%ebp),%edx
  80054c:	88 d1                	mov    %dl,%cl
  80054e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800551:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800555:	8b 45 0c             	mov    0xc(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80055f:	75 2c                	jne    80058d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800561:	a0 24 30 80 00       	mov    0x803024,%al
  800566:	0f b6 c0             	movzbl %al,%eax
  800569:	8b 55 0c             	mov    0xc(%ebp),%edx
  80056c:	8b 12                	mov    (%edx),%edx
  80056e:	89 d1                	mov    %edx,%ecx
  800570:	8b 55 0c             	mov    0xc(%ebp),%edx
  800573:	83 c2 08             	add    $0x8,%edx
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	50                   	push   %eax
  80057a:	51                   	push   %ecx
  80057b:	52                   	push   %edx
  80057c:	e8 a9 14 00 00       	call   801a2a <sys_cputs>
  800581:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800584:	8b 45 0c             	mov    0xc(%ebp),%eax
  800587:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80058d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800590:	8b 40 04             	mov    0x4(%eax),%eax
  800593:	8d 50 01             	lea    0x1(%eax),%edx
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	89 50 04             	mov    %edx,0x4(%eax)
}
  80059c:	90                   	nop
  80059d:	c9                   	leave  
  80059e:	c3                   	ret    

0080059f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
  8005a2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005a8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005af:	00 00 00 
	b.cnt = 0;
  8005b2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005b9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005bc:	ff 75 0c             	pushl  0xc(%ebp)
  8005bf:	ff 75 08             	pushl  0x8(%ebp)
  8005c2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005c8:	50                   	push   %eax
  8005c9:	68 36 05 80 00       	push   $0x800536
  8005ce:	e8 11 02 00 00       	call   8007e4 <vprintfmt>
  8005d3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005d6:	a0 24 30 80 00       	mov    0x803024,%al
  8005db:	0f b6 c0             	movzbl %al,%eax
  8005de:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005e4:	83 ec 04             	sub    $0x4,%esp
  8005e7:	50                   	push   %eax
  8005e8:	52                   	push   %edx
  8005e9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ef:	83 c0 08             	add    $0x8,%eax
  8005f2:	50                   	push   %eax
  8005f3:	e8 32 14 00 00       	call   801a2a <sys_cputs>
  8005f8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005fb:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800602:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800608:	c9                   	leave  
  800609:	c3                   	ret    

0080060a <cprintf>:

int cprintf(const char *fmt, ...) {
  80060a:	55                   	push   %ebp
  80060b:	89 e5                	mov    %esp,%ebp
  80060d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800610:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800617:	8d 45 0c             	lea    0xc(%ebp),%eax
  80061a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80061d:	8b 45 08             	mov    0x8(%ebp),%eax
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	ff 75 f4             	pushl  -0xc(%ebp)
  800626:	50                   	push   %eax
  800627:	e8 73 ff ff ff       	call   80059f <vcprintf>
  80062c:	83 c4 10             	add    $0x10,%esp
  80062f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800632:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800635:	c9                   	leave  
  800636:	c3                   	ret    

00800637 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
  80063a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80063d:	e8 f9 15 00 00       	call   801c3b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800642:	8d 45 0c             	lea    0xc(%ebp),%eax
  800645:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	ff 75 f4             	pushl  -0xc(%ebp)
  800651:	50                   	push   %eax
  800652:	e8 48 ff ff ff       	call   80059f <vcprintf>
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80065d:	e8 f3 15 00 00       	call   801c55 <sys_enable_interrupt>
	return cnt;
  800662:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
  80066a:	53                   	push   %ebx
  80066b:	83 ec 14             	sub    $0x14,%esp
  80066e:	8b 45 10             	mov    0x10(%ebp),%eax
  800671:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80067a:	8b 45 18             	mov    0x18(%ebp),%eax
  80067d:	ba 00 00 00 00       	mov    $0x0,%edx
  800682:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800685:	77 55                	ja     8006dc <printnum+0x75>
  800687:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80068a:	72 05                	jb     800691 <printnum+0x2a>
  80068c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80068f:	77 4b                	ja     8006dc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800691:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800694:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800697:	8b 45 18             	mov    0x18(%ebp),%eax
  80069a:	ba 00 00 00 00       	mov    $0x0,%edx
  80069f:	52                   	push   %edx
  8006a0:	50                   	push   %eax
  8006a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8006a7:	e8 b0 19 00 00       	call   80205c <__udivdi3>
  8006ac:	83 c4 10             	add    $0x10,%esp
  8006af:	83 ec 04             	sub    $0x4,%esp
  8006b2:	ff 75 20             	pushl  0x20(%ebp)
  8006b5:	53                   	push   %ebx
  8006b6:	ff 75 18             	pushl  0x18(%ebp)
  8006b9:	52                   	push   %edx
  8006ba:	50                   	push   %eax
  8006bb:	ff 75 0c             	pushl  0xc(%ebp)
  8006be:	ff 75 08             	pushl  0x8(%ebp)
  8006c1:	e8 a1 ff ff ff       	call   800667 <printnum>
  8006c6:	83 c4 20             	add    $0x20,%esp
  8006c9:	eb 1a                	jmp    8006e5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	ff 75 20             	pushl  0x20(%ebp)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	ff d0                	call   *%eax
  8006d9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006dc:	ff 4d 1c             	decl   0x1c(%ebp)
  8006df:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006e3:	7f e6                	jg     8006cb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006e5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006f3:	53                   	push   %ebx
  8006f4:	51                   	push   %ecx
  8006f5:	52                   	push   %edx
  8006f6:	50                   	push   %eax
  8006f7:	e8 70 1a 00 00       	call   80216c <__umoddi3>
  8006fc:	83 c4 10             	add    $0x10,%esp
  8006ff:	05 94 27 80 00       	add    $0x802794,%eax
  800704:	8a 00                	mov    (%eax),%al
  800706:	0f be c0             	movsbl %al,%eax
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	ff 75 0c             	pushl  0xc(%ebp)
  80070f:	50                   	push   %eax
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	ff d0                	call   *%eax
  800715:	83 c4 10             	add    $0x10,%esp
}
  800718:	90                   	nop
  800719:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800721:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800725:	7e 1c                	jle    800743 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	8d 50 08             	lea    0x8(%eax),%edx
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	89 10                	mov    %edx,(%eax)
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	8b 00                	mov    (%eax),%eax
  800739:	83 e8 08             	sub    $0x8,%eax
  80073c:	8b 50 04             	mov    0x4(%eax),%edx
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	eb 40                	jmp    800783 <getuint+0x65>
	else if (lflag)
  800743:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800747:	74 1e                	je     800767 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	8d 50 04             	lea    0x4(%eax),%edx
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	89 10                	mov    %edx,(%eax)
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	83 e8 04             	sub    $0x4,%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	ba 00 00 00 00       	mov    $0x0,%edx
  800765:	eb 1c                	jmp    800783 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	8d 50 04             	lea    0x4(%eax),%edx
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	89 10                	mov    %edx,(%eax)
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	83 e8 04             	sub    $0x4,%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800783:	5d                   	pop    %ebp
  800784:	c3                   	ret    

00800785 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800785:	55                   	push   %ebp
  800786:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800788:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80078c:	7e 1c                	jle    8007aa <getint+0x25>
		return va_arg(*ap, long long);
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	8b 00                	mov    (%eax),%eax
  800793:	8d 50 08             	lea    0x8(%eax),%edx
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	89 10                	mov    %edx,(%eax)
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	83 e8 08             	sub    $0x8,%eax
  8007a3:	8b 50 04             	mov    0x4(%eax),%edx
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	eb 38                	jmp    8007e2 <getint+0x5d>
	else if (lflag)
  8007aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ae:	74 1a                	je     8007ca <getint+0x45>
		return va_arg(*ap, long);
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	8d 50 04             	lea    0x4(%eax),%edx
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	89 10                	mov    %edx,(%eax)
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	83 e8 04             	sub    $0x4,%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	99                   	cltd   
  8007c8:	eb 18                	jmp    8007e2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	8d 50 04             	lea    0x4(%eax),%edx
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	89 10                	mov    %edx,(%eax)
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	83 e8 04             	sub    $0x4,%eax
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	99                   	cltd   
}
  8007e2:	5d                   	pop    %ebp
  8007e3:	c3                   	ret    

008007e4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007e4:	55                   	push   %ebp
  8007e5:	89 e5                	mov    %esp,%ebp
  8007e7:	56                   	push   %esi
  8007e8:	53                   	push   %ebx
  8007e9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ec:	eb 17                	jmp    800805 <vprintfmt+0x21>
			if (ch == '\0')
  8007ee:	85 db                	test   %ebx,%ebx
  8007f0:	0f 84 af 03 00 00    	je     800ba5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	ff 75 0c             	pushl  0xc(%ebp)
  8007fc:	53                   	push   %ebx
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	ff d0                	call   *%eax
  800802:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800805:	8b 45 10             	mov    0x10(%ebp),%eax
  800808:	8d 50 01             	lea    0x1(%eax),%edx
  80080b:	89 55 10             	mov    %edx,0x10(%ebp)
  80080e:	8a 00                	mov    (%eax),%al
  800810:	0f b6 d8             	movzbl %al,%ebx
  800813:	83 fb 25             	cmp    $0x25,%ebx
  800816:	75 d6                	jne    8007ee <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800818:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80081c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800823:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80082a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800831:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800838:	8b 45 10             	mov    0x10(%ebp),%eax
  80083b:	8d 50 01             	lea    0x1(%eax),%edx
  80083e:	89 55 10             	mov    %edx,0x10(%ebp)
  800841:	8a 00                	mov    (%eax),%al
  800843:	0f b6 d8             	movzbl %al,%ebx
  800846:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800849:	83 f8 55             	cmp    $0x55,%eax
  80084c:	0f 87 2b 03 00 00    	ja     800b7d <vprintfmt+0x399>
  800852:	8b 04 85 b8 27 80 00 	mov    0x8027b8(,%eax,4),%eax
  800859:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80085b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80085f:	eb d7                	jmp    800838 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800861:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800865:	eb d1                	jmp    800838 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800867:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80086e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800871:	89 d0                	mov    %edx,%eax
  800873:	c1 e0 02             	shl    $0x2,%eax
  800876:	01 d0                	add    %edx,%eax
  800878:	01 c0                	add    %eax,%eax
  80087a:	01 d8                	add    %ebx,%eax
  80087c:	83 e8 30             	sub    $0x30,%eax
  80087f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800882:	8b 45 10             	mov    0x10(%ebp),%eax
  800885:	8a 00                	mov    (%eax),%al
  800887:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80088a:	83 fb 2f             	cmp    $0x2f,%ebx
  80088d:	7e 3e                	jle    8008cd <vprintfmt+0xe9>
  80088f:	83 fb 39             	cmp    $0x39,%ebx
  800892:	7f 39                	jg     8008cd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800894:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800897:	eb d5                	jmp    80086e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	83 c0 04             	add    $0x4,%eax
  80089f:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	83 e8 04             	sub    $0x4,%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008ad:	eb 1f                	jmp    8008ce <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b3:	79 83                	jns    800838 <vprintfmt+0x54>
				width = 0;
  8008b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008bc:	e9 77 ff ff ff       	jmp    800838 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008c1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008c8:	e9 6b ff ff ff       	jmp    800838 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008cd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d2:	0f 89 60 ff ff ff    	jns    800838 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008de:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008e5:	e9 4e ff ff ff       	jmp    800838 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008ea:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ed:	e9 46 ff ff ff       	jmp    800838 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	83 c0 04             	add    $0x4,%eax
  8008f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	83 e8 04             	sub    $0x4,%eax
  800901:	8b 00                	mov    (%eax),%eax
  800903:	83 ec 08             	sub    $0x8,%esp
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	50                   	push   %eax
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
			break;
  800912:	e9 89 02 00 00       	jmp    800ba0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800917:	8b 45 14             	mov    0x14(%ebp),%eax
  80091a:	83 c0 04             	add    $0x4,%eax
  80091d:	89 45 14             	mov    %eax,0x14(%ebp)
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	83 e8 04             	sub    $0x4,%eax
  800926:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800928:	85 db                	test   %ebx,%ebx
  80092a:	79 02                	jns    80092e <vprintfmt+0x14a>
				err = -err;
  80092c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80092e:	83 fb 64             	cmp    $0x64,%ebx
  800931:	7f 0b                	jg     80093e <vprintfmt+0x15a>
  800933:	8b 34 9d 00 26 80 00 	mov    0x802600(,%ebx,4),%esi
  80093a:	85 f6                	test   %esi,%esi
  80093c:	75 19                	jne    800957 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80093e:	53                   	push   %ebx
  80093f:	68 a5 27 80 00       	push   $0x8027a5
  800944:	ff 75 0c             	pushl  0xc(%ebp)
  800947:	ff 75 08             	pushl  0x8(%ebp)
  80094a:	e8 5e 02 00 00       	call   800bad <printfmt>
  80094f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800952:	e9 49 02 00 00       	jmp    800ba0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800957:	56                   	push   %esi
  800958:	68 ae 27 80 00       	push   $0x8027ae
  80095d:	ff 75 0c             	pushl  0xc(%ebp)
  800960:	ff 75 08             	pushl  0x8(%ebp)
  800963:	e8 45 02 00 00       	call   800bad <printfmt>
  800968:	83 c4 10             	add    $0x10,%esp
			break;
  80096b:	e9 30 02 00 00       	jmp    800ba0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800970:	8b 45 14             	mov    0x14(%ebp),%eax
  800973:	83 c0 04             	add    $0x4,%eax
  800976:	89 45 14             	mov    %eax,0x14(%ebp)
  800979:	8b 45 14             	mov    0x14(%ebp),%eax
  80097c:	83 e8 04             	sub    $0x4,%eax
  80097f:	8b 30                	mov    (%eax),%esi
  800981:	85 f6                	test   %esi,%esi
  800983:	75 05                	jne    80098a <vprintfmt+0x1a6>
				p = "(null)";
  800985:	be b1 27 80 00       	mov    $0x8027b1,%esi
			if (width > 0 && padc != '-')
  80098a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098e:	7e 6d                	jle    8009fd <vprintfmt+0x219>
  800990:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800994:	74 67                	je     8009fd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800996:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	50                   	push   %eax
  80099d:	56                   	push   %esi
  80099e:	e8 0c 03 00 00       	call   800caf <strnlen>
  8009a3:	83 c4 10             	add    $0x10,%esp
  8009a6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009a9:	eb 16                	jmp    8009c1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009ab:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	50                   	push   %eax
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	ff d0                	call   *%eax
  8009bb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009be:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c5:	7f e4                	jg     8009ab <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c7:	eb 34                	jmp    8009fd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009cd:	74 1c                	je     8009eb <vprintfmt+0x207>
  8009cf:	83 fb 1f             	cmp    $0x1f,%ebx
  8009d2:	7e 05                	jle    8009d9 <vprintfmt+0x1f5>
  8009d4:	83 fb 7e             	cmp    $0x7e,%ebx
  8009d7:	7e 12                	jle    8009eb <vprintfmt+0x207>
					putch('?', putdat);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	6a 3f                	push   $0x3f
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	ff d0                	call   *%eax
  8009e6:	83 c4 10             	add    $0x10,%esp
  8009e9:	eb 0f                	jmp    8009fa <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	53                   	push   %ebx
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009fa:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fd:	89 f0                	mov    %esi,%eax
  8009ff:	8d 70 01             	lea    0x1(%eax),%esi
  800a02:	8a 00                	mov    (%eax),%al
  800a04:	0f be d8             	movsbl %al,%ebx
  800a07:	85 db                	test   %ebx,%ebx
  800a09:	74 24                	je     800a2f <vprintfmt+0x24b>
  800a0b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a0f:	78 b8                	js     8009c9 <vprintfmt+0x1e5>
  800a11:	ff 4d e0             	decl   -0x20(%ebp)
  800a14:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a18:	79 af                	jns    8009c9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a1a:	eb 13                	jmp    800a2f <vprintfmt+0x24b>
				putch(' ', putdat);
  800a1c:	83 ec 08             	sub    $0x8,%esp
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	6a 20                	push   $0x20
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	ff d0                	call   *%eax
  800a29:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a2c:	ff 4d e4             	decl   -0x1c(%ebp)
  800a2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a33:	7f e7                	jg     800a1c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a35:	e9 66 01 00 00       	jmp    800ba0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a40:	8d 45 14             	lea    0x14(%ebp),%eax
  800a43:	50                   	push   %eax
  800a44:	e8 3c fd ff ff       	call   800785 <getint>
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a58:	85 d2                	test   %edx,%edx
  800a5a:	79 23                	jns    800a7f <vprintfmt+0x29b>
				putch('-', putdat);
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	6a 2d                	push   $0x2d
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	ff d0                	call   *%eax
  800a69:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a72:	f7 d8                	neg    %eax
  800a74:	83 d2 00             	adc    $0x0,%edx
  800a77:	f7 da                	neg    %edx
  800a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a7f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a86:	e9 bc 00 00 00       	jmp    800b47 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a8b:	83 ec 08             	sub    $0x8,%esp
  800a8e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a91:	8d 45 14             	lea    0x14(%ebp),%eax
  800a94:	50                   	push   %eax
  800a95:	e8 84 fc ff ff       	call   80071e <getuint>
  800a9a:	83 c4 10             	add    $0x10,%esp
  800a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aa3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aaa:	e9 98 00 00 00       	jmp    800b47 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aaf:	83 ec 08             	sub    $0x8,%esp
  800ab2:	ff 75 0c             	pushl  0xc(%ebp)
  800ab5:	6a 58                	push   $0x58
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	ff d0                	call   *%eax
  800abc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	6a 58                	push   $0x58
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	ff d0                	call   *%eax
  800acc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	ff 75 0c             	pushl  0xc(%ebp)
  800ad5:	6a 58                	push   $0x58
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	ff d0                	call   *%eax
  800adc:	83 c4 10             	add    $0x10,%esp
			break;
  800adf:	e9 bc 00 00 00       	jmp    800ba0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	6a 30                	push   $0x30
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800af4:	83 ec 08             	sub    $0x8,%esp
  800af7:	ff 75 0c             	pushl  0xc(%ebp)
  800afa:	6a 78                	push   $0x78
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	ff d0                	call   *%eax
  800b01:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b04:	8b 45 14             	mov    0x14(%ebp),%eax
  800b07:	83 c0 04             	add    $0x4,%eax
  800b0a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b10:	83 e8 04             	sub    $0x4,%eax
  800b13:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b1f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b26:	eb 1f                	jmp    800b47 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2e:	8d 45 14             	lea    0x14(%ebp),%eax
  800b31:	50                   	push   %eax
  800b32:	e8 e7 fb ff ff       	call   80071e <getuint>
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b40:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b47:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b4e:	83 ec 04             	sub    $0x4,%esp
  800b51:	52                   	push   %edx
  800b52:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b55:	50                   	push   %eax
  800b56:	ff 75 f4             	pushl  -0xc(%ebp)
  800b59:	ff 75 f0             	pushl  -0x10(%ebp)
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	ff 75 08             	pushl  0x8(%ebp)
  800b62:	e8 00 fb ff ff       	call   800667 <printnum>
  800b67:	83 c4 20             	add    $0x20,%esp
			break;
  800b6a:	eb 34                	jmp    800ba0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	53                   	push   %ebx
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	ff d0                	call   *%eax
  800b78:	83 c4 10             	add    $0x10,%esp
			break;
  800b7b:	eb 23                	jmp    800ba0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	6a 25                	push   $0x25
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	ff d0                	call   *%eax
  800b8a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b8d:	ff 4d 10             	decl   0x10(%ebp)
  800b90:	eb 03                	jmp    800b95 <vprintfmt+0x3b1>
  800b92:	ff 4d 10             	decl   0x10(%ebp)
  800b95:	8b 45 10             	mov    0x10(%ebp),%eax
  800b98:	48                   	dec    %eax
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	3c 25                	cmp    $0x25,%al
  800b9d:	75 f3                	jne    800b92 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b9f:	90                   	nop
		}
	}
  800ba0:	e9 47 fc ff ff       	jmp    8007ec <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ba5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ba6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ba9:	5b                   	pop    %ebx
  800baa:	5e                   	pop    %esi
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    

00800bad <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bb3:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb6:	83 c0 04             	add    $0x4,%eax
  800bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc2:	50                   	push   %eax
  800bc3:	ff 75 0c             	pushl  0xc(%ebp)
  800bc6:	ff 75 08             	pushl  0x8(%ebp)
  800bc9:	e8 16 fc ff ff       	call   8007e4 <vprintfmt>
  800bce:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bd1:	90                   	nop
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bda:	8b 40 08             	mov    0x8(%eax),%eax
  800bdd:	8d 50 01             	lea    0x1(%eax),%edx
  800be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	8b 10                	mov    (%eax),%edx
  800beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bee:	8b 40 04             	mov    0x4(%eax),%eax
  800bf1:	39 c2                	cmp    %eax,%edx
  800bf3:	73 12                	jae    800c07 <sprintputch+0x33>
		*b->buf++ = ch;
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	8b 00                	mov    (%eax),%eax
  800bfa:	8d 48 01             	lea    0x1(%eax),%ecx
  800bfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c00:	89 0a                	mov    %ecx,(%edx)
  800c02:	8b 55 08             	mov    0x8(%ebp),%edx
  800c05:	88 10                	mov    %dl,(%eax)
}
  800c07:	90                   	nop
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c19:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	01 d0                	add    %edx,%eax
  800c21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c2f:	74 06                	je     800c37 <vsnprintf+0x2d>
  800c31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c35:	7f 07                	jg     800c3e <vsnprintf+0x34>
		return -E_INVAL;
  800c37:	b8 03 00 00 00       	mov    $0x3,%eax
  800c3c:	eb 20                	jmp    800c5e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c3e:	ff 75 14             	pushl  0x14(%ebp)
  800c41:	ff 75 10             	pushl  0x10(%ebp)
  800c44:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c47:	50                   	push   %eax
  800c48:	68 d4 0b 80 00       	push   $0x800bd4
  800c4d:	e8 92 fb ff ff       	call   8007e4 <vprintfmt>
  800c52:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c58:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c66:	8d 45 10             	lea    0x10(%ebp),%eax
  800c69:	83 c0 04             	add    $0x4,%eax
  800c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c72:	ff 75 f4             	pushl  -0xc(%ebp)
  800c75:	50                   	push   %eax
  800c76:	ff 75 0c             	pushl  0xc(%ebp)
  800c79:	ff 75 08             	pushl  0x8(%ebp)
  800c7c:	e8 89 ff ff ff       	call   800c0a <vsnprintf>
  800c81:	83 c4 10             	add    $0x10,%esp
  800c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c99:	eb 06                	jmp    800ca1 <strlen+0x15>
		n++;
  800c9b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c9e:	ff 45 08             	incl   0x8(%ebp)
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	8a 00                	mov    (%eax),%al
  800ca6:	84 c0                	test   %al,%al
  800ca8:	75 f1                	jne    800c9b <strlen+0xf>
		n++;
	return n;
  800caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cad:	c9                   	leave  
  800cae:	c3                   	ret    

00800caf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cbc:	eb 09                	jmp    800cc7 <strnlen+0x18>
		n++;
  800cbe:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc1:	ff 45 08             	incl   0x8(%ebp)
  800cc4:	ff 4d 0c             	decl   0xc(%ebp)
  800cc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ccb:	74 09                	je     800cd6 <strnlen+0x27>
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 00                	mov    (%eax),%al
  800cd2:	84 c0                	test   %al,%al
  800cd4:	75 e8                	jne    800cbe <strnlen+0xf>
		n++;
	return n;
  800cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ce7:	90                   	nop
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8d 50 01             	lea    0x1(%eax),%edx
  800cee:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cf7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cfa:	8a 12                	mov    (%edx),%dl
  800cfc:	88 10                	mov    %dl,(%eax)
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	84 c0                	test   %al,%al
  800d02:	75 e4                	jne    800ce8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d04:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d1c:	eb 1f                	jmp    800d3d <strncpy+0x34>
		*dst++ = *src;
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8d 50 01             	lea    0x1(%eax),%edx
  800d24:	89 55 08             	mov    %edx,0x8(%ebp)
  800d27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2a:	8a 12                	mov    (%edx),%dl
  800d2c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	84 c0                	test   %al,%al
  800d35:	74 03                	je     800d3a <strncpy+0x31>
			src++;
  800d37:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d3a:	ff 45 fc             	incl   -0x4(%ebp)
  800d3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d40:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d43:	72 d9                	jb     800d1e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d45:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d48:	c9                   	leave  
  800d49:	c3                   	ret    

00800d4a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 30                	je     800d8c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d5c:	eb 16                	jmp    800d74 <strlcpy+0x2a>
			*dst++ = *src++;
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8d 50 01             	lea    0x1(%eax),%edx
  800d64:	89 55 08             	mov    %edx,0x8(%ebp)
  800d67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d6d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d70:	8a 12                	mov    (%edx),%dl
  800d72:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d74:	ff 4d 10             	decl   0x10(%ebp)
  800d77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7b:	74 09                	je     800d86 <strlcpy+0x3c>
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	84 c0                	test   %al,%al
  800d84:	75 d8                	jne    800d5e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d92:	29 c2                	sub    %eax,%edx
  800d94:	89 d0                	mov    %edx,%eax
}
  800d96:	c9                   	leave  
  800d97:	c3                   	ret    

00800d98 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d9b:	eb 06                	jmp    800da3 <strcmp+0xb>
		p++, q++;
  800d9d:	ff 45 08             	incl   0x8(%ebp)
  800da0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	74 0e                	je     800dba <strcmp+0x22>
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8a 10                	mov    (%eax),%dl
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	38 c2                	cmp    %al,%dl
  800db8:	74 e3                	je     800d9d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	0f b6 d0             	movzbl %al,%edx
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	0f b6 c0             	movzbl %al,%eax
  800dca:	29 c2                	sub    %eax,%edx
  800dcc:	89 d0                	mov    %edx,%eax
}
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dd3:	eb 09                	jmp    800dde <strncmp+0xe>
		n--, p++, q++;
  800dd5:	ff 4d 10             	decl   0x10(%ebp)
  800dd8:	ff 45 08             	incl   0x8(%ebp)
  800ddb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de2:	74 17                	je     800dfb <strncmp+0x2b>
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	74 0e                	je     800dfb <strncmp+0x2b>
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8a 10                	mov    (%eax),%dl
  800df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	38 c2                	cmp    %al,%dl
  800df9:	74 da                	je     800dd5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dff:	75 07                	jne    800e08 <strncmp+0x38>
		return 0;
  800e01:	b8 00 00 00 00       	mov    $0x0,%eax
  800e06:	eb 14                	jmp    800e1c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8a 00                	mov    (%eax),%al
  800e0d:	0f b6 d0             	movzbl %al,%edx
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	0f b6 c0             	movzbl %al,%eax
  800e18:	29 c2                	sub    %eax,%edx
  800e1a:	89 d0                	mov    %edx,%eax
}
  800e1c:	5d                   	pop    %ebp
  800e1d:	c3                   	ret    

00800e1e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 04             	sub    $0x4,%esp
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2a:	eb 12                	jmp    800e3e <strchr+0x20>
		if (*s == c)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e34:	75 05                	jne    800e3b <strchr+0x1d>
			return (char *) s;
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	eb 11                	jmp    800e4c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e3b:	ff 45 08             	incl   0x8(%ebp)
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	75 e5                	jne    800e2c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    

00800e4e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	83 ec 04             	sub    $0x4,%esp
  800e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e57:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e5a:	eb 0d                	jmp    800e69 <strfind+0x1b>
		if (*s == c)
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e64:	74 0e                	je     800e74 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e66:	ff 45 08             	incl   0x8(%ebp)
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 ea                	jne    800e5c <strfind+0xe>
  800e72:	eb 01                	jmp    800e75 <strfind+0x27>
		if (*s == c)
			break;
  800e74:	90                   	nop
	return (char *) s;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e86:	8b 45 10             	mov    0x10(%ebp),%eax
  800e89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e8c:	eb 0e                	jmp    800e9c <memset+0x22>
		*p++ = c;
  800e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e91:	8d 50 01             	lea    0x1(%eax),%edx
  800e94:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e9c:	ff 4d f8             	decl   -0x8(%ebp)
  800e9f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ea3:	79 e9                	jns    800e8e <memset+0x14>
		*p++ = c;

	return v;
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ebc:	eb 16                	jmp    800ed4 <memcpy+0x2a>
		*d++ = *s++;
  800ebe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec1:	8d 50 01             	lea    0x1(%eax),%edx
  800ec4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ecd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ed0:	8a 12                	mov    (%edx),%dl
  800ed2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eda:	89 55 10             	mov    %edx,0x10(%ebp)
  800edd:	85 c0                	test   %eax,%eax
  800edf:	75 dd                	jne    800ebe <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800efe:	73 50                	jae    800f50 <memmove+0x6a>
  800f00:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f03:	8b 45 10             	mov    0x10(%ebp),%eax
  800f06:	01 d0                	add    %edx,%eax
  800f08:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f0b:	76 43                	jbe    800f50 <memmove+0x6a>
		s += n;
  800f0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f10:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f13:	8b 45 10             	mov    0x10(%ebp),%eax
  800f16:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f19:	eb 10                	jmp    800f2b <memmove+0x45>
			*--d = *--s;
  800f1b:	ff 4d f8             	decl   -0x8(%ebp)
  800f1e:	ff 4d fc             	decl   -0x4(%ebp)
  800f21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f24:	8a 10                	mov    (%eax),%dl
  800f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f29:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f31:	89 55 10             	mov    %edx,0x10(%ebp)
  800f34:	85 c0                	test   %eax,%eax
  800f36:	75 e3                	jne    800f1b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f38:	eb 23                	jmp    800f5d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	8d 50 01             	lea    0x1(%eax),%edx
  800f40:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f43:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f46:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f49:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f4c:	8a 12                	mov    (%edx),%dl
  800f4e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f50:	8b 45 10             	mov    0x10(%ebp),%eax
  800f53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f56:	89 55 10             	mov    %edx,0x10(%ebp)
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	75 dd                	jne    800f3a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f74:	eb 2a                	jmp    800fa0 <memcmp+0x3e>
		if (*s1 != *s2)
  800f76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f79:	8a 10                	mov    (%eax),%dl
  800f7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	38 c2                	cmp    %al,%dl
  800f82:	74 16                	je     800f9a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	0f b6 d0             	movzbl %al,%edx
  800f8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	0f b6 c0             	movzbl %al,%eax
  800f94:	29 c2                	sub    %eax,%edx
  800f96:	89 d0                	mov    %edx,%eax
  800f98:	eb 18                	jmp    800fb2 <memcmp+0x50>
		s1++, s2++;
  800f9a:	ff 45 fc             	incl   -0x4(%ebp)
  800f9d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fa0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	75 c9                	jne    800f76 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb2:	c9                   	leave  
  800fb3:	c3                   	ret    

00800fb4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fba:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc0:	01 d0                	add    %edx,%eax
  800fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fc5:	eb 15                	jmp    800fdc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	0f b6 d0             	movzbl %al,%edx
  800fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd2:	0f b6 c0             	movzbl %al,%eax
  800fd5:	39 c2                	cmp    %eax,%edx
  800fd7:	74 0d                	je     800fe6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fd9:	ff 45 08             	incl   0x8(%ebp)
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fe2:	72 e3                	jb     800fc7 <memfind+0x13>
  800fe4:	eb 01                	jmp    800fe7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fe6:	90                   	nop
	return (void *) s;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fea:	c9                   	leave  
  800feb:	c3                   	ret    

00800fec <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ff2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ff9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801000:	eb 03                	jmp    801005 <strtol+0x19>
		s++;
  801002:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	3c 20                	cmp    $0x20,%al
  80100c:	74 f4                	je     801002 <strtol+0x16>
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	3c 09                	cmp    $0x9,%al
  801015:	74 eb                	je     801002 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	3c 2b                	cmp    $0x2b,%al
  80101e:	75 05                	jne    801025 <strtol+0x39>
		s++;
  801020:	ff 45 08             	incl   0x8(%ebp)
  801023:	eb 13                	jmp    801038 <strtol+0x4c>
	else if (*s == '-')
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	3c 2d                	cmp    $0x2d,%al
  80102c:	75 0a                	jne    801038 <strtol+0x4c>
		s++, neg = 1;
  80102e:	ff 45 08             	incl   0x8(%ebp)
  801031:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801038:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103c:	74 06                	je     801044 <strtol+0x58>
  80103e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801042:	75 20                	jne    801064 <strtol+0x78>
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	3c 30                	cmp    $0x30,%al
  80104b:	75 17                	jne    801064 <strtol+0x78>
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	40                   	inc    %eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	3c 78                	cmp    $0x78,%al
  801055:	75 0d                	jne    801064 <strtol+0x78>
		s += 2, base = 16;
  801057:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80105b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801062:	eb 28                	jmp    80108c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801064:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801068:	75 15                	jne    80107f <strtol+0x93>
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	3c 30                	cmp    $0x30,%al
  801071:	75 0c                	jne    80107f <strtol+0x93>
		s++, base = 8;
  801073:	ff 45 08             	incl   0x8(%ebp)
  801076:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80107d:	eb 0d                	jmp    80108c <strtol+0xa0>
	else if (base == 0)
  80107f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801083:	75 07                	jne    80108c <strtol+0xa0>
		base = 10;
  801085:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	3c 2f                	cmp    $0x2f,%al
  801093:	7e 19                	jle    8010ae <strtol+0xc2>
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	3c 39                	cmp    $0x39,%al
  80109c:	7f 10                	jg     8010ae <strtol+0xc2>
			dig = *s - '0';
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	0f be c0             	movsbl %al,%eax
  8010a6:	83 e8 30             	sub    $0x30,%eax
  8010a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ac:	eb 42                	jmp    8010f0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	3c 60                	cmp    $0x60,%al
  8010b5:	7e 19                	jle    8010d0 <strtol+0xe4>
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	3c 7a                	cmp    $0x7a,%al
  8010be:	7f 10                	jg     8010d0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	0f be c0             	movsbl %al,%eax
  8010c8:	83 e8 57             	sub    $0x57,%eax
  8010cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ce:	eb 20                	jmp    8010f0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	3c 40                	cmp    $0x40,%al
  8010d7:	7e 39                	jle    801112 <strtol+0x126>
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	3c 5a                	cmp    $0x5a,%al
  8010e0:	7f 30                	jg     801112 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	0f be c0             	movsbl %al,%eax
  8010ea:	83 e8 37             	sub    $0x37,%eax
  8010ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010f6:	7d 19                	jge    801111 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010f8:	ff 45 08             	incl   0x8(%ebp)
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	0f af 45 10          	imul   0x10(%ebp),%eax
  801102:	89 c2                	mov    %eax,%edx
  801104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801107:	01 d0                	add    %edx,%eax
  801109:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80110c:	e9 7b ff ff ff       	jmp    80108c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801111:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801112:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801116:	74 08                	je     801120 <strtol+0x134>
		*endptr = (char *) s;
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	8b 55 08             	mov    0x8(%ebp),%edx
  80111e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801120:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801124:	74 07                	je     80112d <strtol+0x141>
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	f7 d8                	neg    %eax
  80112b:	eb 03                	jmp    801130 <strtol+0x144>
  80112d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <ltostr>:

void
ltostr(long value, char *str)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801138:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80113f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801146:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80114a:	79 13                	jns    80115f <ltostr+0x2d>
	{
		neg = 1;
  80114c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801153:	8b 45 0c             	mov    0xc(%ebp),%eax
  801156:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801159:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80115c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801167:	99                   	cltd   
  801168:	f7 f9                	idiv   %ecx
  80116a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80116d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801170:	8d 50 01             	lea    0x1(%eax),%edx
  801173:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801176:	89 c2                	mov    %eax,%edx
  801178:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117b:	01 d0                	add    %edx,%eax
  80117d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801180:	83 c2 30             	add    $0x30,%edx
  801183:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801185:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801188:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80118d:	f7 e9                	imul   %ecx
  80118f:	c1 fa 02             	sar    $0x2,%edx
  801192:	89 c8                	mov    %ecx,%eax
  801194:	c1 f8 1f             	sar    $0x1f,%eax
  801197:	29 c2                	sub    %eax,%edx
  801199:	89 d0                	mov    %edx,%eax
  80119b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80119e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a6:	f7 e9                	imul   %ecx
  8011a8:	c1 fa 02             	sar    $0x2,%edx
  8011ab:	89 c8                	mov    %ecx,%eax
  8011ad:	c1 f8 1f             	sar    $0x1f,%eax
  8011b0:	29 c2                	sub    %eax,%edx
  8011b2:	89 d0                	mov    %edx,%eax
  8011b4:	c1 e0 02             	shl    $0x2,%eax
  8011b7:	01 d0                	add    %edx,%eax
  8011b9:	01 c0                	add    %eax,%eax
  8011bb:	29 c1                	sub    %eax,%ecx
  8011bd:	89 ca                	mov    %ecx,%edx
  8011bf:	85 d2                	test   %edx,%edx
  8011c1:	75 9c                	jne    80115f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cd:	48                   	dec    %eax
  8011ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d5:	74 3d                	je     801214 <ltostr+0xe2>
		start = 1 ;
  8011d7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011de:	eb 34                	jmp    801214 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	01 d0                	add    %edx,%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	01 c2                	add    %eax,%edx
  8011f5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fb:	01 c8                	add    %ecx,%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801201:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 c2                	add    %eax,%edx
  801209:	8a 45 eb             	mov    -0x15(%ebp),%al
  80120c:	88 02                	mov    %al,(%edx)
		start++ ;
  80120e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801211:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801217:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80121a:	7c c4                	jl     8011e0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80121c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80121f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801222:	01 d0                	add    %edx,%eax
  801224:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801227:	90                   	nop
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 54 fa ff ff       	call   800c8c <strlen>
  801238:	83 c4 04             	add    $0x4,%esp
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80123e:	ff 75 0c             	pushl  0xc(%ebp)
  801241:	e8 46 fa ff ff       	call   800c8c <strlen>
  801246:	83 c4 04             	add    $0x4,%esp
  801249:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80124c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801253:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80125a:	eb 17                	jmp    801273 <strcconcat+0x49>
		final[s] = str1[s] ;
  80125c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	01 c2                	add    %eax,%edx
  801264:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	01 c8                	add    %ecx,%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801270:	ff 45 fc             	incl   -0x4(%ebp)
  801273:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801276:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801279:	7c e1                	jl     80125c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80127b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801282:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801289:	eb 1f                	jmp    8012aa <strcconcat+0x80>
		final[s++] = str2[i] ;
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	8d 50 01             	lea    0x1(%eax),%edx
  801291:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801294:	89 c2                	mov    %eax,%edx
  801296:	8b 45 10             	mov    0x10(%ebp),%eax
  801299:	01 c2                	add    %eax,%edx
  80129b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 c8                	add    %ecx,%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012a7:	ff 45 f8             	incl   -0x8(%ebp)
  8012aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b0:	7c d9                	jl     80128b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b8:	01 d0                	add    %edx,%eax
  8012ba:	c6 00 00             	movb   $0x0,(%eax)
}
  8012bd:	90                   	nop
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012cf:	8b 00                	mov    (%eax),%eax
  8012d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 d0                	add    %edx,%eax
  8012dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012e3:	eb 0c                	jmp    8012f1 <strsplit+0x31>
			*string++ = 0;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8d 50 01             	lea    0x1(%eax),%edx
  8012eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ee:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	74 18                	je     801312 <strsplit+0x52>
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8a 00                	mov    (%eax),%al
  8012ff:	0f be c0             	movsbl %al,%eax
  801302:	50                   	push   %eax
  801303:	ff 75 0c             	pushl  0xc(%ebp)
  801306:	e8 13 fb ff ff       	call   800e1e <strchr>
  80130b:	83 c4 08             	add    $0x8,%esp
  80130e:	85 c0                	test   %eax,%eax
  801310:	75 d3                	jne    8012e5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	84 c0                	test   %al,%al
  801319:	74 5a                	je     801375 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80131b:	8b 45 14             	mov    0x14(%ebp),%eax
  80131e:	8b 00                	mov    (%eax),%eax
  801320:	83 f8 0f             	cmp    $0xf,%eax
  801323:	75 07                	jne    80132c <strsplit+0x6c>
		{
			return 0;
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
  80132a:	eb 66                	jmp    801392 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80132c:	8b 45 14             	mov    0x14(%ebp),%eax
  80132f:	8b 00                	mov    (%eax),%eax
  801331:	8d 48 01             	lea    0x1(%eax),%ecx
  801334:	8b 55 14             	mov    0x14(%ebp),%edx
  801337:	89 0a                	mov    %ecx,(%edx)
  801339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	01 c2                	add    %eax,%edx
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80134a:	eb 03                	jmp    80134f <strsplit+0x8f>
			string++;
  80134c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	8a 00                	mov    (%eax),%al
  801354:	84 c0                	test   %al,%al
  801356:	74 8b                	je     8012e3 <strsplit+0x23>
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	8a 00                	mov    (%eax),%al
  80135d:	0f be c0             	movsbl %al,%eax
  801360:	50                   	push   %eax
  801361:	ff 75 0c             	pushl  0xc(%ebp)
  801364:	e8 b5 fa ff ff       	call   800e1e <strchr>
  801369:	83 c4 08             	add    $0x8,%esp
  80136c:	85 c0                	test   %eax,%eax
  80136e:	74 dc                	je     80134c <strsplit+0x8c>
			string++;
	}
  801370:	e9 6e ff ff ff       	jmp    8012e3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801375:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801376:	8b 45 14             	mov    0x14(%ebp),%eax
  801379:	8b 00                	mov    (%eax),%eax
  80137b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801382:	8b 45 10             	mov    0x10(%ebp),%eax
  801385:	01 d0                	add    %edx,%eax
  801387:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80138d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  80139a:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  8013a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8013a7:	01 d0                	add    %edx,%eax
  8013a9:	48                   	dec    %eax
  8013aa:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8013ad:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8013b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b5:	f7 75 ac             	divl   -0x54(%ebp)
  8013b8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8013bb:	29 d0                	sub    %edx,%eax
  8013bd:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  8013c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  8013c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  8013ce:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8013d5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8013dc:	eb 3f                	jmp    80141d <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8013de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013e1:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8013e8:	83 ec 04             	sub    $0x4,%esp
  8013eb:	50                   	push   %eax
  8013ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8013ef:	68 10 29 80 00       	push   $0x802910
  8013f4:	e8 11 f2 ff ff       	call   80060a <cprintf>
  8013f9:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  8013fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ff:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801406:	83 ec 04             	sub    $0x4,%esp
  801409:	50                   	push   %eax
  80140a:	ff 75 e8             	pushl  -0x18(%ebp)
  80140d:	68 25 29 80 00       	push   $0x802925
  801412:	e8 f3 f1 ff ff       	call   80060a <cprintf>
  801417:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  80141a:	ff 45 e8             	incl   -0x18(%ebp)
  80141d:	a1 28 30 80 00       	mov    0x803028,%eax
  801422:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801425:	7c b7                	jl     8013de <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801427:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  80142e:	e9 42 01 00 00       	jmp    801575 <malloc+0x1e1>
		int flag0=1;
  801433:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  80143a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80143d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801440:	eb 6b                	jmp    8014ad <malloc+0x119>
			for(int k=0;k<count;k++){
  801442:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801449:	eb 42                	jmp    80148d <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  80144b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80144e:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801455:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801458:	39 c2                	cmp    %eax,%edx
  80145a:	77 2e                	ja     80148a <malloc+0xf6>
  80145c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80145f:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801466:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801469:	39 c2                	cmp    %eax,%edx
  80146b:	76 1d                	jbe    80148a <malloc+0xf6>
					ni=arr_add[k].end-i;
  80146d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801470:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801477:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147a:	29 c2                	sub    %eax,%edx
  80147c:	89 d0                	mov    %edx,%eax
  80147e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801481:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801488:	eb 0d                	jmp    801497 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  80148a:	ff 45 d8             	incl   -0x28(%ebp)
  80148d:	a1 28 30 80 00       	mov    0x803028,%eax
  801492:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801495:	7c b4                	jl     80144b <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801497:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80149b:	74 09                	je     8014a6 <malloc+0x112>
				flag0=0;
  80149d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  8014a4:	eb 16                	jmp    8014bc <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  8014a6:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8014ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	01 c2                	add    %eax,%edx
  8014b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014b8:	39 c2                	cmp    %eax,%edx
  8014ba:	77 86                	ja     801442 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  8014bc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014c0:	0f 84 a2 00 00 00    	je     801568 <malloc+0x1d4>

			int f=1;
  8014c6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  8014cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014d0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8014d3:	89 c8                	mov    %ecx,%eax
  8014d5:	01 c0                	add    %eax,%eax
  8014d7:	01 c8                	add    %ecx,%eax
  8014d9:	c1 e0 02             	shl    $0x2,%eax
  8014dc:	05 20 31 80 00       	add    $0x803120,%eax
  8014e1:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  8014e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8014ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ef:	89 d0                	mov    %edx,%eax
  8014f1:	01 c0                	add    %eax,%eax
  8014f3:	01 d0                	add    %edx,%eax
  8014f5:	c1 e0 02             	shl    $0x2,%eax
  8014f8:	05 24 31 80 00       	add    $0x803124,%eax
  8014fd:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  8014ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801502:	89 d0                	mov    %edx,%eax
  801504:	01 c0                	add    %eax,%eax
  801506:	01 d0                	add    %edx,%eax
  801508:	c1 e0 02             	shl    $0x2,%eax
  80150b:	05 28 31 80 00       	add    $0x803128,%eax
  801510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801516:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801519:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801520:	eb 36                	jmp    801558 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801522:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	01 c2                	add    %eax,%edx
  80152a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80152d:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801534:	39 c2                	cmp    %eax,%edx
  801536:	73 1d                	jae    801555 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801538:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80153b:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801545:	29 c2                	sub    %eax,%edx
  801547:	89 d0                	mov    %edx,%eax
  801549:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  80154c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801553:	eb 0d                	jmp    801562 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801555:	ff 45 d0             	incl   -0x30(%ebp)
  801558:	a1 28 30 80 00       	mov    0x803028,%eax
  80155d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801560:	7c c0                	jl     801522 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801562:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801566:	75 1d                	jne    801585 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801568:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  80156f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801572:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801575:	a1 04 30 80 00       	mov    0x803004,%eax
  80157a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80157d:	0f 8c b0 fe ff ff    	jl     801433 <malloc+0x9f>
  801583:	eb 01                	jmp    801586 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801585:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801586:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80158a:	75 7a                	jne    801606 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  80158c:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	01 d0                	add    %edx,%eax
  801597:	48                   	dec    %eax
  801598:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80159d:	7c 0a                	jl     8015a9 <malloc+0x215>
			return NULL;
  80159f:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a4:	e9 a4 02 00 00       	jmp    80184d <malloc+0x4b9>
		else{
			uint32 s=base_add;
  8015a9:	a1 04 30 80 00       	mov    0x803004,%eax
  8015ae:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  8015b1:	a1 28 30 80 00       	mov    0x803028,%eax
  8015b6:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8015b9:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  8015c0:	83 ec 08             	sub    $0x8,%esp
  8015c3:	ff 75 08             	pushl  0x8(%ebp)
  8015c6:	ff 75 a4             	pushl  -0x5c(%ebp)
  8015c9:	e8 04 06 00 00       	call   801bd2 <sys_allocateMem>
  8015ce:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  8015d1:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	01 d0                	add    %edx,%eax
  8015dc:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  8015e1:	a1 28 30 80 00       	mov    0x803028,%eax
  8015e6:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015ec:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  8015f3:	a1 28 30 80 00       	mov    0x803028,%eax
  8015f8:	40                   	inc    %eax
  8015f9:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  8015fe:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801601:	e9 47 02 00 00       	jmp    80184d <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801606:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80160d:	e9 ac 00 00 00       	jmp    8016be <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801612:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801615:	89 d0                	mov    %edx,%eax
  801617:	01 c0                	add    %eax,%eax
  801619:	01 d0                	add    %edx,%eax
  80161b:	c1 e0 02             	shl    $0x2,%eax
  80161e:	05 24 31 80 00       	add    $0x803124,%eax
  801623:	8b 00                	mov    (%eax),%eax
  801625:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801628:	eb 7e                	jmp    8016a8 <malloc+0x314>
			int flag=0;
  80162a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801631:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801638:	eb 57                	jmp    801691 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  80163a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80163d:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801644:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801647:	39 c2                	cmp    %eax,%edx
  801649:	77 1a                	ja     801665 <malloc+0x2d1>
  80164b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80164e:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801655:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801658:	39 c2                	cmp    %eax,%edx
  80165a:	76 09                	jbe    801665 <malloc+0x2d1>
								flag=1;
  80165c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801663:	eb 36                	jmp    80169b <malloc+0x307>
			arr[i].space++;
  801665:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801668:	89 d0                	mov    %edx,%eax
  80166a:	01 c0                	add    %eax,%eax
  80166c:	01 d0                	add    %edx,%eax
  80166e:	c1 e0 02             	shl    $0x2,%eax
  801671:	05 28 31 80 00       	add    $0x803128,%eax
  801676:	8b 00                	mov    (%eax),%eax
  801678:	8d 48 01             	lea    0x1(%eax),%ecx
  80167b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80167e:	89 d0                	mov    %edx,%eax
  801680:	01 c0                	add    %eax,%eax
  801682:	01 d0                	add    %edx,%eax
  801684:	c1 e0 02             	shl    $0x2,%eax
  801687:	05 28 31 80 00       	add    $0x803128,%eax
  80168c:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  80168e:	ff 45 c0             	incl   -0x40(%ebp)
  801691:	a1 28 30 80 00       	mov    0x803028,%eax
  801696:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801699:	7c 9f                	jl     80163a <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  80169b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80169f:	75 19                	jne    8016ba <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  8016a1:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8016a8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8016ab:	a1 04 30 80 00       	mov    0x803004,%eax
  8016b0:	39 c2                	cmp    %eax,%edx
  8016b2:	0f 82 72 ff ff ff    	jb     80162a <malloc+0x296>
  8016b8:	eb 01                	jmp    8016bb <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  8016ba:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  8016bb:	ff 45 cc             	incl   -0x34(%ebp)
  8016be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8016c1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016c4:	0f 8c 48 ff ff ff    	jl     801612 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  8016ca:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  8016d1:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  8016d8:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  8016df:	eb 37                	jmp    801718 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  8016e1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8016e4:	89 d0                	mov    %edx,%eax
  8016e6:	01 c0                	add    %eax,%eax
  8016e8:	01 d0                	add    %edx,%eax
  8016ea:	c1 e0 02             	shl    $0x2,%eax
  8016ed:	05 28 31 80 00       	add    $0x803128,%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8016f7:	7d 1c                	jge    801715 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  8016f9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8016fc:	89 d0                	mov    %edx,%eax
  8016fe:	01 c0                	add    %eax,%eax
  801700:	01 d0                	add    %edx,%eax
  801702:	c1 e0 02             	shl    $0x2,%eax
  801705:	05 28 31 80 00       	add    $0x803128,%eax
  80170a:	8b 00                	mov    (%eax),%eax
  80170c:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  80170f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801712:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801715:	ff 45 b4             	incl   -0x4c(%ebp)
  801718:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80171b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80171e:	7c c1                	jl     8016e1 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801720:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801726:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801729:	89 c8                	mov    %ecx,%eax
  80172b:	01 c0                	add    %eax,%eax
  80172d:	01 c8                	add    %ecx,%eax
  80172f:	c1 e0 02             	shl    $0x2,%eax
  801732:	05 20 31 80 00       	add    $0x803120,%eax
  801737:	8b 00                	mov    (%eax),%eax
  801739:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801740:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801746:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801749:	89 c8                	mov    %ecx,%eax
  80174b:	01 c0                	add    %eax,%eax
  80174d:	01 c8                	add    %ecx,%eax
  80174f:	c1 e0 02             	shl    $0x2,%eax
  801752:	05 24 31 80 00       	add    $0x803124,%eax
  801757:	8b 00                	mov    (%eax),%eax
  801759:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  801760:	a1 28 30 80 00       	mov    0x803028,%eax
  801765:	40                   	inc    %eax
  801766:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  80176b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80176e:	89 d0                	mov    %edx,%eax
  801770:	01 c0                	add    %eax,%eax
  801772:	01 d0                	add    %edx,%eax
  801774:	c1 e0 02             	shl    $0x2,%eax
  801777:	05 20 31 80 00       	add    $0x803120,%eax
  80177c:	8b 00                	mov    (%eax),%eax
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	ff 75 08             	pushl  0x8(%ebp)
  801784:	50                   	push   %eax
  801785:	e8 48 04 00 00       	call   801bd2 <sys_allocateMem>
  80178a:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  80178d:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801794:	eb 78                	jmp    80180e <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801796:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801799:	89 d0                	mov    %edx,%eax
  80179b:	01 c0                	add    %eax,%eax
  80179d:	01 d0                	add    %edx,%eax
  80179f:	c1 e0 02             	shl    $0x2,%eax
  8017a2:	05 20 31 80 00       	add    $0x803120,%eax
  8017a7:	8b 00                	mov    (%eax),%eax
  8017a9:	83 ec 04             	sub    $0x4,%esp
  8017ac:	50                   	push   %eax
  8017ad:	ff 75 b0             	pushl  -0x50(%ebp)
  8017b0:	68 10 29 80 00       	push   $0x802910
  8017b5:	e8 50 ee ff ff       	call   80060a <cprintf>
  8017ba:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  8017bd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8017c0:	89 d0                	mov    %edx,%eax
  8017c2:	01 c0                	add    %eax,%eax
  8017c4:	01 d0                	add    %edx,%eax
  8017c6:	c1 e0 02             	shl    $0x2,%eax
  8017c9:	05 24 31 80 00       	add    $0x803124,%eax
  8017ce:	8b 00                	mov    (%eax),%eax
  8017d0:	83 ec 04             	sub    $0x4,%esp
  8017d3:	50                   	push   %eax
  8017d4:	ff 75 b0             	pushl  -0x50(%ebp)
  8017d7:	68 25 29 80 00       	push   $0x802925
  8017dc:	e8 29 ee ff ff       	call   80060a <cprintf>
  8017e1:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  8017e4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8017e7:	89 d0                	mov    %edx,%eax
  8017e9:	01 c0                	add    %eax,%eax
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	c1 e0 02             	shl    $0x2,%eax
  8017f0:	05 28 31 80 00       	add    $0x803128,%eax
  8017f5:	8b 00                	mov    (%eax),%eax
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	50                   	push   %eax
  8017fb:	ff 75 b0             	pushl  -0x50(%ebp)
  8017fe:	68 38 29 80 00       	push   $0x802938
  801803:	e8 02 ee ff ff       	call   80060a <cprintf>
  801808:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  80180b:	ff 45 b0             	incl   -0x50(%ebp)
  80180e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801811:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801814:	7c 80                	jl     801796 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801816:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801819:	89 d0                	mov    %edx,%eax
  80181b:	01 c0                	add    %eax,%eax
  80181d:	01 d0                	add    %edx,%eax
  80181f:	c1 e0 02             	shl    $0x2,%eax
  801822:	05 20 31 80 00       	add    $0x803120,%eax
  801827:	8b 00                	mov    (%eax),%eax
  801829:	83 ec 08             	sub    $0x8,%esp
  80182c:	50                   	push   %eax
  80182d:	68 4c 29 80 00       	push   $0x80294c
  801832:	e8 d3 ed ff ff       	call   80060a <cprintf>
  801837:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  80183a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80183d:	89 d0                	mov    %edx,%eax
  80183f:	01 c0                	add    %eax,%eax
  801841:	01 d0                	add    %edx,%eax
  801843:	c1 e0 02             	shl    $0x2,%eax
  801846:	05 20 31 80 00       	add    $0x803120,%eax
  80184b:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  80185b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801862:	eb 4b                	jmp    8018af <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801864:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801867:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  80186e:	89 c2                	mov    %eax,%edx
  801870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801873:	39 c2                	cmp    %eax,%edx
  801875:	7f 35                	jg     8018ac <free+0x5d>
  801877:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80187a:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801881:	89 c2                	mov    %eax,%edx
  801883:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801886:	39 c2                	cmp    %eax,%edx
  801888:	7e 22                	jle    8018ac <free+0x5d>
				start=arr_add[i].start;
  80188a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80188d:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801894:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801897:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80189a:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8018a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  8018a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  8018aa:	eb 0d                	jmp    8018b9 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  8018ac:	ff 45 ec             	incl   -0x14(%ebp)
  8018af:	a1 28 30 80 00       	mov    0x803028,%eax
  8018b4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8018b7:	7c ab                	jl     801864 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  8018b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018bc:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  8018c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c6:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8018cd:	29 c2                	sub    %eax,%edx
  8018cf:	89 d0                	mov    %edx,%eax
  8018d1:	83 ec 08             	sub    $0x8,%esp
  8018d4:	50                   	push   %eax
  8018d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d8:	e8 d9 02 00 00       	call   801bb6 <sys_freeMem>
  8018dd:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  8018e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018e6:	eb 2d                	jmp    801915 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  8018e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018eb:	40                   	inc    %eax
  8018ec:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  8018f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f6:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  8018fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801900:	40                   	inc    %eax
  801901:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80190b:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801912:	ff 45 e8             	incl   -0x18(%ebp)
  801915:	a1 28 30 80 00       	mov    0x803028,%eax
  80191a:	48                   	dec    %eax
  80191b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80191e:	7f c8                	jg     8018e8 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801920:	a1 28 30 80 00       	mov    0x803028,%eax
  801925:	48                   	dec    %eax
  801926:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  80192b:	90                   	nop
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 18             	sub    $0x18,%esp
  801934:	8b 45 10             	mov    0x10(%ebp),%eax
  801937:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  80193a:	83 ec 04             	sub    $0x4,%esp
  80193d:	68 68 29 80 00       	push   $0x802968
  801942:	68 18 01 00 00       	push   $0x118
  801947:	68 8b 29 80 00       	push   $0x80298b
  80194c:	e8 17 ea ff ff       	call   800368 <_panic>

00801951 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801957:	83 ec 04             	sub    $0x4,%esp
  80195a:	68 68 29 80 00       	push   $0x802968
  80195f:	68 1e 01 00 00       	push   $0x11e
  801964:	68 8b 29 80 00       	push   $0x80298b
  801969:	e8 fa e9 ff ff       	call   800368 <_panic>

0080196e <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	68 68 29 80 00       	push   $0x802968
  80197c:	68 24 01 00 00       	push   $0x124
  801981:	68 8b 29 80 00       	push   $0x80298b
  801986:	e8 dd e9 ff ff       	call   800368 <_panic>

0080198b <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	68 68 29 80 00       	push   $0x802968
  801999:	68 29 01 00 00       	push   $0x129
  80199e:	68 8b 29 80 00       	push   $0x80298b
  8019a3:	e8 c0 e9 ff ff       	call   800368 <_panic>

008019a8 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019ae:	83 ec 04             	sub    $0x4,%esp
  8019b1:	68 68 29 80 00       	push   $0x802968
  8019b6:	68 2f 01 00 00       	push   $0x12f
  8019bb:	68 8b 29 80 00       	push   $0x80298b
  8019c0:	e8 a3 e9 ff ff       	call   800368 <_panic>

008019c5 <shrink>:
}
void shrink(uint32 newSize)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
  8019c8:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	68 68 29 80 00       	push   $0x802968
  8019d3:	68 33 01 00 00       	push   $0x133
  8019d8:	68 8b 29 80 00       	push   $0x80298b
  8019dd:	e8 86 e9 ff ff       	call   800368 <_panic>

008019e2 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019e8:	83 ec 04             	sub    $0x4,%esp
  8019eb:	68 68 29 80 00       	push   $0x802968
  8019f0:	68 38 01 00 00       	push   $0x138
  8019f5:	68 8b 29 80 00       	push   $0x80298b
  8019fa:	e8 69 e9 ff ff       	call   800368 <_panic>

008019ff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	57                   	push   %edi
  801a03:	56                   	push   %esi
  801a04:	53                   	push   %ebx
  801a05:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a11:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a14:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a17:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a1a:	cd 30                	int    $0x30
  801a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a22:	83 c4 10             	add    $0x10,%esp
  801a25:	5b                   	pop    %ebx
  801a26:	5e                   	pop    %esi
  801a27:	5f                   	pop    %edi
  801a28:	5d                   	pop    %ebp
  801a29:	c3                   	ret    

00801a2a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 04             	sub    $0x4,%esp
  801a30:	8b 45 10             	mov    0x10(%ebp),%eax
  801a33:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a36:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	52                   	push   %edx
  801a42:	ff 75 0c             	pushl  0xc(%ebp)
  801a45:	50                   	push   %eax
  801a46:	6a 00                	push   $0x0
  801a48:	e8 b2 ff ff ff       	call   8019ff <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
}
  801a50:	90                   	nop
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 01                	push   $0x1
  801a62:	e8 98 ff ff ff       	call   8019ff <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	50                   	push   %eax
  801a7b:	6a 05                	push   $0x5
  801a7d:	e8 7d ff ff ff       	call   8019ff <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 02                	push   $0x2
  801a96:	e8 64 ff ff ff       	call   8019ff <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 03                	push   $0x3
  801aaf:	e8 4b ff ff ff       	call   8019ff <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 04                	push   $0x4
  801ac8:	e8 32 ff ff ff       	call   8019ff <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_env_exit>:


void sys_env_exit(void)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 06                	push   $0x6
  801ae1:	e8 19 ff ff ff       	call   8019ff <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	90                   	nop
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	52                   	push   %edx
  801afc:	50                   	push   %eax
  801afd:	6a 07                	push   $0x7
  801aff:	e8 fb fe ff ff       	call   8019ff <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	56                   	push   %esi
  801b0d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b0e:	8b 75 18             	mov    0x18(%ebp),%esi
  801b11:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b14:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	56                   	push   %esi
  801b1e:	53                   	push   %ebx
  801b1f:	51                   	push   %ecx
  801b20:	52                   	push   %edx
  801b21:	50                   	push   %eax
  801b22:	6a 08                	push   $0x8
  801b24:	e8 d6 fe ff ff       	call   8019ff <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5e                   	pop    %esi
  801b31:	5d                   	pop    %ebp
  801b32:	c3                   	ret    

00801b33 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	52                   	push   %edx
  801b43:	50                   	push   %eax
  801b44:	6a 09                	push   $0x9
  801b46:	e8 b4 fe ff ff       	call   8019ff <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	ff 75 0c             	pushl  0xc(%ebp)
  801b5c:	ff 75 08             	pushl  0x8(%ebp)
  801b5f:	6a 0a                	push   $0xa
  801b61:	e8 99 fe ff ff       	call   8019ff <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 0b                	push   $0xb
  801b7a:	e8 80 fe ff ff       	call   8019ff <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 0c                	push   $0xc
  801b93:	e8 67 fe ff ff       	call   8019ff <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 0d                	push   $0xd
  801bac:	e8 4e fe ff ff       	call   8019ff <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	ff 75 0c             	pushl  0xc(%ebp)
  801bc2:	ff 75 08             	pushl  0x8(%ebp)
  801bc5:	6a 11                	push   $0x11
  801bc7:	e8 33 fe ff ff       	call   8019ff <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
	return;
  801bcf:	90                   	nop
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	ff 75 0c             	pushl  0xc(%ebp)
  801bde:	ff 75 08             	pushl  0x8(%ebp)
  801be1:	6a 12                	push   $0x12
  801be3:	e8 17 fe ff ff       	call   8019ff <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
	return ;
  801beb:	90                   	nop
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 0e                	push   $0xe
  801bfd:	e8 fd fd ff ff       	call   8019ff <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	ff 75 08             	pushl  0x8(%ebp)
  801c15:	6a 0f                	push   $0xf
  801c17:	e8 e3 fd ff ff       	call   8019ff <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 10                	push   $0x10
  801c30:	e8 ca fd ff ff       	call   8019ff <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
}
  801c38:	90                   	nop
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 14                	push   $0x14
  801c4a:	e8 b0 fd ff ff       	call   8019ff <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
}
  801c52:	90                   	nop
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 15                	push   $0x15
  801c64:	e8 96 fd ff ff       	call   8019ff <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	90                   	nop
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_cputc>:


void
sys_cputc(const char c)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 04             	sub    $0x4,%esp
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c7b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	50                   	push   %eax
  801c88:	6a 16                	push   $0x16
  801c8a:	e8 70 fd ff ff       	call   8019ff <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
}
  801c92:	90                   	nop
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 17                	push   $0x17
  801ca4:	e8 56 fd ff ff       	call   8019ff <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
}
  801cac:	90                   	nop
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	ff 75 0c             	pushl  0xc(%ebp)
  801cbe:	50                   	push   %eax
  801cbf:	6a 18                	push   $0x18
  801cc1:	e8 39 fd ff ff       	call   8019ff <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	52                   	push   %edx
  801cdb:	50                   	push   %eax
  801cdc:	6a 1b                	push   $0x1b
  801cde:	e8 1c fd ff ff       	call   8019ff <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	52                   	push   %edx
  801cf8:	50                   	push   %eax
  801cf9:	6a 19                	push   $0x19
  801cfb:	e8 ff fc ff ff       	call   8019ff <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	90                   	nop
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	52                   	push   %edx
  801d16:	50                   	push   %eax
  801d17:	6a 1a                	push   $0x1a
  801d19:	e8 e1 fc ff ff       	call   8019ff <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
}
  801d21:	90                   	nop
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	83 ec 04             	sub    $0x4,%esp
  801d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d30:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d33:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	6a 00                	push   $0x0
  801d3c:	51                   	push   %ecx
  801d3d:	52                   	push   %edx
  801d3e:	ff 75 0c             	pushl  0xc(%ebp)
  801d41:	50                   	push   %eax
  801d42:	6a 1c                	push   $0x1c
  801d44:	e8 b6 fc ff ff       	call   8019ff <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	52                   	push   %edx
  801d5e:	50                   	push   %eax
  801d5f:	6a 1d                	push   $0x1d
  801d61:	e8 99 fc ff ff       	call   8019ff <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	51                   	push   %ecx
  801d7c:	52                   	push   %edx
  801d7d:	50                   	push   %eax
  801d7e:	6a 1e                	push   $0x1e
  801d80:	e8 7a fc ff ff       	call   8019ff <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	52                   	push   %edx
  801d9a:	50                   	push   %eax
  801d9b:	6a 1f                	push   $0x1f
  801d9d:	e8 5d fc ff ff       	call   8019ff <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 20                	push   $0x20
  801db6:	e8 44 fc ff ff       	call   8019ff <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	6a 00                	push   $0x0
  801dc8:	ff 75 14             	pushl  0x14(%ebp)
  801dcb:	ff 75 10             	pushl  0x10(%ebp)
  801dce:	ff 75 0c             	pushl  0xc(%ebp)
  801dd1:	50                   	push   %eax
  801dd2:	6a 21                	push   $0x21
  801dd4:	e8 26 fc ff ff       	call   8019ff <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801de1:	8b 45 08             	mov    0x8(%ebp),%eax
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	50                   	push   %eax
  801ded:	6a 22                	push   $0x22
  801def:	e8 0b fc ff ff       	call   8019ff <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
}
  801df7:	90                   	nop
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	50                   	push   %eax
  801e09:	6a 23                	push   $0x23
  801e0b:	e8 ef fb ff ff       	call   8019ff <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
}
  801e13:	90                   	nop
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e1c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e1f:	8d 50 04             	lea    0x4(%eax),%edx
  801e22:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	52                   	push   %edx
  801e2c:	50                   	push   %eax
  801e2d:	6a 24                	push   $0x24
  801e2f:	e8 cb fb ff ff       	call   8019ff <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
	return result;
  801e37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e40:	89 01                	mov    %eax,(%ecx)
  801e42:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	c9                   	leave  
  801e49:	c2 04 00             	ret    $0x4

00801e4c <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	ff 75 10             	pushl  0x10(%ebp)
  801e56:	ff 75 0c             	pushl  0xc(%ebp)
  801e59:	ff 75 08             	pushl  0x8(%ebp)
  801e5c:	6a 13                	push   $0x13
  801e5e:	e8 9c fb ff ff       	call   8019ff <syscall>
  801e63:	83 c4 18             	add    $0x18,%esp
	return ;
  801e66:	90                   	nop
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 25                	push   $0x25
  801e78:	e8 82 fb ff ff       	call   8019ff <syscall>
  801e7d:	83 c4 18             	add    $0x18,%esp
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	83 ec 04             	sub    $0x4,%esp
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e8e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	50                   	push   %eax
  801e9b:	6a 26                	push   $0x26
  801e9d:	e8 5d fb ff ff       	call   8019ff <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea5:	90                   	nop
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <rsttst>:
void rsttst()
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 28                	push   $0x28
  801eb7:	e8 43 fb ff ff       	call   8019ff <syscall>
  801ebc:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebf:	90                   	nop
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	83 ec 04             	sub    $0x4,%esp
  801ec8:	8b 45 14             	mov    0x14(%ebp),%eax
  801ecb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ece:	8b 55 18             	mov    0x18(%ebp),%edx
  801ed1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ed5:	52                   	push   %edx
  801ed6:	50                   	push   %eax
  801ed7:	ff 75 10             	pushl  0x10(%ebp)
  801eda:	ff 75 0c             	pushl  0xc(%ebp)
  801edd:	ff 75 08             	pushl  0x8(%ebp)
  801ee0:	6a 27                	push   $0x27
  801ee2:	e8 18 fb ff ff       	call   8019ff <syscall>
  801ee7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eea:	90                   	nop
}
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <chktst>:
void chktst(uint32 n)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	ff 75 08             	pushl  0x8(%ebp)
  801efb:	6a 29                	push   $0x29
  801efd:	e8 fd fa ff ff       	call   8019ff <syscall>
  801f02:	83 c4 18             	add    $0x18,%esp
	return ;
  801f05:	90                   	nop
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <inctst>:

void inctst()
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 2a                	push   $0x2a
  801f17:	e8 e3 fa ff ff       	call   8019ff <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1f:	90                   	nop
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <gettst>:
uint32 gettst()
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 2b                	push   $0x2b
  801f31:	e8 c9 fa ff ff       	call   8019ff <syscall>
  801f36:	83 c4 18             	add    $0x18,%esp
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 2c                	push   $0x2c
  801f4d:	e8 ad fa ff ff       	call   8019ff <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
  801f55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f58:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f5c:	75 07                	jne    801f65 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f63:	eb 05                	jmp    801f6a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 2c                	push   $0x2c
  801f7e:	e8 7c fa ff ff       	call   8019ff <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
  801f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f89:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f8d:	75 07                	jne    801f96 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f8f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f94:	eb 05                	jmp    801f9b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 2c                	push   $0x2c
  801faf:	e8 4b fa ff ff       	call   8019ff <syscall>
  801fb4:	83 c4 18             	add    $0x18,%esp
  801fb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fba:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fbe:	75 07                	jne    801fc7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fc0:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc5:	eb 05                	jmp    801fcc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 2c                	push   $0x2c
  801fe0:	e8 1a fa ff ff       	call   8019ff <syscall>
  801fe5:	83 c4 18             	add    $0x18,%esp
  801fe8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801feb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fef:	75 07                	jne    801ff8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ff1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff6:	eb 05                	jmp    801ffd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	ff 75 08             	pushl  0x8(%ebp)
  80200d:	6a 2d                	push   $0x2d
  80200f:	e8 eb f9 ff ff       	call   8019ff <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
	return ;
  802017:	90                   	nop
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80201e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802021:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802024:	8b 55 0c             	mov    0xc(%ebp),%edx
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	6a 00                	push   $0x0
  80202c:	53                   	push   %ebx
  80202d:	51                   	push   %ecx
  80202e:	52                   	push   %edx
  80202f:	50                   	push   %eax
  802030:	6a 2e                	push   $0x2e
  802032:	e8 c8 f9 ff ff       	call   8019ff <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
}
  80203a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802042:	8b 55 0c             	mov    0xc(%ebp),%edx
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	52                   	push   %edx
  80204f:	50                   	push   %eax
  802050:	6a 2f                	push   $0x2f
  802052:	e8 a8 f9 ff ff       	call   8019ff <syscall>
  802057:	83 c4 18             	add    $0x18,%esp
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <__udivdi3>:
  80205c:	55                   	push   %ebp
  80205d:	57                   	push   %edi
  80205e:	56                   	push   %esi
  80205f:	53                   	push   %ebx
  802060:	83 ec 1c             	sub    $0x1c,%esp
  802063:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802067:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80206b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80206f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802073:	89 ca                	mov    %ecx,%edx
  802075:	89 f8                	mov    %edi,%eax
  802077:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80207b:	85 f6                	test   %esi,%esi
  80207d:	75 2d                	jne    8020ac <__udivdi3+0x50>
  80207f:	39 cf                	cmp    %ecx,%edi
  802081:	77 65                	ja     8020e8 <__udivdi3+0x8c>
  802083:	89 fd                	mov    %edi,%ebp
  802085:	85 ff                	test   %edi,%edi
  802087:	75 0b                	jne    802094 <__udivdi3+0x38>
  802089:	b8 01 00 00 00       	mov    $0x1,%eax
  80208e:	31 d2                	xor    %edx,%edx
  802090:	f7 f7                	div    %edi
  802092:	89 c5                	mov    %eax,%ebp
  802094:	31 d2                	xor    %edx,%edx
  802096:	89 c8                	mov    %ecx,%eax
  802098:	f7 f5                	div    %ebp
  80209a:	89 c1                	mov    %eax,%ecx
  80209c:	89 d8                	mov    %ebx,%eax
  80209e:	f7 f5                	div    %ebp
  8020a0:	89 cf                	mov    %ecx,%edi
  8020a2:	89 fa                	mov    %edi,%edx
  8020a4:	83 c4 1c             	add    $0x1c,%esp
  8020a7:	5b                   	pop    %ebx
  8020a8:	5e                   	pop    %esi
  8020a9:	5f                   	pop    %edi
  8020aa:	5d                   	pop    %ebp
  8020ab:	c3                   	ret    
  8020ac:	39 ce                	cmp    %ecx,%esi
  8020ae:	77 28                	ja     8020d8 <__udivdi3+0x7c>
  8020b0:	0f bd fe             	bsr    %esi,%edi
  8020b3:	83 f7 1f             	xor    $0x1f,%edi
  8020b6:	75 40                	jne    8020f8 <__udivdi3+0x9c>
  8020b8:	39 ce                	cmp    %ecx,%esi
  8020ba:	72 0a                	jb     8020c6 <__udivdi3+0x6a>
  8020bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8020c0:	0f 87 9e 00 00 00    	ja     802164 <__udivdi3+0x108>
  8020c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020cb:	89 fa                	mov    %edi,%edx
  8020cd:	83 c4 1c             	add    $0x1c,%esp
  8020d0:	5b                   	pop    %ebx
  8020d1:	5e                   	pop    %esi
  8020d2:	5f                   	pop    %edi
  8020d3:	5d                   	pop    %ebp
  8020d4:	c3                   	ret    
  8020d5:	8d 76 00             	lea    0x0(%esi),%esi
  8020d8:	31 ff                	xor    %edi,%edi
  8020da:	31 c0                	xor    %eax,%eax
  8020dc:	89 fa                	mov    %edi,%edx
  8020de:	83 c4 1c             	add    $0x1c,%esp
  8020e1:	5b                   	pop    %ebx
  8020e2:	5e                   	pop    %esi
  8020e3:	5f                   	pop    %edi
  8020e4:	5d                   	pop    %ebp
  8020e5:	c3                   	ret    
  8020e6:	66 90                	xchg   %ax,%ax
  8020e8:	89 d8                	mov    %ebx,%eax
  8020ea:	f7 f7                	div    %edi
  8020ec:	31 ff                	xor    %edi,%edi
  8020ee:	89 fa                	mov    %edi,%edx
  8020f0:	83 c4 1c             	add    $0x1c,%esp
  8020f3:	5b                   	pop    %ebx
  8020f4:	5e                   	pop    %esi
  8020f5:	5f                   	pop    %edi
  8020f6:	5d                   	pop    %ebp
  8020f7:	c3                   	ret    
  8020f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020fd:	89 eb                	mov    %ebp,%ebx
  8020ff:	29 fb                	sub    %edi,%ebx
  802101:	89 f9                	mov    %edi,%ecx
  802103:	d3 e6                	shl    %cl,%esi
  802105:	89 c5                	mov    %eax,%ebp
  802107:	88 d9                	mov    %bl,%cl
  802109:	d3 ed                	shr    %cl,%ebp
  80210b:	89 e9                	mov    %ebp,%ecx
  80210d:	09 f1                	or     %esi,%ecx
  80210f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802113:	89 f9                	mov    %edi,%ecx
  802115:	d3 e0                	shl    %cl,%eax
  802117:	89 c5                	mov    %eax,%ebp
  802119:	89 d6                	mov    %edx,%esi
  80211b:	88 d9                	mov    %bl,%cl
  80211d:	d3 ee                	shr    %cl,%esi
  80211f:	89 f9                	mov    %edi,%ecx
  802121:	d3 e2                	shl    %cl,%edx
  802123:	8b 44 24 08          	mov    0x8(%esp),%eax
  802127:	88 d9                	mov    %bl,%cl
  802129:	d3 e8                	shr    %cl,%eax
  80212b:	09 c2                	or     %eax,%edx
  80212d:	89 d0                	mov    %edx,%eax
  80212f:	89 f2                	mov    %esi,%edx
  802131:	f7 74 24 0c          	divl   0xc(%esp)
  802135:	89 d6                	mov    %edx,%esi
  802137:	89 c3                	mov    %eax,%ebx
  802139:	f7 e5                	mul    %ebp
  80213b:	39 d6                	cmp    %edx,%esi
  80213d:	72 19                	jb     802158 <__udivdi3+0xfc>
  80213f:	74 0b                	je     80214c <__udivdi3+0xf0>
  802141:	89 d8                	mov    %ebx,%eax
  802143:	31 ff                	xor    %edi,%edi
  802145:	e9 58 ff ff ff       	jmp    8020a2 <__udivdi3+0x46>
  80214a:	66 90                	xchg   %ax,%ax
  80214c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802150:	89 f9                	mov    %edi,%ecx
  802152:	d3 e2                	shl    %cl,%edx
  802154:	39 c2                	cmp    %eax,%edx
  802156:	73 e9                	jae    802141 <__udivdi3+0xe5>
  802158:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80215b:	31 ff                	xor    %edi,%edi
  80215d:	e9 40 ff ff ff       	jmp    8020a2 <__udivdi3+0x46>
  802162:	66 90                	xchg   %ax,%ax
  802164:	31 c0                	xor    %eax,%eax
  802166:	e9 37 ff ff ff       	jmp    8020a2 <__udivdi3+0x46>
  80216b:	90                   	nop

0080216c <__umoddi3>:
  80216c:	55                   	push   %ebp
  80216d:	57                   	push   %edi
  80216e:	56                   	push   %esi
  80216f:	53                   	push   %ebx
  802170:	83 ec 1c             	sub    $0x1c,%esp
  802173:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802177:	8b 74 24 34          	mov    0x34(%esp),%esi
  80217b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80217f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802183:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802187:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80218b:	89 f3                	mov    %esi,%ebx
  80218d:	89 fa                	mov    %edi,%edx
  80218f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802193:	89 34 24             	mov    %esi,(%esp)
  802196:	85 c0                	test   %eax,%eax
  802198:	75 1a                	jne    8021b4 <__umoddi3+0x48>
  80219a:	39 f7                	cmp    %esi,%edi
  80219c:	0f 86 a2 00 00 00    	jbe    802244 <__umoddi3+0xd8>
  8021a2:	89 c8                	mov    %ecx,%eax
  8021a4:	89 f2                	mov    %esi,%edx
  8021a6:	f7 f7                	div    %edi
  8021a8:	89 d0                	mov    %edx,%eax
  8021aa:	31 d2                	xor    %edx,%edx
  8021ac:	83 c4 1c             	add    $0x1c,%esp
  8021af:	5b                   	pop    %ebx
  8021b0:	5e                   	pop    %esi
  8021b1:	5f                   	pop    %edi
  8021b2:	5d                   	pop    %ebp
  8021b3:	c3                   	ret    
  8021b4:	39 f0                	cmp    %esi,%eax
  8021b6:	0f 87 ac 00 00 00    	ja     802268 <__umoddi3+0xfc>
  8021bc:	0f bd e8             	bsr    %eax,%ebp
  8021bf:	83 f5 1f             	xor    $0x1f,%ebp
  8021c2:	0f 84 ac 00 00 00    	je     802274 <__umoddi3+0x108>
  8021c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8021cd:	29 ef                	sub    %ebp,%edi
  8021cf:	89 fe                	mov    %edi,%esi
  8021d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021d5:	89 e9                	mov    %ebp,%ecx
  8021d7:	d3 e0                	shl    %cl,%eax
  8021d9:	89 d7                	mov    %edx,%edi
  8021db:	89 f1                	mov    %esi,%ecx
  8021dd:	d3 ef                	shr    %cl,%edi
  8021df:	09 c7                	or     %eax,%edi
  8021e1:	89 e9                	mov    %ebp,%ecx
  8021e3:	d3 e2                	shl    %cl,%edx
  8021e5:	89 14 24             	mov    %edx,(%esp)
  8021e8:	89 d8                	mov    %ebx,%eax
  8021ea:	d3 e0                	shl    %cl,%eax
  8021ec:	89 c2                	mov    %eax,%edx
  8021ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021f2:	d3 e0                	shl    %cl,%eax
  8021f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021fc:	89 f1                	mov    %esi,%ecx
  8021fe:	d3 e8                	shr    %cl,%eax
  802200:	09 d0                	or     %edx,%eax
  802202:	d3 eb                	shr    %cl,%ebx
  802204:	89 da                	mov    %ebx,%edx
  802206:	f7 f7                	div    %edi
  802208:	89 d3                	mov    %edx,%ebx
  80220a:	f7 24 24             	mull   (%esp)
  80220d:	89 c6                	mov    %eax,%esi
  80220f:	89 d1                	mov    %edx,%ecx
  802211:	39 d3                	cmp    %edx,%ebx
  802213:	0f 82 87 00 00 00    	jb     8022a0 <__umoddi3+0x134>
  802219:	0f 84 91 00 00 00    	je     8022b0 <__umoddi3+0x144>
  80221f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802223:	29 f2                	sub    %esi,%edx
  802225:	19 cb                	sbb    %ecx,%ebx
  802227:	89 d8                	mov    %ebx,%eax
  802229:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80222d:	d3 e0                	shl    %cl,%eax
  80222f:	89 e9                	mov    %ebp,%ecx
  802231:	d3 ea                	shr    %cl,%edx
  802233:	09 d0                	or     %edx,%eax
  802235:	89 e9                	mov    %ebp,%ecx
  802237:	d3 eb                	shr    %cl,%ebx
  802239:	89 da                	mov    %ebx,%edx
  80223b:	83 c4 1c             	add    $0x1c,%esp
  80223e:	5b                   	pop    %ebx
  80223f:	5e                   	pop    %esi
  802240:	5f                   	pop    %edi
  802241:	5d                   	pop    %ebp
  802242:	c3                   	ret    
  802243:	90                   	nop
  802244:	89 fd                	mov    %edi,%ebp
  802246:	85 ff                	test   %edi,%edi
  802248:	75 0b                	jne    802255 <__umoddi3+0xe9>
  80224a:	b8 01 00 00 00       	mov    $0x1,%eax
  80224f:	31 d2                	xor    %edx,%edx
  802251:	f7 f7                	div    %edi
  802253:	89 c5                	mov    %eax,%ebp
  802255:	89 f0                	mov    %esi,%eax
  802257:	31 d2                	xor    %edx,%edx
  802259:	f7 f5                	div    %ebp
  80225b:	89 c8                	mov    %ecx,%eax
  80225d:	f7 f5                	div    %ebp
  80225f:	89 d0                	mov    %edx,%eax
  802261:	e9 44 ff ff ff       	jmp    8021aa <__umoddi3+0x3e>
  802266:	66 90                	xchg   %ax,%ax
  802268:	89 c8                	mov    %ecx,%eax
  80226a:	89 f2                	mov    %esi,%edx
  80226c:	83 c4 1c             	add    $0x1c,%esp
  80226f:	5b                   	pop    %ebx
  802270:	5e                   	pop    %esi
  802271:	5f                   	pop    %edi
  802272:	5d                   	pop    %ebp
  802273:	c3                   	ret    
  802274:	3b 04 24             	cmp    (%esp),%eax
  802277:	72 06                	jb     80227f <__umoddi3+0x113>
  802279:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80227d:	77 0f                	ja     80228e <__umoddi3+0x122>
  80227f:	89 f2                	mov    %esi,%edx
  802281:	29 f9                	sub    %edi,%ecx
  802283:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802287:	89 14 24             	mov    %edx,(%esp)
  80228a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80228e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802292:	8b 14 24             	mov    (%esp),%edx
  802295:	83 c4 1c             	add    $0x1c,%esp
  802298:	5b                   	pop    %ebx
  802299:	5e                   	pop    %esi
  80229a:	5f                   	pop    %edi
  80229b:	5d                   	pop    %ebp
  80229c:	c3                   	ret    
  80229d:	8d 76 00             	lea    0x0(%esi),%esi
  8022a0:	2b 04 24             	sub    (%esp),%eax
  8022a3:	19 fa                	sbb    %edi,%edx
  8022a5:	89 d1                	mov    %edx,%ecx
  8022a7:	89 c6                	mov    %eax,%esi
  8022a9:	e9 71 ff ff ff       	jmp    80221f <__umoddi3+0xb3>
  8022ae:	66 90                	xchg   %ax,%ax
  8022b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8022b4:	72 ea                	jb     8022a0 <__umoddi3+0x134>
  8022b6:	89 d9                	mov    %ebx,%ecx
  8022b8:	e9 62 ff ff ff       	jmp    80221f <__umoddi3+0xb3>
