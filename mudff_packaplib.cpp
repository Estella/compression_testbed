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

BYTE *Load_Input_File(char *FileName, DWORD *Size)
{
	BYTE *Memory;
	FILE *Input = fopen(FileName, "rb");

	if (!Input) return(NULL);
	// Get the filesize
	fseek(Input, 0, SEEK_END);
	*Size = ftell(Input);
	fseek(Input, 0, SEEK_SET);

	Memory = (BYTE *)malloc(*Size);
	if (!Memory) return(NULL);
	if (fread(Memory, 1, *Size, Input) != (size_t)*Size) return(NULL);
	if (Input) fclose(Input);
	Input = NULL;
	return(Memory);
}

extern "C"
{
#include "7z/LzmaEnc.h"
	//#include "7z/LzmaDec.h"
}


void* Alloc(void *p, size_t size) { return malloc(size); }
void Free(void *p, void *address) { if (address) free(address); }
ISzAlloc alloc = { Alloc, Free };

extern "C"  unsigned char* __stdcall compress_lzma(unsigned char* pvInput, DWORD dwInputSize, DWORD* pdwOutputSize)
{
	unsigned char* pvOutput;
	unsigned int Packed_Size;
	BYTE *Packed_Mem = (BYTE *)malloc(dwInputSize * 2);
	memset(Packed_Mem, 0, dwInputSize * 2);
	Packed_Size = dwInputSize * 2;
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
#include "aplib.h"
#pragma comment (lib,"aplib.lib")
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
	if (*out_size == APLIB_ERROR)
	{
		free(pvOutput);
		return NULL;
	}

	return pvOutput;
}

/* Work-memory needed for compression. Allocate memory in units
* of 'lzo_align_t' (instead of 'char') to make sure it is properly aligned.
*/
extern "C" DWORD _stdcall get_lzmadepackersize();
extern "C" DWORD _stdcall get_lzmadepackerptr();

extern "C" { void LzmaDecode(UInt16* workmem,
	const unsigned char *inStream, SizeT inSize,
	unsigned char *outStream, SizeT outSize);
}
int main(int argc, char *argv[]) {
	DWORD compressed;
	DWORD original_sz;
	DWORD aplibbed;
	BYTE *Original = Load_Input_File("unpacker.bin", &original_sz);
	DWORD adler1 = adler32(Original, original_sz);
	BYTE* compressed_data = compress_lzma(Original, original_sz, &compressed);
		
	DWORD unpacker_sz = get_lzmadepackersize();
	DWORD unpacker_ptr = get_lzmadepackerptr();

	typedef int(_stdcall *tdecomp) (UInt16* workmem,
		const unsigned char *inStream, SizeT inSize,
		unsigned char *outStream, SizeT outSize);
	//decomp decomp_lzma = (tdecomp)Load_Input_File("unpacker.bin", &unpacker_sz);
	tdecomp decomp_lzma = (tdecomp)unpacker_ptr;
	PVOID testmem = (unsigned char*)malloc(original_sz);
	unsigned char* workmem = (unsigned char*)malloc(0xC4000);
	int result;
	decomp_lzma((UInt16*)workmem, compressed_data + LZMA_PROPS_SIZE, (SizeT)compressed - LZMA_PROPS_SIZE, (unsigned char*)testmem, (SizeT)original_sz);
	DWORD adler2 = adler32((unsigned char*)testmem, original_sz);
	if (adler1 != adler2)printf("File not equal");
	free(Original);
	free(compressed_data);
	free(workmem);
	
	return 0;
}
	
