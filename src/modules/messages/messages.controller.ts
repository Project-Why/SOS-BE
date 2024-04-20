import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Req,
  UsePipes,
} from '@nestjs/common'

import { CodeTransformPipe } from '@utils'

import { MessageCreateDto, MessageQueryDto } from '@interfaces'

import { MessagesService } from '@messages/messages.service'

@Controller('messages')
export class MessagesController {
  constructor(private readonly messagesService: MessagesService) {}

  @Post()
  @UsePipes(new CodeTransformPipe())
  public async create(@Body() messageCreateDto: MessageCreateDto) {
    return this.messagesService.createMessage(messageCreateDto)
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
