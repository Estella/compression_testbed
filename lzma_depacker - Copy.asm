.686p
.model flat, stdcall
option casemap:none

.code

option prologue:none
option epilogue:none

get_lzmadepackersize proc export
    mov eax, unpacker_end - LzmaDecode
    ret
get_lzmadepackersize endp

get_lzmadepackerptr proc export
    mov eax, LzmaDecode
    ret
get_lzmadepackerptr endp



unpacker_start:


LzmaDecode:        
; void __stdcall LzmaDecode(char *workmem, const char *inStream, unsigned int inSize, char *outStream, unsigned int outSize)                          ;<= Procedure Start
;rd= _CRangeDecoder ptr -24h
;var_14= dword ptr -14h
;var_10= dword ptr -10h
;var_C= dword ptr -0Ch
;var_8= dword ptr -8
;var_1= byte ptr -1
;workmem= dword ptr  8
;inStream= dword ptr  0Ch
;inSize= dword ptr  10h
;outStream= dword ptr  14h
;outSize= dword ptr  18h
        PUSH EBP                             ; LzmaDecode
        MOV EBP,ESP
        SUB ESP,024h
		XOR EAX,EAX
        AND DWORD PTR SS:[EBP-014h],EAX
        MOV BYTE PTR SS:[EBP-1],AL
        INC EAX
        MOV DWORD PTR SS:[EBP-0Ch],EAX
		MOV DWORD PTR SS:[EBP-8],EAX
		MOV DWORD PTR SS:[EBP-010h],EAX
        pushad
        MOV EDI,DWORD PTR SS:[EBP+8]
        MOV ESI,EAX
        MOV ECX,01839Bh
        XOR EBX,EBX
        MOV EAX,04000400h
        REP STOS DWORD PTR ES:[EDI]
        MOV EAX,DWORD PTR SS:[EBP+010h]
        XOR ECX,ECX
        MOV EDI,DWORD PTR SS:[EBP+0Ch]
        ADD EAX,EDI
        OR DWORD PTR SS:[EBP-01Ch],0FFFFFFFFh
        PUSH 5
        MOV DWORD PTR SS:[EBP-020h],EAX
        POP EDX

@mudff_00D51064:

        MOVZX EAX,BYTE PTR DS:[EDI]
        SHL ECX,8
        OR ECX,EAX
        INC EDI
        DEC EDX
        JNZ @mudff_00D51064
        MOV EDX,DWORD PTR SS:[EBP+8]
        MOV DWORD PTR SS:[EBP-018h],ECX
        MOV DWORD PTR SS:[EBP-024h],EDI
        CMP DWORD PTR SS:[EBP+018h],EBX
        JBE @mudff_00D512DE
        MOV EDI,DWORD PTR SS:[EBP-014h]

@mudff_00D51085:

        LEA EAX,DWORD PTR SS:[EBP-024h]
        MOV ECX,EDI
        PUSH EAX
        AND ECX,3
        MOV EAX,EBX
        SHL EAX,4
        ADD EAX,ECX
        MOV DWORD PTR SS:[EBP+0Ch],ECX
        LEA EAX,DWORD PTR DS:[EDX+EAX*2]
        PUSH EAX
        CALL RangeDecoderBitDecode
        TEST EAX,EAX
        JNZ @mudff_00D5110A
        MOVZX EAX,BYTE PTR SS:[EBP-1]
        MOV ECX,DWORD PTR SS:[EBP+8]
        IMUL EAX,EAX,0600h
        ADD ECX,0E6Ch
        PUSH 7
        ADD ECX,EAX
        POP EAX
        CMP EBX,EAX
        JL @mudff_00D510D1
        MOV EDX,DWORD PTR SS:[EBP+014h]
        MOV EAX,EDI
        SUB EAX,ESI
        PUSH 1
        MOVZX EAX,BYTE PTR DS:[EAX+EDX]
        PUSH EAX
        JMP @mudff_00D510D5

