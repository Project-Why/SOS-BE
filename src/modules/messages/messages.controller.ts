import { Body, Controller, Get, Ip, Post, UsePipes } from '@nestjs/common'

import { CodeTransformPipe, isLocal } from '@utils'

import { MessageCreateDto, MessageReadDto } from '@interfaces'

import { MessagesService } from '@messages/messages.service'

import axios from 'axios'

import { responseToRead } from './message.util'

@Controller('messages')
export class MessagesController {
  constructor(private readonly messagesService: MessagesService) {}

  @Post()
  @UsePipes(new CodeTransformPipe())
  public async create(
    @Ip() ip: string,
    @Body() messageCreateDto: MessageCreateDto,
  ): Promise<MessageReadDto> {
    let location: string = 'unknown'

    // For Debug
    const reqIP = isLocal()
      ? `${Math.floor(Math.random() * 255)}.${Math.floor(
          Math.random() * 255,
        )}.${Math.floor(Math.random() * 255)}.${Math.floor(
          Math.random() * 255,
        )}`
      : ip

    await axios
      .get<string>('https://ip2c.org/' + reqIP)
      .then(value => {
        location = value.data.split(';')[2]
      })
      .catch(error => {
        alert(error)
      })

    const response = await this.messagesService.createMessage(
      location,
      messageCreateDto,
    )

    return responseToRead(response)
  }

  @Get()
  async getMessages(): Promise<MessageReadDto[]> {
    const response = await this.messagesService.findMessages()
    return response.map(message => responseToRead(message))
  }
}
