import { PipeTransform } from '@nestjs/common'

import { alphabet, hanguel, morseCode, sign } from '@utils'

import { MessageCreateDto } from '@interfaces'

export class CodeTransformPipe
  implements PipeTransform<MessageCreateDto, MessageCreateDto>
{
  transform(value: MessageCreateDto) {
    return { message: this.convertTextToCode(value.message) }
  }
  private convertTextToCode(text: string) {
    let result = ''
    for (let char of text) {
      if (alphabet.test(char)) {
        result += morseCode[char.toLowerCase()] + ' '
      } else if (sign.test(char)) {
        result += morseCode[char] + ' '
      } else if (hanguel.test(char)) {
        const INITIAL_CONSONANTS = [
          'ㄱ',
          'ㄲ',
          'ㄴ',
          'ㄷ',
          'ㄸ',
          'ㄹ',
          'ㅁ',
          'ㅂ',
          'ㅃ',
          'ㅅ',
          'ㅆ',
          'ㅇ',
          'ㅈ',
          'ㅉ',
          'ㅊ',
          'ㅋ',
          'ㅌ',
          'ㅍ',
          'ㅎ',
        ]
        const MEDIAL_VOWELS = [
          'ㅏ',
          'ㅐ',
          'ㅑ',
          'ㅒ',
          'ㅓ',
          'ㅔ',
          'ㅕ',
          'ㅖ',
          'ㅗ',
          'ㅘ',
          'ㅙ',
          'ㅚ',
          'ㅛ',
          'ㅜ',
          'ㅝ',
          'ㅞ',
          'ㅟ',
          'ㅠ',
          'ㅡ',
          'ㅢ',
          'ㅣ',
        ]
        const FINAL_CONSONANTS = [
          '',
          'ㄱ',
          'ㄲ',
          'ㄳ',
          'ㄴ',
          'ㄵ',
          'ㄶ',
          'ㄷ',
          'ㄹ',
          'ㄺ',
          'ㄻ',
          'ㄼ',
          'ㄽ',
          'ㄾ',
          'ㄿ',
          'ㅀ',
          'ㅁ',
          'ㅂ',
          'ㅄ',
          'ㅅ',
          'ㅆ',
          'ㅇ',
          'ㅈ',
          'ㅊ',
          'ㅋ',
          'ㅌ',
          'ㅍ',
          'ㅎ',
        ]
        const charCode = char.charCodeAt(0)
        const unicodeOffset = 44032
        const syllableIndex = charCode - unicodeOffset
        const initialIndex = Math.floor(syllableIndex / (21 * 28))
        const medialIndex = Math.floor((syllableIndex % (21 * 28)) / 28)
        const finalIndex = syllableIndex % 28

        if (initialIndex >= 0 && initialIndex < INITIAL_CONSONANTS.length) {
          result += morseCode[INITIAL_CONSONANTS[initialIndex]] + ' '
        }
        if (medialIndex >= 0 && medialIndex < MEDIAL_VOWELS.length) {
          result += morseCode[MEDIAL_VOWELS[medialIndex]] + ' '
        }
        if (finalIndex > 0 && finalIndex < FINAL_CONSONANTS.length) {
          result += morseCode[FINAL_CONSONANTS[finalIndex]] + ' '
        }
      }
    }
    return result.trim()
  }
}