@mudff_00D510D1:

        PUSH 0
        PUSH 0

@mudff_00D510D5:

        LEA EAX,DWORD PTR SS:[EBP-024h]
        PUSH EAX
        PUSH ECX
        CALL LzmaLiteralDecodeMatch
        MOV ECX,DWORD PTR SS:[EBP+014h]
        MOV BYTE PTR SS:[EBP-1],AL
        MOV BYTE PTR DS:[EDI+ECX],AL
        INC EDI
        CMP EBX,4
        JGE @mudff_00D510F5
        XOR EBX,EBX
        JMP @mudff_00D512D2

@mudff_00D510F5:

        CMP EBX,0Ah
        JGE @mudff_00D51102
        SUB EBX,3
        JMP @mudff_00D512D2

@mudff_00D51102:

        SUB EBX,6
        JMP @mudff_00D512D2

@mudff_00D5110A:

        LEA EAX,DWORD PTR SS:[EBP-024h]
        PUSH EAX
        MOV EAX,DWORD PTR SS:[EBP+8]
        ADD EAX,0180h
        LEA EAX,DWORD PTR DS:[EAX+EBX*2]
        PUSH EAX
        CALL RangeDecoderBitDecode
        CMP EAX,1
        JNZ @mudff_00D511FB
        LEA EAX,DWORD PTR SS:[EBP-024h]
        PUSH EAX
        MOV EAX,DWORD PTR SS:[EBP+8]
        LEA EAX,DWORD PTR DS:[EAX+EBX*2]
        ADD EAX,0198h
        PUSH EAX
        CALL RangeDecoderBitDecode
        TEST EAX,EAX
        LEA EAX,DWORD PTR SS:[EBP-024h]
        PUSH EAX
        JNZ @mudff_00D51184
        MOV ECX,DWORD PTR SS:[EBP+8]
        LEA EAX,DWORD PTR DS:[EBX+0Fh]
        SHL EAX,4
        ADD EAX,DWORD PTR SS:[EBP+0Ch]
        LEA EAX,DWORD PTR DS:[ECX+EAX*2]
        PUSH EAX
        CALL RangeDecoderBitDecode
        TEST EAX,EAX
        JNZ @mudff_00D511D0
        PUSH 0Bh
        POP EAX
        PUSH 9
        POP ECX
        PUSH 7
        POP EDX
        CMP EBX,EDX
        CMOVL EAX,ECX
        MOV ECX,DWORD PTR SS:[EBP+014h]
        MOV EBX,EAX
        MOV EAX,EDI
        SUB EAX,ESI
        MOV AL,BYTE PTR DS:[EAX+ECX]
        MOV BYTE PTR DS:[EDI+ECX],AL
        INC EDI
        MOV BYTE PTR SS:[EBP-1],AL
        JMP @mudff_00D512D2

@mudff_00D51184:

        MOV EAX,DWORD PTR SS:[EBP+8]
        LEA EAX,DWORD PTR DS:[EAX+EBX*2]
        ADD EAX,01B0h
        PUSH EAX
        CALL RangeDecoderBitDecode
        TEST EAX,EAX
        JNZ @mudff_00D5119E
        MOV EAX,DWORD PTR SS:[EBP-0Ch]
        JMP @mudff_00D511CB

@mudff_00D5119E:

        LEA EAX,DWORD PTR SS:[EBP-024h]
        PUSH EAX
        MOV EAX,DWORD PTR SS:[EBP+8]
        LEA EAX,DWORD PTR DS:[EAX+EBX*2]
        ADD EAX,01C8h
        PUSH EAX
        CALL RangeDecoderBitDecode
        TEST EAX,EAX
        JNZ @mudff_00D511BC
        MOV EAX,DWORD PTR SS:[EBP-8]
        JMP @mudff_00D511C5

@mudff_00D511BC:

        MOV EAX,DWORD PTR SS:[EBP-010h]
        MOV ECX,DWORD PTR SS:[EBP-8]
        MOV DWORD PTR SS:[EBP-010h],ECX

