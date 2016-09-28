
; Generated by Code snippet creator IDA Pro plugin v0.990 beta
; (c) 2003-2008 servil, semteksoft corporation, inc.
; Host module: C:\codecrack\src\svn\mudbwt\mudff.exe

.686p
.mmx
.xmm
.k3d
.model flat, C
option casemap: none

; thunk import functions excluded from export: insert standard header file(s) here
; library functions excluded from export: insert corresponding header file(s) here

assume es: nothing

.code

; |   This file has been generated by The Interactive Disassembler (IDA)    |
; |       Copyright (c) 2011 Hex-Rays, <support@hex-rays.com>     |
; | 		 License info: 48-327F-7274-B7 		    |
; | 		       ESET spol. s r.o. 		    |
; Input CRC32 : 07BA6F51

.686p
.mmx
.model flat

assume cs:_text
;org 401000h
assume es:nothing, ss:nothing, ds:_data, fs:nothing, gs:nothing

; Attributes: bp-based frame

; void __stdcall LzmaDecode(char *workmem, const char *inStream, unsigned int inSize, char *outStream, unsigned int outSize)
_LzmaDecode@20 proc near

rd= _CRangeDecoder ptr -24h
var_14= dword ptr -14h
var_10= dword ptr -10h
var_C= dword ptr -0Ch
var_8= dword ptr -8
var_1= byte ptr -1
workmem= dword ptr  8
inStream= dword ptr  0Ch
inSize= dword ptr  10h
outStream= dword ptr  14h
outSize= dword ptr  18h

push ebp
mov ebp, esp
sub esp, 24h
and [ebp+var_14], 0
xor eax, eax
inc eax
mov [ebp+var_1], 0
push ebx
push esi
push edi
mov edi, [ebp+workmem]
mov esi, eax
mov [ebp+var_C], eax
mov ecx, 1839Bh
mov [ebp+var_8], eax
xor ebx, ebx
mov [ebp+var_10], eax
mov eax, 4000400h
rep stosd
mov eax, [ebp+inSize]
xor ecx, ecx
mov edi, [ebp+inStream]
add eax, edi
or [ebp+rd.Range], 0FFFFFFFFh
push 5
mov [ebp+rd.BufferLim], eax
pop edx

loc_401044:
movzx eax, byte ptr [edi]
shl ecx, 8
or ecx, eax
inc edi
dec edx
jnz loc_401044
mov edx, [ebp+workmem]
mov [ebp+rd.Code], ecx
mov [ebp+rd.Buffer], edi
cmp [ebp+outSize], ebx
jbe loc_4012BE
mov edi, [ebp+var_14]

loc_401065:
lea eax, [ebp+rd]
mov ecx, edi
push eax 	; rd
and ecx, 3
mov eax, ebx
shl eax, 4
add eax, ecx
mov [ebp+inStream], ecx
lea eax, [edx+eax*2]
push eax 	; prob
call _RangeDecoderBitDecode@8 ; RangeDecoderBitDecode(x,x)
test eax, eax
jnz loc_4010EA
movzx eax, [ebp+var_1]
mov ecx, [ebp+workmem]
imul eax, 600h
add ecx, 0E6Ch
push 7
add ecx, eax
pop eax
cmp ebx, eax
jl loc_4010B1
mov edx, [ebp+outStream]
mov eax, edi
sub eax, esi
push 1
movzx eax, byte ptr [eax+edx]
push eax
jmp loc_4010B5

loc_4010B1: 	; decodematch
push 0
push 0 	; matchByte

loc_4010B5:
lea eax, [ebp+rd]
push eax 	; rd
push ecx 	; probs
call _LzmaLiteralDecodeMatch@16 ; LzmaLiteralDecodeMatch(x,x,x,x)
mov ecx, [ebp+outStream]
mov [ebp+var_1], al
mov [edi+ecx], al
inc edi
cmp ebx, 4
jge loc_4010D5
xor ebx, ebx
jmp loc_4012B2

