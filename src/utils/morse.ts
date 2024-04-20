import { PipeTransform } from '@nestjs/common'

import { MessageCreateDto } from '@interfaces'

import {
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator'

@ValidatorConstraint()
export class CheckValidText implements ValidatorConstraintInterface {
  validate(text: string) {
    return this.isValidByte(text) && this.isValidCharacter(text)
  }
  private isValidCharacter(text: string): boolean {
    const allowedCharacters = /^[A-Za-z0-9 ,:?'–/()"=+×@ㄱ-ㅎ가-힣ㅏ-ㅣéÉ\n]*$/
    return allowedCharacters.test(text)
  }
  private isValidByte(text: string): boolean {
    const byteLength = new TextEncoder().encode(text).length
    return byteLength <= 150
  }
}

export class CodeTransformPipe
  implements PipeTransform<MessageCreateDto, MessageCreateDto>
{
  transform(value: MessageCreateDto) {
    return { message: this.convertTextToCode(value.message) }
  }
  private convertTextToCode(text: string) {
    const morseCode = {
      'a': '.-',
      'b': '-...',
      'c': '-.-.',
      'd': '-..',
      'e': '.',
      'é': '..',
      'É': '..',
      'f': '..-.',
      'g': '--.',
      'h': '....',
      'i': '..',
      'j': '.---',
      'k': '-.-',
      'l': '.-..',
      'm': '--',
      'n': '-.',
      'o': '---',
      'p': '.--.',
      'q': '--.-',
      'r': '.-.',
      's': '...',
      't': '-',
      'u': '..-',
      'v': '...-',
      'w': '.--',
      'x': '-..-',
      'y': '-.--',
      'z': '--..',
      '1': '.----',
      '2': '..---',
      '3': '...--',
      '4': '....-',
      '5': '.....',
      '6': '-....',
      '7': '--...',
      '8': '---..',
      '9': '----.',
      '0': '-----',
      ',': '--..--',
      ':': '---...',
      '?': '..--..',
      "'": '.----.',
      '-': '-....-',
      '/': '-..-.',
      '(': '-.--.',
      ')': '-.--.-',
      '"': '.-..-.',
      '=': '-...-',
      '+': '.-.-.',
      '×': '-..-',
      '@': '.--.-.',
      'ㄱ': '......',
      'ㄴ': '.....-',
      'ㄷ': '....-.',
      'ㄹ': '....--',
      'ㅁ': '...-..',
      'ㅂ': '...--.',
      'ㅅ': '...---',
      'ㅇ': '..-...',
      'ㅈ': '..-..-',
      'ㅊ': '..-.-.',
      'ㅋ': '..-.--',
      'ㅌ': '..--.-',
      'ㅍ': '..---.',
      'ㅎ': '..----',
      'ㄲ': '.-....',
      'ㄸ': '.-...-',
      'ㅃ': '.-..--',
      'ㅆ': '.-.-..',
      'ㅉ': '.-.--.',
      'ㄳ': '.-.---',
      'ㄵ': '.--...',
      'ㄶ': '.--..-',
      'ㄺ': '.--.--',
      'ㄻ': '.---..',
      'ㄼ': '.---.-',
      'ㄽ': '.-----',
      'ㄾ': '---..-',
      'ㄿ': '---.-.',
      'ㅀ': '---.--',
      'ㅄ': '----..',
      'ㅏ': '-.....',
      'ㅑ': '-...-.',
      'ㅓ': '-...--',
      'ㅕ': '-..-..',
      'ㅗ': '-..-.-',
      'ㅛ': '-..--.',
      'ㅜ': '-..---',
      'ㅠ': '-.-...',
      'ㅡ': '-.-..-',
      'ㅣ': '-.-.-.',
      'ㅐ': '-.-.--',
      'ㅒ': '-.--..',
      'ㅔ': '-.---.',
      'ㅖ': '-.----',
      'ㅘ': '--....',
      'ㅙ': '--...-',
      'ㅚ': '--..-.',
      'ㅝ': '--.-..',
      'ㅞ': '--.-.-',
      'ㅟ': '--.--.',
      'ㅢ': '--.---',
      ' ': '',
      '\n': '',
    }
    const alphabet = /^[A-Za-z]*$/
    const sign = /^[0-9,:?'–/()"=+×@ㄱ-ㅎㅏ-ㅣéÉ]*$/
    const hanguel = /^[가-힣]*$/

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
