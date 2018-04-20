#include "LzmaDecode.h"

#define kNumTopBits 24
#define kTopValue ((UInt32)1 << kNumTopBits)

#define kNumBitModelTotalBits 11
#define kBitModelTotal (1 << kNumBitModelTotalBits)
#define kNumMoveBits 5

typedef struct _CRangeDecoder
{
  const Byte *Buffer;
  UInt32 Range;
  UInt32 Code;
} CRangeDecoder;

#define ReadByte (*rd->Buffer++) 

#define RC_INIT_VAR UInt32 range = rd->Range; UInt32 code = rd->Code;        
#define RC_FLUSH_VAR rd->Range = range; rd->Code = code;
#define RC_NORMALIZE if (range < kTopValue) { range <<= 8; code = (code << 8) | ReadByte; }



int RangeDecoderBitDecode(CProb *prob, CRangeDecoder *rd)
{
	int bit = 0;
  RC_INIT_VAR
  UInt32 bound = (range >> kNumBitModelTotalBits) * *prob;
  if (code < bound)
  {
    range = bound;
    *prob += (kBitModelTotal - *prob) >> kNumMoveBits;
    bit = 0;
  }
  else
  {
    range -= bound;
    code -= bound;
    *prob -= (*prob) >> kNumMoveBits;
    bit = 1;
  }
   RC_NORMALIZE
   RC_FLUSH_VAR
  return bit;
}
int RangeDecoderBitTreeDecode(CProb *probs, int numLevels, CRangeDecoder *rd, int reverse_bit)
{
  int mi = 1;
  int i;
  int symbol = 0;
  for (i = 0; i < numLevels; i++)
  {
	  int bit = RangeDecoderBitDecode(probs + mi, rd);
	  mi = (mi << 1) + bit;
	  symbol |= (bit << i);
  }
  return reverse_bit ? symbol : mi - (1 << numLevels);
}

#define kNumPosBitsMax 4
#define kNumPosStatesMax (1 << kNumPosBitsMax)

#define kLenNumLowBits 3
#define kLenNumLowSymbols (1 << kLenNumLowBits)
#define kLenNumMidBits 3
#define kLenNumMidSymbols (1 << kLenNumMidBits)
#define kLenNumHighBits 8
#define kLenNumHighSymbols (1 << kLenNumHighBits)

#define LenChoice 0
#define LenChoice2 (LenChoice + 1)
#define LenLow (LenChoice2 + 1)
#define LenMid (LenLow + (kNumPosStatesMax << kLenNumLowBits))
#define LenHigh (LenMid + (kNumPosStatesMax << kLenNumMidBits))
#define kNumLenProbs (LenHigh + kLenNumHighSymbols) 

int LzmaLenDecode(CProb *p, CRangeDecoder *rd, int posState)
{
  if(RangeDecoderBitDecode(p + LenChoice, rd) == 0)
    return RangeDecoderBitTreeDecode(p + LenLow +
        (posState << kLenNumLowBits), kLenNumLowBits, rd,0);
  if(RangeDecoderBitDecode(p + LenChoice2, rd) == 0)
    return kLenNumLowSymbols + RangeDecoderBitTreeDecode(p + LenMid +
        (posState << kLenNumMidBits), kLenNumMidBits, rd,0);
  return kLenNumLowSymbols + kLenNumMidSymbols + 
      RangeDecoderBitTreeDecode(p + LenHigh, kLenNumHighBits, rd,0);
}

#define kNumStates 12
#define kNumLitStates 7

#define kStartPosModelIndex 4
#define kEndPosModelIndex 14
#define kNumFullDistances (1 << (kEndPosModelIndex >> 1))

#define kNumPosSlotBits 6
#define kNumLenToPosStates 4

#define kNumAlignBits 4
#define kAlignTableSize (1 << kNumAlignBits)

#define kMatchMinLen 2

#define IsMatch 0
#define IsRep (IsMatch + (kNumStates << kNumPosBitsMax))
#define IsRepG0 (IsRep + kNumStates)
#define IsRepG1 (IsRepG0 + kNumStates)
#define IsRepG2 (IsRepG1 + kNumStates)
#define IsRep0Long (IsRepG2 + kNumStates)
#define PosSlot (IsRep0Long + (kNumStates << kNumPosBitsMax))
#define SpecPos (PosSlot + (kNumLenToPosStates << kNumPosSlotBits))
#define Align (SpecPos + kNumFullDistances - kEndPosModelIndex)
#define LenCoder (Align + kAlignTableSize)
#define RepLenCoder (LenCoder + kNumLenProbs)
#define Literal (RepLenCoder + kNumLenProbs)
#define numProbs 198454

#if Literal != LZMA_BASE_SIZE
StopCompilingDueBUG
#endif


#define lc (8)
#define posStateMask ((1 << (2)) - 1)
#define literalPosMask ((1 << (0)) - 1)