loc_4010D5:
cmp ebx, 0Ah
jge loc_4010E2
sub ebx, 3
jmp loc_4012B2

loc_4010E2:
sub ebx, 6
jmp loc_4012B2

loc_4010EA:
lea eax, [ebp+rd]
push eax 	; rd
mov eax, [ebp+workmem]
add eax, 180h
lea eax, [eax+ebx*2]
push eax 	; prob
call _RangeDecoderBitDecode@8 ; RangeDecoderBitDecode(x,x)
cmp eax, 1
jnz loc_4011DB
lea eax, [ebp+rd]
push eax 	; rd
mov eax, [ebp+workmem]
lea eax, [eax+ebx*2]
add eax, 198h
push eax 	; prob
call _RangeDecoderBitDecode@8 ; RangeDecoderBitDecode(x,x)
test eax, eax
lea eax, [ebp+rd]
push eax 	; rd
jnz loc_401164
mov ecx, [ebp+workmem]
lea eax, [ebx+0Fh]
shl eax, 4
add eax, [ebp+inStream]
lea eax, [ecx+eax*2]
push eax 	; prob
call _RangeDecoderBitDecode@8 ; RangeDecoderBitDecode(x,x)
test eax, eax
jnz loc_4011B0
push 0Bh
pop eax
push 9
pop ecx
push 7
pop edx
cmp ebx, edx
cmovl eax, ecx
mov ecx, [ebp+outStream]
mov ebx, eax
mov eax, edi
sub eax, esi
mov al, [eax+ecx]
mov [edi+ecx], al
inc edi
mov [ebp+var_1], al
jmp loc_4012B2

loc_401164:
mov eax, [ebp+workmem]
lea eax, [eax+ebx*2]
add eax, 1B0h
push eax 	; prob
call _RangeDecoderBitDecode@8 ; RangeDecoderBitDecode(x,x)
test eax, eax
jnz loc_40117E
mov eax, [ebp+var_C]
jmp loc_4011AB

loc_40117E:
lea eax, [ebp+rd]
push eax 	; rd
mov eax, [ebp+workmem]
lea eax, [eax+ebx*2]
add eax, 1C8h
push eax 	; prob
call _RangeDecoderBitDecode@8 ; RangeDecoderBitDecode(x,x)
test eax, eax
jnz loc_40119C
mov eax, [ebp+var_8]
jmp loc_4011A5

loc_40119C:
mov eax, [ebp+var_10]
mov ecx, [ebp+var_8]
mov [ebp+var_10], ecx

loc_4011A5:
mov ecx, [ebp+var_C]
mov [ebp+var_8], ecx

loc_4011AB:
mov [ebp+var_C], esi
mov esi, eax

loc_4011B0: 	; posState
push [ebp+inStream]
lea eax, [ebp+rd]
push eax 	; rd
mov eax, [ebp+workmem]
add eax, 0A68h
push eax 	; p
call _LzmaLenDecode@12 ; LzmaLenDecode(x,x,x)
push 0Bh
pop ecx
push 8
mov edx, eax
cmp ebx, 7
pop eax
cmovl ecx, eax
mov [ebp+inSize], ecx
jmp loc_401296

