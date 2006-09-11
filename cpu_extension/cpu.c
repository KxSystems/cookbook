/** @file cpu.c
 * 
 * Features:
 *
 * - Reading of the CPU frequency.
 *
 * - Reading of the time stamp counter. This version
 *   contains only the AMD64 support. 
 *
 * This file induces a compile time error for 
 * operating systems other than Linux.
 */
 
#if defined(__gnu_linux__) && defined (__LP64__)
#   include <stdio.h>
#   include <string.h>
#   include <limits.h>
#   include <time.h>
#   include <unistd.h>
#   include <fcntl.h>
#   include "k.h"
#   define MAX_PROCFILE_SIZE 32768

/** 
 * Get the current cpu frequency by reading /proc/cpuinfo, or -1
 * if there is a problem.
 * 
 * @param x Ignored; required to allow us to bind to this from q.
 * 
 * @return A double wrapped in a K object.
 */
K q_get_first_cpu_frequency(K x)
{
        static double frequency = -1.0;
        const char searchString[] = "cpu MHz		: ";
        char line[MAX_PROCFILE_SIZE];
        int fd = open ("/proc/cpuinfo", O_RDONLY);
        read (fd, line, MAX_PROCFILE_SIZE);
        char* position = strstr (line, searchString);
        if (NULL != position) {
		position += strlen (searchString);
		float f;
		sscanf (position, "%f", &f);
		frequency = (double) f;
        } 
        return kf(frequency);
}

/** 
 * Read the cycle counter. Shame about the conversion from
 * unsigned to signed. AMD64 only in this version.
 * 
 * @param x Ignored; required to allow us to bind to this from q.
 * 
 * @return A long long wrapped in a K object.
 */
K q_read_cycles_of_this_cpu(K x) 
{
	unsigned long a, b, reading;
	asm volatile("rdtsc" : "=a" (a), "=b" (b)); 
	reading = ((unsigned long)a) | (((unsigned long)b) << 32);
	return kj((J)reading); 
}
 
#else
#   error "Not implemented; this file is for 64bit linux only."
#endif