@mudff_00D511C5:

        MOV ECX,DWORD PTR SS:[EBP-0Ch]
        MOV DWORD PTR SS:[EBP-8],ECX

@mudff_00D511CB:

        MOV DWORD PTR SS:[EBP-0Ch],ESI
        MOV ESI,EAX

@mudff_00D511D0:

        PUSH DWORD PTR SS:[EBP+0Ch]
        LEA EAX,DWORD PTR SS:[EBP-024h]
        PUSH EAX
        MOV EAX,DWORD PTR SS:[EBP+8]
        ADD EAX,0A68h
        PUSH EAX
        CALL LzmaLenDecode
        PUSH 0Bh
        POP ECX
        PUSH 8
        MOV EDX,EAX
        CMP EBX,7
        POP EAX
        CMOVL ECX,EAX
        MOV DWORD PTR SS:[EBP+010h],ECX
        JMP @mudff_00D512B6

@mudff_00D511FB:

        MOV EAX,DWORD PTR SS:[EBP-8]
        MOV DWORD PTR SS:[EBP-010h],EAX
        MOV EAX,DWORD PTR SS:[EBP-0Ch]
        PUSH 0Ah
        MOV DWORD PTR SS:[EBP-8],EAX
        POP EAX
        PUSH 7
        POP ECX
        PUSH DWORD PTR SS:[EBP+0Ch]
        CMP EBX,ECX
        MOV DWORD PTR SS:[EBP-0Ch],ESI
        MOV ESI,DWORD PTR SS:[EBP+8]
        CMOVL EAX,ECX
        MOV DWORD PTR SS:[EBP+010h],EAX
        LEA EAX,DWORD PTR SS:[EBP-024h]
        PUSH EAX
        LEA EAX,DWORD PTR DS:[ESI+0664h]
        PUSH EAX
        CALL LzmaLenDecode
        MOV ECX,EAX
        LEA EAX,DWORD PTR SS:[EBP-024h]
        PUSH 0
        PUSH EAX
        PUSH 6
        PUSH 3
        POP EAX
        CMP ECX,4
        MOV DWORD PTR SS:[EBP+0Ch],ECX
        CMOVL EAX,ECX
        SHL EAX,7
        ADD EAX,0360h
        ADD EAX,ESI
        PUSH EAX
        CALL RangeDecoderBitTreeDecode
        MOV EDX,EAX
        MOV ESI,EDX
        CMP EDX,4
        JL @mudff_00D512B2
        MOV ECX,EDX
        AND ESI,1
        SAR ECX,1
        OR ESI,2
        DEC ECX
        SHL ESI,CL
        CMP EDX,0Eh
        JGE @mudff_00D51288
        PUSH 1
        LEA EAX,DWORD PTR SS:[EBP-024h]
        PUSH EAX
        PUSH ECX
        MOV ECX,DWORD PTR SS:[EBP+8]
        MOV EAX,ESI
        SUB EAX,EDX
        ADD ECX,055Eh
        LEA EAX,DWORD PTR DS:[ECX+EAX*2]
        JMP @mudff_00D512AA

@mudff_00D51288:

        LEA EAX,DWORD PTR DS:[ECX-4]
        PUSH EAX
        LEA EAX,DWORD PTR SS:[EBP-024h]
        PUSH EAX
        CALL RangeDecoderDecodeDirectBits
        SHL EAX,4
        ADD ESI,EAX
        LEA EAX,DWORD PTR SS:[EBP-024h]
        PUSH 1
        PUSH EAX
        MOV EAX,DWORD PTR SS:[EBP+8]
        PUSH 4
        ADD EAX,0644h

@mudff_00D512AA:

        PUSH EAX
        CALL RangeDecoderBitTreeDecode
        ADD ESI,EAX

@mudff_00D512B2:

        MOV EDX,DWORD PTR SS:[EBP+0Ch]
        INC ESI

