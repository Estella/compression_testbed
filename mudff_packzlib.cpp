#include <cstdlib>
#include <vector>

using namespace std;

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>
#include "zopfli/deflate.h"
#include "zlib.h"
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



extern "C"  unsigned char* compress_deflate(unsigned char* in_data, DWORD in_size, DWORD* out_size)
{
	ZopfliOptions options;
	unsigned char* pvOutput;
	options.numiterations = 20;
	size_t outsize = 0;
	ZopfliInitOptions(&options);
	unsigned char bp = 0;
	ZopfliDeflate(&options, 2 /* Dynamic block */, 1,
		in_data, in_size, &bp, &pvOutput, &outsize);
	*out_size = outsize;
	return pvOutput;
}


typedef  int( __stdcall  *d3dx_inflateinit)(z_streamp strm, const char *version, int stream_size);
typedef int(__stdcall *d3dx_inflate)(z_streamp strm, int flush);
typedef  int( __stdcall *d3dx_inflateend) (z_streamp strm);
int main(int argc, char *argv[]) {
	DWORD compressed;
	DWORD original_sz;
	BYTE *Original = Load_Input_File("unpacker.bin", &original_sz);
	DWORD adler1 = adler32(Original, original_sz);

	//compressed = original_sz * 2;
	//BYTE *Packed_Mem = (BYTE *)malloc(compressed);
	//memset(Packed_Mem, 0, compressed);

    BYTE* Packed_Mem = compress_deflate(Original, original_sz, &compressed);
	//if (!compress_rfc1950_7z(Original, original_sz, Packed_Mem, compressed))


	HMODULE hMod = LoadLibrary("d3dx9_30.dll");
	// Calculate the actual address 
	const DWORD_PTR infinitOffset = 0x200046;
	const DWORD_PTR infOffset = 0x200064;
	const DWORD_PTR infend = 0x1FFF1A;
	DWORD_PTR inflateinit = (DWORD_PTR)hMod + infinitOffset;
	DWORD_PTR inflate = (DWORD_PTR)hMod + infOffset;
	DWORD_PTR inflateend = (DWORD_PTR)hMod + infend;

	z_stream d_stream;
	memcpy(Packed_Mem + 2, Packed_Mem, compressed);
	Packed_Mem[0] = 0x58;
	Packed_Mem[1] = 0xc3;
	compressed += 2;
	unsigned char *Test_Mem = (unsigned char *)malloc(compressed * 2);
	if (Test_Mem)
	{
		memset(&d_stream, 0, sizeof(d_stream));
		d_stream.next_in = (unsigned char *)Packed_Mem;
		d_stream.avail_in = compressed;
		d_stream.next_out = Test_Mem;
		d_stream.avail_out = (unsigned int)0x430000;
		//inflateInit(&d_stream);
		d3dx_inflateinit d3dx_infinit = (d3dx_inflateinit)inflateinit;
		d3dx_inflate d3dx_inf = (d3dx_inflate)inflate;
		d3dx_inflateend d3dx_infend = (d3dx_inflateend)inflateend;
		d3dx_infinit(&d_stream, ZLIB_VERSION, (int)sizeof(z_stream));
		d3dx_inf(&d_stream, Z_FULL_FLUSH);
		d3dx_infend(&d_stream);
	}
	memcpy(Packed_Mem, Packed_Mem + 2, compressed);
	compressed -= 2;

	if (compressed >= original_sz)
	{
		printf("Packed file is bigger than unpacked one\n");
		return(0);
	}
	DWORD adler2 = adler32((unsigned char*)Test_Mem, original_sz);
	if (adler1 != adler2)
	{
		printf("File not equal");
	}
	
	free(Original);
	free(Packed_Mem);
	free(Test_Mem);
	return 0;
}
	
