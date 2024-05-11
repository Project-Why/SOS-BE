import { MessageReadDto } from '@interfaces'

import { Message } from '@entities/message.entity'

export function responseToRead(response: Message): MessageReadDto {
  const dto = {} as MessageReadDto
  dto.id = response.id
  dto.createdAt = response.createdAt
  dto.location = response.location
  dto.code = response.code

  return dto
}