@mudff_00D512B6:

        MOV ECX,DWORD PTR SS:[EBP+014h]
        MOV EAX,EDI
        SUB EAX,ESI
        ADD EDX,2
        ADD EAX,ECX

@mudff_00D512C2:

        MOV BL,BYTE PTR DS:[EAX]
        MOV BYTE PTR DS:[EDI+ECX],BL
        INC EDI
        INC EAX
        MOV BYTE PTR SS:[EBP-1],BL
        DEC EDX
        JNZ @mudff_00D512C2
        MOV EBX,DWORD PTR SS:[EBP+010h]

@mudff_00D512D2:

        MOV EDX,DWORD PTR SS:[EBP+8]
        CMP EDI,DWORD PTR SS:[EBP+018h]
        JB @mudff_00D51085

@mudff_00D512DE:

        popad
        MOV ESP,EBP
        POP EBP
        RETN


LzmaLenDecode:                               ;<= Procedure Start
; int __stdcall LzmaLenDecode(unsigned __int16 *p, _CRangeDecoder *rd, int posState)
;_LzmaLenDecode@12 proc near

;p= dword ptr  8
;rd= dword ptr  0Ch
;posState= dword ptr  10h
        PUSH EBP                             ; LzmaLenDecode
        MOV EBP,ESP
        PUSH ESI
        MOV ESI,DWORD PTR SS:[EBP+0Ch]
        PUSH EDI
        MOV EDI,DWORD PTR SS:[EBP+8]
        PUSH ESI
        PUSH EDI
        CALL RangeDecoderBitDecode
        TEST EAX,EAX
        JNZ @mudff_00D51314
        PUSH EAX
        MOV EAX,DWORD PTR SS:[EBP+010h]
        SHL EAX,4
        PUSH ESI
        ADD EAX,4
        PUSH 3
        ADD EAX,EDI
        PUSH EAX
        CALL RangeDecoderBitTreeDecode
        JMP @mudff_00D51350

@mudff_00D51314:

        PUSH ESI
        LEA EAX,DWORD PTR DS:[EDI+2]
        PUSH EAX
        CALL RangeDecoderBitDecode
        PUSH 0
        PUSH ESI
        TEST EAX,EAX
        JNZ @mudff_00D5133F
        MOV EAX,DWORD PTR SS:[EBP+010h]
        SHL EAX,4
        ADD EAX,0104h
        PUSH 3
        ADD EAX,EDI
        PUSH EAX
        CALL RangeDecoderBitTreeDecode
        ADD EAX,8
        JMP @mudff_00D51350

@mudff_00D5133F:

        PUSH 8
        LEA EAX,DWORD PTR DS:[EDI+0204h]
        PUSH EAX
        CALL RangeDecoderBitTreeDecode
        ADD EAX,010h

@mudff_00D51350:

        POP EDI
        POP ESI
        POP EBP
        RETN 0Ch                             ;<= Procedure End


LzmaLiteralDecodeMatch:                      ;<= Procedure Start
; char __stdcall LzmaLiteralDecodeMatch(unsigned __int16 *probs, _CRangeDecoder *rd, char matchByte, int decodematch)
;_LzmaLiteralDecodeMatch@16 proc near

;probs= dword ptr  8
;rd= dword ptr  0Ch
;matchByte= byte ptr  10h
;decodematch= dword ptr 14h
        PUSH EBP                             ; LzmaLiteralDecodeMatch
        MOV EBP,ESP
        PUSH EBX
        PUSH ESI
		PUSH EDI
        XOR EBX,EBX
        
        MOV EDI,DWORD PTR SS:[EBP+8]
        INC EBX

@mudff_00D51362:

        CMP DWORD PTR SS:[EBP+014h],0
        PUSH DWORD PTR SS:[EBP+0Ch]
        JNZ @mudff_00D5137D
        LEA ESI,DWORD PTR DS:[EBX+EBX]
        LEA EAX,DWORD PTR DS:[ESI+EDI]
        PUSH EAX
        CALL RangeDecoderBitDecode
        MOV EBX,EAX
        OR EBX,ESI
        JMP @mudff_00D513A4