void LzmaDecode(unsigned short* workmem_p,
    const unsigned char *inStream,
    unsigned char *outStream, SizeT outSize)
{
  SizeT nowPos = 0;
  Byte previousByte = 0;
  CRangeDecoder rd;
  UInt32 rep0 = 1, rep1 = 1, rep2 = 1, rep3 = 1;
  int len;
  int distance_posslot;
  int iter_state;
  rd.Buffer = inStream;
  rd.Code = 0;
  rd.Range = (0xFFFFFFFF);
  for (iter_state = 0; iter_state < numProbs; iter_state++)
  {
	  if(iter_state < 5)rd.Code = (rd.Code << 8) | (*rd.Buffer++);
	  workmem_p[iter_state] = kBitModelTotal >> 1;
  }
  iter_state=0;

  while(nowPos < outSize)
  {
	if (RangeDecoderBitDecode(workmem_p + IsMatch + (iter_state << kNumPosBitsMax) + (nowPos& posStateMask), &rd) == 0)
    {
      CProb *probs = workmem_p + Literal + (LZMA_LIT_SIZE * 
        (((
        (nowPos 
        )
        & literalPosMask) << lc) + (previousByte >> (8 - lc))));

	  int bit;
	  Byte matchByte = (iter_state >= kNumLitStates) ? outStream[nowPos - rep0] : 0;
	  distance_posslot = 1;
	  if ((iter_state < kNumLitStates))goto symbol_dec;
	  while (distance_posslot < 0x100)
	  {
		  {
			  int matchBit = (matchByte >> 7) & 1;
			  matchByte <<= 1;

			  bit = RangeDecoderBitDecode(probs + 0x100 + (matchBit << 8) + distance_posslot, &rd);
			  distance_posslot = (distance_posslot << 1) | bit;
			  if (matchBit != bit)
			  {
			  symbol_dec:
				  while (distance_posslot < 0x100) {
					  distance_posslot = (distance_posslot << 1) | RangeDecoderBitDecode(probs + distance_posslot, &rd);
				  }
				  break;
			  }
		  }
	  }
	  previousByte = distance_posslot;
      outStream[nowPos++] = previousByte;
      if (iter_state < 4) iter_state = 0;
      else if (iter_state < 10) iter_state -= 3;
      else iter_state -= 6;
    }
    else             
    {
      if (RangeDecoderBitDecode(workmem_p + IsRep + iter_state, &rd) == 1)
      {
        if (RangeDecoderBitDecode(workmem_p + IsRepG0 + iter_state, &rd) == 0)
        {
			if (RangeDecoderBitDecode(workmem_p + IsRep0Long + (iter_state << kNumPosBitsMax) + (nowPos& posStateMask), &rd) == 0)
          {
            iter_state = iter_state < 7 ? 9 : 11;
            previousByte = outStream[nowPos - rep0];
            outStream[nowPos++] = previousByte;
            continue;
          }
        }
        else
        {
         
          if(RangeDecoderBitDecode(workmem_p + IsRepG1 + iter_state, &rd) == 0)
              distance_posslot = rep1;
          else 
          {
            if(RangeDecoderBitDecode(workmem_p + IsRepG2 + iter_state, &rd) == 0)
                distance_posslot = rep2;
            else
            {
                distance_posslot = rep3;
              rep3 = rep2;
            }
            rep2 = rep1;
          }
          rep1 = rep0;
          rep0 = distance_posslot;
        }
		len = LzmaLenDecode(workmem_p + RepLenCoder, &rd, (nowPos& posStateMask));
        iter_state = iter_state < 7 ? 8 : 11;
      }
      else
      {
       
        rep3 = rep2;
        rep2 = rep1;
        rep1 = rep0;
        iter_state = iter_state < 7 ? 7 : 10;
		len = LzmaLenDecode(workmem_p + LenCoder, &rd, (nowPos& posStateMask));
        distance_posslot = RangeDecoderBitTreeDecode(workmem_p + PosSlot +
            ((len < kNumLenToPosStates ? len : kNumLenToPosStates - 1) << 
            kNumPosSlotBits), kNumPosSlotBits, &rd,0);
        if (distance_posslot >= kStartPosModelIndex)
        {
          int numDirectBits = ((distance_posslot >> 1) - 1);
          rep0 = ((2 | ((UInt32)distance_posslot & 1)) << numDirectBits);
          if (distance_posslot < kEndPosModelIndex)
          {
			  rep0 += RangeDecoderBitTreeDecode(
                workmem_p + SpecPos + rep0 - distance_posslot - 1, numDirectBits, &rd,1);
          }
          else
          {

			  distance_posslot = 0;
				  numDirectBits -= kNumAlignBits;
				  do
				  { /* L440 */
					  rd.Range >>= 1;
					  distance_posslot <<= 1;
					  if (rd.Code >= rd.Range)
					  {
						  rd.Code -= rd.Range;
						  distance_posslot |= 1;
					  }
					  if (rd.Range < kTopValue) { rd.Range <<= 8; rd.Code = (rd.Code << 8) | (*rd.Buffer++); }
				  } while (--numDirectBits != 0);
			rep0+=(distance_posslot << kNumAlignBits);
			rep0 += RangeDecoderBitTreeDecode(workmem_p + Align, kNumAlignBits, &rd,1);
          }
        }
        else
          rep0 = distance_posslot;
		 ++rep0;
      }
      len += kMatchMinLen;
      
	  do
      {    
		previousByte = outStream[nowPos - rep0];
        len--;
       outStream[nowPos++] = previousByte;
      }
	  while (len != 0);
    }
  }
}