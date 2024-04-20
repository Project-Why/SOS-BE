import { CheckValidText } from '@utils'

import { IsString, Validate } from 'class-validator'

export class MessageCreateDto {
  @IsString()
  @Validate(CheckValidText, {
    message: 'This message cannot be converted to code.',
  })
  message: string
}
