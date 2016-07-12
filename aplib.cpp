// Author:   Brandon LaCombe
// Date:     February 3, 2006
// License:  Public Domain
#include <windows.h>
#include <tchar.h>
#
// TODO: Enter extra includes here.
#include "aplib.h"
#pragma comment (lib,"aplib.lib")

extern "C" DWORD _stdcall get_aplibdepackersize();
extern "C" DWORD _stdcall get_aplibdepackerptr();

const int MOD_ADLER = 65521;

DWORD adler32(unsigned char *data, size_t len) /* where data is the location of the data in physical memory and
												  len is the length of the data in bytes */
{
	DWORD a = 1, b = 0;
	size_t index;
	/* Process each byte of the data in order */
	for (index = 0; index < len; ++index)
	{
		a = (a + data[index]) % MOD_ADLER;
		b = (b + a) % MOD_ADLER;
	}
	return (b << 16) | a;
}


extern "C"  unsigned char* compress_aplib(unsigned char* in_data, DWORD in_size, DWORD* out_size)
{
	unsigned char* pvOutput;
	DWORD adler32_begin = adler32(in_data, in_size);
    // TODO: Implement the Compress function.
    PVOID pvWorkMemory;
    DWORD dwOutputMemoryMaxSize,
    dwWorkMemorySize;
    dwWorkMemorySize = aP_workmem_size(in_size);
    dwOutputMemoryMaxSize = aP_max_packed_size(in_size);
    pvWorkMemory = VirtualAlloc(NULL, dwWorkMemorySize, MEM_COMMIT, PAGE_READWRITE);
	pvOutput = (unsigned char*)malloc(dwOutputMemoryMaxSize);
    *out_size = aP_pack(in_data, pvOutput, in_size, pvWorkMemory, NULL, NULL);
    VirtualFree(pvWorkMemory, 0, MEM_RELEASE);
    if(*out_size == APLIB_ERROR)
    {
        free(pvOutput);
        return NULL;
    }

	typedef int(_stdcall *tdecomp_aplib) (PVOID, DWORD, PVOID, DWORD);
	DWORD ptr = get_aplibdepackerptr();
	tdecomp_aplib decompress = (tdecomp_aplib)ptr;
	PVOID testmem = (unsigned char*)malloc(in_size);
	size_t outsize = 0;
	decompress(pvOutput, *out_size, testmem, in_size);
	_asm add esp, 10h


	DWORD adler32_end = adler32((unsigned char*)testmem, in_size);
	if (adler32_begin != adler32_end)
	{
		free(testmem);
		free(pvOutput);
		return NULL;
	}
	free(testmem);

    return pvOutput;
}