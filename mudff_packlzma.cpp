#include <cstdlib>
#include <vector>

using namespace std;

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>

#ifdef WIN32
    #include <direct.h>
    #include <malloc.h>
#else
    #include <unistd.h>
    #include <sys/stat.h>
#endif

#define VER         "0.3"

int decomp(char * file, char* directory);
int comp(char * file, char* directory);
void std_err(void);
void io_err(void);



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

extern "C"
{
#include "7z/LzmaEnc.h"
}


void* Alloc(void *p, size_t size) { return malloc(size); }
void Free(void *p, void *address) { if (address) free(address); }
ISzAlloc alloc = { Alloc, Free };

extern "C"  unsigned char* __stdcall compress_lzma(unsigned char* pvInput, DWORD dwInputSize, DWORD* pdwOutputSize)
{
	unsigned char* pvOutput;
	unsigned int Packed_Size = dwInputSize * 2;
	BYTE *Packed_Mem = (BYTE *)malloc(Packed_Size);
	memset(Packed_Mem, 0, Packed_Size);
	CLzmaEncProps props;
	LzmaEncProps_Init(&props);
	props.level = 9;
	props.fb = 273;
	props.lc = 8;
	props.lp = 0;
	props.pb = 2;
	props.algo = 1;
	props.numThreads = 4;
	SizeT s = LZMA_PROPS_SIZE;
	SRes err = LzmaEncode((Byte*)Packed_Mem + LZMA_PROPS_SIZE, (SizeT*)&Packed_Size,
		(Byte*)pvInput, dwInputSize, &props, (Byte*)Packed_Mem, &s, 1, NULL, &alloc, &alloc);
	Packed_Size += LZMA_PROPS_SIZE;
	if (err != SZ_OK)
	{
		free(Packed_Mem);
		free(pvOutput);
		return NULL;
	}
	*pdwOutputSize = Packed_Size;
	pvOutput = (unsigned char*)malloc(*pdwOutputSize);
	memcpy(pvOutput, Packed_Mem, *pdwOutputSize);
	free(Packed_Mem);
	return pvOutput;

}

/* Work-memory needed for compression. Allocate memory in units
* of 'lzo_align_t' (instead of 'char') to make sure it is properly aligned.
*/
extern "C" DWORD _stdcall get_lzmadepackersize();
extern "C" DWORD _stdcall get_lzmadepackerptr();

#include "entropy/lzdatagen.h"
#include "entropy/pcg_basic.h"
#include <time.h>

#define BLOCK_SIZE (1024 * 1024 * 2)

extern "C" { void LzmaDecode(UInt16* workmem,
	const unsigned char *inStream,
	unsigned char *outStream, SizeT outSize);
}
int main(int argc, char *argv[]) {
	DWORD compressed;
	DWORD original_sz = BLOCK_SIZE;
	uint64_t seed = time(NULL);
	
	BYTE *Original = (unsigned char*)malloc(BLOCK_SIZE);
	pcg32_srandom(seed, 0xC0FFEE);
	lzdg_generate_data(Original, original_sz, 4.0, 3.0, 3.0);
	DWORD adler1 = adler32(Original, original_sz);
	printf("Original data adler is 0x%04x\n", adler1);
	BYTE* compressed_data = compress_lzma(Original, original_sz, &compressed);

	typedef int(_stdcall *tdecomp) (UInt16* workmem,
		const unsigned char *inStream, SizeT inSize,
		unsigned char *outStream, SizeT outSize);
	PVOID testmem = (unsigned char*)malloc(original_sz);
	unsigned char* workmem = (unsigned char*)malloc(0xC4000);
	int result;
	LzmaDecode((UInt16*)workmem, compressed_data + LZMA_PROPS_SIZE, (unsigned char*)testmem, (SizeT)original_sz);
	DWORD adler2 = adler32((unsigned char*)testmem, original_sz);
	if (adler1 != adler2)printf("File not equal\n");
	else printf("File equal\n");
	free(Original);
	free(compressed_data);
	free(workmem);
	
	return 0;
}