@mudff_00D5137D:

        MOV AL,BYTE PTR SS:[EBP+010h]
        MOVZX ESI,AL
        ADD AL,AL
        SHR ESI,7
        MOV BYTE PTR SS:[EBP+010h],AL
        LEA EAX,DWORD PTR DS:[ESI+1]
        SHL EAX,8
        ADD EAX,EBX
        LEA EAX,DWORD PTR DS:[EDI+EAX*2]
        PUSH EAX
        CALL RangeDecoderBitDecode
        ADD EBX,EBX
        OR EBX,EAX
        CMP ESI,EAX
        JNZ @mudff_00D513C1

@mudff_00D513A4:

        CMP EBX,0100h
        JL @mudff_00D51362
        JMP @mudff_00D513C9

@mudff_00D513AE:

        PUSH DWORD PTR SS:[EBP+0Ch]
        LEA ESI,DWORD PTR DS:[EBX+EBX]
        LEA EAX,DWORD PTR DS:[ESI+EDI]
        PUSH EAX
        CALL RangeDecoderBitDecode
        MOV EBX,EAX
        OR EBX,ESI

@mudff_00D513C1:

        CMP EBX,0100h
        JL @mudff_00D513AE

@mudff_00D513C9:

        POP EDI
        POP ESI
        MOV AL,BL
        POP EBX
        POP EBP
        RETN 010h                            ;<= Procedure End


RangeDecoderBitDecode:                       ;<= Procedure Start
; int __stdcall RangeDecoderBitDecode(unsigned __int16 *prob, _CRangeDecoder *rd)
;_RangeDecoderBitDecode@8 proc near

;prob= dword ptr  8
;rd= dword ptr  0Ch
        PUSH EBP                             ; RangeDecoderBitDecode
        MOV EBP,ESP
		PUSH EBX
		PUSH ESI
		PUSH EDI
        MOV EDX,DWORD PTR SS:[EBP+8]
        MOV EBX,DWORD PTR SS:[EBP+0Ch]
        MOVZX ECX,WORD PTR DS:[EDX]
        MOV EDI,DWORD PTR DS:[EBX+8]
        MOV EAX,EDI
        MOV ESI,DWORD PTR DS:[EBX+0Ch]
        SHR EAX,0Bh
        IMUL EAX,ECX
        CMP ESI,EAX
        JNB @mudff_00D51408
        MOV EDI,EAX
        MOV EAX,0800h
        SUB EAX,ECX
        SAR EAX,5
        ADD EAX,ECX
        MOV WORD PTR DS:[EDX],AX
        XOR EAX,EAX
        JMP @mudff_00D5141C

@mudff_00D51408:

        SUB EDI,EAX
        SUB ESI,EAX
        MOV AX,CX
        SHR AX,5
        SUB CX,AX
        XOR EAX,EAX
        MOV WORD PTR DS:[EDX],CX
        INC EAX

@mudff_00D5141C:

        CMP EDI,01000000h
        JNB @mudff_00D51436
        MOV EDX,DWORD PTR DS:[EBX]
        SHL ESI,8
        SHL EDI,8
        MOVZX ECX,BYTE PTR DS:[EDX]
        OR ESI,ECX
        LEA ECX,DWORD PTR DS:[EDX+1]
        MOV DWORD PTR DS:[EBX],ECX

@mudff_00D51436:
        MOV DWORD PTR DS:[EBX+8],EDI
        MOV DWORD PTR DS:[EBX+0Ch],ESI
		POP EDI
        POP ESI
        POP EBX
        POP EBP
        RETN 8                               ;<= Procedure End


RangeDecoderBitTreeDecode:                   ;<= Procedure Start
; int __stdcall RangeDecoderBitTreeDecode(unsigned __int16 *probs, int numLevels, _CRangeDecoder *rd, int reverse_bit)
;_RangeDecoderBitTreeDecode@16 proc near

