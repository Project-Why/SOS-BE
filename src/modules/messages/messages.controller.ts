import {
  Body,
  Controller,
  Get,
  Ip,
  Param,
  Post,
  Req,
  UsePipes,
} from '@nestjs/common'

import { CodeTransformPipe, isLocal } from '@utils'

import { MessageCreateDto, MessageQueryDto } from '@interfaces'

import { MessagesService } from '@messages/messages.service'

import axios from 'axios'

@Controller('messages')
export class MessagesController {
  constructor(private readonly messagesService: MessagesService) {}

  @Post()
  @UsePipes(new CodeTransformPipe())
  public async create(
    @Ip() ip: string,
    @Body() messageCreateDto: MessageCreateDto,
  ) {
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
      .catch(err => {
        console.log(err)
      })

    return this.messagesService.createMessage(location, messageCreateDto)
  }

  @Get()
  getMessages() {
    return this.messagesService.findAll()
  }

  @Get(':id')
  getMessage(@Param('id') id: string, @Req() messageQueryDto: MessageQueryDto) {
    return this.messagesService.findOne(+id)
  }
}
