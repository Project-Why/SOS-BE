import {
  Body,
  Controller,
  Get,
  Logger,
  Post,
  Req,
  UsePipes,
} from '@nestjs/common'
import { Throttle } from '@nestjs/throttler'

import { isLocal } from '@utils'

import { MessageCreateDto, MessageReadDto } from '@interfaces'

import { responseToRead } from '@messages/message.util'
import { MessagesService } from '@messages/messages.service'

import { CodeTransformPipe } from '@middlewares/code.transform.pipe'
import { IPv4 } from '@middlewares/ip.parameter.decorator'
import axios from 'axios'

@Controller('messages')
export class MessagesController {
  constructor(private readonly messagesService: MessagesService) {}

  @Throttle({
    '1m': { limit: 10, ttl: 6000 },
    '1h': { limit: 20, ttl: 360000 },
  })
  @Post()
  public async create(
    @IPv4() ip: string,
    @Body(new CodeTransformPipe()) messageCreateDto: MessageCreateDto,
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
        new Logger('HTTP').error(error)
      })

    const response = await this.messagesService.createMessage(
      location,
      messageCreateDto,
    )

    return responseToRead(response)
  }

  @Throttle({
    '1m': { limit: 24, ttl: 6000 },
    '1h': { limit: 48, ttl: 360000 },
  })
  @Get()
  async getMessages(): Promise<MessageReadDto[]> {
    const response = await this.messagesService.findMessages()
    return response.map(message => responseToRead(message))
  }
}