loc_4011DB:
mov eax, [ebp+var_8]
mov [ebp+var_10], eax
mov eax, [ebp+var_C]
push 0Ah
mov [ebp+var_8], eax
pop eax
push 7
pop ecx
push [ebp+inStream] ; posState
cmp ebx, ecx
mov [ebp+var_C], esi
mov esi, [ebp+workmem]
cmovl eax, ecx
mov [ebp+inSize], eax
lea eax, [ebp+rd]
push eax 	; rd
lea eax, [esi+664h]
push eax 	; p
call _LzmaLenDecode@12 ; LzmaLenDecode(x,x,x)
mov ecx, eax
lea eax, [ebp+rd]
push 0 	; reverse_bit
push eax 	; rd
push 6 	; numLevels
push 3
pop eax
cmp ecx, 4
mov [ebp+inStream], ecx
cmovl eax, ecx
shl eax, 7
add eax, 360h
add eax, esi
push eax 	; probs
call _RangeDecoderBitTreeDecode@16 ; RangeDecoderBitTreeDecode(x,x,x,x)
mov edx, eax
mov esi, edx
cmp edx, 4
jl loc_401292
mov ecx, edx
and esi, 1
sar ecx, 1
or esi, 2
dec ecx
shl esi, cl
cmp edx, 0Eh
jge loc_401268
push 1
lea eax, [ebp+rd]
push eax
push ecx
mov ecx, [ebp+workmem]
mov eax, esi
sub eax, edx
add ecx, 55Eh
lea eax, [ecx+eax*2]
jmp loc_40128A

loc_401268:
lea eax, [ecx-4]
push eax 	; numTotalBits
lea eax, [ebp+rd]
push eax 	; rd
call _RangeDecoderDecodeDirectBits@8 ; RangeDecoderDecodeDirectBits(x,x)
shl eax, 4
add esi, eax
lea eax, [ebp+rd]
push 1 	; reverse_bit
push eax 	; rd
mov eax, [ebp+workmem]
push 4 	; numLevels
add eax, 644h

loc_40128A: 	; probs
push eax
call _RangeDecoderBitTreeDecode@16 ; RangeDecoderBitTreeDecode(x,x,x,x)
add esi, eax

loc_401292:
mov edx, [ebp+inStream]
inc esi

loc_401296:
mov ecx, [ebp+outStream]
mov eax, edi
sub eax, esi
add edx, 2
add eax, ecx

loc_4012A2:
mov bl, [eax]
mov [edi+ecx], bl
inc edi
inc eax
mov [ebp+var_1], bl
dec edx
jnz loc_4012A2
mov ebx, [ebp+inSize]

loc_4012B2:
mov edx, [ebp+workmem]
cmp edi, [ebp+outSize]
jb loc_401065

loc_4012BE:
pop edi
pop esi
pop ebx
mov esp, ebp
pop ebp
retn 14h
_LzmaDecode@20 endp

; |   This file has been generated by The Interactive Disassembler (IDA)    |
; |       Copyright (c) 2011 Hex-Rays, <support@hex-rays.com>     |
; | 		 License info: 48-327F-7274-B7 		    |
; | 		       ESET spol. s r.o. 		    |

; Attributes: bp-based frame

; int __stdcall RangeDecoderBitDecode(unsigned __int16 *prob, _CRangeDecoder *rd)
_RangeDecoderBitDecode@8 proc near

prob= dword ptr  8
rd= dword ptr  0Ch

push ebp
mov ebp, esp
mov edx, [ebp+prob]
push ebx
mov ebx, [ebp+rd]
push esi
movzx ecx, word ptr [edx]
push edi
mov edi, [ebx+8]
mov eax, edi
mov esi, [ebx+0Ch]
shr eax, 0Bh
imul eax, ecx
cmp esi, eax
jnb loc_4013E8
mov edi, eax
mov eax, 800h
sub eax, ecx
sar eax, 5
add eax, ecx
mov [edx], ax
xor eax, eax
jmp loc_4013FC

loc_4013E8:
sub edi, eax
sub esi, eax
mov ax, cx
shr ax, 5
sub cx, ax
xor eax, eax
mov [edx], cx
inc eax

loc_4013FC:
cmp edi, 1000000h
jnb loc_401416
mov edx, [ebx]
shl esi, 8
shl edi, 8
movzx ecx, byte ptr [edx]
or esi, ecx
lea ecx, [edx+1]
mov [ebx], ecx

loc_401416:
mov [ebx+8], edi
pop edi
mov [ebx+0Ch], esi
pop esi
pop ebx
pop ebp
retn 8
_RangeDecoderBitDecode@8 endp

