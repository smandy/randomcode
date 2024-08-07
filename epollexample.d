#!/usr/bin/env rdmd

import std.stdio;
import core.sys.linux.epoll;
import core.sys.posix.unistd;
import std.conv;
import core.thread;

enum  {
    EFD_SEMAPHORE = octal!1,
    EFD_CLOEXEC = octal!2000000,
    EFD_NONBLOCK = octal!4000
}
extern(C) int eventfd(uint initval, int flags);

void testepoll() {
	class MyThr: Thread {
		int msgfd;
		this() {
			super(&thread_proc);
			
		}
		
		void thread_proc() {
			int efd = epoll_create(10);
			int fd = eventfd(0, EFD_NONBLOCK);
			msgfd =fd;
			
			epoll_event event;
			event.events = EPOLLIN;
			event.data.u64 = 0x1122334455667788;
			epoll_ctl(efd, EPOLL_CTL_ADD, fd, &event);
			
			ulong val=1;
			core.sys.posix.unistd.write(msgfd, &val, 8);
			
			int nfd;
			epoll_event pollevent;
			for(;;) {
				nfd = epoll_wait(efd, &pollevent, 1, -1);
				if(nfd>0) {
					ulong d = pollevent.data.u64;
					writefln("user, %0x", d); // -> print out is 55667788, high 4 bytes(0x11223344) is lost !!!
					break;
					
				}
			}
			
		}
	}
	
	auto thr = new MyThr();
	thr.start();
	thr.join();
}

void main() {
	testepoll();
}
