import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
} from '@nestjs/common'

import { MessagesService } from '@messages/messages.service'

@Controller('messages')
export class MessagesController {
  constructor(private readonly messagesService: MessagesService) {}

  @Post()
  create(@Body() createMessageDto: any) {
    return this.messagesService.create()
  }

  @Get()
  findAll() {
    return this.messagesService.findAll()
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.messagesService.findOne(+id)
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateMessageDto: any) {
    return this.messagesService.update(+id)
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.messagesService.remove(+id)
  }
}