; |   This file has been generated by The Interactive Disassembler (IDA)    |
; |       Copyright (c) 2011 Hex-Rays, <support@hex-rays.com>     |
; | 		 License info: 48-327F-7274-B7 		    |
; | 		       ESET spol. s r.o. 		    |

; Attributes: bp-based frame

; char __stdcall LzmaLiteralDecodeMatch(unsigned __int16 *probs, _CRangeDecoder *rd, char matchByte, int decodematch)
_LzmaLiteralDecodeMatch@16 proc near

probs= dword ptr  8
rd= dword ptr  0Ch
matchByte= byte ptr  10h
decodematch= dword ptr 14h

push ebp
mov ebp, esp
push ebx
push esi
xor ebx, ebx
push edi
mov edi, [ebp+probs]
inc ebx

loc_401342:
cmp [ebp+decodematch], 0
push [ebp+rd] ; rd
jnz loc_40135D
lea esi, [ebx+ebx]
lea eax, [esi+edi]
push eax 	; prob
call _RangeDecoderBitDecode@8 ; RangeDecoderBitDecode(x,x)
mov ebx, eax
or ebx, esi
jmp loc_401384

loc_40135D:
mov al, [ebp+matchByte]
movzx esi, al
add al, al
shr esi, 7
mov [ebp+matchByte], al
lea eax, [esi+1]
shl eax, 8
add eax, ebx
lea eax, [edi+eax*2]
push eax 	; prob
call _RangeDecoderBitDecode@8 ; RangeDecoderBitDecode(x,x)
add ebx, ebx
or ebx, eax
cmp esi, eax
jnz loc_4013A1

loc_401384:
cmp ebx, 100h
jl loc_401342
jmp loc_4013A9

loc_40138E: 	; rd
push [ebp+rd]
lea esi, [ebx+ebx]
lea eax, [esi+edi]
push eax 	; prob
call _RangeDecoderBitDecode@8 ; RangeDecoderBitDecode(x,x)
mov ebx, eax
or ebx, esi

loc_4013A1:
cmp ebx, 100h
jl loc_40138E

loc_4013A9:
pop edi
pop esi
mov al, bl
pop ebx
pop ebp
retn 10h
_LzmaLiteralDecodeMatch@16 endp

; |   This file has been generated by The Interactive Disassembler (IDA)    |
; |       Copyright (c) 2011 Hex-Rays, <support@hex-rays.com>     |
; | 		 License info: 48-327F-7274-B7 		    |
; | 		       ESET spol. s r.o. 		    |

; Attributes: bp-based frame

; int __stdcall LzmaLenDecode(unsigned __int16 *p, _CRangeDecoder *rd, int posState)
_LzmaLenDecode@12 proc near

p= dword ptr  8
rd= dword ptr  0Ch
posState= dword ptr  10h

push ebp
mov ebp, esp
push esi
mov esi, [ebp+rd]
push edi
mov edi, [ebp+p]
push esi 	; rd
push edi 	; prob
call _RangeDecoderBitDecode@8 ; RangeDecoderBitDecode(x,x)
test eax, eax
jnz loc_4012F4
push eax 	; reverse_bit
mov eax, [ebp+posState]
shl eax, 4
push esi 	; rd
add eax, 4
push 3 	; numLevels
add eax, edi
push eax 	; probs
call _RangeDecoderBitTreeDecode@16 ; RangeDecoderBitTreeDecode(x,x,x,x)
jmp loc_401330

loc_4012F4: 	; rd
push esi
lea eax, [edi+2]
push eax 	; prob
call _RangeDecoderBitDecode@8 ; RangeDecoderBitDecode(x,x)
push 0 	; reverse_bit
push esi 	; rd
test eax, eax
jnz loc_40131F
mov eax, [ebp+posState]
shl eax, 4
add eax, 104h
push 3 	; numLevels
add eax, edi
push eax 	; probs
call _RangeDecoderBitTreeDecode@16 ; RangeDecoderBitTreeDecode(x,x,x,x)
add eax, 8
jmp loc_401330