;probs= dword ptr  8
;numLevels= dword ptr  0Ch
;rd= dword ptr  10h
;reverse_bit= dword ptr 14h
        PUSH EBP                             ; RangeDecoderBitTreeDecode
        MOV EBP,ESP
        PUSH ECX
        PUSH EBX
        PUSH EDI
        XOR EDI,EDI
        XOR EBX,EBX
        INC EDI
        MOV EDX,EDI
        CMP DWORD PTR SS:[EBP+0Ch],EBX
        JLE @mudff_00D5147C
        MOV EDI,EBX
        PUSH ESI

@mudff_00D51458:

        PUSH DWORD PTR SS:[EBP+010h]
        MOV EAX,DWORD PTR SS:[EBP+8]
        LEA ESI,DWORD PTR DS:[EDX+EDX]
        ADD EAX,ESI
        PUSH EAX
        CALL RangeDecoderBitDecode
        MOV ECX,EDI
        LEA EDX,DWORD PTR DS:[ESI+EAX]
        SHL EAX,CL
        OR EBX,EAX
        INC EDI
        CMP EDI,DWORD PTR SS:[EBP+0Ch]
        JL @mudff_00D51458
        XOR EDI,EDI
        INC EDI
        POP ESI

@mudff_00D5147C:

        CMP DWORD PTR SS:[EBP+014h],0
        JE @mudff_00D51486
        MOV EAX,EBX
        JMP @mudff_00D5148F

@mudff_00D51486:

        MOV ECX,DWORD PTR SS:[EBP+0Ch]
        SHL EDI,CL
        SUB EDX,EDI
        MOV EAX,EDX

@mudff_00D5148F:

        POP EDI
        POP EBX
        MOV ESP,EBP
        POP EBP
        RETN 010h                            ;<= Procedure End


RangeDecoderDecodeDirectBits:                ;<= Procedure Start
; unsigned int __stdcall RangeDecoderDecodeDirectBits(_CRangeDecoder *rd, int numTotalBits)
;_RangeDecoderDecodeDirectBits@8 proc near
;rd= dword ptr  8
;numTotalBits= dword ptr  0Ch
        PUSH EBP                             ; RangeDecoderDecodeDirectBits
        MOV EBP,ESP
		PUSH EBX
		PUSH ESI
        PUSH EDI
        MOV EAX,DWORD PTR SS:[EBP+0Ch]
        MOV EBX,DWORD PTR SS:[EBP+8]
        MOV EDX,DWORD PTR DS:[EBX+8]
        MOV ESI,DWORD PTR DS:[EBX+0Ch]
		XOR EDI,EDI
        TEST EAX,EAX
        JE @mudff_00D514DF

@mudff_00D514AF:

        SHR EDX,1
        ADD EDI,EDI
        CMP ESI,EDX
        JB @mudff_00D514BC
        SUB ESI,EDX
        OR EDI,1

@mudff_00D514BC:

        CMP EDX,01000000h
        JNB @mudff_00D514D9
        MOV ECX,DWORD PTR DS:[EBX]
        SHL ESI,8
        SHL EDX,8
        MOVZX EAX,BYTE PTR DS:[ECX]
        OR ESI,EAX
        LEA EAX,DWORD PTR DS:[ECX+1]
        MOV DWORD PTR DS:[EBX],EAX
        MOV EAX,DWORD PTR SS:[EBP+0Ch]

@mudff_00D514D9:

        DEC EAX
        MOV DWORD PTR SS:[EBP+0Ch],EAX
        JNZ @mudff_00D514AF

@mudff_00D514DF:
        MOV DWORD PTR DS:[EBX+0Ch],ESI
        MOV DWORD PTR DS:[EBX+8],EDX
		MOV EAX,EDI
		POP EDI
        POP ESI
        POP EBX
        POP EBP
        RETN 8                               ;<= Procedure End

unpacker_end:
end