loc_40131F: 	; numLevels
push 8
lea eax, [edi+204h]
push eax 	; probs
call _RangeDecoderBitTreeDecode@16 ; RangeDecoderBitTreeDecode(x,x,x,x)
add eax, 10h

loc_401330:
pop edi
pop esi
pop ebp
retn 0Ch
_LzmaLenDecode@12 endp

; |   This file has been generated by The Interactive Disassembler (IDA)    |
; |       Copyright (c) 2011 Hex-Rays, <support@hex-rays.com>     |
; | 		 License info: 48-327F-7274-B7 		    |
; | 		       ESET spol. s r.o. 		    |

; Attributes: bp-based frame

; int __stdcall RangeDecoderBitTreeDecode(unsigned __int16 *probs, int numLevels, _CRangeDecoder *rd, int reverse_bit)
_RangeDecoderBitTreeDecode@16 proc near

probs= dword ptr  8
numLevels= dword ptr  0Ch
rd= dword ptr  10h
reverse_bit= dword ptr 14h

push ebp
mov ebp, esp
push ecx
push ebx
push edi
xor edi, edi
xor ebx, ebx
inc edi
mov edx, edi
cmp [ebp+numLevels], ebx
jle loc_40145C
mov edi, ebx
push esi

loc_401438: 	; rd
push [ebp+rd]
mov eax, [ebp+probs]
lea esi, [edx+edx]
add eax, esi
push eax 	; prob
call _RangeDecoderBitDecode@8 ; RangeDecoderBitDecode(x,x)
mov ecx, edi
lea edx, [esi+eax]
shl eax, cl
or ebx, eax
inc edi
cmp edi, [ebp+numLevels]
jl loc_401438
xor edi, edi
inc edi
pop esi

loc_40145C:
cmp [ebp+reverse_bit], 0
jz loc_401466
mov eax, ebx
jmp loc_40146F

loc_401466:
mov ecx, [ebp+numLevels]
shl edi, cl
sub edx, edi
mov eax, edx

loc_40146F:
pop edi
pop ebx
mov esp, ebp
pop ebp
retn 10h
_RangeDecoderBitTreeDecode@16 endp

; |   This file has been generated by The Interactive Disassembler (IDA)    |
; |       Copyright (c) 2011 Hex-Rays, <support@hex-rays.com>     |
; | 		 License info: 48-327F-7274-B7 		    |
; | 		       ESET spol. s r.o. 		    |

; Attributes: bp-based frame

; unsigned int __stdcall RangeDecoderDecodeDirectBits(_CRangeDecoder *rd, int numTotalBits)
_RangeDecoderDecodeDirectBits@8 proc near

rd= dword ptr  8
numTotalBits= dword ptr  0Ch

push ebp
mov ebp, esp
mov eax, [ebp+numTotalBits]
push ebx
mov ebx, [ebp+rd]
push esi
push edi
xor edi, edi
mov edx, [ebx+8]
mov esi, [ebx+0Ch]
test eax, eax
jz loc_4014BF

loc_40148F:
shr edx, 1
add edi, edi
cmp esi, edx
jb loc_40149C
sub esi, edx
or edi, 1

loc_40149C:
cmp edx, 1000000h
jnb loc_4014B9
mov ecx, [ebx]
shl esi, 8
shl edx, 8
movzx eax, byte ptr [ecx]
or esi, eax
lea eax, [ecx+1]
mov [ebx], eax
mov eax, [ebp+numTotalBits]

loc_4014B9:
dec eax
mov [ebp+numTotalBits], eax
jnz loc_40148F

loc_4014BF:
mov eax, edi
mov [ebx+0Ch], esi
pop edi
pop esi
mov [ebx+8], edx
pop ebx
pop ebp
retn 8
_RangeDecoderDecodeDirectBits@8 endp

end